(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*ObjectiveFunction*)


DefineUsage[PeakObjectiveFunction,{
	BasicDefinitions->{
		{"PeakObjectiveFunction[data]","output", "Calculates the objective function defined by option specification that is used with the DesignOfExperiment function."}
	},
	Input:>{
		{"data",TypeP[{Object[Protocol],Object[Data]}], "A data object or a protocol object with data stored inside."}
	},
	Output:>{
		{"output", _?NumericQ, "A scalar number that represents how well the data accomplished the objective."}
	},
	SeeAlso->{
		"DesignOfExperiment",
		"AnalyzePeaks"
	},
	Author->{"tommy.harrelson"}
}];

DefineUsage[AreaOfTallestPeak,{
	BasicDefinitions->{
		{"AreaOfTallestPeak[data]","output", "Calculates the area between the xy data curve and baseline of the highest peak in the data."}
	},
	Input:>{
		{"data",TypeP[{Object[Protocol],Object[Data]}], "A data object or a protocol object with data stored inside."}
	},
	Output:>{
		{"output", _?NumericQ, "A scalar number that represents how well the data accomplished the objective."}
	},
	SeeAlso->{
		"DesignOfExperiment",
		"PeakObjectiveFunction"
	},
	Author->{"tommy.harrelson"}
}];

DefineUsage[MeanPeakSeparation,{
	BasicDefinitions->{
		{"MeanPeakSeparation[data]","output", "Calculates the mean peak separation of the xy data curve peaks."}
	},
	Input:>{
		{"data",TypeP[{Object[Protocol],Object[Data]}], "A data object or a protocol object with data stored inside."}
	},
	Output:>{
		{"output", _?NumericQ, "A scalar number that represents how well the data accomplished the objective."}
	},
	SeeAlso->{
		"DesignOfExperiment",
		"PeakObjectiveFunction"
	},
	Author->{"tommy.harrelson"}
}];

DefineUsage[MeanPeakHeightWidthRatio,{
	BasicDefinitions->{
		{"MeanPeakHeightWidthRatio[data]","output", "Calculates the mean peak height width ration of the xy data curve peaks."}
	},
	Input:>{
		{"data",TypeP[{Object[Protocol],Object[Data]}], "A data object or a protocol object with data stored inside."}
	},
	Output:>{
		{"output", _?NumericQ, "A scalar number that represents how well the data accomplished the objective."}
	},
	SeeAlso->{
		"DesignOfExperiment",
		"PeakObjectiveFunction"
	},
	Author->{"tommy.harrelson"}
}];

DefineUsage[ResolutionOfTallestPeak,{
	BasicDefinitions->{
		{"ResolutionOfTallestPeak[data]","output", "Calculates the resolution of the tallest peak in the xy data curve peaks."}
	},
	Input:>{
		{"data",TypeP[{Object[Protocol],Object[Data]}], "A data object or a protocol object with data stored inside."}
	},
	Output:>{
		{"output", _?NumericQ, "A scalar number that represents how well the data accomplished the objective."}
	},
	SeeAlso->{
		"DesignOfExperiment",
		"PeakObjectiveFunction"
	},
	Author->{"tommy.harrelson"}
}];