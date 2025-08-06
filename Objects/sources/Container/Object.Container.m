(* ::Package:: *)

(* ::Text:: *)
(*© 2011-2023 Emerald Cloud Lab, Inc.*)




DefineObjectType[Object[Container], {
	Description->"A physical container used to organize and track resources in the ECL.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		(*--- Organizational Information ---*)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name used to refer to this container.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		ModelName -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Name]],
			Pattern :> _String,
			Description -> "The name of the model that specifies general information about this type of container.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Contents -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {LocationPositionP, _Link},
			Relation -> {Null, Object[Container][Container] | Object[Instrument][Container] | Object[Sensor][Container] | Object[Part][Container] | Object[Item][Container] | Object[Sample][Container] | Object[Plumbing][Container] | Object[Wiring][Container]| Object[Package][Container]},
			Description -> "A list of all the Objects that this Object currently contains.",
			Category -> "Organizational Information",
			Abstract -> True,
			Headers -> {"Position","Object in Position"}
		},
		ContentsLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link, String, Link},
			Pattern :> {_?DateObjectQ, In | Out, _Link, _String, _Link},
			Relation -> {
				Null,
				Null,
				Alternatives[
					Object[Sample][LocationLog, 3],
					Object[Container][LocationLog, 3],
					Object[Instrument][LocationLog, 3],
					Object[Part][LocationLog, 3],
					Object[Item][LocationLog, 3],
					Object[Plumbing][LocationLog, 3],
					Object[Wiring][LocationLog, 3],
					Object[Sensor][LocationLog, 3],
					Object[Package][LocationLog, 3]
				],
				Null,
				Alternatives[
					Object[User],
					Object[Protocol],
					Object[Qualification],
					Object[Maintenance]
				]
			},
			Description -> "The record of items moved into and out of this container.",
			Category -> "Container Specifications",
			Headers -> {"Date","Change Type","Content","Position","Responsible Party"}
		},
		StorageAvailability -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {LocationPositionP, _Link},
			Relation -> {None, Object[StorageAvailability][Container]},
			Description -> "For each position, a description of the currently available long-term storage space.",
			Category -> "Dimensions & Positions",
			Developer -> True,
			Headers -> {"Position","Storage Space"}
		},
		CurrentProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol][Resources],
				Object[Maintenance][Resources],
				Object[Qualification][Resources]
			],
			Description -> "The experiment, maintenance, or control that is currently using this container.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		CurrentSubprotocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol],
				Object[Maintenance],
				Object[Qualification]
			],
			Description -> "The specific protocol or subprotocol that is currently using this container.",
			Category -> "Organizational Information",
			Developer -> True
		},
		Missing -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object was not found at its database listed location and that troubleshooting will be required to locate it.",
			Category -> "Organizational Information",
			Developer -> True
		},
		DateMissing -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the sample was set Missing.",
			Category -> "Organizational Information"
		},
		MissingLog -> {
			Format -> Multiple,
			Class -> {Date, Boolean, Link},
			Pattern :> {_?DateObjectQ, BooleanP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log of changes made to this sample's Missing status.",
			Headers -> {"Date", "Restricted", "Responsible Party"},
			Category -> "Organizational Information"
		},
		Restricted -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this container must be specified directly in order to be used in experiments or if instead it can be used by any experiments that request a model matching this container's model.",
			Category -> "Organizational Information"
		},
		RestrictedLog -> {
			Format -> Multiple,
			Class -> {Date, Boolean, Link},
			Pattern :> {_?DateObjectQ, BooleanP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log of changes made to this container's restricted status.",
			Headers -> {"Date", "Restricted", "Responsible Party"},
			Category -> "Organizational Information"
		},
		StoredOnCart -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this container is permanently stored on operator carts.",
			Category -> "Organizational Information"
		},
		Destination->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Object[Container, Site],
			Description->"If this container is in transit, the site where the container is being shipped to.",
			Category->"Organizational Information"
		},
		Site -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site],
			Description -> "The ECL site at which this sample currently resides.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		SiteLog->{
			Format->Multiple,
			Headers->{"Date", "Site", "Responsible Party"},
			Class->{Date, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null, Object[Container,Site], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description->"The site history of the container.",
			Category->"Container Information"
		},
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SampleStatusP,
			Description -> "Current usage state of the container. Meanings are as follows: Available (opened and in use); Stocked (not yet opened); Discarded (discarded or no longer in use); Reserved (earmarked for use in a particular protocol, control or maintenance); Flagged (involved in a protocol that required troubleshooting; integrity unknown).",
			Category -> "Organizational Information",
			Abstract -> True
		},
		StatusLog -> {
			Format -> Multiple,
			Class -> {Expression, Expression, Link},
			Pattern :> {_?DateObjectQ, SampleStatusP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log of changes made to the container's status.",
			Category -> "Organizational Information",
			Headers -> {"Date","Status","Responsible Party"},
			Developer -> True
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},

		(*--- Cover Information ---*)
		Cover -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Lid][CoveredContainer],
				Object[Item, Cap][CoveredContainer],
				Object[Item, PlateSeal][CoveredContainer]
			],
			Description -> "The cover that is currently used to protect this container.",
			Category -> "Cover Information"
		},
		CoverLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link, Link},
			Pattern :> {_?DateObjectQ, On|Off, _Link, _Link},
			Relation -> {Null, Null, Alternatives@@CoverObjectTypes, Object[Protocol]|Object[User]|Object[Maintenance]|Object[Qualification]},
			Units -> {None, None, None, None},
			Description -> "A historical record of the covering or uncovering of the container.",
			Category -> "Cover Information",
			Headers ->{"Date","Action","Cover","Responsible Party"}
		},
		KeepCovered -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the cover on this container should be \"peaked\" off when transferred into/out of instead of taken off completely, which is the default behavior.",
			Category -> "Cover Information"
		},
		PreviousCover -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Lid],
				Object[Item, Cap],
				Object[Item, PlateSeal]
			],
			Description -> "The last cover that was used to protect the contents of this container. This field is only filled out if the container is currently uncovered and the previous cover can be reused (not Crimp Caps or Plate Seals).",
			Category -> "Cover Information"
		},
		Cap -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Item, Cap][CappedContainer],
			Description -> "The cap that is currently used to seal this container.",
			Category -> "Cover Information"
		},
		Septum -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Septum][CoveredContainer]
			],
			Description -> "The septum that is used in conjunction with the cover to protect this container.",
			Category -> "Cover Information"
		},
		Stopper -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Item, Stopper][CoveredContainer]
			],
			Description -> "The stopper that is used in conjuction with the cover to protect this container.",
			Category -> "Cover Information"
		},
		AluminumFoilWrapped -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this container is entirely wrapped with aluminum foil in order to protect the contents of the container from light.",
			Category -> "Cover Information"
		},
		ParafilmWrapped -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this container's cover is secured with parafilm.",
			Category -> "Cover Information"
		},

		(*--- Container Information ---*)
		Container -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container][Contents, 2],
				Object[Instrument][Contents, 2]
			],
			Description -> "The container or instrument that is currently holding this container.",
			Category -> "Container Information",
			Abstract -> True
		},
		Installed -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this container is installed on an instrument.",
			Category -> "Container Information",
			Developer -> True
		},
		Position -> {
			Format -> Single,
			Class -> String,
			Pattern :> LocationPositionP,
			Description -> "The position of this object within its Container.",
			Category -> "Container Information"
		},
		LocationLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link, String, Link},
			Pattern :> {_?DateObjectQ, In | Out, _Link, _String, _Link},
			Relation -> {Null, Null, Object[Container][ContentsLog, 3] | Object[Instrument][ContentsLog, 3], Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "The location history of the container. Lines recording a movement to container and position of Null, Null respectively indicate the item being discarded.",
			Category -> "Container Information",
			Headers ->{"Date","Change Type","Container","Position","Responsible Party"}
		},
		ResourcePickingGrouping -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container],
				Object[Instrument]
			],
			Description -> "The parent container of this object which can be used to give the object's approximate location and to see show its proximity to other objects which may be resource picked at the same time or in use by the same protocol.",
			Category -> "Container Information"
		},
		StackedAbove -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container][StackedBelow],
				Object[Item][StackedBelow],
				Object[Part][StackedBelow]
			],
			Description -> "The container, item, or part placed directly on top of this object. Items in a stack are moved together as a single unit.",
			Category -> "Container Information"
		},
		StackedBelow -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container][StackedAbove],
				Object[Item][StackedAbove],
				Object[Part][StackedAbove]
			],
			Description -> "The Container, Item or Part upon which this item is stacked. Items in a stack are moved as a single item.",
			Category -> "Container Information"
		},

		(*--- Container Specifications ---*)
		Ampoule -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Ampoule]],
			Pattern :> BooleanP,
			Description -> "Indicates that this container is a sealed vessel, containing a measured quantity of substance, meant for single-use.",
			Category -> "Container Specifications"
		},
		Coating -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Coating]],
			Pattern :> ObjectP[Model[Molecule]],
			Description -> "The molecule that coats the interior of this container.",
			Category -> "Container Specifications"
		},
		ContainerMaterials -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],ContainerMaterials]],
			Pattern :> {MaterialP..},
			Description -> "The materials of which this container is made that come in direct contact with the samples it contains.",
			Category -> "Container Specifications"
		},
		Hermetic -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this container has an airtight seal at its aperture.",
			Category -> "Container Specifications"
		},
		Opaque -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Opaque]],
			Pattern :> BooleanP,
			Description -> "Indicates if the exterior of this container blocks the transmission of visible light.",
			Category -> "Container Specifications"
		},
		SelfStanding -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], SelfStanding]],
			Pattern :> BooleanP,
			Description -> "Indicates if this container is capable of staying upright when placed on a flat surface and does not require a rack.",
			Category -> "Container Specifications"
		},
		IrretrievableContents -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], IrretrievableContents]],
			Pattern :> BooleanP,
			Description -> "Indicates that the contents can be transferred into this container but never transferred out again. Null implies False.",
			Category -> "Container Specifications"
		},
		Case -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], Case]],
			Pattern :> BooleanP,
			Description -> "Indicates if a particular model of container is used to transport its contents around the lab in a contained environment for the purpose of isolating the sample for identification purposes because the contents themselves can not be pragmatically stickered with a barcode.",
			Category -> "Container Specifications"
		},
		CasingRequired -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], CasingRequired]],
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
			Description -> "The weight of the container when empty.",
			Category -> "Container Specifications"
		},
		TareWeightDistribution -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> DistributionP[Gram],
			Description -> "The statistical distribution of the tare weight.",
			Category -> "Container Specifications"
		},
		TareWeightLog -> {
			Format -> Multiple,
			Class -> {Date, Real, Link},
			Pattern :> {_?DateObjectQ, GreaterP[0*Gram], _Link},
			Relation -> {Null, Null, Object[Protocol]|Object[User, Emerald, Developer]},
			Units -> {None, Gram, None},
			Description -> "A historical record of the measured tare weight of the container.",
			Category -> "Container Specifications",
			Headers ->{"Date","Tare Weight","Responsible Party"}
		},
		Treatment -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model],Treatment]],
			Pattern :> WellTreatmentP,
			Description -> "The treatment, if any, on the interior of this container.",
			Category -> "Container Specifications"
		},

		(* --- Operating Limits --- *)
		MinTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Minimum temperature this type of container can be exposed to and maintain structural integrity.",
			Category -> "Operating Limits",
			Abstract -> False
		},
		MaxTemperature -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxTemperature]],
			Pattern :> GreaterP[0*Kelvin],
			Description -> "Maximum temperature this type of container can be exposed to and maintain structural integrity.",
			Category -> "Operating Limits",
			Abstract -> False
		},
		MinVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MinVolume]],
			Pattern :> GreaterP[0*Micro*Liter],
			Description -> "The minimum volume required to create a uniform layer at the bottom of the container, indicating the smallest volume needed to reliably aspirate from the container, measure spectral properties, etc.",
			Category -> "Operating Limits",
			Abstract -> False
		},
		MaxVolume -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],MaxVolume]],
			Pattern :> GreaterP[0*Micro*Liter],
			Description -> "Maximum volume of fluid the vessel can hold.",
			Category -> "Operating Limits",
			Abstract -> False
		},
		NumberOfHours -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			Description -> "The amount of time this container has been used during experiments.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		NumberOfUses -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of individual uses that this container has been utilized for during experiments.",
			Category -> "Operating Limits"
		},

		(* --- Dimensions & Positions --- *)
		AllowedPositions -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],AllowedPositions]],
			Pattern :> _Alternatives,
			Description -> "The positions in which this container can accept contents, defined by and pulled from the container's Model.",
			Category -> "Dimensions & Positions"
		},
		DeckLayout -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[DeckLayout][ConfiguredContainers],
			Description -> "The current configuration of container models in specified positions in this container.",
			Category -> "Dimensions & Positions"
		},

		(* --- Physical Properties --- *)
		Appearance -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Data],
			Description -> "The most recent image taken of this container.",
			Category -> "Physical Properties"
		},
		AppearanceLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Data], Object[Protocol]},
			Units -> {None, None, None},
			Description -> "A historical record of when the container was imaged.",
			Category -> "Physical Properties",
			Headers -> {"Date", "Data", "Protocol"}
		},
		Reusable -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that this container can be used repeatedly.",
			Category -> "Physical Properties"
		},

		(* --- Container History ---*)
		Protocols -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol][ContainersIn],
				Object[Protocol][ContainersOut]
			],
			Description -> "Protocols for which this container contained samples that served as inputs or outputs.",
			Category -> "Container History"
		},
		Source -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Transaction],
				Object[Protocol],
				Object[Protocol][PurchasedItems],
				Object[Qualification],
				Object[Qualification][PurchasedItems],
				Object[Maintenance],
				Object[Maintenance][PurchasedItems]
			],
			Description -> "The transaction or protocol that is responsible for generating this container.",
			Category -> "Container History"
		},
		AutoclaveLog -> {
			Format -> Multiple,
			Class -> {Date, Link},
			Pattern :> {_?DateObjectQ, _Link},
			Relation -> {Null, Object[Protocol]},
			Units -> {None, None},
			Description -> "A historical record of when the container was last autoclaved.",
			Category -> "Container History",
			Headers -> {"Date","Autoclave Protocol"}
		},
		DishwashLog -> {
			Format -> Multiple,
			Class -> {Date, Link},
			Pattern :> {_?DateObjectQ, _Link},
			Relation -> {Null, Object[Maintenance, Dishwash][CleanLabware]|Object[Maintenance, Handwash][CleanLabware]},
			Units -> {None, None},
			Description -> "A historical record of when the container was last washed.",
			Category -> "Container History",
			Headers -> {"Date","Dishwash Protocol"}
		},

		(* --- Storage & Handling --- *)
		StorageCondition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The conditions under which this container should be kept when not in use by an experiment.",
			Category -> "Storage & Handling"
		},
		StorageConditionLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Model[StorageCondition], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "A record of changes made to the conditions under which this container should be kept when not in use by an experiment.",
			Headers -> {"Date","Condition","Responsible Party"},
			Category -> "Storage & Handling"
		},
		StoragePositions->{
			Format -> Multiple,
			Class -> {Link, String},
			Pattern :> {_Link, LocationPositionP},
			Relation -> {Object[Container]|Object[Instrument], Null},
			Description -> "The specific containers and positions in which this container is to be stored, allowing more granular organization within storage locations for this container's storage condition.",
			Category -> "Storage & Handling",
			Headers->{"Storage Container", "Storage Position"},
			Developer -> True,
			AdminWriteOnly -> True
		},
		LocalCacheStorage -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this object it currently in a local cache beside an instrument and not in a typical inventory storage.",
			Category -> "Storage & Handling"
		},
		StorageSchedule -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Model[StorageCondition], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "The planned storage condition changes to be performed.",
			Headers -> {"Date", "Condition", "Responsible Party"},
			Category -> "Storage & Handling"
		},
		AwaitingStorageUpdate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this container has been scheduled for movement to a new storage condition.",
			Category -> "Storage & Handling",
			Developer -> True
		},
		AwaitingDisposal -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this container is marked for disposal once it is no longer required for any outstanding experiments.",
			Category -> "Storage & Handling"
		},
		DisposalLog -> {
			Format -> Multiple,
			Class -> {Expression, Boolean, Link},
			Pattern :> {_?DateObjectQ, BooleanP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log of changes made to when this container is marked as awaiting disposal by the AwaitingDisposal Boolean.",
			Headers -> {"Date","Awaiting Disposal","Responsible Party"},
			Category -> "Storage & Handling"
		},
		BiohazardDisposal -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates whether the container should be disposed of as biohazardous waste if disposed of, though it is not necessarily designated for disposal at this time.",
			Category -> "Storage & Handling"
		},
		StoreInverted -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this container is stored upside down.  This is primarily used for solid media to prevent condensation from forming on the lids and dripping into the samples.",
			Category -> "Storage & Handling"
		},
		Expires -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this container expires after a given amount of time.",
			Category -> "Storage & Handling",
			Abstract -> True
		},
		ShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after DateCreated this container is recommended for use before it should be discarded.",
			Category -> "Storage & Handling",
			Abstract -> True
		},
		UnsealedShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after DateUnsealed this container is recommended for use before it should be discarded.",
			Category -> "Storage & Handling",
			Abstract -> True
		},
		AsepticHandling -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if aseptic techniques are followed when moving or using the samples in this container. Aseptic techniques include sanitization, autoclaving, sterile filtration, or transferring in a biosafety cabinet during experimentation and storage.",
			Category -> "Storage & Handling"
		},
		ProvidedStorageCondition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The physical conditions such as temperature and humidity this container provides for samples stored long term within it.",
			Category -> "Storage Information"
		},
		TopLevelStorageDestination -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if the container can provide a different storage condition than its container.",
			Category -> "Storage Information"
		},
		Parafilm -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if containers of this model should have their covers sealed with parafilm the next time it is re-covered.",
			Category -> "Storage & Handling"
		},
		AluminumFoil -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if containers of this model should be wrapped in aluminum foil to protect the container contents from light the next time it is re-covered.",
			Category -> "Storage & Handling"
		},
		AsepticTransportContainerType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AsepticTransportContainerTypeP,
			Description -> "Indicates how this container is contained in an aseptic barrier and if it needs to be unbagged before being used in a protocol, maintenance, or qualification.",
			Category -> "Storage & Handling"
		},
		AsepticTechniqueEnvironment -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Download[Field[Model], AsepticTechniqueEnvironment]],
			Pattern :> BooleanP,
			Description -> "Indicates if interactions with the interior of the container should be done using aseptic practices.",
			Category -> "Storage & Handling"
		},
		(* --- Sensor Information --- *)
		Cameras -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {_String, _Link},
			Relation -> {Null,Object[Part, Camera][MonitoredLocation]},
			Description -> "Cameras monitoring the positions on this container.",
			Category -> "Sensor Information",
			Headers -> {"Position","Cameras monitoring this position"}
		},
		EnvironmentalSensors -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Sensor][DevicesMonitored],
			Description -> "Any additional external sensors that are monitoring this particular container.",
			Category -> "Sensor Information"
		},
		VolumeSensors -> {
			Format -> Multiple,
			Class -> {String, Link},
			Pattern :> {_String, _Link},
			Relation -> {Null,Object[Sensor, Volume][MonitoredLocation]},
			Description -> "Volume Sensors monitoring the positions on this container.",
			Category -> "Dimensions & Positions",
			Headers -> {"Position","Volume sensors monitoring this position"}
		},

		(* --- Plumbing Information --- *)
		Connectors -> {
			Format -> Multiple,
			Class -> {String, Expression, Expression, Real, Real, Expression},
			Pattern :> {ConnectorNameP, ConnectorP, ThreadP|GroundGlassJointSizeP|None, GreaterP[0 Inch], GreaterP[0 Inch], ConnectorGenderP|None},
			Units -> {None, None, None, Inch, Inch, None},
			Description -> "Specifications for the interfaces on this container that may connect to other plumbing components or instrument ports.",
			Category -> "Plumbing Information",
			Headers -> {"Connector Name", "Connector Type","Thread Type","Inner Diameter","Outer Diameter","Gender"}
		},
		Connections -> {
			Format -> Multiple,
			Class -> {String, Link, String},
			Pattern :> {ConnectorNameP, _Link, ConnectorNameP},
			Relation -> {
				Null,
				Alternatives[
					Object[Plumbing][Connections, 2],
					Object[Instrument][Connections, 2],
					Object[Item][Connections,2],
					Object[Part][Connections,2],
					Object[Container][Connections, 2]
				],
				Null
			},
			Description -> "A list of the plumbing components to which this instrument is directly connected to allow flow of liquids/gases.",
			Category -> "Plumbing Information",
			Headers -> {"Connector Name","Connected Object","Object Connector Name"}
		},
		ConnectionLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, String, Link, String, Link},
			Pattern :> {_?DateObjectQ, Connect | Disconnect, ConnectorNameP, _Link, ConnectorNameP, _Link},
			Relation -> {
				Null,
				Null,
				Null,
				Object[Plumbing][ConnectionLog, 4] | Object[Part][ConnectionLog, 4] | Object[Item][ConnectionLog, 4] | Object[Instrument][ConnectionLog, 4] | Object[Container][ConnectionLog, 4],
				Null,
				Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]
			},
			Description -> "The plumbing connection history of this instrument's ports.",
			Category -> "Plumbing Information",
			Headers -> {"Date","Change Type","Connector Name","Connected Object", "Object Connector Name","Responsible Party"}
		},
		ConnectedPlumbing -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Object[Plumbing][ConnectedLocation],Object[Item,Cap][ConnectedLocation]],
			Description -> "All plumbing components that are most closely associated with this container's plumbing system.",
			Category -> "Plumbing Information"
		},
		ConnectedInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument][GasSources,2],
			Description -> "A list of instruments that this container supplies through plumbing connections.",
			Category -> "Plumbing Information"
		},
		ConnectedInstrumentLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link, Link},
			Pattern :> {_?DateObjectQ, Connect | Disconnect, _Link, _Link},
			Relation -> {
				Null,
				Null,
				Object[Instrument][GasSourceLog, 4],
				Alternatives[
					Object[User],
					Object[Protocol],
					Object[Qualification],
					Object[Maintenance]
				]
			},
			Description -> "The record of instruments that this container supplies through plumbing connections.",
			Headers -> {"Date", "Change Type", "Instrument", "Responsible Party"},
			Category -> "Plumbing Information"
		},
		Ferrules -> {
			Format -> Multiple,
			Class -> {String, Link, Real},
			Pattern :> {ConnectorNameP, _Link, GreaterP[0*Milli*Meter]},
			Relation -> {Null, Object[Part,Ferrule][InstalledLocation], Null},
			Units -> {None, None, Milli Meter},
			Description -> "A list of the compressible sealing rings that have been attached to the connecting ports on this container.",
			Category -> "Plumbing Information",
			Headers -> {"Connector Name", "Installed Ferrule","Ferrule Offset"}
		},
		Nuts -> {
			Format -> Multiple,
			Class -> {String, Link, Expression},
			Pattern :> {ConnectorNameP, _Link, ConnectorGenderP|None},
			Relation -> {Null, Object[Part,Nut][InstalledLocation], Null},
			Description -> "A list of the ferrule-compressing connector components that have been attached to the connecting ports on this container.",
			Category -> "Plumbing Information",
			Headers -> {"Connector Name", "Installed Nut", "Connector Gender"}
		},
		PlumbingFittingsLog -> {
			Format -> Multiple,
			Class -> {Date, String, Expression, Link, Link, Real, Link},
			Pattern :> {_?DateObjectQ, ConnectorNameP, ConnectorGenderP|None, _Link, _Link, GreaterP[0*Milli*Meter], _Link},
			Relation -> {Null, Null, Null, Object[Part,Nut], Object[Part,Ferrule], Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Units -> {None, None, None, None, None, Milli*Meter, None},
			Description -> "The history of the connection type present at each connector on this container.",
			Headers -> {"Date", "Connector Name", "Connector Gender", "Installed Nut", "Installed Ferrule", "Ferrule Offset", "Responsible Party"},
			Category -> "Plumbing Information"
		},
		PlumbingSizeLog -> {
			Format -> Multiple,
			Class -> {Date, String, Real, Real, Link},
			Pattern :> {_?DateObjectQ, ConnectorNameP, GreaterP[0*Milli*Meter], GreaterP[0*Milli*Meter], _Link},
			Relation -> {Null, Null, Null, Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Units -> {None, None, Milli*Meter, Milli*Meter, None},
			Description -> "The history of the length of each connector on this container.",
			Headers -> {"Date", "Connector Name", "Connector Trimmed Length", "Final Plumbing Length", "Responsible Party"},
			Category -> "Plumbing Information"
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
		WiringConnections -> {
			Format -> Multiple,
			Class -> {String, Link, String},
			Pattern :> {WiringConnectorNameP, _Link, WiringConnectorNameP},
			Relation -> {
				Null,
				Alternatives[
					Object[Wiring][WiringConnections, 2],
					Object[Instrument][WiringConnections, 2],
					Object[Item][WiringConnections, 2],
					Object[Part][WiringConnections, 2],
					Object[Container][WiringConnections, 2]
				],
				Null
			},
			Headers -> {"Wiring Connector Name", "Connected Object", "Object Wiring Connector Name"},
			Description -> "A list of the wiring components to which this container is directly connected to allow the flow of electricity.",
			Category -> "Wiring Information"
		},
		WiringConnectionLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, String, Link, String, Link},
			Pattern :> {_?DateObjectQ, Connect|Disconnect, WiringConnectorNameP, _Link, WiringConnectorNameP, _Link},
			Relation -> {
				Null,
				Null,
				Null,
				Alternatives[
					Object[Wiring][WiringConnectionLog, 4],
					Object[Instrument][WiringConnectionLog, 4],
					Object[Item][WiringConnectionLog, 4],
					Object[Part][WiringConnectionLog, 4],
					Object[Container][WiringConnectionLog, 4]
				],
				Null,
				Alternatives[Object[User], Object[Protocol], Object[Qualification], Object[Maintenance]]
			},
			Headers -> {"Date", "Change Type", "Wiring Connector Name", "Connected Object", "Object Wiring Connector Name", "Responsible Party"},
			Description -> "The wiring connection history of this container.",
			Category -> "Wiring Information"
		},
		WiringConnectors -> {
			Format -> Multiple,
			Class -> {String, Expression, Expression},
			Pattern :> {WiringConnectorNameP, WiringConnectorP, ConnectorGenderP|None},
			Headers -> {"Wiring Connector Name", "Wiring Connector Type", "Gender"},
			Description -> "Specifications for the wiring interfaces of this container that may plug into and conductively connect to other wiring components or instrument connectors.",
			Category -> "Wiring Information"
		},
		ConnectedWiring -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Wiring][ConnectedLocation],
			Description -> "All wiring components that are most closely associated with this container's wiring system.",
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
		WiringLengthLog -> {
			Format -> Multiple,
			Class -> {Date, String, Real, Real, Link},
			Pattern :> {_?DateObjectQ, WiringConnectorNameP, GreaterP[0 Millimeter], GreaterP[0 Millimeter], _Link},
			Relation -> {Null, Null, Null, Null, Object[User]|Object[Protocol]|Object[Qualification]|Object[Maintenance]},
			Units -> {None, None, Millimeter, Millimeter, None},
			Headers -> {"Date", "Wiring Connector Name", "Wiring Connector Trimmed Length", "Final Wiring Length", "Responsible Party"},
			Description -> "The history of the length of each connector on this item.",
			Category -> "Wiring Information"
		},

		(* --- Inventory --- *)
		Product -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][Samples],
			Description -> "The product that specifies ordering information for this type of container.",
			Category -> "Inventory",
			Abstract -> True
		},
		Order -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Transaction, Order],
				Object[Transaction, DropShipping]
			],
			Description -> "The order from which this container was generated.",
			Category -> "Inventory"
		},
		KitComponents -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Sample][KitComponents],
				Object[Item][KitComponents],
				Object[Container][KitComponents],
				Object[Part][KitComponents],
				Object[Plumbing][KitComponents],
				Object[Wiring][KitComponents],
				Object[Sensor][KitComponents]
			],
			Description -> "All other samples that were received as part of the same kit as this container.",
			Category -> "Inventory"
		},
		Receiving -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Maintenance, ReceiveInventory][Items],
				Object[Maintenance, ReceiveInventory][Containers]
			],
			Description -> "The MaintenanceReceiveInventory in which this container was received.",
			Category -> "Inventory"
		},
		QCDocumentationFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Files containing any QC documentation that arrived with the container.",
			Category -> "Inventory"
		},
		LabelImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Image of the label of this container.",
			Category -> "Inventory"
		},
		BatchNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Manufacturer's batch that the container belongs to.",
			Category -> "Inventory"
		},
		DateStocked -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the container was added to the inventory system.",
			Category -> "Inventory"
		},
		DateUnsealed -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the packaging on the container was first opened in the lab.",
			Category -> "Inventory"
		},
		DatePurchased -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description ->  "Date ownership of this container was transferred to the user.",
			Category -> "Inventory"
		},
		DateDiscarded -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the container was discarded into waste.",
			Category -> "Inventory"
		},
		DateLastUsed -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date this container was last handled in any way.",
			Category -> "Inventory"
		},
		ExpirationDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date after which this container is considered expired.",
			Category -> "Inventory"
		},
		VerifiedSafeDisposal -> {
			Format -> Single,
			Class -> Boolean,
			Pattern:>BooleanP,
			Description -> "Indicates if a container previously marked for external waste disposal can be safely discarded using automated methods.",
			Category -> "Health & Safety"
		},

		(* --- Health & Safety --- *)
		Sterile -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this container is presently considered free of both microbial contamination and any microbial cell samples. To preserve this sterile state, the container is handled with aseptic techniques during experimentation and storage.",
			Category -> "Health & Safety"
		},
		RNaseFree -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates that this container is free of any RNases.",
			Category -> "Health & Safety"
		},
		NucleicAcidFree -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this container is presently considered to be not contaminated with DNA and RNA.",
			Category -> "Health & Safety"
		},
		PyrogenFree -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this container is presently considered to be not contaminated with endotoxin.",
			Category -> "Health & Safety"
		},
		ExpirationHazard -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if containers of this model become hazardous once they are expired and therefore must be automatically disposed of when they pass their expiration date.",
			Category -> "Health & Safety"
		},
		(*--- Qualifications & Maintenance ---*)
		QualificationFrequency -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Computables`Private`qualificationFrequency[Field[Model]]],
			Pattern :> {{ObjectReferenceP[Model[Qualification]], GreaterP[0*Day] | Null}..},
			Description -> "The controls and their required frequencies.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Qualification Model","Time Interval"}
		},
		RecentQualifications -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Qualification], Model[Qualification]},
			Description -> "List of the most recent controls run on this container for each model Qualification in QualificationFrequency.",
			Category -> "Qualifications & Maintenance",
			Abstract -> True,
			Headers -> {"Date","Qualification","Qualification Model"}
		},
		QualificationLog -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Qualification], Model[Qualification]},
			Description -> "List of all the controls that target this container and are not an unlisted protocol.",
			Category -> "Qualifications & Maintenance",
			Headers ->{"Date","Qualification","Qualification Model"},
			Developer -> True
		},
		NextQualificationDate -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, _?DateObjectQ},
			Relation -> {Model[Qualification], Null},
			Description -> "A list of the dates on which the next qualifications will be enqueued for this container.",
			Headers -> {"Qualification Model", "Date"},
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		Qualified -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this container has passed its most recent qualification.",
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		QualificationResultsLog -> {
			Format -> Multiple,
			Class -> {
				Date -> Date,
				Qualification -> Link,
				Result -> Expression
			},
			Pattern :> {
				Date -> _?DateObjectQ,
				Qualification -> _Link,
				Result -> QualificationResultP
			},
			Relation -> {
				Date -> Null,
				Qualification -> Object[Qualification],
				Result -> Null
			},
			Headers -> {
				Date -> "Date Evaluated",
				Qualification -> "Qualification",
				Result -> "Result"
			},
			Description -> "A record of the qualifications run on this container and their results.",
			Category -> "Qualifications & Maintenance"
		},
		QualificationExtensionLog -> {
			Format -> Multiple,
			Class -> {Link, Expression, Expression, Link, Expression, String},
			Pattern :> {_Link, _?DateObjectQ, _?DateObjectQ, _Link, QualificationExtensionCategoryP, _String},
			Relation -> {Model[Qualification], Null, Null, Object[User], Null, Null},
			Description -> "A list of amendments made to the regular qualification schedule of this container, and the reason for the deviation.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Qualification Model", "Original Due Date","Revised Due Date","Responsible Party","Extension Category","Extension Reason"}
		},
		MaintenanceFrequency -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Computables`Private`maintenanceFrequency[Field[Model]]],
			Pattern :> {{ObjectReferenceP[Model[Maintenance]], GreaterP[0*Day] | Null}..},
			Description -> "A list of the maintenances which are run on this container and their required frequencies.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Maintenance Model","Time Interval"}
		},
		RecentMaintenance -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Maintenance], Model[Maintenance]},
			Description -> "List of the most recent maintenances run on this container for each modelMaintenance in MaintenanceFrequency.",
			Category -> "Qualifications & Maintenance",
			Abstract -> True,
			Headers -> {"Date","Maintenance","Mainteance Model"}
		},
		MaintenanceLog -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Maintenance], Model[Maintenance]},
			Description -> "List of all the maintenances that target this container and are not an unlisted protocol.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Date","Maintenance","Maintenance Model"}
		},
		NextMaintenanceDate -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, _?DateObjectQ},
			Relation -> {Model[Maintenance], Null},
			Description -> "A list of the dates on which the next maintenance runs will be enqueued for this container.",
			Headers -> {"Maintenance Model", "Date"},
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		MaintenanceExtensionLog -> {
			Format -> Multiple,
			Class -> {Link, Expression, Expression, Link, Expression, String},
			Pattern :> {_Link, _?DateObjectQ, _?DateObjectQ, _Link, MaintenanceExtensionCategoryP, _String},
			Relation -> {Model[Maintenance], Null, Null, Object[User], Null, Null},
			Description -> "A list of amendments made to the regular maintenance schedule of this container, and the reason for the deviation.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Maintenance Model", "Original Due Date","Revised Due Date","Responsible Party","Extension Category","Extension Reason"}
		},

		(* --- Resources --- *)
		RequestedResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Resource, Sample][RequestedSample],
			Description -> "The list of resource requests for this container that have not yet been Fulfilled.",
			Category -> "Resources",
			Developer -> True
		},
		ResourcePickingQueue -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Maintenance],
				Object[Protocol],
				Object[Qualification]
			],
			Description -> "The line of protocols waiting to access samples from this location.",
			Category -> "Resources",
			Developer -> True
		},

		(* --- Migration Support --- *)
		NewStickerPrinted -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if a new sticker with a hashphrase has been printed for this object and therefore the hashphrase should be shown in engine when scanning the object.",
			Category -> "Migration Support",
			Developer -> True
		},
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
