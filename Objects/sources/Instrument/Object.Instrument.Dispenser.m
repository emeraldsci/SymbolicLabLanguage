(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument,Dispenser],{
	Description -> "Instrument used to deliver liquid sample from its reservoir.",
	CreatePrivileges->None,
	Cache->Download,
	Fields ->{
		Reservoir ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description ->"The reservoir container object used by this instrument to hold liquid for dispension.",
			Category -> "Instrument Specifications"
		},
		MeasuringDevices -> {
			Format -> Multiple,
			Class ->Link,
			Pattern :> _Link,
			Relation -> Object[Container,GraduatedCylinder][DedicatedInstrument],
			Description ->"The graduated cylinder containers used to measure dispensed volume.",
			Category -> "Instrument Specifications"
		},
		FillLiquidModel->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The model of liquid that this dispenser has been designated to contain, and should be refilled with automatically.",
			Category -> "Instrument Specifications"
		}
	}
}];
