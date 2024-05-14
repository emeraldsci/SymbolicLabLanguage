(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*FirstOrDefault*)

DefineUsage[FirstOrDefault,
	{
		BasicDefinitions -> {
			{"FirstOrDefault[expression]", "result", "returns the first element of 'expression' unless it has no length then returns Null."},
			{"FirstOrDefault[expression,default]", "result", "returns the first element of 'expression' unless it has no length, then returns 'default'."}
		},
		Input :> {
			{"expression", _, "An expression to take the first element of."},
			{"default", _, "Default value to return when input expression is length 0."}
		},
		Output :> {
			{"result", _, "Either the first element of the input expression or the specified default value."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"First",
			"LastOrDefault",
			"MostOrDefault",
			"RestOrDefault"
		},
		Author -> {
			"brad"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*LastOrDefault*)

DefineUsage[LastOrDefault,
	{
		BasicDefinitions -> {
			{"LastOrDefault[expression]", "result", "returns the last element of 'expression' unless it has no length then returns Null."},
			{"LastOrDefault[expression,default]", "result", "returns the last element of 'expression' unless it has no length, then returns 'default'."}
		},
		Input :> {
			{"expression", _, "An expression to take the last element of."},
			{"default", _, "Default value to return when input expression is length 0."}
		},
		Output :> {
			{"result", _, "Either the last element of the input expression or the specified default value."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"Last",
			"FirstOrDefault",
			"MostOrDefault",
			"RestOrDefault"
		},
		Author -> {
			"brad"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*MostOrDefault*)

DefineUsage[MostOrDefault,
	{
		BasicDefinitions -> {
			{"MostOrDefault[expression]", "result", "returns the 'expression' with the last element removed or Null if 'expression' is length 0."},
			{"MostOrDefault[expression,default]", "result", "returns the 'expression' with the last element removed or 'default' if 'expression' is length 0."}
		},
		Input :> {
			{"expression", _, "An expression to remove the last element from."},
			{"default", _, "Default value to return when input expression is length 0."}
		},
		Output :> {
			{"result", _, "Either the expression with the last element remove or the specified default value."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"Most",
			"FirstOrDefault",
			"LastOrDefault",
			"RestOrDefault"
		},
		Author -> {
			"brad"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*RestOrDefault*)

DefineUsage[RestOrDefault,
	{
		BasicDefinitions -> {
			{"RestOrDefault[expression]", "result", "returns the 'expression' with the first element removed or Null if 'expression' is length 0."},
			{"RestOrDefault[expression,default]", "result", "returns the 'expression' with the first element removed or 'default' if 'expression' is length 0."}
		},
		Input :> {
			{"expression", _, "An expression to remove the first element from."},
			{"default", _, "Default value to return when input expression is length 0."}
		},
		Output :> {
			{"result", _, "Either the expression with the first element remove or the specified default value."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"Rest",
			"FirstOrDefault",
			"LastOrDefault",
			"MostOrDefault"
		},
		Author -> {
			"brad"
		}
	}];


(* ::Subsubsection::Closed:: *)
(*DeleteNestedDuplicates*)

DefineUsage[DeleteNestedDuplicates,
	{
		BasicDefinitions -> {
			{"DeleteNestedDuplicates[list]", "duplicateFree", "deletes repeated non-List items across an arbitrary-depth list of lists such that a flattened version of the input list will contain no duplicates."}
		},
		MoreInformation -> {

		},
		Input :> {
			{"list", _List, "A list from which duplicate non-list elements will be removed."}
		},
		Output :> {
			{"duplicateFree", _List, "A list of the same depth as the input list with duplicate non-list elements removed."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"DeleteDuplicates",
			"DuplicateFreeQ",
			"Position",
			"Delete"
		},
		Author -> {"ben", "olatunde.olademehin"}
	}];


(* ::Subsubsection::Closed:: *)
(*ParseLog*)


DefineUsage[
	ParseLog,
	{
		BasicDefinitions -> {
			{"ParseLog[objects,field]","data","parses useful information for the 'objects' from the specified log field 'field' using sensible default parameters, such as total times spent in each status."}
		},
		AdditionalDefinitions->{
			{"ParseLog[log,dateColumn,statusColumn,identifierColumn,fieldOfInterest,singleStatusQ,closedLogQ,inactiveStatuses]","data","parses useful information from a directly supplied 'log', with all required parameters manually specified."}
		},
		MoreInformation->{
			"ParseLog takes a log field as input and returns useful information about the time periods that the target was in a particular status.",
			"For example, a StatusLog logs the times at which a target changes status. ParseLog takes this log and returns the total amount of time that the target spent in each status.",
			"The function consists of a core overload (Additional Definitions) that takes the log contents directly (no interaction with the database) and a fully specified set of parameters to be used to parse the log.",
			"There is also a friendly overload (Basic Definitions) that takes a list of objects, the field name to parse, and determines a sensible set of default parameters for that log field type. Manual parsing parameters can still be passed through using options.",
			"The number of options that can be specified is indicative of the diversity of log fields - you may be able to get the function to return a result, but it may not mean much for your particular result. Check that the output is what you intend.",
			"Log fields broadly fall into two categories - single status and multi-status. A single status field is one where each new line in the log implicitly supersedes the previous line, such as an instrument status log. A multi-status log is one where this is not the case, for example a contents log. A line removing B from the target does not have any effect on a line referring to A.",
			"ParseLog splits up multi-status logs based on the supplied identifier column, into a series of single-status sub-logs for each identifier. The results from each sub-log are then combined prior to output.",
			"An additional consideration for multi-status logs is whether to 'double count' periods of overlap. Primary use case is operator ProtocolLogs where an operator can be in two protocols at once, when interrupted. However, the operator is only actively working on the most recent protocol. Counting overlap returns the total time between entering and exiting a protocol, and not counting overlap returns the total time a protocol is actively being worked on.",
			"Counting overlap has little relevance to most multi-status log fields, such as a ContentsLog.",
			"Logs can also be considered closed or open. A closed log is one where the final entry in the log should be considered the end, otherwise analysis will continue to Now.",
			"For example, if a protocol is Processing, that status should be considered to extend to Now. However, if a protocol is completed, it may be more sensible to consider the log closed at the final entry, otherwise there will be a long period of Completed status. This is accurate, but not necessarily desirable.",
			"Closed log looks at DateRetired, DateDiscarded and DateCompleted to determine if a log is better regarded as closed.",
			"Inactive Statuses describe statuses where the following time period should not be associated with the party making the change. This is most relevant when analyzing multi-status fields, or a field that is not the status field.",
			"For example, if analyzing the parties who have used an instrument, this involves analyzing the \"Responsible Party\" of the StatusLog. However, if a party set the instrument to Available, the following time period in the log should not be associated with that party. Available should therefore be included in the InactiveStatuses.",
			"For multi-status logs such as a contents log, InactiveStatuses functions similarly. Time periods will only be counted when each object is active (in the case of a contents log, when the object is \"In\").",
			"The additional options allow you to describe the log that is being parsed. DateColumn and StatusColumn are fixed for a certain log type. FieldColumn and IdentifierColumn may be change to manipulate output.",
			"ParseLog does not perform any log validation, so if the log field contains incorrect or atypical entries, the results may not be representative.",
			"Log fields currently supported with automatic parameters are: StatusLog, QualificationResultsLog, RestrictedLog, MassLog, CountLog, VolumeLog, LocationLog, ConnectionLog, WiringConnectionsLog, ContentsLog, ProtocolLog."
		},
		Input :> {
			{"objects",{ObjectP[]..},"A list of objects that have field."},
			{"field",_Symbol,"The field name to parse for each of object"},
			{"log",Alternatives[{{__}..},{<|__|>..}],"The literal lines of the log field."},
			{"dateColumn",GreaterP[0,1],"The number of the column containing the dates of the log entries"},
			{"statusColumn",GreaterP[0,1],"The number of the column containing the status of the log entries"},
			{"identifierColumn",GreaterP[0,1],"The number of the column containing the identifier of the log entries"},
			{"fieldOfInterest",ListableP[GreaterP[0,1]],"The number of the column containing the field(s) to output of the log entries"},
			{"singleStatusQ",BooleanP,"Indicates if each entry in the log automatically supersedes the previous entry."},
			{"closedLogQ",BooleanP,"Indicates if the final entry in the log should be considered to end the analysis period."},
			{"inactiveStatuses",ListableP[_Symbol],"A list of any statuses where the following time period in the log should not be associated with the party who set this status."}
		},
		Output :> {
			{"data",_,"Useful information from the log field."}
		},
		Options:>{},
		SeeAlso :> {
		},
		Author->{"david.ascough", "dirk.schild"}
	}
];