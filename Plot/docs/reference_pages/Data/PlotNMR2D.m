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
			},
			{
				Definition -> {"PlotNMR2D[protocol]", "plot"},
				Description -> "creates a 'plot' of 2D NMR spectra found in the Data field of 'protocol'.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "The protocol object containing NMR2D data objects.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, NMR2D]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The figure generated from data found in the NMR2D protocol.",
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
		Author -> {"yanzhe.zhu", "kevin.hou", "steven"},
		Preview -> True
	}
];