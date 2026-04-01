(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, TreatWaste], {
	Description -> "A maintenance to treats and safely disposes of the biohazard waste.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		WashBin -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container, WashBin]
			],
			Description -> "Trays containing liquid biohazard samples or unsealed biohazard samples prior to the treatment.",
			Abstract -> True,
			Category -> "General"
		},
		AuditedContainers -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {ObjectP[Object[Container]]..},
			Description -> "For each member of WashBin, a list of container objects that are to be found and scanned in this maintenance.",
			IndexMatching -> WashBin,
			Category -> "General"
		},
		FoundContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Container objects that are found and scanned in this maintenance.",
			Category -> "General"
		},
		Instrument -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument],
				Object[Instrument]
			],
			Description -> "Instrument used in the process of treating the waste.",
			Category -> "General"
		},
		(* biohazard seal fields*)
		ContainersToSeal -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers that hold solid biohazard samples and whose lids need to be secured by sealing with autoclave tape.",
			Category -> "General",
			Abstract -> True
		},
		AutoclaveTape -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Consumable],
				Object[Item, Consumable]
			],
			Description -> "Adhesive tape that can withstand autoclave chamber conditions to hold unsealed biohazard plate and lid together.",
			Category -> "General"
		},
		(* bleaching fields *)
		ContainersToBleach -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers holding the samples to be disposed of by treatment with bleach.",
			Category -> "General",
			Abstract -> True
		},
		Bleach -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The bleach reservoir that is used to load BleachContainers in order to dispose of cell samples during this cell bleaching protocol.",
			Category -> "General"
		},
		BleachContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Vessel],
				Object[Container, Vessel]
			],
			Description -> "The containers that are loaded with bleach and brought to the BisoafetyCabinet to treat the liquid biohazard samples.",
			Category -> "General"
		},
		BleachVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units -> Milliliter,
			Description -> "For each member of BleachContainers, the amount of bleach to load in order to treat the liquid biohazard samples.",
			IndexMatching -> BleachContainers,
			Category -> "General"
		},
		GraduatedCylinders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container]
			],
			Description -> "For each member of BleachContainers, the graduated cylinder used to measure out BleachVolumes in order to load bleach sample into BleachContainers.",
			IndexMatching -> BleachContainers,
			Category -> "General"
		},
		(* OEB45 sanitize-dilute treatment fields *)
		ContainersToSanitizeDilute -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers holding the OEB4/5 samples to be disposed of by treatment with disinfectant (if biohazard) and dilution.",
			Category -> "General",
			Abstract -> True
		},
		(* Note that although bleach is also a disinfectant, I don't want to share the fields since they are used slightly differently. Open to change this name to be more specifically e.g. OEBDisifectantVolume. *)
		SanitizeDilutionContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Vessel],
				Object[Container, Vessel]
			],
			Description -> "The containers that are loaded with water and/or disinfectant and brought to the BisoafetyCabinet to treat the OEB4/5 samples with or without biohazard.",
			Category -> "General"
		},
		DisinfectantVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SanitizeDilutionContainers, the amount of concentrated disinfectant to load in order to treat biohazard of the liquid OEB4/5 samples.",
			IndexMatching -> SanitizeDilutionContainers,
			Category -> "General"
		},
		WaterVolumes -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units -> Milliliter,
			Description -> "For each member of SanitizeDilutionContainers, the amount of water to load in order to dilute the OEB4/5 sample to below $LiquidOEB45MassPercentThreshold and dilute the concentrated disinfectant to potent concentration.",
			IndexMatching -> SanitizeDilutionContainers,
			Category -> "General"
		},
		ContainerLoadingTransferUnitOperation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "Transfer unit operation that contains the instructions for loading the SanitizeDilutionContainers with desired amount of water and/or disinfectant, and if disinfection is needed, adding concentrated disinfectant to the FunnelDisinfectantBath.",
			Category -> "General",
			Developer -> True
		},
		ContainerLoadingTransferProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Protocol, ManualSamplePreparation]],
			Description -> "The sub protocol to perform the ContainerLoadingTransferUnitOperation.",
			Category -> "General",
			Developer -> True
		},
		ContainersToRinse -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The reusable containers in SanitizeDilutionContainers that once held the OEB4/5 samples to be rinsed at the chemical disposal drum.",
			Category -> "General",
			Abstract -> True
		},
		(* Shared developer fields *)
		BatchedTreatmentParameters -> {
			Format -> Multiple,
			Class -> {
				ContainersToBleach -> Expression,
				BleachVolume -> Real,
				BleachingStartTime -> Date,
				GraduatedCylinder -> Link,
				TimeRemaining -> Real,
				BleachContainer -> Link,
				NextBleachContainer -> Link,
				ContainersToDiscard -> Expression
			},
			Pattern :> {
				ContainersToBleach -> {_Link..|Null},
				BleachVolume -> GreaterEqualP[0 Milliliter],
				BleachingStartTime -> _?DateObjectQ,
				GraduatedCylinder -> _Link,
				TimeRemaining -> TimeP,
				BleachContainer -> _Link,
				NextBleachContainer -> _Link,
				ContainersToDiscard -> {_Link...}
			},
			Relation -> {
				ContainersToBleach -> Null,
				BleachVolume -> Null,
				BleachingStartTime -> Null,
				GraduatedCylinder -> Object[Container, GraduatedCylinder],
				TimeRemaining -> Null,
				BleachContainer -> Alternatives[Object[Container, Vessel], Model[Container, Vessel]],
				NextBleachContainer -> Alternatives[Object[Container, Vessel], Model[Container, Vessel]],
				ContainersToDiscard -> Null
			},
			Units -> {
				ContainersToBleach -> None,
				BleachVolume -> Milliliter,
				BleachingStartTime -> None,
				GraduatedCylinder -> None,
				TimeRemaining -> Minute,
				BleachContainer -> None,
				NextBleachContainer -> None,
				ContainersToDiscard -> None
			},
			Headers -> {
				ContainersToBleach -> "Containers To Bleach",
				BleachVolume -> "Amount of Bleach",
				BleachingStartTime -> "Start time of bleaching",
				GraduatedCylinder -> "Dispensing cylinder",
				TimeRemaining -> "Amount of additional waiting time",
				BleachContainer -> "Container preloaded with bleach",
				NextBleachContainer -> "Container preloaded with bleach to use for next batch",
				ContainersToDiscard -> "Non-reusable containers to Discard in BSC"
			},
			Description -> "For each member of BatchLengths, the treatment parameters shared by all containers in the batch.",
			Category -> "Batching",
			Developer -> True
		},
		BatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The lengths of each grouping of bleaching groups.",
			Category -> "Batching",
			Developer -> True
		},
		BatchedSanitizeDiluteParameters -> {
			Format -> Multiple,
			Class -> {
				ContainersToSanitizeDilute -> Expression,
				ContainersToDiscard -> Expression,
				WaterVolume -> Real,
				DisinfectantVolume -> Real,
				DisinfectionStartTime -> Date,
				TimeRemaining -> Real,
				SanitizeDilutionContainer -> Link,
				NextSanitizeDilutionContainer -> Link
			},
			Pattern :> {
				ContainersToSanitizeDilute -> {(ObjectP[])...},
				ContainersToDiscard -> {(ObjectP[])...},
				WaterVolume -> GreaterEqualP[0 Milliliter],
				DisinfectantVolume -> GreaterEqualP[0 Milliliter],
				DisinfectionStartTime -> _?DateObjectQ,
				TimeRemaining -> TimeP,
				SanitizeDilutionContainer -> _Link,
				NextSanitizeDilutionContainer -> _Link
			},
			Relation -> {
				ContainersToSanitizeDilute -> Null,
				ContainersToDiscard -> Null,
				WaterVolume -> Null,
				DisinfectantVolume -> Null,
				DisinfectionStartTime -> Null,
				TimeRemaining -> Null,
				SanitizeDilutionContainer -> Alternatives[Object[Container, Vessel], Model[Container, Vessel]],
				NextSanitizeDilutionContainer -> Alternatives[Object[Container, Vessel], Model[Container, Vessel]]
			},
			Units -> {
				ContainersToSanitizeDilute -> None,
				ContainersToDiscard -> None,
				WaterVolume -> Milliliter,
				DisinfectantVolume -> Milliliter,
				DisinfectionStartTime -> None,
				TimeRemaining -> Minute,
				SanitizeDilutionContainer -> None,
				NextSanitizeDilutionContainer -> None
			},
			Headers -> {
				ContainersToSanitizeDilute -> "Containers To SanitizeDilute",
				ContainersToDiscard -> "Non-reusable containers to Discard in BSC",
				WaterVolume -> "Amount of water to preload into SanitizeDilutionContainer",
				DisinfectantVolume -> "Amount of concentrated disinfectant to preload into SanitizeDilutionContainer",
				DisinfectionStartTime -> "Start time of bleaching",
				TimeRemaining -> "Amount of additional waiting time",
				SanitizeDilutionContainer -> "Container preloaded with water and/or disinfectant",
				NextSanitizeDilutionContainer -> "Container preloaded with water and/or disinfectant to use for next batch"
			},
			Description -> "For each member of SanitizeDiluteBatchLengths, the treatment parameters shared by all containers in the batch.",
			Category -> "Batching",
			Developer -> True
		},
		SanitizeDiluteBatchLengths -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Description -> "The lengths of each grouping of sanitize-diluting groups.",
			Category -> "Batching",
			Developer -> True
		},
		BiosafetyCabinet -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, HandlingStation, BiosafetyCabinet],
				Object[Instrument, HandlingStation, BiosafetyCabinet]
			],
			Description -> "The biosafety cabinet in which biohazard liquid waste is transferred into the BleachContainers.",
			Category -> "General",
			Developer -> True
		},
		BiosafetyWasteBin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container,WasteBin],Object[Container,WasteBin]],
			Description -> "The waste bin brought into the BiosafetyCabinet to hold the BiosafetyWasteBag that collects disposable containers after their contents are transferred out.",
			Category -> "General",
			Developer -> True
		},
		BiosafetyWasteBag -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item,Consumable],Object[Item,Consumable]],
			Description -> "The waste bag brought into the BiosafetyCabinet and placed in the BiosafetyWasteBin to collect disposable containers after their contents are transferred out.",
			Category -> "General",
			Developer -> True
		},
		SecondBiosafetyWasteBag -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item,Consumable],Object[Item,Consumable]],
			Description -> "The waste bag that the tied-up BiosafetyWasteBag is sealed in during BiosafetyCabinet teardown.",
			Category -> "General",
			Developer -> True
		},
		BiosafetyWasteBinPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {
				Alternatives[
					Object[Container,WasteBin],
					Model[Container,WasteBin],
					Object[Item,Consumable],
					Model[Item,Consumable]
				],
				Alternatives[
					Object[Instrument,HandlingStation,BiosafetyCabinet],
					Model[Instrument,HandlingStation,BiosafetyCabinet],
					Object[Container,WasteBin],
					Model[Container,WasteBin]
				],
				Null
			},
			Headers -> {"Objects to move", "Object to move to", "Position to move to"},
			Description -> "The specific positions into which waste bin objects are moved into the BiosafetyCabinet for bleaching liquid biohazard waste.",
			Category -> "General",
			Developer -> True
		},
		BiosafetyCabinetPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {
				Alternatives[
					Object[Container],
					Model[Container],
					Object[Sample],
					Object[Part],
					Model[Part],
					Object[Item]
				],
				Alternatives[
					Model[Instrument, HandlingStation, BiosafetyCabinet],
					Object[Instrument, HandlingStation, BiosafetyCabinet],
					Object[Container,WasteBin],
					Model[Container,WasteBin]
				],
				Null
			},
			Headers -> {"Objects to move", "BSC to move to", "Position to move to"},
			Description -> "The specific positions into which objects are moved into the BiosafetyCabinet for bleaching liquid biohazard waste.",
			Category -> "General",
			Developer -> True
		},
		CollectionObjects->{
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Item],
				Object[Sample],
				Object[Part]
			],
			Description -> "The objects to be moved from the BiosafetyCabinet back onto the cart after transferring liquid biohazard waste to the BleachContainers of all batches.",
			Category -> "General",
			Developer -> True
		},
		Funnel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Part, Funnel],
				Object[Part, Funnel]
			],
			Description -> "The funnel used to facilitate the transfer of liquid biohazard waste to the BleachContainers in the BiosafetyCabinet.",
			Category -> "General",
			Developer -> True
		},
		FunnelDisinfectantBath -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The diluted bleach, or disinfectant, or water sample loaded brought into the BiosafetyCabinet to hold the used Funnel after transferring liquid waste from all batches.",
			Category -> "General",
			Developer -> True
		},
		FunnelDisinfectantVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units -> Milliliter,
			Description -> "The amount of bleach or disinfectant to add to FunnelDisinfectantBath, which contains only water at the time of addition, in order to prepare the diluted disinfectant solution.",
			Category -> "General",
			Developer -> True
		}
	}
}];