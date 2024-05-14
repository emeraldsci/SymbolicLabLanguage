(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*UploadArrayCard*)


DefineUsage[UploadArrayCard,{
	BasicDefinitions->{
		{
			Definition->{"UploadArrayCard[PrimerPairs,Probes]","arrayCardModel"},
			Description->"creates a new 'arrayCardModel' with the pre-dried 'PrimerPairs' and 'Probes' for a quantitative polymerase chain reaction (qPCR) experiment.",
			Inputs:>{
				IndexMatching[
					{
						InputName->"PrimerPairs",
						Description->"The pairs of oligomer strands designed for amplifying nucleic acid targets from the templates, in rows (i.e. A1, A2, ...).",
						Widget->{
							"Forward Primer"->Widget[Type->Object,Pattern:>ObjectP[Model[Molecule,Oligomer]]],
							"Reverse Primer"->Widget[Type->Object,Pattern:>ObjectP[Model[Molecule,Oligomer]]]
						},
						Expandable->False
					},
					{
						InputName->"Probes",
						Description->"The target-specific oligomer strands containing reporter-quencher pairs that generate fluorescence during the target amplification, in rows (i.e. A1, A2, ...).",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Model[Molecule,Oligomer]]
						],
						Expandable->False
					},
					IndexName->"detection reagents"
				]
			},
			Outputs:>{
				{
					OutputName->"arrayCardModel",
					Description->"The model that represents this array card.",
					Pattern:>ObjectP[Model[Container,Plate,Irregular,ArrayCard]]
				}
			}
		}
	},
	MoreInformation->{
		"Each microfluidic array card contains 8 sample loading reservoirs and up to 8*48 sets of pre-dried primers and probes."
	},
	SeeAlso->{
		"UploadArrayCardOptions",
		"UploadArrayCardPreview",
		"ValidUploadArrayCardQ",
		"UploadOligomer",
		"UploadProduct",
		"ExperimentqPCR"
	},
	Author->{"ryan.bisbey", "dirk.schild", "weiran.wang", "eqian"}
}];


(* ::Subsubsection::Closed:: *)
(*UploadArrayCardOptions*)


DefineUsage[UploadArrayCardOptions,
	{
		BasicDefinitions->{
			{
				Definition->{"UploadArrayCardOptions[PrimerPairs,Probes]","ResolvedOptions"},
				Description->"returns the 'ResolvedOptions' for UploadArrayCard when it is called on the 'PrimerPairs' and 'Probes'.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"PrimerPairs",
							Description->"The pairs of oligomer strands designed for amplifying nucleic acid targets from the templates.",
							Widget->{
								"Forward Primer"->Widget[Type->Object,Pattern:>ObjectP[Model[Molecule,Oligomer]]],
								"Reverse Primer"->Widget[Type->Object,Pattern:>ObjectP[Model[Molecule,Oligomer]]]
							},
							Expandable->False
						},
						{
							InputName->"Probes",
							Description->"The target-specific oligomer strands containing reporter-quencher pairs that generate fluorescence during the target amplification.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[Model[Molecule,Oligomer]]
							],
							Expandable->False
						},
						IndexName->"detection reagents"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options when UploadArrayCard is called on the input primers and probes.",
						Pattern:>{Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso->{
			"UploadArrayCard",
			"UploadArrayCardPreview",
			"ValidUploadArrayCardQ",
			"UploadOligomer",
			"UploadProduct",
			"ExperimentqPCR"
		},
		Author->{"ryan.bisbey", "dirk.schild", "weiran.wang", "eqian"}
	}
];


(* ::Subsubsection:: *)
(*UploadArrayCardPreview*)


DefineUsage[UploadArrayCardPreview,
	{
		BasicDefinitions->{
			{
				Definition->{"UploadArrayCardPreview[PrimerPairs,Probes]","Preview"},
				Description->"returns the graphical 'Preview' for UploadArrayCard when it is called on the 'PrimerPairs' and 'Probes'. This preview is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"PrimerPairs",
							Description->"The pairs of oligomer strands designed for amplifying nucleic acid targets from the templates.",
							Widget->{
								"Forward Primer"->Widget[Type->Object,Pattern:>ObjectP[Model[Molecule,Oligomer]]],
								"Reverse Primer"->Widget[Type->Object,Pattern:>ObjectP[Model[Molecule,Oligomer]]]
							},
							Expandable->False
						},
						{
							InputName->"Probes",
							Description->"The target-specific oligomer strands containing reporter-quencher pairs that generate fluorescence during the target amplification.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[Model[Molecule,Oligomer]]
							],
							Expandable->False
						},
						IndexName->"detection reagents"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"Graphical preview representing the output of UploadArrayCard. This value is always Null.",
						Pattern:>Null
					}
				}
			}
		},
		SeeAlso->{
			"UploadArrayCard",
			"UploadArrayCardOptions",
			"ValidUploadArrayCardQ",
			"UploadOligomer",
			"UploadProduct",
			"ExperimentqPCR"
		},
		Author->{"ryan.bisbey", "dirk.schild", "weiran.wang", "eqian"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadArrayCardQ*)


DefineUsage[ValidUploadArrayCardQ,
	{
		BasicDefinitions->{
			{
				Definition->{"ValidUploadArrayCardQ[PrimerPairs,Probes]","Boolean"},
				Description->"checks whether the provided inputs are valid for calling UploadArrayCard.",
				Inputs:>{
					IndexMatching[
						{
							InputName->"PrimerPairs",
							Description->"The pairs of oligomer strands designed for amplifying nucleic acid targets from the templates.",
							Widget->{
								"Forward Primer"->Widget[Type->Object,Pattern:>ObjectP[Model[Molecule,Oligomer]]],
								"Reverse Primer"->Widget[Type->Object,Pattern:>ObjectP[Model[Molecule,Oligomer]]]
							},
							Expandable->False
						},
						{
							InputName->"Probes",
							Description->"The target-specific oligomer strands containing reporter-quencher pairs that generate fluorescence during the target amplification.",
							Widget->Widget[
								Type->Object,
								Pattern:>ObjectP[Model[Molecule,Oligomer]]
							],
							Expandable->False
						},
						IndexName->"detection reagents"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"Whether or not the UploadArrayCard call is valid. Return value can be changed via the OutputFormat option.",
						Pattern:>_EmeraldTestSummary|BooleanP
					}
				}
			}
		},
		SeeAlso->{
			"UploadArrayCard",
			"UploadArrayCardOptions",
			"UploadArrayCardPreview",
			"UploadOligomer",
			"UploadProduct",
			"ExperimentqPCR"
		},
		Author->{"ryan.bisbey", "dirk.schild", "weiran.wang", "eqian"}
	}
];