(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Title:: *)
(*Experiment HPLC: Tests*)


(* ::Section:: *)
(*Unit Testing*)


(* ::Subsection:: *)
(*HPLC*)


(* ::Subsubsection:: *)
(*ExperimentHPLC*)


DefineTests[ExperimentHPLC,
	{
		(* === Basic === *)
		Example[
			{Basic,"Automatically resolve of all options for sample:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False][[1]];
				Lookup[packet,ResolvedOptions]
			),
			OptionsPattern[],
			Variables:>{packet}
		],
		Example[
			{Basic,"Specify the injection volume for each sample:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					InjectionVolume->100 Micro Liter
				][[1]];
				Lookup[packet,Replace[InjectionVolumes]]
			),
			{100 Microliter,100 Microliter,100 Microliter},
			EquivalenceFunction -> Equal,
			Variables:>{packet}
		],

		(* === Additional === *)
		Example[
			{Additional,"Automatically resolve of all options for sample without a model:"},
			(
				packet = ExperimentHPLC[
					Object[Sample,"Test Sample 4 for ExperimentHPLC tests" <> $SessionUUID],
					Upload->False][[1]];
				Lookup[packet,ResolvedOptions]
			),
			OptionsPattern[],
			Variables:>{packet}
		],
		Example[
			{Additional,"Work with a non-standard sample container that we haven't considered:"},
			(
				packet = ExperimentHPLC[
					Object[Sample,"Test Sample 5 for ExperimentHPLC tests (high recovery vial)" <> $SessionUUID],
					Upload->False][[1]];
				Lookup[packet,ResolvedOptions]
			),
			OptionsPattern[],
			Variables:>{packet}
		],
		Example[
			{Additional,"Work with a non-standard sample container that we haven't considered (waters):"},
			(
				packet = ExperimentHPLC[
					Object[Sample,"Test Sample 5 for ExperimentHPLC tests (high recovery vial)" <> $SessionUUID],
					Instrument->Model[Instrument,HPLC,"Waters Acquity UPLC H-Class PDA"],
					Upload->False][[1]];
				Lookup[packet,ResolvedOptions]
			),
			OptionsPattern[],
			Variables:>{packet}
		],
		Example[{Additional,"Buffer composition can be specified to the nearest 0.1 %:"},
			Download[
				ExperimentHPLC[
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					GradientB -> 35.1 Percent
				],
				IsocraticGradientB
			],
			{EqualP[35.1 Percent]}
		],
		Example[{Additional,"Resolves to the Agilent 1260 Infinity II Semi-Preparative HPLC instruments if the samples are at CMU:"},
			Module[
				{protocol,instrumentResource,instrumentModels},
				protocol=ExperimentHPLC[
					{
						Object[Sample,"Test Sample CMU-1 for ExperimentHPLC tests" <> $SessionUUID],
						Object[Sample,"Test Sample CMU-2 for ExperimentHPLC tests" <> $SessionUUID],
						Object[Sample,"Test Sample CMU-3 for ExperimentHPLC tests" <> $SessionUUID]
					},
					Scale->SemiPreparative
				];
				instrumentResource=FirstCase[
					Download[protocol,RequiredResources],
					{_, Instrument, ___}
				][[1]];
				instrumentModels=Download[instrumentResource,InstrumentModels[Object]]
			],
			(*
				{
					"Agilent 1260 Infinity II Semi-Preparative HPLC with UV/Vis Diode Array Detector",
					"Agilent 1260 Infinity II Semi-Preparative HPLC with MALS-DLS-RI Detector",
					"Agilent 1260 Infinity II Semi-Preparative HPLC with UV/Vis Diode Array and Fluorescence Detectors"
				}
			*)
			{
				Model[Instrument, HPLC, "id:dORYzZRWJlDD"],
				Model[Instrument, HPLC, "id:dORYzZRWmDn5"],
				Model[Instrument, HPLC, "id:lYq9jRqD8OpV"]
			}
		],
		Example[
			{Additional,"Supports different types of HPLC vials:"},
			(
				packet = ExperimentHPLC[
					ConstantArray[Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],5],
					(* Use AliquotContainer option to require different type of supported containers. They are all accepted on HPLC and no error/warning should be thrown *)
					AliquotContainer->{Model[Container, Vessel, "HPLC vial (high recovery)"], Model[Container, Vessel, "1mL HPLC Vial (total recovery)"], Model[Container, Vessel, "Amber HPLC vial (high recovery)"], Model[Container, Vessel, "HPLC vial (high recovery), LCMS Certified"], Model[Container, Vessel, "HPLC vial (high recovery) - Deactivated Clear Glass"]},
					Upload->False][[1]];
				{
					Lookup[packet, Scale],
					Lookup[Lookup[packet, Replace[AliquotSamplePreparation]], AliquotContainer][[All,2]]
				}
			),
			{
				Analytical,
				{
					Model[Container, Vessel, "id:jLq9jXvxr6OZ"],
					Model[Container, Vessel, "id:1ZA60vL48X85"],
					Model[Container, Vessel, "id:GmzlKjznOxmE"],
					Model[Container, Vessel, "id:3em6ZvL8x4p8"],
					Model[Container, Vessel, "id:aXRlGnRE6A8m"]
				}
			},
			Variables:>{packet}
		],

		(* === Test === *)
		Test[
			"Output->Tests returns {_EmeraldTest..}:",
			ExperimentHPLC[{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},Output->Tests],
			{_EmeraldTest..}
		],
		Test["A list of tests is returned if a non-existent template is specified, but the Result/Options are $Failed:",
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Template->Object[Protocol,HPLC,"I am not real"],
				Output->{Result,Options,Tests}
			],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Test["Populate SystemPrime fields for a Dionex protocol:",
			Lookup[
				ExperimentHPLC[
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Instrument -> Model[Instrument,HPLC,"UltiMate 3000"],
					Upload -> False
				][[1]],
				{
					SystemPrimeBufferA,
					SystemPrimeBufferB,
					SystemPrimeBufferC,
					SystemPrimeBufferD,
					SystemPrimeGradient,
					Replace[SystemPrimeBufferContainerPlacements]
				}
			],
			Join[
				If[NullQ[#],
					Null,
					Alternatives@@(LinkP[#]&/@#)
				]&/@Download[
					Model[Instrument,HPLC,"UltiMate 3000"],
					{
						SystemPrimeGradients[[All,2]][BufferA][Object],
						SystemPrimeGradients[[All,2]][BufferB][Object],
						SystemPrimeGradients[[All,2]][BufferC][Object],
						SystemPrimeGradients[[All,2]][BufferD][Object],
						SystemPrimeGradients[[All,2]][Object]
					}
				],
				{
					{{LinkP[],{_String..}}..}
				}
			]
		],
		Test["Populate SystemPrime fields for a Waters protocol:",
			Lookup[
				ExperimentHPLC[
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Instrument -> Model[Instrument,HPLC,"Waters Acquity UPLC H-Class PDA"],
					Upload -> False
				][[1]],
				{
					SystemPrimeBufferA,
					SystemPrimeBufferB,
					SystemPrimeBufferC,
					SystemPrimeBufferD,
					SystemPrimeGradient,
					Replace[SystemPrimeBufferContainerPlacements]
				}
			],
			Join[
				If[NullQ[#],
					Null,
					Alternatives@@(LinkP[#]&/@#)
				]&/@Download[
					Model[Instrument,HPLC,"Waters Acquity UPLC H-Class PDA"],
					{
						SystemPrimeGradients[[All,2]][BufferA][Object],
						SystemPrimeGradients[[All,2]][BufferB][Object],
						SystemPrimeGradients[[All,2]][BufferC][Object],
						SystemPrimeGradients[[All,2]][BufferD][Object],
						SystemPrimeGradients[[All,2]][Object]
					}
				],
				{
					{{LinkP[],{_String..}}..}
				}
			]
		],
		Test["Populate SystemPrime fields for a semi-preparative Agilent protocol at CMU:",
			Lookup[
				ExperimentHPLC[
					Object[Sample,"Test Sample CMU-1 for ExperimentHPLC tests" <> $SessionUUID],
					Instrument -> Model[Instrument, HPLC, "Agilent 1260 Infinity II Semi-Preparative HPLC with UV/Vis Diode Array Detector"],
					Upload -> False
				][[1]],
				{
					SystemPrimeBufferA,
					SystemPrimeBufferB,
					SystemPrimeBufferC,
					SystemPrimeBufferD,
					SystemPrimeGradient,
					Replace[SystemPrimeBufferContainerPlacements]
				}
			],
			Join[
				If[NullQ[#],
					Null,
					Alternatives@@(LinkP[#]&/@#)
				]&/@Download[
					Model[Instrument, HPLC, "Agilent 1260 Infinity II Semi-Preparative HPLC with UV/Vis Diode Array Detector"],
					{
						SystemPrimeGradients[[All,2]][BufferA][Object],
						SystemPrimeGradients[[All,2]][BufferB][Object],
						SystemPrimeGradients[[All,2]][BufferC][Object],
						SystemPrimeGradients[[All,2]][BufferD][Object],
						SystemPrimeGradients[[All,2]][Object]
					}
				],
				{
					{{LinkP[],{_String..}}..}
				}
			]
		],
		Test["Populate SystemFlush fields for a Dionex protocol:",
			Lookup[
				ExperimentHPLC[
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Instrument -> Model[Instrument,HPLC,"UltiMate 3000"],
					Upload -> False
				][[1]],
				{
					SystemFlushBufferA,
					SystemFlushBufferB,
					SystemFlushBufferC,
					SystemFlushBufferD,
					SystemFlushGradient,
					Replace[SystemFlushBufferContainerPlacements]
				}
			],
			Join[
				If[NullQ[#],
					Null,
					LinkP[#]
				]&/@Download[
					Model[Instrument,HPLC,"UltiMate 3000"],
					{
						SystemFlushGradients[[All,2]][BufferA][Object],
						SystemFlushGradients[[All,2]][BufferB][Object],
						SystemFlushGradients[[All,2]][BufferC][Object],
						SystemFlushGradients[[All,2]][BufferD][Object],
						SystemFlushGradients[[All,2]][Object]
					}
				],
				{
					{{LinkP[],{_String..}}..}
				}
			]
		],
		Test["Populate SystemFlush fields for a Waters protocol:",
			Lookup[
				ExperimentHPLC[
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Instrument -> Model[Instrument,HPLC,"Waters Acquity UPLC H-Class PDA"],
					Upload -> False
				][[1]],
				{
					SystemFlushBufferA,
					SystemFlushBufferB,
					SystemFlushBufferC,
					SystemFlushBufferD,
					SystemFlushGradient,
					Replace[SystemFlushBufferContainerPlacements]
				}
			],
			Join[
				LinkP[#]&/@Download[
					Model[Instrument,HPLC,"Waters Acquity UPLC H-Class PDA"],
					{
						SystemFlushGradients[[All,2]][BufferA][Object],
						SystemFlushGradients[[All,2]][BufferB][Object],
						SystemFlushGradients[[All,2]][BufferC][Object],
						SystemFlushGradients[[All,2]][BufferD][Object],
						SystemFlushGradients[[All,2]][Object]
					}
				],
				{
					{{LinkP[],{_String..}}..}
				}
			]
		],
		Test["Populate SystemFlush fields for a semi-preparative Agilent protocol at CMU:",
			Lookup[
				ExperimentHPLC[
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Instrument -> Model[Instrument, HPLC, "Agilent 1260 Infinity II Semi-Preparative HPLC with UV/Vis Diode Array and Fluorescence Detectors"],
					Upload -> False
				][[1]],
				{
					SystemFlushBufferA,
					SystemFlushBufferB,
					SystemFlushBufferC,
					SystemFlushBufferD,
					SystemFlushGradient,
					Replace[SystemFlushBufferContainerPlacements]
				}
			],
			Join[
				LinkP[#]&/@Download[
					Model[Instrument, HPLC, "Agilent 1260 Infinity II Semi-Preparative HPLC with UV/Vis Diode Array and Fluorescence Detectors"],
					{
						SystemFlushGradients[[All,2]][BufferA][Object],
						SystemFlushGradients[[All,2]][BufferB][Object],
						SystemFlushGradients[[All,2]][BufferC][Object],
						SystemFlushGradients[[All,2]][BufferD][Object],
						SystemFlushGradients[[All,2]][Object]
					}
				],
				{
					{{LinkP[],{_String..}}..}
				}
			]
		],
		Test["Do not create resources for SystemPrime, SystemFlush and NeedleWashSolution fields (will do that in hplcWavefunctionCollapse):",
			Cases[
				Download[
					ExperimentHPLC[
						Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID]
					],
					RequiredResources
				],
				{
					_,
					Alternatives[
						SystemPrimeBufferA, SystemPrimeBufferB, SystemPrimeBufferC, SystemPrimeBufferD,
						SystemFlushBufferA, SystemFlushBufferB, SystemFlushBufferC, SystemFlushBufferD,
						NeedleWashSolution
					],
					___
				}
			],
			{}
		],
		Test["Populates ReplacementFractionContainers when collecting fractions:",
			With[
				{
					packet = ExperimentHPLC[
						{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
						Upload->False,
						CollectFractions->True
					][[1]]
				},
				Lookup[
					packet,
					Replace[ReplacementFractionContainers]
				]
			],
			{
				Link[Model[Container, Plate, "id:L8kPEjkmLbvW"]],
				Link[Model[Container, Plate, "id:L8kPEjkmLbvW"]],
				Link[Model[Container, Plate, "id:L8kPEjkmLbvW"]],
				Link[Model[Container, Plate, "id:L8kPEjkmLbvW"]]
			}
		],
		Test["Do not populate ReplacementFractionContainers when not collecting fractions:",
			With[{packet = ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Upload->False][[1]]},
				Lookup[
					packet,
					Replace[ReplacementFractionContainers]
				]
			],
			{}
		],
		Test["Select the correct low pressure limit and high pressure limit for the protocol:",
			With[{packet = ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Column -> Model[Item, Column, "Test cartridge-protected column model for ExperimentHPLC" <> $SessionUUID],
				GuardColumn -> Model[Item, Column, "Test cartridge guard column model for ExperimentHPLC" <> $SessionUUID],
				Upload->False][[1]]},
				Lookup[
					packet,
					{MaxPressure,MinPressure}
				]
			],
			{3400PSI,100PSI},
			EquivalenceFunction -> Equal
		],
		Test["ExperimentHPLC works on an input of a position in a container:",
			ExperimentHPLC[
				{"A1",Object[Container,Plate,"Test plate 1 for ExperimentHPLC tests" <> $SessionUUID]}
			],
			ObjectP[Object[Protocol,HPLC]]
		],
		Test["ExperimentHPLC works on an input list of container positions:",
			With[
				{
					packet = ExperimentHPLC[
						{
							{"A1",Object[Container,Plate,"Test plate 1 for ExperimentHPLC tests" <> $SessionUUID]},
							{"A3",Object[Container,Plate,"Test plate 1 for ExperimentHPLC tests" <> $SessionUUID]}
						},
						Upload->False
					][[1]]
				},
				Lookup[
					packet,
					Replace[SamplesIn]
				]
			],
			{
				ObjectP[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID]],
				ObjectP[Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]]
			}
		],

		(* === Options - General === *)
		Example[
			{Options,Instrument,"Specify the instrument to use:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					Instrument->Model[Instrument, HPLC, "UltiMate 3000"]
				][[1]];
				Lookup[
					packet,
					Instrument
				]
			),
			LinkP[Model[Instrument, HPLC, "UltiMate 3000"]],
			Variables:>{packet}
		],
		Example[
			{Options,Instrument,"Specify the multiple instruments that can be used to perform the desired HPLC measurement and fraction collection when availability of the desired Instrument is limited:"},
			(
				protocol = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Instrument->{Model[Instrument, HPLC, "UltiMate 3000"],Model[Instrument, HPLC, "UltiMate 3000 with PCM Detector"],Model[Instrument, HPLC, "UltiMate 3000 with FLR Detector"]}
				];
				Lookup[
					Download[
						protocol,
						AlternateOptions
					],
					Instrument
				]
			),
			{ObjectP[Model[Instrument, HPLC, "UltiMate 3000 with PCM Detector"]],ObjectP[Model[Instrument, HPLC, "UltiMate 3000 with FLR Detector"]]},
			Variables:>{options}
		],
		Example[
			{Options,Instrument,"Specify the preparative scale instrument to use:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],Object[Sample,"Test Sample 8 for ExperimentHPLC tests (15mL Tube)" <> $SessionUUID], Object[Sample,"Test Sample 9 for ExperimentHPLC tests (15mL Tube)" <> $SessionUUID]},
					Upload->False,
					Instrument->Model[Instrument, HPLC, "Agilent 1290 Infinity II LC System"]
				][[1]];
				Lookup[
					packet,
					Instrument
				]
			),
			LinkP[Model[Instrument, HPLC, "id:R8e1Pjp1md8p"]],
			Variables:>{packet}
		],
		Example[
			{Options,Scale,"The Scale option resolves collecting fractions, injection volume/amount, flow rate, and fraction collection parameters:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					Scale->SemiPreparative
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					{
						FlowRate,
						CollectFractions,
						InjectionVolume
					}
				]
			),
			{
				1 Milliliter / Minute,
				True,
				460. Microliter
			},
			EquivalenceFunction -> Equal,
			Variables:>{packet}
		],
		Example[
			{Options,Scale,"Resolves to Preparative scale when needed:"},
			(
				packet = ExperimentHPLC[
					Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],
					Upload->False,
					Column->Model[Item, Column, "Test high flow rate column model for ExperimentHPLC" <> $SessionUUID],
					FlowRate->30Milliliter/Minute,
					CollectFractions->True
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					{Scale,Instrument}
				]
			),
			{
				Preparative,
				{ObjectP[Model[Instrument, HPLC, "Agilent 1290 Infinity II LC System"]]}
			},
			Variables:>{packet}
		],
		Example[
			{Options,SeparationMode,"Specify the type of chromatography for the protocol:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					SeparationMode->ReversePhase
				][[1]];
				Lookup[
					packet,
					SeparationMode
				]
			),
			ReversePhase,
			Variables:>{packet}
		],
		Example[
			{Options,SeparationMode,"Automatically inherit SeparationMode from the specified column:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},

					Column -> Object[Item,Column,"Test cartridge-protected column object for ExperimentHPLC" <> $SessionUUID],
					Upload -> False
				][[1]];
				{Lookup[packet,SeparationMode],Download[Object[Item,Column,"Test cartridge-protected column object for ExperimentHPLC" <> $SessionUUID],Model[SeparationMode]]}
			),
			_?(MatchQ[#[[1]],#[[2]]]&),
			Variables:>{packet}
		],
		Example[
			{Options,Detector,"Specify the type of Detector desired:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->PhotoDiodeArray, OutputFormat -> List];
			Lookup[options,Detector],
			{PhotoDiodeArray},
			Variables:>{options}
		],
		Example[
			{Options,Detector,"Specify multiple types of desired Detector to measure different signals of the sample:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{MultiAngleLightScattering,DynamicLightScattering}, OutputFormat -> List];
			Lookup[options,Detector],
			{MultiAngleLightScattering,DynamicLightScattering},
			Variables:>{options}
		],

		(* === Options - Column === *)
		Example[
			{Options,Column,"Specify the column model to use for the samples:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					Column -> Model[Item,Column,"Aeris XB-C18 15cm Peptide Column"]
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					Column
				]
			),
			Download[Model[Item,Column,"Aeris XB-C18 15cm Peptide Column"],Object],
			Variables:>{packet}
		],
		Example[{Options,Column,"Specify no column to use (Column->Null):"},
			protocol=ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Column -> Null
			];
			Download[protocol, {Column, ColumnSelectorAssembly}],
			{
				Null,
				{
					<|
						ColumnPosition -> PositionA,
						GuardColumn -> Null,
						GuardColumnOrientation -> Null,
						GuardColumnJoin -> Null,
						Column -> Null,
						ColumnOrientation -> Null,
						ColumnJoin -> Null,
						SecondaryColumn -> Null,
						SecondaryColumnJoin -> Null,
						TertiaryColumn -> Null
					|>
				}
			},
			Variables:>{protocol}
		],
		Example[
			{Options,Column,"Specify the column object to use for the samples:"},
			Download[ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Column -> Object[Item,Column,"Test cartridge-protected column object for ExperimentHPLC" <> $SessionUUID]
			],Column],
			ObjectP[Object[Item,Column,"Test cartridge-protected column object for ExperimentHPLC" <> $SessionUUID]]
		],
		Example[
			{Options,Column,"If multiple columns are connected together for the HPLC experiment of the samples and GuardColumn resolves automatically, GuardColumn is resolved based on just the Column option:"},
			Download[ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Column -> Model[Item,Column,"id:dORYzZn0obYE"],
				SecondaryColumn -> Model[Item,Column,"id:o1k9jAKOw6d7"]
			],GuardColumn],
			LinkP[Model[Item, Column, "id:mnk9jO3doO6R"]]
		],
		Example[
			{Options,SecondaryColumn,"Specify the additional column model to use for the samples at downstream of the Column. ColumnSelector option is resolved to show the column connection:"},
			options=ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Column -> Model[Item,Column,"id:o1k9jAKOw6d7"],
				SecondaryColumn -> Model[Item,Column,"id:1ZA60vwjbRla"],
				Output->Options
			];
			Lookup[options,ColumnSelector],
			{PositionA, Model[Item, Column, "id:mnk9jO3doO6R"], Forward, Model[Item,Column,"id:o1k9jAKOw6d7"],Forward, Model[Item,Column,"id:1ZA60vwjbRla"],Null},
			Variables:>{options}
		],
		Example[
			{Options,SecondaryColumn,"Specify the additional column object to use for the samples at downstream of the Column. ColumnSelectorAssembly is resolved to show the column connection:"},
			Download[ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Column -> Object[Item,Column,"Test cartridge-protected column object for ExperimentHPLC" <> $SessionUUID],
				SecondaryColumn -> Object[Item,Column,"Test cartridge-protected column object for ExperimentHPLC (2)" <> $SessionUUID]
			],{Column,SecondaryColumn,ColumnSelectorAssembly}],
			{
				(* Column *)
				LinkP[Object[Item,Column,"Test cartridge-protected column object for ExperimentHPLC" <> $SessionUUID]],
				(* SecondaryColumn *)
				LinkP[Object[Item,Column,"Test cartridge-protected column object for ExperimentHPLC (2)" <> $SessionUUID]],
				(* ColumnSelectorAssembly *)
				{
					KeyValuePattern[
						{
							ColumnPosition -> PositionA,
							GuardColumn-> LinkP[Model[Item, Column, "Test cartridge guard column model for ExperimentHPLC"<>$SessionUUID]],
							GuardColumnOrientation -> Forward,
							GuardColumnJoin -> Null,
							Column->LinkP[Object[Item, Column,"Test cartridge-protected column object for ExperimentHPLC" <> $SessionUUID]],
							ColumnOrientation -> Forward,
							ColumnJoin -> LinkP[Model[Plumbing, ColumnJoin, "id:bq9LA0J98evL"]],
							SecondaryColumn ->LinkP[Object[Item, Column,"Test cartridge-protected column object for ExperimentHPLC (2)" <> $SessionUUID]],
							SecondaryColumnJoin -> Null,
							TertiaryColumn -> Null
						}
					]
				}
			}
		],
		Example[
			{Options,TertiaryColumn,"Specify the additional column to use for the samples at downstream of the Column and SecondaryColumn. ColumnSelector option is resolved to show the column connections. All Column options can be set to either Model or Object:"},
			options=ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Column -> Model[Item,Column,"id:o1k9jAKOw6d7"],
				SecondaryColumn -> Model[Item,Column,"id:1ZA60vwjbRla"],
				TertiaryColumn -> Object[Item,Column,"Test cartridge-protected column object for ExperimentHPLC (2)" <> $SessionUUID],
				Output->Options
			];
			{Lookup[options,Column],Lookup[options,SecondaryColumn],Lookup[options,TertiaryColumn],Lookup[options,ColumnSelector]},
			{
				(* Column *)
				Model[Item,Column,"id:o1k9jAKOw6d7"],
				(* SecondaryColumn *)
				Model[Item,Column,"id:1ZA60vwjbRla"],
				(* TertiaryCollumn *)
				ObjectP[Object[Item,Column,"Test cartridge-protected column object for ExperimentHPLC (2)" <> $SessionUUID]],
				(* ColumnSelector *)
				{
					PositionA,
					Model[Item, Column, "id:mnk9jO3doO6R"],
					Forward,
					Model[Item, Column, "id:o1k9jAKOw6d7"],
					Forward,
					Model[Item, Column, "id:1ZA60vwjbRla"],
					ObjectP[Object[Item, Column, "Test cartridge-protected column object for ExperimentHPLC (2)" <> $SessionUUID]]
				}
			},
			Variables:>{options}
		],
		Example[
			{Options,ColumnOrientation,"Specify the direction of the Column with respect to the flow.:"},
			options=ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Column -> Model[Item,Column,"id:o1k9jAKOw6d7"],
				ColumnOrientation -> Reverse,
				Output->Options
			];
			Lookup[options,ColumnOrientation],
			Reverse,
			Variables:>{options}
		],
		Example[
			{Options,ColumnSelection,"Set ColumnSelection option to True to indicate that multiple sets of columns are used in the experiment:"},
			protocol=ExperimentHPLC[
				{Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID]},
				ColumnSelection->True,
				ColumnSelector -> {
					{PositionA,Null,Null,Model[Item,Column,"id:o1k9jAKOw6d7"],Forward,Null,Null},
					{PositionB,Null,Null,Model[Item,Column,"id:dORYzZn0obYE"],Forward,Null,Null}
				}
			];
			Lookup[Download[protocol,ColumnSelectorAssembly],{ColumnPosition, GuardColumn, GuardColumnOrientation, GuardColumnJoin, Column, ColumnOrientation, ColumnJoin, SecondaryColumn, SecondaryColumnJoin, TertiaryColumn}],
			{
				{PositionA, Null, Null, Null, LinkP[Model[Item, Column, "id:o1k9jAKOw6d7"]], Forward, Null, Null, Null, Null},
				{PositionB, Null, Null, Null, LinkP[Model[Item, Column, "id:dORYzZn0obYE"]], Forward, Null, Null, Null, Null}
			},
			Variables:>{protocol}
		],
		Example[
			{Options,ColumnSelector,"ColumnSelector option can be specified to easily select all columns for the experiment and their sequence of connections:"},
			options=ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnSelector -> {PositionA,Null,Null,Model[Item,Column,"id:dORYzZn0obYE"],Forward,Model[Item,Column,"id:o1k9jAKOw6d7"],Null},
				Output->Options
			];
			Lookup[options,ColumnSelector],
			{PositionA,Null,Null,Model[Item,Column,"id:dORYzZn0obYE"],Forward,Model[Item,Column,"id:o1k9jAKOw6d7"],Null},
			Variables:>{options}
		],
		Example[
			{Options,ColumnSelector,"ColumnSelector option is resolved to Null if only one set of column is allowed on the Instrument:"},
			options=ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				GuardColumn -> Model[Item,Column,"id:mnk9jO3doO6R"],
				Column -> Model[Item,Column,"id:dORYzZn0obYE"],
				SecondaryColumn -> Model[Item,Column,"id:o1k9jAKOw6d7"],
				TertiaryColumn -> Null,
				Output->Options
			];
			Lookup[options,ColumnSelector],
			{
				PositionA,
				ObjectP[Model[Item, Column, "id:mnk9jO3doO6R"]],
				Forward,
				ObjectP[Model[Item, Column, "id:dORYzZn0obYE"]],
				Forward,
				ObjectP[Model[Item, Column, "id:o1k9jAKOw6d7"]],
				Null
			},
			Variables:>{options}
		],
		Test[
			{Options,ColumnSelector,"ColumnSelectionAssembly field is automatically filled based on the specified GuardColumn, Column, SecondaryColumn and TertiaryColumn options:"},
			packet=ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				GuardColumn -> Model[Item,Column,"id:mnk9jO3doO6R"],
				Column -> Model[Item,Column,"id:dORYzZn0obYE"],
				SecondaryColumn -> Model[Item,Column,"id:o1k9jAKOw6d7"],
				TertiaryColumn -> Null,
				Upload->False
			][[1]];
			Lookup[packet, Replace[ColumnSelectorAssembly]],
			{<|ColumnPosition -> PositionA,
				GuardColumn -> Link[Model[Item, Column, "id:mnk9jO3doO6R"]],
				GuardColumnOrientation -> Forward, GuardColumnJoin -> Null,
				Column -> Link[Model[Item, Column, "id:dORYzZn0obYE"]],
				ColumnOrientation -> Forward,
				ColumnJoin -> Link[Model[Plumbing, ColumnJoin, "id:bq9LA0J98evL"]],
				SecondaryColumn -> Link[Model[Item, Column, "id:o1k9jAKOw6d7"]],
				SecondaryColumnJoin -> Null, TertiaryColumn -> Null|>},
			Variables:>{packet}
		],
		Example[
			{Options,ColumnStorageBuffer,"Sets the solvent in which the selected column should be stored in for long term storage after removing from the instrument (used to decide ColumnFlushGradient):"},
			options=ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				BufferC->Model[Sample, "Milli-Q water"],
				ColumnStorageBuffer->Model[Sample, "Milli-Q water"],
				Output->Options
			];
			{
				Lookup[options,ColumnStorageBuffer],
				Lookup[options,ColumnFlushGradient][[-1,4]]
			},
			{
				ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],
				EqualP[100Percent]
			},
			Variables:>{options}
		],
		Example[
			{Options,ColumnStorageBuffer,"Sets the solvent in which the selected column should be stored in for long term storage after removing from the instrument (can be different for multiple column sets in the column selector):"},
			protocol=ExperimentHPLC[
				{Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID]},
				ColumnSelection->True,
				ColumnSelector -> {
					{PositionA,Null,Null,Model[Item,Column,"id:o1k9jAKOw6d7"],Forward,Null,Null},
					{PositionB,Null,Null,Model[Item,Column,"id:dORYzZn0obYE"],Forward,Null,Null}
				},
				BufferA->Model[Sample, "Milli-Q water"],
				BufferB->Model[Sample, StockSolution, "20% Methanol in MilliQ Water"],
				ColumnStorageBuffer->{Model[Sample, "Milli-Q water"],Model[Sample, StockSolution, "20% Methanol in MilliQ Water"]}
			];
			{
				Lookup[Download[protocol,ResolvedOptions],ColumnStorageBuffer],
				Download[protocol,ColumnFlushGradients[Gradient]][[All,-1,2;;5]]
			},
			{
				{ObjectP[Model[Sample, "id:8qZ1VWNmdLBD"]],ObjectP[Model[Sample, StockSolution, "id:Z1lqpMzmp5MO"]]},
				{
					{EqualP[100Percent],EqualP[0Percent],EqualP[0Percent],EqualP[0Percent]},
					{EqualP[0Percent],EqualP[100Percent],EqualP[0Percent],EqualP[0Percent]}
				}
			},
			Variables:>{protocol}
		],
		Example[
			{Options,ColumnStorageBuffer,"Sets the gradient in which the selected column should be stored in for long term storage after removing from the instrument (used to decide ColumnFlushGradient):"},
			protocol=ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnStorageBuffer->{50Percent,10Percent,15Percent,25Percent}
			];
			Download[protocol,ColumnFlushGradients[Gradient]][[1,-1,2;;5]],
			{EqualP[50Percent],EqualP[10Percent],EqualP[15Percent],EqualP[25Percent]},
			Variables:>{protocol}
		],
		Example[
			{Options,IncubateColumn,"Specifies that the columns should be placed in the column oven compartment during the HPLC run:"},
			(
				options = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Output->Options,
					IncubateColumn->True
				];
				Lookup[options,IncubateColumn]
			),
			True,
			Variables:>{options}
		],
		Example[
			{Options,IncubateColumn,"Specifies that the columns should be placed outside the column oven compartment during the HPLC run:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					IncubateColumn->False
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					IncubateColumn
				]
			),
			False,
			Variables:>{packet}
		],
		Example[
			{Options,GuardColumn,"If guard column is specified as a cartridge model, GuardCartridge is the specified cartridge and GuardColumn is in the cartridge model's PreferredGuardColumn field:"},
			Download[ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				GuardColumn -> Model[Item,Cartridge,Column,"Test model cartridge for ExperimentHPLC" <> $SessionUUID]
			],{GuardColumn,GuardCartridge}],
			{LinkP[Model[Item,Column,"Test cartridge guard column model for ExperimentHPLC" <> $SessionUUID]],{LinkP[Model[Item,Cartridge,Column,"Test model cartridge for ExperimentHPLC" <> $SessionUUID]]}}
		],
		Example[
			{Options,GuardColumn,"If guard column is specified as a cartridge model, GuardCartridge is the specified cartridge and GuardColumn is in the cartridge model's PreferredGuardColumn field (2):"},
			Download[ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				GuardColumn -> Model[Item,Cartridge,Column,"Test model cartridge for ExperimentHPLC (2)" <> $SessionUUID]
			],{GuardColumn,GuardCartridge}],
			{LinkP[Model[Item, Column, "Test cartridge guard column model for ExperimentHPLC" <> $SessionUUID]], {LinkP[Model[Item, Cartridge, Column, "Test model cartridge for ExperimentHPLC (2)" <> $SessionUUID]]}}
		],
		Example[
			{Options,GuardColumn,"If guard column is specified as a cartridge object, GuardCartridge is the specified cartridge and GuardColumn is the first column in the cartridge's model's PreferredGuardColumn field:"},
			Download[ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				GuardColumn -> Object[Item,Cartridge,Column,"Test cartridge for ExperimentHPLC" <> $SessionUUID]
			],{GuardColumn,GuardCartridge}],
			{LinkP[Model[Item, Column, "Test cartridge guard column model for ExperimentHPLC" <> $SessionUUID]], {LinkP[Object[Item, Cartridge, Column, "Test cartridge for ExperimentHPLC" <> $SessionUUID]]}}
		],
		Example[
			{Options,GuardColumn,"Specify GuardColumn as Null:"},
			Download[ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				GuardColumn -> Null
			],GuardColumn],
			Null
		],
		Example[
			{Options,GuardColumn,"If guard column is specified as a cartridge-type column model, GuardCartridge is the preferred guard cartridge for that column model:"},
			Download[ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				GuardColumn -> Model[Item,Column,"Test cartridge guard column model for ExperimentHPLC" <> $SessionUUID]
			],{GuardColumn,GuardCartridge}],
			{LinkP[Model[Item, Column, "Test cartridge guard column model for ExperimentHPLC" <> $SessionUUID]], {LinkP[Model[Item, Cartridge, Column, "Test model cartridge for ExperimentHPLC" <> $SessionUUID]]}}
		],
		Example[
			{Options,GuardColumn,"If guard column is specified as a cartridge-type column object, GuardCartridge is the preferred guard cartridge for that column's model:"},
			Download[ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				GuardColumn -> Object[Item,Column,"Test cartridge guard column object for ExperimentHPLC" <> $SessionUUID]
			],{GuardColumn,GuardCartridge}],
			{LinkP[Object[Item, Column, "Test cartridge guard column object for ExperimentHPLC" <> $SessionUUID]], {LinkP[Model[Item, Cartridge, Column, "Test model cartridge for ExperimentHPLC" <> $SessionUUID]]}}
		],
		Example[
			{Options,GuardColumn,"If guard column is specified as a non-cartridge-type column model, GuardCartridge is not populated:"},
			Download[ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				GuardColumn -> Model[Item,Column,"DNAPac PA200 Guard Column"]
			],{GuardColumn,GuardCartridge}],
			{LinkP[Model[Item, Column, "DNAPac PA200 Guard Column"]], {Null}}
		],
		Example[
			{Options,GuardColumnOrientation,"Specify the directionality of the guard column:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				GuardColumn->Model[Item,Column, "Test cartridge guard column model for ExperimentHPLC" <> $SessionUUID],GuardColumnOrientation->Reverse,
				OutputFormat -> List];
			Lookup[options,GuardColumnOrientation],
			Reverse,
			Variables:>{options}
		],
		Example[
			{Options,ColumnPosition,"Specify the column selector for the injection of each sample:"},
			protocol=ExperimentHPLC[
				{Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID]},
				ColumnSelection->True,
				ColumnSelector -> {
					{PositionA,Null,Null,Model[Item,Column,"id:o1k9jAKOw6d7"],Forward,Null,Null},
					{PositionB,Null,Null,Model[Item,Column,"id:dORYzZn0obYE"],Forward,Null,Null}
				},
				ColumnPosition -> {PositionA, PositionB}
			];
			Lookup[Cases[Download[protocol,InjectionTable],KeyValuePattern[Type->Sample]],{Sample,ColumnPosition}],
			{
				{ObjectP[Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID]],PositionA},
				{ObjectP[Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID]],PositionB}
			},
			Variables:>{protocol}
		],
		Example[
			{Options,ColumnTemperature,"Specify the column temperature at which to run each sample:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					ColumnTemperature -> 42.4 Celsius
				][[1]];
				{
					Lookup[
						Lookup[
							packet,
							ResolvedOptions
						],
						ColumnTemperature
					],
					Lookup[
						Cases[
							Lookup[packet, Replace[InjectionTable]],
							KeyValuePattern[Type -> Sample]
						],
						ColumnTemperature
					]
				}
			),
			{42.4 Celsius, {42.4 Celsius, 42.4 Celsius, 42.4 Celsius}},
			Variables:>{packet}
		],

		(* === Options - NumberOfReplicates === *)
		Example[{Options,NumberOfReplicates,"Indicate the number of times the experiment should be replicated:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], NumberOfReplicates->3, Output -> Options];
			Lookup[options, NumberOfReplicates],
			3,
			Variables :> {options}
		],
		Test["If NumberOfReplicates is greater than 1, the InjectionTable is updated accordingly:",
			(
				protocol = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], NumberOfReplicates->3];
				Length[Cases[
					Download[protocol, InjectionTable],
					KeyValuePattern[Type->Sample]
				]]
			),
			3,
			Variables :> {protocol}
		],
		Test["If NumberOfReplicates is greater than 1, SamplesIn index-matched fields are either empty or expanded to match:",
			(
				protocol = ExperimentHPLC[{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID]}, NumberOfReplicates->3];
				indexMatchedFields = Select[Lookup[LookupTypeDefinition[Object[Protocol, HPLC]], Fields], MemberQ[#[[2]], HoldPattern[IndexMatching -> SamplesIn]] &][[All, 1]];
				Length /@ Download[protocol, indexMatchedFields]
			),
			(* Fields are allowed to be empty, but if they are populated, they must match the length of SamplesIn * NumberOfReplicates *)
			{(0|6)..},
			Variables :> {protocol, indexMatchedFields}
		],

		(* === Options - Buffers === *)
		Example[
			{Options,BufferA,"Specify the buffer A for the protocol:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					BufferA->Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"]
				][[1]];
				Lookup[
					packet,
					BufferA
				]
			),
			LinkP[Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"]],
			Variables:>{packet}
		],
		Example[
			{Options,BufferB,"Specify the buffer B for the protocol:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					BufferB -> Model[Sample, StockSolution, "Reverse phase buffer B 0.05% HFBA"]
				][[1]];
				Lookup[
					packet,
					BufferB
				]
			),
			LinkP[Model[Sample, StockSolution, "Reverse phase buffer B 0.05% HFBA"]],
			Variables:>{packet}
		],
		Example[
			{Options,BufferC,"Specify the buffer C for the protocol:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					BufferC -> Model[Sample, "Acetonitrile, HPLC Grade"]
				][[1]];
				Lookup[
					packet,
					BufferC
				]
			),
			LinkP[Model[Sample, "Acetonitrile, HPLC Grade"]],
			Variables:>{packet}
		],
		Example[
			{Options,BufferD,"Specify the buffer D for the protocol:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					BufferD -> Model[Sample, "Acetonitrile, HPLC Grade"]
				][[1]];
				Lookup[
					packet,
					BufferD
				]
			),
			LinkP[Model[Sample, "Acetonitrile, HPLC Grade"]],
			Variables:>{packet}
		],

		(* === Options - InjectionTable === *)
		Example[
			{Options,InjectionTable,"Specify a custom injection sequence to run for the experiment:"},
			(
				customInjectionTable={
					{ColumnPrime,Null,Null,PositionA,Ambient,Object[Method, Gradient, "id:M8n3rxYAonm5"]},
					{Sample,Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],10Microliter,PositionA,Ambient,Object[Method, Gradient, "id:M8n3rxYAonm5"]},
					{Blank,Model[Sample,"Milli-Q water"],10Microliter,PositionA,Ambient,Object[Method, Gradient, "id:M8n3rxYAonm5"]},
					{Sample,Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],10Microliter,PositionA,Ambient,Object[Method, Gradient, "id:M8n3rxYAonm5"]},
					{ColumnFlush,Null,Null,PositionA,Ambient,Object[Method, Gradient, "id:M8n3rxYAonm5"]},
					{Standard,Model[Sample,StockSolution,Standard,"id:N80DNj1rWzaq"],10Microliter,PositionA,Ambient,Object[Method, Gradient, "id:M8n3rxYAonm5"]},
					{Sample,Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID],10Microliter,PositionA,Ambient,Object[Method, Gradient, "id:M8n3rxYAonm5"]},
					{ColumnFlush,Null,Null,PositionA,Ambient,Object[Method, Gradient, "id:M8n3rxYAonm5"]}
				};

				options=ExperimentHPLCOptions[{
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]
				},
					InjectionTable->customInjectionTable,
					ColumnSelector -> {PositionA,Null,Null,Model[Item,Column,"id:o1k9jAKOw6d7"],Forward,Null,Null},
					OutputFormat->List
				];

				Lookup[options,InjectionTable]
			),
			customInjectionTable/.{x:ObjectP[]:>ObjectReferenceP[x]},
			Variables:>{customInjectionTable,options},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],

		(* === Options - Sample Parameters === *)
		Example[
			{Options,SampleTemperature,"Specify the autosampler temperature while the protocol runs:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					SampleTemperature -> 10 Celsius
				][[1]];
				Lookup[
					packet,
					{Instrument,SampleTemperature}
				]
			),
			{LinkP[Model[Instrument,HPLC,"Waters Acquity UPLC H-Class PDA"]],10 Celsius},
			Variables:>{packet}
		],
		Example[
			{Options,InjectionVolume,"Specify the injection volume for each sample:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					InjectionVolume->{100 Micro Liter,100 Micro Liter,100 Micro Liter}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					InjectionVolume
				]
			),
			{100 Microliter,100 Microliter,100 Microliter},
			Variables:>{packet}
		],
		Example[
			{Options,InjectionVolume,"Resolve the injection volume for semi-prep scale experiment:"},
			(
				protocol1 = ExperimentHPLC[
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Scale->SemiPreparative,
					Output->Options
				];
				protocol2 = ExperimentHPLC[
					Object[Sample, "Test Sample CMU-1 for ExperimentHPLC tests" <> $SessionUUID],
					Scale->SemiPreparative,
					Output->Options
				];
				Lookup[
					{protocol1,protocol2},
					InjectionVolume
				]
			),
			{460 Microliter,460 Microliter},
			EquivalenceFunction -> Equal,
			Variables:>{protocol1,protocol2}
		],
		Example[{Options,NeedleWashSolution,"Specify the solvent used to wash the injection needle:"},
			options=ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				NeedleWashSolution->Model[Sample, "Milli-Q water"],Output->Options];
			Lookup[options,NeedleWashSolution],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables:>{options}
		],

		(* === Options - Gradients === *)
		Example[
			{Options,GradientA,"Specify the buffer A gradient for each sample:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					GradientA -> {
						{{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}},
						{{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}},
						{{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}
					}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					GradientA
				]
			),
			Table[{{0 Minute, 10. Percent},{5 Minute,10. Percent},{50 Minute,100. Percent},{50.1 Minute,0. Percent},{55 Minute,0. Percent}},3],
			EquivalenceFunction -> Equal,
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			},
			Variables:>{packet}
		],
		Example[
			{Options,GradientB,"Specify the buffer B gradient for each sample:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					GradientB -> {
						{{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}},
						{{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}},
						{{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}
					}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					GradientB
				]
			),
			Table[{{0 Minute, 10. Percent},{5 Minute,10. Percent},{50 Minute,100. Percent},{50.1 Minute,0. Percent},{55 Minute,0. Percent}},3],
			EquivalenceFunction -> Equal,
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			},
			Variables:>{packet}
		],
		Example[
			{Options,GradientC,"Specify the buffer C gradient for each sample:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					GradientC -> {
						{{50.1 Minute,100 Percent},{55 Minute,100 Percent}},
						{{50.1 Minute,100 Percent},{55 Minute,100 Percent}},
						{{50.1 Minute,100 Percent},{55 Minute,100 Percent}}
					}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					GradientC
				]
			),
			Table[{{50.1 Minute,100 Percent},{55 Minute,100 Percent}},3],
			EquivalenceFunction -> Equal,
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			},
			Variables:>{packet}
		],
		Example[
			{Options,GradientD,"Specify the buffer D gradient for each sample:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					GradientD -> {
						{{50.1 Minute,100 Percent},{55 Minute,100 Percent}},
						{{50.1 Minute,100 Percent},{55 Minute,100 Percent}},
						{{50.1 Minute,100 Percent},{55 Minute,100 Percent}}
					}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					GradientD
				]
			),
			Table[{{50.1 Minute,100 Percent},{55 Minute,100 Percent}},3],
			EquivalenceFunction -> Equal,
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			},
			Variables:>{packet}
		],
		Example[
			{Options,FlowRate,"Specify the speed of the fluid through the pump:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					FlowRate -> 1.5 Milli Liter / Minute
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					FlowRate
				]
			),
			1.5 Milliliter/Minute,
			EquivalenceFunction -> Equal,
			Variables:>{packet}
		],
		Example[{Options,MaxAcceleration,"Specify the max allowed change in speed at which the flow rate ramps:"},
			options=ExperimentHPLCOptions[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument -> Model[Instrument, HPLC, "id:Z1lqpMGJmR0O"],
				MaxAcceleration -> 10 Milliliter/Minute/Minute,
				OutputFormat -> List
			];
			Lookup[options,MaxAcceleration],
			10 Milliliter/Minute/Minute,
			Variables:>{options}
		],
		Example[
			{Options,Gradient,"Specify the existing gradient method for each sample:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					Gradient -> Object[Method, Gradient, "id:M8n3rxYAonm5"]
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					Gradient
				]
			),
			ObjectP[Object[Method, Gradient, "id:M8n3rxYAonm5"]],
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options,Gradient,"Specify the buffer composition over time in the fluid flow:"},
			(
				options = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Output->Options,
					Gradient -> {
						{0Minute,100Percent,0Percent,0Percent,0Percent,1Milliliter/Minute,None},
						{20Minute,50Percent,50Percent,0Percent,0Percent,1Milliliter/Minute,None},
						{20.1Minute,0Percent,100Percent,0Percent,0Percent,1Milliliter/Minute,None},
						{22.5Minute,0Percent,100Percent,0Percent,0Percent,1Milliliter/Minute,None},
						{22.6Minute,0Percent,0Percent,100Percent,0Percent,1Milliliter/Minute,None},
						{25Minute,0Percent,0Percent,100Percent,0Percent,1Milliliter/Minute,None},
						{25.1Minute,100Percent,0Percent,0Percent,0Percent,1Milliliter/Minute,None},
						{28Minute,100Percent,0Percent,0Percent,0Percent,1Milliliter/Minute,None}
					}
				];
				Lookup[options,Gradient]
			),
			{
				{0Minute,100Percent,0Percent,0Percent,0Percent,1Milliliter/Minute,None},
				{20Minute,50Percent,50Percent,0Percent,0Percent,1Milliliter/Minute,None},
				{20.1Minute,0Percent,100Percent,0Percent,0Percent,1Milliliter/Minute,None},
				{22.5Minute,0Percent,100Percent,0Percent,0Percent,1Milliliter/Minute,None},
				{22.6Minute,0Percent,0Percent,100Percent,0Percent,1Milliliter/Minute,None},
				{25Minute,0Percent,0Percent,100Percent,0Percent,1Milliliter/Minute,None},
				{25.1Minute,100Percent,0Percent,0Percent,0Percent,1Milliliter/Minute,None},
				{28Minute,100Percent,0Percent,0Percent,0Percent,1Milliliter/Minute,None}
			},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],

		(* === Options - Sample Detector Parameters === *)
		Example[
			{Options,AbsorbanceWavelength,"Specify the absorbance detection wavelength of the UVVis detector for each sample:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,AbsorbanceWavelength -> 260 Nano Meter][[1]];
				Lookup[Lookup[packet,ResolvedOptions],AbsorbanceWavelength]
			),
			260 Nanometer,
			EquivalenceFunction -> Equal,
			Variables:>{packet}
		],
		Example[
			{Options,AbsorbanceWavelength,"Specify a range of absorbance detection wavelengths of the PhotoDiodeArray detector for each sample:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,AbsorbanceWavelength -> 300 Nanometer;;500 Nanometer][[1]];
				Lookup[Lookup[packet,ResolvedOptions],AbsorbanceWavelength]
			),
			300 Nanometer;;500 Nanometer,
			Variables:>{packet}
		],
		Example[
			{Options,AbsorbanceWavelength,"A PhotoDiodeArray Detector is automatically selected when AbsorbanceWavelength is set to All:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,AbsorbanceWavelength -> All][[1]];
				Lookup[packet,Replace[Detectors]]
			),
			{___,PhotoDiodeArray,___},
			Variables:>{packet}
		],
		Example[
			{Options,AbsorbanceWavelength,"Resolves the AbsorbanceWavelength based on the sample's ExtinctionCoefficients:"},
			(
				protocol = ExperimentHPLC[
					"mySample",
					Instrument -> Model[Instrument, HPLC, "UltiMate 3000"],
					PreparatoryUnitOperations->{Transfer[Source->Model[Sample, "id:BYDOjvG9z6Jl"],Destination->Model[Container, Plate, "id:L8kPEjkmLbvW"],DestinationWell->"A1",Amount->1Milliliter,DestinationLabel->"mySample"]}
             	];
				Download[protocol,AbsorbanceWavelength]
			),
			{280Nanometer},
			Variables:>{protocol},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options,WavelengthResolution,"Specify the increment in wavelengths to measure with the PDA detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->PhotoDiodeArray,WavelengthResolution->1.2*Nanometer, OutputFormat -> List];
			Lookup[options,WavelengthResolution],
			1.2*Nanometer,
			Variables:>{options}
		],
		Example[
			{Options,UVFilter,"Specify whether or not to have the UV filter on or off in order to block UV wavelengths (less than 210 nm):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->PhotoDiodeArray,UVFilter->True, OutputFormat -> List];
			Lookup[options,UVFilter],
			True,
			Variables:>{options}
		],
		Example[
			{Options,AbsorbanceSamplingRate,"Specify how frequently to conduct absorbance sampling measurements:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->UVVis,AbsorbanceSamplingRate->20*1/Second, OutputFormat -> List];
			Lookup[options,AbsorbanceSamplingRate],
			20*1/Second,
			Variables:>{options}
		],
		Example[
			{Options,ExcitationWavelength,"Specify the specific wavelength (a single tuple) that is used to excite fluorescence in the samples in the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Detector->Fluorescence,
				ExcitationWavelength->485 Nanometer,
				OutputFormat -> List
			];
			Lookup[options,ExcitationWavelength],
			(* Due to the problem with CollapseIndexMatchedOptions trying to collapse an option with both singleton pattern and Adder pattern, ExcitationWavelength option will remain {485 Nanometer} in the resolved option. *)
			(485 Nanometer)|{485 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,ExcitationWavelength,"Specify the specific wavelengths (multiple tuples) that are used to excite fluorescence in the samples in the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				ExcitationWavelength->{485 Nanometer,540 Nanometer},
				OutputFormat -> List
			];
			Lookup[options,ExcitationWavelength],
			{485 Nanometer,540 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,EmissionWavelength,"Specify the specific wavelength (a single tuple) at which fluorescence emitted from the sample is measured in the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Detector->Fluorescence,
				EmissionWavelength->520 Nanometer,
				OutputFormat -> List
			];
			Lookup[options,EmissionWavelength],
			(* Due to the problem with CollapseIndexMatchedOptions trying to collapse an option with both singleton pattern and Adder pattern, EmissionWavelength option will remain {485 Nanometer} in the resolved option. *)
			(520 Nanometer)|{520 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,EmissionWavelength,"Specify the specific wavelength (multiple tuples) at which fluorescence emitted from the sample is measured in the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				EmissionWavelength->{520 Nanometer,590 Nanometer},
				OutputFormat -> List
			];
			Lookup[options,EmissionWavelength],
			{520 Nanometer,590 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,EmissionCutOffFilter,"Specify the cut-off wavelength to pre-select the emitted light from the sample and allow only the light with wavelength above the desired value to pass, before the light enters emission monochromator for final wavelength selection:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				EmissionCutOffFilter->280Nanometer,
				OutputFormat -> List
			];
			Lookup[options,EmissionCutOffFilter],
			280Nanometer,
			Variables:>{options}
		],
		Example[
			{Options,FluorescenceGain,"Specify the signal amplification of single-channel fluorescence measurement for the sample to be used on the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Detector->Fluorescence,
				ExcitationWavelength->485 Nanometer,
				EmissionWavelength->520 Nanometer,
				FluorescenceGain->100Percent,
				OutputFormat -> List
			];
			Lookup[options,FluorescenceGain],
			(* Due to the problem with CollapseIndexMatchedOptions trying to collapse an option with both singleton pattern and Adder pattern, FluorescenceGain option will remain {5} in the resolved option. *)
			100Percent|{100Percent},
			Variables:>{options}
		],
		Example[
			{Options,FluorescenceGain,"Specify the signal amplification of multi-channel fluorescence measurement for the sample to be used on the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Instrument->Model[Instrument, HPLC, "UltiMate 3000 with FLR Detector"],
				Detector->Fluorescence,
				ExcitationWavelength->{485 Nanometer,540 Nanometer},
				EmissionWavelength->{520 Nanometer,590 Nanometer},
				FluorescenceGain->{50 Percent,20 Percent},
				OutputFormat -> List
			];
			Lookup[options,FluorescenceGain],
			{50 Percent,20 Percent},
			Variables:>{options},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options,FluorescenceFlowCellTemperature,"Specify the temperature that the thermostat inside the fluorescence flow cell of the detector is set to during the fluorescence measurement of the sample:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				FluorescenceFlowCellTemperature->45Celsius,
				OutputFormat -> List
			];
			Lookup[options,FluorescenceFlowCellTemperature],
			45Celsius,
			Variables:>{options}
		],
		Example[
			{Options,LightScatteringLaserPower,"Specify the laser power filter used in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector for the measurement of the sample:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{MultiAngleLightScattering,DynamicLightScattering},
				LightScatteringLaserPower->90Percent,
				OutputFormat -> List
			];
			Lookup[options,LightScatteringLaserPower],
			90Percent,
			Variables:>{options}
		],
		Example[
			{Options,LightScatteringFlowCellTemperature,"Specify the temperature that the thermostat inside the flow cell of the detector is set to during the Multi-Angle static Light Scattering (MALS) and/or Dynamic Light Scattering (DLS) measurement of the sample:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{MultiAngleLightScattering,DynamicLightScattering},
				LightScatteringFlowCellTemperature->30Celsius,
				OutputFormat -> List
			];
			Lookup[options,LightScatteringFlowCellTemperature],
			30Celsius,
			Variables:>{options}
		],
		Example[
			{Options,RefractiveIndexMethod,"Specify the type of refractive index measurement of the refractive index (RI) detector for the measurement of the sample:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				RefractiveIndexMethod->RefractiveIndex,
				OutputFormat -> List
			];
			Lookup[options,RefractiveIndexMethod],
			RefractiveIndex,
			Variables:>{options}
		],
		Example[
			{Options,RefractiveIndexFlowCellTemperature,"Specify the temperature that the thermostat inside the refractive index flow cell of the refractive index (RI) detector is set to during the refractive index measurement of the sample:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				RefractiveIndexFlowCellTemperature->30Celsius,
				OutputFormat -> List
			];
			Lookup[options,RefractiveIndexFlowCellTemperature],
			30Celsius,
			Variables:>{options}
		],
		(* pH/Conductivity Calibration Options and Messages *)
		Example[
			{Options,pHCalibration,"Indicates if 2-point calibration of the pH probe should be performed before the experiment starts:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{UVVis,pH,Conductance},
				pHCalibration->True,
				OutputFormat->List
			];
			Lookup[options,pHCalibration],
			True,
			Variables:>{options}
		],
		Example[
			{Options,LowpHCalibrationBuffer,"Specifies the low pH buffer that should be used to calibrate the pH probe in the 2-point calibration:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{UVVis,pH,Conductance},
				LowpHCalibrationBuffer->Model[Sample, "pH 4.01 Calibration Buffer, Sachets"],
				OutputFormat->List
			];
			Lookup[options,LowpHCalibrationBuffer],
			ObjectP[Model[Sample, "pH 4.01 Calibration Buffer, Sachets"]],
			Variables:>{options}
		],
		Example[
			{Options,LowpHCalibrationTarget,"Specifies the pH of the LowpHCalibrationBuffer that should be used to calibrate the pH probe in the 2-point calibration:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{UVVis,pH,Conductance},
				LowpHCalibrationTarget->4,
				OutputFormat->List
			];
			Lookup[options,LowpHCalibrationTarget],
			4,
			Variables:>{options},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,HighpHCalibrationBuffer,"Specifies the high pH buffer that should be used to calibrate the pH probe in the 2-point calibration:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{UVVis,pH,Conductance},
				HighpHCalibrationBuffer->Model[Sample, "Reference buffer, pH 7"],
				OutputFormat->List
			];
			Lookup[options,HighpHCalibrationBuffer],
			ObjectP[Model[Sample, "Reference buffer, pH 7"]],
			Variables:>{options}
		],
		Example[
			{Options,HighpHCalibrationTarget,"Specifies the pH of the HighpHCalibrationBuffer that should be used to calibrate the pH probe in the 2-point calibration:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{UVVis,pH,Conductance},
				HighpHCalibrationTarget->7,
				OutputFormat->List
			];
			Lookup[options,HighpHCalibrationTarget],
			7,
			Variables:>{options},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,pHTemperatureCompensation,"Indicates if the measured pH value should be automatically corrected according to the temperature inside the pH flow cell:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{UVVis,pH,Conductance},
				pHTemperatureCompensation->True,
				OutputFormat->List
			];
			Lookup[options,pHTemperatureCompensation],
			True,
			Variables:>{options}
		],
		Example[
			{Options,ConductivityCalibration,"Indicates if 1-point calibration of the conductivity probe should be performed before the experiment starts:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{UVVis,pH,Conductance},
				ConductivityCalibration->True,
				OutputFormat->List
			];
			Lookup[options,ConductivityCalibration],
			True,
			Variables:>{options}
		],
		Example[
			{Options,ConductivityCalibrationBuffer,"Specifies the buffer that should be used to calibrate the conductivity probe in the 1-point calibration:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{UVVis,pH,Conductance},
				ConductivityCalibrationBuffer->Model[Sample, "id:eGakldJ6WqD4"],
				OutputFormat->List
			];
			Lookup[options,ConductivityCalibrationBuffer],
			ObjectP[Model[Sample, "id:eGakldJ6WqD4"]],
			Variables:>{options}
		],
		Example[
			{Options,ConductivityCalibrationTarget,"Specifies the conductivity value of the ConductivityCalibrationBuffer that should be used to calibrate the conductivity probe in the 1-point calibration:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{UVVis,pH,Conductance},
				ConductivityCalibrationTarget->1413Micro*Siemens/Centimeter,
				OutputFormat->List
			];
			Lookup[options,ConductivityCalibrationTarget],
			1413Micro*Siemens/Centimeter,
			Variables:>{options},
			EquivalenceFunction->Equal
		],
		Example[
			{Options,ConductivityTemperatureCompensation,"Indicates if the measured conductivity value should be automatically corrected according to the temperature inside the conductivity flow cell:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{UVVis,pH,Conductance},
				ConductivityTemperatureCompensation->True,
				OutputFormat->List
			];
			Lookup[options,ConductivityTemperatureCompensation],
			True,
			Variables:>{options}
		],
		Example[
			{Options,NebulizerGas,"Specify whether to turn on or off the sheath gas for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->EvaporativeLightScattering,NebulizerGas->False, OutputFormat -> List];
			Lookup[options,NebulizerGas],
			False,
			Variables:>{options}
		],
		Example[
			{Options,NebulizerGasHeating,"Specify whether to turn on or off the heating element for the sheath gas for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->EvaporativeLightScattering,NebulizerGasHeating->False, OutputFormat -> List];
			Lookup[options,NebulizerGasHeating],
			False,
			Variables:>{options}
		],
		Example[
			{Options,NebulizerHeatingPower,"Specify the magnitude of the heating element for the sheath gas for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->EvaporativeLightScattering,NebulizerHeatingPower->30*Percent, OutputFormat -> List];
			Lookup[options,NebulizerHeatingPower],
			30*Percent,
			Variables:>{options}
		],
		Example[
			{Options,NebulizerGasPressure,"Specify the flow rate of the sheath gas by controlling the applied pressure for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->EvaporativeLightScattering,NebulizerGasPressure->30*PSI, OutputFormat -> List];
			Lookup[options,NebulizerGasPressure],
			30*PSI,
			Variables:>{options}
		],
		Example[
			{Options,DriftTubeTemperature,"Specify the temperature of the spray chamber for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->EvaporativeLightScattering,DriftTubeTemperature->70*Celsius, OutputFormat -> List];
			Lookup[options,DriftTubeTemperature],
			70*Celsius,
			Variables:>{options}
		],
		Example[
			{Options,ELSDGain,"Specify the signal amplification of the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->EvaporativeLightScattering,ELSDGain->50 Percent, OutputFormat -> List];
			Lookup[options,ELSDGain],
			50 Percent,
			Variables:>{options}
		],
		Example[
			{Options,ELSDSamplingRate,"Specify the temporal resolution of the measurement of the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},Detector->EvaporativeLightScattering,ELSDSamplingRate->20*1/Second, OutputFormat -> List];
			Lookup[options,ELSDSamplingRate],
			20*1/Second,
			Variables:>{options}
		],

		(* === Options - Fraction Collection === *)
		Example[
			{Options,CollectFractions,"Specify if collection of fractions is desired for each sample:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					CollectFractions->{True, False, True}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					CollectFractions
				]
			),
			{True,False,True},
			Variables:>{packet}
		],
		Example[
			{Options,FractionCollectionDetector,"Specify the type of desired measurement that is used as signal to trigger fraction collection:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{UVVis,Fluorescence},
				CollectFractions->True,
				FractionCollectionDetector->UVVis,
				OutputFormat->List
			];
			Lookup[options,FractionCollectionDetector],
			UVVis,
			Variables:>{options}
		],
		Example[
			{Options,FractionCollectionMethod,"Specify an existing Object[Method, FractionCollection] which describes the conditions for which a fraction is collected:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					FractionCollectionMethod -> Object[Method, FractionCollection, "id:WNa4ZjRDxam8"]
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					FractionCollectionMethod
				]
			),
			ObjectP[Object[Method,FractionCollection]],
			Variables:>{packet}
		],
		Example[
			{Options,FractionCollectionStartTime,"Specify the time at which to start collection fractions:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					FractionCollectionStartTime -> 10 Minute
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					FractionCollectionStartTime
				]
			),
			10 Minute,
			Variables:>{packet}
		],
		Example[
			{Options,FractionCollectionEndTime,"Specify the time at which to end collection fractions:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					FractionCollectionEndTime -> 30 Minute
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					FractionCollectionEndTime
				]
			),
			30 Minute,
			Variables:>{packet}
		],
		Example[
			{Options,FractionCollectionMode,"Specify the method by which fractions collection should be triggered:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					FractionCollectionMode -> Peak
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					FractionCollectionMode
				]
			),
			Peak,
			Variables:>{packet}
		],
		Example[
			{Options,MaxFractionVolume,"Specify the maximum volume of each fraction collected:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					MaxFractionVolume -> 100 Micro Liter
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					MaxFractionVolume
				]
			),
			100 Microliter,
			Variables:>{packet}
		],
		Example[
			{Options,MaxCollectionPeriod,"Specify the maximum duration of each fraction collected:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					MaxCollectionPeriod -> 15*Second
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					MaxCollectionPeriod
				]
			),
			15*Second,
			Variables:>{packet}
		],
		Example[
			{Options,AbsoluteThreshold,"The signal threshold must exceed this value for a peak start to be detected:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					AbsoluteThreshold -> 1000 Milli AbsorbanceUnit
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					AbsoluteThreshold
				]
			),
			1000 Milli AbsorbanceUnit,
			Variables:>{packet}
		],
		Example[
			{Options,AbsoluteThreshold,"AbsoluteThreshold can be set to different units depending on the type of FractionCollectionDetector used in the experiment:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					FractionCollectionDetector->Fluorescence,
					Upload->False,
					AbsoluteThreshold -> 5 Milli RFU
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					AbsoluteThreshold
				]
			),
			5 Milli RFU,
			Variables:>{packet}
		],
		Example[
			{Options,AbsoluteThreshold,"AbsoluteThreshold can be set to different units depending on the type of FractionCollectionDetector used in the experiment:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					FractionCollectionDetector->Conductance,
					Upload->False,
					AbsoluteThreshold -> 100 Milli Siemens/Centimeter
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					AbsoluteThreshold
				]
			),
			100 Milli Siemens/Centimeter,
			Variables:>{packet}
		],
		Example[
			{Options,PeakSlope,"The slope must exceed this value for a peak start to be detected:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					PeakSlope -> 10 Milli AbsorbanceUnit/Second
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					PeakSlope
				]
			),
			10 Milli AbsorbanceUnit/Second,
			Variables:>{packet}
		],
		Example[
			{Options,PeakSlopeDuration,"Specify the minimum duration that changes in slopes must be maintained before they are registered:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					PeakSlopeDuration -> 1 Second
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					PeakSlopeDuration
				]
			),
			Second,
			Variables:>{packet}
		],
		Example[
			{Options,PeakEndThreshold,"The signal value must be below this value for a peak end to be detected:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					PeakEndThreshold -> 100 Milli AbsorbanceUnit
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					PeakEndThreshold
				]
			),
			100 Milli AbsorbanceUnit,
			Variables:>{packet}
		],
		Example[
			{Options,FractionCollectionContainer,"Resolve FractionCollectionContainer based on Site and Scale and Instrument (1):"},
			options = ExperimentHPLC[
				{
					Object[Sample, "Test Sample CMU-1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample, "Test Sample CMU-2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample, "Test Sample CMU-3 for ExperimentHPLC tests" <> $SessionUUID]
				},
				Scale -> SemiPreparative,
				Output->Options
			];
			Lookup[options, {Instrument,FractionCollectionContainer}],
			{
				(*
					{
						"Agilent 1260 Infinity II Semi-Preparative HPLC with UV/Vis Diode Array Detector",
						"Agilent 1260 Infinity II Semi-Preparative HPLC with MALS-DLS-RI Detector",
						"Agilent 1260 Infinity II Semi-Preparative HPLC with UV/Vis Diode Array and Fluorescence Detectors"
					}
				*)
				{
					Model[Instrument, HPLC, "id:dORYzZRWJlDD"],
					Model[Instrument, HPLC, "id:dORYzZRWmDn5"],
					Model[Instrument, HPLC, "id:lYq9jRqD8OpV"]
				},
				(* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
				ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]
			},
			Variables:>{options}
		],
		Example[
			{Options,FractionCollectionContainer,"Resolve FractionCollectionContainer based on Site and Scale and Instrument (2):"},
			options = ExperimentHPLC[
				{
					Object[Sample, "Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample, "Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample, "Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]
				},
				Scale -> SemiPreparative,
				Output->Options
			];
			Lookup[options, {Instrument,FractionCollectionContainer}],
			{
				(*
					{"UltiMate 3000", "UltiMate 3000 with MALS-DLS-RI Detector", "UltiMate 3000 with FLR Detector"}
				*)
				{
					Model[Instrument, HPLC, "id:N80DNjlYwwJq"],
					Model[Instrument, HPLC, "id:M8n3rx098xbO"],
					Model[Instrument, HPLC, "id:wqW9BP7BzwAG"]
				},
				(* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
				ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]
			},
			Variables:>{options}
		],
		Example[
			{Options,FractionCollectionContainer,"Resolve FractionCollectionContainer based on Site and Scale and Instrument (3):"},
			options = ExperimentHPLC[
				{Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID]},
				Scale -> Preparative,
				Output -> Options
			];
			Lookup[options, {Instrument,FractionCollectionContainer}],
			{
				(* "Agilent 1290 Infinity II LC System" *)
				{Model[Instrument, HPLC, "id:R8e1Pjp1md8p"]},
				(* Model[Container, Vessel, "50mL Tube"] *)
				ObjectP[Model[Container, Vessel, "id:bq9LA0dBGGR6"]]
			},
			Variables:>{options}
		],
		Example[
			{Options,FractionCollectionContainer,"Specify the container in which the fractions are collected on the selected instrument's fraction collector:"},
			options = ExperimentHPLC[
				{Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID]},
				FractionCollectionContainer->Model[Container, Vessel, "15mL Tube"],
				Scale -> Preparative,
				Output->Options
			];
			Lookup[options,FractionCollectionContainer],
			ObjectP[Model[Container, Vessel, "15mL Tube"]],
			Variables:>{options}
		],
		Example[
			{Options,FractionCollectionContainer,"Specify the light-sensitive container in which the fractions are collected on the selected instrument's fraction collector:"},
			protocol = ExperimentHPLC[
				{Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID]},
				FractionCollectionContainer->Model[Container, Vessel, "50mL Light Sensitive Centrifuge Tube"],
				Scale -> Preparative
			];
			Download[protocol,FractionContainers],
			{LinkP[Model[Container, Vessel, "id:bq9LA0dBGGrd"]]..},
			Variables:>{protocol}
		],
		Example[
			{Options,FractionCollectionContainer,"Specify the light-sensitive small container in which the fractions are collected on the selected instrument's fraction collector:"},
			protocol = ExperimentHPLC[
				{Object[Sample,"Test Sample 8 for ExperimentHPLC tests (15mL Tube)" <> $SessionUUID],Object[Sample,"Test Sample 9 for ExperimentHPLC tests (15mL Tube)" <> $SessionUUID]},
				FractionCollectionContainer->Model[Container, Vessel, "15mL Light Sensitive Centrifuge Tube"],
				Scale -> Preparative
			];
			Download[protocol,FractionContainers],
			{LinkP[Model[Container, Vessel, "id:rea9jl1orrMp"]]..},
			Variables:>{protocol}
		],

		(* === Options - STANDARD === *)
		Example[
			{Options,Standard,"Specify the sample to use as a standard:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					Standard -> Model[Sample,StockSolution,Standard,"Small Molecule HPLC Standard Mix"]
				][[1]];
				Lookup[packet,Replace[Standards]]
			),
			{LinkP[Model[Sample,StockSolution,Standard,"Small Molecule HPLC Standard Mix"]]..},
			Variables:>{packet}
		],
		Example[
			{Options,Standard,"Specify multiple standards:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					Standard -> {
						Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
						Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]
					}
				][[1]];
				Lookup[packet,Replace[Standards]]
			),
			{LinkP[Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]]..},
			Variables:>{packet}
		],
		Example[
			{Options,StandardInjectionVolume,"Specify the volume of standard to inject:"},
			options = ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				StandardInjectionVolume -> 15 Microliter,
				Upload->False,
				Output->Options
			];
			Lookup[options,StandardInjectionVolume],
			15 Microliter,
			Variables:>{options}
		],
		Example[
			{Options,StandardFrequency,"Specify the frequency at which standards are run:"},
			(
				packets = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					StandardFrequency->2,
					BlankFrequency->FirstAndLast,
					Upload->False
				];
				Lookup[Lookup[First@packets, Replace[InjectionTable]],Type]
			),
			{ColumnPrime, Blank, Standard, Sample, Sample, Standard, Sample, Blank, ColumnFlush},
			Variables:>{packets}
		],
		Example[
			{Options,StandardFrequency,"StandardFrequency -> First will only run a standard first:"},
			(
				packets = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					StandardFrequency->First,
					BlankFrequency->FirstAndLast,
					Upload->False
				];
				Lookup[Lookup[First@packets, Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Blank, Standard, Sample, Sample, Sample, Blank, ColumnFlush},
			Variables:>{packets}
		],
		Example[
			{Options,StandardFrequency,"StandardFrequency -> Last will only run a standard last:"},
			(
				packets = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					StandardFrequency->Last,
					BlankFrequency->FirstAndLast,
					Upload->False
				];
				Lookup[Lookup[First@packets, Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Blank, Sample, Sample, Sample, Blank, Standard, ColumnFlush},
			Variables:>{packets}
		],
		Example[
			{Options,StandardFrequency,"StandardFrequency -> FirstAndLast will run a standard first and last:"},
			(
				packets = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					StandardFrequency->FirstAndLast,
					BlankFrequency->FirstAndLast,
					Upload->False
				];
				Lookup[Lookup[First@packets, Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Blank, Standard, Sample, Sample, Sample, Blank, Standard, ColumnFlush},
			Variables:>{packets}
		],
		Example[
			{Options,StandardFrequency,"StandardFrequency -> None will run no standards:"},
			(
				packets = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					StandardFrequency->None,
					BlankFrequency->FirstAndLast,
					Upload->False
				];
				Lookup[Lookup[First@packets, Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Blank, Sample, Sample, Sample, Blank, ColumnFlush},
			Variables:>{packets}
		],
		Example[
			{Options,StandardColumnPosition,"Specify the column selector for the injection of each standard:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID]},
					Upload->False,
					Standard -> {
						Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
						Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]
					},
					StandardColumnPosition -> {PositionB, PositionA}
				][[1]];
				Lookup[Cases[Lookup[packet,Replace[InjectionTable]],KeyValuePattern[Type->Standard]],{Sample,ColumnPosition}]
			),
			(* Standard by default is FirstAndLast *)
			{
				{LinkP[Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]],PositionB},
				{LinkP[Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]],PositionA},
				{LinkP[Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]],PositionB},
				{LinkP[Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]],PositionA}
			},
			Variables:>{packet}
		],
		Example[
			{Options,StandardColumnTemperature,"Specify the column temperature to run standard sample at:"},
			(
				options = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Standard -> Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
					StandardColumnTemperature -> 50.1 Celsius,
					Upload -> False,
					Output -> Options
				];
				injectionTable = Lookup[options, InjectionTable];
				{
					Lookup[options, StandardColumnTemperature],
					Cases[injectionTable,{Standard,___}][[All,5]]
				}
			),
			{50.1 Celsius,{(50.1 Celsius)..}},
			Variables:>{options,injectionTable}
		],
		Example[
			{Options,StandardGradientA,"Specify the buffer A gradient for each standard:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					StandardFrequency -> FirstAndLast,
					StandardGradientA -> {{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					StandardGradientA
				]
			),
			{{0 Minute, 10. Percent},{5 Minute,10. Percent},{50 Minute,100. Percent},{50.1 Minute,0. Percent},{55 Minute,0. Percent}},
			EquivalenceFunction -> Equal,
			Variables:>{packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options,StandardGradientB,"Specify the buffer B gradient for each standard:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					StandardFrequency -> FirstAndLast,
					StandardGradientB -> {{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					StandardGradientB
				]
			),
			{{0 Minute, 10. Percent},{5 Minute,10. Percent},{50 Minute,100. Percent},{50.1 Minute,0. Percent},{55 Minute,0. Percent}},
			EquivalenceFunction -> Equal,
			Variables:>{packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options,StandardGradientC,"Specify the buffer C gradient for each standard:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					StandardFrequency -> FirstAndLast,
					StandardGradientC -> {{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					StandardGradientC
				]
			),
			{{0 Minute, 10. Percent},{5 Minute,10. Percent},{50 Minute,100. Percent},{50.1 Minute,0. Percent},{55 Minute,0. Percent}},
			EquivalenceFunction -> Equal,
			Variables:>{packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options,StandardGradientD,"Specify the buffer D gradient for each standard:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					StandardFrequency -> FirstAndLast,
					StandardGradientD -> {{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					StandardGradientD
				]
			),
			{{0 Minute, 10. Percent},{5 Minute,10. Percent},{50 Minute,100. Percent},{50.1 Minute,0. Percent},{55 Minute,0. Percent}},
			EquivalenceFunction -> Equal,
			Variables:>{packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options,StandardFlowRate,"Specify the flow rate for each standard:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					StandardFrequency -> FirstAndLast,
					StandardFlowRate -> 1 Milliliter/Minute
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					StandardFlowRate
				]
			),
			1 Milliliter/Minute,
			EquivalenceFunction -> Equal,
			Variables:>{packet}
		],
		Example[
			{Options,StandardGradient,"Specify the gradient method to use for the standards:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					StandardGradient -> Object[Method, Gradient, "id:M8n3rxYAonm5"],
					Standard -> Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]
				][[1]];
				Lookup[packet,{Replace[Standards],Replace[StandardGradients]}]
			),
			{{LinkP[Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]]..},{LinkP[Object[Method, Gradient, "id:M8n3rxYAonm5"]]..}},
			Variables:>{packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],

		(* === Options - Standard Detector Parameters === *)
		Example[
			{Options,StandardAbsorbanceWavelength,"Specify the absorbance detection wavelength of the UVVis detector for each standard sample:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Standard -> Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],Upload->False,StandardAbsorbanceWavelength -> 480 Nano Meter][[1]];
				Lookup[Lookup[packet,	ResolvedOptions],StandardAbsorbanceWavelength]
			),
			480 Nanometer,
			Variables:>{packet},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options,StandardAbsorbanceWavelength,"Specify a range of absorbance detection wavelengths of the PhotoDiodeArray detector for each standard sample:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,StandardAbsorbanceWavelength -> 300 Nanometer;;500 Nanometer][[1]];
				Lookup[Lookup[packet,ResolvedOptions],StandardAbsorbanceWavelength]
			),
			300 Nanometer;;500 Nanometer,
			Variables:>{packet}
		],
		Example[
			{Options,StandardWavelengthResolution,"For Standard samples, specify the increment in wavelengths to measure with the PhotoDiodeArray detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Standard -> Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],StandardWavelengthResolution->1.2*Nanometer, OutputFormat -> List];
			Lookup[options,StandardWavelengthResolution],
			1.2*Nanometer,
			Variables:>{options}
		],
		Example[
			{Options,StandardUVFilter,"For Standard samples, specify whether or not to have the UV filter on or off in order to block UV wavelengths (less than 210 nm):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Standard -> Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],StandardUVFilter->False, OutputFormat -> List];
			Lookup[options,StandardUVFilter],
			False,
			Variables:>{options}
		],
		Example[
			{Options,StandardAbsorbanceSamplingRate,"For Standard samples, specify how frequently the absorbance measurements should be conducted:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Standard -> Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],StandardAbsorbanceSamplingRate->20*1/Second, OutputFormat -> List];
			Lookup[options,StandardAbsorbanceSamplingRate],
			20*1/Second,
			Variables:>{options}
		],
		Example[
			{Options,StandardExcitationWavelength,"Specify the specific wavelength (a single tuple) that is used to excite fluorescence in the standard samples in the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				Standard->Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
				StandardExcitationWavelength->485 Nanometer,
				OutputFormat -> List
			];
			Lookup[options,StandardExcitationWavelength],
			(* Due to the problem with CollapseIndexMatchedOptions trying to collapse an option with both singleton pattern and Adder pattern, ExcitationWavelength option will remain {485 Nanometer} in the resolved option. *)
			(485 Nanometer)|{485 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,StandardExcitationWavelength,"Specify the specific wavelengths (multiple tuples) that are used to excite fluorescence in the standard samples in the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				Standard->Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
				StandardExcitationWavelength->{485 Nanometer,540 Nanometer},
				OutputFormat -> List
			];
			Lookup[options,StandardExcitationWavelength],
			{485 Nanometer,540 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,StandardEmissionWavelength,"Specify the specific wavelength (a single tuple) at which fluorescence emitted from the standard sample is measured in the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				Standard->Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
				StandardEmissionWavelength->520 Nanometer,
				OutputFormat -> List
			];
			Lookup[options,StandardEmissionWavelength],
			(* Due to the problem with CollapseIndexMatchedOptions trying to collapse an option with both singleton pattern and Adder pattern, EmissionWavelength option will remain {485 Nanometer} in the resolved option. *)
			(520 Nanometer)|{520 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,StandardEmissionWavelength,"Specify the specific wavelength (multiple tuples) at which fluorescence emitted from the standard sample is measured in the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				Standard->Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
				StandardEmissionWavelength->{520 Nanometer,590 Nanometer},
				OutputFormat -> List
			];
			Lookup[options,StandardEmissionWavelength],
			{520 Nanometer,590 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,StandardEmissionCutOffFilter,"Specify the cut-off wavelength to pre-select the emitted light from the standard sample and allow only the light with wavelength above the desired value to pass, before the light enters emission monochromator for final wavelength selection:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				Standard->Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
				StandardEmissionCutOffFilter->280Nanometer,
				OutputFormat -> List
			];
			Lookup[options,StandardEmissionCutOffFilter],
			280Nanometer,
			Variables:>{options}
		],
		Example[
			{Options,StandardFluorescenceGain,"Specify the signal amplification of single-channel fluorescence measurement for the standard sample to be used on the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				Standard->Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
				StandardExcitationWavelength->485 Nanometer,
				StandardEmissionWavelength->520 Nanometer,
				StandardFluorescenceGain->100 Percent,
				OutputFormat -> List
			];
			Lookup[options,StandardFluorescenceGain],
			(* Due to the problem with CollapseIndexMatchedOptions trying to collapse an option with both singleton pattern and Adder pattern, FluorescenceGain option will remain {5} in the resolved option. *)
			100 Percent|{100 Percent},
			Variables:>{options}
		],
		Example[
			{Options,StandardFluorescenceGain,"Specify the signal amplification of multi-channel fluorescence measurement for the standard sample to be used on the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Instrument->Model[Instrument, HPLC, "UltiMate 3000 with FLR Detector"],
				Detector->Fluorescence,
				Standard->Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
				StandardExcitationWavelength->{485 Nanometer,540 Nanometer},
				StandardEmissionWavelength->{520 Nanometer,590 Nanometer},
				StandardFluorescenceGain->{50 Percent,20 Percent},
				OutputFormat -> List
			];
			Lookup[options,StandardFluorescenceGain],
			{50 Percent,20 Percent},
			Variables:>{options}
		],
		Example[
			{Options,StandardFluorescenceFlowCellTemperature,"Specify the temperature that the thermostat inside the fluorescence flow cell of the detector is set to during the fluorescence measurement of the standard sample:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				Standard->Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
				StandardFluorescenceFlowCellTemperature->45Celsius,
				OutputFormat -> List
			];
			Lookup[options,StandardFluorescenceFlowCellTemperature],
			45Celsius,
			Variables:>{options}
		],
		Example[
			{Options,StandardLightScatteringLaserPower,"Specify the laser power filter used in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector for the measurement of the standard sample:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{MultiAngleLightScattering,DynamicLightScattering},
				Standard->Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
				StandardLightScatteringLaserPower->90Percent,
				OutputFormat -> List
			];
			Lookup[options,StandardLightScatteringLaserPower],
			90Percent,
			Variables:>{options}
		],
		Example[
			{Options,StandardLightScatteringFlowCellTemperature,"Specify the temperature that the thermostat inside the flow cell of the detector is set to during the Multi-Angle static Light Scattering (MALS) and/or Dynamic Light Scattering (DLS) measurement of the standard sample:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{MultiAngleLightScattering,DynamicLightScattering},
				Standard->Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
				StandardLightScatteringFlowCellTemperature->30Celsius,
				OutputFormat -> List
			];
			Lookup[options,StandardLightScatteringFlowCellTemperature],
			30Celsius,
			Variables:>{options}
		],
		Example[
			{Options,StandardRefractiveIndexMethod,"Specify the type of refractive index measurement of the refractive index (RI) detector for the measurement of the standard sample:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Standard->Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
				StandardRefractiveIndexMethod->RefractiveIndex,
				OutputFormat -> List
			];
			Lookup[options,StandardRefractiveIndexMethod],
			RefractiveIndex,
			Variables:>{options}
		],
		Example[
			{Options,StandardRefractiveIndexFlowCellTemperature,"Specify the temperature that the thermostat inside the refractive index flow cell of the refractive index (RI) detector is set to during the refractive index measurement of the standard sample:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Standard->Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
				StandardRefractiveIndexFlowCellTemperature->30Celsius,
				OutputFormat -> List
			];
			Lookup[options,StandardRefractiveIndexFlowCellTemperature],
			30Celsius,
			Variables:>{options}
		],
		Example[
			{Options,StandardNebulizerGas,"For Standard samples, specify whether to turn on or off the sheath gas for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Standard -> Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],StandardNebulizerGas->False, OutputFormat -> List];
			Lookup[options,StandardNebulizerGas],
			False,
			Variables:>{options}
		],
		Example[
			{Options,StandardNebulizerGasHeating,"For Standard samples, specify whether to turn on or off the heating element for the sheath gas for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Standard -> Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],StandardNebulizerGasHeating->False, OutputFormat -> List];
			Lookup[options,StandardNebulizerGasHeating],
			False,
			Variables:>{options}
		],
		Example[
			{Options,StandardNebulizerHeatingPower,"For Standard samples, specify the magnitude of the heating element for the sheath gas for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Standard -> Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],StandardNebulizerHeatingPower->30*Percent, OutputFormat -> List];
			Lookup[options,StandardNebulizerHeatingPower],
			30*Percent,
			Variables:>{options}
		],
		Example[
			{Options,StandardNebulizerGasPressure,"For Standard samples, specify the flow rate of the sheath gas by controlling the applied pressure for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Standard -> Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],StandardNebulizerGasPressure->30*PSI, OutputFormat -> List];
			Lookup[options,StandardNebulizerGasPressure],
			30*PSI,
			Variables:>{options}
		],
		Example[
			{Options,StandardDriftTubeTemperature,"For Standard samples, specify the temperature of the spray chamber for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Standard -> Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],StandardDriftTubeTemperature->70*Celsius, OutputFormat -> List];
			Lookup[options,StandardDriftTubeTemperature],
			70*Celsius,
			Variables:>{options}
		],
		Example[
			{Options,StandardELSDGain,"For Standard samples, specify the signal amplification of the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Standard -> Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],StandardELSDGain->50 Percent, OutputFormat -> List];
			Lookup[options,StandardELSDGain],
			50 Percent,
			Variables:>{options}
		],
		Example[
			{Options,StandardELSDSamplingRate,"For Standard samples, specify the temporal resolution of the measurement of the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Standard -> Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],StandardELSDSamplingRate->20*1/Second, OutputFormat -> List];
			Lookup[options,StandardELSDSamplingRate],
			20*1/Second,
			Variables:>{options}
		],
		Example[
			{Options,StandardStorageCondition,"Specify the storage condition in which the standards should be stored after the protocol completes:"},
			(
				protocol = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Standard -> {
						Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
						Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"]
					},
					StandardStorageCondition -> Refrigerator
				];
				Download[protocol,StandardsStorageConditions]
			),
			{Refrigerator..},
			Variables:>{protocol}
		],
		Example[
			{Options,StandardStorageCondition,"If two different storage conditions are specified for standard samples in the same container, throw an error:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID]},
				Standard -> {Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				StandardStorageCondition -> {Refrigerator, Freezer}
			],
			$Failed,
			Messages :> {Error::SharedContainerStorageCondition, Error::InvalidOption}
		],

		(* === Options - BLANK === *)
		Example[
			{Options,Blank,"Specify a blank to run:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
					BlankFrequency -> First,
					Upload -> False
				][[1]];
				Lookup[packet,{Replace[Blanks],Replace[BlankSampleVolumes],Replace[BlankGradients]}]
			),
			{
				{LinkP[Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"]]},
				{VolumeP},
				{ObjectP[]}
			},
			Variables:>{packet}
		],
		Example[
			{Options,Blank,"If any blank option is specified but Blank is not, Blank resolves to BufferA:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					BufferA -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
					BlankInjectionVolume -> 10 Microliter,
					BlankFrequency -> First,
					Upload -> False
				][[1]];
				Lookup[packet,{Replace[Blanks],Replace[BlankSampleVolumes],Replace[BlankGradients]}]
			),
			{
				{LinkP[Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"]]},
				{10 Microliter},
				{ObjectP[]}
			},
			Variables:>{packet}
		],
		Example[
			{Options,Blank,"Multiple blanks can be specified to run:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Blank -> {
						Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
						Model[Sample, StockSolution, "Reverse phase buffer B 0.05% HFBA"]
					},
					BlankFrequency -> First,
					Upload -> False
				][[1]];
				Lookup[packet,{Replace[Blanks],Replace[BlankSampleVolumes],Replace[BlankGradients]}]
			),
			{
				{
					LinkP[Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"]],
					LinkP[Model[Sample, StockSolution, "Reverse phase buffer B 0.05% HFBA"]]
				},
				{VolumeP,VolumeP},
				{ObjectP[],ObjectP[]}
			},
			Variables:>{packet}
		],
		Example[
			{Options,Blank,"Blank options will expand to match length of the Blank option value:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Blank -> {
						Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
						Model[Sample, StockSolution, "Reverse phase buffer B 0.05% HFBA"]
					},
					BlankInjectionVolume -> 25 Microliter,
					BlankFrequency -> First,
					Upload -> False
				][[1]];
				Lookup[packet,{Replace[Blanks],Replace[BlankSampleVolumes],Replace[BlankGradients]}]
			),
			{
				{
					LinkP[Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"]],
					LinkP[Model[Sample, StockSolution, "Reverse phase buffer B 0.05% HFBA"]]
				},
				{25 Microliter,25 Microliter},
				{ObjectP[],ObjectP[]}
			},
			Variables:>{packet}
		],
		Example[
			{Options,BlankInjectionVolume,"Specify the volume of each blank to inject:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
					BlankInjectionVolume -> 10 Microliter,
					BlankFrequency -> First,
					Upload -> False
				][[1]];
				Lookup[packet,{Replace[Blanks],Replace[BlankSampleVolumes],Replace[BlankGradients]}]
			),
			{
				{LinkP[Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"]]},
				{10 Microliter},
				{ObjectP[]}
			},
			Variables:>{packet}
		],
		Example[
			{Options,BlankFrequency,"Specify the frequency at which blanks are run:"},
			(
				packets = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					BlankFrequency->2,
					StandardFrequency->FirstAndLast,
					Upload->False
				];
				Lookup[Lookup[First[packets], Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Blank, Standard, Sample, Sample, Blank, Sample, Standard, ColumnFlush},
			Variables:>{packets}
		],
		Example[
			{Options,BlankFrequency,"BlankFrequency -> GradientChange will run a blank first, last, and before any unique gradient:"},
			(
				packets = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					BlankFrequency->GradientChange,
					StandardFrequency->FirstAndLast,
					GradientB->{10 Percent, 20 Percent, 30 Percent},
					Upload->False
				];
				Lookup[Lookup[First[packets], Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Blank, Standard, Sample, ColumnPrime, Blank, Sample,
				ColumnPrime, Blank, Sample, Blank, Standard, ColumnFlush},
			Variables:>{packets},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options,BlankFrequency,"BlankFrequency -> First will only run a blank first:"},
			(
				packets = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					BlankFrequency->First,
					StandardFrequency->FirstAndLast,
					Upload->False
				];
				Lookup[Lookup[First[packets], Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Blank, Standard, Sample, Sample, Sample, Standard, ColumnFlush},
			Variables:>{packets}
		],
		Example[
			{Options,BlankFrequency,"BlankFrequency -> Last will only run a blank last:"},
			(
				packets = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					BlankFrequency->Last,
					StandardFrequency->FirstAndLast,
					Upload->False
				];
				Lookup[Lookup[First[packets], Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Standard, Sample, Sample, Sample, Blank, Standard, ColumnFlush},
			Variables:>{packets}
		],
		Example[
			{Options,BlankFrequency,"BlankFrequency -> FirstAndLast will run a blank first and last:"},
			(
				packets = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					BlankFrequency->FirstAndLast,
					StandardFrequency->FirstAndLast,
					Upload->False
				];
				Lookup[Lookup[First[packets], Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Blank, Standard, Sample, Sample, Sample, Blank,	Standard, ColumnFlush},
			Variables:>{packets}
		],
		Example[
			{Options,BlankFrequency,"BlankFrequency -> None will run no blanks:"},
			(
				packets = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					BlankFrequency->None,
					StandardFrequency->FirstAndLast,
					Upload->False
				];
				Lookup[Lookup[First[packets], Replace[InjectionTable]], Type]
			),
			{ColumnPrime, Standard, Sample, Sample, Sample,	Standard, ColumnFlush},
			Variables:>{options}
		],
		Example[
			{Options,BlankColumnPosition,"Specify the column selector for the injection of each blank:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID]},
					Upload->False,
					Blank -> {
						Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
						Model[Sample, StockSolution, "Reverse phase buffer B 0.05% HFBA"]
					},
					BlankColumnPosition -> {PositionB, PositionA}
				][[1]];
				Lookup[Cases[Lookup[packet,Replace[InjectionTable]],KeyValuePattern[Type->Blank]],{Sample,ColumnPosition}]
			),
			{
				{LinkP[Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"]],PositionB},
				{LinkP[Model[Sample, StockSolution, "Reverse phase buffer B 0.05% HFBA"]],PositionA},
				{LinkP[Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"]],PositionB},
				{LinkP[Model[Sample, StockSolution, "Reverse phase buffer B 0.05% HFBA"]],PositionA}
			},
			Variables:>{packet}
		],
		Example[
			{Options,BlankColumnTemperature,"Specify the column temperature to run blank samples at:"},
			(
				options = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Blank -> Model[Sample,"Milli-Q water"],
					BlankColumnTemperature -> 44.4 Celsius,
					Upload -> False,
					Output -> Options
				];
				injectionTable = Lookup[options, InjectionTable];
				{
					Lookup[options, BlankColumnTemperature],
					Cases[injectionTable,{Blank,___}][[All,5]]
				}
			),
			{44.4 Celsius,{(44.4 Celsius)..}},
			Variables:>{options}
		],
		Example[
			{Options,BlankGradientA,"Specify the buffer A gradient for each blank sample:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					BlankFrequency -> FirstAndLast,
					BlankGradientA -> {{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					BlankGradientA
				]
			),
			{{0 Minute, 10. Percent},{5 Minute,10. Percent},{50 Minute,100. Percent},{50.1 Minute,0. Percent},{55 Minute,0. Percent}},
			EquivalenceFunction -> Equal,
			Variables:>{packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options,BlankGradientB,"Specify the buffer B gradient for each blank:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					BlankFrequency -> FirstAndLast,
					BlankGradientB -> {{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					BlankGradientB
				]
			),
			{{0 Minute, 10. Percent},{5 Minute,10. Percent},{50 Minute,100. Percent},{50.1 Minute,0. Percent},{55 Minute,0. Percent}},
			EquivalenceFunction -> Equal,
			Variables:>{packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options,BlankGradientC,"Specify the buffer C gradient for each blank:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					BlankFrequency -> FirstAndLast,
					BlankGradientC -> {{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					BlankGradientC
				]
			),
			{{0 Minute, 10. Percent},{5 Minute,10. Percent},{50 Minute,100. Percent},{50.1 Minute,0. Percent},{55 Minute,0. Percent}},
			EquivalenceFunction -> Equal,
			Variables:>{packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options,BlankGradientD,"Specify the buffer D gradient for each blank:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					BlankFrequency -> FirstAndLast,
					BlankGradientD -> {{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					BlankGradientD
				]
			),
			{{0 Minute, 10. Percent},{5 Minute,10. Percent},{50 Minute,100. Percent},{50.1 Minute,0. Percent},{55 Minute,0. Percent}},
			EquivalenceFunction -> Equal,
			Variables:>{packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options,BlankFlowRate,"Specify the flow rate for each blank:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					BlankFrequency -> FirstAndLast,
					BlankFlowRate -> 1 Milliliter/Minute
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					BlankFlowRate
				]
			),
			1 Milliliter/Minute,
			EquivalenceFunction -> Equal,
			Variables:>{packet}
		],
		Example[
			{Options,BlankGradient,"Specify the gradient method to use for the blanks:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					BlankGradient -> Object[Method, Gradient, "id:M8n3rxYAonm5"],
					Blank -> Model[Sample, "Milli-Q water"]
				][[1]];
				Lookup[packet,Replace[BlankGradients]]
			),
			{LinkP[Object[Method, Gradient, "id:M8n3rxYAonm5"]]..},
			Variables:>{packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],

		(* === Options - Blank Detector Parameters === *)
		Example[
			{Options,BlankAbsorbanceWavelength,"For Blank samples, specify the detection wavelength of the UVVis detector for each sample:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,BlankAbsorbanceWavelength -> 480 Nano Meter][[1]];
				Lookup[Lookup[packet,ResolvedOptions],BlankAbsorbanceWavelength]
			),
			480 Nanometer,
			EquivalenceFunction -> Equal,
			Variables:>{packet}
		],
		Example[
			{Options,BlankAbsorbanceWavelength,"Specify a range of absorbance detection wavelengths of the PhotoDiodeArray detector for each Blank sample:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,BlankAbsorbanceWavelength -> 300 Nanometer;;500 Nanometer][[1]];
				Lookup[Lookup[packet,ResolvedOptions],BlankAbsorbanceWavelength]
			),
			300 Nanometer;;500 Nanometer,
			Variables:>{packet}
		],
		Example[
			{Options,BlankWavelengthResolution,"For Blank samples, specify the increment in wavelengths to measure with the PhotoDiodeArray detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				BlankWavelengthResolution->1.2*Nanometer, OutputFormat -> List];
			Lookup[options,BlankWavelengthResolution],
			1.2*Nanometer,
			Variables:>{options}
		],
		Example[
			{Options,BlankUVFilter,"For Blank samples, specify whether or not to have the UV filter on or off in order to block UV wavelengths (less than 210 nm):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				BlankUVFilter->False, OutputFormat -> List];
			Lookup[options,BlankUVFilter],
			False,
			Variables:>{options}
		],
		Example[
			{Options,BlankAbsorbanceSamplingRate,"For Blank samples, specify how frequently the absorbance measurements should be conducted:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				BlankAbsorbanceSamplingRate->20*1/Second, OutputFormat -> List];
			Lookup[options,BlankAbsorbanceSamplingRate],
			20*1/Second,
			Variables:>{options},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options,BlankExcitationWavelength,"Specify the specific wavelength (a single tuple) that is used to excite fluorescence in the Blank samples in the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
				BlankFrequency -> First,
				BlankExcitationWavelength->485 Nanometer,
				OutputFormat -> List
			];
			Lookup[options,BlankExcitationWavelength],
			(* Due to the problem with CollapseIndexMatchedOptions trying to collapse an option with both singleton pattern and Adder pattern, ExcitationWavelength option will remain {485 Nanometer} in the resolved option. *)
			(485 Nanometer)|{485 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,BlankExcitationWavelength,"Specify the specific wavelengths (multiple tuples) that are used to excite fluorescence in the Blank samples in the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
				BlankFrequency -> First,
				BlankExcitationWavelength->{485 Nanometer,540 Nanometer},
				OutputFormat -> List
			];
			Lookup[options,BlankExcitationWavelength],
			{485 Nanometer,540 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,BlankEmissionWavelength,"Specify the specific wavelength (a single tuple) at which fluorescence emitted from the Blank sample is measured in the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
				BlankFrequency -> First,
				BlankEmissionWavelength->520 Nanometer,
				OutputFormat -> List
			];
			Lookup[options,BlankEmissionWavelength],
			(* Due to the problem with CollapseIndexMatchedOptions trying to collapse an option with both singleton pattern and Adder pattern, EmissionWavelength option will remain {485 Nanometer} in the resolved option. *)
			(520 Nanometer)|{520 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,BlankEmissionWavelength,"Specify the specific wavelength (multiple tuples) at which fluorescence emitted from the Blank sample is measured in the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
				BlankFrequency -> First,
				BlankEmissionWavelength->{520 Nanometer,590 Nanometer},
				OutputFormat -> List
			];
			Lookup[options,BlankEmissionWavelength],
			{520 Nanometer,590 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,BlankEmissionCutOffFilter,"Specify the cut-off wavelength to pre-select the emitted light from the Blank sample and allow only the light with wavelength above the desired value to pass, before the light enters emission monochromator for final wavelength selection:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
				BlankFrequency -> First,
				BlankEmissionCutOffFilter->280Nanometer,
				OutputFormat -> List
			];
			Lookup[options,BlankEmissionCutOffFilter],
			280Nanometer,
			Variables:>{options}
		],
		Example[
			{Options,BlankFluorescenceGain,"Specify the signal amplification of single-channel fluorescence measurement for the Blank sample to be used on the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
				BlankFrequency -> First,
				BlankExcitationWavelength->485 Nanometer,
				BlankEmissionWavelength->520 Nanometer,
				BlankFluorescenceGain->100 Percent,
				OutputFormat -> List
			];
			Lookup[options,BlankFluorescenceGain],
			(* Due to the problem with CollapseIndexMatchedOptions trying to collapse an option with both singleton pattern and Adder pattern, FluorescenceGain option will remain {5} in the resolved option. *)
			100 Percent|{100 Percent},
			Variables:>{options}
		],
		Example[
			{Options,BlankFluorescenceGain,"Specify the signal amplification of multi-channel fluorescence measurement for the Blank sample to be used on the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Instrument->Model[Instrument, HPLC, "UltiMate 3000 with FLR Detector"],
				Detector->Fluorescence,
				Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
				BlankFrequency -> First,
				BlankExcitationWavelength->{485 Nanometer,540 Nanometer},
				BlankEmissionWavelength->{520 Nanometer,590 Nanometer},
				BlankFluorescenceGain->{50 Percent,20 Percent},
				OutputFormat -> List
			];
			Lookup[options,BlankFluorescenceGain],
			{50 Percent,20 Percent},
			Variables:>{options}
		],
		Example[
			{Options,BlankFluorescenceFlowCellTemperature,"Specify the temperature that the thermostat inside the fluorescence flow cell of the detector is set to during the fluorescence measurement of the blank sample:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
				BlankFrequency -> First,
				BlankFluorescenceFlowCellTemperature->45Celsius,
				OutputFormat -> List
			];
			Lookup[options,BlankFluorescenceFlowCellTemperature],
			45Celsius,
			Variables:>{options}
		],
		Example[
			{Options,BlankLightScatteringLaserPower,"Specify the laser power filter used in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector for the measurement of the blank sample:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{MultiAngleLightScattering,DynamicLightScattering},
				Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
				BlankFrequency -> First,
				BlankLightScatteringLaserPower->90Percent,
				OutputFormat -> List
			];
			Lookup[options,BlankLightScatteringLaserPower],
			90Percent,
			Variables:>{options}
		],
		Example[
			{Options,BlankLightScatteringFlowCellTemperature,"Specify the temperature that the thermostat inside the flow cell of the detector is set to during the Multi-Angle static Light Scattering (MALS) and/or Dynamic Light Scattering (DLS) measurement of the blank sample:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{MultiAngleLightScattering,DynamicLightScattering},
				Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
				BlankFrequency -> First,
				BlankLightScatteringFlowCellTemperature->30Celsius,
				OutputFormat -> List
			];
			Lookup[options,BlankLightScatteringFlowCellTemperature],
			30Celsius,
			Variables:>{options}
		],
		Example[
			{Options,BlankRefractiveIndexMethod,"Specify the type of refractive index measurement of the refractive index (RI) detector for the measurement of the blank sample:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
				BlankFrequency -> First,
				BlankRefractiveIndexMethod->RefractiveIndex,
				OutputFormat -> List
			];
			Lookup[options,BlankRefractiveIndexMethod],
			RefractiveIndex,
			Variables:>{options}
		],
		Example[
			{Options,BlankRefractiveIndexFlowCellTemperature,"Specify the temperature that the thermostat inside the refractive index flow cell of the refractive index (RI) detector is set to during the refractive index measurement of the blank sample:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
				BlankFrequency -> First,
				BlankRefractiveIndexFlowCellTemperature->30Celsius,
				OutputFormat -> List
			];
			Lookup[options,BlankRefractiveIndexFlowCellTemperature],
			30Celsius,
			Variables:>{options}
		],
		Example[
			{Options,BlankNebulizerGas,"For Blank samples, specify whether to turn on or off the sheath gas for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				BlankNebulizerGas->False, OutputFormat -> List];
			Lookup[options,BlankNebulizerGas],
			False,
			Variables:>{options}
		],
		Example[
			{Options,BlankNebulizerGasHeating,"For Blank samples, specify whether to turn on or off the heating element for the sheath gas for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				BlankNebulizerGasHeating->False, OutputFormat -> List];
			Lookup[options,BlankNebulizerGasHeating],
			False,
			Variables:>{options}
		],
		Example[
			{Options,BlankNebulizerHeatingPower,"For Blank samples, specify the magnitude of the heating element for the sheath gas for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				BlankNebulizerHeatingPower->30*Percent, OutputFormat -> List];
			Lookup[options,BlankNebulizerHeatingPower],
			30*Percent,
			Variables:>{options}
		],
		Example[
			{Options,BlankNebulizerGasPressure,"For Blank samples, specify the flow rate of the sheath gas by controlling the applied pressure for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				BlankNebulizerGasPressure->30*PSI, OutputFormat -> List];
			Lookup[options,BlankNebulizerGasPressure],
			30*PSI,
			Variables:>{options}
		],
		Example[
			{Options,BlankDriftTubeTemperature,"For Blank samples, specify the temperature of the spray chamber for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				BlankDriftTubeTemperature->70*Celsius, OutputFormat -> List];
			Lookup[options,BlankDriftTubeTemperature],
			70*Celsius,
			Variables:>{options}
		],
		Example[
			{Options,BlankELSDGain,"For Blank samples, specify the signal amplification of the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				BlankELSDGain->50 Percent, OutputFormat -> List];
			Lookup[options,BlankELSDGain],
			50 Percent,
			Variables:>{options}
		],
		Example[
			{Options,BlankELSDSamplingRate,"For Blank samples, specify the temporal resolution of the measurement of the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				BlankELSDSamplingRate->20*1/Second, OutputFormat -> List];
			Lookup[options,BlankELSDSamplingRate],
			20*1/Second,
			Variables:>{options}
		],
		Example[
			{Options,BlankStorageCondition,"Specify the storage condition in which the blanks should be stored after the protocol completes:"},
			(
				protocol = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Blank -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
					BlankStorageCondition -> Refrigerator
				];
				Download[protocol,BlanksStorageConditions]
			),
			{Refrigerator..},
			Variables:>{protocol}
		],
		Example[
			{Options,BlankStorageCondition,"If two different storage conditions are specified for two blank samples in the same container, throw an error:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID]},
				Blank -> {Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				BlankStorageCondition -> {Refrigerator, Freezer}
			],
			$Failed,
			Messages :> {Error::SharedContainerStorageCondition, Error::InvalidOption}
		],

		(* === Options - COLUMN PRIME/FLUSH === *)
		Example[
			{Options,ColumnRefreshFrequency,"Specify how frequently the column is flushed:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					ColumnRefreshFrequency -> 2
				][[1]];
				Length@Cases[Lookup[packet,Replace[InjectionTable]],KeyValuePattern[Type->ColumnPrime]]
			),
			2,
			Variables:>{packet}
		],
		Example[
			{Options,ColumnRefreshFrequency,"Specify how frequently the column is flushed (can be different for different column sets in ColumnSelector:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample, "Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID], Object[Sample, "Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID]},
					Upload->False,
					ColumnPosition -> {PositionA, PositionB},
					ColumnSelector -> {
						{PositionA, Null, Null, Model[Item, Column, "id:o1k9jAKOw6d7"], Forward, Null, Null},
						{PositionB, Null, Null, Model[Item, Column, "id:dORYzZn0obYE"], Forward, Null, Null}
					},
					Blank -> Model[Sample, "Milli-Q water"],
					ColumnRefreshFrequency -> {FirstAndLast, 1}
				][[1]];
				Lookup[Lookup[packet,Replace[InjectionTable]], {Type,ColumnPosition}]
			),
			{
				{ColumnPrime, PositionA},
				{ColumnPrime, PositionB},
				{Blank, PositionA},
				{Sample, PositionA},
				{ColumnPrime, PositionB},
				{Sample, PositionB},
				{Blank, PositionA},
				{ColumnFlush, PositionA},
				{ColumnFlush, PositionB}
			},
			Variables:>{packet}
		],

		(* === Options - COLUMN PRIME === *)
		Example[
			{Options,ColumnPrimeTemperature,"Specify the column temperature for each column prime:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					ColumnPrimeTemperature -> 60 Celsius
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnPrimeTemperature
				]
			),
			60 Celsius,
			EquivalenceFunction -> Equal,
			Variables:>{packet}
		],
		Example[
			{Options,ColumnPrimeTemperature,"Specify the column temperature for each column prime (multiple column assemblies):"},
			(
				options = ExperimentHPLC[
					{Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID]},
					Output->Options,
					ColumnSelection->True,
					ColumnSelector -> {
						{PositionA,Null,Null,Model[Item,Column,"id:o1k9jAKOw6d7"],Forward,Null,Null},
						{PositionB,Null,Null,Model[Item,Column,"id:dORYzZn0obYE"],Forward,Null,Null}
					},
					Instrument->Model[Instrument, HPLC, "Agilent 1290 Infinity II LC System"],
					ColumnPrimeTemperature->{35Celsius,50Celsius}
				];
				injectionTable=Lookup[options,InjectionTable];
				{
					Lookup[options, ColumnPrimeTemperature],
					injectionTable[[{1,2},{1,4,5}]]
				}
			),
			{
				{35Celsius,50Celsius},
				{{ColumnPrime,PositionA,35Celsius},{ColumnPrime,PositionB,50Celsius}}
			},
			Variables:>{options,injectionTable},
			(* Our current instrument only support Ambient for >1 column assemblies. Since we are checking the resolved InjectionTable, we can ignore these messages *)
			Messages:>{Error::IncompatibleHPLCColumnTemperature,Error::InvalidOption}
		],
		Example[
			{Options,ColumnPrimeGradientA,"Specify the buffer A gradient for each column prime:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					ColumnPrimeGradientA -> {{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnPrimeGradientA
				]
			),
			{{0 Minute, 10. Percent},{5 Minute,10. Percent},{50 Minute,100. Percent},{50.1 Minute,0. Percent},{55 Minute,0. Percent}},
			EquivalenceFunction -> Equal,
			Variables:>{packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options,ColumnPrimeGradientB,"Specify the buffer B gradient for each column prime:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					ColumnPrimeGradientB -> {{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnPrimeGradientB
				]
			),
			{{0 Minute, 10. Percent},{5 Minute,10. Percent},{50 Minute,100. Percent},{50.1 Minute,0. Percent},{55 Minute,0. Percent}},
			EquivalenceFunction -> Equal,
			Variables:>{packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options,ColumnPrimeGradientC,"Specify the buffer C gradient for each column prime:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					ColumnPrimeGradientC -> {{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnPrimeGradientC
				]
			),
			{{0 Minute, 10. Percent},{5 Minute,10. Percent},{50 Minute,100. Percent},{50.1 Minute,0. Percent},{55 Minute,0. Percent}},
			EquivalenceFunction -> Equal,
			Variables:>{packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options,ColumnPrimeGradientD,"Specify the buffer D gradient for each column prime:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					ColumnPrimeGradientD -> {{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnPrimeGradientD
				]
			),
			{{0 Minute, 10. Percent},{5 Minute,10. Percent},{50 Minute,100. Percent},{50.1 Minute,0. Percent},{55 Minute,0. Percent}},
			EquivalenceFunction -> Equal,
			Variables:>{packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[
			{Options,ColumnPrimeFlowRate,"Specify the flow rate for each column prime:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					ColumnPrimeFlowRate -> 1 Milliliter/Minute
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnPrimeFlowRate
				]
			),
			1 Milliliter/Minute,
			EquivalenceFunction -> Equal,
			Variables:>{packet}
		],
		Example[
			{Options,ColumnPrimeGradient,"Specify the column prime gradient with an existing method:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					ColumnPrimeGradient -> Object[Method, Gradient, "id:M8n3rxYAonm5"]
				][[1]];
				Lookup[packet,Replace[ColumnPrimeGradients]]
			),
			{LinkP[Object[Method, Gradient, "id:M8n3rxYAonm5"]]},
			Variables:>{packet},
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],

		(* === Options - Column Prime Detector Parameters === *)
		Example[
			{Options,ColumnPrimeAbsorbanceWavelength,"For column prime(s), specify the detection wavelength for each set of columns:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,ColumnPrimeAbsorbanceWavelength -> 480 Nano Meter][[1]];
				Lookup[Lookup[packet,ResolvedOptions],ColumnPrimeAbsorbanceWavelength]
			),
			480 Nanometer,
			EquivalenceFunction -> Equal,
			Variables:>{packet}
		],
		Example[
			{Options,ColumnPrimeWavelengthResolution,"For column prime(s), specify the increment in wavelengths to measure with the PhotoDiodeArray detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnPrimeWavelengthResolution->1.2*Nanometer, OutputFormat -> List];
			Lookup[options,ColumnPrimeWavelengthResolution],
			1.2*Nanometer,
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeUVFilter,"For column prime(s), specify whether or not to have the UV filter on or off in order to block UV wavelengths (less than 210 nm):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnPrimeUVFilter->False, OutputFormat -> List];
			Lookup[options,ColumnPrimeUVFilter],
			False,
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeAbsorbanceSamplingRate,"For column prime(s), specify how frequently to conduct sampling measurements:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnPrimeAbsorbanceSamplingRate->20*1/Second, OutputFormat -> List];
			Lookup[options,ColumnPrimeAbsorbanceSamplingRate],
			20*1/Second,
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeExcitationWavelength,"Specify the specific wavelength (a single tuple) that is used to excite fluorescence during column prime in the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				ColumnPrimeExcitationWavelength->485 Nanometer,
				OutputFormat -> List
			];
			Lookup[options,ColumnPrimeExcitationWavelength],
			(* Due to the problem with CollapseIndexMatchedOptions trying to collapse an option with both singleton pattern and Adder pattern, ExcitationWavelength option will remain {485 Nanometer} in the resolved option. *)
			(485 Nanometer)|{485 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeExcitationWavelength,"Specify the specific wavelengths (multiple tuples) that are used to excite fluorescence during column prime in the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				ColumnPrimeExcitationWavelength->{485 Nanometer,540 Nanometer},
				OutputFormat -> List
			];
			Lookup[options,ColumnPrimeExcitationWavelength],
			{485 Nanometer,540 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeEmissionWavelength,"Specify the specific wavelength (a single tuple) at which fluorescence emitted from the flow downstream of the column is measured in the Fluorescence detector during column prime:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				ColumnPrimeEmissionWavelength->520 Nanometer,
				OutputFormat -> List
			];
			Lookup[options,ColumnPrimeEmissionWavelength],
			(* Due to the problem with CollapseIndexMatchedOptions trying to collapse an option with both singleton pattern and Adder pattern, EmissionWavelength option will remain {485 Nanometer} in the resolved option. *)
			(520 Nanometer)|{520 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeEmissionWavelength,"Specify the specific wavelength (multiple tuples) at which fluorescence emitted from the flow downstream of the column is measured in the Fluorescence detector during column prime:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				ColumnPrimeEmissionWavelength->{520 Nanometer,590 Nanometer},
				OutputFormat -> List
			];
			Lookup[options,ColumnPrimeEmissionWavelength],
			{520 Nanometer,590 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeEmissionCutOffFilter,"Specify the cut-off wavelength during column prime to pre-select the emitted light from the flow downstream of the column and allow only the light with wavelength above the desired value to pass, before the light enters emission monochromator for final wavelength selection:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				ColumnPrimeEmissionCutOffFilter->280Nanometer,
				OutputFormat -> List
			];
			Lookup[options,ColumnPrimeEmissionCutOffFilter],
			280Nanometer,
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeFluorescenceGain,"Specify the signal amplification of single-channel fluorescence measurement during column prime to be used on the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				ColumnPrimeExcitationWavelength->485 Nanometer,
				ColumnPrimeEmissionWavelength->520 Nanometer,
				ColumnPrimeFluorescenceGain->100 Percent,
				OutputFormat -> List
			];
			Lookup[options,ColumnPrimeFluorescenceGain],
			(* Due to the problem with CollapseIndexMatchedOptions trying to collapse an option with both singleton pattern and Adder pattern, FluorescenceGain option will remain {5} in the resolved option. *)
			100 Percent|{100 Percent},
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeFluorescenceGain,"Specify the signal amplification of multi-channel fluorescence measurement during column prime to be used on the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Instrument->Model[Instrument, HPLC, "UltiMate 3000 with FLR Detector"],
				Detector->Fluorescence,
				ColumnPrimeExcitationWavelength->{485 Nanometer,540 Nanometer},
				ColumnPrimeEmissionWavelength->{520 Nanometer,590 Nanometer},
				ColumnPrimeFluorescenceGain->{50 Percent,20 Percent},
				OutputFormat -> List
			];
			Lookup[options,ColumnPrimeFluorescenceGain],
			{50 Percent,20 Percent},
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeFluorescenceFlowCellTemperature,"Specify the temperature that the thermostat inside the fluorescence flow cell of the detector is set to during column prime:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				ColumnPrimeFluorescenceFlowCellTemperature->45Celsius,
				OutputFormat -> List
			];
			Lookup[options,ColumnPrimeFluorescenceFlowCellTemperature],
			45Celsius,
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeLightScatteringLaserPower,"Specify the laser power filter used in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector for the measurement during column prime:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{MultiAngleLightScattering,DynamicLightScattering},
				ColumnPrimeLightScatteringLaserPower->90Percent,
				OutputFormat -> List
			];
			Lookup[options,ColumnPrimeLightScatteringLaserPower],
			90Percent,
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeLightScatteringFlowCellTemperature,"Specify the temperature that the thermostat inside the flow cell of the detector is set to during the Multi-Angle static Light Scattering (MALS) and/or Dynamic Light Scattering (DLS) measurement during column prime:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{MultiAngleLightScattering,DynamicLightScattering},
				ColumnPrimeLightScatteringFlowCellTemperature->30Celsius,
				OutputFormat -> List
			];
			Lookup[options,ColumnPrimeLightScatteringFlowCellTemperature],
			30Celsius,
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeRefractiveIndexMethod,"Specify the type of refractive index measurement of the refractive index (RI) detector for the measurement during column prime:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnPrimeRefractiveIndexMethod->RefractiveIndex,
				OutputFormat -> List
			];
			Lookup[options,ColumnPrimeRefractiveIndexMethod],
			RefractiveIndex,
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeRefractiveIndexFlowCellTemperature,"Specify the temperature that the thermostat inside the refractive index flow cell of the refractive index (RI) detector is set to during the refractive index measurement during column prime:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnPrimeRefractiveIndexFlowCellTemperature->30Celsius,
				OutputFormat -> List
			];
			Lookup[options,ColumnPrimeRefractiveIndexFlowCellTemperature],
			30Celsius,
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeNebulizerGas,"For column prime(s), specify whether to turn on or off the sheath gas for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnPrimeNebulizerGas->False, OutputFormat -> List];
			Lookup[options,ColumnPrimeNebulizerGas],
			False,
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeNebulizerGasHeating,"For column prime(s), specify whether to turn on or off the heating element for the sheath gas for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnPrimeNebulizerGasHeating->False, OutputFormat -> List];
			Lookup[options,ColumnPrimeNebulizerGasHeating],
			False,
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeNebulizerHeatingPower,"For column prime(s), specify the magnitude of the heating element for the sheath gas for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnPrimeNebulizerHeatingPower->30*Percent, OutputFormat -> List];
			Lookup[options,ColumnPrimeNebulizerHeatingPower],
			30*Percent,
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeNebulizerGasPressure,"For column prime(s), specify the flow rate of the sheath gas by controlling the applied pressure for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnPrimeNebulizerGasPressure->30*PSI, OutputFormat -> List];
			Lookup[options,ColumnPrimeNebulizerGasPressure],
			30*PSI,
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeDriftTubeTemperature,"For column prime(s), specify the temperature of the spray chamber for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnPrimeDriftTubeTemperature->70*Celsius, OutputFormat -> List];
			Lookup[options,ColumnPrimeDriftTubeTemperature],
			70*Celsius,
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeELSDGain,"For column prime(s), specify the signal amplification of the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnPrimeELSDGain->50 Percent, OutputFormat -> List];
			Lookup[options,ColumnPrimeELSDGain],
			50 Percent,
			Variables:>{options}
		],
		Example[
			{Options,ColumnPrimeELSDSamplingRate,"For column prime(s), specify the temporal resolution of the measurement of the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnPrimeELSDSamplingRate->20*1/Second, OutputFormat -> List];
			Lookup[options,ColumnPrimeELSDSamplingRate],
			20*1/Second,
			Variables:>{options}
		],

		(* === Options - COLUMN FLUSH === *)
		Example[
			{Options,ColumnFlushTemperature,"Specify the column temperature for each column flush:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					ColumnFlushTemperature -> 60 Celsius
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnFlushTemperature
				]
			),
			60 Celsius,
			EquivalenceFunction -> Equal,
			Variables:>{packet}
		],
		Example[
			{Options,ColumnFlushTemperature,"Specify the column temperature for each column flush (multiple column assemblies):"},
			(
				options = ExperimentHPLC[
					{Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID]},
					Output->Options,
					ColumnSelection->True,
					ColumnSelector -> {
						{PositionA,Null,Null,Model[Item,Column,"id:o1k9jAKOw6d7"],Forward,Null,Null},
						{PositionB,Null,Null,Model[Item,Column,"id:dORYzZn0obYE"],Forward,Null,Null}
					},
					Instrument->Model[Instrument, HPLC, "Agilent 1290 Infinity II LC System"],
					ColumnFlushTemperature->{58Celsius,34Celsius}
				];
				injectionTable=Lookup[options,InjectionTable];
				{
					Lookup[options, ColumnFlushTemperature],
					injectionTable[[{-2,-1},{1,4,5}]]
				}
			),
			{
				{58Celsius,34Celsius},
				{{ColumnFlush,PositionA,58Celsius},{ColumnFlush,PositionB,34Celsius}}
			},
			Variables:>{options,injectionTable},
			(* Our current instrument only support Ambient for >1 column assemblies. Since we are checking the resolved InjectionTable, we can ignore these messages *)
			Messages:>{Error::IncompatibleHPLCColumnTemperature,Error::InvalidOption}
		],
		Example[
			{Options,ColumnFlushGradientA,"Specify the buffer A gradient for each column flush:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					ColumnFlushGradientA -> {{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnFlushGradientA
				]
			),
			{{0 Minute, 10. Percent},{5 Minute,10. Percent},{50 Minute,100. Percent},{50.1 Minute,0. Percent},{55 Minute,0. Percent}},
			EquivalenceFunction -> Equal,
			Variables:>{packet}
		],
		Example[
			{Options,ColumnFlushGradientB,"Specify the buffer B gradient for each column flush:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					ColumnFlushGradientB -> {{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnFlushGradientB
				]
			),
			{{0 Minute, 10. Percent},{5 Minute,10. Percent},{50 Minute,100. Percent},{50.1 Minute,0. Percent},{55 Minute,0. Percent}},
			EquivalenceFunction -> Equal,
			Variables:>{packet}
		],
		Example[
			{Options,ColumnFlushGradientC,"Specify the buffer C gradient for each column flush:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					ColumnFlushGradientC -> {{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnFlushGradientC
				]
			),
			{{0 Minute, 10. Percent},{5 Minute,10. Percent},{50 Minute,100. Percent},{50.1 Minute,0. Percent},{55 Minute,0. Percent}},
			EquivalenceFunction -> Equal,
			Variables:>{packet}
		],
		Example[
			{Options,ColumnFlushGradientD,"Specify the buffer D gradient for each column flush:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					ColumnFlushGradientD -> {{0 Minute,10 Percent},{5 Minute, 10 Percent},{50 Minute,100 Percent},{50.1 Minute,0 Percent},{55 Minute, 0 Percent}}
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnFlushGradientD
				]
			),
			{{0 Minute, 10. Percent},{5 Minute,10. Percent},{50 Minute,100. Percent},{50.1 Minute,0. Percent},{55 Minute,0. Percent}},
			Variables:>{packet},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options,ColumnFlushFlowRate,"Specify the flow rate for each column flush:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload -> False,
					ColumnFlushFlowRate -> 1 Milliliter/Minute
				][[1]];
				Lookup[
					Lookup[
						packet,
						ResolvedOptions
					],
					ColumnFlushFlowRate
				]
			),
			1 Milliliter/Minute,
			EquivalenceFunction -> Equal,
			Variables:>{packet}
		],
		Example[
			{Options,ColumnFlushGradient,"Specify the column flush gradient with an existing method:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,
					ColumnFlushGradient -> Object[Method, Gradient, "id:M8n3rxYAonm5"]
				][[1]];
				Lookup[packet,Replace[ColumnFlushGradients]]
			),
			{LinkP[Object[Method, Gradient, "id:M8n3rxYAonm5"]]},
			Variables:>{packet}
		],

		(* === Options - Column Flush Detector Parameters === *)
		Example[
			{Options,ColumnFlushAbsorbanceWavelength,"For column flush(es), specify the detection wavelength for each set of columns:"},
			(
				packet = ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Upload->False,ColumnFlushAbsorbanceWavelength -> 480 Nano Meter][[1]];
				Lookup[Lookup[packet,ResolvedOptions],ColumnFlushAbsorbanceWavelength]
			),
			480 Nanometer,
			EquivalenceFunction -> Equal,
			Variables:>{packet}
		],
		Example[
			{Options,ColumnFlushWavelengthResolution,"For column flush(es), specify the increment in wavelengths to measure with the PDA detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnFlushWavelengthResolution->1.2*Nanometer, OutputFormat -> List];
			Lookup[options,ColumnFlushWavelengthResolution],
			1.2*Nanometer,
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushUVFilter,"For column flush(es), specify whether or not to have the UV filter on or off in order to block UV wavelengths (less than 210 nm):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnFlushUVFilter->False, OutputFormat -> List];
			Lookup[options,ColumnFlushUVFilter],
			False,
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushAbsorbanceSamplingRate,"For column flush(es), specify how frequently to conduct sampling measurements:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnFlushAbsorbanceSamplingRate->20*1/Second, OutputFormat -> List];
			Lookup[options,ColumnFlushAbsorbanceSamplingRate],
			20*1/Second,
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushExcitationWavelength,"Specify the specific wavelength (a single tuple) that is used to excite fluorescence during column flush in the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				ColumnFlushExcitationWavelength->485 Nanometer,
				OutputFormat -> List
			];
			Lookup[options,ColumnFlushExcitationWavelength],
			(* Due to the problem with CollapseIndexMatchedOptions trying to collapse an option with both singleton pattern and Adder pattern, ExcitationWavelength option will remain {485 Nanometer} in the resolved option. *)
			(485 Nanometer)|{485 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushExcitationWavelength,"Specify the specific wavelengths (multiple tuples) that are used to excite fluorescence during column flush in the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				ColumnFlushExcitationWavelength->{485 Nanometer,540 Nanometer},
				OutputFormat -> List
			];
			Lookup[options,ColumnFlushExcitationWavelength],
			{485 Nanometer,540 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushEmissionWavelength,"Specify the specific wavelength (a single tuple) at which fluorescence emitted from the flow downstream of the column is measured in the Fluorescence detector during column flush:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				ColumnFlushEmissionWavelength->520 Nanometer,
				OutputFormat -> List
			];
			Lookup[options,ColumnFlushEmissionWavelength],
			(* Due to the problem with CollapseIndexMatchedOptions trying to collapse an option with both singleton pattern and Adder pattern, EmissionWavelength option will remain {485 Nanometer} in the resolved option. *)
			(520 Nanometer)|{520 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushEmissionWavelength,"Specify the specific wavelength (multiple tuples) at which fluorescence emitted from the flow downstream of the column is measured in the Fluorescence detector during column flush:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				ColumnFlushEmissionWavelength->{520 Nanometer,590 Nanometer},
				OutputFormat -> List
			];
			Lookup[options,ColumnFlushEmissionWavelength],
			{520 Nanometer,590 Nanometer},
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushEmissionCutOffFilter,"Specify the cut-off wavelength during column flush to pre-select the emitted light from the flow downstream of the column and allow only the light with wavelength above the desired value to pass, before the light enters emission monochromator for final wavelength selection:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				ColumnFlushEmissionCutOffFilter->280Nanometer,
				OutputFormat -> List
			];
			Lookup[options,ColumnFlushEmissionCutOffFilter],
			280Nanometer,
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushFluorescenceGain,"Specify the signal amplification of single-channel fluorescence measurement during column flush to be used on the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				ColumnFlushExcitationWavelength->485 Nanometer,
				ColumnFlushEmissionWavelength->520 Nanometer,
				ColumnFlushFluorescenceGain->100 Percent,
				OutputFormat -> List
			];
			Lookup[options,ColumnFlushFluorescenceGain],
			(* Due to the problem with CollapseIndexMatchedOptions trying to collapse an option with both singleton pattern and Adder pattern, FluorescenceGain option will remain {5} in the resolved option. *)
			100 Percent|{100 Percent},
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushFluorescenceGain,"Specify the signal amplification of multi-channel fluorescence measurement during column flush to be used on the Fluorescence detector:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Instrument->Model[Instrument, HPLC, "UltiMate 3000 with FLR Detector"],
				Detector->Fluorescence,
				ColumnFlushExcitationWavelength->{485 Nanometer,540 Nanometer},
				ColumnFlushEmissionWavelength->{520 Nanometer,590 Nanometer},
				ColumnFlushFluorescenceGain->{50Percent,20Percent},
				OutputFormat -> List
			];
			Lookup[options,ColumnFlushFluorescenceGain],
			{50Percent,20Percent},
			Variables:>{options},
			EquivalenceFunction -> Equal
		],
		Example[
			{Options,ColumnFlushFluorescenceFlowCellTemperature,"Specify the temperature that the thermostat inside the fluorescence flow cell of the detector is set to during column flush:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				ColumnFlushFluorescenceFlowCellTemperature->45Celsius,
				OutputFormat -> List
			];
			Lookup[options,ColumnFlushFluorescenceFlowCellTemperature],
			45Celsius,
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushLightScatteringLaserPower,"Specify the laser power filter used in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector for the measurement during column flush:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{MultiAngleLightScattering,DynamicLightScattering},
				ColumnFlushLightScatteringLaserPower->90Percent,
				OutputFormat -> List
			];
			Lookup[options,ColumnFlushLightScatteringLaserPower],
			90Percent,
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushLightScatteringFlowCellTemperature,"Specify the temperature that the thermostat inside the flow cell of the detector is set to during the Multi-Angle static Light Scattering (MALS) and/or Dynamic Light Scattering (DLS) measurement during column flush:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{MultiAngleLightScattering,DynamicLightScattering},
				ColumnFlushLightScatteringFlowCellTemperature->30Celsius,
				OutputFormat -> List
			];
			Lookup[options,ColumnFlushLightScatteringFlowCellTemperature],
			30Celsius,
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushRefractiveIndexMethod,"Specify the type of refractive index measurement of the refractive index (RI) detector for the measurement during column flush:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnFlushRefractiveIndexMethod->RefractiveIndex,
				OutputFormat -> List
			];
			Lookup[options,ColumnFlushRefractiveIndexMethod],
			RefractiveIndex,
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushRefractiveIndexFlowCellTemperature,"Specify the temperature that the thermostat inside the refractive index flow cell of the refractive index (RI) detector is set to during the refractive index measurement during column flush:"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnFlushRefractiveIndexFlowCellTemperature->30Celsius,
				OutputFormat -> List
			];
			Lookup[options,ColumnFlushRefractiveIndexFlowCellTemperature],
			30Celsius,
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushNebulizerGas,"For column flush(es), specify whether to turn on or off the sheath gas for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnFlushNebulizerGas->False, OutputFormat -> List];
			Lookup[options,ColumnFlushNebulizerGas],
			False,
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushNebulizerGasHeating,"For column flush(es), specify whether to turn on or off the heating element for the sheath gas for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnFlushNebulizerGasHeating->False, OutputFormat -> List];
			Lookup[options,ColumnFlushNebulizerGasHeating],
			False,
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushNebulizerHeatingPower,"For column flush(es), specify the magnitude of the heating element for the sheath gas for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnFlushNebulizerHeatingPower->30*Percent, OutputFormat -> List];
			Lookup[options,ColumnFlushNebulizerHeatingPower],
			30*Percent,
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushNebulizerGasPressure,"For column flush(es), specify the flow rate of the sheath gas by controlling the applied pressure for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnFlushNebulizerGasPressure->30*PSI, OutputFormat -> List];
			Lookup[options,ColumnFlushNebulizerGasPressure],
			30*PSI,
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushDriftTubeTemperature,"For column flush(es), specify the temperature of the spray chamber for the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnFlushDriftTubeTemperature->70*Celsius, OutputFormat -> List];
			Lookup[options,ColumnFlushDriftTubeTemperature],
			70*Celsius,
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushELSDGain,"For column flush(es), specify the signal amplification of the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnFlushELSDGain->50 Percent, OutputFormat -> List];
			Lookup[options,ColumnFlushELSDGain],
			50 Percent,
			Variables:>{options}
		],
		Example[
			{Options,ColumnFlushELSDSamplingRate,"For column flush(es), specify the temporal resolution of the measurement of the EvaporativeLightScattering detector (if available for the given instrument):"},
			options = ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnFlushELSDSamplingRate->20*1/Second, OutputFormat -> List];
			Lookup[options,ColumnFlushELSDSamplingRate],
			20*1/Second,
			Variables:>{options}
		],

		(* === Shared Options - General === *)
		Example[{Options,ImageSample, "Indicate whether samples should be imaged afterwards:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], ImageSample->False, Output -> Options];
			Lookup[options, ImageSample],
			False,
			Variables :> {options}
		],
		Example[{Options,MeasureVolume, "Indicate whether samples should be volume measured afterwards:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], MeasureVolume->False, Output -> Options];
			Lookup[options, MeasureVolume],
			False,
			Variables :> {options}
		],
		Example[{Options,MeasureWeight, "Indicate whether samples should be weighed afterwards:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], MeasureWeight->False, Output -> Options];
			Lookup[options, MeasureWeight],
			False,
			Variables :> {options}
		],
		Example[{Options,Template, "Use a previous HPLC protocol as a template for a new one:"},
			options = ExperimentHPLC[{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Template->Object[Protocol,HPLC,"Test Template Protocol for ExperimentHPLC" <> $SessionUUID],
				ColumnRefreshFrequency -> Automatic,
				Output -> Options];
			Lookup[options, DriftTubeTemperature],
			55*Celsius,
			Variables :> {options}
		],
		Example[{Options,Name,"Specify the Name of the created HPLC object:"},
			(
				packet = ExperimentHPLC[
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Name->"Another special HPLC New protocol name",Upload->False][[1]];
				Lookup[packet,Name]
			),
			"Another special HPLC New protocol name"
		],

		(* === Shared Options - Incubate === *)
		Example[{Options,Incubate, "Indicate if the SamplesIn should be incubated at a fixed temperature prior to performing any aliquoting or starting the experiment:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], Incubate -> True, Output -> Options];
			Lookup[options, Incubate],
			True,
			Variables :> {options}
		],
		Example[{Options,IncubationTemperature, "Provide the temperature at which the SamplesIn should be incubated:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], IncubationTemperature -> 40 Celsius, Output -> Options];
			Lookup[options, IncubationTemperature],
			40 Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,IncubationTime, "Indicate SamplesIn should be heated for 40 minutes prior to performing any aliquoting or starting the experiment:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], IncubationTime -> 40 Minute, Output -> Options];
			Lookup[options, IncubationTime],
			40 Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,Mix, "Indicates if the SamplesIn should be  prior to performing any aliquoting or starting the experiment:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], Mix -> True, Output -> Options];
			Lookup[options, Mix],
			True,
			Variables :> {options}
		],
		Example[{Options,MixType, "Indicates the style of motion used to mix the sample, prior to starting the experiment:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], MixType -> Vortex, Output -> Options];
			Lookup[options, MixType],
			Vortex,
			Variables :> {options}
		],
		Example[{Options,MixUntilDissolved, "Indicates if the mix should be continued up to the MaxIncubationTime or MaxNumberOfMixes (chosen according to the mix Type), in an attempt dissolve any solute: Any mixing/incbation will occur prior to starting the experiment:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], MixUntilDissolved -> True, Output -> Options];
			Lookup[options, MixUntilDissolved],
			True,
			Variables :> {options}
		],
		Example[{Options,MaxIncubationTime, "Indicate the SamplesIn should be mixed and heated for up to 2 hours or until any solids are fully dissolved:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], MixUntilDissolved->True, MaxIncubationTime -> 2 Hour, Output -> Options];
			Lookup[options, MaxIncubationTime],
			2 Hour,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,IncubationInstrument, "Indicate the instrument which should be used to heat SamplesIn:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], IncubationInstrument -> Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"], Output -> Options];
			Lookup[options, IncubationInstrument],
			ObjectP[Model[Instrument, HeatBlock, "id:3em6Zv9NjwRo"]],
			Variables :> {options}
		],
		Example[{Options,AnnealingTime, "Set the minimum duration for which the SamplesIn should remain in the incubator allowing the system to settle to room temperature after the IncubationTime has passed:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], AnnealingTime -> 40 Minute, Output -> Options];
			Lookup[options, AnnealingTime],
			40 Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,IncubateAliquot, "Specify the amount of each sample that should be transferred from the SamplesIn into the IncubateAliquotContainer when transferring the input sample to a new container before incubation:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], IncubateAliquot -> 450 Microliter, Output -> Options];
			Lookup[options, IncubateAliquot],
			450 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,IncubateAliquotContainer, "Indicate that the input samples should be transferred into 2mL tubes before the are incubated:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], IncubateAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, IncubateAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,IncubateAliquotDestinationWell, "Indicates how the desired position in the corresponding IncubateAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], IncubateAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,IncubateAliquotDestinationWell],
			"A1",
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],

		(* === Shared Options - Centrifuge === *)
		Example[{Options,Centrifuge, "Indicates if the SamplesIn should be centrifuged prior to performing any aliquoting or starting the experiment:"},
			options = ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Centrifuge -> True, Output -> Options];
			Lookup[options, Centrifuge],
			True,
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options,CentrifugeInstrument, "Set the centrifuge that should be used to spin the input samples:"},
			options = ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				CentrifugeInstrument -> Model[Instrument, Centrifuge, "Avanti J-15R"], Output -> Options];
			Lookup[options, CentrifugeInstrument],
			ObjectP[Model[Instrument, Centrifuge, "Avanti J-15R"]],
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options,CentrifugeIntensity, "Indicate the rotational speed which should be applied to the input samples during centrifugation:"},
			options = ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				CentrifugeIntensity -> 1000 RPM, Output -> Options];
			Lookup[options, CentrifugeIntensity],
			1000 RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options,CentrifugeTime, "Specify the SamplesIn should be centrifuged for 2 minutes:"},
			options = ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				CentrifugeTime -> 2 Minute, Output -> Options];
			Lookup[options, CentrifugeTime],
			2 Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options,CentrifugeTemperature, "Indicate the temperature at which the centrifuge chamber should be held while the samples are being centrifuged:"},
			options = ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				CentrifugeTemperature -> 10 Celsius, Output -> Options];
			Lookup[options, CentrifugeTemperature],
			10 Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			TimeConstraint -> 240
		],
		Example[{Options,CentrifugeAliquot, "Indicate the amount of each sample that should be transferred from the SamplesIn into the CentrifugeAliquotContainer when performing an aliquot before centrifugation:"},
			options = ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				CentrifugeAliquot -> 450 Microliter, Output -> Options];
			Lookup[options, CentrifugeAliquot],
			450 Microliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 240
		],
		Example[{Options,CentrifugeAliquotContainer, "Indicate that the input samples should be transferred into 2mL tubes before the are centrifuged:"},
			options = ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				CentrifugeAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, CentrifugeAliquotContainer],
			{{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},{2, ObjectP[Model[Container, Vessel, "2mL Tube"]]},{3, ObjectP[Model[Container, Vessel, "2mL Tube"]]}},
			Variables :> {options},
			Messages:>{Warning::AliquotRequired},
			TimeConstraint -> 240
		],
		Example[{Options,CentrifugeAliquotDestinationWell, "Indicates how the desired position in the corresponding CentrifugeAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], CentrifugeAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,CentrifugeAliquotDestinationWell],
			"A1",
			Variables:>{options},
			Messages:>{Warning::AliquotRequired}
		],

		(* === Shared Options - Filter === *)
		Example[{Options,Filtration, "Indicates if the SamplesIn should be filtered prior to starting the experiment or any aliquoting: Sample Preparation occurs in the order of Incubation, Centrifugation, Filtration, and then Aliquoting (if specified):"},
			options = ExperimentHPLC[Object[Sample,"Large Container Sample for ExperimentHPLC" <> $SessionUUID], Filtration -> True, Output -> Options];
			Lookup[options, Filtration],
			True,
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FiltrationType, "The type of filtration method that should be used to perform the filtration:"},
			options = ExperimentHPLC[Object[Sample,"Test sample for invalid container for ExperimentHPLC tests" <> $SessionUUID], FiltrationType -> Syringe, Output -> Options];
			Lookup[options, FiltrationType],
			Syringe,
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterInstrument, "The instrument that should be used to perform the filtration:"},
			options = ExperimentHPLC[Object[Sample,"Large Container Sample for ExperimentHPLC" <> $SessionUUID], FilterInstrument -> Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"], Output -> Options];
			Lookup[options, FilterInstrument],
			ObjectP[Model[Instrument, PeristalticPump, "VWR Peristaltic Variable Pump PP3400"]],
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,Filter, "The filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentHPLC[Object[Sample,"Large Container Sample for ExperimentHPLC" <> $SessionUUID], Filter -> Model[Item,Filter,"Membrane Filter, PTFE, 0.22um, 142mm"], Output -> Options];
			Lookup[options, Filter],
			ObjectP[Model[Item,Filter,"Membrane Filter, PTFE, 0.22um, 142mm"]],
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterMaterial, "The membrane material of the filter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentHPLC[Object[Sample,"Large Container Sample for ExperimentHPLC" <> $SessionUUID], FilterMaterial -> PES, Output -> Options];
			Lookup[options, FilterMaterial],
			PES,
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,PrefilterMaterial, "The membrane material of the prefilter that should be used to remove impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentHPLC[Object[Sample,"Test sample for invalid container for ExperimentHPLC tests" <> $SessionUUID], PrefilterMaterial -> GxF, Output -> Options];
			Lookup[options, PrefilterMaterial],
			GxF,
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterPoreSize, "The pore size of the filter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentHPLC[Object[Sample,"Large Container Sample for ExperimentHPLC" <> $SessionUUID], FilterPoreSize -> 0.22 Micrometer, Output -> Options];
			Lookup[options, FilterPoreSize],
			0.22 Micrometer,
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,PrefilterPoreSize, "The pore size of the prefilter that should be used when removing impurities from the SamplesIn prior to starting the experiment:"},
			options = ExperimentHPLC[Object[Sample,"Test sample for invalid container for ExperimentHPLC tests" <> $SessionUUID], PrefilterPoreSize -> 1.`*Micrometer, Output -> Options];
			Lookup[options, PrefilterPoreSize],
			1.`*Micrometer,
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterSyringe, "The syringe used to force that sample through a filter:"},
			options = ExperimentHPLC[Object[Sample,"Test sample for invalid container for ExperimentHPLC tests" <> $SessionUUID], FiltrationType -> Syringe, FilterSyringe -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Output -> Options];
			Lookup[options, FilterSyringe],
			ObjectP[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]],
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterHousing, "The filter housing that should be used to hold the filter membrane when filtration is performed using a standalone filter membrane:"},
			options = ExperimentHPLC[Object[Sample,"Large Container Sample for ExperimentHPLC" <> $SessionUUID], FiltrationType -> PeristalticPump, FilterHousing -> Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"], Output -> Options];
			Lookup[options, FilterHousing],
			ObjectP[Model[Instrument, FilterHousing, "Filter Membrane Housing, 142 mm"]],
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterIntensity, "The rotational speed or force at which the samples will be centrifuged during filtration:"},
			options = ExperimentHPLC[Object[Sample,"Test sample for invalid container for ExperimentHPLC tests" <> $SessionUUID], FiltrationType -> Centrifuge, FilterIntensity -> 1000 RPM, Output -> Options];
			Lookup[options, FilterIntensity],
			1000 RPM,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterTime, "The amount of time for which the samples will be centrifuged during filtration:"},
			options = ExperimentHPLC[Object[Sample,"Test sample for invalid container for ExperimentHPLC tests" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTime -> 20 Minute, Output -> Options];
			Lookup[options, FilterTime],
			20 Minute,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterTemperature, "The temperature at which the centrifuge chamber will be held while the samples are being centrifuged during filtration:"},
			options = ExperimentHPLC[Object[Sample,"Test sample for invalid container for ExperimentHPLC tests" <> $SessionUUID], FiltrationType -> Centrifuge, FilterTemperature -> 30 Celsius, Output -> Options];
			Lookup[options, FilterTemperature],
			30 Celsius,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterSterile, "Indicates if the filtration of the samples should be done in a sterile environment:"},
			options = ExperimentHPLC[Object[Sample,"Large Container Sample for ExperimentHPLC" <> $SessionUUID], FilterSterile -> True, Output -> Options];
			Lookup[options, FilterSterile],
			True,
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterAliquot, "The amount of each sample that should be transferred from the SamplesIn into the FilterAliquotContainer when performing an aliquot before filtration:"},
			options = ExperimentHPLC[Object[Sample,"Large Container Sample for ExperimentHPLC" <> $SessionUUID], FilterAliquot -> 200 Milliliter, Output -> Options];
			Lookup[options, FilterAliquot],
			200 Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,FilterAliquotContainer, "The desired type of container that should be used to prepare and house the filter samples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], FilterAliquotContainer -> Model[Container, Vessel, "2mL Tube"], Output -> Options];
			Lookup[options, FilterAliquotContainer],
			{1, ObjectP[Model[Container, Vessel, "2mL Tube"]]},
			Variables :> {options}
		],
		Example[{Options,FilterAliquotDestinationWell, "Indicates how the desired position in the corresponding FilterAliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], FilterAliquotDestinationWell -> "A1", Output -> Options];
			Lookup[options,FilterAliquotDestinationWell],
			"A1",
			Variables:>{options}
		],
		Example[{Options,FilterContainerOut, "The desired container filtered samples should be produced in or transferred into by the end of filtration, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentHPLC[Object[Sample,"Large Container Sample for ExperimentHPLC" <> $SessionUUID], FilterContainerOut -> Model[Container, Vessel, "250mL Glass Bottle"], Output -> Options];
			Lookup[options, FilterContainerOut],
			{1, ObjectP[Model[Container, Vessel, "250mL Glass Bottle"]]},
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],

		(* === Shared Options - Aliquot === *)
		Example[{Options,Aliquot, "Indicates if aliquots should be taken from the SamplesIn and transferred into new AliquotSamples used in lieu of the SamplesIn for the experiment: Note that if NumberOfReplicates is specified this indicates that the input samples will also be aliquoted that number of times: Note that Aliquoting (if specified) occurs after any Sample Preparation (if specified):"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], Aliquot -> True, Output -> Options];
			Lookup[options, Aliquot],
			True,
			Variables :> {options}
		],
		Example[{Options,Aliquot,"If input samples are not in a supported container, force aliquotting in correct container type:"},
			options=ExperimentHPLC[Object[Sample,"Test sample for invalid container for ExperimentHPLC tests" <> $SessionUUID],InjectionVolume -> 100 Microliter,Output -> Options];
			Lookup[options,{Aliquot,AliquotAmount,AliquotContainer}],
			{True, 140.0 Microliter, {{1, ObjectReferenceP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}}},
			Variables :> {options},
			Messages:>{Warning::AliquotRequired}
		],
		Example[{Options,AliquotAmount, "The amount of each sample that should be transferred from the SamplesIn into the AliquotSamples which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], AliquotAmount -> 0.08 Milliliter, Output -> Options];
			Lookup[options, AliquotAmount],
			0.08 Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,AliquotSampleLabel, "Set name labels for aliquots taken from the input samples:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], Aliquot -> True, AliquotSampleLabel -> "Sample 1 aliquot", Output -> Options];
			Lookup[options, AliquotSampleLabel],
			{"Sample 1 aliquot"},
			Variables :> {options}
		],
		Example[{Options,AssayVolume, "The desired total volume of the aliquoted sample plus dilution buffer:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], AssayVolume -> 0.08 Milliliter, Output -> Options];
			Lookup[options, AssayVolume],
			0.08 Milliliter,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,TargetConcentration, "The desired final concentration of analyte in the AliquotSamples after dilution of aliquots of SamplesIn with the ConcentratedBuffer and BufferDiluent which should be used in lieu of the SamplesIn for the experiment:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], TargetConcentration -> 45 Micromolar, Output -> Options];
			Lookup[options, TargetConcentration],
			45 Micromolar,
			EquivalenceFunction -> Equal,
			Variables :> {options},
			Messages :>{Warning::AmbiguousAnalyte}
		],
		Example[{Options,TargetConcentrationAnalyte, "The analyte whose desired final concentration is specified:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], TargetConcentrationAnalyte->Model[Molecule, "Uracil"], TargetConcentration -> 45 Micromolar, Output -> Options];
			Lookup[options, TargetConcentrationAnalyte],
			ObjectP[Model[Molecule, "Uracil"]],
			Variables :> {options}
		],
		Example[{Options,ConcentratedBuffer, "The concentrated buffer which should be diluted by the BufferDilutionFactor with the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 100 Microliter, AliquotAmount -> 20 Microliter, Output -> Options];
			Lookup[options, ConcentratedBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options,BufferDilutionFactor, "The dilution factor by which the concentrated buffer should be diluted by the BufferDiluent; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 100 Microliter, AliquotAmount -> 20 Microliter, Output -> Options];
			Lookup[options, BufferDilutionFactor],
			10,
			EquivalenceFunction -> Equal,
			Variables :> {options}
		],
		Example[{Options,BufferDiluent, "The buffer used to dilute the concentration of the ConcentratedBuffer by BufferDilutionFactor; the diluted version of the ConcentratedBuffer will then be added to any aliquot samples that require dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], BufferDiluent -> Model[Sample, "Milli-Q water"], BufferDilutionFactor -> 10, ConcentratedBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 100 Microliter, AliquotAmount -> 20 Microliter, Output -> Options];
			Lookup[options, BufferDiluent],
			ObjectP[Model[Sample, "Milli-Q water"]],
			Variables :> {options}
		],
		Example[{Options,AssayBuffer, "The buffer that should be added to any aliquots requiring dilution, where the volume of this buffer added is the difference between the AliquotAmount and the total AssayVolume:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], AssayBuffer -> Model[Sample, StockSolution, "10x UV buffer"], AssayVolume -> 100 Microliter, AliquotAmount -> 20 Microliter, Output -> Options];
			Lookup[options, AssayBuffer],
			ObjectP[Model[Sample, StockSolution, "10x UV buffer"]],
			Variables :> {options}
		],
		Example[{Options,AliquotSampleStorageCondition, "The non-default conditions under which any aliquot samples generated by this experiment should be stored after the protocol is completed:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], AliquotSampleStorageCondition -> Refrigerator, Output -> Options];
			Lookup[options, AliquotSampleStorageCondition],
			Refrigerator,
			Variables :> {options}
		],
		Example[{Options,ConsolidateAliquots, "Indicates if identical aliquots should be prepared in the same container/position:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], Aliquot->True, ConsolidateAliquots -> True, Output -> Options];
			Lookup[options, ConsolidateAliquots],
			True,
			Variables :> {options}
		],
		Example[{Options,AliquotPreparation, "Indicates the desired scale at which liquid handling used to generate aliquots will occur:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], Aliquot->True, AliquotPreparation -> Manual, Output -> Options];
			Lookup[options, AliquotPreparation],
			Manual,
			Variables :> {options}
		],
		Example[{Options,AliquotContainer, "The desired type of container that should be used to prepare and house the aliquot samples, with indices indicating grouping of samples in the same plates, if desired:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], AliquotContainer -> Model[Container,Plate,"96-well 2mL Deep Well Plate"], Output -> Options];
			Lookup[options, AliquotContainer],
			{{1, ObjectP[Model[Container, Plate, "96-well 2mL Deep Well Plate"]]}},
			Variables :> {options}
		],
		Example[{Options,DestinationWell, "Indicates how the desired position in the corresponding AliquotContainer in which the aliquot samples will be placed:"},
			options = ExperimentHPLC[Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], DestinationWell -> "A1", Output -> Options];
			Lookup[options,DestinationWell],
			{"A1"},
			Variables:>{options}
		],

		(* === Shared Options - Storage Condition === *)
		Example[
			{Options,SamplesOutStorageCondition,"Specify the storage condition for any generated fraction samples:"},
			Download[ExperimentHPLC[storageConditionSamples,CollectFractions -> True,SamplesOutStorageCondition -> Refrigerator],
				SamplesOutStorage
			],
			{Refrigerator..},
			SetUp:>(
				$CreatedObjects = {};

				plates = Upload[{
					Association[
						Type -> Object[Container,Plate],
						Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],
						Site -> Link[$Site]
					],
					Association[
						Type -> Object[Container,Plate],
						Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],
						Site -> Link[$Site]
					]
				}];
				storageConditionSamples = UploadSample[
					{Model[Sample,StockSolution,Standard,"Small Molecule HPLC Standard Mix"],Model[Sample,StockSolution,Standard,"Small Molecule HPLC Standard Mix"],Model[Sample,StockSolution,Standard,"Small Molecule HPLC Standard Mix"]},
					{{"A1",plates[[1]]},{"A1",plates[[2]]},{"A2",plates[[2]]}},
					InitialAmount -> 500 Microliter,
					StorageCondition -> {AmbientStorage,Refrigerator,Refrigerator}
				];
			),
			TearDown:>(EraseObject[$CreatedObjects,Force->True]),
			Variables:>{storageConditionSamples,plates}
		],
		Example[
			{Options,SamplesInStorageCondition,"Specify the storage condition for the SamplesIn:"},
			Download[ExperimentHPLC[storageConditionSamples, SamplesInStorageCondition -> Freezer],
				SamplesInStorage
			],
			{Freezer..},
			SetUp:>(
				$CreatedObjects = {};

				plates = Upload[{
					Association[
						Type -> Object[Container,Plate],
						Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],
						Site -> Link[$Site]
					],
					Association[
						Type -> Object[Container,Plate],
						Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],
						Site -> Link[$Site]
					]
				}];
				storageConditionSamples = UploadSample[
					{Model[Sample,StockSolution,Standard,"Small Molecule HPLC Standard Mix"],Model[Sample,StockSolution,Standard,"Small Molecule HPLC Standard Mix"],Model[Sample,StockSolution,Standard,"Small Molecule HPLC Standard Mix"]},
					{{"A1",plates[[1]]},{"A1",plates[[2]]},{"A2",plates[[2]]}},
					InitialAmount -> 500 Microliter,
					StorageCondition -> {AmbientStorage,Refrigerator,Refrigerator}
				];
			),
			TearDown:>(EraseObject[$CreatedObjects,Force->True]),
			Variables:>{storageConditionSamples,plates}
		],
		Example[{Options,SamplesInStorageCondition,"If two samples are in the same container but have different storage conditions, throw an error:"},
			ExperimentHPLC[storageConditionSamples, SamplesInStorageCondition -> {Freezer, Refrigerator, Freezer}],
			$Failed,
			Messages :> {Error::SharedContainerStorageCondition, Error::InvalidOption},
			SetUp:>(
				$CreatedObjects = {};

				plates = Upload[{
					Association[
						Type -> Object[Container,Plate],
						Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],
						Site -> Link[$Site]
					],
					Association[
						Type -> Object[Container,Plate],
						Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],
						Site -> Link[$Site]
					]
				}];
				storageConditionSamples = UploadSample[
					{Model[Sample,StockSolution,Standard,"Small Molecule HPLC Standard Mix"],Model[Sample,StockSolution,Standard,"Small Molecule HPLC Standard Mix"],Model[Sample,StockSolution,Standard,"Small Molecule HPLC Standard Mix"]},
					{{"A1",plates[[1]]},{"A1",plates[[2]]},{"A2",plates[[2]]}},
					InitialAmount -> 500 Microliter,
					StorageCondition -> {AmbientStorage,Refrigerator,Refrigerator}
				];
			),
			TearDown:>(EraseObject[$CreatedObjects,Force->True]),
			Variables:>{storageConditionSamples,plates}
		],

		(* === Shared Options - PreparatoryUnitOperations === *)
		Example[{Options, {PreparedModelContainer, PreparedModelAmount}, "Use the PreparatoryUnitOperations option to prepare samples from models before the experiment is run:"},
			options = ExperimentHPLC[
				(* 20 mg/l Caffeine Standard Solution for HPLC System Qualification *)
				{Model[Sample, "id:L8kPEjn8pBbG"], Model[Sample, "id:L8kPEjn8pBbG"]},
				PreparedModelAmount -> 1 Milliliter,
				(* 96-well 2mL Deep Well Plate *)
				PreparedModelContainer -> Model[Container, Plate, "id:L8kPEjkmLbvW"],
				Output -> Options
			];
			prepUOs = Lookup[options, PreparatoryUnitOperations];
			{
				prepUOs[[-1, 1]][Sample],
				prepUOs[[-1, 1]][Container],
				prepUOs[[-1, 1]][Amount],
				prepUOs[[-1, 1]][Well],
				prepUOs[[-1, 1]][ContainerLabel]
			},
			{
				(* 20 mg/l Caffeine Standard Solution for HPLC System Qualification *)
				{ObjectP[Model[Sample, "id:L8kPEjn8pBbG"]]..},
				(* 96-well 2mL Deep Well Plate *)
				{ObjectP[Model[Container, Plate, "id:L8kPEjkmLbvW"]]..},
				{EqualP[1 Milliliter]..},
				{"A1", "B1"},
				{_String, _String}
			},
			Variables :> {options, prepUOs}
		],
		Example[{Options, PreparedModelAmount, "If using model input, the sample preparation options can also be specified:"},
			ExperimentHPLC[
				Model[Sample, "Caffeine"],
				PreparedModelAmount -> 5 Milligram,
				MixType -> Vortex, IncubationTime -> 10 Minute,
				AssayBuffer -> Model[Sample, "Milli-Q water"]
			],
			ObjectP[Object[Protocol, HPLC]]
		],
		Example[
			{Options,PreparatoryUnitOperations,"Describe the preparation of a buffer before using it in an HPLC protocol:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				BufferA -> "My Buffer",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My Buffer Container",
						Container -> Model[Container,Vessel,"Amber Glass Bottle 4 L"]
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> "My Buffer Container",
						Amount -> 1999 Milliliter
					],
					Transfer[
						Source -> Model[Sample, "Heptafluorobutyric acid"],
						Destination -> "My Buffer Container",
						Amount -> 1 Milliliter
					],
					LabelSample[
						Label -> "My Buffer",
						Sample -> {"A1", "My Buffer Container"}
					]
				}
			],
			ObjectP[Object[Protocol,HPLC]],
			Messages :> {Warning::RoundedTransferAmount},
			TimeConstraint -> 3000
		],
		Example[{Options,InjectionSampleVolumeMeasurement,"InjectionSampleVolumeMeasurement can be set to True when volume measurements of the prepared samples are desired before the HPLC run is started:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				BufferA -> "My Buffer",
				PreparatoryUnitOperations -> {
					LabelContainer[
						Label -> "My Buffer Container",
						Container -> Model[Container,Vessel,"Amber Glass Bottle 4 L"]
					],
					Transfer[
						Source -> Model[Sample, "Milli-Q water"],
						Destination -> "My Buffer Container",
						Amount -> 1999 Milliliter
					],
					Transfer[
						Source -> Model[Sample, "Heptafluorobutyric acid"],
						Destination -> "My Buffer Container",
						Amount -> 1 Milliliter
					],
					LabelSample[
						Label -> "My Buffer",
						Sample -> {"A1", "My Buffer Container"}
					]
				},
				InjectionSampleVolumeMeasurement -> True
			],
			ObjectP[Object[Protocol,HPLC]],
			Messages :> {Warning::RoundedTransferAmount},
			TimeConstraint -> 3000
		],


		(* === Messages - General Error Messages === *)
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (name form):"},
			ExperimentHPLC[Object[Sample, "Nonexistent sample"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (name form):"},
			ExperimentHPLC[Object[Container, Vessel, "Nonexistent container"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a sample that does not exist (ID form):"},
			ExperimentHPLC[Object[Sample, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages, "ObjectDoesNotExist", "Throw a message if we have a container that does not exist (ID form):"},
			ExperimentHPLC[Object[Container, Vessel, "id:12345678"]],
			$Failed,
			Messages :> {Download::ObjectDoesNotExist}
		],
		Example[{Messages,"DiscardedSamples","Error if input samples are discarded:"},
			ExperimentHPLC[discardedSample],
			$Failed,
			Messages:>{Error::DiscardedSamples,Error::InvalidInput},
			SetUp:>(
				$CreatedObjects = {};

				discardedSamplePlate = Upload[
					Association[
						Type -> Object[Container,Plate],
						Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],
						Site -> Link[$Site]
					]
				];

				discardedSample = UploadSample[
					Model[Sample, "20 mg/l Caffeine Standard Solution for HPLC System Qualification"],
					{"A1",discardedSamplePlate},
					InitialAmount -> 500 Microliter
				];

				UploadSampleStatus[discardedSample,Discarded,FastTrack->True];
			),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True];
			),
			Variables:>{discardedSample}
		],
		Example[{Messages,"ContainerlessSamples","Error if input samples are not in a container:"},
			ExperimentHPLC[containerlessSample],
			$Failed,
			Messages:>{Error::ContainerlessSamples,Error::InvalidInput},
			SetUp:>(
				$CreatedObjects = {};
				containerlessSample = Upload[
					Association[
						Type -> Object[Sample],
						Model -> Link[Model[Sample, "Milli-Q water"],Objects],
						Volume -> 100 Microliter
					]
				];
			),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True];
			),
			Variables:>{containerlessSamples}
		],
		Example[{Messages,"DuplicateName","Error if specified Name already exists:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Name -> "My special HPLC New protocol name" <> $SessionUUID
			],
			$Failed,
			Messages:>{Error::DuplicateName,Error::InvalidOption}
		],
		Example[{Messages,"RetiredChromatographyInstrument","Error if specified Instrument is Retired:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument -> retiredInstrument
			],
			$Failed,
			Messages:>{Error::RetiredChromatographyInstrument,Error::InvalidOption},
			SetUp:>(
				$CreatedObjects = {};

				retiredInstrument = Upload[
					Association[
						Type -> Object[Instrument,HPLC],
						DeveloperObject -> True,
						Model -> Link[Model[Instrument,HPLC,"UltiMate 3000"],Objects]
					]
				];

				UploadInstrumentStatus[retiredInstrument,Retired,FastTrack->True];
			),
			TearDown:>(
				EraseObject[$CreatedObjects,Force->True];
			),
			Variables:>{retiredInstrument}
		],
		Example[{Messages,"DeprecatedInstrumentModel","Error if specified Instrument model is Deprecated:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument -> Model[Instrument,HPLC,"Prominence UFLC"]
			],
			$Failed,
			Messages:>{Error::DeprecatedInstrumentModel,Error::InvalidOption}
		],
		Example[{Messages,"SolidSamplesNotAllowed","Error if input samples are solid:"},
			ExperimentHPLC[Object[Sample,"Test invalid sample (solid sample) for ExperimentHPLC tests" <> $SessionUUID]],
			$Failed,
			Messages:>{Error::SolidSamplesUnsupported,Error::InvalidInput}
		],
		Example[{Messages,"HPLCTooManySamples","Error if the number of samples and/or aliquots are in too many containers and cannot fit on the required instrument's autosampler:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 4 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 5 for ExperimentHPLC tests (high recovery vial)" <> $SessionUUID]},
				Aliquot->False,
				Instrument->Model[Instrument,HPLC,"Waters Acquity UPLC H-Class PDA"]
			],
			$Failed,
			Messages:>{Error::HPLCTooManySamples,Error::InvalidInput}
		],
		Example[{Messages,"ConflictingInjectionSampleVolumeMeasurementOption","Warning will be thrown if InjectionSampleVolumeMeasurement is specified True but there are no PreparatoryUnitOperations used:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				InjectionSampleVolumeMeasurement -> True
			],
			ObjectP[Object[Protocol,HPLC]],
			Messages:>{Warning::ConflictingInjectionSampleVolumeMeasurementOption}
		],
		Example[
			{Messages,"SamplesOutStorageConditionRequired","Error if samples for which fractions are being collected have distinct storage conditions and SamplesOutStorageCondition is not specified:"},
			ExperimentHPLC[
				storageConditionSamples,
				CollectFractions -> True
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::SamplesOutStorageConditionRequired},
			SetUp:>(
				$CreatedObjects = {};

				plates = Upload[{
					Association[
						Type -> Object[Container,Plate],
						Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],
						Site -> Link[$Site]
					],
					Association[
						Type -> Object[Container,Plate],
						Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],
						Site -> Link[$Site]
					]
				}];
				storageConditionSamples = UploadSample[
					{Model[Sample,StockSolution,Standard,"Small Molecule HPLC Standard Mix"],Model[Sample,StockSolution,Standard,"Small Molecule HPLC Standard Mix"],Model[Sample,StockSolution,Standard,"Small Molecule HPLC Standard Mix"]},
					{{"A1",plates[[1]]},{"A1",plates[[2]]},{"A2",plates[[2]]}},
					InitialAmount -> 500 Microliter,
					StorageCondition -> {AmbientStorage,Refrigerator,Refrigerator}
				];
			),
			TearDown:>(EraseObject[$CreatedObjects,Force->True]),
			Variables:>{storageConditionSamples,plates}
		],

		(* === Messages - Instrument === *)
		Example[{Messages,"InvalidHPLCAlternateInstruments","Not all the specified Instrument cannot fulfill the other experiment options (due to container count):"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 4 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 5 for ExperimentHPLC tests (high recovery vial)" <> $SessionUUID]},
				Aliquot -> False,
				(* {Model[Instrument, HPLC, "UltiMate 3000"], Model[Instrument, HPLC, "Waters Acquity UPLC H-Class PDA"]} *)
				Instrument -> {Model[Instrument, HPLC, "id:N80DNjlYwwJq"], Model[Instrument, HPLC, "id:Z1lqpMGJmR0O"]}
			],
			$Failed,
			Messages:>{Error::InvalidHPLCAlternateInstruments,Error::InvalidOption}
		],
		Example[{Messages,"InvalidHPLCAlternateInstruments","The specified Instrument cannot provide enough space for column and the column cannot be placed outside:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Column -> Model[Item, Column, "Test over-sized column model for ExperimentHPLC" <> $SessionUUID],
				Instrument -> {Model[Instrument, HPLC, "UltiMate 3000"], Model[Instrument, HPLC, "Waters Acquity UPLC H-Class FLR"]}
			],
			$Failed,
			Messages:>{Error::InvalidHPLCAlternateInstruments,Error::InvalidOption}
		],
		Example[{Messages,"ScaleInstrumentConflict","The specified scale and Instrument are incompatible:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Scale -> SemiPreparative,
				InjectionVolume -> 10 Microliter,
				Instrument -> Model[Instrument,HPLC,"Waters Acquity UPLC H-Class PDA"]
			],
			$Failed,
			Messages:>{Error::ScaleInstrumentConflict,Error::InvalidOption}
		],
		Example[{Messages,"HPLCInstrumentScaleConflict","Error if the specified Instrument option has mixed instrument models including Agilent models and non-Agilent models (cannot be supported due to different container requirement):"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID]},
				Instrument -> {Model[Instrument, HPLC, "Agilent 1290 Infinity II LC System"], Model[Instrument, HPLC, "UltiMate 3000"]}
			],
			$Failed,
			Messages:>{Error::HPLCInstrumentScaleConflict,Error::InvalidHPLCAlternateInstruments,Error::InvalidOption}
		],
		Example[{Messages,"MissingHPLCScaleInstrument","Error if the Preparative scale instrument is requested but not in the specified Instrument option:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				InjectionVolume -> 10 Microliter,
				Scale -> Preparative,
				Instrument -> Model[Instrument, HPLC, "UltiMate 3000"]
			],
			$Failed,
			Messages:>{Warning::InsufficientSampleVolume,Error::MissingHPLCScaleInstrument,Error::ScaleInstrumentConflict,Error::InvalidOption}
		],
		Example[{Messages,"SampleTemperatureConflict","Error if SampleTemperature is specified and fraction collection parameters are set when the only instrument supporting autosampler incubation does not support fraction collection:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				SampleTemperature -> 40 Celsius,
				CollectFractions -> True,
				Aliquot -> False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::SampleTemperatureConflict}
		],
		Example[{Messages,"UnsupportedSampleTemperature","Error if SampleTemperature is specified while the specified Instrument does not support autosampler incubation:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument -> Model[Instrument,HPLC,"UltiMate 3000"],	SampleTemperature -> 15 Celsius	],
			$Failed,
			Messages:>{Error::UnsupportedSampleTemperature,Error::InvalidOption}
		],
		Example[{Messages,"UnsupportedBufferD","Error if BufferD is specified while the specified Instrument does not support a four buffer system:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument -> Model[Instrument,HPLC,"UltiMate 3000"],
				BufferD -> Model[Sample,"Acetonitrile, HPLC Grade"]
			],
			$Failed,
			Messages:>{Error::UnsupportedBufferD,Error::InvalidOption}
		],
		Example[{Messages,"UnsupportedGradientD","Error if a gradient specifies the usage of BufferD while the specified Instrument does not support a four buffer system:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument -> Model[Instrument,HPLC,"UltiMate 3000"],
				GradientA -> 10 Percent,
				GradientD -> 90 Percent
			],
			$Failed,
			Messages:>{
				Error::UnsupportedGradientD,
				Warning::HPLCGradientNotReequilibrated,
				Error::InvalidOption
			}
		],
		Example[{Messages,"BufferDMustExistForInstrument","Error if BufferD is set to Null and the specified Instrument requires a BufferD:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument -> Model[Instrument,HPLC,"Waters Acquity UPLC H-Class PDA"],
				BufferD -> Null
			],
			$Failed,
			Messages:>{
				Error::BufferDMustExistForInstrument,
				Error::InvalidOption
			}
		],
		Example[{Messages,"BufferDMustExistForSampleTemperature","Error if BufferD is set to Null while SampleTemperature is specified, requiring an instrument that needs BufferD:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				SampleTemperature -> 40 Celsius,
				BufferD -> Null
			],
			$Failed,
			Messages:>{Error::BufferDMustExistForSampleTemperature,Error::InvalidOption}
		],
		Example[{Messages,"BufferDMustExistForGradient","Error if BufferD is set to Null while Gradient specification includes BufferD:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				GradientA -> 10 Percent,
				GradientD -> 90 Percent,
				BufferD -> Null
			],
			$Failed,
			Messages:>{
				Error::BufferDMustExistForGradient,
				Warning::HPLCGradientNotReequilibrated,
				Error::InvalidOption
			}
		],
		Example[{Messages,"IncompatibleInstrumentBufferD","Error if BufferD is specified but fraction collection is also desired:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				BufferD -> Model[Sample,"Milli-Q water"],
				CollectFractions -> True,
				Aliquot -> False
			],
			$Failed,
			Messages:>{
				Error::IncompatibleInstrumentBufferD,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NoSuitableInstrumentForDetection","The specified items in Detector must have a capable instrument available:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Detector -> {UVVis,Fluorescence,EvaporativeLightScattering,PhotoDiodeArray}
			],
			$Failed,
			Messages:>{Error::NoSuitableInstrumentForDetection,Error::InvalidOption}
		],
		Example[{Messages,"ColumnSelectorInstrumentConflict","The specified number of column sets in ColumnSelector option is not compatible with the required instrument supporting all other parameters:"},
			ExperimentHPLC[
				{Object[Sample, "Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID], Object[Sample, "Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID]},
				ColumnPosition -> {PositionA, PositionB},
				ColumnSelector -> {
					{PositionA, Null, Null, Model[Item, Column, "id:o1k9jAKOw6d7"], Forward, Null, Null},
					{PositionB, Null, Null, Model[Item, Column, "id:dORYzZn0obYE"], Forward, Null, Null}
				},
				GradientA -> 10 Percent,
				GradientB -> 20 Percent,
				GradientD -> 70 Percent
			],
			$Failed,
			Messages:>{Error::ColumnSelectorInstrumentConflict,
				Warning::HPLCGradientNotReequilibrated,
				Warning::AliquotRequired,Error::InvalidOption}
		],

		Example[{Messages,"NonSupportedHPLCInstrument","Error if I-Class HPLC is required:"},
			ExperimentHPLC[
				Object[Sample, "Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument -> Model[Instrument, HPLC, "Waters Acquity UPLC I-Class PDA"]
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::NonSupportedHPLCInstrument}
		],
		Example[{Messages,"NoSuitableHPLCInstrument","Error if there is no HPLC instrument for the specified options:"},
			ExperimentHPLC[
				Object[Sample, "Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				InjectionVolume -> 300 Microliter,
				BufferD -> Model[Sample, "Milli-Q water"],
				GradientB -> 20 Percent,
				GradientD -> 30 Percent
			],
			$Failed,
			Messages:>{Error::InvalidOption,Warning::HPLCGradientNotReequilibrated,Error::NoSuitableHPLCInstrument}
		],
		Example[{Messages,"InvalidHPLCMaxAcceleration","If the specified MaxAcceleration is greater than the required instrument or column's MaxAcceleration, throw an error:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument -> Model[Instrument, HPLC, "id:Z1lqpMGJmR0O"],
				MaxAcceleration -> 300 Milliliter/Minute/Minute
			],
			$Failed,
			Messages:>{Error::InvalidHPLCMaxAcceleration,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleNeedleWash","Error if NeedleWash and BufferC are specified as different reagents for a Dionex instrument:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument->Model[Instrument, HPLC, "UltiMate 3000 with FLR Detector"],
				NeedleWashSolution->Model[Sample, "Milli-Q water"],
				BufferC->Model[Sample, "Acetonitrile, HPLC Grade"]
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::IncompatibleNeedleWash}
		],
		Example[{Messages,"IncompatibleContainerAndNeedleWashBuffer","Error if NeedleWash and BufferC are specified as different reagents but the containers cannot fit on a Waters instrument:"},
			ExperimentHPLC[
				{
					Object[Container, Plate, "Test plate 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container, Plate, "Plate for sample 4 ExperimentHPLC tests" <> $SessionUUID],
					Object[Container, Vessel, "Test high-recovery container for ExperimentHPLC tests" <> $SessionUUID]
				},
				Aliquot -> False,
				NeedleWashSolution -> Model[Sample, "Milli-Q water"],
				BufferC -> Model[Sample, "Acetonitrile, HPLC Grade"]
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::IncompatibleContainerAndNeedleWashBuffer}
		],
		Example[{Messages,"IncompatibleFractionCollectionAndNeedleWashBuffer","Error if NeedleWash and BufferC are specified as different reagents but fraction collection is desired:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				NeedleWashSolution -> Model[Sample, "Milli-Q water"],
				BufferC -> Model[Sample, "Acetonitrile, HPLC Grade"],
				CollectFractions -> True,
				Aliquot -> False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::IncompatibleFractionCollectionAndNeedleWashBuffer}
		],
		Example[
			{Messages,"IncompatibleFlowRate","If the resolved FlowRate is greater than the resolved instrument's compatible flow rate, throw error:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				FlowRate -> 8 Milliliter/Minute,
				Detector -> pH,
				Upload->False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::IncompatibleFlowRate,Error::IncompatibleColumnPrimeFlowRate,Error::IncompatibleColumnFlushFlowRate}
		],
		Example[
			{Messages,"IncompatibleStandardFlowRate","If the resolved StandardFlowRate is greater than the resolved instrument's compatible flow rate, throw error:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				StandardFlowRate -> 8 Milliliter/Minute,
				Detector -> pH,
				Upload->False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::IncompatibleStandardFlowRate}
		],
		Example[
			{Messages,"IncompatibleBlankFlowRate","If the resolved BlankFlowRate is greater than the resolved instrument's compatible flow rate, throw error:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				BlankFlowRate -> 8 Milliliter/Minute,
				Detector -> pH,
				Upload->False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::IncompatibleBlankFlowRate}
		],
		Example[
			{Messages,"IncompatibleColumnPrimeFlowRate","If the resolved ColumnPrimeFlowRate is greater than the resolved instrument's compatible flow rate, throw error:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				ColumnPrimeFlowRate -> 8 Milliliter/Minute,
				Detector -> pH,
				Upload->False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::IncompatibleColumnPrimeFlowRate}
		],
		Example[
			{Messages,"IncompatibleColumnFlushFlowRate","If the resolved ColumnFlushFlowRate is greater than the resolved instrument's compatible flow rate, throw error:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				ColumnFlushFlowRate -> 8 Milliliter/Minute,
				Detector -> pH,
				Upload->False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::IncompatibleColumnFlushFlowRate}
		],

		(* === Messages - Standard/Blank/ColumnSelector General Conflict === *)
		Example[
			{Messages,"StandardOptionsButNoStandard","If Standard is Null, other Standard options should not be specified:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Standard->Null,
				StandardInjectionVolume->50Microliter
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::StandardOptionsButNoStandard}
		],
		Example[
			{Messages,"BlankOptionsButNoBlank","If Blank is Null, other Blank options should not be specified:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Blank->Null,
				BlankInjectionVolume->50Microliter
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::BlankOptionsButNoBlank}
		],
		Example[
			{Messages,"ColumnOptionsButNoColumn","If ColumnSelector is Null, other Column options should not be specified:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Column->Null,
				ColumnPrimeGradientA->30 Percent
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::ColumnOptionsButNoColumn}
		],
		Example[{Messages,"HPLCConflictingFractionCollectionOptions","When the FractionCollectionMode is Time, other options (e.g. AbsoluteThreshold) must be Null:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				FractionCollectionMode->Time,
				AbsoluteThreshold -> 0 Milli AbsorbanceUnit
			],
			$Failed,
			Messages:>{
				Error::HPLCConflictingFractionCollectionOptions,
				Error::InvalidOption
			}
		],
		Example[{Messages,"NotApplicableHPLCPeakFractionCollectionOptions","PeakSlopeDuration and PeakEndSlope fraction collection options are only supported on the UltiMate 3000 HPLC instruments:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],
				Instrument->Model[Instrument, HPLC, "Agilent 1290 Infinity II LC System"],
				PeakSlopeDuration->2Second
			],
			$Failed,
			Messages:>{Error::NotApplicableHPLCPeakFractionCollectionOptions,Error::InvalidOption}
		],
		Example[
			{Messages,"StandardFrequencyNoStandards","StandardFrequency must be Automatic, Null, or None when there are no Standard samples:"},
			(
				ExperimentHPLC[{
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]
				},
					Standard->Null,
					StandardFrequency->FirstAndLast
				]
			),
			$Failed,
			Messages:>{
				Error::StandardFrequencyNoStandards,
				Error::StandardOptionsButNoStandard,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"StandardsButNoFrequency","StandardFrequency must not be None or Infinity when there are Standard samples:"},
			(
				ExperimentHPLC[{
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]
				},
					Standard->Model[Sample,"Milli-Q water"],
					StandardFrequency->None
				]
			),
			$Failed,
			Messages:>{
				Error::StandardsButNoFrequency,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"StandardOptionsButNoFrequency","StandardFrequency must not be None or Infinity when there are Standard samples:"},
			(
				ExperimentHPLC[{
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]
				},
					StandardInjectionVolume->100Microliter,
					StandardFrequency->None
				]
			),
			$Failed,
			Messages:>{
				Error::StandardOptionsButNoFrequency,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"BlankFrequencyNoBlanks","BlankFrequency must be Automatic, Null, or None when there are no Blank samples:"},
			(
				ExperimentHPLC[{
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]
				},
					Blank->Null,
					BlankFrequency->FirstAndLast
				]
			),
			$Failed,
			Messages:>{
				Error::BlankFrequencyNoBlanks,
				Error::BlankOptionsButNoBlank,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"BlanksButNoFrequency","BlankFrequency must not be None or Infinity when there are Blank samples:"},
			(
				ExperimentHPLC[{
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]
				},
					Blank->Model[Sample,"Milli-Q water"],
					BlankFrequency->None
				]
			),
			$Failed,
			Messages:>{
				Error::BlanksButNoFrequency,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"BlankOptionsButNoFrequency","BlankFrequency must not be None or Infinity when there are Blank samples:"},
			(
				ExperimentHPLC[{
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]
				},
					BlankInjectionVolume->50Microliter,
					BlankFrequency->None
				]
			),
			$Failed,
			Messages:>{
				Error::BlankOptionsButNoFrequency,
				Error::InvalidOption
			}
		],

		(* === Messages - Fraction Collection === *)
		Example[
			{Messages,"InvalidFractionCollectionEndTime","If FractionCollectionEndTime is greater than the gradient time, an error is thrown:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				FractionCollectionEndTime -> {30 Minute, 30 Minute, 120 Minute}
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::InvalidFractionCollectionEndTime}
		],
		Example[{Messages, "ConflictScaleAndCollectFractions", "If Scale->Analytical and CollectionFractions->True, throw an error:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				CollectFractions -> True,
				Scale -> Analytical
			],
			$Failed,
			Messages :> {Error::ConflictScaleAndCollectFractions,Error::InvalidOption}
		],
		Example[{Messages,"ConflictFractionOptionSpecification","If the resolution leads to no fraction collection, but fraction collection options were specified, a warning is thrown:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				CollectFractions -> False,
				AbsoluteThreshold -> 50 Milli AbsorbanceUnit
			],
			ObjectP[Object[Protocol,HPLC]],
			Messages:>{Warning::ConflictFractionOptionSpecification}
		],
		Example[{Messages,"ConflictingFractionCollectionMethodOptions","When the FractionCollectionMethod is specified, other fraction collection options should be in accordance with the method:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				FractionCollectionMethod->Object[Method, FractionCollection, "id:WNa4ZjRDxam8"],
				FractionCollectionMode->Time,
				AbsoluteThreshold -> 0 Milli AbsorbanceUnit
			],
			$Failed,
			Messages:>{
				Error::ConflictingFractionCollectionMethodOptions,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"InvalidFractionCollectionContainer","Error if the specified fraction container is not supported by any instrument:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				FractionCollectionContainer->Model[Container, Vessel, "2mL Tube"]
			],
			$Failed,
			Messages:>{Error::InvalidFractionCollectionContainer,Error::InvalidOption}
		],
		Example[
			{Messages,"InvalidFractionCollectionContainer","Error if the specified fraction container is not supported by the specified instrument:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Instrument->Model[Instrument, HPLC, "UltiMate 3000"],
				FractionCollectionContainer->Model[Container, Vessel, "50mL Tube"]
			],
			$Failed,
			Messages:>{Error::InvalidFractionCollectionContainer,Error::InvalidOption}
		],

		(* === Messages - Column Errors/Warnings === *)
		Example[{Messages,"ColumnSelectorConflict","Error if the specified ColumnSelector does not match other column options:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Column -> Model[Item,Column,"id:1ZA60vwjbRla"],
				ColumnSelector -> {PositionA,Null,Forward,Model[Item,Column,"id:dORYzZn0obYE"],Forward,Model[Item,Column,"id:o1k9jAKOw6d7"],Null}
			],
			$Failed,
			Messages:>{Error::ColumnSelectorConflict,Error::InvalidOption}
		],
		Example[{Messages,"ColumnGap","Error if the specified columns are not connected together in the ColumnSelector option:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				ColumnSelector -> {PositionA,Null,Forward,Model[Item,Column,"id:dORYzZn0obYE"],Forward,Null,Model[Item,Column,"id:o1k9jAKOw6d7"]}
			],
			$Failed,
			Messages:>{Error::ColumnGap,Error::InvalidOption}
		],
		Example[{Messages,"ColumnGap","Error if the specified columns are not connected together in the column related option:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Column -> Model[Item,Column,"id:dORYzZn0obYE"],
				SecondaryColumn -> Null,
				TertiaryColumn -> Model[Item,Column,"id:o1k9jAKOw6d7"]
			],
			$Failed,
			Messages:>{Error::ColumnGap,Error::InvalidOption}
		],
		Example[{Messages,"ColumnOrientationSelector","Error if the specified ColumnOrientation does not match ColumnOrientation in ColumnSelector:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				ColumnSelector -> {PositionA,Null,Forward,Model[Item,Column,"id:dORYzZn0obYE"],Forward,Null,Null},
				ColumnOrientation->Reverse
			],
			$Failed,
			Messages:>{Error::ColumnOrientationSelector,Error::InvalidOption}
		],
		Example[{Messages,"GuardColumnSelector","Error if the specified ColumnSelector is Deprecated:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				GuardColumn -> Model[Item,Cartridge,Column,"Test model cartridge for ExperimentHPLC" <> $SessionUUID],
				ColumnSelector -> {PositionA,Null,Forward,Model[Item,Column,"id:dORYzZn0obYE"],Forward,Model[Item,Column,"id:o1k9jAKOw6d7"],Null}
			],
			$Failed,
			Messages:>{Error::GuardColumnSelector,Error::InvalidOption}
		],
		Example[{Messages,"ColumnPositionColumnConflict","Error if the specified ColumnPosition options require more sets of column assemblies that specified in the Column and ColumnSelector options:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnSelector -> {
					{PositionA,Null,Null,Model[Item,Column,"id:o1k9jAKOw6d7"],Forward,Null,Null}
				},
				ColumnPosition -> {PositionA, PositionB}
			],
			$Failed,
			Messages:>{Error::ColumnPositionColumnConflict,Error::InvalidOption}
		],
		Example[{Messages,"DuplicateColumnSelectorPositions","Error if the specified ColumnSelector options has duplicated Column Positions:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				ColumnSelector -> {
					{PositionA,Null,Forward,Model[Item,Column,"id:dORYzZn0obYE"],Forward,Null,Null},
					{PositionA,Null,Forward,Model[Item,Column,"id:dORYzZn0obYE"],Forward,Null,Null}
				}
			],
			$Failed,
			Messages:>{Error::DuplicateColumnSelectorPositions,Warning::AliquotRequired,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleColumnType","If multiple columns are specified, a warning is thrown if any specified Column's SeparationMode does not match the specified Type:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				SeparationMode -> SizeExclusion,
				Column -> Model[Item,Column,"id:o1k9jAKOw6d7"],
				SecondaryColumn -> Model[Item, Column, "id:qdkmxzq7GA9V"]
			],
			ObjectP[Object[Protocol,HPLC]],
			Messages:>{Warning::IncompatibleColumnType,Warning::VariableColumnTypes}
		],
		Example[{Messages,"IncompatibleColumnType","Warning is thrown if specified Column's SeparationMode does not match the specified SeparationMode:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				SeparationMode -> ReversePhase,
				Column -> Model[Item,Column,"DNAPac PA200 4x250mm Column"]
			],
			ObjectP[Object[Protocol,HPLC]],
			Messages:>{Warning::IncompatibleColumnType}
		],
		Example[{Messages,"IncompatibleColumnType","Warning is thrown if specified GuardColumn's SeparationMode does not match the specified SeparationMode:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				SeparationMode -> IonExchange,
				Column -> Model[Item,Column,"DNAPac PA200 4x250mm Column"],
				GuardColumn -> Model[Item,Column,"SecurityGuard Guard Cartridge Kit"]
			],
			ObjectP[Object[Protocol,HPLC]],
			Messages:>{Warning::IncompatibleColumnType}
		],
		Example[
			{Messages,"RedundantGuardColumn","Error is thrown if primary column is already a guard column but guard column is also specified:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Column -> Model[Item, Column, "id:1ZA60vzvMob8"],(*"InfinityLab Poroshell HPH-C18, 3.0 mm, 2.7 µm, UHPLC guard"*)
				GuardColumn -> Model[Item, Column, "id:1ZA60vzvMob8"],
				FlowRate -> 0.2 Milliliter/Minute
			],
			$Failed,
			Messages:>{Error::RedundantGuardColumn, Error::InvalidOption}
		],
		Example[
			{Messages,"VariableColumnTypes","If multiple columns are specified and SeparationMode resolves automatically, SeparationMode is resolved based on just the first column:"},
			Download[ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Column -> Model[Item,Column,"id:o1k9jAKOw6d7"],
				SecondaryColumn -> Model[Item, Column, "id:qdkmxzq7GA9V"]
			],SeparationMode],
			ReversePhase,
			Messages:>{Warning::VariableColumnTypes}
		],
		Example[{Messages,"IncompatibleColumnTechnique","If multiple columns are specified, a warning is thrown if any specified Column's ChromatographyType is not HPLC:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Column -> Model[Item,Column,"id:o1k9jAKOw6d7"],
				SecondaryColumn -> Model[Item,Column,"HiTrap 5x5mL Desalting Column"]
			],
			ObjectP[Object[Protocol,HPLC]],
			Messages:>{Warning::VariableColumnTypes,Warning::IncompatibleColumnTechnique}
		],
		Example[{Messages,"IncompatibleColumnTechnique","Warning is thrown if specified Column's ChromatographyType is not HPLC:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Column -> Model[Item,Column,"HiTrap 5x5mL Desalting Column"]
			],
			ObjectP[Object[Protocol,HPLC]],
			Messages:>{Warning::IncompatibleColumnTechnique}
		],
		Example[{Messages,"IncompatibleColumnTemperature","A warning is thrown if the specified column temperature is outside any specified Column's compatible temperature range:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Column -> Model[Item,Column,"id:7X104vnnLxZZ"],
				ColumnTemperature->80Celsius
			],
			ObjectP[Object[Protocol,HPLC]],
			Messages:>{Warning::IncompatibleColumnTemperature}
		],
		Example[{Messages,"IncompatibleColumnTemperature","If multiple columns are specified, a warning is thrown if the specified column temperature is outside any specified Column's compatible temperature range:"},
			(
				customInjectionTable={
					{ColumnPrime, Null, Automatic, Automatic, Ambient, Automatic},
					{Sample, Object[Sample, "Test Sample 1 for ExperimentHPLC tests"<>$SessionUUID], Automatic, Automatic, 80 Celsius, Automatic},
					{ColumnFlush, Null, Automatic, Automatic, Ambient, Automatic}
				};

				ExperimentHPLC[
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					InjectionTable->customInjectionTable,
					Column -> Model[Item,Column,"id:o1k9jAKOw6d7"],
					SecondaryColumn -> Model[Item,Column,"id:7X104vnnLxZZ"]
				]
			),
			ObjectP[Object[Protocol,HPLC]],
			Messages:>{Warning::IncompatibleColumnTemperature}
		],
		Example[{Messages,"IncompatibleHPLCColumnTemperature","Error if the selected instrument is not available to meet the specified column temperature inside the column temperature options (or no instrument can meet the requirements):"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				ColumnTemperature->9Celsius,
				Instrument->Model[Instrument, HPLC, "id:1ZA60vw8X5eD"]
			],
			$Failed,
			Messages:>{Error::IncompatibleHPLCColumnTemperature,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleHPLCColumnTemperature","Error if the selected instrument is not available to meet the specified column temperature inside the InjectionTable (or no instrument can meet the requirements):"},
			(
				customInjectionTable={
					{ColumnPrime, Null, Automatic, Automatic, Ambient, Automatic},
					{Sample, Object[Sample, "Test Sample 1 for ExperimentHPLC tests"<>$SessionUUID], Automatic, Automatic, 9 Celsius, Automatic},
					{ColumnFlush, Null, Automatic, Automatic, Ambient, Automatic}
				};

				ExperimentHPLC[
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					InjectionTable->customInjectionTable,
					Instrument->Model[Instrument, HPLC, "id:1ZA60vw8X5eD"]
				]
			),
			$Failed,
			Variables:>{customInjectionTable},
			Messages:>{Error::IncompatibleHPLCColumnTemperature,Error::InvalidOption}
		],
		Example[{Messages,"IncompatibleHPLCColumnTemperature","Error if the selected instrument is not available to meet the specified column temperature from the specified gradient methods (or no instrument can meet the requirements):"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Gradient->Object[Method, Gradient, "Test High Temperature Gradient Method for ExperimentHPLC tests" <> $SessionUUID],
				Instrument->Model[Instrument, HPLC, "id:1ZA60vw8X5eD"]
			],
			$Failed,
			Messages:>{Error::IncompatibleHPLCColumnTemperature,Warning::HPLCGradientNotReequilibrated,Error::InvalidOption}
		],
		Example[{Messages,"ReverseMoreThanOneColumn","ColumnOrientation cannot be Reverse with more than two columns given:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Column -> Model[Item,Column,"id:dORYzZn0obYE"],
				SecondaryColumn -> Model[Item,Column,"id:o1k9jAKOw6d7"],
				ColumnOrientation -> Reverse
			],
			$Failed,
			Messages:>{Error::ReverseMoreThanOneColumn,Error::InvalidOption}
		],
		Example[{Messages,"HPLCColumnsCannotFit","Columns cannot be incuated when they cannot fit into the column oven compartment of the HPLC instrument:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Column -> Model[Item, Column, "Test over-sized column model for ExperimentHPLC" <> $SessionUUID],
				IncubateColumn->True
			],
			$Failed,
			Messages:>{Error::HPLCColumnsCannotFit,Error::InvalidOption}
		],
		Example[{Messages,"HPLCCannotIncubateColumn","IncubateColumn must be True in order to set ColumnTemperature for column incubation in the InjectionTable:"},
			customInjectionTable={
				{ColumnPrime, Null, Automatic, Automatic, Ambient, Automatic},
				{Sample, Object[Sample, "Test Sample 1 for ExperimentHPLC tests"<>$SessionUUID], Automatic, Automatic, 40 Celsius, Automatic},
				{ColumnFlush, Null, Automatic, Automatic, Ambient, Automatic}
			};
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				InjectionTable -> customInjectionTable,
				IncubateColumn -> False
			],
			$Failed,
			Variables:>{customInjectionTable},
			Messages:>{Error::HPLCCannotIncubateColumn,Error::InvalidOption}
		],
		Example[{Messages,"HPLCCannotIncubateColumnWaters","IncubateColumn must be True for Waters instrument:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				IncubateColumn -> False,
				Instrument->Model[Instrument,HPLC,"Waters Acquity UPLC H-Class PDA"]
			],
			$Failed,
			Messages:>{Error::HPLCCannotIncubateColumnWaters,Error::InvalidOption}
		],

		(* === Messages - Gradient === *)
		Example[{Messages,"InvalidGradientCompositionOptions","Error if a specified gradient's total buffer composition is greater than 100%:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				GradientA -> {{0 Minute, 10 Percent},{5 Minute,90 Percent}},
				GradientB -> {{0 Minute, 90 Percent},{5 Minute,20 Percent}}
			],
			$Failed,
			Messages:>{
				Error::InvalidOption,
				Error::InvalidGradientCompositionOptions
			}
		],
		Example[{Messages, "HPLCGradientNotReequilibrated", "If the gradient does not reequilibrate before the sample injection, the user is warned:"},
			protocol = ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Gradient -> {
					{0. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{5. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{30. Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{30.1 Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{35. Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None}
				}
			],
			ObjectP[Object[Protocol,HPLC]],
			Messages:>{
				Warning::HPLCGradientNotReequilibrated
			}
		],
		Example[{Messages, "RemovedExtraGradientEntries", "Duplicate times in the gradients will be removed but a warning will be thrown:"},
			protocol = ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Gradient -> {
					{0. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{5. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{30. Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{30. Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{30.1 Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{35. Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{35.1 Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{40. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None}
				}
			];
			Download[protocol, GradientA],
			{
				{
					{Quantity[0., "Minutes"], Quantity[100., "Percent"]},
					{Quantity[5., "Minutes"], Quantity[100., "Percent"]},
					{Quantity[30., "Minutes"], Quantity[0., "Percent"]},
					{Quantity[30.1, "Minutes"], Quantity[0., "Percent"]},
					{Quantity[35., "Minutes"], Quantity[0., "Percent"]},
					{Quantity[35.1, "Minutes"], Quantity[100., "Percent"]},
					{Quantity[40., "Minutes"], Quantity[100., "Percent"]}
				},
				{
					{Quantity[0., "Minutes"], Quantity[100., "Percent"]},
					{Quantity[5., "Minutes"], Quantity[100., "Percent"]},
					{Quantity[30., "Minutes"], Quantity[0., "Percent"]},
					{Quantity[30.1, "Minutes"], Quantity[0., "Percent"]},
					{Quantity[35., "Minutes"], Quantity[0., "Percent"]},
					{Quantity[35.1, "Minutes"], Quantity[100., "Percent"]},
					{Quantity[40., "Minutes"], Quantity[100., "Percent"]}
				},
				{
					{Quantity[0., "Minutes"], Quantity[100., "Percent"]},
					{Quantity[5., "Minutes"], Quantity[100., "Percent"]},
					{Quantity[30., "Minutes"], Quantity[0., "Percent"]},
					{Quantity[30.1, "Minutes"], Quantity[0., "Percent"]},
					{Quantity[35., "Minutes"], Quantity[0., "Percent"]},
					{Quantity[35.1, "Minutes"], Quantity[100., "Percent"]},
					{Quantity[40., "Minutes"], Quantity[100., "Percent"]}
				}
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal,
			Messages:>{
				Warning::RemovedExtraGradientEntries
			}
		],
		Example[{Messages,"OverwritingGradient", "If a value in a supplied gradient is overwritten, then a new gradient method should be made:"},
			protocol=ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Gradient->Object[Method, Gradient, "id:M8n3rxYAonm5"],
				FlowRate -> 2 Milliliter/Minute
			];
			typesGradients={Type, Gradient} /. Download[protocol, InjectionTable];
			downloadedITGradients=Download[Cases[typesGradients, {Sample, x_} :> x],Object];
			And[
				!MatchQ[downloadedITGradients,{ObjectP[Object[Method, Gradient, "id:M8n3rxYAonm5"]]..}],
				MatchQ[downloadedITGradients,{ObjectP[Object[Method, Gradient]]..}]
			],
			True,
			Variables:>{protocol,typesGradients,downloadedITGradients},
			Messages:>{Warning::OverwritingGradient}
		],
		Example[{Messages,"GradientSingleton","Return an error when the specified gradient only has one entry:"},
			ExperimentHPLC[
				Object[Sample, "Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Gradient -> {{5 Minute, 50 Percent, 50 Percent, 0 Percent, 0 Percent, 1 Milliliter/Minute, None}}
			],
			$Failed,
			Messages:>{Error::GradientSingleton,				Error::InvalidOption}
		],
		Example[{Messages, "GradientAmbiguity", "If Gradient is a table, then auxillary options lead to ambiguity:"},
			protocol = ExperimentHPLC[
				Object[Sample, "Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Gradient -> {
					{0. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{5. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{30. Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{30.1 Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{35. Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{35.1 Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{40. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None}
				},
				GradientB -> 50 Percent
			];
			Download[protocol, GradientA],
			{
				{
					{Quantity[0., "Minutes"], Quantity[100., "Percent"]},
					{Quantity[5., "Minutes"], Quantity[100., "Percent"]},
					{Quantity[30., "Minutes"], Quantity[0., "Percent"]},
					{Quantity[30.1, "Minutes"], Quantity[0., "Percent"]},
					{Quantity[35., "Minutes"], Quantity[0., "Percent"]},
					{Quantity[35.1, "Minutes"], Quantity[100., "Percent"]},
					{Quantity[40., "Minutes"], Quantity[100., "Percent"]}
				}
			},
			Variables :> {protocol},
			EquivalenceFunction -> Equal,
			Messages:>{
				Warning::GradientAmbiguity
			}
		],
		Example[{Messages, "GradientOutOfOrder", "If Gradient is a table, each entry must be ascending in time:"},
			ExperimentHPLC[
				Object[Sample, "Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Gradient -> {
					{0. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{5. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{30. Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{30.1 Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{25. Minute, 0. Percent, 100. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{35.1 Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None},
					{40. Minute, 100. Percent, 0. Percent, 0. Percent, 0. Percent, 1 Milliliter/Minute, None}
				}
			],
			$Failed,
			Messages:>{
				Error::GradientOutOfOrder,
				Error::InvalidOption
			}
		],

		(* === Messages - InjectionTable === *)
		Example[
			{Messages,"InjectionTableForeignSamples","The InjectionTable contains samples that are not in the input or doesn't account for all of the samples:"},
			(
				customInjectionTable={
					{ColumnPrime,Null,Automatic,Automatic,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Automatic,Automatic,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Automatic,Automatic,Ambient,Automatic},
					{ColumnFlush,Null,Automatic,Automatic,Ambient,Automatic}
				};

				ExperimentHPLC[{
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]
				},
					InjectionTable->customInjectionTable
				]
			),
			$Failed,
			Variables:>{customInjectionTable,options},
			Messages:>{
				Error::InjectionTableForeignSamples,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"InjectionTableStandardConflict","Both InjectionTable and Standard are specified but have a mismatch:"},
			(
				customInjectionTable={
					{ColumnPrime,Null,Automatic,Automatic,Ambient,Automatic},
					{Standard,Model[Sample,StockSolution,Standard,"id:N80DNj1rWzaq"],Automatic,Automatic,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Automatic,Automatic,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Automatic,Automatic,Ambient,Automatic},
					{Standard,Model[Sample, StockSolution, Standard, "id:R8e1PjpkWx5X"],Automatic,Automatic,Ambient,Automatic},
					{ColumnFlush,Null,Automatic,Automatic,Ambient,Automatic}
				};

				ExperimentHPLC[{
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID]
				},
					InjectionTable->customInjectionTable,
					Standard->{Model[Sample, StockSolution, Standard, "id:R8e1PjpkWx5X"]}
				]
			),
			$Failed,
			Variables:>{customInjectionTable,options},
			Messages:>{
				Error::InjectionTableStandardConflict,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"InjectionTableBlankConflict","Both InjectionTable and Blank are specified but have a mismatch:"},
			(
				customInjectionTable={
					{ColumnPrime,Null,Automatic,Automatic,Ambient,Automatic},
					{Blank,Model[Sample,"Milli-Q water"],Automatic,Automatic,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Automatic,Automatic,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Automatic,Automatic,Ambient,Automatic},
					{Blank,Model[Sample,"Methanol"],Automatic,Automatic,Ambient,Automatic},
					{ColumnFlush,Null,Automatic,Automatic,Ambient,Automatic}
				};

				ExperimentHPLC[{
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID]
				},
					InjectionTable->customInjectionTable,
					Blank->{Model[Sample,"Milli-Q water"]}
				]
			),
			$Failed,
			Variables:>{customInjectionTable},
			Messages:>{
				Error::InjectionTableBlankConflict,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"InjectionTableBlankFrequencyConflict","Error if the specified InjectionTable and BlankFrequency do not match:"},
			(
				customInjectionTable={
					{ColumnPrime,Null,Automatic,Automatic,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Automatic,Automatic,Ambient,Automatic},
					{Blank,Model[Sample,"Milli-Q water"],Automatic,Automatic,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Automatic,Automatic,Ambient,Automatic},
					{Standard,Model[Sample,StockSolution,Standard,"id:N80DNj1rWzaq"],Automatic,Automatic,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID],Automatic,Automatic,Ambient,Automatic},
					{ColumnFlush,Null,Automatic,Automatic,Ambient,Automatic}
				};

				ExperimentHPLC[{
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]
				},
					InjectionTable->customInjectionTable,
					BlankFrequency->3
				]
			),
			$Failed,
			Variables:>{customInjectionTable},
			Messages:>{
				Error::InjectionTableBlankFrequencyConflict,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"InjectionTableGradientConflict","Error if the InjectionTable gradient does not match the gradient provided in the Gradient option:"},
			(
				customInjectionTable={
					{ColumnPrime,Null,Automatic,Automatic,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Automatic,Automatic,Ambient,Object[Method, Gradient, "id:M8n3rxYAonm5"]},
					{Sample,Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Automatic,Automatic,Ambient,Object[Method, Gradient, "id:M8n3rxYAonm5"]},
					{ColumnFlush,Null,Automatic,Automatic,Ambient,Automatic}
				};

				ExperimentHPLC[{
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID]
				},
					InjectionTable->customInjectionTable,
					Gradient->{Object[Method, Gradient, "id:M8n3rxYAonm5"],Object[Method, Gradient, "id:Z1lqpMznM834"]}
				]
			),
			$Failed,
			Variables:>{customInjectionTable,options},
			Messages:>{
				Error::InjectionTableGradientConflict,
				Warning::HPLCBufferConflict,
				Warning::HPLCGradientNotReequilibrated,
				Error::InvalidOption
			}
		],
		Example[{Messages,"InjectionTableStandardFrequencyConflict","Error if the specified InjectionTable and StandardFrequency do not match:"},
			(
				customInjectionTable={
					{ColumnPrime,Null,Automatic,Automatic,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Automatic,Automatic,Ambient,Automatic},
					{Blank,Model[Sample,"Milli-Q water"],Automatic,Automatic,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Automatic,Automatic,Ambient,Automatic},
					{ColumnFlush,Null,Automatic,Automatic,Ambient,Automatic},
					{Standard,Model[Sample,StockSolution,Standard,"id:N80DNj1rWzaq"],Automatic,Automatic,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID],Automatic,Automatic,Ambient,Automatic},
					{ColumnFlush,Null,Automatic,Automatic,Ambient,Automatic}
				};

				ExperimentHPLC[
					{
						Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
						Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],
						Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]
					},
					InjectionTable->customInjectionTable,
					StandardFrequency->3
				]
			),
			$Failed,
			Messages:>{Error::InjectionTableStandardFrequencyConflict,Error::InvalidOption},
			Variables:>{customInjectionTable}
		],
		Example[{Messages,"InjectionVolumeConflict","Error if the InjectionVolume specified in InjectionTable do not match other options:"},
			(
				customInjectionTable={
					{ColumnPrime,Null,Automatic,Automatic,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],30Microliter,PositionA,Ambient,Automatic},
					{ColumnFlush,Null,Automatic,Automatic,Ambient,Automatic}
				};

				ExperimentHPLC[
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					InjectionTable->customInjectionTable,
					InjectionVolume->200Microliter,
					ColumnSelector -> {PositionA, Automatic, Automatic, Model[Item,Column,"Aeris XB-C18 15cm Peptide Column"], Forward, Null, Null}
				]
			),
			$Failed,
			Messages:>{Error::InjectionVolumeConflict,Error::InvalidOption},
			Variables:>{customInjectionTable}
		],
		Example[{Messages,"ColumnPositionInjectionTableConflict","Error if the ColumnPosition specified in InjectionTable do not match other options:"},
			(
				customInjectionTable={
					{ColumnPrime,Null,Null,PositionA,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],30Microliter,PositionA,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],30Microliter,PositionB,Ambient,Automatic},
					{ColumnFlush,Null,Automatic,Automatic,Ambient,Automatic}
				};

				ExperimentHPLC[
					{Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID]},
					InjectionTable->customInjectionTable,
					ColumnSelector -> {
						{PositionA,Null,Null,Model[Item,Column,"id:o1k9jAKOw6d7"],Forward,Null,Null},
						{PositionB,Null,Null,Model[Item,Column,"id:dORYzZn0obYE"],Forward,Null,Null}
					},
					ColumnPosition -> PositionB
				]
			),
			$Failed,
			Messages:>{Error::ColumnPositionInjectionTableConflict,Error::InvalidOption},
			Variables:>{customInjectionTable}
		],
		Example[{Messages,"ColumnTemperatureInjectionTableConflict","Error if the ColumnTemperature specified in InjectionTable do not match other options:"},
			(
				customInjectionTable={
					{ColumnPrime,Null,Null,PositionA,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],30Microliter,PositionA,30Celsius,Automatic},
					{Sample,Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],30Microliter,PositionA,40Celsius,Automatic},
					{ColumnFlush,Null,Automatic,Automatic,Ambient,Automatic}
				};

				ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID]},
					InjectionTable->customInjectionTable,
					ColumnTemperature->{40Celsius,30Celsius}
				]
			),
			$Failed,
			Messages:>{Error::ColumnTemperatureInjectionTableConflict,Error::InvalidOption},
			Variables:>{customInjectionTable}
		],
		Example[
			{Messages,"InjectionTableColumnConflictHPLC","Error if the specified column positions in InjectionTable require more sets of column assemblies that specified in the Column and ColumnSelector options:"},
			(
				customInjectionTable={
					{ColumnPrime,Null,Null,PositionA,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],30Microliter,PositionA,Ambient,Automatic},
					{Sample,Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],30Microliter,PositionB,Ambient,Automatic},
					{ColumnFlush,Null,Automatic,Automatic,Ambient,Automatic}
				};

				ExperimentHPLC[
					{Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID]},
					Column -> Model[Item, Column, "id:o1k9jAKOw6d7"],
					InjectionTable->customInjectionTable
				]
			),
			$Failed,
			Variables:>{customInjectionTable},
			Messages:>{
				Error::InjectionTableColumnConflictHPLC,
				Warning::AliquotRequired,
				Error::InvalidOption
			}
		],

		(* === Messages - Samples === *)
		Example[{Messages,"InsufficientSampleVolume","If InjectionVolume is greater than sample volume, throw error but continue:"},
			(
				packet = ExperimentHPLC[
					Object[Sample,"Test low volume sample for ExperimentHPLC tests" <> $SessionUUID],
					Upload->False,
					InjectionVolume -> 400 Microliter
				][[1]];
				Lookup[packet,Replace[InjectionVolumes]]
			),
			{400 Microliter},
			Messages:>{Warning::InsufficientSampleVolume},
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		Example[{Messages,"InsufficientSampleVolume","If InjectionVolume is less than sample volume but greater than sample volume + dead volume, throw error but continue:"},
			(
				packet = ExperimentHPLC[
					Object[Sample,"Test low volume sample for ExperimentHPLC tests" <> $SessionUUID],
					Upload->False,
					InjectionVolume -> 310 Microliter
				][[1]];
				Lookup[packet,Replace[InjectionVolumes]]
			),
			{310 Microliter},
			Messages:>{Warning::InsufficientSampleVolume},
			EquivalenceFunction -> Equal,
			Variables :> {packet}
		],
		Example[{Messages,"HPLCIncompatibleInjectionVolume","Error if the InjectionVolume is above the instrument's limit:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument->Model[Instrument,HPLC,"Waters Acquity UPLC H-Class PDA"],
				InjectionVolume->200Microliter
			],
			$Failed,
			Messages:>{Error::HPLCIncompatibleInjectionVolume,Error::InvalidOption}
		],
		Example[{Messages,"HPLCIncompatibleInjectionVolume","Error if the InjectionVolume is below the instrument's limit:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument->Model[Instrument,HPLC,"UltiMate 3000"],
				InjectionVolume->4Microliter
			],
			$Failed,
			Messages:>{Error::HPLCIncompatibleInjectionVolume,Error::InvalidOption}
		],
		Example[{Messages,"HPLCSmallInjectionVolume","Warning if the InjectionVolume is below the recommended injection volume:"},
			Lookup[
				ExperimentHPLC[
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Instrument->Model[Instrument,HPLC,"Waters Acquity UPLC H-Class PDA"],
					InjectionVolume->0.5Microliter,
					Output->Options
				],
				InjectionVolume
			],
			0.5Microliter,
			EquivalenceFunction -> Equal,
			Messages:>{Warning::HPLCSmallInjectionVolume}
		],

		(* === Messages - Buffers === *)
		Example[{Messages,"HPLCBufferConflict","Warning if the specified buffer is not the same as in the provided gradient method. The specified buffer is used:"},
			(
				packet=ExperimentHPLC[
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					BufferA -> Model[Sample, "Acetonitrile, HPLC Grade"],
					Gradient -> Object[Method, Gradient, "id:M8n3rxYAonm5"],
					Upload -> False
				][[1]];
				Lookup[packet,BufferA]
			),
			ObjectP[Model[Sample, "Acetonitrile, HPLC Grade"]],
			Messages:>{
				Warning::HPLCBufferConflict
			},
			Variables:>{packet}
		],
		Example[
			{Messages,"NonBinaryHPLC","Non-binary gradients are not supported on HPLC with binary pump:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],
				Instrument->Model[Instrument, HPLC, "id:R8e1Pjp1md8p"],
				Gradient->{
					{
						Quantity[0., "Minutes"],
						Quantity[75., "Percent"],
						Quantity[0., "Percent"],
						Quantity[25., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0.4, "Milliliters"/"Minutes"],
						None
					},
					{
						Quantity[4., "Minutes"],
						Quantity[75., "Percent"],
						Quantity[0., "Percent"],
						Quantity[25., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0.4, "Milliliters"/"Minutes"],
						None
					}
				}
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::NonBinaryHPLC,Warning::HPLCGradientNotReequilibrated}
		],
		Example[
			{Messages,"ConflictColumnStorageBuffer","The specified ColumnStorageBuffer should match one of the specified buffers:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				BufferA -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
				BufferB -> Model[Sample, StockSolution, "Reverse phase buffer B 0.05% HFBA"],
				BufferC -> Model[Sample, "Acetonitrile, HPLC Grade"],
				BufferD -> Model[Sample, "Milli-Q water"],
				ColumnStorageBuffer -> Model[Sample, StockSolution, "20% Methanol in MilliQ Water"]
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::ConflictColumnStorageBuffer}
		],
		Example[
			{Messages,"ConflictColumnStorageBufferFlushGradient","The specified ColumnStorageBuffer gradient must match the end gradient of the specified ColumnFlushGradient:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnFlushGradient->{
					{
						Quantity[0., "Minutes"],
						Quantity[75., "Percent"],
						Quantity[0., "Percent"],
						Quantity[25., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0.4, "Milliliters"/"Minutes"],
						None
					},
					{
						Quantity[4., "Minutes"],
						Quantity[75., "Percent"],
						Quantity[0., "Percent"],
						Quantity[25., "Percent"],
						Quantity[0., "Percent"],
						Quantity[0.4, "Milliliters"/"Minutes"],
						None
					}
				},
				ColumnStorageBuffer->{50Percent,10Percent,15Percent,25Percent}
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::ConflictColumnStorageBufferFlushGradient}
		],
		Example[
			{Messages,"InvalidGradientColumnStorageBuffer","The specified ColumnStorageBuffer gradient must sum to 100%:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnStorageBuffer->{80Percent,10Percent,15Percent,25Percent}
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::InvalidGradientColumnStorageBuffer}
		],
		Example[
			{Messages,"IncompatibleModelColumnStorageBuffer","Non-binary gradients are not supported on HPLC with binary pump:"},
			options=ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				BufferA -> Model[Sample, StockSolution, "Reverse phase buffer A 0.05% HFBA"],
				BufferB -> Model[Sample, StockSolution, "Reverse phase buffer B 0.05% HFBA"],
				BufferC -> Model[Sample, "Acetonitrile, HPLC Grade"],
				BufferD -> Model[Sample, "Milli-Q water"],
				Column -> Model[Item, Column, "Test storage buffer column model for ExperimentHPLC" <> $SessionUUID],
				Output->Options
			];
			Lookup[options,ColumnStorageBuffer],
			{EqualP[90Percent],EqualP[10Percent],EqualP[0Percent],EqualP[0Percent]},
			Messages:>{Warning::IncompatibleModelColumnStorageBuffer},
			Variables:>{options}
		],

		(* === Messages - Detectors === *)
		Example[{Messages,"WavelengthOutOfRange","Error if a detection wavelength is specified that is outside the specified Instrument's compatible range:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument -> Model[Instrument,HPLC,"Waters Acquity UPLC H-Class PDA"],
				AbsorbanceWavelength -> 800 Nanometer
			],
			$Failed,
			Messages:>{Error::WavelengthOutOfRange,Error::InvalidOption}
		],
		Example[{Messages,"WavelengthOutOfRange","Error if an excitation wavelength is specified that is outside the specified Instrument's compatible range:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument -> Model[Instrument, HPLC, "UltiMate 3000 with FLR Detector"],
				ExcitationWavelength -> 1100 Nanometer
			],
			$Failed,
			Messages:>{Error::WavelengthOutOfRange,Error::InvalidOption}
		],
		Example[{Messages,"WavelengthOutOfRange","Error if an excitation wavelength is specified that is outside the specified Instrument's compatible range:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument -> Model[Instrument, HPLC, "Waters Acquity UPLC H-Class FLR"],
				EmissionWavelength -> 1100 Nanometer
			],
			$Failed,
			Messages:>{Error::WavelengthOutOfRange,Error::InvalidOption}
		],
		Example[{Messages,"WavelengthTemperatureConflict","Error if SampleTemperature is specified and a detection wavelength is specified that is outside the Instrument's compatible range which supports autosampler incubation:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				SampleTemperature -> 40 Celsius,
				AbsorbanceWavelength -> 800 Nanometer
			],
			$Failed,
			Messages:>{Error::WavelengthTemperatureConflict,Error::InvalidOption}
		],
		Example[
			{Messages,"DetectorConflict","If the specified Detector are not available in the list of available Detectors of the specified UltiMate 3000 HPLC Instrument, throw error:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Instrument->Model[Instrument, HPLC, "UltiMate 3000"],
				Detector->{MultiAngleLightScattering,DynamicLightScattering},
				Upload->False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::DetectorConflict}
		],
		Example[
			{Messages,"DetectorConflict","If the specified Detector are not available in the list of available Detectors of the specified Waters HPLC Instrument, throw error:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Detector->UVVis,
				Instrument->Model[Instrument,HPLC,"Waters Acquity UPLC H-Class PDA"]
			],
			$Failed,
			Messages:>{Error::DetectorConflict,Error::InvalidOption}
		],
		Example[
			{Messages,"InvalidHPLCDetectorOptions","If a detector is not specified, the options related to this detector should not be populated:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Instrument->Model[Instrument, HPLC, "UltiMate 3000"],
				Detector->UVVis,
				LightScatteringLaserPower->50Percent,
				Upload->False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::InvalidHPLCDetectorOptions}
		],
		Example[{Messages,"UnsupportedSampleTemperatureAndDetectors","If SampleTemperature is specified while the requested Detector is only available on the HPLC instruments that do not support autosampler incubation, throw error:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Detector->{MultiAngleLightScattering,DynamicLightScattering},
				SampleTemperature->15 Celsius
			],
			$Failed,
			Messages:>{
				Error::UnsupportedSampleTemperatureAndDetectors,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnsupportedBufferDAndDetectors","If BufferD is specified while the requested Detector is only available on the HPLC instruments that do not support a four buffer system, throw error:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Detector->{MultiAngleLightScattering,DynamicLightScattering},
				BufferD->Model[Sample,"Acetonitrile, HPLC Grade"]
			],
			$Failed,
			Messages:>{
				Error::UnsupportedBufferDAndDetectors,
				Error::InvalidOption
			}
		],
		Example[{Messages,"UnsupportedGradientDAndDetectors","If a gradient specifies the usage of BufferD while the requested Detector is only available on the HPLC instruments that do not support a four buffer system, throw error:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Detector->{MultiAngleLightScattering,DynamicLightScattering},
				GradientA->10 Percent,
				GradientD->90 Percent
			],
			$Failed,
			Messages:>{
				Error::UnsupportedGradientDAndDetectors,
				Warning::HPLCGradientNotReequilibrated,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"ConflictHPLCDetectorOptions","The detector related options should either all be populated or all be Null in order to determine whether the detector is desired:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				LightScatteringLaserPower->50Percent,
				LightScatteringFlowCellTemperature->Null,
				Upload->False
			],
			$Failed,
			Messages:>{
				Error::InvalidOption,
				Error::ConflictHPLCDetectorOptions,
				Error::MissingHPLCDetectorOptions
			}
		],
		Example[{Messages,"IncompatibleDetectionWavelength","Error if the specified UVVis Detector is not compatible with any instrument that supports the absorbance detection wavelength(s) specified:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Detector -> PhotoDiodeArray,
				AbsorbanceWavelength -> 600 Nanometer,
				Aliquot->False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::IncompatibleDetectionWavelength}
		],
		Example[{Messages,"IncompatibleDetectionWavelength","Error if the specified Fluorescence Detector is not compatible with any instrument that supports the excitation wavelength(s) specified:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Detector -> Fluorescence,
				ExcitationWavelength -> 890 Nanometer,
				CollectFractions ->True
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::IncompatibleDetectionWavelength}
		],
		Example[{Messages,"IncompatibleDetectionWavelength","Error if the specified Fluorescence Detector is not compatible with any instrument that supports the emission wavelength(s) specified:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],
				EmissionWavelength -> 1000 Nanometer
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::IncompatibleDetectionWavelength}
		],
		Example[
			{Messages,"MissingHPLCDetectorOptions","The detector related options should not be set to Null if the detector is requested:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				ExcitationWavelength->Null,
				Upload->False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::MissingHPLCDetectorOptions}
		],
		Example[
			{Messages,"MissingFractionCollectionDetector","If the specified FractionCollectionDetector is not a member of the available detectors of the specified HPLC instrument, throw error:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Instrument->Model[Instrument, HPLC, "UltiMate 3000"],
				FractionCollectionDetector->Fluorescence,
				Upload->False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::MissingFractionCollectionDetector}
		],
		Example[
			{Messages,"ConflictFractionCollectionUnit","If the specified FractionCollectionDetector requires a detector unit different from the specified AbsoluteThreshold, PeakSlope or PeakEndThreshold, throw error:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Instrument->Model[Instrument, HPLC, "UltiMate 3000"],
				FractionCollectionDetector->UVVis,
				AbsoluteThreshold->500Micro*RFU,
				Upload->False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::ConflictFractionCollectionUnit}
		],
		Example[
			{Messages,"MissingHPLCpHCalibrationOptions","When pHCalibration is set to True, the related options must be populated:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{UVVis,pH,Conductance},
				pHCalibration->True,
				LowpHCalibrationTarget->Null,
				Upload->False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::MissingHPLCpHCalibrationOptions}
		],
		Example[
			{Messages,"MissingHPLCpHCalibrationOptions","When pHCalibration is set to True and the calibration buffer is provided, the pH of the calibration buffer must be provided or available through its model:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{UVVis,pH,Conductance},
				pHCalibration->True,
				LowpHCalibrationBuffer->Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Upload->False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::MissingHPLCpHCalibrationOptions}
		],
		Example[
			{Messages,"InvalidHPLCpHCalibrationOptions","When pHCalibration is not True, the related options should not be populated:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{UVVis,pH,Conductance},
				pHCalibration->False,
				LowpHCalibrationTarget->4,
				Upload->False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::InvalidHPLCpHCalibrationOptions}
		],
		Example[
			{Messages,"MissingHPLCConductivityCalibrationOptions","When ConductivityCalibration is set to True, the related options must be populated:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{UVVis,pH,Conductance},
				ConductivityCalibration->True,
				ConductivityCalibrationTarget->Null,
				Upload->False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::MissingHPLCConductivityCalibrationOptions}
		],
		Example[
			{Messages,"MissingHPLCConductivityCalibrationOptions","When ConductivityCalibration is set to True and the calibration buffer is provided, the conductivity of the calibration buffer must be provided or available through its model:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{UVVis,pH,Conductance},
				ConductivityCalibration->True,
				ConductivityCalibrationBuffer->Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Upload->False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::MissingHPLCConductivityCalibrationOptions}
		],
		Example[
			{Messages,"InvalidHPLCConductivityCalibrationOptions","When CondcutivityCalibration is not True, the related options should not be populated:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->{UVVis,pH,Conductance},
				ConductivityCalibration->False,
				ConductivityCalibrationTarget->1000Micro*Siemens/Centimeter,
				Upload->False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::InvalidHPLCConductivityCalibrationOptions}
		],
		Example[
			{Messages,"HPLCpHCalibrationBufferSwapped","The specified LowpHCalibrationTarget should be lower than the specified HighpHCalibrationTarget:"},
			(
				ExperimentHPLC[
					{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
					Detector->{UVVis,pH,Conductance},
					pHCalibration->True,
					LowpHCalibrationBuffer->Model[Sample, "Reference buffer, pH 7"],
					LowpHCalibrationTarget->7,
					HighpHCalibrationBuffer->Model[Sample, "pH 4.01 Calibration Buffer, Sachets"],
					HighpHCalibrationTarget->4,
					Upload->False
				]
			),
			{PacketP[Object[Protocol, HPLC]],___},
			Messages:>{Warning::HPLCpHCalibrationBufferSwapped}
		],
		Example[{Messages,"WavelengthResolutionConflict","Return an error when the AbsorbanceWavelength is not a range (e.g. singleton value) and WavelengthResolution is specified to a value:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				ColumnPrimeAbsorbanceWavelength->280*Nanometer,
				ColumnPrimeWavelengthResolution->1.2*Nanometer
			],
			$Failed,
			Messages:>{
				Error::WavelengthResolutionConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages,"FractionCollectionWavelengthConflict","Return an error if CollectFractions is True but the AbsorbanceWavelength is not a single value:"},
			ExperimentHPLC[
				Object[Sample, "Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <>$SessionUUID],
				Scale -> Preparative,
				AbsorbanceWavelength -> Span[190 Nanometer, 900 Nanometer]
			],
			$Failed,
			Messages:>{
				Error::FractionCollectionWavelengthConflict,
				Error::InvalidOption
			}
		],
		Example[{Messages,"AbsorbanceRateAdjusted","Return an warning if the specified AbsorbanceSamplingRate option is not an achievable value:"},
			packet=ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				AbsorbanceSamplingRate->13/Second,
				Upload->False
			][[1]];
			Lookup[packet,Replace[AbsorbanceSamplingRate]],
			{10/Second,10/Second,10/Second},
			EquivalenceFunction -> Equal,
			Messages:>{
				Warning::AbsorbanceRateAdjusted
			},
			Variables:>{packet}
		],
		Example[{Messages,"WavelengthResolutionAdjusted","Return an warning if the specified WavelengthResolution option is not an achievable value:"},
			packet=ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				WavelengthResolution->2.5Nanometer,
				Upload->False
			][[1]];
			Lookup[packet,Replace[WavelengthResolution]],
			{2.4Nanometer,2.4Nanometer,2.4Nanometer},
			EquivalenceFunction -> Equal,
			Messages:>{
				Warning::WavelengthResolutionAdjusted
			},
			Variables:>{packet}
		],
		Example[
			{Messages,"UVVisOptionsNotApplicable","If AbsorbanceSamplingRate or UVFilter are specified, but the instrument doesn't have those options:"},
			options=ExperimentHPLCOptions[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Instrument->Model[Instrument, HPLC, "UltiMate 3000"],
				AbsorbanceSamplingRate->5*1/Second, OutputFormat -> List
			];
			Lookup[options,Instrument],
			ObjectP[Model[Instrument, HPLC, "UltiMate 3000"]],
			Variables:>{options},
			Messages:>{
				Warning::UVVisOptionsNotApplicable
			}
		],
		Example[
			{Messages,"GasPressureRequiresNebulizer","If NebulizerGasPressure is specified but NebulizerGas is False or Null:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->EvaporativeLightScattering,BlankNebulizerGasPressure->35*PSI,BlankNebulizerGas->Null],
			$Failed,
			Variables:>{options},
			Messages:>{
				Error::ConflictHPLCDetectorOptions,
				Error::GasPressureRequiresNebulizer,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"GasHeatingRequiresNebulizer","If NebulizerGasHeating is specified but NebulizerGas is False or Null:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->EvaporativeLightScattering,NebulizerGasHeating->True,NebulizerGas->False],
			$Failed,
			Variables:>{options},
			Messages:>{
				Error::GasHeatingRequiresNebulizer,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"HeatingPowerRequiresNebulizerHeating","If NebulizerHeatingPower is specified but NebulizerGas or NebulizerGasHeating is False or Null:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->EvaporativeLightScattering,NebulizerHeatingPower->40*Percent,NebulizerGasHeating->Null],
			$Failed,
			Variables:>{options},
			Messages:>{
				Error::ConflictHPLCDetectorOptions,
				Error::HeatingPowerRequiresNebulizerHeating,
				Error::InvalidOption
			}
		],
		Example[
			{Messages,"HPLCEmissionLowerThanExcitation","If any of the specified fluorescence emission wavelengths are less than the excitation wavelengths, throw error:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Detector->Fluorescence,
				ExcitationWavelength->520Nanometer,
				EmissionWavelength->495Nanometer
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::HPLCEmissionLowerThanExcitation}
		],
		Example[
			{Messages,"HPLCEmissionExcitationTooNarrow","If Dionex Fluorescence HPLC is required, excitation wavelength should not be within 20 nm of emission wavelength:"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Instrument->Model[Instrument, HPLC, "UltiMate 3000 with FLR Detector"],
				ExcitationWavelength->555Nanometer,
				EmissionWavelength->570Nanometer
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::HPLCEmissionExcitationTooNarrow}
		],
		Example[
			{Messages,"HPLCEmissionExcitationTooNarrow","If semi-prep Agilent Fluorescence HPLC is required, excitation wavelength should not be within 10 nm of emission wavelength (1):"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample CMU-1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample CMU-2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample CMU-3 for ExperimentHPLC tests" <> $SessionUUID]},
				Instrument->Model[Instrument, HPLC, "Agilent 1260 Infinity II Semi-Preparative HPLC with UV/Vis Diode Array and Fluorescence Detectors"],
				ExcitationWavelength->555Nanometer,
				EmissionWavelength->564Nanometer
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::HPLCEmissionExcitationTooNarrow}
		],
		Example[
			{Messages,"HPLCEmissionExcitationTooNarrow","If semi-prep Agilent Fluorescence HPLC is required, excitation wavelength must be 10 nm larger than emission wavelength (2):"},
			ExperimentHPLC[
				{Object[Sample,"Test Sample CMU-1 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample CMU-2 for ExperimentHPLC tests" <> $SessionUUID],Object[Sample,"Test Sample CMU-3 for ExperimentHPLC tests" <> $SessionUUID]},
				Instrument->Model[Instrument, HPLC, "Agilent 1260 Infinity II Semi-Preparative HPLC with UV/Vis Diode Array and Fluorescence Detectors"],
				ExcitationWavelength->555Nanometer,
				EmissionWavelength->566Nanometer
			],
			ObjectP[Object[Protocol,HPLC]]
		],
		Example[
			{Messages,"ConflictHPLCFluorescenceOptionsLengths","If any of the specified fluorescence emission wavelengths are less than the excitation wavelengths, throw error:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Scale->SemiPreparative,
				Detector->Fluorescence,
				ExcitationWavelength->{495Nanometer,540Nanometer},
				EmissionWavelength->{520Nanometer,590Nanometer},
				FluorescenceGain->{50 Percent,20 Percent, 40 Percent}
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::ConflictHPLCFluorescenceOptionsLengths}
		],
		Example[
			{Messages,"HPLCFluorescenceWavelengthLimit","If too many fluorescence wavelengths are specified for measurement, throw error (limit 4 for Waters and Dionex instruments):"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Detector->Fluorescence,
				ExcitationWavelength->{340Nanometer,395Nanometer,450Nanometer,495Nanometer,540Nanometer,590Nanometer},
				EmissionWavelength->{425Nanometer,455Nanometer,465Nanometer,520Nanometer,590Nanometer,625Nanometer}
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::HPLCFluorescenceWavelengthLimit}
		],
		Example[
			{Messages,"HPLCFluorescenceWavelengthLimit","If too many fluorescence wavelengths are specified for measurement, throw error:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample CMU-1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument -> Model[Instrument, HPLC, "Agilent 1260 Infinity II Semi-Preparative HPLC with UV/Vis Diode Array and Fluorescence Detectors"],
				ExcitationWavelength->{540Nanometer,590Nanometer},
				EmissionWavelength->{590Nanometer,625Nanometer}
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::HPLCFluorescenceWavelengthLimit}
		],
		Example[
			{Messages,"InvalidHPLCEmissionCutOffFilter","EmissionCutOffFilter option can only be set when an emission cut-off filter is available on the selected instrument:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument->Model[Instrument, HPLC, "Waters Acquity UPLC H-Class FLR"],
				Detector->Fluorescence,
				EmissionCutOffFilter->280Nanometer
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::InvalidHPLCEmissionCutOffFilter}
		],
		Example[
			{Messages,"TooLargeHPLCEmissionCutOffFilter","EmissionCutOffFilter option should not be set to a value larger than the emission wavelength:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument->Model[Instrument, HPLC, "UltiMate 3000 with FLR Detector"],
				Detector->Fluorescence,
				ExcitationWavelength->495Nanometer,
				EmissionWavelength->520Nanometer,
				EmissionCutOffFilter->530Nanometer
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::TooLargeHPLCEmissionCutOffFilter}
		],
		Example[
			{Messages,"InvalidWatersHPLCFluorescenceGain","FluorescenceGain must be set to a constant value for multi-channel fluorescence measurement for Waters Acquity UPLC H-Class Fluorescence detector:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument->Model[Instrument, HPLC, "Waters Acquity UPLC H-Class FLR"],
				Detector->Fluorescence,
				ExcitationWavelength-> {495Nanometer,540Nanometer},
				EmissionWavelength-> {520Nanometer,590Nanometer},
				FluorescenceGain-> {100Percent,20Percent}
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::InvalidWatersHPLCFluorescenceGain}
		],
		Example[
			{Messages,"InvalidHPLCFluorescenceFlowCellTemperature","FluorescenceFlowCellTemperature option can only be set when fluorescence flow cell temperature control is available on the selected instrument:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Instrument->Model[Instrument, HPLC, "Waters Acquity UPLC H-Class FLR"],
				Detector->Fluorescence,
				FluorescenceFlowCellTemperature->40Celsius
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::InvalidHPLCFluorescenceFlowCellTemperature}
		],
		Example[
			{Messages,"ConflictRefractiveIndexMethod","When DifferentialRefractiveIndex is selected, the gradient should have the differential refractive index reference loading closed:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Detector->RefractiveIndex,
				RefractiveIndexMethod->DifferentialRefractiveIndex,
				Gradient->{
					{0Minute,100Percent,0Percent,0Percent,0Percent,1Milliliter/Minute,Open},
					{5Minute,100Percent,0Percent,0Percent,0Percent,1Milliliter/Minute,Open},
					{5.1Minute,0Percent,100Percent,0Percent,0Percent,1Milliliter/Minute,Open},
					{10Minute,0Percent,100Percent,0Percent,0Percent,1Milliliter/Minute,Open},
					{10.1Minute,90Percent,10Percent,0Percent,0Percent,1Milliliter/Minute,Open},
					{15Minute,90Percent,10Percent,0Percent,0Percent,1Milliliter/Minute,Open}
				}
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::ConflictRefractiveIndexMethod,Warning::HPLCGradientNotReequilibrated}
		],

		(* === Messages - Instrument Precision === *)
		Example[{Messages,"InstrumentPrecision","Warning will be thrown if a buffer composition is specified to an incompatible precision:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				GradientB -> 35.11 Percent
			],
			ObjectP[Object[Protocol,HPLC]],
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Messages,"InstrumentPrecision","Warning will be thrown if a gradient timepoint is specified to an incompatible precision:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				GradientB -> {{10.001 Minute, 35 Percent}}
			],
			ObjectP[Object[Protocol,HPLC]],
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Messages,"InstrumentPrecision","Warning will be thrown if a gradient flow rate is specified to an incompatible precision:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				FlowRate -> 1.501 Milliliter/Minute
			],
			ObjectP[Object[Protocol,HPLC]],
			Messages:>{Warning::InstrumentPrecision}
		],
		Example[{Messages,"InstrumentPrecision","Warning will be thrown if a gradient flow rate is specified to an incompatible precision:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				Gradient -> {
					{0 Minute,10 Percent,90 Percent, 0 Percent, 0 Percent,1.501 Milliliter/Minute, None},
					{10 Minute,10 Percent,90 Percent, 0 Percent, 0 Percent,1.501 Milliliter/Minute, None}
				}
			],
			ObjectP[Object[Protocol,HPLC]],
			Messages:>{
				Warning::InstrumentPrecision
			}
		],
		Example[{Messages,"InstrumentPrecision","Warning will be thrown if a temperature is specified to an incompatible precision:"},
			(
				customInjectionTable={
					{ColumnPrime, Null, Automatic, Automatic, Ambient, Automatic},
					{Sample, Object[Sample, "Test Sample 1 for ExperimentHPLC tests"<>$SessionUUID], Automatic, Automatic, 30.001 Celsius, Automatic},
					{ColumnFlush, Null, Automatic, Automatic, Ambient, Automatic}
				};
				ExperimentHPLC[
					Object[Sample, "Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					InjectionTable-> customInjectionTable
				]
			),
			ObjectP[Object[Protocol,HPLC]],
			Variables:>{customInjectionTable},
			Messages:>{Warning::InstrumentPrecision}
		],
		Example[{Messages,"InstrumentPrecision","Warning will be thrown if a injection volume is specified to an incompatible precision:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				InjectionVolume -> 10.001 Microliter
			],
			ObjectP[Object[Protocol,HPLC]],
			Messages:>{Warning::InstrumentPrecision}
		],
		Example[{Messages,"InstrumentPrecision","Warning will be thrown if an absorbance is specified to an incompatible precision:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				AbsoluteThreshold -> 1000.1 Milli AbsorbanceUnit
			],
			ObjectP[Object[Protocol,HPLC]],
			Messages:>{Warning::InstrumentPrecision}
		],
		Example[{Messages,"InstrumentPrecision","Warning will be thrown if an absorbance slope is specified to an incompatible precision:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				PeakSlope -> 10.1 Milli AbsorbanceUnit/Second
			],
			ObjectP[Object[Protocol,HPLC]],
			Messages:>{Warning::InstrumentPrecision}
		],
		Example[{Messages,"HPLCIncompatibleAliquotContainer","Error if the specified container in which to aliquot the samples is not compatible with an HPLC instrument:"},
			ExperimentHPLC[
				Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
				AliquotAmount -> 50 Microliter,
				AssayVolume -> 200 Microliter,
				AliquotContainer -> Model[Container, Vessel, "2mL Tube"]
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::HPLCIncompatibleAliquotContainer,Error::AliquotContainers}
		],
		Example[{Messages,"IncompatibleContainerModel","Error if aliquot is explicity prohibited and the input samples are in a container type that is not compatible with an HPLC instrument:"},
			ExperimentHPLC[
				Object[Sample,"Test sample for invalid container for ExperimentHPLC tests" <> $SessionUUID],
				Aliquot -> False
			],
			$Failed,
			Messages:>{Error::InvalidOption,Error::AliquotOptionMismatch}
		],
		Test["When instrument are not specified and total of 3 buffers are used, function should be able to resolve an instrument that supports Ternary gradients:",
			(* How this test works: Setting FlowRate -> 3.5 ml/min would rule out most HPLC, only 2 left are Model[Instrument, HPLC, "UltiMate 3000"] and Model[Instrument, HPLC, "id:GmzlKjY5EOAM"] *)
			(* The latter has no PumpType defined, the Model[Instrument, HPLC, "id:GmzlKjY5EOAM"] is Ternary, so if it works, we should resolve Model[Instrument, HPLC, "id:GmzlKjY5EOAM"] as instrument, otherwise function errors out *)
			Download[ExperimentHPLC[
				{Object[Sample, "Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], Object[Sample, "Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID], Object[Sample, "Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID]},
				Gradient -> {{0 Minute, 95 Percent, 5 Percent, 0 Percent, 0 Percent, 3.5 Milliliter/Minute, None},
					{30 Minute, 0 Percent, 5 Percent, 95 Percent, 0 Percent, 3.5 Milliliter/Minute, None},
					{60 Minute, 95 Percent, 5 Percent, 0 Percent, 0 Percent, 3.5 Milliliter/Minute, None}},
				ColumnFlushGradient -> {{0 Minute, 0 Percent, 0 Percent, 100 Percent, 0 Percent, 3.5 Milliliter/Minute, None}, {30 Minute, 0 Percent, 0 Percent, 100 Percent, 0 Percent, 3.5 Milliliter/Minute, None}},
				BufferA -> Model[Sample, "id:8qZ1VWNmdLBD"], BufferB -> Model[Sample, "id:eGakldaErmD4"], BufferC -> Model[Sample, "id:O81aEB4kJXr1"], FlowRate -> 3.5 Milliliter/Minute,
				Column -> Model[Item, Column, "Test cartridge-protected column model for ExperimentHPLC (2)" <> $SessionUUID]
			], Instrument],
			ObjectP[{Model[Instrument, HPLC, "id:N80DNjlYwwJq"], Model[Instrument, HPLC, "id:M8n3rx098xbO"]}]
		],
		Test["When specifying a Gradient method the automatic resolution of injection table reflects the column gradient:",
			Cases[Lookup[ExperimentHPLC[
				Object[Sample, "Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID], Gradient -> Object[Method, Gradient, "id:M8n3rxYAonm5"],
				Output -> Options], InjectionTable], {Sample, ___}][[1,5]],
			Download[Object[Method, Gradient, "id:M8n3rxYAonm5"], Temperature]
		],
		Test["When running a Fluorescence detector protocol at CMU, resolve to the correct instruments that can fulfill the specified options - Agilent instrument model is excluded if there are more than 1 pair of Excitation/Emission wavelengths:",
			Module[
				{protocol,instrumentResource,instrumentModels},
				protocol=ExperimentHPLC[
					{
						Object[Sample,"Test Sample CMU-1 for ExperimentHPLC tests" <> $SessionUUID],
						Object[Sample,"Test Sample CMU-2 for ExperimentHPLC tests" <> $SessionUUID],
						Object[Sample,"Test Sample CMU-3 for ExperimentHPLC tests" <> $SessionUUID]
					},
					ExcitationWavelength -> {540 Nanometer, 590 Nanometer},
					EmissionWavelength -> {590 Nanometer, 625 Nanometer}
				];
				instrumentResource=FirstCase[
					Download[protocol,RequiredResources],
					{_, Instrument, ___}
				][[1]];
				instrumentModels=Download[instrumentResource,InstrumentModels[Object]]
			],
			{Model[Instrument, HPLC, "id:1ZA60vw8X5eD"]}
		],
		Test["When running a Fluorescence detector protocol at CMU, resolve to the correct instruments that can fulfill the specified options - Agilent instrument model is excluded if the difference between Excitation wavelength and Emission wavelength are less than 10 nm:",
			Module[
				{protocol,instrumentResource,instrumentModels},
				protocol=ExperimentHPLC[
					{
						Object[Sample,"Test Sample CMU-1 for ExperimentHPLC tests" <> $SessionUUID],
						Object[Sample,"Test Sample CMU-2 for ExperimentHPLC tests" <> $SessionUUID],
						Object[Sample,"Test Sample CMU-3 for ExperimentHPLC tests" <> $SessionUUID]
					},
					ExcitationWavelength -> 540 Nanometer,
					EmissionWavelength -> 548 Nanometer
				];
				instrumentResource=FirstCase[
					Download[protocol,RequiredResources],
					{_, Instrument, ___}
				][[1]];
				instrumentModels=Download[instrumentResource,InstrumentModels[Object]]
			],
			{Model[Instrument, HPLC, "id:1ZA60vw8X5eD"]}
		],
		Test["When a detector is only available at one site (pH), resolve to that instrument model even if the samples are at a different site (samples are shipped):",
			Module[
				{protocol,instrumentResource,instrumentModels},
				protocol=ExperimentHPLC[
					{
						Object[Sample, "Test Sample CMU-1 for ExperimentHPLC tests" <> $SessionUUID],
						Object[Sample, "Test Sample CMU-2 for ExperimentHPLC tests" <> $SessionUUID],
						Object[Sample, "Test Sample CMU-3 for ExperimentHPLC tests" <> $SessionUUID]
					},
					Detector -> pH
				];
				instrumentResource=FirstCase[
					Download[protocol,RequiredResources],
					{_, Instrument, ___}
				][[1]];
				instrumentModels=Download[instrumentResource,InstrumentModels[Object]]
			],
			(* Model[Instrument, HPLC, "UltiMate 3000 with PCM Detector"] *)
			{Model[Instrument, HPLC, "id:P5ZnEjdExnnn"]}
		],
		Test["Allows instrument at a different site since samples can be shipped between sites:",
			ExperimentHPLC[
				{
					Object[Sample, "Test Sample CMU-1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample, "Test Sample CMU-2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample, "Test Sample CMU-3 for ExperimentHPLC tests" <> $SessionUUID]
				},
				Instrument -> Model[Instrument, HPLC, "UltiMate 3000"]
			],
			ObjectP[Object[Protocol,HPLC]]
		]
	},
	(* without this, telescope crashes and the test fails *)
	HardwareConfiguration->HighRAM,
	SetUp:>(ClearMemoization[];ClearDownload[];$CreatedObjects = {}),
	TearDown:>(EraseObject[$CreatedObjects,Force->True]),
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(*delete the old objects in case they're still in the database*)
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 4 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 5 for ExperimentHPLC tests (high recovery vial)" <> $SessionUUID],
					Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],
					Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],
					Object[Sample,"Test Sample 8 for ExperimentHPLC tests (15mL Tube)" <> $SessionUUID],
					Object[Sample,"Test Sample 9 for ExperimentHPLC tests (15mL Tube)" <> $SessionUUID],
					Object[Sample,"Large Container Sample for ExperimentHPLC" <> $SessionUUID],
					Object[Sample,"Test sample for invalid container for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test low volume sample for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test invalid sample (solid sample) for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample CMU-1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample CMU-2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample CMU-3 for ExperimentHPLC tests" <> $SessionUUID],

					Object[Container,Plate,"Test plate 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate CMU-1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container, Vessel, "Test large container 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container, Vessel, "Test invalid container 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container, Vessel, "Test 15mL Tube 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container, Vessel, "Test 15mL Tube 2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container, Vessel, "Test high-recovery container for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate 2 (Sodium phosphate solid) for ExperimentHPLC test" <> $SessionUUID],
					Object[Container,Plate,"Plate for low volume sample for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container,Plate,"Plate for sample 4 ExperimentHPLC tests" <> $SessionUUID],

					Object[Protocol,HPLC,"Test Template Protocol for ExperimentHPLC" <> $SessionUUID],
					Object[Protocol, HPLC, "My special HPLC New protocol name" <> $SessionUUID],

					Model[Item, Column, "Test storage buffer column model for ExperimentHPLC" <> $SessionUUID],
					Model[Item, Column, "Test cartridge-protected column model for ExperimentHPLC" <> $SessionUUID],
					Model[Item, Column, "Test cartridge-protected column model for ExperimentHPLC (2)" <> $SessionUUID],
					Object[Item, Column, "Test cartridge-protected column object for ExperimentHPLC" <> $SessionUUID],
					Object[Item, Column, "Test cartridge-protected column object for ExperimentHPLC (2)" <> $SessionUUID],
					Model[Item, Column, "Test over-sized column model for ExperimentHPLC" <> $SessionUUID],
					Model[Item, Column, "Test high flow rate column model for ExperimentHPLC" <> $SessionUUID],
					Model[Item, Column, "Test cartridge guard column model for ExperimentHPLC" <> $SessionUUID],
					Object[Item, Column, "Test cartridge guard column object for ExperimentHPLC" <> $SessionUUID],
					Model[Item, Cartridge, Column, "Test model cartridge for ExperimentHPLC" <> $SessionUUID],
					Model[Item, Cartridge, Column,"Test model cartridge for ExperimentHPLC (2)" <> $SessionUUID],
					Object[Item, Cartridge, Column,"Test cartridge for ExperimentHPLC" <> $SessionUUID],
					Object[Item, Cartridge, Column,"Test cartridge for ExperimentHPLC (2)" <> $SessionUUID],

					Object[Method, Gradient, "Test High Temperature Gradient Method for ExperimentHPLC tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];
		Off[Error::IncompatibleMaterials];
		Module[{firstSetUpload, samples, plate, plateCMU, largeContainer, plate2, tube, plate3, existingNamedProtocol, storageBufferColumn, cartridgeColumn, largeColumn, highFlowRateColumn, gradientMethod,
			 parentColumnObject, parentColumnObject2, guardColumnModel, guardColumnObject, guardCartridgeModel,
			guardCartridgeObject, templateHPLCProtocol, plate4, highRecoveryVial, column2, tube50mL1,tube50mL2,tube15mL1,tube15mL2},

			firstSetUpload = List[
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Site -> Link[$Site],
					DeveloperObject->True,
					Name -> "Test plate 1 for ExperimentHPLC tests" <> $SessionUUID
				],
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Site -> Link[Object[Container,Site,"ECL-CMU"]],
					DeveloperObject->True,
					Name -> "Test plate CMU-1 for ExperimentHPLC tests" <> $SessionUUID
				],
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Site -> Link[$Site],
					DeveloperObject->True,
					Name -> "Test plate 2 (Sodium phosphate solid) for ExperimentHPLC test" <> $SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "250mL Glass Bottle"], Objects],
					Site -> Link[$Site],
					DeveloperObject->True,
					Name -> "Test large container 1 for ExperimentHPLC tests" <> $SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "2mL Tube"], Objects],
					Site -> Link[$Site],
					DeveloperObject->True,
					Name -> "Test invalid container 1 for ExperimentHPLC tests" <> $SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel,"1mL HPLC Vial (total recovery)"], Objects],
					Site -> Link[$Site],
					DeveloperObject->True,
					Name -> "Test high-recovery container for ExperimentHPLC tests" <> $SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Tube"], Objects],
					Site -> Link[$Site],
					DeveloperObject->True,
					Name -> "Test 50mL Tube 1 for ExperimentHPLC tests" <> $SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "50mL Light Sensitive Centrifuge Tube"], Objects],
					Site -> Link[$Site],
					DeveloperObject->True,
					Name -> "Test 50mL Tube 2 for ExperimentHPLC tests" <> $SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "15mL Tube"], Objects],
					Site -> Link[$Site],
					DeveloperObject->True,
					Name -> "Test 15mL Tube 1 for ExperimentHPLC tests" <> $SessionUUID
				],
				Association[
					Type -> Object[Container, Vessel],
					Model -> Link[Model[Container, Vessel, "15mL Light Sensitive Centrifuge Tube"], Objects],
					Site -> Link[$Site],
					DeveloperObject->True,
					Name -> "Test 15mL Tube 2 for ExperimentHPLC tests" <> $SessionUUID
				],
				Association[
					Type -> Object[Protocol, HPLC],
					Name -> "My special HPLC New protocol name" <> $SessionUUID
				],
				Association[
					Type -> Object[Container,Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],
					Site -> Link[$Site],
					DeveloperObject->True,
					Name -> "Plate for low volume sample for ExperimentHPLC tests" <> $SessionUUID
				],
				Association[
					Type -> Object[Container,Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"],Objects],
					Site -> Link[$Site],
					DeveloperObject->True,
					Name -> "Plate for sample 4 ExperimentHPLC tests" <> $SessionUUID
				],
				<|
					DeveloperObject -> True,
					Name -> "Test storage buffer column model for ExperimentHPLC" <> $SessionUUID,
					ChromatographyType -> HPLC,
					SeparationMode -> ReversePhase,
					ColumnType -> Analytical,
					Diameter -> Quantity[4.5`, "Millimeters"],
					Dimensions -> {Quantity[0.195`, "Meters"], Quantity[0.01`, "Meters"], Quantity[0.01`, "Meters"]},
					Expires -> True,
					FunctionalGroup -> C18,
					MaxFlowRate -> Quantity[2.`, ("Milliliters") / ("Minutes")],
					MaxNumberOfUses -> 10000,
					MaxpH -> 9.`,
					MaxPressure -> Quantity[8700.`, ("PoundsForce") / ("Inches")^2],
					MaxTemperature -> Quantity[90.`, "DegreesCelsius"],
					MinFlowRate -> Quantity[1.`, ("Milliliters") / ("Minutes")],
					MinpH -> 1.5`,
					MinPressure -> Quantity[0.`, ("PoundsForce") / ("Inches")^2],
					NominalFlowRate -> Quantity[1.`, ("Milliliters") / ("Minutes")],
					PackingMaterial -> AerisCoreShell,
					PackingType -> Prepacked,
					ParticleSize -> Quantity[3.6`, "Micrometers"],
					PoreSize -> Quantity[100.`, "Angstroms"],
					Reusable -> True,
					Type -> Model[Item, Column],
					Replace[WettedMaterials] -> {AerisCoreShell},
					StorageBuffer -> Link[Model[Sample, StockSolution, "20% Methanol in MilliQ Water"]]
				|>,
				<|
					DeveloperObject -> True,
					Name -> "Test cartridge-protected column model for ExperimentHPLC" <> $SessionUUID,
					ChromatographyType -> HPLC,
					SeparationMode -> ReversePhase,
					ColumnType -> Analytical,
					Diameter -> Quantity[4.5`, "Millimeters"],
					Dimensions -> {Quantity[0.195`, "Meters"], Quantity[0.01`, "Meters"], Quantity[0.01`, "Meters"]},
					Expires -> True,
					FunctionalGroup -> C18,
					MaxFlowRate -> Quantity[2.`, ("Milliliters") / ("Minutes")],
					MaxNumberOfUses -> 10000,
					MaxpH -> 9.`,
					MaxPressure -> Quantity[8700.`, ("PoundsForce") / ("Inches")^2],
					MaxTemperature -> Quantity[90.`, "DegreesCelsius"],
					MinFlowRate -> Quantity[1.`, ("Milliliters") / ("Minutes")],
					MinpH -> 1.5`,
					MinPressure -> Quantity[0.`, ("PoundsForce") / ("Inches")^2],
					NominalFlowRate -> Quantity[1.`, ("Milliliters") / ("Minutes")],
					PackingMaterial -> AerisCoreShell,
					PackingType -> Prepacked,
					ParticleSize -> Quantity[3.6`, "Micrometers"],
					PoreSize -> Quantity[100.`, "Angstroms"],
					Reusable -> True,
					Type -> Model[Item, Column],
					Replace[WettedMaterials] -> {AerisCoreShell}
				|>,
				<|
					DeveloperObject -> True,
					Name -> "Test cartridge-protected column model for ExperimentHPLC (2)" <> $SessionUUID,
					ChromatographyType -> HPLC,
					SeparationMode -> ReversePhase,
					ColumnType -> Analytical,
					Diameter -> Quantity[4.5`, "Millimeters"],
					Dimensions -> {Quantity[0.195`, "Meters"], Quantity[0.01`, "Meters"], Quantity[0.01`, "Meters"]},
					Expires -> True,
					FunctionalGroup -> C18,
					MaxFlowRate -> Quantity[5.`, ("Milliliters") / ("Minutes")],
					MaxNumberOfUses -> 10000,
					MaxpH -> 9.`,
					MaxPressure -> Quantity[8700.`, ("PoundsForce") / ("Inches")^2],
					MaxTemperature -> Quantity[90.`, "DegreesCelsius"],
					MinFlowRate -> Quantity[1.`, ("Milliliters") / ("Minutes")],
					MinpH -> 1.5`,
					MinPressure -> Quantity[0.`, ("PoundsForce") / ("Inches")^2],
					NominalFlowRate -> Quantity[1.`, ("Milliliters") / ("Minutes")],
					PackingMaterial -> AerisCoreShell,
					PackingType -> Prepacked,
					ParticleSize -> Quantity[3.6`, "Micrometers"],
					PoreSize -> Quantity[100.`, "Angstroms"],
					Reusable -> True,
					Type -> Model[Item, Column],
					Replace[WettedMaterials] -> {AerisCoreShell}
				|>,
				<|
					DeveloperObject -> True,
					Name -> "Test over-sized column model for ExperimentHPLC" <> $SessionUUID,
					ChromatographyType -> HPLC,
					SeparationMode -> ReversePhase,
					ColumnType -> Analytical,
					Diameter -> Quantity[10, "Millimeters"],
					Dimensions -> {Quantity[0.5, "Meters"], Quantity[0.01`, "Meters"], Quantity[0.01`, "Meters"]},
					Expires -> True,
					FunctionalGroup -> C18,
					MaxFlowRate -> Quantity[2.`, ("Milliliters") / ("Minutes")],
					MaxNumberOfUses -> 10000,
					MaxpH -> 9.`,
					MaxPressure -> Quantity[8700.`, ("PoundsForce") / ("Inches")^2],
					MaxTemperature -> Quantity[90.`, "DegreesCelsius"],
					MinFlowRate -> Quantity[1.`, ("Milliliters") / ("Minutes")],
					MinpH -> 1.5`,
					MinPressure -> Quantity[0.`, ("PoundsForce") / ("Inches")^2],
					NominalFlowRate -> Quantity[1.`, ("Milliliters") / ("Minutes")],
					PackingMaterial -> AerisCoreShell,
					PackingType -> Prepacked,
					ParticleSize -> Quantity[3.6`, "Micrometers"],
					PoreSize -> Quantity[100.`, "Angstroms"],
					Reusable -> True,
					Type -> Model[Item, Column],
					Replace[WettedMaterials] -> {AerisCoreShell}
				|>,
				<|
					DeveloperObject -> True,
					Name -> "Test high flow rate column model for ExperimentHPLC" <> $SessionUUID,
					ChromatographyType -> HPLC,
					SeparationMode -> ReversePhase,
					ColumnType -> Preparative,
					Diameter -> Quantity[10, "Millimeters"],
					Dimensions -> {Quantity[0.1, "Meters"], Quantity[0.01`, "Meters"], Quantity[0.01`, "Meters"]},
					Expires -> True,
					FunctionalGroup -> C18,
					MaxFlowRate -> Quantity[100.`, ("Milliliters") / ("Minutes")],
					MaxNumberOfUses -> 10000,
					MaxpH -> 9.`,
					MaxPressure -> Quantity[8700.`, ("PoundsForce") / ("Inches")^2],
					MaxTemperature -> Quantity[90.`, "DegreesCelsius"],
					MinFlowRate -> Quantity[1.`, ("Milliliters") / ("Minutes")],
					MinpH -> 1.5`,
					MinPressure -> Quantity[0.`, ("PoundsForce") / ("Inches")^2],
					NominalFlowRate -> Quantity[1.`, ("Milliliters") / ("Minutes")],
					PackingMaterial -> AerisCoreShell,
					PackingType -> Prepacked,
					ParticleSize -> Quantity[3.6`, "Micrometers"],
					PoreSize -> Quantity[100.`, "Angstroms"],
					Reusable -> True,
					Type -> Model[Item, Column],
					Replace[WettedMaterials] -> {AerisCoreShell}
				|>,
				<|
					BufferA -> Link[Model[Sample, "id:jLq9jXY4kkYz"]],
					BufferB -> Link[Model[Sample, "id:9RdZXvKBeeKZ"]],
					BufferC -> Link[Model[Sample, "id:9RdZXvKBeeKZ"]],
					BufferD -> Link[Model[Sample, "id:jLq9jXY4kkYz"]],
					Replace[Gradient] -> {
						{
							Quantity[0., "Minutes"],
							Quantity[75., "Percent"],
							Quantity[0., "Percent"],
							Quantity[0., "Percent"],
							Quantity[25., "Percent"],
							Quantity[0., "Percent"],
							Quantity[0., "Percent"],
							Quantity[0., "Percent"],
							Quantity[0., "Percent"],
							Quantity[0.4, "Milliliters" / "Minutes"]
						},
						{
							Quantity[20., "Minutes"],
							Quantity[75., "Percent"],
							Quantity[0., "Percent"],
							Quantity[0., "Percent"],
							Quantity[25., "Percent"],
							Quantity[0., "Percent"],
							Quantity[0., "Percent"],
							Quantity[0., "Percent"],
							Quantity[0., "Percent"],
							Quantity[0.4, "Milliliters" / "Minutes"]
						}
					},
					GradientA -> {
						{Quantity[0., "Minutes"], Quantity[75., "Percent"]},
						{Quantity[20., "Minutes"], Quantity[75, "Percent"]}
					},
					GradientB -> {
						{Quantity[0., "Minutes"], Quantity[0., "Percent"]},
						{Quantity[20., "Minutes"], Quantity[0., "Percent"]}
					},
					GradientC -> {
						{Quantity[0., "Minutes"], Quantity[0., "Percent"]},
						{Quantity[20., "Minutes"], Quantity[0., "Percent"]}
					},
					GradientD -> {
						{Quantity[0., "Minutes"], Quantity[25., "Percent"]},
						{Quantity[20., "Minutes"], Quantity[25., "Percent"]}
					},
					Temperature -> Quantity[100., "DegreesCelsius"],
					Type -> Object[Method, Gradient],
					DeveloperObject -> False,
					Name -> "Test High Temperature Gradient Method for ExperimentHPLC tests" <> $SessionUUID
				|>
			];

			{plate,plateCMU,plate2,largeContainer,tube,highRecoveryVial,tube50mL1,tube50mL2,tube15mL1,tube15mL2,existingNamedProtocol,plate3,plate4,storageBufferColumn,cartridgeColumn,column2,largeColumn,highFlowRateColumn,gradientMethod}=Upload[firstSetUpload];

			samples = UploadSample[
				{
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, "Dibasic Sodium Phosphate"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"],
					Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"]
				},
				{
					{"A1", plate},
					{"A2", plate},
					{"A3", plate},
					{"A1", plateCMU},
					{"A2", plateCMU},
					{"A3", plateCMU},
					{"A1", largeContainer},
					{"A1", tube},
					{"A1", highRecoveryVial},
					{"A1", plate2},
					{"A1", plate3},
					{"A1", plate4},
					{"A1", tube50mL1},
					{"A1", tube50mL2},
					{"A1", tube15mL1},
					{"A1", tube15mL2}
				},
				InitialAmount -> {
					500 Microliter,
					500 Microliter,
					500 Microliter,
					500 Microliter,
					500 Microliter,
					500 Microliter,
					200 Milliliter,
					2000 Microliter,
					1000 Microliter,
					50 Milligram,
					300 Microliter,
					300 Microliter,
					25 Milliliter,
					25 Milliliter,
					10 Milliliter,
					10 Milliliter
				},
				Name -> {
					"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID,
					"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID,
					"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID,
					"Test Sample CMU-1 for ExperimentHPLC tests" <> $SessionUUID,
					"Test Sample CMU-2 for ExperimentHPLC tests" <> $SessionUUID,
					"Test Sample CMU-3 for ExperimentHPLC tests" <> $SessionUUID,
					"Large Container Sample for ExperimentHPLC" <> $SessionUUID,
					"Test sample for invalid container for ExperimentHPLC tests" <> $SessionUUID,
					"Test Sample 5 for ExperimentHPLC tests (high recovery vial)" <> $SessionUUID,
					"Test invalid sample (solid sample) for ExperimentHPLC tests" <> $SessionUUID,
					"Test low volume sample for ExperimentHPLC tests" <> $SessionUUID,
					"Test Sample 4 for ExperimentHPLC tests" <> $SessionUUID,
					"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID,
					"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID,
					"Test Sample 8 for ExperimentHPLC tests (15mL Tube)" <> $SessionUUID,
					"Test Sample 9 for ExperimentHPLC tests (15mL Tube)" <> $SessionUUID
				}
			];
			Upload[<|Object -> #, DeveloperObject -> True|>& /@ samples];

			(*create our severed sample*)
			Upload[
				{
					Association[
						Object -> Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
						DeveloperObject-> True,
						Replace[Composition] -> {
							{100 VolumePercent, Link[Model[Molecule, "Water"]], Now},
							{50 Micromolar, Link[Model[Molecule, "Uracil"]], Now}
						}
					],
					Association[
						Object -> Object[Sample,"Test Sample 4 for ExperimentHPLC tests" <> $SessionUUID],
						Model -> Null
					],
					<|
						DeveloperObject -> True,
						Name -> "Test cartridge-protected column object for ExperimentHPLC" <> $SessionUUID,
						Model -> Link[Model[Item, Column, "Test cartridge-protected column model for ExperimentHPLC" <> $SessionUUID], Objects],
						Type -> Object[Item, Column],
						Status -> Available,
						Site -> Link[$Site]
					|>,
					<|
						DeveloperObject -> True,
						Name -> "Test cartridge-protected column object for ExperimentHPLC (2)" <> $SessionUUID,
						Model -> Link[Model[Item, Column, "Test cartridge-protected column model for ExperimentHPLC" <> $SessionUUID], Objects],
						Type -> Object[Item, Column],
						Status -> Available,
						Site -> Link[$Site]
					|>,
					<|
						ChromatographyType -> HPLC,
						SeparationMode -> ReversePhase,
						ColumnType -> Guard,
						Dimensions -> {Quantity[0.055`, "Meters"], Quantity[0.015`, "Meters"], Quantity[0.015`, "Meters"]},
						MaxFlowRate -> Quantity[2.`, ("Milliliters") / ("Minutes")],
						MaxNumberOfUses -> 1000,
						MaxpH -> 10.`,
						MaxPressure -> Quantity[3400.`, ("PoundsForce") / ("Inches")^2],
						MinFlowRate -> Quantity[0.05`, ("Milliliters") / ("Minutes")],
						MinpH -> 1.5`,
						MinPressure -> Quantity[1.`, ("PoundsForce") / ("Inches")^2],
						Name -> "Test cartridge guard column model for ExperimentHPLC" <> $SessionUUID,
						DeveloperObject -> True,
						NominalFlowRate -> Quantity[1.`, ("Milliliters") / ("Minutes")],
						PackingType -> Cartridge,
						InternalLength -> Quantity[0.22`, "Meters"],
						InternalDiameter -> Quantity[12.`, "Millimeters"],

						ParticleSize -> Quantity[3.`, "Micrometers"],
						Replace[ProtectedColumns] -> {Link[Model[Item, Column, "Test cartridge-protected column model for ExperimentHPLC" <> $SessionUUID], PreferredGuardColumn]},
						Reusable -> True,
						Type -> Model[Item, Column]
					|>,
					<|
						Name -> "Test model cartridge for ExperimentHPLC" <> $SessionUUID,
						DeveloperObject -> True,
						SeparationMode -> ReversePhase,
						Diameter -> Quantity[0.115`, "Meters"],
						CartridgeLength -> Quantity[0.215`, "Meters"],
						Dimensions -> {Quantity[0.215`, "Meters"], Quantity[0.115`, "Meters"], Quantity[0.115`, "Meters"]},
						MaxPressure -> Quantity[8700.`, ("PoundsForce") / ("Inches")^2],
						Expires -> True,
						FunctionalGroup -> C18,
						MaxNumberOfUses -> 100,
						Reusable -> True,
						Type -> Model[Item, Cartridge, Column]
					|>,
					<|
						Name -> "Test model cartridge for ExperimentHPLC (2)" <> $SessionUUID,
						DeveloperObject -> True,
						SeparationMode -> ReversePhase,
						Diameter -> Quantity[11.5`, "Millimeters"],
						CartridgeLength -> Quantity[0.218`, "Meters"],
						Dimensions -> {Quantity[0.218`, "Meters"], Quantity[0.115`, "Meters"], Quantity[0.115`, "Meters"]},
						MaxPressure -> Quantity[8700.`, ("PoundsForce") / ("Inches")^2],
						Expires -> True,
						FunctionalGroup -> C18,
						MaxNumberOfUses -> 100,
						Reusable -> True,
						Type -> Model[Item, Cartridge, Column]
					|>
				}
			];


			Upload[
				List[
					<|
						DeveloperObject -> True,
						Name -> "Test cartridge guard column object for ExperimentHPLC" <> $SessionUUID,
						Model -> Link[Model[Item, Column, "Test cartridge guard column model for ExperimentHPLC" <> $SessionUUID], Objects],
						Type -> Object[Item, Column],
						Status -> Available,
						Site -> Link[$Site]
					|>,
					<|
						Name -> "Test cartridge for ExperimentHPLC" <> $SessionUUID,
						DeveloperObject -> True,
						Model -> Link[Model[Item, Cartridge, Column, "Test model cartridge for ExperimentHPLC" <> $SessionUUID], Objects],
						Status -> Available,
						Type -> Object[Item, Cartridge, Column],
						Site -> Link[$Site]
					|>,
					<|
						Name -> "Test cartridge for ExperimentHPLC (2)" <> $SessionUUID,
						DeveloperObject -> True,
						Model -> Link[Model[Item, Cartridge, Column,"Test model cartridge for ExperimentHPLC (2)" <> $SessionUUID], Objects],
						Status -> Available,
						Type -> Object[Item, Cartridge, Column],
						Site -> Link[$Site]
					|>,
					Association[
						Object -> Model[Item, Cartridge, Column,"Test model cartridge for ExperimentHPLC" <> $SessionUUID],
						PreferredGuardColumn->Link@Model[Item,Column,"Test cartridge guard column model for ExperimentHPLC" <> $SessionUUID]
					],
					Association[
						Object -> Model[Item, Cartridge, Column,"Test model cartridge for ExperimentHPLC (2)" <> $SessionUUID],
						PreferredGuardColumn->Link@Model[Item,Column,"Test cartridge guard column model for ExperimentHPLC" <> $SessionUUID]
					],
					Association[
						Object -> Model[Item,Column,"Test cartridge guard column model for ExperimentHPLC" <> $SessionUUID],
						PreferredGuardCartridge->Link@Model[Item, Cartridge, Column,"Test model cartridge for ExperimentHPLC" <> $SessionUUID]
					]
				]
			];
			(*Create a protocol that we'll use for template testing*)
			Block[{$PersonID = Object[User, "Test user for notebook-less test protocols"]},
(*				Create a protocol that we'll use for template testing*)
				templateHPLCProtocol = ExperimentHPLC[samples[[1;;3]],
					Name -> "Test Template Protocol for ExperimentHPLC" <> $SessionUUID,
					NebulizerGasPressure -> 60 PSI,
					DriftTubeTemperature -> 55 Celsius
				]
			];

		];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];
		On[Error::IncompatibleMaterials];
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Sample,"Test Sample 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 3 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 4 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample 5 for ExperimentHPLC tests (high recovery vial)" <> $SessionUUID],
					Object[Sample,"Test Sample 6 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],
					Object[Sample,"Test Sample 7 for ExperimentHPLC tests (50mL Tube)" <> $SessionUUID],
					Object[Sample,"Test Sample 8 for ExperimentHPLC tests (15mL Tube)" <> $SessionUUID],
					Object[Sample,"Test Sample 9 for ExperimentHPLC tests (15mL Tube)" <> $SessionUUID],
					Object[Sample,"Large Container Sample for ExperimentHPLC" <> $SessionUUID],
					Object[Sample,"Test sample for invalid container for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test low volume sample for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test invalid sample (solid sample) for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample CMU-1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample CMU-2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Sample,"Test Sample CMU-3 for ExperimentHPLC tests" <> $SessionUUID],

					Object[Container,Plate,"Test plate 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate CMU-1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container, Vessel, "Test large container 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container, Vessel, "Test invalid container 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container, Vessel, "Test 50mL Tube 2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container, Vessel, "Test 15mL Tube 1 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container, Vessel, "Test 15mL Tube 2 for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container, Vessel, "Test high-recovery container for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate 2 (Sodium phosphate solid) for ExperimentHPLC test" <> $SessionUUID],
					Object[Container,Plate,"Plate for low volume sample for ExperimentHPLC tests" <> $SessionUUID],
					Object[Container,Plate,"Plate for sample 4 ExperimentHPLC tests" <> $SessionUUID],

					Object[Protocol,HPLC,"Test Template Protocol for ExperimentHPLC" <> $SessionUUID],
					Object[Protocol, HPLC, "My special HPLC New protocol name" <> $SessionUUID],

					Model[Item, Column, "Test storage buffer column model for ExperimentHPLC" <> $SessionUUID],
					Model[Item, Column, "Test cartridge-protected column model for ExperimentHPLC" <> $SessionUUID],
					Model[Item, Column, "Test cartridge-protected column model for ExperimentHPLC (2)" <> $SessionUUID],
					Object[Item, Column, "Test cartridge-protected column object for ExperimentHPLC" <> $SessionUUID],
					Object[Item, Column, "Test cartridge-protected column object for ExperimentHPLC (2)" <> $SessionUUID],
					Model[Item, Column, "Test over-sized column model for ExperimentHPLC" <> $SessionUUID],
					Model[Item, Column, "Test high flow rate column model for ExperimentHPLC" <> $SessionUUID],
					Model[Item, Column, "Test cartridge guard column model for ExperimentHPLC" <> $SessionUUID],
					Object[Item, Column, "Test cartridge guard column object for ExperimentHPLC" <> $SessionUUID],
					Model[Item, Cartridge, Column, "Test model cartridge for ExperimentHPLC" <> $SessionUUID],
					Model[Item, Cartridge, Column,"Test model cartridge for ExperimentHPLC (2)" <> $SessionUUID],
					Object[Item, Cartridge, Column,"Test cartridge for ExperimentHPLC" <> $SessionUUID],
					Object[Item, Cartridge, Column,"Test cartridge for ExperimentHPLC (2)" <> $SessionUUID],

					Object[Method, Gradient, "Test High Temperature Gradient Method for ExperimentHPLC tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
	),
	Stubs:>{$PersonID=Object[User,"Test user for notebook-less test protocols"]}
];



(* ::Subsubsection:: *)
(*ExperimentHPLCOptions*)


DefineTests[ExperimentHPLCOptions,
	{
		Example[
			{Basic,"Automatically resolve of all options for sample:"},
			ExperimentHPLCOptions[{
				Object[Sample,"Test Sample 1 for ExperimentHPLCOptions tests"<>$SessionUUID],
				Object[Sample,"Test Sample 2 for ExperimentHPLCOptions tests"<>$SessionUUID],
				Object[Sample,"Test Sample 3 for ExperimentHPLCOptions tests"<>$SessionUUID]
			},
				OutputFormat->List
			],
			{Rule[_Symbol,Except[Automatic | $Failed]]..}
		],
		Example[
			{Basic,"Specify the injection volume for each sample:"},
			ExperimentHPLCOptions[{
				Object[Sample,"Test Sample 1 for ExperimentHPLCOptions tests"<>$SessionUUID],
				Object[Sample,"Test Sample 2 for ExperimentHPLCOptions tests"<>$SessionUUID],
				Object[Sample,"Test Sample 3 for ExperimentHPLCOptions tests"<>$SessionUUID]
			},
				InjectionVolume->100 Micro Liter,
				OutputFormat->List
			],
			{Rule[_Symbol,Except[Automatic | $Failed]]..}
		],
		Example[
			{Basic,"Resolve fraction collection fractions:"},
			ExperimentHPLCOptions[{
				Object[Sample,"Test Sample 1 for ExperimentHPLCOptions tests"<>$SessionUUID],
				Object[Sample,"Test Sample 2 for ExperimentHPLCOptions tests"<>$SessionUUID],
				Object[Sample,"Test Sample 3 for ExperimentHPLCOptions tests"<>$SessionUUID]
			},
				Scale->SemiPreparative,
				OutputFormat->List
			],
			{Rule[_Symbol,Except[Automatic | $Failed]]..}
		],
		Example[
			{Options,OutputFormat,"Return the resolved options for each sample as a list:"},
			ExperimentHPLCOptions[{
				Object[Sample,"Test Sample 1 for ExperimentHPLCOptions tests"<>$SessionUUID],
				Object[Sample,"Test Sample 2 for ExperimentHPLCOptions tests"<>$SessionUUID],
				Object[Sample,"Test Sample 3 for ExperimentHPLCOptions tests"<>$SessionUUID]
			},
				OutputFormat->List
			],
			{Rule[_Symbol,Except[Automatic | $Failed]]..}
		],
		Example[
			{Options,OutputFormat,"Return the resolved options for each sample as a table:"},
			ExperimentHPLCOptions[{
				Object[Sample,"Test Sample 1 for ExperimentHPLCOptions tests"<>$SessionUUID],
				Object[Sample,"Test Sample 2 for ExperimentHPLCOptions tests"<>$SessionUUID],
				Object[Sample,"Test Sample 3 for ExperimentHPLCOptions tests"<>$SessionUUID]
			}],
			Graphics_
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		(*delete the old objects in case they're still in the database*)
		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Sample,"Test Sample 1 for ExperimentHPLCOptions tests"<>$SessionUUID],
					Object[Sample,"Test Sample 2 for ExperimentHPLCOptions tests"<>$SessionUUID],
					Object[Sample,"Test Sample 3 for ExperimentHPLCOptions tests"<>$SessionUUID],
					Object[Container,Plate,"Test plate 1 for ExperimentHPLCOptions tests"<>$SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{plate,samples},
			plate = Upload[
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Site -> Link[$Site],
					Name -> "Test plate 1 for ExperimentHPLCOptions tests" <> $SessionUUID
				]
			];
			samples = ECL`InternalUpload`UploadSample[
				{Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"], Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"], Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"]},
				{{"A1", plate}, {"A2", plate}, {"A3", plate}},
				InitialAmount -> 500 Microliter,
				Name -> {
					"Test Sample 1 for ExperimentHPLCOptions tests"<>$SessionUUID,
					"Test Sample 2 for ExperimentHPLCOptions tests"<>$SessionUUID,
					"Test Sample 3 for ExperimentHPLCOptions tests"<>$SessionUUID
				}
			]

		];
		Off[Error::IncompatibleMaterials];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Sample,"Test Sample 1 for ExperimentHPLCOptions tests"<>$SessionUUID],
					Object[Sample,"Test Sample 2 for ExperimentHPLCOptions tests"<>$SessionUUID],
					Object[Sample,"Test Sample 3 for ExperimentHPLCOptions tests"<>$SessionUUID],
					Object[Container,Plate,"Test plate 1 for ExperimentHPLCOptions tests"]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		On[Error::IncompatibleMaterials];
	)
];


(* ::Subsubsection:: *)
(*ExperimentHPLCPreview*)



DefineTests[ExperimentHPLCPreview,
	{
		Example[
			{Basic,"Generate a preview for an HPLC protocol:"},
			ExperimentHPLCPreview[{
				Object[Sample,"Test Sample 1 for ExperimentHPLCPreview tests" <> $SessionUUID],
				Object[Sample,"Test Sample 2 for ExperimentHPLCPreview tests" <> $SessionUUID],
				Object[Sample,"Test Sample 3 for ExperimentHPLCPreview tests" <> $SessionUUID]
			}],
			Null
		],
		Example[
			{Basic,"Generate a preview for a protocol that specifies the injection volume for each sample:"},
			ExperimentHPLCPreview[{
				Object[Sample,"Test Sample 1 for ExperimentHPLCPreview tests" <> $SessionUUID],
				Object[Sample,"Test Sample 2 for ExperimentHPLCPreview tests" <> $SessionUUID],
				Object[Sample,"Test Sample 3 for ExperimentHPLCPreview tests" <> $SessionUUID]
			},InjectionVolume->100 Micro Liter],
			Null
		],
		Example[
			{Basic,"Preview will always be Null:"},
			ExperimentHPLCPreview[{
				Object[Sample,"Test Sample 1 for ExperimentHPLCPreview tests" <> $SessionUUID],
				Object[Sample,"Test Sample 2 for ExperimentHPLCPreview tests" <> $SessionUUID],
				Object[Sample,"Test Sample 3 for ExperimentHPLCPreview tests" <> $SessionUUID]
			},Scale->SemiPreparative],
			Null
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Sample,"Test Sample 1 for ExperimentHPLCPreview tests" <> $SessionUUID],
					Object[Sample,"Test Sample 2 for ExperimentHPLCPreview tests" <> $SessionUUID],
					Object[Sample,"Test Sample 3 for ExperimentHPLCPreview tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate 1 for ExperimentHPLCPreview tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{plate,samples},
			plate = Upload[
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Site -> Link[$Site],
					Name -> "Test plate 1 for ExperimentHPLCPreview tests" <> $SessionUUID
				]
			];
			samples = ECL`InternalUpload`UploadSample[
				{Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"], Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"], Model[Sample, StockSolution, Standard, "Small Molecule HPLC Standard Mix"]},
				{{"A1", plate}, {"A2", plate}, {"A3", plate}},
				InitialAmount -> 500 Microliter,
				Name -> {
					"Test Sample 1 for ExperimentHPLCPreview tests" <> $SessionUUID,
					"Test Sample 2 for ExperimentHPLCPreview tests" <> $SessionUUID,
					"Test Sample 3 for ExperimentHPLCPreview tests" <> $SessionUUID
				}
			]

		];
		Off[Error::IncompatibleMaterials];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Sample,"Test Sample 1 for ExperimentHPLCPreview tests" <> $SessionUUID],
					Object[Sample,"Test Sample 2 for ExperimentHPLCPreview tests" <> $SessionUUID],
					Object[Sample,"Test Sample 3 for ExperimentHPLCPreview tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate 1 for ExperimentHPLCPreview tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		On[Error::IncompatibleMaterials];
	)
];


(* ::Subsubsection:: *)
(*ValidExperimentHPLCQ*)


DefineTests[ValidExperimentHPLCQ,
	{
		Example[
			{Basic,"Runs checks on all the inputs and option values to ensure an HPLC protocol will be properly generated by ExperimentHPLC:"},
			ValidExperimentHPLCQ[{
				Object[Sample,"Test Sample 1 for ValidExperimentHPLCQ tests" <> $SessionUUID],
				Object[Sample,"Test Sample 2 for ValidExperimentHPLCQ tests" <> $SessionUUID],
				Object[Sample,"Test Sample 3 for ValidExperimentHPLCQ tests" <> $SessionUUID]
			}],
			True
		],
		Example[
			{Basic,"An ExperimentHPLC call is not valid if the Gradient options specify a buffer composition greater than 100%:"},
			ValidExperimentHPLCQ[
				Object[Sample,"Test Sample 1 for ValidExperimentHPLCQ tests" <> $SessionUUID],
				InjectionVolume -> 5 Microliter,
				GradientA -> 60 Percent,
				GradientB -> 60 Percent
			],
			False
		],
		Example[
			{Options,Verbose,"Display all tests:"},
			ValidExperimentHPLCQ[{
				Object[Sample,"Test Sample 1 for ValidExperimentHPLCQ tests" <> $SessionUUID],
				Object[Sample,"Test Sample 2 for ValidExperimentHPLCQ tests" <> $SessionUUID],
				Object[Sample,"Test Sample 3 for ValidExperimentHPLCQ tests" <> $SessionUUID]
			},InjectionVolume->100 Micro Liter,Verbose->True],
			True,
			TimeConstraint -> 240
		],
		Example[
			{Options,OutputFormat,"Toggle the output format of the tests to output a TestSummary:"},
			ValidExperimentHPLCQ[{
				Object[Sample,"Test Sample 1 for ValidExperimentHPLCQ tests" <> $SessionUUID],
				Object[Sample,"Test Sample 2 for ValidExperimentHPLCQ tests" <> $SessionUUID],
				Object[Sample,"Test Sample 3 for ValidExperimentHPLCQ tests" <> $SessionUUID]
			},InjectionVolume->100 Micro Liter,OutputFormat->TestSummary],
			_EmeraldTestSummary
		]
	},
	SymbolSetUp:>(
		Off[Warning::SamplesOutOfStock];
		Off[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Sample,"Test Sample 1 for ValidExperimentHPLCQ tests" <> $SessionUUID],
					Object[Sample,"Test Sample 2 for ValidExperimentHPLCQ tests" <> $SessionUUID],
					Object[Sample,"Test Sample 3 for ValidExperimentHPLCQ tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate 1 for ValidExperimentHPLCQ tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		Module[{plate,samples},
			plate = Upload[
				Association[
					Type -> Object[Container, Plate],
					Model -> Link[Model[Container, Plate, "96-well 2mL Deep Well Plate"], Objects],
					Site -> Link[$Site],
					Name -> "Test plate 1 for ValidExperimentHPLCQ tests" <> $SessionUUID
				]
			];
			samples = ECL`InternalUpload`UploadSample[
				{Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"], Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"], Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"]},
				{{"A1", plate}, {"A2", plate}, {"A3", plate}},
				InitialAmount -> 500 Microliter,
				Name -> {
					"Test Sample 1 for ValidExperimentHPLCQ tests" <> $SessionUUID,
					"Test Sample 2 for ValidExperimentHPLCQ tests" <> $SessionUUID,
					"Test Sample 3 for ValidExperimentHPLCQ tests" <> $SessionUUID
				}
			]

		];
		Off[Error::IncompatibleMaterials];
	),
	SymbolTearDown:>(
		On[Warning::SamplesOutOfStock];
		On[Warning::InstrumentUndergoingMaintenance];

		Module[{objs, existingObjs},
			objs = Quiet[Cases[
				Flatten[{
					Object[Sample,"Test Sample 1 for ValidExperimentHPLCQ tests" <> $SessionUUID],
					Object[Sample,"Test Sample 2 for ValidExperimentHPLCQ tests" <> $SessionUUID],
					Object[Sample,"Test Sample 3 for ValidExperimentHPLCQ tests" <> $SessionUUID],
					Object[Container,Plate,"Test plate 1 for ValidExperimentHPLCQ tests" <> $SessionUUID]
				}],
				ObjectP[]
			]];
			existingObjs = PickList[objs, DatabaseMemberQ[objs]];
			EraseObject[existingObjs, Force -> True, Verbose -> False]
		];
		On[Error::IncompatibleMaterials];
	)
];




(* ::Section:: *)
(*End Test Package*)
