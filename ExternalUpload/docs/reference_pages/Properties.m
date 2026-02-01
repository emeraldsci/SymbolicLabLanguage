(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

(* ::Section::Closed:: *)
(*UploadSampleProperties*)

DefineUsage[UploadSampleProperties,
	{
		BasicDefinitions->{
			{
				Definition -> {"UploadSampleProperties[samples]", "updatedSamples"},
				Description -> "returns the objects in 'samples' with their corresponding properties updated.",
				Inputs :> {
					IndexMatching[
						IndexName -> "Input Data",
						{
							InputName -> "samples",
							Description -> "The source samples or for the updates.",
							Widget -> Widget[
								Type -> Object,
								Pattern :> ObjectP[Object],
								ObjectTypes -> {Object[Sample]},
								PreparedSample -> False,
								PreparedContainer -> False
							]
						}
					]
				},
				Outputs :> {
					{
						OutputName -> "updatedSamples",
						Description -> "All samples for which properties were updated.",
						Pattern :> ListableP[ObjectP[{Object[Sample]}]]
					}
				}
			}
		},
		MoreInformation->{
			"If an option value is specified as None, the corresponding field will be cleared (set to Null).",
			"The default option values, Null, indicate that the field should be left untouched.",
			"For Volume and Mass fields, the update 'type' is ComputedVolume and ComputedWeight respectively."
		},
		SeeAlso->{
			"UploadTransportCondition",
			"DefineAnalytes",
			"DefineEHSInformation"
		},
		Author->{"dima","robert", "alou"}
	}
];