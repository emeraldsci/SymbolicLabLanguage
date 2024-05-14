(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Replace, Lamp], {
	Description->"Definition of a set of parameters for a maintenance protocol that replaces a lamp on the maintenance target.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		BlowGunModel-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "The type of blow gun used to clean the replacement lamp's surface.",
			Category -> "General"
		},
		LightMeter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "The type of light meter used to calibrate the replacement lamp.",
			Category -> "General"
		},
		CoolDownTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0Minute],
			Units -> Minute,
			Description -> "Length of time to allow the lamp to cool down before trying to replace it.",
			Category -> "General"
		},
		BurnInTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0Minute],
			Units -> Hour,
			Description -> "Length of time the lamp should be turned on for before new protocols are run on the instrument.",
			Category -> "General"
		}
	}
}];
