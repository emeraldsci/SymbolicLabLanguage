(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFlowCytometry*)


DefineUsage[PlotFlowCytometry,
{
	BasicDefinitions -> {
		{"PlotFlowCytometry[flowData]", "fig", "plots the specified datasets of 'flowData'."}
	},
	Input :> {
		{"flowData", ListableP[ObjectP[Object[Data,FlowCytometry]]], "Flow cytometry data object(s)."}
	},
	Output :> {
		{"fig", _ValidGraphicsQ, "Plot comparing the given data sets."}
	},
	SeeAlso -> {
		"ExperimentFlowCytometry"
	},
	Author -> {"eunbin.go", "ryan.bisbey", "charlene.konkankit", "cgullekson"}
}];