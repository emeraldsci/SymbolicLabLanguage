

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Report, Inventory], {
	Description->"A nightly report of inventory statistics.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {
		
		StartDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The start date for the date range over which this report reviews the inventory for changes.",
			Category -> "Organizational Information"
		},
		DateRange -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[DateCreated], Field[StartDate]}, {Field[StartDate], Field[DateCreated]}],
			Pattern :> {_?DateObjectQ, _?DateObjectQ},
			Description -> "The date range over which this report reviews inventory activity.",
			Category -> "Organizational Information",
			Abstract -> True
		},
		TimeElapsed -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterP[0*Second],
			Units -> Second,
			Description -> "The time it took to evaluate the inventory.",
			Category -> "Organizational Information"
		},
		NumberOfProductsReviewed -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[ProductReviewData]}, Length[Field[ProductReviewData]]],
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of products reviewed in this report.",
			Category -> "Inventory"
		},
		ProductReviewData -> {
			Format -> Multiple,
			Class -> {Link, Expression, Expression, Expression},
			Pattern :> {_Link, GreaterEqualP[0, 1], GreaterEqualP[0, 1], GreaterEqualP[0, 1]},
			Relation -> {Object[Product], Null, Null, Null},
			Units -> {None, None, None, None},
			Description -> "A list of product quantity data: each entry is a sublist in the form: {Product, Sample Quantity Stocked, Sample Quantity Ordered, Minimum Sample Quantity Threshold}.",
			Headers -> {"Product", "Sample Quantity Stocked", "Sample Quantity Ordered", "Minimum Sample Quantity Threshold"},
			Category -> "Inventory"
		},
		NumberOfIncompleteProducts -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[IncompleteProducts]}, Length[Field[IncompleteProducts]]],
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of products that are incomplete and were not reviewed.",
			Category -> "Inventory"
		},
		IncompleteProducts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Product],
			Description -> "A list of products that do not have enough information to meet the requirements for completeness and were not reviewed.",
			Category -> "Inventory"
		},
		NumberOfAutomaticallyGeneratedOrders -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[AutomaticallyGeneratedOrders]}, Length[Field[AutomaticallyGeneratedOrders]]],
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of automatically generated orders that were newly requested within the date range of this report.",
			Category -> "Order Activity"
		},
		AutomaticallyGeneratedOrders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction],
			Description -> "A list of orders that were generated automatically within the date range of this report.",
			Category -> "Order Activity",
			Abstract -> True
		},
		NumberOfIndividuallyRequestedOrders -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[IndividuallyRequestedOrders]}, Length[Field[IndividuallyRequestedOrders]]],
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of individually requested orders that were newly requested within the date range of this report.",
			Category -> "Order Activity"
		},
		IndividuallyRequestedOrders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction],
			Description -> "A list of orders that were requested by individuals within the date range of this report.",
			Category -> "Order Activity",
			Abstract -> True
		},
		NumberOfReceivedOrders -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[ReceivedOrders]}, Length[Field[ReceivedOrders]]],
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of orders that were received within the date range of this report.",
			Category -> "Order Activity"
		},
		ReceivedOrders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction],
			Description -> "A list of orders that were received within the date range of this report.",
			Category -> "Order Activity"
		},
		NumberOfCanceledOrders -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[CanceledOrders]}, Length[Field[CanceledOrders]]],
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of orders that were canceled within the date range of this report.",
			Category -> "Order Activity"
		},
		CanceledOrders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction],
			Description -> "A list of orders that were canceled within the date range of this report.",
			Category -> "Order Activity"
		},
		NumberOfOpenOrders -> {
			Format -> Computable,
			Expression :> SafeEvaluate[{Field[OpenOrders]}, Length[Field[OpenOrders]]],
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of orders that remain open at the end date of this report.",
			Category -> "Order Activity"
		},
		OpenOrders -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Transaction],
			Description -> "A list of orders that remain open at the end date of this report.",
			Category -> "Order Activity",
			Abstract -> True
		}
	}
}];
