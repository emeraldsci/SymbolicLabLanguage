(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Maintenance, Decontaminate, LiquidHandler], {
	Description->"Definition of a set of parameters for a maintenance protocol that decontaminates a liquid handler.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		SanitizationWipes -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item],
			Description -> "The model of the sanitization wipes that will be used for the decontamination.",
			Category -> "Sanitization"
		},
		SanitizationDuration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "The time duration required for the sanitizing agent to be left on surface in order to sterilize it.",
			Category -> "Sanitization"
		},
		IrradiationDuration -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Minute],
			Units -> Minute,
			Description -> "The time duration of the UV irradiation cycle for the instrument.",
			Category -> "Sanitization"
		}
	}
}];
