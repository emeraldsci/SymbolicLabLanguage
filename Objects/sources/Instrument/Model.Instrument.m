(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Instrument], {
	Description->"Model information for a piece of scientific instrumentation used to perform experiments on the ECL.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The manufacturers model name for the given instrument.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Deprecated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this instrument model is historical and no longer used in the lab.",
			Category -> "Organizational Information"
		},
		Authors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The person(s) who created this instrument model.",
			Category -> "Organizational Information"
		},
		ImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "An example photo of this model of instrument.",
			Category -> "Organizational Information"
		},
		UserManualFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Documents in PDF format, comprising product documentation for this instrument, most commonly that which is provided by the manufacturer.",
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
		AlternativeObjects -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument][AlternativeModel],
			Developer -> True,
			Description -> "Objects that represent instances of this model but are not contained in the Objects field. If two instruments are almost identical save for small differences, then the Model field of these two instruments will be shared (and thus the Objects field of the model will contain both of them). The AlternativeObjects field of the model, however, will be populated as well with those objects that are completely accurately described by the model if they are not already in the Objects field.",
			Category -> "Organizational Information"
		},
		USPCategorization -> {
			Format -> Single,
			Class -> {Expression, Expression},
			Pattern :> {USPCategorizationP, USPCategorizationJustificationP},
			Description -> "The USP Group, as outlined in USP 1058, with which this instrument is associated and the justification for that classification. Group A represents the least complex instruments that do not have measurement capability or require calibration. Group B represents instruments that may provide a measurement or an experimental condition that can affect measurement. Group C represents complex analytical instruments with a significant degree of computerization.",
			Headers -> {"USP Group", "Justification"},
			Category -> "Organizational Information",
			Developer -> True
		},

		(* --- Instrument Specifications --- *)
		InstrumentSchematics -> {
			Format -> Multiple,
			Class -> {Link,String},
			Pattern :> {_Link,_String},
			Relation -> {Object[EmeraldCloudFile],Null},
			Description -> "Detailed drawings of the instrument that explain its capabilities and limitations.",
			Category -> "Instrument Specifications",
			Headers -> {"Schematic","Caption"}
		},
		PowerType -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> PowerTypeP,
			Description -> "The type(s) of the power source(s) used by instruments of this model.",
			Category -> "Instrument Specifications"
		},
		BatteryRequirements -> {
			Format -> Multiple,
			Class -> {Integer, Expression},
			Pattern :> {GreaterP[0, 1], BatteryTypeP},
			Units -> {None, None},
			Description -> "All battery requirements for battery-powered instruments of this model.",
			Headers -> {"Number of Batteries","Battery Type"},
			Category -> "Instrument Specifications"
		},
		PowerConsumption -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Watt],
			Units -> Watt,
			Description -> "Estimated power consumption rate of the instrument in Watts (Joule/Second).",
			Category -> "Instrument Specifications"
		},
		Connector -> {
			Format -> Multiple,
			Class -> {Integer, Expression},
			Pattern :> {GreaterP[0, 1], DataConnectorP},
			Units -> {None, None},
			Description -> "All data connector requirements needed to interface the instruments of this model with a computer.",
			Headers -> {"Number of Connectors","Connector Type"},
			Category -> "Instrument Specifications"
		},
		OperatingSystem -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> OperatingSystemP,
			Description -> "Operating system that the software of instruments of this model runs on.",
			Category -> "Instrument Specifications"
		},
		CompatibleInstrumentSoftware -> {
			Format -> Multiple,
			Class -> {Expression, String},
			Pattern :> {InstrumentSoftwareP, _String},
			Description -> "The instrument-specific software that are supported for instruments of this model.",
			Category -> "Instrument Specifications",
			Headers -> {"Software Name", "Version Number"}
		},
		PCICard -> {
			Format -> Multiple,
			Class -> {Integer, Expression},
			Pattern :> {GreaterEqualP[0, 1], PCICardP},
			Units -> {None, None},
			Description -> "All PCICard requirements needed to install specialized hardware.",
			Headers -> {"Number of Cards","Card Type"},
			Category -> "Instrument Specifications"
		},
		Dongle -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if an instrument of this model requires a security dongle in the computer to run.",
			Category -> "Instrument Specifications"
		},
		AssociatedAccessories -> {
			Format -> Multiple,
			Class -> {Link, Integer},
			Pattern :> {_Link, GreaterP[0, 1]},
			Relation -> {Alternatives[
				Model[Instrument][SupportedInstruments],
				Model[Part][SupportedInstruments],
				Model[Container,PlateSealMagazine][SupportedInstruments],
				Model[Container,MagazineRack][SupportedInstruments],
				Model[Container,Rack][SupportedInstruments],
				Model[Sensor][SupportedInstruments],
				Model[Item][SupportedInstruments],
				Model[Plumbing][SupportedInstruments],
				Model[Wiring][SupportedInstruments],
				Model[Container,FiberSampleHolder][SupportedInstruments],
				Model[Container,Spacer][SupportedInstruments],
				Model[Container,GrindingContainer][SupportedInstruments],
				Model[Container,GrinderTubeHolder][SupportedInstruments]
				], Null},
			Units -> {None, None},
			Description -> "Items installed with the instrument for full function.",
			Headers -> {"Item","Quantity"},
			Category -> "Instrument Specifications"
		},
		PositionSelectable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if positions on this instrument are selected by the position selector window in software rather than by scanning position stickers.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		DefaultDataFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file path in $PublicPath to which instruments of this model directly export any generated data provided those instruments don't have DataFilePath populated.",
			Category -> "Instrument Specifications",
			Developer->True
		},
		DefaultMethodFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file path in $PublicPath from which instruments of this model directly import any methods used to run protocols provided those instruments don't have MethodFilePath populated.",
			Category -> "Instrument Specifications",
			Developer->True
		},
		DefaultProgramFilePath -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The file path from which instruments of this model directly run any methods used to run protocols provided those instruments don't have ProgramFilePath populated.",
			Category -> "Instrument Specifications",
			Developer->True
		},
		WasteType -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sample],
			Description -> "The type of waste generated by this instrument.",
			Category -> "Instrument Specifications"
		},
		IntegratedLiquidHandlers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument, LiquidHandler],
			Description -> "The liquid handlers that this instrument model is integrated with for continuous robotic operation between the liquid handler and integrated instrument.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		MovementLock -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the instrument has a locking position for movement around the facility or while in shipping.",
			Category -> "Instrument Specifications",
			Developer -> True
		},
		Weight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Kilo Gram],
			Units -> Kilo Gram,
			Description -> "The approximate weight of the instrument.",
			Category -> "Instrument Specifications"
		},
		UnderSoftwareDevelopment -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this model of instrument is in the process of being brought online.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		(*--- Pricing Information ---*)
		PricingRate -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*USD / Hour],
			Units -> USD / Hour,
			Description -> "The rate charged by the ECL for time used on this instrument in the course of conducting user experiments.",
			Category -> "Pricing Information",
			Developer -> True
		},
		PricingCategory -> {
			Format -> Single,
			Class -> String,
			Pattern :> PricingCategoryP,
			Description -> "The generic billing category this instrument model will be listed under.",
			Category -> "Pricing Information"
		},
		PricingLevel ->{
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Description -> "With respect to cost, the category of devices, for which this Instrument falls into.",
			Category -> "Pricing Information"
		},

		(* --- Compatibility --- *)
		PlugRequirements -> {
			Format -> Multiple,
			Class -> {
				PlugNumber->Integer,
				Phases->Integer,
				Voltage->Integer,
				Current->Real,
				PlugType->String
			},
			Pattern :> {
				PlugNumber->GreaterP[0, 1],
				Phases->GreaterP[0],
				Voltage->RangeP[100*Volt, 480*Volt],
				Current->GreaterP[0*Ampere],
				PlugType->NEMADesignationP
			},
			Units -> {
				PlugNumber -> None,
				Phases -> None,
				Voltage -> Volt,
				Current -> Ampere,
				PlugType -> None
			},
			Description -> "All electrical requirements for plug-in parts of this model.",
			Category -> "Compatibility",
			Headers -> {
				PlugNumber->"Number of Plugs",
				Phases->"Phases",
				Voltage->"Voltage",
				Current->"Current",
				PlugType->"Plug Type"
			}
		},
		AllowedPositions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Positions]}, Computables`Private`allowedPositions[Field[Positions]]],
			Pattern :> _Alternatives,
			Description -> "Generates a pattern of all the valid position names for this model of instrument.",
			Category -> "Compatibility"
		},
		WettedMaterials -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Description -> "A list of materials in the instrument which may be wetted by user-specified liquids.",
			Category -> "Compatibility"
		},
		FacilityRequirementFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "PDFs for facility requirements and pre-installation checkoff forms provided by the supplier for instruments of this model.",
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

		(* --- Dimensions & Positions --- *)
		Dimensions -> {
			Format -> Single,
			Class -> {Real,Real,Real},
			Pattern :> {GreaterP[0*Meter], GreaterP[0*Meter], GreaterP[0*Meter]},
			Units -> {Meter,Meter,Meter},
			Description -> "The external dimensions of this model of instrument.",
			Headers -> {"DimensionX","DimensionY","DimensionZ"},
			Category -> "Dimensions & Positions",
			Abstract -> True
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
		StickerPositionImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description ->  "An image of this model that indicates the correct position for affixing barcode stickers.",
			Category -> "Inventory",
			Developer->True
		},
		CrossSectionalShape -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Circle | Rectangle,
			Description -> "The shape of this model of instrument in the X-Y plane.",
			Category -> "Dimensions & Positions"
		},
		Footprint -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FootprintP,
			Description -> "Standard form factor of the exterior bottom portion of this model of instrument used to seat the container in a position.",
			Category -> "Dimensions & Positions"
		},
		ContainerImage2DFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A top-down (X-Y plane) image of this model of instrument which can be overlaid on a 2D container plot.",
			Category -> "Dimensions & Positions"
		},
		Shape2D -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Polygon | _Circle,
			Description -> "A Graphics primitive corresponding to the 2D shape of this model of instrument.",
			Category -> "Dimensions & Positions"
		},
		Shape3D -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> _Polygon|_MeshRegion,
			Description -> "A Graphics primitive corresponding to the 3D shape of this model of instrument.",
			Category -> "Dimensions & Positions"
		},
		Positions -> {
			Format -> Multiple,
			Class -> {Name->String,Footprint->Expression,MaxWidth->Real,MaxDepth->Real,MaxHeight->Real},
			Pattern :> {Name->LocationPositionP,Footprint->(FootprintP|Open),MaxWidth->GreaterP[0 Centimeter],MaxDepth->GreaterP[0 Centimeter],MaxHeight->GreaterP[0 Centimeter]},
			Units -> {Name->None,Footprint->None,MaxWidth->Meter,MaxDepth->Meter,MaxHeight->Meter},
			Description -> "Spatial definitions of the positions that exist in this model of instrument, where MaxWidth and MaxDepth are the x and y dimensions of the maximum size of object that will fit in this position. MaxHeight is defined as the maximum height of object that can fit in this position without either encountering a barrier or creating a functional impediment to an experiment procedure.",
			Headers->{Name->"Name of Position",Footprint->"Footprint",MaxWidth->"Max Width",MaxDepth->"Max Depth",MaxHeight->"Max Height"},
			Category -> "Dimensions & Positions"
		},
		PositionPlotting -> {
			Format -> Multiple,
			Class -> {Name->String,XOffset->Real,YOffset->Real,ZOffset->Real,CrossSectionalShape->Expression,Rotation->Real},
			Pattern :> {Name->LocationPositionP,XOffset->GreaterEqualP[0 Meter],YOffset->GreaterEqualP[0 Meter],ZOffset->GreaterEqualP[0 Meter],CrossSectionalShape->CrossSectionalShapeP,Rotation->GreaterEqualP[-180]},
			Units -> {Name->None,XOffset->Meter,YOffset->Meter,ZOffset->Meter,CrossSectionalShape->None,Rotation->None},
			Description -> "For each member of Positions, the parameters required to plot the position in this model of instrument, where the offsets refer to the location of the center of the position relative to the close, bottom, left hand corner of the instrument model's dimensions. If the Positions are movable along a given dimension, the offset in that dimension is defined to correspond to the instrument's rest/default state.",
			IndexMatching -> Positions,
			Headers->{Name->"Name of Position",XOffset->"XOffset",YOffset->"YOffset",ZOffset->"ZOffset",CrossSectionalShape->"Cross Sectional Shape",Rotation->"Rotation"},
			Category -> "Dimensions & Positions",
			Developer -> True
		},
		AvailableLayouts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[DeckLayout][InstrumentModel],
			Description -> "Readily available configurations of container models in specified positions on the deck of this instrument model.",
			Category -> "Dimensions & Positions"
		},

		(* --- Storage Information ---  *)
		LocalCacheContents -> {
			Format -> Multiple,
			Class -> {Link, Integer},
			Pattern :> {_Link, GreaterEqualP[0,1]},
			Relation -> {(Model[Container]|Model[Sample]|Model[Part]|Model[Plumbing]|Model[Wiring]|Model[Item]), Null},
			Headers -> {"Item Model", "Required Quantity"},
			Description -> "Items required to be present in the local cache for instruments of this model, along with the required quantity of each item.",
			Category -> "Storage Information"
		},
		SparePartsStorage -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container, Rack][InstrumentsSupplied],
			Description -> "The locations in which spare parts for this type of instrument are stored.",
			Category -> "Storage Information"
		},

		(* --- Storage --- *)
		ProvidedStorageCondition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The physical conditions such as temperature and humidity this instrument provides for samples stored long term within it.",
			Category -> "Storage Information"
		},
		StoragePositions->{
			Format -> Multiple,
			Class -> {Link, String},
			Pattern :> {_Link, LocationPositionP},
			Relation -> {Object[Container]|Object[Instrument], Null},
			Description -> "The specific containers and positions in which this instrument is stored and returned to after use, allowing more granular organization within storage locations for this instrument's storage condition.",
			Category -> "Storage Information",
			Headers->{"Storage Container", "Storage Position"},
			Developer -> True
		},
		DefaultStorageCondition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The condition in which instruments of this model are stored when not in use by an experiment; this condition may be overridden by the specific storage condition of any given instrument.",
			Category -> "Storage Information"
		},

		(* --- Plumbing Information --- *)
		Connectors -> {
			Format -> Multiple,
			Class -> {String, Expression, Expression, Real, Real, Expression},
			Pattern :> {ConnectorNameP, ConnectorP, ThreadP|GroundGlassJointSizeP|None, GreaterP[0 Inch], GreaterP[0 Inch], ConnectorGenderP|None},
			Units -> {None, None, None, Inch, Inch, None},
			Headers -> {"Connector Name", "Connector Type","Thread Type","Inner Diameter","Outer Diameter","Gender"},
			Description -> "Specifications for the ports on this model of instrument that may connect to other plumbing components.",
			Category -> "Plumbing Information"
		},

		(* --- Wiring Information --- *)
		WiringConnectors -> {
			Format -> Multiple,
			Class -> {String, Expression, Expression},
			Pattern :> {WiringConnectorNameP, WiringConnectorP, ConnectorGenderP|None},
			Headers -> {"Wiring Connector Name", "Wiring Connector Type", "Gender"},
			Description -> "Specifications for the wiring ends of this instrument that may plug into and conductively connect to other items, parts or instruments.",
			Category -> "Wiring Information"
		},
		(* --- Qualifications & Maintenance --- *)
		QualificationFrequency -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterP[0*Second]},
			Relation -> {Model[Qualification][Targets], Null},
			Units -> {None, Day},
			Description -> "A list of Qualifications scheduled for instruments of this model and their required frequencies.",
			Headers -> {"Qualification Model", "Time"},
			Category -> "Qualifications & Maintenance"
		},
		MaintenanceFrequency -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterP[0*Second]},
			Relation -> {Model[Maintenance][Targets], Null},
			Units -> {None, Day},
			Description -> "A list of the Maintenance routines scheduled for instruments of this model and their required frequencies.",
			Headers -> {"Maintenance Model", "Time"},
			Category -> "Qualifications & Maintenance"
		},
		ReplacementParts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Part][SupportedInstruments]|Model[Plumbing][SupportedInstruments]|Model[Wiring][SupportedInstruments]|Model[Item][SupportedInstruments],
			Description -> "A list of tracked replacement part models for this instrument.",
			Category -> "Qualifications & Maintenance"
		},
		PassiveClean ->{
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the exterior surfaces of this instrument model can be cleaned while in use.",
			Category -> "Qualifications & Maintenance"
		},
		VentilationFlowRateRequirement -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*(Meter/Second)],
			Units -> (Meter/Second),
			Description -> "The minimum flow rate of air generated by the instrument's ventilator for its safe and proper function.",
			Category -> "Qualifications & Maintenance"
		},
		VentilationFlowRateRecommendation -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*(Meter/Second)],
			Units -> (Meter/Second),
			Description -> "The flow rate of air generated by the instrument's ventilator recommended by its manufacturer.",
			Category -> "Qualifications & Maintenance"
		},
		ContinuousOperation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the instrument is required to operate continuously in the lab, regardless of if it is InUse by a specific protocol, such as a freezer.",
			Category-> "Qualifications & Maintenance"
		},
		QualificationRequired -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this model of instrument must have an active qualification.",
			Category-> "Qualifications & Maintenance",
			Developer -> True
		},
		(* --- Inventory --- *)
		Manufacturer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Company, Supplier][InstrumentsManufactured],
			Description -> "The company that originally manufactured this model of instrument.",
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
		Mobile -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that this model of instrument is portable and its location must be updated and tracked within the lab as it is moved.",
			Category -> "Inventory",
			Developer -> True
		},

		(* --- Health & Safety --- *)
		Sterile -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this model of instrument is used for protocols employing aseptic techniques.",
			Category -> "Health & Safety"
		},
		CultureHandling -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CultureHandlingP,
			Description -> "Indicates the type of cell samples (Microbial or NonMicrobial) that this instrument can be used with (to prevent contamination). Refer to the patterns MicrobialCellTypeP and NonMicrobialCellTypeP for more information.",
			Category -> "Health & Safety"
		},
		GloveBoxStorage -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this model of instrument permanently resides in a glove box.",
			Category -> "Health & Safety"
		},
		FumeHoodStorage -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this model of instrument permanently resides in a fume hood.",
			Category -> "Health & Safety"
		},
		BiosafetyCabinetStorage -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this model of instrument permanently resides in a biosafety cabinet.",
			Category -> "Health & Safety"
		},
		HazardCategories -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> HazardCategoryP,
			Description -> "Hazards to be aware of during operation of instruments of this model.",
			Category -> "Health & Safety"
		},
		AsepticHandling -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether aseptic techniques are followed when handling samples on this model of instrument. These techniques include sanitizing equipment, surfaces, and personnel during experimentation and storage. Unlike AsepticTechniqueEnvironment, which refers only to actions within the instrument's interior, AsepticHandling applies to all sample-handling activities involving this instrument.",
			Category -> "Health & Safety"
		},
		AsepticTechniqueEnvironment -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether any interactions with the instrument's interior are carried out using aseptic practices. Unlike AsepticHandling, AsepticTechniqueEnvironment refers only to actions performed within the instrument's interior.",
			Category -> "Health & Safety"
		},
		(* --- Sensor Information --- *)
		SensorBarrier -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TypeP[Object[Sensor]],
			Description -> "Type of sensors which cannot monitor the internal contents of instruments of this model from the outside.",
			Category -> "Sensor Information"
		},
		(* --- Resources --- *)
		RequestedResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Resource, Instrument][RequestedInstrumentModels],
			Description -> "The list of resource requests for this model instrument that have not yet been Fulfilled.",
			Category -> "Resources",
			Developer -> True
		},
		CurrentUsers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Team, Financing][RequiredInstruments],
			Description -> "Client financing teams that are actively or imminently using this instrument model.",
			Category -> "Organizational Information",
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
