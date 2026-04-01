(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Clean, PlateWasher], {
	Description -> "A protocol that cleans a plate washer.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		MaintenanceKey -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The maintenance object ID converted to an all-lower-case format.",
			Category -> "General",
			Developer -> True
		},
		MethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "The file path of the folder containing the protocol file which contains the run parameters.",
			Category -> "General",
			Developer -> True
		},
		WashSolvent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The wash solvent used to flush and clean all the liquid handling lines in the plate washer.",
			Category -> "General"
		},
		BufferContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, {LocationPositionP..}},
			Relation -> {Object[Container] | Object[Sample] | Model[Sample], Null},
			Description -> "A list of deck placements used for placing buffers needed to run the protocol onto the instrument buffer deck.",
			Category -> "General",
			Developer -> True,
			Headers -> {"Object to Place", "Placement Tree"}
		},
		Deck -> {
			Format -> Single,
			Class -> Link,
			Pattern :> ObjectP[{Object[Container, Deck], Model[Container, Deck]}],
			Relation -> Object[Container, Deck] | Model[Container, Deck],
			Description -> "The buffer deck for the integrated plate washer.",
			Category -> "General"
		},
		(* BioTek Plate Washer only field *)
		WashingBufferA -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent configured on buffer line A of the instrument during maintenance, which is delivered through line A for manifold flushing and subsequently serves as StorageBufferA.",
			Category -> "General"
		},
		WashingBufferB -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent configured on buffer line B of the instrument during maintenance, which is delivered through line B for manifold flushing and subsequently serves as StorageBufferB.",
			Category -> "General"
		},
		WashingBufferC -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent configured on buffer line C of the instrument during maintenance, which is delivered through line C for manifold flushing and subsequently serves as StorageBufferC.",
			Category -> "General"
		},
		WashingBufferD -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample]
			],
			Description -> "The solvent configured on buffer line D of the instrument during maintenance, which is delivered through line D for manifold flushing and subsequently serves as StorageBufferD.",
			Category -> "General"
		},
		(* ELISA Plate Washer only field *)
		MaintenancePlate -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Plate],
				Object[Container, Plate]
			],
			Description -> "The  microplate that is used to collect liquid being flushed into and drained from the plate washer.",
			Category -> "General"
		},
		VesselRackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, Expression},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {(Object[Container]|Model[Container]|Object[Sample]|Model[Sample]|Model[Item]|Object[Item]), (Object[Container]|Model[Container]), Null},
			Description -> "List of placements of vials into automation-friendly vial and plate racks.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object", "Destination Position"}
		}
	}
}];
