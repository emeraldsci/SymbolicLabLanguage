(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Part], {
	Description->"Model information for an interchangeable part used in the maintenance of laboratory equipment or facilities.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the modelPart.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Deprecated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this modelPart is historical and no longer used in the lab.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Authors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The person who created this part model.",
			Category -> "Organizational Information"
		},
		ImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An example photo of this model of part.",
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
		Schematics -> {
			Format -> Multiple,
			Class -> {Link,String},
			Pattern :> {_Link,_String},
			Relation -> {Object[EmeraldCloudFile],Null},
			Description -> "Detailed drawings of the part that explain its capabilities and limitations.",
			Category -> "Part Specifications",
			Headers -> {"Schematic","Caption"}
		},

		(* --- Quality Assurance --- *)
		ReceivingBatchInformation -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FieldP[{Object[Report,Certificate,Analysis],Object[Report, Certificate, Calibration]},Output->Short],
			Description -> "A list of the required fields populated by receiving.",
			Category -> "Quality Assurance"
		},

		(* --- Storage --- *)
		Expires -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if parts of this model type expire over time.",
			Category -> "Storage Information",
			Abstract -> True
		},
		ShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after creation that parts of this model type are recommended for use before it should be discarded.",
			Category -> "Storage Information",
			Abstract -> True
		},
		UnsealedShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after DateUnsealed that parts of this model type are recommended for use before it should be discarded.",
			Category -> "Storage Information",
			Abstract -> True
		},
		DefaultStorageCondition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The condition in which parts of this model are stored when not in use by an experiment; this condition may be overridden by the specific storage condition of any given part.",
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
		AsepticTransportContainerType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AsepticTransportContainerTypeP,
			Description -> "Indicates how parts of this model are contained in an aseptic barrier and if they need to be unbagged before being used in a protocol, maintenance, or qualification.",
			Category -> "Storage Information"
		},
		
		(* --- Plumbing Information --- *)
		Connectors -> {
			Format -> Multiple,
			Class -> {String, Expression, Expression, Real, Real, Expression},
			Pattern :> {ConnectorNameP, ConnectorP, ThreadP|GroundGlassJointSizeP|None, GreaterP[0 Inch], GreaterP[0 Inch], ConnectorGenderP|None},
			Units -> {None, None, None, Inch, Inch, None},
			Description -> "Specifications for the ends of this part (if the part itself is a plumbing component), or the ports on this part, which may connect to other plumbing components or instrument ports.",
			Category -> "Plumbing Information",
			Headers -> {"Connector Name","Connector Type", "Thread Type", "Inner Diameter", "Outer Diameter","Gender"}
		},
		Size -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter],
			Units -> Meter,
			Description -> "The length of this part, in the direction of fluid flow.",
			Category -> "Plumbing Information"
		},

		(* --- Wiring Information --- *)
		WiringConnectors -> {
			Format -> Multiple,
			Class -> {String, Expression, Expression},
			Pattern :> {WiringConnectorNameP, WiringConnectorP, ConnectorGenderP|None},
			Headers -> {"Wiring Connector Name", "Wiring Connector Type", "Gender"},
			Description -> "Specifications for the ends of the wiring connectors on this Part model that may plug into and conductively connect to other wiring components or instrument wiring connectors.",
			Category -> "Wiring Information"
		},
		WiringLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Centimeter],
			Units -> Centimeter,
			Description -> "The length of this part, in the direction of electricity flow.",
			Category -> "Wiring Information"
		},
		WiringDiameters -> {
			Format -> Multiple,
			Class -> Real,
			Pattern :> GreaterP[0 Millimeter],
			Units -> Millimeter,
			Description -> "For each member of WiringConnectors, its effective conductive diameter.",
			Category -> "Wiring Information",
			IndexMatching -> WiringConnectors
		},
		
		(* --- Inventory --- *)
		ProductDocumentationFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "PDFs of any product documentation provided by the supplier of this modelPart.",
			Category -> "Inventory"
		},
		Products -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][ProductModel],
			Description -> "Products ordering information for this model of part.",
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
		PreferredWashBin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation ->Model[Container,WashBin],
			Description -> "Indicates the recommended bin for dishwashing this container.",
			Category -> "Compatibility"
		},
		(* --- Compatibility --- *)
		WettedMaterials -> {
		    Format -> Multiple,
		    Class -> Expression,
		    Pattern :> MaterialP,
			Category -> "Compatibility",
		    Description -> "The materials of which this part is made that may come in direct contact with fluids."
		},

		(* --- Dimensions & Positions --- *)

		Dimensions -> {
			Format -> Single,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterEqualP[0*Meter],GreaterEqualP[0*Meter],GreaterEqualP[0*Meter]},
			Units ->{Meter,Meter,Meter},
			Description -> "The external dimensions of this model of container.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		},

		Footprint -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FootprintP,
			Description -> "Standard form factor of the exterior bottom portion of this model of part used to seat the part in an open position.",
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
		Fragile -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if objects of this model are likely to be damaged if they are stored in a homogeneous pile. Fragile objects are stored by themselves or in positions for which the objects are unlikely to contact each other.",
			Category -> "Inventory",
			Developer->True
		},
		StorageOrientation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> StorageOrientationP,
			Description -> "Indicates how the object is situated while in storage. Upright indicates that the footprint dimension of the stored object is Width x Depth, Side indicates Depth x Height, Face indicates Width x Height, and Null indicates that there is no preferred orientation during storage.",
			Category -> "Inventory",
			Developer->True
		},
		StorageOrientationImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A file containing an image of showing the designated orientation of this object in storage as defined by the StorageOrientation.",
			Category -> "Inventory",
			Developer->True
		},

		(* --- Qualifications & Maintenance --- *)
		MaintenanceFrequency -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterP[0*Day]},
			Relation -> {Model[Maintenance][Targets], Null},
			Units -> {None, Day},
			Description -> "A list of the maintenance models for this part model and their required frequencies.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Maintenance Model", "Frequency"}
		},
		QualificationFrequency -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterP[0*Day]},
			Relation -> {Model[Qualification][Targets], Null},
			Units -> {None, Day},
			Description -> "A list of the Qualification models for this part model and their required frequencies.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Qualification Model", "Frequency"}
		},
		SupportedInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation ->  Alternatives[
				Model[Instrument][ReplacementParts], (*only for Model[Part]*)
				Model[Instrument][AssociatedAccessories,1]
			],
			Description -> "A list of instruments for which this model is replacement part or an accompanying accessory.",
			Category -> "Qualifications & Maintenance"
		},
		SupportedContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation ->  Alternatives[
				Model[Container][AssociatedAccessories,1]
			],
			Description -> "A list of containers for which this model of part acts as a replacement part or an accompanying accessory.",
			Category -> "Qualifications & Maintenance"
		},

		CleaningMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CleaningMethodP,
			Description -> "Indicates the type of cleaning that is employed for this part before reuse.",
			Category -> "Qualifications & Maintenance"
		},
		ContinuousOperation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the part is required to operate continuously in the lab, regardless of if it is InUse by a specific protocol.",
			Category-> "Qualifications & Maintenance"
		},
		(* --- Resources --- *)
		RequestedResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Resource, Sample][RequestedModels],
			Description -> "The list of resource requests for this model part that have not yet been Fulfilled.",
			Category -> "Resources",
			Developer -> True
		},
		(* --- Operating Limits --- *)
		MaxNumberOfHours -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hour],
			Units -> Hour,
			Description -> "The amount of time this part can be used during experiments before performance is expected to degrade and the part should be replaced.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxNumberOfUses -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The maximum number of uses for which this part is expected to perform before performance is expected to degrade and the part should be replaced.",
			Category -> "Operating Limits"
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
		(* --- Sample Preparation --- *)
		Preparable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this samples/items of this model maybe prepared as needed during the course of an experiment.",
			Category -> "Sample Preparation"
		}
	}
}];
