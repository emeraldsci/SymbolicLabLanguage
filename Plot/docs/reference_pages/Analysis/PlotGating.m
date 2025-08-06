(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotGating*)


DefineUsage[PlotGating,
{
	BasicDefinitions->{
		{
			Definition->{"PlotGating[gateObject]","plot"},
			Description->"generates a plot from the clustered data in the provided 'gateObject'.",
			Inputs:>{
				{
					InputName->"gateObject",
					Description->"An Object or Packet containing or associated with clustered data.",
					Widget->Widget[Type->Object,Pattern:>ObjectP[{Object[Data,FlowCytometry],Object[Analysis,Gating]}]]
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"A plot showing the clustered input data associated with 'gateObject'.",
					Pattern:>ValidGraphicsP[]
				}
			}
		}
	},
	SeeAlso -> {
		"PlotFlowCytometry",
		"AnalyzeGating"
	},
	Author -> {"dirk.schild", "kevin.hou", "alice", "brad", "Catherine", "Ruben"},
	Preview->True
}];