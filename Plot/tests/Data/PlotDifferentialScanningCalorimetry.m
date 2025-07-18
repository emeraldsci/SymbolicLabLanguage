(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDifferentialScanningCalorimetry*)


DefineTests[PlotDifferentialScanningCalorimetry,
	{
		Example[{Basic, "Plot DifferentialScanningCalorimetry data:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"]],
			_?ValidGraphicsQ
		],
		Example[{Basic, "Plot DifferentialScanningCalorimetry data using the raw data:"},
			PlotDifferentialScanningCalorimetry[Download[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"], MolarHeatingCurves]],
			_?ValidGraphicsQ
		],
		Example[{Basic, "Plot DifferentialScanningCalorimetry data linked to a protocol object:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"][Protocol]],
			SlideView[{ValidGraphicsP[] ..}]
		],
		Example[{Options, PrimaryData, "Use the PrimaryData option to select what field to plot:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"], PrimaryData -> MolarHeatingCurves],
			_?ValidGraphicsQ
		],
		Example[{Options, SecondaryData, "Use the SecondaryData option to select what field to plot on the second Y axis on top of the primary data:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"], SecondaryData -> {MolarHeatingCurves}],
			_?ValidGraphicsQ
		],
		Example[{Options, Zoomable, "Specify whether a dynamic zoomable plot is provided:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"], Zoomable -> True],
			_?ValidGraphicsQ
		],
		Example[{Options, Display, "Use the Display option to specify display peaks on the plot as well as the data:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"], Display -> {Peaks}],
			_?ValidGraphicsQ
		],
		(* TODO this option needs to be changed to use actual data that is real and actually has replicates *)
		Example[{Options, IncludeReplicates, "Specify whether to also plot the data from replicates of this data object:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"], IncludeReplicates -> False],
			_?ValidGraphicsQ
		],
		Example[{Options, TargetUnits, "Specify the desired units on the x and y axes.  This will convert the data from what it is stored as:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"], TargetUnits -> {Kelvin, Kilojoule/(Mole Kelvin)}, PrimaryData -> MolarHeatingCurves],
			_?ValidGraphicsQ
		],
		Example[{Options, Units, "Specify the units to use when plotting the heating curves:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"], Units -> {HeatingCurves -> {Celsius, Kilo Calorie / Celsius}}],
			_?ValidGraphicsQ
		],
		Example[{Options, FrameLabel, "Specify custom x and y-axis labels:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"], FrameLabel -> {"Temperature (Celsius)", "Heat Flux (kCal / Celsius)"}],
			_?ValidGraphicsQ
		],
		Example[{Options, PlotLabel, "Provide a title for the plot:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"], PlotLabel -> "DSC Heating Curves"],
			_?ValidGraphicsQ
		],
		Example[{Options, PlotTheme, "Indicate a general theme which should be used to set the styling for many plot options:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"], PlotTheme -> "Marketing"],
			_?ValidGraphicsQ
		],
		Example[{Options, Boxes, "Indicate that colors in the legend should be displayed using colored squares instead of lines:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"], Boxes -> True],
			_?ValidGraphicsQ
		],
		Example[{Options, Map, "Specify whether to display a plot for each data object or one with all data superimposed:"},
			PlotDifferentialScanningCalorimetry[{Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"], Object[Data, DifferentialScanningCalorimetry, "id:Y0lXejMoN60a"]}, Map -> True],
			{_?ValidGraphicsQ, _?ValidGraphicsQ}
		],
		Example[{Options, Legend, "Specify whether a legend should be displayed:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"], Legend -> None],
			_?ValidGraphicsQ
		],
		Example[{Options, LegendPlacement, "Specify where a legend should be displayed:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"], LegendPlacement -> Right],
			_?ValidGraphicsQ
		],
		Example[{Options, Peaks, "Provide peaks for the plot:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"], Peaks -> Object[Analysis, Peaks, "id:8qZ1VW0pY8mp"]],
			_?ValidGraphicsQ
		],
		Example[{Options,OptionFunctions, "Turn off any special formatting by clearing the option functions:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"],OptionFunctions -> {}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[{Options, HeatingCurves, "Provide a new value for the heating curves instead of using the value recorded in the object being plotted:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"],HeatingCurves -> {QuantityArray[Table[{x, Sqrt[x]/100}, {x, 4, 120, 1}], {Celsius, Kilo Calorie/Celsius}]}],
			_?ValidGraphicsQ
		],
		Example[{Options, MolarHeatingCurves, "Provide a new value for the molar heating curves instead of using the value recorded in the object being plotted:"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"], MolarHeatingCurves -> {QuantityArray[Table[{x, Sqrt[x/100]}, {x, 4, 120, 1}], {Celsius, Kilo Calorie/(Mole Celsius)}]}],
			_?ValidGraphicsQ
		],
		Example[{Options, Output, "Depending on the Output option, return a plot, a list of resolved options, or the tests (in this case, {}):"},
			PlotDifferentialScanningCalorimetry[Object[Data, DifferentialScanningCalorimetry, "id:M8n3rx0w1O4M"], Output -> {Result, Preview, Options, Tests}],
			{
				_?ValidGraphicsQ,
				_?ValidGraphicsQ,
				{__Rule},
				{}
			}
		]
	}
];
