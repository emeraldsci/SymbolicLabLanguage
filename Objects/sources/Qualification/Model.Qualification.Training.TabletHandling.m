(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Qualification,Training,TabletHandling], {
	Description->"Definition of a set of parameters for a qualification protocol that verifies an operator's ability to demonstrate their knowledge of tablet charging stations and using VNC.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TabletChargingStation->{
				Units -> None,
				Relation -> Model[Container] | Object[Container],
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Description -> "The tablet charging station object that the operator will be asked to find. Note that this list will be optimized by location such that operators take the shortest path between the objects, starting at the first object in the list.",
				Category -> "General"
				},
			TabletHandlingString->{
				Units -> None,
				Relation -> Null,
				Format -> Single,
				Class -> String,
				Pattern :> _String,
				Description -> "The string contained in the text file that will test the user's ability to use VNC.",
				Category -> "General"
				},
		TabletHandlingTrainingInstrument -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "The instrument used to train operators on how to operate VNC.",
			Category -> "General"
		}
	}
}
]