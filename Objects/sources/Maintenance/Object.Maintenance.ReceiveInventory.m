(* ::Package:: *)

(**)


(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Maintenance, ReceiveInventory], {
	Description->"A protocol that processes receiving inventory items.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Orders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Transaction, Order][Receiving],
				Object[Transaction,ShipToECL][Receiving],
				Object[Transaction, DropShipping][Receiving],
				Object[Transaction, SiteToSite][Receiving]
			],
			Description -> "The orders that this maintenance is receiving.",
			Category -> "Inventory",
			Abstract -> True
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
			Description -> "For each member of Orders, number of samples generated total, (e.g., 48 if 2 cases of 24 plates each were received).  This field is always the product of QuantityReceived and SamplesPerItem.",
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
			Description -> "The samples generated by running MainenanceReceiveInventory for this particular batch number.",
			Category -> "Inventory",
			Abstract -> True
		},
		Containers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container][Receiving],
			Description -> "The containers generated by running MainenanceReceiveInventory.",
			Category -> "Inventory",
			Abstract -> True
		},
		Covers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Cap], Object[Item, Lid], Object[Item, PlateSeal]],
			Description -> "The covers generated by running MainenanceReceiveInventory.",
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
			Description -> "The sample objects that contain tablets and need to be counted upon being received.",
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
			Relation -> Object[Protocol,RoboticSamplePreparation]|Object[Protocol,ManualSamplePreparation],
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
		WeightMeasurements -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,MeasureWeight],
			Description -> "Protocols used to determine the initial weights of newly received samples.",
			Category -> "Sample Post-Processing"
		},
		VolumeMeasurements -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,MeasureVolume],
			Description -> "Protocols used to determine the initial volume of newly received samples.",
			Category -> "Sample Post-Processing"
		},
		CountMeasurements -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,MeasureCount],
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
		}
	}
}];
