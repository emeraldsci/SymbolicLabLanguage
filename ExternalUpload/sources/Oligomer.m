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
		UploadMolecule
	},
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> PolymerType,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives @@ Join[AllPolymersP, {Mixed}]],
				Description -> "The type of polymer the nucleic acid is composed of (not counting modifications).",
				ResolutionDescription -> "Resolves to the polymer type of the nucleic acid given as input.",
				Category -> "Organizational Information"
			},

			(* Overwrite the defaults for some safety fields. *)
			{
				OptionName -> State,
				Default -> Solid,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Solid, Liquid, Gas]],
				Description -> "The physical state of the sample when well solvated at room temperature and pressure.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> MSDSRequired,
				Default -> False,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if an MSDS is applicable for this model.",
				Category -> "Health & Safety"
			},
			{
				OptionName -> Flammable,
				Default -> False,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates if pure samples of this molecule are easily set aflame under standard conditions.",
				Category -> "Health & Safety"
			},
			{
				OptionName -> BiosafetyLevel,
				Default -> "BSL-1",
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BiosafetyLevelP],
				Description -> "The Biosafety classification of the substance.",
				Category -> "Health & Safety"
			},
			{
				OptionName -> IncompatibleMaterials,
				Default -> {None},
				AllowNull -> True,
				Widget -> With[{insertMe=Flatten[None | MaterialP]}, Adder[Widget[Type -> Enumeration, Pattern :> insertMe]]],
				Description -> "A list of materials that would be damaged if wetted by this model.",
				Category -> "Compatibility"
			},

			{
				OptionName -> Enthalpy,
				Default -> Null,
				AllowNull -> True,
				Description -> "The expected binding enthalpy for the binding of this oligomer model to its reverse complement.",
				ResolutionDescription -> "Automatically set to the simulated entropy, using the function SimulateEntropy.",
				Category -> "Physical Properties",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-Infinity * KilocaloriePerMole, Infinity * KilocaloriePerMole],
					Units -> {1, {KilocaloriePerMole, {KilocaloriePerMole}}}
				]
			},
			{
				OptionName -> Entropy,
				Default -> Null,
				AllowNull -> True,
				Description -> "The expected binding entropy for the binding of this oligomer model to its reverse complement.",
				ResolutionDescription -> "Automatically set to the simulated entropy, using the function SimulateEntropy.",
				Category -> "Physical Properties",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-Infinity * CaloriePerMoleKelvin, Infinity * CaloriePerMoleKelvin],
					Units -> {1, {CaloriePerMoleKelvin, {CaloriePerMoleKelvin}}}
				]
			},
			{
				OptionName -> FreeEnergy,
				Default -> Null,
				AllowNull -> True,
				Description -> "The expected Gibbs Free Energy for the binding of this oligomer model to its reverse complement at 37 Celsius.",
				ResolutionDescription -> "Automatically set to the simulated free energy, using the function SimulateFreeEnergy.",
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


InstallDefaultUploadFunction[UploadOligomer, Model[Molecule, Oligomer], resolveUploadNucleicAcidModelOptions];
InstallValidQFunction[UploadOligomer, Model[Molecule, Oligomer]];
InstallOptionsFunction[UploadOligomer, Model[Molecule, Oligomer]];
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
