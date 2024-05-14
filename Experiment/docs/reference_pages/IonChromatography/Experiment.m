(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentIonChromatography*)


DefineUsage[ExperimentIonChromatography, 
	{
		BasicDefinitions->{
		{
			Definition->{"ExperimentIonChromatography[Samples]", "Protocol"},
			Description->"generates a 'Protocol' for running an Ion Chromatography experiment to separate charged species from the provided 'Samples'.",
			Inputs:>{
			IndexMatching[
				{
					InputName->"Samples",
					Description->"The mixture of analytes which should be injected onto a separation column and analyzed via Ion Chromatography.",
					Expandable->False,
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
									PatternTooltip -> "Enumeration must be any well from A1 to P24."
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
					]
				},
				IndexName->"experiment samples"
				]
			},
			Outputs:>{
				{
					OutputName->"Protocol",
					Description->"A protocol object that outlines the parameters involved in running Ion Chromatography experiment.",
					Pattern:>ObjectP[Object[Protocol,IonChromatography]]
				}
			}
		}},
		MoreInformation->{
			"If the input samples are not in compatible containers, aliquots will automatically be transferred to appropriate containers.",
			"Compatible containers for protocols using Model[Instrument, IonChromatography, \"ICS 6000\"] are: Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] and Model[Container, Vessel, \"HPLC vial (high recovery)\"]."
		},
		SeeAlso -> {
			"ExperimentIonChromatographyPreview",
			"ExperimentIonChromatographyOptions",
			"ValidExperimentIonChromatographyQ",
			"AnalyzePeaks",
			"PlotChromatography",
			"ExperimentHPLC",
			"ExperimentFPLC"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"malav.desai", "andrey.shur", "josh.kenchel", "steven", "varoth.lilascharoen", "chi.zhao"}
}];


(* ::Subsubsection:: *)
(*ExperimentIonChromatographyPreview*)


DefineUsage[ExperimentIonChromatographyPreview,
	{
		BasicDefinitions->{{
			Definition->{"ExperimentIonChromatographyPreview[Samples]","Preview"},
			Description->"returns the graphical preview for ExperimentIonChromatography when it is called on 'Samples'. This output is always Null.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"Samples",
						Description->"The mixture of analytes which should be injected onto a separation column and analyzed via Ion Chromatography.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample],Object[Container]}],
							Dereference->{Object[Container]->Field[Contents[[All,2]]]}
						],
						Expandable->False
					},
					IndexName->"experiment samples"
				]
			},
			Outputs:>{
				{
					OutputName->"Preview",
					Description->"Graphical preview representing the output of ExperimentIonChromatography. This value is always Null.",
					Pattern:>Null
				}
			}
		}},
		MoreInformation->{},
		SeeAlso->{
			"ExperimentIonChromatography",
			"ExperimentIonChromatographyOptions",
			"ValidExperimentIonChromatographyQ",
			"AnalyzePeaks",
			"PlotChromatography",
			"ExperimentHPLC",
			"ExperimentFPLC"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"malav.desai", "andrey.shur", "josh.kenchel", "steven", "varoth.lilascharoen", "chi.zhao"}
}];


(* ::Subsubsection:: *)
(*ExperimentIonChromatographyOptions*)


DefineUsage[ExperimentIonChromatographyOptions,
	{
		BasicDefinitions->{{
			Definition->{"ExperimentIonChromatographyOptions[Samples]","ResolvedOptions"},
			Description->"returns the resolved options for ExperimentIonChromatography when it is called on 'Samples'.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"Samples",
						Description->"The mixture of analytes which should be injected onto a separation column and analyzed via Ion Chromatography.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample],Object[Container]}],
							Dereference->{Object[Container]->Field[Contents[[All,2]]]}
						],
						Expandable->False
					},
					IndexName->"experiment samples"
				]
			},
			Outputs:>{
				{
					OutputName->"ResolvedOptions",
					Description->"Resolved options when ExperimentIonChromatography is called on the input samples.",
					Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
				}
			}
		}},
		MoreInformation->{
			"This function returns the resolved options that would be fed to ExperimentIonChromatography if it were called on these input samples."
		},
		SeeAlso->{
			"ExperimentIonChromatography",
			"ExperimentIonChromatographyPreview",
			"ValidExperimentIonChromatographyQ",
			"AnalyzePeaks",
			"PlotChromatography",
			"ExperimentHPLC",
			"ExperimentFPLC"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"malav.desai", "andrey.shur", "josh.kenchel", "steven", "varoth.lilascharoen", "chi.zhao"}
}];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentIonChromatographyQ*)


DefineUsage[ValidExperimentIonChromatographyQ,
	{
		BasicDefinitions->{{
			Definition->{"ValidExperimentIonChromatographyQ[Samples]","Booleans"},
			Description->"checks whether the provided 'Samples' and specified options are valid for calling ExperimentIonChromatography.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"Samples",
						Description->"The mixture of analytes which should be injected onto a separation column and analyzed via Ion Chromatography.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[{Object[Sample],Object[Container]}],
							Dereference->{Object[Container]->Field[Contents[[All,2]]]}
						],
						Expandable->False
					},
					IndexName -> "experiment samples"
				]
			},
			Outputs:>{
				{
					OutputName->"Booleans",
					Description->"Whether or not the ExperimentIonChromatography call is valid. Return value can be changed via the OutputFormat option.",
					Pattern :> _EmeraldTestSummary| BooleanP
				}
			}
		}},
		MoreInformation -> {},
		SeeAlso->{
		"ExperimentIonChromatography",
		"ExperimentIonChromatographyPreview",
		"ExperimentIonChromatographyOptions",
		"AnalyzePeaks",
		"PlotChromatography",
		"ExperimentHPLC",
		"ExperimentFPLC"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"malav.desai", "andrey.shur", "josh.kenchel", "steven", "varoth.lilascharoen", "chi.zhao"}
}];