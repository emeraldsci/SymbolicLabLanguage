(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)
(*:Author: shahrier.hussain*)
(* :Date: 2023-6-16 *)

DefineObjectType[Object[Qualification,Training,InstrumentSafety], {
	Description->"The qualification protocol where the Target finds various safety equipments and read their safety instructions.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		PhysicalAndInstrumentSafetyEquipment->{
			Units -> None,
			Relation -> Object[Container,WasteBin] | Object[Instrument],
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Description -> "The physical and instrument safety equipment (sharps waste, biohazard waste, NMR, gas tanks, liquid dewars, centrifuges, cryogenic freezer) the user will be asked to find. Note that this list will be optimized by location such that operators take the shortest path between the objects, starting at the first object in the list.",
			Category -> "General"
		},
		PhysicalAndInstrumentSafetyInstructions->{
			Units -> None,
			Relation -> Null,
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of PhysicalAndInstrumentSafetyEquipment, the special information conveyed to the operator regarding the instrument.",
			Category -> "General",
			IndexMatching -> PhysicalAndInstrumentSafetyEquipment
		}
	}
}
]