(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotCircularDichroism*)


DefineUsage[PlotCircularDichroism,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotCircularDichroism[spectroscopyObjects]","plot"},
				Description->"provides a graphical plot of spectra belonging to 'spectroscopyObjects'.",

				Inputs:>{
					{
						InputName->"spectroscopyObjects",
						Description->"One or more objects containing circular dichroism absorbance (ellipticity) spectrum and absorbance spectrum spectra.",
						Widget->If[
							TrueQ[$ObjectSelectorWorkaround],
							Alternatives[
								"Enter object(s):"->Widget[Type->Expression,Pattern:>ListableP[ObjectP[Object[Data,CircularDichroism]]],Size->Line],
								"Select object(s):"->Adder@Widget[Type->Object,Pattern:>ObjectP[Object[Data,CircularDichroism]],ObjectTypes->{Object[Data,CircularDichroism]}]
							],
							Alternatives[
								"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,CircularDichroism]],ObjectTypes->{Object[Data,CircularDichroism]}],
								"Multiple Objects"->Adder@Widget[Type->Object,Pattern:>ObjectP[Object[Data,CircularDichroism]],ObjectTypes->{Object[Data,CircularDichroism]}]
							]
						]
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
				Definition -> {"PlotCircularDichroism[protocol]", "plot"},
				Description -> "creates a 'plot' of spectra in the data objects found in the Data field of 'protocol'.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "The protocol object containing circular dichroism data objects.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, CircularDichroism]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The figure generated from data found in the circular dichroism protocol.",
						Pattern :> ValidGraphicsP[]
					}
				}
			},
			{
				Definition->{"PlotCircularDichroism[spectrum]","plot"},
				Description->"provides a graphical plot of the provided spectrum.",

				Inputs:>{
					{
						InputName->"spectrum",
						Description->"The spectrum you wish to plot.",
						Widget->Alternatives[
							"Raw Data"->Widget[Type->Expression,Pattern:>UnitCoordinatesP[],Size->Paragraph]
						]
					}
				},
				Outputs:>{
					{
						OutputName->"plot",
						Description->"A graphical representation of the spectrum.",
						Pattern:>ValidGraphicsP[]
					}
				}
			}
		},
		SeeAlso -> {
			"PlotChromatography",
			"PlotNMR",
			"PlotAbsorbanceSpectroscopy"
		},
		Author -> {"melanie.reschke", "jihan.kim", "lige.tonggu", "weiran.wang"},
		Preview->True
	}
];