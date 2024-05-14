(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotRamanSpectroscopy*)


DefineUsage[PlotRamanSpectroscopy,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotRamanSpectroscopy[RamanSpectroscopyData]","fig"},
				Description->"plots the average collected Raman spectrum, Raman spectra from each sampling point, and the sampling pattern for 'RamanSpectroscopyData'.",
				Inputs:>{
					{
						InputName->"RamanSpectroscopyData",
						Description->"The Raman spectroscopy data objects.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Data,RamanSpectroscopy]]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"fig",
						Description->"Figures showing the average of all collected spectra, overlaid spectra, and the sampling patterns used to collect the data.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		MoreInformation->{
			"For each RamanSpectroscopy data object the measurement coordinates are displayed as a tooltip for each spectrum, and the spectra are displayed as a tooltip for each measurement position."
		},
		SeeAlso->{
			"PlotIRSpectroscopy",
			"PlotObject"
		},
		Author->{"alou", "robert", "david.ascough"},
		Preview->True
	}
];