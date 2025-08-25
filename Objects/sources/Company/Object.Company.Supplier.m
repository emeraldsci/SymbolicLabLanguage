

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineObjectType[Object[Company, Supplier], {
	Description->"A company that supplies reagents, consumables, sensors, or instruments.",
	CreatePrivileges->None,
	Cache->Session,
	Fields -> {

		Transactions -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Transaction, Order][Supplier],
				Object[Transaction, DropShipping][Provider]
			],
			Description -> "A list of order transactions placed with the supplier company.",
			Category -> "Order Activity"
		},
		Receipts -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Report, Receipt][Supplier],
			Description -> "A list of receipt reports for orders placed with the supplier company.",
			Category -> "Order Activity",
			Developer -> True
		},
		Products -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[
				Object[Product][Supplier],
				Object[Product][Manufacturer]
			],
			Description -> "Products offered by this supplier.",
			Category -> "Product Specifications"
		},
		InstrumentsManufactured -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Instrument][Manufacturer],
			Description -> "Instruments manufactured by this supplier.",
			Category -> "Product Specifications"
		},
		SensorsManufactured -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Sensor][Manufacturer],
			Description -> "Sensors manufactured by this supplier.",
			Category -> "Product Specifications"
		},
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SupplierStatusP,
			Description -> "The current operational effectiveness of this supplier.",
			Category -> "Organizational Information"
		},
		AccountTransfer -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Company,Supplier],
			Description -> "The company which now acts as the supplier for this company as a result of a merger or acquisition or other transfer process.",
			Category -> "Organizational Information"
		},
		Disputes -> {
			Format -> Multiple,
			Class -> {Expression, Expression, Expression, String},
			Pattern :> {_DateObject,DisputeStatusP,DisputeP,_String},
			Relation -> {Null, Null, Null, Null},
			Description -> "A log of conflicts made with this supplier.",
			Headers -> {"Date", "Status", "Type","Description"},
			Category -> "Organizational Information"
		},
		ActiveSupplierQualityAgreement -> {
			Format -> Single,
			Class -> Boolean,
			Pattern :> BooleanP,
			Description -> "Indicates if there exists an active agreement with this supplier regarding quality of their products.",
			Category -> "Organizational Information"
		},
		SupplierQualityAgreements -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "Any active quality agreement documents.",
			Category -> "Organizational Information"
		},
		EmployeeContacts -> {
			Format -> Multiple,
			Class -> {
				Status -> Date,
				Role -> Expression,
				ServicedSite -> Link,
				Email -> String,
				Phone -> String,
				FirstName -> String,
				LastName -> String
			},
			Pattern :> {
				Status -> UserStatusP,
				Role -> SupplierRoleP,
				ServicedSite -> _Link,
				Email -> EmailP,
				Phone -> PhoneNumberP,
				FirstName -> _String,
				LastName -> _String
			},
			Relation -> {
				Status -> Null,
				Role -> Null,
				ServicedSite -> Object[Container,Site],
				Email -> Null,
				Phone -> Null,
				FirstName -> Null,
				LastName -> Null
			},
			Headers -> {
				Status -> "Status",
				Role -> "Role",
				ServicedSite -> "Serviced Site",
				Email -> "Email",
				Phone -> "Phone",
				FirstName -> "First Name",
				LastName -> "Last Name"
			},
			Description -> "A record of all employees with whom Emerald has interacted.",
			Category -> "Organizational Information"
		},
		PreferredContainers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Container][ServiceProviders],
			Description -> "Known container models that this company tends to ship the samples they supply in.",
			Category -> "Organizational Information"
		},
		PreferredCovers -> {
			Format -> Multiple,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Alternatives[Model[Item, Cap], Model[Item, Lid]],
			Description -> "Known cover models (caps, lids) that this company tends to use to seal containers they supply.",
			Category -> "Organizational Information"
		},
		TransactionLog -> {
			Format -> Multiple,
			Class -> {
				Status -> Expression,
				DateOrdered -> Date,
				Transaction -> Link,
				OriginalDeliveryEstimate -> Date,
				MostRecentDeliveryEstimate -> Date,
				DateReceived -> Date,
				Backordered -> Boolean
			},
			Pattern :> {
				Status -> Outstanding | Delivered,
				DateOrdered -> _DateObject,
				Transaction -> _Link,
				OriginalDeliveryEstimate -> _DateObject,
				MostRecentDeliveryEstimate -> _DateObject,
				DateReceived -> _DateObject,
				Backordered -> BooleanP
			},
			Relation -> {
				Status -> Null,
				DateOrdered -> Null,
				Transaction -> Object[Transaction],
				OriginalDeliveryEstimate -> Null,
				MostRecentDeliveryEstimate -> Null,
				DateReceived -> Null,
				Backordered -> Null
			},
			Headers -> {
				Status -> "Status",
				DateOrdered -> "Date Ordered",
				Transaction -> "Transaction",
				OriginalDeliveryEstimate -> "Original Delivery Estimate",
				MostRecentDeliveryEstimate -> "Most Recent Delivery Estimate",
				DateReceived -> "Date Received",
				Backordered -> "Backordered"
			},
			Description -> "A record of all transactions with this supplier.",
			Category -> "Organizational Information"
		},
		(* Instrument maintenances *)
		RepairLog -> {
			Format -> Multiple,
			Class -> {Date, Link, Link},
			Pattern :> {_?DateObjectQ, _Link, _Link},
			Relation -> {Null, Object[Repair][Vendor], Object[Instrument][RepairLog, 3]},
			Description -> "A record of any off-protocol maintenances performed on instruments to return them to full functionality.",
			Headers -> {"Date", "Repair", "Instrument"},
			Category -> "Qualifications & Maintenance"
		}
	}
}];
