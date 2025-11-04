(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

$ShipFromECLSharedAliquotFields = {
	(* --- Aliquoting --- *)
	Aliquot -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> BooleanP,
		Description -> "Indicates if aliquots are taken from the SamplesIn and transferred into new AliquotSamples which are prepared and shipped in lieu of the SamplesIn for the transaction.",
		Category -> "Aliquoting",
		Developer -> True
	},
	AliquotSamples -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Object[Sample],
		Description -> "Samples corresponding to aliquots of SamplesIn generated during sample preparation and intended for use in this transaction.",
		Category -> "Aliquoting"
	},
	AliquotContainers -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Object[Container],
			Model[Container]
		],
		Description -> "Containers that hold AliquotSamples generated during sample preparation and intended for use in this transaction.",
		Category -> "Aliquoting"
	},
	AliquotVolumes -> {
		Format -> Multiple,
		Class -> Real,
		Pattern :> GreaterP[0*Micro*Liter],
		Units -> Liter Micro,
		Description -> "For each member of SamplesIn, the amount of sample transferred from the initial sample into an aliquot sample which is used in lieu of the initial sample for the transaction.",
		Category -> "Aliquoting",
		IndexMatching -> SamplesIn
	},
	TargetConcentrations -> {
		Format -> Multiple,
		Class -> Expression,
		Pattern :> GreaterP[0*Micro*Molar] | GreaterP[0 (Milligram/Milliliter)],
		Description -> "For each member of SamplesIn, the final concentration of analyte in the aliquot sample which is used in lieu of the initial sample for the transaction.",
		Category -> "Aliquoting",
		IndexMatching -> SamplesIn
	},
	ShipmentVolumes -> {
		Format -> Multiple,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Micro*Liter],
		Units -> Liter Micro,
		Description -> "For each member of SamplesIn, the total volume of the aliquot sample that is in this transaction. This includes the aliquot volume from the initial sample plus any buffer that was added for dilution.",
		Category -> "Aliquoting",
		IndexMatching -> SamplesIn
	},
	ConcentratedBuffer -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Object[Sample],
			Model[Sample]
		],
		Description -> "The concentrated buffer source which is added to each of the AliquotSamples to obtain 1x buffer concentration after dilution of the AliquotSamples which are used in lieu of the SamplesIn for the transaction.",
		Category -> "Aliquoting"
	},
	BufferDilutionFactor -> {
		Format -> Single,
		Class -> Integer,
		Pattern :> GreaterP[0],
		Units -> None,
		Description -> "The dilution factor by which the concentrated buffer is diluted in preparing the AliquotSamples to obtain a 1x buffer concentration after dilution of the AliquotSamples which are used in lieu of the SamplesIn for the transaction.",
		Category -> "Aliquoting"
	},
	BufferDiluent -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Object[Sample],
			Model[Sample]
		],
		Description -> "The diluent used to dilute the concentration of the concentrated buffer in preparing the AliquotSamples which are used in lieu of the SamplesIn for the transaction.",
		Category -> "Aliquoting"
	},
	ShipmentBuffer -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Object[Sample],
			Model[Sample]
		],
		Description -> "The final desired buffer for the AliquotSamples which are used in lieu of the SamplesIn for the transaction.",
		Category -> "Aliquoting"
	},

	ShippingPreparation -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Object[Maintenance,Shipping][Transactions],
		Description -> "The maintenance that prepared the samples in this transaction for shipment.",
		Category -> "Shipping Information"
	},

	SamplePreparationProtocols -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Object[Protocol],
		Description -> "The protocols used to prepare any AliquotSamples in this transaction.",
		Category -> "Aliquoting"
	},
	AliquotSamplePreparation -> {
		Format -> Multiple,
		Class -> {
			Aliquot -> Boolean,
			AliquotAmount -> Expression,
			TargetConcentration -> Expression,
			AssayVolume -> Real,
			(* need this to be an expression; it's okay because we don't ever resource pick from this field; if we had multiple multiples this could be real links *)
			AliquotContainer -> Expression,
			AssayBuffer -> Link,
			BufferDiluent -> Link,
			BufferDilutionFactor -> Real,
			ConcentratedBuffer -> Link,
			DestinationWell -> Expression,
			TargetConcentrationAnalyte -> Expression,
			AliquotSampleLabel -> String
		},
		Pattern :> {
			Aliquot -> BooleanP,
			AliquotAmount -> ListableP[GreaterEqualP[0 Milliliter]|GreaterEqualP[0 Gram]|GreaterEqualP[0 Unit] |GreaterEqualP[0]|Null],
			TargetConcentration -> ListableP[GreaterEqualP[0*Micro*Molar] | GreaterEqualP[0 (Milligram/Milliliter)]|Null],
			AssayVolume -> GreaterP[0 Milliliter],
			AliquotContainer -> {_Integer, ObjectP[{Model[Container], Object[Container]}]},
			AssayBuffer -> ObjectP[{Object[Sample], Model[Sample]}],
			BufferDiluent -> ObjectP[{Object[Sample], Model[Sample]}],
			BufferDilutionFactor -> GreaterEqualP[1],
			ConcentratedBuffer -> ObjectP[{Object[Sample], Model[Sample]}],
			DestinationWell -> Alternatives @@ Flatten[ECL`AllWells[NumberOfWells->384]],
			TargetConcentrationAnalyte -> ListableP[ObjectP[Model[Molecule]]|Null],
			AliquotSampleLabel -> _String
		},
		Units -> {
			Aliquot -> None,
			AliquotAmount -> None,
			TargetConcentration -> None,
			AssayVolume -> Milliliter,
			AliquotContainer -> None,
			AssayBuffer -> None,
			BufferDiluent -> None,
			BufferDilutionFactor -> None,
			ConcentratedBuffer -> None,
			DestinationWell -> None,
			TargetConcentrationAnalyte -> None,
			AliquotSampleLabel -> None
		},
		Relation -> {
			Aliquot -> Null,
			AliquotAmount -> Null,
			TargetConcentration -> Null,
			AssayVolume -> Null,
			AliquotContainer -> Null,
			AssayBuffer -> Object[Sample] | Model[Sample],
			BufferDiluent -> Object[Sample] | Model[Sample],
			BufferDilutionFactor -> Null,
			ConcentratedBuffer -> Object[Sample] | Model[Sample],
			DestinationWell -> Null,
			TargetConcentrationAnalyte -> Null,
			AliquotSampleLabel -> Null
		},
		Description -> "For each member of AliquotSamples, parameters describing how aliquots should be drawn from the input samples after initial sample preparation in order to create new aliquot samples upon which aliquot preparation and the experiment should proceed.",
		Category -> "Aliquoting"
	},
	ConsolidateAliquots -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> BooleanP,
		Description -> "Indicates if identical aliquots should be consolidated in a single sample.",
		Category -> "Aliquoting"
	},
	AliquotPreparation -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> PreparationMethodP,
		Description -> "Indicates if the aliquoting should occur manually or on a robotic liquid handler.",
		Category -> "Aliquoting"
	}
};
$ShipFromECLSharedGeneralFields = {

	ShippingPrice-> {
		Format -> Single,
		Class -> Real,
		Pattern :> GreaterEqualP[0*USD],
		Units -> USD,
		Description -> "The price associated with preparing this transaction for shipment and the shipping price for this transaction.",
		Category -> "Pricing Information"
	},
	(* --- Shipping Information --- *)
	ColdPacking -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> ColdPackingP,
		Description -> "Indicates that the transaction includes samples that must be shipped cold.",
		Category -> "Shipping Information"
	},
	ShippingSpeed -> {
		Format -> Single,
		Class -> Expression,
		Pattern :> ShippingSpeedP,
		Description -> "The delivery speed selected with the shipper of this transaction.",
		Category -> "Shipping Information"
	}
};
$ShipFromECLSharedShippingFields ={
	ShippingContainers -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[Object[Container,Box],Model[Container,Box]],
		Description -> "The packages containing the samples that are shipped by this transaction.",
		Category -> "Shipping Information"
	},
	SecondaryContainers -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[Object[Container,Bag],Model[Container,Bag]],
		Description -> "Any bags used as secondary containment for samples that are shipped in this transaction.",
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
		Description -> "Any plate seals used to seal plates for more secure shipment in this transaction.",
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
		Description -> "If this transaction specifies ColdPacking as Ice, the ice packs used to keep the samples cold during shipment.",
		Category -> "Shipping Information"
	},
	DryIce -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[Model[Sample], Object[Sample]],
		Description -> "If this transaction specifies ColdPacking as DryIce, the dry ice used to keep the samples cold during shipment.",
		Category -> "Shipping Information"
	},
	DryIceStickers -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[Model[Item],Object[Item]],
		Description -> "For each member of ShippingContainers, the sticker used to indicate that dry ice is included in the package.",
		Category -> "Shipping Information",
		IndexMatching->ShippingContainers
	},
	Padding -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Alternatives[
			Object[Item,Consumable],
			Model[Item,Consumable]
		],
		Description -> "If this transaction specifies ColdPacking as Null, the padding used to protect the samples during shipment.",
		Category -> "Shipping Information"
	},
	DryIceMasses -> {
		Format -> Multiple,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Gram],
		Units -> Gram,
		Description -> "For each member of ShippingContainers, the mass of dry ice used to keep the samples in that container cold during shipment.",
		Category -> "Shipping Information",
		IndexMatching->ShippingContainers
	},
	PaddingMasses -> {
		Format -> Multiple,
		Class -> Real,
		Pattern :> GreaterEqualP[0*Gram],
		Units -> Gram,
		Description -> "For each member of ShippingContainers, the mass of padding material used to protect the samples in that container during shipment.",
		Category -> "Shipping Information",
		IndexMatching->ShippingContainers
	},
	PackageWeightData -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Object[Data,Weight],
		Description -> "The weight of the packages shipped by this transactions.",
		Category -> "Shipping Information"
	},
	PackageTareWeightData -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Object[Data,Weight],
		Description -> "The weight of the packages shipped by this transactions before adding dry ice or padding, used for calculating the amount of dry ice and/or packing peanuts consumed during shipping preparation.",
		Category -> "Shipping Information",
		Developer->True
	},
	PackageTareBalanceWeightData -> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Object[Data,Weight],
		Description -> "The weight measurement of the balance when nothing is on it, that was measured for this data.",
		Category -> "Shipping Information",
		Developer->True
	},
	ShippingLabels-> {
		Format -> Multiple,
		Class -> Link,
		Pattern :> _Link,
		Relation -> Object[EmeraldCloudFile],
		Description -> "For each member of ShippingContainers, the shipping labels affixed to the package.",
		Category -> "Shipping Information",
		IndexMatching->ShippingContainers
	},
	Fragile -> {
		Format -> Multiple,
		Class -> Boolean,
		Pattern :> BooleanP,
		Description -> "For each member of SamplesIn, indicates whether the shipped sample is wrapped with an additional layer of protective material.",
		Category -> "Shipping Information",
		IndexMatching -> SamplesIn
	}
};

With[{
	shipFromECLSharedFields=Sequence@@$ShipFromECLSharedGeneralFields,
	sharedShippingFields= Sequence@@$ShipFromECLSharedShippingFields,
	aliquotFields = Sequence@@$ShipFromECLSharedAliquotFields
},
DefineObjectType[Object[Transaction,ShipToUser], {
	Description -> "Objects for tracking the shipments of experimental materials from ECL facilities",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ReturningStatusP,
			Description ->  "An indication of whether the transaction has shipped or is pending or if it has encountered troubleshooting.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		StatusLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link},
			Pattern :> {_?DateObjectQ, ReturningStatusP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "Log of the status changes for this transaction.",
			Category -> "Organizational Information",
			Headers -> {"Date","Status","Responsible Party"},
			Developer -> True
		},
		SamplesIn -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Object[Item],
			Description -> "The samples given as input to this transaction.",
			Category -> "Organizational Information"
		},
		ContainersIn -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers of the input samples for this transaction.",
			Category -> "Organizational Information"
		},
		SamplesOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sample]|Object[Item],
			Description -> "The samples (either the samples in or the aliquoted samples) shipped from ECL to the user in this transaction.",
			Category -> "Organizational Information"
		},
		ContainersOut -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container],
			Description -> "The containers shipped from ECL to the user in this transaction.",
			Category -> "Organizational Information"
		},
		WorkingSamples -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample],
				Model[Sample],
				Object[Item],
				Model[Item]
			],
			Description -> "For each member of SamplesIn, the derived sample on which the experiment acts. This list diverges from SamplesIn when input samples are transferred to new containers.",
			Category -> "Resources",
			IndexMatching->SamplesIn,
			Developer -> True
		},

		WorkingContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Model[Container]
			],
			Description ->"Containers of the samples corresponding to preparations of SamplesIn generated during sample preparation and intended for use in this experiment.",
			Category -> "Resources",
			Developer -> True
		},
		shipFromECLSharedFields,
		aliquotFields,
		sharedShippingFields,

		(* --- Shipping Information --- *)
		Orders -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction, Order][DropShipToUser],
			Description -> "The order that recorded the ordering detail of the samples directly shipped to the user upon purchase.",
			Category -> "Shipping Information"
		}
	}
}]
];
