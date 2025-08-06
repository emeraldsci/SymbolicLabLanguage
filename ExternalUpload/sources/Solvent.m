(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*DefineComposition*)


(* ::Subsubsection:: *)
(*Options and Messages*)


DefineOptions[DefineSolvent,
	SharedOptions :> {
		IndexMatching[
			IndexMatchingInput -> "Input Data",
			{
				OptionName -> Solvent,
				Default -> Null,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Sample]]],
				Description -> "The base solution this sample model is in.",
				Category -> "Organizational Information"
			}
		],
		ExternalUploadHiddenOptions
	}
];


InstallDefaultUploadFunction[DefineSolvent, Object[Sample], InstallNameOverload -> False, InstallObjectOverload -> True];
InstallValidQFunction[DefineSolvent, Object[Sample]];
InstallOptionsFunction[DefineSolvent, Object[Sample]];
