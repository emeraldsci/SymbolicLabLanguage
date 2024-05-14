(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Transaction, DropShipping], {
	Description->"A transaction for materials from external service providers to be drop shipped.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DropShippingStatusP,
			Description -> "A symbol representing the current state of the transaction.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		StatusLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link},
			Pattern :> {_?DateObjectQ, DropShippingStatusP, _Link},
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
			Description -> "Date that the order was placed with the third party provider.",
			Category -> "Organizational Information"
		},
		OrderedItems -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Product],
				Model[Item],
				Model[Sensor]
			],
			Description -> "The models or products of the items ordered to be shipped to ECL from a third party provider in this transaction.",
			Category -> "Shipping Information"
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
		Provider -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Company, Service][Transactions],
				Object[Company, Supplier][Transactions]
			],
			Description -> "The service or supplier company that the ordered items will ship from.",
			Category -> "Shipping Information"
		},
		OrderNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The order number provided by the service provider of the models ordered in this transaction.",
			Category -> "Shipping Information"
		},
		OrderQuantities -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "For each member of OrderedItems, the number of samples expected.",
			Category -> "Inventory",
			IndexMatching -> OrderedItems
		},
		QuantitiesReceived -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "For each member of OrderedItems, number of samples that have been received to date.",
			Category -> "Inventory",
			IndexMatching -> OrderedItems
		},
		QuantitiesOutstanding -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "For each member of OrderedItems, number of samples that have not yet been received.",
			Category -> "Inventory",
			IndexMatching -> OrderedItems
		},
		ReceivedItems -> {
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
			Description -> "The objects generated by recieving this order (such as samples) in the order that they arrive.",
			Category -> "Inventory",
			Developer->True
		},
		ReceivedItemContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Containers automatically generated to hold items received by this order in the order that they arrive.",
			Category -> "Inventory",
			Developer->True
		},
		ReceivedItemCovers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Item, Cap], Object[Item, Lid]],
			Description -> "Covers for the containers automatically generated to hold items received by this order in the order that they arrive.",
			Category -> "Inventory",
			Developer->True
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
			Description -> "For each member of Models, The samples generated by receiving this order.",
			Category -> "Inventory",
			IndexMatching->Models
		},
		ContainersOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "Containers automatically generated to hold samples received by this order.",
			Category -> "Inventory"
		},
		TransferModels -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Sample],
				Object[Product]
			],
			Description -> "Samples that should be moved into a new container upon arrival at ECL.",
			Category -> "Inventory"
		},
		TransferContainers  -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container],
			Description -> "For each member of TransferModels, the type of container into which they will be transferred.",
			Category -> "Inventory",
			IndexMatching->TransferModels
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
			Description -> "For each member of OrderedItems, the initial sample volumes determined as specified in MassSource.",
			Category -> "Inventory",
			IndexMatching -> OrderedItems
		},
		Mass -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Gram],
			Units -> Gram,
			Description -> "For each member of OrderedItems, the initial sample masses determined as specified in VolumeSource.",
			Category -> "Inventory",
			IndexMatching -> OrderedItems
		},
		Count -> {
			Format -> Multiple,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "For each member of OrderedItems, the initial sample count determined as specified in CountSource.",
			Category -> "Inventory",
			IndexMatching -> OrderedItems
		},
		Concentration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Micromolar],
			Units -> Micromolar,
			Description -> "For each member of OrderedItems, the initial sample concentrations determined as specified in ConcentrationSource.",
			Category -> "Inventory",
			IndexMatching -> OrderedItems
		},
		MassConcentration -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterEqualP[(0*Gram)/Liter],
			Units -> Gram/Liter,
			Description -> "For each member of OrderedItems, the initial sample mass concentrations determined as specified in MassConcentrationSource.",
			Category -> "Inventory",
			IndexMatching -> OrderedItems
		},
		MassSource -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> UserSpecified | ProductDocumentation | ExperimentallyMeasure | None,
			Description -> "For each member of OrderedItems, how the mass of the samples is populated upon arrival at the ECL facility. UserSpecified indicates that the user input the initial mass. ExperimentallyMeasure indicates that the mass is measured upon arrival. ProductDocumentation indicates that the mass is found on the documents that ship with the sample. None indicates that an initial mass is not needed for this model.",
			Category -> "Inventory",
			IndexMatching -> OrderedItems
		},
		CountSource -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> UserSpecified | ProductDocumentation | ExperimentallyMeasure | None,
			Description -> "For each member of OrderedItems, how the count of the samples is populated upon arrival at the ECL facility. UserSpecified indicates that the user input the initial count (or mass and tablet weight from which count was calculated). ExperimentallyMeasure indicates that the count is measured upon arrival. ProductDocumentation indicates that the count is found on the documents that ship with the sample. None indicates that an initial count is not needed for this model.",
			Category -> "Inventory",
			IndexMatching -> OrderedItems
		},
		VolumeSource -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> UserSpecified | ProductDocumentation | ExperimentallyMeasure | None,
			Description -> "For each member of OrderedItems, how the volume of the samples will be populated upon arrival at the ECL facility. UserSpecified indicates that the user input the initial volume. ExperimentallyMeasure indicates that the volume is measured upon arrival. ProductDocumentation indicates that the volume is found on the documents that ship with the sample. None indicates that an initial mass is not needed for this model.",
			Category -> "Inventory",
			IndexMatching -> OrderedItems
		},
		ConcentrationSource -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> UserSpecified | ProductDocumentation | None,
			Description -> "For each member of OrderedItems, how the concentration of the samples will be populated upon arrival at the ECL facility. UserSpecified indicates that the user input the initial concentration. ProductDocumentation indicates that the concentration is found on the documents that ship with the sample. None indicates that an initial mass is not needed for this model.",
			Category -> "Inventory",
			IndexMatching -> OrderedItems
		},
		MassConcentrationSource -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> UserSpecified | ProductDocumentation | None,
			Description -> "For each member of OrderedItems, how the mass concentration of the items will be populated upon arrival at the ECL facility. UserSpecified indicates that the user input the initial mass concentration. ProductDocumentation indicates that the mass concentration is found on the documents that ship with the sample. None indicates that an initial mass is not needed for this model.",
			Category -> "Inventory",
			IndexMatching -> OrderedItems
		},
		VolumeMeasurementProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,MeasureVolume],
			Description -> "Any protocols used to experimentally measure the volume of the samples upon arrival.",
			Category -> "Inventory"
		},
		WeightMeasurementProtocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol,MeasureWeight],
			Description -> "Any protocols used to experimentally measure the mass of the samples upon arrival.",
			Category -> "Inventory"
		},
		VerifiedContainerModel -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the container models the drop shipped items arrived in are parameterized or they need to be parameterized and verified by the ECLs team.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		VerifiedCoverModel -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cover models on the container that the drop shipped items arrived in are parameterized or they need to be parameterized and verified by the ECLs team.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		}

	}
}];
