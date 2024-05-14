(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Item, Needle], {
	Description->"Model information for disposable needles used for liquid transfers performed with syringes.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		ConnectionType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ConnectorP,
			Description -> "Indicates the manner by which the needle is connected to a syringe.",
			Category -> "Physical Properties"
		},
		Gauge -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "A number assigned to the needle indicating its outer diameter, inner diameter and wall thickness.",
			Category -> "Dimensions & Positions",
			Abstract -> True
		},
		InnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The diameter of the opening inside of the needle.",
			Category -> "Dimensions & Positions"
		},
		OuterDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The diameter of the outside of the needle including the thickness of the needle material.",
			Category -> "Dimensions & Positions"
		},
		NeedleLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Millimeter],
			Units -> Millimeter,
			Description -> "The length of the needle shaft measured from the end of the needle's hub to its tip.",
			Category -> "Dimensions & Positions",
			Abstract -> True
		},
		Bevel -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[Quantity[0, "Degrees"], Quantity[90, "Degrees"]],
			Units -> Quantity[1, "AngularDegrees"],
			Description -> "The angle of the needle point, where a smaller angle indicates a sharper needle.",
			Category -> "Dimensions & Positions",
			Abstract -> True
		}
	}
}];
