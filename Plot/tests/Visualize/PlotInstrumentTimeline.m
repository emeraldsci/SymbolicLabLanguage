(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotInstrumentTimeline*)


DefineTests[PlotInstrumentTimeline,
	{
		Example[{Basic,"Given an instrument object, creates a status timeline and status pie chart:"},
			myPlot=PlotInstrumentTimeline[
				Object[Instrument,LiquidHandler,"Test Instrument 1 for PlotInstrumentTimeline tests "<>$SessionUUID]
			],
			_Grid,
			Variables:>{myPlot}
		],
		Example[{Basic,"Given an instrument model, creates a status timeline and status pie chart:"},
			myPlot=PlotInstrumentTimeline[
				Model[Instrument,LiquidHandler,"Test Instrument Model for PlotInstrumentTimeline tests "<>$SessionUUID]
			],
			_Grid,
			Variables:>{myPlot}
		],
		Example[{Basic,"Given an instrument object and a timespan, creates a status timeline and status pie chart:"},
			myPlot=PlotInstrumentTimeline[
				Object[Instrument,LiquidHandler,"Test Instrument 2 for PlotInstrumentTimeline tests "<>$SessionUUID],
				6*Month
			],
			_Grid,
			Variables:>{myPlot}
		],
		Example[{Basic,"Given an instrument model and a time span, creates a status timeline and status pie chart:"},
			myPlot=PlotInstrumentTimeline[
				Model[Instrument,LiquidHandler,"Test Instrument Model for PlotInstrumentTimeline tests "<>$SessionUUID],
				6*Month
			],
			_Grid,
			Variables:>{myPlot}
		],
		Test["The plots in the timeline are valid:",
			myPlot=PlotInstrumentTimeline[
				Model[Instrument,LiquidHandler,"Test Instrument Model for PlotInstrumentTimeline tests "<>$SessionUUID],
				6*Month
			];
			(* Our plots are in several layers of grids, pull them all out and make sure they're legit*)
			{myPlot[[1, 4, 1, 1, 1, 1]], myPlot[[1, 4, 1, 1, 1, 2]], myPlot[[1, 6, 1]]},
			{ValidGraphicsP[]..},
			Variables:>{myPlot}
		],
		Test["Test a model that yields a list of 2 data points which can't be plotted with quadratic interpolation.",
			PlotInstrumentTimeline[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			_Grid
		],
		Test["Test a slowly converging model instrument.",
			PlotInstrumentTimeline[Model[Instrument, Pipette, "Eppendorf Research Plus P20"]],
			_Grid
		]
	},
	SymbolSetUp:>(

		$CreatedObjects={};

		(* Gather and erase all pre-existing objects created in SymbolSetUp *)
		Module[
			{
				allObjects,existingObjects,
				logDates,statusList1,statusList2,statusLog1,statusLog2,
				inst1,inst2,instModel
			},

			(* All data objects generated for unit tests *)

			allObjects=
				{
					Object[Instrument,LiquidHandler,"Test Instrument 1 for PlotInstrumentTimeline tests "<>$SessionUUID],
					Object[Instrument,LiquidHandler,"Test Instrument 2 for PlotInstrumentTimeline tests "<>$SessionUUID],
					Model[Instrument,LiquidHandler,"Test Instrument Model for PlotInstrumentTimeline tests "<>$SessionUUID]
				};

			(* Check whether the names we want to give below already exist in the database *)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(* Erase any test objects and models that we failed to erase in the last unit test *)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];

			(* Generate dates for the status logs*)
			logDates=DateRange[Now - 2*Year, Now, 2*Week];

			(* Generate a list of random statuses for each instrument *)
			{statusList1,statusList2}=Table[RandomChoice[{Available,Running,UndergoingMaintenance},Length[logDates]],2];

			(* Generate the status logs for each instrument *)
			statusLog1=MapThread[{#1,#2,Link[$PersonID]}&,{logDates,statusList1}];
			statusLog2=MapThread[{#1,#2,Link[$PersonID]}&,{logDates,statusList2}];

		{
			inst1,
			inst2,
			instModel
		}=CreateID[
			{
				Object[Instrument,LiquidHandler],
				Object[Instrument,LiquidHandler],
				Model[Instrument,LiquidHandler]
			}
		];

		Upload[
			{
				<|
					Name -> "Test Instrument 1 for PlotInstrumentTimeline tests "<>$SessionUUID,
					Object->inst1,
					Replace[StatusLog]->statusLog1,
					Status->statusList1[[-1]],
					DeveloperObject->True
				|>,
				<|
					Name -> "Test Instrument 2 for PlotInstrumentTimeline tests "<>$SessionUUID,
					Object->inst2,
					Replace[StatusLog]->statusLog2,
					Status->statusList2[[-1]],
					DeveloperObject->True
				|>,
				<|
					Name -> "Test Instrument Model for PlotInstrumentTimeline tests "<>$SessionUUID,
					Object->instModel,
					Replace[Objects]->{Link[inst1,Model],Link[inst2,Model]},
					DeveloperObject->True
				|>
			}
		]

	];
	),
	SymbolTearDown:>Module[{objects},
		objects = {
			Object[Instrument,LiquidHandler,"Test Instrument 1 for PlotInstrumentTimeline tests "<>$SessionUUID],
			Object[Instrument,LiquidHandler,"Test Instrument 2 for PlotInstrumentTimeline tests "<>$SessionUUID],
			Model[Instrument,LiquidHandler,"Test Instrument Model for PlotInstrumentTimeline tests "<>$SessionUUID]
		};

		EraseObject[
			PickList[objects,DatabaseMemberQ[objects],True],
			Verbose->False,
			Force->True
		]
	]
];
