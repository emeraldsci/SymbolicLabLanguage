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
		ContainersToSeal -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers that hold solid biohazard samples and whose lids need to be secured by sealing with autoclave tape.",
			Category -> "General",
			Abstract -> True
		},
		ContainersToBleach -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers holding the samples to be disposed of by treatment with bleach.",
			Category -> "General",
			Abstract -> True
		},
		BatchedTreatmentParameters -> {
			Format -> Multiple,
			Class -> {
				ContainersToBleach -> Expression,
				BleachVolume -> Real,
				BleachingStartTime -> Date,
				GraduatedCylinder -> Link,
				TimeRemaining -> Real,
				BleachContainer -> Link,
				NextBleachContainer -> Link
			},
			Pattern :> {
				ContainersToBleach -> {_Link..|Null},
				BleachVolume -> GreaterEqualP[0 Milliliter],
				BleachingStartTime -> _?DateObjectQ,
				GraduatedCylinder -> _Link,
				TimeRemaining -> TimeP,
				BleachContainer -> _Link,
				NextBleachContainer -> _Link
			},
			Relation -> {
				ContainersToBleach -> Null,
				BleachVolume -> Null,
				BleachingStartTime -> Null,
				GraduatedCylinder -> Object[Container, GraduatedCylinder],
				TimeRemaining -> Null,
				BleachContainer -> Alternatives[Object[Container, Vessel], Model[Container, Vessel]],
				NextBleachContainer -> Alternatives[Object[Container, Vessel], Model[Container, Vessel]]
			},
			Units -> {
				ContainersToBleach -> None,
				BleachVolume -> Milliliter,
				BleachingStartTime -> None,
				GraduatedCylinder -> None,
				TimeRemaining -> Minute,
				BleachContainer -> None,
				NextBleachContainer -> None
			},
			Headers -> {
				ContainersToBleach -> "Containers To Bleach",
				BleachVolume -> "Amount of Bleach",
				BleachingStartTime -> "Start time of bleaching",
				GraduatedCylinder -> "Dispensing cylinder",
				TimeRemaining -> "Amount of additional waiting time",
				BleachContainer -> "Container preloaded with bleach",
				NextBleachContainer -> "Container preloaded with bleach to use for next batch"
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
		FunnelBleachBath -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Sample]
			],
			Description -> "The diluted bleach sample loaded brought into the BiosafetyCabinet to hold the used Funnel after transferring liquid biohazard waste from all batches.",
			Category -> "General",
			Developer -> True
		},
		FunnelBleachVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Milliliter],
			Units -> Milliliter,
			Description -> "The amount of bleach to add to FunnelBleachBath, which contains only water at the time of addition, in order to prepare the diluted bleach solution.",
			Category -> "General",
			Developer -> True
		}
	}
}];