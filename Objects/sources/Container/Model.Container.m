(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Model[Container], {
	Description->"Model information for a physical container used to organize and track resources in the ECL.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		(*--- Organizational Information ---*)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of the container model.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Synonyms -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> _String,
			Description -> "List of possible alternative names this model goes by.",
			Category -> "Organizational Information"
		},
		Authors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The person who created this model.",
			Category -> "Organizational Information"
		},
		Deprecated -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this model is historical and no longer used in the lab.",
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
		ParameterizationPlaceholder -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this model is being temporarily used as part of a container parameterization maintenance.",
			Category -> "Organizational Information",
			Developer -> True
		},
		Verified -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the information in this model has been reviewed for accuracy by an ECL employee.",
			Category -> "Organizational Information"
		},
		VerifiedLog -> {
			Format -> Multiple,
			Class -> {Boolean, Link, Date},
			Pattern :> {BooleanP, _Link, _?DateObjectQ},
			Relation -> {Null, Object[User], Null},
			Headers -> {"Verified", "Responsible person", "Date"},
			Description -> "Records the history of changes to the Verified field, along with when the change occured, and the person responsible.",
			Category -> "Organizational Information"
		},
		AdditionalInformation -> {
			Format -> Multiple,
			Class -> {String, Date},
			Pattern :> {_String, _?DateObjectQ},
			Description -> "Supplementary information recorded from the UploadMolecule function. These information usually records the user supplied input and options, providing additional information for verification.",
			Headers -> {"Information", "Date Added"},
			Category -> "Hidden"
		},

		(*--- Cover Information ---*)
		BuiltInCover -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the container has a cover that is physically attached and cannot be physically separated from the container (ex. centrifuge tube).",
			Category -> "Cover Information"
		},
		CutCoverTether -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that the material linking the existing cover to the container should be severed during receiving.",
			Category -> "Cover Information",
			Developer -> True
		},
		DisposableCaps -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this container uses interchangeable caps that are disposable; i.e. the cap on the container could be changed to another equivalent cap at any time.",
			Category -> "Cover Information"
		},
		OpenContainer -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if the container contents are exposed to the open environment when in use and can not be sealed off via capping.",
			Category->"Cover Information",
			Developer ->True
		},
		PermanentlySealed -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this model of container is permanently sealed closed and can not be opened to transfer anything into or out of it.",
			Category -> "Cover Information"
		},

		(* --- Container Specifications ---*)
		Ampoule -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates a sealed vessel containing a measured quantity of substance, meant for single-use.",
			Category -> "Container Specifications"
		},
		Aspiratable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this samples can be transferred out of this container when it is not Covered.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		Dispensable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if samples can be dispensed into this container when it is not Covered.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		AssociatedAccessories -> {
			Format -> Multiple,
			Class -> {Link,Integer},
			Pattern :> {_Link,GreaterP[0,1]},
			Relation -> {Alternatives[ (*Check that Part, Container,Item, Sensor, and Wiring have the SupportedContainers field now*)
				Model[Part][SupportedContainers],
				Model[Container][SupportedContainers],
				Model[Sensor][SupportedContainers],
				Model[Item][SupportedContainers],
				Model[Wiring][SupportedContainers]
			], Null},
			Headers -> {"Item","Quantity"},
			Description -> "A list of items, usually parts, that are installed with this container for full function, given in the format {Item, Quantity}, where the Item is a link to the relevant part model and the Quantity is the number of such parts that must be installed on/with this container for full function.",
			Category -> "Container Specifications"
		},
		SupportedContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Model[Container][AssociatedAccessories,1]
			],
			Description -> "A list of containers for which this model of container acts as a replacement part or an accompanying accessory.",
			Category -> "Container Specifications"
		},
		Coating -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Molecule],
			Description -> "The molecule that coats the interior of this container.",
			Category -> "Container Specifications"
		},
		ContainerMaterials -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> MaterialP,
			Category -> "Container Specifications",
			Description -> "The materials of which this container is made that come in direct contact with the samples it contains."
		},
		DetergentSensitive -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the container should not be used for holding detergent-containing solutions and should be hand washed using a detergent-free procedure, for example containers for samples or solutions used in liquid chromatography coupled to mass spectrometry (LCMS) experiments in order to avoid contamination of the LCMS system.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		Hermetic -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this container has an airtight seal at its aperture.",
			Category -> "Container Specifications"
		},
		InstrumentSchematics -> {
			Format -> Multiple,
			Class -> {Link,String},
			Pattern :> {_Link,_String},
			Relation -> {Object[EmeraldCloudFile],Null},
			Description -> "Detailed drawings of all the available containers of the same type in ECL that explain its capabilities and limitations.",
			Category -> "Container Specifications",
			Headers -> {"Schematic","Caption"}
		},
		Unimageable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that this container should never be imaged.",
			Category -> "Container Specifications",
			Developer -> True
		},
		ImageFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A photo of this model of container.",
			Category -> "Container Specifications"
		},
		ImageFileScale -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[(0 Pixel)/(Centi Meter)],
			Units -> (Pixel / (Centi Meter)),
			Description -> "The scale relating pixels of ImageFile to real world distance.",
			Category -> "Container Specifications"
		},
		Schematics -> {
			Format -> Multiple,
			Class -> {Link,String},
			Pattern :> {_Link,_String},
			Relation -> {Object[EmeraldCloudFile],Null},
			Description -> "Detailed drawings of the container that explain its capabilities and limitations.",
			Category -> "Container Specifications",
			Headers -> {"Schematic","Caption"}
		},
		Opaque -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the exterior of this container blocks the transmission of visible light.",
			Category -> "Container Specifications",
			Abstract -> True
		},
		MinTransparentWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[1 Nanometer,1 Meter],
			Units -> Nanometer,
			Description -> "Minimum wavelength this type of container allows to pass through, thereby allowing measurement of the sample contained using light source with larger wavelength.",
			Category -> "Container Specifications"
		},
		MaxTransparentWavelength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> RangeP[1 Nanometer,1 Meter],
			Units -> Nanometer,
			Description -> "Maximum wavelength this type of container allows to pass through, thereby allowing measurement of the sample contained using light source with smaller wavelength.",
			Category -> "Container Specifications"
		},
		PositionSelectable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if positions in this container are selected by the position selector window in software rather than by scanning position stickers.",
			Category -> "Container Specifications",
			Developer -> True
		},
		SelfStanding -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this container is capable of staying upright when placed on a flat surface and does not require a rack.",
			Category -> "Container Specifications"
		},
		TransportStable -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this container is capable of staying upright without assistance when being transported on an operator cart. Containers that are stable for transport can tolerate cart motion and accidental contact without falling, while those that are not must be resource picked into a rack.",
			Category -> "Container Specifications"
		},
		Transportable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the rack can be selected instead of individually scanning its contents during resource picking, storage, and movement tasks, and used to transport its contents to specified locations.",
			Category -> "Container Specifications"
		},
		Immobile -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this container is affixed to its location and can not be moved. Immobile objects are scanned, but not physically moved during resource picking and storage tasks.",
			Category -> "Container Specifications"
		},
		IrretrievableContents -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that the contents can be transferred into this container but never transferred out again. Null implies False.",
			Category -> "Container Specifications"
		},
		Case -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if a particular model of container is used to transport its contents around the lab in a contained environment for the purpose of isolating the sample for identification purposes because the contents themselves can not be pragmatically stickered with a barcode.",
			Category -> "Container Specifications"
		},
		CasingRequired -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Once filled with a sample, containers of this type must move around the lab inside of a case container that is barcoded because this model can not be barcoded individually.",
			Category -> "Container Specifications"
		},
		Squeezable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates this container must be squeezed in order to have its contents removed.",
			Category -> "Container Specifications"
		},
		TareWeight -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Gram],
			Units -> Gram,
			Description -> "The mean weight of empty containers of this model. Experimental tare weights of new containers of this model must be within 5% of this weight.",
			Category -> "Container Specifications"
		},
		TareWeightDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Gram],
			Description -> "The statistical distribution of the mean weight of empty containers of this model.",
			Category -> "Container Specifications"
		},
		Treatment -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> WellTreatmentP,
			Description -> "The treatment, if any, on the interior of this container.",
			Category -> "Container Specifications"
		},

		(*--- Operating Limits ---*)
		MinTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Minimum temperature this type of container can be exposed to and maintain structural integrity.",
			Category -> "Operating Limits",
			Abstract -> False
		},
		MaxTemperature -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Kelvin],
			Units -> Celsius,
			Description -> "Maximum temperature this type of container can be exposed to and maintain structural integrity.",
			Category -> "Operating Limits",
			Abstract -> False
		},
		MinVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Milli,
			Description -> "The minimum volume required to create a uniform layer at the bottom of the container, indicating the smallest volume needed to reliably aspirate from the container, measure spectral properties, etc.",
			Category -> "Operating Limits"
		},
		MaxVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Micro*Liter],
			Units -> Liter Milli,
			Description -> "Maximum volume of fluid the vessel can hold.",
			Category -> "Operating Limits"
		},
		CoveredVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Microliter],
			Units -> Microliter,
			Description -> "The volume of the vessel with the cover applied or with an imaginary boundary at the top edge of the vessel. Considering surface tension, the filled volume of liquid should be 10% smaller than this to avoid cover contacting samples.",
			Category -> "Operating Limits"
		},
		MaxNumberOfHours -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Hour],
			Units -> Hour,
			Description -> "The amount of time this container can be used during experiments before performance is expected to degrade and the container should be replaced.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		MaxNumberOfUses -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterP[0, 1],
			Units -> None,
			Description -> "The maximum number of uses for which this container is expected to perform before performance is expected to degrade and the container should be replaced.",
			Category -> "Operating Limits"
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
		InternalDiameter3D -> {
			Format -> Multiple,
			Class -> {Real, Real},
			Pattern :> {GreaterP[0*Milli*Meter], GreaterP[0*Milli*Meter]},
			Units -> {Meter Milli, Meter Milli},
			Description -> "A list of the internal diameter of the container over the entire height of the container.",
			Headers -> {"Z Direction Offset (Height)","Internal Diameter"},
			Category -> "Dimensions & Positions"
		},
		CrossSectionalShape -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CrossSectionalShapeP,
			Description -> "The shape of the outside of this container in the X-Y plane.",
			Category -> "Dimensions & Positions"
		},
		Footprint -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> FootprintP,
			Description -> "Standard form factor of the exterior bottom portion of this model of container used to seat the container in an open position.",
			Category -> "Dimensions & Positions"
		},
		TopFootprints -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> FootprintP,
			Description -> "Standard form factors of the exterior top portion of this model of container used to seat a container stacked above.",
			Category -> "Dimensions & Positions"
		},
		Positions -> {
			Format -> Multiple,
			Class -> {Name->String,Footprint->Expression,MaxWidth->Real,MaxDepth->Real,MaxHeight->Real},
			Pattern :> {Name->LocationPositionP,Footprint->(FootprintP|Open),MaxWidth->GreaterP[0 Centimeter],MaxDepth->GreaterP[0 Centimeter],MaxHeight->GreaterP[0 Centimeter]},
			Units -> {Name->None,Footprint->None,MaxWidth->Meter,MaxDepth->Meter,MaxHeight->Meter},
			Description -> "Spatial definitions of the positions that exist in this model of container, where MaxWidth and MaxDepth are the x and y dimensions of the maximum size of object that will fit in this position. MaxHeight is defined as the maximum height of object that can fit in this position without either encountering a barrier or creating a functional impediment to an experiment procedure.",
			Headers->{Name->"Name of Position",Footprint->"Footprint",MaxWidth->"Max Width",MaxDepth->"Max Depth",MaxHeight->"Max Height"},
			Category -> "Dimensions & Positions"
		},
		PositionPlotting -> {
			Format -> Multiple,
			Class -> {Name->String,XOffset->Real,YOffset->Real,ZOffset->Real,CrossSectionalShape->Expression,Rotation->Real},
			Pattern :> {Name->LocationPositionP,XOffset->GreaterEqualP[0 Meter],YOffset->GreaterEqualP[0 Meter],ZOffset->GreaterEqualP[0 Meter],CrossSectionalShape->CrossSectionalShapeP,Rotation->GreaterEqualP[-180]},
			Units -> {Name->None,XOffset->Meter,YOffset->Meter,ZOffset->Meter,CrossSectionalShape->None,Rotation->None},
			Description -> "For each member of Positions, the parameters required to plot the position, where the offsets refer to the location of the center of the position relative to the close, bottom, left hand corner of the container model's dimensions.",
			IndexMatching -> Positions,
			Headers->{Name->"Name of Position",XOffset->"XOffset",YOffset->"YOffset",ZOffset->"ZOffset",CrossSectionalShape->"Cross Sectional Shape",Rotation->"Rotation"},
			Category -> "Dimensions & Positions",
			Developer -> True
		},
		AvailableLayouts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[DeckLayout][ContainerModel],
			Description -> "Readily available configurations of container models in specified positions within this container model.",
			Category -> "Dimensions & Positions"
		},
		AllowedPositions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Positions]}, Computables`Private`allowedPositions[Field[Positions]]],
			Pattern :> _Alternatives,
			Description -> "Generates a pattern of all the valid position names for this model of container.",
			Category -> "Dimensions & Positions"
		},
		ContainerImage2DFile -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A file containing a top-down (X-Y plane) image of this model of container.",
			Category -> "Dimensions & Positions"
		},
		Shape2D -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> {(_Polygon | _Circle | _Line | _GraphicsComplex)..},
			Description -> "A list of Graphics primitives corresponding to the 2D shape of this model of container.",
			Category -> "Dimensions & Positions"
		},
		Shape3D -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> {(_Polygon | _Circle | _Line | _GraphicsComplex|_MeshRegion)..},
			Description -> "A list of Graphics primitives corresponding to the 3D shape of this model of container.",
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

		(* --- Physical Properties --- *)
		Reusable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the container is designed for multiple uses or if it is discarded after a single use. Reusable containers typically requiring cleaning and are hand washed or dishwashed after each use.",
			Category -> "Physical Properties"
		},

		(* --- Storage & Handling --- *)
		DefaultStorageCondition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The condition in which containers of this model are stored when not in use by an experiment; this condition may be overridden by the specific storage condition of any given container.",
			Category -> "Storage & Handling"
		},
		StoragePositions -> {
			Format -> Multiple,
			Class -> {Link, String},
			Pattern :> {_Link, LocationPositionP},
			Relation -> {Object[Container]|Object[Instrument], Null},
			Description -> "The specific containers and positions in which containers of this model are stored, allowing more granular organization within storage locations for this container's default storage condition.",
			Category -> "Storage & Handling",
			Headers->{"Storage Container", "Storage Position"},
			Developer -> True,
			AdminWriteOnly -> True
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
		StoreInverted -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if containers of this model are stored upside down.  This is primarily used for solid media to prevent condensation from forming on the lids and dripping into the samples.",
			Category -> "Storage & Handling"
		},
		Expires -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if containers of this model expire after a given amount of time.",
			Category -> "Storage & Handling",
			Abstract -> True
		},
		ShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after DateCreated that containers of this model are recommended for use before they should be discarded.",
			Category -> "Storage & Handling",
			Abstract -> True
		},
		UnsealedShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after DateUnsealed that containers of this model are recommended for use before they should be discarded.",
			Category -> "Storage & Handling",
			Abstract -> True
		},
		PreferredWashBin -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container,WashBin],
			Description -> "Indicates the recommended bin for dishwashing this container.",
			Category -> "Storage & Handling"
		},
		PreferredMixer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument],
			Description -> "Indicates the recommended mixer for this container.",
			Category -> "Storage & Handling"
		},
		CleaningMethod -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CleaningMethodP,
			Description -> "Indicates the type of cleaning that is employed for this model of container before reuse.",
			Category -> "Storage & Handling"
		},
		Parafilm -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if containers of this model should have their covers sealed with parafilm by default.",
			Category -> "Storage & Handling"
		},
		AluminumFoil -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if containers of this model should be wrapped in aluminum foil to protect the container contents from light by default.",
			Category -> "Storage & Handling"
		},
		AsepticTransportContainerType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AsepticTransportContainerTypeP,
			Description -> "Indicates how containers of this model are contained in an aseptic barrier and if they need to be unbagged before being used in a protocol, maintenance, or qualification.",
			Category -> "Storage & Handling"
		},
		AsepticTechniqueEnvironment -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if interactions with the interior of the container are carried out using aseptic practices.",
			Category -> "Storage & Handling"
		},

		(* --- Sensor Information --- *)
		SensorBarrier -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> TypeP[Object[Sensor]],
			Description -> "Sensors for which this model of container acts as a barrier. All such sensors located outside a container of this model are irrelevant to the container's contents.",
			Category -> "Sensor Information"
		},

		(*--- Plumbing Information ---*)
		Connectors -> {
			Format -> Multiple,
			Class -> {String, Expression, Expression, Real, Real, Expression},
			Pattern :> {ConnectorNameP, ConnectorP, ThreadP|GroundGlassJointSizeP|None, GreaterP[0 Inch], GreaterP[0 Inch], ConnectorGenderP|None},
			Units -> {None, None, None, Inch, Inch, None},
			Description -> "Specifications for the ends of this plumbing component that may connect to other plumbing components or instrument ports.",
			Category -> "Plumbing Information",
			Headers -> {"Connector Name", "Connector Type","Thread Type","Inner Diameter","Outer Diameter","Gender"}
		},
		Size -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter],
			Units -> Meter,
			Description -> "The length of this container, in the direction of fluid flow.",
			Category -> "Plumbing Information"
		},

		(* --- Wiring Information --- *)
		WiringConnectors -> {
			Format -> Multiple,
			Class -> {String, Expression, Expression},
			Pattern :> {WiringConnectorNameP, WiringConnectorP, ConnectorGenderP|None},
			Headers -> {"Wiring Connector Name", "Wiring Connector Type", "Gender"},
			Description -> "Specifications for the ends of the wiring connectors on this Container model that may plug into and conductively connect to other wiring components or instrument wiring connectors.",
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
			Description -> "The length of this container, in the direction of electricity flow.",
			Category -> "Wiring Information"
		},

		(**--- Inventory ---**)
		Products -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][ProductModel],
			Description -> "Products ordering information for this model.",
			Category -> "Inventory"
		},
		ProductDocumentationFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "PDFs of product documentation provided by the supplier of this model.",
			Category -> "Organizational Information"
		},
		ProductURL -> {
			Format -> Multiple,
			Class -> String,
			Pattern :> URLP,
			Description -> "Supplier webpage for the container model which is provided by the user for developers to review and retrieve information.",
			Category -> "Product Specifications",
			Developer -> True
		},
		Preparable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this samples/items of this model maybe prepared as needed during the course of an experiment.",
			Category -> "Inventory"
		},
		Stocked->{
			Format->Single,
			Class->Boolean,
			Pattern:>BooleanP,
			Description->"Indicates if the empty containers of this model are kept in stock for use on demand in experiments.",
			Abstract->True,
			Category -> "Container Specifications"
		},
		(* Note: Containers with StorageBuffer->True are allowed to be resource picked when stocked, even if they have a sample inside of them. *)
		StorageBuffer -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that containers of this model come stocked from the manufacturer with a storage buffer inside of the container.",
			Category -> "Inventory"
		},
		StorageBufferVolume -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Microliter],
			Units -> Microliter,
			Description -> "Indicates the amount of storage buffer containers of this model come stocked with.",
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
		KitProductsContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][KitComponents, ProductModel],
			Description -> "Products ordering information for this filter plate container with its supplied storage buffer solution as part of one or more kits.",
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
		ServiceProviders-> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Company,Service][PreferredContainers], Object[Company, Supplier][PreferredContainers]],
			Description -> "Companies that provide custom synthesis in this model.",
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
			Description -> "The type of sticker applied to containers of this model when they are stickered upon receiving.",
			Category -> "Inventory",
			Developer->True
		},
		BarcodeTag -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Item,Consumable],
			Description -> "The secondary tag used to affix a barcode to this object.",
			Category -> "Inventory",
			Developer->True
		},
		RentByDefault -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this container should be 'rented' from the ECL rather than purchased when it is needed during the course of an experiment.",
			Category -> "Inventory"
		},

		(* --- Health & Safety --- *)
		Sterile -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this model of container arrives free of microbial contamination from the manufacturer or is sterilized upon receiving.",
			Category -> "Health & Safety"
		},
		Sterilized -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this model of container is sterilized by autoclaving upon receiving and, if it is reusable, after being cleaned before it is reused.",
			Category -> "Health & Safety"
		},
		SterilizationBag -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this model of container is sealed in an autoclave bag before autoclaving. The bag protects its sterility until it is used.",
			Category -> "Health & Safety"
		},
		RNaseFree -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that this model of container is free of any RNases when received from the manufacturer.",
			Category -> "Health & Safety"
		},
		NucleicAcidFree -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this model of container is tested to be not contaminated with DNA and RNA by the manufacturer.",
			Category -> "Health & Safety"
		},
		PyrogenFree -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this model of container is tested to be not contaminated with endotoxin by the manufacturer.",
			Category -> "Health & Safety"
		},
		ExpirationHazard -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if containers of this model become hazardous once they are expired and therefore must be automatically disposed of when they pass their expiration date.",
			Category -> "Health & Safety"
		},

		(*--- Compatibility ---*)
		CoverFootprints -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CoverFootprintP,
			Description -> "The cover footprint that can fit on top of this container.",
			Category -> "Compatibility"
		},
		CoverTypes -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CoverTypeP,
			Description -> "The types of covers that are compatible with this container.",
			Category -> "Compatibility"
		},
		CompatibleCameras -> {
			Format -> Multiple,
			Class -> Expression,
			Pattern :> CameraCategoryP,
			Description -> "Indicates camera types capable of taking an image of a sample in this type of container.",
			Category -> "Compatibility"
		},
		PreferredBalance -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BalanceModeP,
			Description -> "Indicates the recommended balance type for weighing a sample in this type of container.",
			Category -> "Compatibility"
		},
		PreferredIllumination -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> IlluminationDirectionP,
			Description -> "The illumination source that should be used when acquiring images of this container.",
			Category -> "Compatibility"
		},
		PreferredCamera -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> CameraCategoryP,
			Description -> "Indicates the recommended camera type for taking an image of a sample in this type of container.",
			Category -> "Compatibility"
		},
		UltrasonicIncompatible -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if volume measurements of samples contained within objects of this model are likely to give errant readings when measurements are conducted via ultrasonic liquid level detection.",
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

		(*--- Qualifications & Maintenance ---*)
		QualificationFrequency -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, _?TimeQ},
			Relation -> {Model[Qualification][Targets], Null},
			Units -> {None, Day},
			Description -> "A list of the Qualification models and their required frequencies.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Qualification", "Time"}
		},
		MaintenanceFrequency -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, _?TimeQ},
			Relation -> {Model[Maintenance][Targets], Null},
			Units -> {None, Day},
			Description -> "A list of the maintenance models and their required frequencies.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Maintenance","Time"}
		},
		ContinuousOperation -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the container is required to operate continuously in the lab, regardless of if it is InUse by a specific protocol, such as a gas supply.",
			Category-> "Qualifications & Maintenance"
		},

		(* --- Resources --- *)
		RequestedResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Resource, Sample][RequestedModels],
			Description -> "The list of resource requests for this model container that have not yet been Fulfilled.",
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
		},
		PendingParameterization -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicate if this model is pending parameterization in lab.",
			Category -> "Organizational Information",
			Developer -> True
		}
	}
}];