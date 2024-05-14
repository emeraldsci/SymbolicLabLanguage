(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, StorageUpdate], {
	Description -> "A protocol that moves samples to their correct storage category or waste.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		ScheduledMoves -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample],
				Object[Item],
				Object[Item][Maintenance],
				Object[Part][Maintenance],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Any items that are scheduled to be moved due to a change in storage conditions.",
			Category -> "General"
		},
		MovedItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample],
				Object[Item],
				Object[Item][Maintenance],
				Object[Part][Maintenance],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Items that were intended to be moved in this maintenance protocol after checking the storage conditions at runtime, except those that are scheduled to be moved into environmental chambers or from crystal incubators.",
			Category -> "General"
		},
		BatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The lengths of each grouping of moved items, so that only a certain number of items were gathered or stored at a time.",
			Category -> "Batching",
			Developer -> True
		},
		FoundItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Any items that were actually moved in this maintenance protocol after checking the storage conditions at runtime.",
			Category -> "General"
		},
		(* fields for hazardous or bulk solid samples *)
		MovedWasteHoldingSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample]
			],
			Description -> "Items that were marked to be moved to waste holding to await pickup of individual containers.",
			Category -> "General"
		},
		FoundWasteHoldingSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample]
			],
			Description -> "Items that were successfully moved to waste holding to await pickup of individual containers.",
			Category -> "General"
		},
		WasteHoldingBatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The lengths of each grouping of MovedWasteHoldingSamples, so that only a certain number of items were gathered or stored at a time.",
			Category -> "Batching",
			Developer -> True
		},
		MovedSolidDisposalSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample]
			],
			Description -> "Bulk solids that were marked to be moved to waste holding to determine if they can be disposed of in waste or require individual container pickup.",
			Category -> "General"
		},
		FoundSolidDisposalSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample]
			],
			Description -> "Bulk solids that were successfully moved to waste holding to determine if they can be disposed of in waste or require individual container pickup.",
			Category -> "General"
		},
		SolidDisposalBatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The lengths of each grouping of MovedSolidDisposalSamples, so that only a certain number of items were gathered or stored at a time.",
			Category -> "Batching",
			Developer -> True
		},
		MovedLargeVolumeSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample]
			],
			Description -> "Liquid samples which have large enough to be disposed of into chemical waste drums.",
			Category -> "General"
		},
		FoundLargeVolumeSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample]
			],
			Description -> "Liquid samples with large volumes that were disposed of in chemical waste drums.",
			Category -> "General"
		},
		LargeVolumeBatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The lengths of each grouping of MovedLargeVolumeSamples, so that only a certain number of items were gathered or stored at a time.",
			Category -> "Batching",
			Developer -> True
		},
		WasteHoldingCabinet -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container]
			],
			Description -> "The cabinet in which the samples should be stored in waste holding prior to pickup.",
			Category -> "General"
		},
		SolidDisposalCabinet -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container]
			],
			Description -> "The cabinet in which the solid samples should be stored temporarily while awaiting pickup.",
			Category -> "General"
		},

		(* long term testing fields *)
		CrystallizationTestingItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Plate],
			Description -> "Any found items that are done with crystallization testing and intended to be moved from crystal incubator to regular storage condition.",
			Category -> "General"
		},
		CrystallizationInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, CrystalIncubator],
				Object[Instrument, CrystalIncubator]
			],
			Description -> "The crystallization incubator used for growing crystals.",
			Category -> "General"
		},
		CrystallizationInstrumentBatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The lengths of each grouping of CrystallizationTestingItems, so that crystallization plates from same crystal incubator are gathered at a time.",
			Category -> "Batching",
			Developer -> True
		},
		CrystallizationTestingEjectedItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Plate],
			Description -> "Any items that were actually ejected to the loading port of crystal incubators in this maintenance protocol before checking the storage conditions at runtime.",
			Category -> "General",
			Developer -> True
		},
		AcceleratedTestingItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample],
				Object[Item],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Any found items that are intended to be moved into an environmental chamber for accelerated environmental-stability testing.",
			Category -> "General"
		},
		AcceleratedTestingInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The environmental chamber used for AcceleratedTesting.",
			Category -> "General"
		},
		IntermediateTestingItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample],
				Object[Item],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Any found items that are intended to be moved into an environmental chamber for intermediate environmental-stability testing.",
			Category -> "General"
		},
		IntermediateTestingInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The environmental chamber used for IntermediateTesting.",
			Category -> "General"
		},
		LongTermTestingItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample],
				Object[Item],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Any found items that are intended to be moved into an environmental chamber for long-term environmental-stability testing.",
			Category -> "General"
		},
		LongTermTestingInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The environmental chamber used for LongTermTesting.",
			Category -> "General"
		},
		PhotostabilityTestingItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Sample],
				Object[Item],
				Object[Item],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Any found items that are intended to be moved into an environmental chamber for photostability testing.",
			Category -> "General"
		},
		PhotostabilityTestingInstrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "The environmental chamber used for PhotostabilityTesting.",
			Category -> "General"
		}
	}
}];
