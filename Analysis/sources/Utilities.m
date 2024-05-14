(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)




(* ::Subsection::Closed:: *)
(*Numeric Utilities*)


(* ::Subsubsection::Closed:: *)
(*InvertData*)


InvertData[xy:{{_?NumericQ,_?NumericQ}..}]:=Module[{min,max},
	{min,max}=MinMax[xy[[;;,2]]];
	Transpose[{xy[[;;,1]],min-(xy[[;;,2]]-max)}]
];


(* ::Subsubsection::Closed:: *)
(*unpercent*)


unpercent[in_Quantity?PercentQ,xy_]:=Unitless[in,Percent]*(Max[xy[[;;,2]]]/100);
unpercent[in_,___]:=in;


(* ::Subsubsection::Closed:: *)
(*monotonicity*)


monotonicity[d:dataPts[_Integer,qPCR]]:=monotonicity[RawAmplificationCurve/.Download[d],RawAmplificationCurve/.Download@(PassiveReference/.Download[d])];
monotonicity[xy:CoordinatesP,Null]:=monotonicity[xy];
monotonicity[xy:CoordinatesP,ref:CoordinatesP]:=monotonicity[xy/ref];
monotonicity[xy:CoordinatesP]:=monotonicity[xy[[;;,2]]];
monotonicity[y:NVectorP]:=Module[{dy,dmax},
	dy=N@Total[Abs[Differences[y]]];
	If[dy===0.,Return[1.]];
	dmax=Max[y]-Min[y];
	1/(dy/dmax)
];
monotonicity[_]:=.5;


(* ::Subsubsection::Closed:: *)
(*LinearFunctionQ*)


DefineOptions[LinearFunctionQ,
	Options :> {
		{Log -> False, BooleanP, "If set to True, the function will allow the provided 'func' to be in the form of (a*Log[base,#]+b)&."}
	}];


LinearFunctionQ[f_Function,OptionsPattern[LinearFunctionQ]]:=Module[{log,base,slope,x},

	(* compute derivative of function *)
	slope = Simplify@If[OptionDefault[OptionValue[Log]],
		Quiet[D[Simplify@f[Exp[x]],x]],
		Quiet[D[f[x],x]]
	];

	(* check if slope is numeric and non-zero *)
	And[NumericQ[slope],!MatchQ[slope,0|0.]]

];

SetAttributes[LinearFunctionQ,Listable];


(* ::Subsection:: *)
(*Common packet fields*)


(* ::Subsubsection::Closed:: *)
(*analysisPacketStandardFieldsStart*)


(*
	Every analysis function packet contains these fields, which are constructed at the start of the function
*)
analysisPacketStandardFieldsStart[unresolvedOps_List]:={
	Author->Link[$PersonID],
	UnresolvedOptions->unresolvedOps
};


(* ::Subsubsection::Closed:: *)
(*analysisPacketStandardFieldsFinish*)


(*
	Every analysis function packet contains these fields, which are constructed at the end of the function
*)

analysisPacketStandardFieldsFinish[resolvedOps:Null]:=Null;

analysisPacketStandardFieldsFinish[resolvedOps_List]:={
	ResolvedOptions->resolvedOps
};


(* ::Subsubsection::Closed:: *)
(*inputToId*)


inputToId[obj: ObjectP[]] := obj;
inputToId[info: PacketP[]] := Lookup[info, Object];
inputToId[info: PacketP[]] := Lookup[info, Object];
inputToId[link: LinkP[]] := link[Object];
inputToId[_] := Null;



(* ::Subsection::Closed:: *)
(*List Manipulation*)


(* ::Subsubsection:: *)
(*subdivideList*)


subdivideList[list:{},divisions:{__Integer}]:= Table[{},Length[divisions]];

subdivideList[list_List,divisions:{__Integer}]:=
		FoldPairList[{Take[#1,#2],Drop[#1,#2]}&,list,divisions];

subdivideList[list_List,divisions:{}] := list;


(* ::Subsection::Closed:: *)
(*Uploading & Returning*)


(* ::Subsubsection::Closed:: *)
(*uploadAnalyzePackets*)

Clear[uploadAnalyzePackets];
uploadAnalyzePacketsNew[assoc:BatchAssociationP]:= Module[{out},
		out = uploadAnalyzePackets[assoc[Packet]];
		<|Result -> out, Batch->True|>
];


(*
	each analysis formatPackets function should return {{_Association..}(*primary*),{_Association...}(*secondary*)},
	then the list definition of analyze functions should call this on the mapped output of that guy
*)
uploadAnalyzePackets[allPackets:{{{(_Association|Null|$Failed)..}|Null|$Failed(*primary*),{(_Association|$Failed)...}(*secondary*)}..}] := Module[{
	ms, ns, primaryPackets, secondaryPackets, newPrimaryPackets, newSecondaryPackets,
	uploadBools, uploadPositions, newGroups, replacePartRules, returnPacketsFull,
	mtotal,ntotal, newObjects, newPackets, packetsToUpload,
	secondaryUploadPositions, primaryReplacementRules, secondaryReplacementRules
},

	If[MatchQ[Flatten[{allPackets}],{(Null|$Failed|<||>)..}],
		Return[allPackets]
	];

	(*
		Figure out which objects to upload based on the Upload option in ResolvedOptions field
		Need And@@ because each inner list is one analysis set.
		Any Null in the packet list get defaulted here to False
	*)
	uploadBools = And@@@Map[
		Lookup[Lookup[#,ResolvedOptions,{Upload->False}],Upload,False]&,
		Replace[allPackets[[;;,1]],(Null|$Failed)-><||>,{2}],
		{2}
	];

	(* if nothing being uploaded, return input *)
	If[MatchQ[uploadBools,{(False|Null)..}],
		Return[allPackets]
	];

	(* find the position of things we want to upload *)
	uploadPositions = Flatten[Position[uploadBools,True,{1}]];

	(* some things in secondar packet list will be empty (nothing to link) and can't get uploaded. *)
	(* need to account for those separately here *)
	secondaryUploadPositions = Intersection[
		Flatten[Position[allPackets[[;;,2]],_?(! MemberQ[#, <||> | Null | $Failed] &),{1},Heads->False]],
		uploadPositions
	];

	(* pull out only the things to upload based on position *)
	primaryPackets = Join@@allPackets[[uploadPositions,1]];
	secondaryPackets = Join@@allPackets[[secondaryUploadPositions,2]];

	(* get the sizes of everything so we can reconstruct after flattening *)
	ms=Length/@allPackets[[uploadPositions,1]];
	ns=Length/@allPackets[[secondaryUploadPositions,2]];

	(* sizes of all primary inserts, and all secondary inserts *)
	(* need this so we can separate primary from secondary after uploading the flat list *)
	mtotal=Length[primaryPackets];
	ntotal=Length[secondaryPackets];

	packetsToUpload = Join[primaryPackets,secondaryPackets];

	(* upload the primary and secondary packets together in one flat list *)
	newObjects = Upload[packetsToUpload,Verbose->True,ConstellationMessage -> Types[{Object[Analysis],Object[Simulation]}]];

	(* tmp error checking if something goes wrong *)
	If[!MatchQ[newObjects,{ObjectReferenceP[]..}],
		Return[$Failed];
	];

	(* substitute the new IDs back into the packets that will be returned *)
	newPackets = MapThread[Prepend[#2,Object->#1]&,{newObjects,packetsToUpload}];

	(* split the new packets back into primary and secondary *)
	newPrimaryPackets = newPackets[[;;mtotal]];
	newSecondaryPackets = newPackets[[mtotal+1;;mtotal+ntotal]];

	(* unflatten inserted back into original shape *)
	newPrimaryPackets = subdivideList[newPrimaryPackets,ms];
	newSecondaryPackets = subdivideList[newSecondaryPackets,ns];

	(*
		Don't do this... make separate part-replacement rules for primary and secondary,
		then swap them back in separately, to avoid problem when one is uploaded and other isn't
	*)
(*
	(* recombine the primary and secondary packets into pairs *)
	newGroups = MapThread[List,{newPrimaryPackets, newSecondaryPackets}];

	(* substitute the new inserted packets back into the original list based on upload positions *)
	replacePartRules = MapThread[Rule,{Flatten[uploadPositions],newGroups}];
	returnPacketsFull = ReplacePart[allPackets,replacePartRules];

	returnPacketsFull
*)

	(* swap back in the new packets and reformat into pairs *)
	primaryReplacementRules = MapThread[Rule[#1,#2]&,{Flatten[uploadPositions],newPrimaryPackets}];
	secondaryReplacementRules = MapThread[Rule[#1,#2]&,{Flatten[secondaryUploadPositions],newSecondaryPackets}];
	MapThread[List,
		{
		 ReplacePart[allPackets[[;;,1]],primaryReplacementRules],
		 ReplacePart[allPackets[[;;,2]],secondaryReplacementRules]
		}
	]

];


(*
	If base case has single analysis packet per set, then add a list at that level,
	then strip it off after uploading
*)
uploadAnalyzePackets[in:{{_Association|Null|$Failed,{_Association...}}..}] := Module[{out},
	out =  uploadAnalyzePackets[MapAt[List,in,{;;,1}]];
	If[MatchQ[out,Null|$Failed],
		out,
		MapAt[First,out,{;;,1}]
	]
];

(*
	If no secondary packets, and them and then remove after
*)
uploadAnalyzePackets[in:{(_Association|Null|$Failed)..}] := Module[{out},
	out =  uploadAnalyzePackets[Map[{#,{}}&,in]];
	If[MatchQ[out,Null|$Failed],
		out,
		out[[;;,1]]
	]
];

(*
	empty list case
*)
uploadAnalyzePackets[in:{}] := {};


(* ::Subsubsection::Closed:: *)
(*returnAnalyzeValue*)


returnAnalyzeValue[in:{{ListableP[_Association|$Failed|Null],{(_Association|$Failed|Null)...}}..}]:= Module[{},
	Map[returnAnalyzeValue[#]&,in]
];
returnAnalyzeValue[in:{primary:ListableP[_Association],secondary:{_Association...}}]:=Module[{
	resolvedOps, returnOp, returnAllOp
},
(* TODO: figure this out... every primary packet has resolved ops... do they always agree?? *)
	resolvedOps = Lookup[First[Flatten[{primary}]],ResolvedOptions,{Output->Null,OutputAll->False}];
	returnOp = Lookup[resolvedOps,Output,Packet];
	returnAllOp = Lookup[resolvedOps,OutputAll,False];
	returnAnalyzeValue[in,returnOp,returnAllOp]
];

returnAnalyzeValue[in:{primary:ListableP[Null|$Failed],secondary:{(Null|$Failed|<||>)...}}] := primary;

returnAnalyzeValue[in:{}] := {};


returnAnalyzeValue[in:{{(_Association|Null|$Failed)..}..}]:= Map[returnAnalyzeValue[#]&,in];
returnAnalyzeValue[in:{(_Association|Null|$Failed)..}]:= Map[returnAnalyzeValue[#]&,in];
returnAnalyzeValue[in:_Association]:=Module[{
	resolvedOps, returnOp, returnAllOp
},
	resolvedOps = Lookup[in,ResolvedOptions,{Output->Null,OutputAll->False}];
	returnOp = Lookup[resolvedOps,Output,Packet];
	returnAllOp = Lookup[resolvedOps,OutputAll,False];
	returnAnalyzeValue[in,returnOp,returnAllOp]
];
returnAnalyzeValue[in:(Null|$Failed)]:=in;

returnAnalyzeValue[in:(Null|$Failed), returnOp_,returnAllOp__]:= in;
returnAnalyzeValue[in:_Association, returnOp_,returnAllOp__]:= returnAnalyzeValue[{in,{}},returnOp,returnAllOp];

returnAnalyzeValue[in:{primary:ListableP[_Association],secondary:{_Association...}}, val:(Null|$Failed), _]:= val;
returnAnalyzeValue[in:{primary:ListableP[_Association],secondary:{_Association...}}, Packet, True]:= in;
returnAnalyzeValue[in:{primary:ListableP[_Association],secondary:{_Association...}}, Object|Result, True]:= {Lookup[primary,Object], Lookup[secondary,Object]};
returnAnalyzeValue[in:{primary:ListableP[_Association],secondary:{_Association...}}, Packet|Result, False]:= primary;
returnAnalyzeValue[in:{primary:ListableP[_Association],secondary:{_Association...}}, Object, False]:= Lookup[primary,Object];
returnAnalyzeValue[in:{primary:ListableP[_Association],secondary:{_Association...}}, field:ListableP[FieldP[Types[{Object[Analysis], Object[Simulation]}],Output->Short]],_]:=
  Lookup[stripAppendReplaceKeyHeads[primary],field];



(* ::Subsubsection::Closed:: *)
(*stripAppendReplaceKeyHeads*)


stripAppendReplaceKeyHeads[assoc_Association]:=KeyMap[stripAppendReplaceHead,assoc];
stripAppendReplaceKeyHeads[assocs:{_Association..}]:=stripAppendReplaceKeyHeads/@assocs;
stripAppendReplaceKeyHeads[other_]:=other;

stripAppendReplaceHead[Append[f_]]:=f;
stripAppendReplaceHead[Replace[f_]]:=f;
stripAppendReplaceHead[f_]:=f;



(* ::Subsubsection::Closed:: *)
(*packetLookup*)


(*
	Allows you to lookup multiple fields whose keys might have Append or Replace wrapped around them
*)
packetLookup[packet_Association,fields_]:= Lookup[stripAppendReplaceKeyHeads[packet],fields];
packetLookup[packets:{_Association..},fields_]:= Lookup[stripAppendReplaceKeyHeads/@packets,fields];
packetLookup[packet_Association,fields_,default_]:= Lookup[stripAppendReplaceKeyHeads[packet],fields,default];
packetLookup[packets:{_Association..},fields_,default_]:= Lookup[stripAppendReplaceKeyHeads/@packets,fields,default];


(* ::Subsubsection::Closed:: *)
(* quietAndCollect *)

(* Use holds to prevent premature evaluation of input expression *)
SetAttributes[quietAndCollect,HoldAll];

(* Utility warning message for outputting saved messages*)
Warning::SystemMessages="`1`";

(* Run the input expression, returning the result of evaluating the expression, plus a string containing all messages that ran while doing so. *)
quietAndCollect[expression_]:=Module[{myStream,result,expressionMessages,output},
	(* Create a new stream to divert the messages to *)
	myStream=OpenWrite[];

	(* Divert messages to our newly created stream *)
	$Messages=Append[$Messages,myStream];

	(* Run the input expression *)
	result=expression;

	(* Store any messages thrown by expression in a String *)
	expressionMessages=ReadString[myStream[[1]]];

	(* Reset the default stream for messages *)
	$Messages=DeleteCases[$Messages,myStream];

	(* Close the stream we created to store messages *)
	Close[myStream];

	(* Format the output as {result, messages} *)
	output = {Quiet[result],expressionMessages};

	(* Return values *)
	output
];


(* ::Subsection::Closed:: *)
(*PHASE OUT*)


(* ::Subsubsection::Closed:: *)
(*objectOrLinkP*)


objectOrLinkP[]:=ObjectReferenceP[]|LinkP[];
objectOrLinkP[arg_]:=ObjectReferenceP[arg]|LinkP[arg];


(* ::Subsubsection:: *)
(*insertAndUpdateAnalyzePackets*)


(* ::Text:: *)
(*List input case*)


(*
	each analysis formatPackets function should return {{_Association..}(*primary*),{_Association...}(*secondary*),{_Association...}(*updates*)},
	then the list definition of analyze functions should call this on the mapped output of that guy
*)
insertAndUpdateAnalyzePackets[allPackets:{{{_Association..}|{Null}|Null(*primary*),{_Association...}(*secondary*),{_Association...}(*updates*)}..}] := Module[{
	ms,ns,primaryInsertPackets,secondaryInsertPackets,updatePackets,
	newPrimaryPackets,newSecondaryPackets,newUpdatePackets,
	uploadBools, uploadPositions, newGroups, replacePartRules,
	returnPacketsFull
},

	(*uploadBools = And@@@(Upload/.(ResolvedOptions/.allPackets[[;;,1]]));*)
	uploadBools = And@@@Map[
		Lookup[Lookup[#,ResolvedOptions,{Upload->False}],Upload,False]&,
		allPackets[[;;,1]],
		{2}
	];

	(* if nothing being uploaded, return input *)
	If[MatchQ[uploadBools,{False..}],
		Return[allPackets]
	];

	uploadPositions = Flatten[Position[uploadBools,True,{1}]];

	primaryInsertPackets = Join@@allPackets[[uploadPositions,1]];
	secondaryInsertPackets = Join@@allPackets[[uploadPositions,2]];
	updatePackets = Join@@allPackets[[uploadPositions,3]];

	ms=Length/@allPackets[[uploadPositions,1]];
	ns=Length/@allPackets[[uploadPositions,2]];

	{newPrimaryPackets,newSecondaryPackets,newUpdatePackets} = insertAndUpdateAnalyzePackets[{primaryInsertPackets,secondaryInsertPackets,updatePackets},True];

	newPrimaryPackets = subdivideList[newPrimaryPackets,ms];
	newSecondaryPackets = subdivideList[newSecondaryPackets,ns];

	(* reformat to match the original input shape *)
	newGroups = MapThread[List,{newPrimaryPackets, newSecondaryPackets, allPackets[[uploadPositions,3]]}];

	replacePartRules = MapThread[Rule,{Flatten[uploadPositions],newGroups}];

	returnPacketsFull = ReplacePart[allPackets,replacePartRules];

	returnPacketsFull

];



(* ::Text:: *)
(*single input case*)


(* add list then strip off if any packets are singleton *)
insertAndUpdateAnalyzePackets[in:{{_Association|Null,{_Association...},{_Association...}}..}] := Module[{out},
	out =  insertAndUpdateAnalyzePackets[MapAt[List,in,{;;,1}]];
	MapAt[First,out,{;;,1}]
];

(* do nothing if not uploading *)
insertAndUpdateAnalyzePackets[in:{{_Association..},{_Association...},{_Association...}}, informBool:False]:= in;

insertAndUpdateAnalyzePackets[primaryInsertPackets:{_Association..},secondaryInsertPackets:{_Association...},updatePackets:{_Association...}, informBool:(True|False)]:=
		insertAndUpdateAnalyzePackets[{primaryInsertPackets,secondaryInsertPackets,updatePackets}, informBool];

insertAndUpdateAnalyzePackets[primaryInsertPackets_Association,secondaryInsertPackets:{_Association...},updatePackets:{_Association...}, informBool:(True|False)]:=
		MapAt[First,insertAndUpdateAnalyzePackets[{{primaryInsertPackets},secondaryInsertPackets,updatePackets}, informBool],1];

(* upload, and cache bust, and print some stuff *)
insertAndUpdateAnalyzePackets[{primaryInsertPackets:{_Association..},secondaryInsertPackets:{_Association...},updatePackets:{_Association...}}, informBool:True] := Module[
	{newPackets,newPrimaryPackets,newSecondaryPackets,m,n},

	m=Length[primaryInsertPackets];
	n=Length[secondaryInsertPackets];

	(* insert new stuff *)
	newPackets = Download[
		Upload[
			Join[primaryInsertPackets,secondaryInsertPackets],
			Verbose->True
		],
		Cache->Download
	];

	(* update other things *)
	Upload[updatePackets];

	newPrimaryPackets = newPackets[[;;m]];

	newSecondaryPackets = newPackets[[m+1;;m+n]];

	{newPrimaryPackets, newSecondaryPackets, updatePackets}

];




(* ::Subsubsection::Closed:: *)
(*finalReturnNew*)


finalReturnNew[primaryObjects:{ObjectReferenceP[]..}, secondaryObjects:{ObjectReferenceP[]...}, updatePackets_, return_, returnAllBool_] := finalReturnNew[Download[primaryObjects],Download[secondaryObjects],updatePackets,return,returnAllBool];
finalReturnNew[primaryInsertPackets_, secondaryInsertPackets_, updatePackets_, Object, True] := {Lookup[primaryInsertPackets,Object],Lookup[secondaryInsertPackets,Object,{}],updatePackets[[;;,1]]};
finalReturnNew[primaryInsertPackets_, secondaryInsertPackets_, updatePackets_, Packet, True] := {primaryInsertPackets,secondaryInsertPackets,updatePackets};
finalReturnNew[primaryInsertPackets_, secondaryInsertPackets_, updatePackets_, Object, False] := Lookup[primaryInsertPackets, Object];
finalReturnNew[primaryInsertPackets_, secondaryInsertPackets_, updatePackets_, Packet, False] := primaryInsertPackets;
finalReturnNew[primaryInsertPackets_, secondaryInsertPackets_, updatePackets_, field: ListableP[FieldP[Types[Object[Analysis]],Output->Short]],returnAllBool_] := Module[{stripRelationsBool,out},
	out=Lookup[primaryInsertPackets,field];
	stripRelationsBool=True;
	If[stripRelationsBool,
		ReplaceAll[out,{link_Link:>link[Object]}], (* strip _relation wrapper off links *)
		out
	]
];



(* ::Subsubsection::Closed:: *)
(*returnAnalyzeValue *Old**)


returnAnalyzeValue[in:{{ListableP[_Association],{_Association...},{_Association...}}..}]:=Module[{},
    Map[returnAnalyzeValue[#]&,in]
	];

returnAnalyzeValue[in:{primary:ListableP[_Association],secondary:{_Association...},updates:{_Association...}}]:=Module[{
	resolvedOps, returnOp, returnAllOp
},
	(* TODO: figure this out... every primary packet has resolved ops... do they always agree?? *)
	resolvedOps = Lookup[First[Flatten[{primary}]],ResolvedOptions,{Output->Null,OutputAll->False}];
	{returnOp, returnAllOp} = Lookup[resolvedOps,{Output,OutputAll},{Packet, False}];
	returnAnalyzeValue[in,returnOp,returnAllOp]
];

returnAnalyzeValue[in:{primary:ListableP[_Association],secondary:{_Association...},updates:{_Association...}}, Null, _]:=
		Null;
returnAnalyzeValue[in:{primary:ListableP[_Association],secondary:{_Association...},updates:{_Association...}}, Packet, True]:=
    in;
returnAnalyzeValue[in:{primary:ListableP[_Association],secondary:{_Association...},updates:{_Association...}}, Object, True]:=
    {Lookup[primary,Object], Lookup[secondary,Object],Lookup[updates,Object]};
returnAnalyzeValue[in:{primary:ListableP[_Association],secondary:{_Association...},updates:{_Association...}}, Packet, False]:=
    primary;
returnAnalyzeValue[in:{primary:ListableP[_Association],secondary:{_Association...},updates:{_Association...}}, Object, False]:=
    Lookup[primary,Object];
returnAnalyzeValue[in:{primary:ListableP[_Association],secondary:{_Association...},updates:{_Association...}}, field:ListableP[FieldP[Types[Object[Analysis]],Output->Short]],_]:=Module[{},
	Lookup[primary,field]
];



(* ::Subsubsection::Closed:: *)
(*analyzeShareCore*)


analysisAppDefaultValue = True;

analyzeShareCore[f_, inList_, originalOps_List, useOutputAll_] := Module[
	{nextOps, wrapperApp, wrapper},
	nextOps = originalOps;
	wrapperApp[singleton_, index_] := Module[
		{tempOut, preOps},
		tempOut = Quiet @ Check[f[singleton, Sequence @@ Join[{App -> False, Upload -> False}, nextOps]], "XTT"];
		tempOut = If[MatchQ[tempOut, "XTT"], f[singleton, Sequence @@ originalOps, Index -> index], f[singleton, Sequence @@ Join[{Index -> index}, nextOps]]];
		If[MatchQ[tempOut, $Failed | $Canceled], Throw[tempOut, "ExitFlag"]; Return[tempOut]];
		If[MatchQ[tempOut, Null], Return[tempOut]];
		preOps = Lookup[First[tempOut], ResolvedOptions];
		nextOps = If[MatchQ[Lookup[preOps, ApplyAll], True], preOps, originalOps];
		finalReturnNew[Sequence @@ tempOut, Lookup[preOps, Output], If[useOutputAll, Lookup[preOps, OutputAll], False]]
	];
	wrapper[singleton_, index_] := Module[
		{tempOut, preOps},
		tempOut = f[singleton, Sequence @@ originalOps, Index -> index];
		If[MatchQ[tempOut, $Failed | $Canceled], Throw[tempOut, "ExitFlag"]; Return[tempOut]];
		If[MatchQ[tempOut, Null], Return[tempOut]];
		preOps = Lookup[First[tempOut], ResolvedOptions];
		finalReturnNew[Sequence @@ tempOut, Lookup[preOps, Output], If[useOutputAll, Lookup[preOps, OutputAll], False]]
	];
	If[TrueQ[Lookup[originalOps, App, analysisAppDefaultValue]], Map[wrapperApp[inList[[#]], {#, Length[inList]}] &, Range[Length[inList]]], Map[wrapper[inList[[#]], {#, Length[inList]}] &, Range[Length[inList]]]]
];



(* ::Subsection:: *)
(*valid packet checking*)


(* ::Subsubsection:: *)
(*validAnalysisPacketQ*)


Options[validAnalysisPacketQ]={
	Round->None,
	NonNullFields -> {},
	NullFields -> {},
	ResolvedOptions -> {},
	Verbose->False
};

validAnalysisPacketQ[packet_,type_,exactFieldRules_,ops:OptionsPattern[]]:=Module[
	{f,requiredAnalysisFields},

	requiredAnalysisFields = {ResolvedOptions,UnresolvedOptions};
	f = analysisTypeToFunction[type];

	RunValidQTest[
		type,
		{
			analysisPacketValidPacketQ[packet,type]&,
			resolvedAnalysisOptionsTests[packet,type,f,OptionValue[ResolvedOptions]]&,
			analysisPacketNullFieldTests[packet,type,OptionValue[NullFields]]&,
			analysisPacketNonNullFieldTests[packet,type,requiredAnalysisFields,OptionValue[NonNullFields]]&,
			analysisPacketExactFieldTests[packet,type,exactFieldRules,OptionValue[Round]]&
		},
		OutputFormat->SingleBoolean,
		PassOptions[
			validAnalysisPacketQ,
			RunValidQTest,
			ops
		]
	]

];

resolvedAnalysisOptionsTests[packet_,type_,f_,resolvedOpRules_]:={
	Test["All options exist in ResolvedOptions:",
		Or[SameQ[ToString/@Sort[Lookup[packet,ResolvedOptions][[;;,1]]],Sort[Options[f][[;;,1]]]],
		SameQ[ToString/@Sort[Lookup[packet,ResolvedOptions][[;;,1]]],Sort[Options[ToExpression[ToString[f] <> "App"]][[;;,1]]]]],
		True
	],
	Test["ResolvedOptions rules match expected values:",
		MatchQ[Lookup[Lookup[packet,ResolvedOptions],resolvedOpRules[[;;,1]]],resolvedOpRules[[;;,2]]],
		True
	],
	Test["ResolvedOptions are all fully resolved (no Automatic values left):",
		MatchQ[DeleteCases[Lookup[packet,ResolvedOptions],Rule[Method,Automatic]|Rule[ReferencePeak,Automatic]][[;;,2]],{Except[Automatic]...}],
		True
	]
};

analysisPacketNonNullFieldTests[packet_,type_,alwaysNonNullFields_,extraNonNullFields_]:={
	Test["Required analysis fields all non-null:",
		Lookup[packet,alwaysNonNullFields],
		{Except[NullP|_Missing]...}
	],
	Test["Additional analysis fields all non-null:",
		Lookup[packet,extraNonNullFields],
		(*{Except[NullP|_Missing]...}*)
		{Except[NullP]...} (* tmp until Packet returns the computable fields *)
	]
};


analysisPacketNullFieldTests[packet_,type_,nullFields_]:={
	Test["Null fields contain Null values:",
		Lookup[packet,nullFields],
		(*{(NullP | {})...}*)
		{(NullP | {}|_Missing)...} (* tmp until Packet returns the computable fields *)
	]
};


analysisPacketExactFieldTests[packet_,type_,exactFieldRules_,round_]:=With[
	{comparisonFunc = resolveComparisonFunction[round]},
	{
	Test["Exact field values match expected:",
		comparisonFunc[Lookup[packet,exactFieldRules[[;;,1]]],exactFieldRules[[;;,2]]],
		True
	]
}];
resolveComparisonFunction[None|Infinity]:=MatchQ;
resolveComparisonFunction[n_Integer]:=RoundMatchQ[n,Force->True];


analysisPacketValidPacketQ[packet_,type_]:={
	Test["Packet passes ValidPacketFormatQ or ValidUploadQ:",
		(* handle both old style packets and new style upload packets with Replace/Append heads *)
		If[MatchQ[Keys[packet],{_Symbol..}],
			ValidPacketFormatQ[packet,type],
			ValidUploadQ[packet]
		],
		True
	]
};


(* ::Subsubsection::Closed:: *)
(*validAnalysisPacketP*)


Options[validAnalysisPacketP]=Options[validAnalysisPacketQ];
validAnalysisPacketP[type_Object,exactRules:{Rule[_Symbol|_Symbol[_Symbol],_]...},ops:OptionsPattern[]]:=
	PatternTest[_Association,Function[packet,validAnalysisPacketQ[packet,type,exactRules,ops]]];
validAnalysisPacketP[type_,exactRules:{Rule[_Symbol|_Symbol[_Symbol],_]...},ops:OptionsPattern[]]:=
	PatternTest[_List,Function[packet,validAnalysisPacketQ[packet,type,exactRules,ops]]];




(* ::Subsubsection::Closed:: *)
(*analysisTypeToFunction*)


analysisTypeToFunction[analysis[fam_]]:=ToExpression["Analyze"<>ToString[fam]];
analysisTypeToFunction[Object[Analysis,fam_]]:=ToExpression["Analyze"<>ToString[fam]];
(*In the case of subclass of an analysis object, e.g. Object[Analysis, MeltingPoint, DynamicLightScattering], only MeltingPoint will be extracted. *)
analysisTypeToFunction[Object[Analysis,fam_, ___]]:=ToExpression["Analyze"<>ToString[fam]];


(* ::Subsection::Closed:: *)
(*shared resolution*)


(* ::Subsubsection::Closed:: *)
(*resolveStandardCurvePacket*)


(* given fit object, just pull the packet *)
resolveStandardCurvePacket[obj:ObjectP[Object[Analysis,Fit]],safeOps_List]:={Download[obj],obj};

(* given something that couldn't resolve, throw an error *)
resolveStandardCurvePacket[Automatic|Null,safeOps_List]:=Module[{},
	{Null,Null}
];



(* given fit arguments, do fit and return packet *)
resolveStandardCurvePacket[fitArgs_,safeOps_List]:=Module[{packet,fitID},

	(* create a fit packet, but don't Upload it yet *)
	packet = AnalyzeFit[fitArgs,Lookup[safeOps,StandardCurveFitType],Sequence@@Lookup[safeOps,StandardCurveFitOptions],Upload->False];

	(* if something went wrong with the fit *)
	If[MatchQ[packet,Null|$Failed|$Canceled],
		Return[{packet,Null}]
	];

	(* Object rule not present anymore by default, so explicitly add *)
	{packet,fitArgs}
];



(* ::Subsubsection::Closed:: *)
(*resolveInformOption*)


resolveInformOption[uploadOption_,outputOption:Preview,functionName_]:=False;
resolveInformOption[uploadOption_,outputOption_,functionName_]:=resolveInformOption[uploadOption,functionName];
(* only allow informing if user is logged in *)
resolveInformOption[False,functionName_]:=False;
resolveInformOption[False,functionName_]:=False;
resolveInformOption[True,functionName_]:=If[
	MatchQ[$PersonID,ObjectP[Object[User]]],
	True,
	(
		Message[functionName::UnknownUser];
		False
	)
];



(* ::Subsubsection:: *)
(*safeAnalyzeOptions*)


(*
	Get the full list of options, with values coming from the following order of precedence:
		1) explicitly specified options
		2) Options option
		3) defaults
	Cannot just do this resolution after doing SafeOptions, because SafeOptions destroys the trace of what was user-specified
*)

(* pull Options option and pass it through *)
safeAnalyzeOptions[f_,unresolvedOps_List]:=
	Module[{key},
		key = If[MemberQ[First /@ unresolvedOps, Template], Template, Options];
		safeAnalyzeOptions[f, unresolvedOps, Lookup[unresolvedOps, key, Null]]
	];
(* if Options is object, pull ResolvedOptions field and pass it through *)
safeAnalyzeOptions[f_,unresolvedOps_List,optionsObject:ObjectP[Object[Analysis]]]:=
	safeAnalyzeOptions[f,unresolvedOps,Download[optionsObject,ResolvedOptions]];
(* get all options using user-specified with top priority, then things from Options object *)
safeAnalyzeOptions[f_,unresolvedOps_List,optionOps:{(_Rule|_RuleDelayed)...}]:=Module[
	{safeOps},

	safeOps = SafeOptions[
		f,
		(* get full list of "defaults" using things from Options, then swap in anything explicitly specified *)
		ToList[ReplaceRule[
			(* need Join here to prevent case where an option isn't in optionsOps (due to oldness or changing fields or whatever) but is in unresolvedOps *)
			Join[
				optionOps,
				ToExpression[#[[1]]] -> #[[2]] & /@ Options[f]
			],
			unresolvedOps,
			Append->False
		]]
	];
	(* User must be loggen in if Upload \[Rule] True *)
	ReplaceRule[safeOps, Upload -> resolveInformOption[Lookup[safeOps, Upload], f]]
];
(* for anything else, use SafeOptions as normal *)
safeAnalyzeOptions[f_,unresolvedOps_List,optionsOption_]:= Module[
	{safeOps},
	safeOps = SafeOptions[f,ToList[unresolvedOps]];
	ReplaceRule[safeOps, Upload -> resolveInformOption[Lookup[safeOps, Upload], f]]
];



(* ::Subsection::Closed:: *)
(*appMapWrapper*)


(* ::Subsubsection::Closed:: *)
(*appMapWrapper*)


(*
	f - map over 'argList'
	g - apply to output of 'f' to get resolved options
*)

appMapWrapper[f_,g_,argList_,originalOps_]:=Module[
	{opsPre,opsPost,index,appBool,error},

	(*
		need this because App option has not been defaulted yet and might not exist in unresolved list.
		If just matching on True, then cases with illegal values will not default to True
	*)
	appBool = Not[MatchQ[Lookup[originalOps,App,True],False]];

	opsPre = originalOps;

	If[appBool,
		(* Need Catch to escape from mapping loop if user clicks Cancel or window X *)
		Catch[
			(* MapIndexed to track how far through the list we are, which is displayed on the app *)
			MapIndexed[
				Module[{tmp},
					(*
					  Need Check here because it's possible that the re-used options are incompatible with the next data set,
					  and in that case we go back to original set of options
					*)
					Check[
						tmp=f[#,Join[{Index->{First[#2],Length[argList]}},opsPre]];,
						error=True;
					];

					(* Exit from the Map if Cancel or X clicked in app *)
					If[MatchQ[tmp,$Canceled|$Failed],
						Throw[tmp,"AppCancel"]
					];


					If[error,
						tmp = f[#,Join[{Index->{First[#2],Length[argList]}},originalOps]];
					];

					(* if $Canceled or $Failed is inside the output structure for some reason (should not intenionally happen) *)
					If[MatchQ[g[tmp],$Canceled|$Failed],
						Throw[g[tmp],"AppCancel"]
					];

					(* get the options from the app output *)
					opsPost = g[tmp];

					(* if ApplyAll, reuse the outputted ops *)
					opsPre = Which[
						MatchQ[opsPost,Null],
							opsPre,
						TrueQ[Lookup[opsPost,ApplyAll]],
							opsPost,
						True,
							opsPre
					];
					tmp
				]&,
				argList
			],
			"AppCancel"
		],

		(* if not in app, just map normally *)
		Map[
			f[#,originalOps]&,
			argList
		]
	]
];




(* ::Subsection::Closed:: *)
(*downloading*)


(* ::Subsubsection::Closed:: *)
(*downloadPeaksFromData*)


downloadPeaksFromData[data:ObjectP[Object[Data]],linkField_Symbol]:=Quiet[
	Check[
		(* Handle packets separately because packets with tons of peaks fields (>50, default pagination length) will have an unevaluated linkField *)
		(* Download is currently bugged for such cases, and will return $Failed *)
		If[MatchQ[data,_Association],
			With[{pkFieldPacket=Packet@@PeaksFields, peaksObj=LastOrDefault[Lookup[data,linkField],$Failed]},
				If[MatchQ[peaksObj,$Failed],
					Null,
					Download[peaksObj,pkFieldPacket]
				]
			],
			Download[data,
				Packet[linkField[[-1]][PeaksFields]]
			]
		],
		Null,
		{Download::Part}
	],
	{Download::Part}
];



(* ::Subsubsection::Closed:: *)
(*downloadObjects*)


downloadObjects[list_List,level_Integer?NonNegative]:=Module[
	{objs,pacs,objPacRules},
	objs = Cases[list,(ObjectReferenceP[]|LinkP[]),{level}];
	pacs = Download[objs];
	objPacRules = MapThread[Rule,{objs,pacs}];
	Replace[list,objPacRules,{level}]
];


(* ::Subsubsection::Closed:: *)
(*megaDownload*)


(*
	Given list (possibly nested to arbitrary depth), find unique stand-alone (i.e. not in packet fields) objects and links,
	download then in single call, then replace downloaded packets back into the list in their original positions.
*)
megaDownload[in_List]:=Module[{objectPositionRules,objects,packets,objectPacketRules,positionPacketRules},
	objectPositionRules = findObjects[in];
	objects = DeleteDuplicates[objectPositionRules[[;;,2]]];
	packets = Download[objects];
	objectPacketRules = MapThread[Rule,{objects,packets}];
	positionPacketRules = ReplaceAll[objectPositionRules,objectPacketRules];
	ReplacePart[in,positionPacketRules]
];
megaDownload[in:ObjectP[]]:=Download[in];

findObjects[in_]:= First[Last[Reap[findObjects[in,{}],"Download Me"]]];
findObjects[in:ObjectReferenceP[],pos_]:=Sow[pos->in,"Download Me"];
findObjects[in:LinkP[],pos_]:=Sow[pos->in,"Download Me"];
findObjects[list_List,pos_]:=MapIndexed[findObjects[#1,Append[pos,First[#2]]]&,list];
findObjects[_,_]:=Null;



(* ::Subsubsection::Closed:: *)
(*cachePackets*)


(*
	Given any input, find all objects and links, download them them in a single call,
	and return a flat list of packets that can be used for the Cache option to subsequent Download calls.
*)
cachePackets[in_]:=Module[{objs},
	objs = DeleteDuplicates[Flatten[findObjects[in]][[;;,2]]];
	Download[objs]
];




(* ::Subsubsection::Closed:: *)
(*peaksTranspose*)


peaksTranspose[pks_Association]:=Module[{n},
	n = Length[pks[Position]];
	Map[PadRight[#,n,Null]&,pks]
];


(* ::Subsubsection::Closed:: *)
(*checkTemporalLinks*)


Warning::InputContainsTemporalLinks="The following input(s), `1`, were detected to be temporal links. Information about these inputs at the specified temporal date will be downloaded for analysis.";

checkTemporalLinks[myInput_, myOptions_]:=Module[{temporalLinks,temporalLinkObjects},
	(* Get the temporal links. *)
	temporalLinks=DeleteDuplicates[Cases[{myInput, myOptions}, TemporalLinkP[], Infinity]];
	temporalLinkObjects=Download[temporalLinks, Object];
	(* Does this list include temporal links? *)
	If[Length[temporalLinks]>0,
		Message[Warning::InputContainsTemporalLinks, ECL`InternalUpload`ObjectToString[DeleteDuplicates[temporalLinkObjects]]];
	];
];


(* ::Subsection::Closed:: *)
(*Peaks patterns*)


(* ::Subsubsection::Closed:: *)
(*PeaksP*)


PeaksFields = {
	Position, Height, HalfHeightWidth, Area, PeakRangeStart, PeakRangeEnd, WidthRangeStart, WidthRangeEnd, BaselineIntercept, BaselineSlope,
	AsymmetryFactor, TailingFactor, RelativeArea, RelativePosition, PeakLabel, TangentWidth, TangentWidthLines, TangentWidthLineRanges,
	HalfHeightResolution, HalfHeightNumberOfPlates, TangentResolution, TangentNumberOfPlates, BaselineFunction,
	NMRSplittingGroup, NMROperatingFrequency, NMRNucleus, NMRChemicalShift, NMRNuclearIntegral, NMRMultiplicity, NMRJCoupling, NMRAssignment, NMRFunctionalGroup
};

