(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentLuminescenceIntensity*)


DefineUsage[ExperimentLuminescenceIntensity,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentLuminescenceIntensity[Samples]","Protocol"},
				Description->"generates a 'Protocol' for measuring luminescence intensity of the provided 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples for which to measure luminescence intensity.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Container with Well Position"->{
									"Well Position" -> Alternatives[
										"A1 to P24" -> Widget[
											Type -> Enumeration,
											Pattern :>  Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
											PatternTooltip -> "Enumeration must be any well from A1 to H12."
										],
										"Container Position" -> Widget[
											Type -> String,
											Pattern :> LocationPositionP,
											PatternTooltip -> "Any valid container position.",
											Size->Line
										]
									],
									"Container" -> Widget[
										Type -> Object,
										Pattern :> ObjectP[{Object[Container]}]
									]
								}
							],
							Expandable -> False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol generated to measure luminescence intensity of the provided input.",
						Pattern:>ObjectP[Object[Protocol,LuminescenceIntensity]]
					}
				}
			}
		},
		MoreInformation->{
			"Any requested sample prep will occur according to the following order: incubate input samples, mix input samples, centrifuge input samples, filter input samples",
			"If injections were specified they will occur in serial before the plate is mixed or read.",
			"If PlateReaderMix -> True, mixing will occur immediately after any injections and before the read.",
			"If Gain is set as a percentage, the actual gain voltage will be determined immediately before the read, after injections and mixing have occurred."
		},
		SeeAlso->{
			"ValidExperimentLuminescenceIntensityQ",
			"ExperimentLuminescenceIntensityOptions",
			"ExperimentLuminescenceKinetics",
			"ExperimentLuminescenceSpectroscopy",
			"ExperimentFluorescenceIntensity",
			"ExperimentAbsorbanceSpectroscopy",
			"ExperimentUVMelting"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"hayley", "mohamad.zandian"}
	}
];