(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotVacuumEvaporation*)


DefineUsage[PlotVacuumEvaporation,
{
	BasicDefinitions -> {
		{
			Definition->{"PlotVacuumEvaporation[lyophilizationData]", "plot"},
			Description->"provides a date trace 'plot' for the given 'lyophilizationData'.",
			Inputs:>{
				{
					InputName->"lyophilizationData",
					Description->"VacuumEvaporation data object(s) containing the pressure and temperature data to be plotted.",
					Widget->Alternatives[
						"Single Object"->Widget[Type->Object,Pattern:>ObjectP[Object[Data,VacuumEvaporation]]],
						"Multiple Objects"->Adder[Widget[Type->Object,Pattern:>ObjectP[Object[Data,VacuumEvaporation]]]]
					]
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"The plots of the pressure and temperature traces.",
					Pattern:>ValidGraphicsP[]
				}
			}
		},
		{
			Definition->{"PlotVacuumEvaporation[pressureTrace,temperatureTrace]", "plot"},
			Description->"provides 'plot' of the given 'pressureTrace' and 'temperatureTrace'.",
			Inputs:>{
				{
					InputName->"pressureTrace",
					Description->"Pressure trace data from a lyophilization run.",
					Widget->Widget[Type->Expression,Pattern:>CoordinatesP,Size->Paragraph]
				},
				{
					InputName->"temperatureTrace",
					Description->"Temperature trace data from a lyophilization run.",
					Widget->Widget[Type->Expression,Pattern:>CoordinatesP,Size->Paragraph]
				}
			},
			Outputs:>{
				{
					OutputName->"plot",
					Description->"The plots of the pressure and temperature traces.",
					Pattern:>ValidGraphicsP[]
				}
			}
		}
	},
	SeeAlso -> {
		"PlotPressure",
		"PlotTemperature",
		"EmeraldDataListPlot"
	},
	Author -> {"malav.desai", "waseem.vali", "hayley"},
	Preview->True
}];