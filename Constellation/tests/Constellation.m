(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*CreateID*)

DefineTests[
	CreateID,
	{
		Example[{Basic, "Create object references for a set of different types:"},
			CreateID[
				{
					Object[Sample],
					Object[Data, Chromatography],
					Model[Sample]
				}
			],
			{
				ObjectReferenceP[Object[Sample]],
				ObjectReferenceP[Object[Data, Chromatography]],
				ObjectReferenceP[Model[Sample]]
			}
		],

		Example[{Basic, "Create an object reference for a type:"},
			CreateID[Object[Sample]],
			ObjectReferenceP[Object[Sample]]
		],

		Example[{Additional, "Providing a Null type will return a Null object:"},
			CreateID[{Null, Object[Sample], Null}],
			{Null, ObjectReferenceP[Object[Sample]], Null}
		],

		Example[{Additional, "References returned do not exist until data is Uploaded to them:"},
			With[
				{object=CreateID[Object[Sample]]},

				{
					DatabaseMemberQ[object],
					Upload[<|Object -> object, DeveloperObject -> True|>],
					DatabaseMemberQ[object]
				}
			],
			{
				False,
				ObjectReferenceP[Object[Sample]],
				True
			}
		],

		Test["IDs created with CreateID should not be seen by Search until they are used:",
			Module[
				{testTime, newId, check1, check2},
				testTime=Yesterday;
				newId=CreateID[Object[Example, Data]];
				check1=MemberQ[Search[Object[Example, Data], DateCreated >= testTime], newId];
				Upload[<|Object -> newId, Number -> 1.1234, DateCreated -> testTime|>];
				check2=MemberQ[Search[Object[Example, Data], DateCreated >= testTime], newId];
				{check1, check2}
			],
			{False, True}
		],

		Test["IDs created with CreateID should not be seen by Download until they are used:",
			Module[
				{newId, check1, check2},

				newId=CreateID[Object[Example, Data]];
				check1=Download[newId];
				Upload[<|Object -> newId, Number -> 1.1234|>];
				check2=Download[newId, Object];
				{check1, check2}
			],
			{$Failed, ObjectReferenceP[Object[Example, Data]]},
			Messages :> {
				Download::ObjectDoesNotExist
			}
		],

		Test["CreateID works with list of only Nulls:",
			CreateID[{Null, Null}],
			{Null, Null}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*PinObject*)


DefineTests[
	PinObject,
	{
		Example[{Basic, "Create a pin for a protocol:"},
			PinObject[
				Object[Protocol, FPLC, "id:8qZ1VWNmw5ex"]
			],
			Null
		],
		Example[{Basic, "Create a pin for a chemical model:"},
			PinObject[
				Model[Sample, "Milli-Q water"]
			],
			Null
		],
		Example[{Basic, "Create a pin for a list of objects:"},
			PinObject[
				{
					Model[Sample, "Milli-Q water"],
					Model[Instrument, Vortex, "id:dORYzZn0o45q"],
					Object[Sample, "id:54n6evLJJqZL"],
					Object[Sample, "id:01G6nvwDDe9D"]
				}
			],
			Null
		],
		Example[{Basic, "Create a pin for all of the SamplesIn of a protocol:"},
			PinObject[
				Object[Protocol, FPLC, "id:8qZ1VWNmw5ex"][SamplesIn]
			],
			Null
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*toTraversals*)


DefineTests[toTraversals, {
	Test["Single Fields are parsed by toTraversals:",
		{
			toTraversals[A, None],
			toTraversals[A, B == True],
			toTraversals[Random[A], None],
			toTraversals[Random[A], B == True],
			toTraversals[A[[1, 2]], None],
			toTraversals[A[[1, 2]][All], None],
			toTraversals[Repeated[Random[A]], B == True]
		}, {
		Traversal[A],
		Traversal[A],
		Traversal[Random, A],
		Traversal[Random, A],
		Traversal[Query[Key[A], 1, 2]],
		Traversal[Query[Key[A], 1, 2], All],
		Traversal[Repeated[Traversal[Random, A], "B=\"True\""]]
	}
	],

	Test["Nested Parts resolve as a single Part:",
		toTraversals[A[[1]][[2]], None],
		Traversal[Query[Key[A], 1, 2]]
	],

	Test["Single Packets of Fields are parsed by toTraversals:",
		{
			toTraversals[Packet[X, Y], None],
			toTraversals[Packet[X, Y], B == True],
			toTraversals[Packet[Random[X], Y], None],
			toTraversals[Packet[Random[X], Y], B == True]
		}, {
		Traversal[ PacketTarget[{X, Y}]],
		Traversal[ PacketTarget[{X, Y}]],
		Traversal[ PacketTarget[{Traversal[ Random, X], Traversal[Y]}]],
		Traversal[ PacketTarget[{Traversal[ Random, X], Traversal[Y]}]]
	}
	],

	Test["Lists of Fields and Packets are parsed by toTraversals:",
		{
			toTraversals[{A}, {A == True}],
			toTraversals[{A, Packet[B, C]}, {None, None}],
			toTraversals[{A, Packet[B, Random[Length]]}, {None, None}],
			toTraversals[
				{A, Packet[B, Random[Length]], Packet[Repeated[C]], Repeated[D]},
				{None, None, A == C, D == False}
			]
		}, {
		{Traversal[A]},
		{Traversal[A], Traversal[PacketTarget[{B, C}]]},
		{Traversal[A], Traversal[ PacketTarget[{Traversal[B], Traversal[Length[Random]]}]]},
		{
			Traversal[A],
			Traversal[PacketTarget[{Traversal[B], Traversal[Length[Random]]}]],
			Traversal[Repeated[Traversal[C], "A=\"C\""], PacketTarget[{}]],
			Traversal[Repeated[Traversal[D], "D=\"False\""]]
		}
	}
	],

	Test["Lists of lists of Fields and Packets are parsed by toTraversals:",
		{
			toTraversals[{{A}}, {{A == True}}],
			toTraversals[{{A, Packet[B, C]}, {D}}, {{None, None}, {None}}],
			toTraversals[{{A, Packet[B, Random[Length]]}}, {{None, None}}],
			toTraversals[
				{{A, Packet[B, Random[Length]]}, {Packet[Repeated[C]], Repeated[D]}},
				{{None, None}, {A == C, D == False}}
			]
		}, {
		{
			{Traversal[A]}
		}, {
			{Traversal[A], Traversal[PacketTarget[{B, C}]]},
			{Traversal[D]}
		}, {
			{Traversal[A], Traversal[PacketTarget[{Traversal[B], Traversal[Length[Random]]}]]}
		}, {
			{Traversal[A], Traversal[PacketTarget[{Traversal[B], Traversal[Length[Random]]}]]},
			{
				Traversal[Repeated[Traversal[C], "A=\"C\""], PacketTarget[{}]],
				Traversal[Repeated[Traversal[D], "D=\"False\""]]
			}
		}
	}
	],

	Test["Lists of lists of traversal-field-lists are (for now) parsed by toTraversals:",
		{
			(* designed syntax *)
			toTraversals[{{ Field[{A, B}] }}, {{None}}],

			(* possible syntax *)
			toTraversals[{{ {A, B} }}, {{None}}],
			toTraversals[{{ {A}, Packet[B, C] }, { {D, E} }}, {{None, None}, {None}}]
		}, {
		{{ Traversal[{A, B}] }},
		{{ Traversal[{A, B}] }},
		{
			{Traversal[{A}], Traversal[PacketTarget[{B, C}]]},
			{Traversal[{D, E}]}
		}
	}
	],

	Test["Bug in searchClauseString: when nonsensical search clauses are given, they should not execute:",
		{
			toTraversals[A, Random[Length]],
			toTraversals[Packet@A, Random[Length]],
			toTraversals[{A}, {Random[Length]}],
			toTraversals[{{A}}, {{Random[Length]}}]
		}, {
		_Traversal,
		_Traversal,
		{_Traversal},
		{{_Traversal}}
	},
		(* there should be no messages! *)
		Messages :> {
			Random::randt,
			Random::randt,
			Random::randt,
			General::stop
		}
	]

}]; (* end of DefineTests[toTraversals] *)

(* ::Subsubsection::Closed:: *)
(*Field*)

DefineTests[
	Field,
	{
		Example[{Basic, "Use Field to avoid evaluation of a complex field specification:"},
			Module[{field},
				field=Field[Container[Contents][[All, 2]]];

				Download[Object[Sample, "Download Test Oligomer"], field]
			],
			{LinkP[]..}
		],

		Example[{Attributes, HoldAll, "Field does not evaluate its argument:"},
			Field[Taco[[1]]],
			HoldPattern[Field[Taco[[1]]]]
		],

		Example[{Basic, "Represents the field Name in an object:"},
			Field[Name],
			HoldPattern[Field[Name]]
		],

		Example[{Messages, "Deprecated", "The multiple-argument format of Field is no longer guaranteed to work:"},
			Download[Object[Sample, "Download Test Oligomer"], Field[Container, Query[Key[Contents], All, 2]]],
			{LinkP[]..}|LinkP[],
			Messages :> {
				Field::Deprecated,
				Download::FieldDoesntExist
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*EraseLink*)


DefineTests[
	EraseLink,
	{
		Example[{Basic, "Delete a link by its reference:"},
			With[{},
				EraseLink[linkRefs[[2]]];
				{
					MemberQ[testIds[[1]][AppendRelation1], linkRefs[[2]]],
					testIds[[1]][AppendRelation1],
					linkRefs[[2]]
				}
			],
			{False, _List, _Link},
			Variables :> {testIds, linkRefs},
			SetUp :> (
				testIds=Table[CreateID[Object[Example, Data]], {5}];
				Upload[<|Object -> testIds[[1]], Replace[AppendRelation1] -> Map[Link[#, AppendRelation2] &, testIds[[2;;]]]|>];
				linkRefs=testIds[[1]][AppendRelation1];
			)
		],

		Example[{Attributes, Listable, "EraseLink is Listable:"},
			EraseLink[{
				Link[Object[Example, Data, "id:lksjdfkj"], AppendRelation2, "wqW9BP4YrEBO"],
				Link[Object[Example, Data, "id:lksjdfkj"], AppendRelation2, "J8AY5jwzVO5B"],
				Link[Object[Example, Data, "id:lksjdfkj"], AppendRelation2, "8qZ1VWNmo4Vn"]
			}],
			{True, True, True},
			Stubs :> {
				ConstellationRequest[___]:=Association["ModifiedReferences" -> {}]
			}
		],

		Example[{Messages, "AmbiguousLinkError", "EraseLink is Listable:"},
			EraseLink[Link[Object[Example, Data, "id:lksjdfkj"], AppendRelation2]],
			$Failed,
			Messages :> {EraseLink::AmbiguousLinkError},
			Stubs :> {
				ConstellationRequest[___]:=Association["ModifiedReferences" -> {}]
			}
		],

		Test["Deleting backlinks for indexed fields removes all the other sub-field values:",
			With[{},
				EraseLink[linkRefs[[2]]];
				{
					MemberQ[Download[testIds[[1]], GroupedMultipleAppendRelation][[2]], {"test2", linkRefs[[2]]}],
					Length[Download[testIds[[1]], GroupedMultipleAppendRelation]],
					MemberQ[Download[testIds[[3]], GroupedMultipleAppendRelationAmbiguous], {Null, linkRefs[[1]]}],
					Length[Download[testIds[[3]], GroupedMultipleAppendRelationAmbiguous]],
					linkRefs
				}
			],
			{
				False,
				2,
				False,
				0,
				{_Link..}
			},
			Variables :> {testIds, linkRefs},
			SetUp :> (
				testIds=CreateID[Table[Object[Example, Data], {4}]];
				Upload[
					<|Object -> testIds[[1]],
						Append[GroupedMultipleAppendRelation] -> {
							{"test1", Link[testIds[[2]], GroupedMultipleAppendRelationAmbiguous, 2]},
							{"test2", Link[testIds[[3]], GroupedMultipleAppendRelationAmbiguous, 2]},
							{"test3", Link[testIds[[4]], GroupedMultipleAppendRelationAmbiguous, 2]}
						}
					|>
				];
				linkRefs=Download[testIds[[1]], GroupedMultipleAppendRelation[[All, 2]]];
			)
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*DatabaseMemberQ*)


DefineTests[
	DatabaseMemberQ,
	{
		Example[{Basic, "Returns True when the object exists:"},
			With[{object=Upload[<|Type -> Object[Example, Data]|>]},
				DatabaseMemberQ[object]
			],
			True
		],

		Example[{Basic, "Returns False when the object does not exist:"},
			DatabaseMemberQ[Object[Example, Data, "id:doesnotexist"]],
			False
		],

		Test["Returns False on type mismatch:",
			With[{object=Upload[<|Type -> Object[Example, Data]|>]},
				DatabaseMemberQ[Object[Sample, object[ID]]]
			],
			False
		],

		Example[{Basic, "Works on lists:"},
			With[
				{
					objects=Append[
						Upload[Table[<|Type -> Object[Example, Data]|>, {2}]],
						Model[Example, "id:doesnotexist"]
					]
				},

				DatabaseMemberQ[objects]
			],
			{True, True, False}
		],

		Example[{Basic, "Returns True if the object a link points to exists:"},
			With[{object=Upload[<|Type -> Object[Example, Data]|>]},
				DatabaseMemberQ[Link[object, MultipleAppendRelation]]
			],
			True
		],

		Test["Returns False if the object type is not defined locally:",
			With[{object=Upload[<|Type -> Object[Sample], DeveloperObject -> True|>]},
				Block[{TypeQ},
					TypeQ[_]:=False;
					DatabaseMemberQ[object]
				]
			],
			False
		],

		Example[{Additional, "Given a packet, returns True if the Object exists in the database:"},
			With[{object=Upload[<|Type -> Object[Example, Data]|>]},
				DatabaseMemberQ[Download[object]]
			],
			True
		],

		Test["Given an Association without and Object key, returns False:",
			DatabaseMemberQ[Association[Type -> Object[Example, Data]]],
			False
		],

		Test["Given an Association with an Object key that is not an object, returns False:",
			DatabaseMemberQ[Association[Object -> 5, Type -> Object[Example, Data]]],
			False
		],

		Test["Handle unicode characters when checking object names:",
			With[{name="Unicode \[CapitalAHat]\[Micro]m"},
				Quiet[
					Upload[<|Type -> Object[Example, Data], Name -> name|>],
					{Upload::NonUniqueName}
				];
				DatabaseMemberQ[Object[Example, Data, name]]
			],
			True
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*ClearDownload*)


DefineTests[
	ClearDownload,
	{
		Example[{Basic, "Remove all objects from the Download cache:"},
			ClearDownload[],
			Null
		],

		(* NOTE: FastDownload intentionally doesn't support this so we stub it out here so that we can continue testing OldDownload. *)
		Example[{Basic, "Remove an object from the Download cache by its ID string:"},
			With[
				{id=Last[$PersonID]},
				Download[$PersonID];
				If[TrueQ[$FastDownload],
					$PersonID,
					ClearDownload[id]
				]
			],
			$PersonID
		],

		(* NOTE: FastDownload intentionally doesn't support this so we stub it out here so that we can continue testing OldDownload. *)
		Example[{Basic,"Remove a specific set of objects from the Download cache:"},
			With[
				{objects={$PersonID, Object[Sample, "Download Test Oligomer"]}},
				Download[objects];
				If[TrueQ[$FastDownload],
					Download[objects, Object],
					ClearDownload[objects]
				]
			],
			{
				$PersonID,
				Object[Sample, "Download Test Oligomer"][Object]
			}
		],

		Test["Removes ID from object/name/id caches:",
			(
				ClearDownload["id:123"];
				{
					KeyExistsQ[objectCache, getObjectCacheKey[Object[Example, Data, "id:123"]]],
					KeyExistsQ[idCache, "id:123"],
					KeyExistsQ[nameCache, Object[Example, Data, "my name"]]
				}
			),
			{False, False, False},
			Stubs :> {
				objectCache=Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[]
				],
				idCache=Association[
					"id:123" -> Object[Example, Data, "id:123"]
				],
				nameCache=Association[
					Object[Example, Data, "my name"] -> Object[Example, Data, "id:123"]
				]
			}
		],

		Test["Removes Object from object/name/id caches:",
			(
				ClearDownload[Object[Example, Data, "id:123"]];
				{
					KeyExistsQ[objectCache, getObjectCacheKey[Object[Example, Data, "id:123"]]],
					KeyExistsQ[idCache, "id:123"],
					KeyExistsQ[nameCache, Object[Example, Data, "my name"]]
				}
			),
			{False, False, False},
			Stubs :> {
				objectCache=Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[]
				],
				idCache=Association[
					"id:123" -> Object[Example, Data, "id:123"]
				],
				nameCache=Association[
					Object[Example, Data, "my name"] -> Object[Example, Data, "id:123"]
				]
			}
		]
	},
	SymbolSetUp :> {
		setupDownloadExampleObjects[];
	}
];

(* ::Subsubsection::Closed:: *)
(*EraseObject*)

DefineTests[
	EraseObject,
	{
		Example[{Basic, "Deleting an Object removes it permanently from the database:"},
			{EraseObject[newId], DatabaseMemberQ[newId]},
			{True, False},
			Variables :> {newId},
			SetUp :> (
				newId=Upload[<|
					Type -> Object[Sample],
					Name -> "EraseObject Test "<>CreateUUID[]
				|>]
			)
		],

		Example[{Additional, "Deleting an Object is Listable:"},
			{EraseObject[newIds], Download[newIds]},
			{{True, True, True}, {$Failed, $Failed, $Failed}},
			Messages :> {
				Download::ObjectDoesNotExist
			},
			Variables :> {newIds},
			SetUp :> (
				newIds=Upload[{
					<|
						Type -> Object[Sample],
						Name -> "EraseObject Test 1"<>CreateUUID[]
					|>,
					<|
						Type -> Object[Sample],
						Name -> "EraseObject Test 2"<>CreateUUID[]
					|>,
					<|
						Type -> Object[Sample],
						Name -> "EraseObject Test 3"<>CreateUUID[]
					|>
				}]
			)
		],

		Example[{Options, Force, "Force->True turns off the prompt to the user if they are sure they want to delete the object:"},
			{EraseObject[newId, Force -> True], Download[newId]},
			{True, $Failed},
			Messages :> {
				Download::ObjectDoesNotExist
			},
			Variables :> {newId},
			SetUp :> (
				newId=Upload[<|
					Type -> Object[Sample],
					Name -> "EraseObject Test "<>CreateUUID[]
				|>]
			)
		],

		Example[{Options, Verbose, "Verbose->False turns off progress/completion indicators:"},
			With[
				{
					object=Upload[<|
						Type -> Object[Sample],
						Name -> CreateUUID[]
					|>]
				},

				EraseObject[object, Verbose -> False]
			],
			True
		],

		Example[{Messages, "NotFound", "Returns $Failed and prints a message for non-existing objects:"},
			EraseObject[Object[Sample, "id:Kvk"]],
			$Failed,
			Messages :> {
				Message[EraseObject::NotFound]
			}
		],

		Example[{Messages, "Error", "Returns $Failed and prints a message for unexpected errors:"},
			EraseObject[Object[Sample, "id:notArealIdString"]],
			$Failed,
			Messages :> {
				Message[EraseObject::Error]
			}
		],

		Example[{Messages, "NotAllowed", "Returns $Failed and prints a message if the user doesn't have permission to delete:"},
			With[
				{obj=Upload@<|
					Type -> Object[Sample],
					DeveloperObject -> True
				|>},
				EraseObject[obj]
			],
			$Failed,
			Messages :> {
				Message[EraseObject::NotAllowed]
			},
			Stubs :> {
				ConstellationRequest[KeyValuePattern["Method" -> "DELETE"], OptionsPattern[]]=(* note: why not SetDelayed!? *)
						<|"Message" -> "permission denied", "Status" -> 2|>
			}
		],

		Example[{Messages, "NotLoggedIn", "Returns $Failed and throws a NotLoggedIn message if not logged in:"},
			EraseObject[Object[Sample, "test erase oligomer"]],
			$Failed,
			Messages :> {
				EraseObject::NotLoggedIn
			},
			Stubs :> {
				loggedInQ[]:=False
			}
		],

		Example[{Options, Force, "Force->True suppressed the confirmation dialog:"},
			With[
				{
					object=Upload[<|
						Type -> Object[Sample],
						Name -> CreateUUID[]
					|>]
				},

				EraseObject[object, Force -> True]
			],
			True
		],

		Example[{Additional, "Erasing object by Name works:"},
			Module[{object, name},
				name=StringJoin["EraseObjectByName test object", CreateUUID[]];
				object=Upload[<|Type -> Object[Sample], Name -> name|>];

				EraseObject[Object[Sample, name]]
			],
			True
		],

		Test["Deleting an object cleans up its backlink:",
			{
				MemberQ[
					Map[linkToObject, Download[testObjs[[1]], AppendRelation1]],
					testObjs[[3]]
				],
				EraseObject[testObjs[[3]]],
				MemberQ[
					Map[linkToObject, Download[testObjs[[1]], AppendRelation1]],
					testObjs[[3]]
				]
			},
			{True, True, False},
			Variables :> {testId, testObjs},
			SetUp :> (
				testId="EraseObject Backlink Test: "<>CreateUUID[];
				testObjs=Upload[Table[<|Type -> Object[Example, Data]|>, {3}]];
				Upload[<|
					Object -> testObjs[[1]],
					Replace[AppendRelation1] -> Map[
						Link[#, AppendRelation2] &,
						testObjs[[2;;]]
					]
				|>];
			)
		],

		Test["Deleting an object removes any objects that were linked to from the cache:",
			Module[{object1, object2},
				object1=Upload[<|Type -> Object[Example, Data]|>];
				object2=Upload[<|
					Type -> Object[Example, Data],
					SingleRelation -> Link[object1, SingleRelationAmbiguous]
				|>];

				Download[object1, Cache -> Session];

				{
					Download[object1, SingleRelationAmbiguous],
					EraseObject[object2],
					Download[object1, SingleRelationAmbiguous]
				}
			],
			{
				LinkP[],
				True,
				Null
			}
		],

		Test["Deleting an object means you can't upload to it again:",
			With[
				{a=Upload[<|Type -> Object[Sample]|>]},

				EraseObject[a];
				Upload[<|Object -> a, DeveloperObject -> True|>]
			],
			$Failed,
			Messages :> {
				Upload::MissingObject
			}
		]
	},
	Stubs :> {
		deleteObjectDialog[___]:=True
	}
];

(* Helpers *)
prefixStringMatchP[prefix_String]:=_String?(StringMatchQ[#, prefix~~__] &);


(* ::Subsubsection::Closed:: *)
(*CreateLinkID*)


DefineTests[
	CreateLinkID,
	{
		Example[{Basic, "Create a link id which can be used in Upload calls:"},
			linkId=CreateLinkID[];
			result=Upload[{
				<|
					Object -> dataObj,
					PersonRelation -> Link[persObj, DataRelation, linkId]
				|>,
				<|
					Object -> persObj,
					Replace[DataRelation] -> {Link[dataObj, PersonRelation, linkId]}
				|>
			}];
			If[result === $Failed, Print["Upload call failed, result: ", result]];
			{
				linkId,
				Download[dataObj, PersonRelation],
				Download[persObj, DataRelation]
			},
			{
				id1_String/;StringMatchQ[id1, StringExpression["clientId:link", __]],
				Link[persObj, DataRelation, _String],
				{Link[dataObj, PersonRelation, _String]}
			}
		],
		Example[{Additional, "CreateLinkID can take count which is how many LinkIDs to create:"},
			CreateLinkID[4],
			{
				id1_String/;StringMatchQ[id1, StringExpression["clientId:link", __]],
				id2_String/;StringMatchQ[id2, StringExpression["clientId:link", __]],
				id3_String/;StringMatchQ[id3, StringExpression["clientId:link", __]],
				id4_String/;StringMatchQ[id4, StringExpression["clientId:link", __]]
			}
		],
		Example[{Basic, "LinkIDs work with indexed fields:"},
			linkId=CreateLinkID[];
			Upload[{
				<|
					Object -> dataObj,
					Append[GroupedMultipleReplaceRelation] -> {{"from", Link[data2Obj, GroupedMultipleReplaceRelationAmbiguous, 2, linkId]}}
				|>,
				<|
					Object -> data2Obj,
					Append[GroupedMultipleReplaceRelationAmbiguous] -> {{"to", Link[dataObj, GroupedMultipleReplaceRelation, 2, linkId]}}
				|>
			}];
			{
				linkId,
				Download[dataObj, GroupedMultipleReplaceRelation],
				Download[data2Obj, GroupedMultipleReplaceRelationAmbiguous]
			},
			{
				id1_String/;StringMatchQ[id1, StringExpression["clientId:link", __]],
				{{"from", Link[data2Obj, GroupedMultipleReplaceRelationAmbiguous, 2, _String]}},
				{{"to", Link[dataObj, GroupedMultipleReplaceRelation, 2, _String]}}
			}
		],
		Test["IDs created with CreateLinkID cannot be erased until uploaded to the server:",
			With[{linkId=CreateLinkID[]},
				Upload[{
					<|Object -> dataObj, PersonRelation -> Link[persObj, DataRelation, linkId]|>,
					<|Object -> persObj, Replace[DataRelation] -> {Link[dataObj, PersonRelation, linkId]}|>
				}];
				{
					EraseLink[Link[persObj, DataRelation, linkId]],
					EraseLink[Download[dataObj, PersonRelation]],
					Download[dataObj, PersonRelation]
				}
			],
			{$Failed, True, Null}
		]
	},
	Variables :> {dataObj, persObj, data2Obj},
	SymbolSetUp :> (
		dataObj=Upload[<|Type -> Object[Example, Data]|>];
		persObj=Upload[<|Type -> Object[Example, Person, Emerald]|>];
		data2Obj=Upload[<|Type -> Object[Example, Data]|>];
	)
];

DefineTests[GetNumOwnedObjects,
	{
		Example[{Basic, "GetNumOwnedObjects test with just the notebook:"},
			(GetNumOwnedObjects[{team}]),
			{AssociationMatchP@Association["team_id" -> Download[team, ID], "num_objects" -> 1]},
			SetUp :> {
				$CreatedObjects={};
				randomStr=ToString[RandomReal[]];
				site=Upload[<|DeveloperObject -> True, Type -> Object[Container, Site],
					Name -> "Test Site for GetNumOwnedObjects Basic "<>randomStr |>];
				team=Upload[<|DeveloperObject -> True, Type -> Object[Team, Financing],
					Name -> "Test Team for GetNumOwnedObjects Basic "<>randomStr, DefaultMailingAddress -> Link[site]|>];
				notebook=Upload[<|DeveloperObject -> True, Type -> Object[LaboratoryNotebook],
					Name -> "Test Notebook for GetNumOwnedObjects Basic "<>randomStr,
					Replace[Financers] -> {Link[team, NotebooksFinanced]},
					Replace[Administrators] -> {Link[Object[User, Emerald, Developer, "id:lYq9jRxwZJll"]]}|>];
			},
			TearDown :> {
				EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
			}
		],
		Example[{Options, Date, "Date option returns the number of owned objects by financing teams at given time:"},
			(GetNumOwnedObjects[{team}, Date -> Now - 1 Year]),
			{AssociationMatchP@Association["team_id" -> Download[team, ID], "num_objects" -> 0]},
			SetUp :> {
				$CreatedObjects={};
				randomStr=ToString[RandomReal[]];
				site=Upload[<|DeveloperObject -> True, Type -> Object[Container, Site],
					Name -> "Test Site for GetNumOwnedObjects Basic "<>randomStr |>];
				team=Upload[<|DeveloperObject -> True, Type -> Object[Team, Financing],
					Name -> "Test Team for GetNumOwnedObjects Basic "<>randomStr, DefaultMailingAddress -> Link[site]|>];
				notebook=Upload[<|DeveloperObject -> True, Type -> Object[LaboratoryNotebook],
					Name -> "Test Notebook for GetNumOwnedObjects Basic "<>randomStr,
					Replace[Financers] -> {Link[team, NotebooksFinanced]},
					Replace[Administrators] -> {Link[Object[User, Emerald, Developer, "id:lYq9jRxwZJll"]]}|>];
			},
			TearDown :> {
				EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
			}
		],
		Example[{Additional, "GetNumOwnedObjects test with transaction objects:"},
			(GetNumOwnedObjects[{team}]),
			{AssociationMatchP@Association["team_id" -> Download[team, ID], "num_objects" -> 4]},
			SetUp :> {
				$CreatedObjects={};
				randomStr=ToString[RandomReal[]];
				{shipToEclCompleted, shipToEclPending, dropShippingOrdered}=Upload[
					{
						<|
							Type -> Object[Transaction, ShipToECL],
							Name -> "ShipToECLCompleted"<>randomStr,
							Status -> Shipped,
							DeveloperObject -> True
						|>,
						<|
							Type -> Object[Transaction, ShipToECL],
							Name -> "ShipToECLPending"<>randomStr,
							Status -> Pending,
							DeveloperObject -> True
						|>,
						<|
							Type -> Object[Transaction, DropShipping],
							Name -> "DropShippingOrdered"<>randomStr,
							Status -> Ordered,
							DeveloperObject -> True
						|>
					}
				];
				site=Upload[<|DeveloperObject -> True,
					Type -> Object[Container, Site],
					Name -> "Test Site for GetNumOwnedObjects "<>randomStr|>];
				team=Upload[<|DeveloperObject -> True,
					Type -> Object[Team, Financing],
					Name -> "Test Team for GetNumOwnedObjects "<>randomStr,
					DefaultMailingAddress -> Link[site]|>];
				notebook=Upload[<|DeveloperObject -> True,
					Type -> Object[LaboratoryNotebook],
					Name -> "Test Notebook for GetNumOwnedObjects "<>randomStr,
					Replace[Financers] -> {
						Link[team, NotebooksFinanced]
					},
					Replace[Administrators] -> {
						Link[Object[User, Emerald, Developer, "id:lYq9jRxwZJll"]]
					}
				|>];
				Upload[
					{
						<|
							Object -> shipToEclCompleted,
							Transfer[Notebook] -> Link[notebook, Objects]
						|>,
						<|
							Object -> shipToEclPending,
							Transfer[Notebook] -> Link[notebook, Objects]
						|>,
						<|
							Object -> dropShippingOrdered,
							Transfer[Notebook] -> Link[notebook, Objects]
						|>
					}
				];
			},
			TearDown :> {
				EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
			},
			Stubs :> {
				$DeveloperSearch=True
			}
		],
		Example[{Messages, "Error", "GetNumOwnedObjects returns error on http error:"},
			(GetNumOwnedObjects[{team}]),
			$Failed,
			Messages :> {Message[GetNumOwnedObjects::Error]},
			SetUp :> {
				$CreatedObjects={};
				randomStr=ToString[RandomReal[]];
				site=Upload[<|DeveloperObject -> True, Type -> Object[Container, Site],
					Name -> "Test Site for GetNumOwnedObjects Basic "<>randomStr |>];
				team=Upload[<|DeveloperObject -> True, Type -> Object[Team, Financing],
					Name -> "Test Team for GetNumOwnedObjects Basic "<>randomStr, DefaultMailingAddress -> Link[site]|>];
				notebook=Upload[<|DeveloperObject -> True, Type -> Object[LaboratoryNotebook],
					Name -> "Test Notebook for GetNumOwnedObjects Basic "<>randomStr,
					Replace[Financers] -> {Link[team, NotebooksFinanced]},
					Replace[Administrators] -> {Link[Object[User, Emerald, Developer, "id:lYq9jRxwZJll"]]}|>];
			},
			TearDown :> {
				EraseObject[PickList[$CreatedObjects, DatabaseMemberQ[$CreatedObjects]], Force -> True, Verbose -> False];
				Unset[$CreatedObjects];
			},
			Stubs :> {
				ConstellationRequest[KeyValuePattern["Path" -> "obj/get-num-owned-objects"], ___]=HTTPError[None, "Server error."]
			}
		]
	}
];

(*TraceHistory*)
DefineTests[TraceHistory,
	{
		Example[{Basic, "Return the TableForm of communications to the database:"},
			Download[$PersonID,Name];TraceHistory[],
			_TableForm
		],
		Example[{Basic, "Inside the table, the result contains the record of communications to the database:"},
			Download[$PersonID,Name];First[TraceHistory[]],
			{_Rule...}
		]
	}
];
