

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, DifferentialScanningCalorimeter], {
	Description->"A differential scanning calorimetry (DSC) instrument that measures heat flux as a function of temperature to determine thermodynamic properties of samples.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		DetergentDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The detergent bottle deck currently used by the instrument.",
			Category -> "Dimensions & Positions"
		},
		BufferDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Deck][Instruments],
			Description -> "The deck which contains the water buffers used to wash the instrument syringe and cell.",
			Category -> "Dimensions & Positions"
		},
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The minimum temperature at which the sample may be held in instruments during its heating/cooling cycle.",
			Category -> "Instrument Specifications"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "The maximum temperature at which the sample may be held in instruments during its heating/cooling cycle.",
			Category -> "Instrument Specifications"
		},
		MinTemperatureRampRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinTemperatureRampRate]],
			Pattern :> GreaterP[0 Celsius / Hour],
			Description -> "The slowest rate at which the temperature of a given sample can change in the course of a heating/cooling cycle for instruments.",
			Category -> "Instrument Specifications"
		},
		MaxTemperatureRampRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxTemperatureRampRate]],
			Pattern :> GreaterP[0 Celsius / Hour],
			Description -> "The fastest rate at which the temperature of a given sample can change in the course of a heating/cooling cycle for instruments.",
			Category -> "Instrument Specifications"
		},
		MinInjectionVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MinInjectionVolume]],
			Pattern :> GreaterP[0 Microliter],
			Description -> "The minimum volume of sample that can be injected into instruments.",
			Category -> "Instrument Specifications"
		},
		MaxInjectionVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxInjectionVolume]],
			Pattern :> GreaterP[0 Microliter],
			Description -> "The maximum volume of sample that can be injected into instruments.",
			Category -> "Instrument Specifications"
		},
		MaintenanceCounter->{
			Format->Single,
			Class->Integer,
			Pattern:>GreaterEqualP[0],
			Description->"The number of experiments the instrument has undergone for maintenance scheduling purposes.",
			Category->"Dimensions & Positions"
		}
	}
}];
