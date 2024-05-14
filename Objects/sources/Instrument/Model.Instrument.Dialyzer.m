(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Dialyzer], {
	Description->"A model describing a device for diffusing contaminants out of a sample by dialysis",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TankVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter],
			Units -> Milliliter,
			Description -> "The volume of solution the that can be held in the dialysis tank.",
			Category -> "Instrument Specifications"
		},
		TankHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter,
			Description -> "The distance between the top and bottom of the tank that holds the dialysis tube.",
			Category -> "Instrument Specifications"
		},
		TankInternalDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter,
			Description -> "The internal with of the tank that holds the dialysis tube.",
			Category -> "Instrument Specifications"
		},
		TankMaterial ->{
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material of which the tank that holds the dialysis tube is made.",
			Category -> "Instrument Specifications"
		},
		ReservoirVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter],
			Units -> Milliliter,
			Description -> "The volume of the instrument's dialysate container.",
			Category -> "Instrument Specifications"
		},
		PeristalticPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,PeristalticPump],
			Description -> "The model of the pump used to generate flow dialysate across the tank.",
			Category -> "Instrument Specifications"
		},
		Reservoir ->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,Vessel],
			Description ->"The model of the container used by this instrument to hold the dialysate.",
			Category -> "Instrument Specifications"
		},
		TubingInnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Internal diameter of the tubing that connects the instrument.",
			Category -> "Dimensions & Positions"
		},
		MaxFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Liter)/Minute],
			Units -> Liter/Minute,
			Description -> "Maximum rate at which the dialyzer can circulate the dialysate.",
			Category -> "Operating Limits"
		},
		MinFlowRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Liter)/Minute],
			Units -> Liter/Minute,
			Description -> "Minimum rate at which the dialyzer can circulate the dialysate.",
			Category -> "Operating Limits"
		}
	}
}];
