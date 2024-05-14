(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,PlateSealer],{
	Description->"A protocol that verifies the functionality of the plate sealer target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		CoveredPlateImages->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[EmeraldCloudFile],
			Description->"Image file containing a photo of the PCR plate after plate sealing.",
			Category -> "General"
		},
		Cover -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Item,PlateSeal]|Object[Item,PlateSeal]),
			Description -> "The cover to be used to seal the container.",
			Category -> "General"
		},
		Container -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Container,Plate]|Object[Container,Plate]),
			Description -> "The container to be sealed.",
			Category -> "General"
		},
		FullySealed -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each PCR plate, indicates if the container appears fully sealed by plate seal.",
			Category -> "Experimental Results"
		}
	}
}];
