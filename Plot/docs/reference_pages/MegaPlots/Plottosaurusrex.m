(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(* Plottosaurusrex *)


DefineUsage[Plottosaurusrex,{
	BasicDefinitions->
		{
			{"Plottosaurusrex[data]","dinosaur","generates a plot of 'data' by instead plotting a 'dinosaur' which may or may not bear any relation to your data."}
		},
	Input:>
		{
			{"data",___,"Data to plot on primary (left) axis."}
		},
	Output:>
		{
			{"dinosaur",_Image,"A picture of a dinosaur."}
		},
	SeeAlso ->
		{
			"ListLinePlot",
			"EmeraldListLinePlot",
			"PlotChromatography"
		},
	Author->{"tyler.pabst", "daniel.shlian", "steven", "frezza"}
}];