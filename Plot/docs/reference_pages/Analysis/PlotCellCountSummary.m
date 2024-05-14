(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*PlotCellCountSummary*)


DefineUsage[PlotCellCountSummary,
{
	BasicDefinitions -> {
		{
			Definition->{"PlotCellCountSummary[CellCount]","plot"},
			Description->"returns a 'plot' of the cell counts from a 'CellCount' Object or Packet.",
			Inputs:>{
				{
				InputName->"CellCount",
				Description->"An Object[Analysis,CellCount] Object or Packet.",
				Widget->If[
					TrueQ[$ObjectSelectorWorkaround],
					Alternatives[
						"Enter object:"->Widget[Type->Expression,Pattern:>ObjectP[Object[Analysis,CellCount]],Size->Line],
						"Select object:"->Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,CellCount]],ObjectTypes->{Object[Analysis,CellCount]}]
					],
					Widget[Type->Object,Pattern:>ObjectP[Object[Analysis,CellCount]],ObjectTypes->{Object[Analysis,CellCount]}]
				]
				}
			},
			Outputs:>{
				{
				OutputName->"plot",
				Description->"A plot of the cell count.",
				Pattern:>_Graphics
				}
			}
		}
	},
	SeeAlso -> {
		"PlotMicroscope",
		"PlotCellCount"
	},
	Author -> {
		"sebastian.bernasek",
		"brad"
	},
	Preview->True
}];
