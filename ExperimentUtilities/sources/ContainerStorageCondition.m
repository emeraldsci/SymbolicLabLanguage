(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineOptions[ValidContainerStorageConditionQ,
	Options :> {
		CacheOption,
		HelperOutputOption
	}
];

(*This error should be thrown when storage conditions for samples sharing a container conflict.*)
Error::SharedContainerStorageCondition="For the following samples, the specified storage condition conflicts with storage conditions of samples sharing the same container: `1`.";

(* Given an unknown format, returns Null. *)
ValidContainerStorageConditionQ[___]:=Null;

(*Given an empty input returns True*)
ValidContainerStorageConditionQ[mySamples:{}, myContainers:{}, myStorageCondition:{}, myOptions:OptionsPattern[]]:=Module[
	{safeOps, output, gatherTests, tests},

	(*Look up the safe options*)
	safeOps=SafeOptions[ValidContainerStorageConditionQ, ToList[myOptions]];

	(*Get the output option*)
	output=Lookup[safeOps, Output];

	(*figure out if we are gathering tests*)
	gatherTests=MemberQ[output, Tests] || MatchQ[output, Tests];

	(*Generate the passing test*)
	tests=If[gatherTests,
		{Test["Our sample storage conditions are compatible with shared container storage conditions: ", True, True]},
		{}
	];

	output /. {Result -> True, Tests -> tests}

];

ValidContainerStorageConditionQ[mySamples:{}, myStorageCondition:{}, myOptions:OptionsPattern[]]:=Module[
	{safeOps, output, gatherTests, tests},

	(*Look up the safe options*)
	safeOps=SafeOptions[ValidContainerStorageConditionQ, ToList[myOptions]];

	(*Get the output option*)
	output=Lookup[safeOps, Output];

	(*figure out if we are gathering tests*)
	gatherTests=MemberQ[output, Tests] || MatchQ[output, Tests];

	(*Generate the passing test*)
	tests=If[gatherTests,
		{Test["Our sample storage conditions are compatible with shared container storage conditions: ", True, True]},
		{}
	];

	output /. {Result -> True, Tests -> tests}

];

(*Given singleton inputs convert to lists*)
ValidContainerStorageConditionQ[mySamples:ObjectP[Object[Sample]], myStorageCondition:SampleStorageTypeP | Disposal | Null, myOptions:OptionsPattern[]]:=ValidContainerStorageConditionQ[{mySamples}, {myStorageCondition}, myOptions];

(*Given singleton inputs convert to lists*)
ValidContainerStorageConditionQ[mySamples:ObjectP[{Object[Sample], Model[Sample]}], myContainers:{_Integer, ObjectP[{Model[Container]}]} | ObjectP[{Object[Container], Model[Container]}], myStorageCondition:SampleStorageTypeP | Disposal | Null, myOptions:OptionsPattern[]]:=ValidContainerStorageConditionQ[{mySamples}, {myContainers}, {myStorageCondition}, myOptions];

(* Giving sample objects and storage conditions the samples container storage condition needs to be checked for any samples that share the same container. *)
ValidContainerStorageConditionQ[mySamples:ListableP[ObjectP[Object[Sample]]], myStorageCondition:ListableP[SampleStorageTypeP | Disposal | Null], myOptions:OptionsPattern[]]:=Module[
	{safeOps, cache, output, gatherTests, containerStorageConditions, containerStorageConditionsNoNulls, containerDefaultStorageConditions, results, invalidSamples, tests, containerContents,
		uniqueContentsStorageConditions, contentsObjects, containerContentsStorageConditions, additionalSamplesBoolean, samplesObjects, formattedResults
	},

	(*Look up the safe options*)
	safeOps=SafeOptions[ValidContainerStorageConditionQ, ToList[myOptions]];

	(*Get the cache for the download call*)
	cache=Lookup[safeOps, Cache];

	(*Get the output option*)
	output=Lookup[safeOps, Output];

	(*figure out if we are gathering tests*)
	gatherTests=MemberQ[output, Tests] || MatchQ[output, Tests];

	(*Get the relevant container storage information*)
	{containerStorageConditions, containerDefaultStorageConditions, containerContents}=Transpose@Download[mySamples, {Container[StorageCondition][StorageCondition], Container[Model][DefaultStorageCondition][StorageCondition], Container[Contents]}, Cache -> cache, Date -> Now];

	(*Check if there are other samples in the container that are not inputs into the function*)
	(*If the contents are Null because the sample does not have a container, return Null in a list so it wont cause errors. This ultimately wont matter because the contents will only be used if the sample shares its container. Since it doesnt have a container, there is nothing to worry about.*)
	contentsObjects=If[MatchQ[#, Null], {Null}, Download[#[[All, 2]], Object]]& /@ containerContents;
	samplesObjects=Download[mySamples, Object];
	containerContentsStorageConditions=contentsObjects /. Thread[Rule[samplesObjects, myStorageCondition]];
	uniqueContentsStorageConditions=Cases[DeleteDuplicates[#], Except[Null]]& /@ containerContentsStorageConditions;
	additionalSamplesBoolean=MatchQ[Complement[#, samplesObjects], Except[{}]]& /@ contentsObjects;

	(*For containers whose storage condition is Null, replace the storage condition with the default storage condition from the model container.*)
	containerStorageConditionsNoNulls=MapThread[If[MatchQ[#1, Null], #2, #1 ]&, {containerStorageConditions, containerDefaultStorageConditions}];

	(*Check if the storage condition specified matches the container storage condition*)
	results=MapThread[
		Function[{sampleStorageCondition, containerStorageCondition, groupStorageCondition, additionalSamplesBool},
			Switch[{additionalSamplesBool, containerStorageCondition},
				{True, Except[Null]}, MatchQ[sampleStorageCondition, containerStorageCondition | Null],
				{True, Null}, MatchQ[sampleStorageCondition, SampleStorageTypeP | Disposal | Null],
				{False, _}, MatchQ[groupStorageCondition, {SampleStorageTypeP | Disposal} | {}]
			]
		],
		{myStorageCondition, containerStorageConditions, uniqueContentsStorageConditions, additionalSamplesBoolean}];

	(*Throw an error message if the storage conditions do not match*)
	(*Find the invalid samples*)
	invalidSamples=PickList[mySamples, results, False];
	If[Length[invalidSamples] > 0 && !gatherTests, Message[Error::SharedContainerStorageCondition, invalidSamples], Nothing];

	(*Generate the passing and failling tests*)
	tests=If[gatherTests, Module[{failingTest, passingTest}, failingTest=If[Length[invalidSamples] > 0, Test["Our sample storage conditions are compatible with shared container storage conditions: ", True, False], Nothing];
	passingTest=If[Length[invalidSamples] == 0, Test["Our sample storage conditions are compatible with shared container storage conditions: ", True, True], Nothing];
	{failingTest, passingTest}],
		{}
	];

	(*Return the desired outputs*)
	(*If there is only a single result output dont return it in a list*)
	formattedResults=results /. {x_} :> x;
	output /. {Result -> formattedResults, Tests -> tests}

];

(* Giving a list of sample object/models, an index matched list of containers, and index matched list of storage conditions the shared containers' storage condition needs to be checked. *)
ValidContainerStorageConditionQ[mySamples:ListableP[ObjectP[{Object[Sample], Model[Sample]}]], myContainers:ListableP[{_Integer, ObjectP[{Model[Container]}]} | ObjectP[{Object[Container], Model[Container]}]], myStorageCondition:ListableP[SampleStorageTypeP | Disposal | Null], myOptions:OptionsPattern[]]:=Module[
	{safeOps, cache, output, gatherTests, containerStorageConditionRules, mergedRules, invalidContainers, results, invalidSamples, tests, formattedResults},

	(*Look up the safe options*)
	safeOps=SafeOptions[ValidContainerStorageConditionQ, ToList[myOptions]];

	(*Get the cache for the download call*)
	cache=Lookup[safeOps, Cache];

	(*Get the output option*)
	output=Lookup[safeOps, Output];

	(*figure out if we are gathering tests*)
	gatherTests=MemberQ[output, Tests] || MatchQ[output, Tests];

	(*Create the container storage conditions rules*)
	containerStorageConditionRules=Thread[Rule[myContainers, myStorageCondition]];

	(*Merge the container storage condition rules and delete duplicate values and Nulls*)
	mergedRules=Merge[containerStorageConditionRules, Cases[DeleteDuplicates[#], Except[Null]]&];

	(*Get just the containers with more than one storage condition*)
	invalidContainers=Keys@DeleteCases[mergedRules, {_} | {}];

	(*return the result for the sample*)
	results=!MemberQ[invalidContainers, #]& /@ myContainers;

	(*Throw an error message if the storage conditions do not match*)
	(*Find the invalid samples*)
	invalidSamples=PickList[mySamples, results, False];
	If[Length[invalidSamples] > 0 && !gatherTests, Message[Error::SharedContainerStorageCondition, invalidSamples], Nothing];

	(*Generate the passing and failling tests*)
	tests=If[gatherTests, Module[{failingTest, passingTest}, failingTest=If[Length[invalidSamples] > 0, Test["Our sample storage conditions are compatible with shared container storage conditions: ", True, False], Nothing];
	passingTest=If[Length[invalidSamples] == 0, Test["Our sample storage conditions are compatible with shared container storage conditions: ", True, True], Nothing];
	{failingTest, passingTest}],
		{}
	];

	(*Return the desired outputs*)
	(*If there is only a single result output dont return it in a list*)
	formattedResults=results /. {x_} :> x;
	output /. {Result -> formattedResults, Tests -> tests}

];