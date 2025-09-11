(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, Clamp], {
	Description->"Model infomation for a fastening tool associated with specific instruments to hold objects together tightly to prevent movement or separation through the application of inward pressure.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		InnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The maximum diameter of the clamp's mouth, which will fit over the neck of glassware or outer diameter of tubing.",
			Category -> "Dimensions & Positions"
		},
		SecondaryInnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "If this clamp has multiple mouths (eg a keck clamp), the maximum diameter of the clamp's smaller mouth, which will fit over the neck of glassware or outer diameter of tubing.",
			Category -> "Dimensions & Positions"
		},
		ClampColor -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PartColorP,
			Description -> "The color of this clamp, used for the purpose of rapid identification of clamp size.",
			Category -> "Physical Properties"
		},
		ClampMaterial -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material of which the mouth of the clamp is made.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		TaperGroundJointSize -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> GroundGlassJointSizeP,
			Description -> "The taper ground joint size designation that this clamp is capable of holding.",
			Category -> "Physical Properties"
		},
		MinAperture -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Millimeter],
			Units -> Millimeter,
			Description -> "For adjustable clamps, the smallest opening the clamping mechanism is able to adopt.",
			Category -> "Dimensions & Positions"
		},
		MaxAperture -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "For adjustable clamps, the largest opening the clamping mechanism is able to adopt.",
			Category -> "Dimensions & Positions"
		},
		ClampType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ClampTypeP, (* BossHead | Pronged | Keck | Hose | Sanitary | Pinch *)
			Description -> "The colloquial class of the clamp. A Pronged clamp has two or more fingers for holding general chemistry labware and equipment. A Sanitary clamp is used to connect pipes or pipe fittings in a leak-free and contamination-resistant way. A Hose clamp is used to secure flexible tubing to a barbed fitting. A Pinch clamp is used to stop or restrict flow through flexible tubing. A BossHead clamp is used for holding a ring stand or rod in a groove or slot with screw. A Keck clamp is used for securing a connection between two tapered, glass joints.",
			Category -> "General",
			Abstract -> True
		},
		FlexibleArm -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the arm of the clamp is has one or more joints or gooseneck springs enabling it to be contorted to be reconfigured into a wide-range of shapes or positions.",
			Category -> "General"
		},
		ArmLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Description -> "For clamps that have a rigid or flexible arm, the distance that this arm extends.",
			Category -> "Dimensions & Positions"
		},
		AuxiliaryClamp -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the item has an additional, built-in clamp.",
			Category -> "General"
		},
		AuxiliaryClampType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ClampTypeP, (* BossHead | Pronged | Keck | Hose | Sanitary | Pinch *)
			Description -> "The colloquial class for the additional, built-in clamp.  A Pronged clamp has two or more fingers for holding general chemistry labware and equipment. A Sanitary clamp is used to connect pipes or pipe fittings in a leak-free and contamination-resistant way. A Hose clamp is used to secure flexible tubing to a barbed fitting. A Pinch clamp is used to stop or restrict flow through flexible tubing. A BossHead clamp is used for holding a ring stand or rod in a groove or slot with screw. A Keck clamp is used for securing a connection between two tapered, glass joints.",
			Category -> "General"
		},
		MinAuxiliaryClampAperture -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Millimeter],
			Description -> "The smallest opening able to be adopted by the additional, built-in clamping mechanism.",
			Category -> "Dimensions & Positions"
		},
		MaxAuxiliaryClampAperture -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Description -> "The largest opening able to be adopted by the additional, built-in clamping mechanism.",
			Category -> "Dimensions & Positions"
		}

	}
}];
