(* ::Subsubsection::Closed:: *)
(*PlotSanMateoCOVIDCases*)


DefineUsage[PlotSanMateoCOVIDCases,
	{
		BasicDefinitions -> {
			{"PlotSanMateoCOVIDCases[]", "plot", "generates a 'plot' of new COVID-19 cases in San Mateo county for the last 30 days. Data is taken from the New York Times' public data repository."},
			{"PlotSanMateoCOVIDCases[timeAgo]", "plot", "generates a 'plot' of new COVID-19 cases from 'timeAgo' until now."},
			{"PlotSanMateoCOVIDCases[startTime,endTime]", "plot", "generates a 'plot' of new COVID-19 cases in San Mateo county from 'startTime' to 'endTime'."}

		},
		Input :> {
			{"timeAgo", TimeP, "The length of time to show when plotting COVID-19 cases (e.g. the last 3 months)."},
			{"startTime", _DateObject, "The first date to display on the plot."},
			{"endTime", _DateObject, "The last date to display on the plot."}
		},
		Output :> {
			{"plot", ValidGraphicsP, "A plot showing daily new cases, a seven day moving average of cases, and the 115 case/day threshold for return to office."}
		},
		SeeAlso -> {
			"EmeraldHistogram",
			"EmeraldListLinePlot"
		},
		Author -> {"dirk.schild", "kevin.hou", "hayley"}
	}];