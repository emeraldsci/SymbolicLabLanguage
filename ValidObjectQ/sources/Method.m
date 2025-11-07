

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)



(* ::Section:: *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validMethodQTests*)


validMethodQTests[packet:PacketP[Object[Method]]] := {

	Test["DateCreated is in the past:",
		Lookup[packet,DateCreated],
	    _?(#<=Now&)|Null
	]
};

errorToOptionMap[Object[Method]]:={};


(* ::Subsection::Closed:: *)
(*validMethodWashCellsQTest*)

validMethodWashCellsQTest[packet:PacketP[Object[Method,WashCells]]]:={};

errorToOptionMap[Object[Method,WashCells]]:={};


(* ::Subsection::Closed:: *)
(*validMethodChangeMediaQTest*)

validMethodChangeMediaQTest[packet:PacketP[Object[Method,ChangeMedia]]]:={};

errorToOptionMap[Object[Method,ChangeMedia]]:={};

(* ::Subsection::Closed:: *)
(*validMethodThawCellsQTest*)

validMethodThawCellsQTest[packet:PacketP[Object[Method,ThawCells]]]:={};

errorToOptionMap[Object[Method,ThawCells]]:={};


(* ::Subsection::Closed:: *)
(*validMethodLyseCellsQTest*)

validMethodLyseCellsQTest[packet:PacketP[Object[Method,LyseCells]]]:={};

errorToOptionMap[Object[Method,LyseCells]]:={};

(* ::Subsection::Closed:: *)
(*validMethodWashPlateQTest*)

validMethodWashPlateQTest[packet: PacketP[Object[Method, WashPlate]]]:= {
	RequiredTogetherTest[packet, {AspirateTravelRate, AspiratePositionings, AspirateDelay}],
	RequiredTogetherTest[packet, {FinalAspirateTravelRate, FinalAspiratePositionings, FinalAspirateDelay}],
	RequiredTogetherTest[packet, {DispenseFlowRate, DispensePositionings, DispenseVacuumDelay}],
	NotNullFieldTest[packet, {Instruments, CrosswiseAspiration, FinalAspirate, BottomWash}]
};


(* ::Subsection::Closed:: *)
(*validMethodCleavageQTests*)


validMethodCleavageQTests[packet:PacketP[Object[Method,Cleavage]]]:={

	RequiredTogetherTest[packet,{SwellSolution, SwellVolume, SwellTime}],

	NotNullFieldTest[
		packet,
		{
			CleavageSolution,
			CleavageSolutionVolume,
			CleavageTime,
			CleavageTemperature,
			NumberOfCleavageCycles,
			CleavageWashVolume,
			CleavageWashSolution,
			CleavageTemperature,
			CleavageTime
		}
	]
};

(* ::Subsection::Closed:: *)
(*validMethodCleavageQTests*)


validMethodCleavageQTests[packet:PacketP[Object[Method,RNADeprotection]]]:={

	NotNullFieldTest[
		packet,
		{
			RNADeprotectionResuspensionSolution,
			RNADeprotectionResuspensionVolume,
			RNADeprotectionResuspensionTime,
			RNADeprotectionResuspensionTemperature,
			RNADeprotectionSolution,
			RNADeprotectionSolutionVolume,
			RNADeprotectionSolutionTemperature,
			RNADeprotectionSolutionTime,
			RNADeprotectionQuenchingSolution,
			RNADeprotectionQuenchingSolutionVolume
		}
	]
};


(* ::Subsection::Closed:: *)
(*validMethodFractionCollectionQTests*)

validMethodFractionCollectionQTests[packet:PacketP[Object[Method,FractionCollection]]]:={
	NotNullFieldTest[packet,FractionCollectionMode],

	FieldComparisonTest[packet,{FractionCollectionStartTime,FractionCollectionEndTime},LessEqual],

	Test["If FractionCollectionMode is Threshold, AbsoluteThreshold is informed:",
		Lookup[packet,{FractionCollectionMode,AbsoluteThreshold}],
		{(Threshold),Except[Null]}|{Except[(Threshold)],_}
	],

	Test["If FractionCollectionMode is Time, MaxCollectionPeriod is informed:",
		Lookup[packet,{FractionCollectionMode,MaxCollectionPeriod}],
		{Time,Except[Null]}|{Except[Time],_}
	]
};

(* ::Subsection::Closed:: *)
(*validMethodFragmentAnalysisQTests*)

validMethodFragmentAnalysisQTests[packet:PacketP[Object[Method,FragmentAnalysis]]]:={
	NotNullFieldTest[
		packet,
		{
			AnalysisMethodAuthor,
			ManufacturerMethodName,(*remove when users are allowed to save their own methods*)
			AnalysisStrategy,
			CapillaryArrayLength,
			TargetAnalyteType,
			TargetSampleVolume,
			MaxTargetMassConcentration,
			MinTargetMassConcentration,
			MaxTargetReadLength,
			MinTargetReadLength,
			Ladder,
			LadderRunningBuffer,
			Blank,
			BlankRunningBuffer,
			SampleRunningBuffer,
			SeparationGel,
			Dye,
			ConditioningSolution,
			CapillaryEquilibration,
			PreMarkerRinse,
			MarkerInjection,
			PreSampleRinse,
			SampleInjectionTime,
			SampleInjectionVoltage,
			SeparationTime,
			SeparationVoltage
		}
	]
};


(* ::Subsection::Closed:: *)
(*validMethodGradientQTests*)


validMethodGradientQTests[packet:PacketP[Object[Method,Gradient]]]:={

	Test["Gradient A/B/C/D/E/F/G/H sum to 100%:",
		Module[
			{gradient,gradA,gradB,gradC,gradD,gradE,gradF,gradG,gradH},
			{gradient,gradA,gradB,gradC,gradD,gradE,gradF,gradG,gradH} = Lookup[packet,{Gradient,GradientA,GradientB,GradientC,GradientD,GradientE,GradientF,GradientG,GradientH}];

			If[Not[Or[MatchQ[gradient,{}],MatchQ[{gradA,gradB,gradC,gradD,gradE,gradF,gradG,gradH},ConstantArray[Null,8]]]],
				Plus@@({gradA,gradB,gradC,gradD,gradE,gradF,gradG,gradH}/.{Null->Nothing}),
				{{Null,100 Percent}}
			]
		],
		{{_,_?(Equal[#,100 Percent]&)}..}
	],

	Test["The times listed in the gradient are monotonically increasing:",
		With[
			{gradient = Lookup[packet,Gradient]},
			If[Not[MatchQ[gradient,{}]],
				Differences[gradient[[All,1]]],
				{1 Minute}
			]
		],
		{GreaterP[0 Minute]..}
	]
};

(* ::Subsection::Closed:: *)
(*validMethodSFCGradientQTests*)


validMethodSFCGradientQTests[packet:PacketP[Object[Method,SupercriticalFluidGradient]]]:={

	Test["CO2Gradient, Gradient A, Gradient B, Gradient C, and Gradient D sum to 100%:",
		Module[
			{gradient,co2grad,gradA,gradB,gradC,gradD},
			{gradient,co2grad,gradA,gradB,gradC,gradD} = Lookup[packet,{Gradient,CO2Gradient,GradientA,GradientB,GradientC,GradientD}];

			If[Not[MatchQ[gradient,{}]],
				Plus@@({co2grad,gradA,gradB,gradC,gradD}),
				{{Null,100 Percent}}
			]
		],
		{{_,_?(Equal[#,100 Percent]&)}..}
	],

	Test["The times listed in the gradient are monotonically increasing:",
		With[
			{gradient = Lookup[packet,Gradient]},
			If[Not[MatchQ[gradient,{}]],
				Differences[gradient[[All,1]]],
				{1 Minute}
			]
		],
		{GreaterP[0 Minute]..}
	]
};


(* ::Subsection::Closed:: *)
(*validMethodIonChromatographyGradientQTests*)


validMethodIonChromatographyGradientQTests[packet:PacketP[Object[Method,IonChromatographyGradient]]]:={

	Test["Gradient A, Gradient B, Gradient C, and Gradient D sum to 100%:",
		Module[
			{gradient,gradA,gradB,gradC,gradD},
			{gradient,gradA,gradB,gradC,gradD} = Lookup[packet,{CationGradient,GradientA,GradientB,GradientC,GradientD}];

			If[Not[MatchQ[gradient,{}]],
				Plus@@({gradA,gradB,gradC,gradD}),
				{{Null,100 Percent}}
			]
		],
		{{_,_?(Equal[#,100 Percent]&)}..}
	],

	Test["EluentGradient does not exceed 100 Millimolar:",
		Module[
			{gradient,eluentGradient},
			{gradient,eluentGradient} = Lookup[packet,{AnionGradient,EluentGradient}];

			If[Not[MatchQ[gradient,{}]],
				eluentGradient,
				{{Null,100 Millimolar}}
			]
		],
		{{_,_?(LessEqual[#,100 Millimolar]&)}..}
	],

	Test["The times listed in the gradient are monotonically increasing for cation gradient:",
		With[
			{gradient = Lookup[packet,CationGradient]},
			If[Not[MatchQ[gradient,{}]],
				Differences[gradient[[All,1]]],
				{1 Minute}
			]
		],
		{GreaterP[0 Minute]..}
	],

	Test["The times listed in the gradient are monotonically increasing for anion gradient:",
		With[
			{gradient = Lookup[packet,AnionGradient]},
			If[Not[MatchQ[gradient,{}]],
				Differences[gradient[[All,1]]],
				{1 Minute}
			]
		],
		{GreaterP[0 Minute]..}
	]
};

(* ::Subsection::Closed:: *)
(*validMethodFlowCytometryQTest*)

validMethodFlowCytometryQTest[packet:PacketP[Object[Method,FlowCytometry]]]:={};


(* ::Subsection::Closed:: *)
(*validMethodMassSpectrometryQTests*)

validMethodMassSpectrometryQTests[packet:PacketP[Object[Method,MassSpectrometry]]]:={
	NotNullFieldTest[packet,{MassAnalyzer,IonSource,Calibrant}],
	If[MatchQ[Lookup[packet,MassAnalyzer],QTOF],
		NotNullFieldTest[packet,{Fragmentation,AcquisitionWindows}],
		Nothing
	],
	If[MatchQ[Lookup[packet,IonSource],ESI],
		NotNullFieldTest[packet,{IonMode, ScanTime, ESICapillaryVoltage, DesolvationTemperature, DesolvationGasFlow, SourceTemperature, SourceVoltage, ConeGasFlow, StepwaveVoltage}],
		Nothing
	],
	RequiredTogetherTest[packet,{MinMasses, MaxMasses}],
	RequiredTogetherTest[packet,{LowCollisionEnergies, HighCollisionEnergies}],
	RequiredTogetherTest[packet,{InitialLowCollisionEnergies, InitialHighCollisionEnergies, FinalLowCollisionEnergies, FinalHighCollisionEnergies}],

	UniquelyInformedTest[packet,{MinMasses,MassSelections}],
	UniquelyInformedTest[packet,{CollisionEnergies, LowCollisionEnergies, InitialLowCollisionEnergies}],
	If[MemberQ[Lookup[packet,AcquisitionModes],DataDependent],
		NotNullFieldTest[packet,{AcquisitionSurveys}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,AcquisitionModes],DataDependent],
		NullFieldTest[packet,{MinimumThresholds, AcquisitionLimits, CycleTimeLimits, ExclusionModes, ExclusionMassSelections, ExclusionMassErrors, FragmentScanTimes, ExclusionRetentionTimeErrors, InclusionModes, InclusionMassSelections, InclusionMassErrors, InclusionRetentionTimeErrors, IsotopeExclusionModes}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,ExclusionModes],TimeLimit],
		NullFieldTest[packet,{ExclusionTimeLimits}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,IsotopeExclusionModes],ChargedState],
		NullFieldTest[packet,{ChargeStateSelections, ChargeStateLimits, ChargeStateMassErrors, ChargeStateMassWindows}],
		Nothing
	],
	If[!MemberQ[Lookup[packet,IsotopeExclusionModes],MassDifference],
		NullFieldTest[packet,{IsotopeMassDifferences, IsotopeRatios, IsotopeDetectionMinimums}],
		Nothing
	]
};


(* ::Subsection::Closed:: *)
(*validMethodMassSpectrometryCalibrationQTests*)


validMethodMassSpectrometryCalibrationQTests[packet:PacketP[Object[Method,MassSpectrometryCalibration]]]:={
	NotNullFieldTest[
		packet,
		{
			Calibrant,
			Matrix,
			AccelerationVoltage,
			GridVoltage,
			LensVoltage,
			DelayTime,
			ShotsPerRaster,
			MinLaserPower,
			MaxLaserPower
		}
	],

	FieldComparisonTest[packet,{MinLaserPower,MaxLaserPower},LessEqual]
};


(* ::Subsection::Closed:: *)
(*validMethodSynthesisCycleQTests*)


validMethodSynthesisCycleQTests[packet:PacketP[Object[Method,SynthesisCycle]]] := With[
	{
		synthType = Lookup[packet,SynthesisType]
	},
	Join[
		{
			NotNullFieldTest[packet,SynthesisType]
		},
		Switch[synthType,
			PNA,
				validPNAMethodSynthesisCycleQTests[packet],
			DNA,
				validDNAMethodSynthesisCycleQTests[packet],
			_,
				{}
		]
	]
];



validPNAMethodSynthesisCycleQTests[packet:PacketP[Object[Method,SynthesisCycle]]]:={
	(* needed for gilson/sym*)
	NotNullFieldTest[
		packet,
		{
			WashVolume,
			CappingVolume,
			DeprotectionTime,
			CouplingTime,
			CappingTime,
			NumberOfDeprotections,
			NumberOfDeprotectionWashes,
			NumberOfCappings,
			NumberOfCappingWashes,
			NumberOfCouplingWashes,
			ActivationTimes
		}
	],

	RequiredTogetherTest[packet,{DeprotonationVolume,DeprotonationTime,NumberOfDeprotonations,NumberOfDeprotonationWashes}],
	RequiredTogetherTest[packet,{DeprotectionVolume,DeprotectionTime,NumberOfDeprotections,NumberOfDeprotectionWashes}],
	RequiredTogetherTest[packet,{ActivationVolumes}],
	RequiredTogetherTest[packet,{CouplingTime,NumberOfCouplings,NumberOfCouplingWashes}],
	RequiredTogetherTest[packet,{CappingVolume,CappingTime,NumberOfCappings,NumberOfCappingWashes}],

	(* needed for gilson only *)
	RequiredTogetherTest[packet,{WashPurgeTime, DeprotectionPurgeTime, CappingPurgeTime}],

	Test["Either ActivationVolumes or PreactivationVolumes/BaseVolumes has to be populated:",
		Lookup[packet,{ActivationVolumes,PreactivationVolumes,BaseVolumes}],
		Alternatives[
			{Except[{}], {}, {}},
			{{}, Except[{}], Except[{}]}
		]
	]
};

validDNAMethodSynthesisCycleQTests[packet:PacketP[Object[Method,SynthesisCycle]]]:={
	NotNullFieldTest[
		packet,
		{
			CouplingTime,
			NumberOfCouplings,
			MonomerVolumeRatio
		}
	]
};



(* ::Subsection::Closed:: *)
(*validMethodVacuumEvaporationQTests*)


validMethodVacuumEvaporationQTests[packet:PacketP[Object[Method,VacuumEvaporation]]]:={

	NotNullFieldTest[
		packet,
		{
			CentrifugalForce, PressureRampTime, (*EquilibrationTime,*) EquilibrationPressure, EvaporationPressure, EvaporationTime, ControlledChamberEvacuation
		}
	]
};



(* ::Subsection::Closed:: *)
(*validMethodWaveformQTests*)


validMethodWaveformQTests[packet:PacketP[Object[Method,Waveform]]]:={

	NotNullFieldTest[
		packet,
		{
			ElectrochemicalDetectionMode,WaveformDuration,ReferenceElectrodeMode
		}
	],

	Test["The times listed in the waveform are monotonically increasing:",
		With[
			{waveform = Lookup[packet,Waveform]},
			If[Not[MatchQ[waveform,{}]],
				Differences[waveform[[All,1]]],
				{1 Second}
			]
		],
		{GreaterP[0 Second]..}
	],

	Test["The last time point listed in the waveform equals the value of WaveformDuration field:",
		With[
			{waveform = Lookup[packet,Waveform], waveformDuration = Lookup[packet,WaveformDuration]},
			If[Not[MatchQ[waveform,{}]],
				First[Last[waveform]] == waveformDuration,
				True
			]
		],
		True
	],

	Test["ElectrochemicalDetectionMode is consistent with the waveform specified. Specifically, if the integration happens over a constant voltage, ElectrochemicalDetectionMode is PulsedAmperometricDetection. If the integration happens over multiple voltages, ElectrochemicalDetectionMode is IntegratedPulsedAmperometricDetection:",
		Module[{waveform,integrationVoltages,electrochemicalDetectionMode},

			waveform = Lookup[packet,Waveform];
			integrationVoltages = Cases[waveform,KeyValuePattern[{Integration->True}]][[All,2]];
			electrochemicalDetectionMode = Lookup[packet, ElectrochemicalDetectionMode];

			Which[
				Length[integrationVoltages] == 1,
				electrochemicalDetectionMode == PulsedAmperometricDetection,

				Length[integrationVoltages] > 1,
				electrochemicalDetectionMode == IntegratedPulsedAmperometricDetection,

				True,
				True
			]
		],
		True
	]
};

(* ::Subsection::Closed:: *)
(*validMethodCrystallizationScreeningQTests*)

validMethodCrystallizationScreeningQTests[packet:PacketP[Object[Method,CrystallizationScreening]]]:={};


(* ::Subsection::Closed:: *)
(*validMethodExtractionQTests*)
validMethodExtractionQTests[packet:PacketP[Object[Method, Extraction]]]:={

	NotNullFieldTest[
		packet,
		{
			Lyse,
			Purification
		}
	],

	(* General Extraction Tests *)

	Test["If Lyse is False, then all lysing options are set to Null or {}: ",
		If[
			MatchQ[Lookup[packet, Lyse], False],
			MemberQ[
				Map[
					MatchQ[Lookup[packet, #], Alternatives[Null,{}]]&,
					{CellType, TargetCellularComponent, NumberOfLysisSteps, PreLysisPellet, PreLysisPelletingIntensity, PreLysisPelletingTime, LysisSolution, LysisMixType, LysisMixRate, LysisMixTime, NumberOfLysisMixes, LysisMixTemperature, LysisTime, LysisTemperature, SecondaryLysisSolution, SecondaryLysisMixType, SecondaryLysisMixRate, SecondaryLysisMixTime, SecondaryNumberOfLysisMixes, SecondaryLysisMixTemperature, SecondaryLysisTime, SecondaryLysisTemperature, TertiaryLysisSolution, TertiaryLysisMixType, TertiaryLysisMixRate, TertiaryLysisMixTime, TertiaryNumberOfLysisMixes, TertiaryLysisMixTemperature, TertiaryLysisTime, TertiaryLysisTemperature, ClarifyLysate, ClarifyLysateIntensity, ClarifyLysateTime}
				],
				False
			],
			False
		],
		False
	],

	Test["If there is not a liquid-liquid extraction called for in Purification, then all of the liquid-liquid extraction fields are Null or {}: ",
		If[
			!MemberQ[Lookup[packet, Purification], LiquidLiquidExtraction] && !MatchQ[Lookup[packet, Purification], LiquidLiquidExtraction],
			MemberQ[
				Map[
					MatchQ[Lookup[packet, #], Alternatives[Null,{}]]&,
					{LiquidLiquidExtractionTechnique, LiquidLiquidExtractionDevice, LiquidLiquidExtractionSelectionStrategy, LiquidLiquidExtractionTargetPhase, LiquidLiquidExtractionTargetLayer, AqueousSolvent, AqueousSolventRatio, OrganicSolvent, OrganicSolventRatio, LiquidLiquidExtractionSolventAdditions, Demulsifier, DemulsifierAdditions, LiquidLiquidExtractionTemperature, NumberOfLiquidLiquidExtractions, LiquidLiquidExtractionMixType, LiquidLiquidExtractionMixTime, LiquidLiquidExtractionMixRate, NumberOfLiquidLiquidExtractionMixes, LiquidLiquidExtractionSettlingTime, LiquidLiquidExtractionCentrifuge, LiquidLiquidExtractionCentrifugeIntensity, LiquidLiquidExtractionCentrifugeTime}
				],
				False
			],
			False
		],
		False
	],

	Test["If there is not a precipitation called for in Purification, then all of the precipitation fields are Null or {}: ",
		If[
			!MemberQ[Lookup[packet, Purification], Precipitation]  && !MatchQ[Lookup[packet, Purification], Precipitation],
			MemberQ[
				Map[
					MatchQ[Lookup[packet, #], Alternatives[Null,{}]]&,
					{NumberOfPrecipitationMixes,PrecipitationDryingTemperature,PrecipitationDryingTime,PrecipitationFilter,PrecipitationFilterCentrifugeIntensity,PrecipitationFiltrationPressure,PrecipitationFiltrationTechnique,PrecipitationFiltrationTime,PrecipitationMembraneMaterial,PrecipitationMixRate,PrecipitationMixTemperature,PrecipitationMixTime,PrecipitationMixType,PrecipitationNumberOfResuspensionMixes,PrecipitationNumberOfWashes,PrecipitationNumberOfWashMixes,PrecipitationPelletCentrifugeIntensity,PrecipitationPelletCentrifugeTime,PrecipitationPoreSize,PrecipitationPrefilterMembraneMaterial,PrecipitationPrefilterPoreSize,PrecipitationReagent,PrecipitationReagentEquilibrationTime,PrecipitationReagentTemperature,PrecipitationResuspensionBuffer,PrecipitationResuspensionBufferEquilibrationTime,PrecipitationResuspensionBufferTemperature,PrecipitationResuspensionMixRate,PrecipitationResuspensionMixTemperature,PrecipitationResuspensionMixTime,PrecipitationResuspensionMixType,PrecipitationSeparationTechnique,PrecipitationTargetPhase,PrecipitationTemperature,PrecipitationTime,PrecipitationWashCentrifugeIntensity,PrecipitationWashMixRate,PrecipitationWashMixTemperature,PrecipitationWashMixTime,PrecipitationWashMixType,PrecipitationWashPrecipitationTemperature,PrecipitationWashPrecipitationTime,PrecipitationWashPressure,PrecipitationWashSeparationTime,PrecipitationWashSolution,PrecipitationWashSolutionEquilibrationTime,PrecipitationWashSolutionTemperature}
				],
				False
			],
			False
		],
		False
	],

	Test["If there is not a solid phase extraction called for in Purification, then all of the solid phase extraction fields are Null or {}: ",
		If[
			!MemberQ[Lookup[packet, Purification], SolidPhaseExtraction]&& !MatchQ[Lookup[packet, Purification], SolidPhaseExtraction],
			MemberQ[
				Map[
					MatchQ[Lookup[packet, #], Alternatives[Null,{}]]&,
					{SecondarySolidPhaseExtractionWashCentrifugeIntensity,SecondarySolidPhaseExtractionWashPressure,SecondarySolidPhaseExtractionWashSolution,SecondarySolidPhaseExtractionWashTemperature,SecondarySolidPhaseExtractionWashTemperatureEquilibrationTime,SecondarySolidPhaseExtractionWashTime,SolidPhaseExtractionCartridge,SolidPhaseExtractionElutionCentrifugeIntensity,SolidPhaseExtractionElutionPressure,SolidPhaseExtractionElutionSolution,SolidPhaseExtractionElutionSolutionTemperature,SolidPhaseExtractionElutionSolutionTemperatureEquilibrationTime,SolidPhaseExtractionElutionTime,SolidPhaseExtractionLoadingCentrifugeIntensity,SolidPhaseExtractionLoadingPressure,SolidPhaseExtractionLoadingTemperature,SolidPhaseExtractionLoadingTemperatureEquilibrationTime,SolidPhaseExtractionLoadingTime,SolidPhaseExtractionSeparationMode,SolidPhaseExtractionSorbent,SolidPhaseExtractionStrategy,SolidPhaseExtractionTechnique,SolidPhaseExtractionWashCentrifugeIntensity,SolidPhaseExtractionWashPressure,SolidPhaseExtractionWashSolution,SolidPhaseExtractionWashTemperature,SolidPhaseExtractionWashTemperatureEquilibrationTime,SolidPhaseExtractionWashTime,TertiarySolidPhaseExtractionWashCentrifugeIntensity,TertiarySolidPhaseExtractionWashPressure,TertiarySolidPhaseExtractionWashSolution,TertiarySolidPhaseExtractionWashTemperature,TertiarySolidPhaseExtractionWashTemperatureEquilibrationTime,TertiarySolidPhaseExtractionWashTime}
				],
				False
			],
			False
		],
		False
	],

	Test["If there is not a magnetic bead separation called for in Purification, then all of the magnetic bead separation fields are Null or {}: ",
		If[
			!MemberQ[Lookup[packet, Purification], MagneticBeadSeparation] && !MatchQ[Lookup[packet, Purification], MagneticBeadSeparation],
			MemberQ[
				Map[
					MatchQ[Lookup[packet, #], Alternatives[Null,{}]]&,
					{ElutionMagnetizationTime,EquilibrationMagnetizationTime,LoadingMagnetizationTime,MagneticBeadAffinityLabel,MagneticBeads,MagneticBeadSeparationAnalyteAffinityLabel,MagneticBeadSeparationElution,MagneticBeadSeparationElutionMix,MagneticBeadSeparationElutionMixRate,MagneticBeadSeparationElutionMixTemperature,MagneticBeadSeparationElutionMixTime,MagneticBeadSeparationElutionMixType,MagneticBeadSeparationElutionSolution,MagneticBeadSeparationEquilibration,MagneticBeadSeparationEquilibrationAirDry,MagneticBeadSeparationEquilibrationAirDryTime,MagneticBeadSeparationEquilibrationMix,MagneticBeadSeparationEquilibrationMixRate,MagneticBeadSeparationEquilibrationMixTemperature,MagneticBeadSeparationEquilibrationMixTime,MagneticBeadSeparationEquilibrationMixType,MagneticBeadSeparationEquilibrationSolution,MagneticBeadSeparationLoadingAirDry,MagneticBeadSeparationLoadingAirDryTime,MagneticBeadSeparationLoadingMix,MagneticBeadSeparationLoadingMixRate,MagneticBeadSeparationLoadingMixTemperature,MagneticBeadSeparationLoadingMixTime,MagneticBeadSeparationLoadingMixType,MagneticBeadSeparationMode,MagneticBeadSeparationPreWash,MagneticBeadSeparationPreWashAirDry,MagneticBeadSeparationPreWashAirDryTime,MagneticBeadSeparationPreWashMix,MagneticBeadSeparationPreWashMixRate,MagneticBeadSeparationPreWashMixTemperature,MagneticBeadSeparationPreWashMixTime,MagneticBeadSeparationPreWashMixType,MagneticBeadSeparationPreWashSolution,MagneticBeadSeparationQuaternaryWash,MagneticBeadSeparationQuaternaryWashAirDry,MagneticBeadSeparationQuaternaryWashAirDryTime,MagneticBeadSeparationQuaternaryWashMix,MagneticBeadSeparationQuaternaryWashMixRate,MagneticBeadSeparationQuaternaryWashMixTemperature,MagneticBeadSeparationQuaternaryWashMixTime,MagneticBeadSeparationQuaternaryWashMixType,MagneticBeadSeparationQuaternaryWashSolution,MagneticBeadSeparationQuinaryWash,MagneticBeadSeparationQuinaryWashAirDry,MagneticBeadSeparationQuinaryWashAirDryTime,MagneticBeadSeparationQuinaryWashMix,MagneticBeadSeparationQuinaryWashMixRate,MagneticBeadSeparationQuinaryWashMixTemperature,MagneticBeadSeparationQuinaryWashMixTime,MagneticBeadSeparationQuinaryWashMixType,MagneticBeadSeparationQuinaryWashSolution,MagneticBeadSeparationSecondaryWash,MagneticBeadSeparationSecondaryWashAirDry,MagneticBeadSeparationSecondaryWashAirDryTime,MagneticBeadSeparationSecondaryWashMix,MagneticBeadSeparationSecondaryWashMixRate,MagneticBeadSeparationSecondaryWashMixTemperature,MagneticBeadSeparationSecondaryWashMixTime,MagneticBeadSeparationSecondaryWashMixType,MagneticBeadSeparationSecondaryWashSolution,MagneticBeadSeparationSelectionStrategy,MagneticBeadSeparationSenaryWash,MagneticBeadSeparationSenaryWashAirDry,MagneticBeadSeparationSenaryWashAirDryTime,MagneticBeadSeparationSenaryWashMix,MagneticBeadSeparationSenaryWashMixRate,MagneticBeadSeparationSenaryWashMixTemperature,MagneticBeadSeparationSenaryWashMixTime,MagneticBeadSeparationSenaryWashMixType,MagneticBeadSeparationSenaryWashSolution,MagneticBeadSeparationSeptenaryWash,MagneticBeadSeparationSeptenaryWashAirDry,MagneticBeadSeparationSeptenaryWashAirDryTime,MagneticBeadSeparationSeptenaryWashMix,MagneticBeadSeparationSeptenaryWashMixRate,MagneticBeadSeparationSeptenaryWashMixTemperature,MagneticBeadSeparationSeptenaryWashMixTime,MagneticBeadSeparationSeptenaryWashMixType,MagneticBeadSeparationSeptenaryWashSolution,MagneticBeadSeparationTertiaryWash,MagneticBeadSeparationTertiaryWashAirDry,MagneticBeadSeparationTertiaryWashAirDryTime,MagneticBeadSeparationTertiaryWashMix,MagneticBeadSeparationTertiaryWashMixRate,MagneticBeadSeparationTertiaryWashMixTemperature,MagneticBeadSeparationTertiaryWashMixTime,MagneticBeadSeparationTertiaryWashMixType,MagneticBeadSeparationTertiaryWashSolution,MagneticBeadSeparationWash,MagneticBeadSeparationWashAirDry,MagneticBeadSeparationWashAirDryTime,MagneticBeadSeparationWashMix,MagneticBeadSeparationWashMixRate,MagneticBeadSeparationWashMixTemperature,MagneticBeadSeparationWashMixTime,MagneticBeadSeparationWashMixType,MagneticBeadSeparationWashSolution,NumberOfMagneticBeadSeparationElutionMixes,NumberOfMagneticBeadSeparationElutions,NumberOfMagneticBeadSeparationEquilibrationMixes,NumberOfMagneticBeadSeparationLoadingMixes,NumberOfMagneticBeadSeparationPreWashes,NumberOfMagneticBeadSeparationPreWashMixes,NumberOfMagneticBeadSeparationQuaternaryWashes,NumberOfMagneticBeadSeparationQuaternaryWashMixes,NumberOfMagneticBeadSeparationQuinaryWashes,NumberOfMagneticBeadSeparationQuinaryWashMixes,NumberOfMagneticBeadSeparationSecondaryWashes,NumberOfMagneticBeadSeparationSecondaryWashMixes,NumberOfMagneticBeadSeparationSenaryWashes,NumberOfMagneticBeadSeparationSenaryWashMixes,NumberOfMagneticBeadSeparationSeptenaryWashes,NumberOfMagneticBeadSeparationSeptenaryWashMixes,NumberOfMagneticBeadSeparationTertiaryWashes,NumberOfMagneticBeadSeparationTertiaryWashMixes,NumberOfMagneticBeadSeparationWashes,NumberOfMagneticBeadSeparationWashMixes,PreWashMagnetizationTime,QuaternaryWashMagnetizationTime,QuinaryWashMagnetizationTime,SecondaryWashMagnetizationTime,SenaryWashMagnetizationTime,SeptenaryWashMagnetizationTime,TertiaryWashMagnetizationTime,WashMagnetizationTime}
				],
				False
			],
			False
		],
		False
	]

};

(* ::Subsection::Closed:: *)
(*validMethodLyseCellsQTests*)
validMethodLyseCellsQTests[packet:PacketP[Object[Method, LyseCells]]]:={

	Test["NumberOfLysisSteps is not greater than 3: ",
		MatchQ[Lookup[packet, NumberOfLysisSteps], (LessEqualP[3]|Null)],
		True
	],

	Test["If NumberOfLysisSteps is 1, all secondary and tertiary lysis options are Null: ",
		If[
			MatchQ[Lookup[packet, NumberOfLysisSteps], 1],
			MatchQ[Lookup[packet,
				{
					SecondaryLysisSolution, SecondaryMixType, SecondaryMixRate, SecondaryMixTime, SecondaryNumberOfMixes, SecondaryMixTemperature, SecondaryLysisTime, SecondaryLysisTemperature,
					TertiaryLysisSolution, TertiaryMixType, TertiaryMixRate, TertiaryMixTime, TertiaryNumberOfMixes, TertiaryMixTemperature, TertiaryLysisTime, TertiaryLysisTemperature
				}
			], NullP],
			True
		],
		True
	],

	Test["If NumberOfLysisSteps is 2, all tertiary lysis options are Null: ",
		If[
			MatchQ[Lookup[packet, NumberOfLysisSteps], 2],
			MatchQ[Lookup[packet,
				{
					TertiaryLysisSolution, TertiaryMixType, TertiaryMixRate, TertiaryMixTime, TertiaryNumberOfMixes, TertiaryMixTemperature, TertiaryLysisTime, TertiaryLysisTemperature
				}
			], NullP],
			True
		],
		True
	],

	Test["If MixType is None, then all other primary mixing options are Null: ",
		If[
			MatchQ[Lookup[packet, MixType], (None|Null)],
			MatchQ[Lookup[packet, {MixTime, MixTime, NumberOfMixes, MixTemperature}], NullP],
			True
		],
		True
	],

	Test["If SecondaryMixType is None, then all other secondary mixing options are Null: ",
		If[
			MatchQ[Lookup[packet, SecondaryMixType], (None|Null)],
			MatchQ[Lookup[packet, {SecondaryMixTime, SecondaryMixTime, SecondaryNumberOfMixes, SecondaryMixTemperature}], NullP],
			True
		],
		True
	],

	Test["If TertiaryMixType is None, then all other tertiary mixing options are Null: ",
		If[
			MatchQ[Lookup[packet, TertiaryMixType], (None|Null)],
			MatchQ[Lookup[packet, {TertiaryMixTime, TertiaryMixTime, TertiaryNumberOfMixes, TertiaryMixTemperature}], NullP],
			True
		],
		True
	],

	Test["If MixType is Shake, then NumberOfMixes is Null: ",
		If[
			MatchQ[Lookup[packet, MixType], Shake],
			MatchQ[Lookup[packet, NumberOfMixes], Null],
			True
		],
		True
	],

	Test["If SecondaryMixType is Shake, then SecondaryNumberOfMixes is Null: ",
		If[
			MatchQ[Lookup[packet, SecondaryMixType], Shake],
			MatchQ[Lookup[packet, SecondaryNumberOfMixes], Null],
			True
		],
		True
	],

	Test["If TertiaryMixType is Shake, then TertiaryNumberOfMixes is Null: ",
		If[
			MatchQ[Lookup[packet, TertiaryMixType], Shake],
			MatchQ[Lookup[packet, TertiaryNumberOfMixes], Null],
			True
		],
		True
	],

	Test["If MixType is Pipette, then MixTime and MixRate are Null and MixTemperature is Null, Ambient, or " <>ToString[$AmbientTemperature]<>": ",
		If[
			MatchQ[Lookup[packet, MixType], Pipette],
			MatchQ[Lookup[packet, {MixTime, MixRate}], NullP] && MatchQ[Lookup[packet, MixTemperature], (Null|AmbientTemperatureP)],
			True
		],
		True
	],

	Test["If SecondaryMixType is Pipette, then SecondaryMixTime and SecondaryMixRate are Null and SecondaryMixTemperature is Null, Ambient, or " <>ToString[$AmbientTemperature]<>": ",
		If[
			MatchQ[Lookup[packet, SecondaryMixType], Pipette],
			MatchQ[Lookup[packet, {SecondaryMixTime, SecondaryMixRate}], NullP] && MatchQ[Lookup[packet, SecondaryMixTemperature], (Null|AmbientTemperatureP)],
			True
		],
		True
	],

	Test["If TertiaryMixType is Pipette, then TertiaryMixTime and TertiaryMixRate are Null and TertiaryMixTemperature is Null, Ambient, or " <>ToString[$AmbientTemperature]<>": ",
		If[
			MatchQ[Lookup[packet, TertiaryMixType], Pipette],
			MatchQ[Lookup[packet, {TertiaryMixTime, TertiaryMixRate}], NullP] && MatchQ[Lookup[packet, TertiaryMixTemperature], (Null|AmbientTemperatureP)],
			True
		],
		True
	],

	Test["If PreLysisPellet is False, then PreLysisPelletingTime and PreLysisPelletingIntensity are both Null: ",
		If[
			MatchQ[Lookup[packet, PreLysisPellet], False],
			MatchQ[Lookup[packet, {PreLysisPelletingTime, PreLysisPelletingIntensity}], NullP],
			True
		],
		True
	],

	Test["If ClarifyLysate is False, then ClarifyLysateTime and ClarifyLysateIntensity are both Null: ",
		If[
			MatchQ[Lookup[packet, ClarifyLysate], False],
			MatchQ[Lookup[packet, {ClarifyLysateTime, ClarifyLysateIntensity}], NullP],
			True
		],
		True
	]

};

(* ::Subsection::Closed:: *)
(*validMethodExtractionProteinQTests*)
validMethodExtractionProteinQTests[packet:PacketP[Object[Method, Extraction, Protein]]]:={
	Test["If TargetProtein is a Model[Molecule], Purification should include at lease one of separation modes for SPE/MBS is set to be Affinity",
		If[MatchQ[Lookup[packet, TargetProtein], ObjectP[Model[Molecule]]],
			MemberQ[ToList@Lookup[packet, Purification],Alternatives[SolidPhaseExtraction,MagneticBeadSeparation]]&&
       MemberQ[Map[Lookup[packet,#]&,{MagneticBeadSeparationMode,SolidPhaseExtractionSeparationMode}],Affinity],
			True
		],
		True
	],
	Test["If TargetProtein is All, Purification should not include any separation modes for SPE/MBS of Affinity",
		If[MatchQ[Lookup[packet, TargetProtein], All]&&MemberQ[ToList@Lookup[packet, Purification],Alternatives[SolidPhaseExtraction,MagneticBeadSeparation]]&&
       MemberQ[Map[Lookup[packet,#]&,{MagneticBeadSeparationMode,SolidPhaseExtractionSeparationMode}],Affinity],
			True,
			False
		],
		False
	]
};

(* ::Subsection::Closed:: *)
(*validMethodExtractionRNAQTests*)
validMethodExtractionRNAQTests[packet:PacketP[Object[Method, Extraction, RNA]]]:={
	NotNullFieldTest[
		packet,
		{
			HomogenizeLysate
		}
	]
};

(* ::Subsection::Closed:: *)
(*validMethodExtractionPlasmidDNAQTests*)
validMethodExtractionPlasmidDNAQTests[packet:PacketP[Object[Method, Extraction, PlasmidDNA]]]:={
	NotNullFieldTest[
		packet,
		{
			Neutralize
		}
	],

	Test["If Neutralize is False, then all Neutralization options are set to Null or {}: ",
		If[
			MatchQ[Lookup[packet, Neutralize], False],
			MemberQ[
				Map[
					MatchQ[Lookup[packet, #], Alternatives[Null,{}]]&,
					{NeutralizationSeparationTechnique, NeutralizationReagent, NeutralizationReagentTemperature, NeutralizationReagentEquilibrationTime, NeutralizationMixType, NeutralizationMixTemperature, NeutralizationMixRate, NeutralizationMixTime, NumberOfNeutralizationMixes, NeutralizationSettlingTime, NeutralizationSettlingTemperature, NeutralizationFiltrationTechnique, NeutralizationFilter, NeutralizationPrefilterPoreSize, NeutralizationPrefilterMembraneMaterial, NeutralizationPoreSize, NeutralizationMembraneMaterial, NeutralizationFilterCentrifugeIntensity, NeutralizationFiltrationPressure, NeutralizationFiltrationTime, NeutralizationPelletCentrifugeIntensity, NeutralizationPelletCentrifugeTime}
				],
				False
			],
			False
		],
		False
	]

};


(* ::Subsection::Closed:: *)
(*validMethodLyseCellsQTests*)
validMethodLyseCellsQTests[packet:PacketP[Object[Method, LyseCells]]]:={

	Test["NumberOfLysisSteps is not greater than 3: ",
		MatchQ[Lookup[packet, NumberOfLysisSteps], (LessEqualP[3]|Null)],
		True
	],

	Test["If NumberOfLysisSteps is 1, all secondary and tertiary lysis options are Null: ",
		If[
			MatchQ[Lookup[packet, NumberOfLysisSteps], 1],
			MatchQ[Lookup[packet,
				{
					SecondaryLysisSolution, SecondaryMixType, SecondaryMixRate, SecondaryMixTime, SecondaryNumberOfMixes, SecondaryMixTemperature, SecondaryLysisTime, SecondaryLysisTemperature,
					TertiaryLysisSolution, TertiaryMixType, TertiaryMixRate, TertiaryMixTime, TertiaryNumberOfMixes, TertiaryMixTemperature, TertiaryLysisTime, TertiaryLysisTemperature
				}
			], NullP],
			True
		],
		True
	],

	Test["If NumberOfLysisSteps is 2, all tertiary lysis options are Null: ",
		If[
			MatchQ[Lookup[packet, NumberOfLysisSteps], 2],
			MatchQ[Lookup[packet,
				{
					TertiaryLysisSolution, TertiaryMixType, TertiaryMixRate, TertiaryMixTime, TertiaryNumberOfMixes, TertiaryMixTemperature, TertiaryLysisTime, TertiaryLysisTemperature
				}
			], NullP],
			True
		],
		True
	],

	Test["If MixType is None, then all other primary mixing options are Null: ",
		If[
			MatchQ[Lookup[packet, MixType], (None|Null)],
			MatchQ[Lookup[packet, {MixTime, MixTime, NumberOfMixes, MixTemperature}], NullP],
			True
		],
		True
	],

	Test["If SecondaryMixType is None, then all other secondary mixing options are Null: ",
		If[
			MatchQ[Lookup[packet, SecondaryMixType], (None|Null)],
			MatchQ[Lookup[packet, {SecondaryMixTime, SecondaryMixTime, SecondaryNumberOfMixes, SecondaryMixTemperature}], NullP],
			True
		],
		True
	],

	Test["If TertiaryMixType is None, then all other tertiary mixing options are Null: ",
		If[
			MatchQ[Lookup[packet, TertiaryMixType], (None|Null)],
			MatchQ[Lookup[packet, {TertiaryMixTime, TertiaryMixTime, TertiaryNumberOfMixes, TertiaryMixTemperature}], NullP],
			True
		],
		True
	],

	Test["If MixType is Shake, then NumberOfMixes is Null: ",
		If[
			MatchQ[Lookup[packet, MixType], Shake],
			MatchQ[Lookup[packet, NumberOfMixes], Null],
			True
		],
		True
	],

	Test["If SecondaryMixType is Shake, then SecondaryNumberOfMixes is Null: ",
		If[
			MatchQ[Lookup[packet, SecondaryMixType], Shake],
			MatchQ[Lookup[packet, SecondaryNumberOfMixes], Null],
			True
		],
		True
	],

	Test["If TertiaryMixType is Shake, then TertiaryNumberOfMixes is Null: ",
		If[
			MatchQ[Lookup[packet, TertiaryMixType], Shake],
			MatchQ[Lookup[packet, TertiaryNumberOfMixes], Null],
			True
		],
		True
	],

	Test["If MixType is Pipette, then MixTime and MixRate are Null and MixTemperature is Null, Ambient, or " <>ToString[$AmbientTemperature]<>": ",
		If[
			MatchQ[Lookup[packet, MixType], Pipette],
			MatchQ[Lookup[packet, {MixTime, MixRate}], NullP] && MatchQ[Lookup[packet, MixTemperature], (Null|AmbientTemperatureP)],
			True
		],
		True
	],

	Test["If SecondaryMixType is Pipette, then SecondaryMixTime and SecondaryMixRate are Null and SecondaryMixTemperature is Null, Ambient, or " <>ToString[$AmbientTemperature]<>": ",
		If[
			MatchQ[Lookup[packet, SecondaryMixType], Pipette],
			MatchQ[Lookup[packet, {SecondaryMixTime, SecondaryMixRate}], NullP] && MatchQ[Lookup[packet, SecondaryMixTemperature], (Null|AmbientTemperatureP)],
			True
		],
		True
	],

	Test["If TertiaryMixType is Pipette, then TertiaryMixTime and TertiaryMixRate are Null and TertiaryMixTemperature is Null, Ambient, or " <>ToString[$AmbientTemperature]<>": ",
		If[
			MatchQ[Lookup[packet, TertiaryMixType], Pipette],
			MatchQ[Lookup[packet, {TertiaryMixTime, TertiaryMixRate}], NullP] && MatchQ[Lookup[packet, TertiaryMixTemperature], (Null|AmbientTemperatureP)],
			True
		],
		True
	],

	Test["If PreLysisPellet is False, then PreLysisPelletingTime and PreLysisPelletingIntensity are both Null: ",
		If[
			MatchQ[Lookup[packet, PreLysisPellet], False],
			MatchQ[Lookup[packet, {PreLysisPelletingTime, PreLysisPelletingIntensity}], NullP],
			True
		],
		True
	],

	Test["If ClarifyLysate is False, then ClarifyLysateTime and ClarifyLysateIntensity are both Null: ",
		If[
			MatchQ[Lookup[packet, ClarifyLysate], False],
			MatchQ[Lookup[packet, {ClarifyLysateTime, ClarifyLysateIntensity}], NullP],
			True
		],
		True
	]

};

(* ::Subsection::Closed:: *)
(* Test Registration *)
registerValidQTestFunction[Object[Method],validMethodQTests];
registerValidQTestFunction[Object[Method, Cleavage],validMethodCleavageQTests];
registerValidQTestFunction[Object[Method, ThawCells],validMethodThawCellsQTest];
registerValidQTestFunction[Object[Method, ChangeMedia],validMethodChangeMediaQTest];
registerValidQTestFunction[Object[Method, WashCells],validMethodWashCellsQTest];
registerValidQTestFunction[Object[Method, WashPlate],validMethodWashPlateQTest];
registerValidQTestFunction[Object[Method, FlowCytometry],validMethodFlowCytometryQTest];
registerValidQTestFunction[Object[Method, FractionCollection],validMethodFractionCollectionQTests];
registerValidQTestFunction[Object[Method, FragmentAnalysis],validMethodFragmentAnalysisQTests];
registerValidQTestFunction[Object[Method, Gradient],validMethodGradientQTests];
registerValidQTestFunction[Object[Method, IonChromatographyGradient],validMethodIonChromatographyGradientQTests];
registerValidQTestFunction[Object[Method, SupercriticalFluidGradient],validMethodSFCGradientQTests];
registerValidQTestFunction[Object[Method, CrystallizationScreening],validMethodCrystallizationScreeningQTests];
registerValidQTestFunction[Object[Method, MassSpectrometry],validMethodMassSpectrometryQTests];
registerValidQTestFunction[Object[Method, MassSpectrometryCalibration],validMethodMassSpectrometryCalibrationQTests];
registerValidQTestFunction[Object[Method, SynthesisCycle],validMethodSynthesisCycleQTests];
registerValidQTestFunction[Object[Method, VacuumEvaporation],validMethodVacuumEvaporationQTests];
registerValidQTestFunction[Object[Method, Waveform],validMethodWaveformQTests];
registerValidQTestFunction[Object[Method, LyseCells],validMethodLyseCellsQTests];
registerValidQTestFunction[Object[Method, Extraction],validMethodExtractionQTests];
registerValidQTestFunction[Object[Method, Extraction, Protein],validMethodExtractionProteinQTests];
registerValidQTestFunction[Object[Method, Extraction, RNA],validMethodExtractionRNAQTests];
registerValidQTestFunction[Object[Method, Extraction, PlasmidDNA],validMethodExtractionPlasmidDNAQTests];
