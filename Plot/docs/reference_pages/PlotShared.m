(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)


(* ::Subsubsection::Closed:: *)
(*AutomaticYRange*)


DefineUsage[AutomaticYRange,
{
	BasicDefinitions -> {
		{"AutomaticYRange[data, offset]", "list", "returns the range of a data set, defined as Y Maximum and Minimum of a 'data' set \[PlusMinus] a specified 'offset'."}
	},
	AdditionalDefinitions -> {

	},
	Input :> {
		{"data", DateCoordinateP | {{_?DateObjectQ, _?UnitsQ}..}, "A dataset in the form {{date, value}..}."},
		{"offset", _?NumericQ, "Desired range offset from the maximum and minimum Y values."}
	},
	Output :> {
		{"list", {_?NumericQ, _?NumericQ}, "A range for the Y axis."}
	},
	Behaviors -> {

	},
	Guides -> {

	},
	Tutorials -> {

	},
	Sync -> Automatic,
	SeeAlso -> {
		"PlotSensor",
		"plot"
	},
	Author -> {"scicomp", "brad"}
}];


(* ::Subsubsection::Closed:: *)
(*FindPlotRange*)


DefineUsage[FindPlotRange,
{
	BasicDefinitions -> {
		{"FindPlotRange[rawPlotRange, plotData]", "range", "calculates a plot range from 'plotData'."}
	},
	MoreInformation -> {
		"Full means shows all the data to the Axis.",
		"All means just show all the data and nothing more.",
		"Automatic means show all the data within the other constraints provided."
	},
	Input :> {
		{"rawPlotRange", _List | All | Automatic | Full, "The raw range form as entered by the user. This can be input in any acceptable PlotRange form."},
		{"plotData", {_?NumericQ..} | CoordinatesP | DateCoordinateP, "The data that is going to be plotted. This data is used to prune the plot range."}
	},
	Output :> {
		{"range", {{_?NumericQ, _?NumericQ}, {_?NumericQ, _?NumericQ}}, "List of four elements with that are the coordinates of the plot range."}
	},
	SeeAlso -> {
		"ListLinePlot",
		"FullPlotRange"
	},
	Author -> {
		"Jonathan",
		"Ruben",
		"robert"
	}
}];


(* ::Subsection::Closed:: *)
(*MotifForm*)


DefineUsage[MotifForm,
{
	BasicDefinitions -> {
		{"MotifForm[expr]", "newExpr", "looks inside 'expr' for anything of the form Structure[__] and renders them as graph images at the motif level."}
	},
	MoreInformation -> {
		"Rendering is strictly a matter of display; the output is equivalent to the input for the purposes of evaluation.",
		"One weird caveat: if you want to copy one of the graphs that gets output from MotifForm, you will need to SELECT it and copy, not CLICK it and copy."
	},
	Input :> {
		{"expr", _, "Any expression whose structures will be replaced with motif pictures."}
	},
	Output :> {
		{"newExpr", _, "Given 'expr' with structures rendered as motif pictures."}
	},
	SeeAlso -> {
		"PlotReactionMechanism",
		"Structure"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];


(* ::Subsubsection::Closed:: *)
(*StructureForm*)


DefineUsage[StructureForm,
{
	BasicDefinitions -> {
		{"StructureForm[expr]", "newExpr", "looks inside 'expr' for anything of the form Structure[__] and renders them as graph images at the nucleotide level."}
	},
	MoreInformation -> {
		"Rendering is strictly a matter of display; the output is equivalent to the input for the purposes of evaluation.",
		"One weird caveat: if you want to copy one of the graphs that gets output from MotifForm, you will need to SELECT it and copy, not CLICK it and copy."
	},
	Input :> {
		{"expr", _, "Any expression whose structures will be replaced with structure pictures."}
	},
	Output :> {
		{"newExpr", _, "Given 'expr' with structures rendered as structure pictures."}
	},
	SeeAlso -> {
		"MotifForm",
		"PlotReactionMechanism"
	},
	Author -> {"scicomp", "brad", "alice", "qian", "thomas"}
}];



(* ::Subsection::Closed:: *)
(*Strict testing stuff*)


Authors[emeraldListLinePlotStrict]={"kevin.hou","amir.saadat","sebastian.bernasek","thomas","brad", "jenny"};
Authors[emeraldDateListPlotStrict]={"kevin.hou","amir.saadat","sebastian.bernasek","thomas","brad", "jenny"};
Authors[emeraldBarChartStrict]={"kevin.hou","amir.saadat","sebastian.bernasek","thomas","brad", "jenny"};
Authors[emeraldPieChartStrict]={"kevin.hou","amir.saadat","sebastian.bernasek","thomas","brad", "jenny"};
Authors[emeraldHistogramStrict]={"kevin.hou","amir.saadat","sebastian.bernasek","thomas","brad", "jenny"};
Authors[emeraldBoxWhiskerChartStrict]={"kevin.hou","amir.saadat","sebastian.bernasek","thomas","brad", "jenny"};