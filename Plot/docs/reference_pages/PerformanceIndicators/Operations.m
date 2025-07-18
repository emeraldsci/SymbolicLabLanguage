(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)

DefineUsage[
	UploadOperationsStatistics,
	{
		BasicDefinitions->{
			{"UploadOperationsStatistics[protocol]","updatedProtocol","Calculates and uploads metrics about the protocol's execution."}
		},
		MoreInformation->{
		},
		Input:>{
			{"protocol",ListableP[ObjectP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]],"The protocol whose metrics are calculated."}
		},
		Output:>{
			{"updatedProtocol",ListableP[ObjectP[{Object[Protocol],Object[Maintenance],Object[Qualification]}]],"The protocol with newly updated metrics."}
		},
		SeeAlso->{
		},
		Author->{"hayley"}
	}
];

DefineUsage[
	OperationsStatisticsTrends,
	{
		BasicDefinitions->{
			{"OperationsStatisticsTrends[experimentTypes,startDate,endDate]","result","Calculates the mean and standard deviation of a given protocol execution metric over time."}
		},
		MoreInformation->{
			"Metrics are calculated for each completed protocol.",
			"Noise in the datasets is decreased by smoothing around the provided radius."
		},
		Input:>{
			{"experimentTypes",ListableP[TypeP[{Object[Protocol], Object[Maintenance], Object[Qualification]}]],"The protocol, qualification or maintenance types to consider."},
			{"startDate",_DateObject,"the beginning of the time period for which data should be shown."},
			{"endDate",_DateObject,"the end of the time period for which data should be shown."}
		},
		Output:>{
			{"result",_List|_Column,"A set of plots, raw datasets and/or exported file locations."}
		},
		SeeAlso->{
			"UploadOperationsStatistics",
			"EmeraldDateListPlot"
		},
		Author->{"hayley"}
	}
];