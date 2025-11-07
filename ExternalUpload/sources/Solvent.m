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
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[Type -> Object, Pattern :> ObjectP[Model[Sample]]],
				Description -> "The base solution this sample model is in.",
				ResolutionDescription -> "For existing objects, Automatic resolves to the current field value.",
				Category -> "Organizational Information"
			}
		],
		ExternalUploadHiddenOptions
	}
];


installDefaultUploadFunction[DefineSolvent, Object[Sample], InstallNameOverload -> False, InstallObjectOverload -> True];
installDefaultValidQFunction[DefineSolvent, Object[Sample]];
installDefaultOptionsFunction[DefineSolvent, Object[Sample]];
