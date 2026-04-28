

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Part, Funnel], {
	Description->"A hollow cone with a tube extending from the smaller end used for transferring samples into containers with small apertures.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		FunnelMaterial -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], FunnelMaterial]],
			Pattern :> MaterialP,
			Category -> "Part Specifications",
			Description -> "The materials of which this part is made that come in direct contact with the samples it contains."
		},
		FunnelType -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], FunnelType]],
			Pattern :> FunnelTypeP,
			Category -> "Part Specifications",
			Description -> "The type of the funnel for use with liquids or solids."
		},
		StemLength -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], StemLength]],
			Pattern :> GreaterP[Milli Meter],
			Description -> "The length of the tube extending from the cone portion of the funnel.",
			Category -> "Physical Properties"
		},
		StemDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], StemDiameter]],
			Pattern :> GreaterP[Milli Meter],
			Description -> "The outer diameter of the tube extending from the cone portion of the funnel.",
			Category -> "Physical Properties"
		},
		ContainerMaterials -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], ContainerMaterials]],
			Pattern :> MaterialP,
			Category -> "Container Specifications",
			Description -> "The materials of which this container is made that come in direct contact with the samples it contains.",
			Category -> "Physical Properties"
		},
		MouthDiameter -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MouthDiameter]],
			Pattern :> GreaterP[Milli Meter],
			Description -> "The inner diameter of the mouth at the widest point of the funnel cone.",
			Category -> "Physical Properties"
		},
		MaxVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxVolume]],
			Pattern :> GreaterP[0 Milliliter],
			Description -> "The maximum volume of fluid that this funnel can hold.",
			Category -> "Physical Properties"
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature that this funnel can be exposed to and maintain structural integrity.",
			Category -> "Physical Properties"
		}
	}
}];
