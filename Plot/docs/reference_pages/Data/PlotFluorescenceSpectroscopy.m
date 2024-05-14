(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotFluorescenceSpectroscopy*)


DefineUsage[PlotFluorescenceSpectroscopy,
{
	BasicDefinitions -> {
		{
			Definition->{"PlotFluorescenceSpectroscopy[fluorescenceSpectroscopyData]", "plot"},
			Description->"displays fluorescence intensity vs wavelength 'plot' for the supplied 'fluorescenceSpectroscopyData'.",
			Inputs:>{
				{
					InputName->"fluorescenceSpectroscopyData",
					Description->"Fluorescence spectroscopy data to be plotted.",
					Widget->Alternatives[
						"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,FluorescenceSpectroscopy]]],
						"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,FluorescenceSpectroscopy]]]]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"The plot of the spectra.",
					Pattern:>ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"PlotFluorescenceSpectroscopy[spectra]", "plot"},
			Description->"displays fluorescence intensity vs wavelength 'plot' when given a 'spectra' as a raw data trace.",
			Inputs:>{
				{
					InputName->"spectra",
					Description->"Spectral data to be plotted.",
					Widget->Alternatives[
						"Single Spectrum"->Widget[Type->Expression,Pattern:>Pattern:>CoordinatesP,Size->Paragraph],
						"Multiple Spectra"->Adder[Widget[Type->Expression,Pattern:>CoordinatesP,Size->Paragraph]]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"The plot of the spectra.",
					Pattern:>ValidGraphicsP[]
				}
			}
		}
	},
	SeeAlso -> {
		"PlotAbsorbanceSpectroscopy",
		"PlotFluorescenceKinetics",
		"EmeraldListLinePlot"
	},
	Author -> {"malav.desai", "waseem.vali", "hayley"},
	Preview->True
}];