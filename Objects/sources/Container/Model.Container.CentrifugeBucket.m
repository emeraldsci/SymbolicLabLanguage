

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, CentrifugeBucket], {
	Description->"Model information for a bucket that holds sample containers and fits into a swinging bucket centrifuge rotor.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Rotor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, CentrifugeRotor][Buckets],
			Description -> "The rotor model with which this model of centrifuge bucket is used.",
			Category -> "Container Specifications"
		},
		MaxRadius -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The maximum distance sample-holding containers will reach from the rotor's center of rotation.",
			Category -> "Container Specifications"
		},
		MaxRotationRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Revolution)/Minute],
			Units -> Revolution/Minute,
			Description -> "The maximum speed at which this centrifuge bucket can safely tolerate being spun.",
			Category -> "Operating Limits"
		},
		MaxForce -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*GravitationalAcceleration],
			Units -> GravitationalAcceleration,
			Description -> "The maximum relative centrifugal force (acceleration away from the center of rotation) that this centrifuge bucket is rated to safely tolerate.",
			Category -> "Operating Limits"
		},
		MaxStackHeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "The maximum height of two stacked plates that the bucket during centrifugation.",
			Category -> "Operating Limits"
		}
	}
}];
