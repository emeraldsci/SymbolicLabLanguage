(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Plumbing], {
	Description->"A component used to direct the flow of liquids or gases throughout the laboratory.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of this plumbing component.",
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
			Description -> "The experiment, maintenance, or Qualification that is currently using this plumbing component.",
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
			Description -> "The specific protocol or subprotocol that is currently using this plumbing component.",
			Category -> "Organizational Information",
			Developer -> True
		},
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SampleStatusP,
			Description -> "A symbol describing the state of this plumbing component for inventory and experimental usage purposes.",
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
		DateStocked -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the plumbing component was received and stocked in inventory.",
			Category -> "Organizational Information"
		},
		DateUnsealed -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the packaging on the plumbing component was first opened in the lab.",
			Category -> "Organizational Information"
		},
		DatePurchased -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description ->  "Date ownership of this plumbing component was transferred to the user.",
			Category -> "Inventory"
		},
		DateDiscarded -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the plumbing component was discarded into waste.",
			Category -> "Organizational Information"
		},
		DateLastUsed -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date this plumbing component was last handled in any way.",
			Category -> "Inventory"
		},
		ExpirationDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date by which the plumbing component should be replaced.",
			Category -> "Organizational Information"
		},
		Expires -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this plumbing component expires after a given amount of time.",
			Category -> "Storage Information",
			Abstract -> True
		},
		ShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after DateCreated this plumbing component is recommended for use before it should be discarded.",
			Category -> "Storage Information",
			Abstract -> True
		},
		UnsealedShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after DateUnsealed this plumbing component is recommended for use before it should be discarded.",
			Category -> "Storage Information",
			Abstract -> True
		},
		StatusLog -> {
			Format -> Multiple,
			Class -> {Expression, Expression, Link},
			Pattern :> {_?DateObjectQ, SampleStatusP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log of changes made to the plumbing component's status.",
			Headers ->  {"Date","Status","Responsible Party"},
			Category -> "Organizational Information",
			Developer -> True
		},
		Restricted -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this plumbing component must be specified directly in order to be used in experiments or if instead it can be used by any experiments that request a model matching this plumbing component's model.",
			Category -> "Organizational Information"
		},
		RestrictedLog -> {
			Format -> Multiple,
			Class -> {Date, Boolean, Link},
			Pattern :> {_?DateObjectQ, BooleanP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log of changes made to this plumbing component's restricted status.",
			Headers -> {"Date", "Restricted", "Responsible Party"},
			Category -> "Organizational Information"
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

		(* --- Plumbing Information --- *)
		Connectors -> {
			Format -> Multiple,
			Class -> {String, Expression, Expression, Real, Real, Expression},
			Pattern :> {ConnectorNameP, ConnectorP, ThreadP|GroundGlassJointSizeP|None, GreaterP[0 Inch], GreaterP[0 Inch], ConnectorGenderP|None},
			Units -> {None, None, None, Inch, Inch, None},
			Description -> "Specifications for the interfaces on this plumbing component that may connect to other plumbing components or instrument ports.",
			Category -> "Plumbing Information",
			Headers -> {"Connector Name", "Connector Type","Thread Type","Inner Diameter","Outer Diameter","Gender"}
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
			Description -> "A listing of the connectors of this plumbing component that are actively attached to other plumbing components or instruments in the lab.",
			Headers ->  {"Connector Name","Connected Object","Object Connector Name"},
			Category -> "Plumbing Information",
			Abstract -> True
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
			Description -> "The connection history of the plumbing component.",
			Headers ->  {"Date","Change Type","Connector Name","Connected Object","Object Connector Name","Responsible Party"},
			Category -> "Plumbing Information"
		},
		ConnectedLocation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument][ConnectedPlumbing],
				Object[Container][ConnectedPlumbing]
			],
			Description -> "The nearest object of known location to which this plumbing component is connected, either directly or indirectly.",
			Category -> "Plumbing Information"
		},
		PlumbingFittingsLog -> {
			Format -> Multiple,
			Class -> {Date, String, Expression, Link, Link, Real, Link},
			Pattern :> {_?DateObjectQ, ConnectorNameP, ConnectorGenderP|None, _Link, _Link, GreaterP[0*Milli*Meter], _Link},
			Relation -> {Null, Null, Null, Object[Part,Nut], Object[Part,Ferrule], Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Units -> {None, None, None, None, None, Milli*Meter, None},
			Description -> "The history of the connection type present at each connector on this plumbing component.",
			Headers -> {"Date", "Connector Name", "Connector Gender", "Installed Nut", "Installed Ferrule", "Ferrule Offset", "Responsible Party"},
			Category -> "Plumbing Information"
		},
		Size -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Meter],
			Units -> Meter,
			Description -> "The length of this plumbing component, in the direction of fluid flow.",
			Category -> "Plumbing Information"
		},
		PlumbingSizeLog -> {
			Format -> Multiple,
			Class -> {Date, String, Real, Real, Link},
			Pattern :> {_?DateObjectQ, ConnectorNameP, GreaterP[0*Milli*Meter], GreaterP[0*Milli*Meter], _Link},
			Relation -> {Null, Null, Null, Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Units -> {None, None, Milli*Meter, Milli*Meter, None},
			Description -> "The history of the length of each connector on this plumbing component.",
			Headers -> {"Date", "Connector Name", "Connector Trimmed Length", "Final Plumbing Length", "Responsible Party"},
			Category -> "Plumbing Information"
		},
		(* --- Physical Properties --- *)
		Count->{
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Units -> None,
			Description -> "The current number of individual items that are part of this plumbing component.",
			Category -> "Physical Properties"
		},
		CountLog->{
			Format -> Multiple,
			Class -> {Date, Integer, Link},
			Pattern :> {_?DateObjectQ, GreaterEqualP[0,1], _Link},
			Relation -> {Null, Null, Object[Protocol] | Object[Maintenance] | Object[Qualification] | Object[Product] | Object[User]},
			Units -> {None, None, None},
			Description -> "A historical record of the count of the plumbing component.",
			Category -> "Physical Properties",
			Headers ->{"Date","Count","Responsible Party"}
		},
		(* --- Inventory --- *)
		SerialNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Identification number for this plumbing component.",
			Category -> "Inventory"
		},
		BatchNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Identifies the manufacturing lot/batch for this plumbing component.",
			Category -> "Inventory"
		},
		QCDocumentationFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Quality control documentation provided by the manufacturer of the plumbing component.",
			Category -> "Inventory"
		},
		LabelImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Image of the label of this plumbing component.",
			Category -> "Inventory"
		},
		Product -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][Samples],
			Description -> "The product employed by this plumbing component.",
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
			Description -> "Order in which this plumbing component was requested for delivery.",
			Category -> "Inventory"
		},
		Receiving -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance, ReceiveInventory][Items],
			Description -> "The receiving protocol in which this plumbing component was received into the lab.",
			Category -> "Inventory"
		},

		(* --- Storage --- *)
		StorageCondition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The conditions under which this plumbing component should be kept when not in use by an experiment.",
			Category -> "Storage Information"
		},
		StorageConditionLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Model[StorageCondition], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "A record of changes made to the conditions under which this plumbing component should be kept when not in use by an experiment.",
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
			Description -> "Indicates if this plumbing component has been scheduled for movement to a new storage condition.",
			Category -> "Storage Information",
			Developer -> True
		},
		AwaitingDisposal -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this plumbing component is marked for disposal once it is no longer required for any outstanding experiments.",
			Category -> "Storage Information"
		},
		DisposalLog -> {
			Format -> Multiple,
			Class -> {Expression, Boolean, Link},
			Pattern :> {_?DateObjectQ, BooleanP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log of changes made to when this plumbing component is marked as awaiting disposal by the AwaitingDisposal Boolean.",
			Headers -> {"Date","Awaiting Disposal","Responsible Party"},
			Category -> "Storage Information"
		},
		StoragePositions->{
			Format -> Multiple,
			Class -> {Link, String},
			Pattern :> {_Link, LocationPositionP},
			Relation -> {Object[Container]|Object[Instrument], Null},
			Description -> "The specific containers and positions in which this container is to be stored, allowing more granular organization within storage locations for this plumbing component's storage condition.",
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
			Description -> "The container in which this plumbing component is located.",
			Category -> "Storage Information"
		},
		Position -> {
			Format -> Single,
			Class -> String,
			Pattern :> LocationPositionP,
			Description -> "The position of this plumbing component within the container in which it is located.",
			Category -> "Storage Information"
		},
		LocationLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link, String, Link},
			Pattern :> {_?DateObjectQ, In | Out, _Link, _String, _Link},
			Relation -> {Null, Null, Object[Container][ContentsLog, 3] | Object[Instrument][ContentsLog, 3], Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "The location history of the plumbing component.",
			Headers -> {"Date","Change Type","Container","Position","Responsible Party"},
			Category -> "Storage Information"
		},
		Site -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site],
			Description -> "The ECL site at which this plumbing component currently resides.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		SiteLog->{
			Format->Multiple,
			Headers->{"Date", "Site", "Responsible Party"},
			Class->{Date, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null, Object[Container,Site], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description->"The site history of the plumbing component.",
			Category->"Container Information"
		},
		ResourcePickingGrouping -> {
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
			Description -> "The transaction or protocol that is responsible for generating this plumbing component.",
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
			Description -> "All other samples that were received as part of the same kit as this plumbing component.",
			Category -> "Inventory"
		},
		SharedInstruments -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Instrument][SharedParts],
			Description -> "List of instruments that are currently sharing this part.",
			Category -> "Qualifications & Maintenance"
		},

		(* --- Operating Limits --- *)
		NumberOfHours -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0*Hour],
			Units -> Hour,
			Description -> "The amount of time this plumbing has been used during experiments.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		NumberOfUses -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of individual uses that this plumbing has been utilized for during experiments.",
			Category -> "General"
		},

		(* --- Resources --- *)
		NewStickerPrinted -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if a new sticker with a hashphrase has been printed for this object and therefore the hashphrase should be shown in engine when scanning the object.",
			Category -> "Migration Support",
			Developer -> True
		},
		RequestedResources -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Resource, Sample][RequestedSample],
			Description -> "The list of resource requests for this plumbing component that have not yet been Fulfilled.",
			Category -> "Resources",
			Developer -> True
		},
		Protocols -> { (* Note: ExperimentAssembleCrossFlowFiltrationTubing generates plumbing objects. *)
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol][SamplesOut]
			],
			Description -> "All protocols that generated this plumbing item.",
			Category -> "General"
		}
	}
}];
