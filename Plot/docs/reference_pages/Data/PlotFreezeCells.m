(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFreezeCells*)


DefineUsage[PlotFreezeCells,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotFreezeCells[dataObject]","plots"},
				Description->"plots the data collected during an ExperimentFreezeCells.",
				Inputs:>{
					{
						InputName->"dataObject",
						Description->"Data object from ExperimentFreezeCells.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Data,FreezeCells]]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"plots",
						Description->"Graphical representation of the data collected for ControlledRateFreezer batches during ExperimentFreezeCells.",
						Pattern:>Alternatives[{_Manipulate..},Null]
					}
				}
			},
			{
				Definition->{"PlotFreezeCells[protocolObject]","plots"},
				Description->"plots the data collected during an ExperimentFreezeCells.",
				Inputs:>{
					{
						InputName->"protocolObject",
						Description->"Protocol object from a completed ExperimentFreezeCells.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Protocol,FreezeCells]]
						],
						Expandable->False
					}
				},
				Outputs:>{
					{
						OutputName->"plots",
						Description->"Graphical representation of the data collected for ControlledRateFreezer batches during ExperimentFreezeCells.",
						Pattern:>Alternatives[{_Manipulate..},Null]
					}
				}
			}
		},
		MoreInformation->{},
		SeeAlso->{
			"ExperimentFreezeCells",
			"ExperimentFreezeCellsPreview"
		},
		Author->{"scicomp", "brad", "gokay.yamankurt"}
	}
];