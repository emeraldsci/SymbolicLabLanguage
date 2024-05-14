(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFragmentAnalysis*)


DefineTests[PlotFragmentAnalysis,
	{
		(* -- BASIC -- *)
		Example[{Basic,"Given an FragmentAnalysis data object, creates a plot for the SampleElectropherogram:"},
			PlotFragmentAnalysis[
				Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]
			],
			_?ValidGraphicsQ
		],
  
		Example[{Basic,"Plot a FragmentAnalysis data in a link:"},
			PlotFragmentAnalysis[Link[Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"],Protocol]],
			_?ValidGraphicsQ
		],
        
        Example[{Basic, "Plot FragmentAnalysis data after calling AnalyzePeaks:"},
            AnalyzePeaks[Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]];
            PlotFragmentAnalysis[Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]],
            _?ValidGraphicsQ
        ],

		(* -- OPTIONS -- *)
		Example[{Options, ImageSize, "Set the image size for the output plots:"},
			PlotFragmentAnalysis[
				Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"],
				ImageSize -> 800
			],
			_?ValidGraphicsQ
		],
		Example[{Options,PrimaryData,"The field name containing the data to be plotted:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},PrimaryData->{Electropherogram}],
			_?ValidGraphicsQ
		],
		Example[{Options,Display,"Additional data to overlay on top of the plot:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},Display->{Peaks}],
			_?ValidGraphicsQ
		],
		Example[{Options,IncludeReplicates,"When set to true, the average of PrimaryData will be be plotted with error bars:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},IncludeReplicates->False],
			_?ValidGraphicsQ
		],
		Example[{Options,TargetUnits,"The units of the x and y axes. If these are distinct from the units currently associated with the data, unit conversions will occur before plotting:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},TargetUnits -> {Minute, RFU}],
			_?ValidGraphicsQ
		],
		Example[{Options,Zoomable,"Indicates if a dynamic plot which can be zoomed in or out will be returned:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},Zoomable->True],
			_?ValidGraphicsQ
		],
		Example[{Options,LegendPlacement,"Specifies where the legend will be placed relative to the plot:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},LegendPlacement->Right],
			_?ValidGraphicsQ
		],
		Example[{Options,Boxes,"If true, the legend will pair each label with a colored box. If false, the labels will be paired with a colored line:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},Boxes->True],
			_?ValidGraphicsQ
		],
		Example[{Options,FrameLabel,"The label to place on top of the frame:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},FrameLabel->{"time (s)","fluorescent intensity (arbitrary unit)",None,None}],
			_?ValidGraphicsQ
		],
		Example[{Options,PlotLabel,"Specifies an overall label for a plot:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},PlotLabel->"my experiment"],
			_?ValidGraphicsQ
		],
		Example[{Options,Electropherogram,"The sample electropherogram trace to display on the plot:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},Electropherogram->Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"][Electropherogram]],
			_?ValidGraphicsQ
		],
		Example[{Options,OptionFunctions,"A list of functions which take in a list of info packets and plot options and return a list of new options:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},OptionFunctions -> {}],
			_?ValidGraphicsQ
		],
		Example[{Options,Legend,"A list of text descriptions of each data set in the plot:"},
			PlotFragmentAnalysis[{Object[Data, FragmentAnalysis, "Data object for PlotFragmentAnalysis testing"]},Legend->{"sample"}],
			_?ValidGraphicsQ
		]
	}

];
