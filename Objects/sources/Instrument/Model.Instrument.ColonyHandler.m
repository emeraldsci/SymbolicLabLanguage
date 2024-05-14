(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument, ColonyHandler], {
	Description->"A model robotic colony handler used for streaking, picking, rearraying and imaging microbial, yeast and viral colonies.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Deck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container, Deck],
			Description -> "The deck layout that is installed on this type of colony handler.",
			Category -> "Instrument Specifications",
			Abstract -> True
		}
	}
}];
