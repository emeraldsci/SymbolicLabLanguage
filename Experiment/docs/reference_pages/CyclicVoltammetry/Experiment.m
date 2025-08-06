(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExperimentCyclicVoltammetry*)

DefineUsage[ExperimentCyclicVoltammetry,
{
	BasicDefinitions -> {
	{
		Definition -> {"ExperimentCyclicVoltammetry[Objects]","Protocol"},
		Description -> "creates a 'Protocol' to perform the cyclic voltammetry measurements on the provided samples or container 'objects'. The cyclic voltammetry technique is mostly used to investigate the reduction and oxidation processes of molecular species, the reversibility of a chemical reaction, the diffusion coefficient of an interested analyte, and many other electrochemical behaviors.",
		Inputs :> {
		IndexMatching[
			{
			InputName -> "Objects",
			Description-> "The samples that should be measured. Container objects must house samples.",
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
			OutputName -> "Protocol",
			Description -> "Protocol generated to perform the cyclic voltammetry measurement on the input objects.",
			Pattern :> ListableP[ObjectP[Object[Protocol,CyclicVoltammetry]]]
			}
		}
	}
	},
	MoreInformation -> {},
	SeeAlso -> {
		"ExperimentCyclicVoltammetryOptions",
		"ValidExperimentCyclicVoltammetryQ",
		"ExperimentCyclicVoltammetryPreview",
		"ExperimentMeasureConductivity"
	},
	Author -> {"jireh.sacramento", "xu.yi", "steven", "qijue.wang"}
}
];

(* ::Subsubsection:: *)
(*ExperimentCyclicVoltammetryOptions*)

DefineUsage[ExperimentCyclicVoltammetryOptions,
{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentCyclicVoltammetryOptions[Objects]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentCyclicVoltammetryOptions when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers whose cyclic voltammogram will be measured.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									ObjectTypes->{Object[Sample],Object[Container]},
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
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
						Description -> "Resolved options when ExperimentCyclicVoltammetryOptions is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentCyclicVoltammetryOptions if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentCyclicVoltammetry",
			"ValidExperimentCyclicVoltammetryQ",
			"ExperimentCyclicVoltammetryPreview"
		},
		Author -> {"jireh.sacramento", "xu.yi", "steven", "qijue.wang"}
	}
];


(* ::Subsubsection:: *)
(*ValidExperimentCyclicVoltammetryQ*)

DefineUsage[ValidExperimentCyclicVoltammetryQ,
{
	BasicDefinitions -> {
		{
			Definition->{"ValidExperimentCyclicVoltammetryQ[Objects]","Booleans"},
			Description -> "checks if the provided 'objects' and specified options are valid for calling ExperimentCyclicVoltammetry.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "Objects",
						Description-> "The samples or containers whose cyclic voltammogram will be measured.",
						Widget->Alternatives[
							"Sample or Container" -> Widget[
								Type->Object,
								Pattern:>ObjectP[{Object[Sample],Object[Container]}],
								ObjectTypes->{Object[Sample],Object[Container]},
								Dereference->{
									Object[Container]->Field[Contents[[All,2]]]
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
					OutputName->"Booleans",
					Description -> "Whether or not the ExperimentCyclicVoltammetry call is valid. Return value can be changed via the OutputFormat option.",
					Pattern :> _EmeraldTestSummary| BooleanP
				}
			}
		}
	},
	MoreInformation -> {},
	SeeAlso -> {
		"ExperimentCyclicVoltammetry",
		"ExperimentCyclicVoltammetryOptions",
		"ExperimentCyclicVoltammetryPreview"
	},
	Tutorials->{
		"Sample Preparation"
	},
	Author -> {"jireh.sacramento", "xu.yi", "steven", "qijue.wang"}
}
];

(* ::Subsubsection:: *)
(*ExperimentCyclicVoltammetryPreview*)

DefineUsage[ExperimentCyclicVoltammetryPreview,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentCyclicVoltammetryPreview[Objects]","Preview"},
				Description -> "returns a graphical representation for the output of an ExperimentCyclicVoltammetry protocol. This 'Preview' is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The samples or containers whose cyclic voltammogram will be measured.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									ObjectTypes->{Object[Sample],Object[Container]},
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
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
						Description -> "A graphical representation for the output of an ExperimentCyclicVoltammetry protocol. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentCyclicVoltammetry",
			"ExperimentCyclicVoltammetryOptions",
			"ValidExperimentCyclicVoltammetryQ"
		},
		Author -> {"jireh.sacramento", "xu.yi", "steven", "qijue.wang"}
	}
];