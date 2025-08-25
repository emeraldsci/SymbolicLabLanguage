(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotNMR2D*)


DefineTests[PlotNMR2D,
	{
		Example[{Basic, "Plot the two-dimensional NMR spectrum of a single object, with a dynamic slider for adjusting the intensity threshold:"},
			PlotNMR2D[Object[Data, NMR2D, "id:4pO6dM5xGzkB"]],
			ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___],
			TimeConstraint -> 120
		],
		Example[{Basic, "Plot the two-dimensional NMR spectrum of a single object with low enough signal that a slider does not appear.  This happens if the data is so noisy and the signal is weak enough that lowering the threshold further will result in extremely high noise:"},
			PlotNMR2D[Object[Data, NMR2D, "id:XnlV5jKxEGzP"]],
			ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___],
			TimeConstraint -> 120
		],
		Example[{Basic, "PlotObject calls PlotNMR2D to plot the two-dimensional spectrum:"},
			PlotObject[Object[Data, NMR2D, "id:4pO6dM5xGzkB"]],
			ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___],
			TimeConstraint -> 120
		],
		Example[{Basic, "Plot the two-dimensional NMR spectrum of multiple objects:"},
			PlotNMR2D[{Object[Data, NMR2D, "id:4pO6dM5xGzkB"], Object[Data, NMR2D, "id:Vrbp1jKxlRDw"]}],
			{(ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___])..},
			TimeConstraint -> 120
		],
		Example[{Basic, "Plot the two-dimensional NMR spectrum of objects linked to a protocol object input:"},
			PlotNMR2D[Object[Data, NMR2D, "id:4pO6dM5xGzkB"][Protocol]],
			SlideView[{(ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___])..}],
			TimeConstraint -> 120
		],
		Example[{Options, SymmetryFilter, "By default, the symmetry filter is not used:"},
			PlotNMR2D[Object[Data, NMR2D, "id:dORYzZJY0WOw"]],
			ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___],
			TimeConstraint -> 120
		],
		Example[{Options, SymmetryFilter, "Set to True to symmetrize the 2D NMR data being plotted. For each pair of points symmetric about the diagonal, the minimum intensity of the two points will be shown, i.e. f(x,y) = Min[f(x,y), f(y,x)]:"},
			PlotNMR2D[Object[Data, NMR2D, "id:dORYzZJY0WOw"], SymmetryFilter -> True],
			ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___],
			TimeConstraint -> 120
		],
		Example[{Options, NoiseThreshold, "Specify the minimum intensity below which no contour levels will be drawn:"},
			PlotNMR2D[Object[Data, NMR2D, "id:4pO6dM5xGzkB"], NoiseThreshold -> 5000000],
			ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___],
			TimeConstraint -> 120
		],
		Example[{Options, NoiseThreshold, "Automatic will calculate the noise threshold based on the distribution of baseline intensities in the input data. This threshold will depend on the SymmetryFilter and Contours options as well:"},
			NoiseThreshold/.PlotNMR2D[Object[Data,NMR2D,"id:4pO6dM5xGzkB"], Contours->10, Output->Options],
			720000
		],
		Example[{Options, Contours, "By default, show automatically pre-computed contour levels:"},
			PlotNMR2D[Object[Data, NMR2D, "id:4pO6dM5xGzkB"]],
			ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___],
			TimeConstraint -> 120
		],
		Example[{Options, Contours, "Show a fixed number of contours at intensities logarithmically spaced between the NoiseThreshold and the maximum intensity:"},
			PlotNMR2D[Object[Data, NMR2D, "id:4pO6dM5xGzkB"], Contours->20],
			ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___],
			TimeConstraint -> 120
		],
		Example[{Options, Contours, "Specify a list of intensity values at which contours should be shown:"},
			PlotNMR2D[Object[Data, NMR2D, "id:4pO6dM5xGzkB"], Contours->Range[2000000, 10000000, 400000]],
			ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___],
			TimeConstraint -> 120
		],
		Test["Automatic Contours default to pre-computed contours stored in the data object:",
			Contours/.PlotNMR2D[Object[Data,NMR2D,"id:dORYzZJY0WOw"], Contours->Automatic, Output->Options],
			{100000, 1000000, 1500000, 2000000, 5000000, 10000000, 50000000, 100000000}
		],
		Example[{Options, GridLines, "Specify whether or not to include grid lines on the plot:"},
			PlotNMR2D[Object[Data, NMR2D, "id:Vrbp1jKxlRDw"], GridLines -> None],
			ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___],
			TimeConstraint -> 120
		],
		Example[{Options, GridLinesStyle, "Specify how the grid lines ought to be displayed:"},
			PlotNMR2D[Object[Data, NMR2D, "id:Vrbp1jKxlRDw"], GridLinesStyle -> Dashed],
			ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___],
			TimeConstraint -> 120
		],
		Example[{Options, AspectRatio, "Specify the aspect ratio of the output plot:"},
			PlotNMR2D[Object[Data, NMR2D, "id:Vrbp1jKxlRDw"], AspectRatio -> 1],
			ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___],
			TimeConstraint -> 120
		],
		Example[{Options, PlotRange, "Specify the plot range in the output plot:"},
			PlotObject[Object[Data,NMR2D,"id:4pO6dM5xGzkB"],PlotRange ->{{-2,2},{-2,4}}],
			ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___],
			TimeConstraint -> 120
		],
		Example[{Options, PlotLabel, "Indicate how to label the plot:"},
			PlotNMR2D[Object[Data, NMR2D, "id:Vrbp1jKxlRDw"], PlotLabel -> "1H-13C HMQC"],
			ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___],
			TimeConstraint -> 120
		],
		Example[{Options, FrameLabel, "Indicate how to label the axes of the two-dimensional plot:"},
			PlotNMR2D[Object[Data, NMR2D, "id:Vrbp1jKxlRDw"], FrameLabel -> {{None, "13C Chemical Shift (ppm)"}, {"1H Chemical Shift (ppm)", None}}],
			ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___],
			TimeConstraint -> 120
		],
		Example[{Options, Frame, "Indicate how the frame should be drawn around the plot:"},
			PlotNMR2D[Object[Data, NMR2D, "id:Vrbp1jKxlRDw"], Frame -> {{True, True}, {True, False}}],
			ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___],
			TimeConstraint -> 120
		],
		Example[{Options, ScaleY, "Indicate if padding is desired in the y dimension of the plot:"},
			PlotNMR2D[Object[Data, NMR2D, "id:Vrbp1jKxlRDw"], ScaleY -> 1.1],
			ValidGraphicsP[]|DynamicModule[_, Column[{_Dynamic, _Slider, _Dynamic}, ___], ___],
			TimeConstraint -> 120
		],
		Example[{Issues,"PlotNMR2D relies on dynamic evaluation and may return $Aborted if a computationally expensive visualization is requested, e.g. if too many dense (low-intensity) contours are specified. You may increase timeout on Dynamic evaluation using SetOptions[$FrontEndSession, DynamicEvaluationTimeout->value] to display these plots, but this may cause slowness in your notebook:"},
			PlotNMR2D[Object[Data, NMR2D, "id:4pO6dM5xGzkB"], Contours -> Range[1000000, 2000000, 20000]],
			DynamicModule[_, Column[{_, _Slider, _Dynamic}, ___], ___],
			TimeConstraint->120
		]
	}
];
