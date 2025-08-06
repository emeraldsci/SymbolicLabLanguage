(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentAssembleCrossFlowFiltrationTubing*)

DefineUsage[ExperimentAssembleCrossFlowFiltrationTubing,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentAssembleCrossFlowFiltrationTubing[tubingModel, count]","protocol"},
				Description->"generates a new protocol to assemble cross flow filtration tubing.",
				Inputs:>{
					{
						InputName->"tubingModel",
						Description->"The cross flow filtration tubing model to be assembled.",
						Widget->Widget[
							Type->Object,
							Pattern :> ObjectP[Model[Plumbing,PrecutTubing]]
						],
						Expandable->False
					},
					{
						InputName->"count",
						Description->"The number of tubing objects to assemble.",
						Widget->Widget[
							Type->Number,
							Pattern :> GreaterP[0]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"protocol",
						Description->"The protocol uploaded by this function.",
						Pattern :>ObjectP[Object[Protocol,AssembleCrossFlowFiltrationTubing]]
					}
				}
			},
			{
				Definition->{"ExperimentAssembleCrossFlowFiltrationTubing[tubingModels, counts]","protocol"},
				Description->"generates a new protocol to assemble cross flow filtration tubing.",
				Inputs:>{
					{
						InputName->"tubingModels",
						Description->"The cross flow filtration tubing models to be assembled.",
						Widget->Adder[Widget[
								Type->Object,
								Pattern :> ObjectP[Model[Plumbing,PrecutTubing]]
							]
						],
						Expandable->False
					},
					{
						InputName->"counts",
						Description->"The number of tubing objects to assemble.",
						Widget->Adder[
							Widget[
								Type->Number,
								Pattern :> GreaterP[0]
							]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"protocol",
						Description->"The protocol uploaded by this function.",
						Pattern :>ObjectP[Object[Protocol,AssembleCrossFlowFiltrationTubing]]
					}
				}
			},
			{
				Definition->{"ExperimentAssembleCrossFlowFiltrationTubing[tubingModels]","protocol"},
				Description->"generates a new protocol to assemble cross flow filtration tubing.",
				Inputs:>{
					{
						InputName->"tubingModels",
						Description->"The cross flow filtration tubing models to be assembled.",
						Widget->Alternatives[
							Widget[
								Type->Object,
								Pattern :> ObjectP[Model[Plumbing,PrecutTubing]]
							],
							Adder[Widget[
								Type->Object,
								Pattern :> ObjectP[Model[Plumbing,PrecutTubing]]
							]]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"protocol",
						Description->"The protocol uploaded by this function.",
						Pattern :>ObjectP[Object[Protocol,AssembleCrossFlowFiltrationTubing]]
					}
				}
			}
		},
		MoreInformation->{
			"This function generates a new Protocol object to assemble cross flow filtration tubings."
		},
		SeeAlso->{
			"ExperimentCrossFlowFiltration",
			"ExperimentAssembleCrossFlowFiltrationTubingOptions",
			"ValidExperimentAssembleCrossFlowFiltrationTubingQ"
		},
		Author->{"yanzhe.zhu", "gil.sharon", "gokay.yamankurt"}
	}
];


(* ::Subsubsection:: *)
(*ExperimentAssembleCrossFlowFiltrationTubingOptions*)


DefineUsage[
	ExperimentAssembleCrossFlowFiltrationTubingOptions,
	{
		BasicDefinitions->{
			{"ExperimentAssembleCrossFlowFiltrationTubingOptions[tubingModels]","ResolvedOptions","generates the 'ResolvedOptions' for assembling cross flow filtration tubing."},
			{"ExperimentAssembleCrossFlowFiltrationTubingOptions[tubingModels,counts]","ResolvedOptions","generates the 'ResolvedOptions' for assembling cross flow filtration tubing."}
		},
		AdditionalDefinitions->{},
		Input:>{
			{"tubingModels",ListableP[ObjectP[Model[Plumbing,PrecutTubing]]],"The cross flow filtration tubing models to be assembled."},
			{"counts",ListableP[_Integer],"The number of tubing objects to assemble."}
		},
		Output:>{
			{"ResolvedOptions",{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...},"Resolved options describing how cross flow filtration tubing is assembled."}
		},
		MoreInformation->{
			"This function returns the options resolved by ExperimentAssembleCrossFlowFiltrationTubing."
		},
		SeeAlso->{
			"ExperimentCrossFlowFiltration",
			"ExperimentAssembleCrossFlowFiltrationTubing",
			"ValidExperimentAssembleCrossFlowFiltrationTubingQ"
		},
		Author->{"yanzhe.zhu", "gil.sharon", "gokay.yamankurt"}
	}
];


(* ::Subsubsection:: *)
(*ExperimentAssembleCrossFlowFiltrationTubingPreview*)


DefineUsage[
	ExperimentAssembleCrossFlowFiltrationTubingPreview,
	{
		BasicDefinitions->{
			{"ExperimentAssembleCrossFlowFiltrationTubingPreview[tubingModels]","Preview","returns a graphical preview of ExperimentAssembleCrossFlowFiltrationTubing."},
			{"ExperimentAssembleCrossFlowFiltrationTubingPreview[tubingModels,counts]","Preview","returns a graphical preview of ExperimentAssembleCrossFlowFiltrationTubing."}
		},
		AdditionalDefinitions->{},
		Input:>{
			{"tubingModels",ListableP[ObjectP[Model[Plumbing,PrecutTubing]]],"The cross flow filtration tubing models to be assembled."},
			{"counts",ListableP[_Integer],"The number of tubing objects to assemble."}
		},
		Output:>{
			{"Preview",Null,"A graphical preview of this function."}
		},
		MoreInformation->{
			"Due to the nature of ExperimentAssembleCrossFlowFiltrationTubing, no graphical preview is available. ExperimentAssembleCrossFlowFiltrationTubingPreview always returns Null."
		},
		SeeAlso->{
			"ExperimentCrossFlowFiltration",
			"ExperimentAssembleCrossFlowFiltrationTubing",
			"ValidExperimentAssembleCrossFlowFiltrationTubingQ",
			"ExperimentAssembleCrossFlowFiltrationTubingOptions"
		},
		Author->{"yanzhe.zhu", "gil.sharon", "gokay.yamankurt"}
	}
];


(* ::Subsubsection:: *)
(*ValidExperimentAssembleCrossFlowFiltrationTubingQ*)


DefineUsage[
	ValidExperimentAssembleCrossFlowFiltrationTubingQ,
	{
		BasicDefinitions->{
			{"ValidExperimentAssembleCrossFlowFiltrationTubingQ[tubingModels]","Boolean","generates a new protocol to assemble cross flow filtration tubing."},
			{"ValidExperimentAssembleCrossFlowFiltrationTubingQ[tubingModels,counts]","Boolean","generates a new protocol to assemble cross flow filtration tubing."}
		},
		AdditionalDefinitions->{},
		Input:>{
			{"tubingModels",ListableP[ObjectP[Model[Plumbing,PrecutTubing]]],"The cross flow filtration tubing models to be assembled."},
			{"counts",ListableP[_Integer],"The number of tubing objects to assemble."}
		},
		Output:>{
			{"Boolean",_EmeraldTestSummary|BooleanP,"The value indicating whether this call is valid as specified."}
		},
		MoreInformation->{
			"This function checks whether the provided 'tubingModels' and `counts` are valid for calling ExperimentAssembleCrossFlowFiltrationTubing."
		},
		SeeAlso->{
			"ExperimentCrossFlowFiltration",
			"ExperimentAssembleCrossFlowFiltrationTubing",
			"ExperimentAssembleCrossFlowFiltrationTubingPreview",
			"ExperimentAssembleCrossFlowFiltrationTubingOptions"
		},
		Author->{"yanzhe.zhu", "gil.sharon", "gokay.yamankurt"}
	}
];