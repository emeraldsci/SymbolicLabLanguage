(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentVapro5600 : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentVapro5600*)


(* ::Subsubsection:: *)
(*ExperimentVapro5600*)


DefineTests[
	ExperimentVapro5600Training,
	{
		(*Example Basic*)
		Example[{Basic,"Generate a protocol to assess an operator's repeatability on the Vapro 5600:"},
			ExperimentVapro5600Training[Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID]],
			ObjectReferenceP[Object[Protocol,Vapro5600Training]]
		],
		(* Messages *)
		Example[{Messages,"Vapro5600LowSampleVolume","Throw a warning if the sample volume is insufficient for reliable measurement:"},
			ExperimentVapro5600Training[Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],SampleVolume->5 Microliter],
			ObjectReferenceP[Object[Protocol,Vapro5600Training]],
			Messages:>{Warning::Vapro5600LowSampleVolume}
		],
		Example[{Messages,"Vapro5600Repeatability","Throw a warning if the passing criteria exceed the nominal repeatability of the instrument:"},
			ExperimentVapro5600Training[Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],Repeatability->1 Millimole/Kilogram],
			ObjectReferenceP[Object[Protocol,Vapro5600Training]],
			Messages:>{Warning::Vapro5600Repeatability}
		],
		Example[{Messages,"Vapro5600InstrumentIncompatible","Throw an error if the instrument is not a Vapro 5600:"},
			ExperimentVapro5600Training[Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],Instrument->Object[Instrument,Osmometer,"Test non Vapro 5600 for ExperimentVapro5600Training"<>$SessionUUID]],
			$Failed,
			Messages:>{Error::Vapro5600InstrumentIncompatible,Error::InvalidOption}
		],
		Example[{Messages,"Vapro5600SampleIncompatible","Throw an error if the sample is not a Vapro 5600 standard:"},
			ExperimentVapro5600Training[Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],Sample->Object[Sample,"Test standard without model for ExperimentVapro5600Training"<>$SessionUUID]],
			$Failed,
			Messages:>{Error::Vapro5600SampleIncompatible,Error::InvalidOption}
		],
		Example[{Messages,"Vapro5600MaxNumberOfMeasurementsIncompatible","Throw an error if the max number of measurements is less than the number we assess at a time:"},
			ExperimentVapro5600Training[Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],RepeatabilityNumberOfMeasurements->3,MaxNumberOfMeasurements->2],
			$Failed,
			Messages:>{Error::Vapro5600MaxNumberOfMeasurementsIncompatible,Error::InvalidOption}
		],
		(* Options tests *)
		Example[{Options,Instrument,"Specify a particular instrument object to run the protocol on:"},
			Download[
				ExperimentVapro5600Training[Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],
					Instrument->Object[Instrument,Osmometer,"Test Vapro 5600 for ExperimentVapro5600Training"<>$SessionUUID]
				],
				Instrument
			],
			LinkP[Object[Instrument,Osmometer,"Test Vapro 5600 for ExperimentVapro5600Training"<>$SessionUUID]]
		],
		Example[{Options,Sample,"Specify a particular sample object to run the protocol with:"},
			Download[
				ExperimentVapro5600Training[Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],
					Sample->Object[Sample,"Test standard for ExperimentVapro5600Training"<>$SessionUUID]
				],
				Sample
			],
			LinkP[Object[Sample,"Test standard for ExperimentVapro5600Training"<>$SessionUUID]]
		],
		Example[{Options,SampleVolume,"Specify the sample volume to load the instrument with:"},
			Download[
				ExperimentVapro5600Training[Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],
					SampleVolume->10 Microliter
				],
				SampleVolume
			],
			10.` Microliter
		],
		Example[{Options,Repeatability,"Specify the target standard deviation that the operator's measurements should reach:"},
			Download[
				ExperimentVapro5600Training[Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],
					Repeatability->3 Millimole/Kilogram
				],
				Repeatability
			],
			3.` Millimole/Kilogram
		],
		Example[{Options,RepeatabilityNumberOfMeasurements,"Specify the number of most recent measurements to calculate repeatability from:"},
			Download[
				ExperimentVapro5600Training[Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],
					RepeatabilityNumberOfMeasurements->2
				],
				RepeatabilityNumberOfMeasurements
			],
			2
		],
		Example[{Options,MaxNumberOfMeasurements,"Specify the number of most recent measurements to calculate repeatability from:"},
			Download[
				ExperimentVapro5600Training[Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],
					MaxNumberOfMeasurements->10
				],
				MaxNumberOfMeasurements
			],
			10
		],
		Example[{Options,Pipette,"Specify a pipette to run the protocol with:"},
			Download[
				ExperimentVapro5600Training[Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],
					Pipette->Object[Instrument,Pipette,"AC-037 10 uL Pipette, Test pipette for ExperimentVapro5600Training"<>$SessionUUID]
				],
				Pipette
			],
			LinkP[Object[Instrument,Pipette,"AC-037 10 uL Pipette, Test pipette for ExperimentVapro5600Training"<>$SessionUUID]]
		],
		Example[{Options,InoculationPaper,"Specify inoculation paper to run the protocol with:"},
			Download[
				ExperimentVapro5600Training[Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],
					InoculationPaper->Object[Item,InoculationPaper,"Test Inoculation Papers for ExperimentVapro5600Training"<>$SessionUUID]
				],
				InoculationPapers
			],
			LinkP[Object[Item,InoculationPaper,"Test Inoculation Papers for ExperimentVapro5600Training"<>$SessionUUID]]
		],
		Example[{Options,Tweezers,"Specify inoculation paper to run the protocol with:"},
			Download[
				ExperimentVapro5600Training[Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],
					Tweezers->Object[Item,Tweezer,"AC-036 Forceps, Tests forceps for ExperimentVapro5600Training"<>$SessionUUID]
				],
				Tweezers
			],
			LinkP[Object[Item,Tweezer,"AC-036 Forceps, Tests forceps for ExperimentVapro5600Training"<>$SessionUUID]]
		],
		Example[{Options,Template,"Inherit options from a previous run protocol:"},
			Download[
				ExperimentVapro5600Training[Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],
					Template->Object[Protocol,Vapro5600Training,"Osmolality Test Template Protocol for ExperimentVapro5600Training"<>$SessionUUID]
				],
				MaxNumberOfMeasurements
			],
			6
		],
		Example[{Options,Name,"Specify the name of a protocol:"},
			Download[
				ExperimentVapro5600Training[Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],
					Name->"Osmolality Test Protocol for ExperimentVapro5600Training"<>$SessionUUID
				],
				Name
			],
			"Osmolality Test Protocol for ExperimentVapro5600Training"<>$SessionUUID
		],
		Example[{Messages,"DiscardedSamples","Throw an error if the standard is discarded:"},
			ExperimentVapro5600Training[
				Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],
				Sample->Object[Sample,"Test discarded standard for ExperimentVapro5600Training"<>$SessionUUID]
			],
			$Failed,
			Messages:>{Error::DiscardedSamples,Error::InvalidOption}
		],
		Example[{Messages,"Vapro5600SampleIncompatible","Throw an error if the standard is model-less:"},
			ExperimentVapro5600Training[
				Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],
				Sample->Object[Sample,"Test standard without model for ExperimentVapro5600Training"<>$SessionUUID]
			],
			$Failed,
			Messages:>{Error::Vapro5600SampleIncompatible,Error::InvalidOption}
		],
		Example[{Additional,"The volume of Sample requested is rounded up to the nearest 400 uL to ensure the protocol picks a fresh vial of standard:"},
			protocol=ExperimentVapro5600Training[Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],
					SampleVolume->10 Microliter
			];
			(* Get the sample resource *)
			sampleResource=FirstCase[Download[protocol,RequiredResources], {x_, Sample, _, _} :> x];
			(* Check the volume requested *)
			Download[sampleResource,Amount],
			EqualP[400.` Microliter],
			Variables:>{protocol,sampleResource}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have an operator input that does not exist (name form):"},
			ExperimentVapro5600Training[Object[User, Emerald, Operator, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have an operator input that does not exist (ID form):"},
			ExperimentVapro5600Training[Object[User, Emerald, Operator, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		]
	},
	Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]},
	SymbolSetUp:>(
		$CreatedObjects={};

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{testObjList,existsFilter},

			testObjList={
				Object[Container,Bench,"Test Bench for ExperimentVapro5600Training"<>$SessionUUID],
				Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Container,Vessel,"Test container 1 for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Container,Vessel,"Test container 2 for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Container,Vessel,"Test container 3 for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Container,Vessel,"Test container 4 for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Container,Vessel,"Test Container for Inoculation Papers for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Sample,"Test discarded standard for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Sample,"Test standard for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Sample,"Test standard without model for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Container,Vessel,"Test Vapro 5600 Osmometer Cleaning Solution Supply Container for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Container,Vessel,"Test Vapro 5600 Osmometer Waste Container for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Item,Cartridge,Desiccant,"Test SS-238 Desiccant Cartridge, Vapro 5600 for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Instrument,Osmometer,"Test Vapro 5600 for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Instrument,Osmometer,"Test non Vapro 5600 for ExperimentVapro5600Training"<>$SessionUUID],
				Model[Instrument,Osmometer,"Test non Vapro 5600 for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Instrument,Pipette,"AC-037 10 uL Pipette, Test pipette for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Item,Tweezer,"AC-036 Forceps, Tests forceps for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Container,Vessel,"Test Container for Inoculation Papers for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Item,InoculationPaper,"Test Inoculation Papers for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Protocol,Vapro5600Training,"Osmolality Test Template Protocol for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Protocol,Vapro5600Training,"Osmolality Test Protocol for ExperimentVapro5600Training"<>$SessionUUID]
			};
			(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
			(* Erase any objects that we failed to erase in the last unit test. *)
			existsFilter=DatabaseMemberQ[testObjList];

			EraseObject[PickList[testObjList,existsFilter],Force->True,Verbose->False];
		];
		Block[{$DeveloperUpload = True},
			Module[
				{
					testBenchPacket,testBench,containerIDs,sampleIDs,osmometerContainerIDs,osmometerContainerModels,osmometerContainerNames,osmometerContainerPackets,desiccantIDs,osmometerModelIDs,osmometerIDs,pipetteIDs,
					tweezerIDs,tweezerModels,tweezerNames,tweezerPackets,inoculationPaperIDs,protocolIDs,operatorIDs,containerModels,containerNames,dessicantModels,dessicantNames,desiccantPackets,containerPackets,samplePackets,sampleUpdatePackets,
					osmometerModelPackets,osmometerPackets,additionalPackets,
					locationPackets,allUploadPackets
				},

				testBenchPacket = UploadSample[
					Model[Container,Bench,"The Bench of Testing"],
					{"First Floor Slot",Object[Container,Building,"15500 Wells Port Drive"]},
					Name->"Test Bench for ExperimentVapro5600Training"<>$SessionUUID,
					FastTrack->True,
					Upload->False
				];
				testBench = Lookup[testBenchPacket[[1]],Object];

				osmometerModelIDs=CreateID[ConstantArray[Model[Instrument,Osmometer],1]];
				osmometerIDs=CreateID[ConstantArray[Object[Instrument,Osmometer],2]];
				pipetteIDs=CreateID[ConstantArray[Object[Instrument,Pipette],1]];
				inoculationPaperIDs=CreateID[ConstantArray[Object[Item,InoculationPaper],1]];
				protocolIDs=CreateID[ConstantArray[Object[Protocol,Vapro5600Training],1]];
				operatorIDs=CreateID[ConstantArray[Object[User,Emerald,Operator],1]];

				(**** Test sample containers ****)
				containerIDs = CreateID[ConstantArray[Object[Container,Vessel],4]];
				containerModels = {Model[Container,Vessel,"1mL clear glass ampule"],Model[Container,Vessel,"1mL clear glass ampule"],Model[Container,Vessel,"1mL clear glass ampule"],Model[Container,Vessel,"150mL Plastic Container"]};
				containerNames = Map[#<>$SessionUUID&,
					{"Test container 1 for ExperimentVapro5600Training", "Test container 2 for ExperimentVapro5600Training", "Test container 3 for ExperimentVapro5600Training", "Test Container for Inoculation Papers for ExperimentVapro5600Training"}
				];
				containerPackets = UploadSample[
					containerModels,
					ConstantArray[{"Bench Top Slot",testBench},Length[containerModels]],
					Name->containerNames,
					ID->containerIDs[ID],
					Cache->testBenchPacket,
					Upload->False
				];

				(**** Test osmometer containers ****)
				osmometerContainerIDs = CreateID[ConstantArray[Object[Container,Vessel],2]];
				osmometerContainerModels = {Model[Container,Vessel,"Vapro 5600 Osmometer Cleaning Solution Supply Container"],Model[Container,Vessel,"Vapro 5600 Osmometer Waste Container"]};
				osmometerContainerNames = Map[#<>$SessionUUID&,
					{"Test Vapro 5600 Osmometer Cleaning Solution Supply Container for ExperimentVapro5600Training","Test Vapro 5600 Osmometer Waste Container for ExperimentVapro5600Training"}
				];
				osmometerContainerPackets = UploadSample[
					osmometerContainerModels,
					ConstantArray[{"Bench Top Slot",testBench},Length[osmometerContainerModels]],
					Name->osmometerContainerNames,
					ID->osmometerContainerIDs[ID],
					Cache->testBenchPacket,
					Upload->False
				];

				(**** Test desiccant ****)
				desiccantIDs = CreateID[ConstantArray[Object[Item,Cartridge,Desiccant],1]];
				dessicantModels = {Model[Item,Cartridge,Desiccant,"SS-238 Desiccant Cartridge, Vapro 5600"]};
				dessicantNames = Map[#<>$SessionUUID&,
					{"Test SS-238 Desiccant Cartridge, Vapro 5600 for ExperimentVapro5600Training"}
				];
				desiccantPackets = UploadSample[
					dessicantModels,
					ConstantArray[{"Bench Top Slot",testBench},Length[dessicantModels]],
					Name->dessicantNames,
					ID->desiccantIDs[ID],
					Cache->testBenchPacket,
					Upload->False
				];

				(**** Test samples ****)
				sampleIDs=CreateID[ConstantArray[Object[Sample],3]];
				samplePackets=UploadSample[
					{
						(*1*)Model[Sample,"id:D8KAEvGLvEAR"],
						(*2*)Model[Sample,"id:D8KAEvGLvEAR"],
						(*3*)Model[Sample,"id:D8KAEvGLvEAR"] (* This will be overwritten with Null later *)
					},
					{
						(*1*){"A1",containerIDs[[1]]},
						(*2*){"A1",containerIDs[[2]]},
						(*3*){"A1",containerIDs[[3]]}
					},
					InitialAmount->{
						(*1*)1 Milliliter,
						(*2*)1 Milliliter,
						(*3*)1 Milliliter
					},
					Name->{
						(*1*)"Test discarded standard for ExperimentVapro5600Training"<>$SessionUUID,
						(*2*)"Test standard for ExperimentVapro5600Training"<>$SessionUUID,
						(*3*)"Test standard without model for ExperimentVapro5600Training"<>$SessionUUID
					},
					ID->sampleIDs[ID],
					Cache->containerPackets,
					Upload->False
				];

				(* Make some changes to our samples to make them unique/invalid. *)
				sampleUpdatePackets={
					(*1*)<|Object->sampleIDs[[1]],Status->Discarded,DeveloperObject->False|>,
					(*2*)<|Object->sampleIDs[[2]],Status->Available,DeveloperObject->False|>,
					(*3*)<|Object->sampleIDs[[3]],Model->Null,Status->Available,DeveloperObject->False|>
				};

				osmometerModelPackets={
					<|
						Object->osmometerModelIDs[[1]],
						Name->"Test non Vapro 5600 for ExperimentVapro5600Training"<>$SessionUUID,
						MinOsmolality->5 Millimole/Kilogram,
						MaxOsmolality->10000 Millimole/Kilogram,
						MinSampleVolume->5 Microliter,
						MaxSampleVolume->15 Microliter,
						EquilibrationTime->10 Second,
						ManufacturerOsmolalityRepeatability->1 Millimole/Kilogram
					|>
				};

				(* The instrument itself *)
				osmometerPackets={
					<|
						Object->osmometerIDs[[1]],
						Name->"Test Vapro 5600 for ExperimentVapro5600Training"<>$SessionUUID,
						Model->Link[Model[Instrument,Osmometer,"Vapro 5600"],Objects],
						Status->Available,
						Replace[SerialNumbers]->{"Instrument","5600202558"},
						Cost->9827.04 USD,
						DataFilePath->"Data\\Vapro5600\\VaproTest",
						Replace[ManufacturerCalibrants]->{
							Link[Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"]],
							Link[Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"]],
							Link[Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"]]
						},
						Software->"Vapro Lab Report",
						CleaningSolutionContainer->Link[osmometerContainerIDs[[1]]],
						WasteContainer->Link[osmometerContainerIDs[[2]]],
						DesiccantCartridge->Link[desiccantIDs[[1]]],
						Site -> Link[$Site],
						DeveloperObject->False
					|>,
					<|
						Object->osmometerIDs[[2]],
						Name->"Test non Vapro 5600 for ExperimentVapro5600Training"<>$SessionUUID,
						Model->Link[osmometerModelIDs[[1]],Objects],
						Status->Available,
						Replace[SerialNumbers]->{"Instrument","5600202558"},
						Cost->9827.04 USD,
						DataFilePath->"Data\\nonVapro5600\\nonVaproTest",
						Replace[ManufacturerCalibrants]->{
							Link[Model[Sample,"Osmolality Standard 290 mmol/kg Sodium Chloride"]],
							Link[Model[Sample,"Osmolality Standard 1000 mmol/kg Sodium Chloride"]],
							Link[Model[Sample,"Osmolality Standard 100 mmol/kg Sodium Chloride"]]
						},
						Software->"nonVapro Lab Report",
						Site -> Link[$Site],
						DeveloperObject->False
					|>
				};

				(****Test tweezer packets****)
				tweezerIDs=CreateID[ConstantArray[Object[Item,Tweezer],1]];
				tweezerModels = {Model[Item,Tweezer,"id:bq9LA0JqYMez"]};
				tweezerNames = Map[#<>$SessionUUID&,
					{"AC-036 Forceps, Tests forceps for ExperimentVapro5600Training"}
				];
				tweezerPackets = UploadSample[
					tweezerModels,
					ConstantArray[{"Bench Top Slot",testBench},Length[tweezerModels]],
					Name->tweezerNames,
					ID->tweezerIDs[ID],
					Cache->testBenchPacket,
					Upload->False
				];

				(* Create test samples *)
				additionalPackets={
					<|
						Object->pipetteIDs[[1]],
						Name->"AC-037 10 uL Pipette, Test pipette for ExperimentVapro5600Training"<>$SessionUUID,
						Model->Link[Model[Instrument,Pipette,"AC-037 10 uL Pipette, Vapro 5600"],Objects],
						Status->Available,
						Site->Link[$Site],
						DeveloperObject->False
					|>,
					<|
						Object->inoculationPaperIDs[[1]],
						Model->Link[Model[Item,InoculationPaper,"6.7mm diameter solute free paper"],Objects],
						Name->"Test Inoculation Papers for ExperimentVapro5600Training"<>$SessionUUID,
						DeveloperObject->False,
						Status->Available,
						Count->5000
					|>,
					<|
						Object->protocolIDs[[1]],
						Name->"Osmolality Test Template Protocol for ExperimentVapro5600Training"<>$SessionUUID,
						ResolvedOptions->{MaxNumberOfMeasurements->6},
						DeveloperObject->False
					|>,
					<|
						Object->operatorIDs[[1]],
						Model->Link[Model[User,Emerald,Operator,"Level 1"],Objects],
						Name->"Test operator for ExperimentVapro5600Training"<>$SessionUUID,
						DeveloperObject->False,
						Status->Active
					|>
				};

				(* Move inoculation papers to the created container *)
				locationPackets=UploadLocation[
					inoculationPaperIDs[[1]],
					{"A1",containerIDs[[4]]},
					Upload->False,
					Cache->Flatten[{containerPackets,additionalPackets}]
				];

				allUploadPackets=Flatten[{
					testBenchPacket,containerPackets,osmometerContainerPackets,desiccantPackets,samplePackets,sampleUpdatePackets,
					osmometerModelPackets,osmometerPackets,tweezerPackets,additionalPackets,locationPackets
				}];

				Upload[allUploadPackets]
			]
		]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		
		Module[{testObjList,existsFilter},
			(* list of test objects *)
			testObjList={
				Object[Container,Bench,"Test Bench for ExperimentVapro5600Training"<>$SessionUUID],
				Object[User,Emerald,Operator,"Test operator for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Container,Vessel,"Test container 1 for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Container,Vessel,"Test container 2 for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Container,Vessel,"Test container 3 for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Container,Vessel,"Test container 4 for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Container,Vessel,"Test Container for Inoculation Papers for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Sample,"Test discarded standard for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Sample,"Test standard for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Sample,"Test standard without model for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Container,Vessel,"Test Vapro 5600 Osmometer Cleaning Solution Supply Container for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Container,Vessel,"Test Vapro 5600 Osmometer Waste Container for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Item,Cartridge,Desiccant,"Test SS-238 Desiccant Cartridge, Vapro 5600 for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Instrument,Osmometer,"Test Vapro 5600 for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Instrument,Osmometer,"Test non Vapro 5600 for ExperimentVapro5600Training"<>$SessionUUID],
				Model[Instrument,Osmometer,"Test non Vapro 5600 for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Instrument,Pipette,"AC-037 10 uL Pipette, Test pipette for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Item,Tweezer,"AC-036 Forceps, Tests forceps for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Container,Vessel,"Test Container for Inoculation Papers for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Item,InoculationPaper,"Test Inoculation Papers for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Protocol,Vapro5600Training,"Osmolality Test Template Protocol for ExperimentVapro5600Training"<>$SessionUUID],
				Object[Protocol,Vapro5600Training,"Osmolality Test Protocol for ExperimentVapro5600Training"<>$SessionUUID]
			};
			
			(* Check whether the names already exist in the database *)
			existsFilter = DatabaseMemberQ[testObjList];
			
			(* Erase any objects that we failed to erase in the last unit test. *)
			Quiet[EraseObject[PickList[testObjList, existsFilter], Force->True, Verbose->False]];
		]
	)
];