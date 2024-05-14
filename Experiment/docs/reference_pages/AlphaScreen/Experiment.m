(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentAlphaScreen*)

DefineUsage[ExperimentAlphaScreen,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentAlphaScreen[Samples]","Protocol"},
				Description->"generates a 'Protocol' object for AlphaScreen measurement of the 'Samples'. The samples should contain analytes with acceptor and donor AlphaScreen beads. Upon laser excitation at 680nm to the donor AlphaScreen beads, singlet Oxygen is produced and diffused to the acceptor AlphaScreen beads only when the two beads are in close proximity. The acceptor AlphaScreen beads react with the singlet Oxygen and emit light signal at 570nm which is captured by a detector in plate reader. A plate which contains the AlphaScreen beads and analytes loaded can be provided as input and the plate will be excited directly and measured in the plate reader. Alternatively, prepared samples can be provided and transferred to an assay plate for AlphaScreen measurement.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description -> "The samples that have analytes with acceptor and donor beads ready for luminescent AlphaScreen measurement.",
							Widget -> Alternatives[
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
						Description->"The protocol generated to describe AlphaScreen measurement of the 'Samples'.",
						Pattern:>ObjectP[Object[Protocol,AlphaScreen]]
					}
				}
			}
		},
		MoreInformation->{
			(*TBU*)
		},
		SeeAlso->{
			"ValidExperimentAlphaScreenQ",
			"ExperimentAlphaScreenOptions",
			"ExperimentFluorescenceIntensity",
			"ExperimentLuminescenceIntensity",
			"PlotAlphaScreen"
			(*update this after we have developed other AlphaScreen applications*)
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"eunbin.go", "jihan.kim", "fan.wu"}
	}
];