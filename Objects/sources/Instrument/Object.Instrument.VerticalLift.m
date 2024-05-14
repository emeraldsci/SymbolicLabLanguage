

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, VerticalLift], {
	Description->"A vertical lift storage unit (VLM) used to store samples.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		NominalTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The current temperature the vertical lift is set to maintain.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		NumberOfTrays -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The current number of trays installed in this VLM.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		MaxNumberOfTrays -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxNumberOfTrays]],
			Pattern :> GreaterP[0, 1],
			Description -> "The maximum number of trays that can be installed in this vertical lift, assuming all contents fit within the height of the trays.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		TotalProductVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],TotalProductVolume]],
			Pattern :> GreaterP[0*Foot^3],
			Description -> "The total volume that this vertical lift can store.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		TemperatureSensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Sensornet temperature probe monitoring this instrument.",
			Category -> "Sensor Information",
			Abstract -> True
		},
		InternalDimensions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],InternalDimensions]],
			Pattern :> {GreaterP[0*Meter],GreaterP[0*Meter],GreaterP[0*Meter]},
			Description -> "The size of one tray in the{X (left-to-right), Y (back-to-front), Z (bottom-to-top)} directions.",
			Category -> "Dimensions & Positions",
			Abstract -> True
		},
		APIVLMStatus -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Ready | Running | Error,
			Description -> "The status of the VLM API that determines if the instrument is in a usable state.",
			Category -> "Organizational Information",
			AdminViewOnly -> True
		},
		APIVLMIdentifier -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Description -> "The unique machine identifier used by the Modula software to make API calls.",
			Category -> "Organizational Information",
			AdminViewOnly -> True
		},
		CurrentShelf -> {
			Format -> Single,
			Class -> {Date, String, Link, Link, Link},
			Pattern :> {_?DateObjectQ, _String, _Link, _Link, _Link | Null},
			Relation -> {Null, Null, Object[User, Emerald], Object[Container, Shelf], Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Headers -> {"Date Called", "Request ID", "User", "Shelf", "Protocol"},
			Description -> "The shelf that is currently in the VLM bay such that objects on this shelf can be picked.",
			Category -> "Organizational Information",
			AdminViewOnly -> True
		},
		ShelfReturnTime -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The time at which the CurrentShelf will be returned from the VLM bay.",
			Category -> "Organizational Information",
			AdminViewOnly -> True
		},
		RequestedShelves -> {
			Format -> Multiple,
			Class -> {Date, String, Link, Link, Link},
			Pattern :> {_?DateObjectQ, _String, _Link, _Link, _Link | Null},
			Relation -> {Null, Null, Object[User, Emerald], Object[Container, Shelf], Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Headers -> {"Date Requested", "Request ID", "User", "Shelf", "Protocol"},
			Description -> "A queue of the VLM shelves requested by protocols running in Engine which need to store or resource pick samples. New required shelves are added to the end of the list and the next shelf is taken from the top of the list.",
			Category -> "Organizational Information",
			AdminViewOnly -> True
		}
	}
}];
