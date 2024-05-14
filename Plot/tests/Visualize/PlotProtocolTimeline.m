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
		Example[{Options,Output,"Specify the output format of the plot function. Preview will still return a plot:"},
			PlotProtocolTimeline[
				Object[Protocol, ImageSample, "id:AEqRl9qdZ7Lw"],
				Output->Preview
			],
			_?ValidGraphicsQ
		],
		Example[{Options,Output,"Use Output->Options to return a list of all calculated options used to create the plot:"},
			PlotProtocolTimeline[
				Object[Protocol, FluorescenceIntensity, "id:bq9LA0JWxb1e"],
				Output->Options
			],
			_List
		],
		Example[{Options,DeveloperDisplay,"Show all internal details on the plot including ready check information, task starts, tickets and operator interrupts:"},
			PlotProtocolTimeline[
				Object[Protocol, MeasureVolume, "id:mnk9jORVbplw"],
				DeveloperDisplay->All
			],
			_DynamicModule
		],
		Example[{Options,DeveloperDisplay,"Specify if more details, such as priority check-ins and delays in instrument processing check-ins, should be displayed:"},
			PlotProtocolTimeline[
				Object[Protocol, RoboticSamplePreparation, "id:Y0lXejlMZj9V"],
				DeveloperDisplay->{InstrumentCheckIns,OperatorInterrupts}
			],
			_DynamicModule
		],
		Example[{Options,DeveloperDisplay,"Hover over the 'ResourceLimitation' label to see what was unavailable:"},
			PlotProtocolTimeline[
				Object[Protocol, qPCR, "id:O81aEB1lBlvO"],
				DeveloperDisplay->{ReadyCheck}
			],
			_DynamicModule
		],
		Example[{Options,DeveloperDisplay,"Hover over a point representing a ticket or a task to see brief details. Click on the point to print the underlying object (ticket or task log) below the plot:"},
			PlotProtocolTimeline[
				Object[Protocol, MeasureVolume, "id:mnk9jORVbplw"],
				DeveloperDisplay->{Tickets,Tasks}
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