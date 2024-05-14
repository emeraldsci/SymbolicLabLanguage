DefineTests[ExperimentPlateMedia,
	{
		Example[{Basic,"Create a protocol for preparing 25 plates of LB agar by manual plating:"},
			ExperimentPlateMedia[Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PlateOut->Model[Container,Plate,"Omni Tray Sterile Media Plate"],
				PlatingVolume->25Milliliter,
				NumberOfPlates->25
			],
			ObjectP[Object[Protocol,PlateMedia]]
		],
		Example[{Basic,"Create a protocol for preparing 25 plates of LB agar using the serial filler:"},
			ExperimentPlateMedia[Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PlateOut->Model[Container,Plate,"Omni Tray Sterile Media Plate"],
				PlatingVolume->25Milliliter,
				NumberOfPlates->25,
				PlatingMethod->Pump
			],
			ObjectP[Object[Protocol,PlateMedia]]
		],
		Example[{Basic,"Create a protocol for preparing 30 plates of LB agar by thawing an existing bottle of solid LB Agar media under the specified conditions:"},
			ExperimentPlateMedia[Object[Sample,"Test sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PlateOut->Model[Container,Plate,"Omni Tray Sterile Media Plate"],
				PlatingVolume->25Milliliter,
				NumberOfPlates->30,
				PrePlatingIncubationTime->45Minute,
				PrePlatingMixRate->100RPM,
				PlatingTemperature->70Celsius
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
				Object[Sample,"Test sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				PlateOut->Model[Container,Plate,"Omni Tray Sterile Media Plate"],
				NumberOfPlates->100
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
				Object[Container,Vessel,"Test container for sample media for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for ExperimentPlateMedia (LB, partially melted solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID]
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
			With[{containers = UploadSample[{Model[Container, Vessel, "1L Glass Bottle"],Model[Container, Vessel, "1L Glass Bottle"]},
				{
					{"Bench Top Slot",Object[Container,Bench,"Fake bench for ExperimentPlateMedia tests"<>$SessionUUID]},
					{"Bench Top Slot",Object[Container,Bench,"Fake bench for ExperimentPlateMedia tests"<>$SessionUUID]}
				},
				Name->{
					"Container for test sample media for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID,
					"Container for test sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID
				}]},
				UploadSample[{Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID],Model[Sample,Media,"Test media model for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID]},
					{
						{"A1",containers[[1]]},
						{"A1",containers[[2]]}
					},
					InitialAmount->{1Liter,1Liter},
					Name->{
						"Test sample media for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID,
						"Test sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID
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
				Object[Container,Vessel,"Test container for sample media for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Test container for sample media for ExperimentPlateMedia (LB, partially melted solid w/2% Agar)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ExperimentPlateMedia (LB, liquid)"<>$SessionUUID],
				Object[Container,Vessel,"Container for test sample media for ExperimentPlateMedia (LB, solid w/2% Agar)"<>$SessionUUID]
			};
			
			(* Check whether the objects already exist in the database *)
			existsFilter = DatabaseMemberQ[objects];
			
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[objects,existsFilter],Force->True,Verbose->False]];
		]
	}
];