(* ::Package:: *)

DefineObjectType[Model[Qualification, FreezePumpThawApparatus], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a freeze pump thaw apparatus.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		DissolvedOxygenMeter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument]
			],
			Description -> "The instrument used to measure the dissolved oxygen concentration of the qualification sample.",
			Category -> "General"
		},
		DissolvedOxygenReduction -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 * Percent],
			Units -> Percent,
			Description -> "The minimum percent by which the dissolved oxygen concentration of the qualification sample must decrease for the qualification to pass.",
			Category -> "General"
		},
		MaxVacuumPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Torr],
			Units -> Torr,
			Description -> "The maximum pressure measurement allowed during the pump portion of the freeze-pump-thaw cycles performed by this model of qualification for the qualification to pass.",
			Category -> "Passing Criteria"
		},
		TemperatureTolerance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Celsius],
			Units -> Celsius,
			Description -> "The deviation above or below the expected temperature allowed during the thaw portion of the freeze-pump-thaw cycles performed by this model of qualification for the qualification to pass.",
			Category -> "Passing Criteria"
		}
	}
}];
