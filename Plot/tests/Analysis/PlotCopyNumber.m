(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection::Closed:: *)
(*PlotCopyNumber*)


DefineTests[PlotCopyNumber,
	{
		(*===Basic examples===*)
		Example[{Basic,"Given a copy number analysis object, creates a plot for the analysis object:"},
			PlotCopyNumber[
				Object[Analysis,CopyNumber,"PlotCopyNumber test copy number analysis 1"]
			],
			ValidGraphicsP[]
		],

		Example[{Basic,"Given multiple copy number analysis objects, creates a plot for the analysis objects:"},
			PlotCopyNumber[
				{
					Object[Analysis,CopyNumber,"PlotCopyNumber test copy number analysis 1"],
					Object[Analysis,CopyNumber,"PlotCopyNumber test copy number analysis 2"]
				}
			],
			ValidGraphicsP[]
		],

		(*===Options examples===*)
		Example[{Options,Zoomable,"Toggles the interactive zoom feature:"},
			PlotCopyNumber[
				Object[Analysis,CopyNumber,"PlotCopyNumber test copy number analysis 1"],
				Zoomable->False
			],
			g_/;ValidGraphicsQ[g]&&Length@Cases[g,_DynamicModule,-1]==0
		],

		(* Output tests *)
		Test["Setting Output to Result returns the plot:",
			PlotCopyNumber[Object[Analysis,CopyNumber,"PlotCopyNumber test copy number analysis 1"],Output->Result],
			_?ValidGraphicsQ
		],

		Test["Setting Output to Preview returns the plot:",
			PlotCopyNumber[Object[Analysis,CopyNumber,"PlotCopyNumber test copy number analysis 1"],Output->Preview],
			_?ValidGraphicsQ
		],

		Test["Setting Output to Options returns the resolved options:",
			PlotCopyNumber[Object[Analysis,CopyNumber,"PlotCopyNumber test copy number analysis 1"],Output->Options],
			ops_/;MatchQ[ops,OptionsPattern[PlotCopyNumber]]
		],

		Test["Setting Output to Tests returns a list of tests:",
			PlotCopyNumber[Object[Analysis,CopyNumber,"PlotCopyNumber test copy number analysis 1"],Output->Tests],
			{(_EmeraldTest|_Example)...}
		],

		Test["Setting Output to {Result,Options} returns the plot along with all resolved options:",
			PlotCopyNumber[Object[Analysis,CopyNumber,"PlotCopyNumber test copy number analysis 1"],Output->{Result,Options}],
			output_List/;MatchQ[First@output,_?ValidGraphicsQ]&&MatchQ[Last@output,OptionsPattern[PlotCopyNumber]]
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
				Object[Analysis,QuantificationCycle,"PlotCopyNumber test Cq analysis 1"],
				Object[Analysis,QuantificationCycle,"PlotCopyNumber test Cq analysis 2"],
				Object[Analysis,Fit,"PlotCopyNumber test standard curve"],
				Object[Analysis,CopyNumber,"PlotCopyNumber test copy number analysis 1"],
				Object[Analysis,CopyNumber,"PlotCopyNumber test copy number analysis 2"]
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
				Name->"PlotCopyNumber test Cq analysis 1",
				QuantificationCycle->23 Cycle,
				DeveloperObject->True
			|>,
			<|
				Type->Object[Analysis,QuantificationCycle],
				Name->"PlotCopyNumber test Cq analysis 2",
				QuantificationCycle->17 Cycle,
				DeveloperObject->True
			|>
		}];

		Module[{fitObject,cnObjects},

			(*Make a test standard curve*)
			fitObject=AnalyzeFit[
				{{Log10[1000],24.7 Cycle},{Log10[10000],21.6 Cycle},{Log10[100000],18.2 Cycle},{Log10[1000000],15 Cycle}},
				Linear,
				Name->"PlotCopyNumber test standard curve",
				Upload->False
			];

			Upload[Append[fitObject,DeveloperObject->True]];

			(*Make test copy number analysis objects*)
			cnObjects=AnalyzeCopyNumber[
				{
					Object[Analysis,QuantificationCycle,"PlotCopyNumber test Cq analysis 1"],
					Object[Analysis,QuantificationCycle,"PlotCopyNumber test Cq analysis 2"]
				},
				Object[Analysis,Fit,"PlotCopyNumber test standard curve"],
				Upload->False
			];

			Upload[{
				Append[First[cnObjects],{DeveloperObject->True,Name->"PlotCopyNumber test copy number analysis 1"}],
				Append[Last[cnObjects],{DeveloperObject->True,Name->"PlotCopyNumber test copy number analysis 2"}]
			}]

		];
	),

	SymbolTearDown:>(
		EraseObject[PickList[$CreatedObjects,DatabaseMemberQ[$CreatedObjects],True],Force->True,Verbose->False];
	)
];
