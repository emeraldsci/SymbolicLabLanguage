(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*PlotVacuumEvaporation*)


DefineOptions[PlotVacuumEvaporation,
	SharedOptions :> {
		EmeraldDateListPlot
	}
];



(* object definition *)
PlotVacuumEvaporation[
	obj:objectOrLinkP[Object[Data,VacuumEvaporation]],
	inputOptions:OptionsPattern[PlotVacuumEvaporation]
]:=PlotVacuumEvaporation[Download[obj],inputOptions];

(* Packet Definition *)
PlotVacuumEvaporation[
	inf:PacketP[Object[Data,VacuumEvaporation]],
	inputOptions:OptionsPattern[PlotVacuumEvaporation]
]:=Module[
	{pressure,temperature},

	pressure = Pressure/.inf;
	temperature = Temperature/.inf;

	PlotVacuumEvaporation[pressure,temperature,inputOptions]
];

(* core definition: temperature and pressure traces *)
PlotVacuumEvaporation[
	pressure:{{_?DateObjectQ, _?PressureQ}..}|QuantityCoordinatesP[{None,Millibar}],
	temperature:{{_?DateObjectQ, _?TemperatureQ}..}|QuantityCoordinatesP[{None,Celsius}],
	ops:OptionsPattern[PlotVacuumEvaporation]
]:=Module[
	{
		originalOps,safeOps,output,plotData,
		specifiedDateTicksFormat,resolvedDateTicksFormat,plotOptions,
		plot,mostlyResolvedOps,almostResolvedOps,resolvedOps
	},

	(* Convert the original options into a list *)
	originalOps=ToList[ops];

	(* Check the options pattern and return a list of all options, using defaults for unspecified or invalid options *)
	safeOps=SafeOptions[PlotVacuumEvaporation,originalOps];

	(* Requested output, either a single value or list of Alternatives[Result,Options,Preview,Tests] *)
	output=Lookup[safeOps,Output];

	(****** Existing Plot Code ******)

	(* Resolve the raw numerical data that you will plot *)
	plotData=pressure;

	(*- Resolve specified options -*)
	(* Resolving DateTicksFormat *)
	specifiedDateTicksFormat=Lookup[safeOps,DateTicksFormat];

	resolvedDateTicksFormat=If[MatchQ[specifiedDateTicksFormat,Automatic],
		{"MonthShort", "/", "DayShort","/","YearShort" ,"-" ,"Hour24",":","Minute"},
		specifiedDateTicksFormat
	];

	(* Resolve all options which should go to the plot function (i.e. EmeraldListLinePlot in most cases)  *)
	plotOptions=ReplaceRule[safeOps,
		{
			SecondYCoordinates->temperature,
			DateTicksFormat->resolvedDateTicksFormat
		}
	];

	(*********************************)

	(* Call one of the MegaPlots.m functions, typically EmeraldListLinePlot, and get those resolved options *)
	{plot,mostlyResolvedOps}=EmeraldDateListPlot[plotData,
		ReplaceRule[plotOptions,
			{
				Output->{Result,Options}
			}
		]
	];

	(* change output replacement back to user-specified value *)
	almostResolvedOps=Prepend[mostlyResolvedOps,Output->output];

	(* Safe options with resolved options from the underlying plot function (plot range, frame, etc.) subbed in *)
	resolvedOps=ReplaceRule[safeOps,almostResolvedOps,Append->False];

	(* Return the requested outputs *)
	output/.{
		Result->plot,
		Options->resolvedOps,
		Preview->Graphics[plot,ImageSize->Full],
		Tests->{}
	}
]
