(* Package *)


DefineObjectType[Object[Maintenance,Shipping], {
	Description->"A protocol that prepares, packages, and ships samples to customers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Transactions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Transaction,ShipToUser][ShippingPreparation],
				Object[Transaction,SiteToSite][ShippingPreparation]
			],
			Description -> "The transaction whose samples are prepared for shipment by this maintenance.",
			Category -> "Organizational Information"
		},
		SamplesIn -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Sample],Object[Item],Model[Sample],Model[Container],Model[Item],Object[Container]],
			Description -> "Source samples shipped by this maintenance (either shipped directly or aliquoted).",
			Category -> "Organizational Information"
		},
		ContainersIn -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Any containers holding the SamplesIn that are shipped by this maintenance.",
			Category -> "Organizational Information"
		},
		SamplesOut -> {
			Format -> Multiple,
			Class -> Link,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Object[Item],
			Description -> "Samples shipped by this maintenance (either the SamplesIn or AliquotSamples of each transaction depending on whether the transaction samples were aliquoted).",
			Category -> "Organizational Information"
		},
		ContainersOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Containers shipped by this maintenance (either the ContainersIn or AliquotContainers of each transaction depending on whether the transaction samples were aliquoted).",
			Category -> "Organizational Information"
		},

		ShippingContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container,Box],
				Object[Container,Box]
			],
			Description -> "The packages shipped by this maintenance.",
			Category -> "Shipping Information"
		},
		ShippedRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Rack],
			Description -> "The racks in which the shipped samples are contained, if racks are requested.",
			Category -> "Inventory"
		},
		SecondaryContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container,Bag],Object[Container,Bag]],
			Description -> "Any bags used as secondary containment for samples shipped in these transactions.",
			Category -> "Shipping Information"
		},
		PlateSeals -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Model[Item]
			],
			Description -> "Any plate seals used to seal plates for more secure shipment.",
			Category -> "Shipping Information"
		},
		Ice -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Consumable],
				Model[Item,Consumable]
			],
			Description -> "Any ice packs used to ship transactions that specify ColdPacking as Ice.",
			Category -> "Shipping Information"
		},
		DryIce -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Sample], Object[Sample]],
			Description -> "Any dry ice used to ship transactions that specify ColdPacking as DryIce.",
			Category -> "Shipping Information"
		},
		Padding -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item,Consumable],
				Model[Item,Consumable]
			],
			Description -> "Any padding used to ship transactions that specify ColdPacking as Null.",
			Category -> "Shipping Information"
		},

		SamplePlacements -> {
			Format -> Multiple,
			Class -> {Link, Link, String},
			Pattern :> {_Link, _Link, LocationPositionP},
			Relation -> {Model[Container] | Object[Container] | Model[Sample] | Model[Item] | Object[Sample] | Object[Item] , Model[Container] | Object[Container], Null},
			Description -> "A list of placements used to place the sample containers (or aliquot containers if aliquoted) and items into the secondary containers and shipping containers.",
			Category -> "Placements",
			Developer -> True,
			Headers -> {"Object to Place", "Destination Object","Destination Position"}
		},
		SamplePreparationProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "The protocols used to create AliquotSamples for each aliquoted transaction prior to starting the experiment.",
			Category -> "Aliquoting"
		},
		Balance-> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, Balance], Object[Instrument, Balance]],
			Description -> "The balance used to weigh packages prepared by this maintenance.",
			Category -> "General"
		},
		PeanutsDispenser -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, Dispenser],Object[Instrument, Dispenser]],
			Description -> "The dispenser used to hold and dispense packing peanuts used in this maintenance shipping.",
	 		Category -> "General"
		},
		DryIceDispenser -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Instrument, Dispenser],Object[Instrument, Dispenser]],
			Description -> "The dispenser used to hold and dispense dry ice used in this maintenance.",
			Category -> "General"
		},
		DryIceStickers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item],Object[Item]],
			Description -> "Stickers used to label any safety hazards on the packages being shipped.",
			Category -> "General"
		},

		ShippingLabelFilePaths-> {
			Format -> Multiple,
			Class -> String,
			Pattern :> FilePathP,
			Description -> "For each member of ShippingContainers, the filepath of the pdf file that contains the shipping labels to affix to the package.",
			Developer -> True,
			Category -> "Shipping Information",
			IndexMatching->ShippingContainers
		}
	}
}];
