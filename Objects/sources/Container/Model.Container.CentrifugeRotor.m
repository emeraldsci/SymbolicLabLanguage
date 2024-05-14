(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container, CentrifugeRotor], {
	Description->"A rotor that goes into a centrifuge to hold containers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		RotorType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CentrifugeRotorTypeP,
			Description -> "The construction type of the rotor, such as swinging-bucket or fixed-angle.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		RotorAngle -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> RotorAngleP,
			Description -> "The angle of the samples in the ultracentrifuge rotor that will be applied to spin the provided samples.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		NumberOfBuckets -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of swinging buckets the rotor can hold.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		BalancePositions -> {
			Format -> Multiple,
			Class -> {String, String},
			Pattern :> {LocationPositionP, LocationPositionP},
			Description -> "A list of pairs of positions (corresponding to the Positions field) that are directly across from one another in the rotor.",
			Category -> "Container Specifications",
			Headers -> {"Position", "Counterbalancing position"}
		},
		MaxRadius -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The distance from the center of the rotor to the bottom of a sample holder.",
			Category -> "Operating Limits"
		},
		MaxRotationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[MaxForce], Field[MaxRadius]}, ECL`RCFToRPM[Field[MaxForce], Field[MaxRadius]]],
			Pattern :> GreaterEqualP[0*RPM],
			Description -> "The maximum number of rotations per minute this rotor is capable of.",
			Category -> "Operating Limits"
		},
		MaxForce -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> GreaterEqualP[0*GravitationalAcceleration],
			Description -> "The maximum relative centrifugal force this rotor is capable of.",
			Category -> "Operating Limits"
		},
		MaxImbalance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The maximum amount of imbalance the rotor can tolerate while still operating properly.",
			Category -> "Operating Limits"
		},
		Buckets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, CentrifugeBucket][Rotor],
			Description -> "Centrifuge bucket models that can be used with this model of centrifuge rotor.",
			Category -> "Compatibility"
		}
	}
}];
