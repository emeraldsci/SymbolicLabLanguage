

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Instrument, Disruptor], {
	Description->"Used for mixing liquid samples in tubes or plates by simultaneously agitating and vortexing at high speed.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		MaxRotationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MaxRotationRate]],
			Pattern :> GreaterP[(0*Revolution)/Second],
			Description -> "Maximum speed at which the vortex can spin samples.",
			Category -> "Operating Limits"
		},
		MinRotationRate -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],MinRotationRate]],
			Pattern :> GreaterP[(0*Revolution)/Second],
			Description -> "Minimum speed at which the vortex can spin samples.",
			Category -> "Operating Limits"
		}
	}
}];
