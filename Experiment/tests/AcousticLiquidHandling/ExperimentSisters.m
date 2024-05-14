(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentAcousticLiquidHandling Sister Functions : Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentAcousticLiquidHandling*)

(* ::Subsubsection:: *)
(*resolveAcousticLiquidHandlingSamplePrepOptions*)

DefineTests[
	resolveAcousticLiquidHandlingSamplePrepOptions,
	{
		Example[{Basic,"Given basic sample with no other options specified, choose a few to make sure they are Null/False:"},
			output=Experiment`Private`resolveAcousticLiquidHandlingSamplePrepOptions[{
				Object[Sample,
					"AcousticLiquidHandling Test Water Sample 1" <> $SessionUUID]},
				Cache -> {Null}];
			options = output[[1]][[2]];
			optionsChosen = Lookup[options,{Incubate,IncubationTemperature,Centrifuge,Filtration}],
			{{False},{Null},{False},{False}},
			Variables :> {output,options,optionsChosen}
		],

		Example[{Basic,"Given basic sample with a couple options specified, choose a few to make sure they are Null/False/specified:"},
			prepOptions={Aliquot -> {True}, AliquotSampleLabel -> {"aliquot sample label 1"},
				AliquotAmount -> {Automatic}, TargetConcentration -> {Automatic},
				TargetConcentrationAnalyte -> {Automatic},
				AssayVolume -> {Automatic}, ConcentratedBuffer -> {Automatic},
				BufferDilutionFactor -> {Automatic}, BufferDiluent -> {Automatic},
				AssayBuffer -> {Automatic},
				AliquotSampleStorageCondition -> {Automatic},
				DestinationWell -> {Automatic}, AliquotContainer -> {Null},
				ConsolidateAliquots -> Automatic, AliquotPreparation -> Automatic,
				Incubate -> {Automatic}, IncubationTemperature -> {Automatic},
				IncubationTime -> {Automatic}, Mix -> {Automatic},
				MixType -> {Automatic}, MixUntilDissolved -> {Automatic},
				MaxIncubationTime -> {Automatic},
				IncubationInstrument -> {Automatic}, AnnealingTime -> {Automatic},
				IncubateAliquotContainer -> {Automatic},
				IncubateAliquotDestinationWell -> {Automatic},
				IncubateAliquot -> {Automatic}, Centrifuge -> {Automatic},
				CentrifugeInstrument -> {Automatic},
				CentrifugeIntensity -> {Automatic}, CentrifugeTime -> {Automatic},
				CentrifugeTemperature -> {Automatic},
				CentrifugeAliquotContainer -> {Automatic},
				CentrifugeAliquotDestinationWell -> {Automatic},
				CentrifugeAliquot -> {Automatic}, Filtration -> {Automatic},
				FiltrationType -> {Automatic}, FilterInstrument -> {Automatic},
				Filter -> {Automatic}, FilterMaterial -> {Automatic},
				PrefilterMaterial -> {Automatic}, FilterPoreSize -> {Automatic},
				PrefilterPoreSize -> {Automatic}, FilterSyringe -> {Automatic},
				FilterHousing -> {Automatic}, FilterIntensity -> {Automatic},
				FilterTime -> {Automatic}, FilterTemperature -> {Automatic},
				FilterContainerOut -> {Automatic},
				FilterAliquotDestinationWell -> {Automatic},
				FilterAliquotContainer -> {Automatic}, FilterAliquot -> {Automatic},
				FilterSterile -> {Automatic}};

			output=Experiment`Private`resolveAcousticLiquidHandlingSamplePrepOptions[{
				Object[Sample,
					"AcousticLiquidHandling Test Water Sample 2" <> $SessionUUID]},
				Sequence@@prepOptions,Cache -> {Null}];
			options = output[[1]][[2]];
			optionsChosen = Lookup[options,{Aliquot,AliquotSampleLabel}],
			{{True},{"aliquot sample label 1"}},
			Variables :> {prepOptions,output,options,optionsChosen}
		],

		Example[{Basic,"Given basic sample with Incubate is True, choose a few to make sure they are the defaulted options:"},
			prepOptions={Aliquot -> {Automatic}, AliquotSampleLabel -> {Automatic},
				AliquotAmount -> {Automatic}, TargetConcentration -> {Automatic},
				TargetConcentrationAnalyte -> {Automatic},
				AssayVolume -> {Automatic}, ConcentratedBuffer -> {Automatic},
				BufferDilutionFactor -> {Automatic}, BufferDiluent -> {Automatic},
				AssayBuffer -> {Automatic},
				AliquotSampleStorageCondition -> {Automatic},
				DestinationWell -> {Automatic}, AliquotContainer -> {Null},
				ConsolidateAliquots -> Automatic, AliquotPreparation -> Automatic,
				Incubate -> {True}, IncubationTemperature -> {Ambient},
				IncubationTime -> {15Minute}, Mix -> {Automatic},
				MixType -> {Automatic}, MixUntilDissolved -> {Automatic},
				MaxIncubationTime -> {Automatic},
				IncubationInstrument -> {Automatic}, AnnealingTime -> {Automatic},
				IncubateAliquotContainer -> {Automatic},
				IncubateAliquotDestinationWell -> {Automatic},
				IncubateAliquot -> {Automatic}, Centrifuge -> {Automatic},
				CentrifugeInstrument -> {Automatic},
				CentrifugeIntensity -> {Automatic}, CentrifugeTime -> {Automatic},
				CentrifugeTemperature -> {Automatic},
				CentrifugeAliquotContainer -> {Automatic},
				CentrifugeAliquotDestinationWell -> {Automatic},
				CentrifugeAliquot -> {Automatic}, Filtration -> {Automatic},
				FiltrationType -> {Automatic}, FilterInstrument -> {Automatic},
				Filter -> {Automatic}, FilterMaterial -> {Automatic},
				PrefilterMaterial -> {Automatic}, FilterPoreSize -> {Automatic},
				PrefilterPoreSize -> {Automatic}, FilterSyringe -> {Automatic},
				FilterHousing -> {Automatic}, FilterIntensity -> {Automatic},
				FilterTime -> {Automatic}, FilterTemperature -> {Automatic},
				FilterContainerOut -> {Automatic},
				FilterAliquotDestinationWell -> {Automatic},
				FilterAliquotContainer -> {Automatic}, FilterAliquot -> {Automatic},
				FilterSterile -> {Automatic}};

			output=Experiment`Private`resolveAcousticLiquidHandlingSamplePrepOptions[{
				Object[Sample,
					"AcousticLiquidHandling Test Water Sample 2" <> $SessionUUID]},
				Sequence@@prepOptions,Cache -> {Null}];
			options = output[[1]][[2]];
			optionsChosen = Lookup[options,{Incubate,IncubationTemperature,IncubationTime,IncubationInstrument}],
			{{True},{Ambient},{15Minute},{Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"]}},
			Variables :> {prepOptions,output,options,optionsChosen}
		],

		Example[{Basic,"Given basic sample with Centrifuge is True, choose a few to make sure they are the defaulted options:"},
			prepOptions={Aliquot -> {Automatic}, AliquotSampleLabel -> {Automatic},
				AliquotAmount -> {Automatic}, TargetConcentration -> {Automatic},
				TargetConcentrationAnalyte -> {Automatic},
				AssayVolume -> {Automatic}, ConcentratedBuffer -> {Automatic},
				BufferDilutionFactor -> {Automatic}, BufferDiluent -> {Automatic},
				AssayBuffer -> {Automatic},
				AliquotSampleStorageCondition -> {Automatic},
				DestinationWell -> {Automatic}, AliquotContainer -> {Null},
				ConsolidateAliquots -> Automatic, AliquotPreparation -> Automatic,
				Incubate -> {Automatic}, IncubationTemperature -> {Automatic},
				IncubationTime -> {Automatic}, Mix -> {Automatic},
				MixType -> {Automatic}, MixUntilDissolved -> {Automatic},
				MaxIncubationTime -> {Automatic},
				IncubationInstrument -> {Automatic}, AnnealingTime -> {Automatic},
				IncubateAliquotContainer -> {Automatic},
				IncubateAliquotDestinationWell -> {Automatic},
				IncubateAliquot -> {Automatic}, Centrifuge -> {True},
				CentrifugeInstrument -> {Automatic},
				CentrifugeIntensity -> {Automatic}, CentrifugeTime -> {Automatic},
				CentrifugeTemperature -> {Automatic},
				CentrifugeAliquotContainer -> {Automatic},
				CentrifugeAliquotDestinationWell -> {Automatic},
				CentrifugeAliquot -> {Automatic}, Filtration -> {Automatic},
				FiltrationType -> {Automatic}, FilterInstrument -> {Automatic},
				Filter -> {Automatic}, FilterMaterial -> {Automatic},
				PrefilterMaterial -> {Automatic}, FilterPoreSize -> {Automatic},
				PrefilterPoreSize -> {Automatic}, FilterSyringe -> {Automatic},
				FilterHousing -> {Automatic}, FilterIntensity -> {Automatic},
				FilterTime -> {Automatic}, FilterTemperature -> {Automatic},
				FilterContainerOut -> {Automatic},
				FilterAliquotDestinationWell -> {Automatic},
				FilterAliquotContainer -> {Automatic}, FilterAliquot -> {Automatic},
				FilterSterile -> {Automatic}};

			output=Experiment`Private`resolveAcousticLiquidHandlingSamplePrepOptions[{
				Object[Sample,
					"AcousticLiquidHandling Test Water Sample 2" <> $SessionUUID]},
				Sequence@@prepOptions,Cache -> {Null}];
			options = output[[1]][[2]];
			optionsChosen = Lookup[options,{Centrifuge,CentrifugeInstrument,CentrifugeTemperature,CentrifugeTime}],
			{{True},{Model[Instrument, Centrifuge, "id:eGakldJEz14E"]},{Ambient},{5Minute}},
			Variables :> {prepOptions,output,options,optionsChosen}
		],

		Example[{Basic,"Given basic sample with Filtration is True, choose a few to make sure they are the defaulted options:"},
			prepOptions={Aliquot -> {Automatic}, AliquotSampleLabel -> {Automatic},
				AliquotAmount -> {Automatic}, TargetConcentration -> {Automatic},
				TargetConcentrationAnalyte -> {Automatic},
				AssayVolume -> {Automatic}, ConcentratedBuffer -> {Automatic},
				BufferDilutionFactor -> {Automatic}, BufferDiluent -> {Automatic},
				AssayBuffer -> {Automatic},
				AliquotSampleStorageCondition -> {Automatic},
				DestinationWell -> {Automatic}, AliquotContainer -> {Null},
				ConsolidateAliquots -> Automatic, AliquotPreparation -> Automatic,
				Incubate -> {True}, IncubationTemperature -> {Automatic},
				IncubationTime -> {Automatic}, Mix -> {Automatic},
				MixType -> {Automatic}, MixUntilDissolved -> {Automatic},
				MaxIncubationTime -> {Automatic},
				IncubationInstrument -> {Automatic}, AnnealingTime -> {Automatic},
				IncubateAliquotContainer -> {Automatic},
				IncubateAliquotDestinationWell -> {Automatic},
				IncubateAliquot -> {Automatic}, Centrifuge -> {Automatic},
				CentrifugeInstrument -> {Automatic},
				CentrifugeIntensity -> {Automatic}, CentrifugeTime -> {Automatic},
				CentrifugeTemperature -> {Automatic},
				CentrifugeAliquotContainer -> {Automatic},
				CentrifugeAliquotDestinationWell -> {Automatic},
				CentrifugeAliquot -> {Automatic}, Filtration -> {True},
				FiltrationType -> {Automatic}, FilterInstrument -> {Automatic},
				Filter -> {Automatic}, FilterMaterial -> {Automatic},
				PrefilterMaterial -> {Automatic}, FilterPoreSize -> {Automatic},
				PrefilterPoreSize -> {Automatic}, FilterSyringe -> {Automatic},
				FilterHousing -> {Automatic}, FilterIntensity -> {Automatic},
				FilterTime -> {Automatic}, FilterTemperature -> {Automatic},
				FilterContainerOut -> {Automatic},
				FilterAliquotDestinationWell -> {Automatic},
				FilterAliquotContainer -> {Automatic}, FilterAliquot -> {Automatic},
				FilterSterile -> {Automatic}};

			output=Experiment`Private`resolveAcousticLiquidHandlingSamplePrepOptions[{
				Object[Sample,
					"AcousticLiquidHandling Test Water Sample 2" <> $SessionUUID]},
				Sequence@@prepOptions,Cache -> {Null}];
			options = output[[1]][[2]];
			optionsChosen = Lookup[options,{Filtration,FiltrationType,FilterTime,FilterInstrument}],
			{{True},{Centrifuge},{5Minute},{Model[Instrument, Centrifuge, "id:eGakldJEz14E"]}},
			Variables :> {prepOptions,output,options,optionsChosen}
		]

	},
	SymbolSetUp:>(
		$CreatedObjects={};
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject->True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		Module[{namedObjects},
			namedObjects={
				Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
				Object[Sample,"AcousticLiquidHandling Test Water Sample 2"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test Source Plate 1"<>$SessionUUID],
				Object[Container,Plate,"AcousticLiquidHandling Test Source Plate 2"<>$SessionUUID]
			};

			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];

		Block[{$DeveloperUpload=True},
			Module[
				(* add variable for object we are creating here *)
				{
					sourceWaterSample1,sourceWaterSample2,sourcePlate1,sourcePlate2
				},

				(* Create some containers *)
				{
					(*1*)sourcePlate1,
					(*2*)sourcePlate2
				}=Upload[{
					(*1*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:7X104vn56dLX"],Objects],Name->"AcousticLiquidHandling Test Source Plate 1"<>$SessionUUID,Site->Link[$Site]|>,
					(*2*)<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"id:7X104vn56dLX"],Objects],Name->"AcousticLiquidHandling Test Source Plate 2"<>$SessionUUID,Site->Link[$Site]|>
				}];

				(* Create some samples *)
				{
					(*1*)sourceWaterSample1,
					(*2*)sourceWaterSample2
				}=ECL`InternalUpload`UploadSample[
					{
						(*1*)Model[Sample,"Milli-Q water"],
						(*2*)Model[Sample,"Milli-Q water"]
					},
					{
						(*1*){"A1",sourcePlate1},
						(*2*){"A1",sourcePlate2}
					},
					InitialAmount->{
						(*1*)30 Microliter,
						(*2*)30 Microliter
					},
					Name->{
						(*1*)"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID,
						(*2*)"AcousticLiquidHandling Test Water Sample 2"<>$SessionUUID
					},
					Status->Available,
					StorageCondition->Refrigerator
				];
			]
		];
	),

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{namedObjects},
			namedObjects=Quiet[Cases[
				Flatten[{
					(* also get rid of any other created objects *)
					$CreatedObjects,
					Object[Sample,"AcousticLiquidHandling Test Water Sample 1"<>$SessionUUID],
					Object[Sample,"AcousticLiquidHandling Test Water Sample 2"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test Source Plate 1"<>$SessionUUID],
					Object[Container,Plate,"AcousticLiquidHandling Test Source Plate 2"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			];

			(* clear $CreatedObjects *)
			Unset[$CreatedObjects]
		]
	)

];

(* ::Subsubsection:: *)
(*ExperimentAcousticLiquidHandlingPreview*)


DefineTests[
	ExperimentAcousticLiquidHandlingPreview,
	{
		Example[{Basic,"No preview is currently available for ExperimentAcousticLiquidHandling:"},
			ExperimentAcousticLiquidHandlingPreview[
				Transfer[
					Source->Object[Sample,"ExperimentAcousticLiquidHandlingPreview Test Water Sample" <> $SessionUUID],
					Amount->100 Nanoliter,
					Destination->{Object[Container,Plate,"ExperimentAcousticLiquidHandlingPreview Test Destination Plate" <> $SessionUUID],"A1"}
				]
			],
			Null
		],
		Example[{Basic,"Return Null for multiple primitive inputs:"},
			ExperimentAcousticLiquidHandlingPreview[{
				Transfer[
					Source->Object[Sample,"ExperimentAcousticLiquidHandlingPreview Test Water Sample" <> $SessionUUID],
					Amount->100 Nanoliter,
					Destination->{Object[Container,Plate,"ExperimentAcousticLiquidHandlingPreview Test Destination Plate" <> $SessionUUID],"A1"}
				],
				Aliquot[
					Source->Object[Sample,"ExperimentAcousticLiquidHandlingPreview Test Water Sample" <> $SessionUUID],
					Amounts->100 Nanoliter,
					Destinations->{
						{Object[Container,Plate,"ExperimentAcousticLiquidHandlingPreview Test Destination Plate" <> $SessionUUID],"B1"},
						{Object[Container,Plate,"ExperimentAcousticLiquidHandlingPreview Test Destination Plate" <> $SessionUUID],"B2"}
					}
				]
			}],
			Null
		],
		Example[{Additional,"If you wish to understand how the experiment will be performed try using ExperimentAcousticLiquidHandlingOptions:"},
			ExperimentAcousticLiquidHandlingOptions[
				Transfer[
					Source->Object[Sample,"ExperimentAcousticLiquidHandlingPreview Test Water Sample" <> $SessionUUID],
					Amount->100 Nanoliter,
					Destination->{Object[Container,Plate,"ExperimentAcousticLiquidHandlingPreview Test Destination Plate" <> $SessionUUID],"A1"}
				]
			],
			_Grid
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		$CreatedObjects={};

		Module[{namedObjects},
			namedObjects={
				Object[Sample,"ExperimentAcousticLiquidHandlingPreview Test Water Sample" <> $SessionUUID],
				Object[Container,Plate,"ExperimentAcousticLiquidHandlingPreview Test Source Plate" <> $SessionUUID],
				Object[Container,Plate,"ExperimentAcousticLiquidHandlingPreview Test Destination Plate" <> $SessionUUID],
				Object[Container,Bench,"test bench for ExperimentAcousticLiquidHandlingPreview tests" <> $SessionUUID]
			};
			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];
		Block[{$AllowSystemsProtocols=True, $DeveloperUpload=True},
			Module[{testBench,sourcePlate,destPlate,sample},
				(* create a test bench for our containers *)
				testBench=Upload[<|
					Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"test bench for ExperimentAcousticLiquidHandlingPreview tests" <> $SessionUUID,
					Site->Link[$Site]
				|>];

				(* create containers *)
				{
					sourcePlate,
					destPlate
				}=UploadSample[
					{
						Model[Container,Plate,"id:7X104vn56dLX"],
						Model[Container,Plate,"id:AEqRl9KmGPWa"]
					},
					{
						{"Work Surface",testBench},
						{"Work Surface",testBench}
					},
					FastTrack->True,
					Name->{
						"ExperimentAcousticLiquidHandlingPreview Test Source Plate" <> $SessionUUID,
						"ExperimentAcousticLiquidHandlingPreview Test Destination Plate" <> $SessionUUID
					}
				];

				(* create test samples *)
				{
					sample
				}=UploadSample[
					{
						Model[Sample,"Milli-Q water"]
					},
					{
						{"A1",sourcePlate}
					},
					Name->{
						"ExperimentAcousticLiquidHandlingPreview Test Water Sample" <> $SessionUUID
					},
					InitialAmount->{
						30 Microliter
					}
				];
			]
		]
	),

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{namedObjects},
			namedObjects=Quiet[Cases[
				Flatten[{
					(* also get rid of any other created objects *)
					$CreatedObjects,
					Object[Sample,"ExperimentAcousticLiquidHandlingPreview Test Water Sample" <> $SessionUUID],
					Object[Container,Plate,"ExperimentAcousticLiquidHandlingPreview Test Source Plate" <> $SessionUUID],
					Object[Container,Plate,"ExperimentAcousticLiquidHandlingPreview Test Destination Plate" <> $SessionUUID],
					Object[Container,Bench,"test bench for ExperimentAcousticLiquidHandlingPreview tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			];
			Unset[$CreatedObjects]
		]
	)
];


(* ::Subsubsection:: *)
(*ExperimentAcousticLiquidHandlingOptions*)


DefineTests[
	ExperimentAcousticLiquidHandlingOptions,
	{
		Example[{Basic,"Return a list of options in table form for a single input primitive:"},
			ExperimentAcousticLiquidHandlingOptions[
				Transfer[
					Source->Object[Sample,"ExperimentAcousticLiquidHandlingOptions Test Water Sample 1" <> $SessionUUID],
					Amount->100 Nanoliter,
					Destination->{Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Source Plate 2" <> $SessionUUID],"A1"}
				]
			],
			Graphics_
		],
		Example[{Basic,"Return a list of options in table form for multiple input primitives:"},
			ExperimentAcousticLiquidHandlingOptions[{
				Transfer[
					Source->Object[Sample,"ExperimentAcousticLiquidHandlingOptions Test Water Sample 1" <> $SessionUUID],
					Amount->100 Nanoliter,
					Destination->{Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Source Plate 2" <> $SessionUUID],"A1"}
				],
				Aliquot[
					Source->Object[Sample,"ExperimentAcousticLiquidHandlingOptions Test Water Sample 1" <> $SessionUUID],
					Amounts->100 Nanoliter,
					Destinations->{
						{Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Source Plate 2" <> $SessionUUID],"B1"},
						{Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Source Plate 2" <> $SessionUUID],"B2"}
					}
				]
			}],
			Graphics_
		],
		Example[{Options,OutputFormat,"If OutputFormat -> List, return a list of rules:"},
			ExperimentAcousticLiquidHandlingOptions[
				Transfer[
					Source->Object[Sample,"ExperimentAcousticLiquidHandlingOptions Test Water Sample 1" <> $SessionUUID],
					Amount->100 Nanoliter,
					Destination->{Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Source Plate 2" <> $SessionUUID],"A1"}
				],
				OutputFormat->List
			],
			{__Rule}
		],

		(* test if options specific to ExperimentAcousticLiquidHandling are include in the output list *)

		Example[{Options,Instrument,"Specify the instrument to perform acoustic liquid handling:"},
			options=ExperimentAcousticLiquidHandlingOptions[
				Transfer[
					Source->Object[Sample,"ExperimentAcousticLiquidHandlingOptions Test Water Sample 1" <> $SessionUUID],
					Amount->100 Nanoliter,
					Destination->{Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Source Plate 2" <> $SessionUUID],"A1"}
				],
				Instrument->Model[Instrument,LiquidHandler,AcousticLiquidHandler,"id:o1k9jAGrz9MG"],
				OutputFormat->List
			];
			Lookup[options,Instrument],
			ObjectP[Model[Instrument,LiquidHandler,AcousticLiquidHandler,"id:o1k9jAGrz9MG"]],
			Variables:>{options}
		],
		Example[{Options,OptimizePrimitives,"Specify how the manipulations should be rearranged to improve transfer throughput:"},
			options=ExperimentAcousticLiquidHandlingOptions[
				{
					Transfer[
						Source->Object[Sample,"ExperimentAcousticLiquidHandlingOptions Test Water Sample 1" <> $SessionUUID],
						Amount->100 Nanoliter,
						Destination->{Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Destination Plate 2" <> $SessionUUID],"A1"}
					],
					Transfer[
						Source->Object[Sample,"ExperimentAcousticLiquidHandlingOptions Test Water Sample 2" <> $SessionUUID],
						Amount->100 Nanoliter,
						Destination->{Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Destination Plate 2" <> $SessionUUID],"A1"}
					],
					Transfer[
						Source->Object[Sample,"ExperimentAcousticLiquidHandlingOptions Test Water Sample 1" <> $SessionUUID],
						Amount->100 Nanoliter,
						Destination->{Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Destination Plate 2" <> $SessionUUID],"B1"}
					]
				},
				OptimizePrimitives->SourcePlateCentric,
				OutputFormat->List
			];
			Lookup[options,OptimizePrimitives],
			SourcePlateCentric,
			Variables:>{options}
		],
		Example[{Options,FluidAnalysisMeasurement,"Specify the measurement type used to determine the fluid properties of the source samples:"},
			options=ExperimentAcousticLiquidHandlingOptions[
				Transfer[
					Source->Object[Sample,"ExperimentAcousticLiquidHandlingOptions Test Water Sample 1" <> $SessionUUID],
					Amount->100 Nanoliter,
					Destination->{Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Source Plate 2" <> $SessionUUID],"A1"}
				],
				FluidAnalysisMeasurement->AcousticImpedance,
				OutputFormat->List
			];
			Lookup[options,FluidAnalysisMeasurement],
			AcousticImpedance,
			Variables:>{options}
		],
		Example[{Options,FluidTypeCalibration,"Specify the calibration used by the acoustic liquid handler to transfer liquid of different types:"},
			options=ExperimentAcousticLiquidHandlingOptions[
				Transfer[
					Source->Object[Sample,"ExperimentAcousticLiquidHandlingOptions Test Water Sample 1" <> $SessionUUID],
					Amount->100 Nanoliter,
					Destination->{Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Source Plate 2" <> $SessionUUID],"A1"}
				],
				FluidTypeCalibration->AqueousWithoutSurfactant,
				OutputFormat->List
			];
			Lookup[options,FluidTypeCalibration],
			AqueousWithoutSurfactant,
			Variables:>{options}
		],
		Example[{Options,InWellSeparation,"Specify whether the droplets transfer to the same destination well are physically separated:"},
			options=ExperimentAcousticLiquidHandlingOptions[
				Consolidation[
					Sources->{
						Object[Sample,"ExperimentAcousticLiquidHandlingOptions Test Water Sample 1" <> $SessionUUID],
						Object[Sample,"ExperimentAcousticLiquidHandlingOptions Test Water Sample 2" <> $SessionUUID]
					},
					Amounts->100 Nanoliter,
					Destination->{Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Destination Plate 1" <> $SessionUUID],"A1"}
				],
				InWellSeparation->True,
				OutputFormat->List
			];
			Lookup[options,InWellSeparation],
			True,
			Variables:>{options}
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
		Module[{namedObjects},
			namedObjects={
				Object[Sample,"ExperimentAcousticLiquidHandlingOptions Test Water Sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentAcousticLiquidHandlingOptions Test Water Sample 2" <> $SessionUUID],
				Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Source Plate 1" <> $SessionUUID],
				Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Source Plate 2" <> $SessionUUID],
				Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Destination Plate 1" <> $SessionUUID],
				Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Destination Plate 2" <> $SessionUUID],
				Object[Container,Bench,"test bench for ExperimentAcousticLiquidHandlingOptions tests" <> $SessionUUID]
			};
			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];
		Block[{$AllowSystemsProtocols=True, $DeveloperUpload=True},
			Module[
				{
					testBench,sourcePlate1,sourcePlate2,destPlate1,destPlate2,sample1,sample2
				},
				(* create a test bench for our containers *)
				testBench=Upload[<|
					Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"test bench for ExperimentAcousticLiquidHandlingOptions tests" <> $SessionUUID,
					Site->Link[$Site]
				|>];

				(* create containers *)
				{
					sourcePlate1,
					sourcePlate2,
					destPlate1,
					destPlate2
				}=UploadSample[
					{
						Model[Container,Plate,"id:7X104vn56dLX"],
						Model[Container,Plate,"id:7X104vn56dLX"],
						Model[Container,Plate,"id:AEqRl9KmGPWa"],
						Model[Container,Plate,"id:AEqRl9KmGPWa"]
					},
					{
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench}
					},
					FastTrack->True,
					Name->{
						"ExperimentAcousticLiquidHandlingOptions Test Source Plate 1" <> $SessionUUID,
						"ExperimentAcousticLiquidHandlingOptions Test Source Plate 2" <> $SessionUUID,
						"ExperimentAcousticLiquidHandlingOptions Test Destination Plate 1" <> $SessionUUID,
						"ExperimentAcousticLiquidHandlingOptions Test Destination Plate 2" <> $SessionUUID
					}
				];
				(* create test samples *)
				{
					sample1,
					sample2
				}=UploadSample[
					{
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"]
					},
					{
						{"A1",sourcePlate1},
						{"A1",sourcePlate2}
					},
					Name->{
						"ExperimentAcousticLiquidHandlingOptions Test Water Sample 1" <> $SessionUUID,
						"ExperimentAcousticLiquidHandlingOptions Test Water Sample 2" <> $SessionUUID
					},
					InitialAmount->{
						30 Microliter,
						30 Microliter
					}
				];
			]
		]
	),

	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{allObjects},
			allObjects=Quiet[Cases[Flatten[{
				$CreatedObjects,
				Object[Sample,"ExperimentAcousticLiquidHandlingOptions Test Water Sample 1" <> $SessionUUID],
				Object[Sample,"ExperimentAcousticLiquidHandlingOptions Test Water Sample 2" <> $SessionUUID],
				Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Source Plate 1" <> $SessionUUID],
				Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Source Plate 2" <> $SessionUUID],
				Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Destination Plate 1" <> $SessionUUID],
				Object[Container,Plate,"ExperimentAcousticLiquidHandlingOptions Test Destination Plate 2" <> $SessionUUID],
				Object[Container,Bench,"test bench for ExperimentAcousticLiquidHandlingOptions tests" <> $SessionUUID]
			}],ObjectP[]]];
			EraseObject[
				PickList[allObjects,DatabaseMemberQ[allObjects]],
				Force->True,
				Verbose->False
			];
			Unset[$CreatedObjects];
		]
	)
];


(* ::Subsubsection:: *)
(*ValidExperimentAcousticLiquidHandlingQ*)


DefineTests[
	ValidExperimentAcousticLiquidHandlingQ,
	{
		Example[{Basic,"Determine the validity of a call on a single input primitive:"},
			ValidExperimentAcousticLiquidHandlingQ[
				Transfer[
					Source->Object[Sample,"ValidExperimentAcousticLiquidHandlingQ Test Water Sample 1" <> $SessionUUID],
					Amount->100 Nanoliter,
					Destination->{Object[Container,Plate,"ValidExperimentAcousticLiquidHandlingQ Test Destination Plate 1" <> $SessionUUID],"A1"}
				]
			],
			True
		],
		Example[{Basic,"Determine the validity of a call on multiple input primitives:"},
			ValidExperimentAcousticLiquidHandlingQ[{
				Transfer[
					Source->Object[Sample,"ValidExperimentAcousticLiquidHandlingQ Test Water Sample 1" <> $SessionUUID],
					Amount->100 Nanoliter,
					Destination->{Object[Container,Plate,"ValidExperimentAcousticLiquidHandlingQ Test Destination Plate 1" <> $SessionUUID],"A1"}
				],
				Aliquot[
					Source->Object[Sample,"ValidExperimentAcousticLiquidHandlingQ Test Water Sample 2" <> $SessionUUID],
					Amounts->100 Nanoliter,
					Destinations->{
						{Object[Container,Plate,"ValidExperimentAcousticLiquidHandlingQ Test Destination Plate 1" <> $SessionUUID],"B1"},
						{Object[Container,Plate,"ValidExperimentAcousticLiquidHandlingQ Test Destination Plate 2" <> $SessionUUID],"B2"}
					}
				]
			}],
			True
		],
		Example[{Basic,"Return False if there are problems with the inputs or options:"},
			ValidExperimentAcousticLiquidHandlingQ[
				Transfer[
					Source->Object[Sample,"ValidExperimentAcousticLiquidHandlingQ Test Water Sample 1" <> $SessionUUID],
					Amount->100 Nanoliter,
					Destination->{Object[Container,Plate,"ValidExperimentAcousticLiquidHandlingQ Test Destination Plate 1" <> $SessionUUID],"A1"}
				],
				InWellSeparation->True
			],
			False
		],
		Example[{Options,OutputFormat,"If OutputFormat -> TestSummary, return a test summary instead of a Boolean:"},
			ValidExperimentAcousticLiquidHandlingQ[
				Transfer[
					Source->Object[Sample,"ValidExperimentAcousticLiquidHandlingQ Test Water Sample 1" <> $SessionUUID],
					Amount->100 Nanoliter,
					Destination->{Object[Container,Plate,"ValidExperimentAcousticLiquidHandlingQ Test Destination Plate 1" <> $SessionUUID],"A1"}
				],
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"If Verbose -> Failures, print the failing tests:"},
			ValidExperimentAcousticLiquidHandlingQ[
				Transfer[
					Source->Object[Sample,"ValidExperimentAcousticLiquidHandlingQ Test Water Sample 1" <> $SessionUUID],
					Amount->100 Nanoliter,
					Destination->{Object[Container,Plate,"ValidExperimentAcousticLiquidHandlingQ Test Destination Plate 1" <> $SessionUUID],"A1"}
				],
				InWellSeparation->True,
				Verbose->Failures
			],
			False
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
		Module[{namedObjects},
			namedObjects={
				Object[Sample,"ValidExperimentAcousticLiquidHandlingQ Test Water Sample 1" <> $SessionUUID],
				Object[Sample,"ValidExperimentAcousticLiquidHandlingQ Test Water Sample 2" <> $SessionUUID],
				Object[Container,Plate,"ValidExperimentAcousticLiquidHandlingQ Test Source Plate 1" <> $SessionUUID],
				Object[Container,Plate,"ValidExperimentAcousticLiquidHandlingQ Test Source Plate 2" <> $SessionUUID],
				Object[Container,Plate,"ValidExperimentAcousticLiquidHandlingQ Test Destination Plate 1" <> $SessionUUID],
				Object[Container,Plate,"ValidExperimentAcousticLiquidHandlingQ Test Destination Plate 2" <> $SessionUUID],
				Object[Container,Bench,"test bench for ValidExperimentAcousticLiquidHandlingQ tests" <> $SessionUUID]
			};
			EraseObject[
				PickList[namedObjects,DatabaseMemberQ[namedObjects]],
				Force->True,
				Verbose->False
			]
		];
		Block[{$AllowSystemsProtocols=True, $DeveloperUpload=True},
			Module[
				{
					testBench,sourcePlate1,sourcePlate2,destPlate1,destPlate2,sample1,sample2
				},
				(* create a test bench for our containers *)
				testBench=Upload[<|
					Type->Object[Container,Bench],
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Name->"test bench for ValidExperimentAcousticLiquidHandlingQ tests" <> $SessionUUID,
					Site->Link[$Site]
				|>];

				(* create containers *)
				{
					sourcePlate1,
					sourcePlate2,
					destPlate1,
					destPlate2
				}=UploadSample[
					{
						Model[Container,Plate,"id:7X104vn56dLX"],
						Model[Container,Plate,"id:7X104vn56dLX"],
						Model[Container,Plate,"id:7X104vn56dLX"],
						Model[Container,Plate,"id:7X104vn56dLX"]
					},
					{
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench},
						{"Work Surface",testBench}
					},
					FastTrack->True,
					Name->{
						"ValidExperimentAcousticLiquidHandlingQ Test Source Plate 1" <> $SessionUUID,
						"ValidExperimentAcousticLiquidHandlingQ Test Source Plate 2" <> $SessionUUID,
						"ValidExperimentAcousticLiquidHandlingQ Test Destination Plate 1" <> $SessionUUID,
						"ValidExperimentAcousticLiquidHandlingQ Test Destination Plate 2" <> $SessionUUID
					}
				];
				(* create test samples *)
				{
					sample1,
					sample2
				}=UploadSample[
					{
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"]
					},
					{
						{"A1",sourcePlate1},
						{"A1",sourcePlate2}
					},
					Name->{
						"ValidExperimentAcousticLiquidHandlingQ Test Water Sample 1" <> $SessionUUID,
						"ValidExperimentAcousticLiquidHandlingQ Test Water Sample 2" <> $SessionUUID
					},
					InitialAmount->{
						30 Microliter,
						30 Microliter
					}
				];

				]
			]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		Module[{allObjects},
			allObjects=Quiet[Cases[Flatten[{
				$CreatedObjects,
				Object[Sample,"ValidExperimentAcousticLiquidHandlingQ Test Water Sample 1" <> $SessionUUID],
				Object[Sample,"ValidExperimentAcousticLiquidHandlingQ Test Water Sample 2" <> $SessionUUID],
				Object[Container,Plate,"ValidExperimentAcousticLiquidHandlingQ Test Source Plate 1" <> $SessionUUID],
				Object[Container,Plate,"ValidExperimentAcousticLiquidHandlingQ Test Source Plate 2" <> $SessionUUID],
				Object[Container,Plate,"ValidExperimentAcousticLiquidHandlingQ Test Destination Plate 1" <> $SessionUUID],
				Object[Container,Plate,"ValidExperimentAcousticLiquidHandlingQ Test Destination Plate 2" <> $SessionUUID],
				Object[Container,Bench,"test bench for ValidExperimentAcousticLiquidHandlingQ tests" <> $SessionUUID]
			}], ObjectP[]]];
			EraseObject[
				PickList[allObjects,DatabaseMemberQ[allObjects]],
				Force->True,
				Verbose->False
			];
			Unset[$CreatedObjects];
		];
	)
];