(* ::Subsection::Closed:: *)
(*PlotSanMateoCOVIDCases*)

DefineTests[PlotSanMateoCOVIDCases,
	{
		Example[{Basic,"By default display 7 day case averages for the last 3 months:"},
			PlotSanMateoCOVIDCases[],
			ValidGraphicsP[]
		],
		Example[{Basic,"Indicate you'd like to see new cases and thresholds for the past 2 months:"},
			PlotSanMateoCOVIDCases[2 Month,Display -> {DailyCases, Thresholds}],
			ValidGraphicsP[]
		],
		Example[{Basic,"Plot all data for the last two months of 2021:"},
			PlotSanMateoCOVIDCases[DateObject[{2021, 11, 1}],DateObject[{2021, 12, 31}],Display->All],
			ValidGraphicsP[]
		],
		Example[{Basic,"For a deeper look use mouse-over bars for exact case counts and the zoomable feature - click and drag to zoom in, and double click to reset zoom to default:"},
			PlotSanMateoCOVIDCases[Display->All],
			ValidGraphicsP[]
		],
		Example[{Options,Display,"Indicate which data to display on the plot, here just the 7-day average and the county classifications:"},
			PlotSanMateoCOVIDCases[Display -> {WeeklyAverage, Thresholds}],
			ValidGraphicsP[]
		],
		Example[{Options,Display,"Use the display option to display only the daily cases:"},
			PlotSanMateoCOVIDCases[Display -> DailyCases],
			ValidGraphicsP[]
		],
		Example[{Options,Display,"Use All to indicate that all data should be overlaid:"},
			PlotSanMateoCOVIDCases[Display -> All],
			ValidGraphicsP[]
		],
		Test["Display only the Thresholds:",
			PlotSanMateoCOVIDCases[Display -> Thresholds],
			ValidGraphicsP[]
		],
		Example[{Messages,"OutOfRange","Print a message if we don't have all data within the requested range. The data set starts in Jan 2021 so earlier data is not displyed:"},
			PlotSanMateoCOVIDCases[DateObject[{2020, 11, 9}],DateObject[{2021, 1, 9}]],
			ValidGraphicsP[],
			Messages:>{PlotSanMateoCOVIDCases::OutOfRange}
		]
	},
	Stubs:>{
		Now=DateObject[{2022,1,1,0,0,0}]
	}
];
