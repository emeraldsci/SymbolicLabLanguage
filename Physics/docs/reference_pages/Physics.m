(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*DNAPhosphoramiditeMolecularWeights*)


DefineUsage[DNAPhosphoramiditeMolecularWeights,
{
	BasicDefinitions -> {
		{"DNAPhosphoramiditeMolecularWeights[]", "{phosphoramiditeMolecularWeightRules}", "returns a list of the molecular weights (in grams/mole) of the DNA phosphoramidite monomer as rules."}
	},
	MoreInformation -> {
		""
	},
	Input :> {

	},
	Output :> {
		{"phosphoramiditeMolecularWeightRules", {(__ -> __)..}, "The molecular weights for each DNA phosphoramidite."}
	},
	SeeAlso -> {
		"ModifierPhosphoramiditeMolecularWeights",
		"PNAMolecularWeights"
	},
	Author -> {"taylor.hochuli", "harrison.gronlund", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*ModifierPhosphoramiditeMolecularWeights*)


DefineUsage[ModifierPhosphoramiditeMolecularWeights,
{
	BasicDefinitions -> {
		{"ModifierPhosphoramiditeMolecularWeights[]", "{modifierPhosphoramiditeMolecularWeightRules}", "returns a list of the molecular weights (in grams/mole) of the modifier phosphoramidite monomer as rules."}
	},
	MoreInformation -> {
		""
	},
	Input :> {

	},
	Output :> {
		{"modifierPhosphoramiditeMolecularWeightRules", {(__ -> __)..}, "The molecular weights of each modified phosphoramidite."}
	},
	SeeAlso -> {
		"DNAPhosphoramiditeMolecularWeights",
		"PNAMolecularWeights"
	},
	Author -> {"taylor.hochuli", "harrison.gronlund", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*PNAMolecularWeights*)


DefineUsage[PNAMolecularWeights,
{
	BasicDefinitions -> {
		{"PNAMolecularWeights[]", "{pnaReagentMolecularWeightRules}", "returns a list of the molecular weights for all PNA reagents."},
		{"PNAMolecularWeights[pnaType]", "{pnaReagentMolecularWeightRules}", "returns a list of the molecular weights for PNA reagents with the specified protecting group or geometry."}
	},
	MoreInformation -> {
		""
	},
	Input :> {
		{"pnaType", Boc | Fmoc | Gamma, "The specific protecting group type or geometry of the PNA."}
	},
	Output :> {
		{"pnaReagentMolecularWeightRules", {(__ -> __)..}, "The molecular weights of the PNA reagents."}
	},
	SeeAlso -> {
		"DNAPhosphoramiditeMolecularWeights",
		"ModifierPhosphoramiditeMolecularWeights"
	},
	Author -> {"tyler.pabst", "daniel.shlian", "thomas", "paul"}
}];

(* ::Subsubsection::Closed:: *)
(*thermodynamicParameters*)


DefineUsage[Physics`Private`thermodynamicParameters,
{
	BasicDefinitions -> {
		{"Physics`Private`thermodynamicParameters[polymer,parameter,type]", "paramRules", "returns list of stacking parameters for desired parameter and polymer."}
	},
	Input :> {
		{"polymer", PolymerP, "Polymer whose parameters are requested."},
		{"parameter", \[CapitalDelta]G | \[CapitalDelta]H | \[CapitalDelta]S, "Parameter whose parameters are requested."},
		{"type", Stacking | Loop | Mismatch, "Type of parameters requested."}
	},
	Output :> {
		{"paramRules", {(_String | _Symbol -> UnitsP[])..}, "List of parameter rules for all dimers of requested polymer type."}
	},
	SeeAlso -> {
		"Parameters",
		"SimulateFreeEnergy"
	},
	Author -> {
		"amir.saadat",
		"brad",
		"alice",
		"qian",
		"thomas"
	}
}];


(* ::Subsubsection::Closed:: *)
(*ValidPolymerQ*)


DefineUsage[ValidPolymerQ,
	{
		BasicDefinitions -> {
			{"ValidPolymerQ[polymer]", "isValid", "checks to see if the info contained in Parameters[polymer] is of correct construction."}
		},
		Input :> {
			{"polymer", _, "The name of the polymer you wish to examine (eg. DNA, RNA, Peptide)."}
		},
		Output :> {
			{"isValid", BooleanP, "True if the Parameters[polymer] pass all of the appropriate tests for validity."}
		},
		SeeAlso -> {
			"ValidPacketFormatQ",
			"ValidDatabaseQ"
		},
		Author -> {
			"amir.saadat",
			"brad"
		}
	}
];

(* ::Subsubsection::Closed:: *)
(*UploadModification*)


DefineUsage[UploadModification,
	{
		BasicDefinitions -> {
			{
				Definition -> {"UploadModification[ModificationName]", "modificationModel"},
				Description -> "creates a new Model[Physics,Modification] object 'modificationModel' with the name 'myModificationName'.",
				Inputs :> {
					{
						InputName -> "ModificationName",
						Description -> "The name of the modification to be created.",
						Widget -> Widget[Type -> Expression, Pattern :> _String, Size->Line],
						Expandable -> False
					}
				},
				Outputs :> {
					{
						OutputName -> "object",
						Description -> "An uploaded Model[Physics,Modification] object that pass the validity checks for its fields.",
						Pattern :> ObjectP[Model[Physics,Modification]]
					}
				}
			},
			{
				Definition -> {"UploadModification[TemplateObject]", "modificationModel"},
				Description -> "updates the pre-exisiting object 'myModificationObject'.",
				Inputs :> {
					{
						InputName -> "TemplateObject",
						Description -> "The name of the modification to be updated.",
						Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Physics,Modification]]],
						Expandable -> False
					}
				},
				Outputs :> {
					{
						OutputName -> "modificationModel",
						Description -> "An uploaded Model[Physics,Modification] object that pass the validity checks for its fields.",
						Pattern :> ObjectP[Model[Physics,Modification]]
					}
				}
			}
		},
		SeeAlso -> {
			"VaildPolymerQ",
			"MolecularWeight",
			"ExtinctionCoefficients",
			"SimulateFreeEnergy"
		},
		Author -> {"scicomp", "brad", "amir.saadat"}
	}
];