(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Screwdriver], {
	Description->"Model information for a linear tool used to turn screws, bolts, nuts and/or similar items.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		DriveType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ScrewdriveTypeP,
			Description -> "The shape at the tip of the shaft of the screwdriver - indicating the type of screws it is compatible with.",
			Category -> "Item Specifications",
			Abstract -> True
		},
		DriveSize -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> GreaterP[0*Inch]|GreaterP[0*Millimeter],
			Units -> None,
			Description -> "The physical measured size of the feature described by the DriveType.",
			Category -> "Item Specifications",
			Abstract -> True
		},
		DriveSizeCode -> {
			Format -> Single,
			Class -> String,
			Pattern :> ScrewdriveSizeCodeP,
			Units -> None,
			Description -> "The shorthand code that describes the size of the screwdriver tip.",
			Category -> "Item Specifications",
			Abstract -> True
		},
		TipThickness -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> GreaterP[0*Inch]|GreaterP[0*Millimeter],
			Units -> None,
			Description -> "The thickness of each blade of the tip that enters the slot of a screw. Applicable to DriveTypes composed of blades only.",
			Category -> "Item Specifications"
		},
		ShaftLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Centimeter],
			Units -> Centimeter,
			Description -> "The length of the screwdriver, not including the handle's length.",
			Category -> "Item Specifications"
		},
		ShaftDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The width of the body of the screwdriver, connecting the handle and the tip.",
			Category -> "Item Specifications"
		},
		HandleLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0Centimeter],
			Units -> Centimeter,
			Description -> "The length of the part of the screwdriver intended to be held.",
			Category -> "Item Specifications"
		},
		RemovableBit -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			Description -> "Indicates if this item can be used with multiple tips.",
			Category -> "Item Specifications"
		},
		BitConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ScrewdriverBitFootprintP,
			Units -> None,
			Description -> "The footprint of removable tip that is compatible with this screwdriver.",
			Category -> "Item Specifications"
		},
		SharpTip -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			Description -> "Indicates if the tip of this item tapers to a point, rather than a blunt end.",
			Category -> "Item Specifications"
		},
		Magnetizable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			Description -> "Indicates if the tip of this item is magnetized or can be made to be so.",
			Category -> "Item Specifications"
		}
	}
}];
