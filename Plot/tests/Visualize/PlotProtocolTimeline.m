(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotProtocolTimeline*)


DefineTests[PlotProtocolTimeline,
	{
		Example[{Basic,"Creates a plot showing a protocol's current status over time as it proceeds from InCart to Completed:"},
			PlotProtocolTimeline[
				Object[Protocol,StockSolution,"id:zGj91a7DDZNj"]
			],
			_DynamicModule
		],
		Test["Given a qualification object, creates a plot for the status timeline:",
			PlotProtocolTimeline[
				Object[Qualification,CapillaryELISA,"id:P5ZnEjdElzV4"]
			],
			_DynamicModule
		],
		Example[{Options,ReadyCheck,"Show periods of ReadyCheck->False with any instrument and/or materials limitations displayed on hover:"},
			PlotProtocolTimeline[
				Object[Protocol, qPCR, "id:O81aEB1lBlvO"],
				ReadyCheck->True
			],
			_DynamicModule
		],
		Example[{Options,OperatorInterrupts,"Show priority check-ins that the operator was pulled into:"},
			PlotProtocolTimeline[
				Object[Protocol,StockSolution,"id:zGj91a7DDZNj"],
				OperatorInterrupts->True
			],
			_DynamicModule
		],
		Example[{Options,Tasks,"Display every Engine task using the creation date of all TaskStart events:"},
			PlotProtocolTimeline[
				Object[Protocol, MeasureVolume, "id:mnk9jORVbplw"],
				Tasks->True
			],
			_DynamicModule
		],
		Example[{Options,Tickets,"Tickets are displayed as red dots on the x-axis. Click on the point to print the underlying ticket below the plot:"},
			PlotProtocolTimeline[
				Object[Protocol, AbsorbanceSpectroscopy, "id:KBL5DvPYWO0d"],
				Tickets -> True
			],
			_DynamicModule
		],
		Example[{Options,InstrumentCheckIns,"Show each time the operator performed a check-in during instrument processing:"},
			PlotProtocolTimeline[
				Object[Protocol, RoboticSamplePreparation, "id:Y0lXejlMZj9V"],
				InstrumentCheckIns->True
			],
			_DynamicModule
		],
		Example[{Options,Subprotocols,"Displays the DateStarted and DateCompleted of all subprotocols completed by the protocol:"},
			PlotProtocolTimeline[
				Object[Protocol, PAGE, "id:xRO9n3EeWa4q"],
				Subprotocols->True
			],
			_DynamicModule
		],
		Example[{Options,Repairs,"Display any repairs needed for the protocol to move forward. Click on the point to print the underlying object below the plot:"},
			PlotProtocolTimeline[
				Object[Qualification, HPLC, "id:xRO9n3EWJVWY"],
				Repairs->True
			],
			_DynamicModule
		],
		Example[{Options,Title,"Provide a specific name for the plot. All plot titles copy themselves to your clipboard on click:"},
			PlotProtocolTimeline[
				Object[Protocol,StockSolution,"id:zGj91a7DDZNj"],
				Title->"My Stock Solution"
			],
			_DynamicModule
		],
		Example[{Messages,"NoStatusLog","Prints a message and returns $Failed if given a protocol without any status information:"},
			PlotProtocolTimeline[Object[Protocol,PAGE,"PlotProtocolTimeline Empty StatusLog "<>$SessionUUID]],
			$Failed,
			Messages:>{Error::NoStatusLog},
			SetUp:>(
				$CreatedObjects={};
				Upload[<|Type->Object[Protocol,PAGE],Name->"PlotProtocolTimeline Empty StatusLog "<>$SessionUUID|>]
			),
			TearDown:>Module[{},
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
			]
		]
	}
];