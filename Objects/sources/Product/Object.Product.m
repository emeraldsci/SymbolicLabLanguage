(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Product], {
	Description->"An item ordered by the ECL from an external supplier.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Shorthand name of the product.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Synonyms -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "List of possible alternative names this product goes by.",
			Category -> "Organizational Information"
		},
		Author -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The user who generated this product entry.",
			Category -> "Organizational Information",
			Developer -> True
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		Deprecated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this product is historical and no longer ordered by the ECL.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Site -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site],
			Description -> "The ECL facility at which the product can be purchased. Null indicates that the product can be purchased at any ECL location.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Verified -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the information in this model has been reviewed for accuracy by an ECL employee.",
			Category -> "Organizational Information"
		},
		VerifiedLog -> {
			Format -> Multiple,
			Class -> {Boolean, Link, Date},
			Pattern :> {BooleanP, _Link, _?DateObjectQ},
			Relation -> {Null, Object[User], Null},
			Headers -> {"Verified", "Responsible person", "Date"},
			Description -> "Records the history of changes to the Verified field, along with when the change occurred, and the person responsible.",
			Category -> "Organizational Information"
		},
		(* --- Product Specifications --- *)
		KitComponents -> {
			Format -> Multiple,
			Class -> {
				NumberOfItems -> Integer,
				ProductModel -> Link,
				DefaultContainerModel -> Link,
				Amount -> VariableUnit,
				Position -> String,
				ContainerIndex -> Integer,
				DefaultCoverModel -> Link,
				OpenContainer -> Expression
			},
			Pattern :> {
				NumberOfItems -> GreaterP[0, 1],
				ProductModel -> _Link,
				DefaultContainerModel -> _Link,
				Amount -> GreaterP[0 Liter] | GreaterP[0 Gram] | GreaterP[0 Unit, 1 Unit],
				Position -> WellP,
				ContainerIndex -> _Integer,
				DefaultCoverModel -> _Link,
				OpenContainer -> BooleanP
			},
			Units -> {
				NumberOfItems -> None,
				ProductModel -> None,
				DefaultContainerModel -> None,
				Amount -> None,
				Position -> None,
				ContainerIndex -> None,
				DefaultCoverModel -> None,
				OpenContainer -> None
			},
			Relation -> {
				NumberOfItems -> Null,
				ProductModel -> Alternatives[
					Model[Sample][KitProducts],
					Model[Container][KitProducts],
					Model[Sensor][KitProducts],
					Model[Part][KitProducts],
					Model[Plumbing][KitProducts],
					Model[Item][KitProducts],
					Model[Wiring][KitProducts],
					Model[Container][KitProductsContainers]
				],
				DefaultContainerModel -> Alternatives[
					Model[Container, Vessel],
					Model[Container, ReactionVessel],
					Model[Container, GasCylinder],
					Model[Container, Bag],
					Model[Container, Shipping],
					Model[Container, Plate],
					Model[Container, MicroscopeSlide]
				],
				Amount -> Null,
				Position -> Null,
				ContainerIndex -> Null,
				DefaultCoverModel -> Alternatives[
					Model[Item, Lid],
					Model[Item, Cap],
					Model[Item, PlateSeal]
				],
				OpenContainer -> Null
			},
			Description -> "All information about the components of this kit product, i.e., a product contains multiple different components.  For every entry, the indices refer to 1.) The number of copies of the given kit component in the kit, 2.) The model for the samples that this component of the kit will generate, 3.) The model of the container that this kit component arrives in, 4.) The amount that comes with each sample, 5.) The position in the DefaultContainerModel in which this arrives, 6.) The index of the container in which it appears (such that if two different kit components share a ContainerIndex, they will go into the same container, like with a plate), 7) The model of the lid or cap the default container model accepts, and 8) whether the container can be covered.",
			Category -> "Product Specifications",
			Abstract -> True
		},
		ProductModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample][Products],
				Model[Container][Products],
				Model[Sensor][Products],
				Model[Part][Products],
				Model[Plumbing][Products],
				Model[Item][Products],
				Model[Wiring][Products]
			],
			Description -> "The model for the samples that this product generates when purchased.",
			Category -> "Product Specifications"
		},
		OpenContainer->{
			Format->Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description->"Indicates if the container contents are exposed to the open environment when in use and can not be sealed off via capping.",
			Category->"Product Specifications",
			Developer ->True
		},
		SealedContainer -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the items of this product arrive as sealed containers with caps or lids. If SealedContainer -> True, no special storage handling will be performed, even if Sterile -> True.",
			Category -> "Product Specifications",
			Developer -> True
		},
		AsepticShippingContainerType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AsepticShippingContainerTypeP,
			Description -> "The manner in which an aseptic product is packed and shipped by the manufacturer. A value of None indicates that the product is not shipped in any specifically aseptic packaging, while a value of Null indicates no available information.",
			Category -> "Product Specifications",
			Developer -> True
		},
		AsepticRebaggingContainerType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AsepticTransportContainerTypeP,
			Description -> "Describes the type of container items of this product will be transferred to if they arrive in a non-resealable aseptic shipping container.",
			Category -> "Product Specifications",
			Developer -> True
		},
		ImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Source file for the catalog image of this product.",
			Category -> "Product Specifications"
		},
		ProductListing -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Full name under which the product is listed, including make and model where relevant.",
			Category -> "Product Specifications"
		},
		Supplier -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Company, Supplier][Products],
			Description -> "The company from which this product is ordered and purchased.",
			Category -> "Product Specifications",
			Abstract -> True
		},
		SupplierName -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Supplier]}, Download[Field[Supplier],Name]],
			Pattern :> _String,
			Description -> "The name of the company that supplies this product.",
			Category -> "Product Specifications"
		},
		CatalogNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Number or code that should be used to purchase this item from the supplier.",
			Category -> "Product Specifications",
			Abstract -> True
		},
		CatalogDescription -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The full description of the item as it is listed in the supplier's catalog including any relevant information on the number of samples per item, the sample type, and/or the amount per sample if that information is included in the suppliers catalog list and necessary to place an order for the correct unit of the item which this product represents.",
			Category -> "Product Specifications"
		},
		Manufacturer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Company, Supplier][Products],
			Description -> "The company that makes this product, if different from the supplier.",
			Category -> "Product Specifications"
		},
		ManufacturerCatalogNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Number or code that the manufacturer uses to refer to this product, when the manufacturer is different from the supplier.",
			Category -> "Product Specifications"
		},
		ProductURL -> {
			Format -> Single,
			Class -> String,
			Pattern :> URLP,
			Description -> "Supplier webpage for the product.",
			Category -> "Product Specifications"
		},
		Packaging -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PackagingP,
			Description -> "Specify whether this product comes in a case (which contains multiple items) or comes in a single item.",
			Category -> "Product Specifications"
		},
		SampleType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SampleDescriptionP,
			Description -> "The description of a single sample contained within an item of this product.",
			Category -> "Product Specifications"
		},
		ItemUnitDescription -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Packaging], Field[SampleType], Field[NumberOfItems]}, Computables`Private`itemUnitDescription[Field[Object]]],
			Pattern :> _String,
			Description -> "The full description of the item expected in an order of this product, including the number of items, the item type, the number of samples per item, the sample type, and, optionally, amount per sample if applicable.",
			Category -> "Product Specifications"
		},
		NumberOfItems -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "Number of samples in each order of one unit of the catalog number, e.g. if a plate product comes in case of 24 units, this options should be set to 24.",
			Category -> "Product Specifications"
		},
		DefaultContainerModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Vessel][ProductsContained],
				Model[Container, ReactionVessel][ProductsContained],
				Model[Container, GasCylinder][ProductsContained],
				Model[Container, Bag][ProductsContained],
				Model[Container, Shipping][ProductsContained],
				Model[Container, ProteinCapillaryElectrophoresisCartridge][ProductsContained],
				Model[Container, Plate][ProductsContained],
				Model[Container, MicroscopeSlide][ProductsContained]
			],
			Description -> "The model of the container that the sample arrives in upon delivery. If a Model[Container,Plate] is given, the plate must only have 1 well.",
			Category -> "Product Specifications",
			Abstract -> False
		},
		DefaultCoverModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Lid],
				Model[Item, Cap],
				Model[Item, PlateSeal]
			],
			Description -> "The model of the cover that seals the container in which the sample arrives in upon delivery.",
			Category -> "Product Specifications",
			Abstract -> False
		},
		ShippingContainer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Container, Bag],Model[Container,Envelope]],
			Description -> "The model of the bulk container that the product arrives in upon delivery.",
			Category -> "Product Specifications",
			Abstract -> False
		},
		Amount -> {
			Format -> Single,
			Class -> VariableUnit,
			Pattern :> GreaterP[0*Milliliter] | GreaterP[0*Milligram] | GreaterP[0*Unit, 1*Unit],
			Description -> "The quantity of material contained in each individual sample of this product.",
			Category -> "Product Specifications",
			Abstract -> True
		},
		Density -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0 * Gram) / Liter],
			Units -> Gram / (Liter Milli),
			Description -> "For product of chemical samples, indicate the ratio between mass and volume. This option does not apply to other type of products.",
			Category -> "Product Specifications"
		},
		CountPerSample -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0],
			Units -> None,
			Description -> "The number of individual items that comes with each sample (e.g. 100 for a box of 100 pipette tips).",
			Category -> "Product Specifications",
			Abstract -> True
		},
		ShippedClean -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "For product of empty containers, indicates that this product arrive ready to be used without needing to be dishwashed.",
			Category -> "Inventory"
		},
		Sterile -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if samples of this product are free from microbial contamination when received from the supplier.",
			Category -> "Product Specifications"
		},
		NucleicAcidFree -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that samples of this product arrive free of nucleic acids from the manufacturer.",
			Category -> "Product Specifications"
		},
		RNaseFree -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that samples of this product arrive free of RNase from the manufacturer.",
			Category -> "Product Specifications"
		},
		PyrogenFree -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that samples of this product arrive free of pyrogens from the manufacturer.",
			Category -> "Product Specifications"
		},
		UnwantedItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "List of images of items that should be thrown out upon receiving.",
			Category -> "Product Specifications"
		},
		RetainCase -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the item should be kept in a case (or blister pack) upon completion of a receiving.",
			Category -> "Product Specifications"
		},

		(* --- Pricing --- *)
		Price->{
			Format->Single,
			Class->Real,
			Pattern:>GreaterEqualP[0*USD],
			Units->USD,
			Description->"Supplier listed price for one unit of this product.",
			Category->"Pricing Information",
			Abstract->True
		},
		UsageFrequency -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> UsageFrequencyP,
			Description -> "An estimate of how often this product is purchased from ECL's inventory for use in experiments and subsequently restocked. Products which are used more frequently carry smaller stocking fees as they must be stored in inventory for a shorter period of time then more rarely consumed items.",
			Category -> "Pricing Information",
			Abstract -> True
		},

		(* --- Inventory --- *)
		Inventories -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Inventory][StockedInventory],
			Description -> "The inventory objects responsible for keeping this product in stock.",
			Category -> "Inventory"
		},
		StickerKitInParallel -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Developer -> True,
			Description -> "Indicate if the SLL object sticker of same component of all kits should be affixed together when multiple counts of kit were ordered in one run, instead of affixing all components from one kit, then move to the next kit.",
			Category -> "Inventory"
		},
		NotForSale -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this product can not be purchased from ECL's inventory because it is a non-commercial item for internal usage only.",
			Category -> "Inventory"
		},
		Stocked -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this product is kept in supply for purchase from ECL's inventory.",
			Category -> "Inventory"
		},
		EstimatedLeadTime -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The supplier's estimated lead time between ordering and receiving this product in stock.",
			Category -> "Inventory"
		},
		Orders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Transaction, Order][Products]
			],
			Description -> "List of order transactions involved in stocking this product.",
			Category -> "Inventory"
		},
		Samples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample][Product],
				Object[Item][Product],
				Object[Container][Product],
				Object[Part][Product],
				Object[Plumbing][Product],
				Object[Sensor][Product],
				Object[Wiring][Product]
			],
			Description -> "All samples (both stocked and historic) that were purchased under this product's supplier and catalog number.",
			Category -> "Inventory"
		},
		BulkContainer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Developer -> True,
			Description -> "Indicates whether the items of this product are stored together, with a sheet of their stickers, in their packaging from the manufacturer. If BulkContainer is Null, this only happens for high quantity items like a bag of many tubes.",
			Category -> "Inventory"
		},
		BulkContainerModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,Bag],
			Developer -> True,
			Description -> "If empirically determined, the bag model in which items of this product are stored.",
			Category -> "Inventory"
		},
		(* --- Replicate Products --- *)
		Template -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][ProductsTemplated],
			Description -> "An existing product object whose values will be used as defaults for any options not specified by the user.",
			Category -> "Product Specifications"
		},
		ProductsTemplated -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][Template],
			Description -> "Products which were generated using this product's values as a starting point for its option defaults.",
			Category -> "Product Specifications"
		},
		(* --- Migration Support --- *)
		LegacyID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The SLL2 ID for this Object, if it was migrated from the old data store.",
			Category -> "Migration Support",
			Developer -> True
		},
		(* --- User inputs when creating the object --- *)
		UnresolvedInputs -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _List,
			Description -> "The raw inputs provided by the user when creating this product via UploadProduct function.",
			Category -> "Organizational Information",
			Developer -> True
		},
		UnresolvedOptions -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> {(_Rule | _RuleDelayed)...},
			Description -> "The options provided by the user when creating this product via UploadProduct function.",
			Category -> "Organizational Information",
			Developer -> True
		}
	}
}];
