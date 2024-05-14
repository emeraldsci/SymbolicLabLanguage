(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*ObjectLog*)

ObjectLogOutputP=_Pane | ListableP[ObjectLogAssociationP] | Null;

ObjectLogAssociationP=AssociationMatchP[
	Association[
		(* The date of the modification *)
		Date -> _?DateObjectQ,

		(* The modified object, (either an object or a type) *)
		Object -> ObjectP[] | TypeP[],

		ObjectName -> _String | Null,

		(* The user who modified the object*)
		User -> ObjectP[Object[User]],

		Username -> _String | Null,

		(* The date that the object log was revised, currently not supported *)
		DateLogRevised -> Null,

		(* The user who revised the object log, currently not supported *)
		UserWhoRevisedLog -> Null,

		(* The type of event that triggered an object log *)
		LogKind -> _String | Null,

		(* A key value map of object fields that map to the updated values *)
		Fields -> _Association,

		(* A list of SLL transaction IDs *)
		Transactions -> _List | Null

	],
	(* Not all keys are required, as the revision history is optional *)
	RequireAllKeys -> False
];

DefineOptions[
	ObjectLog,
	Options :> {
		{OutputFormat -> Table, Association | Table, "Determine whether the function returns a table to display the data, or returns the output as a list of associations."}
	},
	SharedOptions :> {ObjectLogBaseOptions}
];

ObjectLog[input:(ListableP[ObjectP[]] | ListableP[TypeP[]] | PatternSequence[]), ops:OptionsPattern[]
]:=Module[{result, safeOps, outputFormat, tableHeaders, newOps, table, someMetaDataUnavailable},
	safeOps=SafeOptions[ObjectLog, ToList[ops], AutoCorrect->False];

	(* Return $Failed if options could not be defaulted *)
	If[MatchQ[safeOps, $Failed],
		Return[$Failed]
	];

	outputFormat=Lookup[safeOps, OutputFormat];
	newOps=DeleteCases[safeOps, (OutputFormat -> _)];

	If[MatchQ[outputFormat, Association],
		Return[ObjectLogAssociation[input, newOps]]
	];

	(* Get the ObjectLog and check if a SomeMetaDataUnavailable warning is thrown and if so set a flag for post processing  *)
	Quiet[
		Check[
			result=ObjectLogAssociation[input, newOps],
			someMetaDataUnavailable=True,
			ObjectLogAssociation::SomeMetaDataUnavailable
		],
		ObjectLogAssociation::SomeMetaDataUnavailable
	];

	If[MatchQ[result, $Failed], Return[$Failed]];
	If[MatchQ[result, Null], Return[Null]];

	tableHeaders=First[Keys[result]];

	(* If a SomeMetaDataUnavailable warning has been thrown insert the warning into the table *)
	result=If[TrueQ[someMetaDataUnavailable],
		insertSomeMetaDataUnavailableWarning[result,Lookup[newOps,Order]],
		result
	];

	(* Create the table *)
	table=PlotTable[Values[result], TableHeadings -> {Automatic, tableHeaders}, HorizontalScrollBar -> True];

	(* Post process the table for styling *)
	postProcessTable[table]
];

someMetaDataBelowUnavailableWarning="vvv Meta data on fields with multiple entries were not tracked until after 06/13/2023. Changes to Multiple Fields below this row will not return entries that were Null or a list of entirely Null. For instance, a field that contained {Value1, Null, Value 2} will compute as {Value1, Value2} and a field that contained {{Value1, Value2}, {Null, Null}, {Null, Value3}} will compute as {{Value1, Value2}, {Null, Value3}} vvv";
someMetaDataAboveUnavailableWarning="^^^ Meta data on fields with multiple entries were not tracked until after 06/13/2023. Changes to Multiple Fields above this row will not return entries that were Null or a list of entirely Null. For instance, a field that contained {Value1, Null, Value 2} will compute as {Value1, Value2} and a field that contained {{Value1, Value2}, {Null, Null}, {Null, Value3}} will compute as {{Value1, Value2}, {Null, Value3}} ^^^";

(* Insert an association of the form <|0->someMetaDataUnavailableWarning, 1-> SpanFromLeft, 2 -> SpanFromLeft, ...|> to objectLogRecordList
	 right below the last entry we have tracked historical meta data for *)
insertSomeMetaDataUnavailableWarning[objectLogRecordList:{_Association..},order:(NewToOld|OldToNew)]:=Module[{warningRowPosition,rowLength,warningRow},
	(* Find the position to insert the warning row *)
	warningRowPosition=If[MatchQ[order,NewToOld],
		First[FirstPosition[objectLogRecordList,_?Constellation`Private`dateBeforeHistoricalNullMetadataEnhancementQ]],
		Length[objectLogRecordList]-First[FirstPosition[Reverse[objectLogRecordList],_?Constellation`Private`dateBeforeHistoricalNullMetadataEnhancementQ]]+2
	];

	(* Short circuit if there is no need for a warning *)
	If[MatchQ[warningRowPosition, "NotFound"],
		Return[objectLogRecordList]
	];

	(* Create a dummy row as an association with unique but meaningless keys just so to fit in with the rest of the format *)
	warningRow=If[MatchQ[order,NewToOld],
		<|0->someMetaDataBelowUnavailableWarning|>,
		<|0->someMetaDataAboveUnavailableWarning|>
	];

	(* Pad the association with SpanFromLeft so that when the table is displayed all the columns in that row are merged *)
	rowLength=Length[First[objectLogRecordList]];
	warningRow=Merge[Flatten[{warningRow,Table[<|i->SpanFromLeft|>,{i,rowLength-1}]}],Total];

	(* Insert the warning row *)
	Insert[objectLogRecordList,warningRow,warningRowPosition]
];

(* Post processes the table for styling *)
postProcessTable[x_]:=ReplaceAll[x,
	{
		(* Make all SpanFromLeft cells functional *)
		Tooltip[Button[Style[SpanFromLeft, Rule[FontSize, 11]],OrderlessPatternSequence[
			CopyToClipboard[SpanFromLeft], Rule[Appearance, None],
			Rule[Method, "Queued"]]], "Copy value clipboard"] -> SpanFromLeft,
		(* Style the someMetaDataUnavailableWarning to stands out *)
		Style[warning:someMetaDataBelowUnavailableWarning|someMetaDataAboveUnavailableWarning, rest___] -> Style[warning, Red, rest]
	}
];