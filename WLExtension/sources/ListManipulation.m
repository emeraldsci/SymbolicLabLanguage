(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*FirstOrDefault*)

FirstOrDefault[expr_]:=FirstOrDefault[expr, Null];

FirstOrDefault[expr_, default_]:=If[Length[expr]>0,
	First[expr],
	default
];

(* ::Subsection::Closed:: *)
(*LastOrDefault*)

LastOrDefault[expr_]:=LastOrDefault[expr, Null];

LastOrDefault[expr_, default_]:=If[Length[expr]>0,
	Last[expr],
	default
];

(* ::Subsection::Closed:: *)
(*MostOrDefault*)

MostOrDefault[expr_]:=MostOrDefault[expr, Null];

MostOrDefault[expr_, default_]:=If[Length[expr]>0,
	Most[expr],
	default
];

(* ::Subsection::Closed:: *)
(*RestOrDefault*)

RestOrDefault[expr_]:=RestOrDefault[expr, Null];

RestOrDefault[expr_, default_]:=If[Length[expr]>0,
	Rest[expr],
	default
];

(* ::Subsubsection::Closed:: *)
(*PartitionRemainder*)

DefineOptions[
	PartitionRemainder,
	Options:>
		{
			{NegativePadding->0,_Integer?NonNegative,"The number of items that will be placed in the first sublist before partitioning the remaining items."}
		}
];

(* --- Core function --- *)
PartitionRemainder[x_List,n_Integer?Positive,ops:OptionsPattern[PartitionRemainder]]:=PartitionRemainder[x,n,n,ops];

PartitionRemainder[list_List,n_Integer?Positive,d_Integer?Positive,ops:OptionsPattern[PartitionRemainder]]:=Module[{safeOps},

	(* Safely extract the options *)
	safeOps=OptionDefaults[PartitionRemainder, ToList[ops]];

	(* If there's no negative paddding, partition as normal,
		if the negative padding exceeds the list size, just return the list wrapped up,
		if the negative padding does not exceed the list size, strip off the padding then partition, then fuse it back *)
	Which[
		("NegativePadding"/.safeOps)==0,Partition[list,n,d,{1,1},{}],
		("NegativePadding"/.safeOps)>=Length[list],{list},
		True,Module[{unpadded,partList},

			(* Drop anything in the negative padding from the front of the partition list *)
			unpadded=Drop[list,"NegativePadding"/.safeOps];

			(* Partition the list to maintain the remainder *)
			partList=Partition[unpadded,n,d,{1,1},{}];

			(* Return the partition list with the padding prepended *)
			Prepend[partList,Take[list,("NegativePadding"/.safeOps)]]
		]
	]
];


PartitionRemainder[x_List, numbers:{_Integer?Positive..}, ops:OptionsPattern[PartitionRemainder]]:=Map[PartitionRemainder[x, #, ops]&, numbers];

(* ::Subsubsection::Closed:: *)
(*LookupPath*)

(*
	We only want to worry about two broad kinds of data to lookup keys for:
		a) Things that take normal "lookups" by keys, so Associations and lists of Rule types, or
		b) Lists, which you "lookup" into it with Part
*)
LookupPathDataP:=_Association|{(_Rule|_RuleDelayed)...};
LookupPath[data:LookupPathDataP,path:{(_String|_Symbol|_Key|_Integer)..}]:=With[
	{item=Lookup[data, First[path]]},
	recurseLookupPath[item,path]
];
LookupPath[data:LookupPathDataP,path:{}]:=Missing["EmptyPath"];
LookupPath[data_List, path:{_Integer, (_String|_Symbol|_Key|_Integer)...}]:=With[
	{
		(* In the List/Part lookup case, fetching the item is slighly different in that we must deal with out of bound messages / errors*)
		item=If[
			Or[
				First[path]<0,
				First[path]>Length[data]
			],
			(* construct the List version of the missing head. *)
			Missing["IndexOutOfBounds", First[path]],
			(* take the index supplied in the path *)
			Part[data, First[path]]]
	},
	recurseLookupPath[item,path]
];
LookupPath[data_List,path:{}]:=Missing["EmptyPath"];

recurseLookupPath[item_,path_List]:=If[
(* If its missing or at the end of the path, return the element *)
	Or[MatchQ[item, _Missing], Length[Rest[path]]==0],
		item,
	(* else recursively go down the path *)
		LookupPath[item, Rest[path]]
];

LookupPath[data_?(!MatchQ[#, LookupPathDataP|_List]&), path:{(_String|_Symbol|_Key|_Integer)...}]:=With[{},
	Message[LookupPath::InnerPathDataError, data, FirstOrDefault[path]];
	$Failed
];

LookupPath::InnerPathDataError="Encountered 'non-lookable' data typed element `1` along path at key `2`";

(* ::Subsubsection::Closed:: *)
(*ToList*)

ToList[list_List]:=list;
ToList[expr___]:={expr};
