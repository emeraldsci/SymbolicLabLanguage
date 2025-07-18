(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(* PlotInventoryLevels *)

DefineUsage[
	PlotInventoryLevels,
	{
		BasicDefinitions -> {
			{"PlotInventoryLevels[inventoryObject]", "plot", "plots the historic levels of stocked samples, ordered samples and other inventory related parameters."}
		},
		MoreInformation -> {},
		Input :> {
			{"inventoryObject", ObjectP[Object[Inventory]], "The inventory object to plot inventory level history for."}
		},
		Output :> {
			{"plot", _Pane, "A plot of the historic inventory levels."}
		},
		SeeAlso -> {
			"SimulateInventoryLevels",
			"UploadInventory",
			"UploadProduct"
		},
		Author -> {"david.ascough"}
	}
];


(* ::Subsection:: *)
(* SimulateInventoryLevels *)

DefineUsage[
	SimulateInventoryLevels,
	{
		BasicDefinitions -> {
			{"SimulateInventoryLevels[startingStock, consumptionRate, reorderThreshold, reorderAmount]", "plot", "simulates the levels of stocked samples, ordered samples and other inventory related parameters over time for the conditions provided."}
		},
		MoreInformation -> {},
		Input :> {
			{"startingStock", GreaterEqualP[0, 1], "The amount of sample in stock at the beginning of the simulation."},
			{"consumptionRate", GreaterEqualP[0 / Week], "The amount of sample consumed during a given period of time."},
			{"reorderThreshold", GreaterEqualP[0, 1], "The amount below which the stocked inventory level must drop before an order is placed."},
			{"reorderAmount", GreaterEqualP[0, 1], "The amount of sample to reorder in each transaction."}
		},
		Output :> {
			{"plot", _Pane, "A plot of the simulated inventory levels."}
		},
		SeeAlso -> {
			"PlotInventoryLevels",
			"UploadInventory",
			"UploadProduct"
		},
		Author -> {"david.ascough"}
	}
];


(* ::Subsection:: *)
(* simulateTimepoint *)

DefineUsage[
	simulateTimepoint,
	{
		BasicDefinitions -> {
			{"simulateTimepoint[previousTimepoint, simulationParameters]", "nextTimepoint", "takes the state of the inventory simulation from the 'previousTimepoint' and evolves it for the next timestep based on the simulation parameters."}
		},
		MoreInformation -> {
			"Simulates inventory consumption, expiration and replenishment on a daily basis."
		},
		Input :> {
			{
				"previousTimepoint",
				AssociationMatchP[
					(* Quantities in the association are unitless for speed *)
					(* Standard units: Days (Relative to simulation start), Units *)
					<|
						Date -> GreaterEqualP[0, 1], (* Unitless days *)
						CurrentAmountRaw -> GreaterEqualP[0], (* Units, fractional *)
						CurrentAmount -> GreaterEqualP[0, 1], (* Units, whole *)
						OutstandingAmount -> GreaterEqualP[0, 1], (* Units, whole *)
						OrderDueDates -> {GreaterEqualP[0]...}, (* Unitless days *)
						ExpirationDates -> {Alternatives[Null, GreaterEqualP[0]]...}, (* Unitless days *)
						ExpiredAmount -> GreaterEqualP[0, 1] (* Units, whole *)
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],
				"The current state of the inventory simulation."
			},
			{
				"simulationParameters",
				AssociationMatchP[
					<|
						TimeStep -> GreaterEqualP[1, 1], (* Days *)
						ConsumptionRate -> GreaterEqualP[0], (* / Day *)
						ReorderThreshold -> GreaterEqualP[0, 1], (* Units, whole *)
						ReorderAmount -> GreaterEqualP[0, 1], (* Units, whole *)
						ShelfLife ->  Alternatives[GreaterEqualP[0], Infinity], (* Day *)
						LeadTime -> GreaterEqualP[0], (* Days *)
						ResourcePickingMethod -> Alternatives[Oldest, Random]
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],
				"The parameters used to run the simulation."
			}
		},
		Output :> {
			{
				"nextTimepoint",
				AssociationMatchP[
					(* Quantities in the association are unitless for speed *)
					(* Standard units: Days (Relative to simulation start), Units *)
					<|
						Date -> GreaterEqualP[0, 1], (* Unitless days *)
						CurrentAmountRaw -> GreaterEqualP[0], (* Units, fractional *)
						CurrentAmount -> GreaterEqualP[0, 1], (* Units, whole *)
						OutstandingAmount -> GreaterEqualP[0, 1], (* Units, whole *)
						OrderDueDates -> {GreaterEqualP[0]...}, (* Unitless days *)
						ExpirationDates -> {Alternatives[Null, GreaterEqualP[0]]...}, (* Unitless days *)
						ExpiredAmount -> GreaterEqualP[0, 1] (* Units, whole *)
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],
				"The state of the simulation at the next timepoint."
			}
		},
		SeeAlso -> {
			"SimulateInventoryLevels",
			"formatLogForPlot"
		},
		Author -> {"david.ascough"}
	}
];


(* ::Subsection:: *)
(* formatLogForPlot *)

DefineUsage[
	formatLogForPlot,
	{
		BasicDefinitions -> {
			{"formatLogForPlot[log, startDate, endDate]", "formattedLog", "reformats the 'log' so that it contains discrete level changes rather than implying interpolation between values."}
		},
		MoreInformation -> {
			"If a log has values of {t1, 1}, {t2, 2} and {t3, 3} at subsequent time points, it is often inferred that the value should be interpolated smoothly between time points, passing through e.g. a value of 1.5 between t1 and t2.",
			"This function explicitly re-writes the log as {t1, 1}, {t2, 1}, {t2, 2}, {t3, 2}, {t3, 3} to explicitly indicate that the step changes are discrete, and each value is valid until the next time point is reached.",
			"If startDate is provided and it's after the first entry time in the log, an entry will be added to the beginning of the log explicitly at StartDate with the correct value at that time and earlier entries trimmed off.",
			"If endDate is provided, an entry at endDate with the correct value at that time will be added to the end of the log, and later entries will be trimmed off."
		},
		Input :> {
			{"log", {{__}..}, "The log in format {{date, value}..} to reformat."},
			{"startDate", Alternatives[Automatic, _?DateObjectQ], "The date to trim the beginning of the log to."},
			{"endDate", Alternatives[Automatic, _?DateObjectQ], "The date to trim the end of the log to."}
		},
		Output :> {
			{"formattedLog", {{__}..}, "The reformatted logs with explicit discrete value changes and end dates applied."}
		},
		SeeAlso -> {
			"PlotInventoryLevels",
			"SimulateInventoryLevels"
		},
		Author -> {"david.ascough"}
	}
];