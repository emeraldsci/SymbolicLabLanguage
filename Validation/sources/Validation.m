(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Subsection::Closed:: *)
(*ValidQ Functions*)


(* ::Subsubsection::Closed:: *)
(*RunValidQTests*)

DefineOptions[
	RunValidQTest,
	Options:>{
		{Association->False,True|False,"Whether or not to return an Association of inputs->summaries. If False, only returns a list of summaries."},
		{OutputFormat->SingleBoolean,SingleBoolean|Boolean|TestSummary,"Determines the format of the return value. Boolean returns a pass/fail for each entry. SingleBoolean returns a single pass/fail boolean for all the inputs. TestSummary returns the EmeraldTestSummary object for each input."},
		{PrintIndexOnly->False,True|False,"When True, prints the item index as a header for each input instead of the input themselves. This is useful for large inputs like packets."},
		{Verbose->False,True|False|Failures,"If True, print the result of each test as they finish."},
		{SymbolSetUp -> True, True|False, "Option to decide whether to call the SymbolSetUp/SymbolTearDown of the given function when calling RunUnitTest.  Notably would be false for functions like ValidDocumentationQ."}
	},
	SharedOptions:>{
		{RunUnitTest,{SummaryNotebook,DisplayFunction}}
	}
];

RunValidQTest[items_,functions:{(_Symbol|_Function)...}, ops:OptionsPattern[]]:=Module[
	{testRules,invalidPositions,options,results,indicesOnly, symbolSetUp},

	options = OptionDefaults[RunValidQTest,ToList[ops]];
	indicesOnly = Lookup[options,"PrintIndexOnly"];
	symbolSetUp = Lookup[options, "SymbolSetUp"];
	
	testRules = MapIndexed[
		Function[{item,index},
			Rule[
				(* need to do this weird Which with SymbolSetUp option because if we're running VDQ we for sure do _not_ want to run SymbolSetUp/SymbolTearDown of the function and need to ToString to make sure RunUnitTest doesn't do it *)
				Which[
					indicesOnly, "Index " <> ToString[First[index]],
					Not[symbolSetUp], ToString[item],
					True, item
				],
				Map[
					Function[func,
						func[item]
					],
					functions
				]
			]
		],
		ToList[items]
	];
	
	invalidPositions = DeleteDuplicates[
		Apply[
			Join,
			Map[
				invalidTestPositions[#]&,
				testRules[[All,2]]
			]
		]
	];
	
	If[Length[invalidPositions] > 0,
		Message[RunValidQTest::InvalidTests,invalidPositions]
	];

	testRules = Map[
		# -> Apply[
			Join,
			Cases[
				Lookup[testRules,Key[#]],
				{(ExampleP|TestP)...},
				{1}
			]
		]&,
		Keys[testRules]
	];
	
	results=RunUnitTest[
		testRules,
		PassOptions[
			RunValidQTest,
			RunUnitTest,
			options
		]
	];

	If[ListQ[items],
		results,
		If[MatchQ[Lookup[options,"OutputFormat"],SingleBoolean],
			results,
			First[results]
		]
	]
];
RunValidQTest::InvalidTests = "Functions at positions `1` did not return valid lists of tests.";

(*Get positions in the input list where they are not lists of tests.*)
invalidTestPositions[testLists_List]:=Flatten[
	Position[
		testLists,
		_?(Not[MatchQ[#,{(TestP|ExampleP)...}]]&),
		{1},
		Heads->False
	]
];
