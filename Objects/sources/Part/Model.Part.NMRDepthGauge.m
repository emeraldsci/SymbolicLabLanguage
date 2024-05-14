(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, NMRDepthGauge], {
	Description->"Model information for a part used to set the depth of an NMR tube into an NMR shuttle so as to center the sample in the coil.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TubeDiameters -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The NMR tube diameters that this gauge can be used to position.",
			Category -> "Dimensions & Positions"
		},
		DetectionHeights -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units-> Centimeter,
			Description -> "For each member of TubeDiameters, the height of the region marked on the gauge representing the area that the coils use for detection.",
			Category -> "Dimensions & Positions"
		},
		BaseDepths -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Centimeter,
			Description -> "For each member of TubeDiameters, the operating distance between the base of the gauge and the height corresponding to the center of the NMR coils.",
			Category -> "Dimensions & Positions"
		},
		MaxBaseDepth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Centimeter],
			Units -> Centimeter,
			Description -> "The maximum distance between the base of the depth gauge and the height corresponding to the center of the NMR coils.",
			Category -> "Dimensions & Positions"
		},
		AdjustableBase -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the base that contacts the NMR tubes can be raised and lowered.",
			Category -> "Part Specifications"
		}
	}
}];
