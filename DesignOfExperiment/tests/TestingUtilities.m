(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


DefineTests[PeakObjectiveFunction,
	{
		Example[{Basic,"Get the area of the maximum peak height of a simulated protocol:"},
			PeakObjectiveFunction[xyData],
			{_Quantity..},
			SetUp :> (
				(*Pull data for xy Data *)
				xyData = DesignOfExperiment`Private`SimulateHPLC[{}, ColumnTemperature->30 Celsius];
			)
		],
		Example[{Basic,"Get the maximum peak height of chromatography data:"},
			PeakObjectiveFunction[Object[Data, Chromatography, "id:zGj91a7dx17j"]],
			_Quantity
		],
		Example[{Basic,"Using ObjectiveFunction on a protocol returns the objective function applied to each Data object in the protocol:"},
			PeakObjectiveFunction[Object[Protocol, HPLC, "id:M8n3rx04P4zE"]],
			{_Quantity..}
		]
	},
	Variables :> {xyData}
];

DefineTests[AreaOfTallestPeak,
	{
		Example[{Basic,"Get the area of the maximum peak height of a simulated protocol:"},
			AreaOfTallestPeak[xyData],
			{_Quantity..},
			SetUp :> (
				(*Pull data for xy Data *)
				xyData = DesignOfExperiment`Private`SimulateHPLC[{}, ColumnTemperature->30 Celsius];
			)
		],
		Example[{Basic,"Get the maximum peak height of chromatography data:"},
			AreaOfTallestPeak[Object[Data, Chromatography, "id:zGj91a7dx17j"]],
			_Quantity
		],
		Example[{Basic,"Using ObjectiveFunction on a protocol returns the objective function applied to each Data object in the protocol:"},
			AreaOfTallestPeak[Object[Protocol, HPLC, "id:M8n3rx04P4zE"]],
			{_Quantity..}
		]
	},
	Variables :> {xyData}
];

DefineTests[MeanPeakSeparation,
	{
		Example[{Basic,"Get the mean peak separation of a simulated protocol:"},
			MeanPeakSeparation[xyData],
			{_Quantity..},
			SetUp :> (
				(*Pull data for xy Data *)
				xyData = DesignOfExperiment`Private`SimulateHPLC[{}, ColumnTemperature->30 Celsius];
			)
		],
		Example[{Basic,"Get the mean peak separation of chromatography data:"},
			MeanPeakSeparation[Object[Data, Chromatography, "id:zGj91a7dx17j"]],
			_Quantity
		],
		Example[{Basic,"Using ObjectiveFunction on a protocol returns the objective function applied to each Data object in the protocol:"},
			MeanPeakSeparation[Object[Protocol, HPLC, "id:M8n3rx04P4zE"]],
			{_Quantity..}
		]
	},
	Variables :> {xyData}
];

DefineTests[MeanPeakHeightWidthRatio,
	{
		Example[{Basic,"Get the mean peak height width ratio of a simulated protocol:"},
			MeanPeakHeightWidthRatio[xyData],
			{_Quantity..},
			SetUp :> (
				(*Pull data for xy Data *)
				xyData = DesignOfExperiment`Private`SimulateHPLC[{}, ColumnTemperature->30 Celsius];
			)
		],
		Example[{Basic,"Get the mean peak height width ratio of chromatography data:"},
			MeanPeakHeightWidthRatio[Object[Data, Chromatography, "id:zGj91a7dx17j"]],
			_Quantity
		],
		Example[{Basic,"Using ObjectiveFunction on a protocol returns the objective function applied to each Data object in the protocol:"},
			MeanPeakHeightWidthRatio[Object[Protocol, HPLC, "id:M8n3rx04P4zE"]],
			{_Quantity..}
		]
	},
	Variables :> {xyData}
];

DefineTests[ResolutionOfTallestPeak,
	{
		Example[{Basic,"Get the resolution of the tallest peak of a simulated protocol:"},
			ResolutionOfTallestPeak[xyData],
			{_Quantity..},
			SetUp :> (
				(*Pull data for xy Data *)
				xyData = DesignOfExperiment`Private`SimulateHPLC[{}, ColumnTemperature->30 Celsius];
			)
		],
		Example[{Basic,"Get the resolution of the tallest peak of chromatography data:"},
			ResolutionOfTallestPeak[Object[Data, Chromatography, "id:zGj91a7dx17j"]],
			_Quantity
		],
		Example[{Basic,"Using ObjectiveFunction on a protocol returns the objective function applied to each Data object in the protocol:"},
			ResolutionOfTallestPeak[Object[Protocol, HPLC, "id:M8n3rx04P4zE"]],
			{_Quantity..}
		]
	},
	Variables :> {xyData}
];
