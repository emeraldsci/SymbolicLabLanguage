(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotPAGE*)


DefineTests[PlotPAGE,
	{
		Example[{Basic,"Plot a single lane:"},
			PlotPAGE[Object[Data, PAGE, "PlotPAGE test data object"]],
			_?ValidGraphicsQ
		],
		Test["Given a packet:",
			PlotPAGE[Download[Object[Data, PAGE, "PlotPAGE test data object"]]],
			_?ValidGraphicsQ
		],
		Example[{Basic,"Plot a PAGE data in a link:"},
			PlotPAGE[Link[Object[Data, PAGE, "PlotPAGE test data object"],Protocol]],
			_?ValidGraphicsQ
		],
		Example[{Basic,"Plot a lane along with its corresponding standard:"},
			PlotPAGE[Object[Data, PAGE, "PlotPAGE test data object"]],
			_?ValidGraphicsQ
		],
		Example[{Basic,"Plot multiple lanes with one standard:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"],Object[Data, PAGE, "id:pZx9jonGlmG0"]}],
			_?Core`Private`ValidLegendedQ
		],

		Test["Data with peaks picked, but has zero peaks, does not error:",
			PlotPAGE[Object[Data, PAGE, "PlotPAGE test data object"]],
			_?ValidGraphicsQ
		],
		Test["Standard data with no Analytes and no LaneAnalysis:",
			PlotPAGE[Object[Data, PAGE, "PlotPAGE test data object"]],
			_?ValidGraphicsQ
		],
		Example[{Options,IncludeLadder,"Plot the lane loaded with ladder along with other samples:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},IncludeLadder->True],
			_?ValidGraphicsQ
		],
		Example[{Options,Filling,"Indicates how the region under the spectrum should be shaded:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},Filling->Bottom],
			_?ValidGraphicsQ
		],
		Example[{Options,Images,"A list of fields containing images which should be placed at the top of the plot:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},Images->{OptimalLaneImage}],
			_?ValidGraphicsQ
		],
		Example[{Options,LinkedObjects,"Fields containing objects which should be pulled from the input object and plotted alongside it:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},LinkedObjects->{LadderData}],
			_?ValidGraphicsQ
		],
		Example[{Options,PrimaryData,"The field name containing the data to be plotted:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},PrimaryData->{OptimalLaneIntensity}],
			_?ValidGraphicsQ
		],
		Example[{Options,SecondaryData,"Additional fields to display along with the primary data:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},SecondaryData->{HighExposureLaneIntensity},LinkedObjects->Null,Images->{OptimalLaneImage,HighExposureLaneImage}],
			_?ValidGraphicsQ
		],
		Example[{Options,Display,"Additional data to overlay on top of the plot:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},Display->{Peaks}],
			_?ValidGraphicsQ
		],
		Example[{Options,IncludeReplicates,"When set to true, the average of PrimaryData will be be plotted with error bars:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},IncludeReplicates->False],
			_?ValidGraphicsQ
		],
		Example[{Options,TargetUnits,"The units of the x and y axes. If these are distinct from the units currently associated with the data, unit conversions will occur before plotting:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},TargetUnits->{Centimeter, ArbitraryUnit}],
			_?ValidGraphicsQ
		],
		Example[{Options,Units,"The list of units currently associated with each piece of data being plotted:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},Units->{OptimalLaneIntensity->{Pixel, RFU}}],
			_?ValidGraphicsQ
		],
		Example[{Options,PlotTheme,"A PlotTheme describing the general styling of the plot. Any direct specifications of plot styling will overide the default in the theme:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},PlotTheme -> "Marketing"],
			_?ValidGraphicsQ
		],
		Example[{Options,Map,"Indicates if a list of plots corresponding to each trace will be created, or if all traces within a list will be overlayed on the same plot:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},Map->True],
			{_?ValidGraphicsQ}
		],
		Example[{Options,Zoomable,"Indicates if a dynamic plot which can be zoomed in or out will be returned:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},Zoomable->True],
			_?ValidGraphicsQ
		],
		Example[{Options,OptionFunctions,"A list of functions which take in a list of info packets and plot options and return a list of new options:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},OptionFunctions -> {}],
			_?ValidGraphicsQ
		],
		Example[{Options,Legend,"A list of text descriptions of each data set in the plot:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},Legend->{"sample", "ladder"}],
			_?ValidGraphicsQ
		],
		Example[{Options,LegendPlacement,"Specifies where the legend will be placed relative to the plot:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},LegendPlacement->Right],
			_?ValidGraphicsQ
		],
		Example[{Options,Boxes,"If true, the legend will pair each label with a colored box. If false, the labels will be paired with a colored line:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},Boxes->True],
			_?ValidGraphicsQ
		],
		Example[{Options,FrameLabel,"The label to place on top of the frame:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},FrameLabel->{"length (mm)","intensity (arbitrary unit)",None,None}],
			_?ValidGraphicsQ
		],
		Example[{Options,PlotLabel,"Specifies an overall label for a plot:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},PlotLabel->"my experiment"],
			_?ValidGraphicsQ
		],
		Example[{Options,Output,"Indicate what the function should return:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},Output->Result],
			_?ValidGraphicsQ
		],
		Example[{Options,Output,"Indicate what the function should return:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},Output->Preview],
			_?ValidGraphicsQ
		],
		Example[{Options,Output,"Indicate what the function should return:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},Output->Options],
			{_Rule..}
		],
		Example[{Options,Output,"Indicate what the function should return:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},Output->Tests],
			_List
		],
		Example[{Options,LowExposureLaneIntensity,"The low exposure lane intensity trace to display on the plot:"},
			PlotPAGE[Object[Data, PAGE, "PlotPAGE test data object"],LowExposureLaneIntensity ->Object[Data, PAGE, "PlotPAGE test data object"][LowExposureLaneIntensity]],
			_?ValidGraphicsQ
		],
		Example[{Options,MediumLowExposureLaneIntensity,"The medium-low exposure lane intensity trace to display on the plot:"},
			PlotPAGE[Object[Data, PAGE, "PlotPAGE test data object"],MediumLowExposureLaneIntensity ->Object[Data, PAGE, "PlotPAGE test data object"][MediumLowExposureLaneIntensity]],
			_?ValidGraphicsQ
		],
		Example[{Options,MediumHighExposureLaneIntensity,"The medium-high exposure lane intensity trace to display on the plot:"},
			PlotPAGE[Object[Data, PAGE, "PlotPAGE test data object"],MediumHighExposureLaneIntensity ->Object[Data, PAGE, "PlotPAGE test data object"][MediumHighExposureLaneIntensity]],
			_?ValidGraphicsQ
		],
		Example[{Options,HighExposureLaneIntensity,"The high exposure lane intensity trace to display on the plot:"},
			PlotPAGE[Object[Data, PAGE, "PlotPAGE test data object"],HighExposureLaneIntensity ->Object[Data, PAGE, "PlotPAGE test data object"][HighExposureLaneIntensity]],
			_?ValidGraphicsQ
		],
		Example[{Options,OptimalLaneIntensity,"The optimal exposure lane intensity trace to display on the plot:"},
			PlotPAGE[Object[Data, PAGE, "PlotPAGE test data object"],OptimalLaneIntensity ->Object[Data, PAGE, "PlotPAGE test data object"][OptimalLaneIntensity]],
			_?ValidGraphicsQ
		],
		Example[{Options,OptimalLaneImage,"The optimal lane image to display on the plot:"},
			PlotPAGE[Object[Data, PAGE, "PlotPAGE test data object"],OptimalLaneImage ->Object[Data, PAGE, "PlotPAGE test data object"][OptimalLaneImage]],
			_?ValidGraphicsQ
		],
		Example[{Options,Peaks,"Specification of peaks for primary data:"},
			PlotPAGE[{Object[Data, PAGE, "PlotPAGE test data object"]},Peaks->Object[Analysis, Peaks, "PlotPAGE test peak analysis object"]],
			_?ValidGraphicsQ
		]


	}
];
