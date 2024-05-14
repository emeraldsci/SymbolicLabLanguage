(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotWestern*)


DefineTests[PlotWestern,
	{
		Example[
			{Basic, "Plot the spectrum from one Object[Data,Western] Object:"},
			PlotWestern[Object[Data, Western, "id:qdkmxz0A8xx1"]],
			_?ValidGraphicsQ
		],
		Test[
			"Given a packet:",
			PlotWestern[Download[Object[Data, Western, "id:qdkmxz0A8xx1"]]],
			_?ValidGraphicsQ
		],
		Example[
			{Basic, "Plot western data in a link:"},
			PlotWestern[Link[Object[Data, Western, "id:qdkmxz0A8xx1"],Protocol]],
			_?ValidGraphicsQ
		],
		Test[
			"Plot the spectrum from one Object[Data,Western] Object:",
			PlotWestern[Download[Object[Data, Western, "id:qdkmxz0A8xx1"],MassSpectrum]],
			_?ValidGraphicsQ
		],

		Example[
			{Attributes,"ObjectP[Object[Data,Western]]", "Plot the spectrum from one Object[Data,Western] Object:"},
			PlotWestern[Object[Data, Western, "id:qdkmxz0A8xx1"]],
			_?ValidGraphicsQ
		],
		Example[
			{Attributes,"Listable", "Plot the spectra from several Object[Data,Western] Object:"},
			PlotWestern[{Object[Data, Western, "id:qdkmxz0A8xrV"],Object[Data, Western, "id:qdkmxz0A8xx1"]}],
			_?Core`Private`ValidLegendedQ
		],
		Example[
			{Options, PlotLabel, "Add a label to the plot:"},
			PlotWestern[Object[Data, Western, "id:qdkmxz0A8xx1"],PlotLabel->"Simple Label"],
			_?ValidGraphicsQ
		],
		Example[
			{Options, PrimaryData, "Specify the field name containing the data to be plotted:"},
			PlotWestern[{Object[Data, Western, "id:qdkmxz0A8xrV"],Object[Data, Western, "id:qdkmxz0A8xx1"]},PrimaryData->MassSpectrum],
			_?ValidGraphicsQ
		],
		Example[
			{Options, SecondaryData, "Specify the field name containing the secondary data to be plotted:"},
			PlotWestern[{Object[Data, Western, "id:qdkmxz0A8xrV"],Object[Data, Western, "id:qdkmxz0A8xx1"]},SecondaryData-> {MassSpectrum}],
			_?ValidGraphicsQ
		],
		Example[
			{Options, IncludeReplicates, "Specify if the average of PrimaryData will be be plotted with error bars:"},
			PlotWestern[Object[Data, Western, "id:jLq9jXvjqw8E"],IncludeReplicates->True],
			_?ValidGraphicsQ
		],
		Example[
			{Options, TargetUnits, "Specify the desired units of the x and y axes of the plot:"},
			PlotWestern[Object[Data, Western, "id:qdkmxz0A8xx1"],TargetUnits->{Kilogram/Mole,Lumen}],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Zoomable,"Disallow interactive zooming by setting Zoomable->False:"},
			PlotWestern[Object[Data, Western, "id:qdkmxz0A8xx1"],Zoomable->False],
			_?ValidGraphicsQ
		],
		Example[{Options,OptionFunctions,"Turn off formatting by clearing the option functions:"},
			PlotWestern[Object[Data, Western, "id:qdkmxz0A8xx1"],OptionFunctions -> {}],
			_?ValidGraphicsQ,
			TimeConstraint->120
		],
		Example[
			{Options,LegendPlacement,"Indicate that the legend should be placed to the right of the plot:"},
			PlotWestern[Object[Data, Western, "id:qdkmxz0A8xx1"],LegendPlacement -> Right],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Boxes,"Indicate that colors in the legend should be displayed using colored squares instead of lines:"},
			PlotWestern[Object[Data, Western, "id:qdkmxz0A8xx1"],Boxes -> True],
			_?ValidGraphicsQ
		],
		Example[
			{Options,MassSpectrum,"Specify the mass spectrum trace to display on the plot:"},
			PlotWestern[Object[Data, Western, "id:qdkmxz0A8xx1"],MassSpectrum->Download[Object[Data, Western, "id:qdkmxz0A8xx1"],MassSpectrum]],
			_?ValidGraphicsQ
		],
		Example[
			{Options,Peaks,"Indicate the peaks that should be overlaid on the plot:"},
			PlotWestern[Object[Data, Western, "id:qdkmxz0A8xx1"],Peaks->Object[Analysis, Peaks, "id:qdkmxz0APelp"]],
			_?ValidGraphicsQ
		],
		Example[
			{Options, Normalize, "Normalize the spectrum to the maximum y-value point:"},
			PlotWestern[{Object[Data, Western, "id:qdkmxz0A8xrV"],Object[Data, Western, "id:qdkmxz0A8xx1"]},Normalize->1058.24 Lumen],
			_?Core`Private`ValidLegendedQ
		],
		Example[
			{Options, ImageSize, "Set the size of the outputed graphics:"},
			PlotWestern[Object[Data, Western, "id:qdkmxz0A8xx1"],ImageSize->500],
			_?ValidGraphicsQ
		],
		Example[
			{Options, Display, "Do not display any additional information on the plot:"},
			PlotWestern[Object[Data, Western, "id:qdkmxz0A8xx1"],Display->{}],
			_?ValidGraphicsQ
		],
		Example[
			{Options, Legend, "Automatically create a legend with the Object[Data,Western] Object Key:"},
			PlotWestern[{Object[Data, Western, "id:qdkmxz0A8xrV"],Object[Data, Western, "id:qdkmxz0A8xx1"]},Legend->Automatic],
			_?Core`Private`ValidLegendedQ
		],
		Example[
			{Options, Legend, "Create a custom legend:"},
			PlotWestern[Object[Data, Western, "id:qdkmxz0A8xx1"],Legend->{"My data"}],
			_?Core`Private`ValidLegendedQ
		],
		Example[
			{Options, Legend, "Do not display a legend:"},
			PlotWestern[Object[Data, Western, "id:qdkmxz0A8xx1"],Legend->Null],
			_?ValidGraphicsQ
		],
		Example[{Options, PlotRange, "Specify the plot range:"},
			PlotWestern[Object[Data, Western, "id:qdkmxz0A8xx1"],PlotRange->{{0 Kilo Gram/Mole,150 Kilo Gram/Mole},Full}],
			_?ValidGraphicsQ
		],
		Example[{Options, FrameLabel, "Specify the frame label:"},
			PlotWestern[Object[Data, Western, "id:qdkmxz0A8xx1"],FrameLabel->{"kDa","Chemiluminescence"}],
			_?ValidGraphicsQ
		],
		Example[{Options, Map, "Plot each Object[Data,Western] object individually, returning a list of plots:"},
			PlotWestern[{Object[Data, Western, "id:qdkmxz0A8xrV"],Object[Data, Western, "id:qdkmxz0A8xx1"]},Map->True],
			{_?ValidGraphicsQ..}
		]
	}
];
