(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*ExperimentDNASynthesis*)


(* ::Subsubsection::Closed:: *)
(*ExperimentDNASynthesis*)

DefineUsage[ExperimentDNASynthesis,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentDNASynthesis[OligomerModels]", "Protocol"},
				Description -> "creates a DNA Synthesis 'Protocol' to synthesize the 'OligomerModels'.",
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
						IndexName -> "experiment models"
					]
				},
				Outputs :> {
					{
						OutputName -> "Protocol",
						Description -> "A protocol to synthesize DNA.",
						Pattern :> ObjectP[Object[Protocol, DNASynthesis]]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentDNASynthesisOptions",
			"ValidExperimentDNASynthesisQ",
			"ExperimentRNASynthesis",
			"ExperimentPeptideSynthesis",
			"ExperimentPNASynthesis",
			"ExperimentSolidPhaseExtraction",
			"ExperimentVacuumEvaporation",
			"ExperimentHPLC",
			"ExperimentAbsorbanceSpectroscopy"
		},
		Author -> {"dirk.schild", "lei.tian", "ti.wu", "dima", "wyatt"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ValidExperimentDNASynthesisQ*)


DefineUsage[ValidExperimentDNASynthesisQ,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ValidExperimentDNASynthesisQ[OligomerModels]", "Boolean"},
				Description -> "checks whether the provided 'OligomerModels' and specified options are valid for calling ExperimentDNASynthesis.",
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
						IndexName -> "experiment models"
					]
				},
				Outputs :> {
					{
						OutputName -> "Boolean",
						Description -> "Whether or not the ExperimentDNASynthesis call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern :> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentDNASynthesis",
			"ExperimentDNASynthesisOptions",
			"ExperimentDNASynthesisPreview"
		},
		Author -> {"dirk.schild", "lei.tian", "ti.wu", "dima", "wyatt"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ExperimentDNASynthesisPreview*)


DefineUsage[ExperimentDNASynthesisPreview,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentDNASynthesisPreview[OligomerModels]", "Preview"},
				Description -> "returns Null, as there is no graphical preview of the output of ExperimentDNASynthesis.",
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
						IndexName -> "experiment models"
					]
				},
				Outputs :> {
					{
						OutputName -> "Preview",
						Description -> "Graphical preview representing the output of ExperimentDNASynthesis.  This value is always Null.",
						Pattern :> Null
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentDNASynthesis",
			"ExperimentDNASynthesisOptions",
			"ValidExperimentDNASynthesisQ"
		},
		Author -> {"dirk.schild", "lei.tian", "ti.wu", "dima", "wyatt"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentDNASynthesisOptions*)


DefineUsage[ExperimentDNASynthesisOptions,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ExperimentDNASynthesisOptions[OligomerModels]", "ResolvedOptions"},
				Description -> "checks whether the provided OligomerModels and specified options are valid for calling ExperimentDNASynthesis.",
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
						IndexName -> "experiment models"
					]
				},
				Outputs :> {
					{
						OutputName -> "ResolvedOptions",
						Description -> "Resolved options when ExperimentDNASynthesis is called on the input sample(s).",
						Pattern :> {Rule[_Symbol, Except[Automatic | $Failed]] | RuleDelayed[_Symbol, Except[Automatic | $Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentDNASynthesis",
			"ExperimentDNASynthesisPreview",
			"ValidExperimentDNASynthesisQ"
		},
		Author -> {"dirk.schild", "lei.tian", "ti.wu", "dima", "wyatt"}
	}
];