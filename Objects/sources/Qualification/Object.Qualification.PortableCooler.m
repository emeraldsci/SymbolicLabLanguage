(* ::Package:: *)

DefineObjectType[Object[Qualification, PortableCooler], {
	Description -> "A protocol that verifies the functionality of the portable cooler target.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		TimePeriod -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Day],
			Units -> Day,
			Description -> "The time period over which to qualify the portable cooler.",
			Category -> "General"
		},
		SamplingRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "The rate at which to downsample the portable cooler data before analysis.",
			Category -> "General"
		},
		TemperatureData -> {
			Format -> Single,
			Class -> QuantityArray,
			Pattern :> QuantityCoordinatesP[{None, Celsius}],
			Units -> {None, Celsius},
			Description -> "The downsampled data assessed by this qualification.",
			Category -> "Experimental Results"
		},
		MaintenanceTimePeriods -> {
			Format -> Multiple,
			Class -> {Link, Date, Date},
			Pattern :> {_Link, _?DateObjectQ, _?DateObjectQ},
			Relation -> {Object[Maintenance]|Object[Qualification]|Object[Protocol], Null, Null},
			Description -> "The start datetime and end datetime for any time periods within the qualification assessment period that the target is actively undergoing a maintenance.",
			Category -> "Experimental Results",
			Headers -> {"Maintenance", "Start Date", "End Date"}
		}
	}
}];
