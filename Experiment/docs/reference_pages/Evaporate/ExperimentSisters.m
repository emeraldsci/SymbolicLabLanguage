(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ValidExperimentEvaporateQ*)


DefineUsage[ValidExperimentEvaporateQ,
	{
		BasicDefinitions-> {
			{
				Definition->{"ValidExperimentEvaporateQ[Samples]","Boolean"},
				Description->"checks whether the provided 'Samples' and specified options are valid for calling ExperimentEvaporate.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers that will be concentrated by evaporation.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Container,Plate],Object[Container,Vessel],Object[Sample]}],
									Dereference -> {
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
						OutputName -> "Boolean",
						Description -> "Whether or not the ExperimentEvaporate call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentEvaporate",
			"ExperimentEvaporateOptions",
			"ExperimentCentrifuge"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"dima", "malav.desai","steven", "simon.vu", "axu", "wyatt", "sarah", "stacey.lee"}
	}
];



(* ::Subsubsection:: *)
(*ExperimentEvaporatePreview*)


DefineUsage[ExperimentEvaporatePreview,
	{
		BasicDefinitions-> {
			{
				Definition->{"ExperimentEvaporatePreview[Samples]","Preview"},
				Description->"returns Null, as there is no graphical preview of the output of ExperimentEvaporate.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers that will be concentrated by evaporation.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Container,Plate],Object[Container,Vessel],Object[Sample]}],
									Dereference -> {
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
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentEvaporate.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentEvaporate",
			"ExperimentEvaporateOptions",
			"ValidExperimentEvaporateQ",
			"ExperimentCentrifuge"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"dima", "malav.desai","steven", "simon.vu", "axu", "wyatt", "sarah", "stacey.lee"}
	}
];


(* ::Subsubsection:: *)
(*ExperimentEvaporatePreview*)


DefineUsage[ExperimentEvaporateOptions,
	{
		BasicDefinitions-> {
			{
				Definition->{"ExperimentEvaporateOptions[Samples]","ResolvedOptions"},
				Description->"checks whether the provided samples and specified options are valid for calling ExperimentEvaporate.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Samples",
							Description-> "The samples or containers that will be concentrated by evaporation.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Container,Plate],Object[Container,Vessel],Object[Sample]}],
									Dereference -> {
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
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentEvaporate is called on the input sample(s).",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"ExperimentEvaporate",
			"ValidExperimentEvaporateQ",
			"ExperimentCentrifuge"
		},
		Tutorials->{
			"Sample Preparation"
		},
		Author->{"dima", "malav.desai","steven", "simon.vu", "axu", "wyatt", "sarah", "stacey.lee"}
	}
];