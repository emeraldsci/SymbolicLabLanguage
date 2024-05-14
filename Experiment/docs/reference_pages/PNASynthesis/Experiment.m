(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*ExperimentPNASynthesis*)


DefineUsage[ExperimentPNASynthesis,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentPNASynthesis[OligomerModels]","Protocol"},
				Description->"uses a oligomer 'OligomerModels' to create a Peptide Nucleic Acid (PNA) Synthesis 'Protocol' and associated synthesis cycles methods.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "OligomerModels",
							Description-> "The oligomer models, sequence, strands or structures for each oligomer sample that will be created by the protocol.",
							Widget->Alternatives[
								"Oligomer Model" -> Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Model[Molecule,Oligomer]}],ObjectTypes->{Model[Sample],Model[Molecule,Oligomer]}],
								"Oligomer Strand" -> Widget[Type->Expression,Pattern:>StrandP,Size->Paragraph],
								"Oligomer String" -> Widget[Type->String,Pattern:>_?StringQ,Size->Word]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Protocol",
						Description->"The protocol object describing how to run the PNA synthesis experiment.",
						Pattern:>ListableP[ObjectP[Object[Protocol,PNASynthesis]]]
					}
				}
			}
		},
		MoreInformation -> {
			"This experiment function is used to create PNA oligomer strands from an oligomer model object.",
			"The maximum number of strands that can be synthesized in a single run is 12."
		},
		SeeAlso -> {
			"ValidExperimentPNASynthesisQ",
			"ExperimentPNASynthesisOptions",
			"ExperimentMassSpectrometry",
			"ExperimentHPLC",
			"ExperimentDNASynthesis"
		},
		Author->{"alou", "robert", "waltraud.mair"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidExperimentPNASynthesisQ*)


DefineUsage[ValidExperimentPNASynthesisQ,
	{
		BasicDefinitions -> {
			{
				Definition->{"ValidExperimentPNASynthesisQ[OligomerModels]","Boolean"},
				Description->"checks whether the provided 'OligomerModels' and specified options are valid for calling ExperimentPNASynthesis.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "OligomerModels",
							Description-> "The oligomer models, sequence, strands or structures for each oligomer sample that will be created by the protocol.",
							Widget->Alternatives[
								"Oligomer Model" -> Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Model[Molecule,Oligomer]}],ObjectTypes->{Model[Sample],Model[Molecule,Oligomer]}],
								"Oligomer Strand" -> Widget[Type->Expression,Pattern:>StrandP,Size->Paragraph],
								"Oligomer String" -> Widget[Type->String,Pattern:>_?StringQ,Size->Word]
							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Boolean",
						Description->"Whether or not the ExperimentPNASynthesis call is valid.  Return value can be changed via the OutputFormat option.",
						Pattern:> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		MoreInformation -> {
			"This experiment function is used to create PNA oligomer strands from an oligomer model object.",
			"The maximum number of strands that can be synthesized in a single run is 12."
		},
		SeeAlso -> {
			"ExperimentPNASynthesis",
			"ExperimentPNASynthesisOptions",
			"ExperimentMassSpectrometry",
			"ExperimentHPLC",
			"ExperimentDNASynthesis",
			"ExperimentPeptideSynthesis"
		},
		Author->{"alou", "robert", "waltraud.mair"}
	}
];



(* ::Subsubsection::Closed:: *)
(*ExperimentPNASynthesisPreview*)


DefineUsage[ExperimentPNASynthesisPreview,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentPNASynthesisPreview[OligomerModels]","Preview"},
				Description->"returns the graphical preview for ExperimentPNASynthesis when it is called on 'OligomerModels'.  This output is always Null.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "OligomerModels",
							Description-> "The oligomer models, sequence, strands or structures for each oligomer sample that will be created by the protocol.",
							Widget->Alternatives[
								"Oligomer Model" -> Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Model[Molecule,Oligomer]}],ObjectTypes->{Model[Sample],Model[Molecule,Oligomer]}],
								"Oligomer Strand" -> Widget[Type->Expression,Pattern:>StrandP,Size->Paragraph],
								"Oligomer String" -> Widget[Type->String,Pattern:>_?StringQ,Size->Word]

							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"Preview",
						Description->"Graphical preview representing the output of ExperimentPNASynthesis.  This value is always Null.",
						Pattern:> _EmeraldTestSummary | BooleanP
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentPNASynthesis",
			"ExperimentPNASynthesisOptions",
			"ValidExperimentPNASynthesisQ",
			"ExperimentMassSpectrometry",
			"ExperimentHPLC",
			"ExperimentDNASynthesis",
			"ExperimentPeptideSynthesis"
		},
		Author->{"alou", "robert", "waltraud.mair"}
	}
];


(* ::Subsubsection::Closed:: *)
(*ExperimentPNASynthesisOptions*)


DefineUsage[ExperimentPNASynthesisOptions,
	{
		BasicDefinitions -> {
			{
				Definition->{"ExperimentPNASynthesisOptions[OligomerModels]","ResolvedOptions"},
				Description->"returns the resolved options for ExperimentPNASynthesis when it is called on 'OligomerModels'.",
				Inputs:>{
					IndexMatching[
						{
							InputName -> "OligomerModels",
							Description-> "The oligomer models, sequence, strands or structures for each oligomer sample that will be created by the protocol.",
							Widget->Alternatives[
								"Oligomer Model" -> Widget[Type->Object,Pattern:>ObjectP[{Model[Sample],Model[Molecule,Oligomer]}],ObjectTypes->{Model[Sample],Model[Molecule,Oligomer]}],
								"Oligomer Strand" -> Widget[Type->Expression,Pattern:>StrandP,Size->Paragraph],
								"Oligomer String" -> Widget[Type->String,Pattern:>_?StringQ,Size->Word]

							],
							Expandable->False
						},
						IndexName->"experiment samples"
					]
				},
				Outputs:>{
					{
						OutputName->"ResolvedOptions",
						Description->"Resolved options when ExperimentPNASynthesis is called on the input objects.",
						Pattern :> {Rule[_Symbol,Except[Automatic|$Failed]]|RuleDelayed[_Symbol,Except[Automatic|$Failed]]...}
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentPNASynthesis",
			"ValidExperimentPNASynthesisQ",
			"ExperimentMassSpectrometry",
			"ExperimentHPLC",
			"ExperimentDNASynthesis",
			"ExperimentPeptideSynthesis"
		},
		Author->{"alou", "robert", "waltraud.mair"}
	}
];






(* ::Subsubsection::Closed:: *)
(*ValidSynthesisStepQ*)


DefineUsage[ValidSynthesisStepQ,
	{
		BasicDefinitions -> {
			{"ValidSynthesisStepQ[synthesisPrimitive]", "result", "checks to see if 'synthesisPrimitive' has all required key and that it passes all tests associated with that solid phase synthesis primitive."}
		},
		MoreInformation -> {},
		Input :> {
			{"synthesisPrimitive", ListableP[Alternatives[_Washing,_Swelling,_Capping,_Deprotecting,_Deprotonating, _Coupling, _Cleaving]], "The solid phase synthesis being tested for validity."}
		},
		Output :> {
			{"result", ListableP[BooleanP], "The result boolean(s) indicating the validity of the provided resources."}
		},
		SeeAlso -> {
			"ExperimentPNASynthesis",
			"ExperimentPeptideSynthesis",
			"ExperimentDNASynthesis",
			"Washing",
			"Swelling",
			"Capping",
			"Deprotecting",
			"Deprotonating",
			"Couple",
			"Coupling",
			"Cleaving"
		},
		Author -> {"alou", "robert", "waltraud.mair"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Washing*)


DefineUsage[Washing,
	{
		BasicDefinitions -> {
			{"Washing[washingRules]","primitive","generates a solid phase synthesis 'primitive' that describes how previous step's chemicals will be removed from resin by flowing solvent through it into waste."}
		},
		MoreInformation->{
			"The following keys can be used as inputs to the primitive:",
			Grid[
				{
					{"Key","Value Pattern","Description"},
					{"Sample","ObjectP[{Object[Sample],Model[Sample]}]", "The solution which will be used to perform the wash."},
					{"Time","GreaterP[0 Second]","The amount of time for which the wash solution will be mixed with the resin."},
					{"Volume","GreaterP[0 Microliter]","The volume of wash solution used."},
					{"NumberOfReplicates","GreaterP[0]","Number of times the wash step will be repeated."}
				}
			]
		},
		Input:>{
			{
				"washingRules",
				{
					Sample->ObjectP[{Object[Sample],Model[Sample],Object[Sample],Model[Sample,StockSolution]}],
					Time->GreaterP[0 Second],
					Volume->GreaterP[0 Microliter],
					NumberOfReplicates->GreaterP[0]
				},
				"Specific key/value pairs specifying conditions to be used to wash a synthesis vessel."
			}
		},
		Output:>{{"primitive",SynthesisCycleStepP,"A solid phase synthesis primitive containing information for executing a wash step during the synthesis."}},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentPNASynthesis",
			"ExperimentDNASynthesis",
			"Swelling",
			"Capping",
			"Deprotecting",
			"Deprotonating",
			"Couple",
			"Coupling",
			"Cleaving"
		},
		Author->{"alou", "robert"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Swelling*)


DefineUsage[Swelling,
	{
		BasicDefinitions -> {
			{"Swelling[swellRules]","primitive","generates an solid phase synthesis 'primitive' that describes how resin chains will be solvated in order to expose linker sites used as start points for solid phase synthesis."}
		},
		MoreInformation->{
			"The following keys can be used as inputs to the primitive:",
			Grid[
				{
					{"Key","Value Pattern","Description"},
					{"Sample","ObjectP[{Object[Sample],Model[Sample]}]", "The solution which will be used to perform the swell."},
					{"Time","GreaterP[0 Second]","The amount of time for which the swell solution will be mixed with the resin."},
					{"Volume","GreaterP[0 Microliter]","The volume of swell solution used."},
					{"NumberOfReplicates","GreaterP[0]","Number of times the swell step will be repeated."}
				}
			]
		},
		Input:>{
			{
				"swellRules",
				{
					Sample->ObjectP[{Object[Sample],Model[Sample]}],
					Time->GreaterP[0 Second],
					Volume->GreaterP[0 Microliter],
					NumberOfReplicates->GreaterP[0]
				},
				"Specific key/value pairs specifying conditions to be used to swell resin."
			}
		},
		Output:>{{"primitive",SynthesisCycleStepP,"A solid phase synthesis primitive containing information for executing a swell step during the synthesis."}},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentPNASynthesis",
			"ExperimentDNASynthesis",
			"Washing",
			"Capping",
			"Deprotecting",
			"Deprotonating",
			"Couple",
			"Coupling",
			"Cleaving"
		},
		Author->{"alou", "robert"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Capping*)


DefineUsage[Capping,
	{
		BasicDefinitions -> {
			{"Capping[cappingRules]","primitive","generates an solid phase synthesis 'primitive' that describes how a blocking group is chemically coupled to a strand during solid phase synthesis."}
		},
		MoreInformation->{
			"The following keys can be used as inputs to the primitive:",
			Grid[
				{
					{"Key","Value Pattern","Description"},
					{"Sample","ObjectP[{Object[Sample],Model[Sample],Object[Sample],Model[Sample,StockSolution]}]", "The solution which will be used to perform the capping."},
					{"Time","GreaterP[0 Second]","The amount of time for which the capping solution will be mixed with the resin."},
					{"Volume","GreaterP[0 Microliter]","The volume of capping solution used."},
					{"NumberOfReplicates","GreaterP[0]","Number of times the capping step will be repeated."}
				}
			]
		},
		Input:>{
			{
				"cappingRules",
				{
					Sample->ObjectP[{Object[Sample],Model[Sample],Object[Sample],Model[Sample,StockSolution]}],
					Time->GreaterP[0 Second],
					Volume->GreaterP[0 Microliter],
					NumberOfReplicates->GreaterP[0]
				},
				"Specific key/value pairs specifying conditions to be used to cap a strand being synthesized."
			}
		},
		Output:>{{"primitive",SynthesisCycleStepP,"A solid phase synthesis primitive containing information for executing a capping step during the synthesis."}},
		SeeAlso -> {
			"ExperimentPNASynthesis",
			"ExperimentDNASynthesis",
			"Washing",
			"Deprotecting",
			"Deprotonating",
			"Couple",
			"Coupling",
			"Cleaving"
		},
		Author->{"alou", "robert"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Deprotecting*)


DefineUsage[Deprotecting,
	{
		BasicDefinitions -> {
			{"Deprotecting[deprotectionRules]","primitive","generates an solid phase synthesis 'primitive' that describes how a blocking group is chemically eliminated from a strand during solid phase synthesis."}
		},
		MoreInformation->{
			"The following keys can be used as inputs to the primitive:",
			Grid[
				{
					{"Key","Value Pattern","Description"},
					{"Sample","ObjectP[{Object[Sample],Model[Sample],Object[Sample],Model[Sample,StockSolution]}]", "The solution which will be used to perform the deprotection."},
					{"Time","GreaterP[0 Second]","The amount of time for which the deprotection solution will be mixed with the resin."},
					{"Volume","GreaterP[0 Microliter]","The volume of deprotection solution used."},
					{"NumberOfReplicates","GreaterP[0]","Number of times the deprotection step will be repeated."}
				}
			]
		},
		Input:>{
			{
				"deprotectionRules",
				{
					Sample->ObjectP[{Object[Sample],Model[Sample],Object[Sample],Model[Sample,StockSolution]}],
					Time->GreaterP[0 Second],
					Volume->GreaterP[0 Microliter],
					NumberOfReplicates->GreaterP[0]
				},
				"Specific key/value pairs specifying conditions to be used to deprotect a strand being synthesized."
			}
		},
		Output:>{{"primitive",SynthesisCycleStepP,"A solid phase synthesis primitive containing information for executing a deprotection step during the synthesis."}},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentPNASynthesis",
			"ExperimentDNASynthesis",
			"Washing",
			"Capping",
			"Deprotonating",
			"Couple",
			"Coupling",
			"Cleaving"
		},
		Author->{"alou", "robert"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Deprotonating*)


DefineUsage[Deprotonating,
	{
		BasicDefinitions -> {
			{"Deprotonating[deprotonationRules]","primitive","generates an solid phase synthesis 'primitive' that describes how a proton is removed from a strand during solid phase synthesis."}
		},
		MoreInformation->{
			"The following keys can be used as inputs to the primitive:",
			Grid[
				{
					{"Key","Value Pattern","Description"},
					{"Sample","ObjectP[{Object[Sample],Model[Sample],Object[Sample],Model[Sample,StockSolution]}]", "The solution which will be used to perform the deprotonation."},
					{"Time","GreaterP[0 Second]","The amount of time for which the deprotonation solution will be mixed with the resin."},
					{"Volume","GreaterP[0 Microliter]","The volume of deprotonation solution used."},
					{"NumberOfReplicates","GreaterP[0]","Number of times the deprotonation step will be repeated."}
				}
			]
		},
		Input:>{
			{
				"deprotonationRules",
				{
					Sample->ObjectP[{Object[Sample],Model[Sample],Object[Sample],Model[Sample,StockSolution]}],
					Time->GreaterP[0 Second],
					Volume->GreaterP[0 Microliter],
					NumberOfReplicates->GreaterP[0]
				},
				"Specific key/value pairs specifying conditions to be used to deprotonate a strand being synthesized."
			}
		},
		Output:>{{"primitive",SynthesisCycleStepP,"A solid phase synthesis primitive containing information for executing a deprotonation step during the synthesis."}},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentPNASynthesis",
			"ExperimentDNASynthesis",
			"Washing",
			"Capping",
			"Deprotecting",
			"Couple",
			"Coupling",
			"Cleaving"
		},
		Author->{"alou", "robert"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Coupling*)


DefineUsage[Coupling,
	{
		BasicDefinitions -> {
			{"Coupling[couplingRules]","primitive","generates an solid phase synthesis 'primitive' that describes the reagents and conditions to be used for monomer activation via formation of a reactive esters and coupling of that monomer to the strand being synthesized."}
		},
		MoreInformation->{
			"When using the Coupling primitive, the activating solution can be specified as a single Activator solution, or two seperate Preactivator and Base solutions.",
			"The following keys can be used as inputs to the primitive:",
			Grid[
				{
					{"Key","Value Pattern","Description"},
					{"Monomer","ObjectP[{Object[Sample],Model[Sample],Object[Sample],Model[Sample,StockSolution]}]", "The monomer solution which will be activated via formation of a reactive ester."},
					{"MonomerVolume","GreaterP[0 Microliter]", "The volume of monomer solution used."},

					{"Activator","ObjectP[{Object[Sample],Model[Sample],Object[Sample],Model[Sample,StockSolution]}]", "The solution which will be used to perform the activation of the monomer."},
					{"ActivatorVolume","GreaterP[0 Microliter]", "The volume of activator solution used."},

					{"Preactivator","ObjectP[{Object[Sample],Model[Sample],Object[Sample],Model[Sample,StockSolution]}]", "The solution which, in conjunction with the Base solution, will be used to perform the activation of the monomer."},
					{"PreactivatorVolume","GreaterP[0 Microliter]", "The volume of preactivator solution used."},

					{"Base","ObjectP[{Object[Sample],Model[Sample],Object[Sample],Model[Sample,StockSolution]}]", "The solution which, in conjunction with the Preactivator solution, will be used to perform the activation of the monomer."},
					{"BaseVolume", "GreaterP[0 Microliter]","The volume of base solution used."},

					{"ActivationTime","GreaterP[0 Second]", "The amount of time for which the monomer will be mixed in the activation solution(s)."},
					{"CouplingTime","GreaterP[0 Second]", "The amount of time for which the activated monomer will be coupled to the resin."}
				}
			]
		},
		Input:>{
			{
				"couplingRules",
				{
					Monomer->ObjectP[{Object[Sample],Model[Sample],Object[Sample],Model[Sample,StockSolution]}],
					MonomerVolume->GreaterP[0 Microliter],

					Activator->ObjectP[{Object[Sample],Model[Sample],Object[Sample],Model[Sample,StockSolution]}],
					ActivatorVolume->GreaterP[0 Microliter],

					Preactivator->ObjectP[{Object[Sample],Model[Sample],Object[Sample],Model[Sample,StockSolution]}],
					PreactivatorVolume->GreaterP[0 Microliter],

					Base->ObjectP[{Object[Sample],Model[Sample],Object[Sample],Model[Sample,StockSolution]}],
					BaseVolume->GreaterP[0 Microliter],

					ActivationTime->GreaterP[0 Second],
					CouplingTime->GreaterP[0 Second]
				},
				"Specific key/value pairs specifying conditions to be used to activate a monomer during synthesis."
			}
		},
		Output:>{{"primitive",_Wash,"A solid phase synthesis primitive containing information for executing a monomer activation step during the synthesis."}},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentPNASynthesis",
			"ExperimentDNASynthesis",
			"Washing",
			"Capping",
			"Deprotecting",
			"Deprotonating",
			"Couple",
			"Cleaving"
		},
		Author->{"alou", "robert"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Cleaving*)


DefineUsage[Cleaving,
	{
		BasicDefinitions -> {
			{"Cleaving[cleavageRules]","primitive","generates an solid phase synthesis 'primitive' that describes how the synthesized strand is removed from its solid support after the end of solid phase synthesis."}
		},
		MoreInformation->{
			"The following keys can be used as inputs to the primitive:",
			Grid[
				{
					{"Key","Value Pattern","Description"},
					{"Sample","ObjectP[{Object[Sample],Model[Sample],Object[Sample],Model[Sample,StockSolution]}]", "The solution which will be used to perform the cleavage."},
					{"Time","GreaterP[0 Second]","The amount of time for which the cleavage solution will be mixed with the resin."},
					{"Volume","GreaterP[0 Microliter]","The volume of cleavage solution used."},
					{"NumberOfReplicates","GreaterP[0]","Number of times the cleavage step will be repeated."}
				}
			]
		},
		Input:>{
			{
				"cleavageRules",
				{
					Sample->ObjectP[{Object[Sample],Model[Sample],Object[Sample],Model[Sample,StockSolution]}],
					Time->GreaterP[0 Second],
					Volume->GreaterP[0 Microliter],
					NumberOfReplicates->GreaterP[0]
				},
				"Specific key/value pairs specifying conditions to be used to cleave a strand after solid phase synthesis."
			}
		},
		Output:>{{"primitive",SynthesisCycleStepP,"A solid phase synthesis primitive containing information for executing a cleavage step after the synthesis."}},
		Sync -> Automatic,
		SeeAlso -> {
			"ExperimentPNASynthesis",
			"ExperimentDNASynthesis",
			"Washing",
			"Capping",
			"Deprotecting",
			"Deprotonating",
			"Couple",
			"Coupling"
		},
		Author->{"alou", "robert"}
	}
];