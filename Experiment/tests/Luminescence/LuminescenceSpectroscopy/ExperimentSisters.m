(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentLuminescenceSpectroscopyPreview*)
DefineTests[
	ExperimentLuminescenceSpectroscopyPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentFluorescenceSpectroscopy:"},
			ExperimentLuminescenceSpectroscopyPreview[Object[Sample,"Test sample 1 for ExperimentLuminescenceSpectroscopyPreview"]],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed try using ExperimentLuminescenceSpectroscopyOptions:"},
			ExperimentLuminescenceSpectroscopyOptions[Object[Sample,"Test sample 1 for ExperimentLuminescenceSpectroscopyPreview"]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run:"},
			ValidExperimentLuminescenceSpectroscopyQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceSpectroscopyPreview"],Verbose->Failures],
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
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		platePacket=<|
			Type->Object[Container,Plate],
			Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],
			DeveloperObject->True,
			Site -> Link[$Site],
			Name->"Test plate 1 for ExperimentLuminescenceSpectroscopyPreview"
		|>;

		plate1=Upload[platePacket];

		samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
			Name->"Test sample 1 for ExperimentLuminescenceSpectroscopyPreview",
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
(*ExperimentLuminescenceSpectroscopyOptions*)
DefineTests[
	ExperimentLuminescenceSpectroscopyOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentLuminescenceSpectroscopyOptions[Object[Sample,"Test sample 1 for ExperimentLuminescenceSpectroscopyOptions"]],
			_Grid
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentLuminescenceSpectroscopyOptions[Object[Sample,"Test sample 1 for ExperimentLuminescenceSpectroscopyOptions"],
				PlateReaderMix->True
			],
			_Grid,
			Messages:>{Warning::PlateReaderStowaways}
		],
		Example[
			{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentLuminescenceSpectroscopyOptions[{Object[Sample,"Test sample 1 for ExperimentLuminescenceSpectroscopyOptions"]},OutputFormat->List],
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
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		platePacket=<|
			Type->Object[Container,Plate],
			Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],
			DeveloperObject->True,
			Site -> Link[$Site],
			Name->"Test plate 1 for ExperimentLuminescenceSpectroscopyOptions"
		|>;

		plate1=Upload[platePacket];

		samples=UploadSample[{Model[Sample,StockSolution,"0.2M FITC"],Model[Sample,StockSolution,"0.2M FITC"]},{{"A1",plate1},{"A2",plate1}},
			Name->{"Test sample 1 for ExperimentLuminescenceSpectroscopyOptions","Test sample 2 for ExperimentLuminescenceSpectroscopyOptions"},
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
(*ValidExperimentLuminescenceSpectroscopyQ*)

DefineTests[
	ValidExperimentLuminescenceSpectroscopyQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issue:"},
			ValidExperimentLuminescenceSpectroscopyQ[Object[Sample,"Test sample 1 for ValidExperimentLuminescenceSpectroscopyQ"]],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentLuminescenceSpectroscopyQ[Object[Sample,"Test sample 1 for ValidExperimentLuminescenceSpectroscopyQ"],
				PlateReaderMix->False,
				PlateReaderMixTime-> 30 Second
			],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentLuminescenceSpectroscopyQ[Object[Sample,"Test sample 1 for ValidExperimentLuminescenceSpectroscopyQ"],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentLuminescenceSpectroscopyQ[Object[Sample,"Test sample 1 for ValidExperimentLuminescenceSpectroscopyQ"],Verbose->True],
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
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		platePacket=<|
			Type->Object[Container,Plate],
			Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],
			DeveloperObject->True,
			Site -> Link[$Site],
			Name->"Test plate 1 for ValidExperimentLuminescenceSpectroscopyQ"
		|>;

		plate1=Upload[platePacket];

		samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
			Name->"Test sample 1 for ValidExperimentLuminescenceSpectroscopyQ",
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