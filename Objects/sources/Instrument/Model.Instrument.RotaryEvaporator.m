

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, RotaryEvaporator], {
	Description->"Rotary evaporator device for concentrating samples by removing solvent through lowering pressure, increased temperature, and rotating the vessel to avoid bumping.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		BathFluid -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Water | Oil,
			Description -> "Conducting fluid type Stocked in the heat bath.",
			Category -> "Instrument Specifications"
		},
		BathVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "Volume of bath fluid required to fill the heat bath.",
			Category -> "Instrument Specifications"
		},
		MinBathTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature the instrument's heatbath can achieve for incubation.",
			Category -> "Operating Limits"
		},
		MaxBathTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature the instrument's heatbath can achieve for incubation.",
			Category -> "Operating Limits"
		},
		MaxRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*RPM],
			Units -> RPM,
			Description -> "Maximum rotational speed that the instrument can apply to the evaporation flask.",
			Category -> "Operating Limits"
		},
		VaporTrap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,VaporTrap][RotaryEvaporator],
			Description -> "The secondary trap used to chill and collect evaporated solvent to prevent it from reaching the vacuum pump.",
			Category -> "Instrument Specifications"
		},
		VaporTrapCapacity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Liter],
			Units -> Liter,
			Description -> "Maximum volume of condensation the cold trap can hold.",
			Category -> "Operating Limits"
		},
		VaporTrapType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Coil | Finger,
			Description -> "The type of device used as a second evaporated solvent condenser directly upstream of the pump, to protect the pump from fumes.",
			Category -> "Instrument Specifications"
		},
		VacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,VacuumPump],
			Description -> "The pump used to generate a vacuum inside the rotovap by removing air and evaporated solvent from it's evaporation chamber.",
			Category -> "Instrument Specifications"
		},
		TubingInnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Internal diameter of the vacuum tubing that connects to the instrument.",
			Category -> "Dimensions & Positions"
		},
		RecirculatingPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument,RecirculatingPump][RotaryEvaporator],
			Description -> "The pump that moves cooling fluid through this rotovap's condensing coil.",
			Category -> "Instrument Specifications"
		},
		MinArmHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Celsius,
			Description -> "Minimum height the arm holding the condensor column and evaporation flask can be set to.",
			Category -> "Operating Limits"
		},
		MaxArmHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Centimeter,
			Description -> "Maximum height the arm holding the condensor column and evaporation flask can be set to.",
			Category -> "Operating Limits"
		},
		MinArmAngle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Degree],
			Units -> Degree,
			Description -> "Minimum angle the arm holding the condensor column and evaporation flask can be set to.",
			Category -> "Operating Limits"
		},
		MaxArmAngle -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Degree],
			Units -> Degree,
			Description -> "Maximum height the arm holding the condensor column and evaporation flask can be set to.",
			Category -> "Operating Limits"
		}
	}
}];
