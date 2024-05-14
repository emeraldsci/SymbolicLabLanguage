(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part,StirBlade],{
	Description->"Model information for a stir blade used to agitate liquid samples to induce the formation of foam during a dynamic foam analysis experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields->{
		(* --- Washing ---*)
		PreferredWashSolvent->{
			Format->Multiple,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Model[Sample,StockSolution],
				Model[Sample]
			],
			Description->"The chemicals that are preferred for use in washing this stir blade.",
			Category->"Washing"
		}
	}
}];
