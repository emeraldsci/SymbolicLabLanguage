(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotTLC*)


DefineUsage[PlotTLC,
{
	BasicDefinitions -> {
		{"PlotTLC[laneImage]", "plot", "returns a pixel intensity plot of the given lane image, with lane image across top of plot."}
	},
	Input :> {
		{"laneImage", _Image | _Graphics, "An image or graphic to plot pixel intensity from."}
	},
	Output :> {
		{"plot", _Graphic, "A graphical representation of the lane."}
	},
	SeeAlso -> {
		"plot",
		"PlotPAGE"
	},
	Author -> {"hayley", "mohamad.zandian", "brad"}
}];