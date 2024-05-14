(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentFluorescenceIntensityPreview*)
DefineTests[
	ExperimentFluorescenceIntensityPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentFluorescenceIntensity:"},
			ExperimentFluorescenceIntensityPreview[Object[Sample,"Test sample 1 for ExperimentFluorescenceIntensityPreview"<>$SessionUUID]],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed try using ExperimentFluorescenceIntensityOptions:"},
			ExperimentFluorescenceIntensityOptions[Object[Sample,"Test sample 1 for ExperimentFluorescenceIntensityPreview"<>$SessionUUID]],
			_Grid
		],
		Example[{Additional,"The inputs and options can also be checked to verify that the experiment can be safely run:"},
			ValidExperimentFluorescenceIntensityQ[Object[Sample,"Test sample 1 for ExperimentFluorescenceIntensityPreview"<>$SessionUUID],Verbose->Failures],
			True
		]
	},
	Stubs:>{
	(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{platePacket,vesselPacket,bottlePacket,incompatibleChemicalPacket,
			plate1,plate2,emptyPlate,vessel1,vessel2,vessel3,vessel4,vessel5,bottle1,
			numberOfInputSamples,sampleNames,numberOfInjectionSamples,injectionSampleNames,samples},
			ClearMemoization[];
			$CreatedObjects={};

			platePacket=<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],
				DeveloperObject->True,
				Site -> Link[$Site],
				Name->"Test plate 1 for ExperimentFluorescenceIntensityPreview"<>$SessionUUID
			|>;

			plate1=Upload[platePacket];

			samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
				Name->"Test sample 1 for ExperimentFluorescenceIntensityPreview"<>$SessionUUID,
				InitialAmount->100 Microliter
			];
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{},
			EraseObject[$CreatedObjects,Force->True,Verbose->False];
			Unset[$CreatedObjects]
		]
	)
];


(* ::Subsection::Closed:: *)
(*ExperimentFluorescenceIntensityOptions*)
DefineTests[
	ExperimentFluorescenceIntensityOptions,
	{
		Example[{Basic,"Display the option values which will be used in the experiment:"},
			ExperimentFluorescenceIntensityOptions[Object[Sample,"Test sample 1 for ExperimentFluorescenceIntensityOptions"<>$SessionUUID]],
			_Grid
		],
		Example[{Basic,"Any potential issues with provided inputs/options will be displayed:"},
			ExperimentFluorescenceIntensityOptions[Object[Sample,"Test sample 1 for ExperimentFluorescenceIntensityOptions"<>$SessionUUID],
				EmissionWavelength->420 Nanometer,
				ExcitationWavelength->680 Nanometer
			],
			_Grid,
			Messages:>{Warning::WavelengthsSwapped}
		],
		Example[
			{Options,OutputFormat,"If OutputFormat -> List, return a list of options:"},
			ExperimentFluorescenceIntensityOptions[{Object[Sample,"Test sample 1 for ExperimentFluorescenceIntensityOptions"<>$SessionUUID]},OutputFormat->List],
			{(_Rule|_RuleDelayed)..}
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{platePacket,vesselPacket,bottlePacket,incompatibleChemicalPacket,
			plate1,plate2,emptyPlate,vessel1,vessel2,vessel3,vessel4,vessel5,bottle1,
			numberOfInputSamples,sampleNames,numberOfInjectionSamples,injectionSampleNames,samples},
			ClearMemoization[];
			$CreatedObjects={};

			platePacket=<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],
				DeveloperObject->True,
				Site -> Link[$Site],
				Name->"Test plate 1 for ExperimentFluorescenceIntensityOptions"<>$SessionUUID
			|>;

			plate1=Upload[platePacket];

			samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
				Name->"Test sample 1 for ExperimentFluorescenceIntensityOptions"<>$SessionUUID,
				InitialAmount->100 Microliter
			];
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{},
			EraseObject[$CreatedObjects,Force->True,Verbose->False];
			Unset[$CreatedObjects]
		]
	)
];

(* ::Subsection::Closed:: *)
(*ValidExperimentFluorescenceIntensityQ*)

DefineTests[
	ValidExperimentFluorescenceIntensityQ,
	{
		Example[{Basic,"Verify that the experiment can be run without issue:"},
			ValidExperimentFluorescenceIntensityQ[Object[Sample,"Test sample 1 for ValidExperimentFluorescenceIntensityQ"<>$SessionUUID]],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentFluorescenceIntensityQ[Object[Sample,"Test sample 1 for ValidExperimentFluorescenceIntensityQ"<>$SessionUUID],
				PlateReaderMix->False,
				PlateReaderMixTime-> 30 Second
			],
			False
		],
		Example[{Options,OutputFormat,"Return a test summary:"},
			ValidExperimentFluorescenceIntensityQ[Object[Sample,"Test sample 1 for ValidExperimentFluorescenceIntensityQ"<>$SessionUUID],OutputFormat->TestSummary],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Print verbose messages reporting test passage/failure:"},
			ValidExperimentFluorescenceIntensityQ[Object[Sample,"Test sample 1 for ValidExperimentFluorescenceIntensityQ"<>$SessionUUID],Verbose->True],
			True
		]
	},
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	},
	SymbolSetUp:>(
		(* Turn off warnings related to the state of the lab - is okay if we're using a model with no current instances *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{platePacket,vesselPacket,bottlePacket,incompatibleChemicalPacket,
			plate1,plate2,emptyPlate,vessel1,vessel2,vessel3,vessel4,vessel5,bottle1,
			numberOfInputSamples,sampleNames,numberOfInjectionSamples,injectionSampleNames,samples},
			ClearMemoization[];
			$CreatedObjects={};

			platePacket=<|
				Type->Object[Container,Plate],
				Model->Link[Model[Container, Plate, "96-well Black Wall Plate"],Objects],
				DeveloperObject->True,
				Site -> Link[$Site],
				Name->"Test plate 1 for ValidExperimentFluorescenceIntensityQ"<>$SessionUUID
			|>;

			plate1=Upload[platePacket];

			samples=UploadSample[Model[Sample,StockSolution,"0.2M FITC"],{"A1",plate1},
				Name->"Test sample 1 for ValidExperimentFluorescenceIntensityQ"<>$SessionUUID,
				InitialAmount->100 Microliter
			];
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{},
			EraseObject[$CreatedObjects,Force->True,Verbose->False];
			Unset[$CreatedObjects]
		]
	)
]