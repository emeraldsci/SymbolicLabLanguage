(* ::Package:: *)

DefineObjectType[Object[Program, EngineBenchmark], {
	Description -> "Stores looping information and parameters for a mock Rosetta procedure which utilizes every task type to test Rosetta's speed and integration behavior.",
	CreatePrivileges -> None,
	Cache->Session,
	Fields -> {
		(* -- Scanning Tests -- *)
		Containers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "The containers selected via a resource picking task.",
			Category -> "Scanning Tests"
		},

		(* -- PDU Tests -- *)
		PDUPoweredInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "The instrument which is turned on with a PDU task after being selected in an instrument selection task.",
			Category -> "PDU Tests"
		},
		PDUTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Second],
			Units -> Minute,
			Description -> "The length of time for which the PDU is turned on during a PDU task.",
			Category -> "PDU Tests"
		},

		(* -- Sensor Tests -- *)
		Sensor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor],
			Description -> "The sensor whose current value is queried during the record and monitor sensor tasks.",
			Category -> "Sensor Tests"
		},
		RecordedSensorData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "Data recorded during a RecordSensor task.",
			Category -> "Sensor Tests"
		}
	}
}];
