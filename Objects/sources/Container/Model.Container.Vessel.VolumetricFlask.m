(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container, Vessel, VolumetricFlask], {
	Description->"A model for a volumetric flask used for precise preparation of solutions.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Precision -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milliliter],
			Units -> Milliliter,
			Description -> "The amount a volume measurement deviates from the mean when measured with the meniscus at this volumetric flask's marked line.",
			Category -> "Container Specifications"
		},
		CompatibleAdapters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Rack][CompatibleVolumetricFlasks],
			Description -> "The shaker adapters that can be used with this volumetric flask with mixing with shaker.",
			Category -> "Model Information"
		}
	}
}];
