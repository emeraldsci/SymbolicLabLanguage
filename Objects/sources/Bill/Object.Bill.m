(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(*---------------------*)
(* If you add new fields that are shared with Model[Pricing] add them to the list $SharedPricingFields *)
(*---------------------*)
DefineObjectType[Object[Bill], {
	Description -> "Summary information for all of the fees for a billing cycle.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		PricingScheme -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Model[Pricing],
			Description -> "The column join that best connects a column to this guard column.",
			Category -> "Organizational Information",
			Abstract -> True,
			AdminWriteOnly -> True
		},
		Organization -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Team, Financing][BillingHistory, 2],
			Description -> "The team executing the experiments and material usage.",
			Category -> "Organizational Information",
			Abstract -> True,
			AdminWriteOnly -> True
		},
		Site -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site],
			Description -> "The ECL site where the work in this Bill has been done.",
			Category -> "Organizational Information"
		},
		DateStarted -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The starting day and time of the billing cycle.",
			Category -> "Organizational Information",
			Abstract -> True,
			AdminWriteOnly -> True
		},
		DateCompleted -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The final date and time of the billing cycle.",
			Category -> "Organizational Information",
			Abstract -> True,
			AdminWriteOnly -> True
		},
		Status -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BillStatusP, (*Open|Paid|Outstanding|Invoiced*)
			Description -> "The current status of the bill.",
			Category -> "Pricing Information",
			Abstract -> True,
			AdminWriteOnly -> True
		},
		PlanType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SubscriptionTypeP, (*Subscription|AlaCarte*)
			Description -> "Whether the account is continuous across many months (Subscription) or running ad hoc experiments without long-term commitment (AlaCarte).",
			Category -> "Organizational Information",
			AdminWriteOnly -> True
		},
		AccountType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AccountTypeP, (*Enterprise|Academia|Startup*)
			Description -> "Type of the organization this pricing model is used for.",
			Category -> "Organizational Information",
			AdminWriteOnly -> True
		},
		CommitmentLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[1 Month, 1 Month](*1 Month|3 Month|1 Year*),
			Units -> Month,
			Description -> "The commitment duration of the current account.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		NumberOfBaselineUsers -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			Description -> "The quantity of users available at the SoftwareBasePrice.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		CommandCenterPrice -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The amount charged by the ECL per additional user beyond the baseline amount.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		NumberOfAdditionalUsers -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			Description -> "The additional users on the account beyond the NumberOfBaselineUsers.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		ConstellationPrice -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD / (10^6 Unit) ],
			Units -> USD / (10^6 Unit),
			Description -> "The amount charged by the ECL for every million items stored in the Constellation database.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		ConstellationUsage -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0],
			Description -> "The number of objects stored in the ECL Constellation for this account, calculated on DateCompleted.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		ConstellationStorage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The charge for data storage as assessed at the current date or at the end of the billing period.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		IncludedConstellationStorage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * (10^6 Unit)],
			Units -> 10^6 Unit,
			Description -> "The number of stored database objects not subject to fees.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		NumberOfThreads -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The overall usage of ECL laboratory and operator resources afforded by this specific pricing scheme.",
			Category -> "Organizational Information",
			AdminWriteOnly -> True
		},
		LabAccessFee -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The amount charged to access ECL.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		SubscriptionDiscounts -> {
			Format -> Multiple,
			Class -> {Real, String},
			Pattern :> {GreaterEqualP[0 * USD], _String},
			Units -> {USD, None},
			Description -> "Discounts applied towards the LabAccessFee.",
			Headers -> {"Credit","Description"},
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},

		MaterialPurchases -> {
			Format -> Multiple,
			Headers -> {
				(*1*)"Date Purchased",
				(*2*)"Materials",
				(*3*)"Protocol/Transaction",
				(*4*)"Notebook",
				(*5*)"Amount",
				(*6*)"Price Per Unit",
				(*7*)"Total Cost"
			},
			Class -> {
				(*1*)Expression,
				(*2*)Link,
				(*3*)Link,
				(*4*)Link,
				(*5*)VariableUnit,
				(*6*)VariableUnit,
				(*7*)Real
			},
			Pattern :> {
				(*1*)_?DateObjectQ,
				(*2*)_Link,
				(*3*)_Link,
				(*4*)_Link,
				(*5*)GreaterEqualP[0 * Milliliter] | GreaterEqualP[0 * Gram] | GreaterEqualP[0 * Unit] | GreaterEqualP[0],
				(*6*)GreaterEqualP[0 * USD / Milliliter] | GreaterEqualP[0 * USD / Gram] | GreaterEqualP[0 * USD / Unit] | GreaterEqualP[0 * USD],
				(*7*)GreaterEqualP[0 * USD]
			},
			Relation -> {
				(*1*)Null,
				(*2*)Object[Sample] | Object[Container] | Object[Item] | Model[Sample] | Model[Container] | Model[Item] | Object[Product],
				(*3*)Object[Protocol] | Object[Transaction],
				(*4*)Object[LaboratoryNotebook],
				(*5*)Null,
				(*6*)Null,
				(*7*)Null
			},
			Units -> {
				(*1*)None,
				(*2*)None,
				(*3*)None,
				(*4*)None,
				(*5*)None,
				(*6*)None,
				(*7*)USD
			},
			Description -> "History of experiments performed for this billing cycle.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},

		PricePerExperiment -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The amount charged by the ECL for each protocol run in the facility.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		PricePerPriorityExperiment -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The amount charged by the ECL for each priority protocol run in the facility that exceed IncludedPriorityProtocols.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		IncludedPriorityProtocols -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of free priority protocols not subject to PricePerPriorityExperiment.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		ExperimentsCharged -> {
			Format -> Multiple,
			Headers -> {"Protocol", "Date Completed", "Protocol Author", "Priority", "Price", "Charge"},
			Class -> {Link, Expression, Link, Expression, Real, Real},
			Pattern :> {_Link, _?DateObjectQ, _Link, BooleanP, GreaterEqualP[0 * USD], GreaterEqualP[0 * USD]},
			Units -> {None, None, None, None, USD, USD},
			Relation -> {Object[Protocol], Null, Object[User], Null, Null, Null},
			Description -> "History of experiments performed for this billing cycle.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},

		OperatorTimePrice -> {
			Format -> Multiple,
			Headers -> {"Qualification Level", "Price per hour"},
			Class -> {Integer, Real},
			Pattern :> {_Integer, GreaterEqualP[0 * USD / Hour]},
			Units -> {None, USD / Hour},
			Description -> "The amount charged by the ECL for operator time per hour based on the QualificationLevel.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		OperatorPriorityTimePrice -> {
			Format -> Multiple,
			Headers -> {"Qualification Level", "Price per hour"},
			Class -> {Integer, Real},
			Pattern :> {_Integer, GreaterEqualP[0 * USD / Hour]},
			Units -> {None, USD / Hour},
			Description -> "The amount charged by the ECL for operator time on priority protocols based on the QualificationLevel.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		OperatorTimeCharges -> {
			Format -> Multiple,
			Headers -> {
				(*1*)"Date Completed",
				(*2*)"Protocol",
				(*3*)"Operator Model",
				(*5*)"Operator Time",
				(*6*)"Discounted Time",
				(*7*)"Charge"
			},
			Class -> {
				(*1*)Expression,
				(*2*)Link,
				(*3*)String,
				(*5*)Real,
				(*6*)Real,
				(*7*)Real
			},
			Pattern :> {
				(*1*)_?DateObjectQ,
				(*2*)_Link,
				(*3*)_String,
				(*5*)GreaterEqualP[0 * Hour],
				(*6*)GreaterEqualP[0 * Hour],
				(*7*)GreaterEqualP[0 * USD]
			},
			Relation -> {
				(*1*)Null,
				(*2*)Object[Protocol],
				(*3*)Null,
				(*5*)Null,
				(*6*)Null,
				(*7*)Null
			},
			Units -> {
				(*1*)None,
				(*2*)None,
				(*3*)None,
				(*5*)Hour,
				(*6*)Hour,
				(*7*)USD
			},
			Description -> "History of operator performing experiments for this account for this billing cycle.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},

		IncludedInstrumentHours -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "The number of free hours available each month not subject to InstrumentPricing.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		InstrumentPricing -> {
			Format -> Multiple,
			Headers -> {"Tier", "Price per hour"},
			Class -> {Integer, Real},
			Pattern :> {GreaterEqualP[1, 1], GreaterEqualP[0 * USD / Hour]},
			Units -> {None, USD / Hour},
			Description -> "The amount charged by the ECL for instrument time based on the tier level.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		InstrumentTimeCharges -> {
			Format -> Multiple,
			Headers -> {
				(*1*)"Date Completed",
				(*2*)"Protocol",
				(*3*)"Instrument",
				(*4*)"Instrument Tier",
				(*5*)"Instrument Time",
				(*6*)"Discounted Time",
				(*7*)"Charge"
			},
			Class -> {
				(*1*)Expression,
				(*2*)Link,
				(*3*)Link,
				(*4*)Integer,
				(*5*)Real,
				(*6*)Real,
				(*7*)Real
			},
			Pattern :> {
				(*1*)_?DateObjectQ,
				(*2*)_Link,
				(*3*)_Link,
				(*4*)GreaterEqualP[1, 1],
				(*5*)GreaterEqualP[0 * Hour],
				(*6*)GreaterEqualP[0 * Hour],
				(*7*)GreaterEqualP[0 * USD]
			},
			Relation -> {
				(*1*)Null,
				(*2*)Object[Protocol],
				(*3*)Object[Instrument],
				(*4*)Null,
				(*5*)Null,
				(*6*)Null,
				(*7*)Null
			},
			Units -> {
				(*1*)None,
				(*2*)None,
				(*3*)None,
				(*4*)None,
				(*5*)Hour,
				(*6*)Hour,
				(*7*)USD
			},
			Description -> "History of instruments performing experiments for this account for this billing cycle.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},

		IncludedCleanings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of free occasions to clean items (e.g. dishwash glassware) not subject to cleaning fees.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		CleanUpPricing -> {
			Format -> Multiple,
			Class -> {Expression, Real},
			Pattern :> {CleaningP, GreaterEqualP[0 * USD]},
			Units -> {None, USD},
			Description -> "The amount charged by the ECL for cleaning dishware and materials based on the type of cleaning.",
			Headers -> {"Cleaning Type", "Price per Item"},
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		CleanUpCharges -> {
			Format -> Multiple,
			Headers -> {
				(*2*)"Date Cleaned",
				(*1*)"Material Cleaned",
				(*3*)"Associated Protocol/Maintenance",
				(*4*)"Cleaning Type",
				(*5*)"Price",
				(*6*)"Charge"
			},
			Class -> {
				(*1*)Expression,
				(*2*)Link,
				(*3*)Link,
				(*4*)Expression,
				(*5*)Real,
				(*6*)Real
			},
			Pattern :> {
				(*1*)_?DateObjectQ,
				(*2*)_Link,
				(*3*)_Link,
				(*4*)CleaningP,
				(*5*)GreaterEqualP[0 * USD],
				(*6*)GreaterEqualP[0 * USD]
			},
			Relation -> {
				(*1*)Null,
				(*2*)Object[Sample] | Object[Container] | Object[Item],
				(*3*)Object[Protocol] | Object[Maintenance],
				(*4*)Null,
				(*5*)Null,
				(*6*)Null
			},
			Units -> {
				(*1*)None,
				(*2*)None,
				(*3*)None,
				(*4*)None,
				(*5*)USD,
				(*6*)USD
			},
			Description -> "History of clean ups for this account for this billing cycle.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},

		IncludedStockingFees -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The price of free stocking not subject to fees.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		StockingPricing -> {
			Format -> Multiple,
			Headers -> {"Storage Condition", "Price Per Volume"},
			Class -> {Link, Real},
			Relation -> {
				Model[StorageCondition],
				Null
			},
			Pattern :> {
				_Link,
				GreaterEqualP[0 USD / Centimeter^3]
			},
			Units -> {None, USD / Centimeter^3},
			Description -> "The amount charged by the ECL for stocking items based on the frequency of usage and space taken up.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		StockingCharges -> {
			Format -> Multiple,
			Headers -> {
				(*2*)"Material Stocked",
				(*3*)"Volume",
				(*4*)"Stocking Protocol/Maintenance",
				(*5*)"Storage Condition",
				(*6*)"Price",
				(*7*)"Discount",
				(*8*)"Charge"
			},
			Class -> {
				(*2*)Link,
				(*3*)VariableUnit,
				(*4*)Link,
				(*5*)Link,
				(*6*)Real,
				(*7*)Real,
				(*8*)Real
			},
			Pattern :> {
				(*2*)_Link,
				(*3*)GreaterEqualP[0 * Centimeter^3] | GreaterEqualP[0 * Gram] | GreaterEqualP[0 * Liter],
				(*4*)_Link,
				(*5*)_Link,
				(*6*)GreaterEqualP[0 * USD],
				(*7*)GreaterEqualP[0 * USD],
				(*8*)GreaterEqualP[0 * USD]
			},
			Relation -> {
				(*2*)Object[Sample] | Object[Container] | Object[Item],
				(*3*)Null,
				(*4*)Object[Protocol] | Object[Maintenance] | Object[Transaction],
				(*5*)Model[StorageCondition],
				(*6*)Null,
				(*7*)Null,
				(*8*)Null
			},
			Units -> {
				(*2*)None,
				(*3*)None,
				(*4*)None,
				(*5*)None,
				(*6*)USD,
				(*7*)USD,
				(*8*)USD
			},
			Description -> "History of stocking materials for this account for this billing cycle.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},

		IncludedWasteDisposalFees -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The price of waste disposal not subject to fees for this billing cycle.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		WastePricing -> {
			Format -> Multiple,
			Headers -> {"Waste Type", "Disposal cost"},
			Class -> {Expression, Real},
			Pattern :> {WasteTypeP, GreaterEqualP[0 * USD / (Kilo * Gram)]},
			Units -> {None, USD / (Kilo * Gram)},
			Description -> "The amount charged by the ECL for disposing waste.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		WasteDisposalCharges -> {
			Format -> Multiple,
			Headers -> {
				(*1*)"Date Disposed",
				(*3*)"Associated Protocol",
				(*4*)"Waste Type",
				(*5*)"Price",
				(*6*)"Charge"
			},
			Class -> {
				(*1*)Expression,
				(*3*)Link,
				(*4*)Expression,
				(*5*)Real,
				(*6*)Real
			},
			Pattern :> {
				(*1*)_?DateObjectQ,
				(*3*)_Link,
				(*4*)WasteTypeP,
				(*5*)GreaterEqualP[0 * USD],
				(*6*)GreaterEqualP[0 * USD]
			},
			Relation -> {
				(*1*)Null,
				(*3*)Object[Protocol] | Object[Maintenance],
				(*4*)Null,
				(*5*)Null,
				(*6*)Null
			},
			Units -> {
				None,
				None,
				None,
				USD,
				USD
			},
			Description -> "History of waste disposal for this account for this billing cycle.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},

		IncludedStorage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Kilo * Centimeter^3],
			Units -> Kilo * Centimeter^3,
			Description -> "The amount of storage not subject to fees for this billing cycle.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		StoragePricing -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterEqualP[0 * USD / (Centimeter^3 * Hour)]},
			Relation -> {Model[StorageCondition], Null},
			Units -> {None, USD / (Centimeter^3 * Hour)},
			Description -> "The amount charged by the ECL for storing materials for this billing cycle.",
			Headers -> {"Storage Condition", "Price per cubic centimeter per month"},
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		StorageCharges -> {
			Format -> Multiple,
			Headers -> {
				(*1*)"Date Last Used",
				(*2*)"Material",
				(*3*)"Origin",
				(*4*)"Storage Condition",
				(*5*)"Capacity Taken",
				(*6*)"Time in storage",
				(*7*)"Price",
				(*8*)"Discount",
				(*9*)"Charge"
			},
			Class -> {
				(*1*)Expression,
				(*2*)Link,
				(*3*)Link,
				(*4*)String,
				(*5*)Real,
				(*6*)Real,
				(*7*)Real,
				(*8*)Real,
				(*9*)Real
			},
			Pattern :> {
				(*1*)_?DateObjectQ,
				(*2*)_Link,
				(*3*)_Link,
				(*4*)_String,
				(*5*)GreaterEqualP[0 * Centimeter^3],
				(*6*)GreaterEqualP[0 * Hour],
				(*7*)GreaterEqualP[0 * USD],
				(*8*)GreaterEqualP[0 * USD],
				(*9*)GreaterEqualP[0 * USD]
			},
			Relation -> {
				(*1*)Null,
				(*2*)Object[Sample] | Object[Container] | Object[Item],
				(*3*)Object[Protocol] | Object[Maintenance] | Object[Transaction],
				(*4*)Null,
				(*5*)Null,
				(*6*)Null,
				(*7*)Null,
				(*8*)Null,
				(*9*)Null
			},
			Units -> {
				(*1*)None,
				(*2*)None,
				(*3*)None,
				(*4*)None,
				(*5*)Centimeter^3,
				(*6*)Hour,
				(*7*)USD,
				(*8*)USD,
				(*9*)USD
			},
			Description -> "Current storage summary for this account for this billing cycle.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},

		IncludedShipmentFees -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The price of shipments not subject to fees.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		ShippingCharges -> {
			Format -> Multiple,
			Headers -> {
				(*1*)"Date of Shipment",
				(*2*)"Shipment",
				(*3*)"Shipment Weight",
				(*4*)"Price",
				(*5*)"Tax",
				(*6*)"Discount",
				(*7*)"Charge"
			},
			Class -> {
				(*1*)Expression,
				(*2*)Link,
				(*3*)Real,
				(*4*)Real,
				(*5*)Real,
				(*6*)Real,
				(*7*)Real
			},
			Pattern :> {
				(*1*)_?DateObjectQ,
				(*2*)_Link,
				(*3*)GreaterEqualP[0 * Kilo * Gram],
				(*4*)GreaterEqualP[0 * USD],
				(*5*)GreaterEqualP[0 * USD],
				(*6*)GreaterEqualP[0 * USD],
				(*7*)GreaterEqualP[0 * USD]
			},
			Relation -> {
				(*1*)Null,
				(*2*)Object[Transaction],
				(*3*)Null,
				(*4*)Null,
				(*5*)Null,
				(*6*)Null,
				(*7*)Null
			},
			Units -> {
				(*1*)None,
				(*2*)None,
				(*3*)Kilo * Gram,
				(*4*)USD,
				(*5*)USD,
				(*6*)USD,
				(*7*)USD
			},
			Description -> "Current shipment summary for this account for this billing cycle.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},

		CertificationCharges -> {
			Format -> Multiple,
			Headers -> {
				(*1*)"Date of Certification",
				(*2*)"Certified User",
				(*3*)"Certification Level",
				(*4*)"Charge"
			},
			Class -> {
				(*1*)Expression,
				(*2*)Link,
				(*3*)Expression,
				(*4*)Real
			},
			Pattern :> {
				(*1*)_?DateObjectQ,
				(*2*)_Link,
				(*3*)CertificationLevelP,
				(*4*)GreaterEqualP[0 * USD]
			},
			Relation -> {
				(*1*)Null,
				(*2*)Object[User],
				(*3*)Null,
				(*4*)Null
			},
			Units -> {
				None,
				None,
				None,
				USD
			},
			Description -> "Current certification summary for this account for this billing cycle.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},

		PrivateTutoringFee -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The amount charged by the ECL for office hours for this billing cycle.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},

		SubtotalCharges -> {
			Format -> Multiple,
			Headers -> {"Category", "Charge"},
			Class -> {String, Real},
			Pattern :> {_String, GreaterEqualP[0 * USD]},
			Units -> {None, USD},
			Description -> "Subtotal charges for each billing category.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		TotalCharge -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 USD],
			Units -> USD,
			Description -> "The estimated total charge incurred on this bill to date or at closing. This value is an estimate and may not reflect the final invoice.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		BillSummaryNotebook -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "The formatted, summarized charges for this billing cycle.",
			Category -> "Analysis & Reports",
			Abstract -> True,
			AdminWriteOnly -> True
		},
		BillSummaryNotebookPDF -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[EmeraldCloudFile],
			Description -> "A PDF version of BillSummaryNotebook.",
			Category -> "Analysis & Reports",
			AdminWriteOnly -> True
		},
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True,
			AdminWriteOnly -> True
		}
	}
}];