(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Dispenser],{
	Description -> "A model for dispenser instrument used to deliver liquid from its reservoir container.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields  -> {
		ReservoirContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern:> _Link,
			Relation -> Model[Container],
			Description ->"The model of reservoir container used by this instrument to hold liquid for dispension.",
			Category -> "Instrument Specifications"
		},
		MeasuringDevices-> {
			Format -> Multiple,
			Class ->  Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "The model of graduated cylinder containers used to measure dispensed volume.",
			Category -> "Instrument Specifications"
		},
		MaxVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units -> Milliliter,
			Description -> "Max volume of liquid the dispenser reservoir can store.",
			Category -> "Operating Limits"
		},
		MaxFlowRate ->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Liter)/Minute],
			Units -> Liter/Minute,
			Description -> "Maximum rate at which the dispenser can deliver liquid from its reservoir.",
			Category -> "Operating Limits"
		}
	}
}];
