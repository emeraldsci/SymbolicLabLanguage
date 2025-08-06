(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(* ExperimentImageCellsPreview *)


DefineUsage[ExperimentImageCellsPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentImageCellsPreview[Samples]","Preview"},
				Description->"returns the graphical preview for ExperimentImageCells when it is called on 'Samples'. This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The sample(s) to be imaged.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
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
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"Graphical preview of the protocol object to be uploaded when calling ExperimentImageCells on 'Samples'. This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentImageCells",
			"ExperimentImageCellsOptions",
			"ValidExperimentImageCellsQ"
		},
		Author->{"melanie.reschke", "yanzhe.zhu", "varoth.lilascharoen", "cgullekson"}
	}
];


(* ::Subsubsection:: *)
(* ExperimentImageCellsOptions *)


DefineUsage[ExperimentImageCellsOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"ExperimentImageCellsOptions[Samples]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentImageCells when it is called on 'Samples'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The sample(s) to be imaged.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
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
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options when ExperimentImageCells is called on 'Samples'.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation->{
			"This function returns the resolved options that would be fed to ExperimentImageCells if it were called on 'Samples'."
		},
		SeeAlso->{
			"ExperimentImageCells",
			"ExperimentImageCellsPreview",
			"ValidExperimentImageCellsQ"
		},
		Author->{"melanie.reschke", "yanzhe.zhu", "varoth.lilascharoen", "cgullekson"}
	}
];


(* ::Subsubsection:: *)
(* ValidExperimentImageCellsQ *)


DefineUsage[ValidExperimentImageCellsQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidExperimentImageCellsQ[Samples]","Booleans"},
				Description->"checks whether the provided 'Samples' and the specified options are valid for calling ExperimentImageCells.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"Samples",
							Description->"The sample(s) to be imaged.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type->Object,
									Pattern:>ObjectP[{Object[Sample],Object[Container]}],
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
							Expandable->False,
							NestedIndexMatching->True
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Booleans",
						Description->"Whether or not the ExperimentImageCells call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		MoreInformation->{},
		SeeAlso->{
			"ExperimentImageCells",
			"ExperimentImageCellsOptions",
			"ExperimentImageCellsPreview"
		},
		Author->{"melanie.reschke", "yanzhe.zhu", "varoth.lilascharoen", "cgullekson"}
	}
];