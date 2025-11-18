(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, EmptyWaste], {
	Description->"A protocol that inspects waste bins and empties/replaces them if necessary.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		LabArea -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> LabAreaP,
			Description -> "Indicates the lab section in which this maintenance occurs.",
			Category -> "General"
		},
		WasteType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WasteTypeP,
			Description -> "Indicates the waste type being checked.",
			Category -> "General",
			Abstract -> True
		},
		CheckedWasteBins -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Waste bins that were inspected during this maintenance.",
			Category -> "General",
			Abstract -> True
		},
		EmptiedWasteBins -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Waste bins that were emptied during this maintenance.",
			Category -> "General",
			Abstract -> True
		},
		FullWasteBins -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For each member of CheckedWasteBins, indicates if the bin is full.",
			IndexMatching->CheckedWasteBins,
			Category -> "General",
			Developer -> True
		},
		PickedSamplePlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			(* For Sharp, this can be Object[Container,WasteBin] inside a fumehood *)
			Relation -> {Model[Sample] | Model[Container] | Model[Item] | Object[Sample]| Object[Container]| Object[Item], Object[Container] | Object[Instrument], Null},(*TODO remove after item migration, keep only Item*)
			Description -> "Placements for exchanged waste type.",
			Headers->{"Waste Bag", "Destination Container", "Destination Position"},
			Category -> "Placements",
			Developer -> True
		},
		DisposedBags -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample] | Object[Item],
			Description -> "For each member of EmptiedWasteBins, the used trash bag removed from the waste bin during this maintenance.",
			IndexMatching->EmptiedWasteBins,
			Category -> "General",
			Developer -> True
		}
	}
}];
