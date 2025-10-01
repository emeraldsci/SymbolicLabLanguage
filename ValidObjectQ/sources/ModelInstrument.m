(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*validModelInstrumentQTests*)


validModelInstrumentQTests[packet:PacketP[Model[Instrument]]] := {

	(* General fields filled in *)
	NotNullFieldTest[packet,{
			Authors,
			ImageFile,
			Manufacturer,
			UserManualFiles,
			HazardCategories,
			AsepticHandling,
			CrossSectionalShape,
			Dimensions,
			PowerType,
			Name,
			PricingRate
		}
	],

	(* Check all necessary power requirements are supplied *)
	Test[
		"If the instrument uses batteries, BatteryRequirements are supplied:",
		Module[{powerType,batteryRequirements},
			{powerType,batteryRequirements}=Lookup[packet,{PowerType,BatteryRequirements}];
			If[MemberQ[powerType,Battery],
				batteryRequirements!={},
				True
			]
		],
		True
	],
	Test[
		"If the instrument uses electrical outlets, PlugRequirements and PowerConsumption are supplied:",
		Module[{powerType,plugRequirements,powerConsumption},
			{powerType,plugRequirements,powerConsumption}=Lookup[packet,{PowerType,PlugRequirements,PowerConsumption}];
			If[MemberQ[powerType,Plug],
				plugRequirements!={} && !NullQ[powerConsumption],
				True
			]
		],
		True
	],
	Test[
		"If the instrument does not use batteries, no BatteryRequirements are supplied:",
		Module[{powerType,batteryRequirements},
		{powerType,batteryRequirements}=Lookup[packet,{PowerType,BatteryRequirements}];
			If[!MemberQ[powerType,Battery],
				batteryRequirements=={},
				True
			]
		],
		True
	],
	Test[
		"If the instrument does not use electrical outlets, PlugRequirements are not supplied:",
		Module[{powerType,plugRequirements},
		{powerType,plugRequirements}=Lookup[packet,{PowerType,PlugRequirements}];
			If[!MemberQ[powerType,Plug],
				plugRequirements=={},
				True
			]
		],
		True
	],
	Test[
		"If the instrument does not require a power source, PowerConsumption, BatteryRequirements and PlugRequirements are not supplied:",
		Module[{batteryRequirements,plugRequirements,powerConsumption},
		{batteryRequirements,plugRequirements,powerConsumption}=Lookup[packet,{BatteryRequirements,PlugRequirements,PowerConsumption}];
			If[MemberQ[powerType,None],
				batteryRequirements=={} && plugRequirements=={} && powerConsumption==Null,
				True
			]
		],
		True
	],
	Test[
		"If None is selected as the power type, no other options should be selected:",
		Module[{powerType},
		powerType=Lookup[packet,PowerType];
		If[MemberQ[powerType,None],
			Length[powerType]===1,
				True
			]
		],
		True
	],

	Test["If there are associated instruments and all their statuses are inactive, the model must be deprecated. If any of the instruments are active, the model cannot be deprecated:",
		Module[{instruments,deprecated,statuses},
			{instruments, deprecated}=Lookup[packet,{Objects,Deprecated}];

			If[MatchQ[instruments,{ObjectP[Object[Instrument]]..}],

				statuses=Download[instruments, Status];
				Or[
					MatchQ[DeleteDuplicates[Flatten[statuses]],{Retired}] && MatchQ[deprecated,True],
					MemberQ[Flatten[statuses],DeleteCases[InstrumentStatusP,Retired]] && MatchQ[deprecated,Except[True]]
				],
				True
			]
		],
		True
	],

	Test["If AsepticTechniqueEnvironment is set to True and CultureHandling is not Null, AsepticHandling must be True:",
		If[TrueQ[Lookup[packet,AsepticTechniqueEnvironment]] && !NullQ[Lookup[packet,CultureHandling]],
			TrueQ[Lookup[packet,AsepticHandling]],
			True
		],
		True
	],

	Test["If AsepticTechniqueEnvironment is set to True, the instrument model must contains non-empty Positions:",
		If[TrueQ[Lookup[packet,AsepticTechniqueEnvironment]],
			!MatchQ[Lookup[packet,Positions],{}],
			True
		],
		True
	],

	Test["If Sterile is set to True, AsepticHandling must be True:",
		If[TrueQ[Lookup[packet,Sterile]],
			TrueQ[Lookup[packet,AsepticHandling]],
			True
		],
		True
	],

	Test[
		"If None is selected as a hazard category, nothing else is selected:",
		Module[{hazardCategories},
		hazardCategories=Lookup[packet,HazardCategories];
		If[MemberQ[(hazardCategories),Standard],
			Length[hazardCategories]===1,
				True
			]
		],
		True
	],

	Test["The DefaultDataFilePath is distinct from the DataFilePath populated for objects of this model:",
		Module[{defaultPath,paths},
			{defaultPath,paths}=Download[packet,{DefaultDataFilePath,Objects[DataFilePath]}];
			(* None of the paths should be the same as defaultPath *)
			MatchQ[defaultPath,Null] || !MemberQ[paths,defaultPath]
		],
		True
	],

	Test["The DefaultMethodFilePath is distinct from the MethodFilePath populated for objects of this model:",
		Module[{defaultPath,paths},
			{defaultPath,paths}=Download[packet,{DefaultMethodFilePath,Objects[MethodFilePath]}];
			(* None of the paths should be the same as defaultPath *)
			MatchQ[defaultPath,Null] || !MemberQ[paths,defaultPath]
		],
		True
	],

	(* all non-deprecated instrument models need PricingCategory for the billing *)
	Test["When the model is not deprecated, PricingCategory is filled out:",
		If[MatchQ[Lookup[packet,Deprecated],Except[True]],
			MatchQ[Lookup[packet,PricingCategory],PricingCategoryP],
			True
		],
		True
	],

	(* all non-deprecated instrument models need PricingLevel for the billing *)
	Test["When the model is not deprecated, PricingLevel is filled out (ask the Business Development team if you're unsure):",
		If[MatchQ[Lookup[packet,Deprecated],Except[True]],
			MatchQ[Lookup[packet,PricingLevel],_Integer],
			True
		],
		True
	],

	Test["If Mobile is True, the instrument or its model has StoragePositions and DefaultStorageCondition set:",
		{
			Lookup[packet,Mobile],
			Lookup[packet,StoragePositions][[All,1]],
			Lookup[packet,DefaultStorageCondition]
		},
		Alternatives[
			(* if explicitly true, the model must have storage info *)
			{True,{ObjectP[]..},ObjectP[]},
			(* if not true, no storage info is required *)
			{Except[True],_,_}
		]
	],

	(* all non-deprecated instrument models need QualificationRequired *)
	Test["When the model is not deprecated, QualificationRequired is filled out:",
		If[MatchQ[Lookup[packet,Deprecated],Except[True]],
			MatchQ[Lookup[packet,QualificationRequired],BooleanP],
			True
		],
		True
	],

	Test["If the StorageOrientation is Side|Face StorageOrientationImage must be populated:",
		Lookup[packet, {StorageOrientation, StorageOrientationImage}],
		Alternatives[
			{(Side|Face), ObjectP[]},
			{Except[(Side|Face)], _}
		]
	],
	Test["If the StorageOrientation is Upright StorageOrientationImage or ImageFile must be populated:",
		Lookup[packet, {StorageOrientation, StorageOrientationImage, ImageFile}],
		Alternatives[
			{Upright, ObjectP[], _},
			{Upright, _, ObjectP[]},
			{Except[Upright], _, _}
		]
	],


	(* ---------- Finer-grained tests for container validity (see modelContainer) ---------- *)

	(* Must require these together in Model[Instrument], unlike Model[Container] where they're just straight required,
		because not all Model[Instrument]s have positions. *)
	RequiredTogetherTest[packet, {Positions, PositionPlotting}],

	containerModelImageAspectRatio[packet],
	containerModelPositionsDimensionsValid[packet]
};



(* ::Subsection:: *)
(*validModelInstrumentCrimperQTests*)


validModelInstrumentCrimperQTests[packet:PacketP[Model[Instrument,Crimper]]]:={
	(* Shared field shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard,Positions,PositionPlotting}]
};



(* ::Subsection::Closed:: *)
(*validModelInstrumentAnemometerQTests*)


validModelInstrumentAnemometerQTests[packet:PacketP[Model[Instrument,Anemometer]]]:={
	(* Shared field shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard,Positions,PositionPlotting}],

	NotNullFieldTest[packet,{
		(* object specific fields *)
		AirVelocityMeasurementResolution,AirVelocityMeasurementRange,AirVelocityMeasurementAccuracy
	}],

	(* Groups - Require mode information together *)
	RequiredTogetherTest[packet,{AirVelocityMeasurementResolution,AirVelocityMeasurementRange,AirVelocityMeasurementAccuracy}],
	RequiredTogetherTest[packet,{TemperatureMeasurementResolution,TemperatureMeasurementRange,TemperatureMeasurementAccuracy}]

};



(* ::Subsection::Closed:: *)
(*validModelInstrumentAnemometerQTests*)


validModelInstrumentAnemometerQTests[packet:PacketP[Model[Instrument,Anemometer]]]:={
	(* Shared field shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard,Positions,PositionPlotting}],

	NotNullFieldTest[packet,{
		(* object specific fields *)
		AirVelocityMeasurementResolution,AirVelocityMeasurementRange,AirVelocityMeasurementAccuracy
	}],

	(* Groups - Require mode information together *)
	RequiredTogetherTest[packet,{AirVelocityMeasurementResolution,AirVelocityMeasurementRange,AirVelocityMeasurementAccuracy}],
	RequiredTogetherTest[packet,{TemperatureMeasurementResolution,TemperatureMeasurementRange,TemperatureMeasurementAccuracy}]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentAcousticLiquidHandlerQTests*)


validModelInstrumentAcousticLiquidHandlerQTests[packet:PacketP[Model[Instrument,LiquidHandler,AcousticLiquidHandler]]]:={

	(*shared field shaping*)
	NullFieldTest[packet, {
		PCICard,
		WettedMaterials
	}],

	NotNullFieldTest[packet,{
		(* object specific fields *)
		CouplingFluid,
		MinCouplingFluidVolume,
		MaxFlangeHeight,
		DropletTransferResolution,
		MinPlateHeight,
		MaxPlateHeight,
		MinVolume,
		MaxVolume
	}],

	RequiredTogetherTest[packet,{MinPlateHeight,MaxPlateHeight}],
	RequiredTogetherTest[packet,{MinHumidity,MaxHumidity}],
	FieldComparisonTest[packet,{MinPlateHeight,MaxPlateHeight},LessEqual],
	FieldComparisonTest[packet,{MinHumidity,MaxHumidity},LessEqual]
};



(* ::Subsection:: *)
(*validModelInstrumentAspiratorQTests*)


validModelInstrumentAspiratorQTests[packet:PacketP[Model[Instrument,Aspirator]]]:={

	NotNullFieldTest[packet,{
			Positions,PositionPlotting,
			WettedMaterials,
			(* Unique fields *)
			Capacity,
			VacuumPump,
			TipConnectionType,
			ChannelOffset
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentAutoclaveQTests*)


validModelInstrumentAutoclaveQTests[packet:PacketP[Model[Instrument,Autoclave]]]:={

	(* Shared fields shaping *)
	NullFieldTest[packet,{Dongle,OperatingSystem,PCICard}],

	NotNullFieldTest[packet,{
			Positions,PositionPlotting,
			Connector,
			Modes,
			MinPressure,
			MaxPressure,
			MinTemperature,
			MaxTemperature,
			MinCycleTime,
			MinCycleTime,
			AutoclavePrograms
		}
	],

	Test["The three indexes in InternalDimensions must be all informed or all Null or an empty list:",
	Lookup[packet,InternalDimensions],
	{NullP,NullP,NullP}|{Except[NullP],Except[NullP],Except[NullP]|{}}
	],

	FieldComparisonTest[packet, {MinTemperature, MaxTemperature}, LessEqual],
	FieldComparisonTest[packet, {MinCycleTime, MaxCycleTime}, LessEqual],
	FieldComparisonTest[packet, {MinPressure, MaxPressure}, LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentBalanceQTests*)


validModelInstrumentBalanceQTests[packet:PacketP[Model[Instrument,Balance]]]:={

	NotNullFieldTest[packet, {MinWeight, MaxWeight, Mode, MeasureWeightPreferred, Resolution, Positions,PositionPlotting, AllowedMaxVariation}],

	FieldComparisonTest[packet, {Resolution, MaxWeight}, Less],
	FieldComparisonTest[packet, {Resolution, MinWeight}, LessEqual],
	FieldComparisonTest[packet, {Resolution, AllowedMaxVariation}, Less],
	FieldComparisonTest[packet, {AllowedMaxVariation, MaxWeight}, Less],

	NullFieldTest[packet, {Dongle,OperatingSystem,PCICard}]
};
(* ::Subsection::Closed:: *)
(*validModelInstrumentDistanceGaugeQTests*)
validModelInstrumentDistanceGaugeQTests[packet:PacketP[Model[Instrument,DistanceGauge]]]:={

	NotNullFieldTest[packet, {MinDistance, MaxDistance, Mode, Resolution}],

	FieldComparisonTest[packet, {MinDistance, MaxDistance}, Less],

	NullFieldTest[packet, {Dongle,OperatingSystem,PCICard}]
};

(* ::Subsection::Closed:: *)
(*validModelInstrumentCrossFlowFiltrationQTests*)


validModelInstrumentCrossFlowFiltrationQTests[packet:PacketP[Model[Instrument,CrossFlowFiltration]]]:={

	(* Shared fields shaping *)
	NotNullFieldTest[packet,{
		Positions,
		PositionPlotting,
		WettedMaterials
	}]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentCuvetteWasherQTests*)


validModelInstrumentCuvetteWasherQTests[packet:PacketP[Model[Instrument,CuvetteWasher]]]:={

	(* Shared fields shaping *)
	NullFieldTest[packet, {Dongle,OperatingSystem,PCICard,Connector}],

	NotNullFieldTest[packet,{
			Positions,PositionPlotting,
			WettedMaterials,
			(* Unique fields *)
			CuvetteCapacity,
			TrapCapacity
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentpHMeterQTests*)


validModelInstrumentpHMeterQTests[packet:PacketP[Model[Instrument,pHMeter]]]:=Join[

	{
		RequiredTogetherTest[packet,{MinpHs,MaxpHs}],
		NotNullFieldTest[packet,{Resolution,ProbeType,WettedMaterials,TemperatureCorrection,AcquisitionTimeControl}],
		(* Shared fields shaping *)
		NullFieldTest[packet,{Dongle,OperatingSystem,PCICard}]
	},

	If[MatchQ[Lookup[packet,Probes],{ObjectP[]..}],
		With[
			{
				probePackets=Download[packet,
					Packet[Probes[{
						MinpH,
						MaxpH,
						MinDepth,
						MinSampleVolume,
						ShaftDiameter,
						ShaftLength,
						ProbeType
					}]]
				]
			},

			{

				Test["Each value in MinpHs is less than the corresponding one in the MaxpHs:",
					MapThread[
						Function[{eachMinpH,eachMaxpH},
							Switch[{eachMinpH,eachMaxpH},
								{Null,_},True,
								{_,Null},True,
								_, eachMinpH < eachMaxpH
							]
						],
						{
							Lookup[packet,MinpHs],
							Lookup[packet,MaxpHs]
						}
					],
					{True..}
				],

				Test["The MinpHs field matches the MinpH values of the probes connected to the instrument:",
					MatchQ[Lookup[packet,MinpHs],Lookup[probePackets,MinpH]],
					True
				],


				Test["The MaxpHs field matches the MaxpH values of the probes connected to the instrument:",
					MatchQ[Lookup[packet,MaxpHs],Lookup[probePackets,MaxpH]],
					True
				],

				Test["The MinDepths field matches the MinDepth values of the probes connected to the instrument:",
					MatchQ[Lookup[packet,MinDepths],Lookup[probePackets,MinDepth]],
					True
				],

				Test["The MinSampleVolumes field matches the MinSampleVolume values of the probes connected to the instrument:",
					MatchQ[Lookup[packet,MinSampleVolumes],Lookup[probePackets,MinSampleVolume]],
					True
				],

				Test["The ProbeDiameters field matches the ShaftDiameter values of the probes connected to the instrument:",
					MatchQ[Lookup[packet,ProbeDiameters],Lookup[probePackets,ShaftDiameter]],
					True
				],

				Test["The ProbeLengths field matches the ShaftLength values of the probes connected to the instrument:",
					MapThread[
						Function[{instrumentLength,probeLength},
							Switch[{instrumentLength,probeLength},
								{Null,_},True,
								{_,Null},True,
								_, instrumentLength === probeLength
							]
						],
						{
							Lookup[packet,ProbeLengths],
							Lookup[probePackets,ShaftLength]
						}
					],
					{True..}
				],

				Test["The ProbeTypes field matches the ProbeType values of the probes connected to the instrument:",
					MatchQ[Lookup[packet,ProbeTypes],Lookup[probePackets,ProbeType]],
					True
				]
			}
		],
		{}
	]
];

(* ::Subsection::Closed:: *)
(*validModelInstrumentpHTitratorQTests*)


validModelInstrumentpHTitratorQTests[packet:PacketP[Model[Instrument,pHTitrator]]]:={

	NotNullFieldTest[packet, {SyringeVolume, MinDispenseVolume}]

};

(* ::Subsection::Closed:: *)
(*validModelInstrumentConductivityMeterQTests*)


validModelInstrumentConductivityMeterQTests[packet:PacketP[Model[Instrument,ConductivityMeter]]]:={

NotNullFieldTest[packet, {ManufacturerConductivityResolution,ManufacturerTemperatureResolution}],

RequiredTogetherTest[packet, {MinConductivity, MaxConductivity}],
FieldComparisonTest[packet, {MinConductivity, MaxConductivity}, LessEqual]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentBiosafetyCabinetQTests*)


validModelInstrumentBiosafetyCabinetQTests[packet:PacketP[Model[Instrument,BiosafetyCabinet]]]:={

	NotNullFieldTest[packet, {
			BiosafetyLevel,
			MinLaminarFlowSpeed,
			Benchtop,
			Plumbing,
			(* Shared fields shaping *)
			Positions
		}
	],

	NullFieldTest[packet, {Connector, Dongle, OperatingSystem, PCICard}],

	Test["The three indexes in InternalDimensions must be all informed:",
	Lookup[packet,InternalDimensions],
	{Except[NullP],Except[NullP],Except[NullP]}
	]

};

(* ::Subsection::Closed:: *)
(*validModelInstrumentHandlingStationBiosafetyCabinetQTests*)


validModelInstrumentHandlingStationBiosafetyCabinetQTests[packet:PacketP[Model[Instrument,HandlingStation,BiosafetyCabinet]]]:={

	NotNullFieldTest[packet, {
			BiosafetyLevel,
			MinLaminarFlowSpeed,
			Benchtop,
			Plumbing,
			(* Shared fields shaping *)
			Positions
		}
	],

	NullFieldTest[packet, {Connector, Dongle, OperatingSystem, PCICard}],

	Test["The three indexes in InternalDimensions must be all informed:",
	Lookup[packet,InternalDimensions],
	{Except[NullP],Except[NullP],Except[NullP]}
	]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentBioLayerInterferometerQTests*)


validModelInstrumentBioLayerInterferometerQTests[packet : PacketP[Model[Instrument, BioLayerInterferometer]]] := {

	(*Fields that should be informed*)
	NotNullFieldTest[packet,
		{
			(*Unique Fields*)
			ProbeCapacity,
			MaxTemperature,
			MinTemperature,
			MaxShakeRate,
			MinShakeRate,
			MaxWellVolume,
			MinWellVolume,
			RecommendedWellVolume,
			(*Shared fields*)
			Connector,
			OperatingSystem,
			Positions,
			WettedMaterials
		}
	],

	(*Shared fields that should not be informed*)
	NullFieldTest[packet,
		{
			Dongle,
			PCICard
		}
	],

	(*Reasonable values provided for Max/Min, Recommended*)

	FieldComparisonTest[packet, {MinWellVolume, MaxWellVolume}, LessEqual],
	FieldComparisonTest[packet, {MinShakeRate, MaxShakeRate}, LessEqual],
	FieldComparisonTest[packet, {RecommendedWellVolume, MaxWellVolume}, LessEqual],
	FieldComparisonTest[packet, {MinWellVolume, RecommendedWellVolume}, LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentBlowGunQTests*)


validModelInstrumentBlowGunQTests[packet:PacketP[Model[Instrument,BlowGun]]] := {

	(* Fields that SHOULD be informed, ie should NOT be Null*)
	NotNullFieldTest[packet,{
		TriggerType,
		Gas
	}]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentBottleRollerQTests*)


validModelInstrumentBottleRollerQTests[packet:PacketP[Model[Instrument,BottleRoller]]]:={

	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],

	NotNullFieldTest[packet,{
			Positions,PositionPlotting,
			(* Unique fields *)
			MaxLoad,
			RollerDiameter,
			RollerSpacing
		}
	],

	FieldComparisonTest[packet,{MaxRotationRate,MinRotationRate},GreaterEqual],
	FieldComparisonTest[packet,{RollerSpacing,RollerDiameter},GreaterEqual]

};



(* ::Subsection::Closed:: *)
(*validModelInstrumentBottleTopDispenserQTests*)


validModelInstrumentBottleTopDispenserQTests[packet:PacketP[Model[Instrument,BottleTopDispenser]]]:={

	NullFieldTest[packet,{Positions,PositionPlotting,Connector,Dongle,OperatingSystem,PCICard}],

	NotNullFieldTest[packet,{
			WettedMaterials,
			(* unique fields *)
			MinVolume,
			MaxVolume,
			Resolution
		}
	]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentCapillaryELISAQTests*)


validModelInstrumentCapillaryELISAQTests[packet:PacketP[Model[Instrument,CapillaryELISA]]]:={

	NullFieldTest[packet,{

		(* Shared fields *)
		WettedMaterials
	}],


	NotNullFieldTest[packet,{

		(* Shared fields *)
		Connector,
		Dongle,
		OperatingSystem,
		Positions,
		PositionPlotting,
		MovementLock,

		(* Non-shared fields *)
		BarcodeReader,
		TestCartridge,
		ExcitationSource,
		ExcitationSourceType,
		ExcitationFilterType,
		ExcitationWavelength,
		EmissionFilterType,
		EmissionDetector,
		EmissionWavelength,
		MaxAnalytes,
		MaxNumberOfSamples,
		MinVolume,
		MaxVolume,
		Temperature
	}],

	Test["ExcitationWavelength is smaller than EmissionWavelength:",
		TrueQ[Lookup[packet,ExcitationWavelength]<Lookup[packet,EmissionWavelength]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentCellThawQTests*)


validModelInstrumentCellThawQTests[packet:PacketP[Model[Instrument,CellThaw]]]:={
	NullFieldTest[packet,{WettedMaterials}],

	NotNullFieldTest[packet,{Positions,PositionPlotting,Capacity}]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentCentrifugeQTests*)


validModelInstrumentCentrifugeQTests[packet:PacketP[Model[Instrument,Centrifuge]]]:={

	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],

	NotNullFieldTest[packet,{Positions,PositionPlotting,MaxRotationRate,MinRotationRate,SpeedResolution}],

	RequiredTogetherTest[packet,{MaxTemperature,MinTemperature}],
	FieldComparisonTest[packet,{MaxTemperature,MinTemperature},GreaterEqual],
	FieldComparisonTest[packet,{MaxRotationRate,MinRotationRate},GreaterEqual],

	Test[
		"MinRotationRate and MaxRotationRate are in increments of 'SpeedResolution':",
		Module[{minSpeed,speedResolution,maxSpeed},
			{minSpeed,speedResolution,maxSpeed}=Lookup[packet,{MinRotationRate,SpeedResolution,MaxRotationRate}];
			{
				Unitless[Mod[minSpeed,speedResolution]] == 0,
				Unitless[Mod[maxSpeed,speedResolution]] == 0
			}
		],
		{True,True}
	]

};

(* ::Subsection::Closed:: *)
(*validModelInstrumentRobotArmQTests*)


validModelInstrumentRobotArmQTests[packet:PacketP[Model[Instrument,RobotArm]]]:={

	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],

	NotNullFieldTest[packet,{GantryType,ApproximateWorkingEnvelope}],

	RequiredTogetherTest[packet,{Grippers,GripperOpeningWidths}],
	Test[
		"If the linear rail is attached, then linear rail relative angle is also defined:",
		Module[{},
			If[MatchQ[Lookup[packet,LinearRailAttached],True],
				!NullQ[Lookup[packet,LinearRailRelativeAngle]],
				True
			]
		],
		True
	],

	Test[
		"Approximate working envelope is defining a valid polygon:",
		Module[{minX,maxX,minY,maxY,minZ,maxZ},
			{minX,maxX,minY,maxY,minZ,maxZ}=Lookup[packet,ApproximateWorkingEnvelope];
			{
				MatchQ[minX,LessEqualP[maxX]],
				MatchQ[minY,LessEqualP[maxY]],
				MatchQ[minZ,LessEqualP[maxZ]]
			}
		],
		{True,True,True}
	]

};

(* ::Subsection::Closed:: *)
(*validModelInstrumentControlledRateFreezerQTests*)


validModelInstrumentControlledRateFreezerQTests[packet:PacketP[Model[Instrument,ControlledRateFreezer]]]:={

	NotNullFieldTest[packet,{

		(* Shared fields *)
		Positions,
		PositionPlotting,

		(* Unique fields *)
		MinTemperature,
		MinCoolingRate,
		MaxCoolingRate
	}],

	FieldComparisonTest[packet,{MinCoolingRate,MaxCoolingRate},Less],

	Test[
		"The three indexes in InternalDimensions must be all informed:",
		Lookup[packet,InternalDimensions],
		{Except[NullP],Except[NullP],Except[NullP]}
	]
};


(* ::Subsection:: *)
(*validModelInstrumentCoulterCounterQTests*)


validModelInstrumentCoulterCounterQTests[packet:PacketP[Model[Instrument,CoulterCounter]]]:={

	(* fields that should not be Null *)
	NotNullFieldTest[packet,{
		(* Shared fields *)
		Positions,
		PositionPlotting,
		(* Unique fields *)
		ElectrodesMaterial,
		MinParticleSize,
		MaxParticleSize,
		MinOperatingTemperature,
		MaxOperatingTemperature,
		MinMixRate,
		MaxMixRate,
		MinCurrent,
		MaxCurrent,
		MinGain,
		MaxGain
	}],

	(* Sensible Min/Max fields *)
	FieldComparisonTest[packet,{MinParticleSize,MaxParticleSize},LessEqual],
	FieldComparisonTest[packet,{MinOperatingTemperature,MaxOperatingTemperature},LessEqual],
	FieldComparisonTest[packet,{MinHumidity,MaxHumidity},LessEqual],
	FieldComparisonTest[packet,{MinMixRate,MaxMixRate},LessEqual],
	FieldComparisonTest[packet,{MinCurrent,MaxCurrent},LessEqual],
	FieldComparisonTest[packet,{MinGain,MaxGain},LessEqual]

};

(* ::Subsection::Closed:: *)
(*validModelInstrumentCryogenicFreezerQTests*)


validModelInstrumentCryogenicFreezerQTests[packet:PacketP[Model[Instrument,CryogenicFreezer]]]:={

	NotNullFieldTest[packet,{
			(* Shared fields shaping *)
			Positions,PositionPlotting,
			(* Unique fields*)
			StoragePhase,
			LiquidNitrogenCapacity,
			StaticEvaporationRate
		}
	],

	Test["The three indexes in InternalDimensions must be all informed:",
	Lookup[packet,InternalDimensions],
	{Except[NullP],Except[NullP],Except[NullP]}
	],

	NullFieldTest[packet,{Connector,Dongle,OperatingSystem,PCICard}]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentDarkroomQTests*)


validModelInstrumentDarkroomQTests[packet:PacketP[Model[Instrument,Darkroom]]]:={
	(* Shared field shaping *)
	NullFieldTest[packet, {WettedMaterials}],

	NotNullFieldTest[packet,{
			Connector,
			Dongle,
			OperatingSystem,
			Positions,PositionPlotting,
			(* Unique fields *)
			CameraModel,
			CameraResolution,
			LightSources
		}
	],

	Test["The three indexes in InternalDimensions must be all informed:",
	Lookup[packet,InternalDimensions],
	{Except[NullP],Except[NullP],Except[NullP]}
	]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentDesiccatorQTests*)


validModelInstrumentDesiccatorQTests[packet:PacketP[Model[Instrument,Desiccator]]]:={

	(* Shared Field Shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard,WettedMaterials}],
	NotNullFieldTest[packet, {Positions,PositionPlotting}],

	(*Specific fields*)
	NotNullFieldTest[packet, {SampleType,Vacuumable,Desiccant,DesiccantCapacity,DesiccantReplacementFrequency}],

	Test[
		"If the Vaccumable is True, then MinPressure has to be populated:",
		Lookup[packet,{Vacuumable,MinPressure}],
		Alternatives[
			{True,Except[NullP]},
			{False,NullP}
		]
	],

	(*Required fields if SampleType is Closed*)
	Test["if SampleType is set to Closed, Desiccant must be informed:",
		If[MatchQ[Lookup[packet,SampleType],Closed],
			!MatchQ[Lookup[packet,Desiccant],NullP|{}],
			True
		],
		True
	],

	Test["if SampleType is set to Closed, DesiccantReplacementFrequency must be informed:",
		If[MatchQ[Lookup[packet,SampleType],Closed],
			!MatchQ[Lookup[packet,DesiccantReplacementFrequency],NullP|{}],
			True
		],
		True
	]

};



(* ::Subsection::Closed:: *)
(*validModelInstrumentDializerQTests*)


validModelInstrumentDializerQTests[packet:PacketP[Model[Instrument,Dialyzer]]]:={

	(* Shared Field Shaping *)
	NullFieldTest[packet, {
		Connector,
		Dongle,
		OperatingSystem,
		PCICard
	}],

	NotNullFieldTest[packet, {
		Positions,
		PositionPlotting
	}],

	(*Specific fields*)
	NotNullFieldTest[packet, {
		TankVolume,
		TankHeight,
		TankInternalDiameter,
		ReservoirVolume,
		TubingInnerDiameter
	}]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentDiffractometerQTests*)


validModelInstrumentDiffractometerQTests[packet:PacketP[Model[Instrument,Diffractometer]]]:={

	(* basic fields that must be populated *)
	NotNullFieldTest[
		packet,
		{
			RadiationType,
			AnodeMaterial,
			DiffractionDetector,
			DetectorPixelSize,
			DetectorDimensions,
			NumberOfDetectorModules,
			DetectorModuleGapDistance,
			Chiller,
			ExperimentTypes,
			MinTheta,
			MaxTheta,
			MinDetectorDistance,
			MaxDetectorDistance,
			MaxBeamPower,
			MaxVoltage,
			MaxCurrent
		}
	]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentDishwasherQTests*)


validModelInstrumentDishwasherQTests[packet:PacketP[Model[Instrument,Dishwasher]]]:={

	(* Shared Field Shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],

	NotNullFieldTest[packet,{
			Positions,PositionPlotting,
			(* Unique Fields *)
			MinTemperature,
			MaxTemperature,
			Detergent,
			Neutralizer
		}
	],

	Test["The three indexes in InternalDimensions must be all informed:",
		Lookup[packet,InternalDimensions],
		{Except[NullP],Except[NullP],Except[NullP]}
	],

	(* Sensible Min/Max field checks *)
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentDispenserQTests*)


validModelInstrumentDispenserQTests[packet:PacketP[Model[Instrument,Dispenser]]]:={

	(* Shared Field Shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],

	NotNullFieldTest[packet,{
		DispensingMaterialType,
		If[MatchQ[Lookup[packet, DispensingMaterialType], Sheet],
			Nothing,
			Sequence @@ {
				Positions,
				PositionPlotting,
				WettedMaterials,
				(* Unique Fields *)
				ReservoirContainer
			}
		]
	}],

	If[MatchQ[Lookup[packet, DispensingMaterialType], Sheet],
		Nothing,
		Test["The positions must include \"Reservoir Slot\":",
			pos=Lookup[packet,AllowedPositions];
			MemberQ[List@@pos,"Reservoir Slot"],
			True,
			Variables:>{pos}
		]
	]
};



(* ::Subsection::Closed:: *)
(*validModelInstrumentDissolvedOxygenMeterQTests*)


validModelInstrumentDissolvedOxygenMeterQTests[packet:PacketP[Model[Instrument,DissolvedOxygenMeter]]]:={

	(* Shared Field Shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],

	NotNullFieldTest[packet,{
		MinDissolvedOxygen,
		MaxDissolvedOxygen
	}
	],

	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual],
	FieldComparisonTest[packet,{MinDissolvedOxygen,MaxDissolvedOxygen},LessEqual]
};



(* ::Subsection::Closed:: *)
(*validModelInstrumentDNASynthesizerQTests*)


validModelInstrumentDNASynthesizerQTests[packet:PacketP[Model[Instrument,DNASynthesizer]]]:={
(* Shared field shaping *)

	NotNullFieldTest[packet,{
		Connector,
		Dongle,
		OperatingSystem,
		PCICard,
		Positions,
		PositionPlotting,
		ColumnScale,
		ReagentSets,
		ReagentSets,
		NominalArgonPressure,
		NominalChamberGaugePressure,
		NominalPurgeGaugePressure,
		NominalAmiditeAndACNGaugePressure,
		NominalCapAndActivatorGaugePressure,
		NominalDeblockAndOxidizerGaugePressure,
		MethodFilePath
	}
	],


(* Sensible Min/Max field checks *)
	RequiredTogetherTest[packet,{MinArgonPressure,NominalArgonPressure,MaxArgonPressure}],
	FieldComparisonTest[packet,{MinArgonPressure,NominalArgonPressure,MaxArgonPressure},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentDifferentialScanningCalorimeterQTests*)


validModelInstrumentDifferentialScanningCalorimeterQTests[packet:PacketP[Model[Instrument,DifferentialScanningCalorimeter]]]:={
	FieldComparisonTest[packet, {MinInjectionVolume, MaxInjectionVolume}, LessEqual],
	FieldComparisonTest[packet, {MinTemperature, MaxTemperature}, LessEqual],
	FieldComparisonTest[packet, {MinTemperatureRampRate, MaxTemperatureRampRate}, LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentElectroporatorQTests*)


validModelInstrumentElectroporatorQTests[packet:PacketP[Model[Instrument,Electroporator]]]:={

	(* Fields which should not be null *)
	NotNullFieldTest[packet,{Positions,PositionPlotting}],


	RequiredTogetherTest[packet,{MinVoltage,MaxVoltage}],
	FieldComparisonTest[packet,{MinVoltage,MaxVoltage},LessEqual]
};

(* ::Subsection::Closed:: *)
(*validModelInstrumentElectrophoresisQTests*)


validModelInstrumentElectrophoresisQTests[packet:PacketP[Model[Instrument,Electrophoresis]]]:={

	(* Fields which should not be null *)
	NotNullFieldTest[packet,{Connector,Dongle,OperatingSystem,PCICard,Capacity,Positions,PositionPlotting, LaneTop, LaneBottom, LaneWidth, LaneSeparation, LaneCenter, MaxLanes, ImageScale}],

	(* Sensible Min/Max field checks *)
	RequiredTogetherTest[packet,{MinVolume,MaxVolume}],
	FieldComparisonTest[packet,{MinVolume,MaxVolume},LessEqual],

	RequiredTogetherTest[packet,{MinVoltage,MaxVoltage}],
	FieldComparisonTest[packet,{MinVoltage,MaxVoltage},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentEnvironmentalChamberQTests*)


validModelInstrumentEnvironmentalChamberQTests[packet:PacketP[Model[Instrument,EnvironmentalChamber]]]:={

	NotNullFieldTest[packet,{
			(* unique fields *)
			EnvironmentalControls,
			InternalDimensions,
			MinTemperature,
			MaxTemperature,
			MinHumidity,
			MaxHumidity,
			(* shared fields *)
			Positions
		}],

		Test["If UVLight is listed in the EnvironmentalControls field, MinUVLightIntensity is informed:",
			Module[{environmentalControls,minUVLightIntensity},
				{environmentalControls,minUVLightIntensity}= Lookup[packet,{EnvironmentalControls,MinUVLightIntensity}];
				{MemberQ[environmentalControls,UVLight],minUVLightIntensity}
			],
			{True,Except[Null]}|{False,_}
		],

		Test["If VisibleLight is listed in the EnvironmentalControls field, MinVisibleLightIntensity is informed:",
			Module[{environmentalControls,minVisibleLightIntensity},
				{environmentalControls,minVisibleLightIntensity}= Lookup[packet,{EnvironmentalControls,MinVisibleLightIntensity}];
				{MemberQ[environmentalControls,VisibleLight],minVisibleLightIntensity}
			],
			{True,Except[Null]}|{False,_}
		],

	RequiredTogetherTest[packet,{MinTemperature,MaxTemperature}],
	RequiredTogetherTest[packet,{MinHumidity,MaxHumidity}],
	RequiredTogetherTest[packet,{MinUVLightIntensity,MaxUVLightIntensity}],
	RequiredTogetherTest[packet,{MinVisibleLightIntensity,MaxVisibleLightIntensity}],

	(* min/max tests *)
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual],
	FieldComparisonTest[packet,{MinHumidity,MaxHumidity},LessEqual],
	FieldComparisonTest[packet,{MinUVLightIntensity,MaxUVLightIntensity},LessEqual],
	FieldComparisonTest[packet,{MinVisibleLightIntensity,MaxVisibleLightIntensity},LessEqual]

};



(* ::Subsection::Closed:: *)
(*validModelInstrumentCondensateRecirculatorQTests*)


validModelInstrumentCondensateRecirculatorQTests[packet:PacketP[Model[Instrument,CondensateRecirculator]]]:={

	NotNullFieldTest[packet,{
		Capacity,
		FillLiquidModel,
		(* shared fields *)
		Positions
	}]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentEvaporatorQTests*)


validModelInstrumentEvaporatorQTests[packet:PacketP[Model[Instrument,Evaporator]]]:={

	NotNullFieldTest[packet,{Positions,PositionPlotting,MaxTemperature,MinTemperature,TubingInnerDiameter,NitrogenEvaporatorType}],

	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],

	(* Sensible Min/Max field checks *)
	RequiredTogetherTest[packet,{MinTemperature,MaxTemperature}],
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual],
	RequiredTogetherTest[packet,{MinFlowRate,MaxFlowRate}],
	FieldComparisonTest[packet,{MinFlowRate,MaxFlowRate},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentFilterBlockQTests*)


validModelInstrumentFilterBlockQTests[packet:PacketP[Model[Instrument,FilterBlock]]]:={

	NotNullFieldTest[packet,Positions],

	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentFilterHousingQTests*)


validModelInstrumentFilterHousingQTests[packet:PacketP[Model[Instrument,FilterHousing]]]:={

	NotNullFieldTest[packet,{
		Positions,PositionPlotting,
		MembraneDiameter,
		DeadVolume,
		InletConnectionType,
		OutletConnectionType,
		WettedMaterials
	}],

	NullFieldTest[packet, {
		Connector,
		Dongle,
		OperatingSystem,
		PCICard
	}]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentFlowCytometerQTests*)


validModelInstrumentFlowCytometerQTests[packet:PacketP[Model[Instrument,FlowCytometer]]]:={

	(* Fields which should not be null *)
	NotNullFieldTest[packet,{
			Connector,
			Dongle,
			OperatingSystem,
			PCICard,
			Positions,PositionPlotting,
			WettedMaterials,
			(* Non-shared fields *)
			Mode,
			OpticModules,
			FluorescenceChannels,
			MaxEventRate,
			MinInjectionRate,
			MaxInjectionRate,
			MinIncubationTemperature,
			MaxIncubationTemperature,
			MinSampleVolume,
			MaxSampleVolume,
			MinWashVolume,
			MaxWashVolume
		}
	],

	(* Test that all Min/Max field pairs are internally consistent *)
	FieldComparisonTest[packet,{MinInjectionRate,MaxInjectionRate},LessEqual],
	FieldComparisonTest[packet,{MinIncubationTemperature,MaxIncubationTemperature},LessEqual],
	FieldComparisonTest[packet,{MinSampleVolume,MaxSampleVolume},LessEqual],
	FieldComparisonTest[packet,{MinWashVolume,MaxWashVolume},LessEqual]

};


opticModuleSyncQ[packet:PacketP[Model[Instrument,FlowCytometer]]] := Module[
	{fluorChannels,opticModules,opticModuleSpecs},

	fluorChannels = (FluorescenceChannels/.packet);

	(* Pull out the OpticModules field *)
	opticModules = packet[OpticModules];

	(* Assemble a list for each OpticModule that should match the corresponding entry in the FluorescenceChannels field *)
	opticModuleSpecs = Download[opticModules,{ChannelName,Laser,EmissionFilterWavelength,EmissionFilterBandwidth}];

	(* Check that the two match *)
	ContainsExactly[fluorChannels,opticModuleSpecs]
];


(* ::Subsection::Closed:: *)
(*validModelInstrumentFPLCQTests*)


validModelInstrumentFPLCQTests[packet:PacketP[Model[Instrument,FPLC]]]:={
	NotNullFieldTest[packet,{
			Connector,
			Dongle,
			OperatingSystem,
			Positions,PositionPlotting,
			(* Unique fields required *)
			Detectors,
			Mixer,
			MinFlowRate,
			MaxFlowRate,
			MinPressure,
			TubingMaxPressure,
			PumpMaxPressure,
			FlowCellMaxPressure,
			ColumnConnector,
			SampleLoop,
			MinSampleVolume,
			MaxSampleVolume,
			DelayVolume,
			DelayLength,
			FlowCellVolume,
			FlowCellPathLength,
			TubingInnerDiameter,
			DefaultMixer,
			AssociatedAccessories
		}
	],

	(* Check that DetectorLampType is informed if Absorbance is used *)
	Test["If Absorbance is listed in the Detectors field, DetectorLampType is informed:",
		Module[{detectors,detectorLampType},
			{detectors,detectorLampType}= Lookup[packet,{Detectors,DetectorLampType}];
			{MemberQ[detectors,Absorbance],detectorLampType}
			],
		{True,Except[Null]}|{False,_}
	],
	Test["The DefaultMixer should be in the associated accessories:",
		MemberQ[Lookup[packet,AssociatedAccessories][[All,1]][Object],Lookup[packet,DefaultMixer][Object]],
		True
	],
	(* If Detector LampType is informed, then Absorbance criteria must be informed *)
	RequiredTogetherTest[packet,{DetectorLampType,AbsorbanceDetector,AbsorbanceFilterType,MinAbsorbanceWavelength,MaxAbsorbanceWavelength,AbsorbanceWavelengthBandpass}],

	(* Min/Max tests *)
	FieldComparisonTest[packet,{MinFlowRate,MaxFlowRate},LessEqual],
	FieldComparisonTest[packet,{MinPressure,TubingMaxPressure},LessEqual],
	FieldComparisonTest[packet,{MinAbsorbanceWavelength,MaxAbsorbanceWavelength},LessEqual],
	FieldComparisonTest[packet,{MinSampleVolume,MaxSampleVolume},LessEqual]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentGasGeneratorQTests*)


(* TODO: IMPROVE *)
validModelInstrumentGasGeneratorQTests[packet:PacketP[Model[Instrument,GasGenerator]]]:={
	(* Shared fields - Not Null *)
	NotNullFieldTest[packet,{
		DeliveryPressure,
		GasGenerated
	}
	]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentGasChromatographQTests*)


validModelInstrumentGasChromatographQTests[packet:PacketP[Model[Instrument,GasChromatograph]]]:={
	(* Shared fields - Not Null *)
	NotNullFieldTest[packet,{
		Detectors,
		Scale,
		CarrierGases,
		Inlets,
		ColumnInletConnectors,
		ColumnOutletConnectors,
		MaxInletPressure,
		MaxNumberOfColumns,
		MinColumnOvenTemperature,
		MaxColumnOvenTemperature,
		MaxColumnCageDiameter
	}
	],

	(* Min/Max tests *)
	FieldComparisonTest[packet,{MinColumnOvenTemperature,MaxColumnOvenTemperature},Less]
};



(* ::Subsection::Closed:: *)
(*validModelInstrumentGravityRack*)


validModelInstrumentGravityRackQTests[packet:PacketP[Model[Instrument,GravityRack]]]:={
	NotNullFieldTest[
		packet,
		{
			MinCollectionVolume,
			MaxCollectionVolume,
			CollectionRackAttached,
			Platforms,
			Positions,
			Dimensions,
			WettedMaterials
		}
	],

	FieldComparisonTest[packet,{MinCollectionVolume,MaxCollectionVolume},Less],

	Test["If the Platforms field is informed, the types indicated at index 1 match the GravityRackPlatformType field in the corresponding gravity rack Part models indicated at index 2:",
		Module[{platformsField},
			platformsField = Lookup[packet,Platforms];

			If[Length[platformsField]>0,
				MatchQ[
					(*These are the platform types listed in the Platforms field of the Model[Instrument, GravityRack]*)
					platformsField[[All, 1]],
					(*These are the platform types listed in the GravityRackPlatformType field of the actual platform Part models*)
					Download[platformsField[[All, 2]], GravityRackPlatformType]
				],
				(*If Platforms is not informed, just return True*)
				True
			]
		],
		True
	]
};

(* ::Subsection::Closed:: *)
(*validModelInstrumentHandlingStationQTests*)


validModelInstrumentHandlingStationQTests[packet:PacketP[Model[Instrument,HandlingStation]]]:={
	
	NotNullFieldTest[
		packet,
		{
			NumberOfVideoCameras,
			Ventilated,
			Deionizing,
			HermeticTransferCompatible,
			ProvidedHandlingConditions
		}
	],
	
	(* if balance type is populated, every objects should have the corresponding balance types! *)
	Test["BalanceType of the model matches up with each instance's Field[Balances[Mode]]:",
		Module[{balanceTypesToHave, instances, instanceTuples},
			balanceTypesToHave = Lookup[packet, BalanceType];

			(* get the objects *)
			instances = Lookup[packet, Objects];
			instanceTuples = Download[instances, {Status, Balances[Mode]}];

			(* only check non-Retired instances *)
			SubsetQ[balanceTypesToHave, #[[2]]]& /@ DeleteCases[instanceTuples, {Retired, _}]
		],
		{True...}
	],

	Test["BalanceType of the ProvidedHandlingConditions match the BalanceType of the instrument model:",
		Module[{balanceTypesToHave, handlingConditions, handlingConditionBalanceTypes},
			balanceTypesToHave = Lookup[packet, BalanceType];

			(* get the provided handling conditions *)
			handlingConditions = Lookup[packet, ProvidedHandlingConditions];
			handlingConditionBalanceTypes = DeleteDuplicates[Flatten[Download[handlingConditions, BalanceType]]];

			(* cannot provide a handling condition with a balance type that is not in our model *)
			Complement[handlingConditionBalanceTypes, balanceTypesToHave]
		],
		{}
	]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentHandlingStationAmbientQTests*)


validModelInstrumentHandlingStationAmbientQTests[packet:PacketP[Model[Instrument,HandlingStation,Ambient]]]:={
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentHPLCQTests*)


validModelInstrumentHPLCQTests[packet:PacketP[Model[Instrument,HPLC]]]:={
	(* Shared fields - Not Null *)
	NotNullFieldTest[packet,{
			Connector,
			Dongle,
			OperatingSystem,
			Positions,
			PositionPlotting,
			Detectors,
			Mixer,
			MinFlowRate,
			MaxFlowRate,
			MinColumnTemperature,
			MaxColumnTemperature,
			MinPressure,
			TubingMaxPressure,
			PumpMaxPressure,
			FlowCellMaxPressure,
			MaxColumnLength,
			ColumnConnector,
			ColumnCompartmentType,
			SampleLoop,
			MinSampleVolume,
			RecommendedSampleVolume,
			MaxSampleVolume,
			FlowCellVolume,
			FlowCellPathLength,
			TubingInnerDiameter,
			MaxColumnOutsideDiameter,
			NumberOfBuffers,
			PumpType,
			InjectorType,
			SystemPrimeGradients,
			SystemFlushGradients
		}
	],

	FieldComparisonTest[packet,{RecommendedSampleVolume,MinSampleVolume},GreaterEqual],


	(* Check that DetectorLampType is informed if Absorbance is used *)
	Test["If Absorbance is listed in the Detectors field, DetectorLampType is informed:",
		Module[
			{detectors,detectorLampType},
			{detectors,detectorLampType} = Lookup[packet,{Detectors,DetectorLampType}];
			{MemberQ[detectors,UVVis|PhotoDiodeArray],detectorLampType}
		],
		{True,Except[Null]}|{False,_}
	],
	Test["If ColumnCompartmentType is Selector, MaxNumberOfColumns and ColumnPositions are informed. Conversely, if ColumnCompartmentType is Serial, MaxNumberOfColumns is Null:",
		Lookup[packet,{ColumnCompartmentType,MaxNumberOfColumns,ColumnPositions}],
		{Selector,Except[Null],Except[{}]}|{Serial,Null,_}
	],

	Test["ColumnPreheater can only be True for Waters instruments:",
		If[MatchQ[Lookup[packet,Manufacturer],ObjectP[Object[Company, Supplier, "Waters"]]],
			True,
			!TrueQ[Lookup[packet,ColumnPreheater]]
		],
		True
	],

	(* If Detector LampType is informed, then Absorbance criteria must be informed *)
	RequiredTogetherTest[packet,{DetectorLampType,AbsorbanceDetector,AbsorbanceFilterType,MinAbsorbanceWavelength,MaxAbsorbanceWavelength,AbsorbanceWavelengthBandpass}],
	RequiredTogetherTest[packet,{MinAbsorbanceSamplingRate,MaxAbsorbanceSamplingRate}],
	RequiredTogetherTest[packet,{MinSmoothingTimeConstant,MaxSmoothingTimeConstant}],

	(* Min/Max tests *)
	FieldComparisonTest[packet,{MinFlowRate,MaxFlowRate},LessEqual],
	FieldComparisonTest[packet,{MinPressure,TubingMaxPressure},LessEqual],
	FieldComparisonTest[packet,{MinAbsorbanceWavelength,MaxAbsorbanceWavelength},LessEqual],
	FieldComparisonTest[packet,{MinAbsorbanceSamplingRate,MaxAbsorbanceSamplingRate},LessEqual],
	FieldComparisonTest[packet,{MinSmoothingTimeConstant,MaxSmoothingTimeConstant},LessEqual],
	FieldComparisonTest[packet,{MinSampleVolume,MaxSampleVolume},LessEqual],

	(* If AbsorbanceSamplingRates are provided, MinAbsorbanceSamplingRate and MaxAbsorbanceSamplingRate cannot be populated and vice versa *)
	Test["Either AbsorbanceSamplingRates or MinAbsorbanceSamplingRate and MaxAbsorbanceSamplingRate pair can be populated:",
		Lookup[packet, {AbsorbanceSamplingRates,MinAbsorbanceSamplingRate,MaxAbsorbanceSamplingRate}],
		{{},Except[Null],Except[Null]}|{Except[{}],Null,Null}|{{},Null,Null}
	],

	(* If SmoothingTimeConstants are provided, MinSmoothingTimeConstant and MaxSmoothingTimeConstant cannot be populated and vice versa *)
	Test["Either SmoothingTimeConstants or MinSmoothingTimeConstant and MaxSmoothingTimeConstant pair can be populated:",
		Lookup[packet, {SmoothingTimeConstants,MinSmoothingTimeConstant,MaxSmoothingTimeConstant}],
		{{},Except[Null],Except[Null]}|{Except[{}],Null,Null}|{{},Null,Null}
	],

	(* FractionCollectionDetectors is a subset of Detectors *)
	Test["FractionCollectionDetectors is a subset of Detectors:",
		SubsetQ[Lookup[packet,Detectors],Lookup[packet,FractionCollectionDetectors]],
		True
	],

	(* Fluorescence Detector check for Dionex instrument *)
	If[MemberQ[Lookup[packet,Detectors],Fluorescence]&&MatchQ[Lookup[packet,Manufacturer],ObjectP[Object[Company, Supplier, "Dionex"]]],
		{
			NotNullFieldTest[packet, {
				ExcitationSource,
				ExcitationFilterType,
				EmissionFilterType,
				EmissionDetector,
				FluorescenceFlowCellVolume,
				FluorescenceFlowCellPathLength,
				MinExcitationWavelength,
				MaxExcitationWavelength,
				MinEmissionWavelength,
				MaxEmissionWavelength,
				MinFluorescenceFlowCellTemperature,
				MaxFluorescenceFlowCellTemperature
			}],
			FieldComparisonTest[packet,{MinExcitationWavelength,MaxExcitationWavelength},LessEqual],
			FieldComparisonTest[packet,{MinEmissionWavelength,MaxEmissionWavelength},LessEqual],
			FieldComparisonTest[packet,{MinFluorescenceFlowCellTemperature,MaxFluorescenceFlowCellTemperature},LessEqual]
		},
		NullFieldTest[packet,{
			ExcitationSource,
			ExcitationFilterType,
			EmissionFilterType,
			EmissionDetector,
			FluorescenceFlowCellVolume,
			FluorescenceFlowCellPathLength,
			MinExcitationWavelength,
			MaxExcitationWavelength,
			MinEmissionWavelength,
			MaxEmissionWavelength,
			MinFluorescenceFlowCellTemperature,
			MaxFluorescenceFlowCellTemperature
		}]
	],

	Test["DLS is currently only supported in a MALS detector:",
		If[MemberQ[Lookup[packet,Detectors],DynamicLightScattering],
			MemberQ[Lookup[packet,Detectors],MultiAngleLightScattering],
			True
		],
		True
	],

	(* MALS Detector check *)
	If[MemberQ[Lookup[packet,Detectors],MultiAngleLightScattering],
		{
			NotNullFieldTest[packet, {
				LightScatteringSource,
				LightScatteringWavelength,
				MALSDetector,
				MALSDetectorAngles,
				LightScatteringFlowCellVolume,
				MinLightScatteringFlowCellTemperature,
				MaxLightScatteringFlowCellTemperature,
				MinMALSMolecularWeight,
				MaxMALSMolecularWeight,
				MinMALSGyrationRadius,
				MaxMALSGyrationRadius
			}],
			FieldComparisonTest[packet,{MinLightScatteringFlowCellTemperature,MaxLightScatteringFlowCellTemperature},LessEqual],
			FieldComparisonTest[packet,{MinMALSMolecularWeight,MaxMALSMolecularWeight},LessEqual],
			FieldComparisonTest[packet,{MinMALSGyrationRadius,MaxMALSGyrationRadius},LessEqual]
		},
		NullFieldTest[packet,{
			LightScatteringSource,
			LightScatteringWavelength,
			MALSDetector,
			MALSDetectorAngles,
			LightScatteringFlowCellVolume,
			MinLightScatteringFlowCellTemperature,
			MaxLightScatteringFlowCellTemperature,
			MinMALSMolecularWeight,
			MaxMALSMolecularWeight,
			MinMALSGyrationRadius,
			MaxMALSGyrationRadius
		}]
	],

	(* DLS Detector check *)
	If[MemberQ[Lookup[packet,Detectors],DynamicLightScattering],
		{
			NotNullFieldTest[packet, {
				DLSDetector,
				DLSDetectorAngle,
				MinDLSHydrodynamicRadius,
				MaxDLSHydrodynamicRadius
			}],
			FieldComparisonTest[packet,{MinDLSHydrodynamicRadius,MaxDLSHydrodynamicRadius},LessEqual]
		},
		NullFieldTest[packet,{
			DLSDetector,
			DLSDetectorAngle,
			MinDLSHydrodynamicRadius,
			MaxDLSHydrodynamicRadius
		}]
	],

	(* Refractive Index Detector check *)
	If[MemberQ[Lookup[packet,Detectors],RefractiveIndex],
		{
			NotNullFieldTest[packet, {
				RefractiveIndexSource,
				RefractiveIndexWavelength,
				RefractiveIndexDetector,
				RefractiveIndexFlowCellVolume,
				MinRefractiveIndexFlowCellTemperature,
				MaxRefractiveIndexFlowCellTemperature
			}],
			FieldComparisonTest[packet,{MinRefractiveIndexFlowCellTemperature,MaxRefractiveIndexFlowCellTemperature},LessEqual]
		},
		NullFieldTest[packet,{
			RefractiveIndexSource,
			RefractiveIndexWavelength,
			RefractiveIndexDetector,
			RefractiveIndexFlowCellVolume,
			MinRefractiveIndexFlowCellTemperature,
			MaxRefractiveIndexFlowCellTemperature
		}]
	],

	(* pH Detector check *)
	If[MemberQ[Lookup[packet,Detectors],pH],
		{
			NotNullFieldTest[packet, {
				pHFlowCellVolume,
				MinDetectorpH,
				MaxDetectorpH,
				MinpHFlowCellTemperature,
				MaxpHFlowCellTemperature
			}],
			FieldComparisonTest[packet,{MinDetectorpH,MaxDetectorpH},LessEqual],
			FieldComparisonTest[packet,{MinpHFlowCellTemperature,MaxpHFlowCellTemperature},LessEqual]
		},
		NullFieldTest[packet,{
			pHFlowCellVolume,
			MinDetectorpH,
			MaxDetectorpH,
			MinpHFlowCellTemperature,
			MaxpHFlowCellTemperature
		}]
	],

	(* Conductivity Detector check *)
	If[MemberQ[Lookup[packet,Detectors],Conductance],
		{
			NotNullFieldTest[packet, {
				ConductivityFlowCellVolume,
				MinConductivity,
				MaxConductivity,
				MinConductivityFlowCellTemperature,
				MaxConductivityFlowCellTemperature
			}],
			FieldComparisonTest[packet,{MinConductivity,MaxConductivity},LessEqual],
			FieldComparisonTest[packet,{MinConductivityFlowCellTemperature,MaxConductivityFlowCellTemperature},LessEqual]
		},
		NullFieldTest[packet,{
			ConductivityFlowCellVolume,
			MinConductivity,
			MaxConductivity,
			MinConductivityFlowCellTemperature,
			MaxConductivityFlowCellTemperature
		}]
	]

};



(* ::Subsection::Closed:: *)
(*validModelInstrumentSFCQTests*)


validModelInstrumentSFCQTests[packet:PacketP[Model[Instrument,SupercriticalFluidChromatography]]]:={
	(* Shared fields - Not Null *)
	NotNullFieldTest[packet,{
		Connector,
		Dongle,
		OperatingSystem,
		Positions,
		PositionPlotting,
		Detectors,
		Scale,
		MinSampleVolume,
		MaxSampleVolume,
		MinSampleTemperature,
		MinpH,
		MaxpH,
		MaxSampleTemperature,
		ColumnCompartmentType,
		MinFlowRate,
		MaxFlowRate,
		MinBackPressure,
		MaxBackPressure,
		MinColumnTemperature,
		MaxColumnTemperature,
		MaxColumnLength,
		MaxColumnInternalDiameter,
		MinFlowPressure,
		MaxFlowPressure,
		MinCO2Pressure,
		MaxCO2Pressure,
		TubingMaxPressure,
		PumpMaxPressure,
		NumberOfBuffers,
		PumpType,
		InjectorType
	}
	],

	(*all the mass spec related requirements*)
	If[MemberQ[Lookup[packet,Detectors],MassSpectrometry],
		NotNullFieldTest[packet,{MassAnalyzer, IonSources, IonModes, AcquisitionModes, MinMass, MaxMass, MinMakeupFlowRate, MaxMakeupFlowRate, MinSpectrometerSamplingRate, MaxSpectrometerSamplingRate}],
		Nothing
	],

	(*all the pda related requirements*)
	If[MemberQ[Lookup[packet,Detectors],PhotoDiodeArray],
		NotNullFieldTest[packet,{MinAbsorbanceWavelength, MaxAbsorbanceWavelength, AbsorbanceResolution}],
		Nothing
	],

	(*all the ESI MS related requirements*)
	If[MemberQ[Lookup[packet,IonSources],ESI],
		NotNullFieldTest[packet,{MinSamplingConeVoltage, MaxSamplingConeVoltage, MinESICapillaryVoltage, MaxESICapillaryVoltage, MinSourceTemperature, MaxSourceTemperature, MinDesolvationTemperature, MaxDesolvationTemperature}],
		Nothing
	],

	Test["If ColumnCompartmentType is Selector, MaxNumberOfColumns is informed. Conversely, if ColumnCompartmentType is Serial, MaxNumberOfColumns is Null:",
		Lookup[packet,{ColumnCompartmentType,MaxNumberOfColumns}],
		{Selector,Except[Null]}|{Serial,Null}
	],

	(* Min/Max tests *)
	FieldComparisonTest[packet,{MinFlowRate,MaxFlowRate},LessEqual],
	FieldComparisonTest[packet,{MinAbsorbanceWavelength,MaxAbsorbanceWavelength},LessEqual],
	FieldComparisonTest[packet,{MinSampleTemperature,MaxSampleTemperature},LessEqual],
	FieldComparisonTest[packet,{MinBackPressure,MaxBackPressure},LessEqual],
	FieldComparisonTest[packet,{MinMakeupFlowRate,MaxMakeupFlowRate},LessEqual],
	FieldComparisonTest[packet,{MinpH,MaxpH},LessEqual],
	FieldComparisonTest[packet,{MinColumnTemperature,MaxColumnTemperature},LessEqual],
	FieldComparisonTest[packet,{MinFlowPressure,MaxFlowPressure},LessEqual],
	FieldComparisonTest[packet,{MinCO2Pressure,MaxCO2Pressure},LessEqual],
	FieldComparisonTest[packet,{MinSpectrometerSamplingRate,MaxSpectrometerSamplingRate},LessEqual],
	FieldComparisonTest[packet,{MinESICapillaryVoltage,MaxESICapillaryVoltage},LessEqual],
	FieldComparisonTest[packet,{MinSamplingConeVoltage,MaxSamplingConeVoltage},LessEqual],
	FieldComparisonTest[packet,{MinSourceTemperature,MaxSourceTemperature},LessEqual],
	FieldComparisonTest[packet,{MinSampleVolume,MaxSampleVolume},LessEqual]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentFlashChromatographyQTests*)


validModelInstrumentFlashChromatographyQTests[packet:PacketP[Model[Instrument,FlashChromatography]]]:={

	(* Shared fields - Not Null *)
	NotNullFieldTest[packet,{
			Connector,
			Dongle,
			OperatingSystem,
			Positions,PositionPlotting,
			(* Unique fields required *)
			Detectors,
			Mixer,
			MinFlowRate,
			MaxFlowRate,
			MinPressure,
			TubingMaxPressure,
			PumpMaxPressure,
			MaxColumnLength,
			ColumnConnector,
			MinSampleVolume,
			MaxSampleVolume,
			FlowCellPathLength,
			TubingInnerDiameter,
			InjectionValveLength,
			MaxInjectionAssemblyLength,
			WettedMaterials
		}
	],

	(* Check that DetectorLampType is informed if Absorbance is used *)
	Test["If Absorbance is listed in the Detectors field, DetectorLampType is informed:",
		Module[{detectors,detectorLampType},
			{detectors,detectorLampType}= Lookup[packet,{Detectors,DetectorLampType}];
			{MemberQ[detectors,Absorbance],detectorLampType}
			],
		{True,Except[Null]}|{False,_}
	],
	(* If Detector LampType is informed, then Absorbance criteria must be informed *)
	RequiredTogetherTest[packet,{DetectorLampType,AbsorbanceDetector,AbsorbanceFilterType,MinAbsorbanceWavelength,MaxAbsorbanceWavelength,AbsorbanceWavelengthBandpass}],

	(* Min/Max tests *)
	FieldComparisonTest[packet,{MinFlowRate,MaxFlowRate},LessEqual],
	FieldComparisonTest[packet,{MinPressure,TubingMaxPressure},LessEqual],
	FieldComparisonTest[packet,{MinAbsorbanceWavelength,MaxAbsorbanceWavelength},LessEqual],
	FieldComparisonTest[packet,{MinSampleVolume,MaxSampleVolume},LessEqual]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentColonyHandlerQTests*)


validModelInstrumentColonyHandlerQTests[packet:PacketP[Model[Instrument,ColonyHandler]]]:={
	(* The Deck field is populated *)
	NotNullFieldTest[packet,{Deck}]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentColonyImagerQTests*)


validModelInstrumentColonyImagerQTests[packet:PacketP[Model[Instrument,ColonyImager]]]:={};


(* ::Subsection::Closed:: *)
(*validModelInstrumentCrystalIncubatorQTests*)


validModelInstrumentCrystalIncubatorQTests[packet:PacketP[Model[Instrument,CrystalIncubator]]]:={
	NotNullFieldTest[packet, {
		ImagingModes,
		MicroscopeModes,
		MaxPlateDimensions,
		Capacity,
		MinTemperature,
		MaxTemperature
	}],
	Test["The three indexes in PlateMaxDimension must be all informed:",
		Lookup[packet,MaxPlateDimensions],
		{Except[NullP],Except[NullP],Except[NullP]}
	],
	(* Sensible Min/Max field checks *)
	RequiredTogetherTest[packet,{MinExposureTime,MaxExposureTime}],
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentFluorescenceActivatedCellSorterQTests*)


validModelInstrumentFluorescenceActivatedCellSorterQTests[packet:PacketP[Model[Instrument,FluorescenceActivatedCellSorter]]]:={};


(* ::Subsection::Closed:: *)
(*validModelInstrumentFreezerQTests*)


validModelInstrumentFreezerQTests[packet:PacketP[Model[Instrument,Freezer]]]:={
	(* Fields which should not be null *)
	NotNullFieldTest[packet, {
		DefaultTemperature,
		Positions,
		PositionPlotting
	}],

	Test["The three indexes in InternalDimensions must be all informed:",
		Lookup[packet,InternalDimensions],
		{Except[NullP],Except[NullP],Except[NullP]}
	],

	(* Fields which should be null *)
	NullFieldTest[packet,{Connector,Dongle,OperatingSystem,PCICard}],

	(* Sensible Min/Max field checks *)
	RequiredTogetherTest[packet,{MinTemperature,DefaultTemperature,MaxTemperature}],
	FieldComparisonTest[packet,{MinTemperature,DefaultTemperature,MaxTemperature},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentPortableCoolerQTests*)


validModelInstrumentPortableCoolerQTests[packet:PacketP[Model[Instrument,PortableCooler]]]:={
	(* Fields which should not be null *)
	NotNullFieldTest[packet, {
		Positions,
		PositionPlotting
	}],

	Test["The three indexes in InternalDimensions must be all informed:",
		Lookup[packet,InternalDimensions],
		{Except[NullP],Except[NullP],Except[NullP]}
	],

	(* Fields which should be null *)
	NullFieldTest[packet,{Connector,Dongle,OperatingSystem,PCICard}],

	(* Sensible Min/Max field checks *)
	RequiredTogetherTest[packet,{MinTemperature,MaxTemperature}],
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual],

	(* tests for cryogenic portable coolers *)
	If[
		MatchQ[Lookup[packet, Object], ObjectP[Model[Instrument, PortableCooler, "Brooks CryoPod Portable Cryogenic Freezer"]]],

		{
			NotNullFieldTest[packet,{
				(* Unique fields*)
				StoragePhase,
				LiquidNitrogenCapacity,
				StaticEvaporationRate
			}]
		},

		Nothing
	]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentPortableHeaterQTests*)


validModelInstrumentPortableHeaterQTests[packet:PacketP[Model[Instrument,PortableHeater]]]:={
	(* Fields which should not be null *)
	NotNullFieldTest[packet, {
		Positions,
		PositionPlotting
	}],

	Test["The three indexes in InternalDimensions must be all informed:",
		Lookup[packet,InternalDimensions],
		{Except[NullP],Except[NullP],Except[NullP]}
	],

	(* Fields which should be null *)
	NullFieldTest[packet,{Connector,Dongle,OperatingSystem,PCICard}],

	(* Sensible Min/Max field checks *)
	RequiredTogetherTest[packet,{MinTemperature,MaxTemperature}],
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentFumeHoodQTests*)


validModelInstrumentFumeHoodQTests[packet:PacketP[Model[Instrument,FumeHood]]]:={
	(* Fields which should not be null *)
	NotNullFieldTest[packet,{Mode,FlowMeter,MinFlowSpeed,Plumbing,Positions,PositionPlotting}],

	(* Fields which should all be populated *)
	Test["The three indexes in InternalDimensions must be all informed:",
		Lookup[packet,InternalDimensions],
		{Except[NullP],Except[NullP],Except[NullP]}
	],

	(* Fields which should be null *)
	NullFieldTest[packet,{Connector,Dongle,OperatingSystem,PCICard}]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentHandlingStationFumeHoodQTests*)


validModelInstrumentHandlingStationFumeHoodQTests[packet:PacketP[Model[Instrument,HandlingStation,FumeHood]]]:={
	(* Fields which should not be null *)
	NotNullFieldTest[packet,{Mode,FlowMeter,MinFlowSpeed,Plumbing,Positions,PositionPlotting}],

	(* Fields which should all be populated *)
	Test["The three indexes in InternalDimensions must be all informed:",
		Lookup[packet,InternalDimensions],
		{Except[NullP],Except[NullP],Except[NullP]}
	],

	(* Fields which should be null *)
	NullFieldTest[packet,{Connector,Dongle,PCICard}]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentGasFlowSwitchQTests*)


validModelInstrumentGasFlowSwitchQTests[packet:PacketP[Model[Instrument,GasFlowSwitch]]]:={
	(* Fields which should not be null *)
	NotNullFieldTest[packet,
		{
			HighActivationPressure,
			LowActivationPressure,
			SwitchBackPressure,
			OutputPressure,
			TurnsToOpen
		}
	],
	NullFieldTest[packet,
		{
			Connector,
			Dongle,
			OperatingSystem,
			PCICard,
			WettedMaterials,
			Positions,
			PositionPlotting
			}
	]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentGelBoxQTests*)


validModelInstrumentGelBoxQTests[packet:PacketP[Model[Instrument,GelBox]]]:={
	(* Shared field shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],

	NotNullFieldTest[packet,{Positions,PositionPlotting,BufferVolume}]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentGeneticAnalyzerQTests*)


validModelInstrumentGeneticAnalyzerQTests[packet:PacketP[Model[Instrument,GeneticAnalyzer]]]:={

	NullFieldTest[packet,{

		(* Shared fields *)
		WettedMaterials
	}],


	NotNullFieldTest[packet,{

		(* Shared fields *)
		Connector,
		Dongle,
		OperatingSystem,
		Positions,
		PositionPlotting,

		(* Non-shared fields *)
		MinCapillaryTemperature,
		MaxCapillaryTemperature,
		MinVoltage,
		MaxVoltage
	}],

	Test["MinCapillaryTemperature is smaller than MaxCapillaryTemperature:",
		TrueQ[Lookup[packet,MinCapillaryTemperature]<Lookup[packet,MaxCapillaryTemperature]],
		True
	],

	Test["MinVoltage is smaller than MaxVoltage:",
		TrueQ[Lookup[packet,MinVoltage]<Lookup[packet,MaxVoltage]],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentGloveBoxQTests*)


validModelInstrumentGloveBoxQTests[packet:PacketP[Model[Instrument,GloveBox]]]:={
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentHandlingStationGloveBoxQTests*)


validModelInstrumentHandlingStationGloveBoxQTests[packet:PacketP[Model[Instrument,HandlingStation,GloveBox]]]:={
};



(* ::Subsection::Closed:: *)
(*validModelInstrumentGrinderQTests*)

validModelInstrumentGrinderQTests[packet:PacketP[Model[Instrument,Grinder]]]:={

	(* Shared Field Shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],
	NotNullFieldTest[packet, {Positions,PositionPlotting}],

	(*Specific fields*)
	NotNullFieldTest[packet, {GrinderType,GrindingMaterial}],

	(*If GrinderType is MortarGrinder, the following fields should be populated: MinMortarRate, MaxMortarRate, MinPestleRate, MaxPestleRate, WettedMaterials.*)
	Test["If GrinderType is MortarGrinder, MinMortarRate is populated:",
		If[MatchQ[Lookup[packet,GrinderType],MortarGrinder],
			!MatchQ[Lookup[packet,MinMortarRate],NullP|{}],
			True
		],
		True
	],

	Test["If GrinderType is MortarGrinder, MaxMortarRate is populated:",
		If[MatchQ[Lookup[packet,GrinderType],MortarGrinder],
			!MatchQ[Lookup[packet,MaxMortarRate],NullP|{}],
			True
		],
		True
	],

	Test["If GrinderType is MortarGrinder, MinPestleRate is populated:",
		If[MatchQ[Lookup[packet,GrinderType],MortarGrinder],
			!MatchQ[Lookup[packet,MinPestleRate],NullP|{}],
			True
		],
		True
	],
	Test["If GrinderType is MortarGrinder, MaxPestleRate is populated:",
		If[MatchQ[Lookup[packet,GrinderType],MortarGrinder],
			!MatchQ[Lookup[packet,MaxPestleRate],NullP|{}],
			True
		],
		True
	],
	Test["If GrinderType is MortarGrinder, WettedMaterials is populated:",
		If[MatchQ[Lookup[packet,GrinderType],MortarGrinder],
			!MatchQ[Lookup[packet,WettedMaterials],NullP|{}],
			True
		],
		True
	],

	(*If GrinderType is set to anything other than MortarGrinder, MinGrindingRate and MaxGrindingRate are populated.*)
	Test["If GrinderType is MortarGrinder, MinGrindingRate is populated:",
		If[!MatchQ[Lookup[packet,GrinderType],MortarGrinder],
			!MatchQ[Lookup[packet,MinGrindingRate],NullP|{}],
			True
		],
		True
	],

	Test["If GrinderType is MortarGrinder, MaxGrindingRate is populated:",
		If[!MatchQ[Lookup[packet,GrinderType],MortarGrinder],
			!MatchQ[Lookup[packet,MaxGrindingRate],NullP|{}],
			True
		],
		True
	],

	(* Sensible Min/Max field checks *)
	FieldComparisonTest[packet,{MinGrindingRate,MaxGrindingRate},LessEqual],
	FieldComparisonTest[packet,{MinPestleRate,MaxPestleRate},LessEqual],
	FieldComparisonTest[packet,{MinMortarRate,MaxMortarRate},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentInfraredProbeQTests*)


validModelInstrumentInfraredProbeQTests[packet:PacketP[Model[Instrument,InfraredProbe]]]:={};


(* ::Subsection::Closed:: *)
(*validModelInstrumentLiquidHandlerQTests*)


validModelInstrumentLiquidHandlerQTests[packet:PacketP[Model[Instrument,LiquidHandler]]]:={
	(* Shared Not Null *)
	NotNullFieldTest[packet,
		{
			Connector,
			Dongle,
			OperatingSystem,
			Positions,
			PositionPlotting,
			LiquidHandlerType
		}
	],

	(* Exclude AcousticLiquidHandler subtype from all tests involving the Scale Field *)
	Sequence@@If[MatchQ[packet, ObjectP[Model[Instrument, LiquidHandler, AcousticLiquidHandler]]],

		Nothing,

		{
			(* Specific - All *)
			NotNullFieldTest[packet, Scale],

			(* Tests for MicroLiquidHandling instrument only *)
			Test[
				"If the scale of the instrument is MicroLiquidHandling, TipType must informed (Null otherwise):",
				Module[{scale,tipType},
					{scale,tipType}=Lookup[packet,{Scale,TipType}]
				],
				{MicroLiquidHandling,Except[Null]}|{MacroLiquidHandling,Null}
			],
			Test[
				"If the scale of the instrument is MicroLiquidHandling, InternalDimensions must informed (Null otherwise):",
				Module[{scale,internalDimensions},
					{scale,internalDimensions}=Lookup[packet,{Scale,InternalDimensions}]
				],
				{MicroLiquidHandling,{Except[Null],Except[Null],Except[Null]}}|{MacroLiquidHandling,{Null,Null,Null}}
			],

			(* Tests for Gilsons fields *)
			Test[
				"If the TipType of the instrument is FixedTip, TubingType must informed:",
				Module[{tipType,tubingType},
					{tipType,tubingType}=	Lookup[packet,{TipType,TubingType}];
					If[(tipType)=== FixedTip,
						!NullQ[tubingType],
						True
					]
				],
				True
			],
			Test[
				"If the TipType of the instrument is FixedTip, TubingOuterDiameter must informed:",
				Module[{tipType,tubingOuterDiameter},
					{tipType,tubingOuterDiameter}=	Lookup[packet,{TipType,TubingOuterDiameter}];
					If[(tipType)=== FixedTip,
						!NullQ[tubingOuterDiameter],
						True
					]
				],
				True
			],
			Test[
				"If the TipType of the instrument is FixedTip, SyringeVolume must informed:",
				Module[{tipType,syringeVolume},
					{tipType,syringeVolume}=	Lookup[packet,{TipType,SyringeVolume}];
					If[(tipType)=== FixedTip,
						!NullQ[syringeVolume],
						True
					]
				],
				True
			],
			Test[
				"If the TipType of the instrument is FixedTip, NitrogenPressure must informed:",
				Module[{tipType,nitrogenPressure},
					{tipType,nitrogenPressure}=	Lookup[packet,{TipType,NitrogenPressure}];
					If[(tipType)=== FixedTip,
						!NullQ[nitrogenPressure],
						True
					]
				],
				True
			],
			Test[
				"If the TipType of the instrument is FixedTip, MinFlowRate must informed:",
				Module[{tipType,minFlowRate},
					{tipType,minFlowRate}=Lookup[packet,{TipType,MinFlowRate}];
					If[(tipType)=== FixedTip,
						!NullQ[minFlowRate],
						True
					]
				],
				True
			],
			Test[
				"If the TipType of the instrument is FixedTip, MaxFlowRate must informed:",
				Module[{tipType,maxFlowRate},
					{tipType,maxFlowRate}=Lookup[packet,{TipType,MaxFlowRate}];
					If[(tipType)=== FixedTip,
						!NullQ[maxFlowRate],
						True
					]
				],
				True
			],
			Test[
				"If the TipType of the instrument is FixedTip, PCICard must informed:",
				Module[{tipType,pciCard},
					{tipType,pciCard}=Lookup[packet,{TipType,PCICard}];
					If[(tipType)=== FixedTip,
						!NullQ[pciCard],
						True
					]
				],
				True
			],
			Test[
				"If the TipType of the instrument is FixedTip, PrimeVolume must informed:",
				Module[{tipType,primeVolume},
					{tipType,primeVolume}=Lookup[packet,{TipType,PrimeVolume}];
					If[(tipType)=== FixedTip,
						!NullQ[primeVolume],
						True
					]
				],
				True
			],

			(* Tests for Hamilton fields *)
			Test[
				"If the TipType of the instrument is DisposableTip, MinVolume must informed:",
				Module[{tipType,minVolume},
					{tipType,minVolume}=Lookup[packet,{TipType,MinVolume}];
					If[(tipType)=== DisposableTip,
						!NullQ[minVolume],
						True
					]
				],
				True
			],
			Test[
				"If the TipType of the instrument is DisposableTip, MaxVolume must informed:",
				Module[{tipType,maxVolume},
					{tipType,maxVolume}=Lookup[packet,{TipType,MaxVolume}];
					If[(tipType)=== DisposableTip,
						!NullQ[maxVolume],
						True
					]
				],
				True
			],
			Test[
				"If the TipType of the instrument is DisposableTip, MaxHeight must informed:",
				Module[{tipType,maxHeight},
					{tipType,maxHeight}=Lookup[packet,{TipType,MaxHeight}];
					If[(tipType)=== DisposableTip,
						!NullQ[maxHeight],
						True
					]
				],
				True
			],
			Test[
				"If the TipType of the instrument is DisposableTip, PCICard must not informed:",
				Module[{tipType,pciCard},
					{tipType,pciCard}=Lookup[packet,{TipType,PCICard}];
					If[(tipType)=== DisposableTip,
						pciCard=={},
						True
					]
				],
				True
			],
			Test[
				"If the TipType of the instrument is DisposableTip, IndependentChannels must be informed:",
				Module[{tipType,channels},
					{tipType,channels}=Lookup[packet,{TipType,IndependentChannels}];
					If[(tipType)=== DisposableTip,
						!NullQ[channels],
						True
					]
				],
				True
			],

			(*MacroLiquidHandling Liquid handlers*)
			Test[
				"If the scale of the instrument is MacroLiquidHandling, MinTemperature must be informed (Null otherwise):",
				Module[{scale,minTemperature},
					{scale,minTemperature}=Lookup[packet,{Scale,MinTemperature}]
				],
				{MacroLiquidHandling,Except[Null]}|{MicroLiquidHandling,Null}
			],
			Test[
				"If the scale of the instrument is MacroLiquidHandling, MaxTemperature must be informed (Null otherwise):",
				Module[{scale,maxTemperature},
					{scale,maxTemperature}=Lookup[packet,{Scale,MaxTemperature}]
				],
				{MacroLiquidHandling,Except[Null]}|{MicroLiquidHandling,Null}
			],
			Test[
				"If the scale of the instrument is MacroLiquidHandling, MaxVolumes must be populated:",
				Lookup[packet,{Scale,MaxVolumes}],
				{MacroLiquidHandling,Except[{}]}|{MicroLiquidHandling,{}}
			],
			Test[
				"If the scale of the instrument is MacroLiquidHandling, SmallCylinderMaxVolume must be populated:",
				Lookup[packet,{Scale,SmallCylinderMaxVolume}],
				{MacroLiquidHandling,Except[Null]}|{MicroLiquidHandling,Null}
			],
			Test[
				"If the scale of the instrument is MacroLiquidHandling, MediumCylinderMaxVolume must be populated:",
				Lookup[packet,{Scale,MediumCylinderMaxVolume}],
				{MacroLiquidHandling,Except[Null]}|{MicroLiquidHandling,Null}
			],
			Test[
				"If the scale of the instrument is MacroLiquidHandling, LargeCylinderMaxVolume must be populated:",
				Lookup[packet,{Scale,LargeCylinderMaxVolume}],
				{MacroLiquidHandling,Except[Null]}|{MicroLiquidHandling,Null}
			],
			Test[
				"If the scale of the instrument is MacroLiquidHandling, MinStirRate must be informed (Null otherwise):",
				Module[{scale,minStirRate},
					{scale,minStirRate}=Lookup[packet,{Scale,MinStirRate}]
				],
				{MacroLiquidHandling,Except[Null]}|{MicroLiquidHandling,Null}
			],
			Test[
				"If the scale of the instrument is MacroLiquidHandling, MaxStirRate must be informed (Null otherwise):",
				Module[{scale,maxStirRate},
					{scale,maxStirRate}=Lookup[packet,{Scale,MaxStirRate}]
				],
				{MacroLiquidHandling,Except[Null]}|{MicroLiquidHandling,Null}
			]
		}
	],

	RequiredTogetherTest[packet,{MinFlowRate,MaxFlowRate}],
	FieldComparisonTest[packet, {MinFlowRate,MaxFlowRate},Less],
	RequiredTogetherTest[packet,{IndependentChannels,IndependentChannelResolution}],
	RequiredTogetherTest[packet,{MinVolume,MaxVolume,MaxDefaultTransfers}],
	FieldComparisonTest[packet,{MinVolume,MaxVolume},LessEqual],
	RequiredTogetherTest[packet,{MinTemperature,MaxTemperature}],
	RequiredTogetherTest[packet,{MinStirRate,MaxStirRate}],
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual],
	FieldComparisonTest[packet,{MinStirRate,MaxStirRate},LessEqual],

	(* Test for SPE Gilsons *)
	Test[
		"If the model instrument is solid phase extractor, MethodFilePath must be informed:",
		If[MatchQ[Model[Instrument, LiquidHandler, "id:o1k9jAKOwLl8"],Lookup[packet,Object]],
			!NullQ[Lookup[packet,MethodFilePath]],
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentDensityMeterQTests*)


validModelInstrumentDensityMeterQTests[packet:PacketP[Model[Instrument,DensityMeter]]]:={

	(* Defined fields which should NOT be null *)
	NotNullFieldTest[packet, {
		DefaultDataFilePath,
		DefaultMethodFilePath,
		WettedMaterials,
		(*Density meter specific*)
		DensityAccuracy,
		TemperatureAccuracy,
		ManufacturerDensityRepeatability,
		ManufacturerTemperatureRepeatability,
		ManufacturerReproducibility
	}
	],

	FieldComparisonTest[packet,{MaxDensity,MinDensity},GreaterEqual],
	FieldComparisonTest[packet,{MaxTemperature,MinTemperature},GreaterEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentLyophilizerQTests*)


validModelInstrumentLyophilizerQTests[packet:PacketP[Model[Instrument,Lyophilizer]]]:={
	(* Shared Not Null *)
	NullFieldTest[packet, {
		Dongle,
		OperatingSystem,
		PCICard
	}],

	(* Specific - All *)
	NotNullFieldTest[packet, {
		WettedMaterials,
		Positions,
		CondenserCapacity,
		Connector,

		(* Lyophilizer specific*)
		MaxTemperatureRamp,
		MaxPressureRamp,
		VacuumPump,
		CondenserCapacity,
		MinCondenserTemperature,
		MinShelfTemperature,
		MaxShelfTemperature,
		MinPressure
	}],


	RequiredTogetherTest[packet,{MaxShelfHeight,MinShelfHeight}],
	RequiredTogetherTest[packet,{MinShelfTemperature,MaxShelfTemperature}],
	FieldComparisonTest[packet,{MaxShelfHeight,MinShelfHeight},GreaterEqual],
	FieldComparisonTest[packet,{MaxShelfTemperature,MinShelfTemperature},GreaterEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentHeatBlockQTests*)


validModelInstrumentHeatBlockQTests[packet:PacketP[Model[Instrument,HeatBlock]]]:={

	(* Shared fields which should be null *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],

	NotNullFieldTest[packet,{
			Positions,PositionPlotting,
			MinTemperature,
			MaxTemperature
		}
	],

    (* Fields which should all be populated *)
	Test["The three indexes in InternalDimensions must be all informed:",
		Lookup[packet,InternalDimensions],
		{Except[NullP],Except[NullP],Except[NullP]}
	],

	(* Sensible Min/Max field checks *)
	RequiredTogetherTest[packet,{MinTemperature,MaxTemperature}],
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentHeatExchangerQTests*)


validModelInstrumentHeatExchangerQTests[packet:PacketP[Model[Instrument,HeatExchanger]]]:={

	NotNullFieldTest[packet,{
		Positions,PositionPlotting,
		FluidVolume,
		FillFluid
	}],

	(* Sensible Min/Max field checks *)
	RequiredTogetherTest[packet,{MinTemperature,MaxTemperature}],
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual]

};



(* ::Subsection::Closed:: *)
(*validModelInstrumentIncubatorQTests*)


validModelInstrumentIncubatorQTests[packet:PacketP[Model[Instrument,Incubator]]]:={
	(* Shared fields which should be null *)

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet, {Mode,Positions,PositionPlotting,CellTypes}],

	(* Require related information together *)
	RequiredTogetherTest[packet,{OperatingSystem, Dongle}],

	Test["The three indexes in InternalDimensions must be all informed or all Null or an empty list:",
		Lookup[packet,InternalDimensions],
		{NullP,NullP,NullP}|{Except[NullP],Except[NullP],Except[NullP]|{}}
	],

	(* Sensible Max/Mins*)
	RequiredTogetherTest[packet,{MinTemperature, MaxTemperature}],
	FieldComparisonTest[packet,{MinTemperature, MaxTemperature}, LessEqual],

	RequiredTogetherTest[packet,{MinCarbonDioxide, MaxCarbonDioxide}],
	FieldComparisonTest[packet,{MinCarbonDioxide, MaxCarbonDioxide}, LessEqual],

	RequiredTogetherTest[packet,{MinRelativeHumidity, MaxRelativeHumidity}],
	FieldComparisonTest[packet,{MinRelativeHumidity, MaxRelativeHumidity}, LessEqual]
};



(* ::Subsection::Closed:: *)
(*validModelInstrumentIonChromatographyQTests*)


validModelInstrumentIonChromatographyQTests[packet:PacketP[Model[Instrument, IonChromatography]]]:={
	(* Shared fields which should be null *)

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet,{
			Connector,
			Dongle,
			OperatingSystem,
			Positions,
			PositionPlotting,
			MinFlowRate,
			MaxFlowRate,
			MinPressure,
			TubingMaxPressure,
			SampleLoop,
			MinSampleVolume,
			MaxSampleVolume,
			MinSampleTemperature,
			MaxSampleTemperature
		}
	],

	If[MemberQ[packet[AnalysisChannels],AnionChannel],
		NotNullFieldTest[packet,{
			AnionDetector,
			AnionSuppressor,
			AnionNumberOfBuffers,
			AnionPumpType,
			AnionMinColumnTemperature,
			AnionMaxColumnTemperature,
			AnionMaxColumnLength,
			AnionMaxColumnOutsideDiameter,
			AnionPumpMinPressure,
			AnionPumpMaxPressure,
			AnionMinDetectionTemperature,
			AnionMaxDetectionTemperature
		}],
		Nothing
	],

	If[MemberQ[packet[AnalysisChannels],CationChannel],
		NotNullFieldTest[packet,{
			CationDetector,
			CationSuppressor,
			CationNumberOfBuffers,
			CationPumpType,
			CationMinColumnTemperature,
			CationMaxColumnTemperature,
			CationMaxColumnLength,
			CationMaxColumnOutsideDiameter,
			CationPumpMinPressure,
			CationPumpMaxPressure,
			CationMinDetectionTemperature,
			CationMaxDetectionTemperature
		}],
		Nothing
	],

	If[MemberQ[packet[AnalysisChannels],ElectrochemicalChannel],
		NotNullFieldTest[packet,{
			Detectors,
			NumberOfBuffers,
			PumpType,
			MinColumnTemperature,
			MaxColumnTemperature,
			MaxColumnLength,
			MaxColumnOutsideDiameter,
			PumpMinPressure,
			PumpMaxPressure
		}],
		Nothing
	],

	If[MemberQ[packet[Detectors],UVVis],
		NotNullFieldTest[packet,{
			DetectorLampType,
			MinAbsorbanceWavelength,
			MaxAbsorbanceWavelength,
			AbsorbanceWavelengthBandpass
		}],
		Nothing
	],

	If[MemberQ[packet[Detectors],ElectrochemicalDetector],
		NotNullFieldTest[packet,{
			ElectrochemicalDetectionMode,
			ReferenceElectrode,
			MinDetectionTemperature,
			MaxDetectionTemperature,
			MinDetectionVoltage,
			MaxDetectionVoltage,
			MinFlowCellpH,
			MaxFlowCellpH
		}],
		Nothing
	],


	(* Min/Max tests *)
	FieldComparisonTest[packet, {MinFlowRate,MaxFlowRate}, LessEqual],
	FieldComparisonTest[packet, {MinPressure,TubingMaxPressure}, LessEqual],
	FieldComparisonTest[packet, {MinSampleVolume,MaxSampleVolume}, LessEqual],
	FieldComparisonTest[packet, {AnionPumpMinPressure,AnionPumpMaxPressure}, LessEqual],
	FieldComparisonTest[packet, {CationPumpMinPressure,CationPumpMaxPressure}, LessEqual],
	FieldComparisonTest[packet, {AnionMinColumnTemperature,AnionMaxColumnTemperature}, LessEqual],
	FieldComparisonTest[packet, {CationMinColumnTemperature,CationMaxColumnTemperature}, LessEqual],
	FieldComparisonTest[packet, {AnionMinDetectionTemperature, AnionMaxDetectionTemperature}, LessEqual],
	FieldComparisonTest[packet, {CationMinDetectionTemperature, CationMaxDetectionTemperature}, LessEqual],
	FieldComparisonTest[packet, {MinAbsorbanceWavelength,MaxAbsorbanceWavelength}, LessEqual],
	FieldComparisonTest[packet, {MinDetectionTemperature,MaxDetectionTemperature}, LessEqual],
	FieldComparisonTest[packet, {MinDetectionVoltage,MaxDetectionVoltage}, LessEqual],
	FieldComparisonTest[packet, {MinFlowCellpH,MaxFlowCellpH}, LessEqual]
};

(* ::Subsection::Closed:: *)
(*validModelInstrumentKarlFischerTiratorQTests*)


validModelInstrumentKarlFischerTiratorQTests[packet:PacketP[Model[Instrument, KarlFischerTitrator]]]:={
	(* Shared fields which should be null *)

	(* Shared fields which should NOT be null *)
	NotNullFieldTest[packet,{
		Positions,
		PositionPlotting,
		TitrationTechnique,
		SamplingMethods
	}
	],


	(* Min/Max tests *)
	FieldComparisonTest[packet, {MinTemperature,MaxTemperature}, LessEqual]
};

(* ::Subsection::Closed:: *)
(*validModelInstrumentLightMeterQTests*)


validModelInstrumentLightMeterQTests[packet:PacketP[Model[Instrument,LightMeter]]]:={

	(* Shared field shaping *)
	NullFieldTest[packet,{Positions,PositionPlotting}],

	(* Sensible Min/Max field checks *)
	FieldComparisonTest[packet,{MinMeasurableIntensity,MaxMeasurableIntensity},LessEqual],
	FieldComparisonTest[packet,{MinWavelength,MaxWavelength},LessEqual],
	FieldComparisonTest[packet,{MinOperationalTemperature,MaxOperationalTemperature},LessEqual],
	FieldComparisonTest[packet,{MinOperationalRelativeHumidity,MaxOperationalRelativeHumidty},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentLiquidLevelDetectorQTests*)


validModelInstrumentLiquidLevelDetectorQTests[packet:PacketP[Model[Instrument,LiquidLevelDetector]]]:={

	(* Shared field shaping *)
	RequiredTogetherTest[packet,{Connector,OperatingSystem}],

	(* Fields which should not be Null *)
	NotNullFieldTest[packet,{Positions,PositionPlotting,MinDistance,MaxDistance}]

};



(* ::Subsection::Closed:: *)
(*validModelInstrumentLiquidNitrogenDoserQTests*)


validModelInstrumentLiquidNitrogenDoserQTests[packet:PacketP[Model[Instrument,LiquidNitrogenDoser]]]:={

	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],

	(* Fields which should not be Null *)
	NotNullFieldTest[packet,{FlowRate,MinVolume}]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentLiquidParticleCounterQTests*)


validModelInstrumentLiquidParticleCounterQTests[packet:PacketP[Model[Instrument,LiquidParticleCounter]]]:={

	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],
	
	NotNullFieldTest[packet,{
		MinParticleSize,
		MaxParticleSize,
		MinSampleTemperature,
		MaxSampleTemperature,
		MinSyringeFlowRate,
		MaxSyringeFlowRate,
		MinStirRate,
		MaxStirRate,
		SampleContainerClearance
	}]

};



(* ::Subsection::Closed:: *)
(*validModelInstrumentMassSpectrometerQTests*)


validModelInstrumentMassSpectrometerQTests[packet:PacketP[Model[Instrument,MassSpectrometer]]]:={
	(* Shared field shaping *)
	NotNullFieldTest[packet, {
			Connector,
			OperatingSystem,
			Dongle,
			WettedMaterials,
			Positions,PositionPlotting,
			MassAnalyzer,
			IonSources,
			IonModes,
			MinMass,
			MaxMass,
			AcquisitionModes
		}
	],

(* Tests for TOF Analyzer *)
	Test[
		"If TOF, MinAcceleratingVoltage is informed:",
		Module[
		{massAnalyzer, minAcceleratingVoltage},
			{massAnalyzer, minAcceleratingVoltage}= Lookup[packet,	{MassAnalyzer, MinAcceleratingVoltage}];
			If[(massAnalyzer)=== TOF,
				!NullQ[minAcceleratingVoltage],
				True
			]
		],
		True
	],
	Test[
		"If TOF, MaxAcceleratingVoltage is informed:",
		Module[
		{massAnalyzer, maxAcceleratingVoltage},
			{massAnalyzer, maxAcceleratingVoltage}= Lookup[packet,	{MassAnalyzer, MaxAcceleratingVoltage}];
			If[(massAnalyzer)=== TOF,
				!NullQ[maxAcceleratingVoltage],
				True
			]
		],
		True
	],
	Test[
		"If TOF,  MinGridVoltage is informed:",
		Module[
		{massAnalyzer, minGridVoltage},
			{massAnalyzer, minGridVoltage}= Lookup[packet,	{MassAnalyzer, MinGridVoltage}];
			If[(massAnalyzer)=== TOF,
				!NullQ[minGridVoltage],
				True
			]
		],
		True
	],
	Test[
		"If TOF,  MaxGridVoltage is informed:",
		Module[
		{massAnalyzer, maxGridVoltage},
			{massAnalyzer, maxGridVoltage}= Lookup[packet,	{MassAnalyzer, MaxGridVoltage}];
			If[(massAnalyzer)=== TOF,
				!NullQ[maxGridVoltage],
				True
			]
		],
		True
	],
	Test[
		"If TOF,  MinLensVoltage is informed:",
		Module[
		{massAnalyzer, minLensVoltage},
			{massAnalyzer, minLensVoltage}= Lookup[packet,	{MassAnalyzer, MinLensVoltage}];
			If[(massAnalyzer)=== TOF,
				!NullQ[minLensVoltage],
				True
			]
		],
		True
	],
	Test[
		"If TOF, MaxLensVoltage is informed:",
		Module[
		{massAnalyzer, maxLensVoltage},
			{massAnalyzer, maxLensVoltage}= Lookup[packet,	{MassAnalyzer, MaxLensVoltage}];
			If[(massAnalyzer)=== TOF,
				!NullQ[maxLensVoltage],
				True
			]
		],
		True
	],
	Test[
		"If TOF,  MinDelayTime is informed:",
		Module[
		{massAnalyzer, minDelayTime},
			{massAnalyzer, minDelayTime}= Lookup[packet,	{MassAnalyzer, MinDelayTime}];
			If[(massAnalyzer)=== TOF,
				!NullQ[minDelayTime],
				True
			]
		],
		True
	],
	Test[
		"If TOF,  MaxDelayTime is informed:",
		Module[
		{massAnalyzer, maxDelayTime},
			{massAnalyzer, maxDelayTime}= Lookup[packet,	{MassAnalyzer, MaxDelayTime}];
			If[(massAnalyzer)=== TOF,
				!NullQ[maxDelayTime],
				True
			]
		],
		True
	],

	(* Tests for MALDI Source fields *)
	Test["If MALDI, LaserWavelength is informed:",
		Module[
		{ionSources, laserWavelength},
			{ionSources, laserWavelength}= Lookup[packet,	{IonSources, LaserWavelength}];
			{MemberQ[ionSources,MALDI], laserWavelength}
		],
		{True,Except[NullP|{}]}|{False,NullP|{}}
	],


	Test["If MALDI, LaserPulseWidth is informed:",
		Module[
		{ionSources, laserPulseWidth},
			{ionSources, laserPulseWidth}= Lookup[packet,	{IonSources, LaserPulseWidth}];
			{MemberQ[ionSources,MALDI], laserPulseWidth}
		],
		{True,Except[NullP|{}]}|{False,NullP|{}}
	],
	Test["If MALDI, LaserFrequency is informed:",
		Module[
		{ionSources, laserFrequency},
			{ionSources, laserFrequency}= Lookup[packet,	{IonSources, LaserFrequency}];
			{MemberQ[ionSources,MALDI], laserFrequency}
		],
		{True,Except[NullP|{}]}|{False,NullP|{}}
	],
	Test["If MALDI, LaserPower is informed:",
		Module[
		{ionSources, laserPower},
			{ionSources, laserPower}= Lookup[packet,	{IonSources, LaserPower}];
			{MemberQ[ionSources,MALDI], laserPower}
		],
		{True,Except[NullP|{}]}|{False,NullP|{}}
	],

    (*QTOF and MALDI-TOF Specific*)
	Test[
		"If QTOF or TOF, Reflectron is informed:",
		Module[
		{massAnalyzer, reflectron},
			{massAnalyzer, reflectron}= Lookup[packet,	{MassAnalyzer, Reflectron}];
			If[((massAnalyzer)=== QTOF||(massAnalyzer)=== TOF),
				!NullQ[reflectron],
				True
			]
		],
		True
	],


(* Tests for ESI Source fields *)
	Test["If ESI, MinESICapillaryVoltage is informed:",
		Module[
		{ionSources, minESICapillaryVoltage},
			{ionSources, minESICapillaryVoltage}= Lookup[packet,{IonSources, MinESICapillaryVoltage}];
			{MemberQ[ionSources,ESI], minESICapillaryVoltage}
		],
		{True,Except[NullP|{}]}|{False,NullP|{}}
	],
	Test["If ESI, MaxESICapillaryVoltage is informed:",
		Module[
		{ionSources, maxESICapillaryVoltage},
			{ionSources, maxESICapillaryVoltage}= Lookup[packet,{IonSources, MaxESICapillaryVoltage}];
			{MemberQ[ionSources,ESI], maxESICapillaryVoltage}
		],
		{True,Except[NullP|{}]}|{False,NullP|{}}
	],
	Test[
		"If QTOF, MinStepwaveVoltage is informed:",
		Module[
		{massAnalyzer, minStepwaveVoltage},
			{massAnalyzer, minStepwaveVoltage}= Lookup[packet,{MassAnalyzer, MinStepwaveVoltage}];
			If[(massAnalyzer)=== QTOF,
				!NullQ[minStepwaveVoltage],
				True
			]
		],
		True
	],
	Test[
		"If QTOF, MaxStepwaveVoltage is informed:",
		Module[
		{massAnalyzer, maxStepwaveVoltage},
			{massAnalyzer, maxStepwaveVoltage}= Lookup[packet,	{MassAnalyzer, MaxStepwaveVoltage}];
			If[(massAnalyzer)=== QTOF,
				!NullQ[maxStepwaveVoltage],
				True
			]
		],
		True
	],
	Test[
		"If ESI, MinSourceTemperature is informed:",
		Module[
		{ionSources, minSourceTemperature},
			{ionSources, minSourceTemperature}= Lookup[packet,	{IonSources, MinSourceTemperature}];
			If[MemberQ[ionSources,ESI],
				!NullQ[minSourceTemperature],
				True
			]
		],
		True
	],
	Test[
		"If ESI, MaxSourceTemperature is informed:",
		Module[
		{ionSources, maxSourceTemperature},
			{ionSources, maxSourceTemperature}= Lookup[packet,	{IonSources, MaxSourceTemperature}];
			If[MemberQ[ionSources,ESI],
				!NullQ[maxSourceTemperature],
				True
			]
		],
		True
	],
	Test["If ESI, MinDesolvationTemperature is informed:",
		Module[
		{ionSources, minDesolvationTemperature},
			{ionSources, minDesolvationTemperature}= Lookup[packet,	{IonSources, MinDesolvationTemperature}];
			{MemberQ[ionSources,ESI], minDesolvationTemperature}
		],
		{True,Except[NullP|{}]}|{False,NullP|{}}
	],
	Test["If ESI, MaxDesolvationTemperature is informed:",
		Module[
		{ionSources, maxDesolvationTemperature},
			{ionSources, maxDesolvationTemperature}= Lookup[packet,	{IonSources, MaxDesolvationTemperature}];
			{MemberQ[ionSources,ESI], maxDesolvationTemperature}
		],
		{True,Except[NullP|{}]}|{False,NullP|{}}
	],
	Test["If ESI, MinConeGasFlow is informed:",
		Module[
		{ionSources, minConeGasFlow},
			{ionSources, minConeGasFlow}= Lookup[packet,	{IonSources, MinConeGasFlow}];
			{MemberQ[ionSources,ESI], minConeGasFlow}
		],
		{True,Except[NullP|{}]}|{False,NullP|{}}
	],
	Test["If ESI, MaxConeGasFlow is informed:",
		Module[
		{ionSources, maxConeGasFlow},
			{ionSources, maxConeGasFlow}= Lookup[packet,	{IonSources, MaxConeGasFlow}];
			{MemberQ[ionSources,ESI], maxConeGasFlow}
		],
		{True,Except[NullP|{}]}|{False,NullP|{}}
	],
	Test["If ESI, MinDesolvationGasFlow is informed:",
		Module[
		{ionSources, minDesolvationGasFlow},
			{ionSources, minDesolvationGasFlow}= Lookup[packet,	{IonSources, MinDesolvationGasFlow}];
			{MemberQ[ionSources,ESI], minDesolvationGasFlow}
		],
		{True,Except[NullP|{}]}|{False,NullP|{}}
	],
	Test["If ESI, MaxDesolvationGasFlow is informed:",
		Module[
		{ionSources, maxDesolvationGasFlow},
			{ionSources, maxDesolvationGasFlow}= Lookup[packet,	{IonSources, MaxDesolvationGasFlow}];
			{MemberQ[ionSources,ESI], maxDesolvationGasFlow}
		],
		{True,Except[NullP|{}]}|{False,NullP|{}}
	],
	Test[
		"If QQQ, MinDeclusteringVoltage is informed:",
		Module[
			{massAnalyzer, minSourceOffset},
			{massAnalyzer, minSourceOffset}= Lookup[packet,	{MassAnalyzer, MinDeclusteringVoltage}];
			If[(massAnalyzer)=== TripleQuadrupole,
				!NullQ[minSourceOffset],
				True
			]
		],
		True
	],
	Test[
		"If QQQ, MaxDeclusteringVoltage is informed:",
		Module[
			{massAnalyzer, maxSourceOffset},
			{massAnalyzer, maxSourceOffset}= Lookup[packet,	{MassAnalyzer, MaxDeclusteringVoltage}];
			If[(massAnalyzer)=== TripleQuadrupole,
				!NullQ[maxSourceOffset],
				True
			]
		],
		True
	],
	Test[
		"If QQQ, MinIonGuideVoltage is informed:",
		Module[
			{massAnalyzer, minSourceOffset},
			{massAnalyzer, minSourceOffset}= Lookup[packet,	{MassAnalyzer, MinIonGuideVoltage}];
			If[(massAnalyzer)=== TripleQuadrupole,
				!NullQ[minSourceOffset],
				True
			]
		],
		True
	],
	Test[
		"If QQQ, MaxIonGuideVoltage is informed:",
		Module[
			{massAnalyzer, maxSourceOffset},
			{massAnalyzer, maxSourceOffset}= Lookup[packet,	{MassAnalyzer, MinIonGuideVoltage}];
			If[(massAnalyzer)=== TripleQuadrupole,
				!NullQ[maxSourceOffset],
				True
			]
		],
		True
	],

(* Tests for Tandem Analyzer *)
	Test[
		"If QTOF, MinDeclusteringVoltage is informed:",
		Module[
		{massAnalyzer, minSourceOffset},
			{massAnalyzer, minSourceOffset}= Lookup[packet,	{MassAnalyzer, MinDeclusteringVoltage}];
			If[(massAnalyzer)=== QTOF,
				!NullQ[minSourceOffset],
				True
			]
		],
		True
	],
	Test[
		"If QTOF, MaxDeclusteringVoltage is informed:",
		Module[
		{massAnalyzer, maxSourceOffset},
			{massAnalyzer, maxSourceOffset}= Lookup[packet,	{MassAnalyzer, MaxDeclusteringVoltage}];
			If[(massAnalyzer)=== QTOF,
				!NullQ[maxSourceOffset],
				True
			]
		],
		True
	],


(*Logical tests*)
	FieldComparisonTest[packet, {MinMass, MaxMass}, LessEqual],
	FieldComparisonTest[packet, {MinAcceleratingVoltage, MaxAcceleratingVoltage}, LessEqual],
	FieldComparisonTest[packet, {MinGridVoltage, MaxGridVoltage}, LessEqual],
	FieldComparisonTest[packet, {MinDelayTime, MaxDelayTime}, LessEqual],
	FieldComparisonTest[packet, {MinShots, MaxShots}, LessEqual],
	FieldComparisonTest[packet, {MinLensVoltage, MaxLensVoltage}, LessEqual],
	FieldComparisonTest[packet, {MinGuideWireVoltage, MaxGuideWireVoltage}, LessEqual],
  	FieldComparisonTest[packet, {MinDeclusteringVoltage, MaxDeclusteringVoltage}, LessEqual],
	FieldComparisonTest[packet, {MinShots, MaxShots}, LessEqual],
	FieldComparisonTest[packet, {MinESICapillaryVoltage, MaxESICapillaryVoltage}, LessEqual],
	FieldComparisonTest[packet, {MinIonGuideVoltage, MaxIonGuideVoltage}, LessEqual],
	FieldComparisonTest[packet, {MinStepwaveVoltage, MaxStepwaveVoltage}, LessEqual],
	FieldComparisonTest[packet, {MinDesolvationTemperature, MaxDesolvationTemperature}, LessEqual],
	FieldComparisonTest[packet, {MinConeGasFlow, MaxConeGasFlow}, LessEqual],
	FieldComparisonTest[packet, {MinDesolvationGasFlow, MaxDesolvationGasFlow}, LessEqual],
	FieldComparisonTest[packet, {MinCollisionEnergy, MaxCollisionEnergy}, LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentMeltingPointApparatusQTests*)


validModelInstrumentMeltingPointApparatusQTests[packet:PacketP[Model[Instrument,MeltingPointApparatus]]]:={

	(* Shared Field Shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard,WettedMaterials}],

	(*Specific fields*)
	NotNullFieldTest[packet, {Measurands,NumberOfMeltingPointCapillarySlots,MinTemperature,MaxTemperature,MinTemperatureRampRate,MaxTemperatureRampRate}],

	(*FieldComparisonTests*)
	FieldComparisonTest[packet, {MinTemperature, MaxTemperature}, Less],
	FieldComparisonTest[packet, {MinTemperatureRampRate, MaxTemperatureRampRate}, LessEqual]

};



(* ::Subsection::Closed:: *)
(*validModelInstrumentMicroscopeQTests*)


validModelInstrumentMicroscopeQTests[packet:PacketP[Model[Instrument,Microscope]]]:={
	(* Shared field shaping *)
	NullFieldTest[packet,{WettedMaterials}],

	(* Fields which should not be null *)
	NotNullFieldTest[packet,{
		Positions,
		PositionPlotting,
		Modes,
		Orientation,
		Objectives,
		ActiveHumidityControl,
		Autofocus,
		CarbonDioxideControl,
		DefaultTransmittedLightPower,
		HighContentImaging,
		HumidityControl,
		IlluminationTypes,
		ObjectiveMagnifications
	}],

	(* Core computer information is required together *)
	RequiredTogetherTest[packet,{OperatingSystem,Dongle,Connector}],

	(* fields required together *)
	RequiredTogetherTest[packet,{
		CameraModel,
		DefaultMethodFilePath,
		DefaultDataFilePath,
		DefaultQualificationImageFilePath,
		ImagingChannels,
		CustomizableImagingChannel,
		PixelBinning,
		ImageSizeX,
		ImageSizeY,
		ImageScalesX,
		ImageScalesY,
		MaxGrayLevel,
		SamplingMethods,
		DefaultSamplingMethod,
		ImageDeconvolution,
		TimelapseImaging,
		ZStackImaging,
		MaxImagingChannels,
		MinExposureTime,
		MaxExposureTime,
		MaxGrayLevel
	}],

	Test["If the microscope has an Epifluorescence or ConfocalFluorescence mode, the following fields must be informed: CameraModel, DefaultExcitationPowers, DichroicFilterWavelengths, FluorescenceEmissionWavelengths, FluorescenceExcitationWavelengths:",
		Module[{fieldValuesToCheck},
			If[MemberQ[Lookup[packet,Modes],(Epifluorescence|ConfocalFluorescence)],
				fieldValuesToCheck=Lookup[packet,{CameraModel,DefaultExcitationPowers,DichroicFilterWavelengths,FluorescenceEmissionWavelengths,FluorescenceExcitationWavelengths}];
				!MemberQ[fieldValuesToCheck,Null|{}],
				True
			]
		],
		True
	],

	(* sync ObjectiveMagnifications and objectives *)
	Test["ObjectiveMagnifications field is synced with Objectives:",
		Module[{objectives,objectiveMagnifications},
			{objectives,objectiveMagnifications}=Lookup[packet,{Objectives,ObjectiveMagnifications}];
			If[!MatchQ[objectives,{}],
				ContainsExactly[Computables`Private`getMicroscopeObjectiveMagnifications[objectives],objectiveMagnifications],
				MatchQ[objectives,{}]&&MatchQ[objectiveMagnifications,{}]
			]
		],
		True
	],

	Test["If HighContentImager is True, CameraModel and DefaultLabwareDefinitionFilePath must be informed:",
		Module[{fieldValuesToCheck},
			If[TrueQ[Lookup[packet,HighContentImager]],
				fieldValuesToCheck=Lookup[packet,{CameraModel,DefaultLabwareDefinitionFilePath}];
				!MemberQ[fieldValuesToCheck,Null],
				True
			]
		],
		True
	],

	Test["If MicroscopeCalibration is True, CondenserMaxHeight and CondenserMinHeight must be informed:",
		Module[{fieldValuesToCheck},
			If[TrueQ[Lookup[packet,MicroscopeCalibration]],
				fieldValuesToCheck=Lookup[packet,{CondenserMaxHeight,CondenserMinHeight}];
				!MemberQ[fieldValuesToCheck,Null],
				True
			]
		],
		True
	],

	Test["If TemperatureControlledEnvironment is True, MaxTemperatureControl and MinTemperatureControl must be informed:",
		Module[{fieldValuesToCheck},
			If[TrueQ[Lookup[packet,TemperatureControlledEnvironment]],
				fieldValuesToCheck=Lookup[packet,{MaxTemperatureControl,MinTemperatureControl}];
				!MemberQ[fieldValuesToCheck,Null],
				True
			]
		],
		True
	],

	(* index-matching check *)
	Test["If DefaultImageCorrections is populated, the values must index match to Modes:",
		Module[{defaultImageCorrections,modes},
			{defaultImageCorrections,modes}=Lookup[packet,{DefaultImageCorrections,Modes}];
			If[!MatchQ[defaultImageCorrections,{}],
				Length[defaultImageCorrections]==Length[modes],
				True
			]
		],
		True
	],
	Test["If ImageScalesX is populated, the values must index match to ObjectiveMagnifications:",
		Module[{imageScalesX,objectiveMagnifications},
			{imageScalesX,objectiveMagnifications}=Lookup[packet,{ImageScalesX,ObjectiveMagnifications}];
			If[!MatchQ[imageScalesX,{}],
				Length[imageScalesX]==Length[objectiveMagnifications],
				True
			]
		],
		True
	],
	Test["If ImageScalesY is populated, the values must index match to ObjectiveMagnifications:",
		Module[{imageScalesY,objectiveMagnifications},
			{imageScalesY,objectiveMagnifications}=Lookup[packet,{ImageScalesY,ObjectiveMagnifications}];
			If[!MatchQ[imageScalesY,{}],
				Length[imageScalesY]==Length[objectiveMagnifications],
				True
			]
		],
		True
	],
	Test["If FluorescenceExcitationWavelengths is populated, the values must index match to ImagingChannels:",
		Module[{excitationWavelengths,imagingChannels},
			{excitationWavelengths,imagingChannels}=Lookup[packet,{FluorescenceExcitationWavelengths,ImagingChannels}];
			If[!MatchQ[excitationWavelengths,{}],
				Length[excitationWavelengths]==Length[imagingChannels],
				True
			]
		],
		True
	],
	Test["If FluorescenceEmissionWavelengths is populated, the values must index match to ImagingChannels:",
		Module[{emissionWavelengths,imagingChannels},
			{emissionWavelengths,imagingChannels}=Lookup[packet,{FluorescenceEmissionWavelengths,ImagingChannels}];
			If[!MatchQ[emissionWavelengths,{}],
				Length[emissionWavelengths]==Length[imagingChannels],
				True
			]
		],
		True
	],
	Test["If EmissionFilters is populated, the values must index match to ImagingChannels:",
		Module[{emissionFilters,imagingChannels},
			{emissionFilters,imagingChannels}=Lookup[packet,{EmissionFilters,ImagingChannels}];
			If[!MatchQ[emissionFilters,{}],
				Length[emissionFilters]==Length[imagingChannels],
				True
			]
		],
		True
	],
	Test["If DichroicFilterWavelengths is populated, the values must index match to ImagingChannels:",
		Module[{dichroicFilterWavelengths,imagingChannels},
			{dichroicFilterWavelengths,imagingChannels}=Lookup[packet,{DichroicFilterWavelengths,ImagingChannels}];
			If[!MatchQ[dichroicFilterWavelengths,{}],
				Length[dichroicFilterWavelengths]==Length[imagingChannels],
				True
			]
		],
		True
	],
	Test["If DichroicFilters is populated, the values must index match to ImagingChannels:",
		Module[{dichroicFilters,imagingChannels},
			{dichroicFilters,imagingChannels}=Lookup[packet,{DichroicFilters,ImagingChannels}];
			If[!MatchQ[dichroicFilters,{}],
				Length[dichroicFilters]==Length[imagingChannels],
				True
			]
		],
		True
	],
	Test["If DefaultExcitationPowers is populated, the values must index match to ImagingChannels:",
		Module[{defaultExcitationPowers,imagingChannels},
			{defaultExcitationPowers,imagingChannels}=Lookup[packet,{DefaultExcitationPowers,ImagingChannels}];
			If[!MatchQ[defaultExcitationPowers,{}],
				Length[defaultExcitationPowers]==Length[imagingChannels],
				True
			]
		],
		True
	],

	Test["If populated, each member of FluorescenceEmissionWavelengths must be higher than index-matching FluorescenceExcitationWavelengths:",
		Module[{emissionWavelengths,excitationWavelengths},
			{emissionWavelengths,excitationWavelengths}=Lookup[packet,{FluorescenceEmissionWavelengths,FluorescenceExcitationWavelengths}];
			If[!MatchQ[emissionWavelengths,{}]&&!MatchQ[excitationWavelengths,{}],
				And@@MapThread[
					MatchQ[#1,GreaterP[#2]]&,
					{emissionWavelengths,excitationWavelengths}
				],
				True
			]
		],
		True
	],

	(* position check *)
	Test["\"Sample Slot\" must be defined as one of the AllowedPositions and must have Footprint specified:",
		Module[{sampleSlot,sampleSlotDefinedQ},
			sampleSlotDefinedQ=StringMatchQ["Sample Slot",Lookup[packet,AllowedPositions],IgnoreCase->True];
			If[sampleSlotDefinedQ,
				(
					sampleSlot=Select[Lookup[packet,Positions],StringContainsQ[Lookup[#,Name],"sample slot",IgnoreCase->True]&];
					!NullQ[Lookup[sampleSlot,Footprint]]
				),
				False
			]
		],
		True
	],

	(* Sensible Min/Max field checks *)
	FieldComparisonTest[packet,{CondenserMinHeight,CondenserMaxHeight},LessEqual],
	FieldComparisonTest[packet,{MinTemperatureControl,MaxTemperatureControl},LessEqual],
	FieldComparisonTest[packet,{MinExposureTime,MaxExposureTime},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentMicroscopeProbeQTests*)


validModelInstrumentMicroscopeProbeQTests[packet:PacketP[Model[Instrument,MicroscopeProbe]]]:={};


(* ::Subsection::Closed:: *)
(*validModelInstrumentMicrowaveQTests*)


validModelInstrumentMicrowaveQTests[packet:PacketP[Model[Instrument,Microwave]]]:={

	(* Shared field shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],

	NotNullFieldTest[packet, {Rotating,Positions,PositionPlotting}],

	(* fields should all be populated *)
	Test["The three indexes in InternalDimensions must be all informed:",
		Lookup[packet,InternalDimensions],
		{Except[NullP],Except[NullP],Except[NullP]}
	]

};



(* ::Subsection::Closed:: *)
(*validModelInstrumentReactorMicrowaveQTests*)


validModelInstrumentReactorMicrowaveQTests[packet:PacketP[Model[Instrument, Reactor, Microwave]]]:={

	(* Shared field shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],

	NotNullFieldTest[packet, {Positions,PositionPlotting}]
};



(* ::Subsection::Closed:: *)
(*validModelInstrumentNMRQTests*)


validModelInstrumentNMRQTests[packet:PacketP[Model[Instrument,NMR]]]:={

	(* Shared field shaping *)
	NotNullFieldTest[packet,{Positions,PositionPlotting}],

	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}]

};

(* ::Subsection::Closed:: *)
(*validModelInstrumentHotPlateQTests*)

validModelInstrumentHotPlateQTests[packet:PacketP[Model[Instrument, HotPlate]]] := {
	NotNullFieldTest[packet, {MaxTemperature, MinTemperature, StirBarControl, StageDimensions, StageMaterial}],
	FieldComparisonTest[packet, {MaxTemperature, MinTemperature}, GreaterEqual],
	FieldComparisonTest[packet, {MaxStirRate, MinStirRate}, GreaterEqual]
};



(* ::Subsection::Closed:: *)
(*validModelInstrumentOverheadStirrerQTests*)


validModelInstrumentOverheadStirrerQTests[packet:PacketP[Model[Instrument, OverheadStirrer]]]:={
	NotNullFieldTest[packet, {CompatibleImpellers,MinRotationRate, MaxRotationRate, StirBarControl,MinTemperature, MaxTemperature}],
	FieldComparisonTest[packet, {MaxRotationRate, MinRotationRate}, GreaterEqual],
	FieldComparisonTest[packet, {MaxTemperature, MinTemperature}, GreaterEqual],
	If[TrueQ[Lookup[packet,StirBarControl]],
		Sequence@{
			NotNullFieldTest[packet, {MinStirBarRotationRate, MaxStirBarRotationRate}],
			FieldComparisonTest[packet, {MaxStirBarRotationRate, MinStirBarRotationRate}, GreaterEqual]
		},
		NullFieldTest[packet,{MaxStirBarRotationRate, MinStirBarRotationRate}]
	]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentPackingDeviceQTests*)


validModelInstrumentPackingDeviceQTests[packet:PacketP[Model[Instrument,PackingDevice]]]:={

	(* Shared Field Shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard,WettedMaterials}],

	(*Specific fields*)
	NotNullFieldTest[packet, {NumberOfCapillaries}]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentParticleSizeProbeQTests*)


validModelInstrumentParticleSizeProbeQTests[packet:PacketP[Model[Instrument,ParticleSizeProbe]]]:={};


(* ::Subsection::Closed:: *)
(*validModelInstrumentPeptideSynthesizerQTests*)


validModelInstrumentPeptideSynthesizerQTests[packet:PacketP[Model[Instrument,PeptideSynthesizer]]]:={

	(* Shared field shaping *)
	NullFieldTest[packet, {Dongle,PCICard}],

	NotNullFieldTest[packet, {Connector,OperatingSystem,Positions,PositionPlotting}]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentPeristalticPumpQTests*)


validModelInstrumentPeristalticPumpQTests[packet:PacketP[Model[Instrument,PeristalticPump]]]:={

	(* Shared field shaping *)
	NullFieldTest[packet,{Positions,PositionPlotting,Connector,Dongle,OperatingSystem,PCICard}],

	NotNullFieldTest[packet, {MaxFlowRate,MinFlowRate,TubingType}],

	(* Sensible Min/Max field checks *)
	FieldComparisonTest[packet,{MinFlowRate, MaxFlowRate},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentPressureManifoldQTests*)


validModelInstrumentPressureManifoldQTests[packet:PacketP[Model[Instrument,PressureManifold]]]:={
	NotNullFieldTest[packet, {MaxPressure,MinPressure}],
	(* Sensible Min/Max field checks *)
	FieldComparisonTest[packet,{MinPressure, MaxPressure},LessEqual],
	FieldComparisonTest[packet,{MinFlowRate, MaxFlowRate},LessEqual]
};



(* ::Subsection::Closed:: *)
(*validModelInstrumentPlatePourerQTests*)


validModelInstrumentPlatePourerQTests[packet:PacketP[Model[Instrument,PlatePourer]]]:={};


(* ::Subsection::Closed:: *)
(*validModelInstrumentPipetteQTests*)


validModelInstrumentPipetteQTests[packet:PacketP[Model[Instrument,Pipette]]]:={

	(* Shared field shaping *)
	NullFieldTest[packet, {Positions,PositionPlotting,Connector,Dongle,OperatingSystem,PCICard}],

	(* Unique fields that should not be Null *)
	NotNullFieldTest[packet, {Controller,Channels,MaxVolume,MinVolume,TipConnectionType,PipetteType}],

	(* Sensible Min/Max field checks *)
	FieldComparisonTest[packet,{MinVolume,MaxVolume},LessEqual],

	Test["Channel offset is set when the pipette has multiple channels:",
		{Lookup[packet,Channels],Lookup[packet,ChannelOffset]},
		{1,Null}|{GreaterP[1],Except[Null]}
	]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentPlateImagerQTests*)


validModelInstrumentPlateImagerQTests[packet:PacketP[Model[Instrument,PlateImager]]]:={

	(* Shared field shaping - NotNull*)
	NotNullFieldTest[packet, {Positions,PositionPlotting,Connector,OperatingSystem,Cameras,Illumination,ImageScales}],

	NullFieldTest[packet, {WettedMaterials, PCICard, Dongle}]

};


(* ::Subsection:: *)
(*validModelInstrumentNephelometerQTests*)


validModelInstrumentNephelometerQTests[packet:PacketP[Model[Instrument, Nephelometer]]] := {
	NotNullFieldTest[packet,
		{
			Positions,
			PositionPlotting,
			DefaultMethodFilePath,
			DefaultDataFilePath,
			LightSource,
			LightSourceWavelength,
			ScatterDirection,
			Detector,
			MinTemperature,
			MaxTemperature,
			MinOxygenLevel,
			MaxOxygenLevel,
			MinCarbonDioxideLevel,
			MaxCarbonDioxideLevel,
			InjectorVolume,
			InjectorDeadVolume
		}
	],

	(* sensible min/max field *)
	FieldComparisonTest[packet, {MinTemperature, MaxTemperature}, LessEqual],
	FieldComparisonTest[packet, {MinOxygenLevel, MaxOxygenLevel}, LessEqual],
	FieldComparisonTest[packet, {MinCarbonDioxideLevel, MaxCarbonDioxideLevel}, LessEqual]
};



(* ::Subsection::Closed:: *)
(*validModelInstrumentPlateReaderQTests*)


validModelInstrumentPlateReaderQTests[packet:PacketP[Model[Instrument,PlateReader]]]:={

	(* Shared field shaping *)
	NotNullFieldTest[packet,{Positions,PositionPlotting}],
	(* specific fields which should not be Null *)
	NotNullFieldTest[packet, PlateReaderMode],

	(* RequiredTogether *)
	RequiredTogetherTest[packet, {ExcitationSource, ExcitationFilterTypes}],
	RequiredTogetherTest[packet, {AbsorbanceFilterTypes,AbsorbanceDetector,AbsorbanceWavelengthResolution }],
	RequiredTogetherTest[packet, {EmissionFilterTypes, EmissionDetector}],
	RequiredTogetherTest[packet, {LuminescenceFilterTypes, LuminescenceDetector}],
	RequiredTogetherTest[packet, {PolarizationExcitationSource, PolarizationExcitationFilterTypes}],
	RequiredTogetherTest[packet, {PolarizationEmissionFilterTypes, PolarizationEmissionDetector}],
	RequiredTogetherTest[packet, {MinTemperature,MaxTemperature}],
	RequiredTogetherTest[packet, {InjectorVolume, InjectorDeadVolume}],

	Test["The minimum and maximum absorbance wavelengths should be specified only when the instrument absorbance is tunable:",
		Module[{absorbanceFilterTypes, minAbsorbanceWavelength,maxAbsorbanceWavelength},
			{absorbanceFilterTypes, minAbsorbanceWavelength,maxAbsorbanceWavelength} = Lookup[packet,{AbsorbanceFilterTypes, MinAbsorbanceWavelength,MaxAbsorbanceWavelength}];
			If[MemberQ[absorbanceFilterTypes,Monochromators|Array],
				!NullQ[{minAbsorbanceWavelength,maxAbsorbanceWavelength}],
				NullQ[{minAbsorbanceWavelength, maxAbsorbanceWavelength}]
			]
		],
		True
	],

	Test["The minimum and maximum luminescence wavelengths should be specified only when the instrument luminescence is tunable:",
		Module[{luminescenceFilterTypes, minLuminescenceWavelength,maxLuminescenceWavelength},
			{luminescenceFilterTypes, minLuminescenceWavelength,maxLuminescenceWavelength} = Lookup[packet,{LuminescenceFilterTypes, MinLuminescenceWavelength,MaxLuminescenceWavelength}];
			If[MemberQ[luminescenceFilterTypes,Monochromators|Array],
				!NullQ[{minLuminescenceWavelength, maxLuminescenceWavelength}],
				NullQ[{minLuminescenceWavelength, maxLuminescenceWavelength}]
			]
		],
		True
	],

	Test["The minimum and maximum emission wavelengths should be specified only when the instrument emission is tunable:",
		Module[{emissionFilterTypes, minEmissionWavelength,maxEmissionWavelength},
			{emissionFilterTypes, minEmissionWavelength,maxEmissionWavelength} = Lookup[packet,{EmissionFilterTypes, MinEmissionWavelength,MaxEmissionWavelength}];
			If[MemberQ[emissionFilterTypes,Monochromators|Array],
				!NullQ[{minEmissionWavelength,maxEmissionWavelength}],
				NullQ[{minEmissionWavelength,maxEmissionWavelength}]
			]
		],
		True
	],

	Test["The minimum and maximum polarization emission wavelengths should be specified only when the instrument polarization emission is tunable:",
		Module[{polarizationEmissionFilterTypes, minPolarizationEmissionWavelength,maxPolarizationEmissionWavelength},
			{polarizationEmissionFilterTypes, minPolarizationEmissionWavelength,maxPolarizationEmissionWavelength} = Lookup[packet,{PolarizationEmissionFilterTypes, MinPolarizationEmissionWavelength,MaxPolarizationEmissionWavelength}];
			If[MemberQ[polarizationEmissionFilterTypes,Monochromators|Array],
				!NullQ[{minPolarizationEmissionWavelength, maxPolarizationEmissionWavelength}],
				NullQ[{minPolarizationEmissionWavelength, maxPolarizationEmissionWavelength}]
			]
		],
		True
	],

	Test["The minimum and maximum excitation wavelengths should be specified only when the instrument excitation is tunable:",
		Module[{excitationFilterTypes, minExcitationWavelength,maxExcitationWavelength},
			{excitationFilterTypes, minExcitationWavelength,maxExcitationWavelength}= Lookup[packet,{ExcitationFilterTypes, MinExcitationWavelength,MaxExcitationWavelength}];
			If[MemberQ[excitationFilterTypes,Monochromators|Array],
				!NullQ[{minExcitationWavelength, maxExcitationWavelength}],
				NullQ[{minExcitationWavelength,maxExcitationWavelength}]
			]
		],
		True
	],

	(* If Monochromator is chosen for excitation source, then resolution must be filled*)
	Test["If the instrument excitation is tunable, then wavelength resolution must be specified:",
		Module[{excitationFilterTypes, excitationWavelengthResolution},
			{excitationFilterTypes, excitationWavelengthResolution}= Lookup[packet,{ExcitationFilterTypes, ExcitationWavelengthResolution}];
			If[MemberQ[excitationFilterTypes,Monochromators],
				!NullQ[excitationWavelengthResolution],
				True
			]
		],
		True
	],

	(* If the instrument has installed optic modules, the information stored there must match the information in the instrument *)


	Test["If the instrument has installed optic modules, the filter/polarizer information stored in those object must match the filter/polarizer information stored in the model instrument:",
		Module[{opticModules,excitationFilters,excitationPolarizers,emissionFilters,emissionPolarizers,polarizationEmissionFilters,polarizationExcitationFilters,opticModulePackets},
			{opticModules,excitationFilters,excitationPolarizers,emissionFilters,emissionPolarizers,polarizationEmissionFilters,polarizationExcitationFilters}=Lookup[packet,{OpticModules,ExcitationFilters,ExcitationPolarizers,EmissionFilters,EmissionPolarizers,PolarizationEmissionFilters,PolarizationExcitationFilters}];

			opticModulePackets = Download[opticModules];

			If[!MatchQ[opticModulePackets,{}],
				And[
					MatchQ[excitationFilters,getExcitationFilters[opticModulePackets]],
					MatchQ[excitationPolarizers,getExcitationPolarizers[opticModulePackets]],
					MatchQ[emissionFilters,getEmissionFilters[opticModulePackets]],
					MatchQ[emissionPolarizers,getEmissionPolarizers[opticModulePackets]],
					MatchQ[polarizationEmissionFilters,getPolarizationEmissionFilters[opticModulePackets]],
					MatchQ[polarizationExcitationFilters,getPolarizationExcitationFilters[opticModulePackets]]
				],
				True
			]
		],
		True
	],

	(* MaxOpticModules/ MaxFilters must be informed for plate reader model Pherastar or Omega *)
	Test["If plate reader model is Pherastar, MaxOpticModules is informed:",
		Module[{model,maxOpticModules,maxFilters},
			{model,maxOpticModules,maxFilters}=Lookup[packet, {Model, MaxOpticModules, MaxFilters}];

			(* Pherastar plate reader model *)
			If[MatchQ[model,PherastarP],
				{maxOpticModules,maxFilters},
				True
			]
		],
		{5,Null}|True
	],

	Test["If plate reader model is Omega, MaxFilters is informed:",
		Module[{model,maxOpticModules,maxFilters},
			{model,maxOpticModules,maxFilters}=Lookup[packet, {Model, MaxOpticModules, MaxFilters}];

			(* Omega plate reader model *)
			If[MatchQ[model,ObjectP[Model[Instrument, PlateReader, "id:mnk9jO3qDzpY"]]],
				{maxOpticModules,maxFilters},
				True
			]
		],
		{Null,8}|True
	],

	Test["If plate reader model is Flex3, neither MaxOpticModules or MaxFilters is informed:",
		Module[{model,maxOpticModules,maxFilters},
			{model,maxOpticModules,maxFilters}=Lookup[packet, {Model, MaxOpticModules, MaxFilters}];

			(* Flex3 plate reader model *)
			If[MatchQ[model,ObjectP[Model[Instrument, PlateReader, "id:kEJ9mqaVPAoe"]]],
				{maxOpticModules,maxFilters},
				True
			]
		],
		{Null,Null}|True
	],

	Test["If the plate reader supports fluorescence spectroscopy experiments the min and max excitation and emission wavelengths must be specified:",
		If[MemberQ[Lookup[packet,PlateReaderMode],FluorescenceSpectroscopy],
			MatchQ[Lookup[packet,{MinExcitationWavelength,MaxExcitationWavelength,MinEmissionWavelength,MaxEmissionWavelength}],{DistanceP..}],
			True
		],
		True
	],

	Test["If the plate reader supports luminescence spectroscopy experiments the min and max emission wavelengths must be specified:",
		If[MemberQ[Lookup[packet,PlateReaderMode],FluorescenceSpectroscopy],
			MatchQ[Lookup[packet,{MinExcitationWavelength,MaxExcitationWavelength,MinEmissionWavelength,MaxEmissionWavelength}],{DistanceP..}],
			True
		],
		True
	],

	Test["If the plate reader supports fluorescence experiments it must have filter information (ExcitationFilters,EmissionFilters) or monochromator limits:",
		If[MemberQ[Lookup[packet,PlateReaderMode],Fluorescence],
			Or[
				MatchQ[Lookup[packet,{MinExcitationWavelength,MaxExcitationWavelength,MinEmissionWavelength,MaxEmissionWavelength}],{DistanceP..}],
				MatchQ[Lookup[packet,{ExcitationFilters,EmissionFilters}],{{DistanceP..},{{DistanceP,_}..}}]
			],
			True
		],
		True
	],

	(*Currently only CLARIOStar supports AlphaScreen. Perform this only to CLARIOStar and expand it to other plate readers later.*)
	Test["If the plate reader supports AlphaScreen it must have corresponding excitation and emission information:",
		If[MemberQ[Lookup[packet, PlateReaderMode], AlphaScreen] && MatchQ[Lookup[packet, Object], ObjectP[{Model[Instrument, PlateReader, "id:E8zoYvNkmwKw"], Model[Instrument, PlateReader, "id:zGj91a7Ll0Rv"]}]],
			MatchQ[Lookup[packet, {AlphaScreenExcitationLaserWavelength, AlphaScreenEmissionFilter}], {DistanceP, DistanceP}],
			True
		],
		True
	],

	(* Sensible Min/Max field checks *)
	FieldComparisonTest[packet,{MinAbsorbanceWavelength,MaxAbsorbanceWavelength},LessEqual],
	RequiredTogetherTest[packet,{MinAbsorbanceWavelength,MaxAbsorbanceWavelength}],

	FieldComparisonTest[packet,{MinEmissionWavelength,MaxEmissionWavelength},LessEqual],
	RequiredTogetherTest[packet,{MinEmissionWavelength,MaxEmissionWavelength}],


	FieldComparisonTest[packet,{MinExcitationWavelength,MaxExcitationWavelength},LessEqual],
	RequiredTogetherTest[packet,{MinExcitationWavelength,MaxExcitationWavelength}],
	FieldComparisonTest[packet,{MinPolarizationEmissionWavelength,MaxPolarizationEmissionWavelength},LessEqual],
	RequiredTogetherTest[packet,{MinPolarizationEmissionWavelength,MaxPolarizationEmissionWavelength}],

	FieldComparisonTest[packet,{MinLuminescenceWavelength,MaxLuminescenceWavelength},LessEqual],
	RequiredTogetherTest[packet,{MinLuminescenceWavelength,MaxLuminescenceWavelength}],

	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual],
	RequiredTogetherTest[packet,{MinTemperature,MaxTemperature}],

	FieldComparisonTest[packet,{MinAbsorbance,MaxAbsorbance},LessEqual],
	RequiredTogetherTest[packet,{MinAbsorbance,MaxAbsorbance}]
};


(* ::Subsubsection::Closed:: *)
(*getExcitationFilters*)


getExcitationFilters[ opticModules : Null | {(PacketP[Model[Part,OpticModule]]|Null)...}]:= Module[
	{excitationFilterWavelength, polarizations, nonPolarizationModuleSelection, nonPolarizedExcitationWavelengths},

			(* Get excitation Wavelengths *)
			If[
				opticModules === ({}|NullP),
				(* If no opticModules return Null *)
				Null,
				(
					excitationFilterWavelength = Lookup[opticModules,ExcitationFilterWavelength];
					(* get polarizations in all optic modules *)
					polarizations = Lookup[opticModules,{ExcitationPolarizer, EmissionPolarizer, SecondaryEmissionPolarizer}];
					(* If no polarizations are specified, that means that it is not a polarization module *)
					nonPolarizationModuleSelection = NullQ /@ polarizations;
					(* pick the excitation wavelengths that belong to optic modules that have no polarization films anywhere *)
					nonPolarizedExcitationWavelengths = Pick[excitationFilterWavelength, nonPolarizationModuleSelection];
					(* If empty return Null, else return wavelengths *)
					If[
						nonPolarizedExcitationWavelengths =!= {},
						nonPolarizedExcitationWavelengths,
						Null
					]
				)
			]
];


(* ::Subsubsection::Closed:: *)
(*getPolarizationExcitationFilters*)


getPolarizationExcitationFilters[ opticModules : Null | {(PacketP[Model[Part,OpticModule]]|Null)...}]:= Module[
	{excitationWavelengths, polarizations, polarizationModuleSelection, polarizedExcitationWavelengths},

			(* Get excitation Wavelengths *)
			If[
				opticModules === ({}|NullP|{}),
				(* If no opticModules return Null *)
				Null,
				(
					(* get excitation wavelengths in all optic modules *)
					excitationWavelengths =Lookup[opticModules,ExcitationFilterWavelength];
					(* get polarizations in all optic modules *)
					polarizations = Lookup[opticModules,{ExcitationPolarizer, EmissionPolarizer, SecondaryEmissionPolarizer}];
					(* If no polariations are specified that means, that it is not a polarization module *)
					polarizationModuleSelection = !NullQ[#]& /@ polarizations;
					(* pick the excitation wavelengths that belong to optic modules that have no polarization films anywhere *)
					polarizedExcitationWavelengths = Pick[excitationWavelengths, polarizationModuleSelection];
					(* If empty return Null, else return wavelengths *)
					If[
						polarizedExcitationWavelengths === {},
						Null,
						polarizedExcitationWavelengths
					]
				)
			]
];


(* ::Subsubsection::Closed:: *)
(*getEmissionFilters*)


getEmissionFilters[ opticModules : Null | {(PacketP[Model[Part,OpticModule]]|Null)...}]:= Module[
	{emissionWavelengths, polarizations, nonPolarizationModuleSelection, nonPolarizationEmissionWavelengths},

			(* Get excitation Wavelengths *)
			If[
				opticModules === ({}|NullP|{}),
				(* If no opticModules return Null *)
				Null,
				(
					(* get primary/Secondary emission wavelengths in all optic modules *)
					emissionWavelengths = Lookup[opticModules,{EmissionFilterWavelength,SecondaryEmissionFilterWavelength}];
					(* get polarizations in all optic modules *)
					polarizations = Lookup[opticModules,{ExcitationPolarizer, EmissionPolarizer, SecondaryEmissionPolarizer}];
					(* If no polariations are specified that means, that it is not a polarization module *)
					nonPolarizationModuleSelection = NullQ /@ polarizations;
					(* pick the emission wavelengths that belong to optic modules that have no polarization films anywhere *)
					nonPolarizationEmissionWavelengths = Pick[emissionWavelengths, nonPolarizationModuleSelection];
					(* If empty return Null, else return wavelengths *)
					If[
						nonPolarizationEmissionWavelengths =!= {},
						nonPolarizationEmissionWavelengths,
						Null
					]
				)
			]
];


(* ::Subsubsection::Closed:: *)
(*getPolarizationEmissionFilters*)


getPolarizationEmissionFilters[ opticModules : Null | {(PacketP[Model[Part,OpticModule]]|Null)...}]:= Module[
	{emissionWavelengths, polarizations, polarizationModuleSelection, polarizedEmissionWavelengths},

			(* Get excitation Wavelengths *)
			If[
				opticModules === ({}|NullP|{}),
				(* If no opticModules return Null *)
				Null,
				(
					(* get primary/Secondary emission wavelengths in all optic modules *)
					emissionWavelengths = Lookup[opticModules,{EmissionFilterWavelength,SecondaryEmissionFilterWavelength}];
					(* get polarizations in all optic modules *)
					polarizations = Lookup[opticModules,{ExcitationPolarizer, EmissionPolarizer, SecondaryEmissionPolarizer}];
					(* If no polariations are specified that means, that it is not a polarization module *)
					polarizationModuleSelection = !NullQ[#] & /@ polarizations;
					(* pick the emission wavelengths that belong to optic modules that have no polarization films anywhere *)
					polarizedEmissionWavelengths = Pick[emissionWavelengths, polarizationModuleSelection];
					(* If empty return Null, else return wavelengths *)
					If[
						polarizedEmissionWavelengths =!= {},
						polarizedEmissionWavelengths,
						Null
					]
				)
			]
];


(* ::Subsubsection::Closed:: *)
(*getExcitationPolarizers*)


getExcitationPolarizers[ opticModules : Null | {(PacketP[Model[Part,OpticModule]]|Null)...}]:= Module[
	{
		excitationPolarizers
	},
			(* Get excitation Wavelengths *)
			If[
				opticModules === ({}|NullP|{}),
				(* If no opticModules return Null *)
				Null,
				(
					(* get excitation polarizations in all optic modules *)
					excitationPolarizers = DeleteCases[Lookup[opticModules,ExcitationPolarizer], Null];
					(* If empty return Null, else return wavelengths *)
					If[
						excitationPolarizers === {},
						Null,
						excitationPolarizers
					]
				)
			]
];


(* ::Subsubsection::Closed:: *)
(*getEmissionPolarizers*)


getEmissionPolarizers[ opticModules : Null | {(PacketP[Model[Part,OpticModule]]|Null)...}]:= Module[
	{emissionPolarizers, nonNullEmissionPolarizers},

			(* Get excitation Wavelengths *)
			If[
				MatchQ[opticModules ,({}|NullP|{})],
				(* If no opticModules return Null *)
				Null,
				Module[{},(
					(* get primary/Secondary emission wavelengths in all optic modules *)
					emissionPolarizers = Lookup[opticModules,{EmissionPolarizer,SecondaryEmissionPolarizer}];
					(* Delete any entries with no polarizers *)
					nonNullEmissionPolarizers = DeleteCases[emissionPolarizers,NullP|{}];
					(* If empty return Null, else return polarizers *)
					If[
						nonNullEmissionPolarizers =!= {},
						nonNullEmissionPolarizers,
						Null
					]
				)]
			]
];


(* ::Subsection::Closed:: *)
(*validModelInstrumentPlateTilterQTests*)


validModelInstrumentPlateTilterQTests[packet:PacketP[Model[Instrument,PlateTilter]]]:={};


(* ::Subsection::Closed:: *)
(*validModelInstrumentPlateWasherQTests*)


validModelInstrumentPlateWasherQTests[packet:PacketP[Model[Instrument,PlateWasher]]]:={

	(* Shared field shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],

	(* Individual fields *)
	NotNullFieldTest[packet, {Positions,PositionPlotting,MixModes}],

	RequiredTogetherTest[packet,{MinRotationRate,MaxRotationRate}],

	FieldComparisonTest[packet,{MaxRotationRate,MinRotationRate},GreaterEqual]


};





(* ::Subsection::Closed:: *)
(*validModelInstrumentPowerSupplyQTests*)


validModelInstrumentPowerSupplyQTests[packet:PacketP[Model[Instrument,PowerSupply]]]:={

	(* Shared field shaping *)
	NullFieldTest[packet, {Positions,PositionPlotting,Connector,Dongle,OperatingSystem,PCICard}],

	NotNullFieldTest[packet, {NumberOfLeads,MaxVoltage,MaxCurrent,MaxPower}]

};


(* ::Subsection::Closed:: *)
(*validInstrumentPurgeBoxQTests*)


validModelInstrumentPurgeBoxQTests[packet:PacketP[Model[Instrument,PurgeBox]]]:={};



(* ::Subsection::Closed:: *)
(*validModelInstrumentRamanProbeQTests*)


validModelInstrumentRamanProbeQTests[packet:PacketP[Model[Instrument,RamanProbe]]]:={};


(* ::Subsection::Closed:: *)
(*validModelInstrumentRamanSpectrometerQTests*)


validModelInstrumentRamanSpectrometerQTests[packet:PacketP[Model[Instrument,RamanSpectrometer]]]:={

	(* null shared fields *)
	NullFieldTest[packet, {Dongle,PCICard, WettedMaterials}],

	(*not null shared fields*)
	NotNullFieldTest[packet, {Connector, OperatingSystem,Positions}],

	(*not null unique fields*)
	NotNullFieldTest[packet,
		{
			MaxPower,
			MaxDetectionSignal,
			MaxStokesScatteringFrequency,
			MinStokesScatteringFrequency,
			SpectralResolution,
			LaserWavelength,
			OpticsOrientation,
			WellSampling,
			OpticalImaging,
			Objectives
		}
	],

	RequiredTogetherTest[packet, {MinAntiStokesScatteringFrequency, MaxAntiStokesScatteringFrequency}]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentReactorQTests*)


validModelInstrumentReactorQTests[packet:PacketP[Model[Instrument,Reactor]]]:={};


(* ::Subsection::Closed:: *)
(*validModelInstrumentReactorElectrochemicalQTests*)


validModelInstrumentReactorElectrochemicalQTests[packet:PacketP[Model[Instrument,Reactor,Electrochemical]]]:={

	(* Fields which should not be null *)
	NotNullFieldTest[packet,{
		(* Shared Fields *)
		Positions,

		(* Non-Shared Fields *)
		Modes,
		Stirring,
		MaxElectrodeVoltage,
		MaxElectrodeCurrent,
		ElectrochemicalVoltageAccuracy,
		ElectrochemicalCurrentAccuracy,
		CyclicVoltammetryPotentialAccuracy,
		CyclicVoltammetryCurrentAccuracy
	}],

	(* Min/Max field checks *)

	RequiredTogetherTest[packet,{MinOperationTemperature,MaxOperationTemperature}],
	FieldComparisonTest[packet,{MinOperationTemperature,MaxOperationTemperature},LessEqual],

	RequiredTogetherTest[packet,{MinCyclicVoltammetryPotential,MaxCyclicVoltammetryPotential}],
	FieldComparisonTest[packet,{MinCyclicVoltammetryPotential,MaxCyclicVoltammetryPotential},LessEqual],

	RequiredTogetherTest[packet,{MinPotentialSweepRate,MaxPotentialSweepRate}],
	FieldComparisonTest[packet,{MinPotentialSweepRate,MaxPotentialSweepRate},LessEqual],

	RequiredTogetherTest[packet,{MinStirringSpeed,MaxStirringSpeed}],
	FieldComparisonTest[packet,{MinStirringSpeed,MaxStirringSpeed},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentRecirculatingPumpQTests*)


validModelInstrumentRecirculatingPumpQTests[packet:PacketP[Model[Instrument,RecirculatingPump]]]:={

	(* Fields which should not be null *)
	NotNullFieldTest[packet, {MaxTemperature,MinTemperature,TubingInnerDiameter,MaxFlowRate}],

	(* Shared field shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard,Positions,PositionPlotting}],

	(* Sensible Min/Max field checks *)
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentRefractometerQTests*)


validModelInstrumentRefractometerQTests[packet:PacketP[Model[Instrument,Refractometer]]]:={

	(* Defined fields which should NOT be Null *)
	NotNullFieldTest[packet, {
		DefaultDataFilePath,
		DefaultMethodFilePath,
		Positions,
		PositionPlotting,
		WettedMaterials,
		MeasuringWavelength,
		MinTemperature,
		MaxTemperature,
		TemperatureResolution,
		TemperatureAccuracy,
		TemperatureStability,
		MinRefractiveIndex,
		MaxRefractiveIndex,
		RefractiveIndexResolution,
		RefractiveIndexAccuracy,
		MinSampleVolume
	}],

	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},Less],
	FieldComparisonTest[packet,{MinRefractiveIndex,MaxRefractiveIndex},Less]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentRefrigeratorQTests*)


validModelInstrumentRefrigeratorQTests[packet:PacketP[Model[Instrument,Refrigerator]]]:={

	NotNullFieldTest[packet, {
			DefaultTemperature,
			MinTemperature,
			Positions,PositionPlotting,
			MaxTemperature
			}
	],

    (* fields should all be populated *)
	Test["The three indexes in InternalDimensions must be all informed:",
		Lookup[packet,InternalDimensions],
		{Except[NullP],Except[NullP],Except[NullP]}
	],

	FieldComparisonTest[packet, {DefaultTemperature, MaxTemperature}, LessEqual],
	FieldComparisonTest[packet, {DefaultTemperature, MinTemperature}, GreaterEqual],

	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}]


};


(* ::Subsection::Closed:: *)
(*validModelInstrumentRollerQTests*)


validModelInstrumentRollerQTests[packet:PacketP[Model[Instrument, Roller]]]:={};


(* ::Subsection::Closed:: *)
(*validModelInstrumentRockerQTests*)


validModelInstrumentRockerQTests[packet:PacketP[Model[Instrument, Rocker]]]:={};



(* ::Subsection::Closed:: *)
(*validModelInstrumentRotaryEvaporatorQTests*)


validModelInstrumentRotaryEvaporatorQTests[packet:PacketP[Model[Instrument,RotaryEvaporator]]]:={

	NotNullFieldTest[packet, {
			MinBathTemperature,
			MaxBathTemperature,
			MaxRotationRate,
			BathVolume,
			BathFluid,
			VaporTrapType,
			Positions,
			PositionPlotting
		}
	],

	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],

	FieldComparisonTest[packet, {MinBathTemperature, MaxBathTemperature}, LessEqual]

};


(* ::Subsection:: *)
(*validModelInstrumentSampleImagerQTests*)


validModelInstrumentSampleImagerQTests[packet:PacketP[Model[Instrument,SampleImager]]]:={

	(* Shared field shaping - NotNull*)


	(* Shared field shaping - Null*)
	NullFieldTest[packet, {WettedMaterials,PCICard,Dongle}],

	(* Specific required *)
	NotNullFieldTest[packet, {Cameras,Illumination,Positions,PositionPlotting,Connector,OperatingSystem}]


};


(* ::Subsection:: *)
(*validModelInstrumentSampleInspectorQTests*)


validModelInstrumentSampleInspectorQTests[packet:PacketP[Model[Instrument,SampleInspector]]]:={

(* Specific required *)
	NotNullFieldTest[
		packet, 
		{
			Cameras,
			Illumination,
			Positions,
			PositionPlotting,
			Connector,
			OperatingSystem,
			MinTemperature,
			MaxTemperature,
			MaxRotationRate,
			MinRotationRate,
			MaxAgitationTime,
			MinAgitationTime
		}
	]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentShakerQTests*)


validModelInstrumentShakerQTests[packet:PacketP[Model[Instrument,Shaker]]]:={
	(* Shared field shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],

	(* Individual fields *)
	NotNullFieldTest[packet, {TemperatureControl, Positions, PositionPlotting}],

	Test["Either MaxRotationRate/MinRotationRate is filled out or MaxForce/MinForce is filled out:",
		Xor[
			MatchQ[Lookup[packet, MaxRotationRate], RPMP] && MatchQ[Lookup[packet, MinRotationRate], RPMP],
			MatchQ[Lookup[packet, MaxForce], UnitsP[GravitationalAcceleration]] && MatchQ[Lookup[packet, MinForce], UnitsP[GravitationalAcceleration]]
		],
		True
	],

	FieldComparisonTest[packet,{MaxForce,MinForce},GreaterEqual],
	FieldComparisonTest[packet,{MaxRotationRate,MinRotationRate},GreaterEqual],

	Test["The three indexes in InternalDimensions must be all informed or all Null, or the field itself must be Null:",
	Lookup[packet,InternalDimensions],
	{NullP,NullP,NullP}|{Except[NullP],Except[NullP],Except[NullP]}|Null
	],

	(* Min/Max Temperatures are needed if the shaker has temperature control *)
	Test[
		"If TemperatureControl is not None, MinTemperatue and MaxTemperature must be informed:",
		Module[
			{temperatureControl, minTemperature,maxTemperature},
			{temperatureControl, minTemperature,maxTemperature} = Lookup[packet,	{TemperatureControl, MinTemperature,MaxTemperature}];
			If[!MatchQ[(temperatureControl),None],
				(* Ensure none of the related fields are null *)
				!NullQ[minTemperature]&&!NullQ[maxTemperature],
				True
			]
		],
		True
	],
	FieldComparisonTest[packet, {MinTemperature, MaxTemperature}, LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentSolidDispenserQTests*)


validModelInstrumentSolidDispenserQTests[packet:PacketP[Model[Instrument,SolidDispenser]]]:={

	(* not null shared fields *)

	(* not null unique fields *)
	NotNullFieldTest[packet,{MinWeight,MaxWeight,ManufacturerRepeatability,Resolution}]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentSonicatorQTests*)


validModelInstrumentSonicatorQTests[packet:PacketP[Model[Instrument,Sonicator]]]:={
	(* Shared field shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],

	(*specific tests*)
	NotNullFieldTest[packet,{
			Positions,PositionPlotting,
			BathVolume,
			BathFluid
		}
	],

	Test["The three indexes in InternalDimensions must be all informed:",
		Lookup[packet,InternalDimensions],
		{Except[NullP],Except[NullP],Except[NullP]}
	],

	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentSpectrophotometerQTests*)


validModelInstrumentSpectrophotometerQTests[packet:PacketP[Model[Instrument,Spectrophotometer]]]:={
	NotNullFieldTest[packet,{
			Connector,
			Dongle,
			OperatingSystem,
			Positions,PositionPlotting,
			LampType,
			Stirring,
			MinTemperature,
			MaxTemperature,
			ElectromagneticRange,
			Thermocycling
		}
	],

	(* Sensible Min/Max field checks *)
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual],
	FieldComparisonTest[packet,{MinMonochromator,MaxMonochromator},LessEqual],

	FieldComparisonTest[packet,{MinAbsorbance,MaxAbsorbance},LessEqual],
	RequiredTogetherTest[packet,{MinAbsorbance,MaxAbsorbance}]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentSpeedVacQTests*)


validModelInstrumentSpeedVacQTests[packet:PacketP[Model[Instrument,SpeedVac]]]:={
	(* Fields which should not be null *)
	NotNullFieldTest[packet, {MaxImbalance,TubingInnerDiameter,Positions,PositionPlotting}],

	NullFieldTest[packet, {Connector, Dongle, OperatingSystem, PCICard}],

	(* Sensible Min/Max field checks *)
	RequiredTogetherTest[packet,{MinTemperature,MaxTemperature}],
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentSterilizationIndicatorReaderQTests*)


validModelInstrumentSterilizationIndicatorReaderQTests[packet:PacketP[Model[Instrument,SterilizationIndicatorReader]]]:={
	NotNullFieldTest[packet, {IncubationTemperature, Connector}],

	NullFieldTest[packet,{Dongle,OperatingSystem,PCICard}]
};


(* ::Subsection:: *)
(*validModelInstrumentSurfacePlasmonResonanceQTests*)


validModelInstrumentSurfacePlasmonResonanceQTests[packet:PacketP[Model[Instrument,SurfacePlasmonResonance]]]:={};


(* ::Subsection::Closed:: *)
(*validModelInstrumentSyringePumpQTests*)


validModelInstrumentSyringePumpQTests[packet:PacketP[Model[Instrument,SyringePump]]]:={
	NotNullFieldTest[packet, {MaxFlowRate,MinFlowRate}],
	FieldComparisonTest[packet,{MinFlowRate, MaxFlowRate},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentTachometerQTests*)


validModelInstrumentTachometerQTests[packet:PacketP[Model[Instrument,Tachometer]]]:={
	(* Shared field shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard,Positions,PositionPlotting}],
	(* Unique fields *)
	NotNullFieldTest[packet, Mode],

	(* Sensible Min/Max field checks *)
	FieldComparisonTest[packet,{MinLaserModeMeasurement,MaxLaserModeMeasurement},LessEqual],
	FieldComparisonTest[packet,{MinLaserModeDetectionDistance,MaxLaserModeDetectionDistance},LessEqual],
	FieldComparisonTest[packet,{MinContactModeMeasurement,MaxContactModeMeasurement},LessEqual],
	FieldComparisonTest[packet,{MinSurfaceModeMeasurement,MaxSurfaceModeMeasurement},LessEqual],

	(* Groups - Require mode information together *)
	RequiredTogetherTest[packet,{MinLaserModeMeasurement,MaxLaserModeMeasurement,MinLaserModeDetectionDistance,MaxLaserModeDetectionDistance,LaserModeResolution,ManufacturerLaserModeUncertainty}],
	RequiredTogetherTest[packet,{MinContactModeMeasurement,MaxContactModeMeasurement,ContactModeResolution,ManufacturerContactModeUncertainty}],
	RequiredTogetherTest[packet,{MinSurfaceModeMeasurement,MaxSurfaceModeMeasurement,SurfaceModeResolution,ManufacturerSurfaceModeUncertainty}],

	(* If the instrument has a given mode, all fields related to the mode must be informed *)
	Test[
		"If the instrument has a laser mode, all laser-related fields must be informed:",
		If[MemberQ[(Lookup[packet,Mode]),Laser],
			(* Ensure none of the related fields are null *)
			!MemberQ[Lookup[packet,{MinLaserModeMeasurement,MaxLaserModeMeasurement,MinLaserModeDetectionDistance,MaxLaserModeDetectionDistance,LaserModeResolution,ManufacturerLaserModeUncertainty}],Null],
			True
		],
		True
	],
	Test[
		"If the instrument has a contact mode, all contact-related fields must be informed:",
		If[MemberQ[(Lookup[packet,Mode]),Contact],
			(* Ensure none of the related fields are null *)
			!MemberQ[Lookup[packet,{MinContactModeMeasurement,MaxContactModeMeasurement,ContactModeResolution,ManufacturerContactModeUncertainty}],Null],
			True
		],
		True
	],
	Test[
		"If the mode of the instrument is laser, all surface-related fields must be informed:",
		If[MemberQ[(Lookup[packet,Mode]),Surface],
			(* Ensure none of the related fields are null *)
			!MemberQ[Lookup[packet,{MinSurfaceModeMeasurement,MaxSurfaceModeMeasurement,SurfaceModeResolution,ManufacturerSurfaceModeUncertainty}],Null],
			True
		],
		True
	],

	(* If the instrument does not have a given mode, no fields related to the mode should be informed *)
	Test[
		"If the instrument does not have a laser mode, no laser-related fields should be informed:",
		If[!MemberQ[(Lookup[packet,Mode]),Laser],
			(* All the fields should be null, so deleting all null cases should give an empty list *)
			Length[DeleteCases[Lookup[packet,{MinLaserModeMeasurement,MaxLaserModeMeasurement,MinLaserModeDetectionDistance,MaxLaserModeDetectionDistance,LaserModeResolution,ManufacturerLaserModeUncertainty}],Null]]===0,
			True
		],
		True
	],
	Test[
		"If the instrument does not have a contact mode, no contact-related fields should be informed:",
		If[!MemberQ[(Lookup[packet,Mode]),Contact],
			(* All the fields should be null, so deleting all null cases should give an empty list *)
			Length[DeleteCases[packet[[{MinContactModeMeasurement,MaxContactModeMeasurement,ContactModeResolution,ManufacturerContactModeUncertainty}]],Null]]===0,
			True
		],
		True
	],
	Test[
		"If the instrument does not have a surface mode, no surface-related fields should be informed:",
		If[!MemberQ[(Lookup[packet,Mode]),Surface],
			(* All the fields should be null, so deleting all null cases should give an empty list *)
			Length[DeleteCases[packet[[{MinSurfaceModeMeasurement,MaxSurfaceModeMeasurement,SurfaceModeResolution,ManufacturerSurfaceModeUncertainty}]],Null]]===0,
			True
		],
		True
	]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentTensiometerQTests*)


validModelInstrumentTensiometerQTests[packet:PacketP[Model[Instrument,Tensiometer]]]:={
	NullFieldTest[packet, {Dongle, PCICard}],

	(* Not Null Fields *)
	NotNullFieldTest[packet, {RecommendedVolume, Connector, OperatingSystem,WettedMaterials}],

	(* Sensible Min/Max field checks *)
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual],
	FieldComparisonTest[packet,{MinSurfaceTensionMeasurement,MaxSurfaceTensionMeasurement},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentThermocyclerQTests*)


validModelInstrumentThermocyclerQTests[packet:PacketP[Model[Instrument,Thermocycler]]]:={
	RequiredTogetherTest[packet,{OperatingSystem,Dongle}],

	(* Unique Fields *)
	NotNullFieldTest[packet,{Mode,MinTemperature,MaxTemperature,MaxTemperatureRamp,Positions,PositionPlotting}],

	(* Sensible Min/Max field checks *)
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual],

	RequiredTogetherTest[packet,{MinEmissionMonochromator,MaxEmissionMonochromator}],
	FieldComparisonTest[packet,{MinEmissionMonochromator,MaxEmissionMonochromator},LessEqual],

	RequiredTogetherTest[packet,{MinExcitationMonochromator,MaxExcitationMonochromator}],
	FieldComparisonTest[packet,{MinExcitationMonochromator,MaxExcitationMonochromator},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentDigitalPCRQTests*)


validModelInstrumentDigitalPCRQTests[packet:PacketP[Model[Instrument,Thermocycler,DigitalPCR]]]:={

	(* Unique Fields *)
	NotNullFieldTest[packet,{DropletGeneratingGroups}]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentPlateSealerQTests*)


validModelInstrumentPlateSealerQTests[packet:PacketP[Model[Instrument,PlateSealer]]]:={
	(* Unique Fields *)
	NotNullFieldTest[packet,{TemperatureActivated}],

	(* For Manual PlateSealer, fields below are required together *)
	RequiredTogetherTest[packet,{MinTemperature,MaxTemperature,MinDuration,MaxDuration}],

	Test["If the plate sealer uses high temperature, temperature and duration must be informed and legit:",
		If[MatchQ[Lookup[packet,TemperatureActivated],True],
			Module[{temperatureCheck,durationCheck},
				{temperatureCheck,durationCheck}= {Greater[Lookup[packet,MaxTemperature],Lookup[packet,MinTemperature]],
					Greater[Lookup[packet,MaxDuration],Lookup[packet,MinDuration]]}
			],
			{}
			],
		{True,True}|{}
	]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentVacuumCentrifugeQTests*)


validModelInstrumentVacuumCentrifugeQTests[packet:PacketP[Model[Instrument,VacuumCentrifuge]]]:={
	(*shared field shaping*)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],

	(*object specific fields*)
	NotNullFieldTest[packet,{MinTemperature,MaxTemperature,Positions,PositionPlotting,VacuumPressure,MaxSolventVolume,VacuumPumpType,TrapCapacity}],

	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual]

};



(* ::Subsection::Closed:: *)
(*validModelInstrumenVacuumManifoldQTests*)


validModelInstrumentVacuumManifoldQTests[packet:PacketP[Model[Instrument,VacuumManifold]]]:={
(* Shared field shaping *)
	NullFieldTest[packet,{Connector,Dongle,OperatingSystem,PCICard}],

	NotNullFieldTest[packet,{Positions,PositionPlotting,WettedMaterials,ConnectionType,TubingInnerDiameter}]

};



(* ::Subsection::Closed:: *)
(*validModelInstrumentVacuumPumpQTests*)


validModelInstrumentVacuumPumpQTests[packet:PacketP[Model[Instrument,VacuumPump]]]:={
	(* Shared field shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard,Positions,PositionPlotting}],

	(*instrument specific fields*)
	NotNullFieldTest[packet,{PumpType,VacuumPressure,MaxFlowRate,TubingInnerDiameter}]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentVaporTrapQTests*)


validModelInstrumentVaporTrapQTests[packet:PacketP[Model[Instrument,VaporTrap]]]:={
	(* Shared field shaping *)
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard,Positions,PositionPlotting}],

	(*object specific tests*)
	NotNullFieldTest[packet,{CondenserTemperature,CondenserCapacity,TubingInnerDiameter}]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentVerticalLiftQTests*)


validModelInstrumentVerticalLiftQTests[packet:PacketP[Model[Instrument,VerticalLift]]]:={
	(*Shared field shaping*)
	NullFieldTest[packet,Connector],
	NullFieldTest[packet,Dongle],
	NullFieldTest[packet,OperatingSystem],
	NullFieldTest[packet,PCICard],


	NotNullFieldTest[packet,{
		TotalProductVolume,
		MaxNumberOfTrays,
		Positions,
		PositionPlotting
		}
	],

	Test["The three indexes in InternalDimensions must be all informed:",
		Lookup[packet,InternalDimensions],
		{Except[NullP],Except[NullP],Except[NullP]}
	],

	(* Sensible Mins/Maxs *)
	RequiredTogetherTest[packet,{MinTemperature,MaxTemperature}],
	FieldComparisonTest[packet,{MinTemperature,MaxTemperature},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentViscometerQTests*)


validModelInstrumentViscometerQTests[packet:PacketP[Model[Instrument,Viscometer]]]:={
	(*shared field shaping*)
	NullFieldTest[packet, {Dongle,PCICard}],
	NotNullFieldTest[packet,{Connector,OperatingSystem,WettedMaterials,Positions}],

	(*object specific fields*)
	NotNullFieldTest[packet,{MeasurementChipMinTemperature,MeasurementChipMaxTemperature,SampleTrayMinTemperature,SampleTrayMaxTemperature,MinViscosity,MaxViscosity,WettedMaterials}],

	FieldComparisonTest[packet,{MeasurementChipMinTemperature,MeasurementChipMaxTemperature},LessEqual],
	FieldComparisonTest[packet,{SampleTrayMinTemperature,SampleTrayMaxTemperature},LessEqual],
	FieldComparisonTest[packet,{MinFlowRate,MaxFlowRate},LessEqual],
	FieldComparisonTest[packet,{MinViscosity,MaxViscosity},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentVortexQTests*)


validModelInstrumentVortexQTests[packet:PacketP[Model[Instrument,Vortex]]]:={

	NullFieldTest[packet,{Connector,Dongle,OperatingSystem,PCICard}],

	NotNullFieldTest[packet,{Format,MaxRotationRate,MinRotationRate,Positions,PositionPlotting}],


	FieldComparisonTest[packet,{MaxRotationRate,MinRotationRate},GreaterEqual]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentWaterPurifierQTests*)


validModelInstrumentWaterPurifierQTests[packet:PacketP[Model[Instrument,WaterPurifier]]]:={

	(* ---------- Shape shared fields ---------- *)

	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}],

	(* ---------- Non-shared field tests ---------- *)

	NotNullFieldTest[packet,{
			MaxFlowRate,
			MaxPurificationRate,
			StorageCapacity,
			MinResistivity,
			MaxResistivity,
			ParticulateFilter
		}
	],

	(* Kept Min/MaxTotalOrganicContent and MaxDNase/RNase Optional, because these may not be things that every water filter removes *)

	RequiredTogetherTest[packet,{MinTotalOrganicContent,MaxTotalOrganicContent}],

	FieldComparisonTest[packet,{MinResistivity,MaxResistivity},LessEqual],
	FieldComparisonTest[packet,{MinTotalOrganicContent,MaxTotalOrganicContent},LessEqual]

};



(* ::Subsection::Closed:: *)
(*validModelInstrumentSinkQTests*)


validModelInstrumentSinkQTests[packet:PacketP[Model[Instrument,Sink]]]:={
	
	NullFieldTest[packet, {Connector,Dongle,OperatingSystem,PCICard}]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentWesternQTests*)


validModelInstrumentWesternQTests[packet:PacketP[Model[Instrument,Western]]]:={

	(* ---------- Non-shared fields ---------- *)
	NotNullFieldTest[packet,{
			Connector,
			Dongle,
			OperatingSystem,
			Positions,PositionPlotting,
			Mode,
			CapillaryCapacity,
			MaxLoading,
			MinVoltage,
			MaxVoltage,
			MinMolecularWeight,
			MaxMolecularWeight
		}
	],

	FieldComparisonTest[packet,{MinVoltage,MaxVoltage},LessEqual],
	FieldComparisonTest[packet,{MinMolecularWeight,MaxMolecularWeight},LessEqual]

};



(* ::Subsection::Closed:: *)
(*validModelInstrumentMultimodeSpectrophotometerQTests*)


validModelInstrumentMultimodeSpectrophotometerQTests[packet:PacketP[Model[Instrument,MultimodeSpectrophotometer]]]:={
	(*Fields that must be populated*)
	NotNullFieldTest[packet, {
		(*Shared*)
		Positions, PositionPlotting,
		(*Unique*)
		MinTemperature,
		MaxTemperature,
		MinTemperatureRamp,
		MaxTemperatureRamp,
		MinSampleConcentration,
		MaxSampleConcentration,
		FluorescenceDetector,
		StaticLightScatteringDetector,
		DynamicLightScatteringDetector,
		FluorescenceWavelengths,
		StaticLightScatteringWavelengths,
		DynamicLightScatteringWavelengths
	}],

	(*Min/Max temperature sanity check*)
	FieldComparisonTest[packet, {MinTemperature, MaxTemperature}, LessEqual],

	(*Min/max temperature ramp rate sanity check*)
	FieldComparisonTest[packet, {MinTemperatureRamp, MaxTemperatureRamp}, LessEqual],

	(*Min/max sample concentration sanity check*)
	FieldComparisonTest[packet, {MinSampleConcentration, MaxSampleConcentration}, LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentDLSPlateReaderQTests*)


validModelInstrumentDLSPlateReaderQTests[packet:PacketP[Model[Instrument,DLSPlateReader]]]:= {
	(*NullFieldTest[packet,{
		WettedMaterials
	}],*)
	NotNullFieldTest[packet,{
		Connector,
		OperatingSystem,
		(*PCICard,
		Dongle,
		Positions,
		PositionPlotting,*)
		(*Unique*)
		MinTemperature,
		MaxTemperature,
		(*MinTemperatureRamp,
		MaxTemperatureRamp,
		MinSampleConcentration,
		MaxSampleConcentration,*)
		StaticLightScatteringDetector,
		DynamicLightScatteringDetector,
		StaticLightScatteringWavelengths,
		DynamicLightScatteringWavelengths,
		DryGas,
		DryGasPressure
	}],
	(*Min/Max temperature sanity check*)
	FieldComparisonTest[packet, {MinTemperature, MaxTemperature}, LessEqual],

	(*Min/max temperature ramp rate sanity check*)
	FieldComparisonTest[packet, {MinTemperatureRamp, MaxTemperatureRamp}, LessEqual],

	(*Min/max sample concentration sanity check*)
	FieldComparisonTest[packet,{MinSampleConcentration,MaxSampleConcentration},LessEqual]

};



(* ::Subsection::Closed:: *)
(*validModelInstrumentProteinCapillaryElectrophoresisQTests*)


validModelInstrumentProteinCapillaryElectrophoresisQTests[packet:PacketP[Model[Instrument,ProteinCapillaryElectrophoresis]]]:={
	(*Fields that must be populated*)
	NotNullFieldTest[packet, {
	(*Shared fields *)
		Positions,
		PositionPlotting,
		WettedMaterials,
		OperatingSystem,
	(*Unique*)
		MaxVoltageSteps,
		OnBoardMixing
	}],
	(* other tests *)
	FieldComparisonTest[packet, {MinVoltage, MaxVoltage}, LessEqual]


};



(* ::Subsection::Closed:: *)
(*validModelInstrumentFragmentAnalyzerQTests*)


validModelInstrumentFragmentAnalyzerQTests[packet:PacketP[Model[Instrument,FragmentAnalyzer]]]:={

	NotNullFieldTest[packet,{SupportedNumberOfCapillaries,SupportedCapillaryArrayLength,SupportedCapillaryArray}],

	(* Sensible Min/Max field checks *)
	RequiredTogetherTest[packet,{MinEmissionWavelength,MaxEmissionWavelength}],
	FieldComparisonTest[packet,{MinEmissionWavelength,MaxEmissionWavelength},LessEqual],
	RequiredTogetherTest[packet,{MinVoltage,MaxVoltage}],
	FieldComparisonTest[packet,{MinVoltage,MaxVoltage},LessEqual],
	RequiredTogetherTest[packet,{MinDestinationPressure,MaxDestinationPressure}],
	FieldComparisonTest[packet,{MinDestinationPressure,MaxDestinationPressure},LessEqual],
	RequiredTogetherTest[packet,{MinHumidity,MaxHumidity}],
	FieldComparisonTest[packet,{MinHumidity,MaxHumidity},LessEqual],

	Test["Members of SupportedCapillaryArray should have NumberOfCapillaries field value also a member of SupportedNumberOfCapillaries",
		Module[
			{
				supportedCapillaryArrayNumberOfCapillaries,
				supportedCapillaryArray,
				instrumentModelSupportedNumberOfCapillaries
			},

			instrumentModelSupportedNumberOfCapillaries=Lookup[packet,SupportedNumberOfCapillaries];

			supportedCapillaryArray=Lookup[packet,SupportedCapillaryArray];

			supportedCapillaryArrayNumberOfCapillaries=Download[supportedCapillaryArray,NumberOfCapillaries];

			AllTrue[supportedCapillaryArrayNumberOfCapillaries,MemberQ[instrumentModelSupportedNumberOfCapillaries,#]&]
		],
		True
	],

	Test["Members of SupportedCapillaryArray should have CapillaryArrayLength field value also a member of SupportedCapillaryArrayLength",
		Module[
			{
				supportedCapillaryArrayLength,
				supportedCapillaryArray,
				instrumentModelSupportedCapillaryArrayLength
			},

			instrumentModelSupportedCapillaryArrayLength=Lookup[packet,SupportedCapillaryArrayLength];

			supportedCapillaryArray=Lookup[packet,SupportedCapillaryArray];

			supportedCapillaryArrayLength=Download[supportedCapillaryArray,CapillaryArrayLength];

			AllTrue[supportedCapillaryArrayLength,MemberQ[instrumentModelSupportedCapillaryArrayLength,#]&]
		],
		True
	]
};

(* ::Subsection::Closed:: *)
(*validModelInstrumentSchlenkLineQTests*)


validModelInstrumentSchlenkLineQTests[packet:PacketP[Model[Instrument,SchlenkLine]]]:={
	(*Fields that must be populated*)
	NotNullFieldTest[packet, {
		(*Shared fields *)
		Connectors,

		(*Unique*)
		HighVacuumPump,
		LowVacuumPump,
		NumberOfChannels,
		Gas,
		VaporTrap
	}],

	(*Min/Max delivery pressure sanity check*)
	FieldComparisonTest[packet, {MinDeliveryPressure, MaxDeliveryPressure}, LessEqual],
	(*Min/Max source pressure sanity check*)
	FieldComparisonTest[packet, {MinSourcePressure, MaxSourcePressure}, LessEqual]
};



(* ::Subsection::Closed:: *)
(*validModelInstrumentDewarQTests*)


validModelInstrumentDewarQTests[packet:PacketP[Model[Instrument,Dewar]]]:={
	(* Shared fields shaping *)
	NullFieldTest[packet,{Dongle,OperatingSystem,PCICard}],

	(*Fields that must be populated*)
	NotNullFieldTest[packet, {
		(*Shared fields *)
		Positions,
		PositionPlotting,
		(*Unique*)
		LiquidNitrogenCapacity,
		InternalDimensions
	}]
};



(* ::Subsection::Closed:: *)
(*validModelInstrumentSpargingApparatusQTests*)


validModelInstrumentSpargingApparatusQTests[packet:PacketP[Model[Instrument,SpargingApparatus]]]:={
	(* Shared fields shaping *)
	NullFieldTest[packet,{Dongle,OperatingSystem,PCICard}],

	(*Fields that must be populated*)
	NotNullFieldTest[packet, {
		(*Shared fields *)

		(*Unique*)
		SchlenkLine,
		DegasType,
		NumberOfChannels,
		GasType,
		Mixer
	}]
};



(* ::Subsection::Closed:: *)
(*validModelInstrumentVacuumDegasserQTests*)


validModelInstrumentVacuumDegasserQTests[packet:PacketP[Model[Instrument,VacuumDegasser]]]:={
	(* Shared fields shaping *)
	NullFieldTest[packet,{Dongle,OperatingSystem,PCICard}],

	(*Fields that must be populated*)
	NotNullFieldTest[packet, {
		(*Shared fields *)

		(*Unique*)
		SchlenkLine,
		NumberOfChannels,
		DegasType,
		VacuumPump,
		Sonicator,
		MinVacuumPressure,
		MaxVacuumPressure
	}],

	(* Sensible Min/Max field checks *)
	FieldComparisonTest[packet,{MinVacuumPressure,MaxVacuumPressure},LessEqual]
};



(* ::Subsection::Closed:: *)
(*validModelInstrumentFreezePumpThawApparatusQTests*)


validModelInstrumentFreezePumpThawApparatusQTests[packet:PacketP[Model[Instrument,FreezePumpThawApparatus]]]:={
	(* Shared fields shaping *)
	NullFieldTest[packet,{Dongle,OperatingSystem,PCICard}],

	(*Fields that must be populated*)
	NotNullFieldTest[packet, {
		(*Shared fields *)

		(*Unique*)
		SchlenkLine,
		NumberOfChannels,
		Dewar,
		VacuumPump,
		MinVacuumPressure,
		HeatBlock,
		MinThawTemperature,
		MaxThawTemperature,
		DegasType
	}],
	(* Sensible Min/Max field checks *)
	FieldComparisonTest[packet,{MinThawTemperature,MaxThawTemperature},LessEqual]
};





(* ::Subsection::Closed:: *)
(*validInstrumentOsmometerQTests*)


validModelInstrumentOsmometerQTests[packet:PacketP[Model[Instrument,Osmometer]]]:={

	(* Shared fields which should be null *)

	(* Defined fields which should not be null *)
	NotNullFieldTest[packet,{
		DataFilePath,
		OsmolalityMethod,
		MinOsmolality,
		MaxOsmolality,
		MinSampleVolume,
		MaxSampleVolume,
		DedicatedSolvent,
		CustomCalibrants,
		CustomCleaningSolution
	}
	],

	(*Sanity check ranges*)
	FieldComparisonTest[packet,{MaxOperatingTemperature,MinOperatingTemperature},GreaterEqual],
	FieldComparisonTest[packet,{MaxOsmolality,MinOsmolality},GreaterEqual],
	FieldComparisonTest[packet,{MaxSampleVolume,MinSampleVolume},GreaterEqual],
	FieldComparisonTest[packet,{MeasurementChamberMaxTemperature,MeasurementChamberMinTemperature},GreaterEqual],

	(*Total time of experiment must be greater than time of components*)
	FieldComparisonTest[packet,{MeasurementTime,EquilibrationTime},Greater],

	(*Resolution, Accuracy and Repeatability are provided as either a constant, or as a variable quantity, not both*)
	UniquelyInformedTest[packet,{ManufacturerOsmolalityResolution,ManufacturerOsmolalityResolutionScoped}],
	UniquelyInformedTest[packet,{ManufacturerOsmolalityAccuracy,ManufacturerOsmolalityAccuracyScoped}],
	UniquelyInformedTest[packet,{ManufacturerOsmolalityRepeatability,ManufacturerOsmolalityRepeatabilityScoped}],

	(*If calibrants are provided, the osmolalities are populated*)
	RequiredTogetherTest[packet,{ManufacturerCalibrants,ManufacturerCalibrantOsmolalities}],

	(* If CustomCalibrants is False, manufacturer calibrants must be informed.*)
	Test["If CustomCalibrants is False, ManufacturerCalibrants is informed:",
		Lookup[packet,{CustomCalibrants,ManufacturerCalibrants}],
		Alternatives[{False,Except[Null]},{True,_}]
	],

	(* If not custom cleaning solution, manufacturer cleaning solution is informed *)
	Test["If CustomCleaningSolution is False, ManufacturerCleaningSolution is informed:",
		Lookup[packet,{CustomCleaningSolution,ManufacturerCleaningSolution}],
		Alternatives[{False,Except[Null]},{True,_}]
	]

};


(* ::Subsection::Closed:: *)
(*validModelInstrumentDynamicFoamAnalyzerQTests*)


validModelInstrumentDynamicFoamAnalyzerQTests[packet:PacketP[Model[Instrument,DynamicFoamAnalyzer]]]:={
	(*fields that must be populated*)
	NotNullFieldTest[packet,{
		DetectionMethods,
		AgitationTypes,
		IlluminationWavelengths,
		Software
	}
	],

	RequiredTogetherTest[packet,{AvailableGases,MinGasPressure,MaxGasPressure,MinFlowRate,MaxFlowRate}],

	(*Min/Max flow rate sanity check*)
	FieldComparisonTest[packet, {MinTemperature, MaxTemperature}, LessEqual],
	FieldComparisonTest[packet, {MinColumnHeight, MaxColumnHeight}, LessEqual],
	FieldComparisonTest[packet, {MinColumnDiameter, MaxColumnDiameter}, LessEqual],
	FieldComparisonTest[packet, {MinGasPressure, MaxGasPressure}, LessEqual],
	FieldComparisonTest[packet, {MinFlowRate, MaxFlowRate}, LessEqual],
	FieldComparisonTest[packet, {MinStirRate, MaxStirRate}, LessEqual],
	FieldComparisonTest[packet, {MinOscillationPeriod, MaxOscillationPeriod}, LessEqual],
	FieldComparisonTest[packet, {MinFoamHeightSamplingFrequency, MaxFoamHeightSamplingFrequency}, LessEqual]
};



(* ::Subsection::Closed:: *)
(*validModelInstrumentSpargeFilterCleanerQTests*)


validModelInstrumentSpargeFilterCleanerQTests[packet:PacketP[Model[Instrument,SpargeFilterCleaner]]]:={
	(*fields that should be informed*)
	NotNullFieldTest[packet,{PumpType,VacuumPressure}],
	(*sanity check tests*)
	FieldComparisonTest[packet,{MinFilterDiameter,MaxFilterDiameter},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validModelInstrumentUVLampQTests*)


validModelInstrumentUVLampQTests[packet:PacketP[Model[Instrument,UVLamp]]]:={
};


(* ::Subsection:: *)
(* Test Registration *)


registerValidQTestFunction[Model[Instrument],validModelInstrumentQTests];
registerValidQTestFunction[Model[Instrument, Anemometer],validModelInstrumentAnemometerQTests];
registerValidQTestFunction[Model[Instrument, Aspirator],validModelInstrumentAspiratorQTests];
registerValidQTestFunction[Model[Instrument, Autoclave],validModelInstrumentAutoclaveQTests];
registerValidQTestFunction[Model[Instrument, Balance],validModelInstrumentBalanceQTests];
registerValidQTestFunction[Model[Instrument, DistanceGauge],validModelInstrumentDistanceGaugeQTests];
registerValidQTestFunction[Model[Instrument, BioLayerInterferometer], validModelInstrumentBioLayerInterferometerQTests];
registerValidQTestFunction[Model[Instrument, BiosafetyCabinet],validModelInstrumentBiosafetyCabinetQTests];
registerValidQTestFunction[Model[Instrument, BottleRoller],validModelInstrumentBottleRollerQTests];
registerValidQTestFunction[Model[Instrument, BlowGun],validModelInstrumentBlowGunQTests];
registerValidQTestFunction[Model[Instrument, BottleTopDispenser],validModelInstrumentBottleTopDispenserQTests];
registerValidQTestFunction[Model[Instrument, CapillaryELISA],validModelInstrumentCapillaryELISAQTests];
registerValidQTestFunction[Model[Instrument, CellThaw],validModelInstrumentCellThawQTests];
registerValidQTestFunction[Model[Instrument, Centrifuge],validModelInstrumentCentrifugeQTests];
registerValidQTestFunction[Model[Instrument, ColonyHandler],validModelInstrumentColonyHandlerQTests];
registerValidQTestFunction[Model[Instrument, ColonyImager],validModelInstrumentColonyImagerQTests];
registerValidQTestFunction[Model[Instrument, ConductivityMeter],validModelInstrumentConductivityMeterQTests];
registerValidQTestFunction[Model[Instrument, ControlledRateFreezer],validModelInstrumentControlledRateFreezerQTests];
registerValidQTestFunction[Model[Instrument, CoulterCounter],validModelInstrumentCoulterCounterQTests];
registerValidQTestFunction[Model[Instrument, Crimper],validModelInstrumentCrimperQTests];
registerValidQTestFunction[Model[Instrument, CrossFlowFiltration],validModelInstrumentCrossFlowFiltrationQTests];
registerValidQTestFunction[Model[Instrument, CryogenicFreezer],validModelInstrumentCryogenicFreezerQTests];
registerValidQTestFunction[Model[Instrument, CrystalIncubator],validModelInstrumentCrystalIncubatorQTests];
registerValidQTestFunction[Model[Instrument, CuvetteWasher],validModelInstrumentCuvetteWasherQTests];
registerValidQTestFunction[Model[Instrument, Darkroom],validModelInstrumentDarkroomQTests];
registerValidQTestFunction[Model[Instrument, DensityMeter],validModelInstrumentDensityMeterQTests];
registerValidQTestFunction[Model[Instrument, Desiccator],validModelInstrumentDesiccatorQTests];
registerValidQTestFunction[Model[Instrument, Dewar],validModelInstrumentDewarQTests];
registerValidQTestFunction[Model[Instrument, Dialyzer],validModelInstrumentDializerQTests];
registerValidQTestFunction[Model[Instrument, Diffractometer],validModelInstrumentDiffractometerQTests];
registerValidQTestFunction[Model[Instrument, Dishwasher],validModelInstrumentDishwasherQTests];
registerValidQTestFunction[Model[Instrument, Dispenser],validModelInstrumentDispenserQTests];
registerValidQTestFunction[Model[Instrument, DLSPlateReader],validModelInstrumentDLSPlateReaderQTests];
registerValidQTestFunction[Model[Instrument, DissolvedOxygenMeter],validModelInstrumentDissolvedOxygenMeterQTests];
registerValidQTestFunction[Model[Instrument, DNASynthesizer],validModelInstrumentDNASynthesizerQTests];
registerValidQTestFunction[Model[Instrument, DifferentialScanningCalorimeter],validModelInstrumentDifferentialScanningCalorimeterQTests];
registerValidQTestFunction[Model[Instrument, DynamicFoamAnalyzer],validModelInstrumentDynamicFoamAnalyzerQTests];
registerValidQTestFunction[Model[Instrument, Electrophoresis],validModelInstrumentElectrophoresisQTests];
registerValidQTestFunction[Model[Instrument, Electroporator],validModelInstrumentElectroporatorQTests];
registerValidQTestFunction[Model[Instrument, EnvironmentalChamber],validModelInstrumentEnvironmentalChamberQTests];
registerValidQTestFunction[Model[Instrument, CondensateRecirculator],validModelInstrumentCondensateRecirculatorQTests];
registerValidQTestFunction[Model[Instrument, Evaporator],validModelInstrumentEvaporatorQTests];
registerValidQTestFunction[Model[Instrument, FilterBlock],validModelInstrumentFilterBlockQTests];
registerValidQTestFunction[Model[Instrument, FilterHousing],validModelInstrumentFilterHousingQTests];
registerValidQTestFunction[Model[Instrument, FlashChromatography],validModelInstrumentFlashChromatographyQTests];
registerValidQTestFunction[Model[Instrument, FlowCytometer],validModelInstrumentFlowCytometerQTests];
registerValidQTestFunction[Model[Instrument, FluorescenceActivatedCellSorter],validModelInstrumentFluorescenceActivatedCellSorterQTests];
registerValidQTestFunction[Model[Instrument, FPLC],validModelInstrumentFPLCQTests];
registerValidQTestFunction[Model[Instrument, FragmentAnalyzer],validModelInstrumentFragmentAnalyzerQTests];
registerValidQTestFunction[Model[Instrument, FreezePumpThawApparatus],validModelInstrumentFreezePumpThawApparatusQTests];
registerValidQTestFunction[Model[Instrument, Freezer],validModelInstrumentFreezerQTests];
registerValidQTestFunction[Model[Instrument, PortableHeater],validModelInstrumentPortableHeaterQTests];
registerValidQTestFunction[Model[Instrument, PortableCooler],validModelInstrumentPortableCoolerQTests];
registerValidQTestFunction[Model[Instrument, FumeHood],validModelInstrumentFumeHoodQTests];
registerValidQTestFunction[Model[Instrument, GasFlowSwitch],validModelInstrumentGasFlowSwitchQTests];
registerValidQTestFunction[Model[Instrument, GasChromatograph],validModelInstrumentGasChromatographQTests];
registerValidQTestFunction[Model[Instrument, GasGenerator],validModelInstrumentGasGeneratorQTests];
registerValidQTestFunction[Model[Instrument, GelBox],validModelInstrumentGelBoxQTests];
registerValidQTestFunction[Model[Instrument, GeneticAnalyzer],validModelInstrumentGeneticAnalyzerQTests];
registerValidQTestFunction[Model[Instrument, GloveBox],validModelInstrumentGloveBoxQTests];
registerValidQTestFunction[Model[Instrument, GravityRack],validModelInstrumentGravityRackQTests];
registerValidQTestFunction[Model[Instrument, HandlingStation],validModelInstrumentHandlingStationQTests];
registerValidQTestFunction[Model[Instrument, HandlingStation, Ambient], validModelInstrumentHandlingStationAmbientQTests];
registerValidQTestFunction[Model[Instrument, HandlingStation, BiosafetyCabinet], validModelInstrumentHandlingStationBiosafetyCabinetQTests];
registerValidQTestFunction[Model[Instrument, HandlingStation, FumeHood], validModelInstrumentHandlingStationFumeHoodQTests];
registerValidQTestFunction[Model[Instrument, HandlingStation, GloveBox], validModelInstrumentHandlingStationGloveBoxQTests];
registerValidQTestFunction[Model[Instrument, Grinder],validModelInstrumentGrinderQTests];
registerValidQTestFunction[Model[Instrument, HeatBlock],validModelInstrumentHeatBlockQTests];
registerValidQTestFunction[Model[Instrument, HeatExchanger],validModelInstrumentHeatExchangerQTests];
registerValidQTestFunction[Model[Instrument, HotPlate],validModelInstrumentHotPlateQTests];
registerValidQTestFunction[Model[Instrument, HPLC],validModelInstrumentHPLCQTests];
registerValidQTestFunction[Model[Instrument, Incubator],validModelInstrumentIncubatorQTests];
registerValidQTestFunction[Model[Instrument, InfraredProbe],validModelInstrumentInfraredProbeQTests];
registerValidQTestFunction[Model[Instrument, IonChromatography],validModelInstrumentIonChromatographyQTests];
registerValidQTestFunction[Model[Instrument, KarlFischerTitrator],validModelInstrumentKarlFischerTiratorQTests];
registerValidQTestFunction[Model[Instrument, LightMeter],validModelInstrumentLightMeterQTests];
registerValidQTestFunction[Model[Instrument, LiquidHandler],validModelInstrumentLiquidHandlerQTests];
registerValidQTestFunction[Model[Instrument, LiquidHandler,AcousticLiquidHandler],validModelInstrumentAcousticLiquidHandlerQTests];
registerValidQTestFunction[Model[Instrument, LiquidLevelDetector],validModelInstrumentLiquidLevelDetectorQTests];
registerValidQTestFunction[Model[Instrument, LiquidNitrogenDoser],validModelInstrumentLiquidNitrogenDoserQTests];
registerValidQTestFunction[Model[Instrument, LiquidParticleCounter],validModelInstrumentLiquidParticleCounterQTests];
registerValidQTestFunction[Model[Instrument, Lyophilizer],validModelInstrumentLyophilizerQTests];
registerValidQTestFunction[Model[Instrument, MassSpectrometer],validModelInstrumentMassSpectrometerQTests];
registerValidQTestFunction[Model[Instrument, MeltingPointApparatus],validModelInstrumentMeltingPointApparatusQTests];
registerValidQTestFunction[Model[Instrument, Microscope],validModelInstrumentMicroscopeQTests];
registerValidQTestFunction[Model[Instrument, MicroscopeProbe],validModelInstrumentMicroscopeProbeQTests];
registerValidQTestFunction[Model[Instrument, Microwave],validModelInstrumentMicrowaveQTests];
registerValidQTestFunction[Model[Instrument, Reactor, Microwave],validModelInstrumentReactorMicrowaveQTests];
registerValidQTestFunction[Model[Instrument, NMR],validModelInstrumentNMRQTests];
registerValidQTestFunction[Model[Instrument, Osmometer],validModelInstrumentOsmometerQTests];
registerValidQTestFunction[Model[Instrument, OverheadStirrer],validModelInstrumentOverheadStirrerQTests];
registerValidQTestFunction[Model[Instrument, PackingDevice],validModelInstrumentPackingDeviceQTests];
registerValidQTestFunction[Model[Instrument, ParticleSizeProbe],validModelInstrumentParticleSizeProbeQTests];
registerValidQTestFunction[Model[Instrument, PeptideSynthesizer],validModelInstrumentPeptideSynthesizerQTests];
registerValidQTestFunction[Model[Instrument, PeristalticPump],validModelInstrumentPeristalticPumpQTests];
registerValidQTestFunction[Model[Instrument, PressureManifold],validModelInstrumentPressureManifoldQTests];
registerValidQTestFunction[Model[Instrument, PlatePourer],validModelInstrumentPlatePourerQTests];
registerValidQTestFunction[Model[Instrument, pHMeter],validModelInstrumentpHMeterQTests];
registerValidQTestFunction[Model[Instrument, pHTitrator],validModelInstrumentpHTitratorQTests];
registerValidQTestFunction[Model[Instrument, Pipette],validModelInstrumentPipetteQTests];
registerValidQTestFunction[Model[Instrument, PlateImager],validModelInstrumentPlateImagerQTests];
registerValidQTestFunction[Model[Instrument, PlateReader],validModelInstrumentPlateReaderQTests];
registerValidQTestFunction[Model[Instrument, PlateTilter],validModelInstrumentPlateTilterQTests];
registerValidQTestFunction[Model[Instrument, PlateWasher],validModelInstrumentPlateWasherQTests];
registerValidQTestFunction[Model[Instrument, PowerSupply],validModelInstrumentPowerSupplyQTests];
registerValidQTestFunction[Model[Instrument, ProteinCapillaryElectrophoresis],validModelInstrumentProteinCapillaryElectrophoresisQTests];
registerValidQTestFunction[Model[Instrument, PurgeBox],validModelInstrumentPurgeBoxQTests];
registerValidQTestFunction[Model[Instrument, RamanProbe],validModelInstrumentRamanProbeQTests];
registerValidQTestFunction[Model[Instrument, RamanSpectrometer], validModelInstrumentRamanSpectrometerQTests];
registerValidQTestFunction[Model[Instrument, Reactor],validModelInstrumentReactorQTests];
registerValidQTestFunction[Model[Instrument, Reactor, Electrochemical],validModelInstrumentReactorElectrochemicalQTests];
registerValidQTestFunction[Model[Instrument, RecirculatingPump],validModelInstrumentRecirculatingPumpQTests];
registerValidQTestFunction[Model[Instrument, Refractometer], validModelInstrumentRefractometerQTests];
registerValidQTestFunction[Model[Instrument, Refrigerator],validModelInstrumentRefrigeratorQTests];
registerValidQTestFunction[Model[Instrument, RobotArm],validModelInstrumentRobotArmQTests];
registerValidQTestFunction[Model[Instrument, Rocker],validModelInstrumentRockerQTests];
registerValidQTestFunction[Model[Instrument, Roller],validModelInstrumentRollerQTests];
registerValidQTestFunction[Model[Instrument, RotaryEvaporator],validModelInstrumentRotaryEvaporatorQTests];
registerValidQTestFunction[Model[Instrument, SampleImager],validModelInstrumentSampleImagerQTests];
registerValidQTestFunction[Model[Instrument, SampleInspector],validModelInstrumentSampleInspectorQTests];
registerValidQTestFunction[Model[Instrument, SchlenkLine],validModelInstrumentSchlenkLineQTests];
registerValidQTestFunction[Model[Instrument, Shaker],validModelInstrumentShakerQTests];
registerValidQTestFunction[Model[Instrument, SolidDispenser],validModelInstrumentSolidDispenserQTests];
registerValidQTestFunction[Model[Instrument, Sonicator],validModelInstrumentSonicatorQTests];
registerValidQTestFunction[Model[Instrument, SpargeFilterCleaner],validModelInstrumentSpargeFilterCleanerQTests];
registerValidQTestFunction[Model[Instrument, SpargingApparatus],validModelInstrumentSpargingApparatusQTests];
registerValidQTestFunction[Model[Instrument, Spectrophotometer],validModelInstrumentSpectrophotometerQTests];
registerValidQTestFunction[Model[Instrument, SpeedVac],validModelInstrumentSpeedVacQTests];
registerValidQTestFunction[Model[Instrument, SterilizationIndicatorReader],validModelInstrumentSterilizationIndicatorReaderQTests];
registerValidQTestFunction[Model[Instrument, SupercriticalFluidChromatography],validModelInstrumentSFCQTests];
registerValidQTestFunction[Model[Instrument, SurfacePlasmonResonance],validModelInstrumentSurfacePlasmonResonanceQTests];
registerValidQTestFunction[Model[Instrument, SyringePump],validModelInstrumentSyringePumpQTests];
registerValidQTestFunction[Model[Instrument, Tachometer],validModelInstrumentTachometerQTests];
registerValidQTestFunction[Model[Instrument, Tensiometer],validModelInstrumentTensiometerQTests];
registerValidQTestFunction[Model[Instrument, Thermocycler],validModelInstrumentThermocyclerQTests];
registerValidQTestFunction[Model[Instrument, Thermocycler,DigitalPCR],validModelInstrumentDigitalPCRQTests];
registerValidQTestFunction[Model[Instrument, PlateSealer],validModelInstrumentPlateSealerQTests];
registerValidQTestFunction[Model[Instrument, MultimodeSpectrophotometer],validModelInstrumentMultimodeSpectrophotometerQTests];
registerValidQTestFunction[Model[Instrument, UVLamp],validModelInstrumentUVLampQTests];
registerValidQTestFunction[Model[Instrument, VacuumCentrifuge],validModelInstrumentVacuumCentrifugeQTests];
registerValidQTestFunction[Model[Instrument, VacuumDegasser],validModelInstrumentVacuumDegasserQTests];
registerValidQTestFunction[Model[Instrument, VacuumManifold],validModelInstrumentVacuumManifoldQTests];
registerValidQTestFunction[Model[Instrument, VacuumPump],validModelInstrumentVacuumPumpQTests];
registerValidQTestFunction[Model[Instrument, VaporTrap],validModelInstrumentVaporTrapQTests];
registerValidQTestFunction[Model[Instrument, VerticalLift],validModelInstrumentVerticalLiftQTests];
registerValidQTestFunction[Model[Instrument, Viscometer],validModelInstrumentViscometerQTests];
registerValidQTestFunction[Model[Instrument, Vortex],validModelInstrumentVortexQTests];
registerValidQTestFunction[Model[Instrument, WaterPurifier],validModelInstrumentWaterPurifierQTests];
registerValidQTestFunction[Model[Instrument, Sink],validModelInstrumentSinkQTests];
registerValidQTestFunction[Model[Instrument, Western],validModelInstrumentWesternQTests];
registerValidQTestFunction[Model[Instrument, ProteinCapillaryElectrophoresis],validModelInstrumentProteinCapillaryElectrophoresisQTests];
registerValidQTestFunction[Model[Instrument, Nephelometer], validModelInstrumentNephelometerQTests];
