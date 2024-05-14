(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection:: *)
(*Types*)



(*All types*)
(* NOTE: This overload does not filter out example objects if you're not logged in as a developer. *)
Types[All->True]:=With[{
	allTypes=Join[
		Keys[
			ReleaseHold[
				registeredTypes
			]
		],
		{Object[], Model[]}
	]
},
	allTypes
];

(*
			Types
	Types needs to be fast, but can't be fully memoized because it depends on $PersonID, which can change during session.
	So we reference pre-computed lists (allKnownTypes, allPublicTypes, typeDescendentsAll, typeDescendentsPublic), which are populated by DefineObjectType
	We also have little wrappers that goes to the proper list based on $PersonID:  typeDescendents & allTypes
*)
allKnownTypes = {Object[], Model[]};
typeAndDescendents[type_] := {type};

devUserP = Object[User,Emerald,Developer,_];
isDevUser[devUserP] := True;
isDevUser[_] := False;

devTypeP = Object[Example,___];
isDevType[devTypeP] := True;
isDevType[_] := False;

(*
	filter out developer types if not logged in as developer
*)
visibleTypes[types_List] := If[
	isDevUser[$PersonID],
	types,
	DeleteCases[types, devTypeP]
];

(* Model[] and Object[] are not types defined by file, but are included here *)
Types[] := visibleTypes[ Join[
	allKnownTypes,
	{Object[], Model[]}
]];

Types[type_?TypeQ] := visibleTypes[ typeAndDescendents[type] ];

(* 
	given list of types, return a flat, duplicate-free, list of all subtypes
*)
Types[requestedTypes:{_?TypeQ...}] := visibleTypes[
	DeleteDuplicates[
		Catenate[ 
			Map[typeAndDescendents, requestedTypes] 
		] 
	]
];

(*
	All types which are either models or objects,
	but excluding Object[] and Model[]
*)
Types[head:Model | Object]:=DeleteCases[Types[head[]],head[]];

Types[_] := {}

(* ::Subsubsection::Closed:: *)
(*TypeQ*)

(*
	TypeQ[validType] is set to True by DefineObjectType
*)
TypeQ[Object[]]=True;
TypeQ[Model[]]=True;
TypeQ[_]:=False;


(* ::Subsubsection::Closed:: *)
(*TypeP*)


TypeP[]=PatternTest[
	typeP,
	TypeQ[#]&
];

TypeP[type:typeP]:=TypeP[type]=PatternTest[
	Append[type, ___Symbol],
	TypeQ[#]&
];

TypeP[types:{typeP...}]:=TypeP[types]=Apply[
	Alternatives,
	Map[
		TypeP,
		types
	]
];

TypeP[Model]=PatternTest[
	Model[__Symbol],
	TypeQ[#]&
];

TypeP[Object]=PatternTest[
	Object[__Symbol],
	TypeQ[#]&
];


(* ::Subsubsection::Closed:: *)
(*ObjectReferenceQ*)


(*Object/Model with only ID*)
ObjectReferenceQ[(Object | Model)[_String]]:=True;
(*Object/Model with type & ID*)
(* NOTE: This definition is favored after the first one so if we get here, we must have a type. *)
ObjectReferenceQ[object:(_Object|_Model)]:=TypeQ[Most[object]];
ObjectReferenceQ[_]:=False;



(* ::Subsubsection::Closed:: *)
(*ObjectReferenceP*)


ObjectReferenceP[]=PatternTest[
	objectP | modelP,
	ObjectReferenceQ[#]&
];

ObjectReferenceP[Model[]]=ObjectReferenceP[Model];

ObjectReferenceP[Object[]]=ObjectReferenceP[Object];

ObjectReferenceP[type:typeP]:=ObjectReferenceP[type]=PatternTest[
	Append[
		Append[
			type,
			___Symbol
		],
		_String
	],
	ObjectReferenceQ[#]&
];

ObjectReferenceP[types:{typeP...}]:=ObjectReferenceP[types]=Apply[
	Alternatives,
	Map[
		ObjectReferenceP,
		types
	]
];

ObjectReferenceP[Model]=PatternTest[
	modelP,
	ObjectReferenceQ[#]&
];

ObjectReferenceP[Object]=PatternTest[
	objectP,
	ObjectReferenceQ[#]&
];

ObjectReferenceP[object:objectP | modelP]:=PatternTest[
	objectP | modelP,
	SameObjectQ[#, object]&
];



(* ::Subsubsection::Closed:: *)
(*Fields*)


DefineOptions[
	Fields,
	Options :> {
		{Output -> Full, Full | Short, "Full returns the entire field, Short returns only the Symbol for each field."}
	}
];

Fields[types:{typeP...}, ops:OptionsPattern[]]:=Set[
	Fields[types, ops],
	Apply[
		Union,
		Map[
			Fields[#, ops]&,
			types
		]
	]
];
Fields[type:typeP, ops:OptionsPattern[]]:=Module[
	{definition, fieldDefinitions, fields},

	definition=LookupTypeDefinition[type];

	If[definition === $Failed,
		Return[{}]
	];

	fieldDefinitions=Lookup[definition, Fields];

	fields=Apply[
		Union,
		Append[
			Map[
				definitionToFields[type, #]&,
				fieldDefinitions
			],
			headerFields[type]
		]
	];

	(*If Output -> Short, return only the field symbols*)
	Set[
		Fields[type, ops],
		If[MatchQ[OptionDefault[OptionValue[Output]], Full],
			fields,
			DeleteDuplicates[fields[[All, 1]]]
		]
	]
];

(*Convert field definition to Object[__Symbol][_Symbol] forms*)
definitionToFields[type:typeP, field_Symbol -> definition_List]:=With[
	{class=Lookup[definition, Class]},

	Join[
		{type[field]},
		Switch[class,
			{___Rule}, (* named field *)
			Map[type[field, #] &, Keys[class]],

			_List, (*Indexed field*)
			Table[
				type[field, index],
				{index, 1, Length[class]}
			],

			_, (*Single or Multiple field*)
			{}
		]
	]
];

headerFields[type:typeP]:={
	type[ID],
	type[Type],
	type[Object]
};

Fields[head:Model | Object, ops:OptionsPattern[]]:=Apply[
	Union,
	Map[
		Fields[#, ops]&,
		Types[head]
	]
];

Fields[ops:OptionsPattern[]]:=Apply[
	Union,
	Map[
		Fields[#, ops]&,
		Types[]
	]
];

Fields[link:linkP, ops:OptionsPattern[]]:=Fields[
	linkToObject[link],
	ops
];
Fields[object:objectP | modelP, OptionsPattern[]]:=Module[
	{type, packet, fields},

	packet=Download[object];
	If[packet === $Failed,
		Return[{}]
	];
	type=Lookup[packet, Type];

	fields=Map[
		type[First[#]]&,
		Select[
			Normal[packet],
			!emptyFieldQ[type, #]&
		]
	];

	If[MatchQ[OptionDefault[OptionValue[Output]], Short],
		fields[[All, 1]],
		fields
	]
];

(*Computable fields and large multiple fields are non-empty*)
emptyFieldQ[type:typeP, _RuleDelayed]:=False;
(*Single fields which are Null are empty and multiple fields which are {} are empty*)
emptyFieldQ[type:typeP, Rule[field_Symbol, val_]]:=If[
	LookupTypeDefinition[type[field], Format] === Single,
	MatchQ[val, Null],
	MatchQ[val, {}]
];


(* ::Subsubsection::Closed:: *)
(*FieldQ*)

DefineOptions[FieldQ,
	Options :> {
		{Links -> False, BooleanP, "If True, nested link field patterns will be matched."},
		{Output -> Automatic, Automatic | Full | Short, "Full returns the entire field, Short returns only the Symbol for each field.  Automatic resolves to Short if Links->True, and otherwise resolves to Full."}
	}
];

(* no nested link field matching *)
FieldQ[in_, OptionsPattern[]]:=With[{val=Quiet[in]},
	nonLinkFieldQ[val, OptionValue[Output]]
]/;OptionValue[Links] === False;
(* separate function to get around holding breaking the input pattern matching *)
nonLinkFieldQ[field:_Symbol | (type:(Object | Model)[___Symbol])[_Symbol, Repeated[_Integer | _Symbol, {0, 1}]], output_]:=
	MemberQ[
		Fields[type, Output -> Replace[output, Automatic -> Full]],
		field
	];
nonLinkFieldQ[_, _]:=False;

(* yes nested links, but Output->Short *)
FieldQ[in_, OptionsPattern[]]:=downloadableFieldQ[in]/;And[OptionValue[Links] === True, OptionValue[Output] =!= Full];

(* error, can't handle links with full output *)
FieldQ[_, OptionsPattern[]]:=False/;And[OptionValue[Links] === True, OptionValue[Output] === True];

(* anything else *)
FieldQ[_, OptionsPattern[]]:=False;

SetAttributes[FieldQ, HoldFirst];

(* Authors definition for Constellation`Private`downloadableFieldQ *)
Authors[Constellation`Private`downloadableFieldQ]:={"scicomp", "brad"};

downloadableFieldQ[_[Field[_]]]:=False;
downloadableFieldQ[Verbatim[Length][Except[_Symbol]]]:=False;
downloadableFieldQ[Field[arg_]]:=downloadableFieldQ[arg];
downloadableFieldQ[head_[arg_]]:=And[downloadableFieldQ[head], downloadableFieldQ[arg]];
(* Part with one dim *)
downloadableFieldQ[Verbatim[Part][arg_, _Symbol | _Integer | All]]:=downloadableFieldQ[arg];
(* Part with two dims *)
downloadableFieldQ[Verbatim[Part][arg_, _Symbol | _Integer | All, _Integer | Except[All, _Symbol]]]:=downloadableFieldQ[arg];
downloadableFieldQ[Verbatim[Part][arg_, _Symbol, _Integer]]:=downloadableFieldQ[arg];
(*  *)
downloadableFieldQ[_Symbol]:=True;
downloadableFieldQ[Field[arg_]]:=downloadableFieldQ[arg];
downloadableFieldQ[_]:=False;
SetAttributes[downloadableFieldQ, HoldFirst];




(* ::Subsubsection::Closed:: *)
(*FieldP*)


DefineOptions[
	FieldP,
	SharedOptions :> {Fields}
];

FieldP[ops:OptionsPattern[]]:=Set[
	FieldP[ops],
	If[OptionDefault[OptionValue[Output]] === Short,
		PatternTest[
			_Symbol,
			MemberQ[Fields[ops], #]&
		],
		PatternTest[fieldP, FieldQ]
	]
];

FieldP[type:typeP, ops:OptionsPattern[]]:=Set[
	FieldP[type, ops],
	If[OptionDefault[OptionValue[Output]] === Short,
		PatternTest[
			_Symbol,
			MemberQ[Fields[type, ops], #]&
		],
		PatternTest[
			type[_Symbol, Repeated[_Integer | _Symbol, {0, 1}]],
			FieldQ
		]
	]
];

FieldP[types:{typeP...}, ops:OptionsPattern[]]:=Set[
	FieldP[types, ops],
	If[OptionDefault[OptionValue[Output]] === Short,
		PatternTest[
			_Symbol,
			MemberQ[Fields[types, ops], #]&
		],
		With[
			{heads=Alternatives @@ types},
			PatternTest[
				heads[_Symbol, Repeated[_Integer | _Symbol, {0, 1}]],
				FieldQ
			]
		]
	]
];

FieldP[head:Model | Object, ops:OptionsPattern[]]:=Set[
	FieldP[head, ops],
	If[OptionDefault[OptionValue[Output]] === Short,
		PatternTest[
			_Symbol,
			MemberQ[Fields[head, ops], #]&
		],
		PatternTest[
			head[__Symbol][_Symbol, Repeated[_Integer | _Symbol, {0, 1}]],
			FieldQ
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*LinkP*)
Authors[LinkP]:={"platform"};
Authors[TemporalLinkP]:={"platform"};

DefineOptions[
	LinkP,
	Options :> {
		{IncludeTemporalLinks -> False, False | True, "False does not include Temporal Links in the pattern, whilst when True,
		temporal links of the same pattern also match."}
	}
];

(* Explicit empty-list case is necessary to disambiguate {} input from OptionsPattern[] *)
LinkP[{}, ops:OptionsPattern[]]:=Alternatives[];

(*LinkP*)
LinkP[ops:OptionsPattern[]]:=LinkP[ops]=With[
	{temporalArg=If[OptionDefault[OptionValue[LinkP, IncludeTemporalLinks]], _?DateObjectQ, Nothing]},
	optionalArgsP[Link[ObjectReferenceP[]], {_Symbol, _Integer | _Symbol, _String, temporalArg}]
];
LinkP[head:Model | Object, ops:OptionsPattern[]]:=LinkP[head, ops]=With[
	{temporalArg=If[OptionDefault[OptionValue[LinkP, IncludeTemporalLinks]], _?DateObjectQ, Nothing]},
	optionalArgsP[Link[ObjectReferenceP[head]], {_Symbol, _Integer | _Symbol, _String, temporalArg}]
];
LinkP[types:ListableP[TypeP[]], ops:OptionsPattern[]]:=LinkP[types, ops]=With[
	{temporalArg=If[OptionDefault[OptionValue[LinkP, IncludeTemporalLinks]], _?DateObjectQ, Nothing]},
	optionalArgsP[Link[ObjectReferenceP[ToList[types]]], {_Symbol, _Integer | _Symbol, _String, temporalArg}]
];
LinkP[types:ListableP[TypeP[]], fieldSymbols:ListableP[_Symbol], ops:OptionsPattern[]]:=LinkP[types, fieldSymbols, ops]=With[
	{temporalArg=If[OptionDefault[OptionValue[LinkP, IncludeTemporalLinks]], _?DateObjectQ, Nothing]},
	optionalArgsP[
		Link[
			ObjectReferenceP[ToList[types]],
			Apply[
				Alternatives,
				ToList[fieldSymbols]
			]
		],
		{_String, temporalArg}
	]
];
LinkP[types:ListableP[TypeP[]], fieldSymbols:ListableP[_Symbol], indices:ListableP[_Integer | _Symbol], ops:OptionsPattern[]]:=LinkP[types, fieldSymbols, indices, ops]=With[
	{temporalArg=If[OptionDefault[OptionValue[LinkP, IncludeTemporalLinks]], _?DateObjectQ, Nothing]},
	optionalArgsP[
		Link[
			ObjectReferenceP[ToList[types]],
			Apply[
				Alternatives,
				ToList[fieldSymbols]
			],
			Apply[
				Alternatives,
				ToList[indices]
			]
		], {_String, temporalArg}]
];

LinkP[fields:ListableP[FieldP[]], ops:OptionsPattern[]]:=LinkP[fields, ops]=Apply[
	Alternatives,
	Map[
		With[{index=fieldToPart[#]},
			If[!FailureQ[index],
				LinkP[fieldToType[#], fieldToSymbol[#], index, ops],
				LinkP[fieldToType[#], fieldToSymbol[#], ops]
			]
		]&,
		ToList[fields]
	]
];

(*Specific Objects*)

sameObjectsP[objects:ListableP[ObjectReferenceP[]]]:=Apply[
	Alternatives,
	sameObjectP /@ ToList[objects]
];
sameObjectP[obj:(head:(Object | Model))[args__Symbol, id_String?(StringStartsQ[#, "id:"]&)]]:=Alternatives[
	obj,
	PatternTest[
		head[args, _String?(! StringStartsQ[#, "id:"] &)],
		SameObjectQ[#, obj]&
	]
];
sameObjectP[obj:objectP | modelP]:=Alternatives[
	obj,
	_?(SameObjectQ[#, obj]&)
];

LinkP[objects:ListableP[ObjectReferenceP[]], ops:OptionsPattern[]]:=LinkP[objects, ops]=With[
	{temporalArg=If[OptionDefault[OptionValue[LinkP, IncludeTemporalLinks]], _?DateObjectQ, Nothing]},
	optionalArgsP[Link[sameObjectsP[objects]], {_Symbol, _Integer | _Symbol, _String, temporalArg}]
];
LinkP[objects:ListableP[ObjectReferenceP[]], fieldSymbols:ListableP[_Symbol], ops:OptionsPattern[]]:=LinkP[objects, fieldSymbols, ops]=With[
	{temporalArg=If[OptionDefault[OptionValue[LinkP, IncludeTemporalLinks]], _?DateObjectQ, Nothing]},
	optionalArgsP[Link[
		sameObjectsP[objects],
		Apply[Alternatives, ToList[fieldSymbols]]
	], {_String, temporalArg}]
];
LinkP[objects:ListableP[ObjectReferenceP[]], fieldSymbols:ListableP[_Symbol], indices:ListableP[_Integer | _Symbol], ops:OptionsPattern[]]:=LinkP[objects, fieldSymbols, indices, ops]=With[
	{
		temporalArg=If[OptionDefault[OptionValue[LinkP, IncludeTemporalLinks]], _?DateObjectQ, Nothing],
		linkPattern=Link[
			sameObjectsP[objects],
			Apply[
				Alternatives,
				ToList[fieldSymbols]
			],
			Apply[
				Alternatives,
				ToList[indices]
			]]
	},
	(* append the date pattern to it only if the option specifies so*)
	If[temporalArg, Append[linkPattern, _?DateObject], linkPattern]
];


(* ::Subsubsection::Closed:: *)
(*TemporalLinkP*)

(*TemporalLinks are just a subset of Links*)
TemporalLinkP[inputs___]:=LinkP[inputs, IncludeTemporalLinks -> True]?linkHasDateQ;


TemporalLinkDate[link:TemporalLinkP[]]:=Last[link];

(* Get second to last component, if it is a string then that is the id, else there is no ID and return Null*)
LinkID[link:TemporalLinkP[]]:=With[{potentialID=Last[Most[link]]},
	If[MatchQ[potentialID, _String], potentialID, Null]
];

LinkID[link:LinkP[IncludeTemporalLinks -> False]]:=With[{potentialID=Last[link]},
	If[MatchQ[potentialID, _String], potentialID, Null]
];

RemoveLinkID[link:LinkP[IncludeTemporalLinks -> False]]:=If[linkHasIdQ[link], Most[link], link];
(* Strip off the date and try again *)
RemoveLinkID[tlink:TemporalLinkP[]]:=Append[RemoveLinkID[Most[tlink]], TemporalLinkDate[tlink]];
RemoveLinkID[link:Null]:=Null;

(*
	This helper function is mainly because First[] and Last[] are ugly and risky code choices.
	Links should be abstracted away. This is useful for stable code if the link structure changes in the future.
*)

LinkedObject[link:LinkP[IncludeTemporalLinks -> True]]:=First[link];

(* ::Subsubsection::Closed:: *)
(*FieldReferenceP*)


fieldReferenceToType[(head:Object | Model)[typeSymbols:Repeated[_Symbol, {1, 5}], _String, _Symbol, Repeated[_Integer, {0, 1}]]]:=head[
	typeSymbols
];

FieldReferenceP[]:=PatternTest[
	fieldReferenceP,
	FieldQ[fieldReferenceToField[#]]&
];

FieldReferenceP[types:TypeP[] | {TypeP[]...}]:=PatternTest[
	fieldReferenceP,
	MemberQ[
		Types[ToList[types]],
		fieldReferenceToType[#]
	]&
];

FieldReferenceP[types:TypeP[] | {TypeP[]...}, fields:_Symbol | {___Symbol}]:=PatternTest[
	fieldReferenceP,
	And[
		MemberQ[
			Types[ToList[types]],
			fieldReferenceToType[#]
		],
		MemberQ[
			ToList[fields],
			fieldReferenceToSymbol[#]
		]
	]&
];

FieldReferenceP[types:TypeP[] | {TypeP[]...}, fields:_Symbol | {___Symbol}, indices:_Integer | {___Integer}]:=PatternTest[
	fieldReferenceP,
	And[
		MemberQ[
			Types[ToList[types]],
			fieldReferenceToType[#]
		],
		MemberQ[
			ToList[fields],
			fieldReferenceToSymbol[#]
		],
		MemberQ[
			ToList[indices],
			fieldReferenceToColumn[#]
		]
	]&
];


(* ::Subsubsection::Closed:: *)
(*PacketP*)


uploadOperation=(Append | Replace | Erase | EraseCases | Transfer)[_Symbol] | _Symbol;


uploadRule=(Rule | RuleDelayed)[uploadOperation, _];

PacketP[]=KeyValuePattern[(Type -> TypeP[]) | (Object -> ObjectReferenceP[])];


PacketP[object:objectP | modelP, fields:uploadOperation | {uploadOperation...}:{}]:=PacketP[object, fields]=Module[
	{objectPattern, typePattern, allFields, fieldRules},

	objectPattern=ObjectReferenceP[object];
	typePattern=TypeP[objectToType[object]];
	allFields=Append[ToList[fields], Object];


	fieldRules=Replace[
		allFields,
		{
			Object -> (Object -> objectPattern),
			Type -> (Type -> typePattern),
			sym:_Symbol -> ( (Append | Replace | Erase | EraseCases | Transfer)[sym] | sym ) -> _,
			op:_ -> (op -> _)
		},
		{1}
	];

	packetP[typePattern, objectPattern, fieldRules]
];

PacketP[
	type:Object | Model | typeP | {typeP...},
	fields:uploadOperation | {uploadOperation...}:{}
]:=PacketP[type, fields]=Module[
	{changePacketRules, objectPattern, typePattern, fieldRules},

	objectPattern=ObjectReferenceP[type];
	typePattern=TypeP[type];

	changePacketRules={
		Object -> (Object -> objectPattern),
		Type -> (Type -> typePattern),
		sym:_Symbol -> ( (Append | Replace | Erase | EraseCases | Transfer)[sym] | sym ) -> _,
		op:_ -> (op -> _)
	};

	fieldRules=Replace[ToList[fields], changePacketRules, {1}];

	packetP[typePattern, objectPattern, fieldRules]
];

packetP[typePattern:_, objectPattern:_, rules:{_Rule...}]:=With[
	{
		pattern=If[!KeyMemberQ[rules, Type | Object],
			Append[rules, (Type -> typePattern) | (Object -> objectPattern)],
			rules
		]
	},

	KeyValuePattern[pattern]
];


(* ::Subsubsection::Closed:: *)
(*ObjectQ*)


(*Object/Model with only ID*)
ObjectQ[(Object | Model)[_String]]:=True;
(*Object/Model with type & ID*)
ObjectQ[object:ObjectReferenceP[]]:=TypeQ[Most[object]];
(* links *)
ObjectQ[link:LinkP[IncludeTemporalLinks -> True]]:=True;
(* packets *)
ObjectQ[packet:PacketP[]]:=True;
ObjectQ[_]:=False;


(* ::Subsubsection:: *)
(*ObjectP*)


ObjectP[]=Alternatives[
	ObjectReferenceP[],
	LinkP[IncludeTemporalLinks -> True],
	PacketP[]
];

ObjectP[obj:objectP | modelP, fields:{___Symbol} | _Symbol:{}]:=ObjectP[obj, fields]=With[
	{
		type=objectToType[obj],
		id=objectToId[obj]
	},

	Alternatives[
		ObjectReferenceP[obj],
		LinkP[obj, IncludeTemporalLinks -> True],
		PacketP[obj, fields]
	]
];

ObjectP[link:linkP, fields:{___Symbol} | _Symbol:{}]:=ObjectP[link, fields]=ObjectP[linkToObject[link], fields];

ObjectP[type:typeP | Model | Object, fields:{___Symbol} | _Symbol:{}]:=ObjectP[type, fields]=Alternatives[
		ObjectReferenceP[type],
		LinkP[type, IncludeTemporalLinks -> True],
		PacketP[type, fields]
	];


(* mixed list case maps *)
ObjectP[types:{(typeP | Model | Object | objectP | modelP | linkP)...}, fields:{___Symbol} | _Symbol:{}]:=ObjectP[types, fields]=
	Apply[Alternatives,
		Map[ObjectP[#, fields]&,
			types
		]
	];


(* ::Subsubsection:: *)
(*SameObjectQ*)


SameObjectQ[]:=True;
SameObjectQ[$Failed | ObjectP[]]:=True;
SameObjectQ[$Failed, $Failed..]:=False;
(*Short circuit if all inputs are literally identical*)
SameObjectQ[(obj:ObjectP[])..]:=True;

SameObjectQ[inputs:ReferenceWithIdP...]:=
	SameQ[inputs];

SameObjectQ[inputs:($Failed | ObjectP[])..]:=With[
	{
		references=Quiet[
			Download[{inputs}, Object, Verbose -> False],
			{Download::ObjectDoesNotExist}
		]
	},

	And[
		SameQ @@ references,
		Not[MemberQ[references, $Failed]]
	]
];
SameObjectQ[__]:=False;

(* ::Subsubsection:: *)
(*ObjectIDQ*)
ObjectIDQ[id_String]:=StringMatchQ[id,ObjectIDStringP];

ObjectIDQ[_]:=False;

(* ::Subsubsection:: *)
(*ObjectIDStringP*)
ObjectIDStringP="id:"~~WordCharacter..;

(* ::Subsubsection:: *)
(*ObjectIDP*)
ObjectIDP:=_?ObjectIDQ;


Authors[BigQuantityArrayP]:={"platform"};

Authors[LinkP]:={"platform"};
Authors[TemporalLinkP]:={"platform"};
Authors[LinkID]:={"platform"};
Authors[TemporalLinkDate]:={"platform"};
Authors[RemoveLinkID]:={"platform"};
Authors[LinkedObject]:={"platform"};

BigQuantityArrayP[units_List]:=
	QuantityMatrixP[units] | EmeraldFileP | ObjectP[Object[EmeraldCloudFile]];