(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification, PlateWasher], {
	Description -> "A protocol that verifies the functionality of the plate washer target.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		PrereadData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, AbsorbanceSpectroscopy],
			Description -> "Absorbance intensity data for the test container before washing.",
			Category -> "Experimental Results"
		}
	}
}];
