(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section::Closed:: *)
(*Help Files*)


(* ::Subsection::Closed:: *)
(*Patterns*)


(* ::Subsubsection::Closed:: *)
(*ContextQ*)


(*Both ContextQ and ContextP should be in another package which UnitTest calls on.
This will be easier to do once all the unit tests for other packages are split into
their own contexts.*)


DefineUsage[ContextQ,
	{
		BasicDefinitions->{
			{"ContextQ[input]","True|False","returns True if 'input' is the form of a context string, False otherwise."}
		},
		Input:>{
			{"input",_,"Value to test."}
		},
		SeeAlso->{"Context","StringMatchQ"},
		Author->{"platform", "thomas"}
	}
];



(* ::Subsection::Closed:: *)
(*Test Packages & Defining Tests*)


(* ::Subsubsection::Closed:: *)
(*DefineTests*)


DefineUsage[DefineTests,
	{
		BasicDefinitions->{
			{"DefineTests[collection,symbol,tests]","Null","defines a set of 'tests' for a given 'symbol'. The information is stored in the given 'collection'."},
			{"DefineTests[collection,string,tests]","Null","defines a set of 'tests' for a given 'string'. The information is stored in the given 'collection'."},
			{"DefineTests[symbol,tests]","Null","defines a set of 'tests' for a given 'symbol'. The information is stored in the default collection."},
			{"DefineTests[string,tests]","Null","defines a set of 'tests' for a given 'string'. The information is stored in the default collection."}
		},
		MoreInformation->{
			"Stubs defined at the individual Test/Example level will take precedence over stubs defined at the DefineTests level."
		},
		Input:>{
			{"collection",_Symbol,"Symbol in which to store Tests/Examples."},
			{"symbol",_Symbol,"Symbol for which one is defining Tests/Examples."},
			{"string",_String,"String for which one is defining Tests/Examples."},
			{"tests",{(_Test|_Example)...},"A list of Tests/Examples."}
		},
		SeeAlso->{"Tests", "DefineUsage"},
		Author->{"platform", "thomas"},
		Tutorials->{}
	}
];


(* ::Subsection::Closed:: *)
(*Example*)


(* ::Subsubsection::Closed:: *)
(*Example*)


DefineUsage[Example,
	{
		BasicDefinitions->{
			{"Example[{category,description},expression,expectedValue]","example","returns an 'example' which contains an executable Test as well as description/categorization information for documentation generation."},
			{"Example[{category,subCategory,description},expression,expectedValue]","example","returns an 'example' which contains an executable Test as well as description/categorization information for documentation generation."}
		},
		Input:>{
			{"description",_String,"A description for what the expression is testing."},
			{"expression",_,"An expression to be evaluated, the return value of which will be compared to the 'expectedValue'."},
			{"expectedValue",_,"An expression to compare against the return value of 'expression'."},
			{"category",ExampleCategoryP,"Top level category to group this example under."},
			{"subCategory",_Symbol|_String,"Within an example category, further classification of this example."}
		},
		Output:>{
			{"example",ExampleP,"An EmeraldTest object with a Category == ExampleCategoryP."}
		},
		SeeAlso->{"Test","EmeraldTest","EmeraldTestResult","EmeraldTestSummary","Function","TestSummaryNotebook"},
		Author->{"platform", "thomas"},
		Tutorials->{}
	}
];


(* ::Subsection::Closed:: *)
(*Running Tests*)


(* ::Subsubsection::Closed:: *)
(*RunUnitTest*)


DefineUsage[RunUnitTest,
	{
		BasicDefinitions->{
			{"RunUnitTest[symbol]","summary","returns the test 'summary' from executing all unit tests for 'symbol'."},
			{"RunUnitTest[context]","summaries","returns an assocation of test 'summaries' for each symbol in 'context'."},
			{"RunUnitTest[fileName]","summaries","returns an association of test 'summaries' for each symbol whose tests are defined in 'fileName'."},
			{"RunUnitTest[symbols]","summaries","returns an association of test 'summaries' for each of the given 'symbols'."},
			{"RunUnitTest[contexts]","groupSummaries","returns an association of 'contexts' -> symbols in each context -> test summaries for each symbol in that context."},
			{"RunUnitTest[fileNames]","groupSummaries","returns an association of 'fileNames' -> symbols in each test file -> test summary for each symbol in that test file."},
			{"RunUnitTest[association]","summaries","returns an association of test 'summaries' for each of the keys given in 'association'."}
		},
		MoreInformation->{
			"Association & OutputFormat options are ignored in the overload for a list of contexts/files in order to consistently return nested Associations."
		},
		Input:>{
			{"symbol",_Symbol,"A Symbol."},
			{"symbols",{___Symbol},"A list of Symbols."},
			{"context",ContextP,"A Mathematica Context."},
			{"contexts",{ContextP...},"A list of Mathematica Contexts."},
			{"fileName",_String,"The name of a file containing unit test definitions."},
			{"fileNames",{___String},"A list of file names containing unit test definitions."},
			{"association",_Association,"An Association from _String -> {TestP...} to be explicitly run."}
		},
		Output:>{
			{"summary",_EmeraldTestSummary,"Test result summary."},
			{"summaries",_Association,"An association from symbols/strings to their Test result summaries."},
			{"groupSummaries",_Association,"An association of associations: from context/filename -> symbols/strings -> to their Test result summaries."}
		},
		SeeAlso->{"Tests","DefineTests","EmeraldTestSummary","EmeraldTest","EmeraldTestResult","Test","Example","TestSummaryNotebook","RunTest"},
		Author->{"platform", "thomas"},
		Tutorials->{}
	}
];


(* ::Subsection::Closed:: *)
(*Querying Tests*)


(* ::Subsubsection::Closed:: *)
(*UnitTestedItems*)


DefineUsage[UnitTestedItems,
	{
		BasicDefinitions->{
			{"UnitTestedItems[]","items","returns the list of all 'items' with associated unit tests."},
			{"UnitTestedItems[file]","items","returns the list of all 'items' with associated unit tests defined in the given 'file'."},
			{"UnitTestedItems[context]","items","returns the list of all 'items' with associated unit tests defined in the given 'context'."}
		},
		MoreInformation->{
			"If given a relative file path, will search for the given test file relative to the Tests folder."
		},
		Input:>{
			{"file",_String,"An .m file containing unit tests which have been loaded."},
			{"context",_String?ContextQ,"A valid Mathematica context."}
		},
		Output:>{
			{"items",{(_Symbol|_String)...},"A list of Mathematica symbols or strings with unit tests."}
		},
		SeeAlso->{"RunUnitTest", "Tests"},
		Author->{"platform", "thomas"},
		Tutorials->{}
	}
];


(* ::Subsubsection::Closed:: *)
(*Tests*)


DefineUsage[Tests,
	{
		BasicDefinitions->{
			{"Tests[symbol]","results","returns defined Tests and Examples for a given 'symbol'."},
			{"Tests[string]","results","returns defined Tests and Examples for a given 'string'."},
			{"Tests[symbol,Output->Hold]","heldDefinition","returns un-evaluated test definition a given 'symbol'."},
			{"Tests[string,Output->Hold]","heldDefinition","returns un-evaluated test for a given 'string'."}
		},
		MoreInformation->{"If there are no Tests or Examples defined for a given symbol, returns an empty list."},
		Input:>{
			{"symbol",_Symbol,"Symbol to lookup Tests/Examples for."},
			{"string",_String,"String to lookup Tests/Examples for."}
		},
		Output:>{
			{"results",{(TestP|_Example)...},"A list of Tests and Examples."},
			{"heldDefinition",Hold[_],"A held expression of whatever the tests/examples were originally defined as."}
		},
		SeeAlso->{"RunUnitTest", "Tests"},
		Author->{"platform", "thomas"},
		Tutorials->{}
	}
];



(* ::Subsubsection::Closed:: *)
(*TestFile*)


DefineUsage[TestFile,
	{
		BasicDefinitions->{
			{"TestFile[symbol]","filePath","returns the 'filePath' containing the definitions of unit tests for given 'symbol'."},
			{"TestFile[symbol]","$Failed","returns $Failed if no unitTests have been defined for the given 'symbol'."},
			{"TestFile[string]","filePath","returns the 'filePath' containing the definitions of unit tests for given 'string'."},
			{"TestFile[string]","$Failed","returns $Failed if no unitTests have been defined for the given 'string'."}
		},
		Input:>{
			{"symbol",_Symbol,"Symbol to lookup file path for."},
			{"string",_String,"String to lookup Test Options for."}
		},
		Output:>{
			{"filePath",_String?FileExistsQ,"A path to a file containing unit tests for 'symbol'."}
		},
		SeeAlso->{"Tests", "RunUnitTest"},
		Author->{"platform", "thomas"},
		Tutorials->{}
	}
];

(* ::Subsubsection::Closed:: *)
(*TestInformation*)


DefineUsage[TestInformation,
	{
		BasicDefinitions->{
			{"TestInformation[symbol]","association","returns an 'association' with information about the tests for given 'symbol'."},
			{"TestInformation[string]","association","returns an 'association' with information about the tests for given 'string'."}
		},
		MoreInformation->{
			"Keys: \"Tests\",\"Skip\",\"Platform\",\"File\",\"Options\",\"Context\""
		},
		Input:>{
			{"symbol",_Symbol,"Symbol to lookup test information for."},
			{"string",_String,"String to lookup test information for."}
		},
		Output:>{
			{"association",_Association,"An Association with information about the tests for the given symbol/string."}
		},
		SeeAlso->{"DefineTests","Tests","UnitTestedItems"},
		Author->{"platform", "thomas"},
		Tutorials->{}
	}
];


(* ::Subsubsection::Closed:: *)
(*TestOptions*)


DefineUsage[TestOptions,
	{
		BasicDefinitions->{
			{"TestOptions[symbol]","options","returns the 'options' for the group of tests defined with DefineTests['symbol']."},
			{"TestOptions[symbol]","$Failed","returns $Failed if no unitTests have been defined for the given 'symbol'."},
			{"TestOptions[string]","options","returns the 'options' for the group of tests defined with DefineTests['string']."},
			{"TestOptions[string]","$Failed","returns $Failed if no unitTests have been defined for the given 'string'."}
		},
		Input:>{
			{"symbol",_Symbol,"Symbol to lookup Test Options for."},
			{"string",_String,"String to lookup Test Options for."}
		},
		Output:>{
			{"options",{(_Rule|_RuleDelayed)...},"A list of Option rules for the unit tests of 'symbol'."}
		},
		SeeAlso->{"Tests","DefineTests"},
		Author->{"platform", "thomas"},
		Tutorials->{}
	}
];



(* ::Subsection::Closed:: *)
(*Summary Boxes*)


(* ::Subsubsection::Closed:: *)
(*EmeraldTestSummary*)


DefineUsage[EmeraldTestSummary,
	{
		BasicDefinitions->
			{
				{"EmeraldTestSummary[association]","summary","represents the results of executing a group of EmeraldTests."}
			},
		MoreInformation->{
			"Properties can be accessed via EmeraldTestSummary[...][\"Property\"]",
			"Multiple Properties can be accessed via EmeraldTestSummary[...][{\"Property1\",\"Property2\"}]",
			"Properties:",
			Grid[{
				{"Name","Description"},
				{"TestsFor", "The item this group of test results is related to."},
				{"Passed", "True if all tests were run and all tests passed."},
				{"SuccessRate", "Ratio of successful results to total tests."},
				{"RunTime", "Cumulative execution time of all tests for this run."},
				{"Tests", "A list of the individual tests which were to be run."},
				{"Results", "List of all the tests results for the tests which were run."},
				{"Successes", "List of test results which had a 'Success' outcome."},
				{"ResultFailures", "List of test results which had a 'ResultFailure' outcome."},
				{"TimeoutFailures", "List of test results which had a 'TimeoutFailure' outcome."},
				{"MessageFailures", "List of test results which had a 'MessageFailure' outcome."}
			}]
			},
		Input:>
			{
				{"association",_Association,"The association containing the data for the result summary."}
			},
		Output:>
			{
				{"summary",_EmeraldTestSummary,"An EmeraldTestSummary wrapper."}
			},
		Tutorials->{},
		Sync->Automatic,
		SeeAlso->
			{
				"Test",
				"Example",
				"RunUnitTest",
				"EmeraldTest",
				"EmeraldTestResult"
			},
		Author->{"platform", "thomas"}
	}
];


(* ::Subsubsection::Closed:: *)
(*TestSummaryNotebook*)


DefineUsage[TestSummaryNotebook,
	{
		BasicDefinitions->
			{
				{"TestSummaryNotebook[summary]","notebook","returns a 'notebook' with formatted results from the input 'summary'."}
			},
		MoreInformation->{
			"Notebook should appear the same as the \"SummaryNotebook\" display for RunUnitTest."
			},
		Input:>
			{
				{"summary",_EmeraldTestSummary,"A summary of a test run."}
			},
		Output:>
			{
				{"notebook",_NotebookObject,"A formatted notebook displaying test results."}
			},
		Tutorials->{},
		Sync->Automatic,
		SeeAlso->
			{
				"Test",
				"Example",
				"RunUnitTest",
				"EmeraldTest",
				"EmeraldTestResult",
				"EmeraldTestSummary",
				"PlotTestSuiteSummaries"
			},
		Author->{"ben", "olatunde.olademehin", "platform"}
	}
];

(* ::Subsubsection::Closed:: *)
(*SymbolTestFile*)

DefineUsage[SymbolTestFile,
	{
		BasicDefinitions->
			{
				{"SymbolTestFile[symbol]","path","returns the 'path' to the source file containing units tests for 'symbol'."}
			},
		MoreInformation->{
			"Returns $Failed if no tests are found."
			},
		Input:>
			{
				{"symbol",_Symbol|_String,"The symbol (or string name) to lookup the test file for."}
			},
		Output:>
			{
				{"path",_String,"Path to the test file."}
			},
		Tutorials->{},
		SeeAlso->
			{
				"Test",
				"Example",
				"RunUnitTest",
				"EmeraldTest",
				"EmeraldTestResult",
				"EmeraldTestSummary"
			},
		Author->{"platform", "thomas"}
	}
];

(* ::Subsubsection::Closed:: *)
(*TestFailureNotebook*)


DefineUsage[TestFailureNotebook,
	{
		BasicDefinitions->
      {
				{"TestFailureNotebook[summary]","notebook","returns a 'notebook' with formatted results of test failures from the input 'summary'."}
			},
		MoreInformation->
      {
				"Notebook should appear the same as the \"SummaryNotebook\" display for RunUnitTest."
			},
		Input:>
				{
					{"summary",_EmeraldTestSummary,"A summary of a test run."}
				},
		Output:>
				{
					{"notebook",_NotebookObject,"A formatted notebook displaying only failed test results."}
				},
		Tutorials->{},
		Sync->Automatic,
		SeeAlso->
				{
					"Test",
					"Example",
					"RunUnitTest",
					"EmeraldTest",
					"EmeraldTestResult",
					"EmeraldTestSummary",
					"TestSummaryNotebook"
				},
		Author->{"yanzhe.zhu", "ben", "platform", "ti.wu"}
	}
];


(* ::Subsubsection::Closed:: *)
(*Warning*)


DefineUsage[Warning,
	{
		BasicDefinitions->{
			{"Warning[description,expression,expectedValue]","test","returns an executable 'test' which will evaluate 'expression' and determine if it matches 'expectedValue'."}
		},
		MoreInformation->{
			"The following Options MUST be specified as RuleDelayed: Messages,SetUp,TearDown,Variables,Stubs.",
			"The function definitions specified in the Stubs Options list are only applicable during the execution of the test. During the execution of the test, all previously specified definitions for the stubbed out symbols will be ignored and after the test is executed the stubbed out definitions will be forgotten.",
			"The 'Stubs' Options differentiates between Set & SetDelayed calls. A SetDelayed call will clear all definitions for the symbol before applying the Stub definition, whereas a Set call will prepend the definition to the existing DownValues for the symbol.",
			"The 'Set' Stubs (which prepend DownValues) works by copying all the DownValues/OwnValues/UpValues/Options/Attributes for a symbol during a test and as a result will not work with built in Mathematica symbols whose DownValues, OwnValues, etc., are not exposed. However, The SetDelayed method for clearing the symbol will always work."
		},
		Input:>{
			{"description",_String,"A description for what the expression is testing."},
			{"expression",_,"An expression to be evaluated, the return value of which will be compared to the 'expectedValue'."},
			{"expectedValue",_,"An expression to compare against the return value of 'expression'."}
		},
		Output:>{
			{"test",TestP,"An EmeraldTest object."}
		},
		SeeAlso->{"Example","Function","EmeraldTest","RunUnitTest","Test"},
		Author->{"pnafisi", "melanie.reschke", "josh.kenchel", "thomas", "sarah"},
		Tutorials->{}
	}
];


(* ::Subsubsection::Closed:: *)
(*LoadTests*)


DefineUsage[LoadTests,
	{
		BasicDefinitions->{
			{"LoadTests[]","loaded","loads the tests for all the active packages."},
			{"LoadTests[package]","Null","loads the tests for the specific 'package'."},
			{"LoadTests[packages]","loaded","loads the tests for a set of 'packages'."}
		},
		Input:>{
			{"package",_String,"A package name (such as \"Constellation`\")."},
			{"packages",{__String},"A list of package names."}
		},
		Output:>{
			{"loaded",_Association,"An Association with keys that are the packages whose tests were loaded."}
		},
		SeeAlso->{"Tests","Test","Example","RunUnitTest"},
		Author->{"pnafisi", "melanie.reschke", "josh.kenchel", "thomas", "platform"},
		Tutorials->{}
	}
];