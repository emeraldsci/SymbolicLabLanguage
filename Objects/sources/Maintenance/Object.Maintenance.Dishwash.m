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
		RackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container,Rack]|Model[Container,Rack], Object[Instrument]|Model[Instrument], Null},
			Description -> "Position of each rack placed inside the dishwasher.",
			Category -> "Placements",
			Headers -> {"Rack", "Destination Instrument", "Position"}
		},
		ContainerPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {(Object[Container]|Object[Part]|Object[Item]), Object[Instrument]|Model[Instrument], Null},
			Description -> "Position of each container to be washed inside the dishwasher.",
			Category -> "Placements",
			Headers -> {"Container", "Destination Instrument", "Position"},
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
			Description -> "The covers that were on the containers loaded into the dishwasher during this maintenance.",
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
		}
	}
}];
