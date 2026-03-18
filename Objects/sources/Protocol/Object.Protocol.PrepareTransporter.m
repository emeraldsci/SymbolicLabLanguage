

(* ::Text:: *)
(*\[Copyright] 2011-2024 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Protocol, PrepareTransporter], {
	Description->"A protocol for readying portable transporters used to move samples on carts during protocols. For instance, portable heaters and coolers are selected and set to their correct temperatures.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Transporters -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument, PortableHeater],
				Object[Instrument, PortableCooler],
				Model[Instrument, PortableCooler],
				Model[Instrument, PortableHeater],
				Object[Container],
				Model[Container]
			],
			Description -> "The portable devices, such as heaters and coolers, configured in this protocol.",
			Category -> "Method Information"
		},
		Temperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> TemperatureP,
			Units -> Celsius,
			Description -> "For each member of Transporters, the temperature to which it is set.",
			Category -> "Method Information",
			IndexMatching -> Transporters
		},
		RackPlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Object[Container], Object[Instrument], Null},
			Description -> "A list of placements used to move the racks for potential samples to be picked into portable transporters.",
			Headers -> {"Racks to place", "Rack destinations", "Placement Position"},
			Category -> "Placements",
			Developer -> True
		},
		ResourcePlacements -> {
			Format -> Multiple,
			Class -> {Link, Link},
			Pattern :> {_Link, _Link},
			Relation -> {
				Alternatives[Object[Resource, Sample], Model[Container], Object[Container], Model[Item], Object[Item], Object[Sample], Object[Part], Model[Part], Model[Plumbing], Object[Plumbing], Model[Sensor], Object[Sensor], Model[Wiring], Object[Wiring]],
				Alternatives[Object[Instrument, PortableHeater], Object[Instrument, PortableCooler], Model[Instrument, PortableCooler], Model[Instrument, PortableHeater], Object[Container], Model[Container]]
			},
			Description -> "Indicate how the resources should be placed after this protocol completes and returns to resource picking of parent protocol.",
			Headers -> {"Resources", "Portable Transporter"},
			Category -> "Placements"
		},
		TemperatureControlledResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container]| Model[Container] | Object[Sample] | Object[Resource, Sample] | Model[Item] | Object[Item] | Model[Part] | Object[Part]| Model[Plumbing]| Object[Plumbing]| Model[Sensor]| Object[Sensor]| Model[Wiring]| Object[Wiring],
			Description -> "Resources that needs temperature control during transport and will be pre-picked in this protocol.",
			Category -> "General",
			Developer -> True
		},
		ResourcesOnLiner -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container]| Model[Container] | Object[Sample] | Object[Resource, Sample] | Model[Item] | Object[Item] | Model[Part] | Object[Part]| Model[Plumbing]| Object[Plumbing]| Model[Sensor]| Object[Sensor]| Model[Wiring]| Object[Wiring],
			Description -> "Resources that needs lined surface during transport.",
			Category -> "General",
			Developer -> True
		},
		ResourcesEnclosed -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Resource, Sample], Object[Sample], Object[Item], Object[Container], Model[Sample], Model[Item], Model[Container]],
			Description -> "Resources whose samples are stored in this container to prevent exposure during the execution of the given protocol (if there is no resource for a sample, points to the sample directly).",
			Category -> "Liner Information",
			Developer -> True
		},
		InitialTransporterTemperatures -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> TemperatureP,
			Units -> Celsius,
			Description -> "The initial temperature inside transporters before starting configuration.",
			Category -> "Experimental Results"
		},
		InitialTransporterTemperatureData -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Temperature],
			Description -> "The auto-recorded initial temperature data object before starting configuration.",
			Category -> "Experimental Results"
		},
		FinalTransporterTemperatures -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Temperature],
			Description -> "The final temperature inside transporters after temperature equilibration.",
			Category -> "Experimental Results"
		},
		TemperatureTrace -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data, Temperature],
			Description -> "The trace of temperature inside transporters during the entire protocol.",
			Category -> "Experimental Results"
		},
		ObjectsToStore -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container], Object[Item], Object[Part]],
			Description -> "Items that are already contained by the selected transporters which do not belong to the current protocol and need to be stored elsewhere.",
			Category -> "General"
		},
		EstimatedProcessingTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> TimeP,
			Units -> Minute,
			Description -> "Estimated time needed for transporters to reach and equilibrate at the requested temperatures.",
			Category -> "General"
		},
		FumeHood -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Instrument, FumeHood], Model[Instrument, FumeHood], Object[Instrument, HandlingStation, FumeHood], Model[Instrument, HandlingStation, FumeHood]],
			Description -> "FumeHood in which operator configures portable heater.",
			Category -> "General"
		},
		PowerCables -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Wiring, Cable], Model[Wiring, Cable]],
			Description -> "For each member of Transporters, the associated power cable.",
			Category -> "General",
			IndexMatching -> Transporters
		},
		Liners -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Liner], Model[Item, Liner]],
			Description -> "For each member of Transporters, indicates the protective insert that is currently positioned within or on top of this container.",
			Category -> "Compatibility",
			IndexMatching -> Transporters
		},
		OEBContainment -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of Transporters, indicates if this transporter will function as a sealed secondary container to protect operators from exposure to its contents.",
			Category -> "Compatibility",
			IndexMatching -> Transporters
		},
		LightSensitive -> {
			Format -> Multiple,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "For each member of Transporters, indicates if this transporter will function as an opaque enclosure to protect its contents from ambient light.",
			Category -> "Compatibility",
			IndexMatching -> Transporters
		}
	}
}];