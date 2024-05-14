(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineObjectType[Object[Notification, Materials], {
	Description -> "A notification pertaining to the creation or acquisition of experimental models or samples.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {

		(* --- Notification Information --- *)
		MaterialsEvent -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> MaterialsEventP,
			Description -> "The type of event relating to acquisition of experimental materials that this notification announces.",
			Abstract -> True,
			Category -> "Notification Information"
		},
		MaterialsRequired -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product],
			Description -> "The items that are needed to continue with experimentation.",
			Abstract -> True,
			Category -> "Notification Information"
		},
		Protocol -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Protocol],
			Description -> "The protocol to which the materials in this notification pertain.",
			Abstract -> True,
			Category -> "Notification Information"
		},
		Transaction -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction],
			Description -> "The transaction to which this notification pertains.",
			Abstract -> True,
			Category -> "Notification Information"
		},
		Requestor -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[User],
			Description -> "User responsible for requesting the Protocol or Order to which this notification pertains.",
			Abstract -> True,
			Category -> "Notification Information"
		},
		ObjectApproved -> {
			Format -> Single, 
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[],Object[Product]],
			Description -> "The Model or Product approved for use in the ECL.",
			Abstract -> True,
			Category -> "Notification Information"
		}
     
	}
}]
