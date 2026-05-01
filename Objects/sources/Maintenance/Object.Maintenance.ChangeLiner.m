(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2026 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, ChangeLiner], {
	Description -> "A maintenance procedure that replaces installed protective inserts with new ones.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		(* Core fields *)
		TargetLiners -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Liner],
			Description -> "The liner objects to be replaced by this maintenance.",
			Category -> "General",
			Abstract -> True
		},
		TargetContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container], Object[Instrument]
			],
			Description -> "For each member of TargetLiners, the container or instrument that the liner is installed in.",
			Category -> "General",
			Abstract -> True,
			IndexMatching -> TargetLiners
		},
		TargetPositions -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> LocationPositionP,
			Description -> "For each member of TargetLiners, the position the liner is installed in.",
			Category -> "General",
			Abstract -> True,
			IndexMatching -> TargetLiners
		},
		ReplacementLiners -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Liner],
				Object[Item, Liner]
			],
			Description -> "For each member of TargetLiners, the new protective insert that is picked and installed during this maintenance.",
			Category -> "Resources",
			IndexMatching -> TargetLiners
		},

		(* Audit fields *)
		MissingObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Instrument],
				Object[Sample],
				Object[Item],
				Object[Sensor],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "The objects that were expected to be scanned in this maintenance but were not found.",
			Category -> "General",
			Developer -> True,
			Abstract -> True
		},
		FoundObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Instrument],
				Object[Sample],
				Object[Item],
				Object[Sensor],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "The objects that were not expected to be scanned in this maintenance but were found.",
			Category -> "General",
			Developer -> True,
			Abstract -> True
		},

		(* Implementation *)
		(* Required because partial movement tasks can only upload to a pure field, not the batching fields *)
		CurrentOutboundObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Instrument],
				Object[Sample],
				Object[Item],
				Object[Sensor],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "For the current engine iteration, the objects that were expected to be scanned and were successfully located.",
			Category -> "General",
			Developer -> True,
			Abstract -> True
		},
		CurrentFoundObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Instrument],
				Object[Sample],
				Object[Item],
				Object[Sensor],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "For the current engine iteration, the objects that were not expected to be scanned but were found in the lined location.",
			Category -> "General",
			Developer -> True,
			Abstract -> True
		},

		(* Batch the inputs for efficiency *)
		(* The objects stored in a container must be removed before the liner can be replaced *)
		(* The simple way to do this is to bring along some staging space (such as a cart or folding table), move all the items to the staging space, replace the liner, then move all the items back *)
		(* For n objects, this means 2n movements *)
		(* However, if we have a set of identical/interchangeable lined containers we can do a cyclic switcheroo instead *)
		(* Say we have 5 identical shelves in a cabinet, move the items from shelf 1 to staging space. Reline shelf 1. Move items from shelf 2 to shelf 1. Reline shelf 2 etc *)
		(* Finally, move items in staging space to shelf 5. This involved just n + 1 movements *)
		(* So, batch the liners/containers into the groups that support cyclic switcheroos *)

		(* Liners/Containers are only batched when they are close together (to avoid requiring a cart for movement) *)
		(* So store the container that they have in common (e.g. if replacing liners for a series of shelves, the cabinet the shelves are in) *)
		BatchedTopLevelContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container], Model[Instrument],
				Object[Container], Model[Container]
			],
			Description -> "For each member of BatchLengths, the first container that itself contains all of the target containers in the batch.",
			Category -> "Batching",
			IndexMatching -> BatchLengths
		},
		BatchedStageLocations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container],
				Object[Container]
			],
			Description -> "For each member of BatchLengths, the container used to temporarily store objects from the first lined container in the batch.",
			Category -> "Batching",
			IndexMatching -> BatchLengths
		},

		(* The parameters per container to re-line *)
		BatchedExchangeParameters -> {
			Format -> Multiple,
			Class -> {
				(* Container to reline *)
				TargetContainer -> Link,
				(* Old liner to replace *)
				TargetLiner -> Link,
				(* Position to reline *)
				TargetPosition -> String,
				(* All objects physically moved out of the target container *)
				OutboundObjects -> Expression,
				(* Where are the objects being moved to? *)
				OutboundDestination -> Link,
				(* Objects missing from outbound movement *)
				MissingObjects -> Expression,
				(* Objects unexpectedly found during outbound movement *)
				FoundObjects -> Expression,
				(* New liner to install *)
				ReplacementLiner -> Link,
				BatchNumber -> Integer
			},
			Pattern :> {
				TargetContainer -> _Link,
				TargetLiner -> _Link,
				TargetPosition -> LocationPositionP,
				OutboundObjects -> {ObjectReferenceP[{
					Object[Container],
					Object[Instrument],
					Object[Sample],
					Object[Item],
					Object[Sensor],
					Object[Part],
					Object[Plumbing],
					Object[Wiring]
				}]..} | Null,
				OutboundDestination -> _Link,
				MissingObjects -> {ObjectReferenceP[{
					Object[Container],
					Object[Instrument],
					Object[Sample],
					Object[Item],
					Object[Sensor],
					Object[Part],
					Object[Plumbing],
					Object[Wiring]
				}]..} | Null,
				FoundObjects -> {ObjectReferenceP[{
					Object[Container],
					Object[Instrument],
					Object[Sample],
					Object[Item],
					Object[Sensor],
					Object[Part],
					Object[Plumbing],
					Object[Wiring]
				}]..} | Null,
				ReplacementLiner -> _Link,
				BatchNumber -> GreaterP[0, 1]
			},
			Relation -> {
				TargetContainer -> Object[Container],
				TargetLiner -> Object[Item, Liner],
				TargetPosition -> Null,
				OutboundObjects -> Null,
				OutboundDestination -> Alternatives[
					Object[Container],
					Object[Instrument]
				],
				MissingObjects -> Null,
				FoundObjects -> Null,
				ReplacementLiner -> Alternatives[
					Model[Item, Liner],
					Object[Item, Liner]
				],
				BatchNumber -> Null
			},
			Units -> {
				TargetContainer -> None,
				TargetLiner -> None,
				TargetPosition -> None,
				OutboundObjects -> None,
				OutboundDestination -> None,
				MissingObjects -> None,
				FoundObjects -> None,
				ReplacementLiner -> None,
				BatchNumber -> None
			},
			Headers -> {
				TargetContainer -> "Container to Re-line",
				TargetLiner -> "Liner to Replace",
				TargetPosition -> "Position to Re-line",
				OutboundObjects -> "Objects to Remove",
				OutboundDestination -> "Object removal destination",
				MissingObjects -> "Objects Not Found",
				FoundObjects -> "Objects Unexpectedly Found",
				ReplacementLiner -> "New Liner",
				BatchNumber -> "Batch Number"
			},
			IndexMatching -> TargetLiners,
			Description -> "For each member of TargetLiners, the information required to replace the liners in that batch.",
			Category -> "Batching",
			Developer -> True
		},
		BatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The list of batch sizes corresponding to number of liners per batch.",
			Category -> "Batching",
			Developer -> True
		}
	}
}];