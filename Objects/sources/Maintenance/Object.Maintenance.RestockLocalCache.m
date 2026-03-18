(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, RestockLocalCache], {
	Description->"A protocol that moves determined items from storage to an instrument's local cache.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		StockedInstruments -> {
      Format-> Multiple,
      Class-> Link,
      Pattern:> _Link,
      Relation-> Alternatives[Object[Instrument]],
			Description -> "Instruments which have had resources generated for to restock their local cache.",
			Category -> "Instrument Setup",
			Abstract -> True
		},
    RestockingSupplies -> {
      Format -> Multiple,
      Class -> Link,
      Pattern :> _Link,
      Relation -> Model[Container]|Model[Item]|Object[Container]|Object[Item],
      Description -> "Supplies to stock with.",
      Category -> "Instrument Setup",
      Abstract -> True
    },
    RestockingSuppliesLength -> {
      Format -> Multiple,
      Class -> Integer,
      Pattern :> _Integer,
      Description -> "Length from RestockingSupplies to stock for loop task.",
      Category -> "Instrument Setup",
      Abstract -> True
    }
	}
}];
