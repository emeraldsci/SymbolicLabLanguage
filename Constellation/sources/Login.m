(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

OnLoad[
	General::NotLoggedIn="Not logged in.";
	Global`$ConstellationDomain=If[ValueQ[Global`$ConstellationDomain],
		Global`$ConstellationDomain,
		ConstellationDomain[Production]
	]
];



(* ::Section:: *)
(*Code*)


(* ::Subsection::Closed:: *)
(*Helper Functions (JWT and Reponse Parsing)*)


(* AuthenticationDialog works on cloud, desktop, and WolframScript, also supports oAuth *)
getFormResults[formType_String, domain_String]:=AuthenticationDialog[formType,
	WindowTitle -> "Login",
	AppearanceRules -> {
		"Title" -> "Constellation",
		"Description" -> domain
	}
];

jwtFilePath[domain_String]:=FileNameJoin@{getAppDirectory["SLL"], EncodeURIComponent[domain]<>".jwt"};
jwtFilePath[___]:=$Failed;

clearJwtFile[domain_String]:=Module[
	{jwtFile},
	jwtFile=jwtFilePath[domain];
	If[FileExistsQ[jwtFile],
		DeleteFile[jwtFilePath[domain]]
	]
];
clearJwtFile[___]:=Null;

saveJwtFile[token_String, domain_String, email_String]:=Export[jwtFilePath[domain], <|"token" -> token, "email" -> email|>, {"RawJSON"}];

loadJwtFile[domain_String]:=Module[
	{jwtFile, jwtData},
	jwtFile=jwtFilePath[domain];
	If[Not[FileExistsQ[jwtFile]],
		Return[$Failed]
	];
	Import[jwtFile, {"RawJSON"}]
];
loadJwtFile[___]:=$Failed;

(* something like getAppWorkingDirectory() in JavaScript *)
getAppDirectory[app_String]:=Module[
	{dir},
	dir=Switch[$OperatingSystem,
		"Mac", FileNameJoin@{$HomeDirectory, "Library", "ECL", app},
		"Windows", FileNameJoin@{$HomeDirectory, "AppData", "Roaming", "ECL", app},
		_, FileNameJoin@{$HomeDirectory, ".local", "share", "ECL", app}
	];

	If[DirectoryQ[dir],
		dir,
		CreateDirectory[dir, CreateIntermediateDirectories -> True]
	]
];

domainChangePromptApproved[targetDomain_String]:=Module[
	{},
	If[(targetDomain =!= Global`$ConstellationDomain) && loggedInQ[],
		(* warn before logging in to a new domain *)
		ChoiceDialog[
			StringForm[
				"Are you sure you want to switch from `1` to `2`?",
				simplifyDomainName[Global`$ConstellationDomain],
				simplifyDomainName[targetDomain]
			],
			{
				"Proceed to login" -> True,
				"Cancel" -> $Failed
			},
			WindowTitle -> "Changing Constellation domain!"
		],
		(* otherwise we're logged out and trying to login, so proceed *)
		True
	]
];

simplifyDomainName[domain_String]:=Replace[domain, {
	_?testDomainQ -> Test,
	_?productionDomainQ -> Production
}];

handleLoginResponse[response_Association, remember:True | False, email_String]:=Module[
	{error=Lookup[response, "Error"], domain=Lookup[response, "Domain"]},

	$PersonID=Null;
	clearCache[];
	If[error =!= "",
		Message[Login::Server, error];
		Return[$Failed];
	];

	Global`$ConstellationDomain=domain;


	If[Not[Lookup[response, "Success"]],
		GoLink`Private`stashedJwt=Null;
		GoLink`Private`stashedDomain=Null;
		Message[Login::NotLoggedIn];
		Return[$Failed]
	];

	(* Stash the jwt with goLink so it can log back in automatically on link reset. *)
	GoLink`Private`stashedJwt=GoCall["GetJWT"];
	GoLink`Private`stashedDomain=domain;

	(* Use the stashed login creds to update the secondary telescope's login credentials. *)
	(* If AsynchronousUpload has not yet been initialized (and therefore the secondary telescope not yet spawned,
	   then next two lines will simply returned unevaluated.*)
	GoLink`Private`TelescopeRead[];  (*<-- First wait for all asynchronous uploads to finish*)
	GoLink`Private`TelescopeLoginJWT[<|"Domain"->GoLink`Private`stashedDomain, "Token"->GoLink`Private`stashedJwt|>];


	If[remember,
		saveJwtFile[GoLink`Private`stashedJwt, GoLink`Private`stashedDomain, email]
	];
	$PersonID=Append[stringToType[Lookup[response, "Type"]], Lookup[response, "UserId"]];
	If[And[!productionDomainQ[domain], noisyLogin],
		Print[
			Style["Your session is not against the production Object Store, but is using "<>domain,
				FontColor -> Red, FontSize -> 20, FontWeight -> "Bold"
			]
		]
	];

	(* set the site for the employees to know where they work at *)
	If[MatchQ[$PersonID,ObjectP[Object[User,Emerald]]],
		With[{defaultUserSite=Download[$PersonID,ECL`Site[Object]]},
			If[!NullQ[defaultUserSite],
				Unprotect[ECL`$Site];
				ECL`$Site=defaultUserSite;
				Protect[ECL`$Site];
			];

			(* only change $OutputNamedObjects if we're a superuser *)
			Unprotect[ECL`$OutputNamedObjects];
			ECL`$OutputNamedObjects=False;
			Protect[ECL`$OutputNamedObjects];
		],
		With[{financingTeamDefaultSites=Download[$PersonID, ECL`FinancingTeams[ECL`DefaultExperimentSite][Object]]},
			If[MemberQ[financingTeamDefaultSites,ObjectP[]],
				Unprotect[ECL`$Site];
				ECL`$Site=FirstCase[financingTeamDefaultSites,ObjectP[]];
				Protect[ECL`$Site];
			];

			(* set to True if we're not a superuser *)
			Unprotect[ECL`$OutputNamedObjects];
			ECL`$OutputNamedObjects=True;
			Protect[ECL`$OutputNamedObjects];
		]
	];

	Global`$ConstellationVersion=ConstellationVersion[];

	If[testDomainQ[domain],
		ConnectToTrace["Stage"];
	];

	(* Turn on tracing in Production for Engine only *)
	If[MatchQ[domain, "https://engine.emeraldcloudlab.com"],
		ConnectToTrace["Production"];
	];

	(* 
		log some details about loading and building (if it happened)
		these use TraceExpression so can't run it until logged in
		it memoizes so will only evaluate during first login of a session
	*)
	Packager`Private`logLoadDetails[];
	Archive`Private`logBuildDetails[];

	True
];

productionDomainQ[domain_String]:=MemberQ[productionObjStoreURLs, domain];
testDomainQ[domain_String]:=MemberQ[testObjStoreURLs, domain];



(* ::Subsection::Closed:: *)
(*Login*)


DefineOptions[Login,
	Options :> {
		{Database :> Global`$ConstellationDomain, Test | Production | Stage | Ops | _String, "The name or URL of the database."},
		{Email -> "", _String, "The email address for a user account.  By default, when prompting, prompt with an empty address."},
		{Token -> None, None | _String, "A JWT token derived from a previous successful login. If given, no prompt will occur."},
		{Remember -> False, True | False, "When True, tokens will be saved so future login attempts can skip prompting."},
		{QuietDomainChange -> False, True | False, "When True, no prompt will be given when changing from an already logged in domain."}
	}
];
Login::Server="`1`";

(* Pulled out for easy stubbing *)
doLogin[username_String, password_String, domain_String]:=GoCall["Login",
	<|"Username" -> username, "Password" -> password, "Domain" -> domain|>];

doJwtLogin[token_String, domain_String]:=GoCall["LoginJWT",
	<|"Domain" -> domain, "Token" -> token|>];

loginUsernamePassword[username_String, password_String, domain_String, remember:True | False]:=
	handleLoginResponse[doLogin[username, password, domain], remember, username];

loggedInQ[]:=With[{jwt=GoCall["GetJWT"]}, StringQ[jwt] && jwt =!= ""];

(* Takes username/password *)
Login[username_String, password_String, ops:OptionsPattern[]]:=TraceExpression["Login",Module[
	{safeOps, domain, quietDomainChange},
	safeOps=ECL`OptionsHandling`SafeOptions[Login, ToList[ops], ECL`OptionsHandling`AutoCorrect->False];

	(* Return $Failed if options could not be defaulted *)
	If[MatchQ[safeOps, $Failed],
		Return[$Failed]
	];

	domain=ConstellationDomain[Lookup[safeOps, Database]];
	quietDomainChange=Lookup[safeOps, QuietDomainChange];

	If[Not[quietDomainChange] && domainChangePromptApproved[domain] =!= True,
		Return[$Failed]
	];

	loginUsernamePassword[username, password, domain, Lookup[safeOps, Remember]]
]];

Login[username_String, ops:OptionsPattern[]]:=Login[Email -> username, ops];

(*Pops up an inline form to enter username/password*)
Login[ops:OptionsPattern[]]:=TraceExpression["Login",Module[
	{safeOps, domain, quietDomainChange, remember, newEmail, newToken, jwtData, oldToken, reLogin, formResults, matchingEmail, oldEmail},
	safeOps=ECL`OptionsHandling`SafeOptions[Login, ToList[ops], ECL`OptionsHandling`AutoCorrect->False];

	(* Return $Failed if options could not be defaulted *)
	If[MatchQ[safeOps, $Failed],
		Return[$Failed]
	];

	domain=ConstellationDomain[Lookup[safeOps, Database]];
	quietDomainChange=Lookup[safeOps, QuietDomainChange];
	remember=Lookup[safeOps, Remember];
	newEmail=Lookup[safeOps, Email];

	If[Not[quietDomainChange] && domainChangePromptApproved[domain] =!= True,
		Return[$Failed]
	];

	(* if given a token directly, use it to login (or fail hard) *)
	newToken=Lookup[safeOps, Token];
	If[StringQ[newToken],
		Return[handleLoginResponse[doJwtLogin[newToken, domain], remember, newEmail]]
	];

	(* drop old tokens if we're not remembering *)
	If[Not[remember],
		clearJwtFile[domain]
	];

	(* look for previous tokens on file *)
	jwtData=loadJwtFile[domain];
	If[MatchQ[jwtData, _Association],
		oldEmail=Lookup[jwtData, "email", $Failed];
		oldToken=Lookup[jwtData, "token", $Failed],
		oldEmail=$Failed;
		oldToken=$Failed
	];

	(* see if previous token email is the one we want (or if we don't mind anything) *)
	matchingEmail=If[newEmail === "",
		(* if we just have a default email, accept anybody's token *)
		True,
		(* otherwise, check *)
		newEmail === oldEmail
	];

	(* If we can, just use the old token to login *)
	If[matchingEmail && StringQ[oldToken],
		reLogin=Quiet[Login[Normal@Append[Association@ops, {Token -> oldToken, QuietDomainChange -> True (* already prompted *)}]]];
		If[reLogin === True,
			(* yay we logged in with the old token *)
			Return[reLogin],
			(* welp, that token seems to be expired *)
			clearJwtFile[domain]
		]
	];

	(* Otherwise, prompt for a password using appropriate authentication for current enviornment *)
	If[newEmail === "",
		(* email was not provided, full prompt *)
		formResults=getFormResults["UsernamePassword", domain],

		(* Else email provided, just get Password from user *)
		formResults=getFormResults["Password", domain];
		formResults["Username"]=newEmail
	];

	(* return the $Canceled if the user canceled the login session*)
	If[formResults === $Canceled,
		Return[formResults]
	];
	loginUsernamePassword[formResults["Username"], formResults["Password"], domain, remember]
]];

(* ::Subsection::Closed:: *)
(*ManifoldLogin*)
DefineOptions[ManifoldLogin,
	Options :> {
		{Database :> Global`$ConstellationDomain, Test | Production | Stage | Ops | _String, "The name or URL of the database."},
		{Token -> None, None | _String, "A JWT token derived from a previous successful login. If given, no prompt will occur."},
		{QuietDomainChange -> False, True | False, "When True, no prompt will be given when changing from an already logged in domain."},
		{LoginAttemptNumber -> 1, _Integer, "Number of times user has attempted to login."},
		{MaxAttempts -> 5, _Integer, "Maximum number of attempts before exiting."}
	}];

ManifoldLogin[token_String, ops:OptionsPattern[]] := Module[
	{
		safeOps, domain, quietDomainChange, remember, email,
		loginAttemptNumber, maxAttempts,
		response, success,
		pauseValue
	},
	safeOps=ECL`OptionsHandling`SafeOptions[ManifoldLogin, ToList[ops], ECL`OptionsHandling`AutoCorrect->False];

	(* Return $Failed if options could not be defaulted *)
	If[MatchQ[safeOps, $Failed],
		Return[$Failed]
	];

	(* Set defaults for handleLoginResponse arguments. *)
	remember = False;
	email = "";

	(* Domain check. *)
	domain=ConstellationDomain[Lookup[safeOps, Database]];
	quietDomainChange=Lookup[safeOps, QuietDomainChange];
	If[Not[quietDomainChange] && domainChangePromptApproved[domain] =!= True,
		Return[$Failed]
	];

	(* Parse optional args. *)
	loginAttemptNumber = Lookup[safeOps, LoginAttemptNumber];
	maxAttempts = Lookup[safeOps, MaxAttempts];

	(* Login with token. If failed, increment loginAttemptNumber and retry if attempts remaining.*)
	response = doJwtLogin[token, domain];
	success = Lookup[response, "Success"];

	Which[
		(* Failed login, attempts remaining. *)
		MatchQ[success, False] && loginAttemptNumber < maxAttempts,
		(
			(* Increment loginAttemptNumber. *)
			loginAttemptNumber += 1;
			(* Wait before next login attempt.*)
			pauseValue = getPauseValue[loginAttemptNumber];
			Pause[pauseValue];
			(* Recall ManifoldLogin (with Return[] for proper error propagation). *)
			ManifoldLogin[token, LoginAttemptNumber->loginAttemptNumber, MaxAttempts->maxAttempts]
		),

		(* Failed login, max attempts reached. *)
		MatchQ[success, False] && loginAttemptNumber >= maxAttempts,
		(
			(* Change Status to error and Add Error message. *)
			Upload[
				<|
					Object -> Download[$ManifoldComputation, Object],
					Status -> Error,
					ErrorMessage -> "There was a problem initializing your Manifold job. Please resubmit the job again in a few minutes."
				|>
			];
			(* Return $Failed *)
			handleLoginResponse[response, remember, email]
		),

		(* Successful login. *)
		(* Written as catch-all else-like condition. *)
		True,
		handleLoginResponse[response, remember, email]
	]
];

getPauseValue[loginAttemptNumber_Integer] := Module[{pauseValueFunction, xin},
	(*
	Helper function used to determine wait time between failed login attempts.
	Specifically, choosing random-ish exponentially growing wait times to avoid thundering herd style problem which
	causes system failure if too many machines attempt something (i.e. logins) at same time.
	*)

	(* Define function used to generate pause values *)
	(* Sample Wait Times: 0->2., 1->5.43656, 2->14.7781, 3->40.1711, 4->109.196, 5->296.826 *)
	pauseValueFunction = Function[x, N[2*E^(x)]];

	(* Set upper limit on input to function to avoid excessively long wait times between attempts. *)
	xin = If[loginAttemptNumber > 5, 5, loginAttemptNumber];
	pauseValueFunction[xin+RandomReal[{-1,1}]]
];


(* ::Subsection::Closed:: *)
(* ConstellationVersion *)
ConstellationVersion[]:=Module[
	{response, error, version},
	response=ConstellationRequest[
		Association[
			"Path" -> "obj/version",
			"Method" -> "GET",
			"Timeout" -> 360000
		],
		Retries -> 4,
		RetryMode -> Read
	];
	error=Lookup[response, "Error", ""];
	If[error =!= "",
		Return[$Failed];
	];

	version=Lookup[response, "constellation-version", Null];
	If[version == Null, Return[$Failed]];
	version
];

versionGreaterThanOrEqualTo[version_String]:=Module[{currentVersionAsList, versionToCheckAsList, versionComparisons},
	versionToCheckAsList=ToString /@ StringSplit[version, "."];
	currentVersionAsList=ToString /@ StringSplit[Global`$ConstellationVersion, "."];

	versionComparisons=MapThread[GreaterThan, {currentVersionAsList, versionToCheckAsList}];
	(* if any of the comparisons are false, ensure that *)
];

(* ::Subsection::Closed:: *)
(*Logout*)


Logout[]:=Module[
	{response, error},

	clearJwtFile[GoLink`Private`stashedDomain];

	GoLink`Private`stashedJwt=Null;
	GoLink`Private`stashedDomain=Null;
	$PersonID=Null;
	response=GoCall["Logout"];
	error=Lookup[response, "Error"];

	If[error =!= "",
		Message[Logout::Server, error];
		Return[$Failed];
	];

	If[Lookup[response, "Success"],
		True,
		(
			Message[Logout::NotLoggedIn];
			$Failed
		)
	]
];
Logout::Server="`1`";

(*
		apiUrl: Helper function for generating correct URL based on configured basfe URL and
		api endpoint
*)
defaultProdURL="https://constellation.emeraldcloudlab.com";
defaultTestURL="https://constellation-stage.emeraldcloudlab.com";
defaultPlatformURL="https://constellation-platform.emeraldcloudlab.com";

productionObjStoreURLs={
	defaultProdURL,
	"https://cc.emeraldcloudlab.com",
	"https://engine.emeraldcloudlab.com",
	"https://nexus.emeraldcloudlab.com"
};

testObjStoreURLs={
	defaultTestURL,
	"https://cc-stage.emeraldcloudlab.com",
	"https://engine-stage.emeraldcloudlab.com"
};

ProductionQ[]:=MemberQ[Constellation`Private`productionObjStoreURLs, Global`$ConstellationDomain];

noisyLogin=True;
ConstellationDomain[domain:_String]:=domain;
ConstellationDomain[Production]:=defaultProdURL;
ConstellationDomain[Test]:=defaultTestURL;
ConstellationDomain[Stage]:=defaultTestURL;
ConstellationDomain[Platform]:=defaultPlatformURL;


(* ::Subsection:: *)
(*AssumeIdentity (Private function)*)

(* Contains stack of previously assumed identity JWTs so that you can rollback to them if required *)
stashedJwtStack={};

Error::AssumeIdentityNotAllowed="The identity of another constellation user can only be assumed if you logged in as an Object[User,Emerald,Operator] or Object[User,Emerald,Developer]. Only identities of non superusers can be assumed.";
Error::AssumeIdentityBadUser="The user `1` is not a valid constellation user. Please give a valid user to assume the identity of.";
Error::AssumeIdentityUnknownError="An unknown backend error occurred when assuming the identity of `1`.";

DefineOptions[AssumeIdentity,
	Options :> {
		(* Be careful not to set this to true if user code will run after the assume identity, as the user can then rollback to the super user *)
		{AllowRollback -> False, True | False, "If True, you may call RollbackAssumeIdentity to return to the user prior to calling to AssumeIdentity.  Do not set to true if user code will be executed after calling AssumeIdentity."}
	}
];

(* Note: We can't use ObjectP[...] because we're in the Constellation package before the types have loaded. *)
AssumeIdentity[myUser_, ops:OptionsPattern[]]:=Module[
	{safeOps, response, allowRollback},

	safeOps=ECL`OptionsHandling`SafeOptions[AssumeIdentity, ToList[ops], ECL`OptionsHandling`AutoCorrect->False];

	(* Return $Failed if options could not be defaulted *)
	If[MatchQ[safeOps, $Failed],
		Return[$Failed]
	];

	(* Grab whether or not allow rollback option was set *)
	allowRollback=Lookup[safeOps, AllowRollback];

	(* Call the assume identity endpoint to step down to another user. *)
	(* Note: ConstellationRequest will automatically send the token that we have saved from out previous login. *)
	response=ConstellationRequest[<|
		"Path" -> apiUrl["AssumeIdentity"],
		"Body" -> ExportJSON[<|
			"userIdToAssume" -> Download[myUser, ID]
		|>],
		"Method" -> "POST"
	|>];

	(* Look at the status code we got back. Throw an error if we got an error. *)
	If[!MatchQ[Lookup[response, "StatusCode"], 0],
		(* Throw an error. *)
		Switch[Lookup[response, "StatusCode"],
			1,
			Message[Error::AssumeIdentityNotAllowed],
			2,
			Message[Error::AssumeIdentityBadUser, ToString[myUser, InputForm]],
			_,
			Message[Error::AssumeIdentityUnknownError, ToString[myUser, InputForm]]
		];

		Return[$Failed];
	];

	(* If allowRollback option is True, then remember the current auth token before assigning the new auth token *)
	If[allowRollback,
		PrependTo[stashedJwtStack, {$PersonID, GoLink`Private`stashedJwt}];
	];

	(* When we logged in, our JWT got saved to the following local variable and may have gotten stored in a file. Clear them so that the stepped down user can't steal them. *)
	(* When we login in engine, the JWT gets stored in the local javascript kernel so the operator doesn't have to re-login, even if we clear these variables. *)
	clearJwtFile[GoLink`Private`stashedDomain];

	(* Note: We do not reset our stashed domain because we assume that we never change the domain (this should only happen on production). *)
	GoLink`Private`stashedJwt=Lookup[response, "AuthToken"];

	(* Also clear the cache to make sure there aren't old objects lying around for the user to see. *)
	clearCache[];

	(* Get the JWT in the telescope kernel. This is what ConstellationRequest[...] uses. *)
	doJwtLogin[Lookup[response, "AuthToken"], GoLink`Private`stashedDomain];

	(* Set $PersonID. *)
	$PersonID=Download[myUser, Object];

	(* Return our user. *)
	(* Note: Importantly, there is no way to "step-up" to a superuser once stepping down for safety reasons. We reserve that for engine to do after the kernel is cleared. *)
	myUser
];

(* ::Subsection:: *)
(*RollbackAssumeIdentity (Private function)*)

Error::NoPreviousUser="There is no previous user to rollback to.  You must call AssumeIdentity[user, AllowRollback->True] prior to calling RollbackAssumeIdentity.";

RollbackAssumeIdentity[]:=Module[
	{stashedJwt, newJwt, newUser},

	(* Check if a previous JWT exists *)
	If[Length[stashedJwtStack] > 0,
		stashedJwt=stashedJwtStack // First;
		stashedJwtStack=stashedJwtStack // Rest;
		newUser=stashedJwt // First;
		newJwt=stashedJwt // Last,
		Message[Error::NoPreviousUser];
		Return[$Failed];
	];

	(* Clear all the currently stored JWT info *)
	clearJwtFile[GoLink`Private`stashedDomain];

	(* Update the current jwt *)
	GoLink`Private`stashedJwt=newJwt;

	(* Clear the cache because changing the user may change what you have permissions to access *)
	clearCache[];

	(* Get the JWT in the telescope kernel. This is what ConstellationRequest[...] uses. *)
	doJwtLogin[newJwt, GoLink`Private`stashedDomain];

	(* Set $PersonID. *)
	$PersonID=Download[newUser, Object];

	(* Return our user. *)
	newUser
];
