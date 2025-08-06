(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Model[Item], {
	Description->"Model information for a subsidiary object used to support the daily running of experiment and the laboratory.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the Item model.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Deprecated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this item model is historical and no longer used in the lab.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Authors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The person who created this item model.",
			Category -> "Organizational Information"
		},
		Synonyms -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "List of possible alternative names this model goes by.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		UNII -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Unique Ingredient Identifier of compounds based on the unified identification scheme of FDA.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},

		(* --- Quality Assurance --- *)
		ReceivingBatchInformation -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FieldP[{Object[Report,Certificate,Analysis],Object[Report, Certificate, Calibration]},Output->Short],
			Description -> "A list of the required fields populated by receiving.",
			Category -> "Quality Assurance"
		},

		(*--- Item Specifications ---*)
		ImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A photo of this model of container.",
			Category -> "Item Specifications"
		},
		ImageFileScale -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0 Pixel)/(Centi Meter)],
			Units -> (Pixel / (Centi Meter)),
			Description -> "The scale relating pixels of ImageFile to real world distance.",
			Category -> "Item Specifications"
		},
		Schematics -> {
			Format -> Multiple,
			Class -> {Link,String},
			Pattern :> {_Link,_String},
			Relation -> {Object[EmeraldCloudFile],Null},
			Description -> "Detailed drawings of the item that explain its capabilities and limitations.",
			Category -> "Item Specifications",
			Headers -> {"Schematic","Caption"}
		},
		SupportedContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation ->  Alternatives[
				Model[Container][AssociatedAccessories,1]
			],
			Description -> "A list of containers for which this model of item acts as a replacement part or an accompanying accessory.",
			Category -> "Item Specifications"
		},
		SupportedInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation ->  Alternatives[
				Model[Instrument][AssociatedAccessories,1],
				Model[Instrument][ReplacementParts]
			],
			Description -> "A list of instruments for which this model is replacement part or an accompanying accessory.",
			Category -> "Item Specifications"
		},

		(* --- Operating Limits --- *)
		MaxNumberOfHours -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hour],
			Units -> Hour,
			Description -> "The amount of time this item can be used during experiments before performance is expected to degrade and the item should be replaced.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxNumberOfUses -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The maximum number of uses for which this item is expected to perform before performance is expected to degrade and the item should be replaced.",
			Category -> "Operating Limits"
		},

		(* --- Dimensions & Positions --- *)
		Dimensions -> {
			Format -> Single,
			Class -> {Real, Real, Real},
			Pattern :> {GreaterEqualP[0*Meter],GreaterEqualP[0*Meter],GreaterEqualP[0*Meter]},
			Units ->{Meter,Meter,Meter},
			Description -> "The external dimensions of this model of item, in its packaged form if it has one.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Depth)","Z Direction (Height)"}
		},
		Footprint -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FootprintP,
			Description -> "Standard form factor of the exterior bottom portion of this model of item used to seat the item in an open position.",
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
		MaterialDimensions -> {
			Format -> Single,
			Class -> {Real, Real},
			Pattern :> {GreaterEqualP[0*Meter],GreaterEqualP[0*Meter]},
			Units ->{Meter,Meter},
			Description -> "The actual dimensions of this material in it's unpackaged form.",
			Category -> "Dimensions & Positions",
			Headers -> {"X Direction (Width)","Y Direction (Length)"}
		},
		CuttableWidth -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this items length can but cut lengthwise, decreasing the width of the item.",
			Category -> "Dimensions & Positions"
		},
		CuttableLength -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this items length can but cut crosswise, decreasing the length of the item.",
			Category -> "Dimensions & Positions"
		},

		(* ---Physical Properties ---*)
		Density -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[(0*Gram)/Liter Milli],
			Units -> Gram/(Liter Milli),
			Description -> "Known density of items of this model at room temperature.",
			Category -> "Physical Properties",
			Abstract -> False
		},
		ExtinctionCoefficients -> {
			Format -> Multiple,
			Class -> {Wavelength->VariableUnit, ExtinctionCoefficient->VariableUnit},
			Pattern :> {Wavelength->GreaterP[0*Nanometer], ExtinctionCoefficient->(GreaterP[0 Liter/(Centimeter*Mole)] | GreaterP[0 Milli Liter /(Milli Gram * Centimeter)])},
			Description -> "A measure of how strongly this chemical absorbs light at a particular wavelength.",
			Category -> "Physical Properties"
		},
		pH -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[0,14],
			Units -> None,
			Description -> "The logarithmic concentration of hydrogen ions of the substance at room temperature.",
			Category -> "Physical Properties",
			Abstract -> False
		},
		State -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ModelStateP,
			Description -> "The physical state of the item when well solvated at room temperature and pressure.",
			Category -> "Physical Properties"
		},
		Reusable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the item is designed for multiple uses or if it is discarded after a single use. Reusable items may require cleaning and if so they are hand washed or dishwashed after each use.",
			Category -> "Physical Properties"
		},

		(* --- Item History ---*)
		Protocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol][SamplesIn],
			Description -> "All protocols that used this item at any point during their execution in the lab.",
			Category -> "Item History"
		},

		(* --- Storage & Handling --- *)
		DefaultStorageCondition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The condition in which items of this model are stored when not in use by an experiment; this condition may be overridden by the specific storage condition of any given item.",
			Category -> "Storage & Handling"
		},
		StoragePositions->{
			Format -> Multiple,
			Class -> {Link, String},
			Pattern :> {_Link, LocationPositionP},
			Relation -> {Object[Container]|Object[Instrument], Null},
			Description -> "The specific containers and positions in which items of this model are stored, allowing more granular organization within storage locations for this model's storage condition.",
			Category -> "Storage & Handling",
			Headers->{"Storage Container", "Storage Position"},
			Developer -> True
		},
		Fragile -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if objects of this model are likely to be damaged if they are stored in a homogeneous pile. Fragile objects are stored by themselves or in positions for which the objects are unlikely to contact each other.",
			Category -> "Storage & Handling",
			Developer->True
		},
		StorageOrientation -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> StorageOrientationP,
			Description -> "Indicates how the object is situated while in storage. Upright indicates that the footprint dimension of the stored object is Width x Depth, Side indicates Depth x Height, Face indicates Width x Height, and Null indicates that there is no preferred orientation during storage.",
			Category -> "Storage & Handling",
			Developer->True
		},
		StorageOrientationImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A file containing an image of showing the designated orientation of this object in storage as defined by the StorageOrientation.",
			Category -> "Storage & Handling",
			Developer->True
		},
		Expires -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if items of this model expire after a given amount of time.",
			Category -> "Storage & Handling",
			Abstract -> True
		},
		ShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after DateCreated that items of this model are recommended for use before they should be discarded.",
			Category -> "Storage & Handling",
			Abstract -> True
		},
		UnsealedShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after DateUnsealed that items of this model are recommended for use before they should be discarded.",
			Category -> "Storage & Handling",
			Abstract -> True
		},
		LightSensitive -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Determines if the item reacts or degrades in the presence of light and should be stored in the dark to avoid exposure.",
			Category -> "Storage & Handling"
		},
		FluidTransport -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this item is stored in a storage buffer and will be wet when retrieved from storage.",
			Category -> "Storage & Handling"
		},
		TransportTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "The temperature that items of this model should be incubated at while transported between instruments during experimentation.",
			Category -> "Storage & Handling"
		},
		AsepticTransportContainerType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AsepticTransportContainerTypeP,
			Description -> "Indicates how items of this model are contained in an aseptic barrier and if they need to be unbagged before being used in a protocol, maintenance, or qualification.",
			Category -> "Storage & Handling"
		},
		CleaningMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CleaningMethodP,
			Description -> "Indicates the type of cleaning that is employed for this part before reuse.",
			Category -> "Storage & Handling"
		},
		PreferredWashBin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation ->Model[Container,WashBin],
			Description -> "Indicates the recommended bin for dishwashing this container.",
			Category -> "Storage & Handling"
		},

		(* --- Plumbing Information --- *)
		Connectors -> {
			Format -> Multiple,
			Class -> {String, Expression, Expression, Real, Real, Expression},
			Pattern :> {ConnectorNameP, ConnectorP, ThreadP|None, GreaterP[0 Inch], GreaterP[0 Inch], ConnectorGenderP|None},
			Units -> {None, None, None, Inch, Inch, None},
			Description -> "Specifications for the ends of this plumbing component that may connect to other plumbing components or instrument ports.",
			Category -> "Plumbing Information",
			Headers -> {"Connector Name","Connector Type", "Thread Type", "Inner Diameter", "Outer Diameter","Gender"}
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
			Description -> "The fluid volume that can be contained in this item component when used as part of the plumbing.",
			Category ->"Plumbing Information"
		},
		FluidCategory-> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FluidCategoryP,
			Description -> "Type of fluids that can be used with this item component when used as part of the plumbing.",
			Category ->"Plumbing Information",
			Abstract->True
		},
		Size -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter],
			Units -> Meter,
			Description -> "The length of this item, in the direction of fluid flow.",
			Category -> "Plumbing Information"
		},

		(* --- Wiring Information --- *)
		WiringConnectors -> {
			Format -> Multiple,
			Class -> {String, Expression, Expression},
			Pattern :> {WiringConnectorNameP, WiringConnectorP, ConnectorGenderP|None},
			Headers -> {"Wiring Connector Name", "Wiring Connector Type", "Gender"},
			Description -> "Specifications for the ends of the wiring connectors on this Item model that may plug into and conductively connect to other items, parts or instruments.",
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
		WiringLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Centimeter],
			Units -> Centimeter,
			Description -> "The length of this item, in the direction of the electricity flow.",
			Category -> "Wiring Information"
		},

		(* --- Inventory --- *)
		Counted -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if instances of this item have a count which must be decremented each time the item is used.",
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
		ProductDocumentationFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "PDFs of any product documentation provided by the supplier of this item model.",
			Category -> "Inventory"
		},
		Preparable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if items of this model may be prepared as needed during the course of an experiment.",
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
		ServiceProviders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Company, Service][CustomSynthesizes],
			Description -> "Service companies that provide synthesis of this model as a service.",
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
		DefaultStickerModel -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Sticker],
			Description -> "The type of sticker applied to items of this model when they are stickered upon receiving.",
			Category -> "Inventory",
			Developer->True
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
		RentByDefault->{
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this item should be 'rented' from the ECL rather than purchased when it is needed during the course of an experiment.",
			Category -> "Inventory"
		},

		(* --- Health & Safety --- *)
		Sterile -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this model of item arrives free of microbial contamination from the manufacturer or is sterilized upon receiving.",
			Category -> "Health & Safety"
		},
		Sterilized -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this model of item is sterilized by autoclaving upon receiving and, if it is reusable, after being cleaned before it is reused.",
			Category -> "Health & Safety"
		},
		SterilizationBag -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this model of item is sealed in an autoclave bag before autoclaving. The bag protects its sterility until it is used.",
			Category -> "Health & Safety"
		},
		NucleaseFree -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this model of item is tested to be not contaminated with DNase and RNase by the manufacturer.",
			Category -> "Health & Safety"
		},
		NucleicAcidFree -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this model of item is tested to be not contaminated with DNA and RNA by the manufacturer.",
			Category -> "Health & Safety"
		},
		PyrogenFree -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this model of item is tested to be not contaminated with endotoxin by the manufacturer.",
			Category -> "Health & Safety"
		},
		Radioactive -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if items of this model emit substantial ionizing radiation.",
			Category -> "Health & Safety"
		},
		Ventilated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if items of this model must be handled in a ventilated enclosures.",
			Category -> "Health & Safety"
		},
		Flammable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if items of this model are easily set aflame under standard conditions.",
			Category -> "Health & Safety"
		},
		Acid -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if items of this model are strong acids (pH <= 2) and require dedicated secondary containment during storage.",
			Category -> "Health & Safety"
		},
		Base -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if items of this model are strong bases (pH >= 12) and require dedicated secondary containment during storage.",
			Category -> "Health & Safety"
		},
		Pyrophoric -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if items of this model can ignite spontaneously upon exposure to air.",
			Category -> "Health & Safety"
		},
		WaterReactive -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if items of this model react spontaneously upon exposure to water.",
			Category -> "Health & Safety"
		},
		Fuming -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if items of this model emit fumes spontaneously when exposed to air.",
			Category -> "Health & Safety"
		},
		Aqueous -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if items of this model are a solution in water.",
			Category -> "Health & Safety"
		},
		HazardousBan -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if items of this model are currently banned from usage in the ECL because the facility isn't yet equiped to handle them.",
			Category -> "Health & Safety"
		},
		ExpirationHazard -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if items of this model become hazardous once they are expired and therefore must be automatically disposed of when they pass their expiration date.",
			Category -> "Health & Safety"
		},
		ParticularlyHazardousSubstance -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if exposure to this substance has the potential to cause serious and lasting harm. A substance is considered particularly harmful if it is categorized by any of the following GHS classifications (as found on a MSDS): Reproductive Toxicity (H340, H360, H362),  Acute Toxicity (H300, H310, H330, H370, H373), Carcinogenicity (H350).",
			Category -> "Health & Safety"
		},
		DrainDisposal -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if items of this model may be safely disposed down a standard drain.",
			Category -> "Health & Safety"
		},
		MSDSRequired -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if an MSDS is applicable for this model.",
			Category -> "Health & Safety"
		},
		MSDSFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "PDF of the models MSDS (Materials Saftey Data Sheet).",
			Category -> "Health & Safety"
		},
		NFPA -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> NFPAP,
			Description -> "The National Fire Protection Association (NFPA) 704 hazard diamond classification for the substance.",
			Category -> "Health & Safety"
		},
		DOTHazardClass -> {
			Format -> Single,
			Class -> String,
			Pattern :> DOTHazardClassP,
			Description -> "The Department of Transportation hazard classification of the substance.",
			Category -> "Health & Safety"
		},
		BiosafetyLevel -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BiosafetyLevelP,
			Description -> "The Biosafety classification of the substance.",
			Category -> "Health & Safety"
		},

		(* --- Compatibility --- *)
		PreferredCamera -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CameraCategoryP,
			Description -> "Indicates the recommended camera type for taking an image of an object of this model.",
			Category -> "Compatibility"
		},
		IncompatibleMaterials -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP|None,
			Description -> "A list of materials that would be damaged if wetted by this model.",
			Category -> "Compatibility"
		},
		WettedMaterials -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Category -> "Compatibility",
			Description -> "The materials of which this part is made that may come in direct contact with fluids."
		},
		LiquidHandlerIncompatible -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this item cannot be reliably aspirated or dispensed on an automated liquid handling robot.",
			Category -> "Compatibility"
		},
		EngineDefault -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this model has been validated for use with TransferDevices.",
			Category -> "Compatibility",
			Developer -> True
		},

		(* --- Qualifications & Maintenance --- *)
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
		ContinuousOperation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the item is required to operate continuously in the lab, regardless of if it is InUse by a specific protocol.",
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
