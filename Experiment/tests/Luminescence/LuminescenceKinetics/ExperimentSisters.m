(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentLuminescenceKineticsPreview*)
DefineTests[
	ExperimentLuminescenceKineticsPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentLuminescenceKinetics:"},
			ExperimentLuminescenceKineticsPreview[Object[Sample,"Test sample 1 for ExperimentLuminescenceKineticsPreview" <> $SessionUUID]],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed try using ExperimentFluroescenceKineticsOptions:"},
			ExperimentLuminescenceKineticsOptions[Object[Sample,"Test sample 1 for ExperimentLuminescenceKineticsPreview" <> $SessionUUID]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run:"},
			ValidExperimentLuminescenceKineticsQ[Object[Sample,"Test sample 1 for ExperimentLuminescenceKineticsPreview" <> $SessionUUID],Verbose->Failures],
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
			Name->"Test plate 1 for ExperimentLuminescenceKineticsPreview" <> $SessionUUID
		|>;

		plate1=Upload[platePacket];

		samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
			Name->"Test sample 1 for ExperimentLuminescenceKineticsPreview" <> $SessionUUID,
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
(*ExperimentLuminescenceKineticsOptions*)
DefineTests[
	ExperimentLuminescenceKineticsOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentLuminescenceKineticsOptions[Object[Sample,"Test sample 1 for ExperimentLuminescenceKineticsOptions" <> $SessionUUID]],
			_Grid
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentLuminescenceKineticsOptions[Object[Sample,"Test sample 1 for ExperimentLuminescenceKineticsOptions" <> $SessionUUID],
				Instrument->Model[Instrument,PlateReader,"FLUOstar Omega"],
				DualEmissionWavelength->535 Nanometer
			],
			_Grid,
			Messages:>{Error::DualEmissionUnavailable,Error::InvalidOption}
		],
		Example[
			{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentLuminescenceKineticsOptions[{Object[Sample,"Test sample 1 for ExperimentLuminescenceKineticsOptions" <> $SessionUUID]},OutputFormat->List],
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
			Name->"Test plate 1 for ExperimentLuminescenceKineticsOptions" <> $SessionUUID
		|>;

		plate1=Upload[platePacket];

		samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
			Name->"Test sample 1 for ExperimentLuminescenceKineticsOptions" <> $SessionUUID,
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
(*ValidExperimentLuminescenceKineticsQ*)

DefineTests[
	ValidExperimentLuminescenceKineticsQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issue:"},
			ValidExperimentLuminescenceKineticsQ[Object[Sample,"Test sample 1 for ValidExperimentLuminescenceKineticsQ" <> $SessionUUID]],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentLuminescenceKineticsQ[Object[Sample,"Test sample 1 for ValidExperimentLuminescenceKineticsQ" <> $SessionUUID],
				PlateReaderMix->False,
				PlateReaderMixTime-> 30 Second
			],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentLuminescenceKineticsQ[Object[Sample,"Test sample 1 for ValidExperimentLuminescenceKineticsQ" <> $SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentLuminescenceKineticsQ[Object[Sample,"Test sample 1 for ValidExperimentLuminescenceKineticsQ" <> $SessionUUID],Verbose->True],
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
			Name->"Test plate 1 for ValidExperimentLuminescenceKineticsQ" <> $SessionUUID
		|>;

		plate1=Upload[platePacket];

		samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
			Name->"Test sample 1 for ValidExperimentLuminescenceKineticsQ" <> $SessionUUID,
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
