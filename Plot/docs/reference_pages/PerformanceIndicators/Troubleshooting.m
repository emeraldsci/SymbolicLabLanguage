(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Helperfunctions for date objects*)

(*GreaterDateQ*)
DefineUsage[GreaterDateQ,{
	BasicDefinitions->{
		{"GreaterDateQ[x,y]", "bool", "returns True if time point 'x' is greater than 'y'."}
	},
	Input:>{
		{"x",_?DateObjectQ, "a time point."},
		{"y",_?DateObjectQ, "another time point."}
	},
	Output:>{
		{"bool", BooleanP, "A boolean value."}
	},
	SeeAlso->{
		"GreaterEqualDateQ",
		"LessDateQ",
		"LessEqualDateQ"
	},
	Author->{"dirk.schild"}
}];

(*GreaterEqualDateQ*)
DefineUsage[GreaterEqualDateQ,{
	BasicDefinitions->{
		{"GreaterEqualDateQ[x,y]", "bool", "returns True if time point 'x' is greater than or equal to 'y'."}
	},
	Input:>{
		{"x",_?DateObjectQ, "a time point."},
		{"y",_?DateObjectQ, "another time point."}
	},
	Output:>{
		{"bool", BooleanP, "A boolean value."}
	},
	SeeAlso->{
		"GreaterDateQ",
		"LessDateQ",
		"LessEqualDateQ"
	},
	Author->{"dirk.schild"}
}];

(*LessDateQ*)
DefineUsage[LessDateQ,{
	BasicDefinitions->{
		{"LessDateQ[x,y]", "bool", "returns True if time point 'x' is less than 'y'."}
	},
	Input:>{
		{"x",_?DateObjectQ, "a time point."},
		{"y",_?DateObjectQ, "another time point."}
	},
	Output:>{
		{"bool", BooleanP, "A boolean value."}
	},
	SeeAlso->{
		"GreaterEqualDateQ",
		"GreaterDateQ",
		"LessEqualDateQ"
	},
	Author->{"dirk.schild"}
}];

(*LessEqualDateQ*)
DefineUsage[LessEqualDateQ,{
	BasicDefinitions->{
		{"LessEqualDateQ[x,y]", "bool", "returns True if time point 'x' is less than or equal to 'y'."}
	},
	Input:>{
		{"x",_?DateObjectQ, "a time point."},
		{"y",_?DateObjectQ, "another time point."}
	},
	Output:>{
		{"bool", BooleanP, "A boolean value."}
	},
	SeeAlso->{
		"GreaterEqualDateQ",
		"LessDateQ",
		"GreaterDateQ"
	},
	Author->{"dirk.schild"}
}];

(*EqualDateQ*)
DefineUsage[EqualDateQ,{
	BasicDefinitions->{
		{"EqualDateQ[x,y]", "bool", "returns True if time point 'x' is equal to 'y'."}
	},
	Input:>{
		{"x",_?DateObjectQ, "a time point."},
		{"y",_?DateObjectQ, "another time point."}
	},
	Output:>{
		{"bool", BooleanP, "A boolean value."}
	},
	SeeAlso->{
		"GreaterEqualDateQ",
		"LessDateQ",
		"GreaterDateQ"
	},
	Author->{"dirk.schild"}
}];

(*minTime*)
DefineUsage[minTime,{
	BasicDefinitions->{
		{"minTime[x]", "minTime", "returns the minimum date point value from a list of date points 'x'."}
	},
	Input:>{
		{"x",ListableP[_?DateObjectQ], "a list of time points."}
	},
	Output:>{
		{"minTime", _?DateObjectQ, "the minimum date point from the list of input."}
	},
	SeeAlso->{
		"maxTime"
	},
	Author->{"dirk.schild"}
}];

(*maxTime*)
DefineUsage[maxTime,{
	BasicDefinitions->{
			{"maxTime[x]", "maxTime", "returns the maximium date point value from a list of date points 'x'."}
		},
		Input:>{
			{"x",ListableP[_?DateObjectQ], "a list of time points."}
		},
		Output:>{
			{"maxTime", _?DateObjectQ, "the maximum date point from the list of input."}
		},
	SeeAlso->{
		"minTime"
	},
	Author->{"dirk.schild"}
}];

(* ::Subsubsection::Closed:: *)
(*PlotSupportRate*)


DefineUsage[PlotSupportRate,{
	BasicDefinitions->{
		(*no input is given*)
		{
			Definition -> {"PlotSupportRate[]", "figures"},
			Description -> "displays 'figures' showing the troubleshooting rate during last month if nothing is specified.",
			Inputs :> {
			},
			Outputs :> {
				{
					OutputName -> "figures",
					Description -> "A grid of plots showing the troubleshooting rate of all types of tests at ECL lab.",
					Pattern :> _Grid
				}
			}
		},
		(* input a time period *)
		{
			Definition -> {"PlotSupportRate[timeSpan]", "figures"},
			Description -> "displays 'figures' showing the troubleshooting rate during 'timeSpan'.",
			Inputs :> {
				{
					InputName -> "timeSpan",
					Description -> "A period of time from Today-timeSpan to Today.",
					Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Day], Units->Alternatives[Year,Month,Week,Day]]
				}
			},
			Outputs :> {
				{
					OutputName -> "figures",
					Description -> "A grid of plots showing the troubleshooting rate of all types of tests at ECL lab.",
					Pattern :> _Grid
				}
			}
		},
		(* input start and end time *)
		{
			Definition -> {"PlotSupportRate[startTime,endTime]", "figures"},
			Description -> "displays 'figures' showing the troubleshooting rate from 'startTime' to 'endTime'.",
			Inputs :> {
				{
					InputName -> "startTime",
					Description -> "the start of the time period for which data should be shown.",
					Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]

				},
				{
					InputName -> "endTime",
					Description -> "the end of the time period for which data should be shown.",
					Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]
				}
			},
			Outputs :> {
				{
					OutputName -> "figures",
					Description -> "A grid of plots showing the troubleshooting rate of all types of tests at ECL lab.",
					Pattern :> _Grid
				}
			}
		}
	},
	SeeAlso->{
		"PlotSupportDistributions",
		"PlotTotalSupportRate",
		"PlotSupportTimeline",
		"PlotSampleManipulationSupportTimeline"
	},
	Author->{"dirk.schild"}
}];

(* ::Subsubsection::Closed:: *)
(*PlotSupportRate*)


DefineUsage[PlotSupportDistributions,{
	BasicDefinitions->{
		(*all type of Object[Protocol]*)
		{
			Definition -> {"PlotSupportDistributions[]", "figure"},
			Description -> "displays troubleshooting distribution of all types of Protocols if no type is specified.",
			Inputs :> {
			},
			Outputs :> {
				{
					OutputName -> "figure",
					Description -> "A plot showing all types of protocols' troubleshooting distribution.",
					Pattern :> _Legended
				}
			}
		},
		(*some types of Object[Protocol]*)
		{
			Definition -> {"PlotSupportDistributions[types]", "figure"},
			Description -> "displays troubleshooting distribution of Protocols if their types are 'types'.",
			Inputs :> {
				{
					InputName -> "types",
					Description -> "A list of Object[Protocol] types.",
					Widget -> Widget[Type -> Expression, Pattern :> ListableP[TypeP[Object[Protocol]]],Size->Line]
				}
			},
			Outputs :> {
				{
					OutputName -> "figure",
					Description -> "A plot showing all types of protocols' troubleshooting distribution.",
					Pattern :> _Legended
				}
			}
		},
		{
			Definition -> {"PlotSupportDistributions[types,timeSpan]", "figure"},
			Description -> "displays troubleshooting distribution of Protocols if their types are 'types' during 'timeSpan'.",
			Inputs :> {
				{
					InputName -> "types",
					Description -> "A list of Object[Protocol] types.",
					Widget -> Widget[Type -> Expression, Pattern :> ListableP[TypeP[Object[Protocol]]],Size->Line]
				},
				{
					InputName -> "timeSpan",
					Description -> "A period of time from Today-timeSpan to Today.",
					Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Day], Units->Alternatives[Year,Month,Week,Day]]
				}
			},
			Outputs :> {
				{
					OutputName -> "figure",
					Description -> "A plot showing all types of protocols' troubleshooting distribution.",
					Pattern :> _Legended
				}
			}
		},
		{
			Definition -> {"PlotSupportDistributions[types,startTime,endTime]", "figure"},
			Description -> "displays troubleshooting distribution of Protocols if their types are 'types' from 'startTime' to 'endTime'.",
			Inputs :> {
				{
					InputName -> "types",
					Description -> "A list of Object[Protocol] types.",
					Widget -> Widget[Type -> Expression, Pattern :> ListableP[TypeP[Object[Protocol]]], Size -> Line]
				},
				{
					InputName -> "startTime",
					Description -> "the start of the time period for which data should be shown.",
					Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]

				},
				{
					InputName -> "endTime",
					Description -> "the end of the time period for which data should be shown.",
					Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]
				}
			},
			Outputs :> {
				{
					OutputName -> "figure",
					Description -> "A plot showing all types of protocols' troubleshooting distribution.",
					Pattern :> _Legended
				}
			}
		}
	},
	SeeAlso->{
		"PlotSupportRate",
		"PlotTotalSupportRate",
		"PlotSupportTimeline",
		"PlotSampleManipulationSupportTimeline"
	},
	Author->{"dirk.schild"}
}];

(* ::Subsubsection::Closed:: *)
(*PlotTotalSupportRate*)


DefineUsage[PlotTotalSupportRate,{
	BasicDefinitions->{
		(*all type of Object[Protocol]*)
		{
			Definition -> {"PlotTotalSupportRate[]", "figures"},
			Description -> "displays the total troubleshooting rate of this month with interval of a day if nothing is specified.",
			Inputs :> {
			},
			Outputs :> {
				{
					OutputName -> "figures",
					Description -> "A grid of plots showing the total troubleshooting rate of this month.",
					Pattern :> _Grid
				}
			}
		},
		(*some types of Object[Protocol]*)
		{
			Definition -> {"PlotTotalSupportRate[timeSpan]", "figures"},
			Description -> "displays troubleshooting rate during 'timeSpan' with a bin size based on the amount of time to be displayed.",
			Inputs :> {
				{
					InputName -> "timeSpan",
					Description -> "A period of time from Today-timeSpan to Today.",
					Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Day], Units->Alternatives[Year,Month,Week,Day]]
				}
			},
			Outputs :> {
				{
					OutputName -> "figures",
					Description -> "A grid of plots showing the total troubleshooting rate during the 'timeSpan'.",
					Pattern :> _Grid
				}
			}
		},
		{
			Definition -> {"PlotTotalSupportRate[timeSpan,bin]", "figures"},
			Description -> "displays troubleshooting rate during 'timeSpan' with interval of 'bin'.",
			Inputs :> {
				{
					InputName -> "timeSpan",
					Description -> "A period of time from Today-timeSpan to Today.",
					Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Day], Units->Alternatives[Year,Month,Week,Day]]
				},
				{
					InputName -> "bin",
					Description -> "The size of the time period used for individual data points.",
					Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Hour], Units->Alternatives[Year,Month,Week,Day,Hour]]
				}
			},
			Outputs :> {
				{
					OutputName -> "figures",
					Description -> "A grid of plots showing the total troubleshooting rate during the 'timeSpan'.",
					Pattern :> _Grid
				}
			}
		},
		{
			Definition -> {"PlotTotalSupportRate[startTime,endTime]", "figures"},
			Description -> "displays troubleshooting rate from 'startTime' to 'endTime' with an interval based on the amount of time being displayed.",
			Inputs :> {
				{
					InputName -> "startTime",
					Description -> "the start of the time period for which data should be shown.",
					Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]

				},
				{
					InputName -> "endTime",
					Description -> "the end of the time period for which data should be shown.",
					Widget ->Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]
				}
			},
			Outputs :> {
				{
					OutputName -> "figures",
					Description -> "A grid of plots showing the total troubleshooting rate between certain two dates.",
					Pattern :> _Grid
				}
			}
		},
		{
			Definition -> {"PlotTotalSupportRate[startTime,endTime,bin]", "figures"},
			Description -> "displays troubleshooting rate from 'startTime' to 'endTime' with interval of 'bin'.",
			Inputs :> {
				{
					InputName -> "startTime",
					Description -> "the start of the time period for which data should be shown.",
					Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]

				},
				{
					InputName -> "endTime",
					Description -> "the end of the time period for which data should be shown.",
					Widget ->Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]
				},
				{
					InputName -> "bin",
					Description -> "The size of the time period used for individual data points.",
					Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Hour], Units->Alternatives[Year,Month,Week,Day,Hour]]
				}
			},
			Outputs :> {
				{
					OutputName -> "figures",
					Description -> "A grid of plots showing the total troubleshooting rate between certain two dates.",
					Pattern :> _Grid
				}
			}
		}
	},
	SeeAlso->{
		"PlotSupportDistributions",
		"PlotSupportRate",
		"PlotSupportTimeline",
		"PlotSampleManipulationSupportTimeline"
	},
	Author->{"dirk.schild"}
}];

(* ::Subsubsection::Closed:: *)
(*PlotSupportTimeline*)


DefineUsage[PlotSupportTimeline,{
	BasicDefinitions->{
		{
			Definition -> {"PlotSupportTimeline[]", "summaryFigure"},
			Description -> "displays the average number of troubleshooting tickets for all protocols for the last month with a one day interval.",
			Inputs :> {
			},
			Outputs :> {
				{
					OutputName -> "summaryFigure",
					Description -> "A plot showing the troubleshooting rates for this month.",
					Pattern :> _Legended
				}
			}
		},
		{
			Definition -> {"PlotSupportTimeline[protocol]", "protocolSummaryFigure"},
			Description -> "displays the average number of troubleshooting tickets for a given protocol over the last month with a one day interval.",
			Inputs :> {
				{
					InputName -> "protocol",
					Description -> "The protocols whose tickets should be displayed.",
					Widget -> Widget[Type->MultiSelect,Pattern:>DuplicateFreeListableP[TypeP[{Object[Protocol],Object[Qualification],Object[Maintenance]}]]]
				}
			},
			Outputs :> {
				{
					OutputName -> "protocolSummaryFigure",
					Description -> "A plot showing the troubleshooting rate for a given protocol over the last month.",
					Pattern :> _Legended
				}
			}
		},
		{
			Definition -> {"PlotSupportTimeline[timeSpan]", "spanningFigure"},
			Description -> "displays the average number of troubleshooting tickets for all protocols over 'timeSpan' with a bin size based on the amount of time to be displayed.",
			Inputs :> {
				{
					InputName -> "timeSpan",
					Description -> "Indicates how far in the past to show the data.",
					Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Day], Units->Alternatives[Year,Month,Week,Day]]
				}
			},
			Outputs :> {
				{
					OutputName -> "spanningFigure",
					Description -> "A plot showing the troubleshooting rates during the 'timeSpan'.",
					Pattern :> _Legended
				}
			}
		},
		{
			Definition -> {"PlotSupportTimeline[protocol,timeSpan]", "protocolFigure"},
			Description -> "displays the average number of troubleshooting tickets for a given protocol over 'timeSpan' with a bin size based on the amount of time to be displayed.",
			Inputs :> {
				{
					InputName -> "protocol",
					Description -> "The protocols whose tickets should be displayed.",
					Widget -> Widget[Type->MultiSelect,Pattern:>DuplicateFreeListableP[TypeP[{Object[Protocol],Object[Qualification],Object[Maintenance]}]]]
				},
				{
					InputName -> "timeSpan",
					Description -> "Indicates how far in the past to show the data.",
					Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Day], Units->Alternatives[Year,Month,Week,Day]]
				}
			},
			Outputs :> {
				{
					OutputName -> "protocolFigure",
					Description -> "A plot showing the troubleshooting rate during the 'timeSpan' for a given protocol.",
					Pattern :> _Legended
				}
			}
		}
	},
	AdditionalDefinitions->{
		{
			"Definition" -> {"PlotSupportTimeline[timeSpan,bin]", "figure"},
			"Description" -> "displays the average number of troubleshooting tickets for all protocols during 'timeSpan' with an interval of 'bin'.",
			"Inputs" :> {
				{
					InputName -> "timeSpan",
					Description -> "A period of time from Today-timeSpan to Today.",
					Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Day], Units->Alternatives[Year,Month,Week,Day]]
				},
				{
					InputName -> "bin",
					Description -> "The size of the time period used for individual data points.",
					Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Hour], Units->Alternatives[Year,Month,Week,Day,Hour]]
				}
			},
			"Outputs" :> {
				{
					OutputName -> "figure",
					Description -> "A plot showing the troubleshooting rate during the 'timeSpan' with the defined interval.",
					Pattern :> _Legended
				}
			}
		},
		{
			"Definition" -> {"PlotSupportTimeline[protocol,timeSpan,bin]", "figure"},
			"Description" -> "displays the average number of troubleshooting tickets for a given protocol during 'timeSpan' with interval 'bin' for a given protocol.",
			"Inputs" :> {
				{
					InputName -> "protocol",
					Description -> "The protocols whose tickets should be displayed.",
					Widget -> Widget[Type->MultiSelect,Pattern:>DuplicateFreeListableP[TypeP[{Object[Protocol],Object[Qualification],Object[Maintenance]}]]]
				},
				{
					InputName -> "timeSpan",
					Description -> "Indicates how far in the past to show the data.",
					Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Day], Units->Alternatives[Year,Month,Week,Day]]
				},
				{
					InputName -> "bin",
					Description -> "The size of the time period used for individual data points.",
					Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Hour], Units->Alternatives[Year,Month,Week,Day,Hour]]
				}
			},
			"Outputs" :> {
				{
					OutputName -> "figure",
					Description -> "A plot showing the troubleshooting rate during the 'timeSpan' with the defined interval for a given protocol.",
					Pattern :> _Legended
				}
			}
		},
		{
			"Definition" -> {"PlotSupportTimeline[startTime,endTime,bin]", "figure"},
			"Description" -> "displays the average number of troubleshooting tickets for all protocols from 'startTime' to 'endTime' with an interval of 'bin'.",
			"Inputs" :> {
				{
					InputName -> "startTime",
					Description -> "the start of the time period for which data should be shown.",
					Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]

				},
				{
					InputName -> "endTime",
					Description -> "the end of the time period for which data should be shown.",
					Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]
				},
				{
					InputName -> "bin",
					Description -> "The size of the time period used for individual data points.",
					Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Hour], Units->Alternatives[Year,Month,Week,Day,Hour]]
				}
			},
			"Outputs" :> {
				{
					OutputName -> "figure",
					Description -> "A plot showing the troubleshooting rate between the specified dates with the defined interval.",
					Pattern :> _Legended
				}
			}
		},
		{
			"Definition" -> {"PlotSupportTimeline[protocol,startTime,endTime,bin]", "figure"},
			"Description" -> "displays the average number of troubleshooting tickets for a given protocol from 'startTime' to 'endTime' with interval of 'bin'.",
			"Inputs" :> {
				{
					InputName -> "protocol",
					Description -> "The protocols whose tickets should be displayed.",
					Widget -> Widget[Type->MultiSelect,Pattern:>DuplicateFreeListableP[TypeP[{Object[Protocol],Object[Qualification],Object[Maintenance]}]]]
				},
				{
					InputName -> "startTime",
					Description -> "the start of the time period for which data should be shown.",
					Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]

				},
				{
					InputName -> "endTime",
					Description -> "the end of the time period for which data should be shown.",
					Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]
				},
				{
					InputName -> "bin",
					Description -> "The size of the time period used for individual data points.",
					Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Hour], Units->Alternatives[Year,Month,Week,Day,Hour]]
				}
			},
			"Outputs" :> {
				{
					OutputName -> "figure",
					Description -> "A plot showing the troubleshooting rate for a specific protocol between the specified dates with the defined interval.",
					Pattern :> _Legended
				}
			}
		}
	},
	SeeAlso->{
		"PlotSupportDistributions",
		"PlotTotalSupportRate",
		"PlotSupportRate",
		"PlotSampleManipulationSupportTimeline"
	},
	Author->{"hayley", "mohamad.zandian", "Frezza", "lige.tonggu"}
}];

(* ::Subsubsection::Closed:: *)
(*PlotSampleManipulationSupportTimeline*)


DefineUsage[PlotSampleManipulationSupportTimeline,{
	BasicDefinitions->{
		{
			Definition -> {"PlotSampleManipulationSupportTimeline[]", "figure"},
			Description -> "displays the total troubleshooting timeline of this month of Object[Protocol,SampleManipulation] with interval of a day if nothing is specified.",
			Inputs :> {
			},
			Outputs :> {
				{
					OutputName -> "figure",
					Description -> "A plot showing the total troubleshooting timeline of this month.",
					Pattern :> _Legended
				}
			}
		},
		{
			Definition -> {"PlotSampleManipulationSupportTimeline[timeSpan]", "figure"},
			Description -> "displays troubleshooting timeline of Object[Protocol,SampleManipulation] during 'timeSpan' with a bin size based on the amount of time to be displayed.",
			Inputs :> {
				{
					InputName -> "timeSpan",
					Description -> "A period of time from Today-timeSpan to Today.",
					Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Day], Units->Alternatives[Year,Month,Week,Day]]
				}
			},
			Outputs :> {
				{
					OutputName -> "figure",
					Description -> "A plot showing the total troubleshooting timeline during the 'timeSpan'.",
					Pattern :> _Legended
				}
			}
		},
		{
			Definition -> {"PlotSampleManipulationSupportTimeline[timeSpan,bin]", "figure"},
			Description -> "displays troubleshooting timeline of Object[Protocol,SampleManipulation] during 'timeSpan' with interval 'bin'.",
			Inputs :> {
				{
					InputName -> "timeSpan",
					Description -> "A period of time from Today-timeSpan to Today.",
					Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Day], Units->Alternatives[Year,Month,Week,Day]]
				},
				{
					InputName -> "bin",
					Description -> "The size of the time period used for individual data points.",
					Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Hour], Units->Alternatives[Year,Month,Week,Day,Hour]]
				}
			},
			Outputs :> {
				{
					OutputName -> "figure",
					Description -> "A plot showing the total troubleshooting timeline during the 'timeSpan' with defined interval.",
					Pattern :> _Legended
				}
			}
		},
		{
			Definition -> {"PlotSampleManipulationSupportTimeline[startTime,endTime]", "figure"},
			Description -> "displays troubleshooting timeline of Object[Protocol,SampleManipulation] from 'startTime' to 'endTime' with interval of 'bin'.",
			Inputs :> {
				{
					InputName -> "startTime",
					Description -> "the start of the time period for which data should be shown.",
					Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]

				},
				{
					InputName -> "endTime",
					Description -> "the end of the time period for which data should be shown.",
					Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]
				}
			},
			Outputs :> {
				{
					OutputName -> "figure",
					Description -> "A plot showing the total troubleshooting timeline between certain two dates with a bin determined based on the time span being displayed.",
					Pattern :> _Legended
				}
			}
		},
		{
			Definition -> {"PlotSampleManipulationSupportTimeline[startTime,endTime,bin]", "figure"},
			Description -> "displays troubleshooting timeline of Object[Protocol,SampleManipulation] from 'startTime' to 'endTime' with interval of 'bin'.",
			Inputs :> {
				{
					InputName -> "startTime",
					Description -> "the start of the time period for which data should be shown.",
					Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]

				},
				{
					InputName -> "endTime",
					Description -> "the end of the time period for which data should be shown.",
					Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]
				},
				{
					InputName -> "bin",
					Description -> "The size of the time period used for individual data points.",
					Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Hour], Units->Alternatives[Year,Month,Week,Day,Hour]]
				}
			},
			Outputs :> {
				{
					OutputName -> "figure",
					Description -> "A plot showing the total troubleshooting timeline between certain two dates with defined interval.",
					Pattern :> _Legended
				}
			}
		}
	},
	SeeAlso->{
		"PlotSupportDistributions",
		"PlotTotalSupportRate",
		"PlotSupportTimeline",
		"PlotSupportRate"
	},
	Author->{"dirk.schild"}
}];

DefineUsage[
	TroubleshootingTable,
	{
		BasicDefinitions->{
			{"TroubleshootingTable[type]","table","Plots a table of information about tickets found for a given type in the last week."},
			{"TroubleshootingTable[timeAgo]","table","Plots information about tickets found for all tickets in the last timeAgo."},
			{"TroubleshootingTable[startTime,endTime]","table","Plots information about tickets found between 'startTime' and 'endTime'."}
		},
		MoreInformation->{
			"Tickets are found using the SourceProtocol field within the ticket objects.",
			"SourceProtocol is populated with the protocol under active execution when an error occurs."
		},
		Input:>{
			{"type",TypeP[],"The protocol type for which tickets should be pulled."},
			{"timeAgo",TypeP[],"The period of time for which tickets should be shown."},
			{"startTime",TypeP[],"The start of the time period for which tickets should be shown."},
			{"endTime",TypeP[],"The end of the time period for which tickets should be shown."}
		},
		Output:>{
			{"table",_Pane,"A set of information about the tickets pulled including DateCreated and Headline."}
		},
		SeeAlso->{
			"PlotSupportTimeline",
			"BlockerTable"
		},
		Author->{"hayley", "mohamad.zandian"}
	}
];

DefineUsage[
	BlockerTable,
	{
		BasicDefinitions->{
			{"BlockerTable[type]","table","Plots a table of information about blocked tickets found for a given type in the last week."},
			{"BlockerTable[timeAgo]","table","Plots information about blocked tickets found for all tickets in the last timeAgo."},
			{"BlockerTable[startTime,endTime]","table","Plots information about blocked tickets found between 'startTime' and 'endTime'."}
		},
		MoreInformation->{
		},
		Input:>{
			{"type",TypeP[],"The protocol type for which tickets should be pulled."},
			{"timeAgo",TypeP[],"The period of time for which tickets should be shown."},
			{"startTime",TypeP[],"The start of the time period for which tickets should be shown."},
			{"endTime",TypeP[],"The end of the time period for which tickets should be shown."}
		},
		Output:>{
			{"table",_Pane,"A set of information about the tickets pulled including DateCreated and Headline."}
		},
		SeeAlso->{
			"PlotSupportTimeline",
			"TroubleshootingTable"
		},
		Author->{"hayley", "mohamad.zandian"}
	}
];

DefineUsage[
	TroubleshootingErrorSources,
	{
		BasicDefinitions->{
			{"TroubleshootingErrorSources[]","sources","Returns the a unique list of tags ascribed to troubleshooting tickets:"}
		},
		MoreInformation->{
		},
		Output:>{
			{"sources",{_String..},"A list of strings providing unique categorization of the issues encountered in tickets."}
		},
		SeeAlso->{
			"PlotSupportTimeline",
			"TroubleshootingTable"
		},
		Author->{"hayley", "mohamad.zandian"}
	}
];

DefineUsage[
	PlotLongTaskTimeline,
	{
		BasicDefinitions->{
			{
				Definition -> {"PlotLongTaskTimeline[]", "summaryFigure"},
				Description -> "displays the long task counts for the last month.",
				Inputs :> {
				},
				Outputs :> {
					{
						OutputName -> "summaryFigure",
						Description -> "A plot showing the number of long tasks each day.",
						Pattern :> _Legended
					}
				}
			},
			{
				Definition -> {"PlotLongTaskTimeline[protocol]", "protocolSummaryFigure"},
				Description -> "displays long task counts for a given protocol over the last month.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "The protocols from which long tasks should be found.",
						Widget -> Widget[Type->MultiSelect,Pattern:>DuplicateFreeListableP[TypeP[{Object[Protocol],Object[Qualification],Object[Maintenance]}]]]
					}
				},
				Outputs :> {
					{
						OutputName -> "protocolSummaryFigure",
						Description -> "A plot showing the long task counts over the last month for the given protocol.",
						Pattern :> _Legended
					}
				}
			},
				{
				Definition -> {"PlotLongTaskTimeline[timeSpan]", "spanningFigure"},
				Description -> "displays long task counts during 'timeSpan' with a bin size based on the amount of time to be displayed.",
				Inputs :> {
					{
						InputName -> "timeSpan",
						Description -> "Indicates how far in the past to show the data.",
						Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Day], Units->Alternatives[Year,Month,Week,Day]]
					}
				},
				Outputs :> {
					{
						OutputName -> "spanningFigure",
						Description -> "A plot showing the long tasks during the 'timeSpan'.",
						Pattern :> _Legended
					}
				}
			},
			{
				Definition -> {"PlotLongTaskTimeline[protocol,timeSpan]", "protocolFigure"},
				Description -> "displays long task counts for a given protocol during 'timeSpan' with a bin size based on the amount of time to be displayed.",
				Inputs :> {
					{
						InputName -> "protocol",
						Description -> "The protocols from which long tasks should be found.",
						Widget -> Widget[Type->MultiSelect,Pattern:>DuplicateFreeListableP[TypeP[{Object[Protocol],Object[Qualification],Object[Maintenance]}]]]
					},
					{
						InputName -> "timeSpan",
						Description -> "Indicates how far in the past to show the data.",
						Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Day], Units->Alternatives[Year,Month,Week,Day]]
					}
				},
				Outputs :> {
					{
						OutputName -> "protocolFigure",
						Description -> "A plot showing the long task counts during the 'timeSpan' for the given protocol.",
						Pattern :> _Legended
					}
				}
			}
		},
		AdditionalDefinitions->{
			{
				"Definition" -> {"PlotLongTaskTimeline[timeSpan,bin]", "figure"},
				"Description" -> "displays the long tasks that occurred during 'timeSpan' with interval 'bin'.",
				"Inputs" :> {
					{
						InputName -> "timeSpan",
						Description -> "Indicates how far in the past to show the data.",
						Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Day], Units->Alternatives[Year,Month,Week,Day]]
					},
					{
						InputName -> "bin",
						Description -> "The size of the time period used for individual data points.",
						Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Hour], Units->Alternatives[Year,Month,Week,Day,Hour]]
					}
				},
				"Outputs" :> {
					{
						OutputName -> "figure",
						Description -> "A plot showing the long tasks during the 'timeSpan' with the defined interval.",
						Pattern :> _Legended
					}
				}
			},
			{
				"Definition" -> {"PlotLongTaskTimeline[protocol,timeSpan,bin]", "figure"},
				"Description" -> "displays the long tasks that occurred during 'timeSpan' with interval 'bin' for a given protocol.",
				"Inputs" :> {
					{
						InputName -> "protocol",
						Description -> "The protocols from which long tasks should be found.",
						Widget -> Widget[Type->MultiSelect,Pattern:>DuplicateFreeListableP[TypeP[{Object[Protocol],Object[Qualification],Object[Maintenance]}]]]
					},
					{
						InputName -> "timeSpan",
						Description -> "Indicates how far in the past to show the data.",
						Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Day], Units->Alternatives[Year,Month,Week,Day]]
					},
					{
						InputName -> "bin",
						Description -> "The size of the time period used for individual data points.",
						Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Hour], Units->Alternatives[Year,Month,Week,Day,Hour]]
					}
				},
				"Outputs" :> {
					{
						OutputName -> "figure",
						Description -> "A plot showing the long tasks during the 'timeSpan' with the defined interval for a given protocol.",
						Pattern :> _Legended
					}
				}
			},
			{
				"Definition" -> {"PlotLongTaskTimeline[startTime,endTime,bin]", "figure"},
				"Description" -> "displays the long tasks that occurred from 'startTime' to 'endTime' with interval of 'bin'.",
				"Inputs" :> {
					{
						InputName -> "startTime",
						Description -> "the start of the time period for which data should be shown.",
						Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]

					},
					{
						InputName -> "endTime",
						Description -> "the end of the time period for which data should be shown.",
						Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]
					},
					{
						InputName -> "bin",
						Description -> "The size of the time period used for individual data points.",
						Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Hour], Units->Alternatives[Year,Month,Week,Day,Hour]]
					}
				},
				"Outputs" :> {
					{
						OutputName -> "figure",
						Description -> "A plot showing the total long tasks between certain two dates with defined interval.",
						Pattern :> _Legended
					}
				}
			},
			{
				"Definition" -> {"PlotLongTaskTimeline[protocol,startTime,endTime,bin]", "figure"},
				"Description" -> "displays long tasks from 'startTime' to 'endTime' with interval of 'bin' for a given protocol.",
				"Inputs" :> {
					{
						InputName -> "protocol",
						Description -> "The protocols from which long tasks should be found.",
						Widget -> Widget[Type->MultiSelect,Pattern:>DuplicateFreeListableP[TypeP[{Object[Protocol],Object[Qualification],Object[Maintenance]}]]]
					},
					{
						InputName -> "startTime",
						Description -> "the start of the time period for which data should be shown.",
						Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]

					},
					{
						InputName -> "endTime",
						Description -> "the end of the time period for which data should be shown.",
						Widget -> Widget[Type -> Date, Pattern :> _?DateObjectQ, TimeSelector->False]
					},
					{
						InputName -> "bin",
						Description -> "The size of the time period used for individual data points.",
						Widget -> Widget[Type->Quantity, Pattern:>GreaterP[0 Hour], Units->Alternatives[Year,Month,Week,Day,Hour]]
					}
				},
				"Outputs" :> {
					{
						OutputName -> "figure",
						Description -> "A plot showing the total long tasks between certain two dates with defined interval for a specific protocol.",
						Pattern :> _Legended
					}
				}
			}
		},
		MoreInformation->{
		},
		SeeAlso->{
			"PlotSupportTimeline",
			"TroubleshootingTable"
		},
		Author->{"hayley", "mohamad.zandian"}
	}
]