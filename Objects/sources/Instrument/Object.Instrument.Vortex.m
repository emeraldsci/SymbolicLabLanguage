(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, Vortex], {
	Description->"An instrument used for mixing liquid samples in tubes or plates by rotating at high speed.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		
		Format -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Format]],
			Pattern :> VortexTypeP,
			Description -> "Format of labware the vortex can mix.",
			Category -> "Instrument Specifications",
			Abstract -> True
		},
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
		},
		IntegratedSampleInspector -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, SampleInspector][IntegratedAgitator],
			Description -> "The sample inspector that contains this vortex such that samples can be agitated using the vortex and imaged by the sample inspector.",
			Category -> "Integrations"
		}
	}
}];
