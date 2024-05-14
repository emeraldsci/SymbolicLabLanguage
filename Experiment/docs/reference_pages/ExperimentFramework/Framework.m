(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*resolveSharedOptions*)

DefineUsage[
	resolveSharedOptions,
	{
		BasicDefinitions -> {
			{"resolveSharedOptions[myChildFunction, myErrorMessagePrefix, mySamplePackets, myResolverMasterSwitches, myOptionMap, myOptions, myConstantOptions, myMapThreadOptions, gatherTestsQ, myResolutionOptions]", "optionsSimulationAndTests,", " calls myChildFunction with the given options according to the myMasterSwitches input, and returns back options, simulation, and tests from the childFunction, with error messages prefixed according to myErrorMessagePrefix."}
		},
		MoreInformation -> {},
		Input :> {
			{"myChildFunction", _Symbol, "The child function that will be passed the samples on which the child function will be applied."},
			{"myErrorMessagePrefix", _String, "The error message prefix to prepend to any error messages thrown by the child function."},
			{"mySamplePackets", {PacketP[Object[Sample]]..}, "The sample packets, index matches to resolverMasterSwitches, for the child function."},
			{"myResolverMasterSwitches", {BooleanP..}, "The list of booleans that indicate which samples/options will be sent down to the child function."},
			{"myOptionMap", {_Rule...}, "A list of shared option symbol to child function option symbol, to translate options from their shared option set to what they are named in the actual child function being called."},
			{"myOptions", {_Rule...}, "The list of shared options that will be sent down to the childFunction, after translation by the optionMap."},
			{"myConstantOptions", {_Rule...}, "The options that will always be sent down to childFunction, along with experimentOptions, regardless of the masterSwitch input."},
			{"myMapThreadOptions", {_Association...}, "The map thread friendly options, index matched to the sample packets."},
			{"gatherTestsQ", BooleanP, "Indicates if tests will be gathered when calling the childFunction."},
			{"myResolutionOptions", OptionsPattern[resolveSharedOptions], "Other resolution options passed into the childFunction such as the cache or simulations."}
		},
		Output :> {
			{"optionsSimulationAndTests", {{_Rule..}, SimulationP, {_Test...}}, "The resolved options (index matching to the original samples list), simulation, and tests returned by childFunction."}
		},
		SeeAlso -> {
			"populatePreparedSamples"
		},
		Author -> {"taylor.hochuli", "harrison.gronlund"}
	}
];

(* ::Subsection::Closed:: *)
(*populateWorkingAndAliquotSamples*)


DefineUsage[
	populateWorkingAndAliquotSamples,
	{
		BasicDefinitions->{
			{"populateWorkingAndAliquotSamples[protocol]","protocol"," populates WorkingSamples/WorkingContainers from SamplesIn/ContainersIn if they are not filled out, otherwise, populates AliquotSamples if WorkingSamples is different than SamplesIn."}
		},
		MoreInformation->{},
		Input:>{
			{"protocol",ObjectP[Object[Protocol]],"The protocol whose WorkingSamples/WorkingContainers or AliquotSamples will be updated."}
		},
		Output:>{
			{"protocol",ObjectP[Object[Protocol]],"The updated protocol."}
		},
		SeeAlso->{
			"populatePreparedSamples"
		},
		Author->{"ben", "tyler.pabst", "charlene.konkankit", "thomas"}
	}
];

(* ::Subsection::Closed:: *)
(*populatePreparedSamples*)


DefineUsage[
	populatePreparedSamples,
	{
		BasicDefinitions->{
			{"populatePreparedSamples[protocol]","protocol","populates any samples/containers that were prepared by PreparatoryUnitOperations/PreparatoryPrimitives in the fields in which their resources were created."}
		},
		MoreInformation->{
			"When a resource for a simulated sample (from PreparatoryUnitOperations/PreparatoryPrimitives) is made, the PreparedSamples field is filled out with the label of that sample and the field that the sample should be uploaded to once it is prepared.",
			"This function looks at the PreparedSamples field and the SamplePreparationProtocols field to fill out the fields in the protocol object with the Object[Sample]/Object[Container] that was prepared",
			"This happens similar to how the resource picking system fills out picked resources via the RequiredResources field."
		},
		Input:>{
			{"protocol",ObjectP[Object[Protocol]],"The protocol whose WorkingSamples/WorkingContainers will be updated."}
		},
		Output:>{
			{"protocol",ObjectP[Object[Protocol]],"The updated protocol."}
		},
		SeeAlso->{
			"ExperimentSamplePreparation",
			"simulateSamplePreparationPacketsNew"
		},
		Author->{"thomas", "lige.tonggu"}
	}
];

(* ::Subsection::Closed:: *)
(*populateWorkingSamples*)


DefineUsage[
	populateWorkingSamples,
	{
		BasicDefinitions->{
			{"populateWorkingSamples[protocol]","protocol","sets the WorkingSamples and WorkingContainers field to the last SamplesOut/ContainersOut after sample preparation."}
		},
		MoreInformation->{
			"All operations on samples/containers should occur on WorkingSamples/WorkingContainers in the procedure (after sample preparation) instead of SamplesIn/ContainersIn.",
			"If samples are not being manipulated by Sample Preparation, they are kept to be the same SamplesIn/ContainersIn.",
			"WorkingSamples/WorkingContainers index matches to SamplesIn/ContainersIn."
		},
		Input:>{
			{"protocol",ObjectP[Object[Protocol]],"The protocol whose WorkingSamples/WorkingContainers will be updated."}
		},
		Output:>{
			{"protocol",ObjectP[Object[Protocol]],"The updated protocol."}
		},
		SeeAlso->{
			"ValidInputLengthsQ",
			"ExpandIndexMatchedInputs",
			"SafeOptions"
		},
		Author->{"hanming.yang", "thomas"}
	}
];


(* ::Subsection::Closed:: *)
(*containerToSampleOptions*)


DefineUsage[
	containerToSampleOptions,
	{
		BasicDefinitions->{
			{"containerToSampleOptions[myFunction,myObjects,myOptions]","samplesAndOptions","converts options index matched to a container to be indexed matched to the samples within that container."}
		},
		MoreInformation->{
			"Only options marked as IndexMatching->Input which were provided as lists index-matched to the input will be converted to match the samples. All other MapThread options, will be left unchanged.",
			"containerToSampleOptions does not validate option lengths or patterns. If an option is an invalid length or does not match its pattern it will be left unchanged."
		},
		Input:>{
			{"myFunction",_Symbol,"The function whose options are being index matched to the full list of sampeles."},
			{"myObjects",ListableP[ObjectP[{Object[Container],Model[Contaienr],Object[Sample],Model[Sample]}]],"The input objects which should be converted to samples."},
			{"myOptions",{(_Rule|_RuleDelayed)...},"The options which should be index matched to the full list of samples."}
		},
		Output:>{
			{"samplesAndOptions",{{ObjectP[Object[Sample]]...},{(_Rule|_RuleDelayed)...}},"Samples and the options index matched to them."}
		},
		SeeAlso->{
			"ValidInputLengthsQ",
			"ExpandIndexMatchedInputs",
			"SafeOptions"
		},
		Author->{"hayley","thomas"}
	}
];


(* ::Subsection::Closed:: *)
(*splitPrepOptions*)


DefineUsage[
	splitPrepOptions,
	{
		BasicDefinitions->{
			{"splitPrepOptions[allExperimentOptions]","{prepOptions,experimentSpecificOptions}","partitions 'allExperimentOptions' into options used to specify standard sample prep and experiment-specific options."}
		},
		MoreInformation->{
			"This function has the side effect of deleting duplicates by taking the last of any duplicated option rules in the input option list."
		},
		Input:>{
			{"allExperimentOptions",{(_Rule|_RuleDelayed)...},"The Experiment function options which should be separated by category."}
		},
		Output:>{
			{"prepOptions",{(_Rule|_RuleDelayed)...},"Options used to specify standard sample prep."},
			{"experimentSpecificOptions",{(_Rule|_RuleDelayed)...},"Experiment-specific options."}
		},
		SeeAlso->{
			"ExperimentMix",
			"ExperimentFilter",
			"ExperimentIncubate",
			"ExperimentCentrifuge"
		},
		Author->{"hayley","mohamad.zandian"}
	}
];


(* ::Subsection::Closed:: *)
(*resolveSamplePrepOptions*)


DefineUsage[
	resolveSamplePrepOptions,
	{
		BasicDefinitions->{
			{"resolveSamplePrepOptions[myFunction,mySamples,mySamplePrepOptions]","resolvedPrepOptions","resolves all provided options related to sample prep."}
		},
		MoreInformation->{
		},
		Input:>{
			{"myFunction",_Symbol,"The experiment function that is resolving these options."},
			{"mySamples",{ObjectP[{Object[Sample]}]..},"The samples to which should be prepped."},
			{"mySamplePrepOptions",{(_Rule|_RuleDelayed)...},"The initial options descirbing how prep should occur."}
		},
		Output:>{
			{"resolvedPrepOptions",{(_Rule|_RuleDelayed)...},"The complete set of options which fully describe how the samples will be prepped."}
		},
		SeeAlso->{
			"ValidInputLengthsQ",
			"ExpandIndexMatchedInputs",
			"SafeOptions",
			"SimulateSample"
		},
		Author->{"thomas", "lige.tonggu"}
	}
];


(* ::Subsection::Closed:: *)
(*simulateSamplesResourcePackets*)


DefineUsage[
	simulateSamplesResourcePackets,
	{
		BasicDefinitions->{
			{"simulateSamplesResourcePackets[myFunction,mySamples,myResolvedOptions]","{simulatedSamples,simulatedCache}","simulates any samples (and returns then via in-situ replacement) that will be affected by sample manipulation."}
		},
		MoreInformation->{},
		Input:>{
			{"myFunction",_Symbol,"The experiment function that this sample is being called from."},
			{"mySamples",{ObjectP[Object[Sample]]...},"The samples to the main experiment function."},
			{"myResolvedOptions",{(_Rule|_RuleDelayed)...},"The full set of resolved options of this experiment function."}
		},
		Output:>{
			{"simulatedSamples",{ObjectP[Object[Sample]]...},"The samples (after simulation) as they will exist after sample preparation (including aliquot)."},
			{"simulatedCache",{PacketP[]..},"Packets from the simulated sample and container objects that should be used to download information from the simulated samples."}
		},
		SeeAlso->{
			"resolveSamplePrepOptions",
			"populateSamplePrepFields",
			"resolveSamplePrepOptions"
		},
		Author->{"thomas", "lige.tonggu"}
	}
];


(* ::Subsection::Closed:: *)
(*resolveAliquotOptions*)


DefineUsage[
	resolveAliquotOptions,
	{
		BasicDefinitions->{
			{"resolveAliquotOptions[mySamples,mySimulatedSamples,myPrepOptions]","resolvedAliquotOptions","resolves all aliquot options among those provided."}
		},
		MoreInformation->{},
		Input:>{
			{"mySamples",ListableP[ObjectP[Object[Sample]]],"The samples to the main experiment function."},
			{"mySimulatedSamples",ListableP[ObjectP[Object[Sample]]],"The simulated samples to the main experiment function."},
			{"myPrepOptions",{(_Rule|_RuleDelayed)...},"The initial options describing how aliquoting should occur."}
		},
		Output:>{
			{"resolvedAliquotOptions",{(_Rule|_RuleDelayed)...},"The complete set of options which fully describe how the samples will be aliquoted."}
		},
		SeeAlso->{
			"ExperimentAliquot",
			"populateSamplePrepFields",
			"resolveSamplePrepOptions"
		},
		Author->{"thomas", "lige.tonggu"}
	}
];



(* ::Subsection::Closed:: *)
(*populateSamplePrepFields*)


DefineUsage[
	populateSamplePrepFields,
	{
		BasicDefinitions->{
			{
				"populateSamplePrepFields[myUnexpandedSamplesIn,myResolvedOptions]",
				"samplePrepFields",
				"returns a sequence of sample prep fields that should be included in each protocol packet."
			}
		},
		Input:>{
			{"myUnexpandedSamplesIn",{ObjectP[Object[Sample]]..},"The unexpanded SamplesIn that were supplied by the user as input to the experiment function."},
			{"myResolvedOptions",{(_Rule|_RuleDelayed)...},"The resolved options from the resolveExperiment<Type>Options function."}
		},
		Output:>{
			{"samplePrepFields",{(_Rule|_RuleDelayed)...},"A sequence of sample prep fields that should be included in each protocol object."}
		},
		SeeAlso->{
			"containerToSampleOptions",
			"splitPrepOptions",
			"RoundOptionPrecision",
			"mapThreadOptions"
		},
		Author->{"hayley", "mohamad.zandian"}
	}
];

(* ::Subsection::Closed:: *)
(*populateSamplePrepFieldsPooled*)


DefineUsage[
	populateSamplePrepFieldsPooled,
	{
		BasicDefinitions->{
			{
				"populateSamplePrepFieldsPooled[myUnexpandedSamplesIn,myResolvedOptions]",
				"samplePrepFields",
				"returns a sequence of sample prep fields that should be included in each protocol packet. This function should be used instead of populateSamplePrepFields if experiment function allows pooled sample input, to allow correct handling of aliquot fields."
			}
		},
		Input:>{
			{"myUnexpandedSamplesIn",{ObjectP[Object[Sample]]..},"The unexpanded SamplesIn that were supplied by the user as input to the experiment function."},
			{"myResolvedOptions",{(_Rule|_RuleDelayed)...},"The resolved options from the resolveExperiment<Type>Options function."}
		},
		Output:>{
			{"samplePrepFields",{(_Rule|_RuleDelayed)...},"A sequence of sample prep fields that should be included in each protocol object."}
		},
		SeeAlso->{
			"containerToSampleOptions",
			"splitPrepOptions",
			"RoundOptionPrecision",
			"mapThreadOptions",
			"populateSamplePrepFields"
		},
		Author->{"hanming.yang"}
	}
];


(* ::Subsection::Closed:: *)
(*resolvePostProcessingOptions*)


DefineUsage[
	resolvePostProcessingOptions,
	{
		BasicDefinitions->{
			{"resolvePostProcessingOptions[myOptions]","resolvedPostProcessingOptions","resolves the post-processing options by looking at the root protocol's settings:"}
		},
		MoreInformation->{
			"Results may vary if you have not already called SafeOptions on the provided options.",
			"If there is no parent protocol (or no parent protocol option), Automatics will default to True:"
		},
		Input:>{
			{"myOptions",{(_Rule|_RuleDelayed)...},"The 'safe' experiment function's options."}
		},
		Output:>{
			{"resolvedPostProcessingOptions",{(_Rule|_RuleDelayed)...},"The post processing options with Automatics replaced by Booleans."}
		},
		SeeAlso->{
			"resolveSamplePrepOptions",
			"resolveAliquotOptions"
		},
		Author->{"hayley", "mohamad.zandian"}
	}
];

(* ::Subsection::Closed:: *)
(*populateWorkingAndAliquotSamples*)


DefineUsage[
	SamplePreparationCacheFields,
	{
		BasicDefinitions->{
			{"SamplePreparationCacheFields[type]","list","returns a list, sequence or packet of fields that are associated with sample preparation with the input type."}
		},
		Input:>{
			{"type",TypeP[Object[Sample]|Model[Sample]|Object[Container]|Model[Container]|Object[User]],"The protocol whose WorkingSamples/WorkingContainers or AliquotSamples will be updated."}
		},
		Output:>{
			{"list",{Symbol..},"The list, sequence or packet of relevant fields."}
		},
		SeeAlso->{
			"populatePreparedSamples"
		},
		Author->{"kelmen.low", "dima", "charlene.konkankit", "thomas", "steven"}
	}
];