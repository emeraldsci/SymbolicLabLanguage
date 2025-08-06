(* ::Package:: *)

(*\[Copyright] 2011-2025 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(* SampleManipulation framework (Deprecated) legacy code and constants *)


(* ::Subsubsection::Closed:: *)
(*Primitive Key Patterns*)


(* Primitive keys used to specify pipetting method *)
pipettingParameterSet:=(pipettingParameterSet=Association[
	TipType -> Alternatives[
		Automatic,
		TipTypeP,
		(* Specific tip model *)
		ObjectP[Model[Item,Tips]]
	],
	TipSize -> Automatic|VolumeP,
	AspirationRate -> (RangeP[0.4 Microliter/Second,500 Microliter/Second]|Automatic),
	DispenseRate -> (RangeP[0.4 Microliter/Second,500 Microliter/Second]|Automatic),
	OverAspirationVolume -> (RangeP[0 Microliter,50 Microliter]|Automatic),
	OverDispenseVolume -> (RangeP[0 Microliter,300 Microliter]|Automatic),
	AspirationWithdrawalRate -> (RangeP[0.3 Millimeter/Second, 160 Millimeter/Second]|Automatic),
	DispenseWithdrawalRate -> (RangeP[0.3 Millimeter/Second, 160 Millimeter/Second]|Automatic),
	AspirationEquilibrationTime -> (RangeP[0 Second, 9.9 Second]|Automatic),
	DispenseEquilibrationTime -> (RangeP[0 Second, 9.9 Second]|Automatic),
	CorrectionCurve -> Alternatives[
		{{RangeP[0 Microliter, 1000 Microliter],RangeP[0 Microliter, 1250 Microliter]}...},
		Automatic,
		Null
	],
	AspirationMixRate -> (RangeP[0.4 Microliter/Second,500 Microliter/Second]|Automatic|Null),
	DispenseMixRate -> (RangeP[0.4 Microliter/Second,500 Microliter/Second]|Automatic|Null),
	AspirationMix -> BooleanP|Automatic,
	DispenseMix -> BooleanP|Automatic,
	AspirationMixVolume -> (RangeP[0 Microliter,970 Microliter]|Automatic|Null),
	DispenseMixVolume -> (RangeP[0 Microliter,970 Microliter]|Automatic|Null),
	AspirationNumberOfMixes -> (_Integer|Automatic|Null),
	DispenseNumberOfMixes -> (_Integer|Automatic|Null),
	AspirationPosition -> (PipettingPositionP|Automatic),
	DispensePosition -> (PipettingPositionP|Automatic),
	AspirationPositionOffset -> (GreaterEqualP[0 Millimeter]|Automatic),
	DispensePositionOffset -> (GreaterEqualP[0 Millimeter]|Automatic),
	PipettingMethod -> (ObjectP[Model[Method,Pipetting]]|Automatic|Null),
	DynamicAspiration -> Automatic|BooleanP
]);

objectSpecificationP:=(objectSpecificationP=Alternatives[
	NonSelfContainedSampleP,
	NonSelfContainedSampleModelP,
	FluidContainerP,
	FluidContainerModelP,
	PlateAndWellP,
	{ObjectP[Model[Container,Plate]],WellPositionP},
	(* Defined tag *)
	_String,
	(* Container tag *)
	{_String,WellPositionP},
	{_Integer|_Symbol,NonSelfContainedSampleModelP|FluidContainerP|FluidContainerModelP},
	{{_Integer|_Symbol,FluidContainerP|FluidContainerModelP},WellPositionP}
]);

objectSpecificationNoModelP:=(objectSpecificationNoModelP=Alternatives[
	NonSelfContainedSampleP,
	FluidContainerP,
	PlateAndWellP,
	(* Defined tag *)
	_String,
	(* Container tag *)
	{_String,WellPositionP},
	{_Integer|_Symbol,NonSelfContainedSampleModelP|FluidContainerP|FluidContainerModelP},
	{{_Integer|_Symbol,FluidContainerP|FluidContainerModelP},WellPositionP}
]);

manipulationKeyPatterns[Transfer]:=(manipulationKeyPatterns[Transfer]=Join[
	Association[
		Source -> objectSpecificationP,
		Destination -> objectSpecificationP,
		Amount -> (GreaterEqualP[0 Microliter]|GreaterEqualP[0 Gram]|GreaterEqualP[0, 1]),
		Resuspension -> BooleanP|Automatic,
		TransferType -> (Liquid|Slurry|Solid|Automatic),
		DeviceChannel -> Alternatives[
			MultiProbeHead,
			SingleProbe1,
			SingleProbe2,
			SingleProbe3,
			SingleProbe4,
			SingleProbe5,
			SingleProbe6,
			SingleProbe7,
			SingleProbe8
		],
		InWellSeparation -> BooleanP
	],
	pipettingParameterSet
]);

manipulationKeyPatterns[Aliquot]:=(manipulationKeyPatterns[Aliquot]=Join[
	Association[
		Source -> objectSpecificationP,
		Destinations -> {objectSpecificationP..},
		Amounts -> ListableP[(GreaterEqualP[0 Microliter]|GreaterEqualP[0 Gram]|GreaterEqualP[0, 1])],
		TransferType -> (Liquid|Slurry|Solid),
		InWellSeparation -> BooleanP
	],
	pipettingParameterSet
]);
manipulationKeyPatterns[Resuspend]:=(manipulationKeyPatterns[Resuspend]=Join[
	Association[
		Sample -> objectSpecificationP,
		Volume -> GreaterEqualP[0 Microliter],
		Diluent -> objectSpecificationP,
		Mix -> BooleanP,
		MixType -> ListableP[Null|MixTypeP],
		MixUntilDissolved -> ListableP[BooleanP],
		MixVolume -> ListableP[RangeP[1 Microliter, 50 Milliliter]|Null],
		NumberOfMixes -> ListableP[RangeP[1, 50, 1]|Null],
		MaxNumberOfMixes ->  ListableP[RangeP[1, 50, 1]|Null],
		(* Time and Temperature need to allow Null in case we're mixing by Pipette/Inversion *)
		IncubationTime -> ListableP[RangeP[0 Minute,72 Hour] | Null],
		MaxIncubationTime -> ListableP[RangeP[0 Minute,72 Hour]|Null],
		IncubationInstrument -> ListableP[
			ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]|Null],
			IncubationTemperature -> ListableP[Ambient | TemperatureP | Null],
			AnnealingTime -> ListableP[GreaterEqualP[0 Minute]|Null]
	],
	pipettingParameterSet
]);
manipulationKeyPatterns[Consolidation]:=(manipulationKeyPatterns[Consolidation]=Join[
	Association[
		Sources -> {objectSpecificationP..},
		Destination -> objectSpecificationP,
		Amounts -> {(GreaterEqualP[0 Microliter]|GreaterEqualP[0 Gram]|GreaterEqualP[0, 1])..},
		TransferType -> (Liquid|Slurry|Solid),
		InWellSeparation -> BooleanP
	],
	pipettingParameterSet
]);

manipulationKeyPatterns[FillToVolume]:=(manipulationKeyPatterns[FillToVolume]=Association[
	Source -> objectSpecificationP,
	Destination -> objectSpecificationP,
	FinalVolume -> GreaterEqualP[0 Microliter],
	TransferType -> Liquid,
	Method -> FillToVolumeMethodP
]);

manipulationKeyPatterns[Incubate|Mix]:=(manipulationKeyPatterns[Incubate|Mix]=Association[
	(* Incubate keys shared among the different scales *)
	Sample -> ListableP[objectSpecificationNoModelP],
	(* Time and Temperature need to allow Null in case we're mixing by Pipette/Inversion *)
	Time -> ListableP[RangeP[0 Minute,$MaxExperimentTime] | Null],
	Temperature -> ListableP[Ambient | TemperatureP | Null],
	MixRate -> ListableP[RPMP|Null],
	ResidualIncubation -> ListableP[BooleanP],
	ResidualTemperature -> ListableP[Ambient|TemperatureP|Null],
	ResidualMix -> ListableP[BooleanP],
	ResidualMixRate -> ListableP[RPMP|Null],
	(* Incubate keys specific to MicroLiquidHandling *)
	Preheat -> ListableP[BooleanP],
	(* Incubate keys specific to MacroLiquidHandling *)
	Mix -> ListableP[BooleanP],
	MixType -> ListableP[Null|MixTypeP],
	Instrument -> ListableP[ObjectP[Join[MixInstrumentModels,MixInstrumentObjects]]|Null],
	NumberOfMixes -> ListableP[RangeP[1, 50, 1]|Null],
	MixVolume -> ListableP[RangeP[1 Microliter, 50 Milliliter]|Null],
	MixUntilDissolved -> ListableP[BooleanP],
	MaxNumberOfMixes ->  ListableP[RangeP[1, 50, 1]|Null],
	MaxTime -> ListableP[RangeP[0 Minute,$MaxExperimentTime]|Null],
	AnnealingTime -> ListableP[GreaterEqualP[0 Minute]|Null],
	(* Mix borrows this key from the pipetting parameters but since there isn't
	really a concept of aspiration/dispense for mix-by-pipette, fold into one key *)
	MixFlowRate -> (RangeP[0.4 Microliter/Second,500 Microliter/Second]|Automatic),
	MixPosition -> (PipettingPositionP|Automatic),
	MixPositionOffset -> (GreaterEqualP[0 Millimeter]|Automatic),
	CorrectionCurve -> Alternatives[
		{{RangeP[0 Microliter, 1000 Microliter],RangeP[0 Microliter, 1250 Microliter]}...},
		Automatic,
		Null
	],
	TipType -> Alternatives[
		Automatic,
		TipTypeP,
		(* Specific tip model *)
		ObjectP[Model[Item,Tips]]
	],
	TipSize -> Automatic|VolumeP,
	DeviceChannel -> ListableP[Alternatives[
		MultiProbeHead,
		SingleProbe1,
		SingleProbe2,
		SingleProbe3,
		SingleProbe4,
		SingleProbe5,
		SingleProbe6,
		SingleProbe7,
		SingleProbe8
	]]
]);


manipulationKeyPatterns[Wait]:=(manipulationKeyPatterns[Wait]=Association[
	Duration -> GreaterEqualP[0 Second]
]);

manipulationKeyPatterns[Define]:=(manipulationKeyPatterns[Define]=Association[
	Name -> _String,
	Sample -> Alternatives[
		ObjectP[{Object[Sample],Model[Sample]}],
		{
			ObjectP[{Object[Container],Model[Container]}]|_String,
			WellPositionP
		},
		Null,
		Automatic
	],
	Container -> ObjectP[{Object[Container],Model[Container]}]|Null|Automatic,
	Well -> WellPositionP|Automatic,
	ContainerName -> _String|Null,
	Model -> ObjectP[Model[Sample]]|Null|Automatic,
	StorageCondition -> SampleStorageTypeP|ObjectP[Model[StorageCondition]]|Null|Automatic,
	ExpirationDate -> _?DateObjectQ|Null|Automatic,
	TransportTemperature -> GreaterP[0 Kelvin]|Null|Automatic,
	SamplesOut -> BooleanP,
	ModelType -> TypeP[Model[Sample]]|Null,
	ModelName -> _String|Null,
	State -> ModelStateP|Null,
	Expires -> BooleanP|Null,
	ShelfLife -> GreaterP[0 Day]|Null,
	UnsealedShelfLife -> GreaterP[0 Day]|Null,
	DefaultStorageCondition -> SampleStorageTypeP|ObjectP[Model[StorageCondition]]|Null|Automatic,
	DefaultTransportTemperature -> GreaterP[0 Kelvin]|Null
]);


manipulationKeyPatterns[Filter]:=(manipulationKeyPatterns[Filter]=Association[
	(* shared keys among Micro and Macro *)
	Sample -> ListableP[objectSpecificationP],
	(* note that Time is the time to apply pressure in Micro, and the time to centrifuge in Macro *)
	Time -> TimeP,
	CollectionContainer -> Automatic|ListableP[objectSpecificationP],
	CollectionSample -> ListableP[objectSpecificationP]|Null,
	(* Micro specific keys *)
	Pressure -> RangeP[1 PSI, 40 PSI]|Null,
	(*
	FiltrateModel -> ListableP[ObjectP[Model[Sample]]|Null|Automatic],
	ResidueModel -> ListableP[ObjectP[Model[Sample]]|Null|Automatic],
	CollectResidue -> ListableP[Automatic|BooleanP],
	ResidueCollectionSolvent -> ListableP[objectSpecificationP],
	ResidueCollectionDestination -> ListableP[objectSpecificationP],
	ResidueCollectionVolume -> ListableP[Null|VolumeP]
	*)
	(* Macro specific keys *)
	Filter -> Automatic|ListableP[_String]|ListableP[ObjectP[{
		Model[Container, Plate, Filter],
		Object[Container, Plate, Filter],
		Model[Container, Vessel, Filter],
		Object[Container, Vessel, Filter],
		Model[Item,Filter],
		Object[Item,Filter]
	}]],
	FilterStorageCondition->(SampleStorageTypeP|Disposal|ObjectP[Model[StorageCondition]]),
	MembraneMaterial -> Automatic|FilterMembraneMaterialP,
	PoreSize -> Automatic|FilterSizeP,
	FiltrationType -> Automatic|FiltrationTypeP,
	Instrument -> Automatic| ObjectP[{
		Model[Instrument,FilterBlock],
		Object[Instrument,FilterBlock],
		Model[Instrument,PeristalticPump],
		Object[Instrument,PeristalticPump],
		Model[Instrument,VacuumPump],
		Object[Instrument,VacuumPump],
		Model[Instrument,Filter],
		Model[Instrument,Centrifuge],
		Object[Instrument,Centrifuge],
		Model[Instrument,SyringePump],
		Object[Instrument,SyringePump]
	}],
	FilterHousing -> Automatic | Null | ObjectP[{
		Model[Instrument,FilterHousing],
		Object[Instrument,FilterHousing],
		Model[Instrument, FilterBlock],
		Object[Instrument, FilterBlock]
	}],
	Syringe -> Automatic | Null | ObjectP[{
		Model[Container,Syringe],
		Object[Container,Syringe]
	}],
	Sterile -> BooleanP,
	MolecularWeightCutoff -> Automatic | Null | FilterMolecularWeightCutoffP,
	PrefilterMembraneMaterial -> Automatic | Null | FilterMembraneMaterialP,
	PrefilterPoreSize -> Automatic | Null | FilterSizeP,
	Temperature -> Automatic | Null | GreaterEqualP[4 Celsius],
	Intensity -> Automatic | Null | GreaterP[0 RPM] | GreaterP[0 GravitationalAcceleration],
	CounterbalanceWeight -> Automatic  | {RangeP[0 Gram, 500 Gram]..}
]);

manipulationKeyPatterns[MoveToMagnet]:=(manipulationKeyPatterns[MoveToMagnet]=Association[
	Sample->objectSpecificationP
]);

manipulationKeyPatterns[RemoveFromMagnet]:=(manipulationKeyPatterns[RemoveFromMagnet]=Association[
	Sample->objectSpecificationP
]);

manipulationKeyPatterns[Centrifuge]:=(manipulationKeyPatterns[Centrifuge]=Association[
	Sample -> ListableP[objectSpecificationP],
	Instrument -> ListableP[Automatic | ObjectP[{Model[Instrument,Centrifuge],Object[Instrument,Centrifuge]}]],
	Intensity -> ListableP[Automatic | GreaterP[0 RPM] | GreaterP[0 GravitationalAcceleration]],
	Time -> ListableP[Automatic | TimeP],
	Temperature -> ListableP[Automatic | Ambient | RangeP[4 Celsius,40 Celsius]],
	CollectionContainer -> ListableP[objectSpecificationP],
	CounterbalanceWeight -> Automatic | {RangeP[0 Gram, 500 Gram]..}
]);

manipulationKeyPatterns[Pellet]:=(manipulationKeyPatterns[Pellet]=Association@List[
	Sample -> ListableP[objectSpecificationP],
	Instrument -> ListableP[Automatic | ObjectP[{Model[Instrument,Centrifuge],Object[Instrument,Centrifuge]}]],
	Intensity -> ListableP[Automatic | GreaterP[0 RPM] | GreaterP[0 GravitationalAcceleration]],
	Time -> ListableP[Automatic | TimeP],
	Temperature -> ListableP[Automatic | Ambient | RangeP[4 Celsius,40 Celsius]],

	SupernatantDestination->ListableP[objectSpecificationP|Waste],
	ResuspensionSource->ListableP[objectSpecificationP],

	(* Copy over the options from ExperimentPellet. *)
	Sequence@@(#->Automatic|ReleaseHold[Lookup[FirstCase[OptionDefinition[ExperimentPellet], KeyValuePattern["OptionSymbol" -> #]], "Pattern"]]&)/@{
		SupernatantVolume, SupernatantTransferInstrument,
		ResuspensionVolume, ResuspensionInstrument, ResuspensionMix,
		ResuspensionMixType, ResuspensionMixUntilDissolved,
		ResuspensionMixInstrument, ResuspensionMixTime,
		ResuspensionMixMaxTime, ResuspensionMixDutyCycle,
		ResuspensionMixRate, ResuspensionNumberOfMixes,
		ResuspensionMaxNumberOfMixes, ResuspensionMixVolume,
		ResuspensionMixTemperature, ResuspensionMixMaxTemperature,
		ResuspensionMixAmplitude
	}
]);


manipulationKeyPatterns[ReadPlate]:=(manipulationKeyPatterns[ReadPlate]=Association[
	Sample -> ListableP[objectSpecificationP],
	Blank -> ListableP[objectSpecificationP],
	Type -> ReadPlateTypeP,
	Mode -> (Fluorescence|TimeResolvedFluorescence|Automatic),
	Wavelength -> Alternatives[
		ListableP[RangeP[220 Nanometer, 1000 Nanometer]],
		Span[RangeP[220 Nanometer, 1000 Nanometer],RangeP[220 Nanometer, 1000 Nanometer]],
		All,
		Automatic
	],
	BlankAbsorbance -> BooleanP,
	ExcitationWavelength -> ListableP[RangeP[320 Nanometer,740 Nanometer]|Automatic],
	EmissionWavelength -> ListableP[RangeP[320 Nanometer,740 Nanometer]|Automatic],
	WavelengthSelection -> (WavelengthSelectionP|Automatic),
	PrimaryInjectionSample -> ListableP[ObjectP[{Object[Sample],Model[Sample]}]|Null],
	SecondaryInjectionSample -> ListableP[ObjectP[{Object[Sample],Model[Sample]}]|Null],
	TertiaryInjectionSample -> ListableP[ObjectP[{Object[Sample],Model[Sample]}]|Null],
	QuaternaryInjectionSample -> ListableP[ObjectP[{Object[Sample],Model[Sample]}]|Null],
	PrimaryInjectionVolume -> ListableP[RangeP[0.5 Microliter,300 Microliter]|Null],
	SecondaryInjectionVolume -> ListableP[RangeP[0.5 Microliter,300 Microliter]|Null],
	TertiaryInjectionVolume -> ListableP[RangeP[0.5 Microliter,300 Microliter]|Null],
	QuaternaryInjectionVolume -> ListableP[RangeP[0.5 Microliter,300 Microliter]|Null],
	Gain -> ListableP[Alternatives[
		RangeP[1 Percent,95 Percent],
		RangeP[1 Microvolt,4095 Microvolt],
		Automatic
	]],
	DelayTime -> RangeP[0 Microsecond,2 Second]|Automatic,
	ReadTime -> RangeP[1 Microsecond,10000 Microsecond]|Automatic,
	ReadLocation -> ReadLocationP|Automatic,
	Temperature -> Ambient|RangeP[$AmbientTemperature,45 Celsius]|Null,
	EquilibrationTime -> RangeP[0 Minute,1 Hour],
	NumberOfReadings -> RangeP[1,200],
	AdjustmentSample -> FullPlate|objectSpecificationP|Automatic,
	FocalHeight -> RangeP[0 Millimeter,25 Millimeter]|Auto|Automatic,
	PrimaryInjectionFlowRate -> BMGFlowRateP|Automatic,
	SecondaryInjectionFlowRate -> BMGFlowRateP|Automatic,
	TertiaryInjectionFlowRate -> BMGFlowRateP|Automatic,
	QuaternaryInjectionFlowRate -> BMGFlowRateP|Automatic,
	PlateReaderMix -> BooleanP|Automatic,
	PlateReaderMixTime -> RangeP[1 Second,1 Hour]|Automatic|Null,
	PlateReaderMixRate -> RangeP[100 RPM,700 RPM]|Automatic|Null,
	PlateReaderMixMode -> MechanicalShakingP|Automatic|Null,
	ReadDirection -> ReadDirectionP,
	InjectionSampleStorageCondition -> SampleStorageTypeP|Disposal|Null,
	RunTime -> GreaterP[0 Second],
	ReadOrder -> ReadOrderP,
	PlateReaderMixSchedule -> MixingScheduleP|Automatic|Null,
	PrimaryInjectionTime -> GreaterEqualP[0 Second],
	SecondaryInjectionTime -> GreaterEqualP[0 Second],
	TertiaryInjectionTime -> GreaterEqualP[0 Second],
	QuaternaryInjectionTime -> GreaterEqualP[0 Second],
	SpectralScan -> ListableP[FluorescenceScanTypeP|Automatic],
	ExcitationWavelengthRange -> Alternatives[
		Span[RangeP[320 Nanometer,740 Nanometer],RangeP[320 Nanometer,740 Nanometer]],
		Automatic
	],
	EmissionWavelengthRange -> Alternatives[
		Span[RangeP[320 Nanometer,740 Nanometer],RangeP[320 Nanometer,740 Nanometer]],
		Automatic
	],
	ExcitationScanGain -> Alternatives[
		RangeP[0 Percent,95 Percent],
		RangeP[0 Microvolt,4095 Microvolt],
		Automatic
	],
	EmissionScanGain -> Alternatives[
		RangeP[0 Percent,95 Percent],
		RangeP[0 Microvolt,4095 Microvolt],
		Automatic
	],
	AdjustmentEmissionWavelength -> RangeP[320 Nanometer,740 Nanometer]|Automatic,
	AdjustmentExcitationWavelength -> RangeP[320 Nanometer,740 Nanometer]|Automatic,
	IntegrationTime -> RangeP[0.01 Second,100 Second],
	QuantificationWavelength -> ListableP[RangeP[0 Nanometer, 1000 Nanometer]|Automatic],
	QuantifyConcentration -> ListableP[BooleanP|Automatic],
	(* Additional patterns for ExperimentAlphaScreen *)
	PreResolved -> BooleanP,
	AlphaGain -> RangeP[1 Microvolt,4095 Microvolt],
	SettlingTime -> RangeP[0 Second,1 Second],
	ExcitationTime -> RangeP[0.01 Second,1 Second],

	(* Sampling Options for all *)
	SamplingPattern -> PlateReaderSamplingP,
	SamplingDimension -> RangeP[2, 30],
	SamplingDistance -> RangeP[1 Millimeter, 6 Millimeter]
]);

manipulationKeyPatterns[Cover]:=(manipulationKeyPatterns[Cover]=Association[
	Sample -> ListableP[objectSpecificationP],
	Cover -> ListableP[Automatic|ObjectP[{Object[Item,Lid],Model[Item,Lid]}]]
]);

manipulationKeyPatterns[Uncover]:=(manipulationKeyPatterns[Uncover]=Association[
	Sample -> ListableP[objectSpecificationP]
]);




(* ::Subsection:: *)
(*Primitive Installation*)


(* ::Subsubsection::Closed:: *)
(*Primitive Images*)


(* memoize imported image after first reference *)
aliquotImage[]:=aliquotImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","AliquotIcon.png"}]];
mixImage[]:=mixImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","MixIcon.png"}]];
transferImage[]:=transferImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","TransferIcon.png"}]];
consolidationImage[]:=consolidationImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","ConsolidateIcon.png"}]];
filltovolumeImage[]:=filltovolumeImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","FillToVolumeIcon.png"}]];
incubateImage[]:=incubateImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","IncubateIcon.png"}]];
waitImage[]:=waitImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","WaitIcon.png"}]];
defineImage[]:=defineImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","DefineIcon.png"}]];
filterImage[]:=filterImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","FilterIcon.png"}]];
moveToMagnetImage[]:=moveToMagnetImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","MoveToMagnetIcon.png"}]];
removeFromMagnetImage[]:=removeFromMagnetImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","RemoveFromMagnetIcon.png"}]];
centrifugeImage[]:=centrifugeImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","CentrifugeIcon.png"}]];
readPlateImage[]:=centrifugeImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","ReadPlateIcon.png"}]];
pelletImage[]:=pelletImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","CentrifugeIcon.png"}]];
resuspendImage[]:=resuspendImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","ResuspendIcon.png"}]];
coverImage[]:=coverImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","CoverIcon.png"}]];
uncoverImage[]:=uncoverImage[]=Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","CoverIcon.png"}]];

(* TODO - when sending in ReadPlate options convert instrument object to model *)

(* ::Subsubsection::Closed:: *)
(*installSampleManipulationPrimitives*)


formatBoxForm[assoc_, key_, description_]:=With[{value=Lookup[assoc,key,Null]},
	If[NullQ[value],Nothing,BoxForm`SummaryItem[{description<>": ",value}]]
];


installSampleManipulationPrimitives[]:={
	installTransferPrimitive[];,
	installAliquotPrimitive[];,
	installConsolidationPrimitive[];,
	installMixPrimitive[];,
	installIncubatePrimitive[];
	installFillToVolumePrimitive[];
	installWaitPrimitive[];
	installDefinePrimitive[];
	installFilterPrimitive[];
	installMoveToMagnetPrimitive[];
	installRemoveFromMagnetPrimitive[];
	installCentrifugePrimitive[];
	installReadPlatePrimitive[];
	installPelletPrimitive[];
	installResuspendPrimitive[];
	installCoverPrimitive[];
	installUncoverPrimitive[];
};

installSampleManipulationPrimitives[];
Unprotect/@{Aliquot,Consolidation,Transfer,Mix,FillToVolume,Incubate,Wait,Define,Filter,MoveToMagnet,RemoveFromMagnet,Centrifuge,ReadPlate,Pellet,Resuspend,Cover,Uncover};
OverloadSummaryHead/@{Aliquot,Consolidation,Transfer,Mix,FillToVolume,Incubate,Wait,Define,Filter,MoveToMagnet,RemoveFromMagnet,Centrifuge,ReadPlate,Pellet,Resuspend,Cover,Uncover};
Protect/@{Aliquot,Consolidation,Transfer,Mix,FillToVolume,Incubate,Wait,Define,Filter,MoveToMagnet,RemoveFromMagnet,Centrifuge,ReadPlate,Pellet,Resuspend,Cover,Uncover};

(* ensure that reloading the package will re-initialize primitive generation *)
OnLoad[
	installSampleManipulationPrimitives[];
	Unprotect/@{Aliquot,Consolidation,Transfer,Mix,FillToVolume,Incubate,Wait,Define,Filter,MoveToMagnet,RemoveFromMagnet,Centrifuge,ReadPlate,Pellet,Resuspend,Cover,Uncover};
	OverloadSummaryHead/@{Aliquot,Consolidation,Transfer,Mix,FillToVolume,Incubate,Wait,Define,Filter,MoveToMagnet,RemoveFromMagnet,Centrifuge,ReadPlate,Pellet,Resuspend,Cover,Uncover};
	Protect/@{Aliquot,Consolidation,Transfer,Mix,FillToVolume,Incubate,Wait,Define,Filter,MoveToMagnet,RemoveFromMagnet,Centrifuge,ReadPlate,Pellet,Resuspend,Cover,Uncover};
];

(* ::Subsubsection::Closed:: *)
(*Transfer*)


installTransferPrimitive[]:=MakeBoxes[summary:Transfer[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Transfer,
	summary,
	transferImage[],
	{
		If[MatchQ[assoc[Source],_Missing],Nothing,BoxForm`SummaryItem[{"Source: ",Shallow[assoc[Source],{Infinity,20}]}]],
		If[MatchQ[assoc[Destination],_Missing],Nothing,BoxForm`SummaryItem[{"Destination: ",Shallow[assoc[Destination],{Infinity,20}]}]],
		If[MatchQ[assoc[Amount],_Missing],Nothing,BoxForm`SummaryItem[{"Amount: ",Shallow[assoc[Amount],{Infinity,20}]}]],
		If[MatchQ[assoc[Volume],_Missing],Nothing,BoxForm`SummaryItem[{"Amount: ",Shallow[assoc[Volume],{Infinity,20}]}]],
		If[MatchQ[assoc[TipType],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Type: ",Shallow[assoc[TipType],{Infinity,20}]}]],
		If[MatchQ[assoc[TipSize],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Size: ",Shallow[assoc[TipSize],{Infinity,20}]}]],
		If[MatchQ[assoc[PipettingMethod],_Missing],Nothing,BoxForm`SummaryItem[{"PipettingMethod: ",Shallow[assoc[PipettingMethod],{Infinity,20}]}]],
		If[MatchQ[assoc[AspirationClassifications],_Missing],Nothing,BoxForm`SummaryItem[{"Aspiration Classifications: ",Shallow[assoc[AspirationClassifications],{Infinity,20}]}]],
		If[MatchQ[assoc[AspirationClassificationConfidences],_Missing],Nothing,BoxForm`SummaryItem[{"Aspiration Classification Confidences: ",Shallow[assoc[AspirationClassificationConfidences],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[Resuspension],_Missing],Nothing,BoxForm`SummaryItem[{"Resuspension: ",Shallow[assoc[Resuspension],{Infinity,20}]}]],
		If[MatchQ[assoc[TransferType],_Missing],Nothing,BoxForm`SummaryItem[{"TransferType: ",Shallow[assoc[TransferType],{Infinity,20}]}]],
		If[MatchQ[assoc[DeviceChannel],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DeviceChannel: ",Shallow[assoc[DeviceChannel],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationRate: ",Shallow[assoc[AspirationRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseRate: ",Shallow[assoc[DispenseRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[OverAspirationVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"OverAspirationVolume: ",Shallow[assoc[OverAspirationVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[OverDispenseVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"OverDispenseVolume: ",Shallow[assoc[OverDispenseVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationWithdrawalRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationWithdrawalRate: ",Shallow[assoc[AspirationWithdrawalRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseWithdrawalRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseWithdrawalRate: ",Shallow[assoc[DispenseWithdrawalRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationEquilibrationTime],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationEquilibrationTime: ",Shallow[assoc[AspirationEquilibrationTime],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseEquilibrationTime],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseEquilibrationTime: ",Shallow[assoc[DispenseEquilibrationTime],{Infinity,20}]}]
		],
		If[MatchQ[assoc[CorrectionCurve],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"CorrectionCurve: ",Shallow[assoc[CorrectionCurve],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMixRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMixRate: ",Shallow[assoc[AspirationMixRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMixRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMixRate: ",Shallow[assoc[DispenseMixRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMix],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMix: ",Shallow[assoc[AspirationMix],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMix],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMix: ",Shallow[assoc[DispenseMix],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMixVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMixVolume: ",Shallow[assoc[AspirationMixVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMixVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMixVolume: ",Shallow[assoc[DispenseMixVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationNumberOfMixes],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationNumberOfMixes: ",Shallow[assoc[AspirationNumberOfMixes],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseNumberOfMixes],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseNumberOfMixes: ",Shallow[assoc[DispenseNumberOfMixes],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationPosition],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationPosition: ",Shallow[assoc[AspirationPosition],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispensePosition],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispensePosition: ",Shallow[assoc[DispensePosition],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationPositionOffset],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationPositionOffset: ",Shallow[assoc[AspirationPositionOffset],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispensePositionOffset],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispensePositionOffset: ",Shallow[assoc[DispensePositionOffset],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DynamicAspiration],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"Dynamic Aspiration: ",Shallow[assoc[DynamicAspiration],{Infinity,20}]}]
		],
		If[MatchQ[assoc[InWellSeparation],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"InWellSeparation: ",Shallow[assoc[InWellSeparation],{Infinity,20}]}]
		]
	},
	StandardForm
];

(* ::Subsubsection::Closed:: *)
(*Resuspend*)

installResuspendPrimitive[]:=MakeBoxes[summary:Resuspend[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Resuspend,
	summary,
	resuspendImage[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",Shallow[assoc[Sample],{Infinity,20}]}]],
		If[MatchQ[assoc[Volume],_Missing],Nothing,BoxForm`SummaryItem[{"Volume: ",Shallow[assoc[Volume],{Infinity,20}]}]],
		If[MatchQ[assoc[Diluent],_Missing],Nothing,BoxForm`SummaryItem[{"Diluent: ",Shallow[assoc[Diluent], {Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[Mix],_Missing],Nothing,BoxForm`SummaryItem[{"Mix: ",Shallow[assoc[Mix],{Infinity,20}]}]],
		If[MatchQ[assoc[MixType],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Type: ",Shallow[assoc[MixType],{Infinity,20}]}]],
		If[MatchQ[assoc[MixUntilDissolved],_Missing],Nothing,BoxForm`SummaryItem[{"MixUntilDissolved: ",Shallow[assoc[MixUntilDissolved],{Infinity,20}]}]],
		If[MatchQ[assoc[MixVolume],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Volume: ",Shallow[assoc[MixVolume],{Infinity,20}]}]],
		If[MatchQ[assoc[NumberOfMixes],_Missing],Nothing,BoxForm`SummaryItem[{"Number of Mixes: ",Shallow[assoc[NumberOfMixes],{Infinity,20}]}]],
		If[MatchQ[assoc[MaxNumberOfMixes],_Missing],Nothing,BoxForm`SummaryItem[{"Max Number of Mixes: ",Shallow[assoc[MaxNumberOfMixes],{Infinity,20}]}]],
		If[MatchQ[assoc[IncubationTime],_Missing],Nothing,BoxForm`SummaryItem[{"Incubation Time: ",Shallow[assoc[IncubationTime],{Infinity,20}]}]],
		If[MatchQ[assoc[MaxIncubationTime],_Missing],Nothing,BoxForm`SummaryItem[{"MaxIncubation Time: ",Shallow[assoc[MaxIncubationTime],{Infinity,20}]}]],
		If[MatchQ[assoc[IncubationInstrument],_Missing],Nothing,BoxForm`SummaryItem[{"Incubation Instrument: ",Shallow[assoc[IncubationInstrument],{Infinity,20}]}]],
		If[MatchQ[assoc[IncubationTemperature],_Missing],Nothing,BoxForm`SummaryItem[{"Incubation Temperature: ",Shallow[assoc[IncubationTemperature],{Infinity,20}]}]],
		If[MatchQ[assoc[AnnealingTime],_Missing],Nothing,BoxForm`SummaryItem[{"Annealing Time: ",Shallow[assoc[AnnealingTime],{Infinity,20}]}]],
		If[MatchQ[assoc[TipType],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Type: ",Shallow[assoc[TipType],{Infinity,20}]}]],
		If[MatchQ[assoc[TipSize],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Size: ",Shallow[assoc[TipSize],{Infinity,20}]}]],
		If[MatchQ[assoc[PipettingMethod],_Missing],Nothing,BoxForm`SummaryItem[{"PipettingMethod: ",Shallow[assoc[PipettingMethod],{Infinity,20}]}]],
		If[MatchQ[assoc[DeviceChannel],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DeviceChannel: ",Shallow[assoc[DeviceChannel],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationRate: ",Shallow[assoc[AspirationRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseRate: ",Shallow[assoc[DispenseRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[OverAspirationVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"OverAspirationVolume: ",Shallow[assoc[OverAspirationVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[OverDispenseVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"OverDispenseVolume: ",Shallow[assoc[OverDispenseVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationWithdrawalRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationWithdrawalRate: ",Shallow[assoc[AspirationWithdrawalRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseWithdrawalRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseWithdrawalRate: ",Shallow[assoc[DispenseWithdrawalRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationEquilibrationTime],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationEquilibrationTime: ",Shallow[assoc[AspirationEquilibrationTime],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseEquilibrationTime],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseEquilibrationTime: ",Shallow[assoc[DispenseEquilibrationTime],{Infinity,20}]}]
		],
		If[MatchQ[assoc[CorrectionCurve],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"CorrectionCurve: ",Shallow[assoc[CorrectionCurve],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMixRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMixRate: ",Shallow[assoc[AspirationMixRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMixRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMixRate: ",Shallow[assoc[DispenseMixRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMix],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMix: ",Shallow[assoc[AspirationMix],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMix],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMix: ",Shallow[assoc[DispenseMix],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMixVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMixVolume: ",Shallow[assoc[AspirationMixVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMixVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMixVolume: ",Shallow[assoc[DispenseMixVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationNumberOfMixes],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationNumberOfMixes: ",Shallow[assoc[AspirationNumberOfMixes],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseNumberOfMixes],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseNumberOfMixes: ",Shallow[assoc[DispenseNumberOfMixes],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationPosition],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationPosition: ",Shallow[assoc[AspirationPosition],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispensePosition],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispensePosition: ",Shallow[assoc[DispensePosition],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationPositionOffset],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationPositionOffset: ",Shallow[assoc[AspirationPositionOffset],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispensePositionOffset],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispensePositionOffset: ",Shallow[assoc[DispensePositionOffset],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DynamicAspiration],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"Dynamic Aspiration: ",Shallow[assoc[DynamicAspiration],{Infinity,20}]}]
		]
	},
	StandardForm
];

(* ::Subsubsection::Closed:: *)
(*Aliquot*)



installAliquotPrimitive[]:=MakeBoxes[summary:Aliquot[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Aliquot,
	summary,
	aliquotImage[],
	{
		If[MatchQ[assoc[Source],_Missing],Nothing,BoxForm`SummaryItem[{"Source: ",Shallow[assoc[Source],{Infinity,20}]}]],
		If[MatchQ[assoc[Destinations],_Missing],Nothing,BoxForm`SummaryItem[{"Destinations: ",Shallow[assoc[Destinations],{Infinity,20}]}]],
		If[MatchQ[assoc[Amounts],_Missing],Nothing,BoxForm`SummaryItem[{"Amounts: ",Shallow[assoc[Amounts],{Infinity,20}]}]],
		If[MatchQ[assoc[Volumes],_Missing],Nothing,BoxForm`SummaryItem[{"Amounts: ",Shallow[assoc[Volumes],{Infinity,20}]}]],
		If[MatchQ[assoc[TipType],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Type: ",Shallow[assoc[TipType],{Infinity,20}]}]],
		If[MatchQ[assoc[TipSize],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Size: ",Shallow[assoc[TipSize],{Infinity,20}]}]],
		If[MatchQ[assoc[PipettingMethod],_Missing],Nothing,BoxForm`SummaryItem[{"PipettingMethod: ",Shallow[assoc[PipettingMethod],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[TransferType],_Missing],Nothing,BoxForm`SummaryItem[{"TransferType: ",Shallow[assoc[TransferType],{Infinity,20}]}]],
		If[MatchQ[assoc[AspirationRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationRate: ",Shallow[assoc[AspirationRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseRate: ",Shallow[assoc[DispenseRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[OverAspirationVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"OverAspirationVolume: ",Shallow[assoc[OverAspirationVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[OverDispenseVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"OverDispenseVolume: ",Shallow[assoc[OverDispenseVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationWithdrawalRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationWithdrawalRate: ",Shallow[assoc[AspirationWithdrawalRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseWithdrawalRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseWithdrawalRate: ",Shallow[assoc[DispenseWithdrawalRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationEquilibrationTime],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationEquilibrationTime: ",Shallow[assoc[AspirationEquilibrationTime],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseEquilibrationTime],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseEquilibrationTime: ",Shallow[assoc[DispenseEquilibrationTime],{Infinity,20}]}]
		],
		If[MatchQ[assoc[CorrectionCurve],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"CorrectionCurve: ",Shallow[assoc[CorrectionCurve],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMixRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMixRate: ",Shallow[assoc[AspirationMixRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMixRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMixRate: ",Shallow[assoc[DispenseMixRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMix],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMix: ",Shallow[assoc[AspirationMix],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMix],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMix: ",Shallow[assoc[DispenseMix],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMixVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMixVolume: ",Shallow[assoc[AspirationMixVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMixVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMixVolume: ",Shallow[assoc[DispenseMixVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationNumberOfMixes],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationNumberOfMixes: ",Shallow[assoc[AspirationNumberOfMixes],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseNumberOfMixes],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseNumberOfMixes: ",Shallow[assoc[DispenseNumberOfMixes],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationPosition],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationPosition: ",Shallow[assoc[AspirationPosition],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispensePosition],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispensePosition: ",Shallow[assoc[DispensePosition],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationPositionOffset],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationPositionOffset: ",Shallow[assoc[AspirationPositionOffset],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispensePositionOffset],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispensePositionOffset: ",Shallow[assoc[DispensePositionOffset],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DynamicAspiration],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"Dynamic Aspiration: ",Shallow[assoc[DynamicAspiration],{Infinity,20}]}]
		],
		If[MatchQ[assoc[InWellSeparation],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"InWellSeparation: ",Shallow[assoc[InWellSeparation],{Infinity,20}]}]
		]
	},
	StandardForm
];


(* ::Subsubsection::Closed:: *)
(*Consolidation*)


installConsolidationPrimitive[]:=MakeBoxes[summary:Consolidation[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Consolidation,
	summary,
	consolidationImage[],
	{
		If[MatchQ[assoc[Destination],_Missing],Nothing,BoxForm`SummaryItem[{"Destination: ",Shallow[assoc[Destination],{Infinity,20}]}]],
		If[MatchQ[assoc[Sources],_Missing],Nothing,BoxForm`SummaryItem[{"Sources: ",Shallow[assoc[Sources],{Infinity,20}]}]],
		If[MatchQ[assoc[Amounts],_Missing],Nothing,BoxForm`SummaryItem[{"Amounts: ",Shallow[assoc[Amounts],{Infinity,20}]}]],
		If[MatchQ[assoc[Volumes],_Missing],Nothing,BoxForm`SummaryItem[{"Amounts: ",Shallow[assoc[Volumes],{Infinity,20}]}]],
		If[MatchQ[assoc[TipType],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Type: ",Shallow[assoc[TipType],{Infinity,20}]}]],
		If[MatchQ[assoc[TipSize],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Size: ",Shallow[assoc[TipSize],{Infinity,20}]}]],
		If[MatchQ[assoc[PipettingMethod],_Missing],Nothing,BoxForm`SummaryItem[{"PipettingMethod: ",Shallow[assoc[PipettingMethod],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[TransferType],_Missing],Nothing,BoxForm`SummaryItem[{"TransferType: ",Shallow[assoc[TransferType],{Infinity,20}]}]],
		If[MatchQ[assoc[AspirationRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationRate: ",Shallow[assoc[AspirationRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseRate: ",Shallow[assoc[DispenseRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[OverAspirationVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"OverAspirationVolume: ",Shallow[assoc[OverAspirationVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[OverDispenseVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"OverDispenseVolume: ",Shallow[assoc[OverDispenseVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationWithdrawalRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationWithdrawalRate: ",Shallow[assoc[AspirationWithdrawalRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseWithdrawalRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseWithdrawalRate: ",Shallow[assoc[DispenseWithdrawalRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationEquilibrationTime],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationEquilibrationTime: ",Shallow[assoc[AspirationEquilibrationTime],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseEquilibrationTime],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseEquilibrationTime: ",Shallow[assoc[DispenseEquilibrationTime],{Infinity,20}]}]
		],
		If[MatchQ[assoc[CorrectionCurve],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"CorrectionCurve: ",Shallow[assoc[CorrectionCurve],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMixRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMixRate: ",Shallow[assoc[AspirationMixRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMixRate],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMixRate: ",Shallow[assoc[DispenseMixRate],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMix],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMix: ",Shallow[assoc[AspirationMix],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMix],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMix: ",Shallow[assoc[DispenseMix],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationMixVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationMixVolume: ",Shallow[assoc[AspirationMixVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseMixVolume],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseMixVolume: ",Shallow[assoc[DispenseMixVolume],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationNumberOfMixes],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationNumberOfMixes: ",Shallow[assoc[AspirationNumberOfMixes],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispenseNumberOfMixes],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispenseNumberOfMixes: ",Shallow[assoc[DispenseNumberOfMixes],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationPosition],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationPosition: ",Shallow[assoc[AspirationPosition],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispensePosition],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispensePosition: ",Shallow[assoc[DispensePosition],{Infinity,20}]}]
		],
		If[MatchQ[assoc[AspirationPositionOffset],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"AspirationPositionOffset: ",Shallow[assoc[AspirationPositionOffset],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DispensePositionOffset],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"DispensePositionOffset: ",Shallow[assoc[DispensePositionOffset],{Infinity,20}]}]
		],
		If[MatchQ[assoc[DynamicAspiration],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"Dynamic Aspiration: ",Shallow[assoc[DynamicAspiration],{Infinity,20}]}]
		],
		If[MatchQ[assoc[InWellSeparation],_Missing],
			Nothing,
			BoxForm`SummaryItem[{"InWellSeparation: ",Shallow[assoc[InWellSeparation],{Infinity,20}]}]
		]
	},
	StandardForm
];


(* ::Subsubsection::Closed:: *)
(*Mix*)



installMixPrimitive[]:=MakeBoxes[summary:Mix[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Mix,
	summary,
	mixImage[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",Shallow[assoc[Sample],{Infinity,20}]}]],
		If[MatchQ[assoc[MixType],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Type: ",Shallow[assoc[MixType],{Infinity,20}]}]],
		If[MatchQ[assoc[Time],_Missing],Nothing,BoxForm`SummaryItem[{"Time: ",Shallow[assoc[Time],{Infinity,20}]}]],
		If[MatchQ[assoc[MixRate],_Missing],Nothing,BoxForm`SummaryItem[{"Rate: ",Shallow[assoc[MixRate],{Infinity,20}]}]],
		If[MatchQ[assoc[NumberOfMixes],_Missing],Nothing,BoxForm`SummaryItem[{"Number of Mixes: ",Shallow[assoc[NumberOfMixes],{Infinity,20}]}]],
		If[MatchQ[assoc[TipType],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Type: ",Shallow[assoc[TipType],{Infinity,20}]}]],
		If[MatchQ[assoc[TipSize],_Missing],Nothing,BoxForm`SummaryItem[{"Tip Size: ",Shallow[assoc[TipSize],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[MixVolume],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Volume: ",Shallow[assoc[MixVolume],{Infinity,20}]}]],
		If[MatchQ[assoc[MixFlowRate],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Flow Rate: ",Shallow[assoc[MixFlowRate],{Infinity,20}]}]],
		If[MatchQ[assoc[MixPosition],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Position: ",Shallow[assoc[MixPosition],{Infinity,20}]}]],
		If[MatchQ[assoc[MixPositionOffset],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Position Offset: ",Shallow[assoc[MixPositionOffset],{Infinity,20}]}]],
		If[MatchQ[assoc[CorrectionCurve],_Missing],Nothing,BoxForm`SummaryItem[{"Correction Curve: ",Shallow[assoc[CorrectionCurve],{Infinity,20}]}]]
	},
	StandardForm
];

(* TEMPORARY OVERLOAD to convert legacy keys to renamed keys *)
Unprotect[Mix];
Mix[assoc_Association]:=((Mix@KeyDrop[
	Prepend[
		assoc,
		{
			If[KeyExistsQ[assoc,Source],
				Sample -> Lookup[assoc,Source],
				Nothing
			],
			If[KeyExistsQ[assoc,MixCount],
				NumberOfMixes -> Lookup[assoc,MixCount],
				Nothing
			],
			If[KeyExistsQ[assoc,MixTime],
				Time -> Lookup[assoc,MixTime],
				Nothing
			]
		}
	],
	{Source,MixCount,MixTime}
])/;Or[KeyExistsQ[assoc,Source],KeyExistsQ[assoc,MixCount],KeyExistsQ[assoc,MixTime]]);
Protect[Mix];



(* ::Subsubsection::Closed:: *)
(*FillToVolume*)


installFillToVolumePrimitive[]:=MakeBoxes[summary:FillToVolume[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	FillToVolume,
	summary,
	filltovolumeImage[],
	{
		If[MatchQ[assoc[Source],_Missing],Nothing,BoxForm`SummaryItem[{"Source: ",Shallow[assoc[Source],{Infinity,20}]}]],
		Switch[assoc[Destination],
			(* If Destination is just a sample, display that information *)
			(ObjectP[]|_String|PlateAndWellP),
				BoxForm`SummaryItem[{"Destination: ",Shallow[assoc[Destination],{Infinity,20}]}],
			(* If Destination is a unique but unspecified modelContainer, display that information *)
			{_,ObjectP[Model[Container]]},
				Unevaluated[Sequence[
					BoxForm`SummaryItem[{"Destination Container: ",Shallow[assoc[Destination],{Infinity,20}][[1]]}],
					BoxForm`SummaryItem[{"Destination Container Model: ",Shallow[assoc[Destination],{Infinity,20}][[2]]}]
				]],
			_,Nothing
		],
		If[MatchQ[assoc[FinalVolume],_Missing],Nothing,BoxForm`SummaryItem[{"FinalVolume: ",Shallow[assoc[FinalVolume],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[TransferType],_Missing],Nothing,BoxForm`SummaryItem[{"TransferType: ",Shallow[assoc[TransferType],{Infinity,20}]}]],
		If[MatchQ[assoc[Method],_Missing],Nothing,BoxForm`SummaryItem[{"Method: ",Shallow[assoc[Method],{Infinity,20}]}]]
	},
	StandardForm
];



(* ::Subsubsection::Closed:: *)
(*Incubate*)


installIncubatePrimitive[]:=MakeBoxes[summary:Incubate[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Incubate,
	summary,
	incubateImage[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",Shallow[assoc[Sample],{Infinity,20}]}]],
		If[MatchQ[assoc[Temperature],_Missing],Nothing,BoxForm`SummaryItem[{"Temperature: ",Shallow[assoc[Temperature],{Infinity,20}]}]],
		If[MatchQ[assoc[Time],_Missing],Nothing,BoxForm`SummaryItem[{"Time: ",Shallow[assoc[Time],{Infinity,20}]}]],
		If[MatchQ[assoc[MixRate],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Rate: ",Shallow[assoc[MixRate],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[Mix],_Missing],Nothing,BoxForm`SummaryItem[{"Mix: ",Shallow[assoc[Mix],{Infinity,20}]}]],
		If[MatchQ[assoc[Preheat],_Missing],Nothing,BoxForm`SummaryItem[{"Preheat: ",Shallow[assoc[Preheat],{Infinity,20}]}]],
		If[MatchQ[assoc[ResidualIncubation],_Missing],Nothing,BoxForm`SummaryItem[{"Residual Incubation: ",Shallow[assoc[ResidualIncubation],{Infinity,20}]}]],
		If[MatchQ[assoc[ResidualTemperature],_Missing],Nothing,BoxForm`SummaryItem[{"Residual Temperature: ",Shallow[assoc[ResidualTemperature],{Infinity,20}]}]],
		If[MatchQ[assoc[ResidualMix],_Missing],Nothing,BoxForm`SummaryItem[{"Residual Mix: ",Shallow[assoc[ResidualMix],{Infinity,20}]}]],
		If[MatchQ[assoc[ResidualMixRate],_Missing],Nothing,BoxForm`SummaryItem[{"Residual MixRate: ",Shallow[assoc[ResidualMixRate],{Infinity,20}]}]],
		If[MatchQ[assoc[MixType],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Type: ",Shallow[assoc[MixType],{Infinity,20}]}]],
		If[MatchQ[assoc[Instrument],_Missing],Nothing,BoxForm`SummaryItem[{"Instrument: ",Shallow[assoc[Instrument],{Infinity,20}]}]],
		If[MatchQ[assoc[NumberOfMixes],_Missing],Nothing,BoxForm`SummaryItem[{"Number Of Mixes: ",Shallow[assoc[NumberOfMixes],{Infinity,20}]}]],
		If[MatchQ[assoc[MixVolume],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Volume: ",Shallow[assoc[MixVolume],{Infinity,20}]}]],
		If[MatchQ[assoc[MixUntilDissolved],_Missing],Nothing,BoxForm`SummaryItem[{"Mix Until Dissolved: ",Shallow[assoc[MixUntilDissolved],{Infinity,20}]}]],
		If[MatchQ[assoc[MaxNumberOfMixes],_Missing],Nothing,BoxForm`SummaryItem[{"Max Number Of Mixes: ",Shallow[assoc[MaxNumberOfMixes],{Infinity,20}]}]],
		If[MatchQ[assoc[MaxTime],_Missing],Nothing,BoxForm`SummaryItem[{"Max Time: ",Shallow[assoc[MaxTime],{Infinity,20}]}]],
		If[MatchQ[assoc[AnnealingTime],_Missing],Nothing,BoxForm`SummaryItem[{"Annealing Time: ",Shallow[assoc[AnnealingTime],{Infinity,20}]}]]
	},
	StandardForm
];



(* ::Subsubsection::Closed:: *)
(*Wait*)


installWaitPrimitive[]:=MakeBoxes[summary:Wait[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Wait,
	summary,
	waitImage[],
	{
		If[MatchQ[assoc[Duration],_Missing],Nothing,BoxForm`SummaryItem[{"Duration: ",assoc[Duration]}]]
	},
	{},
	StandardForm
];



(* ::Subsubsection::Closed:: *)
(*Define*)



installDefinePrimitive[]:=MakeBoxes[summary:Define[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Define,
	summary,
	defineImage[],
	{
		If[MatchQ[assoc[Name],_Missing],Nothing,BoxForm`SummaryItem[{"Name: ",assoc[Name]}]],
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",assoc[Sample]}]],
		If[MatchQ[assoc[ContainerName],_Missing],Nothing,BoxForm`SummaryItem[{"ContainerName: ",assoc[ContainerName]}]],
		If[MatchQ[assoc[Container],_Missing],Nothing,BoxForm`SummaryItem[{"Container: ",assoc[Container]}]],
		If[MatchQ[assoc[Well],_Missing],Nothing,BoxForm`SummaryItem[{"Well: ",assoc[Well]}]]
	},
	{
		If[MatchQ[assoc[Model],_Missing],Nothing,BoxForm`SummaryItem[{"Model: ",assoc[Model]}]],
		If[MatchQ[assoc[StorageCondition],_Missing],Nothing,BoxForm`SummaryItem[{"StorageCondition: ",assoc[StorageCondition]}]],
		If[MatchQ[assoc[ExpirationDate],_Missing],Nothing,BoxForm`SummaryItem[{"ExpirationDate: ",assoc[ExpirationDate]}]],
		If[MatchQ[assoc[TransportTemperature],_Missing],Nothing,BoxForm`SummaryItem[{"TransportTemperature: ",assoc[TransportTemperature]}]],
		If[MatchQ[assoc[SamplesOut],_Missing],Nothing,BoxForm`SummaryItem[{"SamplesOut: ",assoc[SamplesOut]}]],
		If[MatchQ[assoc[ModelType],_Missing],Nothing,BoxForm`SummaryItem[{"ModelType: ",assoc[ModelType]}]],
		If[MatchQ[assoc[ModelName],_Missing],Nothing,BoxForm`SummaryItem[{"ModelName: ",assoc[ModelName]}]],
		If[MatchQ[assoc[State],_Missing],Nothing,BoxForm`SummaryItem[{"State: ",assoc[State]}]],
		If[MatchQ[assoc[Expires],_Missing],Nothing,BoxForm`SummaryItem[{"Expires: ",assoc[Expires]}]],
		If[MatchQ[assoc[ShelfLife],_Missing],Nothing,BoxForm`SummaryItem[{"ShelfLife: ",assoc[ShelfLife]}]],
		If[MatchQ[assoc[UnsealedShelfLife],_Missing],Nothing,BoxForm`SummaryItem[{"UnsealedShelfLife: ",assoc[UnsealedShelfLife]}]],
		If[MatchQ[assoc[DefaultStorageCondition],_Missing],Nothing,BoxForm`SummaryItem[{"DefaultStorageCondition: ",assoc[DefaultStorageCondition]}]],
		If[MatchQ[assoc[DefaultTransportTemperature],_Missing],Nothing,BoxForm`SummaryItem[{"DefaultTransportTemperature: ",assoc[DefaultTransportTemperature]}]]
	},
	StandardForm
];


(* ::Subsubsection::Closed:: *)
(*Filter*)


installFilterPrimitive[]:=MakeBoxes[summary:Filter[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Filter,
	summary,
	filterImage[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",Shallow[assoc[Sample],{Infinity,20}]}]],
		If[MatchQ[assoc[Pressure],_Missing],Nothing,BoxForm`SummaryItem[{"Pressure: ",Shallow[assoc[Pressure],{Infinity,20}]}]],
		If[MatchQ[assoc[Time],_Missing],Nothing,BoxForm`SummaryItem[{"Time: ",Shallow[assoc[Time],{Infinity,20}]}]],
		If[MatchQ[assoc[FiltrationType],_Missing],Nothing,BoxForm`SummaryItem[{"Filtration Type: ",Shallow[assoc[FiltrationType],{Infinity,20}]}]],
		If[MatchQ[assoc[Filter],_Missing],Nothing,BoxForm`SummaryItem[{"Filter: ",Shallow[assoc[Filter],{Infinity,20}]}]],
		If[MatchQ[assoc[FilterStorageCondition],_Missing],Nothing,BoxForm`SummaryItem[{"Filter Storage Condition: ",Shallow[assoc[FilterStorageCondition],{Infinity,20}]}]],
		If[MatchQ[assoc[MembraneMaterial],_Missing],Nothing,BoxForm`SummaryItem[{"Membrane Material: ",Shallow[assoc[MembraneMaterial],{Infinity,20}]}]],
		If[MatchQ[assoc[PoreSize],_Missing],Nothing,BoxForm`SummaryItem[{"Pore Size: ",Shallow[assoc[PoreSize],{Infinity,20}]}]],
		If[MatchQ[assoc[Temperature],_Missing],Nothing,BoxForm`SummaryItem[{"Temperature: ",Shallow[assoc[Temperature],{Infinity,20}]}]],
		If[MatchQ[assoc[Intensity],_Missing],Nothing,BoxForm`SummaryItem[{"Intensity: ",Shallow[assoc[Intensity],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[CollectionContainer],_Missing],Nothing,BoxForm`SummaryItem[{"Collection Container: ",Shallow[assoc[CollectionContainer],{Infinity,20}]}]],
		If[MatchQ[assoc[Instrument],_Missing],Nothing,BoxForm`SummaryItem[{"Instrument: ",Shallow[assoc[Instrument],{Infinity,20}]}]],
		If[MatchQ[assoc[FilterHousing],_Missing],Nothing,BoxForm`SummaryItem[{"Filter Housing: ",Shallow[assoc[FilterHousing],{Infinity,20}]}]],
		If[MatchQ[assoc[Syringe],_Missing],Nothing,BoxForm`SummaryItem[{"Syringe: ",Shallow[assoc[Syringe],{Infinity,20}]}]],
		If[MatchQ[assoc[PrefilterMembraneMaterial],_Missing],Nothing,BoxForm`SummaryItem[{"Prefilter Membrane Material: ",Shallow[assoc[PrefilterMembraneMaterial],{Infinity,20}]}]],
		If[MatchQ[assoc[PrefilterPoreSize],_Missing],Nothing,BoxForm`SummaryItem[{"Prefilter Pore Size: ",Shallow[assoc[PrefilterPoreSize],{Infinity,20}]}]],
		If[MatchQ[assoc[MolecularWeightCutoff],_Missing],Nothing,BoxForm`SummaryItem[{"Molecular Weight Cutoff: ",Shallow[assoc[MolecularWeightCutoff],{Infinity,20}]}]],
		If[MatchQ[assoc[Sterile],_Missing],Nothing,BoxForm`SummaryItem[{"Sterile: ",Shallow[assoc[Sterile],{Infinity,20}]}]]
	},
	StandardForm
];



(* ::Subsubsection::Closed:: *)
(*MoveToMagnet*)


installMoveToMagnetPrimitive[]:=MakeBoxes[summary:MoveToMagnet[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	MoveToMagnet,
	summary,
	moveToMagnetImage[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",assoc[Sample]}]]
	},
	{},
	StandardForm
];



(* ::Subsubsection::Closed:: *)
(*RemoveFromMagnet*)


installRemoveFromMagnetPrimitive[]:=MakeBoxes[summary:RemoveFromMagnet[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	RemoveFromMagnet,
	summary,
	removeFromMagnetImage[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",assoc[Sample]}]]
	},
	{},
	StandardForm
];



(* ::Subsubsection::Closed:: *)
(*Centrifuge*)


installCentrifugePrimitive[]:=MakeBoxes[summary:Centrifuge[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Centrifuge,
	summary,
	centrifugeImage[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",Shallow[assoc[Sample],{Infinity,20}]}]],
		If[MatchQ[assoc[Time],_Missing],Nothing,BoxForm`SummaryItem[{"Time: ",Shallow[assoc[Time],{Infinity,20}]}]],
		If[MatchQ[assoc[Intensity],_Missing],Nothing,BoxForm`SummaryItem[{"Intensity: ",Shallow[assoc[Intensity],{Infinity,20}]}]]
	},
	{
		If[MatchQ[assoc[Instrument],_Missing],Nothing,BoxForm`SummaryItem[{"Instrument: ",Shallow[assoc[Instrument],{Infinity,20}]}]],
		If[MatchQ[assoc[Temperature],_Missing],Nothing,BoxForm`SummaryItem[{"Temperature: ",Shallow[assoc[Temperature],{Infinity,20}]}]]
	},
	StandardForm
];


(* ::Subsubsection::Closed:: *)
(*ReadPlate*)


installReadPlatePrimitive[]:=MakeBoxes[summary:ReadPlate[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	ReadPlate,
	summary,
	readPlateImage[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",Shallow[assoc[Sample],{Infinity,20}]}]],
		If[MatchQ[assoc[Type],_Missing],Nothing,BoxForm`SummaryItem[{"Type: ",assoc[Type]}]],
		If[MatchQ[assoc[Data],_Missing],Nothing,BoxForm`SummaryItem[{"Data: ",assoc[Data]}]],
		If[MatchQ[assoc[BlankData],_Missing|{}],Nothing,BoxForm`SummaryItem[{"Blank Data: ",assoc[BlankData]}]]
	},
	{
		If[MatchQ[assoc[Blank],_Missing|{}],Nothing,BoxForm`SummaryItem[{"Blank: ",assoc[Blank]}]],
		If[MatchQ[assoc[Wavelength],_Missing],Nothing,BoxForm`SummaryItem[{"Wavelength: ",assoc[Wavelength]}]],
		If[MatchQ[assoc[ExcitationWavelength],_Missing],Nothing,BoxForm`SummaryItem[{"Excitation Wavelength: ",assoc[ExcitationWavelength]}]],
		If[MatchQ[assoc[EmissionWavelength],_Missing],Nothing,BoxForm`SummaryItem[{"Emission Wavelength: ",assoc[EmissionWavelength]}]],

		If[MatchQ[assoc[RunTime],_Missing],Nothing,BoxForm`SummaryItem[{"RunTime: ",assoc[RunTime]}]],
		If[MatchQ[assoc[Temperature],_Missing],Nothing,BoxForm`SummaryItem[{"Temperature: ",assoc[Temperature]}]],
		If[MatchQ[assoc[PlateReaderMix],_Missing],Nothing,BoxForm`SummaryItem[{"Plate Reader Mixing: ",assoc[PlateReaderMix]}]],
		If[MatchQ[assoc[NumberOfReadings],_Missing],Nothing,BoxForm`SummaryItem[{"Number Of Readings: ",assoc[NumberOfReadings]}]],

		If[MatchQ[assoc[Temperature],_Missing],Nothing,BoxForm`SummaryItem[{"Temperature: ",assoc[Temperature]}]],
		If[MatchQ[assoc[EquilibrationTime],_Missing],Nothing,BoxForm`SummaryItem[{"EquilibrationTime: ",assoc[EquilibrationTime]}]],

		If[MatchQ[assoc[SamplingPattern],_Missing|Null],Nothing,BoxForm`SummaryItem[{"SamplingPattern: ",assoc[SamplingPattern]}]],
		If[MatchQ[assoc[SamplingDistance],_Missing|Null],Nothing,BoxForm`SummaryItem[{"SamplingDistance: ",assoc[SamplingDistance]}]],
		If[MatchQ[assoc[SamplingDimension],_Missing|Null],Nothing,BoxForm`SummaryItem[{"SamplingDimension: ",assoc[SamplingDimension]}]]
	},
	StandardForm
];


(* ::Subsubsection::Closed:: *)
(*Pellet*)


installPelletPrimitive[]:=MakeBoxes[summary:Pellet[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Pellet,
	summary,
	pelletImage[],
	(
		If[MatchQ[assoc[#],_Missing],Nothing,BoxForm`SummaryItem[{ToString[#]<>": ",Shallow[assoc[#],{Infinity,20}]}]]
	&)/@{Sample, Time, Intensity, SupernatantVolume},
	(
		If[MatchQ[assoc[#],_Missing],Nothing,BoxForm`SummaryItem[{ToString[#]<>": ",Shallow[assoc[#],{Infinity,20}]}]]
	&)/@{
		Instrument, Temperature, SupernatantVolume, SupernatantDestination,
		SupernatantTransferInstrument, ResuspensionSource,
		ResuspensionVolume, ResuspensionInstrument, ResuspensionMix,
		ResuspensionMixType, ResuspensionMixUntilDissolved,
		ResuspensionMixInstrument, ResuspensionMixTime,
		ResuspensionMixMaxTime, ResuspensionMixDutyCycle,
		ResuspensionMixRate, ResuspensionNumberOfMixes,
		ResuspensionMaxNumberOfMixes, ResuspensionMixVolume,
		ResuspensionMixTemperature, ResuspensionMixMaxTemperature,
		ResuspensionMixAmplitude
	},
	StandardForm
];



(* ::Subsubsection::Closed:: *)
(*Cover*)



installCoverPrimitive[]:=MakeBoxes[summary:Cover[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Cover,
	summary,
	coverImage[],
	{
		If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",assoc[Sample]}]],
		If[MatchQ[assoc[Cover],_Missing],Nothing,BoxForm`SummaryItem[{"Cover: ",assoc[Cover]}]]
	},
	{},
	StandardForm
];


(* ::Subsubsection::Closed:: *)
(*Uncover*)



installUncoverPrimitive[]:=MakeBoxes[summary:Uncover[assoc_Association],StandardForm]:=BoxForm`ArrangeSummaryBox[
	Uncover,
	summary,
	uncoverImage[],
	{If[MatchQ[assoc[Sample],_Missing],Nothing,BoxForm`SummaryItem[{"Sample: ",assoc[Sample]}]]},
	{},
	StandardForm
];







(* ::Subsection:: *)
(*storageConditionTemperatureLookup*)


(* Hard-code a priority lookup for storage condition objects by temperature *)
(* not a great solution, Cam is sorry, did not want to get into a fuller refactor of this during SC object transition *)
storageConditionTemperatureLookup=<|
	Model[StorageCondition,"id:BYDOjvGNDpvm"]->37 Celsius,(*Mammalian Incubation*)
	Model[StorageCondition,"id:mnk9jORxkYOO"]->37 Celsius,(*Bacterial Incubation*)
	Model[StorageCondition,"id:O81aEBZ3KMvp"]->40 Celsius,(*"Environmental Chamber, Accelerated Testing"*)
	Model[StorageCondition,"id:9RdZXv1WdGvZ"]->30 Celsius,(*"Yeast Incubation"*)
	Model[StorageCondition,"id:GmzlKjPoJMNk"]->30 Celsius,(*"Environmental Chamber, Intermediate Testing"*)
	Model[StorageCondition,"id:AEqRl9KXBMx5"]->25 Celsius,(*"Environmental Chamber, Long Term Testing"*)
	Model[StorageCondition,"id:o1k9jAG5NBoG"]->25 Celsius,(*"Environmental Chamber, UV-Vis Photostability Testing"*)
	Model[StorageCondition,"id:7X104vnR18vX"]->22 Celsius,(*"Ambient Storage"*)
	Model[StorageCondition,"id:vXl9j57YrPlN"]->22 Celsius,(*"Ambient Storage, Flammable"*)
	Model[StorageCondition,"id:BYDOjvGNn6Dm"]->22 Celsius,(*"Ambient Storage, Flammable Acid"*)
	Model[StorageCondition,"id:M8n3rx0lR6nM"]->22 Celsius,(*"Ambient Storage, Flammable Base"*)
	Model[StorageCondition,"id:WNa4ZjKvkVaL"]->22 Celsius,(*"Ambient Storage, Acid"*)
	Model[StorageCondition,"id:54n6evLEOmn7"]->22 Celsius,(*"Ambient Storage, Base"*)
	Model[StorageCondition,"id:bq9LA0JdKXW6"]->22 Celsius,(*"Ambient Storage, Desiccated"*)
	Model[StorageCondition,"id:01G6nvwkxl84"]->22 Celsius,(*"Ambient Storage, Desiccated Under Vacuum"*)
	Model[StorageCondition,"id:N80DNj1r04jW"]->4 Celsius,(*"Refrigerator"*)
	Model[StorageCondition,"id:dORYzZJVX3RE"]->4 Celsius,(*"Refrigerator, Flammable"*)
	Model[StorageCondition,"id:Vrbp1jKDY4bm"]->4 Celsius,(*"Refrigerator, Flammable Acid"*)
	Model[StorageCondition,"id:mnk9jOJKBm1m"]->4 Celsius,(*"Refrigerator, Flammable Base"*)
	Model[StorageCondition,"id:XnlV5jKzPXlb"]->4 Celsius,(*"Refrigerator, Base"*)
	Model[StorageCondition,"id:qdkmxzqoPakV"]->4 Celsius,(*"Refrigerator, Acid"*)
	Model[StorageCondition,"id:O81aEBZ5Gnvx"]->4 Celsius,(*"Refrigerator, Flammable Pyrophoric"*)
	Model[StorageCondition,"id:3em6ZvL9x4Zv"]->4 Celsius,(*"Refrigerator, Desiccated"*)
	Model[StorageCondition,"id:vXl9j57YlZ5N"]->-20 Celsius,(*"Freezer"*)
	Model[StorageCondition,"id:jLq9jXqwBdl6"]->4 Celsius,(*"Crystal Incubation"*)
	Model[StorageCondition,"id:n0k9mG8Bv96n"]->-20 Celsius,(*"Freezer, Flammable"*)
	Model[StorageCondition,"id:xRO9n3BVOe3z"]->-80 Celsius,(*"Deep Freezer"*)
	Model[StorageCondition,"id:6V0npvmE09vG"]->-165 Celsius,(*"Cryogenic Storage"*)
	Model[StorageCondition, "id:o1k9jAG98ZL4"]->37 Celsius,(*"Bacterial Incubation with Shaking"*)
	Model[StorageCondition, "id:lYq9jRx9anbV"]->30 Celsius(*"Yeast Incubation with Shaking"*)
|>;

(* ::Subsection::Closed:: *)
(*tipsReachContainerBottomQ*)


(*
	This function takes in a device (a serological tip or a pipette) being used, a model container into which the device is being inserted and a list of packets of all possible tips
	This functions returns whether the specified this manipulation is possible with the device and tips provided
*)
tipsReachContainerBottomQ[
	myTips:ObjectReferenceP[Model[Item,Tips]],
	myContainerModelPacket:PacketP[Model[Container]],
	myTipPackets:{PacketP[Model[Item,Tips]]..}
]:=Module[
	{tipPacket,sourceAperture,sourceDepth,aspirationDepthsAtApertures,aspirationDepthAtClosestAperture,
		maxDepthTipsCanReach,sortedAspirationDepthsAtApertures},

	(* get the packet of the tips we're using; pull AspirationDepth out of that *)
	tipPacket=SelectFirst[myTipPackets,MatchQ[Lookup[#,Object],Download[myTips,Object]]&];
	aspirationDepthsAtApertures=Lookup[tipPacket,AspirationDepth];

	(* TODO handle other container model types *)
	{sourceAperture,sourceDepth}=Switch[myContainerModelPacket,
		PacketP[{Model[Container,Vessel],Model[Container,Cuvette]}],Lookup[myContainerModelPacket,{Aperture,InternalDepth}],
		(* MALDI Plate position is very small but it does not have a well and tips do not need to go to the "bottom" of the plate since the liquid is just touching the surface *)
		PacketP[{Model[Container,Plate,MALDI]}],{
			Min[DeleteCases[Flatten@Lookup[myContainerModelPacket,{WellDimensions,WellDiameter}],Null]],
			0Meter
		},
		PacketP[Model[Container,Plate,Irregular]],{
			Min[DeleteCases[Flatten@Lookup[myContainerModelPacket,{WellPositionDimensions,WellDiameters}],Null]],
			Max[Lookup[myContainerModelPacket,WellDepths]]
		},
		PacketP[Model[Container,Plate]],{
			Min[DeleteCases[Flatten@Lookup[myContainerModelPacket,{WellDimensions,WellDiameter}],Null]],
			Lookup[myContainerModelPacket,WellDepth]
		},
		_,{Null,Null}
	];

	(* If any information is missing, assume the tips can reach the bottom rather than throwing an error and stopping the protocol *)
	(* All info is required by VOQ, so this shouldn't happen *)
	If[
		Or[
			MatchQ[aspirationDepthsAtApertures,{}],
			MatchQ[sourceDepth,NullP],
			MatchQ[sourceAperture,NullP]
		],
		Return[True]
	];

	(* Sort the {{aperture,aspiration depth}..} list by aperture*)
	sortedAspirationDepthsAtApertures=Prepend[SortBy[aspirationDepthsAtApertures,First],{0 Meter,0 Meter}];

	(* Get the last entry with an aperture larger than that of the source aperture *)
	aspirationDepthAtClosestAperture=Last[DeleteCases[
		sortedAspirationDepthsAtApertures,
		_?(First[#]>sourceAperture &)
	]];

	(* Get the aspiration depth for that entry *)
	maxDepthTipsCanReach=Last[aspirationDepthAtClosestAperture];

	(* Check if the aspiration depth is larger than the source depth, indicating tips can reach bottom *)
	maxDepthTipsCanReach>=sourceDepth
];




(* ::Subsection:: *)
(*pipetForTips*)


(*The preferred tip to be used for each pipette type*)
pipetForTips[Model[Item,Tips,"id:8qZ1VW0Vx7jP"]]:=Model[Instrument,Pipette,"id:54n6evLmRbaY"]; (* "Eppendorf Research Plus P2.5", "0.1 - 10 uL Tips, Low Retention, Non-Sterile" *)
pipetForTips[Model[Item,Tips,"id:6V0npvmNkmJe"]]:=Model[Instrument,Pipette,"id:54n6evLmRbaY"]; (* "Eppendorf Research Plus P2.5", "0.1 - 10 uL Tips, Low Retention, Sterile" *)
pipetForTips[Model[Item,Tips,"id:rea9jl1or6YL"]]:=Model[Instrument,Pipette,"id:n0k9mG8Pwod4"]; (* "Eppendorf Research Plus P20", "Olympus 20 ul Filter tips, sterile" *)
pipetForTips[Model[Item,Tips,"id:4pO6dMWvnAlB"]]:=Model[Instrument,Pipette,"id:01G6nvwRpbLd"]; (* "Eppendorf Research Plus P200", "200 ul Towerpacks, non-sterile" *)
pipetForTips[Model[Item,Tips,"id:P5ZnEj4P88jR"]]:=Model[Instrument,Pipette,"id:01G6nvwRpbLd"]; (* "Eppendorf Research Plus P200", "Olympus 200 ul tips, sterile" *)
pipetForTips[Model[Item,Tips,"id:L8kPEjNLDpa6"]]:=Model[Instrument,Pipette,"id:01G6nvwRpbLd"]; (* "Eppendorf Research Plus P200", "200 ul wide-bore tips"*)
pipetForTips[Model[Item,Tips,"id:rea9jl5BBj1L"]]:=Model[Instrument,Pipette,"id:n0k9mG8Pwod4"]; (* "Eppendorf Research Plus P200", "200 uL wide-bore tips, non-sterile for P20 pipette"*)
pipetForTips[Model[Item,Tips,"id:WNa4ZjKxLnNL"]]:=Model[Instrument,Pipette,"id:01G6nvwRpbLd"]; (* "Eppendorf Research Plus P200", "200 uL gel loading tips"*)
pipetForTips[Model[Item,Tips,"id:n0k9mGzRaaN3"]]:=Model[Instrument,Pipette,"id:1ZA60vL547EM"]; (* "Eppendorf Research Plus P1000", "1000 ul reach tips, sterile" *)
pipetForTips[Model[Item,Tips,"id:8qZ1VWNw1z0X"]]:=Model[Instrument,Pipette,"id:1ZA60vL547EM"]; (* "Eppendorf Research Plus P1000", "1000 ul wide-bore tips" *)
pipetForTips[Model[Item,Tips,"id:mnk9jO3qD6R7"]]:=Model[Instrument,Pipette,"id:KBL5Dvw6eLDk"]; (* "Eppendorf Research Plus P5000", "D5000 TIPACK 5 ml tips" *)
pipetForTips[Model[Item,Tips,"id:vXl9j571oL67"]]:=Model[Instrument,Pipette,"id:KBL5Dvw6eLDk"]; (* "Eppendorf Research Plus P5000",  "5000 uL tips, sterile" *)
pipetForTips[Model[Item,Tips,"id:WNa4ZjKROWBE"]]:=Model[Instrument, Pipette, "id:E8zoYvNe7LNv"];(* "Pos-D MR-1000", "1000 uL positive displacement tips, sterile" *)
pipetForTips[Model[Item,Tips,"id:P5ZnEjd4eYJn"]]:=Model[Instrument, Pipette, "id:Y0lXejMGAmr1"];(* "Pos-D MR-100", "100 uL positive displacement tips, sterile" *)
pipetForTips[Model[Item,Tips,"id:1ZA60vwjbRmw"]]:=Model[Instrument, Pipette, "id:1ZA60vL547EM"];(* "Eppendorf Research Plus P1000", ""1000 uL tips, non-sterile"" *)
pipetForTips[Model[Item, Tips, "id:eGakldJR8D9e"]]:=Model[Instrument, Pipette, "id:1ZA60vL547EM"];(*"Eppendorf Research Plus P1000","1000 uL reach tips, non-sterile"*)
pipetForTips[Model[Item, Tips, "id:O81aEBZDpVzN"]]:=Model[Instrument, Pipette, "id:01G6nvwRpbLd"];(*"Eppendorf Research Plus P200","200 uL tips, non-sterile"*)

pipetForTips[Model[Item,Tips,"id:WNa4ZjRr5ljD"]|Model[Item,Tips,"id:01G6nvkKr5Em"]|Model[Item,Tips,"id:zGj91aR3d6MJ"]|Model[Item,Tips,"id:R8e1PjRDbO7d"]|Model[Item,Tips,"id:P5ZnEj4P8q8L"]|Model[Item,Tips,"id:aXRlGnZmOJdv"]|Model[Item,Tips,"id:D8KAEvdqzb8b"]|Model[Item,Tips, "id:kEJ9mqaVP6nV"]|Model[Item,Tips,"id:XnlV5jmbZLwB"]|Model[Item,Tips,"id:pZx9jonGJmkp"]|Model[Item,Tips,"id:Vrbp1jG80zpm"]]:=Model[Instrument,Pipette,"id:3em6ZvLlDkBY"]

(* ::Subsection:: *)
(*compatibleSampleManipulationContainers*)


compatibleSampleManipulationContainers[Bufferbot]:={
	Model[Container,Vessel,"id:xRO9n3vk11pw"], (* 15 mL tube *)
	Model[Container,Vessel,"id:bq9LA0dBGGR6"], (* 50 mL tube *)
	Model[Container,Vessel,"id:bq9LA0dBGGrd"], (* "50mL Light Sensitive Centrifuge Tube" *)
	Model[Container,Vessel,"id:J8AY5jwzPPR7"], (* 250 mL glass bottle *)
	Model[Container,Vessel,"id:aXRlGnZmOONB"], (* 500 mL glass bottle *)
	Model[Container,Vessel,"id:zGj91aR3ddXJ"], (* 1L glass bottle *)
	Model[Container,Vessel,"id:3em6Zv9Njjbv"], (* 2L glass bottle *)
	Model[Container,Vessel,"id:Vrbp1jG800Zm"], (* 4L amber glass bottle *)
	Model[Container,Vessel,"id:aXRlGnZmOOB9"], (* 10L Polypropylene Carboy *)
	Model[Container,Vessel,"id:3em6Zv9NjjkY"] (* 20L Polypropylene Carboy *)
};

DefineOptions[
	compatibleSampleManipulationContainers,
	Options:>{
		{ContainerType -> {Model[Container,Vessel],Model[Container,Plate]}, All|ListableP[TypeP[Model[Container]]], "The list of container types desired as output. Defaults to All types"},
		{EngineDefaultOnly -> True, BooleanP, "Indicates whether a container must be marked as EngineDefault->True to be considered compatible. This is useful when creating resource requests where samples should be transferred into common Hamilton-compatible containers."},
		(*{MinVolume -> None, None|VolumeP, "The list of container types desired as output. Defaults to All types"},*)
		CacheOption
	}
];

(* Core overload which memoizes *)
(*compatibleSampleManipulationContainers[MicroLiquidHandling,ops:OptionsPattern[compatibleSampleManipulationContainers]] := compatibleSampleManipulationContainers[MicroLiquidHandling] = Module[*)
compatibleSampleManipulationContainers[MicroLiquidHandling,ops:OptionsPattern[compatibleSampleManipulationContainers]] := Module[
	{safeOps,typesOp,discoveredPlates,discoveredRacks,discoveredVessels,additionalTempHardcodes,engineDefaultOnly,
		plateSearchCriteria,vesselSearchCriteria},

	safeOps = SafeOptions[compatibleSampleManipulationContainers,ToList[ops]];
	{typesOp,engineDefaultOnly} = Lookup[safeOps,{ContainerType,EngineDefaultOnly}];

	plateSearchCriteria = If[engineDefaultOnly,
		LiquidHandlerPrefix != Null && EngineDefault !=False && DeveloperObject!=True,
		LiquidHandlerPrefix != Null && DeveloperObject!=True
	];

	(* NOTE: we are allowing things that are compatible with SBS HPLC plate rack since it is a replacement for the Hamilton HPLC rack *)
	vesselSearchCriteria = If[engineDefaultOnly,
		Or[
			LiquidHandlerRackID != Null && EngineDefault !=False && DeveloperObject!=True,
			LiquidHandlerAdapter==Model[Container, Rack, "SBS HPLC plate rack"] && LiquidHandlerRackID == Null && EngineDefault !=False && DeveloperObject!=True
			],
		Or[
			LiquidHandlerRackID != Null && DeveloperObject!=True,
			LiquidHandlerAdapter==Model[Container, Rack, "SBS HPLC plate rack"] && LiquidHandlerRackID == Null && DeveloperObject!=True
			]
	];

	(* Search for all plates with LiquidHandlerPrefix and all Vessels with LiquidHandlerRackID *)
	{discoveredPlates,discoveredRacks,discoveredVessels} = If[Constellation`Private`loggedInQ[],

		Search[
			{Model[Container,Plate],Model[Container,Rack],Model[Container,Vessel]},
			Evaluate[{plateSearchCriteria,plateSearchCriteria,vesselSearchCriteria}]
		],

		(* Necessary for loading without error *)
		{{},{},{}}
	];

	(* Temporary hardcodes while we adjust how these vessels are handled in the database - will update by end of 7/14/2020 *)
	additionalTempHardcodes = {
		Model[Container, Vessel, "id:4pO6dM5WvJKM"],(*"8x43mm Glass Reaction Vial"*)
		Model[Container, Vessel, "id:eGakldJ6p35e"](*"22x45mm screw top vial 10mL"*)
	};

	(* Return the full list of plates and vessels that can be used *)
	If[MatchQ[typesOp,All],
		Flatten[{discoveredVessels,discoveredPlates,additionalTempHardcodes}],
		DeleteCases[
			Flatten[{discoveredVessels,discoveredPlates,discoveredRacks,additionalTempHardcodes}],
			Except[Alternatives@@(ObjectP/@ToList[typesOp])]
		]
	]
];

