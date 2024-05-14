(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, ScrewdriverBit], {
	Description->"Model information for a removable tip, or set of tips, of a linear tool used to turn screws, bolts, nuts and/or similar items.",
	CreatePrivileges->None,
	Cache->Session,
	Fields ->{
		DriveType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ScrewdriveTypeP,
			Description -> "The shape at the tip that contacts screws - indicating the type of screws it is compatible with.",
			Category -> "Item Specifications",
			Abstract -> True
		},
		DriveSize -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0*Inch]|GreaterP[0*Millimeter],
			Units -> None,
			Description -> "For each member of DriveType, the physical measured size of the feature described by the DriveType.",
			Category -> "Item Specifications",
			Abstract -> True,
			IndexMatching -> DriveType
		},
		DriveSizeCode -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> ScrewdriveSizeCodeP,
			Units -> None,
			Description -> "For each member of DriveType, the shorthand code that describes the size of the screwdriver tip that contacts screws.",
			Category -> "Item Specifications",
			Abstract -> True,
			IndexMatching -> DriveType
		},
		TipThickness -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0*Inch]|GreaterP[0*Millimeter]|Null,
			Units -> None,
			Description -> "For each member of DriveType, the thickness of each blade of the tip that enters the slot of a screw. Applicable to DriveTypes composed of blades only.",
			Category -> "Item Specifications",
			IndexMatching -> DriveType
		},
		BitConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ScrewdriverBitFootprintP,
			Units -> None,
			Description -> "The footprint of this removable tip that connects it with a screwdriver body.",
			Category -> "Item Specifications"
		},
		SharpTip -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			Description -> "For each member of DriveType, indicates if the tip of this item tapers to a point, rather than a blunt end.",
			Category -> "Item Specifications",
			IndexMatching -> DriveType
		},
		Magnetizable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Units -> None,
			Description -> "Indicates if this tip/tip kit is magnetized or can be made to be so.",
			Category -> "Item Specifications"
		}
	}
}];