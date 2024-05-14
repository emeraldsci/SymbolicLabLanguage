(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Instrument, ColonyHandler], {
	Description->"A robotic colony handler used for streaking, picking, rearraying and imaging bacterial, yeast, and viral colonies.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		ColonyHandlerDeck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Deck][Instruments],
			Description -> "The platform which contains the samples which are used by the instrument.",
			Category -> "Dimensions & Positions"
		}
	}
}];
