(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Part, CuttingJig], {
	Description->"A part that is used to position tubing and cut it to specified lengths.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		TubingCutters->{
			Format -> Multiple,
			Class -> {Link,Real},
			Pattern :> {_Link,GreaterP[0*Meter]},
			Relation -> {Object[Part, TubingCutter], Null},
			Units -> {None,Meter},
			Description -> "The cutter objects that are attached to this jig and the lengths of tubing they cut as dictated by their placements.",
			Category -> "Part Specifications",
			Abstract -> True,
			Headers -> {"Tubing Cutter", "Length of cut"}
		}
	}
}];
