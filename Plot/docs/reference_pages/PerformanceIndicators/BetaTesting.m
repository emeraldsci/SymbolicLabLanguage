(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(*Beta Testing*)

DefineUsage[
	PlotBetaTesting,
	{
		BasicDefinitions->{
			{"PlotBetaTesting[function]","notebook","creates a notebook showing the criteria the function has met and those it still needs to meet in order to pass initial lab testing."}
		},
		MoreInformation->{
			"PlotBetaTesting calls a number of other functions which can be called individually to accesss performance in specific categories. These are listed in the 'See Also'."
		},
		Input:>{
			{"function",_Symbol,"An experiment, qualification or maintenance function."}
		},
		Output:>{
			{"notebook",ObjectP[Object[EmeraldCloudFile]],"A cloud file with a notebook describing the performance of the function in the lab."}
		},
		SeeAlso->{
			"ValidDocumentationQ",
			"PlotSupportTimeline",
			"TroubleshootingTable",
			"ValidObjectQ"
		},
		Author->{"hayley", "mohamad.zandian"}
	}
];


DefineUsage[
	PlotBetaTestingSupportRate,
	{
		BasicDefinitions->{
			{"PlotBetaTestingSupportRate[function]","plot","creates a plot indicating the support ticket rate per protocol as a function of number of protocols since the start date."}
		},
		MoreInformation->{
		},
		Input:>{
			{"function",_Symbol,"An experiment, qualification or maintenance function."}
		},
		Output:>{
			{"plot",_DynamicModule,"A plot displaying the support ticket rate as a function of protocol number since the specified start date."}
		},
		SeeAlso->{
			"PlotBetaTesting",
			"EmeraldListLinePlot"
		},
		Author->{"steven"}
	}
];