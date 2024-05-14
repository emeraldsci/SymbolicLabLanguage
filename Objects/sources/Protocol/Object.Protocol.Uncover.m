(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Protocol, Uncover], {
	Description->"A protocol that will remove caps, lids, or plate seals to the tops of containers in order to expose their contents.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Instruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, Crimper],
				Object[Instrument, Crimper],
				Model[Part, CapPrier],
				Object[Part, CapPrier]
			],
			Description -> "The device used to help remove the cover to the top of the container.",
			Category -> "General"
		},
		DecrimpingHeads -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, DecrimpingHead],
				Object[Part, DecrimpingHead]
			],
			Description -> "The part that attaches to the crimper instrument and is used to remove crimped caps from vials.",
			Category -> "General"
		},
		CrimpingPressures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 PSI],
			Units -> PSI,
			Description -> "The pressure of the gas that is connected to the pneumatic crimper and determines the strength used to crimp or decrimp the crimped cap.",
			Category -> "General"
		},
		CapRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Rack],
				Object[Container, Rack]
			],
			Description -> "The cap racks that should be used to hold and identify the caps, if they do not have a barcode because they are too small.",
			Category -> "General"
		},
		Environment -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Model[Container, Bench],
				Model[Container, OperatorCart],

				Object[Instrument],
				Object[Container],
				Object[Item],
				Object[Part]

			],
			Description -> "The environment that should be used to perform the covering.",
			Category -> "General"
		},
		SterileTechnique -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if a sterile environment should be used for the uncovering.",
			Category -> "General"
		}
	}
}];
