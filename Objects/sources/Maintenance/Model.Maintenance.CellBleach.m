(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, CellBleach], {
	Description->"Definition of a set of parameters for a maintenance protocol that disposes of cell samples by bleaching them.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		LiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "The model of liquid handler which performed the bleaching.",
			Category -> "General"
		},
		Bleach -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of bleach that will be used to sterilize the cells.",
			Category -> "General",
			Abstract -> True
		},
		BleachVolumeFraction -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0, 1, Inclusive -> Right],
			Units -> None,
			Description -> "The volume of bleach that is added to the cells, expressed as a fraction of the recommended working volume of the container.",
			Category -> "General"
		},
		BleachTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "The length of time for which bleach is incubated with the cells.",
			Category -> "General"
		}
	}
}];
