(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotAgarose*)


DefineUsage[PlotAgarose,
	{
		BasicDefinitions ->{
			{
				Definition->{"PlotAgarose[agaroseDataObject]","plot"},
				Description->"plots the 'agaroseDataObject' SampleElectropherogram as a list line plot.",
				Inputs:>{
					{
						InputName->"agaroseDataObject",
						Description->"The Object[Data,AgaroseGelElectrophoresis] object to be plotted.",
						Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Data,AgaroseGelElectrophoresis]]]
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
				Definition -> {"PlotAgarose[protocol]", "plot"},
				Description -> "creates a 'plot' of the SampleElectropherogram in the data objects found in the Data field of 'protocol'.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "The protocol object containing agarose gel electrophoresis data objects.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, AgaroseGelElectrophoresis]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The figure generated from data found in the agarose gel electrophoresis protocol.",
						Pattern :> ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"lanes","PlotWestern","PlotPAGE"
		},
		Author -> {"scicomp", "brad", "xiwei.shan", "spencer.clark"},
		Preview->True
	}
];