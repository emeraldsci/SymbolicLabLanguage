(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineUsage[
	ValidContainerStorageConditionQ,
	{
		BasicDefinitions -> {
			{"ValidContainerStorageConditionQ[mySamples,myStorageConditions]", "{isValidContainerStorageCondition}", "checks that the storage conditions are compatible with samples that share the same container."},
			{"ValidContainerStorageConditionQ[myGeneratedSamples,myResolvedContainers,myResolvedStorageConditions]", "{isValidContainerStorageCondition}", "checks that the resolved storage conditions are compatible with samples that share the same resolved container."}
		},
		Input :> {
			{"mySamples", ListableP[ObjectP[Object[Sample]]], "The objects that we want to make sure have compatible storage conditions."},
			{"myStorageConditions", ListableP[SampleStorageConditionP | Disposal], "The storage conditions we want to make sure are compatible with the shared container samples."},
			{"myGeneratedSamples", ListableP[ObjectP[{Object[Sample], Model[Sample]}]], "The objects that we want to make sure have compatible storage conditions."},
			{"myResolvedContainers", ListableP[{_Integer, ObjectP[{Model[Container]}]} | ObjectP[{Object[Container], Model[Container]}]], "The containers the samples will be generated in."},
			{"myResolvedStorageConditions", ListableP[SampleStorageConditionP | Disposal], "The storage conditions we want to make sure are compatible with the shared container samples."}
		},
		Output :> {
			{"isValidContainerStorageCondition", ListableP[BooleanP], "Indicates if the storage conditions 'myStorageConditions' are compatible with shared container sample storage conditions."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"UploadProtocolStatus",
			"UploadStorageCondition",
			"Upload"
		},
		Author -> {"robert", "alou", "millie.shah"}
	}
];