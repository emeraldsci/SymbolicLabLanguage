(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

OnLoad[
	General::DeprecatedFunction="The function `1` is deprecated."
];

typeP = (Object | Model)[Repeated[_Symbol, {0, 5}]];
emptyTypeP = (Object | Model)[];
objectP = Object[Repeated[_Symbol, {0, 5}], _String];
modelP = Model[Repeated[_Symbol, {0, 5}], _String];
fieldReferenceP = (Object | Model)[Repeated[_Symbol, {1, 5}], _String, _Symbol, Repeated[_Integer | _Symbol, {0, 1}]];
ReferenceWithNameP = (Object | Model)[Repeated[_Symbol, {0, 5}], _String?(! StringMatchQ[#, "id:"~~__] &)];
ReferenceWithIdP = (Object | Model)[Repeated[_Symbol, {0, 5}], _String?(StringMatchQ[#1, "id:"~~__] &)];

(* Special patterns for temporary workaround for Object[UnitOperation]s to stitch alternative class fields back together. *)
(* NOTE: This should be REMOVED as soon as we have alternative class support in fields and UnitOperation no longer does this. *)
nonUnitOperationObjectP = Object[Except[UnitOperation], Repeated[_Symbol, {0,5}], _String];
nonUnitOperationAbbreviatedLinkP = Link[(nonUnitOperationObjectP|modelP), ___];
unitOperationObjectP = Object[UnitOperation, Repeated[_Symbol, {0,5}], _String];
unitOperationAbbreviatedLinkP = Link[(unitOperationObjectP), ___];

fieldP = (Object|Model)[___Symbol][_Symbol,Repeated[_Integer|_Symbol,{0,1}]];

(* Either a date, or different iterations of None *)
optionalDateP = _DateObject | Null | None | Nothing | "" | _Missing;

objectCacheKeyP = (objectP | modelP) | {(objectP | modelP), _DateObject};

baseLinks = {Link[(objectP | modelP), ___Symbol],
	Link[(objectP | modelP), ___Symbol, _Integer],
	Link[(objectP | modelP), ___Symbol, _String],
	Link[(objectP | modelP), ___Symbol, _Integer, _String]};

temporalLinks = Append[#, _?DateObjectQ]& /@ baseLinks;

linkP = Alternatives @@ Join[baseLinks, temporalLinks];
temporalLinkP = Alternatives @@ temporalLinks;

abbreviatedLinkP = Link[(objectP | modelP), ___];
linkHasFieldQ[Link[_Object | _Model]]:=False;
linkHasFieldQ[l:linkP]:=MatchQ[l[[2]], _Symbol];

linkHasIdQ[l:linkP]:=!MatchQ[getLinkId[l], Null];

getLinkId[l:linkP]:=Module[{potentialId},
	potentialId=If[linkHasDateQ[l], Last[Most[l]], Last[l]];
	If[MatchQ[potentialId, _String], potentialId, Null]
];

linkHasDateQ[l:linkP]:=MatchQ[Last[l], _?DateObjectQ];

getLinkDate[l:linkP]:=If[linkHasDateQ[l], Last[l], Null];

linkHasIndexQ[l:linkP]:=If[Length[l] < 3, False, MatchQ[Part[l, 3], _Integer]];

(* ::Subsubsection::Closed:: *)
(*Link*)

Link[Null, ___]:=Null;
Link[link:linkP, field:Repeated[_Symbol, {0, 1}], index:Repeated[_Integer, {0, 1}],
	id:Repeated[_String, {0, 1}],
	time:Repeated[_DateObject, {0, 1}]
]:=Link[
	First[link],
	field,
	index,
	id,
	time
];
Link[packet_Association, field:Repeated[_Symbol, {0, 1}], index:Repeated[_Integer, {0, 1}],
	id:Repeated[_String, {0, 1}],
	time:Repeated[_DateObject, {0, 1}]
]:=With[
	{object=Lookup[packet, Object]},
	If[ObjectReferenceQ[object],
		Link[
			object,
			field,
			index,
			id,
			time
		],
		$Failed
	]
];
(* This overload previously caused a recursive limit error due to the pattern matching on the Repeated fields.
   By calling a separate function, it delays the field pattern matching after the inputs have been checked. *)
Link[inputs:{(linkP | objectP | modelP | _Association | Null)...}, allFields:___]:=internalLink[inputs, allFields];

internalLink[inputs_, field:Repeated[_Symbol, {0, 1}], index:Repeated[_Integer, {0, 1}],
	id:Repeated[_String, {0, 1}],
	time:Repeated[_DateObject, {0, 1}]]:=Map[
	Link[#, field, index, id, time]&,
	inputs
];

(* these overloads are for if Link is wrapped around another link but the thing inside is not an object (namely if it's a Resource, but other things too I guess; the main thing is that Resources are lower on the hierarchy of file dependencies so it won't know what I'm talking about here if I explicitly reference Resources) *)
Link[nonObjectLink:Link[__], fields___]:=Link[First[nonObjectLink], fields];
Link[nonObjectLinks:{Link[__]..}, fields___]:=Map[
	Link[First[#], fields]&,
	nonObjectLinks
];

(* Was FieldType *)
FieldFormatP = Single | Multiple | Computable;
(* was StorageType*)
FieldClassP = Alternatives[
	BigCompressed,
	BigQuantityArray,
	Boolean,
	Compressed,
	Date,
	EmeraldCloudFile,
	Expression,
	Integer,
	Link,
	TemporalLink,
	QuantityArray,
	Real,
	String,
	VariableUnit,
	Distribution
];


objectToType[o:(objectP | modelP)]:=Part[o, ;;-2];
objectToType[o:linkP]:=Part[First[o], ;;-2];
objectToType[Null]:=Null;
objectToType[$Failed]:=$Failed;
objectToType[{o:_, _}]:=objectToType[o];

SetAttributes[objectToType, Listable];
linkToObject[link:linkP]:=First[link];
linkToObject[object:objectP | modelP]:=object;
linkToObject[Null]:=Null;
linkToObject[$Failed]:=$Failed;
SetAttributes[linkToObject, Listable];

packetToType[packet_Association]:=Lookup[
	packet,
	Type,
	With[
		{id=Lookup[packet, Object]},
		If[MissingQ[id] || !ObjectQ[id],
			$Failed,
			objectToType[id]
		]
	]
];

TypeDefinitionP = {(_Rule | _RuleDelayed) ..};

fieldDefinitionKeys[] = {Format, Class, Pattern, Expression, Units, Relation, Description, Required, Category, Abstract, Developer, Headers, IndexMatching, AdminWriteOnly, AdminViewOnly, Migration};

headerFieldsP[]:=Type | ID | Object;
headerFieldsP[things__]:=Flatten[headerFieldsP[] | things];


(* ::Subsubsection::Closed:: *)
(*ValidPacketFormatQ*)

DefineOptions[
	ValidPacketFormatQ,
	Options :> {
		{Strict -> False, True | False, "When true, enables strict checks for things like computable fields not being specified int he packet."},
		{DisplayFunction -> (Short[#, 1]&), _Symbol | _Function, "When Verbose->True|Failures, this function is applied to each element for printing the headers."}
	},
	SharedOptions :> {
		RunValidQTest
	}
];

ValidPacketFormatQ[packets:_Association | {___Association}, type:typeP, ops:OptionsPattern[]]:=RunValidQTest[
	packets,
	{validPacketFormatQTests[#, type, OptionDefault[OptionValue[Strict]]]&},
	PassOptions[ValidPacketFormatQ, RunValidQTest, ops]
];
ValidPacketFormatQ[packets:_Association | {___Association}, ops:OptionsPattern[]]:=RunValidQTest[
	packets,
	{validPacketFormatQTests[#, OptionDefault[OptionValue[Strict]]]&},
	PassOptions[ValidPacketFormatQ, RunValidQTest, ops]
];

validPacketFormatQTests[packet_Association, strict:BooleanP]:=validPacketFormatQTests[
	packet,
	None,
	strict
];
validPacketFormatQTests[packet_Association, expectedType:typeP | None, strict:BooleanP]:=Module[
	{type, fields, rules, fieldTests, headerTests},

	type=packetToType[packet];
	fields=Lookup[LookupTypeDefinition[type], Fields];

	(*conver to list of rules and filter out Units, Computable Fields, and Header Fields*)
	rules=Select[
		Normal[packet],
		If[strict,
			Not[MatchQ[First[#], headerFieldsP[Units]]],
			Not[
				Or[
					MatchQ[#, _RuleDelayed],
					MatchQ[First[#], headerFieldsP[Units]]
				]
			]
		]&
	];

	headerTests={
		If[expectedType =!= None,
			Test["Type matches "<>ToString[expectedType]<>":",
				type,
				expectedType,
				Category -> "Header Fields"
			],
			Test["Type exists:",
				TypeQ[type],
				True,
				Category -> "Header Fields"
			]
		],

		Test["Object field's value, when it is the object head, matches the Type:",
			If[KeyExistsQ[packet, Object] && KeyExistsQ[packet, Type],
				objectToType[Lookup[packet, Object]],
				Lookup[packet, Type]
			],
			Lookup[packet, Type],
			Category -> "Header Fields"
		]
	};

	fieldTests = Map[
		Function[rule,
			Module[{field, value, definition},
				field = If[MatchQ[First[rule], Append[_] | Replace[_]],
					rule[[1, 1]],
					First[rule]
				];
				value = Last[rule];
				definition = Lookup[fields, field];

				{
					Test[SymbolName[field] <> " exists in object definition:",
						MemberQ[fields[[All, 1]], field],
						True,
						Category -> "Fields"
					],

					Test[SymbolName[field] <> " matches its storage pattern:",
						fieldValueMatchesPatternQ[value, definition],
						True,
						Category -> "Fields",
						TimeConstraint -> 300
					]
				}
			]
		],
		rules
	];

	Flatten[
		{
			headerTests,
			fieldTests
		}
	]
];

fieldValueMatchesPatternQ[
	value:_,
	definition:KeyValuePattern[{
		Format -> (format:_),
		Class -> (class:_),
		Pattern :> (pattern:_),
		Relation -> (relation:_)
	}]
]:=With[
	{uploadPattern=uploadFieldPattern[format, class, pattern, relation]},

	Quiet[
		Or[
			MatchQ[value, uploadPattern],
			MatchQ[
				addFieldUnits[value, definition],
				uploadPattern
			],
			MatchQ[Unitless[value], uploadPattern]
		],
		{MapThread::mptc}
	]
];

fieldValueMatchesPatternQ[
	value:_,
	definition:KeyValuePattern[{
		Format -> Computable,
		Pattern :> (pattern:_)
	}]
]:=MatchQ[
	value,
	Null | pattern
];

(*multiple field*)
uploadFieldPattern[Multiple, class:_, pattern:_, relation:_]:=With[
	{singlePattern=uploadFieldPattern[Single, class, pattern, relation]},

	Set[
		uploadFieldPattern[Multiple, class, Verbatim[pattern], Verbatim[relation]],
		Null | singlePattern | {singlePattern...}
	]
];

(* single *)
uploadFieldPattern[Single, class:Except[_List | Link], pattern:_, relation:_]:=
	Set[
		uploadFieldPattern[Single, class, Verbatim[pattern], Verbatim[relation]],
		Null | pattern
	];

(* computable *)
uploadFieldPattern[Computable, class:_, pattern:_, relation:_]:=
	Set[
		uploadFieldPattern[Computable, class, Verbatim[pattern], Verbatim[relation]],
		Null | pattern
	];

(* single link *)
uploadFieldPattern[Single, Link, pattern:_, relation:_]:=
	Set[
		uploadFieldPattern[Single, Link, Verbatim[pattern], Verbatim[relation]],
		Null | generateLinkP[relation]
	];

(* named single field *)
uploadFieldPattern[Single, class:{_Rule..}, pattern:_, relation:_]:=With[
	{linkPattern=Normal[Merge[{pattern, relation}, Apply[maybeLinkP]]]},

	Set[
		uploadFieldPattern[Single, class, Verbatim[pattern], Verbatim[relation]],
		Null | KeyValuePattern[linkPattern]
	]
];

(*indexed single field*)
uploadFieldPattern[Single, class:{Except[_Rule]..}, pattern:_, relation:_]:=With[
	{linkPattern=MapThread[maybeLinkP, {pattern, relation}]},

	Set[
		uploadFieldPattern[Single, class, Verbatim[pattern], Verbatim[relation]],
		Null | linkPattern
	]
];


maybeLinkP[(*pattern*)Verbatim[_Link], relation:_]:=Null | generateLinkP[relation];
maybeLinkP[pattern:Except[_Link], (*relation*)_]:=Null | pattern;


generateLinkP[field:fieldP]:=LinkP[field];
generateLinkP[type:typeP]:=Link[ObjectReferenceP[type], Repeated[_String, {0, 1}]];
generateLinkP[type:emptyTypeP]:=Link[ObjectReferenceP[type], Repeated[_String, {0, 1}]];
generateLinkP[fields:Verbatim[Alternatives][(fieldP | typeP | emptyTypeP)..]]:=Map[
	generateLinkP,
	fields
];
generateLinkP[fields:{(fieldP | typeP | emptyTypeP)..}]:=Apply[
	Alternatives,
	Map[
		generateLinkP,
		fields
	]
];
generateLinkP[(type:emptyTypeP)[field_Symbol]]:=Link[
	ObjectReferenceP[type],
	field,
	Repeated[_Integer, {0, 1}],
	Repeated[_String, {0, 1}]
];
generateLinkP[other_]:=other;


(* ::Subsubsection::Closed:: *)
(*ValidUploadQ*)

DefineOptions[
	ValidUploadQ,
	Options :> {
		{DisplayFunction -> (Short[#, 1]&), _Symbol | _Function, "When Verbose->True|Failures, this function is applied to each element for printing the headers."}
	},
	SharedOptions :> {
		RunValidQTest
	}
];


ValidUploadQ[uploads:_Association | {___Association}, ops:OptionsPattern[]]:=
	RunValidQTest[
		uploads,
		{validUploadTests},
		PassOptions[ValidUploadQ, RunValidQTest, ops]
	];

validUploadTests[upload:_Association]:=With[
	{
		errors=GroupBy[uploadPacketErrors[upload, {0}], Key["error"], First],
		type=packetToType[upload]
	},

	Flatten[
		{
			Test["Type or Object is specified:",
				errors[["TypeNotSpecified"]],
				_Missing,
				FatalFailure -> True
			],

			Test[StringJoin["Type ", ToString[type], " exists:"],
				errors[["NoSuchType"]],
				_Missing
			],

			Test["Name is not empty:",
				errors[["EmptyName"]],
				_Missing
			],

			Test["If Erase or EraseCases is specified, an existing Object must also be specified. (cannot Delete from new objects):",
				errors[["NoObject"]],
				_Missing
			],

			Test["Object type matches upload Type if both fields specified:",
				MemberQ[
					errors[["FieldStoragePattern", "field"]],
					Object
				],
				False
			],

			Map[validUploadFieldTests[#, errors, type]&, Normal[upload]]
		}
	]
];

validUploadFieldTests[(Append | Replace)[field:_Symbol] -> value:_, errors:_Association, type:typeP]:=
	validUploadFieldTests[field -> value, errors, type];

validUploadFieldTests[field_Symbol -> value:_, errors:_Association, type:typeP]:=With[
	{fieldName=SymbolName[field]},

	{
		(* errors caught on server *)
		Test[StringJoin[fieldName, " is not a real, uploading to an integer"],
			Or[
				MatchQ[value, Null | {Null ...} | _Integer | {(_Integer | Null)...}],
				LookupTypeDefinition[type, field, Class] =!= Integer
			],
			True
		],

		(* errors caught on client *)
		Test[StringJoin[fieldName, " exists in ", ToString[type], " :"],
			MemberQ[errors[["NoSuchField", "field"]], field],
			False
		],

		Test[StringJoin[fieldName, " is specified as Append, Replace, Erase, or EraseCases:"],
			MemberQ[errors[["MultipleField", "field"]], field],
			False
		],

		Test[StringJoin[fieldName, " is not Computable:"],
			MemberQ[errors[["ComputableField", "field"]], field],
			False
		],

		Test[StringJoin[fieldName, " matches storage pattern:"],
			MemberQ[errors[["FieldStoragePattern", "field"]], field],
			False
		],

		Test[StringJoin[fieldName, " is not a multiple field if appending Null:"],
			MemberQ[errors[["FieldStoragePattern", "field"]], field] && value === Null,
			False
		]
	}
];

validUploadFieldTests[operation:Erase[field:_Symbol] -> value:_, errors:_Association, _]:=With[
	{operationString=ToString[operation]},

	{
		Test[StringJoin[ToString[field], " exists in ", ToString[type], " :"],
			MemberQ[errors[["NoSuchField", "field"]], field],
			False
		],

		Test[StringJoin[operationString, " are valid Erase indices:"],
			MemberQ[errors[["ErasePattern", "value"]], value],
			False
		],

		Test[StringJoin[operationString, " refers to a multiple or indexed field:"],
			MemberQ[errors[["SingleEraseField", "field"]], field],
			False
		],

		Test[StringJoin[operationString, " indices match the dimensions of the storage pattern:"],
			MemberQ[errors[["EraseDimension", "field"]], field],
			False
		]
	}
];

validUploadFieldTests[operation:EraseCases[field:_Symbol] -> value:_, errors:_Association, _]:=With[
	{operationString=ToString[operation]},

	{
		Test[StringJoin[ToString[field], " exists in ", ToString[type], " :"],
			MemberQ[errors[["NoSuchField", "field"]], field],
			False
		],

		Test[StringJoin[operationString, " refers to a multiple field:"],
			MemberQ[errors[["SingleEraseCases", "field"]], field],
			False
		],

		Test[StringJoin[operationString, " matches storage pattern:"],
			MemberQ[errors[["FieldStoragePattern", "field"]], field],
			False
		]
	}
];

validUploadFieldTests[operation:_ -> _, errors:_Association, (*type*)_]:=With[
	{operationString=ToString[operation]},

	{
		Test[StringJoin[operationString, " is _Symbol or (Append|Replace|Erase)[_Symbol]:"],
			MemberQ[errors[["InvalidOperation", "operation"]], operation],
			False
		]
	}
];

(* Ignore Delayed Rules *)
validUploadFieldTests[_ :> _, _, _]:={};

(* ::Subsection::Closed:: *)
(*Field Manipulation*)

(* ::Subsubsection::Closed:: *)
(*fieldToPart*)

fieldToPart[typeP[_Symbol]]:=$Failed;
fieldToPart[typeP[_Symbol, index:_Integer | _Symbol]]:=index;

(* ::Subsubsection::Closed:: *)
(*fieldToType*)

fieldToType[field:fieldP]:=Head[field];

(* ::Subsubsection::Closed:: *)
(*fieldToSymbol*)

fieldToSymbol[field:fieldP]:=First[field];

(* ::Subsubsection::Closed:: *)
(*IndexedFieldQ*)

IndexedFieldQ[field:fieldP]:=Quiet[
	IndexedFieldQ[LookupTypeDefinition[field]],
	{DefineObjectType::NoTypeDefError, LookupTypeDefinition::NoFieldDefError}
];

IndexedFieldQ[Rule[_, fieldRules:{(_Rule | _RuleDelayed) ...}]]:=
	IndexedFieldQ[fieldRules];

IndexedFieldQ[fieldRules:{(_Rule | _RuleDelayed)...}]:=
	MatchQ[Class /. fieldRules, {_Symbol ..}];

IndexedFieldQ[_]:=False;


(* ::Subsubsection::Closed:: *)
(* NamedFieldQ *)

NamedFieldQ[field:fieldP]:=Quiet[
	NamedFieldQ[LookupTypeDefinition[field]],
	{DefineObjectType::NoTypeDefError, LookupTypeDefinition::NoFieldDefError}
];

NamedFieldQ[_ -> (fieldRules:{(_Rule | _RuleDelayed) ...})]:=
	NamedFieldQ[fieldRules];

NamedFieldQ[fieldRules:{(_Rule | _RuleDelayed) ...}]:=
	MatchQ[Class /. fieldRules, {(_Symbol -> _) ..}];

NamedFieldQ[_]:=False;


(* ::Subsubsection::Closed:: *)
(*MultipleFieldQ*)

MultipleFieldQ[field:fieldP]:=Quiet[
	MultipleFieldQ[LookupTypeDefinition[field]],
	{DefineObjectType::NoTypeDefError, LookupTypeDefinition::NoFieldDefError}
];

MultipleFieldQ[Rule[_, fieldRules:{(_Rule | _RuleDelayed) ...}]]:=
	MultipleFieldQ[fieldRules];

MultipleFieldQ[fieldRules:{(_Rule | _RuleDelayed) ...}]:=
	MatchQ[Format /. fieldRules, Multiple];

MultipleFieldQ[_]:=False;


(* ::Subsubsection::Closed:: *)
(*SingleFieldQ*)

SingleFieldQ[field:fieldP]:=Quiet[
	SingleFieldQ[LookupTypeDefinition[field]],
	{DefineObjectType::NoTypeDefError, LookupTypeDefinition::NoFieldDefError}
];

SingleFieldQ[Rule[_, fieldRules:{(_Rule | _RuleDelayed)...}]]:=
	SingleFieldQ[fieldRules];

SingleFieldQ[fieldRules:{(_Rule | _RuleDelayed)...}]:=
	MatchQ[Format /. fieldRules, Single];

SingleFieldQ[_]:=False;

(* ::Subsubsection::Closed:: *)
(*ComputableFieldQ*)

ComputableFieldQ[field:fieldP]:=ComputableFieldQ[field]=Quiet[
	ComputableFieldQ[LookupTypeDefinition[field]],
	{DefineObjectType::NoTypeDefError, LookupTypeDefinition::NoFieldDefError}
];

ComputableFieldQ[Rule[_, fieldRules:{(_Rule | _RuleDelayed)...}]]:=
	ComputableFieldQ[fieldRules];

ComputableFieldQ[fieldRules:{(_Rule | _RuleDelayed)...}]:=MatchQ[
	Format /. fieldRules,
	Computable
];

ComputableFieldQ[_]:=False;

emeraldCloudFileFieldQ[field:fieldP]:=With[
	{class=Lookup[LookupTypeDefinition[field], Class]},

	class === EmeraldCloudFile
];

bigQuantityArrayFieldQ[field:fieldP]:=With[
	{class=Lookup[LookupTypeDefinition[field], Class]},

	class === BigQuantityArray
];

indexedEmeraldCloudFileFieldQ[field:fieldP]:=With[
	{class=Lookup[LookupTypeDefinition[field], Class]},

	MemberQ[class, EmeraldCloudFile]
];

namedEmeraldCloudFileFieldQ[field:fieldP]:=With[
	{class=Lookup[LookupTypeDefinition[field], Class]},

	MemberQ[Association[class], EmeraldCloudFile]
];

(* ::Subsubsection::Closed:: *)
(*adding units*)

addFieldUnits[Null, {(_Rule | _RuleDelayed)..}]:=Null;
addFieldUnits[{}, {(_Rule | _RuleDelayed)..}]:={};

(* Single or Multiple *)
addFieldUnits[
	value_,
	KeyValuePattern[{
		Format -> Single | Multiple,
		Class -> (class:Except[_List]),
		Units -> (units:_)
	}]
]:=
	addDefaultUnits[value, units, class];

(* Indexed Single *)
addFieldUnits[
	value_,
	KeyValuePattern[{
		Format -> Single,
		Class -> (class:{Except[_Rule]..}),
		Units -> (units:_)
	}]
]:=
	Quiet[
		MapThread[addDefaultUnits, {value, units, class}],
		{MapThread::mptd}
	];

(* Indexed Multiple with one row *)
addFieldUnits[
	value:{Except[_List]..},
	KeyValuePattern[{
		Format -> Multiple,
		Class -> (class:{Except[_Rule]..}),
		Units -> (units:_)
	}]
]:=
	Quiet[
		MapThread[addDefaultUnits, {value, units, class}],
		{MapThread::mptd}
	];

(* Indexed Multiple *)
addFieldUnits[
	value:{__List},
	KeyValuePattern[{
		Format -> Multiple,
		Class -> (class:{Except[_Rule]..}),
		Units -> (units:_)
	}]
]:=
	Quiet[
		Transpose[
			MapThread[
				addDefaultUnits,
				{Transpose[value], units, class}
			]
		],
		{MapThread::mptd}
	];

(* Named Single *)
addFieldUnits[
	value:_,
	KeyValuePattern[{
		Format -> Single,
		Class -> (class:{_Rule..}),
		Units -> (units:_)
	}]
]:=
	Merge[
		KeyIntersection[{value, units, class}],
		Apply[addDefaultUnits]
	];

(* Named Multiple with one row *)
addFieldUnits[
	value:_Association,
	KeyValuePattern[{
		Format -> Multiple,
		Class -> (class:{_Rule..}),
		Units -> (units:_)
	}]
]:=
	Merge[
		KeyIntersection[{value, units, class}],
		Apply[addDefaultUnits]
	];

(* Named Multiple *)
addFieldUnits[
	values:{_Association..},
	KeyValuePattern[{
		Format -> Multiple,
		Class -> (class:{_Rule..}),
		Units -> (units:_)
	}]
]:=With[
	{
		(* equivalent to
			KeyIntersection[{Merge[values, Identity], units, class}]
				// Merge[Apply[addDefaultUnits]]) *)
		merged=Merge[
			KeyIntersection[{
				Merge[values, Identity],
				units,
				class
			}],
			Apply[addDefaultUnits]
		]
	},

	Map[ (* split association of lists to list of associations *)
		AssociationThread[Keys[merged], #] &,
		Transpose[Values[merged]]
	]
];

(* value, default, class *)
addDefaultUnits[value:_?QuantityQ | Null, _, _]:=value;
addDefaultUnits[value:Except[_List | _?QuantityQ, _?NumericQ], defaultUnit_, Real | Integer]:=If[QuantityQ[defaultUnit],
	Quantity[
		value,
		defaultUnit
	],
	value
];
addDefaultUnits[value_List, _, QuantityArray]:=value;
addDefaultUnits[values_List, None, Integer | Real]:=values;
addDefaultUnits[values_List, {None..}, Integer | Real]:=values;
addDefaultUnits[values:{Null}, _, Integer | Real]:=values;
addDefaultUnits[values:{{Null ..}}, _, Integer | Real]:=values;
addDefaultUnits[values_List, defaultUnit:Except[None, _?QuantityQ], Integer | Real]:=Replace[
	values,
	x_?(And[!QuantityQ[#], # =!= Null]&) :> x * defaultUnit,
	{1}
];
addDefaultUnits[value_, _, _]:=value;


(* ::Subsubsection::Closed:: *)
(*nullable*)


nullable[input_]:=Alternatives[input, Null];


(* ::Subsubsection::Closed:: *)
(*fieldReferenceToObject*)


fieldReferenceToObject[
	(head:Object | Model)[
		typeSymbols:Repeated[_Symbol, {1, 5}],
		id_String,
		_Symbol,
		_Integer | _Symbol | PatternSequence[]
	]
]:=head[
	typeSymbols,
	id
];


(* ::Subsubsection::Closed:: *)
(*fieldReferenceToField*)


fieldReferenceToField[
	(head:Object | Model)[
		typeSymbols:Repeated[_Symbol, {1, 5}],
		_String,
		field_Symbol,
		_Integer | _Symbol | PatternSequence[]
	]
]:=
	head[
		typeSymbols
	][field];


(* ::Subsubsection::Closed:: *)
(*fieldReferenceToSymbol*)


fieldReferenceToSymbol[
	(Object | Model)[
		Repeated[_Symbol, {1, 5}],
		_String,
		field_Symbol,
		_Integer | _Symbol | PatternSequence[]
	]
]:=field;

(* ::Subsubsection::Closed:: *)
(*fieldReferenceToColumn*)

fieldReferenceToColumn[(Object | Model)[Repeated[_Symbol, {1, 5}], _String, _Symbol]]:=$Failed;
fieldReferenceToColumn[
	(Object | Model)[
		Repeated[_Symbol, {1, 5}],
		_String,
		_Symbol,
		column:_Integer | _Symbol
	]
]:=column;
