

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Report, Receipt], {
	Description->"A report storing paperwork involved in a shipping or receiving transaction.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		Supplier -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Company, Supplier][Receipts],
			Description -> "The supplier company for this order.",
			Category -> "Product Specifications",
			Abstract -> True
		},
		ConfirmationEmails -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Confirmation emails associated with this supplier order.",
			Category -> "Order Activity"
		},
		Invoices -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Invoices associated with this supplier order.",
			Category -> "Order Activity"
		},
		PurchaseOrders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Purchase orders associated with this supplier order.",
			Category -> "Order Activity"
		},
		PackingSlips -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Packing slips associated with this supplier order.",
			Category -> "Order Activity"
		},
		OtherDocumentation -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Any other documentation related to this supplier order.",
			Category -> "Order Activity"
		},
		ConfirmationNumber -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "Vendor provided confirmation number for a supplier order.",
			Category -> "Order Activity"
		},
		Transactions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction][Receipt],
			Description -> "Transactions that are fulfilled by this supplier order.",
			Category -> "Order Activity",
			Abstract -> True
		}
	}
}];
