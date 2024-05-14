(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*ExperimentMassSpectrometry: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*ExperimentMassSpectrometry*)


DefineTests[
	ExperimentMassSpectrometry,
	{
		Example[{Basic,"Generates a protocol used to measure the molecular weights of compounds within the input samples using ESI-QTOF mass spectrometry:"},
			ExperimentMassSpectrometry[{Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				IonSource->ESI,MassAnalyzer->QTOF
			],
			ObjectP[Object[Protocol,MassSpectrometry]]
		],
		Example[{Basic,"Generates a protocol used to measure the molecular weights of compounds within the input samples using MALDI mass spectrometry:"},
			ExperimentMassSpectrometry[{Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				IonSource->MALDI
			],
			ObjectP[Object[Protocol,MassSpectrometry]]
		],
		Example[{Basic,"Generates a protocol used to measure the molecular weights of compounds within the input samples using ESI-QQQ mass spectrometry:"},
			ExperimentMassSpectrometry[{Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				IonSource->ESI,MassAnalyzer->TripleQuadrupole
			],
			ObjectP[Object[Protocol,MassSpectrometry]]
		],
		Example[{Basic, "Output a list of tests using ESI-QQQ mass spectrometry:"},
			ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]}, IonSource -> ESI,
				MassAnalyzer -> TripleQuadrupole, Output -> Tests],
			{__EmeraldTest}
		],
		Example[{Basic,"Provide options to indicate how the experiment should be performed:"},
			ExperimentMassSpectrometry[
				{Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				IonMode->Positive,
				IonSource->MALDI,
				MassDetection->Span[4000 Dalton,10000 Dalton]
			],
			ObjectP[Object[Protocol,MassSpectrometry]]
		],
		Example[{Additional,"Indicate that measurements should be performed for all samples in a plate:"},
			ExperimentMassSpectrometry[Object[Container, Plate, "Test Plate for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI],
			ObjectP[Object[Protocol,MassSpectrometry]]
		],
		Example[{Additional,"Generates a protocol used to measure the molecular weights of compounds within the input containing mixed samples using ESI-QTOF mass spectrometry:"},
			ExperimentMassSpectrometry[{Object[Sample,"Oligomer Mix Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				IonSource->ESI,InjectionType->FlowInjection],
			ObjectP[Object[Protocol,MassSpectrometry]]
		],
		Example[{Additional,"Generates a protocol used to measure the molecular weights of compounds within the input containing mixed samples using MALDI mass spectrometry:"},
			ExperimentMassSpectrometry[{Object[Sample,"Oligomer Mix Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				IonSource->MALDI],
			ObjectP[Object[Protocol,MassSpectrometry]]
		],
		Example[{Additional,"If no ion source specific options or the instrument option are provided, defaults to ESI-QTOF mass spectrometry:"},
			Lookup[ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Output->Options],{IonSource,Instrument}],
			{ESI,ObjectReferenceP[Model[Instrument,MassSpectrometer,"Xevo G2-XS QTOF"]]},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Additional,"If no ion source specific options or the instrument option are provided, but any of tandem mass options is specified, default to ESI-QQQ:"},
			Lookup[ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],FragmentMassDetection->666*Gram/Mole,Output->Options],{IonSource,Instrument}],
			{ESI,ObjectReferenceP[Model[Instrument,MassSpectrometer,"QTRAP 6500"]]}
		],
		Example[{Additional,"Sample Preparation", "Indicate that the samples should be prepped before beginning the experiment. Here 50mL will be taken from the source sample and mixed at room temperature for 30 minute. This 50mL aliquot will then be centrifuge and filtered.	Finally a 1mL aliquot will be taken from the filtered sample and used in the experiment. Sample Preparation will always occur in this order (incubating/mixing, centrifuging, filtering, aliquoting):"},
			ExperimentMassSpectrometry[
				Object[Sample,"Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Incubate -> True,
				Mix -> True,
				IncubateAliquotContainer -> Model[Container, Vessel, "50mL Tube"],
				IncubateAliquot -> 50 Milliliter,
				Centrifuge -> True,
				Filtration -> True,
				Aliquot -> True,
				AssayVolume -> 1.15 Milliliter,
				AliquotAmount -> 500 Microliter,
				AssayBuffer -> Model[Sample, "Milli-Q water"]
			],
			ObjectP[Object[Protocol,MassSpectrometry]],
			TimeConstraint -> 240
		],
		Example[{Additional,"Sample Preparation", "If you wish to gather multiple mass spectra for the same sample, but only want to incubate it once, set Incubate to False for subsequent appearances of the sample in your input list:"},
			ExperimentMassSpectrometry[
				{Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				Incubate -> {True,False,False}
			],
			ObjectP[Object[Protocol,MassSpectrometry]],
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Additional,"Sample Preparation","Prepare an aliquot containing 250uL of the input sample and 750uL of water. This aliquot will then be used to spot the MALDI plate:"},
			ExperimentMassSpectrometry[
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
			IonSource->MALDI,
				AssayVolume -> 1.1 Milliliter,
				AliquotAmount -> 250 Microliter,
				AssayBuffer -> Model[Sample, "Milli-Q water"]
			],
			ObjectP[Object[Protocol,MassSpectrometry]]
		],
		Example[{Additional,"Required Resources","For ESI-QQQ, generate all required resources for a flow injection protocol:"},
			Module[{
				protocol, resources, resourceFields, allResourcesMade
			},
				protocol = ExperimentMassSpectrometry[
					{
						Object[Sample, "Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
						Object[Sample, "Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
						Object[Sample, "Oligomer 3 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
					},
					IonSource -> ESI,
					InjectionType->FlowInjection,
					MassAnalyzer -> TripleQuadrupole
				];
				resources = Download[protocol, RequiredResources];
				resourceFields = DeleteDuplicates[resources[[All, 2]]]/.Null->Nothing;

				(*Check all resources*)
				allResourcesMade = ContainsExactly[
					resourceFields, {SamplesIn, ContainersIn, Instrument, UniqueCalibrants,
						CalibrantInfusionSyringes, CalibrantInfusionSyringeNeedles, Buffer,
						NeedleWashSolution, SystemPrimeBuffer, SystemPrimeBufferPlacements,
						SystemFlushBuffer, SystemFlushContainerPlacements,
						NeedleWashPlacements, SystemPrimeFlushPlate, PlateSeal,
						TubingRinseSolution, Checkpoints}
				]
			],
			True
		],
		Example[{Additional,"Required Resources","For ESI-QQQ, generate all required resources for a direct infusion protocol:"},
			Module[{
				protocol, resources, resourceFields, allResourcesMade
			},
				protocol = ExperimentMassSpectrometry[
					{
						Object[Sample, "Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
						Object[Sample, "Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
						Object[Sample, "Oligomer 3 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
					},
					IonSource -> ESI,
					InjectionType->DirectInfusion,
					MassAnalyzer -> TripleQuadrupole
				];
				resources = Download[protocol, RequiredResources];
				resourceFields = DeleteDuplicates[resources[[All, 2]]]/.Null->Nothing;

				(*Check all resources*)
				allResourcesMade = ContainsExactly[
					resourceFields, {SamplesIn, ContainersIn, Instrument, UniqueCalibrants,
						CalibrantInfusionSyringes, CalibrantInfusionSyringeNeedles,
						InfusionSyringes, InfusionSyringeNeedles, Checkpoints}
				]
			],
			True
		],
		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples for ExperimentMassSpectrometry:"},
			Download[ExperimentMassSpectrometry["My Pooled Sample",
				PreparatoryUnitOperations-> {
					LabelContainer[
						Label -> "My Pooled Sample",
						Container -> Model[Container, Vessel, "Narrow Mouth Plastic Reservoir Bottle, 30mL, for Xevo G2-XS QTOF"]
					],
					Transfer[
						Source -> {
							Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
							Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
						},
						Destination -> "My Pooled Sample",
						Amount -> {3000 Microliter, 2600 Microliter}
					]
				},
				IonSource-> ESI
			],PreparatoryUnitOperations],
			{SamplePreparationP..}
		],

		Example[{Options,PreparatoryUnitOperations,"Specify prepared samples for ExperimentMassSpectrometry in ESI-QQQ:"},
			Download[ExperimentMassSpectrometry["My Pooled Sample",
				PreparatoryUnitOperations-> {
					LabelContainer[
						Label -> "My Pooled Sample",
						Container -> Model[Container, Vessel, "Narrow Mouth Plastic Reservoir Bottle, 30mL, for Xevo G2-XS QTOF"]
					],
					Transfer[
						Source -> {
							Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
							Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
						},
						Destination -> "My Pooled Sample",
						Amount -> {2000 Microliter, 1000 Microliter}
					]
				},
				IonSource-> ESI,
				MassAnalyzer->TripleQuadrupole
			],PreparatoryUnitOperations],
			{SamplePreparationP..}
		],

		Example[{Options,PreparatoryPrimitives,"Specify prepared samples for ExperimentMassSpectrometry:"},
			Download[ExperimentMassSpectrometry["My Pooled Sample",
				PreparatoryPrimitives-> {
					Define[
						Name -> "My Pooled Sample",
						Container -> Model[Container, Vessel, "Narrow Mouth Plastic Reservoir Bottle, 30mL, for Xevo G2-XS QTOF"]
					],
					Consolidation[
						Sources -> {
							Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
							Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
						},
						Destination -> "My Pooled Sample",
						Amounts -> {3000 Microliter, 2600 Microliter}
					]
				},
				IonSource-> ESI
			],PreparatoryPrimitives],
			{_Define,_Consolidation}
		],

		Example[{Options,PreparatoryPrimitives,"Specify prepared samples for ExperimentMassSpectrometry in ESI-QQQ:"},
			Download[ExperimentMassSpectrometry["My Pooled Sample",
				PreparatoryPrimitives-> {
					Define[
						Name -> "My Pooled Sample",
						Container -> Model[Container, Vessel, "Narrow Mouth Plastic Reservoir Bottle, 30mL, for Xevo G2-XS QTOF"]
					],
					Consolidation[
						Sources -> {
							Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
							Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
						},
						Destination -> "My Pooled Sample",
						Amounts -> {2000 Microliter, 1000 Microliter}
					]
				},
				IonSource-> ESI,
				MassAnalyzer->TripleQuadrupole
			],{PreparedSamples,PreparatoryPrimitives}],
			{
				{{"My Pooled Sample", SamplesIn,1,Null,"A1"},{"My Pooled Sample", ContainersIn,1,Null,Null}},
				{_Define,_Consolidation}
			}
		],

		(* == SHARED OPTIONS == *)

		Example[{Options,Confirm,"Indicate that the protocol should be moved directly into the queue:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Confirm->True],
				Status
			],
			Processing|ShippingMaterials|Backlogged
		],
		Example[{Options,Template,"Indicate that all the same options used for a previous protocol should be used again for the current protocol:"},
			Module[{templateMassSpecProtocol,repeatProtocol},
			(* Create an initial protocol *)
				templateMassSpecProtocol=ExperimentMassSpectrometry[Object[Sample,"Missing Molecular Weight Sample for ExperimentMassSpectrometry"<>$SessionUUID],SpottingMethod->Sandwich];

				(* Create another protocol which will exactly repeat the first *)
				repeatProtocol=ExperimentMassSpectrometry[Object[Sample,"Missing Molecular Weight Sample for ExperimentMassSpectrometry"<>$SessionUUID],Template->templateMassSpecProtocol];

				Download[
					{templateMassSpecProtocol,repeatProtocol},
					{SpottingMethods,SpottingPattern,MinMasses,MaxMasses}
				]
			],
			{
				{{Sandwich},All,{1500.` Gram/Mole},{2500.` Gram/Mole}},
				{{Sandwich},All,{1500.` Gram/Mole},{2500.` Gram/Mole}}
			},
			Messages:>{Warning::UnknownMolecularWeight},
			TimeConstraint -> 200
		],
		Example[{Options,Name,"Give the protocol to be created a unique identifier which can be used instead of its ID:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Name->"Purification QA"<>$SessionUUID],
				Name
			],
			"Purification QA"<>$SessionUUID,
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,NumberOfReplicates,"Indicate each input sample should each be spotted onto 3 different MALDI plate wells:"},
			Download[
				ExperimentMassSpectrometry[
					{Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
					NumberOfReplicates->3,
					AccelerationVoltage->{20 Kilovolt,19.7 Kilovolt}
				],
				{SamplesIn[Object],AccelerationVoltages}
			],
			{
				Join[
					ConstantArray[ObjectP[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID]],3],
					ConstantArray[ObjectP[Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]],3]
				],
				Join[
					ConstantArray[20.` Kilovolt,3],
					ConstantArray[19.7` Kilovolt,3]
				]
			}
		],


		(* == SHARED OPTIONS between MALDI and ESI == *)

		Example[{Options,IonMode,"Indicate that the mass spectrometer should be run in negative ion mode for the current sample:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonMode->Negative,IonSource->MALDI],
				IonModes
			],
			{Negative}
		],
		Example[{Options,IonMode,"For ESI mass spectrometry experiments, if ion mode is not provided, it is automatically set to Positive for DNA and Peptide samples:"},
			Lookup[
				ExperimentMassSpectrometry[{
					Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Object[Sample,"Peptide Sample for ExperimentMassSpectrometry"<>$SessionUUID]
				},
					IonMode->Automatic,
					Output->Options
				],
				IonMode
			],
			Positive,
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,IonMode,"For ESI mass spectrometry experiments, if ion mode is not provided, it is automatically set to Negative for acid samples (acids have the propensity to loose protons in solution, forming negative ions):"},
			Lookup[
				ExperimentMassSpectrometry[Object[Sample,"Small acid Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					IonMode->Automatic,
					Output->Options
				],
				IonMode
			],
			Negative,
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,IonSource,"Indicate the ionization type that should be used to ionize the samples for mass spectrometry measurements:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI],
				IonSource
			],
			MALDI
		],
		Example[{Options,Instrument,"Indicate the specific mass spectrometer to use:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Instrument->Object[Instrument, MassSpectrometer, "Unit Test Instrument For ExperimentMassSpectrometry"<>$SessionUUID]],
				Instrument
			],
			ObjectP[Object[Instrument, MassSpectrometer, "Unit Test Instrument For ExperimentMassSpectrometry"<>$SessionUUID]]
		],
		Example[{Options,Instrument,"If the ion source is specified, the instrument will be set accordingly:"},
			Lookup[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					IonSource->MALDI,
					Output->Options
				],
				{IonSource,Instrument}],
			{MALDI,ObjectReferenceP[Model[Instrument, MassSpectrometer, "Microflex LRF"]]}
		],
		Example[{Options,Instrument,"If the instrument is specified, the ion source will be set accordingly:"},
			Lookup[ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Instrument -> Model[Instrument, MassSpectrometer, "Microflex LRF"],Output->Options],
				{IonSource,Instrument}],
			{MALDI,ObjectReferenceP[Model[Instrument, MassSpectrometer, "Microflex LRF"]]}
		],
		Example[{Options,IonSource,"If neither ion source nor instrument is specified, ion source and instrument default to ESI mass spectrometry:"},
			Lookup[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Instrument -> Automatic, IonSource -> Automatic,Output->Options],
				{IonSource,Instrument}],
			{ESI,ObjectReferenceP[Model[Instrument, MassSpectrometer, "Xevo G2-XS QTOF"]]}
		],
		Example[{Options,IonSource,"If neither the instrument nor the ion source is specified, but one or more MALDI specific option value is supplied, the ion source and instrument will be set accordingly:"},
			Lookup[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Instrument -> Automatic,
					IonSource -> Automatic,
					LensVoltage->5*Kilovolt, (* this is a MALDI specific option *)
					Output->Options
				],
				{IonSource,Instrument}],
			{MALDI,ObjectReferenceP[Model[Instrument, MassSpectrometer, "Microflex LRF"]]}
		],
		Example[{Options,Instrument,"If neither the instrument nor the ion source is specified, but one or more ESI specific option value is supplied, the ion source and instrument will be set accordingly:"},
			Lookup[
				ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Instrument -> Automatic,
					IonSource -> Automatic,
					SourceTemperature->50*Celsius, (* this is ESI specific Option *)
					Output->Options
				],
				{IonSource,Instrument}],
			{ESI,ObjectReferenceP[Model[Instrument, MassSpectrometer, "Xevo G2-XS QTOF"]]}
		],
		Example[{Options,IonSource,"If neither the instrument nor the ion source is specified, and values are provided for both MALDI and ESI specific option, the majority count will determine the desired ion source and the instrument (here GridVoltage and LensVoltage are MALDI, while SourceTemperature is ESI specific):"},
			Lookup[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Instrument -> Automatic,
					IonSource -> Automatic,
					LensVoltage->5*Kilovolt, (* Maldi *)
					GridVoltage->10*Kilovolt, (* Maldi *)
					SourceTemperature->50*Celsius, (* this is the only ESI specific Option *)
					Output->Options
				],
				{IonSource,Instrument}],
			{MALDI,ObjectReferenceP[Model[Instrument, MassSpectrometer, "Microflex LRF"]]},
			Messages:>{Error::UnneededOptions,Error::InvalidOption}
		],
		Test["If neither the instrument nor the ion source is specified, and equal number of options are provided for both MALDI and ESI, source and instrument will be set to ESI mass spectrometry (while an error is being thrown):",
			Lookup[
				ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Instrument -> Automatic,
					IonSource -> Automatic,
					LensVoltage->5*Kilovolt, (* this is MALDI specific Option *)
					GridVoltage->10*Kilovolt,(* this is MALDI specific Option *)
					SourceTemperature->50*Celsius,(* this is ESI specific Option *)
					DesolvationTemperature->50* Celsius,(* this is ESI specific Option *)
					Output->Options
				],
				{IonSource,Instrument}],
			{ESI,ObjectReferenceP[Model[Instrument, MassSpectrometer, "Xevo G2-XS QTOF"]]},
			Messages:>{Error::UnneededOptions,Error::InvalidOption}
		],
		Example[{Options,Instrument,"If IonSource is set or resolved to ESI, no ESI specific options can be set to Null (while MALDI specific options can):"},
			Lookup[
				ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Instrument -> Automatic,
					IonSource -> Automatic,
					SourceTemperature->Null, (* this is ESI specific Option *)
					GridVoltage->Null,
					Output->Options
				],
				{IonSource,Instrument}],
			{ESI,ObjectReferenceP[Model[Instrument, MassSpectrometer, "Xevo G2-XS QTOF"]]},
			Messages:>{Error::MassSpecRequiredOptions,Error::InvalidOption}
		],
		Example[{Options,Calibrant,"Specify the model you'd like to use to calibrate the mass spectrometer:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Calibrant->Model[Sample,StockSolution,Standard,"Peptide/Protein Calibrant Mix"],
					IonSource->MALDI
				],
				Calibrants
			],
			{ObjectP[Model[Sample,StockSolution,Standard,"Peptide/Protein Calibrant Mix"]]}
		],
		Example[{Options,Calibrant,"For ESI-QTOF mass spectrometry measurements, if Calibrant is not specified, sodium formate is used for calibrating small molecules (below 1200 Dalton), sodium iodide is used for peptides, and cesium iodide is used for intact proteins (above 3500 Dalton):"},
			Lookup[
				ExperimentMassSpectrometry[{
					Object[Sample,"775 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Object[Sample,"Peptide Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Object[Sample,"Protein Sample for ExperimentMassSpectrometry"<>$SessionUUID]
				},
					Calibrant->Automatic,
					IonSource->ESI,
					Output->Options
				],
				Calibrant
			],
			{
				ObjectP[Model[Sample,StockSolution,Standard,"Sodium Formate ESI Calibrant"]],
				ObjectP[Model[Sample,StockSolution,Standard,"Sodium Iodide ESI Calibrant"]],
				ObjectP[Model[Sample,StockSolution,Standard,"Cesium Iodide ESI Calibrant"]]
			},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,Analytes,"The analytes are extracted from the sample's composition if not informed:"},
			Lookup[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 4 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					IonSource->MALDI,
					Analytes->Automatic,
					Output->Options
				],
				Analytes
			],
			{ObjectP[Model[Molecule, Oligomer, "Test Oligo1 Identity Model"<>$SessionUUID]]}
		],
		Example[{Options,Analytes,"Use the option Analytes to indicate which components to measure in the experiment:"},
			Lookup[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 4 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					IonSource->MALDI,
					Analytes->{Model[Molecule, Oligomer, "Test Oligo1 Identity Model"<>$SessionUUID]},
					Output->Options
				],
				Analytes
			],
			{ObjectP[Model[Molecule, Oligomer, "Test Oligo1 Identity Model"<>$SessionUUID]]}
		],

		Example[{Options,MassDetection,"In ESI-QTOF mass spectrometry measurements, if left unspecified the mass range automatically resolves to low, mid, or large molecular weight range depending on the molecular weight and sample category of the compound:"},
			Lookup[
				ExperimentMassSpectrometry[{
					Object[Sample,"775 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Object[Sample,"Peptide Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Object[Sample,"Protein Sample for ExperimentMassSpectrometry"<>$SessionUUID]
				},
					MassDetection->Automatic,
					IonSource->ESI,
					Output->Options
				],
				MassDetection
			],
			{100 Dalton;;1200 Dalton,350 Dalton;;2000 Dalton,400 Dalton;;5000 Dalton},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,MassDetection,"In MALDI mass spectrometry measurements, if left unspecified the mass range automatically resolves such that the min and max mass flank the sample molecular weight and the range includes 3 calibrant peaks:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					IonSource->MALDI
				],
				{MinMasses,MaxMasses}
			],
			{{5500 Dalton},{8750 Dalton}},
			EquivalenceFunction->Equal
		],
		Example[{Options,MassDetection,"In MALDI mass spectrometry measurements, if the molecular weight is unknown, the mass range will be selected to flank the 3 center calibrant peaks:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Missing Molecular Weight Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					IonSource->MALDI
				],
				{MinMasses,MaxMasses}
			],
			{{1500 Gram/Mole},{2500 Gram/Mole}},
			Messages:>{Warning::UnknownMolecularWeight},
			EquivalenceFunction->Equal
		],


		(* == ESI OPTIONS == *)
		Example[{Options,ESICapillaryVoltage,"Indicate the capillary voltage which should be used to accelerate ions from the ESI source into the mass spectrometer:"},
			Download[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				ESICapillaryVoltage->2.5*Kilovolt],
				ESICapillaryVoltages],
			{2500.`*Volt},
			EquivalenceFunction->Equal
		],
		Example[{Options,ESICapillaryVoltage,"For low flow applications in ESI mass spectrometry, if the capillary voltage is not specified, a slightly lower capillary voltage is required for negative ion mode:"},
			Lookup[ExperimentMassSpectrometry[{Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Object[Sample,"Oligomer 5 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				ESICapillaryVoltage->Automatic,
				IonMode->{Positive,Negative},
				InfusionFlowRate->10 Microliter/Minute,
				Output->Options
				],
				ESICapillaryVoltage],
			{3*Kilovolt, 2.8 Kilovolt},
			EquivalenceFunction->Equal,
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,ESICapillaryVoltage,"In ESI mass spectrometry, if the capillary voltage is not specified, it is automatically set according to the flow rate:"},
			Lookup[ExperimentMassSpectrometry[{
				Object[Sample,"Oligomer 4 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 5 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				ESICapillaryVoltage->Automatic,
				IonMode->Positive,
				InfusionFlowRate->{10 Microliter/Minute,50 Microliter/Minute,200 Microliter/Minute,400 Microliter/Minute},
				Output->Options
			],
				ESICapillaryVoltage],
			{3*Kilovolt, 2.5 Kilovolt, 2*Kilovolt,1.5 Kilovolt},
			EquivalenceFunction->Equal,
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,StepwaveVoltage,"Indicate the sample cone voltage which should be used to accelerate ions from the ESI source into the mass spectrometer:"},
             			Download[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
							StepwaveVoltage->65*Volt],
							StepwaveVoltages],
			{65*Volt},
			EquivalenceFunction->Equal
		],
		Example[{Options,StepwaveVoltage,"In ESI-QTOF mass spectrometry measurements, if the sample cone voltage is not specified,	it is automatically resolved according to the sample type and molecular weight of the compound:"},
			Download[ExperimentMassSpectrometry[{
				Object[Sample,"Peptide Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample, "Protein Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				StepwaveVoltage->Automatic],
				StepwaveVoltages],
			{40 Volt,100 Volt,120 Volt,120 Volt},
			EquivalenceFunction->Equal,
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,DeclusteringVoltage,"Indicate the voltage offset which should be used to accelerate ions from the ESI source into the mass spectrometer:"},
			Download[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				DeclusteringVoltage->55*Volt],
				DeclusteringVoltages],
			{55*Volt},
			EquivalenceFunction->Equal
		],
		Example[{Options,DeclusteringVoltage,"In ESI-QTOF mass spectrometry measurements, if the Declustering Voltage is not specified, it is automatically set to 40 Volt:"},
			Download[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				DeclusteringVoltage->Automatic,IonSource->ESI],
				DeclusteringVoltages],
			{40*Volt},
			EquivalenceFunction->Equal
		],
		Example[{Options,SourceTemperature,"Indicate the temperature to which the ESI source block should be heated to facilitate desolvation of ions:"},
			Download[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				SourceTemperature->100*Celsius],
				SourceTemperatures],
			{100*Celsius},
			EquivalenceFunction->Equal
		],
		Example[{Options,SourceTemperature,"In ESI mass spectrometry, if the source temperature is not specified, it is automatically set according to the flow rate:"},
			Lookup[ExperimentMassSpectrometry[{
				Object[Sample,"Oligomer 4 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 5 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				SourceTemperature->Automatic,
				IonMode->Positive,
				InfusionFlowRate->{10 Microliter/Minute,50 Microliter/Minute,200 Microliter/Minute,400 Microliter/Minute},
				Output->Options
			],
				SourceTemperature],
			{100 Celsius,120 Celsius,120 Celsius,150 Celsius},
			EquivalenceFunction->Equal,
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,DesolvationTemperature,"Indicate the temperature to which the desolvation unit should be heated to facilitate desolvation of ions:"},
			Download[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				DesolvationTemperature->150*Celsius],
				DesolvationTemperatures],
			{150*Celsius},
			EquivalenceFunction->Equal
		],
		Example[{Options,DesolvationTemperature,"In ESI mass spectrometry, if the desolvation temperature is not specified, it is automatically set according to the flow rate:"},
			Lookup[ExperimentMassSpectrometry[{
				Object[Sample,"Oligomer 4 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 5 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				DesolvationTemperature->Automatic,
				IonMode->Positive,
				InfusionFlowRate->{10 Microliter/Minute,50 Microliter/Minute,200 Microliter/Minute,400 Microliter/Minute},
				Output->Options
			],
				DesolvationTemperature],
			{200 Celsius,350 Celsius,450 Celsius,500 Celsius},
			EquivalenceFunction->Equal,
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,DesolvationGasFlow,"Indicate the nitrogen gas flow around the desolvation unit that should be used to facilitate desolvation of ions:"},
			Download[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				DesolvationGasFlow->500 Liter/Hour],
				DesolvationGasFlows],
			{500 Liter/Hour},
			EquivalenceFunction->Equal
		],
		Example[{Options,DesolvationGasFlow,"In ESI mass spectrometry, if the desolvation gas flow is not specified, it is automatically set according to the flow rate:"},
			Lookup[ExperimentMassSpectrometry[{
				Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				DesolvationGasFlow->Automatic,
				IonMode->Positive,
				InfusionFlowRate->{10 Microliter/Minute,50 Microliter/Minute,200 Microliter/Minute,400 Microliter/Minute},
				Output->Options
			],
				DesolvationGasFlow],
			{600 Liter/Hour,800 Liter/Hour,800 Liter/Hour,1000 Liter/Hour},
			EquivalenceFunction->Equal
		],
		Example[{Options,ConeGasFlow,"Indicate the nitrogen gas flow around the sampling cone that should be used to facilitate desolvation of ions:"},
			Download[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				ConeGasFlow->100 Liter/Hour],
				ConeGasFlows],
			{100 Liter/Hour},
			EquivalenceFunction->Equal
		],
		Example[{Options,ConeGasFlow,"In ESI-QTOF mass spectrometry measurements, if the nitrogen gas flow around the sampling cone is not specified, is set to 50 Liter/Hour:"},
			Download[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				ConeGasFlow->Automatic],
				ConeGasFlows],
			{50 Liter/Hour},
			EquivalenceFunction->Equal
		],
		Example[{Options,InfusionFlowRate,"Indicate at which flow rate the sample should be infused into the mass spectrometer:"},
			Lookup[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				InfusionFlowRate->25 Microliter/Minute,Output->Options],
				InfusionFlowRate],
			25 Microliter/Minute,
			EquivalenceFunction->Equal
		],
		Example[{Options,InfusionFlowRate,"In ESI-QTOF mass spectrometry measurements, if the infusion flow rate is not specified, it is automatically set to 20 Microliter/Minute:"},
			Lookup[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				InfusionFlowRate->Automatic,Output->Options],
				InfusionFlowRate],
			20 Microliter/Minute,
			EquivalenceFunction->Equal
		],
		Example[{Options,ScanTime,"Indicate the time that should pass between the acquisition of each spectra:"},
			Download[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				ScanTime-> 1*Second],
				ScanTimes],
			{1*Second},
			EquivalenceFunction->Equal
		],
		Example[{Options,ScanTime,"In ESI-QTOF mass spectrometry measurements, if the scan time is not specified, it is automatically set to 1 Second (1 Hz):"},
			Download[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				ScanTime->Automatic],
				ScanTimes],
			{1 Second},
			EquivalenceFunction->Equal
		],
		Example[{Options,RunDuration,"Indicate the total time that the sample should be infused and get measurements taken:"},
			Download[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				RunDuration-> 30*Second],
				RunDurations],
			{30*Second},
			EquivalenceFunction->Equal
		],
		Example[{Options,RunDuration,"In ESI-QTOF mass spectrometry measurements, if the run duration is not specified, it is automatically set to 1 Minute:"},
			Download[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				RunDuration->Automatic],
				RunDurations],
			{1*Minute},
			EquivalenceFunction->Equal
		],
		Example[{Options,SampleTemperature,"In ESI-QTOF mass spectrometry measurements, indicate the temperature that samples should be kept in the autosampler before injection (when doing flow injection mass spectrometry):"},
			Download[ExperimentMassSpectrometry[Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				InjectionType->FlowInjection,
				SampleTemperature->15*Celsius],
				SampleTemperature
			],
				15*Celsius,
			EquivalenceFunction->Equal
		],
		Example[{Options,Buffer,"Indicate the buffer that should be used as mobile phase to carry the sample from the autosampler to the ion source before injection into the mass spectrometer (when doing flow injection mass spectrometry):"},
			Download[ExperimentMassSpectrometry[Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				InjectionType->FlowInjection,
				Buffer->Model[Sample,"Methanol - LCMS grade"]],
				Buffer
			],
			ObjectP[Model[Sample,"Methanol - LCMS grade"]]
		],
		Example[{Options,Buffer,"In ESI-QTOF mass spectrometry measurements, when doing flow injection mass spectrometry, Buffer is automatically set to Model[Sample,StockSolution,\"0.1% FA with 5% Acetonitrile in Water, LCMS-grade\"]:"},
			Download[ExperimentMassSpectrometry[Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				InjectionType->FlowInjection,
				Buffer->Automatic],
				Buffer
			],
			ObjectP[Model[Sample, StockSolution, "0.1% FA with 5% Acetonitrile in Water, LCMS-grade"]
			]
		],
		Example[{Options,NeedleWashSolution,"In ESI-QTOF mass spectrometry measurements, when doing flow injection mass spectrometry, NeedleWashSolution is automatically set to Model[Sample,StockSolution,\"20% Methanol in MilliQ Water\"]:"},
			Download[ExperimentMassSpectrometry[Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				InjectionType->FlowInjection,
				NeedleWashSolution->Automatic],
				NeedleWashSolution
			],
			ObjectP[Model[Sample,StockSolution,"20% Methanol in MilliQ Water"]]
		],
		Example[{Options,NeedleWashSolution,"In ESI-QTOF mass spectrometry measurements, indicate the solution that should be used to wash the needle after injecting the sample (when doing flow injection mass spectrometry):"},
			Download[ExperimentMassSpectrometry[Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				InjectionType->FlowInjection,
				NeedleWashSolution->Model[Sample,"Methanol - LCMS grade"]],
				NeedleWashSolution
			],
			ObjectP[Model[Sample,"Methanol - LCMS grade"]]
		],
		Example[{Options,InjectionVolume,"In ESI-QTOF mass spectrometry measurements, indicate how much volume should be picked up by the needle from the sample and injected into the mass spectrometer (when doing flow injection mass spectrometry):"},
			Download[ExperimentMassSpectrometry[{Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				InjectionType->FlowInjection,
				InjectionVolume->{7.5*Microliter,8.5*Microliter}],
				SampleVolumes
			],
			{7.5*Microliter,8.5*Microliter},
			EquivalenceFunction->Equal
		],
		Example[{Options,InjectionVolume,"In autosampler-aided (flow injection) ESI-QTOF mass spectrometry measurements, the injection volume is set to 10 microliters automatically:"},
			Download[ExperimentMassSpectrometry[{Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				InjectionType->FlowInjection,
				InjectionVolume->Automatic],
				SampleVolumes
			],
			{10*Microliter,10*Microliter},
			EquivalenceFunction->Equal
		],
		Example[{Options,InjectionVolume,"In autosampler-aided (flow injection) ESI-QTOF mass spectrometry measurements, if the sample is being transferred to a new container before the experiment, then the injection volume is set to the amount being transferred, minus the dead volume of the autosampler:"},
			Download[ExperimentMassSpectrometry[{Object[Sample,"775 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],Object[Sample,"Peptide Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				InjectionType->FlowInjection,
				AliquotAmount->45*Microliter,
				InjectionVolume->Automatic],
				SampleVolumes
			],
			{25*Microliter,25*Microliter},
			EquivalenceFunction->Equal
		],
		Example[{Options,InjectionType,"In ESI-QTOF mass spectrometry measurements, specify that the sample should be injected directly via the built-in pump on the instrument (DirectInfusion):"},
			Lookup[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				InjectionType->DirectInfusion,
				Output->Options
			],
				InjectionType
			],
			DirectInfusion
		],
		Example[{Options,InjectionType,"In ESI-QTOF mass spectrometry measurements, specify that the sample should be injected using autosampler-aided flow injection:"},
			Lookup[ExperimentMassSpectrometry[{Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				InjectionType->FlowInjection,
				Output->Options
			],
				InjectionType
			],
			FlowInjection
		],
		Example[{Options,InjectionType,"In ESI-QTOF mass spectrometry measurements, if injection-flow related parameters are set (like Buffer, InjectionVolume, etc), then the injection type is automatically set to FlowInjection:"},
			Lookup[ExperimentMassSpectrometry[{Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				InjectionType->Automatic,
				InjectionVolume->{7.5*Microliter,8.5*Microliter},
				Buffer->Model[Sample,"Methanol - LCMS grade"],
				Output->Options
			],
				InjectionType
			],
			FlowInjection
		],
		Example[{Options,InjectionType,"In ESI-QTOF mass spectrometry measurements, if the number of samples to be run is less than 5 then the injection type is automatically set to DirectInfusion:"},
			Lookup[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				InjectionType->Automatic,
				Output->Options
			],
				InjectionType
			],
			DirectInfusion
		],
		Example[{Options,InjectionType,"In ESI-QTOF mass spectrometry measurements, if the samples are inside autosampler-compatible containers, then the injection type is automatically set to FlowInjection:"},
			Lookup[ExperimentMassSpectrometry[Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				InjectionType->Automatic,
				Output->Options
			],
				InjectionType
			],
			DirectInfusion
		],

		(* == MALDI OPTIONS == *)
		Example[{Options,AccelerationVoltage,"The voltage of the first ion source of the MALDI can be specified for each sample:"},
			Download[
				ExperimentMassSpectrometry[{Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},AccelerationVoltage->16 Kilovolt],
				AccelerationVoltages
			],
			{16*Kilovolt},
			EquivalenceFunction->Equal
		],

		Example[{Options,CalibrantLaserPowerRange,"If the calibrant laser power is not specified, it will be inherited from the laser power range:"},
			Download[ExperimentMassSpectrometry[Object[Sample,"5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				LaserPowerRange->Span[10 Percent,40 Percent]],
				CalibrationMethods[{MinLaserPower,MaxLaserPower}]],
			{{10 Percent,40 Percent}},
			EquivalenceFunction->Equal
		],
		Example[{Options,CalibrantLaserPowerRange,"Indicate the laser power which should be used when calibrating the mass spectrometer before running the current analyte:"},
			Download[ExperimentMassSpectrometry[Object[Sample,"5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				LaserPowerRange->Span[10 Percent,40 Percent],
				CalibrantLaserPowerRange->Span[40 Percent,90 Percent]],
				CalibrationMethods[{MinLaserPower,MaxLaserPower}]],
			{{40 Percent,90 Percent}},
			EquivalenceFunction->Equal
		],
		Example[{Options,CalibrantNumberOfShots,"Indicate the laser should be fired 150 times during calibration, but 300 times during sample acquisition:"},
			Download[ExperimentMassSpectrometry[Object[Sample,"5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],NumberOfShots->300,CalibrantNumberOfShots->150],{NumberOfShots,CalibrationMethods[NumberOfShots]}],
			{300,{150}},
			EquivalenceFunction->Equal
		],
		Example[{Options,CalibrantVolume,"Indicate that 0.5 Microliter of calibrant should be used when spotting the MALDI plate:"},
			Download[ExperimentMassSpectrometry[Object[Sample,"5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],CalibrantVolume->0.5 Microliter],CalibrantVolumes],
			{0.5 Microliter},
			EquivalenceFunction->Equal
		],
		Example[{Options,DelayTime,"Delay time is resolved based on the sample type:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 3 Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI],
				DelayTimes
			],
			{250 Nanosecond},
			EquivalenceFunction->Equal
		],
		Example[{Options,Gain,"The gain factor applied to the MALDI detector can be specified to control signal intensity and signal to noise:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 3 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Gain->2.5,IonSource->MALDI],
				Gains
			],
			{2.5},
			EquivalenceFunction->Equal
		],
		Example[{Options,GridVoltage,"The voltage of the second ion source of the MALDI can be specified for each sample:"},
			Download[
				ExperimentMassSpectrometry[{Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},GridVoltage->16 Kilovolt],
				GridVoltages
			],
			{16 Kilovolt},
			EquivalenceFunction->Equal
		],
		Example[{Options,GridVoltage,"The grid voltage is resolved based on the sample type:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 3 Sample for ExperimentMassSpectrometry"<>$SessionUUID],DelayTime->150 Nanosecond],
				GridVoltages
			],
			{18.15 Kilovolt},
			EquivalenceFunction->Equal
		],
		Example[{Options,LaserPowerRange,"Specify a low laser power range if samples are expected to fly easily:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					LaserPowerRange->Span[10 Percent,40 Percent]
				],
				{MinLaserPowers,MaxLaserPowers}
			],
			{{10 Percent},{40 Percent}},
			EquivalenceFunction->Equal
		],
		Example[{Options,LensVoltage,"Indicate the voltage which should be applied to the lens:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],LensVoltage->6.5 Kilovolt],
				LensVoltages
			],
			{6.5 Kilovolt},
			EquivalenceFunction->Equal
		],
		Example[{Options,MALDIPlate,"Indicate that samples should be spotted onto a ground steel plate:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					MALDIPlate->Model[Container, Plate, MALDI, "96-well Ground Steel MALDI Plate"]],
				MALDIPlate
			],
			ObjectP[Model[Container, Plate, MALDI, "96-well Ground Steel MALDI Plate"]]
		],
		Example[{Options,Matrix,"Indicate the specific matrix sample which should be used to assist ionization:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Matrix->Object[Sample,"Matrix Sample for ExperimentMassSpectrometry"<>$SessionUUID]],
				Matrices
			],
			{ObjectP[Object[Sample,"Matrix Sample for ExperimentMassSpectrometry"<>$SessionUUID]]}
		],
		Example[{Options,CalibrantMatrix,"Indicate the specific calibrant matrix sample which should be used to assist ionization:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					CalibrantMatrix->Object[Sample,"Matrix Sample for ExperimentMassSpectrometry"<>$SessionUUID]],
				CalibrantMatrices
			],
			{ObjectP[Object[Sample,"Matrix Sample for ExperimentMassSpectrometry"<>$SessionUUID]]}
		],
		Example[{Options,CalibrantMatrix,"A mix of samples and models can be specified for the calibrant matrices:"},
			Download[
				ExperimentMassSpectrometry[{
					Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
				},
					CalibrantMatrix->{Model[Sample, Matrix, "HCCA MALDI matrix"],Object[Sample,"Matrix Sample for ExperimentMassSpectrometry"<>$SessionUUID]}
				],
				{CalibrantMatrices[Object]}
			],
			{
				{Model[Sample, Matrix, "id:E8zoYveRllLb"],ObjectP[Object[Sample,"Matrix Sample for ExperimentMassSpectrometry"<>$SessionUUID]]}
			}
		],
		Example[{Options,MatrixControlScans,"Indicate the protocol will scan pure matrices as the control sample:"},
			Download[
				ExperimentMassSpectrometry[
					{
						Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
						Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
					},
					IonSource->MALDI,
					MatrixControlScans->False
				],
				{SamplesInWells, CalibrantWells, MatrixWells}
			],
			{
				{"A1", "A2"},
				{"A3"},
				{}
			}
		],
		Example[{Options,NumberOfShots,"Specify the total number of times the laser should be fired during acquisition:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],NumberOfShots->500],
				NumberOfShots
			],
			500,
			EquivalenceFunction->Equal
		],
		Example[{Options,SampleVolume,"Specify the volume of sample to aliquot onto the MALDI plate:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],SampleVolume->0.8 Microliter],
				SampleVolumes
			],
			{0.8 Microliter},
			EquivalenceFunction->Equal
		],
		Example[{Options,ShotsPerRaster,"Specify the number of repeated shots to make between each raster movement:"},
			Download[
				ExperimentMassSpectrometry[{Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},ShotsPerRaster->10],
				ShotsPerRaster
			],
			10,
			EquivalenceFunction->Equal
		],
		Example[{Options,SpottingDryTime,"Indicate that the sample should be allowed to dry for at least 10 minutes after it's spotted onto the MALDI plate:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],SpottingDryTime->10 Minute],
				SpottingDryTime
			],
			10 Minute,
			EquivalenceFunction->Equal
		],
		Example[{Options,SpottingMethod,"If left unspecified the spotting method will be determined from the calibrant:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Calibrant->Model[Sample,StockSolution,Standard,"Low Weight Calibrant Model for ExperimentMassSpectrometry"<>$SessionUUID],
					IonSource->MALDI
				],
				SpottingMethods
			],
			{OpenFace},
			Stubs:>{$DeveloperSearch=True, $RequiredSearchName = $SessionUUID},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,SpottingMethod,"Set the spotting method to Sandwich to layer matrix,analyte,matrix:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],SpottingMethod->Sandwich],
				SpottingMethods
			],
			{Sandwich}
		],
		Example[{Options,SpottingPattern,"Indicate that every other well should be spotted to avoid the risk of cross contamination:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],SpottingPattern->Spaced],
				SpottingPattern
			],
			Spaced
		],

		(*--- ESI-QQQ Tests ---*)
		Example[
			{Options,MassAnalyzer,"In ESI-QQQ, user could specified MassAnalyzer modes:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				MassAnalyzer->TripleQuadrupole,
				Output -> Options
			];
			Lookup[option,MassAnalyzer],
			TripleQuadrupole,
			Variables:>{option}
		],
		Example[
			{Options,MassDetection,"In ESI-QQQ, user could specified a mass range for MassDetection Option:"},
			option = ExperimentMassSpectrometry[
				Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				MassDetection -> Span[110 Gram/Mole, 1000 Gram/Mole],
				Output -> Options];
			Lookup[option, MassDetection],
			Quantity[110, ("Grams")/("Moles")] ;; Quantity[1000, ("Grams")/("Moles")],
			Variables:>{option}
		],
		Example[
			{Options,MassDetection,"In ESI-QQQ, user could specified a single Mass Value as the input for MassDetection Option:"},
			option = ExperimentMassSpectrometry[
				Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				MassDetection ->666 Gram/Mole,
				FragmentMassDetection ->666 Gram/Mole,
				Output -> Options];Lookup[option, MassDetection],
			{Quantity[666, ("Grams")/("Moles")]},
			Variables:>{option}
		],
		Example[
			{Options,MassDetection,"In ESI-QQQ, user could specified a list of Mass Values as the input for MassDetection Option:"},
			option = ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				FragmentMassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				Output -> Options];
			Lookup[option, MassDetection],
			{Quantity[111, ("Grams")/("Moles")],
				Quantity[222, ("Grams")/("Moles")],
				Quantity[333, ("Grams")/("Moles")],
				Quantity[444, ("Grams")/("Moles")],
				Quantity[555, ("Grams")/("Moles")]
			},
			Variables:>{option}
		],

		(*FragmentMassDetection*)
		Example[
			{Options,FragmentMassDetection,"In ESI-QQQ, user could specified a single Value of FragmentMassDetection as the input for MassDetection Option:"},
			option = ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				MassDetection -> Span[110 Gram/Mole, 1000 Gram/Mole],
				FragmentMassDetection -> 666 Gram/Mole,
				Output -> Options]; Lookup[option, FragmentMassDetection],
			{Quantity[666, ("Grams")/("Moles")]},
			Variables:>{option}
		],
		Example[
			{Options,FragmentMassDetection,"In ESI-QQQ, user could specified a range Value of FragmentMassDetection as the input for MassDetection Option:"},
			option = ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				MassDetection ->666 Gram/Mole,
				FragmentMassDetection -> Span[110 Gram/Mole, 1000 Gram/Mole],
				Output -> Options]; Lookup[option, FragmentMassDetection],
			Quantity[110, ("Grams")/("Moles")] ;; Quantity[1000, ("Grams")/("Moles")],
			Variables:>{option}
		],
		Example[
			{Options,FragmentMassDetection,"In ESI-QQQ, user could specified a list of single Mass Values of FragmentMassDetection as the input for MassDetection Option:"},
			option = ExperimentMassSpectrometry[
				Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID], MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				FragmentMassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				Output -> Options]; Lookup[option, FragmentMassDetection],
			{
				Quantity[111, ("Grams")/("Moles")],
				Quantity[222, ("Grams")/("Moles")],
				Quantity[333, ("Grams")/("Moles")],
				Quantity[444, ("Grams")/("Moles")],
				Quantity[555, ("Grams")/("Moles")]
			},
			Variables:>{option}
		],

		(*Collision Energy*)
		Example[
			{Options,CollisionEnergy,"In ESI-QQQ, if user didn't specify the CollisionEnergy, this option will be auto resolved based on the input and resolved ion mode:"},
			option = ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID], MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				FragmentMassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole}, IonMode -> Negative,
				Output -> Options]; Lookup[option, CollisionEnergy],
			{
				Quantity[-40, "Volts"], Quantity[-40, "Volts"],
				Quantity[-40, "Volts"], Quantity[-40, "Volts"],
				Quantity[-40, "Volts"]
			},
			Variables:>{option}
		],
		Example[
			{Options,CollisionEnergy,"In ESI-QQQ, specify a single voltage value as the collision energy used in the collision cell:"},
			option = ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				FragmentMassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				IonMode -> Negative,
				CollisionEnergy -> -60 Volt, Output -> Options]; Lookup[option, CollisionEnergy],
			{
				Quantity[-60, "Volts"], Quantity[-60, "Volts"],
				Quantity[-60, "Volts"], Quantity[-60, "Volts"],
				Quantity[-60, "Volts"]
			},
			Variables:>{option}
		],
		Example[
			{Options,CollisionEnergy,"In ESI-QQQ, specify a different voltage value for each multiple reaction monitoring assay as the collision energy used in the collision cell:"},
			option = ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				FragmentMassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				IonMode -> Positive,
				CollisionEnergy -> {40*Volt,50*Volt,60*Volt,70*Volt,80*Volt},
				Output -> Options
			]; Lookup[option, CollisionEnergy],
			{
				Quantity[40, "Volts"], Quantity[50, "Volts"], Quantity[60, "Volts"],
				Quantity[70, "Volts"], Quantity[80, "Volts"]
			},
			Variables:>{option}
		],
		(*CollisionCellExitVoltage*)
		Example[
			{Options,CollisionCellExitVoltage,"In ESI-QQQ, specify the value that focuses and accelerates the ions out of collision cell (Q2) and into 2nd mass analyzer (MS 2). This potential is tuned to ensure successful ion acceleration out of collision cell and into MS2, and can be adjusted to reach the maximal signal intensity:"},
			option = ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID], MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				FragmentMassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				CollisionCellExitVoltage -> 35 Volt,
				Output -> Options];
			Lookup[option, CollisionCellExitVoltage],
			Quantity[35, "Volts"],
			Variables:>{option}
		],
		(*ScanMode*)
		Example[
			{Options,ScanMode,"In ESI-QQQ, specified scan mode we used to run mass analysis:"},
			option = ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID], MassAnalyzer -> TripleQuadrupole,
				MassDetection -> 666 Gram/Mole, ScanMode -> ProductIonScan,
				Output -> Options]; Lookup[option, ScanMode],
			ProductIonScan,
			Variables:>{option}
		],
		Example[
			{Options,ScanMode,"In ESI-QQQ, if the user didn't specified the ScanMode, auto resolve it based on other input options:"},
			option = ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID], MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				FragmentMassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				CollisionCellExitVoltage -> 35 Volt, Output -> Options];
			Lookup[option, ScanMode],
			MultipleReactionMonitoring,
			Variables:>{option}
		],
		(*Fragment*)
		Example[
			{Options,Fragment,"In ESI-QQQ, specified if the collision cell should be turned on to fragment the intact ion into small charged pieces:"},
			option = ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				MassDetection -> 666 Gram/Mole, Fragment -> True,
				Output -> Options];Lookup[option, Fragment],
			True,
			Variables:>{option}
		],
		Example[{Options, Fragment,
			"In ESI-QQQ, auto resolved Fragment options based on other tandem mass input:"},
			option = ExperimentMassSpectrometry[
				Object[Sample,
					"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID], MassAnalyzer -> TripleQuadrupole,
				MassDetection -> Span[110 Gram/Mole, 900 Gram/Mole],
				CollisionEnergy -> {11*Volt},
				FragmentMassDetection -> 666 Gram/Mole, Output -> Options];
			Lookup[option, Fragment],
			True,
			Variables :> {option}
		],
		(*RunDuration*)
		Example[
			{Options,RunDuration,"In ESI-QQQ, specified the lenght of time for each reaction :"},
			option = ExperimentMassSpectrometry[
				Object[Sample,
					"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID], MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				FragmentMassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				RunDuration -> 1.5 Minute, Output -> Options];Lookup[option, RunDuration],
				Quantity[1.5, "Minutes"],
			Variables:>{option}
		],
		(*ScanTime*)
		Example[
			{Options,ScanTime,"In ESI-QQQ, specified the duration of time allowed to pass between each spectral acquisition. Increasing this value improves sensitivity whereas decreasing this value allows for more data points and spectra to be acquired during the RunDuration:"},
			option = ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID], MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				FragmentMassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				ScanTime -> 30*Millisecond, Output -> Options];Lookup[option, ScanTime],
			30*Millisecond,
			Variables:>{option}
		],
		(*MassTolerance*)
		Example[
			{Options,MassTolerance,"In ESI-QQQ, specified This options indicate the stepsize of both MS1 and MS2 when both or either one of them are set in mass selection mode. This value indicate the mass range used to find apeak with twice the entered range:"},
			option = ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID], MassAnalyzer -> TripleQuadrupole,
				MassDetection -> Span[110 Gram/Mole, 1000 Gram/Mole],
				MassTolerance -> 0.5 Gram/Mole, Output -> Options];Lookup[option, MassTolerance],
			(0.5 Gram/Mole),
			Variables:>{option}
		],

		(*DwellTime*)
		Example[
			{Options,DwellTime,"In ESI-QQQ,specify a single value for the duration of time for which spectra are acquired at the specific mass detection value for SelectedIonMonitoring and MultipleReactionMonitoring mode:"},
			option = ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID], MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				FragmentMassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				DwellTime -> 150 Millisecond, Output -> Options];
			Lookup[option, DwellTime],
			{Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"],
				Quantity[150, "Milliseconds"], Quantity[150, "Milliseconds"],
				Quantity[150, "Milliseconds"]},
			Variables:>{option}
		],

		Example[
			{Options,DwellTime,"In ESI-QQQ,specify a list of values for the duration of time for which spectra are acquired at the specific mass detection value for SelectedIonMonitoring and MultipleReactionMonitoring mode:"},
			option = ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID], MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				FragmentMassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				DwellTime -> {110 Millisecond, 120 Millisecond, 130 Millisecond, 140 Millisecond, 150 Millisecond}, Output -> Options];
			Lookup[option, DwellTime],
			{Quantity[110, "Milliseconds"], Quantity[120, "Milliseconds"],
				Quantity[130, "Milliseconds"], Quantity[140, "Milliseconds"],
				Quantity[150, "Milliseconds"]},
			Variables:>{option}
		],
		(*NeutralLoss*)
		Example[
			{Options,NeutralLoss,"In ESI-QQQ, specified the mass sacn offset betweetn first mass analyzer and the second mass analyzer:"},
			option = ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID], MassAnalyzer -> TripleQuadrupole,
				MassDetection -> Span[110 Gram/Mole, 800 Gram/Mole],
				ScanMode->NeutralIonLoss,
				NeutralLoss -> 566 Gram/Mole, Output -> Options];Lookup[option, NeutralLoss],
			Quantity[566, ("Grams")/("Moles")],
			Variables:>{option}
		],

		(*ESI-QQQ Direct Infusion options using syringe pump*)
		Example[
			{Options,InfusionVolume,"For ESI-QQQ, automatically resolve the physical quantity of sample loaded into the instrument (for now ESI-QQQ only):"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				InfusionVolume->Automatic,
				InjectionType->DirectInfusion,
				MassAnalyzer->TripleQuadrupole,
				Output->Options
			];
			Lookup[option,InfusionVolume],
			Quantity[0.5, "Milliliters"],
			Variables:>{option}
		],
		Example[
			{Options,InfusionSyringe,"For ESI-QQQ, automatically resolve the syringe used for syringe pump infusion injection (For ESI-QQQ only:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				InfusionSyringe->Automatic,
				InjectionType->DirectInfusion,
				MassAnalyzer->TripleQuadrupole,
				Output->Options
			];
			Lookup[option,InfusionSyringe],
			Model[Container, Syringe, "1mL All-Plastic Disposable Syringe"],
			Variables:>{option}
		],
		Example[
			{Options,InfusionFlowRate,"For ESI-QQQ, automatically resolve the flow rate at which the sample is injected into the mass spectrometer through the syringe pump system:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				InfusionFlowRate->Automatic,
				InjectionType->DirectInfusion,
				MassAnalyzer->TripleQuadrupole,
				Output->Options
			];
			Lookup[option,InfusionFlowRate],
			Quantity[5, ("Microliters")/("Minutes")],
			Variables:>{option}
		],
		Example[
			{Options,InfusionVolume,"For ESI-QQQ, specify The physical quantity of sample loaded into the instrument (for now ESI-QQQ only), when using syringe pump to infusion load the sample:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				InfusionVolume->{400 Microliter,600 Microliter},
				InjectionType->DirectInfusion,
				MassAnalyzer->TripleQuadrupole,
				Output->Options
			];
			Lookup[option,InfusionVolume],
			{400 Microliter,600 Microliter},
			Variables:>{option}
		],
		Example[
			{Options,InfusionSyringe,"For ESI-QQQ, specify The syringe used for syringe pump infusion injection (For ESI-QQQ only:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				InfusionSyringe->{Model[Container,Syringe,"id:P5ZnEj4P88P0"], Model[Container,Syringe,"id:01G6nvkKrrKY"]},
				InjectionType->DirectInfusion,
				MassAnalyzer->TripleQuadrupole,
				Output->Options
			];
			Lookup[option,InfusionSyringe],
			{Model[Container,Syringe,"id:P5ZnEj4P88P0"], Model[Container,Syringe,"id:01G6nvkKrrKY"]},
			Variables:>{option}
		],
		Example[
			{Options,InfusionFlowRate,"For ESI-QQQ, specify The flow rate at which the sample is injected into the mass spectrometer through the fluidics pump system (ESI-QTOF) or the syringe pump system. Note that source settings such as source voltage/temperature and desolvation temperature/flow rate should be adjusted according to the flow rate for improved sensitivity and spray stability:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				InfusionFlowRate->{50*Microliter/Minute,40*Microliter/Minute},
				InjectionType->DirectInfusion,
				MassAnalyzer->TripleQuadrupole,
				Output->Options
			];
			Lookup[option,InfusionFlowRate],
			{50*Microliter/Minute,40*Microliter/Minute},
			Variables:>{option}
		],

		(*ESI Specific Ion Source Options*)

		(*User Specified Options*)
		Example[
			{Options,ESICapillaryVoltage,"For ESI-QQQ, specify This option (also known as Ion Spray Voltage) indicate the absolute voltage applied to the tip of the stainless steel capillary tubing in order to produce charged droplets. Adjust this voltage to maximize sensitivity:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				MassAnalyzer->TripleQuadrupole,
				IonMode->{Negative,Positive},
				ESICapillaryVoltage->{-4.0*Kilovolt,4.0*Kilovolt},
				Output->Options
			];
			Lookup[option,ESICapillaryVoltage],
			{Quantity[-4., "Kilovolts"], Quantity[4., "Kilovolts"]},
			Variables:>{option},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,DeclusteringVoltage,"For ESI-QQQ, specify the voltage applied between the orifice (where ions enter the mass spectrometer) and the ion guide to prevent the ionized small particles from aggregating together:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				MassAnalyzer->TripleQuadrupole,
				IonMode->{Negative,Positive},
				DeclusteringVoltage->{-70*Volt,80*Volt},
				Output->Options
			];
			Lookup[option,DeclusteringVoltage],
			{Quantity[-70, "Volts"], Quantity[80, "Volts"]},
			Variables:>{option}
		],
		Example[
			{Options,SourceTemperature,"For ESI-QQQ, specify The temperature setting of the source block. Heating the source block discourages condensation and decreases solvent clustering in the reduced vacuum region of the source:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				MassAnalyzer->TripleQuadrupole,
				SourceTemperature->{150Celsius,150Celsius},
				Output->Options
			];
			Lookup[option,SourceTemperature],
			{Quantity[150, "DegreesCelsius"], Quantity[150, "DegreesCelsius"]},
			Variables:>{option}
		],
		Example[
			{Options,DesolvationTemperature,"For ESI-QQQ, specify The temperature setting for the ESI desolvation heater that controls the nitrogen gas temperature used for solvent evaporation to produce single gas phase ions from the ion spray:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				MassAnalyzer->TripleQuadrupole,
				DesolvationTemperature->{400 Celsius,650 Celsius},
				Output->Options
			];
			Lookup[option,DesolvationTemperature],
			{Quantity[400, "DegreesCelsius"], Quantity[650, "DegreesCelsius"]},
			Variables:>{option}
		],
		Example[
			{Options,DesolvationGasFlow,"For ESI-QQQ, specify The nitrogen gas flowing around the electrospray inlet capillary in order to desolvate and nebulize analytes. Similarly to DesolvationTemperature, the ideal setting is dependent on solvent flow rate and composition:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				MassAnalyzer->TripleQuadrupole,
				DesolvationGasFlow->{60PSI,40PSI},
				Output->Options
			];
			Lookup[option,DesolvationGasFlow],
			{Quantity[60, ("PoundsForce")/("Inches")^2], Quantity[40, ("PoundsForce")/("Inches")^2]},
			Variables:>{option}
		],
		Example[
			{Options,ConeGasFlow,"For ESI-QQQ, specify The nitrogen gas flow ejected around the sample inlet cone (the spherical metal plate acting as a first gate between the sprayer and the reduced pressure chamber, the ion block):"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				MassAnalyzer->TripleQuadrupole,
				ConeGasFlow->{35PSI,41PSI},
				Output->Options
			];
			Lookup[option,ConeGasFlow],
			{Quantity[35, ("PoundsForce")/("Inches")^2], Quantity[41, ("PoundsForce")/("Inches")^2]},
			Variables:>{option}
		],

		Example[{Options,InjectionVolume,"In ESI-QQQ mass spectrometry measurements, indicate how much volume should be picked up by the needle from the sample and injected into the mass spectrometer (when doing flow injection mass spectrometry):"},
			Download[ExperimentMassSpectrometry[{Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				InjectionType->FlowInjection,
				MassAnalyzer->TripleQuadrupole,
				InjectionVolume->{7.5*Microliter,8.5*Microliter}],
				SampleVolumes
			],
			{7.5*Microliter,8.5*Microliter},
			EquivalenceFunction->Equal
		],
		Example[{Options,InjectionVolume,"In ESI-QQQ mass spectrometry measurements, auto resolved InjectionVolumes to 10 microliter if InjectionType is flowinjection:"},
			Download[ExperimentMassSpectrometry[{Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				InjectionType->FlowInjection,
				MassAnalyzer->TripleQuadrupole
				],
				SampleVolumes
			],
			{10*Microliter,10*Microliter},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,IonGuideVoltage,"For ESI-QQQ, specify electric potential applied to the Ion Guide in ESI-QQQ, which guides and focuses the ions through the high-pressure ion guide region:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				MassAnalyzer->TripleQuadrupole,
				IonMode->{Negative,Positive},
				IonGuideVoltage->{-8Volt,12Volt},
				Output->Options
			];
			Lookup[option,IonGuideVoltage],
			{Quantity[-8, "Volts"], Quantity[12, "Volts"]},
			Variables:>{option}
		],
		Example[
			{Options,Output,"For ESI-QQQ, Setting Output -> Tests returns a list of tests:"},
			ExperimentMassSpectrometry[{Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},IonSource->MALDI, Output->Tests],
			{__EmeraldTest}
		],

		(*Resolve Automatic Options*)
		Example[
			{Options,ESICapillaryVoltage,"In ESI-QQQ analysis, if ESICapillaryVoltage option was set to Automatic, it can be auto resolved to a value depends on ion mode:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				IonMode->{Negative,Positive},
				MassAnalyzer->TripleQuadrupole,
				ESICapillaryVoltage->Automatic,
				Output->Options
			];
			Lookup[option,ESICapillaryVoltage],
			{-4.5*Kilovolt,5.5*Kilovolt},
			Variables:>{option},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,DeclusteringVoltage,"In ESI-QQQ analysis, if DeclusteringVoltage option was set to Automatic, it can be auto resolved to a value depends on ion mode:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				IonMode->{Negative,Positive},
				MassAnalyzer->TripleQuadrupole,
				DeclusteringVoltage->Automatic,
				Output->Options

			];
			Lookup[option,DeclusteringVoltage],
			{-90*Volt,90*Volt},
			Variables:>{option}
		],
		Example[
			{Options,StepwaveVoltage,"In ESI-QQQ analysis, if StepwaveVoltage option was set to Automatic, it can be auto resolved to Null:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				MassAnalyzer->TripleQuadrupole,
				StepwaveVoltage->Automatic,
				Output->Options

			];
			Lookup[option,StepwaveVoltage],
			Null,
			Variables:>{option}
		],
		Example[
			{Options,SourceTemperature,"In ESI-QQQ analysis, if SourceTemperature option was set to Automatic, it can be auto resolved to 150 Celsius:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				MassAnalyzer->TripleQuadrupole,
				SourceTemperature->Automatic,
				Output->Options
			];
			Lookup[option,SourceTemperature],
			150 Celsius,
			Variables:>{option}
		],
		Example[
			{Options,DesolvationTemperature,"In ESI-QQQ analysis, if DesolvationTemperature option was set to Automatic, it can be auto resolved to 100 Celsius:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				InfusionFlowRate->{0.01*Milliliter/Minute,Automatic},
				MassAnalyzer->TripleQuadrupole,
				DesolvationTemperature->Automatic,
				Output->Options

			];
			Lookup[option,DesolvationTemperature],
			100 Celsius,
			Variables:>{option}
		],
		Example[
			{Options,DesolvationGasFlow,"In ESI-QQQ analysis, if DesolvationGasFlow option was set to Automatic, it can be auto resolved to 20 PSi:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				MassAnalyzer->TripleQuadrupole,
				DesolvationGasFlow->Automatic,
				Output->Options

			];
			Lookup[option,DesolvationGasFlow],
			20*PSI,
			Variables:>{option}
		],
		Example[
			{Options,ConeGasFlow,"In ESI-QQQ analysis, if ConeGasFlow option was set to Automatic, it can be auto resolved to 50 PSi:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				MassAnalyzer->TripleQuadrupole,
				ConeGasFlow->Automatic,
				Output->Options
			];
			Lookup[option,ConeGasFlow],
			50 PSI,
			Variables:>{option}
		],
		Example[
			{Options,IonGuideVoltage,"In ESI-QQQ analysis, if IonGuideVoltage option was set to Automatic, it can be auto resolved based on IonMode:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				MassAnalyzer->TripleQuadrupole,
				IonMode->{Negative, Positive},
				IonGuideVoltage->Automatic,
				Output->Options
			];
			Lookup[option,IonGuideVoltage],
			{Quantity[-10, "Volts"], Quantity[10, "Volts"]},
			Variables:>{option}
		],
		Example[
			{Options,MultipleReactionMonitoringAssays,"In ESI-QQQ analysis, MultipleReactionMonitoringAssays can be specified:"},
			option=ExperimentMassSpectrometry[{Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				MassAnalyzer->TripleQuadrupole,
				MultipleReactionMonitoringAssays -> {{123 Gram/Mole, 30 Volt, 234 Gram/Mole, 2 Second}, {235 Gram/Mole, 30 Volt, 345 Gram/Mole, 2 Second}, {235 Gram/Mole, 30 Volt, 345 Gram/Mole, 2 Second}, {235 Gram/Mole, 30 Volt, 345 Gram/Mole, 2 Second}},
				Output->Options
			];
			Lookup[option,MultipleReactionMonitoringAssays],
			{
				{Quantity[123, ("Grams")/("Moles")],Quantity[30, "Volts"],Quantity[234, ("Grams")/("Moles")],Quantity[2, "Seconds"]},
				{Quantity[235, ("Grams")/("Moles")],Quantity[30, "Volts"],Quantity[345, ("Grams")/("Moles")],Quantity[2, "Seconds"]},
				{Quantity[235, ("Grams")/("Moles")],Quantity[30, "Volts"], Quantity[345, ("Grams")/("Moles")],Quantity[2, "Seconds"]},
				{Quantity[235, ("Grams")/("Moles")],Quantity[30, "Volts"], Quantity[345, ("Grams")/("Moles")],Quantity[2, "Seconds"]}
			},
			Variables:>{option}
		],
		Example[
			{Options,CalibrantVolume,"In MALDI analysis, CalibrantVolume can be specified:"},
			option=ExperimentMassSpectrometry[{Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				MassAnalyzer->TOF,
				IonSource->MALDI,
				CalibrantVolume -> 1.11Microliter,
				Output->Options
			];
			Lookup[option,CalibrantVolume],
			Quantity[1.11, "Microliters"],
			Variables:>{option}
		],
		Example[
			{Options,AliquotSampleLabel,"Specify the label of the samples, after they are aliquotted:"},
			option = ExperimentMassSpectrometry[
				{Object[Sample, "Oligomer 1 Sample for ExperimentMassSpectrometry" <> $SessionUUID]}, Incubate -> {True},
				AliquotSampleLabel -> {"Test Label For ExpMS Unit Test"},
				Output->Options
			];
			Lookup[option,AliquotSampleLabel],
			{"Test Label For ExpMS Unit Test"},
			Variables:>{option}
		],


		(* --- MESSAGES --- *)

		(* == SHARED ERRORS BETWEEN ESI AND MALDI == *)
		Example[{Messages,"DiscardedSamples","The input samples cannot be discarded:"},
			ExperimentMassSpectrometry[{
				Object[Sample,"Discarded Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			}],
			$Failed,
			Messages:>{Error::DiscardedSamples,Error::InvalidInput}
		],
		Example[{Messages,"NonLiquidSamples","The input samples have to be liquid:"},
			ExperimentMassSpectrometry[{
				Object[Sample,"Tablet Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			}],
			$Failed,
			Messages:>{Error::NonLiquidSample,Error::InvalidInput,Warning::AliquotRequired}
		],
		Example[{Messages,"CalibrantIncompatibleWithIonSource","The calibrant specified needs to be compatible with the requested ion source (here example for ESI):"},
			ExperimentMassSpectrometry[{
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				IonSource->ESI,
				Calibrant->Model[Sample,StockSolution,Standard,"Peptide/Protein Calibrant Mix"]
			],
			$Failed,
			Messages:>{Error::CalibrantIncompatibleWithIonSource,Error::InvalidOption, Warning::AliquotRequired}
		],
		Example[{Messages,"CalibrantIncompatibleWithIonSource","The calibrant specified needs to be compatible with the requested ion source (here example for MALDI):"},
			ExperimentMassSpectrometry[{
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				IonSource->MALDI,
				Calibrant->Model[Sample,StockSolution,Standard,"Sodium Formate ESI Calibrant"]
			],
			$Failed,
			Messages:>{Error::CalibrantIncompatibleWithIonSource,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleInstrument","The instrument specified needs to be compatible with the requested ion source:"},
			ExperimentMassSpectrometry[{
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				IonSource->MALDI,
				Instrument->Model[Instrument,MassSpectrometer,"Xevo G2-XS QTOF"]
			],
			$Failed,
			Messages:>{Error::IncompatibleInstrument,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleMassAnalyzerAndInstrument","The instrument specified needs to be compatible with the requested mass analyzer:"},
			ExperimentMassSpectrometry[{
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				MassAnalyzer->TOF,
				Instrument->Model[Instrument,MassSpectrometer,"Xevo G2-XS QTOF"]
			],
			$Failed,
			Messages:>{Error::IncompatibleMassAnalyzerAndInstrument,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleMassAnalyzerAndIonSource","The IonSource specified needs to be compatible with the requested mass analyzer:"},
			ExperimentMassSpectrometry[{
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				MassAnalyzer -> TripleQuadrupole, IonSource -> MALDI
			],
			$Failed,
			Messages:>{Error::IncompatibleMassAnalyzerAndIonSource,Error::InvalidOption}
		],
		Example[{Messages,"MassSpectrometryInvalidCalibrants","For MALDI-TOF,Calibrants that are deprecated and without ReferencePeaksPositiveMode and ReferencePeaksNegativeMode filled cannot be used:"},
			ExperimentMassSpectrometry[{Object[Sample,"Oligomer 4 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample, "Oligomer 4 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				Calibrant ->Model[Sample, StockSolution, Standard,"Deprecated Calibrant for ExpMS Tests"<>$SessionUUID],
				IonSource -> MALDI
			],
			$Failed,
			Messages:>{Error::MassSpectrometryInvalidCalibrants,Error::InvalidOption,Warning::AliquotRequired},
			Stubs:>{$DeveloperSearch=True, $RequiredSearchName = $SessionUUID}
		],
		Example[{Messages,"MassSpectrometryInvalidCalibrants","For ESI-QTOF, Calibrants that are deprecated and without ReferencePeaksPositiveMode and ReferencePeaksNegativeMode filled cannot be used:"},
			ExperimentMassSpectrometry[{Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				Calibrant -> Model[Sample, StockSolution, Standard, "Deprecated Calibrant for ExpMS Tests"<>$SessionUUID], MassAnalyzer -> QTOF],
			$Failed,
			Messages:>{Error::MassSpectrometryInvalidCalibrants,Error::InvalidOption}
		],
		Example[{Messages,"MassSpectrometryInvalidCalibrants","For ESI-QQQ, Calibrants that are deprecated and without ReferencePeaksPositiveMode and ReferencePeaksNegativeMode filled cannot be used:"},
			ExperimentMassSpectrometry[{Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				Calibrant -> {Automatic,Model[Sample, StockSolution, Standard, "Deprecated Calibrant for ExpMS Tests"<>$SessionUUID]}, MassAnalyzer -> TripleQuadrupole],
			$Failed,
			Messages:>{Error::MassSpectrometryInvalidCalibrants,Error::InvalidOption}
		],
		Example[{Messages,"ESITripleQuadTooManyCalibrants","For ESI-QQQ, the instrument cannot take too many unique calibrants:"},
			ExperimentMassSpectrometry[
				{
					Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
				},
				IonSource -> ESI,
				MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {
					Span[222 Gram/Mole, 777 Gram/Mole],
					666 Gram/Mole,
					{111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
					{111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole}
				},
				FragmentMassDetection -> {
					Automatic,
					Span[200 Gram/Mole, 700 Gram/Mole],
					{111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
					{111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole}
				},
				ScanMode -> {
					FullScan,
					ProductIonScan,
					MultipleReactionMonitoring,
					MultipleReactionMonitoring
				},
				IonMode -> {Positive, Negative, Positive, Negative},
				InjectionType -> DirectInfusion,
				Calibrant -> {
					Automatic,
					Automatic,
					Model[Sample, StockSolution, Standard,"Sodium Iodide ESI Calibrant"],
					Model[Sample, StockSolution, Standard,"Sodium Formate ESI Calibrant"]
				}
			],
			ObjectP[Object[Protocol,MassSpectrometry]],
			Messages:>{Warning::ESITripleQuadTooManyCalibrants,Warning::IncompatibleCalibrant}
		],
		Example[{Messages,"UnneededOptions","Options not relevant to the instrument cannot be specifiec (Here SourceTemperature):"},
			Lookup[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Instrument -> Automatic,
					IonSource -> Automatic,
					LensVoltage->5*Kilovolt, (* Maldi *)
					GridVoltage->10*Kilovolt, (* Maldi *)
					SourceTemperature->50*Celsius, (* this is the only ESI specific Option *)
					Output->Options
				],
				{IonSource,Instrument}],
			{MALDI,ObjectReferenceP[Model[Instrument, MassSpectrometer, "Microflex LRF"]]},
			Messages:>{Error::UnneededOptions,Error::InvalidOption}
		],
		Example[{Messages,"DirectInfusionUnneededOptions","Options not relevant to the InjectionType cannot be specified (here InjectionVolume and SampleTemperature):"},
			ExperimentMassSpectrometry[{
				Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				IonSource->ESI,
				InjectionType->DirectInfusion,
				SourceTemperature->{100*Celsius,Automatic},
				DesolvationTemperature->{50*Celsius,Automatic},
				InjectionVolume->{10*Microliter,20*Microliter},
				SampleTemperature -> 15*Celsius
			],
			$Failed,
			Messages:>{Error::DirectInfusionUnneededOptions,Error::InvalidOption}
		],
		Example[{Messages,"DirectInfusionUnneededOptions","Options not relevant to the InjectionType cannot be specified (here Buffer and NeedleWashSolution):"},
			ExperimentMassSpectrometry[{
				Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				IonSource->ESI,
				InjectionType->DirectInfusion,
				SourceTemperature->{100*Celsius,Automatic},
				DesolvationTemperature->{50*Celsius,Automatic},
				NeedleWashSolution->Model[Sample,"Methanol - LCMS grade"],
				Buffer -> Model[Sample,"Methanol - LCMS grade"]
			],
			$Failed,
			Messages:>{Error::DirectInfusionUnneededOptions,Error::InvalidOption}
		],
		Example[{Messages,"FlowInjectionRequiredOptions","Options not relevant to the InjectionType cannot be set to Null (here InjectionVolume and SampleTemperature):"},
			ExperimentMassSpectrometry[{
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				IonSource->ESI,
				InjectionType->FlowInjection,
				SourceTemperature->{100*Celsius,Automatic},
				DesolvationTemperature->{50*Celsius,Automatic},
				InjectionVolume->Null,
				SampleTemperature -> Null
			],
			$Failed,
			Messages:>{Error::FlowInjectionRequiredOptions,Error::InvalidOption}
		],
		Example[{Messages,"FlowInjectionRequiredOptions","Options not relevant to the InjectionType cannot be set to Null (here Buffer and NeedleWashSolution):"},
			ExperimentMassSpectrometry[{
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				IonSource->ESI,
				InjectionType->FlowInjection,
				SourceTemperature->{100*Celsius,Automatic},
				DesolvationTemperature->{50*Celsius,Automatic},
				NeedleWashSolution-> Null,
				Buffer -> Null
			],
			$Failed,
			Messages:>{Error::FlowInjectionRequiredOptions,Error::InvalidOption}
		],
		Example[{Messages,"InvalidScanTime","The ScanTime is too short (or too long):"},
			ExperimentMassSpectrometry[{
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {Span[100 Gram/Mole, 1000 Gram/Mole], Span[100 Gram/Mole, 100 Gram/Mole]},
				ScanTime -> {5 Millisecond, 10 Second}
			],
			$Failed,
			Messages:>{Error::InvalidScanTime, Error::InvalidMassDetection, Error::InvalidOption}
		],
		Example[{Messages,"MassSpecRequiredOptions","Options relevant to the IonSource and Instrument cannot be set to Null (here GridVoltage):"},
			ExperimentMassSpectrometry[{
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				IonSource->MALDI,
				GridVoltage->{Null,Automatic},
				MassDetection->Span[2000 Dalton,10000 Dalton]
			],
			$Failed,
			Messages:>{Error::MassSpecRequiredOptions,Error::InvalidOption}
		],
		Example[{Messages,"SamplesOutOfMassDetection","Throws a warning if the molecular weight of the sample is outside of the supplied mass range:"},
			ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassDetection->Span[3000 Dalton,6500 Dalton],
				IonSource->MALDI
			],
			ObjectP[Object[Protocol,MassSpectrometry]],
			Messages:>{Warning::SamplesOutOfMassDetection}
		],
		Example[{Messages,"InvalidMassDetection","Returns $Failed if the min mass is greater than the max mass:"},
			ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI,MassDetection->Span[10000 Dalton,2000 Dalton]],
			$Failed,
			Messages:>{Error::InvalidMassDetection,Error::InvalidOption,Error::UnableToCalibrate}
		],
		Example[{Messages,"DefaultMassDetection","If the MassDetection cannot be intelligently resolved from the type or the molecular weight of the sample(s), then it defaults to 350-2000 m/z:"},
			Lookup[ExperimentMassSpectrometry[Object[Sample,"Direct infusion 3 without MW Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->ESI,MassDetection->Automatic,Output->Options],MassDetection],
			Span[350*Gram/Mole,2000*Gram/Mole],
			Messages:>{Warning::DefaultMassDetection}
		],
		Example[{Messages,"LowInMass","Returns a warning if lower limit of the mass range falls into a range that is known to produce spectra of lower quality due to a high quantity of background peaks in MALDI:"},
			ExperimentMassSpectrometry[
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->MALDI,
				MassDetection->Span[600*Dalton,10000*Dalton]
			],
			ObjectP[Object[Protocol,MassSpectrometry]],
			Messages:>{Warning::LowMinMass}
		],
		Example[{Messages,"FilteredAnalytes","Throw warning if the two analyte require different mass detection range and the one of them was filtered:"},
			ExperimentMassSpectrometry[
				Object[Sample, "Oligomer 4 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Analytes ->	Download[Object[Sample,"Oligomer 4 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Composition[[All, 2]][Object]],
				IonSource -> MALDI
			],
			ObjectP[Object[Protocol,MassSpectrometry]],
			Messages:>{Warning::FilteredAnalytes}
		],
		Example[{Messages,"MALDINumberOfShotsTooSmall","NumberOfShots should be larger than ShotsPerRaster to in order to finish at least one run of data collection:"},
			ExperimentMassSpectrometry[
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->MALDI,
				NumberOfShots->80,
				ShotsPerRaster->90
			],
			$Failed,
			Messages:>{Error::MALDINumberOfShotsTooSmall,Error::InvalidOption}
		],
		Example[{Messages,"MALDICalibrantNumberOfShotsTooSmall","CalibrantNumberOfShots should be larger than ShotsPerRaster to in order to finish at least one run of data collection:"},
			ExperimentMassSpectrometry[
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->MALDI,
				CalibrantNumberOfShots->100,
				ShotsPerRaster->150
			],
			$Failed,
			Messages:>{Error::MALDICalibrantNumberOfShotsTooSmall,Error::InvalidOption}
		],
		Example[{Messages,"LowMinMass", "Returns a warning if lower limit of the mass range falls into a range that is known to produce spectra of lower quality due to a high quantity of background peaks in ESI:"},
			ExperimentMassSpectrometry[
				Object[Sample,"775 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->ESI,
				MassDetection->Span[75*Dalton,2000*Dalton]
			],
			ObjectP[Object[Protocol,MassSpectrometry]],
			Messages:>{Warning::LowMinMass,Warning::AliquotRequired}
		],
		Example[{Messages,"CalibrantMassDetectionMismatch", "In ESI-QTOF mass spectrometry measurements, returns a warning if a calibrant is chosen that does not cover the mass range that was automatically resolved to due to the sample's molecular weight or sample type:"},
			ExperimentMassSpectrometry[
				Object[Sample,"5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->ESI,
				Calibrant->Model[Sample,StockSolution,Standard,"Sodium Formate ESI Calibrant"]
			],
			ObjectP[Object[Protocol,MassSpectrometry]],
			Messages:>{Warning::CalibrantMassDetectionMismatch,Warning::IncompatibleCalibrant,Warning::AliquotRequired}
		],
		Example[{Messages,"MassSpectrometryIncompatibleAliquotContainer",
			"Returns an error if a AliquotContainer is supplied that is not compatible with the mass spectrometry system:"},
			ExperimentMassSpectrometry[
				Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->ESI,
				AliquotContainer->Model[Container,Vessel,"2mL Tube"]
			],
			$Failed,
			Messages:>{Error::MassSpectrometryIncompatibleAliquotContainer,Error::InvalidOption,Error::AliquotContainers}
		],
		Example[{Messages,"InstrumentPrecision", "The precision of the ESICapillaryVoltage cannot be not more than 0.01 Kilovolt, the maximum precision achievable by the instrumentation:"},
			Lookup[
				ExperimentMassSpectrometry[Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],ESICapillaryVoltage->2.5555 Kilovolt,Output->Options],
				ESICapillaryVoltage
			],
			2.56 Kilovolt,
			Messages:>{Warning::InstrumentPrecision},
			EquivalenceFunction->Equal
		],
		Example[{Messages,"TooManyESISamples","Returns an error if the number of measurements (number of samples * number of replicates) is not supported by the experiment:"},
			ExperimentMassSpectrometry[
				Table[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],25],
				IonSource->ESI
			],
			$Failed,
			Messages:>{Error::TooManyESISamples,Error::InvalidInput}
		],
		Example[{Messages,"IncompatibleMassDetection","Returns an error if the mass spectrometer cannot support the requested mass range:"},
			ExperimentMassSpectrometry[
				Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->ESI,
				MassDetection->Span[1000*Dalton,101000*Dalton]
			],
			$Failed,
			Messages:>{Error::IncompatibleMassDetection,Error::InvalidOption}
		],
		Example[{Messages,"EmptyContainers","Prints a message and returns $Failed if given any empty containers:"},
			ExperimentMassSpectrometry[{Object[Container, Plate, "Test Plate for ExperimentMassSpectrometry"<>$SessionUUID],Object[Container,Plate,"Empty Container for ExperimentMassSpectrometry"<>$SessionUUID]}],
			$Failed,
			Messages:>{Error::EmptyContainers}
		],
		Test["When running tests returns False if given any empty containers:",
			ValidExperimentMassSpectrometryQ[{Object[Container, Plate, "Test Plate for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Container,Plate,"Empty Container for ExperimentMassSpectrometry"<>$SessionUUID]}],
			False
		],
		Example[{Messages,"DuplicateName","The protocol must be given a unique name:"},
			ExperimentMassSpectrometry[Object[Sample, "Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI,Name->"Existing Mass Spec Protocol"<>$SessionUUID],
			$Failed,
			Messages:>{
				Error::DuplicateName,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnknownMolecularWeight","Options cannot be properly validated for MALDI mass spectrometry experiments, if samples are missing their molecular weights:"},
			ExperimentMassSpectrometry[Object[Sample,"Missing Molecular Weight Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI],
			ObjectP[Object[Protocol,MassSpectrometry]],
			Messages:>{Warning::UnknownMolecularWeight}
		],
		Test["When running tests, options cannot be properly validated if samples are missing their molecular weights:",
			ValidExperimentMassSpectrometryQ[Object[Sample,"Missing Molecular Weight Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI],
			True
		],
		Example[{Messages,"InstrumentPrecision","The precision of the SampleVolume cannot be not more than 0.1 Microliter, the maximum precision achievable by ECL liquid handlers:"},
			Lookup[
				ExperimentMassSpectrometry[Object[Sample, "Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],SampleVolume->1.112 Microliter,Output->Options],
				SampleVolume
			],
			1.1 Microliter,
			Messages:>{Warning::InstrumentPrecision},
			EquivalenceFunction->Equal
		],
		Test["When running tests the precision of the SampleVolume cannot be not more than 0.1 Microliter, the maximum precision achievable by ECL liquid handlers:",
			ValidExperimentMassSpectrometryQ[Object[Sample, "Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],SampleVolume->1.112 Microliter,Output->Options],
			True
		],
		Example[{Messages,"InstrumentPrecision","The precision of the SpottingDryTime cannot be not more than 1 minute, the maximum precision achievable by ECL liquid handlers :"},
			Lookup[
				ExperimentMassSpectrometry[Object[Sample, "Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],SpottingDryTime->641 Second,Output->Options],
				SpottingDryTime
			],
			11 Minute,
			EquivalenceFunction->Equal,
			Messages:>{Warning::InstrumentPrecision}
		],

		Example[{Messages,"MassSpecRequiredOptions","If IonSource is specified to ESI, no ESI specific options can be set to Null (while MALDI specific options can):"},
			Lookup[
				ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Instrument -> Automatic,
					IonSource -> ESI,
					SourceTemperature->Null, (* this is ESI specific Option *)
					GridVoltage->Null,
					Output->Options
				],
				{IonSource,Instrument}],
			{ESI,ObjectReferenceP[Model[Instrument, MassSpectrometer, "Xevo G2-XS QTOF"]]},
			Messages:>{Error::MassSpecRequiredOptions,Error::InvalidOption}
		],
		Example[{Messages,"MassSpectrometryNotEnoughVolume","Sample volumes is large enougth to finish the experiment:"},
			ExperimentMassSpectrometry[
				{"myTestSample1", "myTestSample1"},
				MassAnalyzer -> QTOF,
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "myTestSample1",
						Container -> Model[Container, Vessel,"Narrow Mouth Plastic Reservoir Bottle, 30mL, for Xevo G2-XS QTOF"]],
					LabelContainer[
						Label -> "myTestSample2",
						Container -> Model[Container, Vessel,"Narrow Mouth Plastic Reservoir Bottle, 30mL, for Xevo G2-XS QTOF"]
					],
					Transfer[
						Source -> Model[Sample, "0.1% Formic acid in Water"],
						Destination -> "myTestSample1", Amount -> 2.0 Milliliter
					],
					Transfer[
						Source -> Model[Sample, "0.1% Formic acid in Water"],
						Destination -> "myTestSample2", Amount -> 2.0 Milliliter
					]
				},
				InjectionType -> DirectInfusion
			],
			$Failed,
			Messages:>{Error::MassSpectrometryNotEnoughVolume,Error::InvalidInput}
		],
	(* TESTS *)
		Test["When running tests the precision of the DryTime cannot be not more than 1 minute, the maximum precision achievable by ECL liquid handlers :",
			ValidExperimentMassSpectrometryQ[Object[Sample, "Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],SpottingDryTime->641 Second,Output->Options],
			True
		],
		Example[{Messages,"IncompatibleCalibrant","Throws a warning if there are no peaks in the calibrant to the left or to the right of the sample:"},
			ExperimentMassSpectrometry[Object[Sample,"17000 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Calibrant->Model[Sample, StockSolution, Standard, "id:lYq9jRxAdz1V"],
				IonSource->MALDI
			],
			ObjectP[Object[Protocol,MassSpectrometry]],
			Messages:>{Warning::IncompatibleCalibrant}
		],
		Test["When running tests they will still pass if there are no peaks in the calibrant to the left or to the right of the sample:",
			ValidExperimentMassSpectrometryQ[Object[Sample,"17000 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->MALDI,
				Calibrant->Model[Sample, StockSolution, Standard, "id:lYq9jRxAdz1V"]],
			True
		],
		Test["When running tests returns False if the min mass is greater than the max mass:",
			ValidExperimentMassSpectrometryQ[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI,MassDetection->Span[10000 Dalton,2000 Dalton]],
			False
		],
		Example[{Messages,"InvalidLaserPowerRange","The maximum laser power requested must be less the minimum requested laser power:"},
			ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],LaserPowerRange->Span[90 Percent,20 Percent]],
			$Failed,
			Messages:>{Error::InvalidLaserPowerRange,Error::InvalidOption}
		],
		Test["When running tests the maximum laser power requested must be less the minimum requested laser power:",
			ValidExperimentMassSpectrometryQ[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],LaserPowerRange->Span[90 Percent,20 Percent]],
			False
		],
		Example[{Messages,"InvalidCalibrantLaserPowerRange","The calibrant laser power range is specified as Span[minPower,maxPower] and so minPower must be less than maxPower:"},
			ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],CalibrantLaserPowerRange->Span[10 Percent, 10 Percent]],
			$Failed,
			Messages:>{Error::InvalidCalibrantLaserPowerRange,Error::InvalidOption}
		],
		Test["When running tests the calibrant laser power range is specified as Span[minPower,maxPower] and so minPower must be less than maxPower:",
			ValidExperimentMassSpectrometryQ[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],CalibrantLaserPowerRange->Span[10 Percent, 10 Percent]],
			False
		],
		Example[{Messages,"UnsupportedMALDIPlate","Print a message and returns $Failed if the model of the requested MALDI plate is not supported:"},
			ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MALDIPlate->Object[Container,Plate,"Empty Container for ExperimentMassSpectrometry"<>$SessionUUID]],
			$Failed,
			Messages:>{Error::UnsupportedMALDIPlate,Error::InvalidOption}
		],
		Test["When running tests returns False if the model of the requested MALDI plate is not supported:",
			ValidExperimentMassSpectrometryQ[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MALDIPlate->Object[Container,Plate,"Empty Container for ExperimentMassSpectrometry"<>$SessionUUID]],
			False
		],
		Test["When running tests they will still pass if the molecular weight of the sample is outside of the supplied mass range:",
			ValidExperimentMassSpectrometryQ[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI,MassDetection->Span[3500 Dalton,6500 Dalton]],
			True
		],
		Test["Resolves the mass range when there are only two calibrant peaks, both to the left of the sample:",
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 4 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Calibrant->Model[Sample,StockSolution,Standard,"Two Peak Calibrant Model for ExperimentMassSpectrometry"<>$SessionUUID],
					IonSource->MALDI
				],
				{MinMasses,MaxMasses}
			],
			{{9750 Dalton},{15250 Dalton}},
			Messages:>{Warning::IncompatibleCalibrant,Warning::LimitedReferencePeaks, Warning::AliquotRequired},
			EquivalenceFunction->Equal,
			Stubs:>{$DeveloperSearch=True, $RequiredSearchName = $SessionUUID}
		],
		Test["Gracefully handles the case where the calibrant only has a single reference peak:",
			Lookup[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Calibrant->Model[Sample,StockSolution,Standard,"One Peak Calibrant Model for ExperimentMassSpectrometry"<>$SessionUUID],
					IonSource->MALDI,
					Output->Options],
				MassDetection
			],
			Span[1000 Dalton,10000 Dalton],
			Messages:>{Error::UnableToCalibrate,Warning::IncompatibleCalibrant,Warning::AliquotRequired,Error::InvalidOption},
			EquivalenceFunction->Equal,
			Stubs:>{$DeveloperSearch=True, $RequiredSearchName = $SessionUUID}
		],
		Test["Handles the case where all calibrant peaks are to the left of the sample's molecular weight:",
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 4 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Calibrant->Model[Sample,StockSolution,Standard,"Low Weight Calibrant Model for ExperimentMassSpectrometry"<>$SessionUUID],
					IonSource->MALDI
				],
				{MinMasses,MaxMasses}
			],
			{{7500 Dalton},{15250 Dalton}},
			Messages:>{Warning::IncompatibleCalibrant, Warning::AliquotRequired},
			EquivalenceFunction->Equal,
			Stubs:>{$DeveloperSearch=True, $RequiredSearchName = $SessionUUID}
		],
		Test["Handles the case where the 3 closest calibrant peaks are to the left of the sample's molecular weight:",
			Download[
				ExperimentMassSpectrometry[Object[Sample,"5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Calibrant->Model[Sample,StockSolution,Standard,"Low Weight Calibrant Model for ExperimentMassSpectrometry"<>$SessionUUID],
					IonSource->MALDI
				],
				{MinMasses,MaxMasses}
			],
			{{4500 Dalton},{7750 Dalton}},
			EquivalenceFunction->Equal,
			Stubs:>{$DeveloperSearch=True, $RequiredSearchName = $SessionUUID},
			Messages:>{Warning::AliquotRequired}
		],
		Test["Handles the case where the 3 closest calibrant peaks are to the right of the sample's molecular weight:",
			Download[
				ExperimentMassSpectrometry[Object[Sample,"17000 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Calibrant->Model[Sample,StockSolution,Standard,"High Weight Calibrant Model for ExperimentMassSpectrometry"<>$SessionUUID],
					IonSource->MALDI
				],
				{MinMasses,MaxMasses}
			],
			{{14250 Dalton},{18000 Dalton}},
			EquivalenceFunction->Equal,
			Stubs:>{$DeveloperSearch=True, $RequiredSearchName = $SessionUUID},
			Messages:>{Warning::AliquotRequired}
		],
	
		Test["DelayTime and GridVoltage are set to the user specified values:",
			Download[
				ExperimentMassSpectrometry[Object[Sample,"5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],GridVoltage->16.5 Kilovolt,DelayTime->175 Nanosecond],
				{DelayTimes,GridVoltages}
			],
			{{175 Nanosecond},{16.5 Kilovolt}},
			EquivalenceFunction->Equal
		],

		Example[{Messages,"TooManyMALDISamples",
			"For MALDI mass spectrometry measurements, if the number of input samples with replicates exceeds the number of wells on the MALDI plate, an experiment cannot be generated:"},
			ExperimentMassSpectrometry[{
				Object[Sample, "Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample, "Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				NumberOfReplicates->50,
				IonSource->MALDI
			],
			$Failed,
			Messages:>{Error::TooManyMALDISamples,Error::InvalidOption}
		],
		Test["When running tests if the number of input samples with replicates exceeds the number of wells on the MALDI plate, an experiment cannot be generated:",
			ValidExperimentMassSpectrometryQ[{Object[Sample, "Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample, "Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},IonSource->MALDI,NumberOfReplicates->50],
			False
		],

		Example[{Messages,"ExceedsMALDIPlateCapacity","In MALDI mass spectrometry measurements, if the total number of spots required, given calibrant spots and matrix control spots, exceeds the number of wells on the MALDI plate, an experiment cannot be generated. Note that the number of matrix and calibrant spots can be decreased by using fewer unique settings:"},
			ExperimentMassSpectrometry[{
				Object[Sample, "Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample, "Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
				},
				NumberOfReplicates->48,
				IonSource->MALDI
			],
			$Failed,
			Messages:>{Error::ExceedsMALDIPlateCapacity},
			TimeConstraint->1200
		],
		Test["When running tests if the total number of spots required, given calibrant spots and matrix control spots,	exceeds the number of wells on the MALDI plate, an experiment cannot be generated. Note that the number of matrix and calibrant spots can be decreased by using fewer unique settings:",
			ValidExperimentMassSpectrometryQ[{Object[Sample, "Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample, "Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},IonSource->MALDI,NumberOfReplicates->48],
			False,
			TimeConstraint->1200
		],

		Example[{Messages,"UnableToCalibrate","In MALDI measurements, at least one calibrant reference peak must fall in the mass range for the instrument to be calibrated:"},
			ExperimentMassSpectrometry[Object[Sample,"Oligomer 3 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->MALDI,
				MassDetection->Span[7700 Dalton,9000 Dalton]
			],
			$Failed,
			Messages:>{Error::UnableToCalibrate,Error::InvalidOption}
		],
		Test["When running tests at least one calibrant reference peak must fall in the mass range for the instrument to be calibrated:",
			ValidExperimentMassSpectrometryQ[Object[Sample,"Oligomer 3 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->MALDI,MassDetection->Span[7700 Dalton,9000 Dalton]],
			False
		],

		Example[{Messages,"LimitedReferencePeaks","If there are only two calibrant peaks in the mass range,	the instrument can still be calibrated, but there may be more error in the calibration:"},
			ExperimentMassSpectrometry[Object[Sample,"Oligomer 3 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassDetection->Span[7500 Dalton,9200 Dalton],
				IonSource->MALDI
			],
			ObjectP[Object[Protocol,MassSpectrometry]],
			Messages:>{Warning::LimitedReferencePeaks}
		],
		Test["When running tests if there are only two calibrant peaks in the mass range, the instrument can still be calibrated, but there may be more error in the calibration:",
			ValidExperimentMassSpectrometryQ[Object[Sample,"Oligomer 3 Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI,MassDetection->Span[7500 Dalton,9200 Dalton]],
			True
		],
		Test["When running tests for the most accurate results the calibrant peaks in the mass range should flank the sample's molecular weight:",
			ValidExperimentMassSpectrometryQ[Object[Sample, "Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI,MassDetection->Span[3000 Dalton,6500 Dalton]],
			True
		],
		
		Example[{Messages,"SpottingInstrumentIncompatibleAliquots","For MALDI mass spectrometry measurements, in order to spot the MALDI plate, aliquots must be able to fit on a liquid handler. If the aliquot volume is too large, an error will be thrown:"},
			ExperimentMassSpectrometry[Object[Sample,"Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI,AliquotAmount->100 Milliliter],
			$Failed,
			Messages:>{Error::SpottingInstrumentIncompatibleAliquots,Error::VolumeOverContainerMax,Error::InvalidOption,Error::InvalidOption}
		],
		Test["When running tests in order to spot the MALDI plate, aliquots must be able to fit on a liquid handler. If the aliquot volume is too large, an error will be thrown:",
			ValidExperimentMassSpectrometryQ[Object[Sample,"Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI,AliquotAmount->100 Milliliter],
			False
		],

		Example[{Messages,"AliquotOptionConflict","Aliquot cannot be set to false if the current sample container cannot fit on the liquid handler deck:"},
			ExperimentMassSpectrometry[Object[Sample,"Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI,Aliquot->False],
			$Failed,
			Messages:>{Error::AliquotOptionConflict,Error::InvalidOption}
		],

		Example[{Messages,"AliquotRequired","For MALDI mass spectrometry measurements, if the current sample container cannot fit on the liquid handler deck, it must be aliquoted:"},
			Lookup[
				Download[
					ExperimentMassSpectrometry[Object[Sample,"Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI],AliquotSamplePreparation],
				Aliquot
			],
			{True..},
			Messages:>{Warning::AliquotRequired}
		],

		Test["Does not throw an AliquotRequired warning if the user asked for aliquoting directly or indirectly:",
			{
				ExperimentMassSpectrometry[Object[Sample,"Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI,AssayVolume->1100 Microliter],
				ExperimentMassSpectrometry[Object[Sample,"Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI,Aliquot->True]
			},
			{ObjectP[Object[Protocol,MassSpectrometry]],ObjectP[Object[Protocol,MassSpectrometry]]},
			TimeConstraint -> 240
		],

		Test["When running tests recognizes that it's a soft error if the current sample container cannot fit on the liquid handler deck:",
			ValidExperimentMassSpectrometryQ[Object[Sample,"Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI],
			True
		],

		Test["Creates new calibration methods for unique calibration settings, but uses an existing calibration method when possible:",
			Module[{protocol,calibrationMethods,numberOfNewMethods},
				protocol=ExperimentMassSpectrometry[
					{
						Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
						Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
						Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
					},
					IonSource-> MALDI,
					IonMode -> Positive,
					Matrix -> Model[Sample, Matrix, "id:o1k9jAKOwwvG"],
					Calibrant -> Model[Sample, StockSolution, Standard, "Low Weight Calibrant Model for ExperimentMassSpectrometry"<>$SessionUUID],
					SpottingMethod -> Sandwich,
					MassDetection -> Span[3501 Gram/Mole,8001 Gram/Mole],
					AccelerationVoltage -> {4.12 Kilovolt,4.5 Kilovolt,4.12 Kilovolt},
					GridVoltage -> {3.98 Kilovolt,4.5 Kilovolt,3.98 Kilovolt},
					LensVoltage -> 7 Kilovolt,
					DelayTime -> 100 Nanosecond,
					LaserPowerRange-> Span[65 Percent,85 Percent],
					ShotsPerRaster -> 12,
					NumberOfShots -> 500
				];

				calibrationMethods=Download[protocol,CalibrationMethods[Object]];

				numberOfNewMethods=Length[DeleteDuplicates[calibrationMethods]];

				{calibrationMethods,numberOfNewMethods}
			],
			{
				{
					ObjectP[Object[Method,MassSpectrometryCalibration,"Existing Method for ExperimentMassSpectrometry"<>$SessionUUID]],
					Except[Object[Method,MassSpectrometryCalibration,"Existing Method for ExperimentMassSpectrometry"<>$SessionUUID],ObjectP[Object[Method,MassSpectrometryCalibration]]],
					ObjectP[Object[Method,MassSpectrometryCalibration,"Existing Method for ExperimentMassSpectrometry"<>$SessionUUID]]
				},
				2
			},
			Stubs:>{$DeveloperSearch=True, $RequiredSearchName = $SessionUUID},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Messages,"InvalidMatrixSample","When an Object[Sample] is specified for Matrix whose model is not Model[Sample, Matrix], the function returns $Failed with an error message:"},
			ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Matrix -> Object[Sample, "Sample without a parent Model Matrix Sample for ExperimentMassSpectrometry" <> $SessionUUID]],
			$Failed,
			Messages :> {Error::InvalidMatrixSample, Error::InvalidOption}
		],
		Example[{Messages,"InvalidCalibrantMatrixSample","When an Object[Sample] is specified for CalibrantMatrix whose model is not Model[Sample, Matrix], the function returns $Failed with an error message:"},
					ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], CalibrantMatrix -> Object[Sample, "Sample without a parent Model Matrix Sample for ExperimentMassSpectrometry" <> $SessionUUID]],
					$Failed,
					Messages :> {Error::InvalidCalibrantMatrixSample, Error::InvalidOption}
		],
		Example[{Messages,"UninformedMatrix","When a Matrix is specified, the model for that Matrix must have both SpottingDryTime and SpottingVolume informed, otherwise, the function returns $Failed with an error message:"},
			ExperimentMassSpectrometry[{Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]}, Matrix -> {Model[Sample, Matrix, "Model Matrix without SpottingDryTime informed Sample for ExperimentMassSpectrometry" <> $SessionUUID], Model[Sample, Matrix, "Model Matrix without SpottingVolume informed Sample for ExperimentMassSpectrometry" <> $SessionUUID]}],
			$Failed,
			Messages :> {Error::UninformedModelMatrix, Error::InvalidOption}
		],
		Example[{Messages,"UninformedCalibrantMatrix","When a CalibrantMatrix is specified, the model for that CalibrantMatrix must have both SpottingDryTime and SpottingVolume informed, otherwise, the function returns $Failed with an error message:"},
			ExperimentMassSpectrometry[{Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]}, CalibrantMatrix -> {Object[Sample, "Matrix without SpottingDryTime informed Sample for ExperimentMassSpectrometry" <> $SessionUUID], Object[Sample, "Matrix without SpottingVolume informed Sample for ExperimentMassSpectrometry" <> $SessionUUID]}],
			$Failed,
			Messages :> {Error::UninformedModelCalbirantMatrix, Error::InvalidOption}
		],
		(*ESI-QQQ specific messages*)
		(*ESI QTOF new options*)
		Example[{Messages,"InvalidESIQTOFVoltagesOption","For ESI-QTOF, All voltages (ESICappilaryVoltages and StepwaveVoltages)input needs to be positive:"},
			ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				ESICapillaryVoltage -> -2.5*Kilovolt, IonSource -> ESI,
				MassAnalyzer -> QTOF],
			$Failed,
			Messages:>{Error::InvalidESIQTOFVoltagesOption,Error::InvalidOption}
		],
		Example[{Messages,"InvalidESIQTOFGasOption","For ESI-QTOF, All Gas options (DesolvationGasFlow and ConeGasFlows)input needs to be with a unit of flow rage:"},
			ExperimentMassSpectrometry[
				Object[Sample,
					"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				DesolvationGasFlow -> 50 PSI, IonSource -> ESI,
				MassAnalyzer -> QTOF],
			$Failed,
			Messages:>{Error::InvalidESIQTOFGasOption,Error::InvalidOption}
		],
		Example[{Messages,"InvalidESIQTOFMassDetectionOption","For ESI-QTOF,the MassDetection option can only be a span of mass values.:"},
			ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassDetection -> 666 Gram/Mole, IonSource -> ESI,
				MassAnalyzer -> QTOF],
			$Failed,
			Messages:>{Error::InvalidESIQTOFMassDetectionOption,Error::InvalidOption}
		],
		Example[{Messages,"OutRangedDesolvationTemperature","For ESI-QTOF, All voltages (ESICappilaryVoltages and StepwaveVoltages)input needs to be positive:"},
			ExperimentMassSpectrometry[
				Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				DesolvationTemperature -> 717 Celsius, IonSource -> ESI,
				MassAnalyzer -> QTOF],
			$Failed,
			Messages:>{Error::OutRangedDesolvationTemperature,Error::InvalidOption}
		],

		(*ESI-QQQ Tandem Mass Messages*)
		Example[{Messages,"UnneededTandemMassSpecOptions","For ESI-QQQ, if Scan mode is full scan, the tandem mass specific options need to be Automatic or Null:"},
			ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				CollisionEnergy -> 10 Volt,
				CollisionCellExitVoltage -> Automatic,
				NeutralLoss -> Automatic,
				Fragment -> False,
				MultipleReactionMonitoringAssays -> Automatic,
				ScanMode -> FullScan
			],
			$Failed,
			Messages:>{Error::UnneededTandemMassSpecOptions,Error::InvalidOption}
		],
		Example[{Messages,"OutRangedDesolvationTemperature","For ESI-QTOF, DesolvationTemperature should be smaller thatn 650 Celsius:"},
			ExperimentMassSpectrometry[
				Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				DesolvationTemperature -> 717 Celsius, IonSource -> ESI,
				MassAnalyzer -> QTOF],
			$Failed,
			Messages:>{Error::OutRangedDesolvationTemperature,Error::InvalidOption}
		],
		Example[{Messages,"InvalidSourceTemperatures","For ESI-QQQ, the source temperature should be 150 Celsius:"},
			ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				SourceTemperature -> 141 Celsius, IonSource -> ESI,
				MassAnalyzer -> TripleQuadrupole],
			$Failed,
			Messages:>{Error::InvalidSourceTemperatures,Error::InvalidOption}
		],
		Example[{Messages,"InvalidDesolvationGasFlows","For ESI-QQQ, the DesolvationGasFlow needs to have a unit of pressure (e.g. PSI):"},
			ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				DesolvationGasFlow -> 5 Liter/Minute, IonSource -> ESI,
				MassAnalyzer -> TripleQuadrupole],
			$Failed,
			Messages:>{Error::InvalidDesolvationGasFlows,Error::InvalidOption}
		],
		Example[{Messages,"InvalidConeGasFlow","For ESI-QQQ, the ConeGasFlow needs to have a unit of pressure (e.g. PSI):"},
			ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				ConeGasFlow -> 5 Liter/Minute, IonSource -> ESI,
				MassAnalyzer -> TripleQuadrupole],
			$Failed,
			Messages:>{Error::InvalidConeGasFlow,Error::InvalidOption}
		],
		Example[{Messages,"InfusionVolumeLessThanRunDurationTimesFlowRate","If the infusion volume is less than the product of run duration and flow rate a Warning is issued:"},
			ExperimentMassSpectrometry[{
				Object[Sample, "Oligomer 1 Sample for ExperimentMassSpectrometry" <> $SessionUUID], Object[Sample, "Oligomer 2 Sample for ExperimentMassSpectrometry" <> $SessionUUID], Object[Sample, "Oligomer 3 Sample for ExperimentMassSpectrometry" <> $SessionUUID]},
				IonSource -> ESI, InjectionType -> DirectInfusion, MassAnalyzer -> TripleQuadrupole, InfusionVolume -> 0.5 Milliliter, InfusionFlowRate -> 0.5 Milliliter/Minute, RunDuration -> 2 Minute],
			ObjectP[Object[Protocol, MassSpectrometry]],
			Messages :> {Warning::InfusionVolumeLessThanRunDurationTimesFlowRate}
		],
		Example[{Messages,"InvalidInfusionSyringes","For ESI-QQQ in DirectInfusion, syringes needs to be allowed:"},
			ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				InfusionSyringe -> {Model[Container, Syringe, "id:KBL5Dvw9LKjj"]},
				IonSource -> ESI, MassAnalyzer -> TripleQuadrupole],
			$Failed,
			Messages:>{Error::InvalidInfusionSyringes,Error::InvalidOption}
		],
		Example[{Messages,"InvalidInfusionVolumes","For ESI-QQQ in DirectInfusion, Infusion volumes should be valid value:"},
			ExperimentMassSpectrometry[
				Object[Sample, "Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole, IonSource -> ESI,
				InjectionType -> DirectInfusion,
				InfusionSyringe -> Model[Container, Syringe, "1mL All-Plastic Disposable Syringe"],
				InfusionVolume -> 1.1*Milliliter
			],
			$Failed,
			Messages:>{Error::InvalidInfusionVolumes,Error::InvalidOption}
		],
		Example[{Messages,"InvalidMassToleranceInputs","For ESI-QQQ, MassTolerance should only populated for ranged mass scan:"},
			ExperimentMassSpectrometry[
				Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				FragmentMassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				CollisionCellExitVoltage -> 35 Volt, MassTolerance -> 0.5 Gram/Mole
			],
			$Failed,
			Messages:>{Error::InvalidMassToleranceInputs,Error::InvalidOption}
		],
		Example[{Messages,"FragmentScanModeMisMatches","For ESI-QQQ, the Fragment option match the corresponding ScanMode:"},
			ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				ScanMode -> SelectedIonMonitoring,
				Fragment -> True
			],
			$Failed,
			Messages:>{Error::FragmentScanModeMisMatches,Error::InvalidOption}
		],
		Example[{Messages,"MassDetectionScanModeMismatches","For ESI-QQQ, the MassDetection option match the corresponding ScanMode:"},
			ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				ScanMode -> FullScan
			],
			$Failed,
			Messages:>{Error::MassDetectionScanModeMismatches,Error::InvalidOption}
		],
		Example[{Messages,"FragmentMassDetectionScanModeMismatches","For ESI-QQQ, the FragmentMassDetection option match the corresponding ScanMode:"},
			ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				FragmentMassDetection -> {111 Gram/Mole, 222 Gram/Mole,	333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				ScanMode -> FullScan
			],
			$Failed,
			Messages:>{Error::MassDetectionScanModeMismatches,Error::FragmentMassDetectionScanModeMismatches,Error::UnneededTandemMassSpecOptions,Error::InvalidOption}
		],
		Example[{Messages,"UnneededTandemMassSpecOptions","For ESI-QQQ, the unneeded tandem mass options are not presented:"},
			ExperimentMassSpectrometry[
				Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				MassDetection -> Span[200 Gram/Mole, 800 Gram/Mole],
				ScanMode -> FullScan, CollisionEnergy -> 40 Volt
			],
			$Failed,
			Messages:>{Error::UnneededTandemMassSpecOptions,Error::InvalidOption}
		],
		Example[{Messages,"VoltageInputIonModeMisMatches","For ESI-QQQ, the voltage options (ESICapillaryVoltages, IonGuideVoltages, CollisionEnergy, CollisionCellExitingEnergy) options match the corresponding IonMode:"},
			ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole, IonMode -> Negative,
				MassDetection -> Span[200 Gram/Mole, 800 Gram/Mole],
				FragmentMassDetection -> 345 Gram/Mole, CollisionEnergy -> 40 Volt
			],
			$Failed,
			Messages:>{Error::VoltageInputIonModeMisMatches,Error::InvalidOption}
		],
		Example[{Messages,"TooShortRunDurations","For ESI-QQQ, the RunDuration Options is long enough to finish at least one full mass scan:"},
			ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole, IonMode -> Positive,
				MultipleReactionMonitoringAssays -> {{123 Gram/Mole, 30 Volt, 234 Gram/Mole, 2 Second}, {235 Gram/Mole, 30 Volt, 345 Gram/Mole, 2 Second}, {235 Gram/Mole, 30 Volt, 345 Gram/Mole, 2 Second}, {235 Gram/Mole, 30 Volt, 345 Gram/Mole, 2 Second}},
				RunDuration -> 0.1 Minute
			],
			$Failed,
			Messages:>{Error::TooShortRunDurations,Error::InvalidOption}
		],
		Example[{Messages,"InputOptionsMRMAssaysMismatches","For ESI-QQQ, the MultipleReactionMonitoringAssays option matches the corresponding MassDetections, CollisionEnergy,FragmentMassDetection and DwellTime options:"},
			ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole},
				FragmentMassDetection -> {111 Gram/Mole, 222 Gram/Mole, 444 Gram/Mole},
				DwellTime -> {110 Millisecond, 120 Millisecond, 130 Millisecond},
				MultipleReactionMonitoringAssays -> {{111 Gram/Mole, Automatic, 234 Gram/Mole, 2 Second}, {222 Gram/Mole, Automatic, 345 Gram/Mole, 2 Second}, {333 Gram/Mole, Automatic, 345 Gram/Mole, 2 Second}}],
			$Failed,
			Messages:>{Error::InputOptionsMRMAssaysMismatches,Error::InvalidOption}
		],
		Example[{Messages,"InvalidMultipleReactionMonitoringLengthOfInputOptions","The corresponding MassDetections, CollisionEnergy,FragmentMassDetection and DwellTime options have same length for the MultipleReactionMonitoring as the ScanMode:"},
			ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				MassDetection -> {111 Gram/Mole, 222 Gram/Mole, 333 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				FragmentMassDetection -> {111 Gram/Mole, 222 Gram/Mole, 444 Gram/Mole, 555 Gram/Mole},
				DwellTime -> {110 Millisecond, 120 Millisecond, 130 Millisecond, 140 Millisecond}],
			$Failed,
			Messages:>{Error::InvalidMultipleReactionMonitoringLengthOfInputOptions,Error::InvalidOption}
		],
		Example[{Messages,"FlowInjectionUnneededOptions","For ESI-QQQ, if Injection type is specified as FlowInjection, then options related to DirectInfusion (using syringe) are set to either Automatic or Null:"},
			ExperimentMassSpectrometry[{
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				MassAnalyzer->TripleQuadrupole,
				InjectionType->FlowInjection,
				InfusionVolume->0.66Milliliter],
			$Failed,
			Messages:>{Error::FlowInjectionUnneededOptions,Error::InvalidOption}
		],

		(*--- ESI-QQQ Warnings*)
		Example[{Messages,"TooManyMultpleReactionMonitoringAssays","For ESI-QQQ, throw a warning if user specified too many MultipleReactionMonitoringAssays (>10):"},
			ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole, IonMode -> Positive,
				MultipleReactionMonitoringAssays -> {{123 Gram/Mole, 30 Volt,234 Gram/Mole, 2 Second}, {235 Gram/Mole, 30 Volt, 345 Gram/Mole, 2 Second}, {235 Gram/Mole, 30 Volt, 345 Gram/Mole, 2 Second}, {235 Gram/Mole, 30 Volt, 345 Gram/Mole, 2 Second}, {123 Gram/Mole, 30 Volt, 234 Gram/Mole, 2 Second}, {123 Gram/Mole, 30 Volt, 234 Gram/Mole, 2 Second}, {123 Gram/Mole, 30 Volt, 234 Gram/Mole, 2 Second}, {123 Gram/Mole, 30 Volt, 234 Gram/Mole, 2 Second}, {123 Gram/Mole, 30 Volt, 234 Gram/Mole, 2 Second}, {123 Gram/Mole, 30 Volt, 234 Gram/Mole, 2 Second}, {123 Gram/Mole, 30 Volt, 234 Gram/Mole, 2 Second}, {123 Gram/Mole, 30 Volt, 234 Gram/Mole, 2 Second}}],
			ObjectP[Object[Protocol,MassSpectrometry]],
			Messages:>{Warning::TooManyMultpleReactionMonitoringAssays}
		],
		Example[{Messages,"AutoNeutralLossValueWarnings","For ESI-QQQ, throw a warning if user didn't specified NeutralLoss in NeutralIonLoss mode:"},
			ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				MassDetection -> Span[100 Gram/Mole, 600 Gram/Mole],
				ScanMode -> NeutralIonLoss],
			ObjectP[Object[Protocol,MassSpectrometry]],
			Messages:>{Warning::AutoNeutralLossValueWarnings}
		],
		Example[{Messages,"AutoResolvedMassDetectionFixedValue","For ESI-QQQ, throw a warning if user didn't specified a fixed MassDetection value in ProductIonScan mode:"},
			ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				FragmentMassDetection -> Span[100 Gram/Mole, 200 Gram/Mole],
				ScanMode -> ProductIonScan],
			ObjectP[Object[Protocol,MassSpectrometry]],
			Messages:>{Warning::AutoResolvedMassDetectionFixedValue}
		],
		Example[{Messages,"AutoResolvedFragmentMassDetectionFixedValues","For ESI-QQQ, throw a warning if user didn't specified a fixed FragmentMassDetection value in PrecursorIonScan mode:"},
			ExperimentMassSpectrometry[
				Object[Sample, "Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				MassAnalyzer -> TripleQuadrupole,
				MassDetection -> Span[100 Gram/Mole, 600 Gram/Mole],
				ScanMode -> PrecursorIonScan],
			ObjectP[Object[Protocol,MassSpectrometry]],
			Messages:>{Warning::AutoResolvedFragmentMassDetectionFixedValues}
		],
		Example[{Messages,"invalidMALDITOFMassDetectionOption","For MALDI-TOF, the input MassDetections are ranges of masses:"},
			ExperimentMassSpectrometry[{
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				IonSource->MALDI,
				MassDetection->{123Gram/Mole,456Gram/Mole}
			],
			$Failed,
			Messages:>{Error::invalidMALDITOFMassDetectionOption,Error::InvalidOption}
		],
		Test["A mix of samples and models can be specified for the matrix and calibrant:",
			Download[
				ExperimentMassSpectrometry[{
					Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
				},
					Calibrant->{Model[Sample,StockSolution,Standard,"Peptide/Protein Calibrant Mix"],Object[Sample,"Calibrant Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
					Matrix->{Model[Sample, Matrix, "HCCA MALDI matrix"],Object[Sample,"Matrix Sample for ExperimentMassSpectrometry"<>$SessionUUID]}
				],
				{Calibrants[Object],Matrices[Object],CalibrationMethods[Object]}
			],
			{
				{Model[Sample, StockSolution, Standard, "id:lYq9jRxAdz1V"],ObjectP[Object[Sample,"Calibrant Sample for ExperimentMassSpectrometry"<>$SessionUUID]]},
				{Model[Sample, Matrix, "id:E8zoYveRllLb"],ObjectP[Object[Sample,"Matrix Sample for ExperimentMassSpectrometry"<>$SessionUUID]]},
				{method_,method_} (* same method created since all models are the same *)
			}
		],
		Test["Setting Output -> Tests returns a list of tests (MALDI):",
			ExperimentMassSpectrometry[{Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},IonSource->MALDI,Output->Tests],
			{__EmeraldTest}
		],
		Test["Setting Output -> Tests returns a list of tests (ESI):",
			ExperimentMassSpectrometry[{Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},Output->Tests],
			{__EmeraldTest}
		],
		Test["Setting Output -> Preview returns Null:",
			ExperimentMassSpectrometry[{Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},Output->Preview],
			Null
		],
		Test["Setting Output -> Options returns a list of resolved options:",
			ExperimentMassSpectrometry[{Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},Output->Options],
			{(_Rule)..}
		],
		Test["Setting Output -> Tests returns a list of tests:",
			ExperimentMassSpectrometry[{Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},IonSource->MALDI, Output->Tests],
			{__EmeraldTest}
		],
		Test["Setting Output -> Preview returns Null:",
			ExperimentMassSpectrometry[{Object[Sample,"Oligomer 5 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},IonSource->MALDI, Output->Preview],
			Null
		],
		Test["Setting Output -> Options returns a list of resolved options:",
			ExperimentMassSpectrometry[{Object[Sample,"Oligomer 5 Sample for ExperimentMassSpectrometry"<>$SessionUUID]},IonSource->MALDI, Output->Options],
			{(_Rule)..}
		],

		Test["All the necessary protocol fields are populated in a flow injection ESI experiment:",
				protocol=ExperimentMassSpectrometry[{
					Object[Sample,"Oligomer 5 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
				},
					IonSource->ESI,
					InjectionType->FlowInjection
				];
				Download[protocol,{Buffer,NeedleWashSolution,SystemPrimeBuffer,SystemPrimeGradient,SystemPrimeBufferPlacements,SystemFlushBuffer,SystemFlushGradient,SystemFlushContainerPlacements}],
			{
				ObjectP[Model[Sample]],
				ObjectP[Model[Sample]],
				ObjectP[Model[Sample]],
				ObjectP[Object[Method,Gradient]],
				{{ObjectP[],{"Buffer A Slot"}}},
				ObjectP[Model[Sample]],
				ObjectP[Object[Method,Gradient]],
				{{ObjectP[],{"Buffer A Slot"}}}
			}
		],

		Test["All the necessary resources are created for a flow injection ESI experiment:",
			Module[{protocol,resources,models,resourceFields,allResourcesMade,needleWashResources,
				correctNeedleWashResources,correctNeedleWashModel,bufferResources,correctBufferResources,correctBufferModel},

				protocol=ExperimentMassSpectrometry[{
					Object[Sample,"Oligomer 5 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
				},
					IonSource->ESI,
					InjectionType->FlowInjection
				];

				resources=Download[protocol,RequiredResources];

				resourceFields=DeleteDuplicates[resources[[All,2]]];
				allResourcesMade=ContainsExactly[resourceFields,{SamplesIn,ContainersIn,Calibrants,Instrument,Buffer,NeedleWashSolution,SystemPrimeBuffer,SystemPrimeBufferPlacements,SystemFlushBuffer,SystemFlushContainerPlacements,NeedleWashPlacements,TubingRinseSolution,Checkpoints,Null}];

				(* we should have a single needle wash resource for all samples *)
				needleWashResources=Cases[resources,{_,NeedleWashSolution,___}][[All,1]][Object];
				correctNeedleWashResources=MatchQ[needleWashResources,{ObjectP[Object[Resource, Sample]]}];
				correctNeedleWashModel=MatchQ[Download[protocol,NeedleWashSolution],ObjectP[Model[Sample,StockSolution,"id:Z1lqpMzmp5MO"]]];

				(* we should have a single buffer resource for all samples *)
				bufferResources=Cases[resources,{_,Buffer,___}][[All,1]][Object];
				correctBufferResources=MatchQ[bufferResources,{ObjectP[Object[Resource, Sample]]}];
				correctBufferModel=MatchQ[Download[protocol,Buffer],ObjectP[Model[Sample,StockSolution,"id:XnlV5jKOd4Ko"]]];

				{allResourcesMade,correctNeedleWashResources,correctNeedleWashModel,correctBufferResources,correctBufferModel}
			],
			{True..}
		],

		Test["All the necessary resources are created for a MALDI mass spectrometry experiment:",
			Module[{protocol,resources,models,resourceFields,allResourcesMade,matrixResources,correctMatrixResources,
				calibrantResources,correctCalibrantResources,calibrantMatrixResources,correctCalibrantMatrixResources},
				protocol=ExperimentMassSpectrometry[{
					Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
					Object[Sample,"Oligomer 3 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
				},
					IonSource->MALDI,
					Calibrant->{Model[Sample,StockSolution,Standard,"Peptide/Protein Calibrant Mix"],
						Object[Sample,"Calibrant Sample for ExperimentMassSpectrometry"<>$SessionUUID],
						Model[Sample,StockSolution,Standard,"Peptide/Protein Calibrant Mix"]},
					Matrix->{Model[Sample, Matrix, "THAP MALDI matrix"],Object[Sample,"Matrix Sample for ExperimentMassSpectrometry"<>$SessionUUID],
						Object[Sample,"Matrix Sample for ExperimentMassSpectrometry"<>$SessionUUID]}
				];

				resources=Download[protocol,RequiredResources];

				resourceFields=DeleteDuplicates[resources[[All,2]]];
				allResourcesMade=ContainsExactly[resourceFields,{SamplesIn,ContainersIn,Calibrants,Matrices,CalibrantMatrices,MALDIPlate,Instrument,
					Sonicator,PrimaryPlateCleaningSolvent,SecondaryPlateCleaningSolvent,Checkpoints}];

				matrixResources=Cases[resources,{_,Matrices,___}][[All,1]][Object];
				correctMatrixResources=MatchQ[matrixResources,{x_,y_,y_}];

				calibrantMatrixResources=Cases[resources,{_,CalibrantMatrices,___}][[All,1]][Object];
				correctCalibrantMatrixResources=MatchQ[calibrantMatrixResources,{x_,y_,y_}];

				calibrantResources=Cases[resources,{_,Calibrants,___}][[All,1]][Object];
				correctCalibrantResources=MatchQ[calibrantResources,{x_,y_,x_}];

				{allResourcesMade,correctMatrixResources,correctCalibrantResources,correctCalibrantMatrixResources}
			],
			{True..}
		],
		(* ExperimentIncubate tests. *)
		Example[{Options, Incubate, "Indicate if the SamplesIn should be incubated at a fixed temperature before starting the experiment:"},
			options = ExperimentMassSpectrometry[Object[Sample, "Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI, Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options, IncubationTemperature, "Provide the temperature at which the SamplesIn should be incubated:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI, IncubationTemperature -> 40*Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationTime, "Indicate SamplesIn should be heated for 40 minutes before starting the experiment:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Oligomer 5 Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI, IncubationTime -> 40*Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, MaxIncubationTime, "Indicate the SamplesIn should be mixed and heated for up to 2 hours or until any solids are fully dissolved:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI, MixUntilDissolved->True, MaxIncubationTime -> 2*Hour, Output -> Options];
			Lookup[options, MaxIncubationTime],
			2 Hour,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubationInstrument, "Indicate the instrument which should be used to heat SamplesIn:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->ESI, IncubationInstrument -> Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument,HeatBlock,"id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options, AnnealingTime, "Set the minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Oligomer 5 Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI, AnnealingTime -> 40*Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquot, "Specify the amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when transferring the input sample to a new container before incubation:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI, IncubateAliquot -> 1.5*Milliliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, IncubateAliquotContainer, "Indicate that the input samples should be transferred into 2mL tubes before the are incubated:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->MALDI,
				IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"],
				Output -> Options
			];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, Mix, "Indicate if the SamplesIn should be mixed during the incubation performed before beginning the experiment:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Oligomer 5 Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI, Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options, MixType, "Indicate the style of motion used to mix the sample:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI, MixType -> Vortex, Output -> Options];
			Lookup[options, MixType],
			Vortex,
			Variables :> {options}
		],
		Example[{Options, MixUntilDissolved, "Indicate if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix type), in an attempt dissolve any solute:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI, MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],

		(* Centrifuge *)
		Example[{Options, Centrifuge, "Indicates if the SamplesIn should be centrifuged before starting the experiment:"},
			options = ExperimentMassSpectrometry[Object[Container, Plate, "Test Plate 3 for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI, Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options, CentrifugeInstrument, "Set the centrifuge that should be used to spin the input samples:"},
			options = ExperimentMassSpectrometry[Object[Container, Plate, "Test Plate 3 for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI, CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options, CentrifugeIntensity, "Indicate the rotational speed which should be applied to the input samples during centrifugation:"},
			options = ExperimentMassSpectrometry[Object[Container, Plate, "Test Plate 3 for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI, CentrifugeIntensity -> 1000*RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options, CentrifugeTime, "Specify the SamplesIn should be centrifuged for 2 minutes:"},
			options = ExperimentMassSpectrometry[Object[Container, Plate, "Test Plate 3 for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI, CentrifugeTime -> 2*Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			2*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options, CentrifugeTemperature, "Indicate the temperature at which the centrifuge chamber should be held while the samples are being centrifuged:"},
			options = ExperimentMassSpectrometry[Object[Container, Plate, "Test Plate 3 for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI, CentrifugeTemperature -> 10*Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options, CentrifugeAliquot, "Indicate the amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentMassSpectrometry[Object[Container, Plate, "Test Plate 3 for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI, CentrifugeAliquot -> 1.5*Milliliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			1.5*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options, CentrifugeAliquotContainer, "Indicate that the input samples should be transferred into 2mL tubes before the are centrifuged:"},
			options = ExperimentMassSpectrometry[Object[Container, Plate, "Test Plate 3 for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI, CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},{2, ObjectP[Model[Container, Vessel, "2mL Tube"]]},{3, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
			Variables :> {options},
			TimeConstraint -> 240
		],

		(* filter options *)
		Example[{Options, Filtration, "Indicate if the SamplesIn should be filtered prior to starting the experiment:"},
			options = ExperimentMassSpectrometry[Object[Sample, "Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI, Filtration -> True, FilterAliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options}
		],
		Example[{Options, FiltrationType, "Specify the method by which the input samples should be filtered:"},
			options = ExperimentMassSpectrometry[Object[Sample, "5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI, FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options}
		],
		Example[{Options, FilterInstrument, "Indicate the instrument that should be used to perform the filtration:"},
			options = ExperimentMassSpectrometry[Object[Sample, "Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->MALDI,
				FilterInstrument -> Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"],
				FilterAliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"]],
			Variables :> {options}
		],
		Example[{Options, Filter, "Indicate that a 0.22um PTFE filter should be used to remove impurities from the SamplesIn:"},
			options = ExperimentMassSpectrometry[Object[Sample, "Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI, Filter -> Model[Item, Filter, "Membrane Filter, PTFE, 0.22um, 142mm"], FilterAliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item, Filter, "Membrane Filter, PTFE, 0.22um, 142mm"]],
			Variables :> {options},
			TimeConstraint -> 600
		],
		Example[{Options, FilterMaterial, "Specify the membrane material of the filter that should be used to remove impurities from the SamplesIn:"},
			options = ExperimentMassSpectrometry[Object[Sample, "Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI, FilterMaterial -> PES, FilterAliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options}
		],
		Example[{Options, PrefilterMaterial, "Indicate the membrane material of the prefilter that should be used to remove impurities from the SamplesIn:"},
			options = ExperimentMassSpectrometry[Object[Sample, "5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI,PrefilterMaterial -> GxF, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options}
		],
		Example[{Options, FilterPoreSize, "Set the pore size of the filter that should be used when removing impurities from the SamplesIn:"},
			options = ExperimentMassSpectrometry[Object[Sample, "Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI, FilterPoreSize -> 0.22*Micrometer, FilterAliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22*Micrometer,
			Variables :> {options}
		],
		Example[{Options, PrefilterPoreSize, "Specify the pore size of the prefilter that should be used when removing impurities from the SamplesIn:"},
			options = ExperimentMassSpectrometry[Object[Sample, "5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI, PrefilterPoreSize -> 1.`*Micrometer, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.`*Micrometer,
			Variables :> {options}
		],
		Example[{Options, FilterSyringe, "Indicate the type of syringe which should be used to force that sample through a filter:"},
			options = ExperimentMassSpectrometry[Object[Sample, "5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI,FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options}
		],
		Example[{Options, FilterHousing, "Indicate the filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentMassSpectrometry[Object[Sample, "Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI,FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], FilterAliquotContainer->Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options}
		],
		Example[{Options, FilterIntensity, "Provide the rotational speed or force at which the samples should be centrifuged during filtration:"},
			options = ExperimentMassSpectrometry[Object[Sample, "5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI,FiltrationType -> Centrifuge, FilterIntensity -> 1000*RPM, Aliquot->True, Output -> Options];
			Lookup[options, FilterIntensity],
			1000*RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTime, "Specify the amount of time for which the samples should be centrifuged during filtration:"},
			options = ExperimentMassSpectrometry[Object[Sample, "5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI,FiltrationType -> Centrifuge, FilterTime -> 20*Minute, Aliquot->True, Output -> Options];
			Lookup[options, FilterTime],
			20*Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterTemperature, "Set the temperature at which the centrifuge chamber should be held while the samples are being centrifuged during filtration:"},
			options = ExperimentMassSpectrometry[Object[Sample, "5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI, FiltrationType -> Centrifuge, FilterTemperature -> 30*Celsius, Aliquot -> True, Output -> Options];
			Lookup[options, FilterTemperature],
			30*Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterSterile, "Indicate if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentMassSpectrometry[Object[Sample, "Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI,FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Messages:>{Warning::AliquotRequired},
			Variables :> {options}
		],
		Example[{Options, FilterAliquot, "Specify the amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentMassSpectrometry[Object[Sample, "Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI,FilterAliquot -> 45*Milliliter, FilterAliquotContainer -> Model[Container, Vessel, "50mL Tube"], Output -> Options];
			Lookup[options, FilterAliquot],
			45*Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, FilterAliquotContainer, "Indicate that the input samples should be transferred into a a 50mL tube before they are filtered:"},
			options = ExperimentMassSpectrometry[
				Object[Sample, "Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->MALDI,
				FilterAliquotContainer -> Model[Container, Vessel, "50mL Tube"],
				Output -> Options
			];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "50mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options, FilterContainerOut, "Indicate the container into which samples should be filtered:"},
			options = ExperimentMassSpectrometry[Object[Sample, "Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource->MALDI,FilterContainerOut -> Model[Container, Vessel, "250mL Glass Bottle"], Aliquot->True, Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "250mL Glass Bottle"]]},
			Variables :> {options}
		],
		(* aliquot options *)
		Example[{Options, Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Aliquot -> True,
				Output -> Options];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotAmount, "Indicate that a 100uL aliquot should be taken from the input sample and used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				AliquotAmount -> 100 Microliter,
				IonSource -> MALDI,
				Output -> Options];
			Lookup[options, AliquotAmount],
			100 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, AssayVolume, "Specify the total volume of the aliquot. Here a 100uL aliquot containing 50uL of the input sample and 50uL of buffer will be generated:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				AssayVolume -> 100 Microliter,
				AliquotAmount -> 50 Microliter,
				IonSource->MALDI,
				Output -> Options];
			Lookup[options, AssayVolume],
			100 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentration, "Indicate that an aliquot should be prepared by diluting the input sample such	that the final concentration of analyte in the aliquot is 1mM:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->MALDI,
				AssayVolume -> 100 Microliter,
				TargetConcentration -> 1*Millimolar,
				Output -> Options];
			Lookup[options, TargetConcentration],
			1*Millimolar,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, TargetConcentrationAnalyte, "The analyte whose desired final concentration is specified:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->MALDI,
				AssayVolume -> 100 Microliter,
				TargetConcentration -> 1*Millimolar,
				TargetConcentrationAnalyte->Model[Molecule, Oligomer, "Test Oligo2 Identity Model"<>$SessionUUID],
				Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, Oligomer, "Test Oligo2 Identity Model"<>$SessionUUID]],
			Variables :> {options}
		],
		Example[{Options, ConcentratedBuffer, "Specify the concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to the aliquot sample, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], AssayVolume -> 1150 Microliter, AliquotAmount -> 20 Microliter, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, BufferDilutionFactor,"Indicate the dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], AssayVolume -> 1150 Microliter, AliquotAmount -> 20 Microliter, BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options, BufferDiluent,  "Set the buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], AssayVolume-> 1150 Microliter, AliquotAmount -> 20 Microliter, BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options, AssayBuffer, "Indicate the buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], AssayVolume->1150 Microliter, AliquotAmount->10 Microliter, AssayBuffer->Model[Sample,StockSolution,"10x UV buffer"], Output->Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options, AliquotSampleStorageCondition, "Set the non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], AssayVolume -> 1150 Microliter, AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options, ConsolidateAliquots, "For MALDI mass spectrometry measurements, indicate that only one 150uL aliquot of Object[Sample,\"Oligomer 1 Sample for ExperimentMassSpectrometry\"] should be created:"},
			options = ExperimentMassSpectrometry[{
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID]
			},
				AliquotAmount->75 Microliter,
				ConsolidateAliquots -> True,
				IonSource->MALDI,
				Output -> Options
			];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options, AliquotPreparation, "Indicate that the aliquots should be generated by using an automated liquid handling robot:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID], IonSource -> MALDI,Aliquot->True, AliquotPreparation -> Robotic, Output -> Options];
			Lookup[options, AliquotPreparation],
			Robotic,
			Variables :> {options}
		],
		Example[{Options, AliquotContainer, "For MALDI mass spectrometry measurements, indicate that the aliquot should be prepared in a deep well plate:"},
			options = ExperimentMassSpectrometry[
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				AliquotContainer -> Model[Container,Plate,"96-well 2mL Deep Well Plate"],
				IonSource->MALDI,
				Output -> Options];
			Lookup[options, AliquotContainer],
			{1,ObjectP[Model[Container,Plate,"96-well 2mL Deep Well Plate"]]},
			Variables :> {options}
		],
		Example[{Options,SamplesInStorageCondition,"Indicates how the input samples of the experiment should be stored:"},
			options = ExperimentMassSpectrometry[
				Object[Sample, "Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				SamplesInStorageCondition -> Refrigerator,
				IonSource -> MALDI,
				Output -> Options];
			Lookup[options, SamplesInStorageCondition], Refrigerator,
			Variables :> {options}
		],
		Example[{Options, CalibrantStorageCondition, "Indicates how the input calibrants of the experiment should be stored:"},
			options = ExperimentMassSpectrometry[
				Object[Sample, "Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				CalibrantStorageCondition -> Refrigerator,
				IonSource -> MALDI,
				Output -> Options];
			Lookup[options, CalibrantStorageCondition], Refrigerator,
			Variables :> {options}
		],
		Example[{Options,IncubateAliquotDestinationWell, "Indicates the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentMassSpectrometry[
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->MALDI,
				IncubateAliquotDestinationWell -> "A1",
				Output -> Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,CentrifugeAliquotDestinationWell, "Indicates the desired position in the corresponding
		CentrifugeAliquotDestinationWell in which the aliquot samples will be placed:"},
			options = ExperimentMassSpectrometry[
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->MALDI,
				CentrifugeAliquotDestinationWell -> "A1",
				Output -> Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterAliquotDestinationWell, "Indicates the desired position in the corresponding FilterAliquotDestinationWell in which the aliquot samples will be placed:"},
			options = ExperimentMassSpectrometry[
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->MALDI,
				FilterAliquotDestinationWell -> "A1",
				Output -> Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options, DestinationWell, "Indicates the desired position in the corresponding DestinationWell in which the aliquot samples will be placed:"},
			options = ExperimentMassSpectrometry[
				Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				IonSource->MALDI,
				DestinationWell -> "A1",
				Output -> Options];
			Lookup[options,DestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options, ImageSample, "Indicate if any samples that are modified in the course of the experiment should be imaged after running the experiment:"},
			options = ExperimentMassSpectrometry[Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource -> MALDI, ImageSample -> True, Output -> Options];
			Lookup[options, ImageSample],
			True,
			Variables :> {options}
		],
		Example[{Options,MeasureVolume,"Indicate if any samples that are modified in the course of the experiment should have their volumes measured after running the experiment:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI,MeasureVolume->False],
				MeasureVolume
			],
			False
		],
		Example[{Options,MeasureWeight,"Indicate if any samples that are modified in the course of the experiment should have their weights measured after running the experiment:"},
			Download[
				ExperimentMassSpectrometry[Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID],IonSource->MALDI,MeasureWeight->False],
				MeasureWeight
			],
			False
		],
		Test["Resolves ConsolidateAliquots->True if any aliquoting is being done (MALDI):",
			Download[ExperimentMassSpectrometry[Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Aliquot->True,IonSource->MALDI],ConsolidateAliquots],
			True
		],
		Test["Resolves ConsolidateAliquots->True if any aliquoting is being done (ESI):",
			Download[ExperimentMassSpectrometry[Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID], Aliquot->True],ConsolidateAliquots],
			True
		],

		Test["The matrix and calibrant samples can be the same model as the input samples without causing caching errors:",
			ExperimentMassSpectrometry[{Object[Sample,"Matrix Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Calibrant Sample for ExperimentMassSpectrometry"<>$SessionUUID]},
				Calibrant->Model[Sample,StockSolution,Standard,"Peptide/Protein Calibrant Mix"],
				Matrix->Model[Sample, Matrix, "HCCA MALDI matrix"],
				MassDetection->Span[1000 Dalton, 5000 Dalton]
			],
			ObjectP[Object[Protocol,MassSpectrometry]],
			Messages:>{Warning::IncompatibleCalibrant,Warning::FilteredAnalytes, Warning::SamplesOutOfMassDetection}
		],
		(* This tests the compatability of HPLC vials which are hardcode right now, update as needed or revise if hardcoding changes *)
		Test["ExperimentMassSpectrometry takes HPLC Vials and Amber HPLC Vials as Inputs:",
			ExperimentMassSpectrometry[{Object[Sample,"Water in Vial Sample for ExperimentMassSpectrometry"<>$SessionUUID],
				Object[Sample,"Water in Amber Vial Sample for ExperimentMassSpectrometry"<>$SessionUUID]}
			],
			ObjectP[Object[Protocol,MassSpectrometry]]
		]
	},
	Parallel -> True,
	Stubs:>{
		(* I am an important stub that prevents the tester from getting a bunch of notifications *)
		$PersonID = Object[User, "Test user for notebook-less test protocols"]
	},
	SetUp :> (
		ClearDownload[];
		ClearMemoization[];
		Off[Warning::SamplesOutOfStock];

	),
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Warning::ExpiredSamples];
		massSpecBackupCleanup[];
		Module[{tubePacket,platePacket,vialPacket,numberOfTubes,uploadedObjects,tubeObjects,plateObject,emptyPlate,plateObject2,plateObject3,
			directInfusionContainer1,directInfusionContainer2,directInfusionContainer3,largeContainer,
			highMolecularWeightModel,allPeaksLeftModel,allPeaksRightModel,lowMolecularWeightModel,
			lowWeightCalibrantModel,highWeightCalibrantModel,onePeakCalibrantModel,twoPeakCalibrantModel,deprecatedCalibrantModel,
			massSpecProtocol,calibrationMethod,testSamples,testoligo2, testoligo3, testoligo1,testWater, testChemical,testChemicalLiquid,
			plateObject4,vialObject1, vialObject2, bottleForMethanol,antibodyModel,peptideModel,proteinModel,acidModel,mixedModel,
			uploadedIdentityModels,matrixWithoutSpottingDryTime,matrixWithoutSpottingVolume},

			$CreatedObjects={};


			tubePacket=<|Type->Object[Container,Vessel],Model->Link[Model[Container, Vessel, "2mL Tube"],Objects],Site->Link[$Site],DeveloperObject->True|>;
			platePacket=<|Type->Object[Container,Plate],Model->Link[Model[Container,Plate,"96-well 2mL Deep Well Plate"],Objects],Site->Link[$Site],DeveloperObject->True|>;
			vialPacket=<|Type->Object[Container,Vessel], Site -> Link[$Site], DeveloperObject -> True|>;
			numberOfTubes=15;

			uploadedIdentityModels=Upload[
				(* peptide Identity Models*)
				{<|Type -> Model[Molecule, Oligomer], Name -> "Oligo1 Test Identity Model"<>$SessionUUID, Molecule -> Structure[{"ArgProProGlyPheSerProArgProProGlyPheSerPro"}],
					MolecularWeight -> 1495.72 * Dalton, PolymerType -> Peptide, DeveloperObject -> True|>,
					<|Type -> Model[Molecule, Oligomer], Name -> "Oligo2 Test Identity Model"<>$SessionUUID, Molecule -> Structure[{"ArgProProGlyPheSerGlyPheSerProPheSerPro"}],
						MolecularWeight -> 1380 * Dalton, PolymerType -> Peptide, DeveloperObject -> True|>,
					(* protein Identity Model *)
					<|Type -> Model[Molecule, Protein], Name -> "Protein Test Identity Model"<>$SessionUUID, State -> Liquid, MolecularWeight -> 10000 * Dalton, DeveloperObject -> True|>,
					(* antibody Identity Model *)
					<|Type -> Model[Molecule, Protein, Antibody], Name -> "Antibody Test Identity Model"<>$SessionUUID, DeveloperObject -> True|>,
					(* highMolecularWeight Identity Model *)
					<|Type -> Model[Molecule], Name -> "highMW Test Identity Model"<>$SessionUUID, DeveloperObject -> True, MolecularWeight -> 17000 Gram / Mole|>,
					(* allPeaksLeft Identity Model *)
					<|Type -> Model[Molecule], Name -> "allPeaksLeft Test Identity Model"<>$SessionUUID, State -> Liquid, DeveloperObject -> True, MolecularWeight -> 5200 Gram / Mole|>,
					(* lowMolecularWeight Identity Model *)
					<|Type -> Model[Molecule], Name -> "lowMW Test Identity Model"<>$SessionUUID, DeveloperObject -> True, MolecularWeight -> 775 Gram / Mole|>,
					(* acid Identity Model *)
					<|Type -> Model[Molecule], Name -> "Acid Test Identity Model"<>$SessionUUID, DeveloperObject -> True, MolecularWeight -> 600 Gram / Mole, Acid -> True|>,
					(*Test chemical that is solid*)
					<|Type -> Model[Molecule], Name -> "Test Chemical"<>$SessionUUID, DeveloperObject -> True, State -> Solid|>,
					(*Test chemical that is liquid*)
					<|Type -> Model[Molecule], Name -> "Test Chemical Liquid"<>$SessionUUID, DeveloperObject -> True, State -> Liquid|>,
					(*Test Oligomer 2*)
					<|Type -> Model[Molecule, Oligomer],
						Name -> "Test Oligo2 Identity Model"<>$SessionUUID,
						DeveloperObject -> True,
						Molecule->ToStrand["CTCTCCGGTTCTCTCCGTCTCCGGTT",Polymer -> PNA, Motif -> "D'"],
						MolecularWeight-> 6.90051*Kilogram/Mole|>,
					(*Test Oligomer 3*)
					<|Type -> Model[Molecule, Oligomer],
						Name -> "Test Oligo3 Identity Model"<>$SessionUUID,
						DeveloperObject -> True,
						Molecule->ToStrand["CTCTCCGGTTCTCTCCGTCTCCGGTT", Polymer -> DNA, Motif -> "D'"],
						MolecularWeight->7.80697*Kilogram/Mole|>,
					(*Test Oligomer 1*)
					<|Type -> Model[Molecule, Oligomer],
						Name -> "Test Oligo1 Identity Model"<>$SessionUUID,
						DeveloperObject -> True,
						Molecule->ToStrand[{"CTCTCCGGTT", "CTGCTCCAGACCTGCGCCGCATAAA", "GTCCTTCTATTAGCC"}, Polymer -> DNA, Motif -> {"D'", "X'", "B'"}],
						MolecularWeight->15.1597*Kilogram/Mole|>
				}
			];

			(* Create empty containers, test calibrants, existing protocol, and models*)
			uploadedObjects=Upload[
				Join[
					(* New containers *)
					ConstantArray[tubePacket,numberOfTubes],
					{
						Append[platePacket,Name->"Test Plate for ExperimentMassSpectrometry"<>$SessionUUID],
						Append[platePacket,Name->"Empty Container for ExperimentMassSpectrometry"<>$SessionUUID],
						Append[platePacket,Name->"Test Plate 2 for ExperimentMassSpectrometry"<>$SessionUUID],
						Append[platePacket,Name->"Test Plate 3 for ExperimentMassSpectrometry"<>$SessionUUID],
						Append[platePacket,Name->"Test Plate 4 for ExperimentMassSpectrometry"<>$SessionUUID],
						Append[vialPacket, {Name -> "Test HPLC Vial for ExperimentMassSpectrometry" <> $SessionUUID, Model -> Link[Model[Container, Vessel, "id:jLq9jXvxr6OZ"], Objects]}],
						Append[vialPacket, {Name -> "Test Amber HPLC Vial for ExperimentMassSpectrometry" <> $SessionUUID , Model -> Link[Model[Container, Vessel, "id:GmzlKjznOxmE"], Objects]}]
					},
					(*Chemicals*)
					{
						<|
							Type->Model[Sample],
							Name-> "Test Milli-Q Water"<>$SessionUUID,
							Replace[Composition]->{{100*VolumePercent,Link[Model[Molecule,"Water"]]}},
							DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]],
							DeveloperObject -> True
						|>,

						<|
							Type->Model[Sample],
							Name-> "Test Chemical Sample"<>$SessionUUID,
							Replace[Composition]->{{100*VolumePercent,Link[Model[Molecule,"Test Chemical"<>$SessionUUID]]}},
							DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]],
							Tablet->True,
							State-> Solid,
							Expires-> True,
							DeveloperObject -> True
						|>,
						<|
							Type->Model[Sample],
							Name-> "Test Chemical Sample Liquid"<>$SessionUUID,
							Replace[Composition]->{{100*VolumePercent,Link[Model[Molecule,"Test Chemical Liquid"<>$SessionUUID]]}},
							DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]],
							State-> Liquid,
							Expires-> True,
							DeveloperObject -> True
						|>

					},
					(* direct infusion 30ml vessel *)
					{<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:1ZA60vLx3RB5"],Objects],Site->Link[$Site],DeveloperObject->True|>},
					{<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:1ZA60vLx3RB5"],Objects],Site->Link[$Site],DeveloperObject->True|>},
					{<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"id:1ZA60vLx3RB5"],Objects],Site->Link[$Site],DeveloperObject->True|>},

					(* large container *)
					{<|Type->Object[Container,Vessel],Model->Link[Model[Container,Vessel,"250mL Glass Bottle"],Objects],Site->Link[$Site],DeveloperObject->True|>},
					{<|Type-> Object[Container,Vessel],Model->Link[Model[Container, Vessel, "id:Vrbp1jG800Zm"],Objects],Site->Link[$Site],DeveloperObject->True|>},

					{
						(* peptideModel *)
						<|
							Type -> Model[Sample],
							Replace[Composition] -> {{100 * VolumePercent, Link[Model[Molecule, Oligomer, "Oligo1 Test Identity Model" <> $SessionUUID]]}},
							DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
							DeveloperObject -> True
						|>,
						(* proteinModel *)
						<|
							Type -> Model[Sample],
							Replace[Composition] -> {{100 * VolumePercent, Link[Model[Molecule, Protein, "Protein Test Identity Model" <> $SessionUUID]]}},
							DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
							DeveloperObject -> True
						|>,
						(* antibodyModel *)
						<|
							Type -> Model[Sample],
							Replace[Composition] -> {{100 * VolumePercent, Link[Model[Molecule, Protein, Antibody, "Antibody Test Identity Model" <> $SessionUUID]]}},
							DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
							DeveloperObject -> True
						|>,
						(* highMolecularWeightModel *)
						<|
							Type -> Model[Sample],
							Replace[Composition] -> {{100 * VolumePercent, Link[Model[Molecule, "highMW Test Identity Model" <> $SessionUUID]]}},
							DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
							DeveloperObject -> True
						|>,
						(* allPeaksLeftModel *)
						<|
							Type -> Model[Sample],
							Replace[Composition] -> {{100 * VolumePercent, Link[Model[Molecule, "allPeaksLeft Test Identity Model" <> $SessionUUID]]}},
							DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
							DeveloperObject -> True
						|>,
						(* lowMolecularWeightModel *)
						<|
							Type -> Model[Sample],
							Replace[Composition] -> {{100 * VolumePercent, Link[Model[Molecule, "lowMW Test Identity Model" <> $SessionUUID]]}},
							DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
							DeveloperObject -> True
						|>,
						(* acidModel *)
						<|
							Type -> Model[Sample],
							Replace[Composition] -> {{100 * VolumePercent, Link[Model[Molecule, "Acid Test Identity Model" <> $SessionUUID]]}},
							DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
							DeveloperObject -> True
						|>,

						(*Model[Sample] with mixed oligo composition - mixedModel*)
						<|
							Type -> Model[Sample],
							Name -> "Oligo1 and Oligo2 mixed sample" <> $SessionUUID,
							DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
							Replace[Composition] -> {
								{50 * VolumePercent, Link[Model[Molecule, Oligomer, "Oligo1 Test Identity Model" <> $SessionUUID]]},
								{50 * VolumePercent, Link[Model[Molecule, Oligomer, "Oligo2 Test Identity Model" <> $SessionUUID]]}},
							DeveloperObject -> True
						|>,

						(* Calibrants *)
						<|
							Type -> Model[Sample, StockSolution, Standard],
							PreferredSpottingMethod -> OpenFace,
							Replace[ReferencePeaksPositiveMode] -> {3703, 4544, 5100, 7609, 9133, 10674} Dalton,
							Replace[ReferencePeaksNegativeMode] -> {3701, 4542, 5098, 7607, 9131, 10672} Dalton,
							Name -> "Low Weight Calibrant Model for ExperimentMassSpectrometry" <> $SessionUUID,
							DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
							DeveloperObject -> True,
							CompatibleIonSource -> MALDI
						|>,
						<|
							Type -> Model[Sample, StockSolution, Standard],
							Replace[ReferencePeaksPositiveMode] -> {14328, 17512, 17948, 18014, 30588} Dalton,
							Replace[ReferencePeaksNegativeMode] -> {14326, 17510, 17946, 18012, 30586} Dalton,
							Name -> "High Weight Calibrant Model for ExperimentMassSpectrometry" <> $SessionUUID,
							DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
							DeveloperObject -> True,
							CompatibleIonSource -> MALDI
						|>,
						<|
							Type -> Model[Sample, StockSolution, Standard],
							Replace[ReferencePeaksPositiveMode] -> {12000 Dalton},
							Replace[ReferencePeaksNegativeMode] -> {11998 Dalton},
							Name -> "One Peak Calibrant Model for ExperimentMassSpectrometry" <> $SessionUUID,
							DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
							DeveloperObject -> True
						|>,
						<|
							Type -> Model[Sample, StockSolution, Standard],
							Replace[ReferencePeaksPositiveMode] -> {10000 Dalton, 12010 Dalton},
							Replace[ReferencePeaksNegativeMode] -> {9998 Dalton, 12008 Dalton},
							Name -> "Two Peak Calibrant Model for ExperimentMassSpectrometry" <> $SessionUUID,
							DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
							DeveloperObject -> True
						|>,
						<|
							Type -> Model[Sample, StockSolution, Standard],
							Name -> "Deprecated Calibrant for ExpMS Tests" <> $SessionUUID,
							Replace[ReferencePeaksPositiveMode] -> {123, 456, 789, 1024, 2038, 3703, 4544, 5100, 7609, 9133, 10674} Gram / Mole,
							Replace[ReferencePeaksNegativeMode] -> {123, 456, 789, 1024, 2038, 3703, 4544, 5100, 7609, 9133, 10674} Gram / Mole,
							DefaultStorageCondition -> Link[Model[StorageCondition, "id:7X104vnR18vX"]],
							DeveloperObject -> True,
							Deprecated -> True
						|>
					},
					{
						<|
							Type -> Model[Sample, Matrix],
							Name -> "Model Matrix without SpottingDryTime informed Sample for ExperimentMassSpectrometry" <> $SessionUUID,
							SpottingVolume -> 1 Milliliter,
							DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]],
							DeveloperObject -> True
						|>,
						<|
							Type -> Model[Sample, Matrix],
							Name -> "Model Matrix without SpottingVolume informed Sample for ExperimentMassSpectrometry" <> $SessionUUID,
							SpottingDryTime -> 15 Minute,
							DefaultStorageCondition->Link[Model[StorageCondition,"id:7X104vnR18vX"]],
							DeveloperObject -> True
						|>
					},

					(* Protocol for conflicting Name test *)
					{
						<|
							Type->Object[Protocol,MassSpectrometry],
							Name->"Existing Mass Spec Protocol"<>$SessionUUID,
							DeveloperObject->True,
							Site->Link[$Site]
						|>
					},

					{(*Test oligmer models*)
						<|Type->Model[Sample],
							Replace[Composition]->{
								{100*VolumePercent,Link[Model[Molecule, "Water"]]},
								{10*Millimolar,Link[Model[Molecule,Oligomer,"Test Oligo2 Identity Model"<>$SessionUUID]]}},
							DefaultStorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"]],
							Name->"Test Oligo2 for MassSpectrometry"<>$SessionUUID,
							DeveloperObject->True|>,
						<|Type->Model[Sample],
							Replace[Composition]->{
								{100*VolumePercent,Link[Model[Molecule, "Water"]]},
								{10*Millimolar,Link[Model[Molecule,Oligomer,"Test Oligo3 Identity Model"<>$SessionUUID]]}},
							DefaultStorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"]],
							Name->"Test Oligo3 for MassSpectrometry"<>$SessionUUID,
							DeveloperObject->True|>,
						<|Type->Model[Sample],
							Replace[Composition]->{
								{100*VolumePercent,Link[Model[Molecule, "Water"]]},
								{10*Millimolar,Link[Model[Molecule,Oligomer,"Test Oligo1 Identity Model"<>$SessionUUID]]}},
							DefaultStorageCondition->Link[Model[StorageCondition,"id:N80DNj1r04jW"]],
							Name->"Test Oligo1 for MassSpectrometry"<>$SessionUUID,
							DeveloperObject->True|>}
				]
			];

			(* Assign variables to uploaded objects, first N are all vessels *)
			{
				tubeObjects,
				{
					plateObject,emptyPlate,plateObject2,plateObject3,plateObject4,vialObject1,vialObject2,
					testWater,testChemical,testChemicalLiquid,
					directInfusionContainer1,directInfusionContainer2,directInfusionContainer3,largeContainer,
					bottleForMethanol,peptideModel,proteinModel,antibodyModel,
					highMolecularWeightModel, allPeaksLeftModel,lowMolecularWeightModel,
					acidModel,mixedModel,lowWeightCalibrantModel,highWeightCalibrantModel,onePeakCalibrantModel,
					twoPeakCalibrantModel,deprecatedCalibrantModel,matrixWithoutSpottingDryTime,matrixWithoutSpottingVolume,massSpecProtocol,
					testoligo2, testoligo3, testoligo1
				}
			}=TakeDrop[uploadedObjects,numberOfTubes];

			(* Create samples *)
			testSamples=UploadSample[
				{
				(* samples inside tube objects *)
					testWater,
					testWater,
					Model[Sample, StockSolution, Standard, "Peptide/Protein Calibrant Mix"],
					Model[Sample, Matrix, "HCCA MALDI matrix"],
					matrixWithoutSpottingDryTime,
					matrixWithoutSpottingVolume,
					testWater,
					antibodyModel,
					highMolecularWeightModel,
					allPeaksLeftModel,
					lowMolecularWeightModel,
					peptideModel,
					proteinModel,
					acidModel,
					testChemical,
					(* esi direct infusion samples *)
					testoligo1,
					testoligo2,
					testChemicalLiquid,
					(* large container *)
					allPeaksLeftModel,
					(* methanol, in case we run out of it *)
					Model[Sample, "id:vXl9j5qEnnRD"],
					(* plates *)
					testoligo2,
					testoligo2,
					testoligo3,
					testoligo1,
					testoligo2,
					testoligo3,
					testoligo1,
					mixedModel,
					testWater,
					testWater
				},
				Join[
					{"A1",#}&/@tubeObjects,
					{{"A1",directInfusionContainer1},{"A1",directInfusionContainer2},{"A1",directInfusionContainer3},
					{"A1",largeContainer},{"A1",bottleForMethanol},{"A1",plateObject},{"A2",plateObject},{"A3",plateObject},
						{"A1",plateObject2},{"A1",plateObject3},{"A2",plateObject3},{"A3",plateObject3},{"A1", plateObject4},
						{"A1", vialObject1},{"A1",vialObject2}}
				],
				Name->Map[
					#<>" Sample for ExperimentMassSpectrometry"<>$SessionUUID&,
					{
						(* samples inside tube objects *)
						"Discarded",
						"Water",
						"Calibrant",
						"Matrix",
						"Matrix without SpottingDryTime informed",
						"Matrix without SpottingVolume informed",
						"Sample without a parent Model Matrix",
						"Missing Molecular Weight",
						"17000 Dalton",
						"5200 Dalton",
						"775 Dalton",
						"Peptide",
						"Protein",
						"Small acid",
						"Tablet",
						(* direct infusion samples *)
						"Direct infusion oligomer 1",
						"Direct infusion oligomer 2",
						"Direct infusion 3 without MW",
					(* large container *)
						"Large Container",
						(* Methanol sample *)
						"Methanol",
						(* plates *)
						"Oligomer 1",
						"Oligomer 2",
						"Oligomer 3",
						"Oligomer 4",
						"Oligomer 5",
						"Oligomer 6",
						"Oligomer 7",
						"Oligomer Mix",
						"Water in Vial",
						"Water in Amber Vial"
					}
				],
				InitialAmount->Join[ConstantArray[2 Milliliter,numberOfTubes],{
					(* direct infusion *)
					5*Milliliter,
					5*Milliliter,
					5*Milliliter,
				(* sample in large container *)
					200 Milliliter,
					(* methanol sample *)
					1000 Milliliter,
					(* oligomers *)
					8 Milliliter,1.80 Milliliter,1.80 Milliliter,1.80 Milliliter,1.80 Milliliter,3 Milliliter,3 Milliliter,1.80*Milliliter,
					(* vials *)
					1 Milliliter, 1 Milliliter
				}]
			];

			(* Discard chemical for testing *)
			UploadLocation[testSamples[[1]],Waste];

			Upload[
				Join[
					<|Object->#,DeveloperObject->True|>&/@testSamples,
					{
						<|Object->Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Concentration->10 Millimolar|>,
						<|Object->Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Concentration->10 Millimolar|>,
						<|Object->Object[Sample,"Oligomer 3 Sample for ExperimentMassSpectrometry"<>$SessionUUID],Concentration->10 Millimolar|>,
						<|Object->Object[Sample,"Methanol Sample for ExperimentMassSpectrometry"<>$SessionUUID],Status->Available|> (* make it available so that we can use it in case we run out of methanol in the lab *),
						<|Object->Object[Sample,"Oligomer 5 Sample for ExperimentMassSpectrometry"<>$SessionUUID]|>,
						<|Object->Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID]|>,
						<|Object->Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID]|>,
						<|Object->Object[Sample,"Oligomer 4 Sample for ExperimentMassSpectrometry"<>$SessionUUID]|>,
						<|Object->Object[Sample,"Tablet Sample for ExperimentMassSpectrometry"<>$SessionUUID], State-> Solid|>,
						<|Object->Object[Sample,"Matrix Sample for ExperimentMassSpectrometry"<>$SessionUUID],
							Replace[Analytes]->{Link[Model[Molecule,"id:O81aEBZn7nBj"]],Link[Model[Molecule, "id:o1k9jAGP8PXa"]]}|>
					},
					(* Existing method for new method creation test *)
					{<|
						Type -> Object[Method, MassSpectrometryCalibration],
						Name -> "Existing Method for ExperimentMassSpectrometry"<>$SessionUUID,
						IonMode -> Positive,
						Matrix -> Link@Model[Sample, Matrix, "HPA MALDI matrix"],
						Calibrant -> Link@Model[Sample, StockSolution, Standard, "Low Weight Calibrant Model for ExperimentMassSpectrometry"<>$SessionUUID],
						SpottingMethod -> Sandwich,
						MinMass -> Quantity[3501., "Grams"/"Moles"],
						MaxMass -> Quantity[8001., "Grams"/"Moles"],
						AccelerationVoltage -> Quantity[4.12, "Kilovolts"],
						GridVoltage -> Quantity[3.98, "Kilovolts"],
						Gain -> 2.,
						LensVoltage -> Quantity[7., "Kilovolts"],
						DelayTime -> Quantity[100., "Nanoseconds"],
						MinLaserPower -> Quantity[65., "Percent"],
						MaxLaserPower -> Quantity[85., "Percent"],
						ShotsPerRaster -> 12,
						NumberOfShots -> 2000,
						DeveloperObject -> True
					|>},
					{
						<|
							Type -> Object[Instrument, MassSpectrometer], 
							Name -> "Unit Test Instrument For ExperimentMassSpectrometry"<>$SessionUUID,
							Model -> Link[Model[Instrument, MassSpectrometer, "id:aXRlGn6KaWdO"], Objects],
							ImageFile -> Link[Object[EmeraldCloudFile, "id:xRO9n3BPO5Pq"]],
							Status -> Available, 
							Site -> Link[$Site],
							DeveloperObject -> True
						|>
					}
				]
			]
		]
	),
	TearDown :> (
		On[Warning::SamplesOutOfStock];
	),
	SymbolTearDown:>Module[{},
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Warning::ExpiredSamples];
		EraseObject[$CreatedObjects,Force->True,Verbose->False];
		Unset[$CreatedObjects];
		massSpecBackupCleanup[];
	]
];

massSpecBackupCleanup[]:=Module[{namedObjects,lurkers},
	namedObjects={
		Object[Protocol, MassSpectrometry, "Purification QA"<>$SessionUUID],
		Object[Container, Plate,"Test Plate for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Container, Plate,"Test Plate 2 for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Container, Plate,"Test Plate 3 for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Container, Plate,"Test Plate 4 for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Container, Plate,"Empty Container for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Container, Vessel,"Test HPLC Vial for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Container, Vessel,"Test Amber HPLC Vial for ExperimentMassSpectrometry"<>$SessionUUID],
		Model[Sample, StockSolution, Standard,"Low Weight Calibrant Model for ExperimentMassSpectrometry"<>$SessionUUID],
		Model[Sample, StockSolution, Standard,"High Weight Calibrant Model for ExperimentMassSpectrometry"<>$SessionUUID],
		Model[Sample, StockSolution, Standard,"One Peak Calibrant Model for ExperimentMassSpectrometry"<>$SessionUUID],
		Model[Sample, StockSolution, Standard,"Two Peak Calibrant Model for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Protocol, MassSpectrometry, "Existing Mass Spec Protocol"<>$SessionUUID],
		Object[Sample,"Discarded Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Water Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Calibrant Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Matrix Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Model[Sample, Matrix, "Model Matrix without SpottingDryTime informed Sample for ExperimentMassSpectrometry" <> $SessionUUID],
		Model[Sample, Matrix, "Model Matrix without SpottingVolume informed Sample for ExperimentMassSpectrometry" <> $SessionUUID],
		Object[Sample, "Matrix without SpottingDryTime informed Sample for ExperimentMassSpectrometry" <> $SessionUUID],
		Object[Sample, "Matrix without SpottingVolume informed Sample for ExperimentMassSpectrometry" <> $SessionUUID],
		Object[Sample, "Sample without a parent Model Matrix Sample for ExperimentMassSpectrometry" <> $SessionUUID],
		Object[Sample,"Peptide Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Protein Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Missing Molecular Weight Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"17000 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"5200 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"775 Dalton Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Tablet Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Small acid Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Methanol Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Large Container Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Oligomer 3 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Direct infusion oligomer 1 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Direct infusion oligomer 2 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Direct infusion 3 without MW Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Oligomer 4 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Oligomer 5 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Oligomer 6 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Oligomer 7 Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Oligomer Mix Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Water in Vial Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Sample,"Water in Amber Vial Sample for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Method, MassSpectrometryCalibration, "Existing Method for ExperimentMassSpectrometry"<>$SessionUUID],
		Object[Instrument, MassSpectrometer, "Unit Test Instrument For ExperimentMassSpectrometry"<>$SessionUUID],
		Model[Molecule, Oligomer, "Oligo1 Test Identity Model"<>$SessionUUID],
		Model[Molecule, Oligomer, "Oligo2 Test Identity Model"<>$SessionUUID],
		Model[Sample, "Oligo1 and Oligo2 mixed sample"<>$SessionUUID],
		Model[Molecule, Oligomer, "Test Oligo2 Identity Model"<>$SessionUUID],
		Model[Molecule, Oligomer, "Test Oligo3 Identity Model"<>$SessionUUID],
		Model[Molecule, Oligomer, "Test Oligo1 Identity Model"<>$SessionUUID],
		Model[Molecule,"Test Chemical"<>$SessionUUID],
		Model[Molecule,"Test Chemical Liquid"<>$SessionUUID],
		Model[Molecule, Protein, "Protein Test Identity Model"<>$SessionUUID],
		Model[Molecule, Protein, Antibody, "Antibody Test Identity Model"<>$SessionUUID],
		Model[Molecule, "highMW Test Identity Model"<>$SessionUUID],
		Model[Molecule, "allPeaksLeft Test Identity Model"<>$SessionUUID],
		Model[Molecule, "lowMW Test Identity Model"<>$SessionUUID],
		Model[Molecule, "Acid Test Identity Model"<>$SessionUUID],
		Model[Sample,"Test Milli-Q Water"<>$SessionUUID],
		Model[Sample,"Test Chemical Sample Liquid"<>$SessionUUID],
		Model[Sample,"Test Chemical Sample"<>$SessionUUID],
		Model[Sample,"Test Oligo1 for MassSpectrometry"<>$SessionUUID],
		Model[Sample,"Test Oligo2 for MassSpectrometry"<>$SessionUUID],
		Model[Sample,"Test Oligo3 for MassSpectrometry"<>$SessionUUID],
		Model[Sample, StockSolution, Standard,"Deprecated Calibrant for ExpMS Tests"<>$SessionUUID]
	};
	lurkers=PickList[namedObjects,DatabaseMemberQ[namedObjects],True];
	EraseObject[lurkers,Force->True,Verbose->False]
]


(* ::Section:: *)
(*End Test Package*)
