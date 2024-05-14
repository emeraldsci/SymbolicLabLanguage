(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Item,SPMEFiber], {
	Description->"A solid phase microextraction (SPME) fiber used to adsorb analytes prior to injection into a gas chromatograph.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		ConditioningLog -> {
			Format->Multiple,
			Class->{
				DateConditioned -> Date,
				ConditioningTime -> Real,
				ConditioningTemperature -> Real
			},
			Pattern:>{
				DateConditioned -> _?DateObjectQ,
				ConditioningTime -> GreaterP[0*Minute],
				ConditioningTemperature -> GreaterP[0*Kelvin]
			},
			Units->{
				DateConditioned -> None,
				ConditioningTime -> Minute,
				ConditioningTemperature -> Celsius
			},
			Description -> "A log of the conditioning times and temperatures that have been applied to this SPME fiber.",
			Category -> "Physical Properties"
		},
		InjectionLog -> {
			Format->Multiple,
			Class->{
				DateInjected -> Date,
				Sample->Link,
				Protocol->Link,
				AdsorptionTemperature->Real,
				AdsorptionTime->Real,
				DesorptionTemperature->Real,
				DesorptionTime->Real,
				Data->Link
			},
			Pattern:>{
				DateInjected -> _?DateObjectQ,
				Sample->ObjectP[{Object[Sample],Model[Sample]}],
				Protocol->_Link,
				AdsorptionTemperature->GreaterP[0*Kelvin],
				AdsorptionTime->GreaterP[0*Minute],
				DesorptionTemperature->GreaterP[0*Kelvin],
				DesorptionTime->GreaterP[0*Minute],
				Data->_Link
			},
			Relation->{
				DateInjected -> Null,
				Sample->Alternatives[
					Object[Sample],
					Model[Sample]
				],
				Protocol ->Object[Protocol],
				AdsorptionTemperature->Null,
				AdsorptionTime->Null,
				DesorptionTemperature->Null,
				DesorptionTime->Null,
				Data->Object[Data]
			},
			Units->{
				DateInjected -> None,
				Sample->None,
				Protocol->None,
				AdsorptionTemperature->Celsius,
				AdsorptionTime->Minute,
				DesorptionTemperature->Celsius,
				DesorptionTime->Minute,
				Data->None
			},
			Description -> "A log of the samples, sampling times, and adsorbption/desorption temperatures that have been applied to this SPME fiber.",
			Category -> "Physical Properties"
		},
		RinsingLog -> {
			Format->Multiple,
			Class->{
				DateRinsed -> Date,
				RinseSolvent->Link,
				RinseTime->Real
			},
			Pattern:>{
				DateRinsed -> _?DateObjectQ,
				RinseSolvent->ObjectP[{Object[Sample],Model[Sample]}],
				RinseTime->GreaterP[0*Minute]
			},
			Relation->{
				DateRinsed -> Null,
				RinseSolvent->Alternatives[
					Object[Sample],
					Model[Sample]
				],
				RinseTime ->Null
			},
			Units->{
				DateRinsed -> None,
				RinseSolvent->None,
				RinseTime->Minute
			},
			Description -> "A log of all the rinse solvents and rinsing times that have been applied to this SPME fiber.",
			Category -> "Physical Properties"
		}
	}
}];
