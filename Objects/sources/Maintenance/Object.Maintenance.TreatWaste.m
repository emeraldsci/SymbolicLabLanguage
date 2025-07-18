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
			Description -> "For each member of WashBin, a list of container objects that are found and scanned in this maintenance.",
			IndexMatching -> WashBin,
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
		WasteBin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container, WasteBin],
				Model[Container, WasteBin]
			],
			Description -> "Vessel where liquid biohazard samples are poured into and being mixed with bleach during the treatment.",
			Category -> "General"
		},
		Bleach -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Vessel],
			Description -> "The bleach reservoir that is used to dispose of cell samples during this cell bleaching protocol.",
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
				TimeRemaining -> Real
			},
			Pattern :> {
				ContainersToBleach -> {_Link..|Null},
				BleachVolume -> GreaterEqualP[0 Milliliter],
				BleachingStartTime -> _?DateObjectQ,
				GraduatedCylinder -> _Link,
				TimeRemaining -> TimeP
			},
			Relation -> {
				ContainersToBleach -> Null,
				BleachVolume -> Null,
				BleachingStartTime -> Null,
				GraduatedCylinder -> Object[Container, GraduatedCylinder],
				TimeRemaining -> Null
			},
			Units -> {
				ContainersToBleach -> None,
				BleachVolume -> Milliliter,
				BleachingStartTime -> None,
				GraduatedCylinder -> None,
				TimeRemaining -> Minute
			},
			Headers -> {
				ContainersToBleach -> "Containers To Bleach",
				BleachVolume -> "Amount of Bleach",
				BleachingStartTime -> "Start time of bleaching",
				GraduatedCylinder -> "Dispensing cylinder",
				TimeRemaining -> "Amount of additional waiting time"
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
		}
	}
}];