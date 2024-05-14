

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

DefineObjectType[Object[Maintenance, Replace, Lamp], {
	Description->"A protocol that replaces the lamp of the target instrument.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		LightMeter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument]|Model[Instrument],
			Description -> "The light meter used to calibrate the replacement lamp.",
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
