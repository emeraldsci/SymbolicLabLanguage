(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, TubingCutter], {
	Description->"A model of a part that is used to cut tubing.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		BladeType->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BladeTypeP,
			Description -> "The type of blade that .",
			Category -> "Part Specifications",
			Abstract -> True
		},
		MinDiameter->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli Meter],
			Units -> Milli Meter,
			Description -> "The minimum outer diameter of tubing this jig can reliably position for cutting as dictated by the jig channel.",
			Category -> "Part Specifications",
			Abstract -> True
		},
		MaxDiameter->{
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli Meter],
			Units -> Milli Meter,
			Description -> "The maximum outer diameter of tubing this jig can reliably position for cutting as dictated by the jig channel.",
			Category -> "Part Specifications",
			Abstract -> True
		}
	}
}];
