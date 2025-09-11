(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentImageCells Sister Functions : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentImageCells*)


(* ::Subsection::Closed:: *)
(*ExperimentImageCellsOptions*)


DefineTests[ExperimentImageCellsOptions,
	{
		Example[{Basic,"Return a list of options in table form for one sample:"},
			ExperimentImageCellsOptions[
				Object[Sample,"Test cell sample 1 for ExperimentImageCellsOptions tests"<> $SessionUUID]
			],
			_Grid
		],
		Example[{Basic,"Return a list of options in table form for pooling multiple samples together:"},
			ExperimentImageCellsOptions[{
				{Object[Sample,"Test cell sample 1 for ExperimentImageCellsOptions tests"<> $SessionUUID],Object[Sample,"Test cell sample 2 for ExperimentImageCellsOptions tests"<> $SessionUUID]},
				{Object[Sample,"Test cell sample 3 for ExperimentImageCellsOptions tests"<> $SessionUUID]}
			}],
			_Grid
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, returns the options as a list of rules:"},
			ExperimentImageCellsOptions[
				Object[Sample,"Test cell sample 1 for ExperimentImageCellsOptions tests"<> $SessionUUID],
				OutputFormat->List
			],
			{_Rule..}
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		setUpImageCellsTestObjects["ExperimentImageCellsOptions"]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		tearDownImageCellsTestObjects["ExperimentImageCellsOptions"]
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentImageCellsPreview*)


DefineTests[ExperimentImageCellsPreview,
	{
		Example[{Basic,"Return Null for one sample:"},
			ExperimentImageCellsPreview[
				Object[Sample,"Test cell sample 1 for ExperimentImageCellsPreview tests"<> $SessionUUID]
			],
			Null
		],
		Example[{Basic,"Return Null for multiple samples:"},
			ExperimentImageCellsPreview[{
				{Object[Sample,"Test cell sample 1 for ExperimentImageCellsPreview tests"<> $SessionUUID],Object[Sample,"Test cell sample 2 for ExperimentImageCellsPreview tests"<> $SessionUUID]}
			}],
			Null
		],
		Example[{Basic,"Return Null for multiple pooled samples:"},
			ExperimentImageCellsPreview[{
				{Object[Sample,"Test cell sample 1 for ExperimentImageCellsPreview tests"<> $SessionUUID],Object[Sample,"Test cell sample 2 for ExperimentImageCellsPreview tests"<> $SessionUUID]},
				{Object[Sample,"Test cell sample 3 for ExperimentImageCellsPreview tests"<> $SessionUUID]}
			}],
			Null
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		setUpImageCellsTestObjects["ExperimentImageCellsPreview"]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		tearDownImageCellsTestObjects["ExperimentImageCellsPreview"]
	)
];


(* ::Subsection::Closed:: *)
(*ValidExperimentImageCellsQ*)


DefineTests[ValidExperimentImageCellsQ,
	{
		Example[{Basic,"Returns a Boolean indicating the validity of an experimental setup on a sample:"},
			ValidExperimentImageCellsQ[
				Object[Sample,"Test cell sample 1 for ValidExperimentImageCellsQ tests"<> $SessionUUID]
			],
			True
		],
		Example[{Options,Verbose,"If Verbose -> True, returns the passing and failing tests:"},
			ValidExperimentImageCellsQ[
				Object[Sample,"Test cell sample 1 for ValidExperimentImageCellsQ tests"<> $SessionUUID],
				Verbose->True
			],
			True
		],
		Example[{Options,OutputFormat,"If OutputFormat -> TestSummary, returns a test summary instead of a Boolean:"},
			ValidExperimentImageCellsQ[
				Object[Sample,"Test cell sample 1 for ValidExperimentImageCellsQ tests"<> $SessionUUID],
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		]
	},
	Stubs:>{
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		setUpImageCellsTestObjects["ValidExperimentImageCellsQ"]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		tearDownImageCellsTestObjects["ValidExperimentImageCellsQ"]
	)
];