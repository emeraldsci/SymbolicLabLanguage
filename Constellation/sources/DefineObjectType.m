(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

registeredTypes=Association[];

fieldSymbols=Association[
	"Type" -> Type,
	"ID" -> ID,
	"Model" -> Model,
	"Object" -> Object,
	"Link" -> Link,
	"Objects" -> Objects,
	"User" -> User,
	"Developer" -> Developer,
	(*"NewDateCreated" -> NewDateCreated,*)
	"CreatedBy" -> CreatedBy,
	"DateCreated" -> DateCreated,
	"Valid" -> Valid,
	"Published" -> Published
];

addSymbolLookup[definition:TypeDefinitionP]:=With[
	{
		typeSymbols=Cases[
			Lookup[definition, Type],
			_Symbol,
			{1}
		],
		definitionFieldSymbols=Union @@ Map[
			fieldDefinitionSymbols,
			Lookup[definition, Fields,{}]
		]
	},

	AppendTo[
		fieldSymbols,
		Map[
			SymbolName[#] -> #&,
			Join[
				definitionFieldSymbols,
				typeSymbols
			]
		]
	]
];

fieldDefinitionSymbols[field_Symbol -> definition_List]:=With[
	{class=Lookup[definition, Class]},

	Append[
		If[MatchQ[class, {__Rule}],
			class[[All, 1]],
			{}
		],
		field
	]
];

(* named field *)
defaultTypeFields[(field:_Symbol) -> definition:KeyValuePattern[Class -> (class:{_Rule..})]]:=
	field -> Normal[<|
		Units -> Map[# -> None&, Keys[class]],
		Relation -> Map[# -> Null&, Keys[class]],
		definition
	|>];

(* indexed field *)
defaultTypeFields[(field:_Symbol) -> definition:KeyValuePattern[Class -> (class:{Except[_Rule]...})]]:=
	field -> Normal[<|
		Units -> Table[None, Length[class]],
		Relation -> Table[Null, Length[class]],
		definition
	|>];

(* Single field *)
defaultTypeFields[(field:_Symbol) -> definition:KeyValuePattern[Class -> Except[_List]]]:=
	field -> Normal[<|Units -> None, Relation -> Null, definition|>];

(* Computed, and other strange fields *)
defaultTypeFields[definition:(_Symbol -> Except[KeyValuePattern[Class -> _]])]:=
	definition;


addAutobuiltPatterns[(field:_Symbol) -> definition_]:=If[KeyExistsQ[definition, PatternDescription],
	field -> definition,
	field -> Append[
		definition,
		With[{insertMe=Extract[Association@definition, Key[Pattern], Hold]},
			PatternDescription -> patternAutobuilder[insertMe]
		]
	]
];


(* ::Subsubsection:: *)
(*patternAutobuilder*)


patternAutobuilder[heldPattern:Hold[list_List]]:=patternAutobuilder[Extract[heldPattern, {1, #}, Hold]]& /@ Range[Length[list]];

patternAutobuilder[heldPattern_]:=Switch[heldPattern,
	(* Link *)
	Verbatim[Hold[_Link]],
	"A link to a valid object in Constellation.",
	(* Enumeration of quantity patterns. *)
	Hold[Verbatim[Alternatives][(_GreaterP | _GreaterEqualP | _LessP | _LessEqualP | _RangeP)..]],
	"Enumeration must be one of "<>ToString[List @@ ReleaseHold[heldPattern /. {x:(GreaterP | GreaterEqualP | LessP | LessEqualP | RangeP) :> ToString[x]}]]<>".",
	(* Enumeration. *)
	Hold[Verbatim[Alternatives][__]],
	"Enumeration must be one of "<>ToString[List @@ ReleaseHold[heldPattern]]<>".",
	(* Held enumeration. *)
	_?(MatchQ[ReleaseHold[#], Verbatim[Alternatives][__]]&),
	"Enumeration must be one of "<>ToString[List @@ ReleaseHold[heldPattern]]<>".",
	Verbatim[Hold[_?DateObjectQ]],
	"A valid date.",
	Verbatim[Hold[ColorP]] | Verbatim[Hold[_?ColorQ]],
	"A valid color.",
	Verbatim[Hold[ObjectP[]]],
	"Avalid object of any type.",
	Hold[Verbatim[ObjectP][_]],
	"A valid object of type "<>ToString[Extract[heldPattern, {1, 1}]]<>".",
	(* RangeP[Min, Max, Increment], by default is include on both sides *)
	Hold[RangeP[_, _, _]] | Hold[RangeP[_, _, _, Inclusive -> All]],
	"A number greater than or equal to "<>ToString[Extract[heldPattern, {1, 1}]]<>" and less than or equal to "<>ToString[Extract[heldPattern, {1, 2}]]<>" in increments of "<>ToString[Extract[heldPattern, {1, 3}]]<>".",

	(* RangeP[Min, Max, Increment, Inclusive\[Rule]Left] *)
	Hold[RangeP[_, _, _, Inclusive -> Left]],
	"A number greater than or equal to "<>ToString[Extract[heldPattern, {1, 1}]]<>" and less than "<>ToString[Extract[heldPattern, {1, 2}]]<>" in increments of "<>ToString[Extract[heldPattern, {1, 3}]]<>".",

	(* RangeP[Min, Max, Increment, Inclusive\[Rule]Right] *)
	Hold[RangeP[_, _, _, Inclusive -> Right]],
	"A number greater than "<>ToString[Extract[heldPattern, {1, 1}]]<>" and less than or equal to "<>ToString[Extract[heldPattern, {1, 2}]]<>" in increments of "<>ToString[Extract[heldPattern, {1, 3}]]<>".",

	(* RangeP[Min, Max, Increment, Inclusive\[Rule]None] *)
	Hold[RangeP[_, _, _, Inclusive -> None]],
	"A number greater than "<>ToString[Extract[heldPattern, {1, 1}]]<>" and less than "<>ToString[Extract[heldPattern, {1, 2}]]<>" in increments of "<>ToString[Extract[heldPattern, {1, 3}]]<>".",

	(* RangeP[Min, Max], by default is include on both sides *)
	Hold[RangeP[_, _]] | Hold[RangeP[_, _, Inclusive -> All]],
	"A number greater than or equal to "<>ToString[Extract[heldPattern, {1, 1}]]<>" and less than or equal to "<>ToString[Extract[heldPattern, {1, 2}]]<>".",

	(* RangeP[Min, Max, Inclusive\[Rule]Left] *)
	Hold[RangeP[_, _, Inclusive -> Left]],
	"A number greater than or equal to "<>ToString[Extract[heldPattern, {1, 1}]]<>" and less than "<>ToString[Extract[heldPattern, {1, 2}]]<>".",

	(* RangeP[Min, Max, Inclusive\[Rule]Right] *)
	Hold[RangeP[_, _, Inclusive -> Right]],
	"A number greater than "<>ToString[Extract[heldPattern, {1, 1}]]<>" and less than or equal to "<>ToString[Extract[heldPattern, {1, 2}]]<>".",

	(* RangeP[Min, Max, Inclusive\[Rule]None] *)
	Hold[RangeP[_, _, Inclusive -> None]],
	"A number greater than "<>ToString[Extract[heldPattern, {1, 1}]]<>" and less than "<>ToString[Extract[heldPattern, {1, 2}]]<>".",

	(* GreaterP[value] *)
	Hold[GreaterP[_]],
	"A number greater than "<>ToString[Extract[heldPattern, {1, 1}]]<>".",

	(* GreaterP[value,increment] *)
	Hold[GreaterP[_, _]],
	"A number greater than "<>ToString[Extract[heldPattern, {1, 1}]]<>" in increments of "<>ToString[Extract[heldPattern, {1, 2}]]<>".",

	(* GreaterEqualP[value] *)
	Hold[GreaterEqualP[_]],
	"A number greater than or equal to "<>ToString[Extract[heldPattern, {1, 1}]]<>".",

	(* GreaterEqualP[value,increment] *)
	Hold[GreaterEqualP[_, _]],
	"A number greater than or equal to "<>ToString[Extract[heldPattern, {1, 1}]]<>" in increments of "<>ToString[Extract[heldPattern, {1, 2}]]<>".",

	(* LessP[value] *)
	Hold[LessP[_]],
	"A number less than "<>ToString[Extract[heldPattern, {1, 1}]]<>".",

	(* LessP[value,increment] *)
	Hold[LessP[_, _]],
	"A number less than "<>ToString[Extract[heldPattern, {1, 1}]]<>" in increments of "<>ToString[Extract[heldPattern, {1, 2}]]<>".",

	(* LessEqualP[value] *)
	Hold[LessEqualP[_]],
	"A number less than or equal to "<>ToString[Extract[heldPattern, {1, 1}]]<>".",

	(* LessEqualP[value,increment] *)
	Hold[LessEqualP[_, _]],
	"A number less than or equal to "<>ToString[Extract[heldPattern, {1, 1}]]<>" in increments of "<>ToString[Extract[heldPattern, {1, 2}]]<>".",

	(* Weird Mathematica bug here that I am working around: *)
	Hold[Verbatim[Alternatives][(_GreaterP | _GreaterEqualP | _LessP | _LessEqualP | _RangeP)..]],
	ToString[heldPattern, InputForm],

	(* If we don't have a matching template, simply convert the pattern into a string, verbatim. *)
	_,
	ToString[Extract[heldPattern, {1}, HoldForm]]
];


(* ::Subsubsection:: *)
(*DefineObjectType*)


validTypeDescriptionQ[s_String]:=StringLength[s] > 10;
validTypeDescriptionQ[___]:=False;
CreatePrivilegesP:=Developer | Investigator | None;


DefineObjectType::NoTypeDefError="There is no Type named `1` defined.";
DefineObjectType::TypeAlreadyDefinedError="A class with this name (`1`) is already defined.";

DefineObjectType[type:typeP, typeDef:TypeDefinitionP]:=DefineObjectType[
	type,
	typeDef,
	registeredTypes
];
DefineObjectType[type:typeP, typeDef:TypeDefinitionP, typeRegister_Symbol]:=Module[
	{parentType, mergedDef, typeAnscestors, isDevType},

	If[KeyExistsQ[typeRegister, type],
		(* If we're already defined, it's an error *)
		Message[DefineObjectType::TypeAlreadyDefinedError, ToString[type]];
		Return[$Failed]
	];
	parentType=typeParent[type];
	mergedDef=If[parentType === $Failed,
		(* This is a "root" type--Level 1, so just set the mergedDef to the input Def for registration below.*)
		typeDef,
		(* We need to merge in the parent def into this definition *)
		If[Not[KeyExistsQ[typeRegister, parentType]],
			Message[DefineObjectType::NoTypeDefError, ToString[parentType]];
			Return[$Failed]
		];
		mergeParentIntoType[Lookup[typeRegister, parentType], typeDef]
	];

	(* Add none units if they are not specified *)
	(* Add autobuilt patterns if not already specified *)
	mergedDef=Replace[
		mergedDef,
		(Fields -> fields:_List) :> Fields -> Map[defaultTypeFields[#]&, fields],
		{1}
	];

	(* Define the merged type. *)
	With[
		{definition=Append[mergedDef, Type -> type]},

		AppendTo[
			typeRegister,
			type -> definition
		];
		OnLoad[
			AppendTo[
				typeRegister,
				type -> definition
			];

			(* add dereferencing upvalues for each field in the type definition *)
			setFieldDereferencingUpValues[definition];

			(* populate the 'fieldSymbols' association *)
			addSymbolLookup[definition];

		];

		(* log this as a known type *)
		AppendTo[allKnownTypes,type];

		(* log this as a known type *)
		TypeQ[type] = True;

		(*
			get all anscestor types (things of which 'type' is a subtype)
			e.g. Object[User,Emerald,Developer] => {Object[], Object[User], Object[User,Emerald] }
		*)
		typeAnscestors = Rest@NestList[Most,type, Length[type]];
		(* add type as a descendent to all of those*)
		Map[
			(*
				this records that, e.g. Object[user,Emerald,Developer] is a descendent (subtype) of
				Object[], Object[User], and Object[user,Emerald]
				these lists are used by Types definitions
			*)
			Function[anscestor,
					typeAndDescendents[anscestor]  = Append[typeAndDescendents[anscestor],type];
			],
			typeAnscestors
		];

		definition
	]
];
SetAttributes[DefineObjectType, HoldRest];



typeParent[t:typeP]:=If[Length[t] === 1,
	$Failed,
	Part[t, ;;-2]
];

mergeParentIntoType[parentDef:TypeDefinitionP, typeDef:TypeDefinitionP]:={
	Description -> Lookup[typeDef, Description],
	CreatePrivileges -> Lookup[typeDef, CreatePrivileges, None],
	Timeless -> Lookup[typeDef, Timeless, False],
	If[KeyExistsQ[typeDef, Cache],
		Cache -> Lookup[typeDef, Cache],
		If[KeyExistsQ[parentDef, Cache],
			Cache -> Lookup[parentDef, Cache],
			Nothing
		]
	],
	Fields -> Join[
		Lookup[parentDef, Fields, {}],
		Lookup[typeDef, Fields, {}]
	]
};

autoFieldReverseHead[Object]:=Model;
autoFieldReverseHead[Model]:=Object;
autoFieldReverseMatchQ[t:typeP, head_]:=False/;Length[t] == 0;
autoFieldReverseMatchQ[Object[], Object]:=True;
autoFieldReverseMatchQ[Model[], Model]:=True;
autoFieldReverseMatchQ[t:typeP, head_]:=With[
	{reverseHead=autoFieldReverseHead[head]},
	And[
		MatchQ[t, Blank[head]],
		KeyExistsQ[registeredTypes, t],
		(* We won't have a matching Object[Sample, ___] subtype since our Object Samples are flattened. *)
		Or[
			And[MatchQ[t, Model[ECL`Sample, __]], MatchQ[reverseHead, Object]],
			KeyExistsQ[registeredTypes, Apply[reverseHead, t]]
		]
	]
]/;Length[t] > 0;


newAutoFields[parentType:typeP]:={
	Model -> {
		Format -> Single,
		Class -> Link,
		Pattern :> _Link,
		Relation -> autoFieldType[parentType],
		Description -> "Theoretical model that this object is an instance of.",
		Category -> "Organizational Information",
		Units -> None
	}
}/;autoFieldReverseMatchQ[parentType, Object];

newAutoFields[parentType:typeP]:=Module[{},
	(* If we're dealing with a subtype of Model[Sample], the backlink should be to Object[Sample] (flattened): *)
	If[MatchQ[parentType, Model[Sample, __]],
		{
			Objects -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[Sample][Model],
				Description -> "Objects that represent instances of this model.",
				Category -> "Organizational Information",
				Units -> None
			}
		},
		{
			Objects -> {
				Format -> Multiple,
				Class -> Link,
				Pattern :> _Link,
				Relation -> autoFieldType[parentType],
				Description -> "Objects that represent instances of this model.",
				Category -> "Organizational Information",
				Units -> None
			}
		}
	]
]/;autoFieldReverseMatchQ[parentType, Model];

newAutoFields[_]:={};

autoFieldType[parentType:typeP]:=If[MatchQ[parentType, _Object],
	Apply[Model, parentType][Objects],
	Apply[Object, parentType][Model]
];

addAutoFields[fields_List, type:typeP]:=With[
	{
		withoutName=DeleteCases[
			fields,
			Rule[Name, _],
			{1}
		]
	},

	Join[
		{
			Name -> {
				Format -> Single,
				Class -> String,
				Pattern :> _String,
				Description -> "Name of this Object.",
				Relation -> Null,
				Category -> "Organizational Information",
				Abstract -> True,
				Units -> None,
				PatternDescription -> "A string."
			},
			ID -> {
				Format -> Single,
				Class -> String,
				Pattern :> _String,
				Description -> "ID of this Object.",
				Relation -> Null,
				Category -> "Organizational Information",
				Units -> None,
				PatternDescription -> "The ID of this object."
			},
			Object -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> Evaluate[Append[type, _String]],
				Description -> "Object of this Object.",
				Relation -> Null,
				Category -> "Organizational Information",
				Units -> None,
				PatternDescription -> "The object reference of this object."
			},
			Type -> {
				Format -> Single,
				Class -> Expression,
				Pattern :> Evaluate[type],
				Description -> "Type of this Object.",
				Relation -> Null,
				Category -> "Organizational Information",
				Units -> None,
				PatternDescription -> ToString[Evaluate[type]]
			},
			(* DateCreated will be migrated into this field, after it will be renamed into DateCreated again *)
			(* I don't think this code ever getting executed, because sync of root object fields is not supported *)
			(* NewDateCreated *)
			DateCreated -> {
				Format -> Single,
				Class -> Date,
				Pattern :> _?DateObjectQ,
				Relation -> Null,
				Description -> "The date on which object was created.",
				Category -> "Organizational Information",
				Units -> None,
				PatternDescription -> "The date on which object was created.",
				(*AdminWriteOnly -> True,*)
				Developer -> True
			},
			CreatedBy -> {
				Format -> Single,
				Class -> Link,
				Pattern :> _Link,
				Relation -> Object[User],
				Description -> "The person who created this object.",
				Category -> "Organizational Information",
				Units -> None,
				PatternDescription -> "The person who created this object.",
				(*AdminWriteOnly -> True,*)
				Developer -> True
			},
			Valid -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Relation -> Null,
				Description -> "Indicates whether this object has been validated by ValidObjectQ. True means VoQ passed last time it ran and the object has not changed since then. False means VoQ failed the last time it ran and object has not changed since then. Null means the object has changed since its last run of VoQ.",
				Category -> "Organizational Information",
				Units -> None,
				PatternDescription -> "Indicates whether this object has been validated by ValidObjectQ.",
				AdminWriteOnly -> True,
				Developer -> True
			},
			Published -> {
				Format -> Single,
				Class -> Boolean,
				Pattern :> BooleanP,
				Relation -> Null,
				Description -> "Indicates whether this object has been made world readable. Objects that are published will be available on the web and to all users of ECL for downloading and searching, but not for uploading.",
				Category -> "Organizational Information",
				Units -> None,
				PatternDescription -> "Indicates whether this object is world readable for search and download."
			},
			(*Only add the Notebook field to types that are not Object[LaboratoryNotebook]*)
			If[type =!= Object[LaboratoryNotebook],
				Notebook -> {
					Format -> Single,
					Class -> Link,
					Pattern :> _Link,
					Description -> "Notebook this object belongs to.",
					Relation -> Object[LaboratoryNotebook][Objects],
					Category -> "Organizational Information",
					Units -> None,
					PatternDescription -> "An object of that matches ObjectP[Object[LaboratoryNotebook]]."
				},
				Nothing
			]
		},
		newAutoFields[type],
		withoutName
	]
];

(* ::Subsubsection:: *)
(*fieldNamesToSplitFields*)
(* NOTE: This should be REMOVED as soon as we have alternative class support in fields and UnitOperation no longer does this. *)
(* Returns <|(CombinedField->{SplitFields...})..|> *)
getUnitOperationsSplitFieldsLookup[myType:typeP]:=getUnitOperationsSplitFieldsLookup[LookupTypeDefinition[myType]];
getUnitOperationsSplitFieldsLookup[myTypeDefinition:TypeDefinitionP]:=Module[{possibleClassesAsStrings, splitFields, result},
	(* Get all of our classes as strings. *)
	possibleClassesAsStrings = ToString/@FieldClassP;

	(* Get all of the fields that are really split up into multiple fields for alternative classes. *)
	(* NOTE: We dictate this by including the Migration->SplitField key when defining the field. *)
	splitFields=Cases[
		Lookup[myTypeDefinition, Fields],
		Verbatim[Rule][field_, KeyValuePattern[Migration->SplitField]] :> field
	];

	(* Compute our grouped result. *)
	result=GroupBy[
		splitFields,
		(* Some fields can be indexed. Make sure we migrate those as well *)
		(* Migrate fields. Need to do it in two steps as xxxIndexedSingleLink can also just be replaced as xxxIndexedSingle if we allow both patterns in possibleClassesAsStrings *)
		(ToExpression@StringReplace[StringReplace[ToString[#], fieldName__ ~~ "Indexed" ~~ ("Single"|"Multiple") ~~ (ToString /@ FieldClassP) ... ~~ EndOfString :> fieldName],fieldName__ ~~ class:Alternatives@@possibleClassesAsStrings ~~ EndOfString :> fieldName]&)
	];

	(* Cache our information. *)
	getUnitOperationsSplitFieldsLookup[Lookup[myTypeDefinition, Type]]=result;

	(* Return our result. *)
	result
];



(* ::Subsubsection:: *)
(*setFieldDereferencingUpValues*)
(*
	This sets UpValues on each field symbol to make dereferncing from a list of objects work
	there are MANY duplicate fields across types, so to be efficient these calls are memoized,
	except for non-ECL symbols, which sometimes have trouble getting their definitions saved in MX
*)
(* map this over all fields in definition *)
setFieldDereferencingUpValues[definition_List] :=  Map[
	setFieldDereferencingUpValues,
	 Keys[Lookup[definition,Fields,{}]]
];

setFieldDereferencingUpValues[field_] := Module[{},

		Unprotect[field];

			(* NOTE: This should be REMOVED as soon as we have alternative class support in fields and UnitOperation no longer does this. *)
			If[MatchQ[field, Alternatives@@specialFieldSymbols],
				field /: (objectList : {(objectP | modelP | linkP | _Association)..})[field] := Download[objectList, field];,
				field /: (objectList : {(objectP | modelP | linkP | _Association)..})[field] := If[MemberQ[objectList, unitOperationObjectP|unitOperationAbbreviatedLinkP],
					Module[{unitOperationObjectPositions, regularObjectPositions, unitOperationDownload, regularDownload},
						(* Get the positions of any unit operation objects. These have to be downloaded in a special way. *)
						unitOperationObjectPositions=Position[objectList, unitOperationObjectP|unitOperationAbbreviatedLinkP, {1}, Heads->False];
						regularObjectPositions=Position[objectList, Except[unitOperationObjectP|unitOperationAbbreviatedLinkP], {1}, Heads->False];

						unitOperationDownload=DownloadUnitOperation[(Function[position, Extract[objectList,position]]/@unitOperationObjectPositions), field];
						regularDownload=Download[(Function[position, Extract[objectList,position]]/@regularObjectPositions), field];

						ReplacePart[
							ConstantArray[Null, Length[objectList]],
							Join[
								Rule@@@Transpose[{unitOperationObjectPositions, unitOperationDownload}],
								Rule@@@Transpose[{regularObjectPositions, regularDownload}]
							]
						]
					],
					Download[objectList, field]
				];
			];

			(* This is for situations like object[field1][field2] where the first download object[field1] returns $Failed *)
			field /: $Failed[field] := $Failed;

	(*
		If this is an ECL field, then memoize this call so it doesn't get run again.
		For other non-ecl symbols, definitions don't always get saved properly so we want it to re-run this call.
		upvaluedQ will get saved so the memoized calls will persist in mx form.
	*)
	If[Context[field]==="ECL`",
		(*  Arbitrarily putting True here -- doesn't matter what's returned *)
		setFieldDereferencingUpValues[field]=True;
	];

];


(*
	This list was hard-coded into every setFieldDereferencingUpValues call.
	Putting it upfront to avoid dulpicate calls.
	Notebook is the one symbol that isn't a regular field.
	Some of these have non-ECL context so need to be in OnLoad
*)
specialFieldSymbols = {ID, Object, Type, Model, Objects, Name, Notebook, DateCreated, CreatedBy, Valid, Published};
OnLoad[
	setFieldDereferencingUpValues /@ specialFieldSymbols;
];

(* ::Subsubsection:: *)
(*LookupTypeDefinition*)


LookupTypeDefinition::NoFieldDefError="Type `1` has no Field name `2` defined.";
LookupTypeDefinition::NoFieldComponentDefError="Type `1`, Field `2` has no component named `3` defined.";

LookupTypeDefinition[type:Object[]]={
	Description -> "Root Object Type.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> addAutoFields[{}, type]
};

LookupTypeDefinition[type:Model[]]={
	Description -> "Root Model Type.",
	CreatePrivileges -> None,
	Cache -> Download,
	Fields -> addAutoFields[{}, type]
};

LookupTypeDefinition[type:typeP]:=LookupTypeDefinition[type]=With[
	{realDef=Lookup[registeredTypes, type, $Failed]},
	Replace[
		realDef,
		Rule[Fields, x_] :> Rule[Fields, addAutoFields[x, type]],
		Infinity
	]
];

LookupTypeDefinition[type:typeP, PatternDescription -> True]:=LookupTypeDefinition[type, PatternDescription -> True]=With[
	{realDef=LookupTypeDefinition[type]},
	Replace[
		realDef,
		(Fields -> fields:_List) :> Fields -> Map[addAutobuiltPatterns[#]&, fields],
		{1}
	]
];


LookupTypeDefinition[type:typeP, fieldSymbol_Symbol]:=Module[
	{definition, fieldDefinition},

	definition=LookupTypeDefinition[type];
	fieldDefinition=If[MatchQ[definition, $Failed],
		$Failed,
		LookupPath[definition, {Fields, fieldSymbol}]
	];

	Switch[fieldDefinition,
		$Failed,
		Message[DefineObjectType::NoTypeDefError, type]; $Failed,
		Missing["KeyAbsent", Fields],
		Message[ValidTypeQ::TypeDefinitionStructureError, "No Fields Key found for the type."]; $Failed,
		Missing["KeyAbsent", fieldSymbol],
		Message[LookupTypeDefinition::NoFieldDefError, type, fieldSymbol]; $Failed,
		_,
		fieldDefinition
	]
];
LookupTypeDefinition[type:typeP, fieldSymbols:{_Symbol..}]:=Map[
	LookupTypeDefinition[type, #]&,
	fieldSymbols
];

LookupTypeDefinition[field:fieldP]:=LookupTypeDefinition[field, Null];
LookupTypeDefinition[field:fieldP, component_Symbol]:=With[
	{
		part=If[Length[field] > 1,
			Last[field],
			Null
		],

		lookupResult=If[component === Null,
			LookupTypeDefinition[Head[field], First[field]],
			LookupTypeDefinition[Head[field], First[field], component]
		]
	},

	If[MatchQ[component, Class | Pattern | Relation | Units | Migration] && part=!=Null,
		Switch[lookupResult,
			{_Rule..},
			Lookup[lookupResult, part],

			{Except[_Rule]...},
			Part[lookupResult, part],

			$Failed,
			$Failed
		],
		lookupResult
	]
];

LookupTypeDefinition[type:typeP, fieldSymbol_Symbol, component_Symbol]:=With[
	{result=LookupTypeDefinition[type, fieldSymbol, {component}]},

	If[FailureQ[result],
		result,
		First[result]
	]
];

LookupTypeDefinition[type:typeP, fieldSymbol_Symbol, components:{_Symbol..}]:=Module[
	{definition, fieldDefinition, result, missingComponents},

	definition=LookupTypeDefinition[type];
	fieldDefinition=If[MatchQ[definition, $Failed],
		$Failed,
		LookupPath[definition, {Fields, fieldSymbol}]
	];

	Switch[fieldDefinition,
		$Failed,
		Message[DefineObjectType::NoTypeDefError, type],

		Missing["KeyAbsent", Fields],
		Message[ValidTypeQ::TypeDefinitionStructureError, "No Fields Key found for the type."],

		Missing["KeyAbsent", fieldSymbol],
		Message[LookupTypeDefinition::NoFieldDefError, type, fieldSymbol]
	];

	If[FailureQ[fieldDefinition] || MissingQ[fieldDefinition],
		Return[$Failed]
	];

	result=KeyTake[fieldDefinition, components];
	missingComponents=Complement[components, Keys[result]];

	If[Length[missingComponents] > 0,
		(
			Message[LookupTypeDefinition::NoFieldComponentDefError, type, fieldSymbol, missingComponents];
			Return[$Failed]
		)
	];

	Values[result]
];

clearLookupTypeDefinitions[types:{typeP...}]:=clearLookupTypeDefinitions /@ types;
clearLookupTypeDefinitions[type:typeP]:=Quiet[
	With[{},
		Unset[LookupTypeDefinition[type]];
		Apply[
			Unset,
			Select[
				DownValues[Fields][[All, 1]],
				MemberQ[#, type, Infinity]&
			],
			{1}
		]
	],
	{Unset::norep}
];



(* ::Subsubsection:: *)
(*lookup helpers*)


singleFieldQ[type:typeP, field_Symbol]:=MatchQ[LookupTypeDefinition[type, field, Format], Single];
multipleFieldQ[type:typeP, field_Symbol]:=MatchQ[LookupTypeDefinition[type, field, Format], Multiple];
computableFieldQ[type:typeP, field_Symbol]:=MatchQ[LookupTypeDefinition[type, field, Format], Computable];


(* ::Subsubsection:: *)
(*LookupTypeFieldNames*)
Authors[lookupTypeFieldNames]:={"platform"};

lookupTypeFieldNames[lookup:typeP]:=Map[First, lookupFieldRules[lookup]];
lookupFieldRules[lookup:typeP]:=With[
	{fields=LookupPath[registeredTypes, {Key[lookup], Fields}]},
	Switch[
		fields,
		Missing["KeyAbsent", lookup], Message[DefineObjectType::NoTypeDefError, ToString[lookup]]; $Failed,
		Missing["KeyAbsent", Fields], Message[ValidTypeQ::TypeDefinitionStructureError, "No Fields Key found for the type."]; $Failed,
		_, fields
	]
];



(* ::Subsubsection:: *)
(*ValidTypeQ*)


DefineOptions[
	ValidTypeQ,
	Options :> {
		{CheckServer -> False, True | False, "When true, checks that the definition on the server matches that in the object definition."}
	},
	SharedOptions :> {
		RunValidQTest
	}
];

ValidTypeQ::TypeDefinitionStructureError="The type was defined incorrectly: `1`.";

ValidTypeQ[{}, ops:OptionsPattern[]]:=Null;
ValidTypeQ[type:(typeP | {typeP..}), ops:OptionsPattern[]]:=
	Quiet[
		RunValidQTest[
			type,
			{
				ifTypeExists[validObjectTypeFormatGeneralTests],
				ifTypeExists[validObjectTypeFormatFieldTests],
				ifTypeExists[validTypeFormatLinkTests],
				ifTypeExists[validObjectTypeFormatComputableTests],
				ifTypeExists[validObjectTypeFormatUnitsTests],
				ifTypeExists[validNamedFieldTests],
				If[OptionDefault[OptionValue["CheckServer"]],
					ifTypeExists[validObjectTypeFormatCheckServerTests],
					Nothing
				]
			},
			PassOptions[
				ValidTypeQ,
				RunValidQTest,
				(* need to explicitly set SymbolSetUp to False because otherwise we might run the SymbolSetUp for procedure tests and that is never the intent here *)
				ECL`ReplaceRule[ToList[ops], SymbolSetUp -> False]
			]
		],
		{Part::partd, Lookup::invrl}
	];

(*Only call the function if the type exists, otherwise return a failing test.*)
ifTypeExists[func:_Symbol | _Function]:=Function[type,
	If[TypeQ[type],
		func[type],
		{
			Test[StringJoin[ToString[type], " exists:"],
				False,
				True,
				Category -> "General",
				FatalFailure -> True
			]
		}
	]
];

validObjectTypeFormatGeneralTests[type:typeP]:=Module[
	{typeDef=LookupTypeDefinition[type]},
	If[typeDef === $Failed,
		Message[DefineObjectType::NoTypeDefError, ToString[typeDef]];
		$Failed
	];
	(* else, return the tests *)
	{
		Test["Description is valid:",
			Lookup[typeDef, Description],
			_?(validTypeDescriptionQ[#]&),
			Category -> "General"
		],
		Test["CreatePrivileges is valid:",
			Lookup[typeDef, CreatePrivileges],
			CreatePrivilegesP,
			Category -> "General"
		],
		Test["Fields exist:",
			Lookup[typeDef, Fields],
			{(_Rule | _RuleDelayed)..},
			Category -> "General"
		],
		Test["Cache is Download|Session:",
			Lookup[typeDef, Cache],
			Download | Session,
			Category -> "General"
		],
		With[{duplicateFields=Cases[Tally[Lookup[typeDef,Fields][[All,1]]], {field_, GreaterP[1]}:>field]},
			If[Length[duplicateFields]>0,
				Test["Field names unique "<>ToString[duplicateFields]<>":",
					True,
					False,
					Category->"General"
				],
				Test["Field names unique:",
					True,
					True,
					Category->"General"
				]
			]
		]
	}

];

validObjectTypeFormatFieldTests[type:typeP]:=Module[
	{fields},

	fields=LookupPath[registeredTypes, {Key[type], Fields}];
	If[MatchQ[fields, _Missing],
		Message[ValidTypeQ::TypeDefinitionStructureError, "No Fields Key found for the type. "<>ToString[fields]];
		$Failed
	];

	Apply[
		Join,
		Map[
			With[{description=ToString[#[[1]]]<>" is properly defined:"},
				{
					Test[description,
						validFieldQ[#],
						True,
						Category -> "Field Definitions"
					],

					Test[ToString[#[[1]]]<>" - Description starts with uppercase, ends with a period, contains no square brackets:",
						Lookup[#[[2]], Description],
						_String?(And[
							StringMatchQ[#, _?UpperCaseQ~~___~~"."],
							!StringContainsQ[#, "]" | "["]
						]&),
						Category -> "Descriptions"
					],

					Test[ToString[#[[1]]]<>" - Pattern is not _:",
						Lookup[#[[2]], Pattern],
						Except[Verbatim[_] | _List?(MemberQ[#, Verbatim[_]]&)],
						Category -> "Pattern"
					],

					Test[ToString[#[[1]]]<>" - Pattern is a delayed rule::",
						MemberQ[#[[2]], RuleDelayed[Pattern, _]],
						True,
						Category -> "Pattern"
					],

					Test[ToString[#[[1]]]<>" - Category matches FieldCategoryP:",
						Lookup[#[[2]], Category],
						FieldCategoryP,
						Category -> "Categories"
					],

					Test[ToString[#[[1]]]<>" - not a member of the restricted field names:",
						restrictedFieldNameQ[type, #[[1]]],
						False,
						Category -> "Names"
					],

					(* If headers are defined, make sure that they are the correct length and only with allowed field types*)
					Switch[
						#,

						_?IndexedFieldQ,
						Test[ToString[#[[1]]]<>" - Headers matches length of Class:",
							Lookup[#[[2]], Headers],
							_Missing | {Repeated[_String, {Length[Lookup[#[[2]], Class]]}]},
							Category -> "Field Definitions"
						],

						_?NamedFieldQ,
						Test[ToString[#[[1]]]<>" - Headers matches length of Class:",
							Lookup[#[[2]], Headers],
							_Missing | {Repeated[(_ -> _String), {Length[Lookup[#[[2]], Class]]}]},
							Category -> "Field Definitions"
						],

						(* Headers are allowed but not validated for computable fields *)
						_?ComputableFieldQ,
						Nothing,

						_,
						Test[ToString[#[[1]]]<>" - Headers field should not exist:",
							Lookup[#[[2]], Headers],
							_Missing,
							Category -> "Field Definitions"
						]
					],

					(* Indexed fields must have headers *)
					If[IndexedFieldQ[#],
						Test[ToString[#[[1]]]<>" - Headers required for indexed field:",
							Lookup[#[[2]], Headers],
							Except[_Missing],
							Category -> "Field Definitions"
						],
						Nothing
					],

					If[IndexedFieldQ[#] || MultipleFieldQ[#],
						Test[ToString[#[[1]]]<>" - IndexMatching is a field in the object:",
							Lookup[#[[2]], IndexMatching],
							_Missing | FieldP[type, Output -> Short],
							Category -> "Field Definitions"
						],
						Test[ToString[#[[1]]]<>" - IndexMatching field should not exist:",
							Lookup[#[[2]], IndexMatching],
							_Missing,
							Category -> "Field Definitions"
						]
					],

					(* BigQuantityArrays must have patterns that are in the form of BigQuantityArrayP *)
					If[MatchQ[Lookup[#[[2]], Class], BigQuantityArray],
						Test[ToString[#[[1]]]<>" - the pattern of a BigQuantityArray field matches BigQuantityArrayP[<units specified with the Units key>]:",
							Lookup[#[[2]], Pattern],
							BigQuantityArrayP[Lookup[#[[2]], Units]],
							EquivalenceFunction -> SameQ
						],
						Nothing
					],

					(* make sure description for a field with IndexMatching set starts with For each member; make sure to only test this if IndexMatching is present, legitimately *)
					If[(IndexedFieldQ[#] || MultipleFieldQ[#]) && MatchQ[Lookup[#[[2]], IndexMatching], FieldP[type, Output -> Short]],
						Test[ToString[#[[1]]]<>" - Description for field with IndexMatching rule starts with \"For each member of ___,\":",
							Lookup[#[[2]], Description],
							_?(Function[descriptionString, StringMatchQ[descriptionString, "For each member of "<>ToString[Lookup[#[[2]], IndexMatching]]<>","~~___]]),
							Category -> "Field Definitions"
						],
						Nothing
					]
				}
			]&,
			fields
		]
	]
];

validObjectTypeFormatCheckServerTests[type:typeP]:=Module[{}, {
	Test["Server definition matches that defined in the object definition.",
		serverDefinitionMatchQ[type],
		True,
		Category -> "Server"
	]
}];

(*

	<|"NewFieldCount" -> 0, "NewTypeId" -> "",
	 "UpdatedObjectType" -> False, "UpdatedFieldCount" -> 0,
	 "RemovedFieldCount" -> 0|>
*)

serverDefinitionMatchQ[type:typeP]:=Module[
	{response=checkObjectType[type], newFieldCount, updatedFieldCount, removedFieldCount, updObjectType},
	{
		newFieldCount,
		updatedFieldCount,
		removedFieldCount,
		updObjectType
	}=Lookup[
		response,
		{
			"NewFieldCount",
			"UpdatedFieldCount",
			"RemovedFieldCount",
			"UpdatedObjectType"
		}
	];
	And[
		newFieldCount == 0,
		updatedFieldCount == 0,
		removedFieldCount == 0,
		Not[updObjectType]
	]
];


validObjectTypeFormatComputableTests[type:typeP]:=Map[
	With[{description=ToString[#]<>" reference existing Fields"},
		Test[description,
			validComputableQ[#, type],
			True,
			Category -> "Computable Fields"
		]
	]&,
	computableFields[type]
];

computableFields[type:typeP]:=Part[
	Select[
		LookupPath[registeredTypes, {Key[type], Fields}],
		Lookup[#[[2]], Format] === Computable&
	],
	All,
	1
];

validComputableQ[field_Symbol, type:typeP]:=Module[
	{expression},

	expression=Extract[
		SelectFirst[
			LookupTypeDefinition[type, field],
			First[#] === Expression &
		],
		{2},
		Hold
	];

	MatchQ[
		Complement[Cases[expression, Field[x_] :> x, Infinity], Keys[type], {Type, Object}],
		{}
	]
];

noBlanks[cls:Object[s_Symbol, Verbatim[Blank[]]]]:=Object[s];
noBlanks[cls:Object[s_Symbol, s2_Symbol]]:=Object[s, s2];

fieldDefinitionLinkQ[field:fieldP]:=And[
	FieldQ[field],
	Quiet[
		MatchQ[LookupTypeDefinition[field, Relation], Except[Null | $Failed]],
		{LookupTypeDefinition::NoFieldComponentDefError}
	]
];

pointsBackToQ[from:fieldP, to:fieldP]:=Module[
	{backLinkDef},

	If[!fieldDefinitionLinkQ[from],
		Return[False]
	];
	If[!fieldDefinitionLinkQ[to],
		Return[False]
	];

	backLinkDef=LookupTypeDefinition[to, Relation];
	If[!MatchQ[backLinkDef, (_List | _Alternatives)],
		backLinkDef=List[backLinkDef]
	];

	MemberQ[
		backLinkDef,
		upFieldsAlternatives[from]
	]
];

upFieldsAlternatives[field:fieldP]:=Apply[Alternatives,
	Join[
		upFields[field],
		{field}
	]
];

upFields[field:fieldP]:=With[
	{
		parentField=Apply[
			Most[Head[field]],
			field
		]
	},

	Join[
		{parentField},
		If[Length[Head[parentField]] == 0,
			{},
			upFields[parentField]
		]
	]
];


validTypeFormatLinkTests[type:typeP]:=With[
	{fields=Lookup[LookupTypeDefinition[type], Fields]},

	Apply[
		Join,
		Map[
			fieldLinkTests[type, #]&,
			fields
		]
	]
];

(*non Indexed Field*)
fieldLinkTests[type:typeP, field_Symbol -> definition_List]:=With[
	{
		class=Lookup[definition, Class],
		relations=Flatten[
			ReplaceAll[
				{Lookup[definition, Relation, {}]},
				Alternatives -> List
			]
		]
	},

	If[MatchQ[class, Link] || MatchQ[class, TemporalLink],
		Map[
			backlinkTest[type[field], #]&,
			relations
		],
		{}
	]
]/;Not[IndexedFieldQ[definition]];

(*Indexed Field*)
fieldLinkTests[type:typeP, field_Symbol -> definition_List]:=Module[
	{class, linkIndices, relations, fieldRelations},

	class=Lookup[definition, Class];
	linkIndices=Position[class, Link | TemporalLink, {1}][[All, 1]];
	If[Length[linkIndices] === 0,
		Return[{}]
	];
	relations=Lookup[definition, Relation, {}];
	fieldRelations=Map[
		type[field, #] -> Flatten[ReplaceAll[{relations[[#]]}, Alternatives -> List]]&,
		linkIndices
	];

	Apply[
		Join,
		Map[
			Function[{rule},
				Map[
					backlinkTest[rule[[1]], #]&,
					rule[[2]]
				]
			],
			fieldRelations
		]
	]
]/;IndexedFieldQ[definition];


(* Named Fields *)

namedFieldTests[Except[_Symbol -> KeyValuePattern[(Class | Pattern | Units | Relation) -> {_Rule..}]]]:=
	Nothing;

namedFieldTests[(type:_Symbol) -> (typeDef:KeyValuePattern[(Class | Pattern | Units | Relation) -> {_Rule..}])]:=
	{
		Test[ToString[type]<>" - For Named Fields Class, Pattern, Units and Relation are defined as lists of rules or not at all:",
			DeleteMissing[Lookup[typeDef, {Class, Pattern, Units, Relation}]],
			{{_Rule..}..}
		],

		Test[ToString[type]<>" - Named Fields have a consistent order:",
			Quiet[
				SameQ @@ Map[Keys, DeleteMissing[Lookup[typeDef, {Class, Pattern, Units, Relation}]]],
				{Key::invrl}
			],
			True
		],

		Test[ToString[type]<>" - Has no duplicate columns:",
			Quiet[
				And @@ Map[
					DuplicateFreeQ[Keys[#]]&,
					DeleteMissing[Lookup[typeDef, {Class, Pattern, Units, Relation}]]
				],
				{Key::invrl}
			],
			True
		]
	};

validNamedFieldTests[type:typeP]:=
	Apply[Join,
		Map[namedFieldTests, LookupPath[registeredTypes, {Key[type], Fields}]]
	];

(*Computable Fields*)
fieldLinkTests[type:typeP, field_Symbol -> definition_List]:={};

backlinkTest[from:fieldP, to:fieldP]:=
	Test[StringJoin["Backlink check: ", ToString[to], " points back to ", ToString[from], ":"],
		pointsBackToQ[from, to],
		True,
		Category -> StringJoin["Relations ", ToString[from]]
	];
backlinkTest[from:fieldP, to:typeP]:=
	Test[StringJoin[ToString[to], " exists."],
		TypeQ[to],
		True,
		Category -> StringJoin["Relations ", ToString[from]]
	];
backlinkTest[from:fieldP, to:emptyTypeP]:=
	Test[StringJoin[ToString[to], " will be allowed without an existence check."],
		True,
		True,
		Category -> StringJoin["Relations ", ToString[from]]
	];


validObjectTypeFormatUnitsTests[t:typeP]:=With[
	{fieldRules=DeleteCases[lookupFieldRules[t], _RuleDelayed]},

	Map[
		unitCheckTest[#]&,
		fieldRules
	]
];

unitCheckTest[Rule[fieldName_, rules_]]:=With[
	{description=ToString[fieldName]<>unitsFieldCheckText[rules]},

	Test[
		description,
		correctUnitsQ[rules],
		True,
		Category -> "Units"
	]
];

unitsFieldCheckText[rules:{(_Rule | _RuleDelayed)...}]:=unitsFieldCheckText[Class /. rules];
unitsFieldCheckText[QuantityArray | BigQuantityArray | Compressed | Real | Integer | _List | Distribution]:=" has correct Units";
unitsFieldCheckText[_Symbol]:=" should not have Units specified";

Authors[correctUnitsQ]:={"platform"};

correctUnitsQ[rules:{(_Rule | _RuleDelayed)...}]:=correctUnitsQ[{Class, Units} /. rules](*/;MemberQ[rules,Rule[Class,_]]*);

correctUnitsQ[{QuantityArray | BigQuantityArray | Compressed | Real | Integer | Distribution, None}]:=True;    (* correct specification for no Units *)
correctUnitsQ[{QuantityArray | BigQuantityArray | Compressed | Real | Integer | Distribution, NoUnit}]:=False;    (* old way to specify *)

correctUnitsQ[{QuantityArray | BigQuantityArray | Compressed | Real | Integer | Distribution, Units}]:=False;    (* no Units rule *)
correctUnitsQ[{QuantityArray | BigQuantityArray | Compressed | Real | Integer | Distribution, _?UnitsQ}]:=True; (* has some other unit *)
correctUnitsQ[{QuantityArray | Compressed | Real | Integer | Distribution, {Rule[_Symbol, {_?UnitsQ..}]..}}]:=True; (* for data[Chromatography]'s Gradient field *)

correctUnitsQ[{QuantityArray | BigQuantityArray | Compressed, unitsList_List}]:=False/;MemberQ[unitsList, NoUnit];
correctUnitsQ[{QuantityArray | BigQuantityArray | Compressed, {(None | _?UnitsQ)..}}]:=True;

correctUnitsQ[{_Symbol, Units | None}]:=True; (* these should have no Units rule *)

correctUnitsQ[{_Symbol, _?UnitsQ}]:=False; (* these should have no Units rule *)
correctUnitsQ[{_Symbol, NoUnit}]:=False;

correctUnitsQ[{fieldTypeList_List, Units}]:=True/;!MemberQ[fieldTypeList, (QuantityArray | BigQuantityArray | Compressed | Real | Integer)];
correctUnitsQ[{fieldTypeList_List, Units}]:=False/;MemberQ[fieldTypeList, (QuantityArray | BigQuantityArray | Compressed | Real | Integer)];
correctUnitsQ[{fieldTypeList_List, unitsList_List}]:=And @@ MapThread[correctUnitsQGM[{#1, #2}]&, {fieldTypeList, unitsList}];

correctUnitsQGM[arg:{QuantityArray | BigQuantityArray | Compressed | Real | Integer, _}]:=correctUnitsQ[arg];

correctUnitsQGM[arg:{_Symbol, None}]:=True;

correctUnitsQGM[else___]:=correctUnitsQ[else];


(* ::Subsubsection::Closed:: *)
(*validFieldQ*)
Authors[validFieldQ]:={"platform"};

validFieldQ[fieldSymbol_Symbol, type:typeP]:=With[
	{fieldRules=LookupTypeDefinition[type, fieldSymbol]},
	If[MatchQ[fieldRules, {(_Rule | _RuleDelayed)..}],
		validFieldQ[fieldRules],
		False
	]
];
validFieldQ[Rule[_Symbol,rules:{(_Rule|_RuleDelayed)...}]]:=validFieldQ[rules];
validFieldQ[rules:{(_Rule|_RuleDelayed)...}]:=Module[
	{keyPatterns,isComputable,isLink},

	keyPatterns = Association[
		Format->FieldFormatP,
		Class->FieldClassP|{FieldClassP..}|{(_Symbol->FieldClassP)..},
		Category->_String,
		Description->_String,
		Pattern->Except[_Missing],
		Migration->NMultiple|SplitField|_Missing,
		Headers->{__String}|{(_Symbol -> _String) ..}|_Missing,
		Required->True|False|_Missing,
		Abstract->True|False|_Missing,
		Developer->True|False|_Missing,
		IndexMatching->FieldP[Output -> Short]|_Missing,
		AdminWriteOnly->True|False|_Missing,
		AdminViewOnly->True|False|_Missing
	];

	isComputable=SameQ[
		Lookup[rules, Format],
		Computable
	];

	isLink=With[
		{x=Lookup[rules, Class]},
		Which[
			MatchQ[x, _List], MemberQ[x, Link | TemporalLink],
			MatchQ[x, Link], True,
			MatchQ[x, TemporalLink], True,
			True, False
		]
	];

	If[isComputable,
		KeyDropFrom[keyPatterns, Class];
		KeyDropFrom[keyPatterns, Required];
	];

	If[isLink,
		KeyDropFrom[keyPatterns, Pattern]
	];

	And[
		MatchQ[
			Complement[Keys[rules], fieldDefinitionKeys[]],
			{}
		],

		KeyPatternsQ[rules, keyPatterns],

		If[isComputable,
			MemberQ[Keys[rules], Expression],
			True
		]
	]
];
validFieldQ[_]:=False;



(* ::Subsubsection::Closed:: *)
(*restrictedFieldNameQ*)


restrictedFieldNames="Id" | "Type" | "Object" | "Notebook" | "Model" | "Objects" | "Locked" | "Length" | "All" | "DownloadDate";
restrictedFieldNameQ[Object[LaboratoryNotebook], Objects]:=False;
restrictedFieldNameQ[type:typeP, fieldSymbol_Symbol]:=MemberQ[
	Map[ToUpperCase, restrictedFieldNames],
	ToUpperCase[ToString[fieldSymbol]]
];
