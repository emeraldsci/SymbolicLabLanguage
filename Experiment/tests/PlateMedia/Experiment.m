DefineTests[ExperimentPlateMedia,
	{
		Example[{Basic, "Create a protocol for preparing 10 plates of LB agar by manual plating:"},
			ExperimentPlateMedia[Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PlateOut->Model[Container,Plate,"Omni Tray Sterile Media Plate"],
				PlatingVolume->25Milliliter,
				NumberOfPlates->10
			],
			ObjectP[Object[Protocol,PlateMedia]]
		],
		Example[{Basic,"Create a protocol for preparing 10 plates of LB agar using the serial filler:"},
			ExperimentPlateMedia[Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PlateOut->Model[Container,Plate,"Omni Tray Sterile Media Plate"],
				PlatingVolume->25Milliliter,
				NumberOfPlates->10,
				PlatingMethod->Pump
			],
			ObjectP[Object[Protocol,PlateMedia]]
		],
		Example[{Basic,"Create a protocol for preparing 10 plates of LB agar by thawing an existing bottle of solid LB Agar media under the specified conditions:"},
			ExperimentPlateMedia[Object[Sample,"Test sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PlateOut->Model[Container,Plate,"Omni Tray Sterile Media Plate"],
				PlatingVolume->25Milliliter,
				NumberOfPlates->10,
				PrePlatingIncubationTime->45Minute,
				PlatingTemperature->96*Celsius
			],
			ObjectP[Object[Protocol,PlateMedia]]
		],
		Example[{Basic,"Create a protocol for preparing 1 plate of LB agar and 10 plates of YPD agar:"},
			ExperimentPlateMedia[{Model[Sample,Media,"Test media model for ExperimentPlateMedia (YPD, solid w/2% Agar)"<>$SessionUUID],Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID]},
				PlateOut->Model[Container,Plate,"Omni Tray Sterile Media Plate"],
				PlatingVolume->{20Milliliter,20Milliliter},
				NumberOfPlates-> {1,10}
			],
			ObjectP[Object[Protocol,PlateMedia]]
		],
		Example[{Basic,"Create a protocol for plating 2 mL of LB agar and 2 mL of YPD agar each into a different well in the same plate"},
			ExperimentPlateMedia[{Model[Sample,Media,"Test media model for ExperimentPlateMedia (YPD, solid w/2% Agar)"<>$SessionUUID],Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID]},
				PlateOut->{{1,Model[Container, Plate, "6-well Tissue Culture Plate"]}, {1,Model[Container, Plate, "6-well Tissue Culture Plate"]}},
				PlatingVolume->{2Milliliter,2Milliliter},
				DestinationWell->{{"A1"},{"B2","A2"}}
			],
			ObjectP[Object[Protocol,PlateMedia]]
		],
		Example[{Messages,"PlateOutDestinationWellMismatch", "Throw an error if the specified DestinationWell is not a valid position for the specified PlateOut:"},
			ExperimentPlateMedia[Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PlateOut->Model[Container,Plate,"Omni Tray Sterile Media Plate"],
				DestinationWell->{"A2"}
			],
			$Failed,
			Messages:>{Error::PlateOutDestinationWellMismatch,Error::InvalidOption}
		],
		Example[{Messages,"PlatingVolumeExceedsHalfMaxVolume", "Throw a warning if the user-specified PlateVolume is greater than half of the MaxVolume for the given PlateOut:"},
			ExperimentPlateMedia[Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PlateOut->Model[Container,Plate,"Omni Tray Sterile Media Plate"],
				PlatingVolume->50Milliliter
			],
			ObjectP[Object[Protocol,PlateMedia]],
			Messages:>{Warning::PlatingVolumeExceedsHalfMaxVolume}
		],
		Example[{Messages,"InsufficientMediaForPlating","Throw an error if there is not enough volume of the input media sample to prepare the user-specified NumberOfPlates of media plates in the given PlateOut:"},
			ExperimentPlateMedia[
				Object[Sample,"Test sample insufficient media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PlateOut->Model[Container,Plate,"Omni Tray Sterile Media Plate"],
				NumberOfPlates->10
			],
			$Failed,
			Messages:>{Error::InsufficientMediaForPlating,Error::InvalidOption}
		],
		Example[{Message,"PlatingMethodPumpInstrumentMismatch","Throw an error if Pump is specified for the PlatingMethod option but a serological pipette is specified for the Instrument option"},
			ExperimentPlateMedia[Object[Sample,"Test sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PlatingMethod->Pump,
				Instrument->Model[Instrument,Pipette,"pipetus"]
			],
			$Failed,
			Messages:>{Error::PlatingMethodPumpInstrumentMismatch,Error::InvalidOption}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a media model that does not exist (name form):"},
			ExperimentPlateMedia[Model[Sample, Media, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a media model that does not exist (ID form):"},
			ExperimentPlateMedia[Model[Sample, Media, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		]
	},
	SetUp:>{
		$CreatedObjects={};
	},
	TearDown:>{
		EraseObject[$CreatedObjects,Force->True];
		Unset[$CreatedObjects];
	},
	SymbolSetUp:>{
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objects,existsFilter,fakeBench,mediaSampleLabels,mediaModelLabels,allMediaContainerPackets,allMediaSamplePackets},
			objects={
				Object[Container,Bench,"Fake bench for ExperimentPlateMedia tests"<>$SessionUUID],
				Model[Sample,"Ampicillin for ExperimentPlateMedia"<>$SessionUUID],
				Model[Sample,"Fixed amount ampicillin for ExperimentPlateMedia"<>$SessionUUID],
				Model[Sample,"Agar for ExperimentPlateMedia"<>$SessionUUID],
				Model[Sample,"Agar without Melting Point for ExperimentPlateMedia"<>$SessionUUID],
				Model[Sample,"LB Broth Miller Template Model for ExperimentPlateMedia"<>$SessionUUID],
				Model[Sample,Media,"Liquid LB for ExperimentPlateMedia"<>$SessionUUID],
				Model[Sample,Media,"New LB from a template LB model"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, liquid) + 50ug/mL Ampicillin"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, solid w/2% Agar) + Redundant Agar"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, liquid) + 50ug/mL Ampicillin"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, liquid) + 100ug/mL Ampicillin"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (YPD, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (YPD, solid w/2% Agar)"<>$SessionUUID],
				Model[Sample,Media,"Salt water media model for ExperimentPlateMedia"<>$SessionUUID],
				Model[Sample,Media,"DropOut of Sodium Chloride from Salt Water"<>$SessionUUID],
				Model[Sample,Media,"DropOut of Uracil from Salt Water not possible"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (yeast synthetic complete medium, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (yeast synthetic complete medium, liquid) - Uracil"<>$SessionUUID],
				Object[Sample,"Test sample media for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID],
				Object[Sample,"Test sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Sample,"Test sample insufficient media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for ExperimentPlateMedia (LB, partially melted solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container 2 for test sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID]
			};
			
			(* Check whether the objects already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];
			
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];
			
			(* Set up fake bench *)
			fakeBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Fake bench for ExperimentPlateMedia tests"<>$SessionUUID,DeveloperObject->True|>];
			
			UploadMedia[{{10*Gram,Model[Sample,"Sodium Chloride"]},{980*Milliliter,Model[Sample,"Milli-Q water"]}},
				Model[Sample,"Milli-Q water"],
				1*Liter,
				MediaName->"Salt water media model for ExperimentPlateMedia"<>$SessionUUID
			];
			
			(* Test LB solid media with 2% Agar *)
			With[{agar = UploadSampleModel["Agar for ExperimentPlateMedia"<>$SessionUUID,Composition->{{100*MassPercent,Model[Molecule,"Agar"]}},State->Solid,MeltingPoint->85*Celsius,Expires->False,DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"]]},
				UploadMedia[
					{
						Model[Sample,Media,"LB Broth, Miller"],
						Model[Sample,Media,"LB Broth, Miller"],
						Model[Sample,Media,"Yeast Peptone Dextrose Medium"],
						Model[Sample,Media,"Yeast Peptone Dextrose Medium"]
					},
					MediaName->{
						"Test media model for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID,
						"Test media model for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID,
						"Test media model for ExperimentPlateMedia (YPD, liquid)"<>$SessionUUID,
						"Test media model for ExperimentPlateMedia (YPD, solid w/2% Agar)"<>$SessionUUID
					},
					GellingAgents->{None,{{20*Gram/Liter,agar}},None,{{20*Gram/Liter,agar}}}
				]
			];
			
			(* Test LB liquid media with 50ug/mL Ampicillin *)
			With[{ampicillin = UploadSampleModel["Ampicillin for ExperimentPlateMedia"<>$SessionUUID,Composition->{{100*MassPercent,Model[Molecule,"Ampicillin"]}},State->Solid,Expires->False,DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"]]},
				UploadMedia[
					Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID],
					Supplements->{{50*Milligram,ampicillin}},
					MediaName->"Test media model for ExperimentPlateMedia (LB, liquid) + 50ug/mL Ampicillin"<>$SessionUUID
				]
			];
			
			(* Test LB media Object[Sample] *)
			With[{containers = UploadSample[{Model[Container, Vessel, "1L Glass Bottle"],Model[Container, Vessel, "1L Glass Bottle"],Model[Container, Vessel, "1L Glass Bottle"]},
				{
					{"Bench Top Slot",Object[Container,Bench,"Fake bench for ExperimentPlateMedia tests"<>$SessionUUID]},
					{"Bench Top Slot",Object[Container,Bench,"Fake bench for ExperimentPlateMedia tests"<>$SessionUUID]},
					{"Bench Top Slot",Object[Container,Bench,"Fake bench for ExperimentPlateMedia tests"<>$SessionUUID]}
				},
				Name->{
					"Container for test sample media for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID,
					"Container for test sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID,
					"Container 2 for test sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID
				}]},
				UploadSample[{Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID],Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID]},
					{
						{"A1",containers[[1]]},
						{"A1",containers[[2]]},
						{"A1",containers[[3]]}
					},
					InitialAmount->{1Liter,1Liter,100Microliter},
					Name->{
						"Test sample media for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID,
						"Test sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID,
						"Test sample insufficient media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID
					}
				]
			];
			
			mediaSampleLabels={
				"(LB, liquid)",
				"(LB, solid w/2% Agar)",
				"(LB, partially melted solid w/2% Agar)"
			};
			mediaModelLabels={
				"(LB, liquid)",
				"(LB, solid w/2% Agar)",
				"(LB, partially melted solid w/2% Agar)",
				"(YPD, liquid)",
				"(yeast synthetic complete medium, liquid)",
				"(yeast synthetic complete medium, liquid) - Uracil"
			};
			(* Upload containers for the Test media model objects *)
			allMediaContainerPackets=Map[Association[
				Type->Object[Container,Vessel],
				Model->Link[Model[Container, Vessel, "1L Glass Bottle"],Objects],
				Name->"Test container for sample media for ExperimentPlateMedia "<>#<>$SessionUUID
			]&,mediaSampleLabels];
			
			allMediaSamplePackets=Map[Association[
				Type->Object[Sample,Media],
				Model->Model[Sample,Media,"Test media model for ExperimentPlateMedia "<>#<>$SessionUUID],
				Amount->1*Liter
			]&,mediaSampleLabels];
		]
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		
		Module[{objects,existsFilter},
			objects={
				Object[Container,Bench,"Fake bench for ExperimentPlateMedia tests"<>$SessionUUID],
				Model[Sample,"Ampicillin for ExperimentPlateMedia"<>$SessionUUID],
				Model[Sample,"Fixed amount ampicillin for ExperimentPlateMedia"<>$SessionUUID],
				Model[Sample,"Agar for ExperimentPlateMedia"<>$SessionUUID],
				Model[Sample,"Agar without Melting Point for ExperimentPlateMedia"<>$SessionUUID],
				Model[Sample,"LB Broth Miller Template Model for ExperimentPlateMedia"<>$SessionUUID],
				Model[Sample,Media,"Liquid LB for ExperimentPlateMedia"<>$SessionUUID],
				Model[Sample,Media,"New LB from a template LB model"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, liquid) + 50ug/mL Ampicillin"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, solid w/2% Agar) + Redundant Agar"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, liquid) + 50ug/mL Ampicillin"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, liquid) + 100ug/mL Ampicillin"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (YPD, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (YPD, solid w/2% Agar)"<>$SessionUUID],
				Model[Sample,Media,"Salt water media model for ExperimentPlateMedia"<>$SessionUUID],
				Model[Sample,Media,"DropOut of Sodium Chloride from Salt Water"<>$SessionUUID],
				Model[Sample,Media,"DropOut of Uracil from Salt Water not possible"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (yeast synthetic complete medium, liquid)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMedia (yeast synthetic complete medium, liquid) - Uracil"<>$SessionUUID],
				Object[Sample,"Test sample media for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID],
				Object[Sample,"Test sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Sample,"Test sample insufficient media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for ExperimentPlateMedia (LB, partially melted solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container 2 for test sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID]
			};
			
			(* Check whether the objects already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];
			
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];
		]
	}
];

(* ::Subsubsection:: *)
(*ExperimentPlateMediaOptions*)

DefineTests[
	ExperimentPlateMediaOptions,
	{
		Example[{Basic,"Return a table of resolved options for an ExperimentPlateMedia call to prepare plates from a media model:"},
			ExperimentPlateMediaOptions[Model[Sample,Media,"Test media model for ExperimentPlateMediaOptions (LB, solid w/2% Agar)"<>$SessionUUID]],
			_Grid
		],
		Example[{Basic,"Return a table of resolved options for an ExperimentPlateMedia call to prepare plates from a media object:"},
			ExperimentPlateMediaOptions[Object[Sample,"Test sample media for ExperimentPlateMediaOptions (LB, solid w/2% Agar)"<>$SessionUUID]],
			_Grid
		],
		Example[{Basic,"Return a table of resolved options for an ExperimentPlateMedia call to prepare plates from multiple media models:"},
			ExperimentPlateMediaOptions[
				{
					Model[Sample,Media,"Test media model for ExperimentPlateMediaOptions (LB, solid w/1% Agar)"<>$SessionUUID],
					Model[Sample,Media,"Test media model for ExperimentPlateMediaOptions (LB, solid w/2% Agar)"<>$SessionUUID]
				}
			],
			_Grid
		],
		Example[{Basic,"Return a table of resolved options for an ExperimentPlateMedia call to prepare plates from multiple media objects:"},
			ExperimentPlateMediaOptions[
				{
					Object[Sample,"Test sample media for ExperimentPlateMediaOptions (LB, solid w/1% Agar)"<>$SessionUUID],
					Object[Sample,"Test sample media for ExperimentPlateMediaOptions (LB, solid w/2% Agar)"<>$SessionUUID]
				}
			],
			_Grid
		],

		(* --- Options Examples --- *)
		Example[{Options, OutputFormat ,"Generate a resolved list of options for an ExperimentPlateMedia call to prepare plates for a media model:"},
			ExperimentPlateMediaOptions[Model[Sample,Media,"Test media model for ExperimentPlateMediaOptions (LB, solid w/2% Agar)"<>$SessionUUID], OutputFormat -> List],
			_?(MatchQ[
				Check[SafeOptions[ExperimentPlateMedia, #], $Failed, {Error::Pattern}],
				{(_Rule | _RuleDelayed)..}
			]&)
		]
	},
	SymbolSetUp:>{
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objects,existsFilter,testBench},
			objects={
				Object[Container,Bench,"Test bench for ExperimentPlateMediaOptions tests"<>$SessionUUID],
				Model[Sample,"Agar for ExperimentPlateMediaOptions"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMediaOptions (LB, solid w/1% Agar)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMediaOptions (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Sample,"Test sample media for ExperimentPlateMediaOptions (LB, solid w/1% Agar)"<>$SessionUUID],
				Object[Sample,"Test sample media for ExperimentPlateMediaOptions (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ExperimentPlateMediaOptions (LB, solid w/1% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ExperimentPlateMediaOptions (LB, solid w/2% Agar)"<>$SessionUUID]
			};

			(* Check whether the objects already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];

			(* Set up fake bench *)
			testBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Test bench for ExperimentPlateMediaOptions tests"<>$SessionUUID,DeveloperObject->True|>];

			(* Test LB solid media with 2% Agar *)
			With[{agar = UploadSampleModel["Agar for ExperimentPlateMediaOptions"<>$SessionUUID,Composition->{{100*MassPercent,Model[Molecule,"Agar"]}},State->Solid,MeltingPoint->85*Celsius,Expires->False,DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"]]},
				UploadMedia[
					{
						Model[Sample,Media,"LB Broth, Miller"],
						Model[Sample,Media,"LB Broth, Miller"]
					},
					MediaName->{
						"Test media model for ExperimentPlateMediaOptions (LB, solid w/1% Agar)"<>$SessionUUID,
						"Test media model for ExperimentPlateMediaOptions (LB, solid w/2% Agar)"<>$SessionUUID
					},
					GellingAgents->{{{10*Gram/Liter,agar}},{{20*Gram/Liter,agar}}}
				]
			];

			(* Test LB media Object[Sample] *)
			With[{containers = UploadSample[{Model[Container, Vessel, "1L Glass Bottle"],Model[Container, Vessel, "1L Glass Bottle"]},
				{
					{"Bench Top Slot",Object[Container,Bench,"Test bench for ExperimentPlateMediaOptions tests"<>$SessionUUID]},
					{"Bench Top Slot",Object[Container,Bench,"Test bench for ExperimentPlateMediaOptions tests"<>$SessionUUID]}
				},
				Name->{
					"Container for test sample media for ExperimentPlateMediaOptions (LB, solid w/1% Agar)"<>$SessionUUID,
					"Container for test sample media for ExperimentPlateMediaOptions (LB, solid w/2% Agar)"<>$SessionUUID
				}]},
				UploadSample[{Model[Sample,Media,"Test media model for ExperimentPlateMediaOptions (LB, solid w/1% Agar)"<>$SessionUUID],Model[Sample,Media,"Test media model for ExperimentPlateMediaOptions (LB, solid w/2% Agar)"<>$SessionUUID]},
					{
						{"A1",containers[[1]]},
						{"A1",containers[[2]]}
					},
					InitialAmount->{1Liter,1Liter},
					Name->{
						"Test sample media for ExperimentPlateMediaOptions (LB, solid w/1% Agar)"<>$SessionUUID,
						"Test sample media for ExperimentPlateMediaOptions (LB, solid w/2% Agar)"<>$SessionUUID
					}
				]
			];
		]
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects,existsFilter},
			objects={
				Object[Container,Bench,"Test bench for ExperimentPlateMediaOptions tests"<>$SessionUUID],
				Model[Sample,"Agar for ExperimentPlateMediaOptions"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMediaOptions (LB, solid w/1% Agar)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMediaOptions (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Sample,"Test sample media for ExperimentPlateMediaOptions (LB, solid w/1% Agar)"<>$SessionUUID],
				Object[Sample,"Test sample media for ExperimentPlateMediaOptions (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ExperimentPlateMediaOptions (LB, solid w/1% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ExperimentPlateMediaOptions (LB, solid w/2% Agar)"<>$SessionUUID]
			};

			(* Check whether the objects already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];
		]
	}
];

(* ::Subsubsection:: *)
(*ValidExperimentPlateMediaQ*)

DefineTests[
	ValidExperimentPlateMediaQ,
	{
		Example[{Basic,"Validate an ExperimentPlateMedia call to prepare plates from a media model:"},
			ValidExperimentPlateMediaQ[Model[Sample,Media,"Test media model for ValidExperimentPlateMediaQ (LB, solid w/2% Agar)"<>$SessionUUID]],
			True
		],
		Example[{Basic,"Validate an ExperimentPlateMedia call to prepare plates from a media object:"},
			ValidExperimentPlateMediaQ[Object[Sample,"Test sample media for ValidExperimentPlateMediaQ (LB, solid w/2% Agar)"<>$SessionUUID]],
			True
		],
		Example[{Basic,"Validate an ExperimentPlateMedia call to prepare plates from multiple media models:"},
			ValidExperimentPlateMediaQ[
				{
					Model[Sample,Media,"Test media model for ValidExperimentPlateMediaQ (LB, solid w/1% Agar)"<>$SessionUUID],
					Model[Sample,Media,"Test media model for ValidExperimentPlateMediaQ (LB, solid w/2% Agar)"<>$SessionUUID]
				}
			],
			True
		],
		Example[{Basic,"Validate an ExperimentPlateMedia call to prepare plates from multiple media objects:"},
			ValidExperimentPlateMediaQ[
				{
					Object[Sample,"Test sample media for ValidExperimentPlateMediaQ (LB, solid w/1% Agar)"<>$SessionUUID],
					Object[Sample,"Test sample media for ValidExperimentPlateMediaQ (LB, solid w/2% Agar)"<>$SessionUUID]
				}
			],
			True
		],

		(* --- Options Examples --- *)
		Example[{Options,OutputFormat,"Validate an ExperimentPlateMedia call to prepare plates from a model, returning an ECL Test Summary:"},
			ValidExperimentPlateMediaQ[Model[Sample,Media,"Test media model for ValidExperimentPlateMediaQ (LB, solid w/2% Agar)"<>$SessionUUID], OutputFormat -> TestSummary],
		    _EmeraldTestSummary
		],
		Example[{Options,Verbose,"Validate an ExperimentPlateMedia call to prepare plates from a model, printing a verbose summary of tests as they are run:"},
			ValidExperimentPlateMediaQ[Model[Sample,Media,"Test media model for ValidExperimentPlateMediaQ (LB, solid w/2% Agar)"<>$SessionUUID], Verbose -> True],
			True
		]
	},
	SymbolSetUp:>{
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objects,existsFilter,testBench},
			objects={
				Object[Container,Bench,"Test bench for ValidExperimentPlateMediaQ tests"<>$SessionUUID],
				Model[Sample,"Agar for ValidExperimentPlateMediaQ"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ValidExperimentPlateMediaQ (LB, solid w/1% Agar)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ValidExperimentPlateMediaQ (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Sample,"Test sample media for ValidExperimentPlateMediaQ (LB, solid w/1% Agar)"<>$SessionUUID],
				Object[Sample,"Test sample media for ValidExperimentPlateMediaQ (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ValidExperimentPlateMediaQ (LB, solid w/1% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ValidExperimentPlateMediaQ (LB, solid w/2% Agar)"<>$SessionUUID]
			};

			(* Check whether the objects already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];

			(* Set up fake bench *)
			testBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Test bench for ValidExperimentPlateMediaQ tests"<>$SessionUUID,DeveloperObject->True|>];

			(* Test LB solid media with 2% Agar *)
			With[{agar = UploadSampleModel["Agar for ValidExperimentPlateMediaQ"<>$SessionUUID,Composition->{{100*MassPercent,Model[Molecule,"Agar"]}},State->Solid,MeltingPoint->85*Celsius,Expires->False,DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"]]},
				UploadMedia[
					{
						Model[Sample,Media,"LB Broth, Miller"],
						Model[Sample,Media,"LB Broth, Miller"]
					},
					MediaName->{
						"Test media model for ValidExperimentPlateMediaQ (LB, solid w/1% Agar)"<>$SessionUUID,
						"Test media model for ValidExperimentPlateMediaQ (LB, solid w/2% Agar)"<>$SessionUUID
					},
					GellingAgents->{{{10*Gram/Liter,agar}},{{20*Gram/Liter,agar}}}
				]
			];

			(* Test LB media Object[Sample] *)
			With[{containers = UploadSample[{Model[Container, Vessel, "1L Glass Bottle"],Model[Container, Vessel, "1L Glass Bottle"]},
				{
					{"Bench Top Slot",Object[Container,Bench,"Test bench for ValidExperimentPlateMediaQ tests"<>$SessionUUID]},
					{"Bench Top Slot",Object[Container,Bench,"Test bench for ValidExperimentPlateMediaQ tests"<>$SessionUUID]}
				},
				Name->{
					"Container for test sample media for ValidExperimentPlateMediaQ (LB, solid w/1% Agar)"<>$SessionUUID,
					"Container for test sample media for ValidExperimentPlateMediaQ (LB, solid w/2% Agar)"<>$SessionUUID
				}]},
				UploadSample[{Model[Sample,Media,"Test media model for ValidExperimentPlateMediaQ (LB, solid w/1% Agar)"<>$SessionUUID],Model[Sample,Media,"Test media model for ValidExperimentPlateMediaQ (LB, solid w/2% Agar)"<>$SessionUUID]},
					{
						{"A1",containers[[1]]},
						{"A1",containers[[2]]}
					},
					InitialAmount->{1Liter,1Liter},
					Name->{
						"Test sample media for ValidExperimentPlateMediaQ (LB, solid w/1% Agar)"<>$SessionUUID,
						"Test sample media for ValidExperimentPlateMediaQ (LB, solid w/2% Agar)"<>$SessionUUID
					}
				]
			];
		]
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects,existsFilter},
			objects={
				Object[Container,Bench,"Test bench for ValidExperimentPlateMediaQ tests"<>$SessionUUID],
				Model[Sample,"Agar for ValidExperimentPlateMediaQ"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ValidExperimentPlateMediaQ (LB, solid w/1% Agar)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ValidExperimentPlateMediaQ (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Sample,"Test sample media for ValidExperimentPlateMediaQ (LB, solid w/1% Agar)"<>$SessionUUID],
				Object[Sample,"Test sample media for ValidExperimentPlateMediaQ (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ValidExperimentPlateMediaQ (LB, solid w/1% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ValidExperimentPlateMediaQ (LB, solid w/2% Agar)"<>$SessionUUID]
			};

			(* Check whether the objects already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];
		]
	}
];

(* ::Subsubsection:: *)
(*ExperimentPlateMediaPreview*)

DefineTests[
	ExperimentPlateMediaPreview,
	{
		Example[{Basic,"Generate a preview for an ExperimentPlateMedia call to prepare a plate from a media model (will always be Null):"},
			ExperimentPlateMediaPreview[Model[Sample,Media,"Test media model for ExperimentPlateMediaPreview (LB, solid w/2% Agar)"<>$SessionUUID]],
			Null
		],
		Example[{Basic,"Generate a preview for an ExperimentPlateMedia call to prepare a plate from a media object (will always be Null):"},
			ExperimentPlateMediaPreview[Object[Sample,"Test sample media for ExperimentPlateMediaPreview (LB, solid w/2% Agar)"<>$SessionUUID]],
			Null
		],
		Example[{Basic,"Generate a preview for an ExperimentPlateMedia call to prepare a plate from multiple media models (will always be Null):"},
			ExperimentPlateMediaPreview[
				{
					Model[Sample,Media,"Test media model for ExperimentPlateMediaPreview (LB, solid w/1% Agar)"<>$SessionUUID],
					Model[Sample,Media,"Test media model for ExperimentPlateMediaPreview (LB, solid w/2% Agar)"<>$SessionUUID]
				}
			],
			Null
		],
		Example[{Basic,"Generate a preview for an ExperimentPlateMedia call to prepare a plate from multiple media objects (will always be Null):"},
			ExperimentPlateMediaPreview[
				{
					Object[Sample,"Test sample media for ExperimentPlateMediaPreview (LB, solid w/1% Agar)"<>$SessionUUID],
					Object[Sample,"Test sample media for ExperimentPlateMediaPreview (LB, solid w/2% Agar)"<>$SessionUUID]
				}
			],
			Null
		]
	},
	SymbolSetUp:>{
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Module[{objects,existsFilter,testBench},
			objects={
				Object[Container,Bench,"Test bench for ExperimentPlateMediaPreview tests"<>$SessionUUID],
				Model[Sample,"Agar for ExperimentPlateMediaPreview"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMediaPreview (LB, solid w/1% Agar)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMediaPreview (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Sample,"Test sample media for ExperimentPlateMediaPreview (LB, solid w/1% Agar)"<>$SessionUUID],
				Object[Sample,"Test sample media for ExperimentPlateMediaPreview (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ExperimentPlateMediaPreview (LB, solid w/1% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ExperimentPlateMediaPreview (LB, solid w/2% Agar)"<>$SessionUUID]
			};

			(* Check whether the objects already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];

			(* Set up fake bench *)
			testBench=Upload[<|Type->Object[Container,Bench],Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],Name->"Test bench for ExperimentPlateMediaPreview tests"<>$SessionUUID,DeveloperObject->True|>];

			(* Test LB solid media with 2% Agar *)
			With[{agar = UploadSampleModel["Agar for ExperimentPlateMediaPreview"<>$SessionUUID,Composition->{{100*MassPercent,Model[Molecule,"Agar"]}},State->Solid,MeltingPoint->85*Celsius,Expires->False,DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"]]},
				UploadMedia[
					{
						Model[Sample,Media,"LB Broth, Miller"],
						Model[Sample,Media,"LB Broth, Miller"]
					},
					MediaName->{
						"Test media model for ExperimentPlateMediaPreview (LB, solid w/1% Agar)"<>$SessionUUID,
						"Test media model for ExperimentPlateMediaPreview (LB, solid w/2% Agar)"<>$SessionUUID
					},
					GellingAgents->{{{10*Gram/Liter,agar}},{{20*Gram/Liter,agar}}}
				]
			];

			(* Test LB media Object[Sample] *)
			With[{containers = UploadSample[{Model[Container, Vessel, "1L Glass Bottle"],Model[Container, Vessel, "1L Glass Bottle"]},
				{
					{"Bench Top Slot",Object[Container,Bench,"Test bench for ExperimentPlateMediaPreview tests"<>$SessionUUID]},
					{"Bench Top Slot",Object[Container,Bench,"Test bench for ExperimentPlateMediaPreview tests"<>$SessionUUID]}
				},
				Name->{
					"Container for test sample media for ExperimentPlateMediaPreview (LB, solid w/1% Agar)"<>$SessionUUID,
					"Container for test sample media for ExperimentPlateMediaPreview (LB, solid w/2% Agar)"<>$SessionUUID
				}]},
				UploadSample[{Model[Sample,Media,"Test media model for ExperimentPlateMediaPreview (LB, solid w/1% Agar)"<>$SessionUUID],Model[Sample,Media,"Test media model for ExperimentPlateMediaPreview (LB, solid w/2% Agar)"<>$SessionUUID]},
					{
						{"A1",containers[[1]]},
						{"A1",containers[[2]]}
					},
					InitialAmount->{1Liter,1Liter},
					Name->{
						"Test sample media for ExperimentPlateMediaPreview (LB, solid w/1% Agar)"<>$SessionUUID,
						"Test sample media for ExperimentPlateMediaPreview (LB, solid w/2% Agar)"<>$SessionUUID
					}
				]
			];
		]
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objects,existsFilter},
			objects={
				Object[Container,Bench,"Test bench for ExperimentPlateMediaPreview tests"<>$SessionUUID],
				Model[Sample,"Agar for ExperimentPlateMediaPreview"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMediaPreview (LB, solid w/1% Agar)"<>$SessionUUID],
				Model[Sample,Media,"Test media model for ExperimentPlateMediaPreview (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Sample,"Test sample media for ExperimentPlateMediaPreview (LB, solid w/1% Agar)"<>$SessionUUID],
				Object[Sample,"Test sample media for ExperimentPlateMediaPreview (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ExperimentPlateMediaPreview (LB, solid w/1% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ExperimentPlateMediaPreview (LB, solid w/2% Agar)"<>$SessionUUID]
			};

			(* Check whether the objects already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];

			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];
		]
	}
];