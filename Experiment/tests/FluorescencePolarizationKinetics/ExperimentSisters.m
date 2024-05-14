(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentFluorescencePolarizationKineticsPreview*)
DefineTests[
	ExperimentFluorescencePolarizationKineticsPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentFluorescencePolarizationKinetics:"},
			ExperimentFluorescencePolarizationKineticsPreview[Object[Sample,"Test sample 1 for ExperimentFluorescencePolarizationKineticsPreview"<>$SessionUUID]],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed try using ExperimentFluroescenceKineticsOptions:"},
			ExperimentFluorescencePolarizationKineticsOptions[Object[Sample,"Test sample 1 for ExperimentFluorescencePolarizationKineticsPreview"<>$SessionUUID]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run:"},
			ValidExperimentFluorescencePolarizationKineticsQ[Object[Sample,"Test sample 1 for ExperimentFluorescencePolarizationKineticsPreview"<>$SessionUUID],Verbose->Failures],
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
			Name->"Test plate 1 for ExperimentFluorescencePolarizationKineticsPreview"<>$SessionUUID
		|>;

		plate1=Upload[platePacket];

		samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
			Name->"Test sample 1 for ExperimentFluorescencePolarizationKineticsPreview"<>$SessionUUID,
			InitialAmount->100 Microliter
		]
	],
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	]
];


(* ::Subsection::Closed:: *)
(*ExperimentFluorescencePolarizationKineticsOptions*)
DefineTests[
	ExperimentFluorescencePolarizationKineticsOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentFluorescencePolarizationKineticsOptions[Object[Sample,"Test sample 1 for ExperimentFluorescencePolarizationKineticsOptions"<>$SessionUUID]],
			_Grid
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentFluorescencePolarizationKineticsOptions[Object[Sample,"Test sample 1 for ExperimentFluorescencePolarizationKineticsOptions"<>$SessionUUID],
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
			ExperimentFluorescencePolarizationKineticsOptions[{Object[Sample,"Test sample 1 for ExperimentFluorescencePolarizationKineticsOptions"<>$SessionUUID]},OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},

	Stubs:>{
	(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},

	SymbolSetUp:>Module[
		{platePacket,vesselPacket,bottlePacket,incompatibleChemicalPacket,
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
			Name->"Test plate 1 for ExperimentFluorescencePolarizationKineticsOptions"<>$SessionUUID
		|>;

		plate1=Upload[platePacket];

		samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
			Name->"Test sample 1 for ExperimentFluorescencePolarizationKineticsOptions"<>$SessionUUID,
			InitialAmount->100 Microliter
		]
	],
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	]
];

(* ::Subsection::Closed:: *)
(*ValidExperimentFluorescencePolarizationKineticsQ*)

DefineTests[
	ValidExperimentFluorescencePolarizationKineticsQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issue:"},
			ValidExperimentFluorescencePolarizationKineticsQ[Object[Sample,"Test sample 1 for ValidExperimentFluorescencePolarizationKineticsQ"<>$SessionUUID]],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentFluorescencePolarizationKineticsQ[Object[Sample,"Test sample 1 for ValidExperimentFluorescencePolarizationKineticsQ"<>$SessionUUID],
				PlateReaderMix->False,
				PlateReaderMixTime-> 30 Second
			],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentFluorescencePolarizationKineticsQ[Object[Sample,"Test sample 1 for ValidExperimentFluorescencePolarizationKineticsQ"<>$SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentFluorescencePolarizationKineticsQ[Object[Sample,"Test sample 1 for ValidExperimentFluorescencePolarizationKineticsQ"<>$SessionUUID],Verbose->True],
			True
		]
	},
	Stubs:>{
	(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>Module[
		{platePacket,vesselPacket,bottlePacket,incompatibleChemicalPacket,
		plate1,plate2,emptyPlate,vessel1,vessel2,vessel3,vessel4,vessel5,bottle1,
		numberOfInputSamples,sampleNames,numberOfInjectionSamples,injectionSampleNames,samples},

		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		platePacket=<|
			Type->Object[Container,Plate],
			Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],
			DeveloperObject->True,
			Name->"Test plate 1 for ValidExperimentFluorescencePolarizationKineticsQ"<>$SessionUUID,
			Site -> Link[$Site]
		|>;

		plate1=Upload[platePacket];

		samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
			Name->"Test sample 1 for ValidExperimentFluorescencePolarizationKineticsQ"<>$SessionUUID,
			InitialAmount->100 Microliter
		]
	],
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects]
	]
];
