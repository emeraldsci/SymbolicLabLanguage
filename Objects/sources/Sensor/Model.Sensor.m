(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Sensor], {
	Description->"Model information for a device used to interrogate the state of a sample or the surrounding environment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name given to this sensor model.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Deprecated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this modelSensor is historical and no longer used in the lab.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Authors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The person(s) who created this sensor model.",
			Category -> "Organizational Information"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		ImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A photo of this sensor model.",
			Category -> "Organizational Information"
		},
		Icon -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A simplified image used to represent this sensor.",
			Category -> "Organizational Information"
		},
		UserManualFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "PDFs for the manuals or instruction guides for this model of sensor.",
			Category -> "Organizational Information"
		},
		USPCategorization -> {
			Format -> Single,
			Class -> {Expression, Expression},
			Pattern :> {USPCategorizationP, USPCategorizationJustificationP},
			Description -> "The USP Group, as outlined in USP 1058, with which this sensor is associated and the justification for that classification. Group A represents the least complex instruments that do not have measurement capability or require calibration. Group B represents instruments that may provide a measurement or an experimental condition that can affect measurement. Group C represents complex analytical instruments with a significant degree of computerization.",
			Headers -> {"USP Group", "Justification"},
			Category -> "Organizational Information",
			Developer -> True
		},
		SensorOutputSignal -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SensorOutputTypeP,
			Description -> "The type of signal with which the sensor outputs measurement data.",
			Category -> "Sensor Information"
		},
		PLCVariableType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PLCVariableTypeP,
			Description -> "The type of variable used to represent this sensor model on the PLC that controls the sensor.",
			Category -> "Sensor Information"
		},
		PowerInput -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DirectCurrentP,
			Description -> "Describes the source of power for the sensor.",
			Category -> "Sensor Information"
		},
		Method -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MeasurementMethodP,
			Description -> "Describes what is initially measured by this sensor (before any processing).",
			Category -> "Sensor Information"
		},
		Dimensions-> {
			Format -> Single,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterP[0*Meter], GreaterP[0*Meter],GreaterP[0*Meter]},
			Units -> {Meter, Meter, Meter},
			Description -> "The external dimensions of this sensor.",
			Category -> "Dimensions & Positions",
			Headers -> {"Dimension X", "Dimension Y", "Dimension Z"}
		},
		Footprint -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FootprintP,
			Description -> "Standard form factor of the exterior bottom portion of this model of container used to seat the container in an open position.",
			Category -> "Dimensions & Positions"
		},
		CrossSectionalShape -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CrossSectionalShapeP,
			Description -> "The shape of this model of sensor in the X-Y plane.",
			Category -> "Dimensions & Positions"
		},
		PackingDensity -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Centimeter^(-3)],
			Units ->Centimeter^(-3),
			Description -> "The ratio of the number of items to the volume of the container in which they are packed, when stored in a homogeneous pile. This value is determined empirically by measuring how many objects of this model can fit a fixed volume.",
			Category -> "Dimensions & Positions"
		},
		QualificationFrequency -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterEqualP[0*Day]},
			Relation -> {Model[Qualification][Targets], Null},
			Units -> {None, Day},
			Description -> "A list of the Qualifications which should be run on this sensor and their required frequencies.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Model Qualification Object", "Time"}
		},
		MaintenanceFrequency -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterEqualP[0*Day]},
			Relation -> {Model[Maintenance][Targets], Null},
			Units -> {None, Day},
			Description -> "A list of the maintenances which are run on this sensor and their required frequencies.",
			Category -> "Qualifications & Maintenance",
			Headers ->  {"Model Maintenance Object", "Time"}
		},
		ContinuousOperation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the sensor is required to operate continuously in the lab, regardless of if it is InUse by a specific protocol.",
			Category-> "Qualifications & Maintenance"
		},
		Products -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][ProductModel],
			Description -> "A list of products storing purchasing information for sensors described by this model.",
			Category -> "Inventory"
		},
		KitProducts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][KitComponents, ProductModel],
			Description -> "Products ordering information for this model if this model is part of one or more kits.",
			Category -> "Inventory"
		},
		MixedBatchProducts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][MixedBatchComponents, ProductModel],
			Description -> "Products ordering information for this model if this model is part of one or more mixed batches.",
			Category -> "Inventory"
		},
		StickeredUponArrival -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if a sticker should be attached to this item during Receive Inventory, or if the unpeeled sticker should be stored with the item and affixed during resource picking.",
			Category -> "Inventory",
			Developer->True
		},
		StickerPositionOnReceiving -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if position stickers for this object need to be printed upon receiving.",
			Category -> "Inventory",
			Developer->True
		},
		PositionStickerPlacementImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A file containing a picture of where to put relevant position stickers on the object.",
			Category -> "Inventory",
			Developer -> True
		},
		StickerConnectionOnReceiving -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if connection stickers for this object need to be printed upon receiving.",
			Category -> "Inventory",
			Developer->True
		},
		ConnectionStickerPlacementImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A file containing a picture of where to put relevant connection stickers on the object.",
			Category -> "Inventory",
			Developer -> True
		},
		BarcodeTag -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item],
			Description -> "The secondary tag used to affix a barcode to this object.",
			Category -> "Inventory",
			Developer->True
		},
		Manufacturer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Company, Supplier][SensorsManufactured],
			Description -> "The company that originally manufactured this model of sensor.",
			Category -> "Inventory"
		},
		SupportedInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument][AssociatedAccessories,1],
			Description -> "A list of instruments for which this model is an accompanying accessory.",
			Category -> "Inventory"
		},
		SupportedContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation ->  Alternatives[
				Model[Container][AssociatedAccessories,1]
			],
			Description -> "A list of containers for which this model of sensor acts as a replacement part or an accompanying accessory.",
			Category -> "Inventory"
		},

		(* --- Quality Assurance --- *)
		ReceivingBatchInformation -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FieldP[Object[Report, Certificate, Calibration], Output->Short],
			Description -> "A list of the required fields populated by receiving.",
			Category -> "Quality Assurance"
		},

		(* --- Storage --- *)
		Expires -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if sensors of this model type expire over time.",
			Category -> "Storage Information",
			Abstract -> True
		},
		ShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after creation that sensors of this model type are recommended for use before it should be discarded.",
			Category -> "Storage Information",
			Abstract -> True
		},
		UnsealedShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after DateUnsealed that sensors of this model type are recommended for use before it should be discarded.",
			Category -> "Storage Information",
			Abstract -> True
		},
		DefaultStorageCondition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The condition in which sensors of this model are stored when not in use by an experiment; this condition may be overridden by the specific storage condition of any given sensor.",
			Category -> "Storage Information"
		},
		StoragePositions->{
			Format -> Multiple,
			Class -> {Link, String},
			Pattern :> {_Link, LocationPositionP},
			Relation -> {Object[Container]|Object[Instrument], Null},
			Description -> "The specific containers and positions in which this container is to be stored, allowing more granular organization within storage locations for this part's default storage condition.",
			Category -> "Storage Information",
			Headers->{"Storage Container", "Storage Position"},
			Developer -> True
		},
		StorageOrientation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> StorageOrientationP,
			Description -> "Indicates how the object is situated while in storage. Upright indicates that the footprint dimension of the stored object is Width x Depth, Side indicates Depth x Height, Face indicates Width x Height, and Null indicates that there is no preferred orientation during storage.",
			Category -> "Storage Information",
			Developer->True
		},
		StorageOrientationImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A file containing an image of showing the designated orientation of this object in storage as defined by the StorageOrientation.",
			Category -> "Storage Information",
			Developer->True
		},
		Fragile -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if objects of this model are likely to be damaged if they are stored in a homogeneous pile. Fragile objects are stored by themselves or in positions for which the objects are unlikely to contact each other.",
			Category -> "Storage Information",
			Developer->True
		},
		(* --- Resources --- *)
		RequestedResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Resource, Sample][RequestedModels],
			Description -> "The list of resource requests for this model sensor that have not yet been Fulfilled.",
			Category -> "Resources",
			Developer -> True
		},
		(* --- Migration Support --- *)
		LegacyID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The SLL2 ID for this Object, if it was migrated from the old data store.",
			Category -> "Migration Support",
			Developer -> True
		}
	}
}];
