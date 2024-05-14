(* ::Subsubsection:: *)
(* ExperimentCapillaryIsoelectricFocusing *)

DefineUsage[ExperimentCapillaryIsoelectricFocusing,{

	BasicDefinitions->{
		{
			Definition->{"ExperimentCapillaryIsoelectricFocusing[Samples]","Protocol"},
			Description->"generates a 'Protocol' object for running capillary Isoelectric Focusing (cIEF) on protein 'Samples'. cIEF is an analytical method used to separate proteins by their isoelectric point (pI) over a pH gradient.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"Samples",
						Description->"The samples to be analyzed by capillary Isoelectric Focusing (cIEF). The recommended final protein concentration per sample is ~0.2 mg/mL in 50-200 \[Mu]L (total of 10 \[Mu]g - 40 \[Mu]g protein) for input with less than 15 mM salt.",
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
										Pattern :> Alternatives @@ Flatten[AllWells[NumberOfWells -> 384]],
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
						Expandable->False
					},
					IndexName->"experiment samples"
				]
			},
			Outputs:>{
				{
					OutputName->"Protocol",
					Description->"A protocol object for running a capillary isoelectric focusing experiment.",
					Pattern:>ObjectP[Object[Protocol,CapillaryIsoelectricFocusing]]
				}
			}
		}
	},
	MoreInformation->{
		"A maximum of 100 injections can be run in every batch.",
		"To ensure reproducibility, Standards should be added to every batch of samples. For highest sensitivity, both UVAbsorbance and NativeFluoresence should be used for detection."
	},
	SeeAlso->{
		"ExperimentCapillaryIsoelectricFocusingOptions",
		"ValidExperimentCapillaryIsoelectricFocusingQ",
		"PlotCapillaryIsoelectricFocusing",
		"PlotCapillaryIsoelectricFocusingEvolution",
		"ExperimentSolidPhaseExtraction"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author->{
		"gil.sharon"
	}
}];




(* ::Subsubsection::Closed:: *)
(*ExperimentCapillaryIsoelectricFocusingOptions*)

DefineUsage[ExperimentCapillaryIsoelectricFocusingOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentCapillaryIsoelectricFocusingOptions[Samples]", "ResolvedOptions"},
				Description->"generates the 'ResolvedOptions' for performing a capillary isoelectric focusing experiment on the provided 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples to be analyzed using Capillary Isoelectric Focusing for the separation of proteins by charge.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options describing how the Capillary Isoelectric Focusing experiment is run when ExperimentCapillaryIsoelectricFocusing is called on the input samples.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation->{
			"The options returned by ExperimentCapillaryIsoelectricFocusingOptions may be passed directly to ExperimentCapillaryIsoelectricFocusing."
		},
		SeeAlso->{
			"ExperimentCapillaryIsoelectricFocusing",
			"ValidExperimentCapillaryIsoelectricFocusingQ",
			"PlotCapillaryIsoelectricFocusing",
			"PlotCapillaryIsoelectricFocusingEvolution"
		},
		Author->{
			"gil.sharon"
		}
	}
];



(* ::Subsubsection::Closed:: *)
(*ValidExperimentCapillaryIsoelectricFocusingQ*)


DefineUsage[ValidExperimentCapillaryIsoelectricFocusingQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidExperimentCapillaryIsoelectricFocusingQ[Samples]", "Boolean"},
				Description->"checks whether the provided 'Samples' and specified options are valid for calling ExperimentCapillaryIsoelectricFocusing.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples to be analyzed using Capillary Isoelectric Focusing experiment for the separation of proteins by charge.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"The value indicating whether the ExperimentCapillary call is valid with the specified options on the provided samples. The return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentCapillaryIsoelectricFocusing",
			"ExperimentCapillaryIsoelectricFocusingOptions",
			"PlotCapillaryIsoelectricFocusing",
			"PlotCapillaryIsoelectricFocusingEvolution"
		},
		Author->{
			"gil.sharon"
		}
	}
];



DefineUsage[ExperimentCapillaryIsoelectricFocusingPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentCapillaryIsoelectricFocusingPreview[Samples]","Preview"},
				Description->"returns a graphical preview of the Capillary Isoelectric Focusing experiment defined for 'Samples'. This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples to be analyzed using Capillary Isoelectric Focusing experiment for the separation of proteins by charge.",
							Widget->Widget[
								Type->Object,
								Pattern :> ObjectP[{Object[Sample],Object[Container]}],
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
								}
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"A graphical preview of the ExperimentCapillaryIsoelectricFocusing output. Return value can be changed via the OutputFormat option.",
						Pattern:>Null
					}
				}
			}
		},
		MoreInformation->{
			"Due to the nature of ExperimentCapillaryIsoelectricFocusing, no graphical preview is available for ExperimentCapillaryIsoelectricFocusing. ExperimentCapillaryIsoelectricFocusingPreview always returns Null."
		},
		SeeAlso->{
			"ExperimentCapillaryIsoelectricFocusing",
			"ExperimentCapillaryIsoelectricFocusingOptions",
			"ValidExperimentCapillaryIsoelectricFocusingQ",
			"PlotCapillaryIsoelectricFocusing",
			"PlotCapillaryIsoelectricFocusingEvolution"
		},
		Author->{
			"gil.sharon"
		}
	}
];