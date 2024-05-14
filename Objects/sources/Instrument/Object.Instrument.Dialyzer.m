(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Dialyzer], {
	Description->"A model describing a device for diffusing contaminants out of a sample by dialysis",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TankVolume -> {
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],TankVolume]],
			Pattern :> GreaterP[0*Milliliter],
			Description -> "The volume of solution the that can be held in the dialysis tank.",
			Category -> "Instrument Specifications"
		},
		TankHeight -> {
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],TankHeight]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The distance between the top and bottom of the tank that holds the dialysis tube.",
			Category -> "Instrument Specifications"
		},
		TankInternalDiameter -> {
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],TankInternalDiameter]],
			Pattern :> GreaterP[0*Meter],
			Description -> "The internal with of the tank that holds the dialysis tube.",
			Category -> "Instrument Specifications"
		},
		TankMaterial -> {
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],TankMaterial]],
			Pattern :> MaterialP,
			Description -> "The material of which the tank that holds the dialysis tube is made.",
			Category -> "Instrument Specifications"
		},
		ReservoirVolume -> {
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],ReservoirVolume]],
			Pattern :> GreaterP[0*Milliliter],
			Description -> "The volume of the instrument's dialysate container.",
			Category -> "Instrument Specifications"
		},
		PeristalticPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation ->Object[Instrument,PeristalticPump],
			Description -> "The pump used to generate flow dialysate across the tank.",
			Category -> "Instrument Specifications"
		},
		Reservoir ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description ->"The reservoir container object used by this instrument to hold the dialysate.",
			Category -> "Instrument Specifications"
		},
		ReservoirDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The platform which contains the reservoir and storage containers that are used by the instrument.",
			Category -> "Dimensions & Positions"
		},
		TubingInnerDiameter -> {
			Format->Computable,
			Expression:>SafeEvaluate[{Field[Model]}, Download[Field[Model],TubingInnerDiameter]],
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "Internal diameter of the tubing that connects the instrument.",
			Category -> "Dimensions & Positions"
		}
	}
}];
