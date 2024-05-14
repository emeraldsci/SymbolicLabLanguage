(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Wiring], {
	Description->"A component used to direct the flow of electricity throughout the laboratory.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
	
		Name -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name of this wiring component.",
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
			Description -> "The experiment, maintenance, or Qualification that is currently using this wiring component.",
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
			Description -> "The specific protocol or subprotocol that is currently using this wiring component.",
			Category -> "Organizational Information",
			Developer -> True
		},
		
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SampleStatusP,
			Description -> "A symbol describing the state of this wiring component for inventory and experimental usage purposes.",
			Category -> "Organizational Information",
			Abstract -> True
		},
	
		Missing -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this wiring object was not found at its database listed location and that troubleshooting will be required to locate it.",
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
			Description -> "Date the wiring component was received and stocked in inventory.",
			Category -> "Organizational Information"
		},
		
		DateUnsealed -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the packaging on the wiring component was first opened in the lab.",
			Category -> "Organizational Information"
		},
		
		DatePurchased -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description ->  "Date ownership of this wiring component was transferred to the user.",
			Category -> "Inventory"
		},
		
		DateDiscarded -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date the wiring component was discarded into waste.",
			Category -> "Inventory"
		},
		
		DateLastUsed -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date this wiring component was last handled in any way.",
			Category -> "Inventory"
		},
		
		ExpirationDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date by which the wiring component should be replaced.",
			Category -> "Inventory"
		},
		
		Expires -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates if this wiring component expires after a given amount of time.",
			Category -> "Storage Information",
			Abstract -> True
		},
		
		ShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after DateCreated this wiring component is recommended for use before it should be discarded.",
			Category -> "Storage Information",
			Abstract -> True
		},
		
		UnsealedShelfLife -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Day],
			Units -> Day,
			Description -> "The length of time after DateUnsealed this wiring component is recommended for use before it should be discarded.",
			Category -> "Storage Information",
			Abstract -> True
		},
		
		StatusLog -> {
			Format -> Multiple,
			Class -> {Expression, Expression, Link},
			Pattern :> {_?DateObjectQ, SampleStatusP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log of changes made to the wiring component's status.",
			Headers ->  {"Date","Status","Responsible Party"},
			Category -> "Organizational Information",
			Developer -> True
		},
		
		Restricted -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this wiring component must be specified directly in order to be used in experiments or if instead it can be used by any experiments that request a model matching this wiring component's model.",
			Category -> "Organizational Information"
		},
		
		RestrictedLog -> {
			Format -> Multiple,
			Class -> {Date, Boolean, Link},
			Pattern :> {_?DateObjectQ, BooleanP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log of changes made to this wiring component's restricted status.",
			Headers -> {"Date", "Restricted", "Responsible Party"},
			Category -> "Organizational Information"
		},

		(* --- Wiring Information --- *)
		WiringConnectors -> {
			Format -> Multiple,
			Class -> {String, Expression, Expression},
			Pattern :> {WiringConnectorNameP, WiringConnectorP, ConnectorGenderP|None},
			Headers -> {"Wiring Connector Name", "Wiring Connector Type", "Gender"},
			Description -> "Specifications for the wiring interfaces of this wiring component that may plug into and conductively connect to other wiring components, items, parts or instruments.",
			Category -> "Wiring Information"
		},
		
		WiringLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0 Centimeter],
			Units -> Centimeter,
			Description -> "The length of this wiring component, in the direction of the electricity flow.",
			Category -> "Wiring Information"
		},
		
		WiringLengthLog -> {
			Format -> Multiple,
			Class -> {Date, String, Real, Real, Link},
			Pattern :> {_?DateObjectQ, WiringConnectorNameP, GreaterP[0 Centimeter], GreaterP[0 Centimeter], _Link},
			Relation -> {Null, Null, Null, Null, Object[User]|Object[Protocol]|Object[Qualification]|Object[Maintenance]},
			Units -> {None, None, Centimeter, Centimeter, None},
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
		
		ConnectedLocation -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Instrument][ConnectedWiring],
				Object[Container][ConnectedWiring]
			],
			Description -> "The nearest object of known location to which this wiring component is connected, either directly or indirectly.",
			Category -> "Wiring Information"
		},

		(* --- Physical Properties --- *)
		Count->{
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0,1],
			Units -> None,
			Description -> "The current number of individual items that are part of this wiring component.",
			Category -> "Physical Properties"
		},
		
		CountLog->{
			Format -> Multiple,
			Class -> {Date, Integer, Link},
			Pattern :> {_?DateObjectQ, GreaterEqualP[0,1], _Link},
			Relation -> {Null, Null, Object[Protocol] | Object[Maintenance] | Object[Qualification] | Object[Product] | Object[User]},
			Units -> {None, None, None},
			Description -> "A historical record of the count of the wiring component.",
			Category -> "Physical Properties",
			Headers ->{"Date","Count","Responsible Party"}
		},
		
		(* --- Inventory --- *)
		SerialNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Identification number for this wiring component.",
			Category -> "Inventory"
		},
		
		BatchNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Identifies the manufacturing lot/batch for this wiring component.",
			Category -> "Inventory"
		},
		
		QCDocumentationFiles -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Quality control documentation provided by the manufacturer of the wiring component.",
			Category -> "Inventory"
		},
		
		LabelImage -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Image of the label of this wiring component.",
			Category -> "Inventory"
		},
		
		Product -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product][Samples],
			Description -> "The product employed by this wiring component.",
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
			Description -> "Order in which this wiring component was requested for delivery.",
			Category -> "Inventory"
		},
		
		Receiving -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance, ReceiveInventory][Items],
			Description -> "The receiving protocol in which this wiring component was received into the lab.",
			Category -> "Inventory"
		},

		(* --- Storage --- *)
		StorageCondition -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[StorageCondition],
			Description -> "The conditions under which this wiring component should be kept when not in use by an experiment.",
			Category -> "Storage Information"
		},
		
		StorageConditionLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Model[StorageCondition], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "A record of changes made to the conditions under which this wiring component should be kept when not in use by an experiment.",
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
			Description -> "Indicates if this wiring component has been scheduled for movement to a new storage condition.",
			Category -> "Storage Information",
			Developer -> True
		},
		
		AwaitingDisposal -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this wiring component is marked for disposal once it is no longer required for any outstanding experiments.",
			Category -> "Storage Information"
		},
		
		DisposalLog -> {
			Format -> Multiple,
			Class -> {Expression, Boolean, Link},
			Pattern :> {_?DateObjectQ, BooleanP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log of changes made to when this wiring component is marked as awaiting disposal by the AwaitingDisposal Boolean.",
			Headers -> {"Date","Awaiting Disposal","Responsible Party"},
			Category -> "Storage Information"
		},

		StoragePositions->{
			Format -> Multiple,
			Class -> {Link, String},
			Pattern :> {_Link, LocationPositionP},
			Relation -> {Object[Container]|Object[Instrument], Null},
			Description -> "The specific containers and positions in which this container is to be stored, allowing more granular organization within storage locations for this wiring component's storage condition.",
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
			Description -> "The container in which this wiring component is located.",
			Category -> "Storage Information"
		},
		
		Position -> {
			Format -> Single,
			Class -> String,
			Pattern :> LocationPositionP,
			Description -> "The position of this wiring component within the container in which it is located.",
			Category -> "Storage Information"
		},
		
		LocationLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link, String, Link},
			Pattern :> {_?DateObjectQ, In | Out, _Link, _String, _Link},
			Relation -> {Null, Null, Object[Container][ContentsLog, 3] | Object[Instrument][ContentsLog, 3], Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "The location history of the wiring component.",
			Headers -> {"Date","Change Type","Container","Position","Responsible Party"},
			Category -> "Storage Information"
		},
		
		Site -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site],
			Description -> "The ECL site at which this wiring component currently resides.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		SiteLog->{
			Format->Multiple,
			Headers->{"Date", "Site", "Responsible Party"},
			Class->{Date, Link, Link},
			Pattern:>{_?DateObjectQ, _Link, _Link},
			Relation->{Null, Object[Container,Site], Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description->"The site history of the wiring component.",
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
			Description -> "The transaction or protocol that is responsible for generating this wiring component.",
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
			Description -> "All other samples that were received as part of the same kit as this wiring component.",
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
			Pattern :> GreaterP[0*Hour],
			Units -> Hour,
			Description -> "The amount of time this wiring has been used during experiments.",
			Category -> "Operating Limits",
			Abstract -> True
		},
		
		NumberOfUses -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Units -> None,
			Description -> "The number of individual uses that this wiring has been utilized for during experiments.",
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
			Description -> "The list of resource requests for this wiring component that have not yet been Fulfilled.",
			Category -> "Resources",
			Developer -> True
		}
	}
}];
