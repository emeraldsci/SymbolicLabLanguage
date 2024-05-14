(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineOptions[ValidStorageConditionQ,
	Options :> {
		CacheOption
	}
];

Error::InvalidStorageCondition="Unable to store the sample `1` in the storage condition `2` because the field(s) `3` from the sample and storage condition do not match. Please choose a storage condition where the field values of {Flammable,Acid,Base,Pyrophoric} match the sample.";

(* Given an unknown format, returns False. *)
ValidStorageConditionQ[___]:=False;

(* Giving a symbol for a storage condition is always valid. *)
ValidStorageConditionQ[mySample:ObjectP[{Object[Sample], Model[Sample]}], myStorageCondition:SampleStorageTypeP | Disposal, myOptions:OptionsPattern[]]:=True;

(* Giving an object for a storage condition needs to be checked. *)
ValidStorageConditionQ[mySample:ObjectP[{Object[Sample], Model[Sample]}], myStorageCondition:ObjectP[Model[StorageCondition]], myOptions:OptionsPattern[]]:=Module[
	{safeOptions, safetyFields, transposedSafetyFields, trueQSafetyFields, xOrFields, differentFields},

	(* Get the safe options. *)
	safeOptions=SafeOptions[ValidStorageConditionQ, myOptions];

	(* Pull the relavant fields from the Object[Sample] and from the Model[StorageCondition]. *)
	(* These are in the form {{BooleanP,BooleanP,BooleanP,BooleanP},{BooleanP,BooleanP,BooleanP,BooleanP}}. *)
	safetyFields=Download[{mySample, myStorageCondition}, {Flammable, Acid, Base, Pyrophoric}, Cache -> Lookup[safeOptions, Cache]];

	(* Transpose these fields so we get each Field in a list with the respsective field from the StorageCondition. *)
	transposedSafetyFields=Transpose[safetyFields];

	(* Run TrueQ on all booleans and nulls. This makes everything that is not True, False. *)
	trueQSafetyFields=transposedSafetyFields /. (x:BooleanP | Null :> TrueQ[x]);

	(* Make sure that these fields line up (they must either both be False or both be True). If they don't, throw an error. *)
	xOrFields=(Xor @@ #&) /@ trueQSafetyFields;

	(* If one of the fields didn't line up: *)
	If[MemberQ[xOrFields, True],
		(* Get the name of the field(s) that are different. *)
		differentFields=Pick[{"Flammable", "Acid", "Base", "Pyrophoric"}, xOrFields];

		(* Throw an error. *)
		Message[Error::InvalidStorageCondition, ToString[mySample], ToString[myStorageCondition], ToString[differentFields]];

		(* Return False *)
		False,

		(* ELSE: Return True *)
		True
	]
];

(* Giving an object for a storage condition needs to be checked. *)
ValidStorageConditionQ[flammable:BooleanP, acid:BooleanP, base:BooleanP, pyrophoric:BooleanP, myStorageCondition:ObjectP[Model[StorageCondition]], myOptions:OptionsPattern[]]:=Module[
	{safeOptions, safetyFields, transposedSafetyFields, trueQSafetyFields, xOrFields, differentFields, sampleSafetyFields,
		storageConditionSafetyFields},

	(* Get the safe options. *)
	safeOptions=SafeOptions[ValidStorageConditionQ, myOptions];

	(* First, download the safety condition for the samples. *)
	sampleSafetyFields={flammable, acid, base, pyrophoric};

	(* Pull the relavant fields from the Model[StorageCondition]. *)
	storageConditionSafetyFields=Download[myStorageCondition, {Flammable, Acid, Base, Pyrophoric}, Cache -> Lookup[safeOptions, Cache]];

	(* Combine the safety fields from the sample and the storage condition. *)
	safetyFields={sampleSafetyFields, storageConditionSafetyFields};

	(* Transpose these fields so we get each Field in a list with the respsective field from the StorageCondition. *)
	transposedSafetyFields=Transpose[safetyFields];

	(* Run TrueQ on all booleans and nulls. This makes everything that is not True, False. *)
	trueQSafetyFields=transposedSafetyFields /. (x:BooleanP | Null :> TrueQ[x]);

	(* Make sure that these fields line up (they must either both be False or both be True). If they don't, throw an error. *)
	xOrFields=(Xor @@ #&) /@ trueQSafetyFields;

	(* If one of the fields didn't line up: *)
	If[MemberQ[xOrFields, True],
		(* Get the name of the field(s) that are different. *)
		differentFields=Pick[{"Flammable", "Acid", "Base", "Pyrophoric"}, xOrFields];

		(* Throw an error. *)
		Message[Error::InvalidStorageCondition, "with safety fields Flammable->"<>ToString[flammable]<>", Acid->"<>ToString[acid]<>", Base->"<>ToString[base]<>", Pyrophoric->"<>ToString[pyrophoric], ToString[myStorageCondition], ToString[differentFields]];

		(* Return False *)
		False,

		(* ELSE: Return True *)
		True
	]
];

(* Given a list of objects for which a storage condition needs to be checked. *)
ValidStorageConditionQ[mySamples:{ObjectP[{Object[Sample], Model[Sample]}]..}, myStorageCondition:ObjectP[Model[StorageCondition]], myOptions:OptionsPattern[]]:=Module[
	{safeOptions, safetyFields, transposedSafetyFields, trueQSafetyFields, xOrFields, differentFields,
		sampleSafetyFields, sampleSafetyFieldsCombined, storageConditionSafetyFields},

	(* Get the safe options. *)
	safeOptions=SafeOptions[ValidStorageConditionQ, myOptions];

	(* First, download the safety condition for the samples. *)
	sampleSafetyFields=Download[mySamples, {Flammable, Acid, Base, Pyrophoric}, Cache -> Lookup[safeOptions, Cache]] /. (x:BooleanP | Null :> TrueQ[x]);

	(* Transpose these fields and And them together. *)
	sampleSafetyFieldsCombined=(Or @@ #&) /@ Transpose[sampleSafetyFields];

	(* Pull the relavant fields from the Model[StorageCondition]. *)
	storageConditionSafetyFields=Download[myStorageCondition, {Flammable, Acid, Base, Pyrophoric}, Cache -> Lookup[safeOptions, Cache]];

	(* Combine the safety fields from the sample and the storage condition. *)
	safetyFields={sampleSafetyFieldsCombined, storageConditionSafetyFields};

	(* Transpose these fields so we get each Field in a list with the respsective field from the StorageCondition. *)
	transposedSafetyFields=Transpose[safetyFields];

	(* Run TrueQ on all booleans and nulls. This makes everything that is not True, False. *)
	trueQSafetyFields=transposedSafetyFields /. (x:BooleanP | Null :> TrueQ[x]);

	(* Make sure that these fields line up (they must either both be False or both be True). If they don't, throw an error. *)
	xOrFields=(Xor @@ #&) /@ trueQSafetyFields;

	(* If one of the fields didn't line up: *)
	If[MemberQ[xOrFields, True],
		(* Get the name of the field(s) that are different. *)
		differentFields=Pick[{"Flammable", "Acid", "Base", "Pyrophoric"}, xOrFields];

		(* Throw an error. *)
		Message[Error::InvalidStorageCondition, " with combined safety fields Flammable->"<>ToString[sampleSafetyFieldsCombined[[1]]]<>", Acid->"<>ToString[sampleSafetyFieldsCombined[[2]]]<>", Base->"<>ToString[sampleSafetyFieldsCombined[[3]]]<>", Pyrophoric->"<>ToString[sampleSafetyFieldsCombined[[4]]], ToString[myStorageCondition], ToString[differentFields]];

		(* Return False *)
		False,

		(* ELSE: Return True *)
		True
	]
];
