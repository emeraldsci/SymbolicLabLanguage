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
			},
			{
				Definition -> {"PlotSurfaceTension[protocol]", "plot"},
				Description -> "creates a 'plot' of surface tension data found in the Data field of 'protocol'.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "The protocol object containing surface tension data objects.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, MeasureSurfaceTension]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The figure generated from data found in the MeasureSurfaceTension protocol.",
						Pattern :> ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"AnalyzeCriticalMicelleConcentration",
			"PlotCriticalMicelleConcentration"
		},
		Author -> {"dirk.schild", "eunbin.go", "ryan.bisbey", "charlene.konkankit", "cgullekson"},
		Preview->True
	}
];