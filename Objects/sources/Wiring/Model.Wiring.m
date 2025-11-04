(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Wiring], {
	Description->"Model information for a component used to direct the flow of electricity throughout the laboratory.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
	
		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the wiring component model.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		
		Deprecated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this model is historical and no longer used in the lab.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		
		Authors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The person who created this model.",
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

		(* --- Wiring Information --- *)
		WiringLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Centimeter],
			Units -> Centimeter,
			Description -> "The length of this wiring component, in the direction of electricity flow.",
			Category -> "Wiring Information"
		},
		
		WiringConnectors -> {
			Format -> Multiple,
			Class -> {String, Expression, Expression},
			Pattern :> {WiringConnectorNameP, WiringConnectorP, ConnectorGenderP|None},
			Headers -> {"Wiring Connector Name", "Wiring Connector Type", "Gender"},
			Description -> "Specifications for the wiring ends of this wiring component that may plug into and conductively connect to other wiring components, items, parts or instruments.",
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
		
		ImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A photo of this model of wiring component.",
			Category -> "Wiring Information"
		},

		Icon -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A simplified image used to represent this wiring component.",
			Category -> "Wiring Information"
		},
		
		ProductDocumentationFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "PDFs of any product documentation provided by the supplier of this model wiring component.",
			Category -> "Inventory"
		},

		(* --- Dimensions & Positions --- *)

		Dimensions -> {
			Format -> Single,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterEqualP[0*Meter],GreaterEqualP[0*Meter],GreaterEqualP[0*Meter]},
			Units ->{Meter,Meter,Meter},
			Description -> "The external dimensions of this model of wiring as it arrives from the manufacturer.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		},

		Footprint -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FootprintP,
			Description -> "Standard form factor of the exterior bottom portion of this model of wiring used to seat the wiring in an open position.",
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

		(* --- Operating Limits --- *)
		MaxVoltage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> VoltageP,
			Units -> Volt,
			Description -> "Maximum (positive) voltage that can be tolerated by this wiring component without damage or safety concerns.",
			Category -> "Operating Limits"
		},
		
		MaxCurrent-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Ampere],
			Units -> Ampere,
			Description -> "Maximum current that can be tolerated by this wiring component without damage or safety concerns.",
			Category -> "Operating Limits"
		},
		
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature this wiring component can be exposed to and maintain structural and functional integrity.",
			Category -> "Operating Limits"
		},
		
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature this wiring component can be exposed to and maintain structural and functional integrity.",
			Category -> "Operating Limits"
		},
		
		MaxNumberOfHours -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hour],
			Units -> Hour,
			Description -> "The amount of time this wiring component can be used during experiments before performance is expected to degrade and this component should be replaced.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		
		MaxNumberOfUses -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The maximum number of uses for which this wiring component is expected to perform before performance is expected to degrade and the this component should be replaced.",
			Category -> "Operating Limits"
		},

		(* --- Inventory --- *)
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
		Products -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][ProductModel],
			Description -> "Products ordering information for this wiring component.",
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
		SupportedContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation ->  Alternatives[
				Model[Container][AssociatedAccessories,1]
			],
			Description -> "A list of containers for which this model of wiring object acts as a replacement part or an accompanying accessory.",
			Category -> "Inventory"
		},
		StickerPositionImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of this model that indicates the correct position for affixing barcode stickers.",
			Category -> "Inventory",
			Developer->True
		},

		(* --- Storage --- *)
		Expires -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if wiring components of this model type expire over time.",
			Category -> "Storage Information",
			Abstract -> True
		},
		
		ShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after receipt that wiring components of this model type are recommended for use before being discarded.",
			Category -> "Storage Information",
			Abstract -> True
		},
		
		UnsealedShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after DateUnsealed that wiring components of this model are recommended for use before being discarded.",
			Category -> "Storage Information",
			Abstract -> True
		},
		
		DefaultStorageCondition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The condition in which wiring components of this model are stored when not in use by an experiment; this condition may be overridden by the specific storage condition of any given wiring component.",
			Category -> "Storage Information"
		},

		StoragePositions->{
			Format -> Multiple,
			Class -> {Link, String},
			Pattern :> {_Link, LocationPositionP},
			Relation -> {Object[Container]|Object[Instrument], Null},
			Description -> "The specific containers and positions in which this container is to be stored, allowing more granular organization within storage locations for this wiring's default storage condition.",
			Category -> "Storage Information",
			Headers->{"Storage Container", "Storage Position"},
			Developer -> True
		},

		AsepticTransportContainerType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AsepticTransportContainerTypeP,
			Description -> "Indicates how wiring components of this model are contained in an aseptic barrier and if they need to be unbagged before being used in a protocol, maintenance, or qualification.",
			Category -> "Storage Information"
		},
		
		SupportedInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation ->  Alternatives[
				Model[Instrument][ReplacementParts],
				Model[Instrument][AssociatedAccessories,1]
			],
			Description -> "A list of instruments for which this model is replacement part or an accompanying accessory.",
			Category -> "Qualifications & Maintenance"
		},

		(* --- Resources --- *)
		RequestedResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Resource, Sample][RequestedModels],
			Description -> "The list of resource requests for this model wiring that have not yet been Fulfilled.",
			Category -> "Resources",
			Developer -> True
		},
		
		(* --- Qualifications & Maintenance --- *)
		CleaningMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CleaningMethodP,
			Description -> "Indicates the type of cleaning that is employed for this wiring component before reuse.",
			Category -> "Qualifications & Maintenance"
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
