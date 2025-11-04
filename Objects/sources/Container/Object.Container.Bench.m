

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, Bench], {
	Description->"A lab bench capable of holding small containers and instruments.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Balances -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, Balance],
			Description -> "The balances that are contained on this bench for weighing purposes.",
			Category -> "Instrument Specifications"
		},
		Pipettes->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument,Pipette],
			Description -> "The pipettes that permanently are kept inside of this glove box.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		IRProbe->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Temperature],
			Description -> "The IR temperature probe that should be used to measure the temperature of any samples transferred in this biosafety cabinet.",
			Category -> "Instrument Specifications"
		},
		ImmersionProbe->{
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor, Temperature],
			Description -> "The immersion probe that should be used to measure the temperature of any samples transferred in this biosafety cabinet.",
			Category -> "Instrument Specifications"
		},
		WorkstationComputer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, Computer],
			Description -> "The tablet or desktop computer which is mounted on this receiving bench.",
			Category -> "Integrations"
		}
	}
}];
