(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentFluorescencePolarizationPreview*)
DefineTests[
	ExperimentFluorescencePolarizationPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentFluorescencePolarization:"},
			ExperimentFluorescencePolarizationPreview[Object[Sample,"Test sample 1 for ExperimentFluorescencePolarizationPreview"<>$SessionUUID]],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed try using ExperimentFluorescencePolarizationOptions:"},
			ExperimentFluorescencePolarizationOptions[Object[Sample,"Test sample 1 for ExperimentFluorescencePolarizationPreview"<>$SessionUUID]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run:"},
			ValidExperimentFluorescencePolarizationQ[Object[Sample,"Test sample 1 for ExperimentFluorescencePolarizationPreview"<>$SessionUUID],Verbose->Failures],
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

		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		ClearMemoization[];
		$CreatedObjects={};

		platePacket=<|
			Type->Object[Container,Plate],
			Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],
			DeveloperObject->True,
			Site -> Link[$Site],
			Name->"Test plate 1 for ExperimentFluorescencePolarizationPreview"<>$SessionUUID
		|>;

		plate1=Upload[platePacket];

		samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
			Name->"Test sample 1 for ExperimentFluorescencePolarizationPreview"<>$SessionUUID,
			InitialAmount->100 Microliter
		]
	],
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::InstrumentUndergoingMaintenance];

		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	]
];


(* ::Subsection::Closed:: *)
(*ExperimentFluorescencePolarizationOptions*)
DefineTests[
	ExperimentFluorescencePolarizationOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentFluorescencePolarizationOptions[Object[Sample,"Test sample 1 for ExperimentFluorescencePolarizationOptions"<>$SessionUUID]],
			_Grid
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentFluorescencePolarizationOptions[Object[Sample,"Test sample 1 for ExperimentFluorescencePolarizationOptions"<>$SessionUUID],
				Instrument -> Model[Instrument, PlateReader, "PHERAstar FS"],
				EmissionWavelength->420 Nanometer,
				ExcitationWavelength->680 Nanometer
			],
			_Grid,
			Messages:>{
				Warning::WavelengthsSwapped,
				Error::EmissionWavelengthUnavailable,
				Error::ExcitationWavelengthUnavailable,
				Error::InvalidOption
			}
		],
		Example[
			{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentFluorescencePolarizationOptions[{Object[Sample,"Test sample 1 for ExperimentFluorescencePolarizationOptions"<>$SessionUUID]},OutputFormat->List],
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

		platePacket=<|
			Type->Object[Container,Plate],
			Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],
			DeveloperObject->True,
			Site -> Link[$Site],
			Name->"Test plate 1 for ExperimentFluorescencePolarizationOptions"<>$SessionUUID
		|>;

		plate1=Upload[platePacket];

		samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
			Name->"Test sample 1 for ExperimentFluorescencePolarizationOptions"<>$SessionUUID,
			InitialAmount->100 Microliter
		]
	],

	SymbolTearDown:>Module[{},
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	]
];

(* ::Subsection::Closed:: *)
(*ValidExperimentFluorescencePolarizationQ*)

DefineTests[
	ValidExperimentFluorescencePolarizationQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issue:"},
			ValidExperimentFluorescencePolarizationQ[Object[Sample,"Test sample 1 for ValidExperimentFluorescencePolarizationQ"<>$SessionUUID]],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentFluorescencePolarizationQ[Object[Sample,"Test sample 1 for ValidExperimentFluorescencePolarizationQ"<>$SessionUUID],
				PlateReaderMix->False,
				PlateReaderMixTime-> 30 Second
			],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentFluorescencePolarizationQ[Object[Sample,"Test sample 1 for ValidExperimentFluorescencePolarizationQ"<>$SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentFluorescencePolarizationQ[Object[Sample,"Test sample 1 for ValidExperimentFluorescencePolarizationQ"<>$SessionUUID],Verbose->True],
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

		platePacket=<|
			Type->Object[Container,Plate],
			Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],
			DeveloperObject->True,
			Site -> Link[$Site],
			Name->"Test plate 1 for ValidExperimentFluorescencePolarizationQ"<>$SessionUUID
		|>;

		plate1=Upload[platePacket];

		samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
			Name->"Test sample 1 for ValidExperimentFluorescencePolarizationQ"<>$SessionUUID,
			InitialAmount->100 Microliter
		]
	],
	SymbolTearDown:>Module[{},
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	]
];
