(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Resource], {
	Description->"An item, instrument, reagent, or service required for the execution of an experiment.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		DateInCart -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date that this resource was placed in cart by a protocol.",
			Category -> "Organizational Information"
		},
		DateRequested -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date that this resource was requested by a protocol.",
			Category -> "Organizational Information"
		},
		DateInUse -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date that this resource was in use by a protocol.",
			Category -> "Organizational Information"
		},
		DateFulfilled -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date that this resource request was fulfilled.",
			Category -> "Organizational Information"
		},
		DateCanceled -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date that this resource request was canceled.",
			Category -> "Organizational Information"
		},
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> ResourceStatusP,
			Description -> "The current status of this resource.",
			Category -> "Resources"
		},
		StatusLog -> {
			Format -> Multiple,
			Class -> {Expression, Expression, Link},
			Pattern :> {_?DateObjectQ, ResourceStatusP, _Link},
			Relation -> {Null, Null, Object[User] | Object[Protocol] | Object[Qualification] | Object[Maintenance]},
			Description -> "Log of the status changes for this resource.",
			Category -> "Resources",
			Headers -> {"Date","Status","Responsible Party"},
			Developer -> True
		},
		Requestor -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol][RequiredResources, 1],
				Object[Qualification][RequiredResources, 1],
				Object[Maintenance][RequiredResources, 1],
				Object[Program][RequiredResources, 1],
				Object[UnitOperation][RequiredResources, 1]
			],
			Description -> "The object that requested this resource.",
			Category -> "Resources"
		},
		Order -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Transaction, Order][Resources],
				Object[Transaction, ShipToECL][Resources],
				Object[Transaction, SiteToSite][Resources]
				],
			Description -> "The transaction object that, when received, will allow this resource to be fulfilled.",
			Category -> "Inventory"
		},
		RootProtocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Protocol][SubprotocolRequiredResources],
				Object[Maintenance][SubprotocolRequiredResources],
				Object[Qualification][SubprotocolRequiredResources]
			],
			Description -> "The root protocol of the protocol that requested this resource.",
			Category -> "Resources"
		},
		LegacyID -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The SLL2 ID for this Object, if it was migrated from the old data store.",
			Category -> "Migration Support",
			Developer -> True
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True
		}
	}
}];
