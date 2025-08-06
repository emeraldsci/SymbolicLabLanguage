(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part, AlignmentTool], {
	Description->"A tool used to test and/or adjust the positioning and alignment of an instrument's components.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Cover -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item],
			Description -> "The cover that is used to hold the teaching needles (tips) in place so they don't fall out.",
			Category -> "Cover Information"
		}
	}
}];
