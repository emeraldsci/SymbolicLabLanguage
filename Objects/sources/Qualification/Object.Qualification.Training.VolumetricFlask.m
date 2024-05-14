(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Qualification,Training,VolumetricFlask], {
	Description->"A protocol that verifies an operator's ability to fill a volumetric flask.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		VolumetricFlasks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Vessel, VolumetricFlask],Object[Container, Vessel, VolumetricFlask]],
			Description -> "The volumetric flasks that were used to test the user's ability to measure amounts of a test sample using volumetric flasks.",
			Category -> "Volumetric Flask Skills"
		},
		VolumetricFlaskAmounts -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The volume capacities of the volumetric flasks that will be used to test the user's ability to use volumetric flasks.",
			Category -> "Volumetric Flask Skills"
		},
		VolumetricFlaskWaterDispenser -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument],Model[Instrument]],
			Description -> "The water purifier/dispenser that will be used to fill up the volumetric flasks for the volumetric flask module.",
			Category -> "Volumetric Flask Skills"
		}

		}
}
]