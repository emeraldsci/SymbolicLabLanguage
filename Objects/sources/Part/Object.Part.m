(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Part], {
	Description->"An interchangeable part used in the maintenance of laboratory equipment or facilities.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {

		(* --- Organizational Information --- *)
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Name used to refer to the part.",
			Category -> "Organizational Information",
			Abstract -> True
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
			Description -> "The experiment, maintenance, or qualification that is currently using this part.",
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
			Description -> "The specific protocol or subprotocol that is currently using this part.",
			Category -> "Organizational Information",
			Developer -> True
		},
		ModelName -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]},Download[Field[Model],Name]],
			Pattern :> _String,
			Description -> "The name of the part model that this part was based on.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> PartStatusP,
			Description -> "Current status of the part. Options include Available (opened and in use), Stocked (not yet opened), Discarded (discarded or no longer in use), or InUse (being used).",
			Category -> "Organizational Information",
			Abstract -> True
		},
		Missing -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object was not found at its database listed location and that troubleshooting will be required to locate it.",
			Category -> "Organizational Information",
			Developer -> True
		},
		DateMissing->{
			Format->Single,
			Class->Date,
			Pattern:>_?DateObjectQ,
			Description->"Date the sample was set Missing.",
			Category->"Organizational Information"
		},
		MissingLog->{
			Format->Multiple,
			Class->{Date, Boolean, Link},
			Pattern:>{_?DateObjectQ, BooleanP, _Link},
			Relation->{Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description->"A log of changes made to this sample's Missing status.",
			Headers->{"Date", "Restricted", "Responsible Party"},
			Category->"Organizational Information"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		DateStocked -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the part was received and stocked in inventory.",
			Category -> "Organizational Information"
		},
		DateUnsealed -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the packaging on the part was first opened in the lab.",
			Category -> "Organizational Information"
		},
		DatePurchased -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description ->  "Date ownership of this part was transferred to the user.",
			Category -> "Inventory"
		},
		DateDiscarded -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the part was discarded into waste.",
			Category -> "Organizational Information"
		},
		DateLastUsed -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date this part was last handled in any way.",
			Category -> "Inventory"
		},
		ExpirationDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date by which the part should be replaced.",
			Category -> "Organizational Information"
		},
		Expires -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this part expires after a given amount of time.",
			Category -> "Storage Information",
			Abstract -> True
		},
		ShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after DateCreated this part is recommended for use before it should be discarded.",
			Category -> "Storage Information",
			Abstract -> True
		},
		UnsealedShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after DateUnsealed this part is recommended for use before it should be discarded.",
			Category -> "Storage Information",
			Abstract -> True
		},
		StatusLog -> {
			Format -> Multiple,
			Class -> {Expression, Expression, Link},
			Pattern :> {_?DateObjectQ, SampleStatusP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log of changes made to the part's status.",
			Category -> "Organizational Information",
			Headers -> {"Date", "Status Change Type", "Person Responsible for Change"},
			Developer -> True
		},
		Restricted -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this part must be specified directly in order to be used in experiments or if instead it can be used by any experiments that request a model matching this part's model.",
			Category -> "Organizational Information"
		},
		RestrictedLog -> {
			Format -> Multiple,
			Class -> {Date, Boolean, Link},
			Pattern :> {_?DateObjectQ, BooleanP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log of changes made to this part's restricted status.",
			Headers -> {"Date", "Restricted", "Responsible Party"},
			Category -> "Organizational Information"
		},
		DishwashLog -> {
			Format -> Multiple,
			Class -> {Date, Link},
			Pattern :> {_?DateObjectQ, _Link},
			Relation -> {Null, Object[Maintenance, Dishwash][CleanLabware]|Object[Maintenance, Handwash][CleanLabware]},
			Units -> {None, None},
			Description -> "A historical record of when the container was last washed.",
			Category -> "Organizational Information",
			Headers -> {"Date","Dishwash Protocol"}
		},

		(* --- Inventory --- *)
		SerialNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Identification number for this part.",
			Category -> "Inventory"
		},
		BatchNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Identifies the manufacturing lot/batch for this part.",
			Category -> "Inventory"
		},
		QCDocumentationFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Quality control documentation provided by the manufacturer of the part.",
			Category -> "Inventory"
		},
		LabelImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Image of the label of this part.",
			Category -> "Inventory"
		},
		Product -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][Samples],
			Description -> "The product employed by this part.",
			Category -> "Inventory"
		},
		Order -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Transaction, Order],
				Object[Transaction, DropShipping]
			],
			Description -> "Order that this part was generated from.",
			Category -> "Inventory"
		},
		Receiving -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance, ReceiveInventory][Items],
			Description -> "The MaintenanceReceiveInventory in which this part was received.",
			Category -> "Inventory"
		},

		(* --- Storage --- *)
		StorageCondition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The conditions under which this part should be kept when not in use by an experiment.",
			Category -> "Storage Information"
		},
		StorageConditionLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Model[StorageCondition], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "A record of changes made to the conditions under which this part should be kept when not in use by an experiment.",
			Headers -> {"Date","Condition","Responsible Party"},
			Category -> "Storage Information"
		},
		StorageSchedule -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Model[StorageCondition], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "The planned storage condition changes to be performed.",
			Headers -> {"Date", "Condition", "Responsible Party"},
			Category -> "Storage Information"
		},
		AwaitingStorageUpdate -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this part has been scheduled for movement to a new storage condition.",
			Category -> "Storage Information",
			Developer -> True
		},
		AwaitingDisposal -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this part is marked for disposal once it is no longer required for any outstanding experiments.",
			Category -> "Storage Information"
		},
		DisposalLog -> {
			Format -> Multiple,
			Class -> {Expression, Boolean, Link},
			Pattern :> {_?DateObjectQ, BooleanP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log of changes made to when this part is marked as awaiting disposal by the AwaitingDisposal Boolean.",
			Headers -> {"Date","Awaiting Disposal","Responsible Party"},
			Category -> "Storage Information"
		},
		StoragePositions->{
			Format -> Multiple,
			Class -> {Link, String},
			Pattern :> {_Link, LocationPositionP},
			Relation -> {Object[Container]|Object[Instrument], Null},
			Description -> "The specific containers and positions in which this container is to be stored, allowing more granular organization within storage locations for this part's storage condition.",
			Category -> "Storage Information",
			Headers->{"Storage Container", "Storage Position"},
			Developer -> True
		},
		Container -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Container][Contents, 2],
				Object[Instrument][Contents, 2]
			],
			Description -> "The container in which this part is located.",
			Category -> "Storage Information"
		},
		Position -> {
			Format -> Single,
			Class -> String,
			Pattern :> LocationPositionP,
			Description -> "The position of this part within the container in which it is located.",
			Category -> "Storage Information"
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
			Category -> "Container Specifications"
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
			Category -> "Container Specifications"
		},
		LocationLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link, String, Link},
			Pattern :> {_?DateObjectQ, In | Out, _Link, _String, _Link},
			Relation -> {
				Null,
				Null,
				Object[Container][ContentsLog, 3] | Object[Instrument][ContentsLog, 3],
				Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "The location history of the part. Lines recording a movement to container and position of Null, Null respectively indicate the item being discarded.",
			Category -> "Storage Information",
			Headers ->  {"Date","In or Out","Container moved into or out of","Position moved into or out Of", "Person who moved the part"}
		},
		Site -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site],
			Description -> "The ECL site at which this part currently resides.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		SiteLog->{
			Format->Multiple,
			Headers->{"Date", "Site", "Responsible Party"},
			Class->{Date, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null, Object[Container,Site], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description->"The site history of the part.",
			Category->"Container Information"
		},
		ResourcePickingGrouping->{
			Format->Single,
			Class->Link,
			Pattern:>_Link,
			Relation->Alternatives[
				Object[Container],
				Object[Instrument]
			],
			Description->"The parent container of this object which can be used to give the object's approximate location and to see show its proximity to other objects which may be resource picked at the same time or in use by the same protocol.",
			Category->"Container Specifications"
		},
		(* --- Plumbing Information --- *)
		Connectors -> {
			Format -> Multiple,
			Class -> {String, Expression, Expression, Real, Real, Expression},
			Pattern :> {ConnectorNameP, ConnectorP, ThreadP|GroundGlassJointSizeP|None, GreaterP[0 Inch], GreaterP[0 Inch], ConnectorGenderP|None},
			Units -> {None, None, None, Inch, Inch, None},
			Description -> "Specifications for the interfaces on this part that may connect to other plumbing components or instrument ports.",
			Category -> "Plumbing Information",
			Headers -> {"Connector Name", "Connector Type","Thread Type","Inner Diameter","Outer Diameter","Gender"}
		},
		Nuts -> {
			Format -> Multiple,
			Class -> {String, Link, Expression},
			Pattern :> {ConnectorNameP, _Link, ConnectorGenderP|None},
			Relation -> {Null, Object[Part,Nut][InstalledLocation], Null},
			Description -> "A list of the ferrule-compressing connector components that have been attached to the connecting ports on this item.",
			Category -> "Plumbing Information",
			Headers -> {"Connector Name", "Installed Nut", "Connector Gender"}
		},
		Ferrules -> {
			Format -> Multiple,
			Class -> {String, Link, Real},
			Pattern :> {ConnectorNameP, _Link, GreaterP[0*Milli*Meter]},
			Relation -> {Null, Object[Part,Ferrule][InstalledLocation], Null},
			Units -> {None, None, Milli Meter},
			Description -> "A list of the compressible sealing rings that have been attached to the connecting ports on this item.",
			Category -> "Plumbing Information",
			Headers -> {"Connector Name", "Installed Ferrule","Ferrule Offset"}
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
			Description -> "A list of the plumbing components to which this part is connected to allow flow of liquids/gases.",
			Category -> "Plumbing Information",
			Headers ->  {"Part Port Name", "Plumbing Object", "Plumbing Connector Name"}
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
			Description -> "The plumbing connection history of this part.",
			Category -> "Plumbing Information",
			Headers ->  {"Date", "Connect or Disconnect", "Port Name", "Object Attached to/Detached From", "Plumbing Connector Name Attached to/Detached From", "Person/Protocol Who Performed the Action"}
		},
		PlumbingFittingsLog -> {
			Format -> Multiple,
			Class -> {Date, String, Expression, Link, Link, Real, Link},
			Pattern :> {_?DateObjectQ, ConnectorNameP, ConnectorGenderP|None, _Link, _Link, GreaterP[0*Milli*Meter], _Link},
			Relation -> {Null, Null, Null, Object[Part,Nut], Object[Part,Ferrule], Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Units -> {None, None, None, None, None, Milli*Meter, None},
			Description -> "The history of the connection type present at each connector on this part.",
			Headers -> {"Date", "Connector Name", "Connector Gender", "Installed Nut", "Installed Ferrule", "Ferrule Offset", "Responsible Party"},
			Category -> "Plumbing Information"
		},
		Size -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter],
			Units -> Meter,
			Description -> "The length of this part, in the direction of fluid flow.",
			Category -> "Plumbing Information"
		},
		PlumbingSizeLog -> {
			Format -> Multiple,
			Class -> {Date, String, Real, Real, Link},
			Pattern :> {_?DateObjectQ, ConnectorNameP, GreaterP[0*Milli*Meter], GreaterP[0*Milli*Meter], _Link},
			Relation -> {Null, Null, Null, Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Units -> {None, None, Milli*Meter, Milli*Meter, None},
			Description -> "The history of the length of each connector on this part.",
			Headers -> {"Date", "Connector Name", "Connector Trimmed Length", "Final Plumbing Length", "Responsible Party"},
			Category -> "Plumbing Information"
		},

		(* --- Wiring Information --- *)
		WiringConnectors -> {
			Format -> Multiple,
			Class -> {String, Expression, Expression},
			Pattern :> {WiringConnectorNameP, WiringConnectorP, ConnectorGenderP|None},
			Headers -> {"Wiring Connector Name", "Wiring Connector Type", "Gender"},
			Description -> "Specifications for the wiring interfaces of this part that may plug into and conductively connect to other wiring components or instrument wiring connectors.",
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
		WiringLengthLog -> {
			Format -> Multiple,
			Class -> {Date, String, Real, Real, Link},
			Pattern :> {_?DateObjectQ, WiringConnectorNameP, GreaterP[0 Millimeter], GreaterP[0 Millimeter], _Link},
			Relation -> {Null, Null, Null, Null, Object[User]|Object[Protocol]|Object[Qualification]|Object[Maintenance]},
			Units -> {None, None, Millimeter, Millimeter, None},
			Headers -> {"Date", "Wiring Connector Name", "Wiring Connector Trimmed Length", "Final Wiring Length", "Responsible Party"},
			Description -> "The history of the length of each connector on this part.",
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
			Description -> "A list of the wiring components to which this part is directly connected to allow the flow of electricity.",
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
			Description -> "The wiring connection history of this part.",
			Category -> "Wiring Information"
		},

		(* --- Qualifications & Maintenance --- *)
		Maintenance -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Maintenance][Target],
				Object[Maintenance, StorageUpdate][ScheduledMoves],
				Object[Maintenance, StorageUpdate][MovedItems],
				Object[Maintenance, Replace][ReplacementParts]
			],
			Description -> "Maintenance(s) the parts underwent.",
			Category -> "Qualifications & Maintenance"
		},
		MaintenanceLog -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Maintenance], Model[Maintenance]},
			Description -> "List of all the maintenances that target this part and are not an unlisted protocol.",
			Category -> "Qualifications & Maintenance",
			Headers ->  {"Date Run", "Maintenance Object", "Maintenance Object Model"}
		},
		MaintenanceFrequency -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Computables`Private`maintenanceFrequency[Field[Model]]],
			Pattern :> {{ObjectReferenceP[Model[Maintenance]], GreaterP[0*Day] | Null}..},
			Description -> "A list of the maintenances which are run on this part and their required frequencies.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Model Maintenance Object", "Time"}
		},
		RecentMaintenance -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Maintenance], Model[Maintenance]},
			Description -> "List of the most recent maintenances run on this part for each modelMaintenance in MaintenanceFrequency.",
			Category -> "Qualifications & Maintenance",
			Abstract -> True,
			Headers -> {"Date","Maintenance","Maintenance Model"}
		},
		NextMaintenanceDate -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, _?DateObjectQ},
			Relation -> {Model[Maintenance], Null},
			Description -> "A list of the dates on which the next maintenance runs will be enqueued for this part.",
			Headers -> {"Maintenance Model", "Date"},
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		MaintenanceExtensionLog -> {
			Format -> Multiple,
			Class -> {Link, Expression, Expression, Link, Expression, String},
			Pattern :> {_Link, _?DateObjectQ, _?DateObjectQ, _Link, MaintenanceExtensionCategoryP, _String},
			Relation -> {Model[Maintenance], Null, Null, Object[User], Null, Null},
			Description -> "A list of amendments made to the regular maintenance schedule of this part, and the reason for the deviation.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Maintenance Model", "Original Due Date","Revised Due Date","Responsible Party","Extension Category","Extension Reason"}
		},

		QualificationLog -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Qualification], Model[Qualification]},
			Description -> "List of all the Qualifications that target this part and are not an unlisted protocol.",
			Category -> "Qualifications & Maintenance",
			Headers ->   {"Date Run", "Qualification Object", "Qualification Object Model"},
			Developer -> True
		},
		QualificationFrequency -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[Model]}, Computables`Private`qualificationFrequency[Field[Model]]],
			Pattern :> {{ObjectReferenceP[Model[Qualification]], GreaterP[0*Day] | Null}..},
			Description -> "The Qualifications and their required frequencies.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Model Qualification Object", "Time"}
		},
		RecentQualifications -> {
			Format -> Multiple,
			Class -> {Expression, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Qualification], Model[Qualification]},
			Description -> "List of the most recent Qualifications run on this part for each model Qualification in QualificationFrequency.",
			Category -> "Qualifications & Maintenance",
			Abstract -> True,
			Headers ->  {"Date Completed", "Qualification Object","Qualification Model Object"}
		},
		NextQualificationDate -> {
			Format -> Multiple,
			Class -> {Link, Expression},
			Pattern :> {_Link, _?DateObjectQ},
			Relation -> {Model[Qualification], Null},
			Description -> "A list of the dates on which the next qualifications will be enqueued for this part.",
			Headers -> {"Qualification Model","Date"},
			Category -> "Qualifications & Maintenance",
			Developer -> True
		},
		Qualified -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this part has passed its most recent qualification.",
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
			Description -> "A record of the qualifications run on this part and their results.",
			Category -> "Qualifications & Maintenance"
		},
		QualificationExtensionLog -> {
			Format -> Multiple,
			Class -> {Link, Expression, Expression, Link, Expression, String},
			Pattern :> {_Link, _?DateObjectQ, _?DateObjectQ, _Link, QualificationExtensionCategoryP, _String},
			Relation -> {Model[Qualification], Null, Null, Object[User], Null, Null},
			Description -> "A list of amendments made to the regular qualification schedule of this part, and the reason for the deviation.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Qualification Model", "Original Due Date","Revised Due Date","Responsible Party","Extension Category","Extension Reason"}
		},
		SharedInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument][SharedParts],
			Description -> "List of instruments that are currently sharing this part.",
			Category -> "Qualifications & Maintenance"
		},
		InspectionLog -> {
			Format -> Multiple,
			Class -> {Expression, Link},
			Pattern :> {_?DateObjectQ,  _Link},
			Relation -> {Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log containing dates of inspections as well as the person or party who performed the inspection.",
			Category -> "Qualifications & Maintenance",
			Headers -> {"Date", "Person Responsible for Change"}
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
			Description -> "The transaction or protocol that is responsible for generating this part.",
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
			Description -> "All other samples that were received as part of the same kit as this part.",
			Category -> "Inventory"
		},
		(* --- Operating Limits --- *)
		NumberOfHours -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			Description -> "The amount of time this part has been used during experiments.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		NumberOfHoursLog -> {
			Format -> Multiple,
			Class -> {Date, Real, Link},
			Pattern :> {_?DateObjectQ, GreaterEqualP[0*Hour], _Link},
			Relation -> {Null, Null, Object[Protocol]|Object[User]|Object[Maintenance]},
			Units -> {None, Hour, None},
			Description -> "The historical record of the times this part has been used.",
			Headers -> {"Date", "Number Of Hours", "Responsible Party"},
			Category -> "Operating Limits"
		},
		NumberOfUses -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of individual uses that this part has been utilized for during experiments.",
			Category -> "General"
		},
		(* --- Resources --- *)
		RequestedResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Resource, Sample][RequestedSample],
			Description -> "The list of resource requests for this part that have not yet been Fulfilled.",
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
