

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, RobotArm], {
	Description->"A robotic arm used for moving plates or other labware between instruments or locations in physical space.",
	CreatePrivileges->None,
	Cache->Download,
	Fields-> {
		LiquidHandlerIntegrationOffset -> {
			Format -> Single,
			Class -> {Real, Real, Real, Real},
			Pattern :> {DistanceP, DistanceP, DistanceP, RangeP[-180AngularDegree, 180AngularDegree]},
			Units -> {Meter, Meter, Meter, AngularDegree},
			Description -> "Precise offset of the robot arm coordinate system from the coordinate system of the liquid handler the arm is integrated with.",
			Headers -> {"XOffset", "YOffset", "ZOffset", "Rotation"},
			Category -> "Dimensions & Positions",
			Abstract -> True
		},
		IntegratedLiquidHandler -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, LiquidHandler][IntegratedExternalRobotArm],
			Description -> "The liquid handler that this arm is capable of exchanging labware with automatically.",
			Category -> "Integrations"
		}
	}
}];