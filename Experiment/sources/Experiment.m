(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*Framework Functions (legacy)*)


(* ::Subsubsection::Closed:: *)
(*getMapThreadedOptionNames (legacy)*)


getMapThreadedOptionNames[experimentName_Symbol]:=Module[
	{allOptionNames},

	(* Options[experimentName] returns a {(optionName->defaultValue)..}. Get just the option name *)
	allOptionNames = ToExpression[Options[experimentName][[All, 1]]];

	(* Get a list of any options marked as map threaded in the usage rules*)
	Select[allOptionNames,mapThreadOptionQ[experimentName,#]&]
];


(* ::Subsection:: *)
(*CompatibleMaterialsQ*)


(* ::Subsubsection::Closed:: *)
(*CompatibleMaterialsQ Options and Messages*)


DefineOptions[CompatibleMaterialsQ,
	Options:>{
		{Messages->True,BooleanP,"Indicates if the function should print any messages regarding chemical incompatibility."},
		{OutputFormat->SingleBoolean,SingleBoolean|Boolean,"Determines the format of the return value. Boolean returns a pass/fail for each entry. SingleBoolean returns a single pass/fail boolean for all the inputs. TestSummary returns the EmeraldTestSummary object for each input."},
		FastTrackOption,
		CacheOption,
		SimulationOption,
		HelperOutputOption
	}
];

Error::IncompatibleMaterials="The provided sample-instrument pairs, `1`, are chemically incompatible. Please check the IncompatibleMaterials of the sample and WettedMaterial of the corresponding instrument or part, and substitute these samples for chemically compatible ones if possible.";


(* ::Subsubsection:: *)
(*CompatibleMaterialsQ*)


(* Single Sample Overload: Pass to Core *)
CompatibleMaterialsQ[myInstrument:ObjectP[{Model[Instrument],Object[Instrument], Object[Part], Model[Part]}],mySample:(NonSelfContainedSampleP|NonSelfContainedSampleModelP),myOptions:OptionsPattern[]]:=Module[
	{compatibleMaterialsResult},

	compatibleMaterialsResult = CompatibleMaterialsQ[{myInstrument},{mySample},myOptions];

	If[MatchQ[OptionValue[OutputFormat], SingleBoolean],
		compatibleMaterialsResult,
		First[compatibleMaterialsResult]
	]
];

(* Single instrument multiple samples *)
CompatibleMaterialsQ[myInstrument:ObjectP[{Model[Instrument],Object[Instrument],Object[Part], Model[Part]}],mySamples:{(NonSelfContainedSampleP|NonSelfContainedSampleModelP)...},myOptions:OptionsPattern[]]:=Module[
	{compatibleMaterialsResult, outputOption, outputFormatOption, resultPosition},

	(* this is for backwards compatiblility only; we cannot have {} as an input for the core double listable overload because of MM recursion errors with OptionsPattern *)
	compatibleMaterialsResult = CompatibleMaterialsQ[{myInstrument}, mySamples /. {{} -> Null},myOptions];

	(* pull out the output option *)
	outputOption = OptionValue[Output];
	outputFormatOption = OptionValue[OutputFormat];

	(* get the position of the Result key inside output *)
	(* we need to take First of the Result key but not of everything else *)
	resultPosition = Switch[outputOption,
		_List, FirstPosition[outputOption, Result, Null],
		Result, 0,
		_, Null
	];

	Switch[{outputFormatOption, resultPosition},
		(* if we have SingleBoolean, we don't need to do anything *)
		{SingleBoolean, _}, compatibleMaterialsResult,
		(* if we have Boolean but we just have Result as the Output Option, just take First to remove one level of listedness *)
		{Boolean, 0}, First[compatibleMaterialsResult],
		(* if we have Boolean but Result isn't part of the Output option at all, we don't need to do anything *)
		{Boolean, Null}, compatibleMaterialsResult,
		(* otherwise, we have Result as one entry of several in the Output option.  We need to take First of _only_ the entry where we have Result *)
		{Boolean, _List}, ReplacePart[compatibleMaterialsResult, resultPosition -> First[compatibleMaterialsResult[[First[resultPosition]]]]]
	]
];

(* Single sample mulitple instruments *)
CompatibleMaterialsQ[myInstruments: {ObjectP[{Model[Instrument], Object[Instrument], Object[Part], Model[Part]}]..},mySample:(NonSelfContainedSampleP|NonSelfContainedSampleModelP),myOptions:OptionsPattern[]]:=Module[
	{compatibleMaterialsResult, outputOption, outputFormatOption, resultPosition},

	compatibleMaterialsResult = CompatibleMaterialsQ[myInstruments, {mySample},myOptions];

	(* pull out the output option *)
	outputOption = OptionValue[Output];
	outputFormatOption = OptionValue[OutputFormat];

	(* get the position of the Result key inside output *)
	(* we need to take First of the Result key but not of everything else *)
	resultPosition = Switch[outputOption,
		_List, FirstPosition[outputOption, Result, Null],
		Result, 0,
		_, Null
	];

	Switch[{outputFormatOption, resultPosition},
		(* if we have SingleBoolean, we don't need to do anything *)
		{SingleBoolean, _}, compatibleMaterialsResult,
		(* if we have Boolean but we just have Result as the Output Option, just take First to remove one level of listedness *)
		{Boolean, 0}, First[compatibleMaterialsResult],
		(* if we have Boolean but Result isn't part of the Output option at all, we don't need to do anything *)
		{Boolean, Null}, compatibleMaterialsResult,
		(* otherwise, we have Result as one entry of several in the Output option.  We need to take First of _only_ the entry where we have Result *)
		{Boolean, _List}, ReplacePart[compatibleMaterialsResult, resultPosition -> First[compatibleMaterialsResult[[First[resultPosition]]]]]
	]
];

(* core function; looks at how all samples touch all instruments.  note that this is NOT index matching; it's an all vs all comparison *)
CompatibleMaterialsQ[myInstruments: {ObjectP[{Model[Instrument], Object[Instrument], Object[Part], Model[Part]}]..},mySamples:{(NonSelfContainedSampleP|NonSelfContainedSampleModelP)..}|Null,myOptions:OptionsPattern[]]:=Module[
	{safeOptions,cache,inheritedCache,simulation,fastTrack,messages,samplePacketSpecs, instrumentPacketSpec,
		allDownloadObjects, allDownloadFields,allPackets,samplePackets, allCompatibleQs, incompatiblePairs,
		testsRule,resultRule, fastAssoc, possibleSamplePackets, possibleInstrumentModelPackets,
		listedOptions,outputSpecification,output,gatherTests,safeOptionTests,incompatiblityTests,outputFormat,
		samplesToDownloadFrom, instrumentsToDownloadFrom, sampleInFastAssocQs, instrumentInFastAssocQs,
		downloadedSamplePackets, downloadedInstrumentPackets, instrumentModelPackets, listedSamples
	},

	(* Make sure we're working with a list of options *)
	listedOptions = ToList[myOptions];
	listedSamples = If[NullQ[mySamples], {}, mySamples];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[CompatibleMaterialsQ, listedOptions, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[CompatibleMaterialsQ, listedOptions, AutoCorrect -> False], Null}
	];

	(* If the specified options don't match their patterns, return $Failed *)
	If[MatchQ[safeOptions, $Failed],
		Return[$Failed]
	];

	(* There are no indexed inputs or option so we don't need to call ValidInputLengthsQ, but if this changes, this is where we would do that check. *)

	(* We don't need to resolve or validate any options, but if we did, this is where we would call the resolver *)

	(* assign the option values to local variables *)
	inheritedCache = Lookup[safeOptions, Cache];
	simulation = Lookup[safeOptions, Simulation];
	fastTrack = Lookup[safeOptions, FastTrack];
	messages = Lookup[safeOptions, Messages];
	outputFormat = Lookup[safeOptions, OutputFormat];

	(* merge inherited cache and simulation into one cache *)
	cache = If[NullQ[simulation],
		inheritedCache,
		FlattenCachePackets[{inheritedCache, Lookup[simulation[[1]], Packets]}]
	];

	(* make a fastAssoc from the cache *)
	fastAssoc = makeFastAssocFromCache[cache];

	(* pull out the sample packets and the instrument packets (if they're already in the cache) *)
	possibleSamplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ listedSamples;
	possibleInstrumentModelPackets = Map[
		If[MatchQ[#, ObjectP[Model]],
			fetchPacketFromFastAssoc[#, fastAssoc],
			fastAssocPacketLookup[fastAssoc, #, Model]
		]&,
		myInstruments
	];

	(* determine if the sample and instrument packets are in the fastAssoc already |*)
	sampleInFastAssocQs = MatchQ[#, KeyValuePattern[{IncompatibleMaterials -> _List}]]& /@ possibleSamplePackets;
	instrumentInFastAssocQs = MatchQ[#, KeyValuePattern[{WettedMaterials -> _List}]]& /@ possibleInstrumentModelPackets;

	(* still need to Download from the objects we don't have in the fastAssoc; get those things now *)
	samplesToDownloadFrom = PickList[listedSamples, sampleInFastAssocQs, False];
	instrumentsToDownloadFrom = PickList[myInstruments, instrumentInFastAssocQs, False];

	(* construct field specs for the samples to get their IncompatibleMaterials. Always download the IncompatibleMaterials field, regardless of if we have a Model or Object sample. *)
	samplePacketSpecs = ConstantArray[{Packet[IncompatibleMaterials]}, Length[samplesToDownloadFrom]];

	(* construct a field spec that will give us the WettedMaterials of the instrument or part, depending on whether it's a Model/Object *)
	instrumentPacketSpec = Map[
		If[MatchQ[#, ObjectP[Model]],
			{Packet[WettedMaterials]},
			{Packet[Model[WettedMaterials]]}
		]&,
		instrumentsToDownloadFrom
	];

	(* join together the object and field spec lists for passing to Download as flat lists *)
	allDownloadObjects = Join[samplesToDownloadFrom, instrumentsToDownloadFrom];
	allDownloadFields = Join[samplePacketSpecs, instrumentPacketSpec];

	(* Download from the objects that are not already in the fastAssoc *)
	allPackets = Download[allDownloadObjects, allDownloadFields, Cache -> inheritedCache, Simulation -> simulation];
	{downloadedSamplePackets, downloadedInstrumentPackets} = TakeDrop[allPackets, Length[samplesToDownloadFrom]];

	(* merge what we Downloaded here with what was already in the fastAssoc *)
	(* basically, the positions where we don't have anything in the fastAssoc are going to be in the same order as the downloaded values, so we can just straight go in order with ReplacePart *)
	samplePackets = ReplacePart[possibleSamplePackets, AssociationThread[Position[sampleInFastAssocQs, False], Flatten@downloadedSamplePackets]];
	instrumentModelPackets = ReplacePart[possibleInstrumentModelPackets, AssociationThread[Position[instrumentInFastAssocQs, False], Flatten@downloadedInstrumentPackets]];

	(* compare sample compatibility with all instruments *)
	(* do each sample for each instrument *)
	allCompatibleQs = Map[
		Function[{instrumentModelPacket},
			Map[
				(* get the wetted materials here so we don't get it every time we are sample mapping *)
				With[{wettedMaterials = Lookup[instrumentModelPacket, WettedMaterials]},
					Function[{samplePacket},
						Module[
							{incompatibleMaterials, overlappingMaterials},

							(* pull incompatible materials of this sample model *)
							incompatibleMaterials = Lookup[samplePacket, IncompatibleMaterials];

							(* determine overlap between these incompatible materials and the instrument's wetted materials *)
							overlappingMaterials = Intersection[incompatibleMaterials, wettedMaterials];

							(* if there are overlapping materials, return the original input, as it has an incompatibility *)
							If[MatchQ[overlappingMaterials, {MaterialP..}],
								False,
								True
							]
						]
					]
				],
				samplePackets
			]
		],
		instrumentModelPackets
	];

	(* Pick the sample instrument pairs that are incompatible with the device input *)
	incompatiblePairs = Join @@ MapThread[
		Function[{instrumentModelPacket, compatibleQs},
			MapThread[
				Function[{samplePacket, compatibleQ},
					If[compatibleQ,
						Nothing,
						{Lookup[samplePacket, Object], Lookup[instrumentModelPacket, Object]}
					]
				],
				{samplePackets, compatibleQs}
			]
		],
		{instrumentModelPackets, allCompatibleQs}
	];

	(* throw a message if we are not on the fast track, and have been allowed to throw messages by the Messages option, and we are not collecting tests *)
	If[!fastTrack&&messages&&!gatherTests&&Not[MatchQ[incompatiblePairs,{}]],
		Message[Error::IncompatibleMaterials,incompatiblePairs]
	];


	(* if we are collecting tests, make a test *)
	incompatiblityTests=If[gatherTests,
		Flatten[MapThread[
			Function[{instrumentModelPacket, compatibleQs},
				MapThread[
					Function[{samplePacket, compatibleQ},
						Test[ToString[Lookup[samplePacket, Object]] <> " is chemically compatible with the wetted materials in " <> ToString[Lookup[instrumentModelPacket, Object]] <> ":",
							compatibleQ,
							True
						]
					],
					{samplePackets, compatibleQs}
				]
			],
			{instrumentModelPackets, allCompatibleQs}
		]]
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule = Tests -> If[MemberQ[output, Tests],
		(* Join all exisiting tests generated by helper functions with any additional tests *)
		Join[safeOptionTests, incompatiblityTests],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule = Result -> If[MemberQ[output, Result],
		(*
		If OutputFormat is SingleBoolean, return a boolean indicating if we found any of the provided samples to be incompatible,
		If OutputFormat is Boolean, return a list of booleans indicating if each of the provided samples is incompatible,
		 *)
		If[MatchQ[outputFormat, SingleBoolean],
			And @@ Flatten[allCompatibleQs],
			allCompatibleQs
		]
	];

	outputSpecification /. {testsRule, resultRule}
];



(* ::Subsection:: *)
(*experimentFunctionTypeLookup*)

experimentFunctionTypeLookup = <|
	Experiment -> Object[Protocol],
	ExperimentSamplePreparation -> {
		Object[Protocol, ManualSamplePreparation],
		Object[Protocol, RoboticSamplePreparation],
		Object[Notebook, Script]
	},
	ExperimentCellPreparation -> {
		Object[Protocol, ManualCellPreparation],
		Object[Protocol, RoboticCellPreparation],
		Object[Notebook, Script]
	},
	(* NOTE: ExperimentManualSamplePreparation can return protocols of any type. *)
	ExperimentManualSamplePreparation -> Object[Protocol, ManualSamplePreparation],
	ExperimentRoboticSamplePreparation -> Object[Protocol, RoboticSamplePreparation],
	ExperimentManualCellPreparation -> Object[Protocol, ManualCellPreparation],
	ExperimentRoboticCellPreparation -> Object[Protocol, RoboticCellPreparation],
	ExperimentAbsorbanceSpectroscopy -> Object[Protocol, AbsorbanceSpectroscopy],
	ExperimentAbsorbanceIntensity -> Object[Protocol, AbsorbanceIntensity],
	ExperimentAbsorbanceKinetics -> Object[Protocol, AbsorbanceKinetics],
	ExperimentAcousticLiquidHandling -> Object[Protocol, AcousticLiquidHandling],
	ExperimentAdjustpH -> Object[Protocol, AdjustpH],
	ExperimentAgaroseGelElectrophoresis -> Object[Protocol, AgaroseGelElectrophoresis],
	ExperimentAlphaScreen -> Object[Protocol, AlphaScreen],
	ExperimentUVMelting -> Object[Protocol, UVMelting],
	ExperimentAliquot -> {
		Object[Protocol, ManualSamplePreparation],
		Object[Protocol, ManualCellPreparation],
		Object[Protocol, RoboticSamplePreparation],
		Object[Protocol, RoboticCellPreparation]
	},
	ExperimentAssembleCrossFlowFiltrationTubing -> Object[Protocol, AssembleCrossFlowFiltrationTubing],
	ExperimentAutoclave -> Object[Protocol, Autoclave],
	ExperimentCapillaryELISA -> Object[Protocol, CapillaryELISA],
	ExperimentCapillaryGelElectrophoresisSDS -> Object[Protocol, CapillaryGelElectrophoresisSDS],
	ExperimentCapillaryIsoelectricFocusing -> Object[Protocol, CapillaryIsoelectricFocusing],
	ExperimentCentrifuge -> {
		Object[Protocol, ManualSamplePreparation],
		Object[Protocol, RoboticSamplePreparation],
		Object[Protocol, Centrifuge]
	},
	ExperimentCircularDichroism -> Object[Protocol,CircularDichroism],
	ExperimentCoulterCount -> Object[Protocol, CoulterCount],
	ExperimentCountLiquidParticles -> Object[Protocol,CountLiquidParticles],
	ExperimentCover -> Object[Protocol, Cover],
	ExperimentCrossFlowFiltration -> Object[Protocol, CrossFlowFiltration],
	ExperimentCyclicVoltammetry -> Object[Protocol, CyclicVoltammetry],
	ExperimentDegas -> Object[Protocol,Degas],
	ExperimentDesiccate -> Object[Protocol, Desiccate],
	ExperimentDialysis -> Object[Protocol, Dialysis],
	ExperimentDifferentialScanningCalorimetry -> Object[Protocol, DifferentialScanningCalorimetry],
	ExperimentDigitalPCR -> Object[Protocol, DigitalPCR],
	ExperimentDilute -> {
		Object[Protocol, ManualSamplePreparation],
		Object[Protocol, ManualCellPreparation],
		Object[Protocol, RoboticSamplePreparation],
		Object[Protocol, RoboticCellPreparation]
	},
	ExperimentDNASequencing -> Object[Protocol, DNASequencing],
	ExperimentDNASynthesis -> Object[Protocol, DNASynthesis],
	ExperimentDynamicFoamAnalysis -> Object[Protocol, DynamicFoamAnalysis],
	ExperimentDynamicLightScattering -> Object[Protocol, DynamicLightScattering],
	ExperimentELISA -> Object[Protocol, ELISA],
	ExperimentEvaporate -> Object[Protocol, Evaporate],
	ExperimentFillToVolume -> Object[Protocol, FillToVolume],
	ExperimentFilter -> {
		Object[Protocol, ManualSamplePreparation],
		Object[Protocol, ManualCellPreparation],
		Object[Protocol, RoboticSamplePreparation],
		Object[Protocol, RoboticCellPreparation],
		Object[Protocol, Filter]
	},
	ExperimentFlashChromatography -> Object[Protocol, FlashChromatography],
	ExperimentFlashFreeze -> Object[Protocol, FlashFreeze],
	ExperimentFlowCytometry -> Object[Protocol, FlowCytometry],
	ExperimentFPLC -> Object[Protocol, FPLC],
	ExperimentFluorescenceIntensity -> Object[Protocol, FluorescenceIntensity],
	ExperimentFluorescenceKinetics -> Object[Protocol, FluorescenceKinetics],
	ExperimentFluorescenceSpectroscopy -> Object[Protocol, FluorescenceSpectroscopy],
	ExperimentFluorescencePolarization -> Object[Protocol, FluorescencePolarization],
	ExperimentFluorescencePolarizationKinetics -> Object[Protocol, FluorescencePolarizationKinetics],
	ExperimentFreezeCells -> Object[Protocol, FreezeCells],
	ExperimentFragmentAnalysis -> Object[Protocol, FragmentAnalysis],
	ExperimentGasChromatography -> Object[Protocol, GasChromatography],
	ExperimentGCMS -> Object[Protocol, GasChromatography],
	ExperimentGrind -> Object[Protocol, Grind],
	ExperimentHPLC -> Object[Protocol, HPLC],
	ExperimentICPMS -> Object[Protocol, ICPMS],
	ExperimentIncubate -> {
		Object[Protocol, ManualSamplePreparation],
		Object[Protocol, ManualCellPreparation],
		Object[Protocol, RoboticSamplePreparation],
		Object[Protocol, RoboticCellPreparation],
		Object[Protocol, Incubate]
	},
	ExperimentIncubateCells -> {
		Object[Protocol, IncubateCells],
		Object[Protocol, RoboticCellPreparation]
	},
	ExperimentInteractiveTraining -> Object[Protocol, InteractiveTraining],
	ExperimentImageCells -> Object[Protocol, ImageCells],
	ExperimentImageColonies -> Object[Protocol, RoboticCellPreparation],
	ExperimentImageSample -> Object[Protocol, ImageSample],
	ExperimentIonChromatography -> Object[Protocol,IonChromatography],
	ExperimentIRSpectroscopy -> Object[Protocol, IRSpectroscopy],
	ExperimentLCMS -> Object[Protocol, LCMS],
	ExperimentLuminescenceIntensity -> Object[Protocol, LuminescenceIntensity],
	ExperimentLuminescenceKinetics -> Object[Protocol, LuminescenceKinetics],
	ExperimentLuminescenceSpectroscopy -> Object[Protocol, LuminescenceSpectroscopy],
	ExperimentLyophilize -> Object[Protocol, Lyophilize],
	ExperimentMagneticBeadSeparation -> Object[Protocol, MagneticBeadSeparation],
	ExperimentMassSpectrometry -> Object[Protocol, MassSpectrometry],
	ExperimentMeasureConductivity -> Object[Protocol, MeasureConductivity],
	ExperimentMeasureContactAngle -> Object[Protocol, MeasureContactAngle],
	ExperimentMeasureCount -> Object[Protocol, MeasureCount],
	ExperimentMeasureDensity -> Object[Protocol, MeasureDensity],
	ExperimentMeasureDissolvedOxygen -> Object[Protocol, MeasureDissolvedOxygen],
	ExperimentMeasureMeltingPoint -> Object[Protocol, MeasureMeltingPoint],
	ExperimentMeasureOsmolality -> Object[Protocol, MeasureOsmolality],
	ExperimentMeasurepH -> Object[Protocol, MeasurepH],
	ExperimentMeasureRefractiveIndex -> Object[Protocol, MeasureRefractiveIndex],
	ExperimentMeasureSurfaceTension -> Object[Protocol, MeasureSurfaceTension],
	ExperimentMeasureViscosity -> Object[Protocol, MeasureViscosity],
	ExperimentMeasureVolume -> Object[Protocol, MeasureVolume],
	ExperimentMeasureWeight -> Object[Protocol, MeasureWeight],
	ExperimentMedia -> Object[Protocol, StockSolution],
	ExperimentMicrowaveDigestion -> Object[Protocol, MicrowaveDigestion],
	ExperimentNephelometry -> Object[Protocol, Nephelometry],
	ExperimentNephelometryKinetics -> Object[Protocol, NephelometryKinetics],
	ExperimentNMR -> Object[Protocol, NMR],
	ExperimentNMR2D -> Object[Protocol, NMR2D],
	ExperimentPAGE -> Object[Protocol, PAGE],
	ExperimentPCR -> {
		Object[Protocol, ManualSamplePreparation],
		Object[Protocol, RoboticSamplePreparation],
		Object[Protocol, PCR]
	},
	ExperimentGrowCrystal -> Object[Protocol, GrowCrystal],
	ExperimentPrepareReferenceElectrode -> Object[Protocol, PrepareReferenceElectrode],
	ExperimentPeptideSynthesis -> Object[Protocol, PeptideSynthesis],
	ExperimentPlateMedia -> Object[Protocol, PlateMedia],
	ExperimentPNASynthesis -> Object[Protocol, PNASynthesis],
	ExperimentPowderXRD -> Object[Protocol, PowderXRD],
	ExperimentqPCR -> Object[Protocol, qPCR],
	ExperimentQuantifyCells -> Object[Protocol, QuantifyCells],
	ExperimentQuantifyColonies -> {Object[Protocol, RoboticCellPreparation], Object[Protocol, QuantifyColonies]},
	ExperimentRamanSpectroscopy -> Object[Protocol, RamanSpectroscopy],
	ExperimentResuspend -> {
		Object[Protocol, ManualSamplePreparation],
		Object[Protocol, ManualCellPreparation],
		Object[Protocol, RoboticSamplePreparation],
		Object[Protocol, RoboticCellPreparation]
	},
	ExperimentSpreadCells -> Object[Protocol, RoboticCellPreparation],
	ExperimentSolidPhaseExtraction -> Object[Protocol, SolidPhaseExtraction],
	ExperimentSerialDilute -> {
		Object[Protocol, ManualSamplePreparation],
		Object[Protocol, ManualCellPreparation],
		Object[Protocol, RoboticSamplePreparation],
		Object[Protocol, RoboticCellPreparation],
		Object[Protocol, SerialDilute]
	},
	ExperimentStockSolution -> Object[Protocol, StockSolution],
	ExperimentSupercriticalFluidChromatography -> Object[Protocol, SupercriticalFluidChromatography],
	ExperimentThermalShift -> Object[Protocol, ThermalShift],
	ExperimentTotalProteinDetection -> Object[Protocol, TotalProteinDetection],
	ExperimentTotalProteinQuantification -> Object[Protocol, TotalProteinQuantification],
	ExperimentTransfer -> {
		Object[Protocol, ManualSamplePreparation],
		Object[Protocol, ManualCellPreparation],
		Object[Protocol, RoboticSamplePreparation],
		Object[Protocol, RoboticCellPreparation],
		Object[Protocol, Transfer]
	},
	ExperimentUncover -> Object[Protocol, Uncover],
	ExperimentVisualInspection -> Object[Protocol, VisualInspection],
	ExperimentWestern -> Object[Protocol, Western],
	MaintenanceInstallGasCylinder -> Object[Maintenance, InstallGasCylinder],
	ExperimentPellet -> {
		Object[Protocol, ManualSamplePreparation],
		Object[Protocol, ManualCellPreparation],
		Object[Protocol, RoboticSamplePreparation],
		Object[Protocol, RoboticCellPreparation],
		Object[Protocol, Pellet]
	},
	ExperimentBioLayerInterferometry -> Object[Protocol, BioLayerInterferometry],
	ExperimentVapro5600Training -> Object[Protocol, Vapro5600Training],
	ExperimentVisualInspection -> Object[Protocol, VisualInspection],
	ExperimentInoculateLiquidMedia -> Object[Protocol, InoculateLiquidMedia],
	ExperimentLiquidLiquidExtraction -> Object[Protocol, RoboticSamplePreparation],
	ExperimentPickColonies -> Object[Protocol, RoboticCellPreparation],
	ExperimentSpreadCells -> Object[Protocol, RoboticCellPreparation],
	ExperimentStreakCells -> Object[Protocol, RoboticCellPreparation],
	ExperimentLyseCells -> Object[Protocol, RoboticCellPreparation],
	ExperimentWashCells -> Object[Protocol, RoboticCellPreparation]
|>

