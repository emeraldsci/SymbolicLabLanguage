

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
			Relation -> Alternatives[Object[Instrument, PortableHeater], Object[Instrument, PortableCooler], Model[Instrument, PortableCooler], Model[Instrument, PortableHeater]],
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
				Alternatives[Object[Resource, Sample], Model[Container], Object[Container], Model[Item], Object[Item], Object[Sample]],
				Alternatives[Object[Instrument, PortableHeater], Object[Instrument, PortableCooler], Model[Instrument, PortableCooler], Model[Instrument, PortableHeater]]
			},
			Description -> "Indicate how the resources should be placed after this protocol completes and returns to resource picking of parent protocol.",
			Headers -> {"Resources", "Portable Transporter"},
			Category -> "Placements"
		},
		TemperatureControlledResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container]| Model[Container] | Object[Sample] | Object[Resource, Sample] | Model[Item] | Object[Item],
			Description -> "Resources that needs temperature control during transport and will be pre-picked in this protocol.",
			Category -> "General",
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
			Relation -> Alternatives[Object[Instrument, FumeHood], Model[Instrument, FumeHood]],
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
		}
	}
}];