(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDynamicLightScattering*)


DefineUsage[PlotDynamicLightScattering,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotDynamicLightScattering[dlsDataObject]", "plot"},
				Description->"plots the `dlsDataObject` data as a list line plot.",
				Inputs:>{
					{
						InputName->"dlsDataObject",
						Description->"The Object[Data,DynamicLightScattering] object to be plotted.",
						Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Data,DynamicLightScattering]]]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A graphical representation of the data as a list line plot.",
						Pattern:>ValidGraphicsP[]
					}
				}
			},
			{
				Definition->{"PlotDynamicLightScattering[coordinates]", "plot"},
				Description->"the xy points making up the spectrum to be plotted.",
				Inputs:>{
					{
						InputName->"coordinates",
						Description->"The spectra you wish to plot.",
						Widget->Widget[Type->Expression,Pattern:>CoordinatesP,Size->Paragraph]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A graphical representation of the data as a list line plot.",
						Pattern:>ValidGraphicsP[]
					}
				}
			},
			{
				Definition->{"PlotDynamicLightScattering[MeltingCurveObject]", "plot"},
				Description->"plots the initial and final particles size distributions from the 'MeltingCurveObject' data.",
				Inputs:>{
					{
						InputName->"MeltingCurveObject",
						Description->"The object that contains the initial and final particle size distributions",
						Widget->Widget[Type->Expression,Pattern:>CoordinatesP,Size->Paragraph]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A graphical representation of the particle size for the initial and final mass distributions.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"PlotObject",
			"ExperimentDynamicLightScattering",
			"PlotDynamicLightScatteringAnalysis"
		},
		Author -> {"kelmen.low", "harrison.gronlund", "weiran.wang", "spencer.clark"},
		Preview->True
	}
];