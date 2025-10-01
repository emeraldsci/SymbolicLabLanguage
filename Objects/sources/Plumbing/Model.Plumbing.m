(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Plumbing], {
	Description->"Model information for a component used to direct the flow of liquids or gases throughout the laboratory.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the plumbing component model.",
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

		(* --- Plumbing Information --- *)
		Size -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter],
			Units -> Meter,
			Description -> "The length of this plumbing component, in the direction of fluid flow.",
			Category -> "Plumbing Information"
		},

		WettedMaterials -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Category -> "Plumbing Information",
			Description -> "The materials of which this plumbing component is made that come in direct contact with the samples.",
			Abstract->True
		},
		InnerDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Inch],
			Units -> Inch,
			Description -> "The diameter of the hollow, fluid-containing portion of this plumbing component.",
			Category -> "Plumbing Information",
			Abstract->True
		},
		OuterDiameter -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Inch],
			Units -> Inch,
			Description -> "The diameter of the entire plumbing component, orthogonal to the flow of fluid.",
			Category -> "Plumbing Information",
			Abstract->True
		},
		Connectors -> {
			Format -> Multiple,
			Class -> {String, Expression, Expression, Real, Real, Expression},
			Pattern :> {ConnectorNameP, ConnectorP, ThreadP|GroundGlassJointSizeP|None, GreaterP[0 Inch], GreaterP[0 Inch], ConnectorGenderP|None},
			Units -> {None, None, None, Inch, Inch, None},
			Description -> "Specifications for the ends of this plumbing component that may connect to other plumbing components or instrument ports.",
			Headers -> {"Connector Name", "Connector Type","Thread Type","Inner Diameter","Outer Diameter","Gender"},
			Category -> "Plumbing Information"
		},
		ConnectorGrips -> {
			Format -> Multiple,
			Class -> {String, Expression, Real, Real, Real},
			Pattern :> {ConnectorNameP, ConnectorGripTypeP, GreaterP[0 Inch], GreaterEqualP[0 Newton*Meter], GreaterP[0 Newton*Meter]},
			Units -> {None, None, Inch, Newton*Meter, Newton*Meter},
			Description -> "For each member of Connectors, specifications for a region on this item that may be used in concert with tools or fingers to assist in establishing a Connection to the Connector. Connector Name denotes the Connector to which a grip corresponds. Grip Type indicates the form the grip takes. Options include Flats or Knurled. Flats are parallel faces on the body of an object designed interface with the mouth of a wrench. Knurled denotes that a pattern is etched into the body of an object to increase roughness. Grip Size is the distance across flats or the diameter of the grip. Min torque is the lower bound energetic work required to make a leak-proof seal via rotational force. Max torque is the upper bound after which the fitting may be irreparably distorted or damaged.",
			Category -> "Plumbing Information",
			Headers -> {"Connector Name", "Grip Type", "Grip Size", "Min Torque", "Max Torque"},
			IndexMatching -> Connectors
		},
		DeadVolume-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Milli Liter],
			Units -> Milli Liter,
			Description -> "The fluid volume that can be contained in this plumbing component.",
			Category ->"Plumbing Information"
		},
		FluidCategory-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FluidCategoryP,
			Description -> "Type of fluids that can be used with this plumbing component.",
			Category ->"Plumbing Information",
			Abstract->True
		},
		ImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A photo of this model of plumbing component.",
			Category -> "Plumbing Information"
		},
		Icon -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A simplified image used to represent this plumbing component.",
			Category -> "Plumbing Information"
		},
		ProductDocumentationFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "PDFs of any product documentation provided by the supplier of this model plumbing.",
			Category -> "Inventory"
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
		
		(* --- Operating Limits --- *)
		MinPressure -> {
			Format -> Single,
			Class -> Real,
			Pattern :> PressureP,
			Units -> PSI,
			Description -> "Minimum pressure that can be tolerated by this plumbing component without deformation.",
			Category -> "Operating Limits"
		},
		MaxPressure-> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*PSI],
			Units -> PSI,
			Description -> "Maximum pressure that can be applied to this plumbing component.",
			Category -> "Operating Limits"
		},
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature this plumbing component can be exposed to and maintain structural integrity.",
			Category -> "Operating Limits"
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature this plumbing component can be exposed to and maintain structural integrity.",
			Category -> "Operating Limits"
		},
		MaxNumberOfHours -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hour],
			Units -> Hour,
			Description -> "The amount of time this plumbing can be used during experiments before performance is expected to degrade and the plumbing should be replaced.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxNumberOfUses -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The maximum number of uses for which this plumbing is expected to perform before performance is expected to degrade and the plumbing should be replaced.",
			Category -> "Operating Limits"
		},

		Products -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][ProductModel],
			Description -> "Products ordering information for this plumbing component.",
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

		(* --- Dimensions & Positions --- *)

		Dimensions -> {
			Format -> Single,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterEqualP[0*Meter],GreaterEqualP[0*Meter],GreaterEqualP[0*Meter]},
			Units ->{Meter,Meter,Meter},
			Description -> "The external dimensions of this model of this plumbing as it arrives from the manufacturer.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		},
		Footprint -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FootprintP,
			Description -> "Standard form factor of the exterior bottom portion of this model of container used to seat the plumbing in an open position.",
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

		(* --- Storage --- *)
		Expires -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if plumbing components of this model type expire over time.",
			Category -> "Storage Information",
			Abstract -> True
		},
		ShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after receipt that plumbing components of this model type are recommended for use before being discarded.",
			Category -> "Storage Information",
			Abstract -> True
		},
		UnsealedShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after DateUnsealed that plumbing components of this model are recommended for use before being discarded.",
			Category -> "Storage Information",
			Abstract -> True
		},
		DefaultStorageCondition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The condition in which plumbing components of this model are stored when not in use by an experiment; this condition may be overridden by the specific storage condition of any given plumbing component.",
			Category -> "Storage Information"
		},
		StoragePositions->{
			Format -> Multiple,
			Class -> {Link, String},
			Pattern :> {_Link, LocationPositionP},
			Relation -> {Object[Container]|Object[Instrument], Null},
			Description -> "The specific containers and positions in which this container is to be stored, allowing more granular organization within storage locations for this plumbing's default storage condition.",
			Category -> "Storage Information",
			Headers->{"Storage Container", "Storage Position"},
			Developer -> True
		},
		AsepticTransportContainerType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AsepticTransportContainerTypeP,
			Description -> "Indicates how plumbing components of this model are contained in an aseptic barrier and if they need to be unbagged before being used in a protocol, maintenance, or qualification.",
			Category -> "Storage Information"
		},
		PreferredWashBin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation ->Model[Container,WashBin],
			Description -> "Indicates the recommended bin for dishwashing this container.",
			Category -> "Compatibility"
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

		(* --- Resources --- *)
		RequestedResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Resource, Sample][RequestedModels],
			Description -> "The list of resource requests for this model plumbing that have not yet been Fulfilled.",
			Category -> "Resources",
			Developer -> True
		},
		(* --- Qualifications & Maintenance --- *)
		CleaningMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CleaningMethodP,
			Description -> "Indicates the type of cleaning that is employed for this plumbing component before reuse.",
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
