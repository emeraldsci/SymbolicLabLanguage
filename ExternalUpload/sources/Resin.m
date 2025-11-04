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
	SharedOptions :> {
		SubstanceOptions,
		IdentityModelHealthAndSafetyOptions,
		ExternalUploadHiddenOptions
	},
	Options :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
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
	}
];


installDefaultUploadFunction[UploadResin, Model[Resin]];
installDefaultValidQFunction[UploadResin, Model[Resin]];
installDefaultOptionsFunction[UploadResin, Model[Resin]];
