

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentLuminescenceSpectroscopy*)

DefineUsage[ExperimentLuminescenceSpectroscopy,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentLuminescenceSpectroscopy[Samples]","Protocol"},
				Description->"generates a 'Protocol' for measuring luminescence intensity of the provided 'Samples' over a range of emission wavelengths.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples for which to measure luminescence.",
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
						Description->"The protocol generated to measure luminescence of the provided input.",
						Pattern:>ObjectP[Object[Protocol,LuminescenceSpectroscopy]]
					}
				}
			}
		},
		MoreInformation->{
		},
		SeeAlso->{
			"ValidExperimentLuminescenceSpectroscopyQ",
			"ExperimentLuminescenceSpectroscopyOptions",
			"PlotLuminescenceSpectroscopy",
			"ExperimentLuminescenceIntensity",
			"ExperimentLuminescenceKinetics",
			"ExperimentFluorescenceSpectroscopy",
			"ExperimentAbsorbanceSpectroscopy",
			"ExperimentUVMelting"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"hayley", "mohamad.zandian"}
	}
];