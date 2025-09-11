(* ::Package:: *)

(**)


(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, ReceiveInventory], {
	Description -> "A protocol that processes receiving inventory items.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		Orders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Transaction, Order][Receiving],
				Object[Transaction, ShipToECL][Receiving],
				Object[Transaction, DropShipping][Receiving],
				Object[Transaction, SiteToSite][Receiving]
			],
			Description -> "The orders that this maintenance is receiving.",
			Category -> "Inventory",
			Abstract -> True
		},
		Counter -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "A range of numbers that represent the number of received products that are processed during this maintenance. It is used for looping purposes within procedures.",
			Category -> "Inventory",
			Developer -> True
		},
		OrderNumbers -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The order number provided by the operator to identify the received item.",
			Category -> "Shipping Information",
			Developer -> True
		},
		CatalogNumbers -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "Number or code provided by the operator to identify the received item.",
			Category -> "Inventory",
			Developer -> True
		},
		ProductNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The names of the products that are received by this maintenance.",
			Category -> "Inventory",
			Developer -> True
		},
		SupplierNames -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The names of the companies from which the items received in this maintenance were purchased.",
			Category -> "Inventory",
			Developer -> True
		},
		MatchingProduct -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Container],
				Model[Part],
				Model[Plumbing],
				Model[Wiring],
				Model[Item],
				Object[Product],
				Model[Sensor]
			],
			Description -> "Products that match the entered catalog number.",
			Category -> "Inventory",
			Developer -> True
		},
		MatchingOrder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Transaction, Order], Object[Transaction, DropShipping]],
			Description -> "Orders that match the entered order number.",
			Category -> "Inventory",
			Developer -> True
		},
		MatchingOrders -> {
			Format -> Multiple,
			Class -> {Link, Link},
			Pattern :> {_Link, _Link},
			Relation -> {
				Alternatives[Object[Transaction, Order], Object[Transaction, DropShipping]],
				Alternatives[
					Model[Sample],
					Model[Container],
					Model[Part],
					Model[Plumbing],
					Model[Wiring],
					Model[Item],
					Object[Product],
					Model[Sensor]
				]
			},
			Headers -> {"MatchingOrders", "MatchingProducts"},
			Description -> "Tuples of matching orders and products in cases where more than one order/product is found.",
			Category -> "Inventory",
			Developer -> True
		},
		VerifiedProducts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Container],
				Model[Part],
				Model[Plumbing],
				Model[Wiring],
				Model[Item],
				Object[Product],
				Model[Sensor]
			],
			Description -> "Products that are verified by operators as the exact product.",
			Category -> "Inventory",
			Developer -> True
		},
		VerifiedProductQuantities -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The number of units of the verified product.",
			Category -> "Inventory",
			Developer -> True
		},
		VerifiedOrders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Transaction, Order],
				Object[Transaction, DropShipping]
			],
			Description -> "Orders corresponding to the verified products.",
			Category -> "Inventory",
			Developer -> True
		},
		ProductModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Model[Container],
				Model[Part],
				Model[Plumbing],
				Model[Wiring],
				Model[Item],
				Object[Product],
				Model[Sensor]
			],
			Description -> "For each member of Orders, the model (for sent or drop shipped transactions) or product (for ordered transactions) of item created for that transaction.",
			Category -> "Inventory",
			IndexMatching -> Orders
		},
		QuantityReceived -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "For each member of Orders, number of units of the given catalog number that were received.",
			Category -> "Inventory",
			IndexMatching -> Orders
		},
		SamplesPerItem -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "For each member of Orders, number of samples one unit of the catalog number, e.g. 24 (plates per case).",
			Category -> "Product Specifications",
			IndexMatching -> Orders
		},
		QuantitySamplesReceived -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "For each member of Orders, number of samples generated total, (e.g., 48 if 2 cases of 24 plates each were received). This field is always the product of QuantityReceived and SamplesPerItem.",
			Category -> "Product Specifications",
			IndexMatching -> Orders
		},
		Items -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample][Receiving],
				Object[Item][Receiving],
				Object[Container][Receiving],
				Object[Instrument][Receiving],
				Object[Sensor][Receiving],
				Object[Part][Receiving],
				Object[Plumbing][Receiving],
				Object[Wiring][Receiving]
			],
			Description -> "The samples generated by running MaintenanceReceiveInventory for the orders included in this maintenance.",
			Category -> "Inventory",
			Abstract -> True
		},
		ListedItems -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> ListableP[LinkP[{
				Object[Sample],
				Object[Item],
				Object[Container],
				Object[Instrument],
				Object[Sensor],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			}]],
			Description -> "A partitioned list of samples where each list of samples corresponds to a product or dropshipped model.",
			Category -> "Inventory",
			Developer -> True
		},
		CurrentItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Item],
				Object[Container],
				Object[Instrument],
				Object[Sensor],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "The samples that are actively being processed by this maintenance.",
			Category -> "Inventory",
			Developer -> True
		},
		Containers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container][Receiving],
			Description -> "The containers generated by running MaintenanceReceiveInventory.",
			Category -> "Inventory",
			Abstract -> True
		},
		ListedContainers -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LinkP[Object[Container]]...},
			Description -> "A partitioned list of containers where each list of containers corresponds to a product or dropshipped model.",
			Category -> "Inventory",
			Developer -> True
		},
		CurrentContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers that are actively being processed by this maintenance.",
			Category -> "Inventory",
			Developer -> True
		},
		Covers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Cap], Object[Item, Lid], Object[Item, PlateSeal]],
			Description -> "The covers generated by running MaintenanceReceiveInventory.",
			Category -> "Inventory",
			Abstract -> False
		},
		ShippedRacks -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Rack],
			Description -> "The racks which were shipped along with the other received items.",
			Category -> "Inventory"
		},
		BatchNumbers -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The batch numbers for the items that are actively being processed in this order.",
			Category -> "Inventory",
			Developer -> True
		},
		ExpirationDate -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> _Integer,
			Description -> "The date after which this item is considered expired. This date is recorded from the manufacturer's specified expiration date on the product label.",
			Category -> "Inventory",
			Developer -> True
		},
		ExpirationDates -> {
			Format -> Multiple,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "For each member of VerifiedProducts, the date after which the items of this product are considered expired.",
			Category -> "Inventory"
		},
		VolumeMeasuredSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The sample objects that are liquids and need to be volume measured upon being received.",
			Category -> "Inventory"
		},
		WeightMeasuredSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The sample objects that are solids or liquids with density informed, and need to be weighed upon being received.",
			Category -> "Inventory"
		},
		CountMeasuredSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The sample objects that contain tablets or sachets and need to be counted upon being received.",
			Category -> "Inventory"
		},
		TransferSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample],
			Description -> "The sample objects that need to be transferred to new bottles in order to have their volume measured.",
			Category -> "Inventory"
		},
		GasCylinders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, GasCylinder],
			Description -> "The gas cylinders that are received in this protocol.",
			Category -> "Inventory"
		},
		ReceivingPreparation -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, RoboticSamplePreparation] | Object[Protocol, ManualSamplePreparation],
			Description -> "Any sample manipulation transfer protocols that were generated by and executed during the execution of this MaintenanceReceiveInventory.",
			Category -> "Inventory"
		},
		ReceivingUnitOperations -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> SamplePreparationP,
			Description -> "A list of transfers indicating transfers to be performed to move newly-received samples to new containers in order to have their volumes measured.",
			Category -> "Inventory"
		},
		ReceiveInventoryPrograms -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program][Maintenance],
			Description -> "Any ReceiveInventory programs that were generated during the execution of this MaintenanceReceiveInventory.",
			Category -> "Inventory",
			Developer -> True
		},
		CurrentReceiveInventoryPrograms -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program],
			Description -> "ReceiveInventory programs that are actively being processed by this maintenance.",
			Category -> "Inventory",
			Developer -> True
		},
		UnbagInBSCPrograms -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Program],
			Description -> "ReceiveInventory programs that contain items that are processed in a biosafety cabinet for affixing stickers.",
			Category -> "Inventory",
			Developer -> True
		},
		WeightMeasurements -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, MeasureWeight],
			Description -> "Protocols used to determine the initial weights of newly received samples.",
			Category -> "Sample Post-Processing"
		},
		VolumeMeasurements -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, MeasureVolume],
			Description -> "Protocols used to determine the initial volume of newly received samples.",
			Category -> "Sample Post-Processing"
		},
		CountMeasurements -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol, MeasureCount],
			Description -> "Protocols used to determine the initial count of newly received samples.",
			Category -> "Sample Post-Processing"
		},
		ContainerlessItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Container],
				Object[Part],
				Object[Instrument],
				Object[Item],
				Object[Plumbing],
				Object[Wiring],
				Object[Sensor]
			],
			Description -> "All the objects created in this MaintenanceReceiveInventory that do not have containers created for them.",
			Category -> "Inventory"
		},
		ListedContainerlessItems -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> {LinkP[{
				Object[Sample],
				Object[Item],
				Object[Container],
				Object[Instrument],
				Object[Sensor],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			}]...},
			Description -> "A partitioned list of items where each list of items corresponds to a product or dropshipped model.",
			Category -> "Inventory",
			Developer -> True
		},
		CurrentContainerlessItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Item],
				Object[Container],
				Object[Instrument],
				Object[Sensor],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "The containerless items that are actively being processed by this maintenance.",
			Category -> "Inventory",
			Developer -> True
		},
		InstalledGasCylinders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, GasCylinder],
			Description -> "Gas cylinders being received that require installation.",
			Category -> "Inventory"
		},
		GasCylinderInstallations -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance, InstallGasCylinder],
			Description -> "Maintenance protocols used to install any gas cylinder that are being received.",
			Category -> "Inventory"
		},
		UnverifiedContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "List of new container models encountered in this receiving that need to be parameterized.",
			Category -> "Qualifications & Maintenance"
		},
		ParameterizedContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The container objects that had their container model updated as a result of parameterization.",
			Category -> "Qualifications & Maintenance"
		},
		EmptyContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Container]],
			Description -> "A list of content-free Model or Object Containers that were shipped with the transaction. These empty containers are used for container parameterization, and allow the ECL to work with new container types that are encountered.",
			Category -> "General"
		},
		UnverifiedCovers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Cap], Object[Item, Lid], Object[Item, PlateSeal]],
			Description -> "List of cover items encountered in this receiving that are either of an unparameterized model, or do not match the physical characteristics of their assigned model.",
			Category -> "Inventory",
			Abstract -> False
		},
		RestrictedStoredContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Any empty containers that must be dishwashed prior to being resource picked for use in protocols, but are awaiting parameterization of their covers.",
			Category -> "General"
		},
		SterileLabware -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item]],
			Description -> "The labware that must be autoclaved prior to being resource picked for use in protocols.",
			Category -> "General"
		},
		DimensionMeasurementItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Object[Container],
				Object[Instrument],
				Object[Sensor],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Any items that need to have their dimensions measured during receiving.",
			Category -> "Qualifications & Maintenance"
		},
		StorageOrientationMeasurementItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Object[Container],
				Object[Instrument],
				Object[Sensor],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Any items that need to have their optimal storage orientation determined during receiving.",
			Category -> "Qualifications & Maintenance"
		},
		ItemsToImage -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item],
				Object[Container],
				Object[Instrument],
				Object[Sensor],
				Object[Part],
				Object[Plumbing],
				Object[Wiring]
			],
			Description -> "Any items that need to have their image taken during receiving.",
			Category -> "Qualifications & Maintenance"
		},
		RebaggingEnvironment -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Instrument, BiosafetyCabinet],
				Object[Instrument, BiosafetyCabinet],
				Model[Instrument, HandlingStation, BiosafetyCabinet],
				Object[Instrument, HandlingStation, BiosafetyCabinet]
			],
			Description -> "An aseptic environment used for some or all parts of the maintenance.",
			Category -> "General",
			Abstract -> True
		},
		AsepticContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Bag, Aseptic],
				Object[Container, Bag, Aseptic]
			],
			Description -> "An aseptic bag used to store some or all items received in the maintenance.",
			Category -> "General",
			Abstract -> True
		},
		StickerBags -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container, Bag],
				Object[Container, Bag]
			],
			Description -> "Small plastic bags used to hold printed stickers for items that need to be stickered inside a biosafety cabinet, until the stickers are applied.",
			Category -> "Inventory",
			Developer -> True
		},
		Label -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Item, Consumable],
				Object[Item, Consumable]
			],
			Description -> "Circle labels used as tape for sticking the sticker bags to the product packages.",
			Category -> "Inventory",
			Developer -> True
		},
		Email -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Whether an email should be sent to accounts payable after the items in this maintenance were received. It is uploaded to False after an email is sent.",
			Category -> "Organizational Information",
			Developer -> True
		}
	}
}];
