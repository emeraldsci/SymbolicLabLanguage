(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotMassSpectrometry*)


DefineUsage[PlotMassSpectrometry,
	{
		BasicDefinitions -> {
			{
				Definition->{"PlotMassSpectrometry[massSpectrometryData]", "plot"},
				Description->"provides a graphical plot the provided mass spectra.",
				Inputs:>{
					{
						InputName->"massSpectrometryData",
						Description->"The spectra you wish to plot.",
						Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Data,MassSpectrometry]]]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A graphical representation of the spectra.",
						Pattern:>ValidGraphicsP[]
					}
				}
			},
			{
				Definition->{"PlotMassSpectrometry[spectra]", "plot"},
				Description->"provides a graphical plot the provided mass spectra.",
				Inputs:>{
					{
						InputName->"spectra",
						Description->"The spectra you wish to plot.",
						Widget->Widget[Type->Expression,Pattern:>CoordinatesP,Size->Paragraph]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A graphical representation of the spectra.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"PlotChromatography",
			"PlotNMR"
		},
		Author -> {"mohamad.zandian", "xu.yi", "weiran.wang", "hayley", "brad", "marie.wu"},
		Preview->True
	}
];