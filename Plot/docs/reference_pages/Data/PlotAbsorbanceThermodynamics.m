(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotAbsorbanceThermodynamics*)


DefineUsage[PlotAbsorbanceThermodynamics,
	{
		BasicDefinitions->{
			{
				Definition->{"PlotAbsorbanceThermodynamics[AbsorbanceThermodynamicsObject]","plot"},
				Description->"provides a graphical plot of the melting and/or cooling curves stored in the data object.",
				Inputs:>{
					{
						InputName->"AbsorbanceThermodynamicsObject",
						Description->"The data object containing the melting and/or cooling curve data you wish to plot.",
						Widget->Widget[
							Type->Object,
							Pattern:>ObjectP[Object[Data,MeltingCurve]]
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
				Definition -> {"PlotAbsorbanceThermodynamics[protocol]", "plot"},
				Description -> "creates a 'plot' of the melting and/or cooling curves stored in the data objects found in the Data field of 'protocol'.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "The protocol object containing absorbance thermodynamics data objects.",
						Widget -> Alternatives[
							"UV melting protocol" -> Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, UVMelting]]],
							"Thermal shift protocol" -> Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, ThermalShift]]]
						]
					}
				},
				Outputs :> {
					{
						OutputName -> "plot",
						Description -> "The figure generated from data found in the thermal shift or UV melting protocol.",
						Pattern :> ValidGraphicsP[]
					}
				}
			},
			{
				Definition->{"PlotAbsorbanceThermodynamics[MeltingCurveData]","plot"},
				Description->"provides a graphical plot of the melting curve.",
				Inputs:>{
					{
						InputName->"MeltingCurveData",
						Description->"The melting curve you wish to plot.",
						Widget->Adder[
							{
								"X Coordinate"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y Coordinate"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
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
				Definition->{"PlotAbsorbanceThermodynamics[MeltingCurveData,CoolingCurveData]","plot"},
				Description->"provides a graphical plot of the melting and cooling curve.",
				Inputs:>{
					{
						InputName->"MeltingCurveData",
						Description->"The melting curve you wish to plot.",
						Widget->Adder[
							{
								"X Coordinate"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y Coordinate"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						]
					},
					{
						InputName->"CoolingCurveData",
						Description->"The cooling curve you wish to plot.",
						Widget->Adder[
							{
								"X Coordinate"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y Coordinate"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
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
			"In order to join lists of melting and cooling curves, the lists must be the same length."
		},
		SeeAlso->{
			"PlotChromatography",
			"PlotNMR"
		},
		Author->{"hayley", "mohamad.zandian", "brad"},
		Preview->True
	}
];