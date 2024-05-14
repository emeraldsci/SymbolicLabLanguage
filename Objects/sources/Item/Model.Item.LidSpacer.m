(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, LidSpacer], {
	Description->"Model information for a frame that sits on top of an SBS-format plate to raise the plate lid above the top surface of the plate.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Material-> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "The material of which the lid spacer is composed.",
			Category -> "Physical Properties"
		},
		MinClearance -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "The minimum height above the top surface of the plate at which the lid will be held. The actual distance between the top surface of the plate and the inner bottom surface of the lid depends on whether the lid edges or inner top surface make contact with the lid spacer.",
			Category -> "Physical Properties"
		}
	}
}];
