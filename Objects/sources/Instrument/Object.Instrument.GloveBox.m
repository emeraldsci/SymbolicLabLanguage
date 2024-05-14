(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, GloveBox], {
	Description->"A sealed container that is designed to manipulate samples under a separate atmosphere.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Pipettes->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument,Pipette]
			],
			Description -> "The pipettes that permanently are kept inside of this glove box.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		Tips->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Tips]
			],
			Description -> "The pipettes that permanently are kept inside of this glove box.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
		AntechamberSensors -> {
			Format -> Multiple,
			Class -> {Expression, Link},
			Pattern :> {Alternatives[Left, Right, Small, Large], _Link},
			Relation -> {None, Object[Sensor][DevicesMonitored]},
			Description -> "The sensor for respective GloveBox antichamber(s) in the form: {Antechamber, Sensor}. The antechamber is designated by the symbol Small, Large, Left or Right.",
			Headers -> {"Antechamber","Sensor"},
			Category -> "Sensor Information"
		}
	}
}];
