(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, Dishwash], {
	Description->"A protocol that uses a dishwasher to clean and restock dirty labware.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Dishwasher -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "Dishwasher used during this maintenance.",
			Category -> "Dishwasher Setup",
			Abstract -> True
		},
		DishwashMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DishwashMethodP,
			Description -> "The type of dishwasher cycle utilized to clean the labware.",
			Category -> "Dishwasher Setup"
		},
		Detergent -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Object[Item,Consumable],
				Model[Item,Consumable]
			], (* TODO: Remove after item migration. *)
			Description -> "Detergent sample used to clean the labware.",
			Category -> "Dishwasher Setup"
		},
		Neutralizer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Object[Item,Consumable],
				Model[Item,Consumable]
			], (* TODO: Remove after item migration. *)
			Description -> "Neutralizer agent used to neutralize any acid before draining.",
			Category -> "Dishwasher Setup"
		},
		Softener -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Object[Item,Consumable],
				Model[Item,Consumable]
			], (* TODO: Remove after item migration. *)
			Description -> "Softener agent used to soften tap water used to clean the labware.",
			Category -> "Dishwasher Setup"
		},
		AirFilter -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Part,Filter],
				Model[Part,Filter]
			], 
			Description -> "Filter used to filter the air during labware drying.",
			Category -> "Dishwasher Setup"
		},
		FillingFault -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the dishwasher experienced a filling fault during its first run, prompting a waiting period to refill the purified water tank and a rerun of the cycle.",
			Category -> "Dishwasher Setup"
		},
		ErrorImages -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Photographs of the dishwasher's error log after interruptions to the run.",
			Category -> "Dishwasher Setup"
		},
		RackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {(Object[Container,Rack]|Model[Container,Rack]), (Object[Instrument]|Model[Instrument]), Null},
			Description -> "Position of each rack placed inside the dishwasher.",
			Category -> "Placements",
			Headers -> {"Rack", "Destination Instrument", "Position"}
		},
		ContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {(Object[Container]|Object[Part]|Object[Item]), (Object[Instrument]|Model[Instrument]|Object[Container,Rack]|Model[Container,Rack]), Null},
			Description -> "Position of each container to be washed inside the dishwasher.",
			Category -> "Placements",
			Headers -> {"Container", "Destination Instrument", "Position"},
			Developer -> True
		},
		ContainerPlacementsBatching -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The batch lengths corresponding to the ContainerPlacements field.",
			Category -> "Placements",
			Developer -> True
		},
		BatchedRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container, Rack, Dishwasher], Model[Container, Rack, Dishwasher]],
			Description -> "For each ContainerPlacementsBatching, the rack to which the batch corresponds.",
			Category -> "Placements",
			Developer -> True
		},
		DirtyLabware -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Object[Container]|Object[Part]|Object[Item]),
			Description -> "The dirty labware being washed during this maintenance.",
			Category -> "Loading"
		},
		DirtyLabwareToStore -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Object[Container]|Object[Part]|Object[Item]),
			Description -> "Dirty labware that was resource picked and requires a specific position which could not be accommodated due to space or availability limitation.",
			Category -> "Loading"
		},
		LoadedLabware -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Object[Container]|Object[Part]|Object[Item]),
			Description -> "The dirty labware that is actually loaded onto the dishwasher during this maintenance.",
			Category -> "Loading"
		},
		LoadedCovers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item],
			Description -> "The covers loaded into the dishwasher during this maintenance.",
			Category -> "Loading"
		},
		DishwasherRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Rack,Dishwasher],
			Description -> "The racks being loaded into the dishwasher during this maintenance.",
			Category -> "Loading"
		},
		DishwasherRacksToStore -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Rack,Dishwasher],
			Description -> "Dishwasher racks left in the instrument that are not needed for the current maintenance and should be removed from the instrument.",
			Category -> "Loading"
		},
		FumeHood -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "Fume hood used to empty chemical waste from labware before dishwashing.",
			Category -> "Cleaning"
		},
		SterileLabware -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Object[Container]|Object[Part]|Object[Item]),
			Description -> "The cleaned labware that requires autoclaving after dishwashing has completed.",
			Category -> "Unloading"
		},
		CleanLabware -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Object[Container][DishwashLog, 2]|Object[Part][DishwashLog, 2]|Object[Item][DishwashLog, 2]),
			Description -> "The newly clean labware produced by this maintenance.",
			Category -> "Unloading"
		},
		CoveredContainers  -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Object[Part], Object[Item]],
			Description -> "Containers whose covers are washed in this maintenance and are covered again after cleaning.",
			Category -> "Unloading"
		},
		CleanCovers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item][DishwashLog, 2],
			Description -> "The newly clean covers produced by this maintenance.",
			Category -> "Unloading"
		},
		Dehydrator -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument],
				Model[Instrument]
			],
			Description -> "Dehydrator used during this maintenance.",
			Category -> "Unloading"
		},
		TargetModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Container]|Model[Part]|Model[Item]),
			Description -> "The current model to prioritize for dishwashing.",
			Category -> "Loading"
		},
		Targets -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Object[Container]|Object[Part]|Object[Item]),
			Description -> "A list of objects of the TargetModel expected to be found in the wash bins.",
			Category -> "Loading"
		},
		TargetAmount -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			Description -> "An upper bound of objects of the TargetModel to pick beyond which the additional objects will not fit in the dishwasher. This is used to prevent the operator moving unnecessary objects to their cart.",
			Category -> "Loading"
		},
		PriorityLabware -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> (Model[Container]|Model[Part]|Model[Item]),
			Description -> "Models prioritized for dishwashing during this maintenance.",
			Category -> "Loading"
		},
		RackInspectionFindings -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of DishwasherRacks, issues with the rack reported during operator inspection.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		VolumeCheck -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> Alternatives[GreaterEqualP[0 Percent], GreaterEqualP[0 Unit]],
			Units -> None,
			Description -> "The remaining water in the water purifier tank expressed as a percentage. This value is recorded by the operator in Engine from the status display of the water purifier.",
			Category -> "Sensor Monitoring",
			Developer -> True
		},
		NumberOfDryCycles -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of drying cycles (including the initial one that occurs with the dishwashing method) that have been performed.",
			Category -> "Drying"
		},
		ContainerCovers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item],
			Description -> "For each ContainersToCover, the cover to use when covering.",
			Category -> "Unloading"
		},
		ContainersMissingCovers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Containers that need a clean cover that was not washed during this maintenance.",
			Category -> "Unloading"
		}
	}
}];
