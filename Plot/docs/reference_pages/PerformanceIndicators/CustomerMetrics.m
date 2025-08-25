(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*Customer Metrics*)

DefineUsage[ReportCustomerMetrics,
	{
		BasicDefinitions->{
			{"ReportCustomerMetrics[teamFinancing, startDate, endDate]", "report", "generates a 'report' object that includes information on different metrics for customer 'teamFinancing' usage of the ECL system between 'startDate' to 'endDate'."},
			{"ReportCustomerMetrics[teamFinancing, date]", "report", "generates a 'report' object that includes information on different metrics for customer usage of the ECL system from 'date' up to Today - 1 Day."},
			{"ReportCustomerMetrics[teamFinancing]", "report", "generates a 'report' object that includes information on different metrics for customer usage of the ECL system between Today - 8 Day to Today - 1 Day."},
			{"ReportCustomerMetrics['teamsFinancing`, startDate, endDate]", "report", "generates 'report' objects that includes information on different metrics for a list of customer 'teamsFinancing' usage of the ECL system between 'startDate' to 'endDate'."}
			
		},
		Input:>{
			{"teamFinancing",ObjectP[Object[Team,Financing]],"The financing team whose customer metrics is gathered and stored in the report."},
			{"teamsFinancing",ListableP[ObjectP[Object[Team,Financing]]],"The financing teams whose customer metrics is gathered and stored in the report."},
			{"startDate",_?DayObjectQ,"The start of the date period for which customer metrics is gathered."},
			{"endDate",_?DayObjectQ,"The end of the date period which for customer metrics is gathered."},
			{"date",_?DayObjectQ,"The single date input which corresponds to the 'startDate' and an implicit 'endDate' of Today - 1 Day."}
		},
		Output:>{
			{"report",ObjectP[Object[Report,CustomerMetrics]],"The 'report' object that includes information on different metrics for customer usage of the ECL system between 'startDate' to 'endDate'."}
		},
		MoreInformation->{
			"The 'startDate' is interpreted as at midnight of \"America/Chicago\" timezone.",
			"The 'endDate' is interpreted as at 11:59:59 pm of \"America/Chicago\" timezone.",
			"The most recent `endDate` that can be included in a report is that of Today - 1 day since a full 24 hours of the day must be covered in any report log."
		},
		SeeAlso->{
			"PlotCustomerMetrics"
		},
		Author->{"jireh.sacramento"}
	}
];

DefineUsage[PlotCustomerMetrics,
	{
		BasicDefinitions->{
			{"PlotCustomerMetrics[teamFinancing, startDate, endDate]", "cloudFiles", "generates 'cloudFiles' of created notebooks and PDFs that contains consolidated information on different metrics for customer usage of the ECL system between 'startDate' to 'endDate' and updates the 'teamFinancing' to log the generated 'cloudFiles'."}
		},
		Input:>{
			{"teamFinancing",ObjectP[Object[Team,Financing]],"The financing team whose customer metrics is gathered and presented in the report."},
			{"startDate",_?DayObjectQ,"The start of the date period for which customer metrics is gathered."},
			{"endDate",_?DayObjectQ,"The end of the date period which for customer metrics is gathered."}
		},
		Output:>{
			{"cloudFiles",ObjectP[Object[EmeraldCloudFile]],"The 'cloudFiles' (notebook and PDF) that contains consolidated information on different metrics for customer usage of the ECL system between 'startDate' to 'endDate'."},
			{"teamFinancing",ObjectP[Object[Team,Financing]],"The 'teamFinancing' that is updated to log the generated 'cloudFiles'."}
		},
		SeeAlso->{
			"ReportCustomerMetrics"
		},
		MoreInformation->{
			"The 'startDate' is interpreted as at midnight of \"America/Chicago\" timezone.",
			"The 'endDate' is interpreted as at 11:59:59 pm of \"America/Chicago\" timezone.",
			"The most recent `endDate` that can be included in a report is that of Today - 1 day since a full 24 hours of the day must be covered in any report log."
		},
		Author->{"jireh.sacramento"}
	}
];

DefineUsage[PlotCommandCenterActivity,
	{
		BasicDefinitions->{
			{"PlotCommandCenterActivity[financingTeam, startDate, endDate]", "tabbedUsagePlots", "generates 'tabbedUsagePlots' of Command Center activity separated by department between 'startDate' and 'endDate'."},
			{"PlotCommandCenterActivity[financingTeam, startDate]", "tabbedUsagePlots", "generates 'tabbedUsagePlots' of Command Center activity separated by department between 'startDate' and one day prior to the current date."},
			{"PlotCommandCenterActivity[financingTeam]", "tabbedUsagePlots", "generates 'tabbedUsagePlots' of Command Center activity separated by department for the past month, up to and including one day prior to the current date."}
		},
		Input:>{
			{"financingTeam",ObjectP[Object[Team,Financing]],"The financing team whose users' Command Center activity is presented in the plot or table."},
			{"startDate",_?DayObjectQ,"The start date of the period for which Command Center activity is displayed."},
			{"endDate",_?DayObjectQ,"The end date of the period for which Command Center activity is displayed."}
		},
		Output:>{
			{"tabbedUsagePlots",_TabView,"A TabView containing plots of per-user Command Center activity separated by department between 'startDate' and 'endDate'."},
			{"usageTable",_Pane,"A table summarizing Command Center activity for each of 'financingTeam''s users between 'startDate' and 'endDate'."}
		},
		SeeAlso->{
			"ReportCustomerMetrics",
			"PlotCustomerMetrics"
		},
		MoreInformation->{
			"The 'startDate' is interpreted as at midnight of \"America/Chicago\" timezone.",
			"The 'endDate' is interpreted as at 11:59:59 pm of \"America/Chicago\" timezone.",
			"The most recent 'endDate' that can be included in a plot is Today - 1 Day since a full 24 hours of the day must be covered in any report log."
		},
		Author->{"ben"}
	}
];