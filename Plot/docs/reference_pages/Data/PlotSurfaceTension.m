(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotSurfaceTension*)

DefineUsage[PlotSurfaceTension,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotSurfaceTension[surfaceTensionData]", "plot"},
				Description->"displays surface tension vs dilution factor for the supplied 'surfaceTensionData'.",
				Inputs:>{
					{
						InputName->"surfaceTensionData",
						Description->"Surface tension data you wish to plot.",
						Widget->Alternatives[
							"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data, SurfaceTension]]],
							"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data, SurfaceTension]]]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"The surface tension plot.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"AnalyzeCriticalMicelleConcentration",
			"PlotCriticalMicelleConcentration"
		},
		Author -> {"eunbin.go", "ryan.bisbey", "charlene.konkankit", "cgullekson"},
		Preview->True
	}
];