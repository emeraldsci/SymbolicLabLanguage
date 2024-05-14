(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsubsection:: *)
(*RunValidQTest*)


DefineTests[
	RunValidQTest,
	{
		Example[{Basic,"Single input item returns True if all tests for given input pass:"},
			RunValidQTest[Object[Example, Data, "id:100"], {dataObjectAndGreaterThan10Tests}],
			True
		],

		Example[{Basic,"Multiple input items returns a single True/False if all the inputs pass/fail their tests (gettings tests using given lookup functions):"},
			RunValidQTest[{Object[Example, Data, "id:100"],Object[Example, Data, "id:1"]},{dataObjectAndGreaterThan10Tests}],
			False
		],

		Example[{Messages,"InvalidTests","If any lookup function does not return a list of tests, filter out that input and throw a message:"},
			RunValidQTest[{Object[Example, Data, "id:100"],Object[Example, Data, "id:1"]},{dataObjectAndGreaterThan10Tests,shouldNotEvaluate}],
			False,
			Messages:>{
				Message[RunValidQTest::InvalidTests,{2}]
			}
		],

		Example[{Additional,"Lookup functions can be specified as pure functions as well as symbols:"},
			RunValidQTest[{Object[Example, Data, "id:100"],Object[Example, Data, "id:1"]},{dataObjectAndGreaterThan10Tests[#]&}],
			False
		],

		Example[{Options,SymbolSetUp,"Don't run the SymbolSetUp/SymbolTearDown for the given function if SymbolSetUp -> False:"},
			RunValidQTest[{Object[Example, Data, "id:100"],Object[Example, Data, "id:1"]},{dataObjectAndGreaterThan10Tests},SymbolSetUp -> False],
			False
		],

		Example[{Options,OutputFormat,"Returns EmeraldTestSummary objects instead of booleans if OutputFormat->TestSummary:"},
			RunValidQTest[{Object[Example, Data, "id:100"],Object[Example, Data, "id:1"]},{dataObjectAndGreaterThan10Tests},OutputFormat->TestSummary],
			{_EmeraldTestSummary,_EmeraldTestSummary}
		],

		Example[{Options,OutputFormat,"Returns a list booleans (one for each input) instead of single boolean if OutputFormat->BooleanList:"},
			RunValidQTest[{Object[Example, Data, "id:100"],Object[Example, Data, "id:1"]},{dataObjectAndGreaterThan10Tests},OutputFormat->Boolean],
			{True,False}
		],

		Example[{Options,Association,"Returns an Association of EmeraldTestSummary objects instead of booleans if OutputFormat->TestSummary Association->True:"},
			RunValidQTest[{Object[Example, Data, "id:100"],Object[Example, Data, "id:1"]},{dataObjectAndGreaterThan10Tests},OutputFormat->TestSummary,Association->True],
			_Association?(And[
				MatchQ[#[Object[Example, Data, "id:100"]],_EmeraldTestSummary],
				MatchQ[#[Object[Example, Data, "id:1"]],_EmeraldTestSummary]
			]&)
		],

		Example[{Options,OutputFormat,"Returns a list booleans (one for each input) instead of single boolean if OutputFormat->Boolean & Association -> True:"},
			RunValidQTest[{Object[Example, Data, "id:100"],Object[Example, Data, "id:1"]},{dataObjectAndGreaterThan10Tests},OutputFormat->Boolean,Association->True],
			_Association?(And[
				MatchQ[#[Object[Example, Data, "id:100"]],True],
				MatchQ[#[Object[Example, Data, "id:1"]],False]
			]&)
		],

		Example[{Options,SummaryNotebook,"Inherits SummaryNotebook option for RunUnitTest:"},
			RunValidQTest[Object[Example, Data, "id:100"],{dataObjectAndGreaterThan10Tests},SummaryNotebook->False],
			True
		],

		Example[{Options,Verbose,"Inherits Verbose option for RunUnitTest:"},
			RunValidQTest[Object[Example, Data, "id:100"],{dataObjectAndGreaterThan10Tests},Verbose->False],
			True
		],
		
		Example[{Options,Verbose,"Inherits Verbose option for RunUnitTest:"},
			RunValidQTest[Object[Example, Data, "id:100"],{dataObjectAndGreaterThan10Tests},Verbose->False],
			True
		],
		
		Example[{Options,PrintIndexOnly,"Only print the index of the input instead of the entire input when displaying progress (this is useful for large inputs to save space):"},
			RunValidQTest[Object[Example, Data, "id:100"],{dataObjectAndGreaterThan10Tests},PrintIndexOnly->True],
			True
		],
		
		Test["Given duplicate inputs return result for each element:",
			RunValidQTest[{Object[Example, Data, "id:100"],Object[Example, Data, "id:100"]},{dataObjectAndGreaterThan10Tests},OutputFormat->Boolean],
			{True,True}
		]
	},
	SetUp:>(
		dataObjectAndGreaterThan10Tests[in:ObjectReferenceP[]]:={
			Test["Is a data object:",in,ObjectReferenceP[Object[Example,Data]]],
			Test["Key is the string 100:",Last[in]=="id:100",True]
		};
		packetTests[packet:{(_Rule | _RuleDelayed) ..}]:={
			Test["Is a packet:",True,True]
		};
	),
	Stubs:>{
		NotebookWrite[___]:=Null,
		Print[___]:=Null
	}
];
