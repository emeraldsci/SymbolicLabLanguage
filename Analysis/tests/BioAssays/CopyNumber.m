(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*CopyNumber: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*AnalyzeCopyNumber*)


DefineTests[AnalyzeCopyNumber,
	{
		(*===Basic examples===*)
		Example[{Basic,"Given a quantification cycle (Cq) analysis object and a linear fit analysis object of Cq vs Log10 copy number, creates a copy number analysis object:"},
			AnalyzeCopyNumber[
				Object[Analysis,QuantificationCycle,"AnalyzeCopyNumber test Cq analysis 1"],
				Object[Analysis,Fit,"AnalyzeCopyNumber test standard curve"]
			],
			ObjectP[Object[Analysis,CopyNumber]]
		],
		Example[{Basic,"Given multiple Cq analysis objects and a linear fit analysis object of Cq vs Log10 copy number, creates a copy number analysis object for each Cq analysis object:"},
			AnalyzeCopyNumber[
				{
					Object[Analysis,QuantificationCycle,"AnalyzeCopyNumber test Cq analysis 1"],
					Object[Analysis,QuantificationCycle,"AnalyzeCopyNumber test Cq analysis 2"]
				},
				Object[Analysis,Fit,"AnalyzeCopyNumber test standard curve"]
			],
			ConstantArray[ObjectP[Object[Analysis,CopyNumber]],2]
		],
		Example[{Basic,"Given multiple Cq analysis objects and copy number and Cq analysis object pairs, performs a new fit and uses it to create a copy number analysis object for each Cq analysis object:"},
			AnalyzeCopyNumber[
				{
					Object[Analysis,QuantificationCycle,"AnalyzeCopyNumber test Cq analysis 1"],
					Object[Analysis,QuantificationCycle,"AnalyzeCopyNumber test Cq analysis 2"]
				},
				{
					{1000,Object[Analysis,QuantificationCycle,"AnalyzeCopyNumber test Cq analysis 1"]},
					{10000,Object[Analysis,QuantificationCycle,"AnalyzeCopyNumber test Cq analysis 2"]},
					{100000,Object[Analysis,QuantificationCycle,"AnalyzeCopyNumber test Cq analysis 3"]},
					{1000000,Object[Analysis,QuantificationCycle,"AnalyzeCopyNumber test Cq analysis 4"]}
				}
			],
			ConstantArray[ObjectP[Object[Analysis,CopyNumber]],2]
		],


		(*===Additional examples===*)
		Example[{Additional,"Create a new linear fit analysis object of Cq vs Log10 copy number:"},
			AnalyzeFit[
				Transpose[{
					Log[10,{1000,10000,100000,1000000}],
					Download[{Object[Analysis,QuantificationCycle,"AnalyzeCopyNumber test Cq analysis 1"],Object[Analysis,QuantificationCycle,"AnalyzeCopyNumber test Cq analysis 2"],Object[Analysis,QuantificationCycle,"AnalyzeCopyNumber test Cq analysis 3"],Object[Analysis,QuantificationCycle,"AnalyzeCopyNumber test Cq analysis 4"]},QuantificationCycle]
				}],
				Linear
			],
			ObjectP[Object[Analysis,Fit]]
		],


		(*===Error messages tests===*)
		Example[{Messages,"InvalidFit","If a fit is provided, the ExpressionType is Linear and the DataUnits are {1, 1 Cycle}:"},
			AnalyzeCopyNumber[
				Object[Analysis,QuantificationCycle,"AnalyzeCopyNumber test Cq analysis 1"],
				Object[Analysis,Fit,"AnalyzeCopyNumber test invalid standard curve"]
			],
			$Failed,
			Messages:>{
				Error::InvalidFit,
				Error::InvalidInput
			}
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},


	SymbolSetUp:>(
		$CreatedObjects={};

		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Analysis,QuantificationCycle,"AnalyzeCopyNumber test Cq analysis 1"],
				Object[Analysis,QuantificationCycle,"AnalyzeCopyNumber test Cq analysis 2"],
				Object[Analysis,QuantificationCycle,"AnalyzeCopyNumber test Cq analysis 3"],
				Object[Analysis,QuantificationCycle,"AnalyzeCopyNumber test Cq analysis 4"],
				Object[Analysis,Fit,"AnalyzeCopyNumber test standard curve"],
				Object[Analysis,Fit,"AnalyzeCopyNumber test invalid standard curve"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]

		];

		(*Make test Cq analysis objects*)
		Upload[{
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"AnalyzeCopyNumber test Cq analysis 1",
				QuantificationCycle->24.7 Cycle,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"AnalyzeCopyNumber test Cq analysis 2",
				QuantificationCycle->21.6 Cycle,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"AnalyzeCopyNumber test Cq analysis 3",
				QuantificationCycle->18.2 Cycle,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"AnalyzeCopyNumber test Cq analysis 4",
				QuantificationCycle->15 Cycle,
				DeveloperObject->True
			|>
		}];

		(*Make a valid test standard curve*)
		AnalyzeFit[
			{{Log10[1000],24.7 Cycle},{Log10[10000],21.6 Cycle},{Log10[100000],18.2 Cycle},{Log10[1000000],15 Cycle}},
			Linear,
			Name->"AnalyzeCopyNumber test standard curve"
		];

		(*Make an invalid test standard curve*)
		AnalyzeFit[
			{{Log10[1000],24.7 Cycle},{Log10[10000],21.6 Cycle},{Log10[100000],18.2 Cycle},{Log10[1000000],15 Cycle}},
			Log,
			Name->"AnalyzeCopyNumber test invalid standard curve"
		];
	),


	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)
];


(* ::Subsection::Closed:: *)
(*AnalyzeCopyNumberOptions*)


DefineTests[AnalyzeCopyNumberOptions,
	{
		Example[{Basic,"Given a quantification cycle (Cq) analysis object and a standard curve fit analysis object, returns the options in table form:"},
			AnalyzeCopyNumberOptions[
				Object[Analysis,QuantificationCycle,"AnalyzeCopyNumberOptions test Cq analysis"],
				Object[Analysis,Fit,"AnalyzeCopyNumberOptions test standard curve"]
			],
			_Grid
		],
		Example[{Options,OutputFormat,"If OutputFormat->List, returns the options as a list of rules:"},
			AnalyzeCopyNumberOptions[
				Object[Analysis,QuantificationCycle,"AnalyzeCopyNumberOptions test Cq analysis"],
				Object[Analysis,Fit,"AnalyzeCopyNumberOptions test standard curve"],
				OutputFormat->List
			],
			{_Rule..}
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},


	SymbolSetUp:>(
		$CreatedObjects={};

		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Analysis,QuantificationCycle,"AnalyzeCopyNumberOptions test Cq analysis"],
				Object[Analysis,Fit,"AnalyzeCopyNumberOptions test standard curve"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]

		];

		(*Make a test Cq analysis object*)
		Upload[<|
			Type->Object[Analysis,QuantificationCycle],
			Name->"AnalyzeCopyNumberOptions test Cq analysis",
			QuantificationCycle->23 Cycle,
			DeveloperObject->True
		|>];

		(*Make a test standard curve*)
		AnalyzeFit[
			{{Log10[1000],24.7 Cycle},{Log10[10000],21.6 Cycle},{Log10[100000],18.2 Cycle},{Log10[1000000],15 Cycle}},
			Linear,
			Name->"AnalyzeCopyNumberOptions test standard curve"
		];
	),


	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)
];


(* ::Subsection::Closed:: *)
(*AnalyzeCopyNumberPreview*)


DefineTests[AnalyzeCopyNumberPreview,
	{
		Example[{Basic,"Given a quantification cycle (Cq) analysis object and a standard curve fit analysis object, returns the graphical preview:"},
			AnalyzeCopyNumberPreview[
				Object[Analysis,QuantificationCycle,"AnalyzeCopyNumberPreview test Cq analysis"],
				Object[Analysis,Fit,"AnalyzeCopyNumberPreview test standard curve"]
			],
			ValidGraphicsP[]
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},


	SymbolSetUp:>(
		$CreatedObjects={};

		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Analysis,QuantificationCycle,"AnalyzeCopyNumberPreview test Cq analysis"],
				Object[Analysis,Fit,"AnalyzeCopyNumberPreview test standard curve"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]

		];

		(*Make a test Cq analysis object*)
		Upload[<|
			Type->Object[Analysis,QuantificationCycle],
			Name->"AnalyzeCopyNumberPreview test Cq analysis",
			QuantificationCycle->23 Cycle,
			DeveloperObject->True
		|>];

		(*Make a test standard curve*)
		AnalyzeFit[
			{{Log10[1000],24.7 Cycle},{Log10[10000],21.6 Cycle},{Log10[100000],18.2 Cycle},{Log10[1000000],15 Cycle}},
			Linear,
			Name->"AnalyzeCopyNumberPreview test standard curve"
		];
	),


	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)
];


(* ::Subsection::Closed:: *)
(*ValidAnalyzeCopyNumberQ*)


DefineTests[ValidAnalyzeCopyNumberQ,
	{
		Example[{Basic,"Given a quantification cycle (Cq) analysis object and a standard curve fit analysis object, returns a Boolean indicating the validity of the analysis setup:"},
			ValidAnalyzeCopyNumberQ[
				Object[Analysis,QuantificationCycle,"ValidAnalyzeCopyNumberQ test Cq analysis"],
				Object[Analysis,Fit,"ValidAnalyzeCopyNumberQ test standard curve"]
			],
			True
		],
		Example[{Options,Verbose,"If Verbose->True, returns the passing and failing tests:"},
			ValidAnalyzeCopyNumberQ[
				Object[Analysis,QuantificationCycle,"ValidAnalyzeCopyNumberQ test Cq analysis"],
				Object[Analysis,Fit,"ValidAnalyzeCopyNumberQ test standard curve"],
				Verbose->True
			],
			True
		],
		Example[{Options,OutputFormat,"If OutputFormat->TestSummary, returns a test summary instead of a Boolean:"},
			ValidAnalyzeCopyNumberQ[
				Object[Analysis,QuantificationCycle,"ValidAnalyzeCopyNumberQ test Cq analysis"],
				Object[Analysis,Fit,"ValidAnalyzeCopyNumberQ test standard curve"],
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		]
	},


	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},


	SymbolSetUp:>(
		$CreatedObjects={};

		Module[{allObjects,existingObjects},

			(*Gather all the objects and models created in SymbolSetUp*)
			allObjects={
				Object[Analysis,QuantificationCycle,"ValidAnalyzeCopyNumberQ test Cq analysis"],
				Object[Analysis,Fit,"ValidAnalyzeCopyNumberQ test standard curve"]
			};

			(*Check whether the names we want to give below already exist in the database*)
			existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

			(*Erase any test objects and models that we failed to erase in the last unit test*)
			Quiet[EraseObject[existingObjects,Force->True,Verbose->False]]

		];

		(*Make a test Cq analysis object*)
		Upload[<|
			Type->Object[Analysis,QuantificationCycle],
			Name->"ValidAnalyzeCopyNumberQ test Cq analysis",
			QuantificationCycle->23 Cycle,
			DeveloperObject->True
		|>];

		(*Make a test standard curve*)
		AnalyzeFit[
			{{Log10[1000],24.7 Cycle},{Log10[10000],21.6 Cycle},{Log10[100000],18.2 Cycle},{Log10[1000000],15 Cycle}},
			Linear,
			Name->"ValidAnalyzeCopyNumberQ test standard curve"
		];
	),


	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)
];


(* ::Section:: *)
(*End Test Package*)
