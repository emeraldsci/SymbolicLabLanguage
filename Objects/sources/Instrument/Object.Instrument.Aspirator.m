(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Aspirator], {
	Description->"A device that aspirates liquid out of a container or instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Capacity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Liter],
			Units -> Liter,
			Description -> "The maximum volume this instrument can aspirate.",
			Category -> "Instrument Specifications"
		},
		VacuumPump -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument]|Object[Part],
			Description -> "Vacuum pump used to aspirate liquid.",
			Category -> "Instrument Specifications"
		},
		AspiratorConnectors -> {
			Format -> Multiple,
			Class -> {Link,Expression},
			Pattern :> {_Link,FieldP[Output->Short]},
			Relation -> {Object[Part]|Object[Plumbing], None},
			Description -> "The tubing objects used to connect waste container to vacuum pump or aspirator tip.",
			Headers -> {"Tubing","Destination"},
			Category -> "Instrument Specifications"
		},
		MultiChannelAdapter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,AspiratorAdapter],
			Description -> "Multi-channel adapter for the aspirator.",
			Category -> "Instrument Specifications"
		},
		PipetteAdapter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part,AspiratorAdapter],
			Description -> "Single-channel pipette adapter for the aspirator.",
			Category -> "Instrument Specifications"
		},
		PipetteTipAdapter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Part, AspiratorAdapter],
			Description -> "Single-channel pipette tip adapter for the aspirator.",
			Category -> "Instrument Specifications"
		}
	}
}];
