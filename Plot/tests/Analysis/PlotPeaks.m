(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection::Closed:: *)
(*PlotPeaks*)


DefineTests[PlotPeaks,{

(* definition examples *)
	Example[
		{Basic,"Plot the peak purity from an Object[Analysis,Peaks] Object as a pie chart:"},
		PlotPeaks[Object[Analysis, Peaks, "id:01G6nvkK4l0D"], PlotType->PieChart],
		ValidGraphicsP[]
	],
	Test["Given a packet:",
		PlotPeaks[Download[Object[Analysis, Peaks, "id:01G6nvkK4l0D"]], PlotType->PieChart],
		ValidGraphicsP[]
	],
	Example[
		{Basic,"Plot peak analysis from a link:"},
		PlotPeaks[Link[Object[Analysis, Peaks, "id:01G6nvkK4l0D"],Reference]],
		ValidGraphicsP[],
		Messages:>PlotPeaks::DeprecatedOptions
	],
	Example[
		{Basic,"Plot the peaks associated with a single Object[Data,Chromatography] object as a pie chart of peak purity:"},
		PlotPeaks[Object[Data, Chromatography, "id:Y0lXejGKB9da"], PlotType->PieChart],
		ValidGraphicsP[],
		TimeConstraint -> 120
	],
	Example[
		{Basic,"Plot the peaks associated with a single Object[Data,Western] object as a pie chart of peak purity:"},
		PlotPeaks[Object[Data, Western, "id:vXl9j5qE6Vwe"], PlotType->PieChart],
		ValidGraphicsP[]
	],
	Example[
		{Basic,"Plot the areas of a set of peak purities as a labeled pie chart:"},
		PlotPeaks[{Area->{100,50,50},RelativeArea->{50 Percent,25 Percent,25Percent},PeakLabels->{"Peak 1","Peak 2","Background"}}, PlotType->PieChart],
		ValidGraphicsP[]
	],

(* listable definition input tests *)
	Test[
		"Plot the peak purity from several Object[Analysis,Peaks] Objects as pie charts:",
		PlotPeaks[{Object[Analysis, Peaks, "id:01G6nvkK4l0D"]}, PlotType->PieChart],
		{ValidGraphicsP[]..}
	],
	Test[
		"Plot the peak purity from several Object[Data,Chromatography] Objects as pie charts:",
		PlotPeaks[{Object[Data, Chromatography, "id:Y0lXejGKB9da"]}, PlotType->PieChart],
		{ValidGraphicsP[]..},
		TimeConstraint -> 120
	],
	Test[
		"Plot the peak purity from several Object[Data,Western] Objects as pie charts:",
		PlotPeaks[{Object[Data, Western, "id:vXl9j5qE6Vwe"]}, PlotType->PieChart],
		{ValidGraphicsP[]..}
	],

(* super listable definition input tests *)
	Test[
		"Plot the peak purity from several lists of Object[Analysis,Peaks] Objects as pie charts:",
		PlotPeaks[{{Object[Analysis, Peaks, "id:01G6nvkK4l0D"]}}, PlotType->PieChart],
		{{ValidGraphicsP[]..}..}
	],
	Test[
		"Plot the peak purity from several lists of Object[Data,Chromatography] Objects as pie charts:",
		PlotPeaks[{{Object[Data, Chromatography, "id:Y0lXejGKB9da"]}}, PlotType->PieChart],
		{{ValidGraphicsP[]..}..},
		TimeConstraint -> 120
	],
	Test[
		"Plot the peak purity from several lists of Object[Data,Western] Objects as pie charts:",
		PlotPeaks[{{Object[Data, Western, "id:vXl9j5qE6Vwe"]}}, PlotType->PieChart],
		{{ValidGraphicsP[]..}..}
	],

(* listable definition examples *)
	Example[
		{Attributes,"listable","Plot a list of Object[Analysis,Peaks] Object as a list of pie charts of peak purity:"},
		PlotPeaks[{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]}, PlotType->PieChart],
		{ValidGraphicsP[]..},
		TimeConstraint -> 120
	],
	Example[
		{Attributes,"listable","Plot a mixed list of data Objects as a list of pie charts of peak purity:"},
		PlotPeaks[{Object[Data, Chromatography, "id:Y0lXejGKB9da"],Object[Data, Western, "id:vXl9j5qE6Vwe"]}, PlotType->PieChart],
		{ValidGraphicsP[]..},
		TimeConstraint -> 120
	],


(* PlotType and Display basic examples *)
	Example[
		{Options,PlotType,"Plot the peak purity from an Object[Analysis,Peaks] Object as a bar chart:"},
		PlotPeaks[Object[Analysis, Peaks, "id:01G6nvkK4l0D"],PlotType->BarChart],
		ValidGraphicsP[]
	],
	Example[
		{Options,Display,"Plot the peak areas from an Object[Analysis,Peaks] Object as a bar chart:"},
		PlotPeaks[Object[Analysis, Peaks, "id:01G6nvkK4l0D"],PlotType->BarChart,Display->Area],
		_?ValidGraphicsQ
	],
	Example[
		{Options,PlotType,"Plot the peak widths from an Object[Analysis,Peaks] Object as a bar chart:"},
		PlotPeaks[Object[Analysis, Peaks, "id:01G6nvkK4l0D"],PlotType->BarChart,Display->HalfHeightWidth],
		ValidGraphicsP[]
	],
	Example[
		{Options,PlotType,"Plot the peak heights from an Object[Analysis,Peaks] Object as a bar chart:"},
		PlotPeaks[Object[Analysis, Peaks, "id:01G6nvkK4l0D"],PlotType->BarChart,Display->Height],
		ValidGraphicsP[]
	],
	Example[
		{Options,PlotType,"Plot the peaks associated with a single Object[Data,Chromatography] Object as a barchart automatically displaying peak purity:"},
		PlotPeaks[Object[Data, Chromatography, "id:Y0lXejGKB9da"],PlotType->BarChart],
		ValidGraphicsP[],
		TimeConstraint -> 120
	],
	Example[
		{Options,Display,"Plot the peak areas from a single Object[Data,Chromatography] Object as a bar chart:"},
		PlotPeaks[Object[Data, Chromatography, "id:Y0lXejGKB9da"],PlotType->BarChart,Display->Area],
		ValidGraphicsP[],
		TimeConstraint -> 120
	],
	Example[
		{Options,PlotType,"Plot the peak widths from a single Object[Data,Chromatography] Object as a bar chart:"},
		PlotPeaks[Object[Data, Chromatography, "id:Y0lXejGKB9da"],PlotType->BarChart,Display->HalfHeightWidth],
		ValidGraphicsP[],
		TimeConstraint -> 120
	],
	Example[
		{Options,PlotType,"Plot the peak heights from a single Object[Data,Chromatography] Object as a bar chart:"},
		PlotPeaks[Object[Data, Chromatography, "id:Y0lXejGKB9da"],PlotType->BarChart,Display->Height],
		ValidGraphicsP[],
		TimeConstraint -> 120
	],
	Example[
		{Options,Legend,"Specify a legend:"},
		PlotPeaks[Object[Analysis, Peaks, "id:01G6nvkK4l0D"],Legend->{"a","b","c","d","e","f","g","h","i","j","k","l","m"}, PlotType->PieChart],
		_?Core`Private`ValidLegendedQ
	],
	Example[
		{Options,LegendPlacement,"Specify where the legend should be drawn:"},
		PlotPeaks[Object[Analysis, Peaks, "id:01G6nvkK4l0D"],Legend->{"a","b","c","d","e","f","g","h","i","j","k","l","m"},LegendPlacement->Bottom,PlotType->PieChart],
		_?Core`Private`ValidLegendedQ..
	],
	Example[
		{Options,LegendPlacement,"By default, the legend is drawn on the Right:"},
		PlotPeaks[Object[Analysis, Peaks, "id:01G6nvkK4l0D"],Legend->{"a","b","c","d","e","f","g","h","i","j","k","l","m"},PlotType->PieChart],
		_?Core`Private`ValidLegendedQ..
	],
	Example[
		{Options,Boxes,"By default, boxes are used for legend labels. Set Boxes->False to use lines instead:"},
		PlotPeaks[Object[Analysis, Peaks, "id:01G6nvkK4l0D"],Legend->{"a","b","c","d","e","f","g","h","i","j","k","l","m"},PlotType->PieChart,Boxes->False],
		_?Core`Private`ValidLegendedQ
	],
	Example[
		{Options,ImageSize,"Set the size of the plot. See the documentation of EmeraldPieChart or EmeraldBarChart for more information:"},
		{
			PlotPeaks[Object[Analysis, Peaks, "id:01G6nvkK4l0D"], PlotType->PieChart],
			PlotPeaks[Object[Analysis, Peaks, "id:01G6nvkK4l0D"], PlotType->PieChart, ImageSize->300]
		},
		{ValidGraphicsP[]..}
	],
	Example[
		{Options,Frame,"Specify if a Frame should be drawn. See the documentation of EmeraldPieChart or EmeraldBarChart for more information:"},
		PlotPeaks[Object[Analysis, Peaks, "id:01G6nvkK4l0D"], PlotType->PieChart, Frame->True],
		ValidGraphicsP[]
	],
	Example[
		{Options,AspectRatio,"Set the aspect ratio of the resulting PieChart:"},
		{
			PlotPeaks[Object[Analysis, Peaks, "id:01G6nvkK4l0D"], PlotType->PieChart],
			PlotPeaks[Object[Analysis, Peaks, "id:01G6nvkK4l0D"], PlotType->PieChart, AspectRatio->0.6]
		},
		{ValidGraphicsP[]..}
	],
	Example[
		{Options,AspectRatio,"Set the aspect ratio of the resulting BarChart:"},
		{
			PlotPeaks[Object[Analysis, Peaks, "id:01G6nvkK4l0D"],PlotType->BarChart],
			PlotPeaks[Object[Analysis, Peaks, "id:01G6nvkK4l0D"],PlotType->BarChart,AspectRatio->0.2]
		},
		{ValidGraphicsP[]..}
	],

(* one list Normalized peaks and Display basic tests *)
	Test[
		"Plot the purities of the first peaks normalized to the second peaks associated with each Object[Analysis,Peaks] Object as a barchart:",
		PlotPeaks[{{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]}},Peaks->{{1,2}}, PlotType->PieChart],
		ValidGraphicsP[]
	],
	Test[
		"Plot the areas of the first peaks normalized to the second peaks associated with each Object[Analysis,Peaks] Object as a barchart:",
		PlotPeaks[{{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]}},Peaks->{{1,2}},Display->Area, PlotType->PieChart],
		ValidGraphicsP[]
	],
	Example[
		{Options,Peaks,"Plot the areas of the first peaks normalized to the second peaks associated with each Object[Analysis,Peaks] Object as a barchart:"},
		PlotPeaks[{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},Peaks->{{1,2}},Display->Area, PlotType->PieChart],
		ValidGraphicsP[]
	],
	Test[
		"Plot the areas of the first peaks normalized to the second peaks associated with each Object[Analysis,Peaks] Object as a barchart:",
		PlotPeaks[Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Peaks->{{1,2}},Display->Area, PlotType->BarChart],
		ValidGraphicsP[]
	],

(* two list Normalized peaks and Display basic examples *)
	Example[
		{Options,Peaks,"Plot the areas of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:"},
		PlotPeaks[{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},Peaks->{{1,2}}],
		ValidGraphicsP[]
	],
	Example[
		{Options,Peaks,"Plot the areas of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:"},
		PlotPeaks[{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},Peaks->{1,2}],
		ValidGraphicsP[]
	],
	Example[
		{Options,Peaks,"Plot the areas of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:"},
		PlotPeaks[{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},Peaks->{1}],
		ValidGraphicsP[]
	],
	Example[
		{Options,Peaks,"Plot the areas of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:"},
		PlotPeaks[{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},Peaks->1],
		ValidGraphicsP[]
	],
	Example[
		{Options,Peaks,"Plot the areas of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:"},
		PlotPeaks[{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},Peaks->All],
		ValidGraphicsP[]
	],
	Test[
		"Plot the areas of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:",
		PlotPeaks[Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Peaks->{{1,2}},Display->Area],
		ValidGraphicsP[]
	],
	Test[
		"Plot the areas of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:",
		PlotPeaks[Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Peaks->{1,2},Display->Area],
		ValidGraphicsP[]
	],
	Test[
		"Plot the areas of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:",
		PlotPeaks[Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Peaks->{1},Display->Area],
		ValidGraphicsP[]
	],
	Test[
		"Plot the areas of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:",
		PlotPeaks[Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Peaks->1,Display->Area],
		ValidGraphicsP[]
	],
	Test[
		"Plot the areas of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:",
		PlotPeaks[Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Peaks->All,Display->Area],
		ValidGraphicsP[]
	],
	Test[
		"Plot the heights of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:",
		PlotPeaks[Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Peaks->{{1,2}},Display->Height],
		ValidGraphicsP[]
	],
	Test[
		"Plot the heights of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:",
		PlotPeaks[Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Peaks->{1,2},Display->Height],
		ValidGraphicsP[]
	],
	Test[
		"Plot the heights of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:",
		PlotPeaks[Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Peaks->{1},Display->Height],
		ValidGraphicsP[]
	],
	Test[
		"Plot the heights of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:",
		PlotPeaks[Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Peaks->1,Display->Height],
		ValidGraphicsP[]
	],
	Test[
		"Plot the heights of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:",
		PlotPeaks[Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Peaks->All,Display->Height],
		ValidGraphicsP[]
	],
	Test[
		"Plot the widths of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:",
		PlotPeaks[Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Peaks->{{1,2}},Display->HalfHeightWidth],
		ValidGraphicsP[]
	],
	Test[
		"Plot the widths of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:",
		PlotPeaks[Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Peaks->{1,2},Display->HalfHeightWidth],
		ValidGraphicsP[]
	],
	Test[
		"Plot the widths of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:",
		PlotPeaks[Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Peaks->{1},Display->HalfHeightWidth],
		ValidGraphicsP[]
	],
	Test[
		"Plot the widths of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:",
		PlotPeaks[Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Peaks->1,Display->HalfHeightWidth],
		ValidGraphicsP[]
	],
	Test[
		"Plot the widths of the first set of Object[Analysis,Peaks] Objects normalized to the second set of Object[Analysis,Peaks] Objects as a barchart:",
		PlotPeaks[Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Peaks->All,Display->HalfHeightWidth],
		ValidGraphicsP[]
	],

(* plotting specific peaks as a bar chart *)
	Example[
		{Options,Peaks,"Plot the purity of the first and second peaks associated with each Object[Analysis,Peaks] Object as a barchart:"},
		PlotPeaks[{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},Peaks->{1,2},PlotType->BarChart],
		ValidGraphicsP[]
	],
	Example[
		{Options,Peaks,"Plot the purity of the first peaks associated with each Object[Analysis,Peaks] Object as a barchart:"},
		PlotPeaks[{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},Peaks->{1},PlotType->BarChart],
		ValidGraphicsP[]
	],
	Example[
		{Options,Peaks,"Plot the purity of the first peaks associated with each Object[Analysis,Peaks] Object as a barchart:"},
		PlotPeaks[{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},Peaks->1,PlotType->BarChart],
		ValidGraphicsP[]
	],

	Test[
		"Plot the areas of the first and second peaks associated with each Object[Analysis,Peaks] Object as a barchart:",
		PlotPeaks[{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},Peaks->{1,2},Display->Area,PlotType->BarChart],
		ValidGraphicsP[]
	],
	Test[
		"Plot the areas of the first peaks associated with each Object[Analysis,Peaks] Object as a barchart:",
		PlotPeaks[{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},Peaks->{1},Display->Area,PlotType->BarChart],
		ValidGraphicsP[]
	],
	Test[
		"Plot the heights of the first and second peaks associated with each Object[Analysis,Peaks] Object as a barchart:",
		PlotPeaks[{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},Peaks->{1,2},Display->Height,PlotType->BarChart],
		ValidGraphicsP[]
	],
	Test[
		"Plot the heights of the first peaks associated with each Object[Analysis,Peaks] Object as a barchart:",
		PlotPeaks[{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},Peaks->{1},Display->Height,PlotType->BarChart],
		ValidGraphicsP[]
	],
	Test[
		"Plot the widths of the first and second peaks associated with each Object[Analysis,Peaks] Object as a barchart:",
		PlotPeaks[{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},Peaks->{1,2},Display->HalfHeightWidth,PlotType->BarChart],
		ValidGraphicsP[]
	],
	Test[
		"Plot the widths of the first peaks associated with each Object[Analysis,Peaks] Object as a barchart:",
		PlotPeaks[{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},Peaks->{1},Display->HalfHeightWidth,PlotType->BarChart],
		ValidGraphicsP[]
	],

(* plotting only specific peaks in the pie chart *)
	Example[
		{Options,Peaks,"Plot the purity of the first and second peaks associated with each Object[Analysis,Peaks] Object as a barchart:"},
		PlotPeaks[{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},Peaks->{1,2},PlotType->PieChart],
		{ValidGraphicsP[]..}
	],

(* plotting normalized peaks from data *)
	Test[
		"Plot the purities of the first peaks normalized to the second peaks associated with each SimpleWestern data object as a barchart:",
		PlotPeaks[{{Object[Data, Western, "id:mnk9jO3qLAaN"],Object[Data, Western, "id:7X104vK9AW5k"],Object[Data, Western, "id:xRO9n3vkr5qj"],Object[Data, Western, "id:J8AY5jwzV48D"],Object[Data, Western, "id:bq9LA0dB4Z6a"]}},Peaks->{{1,2}},PlotType->BarChart],
		ValidGraphicsP[]
	],
	Test[
		"Plot the areas of the first peaks normalized to the second peaks associated with each SimpleWestern data object as a barchart:",
		PlotPeaks[{{Object[Data, Western, "id:mnk9jO3qLAaN"],Object[Data, Western, "id:7X104vK9AW5k"],Object[Data, Western, "id:xRO9n3vkr5qj"],Object[Data, Western, "id:J8AY5jwzV48D"],Object[Data, Western, "id:bq9LA0dB4Z6a"]}},Peaks->{{1,2}},Display->Area,PlotType->BarChart],
		ValidGraphicsP[]
	],
	Example[
		{Options,Peaks,"Plot the areas of the first peaks normalized to the second peaks associated with each SimpleWestern data object as a barchart:"},
		PlotPeaks[{Object[Data, Western, "id:mnk9jO3qLAaN"],Object[Data, Western, "id:7X104vK9AW5k"],Object[Data, Western, "id:xRO9n3vkr5qj"],Object[Data, Western, "id:J8AY5jwzV48D"],Object[Data, Western, "id:bq9LA0dB4Z6a"]},Peaks->{{1,2}},Display->Area,PlotType->BarChart],
		ValidGraphicsP[]
	],
	Test[
		"Plot the areas of the first peaks normalized to the second peaks associated with each SimpleWestern data object as a barchart:",
		PlotPeaks[Object[Data, Western, "id:mnk9jO3qLAaN"],Peaks->{{1,2}},Display->Area,PlotType->BarChart],
		ValidGraphicsP[]
	],

(* plotting specific peaks from data as a bar chart *)
	Example[
		{Options,Peaks,"Plot the purity of the first and second peaks associated with each SimpleWestern data object as a piechart:"},
		PlotPeaks[{Object[Data, Western, "id:mnk9jO3qLAaN"],Object[Data, Western, "id:7X104vK9AW5k"],Object[Data, Western, "id:xRO9n3vkr5qj"],Object[Data, Western, "id:J8AY5jwzV48D"],Object[Data, Western, "id:bq9LA0dB4Z6a"]},Peaks->{1,2},PlotType->PieChart],
		{ValidGraphicsP[]..}
	],
	Example[
		{Options,Peaks,"Plot the purity of the first and second peaks associated with each SimpleWestern data object as a barchart:"},
		PlotPeaks[{Object[Data, Western, "id:mnk9jO3qLAaN"],Object[Data, Western, "id:7X104vK9AW5k"],Object[Data, Western, "id:xRO9n3vkr5qj"],Object[Data, Western, "id:J8AY5jwzV48D"],Object[Data, Western, "id:bq9LA0dB4Z6a"]},Peaks->{1,2},PlotType->BarChart],
		ValidGraphicsP[]
	],
	Example[
		{Options,Peaks,"Plot the purity of the first peaks associated with each SimpleWestern data object as a barchart:"},
		PlotPeaks[{Object[Data, Western, "id:mnk9jO3qLAaN"],Object[Data, Western, "id:7X104vK9AW5k"],Object[Data, Western, "id:xRO9n3vkr5qj"],Object[Data, Western, "id:J8AY5jwzV48D"],Object[Data, Western, "id:bq9LA0dB4Z6a"]},Peaks->{1},PlotType->BarChart],
		ValidGraphicsP[]
	],
	Example[
		{Options,Peaks,"Plot the purity of the first peaks associated with each SimpleWestern data object as a barchart:"},
		PlotPeaks[{Object[Data, Western, "id:mnk9jO3qLAaN"],Object[Data, Western, "id:7X104vK9AW5k"],Object[Data, Western, "id:xRO9n3vkr5qj"],Object[Data, Western, "id:J8AY5jwzV48D"],Object[Data, Western, "id:bq9LA0dB4Z6a"]},Peaks->1,PlotType->BarChart],
		ValidGraphicsP[]
	],


	Test[
		"Plot a list of Object[Analysis,Peaks] Object as a list of bar charts of peak purity:",
		PlotPeaks[{Object[Analysis, Peaks, "id:n0k9mGzRE7W6"],Object[Analysis, Peaks, "id:o1k9jAKOYEWa"],Object[Analysis, Peaks, "id:L8kPEjNLqeoN"],Object[Analysis, Peaks, "id:kEJ9mqaVzk58"],Object[Analysis, Peaks, "id:D8KAEvdq1VRR"]},PlotType->BarChart],
		{ValidGraphicsP[]..}
	],

	Test[
		"Plot a list of data objects as a list of bar charts of peak height:",
		PlotPeaks[{{Object[Data, Western, "id:n0k9mGzREGJn"],Object[Data, Western, "id:01G6nvkK4v5r"],Object[Data, Western, "id:AEqRl954D9pa"],Object[Data, Western, "id:zGj91aR3NaXn"],Object[Data, Western, "id:rea9jl1o3l7B"]},{Object[Data, Western, "id:mnk9jO3qLAaN"],Object[Data, Western, "id:7X104vK9AW5k"],Object[Data, Western, "id:xRO9n3vkr5qj"],Object[Data, Western, "id:J8AY5jwzV48D"],Object[Data, Western, "id:bq9LA0dB4Z6a"]},{Object[Data, Western, "id:qdkmxz0A8xrV"],Object[Data, Western, "id:qdkmxz0A8xx1"]}},Display->Height, PlotType->BarChart],
		{{ValidGraphicsP[]..}..}
	],
	Test[
		"Plot a list of data objects as a list of bar charts of peak width:",
		PlotPeaks[{{Object[Data, Western, "id:n0k9mGzREGJn"],Object[Data, Western, "id:01G6nvkK4v5r"],Object[Data, Western, "id:AEqRl954D9pa"],Object[Data, Western, "id:zGj91aR3NaXn"],Object[Data, Western, "id:rea9jl1o3l7B"]},{Object[Data, Western, "id:mnk9jO3qLAaN"],Object[Data, Western, "id:7X104vK9AW5k"],Object[Data, Western, "id:xRO9n3vkr5qj"],Object[Data, Western, "id:J8AY5jwzV48D"],Object[Data, Western, "id:bq9LA0dB4Z6a"]},{Object[Data, Western, "id:qdkmxz0A8xrV"],Object[Data, Western, "id:qdkmxz0A8xx1"]}},Display->HalfHeightWidth, PlotType->BarChart],
		{{ValidGraphicsP[]..}..}
	],

(* PurityP input examples *)
	Test[
		"Plot the purity of a set of peaks as a bar chart:",
		PlotPeaks[{Area->{100,50,50},RelativeArea->{50 Percent,25 Percent,25Percent},PeakLabels->{"Peak 1","Peak 2","Background"}},PlotType->BarChart],
		ValidGraphicsP[]
	],
	Test[
		"Plot the areas of a list of sets of peaks as labeled pie charts:",
		PlotPeaks[{{Area->{100,50,50},RelativeArea->{50 Percent,25 Percent,25Percent},PeakLabels->{"Peak 1","Peak 2","Background"}},{Area->{150,50},RelativeArea->{75 Percent,25Percent},PeakLabels->{"Peak 1","Background"}}}, PlotType->PieChart],
		{ValidGraphicsP[]..}
	],
	Test[
		"Plot the purity of a list of sets of peaks as bar charts:",
		PlotPeaks[{{Area->{100,50,50},RelativeArea->{50 Percent,25 Percent,25Percent},PeakLabels->{"Peak 1","Peak 2","Background"}},{Area->{150,50},RelativeArea->{75 Percent,25Percent},PeakLabels->{"Peak 1","Background"}}},PlotType->BarChart],
		{ValidGraphicsP[]..}
	],

(* chart label related examples *)
	Example[
		{Options,ChartLabels,"Set integers to be the labels for each bar in the barchart:"},
		PlotPeaks[Object[Data, Western, "id:vXl9j5qE6Vwe"],PlotType->BarChart,ChartLabels->{1,2,3}],
		ValidGraphicsP[]
	],
	Example[
		{Options,ChartLabels,"Set strings to be the labels for each bar in the barchart:"},
		PlotPeaks[Object[Data, Western, "id:vXl9j5qE6Vwe"],PlotType->BarChart,ChartLabels->{"Cat","Dog","Hamster"}],
		ValidGraphicsP[]
	],
	Example[
		{Options,ChartLabelOrientation,"Change the orientation of the chart labels on the barchart:"},
		PlotPeaks[Object[Data, Western, "id:vXl9j5qE6Vwe"],PlotType->BarChart,ChartLabelOrientation->Horizontal],
		ValidGraphicsP[]
	],
	Example[
		{Options,ChartLabelOrientation,"Change the orientation of the chart labels on the barchart:"},
		PlotPeaks[Object[Data, Western, "id:vXl9j5qE6Vwe"],PlotType->BarChart,ChartLabelOrientation->Vertical,ChartLabels->{1,2,3}],
		ValidGraphicsP[]
	],
	Example[
		{Options,ChartLabels,"Set the labels for each slice in the piechart:"},
		PlotPeaks[Object[Data, Western, "id:vXl9j5qE6Vwe"],PlotType->PieChart,ChartLabels->{"Cat","Dog"}],
		ValidGraphicsP[]
	],

(* error messages *)
	Example[
		{Message, "DeprecatedOptions","Plotting Object[Analysis, Peaks] or data with links to Object[Analysis, Peaks] with deprecated options will throw a warning:"},
		PlotPeaks[Object[Data, Western, "id:vXl9j5qE6Vwe"]],
		ValidGraphicsP[],
		Messages:>PlotPeaks::DeprecatedOptions
	],
	Example[
		{Messages,"NoPeaks","When no peaks are present, no plot will be created:"},
		PlotPeaks[{Area->{0},RelativeArea->{0 Percent},PeakLabels->{"Peak 1"}}],
		Null,
		Messages:>PlotPeaks::NoPeaks
	],
	Example[
		{Messages,"NoPeaks","When no peaks are present, no plot will be created:"},
		PlotPeaks[Download[Object[Data, qPCR, "id:XnlV5jmbVnNB"]]],
		Null,
		Messages:>PlotPeaks::NoPeaks
	],
	Example[
		{Messages,"TooFewPeaks","When more peaks are requested in the peaks option than exist in the associated Object[Analysis,Peaks] object, the function will plot all the peaks:"},
		PlotPeaks[Object[Data, Western, "id:vXl9j5qE6Vwe"],PlotType->BarChart,Peaks->{1,2,3,4}],
		ValidGraphicsP[],
		Messages:>PlotPeaks::TooFewPeaks
	],
	Example[
		{Messages,"TooFewPeaks","When the requested peak index in the peaks option is greater than the number of peaks in the associated Object[Analysis,Peaks] object, the function will plot the last peak:"},
		PlotPeaks[Object[Data, Western, "id:vXl9j5qE6Vwe"],PlotType->BarChart,Peaks->4],
		ValidGraphicsP[],
		Messages:>PlotPeaks::TooFewPeaks
	],
	Example[
		{Messages,"TooFewPeaks","When the requested peak index in the peaks option is greater than the number of peaks in the associated Object[Analysis,Peaks] object, the function will plot the last peak:"},
		PlotPeaks[Object[Data, Western, "id:vXl9j5qE6Vwe"],PlotType->BarChart,Peaks->{{4,1}}],
		ValidGraphicsP[],
		Messages:>PlotPeaks::TooFewPeaks
	],
	Example[
		{Messages,"DifferentDataFamilies","When different data objects of different families are provided, the function will not evaluate:"},
		PlotPeaks[Object[Data, Western, "id:vXl9j5qE6Vwe"],Object[Data, Chromatography, "id:Y0lXejGKB9da"]],
		Null,
		Messages:>PlotPeaks::DifferentDataFamilies
	],
	Example[
		{Messages,"DifferentDataFamilies","When different data objects of different families are provided, the function will not evaluate:"},
		PlotPeaks[{Object[Data, Chromatography, "id:Y0lXejGKB9da"],Object[Data, Western, "id:vXl9j5qE6Vwe"]},Display->Area],
		Null,
		Messages:>PlotPeaks::DifferentDataFamilies
	],

	Test["Plotting object with no peaks found:",
		PlotPeaks[<|Area -> {}, Height -> {}, ParentPeak -> {},
			PeakRangeStart -> {}, Position -> {},
			Type -> Object[Analysis, Peaks], WidthRangeEnd -> {},
			Purity -> {Area -> {0}, RelativeArea -> {Quantity[100, "Percent"]},
				PeakLabels -> {"Background"}}|>],
		Null
	]

}];
