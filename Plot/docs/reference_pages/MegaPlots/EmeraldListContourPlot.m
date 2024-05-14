(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*EmeraldListContourPlot*)


DefineUsage[EmeraldListContourPlot,
{
	BasicDefinitions -> {
		{
			Definition->{"EmeraldListContourPlot[zvalues]","chart"},
			Description->"creates a ListContourPlot from the input 'zvalues'.",
			Inputs:>{
				{
					InputName->"zvalues",
					Description->"List of data point z values.",
					Widget->Adder[Alternatives[
						"z values at y"->Adder[Alternatives[
							"z value at {x,y}"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word]
						]]
					]]
				}
			},
			Outputs:>{
				{
					OutputName->"chart",
					Description->"A contour plot of 'zvalues'.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"EmeraldListContourPlot[dataset]","chart"},
			Description->"creates a ListContourPlot from the input 'dataset'.",
			Inputs:>{
				{
					InputName->"dataset",
					Description->"List of data point triplets.",
					Widget->Adder[
						{
							"x"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word],
							"y"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word],
							"z"->Widget[Type->Expression,Pattern:>UnitsP[],Size->Word]
						}
					]
				}
			},
			Outputs:>{
				{
					OutputName->"chart",
					Description->"A contour plot of 'dataset'.",
					Pattern:>ZoomableP|_Graphics|_Legended|ValidGraphicsP[]
				}
			}
		}
	},
	SeeAlso -> {
		"ListContourPlot",
		"EmeraldListLinePlot",
		"PlotObject"
	},
	Author -> {"scicomp", "brad", "hayley"},
	Sync -> Automatic,
	Preview->True
}];