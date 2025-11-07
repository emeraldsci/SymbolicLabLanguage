(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentTransfer: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsubsection:: *)
(*ExperimentTransfer*)

DefineTests[
	ExperimentTransfer,
	{
		(* Basic Examples *)
		Example[{Basic,"Basic transfer with liquid samples in 50mL Tubes:"},
			ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					Instrument -> ObjectP[Model[Instrument, Pipette]],
					Balance -> Null,
					Tips -> ObjectP[Model[Item, Tips]],
					TipType -> TipTypeP,
					TipMaterial -> MaterialP,
					ReversePipetting -> False,
					Needle -> Null,
					WeighingContainer -> Null,
					Tolerance -> Null,
					HandPump -> Null,
					QuantitativeTransfer -> False,
					QuantitativeTransferWashSolution -> Null,
					QuantitativeTransferWashVolume -> Null,
					QuantitativeTransferWashInstrument -> Null,
					QuantitativeTransferWashTips -> Null,
					NumberOfQuantitativeTransferWashes -> Null,
					UnsealHermeticSource -> Null,
					UnsealHermeticDestination -> Null,
					BackfillNeedle -> Null,
					BackfillGas -> Null,
					VentingNeedle -> Null,
					TipRinse -> False,
					TipRinseSolution -> Null,
					TipRinseVolume -> Null,
					NumberOfTipRinses -> Null,
					IntermediateDecant -> False,
					IntermediateContainer -> Null
				}]
			}
		],
		Example[{Basic, "Transfer is allowed from one source to multiple destination with multiple amounts:"},
			ExperimentTransfer[
				Model[Sample, "Milli-Q water"],
				{
					Model[Container, Vessel, "2mL Tube"],
					Model[Container, Vessel, "2mL Tube"]
				},
				{
					1 Milliliter,
					0.8 Milliliter
				}
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Example[{Additional, "Transfer automatically expand source/destination/amount singletons to match the length of the listed input:"},
			{
				(* a, b, {c, c} *)
				ExperimentTransfer[Model[Sample, "Milli-Q water"], Model[Container, Vessel, "2mL Tube"], {1 Milliliter, 0.8 Milliliter}],
				(* a, {b, b}, c *)
				ExperimentTransfer[Model[Sample, "Milli-Q water"], {Model[Container, Vessel, "2mL Tube"], Model[Container, Vessel, "2mL Tube"]}, 1 Milliliter],
				(* {a, a}, b, c *)
				ExperimentTransfer[{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]}, Model[Container, Vessel, "2mL Tube"], 1 Milliliter],
				(* a, {b, b}, {c, c} *)
				ExperimentTransfer[Model[Sample, "Milli-Q water"], {Model[Container, Vessel, "2mL Tube"], Model[Container, Vessel, "2mL Tube"]}, {1 Milliliter, 0.8 Milliliter}],
				(* {a, a}, b, {c, c} *)
				ExperimentTransfer[{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]}, Model[Container, Vessel, "2mL Tube"], {1 Milliliter, 0.8 Milliliter}],
				(* {a, a}, {b, b}, c *)
				ExperimentTransfer[{Model[Sample, "Milli-Q water"], Model[Sample, "Milli-Q water"]}, {Model[Container, Vessel, "2mL Tube"], Model[Container, Vessel, "2mL Tube"]}, 1 Milliliter]
			},
			{ObjectP[Object[Protocol, ManualSamplePreparation]]..}
		],
		Example[{Options,PipettingMethod,"Setting this option to control the pipetting parameters in Robotic transfers:"},
			Lookup[
				ExperimentTransfer[
					{
						Model[Sample, "Milli-Q water"],
						{1, Model[Container, Vessel, "id:bq9LA0dBGGR6"]}
					},
					{
						{1, Model[Container, Vessel, "id:bq9LA0dBGGR6"]},
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						0.5 Milliliter,
						0.5 Milliliter
					},
					PipettingMethod -> Model[Method, Pipetting, "DMSO"],
					Preparation -> Robotic,
					Output -> Options
				],
				{PipettingMethod, CorrectionCurve}
			],
			{
				ObjectP[Model[Method, Pipetting, "DMSO"]],
				Round[Download[Model[Method, Pipetting, "DMSO"],CorrectionCurve], 0.01 Microliter]
			}
		],
		Example[{Options,PipettingMethod,"Setting this option to control the pipetting parameters in Robotic transfers. This option can be overwritten by other pipetting parameter options:"},
			Lookup[
				ExperimentTransfer[
					{
						Model[Sample, "Milli-Q water"],
						{1, Model[Container, Vessel, "id:bq9LA0dBGGR6"]}
					},
					{
						{1, Model[Container, Vessel, "id:bq9LA0dBGGR6"]},
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						0.5 Milliliter,
						0.5 Milliliter
					},
					PipettingMethod -> Model[Method, Pipetting, "DMSO"],
					AspirationRate -> 50 Microliter/Second,
					Preparation -> Robotic,
					Output -> Options
				],
				{PipettingMethod, AspirationRate}
			],
			{
				ObjectP[Model[Method, Pipetting, "DMSO"]],
				50 Microliter/Second
			}
		],
		Example[{Options,CorrectionCurve,"Setting this option to control the relationship between a target volume and the corrected volume that needs to be aspirated or dispensed to reach the target volume:"},
			Lookup[
				ExperimentTransfer[
					Model[Sample, "Milli-Q water"],
					Model[Container, Vessel, "2mL Tube"],
					0.5 Milliliter,
					CorrectionCurve -> {
						{0 Microliter, 0 Microliter},
						{50 Microliter, 60 Microliter},
						{150 Microliter, 180 Microliter},
						{300 Microliter, 345 Microliter},
						{500 Microliter, 560 Microliter},
						{1000 Microliter, 1050 Microliter}
					},
					Preparation -> Robotic,
					Output -> Options
				],
				CorrectionCurve
			],
			{
				{0 Microliter, 0 Microliter},
				{50 Microliter, 60 Microliter},
				{150 Microliter, 180 Microliter},
				{300 Microliter, 345 Microliter},
				{500 Microliter, 560 Microliter},
				{1000 Microliter, 1050 Microliter}
			},
			EquivalenceFunction->Equal
		],
		Example[{Messages,"IncompatibleTipItemConsumable","An error is thrown if the specified Tips is a Model[Item,Consumable] and the Instrument is not a Model[Container,GraduatedCylinder] and the destination container is not of Model[Container,Vessel,VolumetricFlask]"},
			ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter,
				Tips-> Model[Item, Consumable, "id:bq9LA0J1xmBd"] (*Model[Item, Consumable, "VWR Disposable Transfer Pipet"]*)
			],
			$Failed,
			Messages :> {
				(* Though use of Model[Item,Consumable] always throws out error IncorrectlySpecifiedTransferOptions outside of FTV, we add IncompatibleTipItemConsumable to have a clear message not to use this model as Tips *)
				Error::IncorrectlySpecifiedTransferOptions,
				Error::IncompatibleTipItemConsumable,
				Error::InvalidInput,
				Error::InvalidOption
			}
		],
		Example[{Messages,"CorrectionCurveNotMonotonic","A warning is thrown if the specified CorrectionCurve does not have monotonically increasing actual volume values:"},
			Lookup[
				ExperimentTransfer[
					Model[Sample, "Milli-Q water"],
					Model[Container, Vessel, "2mL Tube"],
					0.5 Milliliter,
					CorrectionCurve -> {
						{0 Microliter, 0 Microliter},
						{60 Microliter, 55 Microliter},
						{50 Microliter, 60 Microliter},
						{150 Microliter, 180 Microliter},
						{300 Microliter, 345 Microliter},
						{500 Microliter, 560 Microliter},
						{1000 Microliter, 1050 Microliter}
					},
					Preparation -> Robotic,
					Output -> Options
				],
				CorrectionCurve
			],
			{
				{0 Microliter, 0 Microliter},
				{60 Microliter, 55 Microliter},
				{50 Microliter, 60 Microliter},
				{150 Microliter, 180 Microliter},
				{300 Microliter, 345 Microliter},
				{500 Microliter, 560 Microliter},
				{1000 Microliter, 1050 Microliter}
			},
			EquivalenceFunction->Equal,
			Messages :> {Warning::CorrectionCurveNotMonotonic}
		],
		Example[{Messages,"CorrectionCurveIncomplete","A warning is thrown if the specified CorrectionCurve does not covers the transfer volume range of 0 uL - 1000 uL:"},
			Lookup[
				ExperimentTransfer[
					Model[Sample, "Milli-Q water"],
					Model[Container, Vessel, "2mL Tube"],
					0.5 Milliliter,
					PipettingMethod -> Model[Method, Pipetting, "Test pipetting method for ExperimentTransfer" <> $SessionUUID],
					Preparation -> Robotic,
					Output -> Options
				],
				PipettingMethod
			],
			ObjectP[Model[Method, Pipetting, "Test pipetting method for ExperimentTransfer" <> $SessionUUID]],
			Messages :> {Warning::CorrectionCurveIncomplete}
		],
		Example[{Messages,"InvalidCorrectionCurveZeroValue","A CorrectionCurve with a 0 Microliter target volume entry must have a 0 Microliter actual volume value:"},
			ExperimentTransfer[
				Model[Sample, "Milli-Q water"],
				Model[Container, Vessel, "2mL Tube"],
				0.5 Milliliter,
				CorrectionCurve -> {
					{0 Microliter, 5 Microliter},
					{50 Microliter, 60 Microliter},
					{150 Microliter, 180 Microliter},
					{300 Microliter, 345 Microliter},
					{500 Microliter, 560 Microliter},
					{1000 Microliter, 1050 Microliter}
				},
				Preparation -> Robotic
			],
			$Failed,
			Messages :> {Error::InvalidCorrectionCurveZeroValue,Error::InvalidOption}
		],
		Example[{Options,UnsealHermeticDestination,"Setting this option indicates to Transfer that the destination container will not be hermetic and therefore tips can be used if the source container is also not hermetic:"},
			Lookup[
				ExperimentTransfer[
					{
						Model[Sample, "Milli-Q water"],
						{1, Model[Container, Vessel, "id:bq9LA0dBGGR6"]}
					},
					{
						{1, Model[Container, Vessel, "id:bq9LA0dBGGR6"]},
						Model[Container, Vessel, "id:6V0npvmW99k1"]
					},
					{
						1 Milliliter,
						1 Milliliter
					},
					ReplaceDestinationCover -> {Automatic, True},
					Output -> Options
				],
				{Tips, UnsealHermeticDestination}
			],
			{
				{_, ObjectP[]}|ObjectP[],
				{_, True}
			}
		],
		Example[{Options,ReplaceSourceCover,"Indicate that the source sample's old cover should be replaced with a new cover:"},
			Lookup[
				ExperimentTransfer[
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					1 Milliliter,
					ReplaceSourceCover->True,
					Output -> Options
				],
				ReplaceSourceCover
			],
			True
		],
		Example[{Options,ReplaceDestinationCover,"Indicate that the destination sample's old cover should not be replaced and instead the original cover should be reused:"},
			Lookup[
				ExperimentTransfer[
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					1 Milliliter,
					ReplaceDestinationCover->False,
					Output -> Options
				],
				ReplaceDestinationCover
			],
			False
		],
		Example[{Options,RentDestinationContainer,"Indicates if the container model resource requested for this sample should be rented when this experiment is performed:"},
			Module[{resource, protocol, relatedResources},
				resource=Upload[<|Type->Object[Resource, Sample],RentContainer->True|>];

				protocol=ExperimentTransfer[
					Object[Sample, "Test powder sample 6 (SampleHandling->Null) in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Model[Container, Vessel, "id:J8AY5jwzPPR7"],
					1 Gram,
					ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID],
					PreparedResources->{resource}
				];

				relatedResources=Cases[Download[protocol, RequiredResources],{_,Destinations,___}][[All,1]];
				Download[relatedResources,Rent]
			],
			{True}
		],
		Example[{Options,Fresh,"Indicates if a fresh sample should be used when fulfilling the model resource of the transfer source:"},
			Module[{resource, protocol, relatedResources},
				resource=Upload[<|Type->Object[Resource, Sample],Fresh->True|>];

				protocol=ExperimentTransfer[
					Model[Sample, StockSolution, "1x PBS with BSA"],
					Model[Container, Vessel, "50mL Tube"],
					500 Microliter,
					Preparation->Robotic,
					ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID],
					PreparedResources->{resource}
				];

				relatedResources=Cases[Download[protocol, RequiredResources],{_,LabeledObjects,___}][[All,1]];
				Download[relatedResources,Fresh]
			],
			(* First resource corresponds to the source stock solution *)
			{True,Null}
		],
		Example[{Options,OrderFulfilled,"Tie an order to the protocol using OrderFulfilled option:"},
			Module[{testOrder, protocol},
				(* Make an order that should be fulfilled internally *)
				testOrder = OrderSamples[
					Model[Sample, "Milli-Q water"],
					5 * Milliliter,
					InternalOrder -> True
				];

				protocol = ExperimentTransfer[
					Model[Sample, "Milli-Q water"],
					Model[Container, Vessel, "id:bq9LA0dBGGR6"], (* Model[Container, Vessel, "50mL Tube"] *)
					5 * Milliliter,
					OrderFulfilled -> testOrder
				];

				Download[First[testOrder], Fulfillment]
			],
			{LinkP[{Object[Protocol, ManualSamplePreparation], Object[Protocol, RoboticSamplePreparation]}]}
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Options, skip the resource packets and simulation functions:"},
			ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter,
				ReplaceDestinationCover->False,
				Output -> Options,
				OptionsResolverOnly -> True
			],
			{__Rule},
			(* stubbing to be False so that we return $Failed if we get here; the point of the option though is that we don't get here *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=(Message[Error::ShouldntGetHere];False)}
		],
		Example[{Options, OptionsResolverOnly, "If OptionsResolverOnly -> True and Output -> Result, ignore OptionsResolverOnly and you have to keep going:"},
			ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter,
				ReplaceDestinationCover->False,
				Output -> Result,
				OptionsResolverOnly -> True
			],
			$Failed,
			(* stubbing to be False so that we return $Failed; in this case, it should actually get to this point *)
			Stubs :> {Resources`Private`fulfillableResourceQ[___]:=False}
		],
		Example[{Options, SterileTechnique, "If SterileTechnique is set to True, perform transfers using technique that is designed to keep the sample extremely clean:"},
			options = ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Model[Container, Plate, "Omni Tray Sterile Media Plate"],
				1 Milliliter,
				SterileTechnique -> True,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, SterileTechnique],
			True,
			Variables :> {options}
		],
		Example[{Options, CountAsPassage, "CountAsPassage can be set to True to increase passage number by 1 in the CellPassageLog:"},
			{options, simulation} = ExperimentTransfer[
				Object[Sample, "Test cell sample 1 for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				0.1 Milliliter,
				CountAsPassage -> True,
				Output -> {Options, Simulation}
			];
			{
				Lookup[options, CountAsPassage],
				Download[Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], CellPassageLog, Simulation -> simulation]
			},
			{
				True,
				{{
					_?DateObjectQ,
					ObjectP[Model[Cell]],
					ObjectP[Object[Sample, "Test cell sample 1 for ExperimentTransfer" <> $SessionUUID]],
					1,
					_
				}}
			},
			Variables :> {options, simulation},
			Messages :> {Warning::ConflictingSourceAndDestinationAsepticHandling}
		],
		Example[{Options, TransferEnvironment, "If transferring sterile samples that do not contain cells, perform in the Aseptic Transfer BSCs with corresponding aseptic transfer pipettes:"},
			options = ExperimentTransfer[
				Model[Sample,"RPMI-1640 Medium"],
				Model[Container, Plate, "Omni Tray Sterile Media Plate"],
				1 Milliliter,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			{resolvedTransferEnvironment, resolvedInstrument} = Lookup[options, {TransferEnvironment, Instrument}];
			{
				Lookup[options, SterileTechnique],
				Download[resolvedTransferEnvironment, {Object, CultureHandling}],
				Download[resolvedInstrument, {Object, CultureHandling, AsepticHandling}]
			},
			{
				True,
				{ObjectP[Model[Instrument, HandlingStation, BiosafetyCabinet]], Null},
				{ObjectP[Model[Instrument, Pipette]], Null, True}
			},
			Variables :> {options, resolvedTransferEnvironment, resolvedInstrument}
		],
		Example[{Options, WorkCell, "If transferring mammalian samples robotically, perform in the bioSTAR:"},
			protocol = ExperimentTransfer[
				Model[Sample, "HEK293"],
				Model[Container, Plate, "96-well flat bottom plate, Sterile, Nuclease-Free"],
				0.25 Milliliter,
				Preparation -> Robotic
			];
			resolvedWorkCell = Download[Download[protocol, OutputUnitOperations], WorkCell];
			{
				protocol,
				resolvedWorkCell
			},
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				{bioSTAR}
			},
			Variables :> {protocol, resolvedWorkCell}
		],
		Example[{Options, WorkCell, "If transferring bacterial samples robotically, perform in the microbioSTAR:"},
			protocol = ExperimentTransfer[
				Model[Sample, "E.coli MG1655"],
				Model[Container, Plate, "96-well flat bottom plate, Sterile, Nuclease-Free"],
				0.25 Milliliter,
				Preparation -> Robotic
			];
			resolvedWorkCell = Download[Download[protocol, OutputUnitOperations], WorkCell];
			{
				protocol,
				resolvedWorkCell
			},
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				{microbioSTAR}
			},
			Variables :> {protocol, resolvedWorkCell}
		],
		Example[{Options, WorkCell, "If SterileTechnique is set to true for robotic transfer, perform in the microbioSTAR or bioSTAR amd generate RCP:"},
			protocol = ExperimentTransfer[
				Model[Sample, "Milli-Q water"],
				Model[Container, Plate, "96-well flat bottom plate, Sterile, Nuclease-Free"],
				0.25 Milliliter,
				Preparation -> Robotic,
				SterileTechnique -> True
			];
			resolvedWorkCell = Download[Download[protocol, OutputUnitOperations], WorkCell];
			{
				protocol,
				resolvedWorkCell
			},
			{
				ObjectP[Object[Protocol, RoboticCellPreparation]],
				{microbioSTAR|bioSTAR}
			},
			Variables :> {protocol, resolvedWorkCell}
		],
		Example[{Options, WorkCell, "If SterileTechnique is not specified for robotic transfer but WorkCell is, sterile samples can STILL be transferred in STAR and RSP is generated:"},
			protocol = ExperimentTransfer[
				Model[Sample, "Milli-Q water"],
				Model[Container, Plate, "96-well flat bottom plate, Sterile, Nuclease-Free"],
				0.25 Milliliter,
				WorkCell -> STAR,
				Preparation -> Robotic
			];
			resolvedWorkCell = Download[Download[protocol, OutputUnitOperations], WorkCell];
			{
				protocol,
				resolvedWorkCell
			},
			{
				ObjectP[Object[Protocol, RoboticSamplePreparation]],
				{STAR}
			},
			Variables :> {protocol, resolvedWorkCell}
		],
		Example[{Messages, "ConflictingSterileTransferWithWorkCell", "An error is thrown if the sterile sample is transferred in STAR work cell and SterileTechnique is specified:"},
			ExperimentTransfer[
				Object[Sample, "Test sterile sample 1 in a 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Model[Container, Vessel, "50mL Tube"],
				0.95 Milliliter,
				SterileTechnique -> True,
				Preparation -> Robotic,
				WorkCell -> STAR
			],
			$Failed,
			Messages :> {
				Error::ConflictingSterileTransferWithWorkCell,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingSourceAndDestinationAsepticHandling", "A warning is thrown if the source sample is Sterile -> True but the destination is not sterile nor asepticHandling:"},
			ExperimentTransfer[
				Object[Sample, "Test sterile sample 1 in a 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Container, Vessel, "Test non-sterile 50mL Tube 1 for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter
			],
			ObjectP[Object[Protocol, ManualCellPreparation]],
			Messages :> {Warning::ConflictingSourceAndDestinationAsepticHandling}
		],
		Example[{Messages, "ConflictingSourceAndDestinationAsepticHandling", "A warning is thrown if the source sample is AsepticHandling -> True but the destination model is not sterile:"},
			ExperimentTransfer[
				Model[Sample, "SARS-CoV-2 RNA (MT007544.1)"],
				Model[Container, Plate, "96-well UV-Star Plate"],
				0.1 Milliliter,
				Preparation -> Manual
			],
			ObjectP[Object[Protocol, ManualCellPreparation]],
			Messages :> {Warning::ConflictingSourceAndDestinationAsepticHandling}
		],
		Example[{Messages, "ConflictingSourceAndDestinationAsepticHandling", "If transferring from a sterile sample to another sterile sample, then won't throw a message"},
			ExperimentTransfer[
				Object[Sample, "Test sterile sample 1 in a 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test sterile sample 2 in a 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter
			],
			ObjectP[Object[Protocol, ManualCellPreparation]]
		],
		Example[{Messages, "ConflictingSourceAndDestinationAsepticHandling", "If transferring from a sterile sample to a non-sterile but aseptichandling sample, then won't throw a message"},
			ExperimentTransfer[
				Object[Sample, "Test sterile sample 1 in a 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test non-sterile sample 2 in a 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter
			],
				ObjectP[Object[Protocol, ManualCellPreparation]]
		],
		Example[{Messages, "ConflictingSourceAndDestinationAsepticHandling", "If transferring from a sterile sample to a sterile model container, then won't throw a message"},
			ExperimentManualCellPreparation[{
				Transfer[
					Source -> Object[Sample, "Test sterile sample 1 in a 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Destination -> Model[Container, Vessel, "2mL Cryogenic Vial"],
					Amount -> 500 Microliter,
					DestinationContainerLabel -> "ExperimentTransfer DestionationContainerLabel" <> $SessionUUID,
					SterileTechnique -> True
				],
				Transfer[
					Source -> Object[Sample, "Test sterile sample 1 in a 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Destination -> "ExperimentTransfer DestionationContainerLabel" <> $SessionUUID,
					Amount -> 500 Microliter,
					SterileTechnique -> True
				]
			}],
			ObjectP[Object[Protocol, ManualCellPreparation]]
		],
		Example[{Options, KeepSourceCovered, "If SterileTechnique is set to True and Preparation is Robotic, KeepSourceCovered will automatically be set to True:"},
			options = ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				0.5 Milliliter,
				SterileTechnique -> True,
				Preparation -> Robotic,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, KeepSourceCovered],
			True,
			Variables :> {options}
		],
		Example[{Options, KeepDestinationCovered, "If SterileTechnique is set to True and Preparation is Robotic, KeepDestinationCovered will automatically be set to True:"},
			options = ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				0.5 Milliliter,
				SterileTechnique -> True,
				Preparation -> Robotic,
				OptionsResolverOnly -> True,
				Output -> Options
			];
			Lookup[options, KeepDestinationCovered],
			True,
			Variables :> {options}
		],
		Example[{Options, IntermediateDecant, "If SterileTechnique is set to True, then all intermediate decant containers must be Sterile -> True:"},
			prot = ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Model[Container, Vessel, "2mL Tube"],
				1 Milliliter,
				SterileTechnique -> True,
				IntermediateDecant -> True,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];
			batchedUnitOpRequiredResources = Download[prot, BatchedUnitOperations[[1]][RequiredResources]];
			intermediateContainerResource = FirstCase[batchedUnitOpRequiredResources, {res: ObjectP[Object[Resource, Sample]], IntermediateContainerLink, _, _} :> Download[res, Object]];
			Download[intermediateContainerResource, Sterile],
			True,
			Variables :> {prot, batchedUnitOpRequiredResources, intermediateContainerResource}
		],
		Example[{Options, Funnel, "If instrument is GraduatedCylinder, resolved Funnel is compatible with destination container and is FunnelType -> Wet:"},
			options = ExperimentTransfer[
				Model[Sample,"Milli-Q water"],
				Object[Sample,"Test water sample 2 in 100mL VolumetricFlask for ExperimentTransfer" <> $SessionUUID],
				60 Milliliter,
				Preparation->Manual,
				Output->Options
			];
			Download[Lookup[options,Funnel],FunnelType],
			Wet,
			Variables :> {options}
		],
		Example[{Options, Funnel, "If instrument is Null, resolved Funnel is compatible with destination container and FunnelType based on State of source:"},
			options = ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				All,
				Preparation->Manual,
				Output -> Options
			];
			Download[Lookup[options,Funnel],FunnelType],
			Wet,
			Variables :> {options}
		],
		Example[{Options, IntermediateDecantRecoup, "Always default to not recoup residual sample from IntermediateContainer and request a waste container:"},
			prot = ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Model[Container, Vessel, "2mL Tube"],
				1 Milliliter,
				SterileTechnique -> True,
				IntermediateDecant -> True,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];
			Download[prot, BatchedUnitOperations[[1]][{IntermediateDecantRecoup,WasteContainer}]],
			{{False},ObjectP[Model[Container,Vessel]]},
			Variables :> {prot}
		],
		Example[{Messages, RecoupContamination, "Throw an error if recouping back to a public sample:"},
			ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer"<>$SessionUUID],
				Model[Container, Vessel, "2mL Tube"],
				1 Milliliter,
				SterileTechnique -> True,
				IntermediateDecant -> True,
				IntermediateDecantRecoup -> True
			],
			$Failed,
			Messages :> {Error::RecoupContamination, Error::InvalidOption}
		],
		Example[{Messages, "RecoupContamination", "Throw an error if recouping back to a Model[Sample]:"},
			ExperimentManualSamplePreparation[
				{
					LabelSample[
						(* "Milli-Q water" *)
						Sample -> Model[Sample, "id:8qZ1VWNmdLBD"],
						Amount -> 10 Milliliter,
						(* "50mL Tube" *)
						Container -> Model[Container, Vessel, "id:bq9LA0dBGGR6"],
						Label -> "my model sample"
					],
					Transfer[
						(* "Milli-Q water" *)
						Source -> {"my model sample"},
						(* "50mL Tube" *)
						Destination -> {Model[Container, Vessel, "2mL Tube"]},
						Amount -> {1 Milliliter},
						IntermediateDecant -> True,
						IntermediateDecantRecoup -> True
					]
				}
			],
			$Failed,
			Messages :> {Error::RecoupContamination, Error::InvalidInput}
		],
		Test["Always try to resolve to an intermediate container with graduation lines:",
			prot = ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer"<>$SessionUUID],
				Model[Container, Vessel, "2mL Tube"],
				1 Milliliter,
				SterileTechnique -> True,
				IntermediateDecant -> True,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer"<>$SessionUUID]
			];
			Download[prot, {BatchedUnitOperations[[1]][IntermediateContainerLink][[1]][Graduations], BatchedUnitOperations[[1]][IntermediateContainerImage]}],
			{{VolumeP..}, LinkP[Object[EmeraldCloudFile]]},
			Variables :> {prot}
		],
		Test["Set Tips to one that can aspirate from the intermediate container:",
			Lookup[
				ExperimentTransfer[
					{
						Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer"<>$SessionUUID],
						Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer"<>$SessionUUID]
					},
					{
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"]
					},
					{
						200 Microliter,
						1 Milliliter
					},
					IntermediateDecant -> True,
					IntermediateContainer -> {
						Model[Container, Vessel, "New 0.5mL Tube with 2mL Tube Skirt"],
						Model[Container, Vessel, "2mL Tube"]
					},
					Output -> Options
				],
				Tips
			],
			(* Model[Item, Tips, "200 uL tips, non-sterile"], Model[Item, Tips, "1000 uL reach tips, non-sterile"] *)
			{ObjectP[Model[Item, Tips, "id:O81aEBZDpVzN"]], ObjectP[Model[Item, Tips, "id:eGakldJR8D9e"]]}
		],
		Test["Source samples that are marked as Slurry have the SlurryTransfer option resolve to True:",
			ExperimentTransfer[
				{
					Object[Sample, "Test slurry sample 8 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					{1, Model[Container, Vessel,"50mL Tube"]}
				},
				{
					100 Microliter
				},
				Output->Options
			],
			KeyValuePattern[{SlurryTransfer->ListableP[True], MaxNumberOfAspirationMixes->ListableP[_Integer]}]
		],
		Test["Populate PipetteDialImage, AspirationMixPipetteDialImage, DispenseMixPipetteDialImage properly in the batched unit operations:",
			Download[
				ExperimentTransfer[
					Model[Sample, "Milli-Q water"],
					Model[Container, Vessel, "2mL Tube"],
					{1 Milliliter, 0.8 Milliliter},
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer"<>$SessionUUID],
					AspirationMix -> {True, False},
					AspirationMixType -> {Pipette, Automatic},
					AspirationMixVolume -> {0.5 Milliliter, Automatic},
					DispenseMixType -> {Swirl, Pipette},
					DispenseMixVolume -> {Automatic, 0.5 Milliliter}
				],
				BatchedUnitOperations[{PipetteDialImage, AspirationMixPipetteDialImage, DispenseMixPipetteDialImage}]
			],
			{
				{LinkP[Object[EmeraldCloudFile]], LinkP[Object[EmeraldCloudFile]], Null},
				{LinkP[Object[EmeraldCloudFile]], Null, LinkP[Object[EmeraldCloudFile]]}
			}
		],
		Test["Correctly resolves AspirationMixVolume if AspirationMix->True and AspirationMixType->Pipette:",
			ExperimentTransfer[
				{
					Object[Sample, "Test slurry sample 8 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					{1, Model[Container, Vessel,"50mL Tube"]}
				},
				{
					100 Microliter
				},
				AspirationMix->True,
				AspirationMixType->Pipette,
				Output->Options
			],
			KeyValuePattern[{AspirationMixVolume->VolumeP}]
		],
		Test["Correctly resolves DispenseMixVolume if DispenseMix->True and DispenseMixType->Pipette:",
			ExperimentTransfer[
				{
					Object[Sample, "Test slurry sample 8 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					{1, Model[Container, Vessel,"50mL Tube"]}
				},
				{
					100 Microliter
				},
				DispenseMix->True,
				DispenseMixType->Pipette,
				Output->Options
			],
			KeyValuePattern[{DispenseMixVolume->EqualP[50 Microliter]}]
		],
		Test["Correctly resolves DispenseMixVolume if DispenseMix->True and DispenseMixType->Pipette based on the total volume of original sample and transferIn volume:",
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					10 Milliliter
				},
				DispenseMix->True,
				DispenseMixType->Pipette,
				Output->Options
			],
			KeyValuePattern[{DispenseMixVolume->EqualP[10 Milliliter]}]
		],
		Test["Test gravimetric transfer of liquids with small volumes:",
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					{1, Model[Container, Vessel,"50mL Tube"]},
					{1, Model[Container, Vessel,"50mL Tube"]}
				},
				{
					1 Milligram,
					1 Milligram,
					1 Milliliter
				}
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]],
			Messages :> {Message[Warning::QuantitativeTransferRecommended]}
		],
		Test["Test gravimetric transfer of liquids with larger volumes:",
			ExperimentTransfer[
				Model[Sample, StockSolution, "1x PBS with BSA"],
				Model[Container, Vessel, "150 mL Glass Bottle"],
				100 Gram
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Test["Transferring from a sample into the same sample doesn't result in an OverfilledTransfer error (we use this for mixing via pipette):",
			ExperimentTransfer[
				{
					Model[Sample, "Milli-Q water"],
					{1, Model[Container, Vessel, "50mL Tube"]},
					{1, Model[Container, Vessel, "50mL Tube"]}
				},
				{
					{1, Model[Container, Vessel, "50mL Tube"]},
					{1, Model[Container, Vessel, "50mL Tube"]},
					{1, Model[Container, Vessel, "50mL Tube"]}
				},
				{
					50 Milliliter,
					50 Milliliter,
					50 Milliliter
				},
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				_List
			}
		],
		Test["Make a robotic sample preparation protocol that uses a collection container:",
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					{"A1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]}
				},
				{
					500 Microliter
				},
				CollectionContainer -> Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID],
				CollectionTime -> 1 Minute
			],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Test["Advanced collection container test where the sample from the collection container is used as a source:",
			ExperimentRoboticSamplePreparation[{
				Transfer[
					Source -> {
						Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
						Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
						Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
						{"C1", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]}
					},
					Destination -> {
						{"A1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]},
						{"B1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]},
						{"C1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]},
						{"D1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]}
					},
					CollectionContainer -> {
						Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID],
						Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID],
						Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID],
						Null
					},
					Amount -> {0.5 Milliliter,0.5 Milliliter, 0.5 Milliliter, 0.25 Milliliter}
				]
			}],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Test["A MultiProbeHead transfer is grouped separately from subsequent non-MultiProbeHead transfers:",
			Download[
				ExperimentRoboticSamplePreparation[{
					Transfer[
						Source -> Object[Sample, "Test water sample in a reservoir for ExperimentTransfer" <> $SessionUUID],
						Destination -> Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID],
						Amount -> 200*Microliter,
						DeviceChannel -> MultiProbeHead
					],
					Transfer[
						Source -> {
							Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
							Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
							Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
						},
						Destination -> {
							{"A1", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
							{"B1", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
							{"C1", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]}
						},
						Amount -> {0.5 Milliliter,0.5 Milliliter, 0.5 Milliliter}
					]
				}],
				OutputUnitOperations[[1]][MultichannelTransferName]
			],
			(* First 1 is in a group on its own *)
			{
				a_String,
				(* Next 3 are in their own group *)
				b_String,
				b_String,
				b_String
			}
		],
		Test["A new transfer group is created when using a new collection container is used:",
			Download[
				ExperimentTransfer[
					ConstantArray[Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], 14],
					ConstantArray[{"A1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]}, 14],
					ConstantArray[50 Microliter, 14],
					CollectionContainer -> {
						Sequence@@ConstantArray[Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID], 12],
						Sequence@@ConstantArray[Object[Container, Plate, "Test 96-DWP 3 for ExperimentTransfer" <> $SessionUUID], 2]
					},
					CollectionTime -> 1 Minute
				],
				OutputUnitOperations[[1]][MultichannelTransferName]
			],
			{
				(* First 8 are in a group. *)
				a_String,
				a_String,
				a_String,
				a_String,
				a_String,
				a_String,
				a_String,
				a_String,
				(* Next 4 are in a group (8+4=12). *)
				b_String,
				b_String,
				b_String,
				b_String,
				(* Next 2 are in a group because the collection container changed. *)
				c_String,
				c_String
			}
		],
		Test["A new transfer group is created when using a new destination container on top of the collection container:",
			Download[
				ExperimentTransfer[
					ConstantArray[Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], 14],
					{
						Sequence@@ConstantArray[{"A1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]}, 12],
						Sequence@@ConstantArray[{"A1", Object[Container, Plate, "Test 96-DWP 3 for ExperimentTransfer" <> $SessionUUID]}, 2]
					},
					ConstantArray[50 Microliter, 14],
					CollectionContainer -> Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID],
					CollectionTime -> 1 Minute
				],
				OutputUnitOperations[[1]][MultichannelTransferName]
			],
			{
				(* First 8 are in a group. *)
				a_String,
				a_String,
				a_String,
				a_String,
				a_String,
				a_String,
				a_String,
				a_String,
				(* Next 4 are in a group (8+4=12). *)
				b_String,
				b_String,
				b_String,
				b_String,
				(* Next 2 are in a group because the destination container changed. *)
				c_String,
				c_String
			}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentTransfer[
				Object[Sample, "Nonexistent sample"],
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentTransfer[
				Object[Container, Vessel, "Nonexistent container"],
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentTransfer[
				Object[Sample, "id:123456"],
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentTransfer[
				Object[Container, Vessel, "id:123456"],
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated sample but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container, Vessel, "50mL Tube"],
					{"Work Surface", Object[Container, Bench, "Test bench for ExperimentTransfer tests" <> $SessionUUID]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					InitialAmount -> 25 Milliliter,
					Simulation -> simulationToPassIn
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentTransfer[
					sampleID,
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					1 Milliliter,
					Simulation -> simulationToPassIn,
					Output -> Options
				]
			],
			{__Rule}
		],
		Example[{Messages, "ObjectDoesNotExist", "Do NOT throw a message if we have a simulated container but a simulation is specified that indicates that it is simulated:"},
			Module[{containerPackets, containerID, sampleID, samplePackets, simulationToPassIn},
				containerPackets = UploadSample[
					Model[Container, Vessel, "50mL Tube"],
					{"Work Surface", Object[Container, Bench, "Test bench for ExperimentTransfer tests" <> $SessionUUID]},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True
				];
				simulationToPassIn = Simulation[containerPackets];
				containerID = Lookup[First[containerPackets], Object];
				samplePackets = UploadSample[
					Model[Sample, "Milli-Q water"],
					{"A1", containerID},
					Upload -> False,
					SimulationMode -> True,
					FastTrack -> True,
					InitialAmount -> 25 Milliliter,
					Simulation -> simulationToPassIn
				];
				sampleID = Lookup[First[samplePackets], Object];
				simulationToPassIn = UpdateSimulation[simulationToPassIn, Simulation[samplePackets]];

				ExperimentTransfer[
					containerID,
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					1 Milliliter,
					Simulation -> simulationToPassIn,
					Output -> Options
				]
			],
			{__Rule}
		],
		Example[{Messages, "InputContainsTemporalLinks", "Throw a message if given a temporal link:"},
			ExperimentTransfer[
				{
					Link[Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], Now - 1 Minute],
					Link[Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], Now - 1 Minute],
					Link[Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], Now - 1 Minute]
				},
				{
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					{1, Model[Container, Vessel,"50mL Tube"]},
					{1, Model[Container, Vessel,"50mL Tube"]}
				},
				{
					1 Gram,
					1 Gram,
					1 Milliliter
				},
				Output -> Options
			],
			{__Rule},
			Messages :> {Warning::InputContainsTemporalLinks}
		],
		Example[{Messages, "MagnetizationOptionsMismatch", "If the magnetization options are conflicting with one another, an error is thrown:"},
			ExperimentTransfer[
				Object[Sample, "Test powder sample 6 (SampleHandling->Null) in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID],
				1 Gram,
				Magnetization->True,
				MagnetizationTime->Null
			],
			$Failed,
			Messages :> {
				Error::MagnetizationOptionsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CollectionContainerOptionsMismatch", "If the collection container options are conflicting with one another, an error is thrown:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					{"A1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]}
				},
				{
					500 Microliter
				},
				CollectionContainer -> Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID],
				CollectionTime -> Null
			],
			$Failed,
			Messages :> {
				Error::CollectionContainerOptionsMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CollectionContainerFootprintMismatch", "If the collection container's Footprint does not match the destination container's Footprint, an error is thrown:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					50 Microliter
				},
				CollectionContainer -> Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID],
				CollectionTime -> 1 Minute
			],
			$Failed,
			Messages :> {
				Error::CollectionContainerFootprintMismatch,
				Error::InvalidOption
			}
		],
		Example[{Messages, "CoverContainerConflict", "Detects issues with covers, if the SourceCover or DestinationCover options are specified:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					100 Microliter
				},
				ReplaceDestinationCover -> True,
				DestinationCover -> Model[Item, PlateSeal, "qPCR Plate Seal, Clear"]
			],
			$Failed,
			Messages :> {
				Error::CoverContainerConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TransferEnvironmentBalanceCombination","Gravimetric transfers in a BSC should only use scales in that BSC model:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					{1, Model[Container, Vessel,"50mL Tube"]},
					{1, Model[Container, Vessel,"50mL Tube"]}
				},
				{
					1 Gram,
					1 Gram,
					1 Milliliter
				},
				Balance->{Model[Instrument, Balance, "id:rea9jl5Vl1ae"], Model[Instrument, Balance, "id:rea9jl5Vl1ae"], Null},
				TransferEnvironment->Model[Instrument, HandlingStation, BiosafetyCabinet, "id:AEqRl9xveX7p"]
			],
			$Failed,
			Messages:>{
				Error::TransferEnvironmentBalanceCombination,
				Error::InvalidTransferEnvironment,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TransferEnvironmentBalanceCombination","Gravimetric transfers in a fume hood must happen in a hood that actually has a balance on it:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					{1, Model[Container, Vessel,"50mL Tube"]},
					{1, Model[Container, Vessel,"50mL Tube"]}
				},
				{
					1 Gram,
					1 Gram,
					1 Milliliter
				},
				TransferEnvironment->Model[Instrument, HandlingStation, FumeHood, "Fume Hood Handling Station with Schlenk Line"]
			],
			$Failed,
			Messages:>{
				Error::TransferEnvironmentBalanceCombination,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TransferEnvironmentBalanceCombination","checks things correctly when balance is specified as model, handling station specified as object"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					{1, Model[Container, Vessel,"50mL Tube"]},
					{1, Model[Container, Vessel,"50mL Tube"]}
				},
				{
					1 Gram,
					1 Gram,
					1 Milliliter
				},
				Balance->{Model[Instrument, Balance, "id:rea9jl5Vl1ae"], Model[Instrument, Balance, "id:rea9jl5Vl1ae"], Null},
				TransferEnvironment->Object[Instrument, HandlingStation, BiosafetyCabinet, "id:E8zoYvO70Vx5"]
			],
			$Failed,
			Messages:>{
				Error::TransferEnvironmentBalanceCombination,
				Error::InvalidTransferEnvironment,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TransferEnvironmentBalanceCombination","checks things correctly when balance is specified as object, handling station specified as model"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					{1, Model[Container, Vessel,"50mL Tube"]},
					{1, Model[Container, Vessel,"50mL Tube"]}
				},
				{
					1 Gram,
					1 Gram,
					1 Milliliter
				},
				Balance->{Object[Instrument, Balance, "id:n0k9mGzRaDb3"], Object[Instrument, Balance, "id:n0k9mGzRaDb3"], Null},
				TransferEnvironment->Model[Instrument, HandlingStation, BiosafetyCabinet, "id:AEqRl9xveX7p"]
			],
			$Failed,
			Messages:>{
				Error::TransferEnvironmentBalanceCombination,
				Error::InvalidTransferEnvironment,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TransferEnvironmentInstrumentCombination", "Manual transfers in a microbial BSC should only use microbial pipette model:"},
			ExperimentTransfer[
				{Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]},
				{Model[Container, Vessel, "50mL Tube"]},
				{1 Milliliter},
				Instrument -> Model[Instrument, Pipette, "Eppendorf Research Plus P1000, Tissue Culture"],
				TransferEnvironment -> Model[Instrument, HandlingStation, BiosafetyCabinet, "Biosafety Cabinet Handling Station for Microbiology"]
			],
			$Failed,
			Messages :> {
				Error::TransferEnvironmentInstrumentCombination,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TransferEnvironmentInstrumentCombination", "Manual transfers in a tissue culture BSC should only use tissue culture pipette model:"},
			ExperimentTransfer[
				{Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]},
				{Model[Container, Vessel, "50mL Tube"]},
				{1 Milliliter},
				Instrument -> Model[Instrument, Pipette, "Eppendorf Research Plus P1000, Microbial"],
				TransferEnvironment -> Model[Instrument, HandlingStation, BiosafetyCabinet, "Biosafety Cabinet Handling Station for Tissue Culture"]
			],
			$Failed,
			Messages :> {
				Error::TransferEnvironmentInstrumentCombination,
				Error::InvalidOption
			}
		],
		Example[{Messages, "TransferEnvironmentInstrumentCombination", "Manual transfers in an aseptic transfer BSC should only use aseptic transfer pipette model:"},
			ExperimentTransfer[
				{Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]},
				{Model[Container, Vessel, "50mL Tube"]},
				{1 Milliliter},
				Instrument -> Model[Instrument, Pipette, "Eppendorf Research Plus P1000"],
				TransferEnvironment -> Model[Instrument, HandlingStation, BiosafetyCabinet, "Biosafety Cabinet Handling Station with Analytical Balance"]
			],
			$Failed,
			Messages :> {
				Error::TransferEnvironmentInstrumentCombination,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NoTransferEnvironmentAvailable", "Throw an error if no transfer environment can be found for a given sample in:"},
			ExperimentTransfer[
				{Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID]},
				{Model[Container, Vessel, "50mL Tube"]},
				{1 Milliliter},
				SterileTechnique -> True
			],
			$Failed,
			Messages :> {
				Error::SterileTransfersAreInBSC,
				Error::NoTransferEnvironmentAvailable,
				Error::InvalidOption
			}
		],
		Example[{Messages, "NoTransferEnvironmentAvailable", "Throw an error if user specifies a transfer environment that cannot fulfill the specific transfer requirement:"},
			ExperimentTransfer[
				{Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID]},
				{Model[Container, Vessel, "50mL Tube"]},
				{1 Milliliter},
				TransferEnvironment -> Model[Instrument, HandlingStation, BiosafetyCabinet, "Biosafety Cabinet Handling Station with Analytical Balance"]
			],
			$Failed,
			Messages :> {
				Error::InvalidTransferEnvironment,
				Error::InvalidOption
			}
		],
		Test["Using a pipette that should already be in the BSC will result in us requesting not to pick it up front:",
			Module[{protocol},
				protocol=ExperimentTransfer[
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					100 Microliter,
					Instrument -> Model[Instrument, Pipette, "Eppendorf Research Plus P200, Aseptic Transfer"],
					TransferEnvironment -> Model[Instrument, HandlingStation, BiosafetyCabinet, "Biosafety Cabinet Handling Station with Analytical Balance"],
					ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
				];

				Download[
					protocol,
					{
						BatchedUnitOperations[InstrumentLink][CultureHandling],
						RequiredInstruments
					}
				]
			],
			{
				(* null because it's a Transfer bench *)
				{{Null}},
				{Except[ObjectP[Model[Instrument, Pipette]]]..}|{}
			}
		],
		Test["Transfers from a Model[Sample] that comes in a hermetic container will resolve knowing that the source will be in a hermetic container:",
			Module[{options},
				(* Use the Wyatt scratch notebook so we don't use public samples when searching for already fulfillable source samples. *)
				options=ExperimentTransfer[
					{
						Model[Sample,"Tetrahydrofuran, Anhydrous"]
					},
					{
						Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
					},
					{
						1 Milliliter
					},
					ImageSample->False,
					MeasureWeight->False,
					MeasureVolume->False,
					Output->Options
				];

				Lookup[options, BackfillNeedle]
			],
			ObjectP[Model[Item, Needle]]
		],
		Test["Recursive transfer from a water purifier:",
			ExperimentTransfer[
				{
					Model[Sample,"Milli-Q water"],
					{1, Model[Container,Vessel,"id:zGj91aR3ddXJ"]}
				},
				{
					{1, Model[Container,Vessel,"id:zGj91aR3ddXJ"]},
					{2, Model[Container,Vessel,"id:zGj91aR3ddXJ"]}
				},
				{
					20 Milliliter,
					1.5 Milliliter
				}
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Test["Setting InSitu -> True ensures that the source and destinations are not moved from where they already are:",
			protocol = ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter,
				TransferEnvironment -> Object[Instrument, HandlingStation, Ambient, "Test handling station for ExperimentTransfer tests"<>$SessionUUID],
				InSitu -> True,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];
			Download[protocol, RequiredObjects],
			{ObjectP[Model[Item, Tips]]},
			Variables :> {protocol}
		],
		Test["Setting InSitu -> True gets stored in the unit operation objects even though it's a hidden option:",
			protocol = ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter,
				TransferEnvironment -> Object[Instrument, HandlingStation, Ambient, "Test handling station for ExperimentTransfer tests"<>$SessionUUID],
				InSitu -> True
			];
			Lookup[Download[protocol, ResolvedUnitOperationOptions[[1]]], InSitu],
			True,
			Variables :> {protocol}
		],
		Test["Passing the HandlingCondition and EquivalentTransferEnvironments back to MSP so we can resolve things faster in Engine:",
			Module[{protocol},
				protocol = ExperimentTransfer[
					{Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]},
					{{1, Model[Container, Vessel, "id:zGj91aR3ddXJ"]}, {1, Model[Container, Vessel, "id:zGj91aR3ddXJ"]}},
					1 Milliliter
				];
				Lookup[Download[protocol, ResolvedUnitOperationOptions[[1]]], {HandlingCondition, EquivalentTransferEnvironments}]
			],
			{
				{ObjectP[Model[HandlingCondition]]..}?(Length[#] > 1&),
				{ObjectP[Model[Instrument, HandlingStation, Ambient]]..}?(Length[#] > 1&)
			}
		],
		Test["Do not resolve to use a handling station with micro balance, if we do not have to use a micro balance:",
			Module[{protocol},
				protocol = ExperimentTransfer[
					{Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]},
					{{1, Model[Container, Vessel, "id:zGj91aR3ddXJ"]}, {1, Model[Container, Vessel, "id:zGj91aR3ddXJ"]}},
					1 Milliliter
				];
				Flatten[Download[Lookup[Download[protocol, ResolvedUnitOperationOptions[[1]]], HandlingCondition], BalanceType]]
			],
			_?(!MemberQ[#, Micro]&)
		],
		Test["Allows multiple transfer environment models to be selected in TransferEnvironment resources:",
			Module[{protocol, resources},
				protocol = ExperimentTransfer[
					{Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]},
					{{1, Model[Container, Vessel, "id:zGj91aR3ddXJ"]}, {1, Model[Container, Vessel, "id:zGj91aR3ddXJ"]}},
					1 Milliliter,
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
				];
				resources = Cases[Download[protocol, RequiredResources], {obj_, TransferEnvironments, ___} :> Download[obj, Object]];
				{
					SameObjectQ @@ resources,
					Download[resources[[1]], InstrumentModels]
				}
			],
			{
				True,
				{ObjectP[Model[Instrument, HandlingStation, Ambient]]..}?(Length[#] > 1&)
			}
		],
		Test["Once generated a MSP, the resolved options can be feed back to ExperimentTransfer with no errors:",
			Module[{protocol, input, options, transferSub, resources},
				protocol = ExperimentTransfer[
					{Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID]},
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					1 Milliliter
				];
				{input, options} = Download[protocol, {ResolvedUnitOperationInputs[[1]], ResolvedUnitOperationOptions[[1]]}];
				transferSub = ExperimentTransfer[
					input,
					Sequence @@ ReplaceRule[
						options,
						{ParentProtocol -> protocol}
					]
				];
				resources = Cases[Download[transferSub, RequiredResources], {obj_, TransferEnvironments, ___} :> Download[obj, Object]];
				Download[resources, InstrumentModels]
			],
			{
				{ObjectP[Model[Instrument, HandlingStation, Ambient]]..}?(Length[#] > 1&),
				{ObjectP[Model[Instrument, HandlingStation, FumeHood]]..}?(Length[#] > 1&)
			}
		],
		Test["Basic transfer simulation with some labels:",
			ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				All,
				SourceLabel -> "best sample ever",
				SourceContainerLabel -> "best container ever",
				DestinationLabel -> "best destination ever",
				DestinationContainerLabel -> "best destination container ever",
				Output -> {Simulation, Options}
			],
			{
				SimulationP,
				_List
			}
		],
		Test["Waste transfer simulation with some labels:",
			ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Waste,
				All,
				SourceLabel -> "best sample ever",
				SourceContainerLabel -> "best container ever",
				Output -> {Simulation, Options}
			],
			{
				SimulationP,
				_List
			}
		],
		Test["Model[Sample] and Model[Container] transfer simulation with some labels:",
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Model[Sample, "Methanol"],
					Model[Sample, "Methanol"],
					{1, Model[Container, Vessel, "50mL Tube"]}
				},
				{
					{"A1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]},
					Model[Container, Vessel, "50mL Tube"],
					{1, Model[Container, Vessel, "50mL Tube"]},
					{"A2", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]}
				},
				{
					1 Milliliter,
					10 Milliliter,
					1 Milliliter,
					100 Microliter
				},
				SourceLabel -> {
					"best sample ever",
					"best sample ever 2",
					"best sample ever 3",
					"best sample ever 4"
				},
				SourceContainerLabel -> {
					"best container ever",
					"best container ever 2",
					"best container ever 3",
					"best container ever 4"
				},
				DestinationLabel -> {
					"best destination ever",
					"best destination ever 2",
					"best destination ever 3",
					"best destination ever 4"
				},
				DestinationContainerLabel -> {
					"best destination container ever",
					"best destination container ever 2",
					"best destination container ever 3",
					"best destination container ever 4"
				},
				Output -> {Simulation, Options}
			],
			{
				SimulationP,
				_List
			}
		],
		Example[{Options,SamplesInStorageCondition,"Indicates how the input samples of the experiment should be stored:"},
			Lookup[
				ExperimentTransfer[
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					1 Milliliter,
					SamplesInStorageCondition->Refrigerator,
					Output -> Options
				],
				SamplesInStorageCondition
			],
			Refrigerator
		],
		Example[{Options,SamplesInStorageCondition,"Use SamplesInStorageCondition option to indicate how the intermediate samples of the experiment should be stored:"},
			protocol=ExperimentRoboticSamplePreparation[
				{
					Transfer[
						Source->Model[Sample, "Milli-Q water"],
						Destination->Model[Container, Vessel, "2mL Tube"],
						Amount->1 Milliliter,
						DestinationLabel->"my water sample"
					],
					Transfer[
						Source->"my water sample",
						Destination->Model[Container, Vessel, "50mL Tube"],
						Amount->500Microliter,
						SamplesInStorageCondition->Refrigerator
					]
				}
			];
			Download[protocol,OutputUnitOperations[[-1]][SamplesInStorageCondition]],
			{Refrigerator},
			Variables :> {protocol}
		],
		Example[{Options, {SourceTemperature,DestinationTemperature},"SourceTemperature and DestinationTemperature can be specified as Cold and translated into Celsius in the protocol for Preparation -> Manual:"},
			protocol=ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter,
				SourceTemperature -> Cold,
				DestinationTemperature -> Cold,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];
			Download[protocol,
				{
					SourceTemperatures,
					DestinationTemperatures,
					BatchedUnitOperations[[1]][SourceTemperatureReal],
					BatchedUnitOperations[[1]][DestinationTemperatureReal]
				}
			],
			{
				{EqualP[4 Celsius]},
				{EqualP[4 Celsius]},
				{EqualP[4 Celsius]},
				{EqualP[4 Celsius]}
			},
			Variables :> {protocol}
		],
		Example[{Options, {SourceTemperature,DestinationTemperature},"SourceTemperature and DestinationTemperature can be specified as Cold for Transfer primitive in MSP, and eventually translated into Celsius in Transfer Subprotocol:"},
			protocol=ExperimentManualSamplePreparation[
				Transfer[
					Source -> Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Destination -> Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Amount -> 1 Milliliter,
					SourceTemperature -> Cold,
					DestinationTemperature -> Cold
				]
			];
			{resolvedInputs, resolvedOptions} = Download[
				protocol,
				{
					ResolvedUnitOperationInputs[[1]],
					ResolvedUnitOperationOptions[[1]]
				}];
			transferSub = ExperimentTransfer[
				Sequence @@ resolvedInputs,
				Sequence @@ Join[resolvedOptions, {ParentProtocol -> protocol}]
			];
			Download[
				protocol,
				{
					OutputUnitOperations[[1]][SourceTemperatureReal],
					OutputUnitOperations[[1]][SourceTemperatureExpression],
					OutputUnitOperations[[1]][DestinationTemperatureReal],
					OutputUnitOperations[[1]][DestinationTemperatureExpression],
					Subprotocols[[1]][SourceTemperatures],
					Subprotocols[[1]][DestinationTemperatures],
					Subprotocols[[1]][BatchedUnitOperations][[1]][SourceTemperatureReal],
					Subprotocols[[1]][BatchedUnitOperations][[1]][DestinationTemperatureReal]
				}
			],
			{
				{Null},
				{Cold},
				{Null},
				{Cold},
				{EqualP[4 Celsius]},
				{EqualP[4 Celsius]},
				{EqualP[4 Celsius]},
				{EqualP[4 Celsius]}
			},
			Variables :> {protocol, resolvedInputs, resolvedOptions}
		],
		Example[{Options, {SourceTemperature,DestinationTemperature},"SourceTemperature and DestinationTemperature can be specified as Cold and translated into Celsius in the unit operation for Preparation -> Robotic:"},
			protocol=ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				0.5 Milliliter,
				SourceTemperature -> Cold,
				DestinationTemperature -> Cold,
				Preparation -> Robotic
			];
			Download[protocol,
				{
					OutputUnitOperations[[-1]][SourceTemperatureReal],
					OutputUnitOperations[[-1]][DestinationTemperatureReal]
				}
			],
			{{EqualP[4 Celsius]},{EqualP[4 Celsius]}},
			Variables :> {protocol}
		],
		Example[{Messages,"InvalidTransferSourceStorageCondition", "Error is thrown if SamplesInStorageCondition is set for a Model[Sample] source:"},
			ExperimentTransfer[
				Model[Sample, "Milli-Q water"],
				Model[Container, Vessel, "50mL Tube"],
				{100 Microliter},
				SamplesInStorageCondition->Refrigerator
			],
			$Failed,
			Messages:>{
				Error::InvalidTransferSourceStorageCondition,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InvalidTransferNonDisposalSourceStorageCondition", "Error is thrown if SamplesInStorageCondition is not set to Disposal if the source container is an ampoule:"},
			ExperimentTransfer[
				Object[Sample, "Test sterile sample in a 2mL amber glass ampoule for ExperimentTransfer" <> $SessionUUID],
				Model[Container, Vessel, "50mL Tube"],
				All,
				SamplesInStorageCondition->Null
			],
			$Failed,
			Messages:>{
				Error::InvalidTransferNonDisposalSourceStorageCondition,
				Error::InvalidOption
			}
		],
		Test["InvalidTransferNonDisposalSourceStorageCondition is not thrown from Engine, SamplesInStorageCondition is automatically set to Disposal instead:",
			Download[ExperimentTransfer[
				Object[Sample, "Test sterile sample in a 2mL amber glass ampoule for ExperimentTransfer" <> $SessionUUID],
				Model[Container, Vessel, "50mL Tube"],
				All,
				SamplesInStorageCondition->Null
			], OutputUnitOperations[SamplesInStorageCondition]],
			{{Disposal}},
			Stubs :> {$ECLApplication = Engine}
		],
		Example[{Messages,"InvalidTransferNonDisposalSourceStorageCondition", "Error is thrown if SamplesInStorageCondition is not set to Disposal if the source container is crimp-sealed, and it is getting unsealed in a biosafety cabinet:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 4 in Hermetic Container for ExperimentTransfer" <> $SessionUUID]
				},
				{Model[Container, Vessel, "50mL Tube"],Model[Container, Vessel, "50mL Tube"]},
				{1 Milliliter,1 Milliliter},
				UnsealHermeticSource -> True,
				TransferEnvironment -> Model[Instrument, HandlingStation, BiosafetyCabinet, "Biosafety Cabinet Handling Station with Analytical Balance"],
				SamplesInStorageCondition->Freezer
			],
			$Failed,
			Messages:>{
				Error::InvalidTransferNonDisposalSourceStorageCondition,
				Error::InvalidOption
			}
		],
		Example[{Basic,"Basic transfer with liquid samples in 50mL Tubes with specified amounts:"},
			ExperimentTransfer[
				{Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]},
				{Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]},
				{500 Microliter, 2 Milliliter},
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					Instrument -> ListableP[ObjectP[Model[Instrument, Pipette]]],
					Balance -> Null,
					Tips -> ListableP[ObjectP[Model[Item, Tips]]],
					TipType -> ListableP[TipTypeP],
					TipMaterial -> ListableP[MaterialP],
					ReversePipetting -> False,
					Needle -> Null,
					WeighingContainer -> Null,
					Tolerance -> Null,
					HandPump -> Null,
					QuantitativeTransfer -> False,
					QuantitativeTransferWashSolution -> Null,
					QuantitativeTransferWashVolume -> Null,
					QuantitativeTransferWashInstrument -> Null,
					QuantitativeTransferWashTips -> Null,
					NumberOfQuantitativeTransferWashes -> Null,

					UnsealHermeticSource -> Null,
					UnsealHermeticDestination -> Null,
					BackfillNeedle -> Null,
					BackfillGas -> Null,
					VentingNeedle -> Null,

					TipRinse -> False,
					TipRinseSolution -> Null,
					TipRinseVolume -> Null,
					NumberOfTipRinses -> Null,

					IntermediateDecant -> False,
					IntermediateContainer -> Null
				}]
			}
		],
		Example[{Basic,"Transferring into a crimped container using a pipette should result in pipette usage and the destination container to be unsealed and replaced with a new cover:"},
			ExperimentTransfer[
				{
					Model[Sample,"Milli-Q water"]
				},
				{
					Model[Container,Vessel,"2 mL clear glass vial, sterile with septum and aluminum crimp top"]
				},
				{
					150 Microliter
				},
				SterileTechnique->True,
				TransferEnvironment->Model[Instrument, HandlingStation, BiosafetyCabinet, "Biosafety Cabinet Handling Station for Tissue Culture"],
				Instrument->Model[Instrument,Pipette,"Eppendorf Research Plus P200, Tissue Culture"],
				Output-> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualCellPreparation]],
				KeyValuePattern[{
					Instrument -> ListableP[ObjectP[Model[Instrument, Pipette]]],
					Tips -> ListableP[ObjectP[Model[Item, Tips]]],
					TipType -> ListableP[TipTypeP],
					TipMaterial -> ListableP[MaterialP],
					Needle -> Null,
					WeighingContainer -> Null,
					Tolerance -> Null,
					HandPump -> Null,
					QuantitativeTransfer -> False,
					QuantitativeTransferWashSolution -> Null,
					QuantitativeTransferWashVolume -> Null,
					QuantitativeTransferWashInstrument -> Null,
					QuantitativeTransferWashTips -> Null,
					NumberOfQuantitativeTransferWashes -> Null,

					UnsealHermeticSource -> Null,
					UnsealHermeticDestination -> True,

					ReplaceDestinationCover -> True,
					DestinationCover -> ObjectP[Model[Item, Cap]],
					DestinationSeptum -> Null,
					DestinationStopper -> Null
				}]
			}
		],
		Example[{Basic,"Hermetic transfer with liquid samples in between two hermetic containers:"},
			ExperimentTransfer[
				Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 4 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
				500 Microliter,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					Instrument -> ObjectP[Model[Container, Syringe]],
					Balance -> Null,
					Tips -> Null,
					TipType -> Null,
					TipMaterial -> Null,
					ReversePipetting -> Null,
					Needle -> ObjectP[Model[Item, Needle]],
					WeighingContainer -> Null,
					Tolerance -> Null,
					HandPump -> Null,
					QuantitativeTransfer -> False,
					QuantitativeTransferWashSolution -> Null,
					QuantitativeTransferWashVolume -> Null,
					QuantitativeTransferWashInstrument -> Null,
					QuantitativeTransferWashTips -> Null,
					NumberOfQuantitativeTransferWashes -> Null,
					UnsealHermeticSource -> False,
					UnsealHermeticDestination -> False,
					BackfillNeedle -> ObjectP[Model[Item, Needle]],
					BackfillGas -> Nitrogen,
					VentingNeedle -> ObjectP[Model[Item, Needle]]
				}]
			}
		],
		Example[{Options, QuantitativeTransfer, "Quantitative Transfer can be set to True for manual transfer:"},
			ExperimentTransfer[
				{Model[Sample, "Acetylsalicylic Acid (Aspirin)"]},
				{Model[Container, Vessel, "50mL Tube"]},
				{12 Gram},
				QuantitativeTransfer -> True,
				QuantitativeTransferWashSolution -> Model[Sample, "Milli-Q water"],
				QuantitativeTransferWashVolume -> 2 Milliliter,
				NumberOfQuantitativeTransferWashes -> 3,
				QuantitativeTransferWashTips -> Model[Item, Tips, "5000 uL tips, non-sterile"],
				Output-> {Result,Options}
			],

			{ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					QuantitativeTransfer -> True,
					NumberOfQuantitativeTransferWashes -> 3,
					QuantitativeTransferWashInstrument -> ObjectP[Model[Instrument, Pipette, "id:KBL5Dvw6eLDk"]]
				}
				]}
		],
		Test[{"Quantitative Transfer can be performed using a labeled sample upstream in a ManualSamplePreparation:"},
			ExperimentManualSamplePreparation[
				{
					LabelSample[
						Sample -> Model[Sample, "id:8qZ1VWNmdLBD"](*"Milli-Q water"*),
						Amount -> 10 Milliliter,
						Label -> "my wash solution"
					],
					Transfer[
						Source -> {Model[Sample, "id:mnk9jOkmavPY"]},(*"Acetylsalicylic Acid (Aspirin)"*)
						Destination -> {Model[Container, Vessel, "id:bq9LA0dBGGR6"](*"50mL Tube"*)},
						Amount -> {12 Gram},
						QuantitativeTransfer -> True,
						QuantitativeTransferWashVolume -> 3 Milliliter,
						QuantitativeTransferWashSolution -> "my wash solution",
						NumberOfQuantitativeTransferWashes -> 2,
						QuantitativeTransferWashTips -> Model[Item, Tips, "id:mnk9jO3qD6R7"](*"5000 uL tips, non-sterile"*)
					]
				}
			],
			ObjectP[Object[Protocol, ManualSamplePreparation]]
		],
		Test["If quantitative wash solution is Fuming or Ventilated, use FumeHood as the TransferEnvironment:",
			ExperimentTransfer[
				{Model[Sample, "id:8qZ1VWNmdLBD"]},(*"Milli-Q water"*)
				{Model[Container, Vessel, "id:bq9LA0dBGGR6"](*"50mL Tube"*)},
				{12 Gram},
				QuantitativeTransferWashSolution -> Model[Sample, "id:mnk9jOkmavPY"],(*"Acetylsalicylic Acid (Aspirin)"*)
				Output -> Options
			],
			KeyValuePattern[{TransferEnvironment -> ObjectP[{Model[Instrument, HandlingStation, FumeHood]}]}]
		],
		Test["If tip rinse solution is Fuming or Ventilated, use FumeHood as the TransferEnvironment:",
			ExperimentTransfer[
				{Model[Sample, "id:8qZ1VWNmdLBD"]},(*"Milli-Q water"*)
				{Model[Container, Vessel, "id:bq9LA0dBGGR6"](*"50mL Tube"*)},
				1 Milliliter,
				TipRinseSolution -> Model[Sample, "id:mnk9jOkmavPY"],(*"Acetylsalicylic Acid (Aspirin)"*)
				Output -> Options
			],
			KeyValuePattern[{TransferEnvironment -> ObjectP[{Model[Instrument, HandlingStation, FumeHood]}]}]
		],
		Test[{"When Quantitative Transfer is performed, Volume is populated in simulation and State is simulated as Liquid:"},
			{options, simulation} = ExperimentTransfer[
				{Model[Sample, "id:mnk9jOkmavPY"]},(*"Acetylsalicylic Acid (Aspirin)"*)
				{Model[Container, Vessel, "id:bq9LA0dBGGR6"](*"50mL Tube"*)},
				{12 Gram},
				QuantitativeTransfer -> True,
				QuantitativeTransferWashVolume -> 3 Milliliter,
				QuantitativeTransferWashSolution -> Model[Sample, StockSolution, "70% Ethanol"],
				NumberOfQuantitativeTransferWashes -> 2,
				QuantitativeTransferWashTips -> Model[Item, Tips, "id:mnk9jO3qD6R7"],(*"5000 uL tips, non-sterile"*)
				Output -> {Options, Simulation}
			];
			destinationSample = LookupLabeledObject[simulation, Lookup[options, DestinationLabel]];
			Download[
				destinationSample,
				{State, Volume},
				Simulation -> simulation
			],
			{Liquid, GreaterP[6 Milliliter]},
			Variables :> {options, simulation, destinationSample}
		],
		Test["Create a transfer protocol when ExperimentTransfer is called on the ResolvedUnitOperationInputs and ResolvedUnitOperationOptions of an MSP generated inside ExperimentFillToVolume:",
			ExperimentTransfer[
				Object[Protocol, ManualSamplePreparation,"Test MSP Protocol of FillToVolume for ExperimentTransfer tests"<>$SessionUUID][ResolvedUnitOperationInputs][[1]],
				Sequence @@ Object[Protocol, ManualSamplePreparation,"Test MSP Protocol of FillToVolume for ExperimentTransfer tests"<>$SessionUUID][ResolvedUnitOperationOptions][[1]],
				ParentProtocol -> Object[Protocol, ManualSamplePreparation,"Test MSP Protocol of FillToVolume for ExperimentTransfer tests"<>$SessionUUID]
			],
			ObjectP[Object[Protocol,Transfer]]
		],
		Test["When calling from FillToVolume, accept Tips to be specified as Disposable Transfer Pipet:",
			Lookup[
				ExperimentTransfer[
					Model[Sample, "Milli-Q water"],
					Object[Sample, "Test water sample 1 in 100mL VolumetricFlask for ExperimentTransfer"<>$SessionUUID],
					40Milliliter,
					Tips -> Model[Item, Consumable, "id:bq9LA0J1xmBd"],
					FillToVolume -> True,
					Preparation -> Manual,
					OptionsResolverOnly -> True,
					Output->Options
				],
				Tips
			],
			Model[Item, Consumable, "id:bq9LA0J1xmBd"]
		],
		Test["Using a non-sterile model sample as source to a sterile model container, and then use the first destination container as source to transfer again will not resolve using SterileTechnique, and only 1 single transfer unit operation is in output:",
			Module[{protocol},
				protocol=ExperimentManualSamplePreparation[
					{
						LabelContainer[
							Label->"my container for non-sterile model sample",
							Container->Model[Container, Vessel, "50mL Tube"]
						],
						Transfer[
							Source->Model[Sample, "Milli-Q water"],
							Destination->"my container for non-sterile model sample",
							Amount->5 Milliliter
						],
						Transfer[
							Source->"my container for non-sterile model sample",
							Destination->Model[Container, Vessel, "2mL Tube"],
							Amount->500 Microliter
						]
					}
				];

				Download[Cases[Download[protocol, OutputUnitOperations], ObjectP[Object[UnitOperation, Transfer]]], SterileTechnique]
			],
			{{False, False}},
			TimeConstraint -> 10000
		],
		Test["Using a sterile model sample as source to a sterile model container, and then use the first destination container as source to transfer again will resolve using SterileTechnique, and only 1 single transfer unit operation is in output:",
			Module[{protocol},
				protocol=ExperimentManualSamplePreparation[
					{
						LabelContainer[
							Label->"my container for sterile model sample",
							Container->Model[Container, Vessel, "50mL Tube"]
						],
						Transfer[
							Source->Model[Sample, "Tissue Culture Grade Water"],
							Destination->"my container for sterile model sample",
							Amount->5 Milliliter
						],
						Transfer[
							Source->"my container for sterile model sample",
							Destination->Model[Container, Vessel, "2mL Tube"],
							Amount->500 Microliter
						]
					},
					ImageSample -> False,
					MeasureWeight -> False,
					MeasureVolume -> False
				];

				Download[Cases[Download[protocol, OutputUnitOperations], ObjectP[Object[UnitOperation, Transfer]]], SterileTechnique]
			],
			{{True, True}},
			TimeConstraint -> 10000
		],
		Test["Using a non-sterile model sample as source to a sterile model container, and then use the first sample out as source to transfer again will not resolved using SterileTechnique, while 2 transfer unit operations are in output:",
			Module[{protocol},
				protocol=ExperimentManualSamplePreparation[
					{
						LabelContainer[
							Label->"my sterile container",
							Container->Model[Container, Vessel, "50mL Tube"]
						],
						Transfer[
							Source->Model[Sample, "Milli-Q water"],
							Destination->"my sterile container",
							DestinationLabel->"my non-sterile water",
							Amount->5 Milliliter
						],
						Transfer[
							Source->"my non-sterile water",
							Destination->Model[Container, Vessel, "2mL Tube"],
							Amount->500 Microliter
						]
					}
				];

				Download[Cases[Download[protocol, OutputUnitOperations], ObjectP[Object[UnitOperation, Transfer]]], SterileTechnique]
			],
			{{False}, {False}},
			TimeConstraint -> 10000
		],
		Test["When using model container as destination, cover is simulated to cover destination and pass down to the next unit operation for manual preparation:",
			ExperimentManualCellPreparation[
				{
					Transfer[
						Source -> Model[Sample, "E.coli MG1655"],
						Destination -> Model[Container, Vessel, "id:AEqRl9KXBDoW"],(*Falcon Round-Bottom Polypropylene 14mL Test Tube With Cap*)
						DestinationLabel -> "my cells",
						Amount -> 5 Milliliter
					],
					IncubateCells[
						Sample -> "my cells",
						CultureAdhesion -> Suspension,
						Time -> 2 Hour
					]
				},
				Output -> Input
			],
			{TransferP, IncubateCellsP},
			TimeConstraint -> 10000
		],
		Test["When using model container as destination, cover is not simulated instead a cover unit operation is added for robotic preparation:",
			ExperimentRoboticCellPreparation[
				{
					Transfer[
						Source -> Model[Sample, "E.coli MG1655"],
						Destination -> Model[Container, Plate, "id:4pO6dMmErzez"],(*Sterile Deep Round Well, 2 mL*)
						DestinationLabel -> "my cells",
						Amount -> 1 Milliliter
					],
					IncubateCells[
						Sample -> "my cells",
						CultureAdhesion -> Suspension,
						Time -> 0.5 Hour
					]
				},
				Output -> Input
			],
			{TransferP, CoverP, IncubateCellsP},
			TimeConstraint -> 10000
		],
		Example[{Additional,"Detects two separate multichannel runs, 1) up/down -> left/right, 2) left/right -> left/right:"},
			{protocol,options}=ExperimentTransfer[{
				{"A1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]},
				Object[Sample, "Test water sample 16 in B1 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 17 in C1 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 18 in D1 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 19 in A2 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 20 in A3 of DWP for ExperimentTransfer" <> $SessionUUID]},
				{
					{"A1", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"A2", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"A3", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"A4", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"A5", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"A6", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]}
				},
				{All, All, All, All, All, All},
				ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID],
				Output -> {Result, Options}
			];

			{
				Download[protocol, BatchedUnitOperations],
				options
			},
			{
				{ObjectP[Object[UnitOperation, Transfer]], ObjectP[Object[UnitOperation, Transfer]]},
				KeyValuePattern[{
					MultichannelTransfer->True
				}]
			},
			Variables :> {protocol, options}
		],
		Test["Require advanced pipetting certificate if we are using multichannel pipette:",
			protocol = ExperimentTransfer[{
				{"A1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer"<>$SessionUUID]},
				Object[Sample, "Test water sample 16 in B1 of DWP for ExperimentTransfer"<>$SessionUUID],
				Object[Sample, "Test water sample 17 in C1 of DWP for ExperimentTransfer"<>$SessionUUID],
				Object[Sample, "Test water sample 18 in D1 of DWP for ExperimentTransfer"<>$SessionUUID],
				Object[Sample, "Test water sample 19 in A2 of DWP for ExperimentTransfer"<>$SessionUUID],
				Object[Sample, "Test water sample 20 in A3 of DWP for ExperimentTransfer"<>$SessionUUID]},
				{
					{"A1", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"A2", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"A3", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"A4", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"A5", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"A6", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]}
				},
				{All, All, All, All, All, All}
			];

			MemberQ[Download[protocol, RequiredCertifications], LinkP[Model[Certification, "id:jLq9jXqPmvxE"]]], (* Model[Certification, "Advanced Pipetting"] *)
			True,
			Variables :> {protocol}
		],
		Example[{Additional,"Detects two separate multichannel runs, 1) up/down -> down/up, 2) right/left -> left/right:"},
			{protocol,options}=ExperimentTransfer[{
				{"A1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]},
				Object[Sample, "Test water sample 16 in B1 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 17 in C1 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 18 in D1 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 20 in A3 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 19 in A2 of DWP for ExperimentTransfer" <> $SessionUUID]
				},
				{
					{"A4", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"A3", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"A2", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"A1", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"A5", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"A6", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]}
				},
				{All, All, All, All, All, All},
				ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID],
				Output -> {Result, Options}
			];

			{
				Download[protocol, BatchedUnitOperations],
				options
			},
			{
				{ObjectP[Object[UnitOperation, Transfer]], ObjectP[Object[UnitOperation, Transfer]]},
				KeyValuePattern[{
					MultichannelTransfer->True
				}]
			},
			Variables :> {protocol, options}
		],
		(* Note that the number of transfers done here in this test is large since we only resolve to MPH when larger than 4x4 *)
		Example[{Additional,"Multichannel transfers are not done in the same grouping when the source sample is previously transferred into as a destination:"},
			Module[{stocksample,allWells,resolvedInputs},
				stocksample = Model[Sample, StockSolution, "300mM Sodium Chloride"];
				allWells = AllWells[];
				resolvedInputs=ExperimentRoboticSamplePreparationInputs[
					{
						LabelContainer[
							Label -> "dwp",
							Container -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
						],

						(* dispense water into everything except the first column *)
						Transfer[
							Source -> Model[Sample, "Milli-Q water"],
							Destination -> Map[{#, "dwp"} &, Flatten[allWells[[All, 2 ;;]]]],
							Amount -> 100 Microliter
						],

						(* add concentrated stock to the first well of each row *)

						Transfer[
							Source -> stocksample,
							Destination -> Map[{#, "dwp"} &, Flatten[allWells[[All, 1]]]],
							Amount -> 200 Microliter
						],

						(* serially dilute *)
						Sequence @@ MapThread[
							Transfer[
								Source -> Table[{idx, "dwp"}, {idx, #1}],
								Destination -> Table[{idx, "dwp"}, {idx, #2}],
								Amount -> 200 Microliter
							] &,
							{Most[Transpose[allWells]], Rest[Transpose[allWells]]}
						]
					}
				];

				Lookup[resolvedInputs[[2,1]],DeviceChannel]
			],
			{(SingleProbe1|SingleProbe2|SingleProbe3|SingleProbe4|SingleProbe5|SingleProbe6|SingleProbe7|SingleProbe8)..}
		],
		Test["PipettingMethod will resolve from the Solvent field (ignoring the Composition field), test 1:",
			Module[{simulation, options},
				simulation=Simulation[{
					<|
						Object -> Object[Sample, "Test model-less sample in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
						Solvent -> Link[Model[Sample, "Test solvent model sample for ExperimentTransfer" <> $SessionUUID]],
						Replace[Composition] -> {
							{100 VolumePercent, Link[Model[Molecule, Oligomer, "id:54n6evLldkal"]], Now}
						}
					|>,
					<|
						Object->Model[Molecule, Oligomer, "id:54n6evLldkal"],
						PipettingMethod->Link[Model[Method, Pipetting, "id:R8e1PjpeL6DJ"]]
					|>
				}];

				options=ExperimentTransfer[
					Object[Sample, "Test model-less sample in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Model[Container, Vessel, "50mL Tube"],
					{100 Microliter},

					Preparation->Robotic,
					Output->Options,
					Simulation->simulation
				];

				Lookup[
					options,
					PipettingMethod
				]
			],
			ObjectP[Model[Method, Pipetting, "id:4pO6dM5OV9vr"]]
		],
		Test["PipettingMethod will resolve from the largest amount in the Composition field if Solvent field is not set, test 1:",
			Module[{simulation, options},
				simulation=Simulation[{
					<|
						Object -> Object[Sample, "Test model-less sample in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
						Replace[Composition] -> {
							{90 VolumePercent, Link[Model[Molecule,"id:qdkmxzq6W6Ba"]], Now},
							{10 VolumePercent, Link[Model[Molecule, Oligomer, "id:54n6evLldkal"]], Now}
						},
						Solvent -> Null
					|>,
					<|
						Object->Model[Molecule,"id:qdkmxzq6W6Ba"],
						PipettingMethod->Link[Model[Method, Pipetting, "id:4pO6dM5OV9vr"]]
					|>,
					<|
						Object->Model[Molecule, Oligomer, "id:54n6evLldkal"],
						PipettingMethod->Link[Model[Method, Pipetting, "id:R8e1PjpeL6DJ"]]
					|>
				}];

				options=ExperimentTransfer[
					Object[Sample, "Test model-less sample in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Model[Container, Vessel, "50mL Tube"],
					{100 Microliter},

					Preparation->Robotic,
					Output->Options,
					Simulation->simulation
				];

				Lookup[
					options,
					PipettingMethod
				]
			],
			ObjectP[Model[Method, Pipetting, "id:4pO6dM5OV9vr"]]
		],
		Test["PipettingMethod will resolve from the largest amount in the Composition field if Solvent field is not set, test 2:",
			Module[{simulation, options},
				simulation=Simulation[{
					<|
						Object -> Object[Sample, "Test model-less sample in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
						Replace[Composition] -> {
							{10 VolumePercent, Link[Model[Molecule,"id:qdkmxzq6W6Ba"]], Now},
							{90 VolumePercent, Link[Model[Molecule, Oligomer, "id:54n6evLldkal"]], Now}
						},
						Solvent -> Null
					|>,
					<|
						Object->Model[Molecule,"id:qdkmxzq6W6Ba"],
						PipettingMethod->Link[Model[Method, Pipetting, "id:4pO6dM5OV9vr"]]
					|>,
					<|
						Object->Model[Molecule, Oligomer, "id:54n6evLldkal"],
						PipettingMethod->Link[Model[Method, Pipetting, "id:R8e1PjpeL6DJ"]]
					|>
				}];

				options=ExperimentTransfer[
					Object[Sample, "Test model-less sample in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Model[Container, Vessel, "50mL Tube"],
					{100 Microliter},

					Preparation->Robotic,
					Output->Options,
					Simulation->simulation
				];

				Lookup[
					options,
					PipettingMethod
				]
			],
			ObjectP[Model[Method, Pipetting, "id:R8e1PjpeL6DJ"]]
		],
		Test["Pipetting parameters can be overridden, even if a pipetting method object is given:",
			Module[{options},
				options=ExperimentTransfer[
					Model[Sample, "Milli-Q water"],
					Model[Container, Vessel, "50mL Tube"],
					{100 Microliter},
					PipettingMethod -> Model[Method, Pipetting, "Organic Low Viscosity"],

					AspirationMix->True,
					AspirationRate -> 101 Microliter/Second,
					OverAspirationVolume -> 4 Microliter,
					AspirationWithdrawalRate -> 22 Millimeter / Second,
					AspirationEquilibrationTime -> 6 Second,
					AspirationMixRate -> 6 Microliter / Second,

					DispenseMix->True,
					DispenseRate -> 104 Microliter/Second,
					OverDispenseVolume -> 2 Microliter,
					DispenseWithdrawalRate -> 18 Millimeter / Second,
					DispenseEquilibrationTime -> 7 Second,
					DispenseMixRate -> 12 Microliter / Second,

					Output->Options
				];

				Lookup[
					options,
					{
						AspirationMix, AspirationRate, OverAspirationVolume,
						AspirationWithdrawalRate, AspirationEquilibrationTime,
						AspirationMixRate, DispenseMix, DispenseRate, OverDispenseVolume,
						DispenseWithdrawalRate, DispenseEquilibrationTime, DispenseMixRate
					}
				]
			],
			{
				True,
				101 Microliter/Second,
				4 Microliter,
				22 Millimeter / Second,
				6 Second,
				6 Microliter / Second,

				True,
				104 Microliter/Second,
				2 Microliter,
				18 Millimeter / Second,
				7 Second,
				12 Microliter / Second
			}
		],
		Test["Pipetting parameters will be inherited automatically from the pipetting method:",
			Module[{options},
				options=ExperimentTransfer[
					Model[Sample, "Milli-Q water"],
					Model[Container, Vessel, "50mL Tube"],
					{100 Microliter},
					PipettingMethod -> Model[Method, Pipetting, "Organic Low Viscosity"],

					Output->Options
				];

				Lookup[
					options,
					{
						AspirationMix, AspirationRate, OverAspirationVolume,
						AspirationWithdrawalRate, AspirationEquilibrationTime,
						AspirationMixRate, DispenseMix, DispenseRate, OverDispenseVolume,
						DispenseWithdrawalRate, DispenseEquilibrationTime, DispenseMixRate
					}
				]
			],
			{
				False,
				Download[Model[Method, Pipetting, "Organic Low Viscosity"], AspirationRate],
				Download[Model[Method, Pipetting, "Organic Low Viscosity"], OverAspirationVolume],
				Download[Model[Method, Pipetting, "Organic Low Viscosity"], AspirationWithdrawalRate],
				Download[Model[Method, Pipetting, "Organic Low Viscosity"], AspirationEquilibrationTime],
				Null,

				False,
				Download[Model[Method, Pipetting, "Organic Low Viscosity"], DispenseRate],
				Download[Model[Method, Pipetting, "Organic Low Viscosity"], OverDispenseVolume],
				Download[Model[Method, Pipetting, "Organic Low Viscosity"], DispenseWithdrawalRate],
				Download[Model[Method, Pipetting, "Organic Low Viscosity"], DispenseEquilibrationTime],
				Null
			}
		],
		Test["Robotic protocol is able to be generated when given a coordinate within the bounds of the well:",
			ExperimentTransfer[
				Model[Sample, "Milli-Q water"],
				Model[Container, Vessel, "50mL Tube"],
				{100 Microliter},
				DispensePositionOffset -> Coordinate[{1 Millimeter, -2 Millimeter, 1 Millimeter}]
			],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Example[{Messages,"PositionOffsetOutOfBounds", "Message is thrown if trying to offset the pipette out of bounds of the well:"},
			ExperimentTransfer[
				Model[Sample, "Milli-Q water"],
				Model[Container, Vessel, "50mL Tube"],
				{100 Microliter},
				DispensePositionOffset -> Coordinate[{15 Millimeter, 15 Millimeter, 1 Millimeter}]
			],
			$Failed,
			Messages:>{
				Error::PositionOffsetOutOfBounds,
				Error::InvalidOption
			}
		],
		Example[{Messages,"IncompatibleTips", "Specifying tips that are incompatible with the other transfer options results in an error:"},
			ExperimentTransfer[
				Model[Sample, "Milli-Q water"],
				Model[Container, Vessel, "50mL Tube"],
				100 Microliter,
				Tips->Model[Item, Tips, "id:O81aEBZDpVzN"],
				TipMaterial->Graphite
			],
			$Failed,
			Messages:>{
				Error::IncompatibleTips,
				Error::InvalidOption
			}
		],
		Example[{Messages,"IncompatibleTips", "The tips specified must be able to hold the (1) OverDispenseVolume, (2) transfer volume (accounting for correction curve), and (3) OverAspirationVolume:"},
			ExperimentTransfer[
				Model[Sample, "Milli-Q water"],
				Model[Container, Vessel, "50mL Tube"],
				100 Microliter,
				Tips->Model[Item,Tips,"300 uL Hamilton barrier tips, wide bore, 1.55mm orifice"],
				CorrectionCurve->{
					{0 Microliter, 0 Microliter},
					{100 Microliter, 500 Microliter}
				}
			],
			$Failed,
			Messages:>{
				Error::IncompatibleTips,
				Warning::CorrectionCurveIncomplete,
				Error::InvalidOption
			}
		],
		Example[{Messages,"IncompatibleTips", "The tips specified must be able to hold the (1) OverDispenseVolume, (2) transfer volume (accounting for correction curve), and (3) OverAspirationVolume:"},
			ExperimentTransfer[
				Model[Sample, "Milli-Q water"],
				Model[Container, Vessel, "50mL Tube"],
				100 Microliter,
				Tips->Model[Item,Tips,"300 uL Hamilton barrier tips, wide bore, 1.55mm orifice"],
				OverDispenseVolume->300 Microliter
			],
			$Failed,
			Messages:>{
				Error::IncompatibleTips,
				Error::InvalidOption
			}
		],
		Example[{Messages,"IncompatibleTips", "The tips specified must be able to hold the (1) OverDispenseVolume, (2) transfer volume (accounting for correction curve), and (3) OverAspirationVolume:"},
			ExperimentTransfer[
				Model[Sample, "Milli-Q water"],
				Model[Container, Vessel, "50mL Tube"],
				290 Microliter,
				Tips->Model[Item,Tips,"300 uL Hamilton barrier tips, wide bore, 1.55mm orifice"],
				OverAspirationVolume->50 Microliter
			],
			$Failed,
			Messages:>{
				Error::IncompatibleTips,
				Error::InvalidOption
			}
		],
		Test["The tip resolution logic will take into account OverDispenseVolume and OverAspirationVolume:",
			Lookup[
				ExperimentTransfer[
					Model[Sample, "Milli-Q water"],
					Model[Container, Vessel, "50mL Tube"],
					300 Microliter,
					OverDispenseVolume->50 Microliter,
					OverAspirationVolume->50 Microliter,
					Output->Options
				],
				Tips
			],
			ObjectP[Model[Item, Tips, "1000 uL Hamilton tips, non-sterile"]]
		],
		Test["The tip resolution logic will take into account CorrectionCurve:",
			Lookup[
				ExperimentTransfer[
					Model[Sample, "Milli-Q water"],
					Model[Container, Vessel, "50mL Tube"],
					100 Microliter,
					CorrectionCurve->{
						{0 Microliter, 0 Microliter},
						{100 Microliter, 400  Microliter}
					},
					Output->Options
				],
				Tips
			],
			ObjectP[Model[Item, Tips, "1000 uL Hamilton tips, non-sterile"]],
			Messages:>{
				Warning::CorrectionCurveIncomplete
			}
		],
		Test["MultichannelTransferName makes sure to make a new group if the device channel was used in the previous group:",
			Module[{protocol},
				protocol=ExperimentTransfer[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"]
					},
					{
						100 Microliter,
						100 Microliter,
						100 Microliter
					},
					DeviceChannel -> SingleProbe1
				];

				SameQ@@Download[protocol, OutputUnitOperations[[1]][MultichannelTransferName]]
			],
			False
		],
		Test["MultichannelTransferName puts transfers into the same group if the device channel isn't used in the previous group:",
			Module[{protocol},
				protocol=ExperimentTransfer[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "50mL Tube"]
					},
					{
						100 Microliter,
						100 Microliter,
						100 Microliter
					},
					DeviceChannel -> {
						SingleProbe1,
						SingleProbe2,
						SingleProbe3
					}
				];

				SameQ@@Download[protocol, OutputUnitOperations[[1]][MultichannelTransferName]]
			],
			True
		],
		Test["When doing a single robotic transfer, DeviceChannel is resolved to SingleProbe1 by default:",
			Module[{protocol},
				protocol=ExperimentTransfer[
					{
						Model[Sample, "Milli-Q water"]
					},
					{
						Model[Container, Vessel, "50mL Tube"]
					},
					{
						100 Microliter
					},
					Preparation->Robotic
				];

				Download[protocol, OutputUnitOperations[[1]][DeviceChannel]]
			],
			{SingleProbe1}
		],
		Example[{Messages,"NoCompatibleTips", "Reasonable message is thrown if asked to transfer using tip requirments for which there are no engine default tips in the lab:"},
			ExperimentTransfer[
				{
					{"A1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]}
				},
				{
					{"A4", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]}
				},
				{All},
				TipMaterial->Graphite
			],
			$Failed,
			Messages:>{
				Error::NoCompatibleTips,
				Error::InvalidOption
			}
		],
		Example[{Additional,"Detects two separate multichannel runs, 1) up/down -> down/up, 2) right/left -> left/right, into empty wells:"},
			{protocol,options}=ExperimentTransfer[{
				{"A1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]},
				Object[Sample, "Test water sample 16 in B1 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 17 in C1 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 18 in D1 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 20 in A3 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 19 in A2 of DWP for ExperimentTransfer" <> $SessionUUID]
			},
				{
					{"B4", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"B3", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"B2", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"B1", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"B5", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"B6", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]}
				},
				{All, All, All, All, All, All},
				ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID],
				Output -> {Result, Options}
			];

			{
				Download[protocol, BatchedUnitOperations],
				options
			},
			{
				{ObjectP[Object[UnitOperation, Transfer]], ObjectP[Object[UnitOperation, Transfer]]},
				KeyValuePattern[{
					MultichannelTransfer->True
				}]
			},
			Variables :> {protocol, options}
		],
		Example[{Additional, "Set MultichannelTransfer to False is we are aspiration mixing for more than $MaxNumberOfMultichannelPipetteMixes times manually:"},
			ExperimentTransfer[
				{
					{"A1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer"<>$SessionUUID]},
					Object[Sample, "Test water sample 16 in B1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 17 in C1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 18 in D1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 20 in A3 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 19 in A2 of DWP for ExperimentTransfer"<>$SessionUUID]
				},
				{
					{"B4", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B3", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B2", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B1", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B5", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B6", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]}
				},
				ConstantArray[0.5 * Milliliter, 6],
				Preparation -> Manual,
				NumberOfAspirationMixes -> ($MaxNumberOfMultichannelPipetteMixes + 1),
				AspirationMixType -> Pipette,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					MultichannelTransfer -> False
				}]
			}
		],
		Test["do not need advanced pipetting certificate if we are not using advanced pipettes (multichannel or positive displacement):",
			protocol = ExperimentTransfer[
				{
					{"A1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer"<>$SessionUUID]},
					Object[Sample, "Test water sample 16 in B1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 17 in C1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 18 in D1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 20 in A3 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 19 in A2 of DWP for ExperimentTransfer"<>$SessionUUID]
				},
				{
					{"B4", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B3", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B2", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B1", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B5", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B6", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]}
				},
				ConstantArray[0.5 * Milliliter, 6],
				Preparation -> Manual,
				NumberOfAspirationMixes -> ($MaxNumberOfMultichannelPipetteMixes + 1),
				AspirationMixType -> Pipette,
				MultichannelTransfer -> False
			];

			MemberQ[Download[protocol,RequiredCertifications], LinkP[Model[Certification, "id:jLq9jXqPmvxE"]]], (* Model[Certification, "Advanced Pipetting"] *)
			False,
			Variables :> {protocol}
		],
		Example[{Additional, "$MaxNumberOfMultichannelPipetteMixes is not considered when resolving MultichannelTransfer if the transfer is done robotically:"},
			ExperimentTransfer[
				{
					{"A1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer"<>$SessionUUID]},
					Object[Sample, "Test water sample 16 in B1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 17 in C1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 18 in D1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 20 in A3 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 19 in A2 of DWP for ExperimentTransfer"<>$SessionUUID]
				},
				{
					{"B4", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B3", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B2", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B1", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B5", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B6", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]}
				},
				ConstantArray[0.5 * Milliliter, 6],
				Preparation -> Robotic,
				NumberOfAspirationMixes -> ($MaxNumberOfMultichannelPipetteMixes + 1),
				AspirationMixType -> Pipette,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, RoboticSamplePreparation]],
				KeyValuePattern[{
					MultichannelTransfer -> True
				}]
			}
		],
		Example[{Messages, "TooManyMixesWithMultichannelPipette", "Throw a warning if we are aspiration mixing for more than $MaxNumberOfMultichannelPipetteMixes times using multichannel transfer manually:"},
			ExperimentTransfer[
				{
					{"A1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer"<>$SessionUUID]},
					Object[Sample, "Test water sample 16 in B1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 17 in C1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 18 in D1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 20 in A3 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 19 in A2 of DWP for ExperimentTransfer"<>$SessionUUID]
				},
				{
					{"B4", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B3", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B2", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B1", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B5", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B6", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]}
				},
				ConstantArray[0.5 * Milliliter, 6],
				Preparation -> Manual,
				NumberOfAspirationMixes -> ($MaxNumberOfMultichannelPipetteMixes + 1),
				MultichannelTransfer -> True,
				AspirationMixType -> Pipette,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					MultichannelTransfer -> True
				}]
			},
			Messages :> {Warning::TooManyMixesWithMultichannelPipette}
		],
		Example[{Messages, "TooManyMixesWithMultichannelPipette", "Throw a warning if we are dispense mixing for more than $MaxNumberOfMultichannelPipetteMixes times using multichannel transfer manually:"},
			ExperimentTransfer[
				{
					{"A1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer"<>$SessionUUID]},
					Object[Sample, "Test water sample 16 in B1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 17 in C1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 18 in D1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 20 in A3 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 19 in A2 of DWP for ExperimentTransfer"<>$SessionUUID]
				},
				{
					{"B4", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B3", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B2", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B1", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B5", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]},
					{"B6", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer"<>$SessionUUID]}
				},
				ConstantArray[0.5 * Milliliter, 6],
				Preparation -> Manual,
				NumberOfDispenseMixes -> ($MaxNumberOfMultichannelPipetteMixes + 1),
				MultichannelTransfer -> True,
				DispenseMixType -> Pipette,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					MultichannelTransfer -> True
				}]
			},
			Messages :> {Warning::TooManyMixesWithMultichannelPipette}
		],
		Example[{Additional,"Detects two separate multichannel runs, 1) up/down -> down/up, 2) right/left -> left/right, with a random transfer in between:"},
			{protocol,options}=ExperimentTransfer[{
				{"A1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]},
				Object[Sample, "Test water sample 16 in B1 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 17 in C1 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 18 in D1 of DWP for ExperimentTransfer" <> $SessionUUID],
				Model[Sample, "Milli-Q water"],
				Object[Sample, "Test water sample 20 in A3 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 19 in A2 of DWP for ExperimentTransfer" <> $SessionUUID]
			},
				{
					{"B4", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"B3", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"B2", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"B1", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{1, Model[Container, Vessel, "50mL Tube"]},
					{"B5", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"B6", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]}
				},
				{All, All, All, All, 20 Milliliter, All, All},
				ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID],
				Output -> {Result, Options}
			];

			{
				Download[protocol, BatchedUnitOperations],
				options
			},
			{
				{ObjectP[Object[UnitOperation, Transfer]], ObjectP[Object[UnitOperation, Transfer]], ObjectP[Object[UnitOperation, Transfer]]},
				KeyValuePattern[{
					MultichannelTransfer->{True, True, True, True, False, True, True}
				}]
			},
			Variables :> {protocol, options}
		],
		Example[{Additional,"Resolves SourceWell and DestinationWell correctly:"},
			ExperimentTransfer[{
				{"A1", Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]},
				Object[Sample, "Test water sample 16 in B1 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 17 in C1 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 18 in D1 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 19 in A2 of DWP for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 20 in A3 of DWP for ExperimentTransfer" <> $SessionUUID]},
				{
					{"A1", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"A2", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"A3", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"A4", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"A5", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]},
					{"A6", Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID]}
				},
				{All, All, All, All, All, All},
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					SourceWell -> {"A1", "B1", "C1", "D1", "A2", "A3"},
					DestinationWell -> {"A1", "A2", "A3", "A4", "A5", "A6"}
				}]
			}
		],
		Example[{Additional,"Transfer into a new Model[Container] using integer syntax:"},
			ExperimentTransfer[
				{Model[Sample, "Milli-Q water"]},
				{1, Model[Container, Vessel, "50mL Tube"]},
				{40 Milliliter},
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				_List
			}
		],
		Example[{Additional,"A single transfer of Model[Sample, \"Milli-Q water\"] over 50mL will result in us directly using a graduated cylinder:"},
			ExperimentTransfer[
				Model[Sample, "Milli-Q water"],
				PreferredContainer[100 Milliliter],
				55 Milliliter,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					Instrument -> ObjectP[Model[Container, GraduatedCylinder]]
				}]
			}
		],
		Example[{Additional,"Transfers of Model[Sample, \"Milli-Q water\"] under 3mL not use a graduated cylinder/water purifier:"},
			ExperimentTransfer[{
				Model[Sample, "Milli-Q water"]},
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					Instrument->ObjectP[Model[Instrument, Pipette]]
				}]
			}
		],
		Example[{Additional,"The RestrictSource option resolves to False by default:"},
			ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter,
				RestrictSource -> Automatic,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					RestrictSource -> False
				}]
			}
		],
		Example[{Additional,"The RestrictSource option resolves to True when the sample is set to be Restricted elsewhere in the ExperimentTransfer call:"},
			ExperimentTransfer[
				{Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]},
				{Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]},
				{1 Milliliter, 1 Milliliter},
				RestrictSource -> {True, Automatic},
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					RestrictSource -> {True, True}
				}]
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
				UnrestrictSamples[{Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]}];
			)
		],
		Example[{Additional,"The RestrictDestination option resolves to False by default:"},
			ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter,
				RestrictDestination -> Automatic,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					RestrictDestination -> False
				}]
			}
		],
		Example[{Additional,"The RestrictDestination option resolves to True when the sample is set to be Restricted elsewhere in the ExperimentTransfer call:"},
			ExperimentTransfer[
				{Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]},
				{Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]},
				{1 Milliliter, 1 Milliliter},
				RestrictDestination -> {True, Automatic},
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					RestrictDestination -> {True, True}
				}]
			},
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects];
				UnrestrictSamples[{Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]}];
			)
		],
		Example[{Additional,"Hermetic transfer with liquid samples in between two hermetic containers with unsealing specified for the source:"},
			ExperimentTransfer[
				Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 4 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
				500 Microliter,
				UnsealHermeticSource -> True,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					Instrument -> ObjectP[Model[Container, Syringe]],
					Balance -> Null,
					Tips -> Null,
					TipType -> Null,
					TipMaterial -> Null,
					ReversePipetting -> Null,
					Needle -> ObjectP[Model[Item, Needle]],
					WeighingContainer -> Null,
					Tolerance -> Null,
					HandPump -> Null,
					QuantitativeTransfer -> False,
					UnsealHermeticSource -> True,
					UnsealHermeticDestination -> False,
					BackfillNeedle -> Null,
					BackfillGas -> Null,
					VentingNeedle -> ObjectP[Model[Item, Needle]]
				}]
			}
		],
		Example[{Additional,"Hermetic transfer with liquid samples in between two hermetic containers with unsealing specified for the destination:"},
			ExperimentTransfer[
				Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 4 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
				500 Microliter,
				UnsealHermeticDestination -> True,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					Instrument -> ObjectP[Model[Container, Syringe]],
					Balance -> Null,
					Tips -> Null,
					TipType -> Null,
					TipMaterial -> Null,
					ReversePipetting -> Null,
					Needle -> ObjectP[Model[Item, Needle]],
					WeighingContainer -> Null,
					Tolerance -> Null,
					HandPump -> Null,
					QuantitativeTransfer -> False,
					UnsealHermeticSource -> False,
					UnsealHermeticDestination -> True,
					BackfillNeedle -> ObjectP[Model[Item, Needle]],
					BackfillGas -> Nitrogen
				}]
			}
		],
		Example[{Additional,"Hermetic transfer with liquid samples in between two hermetic containers with unsealing specified for both the source and the destination:"},
			ExperimentTransfer[
				Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
				Object[Sample, "Test water sample 4 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
				500 Microliter,
				UnsealHermeticSource -> True,
				UnsealHermeticDestination -> True,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					Instrument -> ObjectP[Model[Instrument, Pipette]],
					Balance -> Null,
					Tips -> ObjectP[Model[Item, Tips]],
					TipType -> TipTypeP,
					TipMaterial -> MaterialP,
					ReversePipetting -> False,
					Needle -> Null,
					WeighingContainer -> Null,
					Tolerance -> Null,
					HandPump -> Null,
					UnsealHermeticSource -> True,
					UnsealHermeticDestination -> True,
					BackfillNeedle -> Null,
					BackfillGas -> Null,
					VentingNeedle -> Null
				}]
			}
		],
		Example[{Additional,"Solid transfer into an empty container:"},
			ExperimentTransfer[
				Object[Sample, "Test powder sample 5 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID],
				1 Gram,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					Instrument -> ObjectP[Model[Item, Spatula]],
					Balance -> ObjectP[Model[Instrument, Balance]],
					Tips -> Null,
					TipType -> Null,
					TipMaterial -> Null,
					ReversePipetting -> Null,
					Needle -> Null,
					WeighingContainer -> Null,
					Tolerance -> MassP,
					HandPump -> Null,
					BackfillNeedle -> Null,
					BackfillGas -> Null,
					VentingNeedle -> Null
				}]
			}
		],
		Example[{Additional,"Setting Magnetization->True automatically turns on the other Magnetization options:"},
			ExperimentTransfer[
				Object[Sample, "Test powder sample 6 (SampleHandling->Null) in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID],
				1 Gram,
				Magnetization -> True,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					Magnetization -> True,
					MagnetizationTime -> TimeP,
					MaxMagnetizationTime -> TimeP,
					MagnetizationRack -> ObjectP[{Model[Container,Rack],Model[Item,MagnetizationRack]}]
				}]
			}
		],
		Example[{Additional,"PreparedResources option works for MSP:"},
			Module[{resource, protocol},
				resource=Upload[<|Type->Object[Resource, Sample]|>];

				protocol=ExperimentTransfer[
					Object[Sample, "Test powder sample 6 (SampleHandling->Null) in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Container,Vessel,"Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID],
					1 Gram,
					ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID],
					PreparedResources->{resource}
				];

				Download[protocol, PreparedResources]
			],
			{ObjectP[Object[Resource, Sample]]}
		],
		Example[{Additional,"PreparedResources option works for RSP:"},
			Module[{resource, protocol},
				resource=Upload[<|Type->Object[Resource, Sample]|>];

				protocol=ExperimentTransfer[
					Model[Sample, "Milli-Q water"],
					Model[Container, Vessel, "50mL Tube"],
					500 Microliter,
					Preparation->Robotic,
					ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID],
					PreparedResources->{resource}
				];

				Download[protocol, PreparedResources]
			],
			{ObjectP[Object[Resource, Sample]]}
		],
		Example[{Additional,"Solid transfer with SampleHandling->Null into an empty container:"},
			ExperimentTransfer[
				Object[Sample, "Test powder sample 6 (SampleHandling->Null) in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID],
				1 Gram,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					Instrument -> ObjectP[Model[Item, Spatula]],
					Balance -> ObjectP[Model[Instrument, Balance]],
					Tips -> Null,
					TipType -> Null,
					TipMaterial -> Null,
					ReversePipetting -> Null,
					Needle -> Null,
					WeighingContainer -> Null,
					Tolerance -> MassP,
					HandPump -> Null,
					BackfillNeedle -> Null,
					BackfillGas -> Null,
					VentingNeedle -> Null
				}]
			}
		],
		Example[{Additional, "Test a variety of transfer methods together in a single call:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test powder sample 5 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test powder sample 5 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Sample, "Test water sample 4 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 4 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
					Object[Container,Plate,"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Container,Plate,"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					500 Microliter,
					500 Microliter,
					.1 Gram,
					.1 Gram
				},
				UnsealHermeticSource -> {
					False,
					True,
					False,
					False
				},
				UnsealHermeticDestination -> False,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					Instrument -> {
						ObjectP[Model[Container, Syringe]],
						ObjectP[Model[Container, Syringe]],
						ObjectP[Model[Item, Spatula]],
						ObjectP[Model[Item, Spatula]]
					},
					Balance -> {
						Null,
						Null,
						ObjectP[Model[Instrument, Balance]],
						ObjectP[Model[Instrument, Balance]]
					},
					Needle -> {
						ObjectP[Model[Item, Needle]],
						ObjectP[Model[Item, Needle]],
						Null,
						Null
					},
					Tolerance -> {
						Null,
						Null,
						MassP,
						MassP
					},
					UnsealHermeticSource -> {
						False,
						True,
						False,
						False
					}
				}]
			},
			Messages :> {
			}
		],
		Example[{Additional, "Gravimetric transfers of liquids use a pipette and tips, transfer directly into the empty destination container:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Model[Container, Vessel, "50mL Tube"]
				},
				{
					1.5 Gram
				},
				Output -> Options
			],
			KeyValuePattern[{
				Instrument -> ObjectP[Model[Instrument, Pipette]],
				Tips -> ObjectP[Model[Item, Tips]],
				WeighingContainer->Null
			}],
			Messages :> {}
		],
		Example[{Additional, "The SourceWell option is smart enough to figure out what wells of the source container will be non-empty and will resolve to that:"},
			ExperimentTransfer[
				{
					Model[Sample, "Milli-Q water"],
					{1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]}
				},
				{
					{1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
					{2, Model[Container, Vessel, "50mL Tube"]}
				},
				{
					1 Milliliter,
					All
				},
				DestinationWell -> {"E2", "A1"},
				Output -> Options
			],
			KeyValuePattern[{
				SourceWell -> {"A1", "E2"},
				DestinationWell -> {"E2", "A1"}
			}],
			Messages :> {}
		],
		Example[{Additional, "A viscous sample can be transferred with PositiveDisplacement pipette:"},
			protocol = ExperimentTransfer[
				Object[Sample, "Test viscous sample 9 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Model[Container, Vessel, "50mL Tube"],
				0.5 Milliliter,
				ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];
			Download[protocol,RequiredInstruments[PipetteType]],
			{PositiveDisplacement},
			Variables :> {protocol},
			Messages :> {}
		],
		Test["Require advanced pipetting certificate if we are using positive displacement pipette in the top level msp:",
			protocol = ExperimentTransfer[
				Object[Sample, "Test viscous sample 9 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Model[Container, Vessel, "50mL Tube"],
				0.5 Milliliter
			];
			MemberQ[Download[protocol,RequiredCertifications], LinkP[Model[Certification, "id:jLq9jXqPmvxE"]]], (* Model[Certification, "Advanced Pipetting"] *)
			True,
			Variables :> {protocol}
		],
		Test["Require advanced pipetting certificate if we are using positive displacement pipette in a transfer UO using msp call:",
			protocol = ExperimentManualSamplePreparation[
				{
					Transfer[
						Source -> Object[Sample, "Test viscous sample 9 in 50mL Tube for ExperimentTransfer"<>$SessionUUID],
						Destination -> Model[Container, Vessel, "50mL Tube"],
						Amount -> 0.5 Milliliter
					]
				}
			];
			MemberQ[Download[protocol,RequiredCertifications], LinkP[Model[Certification, "id:jLq9jXqPmvxE"]]], (* Model[Certification, "Advanced Pipetting"] *)
			True,
			Variables :> {protocol}
		],
		Test["Require advanced pipetting certificate if we are using positive displacement pipette in Object[Protocol, Transfer]:",
			protocol = ExperimentTransfer[
				Object[Sample, "Test viscous sample 9 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Model[Container, Vessel, "50mL Tube"],
				0.5 Milliliter,
				ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];
			MemberQ[Download[protocol,RequiredCertifications], LinkP[Model[Certification, "id:jLq9jXqPmvxE"]]], (* Model[Certification, "Advanced Pipetting"] *)
			True,
			Variables :> {protocol}
		],
		Test["Require advanced pipetting certificate if we are doing slurry transfer with micropipette:",
			protocol = ExperimentTransfer[
				Object[Sample, "Test slurry sample 8 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Model[Container, Vessel, "50mL Tube"],
				0.5 Milliliter,
				Instrument -> Model[Instrument, Pipette, "id:1ZA60vL547EM"], (* P1000 *)
				SlurryTransfer -> True,
				ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];
			MemberQ[Download[protocol,RequiredCertifications], LinkP[Model[Certification, "id:jLq9jXqPmvxE"]]], (* Model[Certification, "Advanced Pipetting"] *)
			True,
			Variables :> {protocol}
		],
		Test["Do not require advanced pipetting certificate if we are not doing slurry transfer with micropipette:",
			protocol = ExperimentTransfer[
				Object[Sample, "Test slurry sample 8 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Model[Container, Vessel, "50mL Tube"],
				9 Milliliter,
				Instrument -> Model[Container, GraduatedCylinder, "10 mL KIMAX, glass graduated cylinder"],
				SlurryTransfer -> True,
				ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];
			MemberQ[Download[protocol,RequiredCertifications], LinkP[Model[Certification, "id:jLq9jXqPmvxE"]]], (* Model[Certification, "Advanced Pipetting"] *)
			False,
			Variables :> {protocol}
		],
		Example[{Additional, "A viscous sample can be transferred gravimetrically by specifying mass amount when Mass is informed in the object:"},
			protocol = ExperimentTransfer[
				Object[Sample, "Test viscous sample 22 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Model[Container, Vessel, "50mL Tube"],
				0.5 Gram,
				ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];
			Download[protocol,{RequiredInstruments[PipetteType],BatchedUnitOperations[Balance]}],
			{{PositiveDisplacement},{{ObjectP[Model[Instrument,Balance]]}}},
			Variables :> {protocol},
			Messages :> {}
		],
		Example[{Messages,"NonAnhydrousSample","If samples are going into the glove box, they should be Anhydrous:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test methanol sample 7 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					1 Milliliter
				},
				TransferEnvironment->Model[Instrument, HandlingStation, GloveBox, "id:6V0npvqD9156"],
				Output -> Options
			],
			KeyValuePattern[{
				Instrument -> ObjectP[Model[Instrument, Pipette]],
				TransferEnvironment->Model[Instrument, HandlingStation, GloveBox, "id:6V0npvqD9156"],
				Tips -> ObjectP[Model[Item, Tips]]
			}],
			Messages :> {
				Message[Warning::NonAnhydrousSample]
			}
		],
		Example[{Messages,"SterileTransfersAreInBSC","SterileTechnique->True transfers must occur in a BSC:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test methanol sample 7 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					1 Milliliter
				},
				TransferEnvironment->Model[Instrument, HandlingStation, Ambient, "id:8qZ1VWkXo06X"],
				Tips->Model[Item, Tips, "id:8qZ1VWNw1z0X"],
				SterileTechnique->True,
				Output -> Options
			],
			KeyValuePattern[{
				Instrument -> ObjectP[Model[Instrument, Pipette]],
				TransferEnvironment->Model[Instrument, HandlingStation, Ambient, "id:8qZ1VWkXo06X"],
				Tips -> ObjectP[Model[Item, Tips]],
				SterileTechnique->True
			}],
			Messages :> {
				Message[Error::SterileTransfersAreInBSC],
				Message[Error::TransferEnvironmentInstrumentCombination],
				Message[Error::InvalidTransferEnvironment],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"AspiratorRequiresSterileTransfer","All transfers using an aspirator must have SterileTechnique->True:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test methanol sample 7 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Waste
				},
				{
					All
				},
				SterileTechnique->False,
				Output -> Options
			],
			KeyValuePattern[{
				SterileTechnique->False
			}],
			Messages :> {
				Message[Error::SterileTransfersAreInBSC],
				Message[Error::VolatileHazardousSamplesInBSC],
				Message[Error::AspiratorRequiresSterileTransfer],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"VolatileHazardousSamplesInBSC","Volatile hazardous materials are not allowed to be transferred in a biosafety cabinet:"},
			ExperimentTransfer[
				{Model[Sample, "Chloroform"]},
				{Model[Container, Vessel, "2 mL clear glass vial, sterile with septum and aluminum crimp top"]},
				{150 Microliter},
				TransferEnvironment -> Model[Instrument, HandlingStation, BiosafetyCabinet, "Biosafety Cabinet Handling Station for Tissue Culture"],
				Instrument ->
					Model[Instrument, Pipette,
						"Eppendorf Research Plus P200, Tissue Culture"]
			],
			$Failed,
			Messages :> {
				Message[Error::VolatileHazardousSamplesInBSC],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"VolatileHazardousSamplesInBSC","Volatile hazardous materials are not allowed to be handled in a biosafety cabinet:"},
			ExperimentTransfer[
				{Model[Sample, "Chloroform"]},
				{Model[Container, Vessel, "2 mL clear glass vial, sterile with septum and aluminum crimp top"]},
				{150 Microliter},
				TransferEnvironment -> Model[Instrument, HandlingStation, BiosafetyCabinet, "Biosafety Cabinet Handling Station for Tissue Culture"],
				Instrument -> Model[Instrument, Pipette, "Eppendorf Research Plus P200, Tissue Culture"]
			],
			$Failed,
			Messages :> {
				Message[Error::VolatileHazardousSamplesInBSC],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"InvalidBackfillGas","Backfill transfers must occur in a BSC or in a fume hood (gas lines are not available on a regular bench):"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					1 Milliliter
				},
				TransferEnvironment->Model[Instrument, HandlingStation, Ambient, "id:8qZ1VWkXo06X"],
				BackfillGas->Argon,
				Output -> Options
			],
			KeyValuePattern[{
				TransferEnvironment->Model[Instrument, HandlingStation, Ambient, "id:8qZ1VWkXo06X"],
				BackfillGas->Argon
			}],
			Messages :> {
				Message[Error::InvalidBackfillGas],
				Message[Error::InvalidTransferEnvironment],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"InvalidBackfillGas","Backfill transfers must occur in a handling station with the correct gas pipe):"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					1 Milliliter
				},
				TransferEnvironment->Model[Instrument, HandlingStation, Ambient, "id:8qZ1VWkXo06X"],
				BackfillGas->Argon,
				Output -> Options
			],
			KeyValuePattern[{
				TransferEnvironment->ObjectP[Model[Instrument, HandlingStation, Ambient, "id:8qZ1VWkXo06X"]],
				BackfillGas->Argon
			}],
			Messages :> {
				Message[Error::InvalidBackfillGas],
				Message[Error::InvalidTransferEnvironment],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"AqueousGloveBoxSamples","Aqueous samples (or samples with Water in the Composition) cannot be handled in the glove box:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					1 Milliliter
				},
				TransferEnvironment->Model[Instrument, HandlingStation, GloveBox, "id:6V0npvqD9156"],
				Output -> Options
			],
			KeyValuePattern[{
				Instrument -> ObjectP[Model[Instrument, Pipette]],
				TransferEnvironment->Model[Instrument, HandlingStation, GloveBox, "id:6V0npvqD9156"],
				Tips -> ObjectP[Model[Item, Tips]]
			}],
			Messages :> {
				Message[Warning::NonAnhydrousSample],
				Message[Error::AqueousGloveBoxSamples],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"InvalidDestinationFunnel","If given a funnel, it must be able to fit in the destination container:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Sample, "Test water sample 14 in 2mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					500 Microliter
				},
				Funnel->Model[Part, Funnel, "id:vXl9j57WMVWJ"],
				Output -> Options
			],
			KeyValuePattern[{
				Instrument -> ObjectP[Model[Instrument, Pipette]],
				Tips -> ObjectP[Model[Item, Tips]],
				Funnel->Model[Part, Funnel, "id:vXl9j57WMVWJ"]
			}],
			Messages :> {
				Message[Error::InvalidDestinationFunnel],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"InvalidIntermediateFunnel","If given an intermediate funnel, it must be able to fit into the intermediate container:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Sample, "Test water sample 14 in 2mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					500 Microliter
				},
				IntermediateDecant->True,
				IntermediateFunnel->Model[Part, Funnel, "id:vXl9j57WMVWJ"],
				IntermediateContainer->Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			],
			KeyValuePattern[{
				Instrument -> ObjectP[Model[Instrument, Pipette]],
				Tips -> ObjectP[Model[Item, Tips]],
				IntermediateFunnel->Model[Part, Funnel, "id:vXl9j57WMVWJ"]
			}],
			Messages :> {
				Message[Error::InvalidIntermediateFunnel],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"ToleranceLessThanBalanceResolution","If given a tolerance, make sure that it is achievable on the given balance:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Model[Container, Vessel, "50mL Tube"]
				},
				{
					1.5 Gram
				},
				Tolerance->0.000001 Gram,
				Output -> Options
			],
			KeyValuePattern[{
				Instrument -> ObjectP[Model[Instrument, Pipette]],
				Tips -> ObjectP[Model[Item, Tips]],
				Tolerance->0.000001 Gram
			}],
			Messages :> {
				Message[Error::ToleranceLessThanBalanceResolution],
				Message[Error::InvalidOption]
			}
		],
		Test["Consolidate funnel resources based on reused when 1) destination is the same, and 2) source is the same and previous destination started out empty:",
			protocol=ExperimentTransfer[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Acetone, Reagent Grade"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Acetone, Reagent Grade"]
				},
				{
					Object[Container,Vessel,VolumetricFlask,"Test 250mL VolumetricFlask 3 for ExperimentTransfer"<>$SessionUUID],
					Object[Container,Vessel,VolumetricFlask,"Test 250mL VolumetricFlask 3 for ExperimentTransfer"<>$SessionUUID],
					Object[Container,Vessel,VolumetricFlask,"Test 250mL VolumetricFlask 4 for ExperimentTransfer"<>$SessionUUID],
					Object[Container,Vessel,VolumetricFlask,"Test 250mL VolumetricFlask 5 for ExperimentTransfer"<>$SessionUUID],
					Object[Container,Vessel,VolumetricFlask,"Test 250mL VolumetricFlask 6 for ExperimentTransfer"<>$SessionUUID],
					Object[Container,Vessel,VolumetricFlask,"Test 250mL VolumetricFlask 6 for ExperimentTransfer"<>$SessionUUID]
				},
				ConstantArray[10 Milliliter, 6],
				ParentProtocol -> Object[Protocol,ManualSamplePreparation,"Test MSP for ExperimentTransfer"<>$SessionUUID]
			];
			(* get number of unique resources *)
			Length[
				DeleteDuplicatesBy[
					Cases[protocol[RequiredResources], {_, Funnels, ___}][[All, 1]],
					ObjectP[#] &
				]
			],
			2, (* expected number of unique resources 1) for transfers with same destination 1 and 2, 2) for transfers with same source and empty previous destinations 3,4,5,6 *)
			Variables:>{protocol}
		],
		Test["Use a weighing container and the Analytical balance if the transfer amount is close to the resolution of a Macro balance, even if the total weight of destination container and the sample will not fit on the Analytical balance:",
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					(* 250 mL Glass Bottle *)
					Model[Container, Vessel, "id:J8AY5jwzPPR7"]
				},
				{
					10 Milligram
				},
				Output -> Options
			],
			KeyValuePattern[{
				Balance -> ObjectP[{Model[Instrument, Balance, "id:54n6evKx08XN"], Model[Instrument, Balance, "id:rea9jl5Vl1ae"], Model[Instrument, Balance, "id:KBL5DvYl3zGN"], Model[Instrument, Balance, "id:N80DNj1Gr5RD"], Model[Instrument, Balance, "id:rea9jl5Vl1ae"]}],
				WeighingContainer -> ObjectP[]
			}],
			Messages :> {Message[Warning::QuantitativeTransferRecommended]}
		],
		Test["Use a weighing container if we are transferring solids into a container that is Immobile:",
			ExperimentTransfer[
				Model[Sample, "id:BYDOjv1VA88z"],
				Model[Container, Vessel, "Bruker ALPHA Sampling Module"],
				10 Milligram,
				Output -> Options
			],
			KeyValuePattern[{
				WeighingContainer -> ObjectP[]
			}],
			Messages :> {Message[Warning::QuantitativeTransferRecommended]}
		],
		Test["When using individually-stickered weigh boats for multiple transfer, resource pick multiple WeighingContainers:",
			protocol = ExperimentTransfer[
				{Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Model[Sample, "id:BYDOjv1VA88z"]},
				{(*250 mL Glass Bottle*)
					Model[Container, Vessel, "id:J8AY5jwzPPR7"],
					Model[Container, Vessel, "id:J8AY5jwzPPR7"]},
				{10 Milligram, 20 Milligram},
				WeighingContainer -> Model[Item, WeighBoat, "id:XnlV5jOD1AjZ"],
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];
			(* Download all the resouce objects created for WeighingContainers *)
			DeleteDuplicates@Cases[
				Download[protocol, RequiredResources],
				{_, WeighingContainers, _, _}
			][[All, 1]][Object],
			(*Should be just 1*)
			{ObjectP[Object[Resource, Sample]], ObjectP[Object[Resource, Sample]]},
			Messages :> {Message[Warning::QuantitativeTransferRecommended]},
			Variables :> {protocol, resource}
		],
		Example[{Messages,"PlateTransferInstrumentRequired","If we are transferring a sample out of a plate, we cannot pour (Instrument->Null):"},
			ExperimentTransfer[
				{
					Model[Sample, "Milli-Q water"],
					{1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]}
				},
				{
					{1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]},
					{2, Model[Container, Vessel, "50mL Tube"]}
				},
				{
					1 Milliliter,
					All
				},
				DestinationWell -> {"E2", "A1"},
				Instrument -> {Automatic, Null},
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::PlateTransferInstrumentRequired],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"TransferInstrumentRequired","We cannot pour (Instrument->Null) if Amount isn't All:"},
			ExperimentTransfer[
				{
					Model[Sample, "Milli-Q water"],
					{1, Model[Container, Vessel, "50mL Tube"]}
				},
				{
					{1, Model[Container, Vessel, "50mL Tube"]},
					{2, Model[Container, Vessel, "50mL Tube"]}
				},
				{
					1 Milliliter,
					0.5 Milliliter
				},
				Instrument -> {Automatic, Null},
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::TransferInstrumentRequired],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"RoundedTransferAmount","The amount transferred will be rounded if it is not achievable by the Resolution of the transfer devices at the ECL for the given mass/volume range:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					{1, Model[Container, Vessel, "50mL Tube"]}
				},
				{
					1.000001 Microliter
				},
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Warning::RoundedTransferAmount]
			}
		],
		Example[{Messages,"TransferSolidSampleByVolume","Solid samples cannot be transferred by volume:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test powder sample 5 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					{1, Model[Container, Vessel, "50mL Tube"]}
				},
				{
					1 Milliliter
				},
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::IncorrectlySpecifiedTransferOptions],
				Message[Error::TransferSolidSampleByVolume],
				Message[Error::InvalidInput],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"GaseousSample","Transfer of gaseous samples is not supported:"},
			ExperimentTransfer[
				{
					Model[Sample, "id:o1k9jAKOwwlE"] (* "Carbon dioxide" *)
				},
				{
					{1, Model[Container, Vessel, "50mL Tube"]}
				},
				{
					1 Milliliter
				},
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::TransferInstrumentRequired],
				Message[Error::GaseousSample],
				Message[Error::InvalidInput],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"IncompatibleTransferDestinationContainer","Sample(s) cannot be trasnferred to destination container(s) that contain IncompatibleMaterials:"},
			ExperimentTransfer[
				Model[Sample, StockSolution, "0.1% (v/v) Methanesulfonic Acid"],
				Model[Container, Vessel, "100 mL Glass Bottle"],
				50 Milliliter,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::IncompatibleTransferDestinationContainer],
				Message[Error::InvalidInput]
			}
		],
		Example[{Messages,"IncompatibleTransferIntermediateContainer","Sample(s) cannot be trasnferred to intermediate container(s) that contain IncompatibleMaterials:"},
			ExperimentTransfer[
				Model[Sample, StockSolution, "0.1% (v/v) Methanesulfonic Acid"],
				Model[Container, Vessel, "50mL Tube"],
				20 Milliliter,
				IntermediateContainer->	Model[Container, Vessel, "100 mL Glass Bottle"],
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::IncompatibleTransferIntermediateContainer],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"IncompatibleFTVTransferIntermediateContainer","Transfer involving FillToVolume to VolumetricFlask only allows Model[Container, Vessel, \"20mL Pyrex Beaker\"] as IntermediateContainer:"},
			ExperimentFillToVolume[
				Object[Sample,"Test water sample 1 in 100mL VolumetricFlask for ExperimentTransfer" <> $SessionUUID],
				100 Milliliter,
				Solvent->Model[Sample, "Milli-Q water"],
				IntermediateContainer -> Model[Container, Vessel, "100 mL Glass Bottle"],
				Output->Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::IncompatibleFTVTransferIntermediateContainer],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"IncompatibleFTVTransferIntermediateDecant","Transfer involving FillToVolume to VolumetricFlask only allows IntermediateDecant False:"},
			ExperimentFillToVolume[
				Object[Sample,"Test water sample 1 in 100mL VolumetricFlask for ExperimentTransfer" <> $SessionUUID],
				100 Milliliter,
				Solvent->Model[Sample, "Milli-Q water"],
				IntermediateDecant -> True,
				Output->Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::IncompatibleFTVTransferIntermediateDecant],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"IncompatibleFTVTransferInstrument","Transfer involving FillToVolume to VolumetricFlask only allows Instrument Null or GraduatedCylinder:"},
			ExperimentFillToVolume[
				Object[Sample,"Test water sample 1 in 100mL VolumetricFlask for ExperimentTransfer" <> $SessionUUID],
				100 Milliliter,
				Solvent->Model[Sample, "Milli-Q water"],
				Instrument ->  Model[Instrument,Pipette,"pipetus"],
				Output->Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::IncompatibleFTVTransferInstrument],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"IncompatibleFTVTransferFunnel","Transfer involving FillToVolume to VolumetricFlask does not allow Funnel Null:"},
			ExperimentFillToVolume[
				Object[Sample,"Test water sample 1 in 100mL VolumetricFlask for ExperimentTransfer" <> $SessionUUID],
				100 Milliliter,
				Solvent->Model[Sample, "Milli-Q water"],
				Funnel ->  Null,
				Output->Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::IncompatibleFTVTransferFunnel],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"TabletCrusherRequired","A pill crusher will be used if a transfer amount is given as a mass when SampleHandling->Itemized and Tablet -> True:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test itemized tablet sample 13 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Model[Container, Vessel, "50mL Tube"]
				},
				{
					2 Gram
				},
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Warning::TabletCrusherRequired]
			}
		],
		Example[{Messages,"BalanceCleaningMethodRequired","An error is thrown if a balance is required but BalanceCleaningMethod is set to Null:"},
			ExperimentTransfer[
				Model[Sample, "id:L8kPEjNLDDBP"], (* Model[Sample, "Caffeine"] *)
				Model[Container, Vessel, VolumetricFlask, "id:Y0lXejMredYv"], (* Model[Container, Vessel, VolumetricFlask, "250 mL Glass Volumetric Flask"] *)
				1 Gram,
				BalanceCleaningMethod->Null,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::BalanceCleaningMethodRequired],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"SachetMassSpecified","A warning is thrown if a mass is specified to transfer from a sachet sample:"},
			{options, simulation} = ExperimentTransfer[
				{Object[Sample, "Test itemized sachet sample 25 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]},
				{Model[Container, Vessel, "50mL Tube"]},
				{1 Gram},
				IncludeSachetPouch -> True,
				Output -> {Options, Simulation}
			];
			{sourceSample, destinationSample} = LookupLabeledObject[simulation, Lookup[options, {SourceLabel, DestinationLabel}]];
			{
				Lookup[options,{Instrument, IncludeSachetPouch, WeighingContainer}],
				Download[
					{sourceSample, destinationSample},
					{Mass, Count, Sachet, Composition},
					Simulation -> simulation
				]
			},
			{
				{ObjectP[Model[Item, Scissors]], True, Null(* We don't need a weighing container because the destination is empty *)},
				{
					{
						MassP, 19, True,
						{
							{EqualP[100 MassPercent], ObjectP[Model[Molecule, "Test sachet filler model for ExperimentTransfer" <> $SessionUUID]], _},
							{Null, ObjectP[Model[Material, "Test sachet pouch model for ExperimentTransfer"<> $SessionUUID]], _}
						}
					},
					{
						MassP, Null, False,
						{
							(* Default to not include the pouch *)
							{EqualP[100 MassPercent], ObjectP[Model[Molecule, "Test sachet filler model for ExperimentTransfer" <> $SessionUUID]], _},
							{Null, ObjectP[Model[Material, "Test sachet pouch model for ExperimentTransfer"<> $SessionUUID]], _}
						}
					}
				}
			},
			Messages :> {
				Message[Warning::SachetMassSpecified]
			},
			Variables :> {options, simulation, sourceSample, destinationSample}
		],
		Example[{Messages,"InvalidTransferTemperatureGloveBox","Transfer in the glove box cannot have a SourceTemperature:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test methanol sample 7 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					{1, Model[Container, Vessel, "50mL Tube"]}
				},
				{
					1 Milliliter
				},
				TransferEnvironment->Model[Instrument, HandlingStation, GloveBox, "id:6V0npvqD9156"],
				SourceTemperature -> 30 Celsius,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::InvalidTransferTemperatureGloveBox],
				Message[Warning::NonAnhydrousSample],
				Message[Error::InvalidTransferEnvironment],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages, "InvalidTransferSource", "Throw an error if transferring from an empty position:"},
			ExperimentTransfer[
				Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID],
				{1, Model[Container, Vessel, "50mL Tube"]},
				All
			],
			$Failed,
			Messages :> {
				Error::InvalidTransferSource,
				Error::InvalidInput
			}
		],
		Example[{Messages,"InvalidTransferTemperatureGloveBox","Transfer in the glove box cannot have a DestinationTemperature:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test methanol sample 7 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					{1, Model[Container, Vessel, "50mL Tube"]}
				},
				{
					1 Milliliter
				},
				TransferEnvironment->Model[Instrument, HandlingStation, GloveBox, "id:6V0npvqD9156"],
				DestinationTemperature -> 30 Celsius,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::InvalidTransferTemperatureGloveBox],
				Message[Warning::NonAnhydrousSample],
				Message[Error::InvalidTransferEnvironment],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"OveraspiratedTransfer","If the amount to be transferred is more than will be in the container/well at the time of the transfer, a warning is thrown:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test powder sample 5 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test powder sample 5 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					10 Gram,
					2 Gram
				},
				Output -> Options
			],
			KeyValuePattern[{
				Instrument -> ObjectP[Model[Item, Spatula]]|{ObjectP[Model[Item, Spatula]]..},
				Balance -> ObjectP[Model[Instrument, Balance]]
			}],
			Messages :> {
				Message[Warning::OveraspiratedTransfer]
			}
		],
		Test["Transfer using a container label multiple times can check OveraspirationTransfer error(part1):",
			ExperimentManualSamplePreparation[
				{
					LabelContainer[
						Label->"my container",
						Container->Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source->Model[Sample, "Milli-Q water"],
						Destination->"my container",
						Amount->1 Milliliter
					],
					Transfer[
						Source->"my container",
						Destination->Model[Container, Vessel, "2mL Tube"],
						Amount->1.5 Milliliter
					]
				},
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {Warning::OveraspiratedTransfer}
		],
		Test["Transfer using a container label multiple times can check OveraspirationTransfer error(part2):",
			ExperimentManualSamplePreparation[
				{
					LabelContainer[
						Label->"my container",
						Container->Model[Container, Vessel, "50mL Tube"]
					],
					Transfer[
						Source->Model[Sample, "Milli-Q water"],
						Destination->"my container",
						Amount->1 Milliliter
					],
					Transfer[
						Source->"my container",
						Destination->Model[Container, Vessel, "2mL Tube"],
						Amount->0.5 Milliliter
					],
					Transfer[
						Source->"my container",
						Destination->Model[Container, Vessel, "2mL Tube"],
						Amount->0.8 Milliliter
					]
				},
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {Warning::OveraspiratedTransfer}
		],
		Example[{Messages,"OverfilledTransfer","Using integer Model[Container] syntax, specify a transfer into the same container, this will cause an overfilled error:"},
			ExperimentTransfer[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{1, Model[Container, Vessel, "50mL Tube"]},
					{1, Model[Container, Vessel, "50mL Tube"]}
				},
				{
					40 Milliliter,
					40 Milliliter
				},
				Output -> Options
			],
			_List,
			Messages :> {
				Message[Error::OverfilledTransfer],
				Message[Error::InvalidInput]
			}
		],
		Example[{Messages,"OverfilledTransfer","Using integer Model[Container] syntax, specify transfers into different containers, not triggering an error:"},
			ExperimentTransfer[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{1, Model[Container, Vessel, "50mL Tube"]},
					Model[Container, Vessel, "50mL Tube"]
				},
				{
					40 Milliliter,
					40 Milliliter
				},
				Output -> Options
			],
			_List,
			Messages :> {}
		],
		Example[{Messages,"OverfilledTransfer","If the amount to be transferred is more than can be held in the destination container, an error is thrown:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], (* 25mL *)
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], (* 10mL *)
					Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID], (* 1mL *)
					Object[Sample, "Test water sample 4 in Hermetic Container for ExperimentTransfer" <> $SessionUUID], (* 1mL *)
					Model[Sample, "Milli-Q water"]
				},
				{
					Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					All,
					All,
					All,
					All,
					30 Milliliter
				},
				Output -> Options
			],
			_List,
			Messages :> {
				Message[Error::OverfilledTransfer],
				Message[Error::InvalidInput]
			}
		],
		Example[{Messages,"OverfilledTransfer","A message will not be thrown when transfers are done into different wells of a plate:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 4 in Hermetic Container for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container,Plate,"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Container,Plate,"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Container,Plate,"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Container,Plate,"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					500 Microliter,
					500 Microliter,
					500 Microliter,
					500 Microliter
				},
				DestinationWell -> {
					"A1",
					"A1",
					"A2",
					"A2"
				},
				Output -> Options
			],
			KeyValuePattern[{
				Instrument -> ObjectP/@{Model[Instrument, Pipette], Model[Instrument, Pipette], Model[Container, Syringe], Model[Container, Syringe]}
			}],
			Messages :> {}
		],
		Example[{Messages,"OverfilledTransfer","If the parent protocol of this transfer is a StockSolution, do not throw the OverfilledTransfer message:"},
			ExperimentTransfer[
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{1, Model[Container, Vessel, "50mL Tube"]},
					{1, Model[Container, Vessel, "50mL Tube"]}
				},
				{
					40 Milliliter,
					40 Milliliter
				},
				Output -> Options,
				ParentProtocol -> Object[Protocol, StockSolution, "Fake stock solution protocol for ExperimentTransfer" <> $SessionUUID]
			],
			_List
		],
		Example[{Messages,"InvalidDestinationHermetic","A message is thrown if trying to unseal a non-hermetic destination container:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container,Plate,"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					1 Milliliter
				},
				DestinationWell -> {
					"A1"
				},
				UnsealHermeticDestination -> True,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::InvalidDestinationHermetic],
				Message[Error::InvalidInput]
			}
		],
		Example[{Messages,"InvalidSourceHermetic","A message is thrown if trying to unseal a non-hermetic source container:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container,Plate,"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					1 Milliliter
				},
				DestinationWell -> {
					"A1"
				},
				UnsealHermeticSource -> True,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::InvalidSourceHermetic],
				Message[Error::InvalidInput]
			}
		],
		Example[{Messages,"InvalidSourceHermetic","A message is thrown if trying to backfill a non-hermetic source container:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container,Plate,"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					1 Milliliter
				},
				DestinationWell -> {
					"A1"
				},
				BackfillGas -> Argon,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::IncorrectlySpecifiedTransferOptions],
				Message[Error::InvalidSourceHermetic],
				Message[Error::InvalidInput],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"DispenseMixOptions","A message is thrown if only some of the dispense mix options are set:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container,Plate,"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					1 Milliliter
				},
				DestinationWell -> {
					"A1"
				},
				DispenseMix->True,
				DispenseMixType->Null,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::DispenseMixOptions],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"AspirationMixOptions","A message is thrown if only some of the aspiration mix options are set:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container,Plate,"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					1 Milliliter
				},
				DestinationWell -> {
					"A1"
				},
				AspirationMix->True,
				NumberOfAspirationMixes->Null,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::AspirationMixOptions],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"TipRinseOptions","A message is thrown if only some of the tip rinse options are set:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container,Plate,"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					1 Milliliter
				},
				DestinationWell -> {
					"A1"
				},
				TipRinse->True,
				TipRinseSolution->Null,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::TipRinseOptions],
				Message[Error::InvalidOption]
			}
		],
		Example[{Options, Instrument, "Appropriate spatula is resolved based on mass to be transferred, instrument TransferVolume and destination Aperture:"},
			Lookup[ExperimentTransfer[
				Model[Sample, "id:L8kPEjNLDDBP"],(*Model[Sample, "Caffeine"]*)
				Model[Container, Vessel, VolumetricFlask, "id:Y0lXejMredYv"],(*Model[Container, Vessel, VolumetricFlask, "250 mL Glass Volumetric Flask"]*)
				500 Milligram,
				QuantitativeTransfer -> True,
				Output -> Options
			],Instrument],
			ObjectP[Model[Item, Spatula, "id:D8KAEv5YPd8R"]] (*Model[Item, Spatula, "Disposable Polypropylene Scoop and Spatula, 31 cm, Individual"]*)
		],
		(* Needle resolver tests *)
		Test["Disposable blunt-tip needles are defaulted to if a syringe is specified and neither of the source and destination are hermetic:",
			Download[
				ExperimentTransfer[
					{
						Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
					},
					{
						Object[Container,Plate,"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]
					},
					{
						1 Milliliter
					},
					Instrument -> Model[Container, Syringe, "id:P5ZnEj4P88P0"]
				],
				OutputUnitOperations[[1]][Needle][{Bevel, Reusable}]
			],
			{{EqualP[Quantity[90., "AngularDegrees"]], False}}
		],
		Test["Sharp needles are used and disposable ones are favored, if a syringe is specified and the source and destination are hermetic that are specified to not get unsealed:",
			Download[
				ExperimentTransfer[
					Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 4 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
					500 Microliter,
					Instrument -> Model[Container, Syringe, "id:P5ZnEj4P88P0"]
				],
				OutputUnitOperations[[1]][Needle][{Bevel, Reusable}]
			],
			{{LessP[Quantity[90., "AngularDegrees"]], False}}
		],
		Example[{Options,{BalancePreCleaningMethod,BalanceCleaningMethod},"BalancePreCleaning and BalanceCleaningMethod is properly resolved:"},
			Lookup[
				ExperimentTransfer[
					Model[Sample, "id:L8kPEjNLDDBP"], (* Model[Sample, "Caffeine"] *)
					Model[Container, Vessel, VolumetricFlask, "id:Y0lXejMredYv"], (* Model[Container, Vessel, VolumetricFlask, "250 mL Glass Volumetric Flask"] *)
					1 Gram,
					Output -> Options
				],
				{BalancePreCleaningMethod,BalanceCleaningMethod}
			],
			{None, Wet}
		],
		Example[{Messages, "QuantitativeTransferRecommended", "A warning to suggest QuantitativeTransfer is thrown when transfer amount is less than 50 milligrams:"},
			ExperimentTransfer[
				{Model[Sample, "Acetylsalicylic Acid (Aspirin)"]},
				(* Use a VolumetricFlask to force it to use a weighing container. If using a 50 mL tube, we will actually use it directly on balance *)
				{Model[Container, Vessel, VolumetricFlask, "id:n0k9mGOLdwjr"]},
				{12 Milligram},
				QuantitativeTransfer -> False,
				Output-> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Warning::QuantitativeTransferRecommended]
			}
		],
		Example[{Messages,"ConflictingQuantitativeTransferOptions","A message is thrown if only some of the quantitative transfer options are set:"},
			ExperimentTransfer[
				{
					Model[Sample, "id:L8kPEjNLDDBP"] (* Model[Sample,"Caffeine"] *)
				},
				{
					Model[Container, Vessel, VolumetricFlask, "id:Y0lXejMredYv"] (*Model[Container, Vessel, VolumetricFlask, "250 mL Glass Volumetric Flask"]*)
				},
				{
					20 Gram
				},
				QuantitativeTransfer->True,
				NumberOfQuantitativeTransferWashes->Null,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::ConflictingQuantitativeTransferOptions],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"NoCompatibleWeighingContainer","A message is thrown if QuantitativeTransfer is True but no compatible WeighingContainer is found (eg IncompatibleMaterials conflict):"},
			ExperimentTransfer[
				{Model[Sample, "Test solid model sample for ExperimentTransfer"<>$SessionUUID]},
				{Model[Container, Vessel, VolumetricFlask, "25 mL Glass Volumetric Flask"]},
				{60 Milligram},
				QuantitativeTransfer -> True,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::NoCompatibleWeighingContainer],
				Message[Error::NoCompatibleFunnel],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"ConflictingQuantitativeTransferOptions","A message is thrown if Preparation is Robotic:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container,Plate,"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					0.5 Milliliter
				},
				DestinationWell -> {
					"A1"
				},
				QuantitativeTransfer -> True,

				Preparation -> Robotic,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::ConflictingQuantitativeTransferOptions],
				Message[Error::ConflictingUnitOperationMethodRequirements],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages, "InvalidQuantitativeTransferWashVolume", "A message is thrown if QuantitativeTransferVolume is greater than 5 Milliliter  since this is the max volume a Micropipette type can hold:"},
			ExperimentTransfer[
				{Model[Sample, "Acetylsalicylic Acid (Aspirin)"]},
				{Model[Container, Vessel, "50mL Tube"]},
				{60 Milligram},
				QuantitativeTransfer -> True,
				QuantitativeTransferWashSolution -> Model[Sample, "Milli-Q water"],
				QuantitativeTransferWashVolume -> 15 Milliliter,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::ConflictingQuantitativeTransferOptions],
				Message[Error::InvalidQuantitativeTransferWashVolume],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages, "IncompatibleQuantitativeTransferWashTips", "A message is thrown if an incompatible QuantitativeTransferWashTips is specified:"},
			ExperimentTransfer[
				{Model[Sample, "Acetylsalicylic Acid (Aspirin)"]},
				{Model[Container, Vessel, "50mL Tube"]},
				{60 Milligram},
				QuantitativeTransfer -> True,
				QuantitativeTransferWashSolution -> Model[Sample, "Milli-Q water"],
				QuantitativeTransferWashTips -> Model[Item, Tips, "5 mL glass barrier serological pipets, sterile"],
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::IncompatibleQuantitativeTransferWashTips],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages, "IncompatibleQuantitativeTransferWashInstrument", "A message is thrown if an incompatible QuantitativeTransferWashInstrument is specified:"},
			ExperimentTransfer[
				{Model[Sample, "Acetylsalicylic Acid (Aspirin)"]},
				{Model[Container, Vessel, "50mL Tube"]},
				{60 Milligram},
				QuantitativeTransfer -> True,
				QuantitativeTransferWashSolution -> Model[Sample, "Milli-Q water"],
				QuantitativeTransferWashInstrument -> Model[Instrument, Pipette, "pipetus"],
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::IncompatibleQuantitativeTransferWashInstrument],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages, "InvalidNumberOfQuantitativeTransferWashes", "If NumberOfQuantitativeTransferWashes is less than 3 when there is a Funnel used for QuantitativeTransfer, throw an error:"},
			ExperimentTransfer[
				{Model[Sample, "Acetylsalicylic Acid (Aspirin)"]},
				{Model[Container, Vessel, "50mL Tube"]},
				{60 Milligram},
				QuantitativeTransfer -> True,
				NumberOfQuantitativeTransferWashes->2,
				WeighingContainer->Model[Item, WeighBoat, "id:eGakldaxb8Lz"], (*Model[Item, WeighBoat, "Weigh boats, pour spout"]*)
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::InvalidNumberOfQuantitativeTransferWashes],
				Message[Error::InvalidOption]
			}
		],
		Example[{Options, WeighingContainer, "WeighingContainer is automatically resolved if QuantitativeTransfer is set to True:"},
			ExperimentTransfer[
				{Model[Sample, "Acetylsalicylic Acid (Aspirin)"]},
				{Model[Container, Vessel, "50mL Tube"]},
				{10 Milligram},
				QuantitativeTransfer -> True,
				QuantitativeTransferWashSolution -> Model[Sample, "Milli-Q water"],
				QuantitativeTransferWashVolume -> 0.2 Milliliter,
				NumberOfQuantitativeTransferWashes -> 2,
				QuantitativeTransferWashTips -> Model[Item, Tips, "200 uL wide-bore tips, non-sterile"],
				Output -> Options
			],
			KeyValuePattern[{
				WeighingContainer -> ObjectP[Model[Item, WeighBoat]]
			}]
		],
		Example[{Messages,"RequiredWeighingContainerNonEmptyDestination","A message is thrown if the weighing container is set to Null, but the destination position will be non-empty at the time of transfer:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test powder sample 5 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test powder sample 5 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container,Plate,"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Container,Plate,"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					.1 Gram,
					.1 Gram
				},
				DestinationWell -> {
					"A1",
					"A1"
				},
				WeighingContainer->Null,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::RequiredWeighingContainerNonEmptyDestination],
				Message[Error::InvalidOption],
				Message[Error::InvalidInput]
			}
		],
		Example[{Messages,"TipsOrNeedleLiquidLevel","A message is thrown if a tip is given that will not reach the bottom of the source's container:"},
			ExperimentTransfer[
				{
					Model[Sample, "Milli-Q water"],
					{1, Model[Container, Vessel, "Amber Glass Bottle 4 L"]}
				},
				{
					{1, Model[Container, Vessel, "Amber Glass Bottle 4 L"]},
					{2, Model[Container, Vessel, "Amber Glass Bottle 4 L"]}
				},
				{
					100 Milliliter,
					200 Microliter
				},
				IntermediateDecant->False,
				Tips -> {
					Automatic,
					Model[Item, Tips, "id:O81aEBZDpVzN"]
				},
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::TipsOrNeedleLiquidLevel],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"InvalidInstrumentCapacity","A message is thrown if a syringe is requested to transfer a solid:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test powder sample 5 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container,Vessel,"Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					1 Gram
				},
				Instrument -> Model[Container, Syringe, "id:P5ZnEj4P88P0"],
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::IncorrectlySpecifiedTransferOptions],
				Message[Error::InvalidInstrumentCapacity],
				Message[Error::InvalidInput],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"InvalidInstrumentCapacity","A message is thrown if a spatula is requested to transfer a liquid:"},
			ExperimentTransfer[
				{
					Object[Container,Vessel,"Test 50mL Tube 1 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container,Vessel,"Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					1 Gram
				},
				Instrument -> Search[Model[Item, Spatula]][[1]],
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::InvalidInstrumentCapacity],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"SpatulaCapacityWarning","A message is thrown if the capacity of the spatula requested is not ideal to transfer the desired amount:"},
			ExperimentTransfer[
				Model[Sample, "id:L8kPEjNLDDBP"], (*Model[Sample, "Caffeine"]*)
				Model[Container, Vessel, VolumetricFlask, "id:Y0lXejMredYv"],(*Model[Container, Vessel, VolumetricFlask, "250 mL Glass Volumetric Flask"]*)
				500 Milligram,
				Instrument -> Model[Item, Spatula, "id:eGakldaVO16x"], (*Micro Spatulas, Color-Coded Handles*)
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Warning::SpatulaCapacityWarning]
			}
		],
		Example[{Messages,"IncompatibleSpatulaWidth","A message is thrown if the width of the spatula requested is does not fit into the destination:"},
			ExperimentTransfer[
				Model[Sample, "id:L8kPEjNLDDBP"], (*Model[Sample, "Caffeine"]*)
				Model[Container, Vessel, "id:AEqRl954GGvv"],(*Model[Container, Vessel, "HPLC vial (flat bottom)"]*)
				500 Milligram,
				Instrument -> Model[Item, Spatula, "Disposable Polypropylene Scoop and Spatula, 31 cm, Individual"],(* Model[Item, Spatula, "Disposable Spatulas, 31 cm"]*)
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::IncompatibleSpatulaWidth],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"ToleranceSpecifiedForAllTransfer","A message is thrown if a tolerance is specified for an Amount->All transfer:"},
			ExperimentTransfer[
				{
					Object[Container,Vessel,"Test 50mL Tube 1 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container,Vessel,"Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					All
				},
				Tolerance -> 0.01 Gram,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::ToleranceSpecifiedForAllTransfer],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"InvalidTransferWellSpecification","A message is thrown if a bogus well is given:"},
			ExperimentTransfer[
				{
					Object[Container,Vessel,"Test 50mL Tube 1 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container,Vessel,"Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					All
				},
				DestinationWell->"A2",
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::InvalidTransferWellSpecification],
				Message[Error::InvalidInput]
			}
		],
		Example[{Messages,"IncorrectlySpecifiedTransferOptions","A message is thrown if a bogus well is given:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test powder sample 5 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container,Vessel,"Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					All
				},
				Instrument -> Search[Model[Item, Spatula]][[1]],
				Balance->Null,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::IncorrectlySpecifiedTransferOptions],
				Message[Error::InvalidInput],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages, "ReversePipettingSampleVolume", "When ReversePipetting is set to True, a message is thrown to warn that additional source sample volume will be aspirated and discarded during the transfer:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Model[Container, Vessel, "2mL Tube"]
				},
				{
					60 Microliter
				},
				ReversePipetting -> True,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Warning::ReversePipettingSampleVolume]
			}
		],
		Example[{Messages, "AspirationMixVolumeOutOfTipRange", "When AspirationMixVolume exceeds the MaxVolume of Tips, an error will be thrown."},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Model[Container, Vessel, "2mL Tube"]
				},
				{
					100 Microliter
				},
				Tips -> Model[Item, Tips, "id:O81aEBZDpVzN"],
				AspirationMix -> True,
				AspirationMixVolume -> 500 Microliter
			],
			$Failed,
			Messages :> {
				Message[Error::InvalidOption],
				Message[Error::AspirationMixVolumeOutOfTipRange]
			}
		],
		Example[{Messages, "AspirationMixVolumeOutOfTipRange", "When AspirationMixVolume is below the MinVolume of Tips, an error will be thrown."},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Model[Container, Vessel, "2mL Tube"]
				},
				{
					100 Microliter
				},
				Tips -> Model[Item, Tips, "id:O81aEBZDpVzN"],
				AspirationMix -> True,
				AspirationMixVolume -> 15 Microliter
			],
			$Failed,
			Messages :> {
				Message[Error::InvalidOption],
				Message[Error::AspirationMixVolumeOutOfTipRange]
			}
		],
		Example[{Messages, "DispenseMixVolumeOutOfTipRange", "When DispenseMixVolume exceeds the MaxVolume of Tips, an error will be thrown."},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Model[Container, Vessel, "2mL Tube"]
				},
				{
					100 Microliter
				},
				Tips -> Model[Item, Tips, "id:O81aEBZDpVzN"],
				DispenseMix -> True,
				DispenseMixVolume -> 500 Microliter
			],
			$Failed,
			Messages :> {
				Message[Error::InvalidOption],
				Message[Error::DispenseMixVolumeOutOfTipRange]
			}
		],
		Example[{Messages, "DispenseMixVolumeOutOfTipRange", "When DispenseMixVolume is below the MinVolume of Tips, an error will be thrown."},
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Model[Container, Vessel, "2mL Tube"]
				},
				{
					100 Microliter
				},
				Tips -> Model[Item, Tips, "id:O81aEBZDpVzN"],
				DispenseMix -> True,
				DispenseMixVolume -> 15 Microliter
			],
			$Failed,
			Messages :> {
				Message[Error::InvalidOption],
				Message[Error::DispenseMixVolumeOutOfTipRange]
			}
		],
		(* ExperimentTransfer should be modified for this test to work *)
		(*Example[{Messages,"IrretrievableSamples","An error is thrown if a irretrievable sample is given as an input to be transferred:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test sample in a capillary for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Container,Vessel,"Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID]
				},
				{
					5 Milligram
				}
			],
			$Failed,
			Messages :> {
				Message[Error::IrretrievableSamples],
				Message[Error::InvalidInput]
			}
		],*)
		Test["If the source and amount are given as singleton values, but destination is listed, this should work:",
			ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				{
					Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID]
				},
				0.5 Milliliter,
				DestinationWell -> {"A1", "A2", "A3"},
				Output -> Options
			],
			{__Rule}
		],
		Test["We should pour if transferring All and we're in a vessel:",
			ExperimentTransfer[
				Object[Sample, "Test Null Volume sample 23 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				PreferredContainer[50 Milliliter],
				All,
				Output -> Options
			],
			KeyValuePattern[{
				Instrument->Null
			}]
		],
		Test["We should NOT pour if transferring All and we're in a vessel but SterileTechnique -> True:",
			ExperimentTransfer[
				Object[Sample, "Test Null Volume sample 23 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				PreferredContainer[50 Milliliter],
				All,
				SterileTechnique -> True,
				Output -> Options
			],
			KeyValuePattern[{
				Instrument -> ObjectP[Model[Instrument, Pipette]],
				Tips -> ObjectP[Model[Item, Tips]]
			}]
		],
		Test["We shouldn't pour if transferring All and we're in a plate:",
			ExperimentTransfer[
				Object[Sample, "Test Null Volume sample 24 in DWP for ExperimentTransfer" <> $SessionUUID],
				PreferredContainer[2 Milliliter],
				All,
				Output -> Options
			],
			KeyValuePattern[{
				Instrument->ObjectP[Model[Instrument, Pipette]]
			}]
		],
		Example[{Additional, "Automatically aspirates/dispenses from the corner of the well if the plate is tilted:"},
			Module[{protocol},
				protocol=ExperimentRoboticCellPreparation[
					{
						LabelContainer[
							Label->"6plate",
							Container->Model[Container,Plate,"Nunc Non-Treated 6-well Plate"]
						],
						Transfer[
							Source->Model[Sample, "Milli-Q water"],
							Destination->"6plate",
							DestinationWell->"A1",
							Amount->1 Milliliter,
							DispenseAngle->10 AngularDegree
						]
					},
					OptimizeUnitOperations->False
				];

				Download[protocol, OutputUnitOperations[[2]][DispensePositionOffset]]
			],
			{_Coordinate..}
		],
		Example[{Additional, "Automatically sets AspirationAngle to DispenseAngle when the container is the same:"},
			Module[{protocol},
				protocol=ExperimentRoboticCellPreparation[
					{
						LabelContainer[
							Label->"6plate",
							Container->Model[Container,Plate,"Nunc Non-Treated 6-well Plate"]
						],
						Transfer[
							Source->Model[Sample, "Milli-Q water"],
							Destination->"6plate",
							DestinationWell->"A1",
							Amount->1 Milliliter,
							DispenseAngle->10 AngularDegree
						],
						Transfer[
							Source->"6plate",
							SourceWell->"A1",
							Destination->"6plate",
							DestinationWell->"B1",
							Amount->1 Milliliter,
							DispenseAngle->10 AngularDegree
						]
					},
					OptimizeUnitOperations->False
				];

				Download[protocol, OutputUnitOperations[[3]][AspirationAngle]]
			],
			{Quantity[10., "AngularDegrees"]..}
		],
		Example[{Additional, "Will group two transfers together in the same group if the plates are at the same tilting angles:"},
			Module[{protocol},
				protocol=ExperimentRoboticCellPreparation[
					{
						LabelContainer[
							Label->"96plate",
							Container->Model[Container, Plate, "96-well 2mL Deep Well Plate"]
						],
						LabelContainer[
							Label->"6plate",
							Container->Model[Container,Plate,"Nunc Non-Treated 6-well Plate"]
						],
						Transfer[
							Source->Model[Sample, "Milli-Q water"],
							Destination->{
								"96plate",
								"6plate"
							},
							DestinationWell->{
								"A1",
								"B1"
							},
							Amount->1 Milliliter
						],
						Transfer[
							Source->{
								"96plate",
								"6plate"
							},
							SourceWell->{
								"A1",
								"B1"
							},
							Destination->{
								"6plate",
								"6plate"
							},
							DestinationWell->{
								"A1",
								"B2"
							},
							Amount->1Milliliter,
							AspirationAngle->{
								Automatic,
								10 AngularDegree
							},
							DispenseAngle->10AngularDegree
						]
					},
					OptimizeUnitOperations->False
				];

				MatchQ[
					Download[protocol, OutputUnitOperations[[4]][MultichannelTransferName]][[1]],
					Download[protocol, OutputUnitOperations[[4]][MultichannelTransferName]][[2]]
				]
			],
			True
		],
		Example[{Additional, "Multiple transfer groups will be made if the same container is tilted to different angles:"},
			Module[{protocol},
				protocol=ExperimentRoboticCellPreparation[
					{
						LabelContainer[
							Label->"96plate",
							Container->Model[Container, Plate, "96-well 2mL Deep Well Plate"]
						],
						LabelContainer[
							Label->"6plate",
							Container->Model[Container,Plate,"Nunc Non-Treated 6-well Plate"]
						],
						Transfer[
							Source->Model[Sample, "Milli-Q water"],
							Destination->{
								"96plate",
								"6plate"
							},
							DestinationWell->{
								"A1",
								"B1"
							},
							Amount->1 Milliliter
						],
						Transfer[
							Source->{
								"96plate",
								"6plate",
								"96plate"
							},
							SourceWell->{
								"A1",
								"B1",
								"A1"
							},
							Destination->{
								"6plate",
								"6plate",
								"6plate"
							},
							DestinationWell->{
								"A1",
								"B2",
								"B1"
							},
							Amount->100 Microliter,
							AspirationAngle->{
								Automatic,
								10AngularDegree,
								Automatic
							},
							DispenseAngle->{
								10AngularDegree,
								10AngularDegree,
								5AngularDegree
							}
						]
					},
					OptimizeUnitOperations->False
				];

				MatchQ[
					Download[protocol, OutputUnitOperations[[4]][MultichannelTransferName]],
					{
						x_String,
						x_String,
						y_String
					}
				]
			],
			True
		],
		Example[{Messages, "MultiProbeHeadDimension","Return an error if the MultiProbeHead can not be completed because the wells are not a rectangle:"},
			ExperimentTransfer[
				ConstantArray[Object[Sample, "Test water sample in a reservoir for ExperimentTransfer" <> $SessionUUID], 12],
				{#,Object[Container,Plate, "Test 96-DWP 3 for ExperimentTransfer" <> $SessionUUID]}&/@{
					"A1", "A2", "A3", "A4", "A5", "A6",
					"B6", "B7", "B8", "B9", "B10", "B11"},
				ConstantArray[100 Microliter, 12],
				Preparation->Robotic,
				DeviceChannel -> ConstantArray[MultiProbeHead, 12],
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Error::MultiProbeHeadDimension,
				Error::InvalidOption
			}
		],
		Example[{Messages, "MultiProbeHeadDispenseLLD","Return an error if the MultiProbeHead can not be completed because the DispensePosition was set to LiquidLevel:"},
			ExperimentTransfer[
				ConstantArray[Object[Sample, "Test water sample in a reservoir for ExperimentTransfer" <> $SessionUUID], 24],
				{#,Object[Container,Plate, "Test 96-DWP 3 for ExperimentTransfer" <> $SessionUUID]}&/@{
					"A1", "A2", "A3", "A4", "A5", "A6", "A7", "A8", "A9", "A10", "A11", "A12",
					"B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9", "B10", "B11", "B12"},
				ConstantArray[100 Microliter, 24],
				Preparation->Robotic,
				DeviceChannel -> ConstantArray[MultiProbeHead, 24],
				DispensePosition->LiquidLevel,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Error::MultiProbeHeadDispenseLLD,
				Error::InvalidOption
			}
		],
		Example[{Messages, "ConflictingUnitOperationMethodRequirements","Return an error if the plate used in a robotic protocol does not have LiquidHandlerPrefix:"},
			ExperimentTransfer[
				Model[Sample, "Milli-Q water"],
				Model[Container, Plate, "Test plate without LiquidHandlerPrefix for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter,
				Preparation->Robotic
			],
			$Failed,
			Messages :> {
				Error::ConflictingUnitOperationMethodRequirements,
				Error::InvalidOption
			}
		],
		Example[{Messages, "DiscardedSamples", "Return an error early if any user-specified objects have the Status of Discarded. No option resolving will be attempted:"},
			ExperimentTransfer[
				Model[Sample, "Milli-Q water"],
				Object[Container,Vessel,"Test discarded 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				1 Milliliter
			],
			$Failed,
			Messages :> {
				Error::DiscardedSamples,
				Error::InvalidInput
			}
		],
		Example[{Additional, MultiProbeHead, "Robotic Transfer automatically recognizes MultiProbeHead transfers of the full plate (part 1):"},
			ExperimentTransfer[
				{#,Object[Container, Plate, "Test 96-DWP 3 for ExperimentTransfer"<>$SessionUUID]}&/@Flatten@AllWells[],
				{#,Object[Container,Plate,"Test 96-DWP 4 for ExperimentTransfer"<>$SessionUUID]}&/@Flatten@AllWells[],
				ConstantArray[50 Microliter, 96],
				Upload->False,
				Preparation->Robotic
			],
			KeyValuePattern[{
				Replace[DeviceChannel]->{MultiProbeHead..},
				Replace[MultiProbeHeadNumberOfRows]->{(8)..},
				Replace[MultiProbeHeadNumberOfColumns]->{(12)..},
				Replace[MultiProbeAspirationOffsetRows]->{(0)..},
				Replace[MultiProbeAspirationOffsetColumns]->{(0)..},
				Replace[MultiProbeDispenseOffsetRows]->{(0)..},
				Replace[MultiProbeDispenseOffsetColumns]->{(0)..}
			}]
		],
		Example[{Additional,MultiProbeHead,"Robotic Transfer automatically recognizes MultiProbeHead transfers of the full plate (part 2):"},
			ExperimentTransfer[
				Join[
					{#,Object[Container,Plate,"Test 96-DWP 3 for ExperimentTransfer"<>$SessionUUID]}&/@Flatten[AllWells[][[2;;7,2;;10]]],
					{#,Object[Container,Plate,"Test 96-DWP 3 for ExperimentTransfer"<>$SessionUUID]}&/@Most[Flatten[AllWells[][[;;,1;;6]]]]
				],
				Join[
					{#,Object[Container,Plate,"Test 96-DWP 4 for ExperimentTransfer"<>$SessionUUID]}&/@Flatten[AllWells[][[3;;8,3;;11]]],
					{#,Object[Container,Plate,"Test 96-DWP 5 for ExperimentTransfer"<>$SessionUUID]}&/@Most[Flatten[AllWells[][[;;,1;;6]]]]
				],
				ConstantArray[50 Microliter,101],
				Upload->False,
				Preparation->Robotic
			],
			KeyValuePattern[{
				Replace[DeviceChannel]->Join[ConstantArray[MultiProbeHead,54],ConstantArray[Except[MultiProbeHead],47]],
				Replace[MultiProbeHeadNumberOfRows]->Join[
					ConstantArray[6,54],
					ConstantArray[Null,47]
				],
				Replace[MultiProbeHeadNumberOfColumns]->Join[
					ConstantArray[9,54],
					ConstantArray[Null,47]
				],
				Replace[MultiProbeAspirationOffsetRows]->Join[
					ConstantArray[-1,54],
					ConstantArray[Null,47]
				],
				Replace[MultiProbeAspirationOffsetColumns]->Join[
					ConstantArray[-2,54],
					ConstantArray[Null,47]
				],
				Replace[MultiProbeDispenseOffsetRows]->Join[
					ConstantArray[0,54],
					ConstantArray[Null,47]
				],
				Replace[MultiProbeDispenseOffsetColumns]->Join[
					ConstantArray[-1,54],
					ConstantArray[Null,47]
				]
			}]
		],
		Test["Split the transfer groups to make sure the DeviceChannel is in ascending order in each group:",
			Module[{protocol,transferUO,multichannelTransferNames},
				protocol=ExperimentTransfer[
					ConstantArray[Model[Sample,"Milli-Q water"],3],
					ConstantArray[Model[Container, Plate, "96-well 2mL Deep Well Plate"],3],
					ConstantArray[300Microliter,3],
					DestinationWell->{"A1","B1","C1"},
					DeviceChannel->{SingleProbe5,SingleProbe7,SingleProbe4},
					Preparation->Robotic
				];
				transferUO=protocol[OutputUnitOperations][[1]];
				multichannelTransferNames=Download[transferUO,MultichannelTransferName];
				{
					Download[transferUO,DeviceChannel],
					MatchQ[multichannelTransferNames[[1]],multichannelTransferNames[[2]]],
					MatchQ[multichannelTransferNames[[1]],multichannelTransferNames[[3]]]
				}
			],
			{
				{SingleProbe5, SingleProbe7, SingleProbe4},
				True,
				False
			}
		],
		Test["If MultichannelTransfer is True and Tips are specified, resolve to a pipette that is compatible with the tips:",
			options = ExperimentTransfer[
				{
					Object[Sample, "Test water sample 16 in B1 of DWP for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 17 in C1 of DWP for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 18 in D1 of DWP for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Sample, "Test water sample 16 in B1 of DWP for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 17 in C1 of DWP for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 18 in D1 of DWP for ExperimentTransfer" <> $SessionUUID]
				},
				{200 Microliter, 200 Microliter, 200 Microliter},
				Tips -> {Model[Item,Tips,"200 uL tips, non-sterile"], Model[Item,Tips,"200 uL tips, non-sterile"], Model[Item,Tips,"200 uL tips, non-sterile"]},
				MultichannelTransfer -> True,
				Preparation -> Manual,
				Output -> Options
			];
			Download[Lookup[options, Instrument], TipConnectionType],
			P200
		],
		Test["If MultichannelTransfer is False and Tips are specified, resolve to a pipette that is compatible with the tips:",
			options = ExperimentTransfer[
				{
					Object[Sample, "Test water sample 16 in B1 of DWP for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 17 in C1 of DWP for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 18 in D1 of DWP for ExperimentTransfer" <> $SessionUUID]
				},
				{
					Object[Sample, "Test water sample 16 in B1 of DWP for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 17 in C1 of DWP for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 18 in D1 of DWP for ExperimentTransfer" <> $SessionUUID]
				},
				{200 Microliter, 200 Microliter, 200 Microliter},
				Tips -> {Model[Item,Tips,"1000 uL tips, non-sterile"], Model[Item,Tips,"1000 uL tips, non-sterile"], Model[Item,Tips,"1000 uL tips, non-sterile"]},
				MultichannelTransfer -> False,
				NumberOfAspirationMixes -> 10,
				Preparation -> Manual,
				Output -> Options
			];
			Download[Lookup[options, Instrument], TipConnectionType],
			P1000
		],
		Test["LivingDestination option defaults to True:",
			protocol = ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				PreferredContainer[2 Milliliter],
				1 Milliliter,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];

			Download[protocol,LivingDestinations],
			{True},
			Variables :> {protocol}
		],
		Test["LivingDestination Option can be set:",
			protocol = ExperimentTransfer[
				Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				PreferredContainer[2 Milliliter],
				1 Milliliter,
				LivingDestination -> True,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];

			Download[protocol,LivingDestinations],
			{True},
			Variables :> {protocol}
		],
		Test["LivingDestination Option can be set for multiple samples:",
			protocol = ExperimentTransfer[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
				},
				{
					PreferredContainer[2 Milliliter],
					PreferredContainer[2 Milliliter]
				},
				{
					1 Milliliter,
					1 Milliliter
				},
				LivingDestination -> {True,False},
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];

			Download[protocol,LivingDestinations],
			{True,False},
			Variables :> {protocol}
		],
		(* Resource combination & Split *)
		Test["Combines the resources for the same Model[Sample] by default:",
			Module[
				{protocol,requiredObjects,resource},
				protocol = ExperimentTransfer[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						900 Microliter,
						900 Microliter
					},
					Preparation -> Robotic
				];
				requiredObjects = Download[protocol,RequiredObjects];
				resource = FirstCase[Download[protocol,RequiredResources],{_,RequiredObjects,1,_}][[1]];
				{
					Count[requiredObjects, ObjectP[Model[Sample, "Milli-Q water"]]],
					Download[resource,Amount],
					Download[resource,ContainerModels]
				}
			],
			{1,GreaterEqualP[1.8Milliliter],{ObjectP[Model[Container, Vessel, "50mL Tube"]]}}
		],
		Example[{Additional,"If the total required volume of a robotic Model[Sample] resource is larger than the maximum of a robotic reservoir, require multiple resources:"},
			Module[
				{protocol,requiredObjects,waterPositions,resources},
				protocol=ExperimentRoboticSamplePreparation[
					{
						LabelContainer[Label->{"plate1", "plate2"},Container ->Model[Container, Plate, "96-well 2mL Deep Well Plate"]],
						Transfer[Source->Model[Sample, "Milli-Q water"],Destination->"plate1",DestinationWell->Flatten[AllWells[]],Amount->970Microliter],
						Transfer[Source->Model[Sample, "Milli-Q water"],Destination->"plate2",DestinationWell->Flatten[AllWells[]],Amount->970Microliter]
					}
				];
				requiredObjects = Download[protocol,RequiredObjects];
				waterPositions = Flatten[Position[Download[requiredObjects,Object],Download[Model[Sample, "Milli-Q water"], Object]]];
				resources = Cases[Download[protocol,RequiredResources],{_,RequiredObjects,Alternatives@@waterPositions,_}][[All,1]];
				{
					Count[requiredObjects, ObjectP[Model[Sample, "Milli-Q water"]]],
					Download[resources,Amount],
					Download[resources,ContainerModels]
				}
			],
			{
				2,
				(* One of the resources should be >160 mL in a reservoir *)
				{___,GreaterP[160Milliliter],___},
				{___,{LinkP[Model[Container, Plate, "id:54n6evLWKqbG"]]},___}
			},
			TimeConstraint -> 3600
		],
		Example[{Additional,"If the total required volume of a manual Model[Sample] resource is larger than the maximum of a 20L carboy, require multiple resources:"},
			Module[
				{protocol,requiredObjects,waterPositions,allUOSourceResources,resources},
				protocol=ExperimentTransfer[
					ConstantArray[Model[Sample, "Milli-Q water"],8],
					ConstantArray[Model[Container, Vessel, "Amber Glass Bottle 4 L"],8],
					(* We will have to do weight water transfer since we want to make sure we create water resource, instead of directly using water purifier *)
					ConstantArray[3Kilogram,8],
					ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
				];
				requiredObjects = Download[protocol,RequiredObjects];
				waterPositions = Flatten[Position[Download[requiredObjects,Object],Download[Model[Sample, "Milli-Q water"], Object]]];
				allUOSourceResources = Download[(FirstCase[#,{___,SourceLink,___}]&/@Download[protocol,BatchedUnitOperations[RequiredResources]])[[All,1]],Object];
				resources = Cases[Download[protocol,RequiredResources],{_,RequiredObjects,Alternatives@@waterPositions,_}][[All,1]];
				{
					Count[requiredObjects, ObjectP[Model[Sample, "Milli-Q water"]]],
					Download[resources,Amount],
					Download[resources,ContainerModels],
					Count[allUOSourceResources,#]&/@Download[resources,Object]
				}
			],
			{
				2,
				(* One of the resources should 18 liter * 1.1 in a 20L carboy and the other one should be 6 Liter * 1.1 in a 10L carboy *)
				{RangeP[18Liter,20Liter],RangeP[6Liter,8Liter]}|{RangeP[6Liter,8Liter],RangeP[18Liter,20Liter]},
				{{LinkP[Model[Container, Vessel, "id:aXRlGnZmOOB9"]]}, {LinkP[Model[Container, Vessel, "id:3em6Zv9NjjkY"]]}}|{{LinkP[Model[Container, Vessel, "id:3em6Zv9NjjkY"]]},{LinkP[Model[Container, Vessel, "id:aXRlGnZmOOB9"]]}},
				{6,2}|{2,6}
			}
		],
		Test["If SourceTemperature is not Ambient, require a plate for robotic sample preparation:",
			Module[
				{protocol,resource},
				protocol = ExperimentTransfer[
					Model[Sample, "Milli-Q water"],
					Model[Container, Vessel, "50mL Tube"],
					900 Microliter,
					SourceTemperature->40Celsius,
					Preparation -> Robotic
				];
				resource = FirstCase[Download[protocol,RequiredResources],{_,RequiredObjects,1,_}][[1]];
				{
					Download[resource,Models],
					Download[resource,Amount],
					Download[resource,ContainerModels]
				}
			],
			{{ObjectP[Model[Sample, "Milli-Q water"]]},GreaterEqualP[0.9Milliliter],{ObjectP[Model[Container,Plate]]..}}
		],
		Test["Set MultichannelTransfer to False in manual preparation, if serial transfer is implied from SourceWell and DestinationWell specifications:",
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 15 in A1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Sequence @@ ConstantArray[{1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]}, 60]
				},
				ConstantArray[{1, Model[Container, Plate, "96-well 2mL Deep Well Plate"]}, 61],
				ConstantArray[75 * Microliter, 61],
				SourceWell -> {Automatic, "B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9", "B10", "B11", "B12", "C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10", "C11", "C12", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "D11", "D12", "E1", "E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9", "E10", "E11", "E12", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12"},
				DestinationWell -> {"B1", "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9", "B10", "B11", "B12", "C1", "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10", "C11", "C12", "D1", "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "D11", "D12", "E1", "E2", "E3", "E4", "E5", "E6", "E7", "E8", "E9", "E10", "E11", "E12", "F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", "G1"},
				Preparation -> Manual,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, ManualSamplePreparation]], KeyValuePattern[MultichannelTransfer -> False]}
		],
		Test["Set MultichannelTransfer to False in manual preparation, if serial transfer is implied from the position of the source and destination samples, and additional SourceWell/DestinationWell specifications :",
			ExperimentTransfer[
				{
					Object[Sample, "Test water sample 15 in A1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 19 in A2 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 20 in A3 of DWP for ExperimentTransfer"<>$SessionUUID],
					Sequence @@ ConstantArray[Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer"<>$SessionUUID], 9],
					Object[Sample, "Test water sample 16 in B1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Sequence @@ ConstantArray[Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer"<>$SessionUUID], 11],
					Object[Sample, "Test water sample 17 in C1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Sequence @@ ConstantArray[Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer"<>$SessionUUID], 11],
					Object[Sample, "Test water sample 18 in D1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Sequence @@ ConstantArray[Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer"<>$SessionUUID], 12]
				},
				{
					Object[Sample, "Test water sample 19 in A2 of DWP for ExperimentTransfer"<>$SessionUUID],
					Object[Sample, "Test water sample 20 in A3 of DWP for ExperimentTransfer"<>$SessionUUID],
					Sequence @@ ConstantArray[Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer"<>$SessionUUID], 9],
					Object[Sample, "Test water sample 16 in B1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Sequence @@ ConstantArray[Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer"<>$SessionUUID], 11],
					Object[Sample, "Test water sample 17 in C1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Sequence @@ ConstantArray[Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer"<>$SessionUUID], 11],
					Object[Sample, "Test water sample 18 in D1 of DWP for ExperimentTransfer"<>$SessionUUID],
					Sequence @@ ConstantArray[Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer"<>$SessionUUID], 13]
				},
				ConstantArray[75 * Microliter, 49],
				SourceWell -> {Automatic, Automatic, Automatic, "A4", "A5", "A6", "A7", "A8", "A9", "A10", "A11", "A12", Automatic, "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9", "B10", "B11", "B12", Automatic, "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10", "C11", "C12", Automatic, "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "D11", "D12", "E1"},
				DestinationWell -> {Automatic, Automatic, "A4", "A5", "A6", "A7", "A8", "A9", "A10", "A11", "A12", Automatic, "B2", "B3", "B4", "B5", "B6", "B7", "B8", "B9", "B10", "B11", "B12", Automatic, "C2", "C3", "C4", "C5", "C6", "C7", "C8", "C9", "C10", "C11", "C12", Automatic, "D2", "D3", "D4", "D5", "D6", "D7", "D8", "D9", "D10", "D11", "D12", "E1", "E2"},
				Preparation -> Manual,
				Output -> {Result, Options}
			],
			{ObjectP[Object[Protocol, ManualSamplePreparation]], KeyValuePattern[MultichannelTransfer -> False]}
		],
		Test["Do not combine the resources for the same Model[Sample] if different SourceTemperature options are requested:",
			Module[
				{protocol,requiredObjects,waterPositions,resources},
				protocol = ExperimentTransfer[
					{
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
					{
						Model[Container, Vessel, "50mL Tube"],
						Model[Container, Vessel, "2mL Tube"]
					},
					{
						900 Microliter,
						900 Microliter
					},
					SourceTemperature-> {40Celsius,50Celsius},
					Preparation -> Robotic
				];
				requiredObjects = Download[protocol,RequiredObjects];
				waterPositions = Flatten[Position[Download[requiredObjects,Object],Download[Model[Sample, "Milli-Q water"], Object]]];
				resources = Cases[Download[protocol,RequiredResources],{_,RequiredObjects,Alternatives@@waterPositions,_}][[All,1]];
				{
					Count[requiredObjects, ObjectP[Model[Sample, "Milli-Q water"]]],
					Download[resources,ContainerModels]
				}
			],
			{2,{{ObjectP[Model[Container,Plate]]..},{ObjectP[Model[Container,Plate]]..}}}
		],
		Test["Do not check Magnetization-related options for resolveTransferMethod if Magnetization -> False:",
			ExperimentRoboticSamplePreparation[
				{
					Transfer[
						Source -> Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
						Amount -> 1 Milliliter,
						Destination -> Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
						Magnetization -> False
					]
				}
			],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		],
		Test["Resolves to the transfer fume hood model if hermetic transfers are required:",
			Module[
				{austinProtocol},
				austinProtocol=ExperimentTransfer[
					Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 4 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
					500 Microliter,
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID],
					Site -> Object[Container, Site, "ECL-2"]
				];
				Download[austinProtocol,BatchedUnitOperations[[1]][TransferEnvironment][[1]]]
			],
			ObjectP[Model[Instrument, HandlingStation, FumeHood]]
		],
		Test["Resolves to a correct handling station if a micro balance model is specified:",
			Module[
				{austinProtocol},
				austinProtocol=ExperimentTransfer[
					Model[Sample,"Sodium Chloride"],
					Model[Container, Vessel, "2mL Tube"],
					500 Milligram,
					Balance -> Model[Instrument,Balance,"Mettler Toledo XP6"],
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID],
					Site -> Object[Container, Site, "ECL-2"]
				];
				Download[austinProtocol,BatchedUnitOperations[[1]][TransferEnvironment][[1]]]
			],
			ObjectP[Model[Instrument, HandlingStation]]
		],
		Test["Resolves to the transfer fume hood model based on Site of the parent protocol (Hermetic container transfers):",
			Module[
				{austinProtocol},
				austinProtocol=ExperimentTransfer[
					Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 4 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
					500 Microliter,
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test ECL-2 MSP for ExperimentTransfer" <> $SessionUUID]
				];
				Download[austinProtocol,BatchedUnitOperations[[1]][TransferEnvironment][[1]]]
			],
			ObjectP[Model[Instrument, HandlingStation, FumeHood]]
		],
		Test["Always resolves to the transfer fume hood model in generating Object[Protocol,ManualSamplePreparation] and Object[Protocol,Transfer] (Hermetic container transfers, ECL-2 version):",
			Module[
				{mspProtocol,mspProtocolTransferEnvironment,transferProtocol,transferProtocolTransferEnvironment},
				mspProtocol=ExperimentTransfer[
					Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 4 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
					500 Microliter,
					Name -> "Test Fume Hood MSP 1 for ExperimentTransfer" <> $SessionUUID
				];
				mspProtocolTransferEnvironment=Lookup[Download[mspProtocol,ResolvedUnitOperationOptions[[1]]],TransferEnvironment];
				(* ConfirmProtocol usually checks for resources and assigns a Site to the protocol but we are going to do it manually here *)
				Upload[<|Object->mspProtocol,Site->Link[Object[Container,Site,"ECL-2"]]|>];
				ClearMemoization[];
				transferProtocol=ExperimentTransfer[
					Download[mspProtocol,ResolvedUnitOperationInputs[[1]]],
					Join[Download[mspProtocol,ResolvedUnitOperationOptions[[1]]],{ParentProtocol->mspProtocol,Name -> "Test Fume Hood Transfer Subprotocol 1 for ExperimentTransfer" <> $SessionUUID}]
				];
				transferProtocolTransferEnvironment=Download[transferProtocol,BatchedUnitOperations[[1]][TransferEnvironment][[1]]];
				{mspProtocolTransferEnvironment,transferProtocolTransferEnvironment}
			],
			{
				(* $TransferFumeHoodModel - Model[Instrument, HandlingStation, FumeHood, "Labconco Premier 6 Foot Variant A"] *)
				ObjectP[Model[Instrument, HandlingStation, FumeHood]],
				ObjectP[Model[Instrument, HandlingStation, FumeHood]]
			}
		],
		Test["Resolves to the transfer fume hood model for Fuming solid transfer that requires a balance:",
			Module[
				{austinProtocol},
				austinProtocol=ExperimentTransfer[
					Model[Sample, "Fmoc-L-Ala-OH"],
					Model[Container, Vessel, "2mL Tube"],
					25 Milligram,
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test ECL-2 MSP for ExperimentTransfer" <> $SessionUUID]
				];
				Download[austinProtocol,BatchedUnitOperations[[1]][TransferEnvironment][[1]]]
			],
			ObjectP[Model[Instrument, HandlingStation, FumeHood]]
		],
		Test["Always resolves to the transfer fume hood model in generating Object[Protocol,ManualSamplePreparation] and Object[Protocol,Transfer] (Fuming solid transfer that requires a balance, ECL-2 version):",
			Module[
				{mspProtocol,mspProtocolTransferEnvironment,transferProtocol,transferProtocolTransferEnvironment},
				mspProtocol=ExperimentTransfer[
					Model[Sample, "Fmoc-L-Ala-OH"],
					Model[Container, Vessel, "2mL Tube"],
					25 Milligram,
					Name -> "Test Fume Hood MSP 3 for ExperimentTransfer" <> $SessionUUID
				];
				mspProtocolTransferEnvironment=Lookup[Download[mspProtocol,ResolvedUnitOperationOptions[[1]]],TransferEnvironment];
				(* ConfirmProtocol usually checks for resources and assigns a Site to the protocol but we are going to do it manually here *)
				Upload[<|Object->mspProtocol,Site->Link[Object[Container,Site,"ECL-2"]]|>];
				ClearMemoization[];
				transferProtocol=ExperimentTransfer[
					Download[mspProtocol,ResolvedUnitOperationInputs[[1]]],
					Join[Download[mspProtocol,ResolvedUnitOperationOptions[[1]]],{ParentProtocol->mspProtocol,Name -> "Test Fume Hood Transfer Subprotocol 3 for ExperimentTransfer" <> $SessionUUID}]
				];
				transferProtocolTransferEnvironment=Download[transferProtocol,BatchedUnitOperations[[1]][TransferEnvironment][[1]]];
				{mspProtocolTransferEnvironment,transferProtocolTransferEnvironment}
			],
			{
				(* $TransferFumeHoodModel - Model[Instrument, HandlingStation, FumeHood, "Labconco Premier 6 Foot Variant A"] *)
				ObjectP[Model[Instrument, HandlingStation, FumeHood]],
				ObjectP[Model[Instrument, HandlingStation, FumeHood]]
			}
		],
		Test["If transferring a sample that is incompatible with some containers (for instance, glass) and we're doing an intermediate transfer, don't use an intermediate container that is that material:",
			Module[{protocol, unitOpRequiredResources, sourceResource},
				protocol = ExperimentTransfer[
					Model[Sample, "Triethylamine trihydrofluoride"],
					Model[Container, Vessel, "5L Plastic Container"],
					1 Liter,
					IntermediateDecant -> True,
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
				];
				unitOpRequiredResources = Download[protocol, BatchedUnitOperations[[1]][RequiredResources]];
				sourceResource = FirstCase[unitOpRequiredResources, {resource:ObjectP[], IntermediateContainerLink, 1, Null} :> resource];
				Download[sourceResource, Models[ContainerMaterials]]
			],
			{{Polypropylene}}
		],
		Test["WasteBin and WasteBag resources are not populated if the TransferEnvironment is NOT a bsc:",
			Module[{protocol},
				protocol = ExperimentTransfer[
					Model[Sample, "Milli-Q water"],
					Model[Container, Vessel, "50mL Tube"],
					900 Microliter,
					TransferEnvironment -> Model[Instrument, HandlingStation, Ambient, "id:8qZ1VWkXo06X"],
					Preparation -> Manual,
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
				];

				Download[protocol,BatchedUnitOperations[{BiosafetyWasteBin,BiosafetyWasteBag,BiosafetyWasteBinPlacements,BiosafetyWasteBinTeardowns}]]
			],
			{{{},{},{},{}}}
		],
		Test["If transferring a sample that is incompatible with some containers (for instance, glass), do not resolve to a source container that is that material:",
			Module[{protocol, unitOpRequiredResources, sourceResource},
				protocol = ExperimentTransfer[
					Model[Sample, "Triethylamine trihydrofluoride"],
					Model[Container, Vessel, "5L Plastic Container"],
					1 Liter,
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
				];
				unitOpRequiredResources = Download[protocol, BatchedUnitOperations[[1]][RequiredResources]];
				sourceResource = FirstCase[unitOpRequiredResources, {resource:ObjectP[], SourceLink, 1, Null} :> resource];
				Download[sourceResource, ContainerModels[ContainerMaterials]]
			],
			{{Polypropylene}}
		],
		Test["If transferring a sample that is incompatible with some containers (for instance, glass) and we're doing an intermediate transfer, don't use an intermediate container that is that material:",
			Module[{protocol, unitOpRequiredResources, sourceResource},
				protocol = ExperimentTransfer[
					Model[Sample, "Triethylamine trihydrofluoride"],
					Model[Container, Vessel, "5L Plastic Container"],
					1 Liter,
					IntermediateDecant -> True,
					ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
				];
				unitOpRequiredResources = Download[protocol, BatchedUnitOperations[[1]][RequiredResources]];
				sourceResource = FirstCase[unitOpRequiredResources, {resource:ObjectP[], IntermediateContainerLink, 1, Null} :> resource];
				Download[sourceResource, Models[ContainerMaterials]]
			],
			{{Polypropylene}}
		],
		Test["Generate an Object[Protocol, ManualCellPreparation] if Preparation -> Manual and a cell-containing sample is used:",
			ExperimentTransfer[
				{Object[Sample, "Test cell sample 1 for ExperimentTransfer" <> $SessionUUID]},
				{Model[Container, Vessel, "50mL Tube"]},
				{0.5 Milliliter},
				Preparation -> Manual,
				ImageSample -> False,
				MeasureVolume -> False,
				MeasureWeight -> False
			],
			ObjectP[Object[Protocol, ManualCellPreparation]]
		],
		Test["Generate an Object[Protocol, RoboticCellPreparation] if Preparation -> Robotic and a cell-containing sample is used:",
			ExperimentTransfer[
				{Object[Sample, "Test cell sample 1 for ExperimentTransfer" <> $SessionUUID]},
				{Model[Container, Vessel, "50mL Tube"]},
				{0.5 Milliliter},
				Preparation -> Robotic,
				ImageSample -> False,
				MeasureVolume -> False,
				MeasureWeight -> False
			],
			ObjectP[Object[Protocol, RoboticCellPreparation]]
		],
		Test["Transfer of specified counts can be resolved for sachet samples:",
			{options, simulation} = ExperimentTransfer[
				{Object[Sample, "Test itemized sachet sample 25 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]},
				{Model[Container, Vessel, "50mL Tube"]},
				{5},
				Output -> {Options, Simulation}
			];
			{sourceSample, destinationSample} = LookupLabeledObject[simulation, Lookup[options, {SourceLabel, DestinationLabel}]];

			{
				Lookup[options,{Instrument, IncludeSachetPouch}],
				Download[
					{sourceSample, destinationSample},
					{Mass, Count, Sachet, Composition},
					Simulation -> simulation
				]
			},
			{
				{ObjectP[Model[Item, Scissors]], False},
				{
					{
						MassP, 15, True,
						{
							{EqualP[100 MassPercent], ObjectP[Model[Molecule, "Test sachet filler model for ExperimentTransfer" <> $SessionUUID]], _},
							{Null, ObjectP[Model[Material, "Test sachet pouch model for ExperimentTransfer"<> $SessionUUID]],_}
						}
					},
					{
						MassP, Null, False,
						{
							(* Default to not include the pouch *)
							{EqualP[100 MassPercent], ObjectP[Model[Molecule, "Test sachet filler model for ExperimentTransfer" <> $SessionUUID]],_}
						}
					}
				}
			},
			Variables :> {options, simulation, sourceSample, destinationSample}
		],
		Test["Transfer of specified counts using tweezers can be resolved for sachet samples, and destination samples gets Count correctly populated:",
			{options, simulation} = ExperimentTransfer[
				{Object[Sample, "Test itemized sachet sample 25 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]},
				{Model[Container, Vessel, "50mL Tube"]},
				{5},
				Instrument -> Model[Item, Tweezer, "id:8qZ1VWNwNDVZ"], (* "Straight flat tip tweezer" *)
				Output -> {Options, Simulation}
			];
			{sourceSample, destinationSample} = LookupLabeledObject[simulation, Lookup[options, {SourceLabel, DestinationLabel}]];

			{
				Lookup[options,{Instrument, IncludeSachetPouch}],
				Download[
					{sourceSample, destinationSample},
					{Mass, Count, Sachet, Model, Composition},
					Simulation -> simulation
				]
			},
			{
				{ObjectP[Model[Item, Tweezer]], Null},
				{
					{
						MassP, 15, True,
						ObjectP[Model[Sample, "Test sachet model sample for ExperimentTransfer"<> $SessionUUID]],
						{
							{EqualP[100 MassPercent], ObjectP[Model[Molecule, "Test sachet filler model for ExperimentTransfer" <> $SessionUUID]], _},
							{Null, ObjectP[Model[Material, "Test sachet pouch model for ExperimentTransfer"<> $SessionUUID]],_}
						}
					},
					{
						MassP, 5, True,
						ObjectP[Model[Sample, "Test sachet model sample for ExperimentTransfer"<> $SessionUUID]],
						{
							{EqualP[100 MassPercent], ObjectP[Model[Molecule, "Test sachet filler model for ExperimentTransfer" <> $SessionUUID]], _},
							{Null, ObjectP[Model[Material, "Test sachet pouch model for ExperimentTransfer"<> $SessionUUID]],_}
						}
					}
				}
			},
			Variables :> {options, simulation, sourceSample, destinationSample}
		],
		Test["Specifying a volume for transfer from sachet source cleanly errors out:",
			ExperimentTransfer[
				{Object[Sample, "Test itemized sachet sample 25 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]},
				{Model[Container, Vessel, "50mL Tube"]},
				{1 Milliliter},
				IncludeSachetPouch -> True
			],
			$Failed,
			Messages :> {
				Message[Error::TransferSolidSampleByVolume],
				Message[Error::InvalidInput]
			}
		],
		Test["Defaulting to PreferredContainer if we are requesting a sample model of an amount that can be prepared via Consolidation in lab, otherwise, set to product default container:",
			{
				Block[{$DeveloperSearch = True}, Module[{protocol, unitOpRequiredResources, sourceResource},
					protocol = ExperimentTransfer[
						Model[Sample, "test liquid model for ExperimentTransfer unit testing "<>$SessionUUID],
						Model[Container, Vessel, "2L Glass Bottle"],
						1.2 Liter,
						ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer"<>$SessionUUID]
					];
					unitOpRequiredResources = Download[protocol, BatchedUnitOperations[[1]][RequiredResources]];
					sourceResource = FirstCase[unitOpRequiredResources, {resource:ObjectP[], SourceLink, 1, Null} :> resource];
					Download[sourceResource, ContainerModels][[1]]
				]],
				Block[{$DeveloperSearch = True, $RequiredSearchName = "This search must fail :)"}, Module[{protocol, unitOpRequiredResources, sourceResource},
					protocol = ExperimentTransfer[
						Model[Sample, "test liquid model for ExperimentTransfer unit testing "<>$SessionUUID],
						Model[Container, Vessel, "2L Glass Bottle"],
						1.2 Liter,
						ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer"<>$SessionUUID]
					];
					unitOpRequiredResources = Download[protocol, BatchedUnitOperations[[1]][RequiredResources]];
					sourceResource = FirstCase[unitOpRequiredResources, {resource:ObjectP[], SourceLink, 1, Null} :> resource];
					Download[sourceResource, ContainerModels][[1]]
				]]
			},
			{ObjectP[Model[Container, Vessel, "2L Glass Bottle"]], ObjectP[Model[Container, Vessel, "4L disposable amber glass bottle for inventory chemicals"]]}
		],
		Test[{"Resolves to not use serological pipettes if we are using volumetric flask as the source:"},
			Module[{msp},
				msp = ExperimentManualSamplePreparation[
					{
						LabelSample[
							(* "Milli-Q water" *)
							Sample -> Model[Sample, "id:8qZ1VWNmdLBD"],
							Amount -> 10 Milliliter,
							(* "20 mL Glass Volumetric Flask" *)
							Container -> Model[Container, Vessel, VolumetricFlask, "id:n0k9mGOLdwjr"],
							Label -> "my sample in volumetric flask"
						],
						Transfer[
							(* "Milli-Q water" *)
							Source -> {"my sample in volumetric flask"},
							(* "50mL Tube" *)
							Destination -> {Model[Container, Vessel, "id:bq9LA0dBGGR6"]},
							Amount -> {5 Milliliter}
						]
					}
				];
				Download[Lookup[Download[msp, ResolvedUnitOperationOptions[[2]]], Tips], PipetteType]
			],
			Micropipette
		],
		Test["Resolve WeightStabilityDuration and MaxWeightVariation to 10 s and 5x balance default if we are transferring small amount of liquid (<5 mL) using balance:",
			protocol = ExperimentTransfer[
				Model[Sample, "Milli-Q water"],
				Model[Container, Vessel, "50mL Tube"],
				2 Milligram,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];
			balanceDefault = Download[protocol, Balances[AllowedMaxVariation]][[1]];
			Equal[
				Download[
					protocol,
					BatchedUnitOperations[[1]][{WeightStabilityDuration, MaxWeightVariation, TareWeightStabilityDuration, MaxTareWeightVariation}]
				],
				{
					{10 Second},
					{balanceDefault * 5},
					{60 Second},
					{balanceDefault}
				}
			],
			True,
			Variables :> {protocol, balanceDefault}
		],
		Test["Resolve WeightStabilityDuration and MaxWeightVariation to 60 s and balance default if we are transferring using balance:",
			protocol = ExperimentTransfer[
				Model[Sample, "Milli-Q water"],
				Model[Container, Vessel, "50mL Tube"],
				6 Gram,
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];
			balanceDefault = Download[protocol, Balances[AllowedMaxVariation]][[1]];
			Equal[
				Download[
					protocol,
					BatchedUnitOperations[[1]][{WeightStabilityDuration, MaxWeightVariation, TareWeightStabilityDuration, MaxTareWeightVariation}]
				],
				{
					{60 Second},
					{balanceDefault},
					{60 Second},
					{balanceDefault}
				}
			],
			True,
			Variables :> {protocol, balanceDefault}
		],

		Test["HandPumpAdapter is specified in a Transfer UO if the resolved HandPump IntakeTubeLength is incompatible with the source container :",
			transferProtocol=ExperimentTransfer[
				Object[Sample, "Test water sample in 10L Carboy for ExperimentTransfer" <> $SessionUUID],
				Model[Container, Vessel, "4L bottle"],
				3 Liter,
				ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];
			Download[transferProtocol,BatchedUnitOperations[[1]][HandPumpAdapter]][[1]],
			ObjectP[Model[Part,HandPumpAdapter]],
			Variables:>{
				transferProtocol
			}
		],
		Test["HandPumpAdapter is not needed in a Transfer UO if the resolved HandPump IntakeTubeLength is compatible with the source container :",
			transferProtocol=ExperimentTransfer[
				Object[Sample, "Test water sample in 20L Carboy for ExperimentTransfer" <> $SessionUUID],
				Model[Container, Vessel, "4L bottle"],
				3 Liter,
				ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];
			Download[transferProtocol,BatchedUnitOperations[[1]][HandPumpAdapter]][[1]],
			Null,
			Variables:>{
				transferProtocol
			}
		],
		Test["Appropriate resources are generated for HandPump and HandPumpAdapter :",
			transferProtocol=ExperimentTransfer[
				{
					Object[Sample, "Test water sample in 10L Carboy for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample in 10L Carboy for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample in 20L Carboy for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample in 10L Carboy for ExperimentTransfer" <> $SessionUUID]
				},
				ConstantArray[Model[Container, Vessel, "4L bottle"],4],
				1 Liter,
				ParentProtocol->Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];
			{
				Length[DeleteDuplicates[
					Cases[
						Flatten[transferProtocol[BatchedUnitOperations][RequiredResources], 1],
						{_, HandPump, ___}
					][[All, 1]][Object]
				]],
				Length[DeleteDuplicates[
					Cases[
						Flatten[transferProtocol[BatchedUnitOperations][RequiredResources], 1],
						{_, HandPumpAdapter, ___}
					][[All, 1]][Object]
				]]
			},
			{3,2},
			Variables:>{
				transferProtocol
			}
		],
		Test["Populate some resources to be picked in BatchedUnitOperations if they can potentially be found in the local cache of transfer environment:",
			transferProtocol= ExperimentTransfer[
				{Object[Sample, "Test water sample in 20L Carboy for ExperimentTransfer" <> $SessionUUID], Object[Sample, "Test water sample in 20L Carboy for ExperimentTransfer" <> $SessionUUID]},
				(* Model[Container, Vessel, "4L bottle"] *)
				{Model[Container, Vessel, "id:mnk9jOkXKnKl"], Model[Container, Vessel, "id:mnk9jOkXKnKl"]},
				3 Liter,
				TransferEnvironment -> {Object[Instrument, HandlingStation, Ambient, "Test handling station 2 for ExperimentTransfer tests" <> $SessionUUID], Model[Instrument, HandlingStation, Ambient, "Test HandlingStation Model with LocalCacheContents for ExperimentTransfer"<>$SessionUUID]},
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];
			Download[transferProtocol, {RequiredObjects, BatchedUnitOperations[RequiredObjects]}],
			{
				{ObjectP[]...},
				(* the destination container *)
				{{LinkP[Model[Container, Vessel, "id:mnk9jOkXKnKl"]]}, {LinkP[Model[Container, Vessel, "id:mnk9jOkXKnKl"]]}}
			},
			Variables:>{
				transferProtocol
			}
		],
		Test["Populate some resources to be picked in the first BatchedUnitOperations if they can potentially be found in the local cache of transfer environment for BSC/GloveBox:",
			transferProtocol= ExperimentTransfer[
				{Object[Sample, "Test methanol sample 7 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], Object[Sample, "Test methanol sample 7 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]},
				(* Model[Container, Vessel, "4L bottle"] *)
				{Model[Container, Vessel, "id:mnk9jOkXKnKl"], Model[Container, Vessel, "id:mnk9jOkXKnKl"]},
				3 Milliliter,
				TransferEnvironment -> Model[Instrument, HandlingStation, GloveBox, "Test HandlingStation Model 2 with LocalCacheContents for ExperimentTransfer" <> $SessionUUID],
				ParentProtocol -> Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID]
			];
			Download[transferProtocol, {RequiredObjects, BatchedUnitOperations[RequiredObjects]}],
			{
				{ObjectP[]...},
				(* the destination container *)
				{{LinkP[Model[Container, Vessel, "id:mnk9jOkXKnKl"]], LinkP[Model[Container, Vessel, "id:mnk9jOkXKnKl"]]}, {}}
			},
			Variables:>{
				transferProtocol
			},
			Messages :> {Warning::NonAnhydrousSample}
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		(* Turn off the SamplesOutOfStock warning for unit tests *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::DeprecatedProduct];
		Off[Warning::APIConnection];
		ClearMemoization[];
		Block[{$Notebook = Null, $DeveloperUpload = True},
			experimentTransferTestCleanup[];
			Module[
				{
					tube1, tube2, tube3, tube4, tube5, tube6, tube7, tube8, tube9, tube10, tube11, tube12, tube13, tube14, tube15, tube16, tube17, tube18, tube19, tube20, tube21, tube22, tube23,
					hermeticContainer1, hermeticContainer2, plate1, plate2, volFlask1,volFlask2,volFlask3,volFlask4,volFlask5,volFlask6,carboy20L,carboy10L,capillary1, ssProt, method, plateModel,handPumpAdapterModel,handPumpAdapterObject,
					testBench, solventSampleModel,solidSampleModel,
					filler, pouch, sachetSampleModel, reservoir1, plate3, plate4, reservoir2, plate5, ampoule1,
					cover1, cover2, createdSamples, capillarySample, discardedTube, testLiquidModel, testProduct, containers,fillToVolumeProtocol,transferUnitOperation,mspProtocol,testHS,testHS2,testHS3,testHS4,testHS5
				},
				Upload[
					{
						<|
							Type -> Object[Protocol, ManualSamplePreparation],
							Name -> "Test MSP for ExperimentTransfer"<>$SessionUUID,
							Author -> Link[$PersonID, ProtocolsAuthored],
							Site -> Link[$Site]
						|>,
						<|
							Type -> Object[Protocol, ManualSamplePreparation],
							Name -> "Test CMU MSP for ExperimentTransfer"<>$SessionUUID,
							Author -> Link[$PersonID, ProtocolsAuthored],
							Site -> Link[Object[Container, Site, "ECL-CMU"]]
						|>,
						<|
							Type -> Object[Protocol, ManualSamplePreparation],
							Name -> "Test ECL-2 MSP for ExperimentTransfer"<>$SessionUUID,
							Author -> Link[$PersonID, ProtocolsAuthored],
							Site -> Link[Object[Container, Site, "ECL-2"]]
						|>,
						<|
							AsepticHandling -> False,
							AsepticTechniqueEnvironment -> False,
							Replace[BalanceType] -> {Macro},
							BiosafetyCabinetStorage -> False,
							CrossSectionalShape -> Rectangle,
							Deionizing -> False,
							Dimensions -> {Quantity[0.8128, "Meters"], Quantity[0.8382, "Meters"], Quantity[1.0287, "Meters"]},
							FumeHoodStorage -> False,
							GloveBoxStorage -> False,
							HermeticTransferCompatible -> False,
							InternalDimensions -> {Quantity[0.762, "Meters"], Quantity[0.8128, "Meters"], Quantity[1.0033, "Meters"]},
							Replace[Positions] -> {<|Name -> "IR Probe Slot", Footprint -> Open, MaxWidth -> Quantity[0.05, "Meters"], MaxDepth -> Quantity[0.05, "Meters"], MaxHeight -> Quantity[0.12, "Meters"]|>, <|Name -> "Balance Camera Slot", Footprint -> Open, MaxWidth -> Quantity[0.074, "Meters"], MaxDepth -> Quantity[0.029, "Meters"], MaxHeight -> Quantity[0.029, "Meters"]|>, <|Name -> "Balance Slot", Footprint -> Open, MaxWidth -> Quantity[0.228, "Meters"], MaxDepth -> Quantity[0.387, "Meters"], MaxHeight -> Quantity[0.101, "Meters"]|>, <|Name -> "Pipette Imaging Slot", Footprint -> Open, MaxWidth -> Quantity[0.2413, "Meters"], MaxDepth -> Quantity[0.2413, "Meters"], MaxHeight -> Quantity[0.2413, "Meters"]|>, <|Name -> "Pipette Camera Slot", Footprint -> Open, MaxWidth -> Quantity[0.074, "Meters"], MaxDepth -> Quantity[0.029, "Meters"], MaxHeight -> Quantity[0.029, "Meters"]|>, <|Name -> "Working Zone Slot", Footprint -> Open, MaxWidth -> Quantity[0.75, "Meters"], MaxDepth -> Quantity[0.35, "Meters"], MaxHeight -> Null|>, <|Name -> "Right Cap Rack Slot", Footprint -> Open, MaxWidth -> Quantity[0.076, "Meters"], MaxDepth -> Quantity[0.076, "Meters"], MaxHeight -> Quantity[0.076, "Meters"]|>, <|Name -> "Left Cap Rack Slot", Footprint -> Open, MaxWidth -> Quantity[0.076, "Meters"], MaxDepth -> Quantity[0.076, "Meters"], MaxHeight -> Quantity[0.076, "Meters"]|>, <|Name -> "Left GoPro Slot", Footprint -> Open, MaxWidth -> Quantity[0.0718, "Meters"], MaxDepth -> Quantity[0.0508, "Meters"], MaxHeight -> Quantity[0.0336, "Meters"]|>, <|Name -> "Middle GoPro Slot", Footprint -> Open, MaxWidth -> Quantity[0.0718, "Meters"], MaxDepth -> Quantity[0.0508, "Meters"], MaxHeight -> Quantity[0.0336, "Meters"]|>, <|Name -> "Right GoPro Slot", Footprint -> Open, MaxWidth -> Quantity[0.0718, "Meters"], MaxDepth -> Quantity[0.0508, "Meters"], MaxHeight -> Quantity[0.0336, "Meters"]|>, <|Name -> "WasteBin Slot", Footprint -> Open, MaxWidth -> Quantity[0.255, "Meters"], MaxDepth -> Quantity[0.178, "Meters"], MaxHeight -> Quantity[0.255, "Meters"]|>, <|Name -> "Mixing Zone Slot", Footprint -> Open, MaxWidth -> Quantity[0.35, "Meters"], MaxDepth -> Quantity[0.35, "Meters"], MaxHeight -> Null|>},
							Replace[ProvidedHandlingConditions] -> {Link[Model[HandlingCondition, "Benchtop Enclosure with Macro Balance"]]},
							QualificationRequired -> False,
							DeveloperObject -> False,
							Sterile -> False,
							Type -> Model[Instrument, HandlingStation, Ambient],
							Ventilated -> False,
							Replace[LocalCacheContents] -> {{Link[Model[Container, Vessel, "4L bottle"]], 5}},
							Name -> "Test HandlingStation Model with LocalCacheContents for ExperimentTransfer"<>$SessionUUID
						|>,
						<|
							AsepticHandling -> False,
							AsepticTechniqueEnvironment -> False,
							Replace[BalanceType] -> {Macro},
							BiosafetyCabinetStorage -> False,
							CrossSectionalShape -> Rectangle,
							Deionizing -> False,
							Dimensions -> {Quantity[0.8128, "Meters"], Quantity[0.8382, "Meters"], Quantity[1.0287, "Meters"]},
							FumeHoodStorage -> False,
							GloveBoxStorage -> False,
							HermeticTransferCompatible -> False,
							InternalDimensions -> {Quantity[0.762, "Meters"], Quantity[0.8128, "Meters"], Quantity[1.0033, "Meters"]},
							Replace[Positions] -> {<|Name -> "IR Probe Slot", Footprint -> Open, MaxWidth -> Quantity[0.05, "Meters"], MaxDepth -> Quantity[0.05, "Meters"], MaxHeight -> Quantity[0.12, "Meters"]|>, <|Name -> "Balance Camera Slot", Footprint -> Open, MaxWidth -> Quantity[0.074, "Meters"], MaxDepth -> Quantity[0.029, "Meters"], MaxHeight -> Quantity[0.029, "Meters"]|>, <|Name -> "Balance Slot", Footprint -> Open, MaxWidth -> Quantity[0.228, "Meters"], MaxDepth -> Quantity[0.387, "Meters"], MaxHeight -> Quantity[0.101, "Meters"]|>, <|Name -> "Pipette Imaging Slot", Footprint -> Open, MaxWidth -> Quantity[0.2413, "Meters"], MaxDepth -> Quantity[0.2413, "Meters"], MaxHeight -> Quantity[0.2413, "Meters"]|>, <|Name -> "Pipette Camera Slot", Footprint -> Open, MaxWidth -> Quantity[0.074, "Meters"], MaxDepth -> Quantity[0.029, "Meters"], MaxHeight -> Quantity[0.029, "Meters"]|>, <|Name -> "Working Zone Slot", Footprint -> Open, MaxWidth -> Quantity[0.75, "Meters"], MaxDepth -> Quantity[0.35, "Meters"], MaxHeight -> Null|>, <|Name -> "Right Cap Rack Slot", Footprint -> Open, MaxWidth -> Quantity[0.076, "Meters"], MaxDepth -> Quantity[0.076, "Meters"], MaxHeight -> Quantity[0.076, "Meters"]|>, <|Name -> "Left Cap Rack Slot", Footprint -> Open, MaxWidth -> Quantity[0.076, "Meters"], MaxDepth -> Quantity[0.076, "Meters"], MaxHeight -> Quantity[0.076, "Meters"]|>, <|Name -> "Left GoPro Slot", Footprint -> Open, MaxWidth -> Quantity[0.0718, "Meters"], MaxDepth -> Quantity[0.0508, "Meters"], MaxHeight -> Quantity[0.0336, "Meters"]|>, <|Name -> "Middle GoPro Slot", Footprint -> Open, MaxWidth -> Quantity[0.0718, "Meters"], MaxDepth -> Quantity[0.0508, "Meters"], MaxHeight -> Quantity[0.0336, "Meters"]|>, <|Name -> "Right GoPro Slot", Footprint -> Open, MaxWidth -> Quantity[0.0718, "Meters"], MaxDepth -> Quantity[0.0508, "Meters"], MaxHeight -> Quantity[0.0336, "Meters"]|>, <|Name -> "WasteBin Slot", Footprint -> Open, MaxWidth -> Quantity[0.255, "Meters"], MaxDepth -> Quantity[0.178, "Meters"], MaxHeight -> Quantity[0.255, "Meters"]|>, <|Name -> "Mixing Zone Slot", Footprint -> Open, MaxWidth -> Quantity[0.35, "Meters"], MaxDepth -> Quantity[0.35, "Meters"], MaxHeight -> Null|>},
							Replace[ProvidedHandlingConditions] -> {Link[Model[HandlingCondition, "id:lYq9jRO0W9YX"]]},
							QualificationRequired -> False,
							DeveloperObject -> False,
							Sterile -> False,
							Type -> Model[Instrument, HandlingStation, GloveBox],
							Ventilated -> False,
							Replace[LocalCacheContents] -> {{Link[Model[Container, Vessel, "4L bottle"]], 5}},
							Name -> "Test HandlingStation Model 2 with LocalCacheContents for ExperimentTransfer"<>$SessionUUID
						|>
					}
				];

				{
					testBench,
					testHS,
					testHS2,
					testHS3,
					testHS4,
					testHS5
				} = Upload[{
					<|Type -> Object[Container, Bench], Name -> "Test bench for ExperimentTransfer tests"<>$SessionUUID, DeveloperObject -> True, Site -> Link[$Site], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects]|>,
					<|Type -> Object[Instrument, HandlingStation, Ambient], Name -> "Test handling station for ExperimentTransfer tests"<>$SessionUUID, DeveloperObject -> True, Site -> Link[$Site], Model -> Link[Model[Instrument, HandlingStation, Ambient, "id:8qZ1VWkXo06X"], Objects]|>,
					<|Type -> Object[Instrument, HandlingStation, Ambient], Name -> "Test handling station 2 for ExperimentTransfer tests"<>$SessionUUID, DeveloperObject -> True, Site -> Link[$Site], Model -> Link[Model[Instrument, HandlingStation, Ambient, "Test HandlingStation Model with LocalCacheContents for ExperimentTransfer"<>$SessionUUID], Objects]|>,
					<|Type -> Object[Instrument, HandlingStation, Ambient], Name -> "Test handling station 3 for ExperimentTransfer tests"<>$SessionUUID, DeveloperObject -> False, Site -> Link[$Site], Model -> Link[Model[Instrument, HandlingStation, Ambient, "Test HandlingStation Model with LocalCacheContents for ExperimentTransfer"<>$SessionUUID], Objects]|>,
					<|Type -> Object[Instrument, HandlingStation, GloveBox], Name -> "Test handling station 4 for ExperimentTransfer tests"<>$SessionUUID, DeveloperObject -> False, Site -> Link[$Site], Model -> Link[Model[Instrument, HandlingStation, GloveBox, "Test HandlingStation Model 2 with LocalCacheContents for ExperimentTransfer"<>$SessionUUID], Objects]|>,
					<|Type -> Object[Instrument, HandlingStation, GloveBox], Name -> "Test handling station 5 for ExperimentTransfer tests"<>$SessionUUID, DeveloperObject -> False, Site -> Link[$Site], Model -> Link[Model[Instrument, HandlingStation, GloveBox, "Test HandlingStation Model 2 with LocalCacheContents for ExperimentTransfer"<>$SessionUUID], Objects]|>
				}];

				UploadLocation[
					testHS,
					{"Work Surface", testBench},
					FastTrack -> True
				];

				{
					(*1*)discardedTube,
					(*2*)tube1,
					(*3*)tube2,
					(*4*)tube3,
					(*5*)tube4,
					(*6*)tube5,
					(*7*)tube6,
					(*8*)tube7,
					(*9*)tube8,
					(*10*)tube9,
					(*11*)tube10,
					(*12*)tube11,
					(*13*)tube12,
					(*14*)tube13,
					(*15*)tube14,
					(*16*)tube15,
					(*17*)tube16,
					(*18*)tube17,
					(*19*)tube18,
					(*20*)tube19,
					(*21*)hermeticContainer1,
					(*22*)hermeticContainer2,
					(*23*)plate1,
					(*24*)plate2,
					(*25*)plate3,
					(*26*)plate4,
					(*27*)plate5,
					(*28*)reservoir1,
					(*29*)reservoir2,
					(*30*)capillary1,
					(*31*)ampoule1,
					(*32*)tube20,
					(*33*)tube21,
					(*34*)tube22,
					(*35*)tube23,
					(*36*)volFlask1,
					(*37*)volFlask2,
					(*38*)carboy20L,
					(*39*)carboy10L,
					(*40*)volFlask3,
					(*41*)volFlask4,
					(*42*)volFlask5,
					(*43*)volFlask6
				} = UploadSample[
					{
						(*1*)Model[Container, Vessel, "50mL Tube"],
						(*2*)Model[Container, Vessel, "50mL Tube"],
						(*3*)Model[Container, Vessel, "50mL Tube"],
						(*4*)Model[Container, Vessel, "50mL Tube"],
						(*5*)Model[Container, Vessel, "50mL Tube"],
						(*6*)Model[Container, Vessel, "50mL Tube"],
						(*7*)Model[Container, Vessel, "50mL Tube"],
						(*8*)Model[Container, Vessel, "50mL Tube"],
						(*9*)Model[Container, Vessel, "50mL Tube"],
						(*10*)Model[Container, Vessel, "50mL Tube"],
						(*11*)Model[Container, Vessel, "50mL Tube"],
						(*12*)Model[Container, Vessel, "50mL Tube"],
						(*13*)Model[Container, Vessel, "50mL Tube"],
						(*14*)Model[Container, Vessel, "2mL Tube"],
						(*15*)Model[Container, Vessel, "50mL Tube"],
						(*16*)Model[Container, Vessel, "50mL Tube"],
						(*17*)Model[Container, Vessel, "50mL Tube"],
						(*18*)Model[Container, Vessel, "50mL Tube"],
						(*19*)Model[Container, Vessel, "50mL Tube"],
						(*20*)Model[Container, Vessel, "50mL Tube"],
						(*21*)Model[Container, Vessel, "id:6V0npvmW99k1"],
						(*22*)Model[Container, Vessel, "id:6V0npvmW99k1"],
						(*23*)Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						(*24*)Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						(*25*)Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						(*26*)Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						(*27*)Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						(*28*)Model[Container, Plate, "id:54n6evLWKqbG"],
						(*29*)Model[Container, Plate, "id:54n6evLWKqbG"],
						(*30*)Model[Container, Capillary, "Melting point capillary"],
						(*31*)Model[Container, Vessel, "id:n0k9mGkp4OK6"], (* Model[Container, Vessel, "2mL amber glass ampoule"] *)
						(*32*)Model[Container, Vessel, "50mL Tube"],
						(*33*)Model[Container, Vessel, "50mL Tube"],
						(*34*)Model[Container, Vessel, "50mL Tube"],
						(*35*)Model[Container, Vessel, "50mL Tube"],
						(*36*)Model[Container, Vessel, VolumetricFlask, "100 mL Glass Volumetric Flask"],
						(*37*)Model[Container, Vessel, VolumetricFlask, "100 mL Glass Volumetric Flask"],
						(*38*)Model[Container, Vessel, "id:3em6Zv9NjjkY"],(*Model[Container, Vessel, "20L Polypropylene Carboy"]*)
						(*39*)Model[Container, Vessel, "id:aXRlGnZmOOB9"](*Model[Container, Vessel, "10L Polypropylene Carboy"]*),
						(*40*)Model[Container, Vessel, VolumetricFlask, "250 mL Glass Volumetric Flask"],
						(*41*)Model[Container, Vessel, VolumetricFlask, "250 mL Glass Volumetric Flask"],
						(*42*)Model[Container, Vessel, VolumetricFlask, "250 mL Glass Volumetric Flask"],
						(*43*)Model[Container, Vessel, VolumetricFlask, "250 mL Glass Volumetric Flask"]
					},
					ConstantArray[{"Working Zone Slot", testHS}, 43],
					Name -> {
						(*1*)"Test discarded 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						(*2*)"Test 50mL Tube 1 for ExperimentTransfer" <> $SessionUUID,
						(*3*)"Test 50mL Tube 2 for ExperimentTransfer" <> $SessionUUID,
						(*4*)"Test 50mL Tube 3 for ExperimentTransfer" <> $SessionUUID,
						(*5*)"Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID,
						(*6*)"Test 50mL Tube 5 for ExperimentTransfer" <> $SessionUUID,
						(*7*)"Test 50mL Tube 6 for ExperimentTransfer" <> $SessionUUID,
						(*8*)"Test 50mL Tube 7 for ExperimentTransfer" <> $SessionUUID,
						(*9*)"Test 50mL Tube 8 for ExperimentTransfer" <> $SessionUUID,
						(*10*)"Test 50mL Tube 9 for ExperimentTransfer" <> $SessionUUID,
						(*11*)"Test 50mL Tube 10 for ExperimentTransfer" <> $SessionUUID,
						(*12*)"Test 50mL Tube 11 for ExperimentTransfer" <> $SessionUUID,
						(*13*)"Test 50mL Tube 12 for ExperimentTransfer" <> $SessionUUID,
						(*14*)"Test 2mL Tube 1 for ExperimentTransfer" <> $SessionUUID,
						(*15*)"Test 50mL Tube 13 for ExperimentTransfer" <> $SessionUUID,
						(*16*)"Test 50mL Tube 14 for ExperimentTransfer" <> $SessionUUID,
						(*17*)"Test 50mL Tube 15 for ExperimentTransfer" <> $SessionUUID,
						(*18*)"Test sterile 50mL Tube 1 for ExperimentTransfer" <> $SessionUUID,
						(*19*)"Test sterile 50mL Tube 2 for ExperimentTransfer" <> $SessionUUID,
						(*20*)"Test non-sterile 50mL Tube 1 for ExperimentTransfer" <> $SessionUUID,
						(*21*)"Test Hermetic Container 1 for ExperimentTransfer" <> $SessionUUID,
						(*22*)"Test Hermetic Container 2 for ExperimentTransfer" <> $SessionUUID,
						(*23*)"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID,
						(*24*)"Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID,
						(*25*)"Test 96-DWP 3 for ExperimentTransfer" <> $SessionUUID,
						(*26*)"Test 96-DWP 4 for ExperimentTransfer" <> $SessionUUID,
						(*27*)"Test 96-DWP 5 for ExperimentTransfer" <> $SessionUUID,
						(*28*)"Test reservoir for ExperimentTransfer" <> $SessionUUID,
						(*29*)"Test reservoir 2 for ExperimentTransfer" <> $SessionUUID,
						(*30*)"Test capillary 1 for ExperimentTransfer" <> $SessionUUID,
						(*31*)"Test 2mL amber glass ampoule for ExperimentTransfer" <> $SessionUUID,
						(*32*)"Test 50mL Tube 16 for ExperimentTransfer" <> $SessionUUID,
						(*33*)"Test non-sterile 50mL Tube 2 for ExperimentTransfer" <> $SessionUUID,
						(*34*)"Test 50mL Tube 17 for ExperimentTransfer" <> $SessionUUID,
						(*35*)"Test non-sterile 50mL Tube 3 for ExperimentTransfer"<>$SessionUUID,
						(*36*)"Test 100mL VolumetricFlask 1 for ExperimentTransfer" <> $SessionUUID,
						(*37*)"Test 100mL VolumetricFlask 2 for ExperimentTransfer" <> $SessionUUID,
						(*38*)"Test 20L Carboy ExperimentTransfer" <> $SessionUUID,
						(*39*)"Test 10L Carboy ExperimentTransfer" <> $SessionUUID,
						(*40*)"Test 250mL VolumetricFlask 3 for ExperimentTransfer" <> $SessionUUID,
						(*41*)"Test 250mL VolumetricFlask 4 for ExperimentTransfer" <> $SessionUUID,
						(*42*)"Test 250mL VolumetricFlask 5 for ExperimentTransfer" <> $SessionUUID,
						(*43*)"Test 250mL VolumetricFlask 6 for ExperimentTransfer" <> $SessionUUID
					},
					Sterile -> {
						(*1*)Automatic,
						(*2*)Automatic,
						(*3*)Automatic,
						(*4*)Automatic,
						(*5*)Automatic,
						(*6*)Automatic,
						(*7*)Automatic,
						(*8*)Automatic,
						(*9*)Automatic,
						(*10*)Automatic,
						(*11*)Automatic,
						(*12*)Automatic,
						(*13*)Automatic,
						(*14*)Automatic,
						(*15*)Automatic,
						(*16*)Automatic,
						(*17*)Automatic,
						(*18*)True,
						(*19*)True,
						(*20*)False,
						(*21*)Automatic,
						(*22*)Automatic,
						(*23*)Automatic,
						(*24*)Automatic,
						(*25*)Automatic,
						(*26*)Automatic,
						(*27*)Automatic,
						(*28*)Automatic,
						(*29*)Automatic,
						(*30*)Automatic,
						(*31*)True,
						(*32*)True,
						(*33*)False,
						(*34*)False,
						(*35*)False,
						(*36*)Automatic,
						(*37*)Automatic,
						(*38*)Automatic,
						(*39*)Automatic,
						(*40*)Automatic,
						(*41*)Automatic,
						(*42*)Automatic,
						(*43*)Automatic
					}
				];

				UploadSampleStatus[Object[Container, Vessel, "Test discarded 50mL Tube for ExperimentTransfer"<>$SessionUUID], Discarded, FastTrack -> True];

				(* Create test solvent sample model *)
				solventSampleModel = UploadSampleModel[
					"Test solvent model sample for ExperimentTransfer"<>$SessionUUID,
					Composition -> {
						{90 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]},
						{10 VolumePercent, Link[Model[Molecule, Oligomer, "XNASMAD01"]]}
					},
					Expires -> False,
					ShelfLife -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Liquid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					PipettingMethod -> Model[Method, Pipetting, "id:4pO6dM5OV9vr"]
				];
				filler = Quiet[UploadMolecule[
					"Test sachet filler model for ExperimentTransfer"<> $SessionUUID,
					State -> Solid,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					Force -> True
				]];
				pouch = UploadMaterial[
					"Test sachet pouch model for ExperimentTransfer"<> $SessionUUID,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					BiosafetyLevel -> "BSL-1"
				];
				sachetSampleModel = UploadSampleModel[
					"Test sachet model sample for ExperimentTransfer"<> $SessionUUID,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {None},
					BiosafetyLevel -> "BSL-1",
					Composition -> {{100 MassPercent, filler}, {Null,
						pouch}},
					Sachet -> True,
					SolidUnitWeight -> 0.85 Gram,
					Expires -> True,
					ShelfLife -> 1 Year,
					UnsealedShelfLife -> 2 Month,
					DefaultStorageCondition -> Model[StorageCondition, "Refrigerator"],
					DefaultSachetPouch -> Model[Material, "Test sachet pouch model for ExperimentTransfer" <> $SessionUUID],
					State -> Solid
				];
				
				(* Create test sample model that has IncompatibleMaterials Polypropylene *)
				solidSampleModel = UploadSampleModel[
					"Test solid model sample for ExperimentTransfer"<>$SessionUUID,
					Composition -> {
						{Null,Null}
					},
					Expires -> False,
					ShelfLife -> Null,
					DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage"]],
					State -> Solid,
					BiosafetyLevel -> "BSL-1",
					Flammable -> False,
					MSDSFile -> NotApplicable,
					IncompatibleMaterials -> {Polypropylene}
				];

				(* Create some samples for testing purposes *)
				createdSamples = UploadSample[
					(* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
					Join[{
						(*1*)Model[Sample, "Milli-Q water"],
						(*2*)Model[Sample, "Milli-Q water"],
						(*3*)Model[Sample, "Milli-Q water"],
						(*4*)Model[Sample, "Milli-Q water"],
						(*5*)Model[Sample, "id:vXl9j5qEn66B"], (* "Sodium carbonate, anhydrous" *)
						(*6*)Model[Sample, "id:vXl9j5qEn66B"], (* "Sodium carbonate, anhydrous" *)
						(*7*)Model[Sample, "Methanol"],
						(*8*)Model[Sample, "Milli-Q water"],
						(*9*)Model[Sample, "Milli-Q water"],
						(*10*)Model[Sample, "id:6V0npvmqVoK1"], (* "Colgate Optic White 8321" *)
						(*11*)Model[Sample, "Rink Amide ChemMatrix"], (* Brittle *)
						(*12*)Model[Sample, "Milli-Q water"], (* Pretend fabric *)
						(*13*)Model[Sample, "id:zGj91a7RJ5mL"], (* "Ibuprofen tablets 500 Count" *)
						(*14*)Model[Sample, "Milli-Q water"],
						(*15*)Model[Sample, "Milli-Q water"],
						(*16*)Model[Sample, "Milli-Q water"],
						(*17*)Model[Sample, "Milli-Q water"],
						(*18*)Model[Sample, "Milli-Q water"],
						(*19*)Model[Sample, "Milli-Q water"],
						(*20*)Model[Sample, "Milli-Q water"],
						(*21*)Model[Sample, "Milli-Q water"],
						(*22*)Model[Sample, "Milli-Q water"],
						(*23*)Model[Sample, "Milli-Q water"],
						(*24*)Model[Sample, "Milli-Q water"],
						(*25*)Model[Sample, "Milli-Q water"],
						(*26*)Model[Sample, "Milli-Q water"],
						(*27*)Model[Sample, "Milli-Q water"],
						(*28*)Model[Sample, "Milli-Q water"],
						(*29*)Model[Sample, "Milli-Q water"],
						(*30*)Model[Sample, "E.coli MG1655"],
						(*31*)Model[Sample, "E.coli MG1655"],
						(*32*)Model[Sample, "Milli-Q water"],
						(*33*)Model[Sample, "Milli-Q water"],
						(*34*)Model[Sample, "Milli-Q water"],
						(*35*)Model[Sample, "Milli-Q water"]
					},
						ConstantArray[Model[Sample, "Milli-Q water"], 96],
						{
							(*34*)Model[Sample, "Milli-Q water"],
							(*35*)sachetSampleModel
						}
					],
					Join[{
						(*1*){"A1", tube1},
						(*2*){"A1", tube2},
						(*3*){"A1", hermeticContainer1},
						(*4*){"A1", hermeticContainer2},
						(*5*){"A1", tube3},
						(*6*){"A1", tube5},
						(*7*){"A1", tube6},
						(*8*){"A1", tube7},
						(*9*){"A1", tube8},
						(*10*){"A1", tube9},
						(*11*){"A1", tube10},
						(*12*){"A1", tube11},
						(*13*){"A1", tube12},
						(*14*){"A1", tube13},
						(*15*){"A1", plate1},
						(*16*){"B1", plate1},
						(*17*){"C1", plate1},
						(*18*){"D1", plate1},
						(*19*){"A2", plate1},
						(*20*){"A3", plate1},
						(*21*){"G4", plate1},
						(*22*){"H2", plate1},
						(*23*){"A1", tube14},
						(*24*){"A1", tube15},
						(*25*){"A1", tube16},
						(*26*){"H8", plate1},
						(*27*){"A1", reservoir1},
						(*28*){"A1", tube17},
						(*29*){"A1", tube18},
						(*30*){"A1", tube20},
						(*31*){"A1", tube23},
						(*32*){"A1", volFlask1},
						(*33*){"A1", volFlask2},
						(*34*){"A1", carboy20L},
						(*35*){"A1", carboy10L}
					},
						({#, plate3}& /@ Flatten@AllWells[]),
						{
							(*36*)	{"A1", ampoule1},
							(*37*)	{"A1", tube22}
						}
					],
					Name -> Join[{
						(*1*)"Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						(*2*)"Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						(*3*)"Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID,
						(*4*)"Test water sample 4 in Hermetic Container for ExperimentTransfer" <> $SessionUUID,
						(*5*)"Test powder sample 5 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						(*6*)"Test powder sample 6 (SampleHandling->Null) in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						(*7*)"Test methanol sample 7 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						(*8*)"Test slurry sample 8 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						(*9*)"Test viscous sample 9 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						(*10*)"Test paste sample 10 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						(*11*)"Test brittle sample 11 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						(*12*)"Test fabric sample 12 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						(*13*)"Test itemized tablet sample 13 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						(*14*)"Test water sample 14 in 2mL Tube for ExperimentTransfer" <> $SessionUUID,
						(*15*)"Test water sample 15 in A1 of DWP for ExperimentTransfer" <> $SessionUUID,
						(*16*)"Test water sample 16 in B1 of DWP for ExperimentTransfer" <> $SessionUUID,
						(*17*)"Test water sample 17 in C1 of DWP for ExperimentTransfer" <> $SessionUUID,
						(*18*)"Test water sample 18 in D1 of DWP for ExperimentTransfer" <> $SessionUUID,
						(*19*)"Test water sample 19 in A2 of DWP for ExperimentTransfer" <> $SessionUUID,
						(*20*)"Test water sample 20 in A3 of DWP for ExperimentTransfer" <> $SessionUUID,
						(*21*)"Test water sample 21 in G4 of DWP for ExperimentTransfer" <> $SessionUUID,
						(*22*)"Test water sample 22 in H2 of DWP for ExperimentTransfer" <> $SessionUUID,
						(*23*)"Test viscous sample 22 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						(*24*)"Test Null Volume sample 23 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						(*25*)"Test model-less sample in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						(*26*)"Test Null Volume sample 24 in DWP for ExperimentTransfer" <> $SessionUUID,
						(*27*)"Test water sample in a reservoir for ExperimentTransfer" <> $SessionUUID,
						(*28*)"Test sterile sample 1 in a 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						(*29*)"Test sterile sample 2 in a 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						(*30*)"Test cell sample 1 for ExperimentTransfer"<>$SessionUUID,
						(*31*)"Test non-sterile sample 2 in a 50mL Tube for ExperimentTransfer"<>$SessionUUID,
						(*32*)"Test water sample 1 in 100mL VolumetricFlask for ExperimentTransfer" <> $SessionUUID,
						(*33*)"Test water sample 2 in 100mL VolumetricFlask for ExperimentTransfer" <> $SessionUUID,
						(*34*)"Test water sample in 20L Carboy for ExperimentTransfer" <> $SessionUUID,
						(*35*)"Test water sample in 10L Carboy for ExperimentTransfer" <> $SessionUUID
					},
						ConstantArray[Null, 96],
						{
							(*36*)"Test sterile sample in a 2mL amber glass ampoule for ExperimentTransfer" <> $SessionUUID,
							(*37*)"Test itemized sachet sample 25 in 50mL Tube for ExperimentTransfer" <> $SessionUUID
						}
					],
					Sterile -> Join[{
						(*1*)Automatic,
						(*2*)Automatic,
						(*3*)Automatic,
						(*4*)Automatic,
						(*5*)Automatic,
						(*6*)Automatic,
						(*7*)Automatic,
						(*8*)Automatic,
						(*9*)Automatic,
						(*10*)Automatic,
						(*11*)Automatic,
						(*12*)Automatic,
						(*13*)Automatic,
						(*14*)Automatic,
						(*15*)Automatic,
						(*16*)Automatic,
						(*17*)Automatic,
						(*18*)Automatic,
						(*19*)Automatic,
						(*20*)Automatic,
						(*21*)Automatic,
						(*22*)Automatic,
						(*23*)Automatic,
						(*24*)Automatic,
						(*25*)Automatic,
						(*26*)Automatic,
						(*27*)Automatic,
						(*28*)True,
						(*29*)True,
						(*30*)Automatic,
						(*31*)False,
						(*32*)Automatic,
						(*33*)Automatic,
						(*34*)Automatic,
						(*35*)Automatic
					},
						ConstantArray[Automatic, 96],
						{
							(*36*) True,
							(*37*) False
						}
					],
					InitialAmount -> Join[{
						(*1*)25 Milliliter,
						(*2*)10 Milliliter,
						(*3*)1 Milliliter,
						(*4*)1 Milliliter,
						(*5*)10 Gram,
						(*6*)10 Gram,
						(*7*)10 Milliliter,
						(*8*)10 Milliliter,
						(*9*)10 Milliliter,
						(*10*)10 Gram,
						(*11*)5 Gram,
						(*12*)5 Gram,
						(*13*)20,
						(*14*)1 Milliliter,
						(*15*)1 Milliliter,
						(*16*)1 Milliliter,
						(*17*)1 Milliliter,
						(*18*)1 Milliliter,
						(*19*)1 Milliliter,
						(*20*)1 Milliliter,
						(*21*)1 Milliliter,
						(*22*)1 Milliliter,
						(*23*)20 Gram,
						(*24*)Null,
						(*25*)25 Milliliter,
						(*26*)Null,
						(*27*)200 Milliliter,
						(*28*)1 Milliliter,
						(*29*)1 Milliliter,
						(*30*)1 Milliliter,
						(*31*)1 Milliliter,
						(*32*)60 Milliliter,
						(*33*)40 Milliliter,
						(*34*)16 Liter,
						(*35*)8 Liter
					},
						ConstantArray[1 Milliliter, 96],
						{
							(*36*)1 Milliliter,
							(*37*)20
						}
					],
					SampleHandling -> Join[{
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Powder,
						Null,
						Liquid,
						Slurry,
						Viscous,
						Paste,
						Brittle,
						Fabric,
						Itemized,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Viscous,
						Null,
						Liquid,
						Null,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Liquid,
						Liquid
					},
						ConstantArray[Liquid, 96],
						{
							Liquid,
							Itemized
						}
					]
				];
				Upload[{
					<|Object -> Object[Sample, "Test non-sterile sample 2 in a 50mL Tube for ExperimentTransfer" <> $SessionUUID], AsepticHandling -> True|>,
					<|Object -> Object[Sample, "Test itemized tablet sample 13 in 50mL Tube for ExperimentTransfer" <> $SessionUUID], Tablet -> True|>
				}];
				(* Create a cover for the crimped container *)
				{cover1, cover2} = UploadSample[
					{
						Model[Item, Cap, "id:mnk9jORMoabZ"],
						Model[Item, Cap, "id:mnk9jORMoabZ"]
					},
					ConstantArray[{"Work Surface", testBench}, 2],
					Name -> {
						"Test crimp cover 1 for ExperimentTransfer"<>$SessionUUID,
						"Test crimp cover 2 for ExperimentTransfer"<>$SessionUUID
					}
				];

				UploadCover[
					{hermeticContainer1, hermeticContainer2},
					Cover -> {cover1, cover2}
				];

				(* FastTrack should be True for this sample due to footprinted destination *)
				capillarySample = UploadSample[
					Model[Sample, "Sodium Chloride"],
					{"A1", capillary1},
					FastTrack -> True,
					InitialAmount -> 5 Milligram,
					Name -> "Test sample in a capillary for ExperimentTransfer"<>$SessionUUID
				];

				(* for reasons that are not totally clear to me all of a sudden this is only working if Mix -> False *)
				ssProt = ExperimentStockSolution[Model[Sample, StockSolution, "70% Ethanol"], Volume -> 100 Milliliter, Name -> "Fake stock solution protocol for ExperimentTransfer"<>$SessionUUID, Mix -> False];

				method = Quiet[
					UploadPipettingMethod[
						AspirationRate -> 100 Microliter / Second,
						DispenseRate -> 200 Microliter / Second,
						CorrectionCurve -> {
							{0 Microliter, 0 Microliter},
							{50 Microliter, 60 Microliter},
							{150 Microliter, 180 Microliter},
							{300 Microliter, 345 Microliter},
							{500 Microliter, 560 Microliter}
						}
					]
				];

				plateModel = Upload[<|
					Type -> Model[Container, Plate],
					Footprint -> Plate,
					Name -> "Test plate without LiquidHandlerPrefix for ExperimentTransfer"<>$SessionUUID,
					Replace[PositionPlotting] -> {
						<|Name -> "A1", XOffset -> Quantity[0.063295, "Meters"], YOffset -> Quantity[0.043395, "Meters"], ZOffset -> Quantity[0.0011, "Meters"], CrossSectionalShape -> Rectangle, Rotation -> 0.|>
					},
					Replace[Positions] -> {
						<|Name -> "A1", Footprint -> Null, MaxWidth -> Quantity[0.12159, "Meters"], MaxDepth -> Quantity[0.07931, "Meters"], MaxHeight -> Quantity[0.03675, "Meters"]|>},
					DeveloperObject -> True,
					MaxVolume->1 Milliliter
				|>];

				(* Make some changes to our samples for testing purposes *)
				Upload[Flatten[{
					<|
						Object -> solventSampleModel, DeveloperObject -> True
					|>,
					<|
						Object -> solidSampleModel, DeveloperObject -> True
					|>,
					<|Object -> #, Status -> Available, DeveloperObject -> True|>& /@ createdSamples,
					<|Object -> #, DeveloperObject -> True|>& /@ Quiet[Cases[Flatten[Download[ssProt, {Object, ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]], ObjectReferenceP[]]],
					(* Remove Model and PipettingMethod for one sample for testing *)
					<|
						Object -> Object[Sample, "Test model-less sample in 50mL Tube for ExperimentTransfer"<>$SessionUUID],
						Model -> Null,
						Solvent -> Null,
						PipettingMethod -> Null
					|>,
					<|Object -> method, Name -> "Test pipetting method for ExperimentTransfer"<>$SessionUUID, DeveloperObject -> True|>
				}]];

				(* Create test waste bins *)
				Upload[{
					<|
						Type -> Object[Container, WasteBin],
						Model -> Link[Model[Container, WasteBin, "Biohazard Waste Container, BSC (Aseptic Transfer)"], Objects], (*"Biohazard Waste Container, BSC (Aseptic Transfer)"*)
						Site -> Link[$Site],
						Status -> Available,
						Name -> "ExperimentTransfer test biosafety waste bin 1 "<>$SessionUUID,
						DeveloperObject -> True
					|>,
					<|
						Type -> Object[Container, WasteBin],
						Model -> Link[Model[Container, WasteBin, "Biohazard Waste Container, BSC (Aseptic Transfer)"], Objects], (*"Biohazard Waste Container, BSC (Aseptic Transfer)"*)
						Site -> Link[$Site],
						Status -> Available,
						Name -> "ExperimentTransfer test biosafety waste bin 2 "<>$SessionUUID,
						DeveloperObject -> True
					|>
				}];

				(* Create test hand pump adapters *)
				handPumpAdapterModel = Upload[<|
					Type->Model[Part,HandPumpAdapter],
					Name->"Test HandPumpAdapter Model for Experiment Transfer"<>$SessionUUID,
					DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
					Dimensions->{0.101 Meter, 0.101 Meter, 0.14 Meter}
				|>];

				handPumpAdapterObject = Upload[<|
					Type->Object[Part,HandPumpAdapter],
					Model->Link[handPumpAdapterModel,Objects],
					Name->"Test HandPumpAdapter Object for Experiment Transfer"<>$SessionUUID
				|>];

				(* Upload test bscs *)
				Upload[{
					<|
						Type -> Object[Instrument, HandlingStation, BiosafetyCabinet],
						Model -> Link[Model[Instrument, HandlingStation, BiosafetyCabinet, "Biosafety Cabinet Handling Station with Analytical Balance"], Objects],
						Site -> Link[$Site],
						Status -> Available,
						Name -> "ExperimentTransfer test bsc 1 "<>$SessionUUID,
						BiosafetyWasteBin -> Link[Object[Container, WasteBin, "ExperimentTransfer test biosafety waste bin 1 "<>$SessionUUID]],
						DeveloperObject -> True
					|>,
					<|
						Type -> Object[Instrument, HandlingStation, BiosafetyCabinet],
						Model -> Link[Model[Instrument, HandlingStation, BiosafetyCabinet, "Biosafety Cabinet Handling Station with Analytical Balance"], Objects],
						Site -> Link[$Site],
						Status -> Available,
						Name -> "ExperimentTransfer test bsc 2 "<>$SessionUUID,
						BiosafetyWasteBin -> Link[Object[Container, WasteBin, "ExperimentTransfer test biosafety waste bin 2 "<>$SessionUUID]],
						DeveloperObject -> True
					|>
				}];

				{
					testLiquidModel,
					testProduct
				} = CreateID[{
					Model[Sample],
					Object[Product]
				}];

				(* upload a new test liquid model *)
				Upload[{
					<|
						Object -> testLiquidModel,
						Name -> "test liquid model for ExperimentTransfer unit testing "<>$SessionUUID,
						Replace[Synonyms] -> {"test liquid model for ExperimentTransfer unit testing "<>$SessionUUID},
						BiosafetyLevel -> "BSL-1",
						BoilingPoint -> 81 Celsius,
						Replace[Composition] -> {{99.9 VolumePercent, Link[Model[Molecule, "Acetonitrile"]]}, {0.1 VolumePercent, Null}},
						DefaultStorageCondition -> Link[Model[StorageCondition, "Ambient Storage, Flammable"]],
						Density -> (0.7019560000000001 Gram / Milliliter),
						DOTHazardClass -> "Class 3 Flammable Liquids Hazard",
						Expires -> True,
						Fiber -> False,
						Flammable -> True,
						Replace[IncompatibleMaterials] -> {Nitrile, Polypropylene},
						Living -> False,
						MeltingPoint -> -46 Celsius,
						MSDSFile -> Link[Object[EmeraldCloudFile, "id:Z1lqpMz5eqe5"]],
						NFPA -> {Health -> 2, Flammability -> 3, Reactivity -> 0, Special -> {}},
						ShelfLife -> 1825 Day,
						State -> Liquid,
						Tablet -> False,
						UltrasonicIncompatible -> True,
						UnsealedShelfLife -> 1825 Day,
						UsedAsMedia -> False,
						UsedAsSolvent -> True,
						VaporPressure -> 9.7 Kilopascal,
						Ventilated -> True
					|>,
					<|
						Object -> testProduct,
						Name -> "test product for ExperimentTransfer unit testing "<>$SessionUUID,
						Replace[Synonyms] -> {"test product for ExperimentTransfer unit testing "<>$SessionUUID},
						Amount -> Quantity[4, "Liters"],
						Author -> Link[$PersonID],
						CatalogDescription -> "Fisher Chemical Acetonitrile, OPTIMA\[Trademark] Grade, 4 L",
						CatalogNumber -> "A996-4",
						DefaultContainerModel -> Link[Model[Container, Vessel, "4L disposable amber glass bottle for inventory chemicals"], ProductsContained],
						DefaultCoverModel -> Link[Model[Item, Cap, "Bottle Cap, 52x38mm"]],
						Deprecated -> False,
						EstimatedLeadTime -> Quantity[17., "Days"],
						Manufacturer -> Link[Object[Company, Supplier, "Fisher Scientific"], Products],
						ManufacturerCatalogNumber -> "A9964",
						NumberOfItems -> 1,
						Packaging -> Single,
						Price -> Quantity[912., "USDollars"],
						ProductModel -> Link[testLiquidModel, Products],
						ProductURL -> "https://www.fishersci.com/shop/products/acetonitrile-optima-fisher-chemical-6/A9964",
						SampleType -> Bottle,
						UsageFrequency -> High
					|>
				}];

				(* upload a few empty containers *)
				containers = UploadSample[
					ConstantArray[Model[Container, Vessel, "4L disposable amber glass bottle for inventory chemicals"], 4],
					ConstantArray[{"Work Surface", testBench}, 4],
					Name -> ("test consolidation container "<>ToString[#]<>" for ExperimentTransfer unit test "<>$SessionUUID& /@ Range[4])
				];

				(* upload 4 samples *)
				UploadSample[
					ConstantArray[testLiquidModel, 4],
					{"A1", #}& /@ containers,
					Name -> ("test consolidation sample "<>ToString[#]<>" for ExperimentTransfer unit test "<>$SessionUUID& /@ Range[4]),
					InitialAmount -> ConstantArray[0.5 Liter, 4]
				];

				fillToVolumeProtocol = ExperimentFillToVolume[
					Object[Sample,"Test water sample 1 in 100mL VolumetricFlask for ExperimentTransfer" <> $SessionUUID],
					100 Milliliter,
					Solvent -> Model[Sample, "Milli-Q water"],
					Name->"Test FillToVolume Protocol for ExperimentTransfer tests"<>$SessionUUID
				];

				TestResources[fillToVolumeProtocol];

				transferUnitOperation = fillToVolumeProtocol[BatchedUnitOperations][[1]][TransferUnitOperations][[1]][Object];

				mspProtocol = ExperimentManualSamplePreparation[transferUnitOperation,Name->"Test MSP Protocol of FillToVolume for ExperimentTransfer tests"<>$SessionUUID,ParentProtocol->fillToVolumeProtocol];
			]
		]
	),

	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::DeprecatedProduct];
		On[Warning::APIConnection];
		experimentTransferTestCleanup[]

	),
	Stubs:>{
		$AllowPublicObjects=True,
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
];

experimentTransferTestCleanup[] := Module[{allObjects, existsFilter},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
				allObjects = Cases[Flatten[{
					Object[Container, Bench, "Test bench for ExperimentTransfer tests" <> $SessionUUID],
					Model[Instrument, HandlingStation, Ambient, "Test HandlingStation Model with LocalCacheContents for ExperimentTransfer"<>$SessionUUID],
					Model[Instrument, HandlingStation, GloveBox, "Test HandlingStation Model 2 with LocalCacheContents for ExperimentTransfer"<>$SessionUUID],
					Object[Instrument, HandlingStation, Ambient, "Test handling station for ExperimentTransfer tests"<>$SessionUUID],
					Object[Instrument, HandlingStation, Ambient, "Test handling station 2 for ExperimentTransfer tests"<>$SessionUUID],
					Object[Instrument, HandlingStation, Ambient, "Test handling station 3 for ExperimentTransfer tests"<>$SessionUUID],
					Object[Instrument, HandlingStation, GloveBox, "Test handling station 4 for ExperimentTransfer tests"<>$SessionUUID],
					Object[Instrument, HandlingStation, GloveBox, "Test handling station 5 for ExperimentTransfer tests"<>$SessionUUID],
					Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID],
					Object[Protocol, ManualSamplePreparation, "Test CMU MSP for ExperimentTransfer" <> $SessionUUID],
					Object[Protocol, ManualSamplePreparation, "Test ECL-2 MSP for ExperimentTransfer" <> $SessionUUID],
					Object[Protocol, ManualSamplePreparation, "Test Fume Hood MSP 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Protocol, ManualSamplePreparation, "Test Fume Hood MSP 2 for ExperimentTransfer" <> $SessionUUID],
					Object[Protocol, ManualSamplePreparation, "Test Fume Hood MSP 3 for ExperimentTransfer" <> $SessionUUID],
					Object[Protocol, ManualSamplePreparation, "Test Fume Hood MSP 4 for ExperimentTransfer" <> $SessionUUID],
					Object[Protocol, ManualSamplePreparation, "Test Water Purifier MSP 5 for ExperimentTransfer" <> $SessionUUID],
					Object[Protocol, ManualSamplePreparation, "Test Water Purifier MSP 6 for ExperimentTransfer" <> $SessionUUID],
					Object[Protocol, Transfer, "Test Fume Hood Transfer Subprotocol 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Protocol, Transfer, "Test Fume Hood Transfer Subprotocol 2 for ExperimentTransfer" <> $SessionUUID],
					Object[Protocol, Transfer, "Test Fume Hood Transfer Subprotocol 3 for ExperimentTransfer" <> $SessionUUID],
					Object[Protocol, Transfer, "Test Fume Hood Transfer Subprotocol 4 for ExperimentTransfer" <> $SessionUUID],
					Object[Protocol, Transfer, "Test Water Purifier Transfer Subprotocol 5 for ExperimentTransfer" <> $SessionUUID],
					Object[Protocol, Transfer, "Test Water Purifier Transfer Subprotocol 6 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test discarded 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 3 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID], (* LEAVE THIS EMPTY *)
					Object[Container, Vessel, "Test 50mL Tube 5 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 6 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 7 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 8 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 9 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 10 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 11 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 12 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 13 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 2mL Tube 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 14 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 15 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test Hermetic Container 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test Hermetic Container 2 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, VolumetricFlask,"Test 100mL VolumetricFlask 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, VolumetricFlask,"Test 100mL VolumetricFlask 2 for ExperimentTransfer" <> $SessionUUID],
					Object[Container,Vessel,VolumetricFlask,"Test 250mL VolumetricFlask 3 for ExperimentTransfer"<>$SessionUUID],
					Object[Container,Vessel,VolumetricFlask,"Test 250mL VolumetricFlask 4 for ExperimentTransfer"<>$SessionUUID],
					Object[Container,Vessel,VolumetricFlask,"Test 250mL VolumetricFlask 5 for ExperimentTransfer"<>$SessionUUID],
					Object[Container,Vessel,VolumetricFlask,"Test 250mL VolumetricFlask 6 for ExperimentTransfer"<>$SessionUUID],
					Object[Container, Vessel, "Test 20L Carboy ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 10L Carboy ExperimentTransfer" <> $SessionUUID],
					Object[Container, Plate, "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Plate, "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Plate, "Test 96-DWP 3 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Plate, "Test 96-DWP 4 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Plate, "Test 96-DWP 5 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Plate, "Test reservoir for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Plate, "Test reservoir 2 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Capillary, "Test capillary 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 4 in Hermetic Container for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test powder sample 5 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test powder sample 6 (SampleHandling->Null) in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test methanol sample 7 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test slurry sample 8 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test viscous sample 9 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test paste sample 10 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test brittle sample 11 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test fabric sample 12 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test itemized tablet sample 13 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 14 in 2mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 15 in A1 of DWP for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 16 in B1 of DWP for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 17 in C1 of DWP for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 18 in D1 of DWP for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 19 in A2 of DWP for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 20 in A3 of DWP for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 21 in G4 of DWP for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 22 in H2 of DWP for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test viscous sample 22 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test Null Volume sample 23 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test Null Volume sample 24 in DWP for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample in a reservoir for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test sample in a capillary for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test model-less sample in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test sterile sample 1 in a 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test sterile sample 2 in a 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test itemized sachet sample 25 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test non-sterile sample 2 in a 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 1 in 100mL VolumetricFlask for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 100mL VolumetricFlask for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample in 20L Carboy for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample in 10L Carboy for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test sterile 50mL Tube 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test sterile 50mL Tube 2 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test non-sterile 50mL Tube 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test non-sterile 50mL Tube 2 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test non-sterile 50mL Tube 3 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 2mL amber glass ampoule for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test sterile sample in a 2mL amber glass ampoule for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test itemized sachet sample 25 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Item, Cap, "Test crimp cover 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Item, Cap, "Test crimp cover 2 for ExperimentTransfer" <> $SessionUUID],
					Model[Sample, "Test solvent model sample for ExperimentTransfer" <> $SessionUUID],
					Model[Sample,"Test solid model sample for ExperimentTransfer"<>$SessionUUID],
					Model[Molecule, "Test sachet filler model for ExperimentTransfer"<> $SessionUUID],
					Model[Material, "Test sachet pouch model for ExperimentTransfer"<> $SessionUUID],
					Model[Sample, "Test sachet model sample for ExperimentTransfer"<> $SessionUUID],
					Model[Method, Pipetting, "Test pipetting method for ExperimentTransfer" <> $SessionUUID],
					Model[Container, Plate, "Test plate without LiquidHandlerPrefix for ExperimentTransfer" <> $SessionUUID],
					Object[Instrument, HandlingStation, BiosafetyCabinet, "ExperimentTransfer test bsc 1 " <> $SessionUUID],
					Object[Instrument, HandlingStation, BiosafetyCabinet, "ExperimentTransfer test bsc 2 " <> $SessionUUID],
					Object[Sample, "Test cell sample 1 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 16 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 17 for ExperimentTransfer" <> $SessionUUID],
					Object[Container, WasteBin, "ExperimentTransfer test biosafety waste bin 1 " <> $SessionUUID],
					Object[Container, WasteBin, "ExperimentTransfer test biosafety waste bin 2 " <> $SessionUUID],
					Quiet[Download[Object[Protocol, StockSolution, "Fake stock solution protocol for ExperimentTransfer" <> $SessionUUID], {Object, ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]],
					Object[Protocol,FillToVolume,"Test FillToVolume Protocol for ExperimentTransfer tests"<>$SessionUUID],
					Object[Protocol,ManualSamplePreparation,"Test MSP Protocol of FillToVolume for ExperimentTransfer tests"<>$SessionUUID],
					Model[Part,HandPumpAdapter,"Test HandPumpAdapter Model for Experiment Transfer"<>$SessionUUID],
					Object[Part,HandPumpAdapter,"Test HandPumpAdapter Object for Experiment Transfer"<>$SessionUUID],
					Model[Sample, "test liquid model for ExperimentTransfer unit testing "<>$SessionUUID],
					Object[Product, "test product for ExperimentTransfer unit testing "<>$SessionUUID],
					Object[Container, Vessel, "test consolidation container 1 for ExperimentTransfer unit test "<>$SessionUUID],
					Object[Container, Vessel, "test consolidation container 2 for ExperimentTransfer unit test "<>$SessionUUID],
					Object[Container, Vessel, "test consolidation container 3 for ExperimentTransfer unit test "<>$SessionUUID],
					Object[Container, Vessel, "test consolidation container 4 for ExperimentTransfer unit test "<>$SessionUUID],
					Object[Sample, "test consolidation sample 1 for ExperimentTransfer unit test "<>$SessionUUID],
					Object[Sample, "test consolidation sample 2 for ExperimentTransfer unit test "<>$SessionUUID],
					Object[Sample, "test consolidation sample 3 for ExperimentTransfer unit test "<>$SessionUUID],
					Object[Sample, "test consolidation sample 4 for ExperimentTransfer unit test "<>$SessionUUID]
				}], ObjectP[]];

	(* Erase any objects that we failed to erase in the last unit test *)
	existsFilter = DatabaseMemberQ[allObjects];

	Quiet[EraseObject[
		PickList[
			allObjects,
			existsFilter
		],
		Force -> True,
		Verbose -> False
	]];
];


DefineTests[
	tipsCanAspirateQ,
	{
		Example[{Basic,"Serological tips should be able to aspirate from the bottom of a 50mL conical:"},
			Experiment`Private`tipsCanAspirateQ[
				Model[Item, Tips, "25 mL plastic barrier serological pipets, sterile"],
				Download[Model[Container, Vessel, "50mL Tube"]],
				2 Milliliter,
				1 Milliliter,
				Download[{Model[Item, Tips, "25 mL plastic barrier serological pipets, sterile"]}],
				Download[Model[Container, Vessel, "50mL Tube"][VolumeCalibrations]]
			],
			True
		],
		Example[{Basic,"Serological tips should be able to aspirate from the bottom of a 1L bottle:"},
			Experiment`Private`tipsCanAspirateQ[
				Model[Item, Tips, "25 mL plastic barrier serological pipets, sterile"],
				Download[Model[Container, Vessel, "1L Glass Bottle"]],
				2 Milliliter,
				1 Milliliter,
				Download[{Model[Item, Tips, "25 mL plastic barrier serological pipets, sterile"]}],
				Download[Model[Container, Vessel, "1L Glass Bottle"][VolumeCalibrations]]
			],
			True
		],
		Example[{Basic,"20uL tips will not be able to aspirate from the bottom of a 2L bottle:"},
			Experiment`Private`tipsCanAspirateQ[
				Model[Item, Tips, "20 uL barrier tips, sterile"],
				Download[Model[Container, Vessel, "2L Glass Bottle"]],
				10 Microliter,
				1 Microliter,
				Download[{Model[Item, Tips, "20 uL barrier tips, sterile"]}],
				Download[Model[Container, Vessel, "2L Glass Bottle"][VolumeCalibrations]]
			],
			False
		],
		Example[{Basic,"Serological tips cannot reach the bottom of a 10L Carboy Test 1:"},
			Experiment`Private`tipsCanAspirateQ[
				Model[Item, Tips, "25 mL plastic barrier serological pipets, sterile"],
				Download[Model[Container, Vessel, "10L Polypropylene Carboy"]],
				5 Milliliter,
				1 Milliliter,
				Download[{Model[Item, Tips, "25 mL plastic barrier serological pipets, sterile"]}],
				Download[Model[Container, Vessel, "10L Polypropylene Carboy"][VolumeCalibrations]]
			],
			False
		],
		Example[{Basic,"Serological tips cannot reach the bottom of a 10L Carboy Test 2:"},
			Experiment`Private`tipsCanAspirateQ[
				Model[Item, Tips, "25 mL plastic barrier serological pipets, sterile"],
				Download[Model[Container, Vessel, "10L Polypropylene Carboy"]],
				1000 Milliliter,
				10 Milliliter,
				Download[{Model[Item, Tips, "25 mL plastic barrier serological pipets, sterile"]}],
				Download[Model[Container, Vessel, "10L Polypropylene Carboy"][VolumeCalibrations]]
			],
			False
		],
		Example[{Basic,"Serological tips can reach the top of a 10L Carboy:"},
			Experiment`Private`tipsCanAspirateQ[
				Model[Item, Tips, "25 mL plastic barrier serological pipets, sterile"],
				Download[Model[Container, Vessel, "10L Polypropylene Carboy"]],
				9000 Milliliter,
				10 Milliliter,
				Download[{Model[Item, Tips, "25 mL plastic barrier serological pipets, sterile"]}],
				Download[Model[Container, Vessel, "10L Polypropylene Carboy"][VolumeCalibrations]]
			],
			True
		],
		Example[{Basic,"Serological tips should not be used to aspirate from any cuvette:"},
			Experiment`Private`tipsCanAspirateQ[
				Model[Item, Tips, "2 mL plastic barrier serological pipets, sterile"],
				Download[Model[Container, Cuvette, "Micro Scale UV Quartz Cuvette with Stirring"]],
				1.5 Milliliter,
				1.0 Milliliter,
				Download[{Model[Item, Tips, "2 mL plastic barrier serological pipets, sterile"]}],
				Download[Model[Container, Cuvette, "Micro Scale UV Quartz Cuvette with Stirring"][VolumeCalibrations]]
			],
			False
		]
	}
];


(* ::Subsubsection:: *)
(*ExperimentTransferOptions*)

DefineTests[
	ExperimentTransferOptions,
	{
		(* Basic Examples *)
		Example[{Basic,"Display the option values for a basic transfer with liquid samples in 50mL Tubes:"},
			ExperimentTransferOptions[
				Object[Sample,"Test Tris sample in 50mL tube (1) for ExperimentTransferOptions "<>$SessionUUID],
				Object[Sample,"Test water sample in 50mL tube (2) for ExperimentTransferOptions "<>$SessionUUID],
				1 Milliliter
			],
			_Grid,
			SetUp:>($CreatedObjects={}),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True,Verbose->False];
				Unset[$CreatedObjects]
			)
		],
		Example[{Options,PipettingMethod,"Display the option values for Robotic transfers:"},
			ExperimentTransferOptions[
				{
					Model[Sample,"Milli-Q water"],
					{1,Model[Container,Vessel,"id:bq9LA0dBGGR6"]}
				},
				{
					{1,Model[Container,Vessel,"id:bq9LA0dBGGR6"]},
					Model[Container,Vessel,"2mL Tube"]
				},
				{
					0.5 Milliliter,
					0.5 Milliliter
				},
				PipettingMethod->Model[Method,Pipetting,"DMSO"],
				Preparation->Robotic
			],
			_Grid
		],
		Example[{Options,"Display the option values for a protocol with Robitic transfers:"},
			ExperimentTransferOptions[
				{
					Model[Sample,"Milli-Q water"],
					{1,Model[Container,Vessel,"id:bq9LA0dBGGR6"]}
				},
				{
					{1,Model[Container,Vessel,"id:bq9LA0dBGGR6"]},
					Model[Container,Vessel,"2mL Tube"]
				},
				{
					0.5 Milliliter,
					0.5 Milliliter
				},
				PipettingMethod->Model[Method,Pipetting,"DMSO"],
				AspirationRate->50 Microliter/Second,
				Preparation->Robotic
			],
			_Grid
		]
	},
	SymbolSetUp:>(Module[{existsFilter,emptyContainer1,emptyContainer2, waterSample,waterSample2},
		ClearMemoization[];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter=DatabaseMemberQ[{
			Object[Container,Vessel,"Test container 1 for ExperimentTransferOptions "<>$SessionUUID],
			Object[Container,Vessel,"Test container 2 for ExperimentTransferOptions "<>$SessionUUID],
			Object[Sample,"Test Tris sample in 50mL tube (1) for ExperimentTransferOptions "<>$SessionUUID],
			Object[Sample,"Test water sample in 50mL tube (2) for ExperimentTransferOptions "<>$SessionUUID]
		}];
		EraseObject[
			PickList[
				{
					Object[Container,Vessel,"Test container 1 for ExperimentTransferOptions "<>$SessionUUID],
					Object[Container,Vessel,"Test container 2 for ExperimentTransferOptions "<>$SessionUUID],
					Object[Sample,"Test Tris sample in 50mL tube (1) for ExperimentTransferOptions "<>$SessionUUID],
					Object[Sample,"Test water sample in 50mL tube (2) for ExperimentTransferOptions "<>$SessionUUID]
				},
				existsFilter
			],
			Force->True,
			Verbose->False
		];
		(* Create some empty containers *)
		{emptyContainer1,emptyContainer2}=Upload[{
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 1 for ExperimentTransferOptions "<>$SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>,
			<|
				Type->Object[Container,Vessel],
				Model->Link[Model[Container,Vessel,"50mL Tube"],Objects],
				Name->"Test container 2 for ExperimentTransferOptions "<>$SessionUUID,
				Site->Link[$Site],
				DeveloperObject->True
			|>
		}];
		(* Create some water samples *)
		{waterSample,waterSample2}=ECL`InternalUpload`UploadSample[
			{
				Model[Sample, StockSolution, "1 M TrisHCl, pH 7.5"],
				Model[Sample,"Milli-Q water"]
			},
			{
				{"A1",emptyContainer1},
				{"A1",emptyContainer2}
			},
			InitialAmount->{40 Milliliter,20 Milliliter},
			Name->{
				"Test Tris sample in 50mL tube (1) for ExperimentTransferOptions "<>$SessionUUID,
				"Test water sample in 50mL tube (2) for ExperimentTransferOptions "<>$SessionUUID
			}
		];
		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object->waterSample,DeveloperObject->True|>,
			<|Object->waterSample2,DeveloperObject->True|>
		}];
	]
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];

(* ::Subsubsection:: *)
(*ValidExperimentTransferQ*)

DefineTests[
	ValidExperimentTransferQ,
	{
		(* Basic Examples *)
		Example[{Basic, "Check the validity for a basic transfer with liquid samples in 50mL Tubes 1:"},
			ValidExperimentTransferQ[
				Object[Sample, "Test water sample 1 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 2 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				1 Milliliter
			],
			True
		],
		Example[{Basic, "Check the validity for a basic transfer with liquid samples in 50mL Tubes 2:"},
			ValidExperimentTransferQ[
				{
					Object[Sample, "Test water sample 1 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID]
				},
				{
					Object[Sample, "Test water sample 2 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID]
				},
				{
					100 Microliter
				},
				ReplaceDestinationCover -> True,
				DestinationCover -> Model[Item, PlateSeal, "qPCR Plate Seal, Clear"]
			],
			False
		]
	},
	SetUp :> (
		$CreatedObjects = {}
	),
	TearDown :> (
		EraseObject[$CreatedObjects, Force -> True];
		Unset[$CreatedObjects]
	),
	SymbolSetUp :> (
		(* Turn off the SamplesOutOfStock warning for unit tests *)
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::DeprecatedProduct];

		Module[{allObjects, existsFilter},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects= Cases[Flatten[{
				Object[Protocol, ManualSamplePreparation, "Test MSP for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 1 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 2 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 3 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 4 for ValidExperimentTransferQ" <> $SessionUUID], (* LEAVE THIS EMPTY *)
				Object[Container,Vessel,"Test 50mL Tube 5 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 6 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 7 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 8 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 9 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 10 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 11 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 12 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 13 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 2mL Tube 1 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube 14 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test Hermetic Container 1 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test Hermetic Container 2 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Plate,"Test 96-DWP 1 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Plate,"Test 96-DWP 2 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 1 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 2 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 3 in Hermetic Container for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 4 in Hermetic Container for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test powder sample 5 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test powder sample 6 (SampleHandling->Null) in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test methanol sample 7 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test slurry sample 8 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test viscous sample 9 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test paste sample 10 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test brittle sample 11 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test fabric sample 12 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test itemized sample 13 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 14 in 2mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 15 in A1 of DWP for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 16 in B1 of DWP for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 17 in C1 of DWP for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 18 in D1 of DWP for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 19 in A2 of DWP for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 20 in A3 of DWP for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 21 in G4 of DWP for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 22 in H2 of DWP for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test viscous sample 22 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test Null Volume sample 23 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test Null Volume sample 24 in DWP for ValidExperimentTransferQ" <> $SessionUUID],
				Quiet[Download[Object[Protocol, StockSolution, "Fake stock solution protocol for ValidExperimentTransferQ" <> $SessionUUID], {Object, ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]]
			}], ObjectP[]];

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter=DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[
					allObjects,
					existsFilter
				],
				Force->True,
				Verbose->False
			]];
		];
		Module[
			{
				tube1, tube2, tube3, tube4, tube5, tube6, tube7, tube8, tube9, tube10, tube11, tube12, tube13, tube14, tube15,
				hermeticContainer1, hermeticContainer2, plate1, plate2, sample1, sample2, sample3, sample4, sample5, sample6,
				sample7, sample8, sample9, sample10, sample11, sample12, sample13, sample14, sample15, sample16, sample17,
				sample18, sample19, sample20, sample21, sample22, sample23, sample24, sample25, ssProt
			},
			Upload[<|
				Type->Object[Protocol, ManualSamplePreparation],
				Name->"Test MSP for ValidExperimentTransferQ" <> $SessionUUID
			|>];

			(* Create some empty containers. *)
			{tube1, tube2, tube3, tube4, tube5, tube6, tube7, tube8, tube9, tube10, tube11, tube12, tube13, tube14, tube15, hermeticContainer1, hermeticContainer2, plate1, plate2} = Upload[{
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 1 for ValidExperimentTransferQ" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 2 for ValidExperimentTransferQ" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 3 for ValidExperimentTransferQ" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 4 for ValidExperimentTransferQ" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 5 for ValidExperimentTransferQ" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 6 for ValidExperimentTransferQ" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 7 for ValidExperimentTransferQ" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 8 for ValidExperimentTransferQ" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 9 for ValidExperimentTransferQ" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 10 for ValidExperimentTransferQ" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 11 for ValidExperimentTransferQ" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 12 for ValidExperimentTransferQ" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
					Name -> "Test 2mL Tube 1 for ValidExperimentTransferQ" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 13 for ValidExperimentTransferQ" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 14 for ValidExperimentTransferQ" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:6V0npvmW99k1"], Objects],
					Name -> "Test Hermetic Container 1 for ValidExperimentTransferQ" <> $SessionUUID,
					Hermetic -> True,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:6V0npvmW99k1"], Objects],
					Name -> "Test Hermetic Container 2 for ValidExperimentTransferQ" <> $SessionUUID,
					Hermetic -> True,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test 96-DWP 1 for ValidExperimentTransferQ" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test 96-DWP 2 for ValidExperimentTransferQ" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>
			}];

			(* Create some samples for testing purposes *)
			{
				sample1,
				sample2,
				sample3,
				sample4,
				sample5,
				sample6,
				sample7,
				sample8,
				sample9,
				sample10,
				sample11,
				sample12,
				sample13,
				sample14,
				sample15,
				sample16,
				sample17,
				sample18,
				sample19,
				sample20,
				sample21,
				sample22,
				sample23,
				sample24,
				sample25
			} = UploadSample[
				(* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
				{
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "id:vXl9j5qEn66B"], (* "Sodium carbonate, anhydrous" *)
					Model[Sample, "id:vXl9j5qEn66B"], (* "Sodium carbonate, anhydrous" *)
					Model[Sample, "Methanol"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "id:6V0npvmqVoK1"], (* "Colgate Optic White 8321" *)
					Model[Sample, "Rink Amide ChemMatrix"], (* Brittle *)
					Model[Sample, "Milli-Q water"], (* Pretend fabric *)
					Model[Sample, "id:zGj91a7RJ5mL"], (* "Ibuprofen tablets 500 Count" *)
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"],
					Model[Sample, "Milli-Q water"]
				},
				{
					{"A1", tube1},
					{"A1", tube2},
					{"A1", hermeticContainer1},
					{"A1", hermeticContainer2},
					{"A1", tube3},
					{"A1", tube5},
					{"A1", tube6},
					{"A1", tube7},
					{"A1", tube8},
					{"A1", tube9},
					{"A1", tube10},
					{"A1", tube11},
					{"A1", tube12},
					{"A1", tube13},
					{"A1", plate1},
					{"B1", plate1},
					{"C1", plate1},
					{"D1", plate1},
					{"A2", plate1},
					{"A3", plate1},
					{"G4", plate1},
					{"H2", plate1},
					{"A1", tube14},
					{"A1", tube15},
					{"H8", plate1}
				},
				Name -> {
					"Test water sample 1 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID,
					"Test water sample 2 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID,
					"Test water sample 3 in Hermetic Container for ValidExperimentTransferQ" <> $SessionUUID,
					"Test water sample 4 in Hermetic Container for ValidExperimentTransferQ" <> $SessionUUID,
					"Test powder sample 5 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID,
					"Test powder sample 6 (SampleHandling->Null) in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID,
					"Test methanol sample 7 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID,
					"Test slurry sample 8 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID,
					"Test viscous sample 9 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID,
					"Test paste sample 10 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID,
					"Test brittle sample 11 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID,
					"Test fabric sample 12 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID,
					"Test itemized sample 13 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID,
					"Test water sample 14 in 2mL Tube for ValidExperimentTransferQ" <> $SessionUUID,
					"Test water sample 15 in A1 of DWP for ValidExperimentTransferQ" <> $SessionUUID,
					"Test water sample 16 in B1 of DWP for ValidExperimentTransferQ" <> $SessionUUID,
					"Test water sample 17 in C1 of DWP for ValidExperimentTransferQ" <> $SessionUUID,
					"Test water sample 18 in D1 of DWP for ValidExperimentTransferQ" <> $SessionUUID,
					"Test water sample 19 in A2 of DWP for ValidExperimentTransferQ" <> $SessionUUID,
					"Test water sample 20 in A3 of DWP for ValidExperimentTransferQ" <> $SessionUUID,
					"Test water sample 21 in G4 of DWP for ValidExperimentTransferQ" <> $SessionUUID,
					"Test water sample 22 in H2 of DWP for ValidExperimentTransferQ" <> $SessionUUID,
					"Test viscous sample 22 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID,
					"Test Null Volume sample 23 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID,
					"Test Null Volume sample 24 in DWP for ValidExperimentTransferQ" <> $SessionUUID
				},
				InitialAmount -> {
					25 Milliliter,
					10 Milliliter,
					1 Milliliter,
					1 Milliliter,
					10 Gram,
					10 Gram,
					10 Milliliter,
					10 Milliliter,
					10 Milliliter,
					10 Gram,
					5 Gram,
					5 Gram,
					20,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					1 Milliliter,
					20 Gram,
					Null,
					Null
				},
				SampleHandling -> {
					Liquid,
					Liquid,
					Liquid,
					Liquid,
					Powder,
					Null,
					Liquid,
					Slurry,
					Viscous,
					Paste,
					Brittle,
					Fabric,
					Itemized,
					Liquid,
					Liquid,
					Liquid,
					Liquid,
					Liquid,
					Liquid,
					Liquid,
					Liquid,
					Liquid,
					Viscous,
					Null,
					Null
				}
			];

			(* for reasons that are not totally clear to me all of a sudden this is only working if Mix -> False *)
			ssProt = ExperimentStockSolution[Model[Sample, StockSolution, "70% Ethanol"], Volume -> 100 Milliliter, Name -> "Fake stock solution protocol for ValidExperimentTransferQ" <> $SessionUUID, Mix -> False];

			(* Make some changes to our samples for testing purposes *)
			Upload[Flatten[{
				<|Object->sample1,Status->Available,DeveloperObject->True|>,
				<|Object->sample2,Status->Available,DeveloperObject->True|>,
				<|Object->sample3,Status->Available,DeveloperObject->True|>,
				<|Object->sample4,Status->Available,DeveloperObject->True|>,
				<|Object->sample5,Status->Available,DeveloperObject->True|>,
				<|Object->sample6,Status->Available,DeveloperObject->True|>,
				<|Object->sample7,Status->Available,DeveloperObject->True|>,
				<|Object->sample8,Status->Available,DeveloperObject->True|>,
				<|Object->sample9,Status->Available,DeveloperObject->True|>,
				<|Object->sample10,Status->Available,DeveloperObject->True|>,
				<|Object->sample11,Status->Available,DeveloperObject->True|>,
				<|Object->sample12,Status->Available,DeveloperObject->True|>,
				<|Object->sample13,Status->Available,DeveloperObject->True|>,
				<|Object->sample14,Status->Available,DeveloperObject->True|>,
				<|Object->sample15,Status->Available,DeveloperObject->True|>,
				<|Object->sample16,Status->Available,DeveloperObject->True|>,
				<|Object->sample17,Status->Available,DeveloperObject->True|>,
				<|Object->sample18,Status->Available,DeveloperObject->True|>,
				<|Object->sample19,Status->Available,DeveloperObject->True|>,
				<|Object->sample20,Status->Available,DeveloperObject->True|>,
				<|Object->sample21,Status->Available,DeveloperObject->True|>,
				<|Object->sample22,Status->Available,DeveloperObject->True|>,
				<|Object->sample23,Status->Available,DeveloperObject->True|>,
				<|Object->sample24,Status->Available,DeveloperObject->True|>,
				<|Object->sample25,Status->Available,DeveloperObject->True|>,
				<|Object -> #, DeveloperObject -> True|>& /@ Quiet[Cases[Flatten[Download[ssProt, {Object, ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]], ObjectReferenceP[]]]
			}]];
		]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::DeprecatedProduct];
		Module[{allObjects, existsFilter},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects= Cases[Flatten[{
				Object[Protocol, ManualSamplePreparation, "Test MSP for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 1 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 2 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 3 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 4 for ValidExperimentTransferQ" <> $SessionUUID], (* LEAVE THIS EMPTY *)
				Object[Container,Vessel,"Test 50mL Tube 5 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 6 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 7 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 8 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 9 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 10 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 11 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 12 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 13 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test 2mL Tube 1 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container, Vessel, "Test 50mL Tube 14 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test Hermetic Container 1 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Vessel,"Test Hermetic Container 2 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Plate,"Test 96-DWP 1 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Container,Plate,"Test 96-DWP 2 for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 1 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 2 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 3 in Hermetic Container for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 4 in Hermetic Container for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test powder sample 5 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test powder sample 6 (SampleHandling->Null) in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test methanol sample 7 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test slurry sample 8 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test viscous sample 9 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test paste sample 10 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test brittle sample 11 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test fabric sample 12 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test itemized sample 13 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 14 in 2mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 15 in A1 of DWP for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 16 in B1 of DWP for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 17 in C1 of DWP for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 18 in D1 of DWP for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 19 in A2 of DWP for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 20 in A3 of DWP for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 21 in G4 of DWP for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test water sample 22 in H2 of DWP for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test viscous sample 22 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test Null Volume sample 23 in 50mL Tube for ValidExperimentTransferQ" <> $SessionUUID],
				Object[Sample, "Test Null Volume sample 24 in DWP for ValidExperimentTransferQ" <> $SessionUUID],
				Quiet[Download[Object[Protocol, StockSolution, "Fake stock solution protocol for ValidExperimentTransferQ" <> $SessionUUID], {Object, ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]]
			}], ObjectP[]];

			(* Erase any objects that we failed to erase in the last unit test *)
			existsFilter=DatabaseMemberQ[allObjects];

			Quiet[EraseObject[
				PickList[
					allObjects,
					existsFilter
				],
				Force->True,
				Verbose->False
			]];
		]
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];



(* ::Subsubsection:: *)
(*Transfer*)


DefineTests[
	Transfer,
	{
		Example[{Basic, "Perform a basic transfer with liquid samples in 50mL Tubes:"},
			Experiment[
				{
					Transfer[
						Source -> Object[Sample, "Test Tris sample in 50mL tube (1) for Transfer unit test "<>$SessionUUID],
						Destination -> Object[Sample, "Test water sample in 50mL tube (2) for Transfer unit test "<>$SessionUUID],
						Amount -> 1 Milliliter
					]
				}
			],
			ObjectP[Object[Protocol]]
		],
		Example[{Basic, "Perform Robotic transfers:"},
			ExperimentRoboticSamplePreparation[
				{
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> Model[Container, Vessel, "2mL Tube"],
						Amount -> 0.5 Milliliter,
						PipettingMethod -> Model[Method, Pipetting, "DMSO"]
					]
				}
			],
			ObjectP[Object[Protocol, RoboticSamplePreparation]]
		]
	},
	SymbolSetUp :> (Module[{existsFilter, emptyContainer1, emptyContainer2, waterSample, waterSample2},
		ClearMemoization[];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects = {};
		(* IMPORTANT: Make sure that any objects you upload have DeveloperObject\[Rule]True. *)
		(* Erase any objects that we failed to erase in the last unit test. *)
		existsFilter = DatabaseMemberQ[{
			Object[Container, Vessel, "Test container 1 for Transfer unit test "<>$SessionUUID],
			Object[Container, Vessel, "Test container 2 for Transfer unit test "<>$SessionUUID],
			Object[Sample, "Test Tris sample in 50mL tube (1) for Transfer unit test "<>$SessionUUID],
			Object[Sample, "Test water sample in 50mL tube (2) for Transfer unit test "<>$SessionUUID]
		}];
		EraseObject[
			PickList[
				{
					Object[Container, Vessel, "Test container 1 for Transfer unit test "<>$SessionUUID],
					Object[Container, Vessel, "Test container 2 for Transfer unit test "<>$SessionUUID],
					Object[Sample, "Test Tris sample in 50mL tube (1) for Transfer unit test "<>$SessionUUID],
					Object[Sample, "Test water sample in 50mL tube (2) for Transfer unit test "<>$SessionUUID]
				},
				existsFilter
			],
			Force -> True,
			Verbose -> False
		];
		(* Create some empty containers *)
		{emptyContainer1, emptyContainer2} = Upload[{
			<|
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
				Name -> "Test container 1 for Transfer unit test "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>,
			<|
				Type -> Object[Container, Vessel],
				Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
				Name -> "Test container 2 for Transfer unit test "<>$SessionUUID,
				Site -> Link[$Site],
				DeveloperObject -> True
			|>
		}];
		(* Create some water samples *)
		{waterSample, waterSample2} = ECL`InternalUpload`UploadSample[
			{
				Model[Sample, StockSolution, "1 M TrisHCl, pH 7.5"],
				Model[Sample, "Milli-Q water"]
			},
			{
				{"A1", emptyContainer1},
				{"A1", emptyContainer2}
			},
			InitialAmount -> {40 Milliliter, 20 Milliliter},
			Name -> {
				"Test Tris sample in 50mL tube (1) for Transfer unit test "<>$SessionUUID,
				"Test water sample in 50mL tube (2) for Transfer unit test "<>$SessionUUID
			}
		];
		(* Make some changes to our samples to make them invalid. *)
		Upload[{
			<|Object -> waterSample, DeveloperObject -> True|>,
			<|Object -> waterSample2, DeveloperObject -> True|>
		}];
	]
	),
	SymbolTearDown :> (
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects, Force -> True, Verbose -> False];
	),
	Stubs :> {
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	}
];