(* ::Package:: *)

DefineObjectType[Model[Qualification, WaterPurifier], {
	Description -> "Definition of a set of parameters for a qualification protocol that verifies the functionality of a water purifier.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* Passing Criteria *)
		ExpectedTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Celsius],
			Units -> Celsius,
			Description -> "The expected temperature of water dispensed by this water purifier.",
			Category -> "Passing Criteria"
		},
		TemperatureTolerance  -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Celsius],
			Units -> Celsius,
			Description -> "The allowed deviation above or below the expected temperature of water dispensed by this water purifier.",
			Category -> "Passing Criteria"
		},
		ExampleQualityReportImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An example image of a quality report for a water purifier with this qualification model.",
			Category -> "Passing Criteria"
		},
		DispenseTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Minute],
			Units -> Minute,
			Description -> "The amount of time for which operators should dispense water during this model of qualification.",
			Category -> "Passing Criteria"
		},
		MinVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Liter],
			Units -> Liter,
			Description -> "The minimum amount of water that is expected to be dispensed within DispenseTime during this model of qualification. If the instrument model includes the volume dispensed in its quality report, this should be populated. If it does not, this should be Null.",
			Category -> "Passing Criteria"
		}
	}
}];