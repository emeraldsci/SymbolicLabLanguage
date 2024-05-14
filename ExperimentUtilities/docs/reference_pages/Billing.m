(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection:: *)
(*SyncBilling*)

DefineUsage[
	SyncBilling,
	{
		BasicDefinitions -> {
			{"SyncBilling[team]", "updated team and bill", "provides an 'updated team and bill' for the usage of the ECL and activities financed by 'team' during the current billing cycle."}
		},
		MoreInformation -> {
			"The updated bill reflects costs calculated by PriceExperiment, PriceData, PriceShipping, PriceTransactions, and PriceRecurring.",
			"Pricing information is only calculated for Completed parent protocols - protocols that are incomplete at the time of the bill closing will appear on the next bill.",
			"Note that any prices displayed in this documentation are only for the sake of example and do not represent actual prices.",
			"If the current billing cycle ends, a new bill is generated, and the completed bill is closed out."
		},
		Input :> {
			{"team", ListableP[ObjectP[Object[Team, Financing]]], "The team(s) whose operator pricing for all its protocols is calculated."}
		},
		Output :> {
			{"updated team and bill", {ObjectP[Object[Bill], Object[Team, Financing]]...}, "The updated bill(s) and updated financing team object."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"PriceStorage",
			"PriceWaste",
			"PriceInstrumentTime",
			"PriceOperatorTime",
			"PriceMaterials",
			"PriceTransactions",
			"PriceExperiment"
		},
		Author -> {"alou", "robert", "dima", "steven"}
	}
];

(* ::Subsubsection:: *)
(*runSyncBilling*)


DefineUsage[
	runSyncBilling,
	{
		BasicDefinitions -> {
			{"runSyncBilling[team]", "result", "provides a 'result' for the usage of the ECL and activities financed by 'team' during the current billing cycle."},
			{"runSyncBilling[All]", "result", "provides a 'result' reporting the results of running SyncBilling on all active Object[Team, Financing] during the current billing cycle."}
		},
		MoreInformation -> {
			"The All overload of this function runs SyncBilling on all Object[Team, Financing] that are currently active.",
			"Emails are sent to Financing via $BillingEmailRecipients."
		},
		Input :> {
			{"team", ListableP[ObjectP[Object[Team, Financing]]], "The team(s) whose operator pricing for all its protocols is calculated."},
			{"All", All, "An indication that all active teams should be run with SyncBilling."}
		},
		Output :> {
			{"result", _Pane | {_String..}, "A summary indicating the successful evaluation of the given Object[Team, Financing]."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"PriceStorage",
			"PriceWaste",
			"PriceInstrumentTime",
			"PriceOperatorTime",
			"PriceMaterials",
			"PriceTransactions",
			"SyncBilling",
			"PriceExperiment"
		},
		Author -> {"alou", "robert", "dima", "steven"}
	}
];

(* ::Subsubsection:: *)
(*runSyncBilling*)


DefineUsage[
	ExportBillingData,
	{
		BasicDefinitions -> {
			{"ExportBillingData[bill, exportPath]", "spreadsheet", "exports a 'spreadsheet' to the 'exportPath' with the charges from the 'bill'."}
		},
		MoreInformation -> {
			"The All overload of this function runs SyncBilling on all Object[Team, Financing] that are currently active."
		},
		Input :> {
			{"bill", ObjectReferenceP[Object[Bill]], "The bill with the data to be exported."},
			{"exportPath", FilePathP, "Destination where the spreadsheet will be exported."}
		},
		Output :> {
			{"spreadsheet", _String, "A path to the file where the billing data was exported."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"PriceStorage",
			"PriceWaste",
			"PriceInstrumentTime",
			"PriceOperatorTime",
			"PriceMaterials",
			"PriceTransactions",
			"SyncBilling",
			"PriceExperiment"
		},
		Author -> {"alou", "robert", "dima"}
	}
];