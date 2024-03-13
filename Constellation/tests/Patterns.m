(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineTests[
	BigQuantityArrayP,
	{
		Example[{Basic, "Matches QuantityArrays:"},
			MatchQ[QuantityArray[{{1.`, 1.`, 1.`}, {2.`, 3.`, 4.`}, {3.`, 6.`, 9.`}, {4.`, 10.`, 16}}, {Second, Meter, Gram}], BigQuantityArrayP[{Second, Meter, Gram}]],
			True
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*Types*)


DefineTests[
	Types,
	{
		Example[{Basic, "Returns a list of all defined types:"},
			Types[],
			{(Object | Model)[___Symbol]..}
		],

		Example[{Basic, "Types which have not been defined do not exist in the Types list:"},
			MemberQ[Types[], Object[My, Type]],
			False
		],

		Example[{Basic, "Returns a list of types from the given level down:"},
			Types[Object[Example]],
			{Object[Example, ___Symbol]..}
		],

		Example[{Basic, "Returns a list of types for a given Model:"},
			Types[Model[Example]],
			{Model[Example, ___Symbol]..}
		],

		Example[{Additional, "Returns a list of all Object types:"},
			Types[Object],
			{Object[__Symbol]..}
		],

		Example[{Additional, "Returns a list of all Model types:"},
			Types[Model],
			{Model[__Symbol]..}
		],

		Example[{Additional, "Get a list of multiple sub-types:"},
			Types[{Model[Example], Object[Example]}],
			{(Model[Example, ___Symbol] | Object[Example, ___Symbol])..}
		],
		Example[{Additional, "Returns list is duplicate free:"},
			Types[{Model[Example], Object[Example]}],
			_?DuplicateFreeQ
		],

		Test["Returned list contains given Model type:",
			Types[Model[Example]],
			_List?(MemberQ[#, Model[Example]]&)
		],

		Test["Returned list contains given Object type:",
			Types[Object[Example]],
			_List?(MemberQ[#, Object[Example]]&)
		],
		(*
			Is this behavior intentional? 
			Some things break if we remove this.
			Alternative is for Types[invalidType] to return $Failed or unevaluated
		*)
		Test["Non-existent type returns empty list:",
			Types[Object[Dog]],
			{}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*TypeQ*)


DefineTests[
	TypeQ,
	{
		Example[{Basic, "Returns True if input is a defined Object type:"},
			TypeQ[Object[Example, Person, Emerald]],
			True
		],

		Example[{Basic, "Returns True if input is a defined Model type:"},
			TypeQ[Model[Example]],
			True
		],

		Example[{Basic, "Returns False if input is not a defined type:"},
			TypeQ[Object[Does, Not, Exist]],
			False
		],

		Example[{Basic, "Returns False if given input is not of the Object/Model form:"},
			TypeQ[123.4],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*TypeP*)


DefineTests[
	TypeP,
	{
		Example[{Basic, "Returns a pattern which matches any type:"},
			MatchQ[Object[Example, Person, Emerald], TypeP[]],
			True
		],

		Example[{Basic, "Returns a pattern that matches any sub-types of the a defined Model type:"},
			MatchQ[Model[Example, Data], TypeP[Model[Example]]],
			True
		],

		Example[{Basic, "Returns a pattern that does not match a type that is not defined:"},
			MatchQ[Object[Does, Not, Exist], TypeP[Object[Does, Not, Exist]]],
			False
		],

		Example[{Basic, "Does not evaluate if not given an expression in the form of an Object/Model type:"},
			TypeP[123.4],
			HoldPattern[TypeP[123.4]]
		],

		Example[{Additional, "Returns a pattern that matches any Model sub-types:"},
			MatchQ[Model[Example, Data], TypeP[Model]],
			True
		],

		Example[{Additional, "Returns a pattern that does not match any Object sub-types:"},
			MatchQ[Object[Example, Data], TypeP[Model]],
			False
		],

		Example[{Additional, "Returns a pattern that matches any number of specific types and their sub-types:"},
			MatchQ[Object[Example, Data], TypeP[{Object[Example, Data], Object[Example, Analysis]}]],
			True
		],

		Example[{Additional, "Returns a pattern that matches any Object sub-types:"},
			MatchQ[Object[Example, Data], TypeP[Object]],
			True
		],

		Example[{Additional, "Returns a pattern that does not match any Model sub-types:"},
			MatchQ[Model[Example, Data], TypeP[Object]],
			False
		],

		Test["Returns a pattern which matches Model type at the given level:",
			MatchQ[Model[Example], TypeP[Model[Example]]],
			True
		],

		Test["Returns a pattern which matches Object type at the given level:",
			MatchQ[Object[Example], TypeP[Object[Example]]],
			True
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ObjectReferenceQ*)


DefineTests[
	ObjectReferenceQ,
	{
		Example[{Basic, "Returns True if input is an object of a defined type:"},
			ObjectReferenceQ[Object[Example, Person, Emerald, "id-string"]],
			True
		],

		Example[{Basic, "Returns True if input is an object of a defined Model type:"},
			ObjectReferenceQ[Model[Example, "id-string"]],
			True
		],

		Example[{Basic, "Returns False if input is an object of a type which is not defined:"},
			ObjectReferenceQ[Object[Does, Not, Exist, "id-string"]],
			False
		],

		Example[{Basic, "Returns False if given input is not of the Object/Model form:"},
			ObjectReferenceQ[123.4],
			False
		],

		Example[{Basic, "Returns False if given input is not of the Object/Model form:"},
			ObjectReferenceQ[123.4],
			False
		],

		Example[{Additional, "Returns True for an Object with only an ID:"},
			ObjectReferenceQ[Object["id-string"]],
			True
		],

		Example[{Additional, "Returns True for a Model with only an ID:"},
			ObjectReferenceQ[Model["id-string"]],
			True
		],

		Example[{Additional, "Does not match a link:"},
			ObjectReferenceQ[Link[Object[Example, Data, "my-object"]]],
			False
		],

		Example[{Additional, "Does not match a packet:"},
			ObjectReferenceQ[<|Type -> Object[Example, Person, Emerald]|>],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ObjectReferenceP*)


DefineTests[
	ObjectReferenceP,
	{
		Example[{Basic, "Returns a pattern which matches an Object/Model of any defined type:"},
			MatchQ[Object[Example, Person, Emerald, "id-string"], ObjectReferenceP[]],
			True
		],

		Example[{Basic, "Returns a pattern that matches an Object of any sub-types of the defined Model type:"},
			MatchQ[Model[Example, Data, "id-string"], ObjectReferenceP[Model[Example]]],
			True
		],

		Example[{Basic, "Returns a pattern that matches any Object of any sub-types of the list of defined types:"},
			MatchQ[
				{
					Model[Example, Data, "id-string"],
					Object[Example, Analysis, "another-id"]
				},
				{ObjectReferenceP[{Model[Example], Object[Example, Analysis]}]..}
			],
			True
		],

		Example[{Basic, "Returns a pattern that does not match a type that is not defined:"},
			MatchQ[Object[Does, Not, Exist, "id-string"], ObjectReferenceP[Object[Does, Not, Exist]]],
			False
		],

		Example[{Basic, "Does not evaluate if not given an expression in the form of an Object/Model type:"},
			ObjectReferenceP[123.4],
			HoldPattern[ObjectReferenceP[123.4]]
		],

		Example[{Additional, "Returns a pattern that matches a Model of any Model sub-types:"},
			MatchQ[Model[Example, Data, "id-string"], ObjectReferenceP[Model]],
			True
		],

		Example[{Additional, "Returns a pattern that does not match an Object of any Object sub-types:"},
			MatchQ[Object[Example, Data, "id-string"], ObjectReferenceP[Model]],
			False
		],

		Example[{Additional, "Returns a pattern that matches an Object of any Object sub-types:"},
			MatchQ[Object[Example, Data, "id-string"], ObjectReferenceP[Object]],
			True
		],

		Example[{Applications, "Returns a pattern that matches all forms of specific Object:"},
			Module[{object, name},

				name=CreateUUID[];
				object=Upload[<|Type -> Object[Example, Data], Name -> name|>];

				Map[
					MatchQ[#, ObjectReferenceP[object]]&,
					{
						object,
						Object[object[[-1]]],
						Object[Example, Data, name]
					}
				]
			],
			{True, True, True}
		],

		Example[{Additional, "Returns a pattern that does not match a Model of any Model sub-types:"},
			MatchQ[Model[Example, Data, "id-string"], ObjectReferenceP[Object]],
			False
		],

		Example[{Additional, "Returns a pattern that matches an Object with no type information:"},
			MatchQ[Object["id-string"], ObjectReferenceP[Object]],
			True
		],

		Example[{Additional, "Returns a pattern that matches a Model with no type information:"},
			MatchQ[Model["id-string"], ObjectReferenceP[Model]],
			True
		],

		Test["Returns a pattern which matches a Model object of the type at the given level:",
			MatchQ[Model[Example, "id-string"], ObjectReferenceP[Model[Example]]],
			True
		],

		Test["Returns a pattern which matches an Object of the type at the given level:",
			MatchQ[Object[Example, "id-String"], ObjectReferenceP[Object[Example]]],
			True
		],

		Example[{Additional, "Does not match a link:"},
			MatchQ[Link[Object[Example, Data, "my-object"]], ObjectReferenceP[]],
			False
		],

		Example[{Additional, "Does not match a packet:"},
			MatchQ[<|Type -> Object[Example, Person, Emerald]|>, ObjectReferenceP[]],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*Fields*)


DefineTests[
	Fields,
	{
		Test["Returns a list of fields for all defined types:",
			Fields[],
			{((Object | Model)[___Symbol][_Symbol, Repeated[_Symbol | _Integer, {0, 1}]])...}
		],

		Example[{Basic, "Returns a list of fields for a given object type:"},
			Fields[Object[Protocol]],
			{Object[Protocol][_Symbol, Repeated[_Integer | _Symbol, {0, 1}]]..}
		],

		Example[{Basic, "Return all fields for a more specific type; this output will include fields from all higher-level types:"},
			Fields[Object[Protocol, HPLC]],
			{Object[Protocol, HPLC][_Symbol, Repeated[_Integer | _Symbol, {0, 1}]]..}
		],

		Test["Returns empty list if type is not defined:",
			Fields[Object[Does, Not, Exist]],
			{}
		],

		Test["Fields which have not been defined do not exist in the Fields list:",
			MemberQ[Fields[], Object[My, Type][NewField]],
			False
		],

		Example[{Basic, "Returns a list of fields for the given Model type:"},
			Fields[Model[Container, Vessel]],
			{Model[Container, Vessel][_Symbol, Repeated[_Integer | _Symbol, {0, 1}]]..}
		],

		Test["Returns a list of fields for all Object types:",
			Fields[Object],
			{Object[__Symbol][_Symbol, Repeated[_Integer | _Symbol, {0, 1}]]..}
		],

		Test["Returns a list of fields for all Model types:",
			Fields[Model],
			{Model[__Symbol][_Symbol, Repeated[_Integer | _Symbol, {0, 1}]]..}
		],

		Example[{Additional, "Returns a single list of all fields in all the given types:"},
			Fields[{Model[Container], Object[Protocol, HPLC]}],
			{
				Alternatives[
					Model[Container][_Symbol, Repeated[_Integer | _Symbol, {0, 1}]],
					Object[Protocol, HPLC][_Symbol, Repeated[_Integer | _Symbol, {0, 1}]]
				]..
			}
		],

		Test["Contains a field entry for each index in indexed fields as well as without their indices:",
			ContainsAll[
				Fields[Object[Example, Data]],
				{
					Object[Example, Data][GroupedMultipleAppendRelation],
					Object[Example, Data][GroupedMultipleAppendRelation, 1],
					Object[Example, Data][GroupedMultipleAppendRelation, 2]
				}
			],
			True
		],

		Test["Contains automatically generated keys Object, ID, Type, Model, DateCreated, Author for Objects:",
			ContainsAll[
				Fields[Object[Example, Data]],
				{
					Object[Example, Data][ID],
					Object[Example, Data][Object],
					Object[Example, Data][Type],
					Object[Example, Data][Model],
					Object[Example,Data][DateCreated],
					Object[Example,Data][CreatedBy]
				}
			],
			True
		],

		Test["Contains automatically generated keys Object, ID, Type, Objects, DateCreated, Author for Models:",
			ContainsAll[
				Fields[Model[Example, Data]],
				{
					Model[Example, Data][ID],
					Model[Example, Data][Object],
					Model[Example, Data][Type],
					Model[Example, Data][Objects],
					Model[Example,Data][DateCreated],
					Model[Example,Data][CreatedBy]
				}
			],
			True
		],

		Example[{Additional,"Given an object returns the non-null fields in the object:"},
			ContainsAll[
				With[
					{object=Upload[<|Type->Object[Example,Data]|>,Verbose->False]},

					Fields[object]
				],
				{
					Object[Example,Data][Object],
					Object[Example,Data][Type],
					Object[Example,Data][ID],
					Object[Example,Data][ComputableName],
					Object[Example,Data][DateCreated],
					Object[Example,Data][CreatedBy],
					Object[Example,Data][Published],
					Object[Example,Data][Valid],
					Object[Example,Data][DeveloperObject]
				}
			],
			True
		],

		Example[{Additional, "Given an object returns an empty list of object does not exist:"},
			Fields[Object[Example, Data, "id:doesnotexist"]],
			{},
			Messages :> {
				Message[Download::ObjectDoesNotExist, "{Object[Example, Data, \"id:doesnotexist\"]}"]
			}
		],

		Example[{Additional,"Given a link to an object returns the non-empty fields in the object:"},
			ContainsAll[
				With[
					{object=Upload[<|Type->Model[Example,Data]|>,Verbose->False]},

					Fields[Link[object,Objects]]
				],
				{
					Model[Example,Data][Object],
					Model[Example,Data][Type],
					Model[Example,Data][ID],
					Model[Example,Data][DateCreated],
					Model[Example,Data][CreatedBy],
					Model[Example,Data][Published],
					Model[Example,Data][Valid],
					Model[Example,Data][DeveloperObject]
				}
			],
			True
		],

		Example[{Options, Output, "Output -> Short returns only the symbols for the fields in a type:"},
			Sort@Fields[Object[Transaction], Output -> Short],
			{_Symbol..}
		],

		Example[{Options, Output, "Output -> Short returns only the symbols for the non-empty fields in an object:"},
			ContainsAll[
				With[
					{object=Upload[<|Type->Object[Example,Data],Replace[IndexedSingle]->{12,Null,Null}|>,Verbose->False]},

					Fields[object,Output->Short]
				],
				{ID,Object,Type,IndexedSingle,ComputableName,DateCreated,CreatedBy,Published,Valid,DeveloperObject}
			],
			True
		],

		Test["An IndexedSingle field is non-empty if any index has a value:",
			ContainsAll[
				With[
					{object=Upload[<|Type->Object[Example,Data],Replace[IndexedSingle]->{12,Null,Null}|>,Verbose->False]},

					Fields[object]
				],
				{
					Object[Example,Data][Object],
					Object[Example,Data][Type],
					Object[Example,Data][ID],
					Object[Example,Data][ComputableName],
					Object[Example,Data][IndexedSingle],
					Object[Example,Data][DateCreated],
					Object[Example,Data][CreatedBy],
					Object[Example,Data][Published],
					Object[Example,Data][Valid],
					Object[Example,Data][DeveloperObject]
				}
			],
			True
		],

		Test["A Single field is non-empty if the value is non-null:",
			ContainsAll[
				With[
					{object=Upload[<|Type->Object[Example,Data],Name->CreateUUID[]|>,Verbose->False]},

					Fields[object]
				],
				{
					Object[Example,Data][Object],
					Object[Example,Data][Type],
					Object[Example,Data][ID],
					Object[Example,Data][ComputableName],
					Object[Example,Data][Name],
					Object[Example,Data][DateCreated],
					Object[Example,Data][CreatedBy],
					Object[Example,Data][Published],
					Object[Example,Data][Valid],
					Object[Example,Data][DeveloperObject]
				}
			],
			True
		],

		Test["A Multiple field is non-empty if there is at least 1 value:",
			ContainsAll[
				With[
					{object=Upload[<|Type->Object[Example,Data],Replace[Random]->{1}|>,Verbose->False]},

					Fields[object]
				],
				{
					Object[Example,Data][Object],
					Object[Example,Data][Type],
					Object[Example,Data][ID],
					Object[Example,Data][ComputableName],
					Object[Example,Data][Random],
					Object[Example,Data][DateCreated],
					Object[Example,Data][CreatedBy],
					Object[Example,Data][Published],
					Object[Example,Data][Valid],
					Object[Example,Data][DeveloperObject]
				}
			],
			True
		],

		Test["A Multiple field RuleDelayed is considered non-empty:",
			ContainsAll[
				With[
					{object=Upload[<|Type->Object[Example,Data],Replace[Random]->Table[1,{300}]|>,Verbose->False]},

					Fields[object]
				],
				{
					Object[Example,Data][Object],
					Object[Example,Data][Type],
					Object[Example,Data][ID],
					Object[Example,Data][ComputableName],
					Object[Example,Data][Random],
					Object[Example,Data][DateCreated],
					Object[Example,Data][CreatedBy],
					Object[Example,Data][Published],
					Object[Example,Data][Valid],
					Object[Example,Data][DeveloperObject]
				}
			],
			True
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*FieldQ*)


DefineTests[
	FieldQ,
	{
		Example[{Basic, "Returns True if given Object field exists in a type:"},
			FieldQ[Object[Example, Data][Model]],
			True
		],

		Example[{Basic, "Returns True if given indexed Object field exists in a type:"},
			FieldQ[Object[Example, Data][GroupedMultipleAppendRelation, 2]],
			True
		],

		Example[{Additional, "Returns True if given Model field exists in a type:"},
			FieldQ[Model[Example, Data][Name]],
			True
		],

		Example[{Basic, "Returns False if given Model field does not exist:"},
			FieldQ[Model[Example, Data][DoesNotExist]],
			False
		],

		Example[{Basic, "Returns False if not given a proper field expression:"},
			FieldQ[Model],
			False
		],

		Example[{Additional, "Returns False if given Object field does not exist:"},
			FieldQ[Object[Data][DoesNotExist]],
			False
		],

		Example[{Additional, "Returns False if field exists but index does not:"},
			FieldQ[Object[Example, Data][GroupedMultipleAppendRelation, 4]],
			False
		],


		Example[{Options, Output, "Match on a short field:"},
			FieldQ[Model, Output -> Short],
			True
		],
		Example[{Options, Output, "Does not match full field if Output->Short:"},
			FieldQ[Object[Example, Data][Model], Output -> Short],
			False
		],
		Example[{Options, Output, "Match on a full field:"},
			FieldQ[Object[Example, Data][Model], Output -> Full],
			True
		],
		Example[{Options, Output, "Does not match short field if Output->Full:"},
			FieldQ[Model, Output -> Full],
			False
		],

		Example[{Options, Links, "Match nested link fields:"},
			FieldQ[Model[Name], Links -> True],
			True
		],
		Example[{Options, Links, "Does not match nested fields if Links option is not true:"},
			FieldQ[Model[Name], Links -> False],
			False
		],
		Example[{Options, Links, "Can match several layers of nesting:"},
			FieldQ[Author[ProtocolsAuthored][StatusLog], Links -> True],
			True
		],
		Example[{Options, Links, "Can mix in Part for grouped or named multiple fields:"},
			FieldQ[Author[ProtocolsAuthored][StatusLog][[All, 3]][SafetyTrainingLog][[1, 1]], Links -> True],
			True
		],
		Test["Return False with no warnings:",
			FieldQ[Author[ProtocolsAuthored][StatusLog][[All, 3]][SafetyTrainingLog][[1, 1]], Links -> False],
			False
		],
		Test["Double through link:", FieldQ[Author[ProtocolsAuthored][StatusLog], Links -> True], True],
		Test["Second element through links:", FieldQ[Author[ProtocolsAuthored][StatusLog][[2]], Links -> True], True],
		Test["Multiple Parts, Links->False:", FieldQ[Field[Products[KitComponents][[ProductModel]][Composition][[2]]], Links -> True], True],
		Test["Multiple Parts 2, Links->False:", FieldQ[Field[CompletedTasks[[3]][FinancingTeams][Administrators][Name]], Links -> True], True],
		Test["Length of field, Links->False:", FieldQ[Length[CheckpointProgress], Links -> True], True],
		Test["Bad format 1, Links->False:", FieldQ[CheckpointProgress[[2, All]], Links -> True], False],
		Test["Multiple Parts, Links->False:", FieldQ[Field[Products[KitComponents][[ProductModel]][Composition][[2]]], Links -> False], False],
		Test["Multiple Parts 2, Links->False:", FieldQ[Field[CompletedTasks[[3]][FinancingTeams][Administrators][Name]], Links -> False], False],
		Test["Length of field, Links->False:", FieldQ[Length[CheckpointProgress], Links -> False], False],
		Test["Double through link:", FieldQ[Author[ProtocolsAuthored][StatusLog], Links -> False], False],
		Test["Second element through links:", FieldQ[Author[ProtocolsAuthored][StatusLog][[2]], Links -> False], False],
		Test["Bad format 1, Links->False:", FieldQ[CheckpointProgress[[2, All]], Links -> False], False]

	}
];

DefineTests[downloadableFieldQ, {

	Test["Symbol:", downloadableFieldQ[Author], True],
	Test["Second element:", downloadableFieldQ[CheckpointProgress[[2]]], True],
	Test["First element in second row:", downloadableFieldQ[CheckpointProgress[[2, 1]]], True],
	Test["Second column:", downloadableFieldQ[CheckpointProgress[[All, 2]]], True],
	Test["All of one name in a named multiple:", downloadableFieldQ[IncubateSamplePreparation[[All, Incubate]]], True],
	Test["One instance of a name in a named multiple:", downloadableFieldQ[IncubateSamplePreparation[[2, Incubate]]], True],
	Test["Through link:", downloadableFieldQ[Author[Name]], True],
	Test["Double through link:", downloadableFieldQ[Author[ProtocolsAuthored][StatusLog]], True],
	Test["Second element through links:", downloadableFieldQ[Author[ProtocolsAuthored][StatusLog][[2]]], True],
	Test["Third column through links:", downloadableFieldQ[Author[ProtocolsAuthored][StatusLog][[All, 3]]], True],
	Test["Through link from the third column throuh links:", downloadableFieldQ[Author[ProtocolsAuthored][StatusLog][[All, 3]][SafetyTrainingLog]], True],
	Test["First element through link of the third column through links:", downloadableFieldQ[Author[ProtocolsAuthored][StatusLog][[All, 3]][SafetyTrainingLog][[1, 1]]], True],
	Test["Symbol Part:", downloadableFieldQ[Field[Products[KitComponents][[ProductModel]]]], True],
	Test["Multiple Parts:", downloadableFieldQ[Field[Products[KitComponents][[ProductModel]][Composition][[2]]]], True],
	Test["Multiple Parts 2:", downloadableFieldQ[Field[CompletedTasks[[3]][FinancingTeams][Administrators][Name]]], True],
	Test["Length of field:", downloadableFieldQ[Length[CheckpointProgress]], True],

	Test["Bad format 1:", downloadableFieldQ[CheckpointProgress[[2, All]]], False],
	Test["Bad format 2:", downloadableFieldQ[Length[CheckpointProgress[[2]]]], False]

}];


(* ::Subsubsection::Closed:: *)
(*FieldP*)


DefineTests[
	FieldP,
	{
		Example[{Basic, "Returns a pattern which matches an Object/Model field in any defined type:"},
			MatchQ[Object[Example, Person, Emerald][Name], FieldP[]],
			True
		],

		Example[{Basic, "Returns a pattern that matches any field in the defined Model type:"},
			MatchQ[Model[Example][Objects], FieldP[Model[Example]]],
			True
		],

		Example[{Basic, "Returns a pattern that does not match a type that is not defined:"},
			MatchQ[Object[Does, Not, Exist][MyField], FieldP[Object[Does, Not, Exist]]],
			False
		],

		Example[{Basic, "Returns a pattern that matches an indexed field in a given Object type:"},
			MatchQ[Object[Example, Data][GroupedMultipleAppendRelation, 1], FieldP[Object[Example, Data]]],
			True
		],

		Example[{Additional, "Does not evaluate if not given an expression in the form of an Object/Model type:"},
			FieldP[123.4],
			HoldPattern[FieldP[123.4]]
		],

		Example[{Additional, "Returns a pattern that matches any fields of any defined Model types:"},
			MatchQ[Model[Example, Data][Objects], FieldP[Model]],
			True
		],

		Example[{Additional, "Returns a pattern that does not match any Object fields, only Model fields:"},
			MatchQ[Object[Example, Data][Name], FieldP[Model]],
			False
		],

		Example[{Additional, "Returns a pattern that matches any fields of any defined Object types:"},
			MatchQ[Object[Example, Data][Random], FieldP[Object]],
			True
		],

		Example[{Additional, "Returns a pattern that matches any fields in any of the given types:"},
			MatchQ[Object[Example, Data][Random], FieldP[{Object[Example, Data], Model[Example]}]],
			True
		],

		Example[{Additional, "Returns a pattern that does not match any Model fields, only Object fields:"},
			MatchQ[Model[Example, Data][Objects], FieldP[Object]],
			False
		],

		Example[{Options, Output, "Output -> Short matches only against field symbols and not fully qualified fields:"},
			MatchQ[Object[Example, Data][Name], FieldP[Object, Output -> Short]],
			False
		],

		Example[{Options, Output, "Output -> Short will match a symbol as long as it is a field in the given type:"},
			MatchQ[Temperature, FieldP[Object[Example, Data], Output -> Short]],
			True
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*LinkP*)


DefineTests[
	LinkP,
	{
		Example[{Basic, "Match a new link to a specific field:"},
			MatchQ[
				Link[Object[Sample, "id:123"], SingleRelation],
				LinkP[]
			],
			True
		],

		Example[{Basic, "Match a new one-way link:"},
			MatchQ[
				Link[Object[Protocol, HPLC, "id:8a7bvabhhg"]],
				LinkP[]
			],
			True
		],
		Example[{Options, IncludeTemporalLinks, "Extends the pattern to Temporal versions of the link:"},
			MatchQ[
				Link[Object[Protocol, HPLC, "id:8a7bvabhhg"], DateObject[]],
				LinkP[IncludeTemporalLinks -> True]
			],
			True
		],
		Example[{Options, IncludeTemporalLinks, "Setting IncludeTemporalLinks->True still matches on links without a Date:"},
			MatchQ[
				Link[Object[Protocol, HPLC, "id:8a7bvabhhg"]],
				LinkP[IncludeTemporalLinks -> True]
			],
			True
		],
		Example[{Additional, "Match an existing one-way link with a link ID:"},
			MatchQ[
				Link[Object[Sample, "My Favourite Sample"], "8a7gdvsz"],
				LinkP[]
			],
			True
		],

		Example[{Additional, "Fields", "Restrict the match to a specific type/field:"},
			MatchQ[
				Link[Object[Protocol, HPLC, "id:8afadfdz8"], Author, "8a9gb72"],
				LinkP[Object[Protocol, HPLC][Author]]
			],
			True
		],

		Example[{Basic, "Restrict the match to a specific object ID:"},
			MatchQ[
				Link[Object[Container, Plate, "id:va78yga2"], Container, "908agcz"],
				LinkP[Object[Container, Plate, "id:va78yga2"]]
			],
			True
		],

		Test["Does not match a Link to a specific object if the object-id in the link is different:",
			MatchQ[
				Link[Object[Example, Data, "my-object"], SingleRelation, "8agjh3"],
				LinkP[Object[Example, Data, "my-other-object"]]
			],
			False
		],

		Example[{Basic, "Match any existing Link to an indexed field with a link-id:"},
			MatchQ[
				Link[Object[Container, Vessel, "id:auag62agf"], Contents, 2, "a176fg8a"],
				LinkP[]
			],
			True
		],

		Example[{Additional, "Types", "Match only links to objects of a given type:"},
			MatchQ[
				Link[Object[Sample, "id:87a9g723"], Container, "9ag37"],
				LinkP[Object[Container]]
			],
			False
		],

		Example[{Additional, "Fields", "Match links to objects of a given type and given fields:"},
			MatchQ[
				Link[Object[Sample, "id:78f1jghav"], Model, "xcva673"],
				LinkP[{Object[Analysis, Fit], Object[Sample]}, {Model, Data}]
			],
			True
		],

		Test["Matches a Link to a specific object and field:",
			MatchQ[
				Link[Object[Example, Data, "my-object"], SingleRelation],
				LinkP[Object[Example, Data, "my-object"], SingleRelation]
			],
			True
		],

		Test["Does not match a link to an object if the field does not match:",
			MatchQ[
				Link[Object[Example, Data, "my-object"], MultipleAppendRelation],
				LinkP[Object[Example, Data, "my-object"], SingleRelation]
			],
			False
		],

		Test["Does not match a link to an object if given Model:",
			MatchQ[
				Link[Object[Example, Data, "my-object"], MultipleAppendRelation],
				LinkP[Model]
			],
			False
		],

		Test["Does not match a link to an Model if given Object:",
			MatchQ[
				Link[Model[Example, Data, "my-object"]],
				LinkP[Object]
			],
			False
		],

		Example[{Additional, "Types", "Match a link to any object (but not a Model object):"},
			MatchQ[
				Link[Object[Container, Plate, "id:7aghhcva"], Contents, 2],
				LinkP[Object]
			],
			True
		],

		Example[{Additional, "Match a link to only model objects:"},
			MatchQ[
				Link[Object[Container, Plate, "id:7aghhcva"], Contents, 2],
				LinkP[Model]
			],
			False
		],

		Example[{Additional, "Names", "Matches an object with an ID to its named object:"},
			MatchQ[
				Link[Object[Sample, "Download Test Oligomer"][Object]],
				LinkP[Object[Sample, "Download Test Oligomer"]]
			],
			True,
			SetUp :> (setupDownloadExampleObjects[])
		],

		Test["Matches a named object with it's ID when the ID is given in the pattern:",
			MatchQ[
				Link[Object[Sample, "Download Test Oligomer"]],
				LinkP[Object[Sample, "Download Test Oligomer"][Object]]
			],
			True,
			SetUp :> (setupDownloadExampleObjects[])
		],

		Example[{Additional, "Subfields", "Matches a link to an indexed subfield:"},
			MatchQ[
				Link[Object[Container, Plate, "id:-1"], Contents, 2],
				LinkP[Object[Container, Plate], Contents, 2]
			],
			True
		],

		Example[{Additional, "Subfields", "Matches a link to a named subfield:"},
			MatchQ[
				Link[Object[Example, Data, "id:-1"], NamedField, FirstColumn],
				LinkP[Object[Example, Data], NamedField, FirstColumn]
			],
			True
		],

		Test["Does not match a link when provided an empty list:",
			MatchQ[
				Link[Model[Example, Data, "my-object"]],
				LinkP[{}]
			],
			False
		]
	}
];

DefineTests[
	TemporalLinkDate,
	{
		Example[{Basic, "TemporalLinkDate returns the date on a Temporal Link:"},
			TemporalLinkDate[Link[Object["Some Object"], SingleRelation, DateObject["Jan 1 2020"]]],
			DateObject["Jan 1 2020"]
		]
	}
];

DefineTests[
	RemoveLinkID,
	{
		Example[{Basic, "Removed the ID from a link:"},
			RemoveLinkID[Link[Object[Sample, "id:123"], SingleRelation, "8a9gb72"]],
			Link[Object[Sample, "id:123"], SingleRelation]
		],
		Example[{Basic, "Keeps Temporal Links intact while removing the id:"},
			RemoveLinkID[Link[Object[Sample, "id:123"], SingleRelation, "8a9gb72", DateObject["Jan 1 2020"]]],
			Link[Object[Sample, "id:123"], SingleRelation, DateObject["Jan 1 2020"]]
		],
		Example[{Basic, "If the link does not have an ID, keeps the link intact:"},
			RemoveLinkID[Link[Object[Sample, "id:123"], SingleRelation]],
			Link[Object[Sample, "id:123"], SingleRelation]
		],
		Example[{Basic, "If the temporal link does not have an ID, keeps the temporal link intact:"},
			RemoveLinkID[Link[Object[Sample, "id:123"], SingleRelation, DateObject["Jan 1 2020"]]],
			Link[Object[Sample, "id:123"], SingleRelation, DateObject["Jan 1 2020"]]
		]
	}
];

DefineTests[
	LinkedObject,
	{
		Example[{Basic, "Grab the object from the link and ignore everything else:"},
			LinkedObject[Link[Object[Sample, "id:123"], SingleRelation, "8a9gb72"]],
			Object[Sample, "id:123"]
		],
		Example[{Basic, "Grab the object from the temporal links and ignore everything else:"},
			LinkedObject[Link[Object[Sample, "id:123"], SingleRelation, "8a9gb72", Now]],
			Object[Sample, "id:123"]
		],
		Example[{Basic, "Grab the object from the temporal links even when there is nothing else:"},
			LinkedObject[Link[Object[Sample, "id:123"]]],
			Object[Sample, "id:123"]
		]
	}
];

(*
	Repeat all the tests with Temporal Links
*)

DefineTests[
	TemporalLinkP,
	{
		Example[{Basic, "Temporal Links are an extension to Links and represent an Object at a specific point in time. Temporal Links share the same structure as links with a date appended:"},
			MatchQ[
				Append[Link[Object[Sample, "id:123"]], DateObject[]],
				TemporalLinkP[]],
			True
		],
		Example[{Basic, "By default, LinkP[] does not accept Temporal Links:"},
			MatchQ[
				Link[Object[Sample, "id:123"], randomDate],
				LinkP[]],
			False
		],
		Example[{Basic, "The Temporal option on LinkP[] allows the pattern to include Temporal Links:"},
			MatchQ[
				Link[Object[Sample, "id:123"], randomDate],
				LinkP[IncludeTemporalLinks -> True]],
			True
		],
		Example[{Basic, "TemporalLinkP[] matches on Temporal Links, but does not match on Regular Links:"},
			{
				MatchQ[
					Link[Object[Sample, "id:123"], randomDate],
					TemporalLinkP[]
				],
				MatchQ[
					Link[Object[Sample, "id:123"]],
					TemporalLinkP[]
				]
			},
			{True, False}
		],
		Example[{Additional, "Downloading a Temporal Link is equivalent to Downloading the object at the time specified by the link:"},
			{
				Download[Link[farObject, startTime], StringData],
				Download[farObject, StringData, Date -> startTime],
				Download[farObject, StringData]
			},
			{"Old Name", "Old Name", "New Name"}
		],
		Example[{Additional, "Downloading Through a Temporal Link gets Values from Historical Version of the Object:"},
			Download[closeObject, OneWayLinkTemporal[StringData]],
			"Old Name"
		],
		Example[{Additional, "If a back link field is defined as Temporal, then the backlink is a temporal link that points back to the object at the time at which the backlink was created:"},
			Download[farObject, DataAnalysis],
			TemporalLinkP[closeObject]
		],
		Example[{Additional, "Inspecting a Temporal Link shows the historical version of that object:"},
			{
				Download[farObject, StringData],
				Download[farObject, StringData, Date -> startTime],
				Inspect[Link[farObject, startTime]]
			},
			{"New Name", "Old Name", _}
		],
		Example[{Additional, "You can search through Temporal Links for historical data:"},
			Module[{result},
				result=First@Search[Object[Example, Data], OneWayLinkTemporal[StringData] == "Old Name", MaxResults -> 1];
				{Download[closeObject, OneWayLinkTemporal][Object][StringData], Download[closeObject, OneWayLinkTemporal[StringData]]}
			],
			{"New Name", "Old Name"}
		],
		Example[{Additional, "Temporal Links and Links can be chained together in a Search. Dates can also be provided to search on previous temporal links within Constellation:"},
			Search[Object[Example, Data],
				MultipleAppendRelation[OneWayLinkTemporal][StringData] == "Old Name",
				MaxResults -> 1, Date -> Now],
			{ObjectP[]..}
		],
		Example[{Additional, "Temporal Links and Links can be chained together in a Download:"},
			First@Download[distantObject, MultipleAppendRelation[OneWayLinkTemporal][StringData]],
			"Old Name"
		],
		Example[{Additional, "Match a new link to a specific field:"},
			MatchQ[
				Link[Object[Sample, "id:123"], SingleRelation, randomDate],
				TemporalLinkP[]
			],
			True
		],

		Example[{Additional, "Match a new one-way link:"},
			MatchQ[
				Link[Object[Protocol, HPLC, "id:8a7bvabhhg"], randomDate],
				TemporalLinkP[]
			],
			True
		],

		Example[{Additional, "Match an existing one-way link with a link ID:"},
			MatchQ[
				Link[Object[Sample, "My Favourite Sample"], "8a7gdvsz", randomDate],
				TemporalLinkP[]
			],
			True
		],

		Example[{Additional, "Fields", "Restrict the match to a specific type/field:"},
			MatchQ[
				Link[Object[Protocol, HPLC, "id:8afadfdz8"], Author, "8a9gb72", randomDate],
				TemporalLinkP[Object[Protocol, HPLC][Author]]
			],
			True
		],

		Example[{Additional, "Restrict the match to a specific object ID:"},
			MatchQ[
				Link[Object[Container, Plate, "id:va78yga2"], Container, "908agcz", randomDate],
				TemporalLinkP[Object[Container, Plate, "id:va78yga2"]]
			],
			True
		],

		Test["Does not match a Link to a specific object if the object-id in the link is different:",
			MatchQ[
				Link[Object[Example, Data, "my-object"], SingleRelation, "8agjh3", randomDate],
				TemporalLinkP[Object[Example, Data, "my-other-object"]]
			],
			False
		],

		Example[{Additional, "Match any existing Link to an indexed field with a link-id:"},
			MatchQ[
				Link[Object[Container, Vessel, "id:auag62agf"], Contents, 2, "a176fg8a", randomDate],
				TemporalLinkP[]
			],
			True
		],

		Example[{Additional, "Types", "Match only links to objects of a given type:"},
			MatchQ[
				Link[Object[Sample, "id:87a9g723"], Container, "9ag37", randomDate],
				TemporalLinkP[Object[Container]]
			],
			False
		],

		Example[{Additional, "Fields", "Match links to objects of a given type and given fields:"},
			MatchQ[
				Link[Object[Sample, "id:78f1jghav"], Model, "xcva673", randomDate],
				TemporalLinkP[{Object[Analysis, Fit], Object[Sample]}, {Model, Data}]
			],
			True
		],

		Test["Matches a Link to a specific object and field:",
			MatchQ[
				Link[Object[Example, Data, "my-object"], SingleRelation, randomDate],
				TemporalLinkP[Object[Example, Data, "my-object"], SingleRelation]
			],
			True
		],

		Test["Does not match a link to an object if the field does not match:",
			MatchQ[
				Link[Object[Example, Data, "my-object"], MultipleAppendRelation, randomDate],
				TemporalLinkP[Object[Example, Data, "my-object"], SingleRelation]
			],
			False
		],

		Test["Does not match a link to an object if given Model:",
			MatchQ[
				Link[Object[Example, Data, "my-object"], MultipleAppendRelation, randomDate],
				TemporalLinkP[Model]
			],
			False
		],

		Test["Does not match a link to an Model if given Object:",
			MatchQ[
				Link[Model[Example, Data, "my-object"], randomDate],
				TemporalLinkP[Object]
			],
			False
		],

		Example[{Additional, "Types", "Match a link to any object (but not a Model object):"},
			MatchQ[
				Link[Object[Container, Plate, "id:7aghhcva"], Contents, 2, randomDate],
				TemporalLinkP[Object]
			],
			True
		],

		Example[{Additional, "Match a link to only model objects:"},
			MatchQ[
				Link[Object[Container, Plate, "id:7aghhcva"], Contents, 2, randomDate],
				TemporalLinkP[Model]
			],
			False
		],

		Example[{Additional, "Names", "Matches an object with an ID to its named object:"},
			MatchQ[
				Link[Object[Sample, "Download Test Oligomer"][Object], randomDate],
				TemporalLinkP[Object[Sample, "Download Test Oligomer"]]
			],
			True,
			SetUp :> (setupDownloadExampleObjects[])
		],

		Test["Matches a named object with it's ID when the ID is given in the pattern:",
			MatchQ[
				Link[Object[Sample, "Download Test Oligomer"], randomDate],
				TemporalLinkP[Object[Sample, "Download Test Oligomer"][Object]]
			],
			True,
			SetUp :> (setupDownloadExampleObjects[])
		],

		Example[{Additional, "Subfields", "Matches a link to an indexed subfield:"},
			MatchQ[
				Link[Object[Container, Plate, "id:-1"], Contents, 2, randomDate],
				TemporalLinkP[Object[Container, Plate], Contents, 2]
			],
			True
		],

		Example[{Additional, "Subfields", "Matches a link to a named subfield:"},
			MatchQ[
				Link[Object[Example, Data, "id:-1"], NamedField, FirstColumn, randomDate],
				TemporalLinkP[Object[Example, Data], NamedField, FirstColumn]
			],
			True
		],

		Test["Make sure non temporal links do not match the temporal link pattern:",
			NoneTrue[
				{
					Link[Object[Example, Data, "id:-1"], NamedField, FirstColumn],
					Link[Object[Container, Plate, "id:-1"], Contents, 2],
					Link[Object[Sample, "Download Test Oligomer"]],
					Link[Object[Sample, "Download Test Oligomer"][Object]],
					Link[Object[Container, Plate, "id:7aghhcva"], Contents, 2],
					Link[Model[Example, Data, "my-object"]],
					Link[Object[Example, Data, "my-object"], MultipleAppendRelation],
					Link[Object[Example, Data, "my-object"], SingleRelation],
					Link[Object[Sample, "id:78f1jghav"], Model, "xcva673"],
					Link[Object[Sample, "id:87a9g723"], Container, "9ag37"],
					Link[Object[Container, Vessel, "id:auag62agf"], Contents, 2, "a176fg8a"],
					Link[Object[Example, Data, "my-object"], SingleRelation, "8agjh3"],
					Link[Object[Container, Plate, "id:va78yga2"], Container, "908agcz"],
					Link[Object[Protocol, HPLC, "id:8afadfdz8"], Author, "8a9gb72"],
					Link[Object[Sample, "My Favourite Sample"], "8a7gdvsz"],
					Link[Object[Protocol, HPLC, "id:8a7bvabhhg"]],
					Link[Object[Sample, "id:123"], SingleRelation]
				},
				MatchQ[TemporalLinkP]
			],
			True
		]
	},
	SymbolSetUp :> (
		randomDate=DateObject["May 9 1996"]; (* Not my birth day or anything *)
		{startTime, farObject, closeObject,distantObject}=setupTemporalLinkTestObjects[]
	)
];

setupTemporalLinkTestObjects[]:=Module[{timeBeforeCloseObjectCreation, farObject, closeObject, distantObject},
	farObject=Upload[Association[Object -> CreateID[Object[Example, Analysis]], StringData -> "Old Name"]];
	Pause[5];
	timeBeforeCloseObjectCreation=Now;
	Pause[5];
	Upload[Association[Object -> farObject, StringData -> "New Name"]];
	closeObject=Upload[Association[Object -> CreateID[Object[Example, Data]], OneWayLinkTemporal -> Link[farObject, timeBeforeCloseObjectCreation],
		Replace[DataAnalysis] -> {Link[farObject, DataAnalysis]}
	]];

	distantObject=Upload[Association[Object -> CreateID[Object[Example, Data]], Append[MultipleAppendRelation] -> {Link[closeObject, MultipleAppendRelationAmbiguous]}]];
	Pause[5];
	{timeBeforeCloseObjectCreation, farObject, closeObject,distantObject}
];


(* ::Subsubsection::Closed:: *)
(*FieldReferenceP*)


DefineTests[
	FieldReferenceP,
	{
		Example[{Basic, "Match a field reference:"},
			MatchQ[
				Object[Example, Data, "id:azcxq", Temperature],
				FieldReferenceP[]
			],
			True
		],

		Example[{Basic, "Does not match a field reference of the wrong type:"},
			MatchQ[
				Object[Example, Data, "id:azcxq", Temperature],
				FieldReferenceP[Object[Example, Person, Emerald]]
			],
			False
		],

		Example[{Basic, "Match a field reference to a pattern requesting its parent type:"},
			MatchQ[
				Object[Example, Data, "id:azcxq", Temperature],
				FieldReferenceP[Object[Example]]
			],
			True
		],

		Test["Matches a field reference if it is the correct type:",
			MatchQ[
				Object[Example, Data, "id:azcxq", Temperature],
				FieldReferenceP[Object[Example, Data]]
			],
			True
		],

		Example[{Basic, "Does not match a field reference with the wrong field:"},
			MatchQ[
				Object[Example, Data, "id:azcxq", Temperature],
				FieldReferenceP[Object[Example, Data], Name]
			],
			False
		],

		Test["Matches a field reference if it is the correct type and field:",
			MatchQ[
				Object[Example, Data, "id:azcxq", Temperature],
				FieldReferenceP[Object[Example, Data], Temperature]
			],
			True
		],

		Example[{Additional, "Matches a field reference if it is one of a list of types:"},
			MatchQ[
				Object[Example, Data, "id:azcxq", Temperature],
				FieldReferenceP[{Object[Example, Data], Object[Example, Person, Emerald]}]
			],
			True
		],

		Test["Does not match a field reference if it is not in the list of types:",
			MatchQ[
				Object[Example, Data, "id:azcxq", Temperature],
				FieldReferenceP[{Object[Data, Chromatography], Object[Example, Person, Emerald]}, Temperature]
			],
			False
		],

		Example[{Additional, "Matches a field reference if it is one of a list of types and fields:"},
			MatchQ[
				Object[Example, Data, "id:azcxq", Temperature],
				FieldReferenceP[{Object[Example, Data], Object[Example, Person, Emerald]}, {Name, Temperature}]
			],
			True
		],

		Test["Does not match a field reference if it is not in the list of fields:",
			MatchQ[
				Object[Example, Data, "id:azcxq", Temperature],
				FieldReferenceP[{Object[Data, Chromatography], Object[Example, Data]}, {Name, GroupedUnits}]
			],
			False
		],

		Example[{Additional, "Does not match a field reference if the index of the field does not match:"},
			MatchQ[
				Object[Example, Data, "id:azcxq", GroupedUnits, 1],
				FieldReferenceP[{Object[Example, Data], Object[Example, Person, Emerald]}, GroupedUnits, 2]
			],
			False
		],

		Test["Matches a field reference if the index of the field does match:",
			MatchQ[
				Object[Example, Data, "id:azcxq", GroupedUnits, 2],
				FieldReferenceP[Object[Example, Data], {GroupedUnits, GroupedMultipleAppendRelation}, {2, 3}]
			],
			True
		]
	}
];


(* ::Subsubsection::Closed:: *)
(* PacketP *)


DefineTests[PacketP,
	{
		Example[{Basic, "Matches a packet that can be uploaded:"},
			MatchQ[
				<|
					Type -> Object[Sample],
					Status -> InUse,
					Replace[VolumeLog] -> {{}}
				|>,
				PacketP[]
			],
			True
		],

		Example[{Basic, "An empty Association is not a valid ChangePacket:"},
			MatchQ[<||>, PacketP[]],
			False
		],

		Example[{Basic, "Returns a pattern that matches a ChangePacket with any sub-type of the specified types:"},
			MatchQ[
				{
					<|Type -> Object[Sample]|>,
					<|Type -> Object[Sample]|>,
					<|Type -> Model[Sample]|>
				},
				{PacketP[{Object[Sample], Model[Sample]}]..}
			],
			True
		],

		Example[{Additional, "Required Fields", "A ChangePacket must have the Object or Type field specified:"},
			MatchQ[
				<|Status -> InUse|>,
				PacketP[]
			],
			False
		],

		Example[{Additional, "Type", "Will not match an association with a Type that does not exist:"},
			MatchQ[
				<|Type -> Model[Does, Not, Exist]|>,
				PacketP[]
			],
			False
		],

		Example[{Additional, "Type", "Specify a list of potential types to match:"},
			MatchQ[
				{<|Type -> Object[User]|>, <|Object -> Object[Sample, "Download Test Oligomer"]|>},
				{Repeated[PacketP[{Object[User], Object[Sample]}], {2}]}
			],
			True
		],

		Example[{Additional, "Fields", "Does not match an Association with keys that are not symbols:"},
			MatchQ[
				<|"Object" -> Model[Sample, "id:123"], "Type" -> Model[Sample], "ID" -> "id:123"|>,
				PacketP[]
			],
			False
		],

		Example[{Additional, "Fields", "If you try a bad operation that is going to match the pattern but will not be Uploaded so tread carefully:"},
			MatchQ[
				<|
					Object -> Model[Sample, "id:123"],
					Type -> Model[Sample],
					BadOperation[StoragePositions] -> {{Link[Model[Container, Plate, "id:456"]],Null}}
				|>,
				PacketP[]
			],
			True
		],

		Example[{Additional, "Fields", "Fields can be specified as required:"},
			With[{pattern=PacketP[Object[Sample], {Status}]},

				{
					MatchQ[<|Type -> Object[Sample]|>, pattern],
					MatchQ[<|Type -> Object[Sample], Status -> InUse|>, pattern]
				}
			],
			{False, True}
		],

		Example[{Additional, "Fields", "Single fields can be specified:"},
			MatchQ[
				<|Type -> Object[Sample], Status -> InUse|>,
				PacketP[Object[Sample], Status]
			],
			True
		],

		Example[{Additional, "Fields", "Operations can be specified as required:"},
			With[{pattern=PacketP[Object[Sample], {Append[StoragePositions]}]},

				{
					MatchQ[<|Type -> Object[Sample]|>, pattern],
					MatchQ[<|Type -> Object[Sample], Append[StoragePositions] -> Null|>, pattern]
				}
			],
			{False, True}
		],

		Example[{Additional, "Fields", "Specifying a field will match an operation on that field:"},
			MatchQ[
				<|Type -> Object[Sample], Append[StoragePositions] -> Null|>,
				PacketP[Object[Sample], StoragePositions]
			],
			True
		],

		Example[{Basic, "Does not match any expression which is not an Association:"},
			MatchQ[12, PacketP[]],
			False
		],

		Test["PacketP matches packets with delayed rules:",
			MatchQ[
				<|
					Type -> Object[Sample],
					ModelName :> SafeEvaluate[
						{Field[Model]},

						Download[Field[Model], Name]
					]
				|>,
				PacketP[]
			],
			True
		],

		Test["PacketP matches packets when Type or Object are specified as fields:",
			MatchQ[
				<|Type -> Object[Sample]|>,
				PacketP[Object[Sample], Type]
			],
			True
		],

		Test["PacketP matches packets with Type and Object when both are specified:",
			MatchQ[
				<|Type -> Object[Sample]|>,
				PacketP[Object[Sample], {Type, Object}]
			],
			False
		],

		Example[{Basic, "Does not evaluate if not given an expression in the form of an Object/Model type:"},
			PacketP[57.9],
			HoldPattern[PacketP[57.9]]
		],

		Example[{Additional, "Returns a pattern that matches any Object:"},
			Map[MatchQ[PacketP[Object]],
				{
					<|Type -> Object[Sample]|>,
					<|Type -> Model[Sample]|>,
					<|Type -> Object[Data]|>
				}
			],
			{True, False, True}
		],

		Example[{Additional, "Returns a pattern that matches any Model:"},
			Map[MatchQ[PacketP[Model]],
				{
					<|Type -> Model[Sample]|>,
					<|Type -> Object[Sample]|>,
					<|Type -> Model[Container]|>
				}
			],
			{True, False, True}
		],

		Test["PacketP matches associations with Transfer[Notebook] keys:",
			MatchQ[
				<|
					Object -> Object[Troubleshooting, Report, "id:1"],
					Transfer[Notebook] -> Link[Object[LaboratoryNotebook, "id:2"], Objects]
				|>,
				PacketP[]
			],
			True
		]

	}
];



(* ::Subsubsection::Closed:: *)
(*ObjectQ*)


DefineTests[
	ObjectQ,
	{
		Example[{Basic, "Returns True if input is an object of a defined type:"},
			ObjectQ[Object[Example, Person, Emerald, "id-string"]],
			True
		],

		Example[{Additional, "Returns True if input is an object of a defined Model type:"},
			ObjectQ[Model[Example, "id-string"]],
			True
		],

		Example[{Basic, "Returns False if input is an object of a type which is not defined:"},
			ObjectQ[Object[Does, Not, Exist, "id-string"]],
			False
		],

		Example[{Additional, "Returns True for an Object with only an ID:"},
			ObjectQ[Object["id-string"]],
			True
		],

		Example[{Additional, "Returns True for a Model with only an ID:"},
			ObjectQ[Model["id-string"]],
			True
		],

		Example[{Additional, "Matches Links to fields:"},
			ObjectQ[Link[Object[Example, Data, "my-object"], SingleRelation]],
			True
		],

		Example[{Basic, "Matches Links:"},
			ObjectQ[Link[Object[Example, Data, "my-object"]]],
			True
		],

		Example[{Additional, "Matches a Link with a link-id and without a Field:"},
			ObjectQ[Link[Object[Example, Data, "my-object"], "link-id"]],
			True
		],

		Example[{Additional, "Matches Links with specific ids:"},
			ObjectQ[Link[Object[Example, Data, "my-object"], SingleRelation, "link-id"]],
			True
		],

		Example[{Basic, "Matches packets:"},
			ObjectQ[<|Type -> Object[Example, Person, Emerald]|>],
			True
		],


		Example[{Basic, "An empty association is not a packet because it is missing the Type key:"},
			ObjectQ[<||>],
			False
		]

	}
];


(* ::Subsubsection::Closed:: *)
(*ObjectP*)


DefineTests[
	ObjectP,
	{
		Example[{Basic, "Returns a pattern which matches an object/model/link/packet of any defined type:"},
			MatchQ[Object[Example, Person, Emerald, "id-string"], ObjectP[]],
			True
		],

		Example[{Basic, "Returns a pattern that matches an Object of any sub-types of the defined Model type:"},
			MatchQ[Model[Example, Data, "id-string"], ObjectP[Model[Example]]],
			True
		],

		Example[{Basic, "Returns a pattern that matches any Object of any sub-types of the list of defined types:"},
			MatchQ[
				{
					Model[Example, Data, "id-string"],
					Object[Example, Analysis, "another-id"]
				},
				{ObjectP[{Model[Example], Object[Example, Analysis]}]..}
			],
			True
		],

		Example[{Basic, "Returns a pattern that does not match a type that is not defined:"},
			MatchQ[Object[Does, Not, Exist, "id-string"], ObjectP[Object[Does, Not, Exist]]],
			False
		],

		Example[{Additional, "Returns a pattern that matches a Model of any Model sub-types:"},
			MatchQ[Model[Example, Data, "id-string"], ObjectP[Model]],
			True
		],

		Example[{Additional, "Returns a pattern that does not match an Object of any Object sub-types:"},
			MatchQ[Object[Example, Data, "id-string"], ObjectP[Model]],
			False
		],

		Example[{Additional, "Returns a pattern that matches an Object of any Object sub-types:"},
			MatchQ[Object[Example, Data, "id-string"], ObjectP[Object]],
			True
		],

		Example[{Additional, "Returns a pattern that does not match a Model of any Model sub-types:"},
			MatchQ[Model[Example, Data, "id-string"], ObjectP[Object]],
			False
		],

		Example[{Additional, "Returns a pattern that matches an Object with no type information:"},
			MatchQ[Object["id-string"], ObjectP[Object]],
			True
		],

		Example[{Additional, "Returns a pattern that matches a Model with no type information:"},
			MatchQ[Model["id-string"], ObjectP[Model]],
			True
		],

		Test["Returns a pattern which matches a Model object of the type at the given level:",
			MatchQ[Model[Example, "id-string"], ObjectP[Model[Example]]],
			True
		],

		Test["Returns a pattern which matches an Object of the type at the given level:",
			MatchQ[Object[Example, "id-String"], ObjectP[Object[Example]]],
			True
		],

		Example[{Additional, "Matches a Link without a link-id:"},
			MatchQ[
				Link[Object[Example, Data, "my-object"], SingleRelation],
				ObjectP[]
			],
			True
		],

		Example[{Additional, "Matches a Link containing object of specific type:"},
			MatchQ[
				Link[Object[Example, Data, "my-object"], SingleRelation],
				ObjectP[Object[Example, Data]]
			],
			True
		],

		Example[{Additional, "Matches only links to objects of a given type:"},
			MatchQ[
				Link[Object[Example, Data, "my-object"], IndexedSingle, 3, "link-id"],
				ObjectP[Object[Example, Person, Emerald]]
			],
			False
		],

		Example[{Additional, "Returns a pattern which matches an packet of any defined type:"},
			MatchQ[<|Type -> Object[Example, Person, Emerald]|>, ObjectP[]],
			True
		],

		Example[{Additional, "Returns a pattern that matches an Object of any sub-types of the defined Model type:"},
			MatchQ[<|Type -> Model[Example, Data]|>, ObjectP[Model[Example]]],
			True
		],

		Example[{Basic, "An empty association is not a packet because it is missing the Type key:"},
			MatchQ[<||>, ObjectP[]],
			False
		],

		Example[{Additional, "Returns a pattern that does not match an Object of any Object sub-types:"},
			MatchQ[<|Type -> Object[Example, Data]|>, ObjectP[Model]],
			False
		],

		Example[{Additional, "Returns a pattern that matches an Object of any Object sub-types:"},
			MatchQ[<|Type -> Object[Example, Data]|>, ObjectP[Object]],
			True
		],

		Example[{Additional, "Returns a pattern that matches a packet with a specific Object Reference:"},
			MatchQ[
				<|Type -> Object[Example, Data], Object -> Object[Example, Data, "id:123"]|>,
				ObjectP[Object[Example, Data, "id:123"]]
			],
			True
		],

		Example[{Additional, "Returns a pattern that does not match a packet with a different Object Reference:"},
			MatchQ[
				<|Type -> Object[Example, Data], Object -> Object[Example, Data, "id:234"]|>,
				ObjectP[Object[Example, Data, "id:123"]]
			],
			False
		],

		Example[{Additional, "Returns a pattern that matches a link of with a specific Object Reference:"},
			MatchQ[
				Link[Object[Example, Data, "id:123"]],
				ObjectP[Object[Example, Data, "id:123"]]
			],
			True
		],

		Example[{Additional, "Returns a pattern that matches a specific Object Reference:"},
			MatchQ[
				Object[Example, Data, "id:123"],
				ObjectP[Object[Example, Data, "id:123"]]
			],
			True
		],

		Example[{Additional, "Required fields can be provided for packets:"},
			Map[MatchQ[ObjectP[Object[Sample], {Name}]],
				{
					<|Type -> Object[Sample], Name -> "Samantha"|>,
					<|Type -> Object[Sample]|>
				}
			],

			{True, False}
		],

		Test["Returns a pattern that matches a specific Object Reference given a link:",
			MatchQ[
				Object[Example, Data, "id:123"],
				ObjectP[Link[Object[Example, Data, "id:123"]]]
			],
			True
		],

		Test["Returns a pattern that does not match a packet with a different Object Reference given a link:",
			MatchQ[
				<|Type -> Object[Example, Data], Object -> Object[Example, Data, "id:234"]|>,
				ObjectP[Link[Object[Example, Data, "id:123"]]]
			],
			False
		],

		Test["Returns a pattern that does not match a link with a different Object Reference given a link:",
			MatchQ[
				Link[Object[Example, Data, "id:234"]],
				ObjectP[Link[Object[Example, Data, "id:123"]]]
			],
			False
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*SameObjectQ*)


DefineTests[
	SameObjectQ,
	{
		Example[{Basic, "Returns True if two objects with only IDs are identical:"},
			With[
				{id=Upload[<|Type -> Object[Example, Data]|>][ID]},
				SameObjectQ[Object[id], Object[id]]
			],
			True
		],

		Example[{Basic, "Returns False if given both Objects and Models:"},
			SameObjectQ[Object["id:123"], Model[Example, "id:45"], Object["id:123"]],
			False
		],

		Example[{Basic, "Returns True if all object forms reference the same Object:"},
			Module[{object, name},
				name=CreateUUID[];
				object=Upload[<|Type -> Object[Example, Data], Name -> name|>];
				id=Last[object];

				SameObjectQ[Object[id], Object[Example, Data, name], object]
			],
			True
		],

		Example[{Basic, "Compares the objects for given links:"},
			Module[{object, name},
				name=CreateUUID[];
				object=Upload[<|Type -> Object[Example, Data], Name -> name|>];

				SameObjectQ[Link[object, "link-id"], Object[Example, Data, name]]
			],
			True
		],

		Example[{Additional, "Returns False if any objects do not exist:"},
			Module[{object, name},
				name=CreateUUID[];
				object=Upload[<|Type -> Object[Example, Data], Name -> name|>];

				SameObjectQ[Object[Example, Data, "Does not exist"], Object[Example, Data, name]]
			],
			False
		],

		Example[{Additional, "Returns True if given a packet and an object with the same ID:"},
			With[{object=Upload[<|Type -> Object[Example, Data]|>]},
				SameObjectQ[object, Download[object]]
			],
			True
		],

		Test["Returns False if objects of the same type with IDs/Names that do not match the same object:",
			With[
				{object=Upload[<|Type -> Object[Example, Data], Name -> CreateUUID[]|>]},

				SameObjectQ[object, Object[Example, Data, CreateUUID[]]]
			],
			False
		],

		Test["Returns True if given fully qualified objects which are the same, one with name and one with ID:",
			Module[
				{name, object},
				name=CreateUUID[];
				object=Upload[<|Type -> Object[Example, Data], Name -> name|>];

				SameObjectQ[object, Object[Example, Data, name]]
			],
			True
		],

		Example[{Additional, "Returns True if given 1 object as an input:"},
			SameObjectQ[Object[Example, Data, "my object"]],
			True
		],

		Example[{Additional, "Returns False if any inputs are not objects:"},
			SameObjectQ[Object[Example, Data, "my object"], 12345],
			False
		],

		Example[{Additional, "Returns True if given no inputs:"},
			SameObjectQ[],
			True
		],

		Test["Returns False if only $Failed in input sequence with more than one item:",
			SameObjectQ[$Failed, $Failed],
			False
		],

		Test["Returns False for two named objects that don't exist:",
			SameObjectQ[Object[Example, Data, "blah"], Object[Example, Data, "something doesnt exist"]],
			False
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*Object*)


DefineTests[
	Object,
	{
		Example[{Basic, "Given an ID, returns the fully qualified object reference:"},
			Object["id:01G6nvkKrNnD"],
			ObjectReferenceP[Object]
		],

		Example[{Basic, "Download a field from an object:"},
			Object[Sample, "Download Test Oligomer"][Container],
			LinkP[],
			SetUp :> (setupDownloadExampleObjects[])
		],

		Example[{Additional, "Returns $Failed if an object does not exist with the given ID:"},
			Object["id:123"],
			$Failed
		],

		Example[{Additional, "Given an ID, returns the fully qualified model reference:"},
			Object["id:rea9jlRvJjB3"],
			ObjectReferenceP[Model]
		],

		Example[{Basic, "Lookup the definition for a type:"},
			LookupTypeDefinition[Object[Sample]],
			{__Rule}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*Model*)


DefineTests[
	Model,
	{
		Example[{Basic, "Find all objects with the model:"},
			Model[Sample, "Download Test Model"][Objects],
			{LinkP[]..},
			SetUp :> (setupDownloadExampleObjects[])
		],
		Example[{Basic, "Lookup the definition for a type:"},
			LookupTypeDefinition[Model[Sample]],
			{__Rule}
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*LinkID*)
DefineTests[
	LinkID,
	{
		Example[{Basic, "Given a Link without LinkID, returns the Null:"},
			Module[{myLink},
				myLink = Link[Object[Container, Vessel, "Test 50 mL Tube 1 (LinkID Test)" <> $SessionUUID]];
				LinkID[myLink]
			],
			Null
		],
		Example[{Basic, "Given a Link with LinkID, returns the id:"},
			Module[{myLink},
				myLink = Link[Object[Container, Vessel, "Test 50 mL Tube 1 (LinkID Test)" <> $SessionUUID],"id:123"];
				LinkID[myLink]
			],
			"id:123"
		],
		Example[{Basic, "Given a TemporalLink, returns the Null if the TemporalLink does not have id:"},
			Module[{myLink},
				myLink = Append[Link[Object[Container, Vessel, "Test 50 mL Tube 1 (LinkID Test)" <> $SessionUUID]],DateObject[]];
				LinkID[myLink]
			],
			Null
		],
		Example[{Basic, "Given a TemporalLink, returns the id if the TemporalLink has id:"},
			Module[{myLink},
				myLink = Append[Link[Object[Container, Vessel, "Test 50 mL Tube 1 (LinkID Test)" <> $SessionUUID],"id:123"],DateObject[]];
				LinkID[myLink]
			],
			"id:123"
		]
	},
	SymbolSetUp :> Module[
		{testObjList, existsFilter, bench, object1},
		testObjList = {
			Object[Container, Bench, "Test Bench (LinkID Test)" <> $SessionUUID],
			Object[Container, Vessel, "Test 50 mL Tube 1 (LinkID Test)" <> $SessionUUID]
		};
		(* clean up any duplicated fake object in db that we will use *)
		existsFilter = DatabaseMemberQ[testObjList];
		EraseObject[PickList[testObjList, existsFilter], Force -> True, Verbose -> False];
		(* pre assign ID *)
		{
			bench,
			object1
		} = Map[CreateID[#[Type]]&, testObjList];
		(* upload bench *)
		Upload[{
			<|
				DeveloperObject -> True,
				Object -> bench,
				Name -> "Test Bench (LinkID Test)" <> $SessionUUID,
				Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects]
			|>
		}];
		(* container *)
		{
			object1
		} = ECL`InternalUpload`UploadSample[
			{
				Model[Container, Vessel, "50mL Tube"]
			},
			ConstantArray[{"Work Surface", bench}, 1],
			Name -> {
				"Test 50 mL Tube 1 (LinkID Test)" <> $SessionUUID
			}
		];
	],
	SymbolTearDown :> Module[
		{testObjList, existsFilter},
		testObjList = {
			Object[Container, Bench, "Test Bench (LinkID Test)" <> $SessionUUID],
			Object[Container, Vessel, "Test 50 mL Tube 1 (LinkID Test)" <> $SessionUUID]
		};
		(* clean up any duplicated fake object in db that we will use *)
		existsFilter = DatabaseMemberQ[testObjList];
		EraseObject[PickList[testObjList, existsFilter], Force -> True, Verbose -> False];
	]
];


(* ::Subsubsection::Closed:: *)
(*ObjectIDQ*)


DefineTests[
	ObjectIDQ,
	{
		Example[{Basic, "Returns True if input is a valid SLL ID:"},
			ObjectIDQ["id:54n6evLeqPd9"],
			True
		],

		Example[{Basic, "Returns False if the ID contains invalid characters:"},
			ObjectIDQ["id:54n6evL@qPd9"],
			False
		],

		Example[{Basic, "Returns False if the ID doesn't start with ID:"},
			ObjectIDQ["54n6evLeqPd9"],
			False
		],

		Example[{Basic, "Returns False if the ID provided is not a string:"},
			ObjectIDQ[TestObjectID],
			False
		],

		Example[{Additional, "Returns False if an object reference is provided:"},
			ObjectIDQ[Object[User, Emerald, Developer, "id:54n6evLeqPd9"]],
			False
		]
	}
];