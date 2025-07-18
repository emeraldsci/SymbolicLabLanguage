(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*UploadResin*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[UploadResin,
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Name,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
				Description -> "The name of the identity model.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Molecule,
				Default -> Null,
				AllowNull -> True,
				Widget -> Alternatives[
					"Atomic Structure" -> Widget[
						Type -> Molecule,
						Pattern :> MoleculeP
					],
					"Polymer Strand/Structure" -> Widget[Type -> Expression, Pattern :> _?StructureQ | _?StrandQ, Size -> Line]
				],
				Description -> "The chemical structure that represents this molecule.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> DefaultSampleModel,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Sample]]],
				Description -> "Specifies the model of sample that will be used if this model is specified to be used in an experiment.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> Synonyms,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Word]],
				Description -> "List of possible alternative names this model goes by.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> CAS,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
				Description -> "Chemical Abstracts Service (CAS) registry number for a chemical.",
				Category -> "Organizational Information"
			},
			{
				OptionName -> IUPAC,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> String, Pattern :> _String, Size -> Line],
				Description -> "International Union of Pure and Applied Chemistry (IUPAC) name for the substance.",
				Category -> "Organizational Information"
			},

			{
				OptionName -> StructureImageFile,
				Default -> Null,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[Type -> String, Pattern :> URLP, Size -> Line],
					Widget[Type -> Object, Pattern :> ObjectP[Object[EmeraldCloudFile]]]
				],
				Description -> "The URL of an image depicting the chemical structure of the pure form of this substance.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> State,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> Alternatives[Solid, Liquid, Gas]],
				Description -> "The physical state of the resin at room temperature and pressure.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> ResinMaterial,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> ResinMaterialP],
				Description -> "The type of the material the resin is made out of.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Linker,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> ResinLinkerTypeP],
				Description -> "The chemical entity used to link a compound to the resin bead during solid phase synthesis.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> Loading,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Quantity, Pattern :> GreaterEqualP[(0 * Mole) / Gram], Units -> (Mole / Gram)],
				Description -> "Ratio of active sites per weight of resin.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> ProtectingGroup,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> ProtectingGroupP],
				Description -> "The protecting group blocking the terminal reactive group on the resin used during solid phase synthesis.",
				Category -> "Physical Properties"
			},
			{
				OptionName -> PreferredCleavageMethod,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Object[Method, Cleavage]]],
				Description -> "Method object containing the preferred parameters for cleaving synthesized strands from this resin.",
				Category -> "Model Information"
			},
			{
				OptionName -> PostCouplingKaiserResult,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> KaiserResultP],
				Description -> "The expected result of a Kaiser test following monomer download. This is used to determine if the resin contains deprotected primary amines (Positive).",
				Category -> "Model Information"
			},
			{
				OptionName -> PostCappingKaiserResult,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Enumeration, Pattern :> KaiserResultP],
				Description -> "The expected result of a Kaiser test following capping of downloaded resin. This is used to determine if the resin contains deprotected primary amines (Positive).",
				Category -> "Model Information"
			}
		]
	},
	SharedOptions :> {
		IdentityModelHealthAndSafetyOptions,
		ExternalUploadHiddenOptions
	}
];


InstallDefaultUploadFunction[UploadResin, Model[Resin]];
InstallValidQFunction[UploadResin, Model[Resin]];
InstallOptionsFunction[UploadResin, Model[Resin]];
