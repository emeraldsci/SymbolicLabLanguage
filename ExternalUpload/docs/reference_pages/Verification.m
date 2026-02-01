(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Subsection::Closed:: *)
(*VerifyObjects*)

DefineUsage[VerifyObjects,
	{
		BasicDefinitions -> {
			{
				Definition -> {"VerifyObjects[objectToVerify]", "VerifiedObject"},
				(* Singleton overload *)
				Description -> "Checks that the given input objects, after applying changes indicated by the options, has all required fields set.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "objectToVerify",
							Description -> "The object pending verification by developers.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[VerificationRequiredTypes],
								PreparedSample -> False,
								PreparedContainer -> False
							],
							Expandable -> False
						},
						IndexName -> "Input Data"
					]
				},
				Outputs :> {
					{
						OutputName -> "VerifiedObject",
						Description -> "The verified object.",
						Pattern :> ObjectP[]
					}
				}
			}
		},
		MoreInformation -> {
			"Find and apply the corresponding verification function on the 'objectToVerify', check if it passes ValidObjectQ; if it does, set Verified -> True for this object."
			"Function includes options for all UploadVerifiedX functions, so modification on input objects can be done directly before checking if it's valid."
		},
		SeeAlso -> {
			"PlotUnverifiedObjects",
			"UploadVerifiedContainerModel",
			"UploadVerifiedSampleModel",
			"VerificationPreCheck"
		},
		Author -> {"hanming.yang"}
	}
];

(* ::Subsection::Closed:: *)
(*PlotUnverifiedObjects*)

DefineUsage[PlotUnverifiedObjects,
	{
		BasicDefinitions -> {
			{
				Definition -> {"VerifyObjects[]", "Table"},
				(* Singleton overload *)
				Description -> "Find objects that's pending verification and plot them in 'Table'.",
				Inputs :> {

				},
				Outputs :> {
					{
						OutputName -> "Table",
						Description -> "The Table of unverified objects.",
						Pattern :> _Pane
					}
				}
			}
		},
		SeeAlso -> {
			"VerifyObjects",
			"VerificationPreCheck"
		},
		Author -> {"hanming.yang"}
	}
];

(* ::Subsection::Closed:: *)
(*VerificationPreCheck*)

DefineUsage[VerificationPreCheck,
	{
		BasicDefinitions -> {
			{
				Definition -> {"VerificationPreCheck[objectToVerify]", "Boolean"},
				Description -> "Checks that the given input objects are ready to be verified by ECL personnel. This function applies additional tests that cannot be done through ValidObjectQ.",
				Inputs :> {
					{
						InputName -> "objectToVerify",
						Description -> "The object pending verification by developers.",
						Widget -> Widget[
							Type -> Object,
							Pattern :> ObjectP[VerificationRequiredTypes],
							PreparedSample -> False,
							PreparedContainer -> False
						],
						Expandable -> False
					}
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A Boolean indicating if pre-verification checks are passing.",
						Pattern :> BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"VerifyObjects",
			"PlotUnverifiedObjects"
		},
		Author -> {"hanming.yang"}
	}
];