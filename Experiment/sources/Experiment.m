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

Warning::IncompatibleMaterials="The provided samples, `1`, are chemically incompatible with the wetted materials in `2`. Please check the IncompatibleMaterials listing in these chemicals, and the WettedMaterials of the instrument, and substitute these samples for chemically compatible ones if possible.";


(* ::Subsubsection:: *)
(*CompatibleMaterialsQ*)


(* Single Sample Overload: Pass to Core *)
CompatibleMaterialsQ[myInstrument:ObjectP[{Model[Instrument],Object[Instrument], Object[Part], Model[Part]}],mySample:(NonSelfContainedSampleP|NonSelfContainedSampleModelP),myOptions:OptionsPattern[]]:=CompatibleMaterialsQ[myInstrument,{mySample},myOptions];

(* Core function, looks at a single instrument and a list of samples for compatibility *)
CompatibleMaterialsQ[myInstrument:ObjectP[{Model[Instrument],Object[Instrument],Object[Part], Model[Part]}],mySamples:{(NonSelfContainedSampleP|NonSelfContainedSampleModelP)...},myOptions:OptionsPattern[]]:=Module[
	{safeOptions,cache,inheritedCache,simulation,fastTrack,messages,samplePacketSpecs,instrumentPacketSpec,allDownloadObjects,
		allDownloadFields,allPackets,samplePackets,instrumentModelPacket,instrumentWettedMaterials,
		incompatibleSamples,testsRule,resultRule,
		listedOptions,outputSpecification,output,gatherTests,safeOptionTests,incompatiblityTests,outputFormat,compatibleQs
	},

	(* Make sure we're working with a list of options *)
	listedOptions=ToList[myOptions];

	(* Determine the requested return value from the function *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];


	(* Call SafeOptions to make sure all options match pattern *)
	{safeOptions,safeOptionTests}=If[gatherTests,
		SafeOptions[CompatibleMaterialsQ,listedOptions,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[CompatibleMaterialsQ,listedOptions,AutoCorrect->False],Null}
	];

	(* If the specified options don't match their patterns, return $Failed *)
	If[MatchQ[safeOptions,$Failed],
		Return[$Failed]
	];

	(* There are no indexed inputs or option so we don't need to call ValidInputLengthsQ, but if this changes, this is where we would do that check. *)

	(* We don't need to resolve or validate any options, but if we did, this is where we would call the resolver *)

	(* assign the option values to local variables *)
	inheritedCache=Lookup[safeOptions,Cache];
	simulation=Lookup[safeOptions,Simulation];
	fastTrack=Lookup[safeOptions,FastTrack];
	messages=Lookup[safeOptions,Messages];
	outputFormat=Lookup[safeOptions,OutputFormat];

	(* merge inherited cache and simulation into one cache *)
	cache=If[NullQ[simulation],
		inheritedCache,
		FlattenCachePackets[{inheritedCache,Lookup[simulation[[1]],Packets]}]
	];
	
	(* construct field specs for the samples to get their IncompatibleMaterials. always download the IncompatibleMaterials field, regardless of if we have a Model or Object sample. *)
	samplePacketSpecs=ConstantArray[{Packet[IncompatibleMaterials]},Length[mySamples]];
	
	(* construct a field spec that will give us the WettedMaterials of the instrument or part, depending on whether it's a Model/Object *)
	instrumentPacketSpec=If[MatchQ[myInstrument,ObjectP[Object]],
		{Packet[Model[{WettedMaterials}]]},
		{Packet[WettedMaterials]}
	];
	
	(* join together the object and field spec lists for passing to Download as flat lists *)
	allDownloadObjects=Append[mySamples,myInstrument];
	allDownloadFields=Append[samplePacketSpecs,instrumentPacketSpec];
	
	(* download material compatibility from the samples/instruments; split the info between the instrument materials and all sample materials *)
	(*
	SPEED: Download will still contact database even with a proper cache, because of cache value for the object definition.
	This becomes terribly slow when we Map call CompatibleMaterialQ.
	So we try to fetchPacketFromCache first. If it has all the fields we need then just take those values. Otherwise download
	*)


	allPackets=If[MatchQ[{mySamples,myInstrument,cache},{{PacketP[]..},PacketP[],_}]||MatchQ[cache,Except[{}|Null|{Null..}]],
		Module[{fetchedSamplePackets,samplePackestFieldQs,fetchedInstrumentPacket,instrumentPacketsFieldQ,neededFieldsExistQ,
			primaryFetch,primaryWithWettedMaterialQ,secondaryFetch,secondaryWithWettedMaterialQ},

			fetchedSamplePackets=fetchPacketFromCache[#,cache]&/@mySamples;
			samplePackestFieldQs=AssociationMatchQ[#,<|IncompatibleMaterials->Except[$Failed]|>,AllowForeignKeys->True]&/@fetchedSamplePackets;

			{fetchedInstrumentPacket,instrumentPacketsFieldQ}=Catch[
				primaryFetch=fetchPacketFromCache[myInstrument,cache];
				primaryWithWettedMaterialQ=AssociationMatchQ[primaryFetch,<|WettedMaterials->_List|>,AllowForeignKeys->True];
				If[primaryWithWettedMaterialQ,
					Throw[{primaryFetch,primaryWithWettedMaterialQ}],
					(*ELSE: does not have WettedMaterials field or did not download this field in cache-- look at its model*)
					secondaryFetch=fetchPacketFromCache[Lookup[primaryFetch,Model,<||>],cache];
					secondaryWithWettedMaterialQ=AssociationMatchQ[secondaryFetch,<|WettedMaterials->_List|>,AllowForeignKeys->True];
					Throw[{secondaryFetch,secondaryWithWettedMaterialQ}]
				]
			];
			neededFieldsExistQ=And@@Flatten[{samplePackestFieldQs,instrumentPacketsFieldQ}];

			If[neededFieldsExistQ,
				(*If both sample and instrument needed fields can be fetched from cache, then just use the fetched packet*)
				Append[List/@fetchedSamplePackets,{fetchedInstrumentPacket}],
				(*ELSE: download*) (*TODO: should we throw a warning here for developers that their cache is no good?*)
				Download[allDownloadObjects,allDownloadFields,Cache->cache]
			]
		],
		(*ELSE: if there's no way we could have used fetchPacketsFromCache either because there's no cache passed or because the mySamples and myInstrument are not packets, then directly go download.*)
		Download[allDownloadObjects,allDownloadFields,Cache->cache]
	];
	samplePackets=Most[allPackets][[All,1]];
	instrumentModelPacket=First[Last[allPackets]];
	
	(* pull the wetted materials of the instruemnt model *)
	instrumentWettedMaterials=Lookup[instrumentModelPacket,WettedMaterials];
	
	(* move through the sample model packets and return those that have an incompatibility *)
	compatibleQs=Map[
		Module[{incompatibleMaterials,overlappingMaterials},

			(* pull incompatible materials of this sample model *)
			incompatibleMaterials=Lookup[#,IncompatibleMaterials];

			(* determine overlap between these incompatible materials and the instrument's wetted materials *)
			overlappingMaterials=Intersection[incompatibleMaterials,instrumentWettedMaterials];

			(* if there are overlapping materials, return the original input, as it has an incompatibility *)
			If[MatchQ[overlappingMaterials,{MaterialP..}],
				False,
				True
			]
		]&,
		samplePackets
	];
	(* Pick the sample inputs that are incompatible with the device input *)
	incompatibleSamples=PickList[mySamples,compatibleQs,False];

	(* throw a message if we are not on the fast track, and have been allowed to throw messages by the Messages option, and we are not collecting tests *)
	If[!fastTrack&&messages&&!gatherTests&&MatchQ[incompatibleSamples,{ObjectP[]..}],
		Message[Warning::IncompatibleMaterials,incompatibleSamples,myInstrument]
	];

	(* if we are collecting tests, make a test *)
	incompatiblityTests=If[gatherTests,
		Map[
			Test[ToString[#]<>" is chemically incompatible with the wetted materials in "<>ToString[myInstrument]<>". Please check the IncompatibleMaterials listing in these samples, and the WettedMaterials of the instrument, and substitute these samples for chemically compatible ones if possible:",
				MemberQ[incompatibleSamples,#],
				False
			]&,mySamples
		]
	];

	(* Prepare the Test result if we were asked to do so *)
	testsRule=Tests->If[MemberQ[output,Tests],
	(* Join all exisiting tests generated by helper functions with any additional tests *)
		Join[safeOptionTests,incompatiblityTests],
		Null
	];

	(* Prepare the standard result if we were asked for it and we can safely do so *)
	resultRule=Result->If[MemberQ[output,Result],
		(*
		If OutputFormat is SingleBoolean, return a boolean indicating if we found any of the provided samples to be incompatible,
		If OutputFormat is Boolean, return a list of booleans indicating if each of the provided samples is incompatible,
		 *)
		If[MatchQ[outputFormat,SingleBoolean],
			And@@compatibleQs,
			compatibleQs
		]
	];

	outputSpecification/.{testsRule,resultRule}
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
		Object[Protocol, RoboticSamplePreparation]
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
	ExperimentCover->Object[Protocol, Cover],
	ExperimentCOVID19Test -> Object[Protocol, COVID19Test],
	ExperimentRoboticCOVID19Test -> Object[Protocol, RoboticCOVID19Test],
	ExperimentCrossFlowFiltration -> Object[Protocol, CrossFlowFiltration],
	ExperimentCyclicVoltammetry -> Object[Protocol, CyclicVoltammetry],
	ExperimentDegas -> Object[Protocol,Degas],
	ExperimentDesiccate -> Object[Protocol, Desiccate],
	ExperimentDialysis -> Object[Protocol, Dialysis],
	ExperimentDifferentialScanningCalorimetry -> Object[Protocol, DifferentialScanningCalorimetry],
	ExperimentDigitalPCR -> Object[Protocol, DigitalPCR],
	ExperimentDilute -> {
		Object[Protocol, ManualSamplePreparation],
		Object[Protocol, RoboticSamplePreparation]
	},
	ExperimentDNASequencing -> Object[Protocol, DNASequencing],
	ExperimentDNASynthesis -> Object[Protocol, DNASynthesis],
	ExperimentDynamicFoamAnalysis -> Object[Protocol, DynamicFoamAnalysis],
	ExperimentDynamicLightScattering -> Object[Protocol, DynamicLightScattering],
	ExperimentEvaporate -> Object[Protocol, Evaporate],
	ExperimentFillToVolume -> Object[Protocol, FillToVolume],
	ExperimentFilter -> {
		Object[Protocol, ManualSamplePreparation],
		Object[Protocol, RoboticSamplePreparation],
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
		Object[Protocol, RoboticSamplePreparation],
		Object[Protocol, Incubate]
	},
	ExperimentIncubateCells -> {
		Object[Protocol, ManualCellPreparation],
		Object[Protocol, RoboticCellPreparation],
		Object[Protocol, IncubateCells]
	},
	ExperimentInteractiveTraining -> Object[Protocol, InteractiveTraining],
	ExperimentImageCells -> Object[Protocol, ImageCells],
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
	ExperimentRamanSpectroscopy -> Object[Protocol, RamanSpectroscopy],
	ExperimentResuspend -> {
		Object[Protocol, ManualSamplePreparation],
		Object[Protocol, RoboticSamplePreparation]
	},
	ExperimentSampleManipulation -> Object[Protocol, SampleManipulation],
	ExperimentSolidPhaseExtraction -> Object[Protocol, SolidPhaseExtraction],
	ExperimentSerialDilute -> {
		Object[Protocol, ManualSamplePreparation],
		Object[Protocol, RoboticSamplePreparation],
		Object[Protocol, SerialDilute]
	},
	ExperimentStockSolution -> Object[Protocol, StockSolution],
	ExperimentSupercriticalFluidChromatography -> Object[Protocol, SupercriticalFluidChromatography],
	ExperimentThermalShift -> Object[Protocol, ThermalShift],
	ExperimentTotalProteinDetection -> Object[Protocol, TotalProteinDetection],
	ExperimentTotalProteinQuantification -> Object[Protocol, TotalProteinQuantification],
	ExperimentTransfer -> {
		Object[Protocol, ManualSamplePreparation],
		Object[Protocol, RoboticSamplePreparation],
		Object[Protocol, Transfer]
	},
	ExperimentUncover -> Object[Protocol, Uncover],
	ExperimentVisualInspection -> Object[Protocol, VisualInspection],
	ExperimentWestern -> Object[Protocol, Western],
	MaintenanceInstallGasCylinder -> Object[Maintenance, InstallGasCylinder],
	ExperimentPellet -> {
		Object[Protocol, ManualSamplePreparation],
		Object[Protocol, RoboticSamplePreparation],
		Object[Protocol, Pellet]
	},
	ExperimentBioLayerInterferometry -> Object[Protocol, BioLayerInterferometry],
	ExperimentVapro5600Training -> Object[Protocol, Vapro5600Training],
	ExperimentVisualInspection -> Object[Protocol, VisualInspection],
	ExperimentInoculateLiquidMedia -> Object[Protocol, InoculateLiquidMedia]
|>

