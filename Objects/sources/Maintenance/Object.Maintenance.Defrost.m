(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Defrost], {
	Description->"A protocol that transfers all the contents of a freezer to a backup freezer and defrosts the freezer.",
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
		RelocatedContainers ->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "Containers that were temporarily relocated from the target instrument during the defrost maintenance procedure.",
			Category -> "General",
			Abstract -> True
		},
		AbsorbentMats-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation-> Alternatives[
				Object[Item,Consumable],
				Model[Item,Consumable]
			],
			Description -> "Absorbent mat used to soak up liquid.",
			Category -> "General",
			Developer -> True
		},
		BackupRackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "Placements for racks relocated to a secondary freezer(s) prior to the start of defrost.",
			Headers->{"Container", "Destination Container", "Destination Position"},
			Category -> "Placements",
			Developer -> True
		},
		ReturnRackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "Placements for racks returned to defrosted freezer after completion of defrost.",
			Headers->{"Container", "Destination Container", "Destination Position"},
			Category -> "Placements",
			Developer -> True
		},
		ItemsToRelocate-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation-> Alternatives[
				Object[Container],
				Object[Item],
				Object[Part]
			],
			Description -> "Items relocated to an alternate storage location in freezer.",
			Category -> "General"
		},
		FoundItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample],
				Object[Item],
				Object[Part]
			],
			Description -> "Any items that were actually moved in this maintenance protocol when consolidating any loose containers into racks.",
			Category -> "General"
		},
		ReserveFreezer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument, Freezer],
			Description -> "The freezer into which the samples will be moved.",
			Category -> "General"
		},
		AuditObjects -> {
			Format -> Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description -> "Indicates if inventory auditing should be performed during this Defrost.",
			Category -> "General"
		},
		AuditedObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers that are audited as a subprotocol of Defrost.",
			Category -> "General"
		},
		BeforeMaintenanceImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image file taken by an operator before defrosting the target.",
			Category -> "Cleaning"
		},
		AfterMaintenanceImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An image file taken by an operator after completing defrosting the target.",
			Category -> "Cleaning"
		}
	}
}];
