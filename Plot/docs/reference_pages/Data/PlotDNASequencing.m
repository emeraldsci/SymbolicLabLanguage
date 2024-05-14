(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotDNASequencing*)


DefineUsage[PlotDNASequencing,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotDNASequencing[dataObject]", "plot"},
				Description->"displays a plot of the raw relative fluorescence versus scan number from the supplied 'dataObject'.",
				Inputs:>{
					{
						InputName->"dataObject",
						Description->"DNA sequencing data that will be plotted.",
						Widget->Alternatives[
							"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,DNASequencing]]],
							"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,DNASequencing]]]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"The plots of the DNA sequencing fluorescence data.",
						Pattern:>Alternatives[{ValidGraphicsP[]..},Null]
					}
				}
			},
			{
				Definition->{"PlotDNASequencing[protocolObject]","plots"},
				Description->"plots of the data collected during an ExperimentDNASequencing.",
				Inputs:>{
					{
						InputName->"protocolObject",
						Description->"Protocol object from a completed ExperimentDNASequencing.",
						Widget->Alternatives[
							"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,DNASequencing]]],
							"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Protocol,DNASequencing]]]]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"plots",
						Description->"Graphical representation of the sequencing data collected during ExperimentDNASequencing.",
						Pattern:>Alternatives[{ValidGraphicsP[]..},Null]
					}
				}
			}
		},
		SeeAlso -> {
			"ExperimentDNASequencing",
			"ValidExperimentDNASequencingQ",
			"EmeraldListLinePlot"
		},
		Author -> {"scicomp", "brad", "hailey.hibbard"},
		Preview->True
	}
];