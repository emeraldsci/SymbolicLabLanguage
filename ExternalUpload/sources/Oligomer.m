(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadOligomer*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[UploadOligomer,
	SharedOptions :> {
		MoleculeOptions,
		ExternalUploadHiddenOptions
	},
	Options :> {
		(* Overwrite the defaults for some options *)
		ModifyOptions[
			MoleculeOptions,
			{
				(* Default the state to Solid *)
				{
					OptionName -> State,
					ResolutionDescription -> "If creating a new object, resolves to Solid. For existing objects, resolves to the current field value."
				},
				(* Default the flammable option to False *)
				{
					OptionName -> Flammable,
					ResolutionDescription -> "If creating a new object, resolves to False. For existing objects, resolves to the current field value."
				},
				(* Default BSL to 1 *)
				{
					OptionName -> BiosafetyLevel,
					ResolutionDescription -> "If creating a new object, resolves to BSL-1. For existing objects, resolves to the current field value."
				},
				(* Default the MSDSRequired to False *)
				(* I'm currently just reproducing the existing code here - we will require the user to declare safety information in future *)
				(* But I might break a lot of code if I just change the default randomly *)
				{
					OptionName -> MSDSRequired,
					ResolutionDescription -> "If creating a new object, resolves to False. For existing objects, resolves to the current field value."
				},
				(* Default IncompatibleMaterials to {None} *)
				{
					OptionName -> IncompatibleMaterials,
					ResolutionDescription -> "If creating a new object, resolves to {None}. For existing objects, resolves to the current field value."
				}
			}
		],

		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> PolymerType,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives @@ Join[AllPolymersP, {Mixed}]],
				Description -> "The type of polymer the nucleic acid is composed of (not counting modifications).",
				ResolutionDescription -> "If creating a new object, resolves to the polymer type of the nucleic acid given as input otherwise Null. For existing objects, resolves to the current field value.",
				Category -> "Organizational Information"
			},

			{
				OptionName -> Enthalpy,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The expected binding enthalpy for the binding of this oligomer model to its reverse complement.",
				ResolutionDescription -> "For new objects, automatically set to the simulated entropy, using the function SimulateEntropy. For existing objects, resolves to the current field value.",
				Category -> "Physical Properties",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-Infinity * KilocaloriePerMole, Infinity * KilocaloriePerMole],
					Units -> {1, {KilocaloriePerMole, {KilocaloriePerMole}}}
				]
			},
			{
				OptionName -> Entropy,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The expected binding entropy for the binding of this oligomer model to its reverse complement.",
				ResolutionDescription -> "For new objects, automatically set to the simulated entropy, using the function SimulateEntropy. For existing objects, resolves to the current field value.",
				Category -> "Physical Properties",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-Infinity * CaloriePerMoleKelvin, Infinity * CaloriePerMoleKelvin],
					Units -> {1, {CaloriePerMoleKelvin, {CaloriePerMoleKelvin}}}
				]
			},
			{
				OptionName -> FreeEnergy,
				Default -> Automatic,
				AllowNull -> True,
				Description -> "The expected Gibbs Free Energy for the binding of this oligomer model to its reverse complement at 37 Celsius.",
				ResolutionDescription -> "For new objects, automatically set to the simulated free energy, using the function SimulateFreeEnergy. For existing objects, resolves to the current field value.",
				Category -> "Physical Properties",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-Infinity * KilocaloriePerMole, Infinity * KilocaloriePerMole],
					Units -> {1, {KilocaloriePerMole, {KilocaloriePerMole}}}
				]
			}
		]
	}
];


UploadOligomer[myStructures:ListableP[_?StructureQ | _?StrandQ], myTypes:ListableP[(PolymerP | Mixed)], myNames:ListableP[_String], myOptions:OptionsPattern[]]:=UploadOligomer[
	myNames,

	(* Add to our other options: *)
	DeleteDuplicates@Flatten[{
		ToList[myOptions],

		PolymerType -> myTypes,
		Molecule -> myStructures
	}]
];


installDefaultUploadFunction[UploadOligomer, Model[Molecule, Oligomer], OptionResolver -> resolveUploadNucleicAcidModelOptions];
installDefaultValidQFunction[UploadOligomer, Model[Molecule, Oligomer]];
installDefaultOptionsFunction[UploadOligomer, Model[Molecule, Oligomer]];
InstallIdentityModelTests[
	UploadOligomer,
	"Upload a model for a biological macromolecule composed of a limited number of monomeric units:",
	{ECL`Structure[{ECL`Strand[ECL`DNA["GATTACAGATTACAG"]]}, {}], DNA, "Test Oligomer Model (UploadOligomerModel)" <> $SessionUUID},
	{Model[Molecule, Oligomer, "Test Oligomer Model (UploadOligomerModel)" <> $SessionUUID]}
];

InstallIdentityModelTests[
	UploadOligomerOptions,
	"Upload a model for a biological macromolecule composed of a limited number of monomeric units:",
	{
		"Test Oligomer Model (UploadOligomerOptions)" <> $SessionUUID,
		Molecule -> ECL`Structure[{ECL`Strand[ECL`DNA["GATTACAGATTACAG"]]}, {}],
		PolymerType -> DNA
	},
	{Model[Molecule, Oligomer, "Test Oligomer Model (UploadOligomerOptions)" <> $SessionUUID]}
];

InstallIdentityModelTests[
	ValidUploadOligomerQ,
	"Upload a model for a biological macromolecule composed of a limited number of monomeric units:",
	{
		"Test Oligomer Model (UploadOligomerOptions)" <> $SessionUUID,
		Molecule -> ECL`Structure[{ECL`Strand[ECL`DNA["GATTACAGATTACAG"]]}, {}],
		PolymerType -> DNA
	},
	{Model[Molecule, Oligomer, "Test Oligomer Model (ValidUploadOligomerQ)" <> $SessionUUID]}
];
