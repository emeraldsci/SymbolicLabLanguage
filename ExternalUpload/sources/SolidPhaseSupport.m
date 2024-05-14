(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadSolidPhaseSupport*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[UploadSolidPhaseSupport,
	SharedOptions :> {
		UploadResin
	},
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Strand,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Molecule, Oligomer]]],
				Description -> "The model of oligomer displayed on the resin.",
				Category -> "Model Information"
			},
			{
				OptionName -> SourceResin,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Resin]]],
				Description -> "The model of the resin prior to synthesis or downloading.",
				Category -> "Model Information"
			},
			{
				OptionName -> PreDownloaded,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
				Description -> "Indicates whether the resin was purchased as a downloaded resin, as opposed to downloaded manually.",
				Category -> "Model Information"
			}
		]
	}
];


InstallDefaultUploadFunction[UploadSolidPhaseSupport, Model[Resin, SolidPhaseSupport]];
InstallValidQFunction[UploadSolidPhaseSupport, Model[Resin, SolidPhaseSupport]];
InstallOptionsFunction[UploadSolidPhaseSupport, Model[Resin, SolidPhaseSupport]];


InstallIdentityModelTests[
	UploadSolidPhaseSupport,
	"Upload a solid phase synthesis resin that has an oligomer displayed on it, typically from synthesis:",
	{
		"Lys-HMBA-ChemMatrix (test for UploadSolidPhaseSupport)" <> $SessionUUID,
		SourceResin -> Model[Resin, "id:xRO9n3BPm0nO"],
		Strand -> Model[Molecule, Oligomer, "id:54n6evLmpJzl"],
		BiosafetyLevel -> "BSL-1",
		State -> Solid,
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	},
	{Model[Resin, SolidPhaseSupport, "Lys-HMBA-ChemMatrix (test for UploadSolidPhaseSupport)" <> $SessionUUID]}
];

InstallIdentityModelTests[
	UploadSolidPhaseSupportOptions,
	"Upload a solid phase synthesis resin that has an oligomer displayed on it, typically from synthesis:",
	{
		"Lys-HMBA-ChemMatrix (test for UploadSolidPhaseSupportOptions)" <> $SessionUUID,
		SourceResin -> Model[Resin, "id:xRO9n3BPm0nO"],
		Strand -> Model[Molecule, Oligomer, "id:54n6evLmpJzl"],
		BiosafetyLevel -> "BSL-1",
		State -> Solid,
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	},
	{Model[Resin, SolidPhaseSupport, "Lys-HMBA-ChemMatrix (test for UploadSolidPhaseSupportOptions)" <> $SessionUUID]}
];

InstallIdentityModelTests[
	ValidUploadSolidPhaseSupportQ,
	"Upload a solid phase synthesis resin that has an oligomer displayed on it, typically from synthesis:",
	{
		"Lys-HMBA-ChemMatrix (test for ValidUploadSolidPhaseSupportQ)" <> $SessionUUID,
		SourceResin -> Model[Resin, "id:xRO9n3BPm0nO"],
		Strand -> Model[Molecule, Oligomer, "id:54n6evLmpJzl"],
		BiosafetyLevel -> "BSL-1",
		State -> Solid,
		Flammable -> False,
		MSDSRequired -> False,
		IncompatibleMaterials -> {None}
	},
	{Model[Resin, SolidPhaseSupport, "Lys-HMBA-ChemMatrix (test for ValidUploadSolidPhaseSupportQ)" <> $SessionUUID]}
];