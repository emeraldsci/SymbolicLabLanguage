(* ::Subsubsection:: *)
(* ExperimentCapillaryGelElectrophoresisSDS *)

DefineUsage[ExperimentCapillaryGelElectrophoresisSDS,{

	BasicDefinitions->{
		{
			Definition->{"ExperimentCapillaryGelElectrophoresisSDS[Samples]","Protocol"},
			Description->"generates a 'Protocol' object for running capillary Gel Electrophoresis-SDS (CESDS) on protein 'Samples'. CESDS is an analytical method used to separate proteins by their molecular weight.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"Samples",
						Description->"The samples to be electrophorated through a separating matrix. The recommended final protein concentration (reduced or non-reduced) per sample is 0.2-1.5 mg/mL in 50-200 \[Mu]L (total of 10 \[Mu]g - 300 \[Mu]g protein) for input with less than 50 mM salt.",
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
							},
							"Model Sample"->Widget[
								Type -> Object,
								Pattern :> ObjectP[Model[Sample]],
								ObjectTypes -> {Model[Sample]}
							]
						],
						Expandable->False
					},
					IndexName->"experiment samples"
				]
			},
			Outputs:>{
				{
					OutputName->"Protocol",
					Description->"A protocol object for running a capillary gel electrophoresis SDS experiment.",
					Pattern:>ObjectP[Object[Protocol,CapillaryGelElectrophoresisSDS]]
				}
			}
		}
	},
	MoreInformation->{
		"A maximum of 48 injections can be run in every batch. ",
		"To ensure reproducibility, Standards should be added to every batch of samples."
	},
	SeeAlso->{
		"ExperimentCapillaryGelElectrophoresisSDSOptions",
		"ValidExperimentCapillaryGelElectrophoresisSDSQ",
		"PlotCapillaryGelElectrophoresisSDS",
		"ExperimentCapillaryIsoelectricFocusing",
		"ExperimentSolidPhaseExtraction"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author->{"xu.yi", "gil.sharon"}
}];



(* ::Subsubsection::Closed:: *)
(*ExperimentCapillaryGelElectrophoresisSDSOptions*)

DefineUsage[ExperimentCapillaryGelElectrophoresisSDSOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentCapillaryGelElectrophoresisSDSOptions[Samples]", "ResolvedOptions"},
				Description->"generates the 'ResolvedOptions' for performing a capillary gel electrophoresis SDS experiment on the provided 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples to be electrophorated through a separating matrix. The recommended final protein concentration (reduced or non-reduced) per sample is 0.2-1.5 mg/mL in 50-200 \[Mu]L (total of 10 \[Mu]g - 300 \[Mu]g protein) for input with less than 50 mM salt.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options describing how the Capillary Gel Electrophoresis SDS experiment is run when ExperimentCapillaryGelElectrophoresisSDS is called on the input samples.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation->{
			"The options returned by ExperimentCapillaryGelElectrophoresisSDSOptions may be passed directly to ExperimentCapillaryGelElectrophoresisSDS."
		},
		SeeAlso->{
			"ExperimentCapillaryGelElectrophoresisSDS",
			"ValidExperimentCapillaryGelElectrophoresisSDSQ",
			"PlotCapillaryGelElectrophoresisSDS"
		},
		Author->{"xu.yi", "gil.sharon"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ValidExperimentCapillaryGelElectrophoresisSDSQ*)


DefineUsage[ValidExperimentCapillaryGelElectrophoresisSDSQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidExperimentCapillaryGelElectrophoresisSDSQ[Samples]", "Boolean"},
				Description->"checks whether the provided 'Samples' and specified options are valid for calling ExperimentCapillaryGelElectrophoresisSDS.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples to be electrophorated through a separating matrix. The recommended final protein concentration (reduced or non-reduced) per sample is 0.2-1.5 mg/mL in 50-200 \[Mu]L (total of 10 \[Mu]g - 300 \[Mu]g protein) for input with less than 50 mM salt.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
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
			"ExperimentCapillaryGelElectrophoresisSDS",
			"ExperimentCapillaryGelElectrophoresisSDSOptions",
			"PlotCapillaryGelElectrophoresisSDS"
		},
		Author->{"xu.yi", "gil.sharon"}
	}
];



DefineUsage[ExperimentCapillaryGelElectrophoresisSDSPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentCapillaryGelElectrophoresisSDSPreview[Samples]","Preview"},
				Description->"returns a graphical preview of the Capillary Gel Electrophoresis SDS experiment defined for 'Samples'. This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The samples to be electrophorated through a separating matrix. The recommended final protein concentration (reduced or non-reduced) per sample is 0.2-1.5 mg/mL in 50-200 \[Mu]L (total of 10 \[Mu]g - 300 \[Mu]g protein) for input with less than 50 mM salt.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									ObjectTypes -> {Object[Sample], Object[Container]},
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									}
								],
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]}
								]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"A graphical preview of the ExperimentCapillaryGelElectrophoresisSDS output. Return value can be changed via the OutputFormat option.",
						Pattern:>Null
					}
				}
			}
		},
		MoreInformation->{
			"Due to the nature of ExperimentCapillaryGelElectrophoresisSDS, no graphical preview is available for ExperimentCapillaryGelElectrophoresisSDS. ExperimentCapillaryGelElectrophoresisSDSPreview always returns Null."
		},
		SeeAlso->{
			"ExperimentCapillaryGelElectrophoresisSDS",
			"ExperimentCapillaryGelElectrophoresisSDSOptions",
			"ValidExperimentCapillaryGelElectrophoresisSDSQ",
			"PlotCapillaryGelElectrophoresisSDS"
		},
		Author->{"xu.yi", "gil.sharon"}
	}
];