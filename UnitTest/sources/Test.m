(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Test*)


(* ::Subsubsection::Closed:: *)
(*Test*)


handlerBlock[{handlerField_String,handler_},code_]:=Module[
	{result,originalHandlers},

	originalHandlers = Lookup[Internal`Handlers[],handlerField];

	Scan[Internal`RemoveHandler[handlerField,#]&,originalHandlers];
	Internal`AddHandler[handlerField,handler];

	result=code;

	Internal`RemoveHandler[handlerField,handler];
	Scan[Internal`AddHandler[handlerField,#]&,originalHandlers];

	result

];
SetAttributes[handlerBlock,HoldRest];

(*Given to use from WRI to prevent catching messages which are never printed/thrown
to the front end during evaluation of tests*)
deactivateHiddenMessages[]:=(
	Unprotect[Internal`DeactivateMessages];
	Internal`DeactivateMessages = Quiet;
	Protect[Internal`DeactivateMessages];
);


SetAttributes[Test,HoldRest];

DefineOptions[
	Test,
	Options:>{
		{TimeConstraint->300,_Integer?NonNegative,"The Test will be considered a failure if the execution takes longer than this value (in seconds)."},
		{EquivalenceFunction->MatchQ,_Function|_Symbol,"Function used to compare the return value of the test expression with the expected value."},
		{Messages:>{},{HoldPattern[MessageName[___]]...}|HoldPattern[MessageName[___]]|{HoldPattern[Message[___]]...}|HoldPattern[Message[___]],"The Messages that are expected to be thrown during the execution of this test."},
		{Stubs:>{},{(HoldPattern[Set[_,_]]|HoldPattern[SetDelayed[_,_]])...},"A list of function definitions to be applied during the execution of the test run."},
		{Category->Tests,_String|_Symbol,"A Category to group tests by."},
		{SubCategory->Null,_String|_Symbol|{__Symbol},"A sub category to group tests by."},
		{FatalFailure->False,True|False,"Whether or not a failure of this test should cause a short circuit in a test run."},
		{SetUp:>Null,_,"Expression to be executed before test expression is executed."},
		{TearDown:>Null,_,"Expression to be executed after test expression is executed."},
		{Variables:>{},{___Symbol},"List of variables to be created private to the test execution. Accessible from SetUp/TearDown but not Stubs."},
		{Warning->False,True|False,"When True, a failure of this test will not affect the result of a test run."},
		{Message->Null,Null|Hold[HoldPattern[MessageName[___]]],"The message that should be thrown if this test does not succeed. The string template of the message will be filled in with the MessageArguments option."},
		{MessageArguments->Null,Null|_List,"The arguments that should be passed to Message[messageName, arg1, arg2...] if a message should be thrown as a result of this test failing."},
		{ConstellationDebug->False,True|False,"When True, attach all constellation requests and responses to the test run."},
		{Sandbox->False, True|False, "Determines if the test is configured to run in the Sandbox environment."}
	}
];

Test[description_String, expressionUnderTest_, expected_, ops:OptionsPattern[]]:=Module[
	{messagesExpected,maxExecutionTime,stateFunctions,equivalenceFunction,stubs,
		executableFunction,replacementOptions,category,subCategory,fatalFailure,
		level,messagesOption,warning, message, messageArguments, constellationDebugQ, sandboxEnabled},

	(* If we're on Manifold, we should increase the timeout constraint to 60 minutes. *)
	(* This is because we really don't want false positives from the manifold unit testing system. *)
	maxExecutionTime=If[MatchQ[ECL`$ManifoldComputation, ECL`ObjectP[]],
		If[MatchQ[OptionValue[TimeConstraint], _Integer?NonNegative] && OptionValue[TimeConstraint] > 60*30,
			OptionValue[TimeConstraint],
			60*60
		],
		optionOrDefault[
			OptionValue[TimeConstraint],
			_Integer?NonNegative,
			"TimeConstraint" /. Options[Test]
		]
	];
	equivalenceFunction=optionOrDefault[
		OptionValue[EquivalenceFunction],
		_Function|_Symbol,
		"EquivalenceFunction" /. Options[Test]
	];

	category=optionOrDefault[
		OptionValue[Category],
		_Symbol|_String,
		"Category" /. Options[Test]
	];
	subCategory=optionOrDefault[
		OptionValue[SubCategory],
		_Symbol|_String|{__Symbol},
		"SubCategory" /. Options[Test]
	];

	fatalFailure=optionOrDefault[
		OptionValue[FatalFailure],
		True|False,
		"FatalFailure" /. Options[Test]
	];

	warning=optionOrDefault[
		OptionValue[Warning],
		True|False,
		"Warning" /. Options[Test]
	];

	constellationDebugQ = optionOrDefault[
		OptionValue[ConstellationDebug],
		True|False,
		"ConstellationDebug" /. Options[Test]
	];

	message=optionOrDefault[
		OptionValue[Message],
		Null|Hold[HoldPattern[MessageName[___]]],
		"Message" /. Options[Test]
	];

	messageArguments=optionOrDefault[
		OptionValue[MessageArguments],
		Null|_List,
		"MessageArguments" /. Options[Test]
	];

	sandboxEnabled=optionOrDefault[
		OptionValue[Sandbox],
		True|False,
		"Sandbox" /. Options[Test]
	];

	(*
		The following option values are RuleDelayed, and their values must be held
		as they contain messages, function calls, and Set/SetDelayed calls.
	*)
	messagesOption=optionOrDefault[
		OptionValue[Automatic,Automatic,Messages,Hold],
		{(HoldPattern[MessageName[___]]|HoldPattern[Message[___]])...}|HoldPattern[MessageName[___]]|HoldPattern[Message[___]],
		"Messages" /. Options[Test]
	];
	stubs=optionOrDefault[
		OptionValue[Automatic,Automatic,Stubs,Hold],
		{(HoldPattern[Set[_,_]]|HoldPattern[SetDelayed[_,_]])...},
		"Stubs" /. Options[Test]
	];

	(*Wrap HoldForm around MessageNames to prevent evaluation for future comparison*)
	level = If[MatchQ[messagesOption,Hold[_List]],
		{2},
		{1}
	];

	messagesExpected=Cases[
		messagesOption,
		HoldPattern[m:(Message|MessageName)[___]] :> HoldForm[m],
		level
	];

	stateFunctions = setStateFunctions[stubs];
	replacementOptions = setupTeardownOptions[Flatten[List[ops]]];

	executableFunction=With[{insertMe1=message,insertMe2=messageArguments},
		ReleaseHold[
			Replace[
				Replace[
					Hold[Block[{setUpTestMessages={},tearDownTestMessages={}},functionWithSetupAndTeardown[
						"Variables",
						"SetUp",
						"TearDown",
						Block[{passed,result},
							Block[{actual,executionTime,$Messages,$MessageList,$TestMessages,$MessagesExpected,messages,heldExpression,heldExpectedResult,messageFailure,resultFailure,timeoutFailure,debugOutput, startDate, endDate, simTasks, simObj},
								(* Make sure that messages don't get printed. *)
								$Messages={};
								$MessageList={};

								(* Keep track of the messages that were thrown. *)
								$TestMessages={};
								$MessagesExpected=messagesExpected;

								(* Set the current test. *)
								$CurrentTest=description;

								handlerBlock[
									{"MessageTextFilter",testMessageHandler},
									ReleaseHold[
										Replace[
											Replace[
												Hold[(
													Block[stubsToBlockVariables,
														If[constellationDebugQ,
															GoLink`Private`startDebugMode[];
														];

														(*Copy original definitions for Set calls to Stubs*)
														Map[
															ReleaseHold,
															stateFunctions
														];

														(*Evaluate Stubs*)
														ReleaseHold[ReleaseHold[Evaluate[setToDownValuePrepend[stubs]]]];

														heldExpression=HoldForm[expressionUnderTest];
														heldExpectedResult=HoldForm[expected];
														startDate = Now;
														(*Evaluate the expression under test, and record how long it takes to execute*)
														{executionTime,actual}=AbsoluteTiming[
															CheckAbort[
																TimeConstrained[expressionUnderTest,maxExecutionTime,$TimeoutFailure],
																$MessageFailure
															]
														];
														endDate = Now;
														(*After the comparison calculation is done, Defer the evaluation of the actual result
                            such that it preserve the state of evaluation within the stubbed environment*)

														actual = Defer[Evaluate[actual]];
														messages=$TestMessages;
														simTasks = $SimulatedTasks;
														simObj = If[MatchQ[ECL`$Simulation, True],
															HoldForm[Evaluate[uploadSimulationCloudFile[]]],
															Null
														];
													];

													(*Expected value is executed outside the context of the
                          Stubbed block (where the actual value is calculated)*)
													(*The extra TrueQ needs to be here to increase the level so that Holds in expected are not removed*)
													timeoutFailure=TrueQ[MatchQ[First[actual],$TimeoutFailure]];
													resultFailure=!TrueQ[equivalenceFunction[Evaluate[First[actual]], expected]];
													messageFailure=!TrueQ[messagesMatchQ[messagesExpected,messages]];
													debugOutput = If[constellationDebugQ,
														GoLink`Private`finishDebugMode[],
														{}
													];

													passed=Not[
														Or[
															timeoutFailure,
															resultFailure,
															messageFailure
														]
													]
												)],
												stubsToBlockVariables->stubbedSymbols[stubs],
												{3}
											],
											Hold[x_]:>x,
											{4}
										]
									]
								];

								(*Return a TestResultP for validation*)
								result=testResult[
									description,
									category,
									subCategory,
									heldExpression,
									actual,
									passed,
									heldExpectedResult,
									messagesExpected,
									messages,
									maxExecutionTime,
									executionTime,
									startDate,
									endDate,
									equivalenceFunction,
									warning,
									Which[
										timeoutFailure,
										"TimeoutFailure",
										resultFailure,
										"ResultFailure",
										messageFailure,
										"MessageFailure",
										True,
										"Success"
									],
									debugOutput,
									setUpTestMessages,
									tearDownTestMessages,
									simTasks,
									simObj,
									sandboxEnabled
								];
							];

							(* Throw a message if asked to do so and we didn't pass. *)
							If[!passed&&!MatchQ[insertMe1,Null|Hold[Null]]&&MatchQ[ECL`$UnitTestMessages,True],
								Message@@Fold[Append,insertMe1,insertMe2];
							];

							(* Return our test result. *)
							result
						]
					]]],
					replacementOptions,
					{3}
				],
				Defer[x_]:>x,
				{2}
			]]
	];

	EmeraldTest[
		Association[
			Description->description,
			Function->executableFunction,
			ExpectedValue->expected,
			Expression->Defer[expressionUnderTest],
			Category->category,
			SubCategory->subCategory,
			FatalFailure->fatalFailure,
			TimeConstraint->maxExecutionTime,
			Warning->warning,
			ID->CreateUUID[],
			ECL`Sandbox->sandboxEnabled
		]
	]
];

setupTeardownOptions[ops_List]:=Module[
	{stringOptionsAssociation,defaults,missingKeys},

	(* Since local Test options (SetUp, TearDown, etc) will be later in the list
	of ops, convert to an Association so they take priority over options set at
	the function level *)
	stringOptionsAssociation = Association@If[MatchQ[ops,{}],
		{},
		MapAt[
			Function[option,
				If[MatchQ[option,_Symbol],
					SymbolName[option],
					option
				]
			],
			ops,
			{All,1}
		]
	];

	defaults = Options[Test];

	missingKeys = Complement[
		{"Variables","SetUp","TearDown"},
		Keys[stringOptionsAssociation]
	];

	Join[
		Normal[stringOptionsAssociation],
		Select[
			defaults,
			MemberQ[missingKeys,#[[1]]]&
		]
	]
];

SetAttributes[functionWithSetupAndTeardown, HoldAll];
functionWithSetupAndTeardown[variables : {___Symbol}, setup_, tearDown_, expression_] := Module[{resultSymbol},

	With[{vars = variables},
		Replace[
			Function[
				Module[vars,
					setUpTestMessages = EvaluationData[setup]["MessagesExpressions"];
					resultSymbol = expression;
					tearDownTestMessages = EvaluationData[tearDown]["MessagesExpressions"];
					resultSymbol
				]
			],
			Hold[{x___}, y_] :> {x, y},
			{2}
		]
	]
];

optionOrDefault::InvalidOptionValue="`1` does not match pattern `2`, defaulting to `3`.";
optionOrDefault[value_,expectedPattern_,default_]:=If[MatchQ[value,expectedPattern|Hold[expectedPattern]],
	value,
	With[{},
		Message[optionOrDefault::InvalidOptionValue,value,expectedPattern,default];
		default
	]
];

SetAttributes[originalStateFunction, HoldFirst];
originalStateFunction[sym_Symbol] := With[
	{
		downValues = DownValues[sym],
		ownValues = OwnValues[sym],
		upValues = UpValues[sym],
		options = Options[sym],
		attributes = Cases[Attributes[sym],Except[Locked|Protected]]
	},

	Hold[
		DownValues[sym] = downValues;
		OwnValues[sym] = ownValues;
		UpValues[sym] = upValues;
		Options[sym] = options;
		Attributes[sym] = attributes;
	]
];

setStateFunctions[stubs : Hold[{(HoldPattern[Set[_, _]] | HoldPattern[SetDelayed[_, _]]) ...}]] := Replace[
	DeleteDuplicates[
		Cases[
			stubs,
			Alternatives[
				HoldPattern[Set[sym_Symbol[___], _]]
			] :> Hold[sym],
			{2}
		]
	],
	Hold->originalStateFunction,
	{2},
	Heads->True
];


stubbedSymbols[stubs : Hold[{(HoldPattern[Set[_, _]] | HoldPattern[SetDelayed[_, _]]) ...}]] := DeleteDuplicates[
	Cases[
		stubs,
		Alternatives[
			HoldPattern[Set[sym_Symbol, _]],
			HoldPattern[Set[sym_Symbol[___], _]],
			HoldPattern[SetDelayed[sym_Symbol[___], _]]
		] :> Hold[sym],
		{2}
	]
];


setToDownValuePrepend[stubs : Hold[{(HoldPattern[Set[_, _]] | HoldPattern[SetDelayed[_, _]]) ...}]] := Replace[
	stubs,
	RuleDelayed[
		HoldPattern[Set[lhs:sym_Symbol[args___], rhs_]],
		With[{arguments=holder[args]},
			ReplaceAll[
				Hold[
					Set[
						DownValues[sym],
						Prepend[DownValues[sym],RuleDelayed[HoldPattern[arguments],rhs]]
					]
				],
				holder->sym
			]
		]
	],
	{2}
];

(* Message Handling*)

$CurrentTest = Null;
$TestMessages = {};
$MessagesExpected = {};

(* ignore a very specific OptionValue::nodef ExpressionUUID message that sometimes gets caught in tests,
 but never makes it to the surface, so is never actually visible to a user *)
testMessageHandler[_String, Hold[OptionValue::nodef], Hold[Message[OptionValue::nodef, HoldForm["ExpressionUUID"], ___]]] := Null;

testMessageHandler[one_String, two:Hold[msg_MessageName], three:Hold[Message[msg_MessageName, args___]]] := Module[{},
	(* Keep track of the messages thrown during evaluation of the test. *)
	AppendTo[
		$TestMessages,
		HoldForm[Message[msg, args]]
	];

	(* If we're running on AWS with a Unit Test object and a message was thrown that wasn't expected, upload it to the unit test object. *)
	If[MatchQ[ECL`$UnitTestObject, _ECL`Object] && Length[Intersection[$MessagesExpected, {HoldForm[Message[msg, args]]}, SameTest->matchingMessageQ]]==0,
		Module[{currentDatabase, loginResult, originalLoginResult, retryCount},
			currentDatabase=Global`$ConstellationDomain;

			Echo["Unexpected message thrown: "<>ToString[HoldForm[Message[msg, args]]]];

			Echo["Logging into stage database to upload message..."];

			(* Switch to the test database. *)
			(* Retry logging in to the stage database up to 3 times. *)
			loginResult = False;
			For[retryCount=1,retryCount<=3,retryCount++,
				loginResult = ECL`Login[
					ECL`Token -> GoLink`Private`stashedJwt,
					ECL`Database -> "https://constellation-stage.emeraldcloudlab.com",
					ECL`QuietDomainChange -> True
				];

				(* Check if login was successful, abort if not *)
				If[TrueQ[loginResult],
					Break[];
				];
				Echo["Attempt number "<>ToString[retryCount]<>" failed. Retrying..."];
				Pause[3];
			];

			(* Check if login was successful, abort if not *)
			If[!TrueQ[loginResult],
				Echo["Error: Login to stage database failed."];
				(* This is the exit safe word for Mathematica jobs running in Manifold -- for more context, look this up in ecl-python. enjoy*)
				Echo["terminate-kernel-strange-excitement-rapidly-explore"];
				Abort[];
			];

			(* Perform the upload *)
			(* Block out $Notebook in case the test has this stubbed to an object that doesn't exist on the stage DB. *)
			Block[{ECL`$Notebook=Null},
				ECL`Upload[<|
					ECL`Object -> ECL`$UnitTestObject,
					Append[Messages] -> {$CurrentTest, HoldForm[Message[msg, args]]}
				|>];
			];

			Echo["Returning to "<>ToString[currentDatabase]<>" database..."];

			(* Switch back to the original database. *)
			(* Retry logging in to the original database up to 3 times. *)
			originalLoginResult = False;
			For[retryCount=1,retryCount<=3,retryCount++,
				originalLoginResult = ECL`Login[
					ECL`Token -> GoLink`Private`stashedJwt,
					ECL`Database -> currentDatabase,
					ECL`QuietDomainChange -> True
				];
			
				(* Check if returning was successful, abort if not *)
				If[TrueQ[originalLoginResult],
					Break[];
				];
				Echo["Attempt number "<>ToString[retryCount]<>" failed. Retrying..."];
				Pause[3];
			];

			(* Check if returning was successful, abort if not *)
			If[!TrueQ[originalLoginResult],
				Echo["Error: Could not log back into the original database"];
				Echo["terminate-kernel-strange-excitement-rapidly-explore"];
				Abort[];
			];
		]
	];

	(* If there are more than 3 non-matching messages thrown during our current evaluation, abort the test. *)
	(* NOTE: $UnitTestMessages is a flag set in the ExternalUpload framework saying that we're expecting a bunch of *)
	(* messages to come up. *)
	If[!MatchQ[ECL`$UnitTestMessages, True] && Length[Complement[$TestMessages, $MessagesExpected, SameTest->matchingMessageQ]]>3,
		Abort[];
	];
];

messagesMatchQ[expected:{HoldForm[_Message|_MessageName]...},actual:{HoldForm[_Message]...}]:=
		ContainsExactly[expected, actual, SameTest->matchingMessageQ];


matchingMessageQ[HoldForm[Message[name1_MessageName, args1__]], HoldForm[Message[name2_MessageName, args2__]]] := And[
	SameQ[
		List[args1],
		List[args2]
	],
	MatchQ[name1, name2]
];

(*Required for different behaviour of expressions when helf in input to tests as expected messages
and what is evaluated in a call to Message in code (things like fractions resolve to different forms)*)
matchingMessageQ[
	HoldForm[name1_MessageName]|HoldForm[Message[name1_MessageName, ___]],
	HoldForm[name2_MessageName]|HoldForm[Message[name2_MessageName, ___]]
]:=
		MatchQ[Hold[name1],Hold[name2]];




(* ::Subsubsection::Closed:: *)
(*TestP*)


TestP=EmeraldTest[_Association];


(* ::Subsubsection::Closed:: *)
(*EmeraldTest*)


OnLoad[
	MakeBoxes[test:EmeraldTest[assoc_Association], StandardForm] := BoxForm`ArrangeSummaryBox[
		EmeraldTest,
		test,
		Null,
		{
			{
				BoxForm`SummaryItem[{"Description: ", assoc[Description]}],
				BoxForm`SummaryItem[{"Category: ", assoc[Category]}]
			},
			{
				BoxForm`SummaryItem[{"ID: ", assoc[ID]}],
				BoxForm`SummaryItem[{"SubCategory: ", assoc[SubCategory]}]
			},
			{
				BoxForm`SummaryItem[{"Fatal Failure: ", assoc[FatalFailure]}],
				""
			}

		},
		{
			BoxForm`SummaryItem[{SummaryBoxes`Private`summaryButton["Run Test",Print[RunTest[test]]],""}],
			BoxForm`SummaryItem[{SummaryBoxes`Private`summaryButton["Expression",Print[test[Expression]]],""}],
			BoxForm`SummaryItem[{SummaryBoxes`Private`summaryButton["Expected Value",Print[test[ExpectedValue]]],""}]
		},
		StandardForm
	]
];


(*Add SubValues accessor*)
OverloadSummaryHead[EmeraldTest];


(* ::Subsection:: *)
(*TestResult*)


(* ::Subsubsection::Closed:: *)
(*TestResultP*)


TestResultP = EmeraldTestResult[_Association];

(* ::Subsubsection::Closed:: *)
(*$SimulatedTasks*)

(* this global variable captures all the tasks that we ran through in this simulation; we AppendTo it during SimulateProcedure, and then clear it when we start a new one *)
(* need to define this here (even though it gets appended to elsewhere) so that Test and Example know about it and can put it in their output blobs *)
$SimulatedTasks = {};

(* ::Subsection::Closed::*)
(*allProcedureTaskIDs*)

(* given a protocol/qual/maintenance type, give all the task IDs in the procedure (in order to attain full coverage of procedure testing) *)
allProcedureTaskIDs[myType:ECL`Object[__Symbol]]:=Module[
	{allProcedures, allTaskIDs, tasksWithDuplicates, trimmedTasks},

	(* this helper from PlotBetaTesting gets all the procedure names; from there we can get all the IDs *)
	allProcedures = Plot`Private`procedureTree[myType];
	allTaskIDs = Lookup[Lookup[ECL`ProcedureAssociation[#], "Tasks"], "ID"]& /@ allProcedures;

	(* want to trim the duplicate tasks off here (i.e., for resource picking the -1, -2, -3, -0 ones etc) *)
	tasksWithDuplicates = Cases[Flatten[allTaskIDs], _String];

	trimmedTasks = StringTrim[#, RegularExpression["[\\-\\+]\\d(\\.\\w)?"]]& /@ tasksWithDuplicates;

	DeleteDuplicates[trimmedTasks]

];

(* ::Subsection::Closed::*)
(*allProcedureTasksPerformed*)

(* calculate the number of tasks perfomred for a given type (because some include subprotocols etc) *)
(* allow myTaskIDs to be {(_String|Null|_Missing)...} because sometimes $SimulatedTasks ends up with that stuff in it and we can just prune that here *)
allProcedureTasksPerformed[myType:ECL`Object[__Symbol], myTaskIDs:{(_String|Null|_Missing)...}]:=Module[
	{allProcTaskIDs},

	(* use the above helper to get the task IDs, then get the ones we actually ran *)
	allProcTaskIDs = allProcedureTaskIDs[myType];
	Intersection[allProcTaskIDs, myTaskIDs]

];

(* ::Subsection::Closed::*)
(*percentTasksPerformed*)

(* calculate the percent of tasks performed given a list of tasks *)
percentTasksPerformed[myType:ECL`Object[__Symbol], myTaskIDs:{(_String|Null|_Missing)...}]:=Module[
	{allProcTaskIDs, taskIDsPerformed},

	taskIDsPerformed = allProcedureTasksPerformed[myType, myTaskIDs];
	allProcTaskIDs = allProcedureTaskIDs[myType];

	If[MatchQ[allProcTaskIDs, {}],
		Null,
		(100 Percent * N[Length[taskIDsPerformed] / Length[allProcTaskIDs]])
	]
];


(* ::Subsubsection::Closed:: *)
(*testResult*)


testResult[
	description_String,
	category:_Symbol|_String,
	subCategory:_Symbol|_String|{__Symbol},
	expression_HoldForm,
	result_,
	passed:(True|False),
	expected:HoldForm[_],
	expectedMessages:{HoldForm[_Message|_MessageName]...},
	messages:{HoldForm[Message[___]]...},
	maxExecutionTime_Integer?NonNegative,
	executionTime_?NumericQ,
	startDate:_?DateObjectQ,
	endDate:_?DateObjectQ,
	equivalenceFunction:_Function|_Symbol,
	warning: True|False,
	outcome_String,
	debugOutput_List: {},
	setupMessages:{Hold[Message[___]]...},
	teardownMessages:{Hold[Message[___]]...},
	simulatedTasks:{___String},
	simulationObj:Null|_HoldForm,
	sandbox: (True | False)
]:=EmeraldTestResult[
	Association[
		Description->description,
		Category->category,
		SubCategory->subCategory,
		Expression->expression,
		(* Only store large results (e.g. single test results > 500kB) if it is a valid graphics object *)
		ActualValue->If[
			(* Use the common heads/checks for graphics *)
			!MatchQ[Evaluate@@result, ListableP[ECL`ValidGraphicsP[]|_DynamicModule|_Image|_Pane|_Grid|_TabView|_SlideView]] && ByteCount[result] > 500000,
			"Result too large to store",
			result
		],
		Passed->passed,
		ExpectedValue->expected,
		ExpectedMessages->expectedMessages,
		(* only show the first 6 actual messages just to tone down the output if it is too big *)
		ActualMessages->If[Length[messages]>6, Flatten[{messages[[;;6]], "further messages not shown"}], messages],
		TimeConstraint->maxExecutionTime,
		ExecutionTime->executionTime,
		StartDate -> startDate,
		EndDate -> endDate,
		EquivalenceFunction->equivalenceFunction,
		Warning->warning,
		Outcome->outcome,
		ConstellationDebugOutput->debugOutput,
		SetUpMessages->setupMessages,
		TearDownMessages->teardownMessages,
		SimulatedTasks -> simulatedTasks,
		Simulation -> simulationObj,
		Sandbox -> sandbox
	]
];


(* ::Subsection::Closed::*)
(*uploadSimulationCloudFile*)

uploadSimulationCloudFile[]:=Module[
	{placeholderSimulation, filePath, cloudFile},
	placeholderSimulation = ECL`$CurrentSimulation;
	filePath = FileNameJoin[{$TemporaryDirectory, CreateUUID[] <> ".nb"}];
	Put[ECL`$CurrentSimulation, filePath];
	(* note that here we are Exiting Simulation and then re-entering it because we want to _actually_ upload the cloud file here for future tests *)
	ECL`ExitSimulation[];
	cloudFile = Block[{$AllowPublicObjects = True},ECL`UploadCloudFile[filePath]];
	ECL`EnterSimulation[];
	ECL`$CurrentSimulation = placeholderSimulation;
	cloudFile
];

(* ::Subsubsection::Closed:: *)
(*EmeraldTestResult*)


OnLoad[
	MakeBoxes[result:EmeraldTestResult[_Association], StandardForm] := BoxForm`ArrangeSummaryBox[
		EmeraldTestResult,
		result,
		If[result[Passed],
			successIcon[],
			failureIcon[]
		],
		{
			BoxForm`SummaryItem[{"Name: ",result[Description]}],
			BoxForm`SummaryItem[{"Outcome: ", result[Outcome]}]
		},
		{
			BoxForm`SummaryItem[{"Execution Time: ", Quantity[result[ExecutionTime],"Seconds"]}]
		},
		StandardForm
	]
];


(*Add SubValues accessor*)
OverloadSummaryHead[EmeraldTestResult];


(*Run an individual test. If no callback provided, pass in a NOP function.*)
RunTest[test:TestP]:=test[Function][];

(*Run an list of tests. If no callback provided, pass in a NOP function.*)
RunTest[tests:{TestP...}]:=RunTest/@tests;