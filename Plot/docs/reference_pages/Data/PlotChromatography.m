(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection:: *)
(*PlotChromatography*)


DefineUsage[PlotChromatography,
{
	BasicDefinitions -> {
		{
			Definition->{"PlotChromatography[dataObject]", "plot"},
			Description->"provides an interactive plot of the data in the chromatography object.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "dataObject",
						Description-> "The piece of data that should be analyzed by PlotChromatography.",
						Widget->Widget[Type->Object,Pattern:>ObjectP[Object[Data,Chromatography]]]
					},
					IndexName -> "dataObject"
				]
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"An interactive plot of the chromatograph.",
					Pattern:>_DynamicModule|_Graphics
				}
			}
		},
		{
			Definition -> {"PlotChromatography[protocol]", "plot"},
			Description -> "creates an interactive 'plot' of the chromatography data found in the Data field of 'protocol'.",
			Inputs :> {
				{
					InputName -> "protocol",
					Description -> "The protocol object containing chromatography data objects.",
					Widget -> Alternatives[
						"FPLC protocol" -> Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, FPLC]]],
						"Gas chromatography protocol" -> Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, GasChromatography]]],
						"HPLC protocol" -> Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, HPLC]]],
						"Ion chromatography protocol" -> Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, IonChromatography]]],
						"LCMS protocol" -> Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, LCMS]]],
						"Supercritical fluid chromatography protocol" -> Widget[Type -> Object, Pattern :> ObjectP[Object[Protocol, SupercriticalFluidChromatography]]]
					]
				}
			},
			Outputs :> {
				{
					OutputName -> "plot",
					Description -> "The figure generated from data found in the chromatography protocol.",
					Pattern :> ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"PlotChromatography[chromatograph]", "plot"},
			Description->"provides plots for chromatographic data.",
			Inputs:>{
				IndexMatching[
					{
						InputName -> "chromatograph",
						Description-> "The chromatographic data you wish to plot.",
						Widget->Adder[
							{
								"X Coordinate"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]],
								"Y Coordinate"->Widget[Type->Number,Pattern:>RangeP[-Infinity,Infinity]]
							}
						]
					},
					IndexName -> "dataObject"
				]
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"An interactive plot of the chromatograph.",
					Pattern:>_DynamicModule|_Graphics
				}
			}
		}
	},
	SeeAlso -> {
		"PlotAbsorbanceSpectroscopy",
		"PlotNMR"
	},
	Author -> {"dirk.schild", "eunbin.go", "ryan.bisbey", "charlene.konkankit", "cgullekson", "amir.saadat", "hayley", "thomas"},
	Preview->True
}];