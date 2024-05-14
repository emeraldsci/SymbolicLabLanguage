

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)

(* ::Package:: *)

(* ::Title:: *)
(*ExperimentMeasureDensity : Tests*)


(* ::Section::Closed:: *)
(*Unit Testing*)


(* ::Subsection::Closed:: *)
(*ExperimentMeasureDensity*)


(* ::Subsubsection::Closed:: *)
(*ExperimentMeasureDensity*)


DefineTests[
	ExperimentMeasureDensity,
	{
		Example[{Basic,"Measure the density of a single sample:"},
			ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureDensity]]
		],

		Example[{Basic,"Measure the density of multiple samples:"},
			ExperimentMeasureDensity[{Object[Sample,"Measure Density Test Sample"<> $SessionUUID],Object[Sample,"Measure Density Test Sample No Density"<> $SessionUUID],Object[Sample,"MeasureDensity Fake Sample w/ Fake Model"<> $SessionUUID]}],
			ObjectP[Object[Protocol,MeasureDensity]]
		],

		Example[{Basic,"Measure the density of a sample in a container:"},
			ExperimentMeasureDensity[Object[Container,Vessel,"MeasureDensity Test Container"<> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureDensity]]
		],

		Example[{Basic,"Measure the density of a single sample with a severed model:"},
			ExperimentMeasureDensity[Object[Sample,"Measure Density Model Severed Test Sample"<> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureDensity]]
		],

		Example[{Options, Name, "A name which should be used to refer to the output object in lieu of an automatically generated ID:"},
			Lookup[
				ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],Name->"My Favorite Measure Density Protocol",Output->Options],
				Name
			],
			"My Favorite Measure Density Protocol"
		],

		Example[{Options, Confirm, "Indicates if the protocols generated should be confirmed for execution immediately upon creation and skip the InCart status:"},
			Module[
				{myProtocol},
				myProtocol = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],Confirm->True];
				Download[myProtocol,Status]
			],
			Processing|ShippingMaterials|Backlogged
		],

		Example[{Options, Volume, "Volume option allows specification of volume of the sample to be used for each measurement:"},
			Lookup[
				ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],Volume->240*Microliter,Output->Options],
				Volume
			],
			240*Microliter
		],

		Example[{Options, RecoupSample, "RecoupSample option determines whether the sample beings weighted will be discarded or returned to the source container after it has been measured:"},
			Lookup[
				ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],RecoupSample->True,Output->Options],
				RecoupSample
			],
			True
		],

		Example[{Options, NumberOfReplicates, "RecoupSample option determines whether the sample beings weighted will be discarded or returned to the source container after it has been measured:"},
			Lookup[
				ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],NumberOfReplicates->3,Output->Options],
				NumberOfReplicates
			],
			3
		],

		Example[{Options, Method, "Method option determines whether the sample will use the FixedVolumeWeight (aliquoting a known amount into a tared container) or the DensityMeter (U-tube oscillation based analytical instrument) method for measurement:"},
			Lookup[
				ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],Method->DensityMeter,Output->Options],
				Method
			],
			DensityMeter
		],

		Example[{Options, Instrument, "Instrument option determines whether the sample will use a balance (for the FixedVolumeWeight method) or a DensityMeter (for the DensityMeter method) instrument for measurement:"},
			Lookup[
				ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],Instrument->Model[Instrument, DensityMeter, "id:P5ZnEjdbXEbE"],Output->Options],
				Instrument
			],
			Model[Instrument, DensityMeter, "id:P5ZnEjdbXEbE"]
		],

		Example[{Options, Temperature, "Temperature option determines the temperature at which the sample measurement will be performed when using the DensityMeter method (the FixedVolumeWeight method can only be performed at Ambient temperature):"},
			Lookup[
				ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],Temperature->40 Celsius,Output->Options],
				Temperature
			],
			40 Celsius
		],

		Example[{Options, ViscosityCorrection, "ViscosityCorrection option determines if the instrument should apply automatic correction for the viscosity of the sample during measurement with the DensityMeter (recommended in all cases for more accurate measurement):"},
			Lookup[
				ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],ViscosityCorrection->True,Output->Options],
				ViscosityCorrection
			],
			True
		],

		Example[{Options, WashSolution, "WashSolution option determines what the initial solution used to clean out the U-tube measurement chamber in the density meter instrument after the measurement is complete:"},
			Lookup[
				ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],WashSolution->Water,Output->Options],
				WashSolution
			],
			{Model[Sample, "Milli-Q water"]}
		],

		Example[{Options, SecondaryWashSolution, "SecondaryWashSolution option determines what the second solution used to clean out the U-tube measurement chamber in the density meter instrument (and aid in drying the chamber) after the measurement is complete and the initial wash (with the WashSolution) has been completed:"},
			Lookup[
				ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],SecondaryWashSolution->Ethanol,Output->Options],
				SecondaryWashSolution
			],
			{Model[Sample,"Ethanol, Reagent Grade"]}
		],

		Example[{Options, TertiaryWashSolution, "TertiaryWashSolution option determines what the third solution used to clean out the U-tube measurement chamber in the density meter instrument (and aid in drying the chamber) after the measurement is complete and the initial wash (with the WashSolution) has been completed:"},
			Lookup[
				ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],TertiaryWashSolution->Ethanol,Output->Options],
				TertiaryWashSolution
			],
			{Model[Sample,"Ethanol, Reagent Grade"]}
		],

		Example[{Options, WashVolume, "WashVolume option determines the volume of each wash solution used to clean out the U-tube measurement chamber in the density meter instrument after the measurement is complete:"},
			Lookup[
				ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],WashVolume->10 Milliliter,Output->Options],
				WashVolume
			],
			10 Milliliter
		],

		Example[{Options, WashCycles, "WashCycles option determines the number of wash cycles (each consisting of one WashVolume of WashSolution, followed by one WashVolume of SecondaryWashSolution) used to clean out the U-tube measurement chamber in the density meter instrument after the measurement is complete:"},
			Lookup[
				ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],WashCycles->2,Output->Options],
				WashCycles
			],
			2
		],

		Example[{Options, AirWaterCheck, "AirWaterCheck option determines if AirWaterCheck option is performed:"},
			Lookup[
				ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],AirWaterCheck->True,Output->Options],
				AirWaterCheck
			],
			True
		],

		(*Messages: Warnings*)
		Example[{Messages,AmbientTemperatureMeasurement,"A Warning is thrown if the samples should be transport warmed but the measurement is taken at ambient temperature:"},
			ExperimentMeasureDensity[Object[Sample,"Measure Density Heated Sample"<> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureDensity]],
			Messages:>{Warning::AmbientTemperatureMeasurement}
		],

		Example[{Messages,AmbientTemperatureMeasurement,"A Warning is thrown if the samples should be transport chilled but the measurement is taken at ambient temperature:"},
			ExperimentMeasureDensity[Object[Sample,"Measure Density Chilled Sample"<> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureDensity]],
			Messages:>{Warning::AmbientTemperatureMeasurement}
		],

		Example[{Messages,ModelDensityNotUpdated,"A Warning is thrown if the samples' Model already has Density information and will not have their Density updated from the current experiment (only the Object[Sample] will have its density updated):"},
			ExperimentMeasureDensity[Object[Sample,"Measure Density Private Model Test Sample"<> $SessionUUID]],
			ObjectP[Object[Protocol,MeasureDensity]],
			Messages:>{Warning::ModelDensityNotUpdated}
		],

		(*Messages: Errors*)
		Example[{Messages,"MeasureDensityVentilatedSamples","An error is thrown if a ventilated sample is specified to be measured with the DensityMeter method:"},
			ExperimentMeasureDensity[{Object[Sample,"Measure Density Ventilated Sample"<> $SessionUUID],Object[Sample,"Measure Density Test Sample"<> $SessionUUID]}, Method -> DensityMeter],
			$Failed,
			Messages:>{Error::MeasureDensityVentilatedSamples,Error::InvalidOption}
		],

		Example[{Messages,"MeasureDensityVolumeTooLow","An error is thrown if a sample does not have sufficient volume to be measured (at least 50 Microliter is required to measure density):"},
			ExperimentMeasureDensity[Object[Sample,"Measure Density Low Volume Test Sample"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::MeasureDensityVolumeTooLow,Error::InvalidInput,Warning::ModelDensityNotUpdated}
		],

		Example[{Messages,"MeasureDensitySolidSample","An error is thrown if a sample is solid (only liquid samples can be have their density measured with ExperimentMeasureDensity):"},
			ExperimentMeasureDensity[Object[Sample,"Measure Density Test Solid Sample"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::MeasureDensitySolidSample,Error::MeasureDensityVolumeUnknown,Error::SolidSamplesUnsupported,Error::InvalidInput}
		],

		Example[{Messages,"MeasureDensityVolumeUnknown","An error is thrown if a sample has no volume information:"},
			ExperimentMeasureDensity[Object[Sample,"Measure Density No Volume Test Sample"<> $SessionUUID]],
			$Failed,
			Messages:>{Error::MeasureDensityVolumeUnknown,Error::InvalidInput,Warning::ModelDensityNotUpdated}
		],

		Example[{Messages,"InvalidWashSolution","An error is thrown if a WashSolution is provided with the FixedVolumeWeight method (this option is only compatible with the DensityMeter method):"},
			ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],WashSolution->Water,Method->FixedVolumeWeight],
			$Failed,
			Messages:>{Error::InvalidWashSolution,Error::InvalidOption}
		],

		Example[{Messages,"InvalidSecondaryWashSolution","An error is thrown if a SecondaryWashSolution is provided with the FixedVolumeWeight method (this option is only compatible with the DensityMeter method):"},
			ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],SecondaryWashSolution->Ethanol,Method->FixedVolumeWeight],
			$Failed,
			Messages:>{Error::InvalidSecondaryWashSolution,Error::InvalidOption}
		],

		Example[{Messages,"InvalidTertiaryWashSolution","An error is thrown if a TertiaryWashSolution is provided with the FixedVolumeWeight method (this option is only compatible with the DensityMeter method):"},
			ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],TertiaryWashSolution->Ethanol,Method->FixedVolumeWeight],
			$Failed,
			Messages:>{Error::InvalidTertiaryWashSolution,Error::InvalidOption}
		],

		Example[{Messages,"InvalidWashVolume","An error is thrown if a WashVolume is provided with the FixedVolumeWeight method (this option is only compatible with the DensityMeter method):"},
			ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],WashVolume->10 Milliliter,Method->FixedVolumeWeight],
			$Failed,
			Messages:>{Error::InvalidWashVolume,Error::InvalidOption}
		],

		Example[{Messages,"InvalidWashCycles","An error is thrown if WashCycles is provided with the FixedVolumeWeight method (this option is only compatible with the DensityMeter method):"},
			ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],WashCycles->2,Method->FixedVolumeWeight],
			$Failed,
			Messages:>{Error::InvalidWashCycles,Error::InvalidOption}
		],

		Example[{Messages,"InvalidTemperature","An error is thrown if a Temperature is provided with the FixedVolumeWeight method (this option is only compatible with the DensityMeter method):"},
			ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],Temperature->40 Celsius,Method->FixedVolumeWeight],
			$Failed,
			Messages:>{Error::InvalidTemperature,Error::InvalidOption}
		],

		Example[{Messages,"InvalidViscosityCorrection","An error is thrown if ViscosityCorrection is provided with the FixedVolumeWeight method (this option is only compatible with the DensityMeter method):"},
			ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],ViscosityCorrection->True,Method->FixedVolumeWeight],
			$Failed,
			Messages:>{Error::InvalidViscosityCorrection,Error::InvalidOption}
		],

		Example[{Messages,"MeasureDensityIncompatibleInstrument","An error is thrown if an incompatible instrument is selected:"},
			ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],Instrument->Model[Instrument,Balance,"id:aXRlGn6V7Jov"]],
			$Failed,
			Messages:>{Error::MeasureDensityIncompatibleInstrument,Error::InvalidOption}
		],

		Example[{Messages,"MeasureDensityIncompatibleVolume","An error is thrown if a Volume other than 2 Milliliter is provided with the DensityMeter method (the measurement chamber has a fixed volume, requiring 2 Milliliter for accurate measurement):"},
			ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],Volume->1.7 Milliliter,Method->DensityMeter],
			$Failed,
			Messages:>{Error::MeasureDensityIncompatibleVolume,Error::InvalidOption}
		],

		Example[{Messages,"InvalidAirWaterCheck","An error is thrown if AirWaterCheck is provided with the FixedVolumeWeight method (this option is only compatible with the DensityMeter method):"},
			ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],AirWaterCheck->True,Method->FixedVolumeWeight],
			$Failed,
			Messages:>{Error::InvalidAirWaterCheck,Error::InvalidOption}
		],

		Test["Running Ventilated samples is possible if they have adequate volumes:",
			ValidExperimentMeasureDensityQ[{Object[Sample,"Measure Density Ventilated Sample"<> $SessionUUID],Object[Sample,"Measure Density Test Sample"<> $SessionUUID]}],
			True
		],

		Test["Volume option is uploaded in the correct order, and not in an alternating order:",
			myProtocolObject = ExperimentMeasureDensity[{Object[Sample,"Measure Density Test Sample"<> $SessionUUID],Object[Sample,"Measure Density Test Sample No Density"<> $SessionUUID]},Volume->{240*Microliter,100*Microliter}];
			Download[myProtocolObject,Volumes],
			{Repeated[240.*Microliter,5],Repeated[100.*Microliter,5]},
			Variables:>{myProtocolObject}
		],

		Test["MeasurementContainers have the correct number of Links informed:",
			myProtocolObject = ExperimentMeasureDensity[{Object[Sample,"Measure Density Test Sample"<> $SessionUUID],Object[Sample,"Measure Density Test Sample No Density"<> $SessionUUID]},NumberOfReplicates->10];
			Length[Download[myProtocolObject,MeasurementContainers]],
			20,
			Variables:>{myProtocolObject}
		],

		(* TODO: the last sample only has 40ul. The pipette/tip code can't find a combo that works for that volume in that tube.
		Once we've determined a solution, uncomment this *)
		Test["Pick alternative pipettes and pipette tips for tricky vessels, such as narrow reaction vials:",
			ExperimentMeasureDensity[
				{Object[Container,Vessel,"MeasureDensity Reaction Vial1"<> $SessionUUID],Object[Container,Vessel,"MeasureDensity Reaction Vial2"<> $SessionUUID](*,Object[Container,Vessel,"MeasureDensity Reaction Vial3"<> $SessionUUID]*)}
			],
			ObjectP[Object[Protocol,MeasureDensity]],
			Messages:>{Warning::ModelDensityNotUpdated}
		],

		Test["Only generate resources for unique pipettes and tip models (up to number of tips in a box):",
			Module[
				{protObj,reqRes,pipetRes,tipRes},

				(* Generate a protocol using a 2mL tube that can use the postive displacement pipettes, and a glass reaction vial that requires a standard pipette instead *)
				protObj = ExperimentMeasureDensity[{Object[Sample,"Measure Density Test Sample In Tube Without Tare"<> $SessionUUID],Object[Sample,"MeasureDensity Fake Sample w/ Fake Model"<> $SessionUUID]},NumberOfReplicates->10,Method->FixedVolumeWeight];

				(* Pull out the required resources and convert links to Objects *)
				reqRes = protObj[RequiredResources]/.{objX:ObjectP[]:>Download[objX,Object]};

				(* Pull out the pipette and tip resources *)
				pipetRes = Cases[reqRes,{ObjectP[Object[Resource,Instrument]],Pipettes,_Integer,Null}];
				tipRes = Cases[reqRes,{ObjectP[Object[Resource,Sample]],PipetteTips,_Integer,Null}];

				(* Test expression: how many unique pipette resources followed by how many unique tip resources *)
				{Length@DeleteDuplicates[pipetRes[[All,1]]],Length@DeleteDuplicates[tipRes[[All,1]]]}
			],

			(* Expected outcome: there are two tube models, one of which can't use positive displacement pipettes,
					so there should be 2 pipette resources and 2 pipette tip resources
			*)
			{2,2}
		],

		Test["If a pipette tip resource would request more tips than are in a box, it splits into multiple resources:",
			Module[
				{protObj,reqRes,pipetRes,tipRes},

				(* Generate a protocol using a 2mL tube that can use the positive displacement pipettes, and a glass reaction vial that requires a standard pipette instead *)
				protObj = ExperimentMeasureDensity[
					Object[Sample,"Measure Density Test Sample In Tube Without Tare"<> $SessionUUID],
					NumberOfReplicates->61,
					Method->FixedVolumeWeight
				];

				(* Pull out the required resources and convert links to Objects *)
				reqRes = protObj[RequiredResources]/.{objX:ObjectP[]:>Download[objX,Object]};

				(* Pull out the pipette and tip resources *)
				tipRes = Cases[reqRes,{ObjectP[Object[Resource,Sample]],PipetteTips,_Integer,Null}];

				(* Test expression: make sure 2 resources are made for the tip boxes that only have a 60 count *)
				(* In this case, the first resource should be repeated 60 times (NumReplicates -> 61), then the next resource
				 should be repeated 1 times, for 61 instances total. *)
				Length@DeleteDuplicates[tipRes[[All,1]]]
			],

			(* The model of tip that should be chosen should have 60 tips per box, meaning we need 2 pipette tip boxes *)
			2,
			TimeConstraint->300
		],

		(* Old test, not relevant to current method
		Test["Only generate resources requesting the number of tips in a tip box at most:",
			Module[
				{protObj,reqRes,pipetRes,tipRes},

				(* Generate a protocol using a 2mL tube that can use the positive displacement pipettes, and a glass reaction vial that requires a standard pipette instead *)
				protObj = ExperimentMeasureDensity[
					Flatten[{
						ConstantArray[Object[Sample, "Measure Density Test Sample In Tube Without Tare"], 35],
						ConstantArray[Object[Sample, "MeasureDensity Fake Sample w/ Fake Model"<> $SessionUUID], 5],
						ConstantArray[Object[Sample, "Measure Density Test Sample In Tube Without Tare"], 30]
					}],
					NumberOfReplicates->2
				];

				(* Pull out the required resources and convert links to Objects *)
				reqRes = protObj[RequiredResources]/.{objX:ObjectP[]:>Download[objX,Object]};

				(* Pull out the pipette and tip resources *)
				tipRes = Cases[reqRes,{ObjectP[Object[Resource,Sample]],PipetteTips,_Integer,Null}][[All,1]];

				(* Test expression: make sure 2 resources are made for the tip boxes that only have a 60 count *)
				(* In this case, the first resource should be repeated 35 times (NumReplicates -> 35), then the next resource
				 (which has a different requested model) should be repeated 35 times, then the first resource should be repeated
				 another 25 times for 60 instances total. Finally a new resource (that will have the same model as the first
				 resource) will be repeated 10 times *)
				MatchQ[
					tipRes,
					{
						Repeated[First[tipRes],35],
						Repeated[tipRes[[37]],5],
						Repeated[First[tipRes],25],
						Repeated[Last[tipRes],5]
					}
				]
			],

			True
		],*)

		(* -------------------------------------------------------- *)
		(* -------------------------------------------------------- *)
		(* ------------ FUNTOPIA SHARED OPTION TESTING ------------ *)
		(* -------------------------------------------------------- *)
		(* -------------------------------------------------------- *)
		Example[{Options,PreparatoryPrimitives,"Make a new stock solution model and measure its density:"},
			ExperimentMeasureDensity[
				"My New StockSolution",
				PreparatoryPrimitives -> {
					Define[
						Name -> "My New StockSolution",
						Container -> Model[Container, Vessel, "50mL Tube"],
						ModelType -> Model[Sample,StockSolution],
						ModelName -> "A Brand New StockSolution"
					],
					Transfer[
						Source -> Model[Sample, "id:BYDOjvG9z6Jl"],
						Destination -> "My New StockSolution",
						Amount -> 2.5*Milliliter
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> "My New StockSolution",
						Amount -> 10*Milliliter
					]
				}
			],
			ObjectP[Object[Protocol,MeasureDensity]]
		],
		Example[{Options,PreparatoryPrimitives,"Transfer water to use as control samples to qualify the accuracy of density measurement:"},
			ExperimentMeasureDensity[
				"My Controls Plate",
				PreparatoryPrimitives -> {
					Define[
						Name -> "My Controls Plate",
						Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> {"My Controls Plate","A1"},
						Amount -> 2.*Milliliter
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> {"My Controls Plate","A2"},
						Amount -> 2.*Milliliter
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> {"My Controls Plate","A3"},
						Amount -> 2.*Milliliter
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> {"My Controls Plate","A4"},
						Amount -> 2.*Milliliter
					]
				},
				Volume -> {100.*Microliter, 250.*Microliter, 500.*Microliter, 1000.*Microliter}
			],
			ObjectP[Object[Protocol,MeasureDensity]],
			Messages:>{Warning::ModelDensityNotUpdated}
		],
		Example[
			{Options,PreparatoryPrimitives,"Add food dye to a 50 milliliter tube, fill to 45 milliliters with dH2O, and then measure the density:"},
			ExperimentMeasureDensity[
				{"My 50mL Tube for density measurement"},
				PreparatoryPrimitives -> {
					Define[
						Name -> "My 50mL Tube for density measurement",
						Container -> Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, "id:BYDOjvG9z6Jl"],
						Destination -> "My 50mL Tube for density measurement",
						Amount -> 7.5 Milliliter
					],
					Transfer[
						Source -> Model[Sample, "id:8qZ1VWNmdLBD"],
						Destination -> "My 50mL Tube for density measurement",
						Amount -> 35 Milliliter
					]
				}
			],
			ObjectP[Object[Protocol,MeasureDensity]]
		],
		Example[{Options,PreparatoryUnitOperations,"Transfer water to use as control samples to qualify the accuracy of density measurement:"},
			ExperimentMeasureDensity[
				"My Controls Plate",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My Controls Plate",
						Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> {"A1", "My Controls Plate"},
						Amount -> 2.*Milliliter
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> {"A2", "My Controls Plate"},
						Amount -> 2.*Milliliter
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> {"A3", "My Controls Plate"},
						Amount -> 2.*Milliliter
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> {"A4", "My Controls Plate"},
						Amount -> 2.*Milliliter
					]
				},
				Volume -> {100.*Microliter, 250.*Microliter, 500.*Microliter, 1000.*Microliter}
			],
			ObjectP[Object[Protocol,MeasureDensity]],
			Messages:>{Warning::ModelDensityNotUpdated}
		],
		Example[
			{Options,PreparatoryUnitOperations,"Add food dye to a 50 milliliter tube, fill to 45 milliliters with dH2O, and then measure the density:"},
			ExperimentMeasureDensity[
				{"My 50mL Tube for density measurement"},
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My 50mL Tube for density measurement",
						Container -> Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source -> Model[Sample, "id:BYDOjvG9z6Jl"],
						Destination -> "My 50mL Tube for density measurement",
						Amount -> 7.5 Milliliter
					],
					Transfer[
						Source -> Model[Sample, "id:8qZ1VWNmdLBD"],
						Destination -> "My 50mL Tube for density measurement",
						Amount -> 35 Milliliter
					]
				}
			],
			ObjectP[Object[Protocol,MeasureDensity]]
		],
		Example[{Options,IncubateAliquotDestinationWell, "Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], IncubateAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],

		Example[{Options,CentrifugeAliquotDestinationWell, "Indicates the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],

		Example[{Options,FilterAliquotDestinationWell, "Indicates the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], FilterAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],

		Example[{Options,DestinationWell, "Indicates the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], DestinationWell -> "A1", Output -> Options];
			Lookup[options,DestinationWell],
			"A1",
			Variables:>{options}
		],

		Example[{Options,SamplesInStorageCondition, "Indicates how the input samples of the experiment should be stored:"},
			options = ExperimentMeasureDensity[Object[Sample, "Measure Density Test Sample"<> $SessionUUID], SamplesInStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options,SamplesInStorageCondition],
			Refrigerator,
			Variables:>{options}
		],

		Example[{Options, Incubate, "Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or any aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], MaxIncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, MaxIncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], IncubateAliquot -> 1.5*Milliliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{_Integer, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],

		Example[{Options, Mix, "Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], MixType -> Shake, Output -> Options];
			Lookup[options, MixType],
			Shake,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incubation will occur prior to starting the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* ExperimentCentrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options}
		],
		Example[{Options, CentrifugeInstrument, "The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample In Tube Without Tare"<> $SessionUUID], CentrifugeInstrument -> Model[Instrument, Centrifuge, "Microfuge 16"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Microfuge 16"]],
			Variables :> {options}
		],
		Example[{Options, CentrifugeIntensity, "The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTime, "The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample In Tube Without Tare"<> $SessionUUID], CentrifugeTime -> 40*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeTemperature, "The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], CentrifugeTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquot, "The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], CentrifugeAliquot -> 1.5*Milliliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, CentrifugeAliquotContainer, "The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{_Integer, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],

	(* filter options *)
		Example[{Options, Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], FilterInstrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, SyringePump, "NE-1010 Syringe Pump"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample In Tube Without Tare"<> $SessionUUID], Filter -> Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], FilterMaterial -> PES, Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], FilterMaterial -> PTFE, PrefilterMaterial -> GxF, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], FilterPoreSize -> 0.22*Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], FilterMaterial->PTFE, PrefilterPoreSize -> 1.*Micrometer, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample In Tube Without Tare"<> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample In Tube Without Tare"<> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, FilterContainerOut -> Model[Container,Vessel,"2mL Tube"],Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample In Tube Without Tare"<> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20*Minute, FilterContainerOut -> Model[Container,Vessel,"2mL Tube"],Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample In Tube Without Tare"<> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 10*Celsius, FilterContainerOut -> Model[Container,Vessel,"2mL Tube"], Output -> Options];
			Lookup[options, FilterTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options}
		],
		Example[{Options, FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], FilterAliquot -> 1.5*Milliliter, Output -> Options];
			Lookup[options, FilterAliquot],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample In Tube Without Tare"<> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{_Integer, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
	(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], AliquotAmount -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], AssayVolume -> 0.08*Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Oligo Sample"<> $SessionUUID], TargetConcentration -> 5*Micromolar, AliquotContainer->Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, TargetConcentration],
			5*Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 150 Microliter, AssayVolume -> 300 Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 150 Microliter, AssayVolume -> 300 Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 150 Microliter, AssayVolume -> 300 Microliter,Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "The analyte whose desired final concentration is specified:"},
			options = ExperimentFPLC[Object[Sample,"Measure Density Oligo Sample"<> $SessionUUID], TargetConcentration -> 5 Micromolar, TargetConcentrationAnalyte ->Model[Molecule, Oligomer, "Test 10mer Model[Molecule,Oligomer] for ExperimentMeasureDensity"<> $SessionUUID], AssayVolume -> 100 Microliter, Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, Oligomer, "Test 10mer Model[Molecule,Oligomer] for ExperimentMeasureDensity"<> $SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AliquotAmount -> 150 Microliter, AssayVolume -> 300 Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], Aliquot -> True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], AliquotContainer -> Model[Container,Vessel,"50mL Tube"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{_Integer, ObjectP[Model[Container,Vessel,"50mL Tube"]]}..},
			Variables :> {options}
		],
		Example[{Options, MeasureVolume, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], MeasureVolume -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, MeasureWeight, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], MeasureWeight -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options, ImageSample, "Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID], ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options,Template, "Use a previous MeasureDensity protocol as a template for a new one:"},
			options=ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],
				Template->Object[Protocol,MeasureDensity,"Test Template Protocol for ExperimentMeasureDensity"<> $SessionUUID],
				Output->Options];
			Lookup[options, NumberOfReplicates],
			4,
			Variables :> {options}
		]
	},
	SymbolSetUp:>Module[{createdObjects,existsFilter,emptyContainer,container1,container2,waterContainer,solidContainer,
		taredTube,fakeModel,fakeHeatedModel,fakeChilledModel,fakeProtocolID,thinTube1,thinTube2,thinTube3,oligoTube,hotTube,coldTube,ventilatedTube,modelSeveredTube,
		testSample,waterSample,sampleWithoutDensity1,sampleWithoutDensity2,solidSample,fakeSample1,waterSample2,privateModelSample,privateModelTube,
		waterSample3,oligoSample,heatedSample,chilledSample,ventilatedSample,modelSeveredSample,lowVolumeSample,noVolumeSample,lowVolumeTube,noVolumeTube},

		$CreatedObjects = {};
		ClearMemoization[];

		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		createdObjects={
			Object[Sample,"Measure Density Test Sample"<> $SessionUUID],
			Object[Sample,"Measure Density Test Water Sample"<> $SessionUUID],
			Object[Sample,"Measure Density Test Sample No Density"<> $SessionUUID],
			Object[Sample,"Measure Density Test Sample In Tube Without Tare"<> $SessionUUID],
			Object[Sample,"Measure Density Test Solid Sample"<> $SessionUUID],
			Model[Sample,StockSolution,"Fake MeasureDensity Testing Model"<> $SessionUUID],
			Object[Protocol,SampleManipulation,"A fake Parent Protocol for ExperimentMeasureDensity testing"<> $SessionUUID],
			Object[Container,Vessel,"MeasureDensity Reaction Vial1"<> $SessionUUID],
			Object[Container,Vessel,"MeasureDensity Reaction Vial2"<> $SessionUUID],
			Object[Container,Vessel,"MeasureDensity Reaction Vial3"<> $SessionUUID],
			Object[Container,Vessel,"MeasureDensity Oligo Tube"<> $SessionUUID],
			Object[Sample,"MeasureDensity Fake Sample w/ Fake Model"<> $SessionUUID],
			Object[Sample,"Measure Density Test Water Sample2"],
			Object[Sample,"Measure Density Test Water Sample3"],
			Object[Sample,"Measure Density Oligo Sample"<> $SessionUUID],
			Object[Container,Vessel,"MeasureDensity Empty Container"<> $SessionUUID],
			Object[Container,Vessel,"MeasureDensity Test Container"<> $SessionUUID],
			Object[Container,Vessel,"MeasureDensity Test Container2"<> $SessionUUID],
			Object[Container,Vessel,"MeasureDensity Test Container3"<> $SessionUUID],
			Object[Container,Vessel,"MeasureDensity Test Container4"<> $SessionUUID],
			Object[Container,Vessel,"MeasureDensity Test Container5"<> $SessionUUID],
			Object[Container,Vessel,"MeasureDensity Heated Tube"<> $SessionUUID],
			Object[Container,Vessel,"MeasureDensity Chilled Tube"<> $SessionUUID],
			Object[Container,Vessel,"MeasureDensity Ventilated Tube"<> $SessionUUID],
			Object[Container,Vessel,"MeasureDensity SeveredModel Tube"<> $SessionUUID],
			Object[Container,Vessel,"MeasureDensity Low Volume Tube"<> $SessionUUID],
			Object[Container,Vessel,"MeasureDensity No Volume Tube"<> $SessionUUID],
			Object[Container,Vessel,"MeasureDensity Private Model Tube"<> $SessionUUID],
			Model[Sample,StockSolution,"Fake MeasureDensity Heated Model"<> $SessionUUID],
			Model[Sample,StockSolution,"Fake MeasureDensity Chilled Model"<> $SessionUUID],
			Model[Sample,StockSolution,"Fake MeasureDensity Ventilated Model"<> $SessionUUID],
			Object[Sample,"Measure Density Heated Sample"<> $SessionUUID],
			Object[Sample,"Measure Density Chilled Sample"<> $SessionUUID],
			Object[Sample,"Measure Density Ventilated Sample"<> $SessionUUID],
			Object[Sample,"Measure Density Model Severed Test Sample"<> $SessionUUID],
			Object[Sample,"Measure Density Low Volume Test Sample"<> $SessionUUID],
			Object[Sample,"Measure Density No Volume Test Sample"<> $SessionUUID],
			Object[Sample,"Measure Density Private Model Test Sample"<> $SessionUUID],
			Model[Molecule, Oligomer, "Test 10mer Model[Molecule,Oligomer] for ExperimentMeasureDensity"<> $SessionUUID],
			Model[Sample,"10mer Test DNA for ExperimentMeasureDensity"<> $SessionUUID],
			Model[Sample,"10mer Test DNA with Density for ExperimentMeasureDensity"<> $SessionUUID],
			Object[Protocol,MeasureDensity,"Test Template Protocol for ExperimentMeasureDensity"<> $SessionUUID]
		};

		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		EraseObject[
			PickList[createdObjects,DatabaseMemberQ[createdObjects]],
			Force->True,
			Verbose->False
		];

		(* Create a Model[Molecule,Oligomer] Identity Model for the TargetConcentration unit test *)
		UploadOligomer[
			"Test 10mer Model[Molecule,Oligomer] for ExperimentMeasureDensity"<> $SessionUUID,
			PolymerType->DNA,
			Molecule->ToStrand["ACTGTGGACT"]
		];

		(* Create some Models for testing purposes *)
		UploadSampleModel[
			"10mer Test DNA for ExperimentMeasureDensity"<> $SessionUUID,
			Composition->{
				{20*Micromolar,Model[Molecule, Oligomer, "Test 10mer Model[Molecule,Oligomer] for ExperimentMeasureDensity"<> $SessionUUID]},
				{100*VolumePercent,Model[Molecule, "Water"]}
			},
			DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"],
			MSDSRequired -> False,
			Expires -> False,
			BiosafetyLevel -> "BSL-1",
			IncompatibleMaterials -> {None},
			State -> Liquid
		];

		UploadSampleModel[
			"10mer Test DNA with Density for ExperimentMeasureDensity"<> $SessionUUID,
			Composition->{
				{20*Micromolar,Model[Molecule, Oligomer, "Test 10mer Model[Molecule,Oligomer] for ExperimentMeasureDensity"<> $SessionUUID]},
				{100*VolumePercent,Model[Molecule, "Water"]}
			},
			DefaultStorageCondition->Model[StorageCondition,"Ambient Storage"],
			Density->1.5 Gram/Milliliter,
			MSDSRequired -> False,
			Expires -> False,
			BiosafetyLevel -> "BSL-1",
			IncompatibleMaterials -> {None},
			State -> Liquid,
			Notebook -> Null
		];
		UploadNotebook[Model[Sample,"10mer Test DNA with Density for ExperimentMeasureDensity"<> $SessionUUID],
			Null
		];

		(* Create some containers *)
		{
			emptyContainer,
			container1,
			container2,
			waterContainer,
			solidContainer,
			taredTube,
			fakeModel,
			fakeHeatedModel,
			fakeChilledModel,
			fakeProtocolID,
			thinTube1,
			thinTube2,
			thinTube3,
			oligoTube,
			hotTube,
			coldTube,
			ventilatedTube,
			modelSeveredTube,
			lowVolumeTube,
			noVolumeTube,
			privateModelTube
		} = Upload[{
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],Name->"MeasureDensity Empty Container"<> $SessionUUID,DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],Name->"MeasureDensity Test Container"<> $SessionUUID,DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],Name -> "MeasureDensity Test Container2"<> $SessionUUID, DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],Name -> "MeasureDensity Test Container3"<> $SessionUUID,DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],Site->Link[$Site],Name -> "MeasureDensity Test Container4"<> $SessionUUID,DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Site->Link[$Site],TareWeight -> 1.27*Gram,Name->"MeasureDensity Test Container5"<> $SessionUUID,DeveloperObject->True|>,
			<|Type->Model[Sample,StockSolution],Name->"Fake MeasureDensity Testing Model"<> $SessionUUID,DefaultStorageCondition->Link[Model[StorageCondition, "id:7X104vnR18vX"]],DeveloperObject->True|>,
			<|Type->Model[Sample,StockSolution],Name->"Fake MeasureDensity Heated Model"<> $SessionUUID,TransportWarmed->85Celsius,DefaultStorageCondition->Link[Model[StorageCondition, "id:7X104vnR18vX"]],DeveloperObject->True|>,
			<|Type->Model[Sample,StockSolution],Name->"Fake MeasureDensity Chilled Model"<> $SessionUUID,TransportChilled->True,DefaultStorageCondition->Link[Model[StorageCondition, "id:7X104vnR18vX"]],DeveloperObject->True|>,
			<|Type->Object[Protocol,SampleManipulation],Name->"A fake Parent Protocol for ExperimentMeasureDensity testing"<> $SessionUUID,Status->Processing,DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"8x43mm Glass Reaction Vial"],Objects],Site->Link[$Site],Name->"MeasureDensity Reaction Vial1"<> $SessionUUID,DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"8x43mm Glass Reaction Vial"],Objects],Site->Link[$Site],Name->"MeasureDensity Reaction Vial2"<> $SessionUUID,DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"8x43mm Glass Reaction Vial"],Objects],Site->Link[$Site],Name->"MeasureDensity Reaction Vial3"<> $SessionUUID,DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Site->Link[$Site],Name->"MeasureDensity Oligo Tube"<> $SessionUUID,TareWeight -> 1.27*Gram,DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Site->Link[$Site],Name->"MeasureDensity Heated Tube"<> $SessionUUID,TareWeight -> 1.27*Gram,DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Site->Link[$Site],Name->"MeasureDensity Chilled Tube"<> $SessionUUID,TareWeight -> 1.27*Gram,DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Site->Link[$Site],Name->"MeasureDensity Ventilated Tube"<> $SessionUUID,TareWeight -> 1.27*Gram,DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Site->Link[$Site],Name->"MeasureDensity SeveredModel Tube"<> $SessionUUID,TareWeight -> 1.27*Gram,DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Site->Link[$Site],Name->"MeasureDensity Low Volume Tube"<> $SessionUUID,TareWeight -> 1.27*Gram,DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Site->Link[$Site],Name->"MeasureDensity No Volume Tube"<> $SessionUUID,TareWeight -> 1.27*Gram,DeveloperObject->True|>,
			<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"2mL Tube"],Objects],Site->Link[$Site],Name->"MeasureDensity Private Model Tube"<> $SessionUUID,TareWeight -> 1.27*Gram,DeveloperObject->True|>
		}];

		(* Create some samples *)

		{
			testSample,
			waterSample,
			sampleWithoutDensity1,
			sampleWithoutDensity2,
			solidSample,
			fakeSample1,
			waterSample2,
			waterSample3,
			oligoSample,
			heatedSample,
			chilledSample,
			ventilatedSample,
			modelSeveredSample,
			lowVolumeSample,
			noVolumeSample,
			privateModelSample
		} = UploadSample[
			{
				Model[Sample,StockSolution,"Fake MeasureDensity Testing Model"<> $SessionUUID],
				Model[Sample,"Milli-Q water"],
				Model[Sample,StockSolution,"Fake MeasureDensity Testing Model"<> $SessionUUID],
				Model[Sample,StockSolution,"Fake MeasureDensity Testing Model"<> $SessionUUID],
				Model[Sample,"Ammonium Bicarbonate"],
				Model[Sample,StockSolution,"Fake MeasureDensity Testing Model"<> $SessionUUID],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"10mer Test DNA for ExperimentMeasureDensity"<> $SessionUUID],
				Model[Sample,StockSolution,"Fake MeasureDensity Heated Model"<> $SessionUUID],
				Model[Sample,StockSolution,"Fake MeasureDensity Chilled Model"<> $SessionUUID],
				Model[Sample,"Isoprene"],
				Model[Sample,"Milli-Q water"](*Temporary model, set to null after initial upload*),
				Model[Sample,"Milli-Q water"],
				Model[Sample,"Milli-Q water"],
				Model[Sample,"10mer Test DNA with Density for ExperimentMeasureDensity"<> $SessionUUID]
			},
			{
				{"A1",container1},
				{"A1",waterContainer},
				{"A1",taredTube},
				{"A1",container2},
				{"A1",solidContainer},
				{"A1",thinTube1},
				{"A1",thinTube2},
				{"A1",thinTube3},
				{"A1",oligoTube},
				{"A1",hotTube},
				{"A1",coldTube},
				{"A1",ventilatedTube},
				{"A1",modelSeveredTube},
				{"A1",lowVolumeTube},
				{"A1",noVolumeTube},
				{"A1",privateModelTube}
			},
			InitialAmount->{
				50 Milliliter,
				50 Milliliter,
				1.5 Milliliter,
				1.5 Milliliter,
				5 Gram,
				800 Microliter,
				600 Microliter,
				40 Microliter,
				1 Milliliter,
				1 Milliliter,
				1 Milliliter,
				4 Milliliter,
				1 Milliliter,
				20 Microliter,
				20 Microliter,
				1 Milliliter
			}
		];

		(* Secondary uploads *)
		Upload[{
			<|Object->testSample,Name->"Measure Density Test Sample"<> $SessionUUID,Status->Available,Replace[IncompatibleMaterials]->{None},DeveloperObject->True|>,
			<|Object->waterSample,Name->"Measure Density Test Water Sample"<> $SessionUUID,Status->Available,Replace[IncompatibleMaterials]->{None},DeveloperObject->True|>,
			<|Object->solidSample,Name->"Measure Density Test Solid Sample"<> $SessionUUID,Status->Available,Replace[IncompatibleMaterials]->{None},DeveloperObject->True|>,
			<|Object->sampleWithoutDensity1,Name->"Measure Density Test Sample In Tube Without Tare"<> $SessionUUID,Status->Available,Replace[IncompatibleMaterials]->{None},DeveloperObject->True|>,
			<|Object->sampleWithoutDensity2,Name->"Measure Density Test Sample No Density"<> $SessionUUID,Status->Available,Replace[IncompatibleMaterials]->{None},DeveloperObject->True|>,
			<|Object->fakeSample1,Name->"MeasureDensity Fake Sample w/ Fake Model"<> $SessionUUID,Status->Available,Replace[IncompatibleMaterials]->{None},DeveloperObject->True|>,
			<|Object->waterSample,Name->"Measure Density Test Water Sample2",Status->Available,Replace[IncompatibleMaterials]->{None},DeveloperObject->True|>,
			<|Object->waterSample,Name->"Measure Density Test Water Sample3",Status->Available,Replace[IncompatibleMaterials]->{None},DeveloperObject->True|>,
			<|Object->oligoSample,Name->"Measure Density Oligo Sample"<> $SessionUUID,Status->Available,Replace[IncompatibleMaterials]->{None},DeveloperObject->True|>,
			<|Object->heatedSample,Name->"Measure Density Heated Sample"<> $SessionUUID,Status->Available,Replace[IncompatibleMaterials]->{None},TransportWarmed->85 Celsius,DeveloperObject->True|>,
			<|Object->chilledSample,Name->"Measure Density Chilled Sample"<> $SessionUUID,Status->Available,Replace[IncompatibleMaterials]->{None},DeveloperObject->True|>,
			<|Object->ventilatedSample,Name->"Measure Density Ventilated Sample"<> $SessionUUID,Status->Available,Replace[IncompatibleMaterials]->{None},DeveloperObject->True|>,
			(*Added model severed object by setting model-> null here*)
			<|Object->modelSeveredSample,Name->"Measure Density Model Severed Test Sample"<> $SessionUUID,Status->Available,Replace[IncompatibleMaterials]->{None},DeveloperObject->True,Model->Null|>,
			<|Object->lowVolumeSample,Name->"Measure Density Low Volume Test Sample"<> $SessionUUID,Status->Available,Replace[IncompatibleMaterials]->{None},DeveloperObject->True|>,
			(*Null out the volume here for the unknown volume sample*)
			<|Object->noVolumeSample,Name->"Measure Density No Volume Test Sample"<> $SessionUUID,Status->Available,Volume->Null,Replace[IncompatibleMaterials]->{None},DeveloperObject->True|>,
			<|Object->privateModelSample,Name->"Measure Density Private Model Test Sample"<> $SessionUUID,Status->Available,Replace[IncompatibleMaterials]->{None},DeveloperObject->True|>
		}];

		(*Create a protocol that we'll use for template testing*)
		Block[{$PersonID = Object[User, "Test user for notebook-less test protocols"]},
			(*Create a protocol that we'll use for template testing*)
			templateHPLCProtocol = ExperimentMeasureDensity[Object[Sample,"Measure Density Test Sample"<> $SessionUUID],
				Name -> "Test Template Protocol for ExperimentMeasureDensity"<> $SessionUUID,
				Method->FixedVolumeWeight,
				NumberOfReplicates->4
			]
		];


	],

	Stubs :> {$PersonID = Object[User, "Test user for notebook-less test protocols"]},

	SymbolTearDown :> {
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		(* Erase all objects that were created in the course of these tests *)
		EraseObject[
			PickList[	$CreatedObjects,
				DatabaseMemberQ[$CreatedObjects]
			],
			Force->True,
			Verbose->False
		];
		(* Cleanse $CreatedObjects *)
		Unset[$CreatedObjects];
	}
];


DefineTests[
	ExperimentMeasureDensityOptions,
	{
		(* --- Basic Examples --- *)
		Module[{model,modelContainer,container,sample},
			Example[{Basic, "Generate a table of resolved options for an ExperimentMeasureDensity call to measure density of a single sample:"},
				ExperimentMeasureDensityOptions[sample],_Grid,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					container =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True, Site-> Link[$Site]]];
					sample=UploadSample[
						model,{"A1",container},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,container,sample},Force->True]}
			]
		],

		Module[{model,modelContainer,container,sampleA,sampleB,containerA,containerB},
			Example[{Basic, "Generate a table of resolved options for an ExperimentMeasureDensity call to measure density of a multiple sample:"},
				ExperimentMeasureDensityOptions[{sampleA,sampleB}],_Grid,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					containerA =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True, Site-> Link[$Site]]];
					containerB =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True, Site-> Link[$Site]]];
					sampleA=UploadSample[
						model,{"A1",containerA},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
					sampleB=UploadSample[
						model,{"A1",containerB},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,containerA,containerB,sampleA,sampleB},Force->True]}
			]
		],

		Module[{model,modelContainer,container,sample},
			Example[{Basic, "Generate a table of resolved options for an ExperimentMeasureDensity call to measure density of a sample in a container:"},
				ExperimentMeasureDensityOptions[container],_Grid,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					container =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True, Site-> Link[$Site]]];
					sample=UploadSample[
						model,{"A1",container},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,container,sample},Force->True]}
			]
		],

		(* --- Options Examples --- *)
		Module[{model,modelContainer,container,sample},
			Example[{Options, OutputFormat, "Generate a resolved list of options for an ExperimentMeasureDensity call to measure density of a single sample:"},
				ExperimentMeasureDensityOptions[Object[Sample,"ExperimentMeasureDensity sample"<>$SessionUUID],OutputFormat->List],
				{_Rule..},
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					container =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True, Site-> Link[$Site]]];
					sample=UploadSample[
						model,{"A1",container},
						Name->"ExperimentMeasureDensity sample"<>$SessionUUID,
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,container,sample},Force->True]}
			]
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	)
];


DefineTests[
	ExperimentMeasureDensityPreview,
	{
	(* --- Basic Examples --- *)
		Module[{model,modelContainer,container,sample},
			Example[
				{Basic, "Generate a preview for an ExperimentMeasureDensity call to measure density of a single sample (will always be Null):"},
				ExperimentMeasureDensityPreview[sample],Null,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					container =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True, Site-> Link[$Site]]];
					sample=UploadSample[
						model,{"A1",container},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,container,sample},Force->True]}
			]
		],

		Module[{model,modelContainer,container,sampleA,sampleB,containerA,containerB},
			Example[
				{Basic, "Generate a preview for an ExperimentMeasureDensity call to measure density of a multiple sample (will always be Null):"},
				ExperimentMeasureDensityPreview[{sampleA,sampleB}],Null,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					containerA =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True, Site-> Link[$Site]]];
					containerB =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True, Site-> Link[$Site]]];
					sampleA=UploadSample[
						model,{"A1",containerA},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
					sampleB=UploadSample[
						model,{"A1",containerB},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,containerA,containerB,sampleA,sampleB},Force->True]}
			]
		],

		Module[{model,modelContainer,container,sample},
			Example[
				{Basic, "Generate a preview for an ExperimentMeasureDensity call to measure density of a sample in a container (will always be Null):"},
				ExperimentMeasureDensityPreview[container],Null,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					container =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True, Site-> Link[$Site]]];
					sample=UploadSample[
						model,{"A1",container},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,container,sample},Force->True]}
			]
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	)
];


DefineTests[
	ValidExperimentMeasureDensityQ,
	{
	(* --- Basic Examples --- *)
		Module[{model,modelContainer,container,sample},
			Example[
				{Basic, "Validate an ExperimentMeasureDensity call to measure the density of a single sample:"},
				ValidExperimentMeasureDensityQ[sample],True,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					container =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True, Site-> Link[$Site]]];
					sample=UploadSample[
						model,{"A1",container},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,container,sample},Force->True]}
			]
		],

		Module[{model,modelContainer,container,sampleA,sampleB,containerA,containerB},
			Example[
				{Basic, "Validate an ExperimentMeasureDensity call to measure the density of multiple samples:"},
				ValidExperimentMeasureDensityQ[{sampleA,sampleB}],True,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					containerA =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True, Site-> Link[$Site]]];
					containerB =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True, Site-> Link[$Site]]];
					sampleA=UploadSample[
						model,{"A1",containerA},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
					sampleB=UploadSample[
						model,{"A1",containerB},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,containerA,containerB,sampleA,sampleB},Force->True]}
			]
		],

		Module[{model,modelContainer,container,sample},
			Example[
				{Basic, "Validate an ExperimentMeasureDensity call to filter to measure the density of a sample in a container:"},
				ValidExperimentMeasureDensityQ[container],True,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					container =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True, Site-> Link[$Site]]];
					sample=UploadSample[
						model,{"A1",container},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,container,sample},Force->True]}
			]
		],

	(* --- Options Examples --- *)
		Module[{model,modelContainer,container,sample},
			Example[
				{Options, OutputFormat, "Validate an ExperimentMeasureDensity call to measure the density a single sample, returning an ECL Test Summary:"},
				ValidExperimentMeasureDensityQ[sample,OutputFormat->TestSummary],_EmeraldTestSummary,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					container =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True, Site-> Link[$Site]]];
					sample=UploadSample[
						model,{"A1",container},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,container,sample},Force->True]}
			]
		],

		Module[{model,modelContainer,container,sample},
			Example[
				{Options, Verbose, "Validate an ExperimentMeasureDensity call to measure the density a single sample, printing a verbose summary of tests as they are run:"},
				ValidExperimentMeasureDensityQ[sample,Verbose->True],True,
				SetUp:>{
					model=Upload[Association[Type -> Model[Sample],DeveloperObject -> True, State->Liquid]];
					modelContainer=Upload[Association[
						Type -> Model[Container, Vessel],
						DeveloperObject -> True,
						Replace[Positions] -> {<|Name -> "A1", Footprint -> Null,MaxWidth -> Quantity[0.028575`, "Meters"],MaxDepth -> Quantity[0.028575`, "Meters"],MaxHeight -> Quantity[0.1143`, "Meters"]|>}]
					];
					container =Upload[Association[Type -> Object[Container, Vessel],Model -> Link[modelContainer, Objects], DeveloperObject -> True, Site-> Link[$Site]]];
					sample=UploadSample[
						model,{"A1",container},
						StorageCondition -> AmbientStorage,InitialAmount->10 Milliliter
					];
				},
				TearDown:>{EraseObject[{model,modelContainer,container,sample},Force->True]}
			]
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
	)
];


(* ::Section::Closed:: *)
(*End Test Package*)
