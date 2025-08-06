(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*ExtinctionCoefficient*)


DefineUsage[ExtinctionCoefficient,
{
	BasicDefinitions -> {
		{"ExtinctionCoefficient[n]", "extinction", "determines the extinction coefficent at 260 (nm) of an average sequence of length n."},
		{"ExtinctionCoefficient[sequence]", "extinction", "determines the extinction coefficent at 260 (nm) of the provided sequence."},
		{"ExtinctionCoefficient[strand]", "extinction", "determine the extinction coefficent at 260 (nm) of the provided strand."},
		{"ExtinctionCoefficient[structure]", "extinction", "determine the extinction coefficent at 260 (nm) of the provided structure."},
		{"ExtinctionCoefficient[object]", "extinction", "determine the extinction coefficent at 260 (nm) of the provided object."}
	},
	Input :> {
		{"n", _Integer, "A sequence of length n you wish to obtain the extinction coefficent of."},
		{"sequence", _?SequenceQ, "The sequence you wish to obtain the extinction coefficent of."},
		{"strand", _?StrandQ, "The strand you wish to obtain the extinction coefficent of."},
		{"structure", _?StructureQ, "The structure you wish to obtain the extinction coefficent of."},
		{"object", ObjectP[Object[Sample]], "The sample oligomer object you wish to obtain the extinction coefficent of."}
	},
	MoreInformation -> {
		"The Extinction Coefficient calculation is based on the formula as described in Object[Report, Literature, \"id:pZx9jon4xKW9\"]: V. Bloomfield et al, \"Nucleic acids: structures, properties and functions.\" (2000) p174-176.",
		"For DNA, the extinction coefficient and the hyperchromacity at 260 nm values can be found in Object[Report, Literature, \"id:kEJ9mqR5EmJB\"]: A. V. Tataurov et al, \"Predicting ultraviolet spectrum of single stranded and double stranded deoxyribonucleic acids.\" (2008) p66-70."
	},
	Output :> {
		{"extinction", _?ExtinctionCoefficientQ, "The extinction coefficent at 260 (nm) of the input."}
	},
	SeeAlso -> {
		"Hyperchromicity260",
		"MolecularWeight"
	},
	Author -> {"yanzhe.zhu", "amir.saadat", "brad"}
}];


(* ::Subsubsection:: *)
(*Hyperchromicity260*)


DefineUsage[Hyperchromicity260,
{
	BasicDefinitions -> {
		{"Hyperchromicity260[n]", "hyperchromicity", "determines the hyperchromicity correction for a sequence of length n."},
		{"Hyperchromicity260[sequence]", "hyperchromicity", "determine the hyperchromicity correction for the input sequence."}
	},
	Input :> {
		{"n", _Integer, "A sequence of length n you wish to obtain the hyperchromicity correction of."},
		{"sequence", SequenceP, "The sequence you wish to obtain the hyperchromicity correction for."}
	},
	Output :> {
		{"hyperchromicity", _, "The hyperchromicity correction for the input sequence."}
	},
	SeeAlso -> {
		"ExtinctionCoefficient",
		"MolecularWeight"
	},
	MoreInformation -> {
		"For DNA, the extinction coefficient and the hyperchromacity at 260 nm values can be found in Object[Report, Literature, \"id:kEJ9mqR5EmJB\"]: A. V. Tataurov et al, \"Predicting ultraviolet spectrum of single stranded and double stranded deoxyribonucleic acids.\" (2008) p66-70."
	},
	Author -> {"yanzhe.zhu", "amir.saadat", "brad"}
}];


(* ::Subsubsection:: *)
(*MolecularWeight*)


DefineUsage[MolecularWeight,
{
	BasicDefinitions -> {
		{"MolecularWeight[model]","weight","computes the molecular weight of a Model[Molecule] constellation object."},
		{"MolecularWeight[molecule]","weight","computes the molecular weight of a Molecule."},
		{"MolecularWeight[oligomer]", "weight", "computes the molecular weight of a sequence, strand, or structure."},
		{"MolecularWeight[n]", "weight", "computes the molecular weight of an average polymer of length n."}
	},
	Input :> {
		{"model",ObjectP[Model[Molecule]],"The Model[Molecule] constellation object you wish to obtain the molecular weight of."},
		{"molecule",_Molecule,"The Molecule[] entity you wish to obtain the molecular weight of."},
		{"oligomer", SequenceP|StrandP|StructureP, "The sequence, strand, or structure you wish to obtain the molecular weight of."},
		{"n", _Integer, "A sequence of length n you wish to estimate the molecular weight of."}
	},
	Output :> {
		{"weight", _?MolecularWeightQ, "The molecular weight of the input molecule."}
	},
	MoreInformation -> {
		"MolecularWeight computes average molecular mass assuming standard isotopic distributions."
	},
	SeeAlso -> {
		"MonoisotopicMass",
		"ExactMass",
		"ExtinctionCoefficient",
		"Hyperchromicity260"
	},
	Author -> {"yanzhe.zhu", "amir.saadat", "kevin.hou", "brad"}
}];


(* ::Subsubsection:: *)
(*MonoisotopicMass*)


DefineUsage[MonoisotopicMass,
{
	BasicDefinitions -> {
		{
			Definition -> {"MonoisotopicMass[molecule]","mass"},
			Description -> "computes the monoisotopic mass of 'molecule'.",
			Inputs:>{
				{
					InputName -> "molecule",
					Description -> "The molecule you wish to obtain the monoisotopic mass of.",
					Widget -> Widget[Type->Expression, Pattern:>Alternatives[_Molecule|ObjectP[Model[Molecule]]], Size->Word]
				}
			},
			Outputs:>{
				{
					OutputName -> "mass",
					Description -> "The monoisotopic mass of the input molecule.",
					Pattern :> UnitsP[Dalton]
				}
			}
		},
		{
			Definition -> {"MonoisotopicMass[oligomer]","mass"},
			Description -> "computes the monoisotopic mass of a sequence, strand, or structure.",
			Inputs:>{
				{
					InputName -> "oligomer",
					Description -> "The sequence, strand, or structure you wish to obtain the monoisotopic mass of.",
					Widget -> Widget[Type->Expression, Pattern:>Alternatives[SequenceP,StrandP,StructureP], Size->Word]
				}
			},
			Outputs:>{
				{
					OutputName -> "mass",
					Description -> "The monoisotopic mass of the input molecule.",
					Pattern :> UnitsP[Dalton]
				}
			}
		}
	},
	MoreInformation -> {
		"The monoisotopic mass is the exact mass of a molecule in which every atom exists as its most common isotope.",
		"This is distinct from the molecular mass, which is the average mass of a molecule according to its atomic isotopic distributions.",
		"Use ExactMass[] to compute the full distribution of possible molecular masses for an input molecule."
	},
	SeeAlso -> {
		"MolecularWeight",
		"ExactMass"
	},
	Author -> {"yanzhe.zhu", "olatunde.olademehin", "weiran.wang", "kevin.hou"}
}];


(* ::Subsubsection:: *)
(*ExactMass*)


DefineUsage[ExactMass,
{
	BasicDefinitions -> {
		{
			Definition -> {"ExactMass[molecule]","mass"},
			Description -> "computes the most probable exact mass of 'molecule'.",
			Inputs:>{
				{
					InputName -> "molecule",
					Description -> "The molecule you wish to obtain the exact mass of.",
					Widget -> Widget[Type->Expression, Pattern:>Alternatives[_Molecule|ObjectP[Model[Molecule]]], Size->Word]
				}
			},
			Outputs:>{
				{
					OutputName -> "mass",
					Description -> "Either the most probable exact mass of 'molecule', or a list/distribution representing the isotopic distribution of its exact masses.",
					Pattern :> UnitsP[Dalton]|_EmpiricalDistribution|_List
				}
			}
		},
		{
			Definition -> {"ExactMass[oligomer]","mass"},
			Description -> "computes the most probable exact mass of a sequence, strand, or structure.",
			Inputs:>{
				{
					InputName -> "oligomer",
					Description -> "The sequence, strand, or structure you wish to obtain the exact mass of.",
					Widget -> Widget[Type->Expression, Pattern:>Alternatives[SequenceP,StrandP,StructureP], Size->Word]
				}
			},
			Outputs:>{
				{
					OutputName -> "mass",
					Description -> "Either the most probable exact mass of 'molecule', or a list/distribution representing the isotopic distribution of its exact masses.",
					Pattern :> UnitsP[Dalton]|_EmpiricalDistribution|_List
				}
			}
		}
	},
	MoreInformation -> {
		"ExactMass computes the most probable exact molecular mass arising from isotopic variation.",
		"The exact mass of a molecule is a distribution of possible quantities because each atom can exist as one of multiple isotopes (with varying probability). Set OutputFormat to List or Distribution to view the full distribution of masses.",
		"The MolecularWeight of a molecule is the mean of its exact mass distribution.",
		"MonoisotopicMass represents the exact mass of a molecule in which each atom exists as its most frequently occurring isotope."
	},
	SeeAlso -> {
		"MolecularWeight",
		"MonoisotopicMass"
	},
	Author -> {"yanzhe.zhu", "olatunde.olademehin", "weiran.wang", "kevin.hou"}
}];


(* ::Subsubsection:: *)
(*ElementData*)


DefineUsage[ECLElementData,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ECLElementData[ElementData, propertyNames]","properties"},
				Description -> "computes the physical properties, such as atomic mass, isotopes, isotope abundance of 'ElementData'.",
				Inputs:>{
					{
						InputName -> "ElementData",
						Description -> "The element you wish to obtain the properties of.",
						Widget -> Widget[Type->Object, Pattern:>ObjectP[Model[Physics, ElementData]]]
					},
					{
						InputName -> "propertyNames",
						Description -> "The properties you wish to obtain.",
						Widget -> Widget[Type->Expression, Pattern:>ElementPropertyP, Size->Word]
					}
				},
				Outputs:>{
					{
						OutputName -> "properties",
						Description -> "The list of values, rules or associations of the desired properties of the elements.",
						Pattern :> _List
					}
				}
			},
			{
				Definition -> {"ECLElementData[ElementSymbol, propertyNames]","properties"},
				Description -> "computes the physical properties, such as atomic mass, isotopes, isotope abundance of 'ElementSymbol'.",
				Inputs:>{
					{
						InputName -> "ElementSymbol",
						Description -> "The element you wish to obtain the properties of.",
						Widget -> Widget[Type->Expression, Pattern:>ElementP, Size->Word]
					},
					{
						InputName -> "propertyNames",
						Description -> "The properties you wish to obtain.",
						Widget -> Widget[Type->Expression, Pattern:>ElementPropertyP, Size->Word]
					}
				},
				Outputs:>{
					{
						OutputName -> "properties",
						Description -> "The list of values, rules or associations of the desired properties of the elements.",
						Pattern :> _List
					}
				}
			},
			{
				Definition -> {"ECLElementData[ElementAbbreviation, propertyNames]","properties"},
				Description -> "computes the physical properties, such as atomic mass, isotopes, isotope abundance of 'ElementAbbreviation'.",
				Inputs:>{
					{
						InputName -> "ElementAbbreviation",
						Description -> "The element abbreviation you wish to obtain the properties of.",
						Widget -> Widget[Type->String, Pattern:>ElementAbbreviationP, Size->Word]
					},
					{
						InputName -> "propertyNames",
						Description -> "The properties you wish to obtain.",
						Widget -> Widget[Type->Expression, Pattern:>ElementPropertyP, Size->Word]
					}
				},
				Outputs:>{
					{
						OutputName -> "properties",
						Description -> "The list of values, rules or associations of the desired properties of the elements.",
						Pattern :> _List
					}
				}
			}
		},
		MoreInformation -> {
			"ElementData function computes the following properties for any given element or list of elements: \n Symbol, Abbreviation, Atomic mass, Isotope list, Isotope Abundance, Isotope mass.",
			"One can change the option Output to alter the format of output."
		},
		SeeAlso -> {
			"MolecularWeight",
			"ECLIsotopeData",
			"updateElementData"
		},
		Author -> {"hanming.yang"}
	}
];


(* ::Subsubsection:: *)
(*IsotopeData*)


DefineUsage[ECLIsotopeData,
	{
		BasicDefinitions -> {
			{
				Definition -> {"ECLIsotopeData[Isotopes, propertyNames]","properties"},
				Description -> "computes the physical properties, such as molar mass, abundance of 'Isotopes'.",
				Inputs:>{
					{
						InputName -> "Isotopes",
						Description -> "The Isotope you wish to obtain the properties of.",
						Widget -> Widget[Type->String, Pattern:>IsotopeP, Size->Word]
					},
					{
						InputName -> "propertyNames",
						Description -> "The properties you wish to obtain.",
						Widget -> Widget[Type->Expression, Pattern:>ElementPropertyP, Size->Word]
					}
				},
				Outputs:>{
					{
						OutputName -> "properties",
						Description -> "The list of values of the desired properties of the isotopes.",
						Pattern :> _List
					}
				}
			}
		},
		MoreInformation -> {
			"ElementData function computes the following properties for any given element or list of elements: \n Symbol, Abbreviation, Atomic mass, Isotope list, Isotope Abundance, Isotope mass.",
			"One can change the option Output to alter the format of output."
		},
		SeeAlso -> {
			"MolecularWeight",
			"ECLElementData",
			"updateIsotopeData"
		},
		Author -> {"hanming.yang"}
	}
];

(* ::Subsubsection:: *)
(*updateElementData*)


DefineUsage[updateElementData,
	{
		BasicDefinitions -> {
			{
				Definition -> {"updateElementData[ElementSymbol, options]","Objects"},
				Description -> "upload the physical properties, such as atomic mass, isotopes, isotope abundance of 'ElementSymbol' into the corresponding 'Objects'.",
				Inputs:>{
					{
						InputName -> "ElementSymbol",
						Description -> "The element you wish to obtain the properties of.",
						Widget -> Widget[Type->Expression, Pattern:>ElementP, Size->Word]
					}
				},
				Outputs:>{
					{
						OutputName -> "Objects",
						Description -> "The new or updated Model[Physics, ElementData] 'objects'.",
						Pattern :> {ObjectP[Model[Physics, ElementData]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function is solely meant to be used by developers to add or modify Model[Physics, ElementData] object. It should not be called in Engine or by customers",
			"One can set property-related options to automatic, in which case the function will try to fetch these properties from Wolfram database.",
			"Alternatively, one can also manually specify properties.",
			"This function does not update isotope-related fields, such as Isotopes, IsotopeAbundances, etc. These fields can be updated through updateIsotopeData function."
		},
		SeeAlso -> {
			"MolecularWeight",
			"ECLElementData",
			"updateIsotopeData"
		},
		Author -> {"hanming.yang"}
	}
];


(* ::Subsubsection:: *)
(*updateIsotopeData*)


DefineUsage[updateIsotopeData,
	{
		BasicDefinitions -> {
			{
				Definition -> {"updateIsotopeData[ElementSymbol, options]","Objects"},
				Description -> "upload the physical properties of isotopes of input 'ElementSymbol', such as Isotopes, IsotopeAbundances, IsotopeMasses into the corresponding 'Objects'.",
				Inputs:>{
					{
						InputName -> "ElementSymbol",
						Description -> "The element of isotopes you wish to obtain the properties of.",
						Widget -> Widget[Type->Expression, Pattern:>ElementP, Size->Word]
					}
				},
				Outputs:>{
					{
						OutputName -> "Objects",
						Description -> "The new or updated Model[Physics, ElementData] 'objects'.",
						Pattern :> {ObjectP[Model[Physics, ElementData]]...}
					}
				}
			}
		},
		MoreInformation -> {
			"This function is solely meant to be used by developers to add or modify Model[Physics, ElementData] object. It should not be called in Engine or by customers",
			"One can set property-related options to automatic, in which case the function will try to fetch these properties from Wolfram database.",
			"Alternatively, one can also manually specify properties.",
			"This function only update isotope-related fields, such as Isotopes, IsotopeAbundances, etc."
		},
		SeeAlso -> {
			"MolecularWeight",
			"ECLElementData",
			"updateIsotopeData"
		},
		Author -> {"hanming.yang"}
	}
];