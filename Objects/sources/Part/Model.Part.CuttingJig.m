(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Part, CuttingJig], {
	Description->"A model of a part that is used to position tubing and cut it to specified lengths.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
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
		},
		TubingCutters->{
			Format -> Multiple,
			Class -> {Link,Real},
			Pattern :> {_Link,GreaterP[0*Meter]},
			Relation -> {Model[Part, TubingCutter], Null},
			Units -> {None,Meter},
			Description -> "The cutter objects that are attached to this jig and the lengths of tubing they cut as dictated by their placements.",
			Category -> "Part Specifications",
			Abstract -> True,
			Headers -> {"Tubing Cutter", "Length of cut"}
		}
	}
}];
