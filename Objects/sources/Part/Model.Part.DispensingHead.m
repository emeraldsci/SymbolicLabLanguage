(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part, DispensingHead], {
	Description->"Model information for an interchangeable head used to dispense fluids into the destination container in a Bufferbot type liquid handler.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		AllowedTubingDiameter -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0*Inch],
			Units -> Inch,
			Description -> "Outside diameter of tubing compatible with this dispensing head.",
			Category -> "Part Specifications"
		},
		MaxBottleDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Millimeter],
			Units -> Millimeter,
			Description -> "Maximum bottle neck inside diameter that can be used with this dispensing head.",
			Category -> "Part Specifications"
		},	
		MinContainerDepth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Millimeter],
			Units -> Millimeter,
			Description -> "Depth of the shortest container that can be used with this dispensing head.",
			Category -> "Part Specifications"
		},
		MaxContainerDepth -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Millimeter],
			Units -> Millimeter,
			Description -> "Depth of the tallest container that can be used with this dispensing head.",
			Category -> "Part Specifications"
		}		
		
	}
}];
