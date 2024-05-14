(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsubsection::Closed:: *)
(*QueueTime*)


DefineUsage[
	QueueTime,
	{
		BasicDefinitions -> {
			{"QueueTime[protocol]", "time", "estimates the 'time' for which the 'protocol' will remain in the queue before it is executed on the ECL based on recent historical queue data."}
		},
		MoreInformation -> {
			"The estimate is calculated from the recent historical queue data statistics stored in the latest Object[Report,QueueTimes] object.",
			"If no Object[Report,QueueTimes] can be found for the last month, it will use hard-coded default estimates."
		},
		Input :> {
			{"protocol", ListableP[ObjectP[Object[Protocol]]], "The protocol(s) whose queue time is being estimated."}
		},
		Output :> {
			{"time", ListableP[GreaterP[0 Hour]], "The estimated time for which the protocol(s) will remain in the queue before being executed."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"UploadProtocolStatus",
			"ReportQueueTimes",
			"BacklogTime"
		},
		Author -> {"hayley", "mohamad.zandian", "ben", "srikant"}
	}
];


(* ::Subsubsection::Closed:: *)
(*BacklogTime*)


DefineUsage[
	BacklogTime,
	{
		BasicDefinitions -> {
			{"BacklogTime[protocol]", "time", "estimates the 'time' for which the backlogged 'protocol' will remain in the backlog before it enters the queue based on processing, queue and backlog times of all other protocols ahead of it."}
		},
		MoreInformation -> {
			"The estimate is calculated by considering:",
			" The processing time for any currently processing protocols.",
			" The processing time for any yet unstarted processing protocol.",
			" The processing time for any backlogged protocols.",
			" The expected queue time (based on recent historical data) for any yet unstarted processing protocols.",
			" The expected queue time (based on recent historical data) for any backlogged protocols.",
			" The maxium number of threads.",
			" The predicated number of available threads at any given time as protocols are being promoted from the backlog to the queue and processing protocols are completed."
		},
		Input :> {
			{"protocol", ListableP[ObjectP[Object[Protocol]]], "The protocol(s) whose backlog time is being estimated."}
		},
		Output :> {
			{"time", ListableP[GreaterP[0 Hour]], "The estimated time for which the protocol(s) will remain in the backlog before being entering the queue."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"UploadProtocolStatus",
			"ReportQueueTimes",
			"QueueTime"
		},
		Author -> {"mohamad.zandian", "hayley"}
	}
];