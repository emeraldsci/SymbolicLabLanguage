(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(*---------------------*)
(* If you add new fields that are shared with Model[Pricing] add them to the $SharedPricingFields *)
(*---------------------*)
DefineObjectType[Model[Pricing], {
	Description -> "Model information of a client pricing scheme for a billing cycle.",
	CreatePrivileges -> None,
	Cache -> Session,
	Fields -> {
		PricingPlanName -> {
			Format -> Single,
			Class -> String,
			Pattern :> _String,
			Description -> "The name given to this pricing scheme.",
			Category -> "Organizational Information",
			Abstract -> True,
			AdminWriteOnly->True
		},
		Site -> {
			Format -> Single,
			Class -> Link,
			Pattern :> _Link,
			Relation -> Object[Container,Site],
			Description -> "The ECL site for which this Model describes usage rates.",
			Category -> "Organizational Information"
		},
		PlanType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> SubscriptionTypeP, (*Subscription|AlaCarte*)
			Description -> "Whether the account is continuous across many months (Subscription) or running ad hoc experiments without long-term commitment (AlaCarte).",
			Category -> "Organizational Information",
			AdminWriteOnly->True
		},
		AccountType -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> AccountTypeP, (*Enterprise|Academia|Startup*)
			Description -> "Type of the organization this pricing model is used for.",
			Category -> "Organizational Information",
			AdminWriteOnly->True
		},

		LoginActivationDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date on which this pricing scheme grants members of the associated financing team access to ECL systems such as Command Center and data in Constellation.",
			Category -> "Organizational Information",
			AdminWriteOnly->True
		},
		StorageActivationDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date on which this pricing scheme grants the associated financing team access to storage at ECL facilities.",
			Category -> "Organizational Information",
			AdminWriteOnly->True
		},
		ThreadActivationDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date on which this pricing scheme grants the associated financing team capacity to run experiments at ECL facilities.",
			Category -> "Organizational Information",
			AdminWriteOnly->True
		},
		ThreadDeactivationDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date past which this pricing scheme no longer grants the associated financing team capacity to run experiments at ECL facilities.",
			Category -> "Organizational Information",
			AdminWriteOnly->True
		},
		LoginDeactivationDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date past which this pricing scheme no longer grants members of the associated financing team access to ECL systems such as Command Center and data in Constellation.",
			Category -> "Organizational Information",
			AdminWriteOnly->True
		},
		StorageDeactivationDate -> {
			Format -> Single,
			Class -> Date,
			Pattern :> _?DateObjectQ,
			Description -> "The date past which this pricing scheme no longer grants the associated financing team access to storage at ECL facilities.",
			Category -> "Organizational Information",
			AdminWriteOnly->True
		},

		CommitmentLength -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[1 Month, 1 Month],
			Units -> Month,
			Description -> "The commitment duration of the current account.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		NumberOfBaselineUsers -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[1, 1],
			Description -> "The quantity of users available at the SoftwareBasePrice.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		CommandCenterPrice -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The amount charged by the ECL per additional user beyond the baseline amount.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		ConstellationPrice -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD / (10^6 Unit) ],
			Units -> USD / (10^6 Unit),
			Description -> "The amount charged by the ECL for every million items stored in the Constellation database.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		NumberOfThreads -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The overall usage of ECL laboratory and operator resources afforded by this specific pricing scheme.",
			Category -> "Organizational Information",
			AdminWriteOnly->True
		},
		NumberOfThreadsLog -> {
			Format -> Multiple,
			Class -> {Date, Integer},
			Pattern :> {_?DateObjectQ, GreaterEqualP[0,1]},
			Description -> "Historical record of changes in the number of threads available to the team.",
			Headers -> {"Date", "Number of threads"},
			Category -> "Organizational Information",
			AdminWriteOnly->True
		},
		LabAccessFee -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The amount charged by the ECL for the LabCapacity.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		PricePerExperiment -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The amount charged by the ECL for each protocol run in the facility.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		PricePerPriorityExperiment -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The amount charged by the ECL for each priority protocol run in the facility that exceed IncludedPriorityProtocols.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		OperatorTimePrice -> {
			Format -> Multiple,
			Headers -> {"Qualification Level", "Price per hour"},
			Class -> {Integer, Real},
			Pattern :> {_Integer, GreaterEqualP[0 * USD / Hour]},
			Units -> {None, USD / Hour},
			Description -> "The amount charged by the ECL for operator time per hour based on the QualificationLevel.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		OperatorPriorityTimePrice -> {
			Format -> Multiple,
			Headers -> {"Qualification Level", "Price per hour"},
			Class -> {Integer, Real},
			Pattern :> {_Integer, GreaterEqualP[0 * USD / Hour]},
			Units -> {None, USD / Hour},
			Description -> "The amount charged by the ECL for operator time on priority protocols based on the QualificationLevel.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		OperatorModelPrice -> {
			Format -> Multiple,
			Headers -> {"Operator Model", "Price per hour"},
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterEqualP[0 * USD / Hour]},
			Units -> {None, USD / Hour},
			Relation -> {
				Model[User,Emerald,Operator],
				Null
			},
			Description -> "The amount charged by the ECL for operator time per hour based on the Operator Model.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		InstrumentPricing -> {
			Format -> Multiple,
			Class -> {Integer, Real},
			Pattern :> {GreaterEqualP[1, 1], GreaterEqualP[0 * USD / Hour]},
			Units -> {None, USD / Hour},
			Description -> "The amount charged by the ECL for instrument time based on the tier level.",
			Headers -> {"Tier", "Price per hour"},
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		CleanUpPricing -> {
			Format -> Multiple,
			Class -> {Expression, Real},
			Pattern :> {CleaningP, GreaterEqualP[0 * USD]},
			Units -> {None, USD},
			Description -> "The amount charged by the ECL for cleaning dishware and materials based on the type of cleaning.",
			Headers -> {"Cleaning Type", "Price per Item"},
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		StockingPricing -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {
				_Link,
				GreaterEqualP[0 USD / Centimeter^3]
			},
			Relation -> {
				Model[StorageCondition],
				Null
			},
			Units -> {None, USD / Centimeter^3},
			Description -> "The amount charged by the ECL for provisioning items based on the cost to stock.",
			Headers -> {"Storage Condition", "Price Per Volume"},
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		WastePricing -> {
			Format -> Multiple,
			Headers -> {"Waste Type", "Disposal cost"},
			Class -> {Expression, Real},
			Pattern :> {WasteTypeP, GreaterEqualP[0 * USD / (Kilo * Gram)]},
			Units -> {None, USD / (Kilo * Gram)},
			Description -> "The amount charged by the ECL for disposing waste.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		StoragePricing -> {
			Format -> Multiple,
			Class -> {Link, Real},
			Pattern :> {_Link, GreaterEqualP[0 * USD / (Centimeter^3 * Hour)]},
			Relation -> {Model[StorageCondition], Null},
			Units -> {None, USD / (Centimeter^3 * Hour)},
			Description -> "The amount charged by the ECL for storing materials.",
			Headers -> {"Storage Condition", "Price per cubic centimeter per month"},
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		IncludedPriorityProtocols -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of free priority protocols allowed per billing cycle.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		IncludedInstrumentHours -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 Hour],
			Units -> Hour,
			Description -> "The number of free hours available each month not subject to InstrumentPricing.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		IncludedCleanings -> {
			Format -> Single,
			Class -> Integer,
			Pattern :> GreaterEqualP[0, 1],
			Description -> "The number of free occasions to clean items (e.g. dishwash glassware) not subject to cleaning fees.",
			Category -> "Pricing Information",
			AdminWriteOnly -> True
		},
		IncludedCleaningFees -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The price of free cleaning (e.g. dishwash glassware) not subject to fees.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		IncludedStockingFees -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The price of free stocking not subject to fees.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		IncludedWasteDisposalFees -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The price of waste disposal not subject to fees.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
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
		IncludedStorageFees -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The price of free storage not subject to fees.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		IncludedShipmentFees -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The price of shipments not subject to fees.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		PrivateTutoringFee -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * USD],
			Units -> USD,
			Description -> "The amount charged by the ECL for office hours each month.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		(*
		IncludedConstellationStorage -> {
			Format -> Single,
			Class -> Real,
			Pattern :> GreaterEqualP[0 * (10^6 Unit)],
			Units -> 10^6 Unit,
			Description -> "The number of stored database objects not subject to fees.",
			Category -> "Pricing Information",
			AdminWriteOnly->True
		},
		*)
		DeveloperObject -> {
			Format -> Single,
			Class -> Expression,
			Pattern :> BooleanP,
			Description -> "Indicates that this object is being used for test purposes only and is not supported by standard SLL features.",
			Category -> "Organizational Information",
			Developer -> True,
			AdminWriteOnly->True
		}
	}
}];