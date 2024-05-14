(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section::Closed:: *)
(*Help Files*)

(* ::Subsubsection::Closed:: *)
(*Test*)


DefineUsage[Test,
	{
		BasicDefinitions->{
			{"Test[description,expression,expectedValue]","test","returns an executable 'test' which will evaluate 'expression' and determine if it matches 'expectedValue'."}
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
		SeeAlso->{"Example","Function","EmeraldTest","RunUnitTest"},
		Author->{"pnafisi", "melanie.reschke", "josh.kenchel", "thomas", "platform"},
		Tutorials->{}
	}
];


(* ::Subsubsection::Closed:: *)
(*EmeraldTest*)


DefineUsage[EmeraldTest,
	{
		BasicDefinitions->
			{
				{"EmeraldTest[association]","test","represents the results of executing a single EmeraldTest."}
			},
		MoreInformation->{
			"Properties can be accessed via EmeraldTest[...][\"Property\"]",
			"Multiple Properties can be accessed via EmeraldTest[...][{\"Property1\",\"Property2\"}]",
			"Properties:",
			Grid[{
				{"Name","Description"},
				{"Description", "The description of the test which was run."},
				{"Expression", "Deferred version of expression that was executed in the test."},
				{"ExpectedValue", "Expected value from executing the test expression."},
				{"Category", "A String or Symbol categorizing the test."},
				{"SubCategory", "A String or Symbol further categorizing the test."},
				{"FatalFailure", "A Boolean used in a run of multiple tests to determine whether or not to halt further test execution on failure."},
				{"ID", "A UUID uniquely identifying the test."},
				{"TimeConstraint","Maximum time in seconds that a test may take to execute."}
			}]
			},
		Input:>
			{
				{"association",_Association,"The association containing the data for the test."}
			},
		Output:>
			{
				{"test",_EmeraldTest,"An EmeraldTest wrapper."}
			},
		Tutorials->{},
		Sync->Automatic,
		SeeAlso->
			{
				"Test",
				"Example",
				"RunUnitTest",
				"EmeraldTestResult",
				"EmeraldTestSummary"
			},
		Author->{"pnafisi", "melanie.reschke"}
	}
];


(* ::Subsubsection::Closed:: *)
(*RunTest*)


DefineUsage[RunTest,
	{
		BasicDefinitions->
			{
				{"RunTest[test]","result","executes a 'test'."}
			},
		Input:>
			{
				{"test",TestP,"The test to execute."}
			},
		Output:>
			{
				{"result",TestResultP,"An EmeraldTestResult."}
			},
		Tutorials->{},
		Sync->Automatic,
		SeeAlso->
			{
				"Test",
				"Example",
				"RunUnitTest",
				"EmeraldTestResult",
				"EmeraldTestSummary"
			},
		Author->{"pnafisi", "melanie.reschke", "josh.kenchel", "thomas", "platform"}
	}
];


(* ::Subsubsection::Closed:: *)
(*EmeraldTestResult*)


DefineUsage[EmeraldTestResult,
	{
		BasicDefinitions->
			{
				{"EmeraldTestResult[association]","result","represents the results of executing a single EmeraldTest."}
			},
		MoreInformation->{
			"Properties can be accessed via EmeraldTestResult[...][\"Property\"]",
			"Multiple Properties can be accessed via EmeraldTestResult[...][{\"Property1\",\"Property2\"}]",
			"Properties:",
			Grid[{
				{"Name","Description"},
				{"Description", "The description of the test which was run."},
				{"Category", "The category for the test."},
				{"SubCategory", "Tge sub-category for the test."},
				{"Outcome", "Outcome of the test execution. May be one of \"Success\", \"ResultFailure\", \"MessageFailure\", \"TimeoutFailure\"."},
				{"Passed", "Boolean value for whether or not the test Outcome was 'Success'"},
				{"Expression", "Deferred version of expression that was executed in the test."},
				{"ActualValue", "Actual value returned from executing the test expression."},
				{"ExpectedValue", "Expected value from executing the test expression."},
				{"ActualMessages", "A list of messages thrown during the execution of the test expression."},
				{"ExpectedMessages", "A list of messages expected to be thrown during the execution of the test expression."},
				{"TimeConstraint", "Maximum time (in seconds) the test expression was allowed to execute for before aborting and resulting in a 'TimeoutFailure'."},
				{"ExecutionTime", "The amount of time (in seconds) the test expression took to run."},
				{"EquivalenceFunction", "The function which was used to compare the expected value to the actual value."}
			}]
		},
		Input:>
			{
				{"association",_Association,"The association containing the data for the test result."}
			},
		Output:>
			{
				{"result",_EmeraldTestResult,"An EmeraldTestResult wrapper."}
			},
		Tutorials->{},
		Sync->Automatic,
		SeeAlso->
			{
				"Test",
				"Example",
				"RunUnitTest",
				"EmeraldTest",
				"EmeraldTestSummary"
			},
		Author->{"pnafisi", "melanie.reschke"}
	}
];