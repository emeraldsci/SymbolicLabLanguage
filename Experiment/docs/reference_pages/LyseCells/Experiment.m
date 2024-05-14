(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection:: *)
(*ExperimentLyseCells*)

DefineUsage[ExperimentLyseCells,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentLyseCells[Samples]", "Protocol"},
				Description -> "generates a 'Protocol' to rupture the cell membranes of the cells contained within the provided 'Samples'.",
				Inputs :> {
					IndexMatching[
						IndexName->"experiment samples",
						{
							InputName -> "Samples",
							Description-> "The cell samples whose membranes are to be ruptured.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
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
							],
							Expandable->False
						}
					]
				},
				Outputs:>{
					{
						OutputName -> "Protocol",
						Description -> "Protocol generated to disrupt the cell membranes of the cells in the input object(s) or container(s).",
						Pattern :> ObjectP[Object[Protocol,RoboticCellPreparation]]
					}
				}
			}
		},
		MoreInformation -> {
		},
		SeeAlso -> {
			"ExperimentLyseCellsOptions",
			"ValidExperimentLyseCellsQ",
			"UploadLyseCellsMethod",
			"ValidUploadLyseCellsMethodQ",
			"ExperimentRoboticCellPreparation",
			"ExperimentDissociateCells",
			"ExperimentExtractRNA",
			"ExperimentExtractGenomicDNA",
			"ExperimentExtractPlasmidDNA",
			"ExperimentExtractProtein",
			"ExperimentExtractOrganelle"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"tyler.pabst", "daniel.shlian"}
	}
];

(* ::Subsection:: *)
(*ValidExperimentLyseCellsQ*)


DefineUsage[ValidExperimentLyseCellsQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentLyseCellsQ[Samples]", "Boolean"},
				Description -> "returns a 'Boolean' indicating the validity of an ExperimentLyseCells call for rupturing cell membranes within the 'Samples'.",
				Inputs :> {
					IndexMatching[
						IndexName->"experiment samples",
						{
							InputName -> "Samples",
							Description-> "The cell samples whose membranes are to be ruptured.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
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
							],
							Expandable->False
						}
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "A True/False value indicating the validity of the provided ExperimentLyseCells call.",
						Pattern :> BooleanP
					}
				}
			}
		},
		MoreInformation -> {
			"This function runs a series of tests to ensure that the provided inputs/options, when passed to ExperimentLyseCells, will return a valid experiment."
		},
		SeeAlso -> {
			"ExperimentLyseCells",
			"ExperimentLyseCellsOptions",
			"ExperimentRoboticCellPreparation"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"tyler.pabst", "daniel.shlian"}
	}
];


(* ::Subsection:: *)
(*ExperimentLyseCellsOptions*)


DefineUsage[ExperimentLyseCellsOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentLyseCellsOptions[Samples]", "ResolvedOptions"},
				Description -> "generates the 'ResolvedOptions' for lysing the cell membranes contained within the provided 'Samples'.",
				Inputs :> {
					IndexMatching[
						IndexName->"experiment samples",
						{
							InputName -> "Samples",
							Description-> "The cell samples whose membranes are to be ruptured.",
							Widget->Alternatives[
								"Sample or Container"->Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
									Dereference->{
										Object[Container]->Field[Contents[[All,2]]]
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
							],
							Expandable->False
						}
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentLyseCellsOptions is called on the input samples.",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"The options returned by this function may be passed directly to ExperimentLyseCells."
		},
		SeeAlso -> {
			"ExperimentLyseCells",
			"ValidExperimentLyseCellsQ",
			"ExperimentRoboticSamplePreparation"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author -> {"tyler.pabst", "daniel.shlian"}
	}
];