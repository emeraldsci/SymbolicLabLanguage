(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,Training,TabletHandling], {
	Description->"A protocol that verifies an operator's ability to demonstrate their knowledge of tablet charging stations and using VNC.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TabletChargingStation -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item],Object[Part],Object[Container],Object[Instrument]],
			Description -> "The tablet charging station object that the operator will be asked to find. Note that this list will be optimized by location such that operators take the shortest path between the objects, starting at the first object in the list.",
			Category -> "General"
		},

		TabletHandlingTrainingInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument],
			Description -> "The instrument used to train operators on how to operate VNC.",
			Category -> "General"
		},

		TabletHandlingUserInput -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Relation -> Null,
			Description -> "String input by user to test if they are connected to the right computer via VNC.",
			Category -> "General"
		},

		TabletHandlingString -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The string contained in the text file that will test the user's ability to use VNC.",
			Category -> "General"
		}
		}
}
]