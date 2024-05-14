(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Title:: *)
(*UnitTest: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection::Closed:: *)
(*ContextQ*)


DefineTests[
	ContextQ,
	{
		Example[{Basic,"Returns True if input is a valid context string:"},
			ContextQ["Core`"],
			True
		],

		Example[{Basic,"Returns False if input is not a string:"},
			ContextQ[Taco],
			False
		],

		Example[{Basic,"Returns False if input is not of the form word` repeated:"},
			ContextQ["XYZ`Test.txt`"],
			False
		],

		Test["Returns False if string has no characters besides `:",
			ContextQ["`"],
			False
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*Test*)


UnitTest`Private`A::Message="";
UnitTest`Private`B::Message="";

DefineTests[
	Test,
	{
		Example[{Basic,"Define a test that asserts 2+2=4:"},
			Test["2 plus 2 is 4:",2+2,4],
			TestP
		],

		Example[{Options,Messages,"Define a test that expects a Message to be thrown:"},
			Test["1/0 Throws error message:",1/0,ComplexInfinity,Messages:>Power::infy],
			TestP
		],

		Example[{Options,TimeConstraint,"Define a test expects execution of the test to be < 2 seconds:"},
			Test["Execution does not take longer than 2 seonds",Pause[3],Null,TimeConstraint->2],
			TestP
		],

		Example[{Options,EquivalenceFunction,"Define a test that uses Equal for result comparison instead of MatchQ:"},
			Test["10.0 = 10:",2*5.0,10,EquivalenceFunction->Equal],
			TestP
		],

		Example[{Options,Stubs,"Re-define the entire behaviour of a symbol within the context of a Test using a SetDelayed Stub:"},
			Test["Map[Taco] == \"Banana!\"","I am a "<>Map[Taco],"I am a Banana!",Stubs:>{Map[Taco]:="Banana!"}],
			TestP
		],

		Example[{Options,Stubs,"Prepend a DownValue to a symbol within the context of a Test using a Set Stub:"},
			Test["Map[Taco] == \"Banana!\"","I am a "<>Map[Taco],"I am a Banana!",Stubs:>{Map[Taco]="Banana!"}],
			TestP
		],

		Example[{Options,Category,"Categorize a Test:"},
			Test["1+1",1+1,2,Category->"Math"],
			_EmeraldTest?(#[Category]==="Math"&)
		],

		Example[{Options,SubCategory,"Sub-Categorize a Test:"},
			Test["1+1",1+1,2,Category->"Math",SubCategory->"Addition"],
			_EmeraldTest?(#["SubCategory"]==="Addition"&)
		],
		Example[{Options, SubCategory, "Sub-Categorize a Test using more than one value:"},
			Test["2 * (1+1)", 2 * (1 + 1), Category -> "Math", SubCategory -> {Plus, Times}],
			_EmeraldTest?(#["SubCategory"]==={Plus, Times}&)
		],

		Example[{Options,FatalFailure,"Flag a Test as a \"Fatal Failure\", causing the test run to be stopped on failure of this test:"},
			Test["1+1",1+1,2,FatalFailure->True],
			_EmeraldTest?(#[FatalFailure]===True&)
		],

		Example[{Options, SetUp, "Specify expressions to be run before the Test:"},
			Test["Sample:", 2, 2, SetUp :> {Print["Starting my setup test!"]}],
			_EmeraldTest
		],

		Example[{Options, Sandbox, "Specify if the test is Sandbox enabled:"},
			Test["Sample:", 2, 2, SetUp :> {Print["Starting my setup test!"]}, Sandbox -> True],
			_EmeraldTest?(#["Sandbox"]===True&)
		],

		Example[{Options, TearDown, "Specify expressions to be run after the Test:"},
			Test["Sample:", 2, 2, TearDown :> {Print["Finished my teardown test!"]}],
			_EmeraldTest
		],

		Example[{Options, Variables, "Specify variables to share between test and expected value expressions:"},
			Test["Sample:", xyz = 7; xyz + 7, 2*xyz, Variables :> {xyz}],
			_EmeraldTest
		],

		Example[{Options, Variables, "Specify variables to share between SetUp, TearDown, test, and expected value expressions:"},
			Test["Sample:",
				xyz + 7,
				2 * xyz,
				Variables :> {xyz},
				SetUp :> {xyz = 7},
				TearDown :> {Print[xyz]}
			],
			_EmeraldTest
		],

		Example[{Options, Warning, "Flag test as being a Warning and should not cause a failure in RunUnitTest:"},
			With[
				{tests={Test["1+1=3:",1+1,3,Warning->True]}},
				First[RunUnitTest[{"Example"->tests},Verbose->False]][Passed]
			],
			True
		],

		Example[{Attributes,HoldRest,"Holds all inputs except the first:"},
			Test[StringJoin["One","Two"],2+2],
			Test["OneTwo",HoldPattern[2+2]]
		],

		Test["Messages can accept Message and MessageName heads simultaniously:",
			(* TODO:Jared: we shouldn't have to run this to check the property *)
			RunTest[
				Test["A test", True, True, Messages:>{f::argx, Message[f::argx,1,2]}]
			][ExpectedMessages],
			{HoldForm[f::argx], HoldForm[Message[f::argx,1,2]]}
		],

		Test["Distinct message heads with the same string are not identical:",
			RunTest[
				Test["A message test",
					Message[UnitTest`Private`A::Message],
					Null,
					Messages:>{UnitTest`Private`B::Message}
				]
			][Outcome],
			"MessageFailure"
		],
		Test["Indicate the StartDate and EndDate of a given Test:",
			test = RunTest[
				Test["A test",
					True,
					True
				]
			];
			{
				test[StartDate],
				test[EndDate]
			},
			{
				_?DateObjectQ,
				_?DateObjectQ
			},
			Variables :> {test}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*Warning*)


DefineTests[
	Warning,
	{
		Example[{Basic,"Define a warning that asserts 2+2=4:"},
			Warning["2 plus 2 is 4:",2+2,4],
			EmeraldTest_
		],

		Example[{Options,Messages,"Define a warning that expects a Message to be thrown:"},
			Warning["1/0 Throws error message:",1/0,ComplexInfinity,Messages:>Power::infy],
			TestP
		],

		Example[{Options,TimeConstraint,"Define a warning expects execution of the warning to be < 2 seconds:"},
			Warning["Execution does not take longer than 2 seconds",Pause[3],Null,TimeConstraint->2],
			TestP
		],

		Example[{Options,EquivalenceFunction,"Define a warning that uses Equal for result comparison instead of MatchQ:"},
			Warning["10.0 = 10:",2*5.0,10,EquivalenceFunction->Equal],
			TestP
		],

		Example[{Options,Stubs,"Re-define the entire behaviour of a symbol within the context of a Test using a SetDelayed Stub:"},
			Warning["Map[Taco] == \"Banana!\"","I am a "<>Map[Taco],"I am a Banana!",Stubs:>{Map[Taco]:="Banana!"}],
			TestP
		],

		Example[{Options,Stubs,"Prepend a DownValue to a symbol within the context of a Test using a Set Stub:"},
			Warning["Map[Taco] == \"Banana!\"","I am a "<>Map[Taco],"I am a Banana!",Stubs:>{Map[Taco]="Banana!"}],
			TestP
		],

		Example[{Options,Category,"Categorize a Test:"},
			Warning["1+1",1+1,2,Category->"Math"],
			_EmeraldTest?(#[Category]==="Math"&)
		],

		Example[{Options,SubCategory,"Sub-Categorize a Test:"},
			Warning["1+1",1+1,2,Category->"Math",SubCategory->"Addition"],
			_EmeraldTest?(#["SubCategory"]==="Addition"&)
		],

		Example[{Options,FatalFailure,"Flag a Test as a \"Fatal Failure\", causing the warning run to be stopped on failure of this warning:"},
			Warning["1+1",1+1,2,FatalFailure->True],
			_EmeraldTest?(#[FatalFailure]===True&)
		],

		Example[{Options, SetUp, "Specify expressions to be run before the Test:"},
			Warning["Sample:", 2, 2, SetUp :> {Print["Starting my setup warning!"]}],
			_EmeraldTest
		],

		Example[{Options, TearDown, "Specify expressions to be run after the Test:"},
			Warning["Sample:", 2, 2, TearDown :> {Print["Finished my teardown warning!"]}],
			_EmeraldTest
		],

		Example[{Options, Variables, "Specify variables to share between warning and expected value expressions:"},
			Warning["Sample:", xyz = 7; xyz + 7, 2*xyz, Variables :> {xyz}],
			_EmeraldTest
		],

		Example[{Options, Variables, "Specify variables to share between SetUp, TearDown, warning, and expected value expressions:"},
			Warning["Sample:",
				xyz + 7,
				2 * xyz,
				Variables :> {xyz},
				SetUp :> {xyz = 7},
				TearDown :> {Print[xyz]}
			],
			_EmeraldTest
		],

		Example[{Options, Warning, "Flag warning as being a Warning and should not cause a failure in RunUnitTest:"},
			With[
				{warnings={Warning["1+1=3:",1+1,3,Warning->True]}},
				First[RunUnitTest[{"Example"->warnings},Verbose->False]][Passed]
			],
			True
		],

		Example[{Attributes,HoldRest,"Holds all inputs except the first:"},
			Warning[StringJoin["One","Two"],2+2],
			Warning["OneTwo",HoldPattern[2+2]]
		],

		Warning["Distinct message heads with the same string are not identical:",
			RunTest[
				Warning["A message warning",
					Message[UnitTest`Private`A::Message],
					Null,
					Messages:>{UnitTest`Private`B::Message}
				]
			][Outcome],
			"MessageFailure"
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*Example*)


DefineTests[
	Example,
	{
		Test["Description set in output rules:",
			Example[{Basic,"TestDescription"},4+4,8][Description],
			"TestDescription"
		],

		Test["Defered expression set in output rules:",
			Example[{Basic,"TestDescription"},4+4,8][Expression],
			Defer[4+4]
		],

		Test["Category set in output rules:",
			Example[{Basic,"TestDescription"},4+4,8][Category],
			Basic
		],

		Test["If no subcategory in input, SubCategory->Null in output rules:",
			Example[{Basic,"TestDescription"},4+4,8]["SubCategory"],
			Null
		],

		Test["If subcategory in input, SubCategory is set in output rules:",
			Example[{Messages,"TestMessage","TestDescription"},4+4,8]["SubCategory"],
			"TestMessage"
		],

		Test["Passes on all options to Test:",
			Example[
				{Basic,"Description:"},
				4+4,
				8,
				Variables:>{thing},
				SetUp:>(thing=4),
				TearDown:>(thing=5),
				Stubs:>{funch[x_Integer]:=10},
				TimeConstraint->2,
				EquivalenceFunction->Equal
			],
			TestP
		],

		Test["Returns an ExampleP:",
			Example[{Basic,"Description:"},4+4,8],
			ExampleP
		],

		Example[{Basic,"Define an Example with a given Category:"},
			Example[{Basic,"4+4=8:"},4+4,8],
			ExampleP
		],

		Example[{Basic,"Define an Example with a given Category and SubCategory:"},
			Example[{Additional,"Symbolic Behaviour","Plus evaluates symbolically:"},Taco+Taco,2 Taco],
			ExampleP
		],
		Example[{Basic,"Define an Example with a given Category multiple SubCategories:"},
			Example[{Additional, {Plus, Times},"Plus evaluates symbolically:"},Taco+Taco,2 Taco],
			ExampleP
		],

		Example[{Basic,"Define an Example with a for a specific Message to be thrown:"},
			Example[{Messages,"infy","1/0 Throws error message:"},1/0,ComplexInfinity,Messages:>Power::infy],
			ExampleP
		],

		Example[{Attributes, HoldRest, "Arguments after the first are not evaluated:"},
			Example[2+2,Banana,7*7],
			Example[4,Banana,_Times]
		],
		Test["Indicate the StartDate and EndDate of a given Example:",
			test = RunTest[
				Example[{Basic, "A test"},
					True,
					True
				]
			];
			{
				test[StartDate],
				test[EndDate]
			},
			{
				_?DateObjectQ,
				_?DateObjectQ
			},
			Variables :> {test}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*DefineTests*)


With[{file="tests.m"},
	DefineTests[
		DefineTests,
		{
			Test["Adds element to collection for given symbol where Context key is the context of the symbol:",
				Block[{testCollection=<||>,symbolToTest},
					DefineTests[testCollection,symbolToTest,{}];

					testCollection[symbolToTest]["Package"]
				],
				"UnitTest`"
			],

			Test["Defines the messages to turn off before the test is run:",
				Block[{testCollection=<||>,symbolToTest},
					DefineTests[testCollection,symbolToTest,{},TurnOffMessages:>{General::stop}];

					testCollection[symbolToTest]["Options"]
				],
				{TurnOffMessages:>{General::stop}}
			],

			Test["Returns Null:",
				Block[{testCollection=<||>,symbolToTest},
					DefineTests[testCollection,symbolToTest,{}]
				],
				Null
			],

			Test["Adds element to collection for given symbol where Tests key is a Held version of the tests:",
				Block[{testCollection=<||>,symbolToTest},
					DefineTests[testCollection,symbolToTest,{
						Test["Description",4+4,8]
					}];

					testCollection[symbolToTest]["Tests"]
				],
				Hold[{Test["Description",4+4,8]}]
			],

			Test["Adds element to collection for given symbol where Options key is the options to for this group of tests:",
				Block[{testCollection=<||>,symbolToTest},
					DefineTests[
						testCollection,
						symbolToTest,
						{Test["Description",4+4,8]},
						SetUp:>10
					];

					testCollection[symbolToTest]["Options"]
				],
				{SetUp:>10}
			],

			Test["Adds element to collection for given string where Package key is the package the tests are defined in:",
				Block[{testCollection=<||>},
					DefineTests[testCollection,"testString",{}];

					testCollection["testString"]["Package"]
				],
				"UnitTest`"
			],

			Test["Adds element to collection for given string where File keyis the file the tests are defined in:",
				Block[{testCollection=<||>},
					DefineTests[testCollection,"testString",{}];

					testCollection["testString"][[2]]
				],
				_String
			],

			Test["Adds element to collection for given string where Tests key is a Held version of the tests:",
				Block[{testCollection=<||>},
					DefineTests[testCollection,"testString",{
						Test["Description",4+4,8]
					}];

					testCollection["testString"]["Tests"]
				],
				Hold[{Test["Description",4+4,8]}]
			],

			Test["Adds element to collection for given string where Options key is the options for this group of tests:",
				Block[{testCollection=<||>},
					DefineTests[
						testCollection,
						"testString",
						{Test["Description",4+4,8]},
						SetUp:>10
					];

					testCollection["testString"]["Options"]
				],
				{SetUp:>10}
			],

			Test["Adds element to symbolTests if collection not specified:",
				Block[{testCollection=<||>,symbolToTest,result},
					DefineTests[
						symbolToTest,
						{Test["Description",4+4,8]},
						SetUp:>10
					];

					result=symbolTests[symbolToTest];
					KeyDropFrom[symbolTests, symbolToTest];
					result
				],
				_Association?(And[
					MatchQ[#["Package"],"UnitTest`"],
					MatchQ[#["Options"],_List],
					MatchQ[#["Tests"],Hold[{Test["Description",4+4,8]}]],
					MatchQ[#["Platform"],{"Windows","MacOSX","Unix"}]
				]&)
			],

			Example[{Basic,"Define tests for a given string:"},
				With[{str="TestString"},
					DefineTests[str,
						{Test["2+2=4",2+2,4]}
					];
					Tests[str]
				],
				{TestP}
			],

			Example[{Basic,"Define tests for a given symbol:"},
				Block[{TestSymbol},
					DefineTests[TestSymbol,
						{Test["2+2=4",2+2,4]}
					];
					Tests[TestSymbol]
				],
				{TestP}
			],

			Example[{Messages,"Null","Throws a warning message if extra Nulls in the input list:"},
				Block[{TestSymbol},
					DefineTests[TestSymbol,
						{Test["2+2=4",2+2,4], Null}
					]
				],
				Null,
				Messages:>{
					DefineTests::Null
				}
			],

			Example[{Messages,"Times","Throws a warning message if extra Times appears in input list:"},
				Block[{TestSymbol},
					DefineTests[TestSymbol,
						(*Missing comma is intentional*)
						{
							Test["2+2=4",2+2,4]
							Test["2+2=5",2+2,5]
						}
					]
				],
				Null,
				Messages:>{
					DefineTests::Times
				}
			],

			Example[{Messages, "Stubs", "Throws a warning message if Stubs does not match the input pattern of a list:"},
				Block[{TestSymbol},
					DefineTests[TestSymbol,
						{Test["2+2=4",2+2,4]},
						Stubs :> ("taco")
					]
				],
				Null,
				Messages:>{
					DefineTests::Stubs
				}
			],

			Example[{Options,SetUp,"Specify an expression to be run before every Test:"},
				With[{str="TestString"},
					DefineTests[str,
						{Test["2+2=4",2+2,4]},
						SetUp:>Print["Before"]
					];
					TestOptions[str]
				],
				{SetUp:>Print["Before"]}
			],

			Example[{Options,Stubs,"Specify stubs to be used in every Test:"},
				With[{str="TestString"},
					DefineTests[str,
						{Test["Stubbing",Now, "cat"]},
						Stubs:>{Now = "cat"}
					];
					TestOptions[str]
				],
				{Stubs:>{Now = "cat"}}
			],

			Example[{Options,TearDown,"Specify an expression to be run after every Test:"},
				With[{str="TestString"},
					DefineTests[str,
						{Test["2+2=4",2+2,4]},
						TearDown:>Print["After"]
					];
					TestOptions[str]
				],
				{TearDown:>Print["After"]}
			],

			Example[{Options, SymbolSetUp, "Specify an expression to be run once before all tests:"},
				With[{str="TestString"},
					DefineTests[str,
						{Test["1+1", 1+1, 2]},
						SymbolSetUp :> Print["Before all"]
					];
					TestOptions[str]
				],
				{SymbolSetUp :> Print["Before all"]}
			],

			Example[{Options, SymbolTearDown, "Specify an expression to be run once after all tests:"},
				With[{str="TestString"},
					DefineTests[str,
						{Test["1+1", 1+1, 2]},
						SymbolTearDown :> Print["After all"]
					];
					TestOptions[str]
				],
				{SymbolTearDown :> Print["After all"]}
			],

			Example[{Options,Variables,"Specify common symbols to be used throughout all Tests:"},
				With[{str="TestString"},
					DefineTests[str,
						{Test["2+2=4",2+2,4]},
						Variables:>{name}
					];
					TestOptions[str]
				],
				{Variables:>{name}}
			],

			Example[{Options,Variables,"Specify common stubs to be used throughout all Tests:"},
				With[{str="TestString"},
					DefineTests[str,
						{Test["2+2=4",2+2,4]},
						Stubs:>{Plus[2,2]=10}
					];
					TestOptions[str]
				],
				{Stubs:>{Plus[2,2]=10}}
			],

			Example[{Options,Platform,"Flag a symbol as having tests which only run on Windows:"},
				With[{str="TestString"},
					DefineTests[str,
						{Test["2+2=4",2+2,4]},
						Platform->{"Windows"}
					];
					symbolTests[str]["Platform"]
				],
				{"Windows"}
			],

			Example[{Options,Skip,"Flag a symbol to have its tests skipped with a description of why:"},
				With[{str="TestString"},
					DefineTests[str,
						{Test["2+2=4",2+2,4]},
						Skip->"Deprecated"
					];
					symbolTests[str]["Skip"]
				],
				"Deprecated"
			],

			Example[{Attributes, HoldAll, "Arguments are not evaluated:"},
				DefineTests[2+2,Banana,7*7],
				DefineTests[_Plus,Banana,_Times]
			]
		},
		Stubs:>{
			currentFile[]:=file,
			DirectoryPackage[___]:="UnitTest`"
		}
	]
];


(* ::Subsubsection::Closed:: *)
(*UnitTestedItems*)


DefineTests[
	UnitTestedItems,
	{
		Example[{Basic,"Get all items which have unit tests:"},
			UnitTestedItems[],
			{(_Symbol|_String|ECL`Object[__Symbol])..}
		],

		(* NOTE: We can't run this test on Manifold since we're running off of a distro. *)
		Example[{Basic,"Get all items which have unit tests defined in a specific file:"},
			If[FileExistsQ[FileNameJoin[{PackageDirectory["UnitTest`"], "tests", "UnitTest.m"}]],
				UnitTestedItems[FileNameJoin[{PackageDirectory["UnitTest`"],"tests","UnitTest.m"}]],
				{True}
			],
			{(_Symbol|_String)..}
		],

		Example[{Basic,"Get all items which have unit tests defined in a specific Context:"},
			UnitTestedItems["UnitTest`"],
			{(_Symbol|_String)..}
		],

		Test["If input is a context, returns symbols with unit tests in child contexts as well:",
			Sort[DeleteDuplicates[Context/@UnitTestedItems["Constellation`",Output->Symbol]]],
			{OrderlessPatternSequence["Constellation`Private`", "ECL`"]}
		],

		Example[{Applications,"Find all private Symbols which have unit tests:"},
			Select[UnitTestedItems[Output->Symbol], StringMatchQ[ToString[#], ___ ~~ "`Private`" ~~ ___] &],
			{__Symbol}
		],

		Example[{Options,Output,"Find all unit tests defined for strings:"},
			UnitTestedItems[Output->String],
			{___String}
		],

		Example[{Options,Output,"Find all unit tests defined for symbols:"},
			UnitTestedItems[Output->Symbol],
			{___Symbol}
		],

		Example[{Options,Output,"Find all unit tests defined for strings or symbols or types:"},
			UnitTestedItems[Output->All],
			{(_Symbol|_String|ECL`Object[__Symbol])..}
		],

		Example[{Options,Skipped,"True returns only skipped items:"},
			UnitTestedItems[Skipped->True],
			{RunUnitTest},
			Stubs:>{
				LoadTests[___]:=Null,
				symbolTests=Association[
					RunUnitTest->Association[
						"Package"->"UnitTest`",
						"File"->"",
						"Tests"->{},
						"Platform"->{"Windows","MacOSX","Unix"},
						"Skip"->"Some Reason",
						"Options"->{}
					],
					"SomeString"->Association[
						"Package"->"UnitTest`",
						"File"->"",
						"Tests"->{},
						"Platform"->{"Windows","MacOSX","Unix"},
						"Skip"->False,
						"Options"->{}
					]
				]
			}
		],

		Example[{Options,Skipped,"False returns only non-skipped items:"},
			UnitTestedItems[Skipped->False],
			{"SomeString"},
			Stubs:>{
				LoadTests[___]:=Null,
				symbolTests=Association[
					RunUnitTest->Association[
						"Package"->"UnitTest`",
						"File"->"",
						"Tests"->{},
						"Platform"->{"Windows","MacOSX","Unix"},
						"Skip"->"Some Reason",
						"Options"->{}
					],
					"SomeString"->Association[
						"Package"->"UnitTest`",
						"File"->"",
						"Tests"->{},
						"Platform"->{"Windows","MacOSX","Unix"},
						"Skip"->False,
						"Options"->{}
					]
				]
			}
		],

		Example[{Options,Skipped,"All returns skipped and non-skipped items:"},
			UnitTestedItems[Skipped->All],
			{RunUnitTest,"SomeString"},
			Stubs:>{
				LoadTests[___]:=Null,
				symbolTests=Association[
					RunUnitTest->Association[
						"Package"->"UnitTest`",
						"File"->"",
						"Tests"->{},
						"Platform"->{"Windows","MacOSX","Unix"},
						"Skip"->"Some Reason",
						"Options"->{}
					],
					"SomeString"->Association[
						"Package"->"UnitTest`",
						"File"->"",
						"Tests"->{},
						"Platform"->{"Windows","MacOSX","Unix"},
						"Skip"->False,
						"Options"->{}
					]
				]
			}
		],

		Example[{Options,Platform,"Return items which can run on the specified platform(s):"},
			UnitTestedItems[Platform->{"Windows"}],
			{"SomeString"},
			Stubs:>{
				LoadTests[___]:=Null,
				symbolTests=Association[
					RunUnitTest->Association[
						"Package"->"UnitTest`",
						"File"->"",
						"Tests"->{},
						"Platform"->{"MaxOSX","Unix"},
						"Skip"->False,
						"Options"->{}
					],
					"SomeString"->Association[
						"Package"->"UnitTest`",
						"File"->"",
						"Tests"->{},
						"Platform"->{"Windows","MaxOSX","Unix"},
						"Skip"->False,
						"Options"->{}
					]
				]
			}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*RunUnitTest*)


With[{file=$InputFileName},
	DefineTests[
		RunUnitTest,
		{
			Example[{Basic,"For a symbol with tests, returns result summary information:"},
				RunUnitTest[symbolWithPassingTests],
				_EmeraldTestSummary?(
					And[
						#[TestsFor]===symbolWithPassingTests,
						#[Passed],
						Length[#[Successes]]===2,
						Length[#[ResultFailures]]===0,
						Length[#[MessageFailures]]===0,
						Length[#[TimeoutFailures]]===0,
						QuantityUnit[#[RunTime]]==="Seconds",
						QuantityUnit[#[SuccessRate]]==="Percent",
						QuantityMagnitude[#[SuccessRate]]==100
					]&
				)
			],

			Example[{Basic,"TurnOffMessages defines the messages to turn off before running the SymbolSetUp (these messages will be turned back on after the SymbolTearDown):"},
				RunUnitTest[symbolWithMessagesToTurnOff],
				_EmeraldTestSummary?(
					And[
						#[TestsFor]===symbolWithMessagesToTurnOff,
						#[Passed]
					]&
				)
			],

			Test["For a symbol without tests, returns empty result summary information:",
				RunUnitTest[symbolWithoutTests],
				_EmeraldTestSummary?(
					And[
						#[TestsFor]===symbolWithoutTests,
						#[Passed],
						Length[#[Successes]]===0,
						Length[#[ResultFailures]]===0,
						Length[#[MessageFailures]]===0,
						Length[#[TimeoutFailures]]===0,
						QuantityUnit[#[RunTime]]==="Seconds",
						QuantityUnit[#[SuccessRate]]==="Percent",
						QuantityMagnitude[#[SuccessRate]]==0
					]&
				)
			],

			Test["For a symbol with failing tests, results in each of ResultFailures and Successes:",
				RunUnitTest[symbolWithFailingTests,Verbose->False],
				_EmeraldTestSummary?(
					And[
						#[TestsFor]===symbolWithFailingTests,
						Not[#[Passed]],
						Length[#[Successes]]===1,
						Length[#[ResultFailures]]===1,
						Length[#[MessageFailures]]===0,
						Length[#[TimeoutFailures]]===0,
						QuantityUnit[#[RunTime]]==="Seconds",
						QuantityUnit[#[SuccessRate]]==="Percent",
						QuantityMagnitude[#[SuccessRate]]==50
					]&
				)
			],

			Example[{Basic,"For a list of symbols, returns an association of symbols to result summaries:"},
				KeySort[RunUnitTest[{symbolWithPassingTests,symbolWithFailingTests}]],
				_Association?(
					And[
						MatchQ[#[symbolWithPassingTests],_EmeraldTestSummary],
						MatchQ[#[symbolWithFailingTests],_EmeraldTestSummary]
					]&
				)
			],

			Example[{Basic,"For a context, runs the unit tests for all symbols in that context and returns an association of their result summaries:"},
				RunUnitTest["Usage`"],
				_Association?(
					And[
						MatchQ[Keys[#],{(_Symbol|_String)..}],
						MatchQ[Values[#],{___EmeraldTestSummary}]
					]&
				)
			],

			Test["Returns an empty association if the context cannot be found:",
				RunUnitTest["ThisDoesNotExist`"],
				Association[]
			],

			Test["For a list of contexts, runs the unit tests for all symbols in each context and returns their result summaries:",
				RunUnitTest[{"UsageTests`","Options`"}],
				_Association?(
					And[
						MatchQ[#["UsageTests`"],_Association],
						MatchQ[#["Options`"],_Association]
					]&
				)
			],

			Test["For a list of contexts, returns and empty association for any context which cannot be found:",
				RunUnitTest[{"UsageTests`","ThisIsNotAContext`"}],
				_Association?(
					And[
						MatchQ[#["UsageTests`"],_Association],
						MatchQ[#["ThisIsNotAContext`"],Association[]]
					]&
				)
			],

			Example[{Additional,"Run a list of arbitrary tests under a given heading:"},
				RunUnitTest[Association["MySpecialTests"->{Test["1+1",1+1,2],Test["2-3",2-3,-1]}]],
				_Association?(
					MatchQ[#["MySpecialTests"],_EmeraldTestSummary]&
				)
			],

			Test["Run a list of arbitrary tests under a given expression heading:",
				RunUnitTest[Association[Example->{Test["1+1",1+1,2],Test["2-3",2-3,-1]}]],
				_Association?(
					MatchQ[#[Example],_EmeraldTestSummary]&
				)
			],

			Test["Run unit tests which use SetUp (instead of SymbolSetUp):",
				Module[
					{myCounter},
					DefineTests["testString", {
							Test["Test 1", myCounter+=1, 1],
							Test["Test 2", myCounter+=1, 1],
							Example[{Basic, "Example 3"}, myCounter+=1, 1]
						},
						SetUp :> (myCounter = 0)
					];
					RunUnitTest["testString", Verbose->False]
				],
				_EmeraldTestSummary?(And[
					#[MessageFailures]==={},
					#[ResultFailures]==={},
					#[TimeoutFailures]==={}
				]&)
			],

			Test["Run unit tests which use SymbolSetUp:",
				Module[
					{myCounter},
					DefineTests["testString", {
							Test["Test 1", myCounter+=1, 2],
							Test["Test 2", myCounter+=1, 3],
							Example[{Basic, "Example 3"}, myCounter+=1, 1]
						},
						SymbolSetUp :> (myCounter = 0)
					];
					RunUnitTest["testString", Verbose->False]
				],
				_EmeraldTestSummary?(And[
					#[MessageFailures]==={},
					#[ResultFailures]==={},
					#[TimeoutFailures]==={}
				]&)
			],

			Test["Run unit tests which use TearDown (instead of SymbolTearDown):",
				Module[
					{myCounter, result},

					myCounter = 0;
					DefineTests["testString", {
							Test["Test 1", 1+1, 2],
							Example[{Basic, "Example 2"}, 3+3, 6]
						},
						TearDown :> (myCounter+=1)
					];
					result = RunUnitTest["testString", Verbose->False];
					{myCounter, result}
				],
				{2, _EmeraldTestSummary?(And[
					#[MessageFailures]==={},
					#[ResultFailures]==={},
					#[TimeoutFailures]==={}
				]&)}
			],

			Test["Run unit tests which use SymbolTearDown:",
				Module[
					{myCounter, result},

					myCounter = 0;
					DefineTests["testString", {
							Test["Test 1", 1+1, 2],
							Test["Test 2", 2+2, 4],
							Example[{Basic, "Example 3"}, 3+3, 6]
						},
						SymbolTearDown :> (myCounter+=1)
					];
					result = RunUnitTest["testString", Verbose->False];
					{myCounter, result}
				],
				{1, _EmeraldTestSummary?(And[
					#[MessageFailures]==={},
					#[ResultFailures]==={},
					#[TimeoutFailures]==={}
				]&)}
			],

			Example[{Options,Association,"Association->False when given an Association as input, returns only the summaries in a list:"},
				RunUnitTest[
					Association[Example->{Test["1+1",1+1,2],Test["2-3",2-3,-1]}],
					Association->False
				],
				{_EmeraldTestSummary}
			],
			Example[{Options,TestsToRun,"Only run tests which are Sandbox-enabled:"},
				RunUnitTest[
					Association[Example->{Test["1+1",1+1,2, Sandbox->True],Test["2-3",2-3,-1]}],
					Association->False,
					TestsToRun->Sandbox
				],
				{_EmeraldTestSummary?(#[TotalTests]===1&)}
			],
			Example[{Options,OutputFormat,"OutputFormat->SingleBoolean when given an Association as input, returns a single True/False:"},
				RunUnitTest[
					Association[Example->{Test["1+1",1+1,2],Test["2-3",2-3,-1]},data[NMR]->{Test["1+1",1+1,2]}],
					OutputFormat->SingleBoolean
				],
				True
			],

			Example[{Options,OutputFormat,"OutputFormat->Boolean when given an Association as input, returns pass/fail as the value instead of the test summary:"},
				RunUnitTest[
					Association[Example->{Test["1+1",1+1,2],Test["2-3",2-3,-1]}],
					OutputFormat->Boolean
				],
				_Association?(
					MatchQ[#[Example],True]&
				)
			],

			Example[{Options,Association,"Association->False when given a list of symbols, returns only the summaries in a list:"},
				RunUnitTest[
					{DefineUsage,LookupUsage},
					Association->False
				],
				{_EmeraldTestSummary,_EmeraldTestSummary}
			],

			Example[{Options,OutputFormat,"OutputFormat->Boolean when given a list of symbols, returns the pass/fail results instead of the summaries:"},
				RunUnitTest[
					{DefineUsage,LookupUsage},
					OutputFormat->Boolean
				],
				_Association?(And[
					MatchQ[#[DefineUsage],True|False],
					MatchQ[#[LookupUsage],True|False],
					Length[#]==2
				]&)
			],

			Example[{Options,OutputFormat,"OutputFormat->SingleBoolean when given a list of symbols, returns a single pass/fail result:"},
				RunUnitTest[
					{DefineUsage,LookupUsage},
					OutputFormat->SingleBoolean
				],
				True|False
			],

			Example[{Options,OutputFormat,"OutputFormat->Boolean when given a single symbol, returns a single pass/fail result:"},
				RunUnitTest[
					DefineUsage,
					OutputFormat->Boolean
				],
				True|False
			],

			Example[{Options,OutputFormat,"OutputFormat->SingleBoolean when given a single symbol, returns a single pass/fail result:"},
				RunUnitTest[
					DefineUsage,
					OutputFormat->SingleBoolean
				],
				True|False
			],

			Example[{Options,OutputFormat,"OutputFormat->Boolean when given a context, returns the pass/fail results instead of the summaries:"},
				RunUnitTest[
					"UsageTests`",
					OutputFormat->Boolean
				],
				_Association?(MatchQ[Values[#],{(True|False)...}]&)
			],

			Example[{Options,OutputFormat,"OutputFormat->SingleBoolean when given a context, returns the pass/fail results instead of the summaries:"},
				RunUnitTest[
					"UsageTests`",
					OutputFormat->SingleBoolean
				],
				True|False
			],

			Example[{Additional,"If a FatalFailure is encountered, do not run any further tests:"},
				RunUnitTest[Association["MySpecialTests"->{Test["1+1",1+1,3,FatalFailure->True],Test["2-3",2-3,-1]}]],

				_Association?(
					And[
						MatchQ[Length[#["MySpecialTests"][Results]],1],
						MatchQ[Length[#["MySpecialTests"]["Tests"]],2]
					]&
				)
			],

			Test["Returns and empty association if the input file cannot be found:",
				RunUnitTest["ThisDoesNotExistAnywhere.m"],
				Association[]
			],

			Test["Returns an empty association for any file in the input list cannot be found:",
				RunUnitTest[{FileNameJoin[{"Usage","Usage.m"}],"ThisDoesNotExistAnywhere.m"}],
				_Association?(
					And[
						MatchQ[#["ThisDoesNotExistAnywhere.m"],Association[]],
						MatchQ[#[FileNameJoin[{"Usage","Usage.m"}]],_Association]
					]&
				)
			],

			Test["For a string with tests, returns result summary information:",
				RunUnitTest["testString"],
				_EmeraldTestSummary?(
					And[
						#[TestsFor]==="testString",
						#[Passed],
						Length[#[Successes]]===2,
						Length[#[ResultFailures]]===0,
						Length[#[MessageFailures]]===0,
						Length[#[TimeoutFailures]]===0,
						QuantityUnit[#[RunTime]]==="Seconds",
						QuantityUnit[#[SuccessRate]]==="Percent",
						QuantityMagnitude[#[SuccessRate]]==100
					]&
				)
			],

			Test["For a string without tests, returns empty result summary information:",
				RunUnitTest["thisHasNoTests"],
				_EmeraldTestSummary?(
					And[
						#[TestsFor]==="thisHasNoTests",
						#[Passed],
						Length[#[Successes]]===0,
						Length[#[ResultFailures]]===0,
						Length[#[MessageFailures]]===0,
						Length[#[TimeoutFailures]]===0,
						QuantityUnit[#[RunTime]]==="Seconds",
						QuantityUnit[#[SuccessRate]]==="Percent",
						QuantityMagnitude[#[SuccessRate]]==0
					]&
				)
			],

			Example[{Options,Category,"Run only the Tests for the given symbol:"},
				RunUnitTest[symbolWithPassingTests,Category->Tests],
				_EmeraldTestSummary?(
					And[
						#[TestsFor]===symbolWithPassingTests,
						Length[#[Successes]]===1,
						Length[#[ResultFailures]]===0,
						Length[#[MessageFailures]]===0,
						Length[#[TimeoutFailures]]===0,
						QuantityUnit[#[RunTime]]==="Seconds",
						QuantityUnit[#[SuccessRate]]==="Percent",
						QuantityMagnitude[#[SuccessRate]]==100
					]&
				)
			],

			Example[{Options,SubCategory,"Run only the Tests for the given symbol.  If there are multiple subcategories for a given test, do all tests that include the indicated subcategory:"},
				RunUnitTest[symbolWithSubCategory,SubCategory->Cat],
				_EmeraldTestSummary?(
					And[
						#[TestsFor]===symbolWithSubCategory,
						Length[#[Successes]]===2,
						Length[#[ResultFailures]]===0,
						Length[#[MessageFailures]]===0,
						Length[#[TimeoutFailures]]===0,
						QuantityUnit[#[RunTime]]==="Seconds",
						QuantityUnit[#[SuccessRate]]==="Percent",
						QuantityMagnitude[#[SuccessRate]]==100
					]&
				)
			],

			Example[{Options,Category,"Run only the Messages or Basic Examples for the given symbol:"},
				RunUnitTest[symbolWithPassingTests,Category->{Messages,Basic}],
				_EmeraldTestSummary?(
					And[
						#[TestsFor]===symbolWithPassingTests,
						Length[#[Successes]]===1,
						Length[#[ResultFailures]]===0,
						Length[#[MessageFailures]]===0,
						Length[#[TimeoutFailures]]===0,
						QuantityUnit[#[RunTime]]==="Seconds",
						QuantityUnit[#[SuccessRate]]==="Percent",
						QuantityMagnitude[#[SuccessRate]]==100
					]&
				)
			],

			Example[{Options,Exclude,"Exclude option filters out symbols to be run from given list of symbols (or strings):"},
				Sort[
					Keys[
						RunUnitTest[
							{Tests,DefineTests,"GradeP"},
							Exclude->{"GradeP"}
						]
					]
				],
				Sort[{Tests,DefineTests}]
			],

			Example[{Options,Verbose,"Verbose->True dynamically prints results of each Test as they are run:"},
				RunUnitTest[symbolWithFailingTests,Verbose->True],
				_EmeraldTestSummary
			],

			Example[{Options,Verbose,"Verbose->Failures & SummaryNotebook->True dynamically prints results of each Test as they are run, displaying output of failed tests only:"},
				RunUnitTest[symbolWithFailingTests,SummaryNotebook->True,Verbose->Failures],
				_EmeraldTestSummary
			],

			Example[{Options,Verbose,"Verbose->False does not print any output during Test runs:"},
				RunUnitTest[symbolWithFailingTests,Verbose->False],
				_EmeraldTestSummary
			],

			Example[{Options,SummaryNotebook,"SummaryNotebook->True (when Verbose->True|Failures) prints test results as they are run in a separate, formatted window:"},
				RunUnitTest[symbolWithFailingTests,Verbose->True,SummaryNotebook->True],
				_EmeraldTestSummary
			],

			Example[{Options,SummaryNotebook,"SummaryNotebook->False (when Verbose->True|Failures) prints a simple text display inline of tests as they are run:"},
				RunUnitTest[symbolWithFailingTests,Verbose->True,SummaryNotebook->False],
				_EmeraldTestSummary
			],

			Example[{Options,ShowExpression,"ShowExpression->False && SummaryNotebook->True hides Test expressions from result window display:"},
				RunUnitTest[symbolWithFailingTests,Verbose->True,SummaryNotebook->True,ShowExpression->False],
				_EmeraldTestSummary
			],

			Example[{Options,DisplayFunction,"Control how inputs are converted to strings for verbose printing:"},
				RunUnitTest[symbolWithFailingTests,Verbose->True,DisplayFunction->(Short[#,1]&)],
				_EmeraldTestSummary
			]
		},
		Variables:>{symbolWithPassingTests,symbolWithFailingTests,symbolWithoutTests,symbolWithMessagesToTurnOff},
		SetUp:>(
			Block[{currentFile},
				currentFile[]:=file;
				DefineTests[symbolWithPassingTests,
					{
						Test["4+4 is 8:",
							4+4,
							8
						],
						Example[{Basic,"4+10 is 14"},
							4+10,
							14
						]
					}
				];

				DefineTests[symbolWithSubCategory,
					{
						Example[{Additional,Cat,"4+10 is 14"},
							4+10,
							14
						],
						Example[{Additional,Dog,"4+10 is 14"},
							4+10,
							14
						],
						Example[{Additional, {Cat, Dog}, "4+10 is 14"},
							4+10,
							14
						]
					}
				];

				DefineTests[
					symbolWithFailingTests,
					{
						Test["4+4 is 10:",
							4+4,
							10
						],
						Example[{Basic,"4+10 is 14"},
							4+10,
							14
						]
					}
				];

				DefineTests[
					symbolWithMessagesToTurnOff,
					{
						Test["Divide by zero:",
							1/0,
							ComplexInfinity
						]
					},
					TurnOffMessages:>{Power::infy}
				];

				DefineTests[
					"testString",
					{
						Test["4+4 is 8:",
							4+4,
							8
						],
						Example[{Basic,"4+10 is 14"},
							4+10,
							14
						]
					}
				]
			];
		),
		TearDown:>(
			Quiet[Unset[symbolTests[symbolWithPassingTests]]];
			Quiet[Unset[symbolTests[symbolWithFailingTests]]];
			Quiet[Unset[symbolTests["testString"]]];
		),
		Stubs:>{
			getTestNotebook[]:=If[MatchQ[invisibleTestNotebook,_NotebookObject],
				invisibleTestNotebook=CreateNotebook[Visible->False],
				invisibleTestNotebook
			],
			NotebookWrite[___]:=Null,
			Print[___]:=Null,
			PrintTemporary[___]:=Null
		}
	]
];


(* ::Subsubsection::Closed:: *)
(*Tests*)


DefineTests[
	Tests,
	{
		Example[{Basic,"Returns empty list if no tests defined for symbol:"},
			Tests[symbolWithoutTests],
			{}
		],

		Example[{Basic,"Returns empty list if no tests defined for a given string:"},
			Tests["noTestsForThisString"],
			{}
		],

		Example[{Basic,"Returns list of Tests & Examples for given symbol if they are defined:"},
			Tests[symbolWithTests],
			{TestP,ExampleP}
		],

		Example[{Basic,"Returns list of Tests & Examples for given string if they are defined:"},
			Tests["testString"],
			{TestP,ExampleP}
		],

		Example[{Options,Output,"Returns only Tests for a given symbol:"},
			Tests[symbolWithTests,Output->Test],
			{TestP}
		],

		Example[{Options,Output,"Returns only Examples for a given symbol:"},
			Tests[symbolWithTests,Output->Example],
			{ExampleP}
		],

		Example[{Options,Output,"Returns original definition un-evaluated for given symbol, aftern option replacements:"},
			Tests[symbolWithInvalidDefinition,Output->Hold],
			Hold[{Test["",Taco,True,Sequence[]]}]
		],

		Test["Adds empty description for tests with only 1 input:",
			With[{test=First[Tests[symbolWithOneInputTests,Output->Test]]},
				test[Description]
			],
			""
		],

		Test["Adds expected output of True for tests with only 1 input:",
			With[{test=First[Tests[symbolWithOneInputTests,Output->Test]]},
				(RunTest[test])[ExpectedValue]
			],
			HoldForm[True]
		],

		Test["Adds empty description for tests with only 2 inputs (no description):",
			With[{test=First[Tests[symbolWithTwoInputTests,Output->Test]]},
				test[Description]
			],
			""
		],

		Test["Expected output unchanged for tests with only 2 inputs (no description):",
			With[{test=First[Tests[symbolWithTwoInputTests,Output->Test]]},
				(RunTest[test])[ExpectedValue]
			],
			HoldForm[4]
		],

		Test["Adds expected output True for tests with only 2 inputs, no expected value:",
			With[{test=First[Tests[symbolWithTwoInputAndDescriptionTests,Output->Test]]},
				(RunTest[test])[ExpectedValue]
			],
			HoldForm[True]
		],

		Test["Defaults Output option if specified incorrectly:",
			Tests[symbolWithTwoInputAndDescriptionTests,Output->Duck],
			{(TestP|ExampleP)..},
			Messages:>Warning::OptionPattern
		],

		Test["Global stubs are combined with local Test stubs:",
			#[Passed]& /@ RunTest[Tests[symbolWithStubs,Output->Test]],
			{True,True,True}
		],

		Test["Global stubs are combined with local Example stubs:",
			#[Passed]& /@ RunTest[Tests[symbolWithStubs,Output->Example]],
			{True,True,True}
		]
	},
	Stubs:>{
		symbolTests=Association[
			symbolWithTests->Association[
				"Tests"->Hold[{Test["Description:",4+4,8],Example[{Basic,"Example:"},5+5,10]}],
				"Options"->{}
			],
			"testString"->Association[
				"Tests"->Hold[{Test["Description:",4+4,8],Example[{Basic,"Example:"},5+5,10]}],
				"Options"->{}
			],
			symbolWithInvalidDefinition->Association[
				"Tests"->Hold[{Test[Taco]}],
				"Options"->{}
			],
			symbolWithStubs->Association[
				"Tests"->Hold[{
					Test["Overriden",g[10],20,Stubs:>{g[x_]:=2*x}],
					Test["Uses Global",g[10],10,Stubs:>{f[10]=12}],
					Test["Uses Local",f[10],12,Stubs:>{f[10]=12}],
					Example[{Basic,"Overriden"},g[10],20,Stubs:>{g[x_]:=2*x}],
					Example[{Basic,"Uses Global"},g[10],10,Stubs:>{f[10]=12}],
					Example[{Basic,"Uses Local"},f[10],12,Stubs:>{f[10]=12}]
				}],
				"Options"->{Stubs:>{g[x_]:=x}}
			],
			symbolWithOneInputTests->Association[
				"Tests"->Hold[{Test[2+2==4]}],
				"Options"->{}
			],
			symbolWithTwoInputTests->Association[
				"Tests"->Hold[{Test[2+2,4]}],
				"Options"->{}
			],
			symbolWithTwoInputAndDescriptionTests->Association[
				"Tests"->Hold[{Test["description",2+2==4]}],
				"Options"->{}
			]
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*TestFile*)


DefineTests[
	TestFile,
	{
		Example[{Basic,"Returns the file path in which the unit tests for a given symbol are defined:"},
			TestFile[Tests],
			"/tests/Tests.m"
		],

		Example[{Basic,"Returns $Failed if there are no tests defined for a given symbol:"},
			TestFile[thisDoesNotExist],
			$Failed
		],

		Example[{Basic,"Returns the file path in which the unit tests for a given string are defined:"},
			TestFile["StringTests"],
			"/tests/StringTests.m"
		],

		Example[{Basic,"Returns $Failed if there are no tests defined for a given string:"},
			TestFile["thisStringHasNoTests"],
			$Failed
		],

		Example[{Applications, "Open the file in which the unit tests for a symbol are defined:"},
			NotebookOpen[TestFile[Tests]],
			_NotebookObject,
			Stubs:>{
				NotebookOpen[_String]:=NotebookObject[1]
			}
		]
	},
	Stubs:>{
		symbolTests=Association[
			Tests->Association[
				"File"->"/tests/Tests.m"
			],
			"StringTests"->Association[
				"File"->"/tests/StringTests.m"
			]
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*TestInformation*)


DefineTests[
	TestInformation,
	{
		Example[{Basic,"Returns an Association with all information about the tests for a given symbol:"},
			TestInformation[TestFile],
			_Association
		],
		Example[{Basic,"Returns an Association with all information about the tests for a given string:"},
			TestInformation["StringTests"],
			_Association,
			Stubs:>{
				symbolTests=Association[
					"StringTests"->Association[
						"Tests"->Hold[{}],
						"Options"->{},
						"File"->"/File/Path.m"
					]
				]
			}
		],
		Example[{Basic,"Returns $Failed if the symbol doesn't exist:"},
			TestInformation[NotARealThing],
			$Failed
		]
	}
];

DefineTests[
	TestOptions,
	{
		Example[{Basic,"Returns the list of Options defined with the tests of the given symbol:"},
			TestOptions[testSymbol],
			{(_Rule|_RuleDelayed)...,SetUp:>2+2,(_Rule|_RuleDelayed)...}
		],

		Example[{Basic,"Returns $Failed if there are no tests defined for a given symbol:"},
			TestOptions[thisDoesNotExist],
			$Failed
		],

		Example[{Basic,"Returns the list of Options defined with the tests of the given string:"},
			TestOptions["testString"],
			{(_Rule|_RuleDelayed)...,SetUp:>2+2,(_Rule|_RuleDelayed)...}
		],

		Example[{Basic,"Returns $Failed if there are no tests defined for a given string:"},
			TestOptions["thisDoesNotExist"],
			$Failed
		],

		Example[{Applications, "Execute the SetUp expression for a given symbol:"},
			SetUp /. TestOptions[testSymbol],
			4
		]
	},
	Stubs:>{
		symbolTests=Association[
			testSymbol->Association[
				"Options"->{SetUp:>2+2}
			],
			"testString"->Association[
				"Options"->{SetUp:>2+2}
			]
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*RunTest*)


DefineTests[
	RunTest,
	{
		Example[{Basic,"Execute a Test:"},
			RunTest[Test["1+1=2",1+1,2]],
			TestResultP
		],

		Example[{Basic,"Execute an Example:"},
			RunTest[Example[{Basic,"1+1=2"},1+1,2]],
			TestResultP
		],

		Example[{Applications,"Execute a specific test from the list of tests for a symbol:"},
			RunTest[Tests[RunUnitTest][[3]]],
			TestResultP
		]
	}
];


(* ::Subsection::Closed:: *)
(*Summary Boxes*)


(* ::Subsubsection::Closed:: *)
(*EmeraldTestSummary*)


DefineTests[
	EmeraldTestSummary,
	{
		Example[{Basic,"RunUnitTest returns an EmeraldTestSummary:"},
			RunUnitTest[Test,Verbose->False],
			_EmeraldTestSummary
		],

		Example[{Basic,"Extract the Pass/Fail boolean for an EmeraldTestSummary:"},
			RunUnitTest[Test,Verbose->False][Passed],
			True
		],

		Example[{Basic,"Extract multiple properties from an EmeraldTestSummary:"},
			RunUnitTest[Test,Verbose->False][{TestsFor,Passed}],
			{Test,True}
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*EmeraldTestResult*)


DefineTests[
	EmeraldTestResult,
	{
		Example[{Basic,"RunTest returns an EmeraldTestResult:"},
			RunTest[Test["1+1=2",1+1,2]],
			_EmeraldTestResult
		],

		Example[{Basic,"Extract the Actual Value from an EmeraldTestResult:"},
			RunTest[Test["1+1=2",1+1,2]][ActualValue],
			Defer[2]
		],

		Example[{Basic,"Extract multiple properties from an EmeraldTestResult:"},
			RunTest[Test["1+1=2",1+1,2]][{ActualValue,ExpectedValue}],
			{Defer[2],HoldForm[2]}
		]
	}
];



(* ::Subsubsection::Closed:: *)
(*EmeraldTestResult*)


DefineTests[
	EmeraldTest,
	{
		Example[{Basic,"Test returns an EmeraldTest:"},
			Test["1+1=2",1+1,2],
			_EmeraldTest
		],

		Example[{Basic,"Extract the Description from an EmeraldTest:"},
			Test["1+1=2",1+1,2][Description],
			"1+1=2"
		],

		Example[{Basic,"Extract multiple properties from an EmeraldTest:"},
			Test["1+1=2",1+1,2][{Expression,ExpectedValue}],
			{Defer[1+1],2}
		]
	}
];

DefineTests[
	TestSummaryNotebook,
	{
		Example[{Basic, "Test Summary Notebook takes an EmeraldTestSummary and displays it:"},
			notebook=TestSummaryNotebook[summary],
			_NotebookObject,
			Variables:>{notebook},
			TearDown:>NotebookClose[notebook]
		],

		Example[{Basic, "Test Summary Notebook shows the number of successes in an EmeraldTestSummary:"},
			notebook=TestSummaryNotebook[summary];
			Cases[
				NotebookGet[notebook],
				box:_TemplateBox :> box[[1, {1, 2}, 1]],
				{0, Infinity},
				2
			],
			{{"\"Total Tests: \"", "2"}, {"\"Successes: \"", "2"}},
			Variables:>{notebook},
			TearDown:>NotebookClose[notebook]
		],

		Example[{Basic, "Test Summary Notebook shows the categories of the tests in an EmeraldTestSummary:"},
			notebook=TestSummaryNotebook[summary];
			Cases[
				NotebookGet[notebook],
				Cell[category:_, "TestCategory", ___] :> category,
				{0, Infinity}
			],
			{"Basic"},
			Variables:>{notebook},
			TearDown:>NotebookClose[notebook]
		]
	},
	Stubs:>{
		summary=EmeraldTestSummary[Association[
			Rule[TestsFor,EmeraldTestResult],
			Rule[Passed,True],
			Rule[Successes, List[
				EmeraldTestResult[Association[
					Description -> "Extract properties from EmeraldTestResult:",
					Rule[Category,Basic],
					Rule[SubCategory,Null],
					Rule[Expression,HoldForm[
						RunTest[
							Test["1+1=2",Plus[1,1],2]
						][List[ActualValue,ExpectedValue]]
					]],
					Rule[ActualValue,Defer[List[Defer[2],2]]],
					Rule[Passed,True],
					Rule[ExpectedValue,HoldForm[List[Defer[2],2]]],
					Rule[ExpectedMessages,List[]],
					Rule[ActualMessages,List[]],
					Rule[TimeConstraint,60],
					Rule[ExecutionTime,0.000883`],
					Rule[EquivalenceFunction,MatchQ],
					Rule[Outcome,"Success"],
					Rule[Sandbox, False]
				]],
				EmeraldTestResult[Association[
					Description -> "Extract the Actual Value from EmeraldTestResult:",
					Rule[Category,Basic],
					Rule[SubCategory,Null],
					Rule[Expression,HoldForm[
						RunTest[
							Test["1+1=2",Plus[1,1],2]
						][ActualValue]
					]],
					Rule[ActualValue,Defer[Defer[2]]],
					Rule[Passed,True],
					Rule[ExpectedValue,HoldForm[Defer[2]]],
					Rule[ExpectedMessages,List[]],
					Rule[ActualMessages,List[]],
					Rule[TimeConstraint,60],
					Rule[ExecutionTime,0.000566`],
					Rule[EquivalenceFunction,MatchQ],
					Rule[Outcome,"Success"],
					Rule[Sandbox, False]
				]]
			]],
			Rule[ResultFailures,List[]],
			Rule[TimeoutFailures,List[]],
			Rule[MessageFailures,List[]],
			Rule[Results, List[
				EmeraldTestResult[Association[
					Description -> "Extract properties from EmeraldTestResult:",
					Rule[Category,Basic],
					Rule[SubCategory,Null],
					Rule[Expression,HoldForm[
						RunTest[
							Test["1+1=2",Plus[1,1],2]
						][List[ActualValue,ExpectedValue]]
					]],
					Rule[ActualValue,Defer[List[Defer[2],2]]],
					Rule[Passed,True],
					Rule[ExpectedValue,HoldForm[List[Defer[2],2]]],
					Rule[ExpectedMessages,List[]],
					Rule[ActualMessages,List[]],
					Rule[TimeConstraint,60],
					Rule[ExecutionTime,0.000883`],
					Rule[EquivalenceFunction,MatchQ],
					Rule[Outcome,"Success"],
					Rule[Sandbox, False]
				]],
				EmeraldTestResult[Association[
					Description -> "Extract the Actual Value from EmeraldTestResult:",
					Rule[Category,Basic],
					Rule[SubCategory,Null],
					Rule[Expression,HoldForm[
						RunTest[
							Test["1+1=2",Plus[1,1],2]
						][ActualValue]
					]],
					Rule[ActualValue,Defer[Defer[2]]],
					Rule[Passed,True],
					Rule[ExpectedValue,HoldForm[Defer[2]]],
					Rule[ExpectedMessages,List[]],
					Rule[ActualMessages,List[]],
					Rule[TimeConstraint,60],
					Rule[ExecutionTime,0.000566`],
					Rule[EquivalenceFunction,MatchQ],
					Rule[Outcome,"Success"],
					Rule[Sandbox, False]
				]]
			]],
			Rule[SuccessRate,Quantity[100.`,"Percent"]],
			Rule[Tests, List[
				EmeraldTest[Association[
					Description -> "Extract properties from EmeraldTestResult:",
					Rule[Function,Function[Print["Stub Function"]]],
					Rule[ExpectedValue,List[Defer[2],2]],
					Rule[Expression,Defer[
						RunTest[
							Test["1+1=2",Plus[1,1],2]
						][List[ActualValue,ExpectedValue]]
					]],
					Rule[Category,Basic],
					Rule[SubCategory,Null],
					Rule[FatalFailure,False],
					Rule[TimeConstraint,60],
					Rule[ID,"d6fed3cf-2bd1-463c-8fb4-7ba4a4061ff9"],
					Rule[Sandbox, False]
				]],
				EmeraldTest[Association[
					Description -> "Extract the Actual Value from EmeraldTestResult:",
					Rule[Function,Function[Print["Stub function"]]],
					Rule[ExpectedValue,HoldForm[Defer[2]]],
					Rule[Expression,Defer[
						RunTest[
							Test["1+1=2",Plus[1,1],2]
						][ActualValue]
					]],
					Rule[Category,Basic],
					Rule[SubCategory,Null],
					Rule[FatalFailure,False],
					Rule[TimeConstraint,60],
					Rule[ID,"282296e7-2a67-4a73-b740-df0b8904532c"],
					Rule[Sandbox, False]
				]]
			]],
			Rule[RunTime,Quantity[0.001989`,"Seconds"]]
		]]
	}
];

DefineTests[SymbolTestFile, {
	Example[{Basic, "Returns path to the file containing tests for a symbol:"},
		SymbolTestFile[Download],
		___ ~~ FileNameJoin[{"Constellation", "tests", "Download.m"}],
		EquivalenceFunction -> StringMatchQ
	],

	Example[{Basic, "Given a string, returns path to file containing tests for the equivalent symbol:"},
		SymbolTestFile["Download"],
		___ ~~ FileNameJoin[{"Constellation", "tests", "Download.m"}],
		EquivalenceFunction -> StringMatchQ
	],

	Example[{Basic, "Given a symbol that has no tests defined, returns $Failed:"},
		SymbolTestFile[NotASymbol],
		$Failed
	]
}];



(* ::Subsubsection::Closed:: *)
(*LoadTests*)


DefineTests[
	LoadTests,
	{
		Example[{Basic,"Load the tests for all loaded packages:"},
			LoadTests[],
			_Association
		],

		Example[{Basic,"Load the tests for a specific package:"},
			LoadTests["Constellation`"],
			Null
		],

		Example[{Basic,"Load the tests for a list of packages:"},
			LoadTests[{"Constellation`","GoLink`"}],
			_Association
		]
	}
];


(* ::Subsubsection::Closed:: *)
(*TestFailureNotebook*)


DefineTests[TestFailureNotebook,
	{
		Example[{Basic,"TestFailureNotebook takes an EmeraldTestSummary and displays it:"},
			notebook=TestFailureNotebook[summaryWithFailure],
			_NotebookObject,
			Variables:>{notebook},
			TearDown:>NotebookClose[notebook]
		],
		Example[{Basic,"TestFailureNotebook shows the number of failures in an EmeraldTestSummary:"},
			notebook=TestFailureNotebook[summaryWithFailure];
			Cases[
				NotebookGet[notebook],
				box:_TemplateBox :> box[[1, {1, 2}, 1]],
				{0, Infinity},
				2
			],
			{{"\"Total Tests: \"", "1"}, {"\"Result Failures: \"", "1"}},
			Variables:>{notebook},
			TearDown:>NotebookClose[notebook]
		],
		Example[{Basic,"If there is no failed test in in an EmeraldTestSummary, print a message:"},
			notebook=TestFailureNotebook[summaryWithoutFailure],
			Null,
			Variables:>{notebook},
			TearDown:>NotebookClose[notebook]
		]
	},
	Stubs:>{
		summaryWithFailure=EmeraldTestSummary[Association[
			Rule[TestsFor,EmeraldTestResult],
			Rule[Passed,False],
			Rule[Successes, List[
				EmeraldTestResult[Association[
					Description -> "Extract properties from EmeraldTestResult:",
					Rule[Category,Basic],
					Rule[SubCategory,Null],
					Rule[Expression,HoldForm[
						RunTest[
							Test["1+1=2",Plus[1,1],2]
						][List[ActualValue,ExpectedValue]]
					]],
					Rule[ActualValue,Defer[List[Defer[2],2]]],
					Rule[Passed,True],
					Rule[ExpectedValue,HoldForm[List[Defer[2],2]]],
					Rule[ExpectedMessages,List[]],
					Rule[ActualMessages,List[]],
					Rule[TimeConstraint,60],
					Rule[ExecutionTime,0.000883`],
					Rule[EquivalenceFunction,MatchQ],
					Rule[Outcome,"Success"]
				]]
			]],
			Rule[ResultFailures,List[
				EmeraldTestResult[Association[
					Description -> "Extract the Actual Value from EmeraldTestResult:",
					Rule[Category,Basic],
					Rule[SubCategory,Null],
					Rule[Expression,HoldForm[
						RunTest[
							Test["1+1=2",Plus[1,1],3]
						][ActualValue]
					]],
					Rule[ActualValue,Defer[Defer[2]]],
					Rule[Passed,False],
					Rule[ExpectedValue,HoldForm[Defer[3]]],
					Rule[ExpectedMessages,List[]],
					Rule[ActualMessages,List[]],
					Rule[TimeConstraint,60],
					Rule[ExecutionTime,0.000566`],
					Rule[EquivalenceFunction,MatchQ],
					Rule[Outcome,"ResultFailure"]
				]]
			]],
			Rule[TimeoutFailures,List[]],
			Rule[MessageFailures,List[]],
			Rule[WarningFailures,List[]],
			Rule[Results, List[
				EmeraldTestResult[Association[
					Description -> "Extract properties from EmeraldTestResult:",
					Rule[Category,Basic],
					Rule[SubCategory,Null],
					Rule[Expression,HoldForm[
						RunTest[
							Test["1+1=2",Plus[1,1],2]
						][List[ActualValue,ExpectedValue]]
					]],
					Rule[ActualValue,Defer[List[Defer[2],2]]],
					Rule[Passed,True],
					Rule[ExpectedValue,HoldForm[List[Defer[2],2]]],
					Rule[ExpectedMessages,List[]],
					Rule[ActualMessages,List[]],
					Rule[TimeConstraint,60],
					Rule[ExecutionTime,0.000883`],
					Rule[EquivalenceFunction,MatchQ],
					Rule[Outcome,"Success"]
				]],
				EmeraldTestResult[Association[
					Description -> "Extract the Actual Value from EmeraldTestResult:",
					Rule[Category,Basic],
					Rule[SubCategory,Null],
					Rule[Expression,HoldForm[
						RunTest[
							Test["1+1=2",Plus[1,1],2]
						][ActualValue]
					]],
					Rule[ActualValue,Defer[2]],
					Rule[Passed,False],
					Rule[ExpectedValue,HoldForm[3]],
					Rule[ExpectedMessages,List[]],
					Rule[ActualMessages,List[]],
					Rule[TimeConstraint,60],
					Rule[ExecutionTime,0.000022`],
					Rule[EquivalenceFunction,MatchQ],
					Rule[Warning,False],
					Rule[Outcome,"ResultFailure"]
				]]
			]],
			Rule[SuccessRate,Quantity[50.`,"Percent"]],
			Rule[Tests, List[
				EmeraldTest[Association[
					Description -> "Extract properties from EmeraldTestResult:",
					Rule[Function,Function[Print["Stub Function"]]],
					Rule[ExpectedValue,List[Defer[2],2]],
					Rule[Expression,Defer[
						RunTest[
							Test["1+1=2",Plus[1,1],2]
						][List[ActualValue,ExpectedValue]]
					]],
					Rule[Category,Basic],
					Rule[SubCategory,Null],
					Rule[FatalFailure,False],
					Rule[TimeConstraint,60],
					Rule[ID,"d6fed3cf-2bd1-463c-8fb4-7ba4a4061ff9"]
				]],
				EmeraldTest[Association[
					Description -> "Extract the Actual Value from EmeraldTestResult:",
					Rule[Function,Function[Print["Stub function"]]],
					Rule[ExpectedValue,HoldForm[Defer[3]]],
					Rule[Expression,Defer[
						RunTest[
							Test["1+1=2",Plus[1,1],3]
						][ActualValue]
					]],
					Rule[Category,Basic],
					Rule[SubCategory,Null],
					Rule[FatalFailure,False],
					Rule[TimeConstraint,60],
					Rule[ID,"282296e7-2a67-4a73-b740-df0b8904532c"]
				]]
			]],
			Rule[RunTime,Quantity[0.001989`,"Seconds"]],
			Rule[TotalTests,2]
		]],
		summaryWithoutFailure=EmeraldTestSummary[Association[
			Rule[TestsFor,EmeraldTestResult],
			Rule[Passed,True],
			Rule[Successes, List[
				EmeraldTestResult[Association[
					Description -> "Extract properties from EmeraldTestResult:",
					Rule[Category,Basic],
					Rule[SubCategory,Null],
					Rule[Expression,HoldForm[
						RunTest[
							Test["1+1=2",Plus[1,1],2]
						][List[ActualValue,ExpectedValue]]
					]],
					Rule[ActualValue,Defer[List[Defer[2],2]]],
					Rule[Passed,True],
					Rule[ExpectedValue,HoldForm[List[Defer[2],2]]],
					Rule[ExpectedMessages,List[]],
					Rule[ActualMessages,List[]],
					Rule[TimeConstraint,60],
					Rule[ExecutionTime,0.000883`],
					Rule[EquivalenceFunction,MatchQ],
					Rule[Outcome,"Success"]
				]]
			]],
			Rule[ResultFailures,List[]],
			Rule[TimeoutFailures,List[]],
			Rule[MessageFailures,List[]],
			Rule[WarningFailures,List[]],
			Rule[Results, List[
				EmeraldTestResult[Association[
					Description -> "Extract properties from EmeraldTestResult:",
					Rule[Category,Basic],
					Rule[SubCategory,Null],
					Rule[Expression,HoldForm[
						RunTest[
							Test["1+1=2",Plus[1,1],2]
						][List[ActualValue,ExpectedValue]]
					]],
					Rule[ActualValue,Defer[List[Defer[2],2]]],
					Rule[Passed,True],
					Rule[ExpectedValue,HoldForm[List[Defer[2],2]]],
					Rule[ExpectedMessages,List[]],
					Rule[ActualMessages,List[]],
					Rule[TimeConstraint,60],
					Rule[ExecutionTime,0.000883`],
					Rule[EquivalenceFunction,MatchQ],
					Rule[Outcome,"Success"]
				]]
			]],
			Rule[SuccessRate,Quantity[100.`,"Percent"]],
			Rule[Tests, List[
				EmeraldTest[Association[
					Description -> "Extract properties from EmeraldTestResult:",
					Rule[Function,Function[Print["Stub Function"]]],
					Rule[ExpectedValue,List[Defer[2],2]],
					Rule[Expression,Defer[
						RunTest[
							Test["1+1=2",Plus[1,1],2]
						][List[ActualValue,ExpectedValue]]
					]],
					Rule[Category,Basic],
					Rule[SubCategory,Null],
					Rule[FatalFailure,False],
					Rule[TimeConstraint,60],
					Rule[ID,"d6fed3cf-2bd1-463c-8fb4-7ba4a4061ff9"]
				]]
			]],
			Rule[RunTime,Quantity[0.001989`,"Seconds"]],
			Rule[TotalTests,1]
		]]
	}
];