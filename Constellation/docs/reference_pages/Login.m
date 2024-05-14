(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineUsage[ConstellationVersion,
	{
		BasicDefinitions -> {
			{"ConstellationVersion[]", "version", "returns the version of Constellation that SLL is currently connected to."}
		},
		MoreInformation -> {},
		Input :> {},
		Output :> {
			{"version", _String, "The version of constellation."}
		},
		SeeAlso -> {"Logout", "Download", "Upload", "ProductionQ"},
		Author -> {"platform"}
	}
];

DefineUsage[Login,
	{
		BasicDefinitions -> {
			{"Login[email,password]", "success", "signs in to the ECL using your 'email' and 'password'."},
			{"Login[token]", "success", "signs in to the ECL using the pre-created authorization 'token'."},
			{"Login[]", "success", "signs in to the ECL by prompting for an email and password."}
		},
		MoreInformation -> {
			"Users must login before accessing any data in the ECL (via Download, Upload, and similar functions).",
			"Returns $Failed if there was an error logging in.",
			"Returns $Canceled if the user cancels log in"
		},
		Input :> {
			{"email", _String, "Your email address associated with your ECL account."},
			{"password", _String, "Your password associated with your ECL account."},
			{"token", _String, "A previously generated authorization token."}
		},
		Output :> {
			{"success", True | $Failed, "If login was successful, True is returned (otherwise returns $Failed)."}
		},
		SeeAlso -> {"Logout", "Download", "Upload", "ProductionQ"},
		Author -> {"platform"}
	}];

DefineUsage[ManifoldLogin,
	{
		BasicDefinitions -> {
			{"ManifoldLogin[token]", "success", "signs in to the ECL using the pre-created authorization 'token', retrying if failed attempt."}
		},
		MoreInformation -> {
			"ManifoldLogin is privately-scoped token-only login function, intended to be used only when logging in via Manifold.",
			"Users must login before accessing any data in the ECL (via Download, Upload, and similar functions).",
			"Returns $Failed if there was an error logging in.",
			"Returns $Canceled if the user cancels log in"
		},
		Input :> {
			{"token", _String, "A previously generated authorization token."}
		},
		Output :> {
			{"success", True | $Failed, "If login was successful, True is returned (otherwise returns $Failed)."}
		},
		SeeAlso -> {"Login", "Logout", "Download", "Upload", "ProductionQ"},
		Author -> {"platform"}
	}];

DefineUsage[Logout,
	{
		BasicDefinitions -> {
			{"Logout[]", "result", "logs a user out of the data service."}
		},
		MoreInformation -> {
		},
		Input :> {
		},
		Output :> {
			{"result", True | $Failed, "If the logout was successful, True is returned, otherwise returns $Failed."}
		},
		SeeAlso -> {"Login", "Download", "Upload", "ProductionQ"},
		Author -> {"platform"}
	}];

DefineUsage[AssumeIdentity,
	{
		BasicDefinitions -> {
			{"AssumeIdentity[user]", "result", "Assume identity of 'user'."}
		},
		MoreInformation -> {
			"You must be logged in as a super user to use this functionality.",
			"Do not call AssumeIdentity with AllowTrue set to True if you are calling untrusted or user code."
		},
		Input :> {
			{"user", ObjectP[Object[User]], "The user to assume identity of."}
		},
		Output :> {
			{"result", ObjectP[Object[User]] | $Failed, "The new user, if successful, and $Failed otherwise."}
		},
		SeeAlso -> {"Login", "RollbackAssumeIdentity"},
		Author -> {"platform"}
	}];

DefineUsage[RollbackAssumeIdentity,
	{
		BasicDefinitions -> {
			{"RollbackAssumeIdentity", "result", "Rollback to the user prior to assuming identity."}
		},
		MoreInformation -> {
			"You must have previously called AssumeIdentity with AllowRollback->True"
		},
		Input :> {
		},
		Output :> {
			{"result", ObjectP[Object[User]] | $Failed, "The new user, if successful, and $Failed otherwise."}
		},
		SeeAlso -> {"Login", "AssumeIdentity"},
		Author -> {"platform"}
	}];
