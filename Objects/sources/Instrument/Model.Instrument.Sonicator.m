(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, Sonicator], {
	Description->"The model for a device that applies sound energy to agitate particles in a sample via a water bath.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		BathFluid -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Water | Oil,
			Description -> "Fluid type that is allowed to be in the sonicator reservoir.",
			Category -> "Instrument Specifications"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature at which the Sonicator can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature at which the Sonicator can incubate.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		BathVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "Volume of bath fluid required to fill the sonicator reservoir.",
			Category -> "Dimensions & Positions"
		},
		InternalDimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The size of space inside the sonicator reservoir.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		}
	}
}];
