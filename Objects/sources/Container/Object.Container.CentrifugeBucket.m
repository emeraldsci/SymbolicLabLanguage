

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Container, CentrifugeBucket], {
	Description->"A bucket that fits into a centrifuge rotor to hold sample containers for centrifugation.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Rotor -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Rotor]],
			Pattern :> ObjectReferenceP[Model[Container, CentrifugeRotor]],
			Description -> "The rotor model with which this model of centrifuge bucket is used.",
			Category -> "Container Specifications"
		},
		MaxRadius -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxRadius]],
			Pattern :> GreaterP[0*Milli*Meter],
			Description -> "The maximum distance sample-holding containers will reach from the rotor's center of rotation.",
			Category -> "Container Specifications"
		},
		MaxRotationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxRotationRate]],
			Pattern :> GreaterP[(0*Revolution)/Minute],
			Description -> "The maximum spin rate at which this centrifuge bucket is rated to safely tolerate.",
			Category -> "Operating Limits"
		},
		MaxForce -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxForce]],
			Pattern :> GreaterEqualP[0*GravitationalAcceleration],
			Description -> "The maximum relative centrifugal force (acceleration away from the center of rotation) that this centrifuge bucket is rated to safely tolerate.",
			Category -> "Operating Limits"
		}
	}
}];
