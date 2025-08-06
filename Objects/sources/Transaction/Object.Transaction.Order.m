(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Transaction, Order], {
	Description->"A transaction to order materials from external suppliers.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OrderStatusP,
			Description -> "A symbol representing the current state of the transaction.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		StatusLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link},
			Pattern :> {_?DateObjectQ, OrderStatusP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "Log of the status changes for this transaction.",
			Category -> "Organizational Information",
			Headers -> {"Date","Status","Responsible Party"},
			Developer -> True
		},
		DateOrdered -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date that the order was placed with the supplier.",
			Category -> "Organizational Information"
		},
		Products -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][Orders],
			Description -> "The products being ordered.",
			Category -> "Product Specifications"
		},
		ProductListings -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Products]}, Download[Field[Products], ProductListing]],
			Pattern :> {(Null | _String) ..},
			Description -> "Full names under which the products are listed, including make and model where relevant.",
			Category -> "Product Specifications"
		},
		CatalogNumbers -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "For each member of Products, number or code that should be used to purchase these items from the supplier.",
			Category -> "Product Specifications",
			IndexMatching -> Products
		},
		ItemUnitDescriptions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Products]}, Download[Field[Products], ItemUnitDescription]],
			Pattern :> {(Null | _String) ..},
			Description -> "Amount that comes with on order of the item's catalog number(e.g. \"500 mL bottle\" or \"1 case of 24 plates\").",
			Category -> "Product Specifications"
		},
		Supplier -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Company, Supplier][Transactions]
			],
			Description -> "The supplier company that the items will ship from.",
			Category -> "Product Specifications"
		},
		OrderNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The order number provided by the supplier of the products ordered in this transaction.",
			Category -> "Shipping Information"
		},
		RequestedAutomatically -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this order was generated automatically due to a product falling below its minimum quantity stocked.",
			Category -> "Inventory",
			Abstract -> True
		},
		InternalOrder->{
			Format->Single,
			Class->Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the items should try to be purchased directly from ECL's in house inventory.",
			Category -> "Inventory",
			Abstract -> True
		},
		OrderQuantities -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "For each member of Products, number of units of the given catalog number to be ordered.",
			Category -> "Inventory",
			IndexMatching -> Products
		},
		OrderedModels -> {
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
				Model[Sensor]
			],
			Description -> "The models directly requested for ordering in this transaction.",
			Category -> "Inventory"
		},
		OrderAmounts -> {
			Format -> Multiple,
			Class -> VariableUnit,
			Pattern :> GreaterP[0*Milliliter] | GreaterP[0*Milligram] | GreaterP[0*Unit, 1*Unit],
			Description -> "For each member of OrderedModels, the amount that will satisfy this order.",
			Category -> "Inventory",
			IndexMatching -> OrderedModels
		},
		QuantitiesReceived -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "For each member of Products, number of units of the given catalog number that have been received to date.",
			Category -> "Inventory",
			IndexMatching -> Products
		},
		QuantitiesOutstanding -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "For each member of Products, number of units of the given catalog number that have not yet been received.",
			Category -> "Inventory",
			IndexMatching -> Products
		},
		Models -> {
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
				Model[Sensor]
			],
			Description -> "The models being ordered.",
			Category -> "Organizational Information"
		},
		SamplesOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Container],
				Object[Part],
				Object[Plumbing],
				Object[Wiring],
				Object[Item],
				Object[Sensor]
			],
			Description -> "For each member of Models, the samples/containers/parts/plumbing generated by receiving this order.",
			Category -> "Inventory",
			IndexMatching -> Models,
			Abstract -> True
		},
		ContainersOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Containers automatically generated to hold samples received by this order.",
			Category -> "Inventory"
		},
		TransferObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Product],Model[Sample]],
			Description -> "Samples that should be moved into a new container upon arrival at ECL.",
			Category -> "Inventory"
		},
		TransferContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "For each member of TransferObjects, the type of container into which they will be transferred.",
			Category -> "Inventory",
			IndexMatching->TransferObjects
		},
		ReceivedItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Object[Container],
				Object[Instrument],
				Object[Sensor],
				Object[Part],
				Object[Plumbing],
				Object[Wiring],
				Object[Item]
			],
			Description -> "The objects generated by receiving this order (such as samples) in the order that they arrive.",
			Category -> "Inventory"
		},
		ReceivedItemContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Containers automatically generated to hold items received by this order in the order that they arrive.",
			Category -> "Inventory"
		},
		ReceivedItemCovers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Cap], Object[Item, Lid], Object[Item, PlateSeal]],
			Description -> "Covers for the containers automatically generated to hold items received by this order in the order that they arrive.",
			Category -> "Inventory",
			Developer->True
		},
		Fulfillment -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol, StockSolution][OrdersFulfilled],
				Object[Protocol, SampleManipulation][OrdersFulfilled],
				Object[Protocol, ManualSamplePreparation][OrdersFulfilled],
				Object[Protocol, ManualCellPreparation][OrdersFulfilled],
				Object[Protocol, RoboticSamplePreparation][OrdersFulfilled],
				Object[Protocol, RoboticCellPreparation][OrdersFulfilled],
				Object[Protocol, Transfer][OrdersFulfilled]
			],
			Description -> "Protocols or maintenance requested to fulfill this order.",
			Category -> "Inventory"
		},
		Receiving -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance, ReceiveInventory][Orders],
			Description -> "The MaintenanceReceiveInventory protocols that received this order.",
			Category -> "Inventory"
		},
		BatchNumbers -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "The batch numbers for the items received in this order.",
			Category -> "Inventory"
		},
		BulkContainer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Developer -> True,
			Description -> "Indicates whether a shipping container object needs to be created into which the items of this order will be moved.  This only happens for high quantity items like a bag of many tubes.",
			Category -> "Inventory"
		},
		Volume -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Liter],
			Units -> Liter,
			Description -> "For each member of Products, the initial sample volumes determined as specified in MassSource.",
			Category -> "Inventory",
			IndexMatching -> Products
		},
		Mass -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Gram],
			Units -> Gram,
			Description -> "For each member of Products, the initial sample masses determined as specified in VolumeSource.",
			Category -> "Inventory",
			IndexMatching -> Products
		},
		Count -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of Products, the initial sample count determined as specified in CountSource.",
			Category -> "Inventory",
			IndexMatching -> Products
		},
		Concentration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micromolar],
			Units -> Micromolar,
			Description -> "For each member of Products, the initial sample concentrations determined as specified in ConcentrationSource.",
			Category -> "Inventory",
			IndexMatching -> Products
		},
		MassConcentration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Liter],
			Units -> Gram/Liter,
			Description -> "For each member of Products, the initial sample mass concentrations determined as specified in MassConcentrationSource.",
			Category -> "Inventory",
			IndexMatching -> Products
		},
		MassSource -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> UserSpecified | ProductDocumentation | ExperimentallyMeasure | None,
			Description -> "For each member of Products, how the mass of the samples is populated upon arrival at the ECL facility. UserSpecified indicates that the user input the initial mass. ExperimentallyMeasure indicates that the mass is measured upon arrival. ProductDocumentation indicates that the mass is found on the documents that ship with the sample. None indicates that an initial mass is not needed for this model.",
			Category -> "Inventory",
			IndexMatching -> Products
		},
		CountSource -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> UserSpecified | ProductDocumentation | ExperimentallyMeasure | None,
			Description -> "For each member of Products, how the count of the samples is populated upon arrival at the ECL facility. UserSpecified indicates that the user input the initial count (or mass and tablet weight from which count was calculated). ExperimentallyMeasure indicates that the count is measured upon arrival. ProductDocumentation indicates that the count is found on the documents that ship with the sample. None indicates that an initial count is not needed for this model.",
			Category -> "Inventory",
			IndexMatching -> Products
		},
		VolumeSource -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> UserSpecified | ProductDocumentation | ExperimentallyMeasure | None,
			Description -> "For each member of Products, how the volume of the samples will be populated upon arrival at the ECL facility. UserSpecified indicates that the user input the initial volume. ExperimentallyMeasure indicates that the volume is measured upon arrival. ProductDocumentation indicates that the volume is found on the documents that ship with the sample. None indicates that an initial mass is not needed for this model.",
			Category -> "Inventory",
			IndexMatching -> Products
		},
		ConcentrationSource -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> UserSpecified | ProductDocumentation | None,
			Description -> "For each member of Products, how the concentration of the samples will be populated upon arrival at the ECL facility. UserSpecified indicates that the user input the initial concentration. ProductDocumentation indicates that the concentration is found on the documents that ship with the sample. None indicates that an initial mass is not needed for this model.",
			Category -> "Inventory",
			IndexMatching -> Products
		},
		MassConcentrationSource -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> UserSpecified | ProductDocumentation | None,
			Description -> "For each member of Products, how the mass concentration of the items will be populated upon arrival at the ECL facility. UserSpecified indicates that the user input the initial mass concentration. ProductDocumentation indicates that the mass concentration is found on the documents that ship with the sample. None indicates that an initial mass is not needed for this model.",
			Category -> "Inventory",
			IndexMatching -> Products
		},
		VolumeMeasurementProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,MeasureVolume],
			Description -> "The protocol used to experimentally measure the volume of the samples upon arrival.",
			Category -> "Inventory"
		},
		WeightMeasurementProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,MeasureWeight],
			Description -> "The protocol used to experimentally measure the mass of the samples upon arrival.",
			Category -> "Inventory"
		},
		BackorderedItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product],
			Description -> "The products within this order that have been marked as Backordered by the supplier.",
			Category -> "Shipping Information"
		},
		ShippingSpeed -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ShippingSpeedP,
			Description -> "The delivery speed selected with the shipper of this transaction.",
			Category -> "Shipping Information"
		},
		ShipToUser->{
   	        Format->Single,
			Class->Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the samples ordered and received in this transaction will send to your work location.",
			Category -> "Shipping Information",
			Abstract -> True
		},
		DropShipToUser-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction, ShipToUser][Orders],
			Description -> "The ShipToUser transaction that tracks the shipping status of the purchased samples in this order.",
			Category -> "Shipping Information"
		},
		Resources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Resource][Order],
			Description -> "The resources that can only be fulfilled once this order is received.",
			Category -> "Resources"
		},
		DependentProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol][ShippingMaterials, 1],
				Object[Maintenance][ShippingMaterials, 1],
				Object[Qualification][ShippingMaterials, 1]
			],
			Description -> "Indicates the protocols that are depending on this order to be received before they can be run or continued.",
			Category -> "Resources"
		},
		DependentOrder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction,Order][SupplierOrder],
			Description -> "An internal order that requires this order to be received so this order's samples may be used to fulfill the samples requested by the dependent order.",
			Category -> "Resources"
		},
		SupplierOrder -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction,Order][DependentOrder],
			Description -> "An order from an external supplier that must be received so that the supplier order's samples may be used to fulfill the samples requested by this order.",
			Category -> "Resources"
		}
	}
}];
