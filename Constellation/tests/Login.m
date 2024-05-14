(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*ConstellationVersion*)
DefineTests[
	ConstellationVersion,
	{
		Example[{Basic,"Returns the version of Constellation that SLL is currently connected to:"},
			ConstellationVersion[],
			_String
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*Login*)

DefineTests[
	Login,
	{
		Example[{Basic, "Returns true with valid username and password:"},
			Login["ben@franklin.org", "lightning"],
			True
		],

		Example[{Basic, "Prompt for username & password:"},
			Login[],
			True,
			Stubs :> {
				getFormResults[___]:=<|"Username" -> "ben@franklin.org", "Password" -> "lightning"|>,
				loadJwtFile[___]:=$Failed
			}
		],

		Example[{Options, Token, "Login using a previously generated authorization token:"},
			Login[Token -> "dGkiOiJpZDpXTmE0WmpSMWtrMVYiLCJleHAiOjE1MTAzNDM2MjksInNjcCI6WyJwcm9kdWN0aW9uIiwibGl2ZSIsIjY4Lj"],
			True,
			Stubs :> {
				Constellation`Private`doJwtLogin["dGkiOiJpZDpXTmE0WmpSMWtrMVYiLCJleHAiOjE1MTAzNDM2MjksInNjcCI6WyJwcm9kdWN0aW9uIiwibGl2ZSIsIjY4Lj", _String]:=Association["Success" -> True, "Error" -> "", "Domain" -> "testing"]
			}
		],

		Test["Sets $PersonID if a person is found with the given email:",
			{
				Login["ben@franklin.org", "lightning"],
				$PersonID
			},
			{
				True,
				Object[User, "id:123"]
			}
		],

		Test["Sets $Site if an Object[User,Emerald] is found with the given email:",
			{
				Login["operator@franklin.org", "lightning"],
				$PersonID,
				$Site
			},
			{
				True,
				Object[User,Emerald, "id:1234"],
				Object[Container,Site,"non-existing test Site for Login"]
			}
		],

		Test["Sets $Site if an Object[User] is found with the given email:",
			{
				Login["ben@franklin.org", "lightning"],
				$PersonID,
				$Site
			},
			{
				True,
				Object[User, "id:123"],
				Object[Container,Site,"non-existing test Site 2 for Login testing"]
			}
		],

		Example[{Messages, "NotLoggedIn", "Returns $Failed if username and/or password does not match:"},
			Login["ben@franklin.org", "key"],
			$Failed,
			Messages :> {
				Login::NotLoggedIn
			},
			Stubs :> {
				Constellation`Private`doLogin["ben@franklin.org", "key", _String]:=Association["Success" -> False, "Error" -> "", "Domain" -> "testing"]
			}
		],

		Example[{Messages, "Server", "Returns $Failed if there is an error communicating with the server:"},
			Login["ben@franklin.org", "key"],
			$Failed,
			Messages :> {
				Message[Login::Server, "Unknown error"]
			},
			Stubs :> {
				Constellation`Private`doLogin["ben@franklin.org", "key", _String]:=Association["Success" -> False, "Error" -> "Unknown error", "Domain" -> "testing"]
			}
		],

		Example[{Options, Database, "The database can be specified as an option:"},
			Login["ben@franklin.org", "lightning", Database -> Test],
			True
		],

		Example[{Options, Database, "The database option can accept a domain as a string:"},
			Login["ben@franklin.org", "lightning", Database -> "my.personal.domain"];
			Global`$ConstellationDomain,
			"my.personal.domain"
		],

		Example[{Options, Email, "Passing only the email option will prompt for password:"},
			Login[Email -> "ben@franklin.org"],
			True,
			Stubs :> {
				getFormResults[___]:=<|"Password" -> "lightning"|>,
				loadJwtFile[___]:=$Failed
			}
		],

		Example[{Options, Remember, "Remembered logins will not prompt a second time:"},
			Hold[
				(* first kernel: prompt *)
				Login[Email -> "ben@franklin.org", Remember -> True];
				(* first kernel: quit without logout *)
				Quit[];

				(* second kernel: no prompt *)
				Login[Email -> "ben@franklin.org", Remember -> True];
			],
			_Hold,
			Stubs :> {
				getFormResults[___]:=<|"Password" -> "lightning"|>,
				loadJwtFile[___]:=$Failed
			}
		],


		Example[{Options, QuietDomainChange, "When changing domains, prompt for approval:"},
			Hold[
				(* first kernel: prompt for login deets *)
				Login[Email -> "ben@franklin.org", Remember -> True, Domain -> sample1];

				(* first kernel again: popup a dialog for changing domain *)
				Login[Email -> "ben@franklin.org", Remember -> True, Domain -> sample2];
			],
			_Hold,
			Stubs :> {
				getFormResults[___]:=<|"Password" -> "lightning"|>,
				loadJwtFile[___]:=$Failed
			}
		],

		Test["Cache is purged on each login:",
			Login["ben@franklin.org", "lightning"]; objectCache,
			<||>
		],

		Test["Remember->True works:",
			(
				Login["ben@franklin.org", "lightning", Remember -> True, QuietDomainChange -> True];
				Login["ben@franklin.org", Remember -> True, QuietDomainChange -> True]
			),
			True,
			Stubs :> {
				getFormResults[___] := $Canceled
			}
		]
	},
	(* Keep the user logged into their original database *)
	SetUp :> (oldDomain=Global`$ConstellationDomain; oldPersonId=$PersonID; oldJwt=GoLink`Private`stashedJwt; oldSite=ECL`$Site),
	TearDown :> (
		(* Set $ConstellationDomain to it's previous value, or the default *)
		Global`$ConstellationDomain=If[ValueQ[oldDomain],
			oldDomain,
			Constellation`Private`ConstellationDomain[Production]
		];
		$PersonID=oldPersonId;
		GoLink`Private`stashedJwt=oldJwt;
		GoLink`Private`stashedDomain=oldDomain;
		Unprotect[ECL`$Site];
		ECL`$Site=oldSite;
		Protect[ECL`$Site]
	),

	Stubs :> {
		idToTypeStringCache=<||>,
		idToTypeCache=<||>,
		typeToIdCache=<||>,
		typeStringToIdCache=<||>,
		listObjectTypes[]:=Association[],
		Constellation`Private`doLogin["ben@franklin.org", "lightning", domain_String]:=Association[
			"Success" -> True,
			"Error" -> "",
			"Domain" -> domain,
			"UserId" -> "id:123",
			"Type" -> "Object.User"],
		Constellation`Private`doLogin["operator@franklin.org", "lightning", domain_String]:=Association[
			"Success" -> True,
			"Error" -> "",
			"Domain" -> domain,
			"UserId" -> "id:1234",
			"Type" -> "Object.User.Emerald"],
		Download[Object[User,Emerald,"id:1234"],ECL`Site[Object]]:=Object[Container,Site,"non-existing test Site for Login"],
		Download[Object[User,"id:123"], ECL`FinancingTeams[ECL`DefaultExperimentSite][Object]]:={Object[Container,Site,"non-existing test Site 2 for Login testing"]},
		Constellation`Private`domainChangePromptApproved[___]:=True,
		fetchUserID[]:=Null,
		objectCache=<|
			Object[User, "id:id"] -> <||>
		|>
	}
];

(* ::Subsubsection::Closed:: *)
(*ManifoldLogin*)

DefineTests[
	ManifoldLogin,
	{
		Example[{Options, Token, "Login using a previously generated authorization token:"},
			ManifoldLogin["dGkiOiJpZDpXTmE0WmpSMWtrMVYiLCJleHAiOjE1MTAzNDM2MjksInNjcCI6WyJwcm9kdWN0aW9uIiwibGl2ZSIsIjY4Lj"],
			True,
			Stubs :> {
				Constellation`Private`doJwtLogin["dGkiOiJpZDpXTmE0WmpSMWtrMVYiLCJleHAiOjE1MTAzNDM2MjksInNjcCI6WyJwcm9kdWN0aW9uIiwibGl2ZSIsIjY4Lj", _String] := Association["Success" -> True, "Error" -> "", "Domain" -> "testing"]
			}
		],
		Example[{Messages, Token, "Failed login retries with wait time:"},
			Catch[Throw[ManifoldLogin["not_a_valid_token", Constellation`Private`MaxAttempts->2]]],
			$Failed,
			Messages :> {
				Login::NotLoggedIn
			},
			Stubs :> {
				Constellation`Private`doJwtLogin["not_a_valid_token", _String] := Association["Success" -> False, "Error" -> "", "Domain" -> "testing"],
				Upload[
					<|
						Object -> Download[$ManifoldComputation, Object],
						Status -> Error,
						ErrorMessage -> "There was a problem initializing your Manifold job. Please resubmit the job again later."
					|>
				] := Null
			}
		]
	},
	SetUp :> (oldDomain=Global`$ConstellationDomain; oldPersonId=$PersonID; oldJwt=GoLink`Private`stashedJwt),
	TearDown :> (
		(* Set $ConstellationDomain to it's previous value, or the default *)
		Global`$ConstellationDomain=If[ValueQ[oldDomain],
			oldDomain,
			Constellation`Private`ConstellationDomain[Stage]
		];
		$PersonID=oldPersonId;
		GoLink`Private`stashedJwt=oldJwt;
		GoLink`Private`stashedDomain=oldDomain
	)

];

(* ::Subsubsection::Closed:: *)
(*Logout*)

DefineTests[
	Logout,
	{
		Example[{Messages, "NotLoggedIn", "Returns $Failed if no user is currently logged in:"},
			Logout[],
			$Failed,
			Messages :> {
				Logout::NotLoggedIn
			},
			Stubs :> {
				GoCall["Logout"]=Association["Success" -> False, "Error" -> ""]
			}
		],

		Example[{Messages, "Server", "Returns $Failed if there is an error communicating with the server:"},
			Logout[],
			$Failed,
			Messages :> {
				Message[Logout::Server, "Unknown error"]
			},
			Stubs :> {
				GoCall["Logout"]=Association["Success" -> False, "Error" -> "Unknown error"]
			}
		],

		Example[{Basic, "Logs the user out of the system:"},
			Logout[],
			True
		]
	},
	(* Keep the user logged into their original database *)
	SetUp :> (oldDomain=Global`$ConstellationDomain; oldPersonId=$PersonID; oldJwt=GoLink`Private`stashedJwt),
	TearDown :> (
		(* Set $ConstellationDomain to it's previous value, or the default *)
		Global`$ConstellationDomain=If[ValueQ[oldDomain],
			oldDomain,
			Constellation`Private`ConstellationDomain[Stage]
		];
		$PersonID=oldPersonId;
		GoLink`Private`stashedJwt=oldJwt;
		GoLink`Private`stashedDomain=oldDomain
	),
	Stubs :> {
		GoCall["Logout"]=Association["Success" -> True, "Error" -> ""],
		clearJwtFile[___]:=Null
	}
];

(* ::Subsubsection::Closed:: *)
(*AssumeIdentity*)

DefineTests[
	AssumeIdentity,
	{
		Example[{Basic, "Can assume another user identity"},
			AssumeIdentity[Object[User, Emerald, Developer, "id:n0k9mG8NLqBn"]],
			ObjectP[Object[User, Emerald, Developer, "id:n0k9mG8NLqBn"]]
		]
	},
	(* Go back to the original user after all the assume identity shenanigans *)
	SetUp :> (oldPersonId=$PersonID),
	TearDown :> (AssumeIdentity[oldPersonId])
];

(* ::Subsubsection::Closed:: *)
(*RollbackAssumeIdentity*)

DefineTests[
	RollbackAssumeIdentity,
	{
		Example[{Basic, "Can rollback to a previous user when assume identity has AllowRollback->True"},
			AssumeIdentity[Object[User, Emerald, Developer, "id:n0k9mG8NLqBn"], AllowRollback -> True];
			RollbackAssumeIdentity[],
			ObjectP[Object[User]]
		],
		Example[{Messages, NoPreviousUser, "Returns $Failed and issues a warning if no previous assume occurs."},
			RollbackAssumeIdentity[],
			$Failed,
			Messages :> {
				Error::NoPreviousUser
			}
		],
		Example[{Messages, NoPreviousUser, "Returns $Failed and issues a warning if assume user without rollback was used."},
			AssumeIdentity[Object[User, Emerald, Developer, "id:n0k9mG8NLqBn"]];
			RollbackAssumeIdentity[],
			$Failed,
			Messages :> {
				Error::NoPreviousUser
			}
		],
		Example[{Messages, NoPreviousUser, "Returns $Failed and issues a warning if rollback called twice after assuming user once."},
			AssumeIdentity[Object[User, Emerald, Developer, "id:n0k9mG8NLqBn"], AllowRollback -> True];
			RollbackAssumeIdentity[];
			RollbackAssumeIdentity[],
			$Failed,
			Messages :> {
				Error::NoPreviousUser
			}
		]
	},
	(* Go back to the original user after all the assume identity shenanigans *)
	SetUp :> (oldPersonId=$PersonID),
	TearDown :> (AssumeIdentity[oldPersonId]),
	Variables :> {oldPersonId}
]
