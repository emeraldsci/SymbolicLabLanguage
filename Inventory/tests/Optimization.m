(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(* PlotInventoryLevels *)


(* ::Subsubsection::Closed:: *)
(* PlotInventoryLevels *)

DefineTests[PlotInventoryLevels,
	{
		Example[{Basic, "Plot a graph of inventory levels over time:"},
			PlotInventoryLevels[Object[Inventory, StockSolution, "id:D8KAEvG4wa4K"]],
			ValidGraphicsP[]
		],
		Example[{Options, StartDate, "Specify the beginning of the plot range:"},
			PlotInventoryLevels[Object[Inventory, StockSolution, "id:D8KAEvG4wa4K"], StartDate -> Now - 1 Week],
			ValidGraphicsP[]
		],
		Example[{Options, EndDate, "Specify the end of the plot range:"},
			PlotInventoryLevels[Object[Inventory, StockSolution, "id:D8KAEvG4wa4K"], StartDate -> Now - 1 Year],
			ValidGraphicsP[]
		],
		Example[{Options, Units, "Specify whether to plot in quantities or product units, if possible:"},
			PlotInventoryLevels[
				Object[Inventory, StockSolution, "id:D8KAEvG4wa4K"],
				Units -> Quantity
			],
			ValidGraphicsP[]
		],
		Example[{Messages, "ConversionFactorNotFound", "Throw a warning if unit conversion is requested, but is not possible:"},
			PlotInventoryLevels[
				Object[Inventory, Product, "Aluminum Round Micro Weigh Boat"],
				Units -> Quantity
			],
			ValidGraphicsP[],
			Messages :> {PlotInventoryLevels::ConversionFactorNotFound}
		],
		Example[{Additional, "Plot the inventory levels of a counted item:"},
			PlotInventoryLevels[Object[Inventory, Product, "Aluminum Round Micro Weigh Boat"]],
			ValidGraphicsP[]
		],
		Example[{Additional, "Plot the inventory levels of a counted item:"},
			PlotInventoryLevels[Object[Inventory, Product, "Aluminum Round Micro Weigh Boat"]],
			ValidGraphicsP[]
		],
		Example[{Additional, "Plot the inventory levels of an inventory stocked by number of containers but containing sample:"},
			PlotInventoryLevels[Object[Inventory, StockSolution, "Reverse phase buffer A 0.05% HFBA, Water"]],
			ValidGraphicsP[]
		],
		Example[{Additional, "Plot the inventory levels of an inventory stocked by amount and containing sample:"},
			PlotInventoryLevels[Object[Inventory, StockSolution, "Reverse phase buffer A 0.05% HFBA, Water"]],
			ValidGraphicsP[]
		]
	}
];


(* ::Subsection::Closed:: *)
(* formatLogForPlot *)


(* ::Subsubsection::Closed:: *)
(* formatLogForPlot *)

DefineTests[formatLogForPlot,
	{
		Example[{Basic, "Reformat a log for plotting:"},
			formatLogForPlot[
				{
					{DateObject[{2024, 01, 01, 0, 0, 0}], 10},
					{DateObject[{2024, 02, 01, 0, 0, 0}], 5},
					{DateObject[{2024, 03, 01, 0, 0, 0}], 1},
					{DateObject[{2024, 04, 01, 0, 0, 0}], 14},
					{DateObject[{2024, 05, 01, 0, 0, 0}], 14},
					{DateObject[{2024, 06, 01, 0, 0, 0}], 20}
				},
				Automatic,
				Automatic
			],
			{
				{EqualP[DateObject[{2024, 01, 01, 0, 0, 0}]], EqualP[10]},
				{EqualP[DateObject[{2024, 02, 01, 0, 0, 0}]], EqualP[10]},
				{EqualP[DateObject[{2024, 02, 01, 0, 0, 0}]], EqualP[5]},
				{EqualP[DateObject[{2024, 03, 01, 0, 0, 0}]], EqualP[5]},
				{EqualP[DateObject[{2024, 03, 01, 0, 0, 0}]], EqualP[1]},
				{EqualP[DateObject[{2024, 04, 01, 0, 0, 0}]], EqualP[1]},
				{EqualP[DateObject[{2024, 04, 01, 0, 0, 0}]], EqualP[14]},
				{EqualP[DateObject[{2024, 05, 01, 0, 0, 0}]], EqualP[14]},
				{EqualP[DateObject[{2024, 05, 01, 0, 0, 0}]], EqualP[14]},
				{EqualP[DateObject[{2024, 06, 01, 0, 0, 0}]], EqualP[14]},
				{EqualP[DateObject[{2024, 06, 01, 0, 0, 0}]], EqualP[20]}
			}
		],
		Example[{Basic, "Reformat a log for plotting and trim to a particular start date:"},
			formatLogForPlot[
				{
					{DateObject[{2024, 01, 01, 0, 0, 0}], 10},
					{DateObject[{2024, 02, 01, 0, 0, 0}], 5},
					{DateObject[{2024, 03, 01, 0, 0, 0}], 1},
					{DateObject[{2024, 04, 01, 0, 0, 0}], 14},
					{DateObject[{2024, 05, 01, 0, 0, 0}], 14},
					{DateObject[{2024, 06, 01, 0, 0, 0}], 20}
				},
				DateObject[{2024, 02, 10, 0, 0, 0}],
				Automatic
			],
			{
				{EqualP[DateObject[{2024, 02, 10, 0, 0, 0}]], EqualP[5]},
				{EqualP[DateObject[{2024, 03, 01, 0, 0, 0}]], EqualP[5]},
				{EqualP[DateObject[{2024, 03, 01, 0, 0, 0}]], EqualP[1]},
				{EqualP[DateObject[{2024, 04, 01, 0, 0, 0}]], EqualP[1]},
				{EqualP[DateObject[{2024, 04, 01, 0, 0, 0}]], EqualP[14]},
				{EqualP[DateObject[{2024, 05, 01, 0, 0, 0}]], EqualP[14]},
				{EqualP[DateObject[{2024, 05, 01, 0, 0, 0}]], EqualP[14]},
				{EqualP[DateObject[{2024, 06, 01, 0, 0, 0}]], EqualP[14]},
				{EqualP[DateObject[{2024, 06, 01, 0, 0, 0}]], EqualP[20]}
			}
		],
		Example[{Basic, "Reformat a log for plotting and trim to a particular end date:"},
			formatLogForPlot[
				{
					{DateObject[{2024, 01, 01, 0, 0, 0}], 10},
					{DateObject[{2024, 02, 01, 0, 0, 0}], 5},
					{DateObject[{2024, 03, 01, 0, 0, 0}], 1},
					{DateObject[{2024, 04, 01, 0, 0, 0}], 14},
					{DateObject[{2024, 05, 01, 0, 0, 0}], 14},
					{DateObject[{2024, 06, 01, 0, 0, 0}], 20}
				},
				Automatic,
				DateObject[{2024, 03, 30, 0, 0, 0}]
			],
			{
				{EqualP[DateObject[{2024, 01, 01, 0, 0, 0}]], EqualP[10]},
				{EqualP[DateObject[{2024, 02, 01, 0, 0, 0}]], EqualP[10]},
				{EqualP[DateObject[{2024, 02, 01, 0, 0, 0}]], EqualP[5]},
				{EqualP[DateObject[{2024, 03, 01, 0, 0, 0}]], EqualP[5]},
				{EqualP[DateObject[{2024, 03, 01, 0, 0, 0}]], EqualP[1]},
				{EqualP[DateObject[{2024, 03, 30, 0, 0, 0}]], EqualP[1]}
			}
		],
		Example[{Additional, "Reformat a log for plotting and extend to the current time:"},
			formatLogForPlot[
				{
					{DateObject[{2024, 01, 01, 0, 0, 0}], 10},
					{DateObject[{2024, 02, 01, 0, 0, 0}], 5},
					{DateObject[{2024, 03, 01, 0, 0, 0}], 1},
					{DateObject[{2024, 04, 01, 0, 0, 0}], 14},
					{DateObject[{2024, 05, 01, 0, 0, 0}], 14},
					{DateObject[{2024, 06, 01, 0, 0, 0}], 20}
				},
				Automatic,
				Now
			],
			{
				{EqualP[DateObject[{2024, 01, 01, 0, 0, 0}]], EqualP[10]},
				{EqualP[DateObject[{2024, 02, 01, 0, 0, 0}]], EqualP[10]},
				{EqualP[DateObject[{2024, 02, 01, 0, 0, 0}]], EqualP[5]},
				{EqualP[DateObject[{2024, 03, 01, 0, 0, 0}]], EqualP[5]},
				{EqualP[DateObject[{2024, 03, 01, 0, 0, 0}]], EqualP[1]},
				{EqualP[DateObject[{2024, 04, 01, 0, 0, 0}]], EqualP[1]},
				{EqualP[DateObject[{2024, 04, 01, 0, 0, 0}]], EqualP[14]},
				{EqualP[DateObject[{2024, 05, 01, 0, 0, 0}]], EqualP[14]},
				{EqualP[DateObject[{2024, 05, 01, 0, 0, 0}]], EqualP[14]},
				{EqualP[DateObject[{2024, 06, 01, 0, 0, 0}]], EqualP[14]},
				{EqualP[DateObject[{2024, 06, 01, 0, 0, 0}]], EqualP[20]},
				{RangeP[Now - 1 Minute, Now], EqualP[20]}
			}
		]
	}
];



(* ::Subsection::Closed:: *)
(* simulateTimepoint *)


(* ::Subsubsection::Closed:: *)
(* simulateTimepoint *)

DefineTests[simulateTimepoint,
	{
		Example[{Basic, "Evolves an inventory simulation by one time step:"},
			simulateTimepoint[
				<|
					Date -> 0,
					CurrentAmountRaw -> 100,
					CurrentAmount -> 100,
					OutstandingAmount -> 0,
					OrderDueDates -> {},
					ExpirationDates -> ConstantArray[Null, 100],
					ExpiredAmount -> 0
				|>,
				<|
					TimeStep -> 1,
					ConsumptionRate -> 5,
					ReorderThreshold -> 50,
					ReorderAmount -> 50,
					ShelfLife -> Infinity,
					LeadTime -> 7,
					ResourcePickingMethod -> Oldest
				|>
			],
			AssociationMatchP[
				<|
					Date -> EqualP[1],
					CurrentAmountRaw -> EqualP[95],
					CurrentAmount -> EqualP[95],
					OutstandingAmount -> 0,
					OrderDueDates -> {},
					ExpirationDates -> ConstantArray[Null, 95],
					ExpiredAmount -> 0
				|>,
				AllowForeignKeys -> False,
				RequireAllKeys -> True
			]
		],
		Example[{Additional, "CurrentAmount is calculated correctly:"},
			simulateTimepoint[
				<|
					Date -> 0,
					CurrentAmountRaw -> 100,
					CurrentAmount -> 100,
					OutstandingAmount -> 0,
					OrderDueDates -> {},
					ExpirationDates -> ConstantArray[Null, 100],
					ExpiredAmount -> 0
				|>,
				<|
					TimeStep -> 1,
					ConsumptionRate -> 7.5,
					ReorderThreshold -> 50,
					ReorderAmount -> 50,
					ShelfLife -> Infinity,
					LeadTime -> 7,
					ResourcePickingMethod -> Oldest
				|>
			],
			AssociationMatchP[
				<|
					CurrentAmountRaw -> EqualP[92.5],
					CurrentAmount -> EqualP[93]
				|>,
				AllowForeignKeys -> True,
				RequireAllKeys -> True
			]
		],
		Example[{Additional, "CurrentAmount is calculated correctly over multiple time steps:"},
			Nest[
				simulateTimepoint[
					#,
					<|
						TimeStep -> 1,
						ConsumptionRate -> 7.5,
						ReorderThreshold -> 50,
						ReorderAmount -> 50,
						ShelfLife -> Infinity,
						LeadTime -> 7,
						ResourcePickingMethod -> Oldest
					|>
				] &,
				<|
					Date -> 0,
					CurrentAmountRaw -> 100,
					CurrentAmount -> 100,
					OutstandingAmount -> 0,
					OrderDueDates -> {},
					ExpirationDates -> ConstantArray[Null, 100],
					ExpiredAmount -> 0
				|>,
				2
			],
			AssociationMatchP[
				<|
					CurrentAmountRaw -> EqualP[85],
					CurrentAmount -> EqualP[85]
				|>,
				AllowForeignKeys -> True,
				RequireAllKeys -> True
			]
		],
		Example[{Additional, "CurrentAmount doesn't fall below 0:"},
			simulateTimepoint[
				<|
					Date -> 10,
					CurrentAmountRaw -> 10,
					CurrentAmount -> 10,
					OutstandingAmount -> 50,
					OrderDueDates -> {15},
					ExpirationDates -> ConstantArray[Null, 10],
					ExpiredAmount -> 0
				|>,
				<|
					TimeStep -> 1,
					ConsumptionRate -> 20,
					ReorderThreshold -> 50,
					ReorderAmount -> 50,
					ShelfLife -> Infinity,
					LeadTime -> 7,
					ResourcePickingMethod -> Oldest
				|>
			],
			AssociationMatchP[
				<|
					CurrentAmountRaw -> EqualP[0],
					CurrentAmount -> EqualP[0]
				|>,
				AllowForeignKeys -> True,
				RequireAllKeys -> True
			]
		],
		Example[{Additional, "An order is placed if the inventory level drops below the reorder threshold:"},
			simulateTimepoint[
				<|
					Date -> 0,
					CurrentAmountRaw -> 55,
					CurrentAmount -> 55,
					OutstandingAmount -> 0,
					OrderDueDates -> {},
					ExpirationDates -> ConstantArray[Null, 55],
					ExpiredAmount -> 0
				|>,
				<|
					TimeStep -> 1,
					ConsumptionRate -> 10,
					ReorderThreshold -> 50,
					ReorderAmount -> 50,
					ShelfLife -> Infinity,
					LeadTime -> 7,
					ResourcePickingMethod -> Oldest
				|>
			],
			AssociationMatchP[
				<|
					CurrentAmountRaw -> EqualP[45],
					CurrentAmount -> EqualP[45],
					OutstandingAmount -> EqualP[50],
					OrderDueDates -> {EqualP[8]} (* Order is placed on day 1, with 7 day lead time *)
				|>,
				AllowForeignKeys -> True,
				RequireAllKeys -> True
			]
		],
		Example[{Additional, "Samples expire when their expiration date is in the past:"},
			simulateTimepoint[
				<|
					Date -> 10,
					CurrentAmountRaw -> 100,
					CurrentAmount -> 100,
					OutstandingAmount -> 0,
					OrderDueDates -> {},
					ExpirationDates -> Join[ConstantArray[8, 40], ConstantArray[20, 60]],
					ExpiredAmount -> 0
				|>,
				<|
					TimeStep -> 1,
					ConsumptionRate -> 10,
					ReorderThreshold -> 50,
					ReorderAmount -> 50,
					ShelfLife -> 7,
					LeadTime -> 7,
					ResourcePickingMethod -> Oldest
				|>
			],
			AssociationMatchP[
				<|
					CurrentAmountRaw -> EqualP[60],
					CurrentAmount -> EqualP[60],
					ExpirationDates -> ConstantArray[20, 60],
					ExpiredAmount -> EqualP[30] (* 10 consumed, then remaining 30 expire *)
				|>,
				AllowForeignKeys -> True,
				RequireAllKeys -> True
			]
		],
		Example[{Additional, "New samples are received on the order due date:"},
			simulateTimepoint[
				<|
					Date -> 10,
					CurrentAmountRaw -> 20,
					CurrentAmount -> 20,
					OutstandingAmount -> 50,
					OrderDueDates -> {11},
					ExpirationDates -> ConstantArray[Null, 10],
					ExpiredAmount -> 0
				|>,
				<|
					TimeStep -> 1,
					ConsumptionRate -> 10,
					ReorderThreshold -> 50,
					ReorderAmount -> 50,
					ShelfLife -> Infinity,
					LeadTime -> 7,
					ResourcePickingMethod -> Oldest
				|>
			],
			AssociationMatchP[
				<|
					CurrentAmountRaw -> EqualP[60],
					CurrentAmount -> EqualP[60],
					ExpirationDates -> ConstantArray[Null, 60],
					OutstandingAmount -> EqualP[0],
					OrderDueDates -> {}
				|>,
				AllowForeignKeys -> True,
				RequireAllKeys -> True
			]
		],
		Test["A simulation evolves correctly over time, placing and receiving orders when required with non-expiring samples:",
			NestList[
				simulateTimepoint[
					#,
					<|
						TimeStep -> 1,
						ConsumptionRate -> 10,
						ReorderThreshold -> 50,
						ReorderAmount -> 100,
						ShelfLife -> Infinity,
						LeadTime -> 3,
						ResourcePickingMethod -> Oldest
					|>
				] &,
				<|
					Date -> 0,
					CurrentAmountRaw -> 100,
					CurrentAmount -> 100,
					OutstandingAmount -> 0,
					OrderDueDates -> {},
					ExpirationDates -> ConstantArray[Null, 100],
					ExpiredAmount -> 0
				|>,
				9
			],
			{
				(* Initial conditions *)
				AssociationMatchP[
					<|
						Date -> EqualP[0],
						CurrentAmountRaw -> EqualP[100],
						CurrentAmount -> EqualP[100],
						OutstandingAmount -> 0,
						OrderDueDates -> {},
						ExpirationDates -> ConstantArray[Null, 100],
						ExpiredAmount -> 0
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],

				(* First time point *)
				AssociationMatchP[
					<|
						Date -> EqualP[1],
						CurrentAmountRaw -> EqualP[90],
						CurrentAmount -> EqualP[90],
						OutstandingAmount -> 0,
						OrderDueDates -> {},
						ExpirationDates -> ConstantArray[Null, 90],
						ExpiredAmount -> 0
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],

				(* Intermediate timepoints *)
				Repeated[_Association, {3}],

				(* Final timepoint before ordering *)
				AssociationMatchP[
					<|
						Date -> EqualP[5],
						CurrentAmountRaw -> EqualP[50],
						CurrentAmount -> EqualP[50],
						OutstandingAmount -> 0,
						OrderDueDates -> {},
						ExpirationDates -> ConstantArray[Null, 50],
						ExpiredAmount -> 0
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],

				(* Order placed *)
				AssociationMatchP[
					<|
						Date -> EqualP[6],
						CurrentAmountRaw -> EqualP[40],
						CurrentAmount -> EqualP[40],
						OutstandingAmount -> EqualP[100],
						OrderDueDates -> {EqualP[9]},
						ExpirationDates -> ConstantArray[Null, 40],
						ExpiredAmount -> 0
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],

				(* Intermediate timepoints *)
				Repeated[_Association, {1}],

				(* Final timepoint before receiving *)
				AssociationMatchP[
					<|
						Date -> EqualP[8],
						CurrentAmountRaw -> EqualP[20],
						CurrentAmount -> EqualP[20],
						OutstandingAmount -> EqualP[100],
						OrderDueDates -> {EqualP[9]},
						ExpirationDates -> ConstantArray[Null, 20],
						ExpiredAmount -> 0
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],

				(* Order received *)
				AssociationMatchP[
					<|
						Date -> EqualP[9],
						CurrentAmountRaw -> EqualP[110],
						CurrentAmount -> EqualP[110],
						OutstandingAmount -> EqualP[0],
						OrderDueDates -> {},
						ExpirationDates -> ConstantArray[Null, 110],
						ExpiredAmount -> 0
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				]
			}
		],
		Test["A simulation evolves correctly over time, placing and receiving orders when required with expiring samples, when samples are consumed before expiration:",
			NestList[
				simulateTimepoint[
					#,
					<|
						TimeStep -> 1,
						ConsumptionRate -> 10,
						ReorderThreshold -> 50,
						ReorderAmount -> 100,
						ShelfLife -> 15,
						LeadTime -> 3,
						ResourcePickingMethod -> Oldest
					|>
				] &,
				<|
					Date -> 0,
					CurrentAmountRaw -> 100,
					CurrentAmount -> 100,
					OutstandingAmount -> 0,
					OrderDueDates -> {},
					ExpirationDates -> ConstantArray[15, 100],
					ExpiredAmount -> 0
				|>,
				10
			],
			{
				(* Initial conditions *)
				AssociationMatchP[
					<|
						Date -> EqualP[0],
						CurrentAmountRaw -> EqualP[100],
						CurrentAmount -> EqualP[100],
						OutstandingAmount -> 0,
						OrderDueDates -> {},
						ExpirationDates -> ConstantArray[15, 100],
						ExpiredAmount -> 0
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],

				(* First time point *)
				AssociationMatchP[
					<|
						Date -> EqualP[1],
						CurrentAmountRaw -> EqualP[90],
						CurrentAmount -> EqualP[90],
						OutstandingAmount -> 0,
						OrderDueDates -> {},
						ExpirationDates -> ConstantArray[15, 90],
						ExpiredAmount -> 0
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],

				(* Intermediate timepoints *)
				Repeated[_Association, {3}],

				(* Final timepoint before ordering *)
				AssociationMatchP[
					<|
						Date -> EqualP[5],
						CurrentAmountRaw -> EqualP[50],
						CurrentAmount -> EqualP[50],
						OutstandingAmount -> 0,
						OrderDueDates -> {},
						ExpirationDates -> ConstantArray[15, 50],
						ExpiredAmount -> 0
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],

				(* Order placed *)
				AssociationMatchP[
					<|
						Date -> EqualP[6],
						CurrentAmountRaw -> EqualP[40],
						CurrentAmount -> EqualP[40],
						OutstandingAmount -> EqualP[100],
						OrderDueDates -> {EqualP[9]},
						ExpirationDates -> ConstantArray[15, 40],
						ExpiredAmount -> 0
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],

				(* Intermediate timepoints *)
				Repeated[_Association, {1}],

				(* Final timepoint before receiving *)
				AssociationMatchP[
					<|
						Date -> EqualP[8],
						CurrentAmountRaw -> EqualP[20],
						CurrentAmount -> EqualP[20],
						OutstandingAmount -> EqualP[100],
						OrderDueDates -> {EqualP[9]},
						ExpirationDates -> ConstantArray[15, 20],
						ExpiredAmount -> 0
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],

				(* Order received *)
				AssociationMatchP[
					<|
						Date -> EqualP[9],
						CurrentAmountRaw -> EqualP[110],
						CurrentAmount -> EqualP[110],
						OutstandingAmount -> EqualP[0],
						OrderDueDates -> {},
						ExpirationDates -> Join[ConstantArray[15, 10], ConstantArray[24, 100]],
						ExpiredAmount -> 0
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],

				(* Final initial samples are consumed *)
				AssociationMatchP[
					<|
						Date -> EqualP[10],
						CurrentAmountRaw -> EqualP[100],
						CurrentAmount -> EqualP[100],
						OutstandingAmount -> EqualP[0],
						OrderDueDates -> {},
						ExpirationDates -> ConstantArray[24, 100],
						ExpiredAmount -> 0
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				]
			}
		],
		Test["A simulation evolves correctly over time, placing and receiving orders when required with expiring samples, when samples are discarded after expiration:",
			NestList[
				simulateTimepoint[
					#,
					<|
						TimeStep -> 1,
						ConsumptionRate -> 10,
						ReorderThreshold -> 50,
						ReorderAmount -> 100,
						ShelfLife -> 5,
						LeadTime -> 3,
						ResourcePickingMethod -> Oldest
					|>
				] &,
				<|
					Date -> 0,
					CurrentAmountRaw -> 100,
					CurrentAmount -> 100,
					OutstandingAmount -> 0,
					OrderDueDates -> {},
					ExpirationDates -> ConstantArray[5, 100],
					ExpiredAmount -> 0
				|>,
				13
			],
			{
				(* Initial conditions *)
				AssociationMatchP[
					<|
						Date -> EqualP[0],
						CurrentAmountRaw -> EqualP[100],
						CurrentAmount -> EqualP[100],
						OutstandingAmount -> 0,
						OrderDueDates -> {},
						ExpirationDates -> ConstantArray[5, 100],
						ExpiredAmount -> EqualP[0]
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],

				(* First time point *)
				AssociationMatchP[
					<|
						Date -> EqualP[1],
						CurrentAmountRaw -> EqualP[90],
						CurrentAmount -> EqualP[90],
						OutstandingAmount -> 0,
						OrderDueDates -> {},
						ExpirationDates -> ConstantArray[5, 90],
						ExpiredAmount -> EqualP[0]
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],

				(* Intermediate timepoints *)
				Repeated[_Association, {3}],

				(* First samples are discarded and order is placed *)
				AssociationMatchP[
					<|
						Date -> EqualP[5],
						CurrentAmountRaw -> EqualP[0],
						CurrentAmount -> EqualP[0],
						OutstandingAmount -> EqualP[100],
						OrderDueDates -> {EqualP[8]},
						ExpirationDates -> {},
						ExpiredAmount -> EqualP[50] (* Of the 60, 10 consumed and remainder discarded *)
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],

				(* Intermediate timepoints *)
				Repeated[
					AssociationMatchP[
						<|
							Date -> _,
							CurrentAmountRaw -> EqualP[0],
							CurrentAmount -> EqualP[0],
							OutstandingAmount -> EqualP[100],
							OrderDueDates -> {EqualP[8]},
							ExpirationDates -> {},
							ExpiredAmount -> EqualP[0]
						|>,
						AllowForeignKeys -> False,
						RequireAllKeys -> True
					],
					{2}
				],

				(* Order received *)
				AssociationMatchP[
					<|
						Date -> EqualP[8],
						CurrentAmountRaw -> EqualP[90], (* 100 received, 10 consumed same day *)
						CurrentAmount -> EqualP[90],
						OutstandingAmount -> EqualP[0],
						OrderDueDates -> {},
						ExpirationDates -> ConstantArray[13, 90],
						ExpiredAmount -> EqualP[0]
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],

				(* Intermediate timepoints *)
				Repeated[_Association, {3}],

				(* Final timepoint before second discard *)
				AssociationMatchP[
					<|
						Date -> EqualP[12],
						CurrentAmountRaw -> EqualP[50],
						CurrentAmount -> EqualP[50],
						OutstandingAmount -> EqualP[0],
						OrderDueDates -> {},
						ExpirationDates -> ConstantArray[13, 50],
						ExpiredAmount -> EqualP[0]
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				],

				(* Second discard *)
				AssociationMatchP[
					<|
						Date -> EqualP[13],
						CurrentAmountRaw -> EqualP[0],
						CurrentAmount -> EqualP[0],
						OutstandingAmount -> EqualP[100],
						OrderDueDates -> {EqualP[16]},
						ExpirationDates -> {},
						ExpiredAmount -> EqualP[40]
					|>,
					AllowForeignKeys -> False,
					RequireAllKeys -> True
				]
			}
		]
	}
];


(* ::Subsection::Closed:: *)
(* SimulateInventoryLevels *)


(* ::Subsubsection::Closed:: *)
(* SimulateInventoryLevels *)

DefineTests[SimulateInventoryLevels,
	{
		Example[{Basic, "Plot a graph simulating inventory levels over time:"},
			SimulateInventoryLevels[
				50,
				10 / Week,
				50,
				50
			],
			_Row
		],
		Example[{Additional, "Increase the starting stock level:"},
			SimulateInventoryLevels[
				100,
				10 / Week,
				50,
				50
			],
			_Row
		],
		Example[{Additional, "Increase the rate of consumption of inventory in the lab:"},
			SimulateInventoryLevels[
				50,
				20 / Week,
				50,
				50
			],
			_Row
		],
		Example[{Additional, "Increase the reorder threshold:"},
			SimulateInventoryLevels[
				50,
				10 / Week,
				75,
				50
			],
			_Row
		],
		Example[{Additional, "Increase the reorder amount:"},
			SimulateInventoryLevels[
				50,
				10 / Week,
				50,
				100
			],
			_Row
		],
		Example[{Options, Duration, "Specify the amount of time to simulate the inventory levels over:"},
			SimulateInventoryLevels[
				50,
				10 / Week,
				50,
				50,
				Duration -> 16 Week
			],
			_Row
		],
		Example[{Options, LeadTime, "Specify the amount of time between placing an order and receiving it:"},
			SimulateInventoryLevels[
				50,
				10 / Week,
				50,
				50,
				LeadTime -> 2 Day
			],
			_Row
		],
		Example[{Options, ShelfLife, "Specify the length of time after receiving before samples expire:"},
			SimulateInventoryLevels[
				50,
				10 / Week,
				50,
				50,
				ShelfLife -> 2 Week
			],
			_Row
		],
		Example[{Options, ResourcePickingMethod, "Specify whether operators use the oldest samples first or select randomly:"},
			SimulateInventoryLevels[
				50,
				10 / Week,
				50,
				50,
				ShelfLife -> 2 Week,
				ResourcePickingMethod -> Oldest
			],
			_Row
		]
	}
];