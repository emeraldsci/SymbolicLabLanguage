

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Data, VacuumEvaporation], {
	Description->"Pressure and temperature data recorded during preparative sample vacuum evaporation.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		VacuumEvaporationMethod -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Method,VacuumEvaporation],
			Description -> "The method object containing all evaporation parameters used to concentrate samples during this evaporation experiment.",
			Category -> "Evaporation"
		},
		EquilibrationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Minute,
			Description -> "The amount of time, including chamber evacuation, heating, centrifuging, drainage of vapors, defrost etc., it takes to achieve a steady state at the NominalTemperature and NominalPressure. During this time, the sample(s) continue to be concentrated.",
			Category -> "General"
		},
		EvaporationTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Second],
			Units -> Hour,
			Description -> "The amount of time, after equilibration is achieved, that the sample(s) continue to undergo evaporation and concentration at the NominalTemperature and NominalPressure.",
			Category -> "General"
		},
		CentrifugalForce -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*GravitationalAcceleration],
			Units -> GravitationalAcceleration,
			Description -> "The force (RCF) exerted on the sample(s) as a result of the revolution of the rotor containing the samples in the instrument chamber. This is done to prevent sample bumping.",
			Category -> "General"
		},
		RotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*RPM],
			Units -> RPM,
			Description -> "The rotation speed at which samples are rotated to prevent sample bumping.",
			Category -> "General"
		},
		NominalTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature that was set for the duration of the lyophilization run.",
			Category -> "General"
		},
		EquilibrationPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Bar],
			Units -> Bar Milli,
			Description -> "The target pressure to achieve by the end of the equilibration time.",
			Category -> "General"
		},
		EvaporationPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milli*Bar],
			Units -> Bar Milli,
			Description -> "The pressure at which the samples will be dried and concentrated after equilibration is completed.",
			Category -> "General"
		},
		Temperature -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> DateCoordinatesComparisonP[GreaterEqualP[0*Celsius]],
			Units -> {None, Celsius},
			Description -> "Trace of temperature vs date/time during the course of the lyophilization experiment.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		Pressure -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> DateCoordinatesComparisonP[GreaterEqualP[0*Millibar]],
			Units -> {None, Millibar},
			Description -> "Trace of pressure vs date/time during the course of the lyophilization experiment.",
			Category -> "Sensor Information",
			Abstract -> True
		}
	}
}];
