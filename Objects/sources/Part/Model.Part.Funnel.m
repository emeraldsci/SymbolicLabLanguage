(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, Funnel], {
	Description->"A hollow cone with a tube extending from the smaller end used for transferring samples into containers with small apertures.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		FunnelMaterial -> {
		    Format -> Single,
		    Class -> Expression,
		    Pattern :> MaterialP,
		    Category -> "Part Specifications",
		    Description -> "The materials of which this part is made that come in direct contact with the samples it contains."
		},
		FunnelType -> {
		    Format -> Single,
		    Class -> Expression,
		    Pattern :> FunnelTypeP,
		    Category -> "Part Specifications",
		    Description -> "The type of the funnel for use with liquids or solids."
		},
		StemLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[Milli Meter],
			Units -> Milli Meter,
			Description -> "The length of the tube extending from the cone portion of the funnel.",
			Category -> "Physical Properties"
		},
		StemDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[Milli Meter],
			Units -> Milli Meter,
			Description -> "The outer diameter of the tube extending from the cone portion of the funnel.",
			Category -> "Physical Properties"
		},
		ContainerMaterials -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Category -> "Container Specifications",
			Description -> "The materials of which this container is made that come in direct contact with the samples it contains.",
			Category -> "Physical Properties"
		},
		MouthDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[Milli Meter],
			Units -> Milli Meter,
			Description -> "The inner diameter of the mouth at the widest point of the funnel cone.",
			Category -> "Physical Properties"
		},
		MaxVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Milliliter],
			Units -> Milliliter,
			Description -> "The maximum volume of fluid that funnels of this model can hold.",
			Category -> "Physical Properties"
		}
	}
}];
