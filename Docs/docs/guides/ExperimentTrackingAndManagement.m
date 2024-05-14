(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Experiment Tracking And Management",
	Abstract -> "Collection of functions use to track and control the flow of experiments in an ECL facility.",
	Reference -> {
		"Managing Protocols" -> {
			{ConfirmProtocol, "Directs the ECL to confirm an experimental protocol that is InCart to begin running in the lab."},
			{UnconfirmProtocol, "Directs the ECL to cancel conformation of an experimental protocol and return a protocol to the Cart."},
			{CancelProtocol, "Permanently cancels an experimental protocol, removing it from processing or the cart."}
		},
		"Threading and Queues" -> {
			{PrioritizeBacklog, "Sets the order in which experimental protocols should be taken from the backlog into processing when more threads become available."},
			{OpenThreads, "Returns a list of protocols that are currently occupying lab threads."},
			{AvailableThreads, "Returns the number of remaining threads that are available to run additional experimental protocols simultaneously."},
			{BacklogTime, "Estimates the amount of time an experimental protocol will remain in the backlog before processing has begun based on the number of threads and the state of the experiments currently processing."},
			{QueueTime, "Estimates the amount of time a processing experiment will be awaiting available resources by looking at recent historic usage data from the facility."},
			{UploadProtocolPriority, "Modifies the priority of the input protocol that will run in the lab."},
			{ParseLog, "Parses and returns useful information for the objects from the specified log field."},
			{ProtocolDelayTime, "Estimates the total amount of time a protocol was delayed beyond our Estimate."}
		},
		"Troubleshooting" -> {
			{RequestSupport, "Facilitates communication with ECL's System Diagnostics team in dealing with any unexpected behavior encountered with the system."}
		}
	},
	RelatedGuides -> {
		GuideLink["RunningExperiments"],
		GuideLink["FacilitiesCapabilitiesAndLimitations"],
		GuideLink["PricingFunctions"]
	}
]
