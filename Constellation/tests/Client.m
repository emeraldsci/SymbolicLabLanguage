(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

DefineTests[
	DateObjectToRFC3339,
	{
		Example[{Basic, "Converts a DateObject into RFC3339 format:"},
			DateObjectToRFC3339[Now],
			_String
		]
	}
];

DefineTests[
	ProductionQ,
	{
		Example[{Basic, "Returns True if the client is communicating with the production object store:"},
			Login["ben@franklin.org", "lightning", Database -> Production];
			ProductionQ[],
			True
		],

		Example[{Basic, "Returns False if the client is communicating with the test object store:"},
			Login["ben@franklin.org", "lightning", Database -> Test];
			ProductionQ[],
			False
		],

		Example[{Basic, "Returns False if the client is communicating with a malformed url:"},
			Login["ben@franklin.org", "lightning", Database -> ""];
			ProductionQ[],
			False
		]
	},
	SetUp :> (oldDomain=Global`$ConstellationDomain; oldPersonId=$PersonID; oldSite=ECL`$Site),
	TearDown :> (
		(* Set $ConstellationDomain to it's previous value, or the default *)
		Global`$ConstellationDomain=If[ValueQ[oldDomain],
			oldDomain,
			Constellation`Private`ConstellationDomain[Production]
		];
		$PersonID=oldPersonId;
		Unprotect[ECL`$Site];
		ECL`$Site=oldSite;
		Protect[ECL`$Site]
	),
	Stubs :> {
		idToTypeStringCache=<||>,
		idToTypeCache=<||>,
		typeToIdCache=<||>,
		typeStringToIdCache=<||>,
		listObjectTypes[]:=Association[],
		Constellation`Private`doLogin["ben@franklin.org", "lightning", domain_String]:=Association[
			"Success" -> True,
			"Error" -> "",
			"Domain" -> domain,
			"UserId" -> "id:123",
			"Type" -> "Object.User"],
		Constellation`Private`domainChangePromptApproved[___]:=True,
		fetchUserID[]:=Null,
		objectCache=<|
			Object[User, "id:id"] -> <||>
		|>,
		Download[Object[User,Emerald,"id:1234"],ECL`Site[Object]]:=Object[Container,Site,"non-existing test Site for Login"]
	}
];

DefineTests[
	lookupFieldClass,
	{
		Example[{Basic, "Returns the class of our resulting field from search through links:"},
			Constellation`Private`lookupFieldClass[Object[Protocol], Constellation`Private`linkSym[SamplesIn, Constellation`Private`linkSym[Model, Name]], 0],
			String
		],
		Example[{Basic, "Returns the class of our resulting field from search through links:"},
			Constellation`Private`lookupFieldClass[Object[Protocol],
				Constellation`Private`linkSym[SamplesIn,
					Constellation`Private`linkSym[Model,
						Constellation`Private`linkSym[Authors,
							Constellation`Private`linkSym[ProtocolsAuthored,
								DateEnqueued]]]], 0],
			Date,
			TimeConstraint -> 10000
		],
		Example[{Basic, "Returns the class of our resulting field from search through links:"},
			Constellation`Private`lookupFieldClass[Object[Protocol],
				Constellation`Private`linkSym[SamplesIn,
					Constellation`Private`linkSym[Model,
						Constellation`Private`linkSym[Authors,
							Constellation`Private`linkSym[ProtocolsAuthored,
								SamplesIn]]]], 0],
			Link,
			TimeConstraint -> 10000
		],
		Example[{Basic, "Indexed multiples work:"},
			Constellation`Private`lookupFieldClass[Object[Protocol],
				Constellation`Private`linkSym[
					Constellation`Private`partSym[InstrumentLog, 2],
					Constellation`Private`linkSym[Model, PowerConsumption]], 0],
			Real,
			TimeConstraint -> 10000
		]
	}
];

DefineTests[
	packetToJSONData,
	{
		Test["Header fields are skipped:",
			packetToJSONData[<|
				Object -> Object[Example, Person, Emerald, "id:kdkjfdkdk"],
				Type -> Object[Example, Person, Emerald],
				FirstName -> "Test",
				LastName -> "Pilot"
			|>],
			<|
				"FirstName" -> "Test",
				"LastName" -> "Pilot"
			|>
		],
		Test["Null single values are included:",
			packetToJSONData[<|
				Object -> Object[Example, Person, Emerald, "id:kdkjfdkdk"],
				Type -> Object[Example, Person, Emerald],
				FirstName -> "Test",
				MiddleName -> Null,
				LastName -> "Pilot"
			|>],
			<|
				"FirstName" -> "Test",
				"MiddleName" -> Null,
				"LastName" -> "Pilot"
			|>
		],
		Test["Numbers convert:",
			packetToJSONData[<|
				Object -> Object[Example, Data, "id:kdkjfdkdk"],
				Type -> Object[Example, Data],
				Number -> 1.234,
				Random -> {10.567, 100.89}
			|>],
			<|
				"Number" -> 1.234,
				"Random" -> {10.567, 100.89}
			|>
		],
		Test["Links (2W) convert:",
			packetToJSONData[<|
				Object -> Object[Example, Data, "id:4930ce309295"],
				Type -> Object[Example, Data],
				ReplaceRepeated -> {
					Link[Object[Example, Data, "id:1586eb44fb8d"], TestName],
					Link[Object[Example, Data, "id:bf9190fb232a"], TestName],
					Link[Object[Example, Data, "id:96df998c4e50"], TestName, 2]
				}
			|>],
			<|
				"ReplaceRepeated" -> {
					<|
						"$Type" -> "__JsonLink__",
						"object" -> <|
							"id" -> "id:1586eb44fb8d",
							"type" -> "Object.Example.Data"
						|>,
						"field" -> <|
							"name" -> "TestName"
						|>
					|>,
					<|
						"$Type" -> "__JsonLink__",
						"object" -> <|
							"id" -> "id:bf9190fb232a",
							"type" -> "Object.Example.Data"
						|>,
						"field" -> <|
							"name" -> "TestName"
						|>
					|>,
					<|
						"$Type" -> "__JsonLink__",
						"object" -> <|
							"id" -> "id:96df998c4e50",
							"type" -> "Object.Example.Data"
						|>,
						"field" -> <|
							"name" -> "TestName",
							"sub_field_index" -> 2
						|>
					|>
				}
			|>
		],
		Test["Links (2W) convert for multi-leveled types:",
			packetToJSONData[<|
				Object -> Object[Example, Data, "id:4930ce309295"],
				Type -> Object[Example, Data],
				ReplaceRepeated -> {
					Link[Object[Example, Data, Specific, "id:1586eb44fb8d"], TestName],
					Link[Object[Example, Data, Specific, "id:bf9190fb232a"], TestName],
					Link[Object[Example, Data, Specific, "id:96df998c4e50"], TestName, 2]
				}
			|>],
			<|
				"ReplaceRepeated" -> {
					<|
						"$Type" -> "__JsonLink__",
						"object" -> <|
							"id" -> "id:1586eb44fb8d",
							"type" -> "Object.Example.Data.Specific"
						|>,
						"field" -> <|
							"name" -> "TestName"
						|>
					|>,
					<|
						"$Type" -> "__JsonLink__",
						"object" -> <|
							"id" -> "id:bf9190fb232a",
							"type" -> "Object.Example.Data.Specific"
						|>,
						"field" -> <|
							"name" -> "TestName"
						|>
					|>,
					<|
						"$Type" -> "__JsonLink__",
						"object" -> <|
							"id" -> "id:96df998c4e50",
							"type" -> "Object.Example.Data.Specific"
						|>,
						"field" -> <|
							"name" -> "TestName",
							"sub_field_index" -> 2
						|>
					|>
				}
			|>
		],
		Test["Links (1W) convert:",
			packetToJSONData[<|
				Object -> Object[Example, Person, Emerald, "id:4930ce309295"],
				Type -> Object[Example, Person, Emerald],
				OneWayData -> {
					Link[Object[Example, Data, "id:1586eb44fb8d"]],
					Link[Object[Example, Data, "id:bf9190fb232a"]],
					Link[Object[Example, Data, "id:96df998c4e50"]]
				}
			|>],
			<|
				"OneWayData" -> {
					<|
						"$Type" -> "__JsonLink__",
						"object" -> <|
							"id" -> "id:1586eb44fb8d",
							"type" -> "Object.Example.Data"
						|>
					|>,
					<|
						"$Type" -> "__JsonLink__",
						"object" -> <|
							"id" -> "id:bf9190fb232a",
							"type" -> "Object.Example.Data"
						|>
					|>,
					<|
						"$Type" -> "__JsonLink__",
						"object" -> <|
							"id" -> "id:96df998c4e50",
							"type" -> "Object.Example.Data"
						|>
					|>
				}
			|>
		],
		Test["Dates convert:",
			packetToJSONData[<|
				Object -> Object[Example, Data, "id:kdkjfdkdk"],
				Type -> Object[Example, Data],
				DateCreated -> DateObject[{2015, 11, 25}, TimeObject[{21, 53, 32.612062}, TimeZone -> -8], TimeZone -> -8]
			|>],
			<|
				"DateCreated" -> "2015-11-25T21:53:32-08:00"
			|>
		],
		Test["Quantities convert:",
			packetToJSONData[<|
				Object -> Object[Example, Data, "kdkjfdkdk"],
				Type -> Object[Example, Data],
				Temperature -> Quantity[87.0, "Celsius"]
			|>],
			<|
				"Temperature" -> "Quantity[87., \"DegreesCelsius\"]"
			|>
		],
		Test["Compressed compress:",
			packetToJSONData[<|
				Object -> Object[Example, Data, "id:kdkjfdkdk"],
				Type -> Object[Example, Data],
				Compressed -> {{2, 1, -4, -1}, {5, -4, 2, -4}, {-5, -2, -5, -5}, {1, 3, -6, -3}, {-4, -5, -4, -5}, {0, 5, -2, 3}}
			|>],
			<|
				"Compressed" -> "1:eJxTTMoPSmNjYGAoZgESPpnFJWksyLxMJiAjkxFE/Pn//38mEP9HU8EKl2SCsdBU/AZJ/gMRv2EEmgqwBcwg4hdIxV9MFX/g2v/gMIMBpB3sGLBVINMAUnhYOA=="
			|>
		],
		Test["QuantityArrays compress:",
			packetToJSONData[<|
				Object -> Object[Example, Data, "id:kdkjfdkdk"],
				Type -> Object[Example, Data],
				QuantityArray1D -> QuantityArray[{2.3, 1.5, 9.0}, "Meters"]
			|>],
			<|
				"QuantityArray1D" -> If[$VersionNumber > 12.0,
					"1:eJxTTMoPSmNkYGAo5gUSgaWJeSWZJZWORUWJlWlMIGE5IBFcUlSaXFJalJoClkhA8F0SSxIh2lmAhE9mcYkniGecxowslgoSA4mkgQGTAwMY/LCH0EoOwWxAyje1JLWoGNU0VF4miAcAQ1onCA==",
					"1:eJxTTMoPSmNmYGAo5gcSwSVFpcklpUWpKY5FRYmVxbxAscDSxLySzJJKsEgaI0gpC5DwySwu8QTxjNNA3GI5TO0JCL5LYkkipmmpIP0gy9PAgMmBAQx+2ENoJYdgNiDlm1qSWlSMajMqLxPEAwAeJTEk"
				]
			|>
		],
		Test["EmeraldCloudFiles (with IDs) encode as InputForm:",
			packetToJSONData[<|
				Object -> Object[Example, Data, "id:kdkjfdkdk"],
				Type -> Object[Example, Data],
				S3Single -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-dev", "2014/09/19/200d09e73692d0c7a3bd3e3ca05d5c83.png", "DUMMY_CLOUD_FILE_ID"]
			|>],
			<|
				(* consider matching jsonEmeraldCloudFileP *)
				"S3Single" -> <|
					"$Type" -> "__JsonEmeraldCloudFile__",
					"Bucket" -> "emeraldsci-ecl-dev",
					"Key" -> "2014/09/19/200d09e73692d0c7a3bd3e3ca05d5c83.png",
					"CloudFileId" -> "DUMMY_CLOUD_FILE_ID"
				|>
			|>
		],
		Test["EmeraldCloudFiles (without IDs) encode as InputForm:",
			packetToJSONData[<|
				Object -> Object[Example, Data, "id:kdkjfdkdk"],
				Type -> Object[Example, Data],
				S3Single -> EmeraldCloudFile["AmazonS3", "emeraldsci-ecl-dev", "2014/09/19/200d09e73692d0c7a3bd3e3ca05d5c83.png"]
			|>],
			<|
				(* consider matching jsonEmeraldCloudFileP *)
				"S3Single" -> <|
					"$Type" -> "__JsonEmeraldCloudFile__",
					"Bucket" -> "emeraldsci-ecl-dev",
					"Key" -> "2014/09/19/200d09e73692d0c7a3bd3e3ca05d5c83.png"
				|>
			|>
		],
		Test["GroupedMultiples convert:",
			packetToJSONData[<|
				Object -> Object[Example, Data, "id:kdkjfdkdk"],
				Type -> Object[Example, Data],
				GroupedMultipleReplaceRelation -> {
					{"Row 1", Link[Object[Example, Data, "id:c59010bd2db6"], GroupedMultipleReplaceRelationAmbiguous, 2]},
					{"Row 2", Link[Object[Example, Data, "id:3a226a611893"], GroupedMultipleReplaceRelationAmbiguous, 2]},
					{"Row 3", Link[Object[Example, Data, "id:0f6b49227e7e"], GroupedMultipleReplaceRelationAmbiguous, 2]}
				}
			|>],
			<|
				"GroupedMultipleReplaceRelation" -> {
					{"Row 1", <|
						"$Type" -> "__JsonLink__",
						"object" -> <|
							"id" -> "id:c59010bd2db6",
							"type" -> "Object.Example.Data"
						|>,
						"field" -> <|
							"name" -> "GroupedMultipleReplaceRelationAmbiguous",
							"sub_field_index" -> 2
						|>
					|>},
					{"Row 2", <|
						"$Type" -> "__JsonLink__",
						"object" -> <|
							"id" -> "id:3a226a611893",
							"type" -> "Object.Example.Data"
						|>,
						"field" -> <|
							"name" -> "GroupedMultipleReplaceRelationAmbiguous",
							"sub_field_index" -> 2
						|>
					|>},
					{"Row 3", <|
						"$Type" -> "__JsonLink__",
						"object" -> <|
							"id" -> "id:0f6b49227e7e",
							"type" -> "Object.Example.Data"
						|>,
						"field" -> <|
							"name" -> "GroupedMultipleReplaceRelationAmbiguous",
							"sub_field_index" -> 2
						|>
					|>}
				}
			|>
		],
		Test["Indexed Singles with Link convert:",
			packetToJSONData[<|
				Object -> Object[Example, Data, "id:kdkjfdkdk"],
				Type -> Object[Example, Data],
				IndexedSingle -> {10, "One", Link[Object[Example, Data, "id:c59010bd2db6"], IndexedSingleBacklink]}
			|>],
			<|
				"IndexedSingle" -> {
					"Quantity[10, \"Meters\"]",
					"One",
					<|
						"$Type" -> "__JsonLink__",
						"object" -> <|
							"id" -> "id:c59010bd2db6",
							"type" -> "Object.Example.Data"
						|>,
						"field" -> <|
							"name" -> "IndexedSingleBacklink"
						|>
					|>
				}
			|>
		],
		Test["Expressions convert:",
			packetToJSONData[<|
				Object -> Object[Example, Data, "id:kdkjfdkdk"],
				Type -> Object[Example, Data],
				FitFunction -> Function[myInput, myInput^2]
			|>],
			<|
				"FitFunction" -> "Function[Constellation`Private`myInput, Constellation`Private`myInput^2]"
			|>
		],
		Test["Integers are auto-converted to Reals:",
			packetToJSONData[<|
				Type -> Object[Example, Data],
				Random -> {1}
			|>],
			<|
				"Random" -> {1.0}
			|>
		],
		Test["Ignores the ID key:",
			packetToJSONData[<|
				Type -> Object[Example, Data],
				Random -> {1},
				ID -> "id:1234"
			|>],
			<|
				"Random" -> {1.0}
			|>
		],
		Test["VariableUnit data is encoded correctly",
			packetToJSONData@<|
				Type -> Object[Example, Data],
				DeveloperObject -> True,
				VariableUnitData -> 3 Gallon
			|>,
			KeyValuePattern[{
				"DeveloperObject" -> "True",
				"VariableUnitData" -> KeyValuePattern[{
					"$Type" -> "__JsonVariableUnit__",
					"mathematica_value" -> "Quantity[3, \"Gallons\"]",
					"search_dimension" -> {KeyValuePattern[{ "Name" -> "LengthUnit", "Exponent" -> 3 }]},
					"search_value" -> ToString[0.011356235352`, InputForm]
				}]
			}]
		],
		Test["Integers are auto-converted to Reals:",
			packetToJSONData[<|
				Type -> Object[Example, Data],
				Random -> {1}
			|>],
			<|
				"Random" -> {1.0}
			|>
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*searchClauseString*)


DefineTests[
	searchClauseString,
	{
		Test["Equalites work:",
			searchClauseString[Name == "Some Name" && Random == 10.200, Type -> Object[Example, Data]],
			"DeveloperObject!=\"True\" AND Name=\"Some Name\" AND Random=10.2"
		],

		Test["Equality with the Type field:",
			searchClauseString[Name == "Some Name" && Type == Object[Example, Data]],
			"DeveloperObject!=\"True\" AND Name=\"Some Name\" AND Type=\"Object.Example.Data\""
		],

		Test["Equality with named sub-field:",
			searchClauseString[NamedSingle[[UnitColumn]] == 4],
			"DeveloperObject!=\"True\" AND NamedSingle[[UnitColumn]]=4"
		],

		Test["Equality with named sub-field and Type option:",
			searchClauseString[NamedSingle[[UnitColumn]] == 4, Type -> Object[Example, Data]],
			"DeveloperObject!=\"True\" AND NamedSingle[[UnitColumn]]=4"
		],

		Test["Inequality with the Type field:",
			searchClauseString[Name == "Some Name" && Type != Object[Example, Data]],
			"DeveloperObject!=\"True\" AND Name=\"Some Name\" AND Type!=\"Object.Example.Data\""
		],

		Test["Inequalities work:",
			{
				searchClauseString[Random > 10.200 && Number >= 100, Type -> Object[Example, Data]],
				searchClauseString[Random < -10.100 && Number <= 32.2, Type -> Object[Example, Data]]
			},
			{
				"DeveloperObject!=\"True\" AND Random>10.2 AND Number>=100",
				"DeveloperObject!=\"True\" AND Random<-10.1 AND Number<=32.2"
			}
		],
		Test["Or clauses are ordered correctly:",
			searchClauseString[Random > 10.2 && Number >= 100 || Random < -10.1, Type -> Object[Example, Data]],
			"DeveloperObject!=\"True\" AND Random>10.2 AND Number>=100 OR DeveloperObject!=\"True\" AND Random<-10.1"
		],
		Test["Object heads result in the ID part of the string:",
			searchClauseString[Random == 10.2 && SingleRelation == Object[Example, Data, "id:1ZA60vwjlVMP"], Type -> Object[Example, Data]],
			"DeveloperObject!=\"True\" AND Random=10.2 AND SingleRelation=\"id:1ZA60vwjlVMP\""
		],
		Test["Object heads with names are displayed full:",
			searchClauseString[Random == 10.2 && SingleRelation == Object[Example, Data, "Rosey"], Type -> Object[Example, Data]],
			"DeveloperObject!=\"True\" AND Random=10.2 AND SingleRelation=\"Object[Example,Data,\\\"Rosey\\\"]\""
		],
		Test["Part translates:",
			searchClauseString[Random == 10.2 && GroupedMultipleAppendRelation[[2]] == Object[Example, Data, "id:1ZA60vwjlVMP"], Type -> Object[Example, Data]],
			"DeveloperObject!=\"True\" AND Random=10.2 AND GroupedMultipleAppendRelation[[2]]=\"id:1ZA60vwjlVMP\""
		],
		Test["Variables resolve:",
			With[
				{val="SomeInterestingValue", objId=Object[Example, Data, "id:1ZA60vwjlVMP"]},
				searchClauseString[Name == val && Random >= 10.1 && SingleRelation == objId, Type -> Object[Example, Data]]
			],
			"DeveloperObject!=\"True\" AND Name=\"SomeInterestingValue\" AND Random>=10.1 AND SingleRelation=\"id:1ZA60vwjlVMP\""
		],
		Test["DateObjects convert to strings:",
			searchClauseString[Random >= 10 && DateCreated < DateObject[{2016, 2, 9}, TimeObject[{13, 8, 0}, TimeZone -> -8.], TimeZone -> -8.], Type -> Object[Example, Data]],
			"DeveloperObject!=\"True\" AND Random>=10 AND DateCreated<\"2016-02-09T13:08:00-08:00\""
		],
		Test["Units convert:",
			searchClauseString[GroupedUnits[[2]] == 120 Kilo Second, Type -> Object[Example, Data]],
			"DeveloperObject!=\"True\" AND GroupedUnits[[2]]=120000."
		],
		Test["Boolean True works:",
			searchClauseString[BooleanField == True, Type -> Object[Example, Data]],
			"DeveloperObject!=\"True\" AND BooleanField=true"
		],
		Test["Boolean False works:",
			searchClauseString[BooleanField == False, Type -> Object[Example, Data]],
			"DeveloperObject!=\"True\" AND BooleanField=false"
		],
		Test["Setting $DeveloperSearch to True includes a DeveloperObject==True condition:",
			Block[{$DeveloperSearch=True},
				searchClauseString[BooleanField == False, Type -> Object[Example, Data]]
			],
			"DeveloperObject=\"True\" AND BooleanField=false"
		],
		Test["Setting $DeveloperSearch to True includes a DeveloperObject==True condition even if the DeveloperObject option is False:",
			Block[{$DeveloperSearch=True},
				searchClauseString[BooleanField == False, Type -> Object[Example, Data], DeveloperObject -> False]
			],
			"DeveloperObject=\"True\" AND BooleanField=false"
		],
		Test["A Search clause that explicitly includes a DeveloperObject condition will be left alone even if $DeveloperSearch is True:",
			Block[{$DeveloperSearch=True},
				searchClauseString[DeveloperObject != True, Type -> Object[Example, Data]]
			],
			"DeveloperObject!=\"True\""
		],
		Test["VariableUnit data is encoded with normalized search_value and search_dimension as Base64 JSON:",
			searchClauseString[
				VariableUnitData == 7 Gallon && DeveloperObject == True,
				Type -> Object[Example, Data]
			],
			_String?(Module[
				{encodedVal, noLF},
				encodedVal=ExportString[
					<|
						"search_dimension" -> {<|"Name" -> "LengthUnit", "Exponent" -> 3|>},
						"search_value" -> ToString[0.026497882488, InputForm] (* 7 gallons is 0.026 m^3, after all *)
					|>,
					{"Base64", "RawJSON"}
				];
				noLF=StringReplace[encodedVal, WhitespaceCharacter -> ""];
				StringContainsQ[#, "VariableUnitData=\"base64:"<>noLF<>"\""]
			]&)
		],
		(* -- Comparator Condition Tests -- *)
		Test["Comparator conditions are distributed within And/Or operators:",
			Block[{$DeveloperSearch=True},
				Constellation`Private`searchClauseString[All[FillToVolumeRatios > 0.5 && FillToVolumeRatios < 1]]
			],
			"DeveloperObject=\"True\" AND All{FillToVolumeRatios>0.5 AND FillToVolumeRatios<1}"
		],
		Test["Comparator conditions work with explicit distribution across And/Or:",
			Block[{$DeveloperSearch=True},
				Constellation`Private`searchClauseString[All[FillToVolumeRatios > 0.5] && All[FillToVolumeRatios < 1]]
			],
			"DeveloperObject=\"True\" AND All{FillToVolumeRatios>0.5} AND All{FillToVolumeRatios<1}"
		],
		Test["Comparator conditions work with explicit distribution across And/Or, using multiple condition types:",
			Block[{$DeveloperSearch=True},
				Constellation`Private`searchClauseString[All[FillToVolumeRatios > 0.5] && Any[FillToVolumeRatios < 1]]
			],
			"DeveloperObject=\"True\" AND All{FillToVolumeRatios>0.5} AND Any{FillToVolumeRatios<1}"
		],
		Test["Exactly[...] with a single field:",
			Block[{$DeveloperSearch=True},
				Constellation`Private`searchClauseString[Exactly[Mass == 1Gram], Type -> Object[Sample]]
			],
			"DeveloperObject=\"True\" AND Exactly{Mass=1.}"
		],
		Test["Exactly[...] with a single field:",
			Block[{$DeveloperSearch=True},
				Constellation`Private`searchClauseString[Exactly[Mass == 1Gram], Type -> Object[Sample]]
			],
			"DeveloperObject=\"True\" AND Exactly{Mass=1.}"
		],
		Test["Exactly[...] with a multiple field:",
			Block[{$DeveloperSearch=True},
				Constellation`Private`searchClauseString[Exactly[Synonyms == {"Milli-Q water", "Type 1"}], Type -> Model[Sample]]
			],
			"DeveloperObject=\"True\" AND Exactly{Synonyms={\"Milli-Q water\", \"Type 1\"}}"
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*fieldSequenceToTraversal*)


DefineTests[fieldSequenceToTraversal,
	{
		Test["Single symbol returns one traversal with Name key:",
			fieldSequenceToTraversal[Traversal[DateCreated], False],
			"next" -> {<|"name" -> "DateCreated"|>}
		],

		Test["Multiple symbols returns nested associations with Name key:",
			fieldSequenceToTraversal[Traversal[SamplesIn, Model, Name], False],
			"next" -> {<|
				"name" -> "SamplesIn",
				"next" -> {<|
					"name" -> "Model",
					"next" -> {<|
						"name" -> "Name"
					|>}
				|>}
			|>}
		],

		Test["All followed by an integer adds part information:",
			fieldSequenceToTraversal[Traversal[Query[Key[Contents], All, 2], Name], False],
			"next" -> {<|
				"name" -> "Contents",
				"columns" -> <|
					"start" -> 2,
					"end" -> 2
				|>,
				"next" -> {<|
					"name" -> "Name"
				|>}
			|>}
		],

		Test["Single index from a field:",
			fieldSequenceToTraversal[Traversal[Query[Key[Contents], 2]], False],
			"next" -> {<|
				"name" -> "Contents",
				"rows" -> <|
					"start" -> 2,
					"end" -> 2
				|>
			|>}
		],

		Test["All from a field:",
			fieldSequenceToTraversal[Traversal[Contents, All], False],
			"next" -> {<|
				"name" -> "Contents",
				"next" -> {<|
					"name" -> "All"
				|>}
			|>}
		],

		Test["Symbol followed by an integer adds part information:",
			fieldSequenceToTraversal[Traversal[Query[Key[Contents], 2], Name], False],
			"next" -> {<|
				"name" -> "Contents",
				"rows" -> <|
					"start" -> 2,
					"end" -> 2
				|>,
				"next" -> {<|
					"name" -> "Name"
				|>}
			|>}
		],

		Test["Combine a part span and list of indices:",
			fieldSequenceToTraversal[Traversal[Query[Key[Contents], 2;;6, {1, 3}], Name], False],
			"next" -> {<|
				"name" -> "Contents",
				"rows" -> <|
					"start" -> 2,
					"end" -> 6
				|>,
				"columns" -> <|
					"indices" -> {1, 3}
				|>,
				"next" -> {<|
					"name" -> "Name"
				|>}
			|>}
		],

		Test["If All is last in the sequence, treat it as a field:",
			fieldSequenceToTraversal[Traversal[Query[Key[Contents], 2;;6], All], False],
			"next" -> {<|
				"name" -> "Contents",
				"rows" -> <|
					"start" -> 2,
					"end" -> 6
				|>,
				"next" -> {<|
					"name" -> "All"
				|>}
			|>}
		],

		Test["Repeated single field:",
			fieldSequenceToTraversal[Traversal[Repeated[Traversal[Container], "tag"]], False],
			"next" -> {<|
				"name" -> "Container",
				"tag" -> "tag",
				"repeat" -> <|
					"max" -> -1,
					"where" -> "",
					"inclusive_search" -> False
				|>
			|>}
		],

		Test["Repeated single field with maximum number of repetitions:",
			fieldSequenceToTraversal[Traversal[Repeated[Traversal[Container], 5, "tag"]], False],
			"next" -> {<|
				"name" -> "Container",
				"tag" -> "tag",
				"repeat" -> <|
					"max" -> 5,
					"where" -> "",
					"inclusive_search" -> False
				|>
			|>}
		],

		Test["Repeated single field with stop condition:",
			fieldSequenceToTraversal[
				Traversal[Repeated[Traversal[Container], "search condition", "tag"]],
				True
			],
			"next" -> {<|
				"name" -> "Container",
				"tag" -> "tag",
				"repeat" -> <|
					"max" -> -1,
					"where" -> "search condition",
					"inclusive_search" -> True
				|>
			|>}
		],

		Test["Repeated nested field:",
			fieldSequenceToTraversal[Traversal[Repeated[Traversal[Protocols, SamplesIn], "tag"]], False],
			"next" -> {<|
				"name" -> "Protocols",
				"tag" -> "tag",
				"repeat" -> <|
					"max" -> -1,
					"next" -> <|
						"name" -> "SamplesIn"
					|>,
					"where" -> "",
					"inclusive_search" -> False
				|>
			|>}
		],

		Test["Repeated multiple field:",
			fieldSequenceToTraversal[
				Traversal[Repeated[Traversal[Query[Key[Contents], All, 2]], "tag"]],
				False
			],
			"next" -> {KeyValuePattern[{
				"name" -> "Contents",
				"tag" -> "tag",
				"columns" -> <|
					"start" -> 2,
					"end" -> 2
				|>,
				"repeat" -> <|
					"max" -> -1,
					"where" -> "",
					"inclusive_search" -> False
				|>
			}]}
		],

		Test["Spans:",
			fieldSequenceToTraversal[Traversal[Contents[[2;;3, 1;;2]]], False],
			"next" -> {<|
				"name" -> "Contents",
				"rows" -> <|
					"start" -> 2,
					"end" -> 3
				|>,
				"columns" -> <|
					"start" -> 1,
					"end" -> 2
				|>
			|>}
		],

		Test["Indices:",
			fieldSequenceToTraversal[Traversal[Contents[[{1, 2}, {3}]]], False],
			"next" -> {<|
				"name" -> "Contents",
				"rows" -> <|"indices" -> {1, 2}|>,
				"columns" -> <|"indices" -> {3}|>
			|>}
		],

		Test["List of fields",
			fieldSequenceToTraversal[Traversal[Model[{Name, Products, Authors}]], False],
			"next" -> {<|
				"name" -> "Model",
				"next" -> {
					<|"name" -> "Name"|>,
					<|"name" -> "Products"|>,
					<|"name" -> "Authors"|>
				}
			|>}
		]
	}
];


DefineTests[Rfc3339ToDateObject,
	{
		Example[{Basic, "Returns a date object in the format used in Constellation APIs."},
			Rfc3339ToDateObject["2022-03-28T20:16:42.815644Z"],
			_?DateObjectQ
		],
		Example[{Basic, "Returns None when an empty string in inputted:"},
			Rfc3339ToDateObject[""],
			None
		],
		Example[{Basic, "Returns a another date object in the format used in Constellation APIs."},
			Rfc3339ToDateObject["2022-03-28T20:22:20.588881Z"],
			_?DateObjectQ
		]
	}
];

DefineTests[ConstellationObjectReferenceAssoc,
	{
		Example[{Basic, "Object references can be converted to associations:"},
			ConstellationObjectReferenceAssoc[Object[Resource, Sample, "id:999999999999"]],
			<|
				"id" -> "id:999999999999",
				"type" -> "Object.Resource.Sample"
			|>
		],
		Example[{Basic, "Model references can be converted to associations:"},
			ConstellationObjectReferenceAssoc[Model[Resource, Sample, "id:999999999999"]],
			<|
				"id" -> "id:999999999999",
				"type" -> "Model.Resource.Sample"
			|>
		],
		Example[{Basic, "Model references can be converted to associations (by name):"},
			ConstellationObjectReferenceAssoc[Object[Resource, Sample, "Sample Name sldkfjasdfs"]],
			<|
				"name" -> "Sample Name sldkfjasdfs",
				"type" -> "Object.Resource.Sample"
			|>
		]
	}
];

DefineTests[transformHeldExpressionToStandardizedTreeForm,
	{
		Test["Double Nested Test with nested ANDs and ORs",
			transformHeldExpressionToStandardizedTreeForm[PriorityProtocol == Null && (CurrentProtocol[Priority] == False || CurrentProtocol[Priority] == Null)],
			Constellation`Private`orSym[
				Constellation`Private`andSym[
					Constellation`Private`equalsSym[PriorityProtocol, Null],
					Constellation`Private`equalsSym[
						Constellation`Private`linkSym[CurrentProtocol, Priority], False]],
				Constellation`Private`andSym[
					Constellation`Private`equalsSym[PriorityProtocol, Null],
					Constellation`Private`equalsSym[
						Constellation`Private`linkSym[CurrentProtocol, Priority], Null]]
			]
		]
	}
];