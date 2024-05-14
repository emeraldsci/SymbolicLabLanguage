(* ::Package:: *)

DefineObjectType[Model[Qualification, EngineBenchmark], {
  	Description -> "Stores information and parameters used to create a mock Engine procedure which utilizes every task type to test Engine's speed and integration behavior.",
  	CreatePrivileges -> None,
		Cache->Session,
  	Fields -> {
		(* -- Scanning Tests -- *)
		WaterModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The type of water which are dispensed and selected during a resource picking task.",
			Category -> "Scanning Tests"
		},
		(* -- Sensor Tests -- *)
		SensorModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sensor],
			Description -> "The type of sensor whose current value is queried.",
			Category -> "Sensor Tests"
		}
	}
}];
