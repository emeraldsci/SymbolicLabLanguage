

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Instrument, DifferentialScanningCalorimeter], {
	Description->"Model of a differential scanning calorimetry (DSC) instrument that measures heat flux as a function of temperature to determine thermodynamic properites of samples.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The minimum temperature at which the sample may be held in instruments of this model during its heating/cooling cycle.",
			Category -> "Instrument Specifications"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The maximum temperature at which the sample may be held in instruments of this model during its heating/cooling cycle.",
			Category -> "Instrument Specifications"
		},
		MinTemperatureRampRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius / Hour],
			Units -> Celsius / Hour,
			Description -> "The slowest rate at which the temperature of a given sample can change in the course of a heating/cooling cycle for instruments of this model.",
			Category -> "Instrument Specifications"
		},
		MaxTemperatureRampRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius / Hour],
			Units -> Celsius / Hour,
			Description -> "The fastest rate at which the temperature of a given sample can change in the course of a heating/cooling cycle for instruments of this model.",
			Category -> "Instrument Specifications"
		},
		MinInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "The minimum volume of sample that can be injected into instruments of this model.",
			Category -> "Instrument Specifications"
		},
		MaxInjectionVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "The maximum volume of sample that can be injected into instruments of this model.",
			Category -> "Instrument Specifications"
		}
	}
}];
