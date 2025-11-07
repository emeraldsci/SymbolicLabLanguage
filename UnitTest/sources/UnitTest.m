(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Title:: *)
(*UnitTest.m*)


(* ::Section:: *)
(*Source Code*)

(* NOTE: It's important that this is set delayed so that it's not evaluated on build of the SLL distro. *)
$SessionUUID:=$SessionUUID=CreateUUID[];

(* ::Subsection::Closed:: *)
(*Old Way Of Defining Tests*)


UnitTests::DeprecatedForm="UnitTests[`1`] is deprecated. Use DefineTests instead.";
UnitTests/:SetDelayed[UnitTests[sym_Symbol],tests_List]:=(
	Message[UnitTests::DeprecatedForm,sym];
	DefineTests[sym,tests]
);


(* ::Subsection::Closed:: *)
(*Patterns*)


(* ::Subsubsection::Closed:: *)
(*ExampleCategoryP*)


ExampleCategoryP::usage="Possible categories for the Category option when defining unit tests.";
Unprotect[ExampleCategoryP];
ExampleCategoryP=Alternatives[Basic,Additional,Options,Attributes,Overloads,Behaviors,Messages,Issues,Applications];
Protect[ExampleCategoryP];


(* ::Subsubsection::Closed:: *)
(*ContextP*)


ContextP::usage="matches a Mathematica context string.";
Unprotect[ContextP];
ContextP:=_String?(StringMatchQ[#,((WordCharacter ..) ~~ "`")..]&);
Protect[ContextP];



(* ::Subsubsection::Closed:: *)
(*ContextQ*)


ContextQ[ContextP]:=True;
ContextQ[_]:=False;


(* ::Subsection::Closed:: *)
(*Test Packages & Defining Tests*)


(* ::Subsubsection::Closed:: *)
(*UnitTests UpValues*)


(*All unit tests defined using the UpValue for UnitTests will be stored using this symbol *)
If[!ValueQ[symbolTests],
	symbolTests=Association[]
];

UnitTests/:SetDelayed[UnitTests[identifier:_Symbol|_String|ECL`Object[__Symbol]], tests_]:=DefineTests[symbolTests,identifier,tests];



(* ::Subsubsection:: *)
(*DefineTests*)


(* ::Subsubsubsection::Closed:: *)
(*Options and Helpers*)


DefineTests::Null="Warning, Null encountered in test list for `1` (`2`): check for extra comma.";
DefineTests::Times="Warning, _Times encountered in test list for `1` (`2`): check for missing comma.";
DefineTests::Stubs="Warning, Stubs is not a list in test list for `1` (`2`). Stubs must be a list of Set or SetDelayed.";

DefineOptions[
	DefineTests,
	Options:>{
		{SetUp:>Null,_,"An expression which will be run before each Test/Example."},
		{TearDown:>Null,_,"An expression which will be run after each Test/Example."},
		{SymbolSetUp:>Null,_,"An expression which will be run once before all Tests/Examples."},
		{SymbolTearDown:>Null,_,"An expression which will be run once after all Tests/Examples."},
		{TurnOffMessages:>{},_,"The list of messages to turn off before running the global SymbolSetUp and turn back on after running the global SymbolTearDown. If the tests are running in parallel on Manifold, TurnOffMessages are also turned off before every SetUp for each test/example (since the tests are run in parallel across multiple nodes)."},
		{Variables:>{},{___Symbol},"A list of Symbols which will be localized to each Test/Example."},
		{Stubs:>{},{(HoldPattern[SetDelayed[_Symbol | _Symbol[___], _]] | HoldPattern[Set[_Symbol | _Symbol[___], _]])...},"List of Set/SetDelayed calls to be applied during the execution of all tests defined for this symbol/string."},
		{Platform->{"Windows","MacOSX","Unix"},{("Windows"|"MacOSX"|"Unix")..},"Which platforms these tests are OK to run on."},
		{Skip->False,False|_String,"Flag these tests as to be skipped when running tests with a description of why."},
		{Parallel->False,True|False,"Indicates that tests for this symbol can be run in parallel."},
		{HardwareConfiguration->Standard,Alternatives[Standard,HighRAM],"If computing on the cloud (Manifold), the hardware which should be used to run computations."},
		{NumberOfParallelThreads->Automatic, (Automatic|Null|RangeP[1,10,1]),"The number of parallel child computation jobs to run."}
	}
];

SetAttributes[DefineTests,HoldAll];

DefineTests[collection_Symbol, sym:_Symbol|_String|ECL`Object[__Symbol], tests_, ops:OptionsPattern[]]:=Module[
	{package, file, options, platform, skip, parallel, hardwareConfiguration, numberOfParallelThreads},

	platform = OptionDefault[OptionValue[Platform]];
	skip = OptionDefault[OptionValue[Skip]];
	parallel = OptionDefault[OptionValue[Parallel]];
	hardwareConfiguration = OptionDefault[OptionValue[HardwareConfiguration]];
	numberOfParallelThreads = OptionDefault[OptionValue[NumberOfParallelThreads]];

	(*For symbols, store the context of that symbol, for strings store the context
	that the tests were defined in.*)
	package = DirectoryPackage[currentFile[]];

	options=DeleteCases[
		List[ops],
		(Platform|Skip)->_
	];
	file = $InputFileName;
	If[KeyExistsQ[options, Stubs] && !MatchQ[Quiet[Extract[Association@options, Key[Stubs], Hold]], Verbatim[Hold][_List]],
		Message[DefineTests::Stubs,sym,$InputFileName]
	];
	If[MemberQ[Hold[tests],Null,{2}],
		Message[DefineTests::Null,sym,$InputFileName]
	];

	If[MemberQ[Hold[tests],_Times,{2}],
		Message[DefineTests::Times,sym,$InputFileName]
	];

	AppendTo[
		collection,
	 	sym -> Association[
			"Package"->package,
			"File"->file,
			"Options"->options,
			"Tests"->Hold[tests],
			"Platform"->platform,
			"Skip"->skip,
			"Parallel"->parallel,
			"HardwareConfiguration"->hardwareConfiguration,
			"NumberOfParallelThreads"->numberOfParallelThreads
		]
	];
];
currentFile[]:=$InputFileName;

DefineTests[identifier:_Symbol|_String|ECL`Object[__Symbol], tests_, ops:OptionsPattern[]]:=DefineTests[
	symbolTests,
	identifier,
	tests,
	ops
];


(* ::Subsection::Closed:: *)
(*SymbolTestFile*)


(* ::Subsubsection::Closed:: *)
(*SymbolTestFile*)


SymbolTestFile[identifier:_Symbol]:=Module[
	{testAssoc,package},
	package=FunctionPackage[identifier];
	If[MatchQ[package,$Failed],
		LoadTests[],
		LoadTests[package]
	];
	testAssoc=Lookup[symbolTests, identifier];
	If[MatchQ[testAssoc, _Missing],
		$Failed,
		Lookup[testAssoc, "File"]
	]
];

SymbolTestFile[identifier:_String]:=
	SymbolTestFile[Symbol[identifier]];


(* ::Subsection::Closed:: *)
(*Example*)


(* ::Subsubsection::Closed:: *)
(*Example*)


DefineOptions[
	Example,
	SharedOptions:>{Test}
];

Example[{category:ExampleCategoryP,description_String},expression_,expected_,ops:OptionsPattern[]]:=Test[
	description,
	expression,
	expected,
	Category->category,
	ops
];


Example[{category:ExampleCategoryP,subCategory:_Symbol|_String|{__Symbol},description_String}, expression_,expected_,ops:OptionsPattern[]]:=Test[
	description,
	expression,
	expected,
	Category->category,
	SubCategory->subCategory,
	ops
];

SetAttributes[Example,HoldRest];


(* ::Subsubsection::Closed:: *)
(*Warning*)


DefineOptions[
	Warning,
	SharedOptions:>{
		{
			Test,
			{
				TimeConstraint,
				EquivalenceFunction,
				Messages,
				Stubs,
				Category,
				SubCategory,
				FatalFailure,
				SetUp,
				TearDown,
				Variables
			}
		}
	}
];

Warning[description_String, expression_, expected_, ops:OptionsPattern[]]:=Test[
	description,
	expression,
	expected,
	Warning->True,
	ops
];

SetAttributes[Warning,HoldRest];


(* ::Subsubsection::Closed:: *)
(*Error*)

ECL`Authors[Error] := {"steven"};

(* Dummy function so that we can DefineTests[...] for it. *)
(* These tests are used to track the Error::MyMessage messages in the command builder functions. *)
Error[]:=Null;


(* ::Subsubsection::Closed:: *)
(*ExampleP*)


ExampleP = EmeraldTest[_Association?(MatchQ[#[Category],ExampleCategoryP]&)];


(* ::Subsection::Closed:: *)
(*Running Tests*)


(* ::Subsubsection:: *)
(*RunUnitTest*)


(* ::Subsubsubsection::Closed:: *)
(*itemPackage*)


itemPackage[string_String]:=Quiet[
	Check[
		itemPackage[Symbol[string]],
		$Failed
	]
];
itemPackage[symbol_Symbol]:=With[
	{package=FunctionPackage[symbol]},

	If[MatchQ[package,$Failed],
		privateSymbolPackage[symbol],
		package
	]
];
itemPackage[type_ECL`Object]:="ProcedureSimulation`";
privateSymbolPackage[symbol_Symbol]:=With[
	{
		context = Context[symbol],
		packagePrivateContexts = Map[
			StringJoin[#,"Private`"]&,
			AvailablePackages[]
		]
	},

	If[MemberQ[packagePrivateContexts,context],
		StringReplace[context,"Private`"->""],
		$Failed
	]
];
itemPackage[items:{(_Symbol|_String|ECL`Object[__Symbol])...}]:=DeleteDuplicates[
	Map[
		itemPackage,
		items
	]
];


(* ::Subsubsubsection::Closed:: *)
(*Public Function*)


DefineOptions[
	RunUnitTest,
	Options:>{
		{Exclude->{},{(_Symbol|_String)...},"A list of symbols to exclude from running their tests."},
		{Verbose->Failures,True|False|Failures,"If True, print the result of each test as they finish."},
		{SummaryNotebook->False,True|False,"If True, prints verbose results in a formatted second window."},
		{Category->All,_Symbol|_String|{(_Symbol|_String)..},"Filter the tests to be run based on their example category, or \"Tests\"."},
		{SubCategory->All,_Symbol|_String|{(_Symbol|_String)..},"Filter the tests to be run based on their example subcategory, or \"Tests\"."},
		{ShowExpression->True,True|False,"Whether or not to display expressions in SummaryNotebook."},
		{Association->True,True|False,"Whether or not to return an Association of inputs->summaries. If False, only returns a list of summaries."},
		{OutputFormat->TestSummary,SingleBoolean|Boolean|TestSummary,"Determines the format of the return value. Boolean returns a pass/fail for each entry. SingleBoolean returns a single pass/fail boolean for all the inputs. TestSummary returns the EmeraldTestSummary object for each input."},
		{DisplayFunction->InputForm,_Symbol|_Function,"When Verbose->True|Failures, this function is applied to each element for printing the headers."},
		{TestsToRun->All, IntegrationTests | Sandbox | All, "When TestsToRun->Sandbox, only run tests defined for Sandbox. When TestsToRun->IntegrationTests omit tests defined for Sandbox. Otherwise run all tests."},
		{ClearMemoization -> True, BooleanP, "Indicate if ClearMemoization[] should be run before SymbolSetUp and after SymbolTearDown. For normal unit testing ClearMemoization should be set to True as temporary test objects can cause severe problems with memoization. However, when RunUnitTest is leveraged for other purposes like VOQ framework, this option may be set to False."}
	}
];


RunUnitTest::ProductionDatabase="Unit tests cannot be run against the production database. ProductionQ[] has evaluated to True. Please switch to the test database and re-run tests.";
(*Run tests for a list of inputs*)
RunUnitTest[inputs:{(_Symbol|Except[_String?filePathQ|_String?ContextQ,_String]|ECL`Object[__Symbol])...},ops:OptionsPattern[]]:=Module[
	{filteredInputs,defaultedOptions,results,packages},

	(* RunUnitTest overloads actually used to run true unit tests are run with the Notebook permissions warning off *)
	(* Ideally we would address all the cases where we default to a Notebook in tests instead *)
	(* TODO This is a temporary fix ONLY for unit testing since multiple unit tests trying to write to the same *)
	(* TODO Object[LaboratoryNotebook]'s Objects field slows down the tests drastically *)
	(* TODO The asana task that tracks the long term solution: https://app.asana.com/0/1150770667411537/1205972734124857/f *)
	Block[{$AllowPublicObjects = True},
		(*Throw Error if we are on Production but skip this if our inputs are empty since we are not going to run real tests on empty list anyway*)
		If[ProductionQ[]&&!MatchQ[inputs,{}],
			Message[RunUnitTest::ProductionDatabase];
			Return[$Failed]
		];

		(* Get the package(s) that these function(s) live in. *)
		packages = itemPackage[inputs];

		(* If we were unable to figure out what package the functions were in, load all tests. *)
		(* Otherwise, just load the required packages. *)
		If[MemberQ[packages,$Failed],
			LoadTests[],
			LoadTests[packages]
		];

		(* Now, we have loaded our tests. *)

		(* Don't run any tests for symbols that were set in Exclude. *)
		filteredInputs=Complement[inputs,OptionValue[Exclude]];
		defaultedOptions=OptionDefaults[RunUnitTest, ToList[ops]];

		clearSummaryNotebook[defaultedOptions];

		results=AssociationMap[
			runIndividualTests[Tests[#],#,Sequence@@defaultedOptions]&,
			filteredInputs
		];

		formatTestOutput[
			results,
			Lookup[defaultedOptions, "OutputFormat"],
			Lookup[defaultedOptions, "Association"]
		]
	]
];

(*Run tests for all symbols in a list of contexts or files*)
RunUnitTest[contextsOrFiles:{(_String?(Or[ContextQ[#],filePathQ[#]]&))...},ops:OptionsPattern[]]:=Module[
	{defaultedOptions,results},
	(* TODO This is a temporary fix ONLY for unit testing since multiple unit tests trying to write to the same *)
	(* TODO Object[LaboratoryNotebook]'s Objects field slows down the tests drastically *)
	(* TODO The asana task that tracks the long term solution: https://app.asana.com/0/1150770667411537/1205972734124857/f *)
	Block[{$AllowPublicObjects  = True},
		defaultedOptions=OptionDefaults[RunUnitTest, ToList[ops]];

		If[ProductionQ[],
			Message[RunUnitTest::ProductionDatabase];
			Return[$Failed]
		];

		If[AllTrue[contextsOrFiles,ContextQ],
			Scan[
				LoadTests,
				Select[
					contextsOrFiles,
					PackageQ
				]
			],
			LoadTests[]
		];
		clearSummaryNotebook[defaultedOptions];

		results=AssociationMap[
			Function[contextOrFile,
				AssociationMap[
					runIndividualTests[Tests[#],#,Sequence@@defaultedOptions]&,
					UnitTestedItems[contextOrFile,Skipped->All]
				]
			],
			contextsOrFiles
		];

		results
	]
];

(*Run tests for all symbols in a given context || file*)
RunUnitTest[contextOrFile_String?(Or[ContextQ[#],filePathQ[#]]&),ops:OptionsPattern[]]:=Module[
	{defaultedOptions,results},
	(* TODO This is a temporary fix ONLY for unit testing since multiple unit tests trying to write to the same *)
	(* TODO Object[LaboratoryNotebook]'s Objects field slows down the tests drastically *)
	(* TODO The asana task that tracks the long term solution: https://app.asana.com/0/1150770667411537/1205972734124857/f *)
	Block[{$AllowPublicObjects  = True},

		defaultedOptions=OptionDefaults[RunUnitTest, ToList[ops]];

		If[ProductionQ[],
			Message[RunUnitTest::ProductionDatabase];
			Return[$Failed]
		];

		If[PackageQ[contextOrFile],
			LoadTests[contextOrFile],
			LoadTests[]
		];

		clearSummaryNotebook[defaultedOptions];

		results=AssociationMap[
			runIndividualTests[Tests[#],#,Sequence@@defaultedOptions]&,
			UnitTestedItems[contextOrFile,Skipped->All]
		];

		formatTestOutput[
			results,
			Lookup[defaultedOptions, "OutputFormat"],
			Lookup[defaultedOptions, "Association"]
		]
	]
];

Packager`OnLoad[
	provisionalLoaded=False;
];

(*Run tests for a given symbol, or a string that is not a context/file, or a type *)
RunUnitTest[identifier:_Symbol|Except[_String?filePathQ|_String?ContextQ,_String]|ECL`Object[__Symbol],ops:OptionsPattern[]]:=Module[
	{defaultedOptions,result,package},
	(* TODO This is a temporary fix ONLY for unit testing since multiple unit tests trying to write to the same *)
	(* TODO Object[LaboratoryNotebook]'s Objects field slows down the tests drastically *)
	(* TODO The asana task that tracks the long term solution: https://app.asana.com/0/1150770667411537/1205972734124857/f *)
	Block[{$AllowPublicObjects  = True},
		defaultedOptions=OptionDefaults[RunUnitTest, ToList[ops]];

		If[Not[TrueQ[provisionalLoaded]] && KeyExistsQ[$ProvisionalFunctions,identifier],
			Get["Provisional`"];
			provisionalLoaded = True;
		];

		If[ProductionQ[],
			Message[RunUnitTest::ProductionDatabase];
			Return[$Failed]
		];

		package = itemPackage[identifier];
		If[package === $Failed,
			LoadTests[],
			LoadTests[package]
		];

		clearSummaryNotebook[defaultedOptions];

		result=runIndividualTests[
			Tests[identifier],
			identifier,
			Sequence@@defaultedOptions
		];

		If[MatchQ[Lookup[defaultedOptions,"OutputFormat"],Boolean|SingleBoolean],
			result[Passed],
			result
		]
	]
];


RunUnitTest[assoc_Association,ops:OptionsPattern[]]:=RunUnitTest[
	Normal[assoc],
	ops
];
RunUnitTest[rules:{___Rule},ops:OptionsPattern[]]:=Module[
	{defaultedOptions,results},
	(* RunUnitTest overloads actually used to run true unit tests are run with the Notebook permissions warning off *)
	(* Ideally we would address all the cases where we default to a Notebook in tests instead *)
	(* TODO This is a temporary fix ONLY for unit testing since multiple unit tests trying to write to the same *)
	(* TODO Object[LaboratoryNotebook]'s Objects field slows down the tests drastically *)
	(* TODO The asana task that tracks the long term solution: https://app.asana.com/0/1150770667411537/1205972734124857/f *)
	Block[{$AllowPublicObjects = True},
		defaultedOptions=OptionDefaults[RunUnitTest, ToList[ops]];

		clearSummaryNotebook[defaultedOptions];

		results=Association[
			KeyValueMap[
				#1 -> runIndividualTests[
					#2,
					#1,
					Sequence@@defaultedOptions,
					Sort->False
				]&,
				Association[rules]
			]
		];

		formatTestOutput[
			rules,
			results,
			Lookup[defaultedOptions, "OutputFormat"],
			Lookup[defaultedOptions, "Association"]
		]
	]
];

clearSummaryNotebook[options:{Rule[_String,_]...}]:=With[
	{
		verbose = Lookup[options,"Verbose"],
		notebook = Lookup[options,"SummaryNotebook"]
	},

	If[(verbose =!= false) && TrueQ[notebook],
		clearNotebook[getTestNotebook[]]
	]
];

formatTestOutput[inputs:{___Rule},results_Association,format:TestSummary|Boolean|SingleBoolean,associationQ:True|False]:=Which[
	format===SingleBoolean,
	And@@Map[#[Passed]&,Values[results]],

	associationQ,
	formatTestOutput[results,format,True],

	True,
	With[
		{assoc = formatTestOutput[results,format,True]},

		Replace[
			Keys[inputs],
			assoc,
			{1}
		]
	]
];

formatTestOutput[results_Association,format:TestSummary|Boolean|SingleBoolean,associationQ:True|False]:=Module[
	{booleanResults,formattedResults},

	booleanResults=Map[#[Passed]&, results];

	If[format===SingleBoolean,
		Return[
			Apply[
				And,
				Values[booleanResults]
			]
		]
	];

	formattedResults=If[MatchQ[format,Boolean],
		booleanResults,
		results
	];

	If[associationQ,
		formattedResults,
		Values[formattedResults]
	]
];


(*Run tests for a given symbol, or a string that is not a context/file but do not
clear any test notebook information*)

Options[runIndividualTests]=Append[Options[RunUnitTest],Sort->True];

runIndividualTests[tests:{TestP...},identifier_,OptionsPattern[]]:=Module[
	{verbose, testsByCategory, category, subcategory,categories, subcategories,sort, showExpression,displayFunction,
		window, testsBySubCategory, flatSubCategories, sortedTests, sandboxOption, filteredTests, clearMemoization},

	verbose = OptionValue[Verbose];
	category = OptionValue[Category];
	subcategory = OptionValue[SubCategory];
	window = OptionValue[SummaryNotebook];
	sort = OptionValue[Sort];
	displayFunction = OptionValue[DisplayFunction];
	showExpression = OptionValue[ShowExpression];
	sandboxOption = OptionValue[TestsToRun];
	clearMemoization = OptionValue[ClearMemoization];

	categories = If[MatchQ[category,_List|All],
		category,
		{category}
	];
	subcategories = If[MatchQ[subcategory,_List|All],
		subcategory,
		{subcategory}
	];

	(* omit specific tests based on the options provided *)
	filteredTests = Switch[
		sandboxOption,
		All, tests,
		Sandbox, Select[tests, #[Sandbox] &],
		IntegrationTests, Select[tests, Not[TrueQ[#[Sandbox]]] &]
	];

	(* get the flat list of subcategories (so if you have multi-symbol subcategory then this flattens out all the way) *)
	flatSubCategories = DeleteDuplicates[Flatten[#[SubCategory]& /@ filteredTests]];

	(* get the sorted tests (or unsorted if we're not sorting) *)
	sortedTests = If[sort,
		SortBy[filteredTests,{#[SubCategory],#[Description]}&],
		filteredTests
	];

	testsBySubCategory = Normal[flatTests[KeySelect[
		(* this used to be a GroupBy but it gets a little goofy with the MemberQ so just Mapping is fine*)
		Association[Map[
			Function[{subCategory},
				subCategory -> Select[sortedTests, MemberQ[ToList[#[SubCategory]], subCategory]&]
			],
			flatSubCategories
		]],
		Or[
			SameQ[subcategories,All],
			MemberQ[subcategories,#]
		]&
	]]];

	testsByCategory = KeySelect[
		GroupBy[
			If[sort,
				SortBy[testsBySubCategory,{#[Category],#[Description]}&],
				testsBySubCategory
			],
			#[Category]&
		],
		Or[SameQ[categories,All],MemberQ[categories,#]]&
	];

	If[verbose===False,
		quietTestResults[testsByCategory, identifier, clearMemoization],
		If[window===True,
			runTestsInNotebook[testsByCategory, identifier, verbose, displayFunction, clearMemoization, ShowExpression->showExpression],
			runTestsInline[testsByCategory, identifier, verbose, displayFunction, clearMemoization]
		]
	]
];

flatTests[testsByCategory_Association] := Apply[
	Join,
	Values[testsByCategory]
];

(* This code first wraps any MessageName[___] with a Hold, looks up the TurnOffMessages option, then replaces any Holds with Offs. *)
turnOffTestMessages[options_List]:=	Lookup[options /. {message_MessageName :> Hold[message]}, TurnOffMessages, {}] /. {Hold -> Off};

(* This code first wraps any MessageName[___] with a Hold, looks up the TurnOffMessages option, then replaces any Holds with On. *)
(* NOTE: At the end of the test, we must turn the messages back on so that we don't affect other development work done in the same kernel. *)
turnOnTestMessages[options_List]:=	Lookup[options /. {message_MessageName :> Hold[message]}, TurnOffMessages, {}] /. {Hold -> On};

(*Execute test functions without any verbose output*)
quietTestResults[testsByCategory_Association, identifier_, clearMemoizationQ:BooleanP]:=Module[
	{tests, symbolOptions, symbolSetUpMessages, symbolTearDownMessages, reapedResults, results, variables, definitions,
		percentCoverage},

	tests=flatTests[testsByCategory];

	(* ClearMemoization before SymbolSetUp and after SymbolTearDown because the creating/erasing objects these often do can mess up memoization badly *)
	(* However, when calling RunUnitTests for other purposes like VOQ tests in external upload functions, clearing memoization can cause unexpected results so this feature should be skipped *)
	If[clearMemoizationQ,
		ECL`ClearMemoization[]
	];

	symbolOptions=defaultTestOptions[identifier];

	(* Before we do anything, get the definitions for the variables we were told to scope. Since it's hard to scope across *)
	(* all the tests (because in order for Module to do its magic, the expressions have to be inserted into the module without *)
	(* lookups that hide scoping), we just save the definitions before we run things and restore the definitions after. *)
	(* Get all of the definitions for these global variables. *)
	(* NOTE: We would normally use Lookup[symbolOptions, Variables, Hold[{}], Hold] here but this isn't compatible with 12.0 *)
	variables=(Extract[Join[<|Variables -> {}|>, Association@symbolOptions], {Key[Variables]}, Hold]/.{sym:Except[Hold | List, _Symbol] -> Hold[sym]})[[1]];
	definitions=variables/.{Hold->Language`ExtendedDefinition};

	(* Clear all these variables so it's like we're scoping them. *)
	variables/.{Hold->Clear};

	(* Before running SymbolSetUp, turn off any TurnOffMessages. *)
	turnOffTestMessages[symbolOptions];

	symbolSetUpMessages = EvaluationData[Lookup[symbolOptions, SymbolSetUp]]["MessagesExpressions"];

	reapedResults = Reap[
		Scan[
			Function[test,
				With[{result=RunTest[test]},
					Sow[result,"UnitTest"];

					If[And[test[FatalFailure],!result[Passed]],
						Return[]
					];
				]
			],
			tests
		],
		"UnitTest"
	];

	(* later: fail with errors if this has problems *)
	symbolTearDownMessages = EvaluationData[Lookup[symbolOptions, SymbolTearDown]]["MessagesExpressions"];

	(* After running SymbolTearDown, turn back on any TurnOffMessages. *)
	UnitTest`Private`turnOnTestMessages[symbolOptions];

	(* Clear all these variables so it's like we're scoping them. *)
	(With[{insertMe=#}, #/.{Hold->Clear}]&)/@variables;

	(* Restore the definitions. *)
	MapThread[
		With[{insertMe1=#1[[1]], insertMe2=#2},
			Language`ExtendedDefinition[insertMe1]=insertMe2;
		]&,
		{variables, definitions}
	];

	(* ClearMemoization before SymbolSetUp and after SymbolTearDown because the creating/erasing objects these often do can mess up memoization badly *)
	(* However, when calling RunUnitTests for other purposes like VOQ tests in external upload functions, clearing memoization can cause unexpected results so this feature should be skipped *)
	If[clearMemoizationQ,
		ECL`ClearMemoization[]
	];

	results = If[MatchQ[reapedResults[[2]],{}],
		{},
		reapedResults[[2,1]]
	];

	(* get all the simulated task IDs from the results *)
	percentCoverage = If[MatchQ[identifier, ECL`Object[__Symbol]],
		Module[{allSimulatedTaskIDs},
			allSimulatedTaskIDs = DeleteDuplicates[Flatten[Map[
				#[SimulatedTasks]&,
				results
			]]];

			percentTasksPerformed[identifier, allSimulatedTaskIDs]
		],
		Null
	];

	toResultSummary[
		identifier,
		results,
		tests,
		SymbolSetUpMessages -> symbolSetUpMessages,
		SymbolTearDownMessages -> symbolTearDownMessages,
		PercentTaskCoverage -> percentCoverage
	]
];

(*Runs tests and prints to unit testing notebook their results as they are executed*)
Options[runTestsInNotebook]={ShowExpression->True};
runTestsInNotebook[testsByCategory_Association,identifier_, verbose:True|Failures, displayFunction:_Symbol|_Function, clearMemoizationQ:BooleanP, ops:OptionsPattern[]]:=Module[
	{testNotebook, symbolOptions,symbolSetUpMessages, reapedResults,symbolTearDownMessages, results, summary, name,
		tests, variables, definitions, percentCoverage},

	testNotebook=getTestNotebook[];
	name=ToString[identifier];

	writeTestNames[testNotebook, testsByCategory, identifier, displayFunction];
	tests=DeleteDuplicates[flatTests[testsByCategory]];

	(* ClearMemoization before SymbolSetUp and after SymbolTearDown because the creating/erasing objects these often do can mess up memoization badly *)
	(* However, when calling RunUnitTests for other purposes like VOQ tests in external upload functions, clearing memoization can cause unexpected results so this feature should be skipped *)
	If[clearMemoizationQ,
		ECL`ClearMemoization[]
	];

	symbolOptions=defaultTestOptions[identifier];

	(* Before we do anything, get the definitions for the variables we were told to scope. Since it's hard to scope across *)
	(* all the tests (because in order for Module to do its magic, the expressions have to be inserted into the module without *)
	(* lookups that hide scoping), we just save the definitions before we run things and restore the definitions after. *)
	(* Get all of the definitions for these global variables. *)
	(* NOTE: We would normally use Lookup[symbolOptions, Variables, Hold[{}], Hold] here but this isn't compatible with 12.0 *)
	variables=(Extract[Join[<|Variables -> {}|>, Association@symbolOptions], {Key[Variables]}, Hold]/.{sym:Except[Hold | List, _Symbol] -> Hold[sym]})[[1]];
	definitions=variables/.{Hold->Language`ExtendedDefinition};

	(* Clear all these variables so it's like we're scoping them. *)
	variables/.{Hold->Clear};

	(* Before running SymbolSetUp, turn off any TurnOffMessages. *)
	turnOffTestMessages[symbolOptions];

	symbolSetUpMessages = EvaluationData[Lookup[symbolOptions, SymbolSetUp]]["MessagesExpressions"];

	reapedResults = Reap[
		Scan[
			Function[test,
				updateRunningCell[testNotebook, test[Description], test[ID]];

				With[
					{
						result = RunTest[test],
						category=If[MatchQ[test[Category],_String],
							test[Category],
							ToString[SymbolName[test[Category]]]
						]
					},

					If[verbose===Failures && result[Passed],
						With[{count=getCategoryCount[testNotebook,name,category]},
							removeCell[testNotebook, test[ID]];
							If[count==1,
								removeCategoryCell[testNotebook,name,category],
								decrementCategoryCell[testNotebook,name,category]
							]
						],
						writeCellResult[testNotebook, test[ID], result, ops]
					];

					Sow[result,"UnitTest"];

					If[And[test[FatalFailure],!result[Passed]],
						Return[]
					];
				]
			],
			tests
		],
		"UnitTest"
	];

	(* later: fail with errors if this has problems *)
	symbolTearDownMessages = EvaluationData[Lookup[symbolOptions, SymbolTearDown]]["MessagesExpressions"];

	(* After running SymbolTearDown, turn back on any TurnOffMessages. *)
	UnitTest`Private`turnOnTestMessages[symbolOptions];

	(* Clear all these variables so it's like we're scoping them. *)
	(With[{insertMe=#}, #/.{Hold->Clear}]&)/@variables;

	(* Restore the definitions. *)
	MapThread[
		With[{insertMe1=#1[[1]], insertMe2=#2},
			Language`ExtendedDefinition[insertMe1]=insertMe2;
		]&,
		{variables, definitions}
	];

	(* ClearMemoization before SymbolSetUp and after SymbolTearDown because the creating/erasing objects these often do can mess up memoization badly *)
	(* However, when calling RunUnitTests for other purposes like VOQ tests in external upload functions, clearing memoization can cause unexpected results so this feature should be skipped *)
	If[clearMemoizationQ,
		ECL`ClearMemoization[]
	];

	results = If[MatchQ[reapedResults[[2]],{}],
		{},
		reapedResults[[2,1]]
	];

	(* get all the simulated task IDs from the results *)
	percentCoverage = If[MatchQ[identifier, ECL`Object[__Symbol]],
		Module[{allSimulatedTaskIDs},
			allSimulatedTaskIDs = DeleteDuplicates[Flatten[Map[
				#[SimulatedTasks]&,
				results
			]]];

			percentTasksPerformed[identifier, allSimulatedTaskIDs]
		],
		Null
	];

	summary = toResultSummary[
		identifier,
		results,
		tests,
		SymbolSetUpMessages -> symbolSetUpMessages,
		SymbolTearDownMessages -> symbolTearDownMessages,
		PercentTaskCoverage -> percentCoverage
	];

	writeSummaryCell[testNotebook,name,summary];

	summary
];

getCategoryCount[notebook_NotebookObject,name_String,category_String]:=With[{},
	NotebookFind[notebook, name, All, CellTags, AutoScroll->False];
	NotebookFind[notebook, category, Next, CellTags, AutoScroll->False];
	ToExpression[Options[NotebookSelection[notebook], CellTags][[1, 2, 2]]]
];

removeCategoryCell[notebook_NotebookObject,name_String,category_String]:=With[{},
	NotebookFind[notebook, name, All, CellTags, AutoScroll->False];
	NotebookFind[notebook, category, Next, CellTags, AutoScroll->False];
	NotebookDelete[notebook]
];

decrementCategoryCell[notebook_NotebookObject,name_String,category_String]:=With[
	{count=getCategoryCount[notebook, name, category]},

	NotebookFind[notebook, name, All, CellTags, AutoScroll->False];
	NotebookFind[notebook, category, Next, CellTags, AutoScroll->False];
	SetOptions[NotebookSelection[notebook], CellTags->{category,ToString[count-1]}]
];


runTestsInline[testsByCategory_Association,identifier_, verbose:True|Failures, displayFunction:_Symbol|_Function, clearMemoizationQ:BooleanP]:=Module[
	{symbolOptions, symbolSetUpMessages, reapedResults, symbolTearDownMessages, results, name, tests, runningTest,
	totalCount, testIndex, maxCategoryLength, tempCell, summary, percentCoverage, variables, definitions},

	name=displayFunction[identifier];

	Print[Style[name,FontWeight->Bold,FontSize->12]];

	tests=DeleteDuplicates[flatTests[testsByCategory]];
	tempCell=PrintTemporary[Dynamic[If[MatchQ[runningTest,_Row],runningTest,""]]];
	runningTest="";
	totalCount=Length[tests];
	testIndex=1;
	maxCategoryLength=Max[Map[StringLength[ToString[#[Category]]]&,tests]];

	(* ClearMemoization before SymbolSetUp and after SymbolTearDown because the creating/erasing objects these often do can mess up memoization badly *)
	(* However, when calling RunUnitTests for other purposes like VOQ tests in external upload functions, clearing memoization can cause unexpected results so this feature should be skipped *)
	If[clearMemoizationQ,
		ECL`ClearMemoization[]
	];

	symbolOptions=defaultTestOptions[identifier];

	(* Before we do anything, get the definitions for the variables we were told to scope. Since it's hard to scope across *)
	(* all the tests (because in order for Module to do its magic, the expressions have to be inserted into the module without *)
	(* lookups that hide scoping), we just save the definitions before we run things and restore the definitions after. *)
	(* Get all of the definitions for these global variables. *)
	(* NOTE: We would normally use Lookup[symbolOptions, Variables, Hold[{}], Hold] here but this isn't compatible with 12.0 *)
	variables=(Extract[Join[<|Variables -> {}|>, Association@symbolOptions], {Key[Variables]}, Hold]/.{sym:Except[Hold | List, _Symbol] -> Hold[sym]})[[1]];
	definitions=variables/.{Hold->Language`ExtendedDefinition};

	(* Clear all these variables so it's like we're scoping them. *)
	variables/.{Hold->Clear};

	(* Before running SymbolSetUp, turn off any TurnOffMessages. *)
	turnOffTestMessages[symbolOptions];

	symbolSetUpMessages = EvaluationData[Lookup[symbolOptions, SymbolSetUp]]["MessagesExpressions"];

	reapedResults = Reap[
		Scan[
			Function[test,
				Module[
					{result,category},

					category=If[MatchQ[test[Category],_String],
						test[Category],
						ToString[SymbolName[test[Category]]]
					];

					runningTest=Row[{Style[StringJoin["Currently Running (",ToString[testIndex],"/",ToString[totalCount],"): "],FontWeight->Bold],test[Description]}];

					If[TrueQ[ECL`$ManifoldRuntime],
						Echo[StringJoin["Currently Running (",ToString[testIndex],"/",ToString[totalCount],"): "<>test[Description]]];
					];

					(* Update testIndex. *)
					testIndex=testIndex+1;

					(* run the tests! *)
					result = RunTest[test];

					If[verbose || (verbose===Failures && !result[Passed]),
						writeResult[category,maxCategoryLength,test[Description],result[Passed],!test[Warning]]
					];

					Sow[result,"UnitTest"];

					If[And[test[FatalFailure],!result[Passed]],
						Return[]
					];
				]
			],
			tests
		],
		"UnitTest"
	];

	NotebookDelete[tempCell];

	(* later: fail with errors if this has problems *)
	symbolTearDownMessages = EvaluationData[Lookup[symbolOptions, SymbolTearDown]]["MessagesExpressions"];

	(* After running SymbolTearDown, turn back on any TurnOffMessages. *)
	UnitTest`Private`turnOnTestMessages[symbolOptions];

	(* Clear all these variables so it's like we're scoping them. *)
	(With[{insertMe=#}, #/.{Hold->Clear}]&)/@variables;

	(* Restore the definitions. *)
	MapThread[
		With[{insertMe1=#1[[1]], insertMe2=#2},
			Language`ExtendedDefinition[insertMe1]=insertMe2;
		]&,
		{variables, definitions}
	];

	(* ClearMemoization before SymbolSetUp and after SymbolTearDown because the creating/erasing objects these often do can mess up memoization badly *)
	(* However, when calling RunUnitTests for other purposes like VOQ tests in external upload functions, clearing memoization can cause unexpected results so this feature should be skipped *)
	If[clearMemoizationQ,
		ECL`ClearMemoization[]
	];

	results = If[MatchQ[reapedResults[[2]],{}],
		{},
		reapedResults[[2,1]]
	];

	(* get all the simulated task IDs from the results *)
	percentCoverage = If[MatchQ[identifier, ECL`Object[__Symbol]],
		Module[{allSimulatedTaskIDs},
			allSimulatedTaskIDs = DeleteDuplicates[Flatten[Map[
				#[SimulatedTasks]&,
				results
			]]];

			percentTasksPerformed[identifier, allSimulatedTaskIDs]
		],
		Null
	];

	summary = toResultSummary[
		identifier,
		results,
		tests,
		SymbolSetUpMessages -> symbolSetUpMessages,
		SymbolTearDownMessages -> symbolTearDownMessages,
		PercentTaskCoverage -> percentCoverage
	];

	summary
];


writeResult[category_String,maxCategoryLength_Integer,description_String,passedQ:True|False,testQ:True|False]:=Module[
	{},
	(* Print out a box that describes the test that is being run:*)
	Print[
		(* Dynamic[Refresh[...,TrackedSymbols\[Rule]{AbsoluteCurrentValue[EvaluationNotebook[],WindowSize]}]] refreshes the tests whenever the window size of the notebook is changed. *)
		Dynamic@Refresh[
			(* If there is still space for us to print out a test, print it out. If not, print out a new line. *)
			(* This will save us when the width gets below 40 px. *)
			If[pageWidth[]-maxCategoryLength-40 > 1,
				createTestBox[category,maxCategoryLength,description,passedQ,testQ],
				""
			],
			TrackedSymbols->{AbsoluteCurrentValue[EvaluationNotebook[],WindowSize]}
		]
	]

];

(* Helper function to create the test result. *)
createTestBox[category_String,maxCategoryLength_Integer,description_String,passedQ:True|False,testQ:True|False]:=Module[
	{lineWidth,lines,lengths,lastLine,dots,gridRows},
	lineWidth=pageWidth[]-maxCategoryLength-40;

	{lines,lengths}=getSentenceLinesAndLengths[description,lineWidth];
		lastLine=If[MatchQ[lines,{}],
			"",
			Last[lines]
		];

		dots=Apply[
			StringJoin,
			Table[".",{lineWidth-Last[lengths,0]}]
		];

		gridRows=If[Length[lines]>1,
			Join[
				{{"   "<>category<>":", First[lines], SpanFromLeft, SpanFromLeft}},
				Map[
					{"", #, SpanFromLeft, SpanFromLeft}&,
					lines[[2;;-2]]
				],
				{{"", lastLine, dots, Which[
					passedQ,Style["[PASS]",FontColor->testColors[ResultSuccess],FontWeight->Bold],
					testQ, Style["[FAIL]",FontWeight->Bold,FontColor->testColors[ResultFailure]],
					True, Style["[WARNING]",FontWeight->Bold,FontColor->testColors[WarningFailure]]
				]}}
			],
			{{"   "<>category<>":", lastLine, dots, Which[
				passedQ, Style["[PASS]",FontColor->testColors[ResultSuccess],FontWeight->Bold],
				testQ, Style["[FAIL]",FontWeight->Bold,FontColor->testColors[ResultFailure]],
				True, Style["[WARNING]",FontWeight->Bold,FontColor->testColors[WarningFailure]]
			]}}
		];

		Grid[
			gridRows,
			ItemSize -> {{1->Scaled[(maxCategoryLength+5)/(lineWidth+5+maxCategoryLength)], 2->All, 3->All, 4->All}, Automatic},
			Alignment -> Left,
			Spacings -> {0,0.5}
		]
];

(* Due to font size differences in the Command Center style sheet, this number needs to be scaled down. *)
pageWidth[]:=IntegerPart[First[AbsoluteCurrentValue[EvaluationNotebook[],WindowSize]]/(8.5*AbsoluteCurrentValue[EvaluationNotebook[],Magnification])/.Inherited|Automatic->1];

badBoxPattern = Alternatives[
	Shortest["\!\(\*FormBox["~~___~~"TraditionalForm]\)"],
	Shortest["(\!\(\*SuperscriptBox["~~__~~","~~__~~"]\))"]
];

getSentenceLinesAndLengths[string_String, lineWidth_Integer]:=Module[{
	badStrs,safeString,safeStringSplit,specialCharacter=FromCharacterCode[14],finalString,safeStringLengths
},

	(* bad box strings *)
	badStrs = StringCases[string,badBoxPattern];

	(* temp thing with bad stuff replaced with unique character *)
	safeString = StringReplace[string,Map[#->specialCharacter&,badStrs]];

	(* split the string *)
	safeStringSplit = InsertLinebreaks[safeString, lineWidth];

	(* need the lengths for something else later *)
	safeStringLengths = StringLength/@StringSplit[safeStringSplit,"\n"];

	(* now sub back in the boxes *)
	finalString = Fold[
		StringReplacePart[
			(* the string *)
			#1,
			(* the box going back in *)
			#2,
			(* position of the next special character *)
			First[StringPosition[#1,specialCharacter],{}]
		]&,
		safeStringSplit,
		badStrs
	];

	(* split to list at newlines *)
	{
		StringSplit[finalString,"\n"],
		safeStringLengths
	}

];


(* ::Subsubsection::Closed:: *)
(*toResultSummary*)

Options[toResultSummary]:={
	SymbolSetUpMessages -> {},
	SymbolTearDownMessages -> {},
	PercentTaskCoverage -> Null
};

toResultSummary[item_, {},{},ops:OptionsPattern[]]:=EmeraldTestSummary[
	Association[
		TestsFor->item,
		Passed->True,
		Successes->{},
		ResultFailures->{},
		TimeoutFailures->{},
		MessageFailures->{},
		Results->{},
		SuccessRate->Quantity[0,"Percent"],
		TotalTests->0,
		RunTime->Quantity[0,"Seconds"],
		SymbolSetUpMessages -> OptionValue[SymbolSetUpMessages],
		SymbolTearDownMessages -> OptionValue[SymbolTearDownMessages],
		PercentTaskCoverage -> OptionValue[PercentTaskCoverage]
	]
];

toResultSummary[item_, results:{TestResultP...},tests:{TestP...},ops:OptionsPattern[]]:=Module[
	{successes,resultFailures,timeoutFailures,messageFailures,warningFailures,
	successRate,runTime,passed},

	successes = Select[
		results,
		(#[Outcome] === "Success")&
	];
	timeoutFailures = Select[
		results,
		(#[Outcome] === "TimeoutFailure")&
	];
	resultFailures = Select[
		results,
		(#[Outcome] === "ResultFailure")&
	];
	messageFailures = Select[
		results,
		(#[Outcome] === "MessageFailure")&
	];
	warningFailures = Select[
		results,
		And[
			#[Outcome] =!= "Success",
			TrueQ[#[Warning]]
		]&
	];
	successRate = Quantity[Round[N[Length[successes]/Length[tests]]*100,0.01],"Percent"];
	runTime = Quantity[Total[#[ExecutionTime]& /@ results],"Seconds"];

	passed = And[
		Length[results] === Length[tests],
		AllTrue[
			results,
			#[Outcome] === "Success" || TrueQ[#[Warning]]&
		]
	];

	EmeraldTestSummary[
		Association[
			TestsFor->item,
			Passed->passed,
			Successes->successes,
			ResultFailures->resultFailures,
			TimeoutFailures->timeoutFailures,
			MessageFailures->messageFailures,
			WarningFailures->warningFailures,
			Results->results,
			SuccessRate->successRate,
			TotalTests->Length[tests],
			RunTime->runTime,
			SymbolSetUpMessages -> OptionValue[SymbolSetUpMessages],
			SymbolTearDownMessages -> OptionValue[SymbolTearDownMessages],
			PercentTaskCoverage -> OptionValue[PercentTaskCoverage]
		]
	]
];


(* ::Subsection::Closed:: *)
(*Notebook Manipulation*)


(* ::Subsubsection::Closed:: *)
(*writeTestNames*)


clearNotebook[notebook_NotebookObject]:=With[
	{},

	SelectionMove[notebook, All, Notebook];
	NotebookDelete[notebook];
];


(* ::Subsubsection::Closed:: *)
(*writeTestNames*)


writeTestNames[notebook_NotebookObject,testsByCategory_Association,identifier_,displayFunction:_Symbol|_Function]:=Module[
	{cells,name},

	name = ToString[identifier];

	NotebookWrite[
		notebook,
		Cell[
			ToBoxes[name],
			"TestSymbol",
			CellTags->{name},
			CellEventActions -> {
				"MouseClicked" :> openCloseCellGroup[]
			}
		]
	];

	cells = Map[
		Function[cat,
			With[
				{
					group=testsByCategory[cat],
					category=If[MatchQ[cat,_String],
						cat,
						ToString[SymbolName[cat]]
					]
				},
				Cell[
					CellGroupData[
						Prepend[
							Map[
								Cell[#[Description], "TestName", CellTags -> #[ID]] &,
								group
							],
							Cell[
								category,
								"TestCategory",
								CellTags->{category,ToString[Length[group]]},
								CellEventActions -> {
									"MouseClicked" :> openCloseCellGroup[]
								}
							]
						],
						1
					]
				]
			]
		],
		Keys[testsByCategory]
	];

	NotebookWrite[
		notebook,
		cells
	];
];


(* ::Subsubsection::Closed:: *)
(*getTestNotebook[]*)


(*
	Attempts to find a previously opened test notebook, identified by
	the window title "Unit Testing Results"
*)
getTestNotebook[]:=Module[
	{existingNotebook,returnNotebook},

	existingNotebook=SelectFirst[
		Notebooks[],
		MatchQ[Options[#,WindowTitle][[1,2]],"Test Results"]&,
		$Failed
	];

	returnNotebook = If[MatchQ[existingNotebook,_NotebookObject],
		existingNotebook,
		CreateWindow[
			StyleDefinitions->"TestSummary.nb"
		]
	];

	If[existingNotebook === $Failed,
		SetOptions[
			returnNotebook,
			WindowSize->{Scaled[1],Scaled[1]},
			WindowMargins->{{0,Automatic}, {Automatic, 0}}
		]
	];
	SetSelectedNotebook[returnNotebook];

	returnNotebook
];


(* ::Subsubsection::Closed:: *)
(*updateRunningCell*)


updateRunningCell[notebook_NotebookObject, name_String, id_String] := Module[
	{selectedCell},

	NotebookFind[notebook, id, All, CellTags];
	selectedCell = First[SelectedCells[notebook]];

	NotebookWrite[
		selectedCell,
		Cell[name, "TestRunning", CellTags -> id]
	];
];



(* ::Subsubsection::Closed:: *)
(*removeCell*)


removeCell[notebook_NotebookObject, id_String] := With[
	{},

	NotebookFind[notebook, id, All, CellTags, AutoScroll->False];
	NotebookDelete[notebook];
];


(* ::Subsubsection::Closed:: *)
(*writeCellResult*)


Options[writeCellResult]={ShowExpression->True};
writeCellResult[notebook_NotebookObject, id_String, result : TestResultP, ops:OptionsPattern[]] := Module[
	{cell, selectedCell},

	NotebookFind[notebook, id, All, CellTags, AutoScroll->False];
	selectedCell = First[SelectedCells[notebook]];

	cell = resultToCellGroup[result, id, ops];

	NotebookWrite[selectedCell, cell];
];


(* ::Subsubsection::Closed:: *)
(*resultToCellGroup*)


Options[resultToCellGroup]={ShowExpression->True};
resultToCellGroup[result : TestResultP, id_String, OptionsPattern[]] := Module[
	{},
	Cell[
		CellGroupData[
			Join[
				{
					resultToNameCell[result, id]
				},
				If[OptionValue[ShowExpression],
					{Cell[BoxData[ToBoxes[result[Expression]]], "TestExpression"]},
					{}
				],
				{
					Cell[BoxData[ToBoxes[result[ExpectedValue]]], "TestExpectedOutput"],
					Cell[BoxData[ToBoxes[result[ActualValue]]], "TestOutput"]
				},
				If[result[ExpectedMessages]==={} && result[ActualMessages]==={},
					{},
					{
						Cell[BoxData[ToBoxes[result[ExpectedMessages]]], "TestExpectedMessages"],
						Cell[BoxData[ToBoxes[result[ActualMessages]]], "TestMessages"]
					}
				],
				{
					Cell[BoxData[ToBoxes[{result[StartDate], result[EndDate]}]], "StartDate/EndDate"]
				},
				If[result[SetUpMessages]==={},
					{},
					{
						Cell[BoxData[ToBoxes[result[SetUpMessages]]], "SetUpMessages"]
					}
				],
				If[result[TearDownMessages]==={},
					{},
					{
						Cell[BoxData[ToBoxes[result[TearDownMessages]]], "TearDownMessages"]
					}
				],
				If[result[Simulation]===Null,
					{},
					{
						Cell[BoxData[ToBoxes[result[Simulation]]], "Simulation"]
					}
				]
			],
			1
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*resultToNameCell*)


resultToNameCell[result : TestResultP, id_String] := Module[
	{
		outcome, name, prefix, sandbox
	},
	sandbox=result[Sandbox];
	outcome=result[Outcome];
	name=result[Description];
	prefix = Switch[outcome,
		"TimeoutFailure",
		"\[WatchIcon]",
		"ResultFailure",
		"\[Square]",
		"MessageFailure",
		"\[WarningSign]",
		"Success",
		"\[Checkmark]"
	];

	Cell[
		BoxData[
			GridBox[
				{{
					StyleBox[prefix, FontSize->24, FontColor->Black],
					Cell[TextData[name]],
					If[sandbox, StyleBox["\[KernelIcon]", FontSize->24, FontColor->Black, Alignment -> Right], ""]
				}},
				ColumnAlignments -> {Center, Left, Right},
				RowAlignments -> {Center, Center, Center}
			]
		],
		Switch[outcome,
			"TimeoutFailure",
				"TestTimeoutFailure",
			"ResultFailure",
				"TestResultFailure",
			"MessageFailure",
				"TestMessageFailure",
			"Success",
				"TestSuccess"
		],
		CellTags->id
	]
];

openCloseCellGroup[] := With[
	{},
	SelectionMove[InputNotebook[], All, ButtonCell, AutoScroll -> False];
	FrontEndExecute[FrontEndToken["OpenCloseGroup"]];
];


(* ::Subsubsection::Closed:: *)
(*writeSummaryCell*)


writeSummaryCell[notebook_NotebookObject,name_String,summary_EmeraldTestSummary]:=Module[
	{grid},

	grid=resultGrid[
		Length[summary[Results]],
		Length[summary[Successes]],
		Length[summary[ResultFailures]],
		Length[summary[MessageFailures]],
		Length[summary[TimeoutFailures]]
	];

	NotebookFind[notebook, name, All, CellTags, AutoScroll->False];
	SelectionMove[notebook, After, Cell,AutoScroll->False];

	NotebookWrite[
		notebook,
		Cell[BoxData[ToBoxes[grid]],"ResultSummary"]
	];

	SelectionMove[notebook, After, Notebook];
];

resultGrid[total_Integer,success_Integer,resultFailure_Integer,messageFailure_Integer,timeoutFailure_Integer]:=Module[
	{resultSections,nonZeroSections,rows,backgroundRules},

	resultSections={
			{"Total Tests: ", total, GrayLevel[0.45]},
			{"Successes: ", success, RGBColor[0.380392,0.603922,0.384314]},
			{"Result Failures: ", resultFailure, RGBColor[0.74902,0.403922,0.4]},
			{"Message Failures: ", messageFailure, RGBColor[0.921569,0.678431,0.337255]},
			{"Timeout Failures: ", timeoutFailure, RGBColor[0.945,0.81,0.314]}
	};

	nonZeroSections=Select[
		resultSections,
		#[[2]]>0&
	];

	rows = Map[
		Apply[rowBox,Part[#,{1,2}]]&,
		nonZeroSections
	];

	backgroundRules = MapIndexed[
	{1,First[#2]}->Last[#1]&,
		nonZeroSections
	];

	Grid[
		{rows},
		Frame->All,
		Alignment->Center,
		Background->{
			None,
			None,
			backgroundRules
		},
		FrameStyle->GrayLevel[0.65]
	]
];

rowBox[text_String,count_Integer]:=Row[{fontStyle[text],fontStyle[count]},ImageSize->{150,22},Alignment->Center];
fontStyle[input_]:=Style[input,FontSize->14,FontWeight->Bold,FontFamily->"Arial",FontColor->RGBColor[1,1,1]];


(* ::Subsection::Closed:: *)
(*Querying Tests*)


(* ::Subsubsection::Closed:: *)
(*UnitTestedItems*)


DefineOptions[
	UnitTestedItems,
	Options:>{
		{Output->All,Symbol|String|Type|All,"Controls whether to filter the output by Symbols/String/Types or everything."},
		{Skipped->False,True|False|All,"True returns only skipped symbol, False returns only non-skipped symbols, All returns both skipped and not-skipped symbols."},
		{Platform->{$OperatingSystem},{("Windows"|"MacOSX"|"Unix")..},"Return only test items which can run on all the specified platforms."}
	}
];


(*Returns all symbols/strings with unit tests, filtered by Option value*)
UnitTestedItems[ops:OptionsPattern[]]:=With[
	{},

	LoadTests[];
	filterTestedItems[
		ops,
		Function[True]
	]
];

filterTestedItems[ops:OptionsPattern[UnitTestedItems],selector_Function]:=Module[
	{
		skippedCheck=skippedSelector[OptionValue[Skipped]],
		platformCheck=platformSelector[OptionValue[Platform]],
		outputCheck=outputSelector[OptionValue[Output]]
	},
	Select[
		Keys[
			Select[
				symbolTests,
				And[
					skippedCheck[Lookup[#,"Skip"]],
					platformCheck[Lookup[#,"Platform"]],
					selector[#]
				]&
			]
		],
		outputCheck
	]
];

skippedSelector[True]=MatchQ[_String];
skippedSelector[False]=MatchQ[False];
skippedSelector[All]=MatchQ[_String|False];

platformSelector[platforms:{__String}]:=Function[in,
	MatchQ[
		Complement[
			platforms,
			in
		],
		{}
	]
];

outputSelector[String]:=MatchQ[_String];
outputSelector[Symbol]:=MatchQ[_Symbol];
outputSelector[Type]:=MatchQ[ECL`Object[__Symbol]];
outputSelector[All]:=MatchQ[_String|_Symbol|ECL`Object[__Symbol]];


(*Returns symbols/strings with unit tests for a specific context,
filtered by Option value*)
UnitTestedItems[context_String?ContextQ,ops:OptionsPattern[]]:=With[{},
	If[PackageQ[context],
		LoadTests[context]
	];

	filterTestedItems[
		ops,
		Function[testInfo,
			And[
				StringQ[Lookup[testInfo,"Package"]],
				StringMatchQ[Lookup[testInfo,"Package"], context ~~ ___]
			]
		]
	]
];

(*Returns symbols/strings with unit tests for a specific file,
filtered by Option value*)
UnitTestedItems[fileName_String?filePathQ,ops:OptionsPattern[]]:=With[
	{
		filePattern=If[FileExistsQ[fileName],
			fileName,
			___~~FileNameJoin[{"","Tests",fileName}]
		]
	},

	LoadTests[];

	filterTestedItems[
		ops,
		Function[testInfo,
			StringMatchQ[Lookup[testInfo,"File"], filePattern]
		]
	]
];

filePathQ[fileName_String]:=StringMatchQ[
	fileName,
	__~~"."~~(WordCharacter..)
];


(* ::Subsubsection::Closed:: *)
(*Tests*)


(* ::Subsubsubsection::Closed:: *)
(*Hold Helper Functions*)


(* Given f and Hold[g[x]], return Hold[f[g[x]]] without evaluating anything. *)
holdComposition[f_,Hold[expr__]]:=Hold[f[expr]];
holdComposition[List,{}]:=Hold[{}];
SetAttributes[holdComposition,HoldAll];

(* Given f and {Hold[a[x]], Hold[b[x]]..}, returns Hold[f[a[x],b[x]..]]. *)
holdCompositionList[f_,{helds___Hold}]:=Module[{joinedHelds},
	(* Join the held heads. *)
	joinedHelds=Join[helds];

	(* Swap the outer most hold with f. Then hold the result. *)
	With[{insertMe=joinedHelds},holdComposition[f,insertMe]]
];
SetAttributes[holdCompositionList,HoldAll];

(* Given Hold[{one__}] and Hold[{two__}] returns Hold[one, two]. *)
holdListJoin[heldList1_,heldList2_]:=Join[heldList1,heldList2]/.{Hold[List[x___],List[y___]]:>Hold[List[x,y]]};
SetAttributes[holdListJoin,HoldAll];


(* ::Subsubsubsection::Closed:: *)
(*Thread Helper*)


(*Given a Held list of Example/Test functions, update old formats to meet the
new standard and append the common Setup/Teardown options to the calls*)
threadOptions[tests: {}, options : {(_Rule | _RuleDelayed) ...}] := {};
threadOptions[tests: Hold[{(_Test | _Example) ...}], options : {(_Rule | _RuleDelayed) ...}] := With[
	{ops = Sequence @@ options},
	Replace[
		tests,
		{
			(*Old Test format without Description or expected value (implied True), add options*)
			Test[expr_] :> Test["", expr, True, ops],
			(*Old Test format without Description, add empty description and options*)
			Test[expr : Except[_String], expected_, rest:(_Rule|_RuleDelayed)...] :> Test["", expr, expected, Evaluate[joinStubs[options,{rest}]]],
			(*Old Test format without expected value (implied True)*)
			Test[desc_String, expr_] :> Test[desc, expr, True, ops],
			(*Current Test format, append options*)
			Test[desc_String, expr_, expected_, rest:(_Rule|_RuleDelayed)...] :> Test[desc, expr, expected, Evaluate[joinStubs[options,{rest}]]],
			(*Current Example format, append options*)
			Example[desc_List,expr_,expected_, rest:(_Rule|_RuleDelayed)...] :> Example[desc, expr, expected, Evaluate[joinStubs[options,{rest}]]]
		},
		{2}
	]
];

(*If input expression is improperly formatted, just return that expression.
This is used in the case of Output->Hold*)
threadOptions[input:Hold[___], options : {(_Rule | _RuleDelayed) ...}]:=input;

joinStubs[a : {(_Rule | _RuleDelayed) ...}, b : {(_Rule | _RuleDelayed) ...}] := With[
	{
		stubs = Join[
			Select[a, First[#] === Stubs &],
			Select[b, First[#] === Stubs &]
		],
		withoutStubs = Join[
			Select[a, First[#] =!= Stubs &],
			Select[b, First[#] =!= Stubs &]
		]
	},
	Module[
		{stubRule},
		stubRule = Replace[
			Join@@(Replace[
				stubs,
				List -> Hold,
				{3},
				Heads -> True
			][[All, 2]]),
			Hold[x___] :> (Stubs :> {x}),
			{0},
			Heads->True
		];

		Sequence@@Append[withoutStubs, stubRule]
	]
];


(* ::Subsubsubsection::Closed:: *)
(*Public Function*)


DefineOptions[
	Tests,
	Options:>{
		{Output->{Test,Example},Test|Example|{Test,Example}|Hold,"Controls output filtering of TestP vs ExampleP. By default returns both but can be restricted to either one using Test|Example respectively."}
	}
];

Tests[identifier:_Symbol|_String|ECL`Object[__Symbol]|ECL`Model[__Symbol],OptionsPattern[]]:=Module[
	{testsCache,heldTests,heldDefinition,testsAndExamples,filter,symbolOptions},

	(* Try to figure out the package where this function is located. *)
	(* If we find it, load the tests from that package. If we can't find it, load all of the tests. *)
	With[
		{package=FunctionPackage[identifier]},
		If[package===$Failed,
			LoadTests[],
			LoadTests[package]
		]
	];

	(*Parse the DownValues symbolTests (where the tests and associated
	information for any given symbol/string are stored) and extract
	the portion that is the tests/examples themselves (ignoring the information
	about symbol context etc.)*)

	(* Get the cache of tests that we stashed for this symbol. *)
	testsCache=Lookup[symbolTests,identifier,<||>];

	(* Get the tests from the test cache. *)
	heldTests=Lookup[testsCache,"Tests",{}];

	(*fetch Setup/Teardown options associated with symbol via DefineTests*)
	(* NOTE: We don't want to inherit the global Variables option from DefineTests[...] since that will scope it twice. *)
	symbolOptions=Normal@KeyDrop[defaultTestOptions[identifier], Variables];

	(*Add to all Tests/Examples the Setup/Teardown options associated with the given symbol*)
	testsAndExamples=threadOptions[
		heldTests,
		symbolOptions
	];

	(*Filter the output Tests/Examples based on the Output option*)
	filter=OptionDefault[OptionValue[Output]];

	Quiet[
		Switch[filter,
			Test,
				Select[ReleaseHold[testsAndExamples],And[MatchQ[#,TestP],!MatchQ[#,ExampleP]]&],
			Example,
				Cases[ReleaseHold[testsAndExamples],ExampleP,{1}],
			_List,
				Cases[ReleaseHold[testsAndExamples],TestP,{1}],
			Hold,
				If[MatchQ[testsAndExamples,{}],
					Hold[{}],
					testsAndExamples
				]
		]
	]
];


(* ::Subsubsection::Closed:: *)
(*TestFile*)


TestFile[identifier:_Symbol|_String|ECL`Object[__Symbol]] := Module[
	{packages},

	packages = itemPackage[identifier];
	If[MemberQ[packages,$Failed],
		LoadTests[],
		LoadTests[packages]
	];

	Lookup[
		Lookup[
			symbolTests,
			identifier,
			Association[]
		],
		"File",
		$Failed
	]
];


(* ::Subsubsection::Closed:: *)
(*TestInformation*)


TestInformation[identifier:_Symbol|_String|ECL`Object[__Symbol]]:=Module[{package},

	package=FunctionPackage[identifier];
	If[MatchQ[package,$Failed],
		LoadTests[],
		LoadTests[package]
	];

  Lookup[
		symbolTests,
		identifier,
		$Failed
	]
];


(* ::Subsubsection::Closed:: *)
(*TestOptions*)


TestOptions[identifier:_Symbol|_String|ECL`Object[__Symbol]] := Lookup[
	Lookup[
		symbolTests,
		identifier,
		Association[]
	],
	"Options",
	$Failed
];

defaultTestOptions[identifier:_Symbol|_String|ECL`Object[__Symbol]]:=With[
	{testOpts = TestOptions[identifier]},

	If[testOpts===$Failed,
		{},
		testOpts
	]
];
defaultTestOptions[___]:={};


(* ::Subsection::Closed:: *)
(*Summary Boxes*)


(* ::Subsubsection::Closed:: *)
(*Common Helpers*)


(*Common colors used throughout for summary information*)
testColors = Association[
	ResultSuccess->RGBColor[0.380392, 0.603922, 0.384314],
	ResultFailure->RGBColor[0.74902, 0.403922, 0.4],
	MessageFailure->RGBColor[0.921569, 0.678431, 0.337255],
	TimeoutFailure->RGBColor[0.945, 0.81, 0.314],
	WarningFailure->RGBColor[0.921569, 0.678431, 0.337255],
	Running->GrayLevel[0.35],
	Pending->GrayLevel[0.65]
];

failureIcon[]:=With[
	{image=Import[FileNameJoin[{PackageDirectory["UnitTest`"],"resources","failure.png"}]]},
	warningIcon[]=Image[
		image,
		ImageSize -> {Automatic, Dynamic[3.5*CurrentValue["FontCapHeight"]]}
	]
];

successIcon[]:=With[
	{image=Import[FileNameJoin[{PackageDirectory["UnitTest`"],"resources","success.png"}]]},
	warningIcon[]=Image[
		image,
		ImageSize -> {Automatic, Dynamic[3.5*CurrentValue["FontCapHeight"]]}
	]
];

warningIcon[]:=With[
	{image=Import[FileNameJoin[{PackageDirectory["UnitTest`"],"resources","warning.png"}]]},
	warningIcon[]=Image[
		image,
		ImageSize -> {Automatic, Dynamic[3.5*CurrentValue["FontCapHeight"]]}
	]
];



(* ::Subsubsection::Closed:: *)
(*EmeraldTestSummary*)


OnLoad[
	MakeBoxes[summary:EmeraldTestSummary[assoc_Association], StandardForm] := With[
		{testCount = assoc[TotalTests]},

		BoxForm`ArrangeSummaryBox[
			EmeraldTestSummary,
			summary,
			Which[
				Length[assoc[WarningFailures]]>0,
					warningIcon[],
				SameQ[Length[assoc[Results]],testCount] && assoc[Passed],
					successIcon[],
				True,
					failureIcon[]
			],
			{
				{
					BoxForm`SummaryItem[{"Tests For: ", assoc[TestsFor]}],
					BoxForm`SummaryItem[{"Total Tests: ", testCount}]
				},
				{
					BoxForm`SummaryItem[{"Run Time: ", assoc[RunTime]}],
					BoxForm`SummaryItem[{"Success Rate: ", assoc[SuccessRate]}]
				},
				If[NullQ[Lookup[assoc, PercentTaskCoverage]],
					Nothing,
					{BoxForm`SummaryItem[{"Percent Task Coverage: ", assoc[PercentTaskCoverage]}]}
				]
			},
			{
				{
					BoxForm`SummaryItem[{"Successes: ", Length[assoc[Successes]]}],
					BoxForm`SummaryItem[{"Warnings: ", Length[assoc[WarningFailures]]}]
				},
				{
					BoxForm`SummaryItem[{"Result Failures: ", Length[assoc[ResultFailures]]}],
					BoxForm`SummaryItem[{"Timeout Failures: ", Length[assoc[TimeoutFailures]]}]
				},
				{
					BoxForm`SummaryItem[{"Message Failures: ", Length[assoc[MessageFailures]]}],
					BoxForm`SummaryItem[{"Incomplete: ", testCount-Length[assoc[Results]]}]
				}
			},
			StandardForm
		]
	]
];

(*Add SubValues accessor*)
OverloadSummaryHead[EmeraldTestSummary];


(* ::Subsubsection::Closed:: *)
(*TestFailureNotebook*)

Authors[TestFailureNotebook]:={"yanzhe.zhu", "james.kammert"};

(* overload for unit tests *)
TestFailureNotebook[unitTestObject:ObjectP[Object[UnitTest,Function]],ops:OptionsPattern[TestFailureNotebook]]:=Module[{},
	TestFailureNotebook[Get[DownloadCloudFile[unitTestObject[EmeraldTestSummary],$TemporaryDirectory]],ops]
];

TestFailureNotebook[mySummary_EmeraldTestSummary] := Module[
	{contents, testsFor, passed, successes, resultFailures,
		timeoutFailures, messageFailures, warningFailures, results,
		successRate, totalTests, runTime, fakeNotebook},

	contents = mySummary /. {EmeraldTestSummary[x_] :> x};

	{testsFor, passed, successes, resultFailures, timeoutFailures,
		messageFailures, warningFailures, results, successRate,
		totalTests, runTime} =
			Lookup[contents, {TestsFor, Passed, Successes, ResultFailures,
				TimeoutFailures, MessageFailures, WarningFailures, Results,
				SuccessRate, TotalTests, RunTime}];

	(*remove passing tests*)
	If[passed,
		Print["No failing tests to display!"];
		Return[Null]
	];

	(*reassemble the emerald test summary*)
	fakeNotebook = EmeraldTestSummary[
		<|
			TestsFor -> testsFor,
			Passed -> passed,
			Successes -> {},
			ResultFailures -> resultFailures,
			TimeoutFailures -> timeoutFailures,
			MessageFailures -> messageFailures,
			WarningFailures -> warningFailures,
			Results ->
					Flatten[{resultFailures, timeoutFailures, messageFailures,
						warningFailures}],
			SuccessRate -> 0 Percent,
			TotalTests ->
					Length[Flatten[{resultFailures, timeoutFailures,
						messageFailures, warningFailures}]],
			RunTime -> runTime
		|>
	];

	TestSummaryNotebook[fakeNotebook]
];



(* ::Subsubsection::Closed:: *)
(*TestSummaryNotebook*)

DefineOptions[TestSummaryNotebook,
	Options:> {
		{Destination->Automatic,Automatic|Desktop|Cloud,"If Desktop, return a local notebook.  If Cloud, create a CloudObject.  If Automatic, create CloudObject if $CloudEvaluation is True."}
	}
];

(* overload for unit tests *)
TestSummaryNotebook[unitTestObject:ObjectP[Object[UnitTest,Function]],ops:OptionsPattern[]]:=Module[{},
	TestSummaryNotebook[Get[DownloadCloudFile[unitTestObject[EmeraldTestSummary],$TemporaryDirectory]],ops]
];

TestSummaryNotebook[summary_CloudObject,ops:OptionsPattern[]]:=Module[{ets},
	ets = CloudGet[summary];
	If[MatchQ[ets,_EmeraldTestSummary],
		TestSummaryNotebook[ets,ops],
		Message[TestSummaryNotebook::InvalidCloudObject];
	]
];


TestSummaryNotebook[summary_EmeraldTestSummary,ops:OptionsPattern[]]:=Module[
	{destination},
	destination = OptionValue[Destination];
	destination = Switch[destination,
		Automatic, If[$CloudEvaluation, Cloud, Desktop],
		_, destination
	];

	Switch[destination,
		Cloud, testSummaryCloudNotebook[summary],
		Desktop, testSummaryDesktopNotebook[summary]
	]

];

testSummaryNotebookResultCells[results:{TestResultP...}] := Module[{resultsByCategory},
	resultsByCategory = GroupBy[
		results,
		#[Category]&
	];

	Map[
		Function[cat,
			With[
				{
					group=resultsByCategory[cat],
					category=If[MatchQ[cat,_String],
						cat,
						ToString[SymbolName[cat]]
					]
				},
				Cell[
					CellGroupData[
						Prepend[
							Map[
								resultToCellGroup[#,CreateUUID[]]&,
								group
							],

							Cell[
								category,
								"TestCategory",
								CellTags->{category,ToString[Length[group]]},
								CellEventActions -> {
									"MouseClicked" :> openCloseCellGroup[]
								}
							]
						]
					]
				]
			]
		],
		Keys[resultsByCategory]
	]
];

testSummaryDesktopNotebook[summary_EmeraldTestSummary]:=Module[
	{notebook, name, sandboxResults, manifoldResults, sandboxCells, manifoldCells},

	notebook = NotebookCreate[
		StyleDefinitions->"TestSummary.nb",
		Visible->False
	];
	name = ToString[summary[TestsFor]];

	(*Write Name*)
	NotebookWrite[
		notebook,
		Cell[
			name,
			"TestSymbol",
			CellTags->{name},
			CellEventActions -> {
				"MouseClicked" :> openCloseCellGroup[]
			}
		]
	];

	writeSummaryCell[notebook, name, summary];

	sandboxResults = Select[summary[Results], #[Sandbox] == True &];

	manifoldResults = Select[summary[Results], Not@TrueQ[#[Sandbox]] &];

	sandboxCells = testSummaryNotebookResultCells[sandboxResults];
	manifoldCells = testSummaryNotebookResultCells[manifoldResults];

	If[Length[manifoldCells]>0,
		NotebookWrite[notebook, Cell["Integration Test Results", "ResultSummary"]];
		NotebookWrite[notebook, manifoldCells];
	];

	If[Length[sandboxCells]>0,
		NotebookWrite[notebook, Cell["Sandbox Results", "ResultSummary"]];
		NotebookWrite[notebook, sandboxCells];
	];

	SetOptions[notebook,Visible->True];
	SetSelectedNotebook[notebook];

	notebook
];


testSummaryCloudNotebook[summary_EmeraldTestSummary]:=Module[
		{ name, notebook, grid, resultsByCategory, testCells},

		name = ToString[summary[TestsFor]];
		notebook = CloudObject[];
		(* notebook = CloudObject["user:brad@emeraldcloudlab.com/UnitTests/"<>name<>".nb"]; *)

		grid = UnitTest`Private`resultGrid[
			Length[summary[Results]],
			Length[summary[Successes]],
			Length[summary[ResultFailures]],
			Length[summary[MessageFailures]],
			Length[summary[TimeoutFailures]]
		];
	    resultsByCategory = GroupBy[
			summary[Results],
			#[Category]&
		];

		testCells = Map[
			Function[cat,
				With[{
						group=resultsByCategory[cat],
						category=If[MatchQ[cat,_String],cat,ToString[SymbolName[cat]]]
					},
					Cell[CellGroupData[Prepend[
						Map[
							Cell[
								CellGroupData[
									Join[
										{UnitTest`Private`resultToNameCell[#, CreateUUID[]]},
										{Cell[BoxData[ToBoxes[#[Expression]]], "TestExpression"]},
										{
											Cell[BoxData[ToBoxes[#[ExpectedValue]]], "TestExpectedOutput"],
											Cell[BoxData[ToBoxes[#[ActualValue]]], "TestOutput"]
										},
										If[#[ExpectedMessages]==={} && #[ActualMessages]==={},
											{},
											{
												Cell[BoxData[ToBoxes[#[ExpectedMessages]]], "TestExpectedMessages"],
												Cell[BoxData[ToBoxes[#[ActualMessages]]], "TestMessages"]
											}
										],
										{
											Cell[BoxData[ToBoxes[{#[StartDate], #[EndDate]}]], "StartDate/EndDate"]
										},
										If[#[SetUpMessages]==={},
											{},
											{
												Cell[BoxData[ToBoxes[#[SetUpMessages]]], "SetUpMessages"]
											}
										],
										If[#[TearDownMessages]==={},
											{},
											{
												Cell[BoxData[ToBoxes[#[TearDownMessages]]], "TearDownMessages"]
											}
										],
										If[#[Simulation]===Null,
											{},
											{
												Cell[BoxData[ToBoxes[#[Simulation]]], "Simulation"]
											}
										]
									],
									1
								]
							]&,
							group
						],

						Cell[
							category,
							"TestCategory",
							CellTags->{category,ToString[Length[group]]}
	          ]
					]
				]]]
			],
			Keys[resultsByCategory]
		];


		CloudDeploy[
			Notebook[
				{
					Cell[name,"TestSymbol",CellTags->{name}],
					Cell[BoxData[ToBoxes[grid]],"ResultSummary"],
					testCells
				},
						StyleDefinitions->Import[FileNameJoin[{ECL`$EmeraldPath,"UnitTest","FrontEnd","StyleSheets","CloudTestSummary.nb"}]]
			],
			notebook,
			Permissions->{"Authenticated" ->{"Read", "Write","Execute"}}
		];
		(* SetPermissions[notebook,"Public"]; *)
		(* CloudPublish[notebook]; *)

		notebook
];

(* ::Subsubsection::Closed:: *)
(*LoadTests*)


(*Load all test files for all known, loaded packages*)
LoadTests[]:=AssociationMap[
	LoadTests,
	Select[
		$Packages,
		PackageQ
	]
];


LoadTests[packages:{___String}]:=AssociationMap[
	LoadTests,
	packages
];

(*Load all m-files in the tests directory for the given package.
These files will define the unit tests for functions in the package.*)
LoadTests[package_String]:=Module[
	{metadata, directory, testFiles},

	(*Try and load metadata for the package, if not found return $Failed*)
	metadata = PackageMetadata[package];
	If[metadata === $Failed,
		Return[$Failed]
	];

	directory = Lookup[metadata,"Directory"];

	(*Find all m-files which define tests *)
	testFiles = FileNames[
		"*.m",
		FileNameJoin[{directory,"tests"}],
		Infinity
	];

	(*Load all dependencies for the package and load the test files
	in the `Private` context for the given package.*)
	Block[{$ContextPath},
		$ContextPath = {"System`","Packager`"};

		(* Begin the context *)
		Begin[package<>"Private`"];

		(*Load dependencies*)
		Scan[
			LoadPackage,
			Union[
				Lookup[metadata,"Dependencies",{}],
				{package,"UnitTest`"}
			]
		];

		(* Load Tests *)
		Scan[
			loadTestFile,
			testFiles
		];

		End[];
	];
];

(*Only load a test file if it has not been loaded or it has modified
since last load*)
loadTestFile[path_String]:=With[
	{modificationDate = FileDate[path]},

	(* Initialize loaded tests association to keep track of which files are loaded when*)
	If[!ValueQ[loadedTestFiles],
		loadedTestFiles=Association[]
	];

	If[modificationDate >= Lookup[loadedTestFiles,path,DateObject[0]],
		Get[path];
		AppendTo[
			loadedTestFiles,
			path -> Now
		]
	]
];
