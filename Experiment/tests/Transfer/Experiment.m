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
					WaterPurifier -> Null,
					HandPump -> Null,
					QuantitativeTransfer -> Null,
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
				Download[Model[Method, Pipetting, "DMSO"],CorrectionCurve]
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
			KeyValuePattern[{AspirationMixVolume->ListableP[VolumeP]}]
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
			ObjectP[Object[Protocol, ManualSamplePreparation]]
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
				Balance->{Model[Instrument, Balance, "id:vXl9j5qEnav7"], Model[Instrument, Balance, "id:vXl9j5qEnav7"], Null},
				TransferEnvironment->Model[Instrument, BiosafetyCabinet, "id:dORYzZJzEBdE"]
			],
			$Failed,
			Messages:>{
				Error::TransferEnvironmentBalanceCombination,
				Error::InvalidOption
			}
		],
		Test["Using a pipette that should already be in the BSC will result in us requesting not to pick it up front:",
			Module[{protocol},
				(* Put a "Eppendorf Research Plus P200, Tissue Culture" in the BSC so that it doesn't get picked up front. *)
				UploadLocation[Object[Instrument, Pipette, "id:O81aEBZDbB7D"], {"Work Surface", Object[Instrument, BiosafetyCabinet, "id:Y0lXejMaxDwV"]}];

				Upload[<|
					Object->Object[Instrument, BiosafetyCabinet, "id:Y0lXejMaxDwV"],
					Append[Pipettes]->Link[Object[Instrument, Pipette, "id:O81aEBZDbB7D"]]
				|>];

				protocol=ExperimentTransfer[
					Object[Sample, "Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					Object[Sample, "Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
					100 Microliter,
					Instrument -> Model[Instrument, Pipette, "id:xRO9n3BqKznz"],
					TransferEnvironment -> Model[Instrument, BiosafetyCabinet, "id:dORYzZJzEBdE"],
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
				{{NonMicrobial}},
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
				TransferEnvironment -> Object[Container, Bench, "Test bench for ExperimentTransfer tests" <> $SessionUUID],
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
				TransferEnvironment -> Object[Container, Bench, "Test bench for ExperimentTransfer tests" <> $SessionUUID],
				InSitu -> True
			];
			Lookup[Download[protocol, ResolvedUnitOperationOptions[[1]]], InSitu],
			True,
			Variables :> {protocol}
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
					WaterPurifier -> Null,
					HandPump -> Null,
					QuantitativeTransfer -> Null,
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
		Example[{Basic,"Transferring into a crimped container using a pipette should result in pipette usage and the destination container ot be unsealed and replaced with a new cover:"},
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
				Instrument->Model[Instrument,Pipette,"Eppendorf Research Plus P200, Tissue Culture"],
				Output-> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					Instrument -> ListableP[ObjectP[Model[Instrument, Pipette]]],
					Tips -> ListableP[ObjectP[Model[Item, Tips]]],
					TipType -> ListableP[TipTypeP],
					TipMaterial -> ListableP[MaterialP],
					Needle -> Null,
					WeighingContainer -> Null,
					Tolerance -> Null,
					WaterPurifier -> Null,
					HandPump -> Null,
					QuantitativeTransfer -> Null,
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
					WaterPurifier -> Null,
					HandPump -> Null,
					QuantitativeTransfer -> Null,
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
		Example[{Options,QuantitativeTransfer,"Quantitative Transfer using 2 Milliliter of Milli-Q Water"},
			ExperimentTransfer[
				{
					Model[Sample, "id:mnk9jOkmavPY"]
				},
				{
					Model[Container, Vessel, VolumetricFlask, "id:kEJ9mqRNvwNE"]
				},
				{
					12 Milligram
				},
				QuantitativeTransfer -> True,
				QuantitativeTransferWashSolution -> Model[Sample,"id:8qZ1VWNmdLBD"],
				QuantitativeTransferWashVolume -> 2 Milliliter,
				NumberOfQuantitativeTransferWashes -> 2,
				QuantitativeTransferWashTips -> Model[Item,Tips,"id:mnk9jO3qD6R7"],
				Output-> {Result,Options}
			],

			{ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					QuantitativeTransfer -> True,
					QuantitativeTransferWashVolume->2 Milliliter,
					NumberOfQuantitativeTransferWashes->2,
					QuantitativeTransferWashTips->Model[Item,Tips,"id:mnk9jO3qD6R7"]}
				]}
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
							{100 VolumePercent, Link[Model[Molecule, Oligomer, "id:54n6evLldkal"]]}
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
							{90 VolumePercent, Link[Model[Molecule,"id:qdkmxzq6W6Ba"]]},
							{10 VolumePercent, Link[Model[Molecule, Oligomer, "id:54n6evLldkal"]]}
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
							{10 VolumePercent, Link[Model[Molecule,"id:qdkmxzq6W6Ba"]]},
							{90 VolumePercent, Link[Model[Molecule, Oligomer, "id:54n6evLldkal"]]}
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
		Example[{Additional,"A single transfer of Model[Sample, \"Milli-Q water\"] over 50mL will result in us directly using a graduated cylinder and a water purifier:"},
			ExperimentTransfer[
				Model[Sample, "Milli-Q water"],
				PreferredContainer[100 Milliliter],
				55 Milliliter,
				Output -> {Result, Options}
			],
			{
				ObjectP[Object[Protocol, ManualSamplePreparation]],
				KeyValuePattern[{
					Instrument -> ObjectP[Model[Container, GraduatedCylinder]],
					WaterPurifier -> ObjectP[{Model[Instrument, WaterPurifier], Object[Instrument, WaterPurifier]}]
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
					Instrument->ObjectP[Model[Instrument, Pipette]],
					WaterPurifier->Null
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
					WaterPurifier -> Null,
					HandPump -> Null,
					QuantitativeTransfer -> Null,
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
					WaterPurifier -> Null,
					HandPump -> Null,
					QuantitativeTransfer -> Null,
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
					WaterPurifier -> Null,
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
					WaterPurifier -> Null,
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
					WaterPurifier -> Null,
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
				TransferEnvironment->Model[Instrument, GloveBox, "id:jLq9jXvjaXOa"],
				Output -> Options
			],
			KeyValuePattern[{
				Instrument -> ObjectP[Model[Instrument, Pipette]],
				TransferEnvironment->Model[Instrument, GloveBox, "id:jLq9jXvjaXOa"],
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
				TransferEnvironment->Model[Container, Bench, "id:pZx9jonGJJqM"],
				Tips->Model[Item, Tips, "id:8qZ1VWNw1z0X"],
				SterileTechnique->True,
				Output -> Options
			],
			KeyValuePattern[{
				Instrument -> ObjectP[Model[Instrument, Pipette]],
				TransferEnvironment->Model[Container, Bench, "id:pZx9jonGJJqM"],
				Tips -> ObjectP[Model[Item, Tips]],
				SterileTechnique->True
			}],
			Messages :> {
				Message[Error::SterileTransfersAreInBSC],
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
				Message[Error::AspiratorRequiresSterileTransfer],
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
				TransferEnvironment->Model[Container, Bench, "id:pZx9jonGJJqM"],
				BackfillGas->Argon,
				Output -> Options
			],
			KeyValuePattern[{
				TransferEnvironment->Model[Container, Bench, "id:pZx9jonGJJqM"],
				BackfillGas->Argon
			}],
			Messages :> {
				Message[Error::InvalidBackfillGas],
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
				TransferEnvironment->Model[Instrument, GloveBox, "id:jLq9jXvjaXOa"],
				Output -> Options
			],
			KeyValuePattern[{
				Instrument -> ObjectP[Model[Instrument, Pipette]],
				TransferEnvironment->Model[Instrument, GloveBox, "id:jLq9jXvjaXOa"],
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
				Balance -> ObjectP[Model[Instrument, Balance, "id:vXl9j5qEnav7"]],
				WeighingContainer -> ObjectP[]
			}]
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
		(* Rounding is a little messed up right now. Investigate SafeRound. *)
		(*Example[{Messages,"RoundedTransferAmount","The amount transferred will be rounded if it is not achievable by the Resolution of the transfer devices at the ECL for the given mass/volume range:"},
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
		],*)
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
		Example[{Messages,"TabletCrusherRequired","A pill crusher will be used if a transfer amount is given as a mass when SampleHandling->Itemized:"},
			ExperimentTransfer[
				{
					Object[Sample, "Test itemized sample 13 in 50mL Tube for ExperimentTransfer" <> $SessionUUID]
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
		Example[{Messages,"InvalidTransferTemperatureGloveBox","Transfer in the glove box cannot have a SourceTemperature/DestinationTemperature:"},
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
				TransferEnvironment->Model[Instrument, GloveBox, "id:jLq9jXvjaXOa"],
				SourceTemperature -> 30 Celsius,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::InvalidTransferTemperatureGloveBox],
				Message[Warning::NonAnhydrousSample],
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
		Example[{Messages,"InvalidTransferTemperatureGloveBox","Transfer in the glove box cannot have a SourceTemperature/DestinationTemperature:"},
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
				TransferEnvironment->Model[Instrument, GloveBox, "id:jLq9jXvjaXOa"],
				SourceTemperature -> 30 Celsius,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::InvalidTransferTemperatureGloveBox],
				Message[Warning::NonAnhydrousSample],
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
				Message[Error::InvalidBackfillGas],
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
		Example[{Messages,"QuantitativeTransferOptions","A message is thrown if only some of the quantitative transfer options are set:"},
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
				QuantitativeTransfer->True,
				NumberOfQuantitativeTransferWashes->Null,
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::QuantitativeTransferOptions],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"InvalidWaterPurifier","A message is thrown if a non-water transfer over 3mL is done, but a water purifier is specified 1:"},
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
				WaterPurifier->Model[Instrument, WaterPurifier, "id:eGakld01zVXG"],
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::InvalidWaterPurifier],
				Message[Error::InvalidOption]
			}
		],
		Example[{Messages,"InvalidWaterPurifier","A message is thrown if a non-water transfer over 3mL is done, but a water purifier is specified 2:"},
			ExperimentTransfer[
				{
					Model[Sample, "Milli-Q water"]
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
				WaterPurifier->Model[Instrument, WaterPurifier, "id:eGakld01zVXG"],
				Output -> Options
			],
			KeyValuePattern[{}],
			Messages :> {
				Message[Error::InvalidWaterPurifier],
				Message[Error::InvalidOption]
			}
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
					OptimizeUnitOperations->False,
					Debug->True
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
				NumberOfAspirationMixes -> 10,
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
			}
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
		Block[{$Notebook=Null},
			Module[{allObjects, existsFilter},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects= Cases[Flatten[{
				Object[Container, Bench, "Test bench for ExperimentTransfer tests" <> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test discarded 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 1 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 2 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 3 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID], (* LEAVE THIS EMPTY *)
				Object[Container,Vessel,"Test 50mL Tube 5 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 6 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 7 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 8 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 9 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 10 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 11 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 12 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 13 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 2mL Tube 1 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 14 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 15 for ExperimentTransfer"<> $SessionUUID],
				Object[Container,Vessel,"Test Hermetic Container 1 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test Hermetic Container 2 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Plate,"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Plate,"Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Plate, "Test 96-DWP 3 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Plate, "Test 96-DWP 4 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Plate, "Test 96-DWP 5 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Plate,"Test reservoir for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Plate,"Test reservoir 2 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Capillary,"Test capillary 1 for ExperimentTransfer" <> $SessionUUID],
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
				Object[Sample, "Test itemized sample 13 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
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
				Model[Sample, "Test solvent model sample for ExperimentTransfer" <> $SessionUUID],
				Model[Method, Pipetting, "Test pipetting method for ExperimentTransfer" <> $SessionUUID],
				Model[Container, Plate, "Test plate without LiquidHandlerPrefix for ExperimentTransfer" <> $SessionUUID],
				Quiet[Download[Object[Protocol, StockSolution, "Fake stock solution protocol for ExperimentTransfer" <> $SessionUUID], {Object, ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]]
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
				tube1, tube2, tube3, tube4, tube5, tube6, tube7, tube8, tube9, tube10, tube11, tube12, tube13, tube14, tube15, tube16,
				hermeticContainer1, hermeticContainer2, plate1, plate2, capillary1, ssProt, method, plateModel,
				testBench, allContainers, solventSampleModel, reservoir1, plate3, plate4, reservoir2, plate5, createdSamples, capillarySample, discardedTube
			},
			Upload[<|
				Type->Object[Protocol, ManualSamplePreparation],
				Name->"Test MSP for ExperimentTransfer" <> $SessionUUID,
				Author -> Link[$PersonID, ProtocolsAuthored],
				Site -> Link[$Site]
			|>];

				testBench = Upload[<|Type -> Object[Container, Bench], Name -> "Test bench for ExperimentTransfer tests" <> $SessionUUID, DeveloperObject -> True, Site -> Link[$Site], Model -> Link[Model[Container, Bench, "The Bench of Testing"], Objects]|>];

			(* Create some empty containers. *)
			allContainers = Upload[{
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test discarded 50mL Tube for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 1 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 2 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 3 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 5 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 6 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 7 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 8 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 9 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 10 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 11 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 12 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
					Name -> "Test 2mL Tube 1 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 13 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 14 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Name -> "Test 50mL Tube 15 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:6V0npvmW99k1"], Objects],
					Name -> "Test Hermetic Container 1 for ExperimentTransfer" <> $SessionUUID,
					Hermetic -> True,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "id:6V0npvmW99k1"], Objects],
					Name -> "Test Hermetic Container 2 for ExperimentTransfer" <> $SessionUUID,
					Hermetic -> True,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test 96-DWP 3 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test 96-DWP 4 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Name -> "Test 96-DWP 5 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "id:54n6evLWKqbG"], Objects],(*"200mL Polypropylene Robotic Reservoir, non-sterile"*)
					Name -> "Test reservoir for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "id:54n6evLWKqbG"], Objects],(*"200mL Polypropylene Robotic Reservoir, non-sterile"*)
					Name -> "Test reservoir 2 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True,
					Site -> Link[$Site]
				|>,
				<|
					Type -> Object[Container, Capillary],
					Model -> Link[Model[Container, Capillary, "Melting point capillary"], Objects],
					Name -> "Test capillary 1 for ExperimentTransfer" <> $SessionUUID,
					DeveloperObject -> True
				|>
			}];
			{
				discardedTube,
				tube1,
				tube2,
				tube3,
				tube4,
				tube5,
				tube6,
				tube7,
				tube8,
				tube9,
				tube10,
				tube11,
				tube12,
				tube13,
				tube14,
				tube15,
				tube16,
				hermeticContainer1,
				hermeticContainer2,
				plate1,
				plate2,
				plate3,
				plate4,
				plate5,
				reservoir1,
				reservoir2,
				capillary1
			} = allContainers;
			UploadLocation[allContainers, ConstantArray[{"Work Surface", testBench}, Length[allContainers]], FastTrack -> True];

			UploadSampleStatus[Object[Container,Vessel,"Test discarded 50mL Tube for ExperimentTransfer" <> $SessionUUID], Discarded, FastTrack -> True];

			(* Create test solvent sample model *)
			solventSampleModel = UploadSampleModel[
				"Test solvent model sample for ExperimentTransfer" <> $SessionUUID,
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
				MSDSRequired -> False,
				IncompatibleMaterials -> {None},
				PipettingMethod -> Model[Method, Pipetting, "id:4pO6dM5OV9vr"]
			];

				(* Create some samples for testing purposes *)
				createdSamples = UploadSample[
					(* NOTE: We over-ride the SampleHandling of these models so that we get consistent test results. *)
					Join[{
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
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"],
						Model[Sample, "Milli-Q water"]
					},
						ConstantArray[Model[Sample,"Milli-Q water"],96]
						],
					Join[{
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
						{"A1", tube16},
						{"H8", plate1},
						{"A1", reservoir1}
					},
						({#,plate3}&/@Flatten@AllWells[])
						],
					Name -> Join[{
						"Test water sample 1 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						"Test water sample 2 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						"Test water sample 3 in Hermetic Container for ExperimentTransfer" <> $SessionUUID,
						"Test water sample 4 in Hermetic Container for ExperimentTransfer" <> $SessionUUID,
						"Test powder sample 5 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						"Test powder sample 6 (SampleHandling->Null) in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						"Test methanol sample 7 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						"Test slurry sample 8 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						"Test viscous sample 9 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						"Test paste sample 10 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						"Test brittle sample 11 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						"Test fabric sample 12 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						"Test itemized sample 13 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						"Test water sample 14 in 2mL Tube for ExperimentTransfer" <> $SessionUUID,
						"Test water sample 15 in A1 of DWP for ExperimentTransfer" <> $SessionUUID,
						"Test water sample 16 in B1 of DWP for ExperimentTransfer" <> $SessionUUID,
						"Test water sample 17 in C1 of DWP for ExperimentTransfer" <> $SessionUUID,
						"Test water sample 18 in D1 of DWP for ExperimentTransfer" <> $SessionUUID,
						"Test water sample 19 in A2 of DWP for ExperimentTransfer" <> $SessionUUID,
						"Test water sample 20 in A3 of DWP for ExperimentTransfer" <> $SessionUUID,
						"Test water sample 21 in G4 of DWP for ExperimentTransfer" <> $SessionUUID,
						"Test water sample 22 in H2 of DWP for ExperimentTransfer" <> $SessionUUID,
						"Test viscous sample 22 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						"Test Null Volume sample 23 in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						"Test model-less sample in 50mL Tube for ExperimentTransfer" <> $SessionUUID,
						"Test Null Volume sample 24 in DWP for ExperimentTransfer" <> $SessionUUID,
						"Test water sample in a reservoir for ExperimentTransfer" <> $SessionUUID
					},
						ConstantArray[Null, 96]
						],
					InitialAmount -> Join[{
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
						25 Milliliter,
						Null,
						200 Milliliter
					},
						ConstantArray[1 Milliliter, 96]
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
						Liquid
					},
						ConstantArray[Liquid, 96]
						]
				];

			(* FastTrack should be True for this sample due to footprinted destination *)
			capillarySample = UploadSample[
				Model[Sample, "Sodium Chloride"],
				{"A1", capillary1},
				FastTrack -> True,
				InitialAmount -> 5 Milligram,
				Name -> "Test sample in a capillary for ExperimentTransfer" <> $SessionUUID
			];

			(* for reasons that are not totally clear to me all of a sudden this is only working if Mix -> False *)
			ssProt = ExperimentStockSolution[Model[Sample, StockSolution, "70% Ethanol"], Volume -> 100 Milliliter, Name -> "Fake stock solution protocol for ExperimentTransfer" <> $SessionUUID, Mix -> False];

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

				plateModel=Upload[<|
					Type->Model[Container,Plate],
					Footprint->Plate,
					Name->"Test plate without LiquidHandlerPrefix for ExperimentTransfer" <> $SessionUUID,
					Replace[PositionPlotting] -> {
						<|Name -> "A1", XOffset -> Quantity[0.063295, "Meters"], YOffset -> Quantity[0.043395, "Meters"], ZOffset -> Quantity[0.0011, "Meters"], CrossSectionalShape -> Rectangle, Rotation -> 0.|>
					},
					Replace[Positions] -> {
						<|Name -> "A1", Footprint -> Null, MaxWidth -> Quantity[0.12159, "Meters"], MaxDepth -> Quantity[0.07931, "Meters"], MaxHeight -> Quantity[0.03675, "Meters"]|>},
					DeveloperObject -> True
				|>];

				(* Make some changes to our samples for testing purposes *)
				Upload[Flatten[{
					<|
						Object -> solventSampleModel, DeveloperObject -> True
					|>,
					<|Object->#, Status->Available, DeveloperObject->True|>&/@createdSamples,
					<|Object -> #, DeveloperObject -> True|>& /@ Quiet[Cases[Flatten[Download[ssProt, {Object, ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]], ObjectReferenceP[]]],
					(* Remove Model and PipettingMethod for one sample for testing *)
					<|
						Object->Object[Sample, "Test model-less sample in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
						Model->Null,
						Solvent->Null,
						PipettingMethod->Null
					|>,
					<|Object->method,Name->"Test pipetting method for ExperimentTransfer" <> $SessionUUID,DeveloperObject->True|>
				}]];
			]
		]
		),

		SymbolTearDown :> (
			On[Warning::SamplesOutOfStock];
			On[Warning::InstrumentUndergoingMaintenance];
			On[Warning::DeprecatedProduct];
			Module[{allObjects, existsFilter},

			(* Define a list of all of the objects that are created in the SymbolSetUp - containers, samples, models, etc. *)
			allObjects= Cases[Flatten[{
				Object[Container, Bench, "Test bench for ExperimentTransfer tests" <> $SessionUUID],
				Object[Protocol, ManualSamplePreparation, "Test MSP for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test discarded 50mL Tube for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 1 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 2 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 3 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 4 for ExperimentTransfer" <> $SessionUUID], (* LEAVE THIS EMPTY *)
				Object[Container,Vessel,"Test 50mL Tube 5 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 6 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 7 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 8 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 9 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 10 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 11 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 12 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 13 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 2mL Tube 1 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 14 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test 50mL Tube 15 for ExperimentTransfer"<> $SessionUUID],
				Object[Container,Vessel,"Test Hermetic Container 1 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Vessel,"Test Hermetic Container 2 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Plate,"Test 96-DWP 1 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Plate,"Test 96-DWP 2 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Plate, "Test 96-DWP 3 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Plate, "Test 96-DWP 4 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Plate, "Test 96-DWP 5 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Plate,"Test reservoir for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Plate,"Test reservoir 2 for ExperimentTransfer" <> $SessionUUID],
				Object[Container,Capillary,"Test capillary 1 for ExperimentTransfer" <> $SessionUUID],
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
				Object[Sample, "Test itemized sample 13 in 50mL Tube for ExperimentTransfer" <> $SessionUUID],
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
				Model[Sample, "Test solvent model sample for ExperimentTransfer" <> $SessionUUID],
				Model[Method, Pipetting, "Test pipetting method for ExperimentTransfer" <> $SessionUUID],
				Model[Container, Plate, "Test plate without LiquidHandlerPrefix for ExperimentTransfer" <> $SessionUUID],
				Quiet[Download[Object[Protocol, StockSolution, "Fake stock solution protocol for ExperimentTransfer" <> $SessionUUID], {Object, ProcedureLog[Object], RequiredResources[[All, 1]][Object]}]]
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
	Stubs:>{
		$AllowPublicObjects=True,
		$PersonID=Object[User,"Test user for notebook-less test protocols"]
	}
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