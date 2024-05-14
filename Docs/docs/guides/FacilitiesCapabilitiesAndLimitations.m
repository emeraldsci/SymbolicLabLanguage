(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

Guide[
	Title -> "Facilities Capabilities And Limitations",
	Abstract -> "Collection of functions for assessing the status and limitations of ECL Facilities and Capabilities.",
	Reference -> {
		"Chemical Compatibility" -> {
			{CompatibleMaterialsQ, "Checks if the wetted materials of a given instrument are thought to be chemically compatible with a provided list of samples."}
		},
		"Sample Limitations" -> {
			{SampleVolumeRangeQ, "Checks if a given volume can be measured and manipulated in the lab."},
			{AchievableResolution, "Rounds a provided volume or mass to the closest precision a given instrument type is capable of working with in the ECL."},
			{PreferredContainer, "Returns the smallest standardized ECL container model which can hold a given volume."},
			{AliquotContainers, "Finds the potential preferred containers that can both hold the all volume of input sample and fit on input instrument."},
			{TransferDevices, "Given a volume or mass returns a list of devices that can be used to measure that amount, along with the working measuring range and resolution of those devices."},
			{IncubateCellsDevices, "Indicates which incubators are compatible with the container models, container or samples given as inputs."},
			{IncubateDevices, "Indicates which incubators are compatible with the samples given as inputs."},
			{MixDevices, "Indicates which instruments can be used to mix the sample or a given sample volume inside a container model."},
			{LNAChimeraQ, "Checks if the given string or strand is a valid Chimera sequence."}
		},
		"Footprint Limitations" ->{
			{CompatibleFootprintQ, "Checks if a sample or a container can fit into the one of the positions in the specified instrument or location."},
			{CentrifugeDevices, "Lists all instruments physically capable of centrifuging a given set of samples."}
		},
		"Resource Requests" -> {
			{Resource, "Wrapper for defining a resource request within the ECL facility for use in conducting experiments."},
			{ValidResourceQ, "Checks if a give Resource request is properly formatted for its given type of resource."},
			{SampleUsage, "Creates a table that lists out the usage amount, the amount in user's inventory, and amount in public inventory fo all samples specified in input unit operations."}
		}
	},
	RelatedGuides -> {
		GuideLink["RunningExperiments"],
		GuideLink["ExperimentTrackingAndManagement"],
		GuideLink["PricingFunctions"]
	}
]
