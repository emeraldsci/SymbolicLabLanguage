(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Item, Clamp], {
	Description->"Model infomation for a fastening tool to hold objects together tightly to prevent movement or separation through the application of inward pressure.",
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
			Description -> "The material that the mouth of the clamp is made of.",
			Category -> "Physical Properties",
			Abstract -> True
		},
		TaperGroundJointSize -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> GroundGlassJointSizeP,
			Description -> "The taper ground joint size designations that this clamp is capable of holding, used to secure a cap to a container.",
			Category -> "Physical Properties"
		}
	}
}]