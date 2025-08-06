(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineUsage[
	ValidStorageConditionQ,
	{
		BasicDefinitions -> {
			{"ValidStorageConditionQ[mySample,myStorageCondition]", "isValidStorageCondition", "checks that the storage safety information from 'myStorageCondition' and 'mySample' are the same."}
		},
		Input :> {
			{"mySample", ObjectP[Object[Sample]], "The object that we want to make sure is compatible with the storage condition."},
			{"myStorageCondition", ObjectP[Model[StorageCondition]], "The storage condition we want to make sure is compatible with the sample."}
		},
		Output :> {
			{"isValidStorageCondition", BooleanP, "Indicates if the storage safety information from 'myStorageCondition' and 'mySample' are the same."}
		},
		Sync -> Automatic,
		SeeAlso -> {
			"UploadProtocolStatus",
			"UploadStorageCondition",
			"Upload"
		},
		Author -> {"xu.yi", "waseem.vali", "malav.desai", "thomas"}
	}
];