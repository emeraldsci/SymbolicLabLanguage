(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*DefineAnalytes*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[DefineAnalytes,
	SharedOptions :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Analytes,
				Default -> Null,
				AllowNull -> True,
				Widget -> Alternatives[
					"List of Analytes" -> With[{insertMe=List @@ IdentityModelTypeP},
						Adder[
							Widget[Type -> Object, Pattern :> ObjectP[insertMe]]
						]
					],
					"Empty List" -> Widget[Type -> Enumeration, Pattern :> Alternatives[{}]]
				],
				Description -> "The molecular identities of primary interest in this sample.",
				Category -> "Organizational Information"
			}
		],
		ExternalUploadHiddenOptions
	}
];

InstallDefaultUploadFunction[DefineAnalytes, Object[Sample], {InstallNameOverload -> False, InstallObjectOverload -> True}];
InstallValidQFunction[DefineAnalytes, Object[Sample]];
InstallOptionsFunction[DefineAnalytes, Object[Sample]];
