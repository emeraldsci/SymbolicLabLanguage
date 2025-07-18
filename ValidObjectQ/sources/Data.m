(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* Begin Private Context *)
(*Source Code*)


(* ::Subsection::Closed:: *)
(*validDataQTests*)


validDataQTests[packet:PacketP[Object[Data]]] := {

	NotNullFieldTest[packet, DateCreated],

	Test["If DateCreated is informed, it is in the past:",
		Lookup[packet, DateCreated],
		Alternatives[
			Null,{},
			_?(#<=Now&)
		]
	],

	If[MatchQ[Lookup[packet,Protocol],ObjectP[]],
		Module[
			{protNotebook},

			protNotebook = Download[Lookup[packet,Protocol],Notebook[Object]];

			Test["If the linked Protocol has a notebook, the data shares that same notebook:",
				MatchQ[
					Download[Lookup[packet,Notebook],Object],
					protNotebook
				],
				True
			]
		],
		Nothing
	]
};


(* ::Subsection::Closed:: *)
(*validDataAbsorbanceIntensityQTests*)


validDataAbsorbanceIntensityQTests[packet:PacketP[Object[Data,AbsorbanceIntensity]]]:={
	(* Shared Fields which should NOT be null *)
	UniquelyInformedTest[packet, {Instrument, Sensor}],
	UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],


	(* Unique Fields which should NOT be null *)
	NotNullFieldTest[packet,{DataType,Instrument}],

	(* Shared Fields which should be null *)
	NullFieldTest[packet,{SamplesOut,Sensor}],

	(* doublecheck that NumberOfReadings is Null for Lunatic and an Integer for all other instrument models *)
	Test["If Instrument -> Lunatic, then NumberOfReadings is Null; otherwise the NumberOfReadings must be an integer:",
		{Download[Lookup[packet,Instrument],Model[Object]],Lookup[packet,NumberOfReadings]},
		Alternatives[
			{ObjectP[Model[Instrument, PlateReader, "id:N80DNj1lbD66"]],Null},
			{_,_Integer}
		]
	],

	(* data type vs links *)
	Test["Data type and link field should NOT match:",
		Lookup[packet,{DataType, BlankAbsorbance, AnalyteAbsorbances}],
		{Null,_,_}|{Blank,Null,_}|{Analyte,_,{}}
	],

	(* If using the Lunatic, data may not be populated *)
	Test["If absorbance spectrum was taken on Lunatic instrument, the AbsorbanceSpectrum field may be Null:",
		{Download[Lookup[packet, Instrument], Model[Object]], Lookup[packet, Absorbance]},
		{ObjectP[Model[Instrument, PlateReader, "Lunatic"]], _} | {_, Except[Null]}
	],

	(* analysis *)
	If[MatchQ[Concentration/.packet, Null], (*Concentration or MassConcentration*)
		RequiredTogetherTest[packet,{QuantificationAnalyses,DilutedMassConcentration,MassConcentration,PathLength,PathLengthMethod}],
		RequiredTogetherTest[packet,{QuantificationAnalyses,DilutedConcentration,Concentration,PathLength,PathLengthMethod}]
	]
};


(* ::Subsection::Closed:: *)
(*validDataAbsorbanceKineticsQTests*)


validDataAbsorbanceKineticsQTests[packet:PacketP[Object[Data,AbsorbanceKinetics]]]:={
	(* Shared Fields which should NOT be null *)
	UniquelyInformedTest[packet, {Instrument, Sensor}],
	UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],

	(* Shared Fields which should be null *)
	NullFieldTest[packet,{SamplesOut,Sensor}],

	(* Unique Fields which should NOT be null *)
	NotNullFieldTest[packet,{Well,NumberOfReadings,DataType,DataFile,Instrument}],

	(* MinWavelength < MaxWavelength *)
	FieldComparisonTest[packet,{MinWavelength,MaxWavelength},Less],

	(* Either a range is fully specified or a set of discrete wavelengths is provided *)
	(* When discrete wavelengths are given, data will be returned as a set of trajectories. When a span is given we'll return 3D data *)
	RequiredTogetherTest[packet,{MinWavelength,MaxWavelength,AbsorbanceTrajectory3D}],
	UniquelyInformedTest[packet,{MinWavelength,Wavelengths}],
	RequiredTogetherTest[packet,{Wavelengths,AbsorbanceTrajectories}],
	UniquelyInformedTest[packet,{AbsorbanceTrajectories,AbsorbanceTrajectory3D}],
	(* Following test does not apply to analytes - not sure if there's a better way to skip the test *)
	If[MatchQ[Lookup[packet,DataType],Except[Analyte]],
		UniquelyInformedTest[packet,{UnblankedAbsorbanceTrajectories,UnblankedAbsorbanceTrajectory3D}],
		NotNullFieldTest[packet,DataType]
	],

	(* If there are injections, make sure all info is specified *)
	RequiredTogetherTest[packet,{InjectionSamples,InjectionTimes,InjectionVolumes,InjectionFlowRates}],

	Test["Only analyte data may have corresponding unblanked trajectories and point to the data gathered for the blank:",
		Lookup[packet,{DataType,BlankTrajectory,UnblankedAbsorbanceTrajectories,UnblankedAbsorbanceTrajectory3D}],
		Alternatives[
			{Blank,Null,{},Null},
			{Analyte,Null,{},Null},
			{Analyte,ObjectP[],{QuantityMatrixP[]..},Null},
			{Analyte,ObjectP[],{},QuantityMatrixP[]}
		]
	]
};


(* ::Subsection::Closed:: *)
(*validDataAbsorbanceSpectroscopyQTests*)


validDataAbsorbanceSpectroscopyQTests[packet:PacketP[Object[Data,AbsorbanceSpectroscopy]]]:={
	(* Shared Fields which should NOT be null *)
	UniquelyInformedTest[packet, {Instrument, Sensor}],
	UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],


	(* Unique Fields which should NOT be null *)
	NotNullFieldTest[packet,{DataType,DataFile,Instrument}],

	(* Shared Fields which should be null *)
	NullFieldTest[packet,{SamplesOut,Sensor}],

	(* doublecheck that NumberOfReadings is Null for Lunatic and an Integer for all other instrument models *)
	Test["If Instrument -> Lunatic, then NumberOfReadings is Null; otherwise the NumberOfReadings must be an integer:",
		{Download[Lookup[packet,Instrument],Model[Object]],Lookup[packet,NumberOfReadings]},
		Alternatives[
			{ObjectP[Model[Instrument, PlateReader, "id:N80DNj1lbD66"]],Null},
			{_,_Integer}
		]
	],

	(* data type vs links *)
	Test["Data type and link field should NOT match:",
		Lookup[packet,{DataType,EmptySpectrum,BlankSpectrum,AnalyteSpectrum}],
		{Null,_,_,_}|{Empty,Null,_,_}|{Blank,_,Null,_}|{Analyte,_,_,Null}
	],

	(* If using the Lunatic, data may not be populated *)
	Test["If absorbance spectrum was taken on Lunatic instrument, the AbsorbanceSpectrum field may be Null:",
		{Download[Lookup[packet, Instrument], Model[Object]], Lookup[packet, AbsorbanceSpectrum]},
		{ObjectP[Model[Instrument, PlateReader, "Lunatic"]], _} | {_, Except[Null]}
	],

	(* max two of the link fields are informed *)
	Test["All three of the data-linking fields cannot be informed:",
		Count[Lookup[packet,{EmptySpectrum,BlankSpectrum,AnalyteSpectrum}],NullP],
		GreaterP[0,1]
	],

	(* analysis *)
	If[MatchQ[Concentration/.packet, Null], (*Concentration or MassConcentration*)
		RequiredTogetherTest[packet,{QuantificationAnalyses,DilutedMassConcentration,MassConcentration,PathLength,PathLengthMethod}],
		RequiredTogetherTest[packet,{QuantificationAnalyses,DilutedConcentration,Concentration,PathLength,PathLengthMethod}]
	]
};


(* ::Subsection:: *)
(*validDataAcousticLiquidHandlingQTests*)


validDataAcousticLiquidHandlingQTests[packet:PacketP[Object[Data,AcousticLiquidHandling]]]:={
	(* Shared Fields which should NOT be null *)
	UniquelyInformedTest[packet,{Instrument,Sensor}],
	UniquelyInformedTest[packet,{Protocol,Qualifications,Maintenance}],


	NotNullFieldTest[packet,{
		(* not null shared fields *)
		DataFile,
		SamplesIn,
		SamplesOut,

		(* not null unique fields *)
		SourcePosition,
		ResolvedManipulations,
		TransferHistory,
		InitialVolume,
		TransferVolume,
		FinalVolume,
		WellFluidHeight,
		FluidAnalysis
	}
	]
};



(* ::Subsection::Closed:: *)
(*validDataAgaroseGelElectrophoresisQTests*)


validDataAgaroseGelElectrophoresisQTests[packet:PacketP[Object[Data,AgaroseGelElectrophoresis]]]:={

	(* Shared Fields which should NOT be null *)
	UniquelyInformedTest[packet, {Instrument, Sensor}],
	UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],

	(* Unique or Shared Fields which should NOT be null *)
	NotNullFieldTest[
		packet,
		{
			Scale,GelModel,GelMaterial,GelPercentage,LoadingDyes,SeparationTime,Voltage,DutyCycle,CycleDuration,ExposureTimes,ExcitationWavelengths,ExcitationBandwidths,EmissionWavelengths,EmissionBandwidths,
			SampleElectropherogram,MarkerElectropherogram,BlueFluorescenceImageFiles,RedFluorescenceImageFiles,DataType,LaneNumber,NeighboringLanes
		}
	],

	(* Tests to make sure index-matching fields are same length  *)
	Test["ExposureTimes matches BlueFluorescenceImageFiles in length:",
		Length[Lookup[packet,ExposureTimes]],
		Length[Lookup[packet,BlueFluorescenceImageFiles]]
	],
	Test["ExposureTimes matches RedFluorescenceImageFiles in length:",
		Length[Lookup[packet,ExposureTimes]],
		Length[Lookup[packet,RedFluorescenceImageFiles]]
	]
};



(* ::Subsection::Closed:: *)
(*validDataBioLayerInterferometryQTests*)


validDataBioLayerInterferometryQTests[packet:PacketP[Object[Data, BioLayerInterferometry]]]:={

	(* other not Null fields *)
	NotNullFieldTest[
		packet,
		{
			SamplesIn, Instrument, BioProbe, DataType, WellData, WellInformation, MeasuredWellPositions
		}
	],

	UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}]

};



(* ::Subsection::Closed:: *)
(*validDataUVMeltingQTests*)


validDataUVMeltingQTests[packet:PacketP[Object[Data,MeltingCurve]]]:={
	(* Shared Fields which should NOT be null *)
	NotNullFieldTest[packet,{SamplesIn,Instrument}],
	UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],

	(* Shared fields which should be Null *)
	NullFieldTest[packet,Sensor],

	(*At least one melting curve or cooling curve must be informed*)
	AnyInformedTest[packet,{MeltingCurve,CoolingCurve,MeltingCurve3D,CoolingCurve3D}],

	(* Should have melting curve or cooling curve info; secondary and tertiary are optional. Aggregation curve data are optional. *)
	RequiredTogetherTest[packet,{SecondaryMeltingCurve,SecondaryCoolingCurve}],
	RequiredTogetherTest[packet,{TertiaryMeltingCurve,TertiaryCoolingCurve}],
	RequiredTogetherTest[packet,{QuaternaryMeltingCurve,QuaternaryCoolingCurve}],
	RequiredTogetherTest[packet,{QuinaryMeltingCurve,QuinaryCoolingCurve}],
	RequiredTogetherTest[packet,{SecondaryMeltingCurve3D,SecondaryCoolingCurve3D}],
	RequiredTogetherTest[packet,{TertiaryMeltingCurve3D,TertiaryCoolingCurve3D}],
	RequiredTogetherTest[packet,{QuaternaryMeltingCurve3D,QuaternaryCoolingCurve3D}],
	RequiredTogetherTest[packet,{QuinaryMeltingCurve3D,QuinaryCoolingCurve3D}],
	RequiredTogetherTest[packet,{SecondaryAggregationCurve,SecondaryAggregationRecoveryCurve}],
	RequiredTogetherTest[packet,{TertiaryAggregationCurve,TertiaryAggregationRecoveryCurve}],
	RequiredTogetherTest[packet,{SecondaryAggregationCurve3D,SecondaryAggregationRecoveryCurve3D}],
	RequiredTogetherTest[packet,{TertiaryAggregationCurve3D,TertiaryAggregationRecoveryCurve3D}],

	(* Data should be synced with protocol *)
	With[
		{
			protPacket = If[Not[NullQ[packet[Protocol]]],
				Download[packet[Protocol]]
			]
		},
		If[Not[NullQ[protPacket]]&&MatchQ[Lookup[protPacket,Object],ObjectP[Object[Protocol,UVMelting]]],
			{
				FieldSyncTest[{protPacket,packet},Wavelength],
				FieldSyncTest[{protPacket,packet},MinWavelength],
				FieldSyncTest[{protPacket,packet},MaxWavelength]
			},
			Nothing
		]
	],

	(* Either Wavelength or MinWavelength and MaxWavelength are informed *)
	RequiredTogetherTest[packet,{MinWavelength,MaxWavelength}],
	RequiredTogetherTest[packet,{MinEmissionWavelength,MaxEmissionWavelength}],


	FieldComparisonTest[packet,{MinWavelength,MaxWavelength},Less],
	FieldComparisonTest[packet,{ExcitationWavelength,EmissionWavelength},Less],

	(*if the protocol is UVMelting must have Wavelength filled out. If the protocol is ThermalShift must have EmissionWavelength or MinEmissionWavelength.*)
	With[
		{
			protPacket = If[Not[NullQ[packet[Protocol]]],
				Download[packet[Protocol]]
			]
		},
		If[Not[NullQ[protPacket]]&&MatchQ[Lookup[protPacket,Object],ObjectP[Object[Protocol,UVMelting]]],
			NotNullFieldTest[packet,Wavelength],
			UniquelyInformedTest[packet,{EmissionWavelength,MinEmissionWavelength}]
		]
	],

	(*if the protocol is ThermalShift, shared DataFile field will be Null. The Uncle exports two data files one for fluorescence and one for SLS but DataFile in the parent object is a single field. Our MeltingCurve data object has a RawDataFiles multiple field that is requried instead.*)
	With[
		{
			protPacket = If[Not[NullQ[packet[Protocol]]],
				Download[packet[Protocol]]
			]
		},
		If[Not[NullQ[protPacket]]&&MatchQ[Lookup[protPacket,Object],ObjectP[Object[Protocol,ThermalShift]]],
			{
				NotNullFieldTest[packet, RawDataFiles],
				NotNullFieldTest[packet, DataFiles]
			},
			NotNullFieldTest[packet, DataFile]
		]
	]

};


(* ::Subsection::Closed:: *)
(*validDataAppearanceQTests*)


validDataAppearanceQTests[packet:PacketP[Object[Data,Appearance]]]:=If[MatchQ[Lookup[packet,Type],Except[Object[Data,Appearance,Crystals]|Object[Data,Appearance,Colonies]]],
	(* For all Appearance that are not Crystals *)
	{
		(* Shared Fields - Null*)
		NullFieldTest[packet, {DataFile,SamplesOut}],

		(* Shared Fields - Not Null *)
		UniquelyInformedTest[packet, {Instrument, Sensor, Camera}],

		(* Tests for DataType  *)
		Test["If DataType is defined, Protocol, Maintenance or Qualification is defined:",
			Module[{dataType,protocol,qualification,maintenance,instrument},
				{dataType,protocol,qualification,maintenance,instrument}=Lookup[packet,{DataType,Protocol, Qualifications, Maintenance,Instrument}];
				If[!NullQ[dataType]&&!NullQ[instrument],
					MatchQ[{protocol,qualification,maintenance},
						Alternatives[
							{Except[NullP|{}], NullP|{},  NullP|{}},
							{NullP|{},Except[NullP|{}],  NullP|{}},
							{NullP|{}, NullP|{},Except[NullP|{}]}
						]
					],
					True
				]
			],
			True
		],

		(* Specific fields *)
		(* ExposureTime will no longer always be populated, because the overhead imager must auto-expose depending on selected lighting conditions *)
		(* UncroppedImageFile will no longer always be populated, because the qpix does not output a full uncropped image *)

		Test["If DataType is Ruler than only AnalyteData should be informed, while if DataType is Analyte, than only SamplesIn should be informed:",
			Lookup[packet,	{DataType, SamplesIn, AnalyteData}],
				Alternatives[
					{Ruler, NullP|{}, Except[NullP|{}]},
					{Analyte, Except[NullP|{}], NullP|{}},
					{NullP|{}, NullP|{}, NullP|{}}
			]
		]
		},
		(* For Object[Data, Appearance, Crystals] *)
		{
			NotNullFieldTest[packet, {VisibleLightImageFile}]
		}
	];

(* ::Subsection::Closed:: *)
(*validDataAppearanceColoniesQTests*)

validDataAppearanceColoniesQTests[packet:PacketP[Object[Data,Appearance]]]:={
	
	(* Different types of imaging parameters are all required together *)
	RequiredTogetherTest[packet,{
		VioletFluorescenceImageFile,
		VioletFluorescenceExcitationWavelength,
		VioletFluorescenceEmissionWavelength,
		VioletFluorescenceExposureTime,
		VioletFluorescenceIlluminationDirection,
		VioletFluorescenceImageScale
	}],
	RequiredTogetherTest[packet,{
		GreenFluorescenceImageFile,
		GreenFluorescenceExcitationWavelength,
		GreenFluorescenceEmissionWavelength,
		GreenFluorescenceExposureTime,
		GreenFluorescenceIlluminationDirection,
		GreenFluorescenceImageScale
	}],
	RequiredTogetherTest[packet,{
		OrangeFluorescenceImageFile,
		OrangeFluorescenceExcitationWavelength,
		OrangeFluorescenceEmissionWavelength,
		OrangeFluorescenceExposureTime,
		OrangeFluorescenceIlluminationDirection,
		OrangeFluorescenceImageScale
	}],
	RequiredTogetherTest[packet,{
		RedFluorescenceImageFile,
		RedFluorescenceExcitationWavelength,
		RedFluorescenceEmissionWavelength,
		RedFluorescenceExposureTime,
		RedFluorescenceIlluminationDirection,
		RedFluorescenceImageScale
	}],
	RequiredTogetherTest[packet,{
		DarkRedFluorescenceImageFile,
		DarkRedFluorescenceExcitationWavelength,
		DarkRedFluorescenceEmissionWavelength,
		DarkRedFluorescenceExposureTime,
		DarkRedFluorescenceIlluminationDirection,
		DarkRedFluorescenceImageScale
	}],
	RequiredTogetherTest[packet,{
		BlueWhiteScreenImageFile,
		BlueWhiteScreenFilterWavelength,
		BlueWhiteScreenExposureTime,
		BlueWhiteScreenIlluminationDirection,
		BlueWhiteScreenImageScale
	}],
	RequiredTogetherTest[packet,{
		DarkfieldImageFile,
		DarkfieldExposureTime,
		DarkfieldIlluminationDirection,
		DarkfieldScreenImageScale
	}]
};



(* ::Subsection::Closed:: *)
(*validDataELISAQTests*)


validDataELISAQTests[packet:PacketP[Object[Data,ELISA]]]:={
	(* Shared Fields which should NOT be null *)
	NotNullFieldTest[packet,{SamplesIn,Instrument}],
	If[MatchQ[packet[AssayType],CapillaryELISA],NotNullFieldTest[packet,{DataFile}],Nothing],
	UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],

	(* Shared Fields which should be null *)
	NullFieldTest[packet,{SamplesOut,Sensor}],

	(* Unique Fields which should NOT be null *)
	If[MatchQ[packet[Protocol],ObjectP[]],
		NotNullFieldTest[packet,{
			AssayType,
			NumberOfReplicates,
			DataType,
			DilutionFactors
		}],
		Nothing
	],

	(*must informed fields by assay type*)
	Switch[packet[AssayType],
		CapillaryELISA,
		NotNullFieldTest[packet,{Multiplex}],

		DirectELISA|DirectSandwichELISA|DirectCompetitiveELISA,
		NotNullFieldTest[packet,{PrimaryAntibody,PrimaryAntibodyDilutionFactor,AbsorbanceWavelength,Absorbances}],

		InDirectELISA|IndirectSandwichELISA|IndirectCompetitiveELISA,
		NotNullFieldTest[packet,{PrimaryAntibody,PrimaryAntibodyDilutionFactor,SecondaryAntibody,SecondaryAntibodyDilutionFactor,AbsorbanceWavelength,Absorbances}],

		FastELISA,
		NotNullFieldTest[packet,{PrimaryAntibody,PrimaryAntibodyDilutionFactor,CaptureAntibody,CaptureAntibodyDilutionFactor,AbsorbanceWavelength,Absorbances}]
	],

	(*Absorbance Wavelength and readings are required together*)
	RequiredTogetherTest[packet,{SecondaryAbsorbanceWavelength,SecondaryAbsorbances}],
	RequiredTogetherTest[packet,{TertiaryAbsorbanceWavelength,TertiaryAbsorbances}],
	RequiredTogetherTest[packet,{TertiaryAbsorbanceWavelength,TertiaryAbsorbances}],


	(* Multiplex information should match the analytes information *)
	Which[TrueQ[packet[Multiplex]],
		NotNullFieldTest[packet,{MultiplexAnalytes,MultiplexBackgroundIntensities,MultiplexIntensities}],
		MatchQ[packet[AssayType],CapillaryELISA],
		NotNullFieldTest[packet,{Analyte,BackgroundIntensities,Intensities}],
		True,
		Nothing
	],

	(* Only one of two options for single-plex or multiplex should be populated *)
	If[MatchQ[packet[AssayType],CapillaryELISA],
		{
			UniquelyInformedTest[packet, {Analyte, MultiplexAnalytes}],
			UniquelyInformedTest[packet, {BackgroundIntensities, MultiplexBackgroundIntensities}],
			UniquelyInformedTest[packet, {DetectorRangeExceeded, MultiplexDetectorRangeExceeded}],
			UniquelyInformedTest[packet, {Intensities, MultiplexIntensities}]
		},
		Nothing
	],


	(* Depending on DataType, different fields are required.*)
	If[MatchQ[packet[AssayType],CapillaryELISA],
		Which[
			MatchQ[packet[DataType],Standard],
			NotNullFieldTest[packet,{StandardCompositions}],
			MatchQ[packet[SampleType],Spike],
			NotNullFieldTest[packet,{SpikeSample,InitialSampleVolume,SpikeConcentrations,SpikeVolume}],
			True,
			Nothing
		],
		Nothing
	],


	(* Depending on DataType, different fields should be Null.*)
	Which[
		MatchQ[packet[DataType],Standard],
		NullFieldTest[packet,{StandardData,SpikeSample,SpikeConcentrations,SpikeVolume}],
		MatchQ[packet[SampleType],Unknown],
		NullFieldTest[packet,{StandardCompositions,SpikeSample,SpikeConcentrations,SpikeVolume}],
		MatchQ[packet[SampleType],Spike],
		NullFieldTest[packet,{StandardCompositions}],
		True,Nothing
	],


	(* If AssayType is CapillaryELISA, we must have a Cartridge *)
	If[MatchQ[packet[AssayType],CapillaryELISA],
		NotNullFieldTest[packet,{Cartridge}],
		NullFieldTest[packet,{Cartridge}]
	],

	(* For CapillaryELISA Cartridge, Multiplex, analytes and NumberOfReplicates information should match its Cartridge *)
	If[MatchQ[packet[AssayType],CapillaryELISA],
		Test["Multiplex information should match Cartridge:",
			MatchQ[{Lookup[packet,Cartridge][CartridgeType],packet[Multiplex]},{Customizable|SinglePlex72X1,False}|{Except[Customizable|SinglePlex72X1],True}],
			True
		],
		Nothing
	],

	If[MatchQ[packet[AssayType],CapillaryELISA],
		Test["NumberOfReplicates should match Cartridge:",
			MatchQ[{Lookup[packet,Cartridge][CartridgeType],packet[NumberOfReplicates]},{MultiPlex32X8,2}|{Except[MultiPlex32X8],3}],
			True
		],
		Nothing
	],

	If[MatchQ[packet[AssayType],CapillaryELISA]&&MatchQ[Lookup[packet,Cartridge][CartridgeType],SinglePlex72X1],
		Test["Analyte should match Cartridge for SinglePlex72X1 type of Cartridge:",
			MatchQ[ToList[packet[Analyte][Object]],Lookup[packet,Cartridge][AnalyteMolecules][Object]],
			True
		],
		Nothing
	],

	If[MatchQ[packet[AssayType],CapillaryELISA]&&MatchQ[Lookup[packet,Cartridge][CartridgeType],MultiAnalyte16X4|MultiAnalyte32X4|MultiPlex32X8],
		Test["MultiplexAnalytes should match Cartridge for multi-analyte or multiplex types of Cartridge:",
			MatchQ[packet[MultiplexAnalytes][Object],Lookup[packet,Cartridge][AnalyteMolecules][Object]],
			True
		],
		Nothing
	],

	(* Antibody information is required for Customizable cartridge in capillaryELISA experiment *)
	If[MatchQ[packet[AssayType],CapillaryELISA]&&MatchQ[Lookup[packet,Cartridge][CartridgeType],Customizable],
		NotNullFieldTest[packet,{CaptureAntibody,DetectionAntibody}],
		NullFieldTest[packet,{DetectionAntibody}]
	],

	(* For a pre-loaded capillayELISA cartridge, standard curves from the manufacturer is required. *)
	If[MatchQ[packet[AssayType],CapillaryELISA]&&!MatchQ[Lookup[packet,Cartridge][CartridgeType],Customizable],
		NotNullFieldTest[packet,{StandardCurveFunctions}],
		Nothing
	],

	(* TODO Get this test back when analysis is established *)
	(*
	(* After analysis, StandardCurveFunctions should be available. One of AssayConcentrations and MultiplexAssayConcentrations should be populated. *)
	If[!MatchQ[packet[CompositionAnalyses],{}],
		NotNullFieldTest[packet,{StandardCurveFunctions}],
		Nothing
	],
	*)

	Test["MultiplexBackgroundIntensities must be provided for all analytes:",
		If[TrueQ[packet[Multiplex]],
			TrueQ[Length[MultiplexAnalytes]==Length[MultiplexBackgroundIntensities]],
			True
		],
		True
	],

	Test["MultiplexBackgroundIntensities must be provided for all dilutions:",
		If[TrueQ[packet[Multiplex]]&&!MatchQ[packet[MultiplexBackgroundIntensities],{}],
			And@@(
				Map[
					TrueQ[Length[#]==Length[packet[DilutionFactors]]]&,
					packet[MultiplexBackgroundIntensities][[All,2]]
				]
			),
			True
		],
		True
	],

	Test["MultiplexDetectorRangeExceeded must be provided for all analytes:",
		If[TrueQ[packet[Multiplex]]&&MatchQ[packet[AssayType],CapillaryELISA],
			TrueQ[Length[MultiplexAnalytes]==Length[MultiplexDetectorRangeExceeded]],
			True
		],
		True
	],

	Test["MultiplexBackgroundIntensities must be provided for all dilutions:",
		If[TrueQ[packet[Multiplex]]&&MatchQ[packet[AssayType],CapillaryELISA]&&!MatchQ[packet[MultiplexDetectorRangeExceeded],{}],
			And@@(
				Map[
					TrueQ[Length[#]==Length[packet[DilutionFactors]]]&,
					packet[MultiplexDetectorRangeExceeded][[All,2]]
				]
			),
			True
		],
		True
	],

	Test["MultiplexIntensities must be provided for all analytes:",
		If[TrueQ[packet[Multiplex]],
			TrueQ[Length[MultiplexAnalytes]==Length[MultiplexIntensities]],
			True
		],
		True
	],

	Test["MultiplexIntensities must be provided for all dilutions:",
		If[TrueQ[packet[Multiplex]]&&!MatchQ[packet[MultiplexIntensities],{}],
			And@@(
				Map[
					TrueQ[Length[#]==Length[packet[DilutionFactors]]]&,
					packet[MultiplexIntensities][[All,2]]
				]
			),
			True
		],
		True
	],

	(* TODO Get this test back when analysis is established *)
	(*
	(*If StandardCurveFunctions or CompositionAnalyses is populated, either AssayConcentrations or MultiplexAssayConcentrations should be populated *)
	If[!MatchQ[packet[StandardCurveFunctions],{}]||!MatchQ[packet[CompositionAnalyses],{}],
		UniquelyInformedTest[packet,{AssayConcentrations,MultiplexAssayConcentrations}],
		Nothing
	],
	*)

	Test["MultiplexAssayConcentrations must be provided for all analytes when analysis is performed on this data:",
		If[TrueQ[packet[Multiplex]]&&!MatchQ[packet[MultiplexAssayConcentrations],{}],
			TrueQ[Length[MultiplexAnalytes]==Length[MultiplexIntensities]],
			True
		],
		True
	],

	Test["MultiplexAssayConcentrations must be provided for all dilutions when analysis is performed on this data:",
		If[TrueQ[packet[Multiplex]]&&!MatchQ[packet[MultiplexAssayConcentrations],{}],
			And@@(
				Map[
					TrueQ[Length[#]==Length[packet[DilutionFactors]]]&,
					packet[MultiplexAssayConcentrations][[All,2]]
				]
			),
			True
		],
		True
	]

	(* Note that we don't put requirements for Concentrations as it may not be populated when all values are out of the detection range. *)

};



(* ::Subsection::Closed:: *)
(*validDataCapillaryGelElectrophoresisSDSQTests*)


validDataCapillaryGelElectrophoresisSDSQTests[packet:PacketP[Object[Data,CapillaryGelElectrophoresisSDS]]]:={
	(* not null shared fields *)
	NotNullFieldTest[
		packet,
		{
			SamplesIn, Cartridge, Instrument, SampleType, TotalVolume, SampleVolume, Well, InjectionIndex,
			CurrentData, VoltageData, DataFile, Protocol,  InjectionVoltageDurationProfile,
			SeparationVoltageDurationProfile, UVAbsorbanceData, UVAbsorbanceBackgroundData
		}
	],

	(* null shared fields*)
	NullFieldTest[packet,SamplesOut],
	NullFieldTest[packet,Sensor],

	(* sample prep *)
	RequiredTogetherTest[packet,{DenaturingTemperature, DenaturingTime}],
	RequiredTogetherTest[packet,{CoolingTemperature, CoolingTime}],

	RequiredTogetherTest[packet,{PremadeMasterMixReagent, PremadeMasterMixVolume}],
	RequiredTogetherTest[packet,{InternalReference, InternalReferenceVolume}],
	RequiredTogetherTest[packet,{ConcentratedSDSBuffer, ConcentratedSDSBufferVolume}],
	RequiredTogetherTest[packet,{SDSBuffer, SDSBufferVolume}],
	RequiredTogetherTest[packet,{ReducingAgent, ReducingAgentVolume}],
	RequiredTogetherTest[packet,{AlkylatingAgent, AlkylatingAgentVolume}],

	(* data *)
	AnyInformedTest[packet,{ UVAbsorbanceData, ProcessedUVAbsorbanceData}]
};


(* ::Subsection::Closed:: *)
(*validDataCapillaryIsoelectricFocusingQTests*)


validDataCapillaryIsoelectricFocusingQTests[packet:PacketP[Object[Data,CapillaryIsoelectricFocusing]]]:={
	(* not null shared fields *)
	NotNullFieldTest[
		packet,
		{
			SamplesIn, Cartridge, Instrument, SampleType, TotalVolume, SampleVolume, Well, InjectionIndex,
			LoadTime, VoltageDurationProfile, SeparationData, UVAbsorbanceData, UVAbsorbanceBackgroundData,
			ProcessedUVAbsorbanceData,CurrentData, VoltageData, DataFile, Protocol
		}
	],

	(* null shared fields*)
	NullFieldTest[packet,SamplesOut],
	NullFieldTest[packet,Sensor],

	(* fluorescence data *)
	RequiredTogetherTest[packet,{FluorescenceData,FluorescenceBackgroundData,ProcessedFluorescenceData}],

	(* sample prep *)
	RequiredTogetherTest[packet,{PremadeMasterMixReagent, PremadeMasterMixVolume}],
	RequiredTogetherTest[packet,{Ampholytes, AmpholyteVolumes}],
	RequiredTogetherTest[packet,{IsoelectricPointMarkers, IsoelectricPointMarkersVolumes}],
	RequiredTogetherTest[packet,{DenaturationReagent, DenaturationReagentVolume}],
	RequiredTogetherTest[packet,{AnodicSpacer, AnodicSpacerVolume}],
	RequiredTogetherTest[packet,{CathodicSpacer, CathodicSpacerVolume}]
};

(* ::Subsection::Closed:: *)
(*validDataFragmentAnalysisQTests*)


validDataFragmentAnalysisQTests[packet:PacketP[Object[Data,FragmentAnalysis]]]:={
	(* not null shared fields *)
	NotNullFieldTest[
		packet,
		{
			SamplesIn,
			CapillaryArray,
			Instrument,
			SampleType,
			Well,
			SeparationGel,
			Dye,
			SampleInjectionTime,
			SampleInjectionVoltage,
			RunningBuffer,
			SeparationTime,
			SeparationVoltage
		}
	],

	(* null shared fields*)
	NullFieldTest[packet,SamplesOut],

	(* require together *)
	RequiredTogetherTest[packet,{MarkerInjectionTime, MarkerInjectionVoltage}],
	RequiredTogetherTest[packet,{LoadingBuffer, LoadingBufferVolume}],

	(* data *)
	AnyInformedTest[packet,{
		SimulatedGelImage,
		RawDataFile,
		Electropherogram,
		ElectropherogramImage
	}]
};


(* ::Subsection::Closed:: *)
(*validDataChromatographyQTests*)


validDataChromatographyQTests[packet:PacketP[Object[Data,Chromatography]]]:={
	(* Shared Fields which should NOT be null *)
	UniquelyInformedTest[packet, {Instrument, Sensor}],

	NotNullFieldTest[packet,ChromatographyType],

	If[MatchQ[Lookup[packet,ChromatographyType],GasChromatography],
		NotNullFieldTest[packet,{Instrument,DataFile,DataType,Detectors}],
		NotNullFieldTest[packet,{Instrument,DataFile,DataType,Detectors,FlowRates}]
	],

	(* Shared Fields which should be null *)
	NullFieldTest[packet,Sensor],

	(* Individual Fields *)
	NotNullFieldTest[packet,{DataType}],


	(* SeparationMode is required unless DataType is SystemPrime or SystemFlush or GC *)
	If[MatchQ[Lookup[packet,DataType],Alternatives[SystemPrime,SystemFlush]]||MatchQ[Lookup[packet,ChromatographyType],GasChromatography],
		Nothing,
		NotNullFieldTest[packet,SeparationMode]
	],

	(*sample volume must be filled for injecting samples*)
	If[MatchQ[Lookup[packet,DataType],Alternatives[Analyte,Standard]],
		NotNullFieldTest[packet,{SampleVolume,InjectionIndex}],
		Nothing
	],

	(* InjectionIndex is required for blanks if an injection took place *)
	If[MatchQ[Lookup[packet,{DataType,SampleVolume}],{Blank,Except[NullP]}],
		RequiredTogetherTest[packet,{SampleVolume,InjectionIndex}],
		Nothing
	],

	(* Protoco/Qualification/Maintenance is required unless DataType is SystemPrime or SystemFlush *)
	If[MatchQ[Lookup[packet,DataType],Alternatives[SystemPrime,SystemFlush]],
		Nothing,
		UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}]
	],

	Test["SamplesIn is informed for analyte data",
		Lookup[packet,	{DataType, SamplesIn}],
		(* If ladder, should point at analytes *)
		{Analyte|BatchStandard|Standard|Blank,{ObjectP[]..}}|
		(* If batch ladder, should point at batch analytes *)
		{Flush|Prime|SystemFlush|SystemPrime|Blank,NullP|{}}
	],

	(* FPLC gradients are empircal gradient measurements, and will not match the gradient in the method *)
	Test["If GradientA is listed, it must be synced with GradientA of the GradientMethod listed:",
		If[MatchQ[Lookup[packet,ChromatographyType],Except[FPLC|GasChromatography|Flash]],
			Or[NullQ[packet[GradientMethod][GradientA]],Lookup[packet,GradientA]==packet[GradientMethod][GradientA]],
			True
		],
		True
	],
	Test["If GradientB is listed, it must be synced with GradientB of the GradientMethod listed:",
		If[MatchQ[Lookup[packet,ChromatographyType],Except[FPLC|GasChromatography|Flash]],
			Or[NullQ[packet[GradientMethod][GradientB]],Lookup[packet,GradientB]==packet[GradientMethod][GradientB]],
			True
		],
		True
	],
	Test["If GradientC is listed, it must be synced with GradientC of the GradientMethod listed:",
		If[MatchQ[Lookup[packet,ChromatographyType],Except[FPLC|GasChromatography|Flash]],
			Or[NullQ[packet[GradientMethod][GradientC]],Lookup[packet,GradientC]==packet[GradientMethod][GradientC]],
			True
		],
		True
	],
	Test["If GradientD is listed, it must be synced with GradientD of the GradientMethod listed:",
		Which[
			MatchQ[Lookup[packet,ChromatographyType],FPLC],True,
			MatchQ[Lookup[packet,GradientD],{}|Null],True,
			NullQ[packet[GradientMethod][GradientD]],True,
			True,Lookup[packet,GradientD]==packet[GradientMethod][GradientD]
		],
		True
	],
	Test["If EluentGradient is listed, it must be synced with EluentGradient of the GradientMethod listed:",
		If[MatchQ[Lookup[packet,ChromatographyType],IonChromatography],
			If[MatchQ[packet[GradientMethod],ObjectP[Object[Method,IonChromatographyGradient]]],
				Or[NullQ[packet[GradientMethod][EluentGradient]],Lookup[packet,EluentGradient]==packet[GradientMethod][EluentGradient]],
				True
			],
			True
		],
		True
	],

	If[MatchQ[Lookup[packet,Fractions],Except[{}|Null]],
		RequiredTogetherTest[packet,{SamplesOut,Fractions}],
		Nothing
	],


	(* At least one buffer must be used *)
	Switch[
		Lookup[packet,ChromatographyType],

		GasChromatography,Nothing,
		IonChromatography,AnyInformedTest[packet,{BufferA,BufferB,BufferC,BufferD,EluentGeneratorInletSolution}],
		_,AnyInformedTest[packet,{BufferA,BufferB,BufferC,BufferD}]
	],
	RequiredTogetherTest[packet,{BufferA,GradientA}],
	RequiredTogetherTest[packet,{BufferB,GradientB}],
	RequiredTogetherTest[packet,{Eluent,EluentGradient}],

	RequiredTogetherTest[packet,{MinAbsorbanceWavelength,MaxAbsorbanceWavelength}],


	(* Min wavelength must be less than max wavelength*)
	FieldComparisonTest[packet,{MinAbsorbanceWavelength,MaxAbsorbanceWavelength},Less],

	Test["FractionCollectionDetector is a member of Detectors:",
		If[!NullQ[Lookup[packet,FractionCollectionDetector]],
			MemberQ[Lookup[packet,Detectors],Lookup[packet,FractionCollectionDetector]],
			True
		],
		True
	],

	(* Detector related information is populated together *)
	(* pH Calibration *)
	If[MatchQ[Lookup[packet,pHCalibration],True],
		NotNullFieldTest[packet,{
			LowpHCalibrationBuffer,
			HighpHCalibrationBuffer,
			LowpHCalibrationTarget,
			HighpHCalibrationTarget
		}],
		NullFieldTest[packet,{
			LowpHCalibrationBuffer,
			HighpHCalibrationBuffer,
			LowpHCalibrationTarget,
			HighpHCalibrationTarget
		}]
	],

	(* Conductivity Calibration *)
	If[MatchQ[Lookup[packet,ConductivityCalibration],True],
		NotNullFieldTest[packet,{
			ConductivityCalibrationBuffer,
			ConductivityCalibrationTarget
		}],
		NullFieldTest[packet,{
			ConductivityCalibrationBuffer,
			ConductivityCalibrationTarget
		}]
	],

	(* pH Detector *)
	Which[
		MemberQ[Lookup[packet,Detectors],pH]&&MatchQ[ChromatographyType,HPLC],
		{
			NotNullFieldTest[packet, {
				pHCalibration,
				pHTemperatureCompensation,
				pH
			}],
			If[MatchQ[Lookup[packet,pHTemperatureCompensation],True],
				NotNullFieldTest[packet, {
					pHFlowCellTemperature
				}],
				Nothing
			]
		},
		MemberQ[Lookup[packet,Detectors],pH],
		NotNullFieldTest[packet,pH],
		True,
		NullFieldTest[packet,{
			pHCalibration,
			pHTemperatureCompensation,
			pH,
			pHFlowCellTemperature,
			pHPeaksAnalyses
		}]
	],

	(* Conductance Detector *)
	Which[
		MemberQ[Lookup[packet,Detectors],Conductance]&&MatchQ[Lookup[packet,ChromatographyType],HPLC],
		{
			NotNullFieldTest[packet, {
				ConductivityCalibration,
				ConductivityTemperatureCompensation,
				Conductance
			}],
			If[MatchQ[Lookup[packet,ConductivityTemperatureCompensation],True],
				NotNullFieldTest[packet, {
					ConductivityFlowCellTemperature
				}],
				Nothing
			]
		},
		MemberQ[Lookup[packet,Detectors],Conductance],
		NotNullFieldTest[packet,Conductance],
		True,
		NullFieldTest[packet,{
			ConductivityCalibration,
			ConductivityTemperatureCompensation,
			Conductance,
			ConductivityFlowCellTemperature,
			ConductancePeaksAnalyses
		}]
	],

	(* Fluorescence Detector *)
	Which[
		MemberQ[Lookup[packet,Detectors],Fluorescence]&&!MatchQ[Lookup[packet,DataType],Alternatives[SystemPrime,SystemFlush]],
		{
			NotNullFieldTest[packet, {
				ExcitationWavelength,
				EmissionWavelength,
				FluorescenceGain,
				Fluorescence
			}],
			RequiredTogetherTest[packet,{ExcitationWavelength,EmissionWavelength,Fluorescence}],
			RequiredTogetherTest[packet,{SecondaryExcitationWavelength,SecondaryEmissionWavelength,SecondaryFluorescence}],
			RequiredTogetherTest[packet,{TertiaryExcitationWavelength,TertiaryEmissionWavelength,TertiaryFluorescence}],
			RequiredTogetherTest[packet,{QuaternaryExcitationWavelength,QuaternaryEmissionWavelength,QuaternaryFluorescence}]
		},
		!MemberQ[Lookup[packet,Detectors],Fluorescence],
		NullFieldTest[packet, {
			ExcitationWavelength,
			SecondaryExcitationWavelength,
			TertiaryExcitationWavelength,
			QuaternaryExcitationWavelength,
			EmissionWavelength,
			SecondaryEmissionWavelength,
			TertiaryEmissionWavelength,
			QuaternaryEmissionWavelength,
			EmissionCutOffFilter,
			FluorescenceGain,
			FluorescenceFlowCellTemperature,
			Fluorescence,
			SecondaryFluorescence,
			TertiaryFluorescence,
			QuaternaryFluorescence,
			FluorescencePeaksAnalyses,
			SecondaryFluorescencePeaksAnalyses,
			TertiaryFluorescencePeaksAnalyses,
			QuaternaryFluorescencePeaksAnalyses
		}],
		True,
		Nothing
	],

	(* MALS and DLS *)
	If[MemberQ[Lookup[packet,Detectors],MultiAngleLightScattering],
		NotNullFieldTest[packet, {
			LightScatteringLaserPower,
			MultiAngleLightScattering22Degree,
			MultiAngleLightScattering28Degree,
			MultiAngleLightScattering32Degree,
			MultiAngleLightScattering38Degree,
			MultiAngleLightScattering44Degree,
			MultiAngleLightScattering50Degree,
			MultiAngleLightScattering57Degree,
			MultiAngleLightScattering64Degree,
			MultiAngleLightScattering72Degree,
			MultiAngleLightScattering81Degree,
			MultiAngleLightScattering99Degree,
			MultiAngleLightScattering108Degree,
			MultiAngleLightScattering117Degree,
			MultiAngleLightScattering126Degree,
			MultiAngleLightScattering134Degree,
			MultiAngleLightScattering141Degree,
			MultiAngleLightScattering147Degree,
			MALSDetectorAngles
		}],
		NullFieldTest[packet, {
			MultiAngleLightScattering22Degree,
			MultiAngleLightScattering28Degree,
			MultiAngleLightScattering32Degree,
			MultiAngleLightScattering38Degree,
			MultiAngleLightScattering44Degree,
			MultiAngleLightScattering50Degree,
			MultiAngleLightScattering57Degree,
			MultiAngleLightScattering64Degree,
			MultiAngleLightScattering72Degree,
			MultiAngleLightScattering81Degree,
			MultiAngleLightScattering90Degree,
			MultiAngleLightScattering99Degree,
			MultiAngleLightScattering108Degree,
			MultiAngleLightScattering117Degree,
			MultiAngleLightScattering126Degree,
			MultiAngleLightScattering134Degree,
			MultiAngleLightScattering141Degree,
			MultiAngleLightScattering147Degree,
			MALSDetectorAngles,
			MultiAngleLightScatteringAnalyses
		}]
	],

	If[MemberQ[Lookup[packet,Detectors],DynamicLightScattering],
		NotNullFieldTest[packet, {
			LightScatteringLaserPower,
			DynamicLightScattering
		}],
		NullFieldTest[packet, {
			DynamicLightScattering,
			DynamicLightScatteringAnalyses
		}]
	],

	If[!MemberQ[Lookup[packet,Detectors],DynamicLightScattering]&&!MemberQ[Lookup[packet,Detectors],MultiAngleLightScattering],
		NullFieldTest[packet, {
			LightScatteringFlowCellTemperature,
			LightScatteringLaserPower
		}],
		Nothing
	],

	(* Refractive Index *)
	If[MemberQ[Lookup[packet,Detectors],RefractiveIndex],
		{
			NotNullFieldTest[packet,{
				RefractiveIndexMethod,
				RefractiveIndex
			}],
			If[MatchQ[Lookup[packet,RefractiveIndexMethod],DifferentialRefractiveIndex],
				(* Composition must not be Null. DifferentialRefractiveIndexReference data may be Null if it happens inside the Sample injection - not by ColumnPrime/Standard/Blank. *)
				NotNullFieldTest[packet,{DifferentialRefractiveIndexReferenceComposition}],
				NullFieldTest[packet, {DifferentialRefractiveIndexReference,DifferentialRefractiveIndexReferenceComposition}]
			]
		},
		NullFieldTest[packet,{
			RefractiveIndexMethod,
			DifferentialRefractiveIndexReference,
			DifferentialRefractiveIndexReferenceComposition,
			RefractiveIndexFlowCellTemperature,
			RefractiveIndex,
			RefractiveIndexPeaksAnalysis
		}]
	],

	(* Conductance detection for IonChromatography *)
	If[MemberQ[Lookup[packet,Detectors],Conductance]&&MatchQ[Lookup[packet,ChromatographyType],IonChromatography],
		NotNullFieldTest[packet,{
			SuppressorMode
		}],
		NullFieldTest[packet,{
			SuppressorMode
		}]
	],

	(* Electrochemical detection *)
	If[MemberQ[Lookup[packet,Detectors],ElectrochemicalDetector],
		NotNullFieldTest[packet,{
			ElectrochemicalDetectionMode,
			ReferenceElectrodeMode,
			ElectrochemicalSamplingRate
		}],
		NullFieldTest[packet,{
			ElectrochemicalDetectionMode,
			WorkingElectrode,
			ReferenceElectrode,
			ReferenceElectrodeMode,
			ElectrochemicalVoltage,
			ElectrochemicalVoltageProfile,
			ElectrochemicalWaveform,
			ElectrochemicalWaveformProfile,
			ElectrochemicalSamplingRate
		}]
	],
	If[
		Or[
			MemberQ[Lookup[packet,Detectors],Conductance]&&MatchQ[Lookup[packet,ChromatographyType],IonChromatography],
			MemberQ[Lookup[packet,Detectors],ElectrochemicalDetector]
		],
		NotNullFieldTest[packet,DetectionTemperature],
		NullFieldTest[packet,DetectionTemperature]
	]

};



(* ::Subsection::Closed:: *)
(*validDataChromatographyMassSpectraQTests*)


validDataChromatographyMassSpectraQTests[packet:PacketP[Object[Data,ChromatographyMassSpectra]]]:= {
	(* Shared Fields and combined fields which should NOT be null in not-GC *)
	Sequence@@If[!MatchQ[Lookup[packet,FluidType],Gas],
		{
			NotNullFieldTest[packet, {Detectors, GradientMethod, FlowRates, SeparationMode, MassSpectrum}],
			RequiredTogetherTest[packet,{Calibrant, CalibrationStandardDeviation}],
			RequiredTogetherTest[packet,{Column, ColumnTemperature, ColumnOrientation}],
			RequiredTogetherTest[packet,{GuardColumn,GuardColumnOrientation}],
			RequiredTogetherTest[packet,{LowCollisionEnergies, HighCollisionEnergies}],
			RequiredTogetherTest[packet,{FinalLowCollisionEnergies, FinalHighCollisionEnergies}]
		},
		Nothing
	],
	
	Sequence@@(Test[ToString[#]<>" is not specified if the Acquisition is not DataDependent:",
		If[And[(!MatchQ[Lookup[packet,FluidType],Gas]),(!MemberQ[Lookup[packet,AcquisitionModes],DataDependent])],
			MatchQ[Lookup[packet,#],(Null|{Null...})],
			True
		],
		True
	]&/@{MinimumThresholds, AcquisitionLimits, CycleTimeLimits}),
	
	
	(* Shared fields for SFC and GC*)
	Sequence@@If[!MatchQ[Lookup[packet,FluidType],Liquid],
		{
			NotNullFieldTest[packet, {AcquisitionMode,Instrument,MassDetectionGain}]
		},
		Nothing
	],
	
	(* Shared Fields and combined fields which should NOT be null in GC *)
	Sequence@@If[MatchQ[Lookup[packet,FluidType],Gas],
		{
			NotNullFieldTest[packet, {Detector, SeparationMethod}]
		},
		Nothing
	],

	(* Shared Fields which should NOT be null shared *)
	NotNullFieldTest[packet, {
		DataType, FluidType , Scale, DateInjected, MassAnalyzer, IonSource, MinMass, MaxMass,
		SourceTemperature, IonAbundance3D}],

	If[MatchQ[Lookup[packet,IonSource],ESI]&&	MatchQ[Lookup[packet,MassAnalyzer],(QTOF|TripleQuadrupole)],
		NotNullFieldTest[packet,{IonMode, ScanTimes, ESICapillaryVoltage, DesolvationTemperature, IonAbundance3D, DesolvationGasFlow, SourceTemperature, ESICapillaryVoltage, ConeGasFlow, StepwaveVoltage,
			AcquisitionModes,AcquisitionWindows,Fragmentations}],
		Nothing
	],
	RequiredTogetherTest[packet,{MinMasses, MaxMasses}],
	If[MemberQ[Lookup[packet,AcquisitionModes],DataDependent],
		NotNullFieldTest[packet,{AcquisitionSurveys}],
		Nothing
	],
	
	Sequence@@(Test[ToString[#]<>" is not specified if the IsotopeExclusionModes is not ChargedState:",
		If[(!MemberQ[Lookup[packet,IsotopeExclusionModes],ChargedState]),
			MatchQ[Lookup[packet,#],(Null|{Null...})],
			True
		],
		True
	]&/@{ChargeStateSelections, ChargeStateLimits, ChargeStateMassTolerances}),
	
	
	(*sample volume must be filled for injecting samples*)
	If[MatchQ[Lookup[packet,DataType],Alternatives[Analyte,Standard]],
		NotNullFieldTest[packet,{SampleVolume,InjectionIndex}],
		Nothing
	],

	(* InjectionIndex is required for blanks if an injection took place *)
	If[MatchQ[Lookup[packet,{DataType,SampleVolume}],{Blank,Except[NullP]}],
		RequiredTogetherTest[packet,{SampleVolume,InjectionIndex}],
		Nothing
	],

	If[MatchQ[Lookup[packet,FluidType],Liquid],
		NotNullFieldTest[packet,{BufferA, BufferB, BufferC, BufferD, GradientA, GradientB, GradientC, GradientD}],
		Nothing
	],

	(*all the SFC related requirements*)
	If[MatchQ[Lookup[packet,FluidType],SupercriticalCO2],
		NotNullFieldTest[packet,{CosolventA, CosolventB, CosolventC, CosolventD, MakeupSolvent, BackPressure, CO2Gradient, MakeupFlowRate, GradientA, GradientB, GradientC, GradientD}],
		Nothing
	],

	(*all the PDA requirements*)
	If[MemberQ[Lookup[packet,Detectors],PhotoDiodeArray],
		NotNullFieldTest[packet,{MinAbsorbanceWavelength, MaxAbsorbanceWavelength, AbsorbanceWavelengthResolution, UVFilter, AbsorbanceSamplingRate, AbsorbanceWavelength, Absorbance3D}],
		Nothing
	],
	If[MemberQ[Lookup[packet,Detectors],PhotoDiodeArray],
		FieldComparisonTest[packet,{MaxAbsorbanceWavelength,MinAbsorbanceWavelength},GreaterEqual],
		Nothing
	],

	(*all the field comparisons*)
	FieldComparisonTest[packet,{MaxMass,MinMass},GreaterEqual]

};


(* ::Subsection::Closed:: *)
(*validDataCarbonDioxideQTests*)


validDataCarbonDioxideQTests[packet:PacketP[Object[Data,CarbonDioxide]]]:=
{
(* Shared Field Shaping *)
NullFieldTest[packet,{SamplesIn,SamplesOut,Instrument,DataFile}],

NotNullFieldTest[packet,Sensor],
UniquelyInformedTest[packet, {Instrument, Sensor}],

(* Unique Fields which should NOT be null *)
NotNullFieldTest[packet,{CarbonDioxideLog,RawData}],

(* Sensible Min/Max *)
RequiredTogetherTest[packet,{FirstDataPoint,LastDataPoint}],
FieldComparisonTest[packet,{FirstDataPoint,LastDataPoint},LessEqual],

(* max of one of protocols,qualifications,maintenance should be informed *)
Test["Not more than one of protocols, qualifications, and maintenance should be informed:",
	Count[Lookup[packet,{Protocol,Maintenance,Qualifications}],Except[Null]],
	RangeP[0,1,1]
]
};


(* ::Subsection::Closed:: *)
(*validDataConductivityQTests*)


validDataConductivityQTests[packet:PacketP[Object[Data,Conductivity]]]:={
(* Shared Field Shaping *)
NullFieldTest[packet,{SamplesOut,Instrument}],

(* Unique Fields which should NOT be null *)
NotNullFieldTest[packet,{Conductivity, Temperature,Probe}],

(*shared fields that are not null*)
NotNullFieldTest[packet, {DataFile}],

Test["AlphaCoefficient should be populated if TemperatureCorrection is Linear.",
	Lookup[packet,{TemperatureCorrection,AlphaCoefficient}],
	{Alternatives[NonLinear,None,PureWater],NullP|{}}|{Linear,Except[NullP|{}]}
],

(* max of one of protocols,qualifications,maintenance should be informed *)
Test["Not more than one of protocols, qualifications, and maintenance should be informed:",
	Count[Lookup[packet,{Protocol,Maintenance,Qualifications}],Except[Null]],
	RangeP[0,1,1]
]
};


(* ::Subsection::Closed:: *)
(*validDataContactAngleQTests*)


validDataContactAngleQTests[packet:PacketP[Object[Data,ContactAngle]]]:={
	(* Shared Field Shaping *)
	NullFieldTest[packet,{SamplesOut,Instrument}],

	(*shared fields that are not null*)
	NotNullFieldTest[packet,{DataFile}],

	(* Unique Fields which should NOT be null *)
	NotNullFieldTest[packet,{
		NumberOfCycles,
		WettingLiquid,
		Temperature
	}],

	Test["If AdvancingContactAngle or RecedingContactAngle are populated, they should be equal or larger than 0 angular degree and equal or smaller than 180 angular degree:",
		Module[{contactAngles},
			contactAngles={AdvancingContactAngle,RecedingContactAngle};
			Map[Lookup[packet,#]&,contactAngles]
		],
		{
			{({RangeP[0 AngularDegree,180 AngularDegree],_Real}|{Null,Null})...},
			{({RangeP[0 AngularDegree,180 AngularDegree],_Real}|{Null,Null})...}
		}
	]
};

(* ::Subsection:: *)
(*validDataCoulterCountQTests*)


validDataCoulterCountQTests[packet:PacketP[Object[Data,CoulterCount]]]:={

	(* fields that should not be null *)
	NotNullFieldTest[packet,{
		(* Shared fields *)
		DataFiles,
		Protocol,
		SamplesIn,
		(* Unique fields *)
		DataType,
		Oversaturated,
		ApertureDiameter,
		StopCondition,
		RunTime,
		RunVolume,
		RawTotalCount,
		UnblankedTotalCount,
		UnblankedDiameterDistribution,
		UnblankedConcentration
	}],

	(* fields that should be null *)
	NullFieldTest[packet,{
		SamplesOut
	}],

	(* if we are not dealing with a blank, then processed data is expected *)
	If[!MatchQ[Lookup[packet, DataType], Blank],
		NotNullFieldTest[packet,{
			DiameterDistribution,
			BlankDiameterDistribution,
			BlankTotalCount,
			BlankData,
			TotalCount,
			ModalDiameter,
			AverageDiameter,
			Concentration,
			DerivedConcentration
		}],
		Nothing
	]
};


(*validDataWettedLengthQTests*)

validDataWettedLengthQTests[packet:PacketP[Object[Data,WettedLength]]]:={
	(* Shared Field Shaping *)
	NullFieldTest[packet,{SamplesOut,Instrument}],

	(* Unique Fields which should NOT be null *)
	NotNullFieldTest[packet,{
		Sample,
		WettingLiquid,
		Temperature,
		TemperatureTrace,
		ForceMeasured,
		CalculatedWettedLength,
		FitAnalyses
	}]
};


(* ::Subsection::Closed:: *)
(*validDataCrossFlowQTests*)


validDataCrossFlowQTests[packet:PacketP[Object[Data,CrossFlowFiltration]]]:={
	If[
		MatchQ[Download[Lookup[packet,Instrument], Model],LinkP[Model[Instrument, CrossFlowFiltration, "\[Micro]PULSE - TFF"]]],
		NotNullFieldTest[packet,
			{
				SamplesIn,
				FiltrationMode,
				CrossFlowFilter,
				InletPressureData,
				RetentatePressureData,
				PermeatePressureData,
				TransmembranePressureData,
				RetentateWeightData,
				DiafiltrationWeightData,
				FiltrationCycleLog,
				DataFiles,
				SampleType
			}
		],
		NotNullFieldTest[
			packet,
			{
				Protocol,
				InletPressureData,
				RetentatePressureData,
				PermeatePressureData,
				TransmembranePressureData,
				RetentateWeightData,
				PermeateWeightData,
				PrimaryPumpFlowRateData,
				SecondaryPumpFlowRateData,
				RetentateConductivityData,
				PermeateConductivityData,
				TemperatureData
			}
		]
	]
};



(* ::Subsection::Closed:: *)
(*validDataCyclicVoltammetryQTests*)


validDataCyclicVoltammetryQTests[packet:PacketP[Object[Data,CyclicVoltammetry]]]:={

	(* Shared Fields which Should Only Be Filled in One of Them, and Not All Null *)
	UniquelyInformedTest[packet, {Instrument, Sensor}],
	UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],

	(* Non-Shared Fields which should NOT be null *)
	NotNullFieldTest[packet,{
		DataType,
		LoadingSample,
		SampleVolume,
		WorkingElectrode,
		ReferenceElectrode,
		CounterElectrode,
		ReactionVessel,
		ElectrodeCap,
		VoltammogramPotentials
	}],
	RequiredTogetherTest[packet,{
		SpargingGas,
		SpargingTime,
		SpargingPressure
	}]
};



(* ::Subsection::Closed:: *)
(*validDataDNASequencingQTests*)


validDataDNASequencingQTests[packet:PacketP[Object[Data,DNASequencing]]]:={

	(* not null shared fields *)
	NotNullFieldTest[packet, {SamplesIn, Instrument, DataFile}],

	UniquelyInformedTest[packet, {Instrument, Sensor}],
	UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],

	(* null shared fields *)
	NullFieldTest[packet, {Sensor,SamplesOut}],

	(* not null unique fields *)
	NotNullFieldTest[packet, {
		Well,
		AdenosineTripshophateTerminator,
		ThymidineTripshophateTerminator,
		GuanosineTripshophateTerminator,
		CytosineTriphosphateTerminator
	}]
};


(* ::Subsection::Closed:: *)
(*validDataDifferentialScanningCalorimetryQTests*)


validDataDifferentialScanningCalorimetryQTests[packet:PacketP[Object[Data, DifferentialScanningCalorimetry]]]:={

NotNullFieldTest[packet, {DateCreated, Protocol, SamplesIn, Instrument, TemperatureRampRate, NumberOfScans, HeatingCurves, StartTemperature, EndTemperature, DataFile}],

NullFieldTest[packet, {SamplesOut}]

};


(* ::Subsection::Closed:: *)
(*validDataDissolvedOxygenQTests*)


validDataDissolvedOxygenQTests[packet:PacketP[Object[Data, DissolvedOxygen]]]:={

	NotNullFieldTest[packet, {DateCreated, Protocol, SamplesIn, Instrument, DissolvedOxygen, Temperature, Pressure, DataFile}],

	NullFieldTest[packet, {SamplesOut}]

};



(* ::Subsection::Closed:: *)
(*validDataDynamicLightScatteringQTests*)


validDataDynamicLightScatteringQTests[packet:PacketP[Object[Data, DynamicLightScattering]]]:={

	(* not null shared fields *)
	NotNullFieldTest[packet,{SamplesIn,DataFile,Instrument,DateCreated}],
	UniquelyInformedTest[packet, {Instrument, Sensor}],
	UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],

	(* null shared fields *)
	NullFieldTest[packet,SamplesOut],

	(* not null unique fields *)
	NotNullFieldTest[packet,{
		AssayFormFactor,
		Instrument,
		AssayType,
		Temperature,
		AutomaticLaserSettings
	}],

	RequiredTogetherTest[packet, {
		AssayContainers,
		AssayPositions
	}],

	RequiredTogetherTest[packet, {
		R90OverK,
		KirkwoodBuffIntegral
	}],

	(*isothermal stability fields*)
	RequiredTogetherTest[packet, {
		ZAverageDiameters,
		PolydispersityIndices,
		ScatteredLightIntensities
	}],

	(*sizing/polydispersity fields*)
	RequiredTogetherTest[packet, {
		ZAverageDiameter,
		ZAverageDiffusionCoefficient,
		DiameterStandardDeviation,
		PolydispersityIndex,
		CorrelationCurveFitVariance,
		ScatteredLightIntensity,
		IntensityDistribution,
		MassDistribution,
		CorrelationCurve
	}]
};


(* ::Subsection::Closed:: *)
(*validDataDensityQTests*)



validDataDensityQTests[packet:PacketP[Object[Data, Density]]]:={

NotNullFieldTest[packet, {
	Method,
	Density,
	Protocol
}]

};


(* ::Subsection::Closed:: *)
(*validDataFlowCytometryQTests*)


validDataFlowCytometryQTests[packet:PacketP[Object[Data,FlowCytometry]]]:= {

(* Only perform these tests on modern data *)
If[(Lookup[packet, DateCreated]) > DateObject["Jan 1 2016"],
	{
		(* Shared *)
		NotNullFieldTest[packet, SamplesIn],
		UniquelyInformedTest[packet, {Instrument, Sensor}],
		UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}]
	},
	{}
],

(*shared fields that are not null*)
NotNullFieldTest[packet, {Instrument,DataFile}],

(* shared fields that are null *)
NullFieldTest[packet, Sensor],
NotNullFieldTest[packet, {ExperimentFile,InjectionSpeed,SignalWidth,PrimaryTrigger,TriggerRelation}],


Test["SecondaryTrigger is appropriately informed depending on the trigger relation",
	Lookup[packet,{TriggerRelation,SecondaryTrigger}],
	{First,NullP|{}}|{And|Or,Except[NullP|{}]}
],

RequiredTogetherTest[packet, {
	FluorescenceLaser,
	FluorescenceEmissionWavelength,
	FluorescenceEmissionBandwidth,
	FluorescenceGain,
	FluorescenceHeight,
	FluorescenceArea
}]
};

(* ::Subsection::Closed:: *)
(*validDataAlphaScreenQTests*)


validDataAlphaScreenQTests[packet:PacketP[Object[Data,AlphaScreen]]]:=Module[
	{protocolPacket},

	protocolPacket=Download[packet[Protocol]];

	Join[
		{
			(* Shared Fields - Null *)
			NullFieldTest[packet,{SamplesOut,Sensor}],

			(* Shared Fields - NotNull *)
			NotNullFieldTest[packet,{SamplesIn,Protocol,Instrument,DataFile}],
			UniquelyInformedTest[packet,{Instrument,Sensor}],
			UniquelyInformedTest[packet,{Protocol,Qualifications,Maintenance}],

			(* Specific Fields *)
			NotNullFieldTest[packet,{ExcitationTime,DelayTime,IntegrationTime,Gain,ReadTemperature,Well,Intensity}]

		},
		(* FieldSync checks will break if there is no protocol object. This is checked in a separate test *)
		If[MatchQ[protocolPacket,Null],
			{},
			{
				FieldSyncTest[{protocolPacket,packet},PreparedPlate],
				FieldSyncTest[{protocolPacket,packet},ReadTemperature],
				FieldSyncTest[{protocolPacket,packet},Gain],
				FieldSyncTest[{protocolPacket,packet},ExcitationWavelength],
				FieldSyncTest[{protocolPacket,packet},EmissionWavelength],
				FieldSyncTest[{protocolPacket,packet},ExcitationTime],
				FieldSyncTest[{protocolPacket,packet},DelayTime],
				FieldSyncTest[{protocolPacket,packet},IntegrationTime]
			}
		]
	]
];

(* ::Subsection::Closed:: *)
(*validDataFluorescenceIntensityQTests*)


validDataFluorescenceIntensityQTests[packet:PacketP[{Object[Data,FluorescenceKinetics],Object[Data,FluorescenceIntensity]}]]:=Module[
{dataField,dualDataField,protocolPacket},

dataField=If[MatchQ[packet,PacketP[Object[Data,FluorescenceKinetics]]],
	EmissionTrajectories,
	Intensities
];

dualDataField=If[MatchQ[packet,PacketP[Object[Data,FluorescenceKinetics]]],
	DualEmissionTrajectories,
	DualEmissionIntensities
];

protocolPacket=Download[packet[Protocol]];

Join[
	validPlateReaderDataTests[packet],
	{
		(* Specific Fields *)
		NotNullFieldTest[packet,{EmissionWavelengths,Gains,dataField}],

		(* Required Together *)
		RequiredTogetherTest[packet,
			{
				DualEmissionGains,
				DualEmissionWavelengths,
				dualDataField
			}
		]
	},
	(* FieldSync checks will break if there is no protocol object. This is checked in a separate test *)
	If[MatchQ[protocolPacket,Null],
		{},
		{
			FieldSyncTest[{protocolPacket,packet},ExcitationWavelengths],
			FieldSyncTest[{protocolPacket,packet},EmissionWavelengths],
			FieldSyncTest[{protocolPacket,packet},DualEmissionWavelengths],
			FieldSyncTest[{protocolPacket,packet},NumberOfReadings],
			FieldSyncTest[{protocolPacket,packet},DelayTime],
			FieldSyncTest[{protocolPacket,packet},ReadTime]
		}
	]
]
];



(* ::Subsection::Closed:: *)
(*validDataFluorescencePolarizationQTests*)


validDataFluorescencePolarizationQTests[packet:PacketP[{Object[Data,FluorescencePolarization],Object[Data,FluorescencePolarizationKinetics]}]]:=Module[
{dataField,dualDataField,protocolPacket},

dataField=If[MatchQ[packet,PacketP[Object[Data,FluorescencePolarizationKinetics]]],
	ParallelTrajectories,
	ParallelIntensities
];

dualDataField=If[MatchQ[packet,PacketP[Object[Data,FluorescencePolarizationKinetics]]],
	PerpendicularTrajectories,
	PerpendicularIntensities
];

protocolPacket=Download[packet[Protocol]];

Join[
	validPlateReaderDataTests[packet],
	{
		(* Specific Fields *)
		NotNullFieldTest[packet,{EmissionWavelengths,Gains,dataField,DualEmissionWavelengths,DualEmissionGains,dualDataField,Anisotropy,Polarization}]
	},
	(* FieldSync checks will break if there is no protocol object. This is checked in a separate test *)
	If[MatchQ[protocolPacket,Null],
		{},
		{
			FieldSyncTest[{protocolPacket,packet},ExcitationWavelengths],
			FieldSyncTest[{protocolPacket,packet},EmissionWavelengths],
			FieldSyncTest[{protocolPacket,packet},DualEmissionWavelengths],
			FieldSyncTest[{protocolPacket,packet},NumberOfReadings]
		}
	]
]
];


(* ::Subsection::Closed:: *)
(*validDataFluorescenceSpectroscopyQTests*)


validDataFluorescenceSpectroscopyQTests[packet:PacketP[Object[Data,FluorescenceSpectroscopy]]]:=Module[{protocolPacket},

protocolPacket=Download[packet[Protocol]];

Join[
	validPlateReaderDataTests[packet],
	{
		NotNullFieldTest[packet, {NumberOfReadings}],
		RequiredTogetherTest[packet,{EmissionSpectrum,ExcitationWavelength,MinEmissionWavelength,MaxEmissionWavelength,EmissionScanGain}],
		RequiredTogetherTest[packet,{ExcitationSpectrum,MinExcitationWavelength,MaxExcitationWavelength,EmissionWavelength,ExcitationScanGain}]
	},
	(* FieldSync checks will break if there is no protocol object. This is checked in a separate test *)
	If[MatchQ[protocolPacket,Null],
		{},
		{
			FieldSyncTest[{protocolPacket,packet},ExcitationWavelength],
			FieldSyncTest[{protocolPacket,packet},MinEmissionWavelength],
			FieldSyncTest[{protocolPacket,packet},MaxEmissionWavelength],
			FieldSyncTest[{protocolPacket,packet},MinExcitationWavelength],
			FieldSyncTest[{protocolPacket,packet},MaxExcitationWavelength],
			FieldSyncTest[{protocolPacket,packet},EmissionWavelength]
		}
	]
]
];


(* ::Subsection::Closed:: *)
(*validDataFluorescenceThermodynamicsQTests*)


validDataFluorescenceThermodynamicsQTests[packet:PacketP[Object[Data,FluorescenceThermodynamics]]]:={

UniquelyInformedTest[packet, {Instrument, Sensor}],
UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],

(* shared fields not null*)
NotNullFieldTest[packet, {SamplesIn, DataFile, Instrument}],

(* shared fields null *)
NullFieldTest[packet, {SamplesOut, Sensor}],

(* unique fields not null *)
NotNullFieldTest[packet, {Reporter,Quencher,ExcitationWavelength,ExcitationBandwidth,EmissionWavelength,EmissionBandwidth,Well}],


(* If PassiveReference and MeltingCurve \[NotEqual] Null, then RawMeltingCurve \[NotEqual] NUll *)
Test[
	"If PassiveReference and MeltingCurve are informed, then RawMeltingCurve should be informed:",
	If[
		MatchQ[Lookup[packet,{PassiveReference,MeltingCurve}],{Except[NullP|{}],Except[NullP|{}]}],
		!NullQ[Lookup[packet,RawMeltingCurve]],
		True
	],
	True
],

(* If PassiveReference and CoolingCurve \[NotEqual] Null, then RawCoolingCurve \[NotEqual] NUll *)
Test[
	"If PassiveReference and CoolingCurve are informed, then RawCoolingCurve should be informed:",
	If[
		MatchQ[Lookup[packet,{PassiveReference,CoolingCurve}],{Except[NullP|{}],Except[NullP|{}]}],
		!NullQ[Lookup[packet,RawCoolingCurve]],
		True
	],
	True
],

(* If PassiveReference is informed, then Analytes should be Null, or vice versa. Note both can be null, but not both informed *)
Test[
	"If informed, only one of PassiveReference or Analytes should be informed, not both:",
		 Lookup[packet,	{PassiveReference, Analytes}],
		{NullP|{}, NullP|{}}|{NullP|{}, Except[NullP|{}]}|{Except[NullP|{}], NullP|{}}
],

(* Make sure that if DataType is informed, it is synced with what is informed for PassiveReference and Analytes *)
Test[
	"If DataType is informed, ensure that it is synced with PassiveReference and Analytes:",
		Lookup[packet,{DataType, PassiveReference, Analytes}],
		{NullP|{}, _, _}|{PassiveReference, NullP|{}, _}|{Analyte, _, NullP|{}}
],

(*Logical other tests*)
AnyInformedTest[packet, {CoolingCurve, MeltingCurve}]
};



(* ::Subsection::Closed:: *)
(*validDataFreezeCellsQTests*)


validDataFreezeCellsQTests[packet:PacketP[Object[Data,FreezeCells]]]:={

	(* Unique Fields which should NOT be null *)
	NotNullFieldTest[packet,{
		Batches,
		FreezingMethods,
		Instruments,
		ExpectedTemperatureData,
		MeasuredTemperatureData
	}],

	RequiredTogetherTest[packet,{
		FreezingRates,
		Durations,
		ResidualTemperatures
	}]
};




(* ::Subsection::Closed:: *)
(*validDataLiquidLevelQTests*)


validDataLiquidLevelQTests[packet:PacketP[Object[Data,LiquidLevel]]]:= {
(* Shared Field Shaping *)
NullFieldTest[packet,{SamplesOut,Instrument,DataFile}],

NotNullFieldTest[packet,Sensor],
UniquelyInformedTest[packet, {Instrument, Sensor}],

(* Unique Fields which should NOT be null *)
NotNullFieldTest[packet,{LiquidLevelLog,RawData}],

(* Sensible Min/Max *)
RequiredTogetherTest[packet,{FirstDataPoint,LastDataPoint}],
FieldComparisonTest[packet,{FirstDataPoint,LastDataPoint},LessEqual],

(* max of one of protocols,qualifications,maintenance should be informed *)
Test["Not more than one of protocols, qualifications, and maintenance should be informed:",
	Count[Lookup[packet,{Protocol,Maintenance,Qualifications}],Except[Null]],
	RangeP[0,1,1]
]
};


(* ::Subsection::Closed:: *)
(*validDataLCMSQTests*)


validDataLCMSQTests[packet:PacketP[Object[Data,LCMS]]]:={
(* shared fields not null *)
UniquelyInformedTest[packet, {Instrument, Sensor}],
UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],
NotNullFieldTest[packet, {SamplesIn, Instrument, DataFile}],

(* shared fields null *)
NullFieldTest[packet, {SamplesOut,Sensor}],

(* unique fields not null *)
NotNullFieldTest[packet, {
		MassSpectra,
		Peaks,
		Chromatogram,
		AcquisitionMode,
		IonSource,
		IonMode,
		MinMass,
		MaxMass,
		MassAnalysisStage,
		SourceVoltageOffset,
		SourceTemperature,
		DesolvationTemperature,
		MassAnalysisStage,
		ConeGasFlow,
		DesolvationGasFlow,
		TotalIonCurrent,
		BasePeakIntensity,
		BasePeakMass,
		CollisionVoltage
	}
],

(* Gradient information required together *)
RequiredTogetherTest[packet,{GradientA,BufferA}],
RequiredTogetherTest[packet,{GradientB,BufferB}],
RequiredTogetherTest[packet,{GradientC,BufferC}],
RequiredTogetherTest[packet,{GradientD,BufferD}],


(*Logical Maximum/Minimum Tests*)
FieldComparisonTest[packet, {MinMass, MaxMass}, LessEqual],
(*Tandem MS Specific*)
Test[
	"If MSMS data belongs to a fragment ion scan (MassAnalysisStage is 2) then PrecursorIonNominalMass is informed:",
	Module[{massSpectrometryFunction,massAnalysisStage},
		{massSpectrometryFunction,massAnalysisStage}=Lookup[packet,{AcquisitionMode,MassAnalysisStage}];
		If[massSpectrometryFunction=== MSMS &&massAnalysisStage=== 2,
			NotNullFieldTest[packet, NominalPrecursorIonMass],
			True
		]
	],
	True
],
Test[
	"If MSMS data belongs to a fragment ion scan (MassAnalysisStage is 2) then MinPrecursorIonSelectionMass is informed:",
	Module[{massSpectrometryFunction,massAnalysisStage},
		{massSpectrometryFunction,massAnalysisStage}=Lookup[packet,{AcquisitionMode,MassAnalysisStage}];
		If[massSpectrometryFunction=== MSMS &&massAnalysisStage=== 2,
			NotNullFieldTest[packet, MinPrecursorIonSelectionMass],
			True
		]
	],
	True
],
Test[
	"If MSMS data belongs to a fragment ion scan (MassAnalysisStage is 2) then MaxPrecursorIonSelectionMass is informed:",
	Module[{massSpectrometryFunction,massAnalysisStage},
		{massSpectrometryFunction,massAnalysisStage}=Lookup[packet,{AcquisitionMode,MassAnalysisStage}];
		If[massSpectrometryFunction=== MSMS &&massAnalysisStage=== 2,
			NotNullFieldTest[packet, MaxPrecursorIonSelectionMass],
			True
		]
	],
	True
],
Test[
	"If MSMS data belongs to a precursor ion scan (MassAnalysisStage is 1) then CorrelatedFragmentIonData is informed:",
	Module[{massSpectrometryFunction,massAnalysisStage},
		{massSpectrometryFunction,massAnalysisStage}=Lookup[packet,{AcquisitionMode,MassAnalysisStage}];
		If[massSpectrometryFunction=== MSMS &&massAnalysisStage=== 1,
			NotNullFieldTest[packet, FragmentIonData],
			True
		]
	],
	True
],


Test[
	"If MSMS data belongs to a fragment ion  scan (MassAnalysisStage is 2) then CorrelatedFragmentIonData is informed:",
	Module[{massSpectrometryFunction,massAnalysisStage},
		{massSpectrometryFunction,massAnalysisStage}=Lookup[packet,{AcquisitionMode,MassAnalysisStage}];
		If[massSpectrometryFunction=== MSMS &&massAnalysisStage=== 1,
			NotNullFieldTest[packet, PrecursorIonData],
			True
		]
	],
	True
]
};


(* ::Subsection::Closed:: *)
(*validDataLuminescenceIntensityQTests*)


validDataLuminescenceIntensityQTests[packet:PacketP[{Object[Data,LuminescenceIntensity],Object[Data,LuminescenceKinetics]}]]:=Module[
{dataField,dualDataField,protocolPacket},

dataField=If[MatchQ[packet,PacketP[Object[Data,LuminescenceKinetics]]],
	EmissionTrajectories,
	Intensities
];

dualDataField=If[MatchQ[packet,PacketP[Object[Data,LuminescenceKinetics]]],
	DualEmissionTrajectories,
	DualEmissionIntensities
];

protocolPacket=Download[packet[Protocol]];

Join[
	validPlateReaderDataTests[packet],
	{
		NotNullFieldTest[packet,{dataField,Gains}],
		RequiredTogetherTest[packet,{DualEmissionGains,DualEmissionWavelengths,dualDataField}]
	},
	(* FieldSync checks will break if there is no protocol object. This is checked in a separate test *)
	If[MatchQ[protocolPacket,Null],
		{},
		{
			FieldSyncTest[{protocolPacket,packet},IntegrationTime],
			FieldSyncTest[{protocolPacket,packet},EmissionWavelengths],
			FieldSyncTest[{protocolPacket,packet},DualEmissionWavelengths]
		}
	]
]
];


(* ::Subsection::Closed:: *)
(*validDataLuminescenceSpectroscopyQTests*)


validDataLuminescenceSpectroscopyQTests[packet:PacketP[Object[Data,LuminescenceSpectroscopy]]]:=Module[{protocolPacket},

protocolPacket=Download[packet[Protocol]];

Join[
	validPlateReaderDataTests[packet],
	{NotNullFieldTest[packet,{EmissionSpectrum,Gain}]},
	(* FieldSync checks will break if there is no protocol object. This is checked in a separate test *)
	If[MatchQ[protocolPacket,Null],
		{},
		{
			FieldSyncTest[{protocolPacket,packet},IntegrationTime],
			FieldSyncTest[{protocolPacket,packet},MinEmissionWavelength],
			FieldSyncTest[{protocolPacket,packet},MaxEmissionWavelength]
		}
	]
]
];


(* ::Subsection::Closed:: *)
(*validDataMassSpectrometryQTests*)


validDataMassSpectrometryQTests[packet:PacketP[Object[Data,MassSpectrometry]]]:={
(* shared fields not null *)
NotNullFieldTest[packet, {Instrument, DataFile}], (*Removed SamplesIn*)
UniquelyInformedTest[packet, {Instrument, Sensor}],
UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],

(* shared fields null *)
NullFieldTest[packet, {SamplesOut,Sensor}],

(* unique fields not null *)
NotNullFieldTest[packet, {
		AcquisitionMode,
		MassAnalyzer,
		IonSource,
		IonMode,
		MassAnalysisStage,
		DataType
		}
	],
	


(*Fields that are required together because they depend on each other*)
RequiredTogetherTest[packet, {MinMass, MaxMass}],


(*Logical Maximum/Minimum Tests*)
FieldComparisonTest[packet, {MinMass, MaxMass}, LessEqual],
FieldComparisonTest[packet, {MinLaserPower, MaxLaserPower}, LessEqual],

	(*ESI QQQ new objects*)
	RequiredTogetherTest[packet, {FragmentMinMass, FragmentMaxMass}],
	FieldComparisonTest[packet, {FragmentMinMass, FragmentMaxMass}, LessEqual],

	Sequence@@If[MatchQ[Lookup[packet,MassAnalyzer],TripleQuadrupole],
		{
			NotNullFieldTest[packet, {ESICapillaryVoltage,ScanTime,DeclusteringVoltage,IonGuideVoltage,SourceTemperature,DesolvationTemperature,ScanMode}],
			UniquelyInformedTest[packet,{MinMass,MassSelections}],
			If[MemberQ[Lookup[packet,AcquisitionMode],MSMS],
				NullFieldTest[packet,{CollisionEnergies,CollisionCellExitVoltage}],
				Nothing
			],
			Which[
				MatchQ[Lookup[packet,ScanMode],MultipleReactionMonitoring], NotNullFieldTest[packet,{MultipleReactionMonitoringAssays,ReactionMonitoringIntensity,ReactionMonitoringMassChromatogram,DwellTimes}],
				MatchQ[Lookup[packet,ScanMode],SelectedIonMonitoring], NotNullFieldTest[packet,{IonMonitoringIntensity,IonMonitoringMassChromatogram,DwellTimes}],
				True,NotNullFieldTest[packet,{MassSpectrum}]
			]
		},
		Nothing
	],

	(* Sync Tests *)
With[
	{
		protPacket = If[Not[NullQ[packet[Protocol]]],
			Download[packet[Protocol]]
		]
	},
	If[Not[NullQ[protPacket]],
		FieldSyncTest[{protPacket,packet},IonSource],
		Nothing
	]
],

(*custom tests necessary*)
Test[
	"Analytes, Matrix and Calibrant data is correctly linked:",
	Module[{analytes, matrix,calibrant,ionSource},
		{ionSource,analytes, matrix,calibrant}= Lookup[packet, {IonSource,Analytes, Matrix,Calibrant}];
		If[MatchQ[ionSource,MALDI],
			Or[
				(* Matrix data is linked to calibrant and analyte data*)
				(*(!NullQ[analytes] && NullQ[matrix] &&!NullQ[calibrant]),*)
				(!MatchQ[analytes,{}]&&MatchQ[matrix,{}]&&!MatchQ[calibrant,{}]),
				(* Calibrant data is linked to analytes and matrix data *)
				(*(!NullQ[analytes] && !NullQ[matrix] && NullQ[calibrant]),*)
				(!MatchQ[analytes,{}]&&!MatchQ[matrix,{}]&&MatchQ[calibrant,{}]),
				(* Calibrant data is linked to analytes and matrix data *)
				(*(NullQ[analytes] && !NullQ[matrix] && !NullQ[calibrant])*)
				(MatchQ[analytes,{}]&&!MatchQ[matrix,{}]&&!MatchQ[calibrant,{}]),
				(*For now since we added CalibrantMatrices into the protocol everything could be linked*)
				(!MatchQ[analytes,{}]&&!MatchQ[matrix,{}]&&!MatchQ[calibrant,{}])
			],
			True
		]
	],
	True
],

(* Tests for TOF Analyzer *)
Test[
	"If TOF, AccelerationVoltage is informed:",
	Module[{massAnalyzer,accelerationVoltage},
		{massAnalyzer,accelerationVoltage}=Lookup[packet,{MassAnalyzer,AccelerationVoltage}];
		If[massAnalyzer=== TOF,
			!NullQ[accelerationVoltage],
			True
		]
	],
	True
],
Test[
	"If TOF,  GridVoltage is informed:",
	Module[{massAnalyzer,gridVoltage},
		{massAnalyzer,gridVoltage}=Lookup[packet,{MassAnalyzer,GridVoltage}];
		If[massAnalyzer=== TOF,
			!NullQ[gridVoltage],
			True
		]
	],
	True
],
Test[
	"If TOF,  LensVoltage is informed:",
	Module[{massAnalyzer,lensVoltage},
		{massAnalyzer,lensVoltage}=Lookup[packet,{MassAnalyzer,LensVoltage}];
		If[massAnalyzer=== TOF,
			!NullQ[lensVoltage],
			True
		]
	],
	True
],
Test[
	"If TOF,  DelayTime is informed:",
	Module[{massAnalyzer,delayTime},
		{massAnalyzer,delayTime}=Lookup[packet,{MassAnalyzer,DelayTime}];
		If[massAnalyzer=== TOF,
			!NullQ[delayTime],
			True
		]
	],
	True
],

(*QTOF Specific*)
Test[
	"If QTOF,  SourceVoltageOffset is informed:",
	Module[{massAnalyzer,sourceVoltageOffset},
		{massAnalyzer,sourceVoltageOffset}=Lookup[packet,{MassAnalyzer,SourceVoltageOffset}];
		If[massAnalyzer=== QTOF,
			!NullQ[sourceVoltageOffset],
			True
		]
	],
	True
],

(* Tests for MALDI Source fields *)
Test[
	"If MALDI, LaserFrequency is informed:",
	Module[{ionSource,laserFrequency},
		{ionSource,laserFrequency}=Lookup[packet,{IonSource,LaserFrequency}];
		If[MemberQ[ionSource,MALDI],
			!NullQ[laserFrequency],
			True
		]
	],
	True
],
Test[
	"If MALDI, ShotsPerRaster  is informed:",
	Module[{ionSource,shotsPerRaster},
		{ionSource,shotsPerRaster}=Lookup[packet,{IonSource,ShotsPerRaster}];
		If[MemberQ[ionSource,MALDI],
			!NullQ[shotsPerRaster],
			True
		]
	],
	True
],
Test[
	"If MALDI, MinLaserPower is informed:",
	Module[{ionSource,minLaserPower},
		{ionSource,minLaserPower}=Lookup[packet,{IonSource,MinLaserPower}];
		If[MemberQ[ionSource,MALDI],
			!NullQ[minLaserPower],
			True
		]
	],
	True
],
Test[
	"If MALDI, MaxLaserPower is informed:",
	Module[{ionSource,maxLaserPower},
		{ionSource,maxLaserPower}=Lookup[packet,{IonSource,MaxLaserPower}];
		If[MemberQ[ionSource,MALDI],
			!NullQ[maxLaserPower],
			True
		]
	],
	True
],
Test[
	"If MALDI, DelayTime is informed:",
	Module[{ionSource,delayTime},
		{ionSource,delayTime}=Lookup[packet,{IonSource,DelayTime}];
		If[MemberQ[ionSource,MALDI],
			!NullQ[delayTime],
			True
		]
	],
	True
],

(* Tests for ESI Source fields *)
Test[
	"If  ESI, ESICapillaryVoltage is informed:",
	Module[{ionSource,eSICapillaryVoltage},
		{ionSource,eSICapillaryVoltage}=Lookup[packet,{IonSource,ESICapillaryVoltage}];
		If[MemberQ[ionSource,ESI],
			!NullQ[eSICapillaryVoltage],
			True
		]
	],
	True
],
Test[
	"If ESI, SamplingConeVoltage is informed:",
	Module[{ionSource,samplingConeVoltage},
		{ionSource,samplingConeVoltage}=Lookup[packet,{IonSource,SamplingConeVoltage}];
		If[MemberQ[ionSource,ESI],
			!NullQ[samplingConeVoltage],
			True
		]
	],
	True
],
Test[
	"If ESI, SourceTemperature is informed:",
	Module[{ionSource,sourceTemperature},
		{ionSource,sourceTemperature}=Lookup[packet,{IonSource,SourceTemperature}];
		If[MemberQ[ionSource,ESI],
			!NullQ[sourceTemperature],
			True
		]
	],
	True
],
Test[
	"If ESI, DesolvationTemperature is informed:",
	Module[{ionSource,desolvationTemperature},
		{ionSource,desolvationTemperature}=Lookup[packet,{IonSource,DesolvationTemperature}];
		If[MemberQ[ionSource,ESI],
			!NullQ[desolvationTemperature],
			True
		]
	],
	True
],
Test[
	"If ESI, ConeGasFlow is informed:",
	Module[{ionSource,coneGasFlow},
		{ionSource,coneGasFlow}=Lookup[packet,{IonSource,ConeGasFlow}];
		If[MemberQ[ionSource,ESI],
			!NullQ[coneGasFlow],
			True
		]
	],
	True
],
Test[
	"If ESI, DesolvationGasFlow is informed:",
	Module[{ionSource,desolvationGasFlow},
		{ionSource,desolvationGasFlow}=Lookup[packet,{IonSource,DesolvationGasFlow}];
		If[MemberQ[ionSource,ESI],
			!NullQ[desolvationGasFlow],
			True
		]
	],
	True
]
};


(* ::Subsection::Closed:: *)
(*validDataMeltingPointQTests*)


validDataMeltingPointQTests[packet : PacketP[Object[Data, MeltingPoint]]] := {
	(* shared fields not null *)
	NotNullFieldTest[packet, {
		DateCreated,
		Protocol,
		SamplesIn,
		Instrument,
		AssaySample,
		NumberOfReplicates,
		SealCapillary,
		StartTemperature,
		EquilibrationTime,
		EndTemperature,
		TemperatureRampRate,
		Position,
		MeltingCurve,
		MeltingCurveFile,
		CapillaryVideoFile,
		TransmissionVideoFile,
		MeasurementMethod
	}],

	(* shared fields null *)
	NullFieldTest[packet, {SamplesOut, Sensor}],

	(*Logical Maximum/Minimum Tests*)
	FieldComparisonTest[packet, {StartTemperature, EndTemperature}, Less],

	(* Sync Tests: sync data between replicates *)
	If[
		NullQ[packet[Replicates]],
		Nothing,
		Module[{dataPackets},
			dataPackets = Download[packet[Replicates]];
			{
				FieldSyncTest[Flatten@{dataPackets, packet}, MeasurementMethod],
				FieldSyncTest[Flatten@{dataPackets, packet}, NumberOfReplicates],
				FieldSyncTest[Flatten@{dataPackets, packet}, SealCapillary],
				FieldSyncTest[Flatten@{dataPackets, packet}, StartTemperature],
				FieldSyncTest[Flatten@{dataPackets, packet}, EquilibrationTime],
				FieldSyncTest[Flatten@{dataPackets, packet}, EndTemperature],
				FieldSyncTest[Flatten@{dataPackets, packet}, TemperatureRampRate]
			}
		]
	]
};

(* ::Subsection::Closed:: *)
(*validDataMicroscopeQTests*)


validDataMicroscopeQTests[packet:PacketP[Object[Data,Microscope]]]:={
	(* shared fields not null *)
	NotNullFieldTest[packet,{SamplesIn,Instrument}],
	UniquelyInformedTest[packet,{Protocol,Qualifications,Maintenance}],

	(* Shared Fields that should BE Null*)
	NullFieldTest[packet,{SamplesOut,Sensor}],

	(* run the tests below on old ET data only *)
	If[MatchQ[Lookup[packet,DateCreated],LessP[DateObject[{2016,5}]]],
		{
			(* unique fields not null *)
			NotNullFieldTest[packet,{ObjectiveMagnification,Scale,CameraTemperature,StageX,StageY,PlateModel,Well,BufferModel}],

			(*Fields that are required together *)
			RequiredTogetherTest[packet,{PhaseContrastExposureTime,PhaseContrastImageFile}],
			RequiredTogetherTest[packet,{FluorescenceExposureTime,FluorescenceImageFile,ExcitationWavelength,EmissionWavelength}],
			RequiredTogetherTest[packet,{SecondaryFluorescenceExposureTime,SecondaryFluorescenceImageFile,SecondaryExcitationWavelength,SecondaryEmissionWavelength }],
			RequiredTogetherTest[packet,{TertiaryFluorescenceExposureTime,TertiaryFluorescenceImageFile,TertiaryExcitationWavelength,TertiaryEmissionWavelength }],

			(* ExcitationWavelength \[LessEqual]  EmissionWavelength if both are not Null *)
			FieldComparisonTest[packet,{ExcitationWavelength,EmissionWavelength},LessEqual],
			FieldComparisonTest[packet,{SecondaryExcitationWavelength,SecondaryEmissionWavelength},LessEqual],
			FieldComparisonTest[packet,{TertiaryExcitationWavelength,TertiaryEmissionWavelength},LessEqual]
		},
		Nothing
	]
};


(* ::Subsection::Closed:: *)
(*validDataNMRQTests*)


validDataNMRQTests[packet : PacketP[Object[Data, NMR]]] := {
	(* shared fields not null *)
	NotNullFieldTest[packet, {SamplesIn, Instrument}],
	UniquelyInformedTest[packet, {Instrument, Sensor}],
	UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],
	UniquelyInformedTest[packet, {NMRSpectrum, TimedNMRSpectra}],

	(* shared fields null *)
	NullFieldTest[packet, {Sensor}],

	(* unique fields not null *)
	NotNullFieldTest[packet, {AcquisitionTime, RelaxationDelay, SolventModel, Nucleus, Frequency, Temperature, SweepWidth}]

};



(* ::Subsection::Closed:: *)
(*validDataNMR2DQTests*)


validDataNMR2DQTests[packet:PacketP[Object[Data,NMR2D]]]:={
(* shared fields not null *)
NotNullFieldTest[packet, {SamplesIn, Instrument}],
UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],

(* shared fields null *)
NullFieldTest[packet, {Sensor}],

(* unique fields not null *)
NotNullFieldTest[packet, {ExperimentType,Probe,Frequency,SolventModel,DirectNucleus,IndirectNucleus, DirectNumberOfPoints,DirectAcquisitionTime,DirectSpectralDomain,IndirectNumberOfPoints,IndirectSpectralDomain,SamplingMethod,FreeInductionDecay,NMR2DSpectrum}],

(* Make sure TOCSYMixTime is populated appropriately *)
Test["TOCSYMixTime is populated if and only if ExperimentType -> TOCSY | HSQCTOCSY | HMQCTOCSY:",
	Lookup[packet, {ExperimentType, TOCSYMixTime}],
	Alternatives[
		{TOCSY|HSQCTOCSY|HMQCTOCSY, UnitsP[Millisecond]},
		{Except[TOCSY|HSQCTOCSY|HMQCTOCSY], Null}
	]
]
};


(* ::Subsection::Closed:: *)
(*validDataNephelometryQTests*)


validDataNephelometryQTests[packet:PacketP[Object[Data,Nephelometry]]]:={
	(* Shared Fields which should NOT be null *)
	UniquelyInformedTest[packet, {Instrument, Sensor}],
	UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],


	(* Unique Fields which should NOT be null *)
	NotNullFieldTest[packet,{DataType,Instrument}],

	(* Shared Fields which should be null *)
	NullFieldTest[packet,{SamplesOut,Sensor}],

	(* If there are injections, make sure all info is specified *)
	RequiredTogetherTest[packet,{InjectionSamples,InjectionVolumes,InjectionFlowRates}]


};


(* ::Subsection::Closed:: *)
(*validDataNephelometryKineticsQTests*)


validDataNephelometryKineticsQTests[packet:PacketP[Object[Data,NephelometryKinetics]]]:={
	(* Shared Fields which should NOT be null *)
	UniquelyInformedTest[packet, {Instrument, Sensor}],
	UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],

	(* Shared Fields which should be null *)
	NullFieldTest[packet,{SamplesOut,Sensor}],

	(* Unique Fields which should NOT be null *)
	NotNullFieldTest[packet,{Wells,DataType,DataFile,Instrument}],

	(* If there are injections, make sure all info is specified *)
	RequiredTogetherTest[packet,{InjectionSamples,InjectionTimes,InjectionVolumes,InjectionFlowRates}]

};



(* ::Subsection::Closed:: *)
(*validDataPAGEQTests*)


validDataPAGEQTests[packet:PacketP[Object[Data,PAGE]]]:={
	(* not null shared fields *)
	NotNullFieldTest[packet, {SamplesIn, OptimalLaneIntensity, Instrument}],
	UniquelyInformedTest[packet, {Instrument, Sensor}],
	UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],

	(* null shared fields*)
	(* Data is stored in OptimalGelImageFile and OptimalLaneImageFile *)
	NullFieldTest[packet,DataFile],
	NullFieldTest[packet,SamplesOut],
	NullFieldTest[packet,Sensor],

	(* not null unique fields *)
	NotNullFieldTest[packet,OptimalGelImageFile],
	NotNullFieldTest[packet,OptimalLaneImageFile],
	NotNullFieldTest[packet,LaneNumber],
	NotNullFieldTest[packet,Scale],
	NotNullFieldTest[packet,InvertIntensity],

	(* Standards vs Analytes *)
	NotNullFieldTest[packet,DataType],
	Test["If DataType is Standard, LadderData is not informed and Analytes is optional:",
		Lookup[packet,{DataType,LadderData,Analytes}],
		{Standard,NullP,_}|{Except[Standard],_,_}
	],

	Test["If DataType is Analyte, LadderData must be informed and Analytes is not informed:",
		Lookup[packet,{DataType,LadderData,Analytes}],
		{Analyte,Except[NullP],{}}|{Except[Analyte],_,_}
	],

	(* Gel information *)
	NotNullFieldTest[packet,{GelModel,GelMaterial,GelPercentage,DenaturingGel}],

	With[
		{
			gelModelPacket = If[Not[NullQ[packet[GelModel]]],
				Download[packet[GelModel]]
			]
		},
		If[Not[NullQ[gelModelPacket]],
			{
				FieldSyncTest[{packet,gelModelPacket},GelMaterial],
				FieldSyncTest[{packet,gelModelPacket},GelPercentage],
				FieldSyncTest[{packet,gelModelPacket},CrosslinkerRatio]
			},
			Nothing
		]
	],

	(* Method information *)
	NotNullFieldTest[packet,{Voltage,SeparationTime,DutyCycle,CycleDuration,OptimalExposureTime}],
	RequiredTogetherTest[packet,{ExcitationWavelength,EmissionWavelength,ExcitationBandwidth,EmissionBandwidth}],

	With[
		{
			protPacket = If[Not[NullQ[packet[Protocol]]],
				Download[packet[Protocol]]
			]
		},
		If[Not[NullQ[protPacket]],
			{
				FieldSyncTest[{protPacket,packet},Voltage],
				FieldSyncTest[{protPacket,packet},SeparationTime],
				FieldSyncTest[{protPacket,packet},DutyCycle],
				FieldSyncTest[{protPacket,packet},StainingTime],
				FieldSyncTest[{protPacket,packet},ExcitationWavelength],
				FieldSyncTest[{protPacket,packet},ExcitationBandwidth],
				FieldSyncTest[{protPacket,packet},EmissionWavelength],
				FieldSyncTest[{protPacket,packet},EmissionBandwidth],
				FieldSyncTest[{protPacket,packet},CycleDuration],
				FieldSyncTest[{protPacket,packet},GelMaterial],
				FieldSyncTest[{protPacket,packet},GelPercentage],
				FieldSyncTest[{protPacket,packet},CrosslinkerRatio],
				FieldSyncTest[{protPacket,packet},DenaturingGel]
			},
			Nothing
		]
	]
};


(* ::Subsection::Closed:: *)
(*validDatapHAdjustmentQTests*)


validDatapHAdjustmentQTests[packet:PacketP[Object[Data,pHAdjustment]]]:= {
	(* Shared Field Shaping *)
	NullFieldTest[packet,{SamplesOut}],

	NotNullFieldTest[packet,{Probe}]
};



(* ::Subsection::Closed:: *)
(*validDatapHQTests*)


validDatapHQTests[packet:PacketP[Object[Data,pH]]]:=
{
(* Shared Field Shaping *)
NullFieldTest[packet,{SamplesOut}],

RequiredTogetherTest[packet,{Instrument,DataFile,CalibrationData}],

(* max of one of protocols,qualifications,maintenance should be informed *)
Test["Not more than one of protocols, qualifications, and maintenance should be informed:",
	Count[Lookup[packet,{Protocol,Maintenance,Qualifications}],Except[Null]],
	RangeP[0,1,1]
]
};


(* ::Subsection::Closed:: *)
(*validDataPressureQTests*)


validDataPressureQTests[packet:PacketP[Object[Data,Pressure]]]:=
{
(* Shared Field Shaping *)
NullFieldTest[packet,{SamplesIn,SamplesOut,Instrument,DataFile}],

NotNullFieldTest[packet,Sensor],
UniquelyInformedTest[packet, {Instrument, Sensor}],

(* Unique Fields which should NOT be null *)
NotNullFieldTest[packet,{PressureLog,RawData}],

(* Sensible Min/Max *)
RequiredTogetherTest[packet,{FirstDataPoint,LastDataPoint}],
FieldComparisonTest[packet,{FirstDataPoint,LastDataPoint},LessEqual],

(* max of one of protocols,qualifications,maintenance should be informed *)
Test["Not more than one of protocols, qualifications, and maintenance should be informed:",
	Count[Lookup[packet,{Protocol,Maintenance,Qualifications}],Except[Null]],
	RangeP[0,1,1]
]
};


(* ::Subsection::Closed:: *)
(*validDataRamanSpectroscopyQTests*)


validDataRamanSpectroscopyQTests[packet:PacketP[Object[Data,RamanSpectroscopy]]]:={

	(* not null shared fields *)
	NotNullFieldTest[packet, {SamplesIn, Instrument, DataFile, DateCreated}],

	(*only one these *)
	UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],

	(* null shared fields *)
	NullFieldTest[packet, {Sensor, SamplesOut}],

	(* not null unique fields *)
	NotNullFieldTest[packet, {
		RamanSpectra,
		UnblankedRamanSpectra,
		AverageRamanSpectrum,
		MeasurementPositions,
		WellCenterPosition,
		DetectorExposure,
		LaserPowerPercentage,
		Objective
	}],

	(* if there are images we need all the info for them *)
	RequiredTogetherTest[packet,{
		OpticalImages,
		LedBrightness,
		CameraExposure
	}],

	(* The measurement positions field must be of the same length as the RamanSpectra field *)
	Test[
		"Each RamanSpectra element has a cooresponding position in MeasurementPositions:",
		MatchQ[Length[Lookup[packet, RamanSpectra]], Length[Lookup[packet, MeasurementPositions]]],
		True
	]
};



(* ::Subsection::Closed:: *)
(*validDataqPCRQTests*)


validDataqPCRQTests[packet:PacketP[Object[Data,qPCR]]]:={

(* not null shared fields *)
NotNullFieldTest[packet, {SamplesIn, Instrument, DataFile}],

UniquelyInformedTest[packet, {Instrument, Sensor}],
UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],

(* null shared fields *)
NullFieldTest[packet, {Sensor,SamplesOut}],

(* not null unique fields *)
NotNullFieldTest[packet, {
	Primers,
	Well,
	TemplateOligomerType,
	DataType,
	AmplificationCurveTypes,
	ExcitationWavelengths,
	EmissionWavelengths,
	AmplificationCurves,
	AmplificationReadTemperature
}],

(* If a passive reference dye was used, RawAmplificationCurves should be populated *)
Test[
	"RawAmplificationCurves is populated if the associated protocol specifies use of a passive reference dye:",
	{Download[Lookup[packet, Protocol], ReferenceDye], Lookup[packet, RawAmplificationCurves]},
	{Except[Null], Except[{}]} | {Null, {}}
],

(* MeltingCurves should be populated if and only if MeltingCurve->True in the associated protocol *)
Test[
	"MeltingCurves is populated if and only if MeltingCurve->True if the associated protocol specifies MeltingCurve->True:",
	{Download[Lookup[packet, Protocol], MeltingCurve], Lookup[packet, MeltingCurves]},
	{True, Except[{}]} | {False, {}}
],

(* If a passive reference dye was used and MeltingCurve->True in protocol, RawMeltingCurves should be populated *)
Test[
	"RawMeltingCurves is populated if the associated protocol specifies use of a passive reference dye and MeltingCurve->True:",
	{Download[Lookup[packet, Protocol], {MeltingCurve, ReferenceDye}], Lookup[packet, RawMeltingCurves]},
	{{True, Except[Null]}, Except[{}]} | {Except[{True, Except[Null]}], {}}
],

(* Make sure Dilution is populated for standard data *)
Test[
	"Dilution must be populated if and only if this is a piece of standard data:",
	Lookup[packet, {DataType, Dilution}],
	{StandardCurve, Except[Null]} | {Except[StandardCurve], Null}
],


(* wavelengths should be related properly
	Can't use FieldComparisonTest here because both are multiple *)
Test[
	"All members of ExcitationWavelength are less than the corresponding entries in EmissionWavelength:",
	MapThread[
		Less,
		Lookup[packet, {ExcitationWavelengths, EmissionWavelengths}]
	],
	{True..}
]
};


(* ::Subsection::Closed:: *)
(*validDataDigitalPCRQTests*)


validDataDigitalPCRQTests[packet:PacketP[Object[Data,DigitalPCR]]]:={

	(* not null shared fields *)
	NotNullFieldTest[packet, {SamplesIn, Instrument, DataFile}],

	(* not null unique fields *)
	NotNullFieldTest[packet, {
		Well,
		ExcitationWavelengths,
		EmissionWavelengths
	}]

	(* add more tests for unique fields *)
};

(* ::Subsection::Closed:: *)
(*validDataRefractiveIndexQTests*)

validDataRefractiveIndexQTest[packet:PacketP[Object[Data,RefractiveIndex]]]:={
	NotNullFieldTest[packet,
		{
			SamplesIn,
			RefractiveIndex,
			Temperature,
			MethodFiles,
			DataFiles,
			Protocol
		}]
};

(* ::Subsection::Closed:: *)
(*validDataRelativeHumidityQTests*)


validDataRelativeHumidityQTests[packet:PacketP[Object[Data,RelativeHumidity]]]:=
{
(* Shared Fields which should NOT be null *)
NotNullFieldTest[packet,Sensor],
UniquelyInformedTest[packet, {Instrument, Sensor}],

(* Shared Fields which should be null *)
NullFieldTest[packet,{SamplesIn,SamplesOut,Instrument,DataFile}],

(* Unique Fields which should NOT be null *)
NotNullFieldTest[packet,{RelativeHumidityLog,RawData}],

(* Sensible Min/Max *)
RequiredTogetherTest[packet,{FirstDataPoint,LastDataPoint}],
FieldComparisonTest[packet,{FirstDataPoint,LastDataPoint},LessEqual],

(* max of one of protocols,qualifications,maintenance should be informed *)
Test["Not more than one of protocols, qualifications, and maintenance should be informed:",
	Count[Lookup[packet,{Protocol,Maintenance,Qualifications}],Except[Null]],
	RangeP[0,1,1]
]
};



(* ::Subsection::Closed:: *)
(*validDataTemperatureQTests*)


validDataSurfaceTensionQTests[packet:PacketP[Object[Data,SurfaceTension]]]:={
(* Shared Fields which should NOT be null *)
NotNullFieldTest[packet,{Composition,AliquotSamples,DataFile,SamplesIn}],

(* Unique Fields which should NOT be null *)
NotNullFieldTest[packet,{SurfaceTensions,Temperatures}],

(* max of one of protocols,qualifications,maintenance should be informed *)
Test["Not more than one of protocols, qualifications, and maintenance should be informed:",
	Count[Lookup[packet,{Protocol,Maintenance,Qualifications}],Except[Null]],
	RangeP[0,1,1]
]
};


(* ::Subsection::Closed:: *)
(*validDataTemperatureQTests*)


validDataTemperatureQTests[packet:PacketP[Object[Data,Temperature]]]:={
(* Shared Fields which should NOT be null *)
NotNullFieldTest[packet,Sensor],
UniquelyInformedTest[packet, {Instrument, Sensor}],

(* Shared Fields which should be null *)
NullFieldTest[packet,{SamplesOut,Instrument,DataFile}],

(* Unique Fields which should NOT be null *)
NotNullFieldTest[packet,{TemperatureLog,RawData}],

(* Sensible Min/Max *)
RequiredTogetherTest[packet,{FirstDataPoint,LastDataPoint}],
FieldComparisonTest[packet,{FirstDataPoint,LastDataPoint},LessEqual],

(* max of one of protocols,qualifications,maintenance should be informed *)
Test["Not more than one of protocols, qualifications, and maintenance should be informed:",
	Count[Lookup[packet,{Protocol,Maintenance,Qualifications}],Except[Null]],
	RangeP[0,1,1]
]
};



(* ::Subsection::Closed:: *)
(*validDataFlowRateQTests*)


validDataFlowRateQTests[packet:PacketP[Object[Data,FlowRate]]] := {
(* Shared Fields which should NOT be null *)
NotNullFieldTest[packet,Sensor],
UniquelyInformedTest[packet, {Instrument, Sensor}],

(* Shared Fields which should be null *)
NullFieldTest[packet,{SamplesOut,Instrument,DataFile}],

(* Unique Fields which should NOT be null *)
NotNullFieldTest[packet,{FlowRateLog,RawData}],

(* Sensible Min/Max *)
RequiredTogetherTest[packet,{FirstDataPoint,LastDataPoint}],
FieldComparisonTest[packet,{FirstDataPoint,LastDataPoint},LessEqual],

(* max of one of protocols,qualifications,maintenance should be informed *)
Test["Not more than one of protocols, qualifications, and maintenance should be informed:",
	Count[Lookup[packet,{Protocol,Maintenance,Qualifications}],Except[Null]],
	RangeP[0,1,1]
]
};



(* ::Subsection::Closed:: *)
(*validDataTLCQTests*)


validDataTLCQTests[packet:PacketP[Object[Data,TLC]]] := {
(* not null shared fields *)
UniquelyInformedTest[packet, {Instrument, Sensor}],
UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],
NotNullFieldTest[packet, {SamplesIn,Instrument }],

(* null shared fields *)
NullFieldTest[packet,{SamplesOut,DataFile}],

(* not null unique fields *)
NotNullFieldTest[packet, {DarkroomImageFile,PlateImageFile,LaneImageFile,LaneNumber,Scale,InvertIntensity,ExposureTime,RelativeAperture,ISOSensitivity}]
};


(* ::Subsection::Closed:: *)
(*validDataVacuumEvaporationQTests*)


validDataVacuumEvaporationQTests[packet:PacketP[Object[Data,VacuumEvaporation]]] := {
(* Shared Fields which should NOT be null *)
UniquelyInformedTest[packet, {Instrument, Sensor}],
UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],
NotNullFieldTest[packet,{Instrument,DataFile,SamplesIn}],


(* Shared Fields which should be null *)
NullFieldTest[packet,{SamplesOut,Sensor}],

(* unique fields *)
AnyInformedTest[packet, {CentrifugalForce, RotationRate}],
NotNullFieldTest[packet,{EquilibrationTime,EvaporationTime,NominalTemperature,EquilibrationPressure,EvaporationPressure,VacuumEvaporationMethod,Temperature,Pressure}],


(* data should be synced with protocol *)
With[
	{
		protPacket = If[Not[NullQ[packet[Protocol]]],
			Download[packet[Protocol]]
		]
	},
	If[Not[NullQ[protPacket]],
		{
			FieldSyncTest[{protPacket,packet},EquilibrationTime],
			FieldSyncTest[{protPacket,packet},EvaporationTime],
			FieldSyncTest[{protPacket,packet},CentrifugalForce],
			FieldSyncTest[{protPacket,packet},RotationRate],
			FieldSyncTest[{protPacket,packet},EquilibrationPressure],
			FieldSyncTest[{protPacket,packet},EvaporationPressure],
			FieldSyncTest[{protPacket,packet},VacuumEvaporationMethod]
		},
		Nothing
	]
]
};


(* ::Subsection::Closed:: *)
(*validDataViscosityQTests*)


validDataViscosityQTests[packet:PacketP[Object[Data,Viscosity]]] := {
(* not null shared fields *)
NotNullFieldTest[packet,{SamplesIn,DataFile,Instrument}],
UniquelyInformedTest[packet, {Instrument, Sensor}],
UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],

(* not null unique fields *)
NotNullFieldTest[packet,{
		MeasurementMethod,
		ViscometerChip,
		InjectionVolumes,
		MeasurementMethodTable
	}
]
};
(* ::Subsection::Closed:: *)
(*validDataDistanceQTests*)


validDataDistanceQTests[packet:PacketP[Object[Data,Distance]]]:={
		Test["At least one of sensor/instrument populated",
			Lookup[packet,{Sensor,Instrument}],
			Except[NullP]
		],

		(* null shared fields*)
		NullFieldTest[packet,SamplesOut],

		(* always needed *)
		NotNullFieldTest[packet,{Distance,DistanceStandardDeviation,DistanceDistribution}],

		Test["If Distance is informed, so are the statistical related fields:",
			Lookup[packet,{Distance,DistanceStandardDeviation,DistanceDistribution}],
			{Null,_,_}|{DistanceP,DistanceP,DistributionP[]}
		]
};

(* ::Subsection::Closed:: *)
(*validDataVolumeQTests*)


validDataVolumeQTests[packet:PacketP[Object[Data,Volume]]]:=Switch[Lookup[packet,{MeasurementMethod,Protocol}],
{Ultrasonic,_},
	{
		Test["At least one of sensor/instrument populated",
			Lookup[packet,{Sensor,Instrument}],
			Except[NullP]
		],

		If[!MatchQ[Lookup[packet,DataType],Tare]&&!MatchQ[Lookup[packet,Sensor],ObjectP[]],
			UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],
			Nothing
		],

		(* null shared fields*)
		NullFieldTest[packet,SamplesOut],

		(* always needed *)
		NotNullFieldTest[packet,{LiquidLevel,LiquidLevelStandardDeviation,NumberOfReadings,MeasurementMethod,DataType}],

		Test["If data is not a Tare reading, SampleContainer and ContainerModel are informed:",
			Lookup[packet,{DataType,SampleContainer,ContainerModel}],
			{Tare,NullP,NullP}|{Except[Tare],Except[NullP],Except[NullP]}
		],

		Test["SamplesIn is populated for analyte data from a protocol:",
			Lookup[packet,{DataType,Protocol,SamplesIn}],
			{Tare,_,_}|{Except[Tare],Except[Null],Except[{}]}|{Except[Tare],Null,_}
		],

		Test["If QuantificationAnalyses is informed, Volume must be informed:",
			Lookup[packet,{QuantificationAnalyses,Volume}],
			Alternatives[
				{Except[NullP|{}],Except[NullP|{}]},
				{NullP|{},_}
			]
		],

		Test["Volume must be informed, unless the associated protocol is a plate calibration maintenance, or the data type is tare:",
			Lookup[packet,{DataType,Volume,Protocol,Maintenance}],
			{Except[Tare],Except[NullP|{}],_,_}|{_,NullP|{},NullP|{},Except[NullP|{}]}|{Tare,NullP|{},_,_}
		],

		Test["If Volume is informed, so are the error fields and a calibration:",
			Lookup[packet,{Volume,VolumeStandardDeviation,VolumeDistribution,VolumeCalibration}],
			{Null,_,_,_}|{VolumeP,VolumeP,DistributionP[],Except[NullP]}
		]
	},
{Gravimetric,ObjectP[Object[Protocol]]},
	{
		(* not null fields *)
		NotNullFieldTest[packet,{Instrument,DataType,Volume,VolumeStandardDeviation,VolumeDistribution,Weight,WeightStandardDeviation,WeightDistribution,WeightData,SampleContainer,ContainerModel,SamplesIn}],
		UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}]
	},
{Gravimetric,Null},
	{
		(* not null shared fields *)
		NotNullFieldTest[packet,Instrument],
		UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],

		(* null shared fields*)
		NullFieldTest[packet,{SamplesOut,MeasurementMethod,DataType,Volume}]
	},
{Gravimetric,Null},
	{
		NotNullFieldTest[packet,MeasurementMethod]
	},
_,
	{}
];



(* ::Subsection::Closed:: *)
(*validDataWeightQTests*)


(* Choose tests based on protocol *)
validDataWeightQTests[packet:PacketP[Object[Data,Weight]]] := Which[

(* If it is from Rosetta protocol[MeasureWeight *)
MatchQ[Lookup[packet,Protocol],ObjectP[Object[Protocol,MeasureWeight]]],
{
	(* Shared Fields which should be null *)
	NullFieldTest[packet,{DataFile,SamplesOut}],

	(* Shared Fields that should not be null *)
	NotNullFieldTest[packet,{Sensor,Weight,WeightStandardDeviation,WeightDistribution}],

	Test[
		"If the DataType is Analyte, then SamplesIn should be informed:",
		Lookup[packet,{DataType, SamplesIn}],
		Alternatives[{Analyte, Except[NullP|{}]},{Except[Analyte],_}]
	],

	(* sensor net stuff *)
	NotNullFieldTest[packet,{WeightLog,FirstDataPoint,LastDataPoint,DailyLog,RawData}],

	(* Tare data and tare weight should be required together, if informed *)
	Test[
		"If TareData is informed, TareWeight must be informed. If TareWeight is informed, TareData need not be informed:",
		Lookup[packet,{TareData, TareWeight}],
		Alternatives[{Except[NullP],Except[NullP]}, {NullP,_}]
	],

	(* Residue data and Residue weight should be required together, if informed *)
	RequiredTogetherTest[packet,{ResidueWeightData, ResidueWeight}],

	 (* should be filled out together. These fields are informed only at end of protocol, so is not included in NotNullFieldTest  *)
	 RequiredTogetherTest[packet,{Instrument,BalanceType,SampleContainer,ContainerModel,DataType}]
},

(* If it is from protocol[Centrifuge] *)
MatchQ[Lookup[packet,Protocol],ObjectP[Object[Protocol,Centrifuge]]],
{
	(* Shared Fields which should be null *)
	NullFieldTest[packet,{DataFile,SamplesIn,SamplesOut}],
	(* Shared Fields that should not be null *)
	NotNullFieldTest[packet,{Sensor}],
	(* not null unique fields *)
	NotNullFieldTest[packet,{Weight,WeightStandardDeviation,WeightDistribution}],
	(* should be filled out together. These fields are informed only at end of protocol, so is not included in NotNull FieldTest  *)
	RequiredTogetherTest[packet,{Instrument, BalanceType, DataType}],

	(* sensor net stuff *)
	NotNullFieldTest[packet,{WeightLog,FirstDataPoint,LastDataPoint,DailyLog,RawData}],

	Sequence@@If[MatchQ[Lookup[packet,DataType],Container],
		{
			NotNullFieldTest[packet,{SampleContainer,ContainerModel}]
		},
		{
			NullFieldTest[packet,{SampleContainer,ContainerModel }]
		}
	]
},

(* If it is from protocol[PNASynthesis] *)
MatchQ[Lookup[packet,Protocol],ObjectP[Object[Protocol, PNASynthesis]]],
{
	(* Shared Fields that should not be null *)
	NotNullFieldTest[packet,{
			Sensor,
			Weight,
			WeightStandardDeviation,
			WeightDistribution,
			WeightLog,
			FirstDataPoint,
			LastDataPoint,
			DailyLog,
			RawData
		}
	]
},

(* anything else. e.g. for waste measurements etc *)
True,
{
	(* sensor net stuff *)
	NotNullFieldTest[packet,{WeightLog,FirstDataPoint,LastDataPoint,DailyLog,RawData}]

}
];


(* ::Subsection::Closed:: *)
(*validDataWesternQTests*)


validDataWesternQTests[packet:PacketP[Object[Data,Western]]] := {
(* not null shared fields *)
NotNullFieldTest[packet,{SamplesIn,DataFile,Instrument}],
UniquelyInformedTest[packet, {Instrument, Sensor}],
UniquelyInformedTest[packet, {Protocol, Qualifications, Maintenance}],

(* null shared fields *)
NullFieldTest[packet,SamplesOut],

(* not null unique fields *)
NotNullFieldTest[packet,{
		CapillaryNumber,
		SeparatingMatrixLoadTime,
		StackingMatrixLoadTime,
		SampleLoadTime,
		SeparationTime,
		Voltage,
		UVExposureTime,
		BlockingTime,
		SignalDetectionTimes,
		MassSpectrum
	}
],

(* both of these associated data fields should not be informed simultaneously *)
UniquelyInformedTest[packet,{LadderData,Analytes}]
};



(* ::Subsection::Closed:: *)
(*validDataXRayDiffractionQTests*)


validDataXRayDiffractionQTests[packet:PacketP[Object[Data,XRayDiffraction]]]:={
NotNullFieldTest[
	packet,
	{
		ExperimentType,
		BeamPower,
		Voltage,
		Current,
		ExposureTime
	}
],

Test["If ExperimentType -> SingleCrystal, Reflections must be populated; otherwise, it must be {}:",
	Lookup[packet, {ExperimentType, Reflections}],
	{SingleCrystal, Except[{}]} | {Powder, {}}
],

Test["If ExperimentType -> Powder, DiffractionPattern must be populated; otherwise, it must be Null:",
	Lookup[packet, {ExperimentType, DiffractionPattern}],
	{Powder, QuantityArrayP[{{AngularDegree, ArbitraryUnit}..}]} | {SingleCrystal, Null}
]
};


(* ::Subsection::Closed:: *)
(*validDataIRSpectroscopyQTests*)


validDataIRSpectroscopyQTests[packet:PacketP[Object[Data,IRSpectroscopy]]]:={
NotNullFieldTest[
	packet,
	{
		WavenumberResolution,
		ExportDirectory,
		MinWavenumber,
		MaxWavenumber,
		MethodFiles,
		Instrument
	}
],

Test["If DataType -> Blank and Blanks -> Null, then LoadingSample should be Null. Otherwise, it should be informed:",
	Lookup[packet, {Blanks, DataType, LoadingSamples}],
	{Null,Blank,Null} | {Null,Blank,{}} | {_, Analyte, Except[Null]} | {Except[Null], Blank, Except[Null]}
],

UniquelyInformedTest[packet, {IntegrationTime, NumberOfReadings}],
RequiredTogetherTest[packet,{BlankAmount, Blanks}],

Test["If DataType -> Analyte, SamplesIn and SampleAmount must be informed:",
	Lookup[packet,{DataType,SamplesIn,SampleAmount}],
	{Analyte, Except[Null|{}],Except[Null]} | {Except[Analyte],_,_}
],

RequiredTogetherTest[packet,{SampleAmount, SamplesIn}],
RequiredTogetherTest[packet,{SuspensionSolutionVolume, SuspensionSolution}]
};



(* ::Subsection::Closed:: *)
(*validFragmentAnalysisDataTests*)


validFragmentAnalysisDataTests[packet:PacketP[Object[Data,FragmentAnalysis]]]:={
	NotNullFieldTest[
		packet,
		{
			Well,
			SampleType
		}
	],

	RequiredTogetherTest[packet,{FragmentSizeAnalyses, FragmentSizeAnalysesImage}]
};



(* ::Subsection::Closed:: *)
(*validPlateReaderDataTests*)


validPlateReaderDataTests[packet:PacketP[{Object[Data,FluorescenceIntensity],Object[Data,FluorescenceKinetics],Object[Data,FluorescencePolarization],Object[Data,FluorescencePolarizationKinetics],Object[Data,FluorescenceSpectroscopy],Object[Data,LuminescenceIntensity],Object[Data,LuminescenceKinetics],Object[Data,LuminescenceSpectroscopy]}]]:=Module[{protocolPacket}, protocolPacket=Download[packet[Protocol]];

Join[
	{
		(* Shared Fields - Null *)
		NullFieldTest[packet,{SamplesOut,Sensor}],

		(* Shared Fields - NotNull *)
		NotNullFieldTest[packet,{SamplesIn,Protocol,Instrument,DataFile}],
		UniquelyInformedTest[packet,{Instrument,Sensor}],
		UniquelyInformedTest[packet,{Protocol,Qualifications,Maintenance}],

		(* Specific Fields *)
		NotNullFieldTest[packet,{Well,Temperature}],

		If[MatchQ[packet,PacketP[{Object[Data,FluorescenceKinetics],Object[Data,LuminescenceKinetics]}]],
			RequiredTogetherTest[packet,
				{
					InjectionFlowRates,
					InjectionTimes,
					InjectionVolumes,
					InjectionSamples
				}
			],
			RequiredTogetherTest[packet,
				{
					InjectionFlowRates,
					InjectionVolumes,
					InjectionSamples
				}
			]
		]
	},
	(* Data method information should be synced with protocol *)
	(* FieldSync checks will break if there is no protocol object. This is checked in a separate test *)
	If[MatchQ[protocolPacket,Null],
		{},
		{FieldSyncTest[{protocolPacket,packet},ReadLocation]}
	]
]
];


(* ::Subsection::Closed:: *)
(*validDataOsmolalityQTests*)

validDataOsmolalityQTests[packet:PacketP[Object[Data,Osmolality]]]:={
	(* Not null fields *)
	NotNullFieldTest[packet,{
		SamplesIn,
		DataFile,
		Instrument,
		MeasurementMethod,
		Osmolality
	}],

	(*Null tests*)
	NullFieldTest[packet,{
		SamplesOut
	}],


	(*If calibrants are listed, the osmolalities must be provided*)
	RequiredTogetherTest[packet,{Calibrants,CalibrantOsmolalities}]
};


(* ::Subsection::Closed:: *)
(*validDataCircularDichroismQTests*)

validDataCircularDichroismQTests[packet:PacketP[Object[Data,CircularDichroism]]]:={
	(* Not null fields *)
	NotNullFieldTest[packet,{
		DataType,
		ReadPlate,
		Instrument,
		Well,
		AverageTime,
		AbsorbanceSpectrum,
		AbsorbanceDifferenceSpectrum,
		CircularDichroismAbsorbanceSpectrum

	}],

	UniquelyInformedTest[packet,{MinWavelength,	Wavelengths}],
	RequiredTogetherTest[packet,{MinWavelength,MaxWavelength}],

	If[
		MatchQ[Lookup[packet,DateType],(Analyte)],
		NotNullFieldTest[packet{SamplesIn,UnblankedAbsorbanceDifferenceSpectrum,UnblankedCircularDichroismAbsorbanceSpectrum,UnblankedAbsorbanceSpectrum}],
		Nothing
	],
	If[
		MatchQ[Lookup[packet,DateType],(Analyte|Blank)],
		NotNullFieldTest[packet,{SampleVolume}],
		Nothing
	],

	If[
		MatchQ[Lookup[packet,DateType],(Blank|Empty)],
		NotNullFieldTest[packet,{AnalyteSpectra}],
		Nothing
	]

};


(* ::Subsection::Closed:: *)
(*validDataDynamicFoamAnalysisQTests*)

validDataDynamicFoamAnalysisQTests[packet:PacketP[Object[Data,DynamicFoamAnalysis]]]:={
	(* Not null fields *)
	NotNullFieldTest[packet,{
		SamplesIn,
		RawDataFiles,
		Instrument,
		SampleVolume,
		AgitationTime,
		DecayTime,
		Wavelength,
		FoamHeight,
		LiquidHeight,
		TotalFoamLiquidHeight,
		FoamVolume,
		LiquidVolume,
		TotalFoamLiquidVolume,
		FoamVolumeStability,
		FoamLiquidStability,
		FoamHeightParameters
	}],

	(*If liquid conductivity method was used, these will be not null*)
	RequiredTogetherTest[packet,{
		LiquidContentSensor1,
		LiquidContentSensor2,
		LiquidContentSensor3,
		LiquidContentSensor4,
		LiquidContentSensor5,
		LiquidContentSensor6,
		LiquidContentSensor7,
		ResistanceReferenceSensor,
		ResistanceSensor1,
		ResistanceSensor2,
		ResistanceSensor3,
		ResistanceSensor4,
		ResistanceSensor5,
		ResistanceSensor6,
		ResistanceSensor7,
		LiquidConductivityParametersSensor1,
		LiquidConductivityParametersSensor2,
		LiquidConductivityParametersSensor3,
		LiquidConductivityParametersSensor4,
		LiquidConductivityParametersSensor5,
		LiquidConductivityParametersSensor6,
		LiquidConductivityParametersSensor7
	}],

	(*If structure method was used, these will be not null*)
	RequiredTogetherTest[packet,{
		BubbleCount,
		MeanBubbleArea,
		StandardDeviationBubbleArea,
		AverageBubbleRadius,
		MeanSquareBubbleRadius,
		BubbleSauterMeanRadius,
		FoamStructureParameters
	}],

	(* If foaming method was used, these should both be populated *)
	RequiredTogetherTest[packet,{
		ConvertedVideoFile,
		RawVideoFile
	}]
};

(* ::Subsection::Closed:: *)
(*validDataLiquidParticleCountQTests*)

validDataLiquidParticleCountQTests[packet:PacketP[Object[Data,LiquidParticleCount]]]:={
	(* Not null fields *)
	NotNullFieldTest[packet,
		{
			Syringe,
			ReadingVolume,
			ParticleSizes,
			NumberOfReading,
			DiscardFirstRun,
			FlowRate,
			LiquidParticleCount,
			SummationCounts,
			CumulativeCounts
		}
	],

	RequiredTogetherTest[packet,
		{
			DilutionFactor,
			Diluent,
			DilutionMixVolume,
			DilutionNumberOfMix,
			DilutionMixRate
		}
	]

};



(* ::Subsection::Closed:: *)
(*validDataQuantifyCellsQTests*)

validDataQuantifyCellsQTests[packet:PacketP[Object[Data,QuantifyCells]]]:={
	(* Not null fields *)
	NotNullFieldTest[packet,
		{
			Methods,
			QuantificationUnit,
			Instruments
		}
	],
	RequiredTogetherTest[packet,
		{
			Absorbances,
			AbsorbanceData
		}
	],
	RequiredTogetherTest[packet,
		{
			Turbidities,
			NephelometryData
		}
	]

};



(* ::Subsection::Closed:: *)
(*validDataQuantifyColoniesQTests*)

validDataQuantifyColoniesQTests[packet:PacketP[Object[Data,QuantifyColonies]]]:={
	(* Not null fields *)
	NotNullFieldTest[packet,
		{
			QuantificationColonySamples,
			QuantificationColonyDilutionFactors,
			MinReliableColonyCount,
			MaxReliableColonyCount,
			AllColonyAppearanceLog,
			ColonyAnalysisLog,
			TotalColonyCountsLog
		}
	],

	RequiredTogetherTest[packet,
		{
			TotalColonyCounts,
			PopulationTotalColonyCount,
			CellConcentration
		}
	]

};



(* ::Subsection:: *)
(* Test Registration *)


registerValidQTestFunction[Object[Data],validDataQTests];
registerValidQTestFunction[Object[Data, AbsorbanceIntensity],validDataAbsorbanceIntensityQTests];
registerValidQTestFunction[Object[Data, AbsorbanceKinetics],validDataAbsorbanceKineticsQTests];
registerValidQTestFunction[Object[Data, AbsorbanceSpectroscopy],validDataAbsorbanceSpectroscopyQTests];
registerValidQTestFunction[Object[Data, AcousticLiquidHandling],validDataAcousticLiquidHandlingQTests];
registerValidQTestFunction[Object[Data, AgaroseGelElectrophoresis],validDataAgaroseGelElectrophoresisQTests];
registerValidQTestFunction[Object[Data, AlphaScreen],validDataAlphaScreenQTests];
registerValidQTestFunction[Object[Data, BioLayerInterferometry], validDataBioLayerInterferometryQTests];
registerValidQTestFunction[Object[Data, MeltingCurve],validDataUVMeltingQTests];
registerValidQTestFunction[Object[Data, Appearance],validDataAppearanceQTests];
registerValidQTestFunction[Object[Data, Appearance, Colonies],validDataAppearanceColoniesQTests];
registerValidQTestFunction[Object[Data, ELISA],validDataELISAQTests];
registerValidQTestFunction[Object[Data, CarbonDioxide],validDataCarbonDioxideQTests];
registerValidQTestFunction[Object[Data, CapillaryIsoelectricFocusing],validDataCapillaryIsoelectricFocusingQTests];
registerValidQTestFunction[Object[Data, CapillaryGelElectrophoresisSDS],validDataCapillaryGelElectrophoresisSDSQTests];
registerValidQTestFunction[Object[Data, FragmentAnalysis],validDataFragmentAnalysisQTests];
registerValidQTestFunction[Object[Data, Chromatography],validDataChromatographyQTests];
registerValidQTestFunction[Object[Data, ChromatographyMassSpectra],validDataChromatographyMassSpectraQTests];
registerValidQTestFunction[Object[Data, Conductivity],validDataConductivityQTests];
registerValidQTestFunction[Object[Data, ContactAngle],validDataContactAngleQTests];
registerValidQTestFunction[Object[Data, CoulterCount],validDataCoulterCountQTests];
registerValidQTestFunction[Object[Data, CrossFlowFiltration],validDataCrossFlowQTests];
registerValidQTestFunction[Object[Data, CyclicVoltammetry],validDataCyclicVoltammetryQTests];
registerValidQTestFunction[Object[Data, DNASequencing],validDataDNASequencingQTests];
registerValidQTestFunction[Object[Data, DifferentialScanningCalorimetry],validDataDifferentialScanningCalorimetryQTests];
registerValidQTestFunction[Object[Data, DissolvedOxygen],validDataDissolvedOxygenQTests];
registerValidQTestFunction[Object[Data, Density],validDataDensityQTests];
registerValidQTestFunction[Object[Data, DynamicFoamAnalysis],validDataDynamicFoamAnalysisQTests];
registerValidQTestFunction[Object[Data, DynamicLightScattering],validDataDynamicLightScatteringQTests];
registerValidQTestFunction[Object[Data, LuminescenceIntensity],validDataLuminescenceIntensityQTests];
registerValidQTestFunction[Object[Data, LuminescenceKinetics],validDataLuminescenceIntensityQTests];
registerValidQTestFunction[Object[Data, LuminescenceSpectroscopy],validDataLuminescenceSpectroscopyQTests];
registerValidQTestFunction[Object[Data, FlowCytometry],validDataFlowCytometryQTests];
registerValidQTestFunction[Object[Data, FluorescenceIntensity],validDataFluorescenceIntensityQTests];
registerValidQTestFunction[Object[Data, FluorescenceKinetics],validDataFluorescenceIntensityQTests];
registerValidQTestFunction[Object[Data, FluorescencePolarization],validDataFluorescencePolarizationQTests];
registerValidQTestFunction[Object[Data, FluorescencePolarizationKinetics],validDataFluorescencePolarizationQTests];
registerValidQTestFunction[Object[Data, FluorescenceSpectroscopy],validDataFluorescenceSpectroscopyQTests];
registerValidQTestFunction[Object[Data, FluorescenceThermodynamics],validDataFluorescenceThermodynamicsQTests];
registerValidQTestFunction[Object[Data, FreezeCells],validDataFreezeCellsQTests];
registerValidQTestFunction[Object[Data, IRSpectroscopy],validDataIRSpectroscopyQTests];
registerValidQTestFunction[Object[Data, LCMS],validDataLCMSQTests];
registerValidQTestFunction[Object[Data, LiquidLevel],validDataLiquidLevelQTests];
registerValidQTestFunction[Object[Data, MassSpectrometry],validDataMassSpectrometryQTests];
registerValidQTestFunction[Object[Data, MeltingPoint],validDataMeltingPointQTests];
registerValidQTestFunction[Object[Data, Microscope],validDataMicroscopeQTests];
registerValidQTestFunction[Object[Data, Nephelometry],validDataNephelometryQTests];
registerValidQTestFunction[Object[Data, NephelometryKinetics],validDataNephelometryKineticsQTests];
registerValidQTestFunction[Object[Data, NMR],validDataNMRQTests];
registerValidQTestFunction[Object[Data, NMR2D],validDataNMR2DQTests];
registerValidQTestFunction[Object[Data, Osmolality],validDataOsmolalityQTests];
registerValidQTestFunction[Object[Data, PAGE],validDataPAGEQTests];
registerValidQTestFunction[Object[Data, pH],validDatapHQTests];
registerValidQTestFunction[Object[Data, pHAdjustment],validDatapHAdjustmentQTests];
registerValidQTestFunction[Object[Data, Pressure],validDataPressureQTests];
registerValidQTestFunction[Object[Data, qPCR],validDataqPCRQTests];
registerValidQTestFunction[Object[Data, DigitalPCR],validDataDigitalPCRQTests];
registerValidQTestFunction[Object[Data, RamanSpectroscopy], validDataRamanSpectroscopyQTests];
registerValidQTestFunction[Object[Data, RefractiveIndex], validDataRefractiveIndexQTest];
registerValidQTestFunction[Object[Data, RelativeHumidity],validDataRelativeHumidityQTests];
registerValidQTestFunction[Object[Data, SurfaceTension],validDataSurfaceTensionQTests];
registerValidQTestFunction[Object[Data, Temperature],validDataTemperatureQTests];
registerValidQTestFunction[Object[Data, FlowRate],validDataFlowRateQTests];
registerValidQTestFunction[Object[Data, TLC],validDataTLCQTests];
registerValidQTestFunction[Object[Data, VacuumEvaporation],validDataVacuumEvaporationQTests];
registerValidQTestFunction[Object[Data, Viscosity],validDataViscosityQTests];
registerValidQTestFunction[Object[Data, Volume],validDataVolumeQTests];
registerValidQTestFunction[Object[Data, Distance],validDataDistanceQTests];
registerValidQTestFunction[Object[Data, Weight],validDataWeightQTests];
registerValidQTestFunction[Object[Data, Western],validDataWesternQTests];
registerValidQTestFunction[Object[Data, Example, Specific],validDataExampleQTests];
registerValidQTestFunction[Object[Data, XRayDiffraction], validDataXRayDiffractionQTests];
registerValidQTestFunction[Object[Data, CircularDichroism], validDataCircularDichroismQTests];
registerValidQTestFunction[Object[Data, LiquidParticleCount], validDataLiquidParticleCountQTests];
registerValidQTestFunction[Object[Data, WettedLength],validDataWettedLengthQTests];
registerValidQTestFunction[Object[Data, QuantifyCells], validDataQuantifyCellsQTests];
registerValidQTestFunction[Object[Data, QuantifyColonies], validDataQuantifyColoniesQTests];
