

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Container, FloatingRack], {
	Description->"A model of a container used to submerge tubes inside a liquid.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		SlotDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli*Meter],
			Units -> Meter Milli,
			Description -> "Diameter of each round position used to hold tubes.",
			Category -> "Dimensions & Positions"
		},
		SlotShape -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SlotShapeP,
			Description -> "The shape of slots of this floating rack in the X-Y plane.",
			Category -> "Dimensions & Positions"
		},
		RackThickness -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Meter],
			Units -> Meter Milli,
			Description -> "The height of the floating rack.",
			Category -> "Dimensions & Positions"
		},
		NumberOfSlots -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "Number of slots in the rack that are capable of holding tubes.",
			Category -> "Dimensions & Positions"
		},
		Color -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PartColorP,
			Description -> "The color of this floating rack.",
			Category -> "Physical Properties"
		}
	}
}];
