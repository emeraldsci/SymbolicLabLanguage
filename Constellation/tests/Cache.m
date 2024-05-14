(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*cacheObjectID*)

DefineTests[
	cacheObjectID,
	{
		Test["Given an object with a name not in the cache, returns itself:",
			cacheObjectID[Object[Example, Data, "my name"]],
			Object[Example, Data, "my name"]
		],

		Test["Given an object with a name in the cache, returns the full ID in the cache:",
			cacheObjectID[Object[Example, Data, "cached name"]],
			Object[Example, Data, "id:1234"]
		],

		Test["Given an object with an ID, returns that object:",
			cacheObjectID[Object[Example, Data, "id:abc"]],
			Object[Example, Data, "id:abc"]
		],

		Test["Given a key with None, returns that object:",
			cacheObjectID[{Object[Example, Data, "cached name"], None}],
			{Object[Example, Data, "id:1234"], None}
		]
	},
	Stubs :> {
		nameCache=Association[
			Object[Example, Data, "cached name"] -> Object[Example, Data, "id:1234"]
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*filterSessionCachedFields*)

DefineTests[
	filterSessionCachedFieldsWithDate,
	{
		Test["Given an object not in the cache, return all fields for that object:",
			filterSessionCachedFieldsWithDate[
				<|{Object[Example, Data, "id:666"], None} -> <|"Fields" -> {Traversal[TestName], Traversal[Random]}|>|>,
				(*Cache*)
				<||>
			],
			<|{Object[Example, Data, "id:666"], None} -> <|"Fields" -> {OrderlessPatternSequence[Traversal[TestName], Traversal[Random]]}|>|>
		],

		Test["Given an object in the cache, return all fields for that object if it is not session cached:",
			filterSessionCachedFieldsWithDate[
				<|{Object[Example, Data, "id:123"], None} -> <|"Fields" -> {Traversal[TestName], Traversal[Random]}|>|>,
				(*Cache*)
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Session" -> False
					]
				]
			],
			<|{Object[Example, Data, "id:123"], None} -> <|"Fields" -> {OrderlessPatternSequence[Traversal[TestName], Traversal[Random]]}|>|>
		],

		Test["Given an object in the cache, return no fields if session cached:",
			filterSessionCachedFieldsWithDate[
				<|{Object[Example, Data, "id:123"], None} -> <|"Fields" -> {Traversal[TestName], Traversal[Random]}|>|>,
				(*Cache*)
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Session" -> True
					]
				]
			],
			<||>
		],
		Test["Given a temporal object object in the cache, return no fields if session cached:",
			With[{date=DateObject[DateString[DateObject[]]]},
				filterSessionCachedFieldsWithDate[
					<|{Object[Example, Data, "id:123"], date} -> <|"Fields" -> {Traversal[TestName], Traversal[Random]}|>|>,
					(*Cache*)
					Association[
						getObjectCacheKey[Object[Example, Data, "id:123"], date] -> Association[
							"Session" -> True
						]
					]
				]],
			<||>
		],
		Test["Given a temporal object in the cache, return all fields for that object if it is not session cached:",
			With[{date=DateObject[DateString[DateObject[]]]},
				filterSessionCachedFieldsWithDate[
					<|{Object[Example, Data, "id:123"], date} -> <|"Fields" -> {Traversal[TestName], Traversal[Random]}|>|>,
					(*Cache*)
					Association[
						getObjectCacheKey[Object[Example, Data, "id:123"], date] -> Association[
							"Session" -> False
						]
					]
				]],
			<|{Object[Example, Data, "id:123"], _DateObject} -> <|"Fields" -> {OrderlessPatternSequence[Traversal[TestName], Traversal[Random]]}|>|>
		],

		Test["Given an object in the cache, return only the fields in the cache which are RuleDelayed:",
			filterSessionCachedFieldsWithDate[
				<|{Object[Example, Data, "id:123"], None} -> <|"Fields" -> {Traversal[TestName], Traversal[Random]}|>|>,
				(*Cache*)
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Session" -> True,
						"Fields" -> Association[
							Traversal[Random] -> Association[
								"Rule" -> RuleDelayed[Random, Object[Example, Data, "id:123"][Random]]
							]
						]
					]
				]
			],
			Association[
				{Object[Example, Data, "id:123"], None} -> <|"Fields" -> {Traversal[Random]}|>
			]
		],

		Test["Given an object in the cache, do not return fields that are not RuleDelayed:",
			filterSessionCachedFieldsWithDate[
				<|{Object[Example, Data, "id:123"], None} -> <|"Fields" -> {Traversal[TestName], Traversal[Random]}|>|>,
				(*Cache*)
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Session" -> True,
						"Fields" -> Association[
							Traversal[Random] -> Association[
								"Rule" -> Rule[Random, {1, 2, 3}]
							]
						]
					]
				]
			],
			Association[]
		],

		Test["Given an object in the session cache, return only FieldParts with more than 1 level:",
			filterSessionCachedFieldsWithDate[
				<|{Object[Example, Data, "id:123"], None} -> <|"Fields" -> {Traversal[TestName], Traversal[SingleRelation[Name]], Traversal[Random]}|>|>,
				(*Cache*)
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
							Traversal[SingleRelation] -> Association[
								"Rule" -> Rule[SingleRelation, Link[Object[Example, Data, "id:999"]]]
							]
						],
						"CAS" -> "456",
						"Session" -> True
					]
				]
			],
			Association[
				{Object[Example, Data, "id:123"], None} -> <|"Fields" -> {Traversal[SingleRelation[Name]]}|>
			]
		],
		Test["Given a temporal object in the session cache, return only FieldParts with more than 1 level:",
			With[{date=DateObject[DateString[DateObject[]]]},
				filterSessionCachedFieldsWithDate[
					<|{Object[Example, Data, "id:123"], date} -> <|"Fields" -> {Traversal[TestName], Traversal[SingleRelation[Name]], Traversal[Random]}|>|>,
					(*Cache*)
					Association[
						getObjectCacheKey[Object[Example, Data, "id:123"], date] -> Association[
							"Fields" -> Association[
								Traversal[SingleRelation] -> Association[
									"Rule" -> Rule[SingleRelation, Link[Object[Example, Data, "id:999"]]]
								]
							],
							"CAS" -> "456",
							"Session" -> True
						]
					]
				]],
			Association[
				{Object[Example, Data, "id:123"], _DateObject} -> <|"Fields" -> {Traversal[SingleRelation[Name]]}|>
			]
		],
		Test["Given an object in the session cache, do not return traversal part if linked object is also in the session cache:",
			filterSessionCachedFieldsWithDate[
				<|{Object[Example, Data, "id:123"], None} -> <|"Fields" -> {Traversal[TestName], Traversal[SingleRelation[Name]], Traversal[Random]}|>|>,
				(*Cache*)
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
							Traversal[SingleRelation] -> Association[
								"Rule" -> Rule[SingleRelation, Link[Object[Example, Data, "id:999"]]]
							]
						],
						"CAS" -> "456",
						"Session" -> True
					],
					getObjectCacheKey[Object[Example, Data, "id:999"]] -> Association[
						"Fields" -> Association[],
						"CAS" -> "123",
						"Session" -> True
					]
				]
			],
			Association[]
		],

		Test["Given an object in the session cache, if the field in a traveral part is not in the object, do not include that field:",
			filterSessionCachedFieldsWithDate[
				<|{Object[Example, Data, "id:123"], None} -> <|"Fields" -> {Traversal[TestName], Traversal[SingleRelation[Name]], Traversal[Random]}|>|>,
				(*Cache*)
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
						],
						"CAS" -> "456",
						"Session" -> True
					]
				]
			],
			Association[]
		],

		Test["Given an object in the cache by its name, return all fields for that object:",
			filterSessionCachedFieldsWithDate[
				Association[
					{Object[Example, Data, "cached name"], None} -> <|"Fields" -> {Traversal[TestName], Traversal[Random]}|>,
					{Object[Example, Data, "id:111"], None} -> <|"Fields" -> {Traversal[Random]}|>
				],
				(*Cache*)
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Session" -> True
					]
				]
			],
			Association[
				{Object[Example, Data, "cached name"], None} -> <|"Fields" -> {OrderlessPatternSequence[Traversal[TestName], Traversal[Random]]}|>,
				{Object[Example, Data, "id:111"], None} -> <|"Fields" -> {Traversal[Random]}|>
			]
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*filterLocalFields*)

DefineTests[
	filterLocalFieldsWithDate,
	{
		Test["Removes Type/Object/ID from all objects with IDs:",
			filterLocalFieldsWithDate[
				Association[
					{Object[Example, Data, "id:666"], None} -> Association[
						"Fields" -> {Traversal[ID], Traversal[Type], Traversal[Random]}
					]
				]
			],
			<|{Object[Example, Data, "id:666"], None} -> <|"Fields" -> {Traversal[Random]}|>|>
		],

		Test["Removes Type from all objects with Names:",
			filterLocalFieldsWithDate[
				Association[
					{Object[Example, Data, "id:666"], None} -> Association[
						"Fields" -> {Traversal[ID], Traversal[Type], Traversal[Object], Traversal[Random]}
					],
					{Object[Example, Data, "named object"], None} -> Association[
						"Fields" -> {Traversal[Type], Traversal[Object], Traversal[Random]}
					]
				]
			],
			<|
				{Object[Example, Data, "id:666"], None} -> <|"Fields" -> {Traversal[Random]}|>,
				{Object[Example, Data, "named object"], None} -> <|"Fields" -> {Traversal[Object], Traversal[Random]}|>
			|>
		],

		Test["Does not include an entry for the object if all fields are local:",
			filterLocalFieldsWithDate[
				Association[
					{Object[Example, Data, "id:666"], None} -> Association[
						"Fields" -> {Traversal[ID], Traversal[Type], Traversal[Object]}
					],
					{Object[Example, Data, "named object"], None} -> Association[
						"Fields" -> {Traversal[Type], Traversal[Object], Traversal[Random]}
					]
				]
			],
			<|
				{Object[Example, Data, "named object"], None} -> <|"Fields" -> {Traversal[Object], Traversal[Random]}|>
			|>
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*filterExplicitFields*)

DefineTests[
	filterExplicitFieldsWithDate,
	{
		Test["Returns all the field for the object if there are no packets:",
			filterExplicitFieldsWithDate[
				<|{Object[Example, Data, "id:666"], None} -> <|
					"Fields" -> {Traversal[ID], Traversal[Type], Traversal[Random]}
				|>|>,
				<||>
			],
			<|{Object[Example, Data, "id:666"], None} -> <|
				"Fields" -> {Traversal[ID], Traversal[Type], Traversal[Random]}
			|>|>
		],

		Test["Removes all fields for each object that is in the packets list:",
			filterExplicitFieldsWithDate[
				<|
					{Object[Example, Data, "id:666"], None} -> <|
						"Fields" -> {Traversal[ID], Traversal[Type], Traversal[Object], Traversal[Random]}
					|>
				|>,
				<|
					getObjectCacheKey[Object[Example, Data, "id:666"]] -> <|
						"Fields" -> <|
							Traversal[Object] -> <|"Rule" -> Rule[Object, Object[Example, Data, "id:666"]]|>,
							Traversal[Type] -> <|"Rule" -> Rule[Type, Object[Example, Data]]|>,
							Traversal[ID] -> <|"Rule" -> Rule[ID, "id:666"]|>,
							Traversal[Random] -> <|"Rule" -> Rule[Random, {1, 2, 3}]|>
						|>
					|>
				|>
			],
			<|{Object[Example, Data, "id:666"], None} -> <|"Fields" -> {}|>|>
		],

		Test["Removes traversal fields and provides a message if root is missing from packet:",
			filterExplicitFieldsWithDate[
				<|
					{Object[Example, Data, "id:666"], None} -> <|
						"Fields" -> {Traversal[ID], Traversal[Type], Traversal[Object], Traversal[Random]}
					|>,
					{Object[Example, Data, "named object"], None} -> <|
						"Fields" -> {Traversal[Type], Traversal[Object], Traversal[SingleRelation[Name]]}
					|>
				|>,
				<|
					getObjectCacheKey[Object[Example, Data, "id:666"]] -> <|
						"Fields" -> <|
							Traversal[Object] -> <|"Rule" -> Rule[Object, Object[Example, Data, "id:666"]]|>,
							Traversal[Type] -> <|"Rule" -> Rule[Type, Object[Example, Data]]|>,
							Traversal[ID] -> <|"Rule" -> Rule[ID, "id:666"]|>,
							Traversal[Random] -> <|"Rule" -> Rule[Random, {1, 2, 3}]|>
						|>
					|>
				|>
			],
			<|
				{Object[Example, Data, "id:666"], None} -> <|"Fields" -> {}|>,
				{Object[Example, Data, "named object"], None} -> <|
					"Fields" -> {Traversal[Object], Traversal[Type], Traversal[SingleRelation[Name]]}
				|>
			|>
		],
		Test["Returns traversal fields if a link exists at the root in the packets list:",
			filterExplicitFieldsWithDate[
				<|
					{Object[Example, Data, "id:666"], None} -> <|
						"Fields" -> {
							Traversal[ID],
							Traversal[Type],
							Traversal[Object],
							Traversal[SingleRelation[Name]]
						}
					|>
				|>,
				<|
					getObjectCacheKey[Object[Example, Data, "id:666"]] -> <|
						"Fields" -> <|
							Traversal[Object] -> <|
								"Rule" -> Rule[Object, Object[Example, Data, "id:666"]]
							|>,
							Traversal[Type] -> <|
								"Rule" -> Rule[Type, Object[Example, Data]]
							|>,
							Traversal[ID] -> <|
								"Rule" -> Rule[ID, "id:666"]
							|>,
							Traversal[SingleRelation] -> <|
								"Rule" -> Rule[
									SingleRelation,
									Link[Object[Example, Data, "id:222"], SingleRelationAmbiguous, "asdf"]
								]
							|>
						|>
					|>
				|>
			],
			<|
				{Object[Example, Data, "id:666"], None} -> <|"Fields" -> {}|>,
				{Object[Example, Data, "id:222"], None} -> <|"Fields" -> {Traversal[Name]}|>
			|>
		],
		Test["Returns traversal fields if a temporal link exists at the root in the packets list:",
			filterExplicitFieldsWithDate[
				<|
					{Object[Example, Data, "id:666"], None} -> <|
						"Fields" -> {
							Traversal[ID],
							Traversal[Type],
							Traversal[Object],
							Traversal[SingleRelation[Name]]
						}
					|>
				|>,
				<|
					getObjectCacheKey[Object[Example, Data, "id:666"]] -> <|
						"Fields" -> <|
							Traversal[Object] -> <|
								"Rule" -> Rule[Object, Object[Example, Data, "id:666"]]
							|>,
							Traversal[Type] -> <|
								"Rule" -> Rule[Type, Object[Example, Data]]
							|>,
							Traversal[ID] -> <|
								"Rule" -> Rule[ID, "id:666"]
							|>,
							Traversal[SingleRelation] -> <|
								"Rule" -> Rule[
									SingleRelation,
									Link[Object[Example, Data, "id:222"], SingleRelationAmbiguous, "asdf", DateObject["Sep 1 2020"]]
								]
							|>
						|>
					|>
				|>
			],
			<|
				{Object[Example, Data, "id:666"], None} -> <|"Fields" -> {}|>,
				{Object[Example, Data, "id:222"], DateObject["Sep 1 2020"]} -> <|"Fields" -> {Traversal[Name]}|>
			|>
		],
		Test["Returns traversal fields if a list of links exists at the root in the packets list:",
			filterExplicitFieldsWithDate[
				<|
					{Object[Example, Data, "id:666"], None} -> <|
						"Fields" -> {
							Traversal[ID],
							Traversal[Type],
							Traversal[Object],
							Traversal[MultipleAppendRelation[Name]]
						}
					|>
				|>,
				<|getObjectCacheKey[Object[Example, Data, "id:666"]] -> <|
					"Fields" -> <|
						Traversal[Object] -> <|"Rule" -> Rule[Object, Object[Example, Data, "id:666"]]|>,
						Traversal[Type] -> <|"Rule" -> Rule[Type, Object[Example, Data]]|>,
						Traversal[ID] -> <|"Rule" -> Rule[ID, "id:666"]|>,
						Traversal[MultipleAppendRelation] -> <|"Rule" -> Rule[MultipleAppendRelation, {
							Link[Object[Example, Data, "id:222"], MultipleAppendRelationAmbiguous, "asdf"],
							Link[Object[Example, Data, "id:333"], MultipleAppendRelationAmbiguous, "xyz"]
						}]|>
					|>
				|>|>
			],
			<|
				{Object[Example, Data, "id:666"], None} -> <|"Fields" -> {}|>,
				{Object[Example, Data, "id:222"], None} -> <|"Fields" -> {Traversal[Name]}|>,
				{Object[Example, Data, "id:333"], None} -> <|"Fields" -> {Traversal[Name]}|>
			|>
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*filterCachedFields*)

DefineTests[
	filterCachedFieldsWithDate,
	{
		Test["Returns all fields if object not in cache:",
			filterCachedFieldsWithDate[
				Association[
					{Object[Example, Data, "cached name"], None} -> Association[
						"Fields" -> {Traversal[TestName], Traversal[Random]},
						"CAS" -> "123",
						"Limit" -> 50
					],
					{Object[Example, Data, "id:111"], None} -> Association[
						"Fields" -> {Traversal[Random]},
						"CAS" -> "456",
						"Limit" -> 50
					]
				],
				(*Cache*)
				<||>
			],
			Association[
				{Object[Example, Data, "cached name"], None} -> Association[
					"Fields" -> {Traversal[TestName], Traversal[Random]},
					"CAS" -> "123",
					"Limit" -> 50
				],
				{Object[Example, Data, "id:111"], None} -> Association[
					"Fields" -> {Traversal[Random]},
					"CAS" -> "456",
					"Limit" -> 50
				]
			]
		],

		Test["Does not return Length field requests if CAS token is the same and summary exists in cache:",
			filterCachedFieldsWithDate[
				Association[
					{Object[Example, Data, "id:111"], None} -> Association[
						"Fields" -> {Traversal[TestName], Traversal[Random[Length]]},
						"CAS" -> "456",
						"Limit" -> 50
					]
				],
				(*Cache*)
				Association[
					getObjectCacheKey[Object[Example, Data, "id:111"]] -> Association[
						"Fields" -> <||>,
						"FieldSummaries" -> <|
							Random -> <|
								"Count" -> 10
							|>
						|>,
						"CAS" -> "456"
					]
				]
			],
			Association[
				{Object[Example, Data, "id:111"], None} -> Association[
					"Fields" -> {Traversal[TestName]},
					"CAS" -> "456",
					"Limit" -> 50
				]
			]
		],

		Test["If object fields are all in cache and >= the requested limit, do not return entry for that object:",
			filterCachedFieldsWithDate[
				Association[
					{Object[Example, Data, "cached name"], None} -> Association[
						"Fields" -> {Traversal[TestName], Traversal[Random]},
						"CAS" -> "123",
						"Limit" -> 50
					],
					{Object[Example, Data, "id:111"], None} -> Association[
						"Fields" -> {Traversal[Random]},
						"CAS" -> "456",
						"Limit" -> 50
					]
				],
				(*Cache*)
				Association[
					getObjectCacheKey[Object[Example, Data, "id:111"]] -> Association[
						"Fields" -> Association[
							Traversal[Random] -> Association[
								"Rule" -> Rule[Random, {1, 2, 3}],
								"Limit" -> 50
							]
						],
						"CAS" -> "456"
					]
				]
			],
			Association[
				{Object[Example, Data, "cached name"], None} -> Association[
					"Fields" -> {Traversal[TestName], Traversal[Random]},
					"CAS" -> "123",
					"Limit" -> 50
				]
			]
		],

		Test["If object is in the cache but only some fields are cached, filter out those fields:",
			filterCachedFieldsWithDate[
				Association[
					{Object[Example, Data, "id:123"], None} -> Association[
						"Fields" -> {Traversal[TestName], Traversal[Random]},
						"CAS" -> "123",
						"Limit" -> 50
					],
					{Object[Example, Data, "id:111"], None} -> Association[
						"Fields" -> {Traversal[Random]},
						"CAS" -> "456",
						"Limit" -> 50
					]
				],
				(*Cache*)
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
							Traversal[Random] -> Association[
								"Rule" -> Rule[Random, {1, 2, 3}],
								"Limit" -> 50
							]
						],
						"CAS" -> "123"
					]
				]
			],
			Association[
				{Object[Example, Data, "id:123"], None} -> Association[
					"Fields" -> {Traversal[TestName]},
					"CAS" -> "123",
					"Limit" -> 50
				],
				{Object[Example, Data, "id:111"], None} -> Association[
					"Fields" -> {Traversal[Random]},
					"CAS" -> "456",
					"Limit" -> 50
				]
			]
		],

		Test["If object is in the cache but only some fields are >= the requested limit, filter out only those fields:",
			filterCachedFieldsWithDate[
				Association[
					{Object[Example, Data, "id:123"], None} -> Association[
						"Fields" -> {Traversal[TestName], Traversal[Random]},
						"CAS" -> "123",
						"Limit" -> 100
					],
					{Object[Example, Data, "id:111"], None} -> Association[
						"Fields" -> {Traversal[Random]},
						"CAS" -> "456",
						"Limit" -> 50
					]
				],
				(*Cache*)
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
							Traversal[Random] -> Association[
								"Rule" -> Rule[Random, {1, 2, 3}],
								"Limit" -> 50
							],
							Traversal[TestName] -> Association[
								"Rule" -> Rule[TestName, "ASDF"],
								"Limit" -> 200
							]
						],
						"CAS" -> "123"
					]
				]
			],
			Association[
				{Object[Example, Data, "id:123"], None} -> Association[
					"Fields" -> {Traversal[Random]},
					"CAS" -> "123",
					"Limit" -> 100
				],
				{Object[Example, Data, "id:111"], None} -> Association[
					"Fields" -> {Traversal[Random]},
					"CAS" -> "456",
					"Limit" -> 50
				]
			]
		],

		Test["If CAS token is different than requested, return all fields for that object:",
			filterCachedFieldsWithDate[
				Association[
					{Object[Example, Data, "id:123"], None} -> Association[
						"Fields" -> {Traversal[TestName], Traversal[Random]},
						"CAS" -> "123",
						"Limit" -> 100
					],
					{Object[Example, Data, "id:111"], None} -> Association[
						"Fields" -> {Traversal[Random]},
						"CAS" -> "456",
						"Limit" -> 50
					]
				],
				(*Cache*)
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
							Traversal[Random] -> Association[
								"Rule" -> Rule[Random, {1, 2, 3}],
								"Limit" -> 50
							],
							Traversal[TestName] -> Association[
								"Rule" -> Rule[TestName, "ASDF"],
								"Limit" -> 200
							]
						],
						"CAS" -> "222"
					]
				]
			],
			Association[
				{Object[Example, Data, "id:123"], None} -> Association[
					"Fields" -> {Traversal[TestName], Traversal[Random]},
					"CAS" -> "123",
					"Limit" -> 100
				],
				{Object[Example, Data, "id:111"], None} -> Association[
					"Fields" -> {Traversal[Random]},
					"CAS" -> "456",
					"Limit" -> 50
				]
			]
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*getCacheValue*)

DefineTests[
	getCacheValue,
	{
		Test["If given $Failed and a single field, returns $Failed:",
			getCacheValue[$Failed, Null, Traversal[Name], <||>],
			$Failed
		],

		Test["If given $Failed and a list of fields, returns $Failed for each index:",
			getCacheValue[$Failed, Null, {Traversal[Random], Traversal[Name]}, <||>],
			{$Failed, $Failed}
		],

		Test["If given Null and a list of fields, returns Null:",
			getCacheValue[Null, Null, {Traversal[Random], Traversal[Name]}, <||>],
			Null
		],

		Test["If given Null and a single field, returns Null:",
			getCacheValue[Null, Null, Traversal[Random], <||>],
			Null
		],

		Test["If given a packet and a single field, returns the value of that field in the packet:",
			getCacheValue[
				<|Type -> Object[Example, Data], Random -> {1, 2, 3}|>,
				Null,
				Traversal[Random],
				<||>
			],
			{1, 2, 3}
		],

		Test["If given a packet and a list of fields, returns the value of that fields in the packet:",
			getCacheValue[
				<|Type -> Object[Example, Data], Random -> {1, 2, 3}, Name -> "Hello"|>,
				Null,
				{Traversal[Random], Traversal[Name]},
				<||>
			],
			{{1, 2, 3}, "Hello"}
		],

		Test["If given a packet and a list of fields, returns $Failed for single fields missing in the packet:",
			getCacheValue[
				<|Type -> Object[Example, Data], Random -> {1, 2, 3}|>,
				Null,
				{Traversal[Random], Traversal[Name]},
				<||>
			],
			{{1, 2, 3}, $Failed}
		],

		Test["If given a packet and a list of fields, returns $Failed for multiple fields missing in the packet:",
			getCacheValue[
				<|Type -> Object[Example, Data], Name -> "Hello"|>,
				Null,
				{Traversal[Random], Traversal[Name]},
				<||>
			],
			{$Failed, "Hello"}
		],

		Test["If given a packet and a list of fields, returns $Failed fields missing in the packet if the packet does not have a type:",
			getCacheValue[
				<|Name -> "Hello"|>,
				Null,
				{Traversal[Random], Traversal[Name]},
				<||>
			],
			{$Failed, "Hello"}
		],

		Test["If given an object and a list of fields, looks up the values for those fields in the cache:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				Null,
				{Traversal[Random], Traversal[Name]},
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"], None] -> Association[
						"Fields" -> Association[
							Traversal[Random] -> Association[
								"Rule" -> Rule[Random, {1, 1, 1}],
								"Limit" -> 50
							],
							Traversal[Name] -> Association[
								"Rule" -> Rule[Name, "My Name"],
								"Limit" -> 200
							]
						],
						"CAS" -> "222"
					]
				]
			],
			{{1, 1, 1}, "My Name"}
		],
		Test["If given an object and a list of fields, don't use the values of a different date:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				Null,
				{Traversal[Random], Traversal[Name]},
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"], DateObject["Jan 1 2020"]] -> Association[
						"Fields" -> Association[
							Traversal[Random] -> Association[
								"Rule" -> Rule[Random, {1, 1, 1}],
								"Limit" -> 50
							],
							Traversal[Name] -> Association[
								"Rule" -> Rule[Name, "My Name"],
								"Limit" -> 200
							]
						],
						"CAS" -> "222"
					]
				]
			],
			{$Failed, $Failed}
		],
		Test["If given an object with a date and a list of fields, don't use the most recent values:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				DateObject["Jan 1 2020"],
				{Traversal[Random], Traversal[Name]},
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"], None] -> Association[
						"Fields" -> Association[
							Traversal[Random] -> Association[
								"Rule" -> Rule[Random, {1, 1, 1}],
								"Limit" -> 50
							],
							Traversal[Name] -> Association[
								"Rule" -> Rule[Name, "My Name"],
								"Limit" -> 200
							]
						],
						"CAS" -> "222"
					]
				]
			],
			{$Failed, $Failed}
		],
		Test["If given an object with a date and a list of fields, use that date as part of the key:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				DateObject["Jan 1 2020"],
				{Traversal[Random], Traversal[Name]},
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"], DateObject[AbsoluteTime[DateObject["Jan 1 2020"]]]] -> Association[
						"Fields" -> Association[
							Traversal[Random] -> Association[
								"Rule" -> Rule[Random, {1, 1, 1}],
								"Limit" -> 50
							],
							Traversal[Name] -> Association[
								"Rule" -> Rule[Name, "My Name"],
								"Limit" -> 200
							]
						],
						"CAS" -> "222"
					]
				]
			],
			{{1, 1, 1}, "My Name"}
		],
		Test["If given an object with a date and a list of fields, don't lookup on a different date:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				DateObject["Jan 1 2020"],
				{Traversal[Random], Traversal[Name]},
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"], DateObject["Jan 2 2020"]] -> Association[
						"Fields" -> Association[
							Traversal[Random] -> Association[
								"Rule" -> Rule[Random, {1, 1, 1}],
								"Limit" -> 50
							],
							Traversal[Name] -> Association[
								"Rule" -> Rule[Name, "My Name"],
								"Limit" -> 200
							]
						],
						"CAS" -> "222"
					]
				]
			],
			{$Failed, $Failed}
		],

		Test["If given an object and a list of fields, returns default values for any fields not in the cache:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				Null,
				{Traversal[Random], Traversal[Name]},
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"], None] -> Association[
						"Fields" -> Association[
							Traversal[Random] -> Association[
								"Rule" -> Rule[Random, {1, 1, 1}],
								"Limit" -> 50
							]
						],
						"CAS" -> "222"
					]
				]
			],
			{{1, 1, 1}, Null}
		],

		Test["If given a link, lookup its object in the cache and return default values for any fields not in the cache:",
			getCacheValue[
				Link[Object[Example, Data, "id:123"], TestName],
				Null,
				{Traversal[Random], Traversal[Name]},
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"], None] -> Association[
						"Fields" -> Association[
							Traversal[Random] -> Association[
								"Rule" -> Rule[Random, {1, 1, 1}],
								"Limit" -> 50
							]
						],
						"CAS" -> "222"
					]
				]
			],
			{{1, 1, 1}, Null}
		],

		Test["If given a named object, convert it to an ID and look it up in the cache:",
			getCacheValue[
				Object[Example, Data, "my name"],
				Null,
				Traversal[Random],
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
							Traversal[Random] -> Association[
								"Rule" -> Rule[Random, {1, 1, 1}],
								"Limit" -> 50
							]
						],
						"CAS" -> "222"
					]
				]
			],
			{1, 1, 1},
			Stubs :> {
				nameCache=Association[
					Object[Example, Data, "my name"] -> Object[Example, Data, "id:123"]
				]
			}
		],

		Test["If given a Traversal with an index and the field value is not a list of lists, return $Failed for that field:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				Null,
				Traversal[Query[Key[Random], All, 2]],
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
							Traversal[Random] -> Association[
								"Rule" -> Rule[Random, {1, 1, 1}],
								"Limit" -> 50
							]
						],
						"CAS" -> "222"
					]
				]
			],
			$Failed
		],

		Test["If given a Traversal with an index and the field value is not a list, return $Failed for that field:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				Null,
				Traversal[Query[Key[Name], All, 2]],
				Association[]
			],
			$Failed
		],

		Test["If given a Traversal with an index, return only the values at that index for the field:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				Null,
				Traversal[Query[Key[GroupedUnits], All, 1]],
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
							Traversal[GroupedUnits] -> Association[
								"Rule" -> Rule[GroupedUnits, {{"A", 12 Second}, {"B", 10 Minute}}],
								"Limit" -> 50
							]
						],
						"CAS" -> "222"
					]
				]
			],
			{"A", "B"}
		],

		Test["If given a Traversal with an index, return $Failed if that index is out of range of the values for that field:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				Null,
				Traversal[Query[Key[GroupedUnits], All, 3]],
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
							Traversal[GroupedUnits] -> Association[
								"Rule" -> Rule[GroupedUnits, {{"A", 12 Second}, {"B", 10 Minute}}],
								"Limit" -> 50
							]
						],
						"CAS" -> "222"
					]
				]
			],
			$Failed
		],

		Test["If given an object with no fields that does not exist in the cache, return $Failed:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				Null,
				Association[]
			],
			$Failed
		],

		Test["If given a link with no fields that does not exist in the cache, return $Failed:",
			getCacheValue[
				Link[Object[Example, Data, "id:123"], TestName],
				Null,
				Association[]
			],
			$Failed
		],

		Test["If given an object with a name and no fields that does exist in the cache, retrieve the values from the cache:",
			getCacheValue[
				Object[Example, Data, "my name"],
				Null,
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
							Traversal[GroupedUnits] -> Association[
								"Rule" -> Rule[GroupedUnits, {{"A", 12 Second}, {"B", 10 Minute}}],
								"Limit" -> 50
							]
						],
						"CAS" -> "222"
					]
				]
			],
			_Association,
			Stubs :> {
				nameCache=Association[
					Object[Example, Data, "my name"] -> Object[Example, Data, "id:123"]
				]
			}
		],

		Test["If given an object with a name that is not cached and the Type field, construct it from the object:",
			getCacheValue[
				Object[Example, Data, "my name"],
				Null,
				Traversal[Type],
				Association[]
			],
			Object[Example, Data],
			Stubs :> {
				nameCache=Association[]
			}
		],

		Test["If given an object with a name that is not cached and the ID field, returns $Failed:",
			getCacheValue[
				Object[Example, Data, "my name"],
				Null,
				Traversal[ID],
				Association[]
			],
			$Failed,
			Stubs :> {
				nameCache=Association[]
			}
		],

		Test["If given an object with a name that is not cached and the Object field, returns $Failed:",
			getCacheValue[
				Object[Example, Data, "my name"],
				Null,
				Traversal[Object],
				Association[]
			],
			$Failed,
			Stubs :> {
				nameCache=Association[]
			}
		],

		Test["If given an object with a name that is cached and the Object field, returns the Object field from the cache:",
			getCacheValue[
				Object[Example, Data, "my name"],
				Null,
				Traversal[Object],
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
							Traversal[GroupedUnits] -> Association[
								"Rule" -> Rule[GroupedUnits, {{"A", 12 Second}, {"B", 10 Minute}}],
								"Limit" -> 50
							],
							Traversal[Object] -> Association[
								"Rule" -> Rule[Object, Object[Example, Data, "id:123"]],
								"Limit" -> 50
							]
						],
						"CAS" -> "222"
					]
				]
			],
			Object[Example, Data, "id:123"],
			Stubs :> {
				nameCache=Association[
					Object[Example, Data, "my name"] -> Object[Example, Data, "id:123"]
				]
			}
		],

		Test["If given an object with a name that is cached and the ID field, returns the ID field from the cache:",
			getCacheValue[
				Object[Example, Data, "my name"],
				Null,
				Traversal[ID],
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
							Traversal[GroupedUnits] -> Association[
								"Rule" -> Rule[GroupedUnits, {{"A", 12 Second}, {"B", 10 Minute}}],
								"Limit" -> 50
							],
							Traversal[ID] -> Association[
								"Rule" -> Rule[ID, "id:123"],
								"Limit" -> 50
							]
						],
						"CAS" -> "222"
					]
				]
			],
			"id:123",
			Stubs :> {
				nameCache=Association[
					Object[Example, Data, "my name"] -> Object[Example, Data, "id:123"]
				]
			}
		],

		Test["If given an object with an id that is not cached and the Type field, construct it from the object:",
			getCacheValue[
				Object[Example, Data, "id:222"],
				Null,
				Traversal[Type],
				Association[]
			],
			Object[Example, Data],
			Stubs :> {
				nameCache=Association[]
			}
		],

		Test["If given an object with an id that is not cached and the ID field, construct it from the object:",
			getCacheValue[
				Object[Example, Data, "id:222"],
				Null,
				Traversal[ID],
				Association[]
			],
			"id:222",
			Stubs :> {
				nameCache=Association[]
			}
		],

		Test["If given an object with an id that is not cached and the Object field, return the object:",
			getCacheValue[
				Object[Example, Data, "id:222"],
				Null,
				Traversal[Object],
				Association[]
			],
			Object[Example, Data, "id:222"],
			Stubs :> {
				nameCache=Association[]
			}
		],

		Test["If given an object not in the cache and a field that is not locally computable (Type/Object/ID), return $Failed:",
			getCacheValue[
				Object[Example, Data, "id:222"],
				Null,
				Traversal[Name],
				Association[]
			],
			$Failed
		],

		Test["If given an erroneous input as the first argument, return $Failed:",
			getCacheValue[
				{"A list", "of strings"},
				Null,
				Traversal[Name],
				Association[]
			],
			$Failed
		],

		Test["If given a field part of more than 1 level and the first level does not contain a link, return InvalidLinkField:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				Null,
				Traversal[ID[Name]],
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
							Traversal[ID] -> Association[
								"Rule" -> Rule[ID, "id:123"],
								"Limit" -> 50
							]
						],
						"CAS" -> "222"
					]
				]
			],
			InvalidLinkField[Defer[ID]]
		],

		Test["If given a field part of more than 1 level and the first level does not exist, return default value for a single field:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				Null,
				Traversal[SingleRelation[Name]],
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[],
						"CAS" -> "222"
					]
				]
			],
			Null
		],

		Test["If given a field part of more than 1 level and the first level does not exist, return default value for a multiple field:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				Null,
				Traversal[MultipleAppendRelation[Name]],
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[],
						"CAS" -> "222"
					]
				]
			],
			{}
		],

		Test["If given a field part of more than 1 level and the object at the second level is not in the cache, return $Failed:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				Null,
				Traversal[SingleRelation[Name]],
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
							Traversal[SingleRelation] -> Association[
								"Rule" -> Rule[SingleRelation, Link[Object[Example, Data, "id:abc"]]],
								"Limit" -> 50
							]
						],
						"CAS" -> "222"
					]
				]
			],
			$Failed
		],

		Test["If given a field part of more than 1 level and the object at the second level is not in the cache, return $Failed:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				Null,
				Traversal[SingleRelation[Name]],
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
							Traversal[SingleRelation] -> Association[
								"Rule" -> Rule[SingleRelation, Link[Object[Example, Data, "id:abc"]]],
								"Limit" -> 50
							]
						],
						"CAS" -> "222"
					]
				]
			],
			$Failed
		],

		Test["If given a field part of more than 1 level retrieve all values from the cache:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				Null,
				Traversal[SingleRelation[Name]],
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
							Traversal[SingleRelation] -> Association[
								"Rule" -> Rule[SingleRelation, Link[Object[Example, Data, "id:222"]]],
								"Limit" -> 50
							]
						],
						"CAS" -> "222"
					],
					getObjectCacheKey[Object[Example, Data, "id:222"]] -> Association[
						"Fields" -> Association[
							Traversal[Name] -> Association[
								"Rule" -> Rule[Name, "My Name"],
								"Limit" -> 50
							]
						],
						"CAS" -> "222"
					]
				]
			],
			"My Name"
		],

		Test["If given a field part of more than 1 level, and first level is a list, retrieve all values from the cache:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				Null,
				Traversal[MultipleAppendRelation[Name]],
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
							Traversal[MultipleAppendRelation] -> Association[
								"Rule" -> Rule[MultipleAppendRelation, {Link[Object[Example, Data, "id:222"]], Link[Object[Example, Data, "id:abc"]]}],
								"Limit" -> 50
							]
						],
						"CAS" -> "222"
					],
					getObjectCacheKey[Object[Example, Data, "id:222"]] -> Association[
						"Fields" -> Association[
							Traversal[Name] -> Association[
								"Rule" -> Rule[Name, "My Name"],
								"Limit" -> 50
							]
						],
						"CAS" -> "222"
					]
				]
			],
			{"My Name", $Failed}
		],

		Test["If given Traversal[All] returns all fields in the cache for that object:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				Null,
				Traversal[All],
				Association[
					getObjectCacheKey[Object[Example, Data, "id:123"]] -> Association[
						"Fields" -> Association[
							Traversal[Random] -> Association[
								"Rule" -> Rule[Random, {1, 2, 3}],
								"Limit" -> 50
							],
							Traversal[Name] -> Association[
								"Rule" -> Rule[Name, "My Name"],
								"Limit" -> 50
							],
							Traversal[Type] -> Association[
								"Rule" -> Rule[Type, Object[Example, Data]],
								"Limit" -> 50
							]
						],
						"CAS" -> "222"
					]
				]
			],
			_Association?(And[
				Lookup[#, Random] === {1, 2, 3},
				Lookup[#, Name] === "My Name",
				ContainsAll[Keys[#], Keys[Object[Example, Data]]]
			]&)
		],

		Test["If given Traversal[All] and object is not in the cache, return $Failed:",
			getCacheValue[
				Object[Example, Data, "id:123"],
				Null,
				Traversal[All],
				Association[]
			],
			$Failed
		],

		Test["If given Traversal[All] and a packet, return the packet:",
			getCacheValue[
				<|Object -> Object[Example, Data, "id:123"], Random -> {1, 2, 3}|>,
				Null,
				Traversal[All],
				Association[]
			],
			<|Object -> Object[Example, Data, "id:123"], Random -> {1, 2, 3}|>
		]
	}
];
(* ::Subsubsection::Closed:: *)
(*getObjectCacheKey*)

DefineTests[
	getObjectCacheKey,
	{
		Test["getObjectCacheKey works with just Object param",
			getObjectCacheKey[Object[Example, Data, "id:123"]],
			{Object[Example, Data, "id:123"], None}
		],

		Test["getObjectCacheKey works with Object and Date param",
			With[{date=DateObject[DateString[DateObject[]]]},
				getObjectCacheKey[Object[Example, Data, "id:123"], date]],
			{Object[Example, Data, "id:123"], _DateObject}
		]
	}
];
