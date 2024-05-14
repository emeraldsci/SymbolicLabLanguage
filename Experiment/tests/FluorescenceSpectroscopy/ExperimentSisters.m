(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentFluorescenceSpectroscopyPreview*)
DefineTests[
	ExperimentFluorescenceSpectroscopyPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentFluorescenceSpectroscopy:"},
			ExperimentFluorescenceSpectroscopyPreview[Object[Sample,"Test sample 1 for ExperimentFluorescenceSpectroscopyPreview"<>$SessionUUID]],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed try using ExperimentFluorescenceSpectroscopyOptions:"},
			ExperimentFluorescenceSpectroscopyOptions[Object[Sample,"Test sample 1 for ExperimentFluorescenceSpectroscopyPreview"<>$SessionUUID]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run:"},
			ValidExperimentFluorescenceSpectroscopyQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceSpectroscopyPreview"<>$SessionUUID],Verbose->Failures],
			True
		]
	},
	Stubs:>{
	(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>Module[{platePacket,vesselPacket,bottlePacket,incompatibleChemicalPacket,
		plate1,plate2,emptyPlate,vessel1,vessel2,vessel3,vessel4,vessel5,bottle1,
		numberOfInputSamples,sampleNames,numberOfInjectionSamples,injectionSampleNames,samples},
		ClearMemoization[];
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		platePacket=<|
			Type->Object[Container,Plate],
			Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],
			DeveloperObject->True,
			Site -> Link[$Site],
			Name->"Test plate 1 for ExperimentFluorescenceSpectroscopyPreview"<>$SessionUUID
		|>;

		plate1=Upload[platePacket];

		samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
			Name->"Test sample 1 for ExperimentFluorescenceSpectroscopyPreview"<>$SessionUUID,
			InitialAmount->100 Microliter
		];
	],
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	]
];


(* ::Subsection::Closed:: *)
(*ExperimentFluorescenceSpectroscopyOptions*)
DefineTests[
	ExperimentFluorescenceSpectroscopyOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentFluorescenceSpectroscopyOptions[Object[Sample,"Test sample 1 for ExperimentFluorescenceSpectroscopyOptions"<>$SessionUUID]],
			_Grid
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentFluorescenceSpectroscopyOptions[Object[Sample,"Test sample 1 for ExperimentFluorescenceSpectroscopyOptions"<>$SessionUUID],
				PlateReaderMix->True
			],
			_Grid,
			Messages:>{Warning::PlateReaderStowaways}
		],
		Example[
			{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentFluorescenceSpectroscopyOptions[{Object[Sample,"Test sample 1 for ExperimentFluorescenceSpectroscopyOptions"<>$SessionUUID]},OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs:>{
	(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>Module[{platePacket,vesselPacket,bottlePacket,incompatibleChemicalPacket,
		plate1,plate2,emptyPlate,vessel1,vessel2,vessel3,vessel4,vessel5,bottle1,
		numberOfInputSamples,sampleNames,numberOfInjectionSamples,injectionSampleNames,samples},
		ClearMemoization[];
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		platePacket=<|
			Type->Object[Container,Plate],
			Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],
			DeveloperObject->True,
			Site -> Link[$Site],
			Name->"Test plate 1 for ExperimentFluorescenceSpectroscopyOptions"<>$SessionUUID
		|>;

		plate1=Upload[platePacket];

		samples=UploadSample[{Model[Sample,StockSolution,"0.2M FITC"],Model[Sample,StockSolution,"0.2M FITC"]},{{"A1",plate1},{"A2",plate1}},
			Name->{"Test sample 1 for ExperimentFluorescenceSpectroscopyOptions"<>$SessionUUID,"Test sample 2 for ExperimentFluorescenceSpectroscopyOptions"<>$SessionUUID},
			InitialAmount->100 Microliter
		];
	],
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	]
];

(* ::Subsection::Closed:: *)
(*ValidExperimentFluorescenceSpectroscopyQ*)

DefineTests[
	ValidExperimentFluorescenceSpectroscopyQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issue:"},
			ValidExperimentFluorescenceSpectroscopyQ[Object[Sample,"Test sample 1 for ValidExperimentFluorescenceSpectroscopyQ"<>$SessionUUID]],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentFluorescenceSpectroscopyQ[Object[Sample,"Test sample 1 for ValidExperimentFluorescenceSpectroscopyQ"<>$SessionUUID],
				PlateReaderMix->False,
				PlateReaderMixTime-> 30 Second
			],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentFluorescenceSpectroscopyQ[Object[Sample,"Test sample 1 for ValidExperimentFluorescenceSpectroscopyQ"<>$SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentFluorescenceSpectroscopyQ[Object[Sample,"Test sample 1 for ValidExperimentFluorescenceSpectroscopyQ"<>$SessionUUID],Verbose->True],
			True
		]
	},
	Stubs:>{
	(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>Module[{platePacket,vesselPacket,bottlePacket,incompatibleChemicalPacket,
		plate1,plate2,emptyPlate,vessel1,vessel2,vessel3,vessel4,vessel5,bottle1,
		numberOfInputSamples,sampleNames,numberOfInjectionSamples,injectionSampleNames,samples},
		ClearMemoization[];
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		platePacket=<|
			Type->Object[Container,Plate],
			Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],
			DeveloperObject->True,
			Site -> Link[$Site],
			Name->"Test plate 1 for ValidExperimentFluorescenceSpectroscopyQ"<>$SessionUUID
		|>;

		plate1=Upload[platePacket];

		samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
			Name->"Test sample 1 for ValidExperimentFluorescenceSpectroscopyQ"<>$SessionUUID,
			InitialAmount->100 Microliter
		];
	],
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	]
]
