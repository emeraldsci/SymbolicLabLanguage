(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection::Closed:: *)
(*ValidPacketFormatQ*)


DefineTests[
	ValidPacketFormatQ,
	{
		Test["If Object specified, its type matches the Type:",
			ValidPacketFormatQ[<|Type -> Object[Example, Data], Object -> Object[Example, Data, "12jdkskl"]|>],
			True
		],

		Test["Accepts a list of packets:",
			ValidPacketFormatQ[{
				<|Type -> Object[Example, Data], Object -> Object[Example, Data, "12jdkskl"]|>,
				<|Type -> Object[Example, Person, Emerald], Object -> Object[Example, Person, Emerald, "abd1casc1"]|>
			}],
			True
		],

		Test["Fails if Object type does not match packet Type.:",
			ValidPacketFormatQ[<|Type -> Object[Example, Person, Emerald], Object -> Object[Example, Data, "12jdkskl"]|>],
			False
		],

		Test["Ignores Units field:",
			ValidPacketFormatQ[<|Type -> Object[Example, Data], Units -> {Kelvin, Celsius}|>],
			True
		],

		Example[{Additional, "Ignores computable fields (RuleDelayed):"},
			ValidPacketFormatQ[<|Type -> Object[Example, Data], Thing :> "HELP!"|>],
			True
		],

		Test["Ignores failing storage patterns when the value is null (singles):",
			ValidPacketFormatQ[<|Type -> Object[Example, Data], Name -> Null|>],
			True
		],

		Test["Ignores failing storage patterns when the value is null (multiples):",
			ValidPacketFormatQ[<|Type -> Object[Example, Data], Random -> Null, GroupedMultipleAppendRelation -> Null, GroupedUnits -> Null|>],
			True
		],

		Test["Non-grouped multiple Lists with just a single Null are allowed:",
			ValidPacketFormatQ[<|Type -> Object[Example, Data], Random -> {Null}|>],
			True
		],

		Test["Non-grouped multiple Links Lists with just a single Null are allowed:",
			ValidPacketFormatQ[<|Type -> Object[Example, Data], MultipleAppendRelation -> {Null}|>],
			True
		],

		Test["Ignores failing storage patterns when a multiple value is an empty list:",
			ValidPacketFormatQ[<|Type -> Object[Example, Data], Random -> {}|>],
			True
		],

		Test["Ignores failing storage patterns when a grouped multiple value is null:",
			ValidPacketFormatQ[<|Type -> Object[Example, Data], GroupedMultipleAppendRelation -> {{Null, Null}}|>],
			True
		],

		Test["Ignores failing storage patterns when a grouped multiple value is an empty list:",
			ValidPacketFormatQ[<|Type -> Object[Example, Data], GroupedMultipleAppendRelation -> {}|>],
			True
		],

		Example[{Basic, "Returns False if field not in definition:"},
			ValidPacketFormatQ[<|Type -> Object[Example, Data], Smorgasbord -> "Ja"|>],
			False
		],

		Example[{Basic, "Returns False if field value does not match storage pattern in definition:"},
			ValidPacketFormatQ[<|Type -> Object[Example, Data], Temperature -> "Ja"|>],
			False
		],

		Test["Returns False if one entry in multiple field does not match storage pattern in definition:",
			ValidPacketFormatQ[<|Type -> Object[Example, Data], Random -> {1, 2, "HAHAHA"}|>],
			False
		],

		Test["Returns False if one entry in multiple field does not match storage pattern in definition:",
			ValidPacketFormatQ[<|
				Type -> Object[Example, Data],
				GroupedMultipleAppendRelation -> {
					{"String", Object[Example, Data, "f0addaa5c1fd"]},
					{NotAString, 1}
				}
			|>],
			False
		],

		Example[{Additional, "If field has default Units and none are specified, add them before checking validity:"},
			ValidPacketFormatQ[<|Type -> Object[Example, Data], Temperature -> 10|>],
			True
		],

		Test["Returns False If multiple field value not in List return:",
			ValidPacketFormatQ[<|Type -> Object[Example, Data], MultipleAppendRelation -> Object[Example, Data, "f0addaa5c1fd"]|>],
			False
		],

		Example[{Options, Strict, "Returns False if computable field does not match its storage pattern when Strict -> True:"},
			ValidPacketFormatQ[<|Type -> Object[User, Emerald, Developer], Photo :> Taco|>, Strict -> True],
			False
		],

		Test["Returns True if computable field does match its storage pattern when Strict -> True:",
			ValidPacketFormatQ[<|Type -> Object[User, Emerald, Developer], Photo :> Null|>, Strict -> True],
			True
		],

		Test["Returns False if computable field does match its storage pattern when Strict -> False:",
			ValidPacketFormatQ[<|Type -> Object[Example, Person, Emerald], FullName :> ""|>],
			True
		],

		Test["Returns False If grouped multiple field value not in List return:",
			ValidPacketFormatQ[<|Type -> Object[Example, Data], GroupedMultipleAppendRelation -> Object[Example, Data, "f0addaa5c1fd"]|>],
			False
		],

		Test["Returns False If grouped multiple field value not in nested List:",
			ValidPacketFormatQ[<|Type -> Object[Example, Data], GroupedMultipleAppendRelation -> {Object[Example, Data, "f0addaa5c1fd"]}|>],
			False
		],

		Example[{Options, Verbose, "Verbose Option prints the individual field checks:"},
			ValidPacketFormatQ[<|Type -> Object[Example, Data], Temperature -> 10|>],
			True
		],

		Test["Indexed multiple fields with Units not specified and one value is Null returns True:",
			ValidPacketFormatQ[<|Type -> Object[Example, Data], GroupedUnits -> {{"String", 10}, {"Stringy", Null}}|>],
			True
		],

		Test["Link head is required:",
			ValidPacketFormatQ[<|Type -> Object[Example, Data], MultipleAppendRelation -> {Object[Example, Data, "f0addaa5c1fd"]}|>],
			False
		],
		Test["Link head is required:",
			ValidPacketFormatQ[<|
				Type -> Object[Example, Data],
				MultipleAppendRelation -> {Link[Object[Example, Data, "f0addaa5c1fd"], MultipleAppendRelationAmbiguous]}
			|>],
			True
		],
		Test["One-way Links are ok, if configured:",
			ValidPacketFormatQ[<|
				Type -> Object[Example, Person, Emerald],
				OneWayData -> {Link[Object[Example, Data, "f0addaa5c1fd"]]}
			|>],
			True
		],
		Test["Temporal Links are not ok on Link Fields:",
			ValidPacketFormatQ[<|
				Type -> Object[Example, Person, Emerald],
				OneWayData -> {Link[Object[Example, Data, "f0addaa5c1fd"], Now]}
			|>],
			False
		],
		Test["Temporal Links are ok on Temporal Link Fields:",
			ValidPacketFormatQ[<|
				Type -> Object[Example, Person, Emerald],
				OneWayDataTemporal -> {Link[Object[Example, Data, "f0addaa5c1fd"], Now]}
			|>],
			True
		],
		Test["Links are ok on Temporal Link Fields, if configured:",
			ValidPacketFormatQ[<|
				Type -> Object[Example, Person, Emerald],
				OneWayDataTemporal -> {Link[Object[Example, Data, "f0addaa5c1fd"]]}
			|>],
			True
		],
		Test["Fails if link points to an incorrect type:",
			ValidPacketFormatQ[<|
				Type -> Object[Example, Data],
				MultipleAppendRelation -> {Link[Object[Example, Person, Emerald, "f0addaa5c1fd"], MultipleAppendRelationAmbiguous]}
			|>],
			False
		],
		Test["Fails if link points to an incorrect field:",
			ValidPacketFormatQ[<|
				Type -> Object[Example, Data],
				MultipleAppendRelation -> {Link[Object[Example, Data, "f0addaa5c1fd"], TestRun]}
			|>],
			False
		],
		Example[{Options, DisplayFunction, "The printed list of packets can be modified:"},
			ValidPacketFormatQ[
				<|Type -> Object[Example, Data]|>,
				DisplayFunction -> (Style[#, FontColor -> Red]&)
			],
			True
		]
	},
	Stubs :> {
		PrintTemporary[___]:=Null,
		Print[___]:=Null
	}
];


(* ::Subsubsection::Closed:: *)
(*ValidUploadQ*)

DefineTests[
	ValidUploadQ,
	{
		Test["If Object specified, its type matches the Type:",
			ValidUploadQ[<|Type -> Object[Example, Data], Object -> Object[Example, Data, "12jdkskl"]|>],
			True
		],

		Test["Accepts a list of uploads:",
			ValidUploadQ[{
				<|Type -> Object[Example, Data], Object -> Object[Example, Data, "12jdkskl"]|>,
				<|Type -> Object[Example, Person, Emerald], Object -> Object[Example, Person, Emerald, "abd1casc1"]|>
			}],
			True
		],

		Test["Fails if Object type does not match packet Type.:",
			ValidUploadQ[<|Type -> Object[Example, Person, Emerald], Object -> Object[Example, Data, "12jdkskl"]|>],
			False
		],

		Example[{Additional, "Ignores all delayed rules:"},
			ValidUploadQ[<|Type -> Object[Example, Data], ComputableName :> "HELP!"|>],
			True
		],

		Test["Ignores failing storage patterns when the value is Null for single fields:",
			ValidUploadQ[<|Type -> Object[Example, Data], Name -> Null|>],
			True
		],

		Test["Returns False for Append[MultipleField] -> Null:",
			ValidUploadQ[<|Type -> Object[Example, Data], Append[Random] -> Null, Replace[GroupedMultipleAppendRelation] -> Null, Replace[GroupedUnits] -> Null|>],
			False
		],

		Test["Returns True if given {Null} for a multiple field:",
			ValidUploadQ[<|Type -> Object[Example, Data], Replace[Random] -> {Null}|>],
			True
		],

		Test["Returns True if given {Null} for a multiple field that is a link:",
			ValidUploadQ[<|Type -> Object[Example, Data], Append[MultipleAppendRelation] -> {Null}|>],
			True
		],

		Test["Appending an empty list to a multiple field is valid:",
			ValidUploadQ[<|Type -> Object[Example, Data], Append[Random] -> {}|>],
			True
		],

		Test["Replacing a multiple field with an empty list is valid:",
			ValidUploadQ[<|Type -> Object[Example, Data], Replace[Random] -> {}|>],
			True
		],

		Test["Ignores failing storage patterns when a grouped multiple value is null:",
			ValidUploadQ[<|Type -> Object[Example, Data], Append[GroupedMultipleAppendRelation] -> {{Null, Null}}|>],
			True
		],

		Test["Ignores failing storage patterns when a grouped multiple value is an empty list:",
			ValidUploadQ[<|Type -> Object[Example, Data], Replace[GroupedMultipleAppendRelation] -> {}|>],
			True
		],

		Example[{Basic, "Returns False if field not in definition:"},
			ValidUploadQ[<|Type -> Object[Example, Data], Smorgasbord -> "Ja"|>],
			False
		],

		Example[{Basic, "Returns False if field value does not match storage pattern in definition:"},
			ValidUploadQ[<|Type -> Object[Example, Data], Temperature -> "Ja"|>],
			False
		],

		Test["Returns False if one entry in multiple field does not match storage pattern in definition:",
			ValidUploadQ[<|Type -> Object[Example, Data], Append[Random] -> {1, 2, "HAHAHA"}|>],
			False
		],

		Test["Returns False if one entry in an indexed multiple field does not match storage pattern in definition:",
			ValidUploadQ[<|
				Type -> Object[Example, Data],
				Replace[GroupedMultipleAppendRelation] -> {
					{"String", Object[Example, Data, "f0addaa5c1fd"]},
					{NotAString, 1}
				}
			|>],
			False
		],

		Example[{Additional, "If field has default Units and none are specified, add them before checking validity:"},
			ValidUploadQ[<|Type -> Object[Example, Data], Temperature -> 10|>],
			True
		],

		Test["Returns False if multiple field value not in List return:",
			ValidUploadQ[<|Type -> Object[Example, Data], Append[MultipleAppendRelation] -> Object[Example, Data, "f0addaa5c1fd"]|>],
			False
		],

		Test["Returns False if multiple field is not wrapped in Append|Replace:",
			ValidUploadQ[<|Type -> Object[Example, Data], Random -> {1, 2, 3}|>],
			False
		],

		Test["Returns False if any keys are not _Symbol|(Append|Replace)[_Symbol]:",
			ValidUploadQ[<|Type -> Object[Example, Data], Thing[Random] -> {1, 2, 3}, 4 -> 5|>],
			False
		],

		Test["Returns True if single field is wrapped in Append|Replace:",
			ValidUploadQ[<|Type -> Object[Example, Data], Append[Temperature] -> 12|>],
			True
		],

		Test["Returns False if indexed multiple field value not in List:",
			ValidUploadQ[<|Type -> Object[Example, Data], Append[GroupedMultipleAppendRelation] -> Object[Example, Data, "f0addaa5c1fd"]|>],
			False
		],

		Test["Returns False if indexed multiple field value not in nested List:",
			ValidUploadQ[<|Type -> Object[Example, Data], Append[GroupedMultipleAppendRelation] -> {Object[Example, Data, "f0addaa5c1fd"]}|>],
			False
		],

		Example[{Options, Verbose, "Verbose Option prints the individual field checks:"},
			ValidUploadQ[<|Type -> Object[Example, Data], Temperature -> 10|>, Verbose -> True],
			True
		],

		Test["Indexed multiple fields with Units not specified and one value is Null returns True:",
			ValidUploadQ[<|Type -> Object[Example, Data], Append[GroupedUnits] -> {{"String", 10}, {"Stringy", Null}}|>],
			True
		],

		Test["Returns false if Link head is missing for multiple fields which are links:",
			ValidUploadQ[<|Type -> Object[Example, Data], Append[MultipleAppendRelation] -> {Object[Example, Data, "f0addaa5c1fd"]}|>],
			False
		],

		Test["Returns True when links are fully specified for multiple fields which are links:",
			ValidUploadQ[
				<|
					Type -> Object[Example, Data],
					Append[MultipleAppendRelation] -> {Link[Object[Example, Data, "f0addaa5c1fd"], MultipleAppendRelationAmbiguous]}
				|>
			],
			True
		],

		Test["Returns True for one-way Link fields:",
			ValidUploadQ[
				<|
					Type -> Object[Example, Person, Emerald],
					Append[OneWayData] -> {Link[Object[Example, Data, "f0addaa5c1fd"]]}
				|>
			],
			True
		],

		Test["Returns False if link points to an object of the wrong type:",
			ValidUploadQ[<|
				Type -> Object[Example, Data],
				Append[MultipleAppendRelation] -> {Link[Object[Example, Person, Emerald, "f0addaa5c1fd"], MultipleAppendRelationAmbiguous]}
			|>],
			False
		],

		Test["Returns False if Type & Object rules don't exist:",
			ValidUploadQ[<|
				Append[MultipleAppendRelation] -> {Link[Object[Example, Person, Emerald, "f0addaa5c1fd"], MultipleAppendRelationAmbiguous]}
			|>],
			False
		],

		Test["Returns False if link points to an incorrect field in the target object:",
			ValidUploadQ[
				<|
					Type -> Object[Example, Data],
					Replace[MultipleAppendRelation] -> {Link[Object[Example, Data, "f0addaa5c1fd"], TestRun]}
				|>
			],
			False
		],

		Test["Returns False if any computable fields are specified as Rules:",
			ValidUploadQ[
				<|
					Type -> Object[Example, Data],
					ComputableName -> "Hello"
				|>
			],
			False
		],

		Test["Appending to a multiple field with a single item is valid:",
			ValidUploadQ[
				<|
					Type -> Object[Example, Data],
					Append[Random] -> 1
				|>
			],
			True
		],

		Test["Replacing a multiple field with a single item is valid:",
			ValidUploadQ[
				<|
					Type -> Object[Example, Data],
					Replace[Random] -> 1
				|>
			],
			True
		],

		Test["Appending a single list to an indexed multiple field is valid:",
			ValidUploadQ[
				<|
					Type -> Object[Example, Data],
					Append[GroupedUnits] -> {"Hello", 4.0}
				|>
			],
			True
		],

		Test["Replacing an indexed multiple field with a single list is valid:",
			ValidUploadQ[
				<|
					Type -> Object[Example, Data],
					Replace[GroupedUnits] -> {"Hello", 4.0}
				|>
			],
			True
		],

		Test["Deleting something other than indices is invalid:",
			ValidUploadQ[<|Object -> Object[Example, Data, "id:123"], Erase[Random] -> "hi mom"|>],
			False
		],

		Test["Deleting from a multiple field is valid:",
			ValidUploadQ[<|Object -> Object[Example, Data, "id:123"], Erase[Random] -> 2|>],
			True
		],

		Test["Deleting from an indexed field is valid:",
			ValidUploadQ[<|Object -> Object[Example, Data, "id:123"], Erase[IndexedSingle] -> 2|>],
			True
		],

		Test["Deleting from a single indexed field is invalid:",
			ValidUploadQ[<|Object -> Object[Example, Data, "id:123"], Erase[Status] -> 1|>],
			False
		],

		Test["Deleting a row and column from a non indexed multiple field is invalid:",
			ValidUploadQ[<|Object -> Object[Example, Data, "id:123"], Erase[Random] -> {1, 2}|>],
			False
		],

		Test["EraseCases is invalid if the value does not match the storage pattern:",
			ValidUploadQ[<|Object -> Object[Example, Data, "id:123"], EraseCases[Random] -> {1, 2}|>],
			False
		],

		Test["EraseCases is invalid if the field is a single field:",
			ValidUploadQ[<|Object -> Object[Example, Data, "id:123"], EraseCases[Name] -> "Hello"|>],
			False
		],

		Test["EraseCases is invalid if the field is an indexed single field:",
			ValidUploadQ[<|Object -> Object[Example, Data, "id:123"], EraseCases[IndexedSingle] -> 4|>],
			False
		],

		Test["EraseCases is invalid if the field does not exist:",
			ValidUploadQ[<|Object -> Object[Example, Data, "id:123"], EraseCases[DoesntExist] -> 4|>],
			False
		],

		Test["EraseCases is valid if the field is a multiple field and the value matches the storage pattern:",
			ValidUploadQ[<|Object -> Object[Example, Data, "id:123"], EraseCases[Random] -> 4|>],
			True
		],

		Test["EraseCases is valid if the field is an indexed multiple field and the value matches the storage pattern:",
			ValidUploadQ[<|Object -> Object[Example, Data, "id:123"], EraseCases[GroupedUnits] -> {"A1", 12 Minute}|>],
			True
		],

		Test["EraseCases is invalid if there is no Object specified:",
			ValidUploadQ[<|Type -> Object[Example, Data], EraseCases[GroupedUnits] -> {"A1", 12 Minute}|>],
			False
		],

		Test["Uploading real values to integer quantities is invalid:",
			ValidUploadQ[<|Type -> Object[Example, Data], IntegerQuantity -> 1.5|>],
			False
		],

		Example[{Options, DisplayFunction, "The printed list of packets can be modified:"},
			ValidUploadQ[
				<|Type -> Object[Example, Data]|>,
				DisplayFunction -> (Style[#, FontColor -> Red]&)
			],
			True
		]
	},
	Stubs :> {
		PrintTemporary[___]:=Null,
		Print[___]:=Null
	}
];

(* ::Subsubsection::Closed:: *)
(*SingleFieldQ*)

DefineTests[
	SingleFieldQ,
	{
		Example[{Basic, "Returns True if given a field definition with Format -> Single and Class -> Except[_List]:"},
			SingleFieldQ[
				{
					Format -> Single,
					Class -> _String,
					Pattern :> _String,
					Description -> "A Single field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			True
		],

		Test["Returns True if given a field definition with Format -> Single and Class -> _List (Indexed Single Field):",
			SingleFieldQ[
				{
					Format -> Single,
					Class -> {String, Link},
					Pattern :> {_String, _Link},
					Relation -> {Null, Object[Example, Data][GroupedMultipleAppendRelationAmbiguous, 2]},
					Description -> "An Indexed Single field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			True
		],

		Test["Returns False if given a field definition with Format -> Multiple:",
			SingleFieldQ[
				{
					Format -> Multiple,
					Class -> {String, Link},
					Pattern :> {_String, _Link},
					Relation -> {Null, Object[Example, Data][GroupedMultipleAppendRelationAmbiguous, 2]},
					Description -> "An Multiple field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			False
		],

		Test["Returns False if given a field definition with Format -> Computable:",
			SingleFieldQ[
				{
					Format -> Computable,
					Expression :> 1 + 1,
					Pattern :> _Integer,
					Description -> "A Computable field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			False
		],

		Example[{Basic, "Returns False if given a field definition rule with Format -> Computable:"},
			SingleFieldQ[
				ComputableField -> {
					Format -> Computable,
					Expression :> 1 + 1,
					Pattern :> _Integer,
					Description -> "A Computable field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			False
		],

		Example[{Basic, "Returns True if given a field definition rule with Format -> Single and Class -> Except[_List]:"},
			SingleFieldQ[
				MySingleField -> {
					Format -> Single,
					Class -> Integer,
					Pattern :> _Integer,
					Description -> "A SingleField field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			True
		],

		Example[{Basic, "Returns False if given a Multiple field:"},
			SingleFieldQ[Object[Example, Data][Random]],
			False
		],

		Example[{Basic, "Returns True if given a Single field:"},
			SingleFieldQ[Object[Example, Data][Temperature]],
			True
		],

		Example[{Additional, "Returns False if given a field that does not exist:"},
			SingleFieldQ[Object[Example, Data][DoesNotExist]],
			False
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*MultipleFieldQ*)

DefineTests[
	MultipleFieldQ,
	{
		Example[{Basic, "Returns True if given a field definition with Format -> Multiple and Class -> Except[_List]:"},
			MultipleFieldQ[
				{
					Format -> Multiple,
					Class -> _String,
					Pattern :> _String,
					Description -> "A Multiple field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			True
		],

		Test["Returns True if given a field definition with Format -> Multiple and Class -> _List (Indexed Multiple Field):",
			MultipleFieldQ[
				{
					Format -> Multiple,
					Class -> {String, Link},
					Pattern :> {_String, _Link},
					Relation -> {Null, Object[Example, Data][GroupedMultipleAppendRelationAmbiguous, 2]},
					Description -> "An Indexed Multiple field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			True
		],

		Test["Returns False if given a field definition with Format -> Single:",
			MultipleFieldQ[
				{
					Format -> Single,
					Class -> String,
					Pattern :> _String,
					Description -> "A Single field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			False
		],

		Test["Returns False if given a field definition with Format -> Computable:",
			MultipleFieldQ[
				{
					Format -> Computable,
					Expression :> 1 + 1,
					Pattern :> _Integer,
					Description -> "A Computable field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			False
		],

		Example[{Basic, "Returns False if given a field definition rule with Format -> Computable:"},
			MultipleFieldQ[
				ComputableField -> {
					Format -> Computable,
					Expression :> 1 + 1,
					Pattern :> _Integer,
					Description -> "A Computable field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			False
		],

		Example[{Basic, "Returns True if given a field definition rule with Format -> Multiple and Class -> Except[_List]:"},
			MultipleFieldQ[
				MyMultipleField -> {
					Format -> Multiple,
					Class -> Integer,
					Pattern :> _Integer,
					Description -> "A Multiple field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			True
		],

		Example[{Basic, "Returns False if given a Single field:"},
			MultipleFieldQ[Object[Example, Data][Temperature]],
			False
		],

		Example[{Basic, "Returns True if given a Multiple field:"},
			MultipleFieldQ[Object[Example, Data][Random]],
			True
		],

		Example[{Additional, "Returns False if given a field that does not exist:"},
			MultipleFieldQ[Object[Example, Data][DoesNotExist]],
			False
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*IndexedFieldQ*)

DefineTests[
	IndexedFieldQ,
	{
		Example[{Basic, "Returns True if given a field definition with Class -> _List:"},
			IndexedFieldQ[
				{
					Format -> Multiple,
					Class -> {String, Link},
					Pattern :> {_String, _Link},
					Relation -> {Null, Object[Example, Data][GroupedMultipleAppendRelationAmbiguous, 2]},
					Description -> "An Indexed Multiple field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			True
		],

		Test["Returns False if given a field definition with Class -> Except[_List] (Multiple Field):",
			IndexedFieldQ[
				{
					Format -> Multiple,
					Class -> _String,
					Pattern :> _String,
					Description -> "A Multiple field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			False
		],

		Test["Returns True if given a field definition with Format -> Single:",
			IndexedFieldQ[
				{
					Format -> Single,
					Class -> String,
					Pattern :> {_String, _Link},
					Description -> "A Single field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			False
		],

		Test["Returns False if given a field definition with Format -> Computable:",
			IndexedFieldQ[
				{
					Format -> Computable,
					Expression :> 1 + 1,
					Pattern :> _Integer,
					Description -> "A Computable field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			False
		],

		Example[{Basic, "Returns False if given a field definition rule with Format -> Computable:"},
			IndexedFieldQ[
				ComputableField -> {
					Format -> Computable,
					Expression :> 1 + 1,
					Pattern :> _Integer,
					Description -> "A Computable field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			False
		],

		Example[{Basic, "Returns True if given a field definition rule with Class -> _List:"},
			IndexedFieldQ[
				IndexedMultipleField -> {
					Format -> Multiple,
					Class -> {String, Link},
					Pattern :> {_String, _Link},
					Relation -> {Null, Object[Example, Data][GroupedMultipleAppendRelationAmbiguous, 2]},
					Description -> "An Indexed Multiple field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			True
		],

		Example[{Basic, "Returns False if given a field that is not indexed field:"},
			IndexedFieldQ[Object[Example, Data][Temperature]],
			False
		],

		Example[{Basic, "Returns True if given an indexed field:"},
			IndexedFieldQ[Object[Example, Data][GroupedMultipleAppendRelation]],
			True
		],

		Example[{Additional, "Returns False if given a field that does not exist:"},
			IndexedFieldQ[Object[Example, Data][DoesNotExist]],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(* NamedFieldQ *)

DefineTests[NamedFieldQ,
	{
		Example[{Basic, "Returns True if given a field definition with Class -> {_Rule ..}:"},
			NamedFieldQ[
				{
					Format -> Multiple,
					Class -> {Column1 -> String, Column2 -> Link},
					Pattern :> {Column1 -> _String, Column2 -> _Link},
					Relation -> {
						Column1 -> Null,
						Column2 -> Object[Example, Data][GroupedMultipleAppendRelationAmbiguous, 2]
					},
					Description -> "An Indexed Multiple field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			True
		],

		Test["Returns False if given a field definition with Class -> Except[{_Rule ..}]:",
			NamedFieldQ[
				{
					Format -> Multiple,
					Class -> _String,
					Pattern :> _String,
					Description -> "A Multiple field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			False
		],

		Test["Returns True if given a named field definition with Format -> Single:",
			NamedFieldQ[
				{
					Format -> Single,
					Class -> {Column1 -> String},
					Pattern :> {Column1 -> _String},
					Description -> "A Single field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			True
		],

		Test["Returns False if given a field definition with Format -> Computable:",
			NamedFieldQ[
				{
					Format -> Computable,
					Expression :> 1 + 1,
					Pattern :> _Integer,
					Description -> "A Computable field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			False
		],

		Example[{Basic, "Returns False if given a field definition rule with Format -> Computable:"},
			NamedFieldQ[
				ComputableField -> {
					Format -> Computable,
					Expression :> 1 + 1,
					Pattern :> _Integer,
					Description -> "A Computable field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			False
		],

		Example[{Basic, "Returns True if given a field definition rule with Class -> {_Rule ..}:"},
			NamedFieldQ[
				NamedMultipleField -> {
					Format -> Multiple,
					Class -> {Column1 -> String, Column2 -> Link},
					Pattern :> {Column1 -> _String, Column2 -> _Link},
					Relation -> {
						Column1 -> Null,
						Column2 -> Object[Example, Data][GroupedMultipleAppendRelationAmbiguous, 2]
					},
					Description -> "An Indexed Multiple field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			True
		],

		Example[{Basic, "Returns False if given a field that is not named field:"},
			NamedFieldQ[Object[Example, Data][Temperature]],
			False
		],

		Example[{Basic, "Returns True if given an named field:"},
			NamedFieldQ[Object[Example, Data][NamedSingle]],
			True
		],

		Example[{Additional, "Returns False if given a field that does not exist:"},
			NamedFieldQ[Object[Example, Data][DoesNotExist]],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*ComputableFieldQ*)

DefineTests[
	ComputableFieldQ,
	{
		Example[{Basic, "Returns True if given a field definition with Format -> Computable:"},
			ComputableFieldQ[
				{
					Format -> Computable,
					Pattern :> _String,
					Expression :> "Hello "<>Field[Name],
					Description -> "A computable field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			True
		],

		Test["Returns False if given a field definition with Format -> Single:",
			ComputableFieldQ[
				{
					Format -> Single,
					Class -> _String,
					Pattern :> _String,
					Description -> "A Single field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			False
		],

		Test["Returns False if given a field definition with Format -> Multiple:",
			ComputableFieldQ[
				{
					Format -> Multiple,
					Class -> String,
					Pattern :> _String,
					Description -> "A Multiple field.",
					Category -> "Experiments & Simulations",
					Required -> False,
					Abstract -> False
				}
			],
			False
		],

		Example[{Basic, "Returns False if given a Single field:"},
			ComputableFieldQ[Object[Example, Data][Temperature]],
			False
		],

		Example[{Basic, "Returns False if given a Multiple field:"},
			ComputableFieldQ[Object[Example, Data][MultipleAppendRelation]],
			False
		],

		Example[{Basic, "Returns True if given a Computable field:"},
			ComputableFieldQ[Object[Example, Data][ComputableName]],
			True
		],

		Example[{Additional, "Returns False if given a field that does not exist:"},
			ComputableFieldQ[Object[Example, Data][DoesNotExist]],
			False
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*fieldToPart*)

DefineTests[
	fieldToPart,
	{
		Example[{Basic, "Returns field index for an indexed multiple field:"},
			fieldToPart[Object[Example, Data][GroupedMultipleAppendRelation, 1]],
			1
		],

		Example[{Basic, "Returns field name for a named multiple field:"},
			fieldToPart[Object[Example, Data][NamedField, FirstColumn]],
			FirstColumn
		],

		Example[{Basic, "Returns $Failed if no index for field:"},
			fieldToPart[Object[Example, Data][GroupedMultipleAppendRelation]],
			$Failed
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*fieldToType*)

DefineTests[
	fieldToType,
	{
		Example[{Basic, "Returns type for the given Object field with index:"},
			fieldToType[Object[Example, Data][GroupedMultipleAppendRelation, 1]],
			Object[Example, Data]
		],

		Example[{Basic, "Returns type for the given Object field without an index:"},
			fieldToType[Object[Example, Data][Temperature]],
			Object[Example, Data]
		],

		Example[{Basic, "Returns type for the given Model field:"},
			fieldToType[Model[Example, Data][Objects]],
			Model[Example, Data]
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*fieldToSymbol*)

DefineTests[
	fieldToSymbol,
	{
		Example[{Basic, "Returns field symbol for the given Object field with index:"},
			fieldToSymbol[Object[Example, Data][GroupedMultipleAppendRelation, 1]],
			GroupedMultipleAppendRelation
		],

		Example[{Basic, "Returns field symbol for the given Object field without an index:"},
			fieldToSymbol[Object[Example, Data][Temperature]],
			Temperature
		],

		Example[{Basic, "Returns field symbol for the given Model field:"},
			fieldToSymbol[Model[Example, Data][Objects]],
			Objects
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*packetToType*)

DefineTests[
	packetToType,
	{
		Example[{Basic, "Returns type from Association when only Object key exists:"},
			packetToType[<|Object -> Object[Data, NMR, "id:12"]|>],
			Object[Data, NMR]
		],

		Example[{Basic, "Returns type from Association when only Type key exists:"},
			packetToType[<|Type -> Object[Data, Chromatography]|>],
			Object[Data, Chromatography]
		],

		Example[{Basic, "Returns $Failed if neither Type or Object keys exist:"},
			packetToType[<|Name -> "My Special Packet"|>],
			$Failed
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*fieldReferenceToObject*)

DefineTests[
	fieldReferenceToObject,
	{
		Example[{Basic, "Returns the object the field reference points to:"},
			fieldReferenceToObject[Object[Example, Data, "id:zx91", Temperature]],
			Object[Example, Data, "id:zx91"]
		],

		Example[{Basic, "Returns the object the field reference points to when it's an indexed multiple field:"},
			fieldReferenceToObject[Object[Example, Data, "id:zx91", GroupedUnits, 2]],
			Object[Example, Data, "id:zx91"]
		],

		Example[{Basic, "Returns the object from a named field reference:"},
			fieldReferenceToObject[Object[Example, Data, "id:-1", NamedSingle, UnitColumn]],
			Object[Example, Data, "id:-1"]
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*fieldReferenceToField*)

DefineTests[
	fieldReferenceToField,
	{
		Example[{Basic, "Returns the field the field reference points to:"},
			fieldReferenceToField[Object[Example, Data, "id:zx91", Temperature]],
			Object[Example, Data][Temperature]
		],

		Example[{Basic, "Returns the field the field reference points to when it's an indexed multiple field:"},
			fieldReferenceToField[Object[Example, Data, "id:zx91", GroupedUnits, 2]],
			Object[Example, Data][GroupedUnits]
		],

		Example[{Basic, "Returns the referenced field when it's a named field:"},
			fieldReferenceToField[Object[Example, Data, "id:-1", NamedSingle, UnitColumn]],
			Object[Example, Data][NamedSingle]
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*fieldReferenceToSymbol*)

DefineTests[
	fieldReferenceToSymbol,
	{
		Example[{Basic, "Returns the field symbol the field reference polints to:"},
			fieldReferenceToSymbol[Object[Example, Data, "id:zx91", Temperature]],
			Temperature
		],

		Example[{Basic, "Returns the field symbol the field reference points to when it's an indexed multiple field:"},
			fieldReferenceToSymbol[Object[Example, Data, "id:zx91", GroupedUnits, 2]],
			GroupedUnits
		],

		Example[{Basic, "Returns the field symbol for a named field reference:"},
			fieldReferenceToSymbol[Object[Example, Data, "id:-1", NamedSingle, UnitColumn]],
			NamedSingle
		]
	}
];

(* ::Subsubsection::Closed:: *)
(*fieldReferenceToColumn*)

DefineTests[
	fieldReferenceToColumn,
	{
		Example[{Basic, "Returns $Failed if field is reference is not to a specific index:"},
			fieldReferenceToColumn[Object[Example, Data, "id:zx91", Temperature]],
			$Failed
		],

		Example[{Basic, "Returns the index in the field the reference points to when it's an indexed multiple field:"},
			fieldReferenceToColumn[Object[Example, Data, "id:zx91", GroupedUnits, 2]],
			2
		],

		Example[{Basic, "Returns column name from a named field reference:"},
			fieldReferenceToColumn[Object[Example, Data, "id:-1", NamedSingle, UnitColumn]],
			UnitColumn
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*Link*)




DefineTests[
	Link,
	{
		Example[{Additional, "Given a Link as the first argument returns a new Link to the Link's object:"},
			Link[Link[Object[Example, Data, "id:4"], SingleRelation, "link-id"], SingleRelation],
			Link[Object[Example, Data, "id:4"], SingleRelation]
		],
		Example[{Additional, "If Link is wrapped around a Temporal Link, a new link is created that drops the date:"},
			Link[Link[Object[Example, Data, "id:4"], SingleRelation, "link-id", DateObject["Jan 1 2020"]], SingleRelation],
			Link[Object[Example, Data, "id:4"], SingleRelation]
		],
		Example[{Additional, "The original date is dropped if a new Temporal Link is defined over an existing Link:"},
			Link[Link[Object[Example, Data, "id:4"], SingleRelation, "link-id", DateObject["Jan 1 2020"]], SingleRelation, DateObject["May 1 2020"]],
			Link[Object[Example, Data, "id:4"], SingleRelation, DateObject["May 1 2020"]]
		],
		Example[{Additional, "If Link is wrapped around a non-object twice, this still reduces to a single Link:"},
			Link[Link["Not a real object", SingleRelation, "link-id"], GroupedMultipleAppendRelation, 2],
			Link["Not a real object", GroupedMultipleAppendRelation, 2]
		],
		Example[{Additional, "Retuns Null if given Null as first argument:"},
			Link[Null, GroupedMultipleAppendRelation, 2],
			Null
		],
		Example[{Basic, "Represents a link to a field in an object at the specific index:"},
			Link[Object[Example, Data, "id:123"], GroupedMultipleAppendRelation, 2],
			HoldPattern[Link[Object[Example, Data, "id:123"], GroupedMultipleAppendRelation, 2]]
		],

		Example[{Basic, "Represents a temporal link to a field in an object at the specific index:"},
			Link[Object[Example, Data, "id:123"], GroupedMultipleAppendRelation, 2, someDate],
			Link[Object[Example, Data, "id:123"], GroupedMultipleAppendRelation, 2, someDate]
		],

		Example[{Basic, "Represents a link to a field in another object:"},
			Link[Object[Example, Data, "id:123"], SingleRelation],
			Link[Object[Example, Data, "id:123"], SingleRelation]
		],

		Test["Represents a Temporal link to a field in another object:",
			Link[Object[Example, Data, "id:123"], SingleRelation, someDate],
			Link[Object[Example, Data, "id:123"], SingleRelation, someDate]
		],

		Example[{Basic, "Represents a link to an object without a backlink field:"},
			Link[Object[Example, Data, "id:123"]],
			Link[Object[Example, Data, "id:123"]]
		],

		Test["Represents a temporal link to an object without a backlink field:",
			Link[Object[Example, Data, "id:123"], someDate],
			Link[Object[Example, Data, "id:123"], someDate]
		],

		Example[{Basic, "Create a list of links from a list of objects:"},
			Link[{Object[Example, Data, "id:123"], Object[Example, Data, "id:456"]}, SingleRelation],
			{
				Link[Object[Example, Data, "id:123"], SingleRelation],
				Link[Object[Example, Data, "id:456"], SingleRelation]
			}
		],

		Test["Create a list of temporal links from a list of objects:",
			Link[{Object[Example, Data, "id:123"], Object[Example, Data, "id:456"]}, SingleRelation, someDate],
			{
				Link[Object[Example, Data, "id:123"], SingleRelation, someDate],
				Link[Object[Example, Data, "id:456"], SingleRelation, someDate]
			}
		],

		Example[{Additional, "Create a link to the object given a packet:"},
			Link[<|Object -> Object[Example, Data, "id:456"]|>, SingleRelation],
			Link[Object[Example, Data, "id:456"], SingleRelation]
		],

		Test["Create a temporal link to the object given a packet:",
			Link[<|Object -> Object[Example, Data, "id:456"]|>, SingleRelation, someDate],
			Link[Object[Example, Data, "id:456"], SingleRelation, someDate]
		],

		Test["Given a packet without an Object key, returns $Failed:",
			Link[<|Type -> Object[Example, Data]|>, SingleRelation],
			$Failed
		],
		Example[{Additional, "Given a Temporal Link as the first argument returns a new Link to the Link's object:"},
			Link[Link[Object[Example, Data, "id:4"], SingleRelation, "link-id", someDate], SingleRelation],
			Link[Object[Example, Data, "id:4"], SingleRelation]
		],
		Example[{Additional, "If Link is wrapped around a non-object twice, you can still define a Temporal Link:"},
			Link[Link["Not a real object", SingleRelation, "link-id"], GroupedMultipleAppendRelation, 2, someDate],
			Link["Not a real object", GroupedMultipleAppendRelation, 2, someDate]
		]
	},
	SymbolSetUp :> {someDate=DateObject["May 9 1996"]}
];
