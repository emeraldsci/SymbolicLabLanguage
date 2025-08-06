(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotNMR*)


DefineUsage[PlotNMR,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotNMR[NMRdata]","plot"},
				Description->"generates a graphical representation of spectra contained in 'NMRdata'.",
				Inputs:>{
					{
						InputName->"NMRdata",
						Description->"One or more Object[Data,NMR] objects containing spectra.",
						Widget->If[
							TrueQ[$ObjectSelectorWorkaround],
							Alternatives[
								"Enter object(s):"->Widget[Type->Expression,Pattern:>ListableP[ObjectP[Object[Data,NMR]]],Size->Line],
								"Select object(s):"->Adder@Widget[Type->Object,Pattern:>ObjectP[Object[Data,NMR]],ObjectTypes->{Object[Data,NMR]}]
							],
							Alternatives[
								"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,NMR]],ObjectTypes->{Object[Data,NMR]}],
								"Multiple Objects"->Adder@Widget[Type->Object,Pattern:>ObjectP[Object[Data,NMR]],ObjectTypes->{Object[Data,NMR]}]
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
				Definition -> {"PlotNMR[protocol]", "plot"},
				Description -> "creates a 'plot' of NMR spectra found in the Data field of 'protocol'.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "The protocol object containing NMR data objects.",
						Widget -> Alternatives[
							Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, NMR]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The figure generated from data found in the NMR protocol.",
						Pattern :> ValidGraphicsP[]
					}
				}
			},
			{
				Definition->{"PlotNMR[spectra]","plot"},
				Description->"generates a graphical representation of the provided 'spectra'.",
				Inputs:>{
					{
						InputName->"spectra",
						Description->"One or more raw NMR spectra to be plotted.",
						Widget->Alternatives[
							"Single Spectrum"->Adder@Widget[Type->Expression,Pattern:>UnitCoordinatesP[],Size->Paragraph],
							"Multiple Spectra"->Widget[Type->Expression,Pattern:>ListableP[UnitCoordinatesP[]],Size->Paragraph]
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
			}
		},
		MoreInformation->{
			"NMR spectra are traditionally displayed in reverse x-axis form, however the option for PlotRange uses the standard {{xmin,xmax},{ymin,ymax}} format."
		},
		SeeAlso -> {
			"PlotChromatography",
			"PlotAbsorbanceSpectroscopy"
		},
		Author -> {"yanzhe.zhu", "sebastian.bernasek", "hayley", "brad"},
		Preview->True
	}
];