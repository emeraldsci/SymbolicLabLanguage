(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Package], {
	Description->"An object representing an incoming package that does not have corresponding transaction associated with it.",
	CreatePrivileges->None,
	Cache->Download,
	Fields -> {
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Receiving | Available | PickedUp, 
			Description -> "Indicates if this package still in SnR then its is receiving, if it is in the mailbox then available and when its no longer in mailbox then its pickedup.",
			Category -> "Receiving Information",
			Abstract->True
		},
		Recipient -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "The user that the package is addressed to.",
			Category -> "Receiving Information",
			Abstract->True
		},
		RecipientFirstName-> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The user's first name that the package is addressed to.",
			Category -> "Receiving Information"
		},
		RecipientLastName-> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The user's last name that the package is addressed to.",
			Category -> "Receiving Information"
		},
		DateReceived -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _DateObject,
			Description -> "The date this package was checked in through a maintenance receive inventory.",
			Category -> "Receiving Information",
			Abstract->True
		},
		DatePickedUp -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _DateObject,
			Description -> "The date this package was taken out of mailbox by recipient and no longer in mailroom.",
			Category -> "Receiving Information",
			Abstract->True
		},
		Site -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site],
			Description -> "The ECL site at which this package is located.",
			Category -> "Receiving Information",
			Abstract -> True
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
		Container -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container][Contents, 2],
			Description -> "The mailbox in which this package is physically located.",
			Category -> "Receiving Information"
		},
		Receiving -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance,ReceivePackage][Packages],
			Description -> "The receiving protocol which the package was processed from Shipping and Receiving and delivered to the mailbox.",
			Category -> "Receiving Information"
		},
		Size -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> Small|Medium|Large,
			Description -> "The approximate size of the package.",
			Category -> "Receiving Information"
		},
		PackageImages -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Photographs of the package taken during receiving.",
			Category -> "Receiving Information"
		},
		PackageDocumentationImages -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Photographs documents accompanying the package taken during receiving.",
			Category -> "Receiving Information"
		},
		AsanaTaskID-> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "ID numbers of the Asana task created for the package.",
			Category -> "Receiving Information"
		},
		ReturnAddress-> {
			Format -> Single,
			Class -> String,
			Pattern :> StreetAddressP,
			Description -> "The return street address of where package was shipped from (just the local road and street number, and any unit numbers only).",
			Category -> "Sender Information"
		},
		ReturnAddress2 -> {
			Format -> Single,
			Class -> String,
			Pattern :> StreetAddressP,
			Description -> "An optional second line for the return street address where packages were shipped from.",
			Category -> "Sender Information"
		},
		ReturnAddressCity-> {
			Format -> Single,
			Class -> String,
			Pattern :> CityP,
			Description ->"The city of the return address of where this packages were shipped from.",
			Category -> "Sender Information"
		},
		ReturnAddressState-> {
			Format -> Single,
			Class -> String,
			Pattern :> UnitedStateAbbreviationP,
			Description -> "The US state of the return address of where the packages were shipped from.",
			Category -> "Sender Information"
		},
		ReturnAddressZIPCode-> {
			Format -> Single,
			Class -> String,
			Pattern :> ZIPCodeP,
			Description -> "The ZIP code of the return address of where the packages were shipped from.",
			Category -> "Sender Information"
		},
		Supplier -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Company, Supplier],
			Description -> "The Company that sent this package.",
			Category -> "Sender Information"
		},
		Shipper -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Company, Shipper],
			Description -> "The shipping company used to deliver the package to this site.",
			Category -> "Sender Information"
		},
		TrackingNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Tracking numbers provided by the shipping company on the package.",
			Category -> "Sender Information"
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		},
		LocationLog -> {
			Format -> Multiple,
			Class -> {Date, Expression, Link, String, Link},
			Pattern :> {_?DateObjectQ, In | Out, _Link, _String, _Link},
			Relation -> {Null, Null, Object[Container][ContentsLog, 3], Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "The location history of the container. Lines recording a movement to container and position of Null, Null respectively indicate the item being discarded.",
			Category -> "Receiving Information",
			Headers ->{"Date","Change Type","Container","Position","Responsible Party"}
		},
		Position -> {
			Format -> Single,
			Class -> String,
			Pattern :> LocationPositionP,
			Description -> "The position of the package within its Container.",
			Category -> "Receiving Information"
		},
		CurrentProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance][Resources],
			Description -> "The maintenance that is currently using this package.",
			Category -> "Receiving Information",
			Abstract -> True
		},
		CurrentSubprotocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance],
			Description -> "The specific protocol or subprotocol that is currently using this package.",
			Category -> "Receiving Information",
			Developer -> True
		},
		StatusLog -> {
			Format -> Multiple,
			Class -> {Expression, Expression, Link},
			Pattern :> {_?DateObjectQ, SampleStatusP, _Link},
			Relation -> {Null, Null, Object[User] |Object[Maintenance]},
			Description -> "A log of changes made to the package's status.",
			Headers -> {"Date","Status","Responsible Party"},
			Category -> "Receiving Information",
			Developer -> True
		},
		DateLastUsed -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "Date this package was last handled in any way.",
			Category -> "Inventory"
		},
		CommentLog -> {
			Format -> Multiple,
			Class -> {Date, Link, String},
			Pattern :> {_?DateObjectQ, _Link, _String},
			Relation -> {Null, Object[User], Null},
			Description -> "A log of all the comments about the troubleshooting.",
			Category -> "Receiving Information",
			Headers -> {"Date","Person Commenting","Comment"}
		},
		AttachmentLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[User], Object[EmeraldCloudFile]},
			Description -> "A log of the additional supporting material describing this troubleshooting.",
			Category -> "Receiving Information",
			Headers -> {"Date","Person Attaching","Attachment"}
		},
		StoragePositions->{
			Format -> Multiple,
			Class -> {Link, String},
			Pattern :> {_Link, LocationPositionP},
			Relation -> {Object[Container]|Object[Instrument], Null},
			Description -> "The specific containers and positions in which plumbing components of this model are stored, allowing more granular organization within storage locations for this plumbing's default storage condition.",
			Category -> "Storage Information",
			Headers->{"Storage Container", "Storage Position"},
			Developer -> True
		},
		AwaitingDisposal -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if this plumbing component is marked for disposal once it is no longer required for any outstanding experiments.",
			Category -> "Storage Information"
		},
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
		Source -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Maintenance],
			Description -> "The transaction or protocol that is responsible for generating this plumbing component.",
			Category -> "Inventory"
		},
		DisposalLog -> {
			Format -> Multiple,
			Class -> {Expression, Boolean, Link},
			Pattern :> {_?DateObjectQ, BooleanP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Maintenance] | Object[Qualification]},
			Description -> "A log of changes made to when this item is marked as awaiting disposal by the AwaitingDisposal Boolean.",
			Headers -> {"Date","Awaiting Disposal","Responsible Party"},
			Category -> "Storage Information"
		},

		NewStickerPrinted -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if a new sticker with a hashphrase has been printed for this object and therefore the hashphrase should be shown in engine when scanning the object.",
			Category -> "Migration Support",
			Developer -> True
		}
	}
}];
