
(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ExperimentDilute*)


DefineUsage[ExperimentDilute,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentDilute[Sample]", "Protocol"},
				Description -> "generates a 'Protocol' to perform basic dilution of the provided liquid 'Sample' with some amount of solvent.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "Sample",
							Description -> "The sample to be diluted.",
							Widget -> Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									},
									PreparedSample -> False,
									PreparedContainer -> False
								],
								"Model Sample"->Widget[
									Type -> Object,
									Pattern :> ObjectP[Model[Sample]],
									ObjectTypes -> {Model[Sample]},
									OpenPaths -> {
										{
											Object[Catalog, "Root"],
											"Materials"
										}
									}
								]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "A protocol containing instructions for completion of the requested sample dilution.",
						Pattern :> ObjectP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, ManualCellPreparation], Object[Protocol, RoboticSamplePreparation], Object[Protocol, RoboticCellPreparation]}]
					}
				}
			}
		},
		MoreInformation -> {
			"This function serves as a simplified interface to ExperimentSamplePreparation.",
			"The SamplePreparation procedure is used to accomplish the dilution."
		},
		SeeAlso -> {
			"ValidExperimentDiluteQ",
			"ExperimentDiluteOptions",
			"ExperimentDilutePreview",
			"ExperimentSamplePreparation",
			"ExperimentAliquot",
			"ExperimentResuspend",
			"Transfer",
			"Mix",
			"Aliquot"
		},
		Author -> {"malav.desai", "waseem.vali", "ryan.bisbey", "boris.brenerman", "cgullekson", "steven"}
	}
];


(* ::Subsubsection:: *)
(*ExperimentDiluteOptions*)

DefineUsage[ExperimentDiluteOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentDiluteOptions[Objects]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentDiluteOptions when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The sample to be diluted.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									},
									PreparedSample -> False,
									PreparedContainer -> False
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
						Description -> "Resolved options when ExperimentDiluteOptions is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function returns the resolved options that would be fed to ExperimentDiluteOptions if it were called on these input objects."
		},
		SeeAlso -> {
			"ExperimentDilute",
			"ValidExperimentDiluteQ",
			"ExperimentDilutePreview",
			"ExperimentSamplePreparation",
			"ExperimentAliquot",
			"Transfer",
			"Mix",
			"Aliquot"
		},
		Author -> {"malav.desai", "waseem.vali", "ryan.bisbey", "boris.brenerman", "cgullekson", "steven"}
	}
];

(* ::Subsubsection:: *)
(*ExperimentDilutePreview*)

DefineUsage[ExperimentDilutePreview,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentDilutePreview[Objects]","Preview"},
				Description -> "returns the preview for ExperimentDilute when it is called on 'objects'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The sample to be diluted.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									},
									PreparedSample -> False,
									PreparedContainer -> False
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
						Description -> "Graphical preview representing the output of ExperimentDilute. This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentDilute",
			"ValidExperimentDiluteQ",
			"ExperimentDiluteOptions",
			"ExperimentSamplePreparation",
			"ExperimentAliquot",
			"Transfer",
			"Mix",
			"Aliquot"
		},
		Author -> {"malav.desai", "waseem.vali", "ryan.bisbey", "boris.brenerman", "cgullekson", "steven"}
	}
];

(* ::Subsubsection:: *)
(*ValidExperimentDiluteQ*)

DefineUsage[ValidExperimentDiluteQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentDiluteQ[Objects]","Booleans"},
				Description -> "checks whether the provided 'objects' and specified options are valid for calling ExperimentDilute.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "Objects",
							Description-> "The sample to be diluted.",
							Widget->Alternatives[
								"Sample or Container" -> Widget[
									Type -> Object,
									Pattern :> ObjectP[{Object[Sample], Object[Container]}],
									Dereference -> {
										Object[Container] -> Field[Contents[[All, 2]]]
									},
									PreparedSample -> False,
									PreparedContainer -> False
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
						Description -> "Whether or not the ExperimentDilute call is valid. Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary| BooleanP
					}
				}
			}
		},
		MoreInformation -> {},
		SeeAlso -> {
			"ExperimentDilute",
			"ExperimentDiluteOptions",
			"ExperimentDilutePreview",
			"ExperimentSamplePreparation",
			"ExperimentAliquot",
			"Transfer",
			"Mix",
			"Aliquot"
		},
		Author -> {"malav.desai", "waseem.vali", "ryan.bisbey", "boris.brenerman", "cgullekson", "steven"}
	}
];