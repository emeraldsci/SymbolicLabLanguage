(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ExperimentRNASynthesis*)

(* ::Subsubsection::Closed:: *)
(*Options for ExperimentRNASynthesis *)

DefineUsage[ExperimentRNASynthesis,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentRNASynthesis[OligomerModels]", "Protocol"},
				Description -> "creates a RNA Synthesis 'Protocol' to synthesize the 'OligomerModels'.",
				MoreInformation -> {
					"Each protocol can hold up to 48 strands and 3 modifications due to instrument constraints."
				},
				Inputs :> {
					IndexMatching[
						{
							InputName -> "OligomerModels",
							Description -> "The oligomer models that will be synthesized.",
							Widget -> Alternatives[
								"Oligomer Model" -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Sample], Model[Molecule, Oligomer]}], ObjectTypes -> {Model[Sample], Model[Molecule, Oligomer]}],
								"Oligomer Strand" -> Widget[Type -> Expression, Pattern :> StrandP, Size -> Paragraph],
								"Oligomer Structure" -> Widget[Type -> Expression, Pattern :> StructureP, Size -> Paragraph],
								"Oligomer String" -> Widget[Type -> String, Pattern :> _?StringQ, Size -> Word]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "A protocol to synthesize RNA.",
						Pattern :> ObjectP[Object[Protocol, RNASynthesis]]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentRNASynthesisOptions",
			"ValidExperimentRNASynthesisQ",
			"ExperimentDNASynthesis",
			"ExperimentPeptideSynthesis",
			"ExperimentPNASynthesis",
			"ExperimentSolidPhaseExtraction",
			"ExperimentVacuumEvaporation",
			"ExperimentHPLC",
			"ExperimentAbsorbanceSpectroscopy"
		},
		Author -> {"ryan.bisbey", "andrey.shur", "robert", "ti.wu", "dima"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentRNASynthesisPreview*)

DefineUsage[ExperimentRNASynthesisPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentRNASynthesisPreview[OligomerModels]", "Preview"},
				Description -> "returns Null, as there is no graphical preview of the output of ExperimentRNASynthesis.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "OligomerModels",
							Description -> "The oligomer models that will be synthesized.",
							Widget -> Alternatives[
								"Oligomer Model" -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Sample], Model[Molecule, Oligomer]}], ObjectTypes -> {Model[Sample], Model[Molecule, Oligomer]}],
								"Oligomer Strand" -> Widget[Type -> Expression, Pattern :> StrandP, Size -> Paragraph],
								"Oligomer String" -> Widget[Type -> String, Pattern :> _?StringQ, Size -> Word]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentRNASynthesis.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentRNASynthesis",
			"ExperimentRNASynthesisOptions",
			"ValidExperimentRNASynthesisQ"
		},
		Author -> {"ryan.bisbey", "andrey.shur", "robert", "ti.wu", "dima"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ValidExperimentRNASynthesisQ*)


DefineUsage[ValidExperimentRNASynthesisQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentRNASynthesisQ[OligomerModels]", "Boolean"},
				Description -> "checks whether the provided 'OligomerModels' and specified options are valid for calling ExperimentRNASynthesis.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "OligomerModels",
							Description -> "The oligomer models that will be synthesized.",
							Widget -> Alternatives[
								"Oligomer Model" -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Sample], Model[Molecule, Oligomer]}], ObjectTypes -> {Model[Sample], Model[Molecule, Oligomer]}],
								"Oligomer Strand" -> Widget[Type -> Expression, Pattern :> StrandP, Size -> Paragraph],
								"Oligomer String" -> Widget[Type -> String, Pattern :> _?StringQ, Size -> Word]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "Whether or not the ExperimentRNASynthesis call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentRNASynthesis",
			"ExperimentRNASynthesisOptions"
		},
		Author -> {"ryan.bisbey", "andrey.shur", "robert", "ti.wu", "dima"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ExperimentRNASynthesisOptions*)


DefineUsage[ExperimentRNASynthesisOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentRNASynthesisOptions[OligomerModels]", "ResolvedOptions"},
				Description -> "checks whether the provided OligomerModels and specified options are valid for calling ExperimentRNASynthesis.",
				Inputs :> {
					IndexMatching[
						{
							InputName -> "OligomerModels",
							Description -> "The oligomer models that will be synthesized.",
							Widget -> Alternatives[
								"Oligomer Model" -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Sample], Model[Molecule, Oligomer]}], ObjectTypes -> {Model[Sample], Model[Molecule, Oligomer]}],
								"Oligomer Strand" -> Widget[Type -> Expression, Pattern :> StrandP, Size -> Paragraph],
								"Oligomer String" -> Widget[Type -> String, Pattern :> _?StringQ, Size -> Word]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentRNASynthesis is called on the input sample(s).",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentRNASynthesis",
			"ExperimentRNASynthesisPreview",
			"ValidExperimentRNASynthesisQ"
		},
		Author -> {"jireh.sacramento", "xu.yi", "nont.kosaisawe", "dima"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Options for ExperimentRNASynthesis *)

DefineUsage[experimentNNASynthesis,
	{
		BasicDefinitions -> {
			{
				Definition -> {"experimentNNASynthesis[oligomerType, OligomerModels]", "Protocol"},
				Description -> "creates a 'oligomerType' Synthesis 'Protocol' to synthesize the 'OligomerModels'.",
				MoreInformation -> {
					"Each protocol can hold up to 48 strands and 3 modifications due to instrument constraints."
				},
				Inputs :> {
					{
						InputName-> "oligomerType",
						Description -> "Type of the oligomer being synthesized.",
						Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[DNA, RNA]],
						Expandable -> False
					},
					IndexMatching[
						{
							InputName -> "OligomerModels",
							Description -> "The oligomer models that will be synthesized.",
							Widget -> Alternatives[
								"Oligomer Model" -> Widget[Type -> Object, Pattern :> ObjectP[{Model[Sample], Model[Molecule, Oligomer]}], ObjectTypes -> {Model[Sample], Model[Molecule, Oligomer]}],
								"Oligomer Strand" -> Widget[Type -> Expression, Pattern :> StrandP, Size -> Paragraph],
								"Oligomer Structure" -> Widget[Type -> Expression, Pattern :> StructureP, Size -> Paragraph],
								"Oligomer String" -> Widget[Type -> String, Pattern :> _?StringQ, Size -> Word]
							],
							Expandable -> False
						},
						IndexName -> "experiment samples"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "A protocol to synthesize RNA.",
						Pattern :> ObjectP[Object[Protocol, RNASynthesis]]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentRNASynthesisOptions",
			"ValidExperimentRNASynthesisQ",
			"ExperimentDNASynthesis",
			"ExperimentPeptideSynthesis",
			"ExperimentPNASynthesis",
			"ExperimentSolidPhaseExtraction",
			"ExperimentVacuumEvaporation",
			"ExperimentHPLC",
			"ExperimentAbsorbanceSpectroscopy"
		},
		Author -> {"dima", "steven"}
	}
];