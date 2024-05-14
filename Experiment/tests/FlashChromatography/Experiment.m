(* ::Subsection:: *)
(*ExperimentFlashChromatography*)

DefineTests[
	ExperimentFlashChromatography,
	{
		(* Basic tests *)

		Example[{Basic,"Some options (Instrument, Column, BufferA, BufferB, and Cartridge) can be specified with Objects:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Instrument->Object[Instrument,FlashChromatography,"Instrument for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Column->Object[Item,Column,"12g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
				BufferA->Object[Sample,"Hexanes Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],
				BufferB->Object[Sample,"Ethyl Acetate Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Cartridge->Object[Container,ExtractionCartridge,"25g Prepacked Silica Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,{Instrument,Column,BufferA,BufferB,Cartridge}],
			{
				ObjectReferenceP[Object[Instrument,FlashChromatography,"Instrument for ExperimentFlashChromatography Testing"<>$SessionUUID]],
				ObjectReferenceP[Object[Item,Column,"12g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID]],
				ObjectReferenceP[Object[Sample,"Hexanes Sample for ExperimentFlashChromatography Testing"<>$SessionUUID]],
				ObjectReferenceP[Object[Sample,"Ethyl Acetate Sample for ExperimentFlashChromatography Testing"<>$SessionUUID]],
				ObjectReferenceP[Object[Container,ExtractionCartridge,"25g Prepacked Silica Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID]]
			},
			Variables:>{options}
		],
		Example[{Basic,"PreparatoryUnitOperations can be used to create the ExperimentFlashChromatography call used for QualificationFlashChromatography:"},
			Module[{result,options,simulation,tests},
				{result,options,simulation,tests}=ExperimentFlashChromatography[
					"Qualification Sample",
					PreparatoryUnitOperations->Download[
						Model[Qualification,FlashChromatography,"CombiFlash Rf 200 Qualification"],
						PreparatoryUnitOperations
					],
					LoadingType->Liquid,
					LoadingAmount->1. Milliliter,
					SamplesInStorageCondition->Disposal,
					SamplesOutStorageCondition->Disposal,
					Instrument->Object[Instrument,FlashChromatography,"Instrument for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Output->{Result,Options,Simulation,Tests}
				];
				{
					Download[result,{LoadingType,LoadingAmount,Column}],
					Lookup[options,{LoadingType,LoadingAmount,Column}],
					Download["Qualification Sample"/.Lookup[simulation[[1]],Labels],{Volume,Composition},Simulation->simulation],
					tests
				}
			],
			{
				{{Liquid},{1. Milliliter},{ObjectP[Model[Item,Column]]}},
				{Liquid,1 Milliliter,ObjectP[Model[Item,Column]]},
				{
					4250.8` Microliter,
					{
						{19.04489016236867` VolumePercent,ObjectP[Model[Molecule,"Hexane"]]},
						{76.17956064947468` VolumePercent,ObjectP[Model[Molecule,"Ethyl acetate"]]},
						{53.13271443580146` Millimolar,ObjectP[Model[Molecule,"Phenacetin"]]},
						{180.29811760265713` Millimolar,ObjectP[Model[Molecule,"N-Benzylbenzamide"]]}
					}
				},
				{_EmeraldTest..}
			}
		],

		(* FlashChromatography option tests *)

		Example[{Options,Preparation,"The Preparation option can be specified to Manual to indicate that the experiment will be performed manually by an operator rather than robotically by an automated liquid handler:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Preparation->Manual,
				Output->Options
			];
			Lookup[options,Preparation],
			Manual,
			Variables:>{options}
		],
		Example[{Options,Preparation,"If the Preparation option is unspecified, it resolves to Manual:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,Preparation],
			Manual,
			Variables:>{options}
		],
		Example[{Options,Instrument,"The Instrument option can be specified to a particular Flash Chromatography instrument object:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Instrument->Object[Instrument,FlashChromatography,"Instrument for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,Instrument],
			ObjectReferenceP[Object[Instrument,FlashChromatography,"Instrument for ExperimentFlashChromatography Testing"<>$SessionUUID]],
			Variables:>{options}
		],
		Example[{Options,Instrument,"The Instrument option defaults to the CombiFlash Rf 200:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,Instrument],
			ObjectReferenceP[Model[Instrument,FlashChromatography,"CombiFlash Rf 200"]],
			Variables:>{options}
		],
		Example[{Options,Detector,"The Detector option can be specified to an ultraviolet absorbance detector:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Detector->UV,
				Output->Options
			];
			Lookup[options,Detector],
			UV,
			Variables:>{options}
		],
		Example[{Options,Detector,"The Detector option defaults to an ultraviolet absorbance detector:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,Detector],
			UV,
			Variables:>{options}
		],
		Example[{Options,SeparationMode,"The SeparationMode option can be specified to indicate whether the separation will be normal or reverse phase:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				SeparationMode->ReversePhase,
				Output->Options
			];
			Lookup[options,SeparationMode],
			ReversePhase,
			Variables:>{options}
		],
		Example[{Options,SeparationMode,"If no column is specified, then the SeparationMode option resolves to NormalPhase:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,SeparationMode],
			NormalPhase,
			Variables:>{options}
		],
		Example[{Options,SeparationMode,"If a reverse phase column is specified, then the SeparationMode option resolves to ReversePhase:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Column->Object[Item,Column,"15.5g C18 Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,SeparationMode],
			ReversePhase,
			Variables:>{options}
		],
		Example[{Options,BufferA,"BufferA and BufferB can be specified together:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				BufferA->Object[Sample,"Hexanes Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],
				BufferB->Object[Sample,"Ethyl Acetate Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,{BufferA,BufferB}],
			{
				ObjectReferenceP[Object[Sample,"Hexanes Sample for ExperimentFlashChromatography Testing"<>$SessionUUID]],
				ObjectReferenceP[Object[Sample,"Ethyl Acetate Sample for ExperimentFlashChromatography Testing"<>$SessionUUID]]
			},
			Variables:>{options}
		],
		Example[{Options,BufferB,"If Buffer A and Buffer B are both unspecified, they will be resolved based on the SeparationMode:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				SeparationMode->ReversePhase,
				Output->Options
			];
			Lookup[options,{BufferA,BufferB}],
			{
				ObjectReferenceP[Model[Sample,"Milli-Q water"]],
				ObjectReferenceP[Model[Sample,"Methanol"]]
			},
			Variables:>{options}
		],
		Example[{Options,LoadingType,"LoadingType can be specified to indicate how the sample should be introduced to the instrument:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				LoadingType->Solid,
				Output->Options
			];
			Lookup[options,LoadingType],
			Solid,
			Variables:>{options}
		],
		Example[{Options,LoadingType,"LoadingType resolves to Liquid if no cartridge-related options are specified:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,LoadingType],
			Liquid,
			Variables:>{options}
		],
		Example[{Options,LoadingType,"LoadingType resolves to Solid if any cartridge-related options are specified and to Liquid otherwise:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				CartridgeDryingTime->{
					10 Minute,
					0 Minute,
					Null
				},
				Output->Options
			];
			Lookup[options,LoadingType],
			{Solid,Solid,Liquid},
			Variables:>{options}
		],
		Example[{Options,MaxLoadingPercent,"MaxLoadingPercent can be specified to indicate the maximum percentage of the column's VoidVolume that can be loaded onto the column as sample:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				MaxLoadingPercent->2 Percent,
				Output->Options
			];
			Lookup[options,MaxLoadingPercent],
			2 Percent,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,MaxLoadingPercent,"MaxLoadingPercent resolves to 12% if LoadingType is Solid and to 6% if LoadingType is Liquid or Preloaded:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				LoadingType->{
					Solid,
					Liquid,
					Preloaded
				},
				Output->Options
			];
			Lookup[options,MaxLoadingPercent],
			{12 Percent,6 Percent,6 Percent},
			Variables:>{options}
		],
		Example[{Options,Column,"Column can be specified to an Object or a Model column that the sample will flow through to be separated:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Column->{
					Object[Item,Column,"4g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Model[Item,Column,"RediSep Gold Normal Phase Silica Column 24g"]
				},
				Output->Options
			];
			Lookup[options,Column],
			{
				ObjectReferenceP[Object[Item,Column,"4g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID]],
				ObjectReferenceP[Model[Item,Column,"RediSep Gold Normal Phase Silica Column 24g"]]
			},
			Variables:>{options}
		],
		Example[{Options,Column,"If Column is unspecified, it will resolve to a column of the correct SeparationMode:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				SeparationMode->ReversePhase,
				Output->Options
			];
			Download[Lookup[options,Column],SeparationMode],
			ReversePhase,
			Variables:>{options}
		],
		Example[{Options,Column,"If Column is unspecified and LoadingAmount is specified, Column will resolve to a model large enough that MaxLoadingPercent times the column's VoidVolume is greater than or equal to the LoadingAmount:"},
			Module[{options,voidVolumes,maxLoadingFractions,maxLoad,load},
				options=ExperimentFlashChromatography[
					{
						Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
						Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
						Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
					},
					LoadingAmount->{
						0.5 Milliliter,
						3 Milliliter,
						9 Milliliter
					},
					MaxLoadingPercent->{
						Automatic,
						3 Percent,
						5 Percent
					},
					CollectFractions->False,
					Output->Options
				];
				voidVolumes=Download[Lookup[options,Column],VoidVolume];
				maxLoadingFractions=Unitless[Lookup[options,MaxLoadingPercent],Percent]/100.;
				maxLoad=voidVolumes*maxLoadingFractions;
				load=Lookup[options,LoadingAmount];
				MapThread[#1>=#2&,{maxLoad,load}]
			],
			{True,True,True},
			Messages:>{Error::InvalidTotalBufferVolume,Error::InvalidOption}
		],
		Example[{Options,LoadingAmount,"LoadingAmount can be specified to a Volume or to All (which loads All of the sample):"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Low Volume Sample for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				LoadingAmount->{
					1. Milliliter,
					All
				},
				Output->Options
			];
			Lookup[options,LoadingAmount],
			{1 Milliliter,All},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,LoadingAmount,"If LoadingAmount is left unspecified, it resolves to MaxLoadingPercent * the column's VoidVolume or to the sample's total volume, whichever is smaller:"},
			Module[{samples,options,voidVolume,maxLoadingFraction,maxLoad,sampleVolumes,predictedLoad,load},
				samples={
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Low Volume Sample for ExperimentFlashChromatography Testing"<>$SessionUUID]
				};
				options=ExperimentFlashChromatography[samples,Output->Options];
				voidVolume=Download[Lookup[options,Column],VoidVolume];
				maxLoadingFraction=Unitless[Lookup[options,MaxLoadingPercent],Percent]/100.;
				maxLoad=voidVolume*maxLoadingFraction;
				sampleVolumes=Download[samples,Volume];
				predictedLoad=SafeRound[
					Min[#,maxLoad]&/@sampleVolumes,
					Experiment`Private`flashChromatographyVolumePrecision[],
					Round->Down
				];
				load=Lookup[options,LoadingAmount];
				Equal[predictedLoad,load]
			],
			True
		],
		Example[{Options,LoadingAmount,"If LoadingAmount is left unspecified, it resolves to MaxLoadingPercent * the column's VoidVolume or to the sample's total volume rounded down to the experiment's volume precision, whichever is smaller:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Low Volume Sample for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Output->Options
			];
			Lookup[options,LoadingAmount],
			{1.0 Milliliter,0.5 Milliliter},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,LoadingAmount,"If LoadingAmount, Detectors, or WideRangeUV are specified to All, the corresponding fields in the Protocol object have the values to which All corresponds:"},
			protocol=ExperimentFlashChromatography[
				Object[Sample,"Low Volume Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],
				LoadingAmount->All,
				Detectors->All,
				WideRangeUV->All
			];
			{
				Download[protocol,{LoadingAmount,Detectors,WideRangeUV}],
				Lookup[Download[protocol,ResolvedOptions],{LoadingAmount,Detectors,WideRangeUV}]
			},
			{
				{
					{0.5 Milliliter},
					{{PrimaryWavelength,SecondaryWavelength,WideRangeUV}},
					{Span[200 Nanometer,360 Nanometer]}
				},
				{
					{All},
					{All},
					{All}
				}
			},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,Cartridge,"Cartridge can be specified to an Object or a Model of solid load cartridge into which sample will be introduced if LoadingType is Solid:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Cartridge->{
					Object[Container,ExtractionCartridge,"25g Prepacked Silica Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Model[Container,ExtractionCartridge,"RediSep 5g Solid Load Cartridge Empty"]
				},
				Output->Options
			];
			Lookup[options,Cartridge],
			{
				ObjectReferenceP[Object[Container,ExtractionCartridge,"25g Prepacked Silica Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID]],
				ObjectReferenceP[Model[Container,ExtractionCartridge,"RediSep 5g Solid Load Cartridge Empty"]]
			},
			Variables:>{options}
		],
		Example[{Options,Cartridge,"If Cartridge is left unspecified, it resolves to a cartridge Model if LoadingType is Solid or to Null if LoadingType is Liquid or Preloaded:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				LoadingType->{
					Solid,
					Liquid,
					Preloaded
				},
				Output->Options
			];
			Lookup[options,Cartridge],
			{
				ObjectReferenceP[Model[Container,ExtractionCartridge]],
				Null,
				Null
			},
			Variables:>{options}
		],
		Example[{Options,CartridgePackingMaterial,"CartridgePackingMaterial can be specified if Cartridge is specified to a cartridge with LoadingType HandPacked to indicate the material with which the cartridge will be filled:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Cartridge->Model[Container,ExtractionCartridge,"RediSep 5g Solid Load Cartridge Empty"],
				CartridgePackingMaterial->Silica,
				Output->Options
			];
			Lookup[options,CartridgePackingMaterial],
			Silica,
			Variables:>{options}
		],
		Example[{Options,CartridgeFunctionalGroup,"CartridgeFunctionalGroup can be specified if Cartridge is specified to a cartridge with LoadingType HandPacked to indicate the functional group on the material with which the cartridge will be filled:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Column->Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 5.5g"],
				Cartridge->Model[Container,ExtractionCartridge,"RediSep 5g Solid Load Cartridge Empty"],
				CartridgeFunctionalGroup->C18,
				Output->Options
			];
			Lookup[options,CartridgeFunctionalGroup],
			C18,
			Variables:>{options}
		],
		Example[{Options,CartridgePackingMass,"CartridgePackingMass can be specified if Cartridge is specified to a cartridge with LoadingType HandPacked to indicate the mass of the material with which the cartridge will be filled:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Cartridge->Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Empty"],
				CartridgePackingMass->20 Gram,
				Output->Options
			];
			Lookup[options,CartridgePackingMass],
			20 Gram,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,Cartridge,"If a Prepacked Cartridge is specified, then CartridgePackingMaterial, CartridgeFunctionalGroup, and CartridgePackingMass resolve to the values from the Cartridge's Model:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Cartridge->Model[Container,ExtractionCartridge,"RediSep 65g Solid Load Cartridge Prepacked with 65g Silica"],
				Output->Options
			];
			Lookup[options,{CartridgePackingMaterial,CartridgeFunctionalGroup,CartridgePackingMass}],
			{Silica,Null,65 Gram},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,Cartridge,"If HandPacked cartridges are specified, then CartridgePackingMaterial resolves to Silica, CartridgeFunctionalGroup resolves to Null if SeparationMode is NormalPhase, and and CartridgePackingMass resolves to whichever is smaller: the column's BedWeight or the cartridge's MaxBedWedight:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Column->{
					Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 30g"],
					Model[Item,Column,"RediSep Gold Normal Phase Silica Column 12g"]
				},
				Cartridge->{
					Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Empty"],
					Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Empty"]
				},
				Output->Options
			];
			Lookup[options,{SeparationMode,CartridgePackingMaterial,CartridgeFunctionalGroup,CartridgePackingMass}],
			{
				NormalPhase,
				Silica,
				Null,
				{25 Gram,12 Gram}
			},
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::MixedSeparationModes,Warning::MismatchedColumnAndCartridge}
		],
		Example[{Options,Cartridge,"If HandPacked cartridges are specified, then CartridgePackingMaterial resolves to Silica, CartridgeFunctionalGroup resolves to C18 if SeparationMode is ReversePhase, and and CartridgePackingMass resolves to whichever is smaller: the column's BedWeight or the cartridge's MaxBedWedight:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Column->{
					Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 30g"]
				},
				Cartridge->{
					Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Empty"]
				},
				Output->Options
			];
			Lookup[options,{SeparationMode,CartridgePackingMaterial,CartridgeFunctionalGroup,CartridgePackingMass}],
			{
				ReversePhase,
				Silica,
				C18,
				25 Gram
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,Cartridge,"HandPacked cartridges can be specified to be filled with 17 Gram of Silica or with 10 Gram of Silica bonded to C18:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Cartridge->{
					Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Empty"],
					Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Empty"]
				},
				CartridgePackingMaterial->Silica,
				CartridgeFunctionalGroup->{Null,C18},
				CartridgePackingMass->{23 Gram,10 Gram},
				Output->Options
			];
			Lookup[options,{CartridgePackingMaterial,CartridgeFunctionalGroup,CartridgePackingMass}],
			{
				Silica,
				{Null,C18},
				{23 Gram,10 Gram}
			},
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::MismatchedColumnAndCartridge}
		],
		Example[{Options,CartridgeDryingTime,"CartridgeDryingTime can be specified to indicate how long the loaded cartridge will be dried with compressed air before the start of separation:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				CartridgeDryingTime->3 Minute,
				Output->Options
			];
			Lookup[options,CartridgeDryingTime],
			3 Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FlowRate,"FlowRate can be specified to indicate the rate at which fluid will move through the instrument and column:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				FlowRate->10 Milliliter/Minute,
				Output->Options
			];
			Lookup[options,FlowRate],
			10 Milliliter/Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FlowRate,"If FlowRate is unspecified, it resolves to the minimum of the maximum flow rates of the instrument, column, and cartridge (if there is a cartridge):"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Column->{
					Model[Item,Column,"RediSep Gold Normal Phase Silica Column 12g"],
					Model[Item,Column,"RediSep Gold Normal Phase Silica Column 40g"],
					Model[Item,Column,"RediSep Gold Normal Phase Silica Column 40g"]
				},
				Cartridge->{
					Null,
					Null,
					Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Prepacked with 12g Silica"]
				},
				Output->Options
			];
			Lookup[options,FlowRate],
			{
				30 Milliliter/Minute,
				40 Milliliter/Minute,
				35 Milliliter/Minute
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,PreSampleEquilibration,"PreSampleEquilibration can be specified to indicate how long buffer at the initial gradient composition will be flowed through the column to equilibrate it before the introduction of sample:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				PreSampleEquilibration->3 Minute,
				Output->Options
			];
			Lookup[options,PreSampleEquilibration],
			3 Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,PreSampleEquilibration,"PreSampleEquilibrium defaults to 3 times the column's VoidVolume divided by the FlowRate:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Column->{
					Model[Item,Column,"RediSep Gold Normal Phase Silica Column 12g"],
					Model[Item,Column,"RediSep Gold Normal Phase Silica Column 12g"],
					Model[Item,Column,"RediSep Gold Normal Phase Silica Column 24g"]
				},
				FlowRate->{
					20 Milliliter/Minute,
					30 Milliliter/Minute,
					30 Milliliter/Minute
				},
				Output->Options
			];
			Lookup[options,PreSampleEquilibration],
			{
				2.52 Minute,
				1.68 Minute,
				3.36 Minute
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,GradientStart,"GradientStart can be specified alongside GradientEnd and GradientDuration to indicate the percentage of BufferB at the beginning of the gradient:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientStart->0 Percent,
				GradientEnd->80 Percent,
				GradientDuration->10 Minute,
				Output->Options
			];
			Lookup[options,GradientStart],
			0 Percent,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,GradientEnd,"GradientEnd can be specified alongside GradientStart and GradientDuration to indicate the percentage of BufferB at the end of the gradient:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientStart->5 Percent,
				GradientEnd->75 Percent,
				GradientDuration->10 Minute,
				Output->Options
			];
			Lookup[options,GradientEnd],
			75 Percent,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,GradientDuration,"GradientDuration can be specified alongside GradientStart and GradientEnd to indicate the length of time over which BufferB changes from the percentage specified by GradientStart to that specified by GradientEnd:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientStart->10 Percent,
				GradientEnd->75 Percent,
				GradientDuration->20 Minute,
				Output->Options
			];
			Lookup[options,GradientDuration],
			20 Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,EquilibrationTime,"EquilibrationTime can be specified if GradientStart, GradientEnd, and GradientDuration are also specified to indicate the length of time that BufferB is held at the percentage specified by GradientStart before the start of GradientDuration:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientStart->20 Percent,
				GradientEnd->60 Percent,
				GradientDuration->20 Minute,
				EquilibrationTime->10 Minute,
				Output->Options
			];
			Lookup[options,EquilibrationTime],
			10 Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FlushTime,"FlushTime can be specified if GradientStart, GradientEnd, and GradientDuration are also specified to indicate the length of time that BufferB is held at the percentage specified by GradientEnd after the end of GradientDuration:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientStart->5 Percent,
				GradientEnd->50 Percent,
				GradientDuration->10 Minute,
				FlushTime->15 Minute,
				Output->Options
			];
			Lookup[options,FlushTime],
			15 Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,GradientStart,"Use the shortcut gradient options to specify an isocratic separation at 20% Buffer B for 30 minutes:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientStart->20 Percent,
				GradientEnd->20 Percent,
				GradientDuration->30 Minute,
				Output->Options
			];
			Lookup[options,GradientB],
			{
				{0 Minute,20 Percent},
				{30 Minute,20 Percent}
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,GradientStart,"Use the shortcut gradient options to specify a 5 minute equilibration at 0% Buffer B, then a linear ramp from 0% to 90% over 20 minutes, then a 10 minute flush at 90%:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientStart->0 Percent,
				GradientEnd->90 Percent,
				EquilibrationTime->5 Minute,
				GradientDuration->20 Minute,
				FlushTime->10 Minute,
				Output->Options
			];
			Lookup[options,GradientB],
			{
				{0 Minute,0 Percent},
				{5 Minute,0 Percent},
				{25 Minute,90 Percent},
				{35 Minute,90 Percent}
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,GradientStart,"Gradient, GradientA, GradientB, and gradient shortcut options can all be (redundantly) specified together as long as they specify the same gradient:"},
			protocol=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientStart->10 Percent,
				GradientEnd->70 Percent,
				GradientDuration->20 Minute,
				GradientB->{
					{0 Minute,10 Percent},
					{20 Minute,70 Percent}
				},
				GradientA->{
					{0 Minute,90 Percent},
					{20 Minute,30 Percent}
				},
				Gradient->{
					{0 Minute,90 Percent,10 Percent},
					{20 Minute,30 Percent,70 Percent}
				}
			];
			Download[protocol,GradientB],
			{
				{
					{0 Minute,10 Percent},
					{20 Minute,70 Percent}
				}
			},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,GradientB,"Specify GradientB to an isocratic separation at 20% Buffer B for 30 minutes:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientB->{
					{0 Minute,20 Percent},
					{30 Minute,20 Percent}
				},
				Output->Options
			];
			Lookup[options,GradientB],
			{
				{0 Minute,20 Percent},
				{30 Minute,20 Percent}
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,GradientB,"Specify GradientB to a 5 minute equilibration at 0% Buffer B, then a linear ramp from 0% to 90% over 20 minutes, then a 10 minute flush at 90%:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientB->{
					{0 Minute,0 Percent},
					{5 Minute,0 Percent},
					{25 Minute,90 Percent},
					{35 Minute,90 Percent}
				},
				Output->Options
			];
			Lookup[options,GradientB],
			{
				{0 Minute,0 Percent},
				{5 Minute,0 Percent},
				{25 Minute,90 Percent},
				{35 Minute,90 Percent}
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,GradientB,"If BufferB is methanol, the default GradientB maxes out at 50% BufferB:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				SeparationMode->ReversePhase,
				Output->Options
			];
			{
				Lookup[options,BufferB],
				Max[Lookup[options,GradientB][[All,2]]]
			},
			{
				ObjectP[Model[Sample,"Methanol"]],
				50 Percent
			},
			Variables:>{options}
		],
		Example[{Options,GradientB,"If all gradient options are unspecified, GradientB resolves to a default gradient which depends on the FlowRate and on the column's BedWeight, VoidVolume, and FunctionalGroup:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Column->{
					Model[Item,Column,"RediSep Gold Normal Phase Silica Column 12g"],
					Model[Item,Column,"RediSep Gold Normal Phase Silica Column 12g"],
					Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 30g"]
				},
				FlowRate->{
					25 Milliliter/Minute,
					30 Milliliter/Minute,
					30 Milliliter/Minute
				},
				Output->Options
			];
			Lookup[options,GradientB],
			{
				{
					{0 Minute,0 Percent},
					{0.93 Minute,0 Percent},
					{12.11 Minute,100 Percent},
					{13.97 Minute,100 Percent},
					{13.97 Minute,0 Percent},
					{14.9 Minute,0 Percent}
				},
				{
					{0 Minute,0 Percent},
					{0.78 Minute,0 Percent},
					{10.09 Minute,100 Percent},
					{11.64 Minute,100 Percent},
					{11.64 Minute,0 Percent},
					{12.42 Minute,0 Percent}
				},
				{
					{0 Minute,0 Percent},
					{0.93 Minute,0 Percent},
					{12.15 Minute,100 Percent},
					{14.01 Minute,100 Percent},
					{14.01 Minute,50 Percent},
					{15.88 Minute,50 Percent}
				}
			},
			EquivalenceFunction->Equal,
			Variables:>{options},
			Messages:>{Warning::MixedSeparationModes}
		],
		Example[{Options,GradientA,"Specify GradientA to an isocratic separation at 20% BufferB (80% BufferA) for 30 minutes:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientA->{
					{0 Minute,80 Percent},
					{30 Minute,80 Percent}
				},
				Output->Options
			];
			Lookup[options,GradientA],
			{
				{0 Minute,80 Percent},
				{30 Minute,80 Percent}
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,GradientA,"Specify GradientA to a 5 minute equilibration at 0% BufferB (100% BufferA), then a linear ramp from 0% to 90% BufferB (100% to 10% BufferA) over 20 minutes, then a 10 minute flush at 90% BufferB (10% BufferA):"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientA->{
					{0 Minute,100 Percent},
					{5 Minute,100 Percent},
					{25 Minute,10 Percent},
					{35 Minute,10 Percent}
				},
				Output->Options
			];
			Lookup[options,GradientA],
			{
				{0 Minute,100 Percent},
				{5 Minute,100 Percent},
				{25 Minute,10 Percent},
				{35 Minute,10 Percent}
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,Gradient,"Specify Gradient to an isocratic separation at 20% BufferB (80% BufferA) for 30 minutes:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Gradient->{
					{0 Minute,80 Percent,20 Percent},
					{30 Minute,80 Percent,20 Percent}
				},
				Output->Options
			];
			Lookup[options,Gradient],
			{
				{0 Minute,80 Percent,20 Percent},
				{30 Minute,80 Percent,20 Percent}
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,Gradient,"Specify Gradient to a 5 minute equilibration at 0% BufferB (100% BufferA), then a linear ramp from 0% to 90% BufferB (100% to 10% BufferA) over 20 minutes, then a 10 minute flush at 90% BufferB (10% BufferA):"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Gradient->{
					{0 Minute,100 Percent,0 Percent},
					{5 Minute,100 Percent,0 Percent},
					{25 Minute,10 Percent,90 Percent},
					{35 Minute,10 Percent,90 Percent}
				},
				Output->Options
			];
			Lookup[options,Gradient],
			{
				{0 Minute,100 Percent,0 Percent},
				{5 Minute,100 Percent,0 Percent},
				{25 Minute,10 Percent,90 Percent},
				{35 Minute,10 Percent,90 Percent}
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,Gradient,"Either GradientA, GradientB, or Gradient can be specified and the others will resolve to match:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				GradientA->{
					{
						{0 Minute,100 Percent},
						{10 Minute,0 Percent}
					},
					Automatic,
					Automatic
				},
				GradientB->{
					Automatic,
					{
						{0 Minute,10 Percent},
						{30 Minute,80 Percent}
					},
					Automatic
				},
				Gradient->{
					Automatic,
					Automatic,
					{
						{0 Minute,95 Percent,5 Percent},
						{10 Minute,95 Percent,5 Percent},
						{20 Minute,15 Percent,85 Percent}
					}
				},
				Output->Options
			];
			Lookup[options,{GradientA,GradientB,Gradient}],
			{
				{
					{
						{0 Minute,100 Percent},
						{10 Minute,0 Percent}
					},
					{
						{0 Minute,90 Percent},
						{30 Minute,20 Percent}
					},
					{
						{0 Minute,95 Percent},
						{10 Minute,95 Percent},
						{20 Minute,15 Percent}
					}
				},
				{
					{
						{0 Minute,0 Percent},
						{10 Minute,100 Percent}
					},
					{
						{0 Minute,10 Percent},
						{30 Minute,80 Percent}
					},
					{
						{0 Minute,5 Percent},
						{10 Minute,5 Percent},
						{20 Minute,85 Percent}
					}
				},
				{
					{
						{0 Minute,100 Percent,0 Percent},
						{10 Minute,0 Percent,100 Percent}
					},
					{
						{0 Minute,90 Percent,10 Percent},
						{30 Minute,20 Percent,80 Percent}
					},
					{
						{0 Minute,95 Percent,5 Percent},
						{10 Minute,95 Percent,5 Percent},
						{20 Minute,15 Percent,85 Percent}
					}
				}
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CollectFractions,"CollectFractions can be specified to indicate whether eluent from the column containing separated sample should be collected:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				CollectFractions->False,
				Output->Options
			];
			Lookup[options,CollectFractions],
			False,
			Variables:>{options}
		],
		Example[{Options,CollectFractions,"If CollectFractions is unspecified, it defaults to True:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,CollectFractions],
			True,
			Variables:>{options}
		],
		Example[{Options,FractionCollectionStartTime,"FractionCollectionStartTime can be specified to indicate the time during the gradient when fraction collection can begin:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				FractionCollectionStartTime->2 Minute,
				Output->Options
			];
			Lookup[options,FractionCollectionStartTime],
			2 Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FractionCollectionStartTime,"If CollectFractions is True, FractionCollectionStartTime defaults to 0 Minute and if CollectFractions is False, it defaults to Null:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				CollectFractions->{
					True,
					False
				},
				Output->Options
			];
			Lookup[options,FractionCollectionStartTime],
			{0 Minute,Null},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FractionCollectionEndTime,"FractionCollectionEndTime can be specified to indicate the time during the gradient when fraction collection will cease:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				FractionCollectionEndTime->10 Minute,
				Output->Options
			];
			Lookup[options,FractionCollectionEndTime],
			10 Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FractionCollectionEndTime,"If CollectFractions is True, FractionCollectionEndTime defaults to the total Gradient time and if CollectFractions is False, it defaults to Null:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				CollectFractions->{
					True,
					False
				},
				Output->Options
			];
			{
				Lookup[options,FractionCollectionEndTime],
				First[Last[Lookup[options,GradientB]]]
			},
			{
				{12.42 Minute,Null},
				12.42 Minute
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FractionContainer,"FractionContainer can be specified to indicate the model of container into which eluent from the column will be collected:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				FractionContainer->Model[Container,Vessel,"15mL Tube"],(* TODO: change this to one of the new capped test tubes *)
				Output->Options
			];
			Lookup[options,FractionContainer],
			ObjectReferenceP[Model[Container,Vessel,"15mL Tube"]],
			Variables:>{options}
		],
		Example[{Options,FractionContainer,"If FractionContainer and MaxFractionVolume are unspecified, FractionContainer resolves to a default tube if CollectFractions is True or to Null if CollectFractions is False:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				CollectFractions->{
					True,
					False
				},
				Output->Options
			];
			Lookup[options,FractionContainer],
			{
				ObjectReferenceP[Model[Container,Vessel,"15mL Tube"]],
				Null
			},
			Variables:>{options}
		],
		(* This test expects certain tubes to be returned by the Search in the function. If new tubes are being returned, the
		test may fail. Please confirm that the new tubes are actually compatible with the instrument and then change this test.
		Or if the new tubes are not compatible, adjust the parameters of the Search in the function to exclude them. *)
		Example[{Options,FractionContainer,"If FractionContainer is unspecified and MaxFractionVolume is specified, FractionContainer resolves to a container large enough to hold MaxFractionVolume:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				MaxFractionVolume->{
					10 Milliliter,
					6 Milliliter,
					3 Milliliter
				},
				Output->Options
			];
			Lookup[options,FractionContainer],
			ObjectReferenceP[Model[Container,Vessel,"15mL Tube"]],
			Variables:>{options}
		],
		(* This test expects certain tubes to be returned by the Search in the function. If new tubes are being returned, the
		test may fail. Please confirm that the new tubes are actually compatible with the instrument and then change this test.
		Or if the new tubes are not compatible, adjust the parameters of the Search in the function to exclude them. *)
		Example[{Options,FractionContainer,"If FractionContainer is unspecified and MaxFractionVolume is specified, FractionContainer resolves to a container large enough to hold MaxFractionVolume or throws an error and resolves to 15mL tubes if there are no compatible containers large enough for the MaxFractionVolume:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				MaxFractionVolume->{
					10 Milliliter,
					15 Milliliter,
					30 Milliliter
				},
				Output->Options
			];
			Lookup[options,FractionContainer],
			{ObjectReferenceP[Model[Container, Vessel, "15mL Tube"]],
				ObjectReferenceP[Model[Container, Vessel, "15x150mm Test Tubes"]],
				ObjectReferenceP[Model[Container, Vessel, "15x150mm Test Tubes"]]},
			Variables:>{options},
			Messages:>{Error::InvalidMaxFractionVolume,Error::InvalidOption}
		],
		Example[{Options,MaxFractionVolume,"MaxFractionVolume can be specified to indicate the maximum volume of eluent that will be collected in each fraction collection container:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				MaxFractionVolume->10 Milliliter,
				Output->Options
			];
			Lookup[options,MaxFractionVolume],
			10 Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,MaxFractionVolume,"If MaxFractionVolume is unspecified, it resolves to 80% of the FractionContainer's MaxVolume if CollectFractions is True or to Null if CollectFractions is False:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]

				},
				FractionContainer->{
					Model[Container,Vessel,"15mL Tube"],
					Null
				},
				CollectFractions->{
					True,
					False
				},
				Output->Options
			];
			Lookup[options,MaxFractionVolume],
			{
				12 Milliliter,
				Null
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FractionCollectionMode,"FractionCollectionMode can be specified to indicate whether All eluent from the column will be collected, or only that corresponding to Peaks called by the peak detection algorithm:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				FractionCollectionMode->All,
				Output->Options
			];
			Lookup[options,FractionCollectionMode],
			All,
			Variables:>{options}
		],
		Example[{Options,FractionCollectionMode,"If FractionCollectionMode is unspecified, it resolves to Peaks if CollectFractions is True or to Null if CollectFractions is False:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				CollectFractions->{
					True,
					False
				},
				Output->Options
			];
			Lookup[options,FractionCollectionMode],
			{Peaks,Null},
			Variables:>{options}
		],
		Example[{Options,Detectors,"Detectors can be specified to a list of detectors (including PrimaryWavelength, SecondaryWavelength, and/or WideRangeUV) or to All which indicates that all three Detectors will be used:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Detectors->{
					{PrimaryWavelength},
					{PrimaryWavelength,SecondaryWavelength},
					All
				},
				Output->Options
			];
			Lookup[options,Detectors],
			{
				{PrimaryWavelength},
				{PrimaryWavelength,SecondaryWavelength},
				All
			},
			Variables:>{options}
		],
		Example[{Options,Detectors,"If there is a single sample and Detectors is specified to a single (unlisted) element from the list of allowed detectors, enclose it in a list:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Detectors->PrimaryWavelength,
				Output->Options
			];
			Lookup[options,Detectors],
			{PrimaryWavelength},
			Variables:>{options}
		],
		Example[{Options,Detectors,"If there are multiple samples and Detectors is specified to a single (unlisted) element from the list of allowed detectors, enclose it in a list:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Detectors->PrimaryWavelength,
				Output->Options
			];
			Lookup[options,Detectors],
			{PrimaryWavelength},
			Variables:>{options}
		],
		Example[{Options,Detectors,"If Detectors is unspecified, it defaults to All:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,Detectors],
			All,
			Variables:>{options}
		],
		Example[{Options,PrimaryWavelength,"PrimaryWavelength can be specified to a wavelength of UV light whose absorbance through the sample will be measured during the separation:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				PrimaryWavelength->310 Nanometer,
				Output->Options
			];
			Lookup[options,PrimaryWavelength],
			310 Nanometer,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,PrimaryWavelength,"If PrimaryWavelength is unspecified, it defaults to 254 Nanometer:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,PrimaryWavelength],
			254 Nanometer,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,SecondaryWavelength,"SecondaryWavelength can be specified to a wavelength of UV light whose absorbance through the sample will be measured during the separation:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				SecondaryWavelength->270 Nanometer,
				Output->Options
			];
			Lookup[options,SecondaryWavelength],
			270 Nanometer,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,SecondaryWavelength,"If SecondaryWavelength is unspecified, it defaults to 280 Nanometer:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,SecondaryWavelength],
			280 Nanometer,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,WideRangeUV,"WideRangeUV can be specified to a span of wavelengths of UV light whose average absorbance through the sample will be measured during the separation:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				WideRangeUV->{
					250 Nanometer;;300 Nanometer,
					Span[250 Nanometer,300 Nanometer]
				},
				Output->Options
			];
			Lookup[options,WideRangeUV],
			{
				250 Nanometer;;300 Nanometer,
				250 Nanometer;;300 Nanometer
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,WideRangeUV,"If WideRangeUV is unspecified, it defaults to All:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,WideRangeUV],
			All,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,PeakDetectors,"PeakDetectors can be specified to a list of detectors (PrimaryWavelength, SecondaryWavelength, and/or WideRangeUV) or to Null:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				PeakDetectors->{
					{PrimaryWavelength,WideRangeUV},
					Null
				},
				Output->Options
			];
			Lookup[options,PeakDetectors],
			{
				{PrimaryWavelength,WideRangeUV},
				Null
			},
			Variables:>{options}
		],
		Example[{Options,PeakDetectors,"If PeakDetectors is unspecified, it will default to PrimaryWavelength and SecondaryWavelength if they are both included in Detectors, to one of them if only one of them is included in Detectors, or to WideRangeUV if neither is included in Detectors:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Detectors->{
					{PrimaryWavelength,SecondaryWavelength,WideRangeUV},
					{SecondaryWavelength,WideRangeUV},
					{WideRangeUV}
				},
				Output->Options
			];
			Lookup[options,PeakDetectors],
			{
				{PrimaryWavelength,SecondaryWavelength},
				{SecondaryWavelength},
				{WideRangeUV}
			},
			Variables:>{options}
		],
		Example[{Options,PeakDetectors,"If PeakDetectors is unspecified, WideRangeUV is included in Detectors, and any of the WideRangeUV peak detection options are specified (to something non-Null), PeakDetectors resolves to include WideRangeUV:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Detectors->{
					{PrimaryWavelength,SecondaryWavelength,WideRangeUV},
					{PrimaryWavelength,SecondaryWavelength,WideRangeUV},
					{PrimaryWavelength,SecondaryWavelength,WideRangeUV}
				},
				WideRangeUVPeakDetectionMethod->{
					Automatic,
					Null,
					{Slope}
				},
				Output->Options
			];
			Lookup[options,PeakDetectors],
			{
				{PrimaryWavelength,SecondaryWavelength},
				{PrimaryWavelength,SecondaryWavelength},
				{PrimaryWavelength,SecondaryWavelength,WideRangeUV}
			},
			Variables:>{options}
		],
		Example[{Options,PrimaryWavelengthPeakDetectionMethod,"PrimaryWavelengthPeakDetectionMethod can be specified to a list of Slope and/or Threshold (or to Null if PrimaryWavelength is not present in PeakDetectors) to indicate the peak detection algorithms that will be used to call peaks on the absorbance detection from the PrimaryWavelength detector:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				PeakDetectors->{
					Automatic,
					Automatic,
					{SecondaryWavelength,WideRangeUV}
				},
				PrimaryWavelengthPeakDetectionMethod->{
					{Slope},
					{Slope,Threshold},
					Null
				},
				Output->Options
			];
			Lookup[options,PrimaryWavelengthPeakDetectionMethod],
			{
				{Slope},
				{Slope,Threshold},
				Null
			},
			Variables:>{options}
		],
		Example[{Options,SecondaryWavelengthPeakDetectionMethod,"SecondaryWavelengthPeakDetectionMethod defaults to {Slope} if no other SecondaryWavelength peak detection options are specified, or to {Slope,Threshold} if SecondaryWavelengthPeakThreshold is specified, or to {Threshold} if SecondaryWavelengthPeakWidth is Null:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				SecondaryWavelengthPeakWidth->{
					Automatic,
					Automatic,
					Null
				},
				SecondaryWavelengthPeakThreshold->{
					Automatic,
					100 MilliAbsorbanceUnit,
					Automatic
				},
				Output->Options
			];
			Lookup[options,SecondaryWavelengthPeakDetectionMethod],
			{
				{Slope},
				{Slope,Threshold},
				{Threshold}
			},
			Variables:>{options}
		],
		Example[{Options,WideRangeUVPeakDetectionMethod,"If WideRangeUVPeakDetectionMethod is {Slope,Threshold}, WideRangeUVPeakWidth and WideRangeUVPeakThreshold are both resolved to default values; if it is {Slope}, WideRangeUVPeakWidth resolves to a default value and WideRangeUVPeakThreshold resolves to Null; if it is {Threshold}, WideRangeUVPeakWidth resolves to Null and WideRangeUVPeakThreshold resolves to a default value, if it is Null, they both resolve to Null:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 4 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				WideRangeUVPeakDetectionMethod->{
					{Slope,Threshold},
					{Slope},
					{Threshold},
					Null
				},
				Output->Options
			];
			Lookup[options,{WideRangeUVPeakWidth,WideRangeUVPeakThreshold}],
			{
				{
					1 Minute,
					1 Minute,
					Null,
					Null
				},
				{
					200 MilliAbsorbanceUnit,
					Null,
					200 MilliAbsorbanceUnit,
					Null
				}
			},
			Variables:>{options}
		],
		Example[{Options,PrimaryWavelengthPeakWidth,"PrimaryWavelengthPeakWidth can be specified to a peak width from FlashChromatographyPeakWidthP (or to Null if PrimaryWavelength is not present in PeakDetectors) to indicate the peak width parameter used for the Slope-based peak detection algorithm:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				PeakDetectors->{
					{PrimaryWavelength,SecondaryWavelength,WideRangeUV},
					{SecondaryWavelength,WideRangeUV}
				},
				PrimaryWavelengthPeakWidth->{
					2 Minute,
					Null
				},
				Output->Options
			];
			Lookup[options,PrimaryWavelengthPeakWidth],
			{
				2 Minute,
				Null
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,SecondaryWavelengthPeakWidth,"SecondaryWavelengthPeakWidth defaults to 1 Minute if SecondaryWavelength is in PeakDetectors or to Null otherwise:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				PeakDetectors->{
					{PrimaryWavelength,SecondaryWavelength,WideRangeUV},
					{PrimaryWavelength,WideRangeUV}
				},
				Output->Options
			];
			Lookup[options,SecondaryWavelengthPeakWidth],
			{
				1 Minute,
				Null
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,WideRangeUVPeakWidth,"If WideRangeUVPeakWidth is Automatic or Null, PeakDetectors defaults to {PrimaryWavelength,SecondaryWavelength}, if it is specified, PeakDetectors defaults to {PrimaryWavelength,SecondaryWavelength,WideRangeUV}:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				WideRangeUVPeakWidth->{
					Automatic,
					Null,
					30 Second
				},
				Output->Options
			];
			Lookup[options,PeakDetectors],
			{
				{PrimaryWavelength,SecondaryWavelength},
				{PrimaryWavelength,SecondaryWavelength},
				{PrimaryWavelength,SecondaryWavelength,WideRangeUV}
			},
			Variables:>{options}
		],
		Example[{Options,PrimaryWavelengthPeakThreshold,"PrimaryWavelengthPeakThreshold can be specified to an absorbance value (or to Null if PrimaryWavelength is not present in PeakDetectors) to indicate the absorbance level above which a peak will be called:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				PeakDetectors->{
					{PrimaryWavelength,SecondaryWavelength,WideRangeUV},
					{SecondaryWavelength,WideRangeUV}
				},
				PrimaryWavelengthPeakThreshold->{
					150 MilliAbsorbanceUnit,
					Null
				},
				Output->Options
			];
			Lookup[options,PrimaryWavelengthPeakThreshold],
			{
				150 MilliAbsorbanceUnit,
				Null
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,SecondaryWavelengthPeakThreshold,"SecondaryWavelengthPeakThreshold defaults to 200 MilliAbsorbanceUnit if SecondaryWavelength is included in PeakDetectors and Threshold is included in SecondaryWavelengthPeakDetectionMethod, or to Null otherwise:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				PeakDetectors->{
					{PrimaryWavelength,SecondaryWavelength,WideRangeUV},
					{PrimaryWavelength,SecondaryWavelength,WideRangeUV},
					{PrimaryWavelength,WideRangeUV}
				},
				SecondaryWavelengthPeakDetectionMethod->{
					{Threshold,Slope},
					{Slope},
					Automatic
				},
				Output->Options
			];
			Lookup[options,SecondaryWavelengthPeakThreshold],
			{
				200 MilliAbsorbanceUnit,
				Null,
				Null
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,WideRangeUVPeakThreshold,"WideRangeUVPeakThreshold defaults to 200 MilliAbsorbanceUnit if WideRangeUV is included in PeakDetectors and Threshold is included in WideRangeUVPeakDetectionMethod, or to Null otherwise:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				PeakDetectors->{
					{PrimaryWavelength,SecondaryWavelength,WideRangeUV},
					{PrimaryWavelength,SecondaryWavelength,WideRangeUV},
					{PrimaryWavelength}
				},
				WideRangeUVPeakDetectionMethod->{
					{Threshold,Slope},
					{Slope},
					Automatic
				},
				Output->Options
			];
			Lookup[options,WideRangeUVPeakThreshold],
			{
				200 MilliAbsorbanceUnit,
				Null,
				Null
			},
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,ColumnStorageCondition,"ColumnStorageCondition can be specified to Disposal or to a sample storage type (matches SampleStorageTypeP) to indicate whether the column will be discarded or stored after the separation and, if stored, under what conditions it will be stored:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				ColumnStorageCondition->{
					Disposal,
					AmbientStorage
				},
				Output->Options
			];
			Lookup[options,ColumnStorageCondition],
			{
				Disposal,
				AmbientStorage
			},
			Variables:>{options}
		],
		Example[{Options,ColumnStorageCondition,"ColumnStorageCondition defaults to AmbientStorage for reusable columns and to Disposal for single-use columns:"},
			protocol=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Column->{
					Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 15.5g"],
					Model[Item,Column,"RediSep Gold Normal Phase Silica Column 24g"],
					Model[Item,Column,"CombiFlash Prime Tube Assembly"]
				}
			];
			Download[protocol,ColumnStorageCondition],
			{
				AmbientStorage,
				Disposal,
				AmbientStorage
			},
			Variables:>{protocol},
			Messages:>{Warning::MixedSeparationModes}
		],
		Example[{Options,ColumnStorageCondition,"ColumnStorageCondition defaults to AmbientStorage for nominally single-use columns that are specified to be used again and to Disposal if they are not specified to be used again:"},
			protocol=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Column->{
					Object[Item,Column,"12g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Item,Column,"12g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Item,Column,"12g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				CollectFractions->False
			];
			Download[protocol,ColumnStorageCondition],
			{
				AmbientStorage,
				AmbientStorage,
				Disposal
			},
			Variables:>{protocol}
		],
		Example[{Options,AirPurgeDuration,"AirPurgeDuration can be specified to Null or to a length of time to indicate how long the column will have pressurized air forced through it to remove traces of the buffers:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Column->{
					Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 15.5g"],
					Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 15.5g"],
					Model[Item,Column,"RediSep Gold Normal Phase Silica Column 24g"]
				},
				AirPurgeDuration->{
					0 Minute,
					Null,
					2 Minute
				},
				Output->Options
			];
			Lookup[options,AirPurgeDuration],
			{
				0 Minute,
				Null,
				2 Minute
			},
			Variables:>{options},
			Messages:>{Warning::MixedSeparationModes}
		],
		Example[{Options,AirPurgeDuration,"AirPurgeDuration defaults to 1 Minute for single-use columns and to 0 Minute for multi-use columns:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Column->{
					Model[Item,Column,"RediSep Gold Normal Phase Silica Column 24g"],
					Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 15.5g"]
				},
				Output->Options
			];
			Lookup[options,AirPurgeDuration],
			{
				1 Minute,
				0 Minute
			},
			Variables:>{options},
			Messages:>{Warning::MixedSeparationModes}
		],
		Example[{Options,Name,"Name can be specified to provide a Name for the Object[Protocol,FlashChromatography] created by an ExperimentFlashChromatography call:"},
			protocol=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Name->"My Favorite Flash Chromatography Protocol"<>$SessionUUID
			];
			Download[protocol,Name],
			"My Favorite Flash Chromatography Protocol"<>$SessionUUID,
			Variables:>{protocol}
		],
		Example[{Options,Template,"Template can be specified to a previously generated Object[Protocol,FlashChromatography]:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Template->Object[Protocol,FlashChromatography,"Template Protocol for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Output->Options
			];
			Lookup[options,Template],
			ObjectReferenceP[Object[Protocol,FlashChromatography,"Template Protocol for ExperimentFlashChromatography Testing"<>$SessionUUID]],
			Variables:>{options}
		],
		Example[{Options,Template,"Template can be specified to a previously generated Object[Protocol,FlashChromatography] to reuse the options from that call, specified options will override those from the template:"},
			template=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				FlowRate->20 Milliliter/Minute,
				PrimaryWavelength->250 Nanometer
			];
			protocol=ExperimentFlashChromatography[
				Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Template->template,
				PrimaryWavelength->300 Nanometer
			];
			Download[{template,protocol},{FlowRate,PrimaryWavelength}],
			{
				{{20 Milliliter/Minute},{250 Nanometer}},
				{{20 Milliliter/Minute},{300 Nanometer}}
			},
			EquivalenceFunction->Equal,
			Variables:>{template,protocol}
		],
		Example[{Options,Template,"Template can copy over gradient shortcut options and specified shortcut options can overwrite the templated options:"},
			template=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientStart->5 Percent,
				GradientEnd->50 Percent,
				GradientDuration->14 Minute
			];
			protocol=ExperimentFlashChromatography[
				Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Template->template,
				GradientDuration->20 Minute,
				FlushTime->5 Minute
			];
			Download[{template,protocol},GradientB],
			{
				{
					{
						{0 Minute,5 Percent},
						{14 Minute,50 Percent}
					}
				},
				{
					{
						{0 Minute,5 Percent},
						{20 Minute,50 Percent},
						{25 Minute,50 Percent}
					}
				}
			},
			EquivalenceFunction->Equal,
			Variables:>{template,protocol}
		],
		Example[{Options,Template,"Templated gradient options can be overwritten by specified gradient options:"},
			template=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientB->{
					{0 Minute,12 Percent},
					{27 Minute,60 Percent}
				}
			];
			protocol=ExperimentFlashChromatography[
				Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Template->template,
				GradientA->{
					{0 Minute,95 Percent},
					{10 Minute,95 Percent},
					{30 Minute,25 Percent}
				}
			];
			Download[{template,protocol},GradientB],
			{
				{
					{
						{0 Minute,12 Percent},
						{27 Minute,60 Percent}
					}
				},
				{
					{
						{0 Minute,5 Percent},
						{10 Minute,5 Percent},
						{30 Minute,75 Percent}
					}
				}
			},
			EquivalenceFunction->Equal,
			Variables:>{template,protocol}
		],

		(* Sample preparation tests *)

		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples for separation using PreparatoryUnitOperations:"},
			options=ExperimentFlashChromatography[
				"Container",
				PreparatoryUnitOperations->{
					LabelContainer[
						Label->"Container",
						Container->Model[Container,Vessel,"50mL Tube"]
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Amount->40 Milliliter,
						Destination->"Container"
					]
				},
				Output->Options
			];
			Lookup[options,PreparatoryUnitOperations],
			{
				ManualSamplePreparation[
					LabelContainer[
						<|
							Container->{ObjectReferenceP[Model[Container,Vessel,"50mL Tube"]]},
							Label->{"Container"}
						|>
					],
					Transfer[
						<|
							Amount->{40 Milliliter},
							Destination->{"Container"},
							Source->{ObjectReferenceP[Model[Sample,"Milli-Q water"]]}
						|>
					]
				]
			},
			Variables:>{options}
		],
		Example[{Options,PreparatoryUnitOperations,"If samples are specified for preparation using PreparatoryUnitOperations, SampleLabel and SampleContainerLabel resolve to the labels from the PreparatoryUnitOperations:"},
			options=ExperimentFlashChromatography[
				"Container",
				PreparatoryUnitOperations->{
					LabelContainer[
						Label->"Container",
						Container->Model[Container,Vessel,"50mL Tube"]
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Amount->40 Milliliter,
						Destination->"Container"
					]
				},
				Output->Options
			];
			Lookup[options,{SampleLabel,SampleContainerLabel}],
			{"transfer destination sample 1","Container"},
			Variables:>{options}
		],
		Example[{Options,PreparatoryPrimitives,"Specify prepared samples for separation using PreparatoryPrimitives:"},
			options=ExperimentFlashChromatography[
				"Container",
				PreparatoryPrimitives->{
					Define[
						Name->"Container",
						Container->Model[Container,Vessel,"50mL Tube"]
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Amount->35 Milliliter,
						Destination->"Container"
					]
				},
				Output->Options
			];
			Lookup[options,PreparatoryPrimitives],
			{
				Define[
					<|
						Name->"Container",
						Container->ObjectReferenceP[Model[Container,Vessel,"50mL Tube"]]
					|>
				],
				Transfer[
					<|
						Source->ObjectReferenceP[Model[Sample,"Milli-Q water"]],
						Amount->Quantity[35,"Milliliters"],
						Destination->"Container"
					|>
				]
			},
			Variables:>{options}
		],
		Example[{Options,PreparatoryPrimitives,"If samples are specified for preparation using PreparatoryPrimitives, SampleContainerLabel resolves to the label from PreparatoryPrimitives and SampleLabel resolves to a default label:"},
			options=ExperimentFlashChromatography[
				"Container",
				PreparatoryPrimitives->{
					Define[
						Name->"Container",
						Container->Model[Container,Vessel,"50mL Tube"]
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Amount->35 Milliliter,
						Destination->"Container"
					]
				},
				Output->Options
			];
			Lookup[options,{SampleLabel,SampleContainerLabel}],
			{String_,"Container"},
			Variables:>{options}
		],

		(* Incubate option tests *)

		Example[{Options,Incubate,"Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Incubate->True,
				Output->Options
			];
			Lookup[options,Incubate],
			True,
			Variables:>{options}
		],
		Example[{Options,IncubationTemperature,"Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				IncubationTemperature->40*Celsius,
				Output->Options
			];
			Lookup[options,IncubationTemperature],
			40*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubationTime,"Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				IncubationTime->40*Minute,
				Output->Options
			];
			Lookup[options,IncubationTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,MaxIncubationTime,"Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				MaxIncubationTime->40*Minute,
				Output->Options
			];
			Lookup[options,MaxIncubationTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubationInstrument,"The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				IncubationInstrument->Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"],
				Output->Options
			];
			Lookup[options,IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables:>{options}
		],
		Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				AnnealingTime->40*Minute,
				Output->Options
			];
			Lookup[options,AnnealingTime],
			40*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				IncubateAliquot->1.5*Milliliter,
				Output->Options
			];
			Lookup[options,IncubateAliquot],
			1.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				IncubateAliquotContainer->Model[Container,Vessel,"50mL Tube"],
				Output->Options];
			Lookup[options,IncubateAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables:>{options}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				IncubateAliquotContainer->Model[Container,Vessel,"50mL Tube"],
				IncubateAliquotDestinationWell->"A1",
				Output->Options
			];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],Mix->True,Output->Options];
			Lookup[options,Mix],
			True,
			Variables:>{options}
		],
		Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],MixType->Shake,Output->Options];
			Lookup[options,MixType],
			Shake,
			Variables:>{options}
		],
		Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix FiltrationType), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],MixUntilDissolved->True,Output->Options];
			Lookup[options,MixUntilDissolved],
			True,
			Variables:>{options}
		],

		(* Centrifuge option tests *)

		Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],Centrifuge->True,Output->Options];
			Lookup[options,Centrifuge],
			True,
			Variables:>{options}
		],
		Example[{Options,CentrifugeInstrument,"The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],CentrifugeInstrument->Model[Instrument,Centrifuge,"Avanti J-15R"],Output->Options];
			Lookup[options,CentrifugeInstrument],
			ObjectP[Model[Instrument,Centrifuge,"Avanti J-15R"]],
			Variables:>{options}
		],
		Example[{Options,CentrifugeIntensity,"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],CentrifugeIntensity->1000*RPM,Output->Options];
			Lookup[options,CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],CentrifugeTime->10*Minute,Output->Options];
			Lookup[options,CentrifugeTime],
			10*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeTemperature,"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],CentrifugeTemperature->10*Celsius,Output->Options];
			Lookup[options,CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquot,"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],CentrifugeAliquot->1.5*Milliliter,Output->Options];
			Lookup[options,CentrifugeAliquot],
			1.5*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->300
		],
		Example[{Options,CentrifugeAliquotContainer,"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,CentrifugeAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables:>{options},
			TimeConstraint->300
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates the desired position in the corresponding CentrifugeAliquotDestinationWell in which the aliquot samples will be placed:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"],CentrifugeAliquotDestinationWell->"A1",Output->Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options},
			TimeConstraint->300
		],

		(* Filter option tests *)

		Example[{Options,Filtration,"Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],Filtration->True,Output->Options];
			Lookup[options,Filtration],
			True,
			Variables:>{options}
		],
		Example[{Options,FiltrationType,"The type of filtration method that should be used to perform the filtration:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],FiltrationType->Syringe,Output->Options];
			Lookup[options,FiltrationType],
			Syringe,
			Variables:>{options}
		],
		Example[{Options,FilterInstrument,"The instrument that should be used to perform the filtration:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],FilterInstrument->Model[Instrument,VacuumPump,"Rocker 300 for Filtration, Non-sterile"],Output->Options];
			Lookup[options,FilterInstrument],
			ObjectP[Model[Instrument,VacuumPump,"Rocker 300 for Filtration, Non-sterile"]],
			Variables:>{options}
		],
		Example[{Options,Filter,"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],Filter->Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"],Output->Options];
			Lookup[options,Filter],
			ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]],
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates the position in the filter aliquot container that the sample should be moved into:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],FilterAliquotContainer->Model[Container,Plate,"96-well UV-Star Plate"],FilterAliquotDestinationWell->"A2",Output->Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A2",
			Variables:>{options},
			TimeConstraint->300
		],
		Example[{Options,FilterMaterial,"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],FilterMaterial->PES,Output->Options];
			Lookup[options,FilterMaterial],
			PES,
			Variables:>{options}
		],
		Example[{Options,PrefilterMaterial,"The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],PrefilterMaterial->GxF,FilterMaterial->PTFE,Output->Options];
			Lookup[options,PrefilterMaterial],
			GxF,
			Variables:>{options}
		],
		Example[{Options,FilterPoreSize,"The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],FilterPoreSize->0.22*Micrometer,Output->Options];
			Lookup[options,FilterPoreSize],
			0.22*Micrometer,
			Variables:>{options}
		],
		Example[{Options,PrefilterPoreSize,"The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],PrefilterPoreSize->1.*Micrometer,FilterMaterial->PTFE,Output->Options];
			Lookup[options,PrefilterPoreSize],
			1.*Micrometer,
			Variables:>{options}
		],
		Example[{Options,FilterSyringe,"The syringe used to force the sample through a filter:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],FiltrationType->Syringe,FilterSyringe->Model[Container, Syringe, "id:AEqRl9Kz1VD1"],Output->Options];
			Lookup[options,FilterSyringe],
			ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]],
			Variables:>{options}
		],
		Example[{Options,FilterHousing,"FilterHousing resolves to Null for all reasonably-small samples that might be used in this experiment:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],Filtration->True,Output->Options];
			Lookup[options,FilterHousing],
			Null,
			Variables:>{options}
		],
		Example[{Options,FilterIntensity,"The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options=ExperimentFlashChromatography[Object[Sample,"Low Volume Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],FiltrationType->Centrifuge,FilterIntensity->1000*RPM,Output->Options];
			Lookup[options,FilterIntensity],
			1000*RPM,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterTime,"The amount of time for which the samples will be centrifuged during filtration:"},
			options=ExperimentFlashChromatography[Object[Sample,"Low Volume Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],FiltrationType->Centrifuge,FilterTime->20*Minute,Output->Options];
			Lookup[options,FilterTime],
			20*Minute,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,FilterTemperature,"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options=ExperimentFlashChromatography[Object[Sample,"Low Volume Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],FiltrationType->Centrifuge,FilterTemperature->10*Celsius,Output->Options];
			Lookup[options,FilterTemperature],
			10*Celsius,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->500
		],
		Example[{Options,FilterSterile,"Indicates if the filtration of the samples should be done in a sterile environment:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],FilterSterile->True,Output->Options];
			Lookup[options,FilterSterile],
			True,
			Variables:>{options}
		],
		Example[{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],FilterAliquot->150*Microliter,Output->Options];
			Lookup[options,FilterAliquot],
			150*Microliter,
			EquivalenceFunction->Equal,
			Variables:>{options},
			TimeConstraint->500
		],
		Example[{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],FilterAliquotContainer->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterAliquotContainer],
			{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables:>{options},
			TimeConstraint->300
		],
		Example[{Options,FilterContainerOut,"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],FilterContainerOut->Model[Container,Vessel,"50mL Tube"],Output->Options];
			Lookup[options,FilterContainerOut],
			{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]},
			Variables:>{options}
		],

		(* Aliquot option tests *)

		Example[{Options,Aliquot,"Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],Aliquot->True,Output->Options];
			Lookup[options,Aliquot],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotAmount,"The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],AliquotAmount->0.12*Milliliter,Output->Options];
			Lookup[options,AliquotAmount],
			0.12*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,AssayVolume,"The desired total volume of the aliquoted sample plus dilution buffer:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],AssayVolume->0.12*Milliliter,Output->Options];
			Lookup[options,AssayVolume],
			0.12*Milliliter,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentration,"The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],TargetConcentration->1*Millimolar,Output->Options];
			Lookup[options,TargetConcentration],
			1*Millimolar,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,TargetConcentrationAnalyte,"The analyte whose desired final concentration is specified:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],TargetConcentration->5 Micromolar,TargetConcentrationAnalyte->Model[Molecule,"Uracil"],AliquotAmount->10 Milliliter,Output->Options];
			Lookup[options,TargetConcentrationAnalyte],
			ObjectP[Model[Molecule,"Uracil"]],
			Variables:>{options}
		],
		Example[{Options,ConcentratedBuffer,"The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],AssayVolume->5 Milliliter,AliquotAmount->2 Milliliter,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],Output->Options];
			Lookup[options,ConcentratedBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,BufferDilutionFactor,"The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],AssayVolume->5 Milliliter,AliquotAmount->2 Milliliter,BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],Output->Options];
			Lookup[options,BufferDilutionFactor],
			10,
			EquivalenceFunction->Equal,
			Variables:>{options}
		],
		Example[{Options,BufferDiluent,"The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],AssayVolume->5 Milliliter,AliquotAmount->2 Milliliter,BufferDiluent->Model[Sample,"Milli-Q water"],BufferDilutionFactor->10,ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"],Output->Options];
			Lookup[options,BufferDiluent],
			ObjectP[Model[Sample,"Milli-Q water"]],
			Variables:>{options}
		],
		Example[{Options,AssayBuffer,"The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],AssayVolume->5 Milliliter,AliquotAmount->2 Milliliter,AssayBuffer->Model[Sample,StockSolution,"10x UV buffer"],Output->Options];
			Lookup[options,AssayBuffer],
			ObjectP[Model[Sample,StockSolution,"10x UV buffer"]],
			Variables:>{options}
		],
		Example[{Options,AliquotSampleStorageCondition,"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],AliquotSampleStorageCondition->Refrigerator,Output->Options];
			Lookup[options,AliquotSampleStorageCondition],
			Refrigerator,
			Variables:>{options}
		],
		Example[{Options,ConsolidateAliquots,"Indicates if identical aliquots should be prepared in the same container/position:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],ConsolidateAliquots->True,Output->Options];
			Lookup[options,ConsolidateAliquots],
			True,
			Variables:>{options}
		],
		Example[{Options,AliquotPreparation,"Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],Aliquot->True,AliquotPreparation->Manual,Output->Options];
			Lookup[options,AliquotPreparation],
			Manual,
			Variables:>{options}
		],
		Example[{Options,AliquotContainer,"The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options=ExperimentFlashChromatography[Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],AliquotContainer->Model[Container,Plate,"In Situ-1 Crystallization Plate"],Output->Options];
			Lookup[options,AliquotContainer],
			{1,ObjectP[Model[Container,Plate,"In Situ-1 Crystallization Plate"]]},
			Variables:>{options}
		],
		Example[{Options,DestinationWell,"The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				AliquotContainer->Model[Container,Plate,"In Situ-1 Crystallization Plate"],
				DestinationWell->"A2",
				Output->Options
			];
			Lookup[options,DestinationWell],
			"A2",
			Variables:>{options}
		],

		(* Post-processing option tests *)

		Example[{Options,ImageSample,"Indicates if any samples that are modified in the course of the experiment should be freshly imaged after running the experiment:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				ImageSample->False,
				Output->Options
			];
			Lookup[options,ImageSample],
			False,
			Variables:>{options}
		],
		Example[{Options,MeasureVolume,"Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				MeasureVolume->False,
				Output->Options
			];
			Lookup[options,MeasureVolume],
			False,
			Variables:>{options}
		],
		Example[{Options,MeasureWeight,"Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				MeasureWeight->False,
				Output->Options
			];
			Lookup[options,MeasureWeight],
			False,
			Variables:>{options}
		],
		Example[{Options,SamplesOutStorageCondition,"The storage condition at which the samples out should be stored after the end of the protocol:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				SamplesOutStorageCondition->{
					Null,
					AmbientStorage,
					Disposal
				},
				Output->Options
			];
			Lookup[options,SamplesOutStorageCondition],
			{
				Null,
				AmbientStorage,
				Disposal
			},
			Variables:>{options}
		],
		Example[{Options,SamplesInStorageCondition,"The storage condition at which the samples in should be stored after the end of the protocol:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				SamplesInStorageCondition->{
					Null,
					Refrigerator,
					Disposal
				},
				Output->Options
			];
			Lookup[options,SamplesInStorageCondition],
			{
				Null,
				Refrigerator,
				Disposal
			},
			Variables:>{options}
		],

		(* Label option tests *)

		Example[{Options,SampleLabel,"SampleLabel can be specified to a String to provide a label for a sample, or it can automatically resolve to a String:"},
			protocol=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				SampleLabel->{
					"My favorite FlashChromatography sample",
					Automatic
				}
			];
			Download[protocol,BatchedUnitOperations[SampleLabel]],
			{
				{"My favorite FlashChromatography sample"},
				{_String}
			},
			Variables:>{protocol}
		],
		Example[{Options,SampleLabel,"If the same sample is included as input more than once, the SampleLabel option resolves to the same value for each:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Output->Options
			];
			{label1,label2,label3}=Lookup[options,SampleLabel];
			{
				MatchQ[label1,label2],
				MatchQ[label2,label3]
			},
			{False,True},
			Variables:>{options,label1,label2,label3}
		],
		Example[{Options,SampleContainerLabel,"SampleContainerLabel can be specified to a String to provide a label for a sample's container, or it can automatically resolve to a String:"},
			protocol=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				SampleContainerLabel->{
					"My favorite FlashChromatography sample container",
					Automatic
				}
			];
			Download[protocol,BatchedUnitOperations[SampleContainerLabel]],
			{
				{"My favorite FlashChromatography sample container"},
				{_String}
			},
			Variables:>{protocol}
		],
		Example[{Options,ColumnLabel,"ColumnLabel can be specified to a String to provide a label for a column, or it can automatically resolve to a String:"},
			protocol=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				ColumnLabel->{
					"My favorite FlashChromatography column",
					Automatic
				}
			];
			Download[protocol,BatchedUnitOperations[ColumnLabel]],
			{
				{"My favorite FlashChromatography column"},
				{_String}
			},
			Variables:>{protocol}
		],
		Example[{Options,ColumnLabel,"If Column is specified to multiples of the same Object, ColumnLabel resolves to the same String for each, if Column is specified to multiples of the same Model, ColumnLabel resolves to different Strings for each:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 4 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Column->{
					Object[Item,Column,"12g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Item,Column,"12g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Model[Item,Column,"RediSep Gold Normal Phase Silica Column 12g"],
					Model[Item,Column,"RediSep Gold Normal Phase Silica Column 12g"]
				},
				Output->Options
			];
			{label1,label2,label3,label4}=Lookup[options,ColumnLabel];
			{
				MatchQ[label1,label2],
				MatchQ[label2,label3],
				MatchQ[label3,label4]
			},
			{True,False,False},
			Variables:>{options,label1,label2,label3,label4}
		],
		Example[{Options,CartridgeLabel,"CartridgeLabel can be specified to a String to provide a label for a cartridge, or it can automatically resolve to a String:"},
			protocol=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				LoadingType->Solid,
				CartridgeLabel->{
					"My favorite FlashChromatography cartridge",
					Automatic
				}
			];
			Download[protocol,BatchedUnitOperations[CartridgeLabel]],
			{
				{"My favorite FlashChromatography cartridge"},
				{_String}
			},
			Variables:>{protocol}
		],
		Example[{Options,CartridgeLabel,"If Cartridge is specified to multiples of the same Object, CartridgeLabel resolves to the same String for each, if Cartridge is specified to multiples of the same Model, CartridgeLabel resolves to different Strings for each:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 4 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Cartridge->{
					Object[Container,ExtractionCartridge,"25g Prepacked Silica Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Container,ExtractionCartridge,"25g Prepacked Silica Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Model[Container,ExtractionCartridge,"RediSep 65g Solid Load Cartridge Prepacked with 32g Silica"],
					Model[Container,ExtractionCartridge,"RediSep 65g Solid Load Cartridge Prepacked with 32g Silica"]
				},
				Output->Options
			];
			{label1,label2,label3,label4}=Lookup[options,CartridgeLabel];
			{
				MatchQ[label1,label2],
				MatchQ[label2,label3],
				MatchQ[label3,label4]
			},
			{True,False,False},
			Variables:>{options,label1,label2,label3,label4}
		],
		Example[{Options,AliquotSampleLabel,"AliquotSampleLabel can be specified to a String to provide a label for an aliquoted sample, or it can automatically resolve to a String if there is an Aliquot or to Null if there is no Aliquot:"},
			protocol=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Aliquot->{
					True,
					True,
					False
				},
				AliquotAmount->{
					1 Milliliter,
					2 Milliliter,
					Automatic
				},
				AliquotSampleLabel->{
					"My favorite FlashChromatography sample aliquot",
					Automatic,
					Automatic
				}
			];
			Download[protocol,BatchedUnitOperations[AliquotSampleLabel]],
			{
				{"My favorite FlashChromatography sample aliquot"},
				{_String},
				{Null}
			},
			Variables:>{protocol}
		],
		Example[{Additional,Resources,"Rack resources will be generated no matter whether CollectFractions is True or False, but if it is False only one Rack will be generated, even for long gradients:"},
			protocol=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				GradientStart->0 Percent,
				GradientEnd->0 Percent,
				GradientDuration->{
					5 Minute,
					40 Minute,
					40 Minute
				},
				CollectFractions->{
					True,
					True,
					False
				},
				FractionContainer->{
					Model[Container,Vessel,"15mL Tube"],
					Model[Container,Vessel,"15mL Tube"],
					Null
				}
			];
			Download[protocol,{Rack,SecondaryRack}],
			{
				{ObjectP[Model[Container,Rack]],ObjectP[Model[Container,Rack]],ObjectP[Model[Container,Rack]]},
				{Null,ObjectP[Model[Container,Rack]],Null}
			},
			Variables:>{protocol}
		],
		Example[{Additional,Resources,"Resources will be generated for syringes and needles:"},
			protocol=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				GradientB->{
					{0 Minute,0 Percent},
					{2 Minute,100 Percent}
				},
				LoadingAmount->{
					0.5 Milliliter,
					4 Milliliter,
					11 Milliliter
				}
			];
			Download[protocol,{Syringe,Needle}],
			{
				ConstantArray[ObjectP[Model[Container,Syringe]],3],
				ConstantArray[ObjectP[Model[Item,Needle]],3]
			},
			Variables:>{protocol}
		],
		Example[{Additional,Resources,"The syringe resources are appropriately sized to hold the LoadingAmount:"},
			protocol=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				GradientB->{
					{0 Minute,0 Percent},
					{10 Minute,100 Percent}
				},
				LoadingAmount->{
					0.5 Milliliter,
					4 Milliliter,
					11 Milliliter
				}
			];
			MapThread[
				IntervalMemberQ[#1,#2]&,
				{
					Interval/@Download[protocol,Syringe[{MinVolume,MaxVolume}]],
					Download[protocol,LoadingAmount]
				}
			],
			{True,True,True},
			Variables:>{protocol}
		],
		Example[{Additional,Resources,"Resources will be generated for frits, plungers, cartridge caps, and cartridge cap tubing:"},
			protocol=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				CollectFractions->False,
				LoadingType->{
					Solid,
					Solid,
					Liquid
				},
				Cartridge->{
					Model[Container,ExtractionCartridge,"RediSep 5g Solid Load Cartridge Prepacked with 5g Silica"],
					Model[Container,ExtractionCartridge,"RediSep 5g Solid Load Cartridge Empty"],
					Null
				}
			];
			Download[protocol,{Frits,Plunger,CartridgeCap,CartridgeCapTubing}],
			{
				{Null,ObjectP[Model[Item,Consumable]],Null},
				{Null,ObjectP[Model[Item,Plunger]],Null},
				{ObjectP[Model[Part,CartridgeCap]],ObjectP[Model[Part,CartridgeCap]],Null},
				{ObjectP[Model[Plumbing]],ObjectP[Model[Plumbing]],Null}
			},
			Variables:>{protocol}
		],
		Example[{Additional,Resources,"Resources will be generated for beakers for each cartridge and for media needed to hand-pack cartridges:"},
			protocol=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 4 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				CartridgeDryingTime->{
					0 Minute,
					5 Minute,
					0 Minute,
					Null
				},
				LoadingType->{
					Solid,
					Solid,
					Solid,
					Liquid
				},
				CollectFractions->False,
				Cartridge->{
					Model[Container,ExtractionCartridge,"RediSep 5g Solid Load Cartridge Empty"],
					Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Empty"],
					Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Prepacked with 12g Silica"],
					Null
				}
			];
			Download[protocol,{Beaker,CartridgeMedia}],
			{
				{
					ObjectP[Model[Container,Vessel,"600mL Pyrex Beaker"]],
					ObjectP[Model[Container,Vessel,"600mL Pyrex Beaker"]],
					ObjectP[Model[Container,Vessel,"600mL Pyrex Beaker"]],
					Null
				},
				{
					ObjectP[Model[Sample,"Silica Gel Spherical 40-75 um"]],
					ObjectP[Model[Sample,"Silica Gel Spherical 40-75 um"]],
					Null,
					Null
				}
			},
			Variables:>{protocol}
		],
		Example[{Additional,UnitOperation,"The BatchedUnitOperations of the protocol object will have the RunTime field populated correctly for each LoadingType:"},
			protocol=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 4 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				GradientB->{
					{
						{0 Minute,0 Percent},
						{10 Minute,100 Percent}
					},
					{
						{0 Minute,0 Percent},
						{5 Minute,100 Percent}
					},
					{
						{0 Minute,0 Percent},
						{5 Minute,100 Percent}
					},
					{
						{0 Minute,0 Percent},
						{5 Minute,100 Percent}
					}
				},
				LoadingType->{
					Liquid,
					Liquid,
					Preloaded,
					Solid
				},
				CollectFractions->False
			];
			Download[protocol,BatchedUnitOperations[RunTime]],
			{
				{12 Minute},
				{7 Minute},
				{7 Minute},
				{8.68 Minute}
			},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],

		(* SamplePrep tests *)

		Test["FlashChromatography primitive can be used as part of ExperimentSamplePreparation with sample labels:",
			protocol=ExperimentSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Container->Model[Container,Vessel,"50mL Tube"],
					Amount->1 Milliliter,
					Label->"my sample 1"
				],
				Transfer[
					Source->"my sample 1",
					Destination->Model[Container,Vessel,"2mL Tube"],
					Amount->300 Microliter,
					DestinationLabel->"my sample 2"
				],
				FlashChromatography[
					Sample->{
						"my sample 1",
						"my sample 2"
					}
				]
			}];
			{
				Download[protocol,CalculatedUnitOperations[[3]][LoadingAmountVariableUnit]],
				Lookup[Download[protocol,ResolvedUnitOperationOptions[[3]]],LoadingAmount]
			},
			{
				{0.7 Milliliter,0.3 Milliliter},
				{0.7 Milliliter,0.3 Milliliter}
			},
			Variables:>{protocol},
			EquivalenceFunction->Equal
		],
		Test["FlashChromatography primitive can accept a list of samples:",
			ExperimentSamplePreparation[{
				LabelSample[
					Sample->{
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"]
					},
					Amount->{
						5 Milliliter,
						5 Milliliter
					},
					Label->{
						"sample 1",
						"sample 2"
					}
				],
				FlashChromatography[
					Sample->{
						"sample 1",
						"sample 2"
					}
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Test["FlashChromatography primitive can accept a list of samples with different loading types:",
			protocol=ExperimentSamplePreparation[{
				LabelSample[
					Sample->{
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"]
					},
					Amount->{
						5 Milliliter,
						5 Milliliter
					},
					Label->{
						"sample 1",
						"sample 2"
					}
				],
				FlashChromatography[
					Sample->{
						"sample 1",
						"sample 2"
					},
					LoadingType->{
						Liquid,
						Solid
					}
				]
			}];
			{
				Download[protocol,CalculatedUnitOperations[[2]][{LoadingType,CartridgeLink}]],
				Lookup[Download[protocol,ResolvedUnitOperationOptions[[2]]],{LoadingType,Cartridge}]
			},
			{
				{
					{Liquid,Solid},
					{Null,ObjectP[Model[Container,ExtractionCartridge]]}
				},
				{
					{Liquid,Solid},
					{Null,ObjectP[Model[Container,ExtractionCartridge]]}
				}
			},
			Variables:>{protocol}
		],
		Test["FlashChromatography primitive can accept a container label and can label the sample inside it:",
			protocol=ExperimentSamplePreparation[{
				LabelContainer[
					Label->"my container",
					Container->Model[Container,Vessel,"50mL Tube"]
				],
				Transfer[
					Source->Model[Sample,"Milli-Q water"],
					Destination->"my container",
					Amount->3 Milliliter
				],
				FlashChromatography[
					Sample->"my container",
					SampleLabel->"my sample"
				]
			}];
			Download[protocol,CalculatedUnitOperations[[3]][{SampleLabel,SampleContainerLabel,FlowRate}]],
			{
				{"my sample"},
				{"my container"},
				{FlowRateP}
			},
			Variables:>{protocol}
		],

		(* Message tests *)

		Example[{Messages,"DiscardedSamples","Throw an error and return $Failed if the input sample is discarded:"},
			ExperimentFlashChromatography[Object[Sample,"Discarded Sample for ExperimentFlashChromatography Testing"<>$SessionUUID]],
			$Failed,
			Messages:>{Error::DiscardedSamples,Error::InvalidInput}
		],
		Example[{Messages,"NonLiquidSamples","Throw an error and return $Failed if the input sample is not a liquid:"},
			ExperimentFlashChromatography[Object[Sample,"Solid Sample for ExperimentFlashChromatography Testing"<>$SessionUUID]],
			$Failed,
			Messages:>{Error::NonLiquidSamples,Error::MissingSampleVolumes,Error::SolidSamplesUnsupported,Error::InvalidInput}
		],
		Example[{Messages,"MissingSampleVolumes","Throw an error and return $Failed if the input sample's volume is Null:"},
			ExperimentFlashChromatography[Object[Sample,"Null Volume Sample for ExperimentFlashChromatography Testing"<>$SessionUUID]],
			$Failed,
			Messages:>{Error::MissingSampleVolumes,Error::InvalidInput}
		],
		Example[{Messages,"InstrumentPrecision","If an option is specified at a higher precision than allowed, then throw a warning and round the option:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				FlowRate->10.12345 Milliliter/Minute,
				Output->Options
			];
			Lookup[options,FlowRate],
			10.1 Milliliter/Minute,
			EquivalenceFunction->Equal,
			Messages:>{Warning::InstrumentPrecision},
			Variables:>{options}
		],
		Example[{Messages,"DuplicateName","Throw an error and return $Failed if the specified Name is already in use for another Flash Chromatography protocol:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Name->"Already Existing Protocol Name for ExperimentFlashChromatography Testing"<>$SessionUUID
			],
			$Failed,
			Messages:>{Error::DuplicateName,Error::InvalidOption}
		],
		Example[{Messages,"InvalidFlashChromatographyPreparation","If Preparation is specified to Robotic, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Preparation->Robotic
			],
			$Failed,
			Messages:>{Error::InvalidFlashChromatographyPreparation,Error::InvalidOption}
		],
		Example[{Messages,"MixedSeparationModes","If columns with a mix of SeparationModes are specified, then throw a warning and resolve the SeparationMode Option to NormalPhase:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Column->{
					Object[Item,Column,"12g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Item,Column,"15.5g C18 Column for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Output->Options
			];
			Lookup[options,SeparationMode],
			NormalPhase,
			Messages:>{Warning::MixedSeparationModes},
			Variables:>{options}
		],
		Example[{Messages,"MixedSeparationModes","If columns with a mix of SeparationModes are specified and SeparationMode is specified, then throw warnings:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Column->{
					Object[Item,Column,"12g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Item,Column,"15.5g C18 Column for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				SeparationMode->ReversePhase,
				Output->Options
			];
			Lookup[options,SeparationMode],
			ReversePhase,
			Messages:>{Warning::MixedSeparationModes,Warning::MismatchedSeparationModes},
			Variables:>{options}
		],
		Example[{Messages,"MismatchedSeparationModes","If the specified SeparationMode option does not match SeparationMode field of the Model of the specified column, then throw a warning:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Column->Object[Item,Column,"12g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
				SeparationMode->ReversePhase,
				Output->Options
			];
			Lookup[options,SeparationMode],
			ReversePhase,
			Messages:>{Warning::MismatchedSeparationModes},
			Variables:>{options}
		],
		Example[{Messages,"IncompleteBufferSpecification","If only one of BufferA and BufferB are specified, then throw an error message and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				BufferA->Object[Sample,"Hexanes Sample for ExperimentFlashChromatography Testing"<>$SessionUUID]
			],
			$Failed,
			Messages:>{Error::IncompleteBufferSpecification,Error::InvalidOption}
		],
		Example[{Messages,"MismatchedCartridgeOptions","If some cartridge-related options are specified and others are Null, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Cartridge->Null,
				CartridgeDryingTime->5 Minute,
				CartridgePackingMass->30 Gram,
				CartridgePackingMaterial->Null
			],
			$Failed,
			Messages:>{Error::MismatchedCartridgeOptions,Error::InvalidOption}
		],
		Example[{Messages,"MismatchedSolidLoadNullCartridgeOptions","If LoadingType is specified to Solid but any cartridge-related options are Null, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				LoadingType->Solid,
				CartridgePackingMaterial->Null
			],
			$Failed,
			Messages:>{Error::MismatchedSolidLoadNullCartridgeOptions,Warning::MismatchedColumnAndCartridge,Error::InvalidOption}
		],
		Example[{Messages,"MismatchedLiquidLoadSpecifiedCartridgeOptions","If LoadingType is specified to Liquid but any cartridge-related options are specified, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				LoadingType->Liquid,
				CartridgeDryingTime->5 Minute
			],
			$Failed,
			Messages:>{Error::MismatchedLiquidLoadSpecifiedCartridgeOptions,Error::InvalidOption}
		],
		Example[{Messages,"RecommendedMaxLoadingPercentExceeded","If MaxLoadingPercent is specified to higher than the recommended value for the resolved LoadingType, then throw a Warning:"},
			options=ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				LoadingType->{Solid,Liquid},
				MaxLoadingPercent->{20 Percent,10 Percent},
				Output->Options
			];
			Lookup[options,MaxLoadingPercent],
			{20 Percent,10 Percent},
			EquivalenceFunction->Equal,
			Messages:>{Warning::RecommendedMaxLoadingPercentExceeded},
			Variables:>{options}
		],
		Example[{Messages,"InvalidCartridgeMaxBedWeight","If the specified cartridge is ChromatographyType Flash, but has a MaxBedWeight which is not 5, 25, or 65g, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				CollectFractions->False,
				Cartridge->Model[Container,ExtractionCartridge,"Cartridge Model with 6g MaxBedWeight for ExperimentFlashChromatography Testing"<>$SessionUUID]
			],
			$Failed,
			Messages:>{Error::InvalidCartridgeMaxBedWeight,Error::InvalidOption}
		],
		Example[{Messages,"DeprecatedColumn","If the Model of the specified column is Deprecated->True, then throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Column->Model[Item,Column,"Innova 12g E Series Flash Cartridge"]
			],
			$Failed,
			Messages:>{Error::DeprecatedColumn,Error::IncompatibleInjectionAssemblyLength,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleColumnType","If the Model of the specified column does not have ChromatographyType->Flash, then throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Column->Object[Item,Column,"FPLC Column for ExperimentFlashChromatography Testing"<>$SessionUUID]
			],
			$Failed,
			Messages:>{Error::IncompatibleColumnType,Error::IncompatibleInjectionAssemblyLength,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleFlowRates","If the Model of the specified column does not have a MinFlowRate to MaxFlowRate range that overlaps with the instrument's, then throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Column->Object[Item,Column,"Column with Low Flow Rate for ExperimentFlashChromatography Testing"<>$SessionUUID]
			],
			$Failed,
			Messages:>{Error::IncompatibleFlowRates,Error::InvalidOption}
		],
		Example[{Messages,"InsufficientSampleVolumeFlashChromatography","If the specified LoadingAmount is larger than the sample volume, then throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Low Volume Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],
				LoadingAmount->1 Milliliter
			],
			$Failed,
			Messages:>{Error::InsufficientSampleVolumeFlashChromatography,Error::InvalidOption}
		],
		Example[{Messages,"InsufficientSampleVolumeFlashChromatography","If the specified LoadingAmount is larger than the volume of the aliquoted sample, then throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				LoadingAmount->2 Milliliter,
				AliquotAmount->1 Milliliter
			],
			$Failed,
			Messages:>{Error::InsufficientSampleVolumeFlashChromatography,Error::InvalidOption}
		],
		Example[{Messages,"InvalidLoadingAmountForColumn","If LoadingAmount and Column are specified, and the column is not large enough that MaxLoadingPercent times the column's VoidVolume is greater than or equal to the LoadingAmount, then throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Column->Object[Item,Column,"4g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
				LoadingAmount->5 Milliliter
			],
			$Failed,
			Messages:>{Error::InvalidLoadingAmountForColumn,Error::InvalidOption}
		],
		Example[{Messages,"InvalidLoadingAmount","If LoadingAmount is specified, Column is unspecified, and none of the default columns is large enough that MaxLoadingPercent times the column's VoidVolume is greater than or equal to the LoadingAmount, then throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				LoadingAmount->All,
				CollectFractions->False
			],
			$Failed,
			Messages:>{Error::InvalidLoadingAmount,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleCartridgeLoadingType","If Cartridge is specified but LoadingType is not Solid, then throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Cartridge->Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Prepacked with 25g Silica"],
				LoadingType->Liquid
			],
			$Failed,
			Messages:>{Error::MismatchedLiquidLoadSpecifiedCartridgeOptions,Error::IncompatibleCartridgeLoadingType,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleCartridgeType","If a cartridge whose Model is not ChromatographyType->Flash is specified, then throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Cartridge->Model[Container,ExtractionCartridge,"Sep-Pak Silica, 500 mg, 6 ml, Vac extraction cartridge"]
			],
			$Failed,
			Messages:>{Error::IncompatibleCartridgeType,Error::IncompatibleCartridgePackingType,Error::IncompatibleFlowRates,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleCartridgePackingType","If a cartridge whose Model's PackingType is not Prepacked or HandPacked is specified, then throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Cartridge->Model[Container,ExtractionCartridge,"Cartridge Model with Null PackingType for ExperimentFlashChromatography Testing"<>$SessionUUID]
			],
			$Failed,
			Messages:>{Error::IncompatibleCartridgePackingType,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleFlowRates","If the Model of the specified cartridge does not have a MinFlowRate to MaxFlowRate range that overlaps with the instrument's, then throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Cartridge->Model[Container,ExtractionCartridge,"Cartridge Model with Low Flow Rate for ExperimentFlashChromatography Testing"<>$SessionUUID]
			],
			$Failed,
			Messages:>{Error::IncompatibleFlowRates,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleFlowRates","If the Model of the specified cartridge does not have a MinFlowRate to MaxFlowRate range that overlaps with the resolved column's, then throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Cartridge->Model[Container,ExtractionCartridge,"Cartridge Model with High Flow Rate for ExperimentFlashChromatography Testing"<>$SessionUUID]
			],
			$Failed,
			Messages:>{Error::IncompatibleFlowRates,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleInjectionAssemblyLength","If the total length of the injection assembly is longer than the instrument's MaxInjectionAssemblyLength, then throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Column->Model[Item,Column,"Very Long Column Model for ExperimentFlashChromatography Testing"<>$SessionUUID]
			],
			$Failed,
			Messages:>{Error::IncompatibleInjectionAssemblyLength,Error::InvalidOption}
		],
		Example[{Messages,"MismatchedColumnAndCartridge","If the SeparationMode, PackingMaterial, and FunctionalGroup fields of the column and the cartridge do not match, then throw a warning:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Column->Model[Item,Column,"RediSep Gold Normal Phase Silica Column 4g"],
				Cartridge->Model[Container,ExtractionCartridge,"RediSep 5g Solid Load Cartridge Prepacked with 5g C18"]
			],
			ObjectP[Object[Protocol,FlashChromatography]],
			Messages:>{Warning::MixedSeparationModes,Warning::MismatchedColumnAndPrepackedCartridge,Warning::MismatchedColumnAndCartridge}
		],
		Example[{Messages,"InvalidCartridgePackingMaterial","If Cartridge is unspecified and CartridgePackingMaterial is specified, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				CartridgePackingMaterial->Silica
			],
			$Failed,
			Messages:>{Error::InvalidCartridgePackingMaterial,Error::InvalidOption}
		],
		Example[{Messages,"InvalidCartridgePackingMaterial","If Cartridge is specified to a cartridge with Prepacked LoadingType and CartridgePackingMaterial is specified, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Cartridge->Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Prepacked with 12g C18"],
				CartridgePackingMaterial->Silica
			],
			$Failed,
			Messages:>{Error::InvalidCartridgePackingMaterial,Error::InvalidOption}
		],
		Example[{Messages,"InvalidCartridgeFunctionalGroup","If Cartridge is specified to a cartridge with Prepacked LoadingType and CartridgeFunctionalGroup is specified, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Cartridge->Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Prepacked with 12g C18"],
				CartridgeFunctionalGroup->C18
			],
			$Failed,
			Messages:>{Error::InvalidCartridgeFunctionalGroup,Error::InvalidOption}
		],
		Example[{Messages,"MismatchedColumnAndCartridge","If there is a resolved Cartridge and the resolved CartridgePackingMaterial and CartridgeFunctionalGroup options don't match the PackingMaterial and FunctionalGroup fields of the column, then throw a warning:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Column->Model[Item,Column,"RediSep Gold Normal Phase Silica Column 40g"],
				Cartridge->Model[Container,ExtractionCartridge,"RediSep 65g Solid Load Cartridge Empty"],
				CartridgePackingMaterial->Silica,
				CartridgeFunctionalGroup->C18
			],
			ObjectP[Object[Protocol,FlashChromatography]],
			Messages:>{Warning::MixedSeparationModes,Warning::MismatchedColumnAndCartridge}
		],
		Example[{Messages,"InvalidCartridgePackingMass","If Cartridge is specified to a cartridge with Prepacked LoadingType and CartridgePackingMass is specified, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Cartridge->Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Prepacked with 12g C18"],
				CartridgePackingMass->15 Gram
			],
			$Failed,
			Messages:>{Error::InvalidCartridgePackingMass,Error::InvalidOption}
		],
		Example[{Messages,"TooHighCartridgePackingMass","If CartridgePackingMass is specified to a value higher than the MaxBedWeight of the Cartridge, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Cartridge->Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Empty"],
				CartridgePackingMass->30 Gram
			],
			$Failed,
			Messages:>{Error::TooHighCartridgePackingMass,Error::InvalidOption}
		],
		Example[{Messages,"TooLowCartridgePackingMass","If CartridgePackingMass is specified to a value lower than LoadingAmount times 2 Gram/Milliter, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Cartridge->Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Empty"],
				CartridgePackingMass->1 Gram
			],
			$Failed,
			Messages:>{Error::TooLowCartridgePackingMass,Error::InvalidOption}
		],
		Example[{Messages,"TooLowCartridgePackingMass","If a very small cartridge and a very large column are specified, and the CartridgePackingMass and LoadingAmount resolve such that CartridgePackingMass is less than LoadingAmount times 2 Gram/Milliliter, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Column->Model[Item,Column,"RediSep Gold Normal Phase Silica Column 120g"],
				Cartridge->Model[Container,ExtractionCartridge,"RediSep 5g Solid Load Cartridge Empty"],
				CollectFractions->False
			],
			$Failed,
			Messages:>{Error::TooLowCartridgePackingMass,Error::InvalidOption}
		],
		Example[{Messages,"InvalidPackingMassForCartridgeCaps","If the CartridgePackingMass is below the range of bed weight values compatible with instrument-compatible cartridge caps, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Cartridge->Model[Container,ExtractionCartridge,"RediSep 5g Solid Load Cartridge Empty"],
				LoadingAmount->0.2 Milliliter,
				CartridgePackingMass->0.8 Gram
			],
			$Failed,
			Messages:>{Error::InvalidPackingMassForCartridgeCaps,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleFlowRateFlashChromatography","If FlowRate is specified outside of the intersection of the MinFlowRate to MaxFlowRate intervals of the instrument and column, throw and error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Column->Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 5.5g"],
				FlowRate->50 Milliliter/Minute
			],
			$Failed,
			Messages:>{Error::IncompatibleFlowRateFlashChromatography,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleFlowRateFlashChromatography","If FlowRate is specified outside of the intersection of the MinFlowRate to MaxFlowRate intervals of the instrument, column and cartridge, throw and error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Column->Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 5.5g"],
				Cartridge->Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Empty"],
				FlowRate->30 Milliliter/Minute
			],
			$Failed,
			Messages:>{Error::IncompatibleFlowRateFlashChromatography,Error::InvalidOption}
		],
		Example[{Messages,"IncompatiblePreSampleEquilibration","If PreSampleEquilibration is specified and LoadingType is Preloaded, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				LoadingType->Preloaded,
				PreSampleEquilibration->3 Minute
			],
			$Failed,
			Messages:>{Error::IncompatiblePreSampleEquilibration,Error::InvalidOption}
		],
		Example[{Messages,"RedundantGradientShortcut","If any shortcut gradient options and a non-shortcut gradient option are both specified and they don't match one another, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientStart->10 Percent,
				GradientEnd->70 Percent,
				GradientDuration->30 Minute,
				GradientB->{
					{0 Minute,10 Percent},
					{20 Minute,70 Percent}
				}
			],
			$Failed,
			Messages:>{Error::RedundantGradientShortcut,Error::InvalidOption}
		],
		Example[{Messages,"IncompleteGradientShortcut","If any shortcut gradient options are specified, but all of GradientStart, GradientEnd, and GradientDuration are not specified, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientStart->10 Percent,
				GradientEnd->70 Percent
			],
			$Failed,
			Messages:>{Error::IncompleteGradientShortcut,Error::InvalidOption}
		],
		Example[{Messages,"ZeroGradientShortcut","If a gradient shortcut with a total length of 0 minutes is specified, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientStart->10 Percent,
				GradientEnd->10 Percent,
				EquilibrationTime->0 Minute,
				GradientDuration->0 Minute
			],
			$Failed,
			Messages:>{Error::ZeroGradientShortcut,Error::InvalidOption}
		],
		Example[{Messages,"RedundantGradientSpecification","If more than one of Gradient, GradientA, and GradientB is specified and they have the same number of timepoints, but they don't match one another, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientA->{
					{0 Minute,100 Percent},
					{5 Minute,30 Percent},
					{20 Minute,30 Percent}
				},
				GradientB->{
					{0 Minute,0 Percent},
					{5 Minute,70 Percent},
					{25 Minute,70 Percent}
				}
			],
			$Failed,
			Messages:>{Error::RedundantGradientSpecification,Error::InvalidOption}
		],
		Example[{Messages,"RedundantGradientSpecification","If more than one of Gradient, GradientA, and GradientB is specified and they don't match one another, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientB->{
					{0 Minute,0 Percent},
					{10 Minute,80 Percent}
				},
				GradientA->{
					{0 Minute,100 Percent},
					{10 Minute,20 Percent},
					{15 Minute,20 Percent}
				}
			],
			$Failed,
			Messages:>{Error::RedundantGradientSpecification,Error::InvalidOption}
		],
		Example[{Messages,"InvalidGradientTime","If a specified gradient's times do not start at 0 minutes, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientA->{
					{1 Minute,100 Percent},
					{10 Minute,40 Percent},
					{20 Minute,40 Percent}
				}
			],
			$Failed,
			Messages:>{Error::InvalidGradientTime,Error::InvalidOption}
		],
		Example[{Messages,"InvalidGradientTime","If a specified gradient's times do not end at greater than 0 minutes, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Gradient->{
					{0 Minute,100 Percent,0 Percent},
					{0 Minute,0 Percent,100 Percent}
				}
			],
			$Failed,
			Messages:>{Error::InvalidGradientTime,Error::InvalidOption}
		],
		Example[{Messages,"InvalidGradientTime","If a specified gradient's times are not monotonically increasing, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientB->{
					{0 Minute,0 Percent},
					{10 Minute,40 Percent},
					{8 Minute,40 Percent},
					{16 Minute,90 Percent}
				}
			],
			$Failed,
			Messages:>{Error::InvalidGradientTime,Error::InvalidOption}
		],
		Example[{Messages,"InvalidTotalGradientTime","If the total length of time of the resolved gradient is greater than the maximum flash chromatography gradient time, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientStart->50 Percent,
				GradientEnd->50 Percent,
				EquilibrationTime->1 Hour,
				GradientDuration->16 Hour,
				FlowRate->5 Milliliter/Minute
			],
			$Failed,
			Messages:>{Error::InvalidTotalGradientTime,Warning::TotalFractionVolume,Error::InvalidOption}
		],
		Example[{Messages,"MethanolPercent","If BufferB is methanol, the column is silica-based, and the max percentage of BufferB in the gradient is greater than 50%, then throw a warning:"},
			protocol=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				SeparationMode->ReversePhase,
				GradientB->{
					{0 Minute,0 Percent},
					{10 Minute,75 Percent}
				}
			];
			Download[protocol,{BufferB,GradientB,Column[PackingMaterial]}],
			{
				ObjectP[Model[Sample,"Methanol"]],
				{{
					{0 Minute,0 Percent},
					{10 Minute,75 Percent}
				}},
				{Silica}
			},
			Messages:>{Warning::MethanolPercent},
			Variables:>{protocol}
		],
		Example[{Messages,"InvalidFractionCollectionOptions","If CollectFractions is True and a fraction collection-related option is Null, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				CollectFractions->True,
				FractionContainer->Null
			],
			$Failed,
			Messages:>{Error::InvalidFractionCollectionOptions,Error::InvalidOption}
		],
		Example[{Messages,"InvalidFractionCollectionOptions","If CollectFractions is unspecified and a fraction collection-related option is Null, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				FractionCollectionMode->Null
			],
			$Failed,
			Messages:>{Error::InvalidFractionCollectionOptions,Error::InvalidOption}
		],
		Example[{Messages,"InvalidCollectFractions","If CollectFractions is False and a fraction collection-related option is specified, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				CollectFractions->False,
				FractionCollectionStartTime->1 Minute
			],
			$Failed,
			Messages:>{Error::InvalidCollectFractions,Error::InvalidOption}
		],
		Example[{Messages,"InvalidCollectFractions","If CollectFractions is False and all fraction collection-related options are specified, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				CollectFractions->False,
				FractionCollectionStartTime->5 Minute,
				FractionCollectionEndTime->10 Minute,
				FractionContainer->Model[Container,Vessel,"15mL Tube"],
				MaxFractionVolume->10 Milliliter,
				FractionCollectionMode->All
			],
			$Failed,
			Messages:>{Error::InvalidCollectFractions,Error::InvalidOption}
		],
		Example[{Messages,"MismatchedFractionCollectionOptions","If any fraction collection-related option is specified and any other is Null, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				FractionCollectionEndTime->10 Minute,
				MaxFractionVolume->Null
			],
			$Failed,
			Messages:>{Error::InvalidFractionCollectionOptions,Error::MismatchedFractionCollectionOptions,Error::InvalidOption}
		],
		Example[{Messages,"InvalidFractionCollectionStartTimeFlash","If FractionCollectionStartTime is specified to a value greater than the total length of time of the resolved GradientB, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				FractionCollectionStartTime->25 Minute,
				GradientB->{
					{0 Minute,0 Percent},
					{20 Minute,90 Percent}
				}
			],
			$Failed,
			Messages:>{Error::InvalidFractionCollectionStartTimeFlash,Error::InvalidOption}
		],
		Example[{Messages,"InvalidFractionCollectionEndTimeFlash","If FractionCollectionEndTime is specified to a value less than or equal to FractionCollectionStartTime, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				FractionCollectionStartTime->10 Minute,
				FractionCollectionEndTime->5 Minute,
				GradientB->{
					{0 Minute,10 Percent},
					{30 Minute,70 Percent}
				}
			],
			$Failed,
			Messages:>{Error::InvalidFractionCollectionEndTimeFlash,Error::InvalidOption}
		],
		Example[{Messages,"InvalidFractionCollectionEndTimeFlash","If FractionCollectionEndTime is specified to a value greater than the total length of time of the resolved GradientB, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				FractionCollectionEndTime->40 Minute,
				GradientB->{
					{0 Minute,10 Percent},
					{20 Minute,80 Percent}
				}
			],
			$Failed,
			Messages:>{Error::InvalidFractionCollectionEndTimeFlash,Error::InvalidOption}
		],
		Example[{Messages,"InvalidFractionContainer","If FractionContainer is specified to a container that is not on the allowed list of fraction collection containers, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				FractionContainer->Model[Container,Vessel,"2mL Tube"]
			],
			$Failed,
			Messages:>{Error::InvalidFractionContainer,Error::InvalidOption}
		],
		Example[{Messages,"InvalidMaxFractionVolumeForContainer","If the specified MaxFractionVolume is too large for the specified FractionContainer, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				FractionContainer->Model[Container,Vessel,"15mL Tube"],
				MaxFractionVolume->20 Milliliter
			],
			$Failed,
			Messages:>{Error::InvalidMaxFractionVolumeForContainer,Error::InvalidOption}
		],
		Example[{Messages,"InvalidMaxFractionVolume","If the specified MaxFractionVolume is too large for the largest allowed fraction collection container, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				MaxFractionVolume->50 Milliliter
			],
			$Failed,
			Messages:>{Error::InvalidMaxFractionVolume,Error::InvalidOption}
		],
		Example[{Messages,"InvalidSpecifiedDetectors","If a detector option (PrimaryWavelength, SecondaryWavelength, or WideRangeUV) is specified but is not included in the Detectors option, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Detectors->{SecondaryWavelength,WideRangeUV},
				PrimaryWavelength->300 Nanometer
			],
			$Failed,
			Messages:>{Error::InvalidSpecifiedDetectors,Error::InvalidOption}
		],
		Example[{Messages,"InvalidNullDetectors","If a detector option (PrimaryWavelength, SecondaryWavelength, or WideRangeUV) is Null but is included in the Detectors option, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Detectors->{PrimaryWavelength,SecondaryWavelength,WideRangeUV},
				PrimaryWavelength->Null
			],
			$Failed,
			Messages:>{Error::InvalidNullDetectors,Error::InvalidOption}
		],
		Example[{Messages,"InvalidNullDetectors","If a detector option (PrimaryWavelength, SecondaryWavelength, or WideRangeUV) is Null but is included in the Detectors option, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Detectors->{PrimaryWavelength,SecondaryWavelength,WideRangeUV},
				PrimaryWavelength->Null
			],
			$Failed,
			Messages:>{Error::InvalidNullDetectors,Error::InvalidOption}
		],
		Example[{Messages,"InvalidWideRangeUV","If WideRangeUV is specified such that the first element of the Span is greater than the second element, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				WideRangeUV->Span[270 Nanometer,250 Nanometer]
			],
			$Failed,
			Messages:>{Error::InvalidWideRangeUV,Error::InvalidOption}
		],
		Example[{Messages,"MissingPeakDetectors","If detectors are included in PeakDetectors that are not present in Detectors, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Detectors->{PrimaryWavelength,WideRangeUV},
				PeakDetectors->{SecondaryWavelength}
			],
			$Failed,
			Messages:>{Error::MissingPeakDetectors,Error::InvalidOption}
		],
		Example[{Messages,"InvalidSpecifiedPeakDetection","If PrimaryWavelength peak detection-related options are specified, but PrimaryWavelength is not in PeakDetectors, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				PeakDetectors->{SecondaryWavelength,WideRangeUV},
				PrimaryWavelengthPeakDetectionMethod->{Slope}
			],
			$Failed,
			Messages:>{Error::InvalidSpecifiedPeakDetection,Error::InvalidOption}
		],
		Example[{Messages,"InvalidSpecifiedPeakDetection","If SecondaryWavelengthPeakWidth is specified, but SecondaryWavelength is not in PeakDetectors, throw errors and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				PeakDetectors->{PrimaryWavelength,WideRangeUV},
				SecondaryWavelengthPeakWidth->4 Minute
			],
			$Failed,
			Messages:>{Error::InvalidSpecifiedPeakDetection,Error::InvalidPeakWidth,Error::InvalidOption}
		],
		Example[{Messages,"InvalidSpecifiedPeakDetection","If WideRangeUV peak detection-related options are specified, but WideRangeUV is not in PeakDetectors (because it is not in Detectors), throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Detectors->{PrimaryWavelength,SecondaryWavelength},
				WideRangeUVPeakDetectionMethod->{Threshold}
			],
			$Failed,
			Messages:>{Error::InvalidSpecifiedPeakDetection,Error::InvalidOption}
		],
		Example[{Messages,"InvalidNullPeakDetectionMethod","If PrimaryWavelengthPeakDetectionMethod is set to Null, but PrimaryWavelength is in PeakDetectors, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				PrimaryWavelengthPeakDetectionMethod->Null
			],
			$Failed,
			Messages:>{Error::InvalidNullPeakDetectionMethod,Error::InvalidOption}
		],
		Example[{Messages,"InvalidNullPeakDetectionMethod","If SecondaryWavelengthPeakDetectionMethod is set to Null, but SecondaryWavelength is in PeakDetectors, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				PeakDetectors->{SecondaryWavelength,WideRangeUV},
				SecondaryWavelengthPeakDetectionMethod->Null
			],
			$Failed,
			Messages:>{Error::InvalidNullPeakDetectionMethod,Error::InvalidOption}
		],
		Example[{Messages,"InvalidNullPeakDetectionMethod","If WideRangeUVPeakDetectionMethod is set to Null, but WideRangeUV is in PeakDetectors, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				PeakDetectors->{WideRangeUV},
				WideRangeUVPeakDetectionMethod->Null
			],
			$Failed,
			Messages:>{Error::InvalidNullPeakDetectionMethod,Error::InvalidOption}
		],
		Example[{Messages,"InvalidNullPeakDetectionParameters","If PrimaryWavelengthPeakWidth and PrimaryWavelengthPeakThreshold are both set to Null, but PrimaryWavelength is in PeakDetectors, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				PrimaryWavelengthPeakWidth->Null,
				PrimaryWavelengthPeakThreshold->Null
			],
			$Failed,
			Messages:>{Error::InvalidNullPeakDetectionParameters,Error::InvalidOption}
		],
		Example[{Messages,"InvalidNullPeakDetectionParameters","If SecondaryWavelengthPeakWidth and SecondaryWavelengthPeakThreshold are both set to Null, but SecondaryWavelength is in PeakDetectors, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				SecondaryWavelengthPeakWidth->Null,
				SecondaryWavelengthPeakThreshold->Null
			],
			$Failed,
			Messages:>{Error::InvalidNullPeakDetectionParameters,Error::InvalidOption}
		],
		Example[{Messages,"InvalidNullPeakDetectionParameters","If WideRangeUVPeakWidth and WideRangeUVPeakThreshold are both set to Null, but WideRangeUV is in PeakDetectors, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				PeakDetectors->{WideRangeUV,PrimaryWavelength},
				WideRangeUVPeakWidth->Null,
				WideRangeUVPeakThreshold->Null
			],
			$Failed,
			Messages:>{Error::InvalidNullPeakDetectionParameters,Error::InvalidOption}
		],
		Example[{Messages,"InvalidNullPeakDetectionParameters","If WideRangeUVPeakWidth and WideRangeUVPeakThreshold are both set to Null, but PeakDetectors is Automatic, don't throw an error because WideRangeUV isn't in PeakDetectors automatically:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				WideRangeUVPeakWidth->Null,
				WideRangeUVPeakThreshold->Null,
				Output->Options
			];
			Lookup[options,PeakDetectors],
			{PrimaryWavelength,SecondaryWavelength},
			Variables:>{options}
		],
		Example[{Messages,"InvalidPeakWidth","If PrimaryWavelengthPeakWidth is specified, but PrimaryWavelengthPeakDetectionMethod doesn't include Slope, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				PrimaryWavelengthPeakWidth->2 Minute,
				PrimaryWavelengthPeakDetectionMethod->{Threshold}
			],
			$Failed,
			Messages:>{Error::InvalidPeakWidth,Error::InvalidOption}
		],
		Example[{Messages,"InvalidPeakWidth","If SecondaryWavelengthPeakWidth is specified, but SecondaryWavelengthPeakDetectionMethod doesn't include Slope, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				SecondaryWavelengthPeakWidth->1 Minute,
				SecondaryWavelengthPeakDetectionMethod->{Threshold}
			],
			$Failed,
			Messages:>{Error::InvalidPeakWidth,Error::InvalidOption}
		],
		Example[{Messages,"InvalidPeakWidth","If WideRangeUVPeakWidth is specified, but WideRangeUVPeakDetectionMethod doesn't include Slope, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				WideRangeUVPeakWidth->1 Minute,
				WideRangeUVPeakDetectionMethod->Null
			],
			$Failed,
			Messages:>{Error::InvalidPeakWidth,Error::InvalidNullPeakDetectionMethod,Error::InvalidOption}
		],
		Example[{Messages,"InvalidPeakThreshold","If PrimaryWavelengthPeakThreshold is specified, but PrimaryWavelengthPeakDetectionMethod doesn't include Threshold, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				PrimaryWavelengthPeakThreshold->200 MilliAbsorbanceUnit,
				PrimaryWavelengthPeakDetectionMethod->{Slope}
			],
			$Failed,
			Messages:>{Error::InvalidPeakThreshold,Error::InvalidOption}
		],
		Example[{Messages,"InvalidPeakThreshold","If SecondaryWavelengthPeakThreshold is specified, but SecondaryWavelengthPeakDetectionMethod doesn't include Threshold, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				SecondaryWavelengthPeakThreshold->150 MilliAbsorbanceUnit,
				SecondaryWavelengthPeakDetectionMethod->{Slope}
			],
			$Failed,
			Messages:>{Error::InvalidPeakThreshold,Error::InvalidOption}
		],
		Example[{Messages,"InvalidPeakThreshold","If WideRangeUVPeakThreshold is specified, but WideRangeUVPeakDetectionMethod doesn't include Threshold, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				WideRangeUVPeakThreshold->300 MilliAbsorbanceUnit,
				WideRangeUVPeakDetectionMethod->Null
			],
			$Failed,
			Messages:>{Error::InvalidPeakThreshold,Error::InvalidNullPeakDetectionMethod,Error::InvalidOption}
		],
		Example[{Messages,"InvalidColumnStorageCondition","If the ColumnStorageCondition of a column that is specified to be used again is set to Disposal, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Column->{
					Object[Item,Column,"15.5g C18 Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Item,Column,"15.5g C18 Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Item,Column,"15.5g C18 Column for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				ColumnStorageCondition->{
					AmbientStorage,
					Disposal,
					AmbientStorage
				},
				CollectFractions->False
			],
			$Failed,
			Messages:>{Error::InvalidColumnStorageCondition,Error::InvalidOption}
		],
		Example[{Messages,"InvalidAirPurgeDuration","If a column is set to be Disposed by ColumnStorageCondition, but AirPurgeDuration is 0 Minute, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				ColumnStorageCondition->Disposal,
				AirPurgeDuration->0 Minute
			],
			$Failed,
			Messages:>{Error::InvalidAirPurgeDuration,Error::InvalidOption}
		],
		Example[{Messages,"AirPurgeAndStoreColumn","If a column is set to be stored by ColumnStorageCondition, but AirPurgeDuration is greater than 0 Minute, throw a warning:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				ColumnStorageCondition->AmbientStorage,
				AirPurgeDuration->1.5 Minute,
				Output->Options
			];
			Lookup[options,AirPurgeDuration],
			1.5 Minute,
			Messages:>{Warning::AirPurgeAndStoreColumn},
			Variables:>{options}
		],
		Example[{Messages,"InvalidNullCartridgeLabel","If there is a resolved Cartridge, and CartridgeLabel is set to Null, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Cartridge->Object[Container,ExtractionCartridge,"25g Prepacked Silica Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID],
				CartridgeLabel->Null
			],
			$Failed,
			Messages:>{Error::InvalidNullCartridgeLabel,Error::InvalidOption}
		],
		Example[{Messages,"InvalidSpecifiedCartridgeLabel","If Cartridge resolves to Null, and CartridgeLabel is set to a String, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				LoadingType->Liquid,
				CartridgeLabel->"My favorite cartridge"
			],
			$Failed,
			Messages:>{Error::InvalidSpecifiedCartridgeLabel,Error::InvalidOption}
		],


		Example[{Messages,"InvalidLabel","If identical SamplesIn are referred to by different sample labels, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				SampleLabel->{
					"Sample 1",
					"Sample 2"
				}
			],
			$Failed,
			Messages:>{Error::InvalidLabel,Error::InvalidOption}
		],
		Example[{Messages,"InvalidLabel","If identical sample labels refer to different SamplesIn, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				SampleLabel->{
					"Sample 1",
					"Sample 1"
				}
			],
			$Failed,
			Messages:>{Error::InvalidLabel,Error::InvalidOption}
		],
		Example[{Messages,"InvalidLabel","If identical ContainersIn are referred to by different sample container labels, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				SampleContainerLabel->{
					"Sample Container 1",
					"Sample Container 2"
				}
			],
			$Failed,
			Messages:>{Error::InvalidLabel,Error::InvalidOption}
		],
		Example[{Messages,"InvalidLabel","If identical sample container labels refer to different ContainersIn, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				SampleContainerLabel->{
					"Sample Container 1",
					"Sample Container 1"
				}
			],
			$Failed,
			Messages:>{Error::InvalidLabel,Error::InvalidOption}
		],
		Example[{Messages,"InvalidTotalFractionVolume","If FractionCollectionMode is All and the number of required fraction collection tubes is greater than that which can be held in two fraction collection containers, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientB->{
					{0 Hour,0 Percent},
					{3 Hour,100 Percent}
				},
				FractionCollectionMode->All
			],
			$Failed,
			Messages:>{Error::InvalidTotalFractionVolume,Error::InvalidOption}
		],
		Example[{Messages,"InvalidTotalFractionVolume","If FractionCollectionMode is Peaks and the max number of required fraction collection tubes is greater than that which can be held in two fraction collection containers, throw a warning:"},
			options=ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientB->{
					{0 Hour,0 Percent},
					{3 Hour,100 Percent}
				},
				FractionCollectionMode->Peaks,
				Output->Options
			];
			Lookup[options,FractionCollectionMode],
			Peaks,
			Messages:>{Warning::TotalFractionVolume},
			Variables:>{options}
		],


		Example[{Messages,"InvalidLabel","If identical column Objects are referred to by different column labels, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Column->{
					Object[Item,Column,"4g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Item,Column,"4g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				ColumnLabel->{
					"Column 1",
					"Column 2"
				}
			],
			$Failed,
			Messages:>{Error::InvalidLabel,Error::InvalidOption}
		],
		Example[{Messages,"InvalidLabel","If identical column labels refer to different columns, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Column->{
					Object[Item,Column,"4g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Item,Column,"12g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				ColumnLabel->{
					"Column 1",
					"Column 1"
				}
			],
			$Failed,
			Messages:>{Error::InvalidLabel,Error::InvalidOption}
		],
		Example[{Messages,"InvalidLabel","If identical cartridge Objects are referred to by different cartridge labels, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Cartridge->{
					Object[Container,ExtractionCartridge,"25g Prepacked Silica Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Container,ExtractionCartridge,"25g Prepacked Silica Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				CartridgeLabel->{
					"Cartridge 1",
					"Cartridge 2"
				}
			],
			$Failed,
			Messages:>{Error::InvalidLabel,Error::InvalidOption}
		],
		Example[{Messages,"InvalidLabel","If identical cartridge labels refer to different cartridges, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				Cartridge->{
					Object[Container,ExtractionCartridge,"25g Prepacked Silica Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Model[Container,ExtractionCartridge,"RediSep 5g Solid Load Cartridge Prepacked with 5g Silica"]
				},
				CartridgeLabel->{
					"Cartridge 1",
					"Cartridge 1"
				}
			],
			$Failed,
			Messages:>{Error::InvalidLabel,Error::InvalidOption}
		],
		Example[{Messages,"InvalidTotalBufferVolume","If more than 4 liters of BufferB would be used by the gradient, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				GradientStart->100 Percent,
				GradientEnd->100 Percent,
				GradientDuration->2 Hour
			],
			$Failed,
			Messages:>{Error::InvalidTotalBufferVolume,Warning::TotalFractionVolume,Error::InvalidOption}
		],
		Example[{Messages,"InvalidTotalBufferVolume","If more than 4 liters of BufferA would be used by the gradient, throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				{
					Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
					Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				GradientA->{
					{
						{0 Minute,100 Percent},
						{2 Hour,100 Percent}
					},
					{
						{0 Minute,100 Percent},
						{10 Minute,100 Percent}
					},
					{
						{0 Minute,100 Percent},
						{10 Minute,100 Percent}
					}
				},
				CollectFractions->{
					True,
					True,
					False
				}
			],
			$Failed,
			Messages:>{Error::InvalidTotalBufferVolume,Warning::TotalFractionVolume,Error::InvalidOption}
		],
		Example[{Messages,"InvalidLoadingAmountForInstrument","If the resolved LoadingAmount is outside the sample loading volume range of the resolved Instrument, then throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				LoadingAmount->0 Microliter
			],
			$Failed,
			Messages:>{Error::InvalidLoadingAmountForInstrument,Error::InvalidLoadingAmountForSyringes,Error::InvalidOption}
		],
		Example[{Messages,"InvalidLoadingAmountForSyringes","If the resolved LoadingAmount is outside the volume range of the instrument-compatible syringes, then throw an error and return $Failed:"},
			ExperimentFlashChromatography[
				Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				LoadingAmount->0 Microliter
			],
			$Failed,
			Messages:>{Error::InvalidLoadingAmountForInstrument,Error::InvalidLoadingAmountForSyringes,Error::InvalidOption}
		]
	},
	Stubs:>{
		$DeveloperUpload=True,
		$PublicPath=$TemporaryDirectory,
		Resources`Private`fulfillableResourceQ=True&
	},
	SymbolSetUp:>{
		Module[{
			instrumentModel,testBench,testLocalCache,
			qualSampleDefaultContainerModel,qualSampleDefaultContainerCoverModel,
			testInstrumentParts,testContainers,testCovers,testSamples,
			testColumnModels,testCartridgeModels,
			testInstruments,testProtocols,testColumns,testCartridgeMaterials,
			uploadedObjects
		},
			Off[Warning::SamplesOutOfStock];
			Off[Warning::DeprecatedProduct];
			Off[Warning::SampleMustBeMoved];
			Off[Warning::InstrumentUndergoingMaintenance];
			Off[Warning::NoModelNameGiven];

			$CreatedObjects={};
			tearDownExperimentFlashChromatographyTestObjects[];

			(* The real CombiFlash Rf 200 instrument model *)
			instrumentModel=Model[Instrument,FlashChromatography,"CombiFlash Rf 200"][Object];

			(*-- Test Objects --*)

			(* Create the test bench *)
			testBench=Upload[
				<|
					Model->Link[Model[Container,Bench,"The Bench of Testing"],Objects],
					Type->Object[Container,Bench],
					Name->"Bench for ExperimentFlashChromatography Testing"<>$SessionUUID,
					Site->Link[$Site]
				|>
			];

			(* Create the test local instrument cache *)
			testLocalCache=UploadSample[
				Model[Container,Rack,"1-position Akro-Grid Tote"],
				{"Work Surface",testBench},
				Name->"Local Cache for ExperimentFlashChromatography Testing"<>$SessionUUID,
				Status->Available,
				StorageCondition->AmbientStorage
			];

			(* Create parts for the test instrument *)
			testInstrumentParts=UploadSample[
				{
					Model[Item,Cap,"38-430 Bottle Cap"],
					Model[Item,Cap,"38-430 Bottle Cap"],
					Model[Container,Deck,"CombiFlash Rf200 MPLC Buffer Deck"],
					Model[Container,Deck,"MPLC Deck"],
					Model[Container,Vessel,"20L Polypropylene Carboy"]
				},
				ConstantArray[{"Work Surface",testBench},5],
				Name->{
					"Buffer A1 Aspiration Cap for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Buffer B1 Aspiration Cap for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Buffer Deck for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Fraction Collection Deck for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Waste Container for ExperimentFlashChromatography Testing"<>$SessionUUID
				},
				Status->Available,
				StorageCondition->AmbientStorage
			];

			(* Restrict the test instrument parts *)
			Upload[<|Object->#,Restricted->True|>&/@testInstrumentParts];

			(* Create test instruments *)
			testInstruments=Upload[{
				<|
					Type->Object[Instrument,FlashChromatography],
					Model->Link[instrumentModel,Objects],
					Name->"Instrument for ExperimentFlashChromatography Testing"<>$SessionUUID,
					Replace[InstrumentSoftware]->{PeakTrak,"v2.1.21"},
					Replace[SerialNumbers]->{{"Instrument","123454321"}},
					BufferA1Cap->Link[testInstrumentParts[[1]],FlashChromatography],
					BufferB1Cap->Link[testInstrumentParts[[2]],FlashChromatography],
					BufferDeck->Link[testInstrumentParts[[3]],Instruments],
					FractionCollectorDeck->Link[testInstrumentParts[[4]],Instruments],
					WasteContainer->Link[testInstrumentParts[[5]]],
					Status->Available,
					Site->Link[$Site]
				|>
			}];

			(* Upload the instrument's location *)
			UploadLocation[testInstruments,{"Work Surface",testBench}, FastTrack->True];

			qualSampleDefaultContainerModel=Model[Container,Vessel,"5mL Clear Plastic Self Standing Tube with Blue Cap"];
			qualSampleDefaultContainerCoverModel=Model[Item, Cap, "id:9RdZXvdmDz5J"];

			(* Create the test sample containers *)
			testContainers=UploadSample[
				{
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"50mL Tube"],
					Model[Container,Vessel,"Amber Glass Bottle 4 L"],
					Model[Container,Vessel,"Amber Glass Bottle 4 L"],
					Model[Container,Vessel,"50mL Tube"],
					qualSampleDefaultContainerModel
				},
				ConstantArray[{"Work Surface",testBench},12],
				Name->{
					"Tube 1 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Tube 2 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Tube 3 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Tube 4 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Tube 5 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Tube 6 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Tube 7 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Tube 8 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Bottle 1 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Bottle 2 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Tube for Silica Gel for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Tube for Solid Qualification Sample for ExperimentFlashChromatography Testing"<>$SessionUUID
				},
				Status->Available,
				StorageCondition->AmbientStorage
			];

			(* Create covers for the test containers *)
			testCovers=UploadSample[
				{
					Model[Item,Cap,"50 mL tube cap"],
					Model[Item,Cap,"50 mL tube cap"],
					Model[Item,Cap,"50 mL tube cap"],
					Model[Item,Cap,"50 mL tube cap"],
					Model[Item,Cap,"50 mL tube cap"],
					Model[Item,Cap,"50 mL tube cap"],
					Model[Item,Cap,"50 mL tube cap"],
					Model[Item,Cap,"50 mL tube cap"],
					Model[Item,Cap,"38-430 Bottle Cap"],
					Model[Item,Cap,"38-430 Bottle Cap"],
					Model[Item,Cap,"50 mL tube cap"],
					qualSampleDefaultContainerCoverModel
				},
				ConstantArray[{"Work Surface",testBench},12],
				Name->{
					"Tube Cap 1 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Tube Cap 2 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Tube Cap 3 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Tube Cap 4 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Tube Cap 5 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Tube Cap 6 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Tube Cap 7 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Tube Cap 8 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Bottle Cap 1 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Bottle Cap 2 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Tube Cap for Silica Gel Tube for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Tube Cap for Solid Qualification Sample for ExperimentFlashChromatography Testing"<>$SessionUUID
				},
				Status->Available,
				StorageCondition->AmbientStorage
			];

			(* Cover the test containers *)
			UploadCover[testContainers,Cover->testCovers];

			(* Create the test samples *)
			testSamples=UploadSample[
				{
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Milli-Q water"],
					Model[Sample,"Silica Gel"],
					Model[Sample,"Hexanes"],
					Model[Sample,"Ethyl acetate, HPLC Grade"],
					Model[Sample,"Silica Gel Spherical 40-75 um"],
					Model[Sample,"Teledyne Universal Test Mix"]
				},
				{"A1",#}&/@testContainers,
				Name->{
					"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Sample 4 for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Low Volume Sample for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Discarded Sample for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Null Volume Sample for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Solid Sample for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Hexanes Sample for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Ethyl Acetate Sample for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Silica Gel for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Solid Qualification Sample for ExperimentFlashChromatography Testing"<>$SessionUUID
				},
				InitialAmount->{
					45 Milliliter,
					45 Milliliter,
					45 Milliliter,
					45 Milliliter,
					0.5 Milliliter,
					45 Milliliter,
					45 Milliliter,
					45 Gram,
					3 Liter,
					3 Liter,
					20 Gram,
					250 Milligram
				},
				StorageCondition->AmbientStorage,
				Status->Available
			];

			(* Discard a test sample *)
			UploadSampleStatus[Object[Sample,"Discarded Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],Discarded];

			(* Set a test sample's volume to Null *)
			Upload[<|
				Object->Object[Sample,"Null Volume Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Volume->Null
			|>];

			(* Update the composition of a sample *)
			Upload[<|
				Object->Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
				Replace[Composition]->{
					{100 VolumePercent,Link[Model[Molecule,"Water"]]},
					{5 Millimolar,Link[Model[Molecule,"Uracil"]]}
				}
			|>];

			testColumnModels=Upload[{
				<|
					Type->Model[Item,Column],
					StorageCaps->True,
					Name->"Column Model with Low Flow Rate for ExperimentFlashChromatography Testing"<>$SessionUUID,
					SeparationMode->NormalPhase,
					Reusability->False,
					MaxNumberOfUses->1,
					PackingMaterial->Silica,
					FunctionalGroup->Null,
					Replace[WettedMaterials]->{Silica,Polypropylene},
					ParticleSize->40 Micrometer,
					BedWeight->12 Gram,
					MaxPressure->200 PSI,
					MaxFlowRate->4 Milliliter/Minute,
					Dimensions->{
						1.95 Centimeter,
						1.95 Centimeter,
						7.485 Centimeter
					},
					ColumnLength->7.485 Centimeter,
					Diameter->1.95 Centimeter,

					VoidVolume->16.8 Milliliter,
					MinSampleMass->20 Milligram,
					MaxSampleMass->400 Milligram,

					Replace[Authors]->{Link[$PersonID]},
					Replace[ProductDocumentationFiles]->{Link[Object[EmeraldCloudFile,"id:GmzlKjPvXWa9"]]},
					ChromatographyType->Flash,
					ColumnType->Preparative,
					PackingType->Prepacked,
					DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
					Expires->True,
					UnsealedShelfLife->2 Year,
					MinTemperature->20 Celsius,
					MaxTemperature->25 Celsius,
					MinPressure->0 PSI,
					MinFlowRate->0.5 Milliliter/Minute,
					MinpH->1.,
					MaxpH->10.,
					DeveloperObject->True
				|>,
				<|
					Type->Model[Item,Column],
					StorageCaps->True,
					Name->"Very Long Column Model for ExperimentFlashChromatography Testing"<>$SessionUUID,
					SeparationMode->NormalPhase,
					Reusability->False,
					MaxNumberOfUses->1,
					PackingMaterial->Silica,
					FunctionalGroup->Null,
					Replace[WettedMaterials]->{Silica,Polypropylene},
					ParticleSize->63 Micrometer,
					BedWeight->12 Gram,
					MaxPressure->200 PSI,
					MaxFlowRate->30 Milliliter/Minute,
					Dimensions->{
						1.95 Centimeter,
						1.95 Centimeter,
						100 Centimeter
					},
					ColumnLength->100 Centimeter,
					Diameter->1.95 Centimeter,

					VoidVolume->16.8 Milliliter,
					MinSampleMass->20 Milligram,
					MaxSampleMass->400 Milligram,

					Replace[Authors]->{Link[$PersonID]},
					Replace[ProductDocumentationFiles]->{Link[Object[EmeraldCloudFile,"id:GmzlKjPvXWa9"]]},
					ChromatographyType->Flash,
					ColumnType->Preparative,
					PackingType->Prepacked,
					DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
					Expires->True,
					UnsealedShelfLife->2 Year,
					MinTemperature->20 Celsius,
					MaxTemperature->25 Celsius,
					MinPressure->0 PSI,
					MinFlowRate->0.5 Milliliter/Minute,
					MinpH->1.,
					MaxpH->10.,
					DeveloperObject->True
				|>,
				<|
					Type->Model[Container,ExtractionCartridge],
					Name->"Cartridge Model with Null PackingType for ExperimentFlashChromatography Testing"<>$SessionUUID,
					SeparationMode->Null,
					Reusability->False,
					MaxNumberOfUses->1,
					PackingMaterial->Null,
					PackingType->Null,
					CasingMaterial->Polypropylene,
					FunctionalGroup->Null,
					ParticleSize->Null,
					BedWeight->Null,
					MaxBedWeight->25 Gram,
					MaxVolume->45 Milliliter,
					MaxPressure->200 PSI,
					MaxFlowRate->35 Milliliter/Minute,
					Dimensions->{
						2.657 Centimeter,
						2.657 Centimeter,
						8.509 Centimeter
					},
					CartridgeLength->8.509 Centimeter,
					Diameter->2.657 Centimeter,

					Replace[Positions]->{
						<|
							Name->"A1",
							Footprint->Open,
							MaxWidth->2.657 Centimeter,
							MaxDepth->2.657 Centimeter,
							MaxHeight->8.509 Centimeter
						|>
					},
					Replace[PositionPlotting]->{
						<|
							Name->"A1",
							XOffset->1.3285 Centimeter,
							YOffset->1.3285 Centimeter,
							ZOffset->4.2545 Centimeter,
							CrossSectionalShape->Circle,
							Rotation->0.
						|>
					},
					CrossSectionalShape->Circle,
					Replace[Authors]->{Link[$PersonID]},
					Replace[ProductDocumentationFiles]->{Link[Object[EmeraldCloudFile,"id:GmzlKjPvXWa9"]]},
					ChromatographyType->Flash,
					DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
					Expires->True,
					UnsealedShelfLife->2 Year,
					MinTemperature->20 Celsius,
					MaxTemperature->25 Celsius,
					MinPressure->0 PSI,
					MinFlowRate->0.5 Milliliter/Minute,
					MinpH->7.,
					MaxpH->10.,
					DeveloperObject->True
				|>,
				<|
					Type->Model[Container,ExtractionCartridge],
					Name->"Cartridge Model with Low Flow Rate for ExperimentFlashChromatography Testing"<>$SessionUUID,
					SeparationMode->Null,
					Reusability->False,
					MaxNumberOfUses->1,
					PackingMaterial->Null,
					PackingType->HandPacked,
					CasingMaterial->Polypropylene,
					FunctionalGroup->Null,
					ParticleSize->Null,
					BedWeight->Null,
					MaxBedWeight->25 Gram,
					MaxVolume->45 Milliliter,
					MaxPressure->200 PSI,
					MaxFlowRate->4 Milliliter/Minute,
					Dimensions->{
						2.657 Centimeter,
						2.657 Centimeter,
						8.509 Centimeter
					},
					CartridgeLength->8.509 Centimeter,
					Diameter->2.657 Centimeter,

					Replace[Positions]->{
						<|
							Name->"A1",
							Footprint->Open,
							MaxWidth->2.657 Centimeter,
							MaxDepth->2.657 Centimeter,
							MaxHeight->8.509 Centimeter
						|>
					},
					Replace[PositionPlotting]->{
						<|
							Name->"A1",
							XOffset->1.3285 Centimeter,
							YOffset->1.3285 Centimeter,
							ZOffset->4.2545 Centimeter,
							CrossSectionalShape->Circle,
							Rotation->0.
						|>
					},
					CrossSectionalShape->Circle,
					Replace[Authors]->{Link[$PersonID]},
					Replace[ProductDocumentationFiles]->{Link[Object[EmeraldCloudFile,"id:GmzlKjPvXWa9"]]},
					ChromatographyType->Flash,
					DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
					Expires->True,
					UnsealedShelfLife->2 Year,
					MinTemperature->20 Celsius,
					MaxTemperature->25 Celsius,
					MinPressure->0 PSI,
					MinFlowRate->0.5 Milliliter/Minute,
					MinpH->7.,
					MaxpH->10.,
					DeveloperObject->True
				|>,
				<|
					Type->Model[Container,ExtractionCartridge],
					Name->"Cartridge Model with High Flow Rate for ExperimentFlashChromatography Testing"<>$SessionUUID,
					SeparationMode->Null,
					Reusability->False,
					MaxNumberOfUses->1,
					PackingMaterial->Null,
					PackingType->HandPacked,
					CasingMaterial->Polypropylene,
					FunctionalGroup->Null,
					ParticleSize->Null,
					BedWeight->Null,
					MaxBedWeight->25 Gram,
					MaxVolume->45 Milliliter,
					MaxPressure->200 PSI,
					MaxFlowRate->200 Milliliter/Minute,
					Dimensions->{
						2.657 Centimeter,
						2.657 Centimeter,
						8.509 Centimeter
					},
					CartridgeLength->8.509 Centimeter,
					Diameter->2.657 Centimeter,

					Replace[Positions]->{
						<|
							Name->"A1",
							Footprint->Open,
							MaxWidth->2.657 Centimeter,
							MaxDepth->2.657 Centimeter,
							MaxHeight->8.509 Centimeter
						|>
					},
					Replace[PositionPlotting]->{
						<|
							Name->"A1",
							XOffset->1.3285 Centimeter,
							YOffset->1.3285 Centimeter,
							ZOffset->4.2545 Centimeter,
							CrossSectionalShape->Circle,
							Rotation->0.
						|>
					},
					CrossSectionalShape->Circle,
					Replace[Authors]->{Link[$PersonID]},
					Replace[ProductDocumentationFiles]->{Link[Object[EmeraldCloudFile,"id:GmzlKjPvXWa9"]]},
					ChromatographyType->Flash,
					DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
					Expires->True,
					UnsealedShelfLife->2 Year,
					MinTemperature->20 Celsius,
					MaxTemperature->25 Celsius,
					MinPressure->0 PSI,
					MinFlowRate->150 Milliliter/Minute,
					MinpH->7.,
					MaxpH->10.,
					DeveloperObject->True
				|>

			}];

			testCartridgeModels=Upload[{
				<|
					Type->Model[Container,ExtractionCartridge],
					Name->"Cartridge Model with 6g MaxBedWeight for ExperimentFlashChromatography Testing"<>$SessionUUID,
					SeparationMode->NormalPhase,
					Reusability->False,
					MaxNumberOfUses->1,
					PackingMaterial->Silica,
					PackingType->Prepacked,
					CasingMaterial->Polypropylene,
					FunctionalGroup->Null,
					ParticleSize->40 Micrometer,
					BedWeight->6 Gram,
					MaxBedWeight->6 Gram,
					MaxVolume->10 Milliliter,
					MaxPressure->200 PSI,
					MaxFlowRate->18 Milliliter/Minute,
					Dimensions->{
						1.557 Centimeter,
						1.557 Centimeter,
						5.105 Centimeter
					},
					CartridgeLength->5.105 Centimeter,
					Diameter->1.557 Centimeter,

					Replace[Positions]->{
						<|
							Name->"A1",
							Footprint->Open,
							MaxWidth->1.557 Centimeter,
							MaxDepth->1.557 Centimeter,
							MaxHeight->5.105 Centimeter
						|>
					},
					Replace[PositionPlotting]->{
						<|
							Name->"A1",
							XOffset->1.557/2 Centimeter,
							YOffset->1.557/2 Centimeter,
							ZOffset->5.105/2 Centimeter,
							CrossSectionalShape->Circle,
							Rotation->0.
						|>
					},
					CrossSectionalShape->Circle,
					ImageFile->Link[Object[EmeraldCloudFile,"id:M8n3rx0EvDxG"]],

					Replace[Authors]->{Link[$PersonID]},
					Replace[ProductDocumentationFiles]->{Link[Object[EmeraldCloudFile,"id:GmzlKjPvXWa9"]]},
					ChromatographyType->Flash,
					DefaultStorageCondition->Link[Model[StorageCondition,"Ambient Storage"]],
					Expires->True,
					UnsealedShelfLife->2 Year,
					MinTemperature->20 Celsius,
					MaxTemperature->25 Celsius,
					MinPressure->0 PSI,
					MinFlowRate->0.5 Milliliter/Minute,
					MinpH->7.,
					MaxpH->10.,
					DeveloperObject->True
				|>
			}];

			testProtocols=Upload[{
				<|
					Type->Object[Protocol,FlashChromatography],
					Name->"Already Existing Protocol Name for ExperimentFlashChromatography Testing"<>$SessionUUID
				|>,
				<|
					Type->Object[Protocol,FlashChromatography],
					Name->"Template Protocol for ExperimentFlashChromatography Testing"<>$SessionUUID
				|>
			}];

			testColumns=UploadSample[
				{
					Model[Item,Column,"RediSep Gold Normal Phase Silica Column 4g"],
					Model[Item,Column,"RediSep Gold Normal Phase Silica Column 12g"],
					Model[Item,Column,"RediSep Gold Normal Phase Silica Column 40g"],
					Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 15.5g"],
					Model[Item,Column,"id:o1k9jAGmWnjx"],(* Non-Flash column *)
					Model[Item,Column,"Column Model with Low Flow Rate for ExperimentFlashChromatography Testing"<>$SessionUUID]
				},
				ConstantArray[{"Work Surface",testBench},6],
				Name->{
					"4g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"12g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"40g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"15.5g C18 Column for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"FPLC Column for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Column with Low Flow Rate for ExperimentFlashChromatography Testing"<>$SessionUUID
				},
				StorageCondition->AmbientStorage,
				Status->Available
			];

			testCartridgeMaterials=UploadSample[
				{
					Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Prepacked with 25g Silica"],
					Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Prepacked with 12g Silica"],
					Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Empty"],
					Model[Item,Consumable,"Frits for RediSep 25g Solid Load Cartridge"],
					Model[Item,Plunger,"Plunger for RediSep 25g or 65g Solid Load Cartridge"],
					Model[Part,CartridgeCap,"CombiFlash Adjustable Solid Load Cartridge Cap 5g to 25g"],
					Model[Plumbing,"CombiFlash Adjustable Solid Load Cartridge Cap Tubing"]
				},
				ConstantArray[{"Work Surface",testBench},7],
				Name->{
					"25g Prepacked Silica Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"12g Prepacked Silica Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"25g Empty Silica Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Frits for 25g Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Plunger for 25g Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Cartridge Cap for 25g Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID,
					"Cartridge Cap Tubing for 25g Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID
				},
				StorageCondition->AmbientStorage,
				Status->{Stocked,Stocked,Stocked,Stocked,Available,Available,Available}
			];

			(* Upload the count of the box of frits *)
			UploadCount[Object[Item,Consumable,"Frits for 25g Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID],100];


			(* Get a list of the uploaded objects *)
			uploadedObjects=Flatten[{testBench,testInstruments,testContainers,testCovers,testSamples,testColumnModels,testProtocols,testColumns,testCartridgeMaterials}];

			(* Set DeveloperObject for the uploaded objects *)
			Upload[Map[
				<|
					Object->#,
					DeveloperObject->True
				|>&,
				uploadedObjects
			]];
		];
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::DeprecatedProduct];
		On[Warning::SampleMustBeMoved];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::NoModelNameGiven];

		tearDownExperimentFlashChromatographyTestObjects[];
		Unset[$CreatedObjects];
	}
];

tearDownExperimentFlashChromatographyTestObjects[]:=Module[
	{
		allObjects,existingObjects
	},

	(* Gather all the objects and models created in SymbolSetUp *)
	allObjects=Join[
		Cases[$CreatedObjects,ObjectP[]],
		{

			(*-- Test Objects --*)

			Object[Container,Bench,"Bench for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Container,Rack,"Local Cache for ExperimentFlashChromatography Testing"<>$SessionUUID],

			Object[Item,Cap,"Buffer A1 Aspiration Cap for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Cap,"Buffer B1 Aspiration Cap for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Container,Deck,"Buffer Deck for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Container,Deck,"Fraction Collection Deck for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Container,Vessel,"Waste Container for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Instrument,FlashChromatography,"Instrument for ExperimentFlashChromatography Testing"<>$SessionUUID],

			Object[Container,Vessel,"Tube 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Container,Vessel,"Tube 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Container,Vessel,"Tube 3 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Container,Vessel,"Tube 4 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Container,Vessel,"Tube 5 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Container,Vessel,"Tube 6 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Container,Vessel,"Tube 7 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Container,Vessel,"Tube 8 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Container,Vessel,"Bottle 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Container,Vessel,"Bottle 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Container,Vessel,"Tube for Silica Gel for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Container,Vessel,"Tube for Solid Qualification Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],

			Object[Item,Cap,"Tube Cap 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Cap,"Tube Cap 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Cap,"Tube Cap 3 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Cap,"Tube Cap 4 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Cap,"Tube Cap 5 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Cap,"Tube Cap 6 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Cap,"Tube Cap 7 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Cap,"Tube Cap 8 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Cap,"Bottle Cap 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Cap,"Bottle Cap 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Cap,"Tube Cap for Silica Gel Tube for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Cap,"Tube Cap for Solid Qualification Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],

			Object[Sample,"Sample 1 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Sample,"Sample 2 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Sample,"Sample 3 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Sample,"Sample 4 for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Sample,"Low Volume Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Sample,"Discarded Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Sample,"Solid Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Sample,"Null Volume Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Sample,"Hexanes Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Sample,"Ethyl Acetate Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Sample,"Silica Gel for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Sample,"Solid Qualification Sample for ExperimentFlashChromatography Testing"<>$SessionUUID],

			Model[Item,Column,"Column Model with Low Flow Rate for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Model[Item,Column,"Very Long Column Model for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Model[Container,ExtractionCartridge,"Cartridge Model with Null PackingType for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Model[Container,ExtractionCartridge,"Cartridge Model with Low Flow Rate for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Model[Container,ExtractionCartridge,"Cartridge Model with High Flow Rate for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Model[Container,ExtractionCartridge,"Cartridge Model with 6g MaxBedWeight for ExperimentFlashChromatography Testing"<>$SessionUUID],

			Object[Protocol,FlashChromatography,"Already Existing Protocol Name for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Protocol,FlashChromatography,"Template Protocol for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Protocol,FlashChromatography,"My Favorite Flash Chromatography Protocol"<>$SessionUUID],
			Object[Item,Column,"4g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Column,"12g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Column,"40g Silica Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Column,"15.5g C18 Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Column,"FPLC Column for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Column,"Column with Low Flow Rate for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Container,ExtractionCartridge,"25g Prepacked Silica Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Container,ExtractionCartridge,"12g Prepacked Silica Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Container,ExtractionCartridge,"25g Empty Silica Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Consumable,"Frits for 25g Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Item,Plunger,"Plunger for 25g Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Part,CartridgeCap,"Cartridge Cap for 25g Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID],
			Object[Plumbing,"Cartridge Cap Tubing for 25g Cartridge for ExperimentFlashChromatography Testing"<>$SessionUUID]
		}
	];

	(* Check whether the names already exist in the database *)
	existingObjects=PickList[allObjects,DatabaseMemberQ[allObjects]];

	(* Erase any objects and models that exist in the database *)
	Quiet[EraseObject[existingObjects,Force->True,Verbose->False]];
];


(* ::Subsection:: *)
(*FlashChromatography*)

DefineTests[
	FlashChromatography,
	{
		Example[{Basic,"FlashChromatography primitive can be used as part of ExperimentSamplePreparation with sample labels:"},
			protocol=ExperimentSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Container->Model[Container,Vessel,"50mL Tube"],
					Amount->1 Milliliter,
					Label->"my sample 1"
				],
				Transfer[
					Source->"my sample 1",
					Destination->Model[Container,Vessel,"2mL Tube"],
					Amount->300 Microliter,
					DestinationLabel->"my sample 2"
				],
				FlashChromatography[
					Sample->{
						"my sample 1",
						"my sample 2"
					}
				]
			}];
			{
				Download[protocol,CalculatedUnitOperations[[3]][LoadingAmountVariableUnit]],
				Lookup[Download[protocol,ResolvedUnitOperationOptions[[3]]],LoadingAmount]
			},
			{
				{0.7 Milliliter,0.3 Milliliter},
				{0.7 Milliliter,0.3 Milliliter}
			},
			Variables:>{protocol},
			EquivalenceFunction->Equal
		],
		Example[{Options,Sample,"FlashChromatography primitive can accept a list of samples:"},
			ExperimentSamplePreparation[{
				LabelSample[
					Sample->{
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"]
					},
					Amount->{
						5 Milliliter,
						5 Milliliter
					},
					Label->{
						"sample 1",
						"sample 2"
					}
				],
				FlashChromatography[
					Sample->{
						"sample 1",
						"sample 2"
					}
				]
			}],
			ObjectP[Object[Protocol,ManualSamplePreparation]]
		],
		Example[{Options,LoadingType,"FlashChromatography primitive can accept a list of samples with different loading types:"},
			protocol=ExperimentSamplePreparation[{
				LabelSample[
					Sample->{
						Model[Sample,"Milli-Q water"],
						Model[Sample,"Milli-Q water"]
					},
					Amount->{
						5 Milliliter,
						5 Milliliter
					},
					Label->{
						"sample 1",
						"sample 2"
					}
				],
				FlashChromatography[
					Sample->{
						"sample 1",
						"sample 2"
					},
					LoadingType->{
						Liquid,
						Solid
					}
				]
			}];
			{
				Download[protocol,CalculatedUnitOperations[[2]][{LoadingType,CartridgeLink}]],
				Lookup[Download[protocol,ResolvedUnitOperationOptions[[2]]],{LoadingType,Cartridge}]
			},
			{
				{
					{Liquid,Solid},
					{Null,ObjectP[Model[Container,ExtractionCartridge]]}
				},
				{
					{Liquid,Solid},
					{Null,ObjectP[Model[Container,ExtractionCartridge]]}
				}
			},
			Variables:>{protocol}
		],
		Example[{Options,SampleLabel,"FlashChromatography primitive can accept a container label and can label the sample inside it:"},
			protocol=ExperimentSamplePreparation[{
				LabelContainer[
					Label->"my container",
					Container->Model[Container,Vessel,"50mL Tube"]
				],
				Transfer[
					Source->Model[Sample,"Milli-Q water"],
					Destination->"my container",
					Amount->3 Milliliter
				],
				FlashChromatography[
					Sample->"my container",
					SampleLabel->"my sample"
				]
			}];
			Download[protocol,CalculatedUnitOperations[[3]][{SampleLabel,SampleContainerLabel,FlowRate}]],
			{
				{"my sample"},
				{"my container"},
				{FlowRateP}
			},
			Variables:>{protocol}
		],
		Example[{Options,SampleContainerLabel,"The SampleContainerLabel can label the container of the input sample:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					SampleContainerLabel->"sample container"
				]
			}];
			Download[protocol,{
				CalculatedUnitOperations[[1]][ContainerLink],
				CalculatedUnitOperations[[2]][{SampleLabel,SampleContainerLabel,FlowRate}]
			}],
			{
				{
					ObjectP[PreferredContainer[45 Milliliter]]
				},
				{
					{"sample"},
					{"sample container"},
					{FlowRateP}
				}
			},
			Variables:>{protocol}
		],
		Example[{Options,MaxLoadingPercent,"MaxLoadingPercent can be specified to indicate the maximum percentage of the column's VoidVolume that can be loaded onto the column as sample:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					MaxLoadingPercent->5 Percent
				]
			}];
			{
				Download[protocol,CalculatedUnitOperations[[2]][{MaxLoadingPercent,LoadingAmountVariableUnit}]],
				Round[Download[protocol,CalculatedUnitOperations[[2]][ColumnLink][VoidVolume]]*0.05,0.1 Milliliter]
			},
			{
				{
					{5 Percent},
					{0.8 Milliliter}
				},
				{0.8 Milliliter}
			},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,Column,"Column can be specified to indicate the type of column that the sample will flow through to be separated:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					Column->Model[Item,Column,"RediSep Gold Normal Phase Amine Column 15.5g"]
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][{ColumnLink,SeparationMode}]],
			{
				{ObjectP[Model[Item,Column,"RediSep Gold Normal Phase Amine Column 15.5g"]]},
				NormalPhase
			},
			Variables:>{protocol}
		],
		Example[{Options,ColumnLabel,"ColumnLabel can be specified to a String to provide a label for a column, or it can automatically resolve to a String:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->{"sample","sample"},
					ColumnLabel->{
						"My favorite FlashChromatography column",
						Automatic
					}
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][ColumnLabel]],
			{
				"My favorite FlashChromatography column",
				_String
			},
			Variables:>{protocol}
		],
		Example[{Options,PreSampleEquilibration,"PreSampleEquilibration can be specified to indicate how long buffer at the initial gradient composition will be flowed through the column to equilibrate it before the introduction of sample:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->{"sample","sample"},
					PreSampleEquilibration->{5 Minute,Automatic}
				]
			}];
			{preSampleEquilibrium,voidVolume,flowRate}=Download[protocol,CalculatedUnitOperations[[2]][{PreSampleEquilibration,ColumnLink[VoidVolume],FlowRate}]];
			{
				preSampleEquilibrium,
				voidVolume,
				flowRate,
				voidVolume[[2]]*3/flowRate[[2]]
			},
			{
				{5.0 Minute,1.68 Minute},
				{16.8 Milliliter,16.8 Milliliter},
				{30.0 Milliliter/Minute,30.0 Milliliter/Minute},
				1.68 Minute
			},
			EquivalenceFunction->RoundMatchQ[8],
			Variables:>{protocol,preSampleEquilibrium,voidVolume,flowRate}
		],
		Example[{Options,LoadingAmount,"LoadingAmount can be specified to a Volume or to All (which loads All of the sample):"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->0.5 Milliliter,
					Label->"low volume sample"
				],
				FlashChromatography[
					Sample->{"sample","low volume sample"},
					LoadingAmount->{0.9 Milliliter,All}
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][{LoadingAmountExpression,LoadingAmountVariableUnit}]],
			{
				{Null,All},
				{0.9 Milliliter,Null}
			},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,Cartridge,"Cartridge can be specified to indicate the type of solid load cartridge into which sample will be introduced if LoadingType is Solid:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					Cartridge->Model[Container,ExtractionCartridge,"RediSep 5g Solid Load Cartridge Empty"]
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][CartridgeLink]],
			{ObjectP[Model[Container,ExtractionCartridge,"RediSep 5g Solid Load Cartridge Empty"]]},
			Variables:>{protocol}
		],
		Example[{Options,CartridgeLabel,"CartridgeLabel can be specified to a String to provide a label for a cartridge, or it can automatically resolve to a String:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->{"sample","sample"},
					LoadingType->Solid,
					CartridgeLabel->{
						"My favorite FlashChromatography cartridge",
						Automatic
					}
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][CartridgeLabel]],
			{
				"My favorite FlashChromatography cartridge",
				_String
			},
			Variables:>{protocol}
		],
		Example[{Options,CartridgePackingMaterial,"CartridgePackingMaterial can be specified if Cartridge is specified to a cartridge with LoadingType HandPacked to indicate the material with which the cartridge will be filled:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					LoadingType->Solid,
					Cartridge->Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Empty"],
					CartridgePackingMaterial->Silica
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][CartridgePackingMaterial]],
			{Silica},
			Variables:>{protocol}
		],
		Example[{Options,CartridgeFunctionalGroup,"CartridgeFunctionalGroup can be specified if Cartridge is specified to a cartridge with LoadingType HandPacked to indicate the functional group on the material with which the cartridge will be filled:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					Column->Model[Item,Column,"RediSep Gold Reverse Phase C18 Column 5.5g"],
					Cartridge->Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Empty"],
					CartridgeFunctionalGroup->C18
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][CartridgeFunctionalGroup]],
			{C18},
			Variables:>{protocol}
		],
		Example[{Options,CartridgePackingMass,"CartridgePackingMass can be specified if Cartridge is specified to a cartridge with LoadingType HandPacked to indicate the mass of the material with which the cartridge will be filled:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					Cartridge->Model[Container,ExtractionCartridge,"RediSep 65g Solid Load Cartridge Empty"],
					CartridgePackingMass->30 Gram
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][CartridgePackingMass]],
			{30 Gram},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,CartridgeDryingTime,"CartridgeDryingTime can be specified to indicate how long the loaded cartridge will be dried with compressed air before the start of separation:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					CartridgeDryingTime->10.0 Minute
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][{LoadingType,CartridgeLink,CartridgeDryingTime}]],
			{
				{Solid},
				{ObjectP[Model[Container,ExtractionCartridge,"RediSep 25g Solid Load Cartridge Prepacked with 12g Silica"]]},
				{10.0 Minute}
			},
			Variables:>{protocol}
		],
		Example[{Options,GradientA,"Specify GradientA to an isocratic separation at 50% BufferA for 10 minutes:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					GradientA->{
						{0 Minute,50 Percent},
						{10 Minute,50 Percent}
					}
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][GradientA]],
			{{
				{0 Minute,50 Percent},
				{10 Minute,50 Percent}
			}},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,GradientB,"Specify GradientB to a 5 minute equilibration at 0% Buffer B, then a linear ramp from 0% to 90% over 20 minutes, then a 10 minute flush at 90%:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					GradientB->{
						{0 Minute,0 Percent},
						{5 Minute,0 Percent},
						{25 Minute,90 Percent},
						{35 Minute,90 Percent}
					}
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][GradientB]],
			{{
				{0 Minute,0 Percent},
				{5 Minute,0 Percent},
				{25 Minute,90 Percent},
				{35 Minute,90 Percent}
			}},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,FlowRate,"FlowRate can be specified to indicate the rate at which fluid will move through the instrument and column:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					FlowRate->10 Milliliter/Minute
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][FlowRate]],
			{10 Milliliter/Minute},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,GradientStart,"GradientStart can be specified alongside GradientEnd and GradientDuration to indicate the percentage of BufferB at the beginning of the gradient:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					GradientStart->3 Percent,
					GradientEnd->80 Percent,
					GradientDuration->10 Minute
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][GradientB]],
			{{
				{0 Minute,3 Percent},
				{10 Minute,80 Percent}
			}},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,GradientEnd,"GradientEnd can be specified alongside GradientStart and GradientDuration to indicate the percentage of BufferB at the end of the gradient:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					GradientStart->5 Percent,
					GradientEnd->85 Percent,
					GradientDuration->12 Minute
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][GradientB]],
			{{
				{0 Minute,5 Percent},
				{12 Minute,85 Percent}
			}},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,GradientDuration,"GradientDuration can be specified alongside GradientStart and GradientEnd to indicate the length of time over which BufferB changes from the percentage specified by GradientStart to that specified by GradientEnd:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					GradientStart->9 Percent,
					GradientEnd->81 Percent,
					GradientDuration->14 Minute
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][GradientB]],
			{{
				{0 Minute,9 Percent},
				{14 Minute,81 Percent}
			}},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,EquilibrationTime,"EquilibrationTime can be specified if GradientStart, GradientEnd, and GradientDuration are also specified to indicate the length of time that BufferB is held at the percentage specified by GradientStart before the start of GradientDuration:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					GradientStart->20 Percent,
					GradientEnd->60 Percent,
					GradientDuration->20 Minute,
					EquilibrationTime->10 Minute
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][GradientB]],
			{{
				{0 Minute,20 Percent},
				{10 Minute,20 Percent},
				{30 Minute,60 Percent}
			}},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,FlushTime,"FlushTime can be specified if GradientStart, GradientEnd, and GradientDuration are also specified to indicate the length of time that BufferB is held at the percentage specified by GradientEnd after the end of GradientDuration:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					GradientStart->5 Percent,
					GradientEnd->50 Percent,
					GradientDuration->10 Minute,
					FlushTime->15 Minute
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][GradientB]],
			{{
				{0 Minute,5 Percent},
				{10 Minute,50 Percent},
				{25 Minute,50 Percent}
			}},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,Gradient,"Gradient can be specified and GradientA and GradientB will resolve to match it:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					Gradient->{
						{0 Minute,95 Percent,5 Percent},
						{10 Minute,95 Percent,5 Percent},
						{20 Minute,15 Percent,85 Percent}
					}
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][{Gradient,GradientA,GradientB}]],
			{
				{{
					{0 Minute,95 Percent,5 Percent},
					{10 Minute,95 Percent,5 Percent},
					{20 Minute,15 Percent,85 Percent}
				}},
				{{
					{0 Minute,95 Percent},
					{10 Minute,95 Percent},
					{20 Minute,15 Percent}
				}},
				{{
					{0 Minute,5 Percent},
					{10 Minute,5 Percent},
					{20 Minute,85 Percent}
				}}
			},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,CollectFractions,"CollectFractions can be specified to indicate whether eluent from the column containing separated sample should be collected:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->{"sample","sample"},
					CollectFractions->{True,False}
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][{CollectFractions,FractionContainer}]],
			{
				{True,False},
				{ObjectP[Model[Container,Vessel]],Null}
			},
			Variables:>{protocol}
		],
		Example[{Options,FractionCollectionStartTime,"FractionCollectionStartTime can be specified to indicate the time during the gradient when fraction collection can begin:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					FractionCollectionStartTime->2 Minute
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][{CollectFractions,FractionCollectionStartTime}]],
			{
				{True},
				{2 Minute}
			},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,FractionCollectionEndTime,"FractionCollectionEndTime can be specified to indicate the time during the gradient when fraction collection will cease:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					FractionCollectionEndTime->11 Minute
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][{CollectFractions,FractionCollectionEndTime}]],
			{
				{True},
				{11 Minute}
			},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,FractionContainer,"FractionContainer can be specified to indicate the model of container into which eluent from the column will be collected:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					FractionContainer->Model[Container,Vessel,"15mL Tube"]
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][FractionContainer]],
			{ObjectP[Model[Container,Vessel,"15mL Tube"]]},
			Variables:>{protocol}
		],
		Example[{Options,MaxFractionVolume,"MaxFractionVolume can be specified to indicate the maximum volume of eluent that will be collected in each fraction collection container:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					FractionContainer->Model[Container,Vessel,"15mL Tube"],
					MaxFractionVolume->10 Milliliter
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][MaxFractionVolume]],
			{10 Milliliter},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,FractionCollectionMode,"FractionCollectionMode can be specified to indicate whether All eluent from the column will be collected, or only that corresponding to Peaks called by the peak detection algorithm:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					FractionCollectionMode->Peaks
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][FractionCollectionMode]],
			{Peaks},
			Variables:>{protocol}
		],
		Example[{Options,Detectors,"Detectors can be specified to a list of detectors (including PrimaryWavelength, SecondaryWavelength, and/or WideRangeUV) or to All which indicates that all three Detectors will be used:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->{"sample","sample"},
					Detectors->{
						{PrimaryWavelength,SecondaryWavelength},
						All
					}
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][Detectors]],
			{
				{PrimaryWavelength,SecondaryWavelength},
				All
			},
			Variables:>{protocol}
		],
		Example[{Options,PrimaryWavelength,"PrimaryWavelength can be specified to a wavelength of UV light whose absorbance through the sample will be measured during the separation:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					PrimaryWavelength->310 Nanometer
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][PrimaryWavelength]],
			{310 Nanometer},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,SecondaryWavelength,"SecondaryWavelength can be specified to a wavelength of UV light whose absorbance through the sample will be measured during the separation:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					SecondaryWavelength->270 Nanometer
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][SecondaryWavelength]],
			{270 Nanometer},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,WideRangeUV,"WideRangeUV can be specified to a span of wavelengths of UV light whose average absorbance through the sample will be measured during the separation:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					WideRangeUV->250 Nanometer;;300 Nanometer
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][WideRangeUV]],
			{250 Nanometer;;300 Nanometer},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,PeakDetectors,"PeakDetectors can be specified to a list of detectors (PrimaryWavelength, SecondaryWavelength, and/or WideRangeUV):"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					PeakDetectors->{PrimaryWavelength,WideRangeUV}
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][PeakDetectors]],
			{{PrimaryWavelength,WideRangeUV}},
			Variables:>{protocol}
		],
		Example[{Options,PrimaryWavelengthPeakDetectionMethod,"PrimaryWavelengthPeakDetectionMethod can be specified to a list of Slope and/or Threshold (or to Null if PrimaryWavelength is not present in PeakDetectors) to indicate the peak detection algorithms that will be used to call peaks on the absorbance detection from the PrimaryWavelength detector:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->{"sample","sample","sample"},
					PeakDetectors->{
						Automatic,
						Automatic,
						{SecondaryWavelength,WideRangeUV}
					},
					PrimaryWavelengthPeakDetectionMethod->{
						{Slope},
						{Slope,Threshold},
						Null
					}
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][PrimaryWavelengthPeakDetectionMethod]],
			{
				{Slope},
				{Slope,Threshold},
				Null
			},
			Variables:>{protocol}
		],
		Example[{Options,SecondaryWavelengthPeakDetectionMethod,"SecondaryWavelengthPeakDetectionMethod can be specified to a list of Slope and/or Threshold to indicate the peak detection algorithms that will be used to call peaks on the absorbance detection from the PrimaryWavelength detector:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					SecondaryWavelengthPeakDetectionMethod->{Slope,Threshold}
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][SecondaryWavelengthPeakDetectionMethod]],
			{{Slope,Threshold}},
			Variables:>{protocol}
		],
		Example[{Options,WideRangeUVPeakDetectionMethod,"WideRangeUVPeakDetectionMethod can be specified to a list of Slope and/or Threshold to indicate the peak detection algorithms that will be used to call peaks on the absorbance detection from the PrimaryWavelength detector:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					WideRangeUVPeakDetectionMethod->{Slope}
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][WideRangeUVPeakDetectionMethod]],
			{{Slope}},
			Variables:>{protocol}
		],
		Example[{Options,PrimaryWavelengthPeakWidth,"PrimaryWavelengthPeakWidth can be specified to a peak width from FlashChromatographyPeakWidthP to indicate the peak width parameter used for the Slope-based peak detection algorithm:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					PrimaryWavelengthPeakWidth->2 Minute
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][PrimaryWavelengthPeakWidth]],
			{2 Minute},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,SecondaryWavelengthPeakWidth,"SecondaryWavelengthPeakWidth can be specified to a peak width from FlashChromatographyPeakWidthP to indicate the peak width parameter used for the Slope-based peak detection algorithm:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					SecondaryWavelengthPeakWidth->4 Minute
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][SecondaryWavelengthPeakWidth]],
			{4 Minute},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,WideRangeUVPeakWidth,"WideRangeUVPeakWidth can be specified to a peak width from FlashChromatographyPeakWidthP to indicate the peak width parameter used for the Slope-based peak detection algorithm:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					WideRangeUVPeakWidth->30 Second
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][WideRangeUVPeakWidth]],
			{30 Second},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,PrimaryWavelengthPeakThreshold,"PrimaryWavelengthPeakThreshold can be specified to an absorbance value to indicate the absorbance level above which a peak will be called:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					PrimaryWavelengthPeakThreshold->150 MilliAbsorbanceUnit
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][PrimaryWavelengthPeakThreshold]],
			{150 MilliAbsorbanceUnit},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,SecondaryWavelengthPeakThreshold,"SecondaryWavelengthPeakThreshold can be specified to an absorbance value to indicate the absorbance level above which a peak will be called:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					SecondaryWavelengthPeakThreshold->140 MilliAbsorbanceUnit
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][SecondaryWavelengthPeakThreshold]],
			{140 MilliAbsorbanceUnit},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,WideRangeUVPeakThreshold,"WideRangeUVPeakThreshold can be specified to an absorbance value to indicate the absorbance level above which a peak will be called:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					WideRangeUVPeakThreshold->120 MilliAbsorbanceUnit
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][WideRangeUVPeakThreshold]],
			{120 MilliAbsorbanceUnit},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,ColumnStorageCondition,"ColumnStorageCondition defaults to AmbientStorage for reusable columns and to Disposal for single-use columns:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->{"sample","sample"},
					Column->{
						Model[Item,Column,"RediSep Gold Normal Phase Amine Column 15.5g"],
						Model[Item,Column,"RediSep Gold Normal Phase Silica Column 24g"]
					}
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][ColumnStorageCondition]],
			{AmbientStorage,Disposal},
			Variables:>{protocol}
		],
		Example[{Options,AirPurgeDuration,"AirPurgeDuration can be specified to a length of time to indicate how long the column will have pressurized air forced through it to remove traces of the buffers:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					AirPurgeDuration->2 Minute
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][AirPurgeDuration]],
			{2 Minute},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,Incubate,"Indicates if the SamplesIn should be incubated at a fixed temperature prior to starting the experiment or aliquoting. Incubate->True indicates that all SamplesIn should be incubated. Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					Incubate->True
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][Incubate]],
			{True},
			Variables:>{protocol}
		],
		Example[{Options,IncubationTemperature,"Temperature at which the SamplesIn should be incubated for the duration of the IncubationTime prior to starting the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					IncubationTemperature->40*Celsius
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][IncubationTemperatureReal]],
			{40*Celsius},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,IncubationTime,"Duration for which SamplesIn should be incubated at the IncubationTemperature, prior to starting the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					IncubationTime->40*Minute
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][IncubationTime]],
			{40*Minute},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,MaxIncubationTime,"Maximum duration of time for which the samples will be mixed while incubated in an attempt to dissolve any solute, if the MixUntilDissolved option is chosen: This occurs prior to starting the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					MaxIncubationTime->40*Minute
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][MaxIncubationTime]],
			{40*Minute},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,IncubationInstrument,"The instrument used to perform the Mix and/or Incubation, prior to starting the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					IncubationInstrument->Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][IncubationInstrument]],
			{ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]]},
			Variables:>{protocol}
		],
		Example[{Options,AnnealingTime,"Minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed but prior to starting the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					AnnealingTime->40*Minute
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][AnnealingTime]],
			{40*Minute},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,IncubateAliquot,"The amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when performing an aliquot before incubation:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					IncubateAliquot->1.5*Milliliter
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][IncubateAliquotReal]],
			{1.5*Milliliter},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],

		Example[{Options,IncubateAliquotContainer,"The desired type of container that should be used to prepare and house the incubation samples which should be used in lieu of the SamplesIn for the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					IncubateAliquotContainer->Model[Container,Vessel,"50mL Tube"]
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][IncubateAliquotContainerExpression]],
			{{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]}},
			Variables:>{protocol}
		],
		Example[{Options,IncubateAliquotDestinationWell,"Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					IncubateAliquotContainer->Model[Container,Vessel,"50mL Tube"],
					IncubateAliquotDestinationWell->"A1"
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][IncubateAliquotDestinationWell]],
			{"A1"},
			Variables:>{protocol}
		],
		Example[{Options,Mix,"Indicates if this sample should be mixed while incubated, prior to starting the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					Mix->True
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][Mix]],
			{True},
			Variables:>{protocol}
		],
		Example[{Options,MixType,"Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					MixType->Shake
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][MixType]],
			{Shake},
			Variables:>{protocol}
		],
		Example[{Options,MixUntilDissolved,"Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix FiltrationType), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					MixUntilDissolved->True
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][MixUntilDissolved]],
			{True},
			Variables:>{protocol}
		],
		Example[{Options,Centrifuge,"Indicates if the SamplesIn should be centrifuged prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					Centrifuge->True
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][Centrifuge]],
			{True},
			Variables:>{protocol}
		],
		Example[{Options,CentrifugeInstrument,"The centrifuge that will be used to spin the provided samples prior to starting the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					CentrifugeInstrument->Model[Instrument,Centrifuge,"Avanti J-15R"]
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][CentrifugeInstrument]],
			{ObjectP[Model[Instrument,Centrifuge,"Avanti J-15R"]]},
			Variables:>{protocol}
		],
		Example[{Options,CentrifugeIntensity,"The rotational speed or the force that will be applied to the samples by centrifugation prior to starting the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					CentrifugeIntensity->1000*RPM
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][CentrifugeIntensity]],
			{1000*RPM},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,CentrifugeTime,"The amount of time for which the SamplesIn should be centrifuged prior to starting the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					CentrifugeTime->10*Minute
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][CentrifugeTime]],
			{10*Minute},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,CentrifugeTemperature,"The temperature at which the centrifuge chamber should be held while the samples are being centrifuged prior to starting the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					CentrifugeTemperature->10*Celsius
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][CentrifugeTemperatureReal]],
			{10*Celsius},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,CentrifugeAliquot,"The amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					CentrifugeAliquot->1.5*Milliliter
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][CentrifugeAliquotReal]],
			{1.5*Milliliter},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,CentrifugeAliquotContainer,"The desired type of container that should be used to prepare and house the centrifuge samples which should be used in lieu of the SamplesIn for the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					CentrifugeAliquotContainer->Model[Container,Vessel,"50mL Tube"]
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][CentrifugeAliquotContainerExpression]],
			{{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]}},
			Variables:>{protocol}
		],
		Example[{Options,CentrifugeAliquotDestinationWell,"Indicates the desired position in the corresponding CentrifugeAliquotDestinationWell in which the aliquot samples will be placed:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					CentrifugeAliquotDestinationWell->"A1"
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][CentrifugeAliquotDestinationWell]],
			{"A1"},
			Variables:>{protocol}
		],
		Example[{Options,Filtration,"Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					Filtration->True
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][Filtration]],
			{True},
			Variables:>{protocol}
		],
		Example[{Options,FiltrationType,"The type of filtration method that should be used to perform the filtration:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					FiltrationType->Syringe
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][FiltrationType]],
			{Syringe},
			Variables:>{protocol}
		],
		Example[{Options,FilterInstrument,"The instrument that should be used to perform the filtration:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					FilterInstrument->Model[Instrument,VacuumPump,"Rocker 300 for Filtration, Non-sterile"]
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][FilterInstrument]],
			{ObjectP[Model[Instrument,VacuumPump,"Rocker 300 for Filtration, Non-sterile"]]},
			Variables:>{protocol}
		],
		Example[{Options,Filter,"The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					Filter->Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][FilterLink]],
			{ObjectP[Model[Item,Filter,"Disk Filter, PES, 0.22um, 30mm"]]},
			Variables:>{protocol}
		],
		Example[{Options,FilterAliquotDestinationWell,"Indicates the position in the filter aliquot container that the sample should be moved into:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					FilterAliquotDestinationWell->"A1"
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][FilterAliquotDestinationWell]],
			{"A1"},
			Variables:>{protocol}
		],
		Example[{Options,FilterMaterial,"The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					FilterMaterial->PES
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][FilterMaterial]],
			{PES},
			Variables:>{protocol}
		],
		Example[{Options,PrefilterMaterial,"The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					PrefilterMaterial->GxF
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][PrefilterMaterial]],
			{GxF},
			Variables:>{protocol}
		],
		Example[{Options,FilterPoreSize,"The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					FilterPoreSize->0.22*Micrometer
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][FilterPoreSize]],
			{0.22*Micrometer},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,PrefilterPoreSize,"The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					PrefilterPoreSize->1.*Micrometer
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][PrefilterPoreSize]],
			{1.*Micrometer},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,FilterSyringe,"The syringe used to force the sample through a filter:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					FilterSyringe->Model[Container, Syringe, "id:AEqRl9Kz1VD1"]
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][FilterSyringe]],
			{ObjectP[Model[Container, Syringe, "id:AEqRl9Kz1VD1"]]},
			Variables:>{protocol}
		],
		Example[{Options,FilterHousing,"FilterHousing resolves to Null for all reasonably-small samples that might be used in this experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					Filtration->True
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][FilterHousingExpression]],
			{Null},
			Variables:>{protocol}
		],
		Example[{Options,FilterIntensity,"The rotational speed or force at which the samples will be centrifuged during filtration:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->0.5 Milliliter,
					Label->"low volume sample"
				],
				FlashChromatography[
					Sample->"low volume sample",
					FiltrationType->Centrifuge,
					FilterIntensity->1000*RPM
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][FilterIntensity]],
			{1000*RPM},
			Variables:>{protocol}
		],
		Example[{Options,FilterTime,"The amount of time for which the samples will be centrifuged during filtration:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->0.5 Milliliter,
					Label->"low volume sample"
				],
				FlashChromatography[
					Sample->"low volume sample",
					FiltrationType->Centrifuge,
					FilterTime->20*Minute
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][FilterTime]],
			{20*Minute},
			Variables:>{protocol}
		],
		Example[{Options,FilterTemperature,"The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->0.5 Milliliter,
					Label->"low volume sample"
				],
				FlashChromatography[
					Sample->"low volume sample",
					FiltrationType->Centrifuge,
					FilterTemperature->10*Celsius
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][FilterTemperature]],
			{10*Celsius},
			Variables:>{protocol}
		],
		Example[{Options,FilterSterile,"Indicates if the filtration of the samples should be done in a sterile environment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					FilterSterile->True
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][FilterSterile]],
			{True},
			Variables:>{protocol}
		],
		Example[{Options,FilterAliquot,"The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					FilterAliquot->150*Microliter
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][FilterAliquotReal]],
			{150*Microliter},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,FilterAliquotContainer,"The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					FilterAliquotContainer->Model[Container,Vessel,"50mL Tube"]
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][FilterAliquotContainerExpression]],
			{{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]}},
			Variables:>{protocol}
		],
		Example[{Options,FilterContainerOut,"The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					FilterContainerOut->Model[Container,Vessel,"50mL Tube"]
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][FilterContainerOutExpression]],
			{{1,ObjectP[Model[Container,Vessel,"50mL Tube"]]}},
			Variables:>{protocol}
		],
		Example[{Options,Aliquot,"Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					Aliquot->True
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][Aliquot]],
			{True},
			Variables:>{protocol}
		],
		Example[{Options,AliquotSampleLabel,"AliquotSampleLabel can be specified to a String to provide a label for an aliquoted sample, or it can automatically resolve to a String if there is an Aliquot or to Null if there is no Aliquot:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->{"sample","sample","sample"},
					Aliquot->{
						True,
						True,
						False
					},
					AliquotAmount->{
						1 Milliliter,
						2 Milliliter,
						Automatic
					},
					AliquotSampleLabel->{
						"My favorite FlashChromatography sample aliquot",
						Automatic,
						Automatic
					}
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][AliquotSampleLabel]],
			{
				"My favorite FlashChromatography sample aliquot",
				_String,
				Null
			},
			Variables:>{protocol}
		],
		Example[{Options,AliquotAmount,"The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					AliquotAmount->0.12*Milliliter
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][AliquotAmountVariableUnit]],
			{0.12*Milliliter},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,AssayVolume,"The desired total volume of the aliquoted sample plus dilution buffer:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					AssayVolume->0.12*Milliliter
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][AssayVolume]],
			{0.12*Milliliter},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,TargetConcentration,"The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelContainer[
					Container->Model[Container,Vessel,"50mL Tube"],
					Label->"container"
				],
				Transfer[
					Source->{Model[Sample,"Uracil"],Model[Sample,"Milli-Q water"]},
					Amount->{25.2 Milligram,45 Milliliter},
					Destination->"container"
				],
				FlashChromatography[
					Sample->"container",
					TargetConcentration->1 Millimolar
				]
			}];
			Download[protocol,CalculatedUnitOperations[[3]][{TargetConcentration,TargetConcentrationAnalyte,AliquotAmountVariableUnit,AssayVolume}]],
			{
				{1 Millimolar},
				{ObjectP[Model[Molecule,"Uracil"]]},
				{45. Milliliter},
				{224. Milliliter}
			},
			EquivalenceFunction->RoundMatchQ[8],
			Variables:>{protocol}
		],
		Example[{Options,TargetConcentrationAnalyte,"The analyte whose desired final concentration is specified:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelContainer[
					Container->Model[Container,Vessel,"50mL Tube"],
					Label->"container"
				],
				Transfer[
					Source->{Model[Sample,"Uracil"],Model[Sample,"Milli-Q water"]},
					Amount->{25.2 Milligram,45 Milliliter},
					Destination->"container"
				],
				FlashChromatography[
					Sample->"container",
					TargetConcentration->5 Micromolar,
					TargetConcentrationAnalyte->Model[Molecule,"Uracil"],
					AliquotAmount->10 Milliliter
				]
			}];
			Download[protocol,CalculatedUnitOperations[[3]][TargetConcentrationAnalyte]],
			{ObjectP[Model[Molecule,"Uracil"]]},
			Variables:>{protocol}
		],
		Example[{Options,ConcentratedBuffer,"The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					AssayVolume->5 Milliliter,
					AliquotAmount->2 Milliliter,
					ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"]
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][ConcentratedBufferLink]],
			{ObjectP[Model[Sample,StockSolution,"10x UV buffer"]]},
			Variables:>{protocol}
		],
		Example[{Options,BufferDilutionFactor,"The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					AssayVolume->5 Milliliter,
					AliquotAmount->2 Milliliter,
					BufferDilutionFactor->10,
					ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"]
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][BufferDilutionFactor]],
			{10},
			EquivalenceFunction->Equal,
			Variables:>{protocol}
		],
		Example[{Options,BufferDiluent,"The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					AssayVolume->5 Milliliter,
					AliquotAmount->2 Milliliter,
					BufferDiluent->Model[Sample,"Milli-Q water"],
					BufferDilutionFactor->10,
					ConcentratedBuffer->Model[Sample,StockSolution,"10x UV buffer"]
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][BufferDiluentLink]],
			{ObjectP[Model[Sample,"Milli-Q water"]]},
			Variables:>{protocol}
		],
		Example[{Options,AssayBuffer,"The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					AssayVolume->5 Milliliter,
					AliquotAmount->2 Milliliter,
					AssayBuffer->Model[Sample,StockSolution,"10x UV buffer"]
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][AssayBufferLink]],
			{ObjectP[Model[Sample,StockSolution,"10x UV buffer"]]},
			Variables:>{protocol}
		],
		Example[{Options,AliquotSampleStorageCondition,"The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					AliquotSampleStorageCondition->Refrigerator
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][AliquotSampleStorageCondition]],
			{Refrigerator},
			Variables:>{protocol}
		],
		Example[{Options,ConsolidateAliquots,"Indicates if identical aliquots should be prepared in the same container/position:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					ConsolidateAliquots->True
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][ConsolidateAliquots]],
			True,
			Variables:>{protocol}
		],
		Example[{Options,AliquotPreparation,"Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					Aliquot->True,
					AliquotPreparation->Manual
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][AliquotPreparation]],
			Manual,
			Variables:>{protocol}
		],
		Example[{Options,AliquotContainer,"Indicates the desired container into which aliquoting will occur:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					AliquotContainer->Model[Container,Plate,"In Situ-1 Crystallization Plate"]
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][AliquotContainerExpression]],
			{{1,ObjectP[Model[Container,Plate,"In Situ-1 Crystallization Plate"]]}},
			Variables:>{protocol}
		],
		Example[{Options,DestinationWell,"The desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					AliquotContainer->Model[Container,Plate,"In Situ-1 Crystallization Plate"],
					DestinationWell->"A2"
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][DestinationWell]],
			{"A2"},
			Variables:>{protocol}
		],
		Example[{Options,SamplesInStorageCondition,"The storage condition at which the samples in should be stored after the end of the protocol:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					SamplesInStorageCondition->Refrigerator
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][SamplesInStorageCondition]],
			{Refrigerator},
			Variables:>{protocol}
		],
		Example[{Options,SamplesOutStorageCondition,"The storage condition at which the samples out should be stored after the end of the protocol:"},
			protocol=ExperimentManualSamplePreparation[{
				LabelSample[
					Sample->Model[Sample,"Milli-Q water"],
					Amount->45 Milliliter,
					Label->"sample"
				],
				FlashChromatography[
					Sample->"sample",
					SamplesOutStorageCondition->Disposal
				]
			}];
			Download[protocol,CalculatedUnitOperations[[2]][SamplesOutStorageCondition]],
			{Disposal},
			Variables:>{protocol}
		]
	},
	SymbolSetUp:>{
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False]
	}
];

(* ::Subsection:: *)
(*ExperimentFlashChromatographyOptions*)

DefineTests[
	ExperimentFlashChromatographyOptions,
	{
		Example[{Basic,"Generate a table of resolved options for an ExperimentFlashChromatography call to separate a labeled sample:"},
			ExperimentFlashChromatographyOptions[
				"sample",
				PreparatoryUnitOperations->{
					LabelSample[
						Sample->Model[Sample,"Milli-Q water"],
						Amount->45 Milliliter,
						Label->"sample"
					]
				}
			],
			_Grid
		],
		Example[{Basic,"Generate a table of resolved options for an ExperimentFlashChromatography call to separate a sample from a labeled container:"},
			ExperimentFlashChromatographyOptions[
				"container",
				PreparatoryUnitOperations->{
					LabelContainer[
						Container->Model[Container,Vessel,"50mL Tube"],
						Label->"container"
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Amount->45 Milliliter,
						Destination->"container"
					]
				}
			],
			_Grid
		],
		Example[{Basic,"Generate a table of resolved options for an ExperimentFlashChromatography call to separate a labeled sample and a sample from a labeled container:"},
			ExperimentFlashChromatographyOptions[
				{"sample","container"},
				PreparatoryUnitOperations->{
					LabelSample[
						Sample->Model[Sample,"Milli-Q water"],
						Amount->20 Milliliter,
						Label->"sample"
					],
					LabelContainer[
						Container->Model[Container,Vessel,"50mL Tube"],
						Label->"container"
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Amount->45 Milliliter,
						Destination->"container"
					]
				}
			],
			_Grid
		],
		Example[{Options,OutputFormat,"Generate a resolved list of options for an ExperimentFlashChromatography call to separate a labeled sample:"},
			ExperimentFlashChromatographyOptions[
				"sample",
				PreparatoryUnitOperations->{
					LabelSample[
						Sample->Model[Sample,"Milli-Q water"],
						Amount->45 Milliliter,
						Label->"sample"
					]
				},
				OutputFormat->List
			],
			_?(MatchQ[
				Check[SafeOptions[ExperimentFlashChromatography,#],$Failed,{Error::Pattern}],
				{(_Rule|_RuleDelayed)..}
			]&)
		]
	},
	SymbolSetUp:>{
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False]
	}
];

(* ::Subsection:: *)
(*ExperimentFlashChromatographyPreview*)

DefineTests[
	ExperimentFlashChromatographyPreview,
	{
		Example[{Basic,"Generate a preview for an ExperimentFlashChromatography call to separate a labeled sample (will always be Null):"},
			ExperimentFlashChromatographyPreview[
				"sample",
				PreparatoryUnitOperations->{
					LabelSample[
						Sample->Model[Sample,"Milli-Q water"],
						Amount->45 Milliliter,
						Label->"sample"
					]
				}
			],
			Null
		],
		Example[{Basic,"Generate a preview for an ExperimentFlashChromatography call to separate a sample from a labeled container (will always be Null):"},
			ExperimentFlashChromatographyPreview[
				"container",
				PreparatoryUnitOperations->{
					LabelContainer[
						Container->Model[Container,Vessel,"50mL Tube"],
						Label->"container"
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Amount->45 Milliliter,
						Destination->"container"
					]
				}
			],
			Null
		],
		Example[{Basic,"Generate a preview for an ExperimentFlashChromatography call to separate a labeled sample and a sample from a labeled container (will always be Null):"},
			ExperimentFlashChromatographyPreview[
				{"sample","container"},
				PreparatoryUnitOperations->{
					LabelSample[
						Sample->Model[Sample,"Milli-Q water"],
						Amount->20 Milliliter,
						Label->"sample"
					],
					LabelContainer[
						Container->Model[Container,Vessel,"50mL Tube"],
						Label->"container"
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Amount->45 Milliliter,
						Destination->"container"
					]
				}
			],
			Null
		]
	},
	SymbolSetUp:>{
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False]
	}
];


(* ::Subsection:: *)
(*ValidExperimentFlashChromatographyQ*)

DefineTests[
	ValidExperimentFlashChromatographyQ,
	{
		Example[{Basic,"Validate an ExperimentFlashChromatography call to separate a labeled sample:"},
			ValidExperimentFlashChromatographyQ[
				"sample",
				PreparatoryUnitOperations->{
					LabelSample[
						Sample->Model[Sample,"Milli-Q water"],
						Amount->45 Milliliter,
						Label->"sample"
					]
				}
			],
			True
		],
		Example[{Basic,"Validate an ExperimentFlashChromatography call to separate a sample from a labeled container:"},
			ValidExperimentFlashChromatographyQ[
				"container",
				PreparatoryUnitOperations->{
					LabelContainer[
						Container->Model[Container,Vessel,"50mL Tube"],
						Label->"container"
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Amount->45 Milliliter,
						Destination->"container"
					]
				}
			],
			True
		],
		Example[{Basic,"Validate an ExperimentFlashChromatography call to separate a labeled sample and a sample from a labeled container:"},
			ValidExperimentFlashChromatographyQ[
				{"sample","container"},
				PreparatoryUnitOperations->{
					LabelSample[
						Sample->Model[Sample,"Milli-Q water"],
						Amount->20 Milliliter,
						Label->"sample"
					],
					LabelContainer[
						Container->Model[Container,Vessel,"50mL Tube"],
						Label->"container"
					],
					Transfer[
						Source->Model[Sample,"Milli-Q water"],
						Amount->45 Milliliter,
						Destination->"container"
					]
				}
			],
			True
		],
		Example[{Options,OutputFormat,"Validate an ExperimentFlashChromatography call to separate a labeled sample, returning an ECL Test Summary:"},
			ValidExperimentFlashChromatographyQ[
				"sample",
				PreparatoryUnitOperations->{
					LabelSample[
						Sample->Model[Sample,"Milli-Q water"],
						Amount->45 Milliliter,
						Label->"sample"
					]
				},
				OutputFormat->TestSummary
			],
			_EmeraldTestSummary
		],
		Example[{Options,Verbose,"Validate an ExperimentFlashChromatography call to separate a labeled sample, printing a verbose summary of tests as they are run:"},
			ValidExperimentFlashChromatographyQ[
				"sample",
				PreparatoryUnitOperations->{
					LabelSample[
						Sample->Model[Sample,"Milli-Q water"],
						Amount->45 Milliliter,
						Label->"sample"
					]
				},
				Verbose->True
			],
			True
		]
	},
	SymbolSetUp:>{
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		$CreatedObjects={};
	},
	SymbolTearDown:>{
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		EraseObject[$CreatedObjects,Force->True,Verbose->False]
	}
];



