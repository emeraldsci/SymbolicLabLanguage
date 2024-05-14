(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Decontaminate, Incubator], {
	Description -> "A protocol that decontaminates an incubator interior to ensure a sterile environment is maintained.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
	(* --- Draining --- *)
		WasteContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "Container which is used to drain the waste liquid from the incubator for disposal.",
			Category -> "Draining"
		},
		LiquidWaste -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The liquid waste collected from the reservoir.",
			Category -> "Draining",
			Developer -> True
		},
		Aspirator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, Aspirator],
				Model[Instrument, Aspirator],
				Model[Part, HandPump],
				Object[Part, HandPump]
			],
			Description -> "Aspirator instrument used to drain instrument reservoir.",
			Category -> "Draining",
			Developer -> True
		},
		AspiratorConnectors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Plumbing, Tubing], Object[Plumbing, Tubing]
			],
			Description -> "Aspirator inlet and outlet tubings work together with handpump to drain instrument reservoir.",
			Category -> "Draining",
			Developer -> True
		},
		TipRinseSolution -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The solution that the Tips is rinsed before they are used to aspirate from the reservoir container.",
			Category -> "Draining",
			Developer -> True
		},
		Chemwipe -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item, Consumable]|Object[Item, Consumable],
			Description -> "The wipe (such as sterile cloth) that is used to remove excess liquid from the reservoir container.",
			Category -> "Draining",
			Developer -> True
		},
		AspiratorTip -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "Tip connected to vacuum aspirator to aspirate liquid out of incubator reservoir container.",
			Category -> "Draining",
			Developer -> True
		},
		Tweezers -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "Tweezers to remove cotton from tip connected to vaccum aspirator to aspirate liquid out of incubator reservoir container.",
			Category -> "Draining",
			Developer -> True
		},
		(* --- Incubator Takedown --- *)
		ContainersStorageLocation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Object[Container]
			],
			Description -> "Storage deck for cell culture vessels that needed to be moved out of the incubator during the decontamination maintenance procedure.",
			Developer -> True,
			Category -> "Incubator Takedown"
		},
		IncubatorRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "Incubator racks inside of ContainersStorageLocation for cell culture vessels that needed to be moved out of the incubator during the decontamination maintenance procedure.",
			Developer -> True,
			Category -> "Incubator Takedown"
		},
		IncubatorContents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description -> "Cell Culture vessels inside the incubator before the decontamination maintenance procedure, including DefaultIncubatorContainers, CustomIncubatorContainers and NonIncubationStorageContainers.",
			Category -> "Incubator Takedown",
			Abstract -> True
		},
		AlternativeIncubator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument], Object[Instrument]],
			Description -> "The specified instrument where all sample is asked to relocated to.",
			Category -> "Incubator Takedown",
			Abstract -> True
		},
		DefaultIncubatorContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Cell Culture vessels inside the incubator are permanently relocated to another incubator with the same ProvidedStorageCondition during the decontamination maintenance procedure.",
			Category -> "Incubation",
			Developer -> True
		},
		CustomIncubatorContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Cell Culture vessels inside the incubator that are temporarily relocated during the decontamination maintenance procedure.",
			Category -> "Incubation",
			Developer -> True
		},
		NonIncubationStorageContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers that have an AwaitingStorageUpdate to SamplesOutStorageCondition that does not correspond to an incubator before the decontamination maintenance procedure.",
			Category -> "Incubator Takedown",
			Developer -> True
		},
		DeckRackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Container], Null},
			Description -> "The order of racks present on the incubator's deck.",
			Headers -> {"IncubatorRack", "IncubatorDeck", "DeckPosition"},
			Category -> "Incubator Takedown",
			Developer -> True
		},
		(* --- Decontaminating --- *)
		CleanedIncubatorImages -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Image file containing a photo of the incubator after cleaning.",
			Category -> "Decontaminating",
			Abstract -> True
		},
		DecontaminatingReagent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The decontaminating reagent required to decontaminate the incubator.",
			Category -> "Decontaminating"
		},
		DecontaminatingReagentVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Liter],
			Units -> Liter,
			Description -> "The volume of liquid used to decontaminate the incubator.",
			Category -> "Decontaminating"
		},
		ReagentSterilization -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, Autoclave],
			Description -> "Subprotocols to sterilize the DecontaminatingReagent used to remove contaminants in the incubator interior.",
			Category -> "Decontaminating"
		},
		(* --- Refilling --- *)
		ReservoirContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The container that holds reservoir liquid to drain and refill during this maintenace.",
			Category -> "Refilling"
		},
		RefillReservoir -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance, RefillReservoir],
			Description -> "Subprotocol to refill the incubator reservoir container as part of the decontaminate maintenance.",
			Category -> "Refilling"
		}
	}
}];
