(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,PeptideSynthesizer], {
	Description->"A protocol that verifies the functionality of the peptide synthesizer target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		AbsorbanceQualityControlProtocol-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,AbsorbanceSpectroscopy],
			Description -> "The absorbance spectroscopy protocol used to interrogate crude concentration of synthesized strands.",
			Category -> "General"
		}
	}
}];

