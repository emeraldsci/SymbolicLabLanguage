

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, CentrifugeRotor], {
	Description->"A rotor that goes into a centrifuge to hold buckets or plates.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		RotorType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], RotorType]],
			Pattern :> CentrifugeRotorTypeP,
			Description -> "The construction type of the rotor, such as swing-bucket or fixed.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		NumberOfBuckets -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], NumberOfBuckets]],
			Pattern :> GreaterP[0, 1],
			Description -> "The number of swinging buckets used to hold sample racks on a single rotor.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		BalancePositions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], BalancePositions]],
			Pattern :> {LocationPositionPairP..},
			Description -> "A list of pairs of positions (corresponding to the Positions field) that are directly across from one another in the rotor.",
			Category -> "Container Specifications"
		},
		MaxRadius -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxRadius]],
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "The distance from the center of the rotor to the bottom of a sample holder.",
			Category -> "Operating Limits"
		},
		MaxForce -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxForce]],
			Pattern :> GreaterEqualP[0*GravitationalAcceleration],
			Description -> "The maximum relative centrifugal force this rotor is capable of.",
			Category -> "Operating Limits"
		},
		MaxRotationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[MaxForce], Field[MaxRadius]}, ECL`RCFToRPM[Field[MaxForce], Field[MaxRadius]]],
			Pattern :> GreaterEqualP[0*RPM],
			Description -> "The maximum rotations per minute this rotor is capable of.",
			Category -> "Operating Limits"
		},
		MaxImbalance -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxImbalance]],
			Pattern :> GreaterP[0*Gram],
			Description -> "The maximum amount of imbalance the rotor can tolerate while still operating properly.",
			Category -> "Operating Limits"
		},
		Buckets -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Buckets]],
			Pattern :> {ObjectReferenceP[Model[Container, CentrifugeBucket]]...},
			Description -> "Centrifuge bucket models that can be used with this model of centrifuge rotor.",
			Category -> "Model Information"
		}
	}
}];
