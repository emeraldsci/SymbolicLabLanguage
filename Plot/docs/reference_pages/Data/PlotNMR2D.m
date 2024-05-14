(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotNMR2D*)


DefineUsage[PlotNMR2D,
	{
		BasicDefinitions -> {
			{
				Definition -> {"PlotNMR2D[NMR2Ddata]", "plot"},
				Description -> "provides a graphical plot the provided 'NMR2Ddata' spectra.",
				Inputs :> {
					{
						InputName -> "NMR2Ddata",
						Description -> "The NMR2D data object containing the spectra you wish to plot.",
						Widget -> Alternatives[
							"Single Object" -> Widget[Type -> Object, Pattern :> ObjectP[Object[Data, NMR2D]]],
							"Multiple Objects" -> Adder[Widget[Type -> Object, Pattern :> ObjectP[Object[Data, NMR2D]]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "A graphical representation of the spectra.",
						Pattern :> ValidGraphicsP[]
					}
				}
			}
		},
		MoreInformation -> {
			"Two-dimensional NMR spectra are traditionally displayed as contour plots.",
			"The dynamic slider below each plot controls the threshold below which peaks will not be shown.",
			"If the data is particularly noisy and the signal is weak, the slider will not appear and the spectrum may only be viewed at a single contour level.",
			"Note that the first time a dataset is plotted in a session, it may take a long time to process the data. Contour levels are cached so that subsequent plots of the same data are fast."
		},
		SeeAlso -> {
			"PlotNMR",
			"PlotAbsorbanceSpectroscopy",
			"EmeraldListContourPlot"
		},
		Author -> {"kevin.hou","steven"},
		Preview -> True
	}
];
