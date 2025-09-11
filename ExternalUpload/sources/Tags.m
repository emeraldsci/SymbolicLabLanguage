(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*DefineTags*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[DefineTags,
	SharedOptions :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Tags,
				Default -> Null,
				AllowNull -> True,
				Widget -> Adder[Widget[Type -> String, Pattern :> _String, Size -> Line]],
				Description -> "User-supplied labels that are used for the management and organization of samples. If an aliquot is taken out of this sample, the new sample that is generated will inherit this sample's tags.",
				Category -> "Organizational Information"
			}
		],
		ExternalUploadHiddenOptions
	}
];


InstallDefaultUploadFunction[DefineTags, Object[Sample], OptionResolver -> resolveDefaultUploadFunctionOptions, InstallNameOverload -> False, InstallObjectOverload -> True];
InstallValidQFunction[DefineTags, Object[Sample]];
InstallOptionsFunction[DefineTags, Object[Sample]];
