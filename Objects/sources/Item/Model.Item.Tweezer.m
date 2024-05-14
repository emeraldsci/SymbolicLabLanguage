(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Tweezer], {
	Description->"Model information for a device used to grasp an item too small to be handled by human hands.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TipType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> TweezerTipTypeP,
			Description -> "The shape of the tip of the tweezer used to grasp items.",
			Category -> "Item Specifications"	
		},
		Material-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The type of material used for the tweezer.",
			Category -> "Physical Properties"
		},
		TweezerLength-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> Centimeter,
			Description -> "The overall length of the tweezer.",
			Category -> "Dimensions & Positions"
		},
		TipWidth-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> Centimeter,
			Description -> "The width of the tweezer tip used to grasp items.",
			Category -> "Dimensions & Positions"
		},
		TipLength-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units-> Centimeter,
			Description -> "The length of the tweezer tip used to grasp items.",
			Category -> "Dimensions & Positions"
		},
		CalibrationWeights -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, CalibrationWeight][WeightHandle]
			],
			Description -> "The calibration weights for which this tweezer is the appropriate handling device.",
			Category -> "Item Specifications"
		}		
	}
}];
