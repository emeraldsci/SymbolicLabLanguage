(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(* PlotInventoryLevels *)

DefineOptions[
	PlotInventoryLevels,
	Options :> {
		{
			OptionName -> StartDate,
			Default -> Automatic,
			Description -> "The earliest date to plot.",
			ResolutionDescription -> "Resolves to 6 months before the end date.",
			AllowNull -> False,
			Pattern :> Alternatives[Automatic, _?DateObjectQ],
			Category -> "General"
		},
		{
			OptionName -> EndDate,
			Default :> Now,
			Description -> "The latest date to plot.",
			ResolutionDescription -> "Resolves to Now.",
			AllowNull -> False,
			Pattern :> Alternatives[Automatic, _?DateObjectQ],
			Category -> "General"
		},
		{
			OptionName -> Units,
			Default -> Automatic,
			Description -> "The type of units to use for the plot.",
			ResolutionDescription -> "Resolves to the units used for CurrentAmount of the inventory.",
			AllowNull -> False,
			Pattern :> Alternatives[Automatic, Quantity, Unit],
			Category -> "General"
		},
		(* Output option required for PlotObject integration *)
		OutputOption
	}
];

PlotInventoryLevels::ConversionFactorNotFound = "A conversion factor could not be determined to plot inventory levels with units of `1`. Plotting in native units.";

PlotInventoryLevels[myInventories : ListableP[ObjectP[Object[Inventory]]], myOptions : OptionsPattern[PlotInventoryLevels]] := Module[
	{
		listedInventories, safeOptions, startDateOption, endDateOption, resolvedStartDate, resolvedEndDate, unitsOption,
		currentAmountLogs, thresholdLogs, outstandingAmountLogs, usageLogs, expiredAmountLogs,
		stockedInventoryObjects, amountPerUnitStockSolutions, amountPerUnitOthers, unitConversions, safeUnits,
		logsToPlot, safeFormatLogForPlot, outputOption, plot, finalPlot
	},

	(* List the inputs *)
	listedInventories = ToList[myInventories];

	(* Get the safe options *)
	safeOptions = SafeOptions[PlotInventoryLevels, ToList[myOptions]];

	(* Extract the options *)
	{startDateOption, endDateOption, unitsOption, outputOption} = Lookup[safeOptions, {StartDate, EndDate, Units, Output}];

	(* Download the required info *)
	{
		currentAmountLogs, thresholdLogs, outstandingAmountLogs, usageLogs, expiredAmountLogs,
		stockedInventoryObjects,
		amountPerUnitStockSolutions,
		amountPerUnitOthers
	} = Transpose@Quiet[Download[
		listedInventories,
		{
			CurrentAmountLog, ReorderThresholdLog, OutstandingAmountLog, UsageLog, ExpiredAmountLog,
			StockedInventory[[1]][Object],
			StockedInventory[[1]][TotalVolume],
			StockedInventory[[1]][Amount]
		}
	], {Download::FieldDoesntExist}];

	(* Resolve the plot range *)
	(* End date is Now unless specified *)
	resolvedEndDate = If[DateObjectQ[endDateOption],
		endDateOption,
		Now
	];

	(* Start date is the end date - 6 months, unless specified *)
	resolvedStartDate = If[DateObjectQ[startDateOption],
		startDateOption,
		resolvedEndDate - 6 Month
	];

	(* Deduce the conversion between amount/unities, if any *)
	unitConversions = MapThread[
		Function[{stockedInventoryObject, amountPerUnitStockSolution, amountPerUnitOther, currentAmountLog},
			Module[
				{stockSolutionQ, requiredUnits, conversionFactor, resolvedConversionFactor, currentAmountUnits},

				(* Check if we're a stock solution *)
				stockSolutionQ = MatchQ[stockedInventoryObject, ObjectP[Model[Sample, StockSolution]]];

				(* Get the conversion factor between unities and amount, if there is one *)
				conversionFactor = If[stockSolutionQ,
					amountPerUnitStockSolution,
					amountPerUnitOther
				];

				(* Check what units the current amount are in *)
				currentAmountUnits = If[!MatchQ[currentAmountLog, {}],
					Units[currentAmountLog[[1, 2]]],
					Null
				];

				(* We'll plot in the units of current amount by default, so extract those units if required *)
				requiredUnits = Which[
					!MatchQ[unitsOption, Automatic],
					unitsOption,

					!MatchQ[currentAmountLog, {}] && UnitsQ[currentAmountLog[[1, 2]], Unit],
					Unit,

					!MatchQ[currentAmountLog, {}],
					Quantity,

					True,
					Unit
				];

				(* Resolve the conversion factor *)
				resolvedConversionFactor = Which[
					(* If a quantity conversion factor is located, make it explicitly quantity / unit *)
					Or[UnitsQ[conversionFactor, Gram], UnitsQ[conversionFactor, Liter]],
					conversionFactor / Unit,

					(* Otherwise there is no conversion factor. If we were asked to convert, we can't do that so throw a soft warning *)
					And[
						(* Option is specified *)
						!MatchQ[unitsOption, Automatic],

						(* Specified units don't match the resolved units *)
						!Or[
							MatchQ[requiredUnits, Quantity] && Or[UnitsQ[currentAmountUnits, Gram], UnitsQ[currentAmountUnits, Liter]],
							MatchQ[requiredUnits, Unit] && UnitsQ[currentAmountUnits, Unit]
						]
					],
					Message[PlotInventoryLevels::ConversionFactorNotFound, unitsOption];
					Null,

					(* Otherwise simply return Null *)
					True,
					Null
				];

				(* If converting units, return the conversion factor *)
				Switch[{requiredUnits, resolvedConversionFactor},
					(* If targeting unit units, and we have a conversion factor, return it *)
					{Unit, Except[Null]},
					resolvedConversionFactor,

					(* If targeting quantity units, and we have a conversion factor, return the reciprocal *)
					{Quantity, Except[Null]},
					1 / resolvedConversionFactor,

					(* Otherwise return Null to avoid conversion *)
					_,
					Null
				]
			]
		],
		{stockedInventoryObjects, amountPerUnitStockSolutions, amountPerUnitOthers, currentAmountLogs}
	];

	(* DateListPlot has a weird property where it fails to plot at all if one of the datasets is {} *)
	(* This can be worked around by plotting 0 for the plot range *)
	safeFormatLogForPlot[log_, startDate_, endDate_] := With[{formattedLog = formatLogForPlot[log, startDate, endDate]},
		If[MatchQ[formattedLog, {}],
			{{startDate, 0}, {endDate, 0}},
			formattedLog
		]
	];

	(* Helper to ensure everything is in the same units - some items may be in unities and others in amounts *)
	safeUnits[log__, conversion_] := Which[
		(* If converting to quantities, do so *)
		Or[UnitsQ[conversion, Unit / Liter], UnitsQ[conversion, Unit / Gram]],
		(* If an amount is in unities, convert to grams/liters*)
		(* Unitless[x, Unit] Unit ensures that all values have explicit 1 Unit units. Otherwise you can get a weird mix of 1 vs 1 Unit *)
		(* For example 4 Liter / (4 Liter / Unit) = 1 Unit whereas 4000 Milliliter / (4 Liter / Unit) = 1 *)
		If[UnitsQ[#[[2]], Unit],
			ReplacePart[#, 2 -> (Unitless[#[[2]], Unit] Unit) / conversion],
			{#[[1]], #[[2]]}
		]& /@ log,

		(* If converting to units, do so *)
		Or[UnitsQ[conversion, Liter / Unit], UnitsQ[conversion, Gram / Unit]],
		(* If an amount is in grams/liters, convert to (fractional) unities *)
		(* Unitless[x, Unit] Unit ensures that all values have explicit 1 Unit units. Otherwise you can get a weird mix of 1 vs 1 Unit *)
		(* For example 4 Liter / (4 Liter / Unit) = 1 Unit whereas 4000 Milliliter / (4 Liter / Unit) = 1 *)
		If[Or[UnitsQ[#[[2]], Gram], UnitsQ[#[[2]], Liter]],
			ReplacePart[#, 2 -> Unitless[#[[2]] / conversion, Unit] Unit],
			{#[[1]], Unitless[#[[2]], Unit] Unit}
		]& /@ log,

		(* Otherwise, no conversion *)
		True,
		log
	];

	(* Format the logs for plotting *)
	logsToPlot = MapThread[
		Function[{currentAmountLog, thresholdLog, outstandingAmountLog, usageLog, expiredAmountLog, unitConversion},
			{
				safeUnits[safeFormatLogForPlot[currentAmountLog, resolvedStartDate, resolvedEndDate], unitConversion],
				safeUnits[safeFormatLogForPlot[thresholdLog, resolvedStartDate, resolvedEndDate], unitConversion],
				safeUnits[safeFormatLogForPlot[outstandingAmountLog, resolvedStartDate, resolvedEndDate], unitConversion],
				safeUnits[safeFormatLogForPlot[usageLog[[All, {1, 3}]], resolvedStartDate, resolvedEndDate], unitConversion], (* Usage log includes both number of resources and amount used - plot the latter *)
				safeUnits[safeFormatLogForPlot[expiredAmountLog, resolvedStartDate, resolvedEndDate], unitConversion]
			}
		],
		{currentAmountLogs, thresholdLogs, outstandingAmountLogs, usageLogs, expiredAmountLogs, unitConversions}
	];

	(* Plot the graph *)
	plot = MapThread[
		Function[{logs, unitConversion},
			Zoomable[EmeraldDateListPlot[
				logs,
				PlotRange -> {
					{resolvedStartDate, resolvedEndDate},
					{0, All}
				},
				FrameLabel -> {
					"Date",
					Which[
						(* If no conversion, we're plotting in units *)
						NullQ[unitConversion],
						"Count",

						(* Converting to quantities *)
						Or[UnitsQ[unitConversion, Unit / Liter], UnitsQ[unitConversion, Unit / Gram]],
						"Quantity (" <> TextString[unitConversion] <> ")",

						(* Converting to units *)
						Or[UnitsQ[unitConversion, Liter / Unit], UnitsQ[unitConversion, Gram / Unit]],
						"Count (" <> TextString[unitConversion] <> ")",

						(* Default *)
						True,
						"Amount"
					]
				},
				ImageSize -> Large,
				Legend -> {"Current Amount", "Reorder Threshold", "Outstanding Amount", "Usage Log", "Expired Amount Log"}
			]]
		],
		{logsToPlot, unitConversions}
	];

	(* Remove listing on plot if only a single input *)
	finalPlot = If[MatchQ[myInventories, ObjectP[]],
		First[plot],
		plot
	];

	(* Return the output *)
	(* Option is required for PlotObject integration but doesn't really do anything *)
	outputOption /. {
		Result -> finalPlot,
		Options -> {},
		Preview -> plot,
		Tests -> {}
	}
];


(* ::Subsection::Closed:: *)
(* SimulateInventoryLevels *)

DefineOptions[
	SimulateInventoryLevels,
	Options :> {
		{
			OptionName -> Duration,
			Default -> 12 Month,
			Description -> "The length of time to simulate the inventory levels for.",
			AllowNull -> False,
			Pattern :> GreaterEqualP[4 Week, Day],
			Category -> "General"
		},
		{
			OptionName -> LeadTime,
			Default -> 1 Week,
			Description -> "The duration between placing an order and receiving the order into SLL.",
			AllowNull -> False,
			Pattern :> GreaterEqualP[0 Day],
			Category -> "General"
		},
		{
			OptionName -> ShelfLife,
			Default -> Infinity,
			Description -> "The length of time between receiving a sample and it exceeding its expiration date, resulting in disposal.",
			AllowNull -> False,
			Pattern :> Alternatives[GreaterEqualP[0 Day], Infinity],
			Category -> "General"
		},
		{
			OptionName -> ResourcePickingMethod,
			Default -> Random,
			Description -> "The method that operators use when deciding which in-stock samples to use to fulfil a resource.",
			AllowNull -> True,
			Pattern :> Alternatives[Oldest, Random],
			Category -> "General"
		}
	}
];


SimulateInventoryLevels[
	myStartingStock : GreaterEqualP[0, 1],
	myConsumptionRate : GreaterEqualP[0 / Week],
	myReorderThreshold : GreaterEqualP[0, 1],
	myReorderAmount : GreaterEqualP[0, 1],
	myOptions : OptionsPattern[SimulateInventoryLevels]
] := Module[
	{
		safeOptions, durationOption, leadTimeOption, shelfLifeOption, stockControlOption,
		timestepUnitted, consumptionRate, reorderLeadTime, simulationDuration, shelfLife, timestepGranularity,
		initialConditions, inventoryTrajectory, inventoryTrajectoryRaw, numberOfSimulationSteps,
		orderDates
	},

	(* Timestep of the numerical simulation *)
	(* Currently orders are placed and received once per period (same as reality if that period is 1 day) so that needs to be upgraded if this is changed *)
	timestepUnitted = 1 Day;

	(* Get the safe ops *)
	safeOptions = SafeOptions[SimulateInventoryLevels, ToList[myOptions]];

	(* Extract the options *)
	{durationOption, leadTimeOption, shelfLifeOption, stockControlOption} = Lookup[safeOptions, {Duration, LeadTime, ShelfLife, ResourcePickingMethod}];

	(* Convert the inputs to standard, unitless quantities for faster calculation *)
	timestepGranularity = Unitless[timestepUnitted, Day];
	consumptionRate = Unitless[myConsumptionRate, 1 / Day];
	reorderLeadTime = Unitless[leadTimeOption, Day];
	simulationDuration = Unitless[durationOption, Day];
	shelfLife = Unitless[shelfLifeOption, Day];
	numberOfSimulationSteps = Ceiling[simulationDuration / timestepGranularity];

	(* Assemble the initial conditions of the simulation *)
	initialConditions = <|
		Date -> 0,
		CurrentAmountRaw -> myStartingStock, (* This is an internal variable and may be fractional to keep the overall consumption rate on track *)
		CurrentAmount -> myStartingStock, (* This is the external variable for stock level - a rounded integer amount of stock *)
		OutstandingAmount -> 0, (* Amount of sample on order *)
		OrderDueDates -> {}, (* List of outstanding order due dates *)
		ExpirationDates -> If[ (* Expiration dates of currently stocked samples *)
			MatchQ[shelfLife, Infinity],
			ConstantArray[Null, myStartingStock],
			ConstantArray[shelfLife, myStartingStock]
		],
		ExpiredAmount -> 0 (* Amount of expired sample discarded in this timestep *)
	|>;

	(* Run the simulation *)
	inventoryTrajectoryRaw = NestList[
		simulateTimepoint[
			#1,
			<|
				TimeStep -> timestepGranularity,
				ConsumptionRate -> consumptionRate,
				ReorderThreshold -> myReorderThreshold,
				ReorderAmount -> myReorderAmount,
				ShelfLife -> shelfLife,
				LeadTime -> reorderLeadTime,
				ResourcePickingMethod -> stockControlOption
			|>
		] &,
		initialConditions,
		numberOfSimulationSteps
	];

	(* Restore the units in the simulation data *)
	inventoryTrajectory = Append[
		#,
		Date -> (Lookup[#, Date] / 7) * Week (* Convert to weeks as easier to understand when viewed *)
	] & /@ inventoryTrajectoryRaw;

	(* Extract some metrics from the trajectory *)
	(* When were orders placed? *)
	orderDates = Cases[
		Transpose[
			(* Pair each outstanding amount with the one from the previous time point *)
			{inventoryTrajectory, Prepend[Most[inventoryTrajectory], <|OutstandingAmount -> 0|>]}
		],
		(* Pick out time points where the outstanding amount is greater than the previous time point *)
		dataPoint : _?(GreaterQ[Lookup[First[#], OutstandingAmount], Lookup[Last[#], OutstandingAmount]]&) :> Lookup[First[dataPoint], Date]
	];

	(* Make a plot *)
	Row[
		{
			Zoomable@EmeraldListLinePlot[
				{
					formatLogForPlot[Lookup[inventoryTrajectory, {Date, OutstandingAmount}]],
					formatLogForPlot[Lookup[inventoryTrajectory, {Date, ExpiredAmount}]],
					formatLogForPlot[Lookup[inventoryTrajectory, {Date, CurrentAmount}]],
					formatLogForPlot[{{Lookup[First[inventoryTrajectory], Date], myReorderThreshold}, {Lookup[Last[inventoryTrajectory], Date], myReorderThreshold}}]
				},
				PlotRange -> {
					{Lookup[First[inventoryTrajectory], Date], Lookup[Last[inventoryTrajectory], Date]},
					{0, Automatic}
				},
				ImageSize -> 500,
				Legend -> {
					"Outstanding Amount",
					"Expired Amount",
					"Current Amount",
					"Reorder Threshold"
				},
				PlotStyle -> {
					{Blue (* Dark Orange *), Thickness[0.004]},
					{RGBColor[0.7, 0.1, 0.1] (* Dark Red *), Thickness[0.003]},
					{RGBColor[0.2, 0.5, 0.2] (* Dark Green *), Thickness[0.003]},
					{Black, Thickness[0.003]}
				},
				LegendPlacement -> Right,
				FrameLabel -> {"Simulated Week", "Inventory Level / Units"}
			],
			PlotTable[
				{
					{Max[Lookup[inventoryTrajectory, CurrentAmount]]},
					{Min[Lookup[inventoryTrajectory, CurrentAmount]]},
					{Quiet[Check[Round[Min[Rest[orderDates] - Most[orderDates]], 0.1], Null]]},
					{Max[Lookup[inventoryTrajectory, OutstandingAmount]] / myReorderAmount},
					{Round[Total[Lookup[inventoryTrajectory, ExpiredAmount]] / Lookup[Last[inventoryTrajectory], Date], 0.1]},
					{Round[Length[Split[Select[Lookup[inventoryTrajectory, ExpiredAmount], # > 0&]]] / Lookup[Last[inventoryTrajectory], Date], 0.01]}
				},
				TableHeadings -> {
					{
						"Maximum Stock Level",
						"Minimum Stock Level",
						"Most frequent re-order",
						"Most simultaneous pending orders",
						"Sample discard rate",
						"Discard event rate"
					},
					Automatic
				},
				UnitForm -> False
			]
		},
		Spacer[50]
	]
];


(* Function for generating the next time point in the inventory simulation from the previous one *)
simulateTimepoint[
	myPreviousTimepoint : AssociationMatchP[
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
	myParameters : AssociationMatchP[
		<|
			TimeStep -> GreaterEqualP[1, 1], (* Days *)
			ConsumptionRate -> GreaterEqualP[0], (* / Day *)
			ReorderThreshold -> GreaterEqualP[0, 1], (* Units, whole *)
			ReorderAmount -> GreaterEqualP[0, 1], (* Units, whole *)
			ShelfLife -> Alternatives[GreaterEqualP[0], Infinity], (* Day *)
			LeadTime -> GreaterEqualP[0], (* Days *)
			ResourcePickingMethod -> Alternatives[Oldest, Random]
		|>,
		AllowForeignKeys -> False,
		RequireAllKeys -> True
	]
] := Module[
	{
		timeStep, consumptionRate, reorderThreshold,
		reorderAmount, shelfLife, leadTime, stockControl,
		previousTime, amount, roundedAmount, outstandingAmount,
		orderDueDates, expirationDates, expiredSamples,
		currentTime
	},

	(* Note that this function updates internal variables multiple times throughout *)

	(* Lookup the values of the simulation for the previous point *)
	{
		previousTime, amount, outstandingAmount,
		orderDueDates, expirationDates
	} = Lookup[
		myPreviousTimepoint,
		{
			Date, CurrentAmountRaw, OutstandingAmount,
			OrderDueDates, ExpirationDates
		}
	];

	(* Lookup the simulation parameters *)
	{
		timeStep, consumptionRate, reorderThreshold,
		reorderAmount, shelfLife, leadTime, stockControl
	} = Lookup[
		myParameters,
		{
			TimeStep, ConsumptionRate, ReorderThreshold,
			ReorderAmount, ShelfLife, LeadTime, ResourcePickingMethod
		}
	];

	(* Add the timestep to the old date to get the current one *)
	currentTime = previousTime + timeStep;


	(* Receive orders at the beginning of the time period *)
	(* If an order comes in, add it to the stock levels at the start of the day. Otherwise no change *)
	{amount, orderDueDates, outstandingAmount, expirationDates} = If[MemberQ[orderDueDates, LessEqualP[currentTime]],
		Module[{countReceived},

			(* Count received is the number of orders * amount in the order *)
			countReceived = Count[orderDueDates, LessEqualP[currentTime]] * reorderAmount;

			{
				(* Add the amount we're receiving to the in-stock amount *)
				amount + countReceived,

				(* Remove the order dates for the items we just received *)
				Cases[orderDueDates, Except[LessEqualP[currentTime]]],

				(* Remove the amount we just received from the outstanding amount *)
				outstandingAmount - countReceived,

				(* Append the new expiration dates to the existing list of expiration dates for the stocked items *)
				If[MatchQ[shelfLife, Infinity],
					Join[expirationDates, ConstantArray[Null, countReceived]],
					Join[expirationDates, ConstantArray[currentTime + shelfLife, countReceived]]
				]
			}
		],

		{
			amount,
			orderDueDates,
			outstandingAmount,
			expirationDates
		}
	];


	(* Account for consumption *)
	amount = Max[(amount - consumptionRate * timeStep), 0];
	roundedAmount = Ceiling[amount];
	expirationDates = Switch[stockControl,
		Oldest,
		Take[Sort[expirationDates], -roundedAmount],

		Random,
		RandomSample[expirationDates, roundedAmount]
	];

	(* Account for expired samples *)
	{amount, roundedAmount, expirationDates, expiredSamples} = If[MatchQ[shelfLife, Infinity],
		(* No change if samples don't expire *)
		{amount, roundedAmount, expirationDates, 0},

		Module[{numberOfExpiredSamples, unexpiredDates},

			unexpiredDates = Select[expirationDates, # > currentTime &];
			numberOfExpiredSamples = Length[expirationDates] - Length[unexpiredDates];

			{
				Max[amount - numberOfExpiredSamples, 0],
				Ceiling[amount - numberOfExpiredSamples],
				unexpiredDates,
				numberOfExpiredSamples
			}
		]
	];

	(* Place orders at the end of the time period *)
	(* Check if we're under the threshold and place an order if needed. Otherwise no change *)
	{outstandingAmount, orderDueDates} = If[LessQ[amount + (Length[orderDueDates] * reorderAmount), reorderThreshold],
		{outstandingAmount + reorderAmount, Append[orderDueDates, currentTime + leadTime]},
		{outstandingAmount, orderDueDates}
	];


	<|
		Date -> currentTime,
		(* Keep the whole value in memory *)
		CurrentAmountRaw -> amount,
		(* Round to whole numbers here *)
		CurrentAmount -> roundedAmount,
		OutstandingAmount -> outstandingAmount,
		OrderDueDates -> orderDueDates,
		ExpirationDates -> expirationDates,
		ExpiredAmount -> expiredSamples
	|>
];



(* ::Subsection::Closed:: *)
(* formatLogForPlot *)

(* Small helper to make logs look nice when plotting *)
(* We want to see step changes when an order comes in rather than a gradual, smooth change from the previous value *)
(* Works with logs of format {{date, value}..} *)
formatLogForPlot[log : {{__}..}] := formatLogForPlot[log, Automatic, Automatic];
formatLogForPlot[log : {{__}..}, startDate : Alternatives[_?DateObjectQ, Automatic], endDate : Alternatives[_?DateObjectQ, Automatic]] := Module[
	{explicitTransitionLog, trimmedLog},

	(* Add extra entries into the log to explicitly make each value extend to the next *)
	(* e.g. {{1, 2}, {2, 6}, {3, 7}} becomes {{1, 2}, {2, 2}, {2, 6}, {3, 6}, {3, 7}} to ensure stepwise transitions *)
	explicitTransitionLog = Module[
		{endPointLog},

		(* Determine the end points of each step by rotating the log and trimming off the extra, final values that's not needed *)
		endPointLog = MapThread[
			{#1, #2}&,
			{Most[RotateLeft[log[[All, 1]]]], log[[;; -2, 2]]}
		];

		(* Then riffle the two logs *)
		Riffle[log, endPointLog]
	];

	(* Trim the log for the period of interest. Insert entries for beginning and end of periods of interest *)
	trimmedLog = Module[
		{frontTrimmed},

		(* If the start date isn't automatic, trim the front of the log *)
		frontTrimmed = If[!MatchQ[startDate, Automatic],
			Module[{logBeforeDate, logAfterDate},

				(* Split off the log entries before the start date *)
				logBeforeDate = Select[explicitTransitionLog, LessQ[First[#], startDate] &];

				(* Pull out the log entries after the start date *)
				logAfterDate = Select[explicitTransitionLog, GreaterEqualQ[First[#], startDate] &];

				(* If there are log entries before the start date, create a new entry at the exact start time to make sure the initial value isn't lost *)
				If[!MatchQ[logBeforeDate, {}] && Or[MatchQ[logAfterDate, {}], !EqualQ[logAfterDate[[1, 1]], startDate]],
					Prepend[logAfterDate, {startDate, logBeforeDate[[-1, 2]]}],
					logAfterDate
				]
			],
			explicitTransitionLog
		];

		(* If the end date isn't automatic, trim the end of the log *)
		If[!MatchQ[endDate, Automatic],
			Module[{endTrimmed},
				(* Trim the logs *)
				endTrimmed = Select[frontTrimmed, LessEqualQ[First[#], endDate] &];

				(* Add a new entry at the end of the log to make sure the logs go up to the end date *)
				If[!EqualQ[endTrimmed[[-1, 1]], endDate],
					Append[
						endTrimmed,
						{endDate, endTrimmed[[-1, 2]]}
					],
					endTrimmed
				]
			],
			frontTrimmed
		]
	];

	(* Return the final list *)
	trimmedLog
];

formatLogForPlot[{}] := {};
formatLogForPlot[{}, _, _] := {};