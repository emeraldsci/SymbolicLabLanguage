(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFlowCytometry*)


DefineUsage[PlotFlowCytometry,
{
	BasicDefinitions -> {
		{
			Definition -> {"PlotFlowCytometry[data]", "plot"},
			Description -> "creates a 'plot' of the flow cytometry 'data'.",
			Inputs :> {
				{
					InputName -> "data",
					Description -> "The flow cytometry data object(s).",
					Widget -> Alternatives[
						"Single Object" -> Widget[Type -> Object, Pattern :> ObjectP[Object[Data, FlowCytometry]]],
						"Multiple Objects" -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Data, FlowCytometry]]]]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "plot",
					Description -> "Plot comparing the given data sets.",
					Pattern :> ValidGraphicsP[]
				}
			}
		},
		{
			Definition -> {"PlotFlowCytometry[protocol]", "plot"},
			Description -> "creates a 'plot' of the flow cytometry data objects found in the Data field of 'protocol'.",
			Inputs :> {
				{
					InputName -> "protocol",
					Description -> "The protocol object containing flow cytometry data objects.",
					Widget -> Alternatives[
						Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, FlowCytometry]]]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "plot",
					Description -> "The figure generated from data found in the flow cytometry protocol.",
					Pattern :> ValidGraphicsP[]
				}
			}
		}
	},
	SeeAlso -> {
		"ExperimentFlowCytometry"
	},
	Author -> {"dirk.schild", "eunbin.go", "ryan.bisbey", "charlene.konkankit", "cgullekson"}
}];