(* ::Package:: *)

(* ::Subsection::Closed:: *)
(*UploadName*)


(* ::Subsubsection:: *)
(*UploadName*)


(* Define the Unit Tests *)
DefineTests[UploadName,
	{
		Example[{Basic, "Upload a name to a pre-existing object:"},
			(
				UploadName[testColumn1, "Test Name 1, UploadName " <> $SessionUUID];
				Download[testColumn1, Name]
			),
			"Test Name 1, UploadName " <> $SessionUUID,
			TearDown :> {
				Upload[<|
					Object -> testColumn1,
					Name -> "Test Column 1, UploadName " <> $SessionUUID,
					Replace[Synonyms] -> {}
				|>]
			}
		],

		Example[{Basic, "Upload names to multiple objects at one time:"},
			(
				UploadName[{testColumn1, testColumn2}, {"Test Name 1, UploadName " <> $SessionUUID, "Test Name 2, UploadName " <> $SessionUUID}];
				Download[{testColumn1, testColumn2}, Name]
			),
			{"Test Name 1, UploadName " <> $SessionUUID, "Test Name 2, UploadName " <> $SessionUUID},
			TearDown :> {
				Upload[{<|
					Object -> testColumn1,
					Name -> "Test Column 1, UploadName " <> $SessionUUID,
					Replace[Synonyms] -> {}
				|>,
					<|
						Object -> testColumn2,
						Name -> "Test Column 2, UploadName " <> $SessionUUID,
						Replace[Synonyms] -> {}
					|>}]
			}
		],

		Example[{Options, Synonyms, "Add additional synonyms for the object:"},
			(
				UploadName[testColumn1, "Test Name 1, UploadName " <> $SessionUUID, Synonyms -> {"Taco", "Test Synonym"}];
				Download[testColumn1, {Name, Synonyms}]
			),
			{"Test Name 1, UploadName " <> $SessionUUID, {"Test Name 1, UploadName " <> $SessionUUID, "Taco", "Test Synonym"}},
			TearDown :> {
				Upload[<|
					Object -> testColumn1,
					Name -> "Test Column 1, UploadName " <> $SessionUUID,
					Replace[Synonyms] -> {}
				|>]
			}
		],

		Example[{Options, Synonyms, "Upload additional synonyms to multiple objects:"},
			(
				UploadName[{testColumn1, testColumn2}, {"Test Name 1, UploadName " <> $SessionUUID, "Test Name 2, UploadName " <> $SessionUUID},
					Synonyms -> {{"Test Synonym 1, UploadName " <> $SessionUUID}, {"Test Synonym 2, UploadName " <> $SessionUUID}}
				];
				Download[{testColumn1, testColumn2}, {Name, Synonyms}]
			),
			{
				{"Test Name 1, UploadName " <> $SessionUUID, {"Test Name 1, UploadName " <> $SessionUUID, "Test Synonym 1, UploadName " <> $SessionUUID}},
				{"Test Name 2, UploadName " <> $SessionUUID, {"Test Name 2, UploadName " <> $SessionUUID, "Test Synonym 2, UploadName " <> $SessionUUID}}
			},
			TearDown :> {
				Upload[{<|
					Object -> testColumn1,
					Name -> "Test Column 1, UploadName " <> $SessionUUID,
					Replace[Synonyms] -> {}
				|>,
					<|
						Object -> testColumn2,
						Name -> "Test Column 2, UploadName " <> $SessionUUID,
						Replace[Synonyms] -> {}
					|>}]
			}
		],

		Example[{Options, Synonyms, "Specify no additional synonyms for an object using Null:"},
			(
				UploadName[{testColumn1, testColumn2}, {"Test Name 1, UploadName " <> $SessionUUID, "Test Name 2, UploadName " <> $SessionUUID},
					Synonyms -> {{"Test Synonym 1, UploadName " <> $SessionUUID}, Null}];
				Download[{testColumn1, testColumn2}, {Name, Synonyms}]
			),
			{
				{"Test Name 1, UploadName " <> $SessionUUID, {"Test Name 1, UploadName " <> $SessionUUID, "Test Synonym 1, UploadName " <> $SessionUUID}},
				{"Test Name 2, UploadName " <> $SessionUUID, {"Test Name 2, UploadName " <> $SessionUUID}}
			},
			TearDown :> {
				Upload[{<|
					Object -> testColumn1,
					Name -> "Test Column 1, UploadName " <> $SessionUUID,
					Replace[Synonyms] -> {}
				|>,
					<|
						Object -> testColumn2,
						Name -> "Test Column 2, UploadName " <> $SessionUUID,
						Replace[Synonyms] -> {}
					|>}]
			}
		],

		Example[{Options, OverwriteSynonyms, "Replace Existing Synonyms:"},
			(
				UploadName[{testColumn1, testColumn2}, {"Test Name 1, UploadName " <> $SessionUUID, "Test Name 2, UploadName " <> $SessionUUID}, Synonyms -> {{"Test Synonym 1, UploadName " <> $SessionUUID}, {"Test Synonym 2, UploadName " <> $SessionUUID}}];
				UploadName[{testColumn1, testColumn2}, {"Test Name 1, UploadName " <> $SessionUUID, "Test Name 2, UploadName " <> $SessionUUID}, Synonyms -> {{"Test Synonym 1, UploadName " <> $SessionUUID}, {"Taco"}}, OverwriteSynonyms -> True];
				Download[{testColumn1, testColumn2}, {Name, Synonyms}]
			),
			{{"Test Name 1, UploadName " <> $SessionUUID, {"Test Name 1, UploadName " <> $SessionUUID, "Test Synonym 1, UploadName " <> $SessionUUID}}, {"Test Name 2, UploadName " <> $SessionUUID, {"Test Name 2, UploadName " <> $SessionUUID, "Taco"}}},
			TearDown :> {
				Upload[{<|
					Object -> testColumn1,
					Name -> "Test Column 1, UploadName " <> $SessionUUID,
					Replace[Synonyms] -> {}
				|>,
					<|
						Object -> testColumn2,
						Name -> "Test Column 2, UploadName " <> $SessionUUID,
						Replace[Synonyms] -> {}
					|>}]
			}
		],

		Example[{Options, OverwriteSynonyms, "Add to Existing Synonyms:"},
			(
				UploadName[{testColumn1, testColumn2}, {"Test Name 1, UploadName " <> $SessionUUID, "Test Name 2, UploadName " <> $SessionUUID}, Synonyms -> {{"Test Synonym 1, UploadName " <> $SessionUUID}, {"Test Synonym 2, UploadName " <> $SessionUUID}}];
				UploadName[{testColumn1, testColumn2}, {"Test Name 1, UploadName " <> $SessionUUID, "Test Name 2, UploadName " <> $SessionUUID}, Synonyms -> {{"Test Synonym 1, UploadName " <> $SessionUUID}, {"Taco"}}, OverwriteSynonyms -> False];
				Download[{testColumn1, testColumn2}, {Name, Synonyms}]
			),
			{{"Test Name 1, UploadName " <> $SessionUUID, {"Test Name 1, UploadName " <> $SessionUUID, "Test Synonym 1, UploadName " <> $SessionUUID, "Test Synonym 1, UploadName " <> $SessionUUID}}, {"Test Name 2, UploadName " <> $SessionUUID, {OrderlessPatternSequence["Test Name 2, UploadName " <> $SessionUUID, "Test Synonym 2, UploadName " <> $SessionUUID, "Taco"]}}},
			TearDown :> {
				Upload[{<|
					Object -> testColumn1,
					Name -> "Test Column 1, UploadName " <> $SessionUUID,
					Replace[Synonyms] -> {}
				|>,
					<|
						Object -> testColumn2,
						Name -> "Test Column 2, UploadName " <> $SessionUUID,
						Replace[Synonyms] -> {}
					|>}]
			}
		],

		Example[{Messages, "NameAlreadyInUse", "Cannot add name that is already in use for that type:"},
			(
				UploadName[{testColumn1, testColumn2}, {"Test Name 1, UploadName " <> $SessionUUID, "Test Name 1, UploadName " <> $SessionUUID}]
			),
			$Failed,
			Messages :> {Error::NameAlreadyInUse},
			TearDown :> {
				Upload[{<|
					Object -> testColumn1,
					Name -> "Test Column 1, UploadName " <> $SessionUUID,
					Replace[Synonyms] -> {}
				|>,
					<|
						Object -> testColumn2,
						Name -> "Test Column 2, UploadName " <> $SessionUUID,
						Replace[Synonyms] -> {}
					|>}]
			}
		],
		Example[{Messages, "NameAlreadyInUse", "Cannot add name that is already in use for that type when using singleton input case:"},
			(
				UploadName[testColumn2, "Test Column 1, UploadName " <> $SessionUUID]
			),
			$Failed,
			Messages :> {Error::NameAlreadyInUse},
			TearDown :> {
				Upload[{
					<|
						Object -> testColumn1,
						Name -> "Test Column 1, UploadName " <> $SessionUUID,
						Replace[Synonyms] -> {}
					|>,
					<|
						Object -> testColumn2,
						Name -> "Test Column 2, UploadName " <> $SessionUUID,
						Replace[Synonyms] -> {}
					|>}
				]
			}
		]
	},
	SymbolSetUp :> {
		Module[
			{allObjs, existingObjs},
			allObjs={
				Model[Item, Column, "Test Column 1, UploadName " <> $SessionUUID],
				Model[Item, Column, "Test Column 2, UploadName " <> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];

			testColumn1=Upload[<|Type -> Model[Item, Column], Name -> "Test Column 1, UploadName " <> $SessionUUID, Replace[Synonyms] -> {}, DeveloperObject -> True|>];
			testColumn2=Upload[<|Type -> Model[Item, Column], Name -> "Test Column 2, UploadName " <> $SessionUUID, Replace[Synonyms] -> {}, DeveloperObject -> True|>];
		]
	},
	SymbolTearDown :> {
		Module[
			{allObjs, existingObjs},
			allObjs={
				Model[Item, Column, "Test Column 1, UploadName " <> $SessionUUID],
				Model[Item, Column, "Test Column 2, UploadName " <> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
			Clear[testColumn1, testColumn2];
		]
	}
];


(* ::Subsubsection:: *)
(*UploadNameOptions*)


DefineTests[UploadNameOptions,
	{
		Example[{Basic, "Returns resolved options for UploadName when passed a singleton input:"},
			(
				UploadNameOptions[testColumn1, "Test Name 1, UploadNameOptions " <> $SessionUUID, OutputFormat -> List]
			),
			{Rule[_, Except[Automatic]]...}
		],

		Example[{Basic, "Returns resolved options for UploadName when passed a list of inputs:"},
			(
				UploadNameOptions[{testColumn1, testColumn2}, {"Test Name 1, UploadNameOptions " <> $SessionUUID, "Test Name 2, UploadNameOptions " <> $SessionUUID}, OutputFormat -> List]
			),
			{Rule[_, Except[Automatic]]...}
		],

		Example[{Basic, "Does not actually name the input:"},
			(
				beforeName=Download[testColumn1, Name];
				UploadNameOptions[testColumn1, "Test Name 1, UploadNameOptions " <> $SessionUUID];
				afterName=Download[testColumn1, Name];
				{beforeName, afterName}
			),
			{"Test Column 1, UploadNameOptions " <> $SessionUUID, "Test Column 1, UploadNameOptions " <> $SessionUUID},
			SetUp :> {
				Upload[<|
					Object -> testColumn1,
					Name -> "Test Column 1, UploadNameOptions " <> $SessionUUID,
					Replace[Synonyms] -> {}
				|>]
			}
		],

		Example[{Options, OutputFormat, "Returns resolved options for UploadName as a table:"},
			(
				UploadNameOptions[testColumn1, "Test Name 1, UploadNameOptions " <> $SessionUUID, OutputFormat -> Table]
			),
			Graphics_
		]
	},
	SymbolSetUp :> {
		Module[
			{allObjs, existingObjs},
			allObjs={
				Model[Item, Column, "Test Column 1, UploadNameOptions " <> $SessionUUID],
				Model[Item, Column, "Test Column 2, UploadNameOptions " <> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];

			testColumn1=Upload[<|Type -> Model[Item, Column], Name -> "Test Column 1, UploadNameOptions " <> $SessionUUID, Replace[Synonyms] -> {}, DeveloperObject -> True|>];
			testColumn2=Upload[<|Type -> Model[Item, Column], Name -> "Test Column 2, UploadNameOptions " <> $SessionUUID, Replace[Synonyms] -> {}, DeveloperObject -> True|>];
		]
	},
	SymbolTearDown :> {
		Module[
			{allObjs, existingObjs},
			allObjs={
				Model[Item, Column, "Test Column 1, UploadNameOptions " <> $SessionUUID],
				Model[Item, Column, "Test Column 2, UploadNameOptions " <> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
			Clear[testColumn1, testColumn2];
		]
	}
];


(* ::Subsubsection:: *)
(*UploadNamePreview*)


DefineTests[UploadNamePreview,
	{
		Example[{Basic, "Returns Null when passed a singleton input:"},
			(
				UploadNamePreview[testColumn1, "Test Name 1, UploadNamePreview " <> $SessionUUID]
			),
			Null
		],

		Example[{Basic, "Returns Null when passed a list of inputs:"},
			(
				UploadNamePreview[{testColumn1, testColumn2}, {"Test Name 1, UploadNamePreview " <> $SessionUUID, "Test Name 2, UploadNamePreview " <> $SessionUUID}]
			),
			Null
		],

		Example[{Basic, "Does not actually name the input:"},
			(
				beforeName=Download[testColumn1, Name];
				UploadNamePreview[testColumn1, "Test Name 1, UploadNamePreview " <> $SessionUUID];
				afterName=Download[testColumn1, Name];
				{beforeName, afterName}
			),
			{"Test Column 1, UploadNamePreview " <> $SessionUUID, "Test Column 1, UploadNamePreview " <> $SessionUUID},
			SetUp :> {
				Upload[<|
					Object -> testColumn1,
					Name -> "Test Column 1, UploadNamePreview " <> $SessionUUID,
					Replace[Synonyms] -> {}
				|>]
			}
		]
	},
	SymbolSetUp :> {
		Module[
			{allObjs, existingObjs},
			allObjs={
				Model[Item, Column, "Test Column 1, UploadNamePreview " <> $SessionUUID],
				Model[Item, Column, "Test Column 2, UploadNamePreview " <> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];

			testColumn1=Upload[<|Type -> Model[Item, Column], Name -> "Test Column 1, UploadNamePreview " <> $SessionUUID, Replace[Synonyms] -> {}, DeveloperObject -> True|>];
			testColumn2=Upload[<|Type -> Model[Item, Column], Name -> "Test Column 2, UploadNamePreview " <> $SessionUUID, Replace[Synonyms] -> {}, DeveloperObject -> True|>];
		]
	},
	SymbolTearDown :> {
		Module[
			{allObjs, existingObjs},
			allObjs={
				Model[Item, Column, "Test Column 1, UploadNamePreview " <> $SessionUUID],
				Model[Item, Column, "Test Column 2, UploadNamePreview " <> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
			Clear[testColumn1, testColumn2];
		]
	}
];


(* ::Subsubsection:: *)
(*ValidUploadNameQ*)


DefineTests[ValidUploadNameQ,
	{
		Example[{Basic, "Validate a request to add a single object's name:"},
			ValidUploadNameQ[testColumn1, "Test Name 1" <> $SessionUUID],
			True
		],

		Example[{Basic, "Validate a request to add names to multiple objects:"},
			ValidUploadNameQ[{testColumn1, testColumn2}, {"Test Name 1" <> $SessionUUID, "Test Name 2" <> $SessionUUID}],
			True
		],

		Example[{Basic, "Does not actually name the input:"},
			(
				beforeName=Download[testColumn1, Name];
				ValidUploadNameQ[testColumn1, "Test Name 1" <> $SessionUUID];
				afterName=Download[testColumn1, Name];
				{beforeName, afterName}
			),
			{"Test Column 1" <> $SessionUUID , "Test Column 1" <> $SessionUUID},
			SetUp :> {
				Upload[<|
					Object -> testColumn1,
					Name -> "Test Column 1" <> $SessionUUID,
					Replace[Synonyms] -> {}
				|>]
			}
		],

		Example[{Basic, "Invalid object input will not cause validation to fail:"},
			{
				ValidUploadNameQ[testColumn1, "Test Name 1" <> $SessionUUID],
				ValidObjectQ[testColumn1]
			},
			{True, False}
		],

		Example[{Basic, "Validation will fail if name is already in use by an object of that type:"},
			{
				UploadName[testColumn1, "Test Name 1" <> $SessionUUID];
				ValidUploadNameQ[testColumn2, "Test Name 1" <> $SessionUUID]
			},
			{False},
			TearDown :> {
				Upload[<|
					Object -> testColumn1,
					Name -> "Test Column 1" <> $SessionUUID,
					Replace[Synonyms] -> {}
				|>]
			}
		],

		Example[{Options, OutputFormat, "Return an EmeraldTestSummary:"},
			(
				ValidUploadNameQ[testColumn1, "Test Name 1" <> $SessionUUID, OutputFormat -> TestSummary]
			),
			_EmeraldTestSummary
		],

		Example[{Options, Verbose, "Print verbose messages reporting test passage / failure:"},
			ValidUploadNameQ[testColumn1, "Test Name 1" <> $SessionUUID, Verbose -> True],
			True
		]
	},
	SymbolSetUp :> {
		Module[
			{allObjs, existingObjs},
			allObjs={
				Model[Item, Column, "Test Column 1" <> $SessionUUID],
				Model[Item, Column, "Test Column 2" <> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];

			testColumn1=Upload[<|Type -> Model[Item, Column], Name -> "Test Column 1" <> $SessionUUID, Replace[Synonyms] -> {}, DeveloperObject -> True|>];
			testColumn2=Upload[<|Type -> Model[Item, Column], Name -> "Test Column 2" <> $SessionUUID, Replace[Synonyms] -> {}, DeveloperObject -> True|>];
		]
	},
	SymbolTearDown :> {
		Module[
			{allObjs, existingObjs},
			allObjs={
				Model[Item, Column, "Test Column 1" <> $SessionUUID],
				Model[Item, Column, "Test Column 2" <> $SessionUUID]
			};
			existingObjs=PickList[allObjs, DatabaseMemberQ[allObjs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False];
			Clear[testColumn1, testColumn2];
		]
	},
	Variables :> {
		testColumn1,
		testColumn2
	}
];

(* ::Subsubsection:: *)
(*GetAddressLookupTableJSON*)

DefineTests[
	GetAddressLookupTableJSON,
	{
		Test["GetAddressLookupTableJSON returns a valid JSON.",
			GetAddressLookupTableJSON[],
			_String
		]
	}
];