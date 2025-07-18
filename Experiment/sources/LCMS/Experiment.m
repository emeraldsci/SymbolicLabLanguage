(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(* Options *)
(*ExperimentLCMS*)

DefineOptions[ExperimentLCMS,
	Options :> {
		{
			OptionName -> SeparationMode,
			Default -> Automatic,
			Description -> "The category of method used to elicit differential column retention due to interaction between molecules in the mobile phase with those on the stationary phase (column).",
			ResolutionDescription -> "Automatically set to match the Separation Mode listed with the provided column.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> SeparationModeP
			],
			Category -> "General"
		},
		{
			OptionName -> MassAnalyzer,
			Default -> Automatic,
			Description -> "The manner of detection used to resolve and detect molecules. QTOF accelerates ions through an elongated flight tube and separates ions by their flight time (related to mass to charge ratio).",
			ResolutionDescription -> "Is automatically set to the QTOF.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> (QTOF | TripleQuadrupole)
			]
		},
		{
			OptionName -> ChromatographyInstrument,
			Default -> Model[Instrument, HPLC, "Waters Acquity UPLC I-Class PDA"],
			Description -> "The device used to separate molecules from the sample mixture using mobile liquid through an adsorbent column.",
			ResolutionDescription -> "Automatically set to an instrument model that is available for the best MassSpectrometerInstrument.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, HPLC], Object[Instrument, HPLC]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Chromatography",
						"High Pressure Liquid Chromatography (HPLC)"
					}
				}
			],
			Category -> "General"
		},
		{
			OptionName -> MassSpectrometerInstrument,
			Default -> Automatic,
			Description -> "The device used to ionize, separate, fragment (optionally), and detect analyte species.",
			ResolutionDescription->"Is automatically set according to MassAnalyzer: Model[Instrument, MassSpectrometer, \"Xevo G2-XS QTOF\"] for QTOF, Model[Instrument, MassSpectrometer, \"QTRAP 6500\"] for using TripleQuadrupole.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, MassSpectrometer], Object[Instrument, MassSpectrometer]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Mass Spectrometer"
					}
				}
			]
		},
		{
			OptionName -> Detector,
			Default -> {Temperature,Pressure,PhotoDiodeArray},
			Description -> "Additional measurements to employ in concert with MassSpectrometry. Other measurements include: PhotoDiodeArray (measures the absorbance of a range of wavelengths), system Temperature (QTOF only), and system Pressure (QTOF only).",
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> (Temperature|Pressure|PhotoDiodeArray)
				],
				Adder[
					Widget[
						Type -> Enumeration,
						Pattern :> (Temperature|Pressure|PhotoDiodeArray)
					]
				]
			],
			Category->"General"
		},
		{
			OptionName -> Column,
			Default -> Automatic,
			Description -> "The item containing the stationary phase through which the mobile phase and input samples flow. It adsorbs and separates the molecules within the sample based on the properties of the mobile phase, Samples, Column material, and Column Temperature.",
			ResolutionDescription -> "Automatically set to a column model compatible for the instrument selected and specified separation Mode.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, Column], Object[Item, Column]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Liquid Chromatography",
						"HPLC Columns"
					}
				}
			],
			Category -> "Chromatography"
		},
		{
			OptionName -> SecondaryColumn,
			Default -> Automatic,
			Description -> "The additional stationary phase through which the mobile phase and input samples flow. The SecondaryColumn selectively adsorb analytes and is connected to flow path, downstream of the Column.",
			ResolutionDescription -> "If ColumnSelector is specified, set from there; otherwise, set to Null.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, Column], Object[Item, Column]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Liquid Chromatography",
						"HPLC Columns"
					}
				}
			],
			Category -> "Chromatography"
		},
		{
			OptionName -> TertiaryColumn,
			Default -> Automatic,
			Description -> "The additional stationary phase through which the mobile phase and input samples flow. The TertiaryColumn selectively adsorb analytes and is connected to flow path, downstream of the SecondaryColumn.",
			ResolutionDescription -> "If ColumnSelector is specified, set from there; otherwise, set to Null.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, Column], Object[Item, Column]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Liquid Chromatography",
						"HPLC Columns"
					}
				}
			],
			Category -> "Chromatography"
		},
		{
			OptionName -> GuardColumn,
			Default -> Automatic,
			Description -> "The protective device placed in the flow path before the Column in order to adsorb fouling contaminants and, thus, preserve the Column lifetime.",
			ResolutionDescription -> "Automatically set from the column model's PreferredGuardColumn. If Column is Null, GuardColumn is automatically set to Null.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Item, Column], Object[Item, Column], Model[Item, Cartridge, Column], Object[Item, Cartridge, Column]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Liquid Chromatography",
						"HPLC Columns",
						"Guard Columns"
					}
				}
			],
			Category -> "General"
		},
		(* Note ColumnSelector option is in different format in HPLC vs LCMS as no LCMS instruments provide column selector valves as of now *)
		{
			OptionName -> ColumnSelector,
			Default -> Automatic,
			Description -> "The set of all the columns loaded into the Instrument's column selector and referenced in Column, SecondaryColumn, TertiaryColumn. The Serial configuration indicates one fluid line for all the samples, Standard and Blank. The Selector configuration indicates use of a column selector where the column line is programmatically switchable between samples.",
			ResolutionDescription -> "Automatically set to match the values in Column, SecondaryColumn, TertiaryColumn and GuardColumn options.",
			AllowNull -> False,
			Widget -> {
				"Guard Column" -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Item, Column], Object[Item, Column]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Liquid Chromatography",
								"HPLC Columns",
								"Guard Columns"
							}
						}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Automatic | Null]
					]
				],
				"Column" -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Item, Column], Object[Item, Column]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Liquid Chromatography",
								"HPLC Columns"
							}
						}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Automatic | Null]
					]
				],
				"Secondary Column" -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Item, Column], Object[Item, Column]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Liquid Chromatography",
								"HPLC Columns"
							}
						}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Automatic | Null]
					]
				],
				"Tertiary Column" -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Item, Column], Object[Item, Column]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Liquid Chromatography",
								"HPLC Columns"
							}
						}
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Automatic | Null]
					]
				]
			},
			Category -> "Chromatography"
		},
		{
			OptionName -> NumberOfReplicates,
			Default -> Null,
			Description -> "The number of times to repeat measurements on each provided sample(s). If Aliquot -> True, this also indicates the number of times each provided sample will be aliquoted. For experiment samples {A,B,C} if NumberOfReplicates is specified as 3, the order of samples to run on the instrument will be {A,A,A,B,B,B,C,C,C}.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1, 96, 1]
			],
			Category -> "General"
		},
		(* --- Buffers --- *)
		{
			OptionName -> BufferA,
			Default -> Automatic,
			Description -> "A solvent or buffer placed in the 'A' bottle as shown in Figure 2.1.1 of ExperimentLCMS help file, pumped through the instrument as part of the mobile phase, the compositions of which is determined by the GradientA option.",
			ResolutionDescription -> "Automatically set from SeparationMode (e.g. Water buffer if ReversePhase) or the objects specified by the Gradient option.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Liquid Chromatography",
						"Buffer Systems"
					}
				}
			],
			Category -> "Chromatography"
		},
		{
			OptionName -> BufferB,
			Default -> Automatic,
			Description -> "A solvent or buffer placed in the 'B' bottle as shown in Figure 2.1.1 of ExperimentLCMS help file, pumped through the instrument as part of the mobile phase, the compositions of which is determined by the GradientB option.",
			ResolutionDescription -> "Automatically set from SeparationMode (e.g. Acetonitrile buffer if ReversePhase) or the objects specified by the Gradient option.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Liquid Chromatography",
						"Buffer Systems"
					}
				}
			],
			Category -> "Chromatography"
		},
		{
			OptionName -> BufferC,
			Default -> Automatic,
			Description -> "A solvent or buffer placed in the 'C' bottle as shown in Figure 2.1.1 of ExperimentLCMS help file, pumped through the instrument as part of the mobile phase, the compositions of which is determined by the GradientC option.",
			ResolutionDescription -> "Automatically set from SeparationMode or the objects specified by the Gradient option.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Liquid Chromatography",
						"Buffer Systems"
					}
				}
			],
			Category -> "Chromatography"
		},
		{
			OptionName -> BufferD,
			Default -> Automatic,
			Description -> "A solvent or buffer placed in the 'D' bottle as shown in Figure 2.1.1 of ExperimentLCMS help file, pumped through the instrument as part of the mobile phase, the compositions of which is determined by the GradientD option.",
			ResolutionDescription -> "Automatically set from SeparationMode or the objects specified by the Gradient option.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Liquid Chromatography",
						"Buffer Systems"
					}
				}
			],
			Category -> "Chromatography"
		},
		{
			OptionName -> InjectionTable,
			Default -> Automatic,
			Description -> "The order of Sample, Standard and Blank sample injected into the Instrument during measurement and/or collection. This also includes the priming and flushing of the column(s).",
			ResolutionDescription -> "Samples are inserted in the order of the input samples based with the number of replicates. Standard and Blank samples are inserted based on the determination of StandardFrequency and BlankFrequency options. For example, StandardFrequency -> FirstAndLast and BlankFrequency -> Null result in Standard samples injected first, then samples, and then the Standard sample set again at the end. Column priming is inserted at the beginning and repeated according to ColumnPrimeFrequency. Column flushing is inserted at the end.",
			AllowNull -> False,
			Widget -> Adder[
				{
					"Type" -> Widget[
						Type -> Enumeration,
						Pattern :> Standard | Sample | Blank | ColumnPrime | ColumnFlush
					],
					"Sample" -> Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
							ObjectTypes -> {Model[Sample], Object[Sample]},
							OpenPaths -> {
								{
									Object[Catalog, "Root"],
									"Materials"
								}
							}
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
						]
					],
					"InjectionVolume" -> Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Microliter, 50 Microliter, 1 Microliter],
							Units :> Microliter
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
						]
					],
					"Column Temperature" -> Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[30 Celsius, 90 Celsius],
							Units -> Celsius
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Ambient, Automatic]
						]
					],
					"Gradient" -> Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[Method, Gradient]]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic|New]
						]
					],
					"Mass Spectrometry" -> Alternatives[
						Widget[
							Type -> Object,
							Pattern :> ObjectP[Object[Method, MassAcquisition]]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic|New]
						]
					]
				},
				Orientation -> Vertical
			],
			Category -> "Sample Parameters"
		},
		{
			OptionName -> SampleTemperature,
			Default -> Ambient,
			Description -> "The temperature of the chamber in which the samples, Standard, and Blank are stored while waiting for the Injection.",
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[5 Celsius, 40 Celsius],
					Units -> Celsius
				],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ambient]
				]
			],
			Category -> "Sample Parameters"
		},

		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName->ColumnTemperature,
				Default -> Automatic,
				Description -> "The temperature of the Column throughout the measurement and/or collection. If ColumnTemperature is set to Ambient, column oven temperature control is not used. Otherwise, ColumnTemperature is maintained by temperature control of the column oven.",
				ResolutionDescription -> "Automatically set to the corresponding gradient temperature specified in the Gradient option or the column temperature for the sample in the InjectionTable option; otherwise, set to Ambient.",
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[30 Celsius, 90 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Category -> "Sample Parameters"
			},
			{
				OptionName -> InjectionVolume,
				Default -> Automatic,
				Description -> "The physical quantity of sample loaded into the flow path for measurement.",
				ResolutionDescription -> "If InjectionTable is specified, automatically set from the Injection Volume entry for the sample. Otherwise set to 5 Microliter.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter, 50 Microliter],
					Units -> Microliter
				],
				Category -> "Sample Parameters"
			}
		],
		{
			OptionName -> NeedleWashSolution,
			Default -> Automatic,
			Description -> "The solvent used to wash the injection needle before each sample introduction.",
			ResolutionDescription -> "Defaults to Model[Sample, \"Milli-Q water\"] for IonExchange and SizeExclusion SeparationType or Model[Sample, StockSolution, \"20% Methanol in MilliQ Water\"] for other SeparationType.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Reagents"
					}
				},
				PreparedSample->False,
				PreparedContainer->False
			],
			Category -> "Sample Parameters"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",

			(* --- Gradient Specification Parameters --- *)
			{
				OptionName -> GradientA,
				Default -> Automatic,
				Description -> "The composition of BufferA within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientA->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferA in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
				ResolutionDescription -> "If Gradient option is specified, set from it or implicitly determined from the GradientB, GradientC, and GradientD options such that the total amounts to 100%.",
				AllowNull -> False,
				Category -> "Gradient",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Minute, $MaxExperimentTime],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer A Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> GradientB,
				Default -> Automatic,
				Description -> "The composition of BufferB within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientB->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferB in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
				ResolutionDescription -> "If Gradient option is specified, set from it or implicitly determined from the GradientA, GradientC, and GradientD options such that the total amounts to 100%. If no other gradient options are specified, a Buffer B gradient of 10% to 100% over 45 minutes is used.",
				AllowNull -> False,
				Category -> "Gradient",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Minute, $MaxExperimentTime],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer B Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> GradientC,
				Default -> Automatic,
				Description -> "The composition of BufferC within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientC->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferC in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
				ResolutionDescription -> "If Gradient option is specified, set from it or implicitly determined from the GradientA, GradientB, and GradientD options such that the total amounts to 100%.",
				AllowNull -> False,
				Category -> "Gradient",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Minute, $MaxExperimentTime],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer C Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> GradientD,
				Default -> Automatic,
				Description -> "The composition of BufferD within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientD->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferD in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
				ResolutionDescription -> "If Gradient option is specified, set from it or implicitly determined from the GradientA, GradientB, and GradientC options such that the total amounts to 100%.",
				AllowNull -> True,
				Category -> "Gradient",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Minute, $MaxExperimentTime],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer D Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> FlowRate,
				Default -> Automatic,
				Description -> "The net speed of the fluid flowing through the pump inclusive of the composition of BufferA, BufferB, BufferC, and BufferD specified in the gradient options. This speed is linearly interpolated such that consecutive entries of {Time, Flow Rate} will define the intervening fluid speed. For example, {{0 Minute, 0.3 Milliliter/Minute},{30 Minute, 0.5 Milliliter/Minute}} means flow rate of 0.4 Milliliter/Minute at 15 minutes into the run.",
				ResolutionDescription -> "If Gradient option is specified, automatically set from the method given in the Gradient option. If NominalFlowRate of the column model is specified, set to lesser of the NominalFlowRate for each of the columns, guard columns or the instrument's MaxFlowRate. Otherwise set to 1 Milliliter / Minute.",
				AllowNull -> False,
				Category -> "Gradient",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Milliliter / Minute, 2 Milliliter / Minute],
						Units -> CompoundUnit[
							{1, {Milliliter, {Milliliter, Liter}}},
							{-1, {Minute, {Minute, Second}}}
						]
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Minute, $MaxExperimentTime],
								Units -> {Minute, {Second, Minute}}
							],
							"Flow Rate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Milliliter / Minute, 2 Milliliter / Minute],
								Units -> CompoundUnit[
									{1, {Milliliter, {Milliliter, Liter}}},
									{-1, {Minute, {Minute, Second}}}
								]
							]
						},
						Orientation -> Vertical
					]
				]
			}
		],
		{
			OptionName -> MaxAcceleration,
			Default -> Automatic,
			Description -> "When ramping up the FlowRate of solvent through the instrument, the maximum allowed change per time in the FlowRate.",
			ResolutionDescription -> "For Waters instruments, automatically set to the lowest value from Max the Column, Instrument, and GuardColumn models. For other instruments, automatically set to Null. ",
			Category -> "Separation",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 (Milliliter / Minute / Minute)],
				Units -> CompoundUnit[
					{1, {Milliliter, {Milliliter, Liter}}},
					{-2, {Minute, {Minute, Second}}}
				]
			]
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> Gradient,
				Default -> Automatic,
				Description -> "The composition of different specified buffers in BufferA, BufferB, BufferC and BufferD over time in the fluid flow. Specific parameters of a gradient object can be overridden by specific options.",
				ResolutionDescription -> "Automatically set to best meet all the Gradient options (e.g. GradientA, GradientB, GradientC, GradientD, FlowRate).",
				AllowNull -> False,
				Category -> "Gradient",
				Widget -> Alternatives[
					Widget[Type -> Object, Pattern :> ObjectP[Object[Method, Gradient]]],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Minute, $MaxExperimentTime],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer A Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Buffer B Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Buffer C Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Buffer D Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Flow Rate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Milliliter / Minute, 2 Milliliter / Minute],
								Units -> CompoundUnit[
									{1, {Milliliter, {Milliliter, Liter}}},
									{-1, {Minute, {Minute, Second}}}
								]
							]
						},
						Orientation -> Vertical
					]
				]
			}
		],
		{
			OptionName -> Calibrant,
			Default -> Automatic,
			Description -> "The sample with components of known mass-to-charge ratios (m/z) used to calibrate the mass spectrometer. In the chosen ion polarity mode, the calibrant should contain at least 3 masses spread over the mass range of interest.",
			ResolutionDescription -> "If using QTOF as the mass analyzer, set to sodium iodide for peptide samples, cesium iodide for intact protein analysis. For other types of samples, is set to cesium iodide if molecular weight is above 2000 Da, to sodium iodide if molecular weight between 1200 and 2000 Da, and to sodium formate for all others (small molecule range). If using TripleQuadrupole as the mass analyzer, this option will be set automatically based on the first IonMode: Model[Sample, \"id:zGj91a71kXEO\"] or Model[Sample, \"id:bq9LA0JA1YJz\"] for Positive and Negative, respectively.",
			AllowNull -> False,
			Category -> "Mass Analysis",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Mass Spectrometry",
						"Calibrants"
					}
				}
			]
		},
		{
			OptionName -> SecondCalibrant,
			Default -> Automatic,
			Description -> "The additional sample with components of known mass-to-charge ratios (m/z) used to calibrate the mass spectrometer. In the chosen ion polarity mode, the calibrant should contain at least 3 masses spread over the mass range of interest.",
			ResolutionDescription -> "Set to Model[Sample, \"id:zGj91a71kXEO\"] or Model[Sample, \"id:bq9LA0JA1YJz\"] for Positive and Negative, respectively, when using TripleQuadrupole as the MassAnalyzer. Otherwise set to Null.",
			AllowNull -> True,
			Category -> "Mass Analysis",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Mass Spectrometry",
						"Calibrants"
					}
				}
			]
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			(* --- Detector Specific Parameters --- *)
			(*mass spec specific options*)
			{
				OptionName -> Analytes,
				Default -> Automatic,
				Description -> "The compounds of interest that are present in the given samples, used to determine the other settings for the Mass Spectrometer (e.g. MassRange).",
				ResolutionDescription -> "If populated, will resolve to the user-specified Analytes field in the Object[Sample]. Otherwise, will resolve to the larger compounds in the sample, in the order of Proteins, Peptides, Oligomers, then other small molecules. Otherwise, set Null.",
				Category -> "Mass Analysis",
				AllowNull -> True,
				Widget -> Adder[
					Widget[Type -> Object, Pattern :> ObjectP[IdentityModelTypes]]
				]
			},
			{
				OptionName -> IonMode,
				Default -> Automatic,
				Description -> "Indicates if positively or negatively charged ions are analyzed.",
				ResolutionDescription -> "For oligomer samples of the types Peptide, DNA, and other synthetic oligomers, is automatically set to positive ion mode. For other types of samples, defaults to positive ion mode, unless the sample is acid (pH<=5 or pKa<=8).",
				Category -> "Mass Analysis",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> IonModeP
				]
			},
			{
				OptionName -> MassSpectrometryMethod,
				Default -> Automatic,
				Description -> "The previously specified instruction(s) for the analyte ionization, selection, fragmentation, and detection.",
				ResolutionDescription -> "If set in the InjectionTable option, set to that; otherwise, set to New.",
				AllowNull -> True,
				Category -> "Mass Analysis",
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[Method, MassAcquisition]]
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[New]
					]
				]
			},
			{
				OptionName -> ESICapillaryVoltage,
				Default -> Automatic,
				Description -> "The absolute voltage applied to the tip of the stainless steel capillary tubing in order to produce charged droplets. Adjust this voltage to maximize sensitivity. Most compounds are optimized between 0.5 and 3.2 kV in ESI positive ion mode and 0.5 and 2.6 in ESI negative ion mode, but can be altered according to sample type. For low flow applications, best sensitivity will be achieved with a relatively high value in ESI positive (e.g. 3.0 kV), for standard flow UPLC a value of 0.5 kV is typically best for maximum sensitivity.",
				ResolutionDescription -> "Is automatically set according to the flow rate (0-0.02 ml/min -> 3.0 kV, 0.02-0.1 ml/min -> 1.5 kV, >0.1 ml/min -> 0.5 kV).",
				AllowNull -> False,
				Category -> "Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-4 Kilovolt, 5 Kilovolt],
					Units -> {Kilovolt, {Millivolt, Volt, Kilovolt}}
				]
			},
			{
				OptionName -> DeclusteringVoltage,
				Default -> Automatic,
				Description -> "The voltage offset between the ion block (the reduced pressure chamber of the source block) and the stepwave ion guide (the optics before the quadrupole mass analyzer). This voltage attracts charged ions in the spray being produced from the capillary tip into the ion block leading into the mass spectrometer. This voltage is typically set to 25-100 V and its tuning has little effect on sensitivity compared to other options (e.g. StepwaveVoltage).",
				ResolutionDescription -> "Is automatically set to any specified MassAcquisition method; otherwise, set to 40 Volt.",
				AllowNull -> False,
				Category -> "Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Volt, 150 Volt],
					Units -> {Volt, {Millivolt, Volt, Kilovolt}}
				]
			},
			{
				OptionName -> StepwaveVoltage,
				Default -> Automatic,
				Description -> "The voltage offset between the 1st and 2nd stage of the ion guide which leads ions coming from the sample cone towards the quadrupole mass analyzer. This voltage normally optimizes between 25 and 150 V and should be adjusted for sensitivity depending on compound and charge state. For multiply charged species it is typically set to to 40-50 V, and higher for singly charged species. In general higher cone voltages (120-150 V) are needed for larger mass ions such as intact proteins and monoclonal antibodies. It also has greatest effect on in-source fragmentation and should be decreased if in-source fragmentation is observed but not desired. This is an unique option for QTOF as the massanalyzer.",
				ResolutionDescription -> "Is automatically set according to the sample type (proteins, antibodies and analytes with MW > 2000 -> 120 V, DNA and synthetic nucleic acid oligomers -> 100 V, all others (including peptides and small molecules) -> 40 V).",
				AllowNull -> True,
				Category -> "Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Volt, 200 Volt],
					Units -> {Volt, {Millivolt, Volt, Kilovolt}}
				]
			},
			{
				OptionName -> SourceTemperature,
				Default -> Automatic,
				Description -> "The temperature setting of the source block. Heating the source block discourages condensation and decreases solvent clustering in the reduced vacuum region of the source. This temperature setting is flow rate and sample dependent. Typical values are between 60 to 120 Celsius. For thermally labile analytes, a lower temperature setting is recommended.",
				ResolutionDescription -> "Is automatically set according to the flow rate (0-0.02 ml/min -> 100 Celsius, 0.02-0.3 ml/min -> 120 Celsius, >0.301 -> 150 Celsius).",
				AllowNull -> False,
				Category -> "Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[25 Celsius, 150 Celsius],
					Units -> Celsius
				]
			},
			{
				OptionName -> DesolvationTemperature,
				Default -> Automatic,
				Description -> "The temperature setting for the ESI desolvation heater that controls the nitrogen gas temperature used for solvent evaporation to produce single gas phase ions from the ion spray. Similar to DesolvationGasFlow, this setting is dependent on solvent flow rate and composition. A typical range is 150 to 650 Celsius.",
				ResolutionDescription -> "Is automatically set according to the flow rate (0-0.02 ml/min -> 200 Celsius, 0.02-0.1 ml/min -> 350 Celsius, 0.101-0.3 -> 450 Celsius, 0.301->0.5 ml/min -> 500 Celsius, >0.500 ml/min -> 600 Celsius).",
				AllowNull -> False,
				Category -> "Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[20 Celsius, 650 Celsius],
					Units -> Celsius
				]
			},
			{
				OptionName -> DesolvationGasFlow,
				Default -> Automatic,
				Description -> "The rate at which nitrogen gas is flowed around the ESI capillary. It is used for solvent evaporation to produce single gas phase ions from the ion spray. Similar to DesolvationTemperature, this setting is dependent on solvent flow rate and composition. Higher desolvation gas flows usually result in increased sensitivity, but too high values can cause spray instability. Typical values are between 300 and 1200 L/h.",
				ResolutionDescription -> "Is automatically set according to the flow rate (0-0.02 ml/min -> 600 L/h, 0.02-0.3 ml/min -> 800 L/h, 0.301-0.500 ml/min -> 1000 L/h, >0.500 ml/min -> 1200 L/h).",
				AllowNull -> False,
				Category -> "Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :>RangeP[55 Liter/Hour, 1200 Liter/Hour] | RangeP[0 PSI, 85 PSI],
					Units -> Alternatives[
						CompoundUnit[
							{1, {Liter, {Liter, Milliliter}}},
							{-1, {Hour, {Hour, Minute}}}
						],
						PSI
					]
				]
			},
			{
				OptionName -> ConeGasFlow,
				Default -> Automatic,
				Description -> "The nitrogen gas flow ejected around the sample inlet cone (the spherical metal plate acting as a first gate between the sprayer and the reduced pressure chamber, the ion block). This gas flow is used to minimize the formation of solvent ion clusters. It also helps reduce adduct ions and directing the spray into the ion block while keeping the sample cone clean. The same parameter is referred to as Curtain Gas Pressure for ESI-QQQ. Typical values are between 0 and 150 L/h for ESI-QTOF or 20 to 55 PSI for ESI-QQQ.",
				ResolutionDescription -> "Is automatically set to 50 Liter/Hour for ESI-QTOF and 50 PSI for ESI-QQQ, and is set to Null in MALDI-TOF. Is not recommended to set to a smaller value of 40 PSI in ESI-QQQ, due to potential deposition of the sample inside the instrument that will lead to contamination.",
				AllowNull -> False, (* ConeGasFlow is needed for all MSes used in LCMS so this differs from ExperimentMassSpectrometry *)
				Category -> "Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :>RangeP[0 Liter/Hour, 300 Liter/Hour] | RangeP[20 PSI, 55 PSI],
					Units -> Alternatives[
						CompoundUnit[
							{1, {Liter, {Liter, Milliliter}}},
							{-1, {Hour, {Hour, Minute}}}
						],
						PSI
					]
				]
			},
			{
				OptionName -> IonGuideVoltage,
				Default -> Automatic,
				Description -> "This option (also known as Entrance Potential (EP)) is a unique option of ESI-QQQ. This parameter indicates electric potential applied to the Ion Guide in ESI-QQQ, which guides and focuses the ions through the high-pressure ion guide region.",
				ResolutionDescription -> "Is automatically set to 10 V for positive ions, or \[Dash]10 V for negative ions in ESI-QQQ, and can be changed between 2-15 V in both positive and negative mode. This value is set to Null in ESI-QTOF.",
				AllowNull -> True,
				Category -> "Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-15 Volt, -2 Volt] | RangeP[2 Volt, 15 Volt],
					Units -> Volt
				]
			},
			(*
			IndexMatching[
				IndexMatchingParent -> AcquisitionWindow, *)
			{
				OptionName -> AcquisitionWindow,
				Default -> Automatic,
				Description -> "The time range with respect to the chromatographic separation to conduct analyte ionization, selection/survey, optional fragmentation, and detection.",
				ResolutionDescription -> "Set to the entire gradient window 0 Minute to the last time point in Gradient.",
				AllowNull -> False,
				Category -> "Mass Analysis",
				Widget -> Alternatives[
					Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Minute,8 Hour],
							Units -> Minute
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Minute,8 Hour],
							Units -> Minute
						]
					],
					Adder[
						Alternatives[
							Span[
								Widget[
									Type -> Quantity,
									Pattern :> RangeP[0 Minute,8 Hour],
									Units -> Minute
								],
								Widget[
									Type -> Quantity,
									Pattern :> RangeP[0 Minute,8 Hour],
									Units -> Minute
								]
							],
							Widget[
								Type-> Enumeration,
								Pattern:>Alternatives[Automatic|Null]
							]
						]
					]
				]
			},
			{
				OptionName -> AcquisitionMode,
				Default -> Automatic,
				Description ->  "The method by which spectra are collected. DataDependent will depend on the properties of the measured mass spectrum of the intact ions. DataIndependent will systemically scan through all of the intact ions. MS1 will focus on defined intact masses. MS1MS2 will focus on fragmented masses.",
				ResolutionDescription -> "Set to MS1FullScan unless DataDependent related options are set, then set to DataDependent.",
				Category -> "Mass Analysis",
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> MSAcquisitionModeP (*DataIndependent|DataDependent|MS1FullScan|MS1MS2ProductIonScan|SelectedIonMonitoring|NeutralIonLoss|PrecursorIonScan|MultipleReactionMonitoring*)
					],
					Adder[
						Widget[
							Type -> Enumeration,
							Pattern :> MSAcquisitionModeP (*DataIndependent|DataDependent|MS1FullScan|MS1MS2ProductIonScan|SelectedIonMonitoring|NeutralIonLoss|PrecursorIonScan|MultipleReactionMonitoring*)
						]
					]
				]
			},
			{
				OptionName -> Fragment,
				Default -> Automatic,
				Description -> "Indicates if ions should be collided with neutral gas and dissociated in order to measure the resulting product ions. Also known as tandem mass spectrometry or MS/MS (as opposed to MS).",
				ResolutionDescription -> "Set to True if AcquisitionMode is MS1MS2ProductIonScan, DataDependent, or DataIndependent. Set True if any of the Fragmentation related options are set (e.g. FragmentMassDetection).",
				Category -> "Mass Analysis",
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					],
					Adder[
						Widget[
							Type -> Enumeration,
							Pattern :> BooleanP
						]
					]
				]
			},
			{
				OptionName -> MassDetection,
				Default -> Automatic,
				Description -> "The lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for intact masses. When Fragment is True, the intact ions will be selected for fragmentation.",
				ResolutionDescription -> "For Fragment -> False, automatically set to one of three default mass ranges according to the molecular weight of the Analytes to encompass them.",
				AllowNull -> False,
				Category -> "Mass Analysis",
				Widget -> Alternatives[
					Alternatives[
					
						"MS1FullScan, NeutralIonLoss, DataDependent, DataIndependent or PrecursorIonScan" -> Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"MS1MS2ProductIonScan or SelectedIonMonitoring" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						],
						"SelectedIonMonitoring or MultipleReactionMonitoring" -> Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"DataDependent or DataIndependent" -> Widget[
							Type -> Enumeration,
							Pattern :> MSAnalyteGroupP (*All|Peptide|SmallMolecule|Protein*)
						]
					],
					Adder[Alternatives[
						"MS1FullScan, NeutralIonLoss, DataDependent, DataIndependent or PrecursorIonScan" -> Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"MS1MS2ProductIonScan or SelectedIonMonitoring" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						],
						"SelectedIonMonitoring or MultipleReactionMonitoring" -> Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"DataDependent or DataIndependent" -> Widget[
							Type -> Enumeration,
							Pattern :> MSAnalyteGroupP (*All|Peptide|SmallMolecule|Protein*)
						]
					]]
				]
			},
			{
				OptionName -> MassDetectionStepSize,
				Default -> Automatic,
				Description ->"Indicate the step size for mass collection in range when using TripleQuadruploe as the MassAnalyzer.",
				ResolutionDescription ->"This option will be set to Null if using ESI-QTOF. For ESI-QQQ, if both of the mass analyzer are in mass selection mode (SelectedIonMonitoring and MultipleReactionMonitoring mode), this option will be auto resolved to Null. In all other mass scan modes in ESI-QQQ, this option will be automatically resolved to 0.1 g/mol.",
				AllowNull -> True,
				Category -> "Mass Analysis",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.01 Gram/Mole, 1 Gram/Mole],
						Units -> CompoundUnit[
							{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
							{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
						]
					],
					Adder[
						Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.01 Gram/Mole, 1 Gram/Mole],
								Units -> CompoundUnit[
									{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
									{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
								]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]
					]
				]
			},
			{
				OptionName -> ScanTime,
				Default -> Automatic,
				Description -> "The duration of time allowed to pass between each spectral acquisition. When AcquisitionMode is DataDependent, this value refers to the duration for measuring spectra from the intact ions. Increasing this value improves sensitivity whereas decreasing this value allows for more data points and spectra to be acquired.",
				ResolutionDescription -> "Set to 1 second unless a method is given.",
				AllowNull -> False,
				Category -> "Mass Analysis",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 10 Second],
						Units -> Second
					],
					Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.015 Second, 10 Second],
							Units -> Second
						]
					]
				]
			},
			{
				OptionName -> FragmentMassDetection,
				Default -> Automatic,
				Description -> "The lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for product ions. When AcquisitionMode is DataDependent|DataIndependent, all of the product ions in consideration for measurement.  Null if Fragment is False.",
				ResolutionDescription -> "When Fragment is False, set to Null. Otherwise, 20 Gram/Mole to the maximum MassDetection.",
				AllowNull -> True,
				Category -> "Mass Analysis",
				Widget -> Alternatives[
					Alternatives[
						"PrecursorIonScan" -> Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 16000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"ProductIonScan" -> Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 16000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[100 Gram / Mole, 16000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"DataDependent or DataIndependent" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[All]
						],
						"Null" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						],
						"MultipleReactionMonitoring" -> Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 2000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						]
					],
					Adder[Alternatives[
						"PrecursorIonScan" -> Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 16000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"ProductIonScan" -> Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 16000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[100 Gram / Mole, 16000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"DataDependent or DataIndependent" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[All]
						],
						"Null" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						],
						"MultipleReactionMonitoring" -> Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 2000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						]
					]]
				]
			},
			{
				OptionName -> CollisionEnergy, (*TODO: make a figure for the interpolation; preview function tab*)
				Default -> Automatic,
				Description -> "The voltage by which intact ions are accelerated through inert gas in order to dissociate them into measurable fragment ion species when Fragment is True. If the corresponding AcquisitionMode is DataIndependent, CollisionEnergy specifies the voltage of the low fragemention scan. Otherwise, CollisionEnergy cannot be defined simultaneously with CollisionEnergyMassProfile.",
				ResolutionDescription -> "Is automatically set to 40 Volt when Fragment is True, otherwise is set to Null.",
				AllowNull -> True,
				Category -> "Mass Analysis",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.1 Volt, 255 Volt]| RangeP[-180 Volt, 5 Volt],
						Units -> {Volt, {Millivolt, Volt, Kilovolt}}
					],
					Adder[Alternatives[
						"Single Values"->Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt]| RangeP[-180 Volt, 5 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						],
						"A list of Single Values"->Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Volt, 180 Volt] | RangeP[-180 Volt, 5 Volt],
								Units -> Volt
							],
							Orientation->Vertical
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> CollisionCellExitVoltage,
				Default -> Automatic,
				Description ->"Also known as the Collision Cell Exit Potential (CXP). This value focuses and accelerates the ions out of collision cell (Q2) and into 2nd mass analyzer (MS 2). This potential is tuned to ensure successful ion acceleration out of collision cell and into MS2, and can be adjusted to reach the maximal signal intensity. This option is unique to ESI-QQQ for now, and only required when Fragment ->True and/or in ScanMode that achieves tandem mass feature (PrecursorIonScan, NeutralIonLoss,MS1MS2ProductIonScan,MultipleReactionMonitoring). For non-tandem mass ScanMode (FullScan and SelectedIonMonitoring) and other massspectrometer (ESI-QTOF and MALDI-TOF), this option is resolved to Null.",
				ResolutionDescription ->"Is automatically set to 15 V (Positive mode) or -15 V (Negative mode) if the collision option is True and using QQQ as the mass analyzer. ",
				AllowNull -> True,
				Category -> "Mass Analysis",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[-55 Volt, 55 Volt],
						Units -> Volt
					],
					Adder[
						Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[-55 Volt, 55 Volt],
								Units -> Volt
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]
					]
				]
			},
			
			(* AcquisitionMode specific options for Tandem Mass Spectrometry *)
			{
				OptionName -> DwellTime,
				Default -> Automatic,
				Description -> "The duration of time for which spectra are acquired at the specific mass detection value for SelectedIonMonitoring and MultipleReactionMonitoring mode in ESI-QQQ.",
				ResolutionDescription -> "Is automatically set to 200 microsecond if StandardAcquisition is in SelectedIonMonitoring or MultipleReactionMonitoring mode. Otherwise is set to Null.",
				AllowNull -> True,
				Category -> "Mass Analysis",
				Widget ->Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[5 Millisecond,  2000 Millisecond],
						Units -> {Millisecond, {Millisecond,Second,Minute}}
					],
					Adder[Alternatives[
						"Single Values"->Widget[
							Type -> Quantity,
							Pattern :> RangeP[5 Millisecond,  2000 Millisecond],
							Units -> {Millisecond, {Millisecond,Second,Minute}}
						],
						"A list of Single Values"->Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Millisecond,  2000 Millisecond],
								Units -> {Millisecond, {Millisecond,Second,Minute}}
							],
							Orientation->Vertical
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> NeutralLoss,
				Default -> Automatic,
				Description ->"A neutral loss scan is performed on ESI-QQQ instrument by scanning the sample through the first quadrupole (Q1). The ions are then fragmented in the collision cell. The second mass analyzer is then scanned with a fixed offset to MS1. This option represents the value of this offset.",
				ResolutionDescription ->"Is set to 500 g/mol if using NeutralIonLoss as AcquisitionMode, and is Null in other modes.",
				AllowNull -> True,
				Category -> "Mass Analysis",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 Gram/Mole],
						Units -> CompoundUnit[
							{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
							{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
						]
					],
					Adder[
						Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Gram/Mole],
								Units -> CompoundUnit[
									{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
									{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
								]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]
					]
				]
			},
			{
				OptionName -> MultipleReactionMonitoringAssays,
				Default -> Automatic,
				Description -> "In ESI-QQQ, the ion corresponding to the compound of interest is targeted with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and DwellTime (length of time of each scan).",
				ResolutionDescription -> "Is set based on MassDetection, CollisionEnergy, DwellTime and FragmentMassDetection.",
				AllowNull -> True,
				Category -> "Mass Analysis",
				Widget -> Alternatives[
					Adder[
						Alternatives[
							"Individual Multiple Reaction Monitoring Assay" -> Adder[{
								"Mass Selection Values" -> Widget[
									Type -> Quantity,
									Pattern :> GreaterP[0 Gram / Mole],
									Units -> CompoundUnit[
										{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
										{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
									]
								],
								"CollisionEnergies" -> Alternatives[
									Widget[
										Type -> Quantity,
										Pattern :> RangeP[5 Volt, 180 Volt] | RangeP[-180 Volt, 5 Volt],
										Units -> Volt
									],
									Widget[
										Type -> Enumeration,
										Pattern :> Alternatives[Automatic]
									]
								],
								"Fragment Mass Selection Values" -> Widget[
									Type -> Quantity,
									Pattern :> GreaterP[0 Gram / Mole],
									Units -> CompoundUnit[
										{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
										{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
									]
								],
								"Dwell Times" -> Alternatives[
									Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0 Second],
										Units -> {Millisecond, {Microsecond, Millisecond, Second}}
									],
									Widget[
										Type -> Enumeration,
										Pattern :> Alternatives[Automatic]
									]
								]
							}],
							{
								"Multiple Reaction Monitoring Assays" -> Adder[{
									"Mass Selection Values" -> Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0 Gram / Mole],
										Units -> CompoundUnit[
											{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
											{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
										]
									],
									"CollisionEnergies" -> Alternatives[
										Widget[
											Type -> Quantity,
											Pattern :> RangeP[5 Volt, 180 Volt] | RangeP[-180 Volt, 5 Volt],
											Units -> Volt
										],
										Widget[
											Type -> Enumeration,
											Pattern :> Alternatives[Automatic]
										]
									],
									"Fragment Mass Selection Values" -> Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0 Gram / Mole],
										Units -> CompoundUnit[
											{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
											{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
										]
									],
									"Dwell Times" -> Alternatives[
										Widget[
											Type -> Quantity,
											Pattern :> GreaterP[0 Second],
											Units -> {Millisecond, {Microsecond, Millisecond, Second}}
										],
										Widget[
											Type -> Enumeration,
											Pattern :> Alternatives[Automatic]
										]
									]
								}]
							},
							"None" -> Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null, {Null}]
							]
						],
						Orientation -> Vertical
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					]
				]
			},
			{
				OptionName -> CollisionEnergyMassProfile,
				Default -> Automatic,
				Description -> "The relationship of collision energy with the MassDetection. If the corresponding AcquisitionMode is DataIndependent, this span specifies the minimum and maximum values for the linear voltage ramp of the high fragmentation scan. If the corresponding AcquisitionMode is DataDependent, this span specifies the minimum and maximum values for the low energy voltage ramp. Otherwise, it should be Null. ",
				ResolutionDescription -> "Set to CollisionEnergyMassScan if defined; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Mass Analysis",
				Widget -> Alternatives[
					Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						]
					],
					Adder[Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.1 Volt, 255 Volt],
								Units -> {Volt, {Millivolt, Volt, Kilovolt}}
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.1 Volt, 255 Volt],
								Units -> {Volt, {Millivolt, Volt, Kilovolt}}
							]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> CollisionEnergyMassScan,
				Default -> Automatic,
				Description -> "The collision energy profile at the end of the scan from CollisionEnergy or CollisionEnergyScanProfile, as related to analyte mass.",
				AllowNull -> True,
				Category -> "Mass Analysis",
				Widget->Alternatives[
					Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						]
					],
					Adder[Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.1 Volt, 255 Volt],
								Units -> {Volt, {Millivolt, Volt, Kilovolt}}
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.1 Volt, 255 Volt],
								Units -> {Volt, {Millivolt, Volt, Kilovolt}}
							]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> FragmentScanTime,
				Default -> Automatic,
				Description -> "The duration of the spectral scanning for each fragmentation of an intact ion when AcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Automatically set to the same value as ScanTime if AcquisitionMode is DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Data Dependent Acquisition",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 10 Second],
						Units -> Second
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.015 Second, 10 Second],
							Units -> Second
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> AcquisitionSurvey,
				Default -> Automatic,
				Description -> "The number of intact ions to consider for fragmentation and product ion measurement in every measurement cycle when AcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Automatically set to 10 if AcquisitionMode is set to DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Data Dependent Acquisition",
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[1, 30, 1]
					],
					Adder[Alternatives[
						Widget[
							Type -> Number,
							Pattern :> RangeP[1, 30, 1]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> MinimumThreshold,
				Default -> Automatic,
				Description -> "The minimum number of total ions detected within ScanTime durations needed to trigger the start of data dependent acquisition when AcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Automatically set to (100000/Second)*ScanTime if AcquisitionMode is DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Data Dependent Acquisition",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 ArbitraryUnit, 8000000 ArbitraryUnit],
						Units -> ArbitraryUnit
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 ArbitraryUnit, 8000000 ArbitraryUnit],
							Units -> ArbitraryUnit
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> AcquisitionLimit,
				Default -> Automatic,
				Description -> "The maximum number of total ions for a specific intact ion when AcquisitionMode is set to DataDependent. When this value is exceeded, acquisition will switch to fragmentation of the next candidate ion.",
				ResolutionDescription -> "Automatically inherited from supplied method if AcquisitionMode is set to DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Data Dependent Acquisition",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 ArbitraryUnit, 8000000 ArbitraryUnit],
						Units -> ArbitraryUnit
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 ArbitraryUnit, 8000000 ArbitraryUnit],
							Units -> ArbitraryUnit
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> CycleTimeLimit,
				Default -> Automatic,
				Description -> "The maximum possible computed duration of all of the scans for the intact and fragmentation measurements when AcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Calculated from the AcquisitionSurvey, ScanTime, and FragmentScanTime.",
				AllowNull -> True,
				Category -> "Data Dependent Acquisition",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 20000 Second],
						Units -> Second
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.015 Second, 20000 Second],
							Units -> Second
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
		(*IndexMatching[
				IndexMatchingParent -> ExclusionDomain,*)
				{
					OptionName -> ExclusionDomain,
					Default -> Automatic,
					Description -> "The time range when the ExclusionMasses are omitted in the chromatogram. Full indicates for the entire period.",
					ResolutionDescription -> "Set to the entire AcquisitionWindow.",
					AllowNull -> True,
					Category -> "Data Dependent Acquisition",
					Widget -> Alternatives[
						Alternatives[
							Span[
								Widget[
									Type -> Quantity,
									Pattern :> GreaterEqualP[0 Minute],
									Units -> Minute
								],
								Widget[ Type -> Quantity,
									Pattern :> GreaterEqualP[0 Minute],
									Units -> Minute
								]
							],
							Widget[
								Type-> Enumeration,
								Pattern:>Alternatives[Full]
							]
						],
						Adder[Alternatives[
								Span[
									Widget[
										Type -> Quantity,
										Pattern :> GreaterEqualP[0 Minute],
										Units -> Minute
									],
									Widget[ Type -> Quantity,
										Pattern :> GreaterEqualP[0 Minute],
										Units -> Minute
									]
								],
								Widget[
									Type-> Enumeration,
									Pattern:>Alternatives[Full]
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Null]
								]
						]],
						Adder[Adder[Alternatives[
							Span[
								Widget[
									Type -> Quantity,
									Pattern :> GreaterEqualP[0 Minute],
									Units -> Minute
								],
								Widget[ Type -> Quantity,
									Pattern :> GreaterEqualP[0 Minute],
									Units -> Minute
								]
							],
							Widget[
								Type-> Enumeration,
								Pattern:>Alternatives[Full]
							]
						]]]
					]
				},
				{
					OptionName -> ExclusionMass, (*Index matched to the exclusion domain*)
					Default -> Automatic,
					Description -> "The intact ions (Target Mass) to omit. When set to All, the mass is excluded for the entire ExclusionDomain. When set to Once, the mass is excluded in the first survey appearance, but considered for consequent ones.",
					ResolutionDescription -> "If any ExclusionMode-related options are set (e.g. ExclusionMassTolerance), a target mass of the first Analyte (if not in InclusionMasses) is chosen and retention time is set to 0*Minute.",
					Category -> "Data Dependent Acquisition",
					AllowNull -> True,
					Widget -> Alternatives[
						{
							"Mode" -> Widget[
								Type-> Enumeration,
								Pattern:>All|Once
							],
							"Target Mass" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram/Mole, 100000 Gram/Mole],
								Units -> Gram/Mole
							]
						},
						Adder[Alternatives[
							{
								"Mode" -> Widget[
									Type-> Enumeration,
									Pattern:>All|Once
								],
								"Target Mass" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[2 Gram/Mole, 100000 Gram/Mole],
									Units -> Gram/Mole
								]
							},
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]],
						Adder[Adder[
							{
								"Mode" -> Widget[
									Type-> Enumeration,
									Pattern:>All|Once
								],
								"Target Mass" -> Widget[
									Type -> Quantity,
									Pattern :> RangeP[2 Gram/Mole, 100000 Gram/Mole],
									Units -> Gram/Mole
								]
							}
						]]
					]
				},
						(*	], *)
			{
				OptionName -> ExclusionMassTolerance,
				Default -> Automatic,
				Description -> "The range above and below each ion in ExclusionMasses to consider for omission when ExclusionMass is set to All or Once.",
				ResolutionDescription -> "If ExclusionMass -> All or Once, set to 0.5 Gram/Mole; otherwise, Null.",
				AllowNull -> True,
				Category -> "Data Dependent Acquisition",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
						Units -> Gram/Mole
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> ExclusionRetentionTimeTolerance,
				Default -> Automatic,
				Description -> "The range of time above and below the ExclusionDomain to consider for exclusion.",
				ResolutionDescription -> "If ExclusionMass and ExclusionDomain options are set, this is set to 10 seconds; otherwise, Null.",
				AllowNull -> True,
				Category -> "Data Dependent Acquisition",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Second, 3600 Second],
						Units -> Second
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Second, 3600 Second],
							Units -> Second
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
		(*IndexMatching[
				IndexMatchingParent -> InclusionDomain, *)
				{
					OptionName -> InclusionDomain,
					Default -> Automatic,
					Description -> "The time range when InclusionMass applies in the chromatogram. Full indicates for the entire period.",
					ResolutionDescription -> "Set to the entire AcquisitionWindow.",
					AllowNull -> True,
					Category -> "Data Dependent Acquisition",
					Widget -> Alternatives[
						Alternatives[
							Span[
								Widget[
									Type -> Quantity,
									Pattern :> GreaterEqualP[0 Minute],
									Units -> Minute
								],
								Widget[ Type -> Quantity,
									Pattern :> GreaterEqualP[0 Minute],
									Units -> Minute
								]
							],
							Widget[
								Type-> Enumeration,
								Pattern:>Alternatives[Full]
							]
						],
						Adder[Alternatives[
							Span[
								Widget[
									Type -> Quantity,
									Pattern :> GreaterEqualP[0 Minute],
									Units -> Minute
								],
								Widget[ Type -> Quantity,
									Pattern :> GreaterEqualP[0 Minute],
									Units -> Minute
								]
							],
							Widget[
								Type-> Enumeration,
								Pattern:>Alternatives[Full]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]],
						Adder[Adder[Alternatives[
							Span[
								Widget[
									Type -> Quantity,
									Pattern :> GreaterEqualP[0 Minute],
									Units -> Minute
								],
								Widget[ Type -> Quantity,
									Pattern :> GreaterEqualP[0 Minute],
									Units -> Minute
								]
							],
							Widget[
								Type-> Enumeration,
								Pattern:>Alternatives[Full]
							]
						]]]
					]
				},
				{
					OptionName -> InclusionMass, (*Index matched to InclusionDomain*)
					Default -> Automatic,
					Description -> "The ions (Target Mass) to prioritize during the survey scan for further fragmentation when AcquisitionMode is DataDependent. When the Mode is Only, the InclusionMass will solely be considered for surveys. When Mode is Preferential, the InclusionMass will be prioritized for survey.",
					ResolutionDescription -> "When InclusionMode  Only or Preferential, an entry mass is added based on the mass of the most salient analyte of the sample.",
					Category -> "Data Dependent Acquisition",
					AllowNull -> True,
					Widget -> Alternatives[
						{
							"Mode" -> Widget[ (*InclusionMassMode*)
								Type-> Enumeration,
								Pattern:>Only|Preferential
							],
							"Target Mass" -> Widget[ (*InclusionMass*)
								Type -> Quantity,
								Pattern :> RangeP[2 Gram/Mole, 4000 Gram/Mole],
								Units -> Gram/Mole
							]
						},
						Adder[Alternatives[
							{
								"Mode" -> Widget[ (*InclusionMassMode*)
									Type-> Enumeration,
									Pattern:>Only|Preferential
								],
								"Target Mass" -> Widget[ (*InclusionMass*)
									Type -> Quantity,
									Pattern :> RangeP[2 Gram/Mole, 4000 Gram/Mole],
									Units -> Gram/Mole
								]
							},
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]],
						Adder[Adder[
							{
								"Mode" -> Widget[ (*InclusionMassMode*)
									Type-> Enumeration,
									Pattern:>Only|Preferential
								],
								"Target Mass" -> Widget[ (*InclusionMass*)
									Type -> Quantity,
									Pattern :> RangeP[2 Gram/Mole, 4000 Gram/Mole],
									Units -> Gram/Mole
								]
							}
						]]
					]
				},
				{
					OptionName -> InclusionCollisionEnergy, (*Index matched to InclusionDomain*)
					Default -> Automatic,
					Description -> "The overriding collision energy value that can be applied to the InclusionMass. Null will default to the CollisionEnergy and related options.",
					ResolutionDescription -> "Inherited from any supplied method.",
					AllowNull -> True,
					Category -> "Data Dependent Acquisition",
					Widget -> Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Volt, 255 Volt],
							Units -> Volt
						],
						Adder[Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Volt, 255 Volt],
								Units -> Volt
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]],
						Adder[Adder[Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Volt, 255 Volt],
							Units -> Volt
						]]]
					]
				},
				{
					OptionName -> InclusionDeclusteringVoltage,
					Default -> Automatic,
					Description -> "The overriding source voltage value that can be applied to the InclusionMass. Null will default to the DeclusteringVoltage option.",
					ResolutionDescription -> "Inherited from any supplied method.",
					AllowNull -> True,
					Category -> "Data Dependent Acquisition",
					Widget -> Alternatives[
						Widget[ (*InclusionDeclusteringVoltage*)
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 150 Volt],
							Units -> Volt
						],
						Adder[Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.1 Volt, 150 Volt],
								Units -> Volt
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]],
						Adder[Adder[Widget[ (*InclusionDeclusteringVoltage*)
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 150 Volt],
							Units -> Volt
						]]]
					]
				},
				{
					OptionName -> InclusionChargeState,
					Default -> Automatic,
					Description -> "The maximum charge state of the InclusionMass to also consider for inclusion. For example, if this is set to 3 and the polarity is Positive, then +1,+2,+3 charge states will be considered as well.",
					ResolutionDescription -> "Inherited from any supplied method.",
					AllowNull -> True,
					Category -> "Data Dependent Acquisition",
					Widget -> Alternatives[
						Widget[
							Type -> Number,
							Pattern :> RangeP[0, 6, 1]
						],
						Adder[Alternatives[
							Widget[
								Type -> Number,
								Pattern :> RangeP[0, 6, 1]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]],
						Adder[Adder[Widget[
							Type -> Number,
							Pattern :> RangeP[0, 6, 1]
						]]]
					]
				},
				{
					OptionName -> InclusionScanTime,
					Default -> Automatic,
					Description -> "The overriding scan time duration that can be applied to the InclusionMass for the consequent fragmentation. Null will default to the FragmentScanTime option.",
					ResolutionDescription -> "Inherited from any supplied method.",
					AllowNull -> True,
					Category -> "Data Dependent Acquisition",
					Widget -> Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.015 Second, 10 Second],
							Units -> Second
						],
						Adder[Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.015 Second, 10 Second],
								Units -> Second
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]],
						Adder[Adder[Widget[ (*InclusionScanTime*)
							Type -> Quantity,
							Pattern :> RangeP[0.015 Second, 10 Second],
							Units -> Second
						]]]
					]
				},
			(*)]*)
			{
				OptionName -> InclusionMassTolerance,
				Default -> Automatic,
				Description -> "The range above and below each ion in InclusionMasses to consider for prioritization. For example, if set to 0.5 Gram/Mole, the total range is 1 Gram/Mole.",
				ResolutionDescription -> "Set to 0.5 Gram/Mole if InclusionMass is given; otherwise, Null.",
				AllowNull -> True,
				Category -> "Data Dependent Acquisition",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
						Units -> Gram/Mole
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> SurveyChargeStateExclusion,
				Default -> Automatic,
				Description -> "Indicates if redundant ions that differ by ionic charge (+1/-1, +2/-2, etc.) should be excluded and if ChargeState exclusion-related options should be automatically filled in.",
				ResolutionDescription -> "Set to True, if any of the ChargeState options are set; otherwise, False.",
				Category -> "Mass Analysis",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					],
					Adder[Alternatives[
						Widget[
							Type -> Enumeration,
							Pattern :> BooleanP
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> SurveyIsotopeExclusion,
				Default -> Automatic,
				Description -> "Indicates if redundant ions that differ by isotopic mass (e.g. 1, 2 Gram/Mole) should be excluded and if MassIsotope exclusion-related options should be automatically filled in.",
				ResolutionDescription -> "Set to True, if any of the IsotopeExclusion options are set; otherwise, False.",
				Category -> "Mass Analysis",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					],
					Adder[Alternatives[
						Widget[
							Type -> Enumeration,
							Pattern :> BooleanP
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> ChargeStateExclusionLimit,
				Default -> Automatic,
				Description -> "The number of ions to survey first with exclusion by ionic state. For example, if AcquisitionSurvey is 10 and this option is 5, then 5 ions will be surveyed with charge-state exclusion. For candidate ions of rank 6 to 10, no exclusion will be performed.", (*TODO: a figure*)
				ResolutionDescription -> "Inherited from any supplied method; otherwise, set the same to AcquisitionSurvey, if any ChargeState option is set.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[0, 30, 1]
					],
					Adder[Alternatives[
						Widget[
							Type -> Number,
							Pattern :> RangeP[0, 30, 1]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				],
				Category -> "Data Dependent Acquisition"
			},
			{
				OptionName -> ChargeStateExclusion,
				Default -> Automatic,
				Description -> "The specific ionic states of intact ions to redundantly exclude from the survey for further fragmentation/acquisition. 1 refers to +1/-1, 2 refers to +2/-2, etc.",
				ResolutionDescription -> "When SurveyChargeStateExclusion is True, set to {1,2}; otherwise, Null.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[1, 6, 1]
					],
					Adder[Alternatives[
						Widget[
							Type -> Number,
							Pattern :> RangeP[1, 6, 1]
						],
						Adder[
							Widget[
								Type -> Number,
								Pattern :> RangeP[1, 6, 1]
							],
							Orientation->Vertical
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				],
				Category -> "Data Dependent Acquisition"
			},
			{
				OptionName -> ChargeStateMassTolerance,
				Default -> Automatic,
				Description -> "The range of m/z to consider for exclusion by ionic state property when SurveyChargeStateExclusion is True.",
				ResolutionDescription -> "When SurveyChargeStateExclusion is True, set to 0.5 Gram/Mole; otherwise, Null.",
				AllowNull -> True,
				Category -> "Data Dependent Acquisition",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
						Units -> Gram/Mole
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
		(*	IndexMatching[
				IndexMatchingParent -> IsotopicExclusion,*)
				{
					OptionName -> IsotopicExclusion,
					Default -> Automatic,
					Description -> "The m/z difference between monoisotopic ions as a criterion for survey exclusion.",
					ResolutionDescription -> "When SurveyIsotopeExclusion is True, set to 1 Gram/Mole; otherwise, Null.",
					AllowNull -> True,
					Category -> "Data Dependent Acquisition",
					Widget -> Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						],
						Adder[Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
								Units -> Gram/Mole
							],
							Adder[
								Widget[
									Type -> Quantity,
									Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
									Units -> Gram/Mole
								],
								Orientation->Vertical
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]]
					]
				},
				{
					OptionName -> IsotopeRatioThreshold, (*index matching IsotopicExclusion*)
					Default -> Automatic, (*TODO: Figure *)
					Description -> "The minimum relative magnitude between monoisotopic ions in order to be considered an isotope for exclusion.",
					ResolutionDescription -> "When SurveyIsotopeExclusion is True, set to 0.1; otherwise, Null.",
					AllowNull -> True,
					Widget -> Alternatives[
						Widget[
							Type -> Number,
							Pattern :> RangeP[0, 1]
						],
						Adder[Alternatives[
							Widget[
								Type -> Number,
								Pattern :> RangeP[0, 1]
							],
							Adder[
								Widget[
									Type -> Number,
									Pattern :> RangeP[0, 1]
								],
								Orientation->Vertical
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]]
					],
					Category -> "Data Dependent Acquisition"
				}
			(*]*),
			{ (*index matching to above*)
				OptionName -> IsotopeDetectionMinimum,
				Default -> Automatic,
				Description -> "The acquisition rate of a given intact mass to consider for isotope exclusion in the survey.",
				ResolutionDescription -> "When SurveyIsotopeExclusion is True, set to 10 1/Second; otherwise, Null.",
				Category -> "Data Dependent Acquisition",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 * 1 / Second],
						Units -> {-1, {Minute, {Minute, Second}}}
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 * 1 / Second],
							Units -> {-1, {Minute, {Minute, Second}}}
						],
						Adder[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 * 1 / Second],
								Units -> {-1, {Minute, {Minute, Second}}}
							],
							Orientation->Vertical
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> IsotopeMassTolerance,
				Default -> Automatic,
				Description -> "The range of m/z around a mass to consider for exclusion. This applies for both ChargeState and mass shifted Isotope. If set to 0.5 Gram/Mole, then the total range should be 1 Gram/Mole.",
				ResolutionDescription -> "When SurveyIsotopeExclusion or SurveyChargeStateExclusion is True, set to 0.5 Gram/Mole; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Data Dependent Acquisition",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
						Units -> Gram/Mole
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> IsotopeRatioTolerance,
				Default -> Automatic,
				Description -> "The range of relative magnitude around IsotopeRatio to consider for isotope exclusion.",
				ResolutionDescription -> "If SurveyIsotopeExclusion is True, set to 30*Percent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Data Dependent Acquisition",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent,100Percent],
						Units -> Percent
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent,100Percent],
							Units -> Percent
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			(*  ], *)

			{
				OptionName -> AbsorbanceWavelength,
				Default -> Automatic,
				Description -> "The wavelength of light passed through the flow cell for the PhotoDiodeArray (PDA) Detector. A 3D data is generated from a spectrum of light passing through the flow cell. Absorbance wavelength represents the wavelength at which a 2D data slice is generated from the 3D data.",
				ResolutionDescription -> "When conducting absorbance measurement, set to All.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Single" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[190 Nanometer, 500 Nanometer],
						Units -> Nanometer
					],
					"All" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					],
					"Range" -> Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[190 Nanometer, 500 Nanometer],
							Units -> Nanometer
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[200 Nanometer, 500 Nanometer],
							Units -> Nanometer
						]
					]
				],
				Category -> "Detector Parameters"
			},
			{
				OptionName -> WavelengthResolution,
				Default -> Automatic,
				Description -> "The increment of wavelength for the range of light passed through the flow for absorbance measurement with the PhotoDiodeArray detector.",
				ResolutionDescription -> "Automatically set to 2.4 Nanometer. Set to Null if AbsorbanceWavelength is a singleton value.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1.2 * Nanometer, 12.0 * Nanometer],
					Units -> Nanometer
				],
				Category -> "Detector Parameters"
			},
			{
				OptionName -> UVFilter,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if UV wavelengths (less than 210 nm) should be blocked from being transmitted through the sample for PhotoDiodeArray detectors.",
				ResolutionDescription -> "Automatically set to False for Instruments with PDA detectors; otherwise, resolves to Null.",
				Category -> "Detector Parameters"
			},
			{
				OptionName -> AbsorbanceSamplingRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * 1 / Second, 80 * 1 / Second, 1 * 1 / Second], (*can be only specific values*)
					Units -> {-1, {Minute, {Minute, Second}}}
				],
				Description -> "The number of times an absorbance measurement is made per second by the detector on the selected instrument. Lower values will be less susceptible to noise but will record less frequently across time.",
				ResolutionDescription -> "Automatically set to 20/Second for Instruments with PhotoDiodeArray (PDA) detectors; otherwise, resolves to Null.",
				Category -> "Detector Parameters"
			}
		],
		IndexMatching[
			IndexMatchingParent -> Standard,
			{
				OptionName -> Standard,
				Default -> Automatic,
				Description -> "The reference compound(s) injected into the instrument, often used for quantification or to check internal measurement consistency.",
				ResolutionDescription -> "If any other Standard option is specified, automatically set based on the SeparationMode option. If InjectionTable is specified, set from the specified Standard entries in the InjectionTable.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Liquid Chromatography",
							"Standards"
						},
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Standards"
						}
					}
				]
			},
			{
				OptionName -> StandardInjectionVolume,
				Default -> Automatic,
				Description -> "The physical quantity of Standard sample loaded into the flow path on the selected instrument along with the mobile phase onto the stationary phase.",
				ResolutionDescription -> "Automatically set equal to the first entry in InjectionVolume.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter, 500 Microliter],
					Units -> Microliter
				]
			}
		],
		{
			OptionName -> StandardFrequency,
			Default -> Automatic,
			Description -> "The frequency at which Standard measurements will be inserted between the experiment samples.",
			ResolutionDescription -> "If injectionTable is given, automatically set to Null and the sequence of Standards specified in the InjectionTable will be used in the experiment. If any other Standard option is specified, automatically set to FirstAndLast.",
			AllowNull -> True,
			Category -> "Standard",
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> None | First | Last | FirstAndLast | GradientChange
				],
				Widget[
					Type -> Number,
					Pattern :> GreaterP[0, 1]
				]
			]
		},
		IndexMatching[
			IndexMatchingParent -> Standard,
			{
				OptionName -> StandardColumnTemperature,
				Default -> Automatic,
				Description -> "The temperature of the column when the Standard gradient and measurement are run. If StandardColumnTemperature is set to Ambient, column oven temperature control is not used. Otherwise, StandardColumnTemperature is maintained by temperature control of the column oven.",
				ResolutionDescription -> "Automatically set to the corresponding gradient temperature specified in the StandardGradient option or the column temperature for the sample in the InjectionTable option; otherwise, set as the first value of the ColumnTemperature option.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[30 Celsius, 90 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				]
			},
			{
				OptionName -> StandardGradientA,
				Default -> Automatic,
				Description -> "The composition of BufferA within the flow, defined for specific time points for Standard measurement. The composition is linearly interpolated for the intervening periods between the defined time points. For example for StandardGradientA->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferA in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
				ResolutionDescription -> "If StandardGradient option is specified, set from it or implicitly determined from the StandardGradientB, StandardGradientC, and StandardGradientD options such that the total amounts to 100%.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Minute, $MaxExperimentTime],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer A Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> StandardGradientB,
				Default -> Automatic,
				Description -> "The composition of BufferB within the flow, defined for specific time points for Standard measurement. The composition is linearly interpolated for the intervening periods between the defined time points. For example for StandardGradientB->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferB in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
				ResolutionDescription -> "If StandardGradient option is specified, set from it or implicitly determined from the StandardGradientA, StandardGradientC, and StandardGradientD options such that the total amounts to 100%.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Minute, $MaxExperimentTime],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer B Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> StandardGradientC,
				Default -> Automatic,
				Description -> "The composition of BufferC within the flow, defined for specific time points for Standard measurement. The composition is linearly interpolated for the intervening periods between the defined time points. For example for StandardGradientC->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferC in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
				ResolutionDescription -> "If StandardGradient option is specified, set from it or implicitly determined from the StandardGradientA, StandardGradientB, and StandardGradientD options such that the total amounts to 100%.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Minute, $MaxExperimentTime],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer C Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> StandardGradientD,
				Default -> Automatic,
				Description -> "The composition of BufferD within the flow, defined for specific time points for Standard measurement. The composition is linearly interpolated for the intervening periods between the defined time points. For example for StandardGradientD->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferD in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
				ResolutionDescription -> "If StandardGradient option is specified, set from it or implicitly determined from the StandardGradientA, StandardGradientB, and StandardGradientC options such that the total amounts to 100%.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Minute, $MaxExperimentTime],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer D Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> StandardFlowRate,
				Default -> Automatic,
				Description -> "The net speed of the fluid flowing through the pump inclusive of the composition of BufferA, BufferB, BufferC, and BufferD specified in the StandardGradient options during Standard measurement. This speed is linearly interpolated such that consecutive entries of {Time, Flow Rate} will define the intervening fluid speed. For example, {{0 Minute, 0.3 Milliliter/Minute},{30 Minute, 0.5 Milliliter/Minute}} means flow rate of 0.4 Milliliter/Minute at 15 minutes into the run.",
				ResolutionDescription -> "If StandardGradient option is specified, automatically set from the method given in the StandardGradient option. If NominalFlowRate of the column model is specified, set to lesser of the NominalFlowRate for each of the columns, guard columns or the instrument's MaxFlowRate. Otherwise set to 1 Milliliter / Minute.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Milliliter / Minute, 2 Milliliter / Minute],
						Units -> CompoundUnit[
							{1, {Milliliter, {Milliliter, Liter}}},
							{-1, {Minute, {Minute, Second}}}
						]
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Minute, $MaxExperimentTime],
								Units -> {Minute, {Second, Minute}}
							],
							"Flow Rate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Milliliter / Minute, 2 Milliliter / Minute],
								Units -> CompoundUnit[
									{1, {Milliliter, {Milliliter, Liter}}},
									{-1, {Minute, {Minute, Second}}}
								]
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> StandardGradient,
				Default -> Automatic,
				Description -> "The composition of different specified buffers in BufferA, BufferB, BufferC and BufferD over time in the fluid flow for Standard measurement. Specific parameters of a gradient object can be overridden by specific options.",
				ResolutionDescription -> "Automatically set to best meet all the StandardGradient options (e.g. StandardGradientA, StandardGradientB, StandardGradientC, StandardGradientD, StandardFlowRate).",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[Type -> Object, Pattern :> ObjectP[Object[Method, Gradient]]],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Minute, $MaxExperimentTime],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer A Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Buffer B Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Buffer C Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Buffer D Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Flow Rate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Milliliter / Minute, 2 Milliliter / Minute],
								Units -> CompoundUnit[
									{1, {Milliliter, {Milliliter, Liter}}},
									{-1, {Minute, {Minute, Second}}}
								]
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> StandardAnalytes,
				Default -> Automatic,
				Description -> "The compounds of interest that are present in the given Standard, used to determine the other settings for the Mass Spectrometer (e.g. MassRange).",
				ResolutionDescription -> "If populated, will resolve to the user-specified Analytes field in the Object[Sample]. Otherwise, will resolve to the larger compounds in the sample, in the order of Proteins, Peptides, Oligomers, then other small molecules; otherwise, set Null.",
				Category -> "Standard",
				AllowNull -> True,
				Widget -> Adder[
					Widget[Type -> Object, Pattern :> ObjectP[IdentityModelTypes]]
				]
			},
			{
				OptionName -> StandardIonMode,
				Default -> Automatic,
				Description -> "Indicates if positively or negatively charged ions are analyzed for the Standard.",
				ResolutionDescription -> "Set to the first IonMode for an analyte input sample.",
				Category -> "Standard",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> IonModeP
				]
			},
			{
				OptionName -> StandardMassSpectrometryMethod,
				Default -> Automatic,
				Description -> "The previously specified instruction(s) for the Standard ionization, selection, fragmentation, and detection.",
				ResolutionDescription -> "If Standard samples exist and MassSpectrometryMethod is specified, then set to the first available StandardMassSpectrometryMethod.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[Method, MassAcquisition]]
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[New]
					]
				]
			},
			{
				OptionName -> StandardESICapillaryVoltage,
				Default -> Automatic,
				Description -> "The absolute voltage applied to the tip of the stainless steel capillary tubing in order to produce charged droplets. Adjust this voltage to maximize sensitivity. Most compounds are optimized between 0.5 and 3.2 kV in ESI positive ion mode and 0.5 and 2.6 in ESI negative ion mode, but can be altered according to sample type. For low flow applications, best sensitivity will be achieved with a relatively high value in ESI positive (e.g. 3.0 kV), for standard flow UPLC a value of 0.5 kV is typically best for maximum sensitivity.",
				ResolutionDescription -> "Is automatically set to the first ESICapillaryVoltage.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-4 Kilovolt, 5 Kilovolt],
					Units -> {Kilovolt, {Millivolt, Volt, Kilovolt}}
				]
			},
			{
				OptionName -> StandardDeclusteringVoltage,
				Default -> Automatic,
				Description -> "The voltage offset between the ion block (the reduced pressure chamber of the source block) and the stepwave ion guide (the optics before the quadrupole mass analyzer). This voltage attracts charged ions in the spray being produced from the capillary tip into the ion block leading into the mass spectrometer. This voltage is typically set to 25-100 V and its tuning has little effect on sensitivity compared to other options (e.g. StandardStepwaveVoltage).",
				ResolutionDescription -> "Is automatically set to any specified MassAcquisition method; otherwise, set to 40 Volt.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Volt, 150 Volt],
					Units -> {Volt, {Millivolt, Volt, Kilovolt}}
				]
			},
			{
				OptionName -> StandardStepwaveVoltage,
				Default -> Automatic,
				Description -> "The voltage offset between the 1st and 2nd stage of the stepwave ion guide which leads ions coming from the sample cone towards the quadrupole mass analyzer. This voltage normally optimizes between 25 and 150 V and should be adjusted for sensitivity depending on compound and charge state. For multiply charged species it is typically set to to 40-50 V, and higher for singly charged species. In general higher cone voltages (120-150 V) are needed for larger mass ions such as intact proteins and monoclonal antibodies. It also has greatest effect on in-source fragmentation and should be decreased if in-source fragmentation is observed but not desired.",
				ResolutionDescription -> "Is automatically set to the first StepwaveVoltage.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Volt, 200 Volt],
					Units -> {Volt, {Millivolt, Volt, Kilovolt}}
				]
			},
			{
				OptionName -> StandardIonGuideVoltage,
				Default -> Automatic,
				Description -> "This option (also known as Entrance Potential (EP)) is a unique option of ESI-QQQ. This parameter indicates electric potential applied to the Ion Guide in ESI-QQQ, which guides and focuses the ions through the high-pressure ion guide region.",
				ResolutionDescription -> "Is automatically set to the first IonGuideVoltage.",
				AllowNull -> True,
				Category -> "Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-15 Volt, -2 Volt] | RangeP[2 Volt, 15 Volt],
					Units -> Volt
				]
			},
			{
				OptionName -> StandardSourceTemperature,
				Default -> Automatic,
				Description -> "The temperature setting of the source block. Heating the source block discourages condensation and decreases solvent clustering in the reduced vacuum region of the source. This temperature setting is flow rate and sample dependent. Typical values are between 60 to 120 Celsius. For thermally labile analytes, a lower temperature setting is recommended.",
				ResolutionDescription -> "Is automatically set to the first SourceTemperature.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[25 Celsius, 150 Celsius],
					Units -> Celsius
				]
			},
			{
				OptionName -> StandardDesolvationTemperature,
				Default -> Automatic,
				Description -> "The temperature setting for the ESI desolvation heater that controls the nitrogen gas temperature used for solvent evaporation to produce single gas phase ions from the ion spray. Similar to StandardDesolvationGasFlow, this setting is dependent on solvent flow rate and composition. A typical range is from 150 to 650 Celsius.",
				ResolutionDescription -> "Is automatically set to the first DesolvationTemperature.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[20 Celsius, 650 Celsius],
					Units -> Celsius
				]
			},
			{
				OptionName -> StandardDesolvationGasFlow,
				Default -> Automatic,
				Description -> "The rate at which nitrogen gas is flowed around the ESI capillary. It is used for solvent evaporation to produce single gas phase ions from the ion spray. Similar to StandardDesolvationTemperature, this setting is dependent on solvent flow rate and composition. Higher desolvation temperatures usually result in increased sensitivity, but too high values can cause spray instability. Typical values are between 300 to 1200 L/h.",
				ResolutionDescription -> "Is automatically set to the first DesolvationGasFlow.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :>RangeP[55 Liter/Hour, 1200 Liter/Hour] | RangeP[0 PSI, 85 PSI],
					Units -> Alternatives[
						CompoundUnit[
							{1, {Liter, {Liter, Milliliter}}},
							{-1, {Hour, {Hour, Minute}}}
						],
						PSI
					]
				]
			},
			{
				OptionName -> StandardConeGasFlow,
				Default -> Automatic,
				Description -> "The rate at which nitrogen gas is flowed around the sample inlet cone (the spherical metal plate acting as a first gate between the sprayer and the reduced pressure chamber, the ion block). This gas flow is used to minimize the formation of solvent ion clusters. It also helps reduce adduct ions and directing the spray into the ion block while keeping the sample cone clean. Typical values are between 0 and 150 L/h.",
				ResolutionDescription -> "Is automatically set to the first ConeGasFlow.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :>RangeP[0 Liter/Hour, 300 Liter/Hour] | RangeP[30 PSI, 55 PSI],
					Units -> Alternatives[
						CompoundUnit[
							{1, {Liter, {Liter, Milliliter}}},
							{-1, {Hour, {Hour, Minute}}}
						],
						PSI
					]
				]
			},(*
			IndexMatching[
				IndexMatchingParent -> StandardAcquisitionWindow,*)
			{
				OptionName -> StandardAcquisitionWindow,
				Default -> Automatic,
				Description -> "The time range with respect to the chromatographic separation to conduct standard analyte ionization, selection/survey, optional fragmentation, and detection.",
				ResolutionDescription -> "Set to the entire gradient window 0 Minute to the last time point in StandardGradient.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Minute,8 Hour],
							Units -> Minute
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Minute,8 Hour],
							Units -> Minute
						]
					],
					Adder[
						Alternatives[
							Span[
								Widget[
									Type -> Quantity,
									Pattern :> RangeP[0 Minute,8 Hour],
									Units -> Minute
								],
								Widget[
									Type -> Quantity,
									Pattern :> RangeP[0 Minute,8 Hour],
									Units -> Minute
								]
							]
						]
					]
				]
			},
			{
				OptionName -> StandardAcquisitionMode,
				Default -> Automatic,
				Description -> "The method by which spectra are collected. DataDependent will depend on the properties of the measured mass spectrum of the intact ions. DataIndependent will systemically scan through all of the intact ions. MS1 will focus on defined intact masses. MS1MS2ProductIonScan will focus on fragmented masses.",
				ResolutionDescription -> "Set to MS1FullScan unless DataDependent related options are set, then set to DataDependent.",
				Category -> "Standard",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> MSAcquisitionModeP (*DataIndependent|DataDependent|MS1FullScan|ProductIonScan(MS1MS2ProductIonScan)|SelectedIonMonitoring|NeutralIonLoss|ProductIonScan|MultipleReactionMonitoring*)
					],
					Adder[
						Widget[
							Type -> Enumeration,
							Pattern :> MSAcquisitionModeP (*DataIndependent|DataDependent|MS1FullScan|MS1MS2ProductIonScan|SelectedIonMonitoring|NeutralIonLoss|ProductIonScan|MultipleReactionMonitoring*)
						]
					]
				]
			},
			{
				OptionName -> StandardFragment,
				Default -> Automatic,
				Description -> "Indicates if ions should be collided with neutral gas and dissociated in order to measure the resulting product ions. Also known as tandem mass spectrometry or MS/MS (as opposed to MS).",
				ResolutionDescription -> "Set to True if StandardAcquisitionMode is MS1MS2ProductIonScan, DataDependent, or DataIndependent. Set True if any of the Fragmentation related options are set (e.g. StandardFragmentMassDetection).",
				Category -> "Standard",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					],
					Adder[
						Widget[
							Type -> Enumeration,
							Pattern :> BooleanP
						]
					]
				]
			},
			{
				OptionName -> StandardMassDetection,
				Default -> Automatic,
				Description -> "The lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for intact masses. When StandardFragment is True, the intact ions will be selected for fragmentation.",
				ResolutionDescription -> "For StandardFragment -> False, automatically set to one of three default mass ranges according to the molecular weight of the StandardAnalytes to encompass them.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Alternatives[
						"Single" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						],
						"Specific List" -> Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"Range" -> Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"All" -> Widget[
							Type -> Enumeration,
							Pattern :> MSAnalyteGroupP (*All|Peptide|SmallMolecule|Protein*)
						]
					],
					Adder[Alternatives[
						"Single" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						],
						"Specific List" -> Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"Range" -> Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"All" -> Widget[
							Type -> Enumeration,
							Pattern :> MSAnalyteGroupP (*All|Peptide|SmallMolecule|Protein*)
						]
					]]
				]
			},
			{
				OptionName -> StandardScanTime,
				Default -> Automatic,
				Description -> "The duration of time allowed to pass between each spectral acquisition. When StandardAcquisitionMode is DataDependent, this value refers to the duration for measuring spectra from the intact ions. Increasing this value improves sensitivity whereas decreasing this value allows for more data points and spectra to be acquired.",
				ResolutionDescription -> "Set to 0.2 seconds unless a method is given.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 10 Second],
						Units -> Second
					],
					Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.015 Second, 10 Second],
							Units -> Second
						]
					]
				]
			},
			{
				OptionName -> StandardFragmentMassDetection,
				Default -> Automatic,
				Description -> "The lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for product ions. When StandardAcquisitionMode is DataDependent|DataIndependent, all of the product ions in consideration for measurement.  Null if StandardFragment is False.",
				ResolutionDescription -> "When StandardFragment is False, set to Null. Otherwise, 20 Gram/Mole to the maximum StandardMassDetection.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Alternatives[
						"PrecursorIonScan" -> Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 16000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"ProductIonScan" -> Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 16000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[100 Gram / Mole, 16000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"DataDependent or DataIndependent" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[All]
						],
						"Null" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						],
						"MultipleReactionMonitoring" -> Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 2000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						]
					],
					Adder[Alternatives[
						"PrecursorIonScan" -> Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 16000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"ProductIonScan" -> Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 16000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[100 Gram / Mole, 16000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"DataDependent or DataIndependent" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[All]
						],
						"Null" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						],
						"MultipleReactionMonitoring" -> Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 2000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						]
					]]
				]
			},
			{
				OptionName -> StandardCollisionEnergy,
				Default -> Automatic,
				Description -> "The voltage by which intact ions are accelerated through inert gas in order to dissociate them into measurable fragment ion species when StandardFragment is True. StandardCollisionEnergy cannot be defined simultaneously with StandardCollisionEnergyMassProfile.",
				ResolutionDescription -> "Is automatically set to 40 Volt when StandardFragment is True, otherwise is set to Null.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.1 Volt, 255 Volt]| RangeP[-180 Volt, 5 Volt],
						Units -> {Volt, {Millivolt, Volt, Kilovolt}}
					],
					Adder[Alternatives[
						"Single Values"->Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt]| RangeP[-180 Volt, 5 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						],
						"A list of Single Values"->Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Volt, 180 Volt] | RangeP[-180 Volt, 5 Volt],
								Units -> Volt
							],
							Orientation->Vertical
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> StandardCollisionEnergyMassProfile,
				Default -> Automatic,
				Description -> "The relationship of collision energy with the StandardMassDetection.",
				ResolutionDescription -> "Set to StandardCollisionEnergyMassScan if defined; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						]
					],
					Adder[Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.1 Volt, 255 Volt],
								Units -> {Volt, {Millivolt, Volt, Kilovolt}}
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.1 Volt, 255 Volt],
								Units -> {Volt, {Millivolt, Volt, Kilovolt}}
							]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> StandardCollisionEnergyMassScan,
				Default -> Automatic,
				Description -> "The collision energy profile at the end of the scan from StandardCollisionEnergy or StandardCollisionEnergyScanProfile, as related to analyte mass.",
				AllowNull -> True,
				Category -> "Standard",
				Widget->Alternatives[
					Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						]
					],
					Adder[Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.1 Volt, 255 Volt],
								Units -> {Volt, {Millivolt, Volt, Kilovolt}}
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.1 Volt, 255 Volt],
								Units -> {Volt, {Millivolt, Volt, Kilovolt}}
							]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> StandardFragmentScanTime,
				Default -> Automatic,
				Description -> "The duration of the spectral scanning for each fragmentation of an intact ion when StandardAcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Automatically set to the same value as ScanTime if StandardAcquisitionMode is DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 10 Second],
						Units -> Second
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.015 Second, 10 Second],
							Units -> Second
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> StandardAcquisitionSurvey,
				Default -> Automatic,
				Description -> "The number of intact ions to consider for fragmentation and product ion measurement in every measurement cycle when StandardAcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Automatically set to 10 if StandardAcquisitionMode is set to DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[1, 30, 1]
					],
					Adder[Alternatives[
						Widget[
							Type -> Number,
							Pattern :> RangeP[1, 30, 1]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> StandardMinimumThreshold,
				Default -> Automatic,
				Description -> "The minimum number of total ions detected within ScanTime durations needed to trigger the start of data dependent acquisition when StandardAcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Automatically set to (100000/Second)*ScanTime if StandardAcquisitionMode is DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 ArbitraryUnit, 8000000 ArbitraryUnit],
						Units -> ArbitraryUnit
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 ArbitraryUnit, 8000000 ArbitraryUnit],
							Units -> ArbitraryUnit
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> StandardAcquisitionLimit,
				Default -> Automatic,
				Description -> "The maximum number of total ions for a specific intact ion when StandardAcquisitionMode is set to DataDependent. When this value is exceeded, acquisition will switch to fragmentation of the next candidate ion.",
				ResolutionDescription -> "Automatically inherited from supplied method if StandardAcquisitionMode is set to DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 ArbitraryUnit, 8000000 ArbitraryUnit],
						Units -> ArbitraryUnit
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 ArbitraryUnit, 8000000 ArbitraryUnit],
							Units -> ArbitraryUnit
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> StandardCycleTimeLimit,
				Default -> Automatic,
				Description -> "The maximum possible computed duration of all of the scans for the intact and fragmentation measurements when StandardAcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Calculated from the StandardAcquisitionSurvey, StandardScanTime, and StandardFragmentScanTime.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 20000 Second],
						Units -> Second
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.015 Second, 20000 Second],
							Units -> Second
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			(*IndexMatching[
					IndexMatchingParent -> ExclusionDomain,*)
			{
				OptionName -> StandardExclusionDomain,
				Default -> Automatic,
				Description -> "The time range when the StandardExclusionMasses are omitted in the chromatogram. Full indicates for the entire period.",
				ResolutionDescription -> "Set to the entire StandardAcquisitionWindow.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						]
					],
					Adder[Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]],
					Adder[Adder[Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						]
					]]]
				]
			},
			{
				OptionName -> StandardExclusionMass, (*Index matched to the exclusion domain*)
				Default -> Automatic,
				Description -> "The intact ions (Target Mass) to omit. When set to All, the mass is excluded for the entire StandardExclusionDomain. When set to Once, the mass is excluded in the first survey appearance, but considered for consequent ones.",
				ResolutionDescription -> "If any StandardExclusionMode-related options are set (e.g. StandardExclusionMassTolerance), a target mass of the first Analyte (if not in StandardInclusionMasses) is chosen and retention time is set to 0*Minute.",
				Category -> "Standard",
				AllowNull -> True,
				Widget -> Alternatives[
					{
						"Mode" -> Widget[
							Type-> Enumeration,
							Pattern:>All|Once
						],
						"Target Mass" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[2 Gram/Mole, 100000 Gram/Mole],
							Units -> Gram/Mole
						]
					},
					Adder[Alternatives[
						{
							"Mode" -> Widget[
								Type-> Enumeration,
								Pattern:>All|Once
							],
							"Target Mass" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram/Mole, 100000 Gram/Mole],
								Units -> Gram/Mole
							]
						},
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]],
					Adder[Adder[
						{
							"Mode" -> Widget[
								Type-> Enumeration,
								Pattern:>All|Once
							],
							"Target Mass" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram/Mole, 100000 Gram/Mole],
								Units -> Gram/Mole
							]
						}
					]]
				]
			},
			(*	], *)
			{
				OptionName -> StandardExclusionMassTolerance,
				Default -> Automatic,
				Description -> "The range above and below each ion in StandardExclusionMasses to consider for omission when StandardExclusionMass is All or Once.",
				ResolutionDescription -> "If StandardExclusionMass -> All or Once, set to 0.5 Gram/Mole; otherwise, Null.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
						Units -> Gram/Mole
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> StandardExclusionRetentionTimeTolerance,
				Default -> Automatic,
				Description -> "The range of time above and below the StandardExclusionDomain to consider for exclusion.",
				ResolutionDescription -> "If StandardExclusionMass and StandardExclusionDomain options are set, this is set to 10 seconds; otherwise, Null.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Second, 3600 Second],
						Units -> Second
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Second, 3600 Second],
							Units -> Second
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			(*IndexMatching[
					IndexMatchingParent -> InclusionDomain, *)
			{
				OptionName -> StandardInclusionDomain,
				Default -> Automatic,
				Description -> "The time range when StandardInclusionMass applies with respect to the chromatogram. Full indicates for the entire period.",
				ResolutionDescription -> "Set to the entire StandardAcquisitionWindow.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						]
					],
					Adder[Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]],
					Adder[Adder[Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						]
					]]]
				]
			},
			{
				OptionName -> StandardInclusionMass, (*Index matched to InclusionDomain*)
				Default -> Automatic,
				Description -> "The ions (Target Mass) to prioritize during the survey scan for further fragmentation when StandardAcquisitionMode is DataDependent. StandardInclusionMass set to Only will solely be considered for surveys. When Mode is Preferential, the InclusionMass will be prioritized for survey.",
				ResolutionDescription -> "When StandardInclusionMode  Only or Preferential, an entry mass is added based on the mass of the most salient analyte of the sample.",
				Category -> "Standard",
				AllowNull -> True,
				Widget -> Alternatives[
					{
						"Mode" -> Widget[ (*InclusionMassMode*)
							Type-> Enumeration,
							Pattern:>Only|Preferential
						],
						"Target Mass" -> Widget[ (*InclusionMass*)
							Type -> Quantity,
							Pattern :> RangeP[2 Gram/Mole, 4000 Gram/Mole],
							Units -> Gram/Mole
						]
					},
					Adder[Alternatives[
						{
							"Mode" -> Widget[ (*InclusionMassMode*)
								Type-> Enumeration,
								Pattern:>Only|Preferential
							],
							"Target Mass" -> Widget[ (*InclusionMass*)
								Type -> Quantity,
								Pattern :> RangeP[2 Gram/Mole, 4000 Gram/Mole],
								Units -> Gram/Mole
							]
						},
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]],
					Adder[Adder[
						{
							"Mode" -> Widget[ (*InclusionMassMode*)
								Type-> Enumeration,
								Pattern:>Only|Preferential
							],
							"Target Mass" -> Widget[ (*InclusionMass*)
								Type -> Quantity,
								Pattern :> RangeP[2 Gram/Mole, 4000 Gram/Mole],
								Units -> Gram/Mole
							]
						}
					]]
				]
			},
			{
				OptionName -> StandardInclusionCollisionEnergy, (*Index matched to StandardInclusionDomain*)
				Default -> Automatic,
				Description -> "The overriding collision energy value that can be applied to the StandardInclusionMass. Null will default to the StandardCollisionEnergy option and related options.",
				ResolutionDescription -> "Inherited from any supplied method.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Volt, 255 Volt],
						Units -> Volt
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Volt, 255 Volt],
							Units -> Volt
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]],
					Adder[Adder[Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Volt, 255 Volt],
						Units -> Volt
					]]]
				]
			},
			{
				OptionName -> StandardInclusionDeclusteringVoltage,
				Default -> Automatic,
				Description -> "The overriding source voltage value that can be applied to the StandardInclusionMass. Null will default to the StandardDeclusteringVoltage option.",
				ResolutionDescription -> "Inherited from any supplied method.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[ (*InclusionDeclusteringVoltage*)
						Type -> Quantity,
						Pattern :> RangeP[0.1 Volt, 150 Volt],
						Units -> Volt
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 150 Volt],
							Units -> Volt
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]],
					Adder[Adder[Widget[ (*InclusionDeclusteringVoltage*)
						Type -> Quantity,
						Pattern :> RangeP[0.1 Volt, 150 Volt],
						Units -> Volt
					]]]
				]
			},
			{
				OptionName -> StandardInclusionChargeState,
				Default -> Automatic,
				Description -> "The maximum charge state of the StandardInclusionMass to also consider for inclusion. For example, if this is set to 3 and the polarity is Positive, then +1,+2,+3 charge states will be considered as well.",
				ResolutionDescription -> "Inherited from any supplied method.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[0, 6, 1]
					],
					Adder[Alternatives[
						Widget[
							Type -> Number,
							Pattern :> RangeP[0, 6, 1]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]],
					Adder[Adder[Widget[
						Type -> Number,
						Pattern :> RangeP[0, 6, 1]
					]]]
				]
			},
			{
				OptionName -> StandardInclusionScanTime,
				Default -> Automatic,
				Description -> "The overriding scan time duration that can be applied to the StandardInclusionMass for the consequent fragmentation. Null will default to the StandardFragmentScanTime option.",
				ResolutionDescription -> "Inherited from any supplied method.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 10 Second],
						Units -> Second
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.015 Second, 10 Second],
							Units -> Second
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]],
					Adder[Adder[Widget[ (*InclusionScanTime*)
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 10 Second],
						Units -> Second
					]]]
				]
			},
			(*)]*)
			{
				OptionName -> StandardInclusionMassTolerance,
				Default -> Automatic,
				Description -> "The range above and below each ion in StandardInclusionMass to consider for prioritization. For example, if set to 0.5 Gram/Mole, the total range is 1 Gram/Mole.",
				ResolutionDescription -> "Set to 0.5 Gram/Mole if StandardInclusionMass is given; otherwise, Null.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
						Units -> Gram/Mole
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> StandardSurveyChargeStateExclusion,
				Default -> Automatic,
				Description -> "Indicates if redundant ions that differ by ionic charge (+1/-1, +2/-2, etc.) should be excluded and if StandardChargeState exclusion-related options should be automatically filled in.",
				ResolutionDescription -> "Set to True, if any of the StandardChargeState options are set; otherwise, False.",
				Category -> "Standard",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					],
					Adder[Alternatives[
						Widget[
							Type -> Enumeration,
							Pattern :> BooleanP
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> StandardSurveyIsotopeExclusion,
				Default -> Automatic,
				Description -> "Indicates if redundant ions that differ by isotopic mass (e.g. 1, 2 Gram/Mole) should be excluded and if StandardMassIsotope exclusion-related options should be automatically filled in.",
				ResolutionDescription -> "Set to True, if any of the StandardIsotopeExclusion options are set; otherwise, False.",
				Category -> "Standard",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					],
					Adder[Alternatives[
						Widget[
							Type -> Enumeration,
							Pattern :> BooleanP
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> StandardChargeStateExclusionLimit,
				Default -> Automatic,
				Description -> "The number of ions to survey first with exclusion by ionic state. For example, if StandardAcquisitionSurvey is 10 and this option is 5, then 5 ions will be surveyed with charge-state exclusion. For candidate ions of rank 6 to 10, no exclusion will be performed.",
				ResolutionDescription -> "Inherited from any supplied method; otherwise, set the same to StandardAcquisitionSurvey, if any ChargeState option is set.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[0, 30, 1]
					],
					Adder[Alternatives[
						Widget[
							Type -> Number,
							Pattern :> RangeP[0, 30, 1]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				],
				Category -> "Standard"
			},
			{
				OptionName -> StandardChargeStateExclusion,
				Default -> Automatic,
				Description -> "The specific ionic states of intact ions to redundantly exclude from the survey for further fragmentation/acquisition. 1 refers to +1/-1, 2 refers to +2/-2, etc.",
				ResolutionDescription -> "When StandardSurveyChargeStateExclusion is True, set to {1,2}; otherwise, Null.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[1, 6, 1]
					],
					Adder[Alternatives[
						Widget[
							Type -> Number,
							Pattern :> RangeP[1, 6, 1]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						],
						Adder[
							Widget[
								Type -> Number,
								Pattern :> RangeP[1, 6, 1]
							]
						]
					]]
				],
				Category -> "Standard"
			},
			{
				OptionName -> StandardChargeStateMassTolerance,
				Default -> Automatic,
				Description -> "The range of m/z to consider for exclusion by ionic state property when StandardSurveyChargeStateExclusion is True.",
				ResolutionDescription -> "When StandardSurveyChargeStateExclusion is True, set to 0.5 Gram/Mole; otherwise, Null.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
						Units -> Gram/Mole
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			(*	IndexMatching[
					IndexMatchingParent -> IsotopicExclusion,*)
			{
				OptionName -> StandardIsotopicExclusion,
				Default -> Automatic,
				Description -> "The m/z difference between monoisotopic ions as a criterion for survey exclusion.",
				ResolutionDescription -> "When StandardSurveyIsotopeExclusion is True, set to 1 Gram/Mole; otherwise, Null.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
						Units -> Gram/Mole
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						],
						Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
								Units -> Gram/Mole
							]
						]
					]]
				]
			},
			{
				OptionName -> StandardIsotopeRatioThreshold, (*index matching IsotopicExclusion*)
				Default -> Automatic, (*TODO: Figure *)
				Description -> "The minimum relative magnitude between monoisotopic ions in order to be considered for exclusion.",
				ResolutionDescription -> "When StandardSurveyIsotopeExclusion is True, set to 0.1; otherwise, Null.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[0, 1]
					],
					Adder[
						Alternatives[
							Widget[
								Type -> Number,
								Pattern :> RangeP[0, 1]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							],
							Adder[
								Widget[
									Type -> Number,
									Pattern :> RangeP[0, 1]
								]
							]
						]
					]
				],
				Category -> "Standard"
			}
			(*]*),
			{ (*index matching to above*)
				OptionName -> StandardIsotopeDetectionMinimum,
				Default -> Automatic,
				Description -> "The acquisition rate of a given intact mass to consider for isotope exclusion in the survey.",
				ResolutionDescription -> "When StandardSurveyIsotopeExclusion is True, set to 10 1/Second; otherwise, Null.",
				Category -> "Standard",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 * 1 / Second],
						Units -> {-1, {Minute, {Minute, Second}}}
					],
					Adder[
						Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 * 1 / Second],
								Units -> {-1, {Minute, {Minute, Second}}}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							],
							Adder[
								Widget[
									Type -> Quantity,
									Pattern :> GreaterEqualP[0 * 1 / Second],
									Units -> {-1, {Minute, {Minute, Second}}}
								]
							]
						]
					]
				]
			},
			{
				OptionName -> StandardIsotopeMassTolerance,
				Default -> Automatic,
				Description -> "The range of m/z around a mass to consider for exclusion. This applies for both ChargeState and mass shifted Isotope. If set to 0.5 Gram/Mole, then the total range should be 1 Gram/Mole.",
				ResolutionDescription -> "When StandardSurveyIsotopeExclusion or StandardSurveyChargeStateExclusion is True, set to 0.5 Gram/Mole; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
						Units -> Gram/Mole
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> StandardIsotopeRatioTolerance,
				Default -> Automatic,
				Description -> "The range of relative magnitude around StandardIsotopeRatio to consider for isotope exclusion.",
				ResolutionDescription -> "If StandardSurveyIsotopeExclusion is True, set to 30*Percent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent,100Percent],
						Units -> Percent
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent,100Percent],
							Units -> Percent
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> StandardDwellTime,
				Default -> Automatic,
				Description -> "The duration of time for which spectra are acquired at the specific mass detection value for SelectedIonMonitoring and MultipleReactionMonitoring mode in ESI-QQQ.",
				ResolutionDescription -> "Is automatically set to 200 microsecond if StandardAcquisition is in SelectedIonMonitoring or MultipleReactionMonitoring mode. Otherwise is set to Null.",
				AllowNull -> True,
				Category -> "Standard",
				Widget ->Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[5 Millisecond,  2000 Millisecond],
						Units -> {Millisecond, {Millisecond,Second,Minute}}
					],
					Adder[
						Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Millisecond,  2000 Millisecond],
								Units -> {Millisecond, {Millisecond,Second,Minute}}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							],
							Adder[
								Widget[
									Type -> Quantity,
									Pattern :> RangeP[5 Millisecond,  2000 Millisecond],
									Units -> {Millisecond, {Millisecond,Second,Minute}}
								]
							]
						],
						Orientation->Vertical
					]
				]
			},
			{
				OptionName -> StandardCollisionCellExitVoltage,
				Default -> Automatic,
				Description ->"Also known as the Collision Cell Exit Potential (CXP). This value focuses and accelerates the ions out of collision cell (Q2) and into 2nd mass analyzer (MS 2). This potential is tuned to ensure successful ion acceleration out of collision cell and into MS2, and can be adjusted to reach the maximal signal intensity. This option is unique to ESI-QQQ for now, and only required when Fragment ->True and/or in ScanMode that achieves tandem mass feature (PrecursorIonScan, NeutralIonLoss,ProductIonScan,MultipleReactionMonitoring). For non-tandem mass ScanMode (FullScan and SelectedIonMonitoring) and other massspectrometer (ESI-QTOF and MALDI-TOF), this option is resolved to Null.",
				ResolutionDescription ->"For TripleQuadrupole as the MassAnalyzer, is set to first CollisionCellExitVoltage, otherwise set to Null.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[-55 Volt, 55 Volt],
						Units -> Volt
					],
					Adder[
						Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[-55 Volt, 55 Volt],
								Units -> Volt
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]
					]
				]
			},
			{
				OptionName -> StandardMassDetectionStepSize,
				Default -> Automatic,
				Description ->"Indicate the step size for mass collection in range when using TripleQuadruploe as the MassAnalyzer.",
				ResolutionDescription ->"Is set to first MassDetectionStepSize",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.01 Gram/Mole, 1 Gram/Mole],
						Units -> CompoundUnit[
							{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
							{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
						]
					],
					Adder[
						Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.01 Gram/Mole, 1 Gram/Mole],
								Units -> CompoundUnit[
									{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
									{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
								]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]
					]
				]
			},
			{
				OptionName -> StandardNeutralLoss,
				Default -> Automatic,
				Description ->"A neutral loss scan is performed on ESI-QQQ mass spectrometry by scanning the sample through the first quadrupole (Q1). The ions are then fragmented in the collision cell. The second mass analyzer is then scanned with a fixed offset to MS1. This option represents the value of this offset.",
				ResolutionDescription ->"Is set to 500 g/mol if using NeutralIonLoss as StandardAcquisitionMode, and is Null in other modes.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 Gram/Mole],
						Units -> CompoundUnit[
							{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
							{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
						]
					],
					Adder[
						Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Gram/Mole],
								Units -> CompoundUnit[
									{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
									{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
								]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]
					]
				]
			},
			{
				OptionName -> StandardMultipleReactionMonitoringAssays,
				Default -> Automatic,
				Description -> "In ESI-QQQ mass spectrometry analysis, the ion corresponding to the compound of interest is targeted with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and DwellTime (length of time of each scan).",
				ResolutionDescription -> "Is set based on StandardMassDetection, StandardCollisionEnergy, StandardDwellTime and StandardFragmentMassDetection.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Adder[
						Alternatives[
							"Individual Multiple Reaction Monitoring Assay" -> Adder[{
								"Mass Selection Values" -> Widget[
									Type -> Quantity,
									Pattern :> GreaterP[0 Gram / Mole],
									Units -> CompoundUnit[
										{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
										{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
									]
								],
								"CollisionEnergies" -> Alternatives[
									Widget[
										Type -> Quantity,
										Pattern :> RangeP[5 Volt, 180 Volt] | RangeP[-180 Volt, 5 Volt],
										Units -> Volt
									],
									Widget[
										Type -> Enumeration,
										Pattern :> Alternatives[Automatic]
									]
								],
								"Fragment Mass Selection Values" -> Widget[
									Type -> Quantity,
									Pattern :> GreaterP[0 Gram / Mole],
									Units -> CompoundUnit[
										{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
										{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
									]
								],
								"Dwell Times" -> Alternatives[
									Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0 Second],
										Units -> {Millisecond, {Microsecond, Millisecond, Second}}
									],
									Widget[
										Type -> Enumeration,
										Pattern :> Alternatives[Automatic]
									]
								]
							}],
							{
								"Multiple Reaction Monitoring Assays" -> Adder[{
									"Mass Selection Values" -> Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0 Gram / Mole],
										Units -> CompoundUnit[
											{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
											{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
										]
									],
									"CollisionEnergies" -> Alternatives[
										Widget[
											Type -> Quantity,
											Pattern :> RangeP[5 Volt, 180 Volt] | RangeP[-180 Volt, 5 Volt],
											Units -> Volt
										],
										Widget[
											Type -> Enumeration,
											Pattern :> Alternatives[Automatic]
										]
									],
									"Fragment Mass Selection Values" -> Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0 Gram / Mole],
										Units -> CompoundUnit[
											{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
											{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
										]
									],
									"Dwell Times" -> Alternatives[
										Widget[
											Type -> Quantity,
											Pattern :> GreaterP[0 Second],
											Units -> {Millisecond, {Microsecond, Millisecond, Second}}
										],
										Widget[
											Type -> Enumeration,
											Pattern :> Alternatives[Automatic]
										]
									]
								}]
							},
							"None" -> Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null, {Null}]
							]
						],
						Orientation -> Vertical
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					]
				]
			},
			(*],*)

			{
				OptionName -> StandardAbsorbanceWavelength,
				Default -> Automatic,
				Description -> "For Standard measurement, the wavelength of light passed through the flow cell for the PhotoDiodeArray (PDA) Detector. A 3D data is generated from a spectrum of light passing through the flow cell. Absorbance wavelength represents the wavelength at which a 2D data slice is generated from the 3D data.",
				ResolutionDescription -> "Automatically set to the same as the first entry in AbsorbanceWavelength.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Single" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[190 Nanometer, 500 Nanometer, 1 Nanometer],
						Units -> Nanometer
					],
					"All" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					],
					"Range" -> Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[190 Nanometer, 490 Nanometer, 1 Nanometer],
							Units -> Nanometer
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[200 Nanometer, 500 Nanometer, 1 Nanometer],
							Units -> Nanometer
						]
					]
				],
				Category -> "Standard"
			},
			{
				OptionName -> StandardWavelengthResolution,
				Default -> Automatic,
				Description -> "The increment in wavelength for the range of wavelength of light passed through the flow for absorbance measurement for the instruments with PhotoDiodeArray Detector for Standard measurement.",
				ResolutionDescription -> "Automatically set to the same as the first entry in WavelengthResolution.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1.2 * Nanometer, 12.0 * Nanometer], (*this can only go to specific values*)
					Units -> Nanometer
				],
				Category -> "Standard"
			},
			{
				OptionName -> StandardUVFilter,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if UV wavelengths (less than 210 nm) should be blocked from being transmitted through the sample for the PhotoDiodeArray (PDA) detector for Standard measurement.",
				ResolutionDescription -> "Automatically set to the same as the first entry in UVFilter.",
				Category -> "Standard"
			},
			{
				OptionName -> StandardAbsorbanceSamplingRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * 1 / Second, 80 * 1 / Second, 1 * 1 / Second], (*can be only specific values*)
					Units -> {-1, {Minute, {Minute, Second}}}
				],
				Description -> "The number of times an absorbance measurement is made per second for Standard sample. Lower values will be less susceptible to noise but will record less frequently across time.",
				ResolutionDescription -> "Automatically set to the same as the first entry in AbsorbanceSamplingRate.",
				Category -> "Standard"
			},
			{
				OptionName -> StandardStorageCondition,
				Default -> Null,
				Description -> "The non-default conditions under which any standards used by this experiment should be stored after the protocol is completed. If left unset, the standard samples will be stored according to their Models' DefaultStorageCondition.",
				AllowNull -> True,
				Category -> "Standard",
				(* Null indicates the storage conditions will be inherited from the model *)
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal]
				]
			}
		],
		IndexMatching[
			IndexMatchingParent -> Blank,
			{
				OptionName -> Blank,
				Default -> Automatic,
				Description -> "The object(s) (samples) to inject typically as negative controls (e.g. to test effects stemming from injection, sample solvent, impurities on the column or buffer).",
				ResolutionDescription -> "If any other Blank option is specified or RefractiveIndex Detector is selected, automatically set to the specified BufferA or Model[Sample, \"Milli-Q water\"].",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Buffers",
							"HPLC Buffers"
						},
						{
							Object[Catalog, "Root"],
							"Materials",
							"Reagents",
							"Water"
						}
					}
				]
			},
			{
				OptionName -> BlankInjectionVolume,
				Default -> Automatic,
				Description -> "The physical quantity of Blank sample that is loaded into the flow path on the selected instrument along with the mobile phase onto the stationary phase.",
				ResolutionDescription -> "Automatically set equal to the first entry in InjectionVolume.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter, 500 Microliter],
					Units -> Microliter
				]
			}
		],
		{
			OptionName -> BlankFrequency,
			Default -> Automatic,
			Description -> "The frequency at which Blank measurements will be inserted between Sample.",
			ResolutionDescription -> "If injectionTable is given, automatically set to Null and the sequence of Blanks specified in the InjectionTable will be used in the experiment. If any other Blank option is specified, automatically set to FirstAndLast.",
			AllowNull -> True,
			Category -> "Blanks",
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> None | First | Last | FirstAndLast | GradientChange
				],
				Widget[
					Type -> Number,
					Pattern :> GreaterP[0, 1]
				]
			]
		},
		IndexMatching[
			IndexMatchingParent -> Blank,
			{
				OptionName -> BlankColumnTemperature,
				Default -> Automatic,
				Description -> "The temperature of the column when the Blank gradient and measurement are run. If BlankColumnTemperature is set to Ambient, column oven temperature control is not used. Otherwise, BlankColumnTemperature is maintained by temperature control of the column oven.",
				ResolutionDescription -> "Automatically set to the corresponding gradient temperature specified in the BlankGradient option or the column temperature for the sample in the InjectionTable option; otherwise, set as the first value of the ColumnTemperature option.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[30 Celsius, 90 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				]
			},
			{
				OptionName -> BlankGradientA,
				Default -> Automatic,
				Description -> "The composition of BufferA within the flow, defined for specific time points for Blank measurement. The composition is linearly interpolated for the intervening periods between the defined time points. For example for BlankGradientA->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferA in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
				ResolutionDescription -> "If BlankGradient option is specified, set from it or implicitly determined from the BlankGradientB, BlankGradientC, and BlankGradientD options such that the total amounts to 100%.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Minute, $MaxExperimentTime],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer A Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> BlankGradientB,
				Default -> Automatic,
				Description -> "The composition of BufferB within the flow, defined for specific time points for Blank measurement. The composition is linearly interpolated for the intervening periods between the defined time points. For example for BlankGradientB->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferB in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
				ResolutionDescription -> "If BlankGradient option is specified, set from it or implicitly determined from the BlankGradientA, BlankGradientC, and BlankGradientD options such that the total amounts to 100%.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Minute, $MaxExperimentTime],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer B Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> BlankGradientC,
				Default -> Automatic,
				Description -> "The composition of BufferC within the flow, defined for specific time points for Blank measurement. The composition is linearly interpolated for the intervening periods between the defined time points. For example for BlankGradientC->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferC in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
				ResolutionDescription -> "If BlankGradient option is specified, set from it or implicitly determined from the BlankGradientA, BlankGradientB, and BlankGradientD options such that the total amounts to 100%.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Minute, $MaxExperimentTime],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer C Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> BlankGradientD,
				Default -> Automatic,
				Description -> "The composition of BufferD within the flow, defined for specific time points for Blank measurement. The composition is linearly interpolated for the intervening periods between the defined time points. For example for BlankGradientD->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferD in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
				ResolutionDescription -> "If BlankGradient option is specified, set from it or implicitly determined from the BlankGradientA, BlankGradientB, and BlankGradientC options such that the total amounts to 100%.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Minute, $MaxExperimentTime],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer D Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> BlankFlowRate,
				Default -> Automatic,
				Description -> "The net speed of the fluid flowing through the pump inclusive of the composition of BufferA, BufferB, BufferC, and BufferD specified in the BlankGradient options during Blank measurement. This speed is linearly interpolated such that consecutive entries of {Time, Flow Rate} will define the intervening fluid speed. For example, {{0 Minute, 0.3 Milliliter/Minute},{30 Minute, 0.5 Milliliter/Minute}} means flow rate of 0.4 Milliliter/Minute at 15 minutes into the run.",
				ResolutionDescription -> "If BlankGradient option is specified, automatically set from the method given in the BlankGradient option. If NominalFlowRate of the column model is specified, set to lesser of the NominalFlowRate for each of the columns, guard columns or the instrument's MaxFlowRate. Otherwise set to 1 Milliliter / Minute.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Milliliter / Minute, 2 Milliliter / Minute],
						Units -> CompoundUnit[
							{1, {Milliliter, {Milliliter, Liter}}},
							{-1, {Minute, {Minute, Second}}}
						]
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Minute, $MaxExperimentTime],
								Units -> {Minute, {Second, Minute}}
							],
							"Flow Rate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Milliliter / Minute, 2 Milliliter / Minute],
								Units -> CompoundUnit[
									{1, {Milliliter, {Milliliter, Liter}}},
									{-1, {Minute, {Minute, Second}}}
								]
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> BlankGradient,
				Default -> Automatic,
				Description -> "The composition of different specified buffers in BufferA, BufferB, BufferC and BufferD over time in the fluid flow during Blank measurement. Specific parameters of a gradient object can be overridden by specific options.",
				ResolutionDescription -> "Automatically set to best meet all the BlankGradient options (e.g. BlankGradientA, BlankGradientB, BlankGradientC, BlankGradientD, BlankFlowRate).",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[Type -> Object, Pattern :> ObjectP[Object[Method, Gradient]]],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Minute, $MaxExperimentTime],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer A Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Buffer B Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Buffer C Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Buffer D Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Flow Rate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Milliliter / Minute, 2 Milliliter / Minute],
								Units -> CompoundUnit[
									{1, {Milliliter, {Milliliter, Liter}}},
									{-1, {Minute, {Minute, Second}}}
								]
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> BlankAnalytes,
				Default -> Automatic,
				Description -> "The compounds of interest that are present in the given Blank samples, used to determine the other settings for the Mass Spectrometer (e.g. MassRange).",
				ResolutionDescription -> "If populated, will resolve to the user-specified Analytes field in the Object[Sample]. Otherwise, will resolve to the larger compounds in the sample, in the order of Proteins, Peptides, Oligomers, then other small molecules. Otherwise, set Null.",
				Category -> "Blanks",
				AllowNull -> True,
				Widget -> Adder[
					Widget[Type -> Object, Pattern :> ObjectP[IdentityModelTypes]]
				]
			},
			{
				OptionName -> BlankIonMode,
				Default -> Automatic,
				Description -> "Indicates if positively or negatively charged ions are analyzed.",
				ResolutionDescription -> "Set to the first IonMode for an analyte input sample.",
				Category -> "Blanks",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> IonModeP
				]
			},
			{
				OptionName -> BlankMassSpectrometryMethod,
				Default -> Automatic,
				Description -> "The previously specified instruction(s) for the analyte ionization, selection, fragmentation, and detection.",
				ResolutionDescription -> "If Blank samples exist and MassSpectrometryMethod is specified, then set to the first available BlankMassSpectrometryMethod.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[Method, MassAcquisition]]
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[New]
					]
				]
			}, (*
			IndexMatching[
				IndexMatchingParent -> BlankAcquisitionWindow,*)

			{
				OptionName -> BlankESICapillaryVoltage,
				Default -> Automatic,
				Description -> "The absolute voltage applied to the tip of the stainless steel capillary tubing in order to produce charged droplets. Adjust this voltage to maximize sensitivity. Most compounds are optimized between 0.5 and 3.2 kV in ESI positive ion mode and 0.5 and 2.6 in ESI negative ion mode, but can be altered according to sample type. For low flow applications, best sensitivity will be achieved with a relatively high value in ESI positive (e.g. 3.0 kV), for blank flow UPLC a value of 0.5 kV is typically best for maximum sensitivity.",
				ResolutionDescription -> "Is automatically set to the first ESICapillaryVoltage.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-4 Kilovolt, 5 Kilovolt],
					Units -> {Kilovolt, {Millivolt, Volt, Kilovolt}}
				]
			},
			{
				OptionName -> BlankDeclusteringVoltage,
				Default -> Automatic,
				Description -> "The voltage offset between the ion block (the reduced pressure chamber of the source block) and the stepwave ion guide (the optics before the quadrupole mass analyzer). This voltage attracts charged ions in the spray being produced from the capillary tip into the ion block leading into the mass spectrometer. This voltage is typically set to 25-100 V and its tuning has little effect on sensitivity compared to other options (e.g. BlankStepwaveVoltage).",
				ResolutionDescription -> "Is automatically set to any specified MassAcquisition method; otherwise, set to 40 Volt.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Volt, 150 Volt],
					Units -> {Volt, {Millivolt, Volt, Kilovolt}}
				]
			},
			{
				OptionName -> BlankStepwaveVoltage,
				Default -> Automatic,
				Description -> "The voltage offset between the 1st and 2nd stage of the stepwave ion guide which leads ions coming from the sample cone towards the quadrupole mass analyzer. This voltage normally optimizes between 25 and 150 V and should be adjusted for sensitivity depending on compound and charge state. For multiply charged species it is typically set to to 40-50 V, and higher for singly charged species. In general higher cone voltages (120-150 V) are needed for larger mass ions such as intact proteins and monoclonal antibodies. It also has greatest effect on in-source fragmentation and should be decreased if in-source fragmentation is observed but not desired.",
				ResolutionDescription -> "Is automatically set to the first StepwaveVoltage.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 Volt, 200 Volt],
					Units -> {Volt, {Millivolt, Volt, Kilovolt}}
				]
			},
			{
				OptionName -> BlankIonGuideVoltage,
				Default -> Automatic,
				Description -> "This option (also known as Entrance Potential (EP)) is a unique option of ESI-QQQ. This parameter indicates electric potential applied to the Ion Guide in ESI-QQQ, which guides and focuses the ions through the high-pressure ion guide region.",
				ResolutionDescription -> "Is automatically set to the first IonGuideVoltage.",
				AllowNull -> True,
				Category -> "Ionization",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-15 Volt, -2 Volt] | RangeP[2 Volt, 15 Volt],
					Units -> Volt
				]
			},
			{
				OptionName -> BlankSourceTemperature,
				Default -> Automatic,
				Description -> "The temperature setting of the source block. Heating the source block discourages condensation and decreases solvent clustering in the reduced vacuum region of the source. This temperature setting is flow rate and sample dependent. Typical values are between 60 to 120 Celsius. For thermally labile analytes, a lower temperature setting is recommended.",
				ResolutionDescription -> "Is automatically set to the first SourceTemperature.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[25 Celsius, 150 Celsius],
					Units -> Celsius
				]
			},
			{
				OptionName -> BlankDesolvationTemperature,
				Default -> Automatic,
				Description -> "The temperature setting for the ESI desolvation heater that controls the nitrogen gas temperature used for solvent evaporation to produce single gas phase ions from the ion spray. Similar to BlankDesolvationGasFlow, this setting is dependent on solvent flow rate and composition. A typical range is from 150 to 650 Celsius.",
				ResolutionDescription -> "Is automatically set to the first DesolvationTemperature.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[20 Celsius, 650 Celsius],
					Units -> Celsius
				]
			},
			{
				OptionName -> BlankDesolvationGasFlow,
				Default -> Automatic,
				Description -> "The rate at which nitrogen gas is flowed around the ESI capillary. It is used for solvent evaporation to produce single gas phase ions from the ion spray. Similar to BlankDesolvationTemperature, this setting is dependent on solvent flow rate and composition. Higher desolvation temperatures usually result in increased sensitivity, but too high values can cause spray instability. Typical values are between 300 to 1200 L/h.",
				ResolutionDescription -> "Is automatically set to the first DesolvationGasFlow.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :>RangeP[55 Liter/Hour, 1200 Liter/Hour] | RangeP[0 PSI, 85 PSI],
					Units -> Alternatives[
						CompoundUnit[
							{1, {Liter, {Liter, Milliliter}}},
							{-1, {Hour, {Hour, Minute}}}
						],
						PSI
					]
				]
			},
			{
				OptionName -> BlankConeGasFlow,
				Default -> Automatic,
				Description -> "The rate at which nitrogen gas is flowed around the sample inlet cone (the spherical metal plate acting as a first gate between the sprayer and the reduced pressure chamber, the ion block). This gas flow is used to minimize the formation of solvent ion clusters. It also helps reduce adduct ions and directing the spray into the ion block while keeping the sample cone clean. Typical values are between 0 and 150 L/h.",
				ResolutionDescription -> "Is automatically set to the first ConeGasFlow.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :>RangeP[0 Liter/Hour, 300 Liter/Hour] | RangeP[30 PSI, 55 PSI],
					Units -> Alternatives[
						CompoundUnit[
							{1, {Liter, {Liter, Milliliter}}},
							{-1, {Hour, {Hour, Minute}}}
						],
						PSI
					]
				]
			},
			{
				OptionName -> BlankAcquisitionWindow,
				Default -> Automatic,
				Description -> "The time range with respect to the chromatographic separation to conduct analyte ionization, selection/survey, optional fragmentation, and detection.",
				ResolutionDescription -> "Set to the entire gradient window 0 Minute to the last time point in BlankGradient.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Minute,8 Hour],
							Units -> Minute
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Minute,8 Hour],
							Units -> Minute
						]
					],
					Adder[
						Alternatives[
							Span[
								Widget[
									Type -> Quantity,
									Pattern :> RangeP[0 Minute,8 Hour],
									Units -> Minute
								],
								Widget[
									Type -> Quantity,
									Pattern :> RangeP[0 Minute,8 Hour],
									Units -> Minute
								]
							]
						]
					]
				]
			},
			{
				OptionName -> BlankAcquisitionMode,
				Default -> Automatic,
				Description -> "The method by which spectra are collected. DataDependent will depend on the properties of the measured mass spectrum of the intact ions. DataIndependent will systemically scan through all of the intact ions. MS1 will focus on defined intact masses. MS1MS2 will focus on fragmented masses.",
				ResolutionDescription -> "Set to MS1FullScan unless DataDependent related options are set, then set to DataDependent.",
				Category -> "Blanks",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> MSAcquisitionModeP (*DataIndependent|DataDependent|MS1FullScan|MS1MS2ProductIonScan|SelectedIonMonitoring|NeutralIonLoss|ProductIonScan|MultipleReactionMonitoring*)
					],
					Adder[
						Widget[
							Type -> Enumeration,
							Pattern :> MSAcquisitionModeP (*DataIndependent|DataDependent|MS1FullScan|MS1MS2ProductIonScan|SelectedIonMonitoring|NeutralIonLoss|ProductIonScan|MultipleReactionMonitoring*)
						]
					]
				]
			},
			{
				OptionName -> BlankFragment,
				Default -> Automatic,
				Description -> "Indicates if ions should be collided with neutral gas and dissociated in order to measure the resulting product ions. Also known as tandem mass spectrometry or MS/MS (as opposed to MS).",
				ResolutionDescription -> "Set to True if BlankAcquisitionMode is MS1MS2ProductIonScan, DataDependent, or DataIndependent. Set True if any of the Fragmentation related options are set (e.g. BlankFragmentMassDetection).",
				Category -> "Blanks",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					],
					Adder[
						Widget[
							Type -> Enumeration,
							Pattern :> BooleanP
						]
					]
				]
			},
			{
				OptionName -> BlankMassDetection,
				Default -> Automatic,
				Description -> "The lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for intact masses. When BlankFragment is True, the intact ions will be selected for fragmentation.",
				ResolutionDescription -> "For BlankFragment -> False, automatically set to one of three default mass ranges according to the molecular weight of the BlankAnalytes to encompass them.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Alternatives[
						"Single" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						],
						"Specific List" -> Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"Range" -> Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"All" -> Widget[
							Type -> Enumeration,
							Pattern :> MSAnalyteGroupP (*All|Peptide|SmallMolecule|Protein*)
						]
					],
					Adder[Alternatives[
						"Single" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						],
						"Specific List" -> Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"Range" -> Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"All" -> Widget[
							Type -> Enumeration,
							Pattern :> MSAnalyteGroupP (*All|Peptide|SmallMolecule|Protein*)
						]
					]]
				]
			},
			{
				OptionName -> BlankScanTime,
				Default -> Automatic,
				Description -> "The duration of time allowed to pass between each spectral acquisition. When BlankAcquisitionMode is DataDependent, this value refers to the duration for measuring spectra from the intact ions. Increasing this value improves sensitivity whereas decreasing this value allows for more data points and spectra to be acquired.",
				ResolutionDescription -> "Set to 0.2 seconds unless a method is given.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 10 Second],
						Units -> Second
					],
					Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.015 Second, 10 Second],
							Units -> Second
						]
					]
				]
			},
			{
				OptionName -> BlankFragmentMassDetection,
				Default -> Automatic,
				Description -> "The lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for product ions. When BlankAcquisitionMode is DataDependent|DataIndependent, all of the product ions in consideration for measurement.  Null if BlankFragment is False.",
				ResolutionDescription -> "When BlankFragment is False, set to Null. Otherwise, 20 Gram/Mole to the maximum BlankMassDetection.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Alternatives[
						"PrecursorIonScan" -> Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 16000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"ProductIonScan" -> Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 16000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[100 Gram / Mole, 16000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"DataDependent or DataIndependent" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[All]
						],
						"Null" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						],
						"MultipleReactionMonitoring" -> Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 2000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						]
					],
					Adder[Alternatives[
						"PrecursorIonScan" -> Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 16000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"ProductIonScan" -> Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 16000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 16000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						],
						"DataDependent or DataIndependent" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[All]
						],
						"Null" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						],
						"MultipleReactionMonitoring" -> Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Gram / Mole, 2000 Gram / Mole],
								Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
							]
						]
					]]
				]
			},
			{
				OptionName -> BlankCollisionEnergy,
				Default -> Automatic,
				Description -> "The voltage by which intact ions are accelerated through inert gas in order to dissociate them into measurable fragment ion species when BlankFragment is True. BlankCollisionEnergy cannot be defined simultaneously with BlankCollisionEnergyMassProfile.",
				ResolutionDescription -> "Is automatically set to 40 Volt when BlankFragment is True, otherwise is set to Null.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.1 Volt, 255 Volt]| RangeP[-180 Volt, 5 Volt],
						Units -> {Volt, {Millivolt, Volt, Kilovolt}}
					],
					Adder[Alternatives[
						"Single Values"->Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt]| RangeP[-180 Volt, 5 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						],
						"A list of Single Values"->Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Volt, 180 Volt] | RangeP[-180 Volt, 5 Volt],
								Units -> Volt
							],
							Orientation->Vertical
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> BlankCollisionEnergyMassProfile,
				Default -> Automatic,
				Description -> "The relationship of collision energy with the BlankMassDetection.",
				ResolutionDescription -> "Set to BlankCollisionEnergyMassScan if defined; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						]
					],
					Adder[Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.1 Volt, 255 Volt],
								Units -> {Volt, {Millivolt, Volt, Kilovolt}}
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.1 Volt, 255 Volt],
								Units -> {Volt, {Millivolt, Volt, Kilovolt}}
							]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> BlankCollisionEnergyMassScan,
				Default -> Automatic,
				Description -> "The collision energy profile at the end of the scan from BlankCollisionEnergy or BlankCollisionEnergyScanProfile, as related to analyte mass.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget->Alternatives[
					Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						]
					],
					Adder[Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.1 Volt, 255 Volt],
								Units -> {Volt, {Millivolt, Volt, Kilovolt}}
							],
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.1 Volt, 255 Volt],
								Units -> {Volt, {Millivolt, Volt, Kilovolt}}
							]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> BlankFragmentScanTime,
				Default -> Automatic,
				Description -> "The duration of the spectral scanning for each fragmentation of an intact ion when BlankAcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Automatically set to the same value as ScanTime if BlankAcquisitionMode is DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 10 Second],
						Units -> Second
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.015 Second, 10 Second],
							Units -> Second
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> BlankAcquisitionSurvey,
				Default -> Automatic,
				Description -> "The number of intact ions to consider for fragmentation and product ion measurement in every measurement cycle when BlankAcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Automatically set to 10 if BlankAcquisitionMode is set to DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[1, 30, 1]
					],
					Adder[Alternatives[
						Widget[
							Type -> Number,
							Pattern :> RangeP[1, 30, 1]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> BlankMinimumThreshold,
				Default -> Automatic,
				Description -> "The minimum number of total ions detected within ScanTime durations needed to trigger the start of data dependent acquisition when BlankAcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Automatically set to (100000/Second)*ScanTime if BlankAcquisitionMode is DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 ArbitraryUnit, 8000000 ArbitraryUnit],
						Units -> ArbitraryUnit
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 ArbitraryUnit, 8000000 ArbitraryUnit],
							Units -> ArbitraryUnit
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> BlankAcquisitionLimit,
				Default -> Automatic,
				Description -> "The maximum number of total ions for a specific intact ion when BlankAcquisitionMode is set to DataDependent. When this value is exceeded, acquisition will switch to fragmentation of the next candidate ion.",
				ResolutionDescription -> "Automatically inherited from supplied method if BlankAcquisitionMode is set to DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 ArbitraryUnit, 8000000 ArbitraryUnit],
						Units -> ArbitraryUnit
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 ArbitraryUnit, 8000000 ArbitraryUnit],
							Units -> ArbitraryUnit
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> BlankCycleTimeLimit,
				Default -> Automatic,
				Description -> "The maximum possible computed duration of all of the scans for the intact and fragmentation measurements when BlankAcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Calculated from the BlankAcquisitionSurvey, BlankScanTime, and BlankFragmentScanTime.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 20000 Second],
						Units -> Second
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.015 Second, 20000 Second],
							Units -> Second
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			(*IndexMatching[
					IndexMatchingParent -> ExclusionDomain,*)
			{
				OptionName -> BlankExclusionDomain,
				Default -> Automatic,
				Description -> "The time range when the BlankExclusionMasses are omitted in the chromatogram. Full indicates for the entire period.",
				ResolutionDescription -> "Set to the entire BlankAcquisitionWindow.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						]
					],
					Adder[Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]],
					Adder[Adder[Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						]
					]]]
				]
			},
			{
				OptionName -> BlankExclusionMass, (*Index matched to the exclusion domain*)
				Default -> Automatic,
				Description -> "The intact ions (Target Mass) to omit. When the Mode is set to All, the mass is excluded for the entire ExclusionDomain. When the Mode is set to Once, the Mass is excluded in the first survey appearance, but considered for consequent ones.",
				ResolutionDescription -> "If any BlankExclusionMode-related options are set (e.g. BlankExclusionMassTolerance), a target mass of the first Analyte (if not in BlankInclusionMasses) is chosen and retention time is set to 0*Minute.",
				Category -> "Blanks",
				AllowNull -> True,
				Widget -> Alternatives[
					{
						"Mode" -> Widget[
							Type-> Enumeration,
							Pattern:>All|Once
						],
						"Target Mass" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[2 Gram/Mole, 100000 Gram/Mole],
							Units -> Gram/Mole
						]
					},
					Adder[Alternatives[
						{
							"Mode" -> Widget[
								Type-> Enumeration,
								Pattern:>All|Once
							],
							"Target Mass" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram/Mole, 100000 Gram/Mole],
								Units -> Gram/Mole
							]
						},
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]],
					Adder[Adder[
						{
							"Mode" -> Widget[
								Type-> Enumeration,
								Pattern:>All|Once
							],
							"Target Mass" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram/Mole, 100000 Gram/Mole],
								Units -> Gram/Mole
							]
						}
					]]
				]
			},
			(*	], *)
			{
				OptionName -> BlankExclusionMassTolerance,
				Default -> Automatic,
				Description -> "The range above and below each ion in BlankExclusionMasses to consider for omission when BlankExclusionMass is All or Once.",
				ResolutionDescription -> "If BlankExclusionMass -> All or Once, set to 0.5 Gram/Mole; otherwise, Null.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
						Units -> Gram/Mole
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> BlankExclusionRetentionTimeTolerance,
				Default -> Automatic,
				Description -> "The range of time above and below the BlankExclusionDomain to consider for exclusion.",
				ResolutionDescription -> "If BlankExclusionMass and BlankExclusionDomain options are set, this is set to 10 seconds; otherwise, Null.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Second, 3600 Second],
						Units -> Second
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Second, 3600 Second],
							Units -> Second
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			(*IndexMatching[
					IndexMatchingParent -> InclusionDomain, *)
			{
				OptionName -> BlankInclusionDomain,
				Default -> Automatic,
				Description -> "The time range when BlankInclusionMass applies with respect to the chromatogram. Full indicates for the entire period.",
				ResolutionDescription -> "Set to the entire BlankAcquisitionWindow.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						]
					],
					Adder[Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]],
					Adder[Adder[Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						]
					]]]
				]
			},
			{
				OptionName -> BlankInclusionMass, (*Index matched to InclusionDomain*)
				Default -> Automatic,
				Description -> "The ions (Target Mass) to prioritize during the survey scan for further fragmentation when BlankAcquisitionMode is DataDependent. BlankInclusionMass set to Only will solely be considered for surveys.  When Mode is Preferential, the InclusionMass will be prioritized for survey.",
				ResolutionDescription -> "When BlankInclusionMode  Only or Preferential, an entry mass is added based on the mass of the most salient analyte of the sample.",
				Category -> "Blanks",
				AllowNull -> True,
				Widget -> Alternatives[
					{
						"Mode" -> Widget[ (*InclusionMassMode*)
							Type-> Enumeration,
							Pattern:>Only|Preferential
						],
						"Target Mass" -> Widget[ (*InclusionMass*)
							Type -> Quantity,
							Pattern :> RangeP[2 Gram/Mole, 4000 Gram/Mole],
							Units -> Gram/Mole
						]
					},
					Adder[Alternatives[
						{
							"Mode" -> Widget[ (*InclusionMassMode*)
								Type-> Enumeration,
								Pattern:>Only|Preferential
							],
							"Target Mass" -> Widget[ (*InclusionMass*)
								Type -> Quantity,
								Pattern :> RangeP[2 Gram/Mole, 4000 Gram/Mole],
								Units -> Gram/Mole
							]
						},
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]],
					Adder[Adder[
						{
							"Mode" -> Widget[ (*InclusionMassMode*)
								Type-> Enumeration,
								Pattern:>Only|Preferential
							],
							"Target Mass" -> Widget[ (*InclusionMass*)
								Type -> Quantity,
								Pattern :> RangeP[2 Gram/Mole, 4000 Gram/Mole],
								Units -> Gram/Mole
							]
						}
					]]
				]
			},
			{
				OptionName -> BlankInclusionCollisionEnergy, (*Index matched to BlankInclusionDomain*)
				Default -> Automatic,
				Description -> "The overriding collision energy value that can be applied to the BlankInclusionMass. Null will default to the BlankCollisionEnergy option and related.",
				ResolutionDescription -> "Inherited from any supplied method.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Volt, 255 Volt],
						Units -> Volt
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Volt, 255 Volt],
							Units -> Volt
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]],
					Adder[Adder[Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Volt, 255 Volt],
						Units -> Volt
					]]]
				]
			},
			{
				OptionName -> BlankInclusionDeclusteringVoltage,
				Default -> Automatic,
				Description -> "The overriding source voltage value that can be applied to the BlankInclusionMass. Null will default to the BlankDeclusteringVoltage option.",
				ResolutionDescription -> "Inherited from any supplied method.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[ (*InclusionDeclusteringVoltage*)
						Type -> Quantity,
						Pattern :> RangeP[0.1 Volt, 150 Volt],
						Units -> Volt
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 150 Volt],
							Units -> Volt
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]],
					Adder[Adder[Widget[ (*InclusionDeclusteringVoltage*)
						Type -> Quantity,
						Pattern :> RangeP[0.1 Volt, 150 Volt],
						Units -> Volt
					]]]
				]
			},
			{
				OptionName -> BlankInclusionChargeState,
				Default -> Automatic,
				Description -> "The maximum charge state of the BlankInclusionMass to also consider for inclusion. For example, if this is set to 3 and the polarity is Positive, then +1,+2,+3 charge states will be considered as well.",
				ResolutionDescription -> "Inherited from any supplied method.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[0, 6, 1]
					],
					Adder[Alternatives[
						Widget[
							Type -> Number,
							Pattern :> RangeP[0, 6, 1]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]],
					Adder[Adder[Widget[
						Type -> Number,
						Pattern :> RangeP[0, 6, 1]
					]]]
				]
			},
			{
				OptionName -> BlankInclusionScanTime,
				Default -> Automatic,
				Description -> "The overriding scan time duration that can be applied to the BlankInclusionMass for the consequent fragmentation. Null will default to the BlankFragmentScanTime option.",
				ResolutionDescription -> "Inherited from any supplied method.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 10 Second],
						Units -> Second
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.015 Second, 10 Second],
							Units -> Second
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]],
					Adder[Adder[Widget[ (*InclusionScanTime*)
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 10 Second],
						Units -> Second
					]]]
				]
			},
			(*)]*)
			{
				OptionName -> BlankInclusionMassTolerance,
				Default -> Automatic,
				Description -> "The range above and below each ion in BlankInclusionMass to consider for prioritization. For example, if set to 0.5 Gram/Mole, the total range is 1 Gram/Mole.",
				ResolutionDescription -> "Set to 0.5 Gram/Mole if BlankInclusionMass is given; otherwise, Null.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
						Units -> Gram/Mole
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> BlankSurveyChargeStateExclusion,
				Default -> Automatic,
				Description -> "Indicates if redundant ions that differ by ionic charge (+1/-1, +2/-2, etc.) should be left out and if BlankChargeState exclusion-related options should be automatically filled in.",
				ResolutionDescription -> "Set to True, if any of the BlankChargeState options are set; otherwise, False.",
				Category -> "Blanks",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					],
					Adder[Alternatives[
						Widget[
							Type -> Enumeration,
							Pattern :> BooleanP
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> BlankSurveyIsotopeExclusion,
				Default -> Automatic,
				Description -> "Indicates if redundant ions that differ by isotopic mass (e.g. 1, 2 Gram/Mole) should be excluded and if BlankMassIsotope exclusion-related options should be automatically filled in.",
				ResolutionDescription -> "Set to True, if any of the BlankIsotopeExclusion options are set; otherwise, False.",
				Category -> "Blanks",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					],
					Adder[Alternatives[
						Widget[
							Type -> Enumeration,
							Pattern :> BooleanP
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> BlankChargeStateExclusionLimit,
				Default -> Automatic,
				Description -> "The number of ions to survey first with exclusion by ionic state. For example, if BlankAcquisitionSurvey is 10 and this option is 5, then 5 ions will be surveyed with charge-state exclusion. For candidate ions of rank 6 to 10, no exclusion will be performed.",
				ResolutionDescription -> "Inherited from any supplied method; otherwise, set the same to BlankAcquisitionSurvey, if any ChargeState option is set.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[0, 30, 1]
					],
					Adder[Alternatives[
						Widget[
							Type -> Number,
							Pattern :> RangeP[0, 30, 1]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				],
				Category -> "Blanks"
			},
			{
				OptionName -> BlankChargeStateExclusion,
				Default -> Automatic,
				Description -> "The specific ionic states of intact ions to redundantly exclude from the survey for further fragmentation/acquisition. 1 refers to +1/-1, 2 refers to +2/-2, etc.",
				ResolutionDescription -> "When BlankSurveyChargeStateExclusion is True, set to {1,2}; otherwise, Null.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[1, 6, 1]
					],
					Adder[Alternatives[
						Widget[
							Type -> Number,
							Pattern :> RangeP[1, 6, 1]
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						],
						Adder[
							Widget[
								Type -> Number,
								Pattern :> RangeP[1, 6, 1]
							]
						]
					]]
				],
				Category -> "Blanks"
			},
			{
				OptionName -> BlankChargeStateMassTolerance,
				Default -> Automatic,
				Description -> "The range of m/z to consider for exclusion by ionic state property when BlankSurveyChargeStateExclusion is True.",
				ResolutionDescription -> "When BlankSurveyChargeStateExclusion is True, set to 0.5 Gram/Mole; otherwise, Null.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
						Units -> Gram/Mole
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			(*	IndexMatching[
					IndexMatchingParent -> IsotopicExclusion,*)
			{
				OptionName -> BlankIsotopicExclusion,
				Default -> Automatic,
				Description -> "The m/z difference between monoisotopic ions as a criterion for survey exclusion.",
				ResolutionDescription -> "When BlankSurveyIsotopeExclusion is True, set to 1 Gram/Mole; otherwise, Null.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						]
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						],
						Adder[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
								Units -> Gram/Mole
							]
						]
					]]
				]
			},
			{
				OptionName -> BlankIsotopeRatioThreshold, (*index matching IsotopicExclusion*)
				Default -> Automatic, (*TODO: Figure *)
				Description -> "The minimum relative magnitude between monoisotopic ions in order to be considered an isotope for exclusion.",
				ResolutionDescription -> "When BlankSurveyIsotopeExclusion is True, set to 0.1; otherwise, Null.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[0, 1]
					],
					Adder[
						Alternatives[
							Widget[
								Type -> Number,
								Pattern :> RangeP[0, 1]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							],
							Adder[
								Widget[
									Type -> Number,
									Pattern :> RangeP[0, 1]
								]
							]
						]
					]
				],
				Category -> "Blanks"
			}
			(*]*),
			{ (*index matching to above*)
				OptionName -> BlankIsotopeDetectionMinimum,
				Default -> Automatic,
				Description -> "The acquisition rate of a given intact mass to consider for isotope exclusion in the survey.",
				ResolutionDescription -> "When BlankSurveyIsotopeExclusion is True, set to 10 1/Second; otherwise, Null.",
				Category -> "Blanks",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 * 1 / Second],
						Units -> {-1, {Minute, {Minute, Second}}}
					],
					Adder[
						Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 * 1 / Second],
								Units -> {-1, {Minute, {Minute, Second}}}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							],
							Adder[
								Widget[
									Type -> Quantity,
									Pattern :> GreaterEqualP[0 * 1 / Second],
									Units -> {-1, {Minute, {Minute, Second}}}
								]
							]
						]
					]
				]
			},
			{
				OptionName -> BlankIsotopeMassTolerance,
				Default -> Automatic,
				Description -> "The range of m/z around a mass to consider for exclusion. This applies for both ChargeState and mass shifted Isotope. If set to 0.5 Gram/Mole, then the total range should be 1 Gram/Mole.",
				ResolutionDescription -> "When BlankSurveyIsotopeExclusion or BlankSurveyChargeStateExclusion is True, set to 0.5 Gram/Mole; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
						Units -> Gram/Mole
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> BlankIsotopeRatioTolerance,
				Default -> Automatic,
				Description -> "The range of relative magnitude around BlankIsotopeRatio to consider for isotope exclusion.",
				ResolutionDescription -> "If BlankSurveyIsotopeExclusion is True, set to 30*Percent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent,100Percent],
						Units -> Percent
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent,100Percent],
							Units -> Percent
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Null]
						]
					]]
				]
			},
			{
				OptionName -> BlankNeutralLoss,
				Default -> Automatic,
				Description ->"A neutral loss scan is performed on ESI-QQQ mass spectrometry by scanning the sample through the first quadrupole (Q1). The ions are then fragmented in the collision cell. The second mass analyzer is then scanned with a fixed offset to MS1. This option represents the value of this offset.",
				ResolutionDescription ->"Is set to 500 g/mol if using NeutralIonLoss as the BlankAcquisitionMode, and is Null in other modes.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> GreaterP[0 Gram/Mole],
						Units -> CompoundUnit[
							{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
							{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
						]
					],
					Adder[
						Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Gram/Mole],
								Units -> CompoundUnit[
									{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
									{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
								]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]
					]
				]
			},
			{
				OptionName -> BlankDwellTime,
				Default -> Automatic,
				Description -> "The duration of time for which spectra are acquired at the specific mass detection value for SelectedIonMonitoring and MultipleReactionMonitoring mode in ESI-QQQ.",
				ResolutionDescription -> "Is automatically set to 200 microsecond if BlankAcquisition is in SelectedIonMonitoring or MultipleReactionMonitoring mode.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget ->Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[5 Millisecond,  2000 Millisecond],
						Units -> {Millisecond, {Millisecond,Second,Minute}}
					],
					Adder[
						Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Millisecond,  2000 Millisecond],
								Units -> {Millisecond, {Millisecond,Second,Minute}}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							],
							Adder[
								Widget[
									Type -> Quantity,
									Pattern :> RangeP[5 Millisecond,  2000 Millisecond],
									Units -> {Millisecond, {Millisecond,Second,Minute}}
								]
							]
						],
						Orientation->Vertical
					]
				]
			},
			{
				OptionName -> BlankCollisionCellExitVoltage,
				Default -> Automatic,
				Description ->"Also known as the Collision Cell Exit Potential (CXP). This value focuses and accelerates the ions out of collision cell (Q2) and into 2nd mass analyzer (MS 2). This potential is tuned to ensure successful ion acceleration out of collision cell and into MS2, and can be adjusted to reach the maximal signal intensity. This option is unique to ESI-QQQ for now, and only required when Fragment ->True and/or in ScanMode that achieves tandem mass feature (PrecursorIonScan, NeutralIonLoss,ProductIonScan,MultipleReactionMonitoring). For non-tandem mass ScanMode (FullScan and SelectedIonMonitoring) and other massspectrometer (ESI-QTOF and MALDI-TOF), this option is resolved to Null.",
				ResolutionDescription ->"For TripleQuadrupole as the MassAnalyzer, is set to first CollisionCellExitVoltage, otherwise set to Null.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[-55 Volt, 55 Volt],
						Units -> Volt
					],
					Adder[
						Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[-55 Volt, 55 Volt],
								Units -> Volt
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]
					]
				]
			},
			{
				OptionName -> BlankMassDetectionStepSize,
				Default -> Automatic,
				Description ->"Indicate the step size for mass collection in range when using TripleQuadruploe as the MassAnalyzer.",
				ResolutionDescription ->"This option will be set to Null if using ESI-QTOF. For ESI-QQQ, if both of the mass analyzer are in mass selection mode (SelectedIonMonitoring and MultipleReactionMonitoring mode), this option will be auto resolved to Null. In all other mass scan modes in ESI-QQQ, this option will be automatically resolved to 0.1 g/mol.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.01 Gram/Mole, 1 Gram/Mole],
						Units -> CompoundUnit[
							{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
							{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
						]
					],
					Adder[
						Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.01 Gram/Mole, 1 Gram/Mole],
								Units -> CompoundUnit[
									{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
									{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
								]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null]
							]
						]
					]
				]
			},
			{
				OptionName -> BlankMultipleReactionMonitoringAssays,
				Default -> Automatic,
				Description -> "In ESI-QQQ mass spectrometry analysis, the ion corresponding to the compound of interest is targeted with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and DwellTime (length of time of each scan).",
				ResolutionDescription -> "Is set based on BlankMassDetection, BlankCollisionEnergy, BlankDwellTime and BlankFragmentMassDetection.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Adder[
						Alternatives[
							"Individual Multiple Reaction Monitoring Assay" -> Adder[{
								"Mass Selection Values" -> Widget[
									Type -> Quantity,
									Pattern :> GreaterP[0 Gram / Mole],
									Units -> CompoundUnit[
										{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
										{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
									]
								],
								"CollisionEnergies" -> Alternatives[
									Widget[
										Type -> Quantity,
										Pattern :> RangeP[5 Volt, 180 Volt] | RangeP[-180 Volt, 5 Volt],
										Units -> Volt
									],
									Widget[
										Type -> Enumeration,
										Pattern :> Alternatives[Automatic]
									]
								],
								"Fragment Mass Selection Values" -> Widget[
									Type -> Quantity,
									Pattern :> GreaterP[0 Gram / Mole],
									Units -> CompoundUnit[
										{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
										{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
									]
								],
								"Dwell Times" -> Alternatives[
									Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0 Second],
										Units -> {Millisecond, {Microsecond, Millisecond, Second}}
									],
									Widget[
										Type -> Enumeration,
										Pattern :> Alternatives[Automatic]
									]
								]
							}],
							{
								"Multiple Reaction Monitoring Assays" -> Adder[{
									"Mass Selection Values" -> Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0 Gram / Mole],
										Units -> CompoundUnit[
											{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
											{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
										]
									],
									"CollisionEnergies" -> Alternatives[
										Widget[
											Type -> Quantity,
											Pattern :> RangeP[5 Volt, 180 Volt] | RangeP[-180 Volt, 5 Volt],
											Units -> Volt
										],
										Widget[
											Type -> Enumeration,
											Pattern :> Alternatives[Automatic]
										]
									],
									"Fragment Mass Selection Values" -> Widget[
										Type -> Quantity,
										Pattern :> GreaterP[0 Gram / Mole],
										Units -> CompoundUnit[
											{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
											{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
										]
									],
									"Dwell Times" -> Alternatives[
										Widget[
											Type -> Quantity,
											Pattern :> GreaterP[0 Second],
											Units -> {Millisecond, {Microsecond, Millisecond, Second}}
										],
										Widget[
											Type -> Enumeration,
											Pattern :> Alternatives[Automatic]
										]
									]
								}]
							},
							"None" -> Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Null, {Null}]
							]
						],
						Orientation -> Vertical
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					]
				]
			},
			(* ],*)
			{
				OptionName -> BlankAbsorbanceWavelength,
				Default -> Automatic,
				Description -> "For Blank measurement, the wavelength of light passed through the flow cell for the UVVis Detector. For PhotoDiodeArray Detector, a 3D data is generated from a spectrum of light passing through the flow cell. Absorbance wavelength in that case represents the wavelength at which a 2D data slice is generated from the 3D data.",
				ResolutionDescription -> "Automatically set to the same as the first entry in AbsorbanceWavelength.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Single" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[190 Nanometer, 500 Nanometer, 1 Nanometer],
						Units -> Nanometer
					],
					"All" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					],
					"Range" -> Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[190 Nanometer, 490 Nanometer, 1 Nanometer],
							Units -> Nanometer
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[200 Nanometer, 500 Nanometer, 1 Nanometer],
							Units -> Nanometer
						]
					]
				],
				Category -> "Blanks"
			},
			{
				OptionName -> BlankWavelengthResolution,
				Default -> Automatic,
				Description -> "The increment in wavelength for the range of wavelength of light passed through the flow for absorbance measurement for the instruments with PhotoDiodeArray Detector for Blank measurement.",
				ResolutionDescription -> "Automatically set to the same as the first entry in WavelengthResolution.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1.2 * Nanometer, 12.0 * Nanometer], (*this can only go to specific values*)
					Units -> Nanometer
				],
				Category -> "Blanks"
			},
			{
				OptionName -> BlankUVFilter,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if UV wavelengths (less than 210 nm) should be blocked from being transmitted through the sample for the PhotoDiodeArray Detector for Blank measurement.",
				ResolutionDescription -> "Automatically set to the same as the first entry in UVFilter.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankAbsorbanceSamplingRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * 1 / Second, 80 * 1 / Second, 1 * 1 / Second], (*can be only specific values*)
					Units -> {-1, {Minute, {Minute, Second}}}
				],
				Description -> "The number of times the absorbance measurement is made per second during Blank measurement. Lower values will be less susceptible to noise but will record less frequently across time.",
				ResolutionDescription -> "Automatically set to the same as the first entry in AbsorbanceSamplingRate.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankStorageCondition,
				Default -> Null,
				Description -> "The non-default conditions under which any blanks used by this experiment should be stored after the protocol is completed. If left unset, Blank samples will be stored according to their Models' DefaultStorageCondition.",
				AllowNull -> True,
				Category -> "Blanks",
				(* Null indicates the storage conditions will be inherited from the model *)
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal]
				]
			}
		],
		{
			OptionName -> ColumnRefreshFrequency,
			Default -> Automatic,
			Description -> "The frequency of column prime inserted into the order of analyte injections at which solvent is flowed to equilibrate the column in order to remove contaminants and reset the gradient to match the starting percentage of the subsequent injection. An initial column prime and final column flush will be performed unless Null or None is specified. For First, it is performed at the beginning. For Last, it is performed at the end. For FirstAndLast, it is performed both at the beginning and end. For GradientChange, it is performed every time a change in the gradient is encountered for the injections. A Number indicates the number of injections after which it is performed and also in the beginning (eg: for 2, it is performed at the start and after 2nd, 4th, 6th and so on injections).",
			ResolutionDescription -> "Automatically set to Null when InjectionTable option is specified (meaning that this option is inconsequential) or no column is used in the experiment; otherwise, set to GradientChange.",
			AllowNull -> True,
			Category -> "Column Prime",
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> None | FirstAndLast | First | Last | GradientChange
				],
				Widget[
					Type -> Number,
					Pattern :> GreaterP[0, 1]
				]
			]
		},
		(* --- Column Prime Gradient Parameters --- *)
		{
			OptionName -> ColumnPrimeTemperature,
			Default -> Automatic,
			Description -> "The column's temperature at which the column prime gradient is run. If ColumnPrimeTemperature is set to Ambient, column oven temperature control is not used. Otherwise, ColumnPrimeTemperature is maintained by temperature control of the column oven.",
			ResolutionDescription -> "Automatically set to the corresponding gradient temperature specified in the ColumnPrimeGradient option or the column temperature for the column prime in the InjectionTable option; otherwise, set as the first value of the ColumnTemperature option.",
			AllowNull -> True,
			Category -> "Column Prime",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[30 Celsius, 90 Celsius],
					Units -> Celsius
				],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ambient]
				]
			]
		},
		{
			OptionName -> ColumnPrimeGradientA,
			Default -> Automatic,
			Description -> "The composition of BufferA within the flow, defined for specific time points for column prime. The composition is linearly interpolated for the intervening periods between the defined time points. For example for ColumnPrimeGradientA->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferA in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
			ResolutionDescription -> "If ColumnPrimeGradient option is specified, set from it or implicitly determined from the ColumnPrimeGradientB, ColumnPrimeGradientC, and ColumnPrimeGradientD options such that the total amounts to 100%.",
			AllowNull -> True,
			Category -> "Column Prime",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Minute, $MaxExperimentTime],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer A Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> ColumnPrimeGradientB,
			Default -> Automatic,
			Description -> "The composition of BufferB within the flow, defined for specific time points for column prime. The composition is linearly interpolated for the intervening periods between the defined time points. For example for ColumnPrimeGradientB->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferB in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
			ResolutionDescription -> "If ColumnPrimeGradient option is specified, set from it or implicitly determined from the ColumnPrimeGradientA, ColumnPrimeGradientC, and ColumnPrimeGradientD options such that the total amounts to 100%.",
			AllowNull -> True,
			Category -> "Column Prime",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Minute, $MaxExperimentTime],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer B Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> ColumnPrimeGradientC,
			Default -> Automatic,
			Description -> "The composition of BufferC within the flow, defined for specific time points for column prime. The composition is linearly interpolated for the intervening periods between the defined time points. For example for ColumnPrimeGradientC->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferC in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
			ResolutionDescription -> "If ColumnPrimeGradient option is specified, set from it or implicitly determined from the ColumnPrimeGradientA, ColumnPrimeGradientB, and ColumnPrimeGradientD options such that the total amounts to 100%.",
			AllowNull -> True,
			Category -> "Column Prime",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Minute, $MaxExperimentTime],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer C Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> ColumnPrimeGradientD,
			Default -> Automatic,
			Description -> "The composition of BufferD within the flow, defined for specific time points for column prime. The composition is linearly interpolated for the intervening periods between the defined time points. For example for ColumnPrimeGradientD->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferD in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
			ResolutionDescription -> "If ColumnPrimeGradient option is specified, set from it or implicitly determined from the ColumnPrimeGradientA, ColumnPrimeGradientB, and ColumnPrimeGradientC options such that the total amounts to 100%.",
			AllowNull -> True,
			Category -> "Column Prime",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Minute, $MaxExperimentTime],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer D Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> ColumnPrimeFlowRate,
			Default -> Automatic,
			Description -> "The net speed of the fluid flowing through the pump inclusive of the composition of BufferA, BufferB, BufferC, and BufferD specified in the ColumnPrimeGradient options during column prime. This speed is linearly interpolated such that consecutive entries of {Time, Flow Rate} will define the intervening fluid speed. For example, {{0 Minute, 0.3 Milliliter/Minute},{30 Minute, 0.5 Milliliter/Minute}} means flow rate of 0.4 Milliliter/Minute at 15 minutes into the run.",
			ResolutionDescription -> "If ColumnPrimeGradient option is specified, automatically set from the method given in the ColumnPrimeGradient option. If NominalFlowRate of the column model is specified, set to lesser of the NominalFlowRate for each of the columns, guard columns or the instrument's MaxFlowRate. Otherwise set to 1 Milliliter / Minute.",
			AllowNull -> True,
			Category -> "Column Prime",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Milliliter / Minute, 2 Milliliter / Minute],
					Units -> CompoundUnit[
						{1, {Milliliter, {Milliliter, Liter}}},
						{-1, {Minute, {Minute, Second}}}
					]
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Minute, $MaxExperimentTime],
							Units -> {Minute, {Second, Minute}}
						],
						"Flow Rate" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Milliliter / Minute, 2 Milliliter / Minute],
							Units -> CompoundUnit[
								{1, {Milliliter, {Milliliter, Liter}}},
								{-1, {Minute, {Minute, Second}}}
							]
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> ColumnPrimeGradient,
			Default -> Automatic,
			Description -> "The composition of different specified buffers in BufferA, BufferB, BufferC and BufferD over time in the fluid flow for column prime. Specific parameters of a gradient object can be overridden by specific options.",
			ResolutionDescription -> "Automatically set to best meet all the ColumnPrimeGradient options (e.g. ColumnPrimeGradientA, ColumnPrimeGradientB, ColumnPrimeGradientC, ColumnPrimeGradientD, ColumnPrimeFlowRate).",
			AllowNull -> True,
			Category -> "Column Prime",
			Widget -> Alternatives[
				Widget[Type -> Object, Pattern :> ObjectP[Object[Method, Gradient]]],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Minute, $MaxExperimentTime],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer A Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer B Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer C Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer D Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Flow Rate" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Milliliter / Minute, 2 Milliliter / Minute],
							Units -> CompoundUnit[
								{1, {Milliliter, {Milliliter, Liter}}},
								{-1, {Minute, {Minute, Second}}}
							]
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> ColumnPrimeIonMode,
			Default -> Automatic,
			Description -> "Indicates if positively or negatively charged ions are analyzed.",
			ResolutionDescription -> "Set to the first IonMode for an analyte input sample.",
			Category -> "Column Prime",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> IonModeP
			]
		},
		{
			OptionName -> ColumnPrimeMassSpectrometryMethod,
			Default -> Automatic,
			Description -> "The previously specified instruction(s) for the analyte ionization, selection, fragmentation, and detection.",
			ResolutionDescription -> "If ColumnPrime samples exist and MassSpectrometryMethod is specified, then set to the first available ColumnPrimeMassSpectrometryMethod.",
			AllowNull -> True,
			Category -> "Column Prime",
			Widget -> Alternatives[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Method, MassAcquisition]]
				],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[New]
				]
			]
		},
		{
			OptionName -> ColumnPrimeESICapillaryVoltage,
			Default -> Automatic,
			Description -> "The absolute voltage applied to the tip of the stainless steel capillary tubing in order to produce charged droplets. Adjust this voltage to maximize sensitivity. Most compounds are optimized between 0.5 and 3.2 kV in ESI positive ion mode and 0.5 and 2.6 in ESI negative ion mode, but can be altered according to sample type. For low flow applications, best sensitivity will be achieved with a relatively high value in ESI positive (e.g. 3.0 kV), for columnPrime flow UPLC a value of 0.5 kV is typically best for maximum sensitivity.",
			ResolutionDescription -> "Is automatically set to the first ESICapillaryVoltage.",
			AllowNull -> True,
			Category -> "Column Prime",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[-4 Kilovolt, 5 Kilovolt],
				Units -> {Kilovolt, {Millivolt, Volt, Kilovolt}}
			]
		},
		{
			OptionName -> ColumnPrimeDeclusteringVoltage,
			Default -> Automatic,
			Description -> "The voltage offset between the ion block (the reduced pressure chamber of the source block) and the stepwave ion guide (the optics before the quadrupole mass analyzer). This voltage attracts charged ions in the spray being produced from the capillary tip into the ion block leading into the mass spectrometer. This voltage is typically set to 25-100 V and its tuning has little effect on sensitivity compared to other options (e.g. ColumnPrimeStepwaveVoltage).",
			ResolutionDescription -> "Is automatically set to any specified MassAcquisition method; otherwise, set to 40 Volt.",
			AllowNull -> True,
			Category -> "Column Prime",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.1 Volt, 150 Volt],
				Units -> {Volt, {Millivolt, Volt, Kilovolt}}
			]
		},
		{
			OptionName -> ColumnPrimeStepwaveVoltage,
			Default -> Automatic,
			Description -> "The voltage offset between the 1st and 2nd stage of the stepwave ion guide which leads ions coming from the sample cone towards the quadrupole mass analyzer. This voltage normally optimizes between 25 and 150 V and should be adjusted for sensitivity depending on compound and charge state. For multiply charged species it is typically set to to 40-50 V, and higher for singly charged species. In general higher cone voltages (120-150 V) are needed for larger mass ions such as intact proteins and monoclonal antibodies. It also has greatest effect on in-source fragmentation and should be decreased if in-source fragmentation is observed but not desired.",
			ResolutionDescription -> "Is automatically set to the first StepwaveVoltage.",
			AllowNull -> True,
			Category -> "Column Prime",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.1 Volt, 200 Volt],
				Units -> {Volt, {Millivolt, Volt, Kilovolt}}
			]
		},
		{
			OptionName -> ColumnPrimeIonGuideVoltage,
			Default -> Automatic,
			Description -> "This option (also known as Entrance Potential (EP)) is a unique option of ESI-QQQ. This parameter indicates electric potential applied to the Ion Guide in ESI-QQQ, which guides and focuses the ions through the high-pressure ion guide region.",
			ResolutionDescription -> "Is automatically set to first IonGuideVoltage.",
			AllowNull -> True,
			Category -> "Ionization",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[-15 Volt, -2 Volt] | RangeP[2 Volt, 15 Volt],
				Units -> Volt
			]
		},
		{
			OptionName -> ColumnPrimeSourceTemperature,
			Default -> Automatic,
			Description -> "The temperature setting of the source block. Heating the source block discourages condensation and decreases solvent clustering in the reduced vacuum region of the source. This temperature setting is flow rate and sample dependent. Typical values are between 60 to 120 Celsius. For thermally labile analytes, a lower temperature setting is recommended.",
			ResolutionDescription -> "Is automatically set to the first SourceTemperature.",
			AllowNull -> True,
			Category -> "Column Prime",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[25 Celsius, 150 Celsius],
				Units -> Celsius
			]
		},
		{
			OptionName -> ColumnPrimeDesolvationTemperature,
			Default -> Automatic,
			Description -> "The temperature setting for the ESI desolvation heater that controls the nitrogen gas temperature used for solvent evaporation to produce single gas phase ions from the ion spray. Similar to ColumnPrimeDesolvationGasFlow, this setting is dependent on solvent flow rate and composition. A typical range is from 150 to 650 Celsius.",
			ResolutionDescription -> "Is automatically set to the first DesolvationTemperature.",
			AllowNull -> True,
			Category -> "Column Prime",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[20 Celsius, 650 Celsius],
				Units -> Celsius
			]
		},
		{
			OptionName -> ColumnPrimeDesolvationGasFlow,
			Default -> Automatic,
			Description -> "The rate at which nitrogen gas is flowed around the ESI capillary. It is used for solvent evaporation to produce single gas phase ions from the ion spray. Similar to ColumnPrimeDesolvationTemperature, this setting is dependent on solvent flow rate and composition. Higher desolvation temperatures usually result in increased sensitivity, but too high values can cause spray instability. Typical values are between 300 to 1200 L/h.",
			ResolutionDescription -> "Is automatically set to the first DesolvationGasFlow.",
			AllowNull -> True,
			Category -> "Column Prime",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :>RangeP[55 Liter/Hour, 1200 Liter/Hour] | RangeP[0 PSI, 85 PSI],
				Units -> Alternatives[
					CompoundUnit[
						{1, {Liter, {Liter, Milliliter}}},
						{-1, {Hour, {Hour, Minute}}}
					],
					PSI
				]
			]
		},
		{
			OptionName -> ColumnPrimeConeGasFlow,
			Default -> Automatic,
			Description -> "The rate at which nitrogen gas flow is flowed around the sample inlet cone (the spherical metal plate acting as a first gate between the sprayer and the reduced pressure chamber, the ion block). This gas flow is used to minimize the formation of solvent ion clusters. It also helps reduce adduct ions and directing the spray into the ion block while keeping the sample cone clean. Typical values are between 0 and 150 L/h.",
			ResolutionDescription -> "Is automatically set to the first ConeGasFlow.",
			AllowNull -> True,
			Category -> "Column Prime",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :>RangeP[0 Liter/Hour, 300 Liter/Hour] | RangeP[30 PSI, 55 PSI],
				Units -> Alternatives[
					CompoundUnit[
						{1, {Liter, {Liter, Milliliter}}},
						{-1, {Hour, {Hour, Minute}}}
					],
					PSI
				]
			]
		},
		IndexMatching[
			IndexMatchingParent -> ColumnPrimeAcquisitionWindow,
			{
				OptionName -> ColumnPrimeAcquisitionWindow,
				Default -> Automatic,
				Description -> "The time range with respect to the chromatographic separation to conduct analyte ionization, selection/survey, optional fragmentation, and detection.",
				ResolutionDescription -> "Set to the entire gradient window 0 Minute to the last time point in ColumnPrimeGradient.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Span[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Minute,8 Hour],
						Units -> Minute
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Minute,8 Hour],
						Units -> Minute
					]
				]
			},
			{
				OptionName -> ColumnPrimeAcquisitionMode,
				Default -> Automatic,
				Description -> "The method by which spectra are collected. DataDependent will depend on the properties of the measured mass spectrum of the intact ions. DataIndependent will systemically scan through all of the intact ions. MS1FullScan will focus on defined intact masses. MS1MS2 will focus on fragmented masses.",
				ResolutionDescription -> "Set to MS1FullScan unless DataDependent related options are set, then set to DataDependent.",
				Category -> "Column Prime",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> MSAcquisitionModeP (*DataIndependent|DataDependent|MS1FullScan|MS1MS2ProductIonScan|SelectedIonMonitoring|NeutralIonLoss|ProductIonScan|MultipleReactionMonitoring*)
				]
			},
			{
				OptionName -> ColumnPrimeFragment,
				Default -> Automatic,
				Description -> "Indicates if ions should be collided with neutral gas in order to measure the resulting product ions. Also known as tandem mass spectrometry or MS/MS (as opposed to MS).",
				ResolutionDescription -> "Set to True if ColumnPrimeAcquisitionMode is MS1MS2ProductIonScan, DataDependent, or DataIndependent. Set True if any of the Fragmentation related options are set (e.g. ColumnPrimeFragmentMassDetection).",
				Category -> "Column Prime",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> ColumnPrimeMassDetection,
				Default -> Automatic,
				Description -> "The lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for intact masses. When ColumnPrimeFragment is True, the intact ions will be selected for fragmentation.",
				ResolutionDescription -> "For ColumnPrimeFragment -> False, automatically set to one of three default mass ranges according to the molecular weight of the ColumnPrimeAnalytes to encompass them.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Alternatives[
					"Single" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
						Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
					],
					"Specific List" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						]
					],
					"Range" -> Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						]
					],
					"All" -> Widget[
						Type -> Enumeration,
						Pattern :> MSAnalyteGroupP
					]
				]
			},
			{
				OptionName -> ColumnPrimeScanTime,
				Default -> Automatic,
				Description -> "The duration of time allowed to pass between each spectral acquisition. When ColumnPrimeAcquisitionMode is DataDependent, this value refers to the duration for measuring spectra from the intact ions. Increasing this value improves sensitivity whereas decreasing this value allows for more data points and spectra to be acquired.",
				ResolutionDescription -> "Set to 0.2 seconds unless a method is given.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.015 Second, 10 Second],
					Units -> Second
				]
			},
			{
				OptionName -> ColumnPrimeFragmentMassDetection,
				Default -> Automatic,
				Description -> "The lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for product ions. When ColumnPrimeAcquisitionMode is DataDependent|DataIndependent, all of the product ions in consideration for measurement.  Null if ColumnPrimeFragment is False.",
				ResolutionDescription -> "When ColumnPrimeFragment is False, set to Null. Otherwise, 20 Gram/Mole to the maximum ColumnPrimeMassDetection.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Alternatives[
					"PrecursorIonScan" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[5 Gram / Mole, 16000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						]
					],
					"ProductIonScan" -> Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[5 Gram / Mole, 16000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[100 Gram / Mole, 16000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						]
					],
					"DataDependent or DataIndependent" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					],
					"Null" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					],
					"MultipleReactionMonitoring" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[5 Gram / Mole, 2000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						]
					]
				]
			},
			{
				OptionName -> ColumnPrimeCollisionEnergy,
				Default -> Automatic,
				Description -> "The voltage by which intact ions are accelerated through inert gas in order to dissociate them into measurable fragment ion species when ColumnPrimeFragment is True. ColumnPrimeCollisionEnergy cannot be defined simultaneously with ColumnPrimeCollisionEnergyMassProfile.",
				ResolutionDescription -> "Is automatically set to 40 Volt when ColumnPrimeFragment is True, otherwise is set to Null.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[5 Volt, 255 Volt] | RangeP[-180 Volt, 5 Volt],
						Units -> Volt
					],
					Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[5 Volt, 180 Volt] | RangeP[-180 Volt, 5 Volt],
							Units -> Volt
						],
						Orientation->Vertical
					]
				]
			},
			{
				OptionName -> ColumnPrimeCollisionEnergyMassProfile,
				Default -> Automatic,
				Description -> "The relationship of collision energy with the ColumnPrimeMassDetection.",
				ResolutionDescription -> "Set to ColumnPrimeCollisionEnergyMassScan if defined; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Span[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.1 Volt, 255 Volt],
						Units -> {Volt, {Millivolt, Volt, Kilovolt}}
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.1 Volt, 255 Volt],
						Units -> {Volt, {Millivolt, Volt, Kilovolt}}
					]
				]
			},
			{
				OptionName -> ColumnPrimeCollisionEnergyMassScan,
				Default -> Automatic,
				Description -> "The collision energy profile at the end of the scan from ColumnPrimeCollisionEnergy or ColumnPrimeCollisionEnergyScanProfile, as related to analyte mass.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget->Alternatives[
					"Constant"->Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.1 Volt, 255 Volt],
						Units -> {Volt, {Millivolt, Volt, Kilovolt}}
					],
					"Range"->Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						]
					]
				]
			},
			{
				OptionName -> ColumnPrimeFragmentScanTime,
				Default -> Automatic,
				Description -> "The duration of the spectral scanning for each fragmentation of an intact ion when ColumnPrimeAcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Automatically set to the same value as ScanTime if ColumnPrimeAcquisitionMode is DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 10 Second],
						Units -> Second
					]
				]
			},
			{
				OptionName -> ColumnPrimeAcquisitionSurvey,
				Default -> Automatic,
				Description -> "The number of intact ions to consider for fragmentation and product ion measurement in every measurement cycle when ColumnPrimeAcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Automatically set to 10 if ColumnPrimeAcquisitionMode is set to DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 30, 1]
				]
			},
			{
				OptionName -> ColumnPrimeMinimumThreshold,
				Default -> Automatic,
				Description -> "The minimum number of total ions detected within ScanTime durations needed to trigger the start of data dependent acquisition when ColumnPrimeAcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Automatically set to (100000/Second)*ScanTime if ColumnPrimeAcquisitionMode is DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 ArbitraryUnit, 8000000 ArbitraryUnit],
					Units -> ArbitraryUnit
				]
			},
			{
				OptionName -> ColumnPrimeAcquisitionLimit,
				Default -> Automatic,
				Description -> "The maximum number of total ions for a specific intact ion when ColumnPrimeAcquisitionMode is set to DataDependent. When this value is exceeded, acquisition will switch to fragmentation of the next candidate ion.",
				ResolutionDescription -> "Automatically inherited from supplied method if ColumnPrimeAcquisitionMode is set to DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 ArbitraryUnit, 8000000 ArbitraryUnit],
					Units -> ArbitraryUnit
				]
			},
			{
				OptionName -> ColumnPrimeCycleTimeLimit,
				Default -> Automatic,
				Description -> "The maximum possible computed duration of all of the scans for the intact and fragmentation measurements when ColumnPrimeAcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Calculated from the ColumnPrimeAcquisitionSurvey, ColumnPrimeScanTime, and ColumnPrimeFragmentScanTime.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.015 Second, 20000 Second],
					Units -> Second
				]
			},
			(*IndexMatching[
					IndexMatchingParent -> ExclusionDomain,*)
			{
				OptionName -> ColumnPrimeExclusionDomain,
				Default -> Automatic,
				Description -> "THe time range when the ColumnPrimeExclusionMasses are omitted in the chromatogram. Full indicates for the entire period.",
				ResolutionDescription -> "Set to the entire ColumnPrimeAcquisitionWindow.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Alternatives[
					Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						]
					],
					Adder[Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						]
					]]
				]
			},
			{
				OptionName -> ColumnPrimeExclusionMass, (*Index matched to the exclusion domain*)
				Default -> Automatic,
				Description -> "The intact ions (Target Mass) to omit. When the Mode is set to All, the mass is excluded for the entire ExclusionDomain. When set to Once, the mass is excluded in the first survey appearance, but considered for consequent ones.",
				ResolutionDescription -> "If any ColumnPrimeExclusionMode-related options are set (e.g. ColumnPrimeExclusionMassTolerance), a target mass of the first Analyte (if not in ColumnPrimeInclusionMasses) is chosen and retention time is set to 0*Minute.",
				Category -> "Column Prime",
				AllowNull -> True,
				Widget -> Alternatives[
					{
						"Mode" -> Widget[
							Type-> Enumeration,
							Pattern:>All|Once
						],
						"Target Mass" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[2 Gram/Mole, 100000 Gram/Mole],
							Units -> Gram/Mole
						]
					},
					Adder[
						{
							"Mode" -> Widget[
								Type-> Enumeration,
								Pattern:>All|Once
							],
							"Target Mass" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram/Mole, 100000 Gram/Mole],
								Units -> Gram/Mole
							]
						}
					]
				]
			},
			(*	], *)
			{
				OptionName -> ColumnPrimeExclusionMassTolerance,
				Default -> Automatic,
				Description -> "The range above and below each ion in ColumnPrimeExclusionMasses to consider for omission when ColumnPrimeExclusionMass is set to All or Once.",
				ResolutionDescription -> "If ColumnPrimeExclusionMass -> All or Once, set to 0.5 Gram/Mole; otherwise, Null.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
					Units -> Gram/Mole
				]
			},
			{
				OptionName -> ColumnPrimeExclusionRetentionTimeTolerance,
				Default -> Automatic,
				Description -> "The range of time above and below the ColumnPrimeExclusionDomain to consider for exclusion.",
				ResolutionDescription -> "If ColumnPrimeExclusionMass and ColumnPrimeExclusionDomain options are set, this is set to 10 seconds; otherwise, Null.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Second, 3600 Second],
					Units -> Second
				]
			},
			(*IndexMatching[
					IndexMatchingParent -> InclusionDomain, *)
			{
				OptionName -> ColumnPrimeInclusionDomain,
				Default -> Automatic,
				Description -> "The time range when the ColumnPrimeInclusionMass applies with respect to the chromatogram. Full indicates for the entire period.",
				ResolutionDescription -> "Set to the entire ColumnPrimeAcquisitionWindow.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Alternatives[
					Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						]
					],
					Adder[Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						]
					]]
				]
			},
			{
				OptionName -> ColumnPrimeInclusionMass, (*Index matched to InclusionDomain*)
				Default -> Automatic,
				Description -> "The ions (Target Mass) to prioritize during the survey scan for further fragmentation when ColumnPrimeAcquisitionMode is DataDependent. ColumnPrimeInclusionMass set to Only will solely be considered for surveys.  When Mode is Preferential, the InclusionMass will be prioritized for survey.",
				ResolutionDescription -> "When ColumnPrimeInclusionMode  Only or Preferential, an entry mass is added based on the mass of the most salient analyte of the sample.",
				Category -> "Column Prime",
				AllowNull -> True,
				Widget -> Alternatives[
					{
						"Mode" -> Widget[ (*InclusionMassMode*)
							Type-> Enumeration,
							Pattern:>Only|Preferential
						],
						"Target Mass" -> Widget[ (*InclusionMass*)
							Type -> Quantity,
							Pattern :> RangeP[2 Gram/Mole, 4000 Gram/Mole],
							Units -> Gram/Mole
						]
					},
					Adder[
						{
							"Mode" -> Widget[ (*InclusionMassMode*)
								Type-> Enumeration,
								Pattern:>Only|Preferential
							],
							"Target Mass" -> Widget[ (*InclusionMass*)
								Type -> Quantity,
								Pattern :> RangeP[2 Gram/Mole, 4000 Gram/Mole],
								Units -> Gram/Mole
							]
						}
					]
				]
			},
			{
				OptionName -> ColumnPrimeInclusionCollisionEnergy, (*Index matched to ColumnPrimeInclusionDomain*)
				Default -> Automatic,
				Description -> "The overriding collision energy value that can be applied to the ColumnPrimeInclusionMass. Null will default to the ColumnPrimeCollisionEnergy option and related.",
				ResolutionDescription -> "Inherited from any supplied method.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Volt, 255 Volt],
						Units -> Volt
					],
					Adder[Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Volt, 255 Volt],
						Units -> Volt
					]]
				]
			},
			{
				OptionName -> ColumnPrimeInclusionDeclusteringVoltage,
				Default -> Automatic,
				Description -> "The overriding source voltage value that can be applied to the ColumnPrimeInclusionMass. Null will default to the ColumnPrimeDeclusteringVoltage option.",
				ResolutionDescription -> "Inherited from any supplied method.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Alternatives[
					Widget[ (*InclusionDeclusteringVoltage*)
						Type -> Quantity,
						Pattern :> RangeP[0.1 Volt, 150 Volt],
						Units -> Volt
					],
					Adder[Widget[ (*InclusionDeclusteringVoltage*)
						Type -> Quantity,
						Pattern :> RangeP[0.1 Volt, 150 Volt],
						Units -> Volt
					]]
				]
			},
			{
				OptionName -> ColumnPrimeInclusionChargeState,
				Default -> Automatic,
				Description -> "The maximum charge state of the ColumnPrimeInclusionMass to also consider for inclusion. For example, if this is set to 3 and the polarity is Positive, then +1,+2,+3 charge states will be considered as well.",
				ResolutionDescription -> "Inherited from any supplied method.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[0, 6, 1]
					],
					Adder[Widget[
						Type -> Number,
						Pattern :> RangeP[0, 6, 1]
					]]
				]
			},
			{
				OptionName -> ColumnPrimeInclusionScanTime,
				Default -> Automatic,
				Description -> "The overriding scan time duration that can be applied to the ColumnPrimeInclusionMass for the consequent fragmentation. Null will default to the ColumnPrimeFragmentScanTime option.",
				ResolutionDescription -> "Inherited from any supplied method.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 10 Second],
						Units -> Second
					],
					Adder[Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 10 Second],
						Units -> Second
					]]
				]
			},
			(*)]*)
			{
				OptionName -> ColumnPrimeInclusionMassTolerance,
				Default -> Automatic,
				Description -> "The range above and below each ion in ColumnPrimeInclusionMass to consider for prioritization. For example, if set to 0.5 Gram/Mole, the total range is 1 Gram/Mole.",
				ResolutionDescription -> "Set to 0.5 Gram/Mole if ColumnPrimeInclusionMass is given; otherwise, Null.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
						Units -> Gram/Mole
					]
				]
			},
			{
				OptionName -> ColumnPrimeSurveyChargeStateExclusion,
				Default -> Automatic,
				ResolutionDescription -> "Set to True, if any of the ColumnPrimeChargeState options are set; otherwise, False.",
				Description -> "Indicates if redundant ions that differ by ionic charge (+1/-1, +2/-2, etc.) should be excluded and if ColumnPrimeChargeState exclusion-related options should be automatically filled in.",
				Category -> "Column Prime",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				]
			},
			{
				OptionName -> ColumnPrimeSurveyIsotopeExclusion,
				Default -> Automatic,
				Description -> "Indicates if redundant ions that differ by isotopic mass (e.g. 1, 2 Gram/Mole) should be excluded and if ColumnPrimeMassIsotope exclusion-related options should be automatically filled in.",
				ResolutionDescription -> "Set to True, if any of the ColumnPrimeIsotopeExclusion options are set; otherwise, False.",
				Category -> "Column Prime",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> ColumnPrimeChargeStateExclusionLimit,
				Default -> Automatic,
				Description -> "The number of ions to survey first with exclusion by ionic state. For example, if ColumnPrimeAcquisitionSurvey is 10 and this option is 5, then 5 ions will be surveyed with charge-state exclusion. For candidate ions of rank 6 to 10, no exclusion will be performed.",
				ResolutionDescription -> "Inherited from any supplied method; otherwise, set the same to ColumnPrimeAcquisitionSurvey, if any ChargeState option is set.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 30, 1]
				],
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeChargeStateExclusion,
				Default -> Automatic,
				Description -> "The specific ionic states of intact ions to redundantly exclude from the survey for further fragmentation/acquisition. 1 refers to +1/-1, 2 refers to +2/-2, etc.",
				ResolutionDescription -> "When ColumnPrimeSurveyChargeStateExclusion is True, set to {1,2}; otherwise, Null.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[1, 6, 1]
					],
					Adder[
						Widget[
							Type -> Number,
							Pattern :> RangeP[1, 6, 1]
						]
					]
				],
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeChargeStateMassTolerance,
				Default -> Automatic,
				Description -> "The range of m/z to consider for exclusion by ionic state property when ColumnPrimeSurveyChargeStateExclusion is True.",
				ResolutionDescription -> "When ColumnPrimeSurveyChargeStateExclusion is True, set to 0.5 Gram/Mole; otherwise, Null.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
					Units -> Gram/Mole
				]
			},
			(*	IndexMatching[
					IndexMatchingParent -> IsotopicExclusion,*)
			{
				OptionName -> ColumnPrimeIsotopicExclusion,
				Default -> Automatic,
				Description -> "The m/z difference between monoisotopic ions as a criterion for survey exclusion.",
				ResolutionDescription -> "When ColumnPrimeSurveyIsotopeExclusion is True, set to 1 Gram/Mole; otherwise, Null.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Alternatives[
					Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						]
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						]
					]]
				]
			},
			{
				OptionName -> ColumnPrimeIsotopeRatioThreshold, (*index matching IsotopicExclusion*)
				Default -> Automatic, (*TODO: Figure *)
				Description -> "The minimum relative magnitude between monoisotopic ions in order to be considered an isotope for exclusion.",
				ResolutionDescription -> "When ColumnPrimeSurveyIsotopeExclusion is True, set to 0.1; otherwise, Null.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[0, 1]
					],
					Adder[Widget[
						Type -> Number,
						Pattern :> RangeP[0, 1]
					]]
				],
				Category -> "Column Prime"
			}
			(*]*),
			{ (*index matching to above*)
				OptionName -> ColumnPrimeIsotopeDetectionMinimum,
				Default -> Automatic,
				Description -> "The acquisition rate of a given intact mass to consider for isotope exclusion in the survey.",
				ResolutionDescription -> "When ColumnPrimeSurveyIsotopeExclusion is True, set to 10 1/Second; otherwise, Null.",
				Category -> "Column Prime",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 * 1 / Second],
						Units -> {-1, {Minute, {Minute, Second}}}
					],
					Adder[
						Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 * 1 / Second],
							Units -> {-1, {Minute, {Minute, Second}}}
						]
					]
				]
			},
			{
				OptionName -> ColumnPrimeIsotopeMassTolerance,
				Default -> Automatic,
				Description -> "The range of m/z around a mass to consider for exclusion. This applies for both ChargeState and mass shifted Isotope. If set to 0.5 Gram/Mole, then the total range should be 1 Gram/Mole.",
				ResolutionDescription -> "When ColumnPrimeSurveyIsotopeExclusion or ColumnPrimeSurveyChargeStateExclusion is True, set to 0.5 Gram/Mole; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
						Units -> Gram/Mole
					]
				]
			},
			{
				OptionName -> ColumnPrimeIsotopeRatioTolerance,
				Default -> Automatic,
				Description -> "The range of relative magnitude around ColumnPrimeIsotopeRatio to consider for isotope exclusion.",
				ResolutionDescription -> "If ColumnPrimeSurveyIsotopeExclusion is True, set to 30*Percent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent,100Percent],
						Units -> Percent
					]
				]
			},
			{
				OptionName -> ColumnPrimeNeutralLoss,
				Default -> Automatic,
				Description ->"A neutral loss scan is performed on ESI-QQQ mass spectrometry by scanning the sample through the first quadrupole (Q1). The ions are then fragmented in the collision cell. The second mass analyzer is then scanned with a fixed offset to MS1. This option represents the value of this offset.",
				ResolutionDescription ->"Is set to 500 g/mol if using NeutralIonLoss as the ColumnPrimeAcquisitionMode, and is Null in other modes.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Gram/Mole],
					Units ->
						CompoundUnit[
							{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
							{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
						]
				]
			},
			{
				OptionName -> ColumnPrimeDwellTime,
				Default -> Automatic,
				Description -> "The duration of time for which spectra are acquired at the specific mass detection value for SelectedIonMonitoring and MultipleReactionMonitoring mode in ESI-QQQ.",
				ResolutionDescription -> "Is automatically set to 200 microsecond if ColumnPrimeAcquisitionMode is in SelectedIonMonitoring or MultipleReactionMonitoring mode.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget ->Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[5 Millisecond,  2000 Millisecond],
						Units -> {Millisecond, {Millisecond,Second,Minute}}
					],
					Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[5 Millisecond,  2000 Millisecond],
							Units -> {Millisecond, {Millisecond,Second,Minute}}
						],
						Orientation->Vertical
					]
				]
			},
			{
				OptionName -> ColumnPrimeCollisionCellExitVoltage,
				Default -> Automatic,
				Description ->"Also known as the Collision Cell Exit Potential (CXP). This value focuses and accelerates the ions out of collision cell (Q2) and into 2nd mass analyzer (MS 2). This potential is tuned to ensure successful ion acceleration out of collision cell and into MS2, and can be adjusted to reach the maximal signal intensity. This option is unique to ESI-QQQ for now, and only required when Fragment ->True and/or in ScanMode that achieves tandem mass feature (PrecursorIonScan, NeutralIonLoss,ProductIonScan,MultipleReactionMonitoring). For non-tandem mass ScanMode (FullScan and SelectedIonMonitoring) and other massspectrometer (ESI-QTOF and MALDI-TOF), this option is resolved to Null.",
				ResolutionDescription ->"For TripleQuadrupole as the MassAnalyzer, is set to first CollisionCellExitVoltage, otherwise set to Null.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-55 Volt, 55 Volt],
					Units -> Volt
				]
			},
			{
				OptionName -> ColumnPrimeMassDetectionStepSize,
				Default -> Automatic,
				Description ->"Indicate the step size for mass collection in range when using TripleQuadruploe as the MassAnalyzer.",
				ResolutionDescription ->"Is set to first CollisionCellExitVoltage",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.01 Gram/Mole, 1 Gram/Mole],
					Units -> CompoundUnit[
						{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
						{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
					]
				]
			},
			{
				OptionName -> ColumnPrimeMultipleReactionMonitoringAssays,
				Default -> Automatic,
				Description -> "In ESI-QQQ mass spectrometry analysis, the ion corresponding to the compound of interest is targeted with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and DwellTime (length of time of each scan).",
				ResolutionDescription -> "Is set based on ColumnPrimeMassDetection, ColumnPrimeCollisionEnergy, ColumnPrimeDwellTime and ColumnPrimeFragmentMassDetection.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Alternatives[
					"Individual Multiple Reaction Monitoring Assay" -> Adder[{
						"Mass Selection Values" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Gram / Mole],
							Units -> CompoundUnit[
								{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
								{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
							]
						],
						"CollisionEnergies" -> Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Volt, 180 Volt] | RangeP[-180 Volt, 5 Volt],
								Units -> Volt
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						],
						"Fragment Mass Selection Values" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Gram / Mole],
							Units -> CompoundUnit[
								{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
								{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
							]
						],
						"Dwell Times" -> Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Second],
								Units -> {Millisecond, {Microsecond, Millisecond, Second}}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						]
					}],
					{
						"Multiple Reaction Monitoring Assays" -> Adder[{
							"Mass Selection Values" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Gram / Mole],
								Units -> CompoundUnit[
									{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
									{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
								]
							],
							"CollisionEnergies" -> Alternatives[
								Widget[
									Type -> Quantity,
									Pattern :> RangeP[5 Volt, 180 Volt] | RangeP[-180 Volt, 5 Volt],
									Units -> Volt
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Automatic]
								]
							],
							"Fragment Mass Selection Values" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Gram / Mole],
								Units -> CompoundUnit[
									{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
									{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
								]
							],
							"Dwell Times" -> Alternatives[
								Widget[
									Type -> Quantity,
									Pattern :> GreaterP[0 Second],
									Units -> {Millisecond, {Microsecond, Millisecond, Second}}
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Automatic]
								]
							]
						}]
					},
					"None"->Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null, {Null}]
					]
				]
			}
		],

		{
			OptionName -> ColumnPrimeAbsorbanceWavelength,
			Default -> Automatic,
			Description -> "The wavelength of light passed through the flow for the UVVis and Detector for detection during column prime. For PhotoDiodeArray Detector, a 3D data is generated from a spectrum of light passing through the flow cell. Absorbance wavelength in that case represents the wavelength at which a 2D data slice is generated from the 3D data.",
			ResolutionDescription -> "Automatically set to the same as the first entry in AbsorbanceWavelength.",
			AllowNull -> True,
			Widget -> Alternatives[
				"Single" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[190 Nanometer, 500 Nanometer, 1 Nanometer],
					Units -> Nanometer
				],
				"All" -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[All]
				],
				"Range" -> Span[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[190 Nanometer, 490 Nanometer, 1 Nanometer],
						Units -> Nanometer
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[200 Nanometer, 500 Nanometer, 1 Nanometer],
						Units -> Nanometer
					]
				]
			],
			Category -> "Column Prime"
		},
		{
			OptionName -> ColumnPrimeWavelengthResolution,
			Default -> Automatic,
			Description -> "The increment in wavelength for the range of wavelength of light passed through the flow for absorbance measurement for the instruments with PhotoDiodeArray Detector during column prime.",
			ResolutionDescription -> "Automatically set to the same as the first entry in WavelengthResolution.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[1.2 * Nanometer, 12.0 * Nanometer], (*this can only go to specific values*)
				Units -> Nanometer
			],
			Category -> "Column Prime"
		},
		{
			OptionName -> ColumnPrimeUVFilter,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if UV wavelengths (less than 210 nm) should be blocked from being transmitted through the sample for the PhotoDiodeArray (PDA) detector for ColumnPrime measurements.",
			ResolutionDescription -> "Automatically set to the same as the first entry in UVFilter.",
			Category -> "Column Prime"
		},
		{
			OptionName -> ColumnPrimeAbsorbanceSamplingRate,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[1 * 1 / Second, 80 * 1 / Second, 1 * 1 / Second], (*can be only specific values*)
				Units -> {-1, {Minute, {Minute, Second}}}
			],
			Description -> "The number of times an absorbance measurement is made per second during column prime. Lower values will be less susceptible to noise but will record less frequently across time.",
			ResolutionDescription -> "Automatically set to the same as the first entry in AbsorbanceSamplingRate.",
			Category -> "Column Prime"
		},
		(* --- Column Flush Gradient Parameters --- *)
		{
			OptionName -> ColumnFlushTemperature,
			Default -> Automatic,
			Description -> "The column's temperature at which the column flush gradient is run. If ColumnFlushTemperature is set to Ambient, column oven temperature control is not used. Otherwise, ColumnFlushTemperature is maintained by temperature control of the column oven.",
			ResolutionDescription -> "Automatically set to the corresponding gradient temperature specified in the ColumnFlushGradient option or the column temperature for the column flush in the InjectionTable option; otherwise, set as the first value of the ColumnTemperature option.",
			AllowNull -> True,
			Category -> "Column Flush",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[30 Celsius, 90 Celsius],
					Units -> Celsius
				],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ambient]
				]
			]
		},
		{
			OptionName -> ColumnFlushGradientA,
			Default -> Automatic,
			Description -> "The composition of BufferA within the flow, defined for specific time points for column flush. The composition is linearly interpolated for the intervening periods between the defined time points. For example for ColumnFlushGradientA->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferA in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
			ResolutionDescription -> "If ColumnFlushGradient option is specified, set from it or implicitly determined from the ColumnFlushGradientB, ColumnFlushGradientC, and ColumnFlushGradientD options such that the total amounts to 100%.",
			AllowNull -> True,
			Category -> "Column Flush",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Minute, $MaxExperimentTime],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer A Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> ColumnFlushGradientB,
			Default -> Automatic,
			Description -> "The composition of BufferB within the flow, defined for specific time points for column flush. The composition is linearly interpolated for the intervening periods between the defined time points. For example for ColumnFlushGradientB->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferB in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
			ResolutionDescription -> "If ColumnFlushGradient option is specified, set from it or implicitly determined from the ColumnFlushGradientA, ColumnFlushGradientC, and ColumnFlushGradientD options such that the total amounts to 100%.",
			AllowNull -> True,
			Category -> "Column Flush",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Minute, $MaxExperimentTime],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer B Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> ColumnFlushGradientC,
			Default -> Automatic,
			Description -> "The composition of BufferC within the flow, defined for specific time points for column flush. The composition is linearly interpolated for the intervening periods between the defined time points. For example for ColumnFlushGradientC->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferC in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
			ResolutionDescription -> "If ColumnFlushGradient option is specified, set from it or implicitly determined from the ColumnFlushGradientA, ColumnFlushGradientB, and ColumnFlushGradientD options such that the total amounts to 100%.",
			AllowNull -> True,
			Category -> "Column Flush",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Minute, $MaxExperimentTime],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer C Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> ColumnFlushGradientD,
			Default -> Automatic,
			Description -> "The composition of BufferD within the flow, defined for specific time points for column flush. The composition is linearly interpolated for the intervening periods between the defined time points. For example for ColumnFlushGradientD->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferD in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
			ResolutionDescription -> "If ColumnFlushGradient option is specified, set from it or implicitly determined from the ColumnFlushGradientA, ColumnFlushGradientB, and ColumnFlushGradientC options such that the total amounts to 100%.",
			AllowNull -> True,
			Category -> "Column Flush",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Minute, $MaxExperimentTime],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer D Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> ColumnFlushFlowRate,
			Default -> Automatic,
			Description -> "The net speed of the fluid flowing through the pump inclusive of the composition of BufferA, BufferB, BufferC, and BufferD specified in the ColumnFlushGradient options during column flush. This speed is linearly interpolated such that consecutive entries of {Time, Flow Rate} will define the intervening fluid speed. For example, {{0 Minute, 0.3 Milliliter/Minute},{30 Minute, 0.5 Milliliter/Minute}} means flow rate of 0.4 Milliliter/Minute at 15 minutes into the run.",
			ResolutionDescription -> "If ColumnFlushGradient option is specified, automatically set from the method given in the ColumnFlushGradient option. If NominalFlowRate of the column model is specified, set to lesser of the NominalFlowRate for each of the columns, guard columns or the instrument's MaxFlowRate. Otherwise set to 1 Milliliter / Minute.",
			AllowNull -> True,
			Category -> "Column Flush",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Milliliter / Minute, 2 Milliliter / Minute],
					Units -> CompoundUnit[
						{1, {Milliliter, {Milliliter, Liter}}},
						{-1, {Minute, {Minute, Second}}}
					]
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Minute, $MaxExperimentTime],
							Units -> {Minute, {Second, Minute}}
						],
						"Flow Rate" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Milliliter / Minute, 2 Milliliter / Minute],
							Units -> CompoundUnit[
								{1, {Milliliter, {Milliliter, Liter}}},
								{-1, {Minute, {Minute, Second}}}
							]
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> ColumnFlushGradient,
			Default -> Automatic,
			Description -> "The composition of different specified buffers in BufferA, BufferB, BufferC and BufferD over time in the fluid flow for column prime. Specific parameters of a gradient object can be overridden by specific options.",
			ResolutionDescription -> "Automatically set to best meet the values specified in ColumnFlushGradient options (e.g. ColumnFlushGradientA, ColumnFlushGradientB, ColumnFlushGradientC, ColumnFlushGradientD, ColumnFlushFlowRate).",
			AllowNull -> True,
			Category -> "Column Flush",
			Widget -> Alternatives[
				Widget[Type -> Object, Pattern :> ObjectP[Object[Method, Gradient]]],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Minute, $MaxExperimentTime],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer A Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer B Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer C Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer D Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Flow Rate" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Milliliter / Minute, 2 Milliliter / Minute],
							Units -> CompoundUnit[
								{1, {Milliliter, {Milliliter, Liter}}},
								{-1, {Minute, {Minute, Second}}}
							]
						]
					},
					Orientation -> Vertical
				]
			]
		},
		{
			OptionName -> ColumnFlushIonMode,
			Default -> Automatic,
			Description -> "Indicates if positively or negatively charged ions are analyzed.",
			ResolutionDescription -> "Set to the first IonMode for an analyte input sample.",
			Category -> "Column Flush",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> IonModeP
			]
		},
		{
			OptionName -> ColumnFlushMassSpectrometryMethod,
			Default -> Automatic,
			Description -> "The previously specified instruction(s) for the analyte ionization, selection, fragmentation, and detection.",
			ResolutionDescription -> "If ColumnFlush samples exist and MassSpectrometryMethod is specified, then set to the first available ColumnFlushMassSpectrometryMethod.",
			AllowNull -> True,
			Category -> "Column Flush",
			Widget -> Alternatives[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Method, MassAcquisition]]
				],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[New]
				]
			]
		},
		{
			OptionName -> ColumnFlushESICapillaryVoltage,
			Default -> Automatic,
			Description -> "The absolute voltage applied to the tip of the stainless steel capillary tubing in order to produce charged droplets. Adjust this voltage to maximize sensitivity. Most compounds are optimized between 0.5 and 3.2 kV in ESI positive ion mode and 0.5 and 2.6 in ESI negative ion mode, but can be altered according to sample type. For low flow applications, best sensitivity will be achieved with a relatively high value in ESI positive (e.g. 3.0 kV), for columnFlush flow UPLC a value of 0.5 kV is typically best for maximum sensitivity.",
			ResolutionDescription -> "Is automatically set to the first ESICapillaryVoltage.",
			AllowNull -> True,
			Category -> "Column Flush",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[-4 Kilovolt, 5 Kilovolt],
				Units -> {Kilovolt, {Millivolt, Volt, Kilovolt}}
			]
		},
		{
			OptionName -> ColumnFlushDeclusteringVoltage,
			Default -> Automatic,
			Description -> "The voltage offset between the ion block (the reduced pressure chamber of the source block) and the stepwave ion guide (the optics before the quadrupole mass analyzer). This voltage attracts charged ions in the spray being produced from the capillary tip into the ion block leading into the mass spectrometer. This voltage is typically set to 25-100 V and its tuning has little effect on sensitivity compared to other options (e.g. ColumnFlushStepwaveVoltage).",
			ResolutionDescription -> "Is automatically set to any specified MassAcquisition method; otherwise, set to 40 Volt.",
			AllowNull -> True,
			Category -> "Column Flush",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.1 Volt, 150 Volt],
				Units -> {Volt, {Millivolt, Volt, Kilovolt}}
			]
		},
		{
			OptionName -> ColumnFlushStepwaveVoltage,
			Default -> Automatic,
			Description -> "The voltage offset between the 1st and 2nd stage of the stepwave ion guide which leads ions coming from the sample cone towards the quadrupole mass analyzer. This voltage normally optimizes between 25 and 150 V and should be adjusted for sensitivity depending on compound and charge state. For multiply charged species it is typically set to to 40-50 V, and higher for singly charged species. In general higher cone voltages (120-150 V) are needed for larger mass ions such as intact proteins and monoclonal antibodies. It also has greatest effect on in-source fragmentation and should be decreased if in-source fragmentation is observed but not desired.",
			ResolutionDescription -> "Is automatically set to the first StepwaveVoltage.",
			AllowNull -> True,
			Category -> "Column Flush",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.1 Volt, 200 Volt],
				Units -> {Volt, {Millivolt, Volt, Kilovolt}}
			]
		},
		{
			OptionName -> ColumnFlushIonGuideVoltage,
			Default -> Automatic,
			Description -> "This option (also known as Entrance Potential (EP)) is a unique option of ESI-QQQ. This parameter indicates electric potential applied to the Ion Guide in ESI-QQQ, which guides and focuses the ions through the high-pressure ion guide region.",
			ResolutionDescription -> "Is automatically set to first IonGuideVoltage.",
			AllowNull -> True,
			Category -> "Ionization",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[-15 Volt, -2 Volt] | RangeP[2 Volt, 15 Volt],
				Units -> Volt
			]
		},
		{
			OptionName -> ColumnFlushSourceTemperature,
			Default -> Automatic,
			Description -> "The temperature setting of the source block. Heating the source block discourages condensation and decreases solvent clustering in the reduced vacuum region of the source. This temperature setting is flow rate and sample dependent. Typical values are between 60 to 120 Celsius. For thermally labile analytes, a lower temperature setting is recommended.",
			ResolutionDescription -> "Is automatically set to the first SourceTemperature.",
			AllowNull -> True,
			Category -> "Column Flush",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[25 Celsius, 150 Celsius],
				Units -> Celsius
			]
		},
		{
			OptionName -> ColumnFlushDesolvationTemperature,
			Default -> Automatic,
			Description -> "The temperature setting for the ESI desolvation heater that controls the nitrogen gas temperature used for solvent evaporation to produce single gas phase ions from the ion spray. Similar to ColumnFlushDesolvationGasFlow, this setting is dependent on solvent flow rate and composition. A typical range is from 150 to 650 Celsius.",
			ResolutionDescription -> "Is automatically set to the first DesolvationTemperature.",
			AllowNull -> True,
			Category -> "Column Flush",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[20 Celsius, 650 Celsius],
				Units -> Celsius
			]
		},
		{
			OptionName -> ColumnFlushDesolvationGasFlow,
			Default -> Automatic,
			Description -> "The rate at which nitrogen gas is flowed around the ESI capillary. It is used for solvent evaporation to produce single gas phase ions from the ion spray. Similar to ColumnFlushDesolvationTemperature, this setting is dependent on solvent flow rate and composition. Higher desolvation temperatures usually result in increased sensitivity, but too high values can cause spray instability. Typical values are between 300 to 1200 L/h.",
			ResolutionDescription -> "Is automatically set to the first DesolvationGasFlow.",
			AllowNull -> True,
			Category -> "Column Flush",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :>RangeP[55 Liter/Hour, 1200 Liter/Hour] | RangeP[0 PSI, 85 PSI],
				Units -> Alternatives[
					CompoundUnit[
						{1, {Liter, {Liter, Milliliter}}},
						{-1, {Hour, {Hour, Minute}}}
					],
					PSI
				]
			]
		},
		{
			OptionName -> ColumnFlushConeGasFlow,
			Default -> Automatic,
			Description -> "The rate at which nitrogen gas is flowed around the sample inlet cone (the spherical metal plate acting as a first gate between the sprayer and the reduced pressure chamber, the ion block). This gas flow is used to minimize the formation of solvent ion clusters. It also helps reduce adduct ions and directing the spray into the ion block while keeping the sample cone clean. Typical values are between 0 and 150 L/h.",
			ResolutionDescription -> "Is automatically set to the first ConeGasFlow.",
			AllowNull -> True,
			Category -> "Column Flush",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :>RangeP[0 Liter/Hour, 300 Liter/Hour] | RangeP[30 PSI, 50 PSI],
				Units -> Alternatives[
					CompoundUnit[
						{1, {Liter, {Liter, Milliliter}}},
						{-1, {Hour, {Hour, Minute}}}
					],
					PSI
				]
			]
		},
		IndexMatching[
			IndexMatchingParent -> ColumnFlushAcquisitionWindow,
			{
				OptionName -> ColumnFlushAcquisitionWindow,
				Default -> Automatic,
				Description -> "The time range with respect to the chromatographic separation to conduct analyte ionization, selection/survey, optional fragmentation, and detection.",
				ResolutionDescription -> "Set to the entire gradient window 0 Minute to the last time point in ColumnFlushGradient.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Span[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Minute,8 Hour],
						Units -> Minute
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Minute,8 Hour],
						Units -> Minute
					]
				]
			},
			{
				OptionName -> ColumnFlushAcquisitionMode,
				Default -> Automatic,
				Description -> "The method by which spectra are collected. DataDependent will depend on the properties of the measured mass spectrum of the intact ions. DataIndependent will systemically scan through all of the intact ions. MS1FullScan will focus on defined intact masses. MS1MS2 will focus on fragmented masses.",
				ResolutionDescription -> "Set to MS1FullScan unless DataDependent related options are set, then set to DataDependent.",
				Category -> "Column Flush",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> MSAcquisitionModeP (*DataIndependent|DataDependent|MS1FullScan|MS1MS2ProductIonScan|SelectedIonMonitoring|NeutralIonLoss|ProductIonScan|MultipleReactionMonitoring*)
				]
			},
			{
				OptionName -> ColumnFlushFragment,
				Default -> Automatic,
				Description -> "Indicates if ions should be collided with neutral gas and dissociated in order to measure the resulting product ions. Also known as tandem mass spectrometry or MS/MS (as opposed to MS).",
				ResolutionDescription -> "Set to True if ColumnFlushAcquisitionMode is MS1MS2ProductIonScan, DataDependent, or DataIndependent. Set True if any of the Fragmentation related options are set (e.g. ColumnFlushFragmentMassDetection).",
				Category -> "Column Flush",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> ColumnFlushMassDetection,
				Default -> Automatic,
				Description -> "The lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for intact masses. When ColumnFlushFragment is True, the intact ions will be selected for fragmentation.",
				ResolutionDescription -> "For ColumnFlushFragment -> False, automatically set to one of three default mass ranges according to the molecular weight of the ColumnFlushAnalytes to encompass them.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Alternatives[
					"Single" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
						Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
					],
					"Specific List" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						]
					],
					"Range" -> Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[2 Gram / Mole, 100000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						]
					],
					"All" -> Widget[
						Type -> Enumeration,
						Pattern :> MSAnalyteGroupP
					]
				]
			},
			{
				OptionName -> ColumnFlushScanTime,
				Default -> Automatic,
				Description -> "The duration of time allowed to pass between each spectral acquisition. When ColumnFlushAcquisitionMode is DataDependent, this value refers to the duration for measuring spectra from the intact ions. Increasing this value improves sensitivity whereas decreasing this value allows for more data points and spectra to be acquired.",
				ResolutionDescription -> "Set to 0.2 seconds unless a method is given.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.015 Second, 10 Second],
					Units -> Second
				]
			},
			{
				OptionName -> ColumnFlushFragmentMassDetection,
				Default -> Automatic,
				Description -> "The lowest and the highest mass-to-charge ratio (m/z) to be recorded or selected for product ions. When ColumnFlushAcquisitionMode is DataDependent|DataIndependent, all of the product ions in consideration for measurement.  Null if ColumnFlushFragment is False.",
				ResolutionDescription -> "When ColumnFlushFragment is False, set to Null. Otherwise, 20 Gram/Mole to the maximum ColumnFlushMassDetection.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Alternatives[
					"PrecursorIonScan" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[5 Gram / Mole, 16000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						]
					],
					"ProductIonScan" -> Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[5 Gram / Mole, 16000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[100 Gram / Mole, 16000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						]
					],
					"DataDependent or DataIndependent" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					],
					"Null" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null]
					],
					"MultipleReactionMonitoring" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[5 Gram / Mole, 2000 Gram / Mole],
							Units -> CompoundUnit[{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}}, {-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}]
						]
					]
				]
			},
			{
				OptionName -> ColumnFlushCollisionEnergy,
				Default -> Automatic,
				Description -> "The voltage by which intact ions are accelerated through inert gas in order to dissociate them into measurable fragment ion species when ColumnFlushFragment is True. Cannot be defined simultaneously with ColumnFlushCollisionEnergyMassProfile.",
				ResolutionDescription -> "Is automatically set to 40 Volt when ColumnFlushFragment is True, otherwise is set to Null.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[5 Volt, 255 Volt] | RangeP[-180 Volt, 5 Volt],
						Units -> Volt
					],
					Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[5 Volt, 180 Volt] | RangeP[-180 Volt, 5 Volt],
							Units -> Volt
						],
						Orientation->Vertical
					]
				]
			},
			{
				OptionName -> ColumnFlushCollisionEnergyMassProfile,
				Default -> Automatic,
				Description -> "The relationship of collision energy with the ColumnFlushMassDetection.",
				ResolutionDescription -> "Set to ColumnFlushCollisionEnergyMassScan if defined; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Span[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.1 Volt, 255 Volt],
						Units -> {Volt, {Millivolt, Volt, Kilovolt}}
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.1 Volt, 255 Volt],
						Units -> {Volt, {Millivolt, Volt, Kilovolt}}
					]
				]
			},
			{
				OptionName -> ColumnFlushCollisionEnergyMassScan,
				Default -> Automatic,
				Description -> "The collision energy profile at the end of the scan from ColumnFlushCollisionEnergy or ColumnFlushCollisionEnergyScanProfile, as related to analyte mass.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget->Alternatives[
					"Constant"->Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.1 Volt, 255 Volt],
						Units -> {Volt, {Millivolt, Volt, Kilovolt}}
					],
					"Range"->Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.1 Volt, 255 Volt],
							Units -> {Volt, {Millivolt, Volt, Kilovolt}}
						]
					]
				]
			},
			{
				OptionName -> ColumnFlushFragmentScanTime,
				Default -> Automatic,
				Description -> "The duration of the spectral scanning for each fragmentation of an intact ion when ColumnFlushAcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Automatically set to the same value as ScanTime if ColumnFlushAcquisitionMode is DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 10 Second],
						Units -> Second
					]
				]
			},
			{
				OptionName -> ColumnFlushAcquisitionSurvey,
				Default -> Automatic,
				Description -> "The number of intact ions to consider for fragmentation and product ion measurement in every measurement cycle when ColumnFlushAcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Automatically set to 10 if ColumnFlushAcquisitionMode is set to DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[1, 30, 1]
				]
			},
			{
				OptionName -> ColumnFlushMinimumThreshold,
				Default -> Automatic,
				Description -> "The minimum number of total ions detected within ScanTime durations needed to trigger the start of data dependent acquisition when ColumnFlushAcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Automatically set to (100000/Second)*ScanTime if ColumnFlushAcquisitionMode is DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 ArbitraryUnit, 8000000 ArbitraryUnit],
					Units -> ArbitraryUnit
				]
			},
			{
				OptionName -> ColumnFlushAcquisitionLimit,
				Default -> Automatic,
				Description -> "The maximum number of total ions for a specific intact ion when ColumnFlushAcquisitionMode is set to DataDependent. When this value is exceeded, acquisition will switch to fragmentation of the next candidate ion.",
				ResolutionDescription -> "Automatically inherited from supplied method if ColumnFlushAcquisitionMode is set to DataDependent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 ArbitraryUnit, 8000000 ArbitraryUnit],
					Units -> ArbitraryUnit
				]
			},
			{
				OptionName -> ColumnFlushCycleTimeLimit,
				Default -> Automatic,
				Description -> "The maximum possible computed duration of all of the scans for the intact and fragmentation measurements when ColumnFlushAcquisitionMode is set to DataDependent.",
				ResolutionDescription -> "Calculated from the ColumnFlushAcquisitionSurvey, ColumnFlushScanTime, and ColumnFlushFragmentScanTime.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.015 Second, 20000 Second],
					Units -> Second
				]
			},
			(*IndexMatching[
					IndexMatchingParent -> ExclusionDomain,*)
			{
				OptionName -> ColumnFlushExclusionDomain,
				Default -> Automatic,
				Description -> "The tune range when the ColumnFlushExclusionMasses are omitted in the chromatogram. Full indicates for the entire period.",
				ResolutionDescription -> "Set to the entire ColumnFlushAcquisitionWindow.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Alternatives[
					Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						]
					],
					Adder[Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						]
					]]
				]
			},
			{
				OptionName -> ColumnFlushExclusionMass, (*Index matched to the exclusion domain*)
				Default -> Automatic,
				Description -> "The intact ions (Target Mass) to omit. When the Mode is set to All, the mass is excluded for the entire ExclusionDomain. When the Mode is set to Once, the Mass is excluded in the first survey appearance, but considered for consequent ones.",
				ResolutionDescription -> "If any ColumnFlushExclusionMode-related options are set (e.g. ColumnFlushExclusionMassTolerance), a target mass of the first Analyte (if not in ColumnFlushInclusionMasses) is chosen and retention time is set to 0*Minute.",
				Category -> "Column Flush",
				AllowNull -> True,
				Widget -> Alternatives[
					{
						"Mode" -> Widget[
							Type-> Enumeration,
							Pattern:>All|Once
						],
						"Target Mass" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[2 Gram/Mole, 100000 Gram/Mole],
							Units -> Gram/Mole
						]
					},
					Adder[
						{
							"Mode" -> Widget[
								Type-> Enumeration,
								Pattern:>All|Once
							],
							"Target Mass" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[2 Gram/Mole, 100000 Gram/Mole],
								Units -> Gram/Mole
							]
						}
					]
				]
			},
			(*	], *)
			{
				OptionName -> ColumnFlushExclusionMassTolerance,
				Default -> Automatic,
				Description -> "The range above and below each ion in ColumnFlushExclusionMasses to consider for omission when ColumnFlushExclusionMass is set to All or Once.",
				ResolutionDescription -> "If ColumnFlushExclusionMass -> All or Once, set to 0.5 Gram/Mole; otherwise, Null.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
					Units -> Gram/Mole
				]
			},
			{
				OptionName -> ColumnFlushExclusionRetentionTimeTolerance,
				Default -> Automatic,
				Description -> "The range of time above and below the ColumnFlushExclusionDomain to consider for exclusion.",
				ResolutionDescription -> "If ColumnFlushExclusionMass and ColumnFlushExclusionDomain options are set, this is set to 10 seconds; otherwise, Null.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Second, 3600 Second],
					Units -> Second
				]
			},
			(*IndexMatching[
					IndexMatchingParent -> InclusionDomain, *)
			{
				OptionName -> ColumnFlushInclusionDomain,
				Default -> Automatic,
				Description -> "The time range when the ColumnFlushInclusionMass applies with respect to the chromatogram.",
				ResolutionDescription -> "Set to the entire ColumnFlushAcquisitionWindow.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Alternatives[
					Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						]
					],
					Adder[Alternatives[
						Span[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							],
							Widget[ Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> Minute
							]
						],
						Widget[
							Type-> Enumeration,
							Pattern:>Alternatives[Full]
						]
					]]
				]
			},
			{
				OptionName -> ColumnFlushInclusionMass, (*Index matched to InclusionDomain*)
				Default -> Automatic,
				Description -> "The ions (Target Mass) to prioritize during the survey scan for further fragmentation When ColumnFlushAcquisitionMode is DataDependent. ColumnFlushInclusionMass set to Only will solely be considered for surveys.  When Mode is Preferential, the InclusionMass will be prioritized for survey.",
				ResolutionDescription -> "When ColumnFlushInclusionMode  Only or Preferential, an entry mass is added based on the mass of the most salient analyte of the sample.",
				Category -> "Column Flush",
				AllowNull -> True,
				Widget -> Alternatives[
					{
						"Mode" -> Widget[ (*InclusionMassMode*)
							Type-> Enumeration,
							Pattern:>Only|Preferential
						],
						"Target Mass" -> Widget[ (*InclusionMass*)
							Type -> Quantity,
							Pattern :> RangeP[2 Gram/Mole, 4000 Gram/Mole],
							Units -> Gram/Mole
						]
					},
					Adder[
						{
							"Mode" -> Widget[ (*InclusionMassMode*)
								Type-> Enumeration,
								Pattern:>Only|Preferential
							],
							"Target Mass" -> Widget[ (*InclusionMass*)
								Type -> Quantity,
								Pattern :> RangeP[2 Gram/Mole, 4000 Gram/Mole],
								Units -> Gram/Mole
							]
						}
					]
				]
			},
			{
				OptionName -> ColumnFlushInclusionCollisionEnergy, (*Index matched to ColumnFlushInclusionDomain*)
				Default -> Automatic,
				Description -> "The overriding collision energy value that can be applied to the ColumnFlushInclusionMass. Null will default to the ColumnFlushCollisionEnergy option and related.",
				ResolutionDescription -> "Inherited from any supplied method.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Volt, 255 Volt],
						Units -> Volt
					],
					Adder[Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Volt, 255 Volt],
						Units -> Volt
					]]
				]
			},
			{
				OptionName -> ColumnFlushInclusionDeclusteringVoltage,
				Default -> Automatic,
				Description -> "The overriding source voltage value that can be applied to the ColumnFlushInclusionMass. Null will default to the ColumnFlushDeclusteringVoltage option.",
				ResolutionDescription -> "Inherited from any supplied method.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Alternatives[
					Widget[ (*InclusionDeclusteringVoltage*)
						Type -> Quantity,
						Pattern :> RangeP[0.1 Volt, 150 Volt],
						Units -> Volt
					],
					Adder[Widget[ (*InclusionDeclusteringVoltage*)
						Type -> Quantity,
						Pattern :> RangeP[0.1 Volt, 150 Volt],
						Units -> Volt
					]]
				]
			},
			{
				OptionName -> ColumnFlushInclusionChargeState,
				Default -> Automatic,
				Description -> "The maximum charge state of the ColumnFlushInclusionMass to also consider for inclusion. For example, if this is set to 3 and the polarity is Positive, then +1,+2,+3 charge states will be considered as well.",
				ResolutionDescription -> "Inherited from any supplied method.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[0, 6, 1]
					],
					Adder[Widget[
						Type -> Number,
						Pattern :> RangeP[0, 6, 1]
					]]
				]
			},
			{
				OptionName -> ColumnFlushInclusionScanTime,
				Default -> Automatic,
				Description -> "The overriding scan time duration that can be applied to the ColumnFlushInclusionMass for the consequent fragmentation. Null will default to the ColumnFlushFragmentScanTime option.",
				ResolutionDescription -> "Inherited from any supplied method.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 10 Second],
						Units -> Second
					],
					Adder[Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.015 Second, 10 Second],
						Units -> Second
					]]
				]
			},
			(*)]*)
			{
				OptionName -> ColumnFlushInclusionMassTolerance,
				Default -> Automatic,
				Description -> "The range above and below each ion in ColumnFlushInclusionMass to consider for prioritization. For example, if set to 0.5 Gram/Mole, the total range is 1 Gram/Mole.",
				ResolutionDescription -> "Set to 0.5 Gram/Mole if ColumnFlushInclusionMass is given; otherwise, Null.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
						Units -> Gram/Mole
					]
				]
			},
			{
				OptionName -> ColumnFlushSurveyChargeStateExclusion,
				Default -> Automatic,
				Description -> "Indicates if redundant ions that differ by ionic charge (+1/-1, +2/-2, etc.) should be excluded and if ColumnFlushChargeState exclusion-related options should be automatically filled in.",
				ResolutionDescription -> "Set to True, if any of the ColumnFlushChargeState options are set; otherwise, False.",
				Category -> "Column Flush",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Enumeration,
						Pattern :> BooleanP
					]
				]
			},
			{
				OptionName -> ColumnFlushSurveyIsotopeExclusion,
				Default -> Automatic,
				Description -> "Indicates if redundant ions that differ by isotopic mass (e.g. 1, 2 Gram/Mole) should be excluded and if ColumnFlushMassIsotope exclusion-related options should be automatically filled.",
				ResolutionDescription -> "Set to True, if any of the ColumnFlushIsotopeExclusion options are set; otherwise, False.",
				Category -> "Column Flush",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> ColumnFlushChargeStateExclusionLimit,
				Default -> Automatic,
				Description -> "The number of ions to survey first with exclusion by ionic state. For example, if ColumnFlushAcquisitionSurvey is 10 and this option is 5, then 5 ions will be surveyed with charge-state exclusion. For candidate ions of rank 6 to 10, no exclusion will be performed.",
				ResolutionDescription -> "Inherited from any supplied method; otherwise, set the same to ColumnFlushAcquisitionSurvey, if any ChargeState option is set.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Number,
					Pattern :> RangeP[0, 30, 1]
				],
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushChargeStateExclusion,
				Default -> Automatic,
				Description -> "The specific ionic states of intact ions to redundantly exclude from the survey for further fragmentation/acquisition. 1 refers to +1/-1, 2 refers to +2/-2, etc.",
				ResolutionDescription -> "When ColumnFlushSurveyChargeStateExclusion is True, set to {1,2}; otherwise, Null.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[1, 6, 1]
					],
					Adder[
						Widget[
							Type -> Number,
							Pattern :> RangeP[1, 6, 1]
						]
					]
				],
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushChargeStateMassTolerance,
				Default -> Automatic,
				Description -> "The range of m/z to consider for exclusion by ionic state property when ColumnFlushSurveyChargeStateExclusion is True.",
				ResolutionDescription -> "When ColumnFlushSurveyChargeStateExclusion is True, set to 0.5 Gram/Mole; otherwise, Null.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
					Units -> Gram/Mole
				]
			},
			(*	IndexMatching[
					IndexMatchingParent -> IsotopicExclusion,*)
			{
				OptionName -> ColumnFlushIsotopicExclusion,
				Default -> Automatic,
				Description -> "The m/z difference between monoisotopic ions as a criterion for survey exclusion.",
				ResolutionDescription -> "When ColumnFlushSurveyIsotopeExclusion is True, set to 1 Gram/Mole; otherwise, Null.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Alternatives[
					Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						]
					],
					Adder[Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
							Units -> Gram/Mole
						]
					]]
				]
			},
			{
				OptionName -> ColumnFlushIsotopeRatioThreshold, (*index matching IsotopicExclusion*)
				Default -> Automatic, (*TODO: Figure *)
				Description -> "The minimum relative magnitude between monoisotopic ions in order to be considered an isotope for exclusion.",
				ResolutionDescription -> "When ColumnFlushSurveyIsotopeExclusion is True, set to 0.1; otherwise, Null.",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Number,
						Pattern :> RangeP[0, 1]
					],
					Adder[Widget[
						Type -> Number,
						Pattern :> RangeP[0, 1]
					]]
				],
				Category -> "Column Flush"
			}
			(*]*),
			{ (*index matching to above*)
				OptionName -> ColumnFlushIsotopeDetectionMinimum,
				Default -> Automatic,
				Description -> "The acquisition rate of a given intact mass to consider for isotope exclusion in the survey.",
				ResolutionDescription -> "When ColumnFlushSurveyIsotopeExclusion is True, set to 10 1/Second; otherwise, Null.",
				Category -> "Column Flush",
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 * 1 / Second],
						Units -> {-1, {Minute, {Minute, Second}}}
					],
					Adder[
						Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 * 1 / Second],
							Units -> {-1, {Minute, {Minute, Second}}}
						]
					]
				]
			},
			{
				OptionName -> ColumnFlushIsotopeMassTolerance,
				Default -> Automatic,
				Description -> "The range of m/z around a mass to consider for exclusion. This applies for both ChargeState and mass shifted Isotope. If set to 0.5 Gram/Mole, then the total range should be 1 Gram/Mole.",
				ResolutionDescription -> "When ColumnFlushSurveyIsotopeExclusion or ColumnFlushSurveyChargeStateExclusion is True, set to 0.5 Gram/Mole; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Gram/Mole, 3000 Gram/Mole],
						Units -> Gram/Mole
					]
				]
			},
			{
				OptionName -> ColumnFlushIsotopeRatioTolerance,
				Default -> Automatic,
				Description -> "The range of relative magnitude around ColumnFlushIsotopeRatio to consider for isotope exclusion.",
				ResolutionDescription -> "If ColumnFlushSurveyIsotopeExclusion is True, set to 30*Percent; otherwise, set to Null.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent,100Percent],
						Units -> Percent
					]
				]
			},
			{
				OptionName -> ColumnFlushNeutralLoss,
				Default -> Automatic,
				Description ->"A neutral loss scan is performed on ESI-QQQ mass spectrometry by scanning the sample through the first quadrupole (Q1). The ions are then fragmented in the collision cell. The second mass analyzer is then scanned with a fixed offset to MS1. This option represents the value of this offset.",
				ResolutionDescription ->"Is set to 500 g/mol if using NeutralIonLoss as the ColumnFlushAcquisitionMode, and is Null in other modes.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Gram/Mole],
					Units ->
						CompoundUnit[
							{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
							{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
						]
				]
			},
			{
				OptionName -> ColumnFlushDwellTime,
				Default -> Automatic,
				Description -> "The duration of time for which spectra are acquired at the specific mass detection value for SelectedIonMonitoring and MultipleReactionMonitoring mode in ESI-QQQ.",
				ResolutionDescription -> "Is automatically set to 200 microsecond if ColumnFlushAcquisitionMode is in SelectedIonMonitoring or MultipleReactionMonitoring mode.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget ->Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[5 Millisecond,  2000 Millisecond],
						Units -> {Millisecond, {Millisecond,Second,Minute}}
					],
					Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[5 Millisecond,  2000 Millisecond],
							Units -> {Millisecond, {Millisecond,Second,Minute}}
						],
						Orientation->Vertical
					]
				]
			},
			{
				OptionName -> ColumnFlushCollisionCellExitVoltage,
				Default -> Automatic,
				Description ->"Also known as the Collision Cell Exit Potential (CXP). This value focuses and accelerates the ions out of collision cell (Q2) and into 2nd mass analyzer (MS 2). This potential is tuned to ensure successful ion acceleration out of collision cell and into MS2, and can be adjusted to reach the maximal signal intensity. This option is unique to ESI-QQQ for now, and only required when Fragment ->True and/or in ScanMode that achieves tandem mass feature (PrecursorIonScan, NeutralIonLoss,ProductIonScan,MultipleReactionMonitoring). For non-tandem mass ScanMode (FullScan and SelectedIonMonitoring) and other massspectrometer (ESI-QTOF and MALDI-TOF), this option is resolved to Null.",
				ResolutionDescription ->"For TripleQuadrupole as the MassAnalyzer, is set to first CollisionCellExitVoltage, otherwise set to Null.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[-55 Volt, 55 Volt],
					Units -> Volt
				]
			},
			{
				OptionName -> ColumnFlushMassDetectionStepSize,
				Default -> Automatic,
				Description ->"Indicate the step size for mass collection in range when using TripleQuadruploe as the MassAnalyzer.",
				ResolutionDescription ->"Is set to first CollisionCellExitVoltage",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.01 Gram/Mole, 1 Gram/Mole],
					Units -> CompoundUnit[
						{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
						{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
					]
				]
			},
			{
				OptionName -> ColumnFlushMultipleReactionMonitoringAssays,
				Default -> Automatic,
				Description -> "In ESI-QQQ mass spectrometry analysis, the ion corresponding to the compound of interest is targeted with subsequent fragmentation of that target ion to produce a range of daughter ions. One (or more) of these fragment daughter ions can be selected for quantitation purposes. Only compounds that meet both these criteria, i.e. specific parent ion and specific daughter ions corresponding to the mass of the molecule of interest are detected within the mass spectrometer. The mass assays (MS1/MS2 mass value combinations) for each scan, along with the CollisionEnergy and DwellTime (length of time of each scan).",
				ResolutionDescription -> "Is set based on ColumnFlushMassDetection, ColumnFlushCollisionEnergy, ColumnFlushDwellTime and ColumnFlushFragmentMassDetection.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Alternatives[
					"Individual Multiple Reaction Monitoring Assay" -> Adder[{
						"Mass Selection Values" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Gram / Mole],
							Units -> CompoundUnit[
								{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
								{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
							]
						],
						"CollisionEnergies" -> Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[5 Volt, 180 Volt] | RangeP[-180 Volt, 5 Volt],
								Units -> Volt
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						],
						"Fragment Mass Selection Values" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterP[0 Gram / Mole],
							Units -> CompoundUnit[
								{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
								{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
							]
						],
						"Dwell Times" -> Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Second],
								Units -> {Millisecond, {Microsecond, Millisecond, Second}}
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							]
						]
					}],
					{
						"Multiple Reaction Monitoring Assays" -> Adder[{
							"Mass Selection Values" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Gram / Mole],
								Units -> CompoundUnit[
									{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
									{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
								]
							],
							"CollisionEnergies" -> Alternatives[
								Widget[
									Type -> Quantity,
									Pattern :> RangeP[5 Volt, 180 Volt] | RangeP[-180 Volt, 5 Volt],
									Units -> Volt
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Automatic]
								]
							],
							"Fragment Mass Selection Values" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterP[0 Gram / Mole],
								Units -> CompoundUnit[
									{1, {Gram, {Nanogram, Microgram, Milligram, Gram, Kilogram}}},
									{-1, {Mole, {Nanomole, Micromole, Millimole, Mole}}}
								]
							],
							"Dwell Times" -> Alternatives[
								Widget[
									Type -> Quantity,
									Pattern :> GreaterP[0 Second],
									Units -> {Millisecond, {Microsecond, Millisecond, Second}}
								],
								Widget[
									Type -> Enumeration,
									Pattern :> Alternatives[Automatic]
								]
							]
						}]
					},
					"None"->Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Null, {Null}]
					]
				]
			}
		],
		{
			OptionName -> ColumnFlushAbsorbanceWavelength,
			Default -> Automatic,
			Description -> "The wavelength of light passed through the flow for the UVVis and Detector for detection during column flush. For PhotoDiodeArray Detector, a 3D data is generated from a spectrum of light passing through the flow cell. Absorbance wavelength in that case represents the wavelength at which a 2D data slice is generated from the 3D data.",
			ResolutionDescription -> "Automatically set to the same as the first entry in AbsorbanceWavelength.",
			AllowNull -> True,
			Widget -> Alternatives[
				"Single" -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[190 Nanometer, 500 Nanometer, 1 Nanometer],
					Units -> Nanometer
				],
				"All" -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[All]
				],
				"Range" -> Span[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[190 Nanometer, 490 Nanometer, 1 Nanometer],
						Units -> Nanometer
					],
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[200 Nanometer, 500 Nanometer, 1 Nanometer],
						Units -> Nanometer
					]
				]
			],
			Category -> "Column Flush"
		},
		{
			OptionName -> ColumnFlushWavelengthResolution,
			Default -> Automatic,
			Description -> "The increment of wavelength for the range of wavelength of light passed through the flow for absorbance measurement for the instruments with PhotoDiodeArray Detector during column flush.",
			ResolutionDescription -> "Automatically set to the same as the first entry in WavelengthResolution.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[1.2 * Nanometer, 12.0 * Nanometer], (*this can only go to specific values*)
				Units -> Nanometer
			],
			Category -> "Column Flush"
		},
		{
			OptionName -> ColumnFlushUVFilter,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if UV wavelengths (less than 210 nm) should be blocked from being transmitted through the flow for PhotoDiodeArray Detector during column flush.",
			ResolutionDescription -> "Automatically set to the same as the first entry in UVFilter.",
			Category -> "Column Flush"
		},
		{
			OptionName -> ColumnFlushAbsorbanceSamplingRate,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[1 * 1 / Second, 80 * 1 / Second, 1 * 1 / Second], (*can be only specific values*)
				Units -> {-1, {Minute, {Minute, Second}}}
			],
			Description -> "The number of times an absorbance measurement is made per second during column flush. Lower values will be less susceptible to noise but will record less frequently across time.",
			ResolutionDescription -> "Automatically set to the same as the first entry in AbsorbanceSamplingRate.",
			Category -> "Column Flush"
		},
		NonBiologyFuntopiaSharedOptions,
		ModifyOptions[
			ModelInputOptions,
			OptionName -> PreparedModelAmount
		],
		ModifyOptions[
			ModelInputOptions,
			PreparedModelContainer,
			{
				ResolutionDescription -> "If PreparedModelAmount is set to All and the input model has a product associated with both Amount and DefaultContainerModel populated, automatically set to the DefaultContainerModel value in the product. Otherwise, automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"]."
			}
		],
		SimulationOption
	}
];

Error::InclusionExclusionOverlap="The same mass is in the InclusionMode list as the ExclusionMode list for `1`. Please specify distinct masses in InclusionMode and ExclusionMode lists.";
Error::OnlyMassSpecAvailable="We do not currently offer `1` as mass spectrometer for LCMS. Currently, we offer `2`.";
Error::OnlyHPLCAvailable="We do not currently offer `1` as a chromatography instrument for LCMS. Currently, we offer `2`.";
Error::HPLCColumnsCannotFitLCMS = "The specified columns cannot fit into the instrument's column oven compartment. Please check the Dimensions of the column and the MaxColumnLength of the instruments and select a different column in the experiment.";
Error::ColumnPrimeConflict="Column prime options cannot be set when column prime is not being performed. Consider allowing options `1` to be set automatically";
Error::ColumnFlushConflict="Column flush options cannot be set when column flush is not being performed. Considering letting options `1` to be set automatically";
Error::FragmentConflict="The Fragment options `1` must be compatible with their corresponding AcquisitionMode option. Fragment must be True when AcquisitionMode is MS1MS2ProductIonScan, PrecursorIonScan, NeutralIonLoss, MultipleReactionMonitoring,DataIndependent, and DataDependent, and it must be False for MS1FullScan. Consider setting either the AcquisitionMode or Fragment.";
Error::MassDetectionConflict="The MassDetection options `1` cannot have multiple entries when AcquisitionMode is MS1MS2ProductIonScan. Only one mass can be chosen.";
Error::FragmentDetectionConflict="FragmentMassDetection options `1` must be specified if the AcquisitionMode is MS1MS2ProductIonScan, DataDependent, or DataIndependent, or must be Null if the AcquisitionMode is MS1FullScan. Consider using an AcquisitionMode of MS1MS2ProductIonScan, DataIndependent, or DataDependent if `1` are desired, or setting FragmentMassDetection to Null if the desired AcquisitionMode is MS1FullScan.";
Error::CollisonEnergyConflict="CollisionEnergy options `1` can not be defined unless the AcquisitionMode is MS1MS2ProductIonScan, DataDependent, DataIndependent. It should also be Null for when AcquisitionMode MS1FullScan.";
Error::CollisionEnergyProfileConflict="The defined CollisionEnergyMassProfile does not match with CollisionEnergy as seen in `1`. If AcquisitionMode is DataIndependent, CollisionEnergy must be smaller or equal to the left side of CollisionEnergyMassProfile.  Otherwise, CollisionEnergyMassProfile cannot be defined at the same time as CollisionEnergy, so consider setting either CollisionEnergyMassProfile or CollisionEnergy, but not both.";
Error::CollisionEnergyScanConflict="CollisionEnergyMassScan options `1` cannot be defined unless the corresponding AcquisitionMode is DataDependent.";
Error::FragmentScanTimeConflict="FragmentScanTime options `1` can only be set if the corresponding AcquisitionMode option is DataDependent. It must not be Null when AcquisitionMode is DataDependent. Consider setting AcquisitionMode to DataDependent or allowing FragmentScanTime options to be Automatic.";
Error::AcquisitionSurveyConflict="AcquisitionSurvey options `1` can only be set if the corresponding AcquisitionMode option is DataDependent. It must not be Null when AcquisitionMode is DataDependent. Consider setting AcquisitionMode to DataDependent or setting AcquisitionSurvey to Automatic. ";
Error::AcquisitionLimitConflict="AcquisitionLimit options `1` can only be set if the corresponding AcquisitionMode option is DataDependent. Consider setting AcquisitionMode to DataDependent or setting AcquisitionLimit Automatic.";
Error::CycleTimeLimitConflict= "The specified CycleTimeLimit options `1` cannot be met with the defined AcquisitionSurvey, ScanTime, and FragmentScanTime settings. Consider providing lower values for these options.";
Error::ExclusionModeConflict="ExclusionMode options `1` can only be set if the corresponding AcquisitionMode option is DataDependent. Consider setting AcquisitionMode to DataDependent or allowing ExclusionMode options to be set automatically.";
Error::ExclusionMassToleranceConflict="ExclusionMassTolerance options `1` can only be set if the corresponding ExclusionMode options are set. It must not be Null when ExclusionMode options are provided. Consider providing values for ExclusionMassTolerance and ExclusionMode options or allowing all these options to be set automatically.";
Error::ExclusionRetentionTimeConflict="ExclusionRetentionTimeTolerance options `1` can only be set if the corresponding ExclusionMode options are set. It must not be Null when ExclusionMode options are provided.";
Error::InclusionModeConflict="InclusionMode options `1` can only be set if the corresponding AcquisitionMode option is DataDependent. Consider setting the AcquisitionMode to DataDependent or setting InclusionMode options to Automatic.";
Error::InclusionMassToleranceConflict="InclusionMassTolerance options `1` can only be set if the corresponding InclusionMode options are set. It must not be Null when InclusionMode options are provided.";
Error::ChargeStateExclusionLimitConflict="ChargeStateExclusionLimit options `1` must not exceed the value of the corresponding AcquisitionSurvey. Consider setting the ChargeStateExclusion to a lower value or increasing the AcquisitionSurvey value.";
Error::ChargeStateExclusionConflict="ChargeStateExclusion options `1` can only be set if the corresponding AcquisitionMode option is DataDependent. Consider setting the AcquisitionMode to DataDependent or leaving the ChargeStateExclusion options as Automatic.";
Error::ChargeStateMassToleranceConflict="ChargeStateMassTolerance options `1` can only be set if the corresponding ChargeStateExclusion options are set. It must not be Null when ChargeStateExclusion options are provided.";
Error::IsotopicExclusionLimitConflict="IsotopicExclusionMass options `1` can only have up to 2 entries. Please remove anything beyond two entries.";
Error::IsotopicExclusionMassConflict="IsotopicExclusionMass options `1` can only be set if the corresponding AcquisitionMode option is DataDependent. Consider setting AcquisitionMode to DataDependent or setting the IsotopicExclusionMass options to Automatic.";
Error::IsotopeMassToleranceConflict="IsotopeMassTolerance options `1` can only be set if the corresponding IsotopicExclusionMass options are set. It must not be Null when ChargeStateExclusion options are provided.";
Error::IsotopeRatioToleranceConflict="IsotopeRatioTolerance options `1` can only be set if the corresponding IsotopicExclusionMass options are set. It must not be Null when ChargeStateExclusion options are provided.";
Error::LCMSInvalidScanTime = "Values for `1` are either too short (or too long). Each scan time must be greater than or equal to 3 Microseconds (and less than or equal to 5 Seconds) per point in the range. The number of points in the MassDetection range may be calculated by the equation: (Max[MassDetection] - Min[MassDetection])/MassDetectionStepSize + 1.";
Error::ExclusionModeMustBeSame="The instrument cannot mix and match different modes in ExclusionMasses options `1` as they current are in `2`.";
Error::DataIndependentSoleWindow="DataIndependent acquisition can only be done by itself. Redo options `1` so that DataIndependent acquisition is sole performed for the injection.";
Error::OverlappingAcquisitionWindows="The following acquisition windows options have overlap: `1` with values `2`. Please provide acquisition window options that do not overlap.";
Error::AcquisitionWindowTooLong="The following acquisition windows options `1` and their values `2` exceed the respective gradient duration `3`. Please shorten the window or use a longer gradient.";
Error::InvalidSourceTemperature="When using TripleQuadrupole as MassAnalyzer, the following source temperature options `1` and their values `2` is not 150 Celsius. The instrument for TripleQuadrupole can only accept 150 Celsius as SourceTemperature.";
Error::InvalidVoltageOptions="The following voltage related options `1` and their values `2` are not consistent with corresponding ion modes `3`. For QTOF as the mass analyzer, all CollisionEnergy can only be positive, and CollisionCellExitVoltage can only be Null. For TripleQuadrupole as the MassAnalyzer, please specify positive voltages for positive and negative mode for negative ion mode.";
Error::InvalidCollisionVoltageOptions="The following collision voltages related options `1` and their values `2` are not consistent with corresponding ion modes `3`. For QTOF as the mass analyzer, all voltages can only be positive. For TripleQuadrupole as the MassAnalyzer, please specify positive voltages for positive and negative mode for negative ion mode.";
Error::LCMSInvalidMultipleReactionMonitoringLengthOfInputOptions="When using MultipleReactionMonitoring as the acquisition modes, the following options `1` don't have same length of values for the inputs: `2`. Make sure \"Mass Selection Values\", \"CollisionEnergies\",\"Fragment Mass Selection Values\" and \"Dwell Times\" have the same length.";
Error::LCMSCollisionEnergyAcquisitionModeConflict="When not using MultipleReactionMonitoring as the acquisition mode, the following CollisionEnergy options `1` can only have one single value for each AcquisitionWindow. If multiple AcquisitionWindows are desired, please either specify the desired the AcquisitionWindow or add another layer of the list to specific CollisionEnergy values. For example: `2`";
Error::InvalidGasFlowOptions="The following gas flow options related options `1` and their values `2` are not consistent with corresponding mass analyzer `3`. For QTOF as the mass analyzer, the instrument accepts gas flows in flow rates (mL/min), while for QQQ as the mass analyzer, the instrument only accepts pressures (PSI) as the unit.";
Error::MassAnalyzerAndAcquitionModeMismatched="The acquisition mode specified for this experiment `1` and their values `2` are not consistent with specified massanalyzer `3`. For QTOF as the mass analyzer, AcquistionMode can be: DataIndependent, DataDependent, MS1FullScan, MS1MS2ProductIonScan. For QQQ as the mass analyzer, AcquisitionMode can be: MS1FullScan, MS1MS2ProductIonScan, SelectedIonMonitoring, NeutralIonLoss, PrecursorIonScan, MultipleReactionMonitoring";
Error::MassAnalyzerAndMassSpecInstrumentConflict="The MassAnalyzer: `1` cannot be used by specified instrument `2`. If QTOF is desired, please use Model[Instrument, MassSpectrometer, \"Xevo G2-XS QTOF\"], and if TripleQuadrupole is desired, please use Model[Instrument, MassSpectrometer, \"QTRAP 6500\"].";

(*Warning*)
Warning::OverwritingMassAcquisitionMethod="The following acquisition methods specified in the following options `1` will be overwritten with new methods because of specified acquisition changes.";
Warning::OnlyOneCalibrantWillBeRan="If the MassAnalyzer is not TripleQuadrupole, only one calibrant will be ran during the experiment: `1`. The SecondCalibrant (`2`) will not be ran.";
Warning::SameCalibrantsForLCMS="The specified carlibrants `1` and `2` are same, only one calibrant will be ran in experiment.";
Warning::LCMSAutoResolvedNeutralLoss="For using TripleQuadrupole and NeutralIonLoss as the acquisition mode, a valid mass value in NeutralLoss option needs to be specified in order to generate useful and reliable data. The experiment can further proceed with an automatically assigned value `2` for the following options `1`, but this experiment may not generate reliable data.";

(*Instrumentation Issue: Waiting on SciEx to resolve the following error message and associated code can be removed if the company is able to address this issue. *)
Error::InstrumentationLimitation = "The specified options are unable to be fulfilled faithfully by the mass spectrometer. These conditions result in data artifacts during acquisition. Please specify an alternate MassDetection (i.e. not 5 to 1250 Gram/Mole), MassDetectionStepSize (i.e. not 0.1 Gram/Mole), or ScanTime (i.e. not 0.5 Second) for: `1`.";

(* ::Subsubsection:: *)
(*ExperimentLCMS main function*)


ExperimentLCMS[mySamples:ListableP[ObjectP[Object[Sample]]],myOptions:OptionsPattern[]]:=Module[
	{listedOptions, outputSpecification, output, gatherTestsQ, cache, validSamplePreparationResult,
		mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,modelMoleculeObjects,
		safeOps,safeOpsTests,validLengths,validLengthTests,templatedOptions,templateTests,download,
		inheritedOptions, expandedSafeOps, hplcInstrumentFields, msInstrumentFields, modelHPLCInstrumentFields,
		modelMSInstrumentFields, columnFields, modelColumnFields,cartridgeFields, modelCartridgeFields, gradientFields,
		massSpectrometryMethodFields, objectSampleFields, modelSampleFields, objectContainerFields, modelContainerFields,
		sampleFields, modelContainerFieldsPacket,optionsWithObjects,availableHPLCInstrumentObjects,availableHPLCInstrumentModels,
		availableMSInstruments, allObjects,sampleObjects, modelContainerObjects, hplcInstrumentObjects, modelHPLCInstrumentObjects,
		msInstrumentObjects, modelMSInstrumentObjects, columnObjects, modelColumnObjects, gradientObjects, msMethodObjects,
		cartridgeObjects, modelCartridgeObjects,cacheBall, resolvedOptionsResult, collapsedResolvedOptions, protocolObject,
		resolvedOptions,resolvedOptionsTests, sampleIdentityModelFields,modelMoleculeFieldsPacket,identityModelFieldsPacketForm,
		identityModelObjects, resourcePackets,resourcePacketTests,listedSamples, mySamplesWithPreparedSamplesNamed, safeOpsNamed,
		myOptionsWithPreparedSamplesNamed, updatedSimulation},

	(* Make sure we're working with a list of options *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTestsQ=MemberQ[output,Tests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myOptions], Cache, {}];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed,myOptionsWithPreparedSamplesNamed,updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentLCMS,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed,safeOpsTests}=If[gatherTestsQ,
		SafeOptions[ExperimentLCMS,myOptionsWithPreparedSamplesNamed,AutoCorrect->False,Output->{Result,Tests}],
		{SafeOptions[ExperimentLCMS,myOptionsWithPreparedSamplesNamed,AutoCorrect->False],{}}
	];

	(* Sanitize named inputs *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, Simulation -> updatedSimulation];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengths,validLengthTests}=If[gatherTestsQ,
		ValidInputLengthsQ[ExperimentLCMS,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ValidInputLengthsQ[ExperimentLCMS,{mySamplesWithPreparedSamples},myOptionsWithPreparedSamples],Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengths,
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions,templateTests}=If[gatherTestsQ,
		ApplyTemplateOptions[ExperimentLCMS,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples,Output->{Result,Tests}],
		{ApplyTemplateOptions[ExperimentLCMS,{ToList[mySamplesWithPreparedSamples]},myOptionsWithPreparedSamples],Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests -> Join[safeOpsTests,validLengthTests,templateTests],
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions=ReplaceRule[safeOps,templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps=Last[ExpandIndexMatchedInputs[ExperimentLCMS, {ToList[mySamplesWithPreparedSamples]}, inheritedOptions]];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)

	(* Fields to download from any instrument objects *)
	hplcInstrumentFields = {
		Packet[Model, Status, MinColumnTemperature, MaxColumnTemperature, Site],
		Packet[Model[{
			Name,
			AutosamplerDeckModel,
			MinAcceleration,
			MaxAcceleration,
			MinAbsorbanceWavelength,
			MaxAbsorbanceWavelength,
			TubingMaxPressure,
			PumpMaxPressure,
			MaxColumnLength,
			PumpType,
			NumberOfBuffers,
			SystemPrimeGradients,
			SystemFlushGradients,
			MinFlowRate,
			MaxFlowRate,
			MinSampleVolume,
			RecommendedSampleVolume,
			MaxSampleVolume,
			MinSampleTemperature,
			MaxSampleTemperature,
			MinColumnTemperature,
			MaxColumnTemperature,
			WashSolution,
			SampleLoop,
			Detectors,
			FractionCollectionDetectors,
			Manufacturer,
			Deprecated,
			WettedMaterials,
			MaxNumberOfColumns,
			Positions,
			ColumnPreheater,
			Scale
		}]],
		Packet[Model[Field[SystemPrimeGradients[[All, 2]]][{Gradient, BufferA, BufferB, BufferC, BufferD, RefractiveIndexReferenceLoading}]]],
		Packet[Model[Field[SystemFlushGradients[[All, 2]]][{Gradient, BufferA, BufferB, BufferC, BufferD, RefractiveIndexReferenceLoading}]]],
		Packet[Model[Field[AutosamplerDeckModel]][{Positions}]]
	};

	msInstrumentFields = {
		Packet[Model,Status,MinColumnTemperature,MaxColumnTemperature],
		Packet[Model[{
			IonSources, MassAnalyzer, Detectors, Objects
		}]]
	};

	(* Fields to download from any model instrument objects *)
	modelHPLCInstrumentFields = {
		Packet[
			Name,
			AutosamplerDeckModel,
			MinAcceleration,
			MaxAcceleration,
			MinAbsorbanceWavelength,
			MaxAbsorbanceWavelength,
			MinEmissionWavelength,
			MaxEmissionWavelength,
			MinExcitationWavelength,
			MaxExcitationWavelength,
			TubingMaxPressure,
			PumpMaxPressure,
			MaxColumnLength,
			PumpType,
			NumberOfBuffers,
			SystemPrimeGradients,
			SystemFlushGradients,
			MinFlowRate,
			MaxFlowRate,
			MinSampleVolume,
			RecommendedSampleVolume,
			MaxSampleVolume,
			MinSampleTemperature,
			MaxSampleTemperature,
			MinColumnTemperature,
			MaxColumnTemperature,
			WashSolution,
			SampleLoop,
			Detectors,
			FractionCollectionDetectors,
			Manufacturer,
			Deprecated,
			WettedMaterials,
			MaxNumberOfColumns,
			Positions,
			ColumnPreheater
		],
		Packet[Field[SystemPrimeGradients[[All, 2]]][{Gradient, BufferA, BufferB, BufferC, BufferD, RefractiveIndexReferenceLoading}]],
		Packet[Field[SystemFlushGradients[[All, 2]]][{Gradient, BufferA, BufferB, BufferC, BufferD, RefractiveIndexReferenceLoading}]],
		Packet[Field[AutosamplerDeckModel][{Positions}]]
	};

	modelMSInstrumentFields={Packet[IonSources,MassAnalyzer,Detectors,Objects]};

	(* Fields to download from any column objects *)
	columnFields = {
		Packet[Model],
		Packet[Model[{SeparationMode,ChromatographyType,MaxAcceleration,MinFlowRate,MaxFlowRate,MaxPressure,PreferredGuardColumn,PreferredColumnJoin,MinTemperature,MaxTemperature,PreferredGuardCartridge,Dimensions,Diameter}]],
		Packet[Model[PreferredGuardColumn][{SeparationMode, ChromatographyType, MaxAcceleration, MinFlowRate, MaxFlowRate, MaxPressure, PreferredGuardColumn, PreferredColumnJoin, MinTemperature, MaxTemperature, PreferredGuardCartridge,Dimensions,Diameter}]]
	};

	(* Fields to download from any column model objects *)
	modelColumnFields = {
		Packet[SeparationMode,ChromatographyType,MaxAcceleration,MinFlowRate,MaxFlowRate,MaxPressure,PreferredGuardColumn,PreferredColumnJoin,MinTemperature,MaxTemperature,PreferredGuardCartridge,Dimensions,Diameter],
		Packet[PreferredGuardColumn[{SeparationMode,ChromatographyType,MaxAcceleration,MinFlowRate,MaxFlowRate,MaxPressure,PreferredGuardColumn,PreferredColumnJoin,MinTemperature,MaxTemperature,PreferredGuardCartridge,Dimensions,Diameter}]]};

	(* Fields to download from any cartridge objects *)
	cartridgeFields = {
		Packet[Model],
		Packet[Model[{PreferredGuardColumn, MaxPressure}]],
		Packet[Model[PreferredGuardColumn][{SeparationMode,ChromatographyType,MaxAcceleration,MinFlowRate,MaxFlowRate,MaxPressure,PreferredGuardColumn,PreferredColumnJoin,MinTemperature,MaxTemperature}]]
	};

	(* Fields to download from any cartridge model objects *)
	modelCartridgeFields = {
		Packet[PreferredGuardColumn,MaxPressure],
		Packet[PreferredGuardColumn[{SeparationMode,ChromatographyType,MaxAcceleration,MinFlowRate,MaxFlowRate,MaxPressure,PreferredGuardColumn,PreferredColumnJoin,MinTemperature,MaxTemperature}]]};

	(* Set fields to download from gradient objects *)
	gradientFields = {Packet[BufferA,BufferB,BufferC,BufferD,Gradient,RefractiveIndexReferenceLoading,Temperature]};

	(* Set fields to download from mass spectrometry method *)
	massSpectrometryMethodFields={Packet[MassAnalyzer,IonSource,IonMode,Calibrant,AcquisitionWindows,
		AcquisitionModes,Fragmentations,MinMasses,MaxMasses,MassSelections,ScanTimes,FragmentMinMasses,
		FragmentMaxMasses,FragmentMassSelections,CollisionEnergies,LowCollisionEnergies,HighCollisionEnergies,
		FinalLowCollisionEnergies,FinalHighCollisionEnergies,
		FragmentScanTimes,AcquisitionSurveys,MinimumThresholds,AcquisitionLimits,CycleTimeLimits,ExclusionDomains,ExclusionMasses,
		ExclusionMassTolerances,ExclusionRetentionTimeTolerances,InclusionDomains, InclusionMasses,InclusionCollisionEnergies,
		InclusionDeclusteringVoltages, InclusionChargeStates, InclusionScanTimes,InclusionMassTolerances,IsotopeExclusionModes,
		ChargeStateSelections,ChargeStateLimits,ChargeStateMassTolerances,ChargeStateMassWindows,IsotopeMassDifferences,
		IsotopeRatios,IsotopeDetectionMinimums,IsotopeRatioTolerances,IsotopeMassTolerances,
		ESICapillaryVoltage,DesolvationTemperature,DesolvationGasFlow,SourceTemperature,DeclusteringVoltage,ConeGasFlow,StepwaveVoltage,
		IonGuideVoltage, SecondCalibrant, CollisionCellExitVoltages, DwellTimes, MassDetectionStepSizes, MultipleReactionMonitoringAssays, NeutralLosses
	]};

	(*define all the fields that we want*)
	objectSampleFields=Union[SamplePreparationCacheFields[Object[Sample]],{Analytes,Density,LightSensitive,State,IncompatibleMaterials}];
	modelSampleFields=Union[SamplePreparationCacheFields[Model[Sample]],{pH,Conductivity,IncompatibleMaterials}];
	sampleIdentityModelFields = {pKa,Acid,Base,Molecule,MolecularWeight,StandardComponents,PolymerType, FluorescenceEmissionMaximums, ExtinctionCoefficients};
	objectContainerFields=Union[SamplePreparationCacheFields[Object[Container]]];
	modelContainerFields=Union[{MaxVolume,MinVolume,DefaultStorageCondition,NumberOfPositions},SamplePreparationCacheFields[Model[Container]]];

	(* Set fields to download from mySamples *)
	sampleFields = {
		Packet[Sequence@@objectSampleFields],
		Packet[Model[modelSampleFields]],
		Packet[Analytes[sampleIdentityModelFields]],
		Packet[Field[Composition[[All, 2]]][sampleIdentityModelFields]],
		Packet[Container[objectContainerFields]],
		Packet[Container[Model][modelContainerFields]]
	};

	(* Set fields for any model molecules *)
	modelMoleculeFieldsPacket ={Packet[Sequence@@sampleIdentityModelFields]};

	(* Container Model fields to download *)
	modelContainerFieldsPacket = {Packet[Sequence@@modelContainerFields]};

	(*Identity Model field sto download*)
	identityModelFieldsPacketForm={Packet[Sequence@@sampleIdentityModelFields]};

	(* Any options whose values _could_ be an object *)
	optionsWithObjects = {
		MassSpectrometerInstrument,
		ChromatographyInstrument,
		Column,
		SecondaryColumn,
		TertiaryColumn,
		GuardColumn,
		BufferA,
		BufferB,
		BufferC,
		BufferD,
		NeedleWashSolution,
		Gradient,
		MassSpectrometryMethod,
		Calibrant,
		Standard,
		StandardMassSpectrometryMethod,
		Blank,
		BlankMassSpectrometryMethod,
		ColumnPrimeMassSpectrometryMethod,
		ColumnFlushMassSpectrometryMethod,
		StandardGradient,
		BlankGradient,
		ColumnPrimeGradient,
		ColumnFlushGradient,
		InjectionTable,
		ColumnSelector,
		Analytes,
		StandardAnalytes,
		BlankAnalytes
	};

	(*define the instruments available for this experiment*)
	(* NOTE: not all of these LCs are actually available to use with LCMS. We just need to pass cache to ExperimentHPLC's resolver *)
	(* All the instruments to download and possibly use from memoization *)
	availableHPLCInstrumentModels = allHPLCInstrumentSearch["Memoization"][[1]];
	availableHPLCInstrumentObjects = Join[
		allECL2HPLCInstrumentObjectsSearch["Memoization"],
		allECLCMUHPLCInstrumentObjectsSearch["Memoization"]
	];

	availableMSInstruments={Model[Instrument, MassSpectrometer, "id:aXRlGn6KaWdO"] (*"Xevo G2-XS QTOF"*),Model[Instrument, MassSpectrometer, "id:N80DNj1aROOD"] (*"QTRAP 6500"*)};

	(* Flatten and merge all possible objects needed into a list *)
	allObjects = DeleteDuplicates@Download[
		Cases[
			Flatten@Join[
				mySamplesWithPreparedSamples,
				(* Default objects *)
				{
					$DefaultHPLCColumns,
					(* Plate for samples *)
					Model[Container, Plate, "96-well 2mL Deep Well Plate"],
					(* Vials used for standards *)
					Model[Container, Vessel, "1mL HPLC Vial (total recovery)"],
					Model[Container, Vessel, "HPLC vial (high recovery)"],
					Model[Container, Vessel, "HPLC vial (flat bottom)"],
					Model[Container, Vessel, "Amber HPLC vial (high recovery)"],
					Model[Container, Vessel, "HPLC vial (high recovery), LCMS Certified"],
					Model[Container, Vessel, "HPLC vial (high recovery) - Deactivated Clear Glass"],
					(* These are only used in prep HPLC but we would like to pass in the cache when calling ExperimentHPLC *)
					Model[Container, Vessel, "15mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "15mL Light Sensitive Centrifuge Tube"],
					Model[Container, Vessel, "50mL Light Sensitive Centrifuge Tube"],
					(* Instruments *)
					availableHPLCInstrumentObjects,
					availableHPLCInstrumentModels,
					availableMSInstruments,
					(* Autosampler Racks *)
					Model[Container, Rack, "HPLC Vial Rack"],
					Model[Container, Rack, "Waters Acquity UPLC Autosampler Rack"],
					(* These are only used in prep HPLC but we would like to pass in the cache when calling ExperimentHPLC *)
					Experiment`Private`$SmallAgilentHPLCAutosamplerRack,
					Experiment`Private`$LargeAgilentHPLCAutosamplerRack,
					(* Default Buffers *)
					Model[Sample,StockSolution,"id:9RdZXvKBeEbJ"],
					Model[Sample,StockSolution,"id:Vrbp1jG80zwE"],
					Model[Sample,StockSolution,"id:8qZ1VWNmdLbb"],
					Model[Sample,StockSolution,"id:eGakld01zKqx"],
					Model[Sample,"id:8qZ1VWNmdLBD"],
					Model[Sample,"id:O81aEB4kJXr1"],
					Model[Sample, StockSolution, "id:AEqRl9KNxZPp"]
				},
				(* All options that _could_ have an object *)
				Lookup[expandedSafeOps,optionsWithObjects]
			],
			ObjectP[]
		],
		Object
	];

	(* Isolate objects of particular types so we can build a indexed-download call *)
	sampleObjects = Cases[allObjects,NonSelfContainedSampleP];
	modelContainerObjects = Cases[allObjects,ObjectP[Model[Container]]];
	modelMoleculeObjects = Cases[allObjects,ObjectP[Model[Molecule]]];
	hplcInstrumentObjects = Cases[allObjects,ObjectP[Object[Instrument,HPLC]]];
	modelHPLCInstrumentObjects = Cases[allObjects,ObjectP[Model[Instrument,HPLC]]];
	msInstrumentObjects = Cases[allObjects,ObjectP[Object[Instrument,MassSpectrometer]]];
	modelMSInstrumentObjects = Cases[allObjects,ObjectP[Model[Instrument,MassSpectrometer]]];
	columnObjects = Cases[allObjects,ObjectP[Object[Item,Column]]];
	modelColumnObjects = Cases[allObjects,ObjectP[Model[Item,Column]]];
	gradientObjects = Cases[allObjects,ObjectP[Object[Method,Gradient]]];
	msMethodObjects = Cases[allObjects,ObjectP[Object[Method,MassAcquisition]]];
	cartridgeObjects = Cases[allObjects,ObjectP[Object[Item, Cartridge, Column]]];
	modelCartridgeObjects = Cases[allObjects,ObjectP[Model[Item, Cartridge, Column]]];
	identityModelObjects = Cases[allObjects,IdentityModelP];

	(*perform our download for everything needed*)
	download=Quiet[Download[
		{
			sampleObjects,
			modelMoleculeObjects,
			modelContainerObjects,
			hplcInstrumentObjects,
			modelHPLCInstrumentObjects,
			msInstrumentObjects,
			modelMSInstrumentObjects,
			columnObjects,
			modelColumnObjects,
			gradientObjects,
			msMethodObjects,
			cartridgeObjects,
			modelCartridgeObjects,
			identityModelObjects
		},
		{
			sampleFields,
			modelMoleculeFieldsPacket,
			modelContainerFieldsPacket,
			hplcInstrumentFields,
			modelHPLCInstrumentFields,
			msInstrumentFields,
			modelMSInstrumentFields,
			columnFields,
			modelColumnFields,
			gradientFields,
			massSpectrometryMethodFields,
			cartridgeFields,
			modelCartridgeFields,
			identityModelFieldsPacketForm
		},
		Cache->cache,
		Simulation -> updatedSimulation,
		Date->Now
	],{Download::FieldDoesntExist}];

	cacheBall = DeleteCases[
		FlattenCachePackets[
			{
				cache,
				download
			}
		],
		Null
	];

	(* Build the resolved options *)
	resolvedOptionsResult=If[gatherTestsQ,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions,resolvedOptionsTests}=resolveExperimentLCMSOptions[ToList[mySamplesWithPreparedSamples],expandedSafeOps,Cache->cacheBall, Simulation -> updatedSimulation,Output->{Result,Tests}];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->resolvedOptionsTests|>,OutputFormat->SingleBoolean,Verbose->False],
			{resolvedOptions,resolvedOptionsTests},
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions,resolvedOptionsTests}={resolveExperimentLCMSOptions[ToList[mySamplesWithPreparedSamples],expandedSafeOps,Cache->cacheBall, Simulation -> updatedSimulation],{}},
			$Failed,
			{Error::InvalidInput,Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentLCMS,
		resolvedOptions,
		Ignore->myOptionsWithPreparedSamples,
		Messages->False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult,$Failed],
		Return[outputSpecification/.{
			Result -> $Failed,
			Tests->Join[safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests],
			Options->RemoveHiddenOptions[ExperimentLCMS,collapsedResolvedOptions],
			Preview->Null,
			Simulation -> updatedSimulation
		}]
	];
	
	
	(* Build packets with resources *)
	{resourcePackets,resourcePacketTests} = If[gatherTestsQ,
		LCMSResourcePackets[ToList[mySamplesWithPreparedSamples],templatedOptions,resolvedOptions,Cache->cacheBall, Simulation -> updatedSimulation,Output->{Result,Tests}],
		{LCMSResourcePackets[ToList[mySamplesWithPreparedSamples],templatedOptions,resolvedOptions,Cache->cacheBall, Simulation -> updatedSimulation],{}}
	];

	(* If we don't have to return the Result, don't bother calling UploadProtocol[...]. *)
	If[!MemberQ[output,Result],
		Return[outputSpecification/.{
			Result -> Null,
			Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
			Options -> RemoveHiddenOptions[ExperimentLCMS,collapsedResolvedOptions],
			Preview -> Null,
			Simulation -> updatedSimulation
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	
	protocolObject = If[!MatchQ[resourcePackets,$Failed]&&!MatchQ[resolvedOptionsResult,$Failed],
		(*if we need to also upload accessory packets*)
		If[Length[resourcePackets]>1,
			UploadProtocol[
				First[resourcePackets],
				Rest[resourcePackets],
				Upload->Lookup[safeOps,Upload],
				Confirm->Lookup[safeOps,Confirm],
				CanaryBranch->Lookup[safeOps,CanaryBranch],
				ParentProtocol->Lookup[safeOps,ParentProtocol],
				Priority->Lookup[safeOps,Priority],
				StartDate->Lookup[safeOps,StartDate],
				HoldOrder->Lookup[safeOps,HoldOrder],
				QueuePosition->Lookup[safeOps,QueuePosition],
				ConstellationMessage->Object[Protocol,LCMS],
				Cache->cache,
				Simulation -> updatedSimulation
			],
			(*otherwise just protocol packet*)
			UploadProtocol[
				First[resourcePackets],
				Upload->Lookup[safeOps,Upload],
				Confirm->Lookup[safeOps,Confirm],
				CanaryBranch->Lookup[safeOps,CanaryBranch],
				ParentProtocol->Lookup[safeOps,ParentProtocol],
				Priority->Lookup[safeOps,Priority],
				StartDate->Lookup[safeOps,StartDate],
				HoldOrder->Lookup[safeOps,HoldOrder],
				QueuePosition->Lookup[safeOps,QueuePosition],
				ConstellationMessage->Object[Protocol,LCMS],
				Cache->cache,
				Simulation -> updatedSimulation
			]
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests,validLengthTests,templateTests,resolvedOptionsTests,resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentLCMS,collapsedResolvedOptions],
		Preview -> Null,
		Simulation -> updatedSimulation
	}
];

(*container overload*)
ExperimentLCMS[myContainers:ListableP[ObjectP[{Object[Container],Object[Sample],Model[Sample]}]|_String|{LocationPositionP,_String|ObjectP[Object[Container]]}],myOptions:OptionsPattern[]]:=Module[
	{outputSpecification,output,gatherTests,validSamplePreparationResult,mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,
		updatedSimulation,containerToSampleResult,containerToSampleOutput,samples,sampleOptions,
		containerToSampleTests,containerToSampleSimulation},

	(* Determine the requested return value from the function *)
	outputSpecification=Quiet[OptionValue[Output]];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTests=MemberQ[output,Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult=Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples,myOptionsWithPreparedSamples,updatedSimulation}=simulateSamplePreparationPacketsNew[
			ExperimentLCMS,
			ToList[myContainers],
			ToList[myOptions],
			DefaultPreparedModelContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
		],
		$Failed,
		{Download::ObjectDoesNotExist, Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult,$Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult=If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput,containerToSampleTests, containerToSampleSimulation}=containerToSampleOptions[
			ExperimentLCMS,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output->{Result,Tests,Simulation},
			Simulation -> updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests"->containerToSampleTests|>,OutputFormat->SingleBoolean,Verbose->False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
				ExperimentLCMS,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output-> {Result, Simulation},
				Simulation -> updatedSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult,$Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification/.{
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null
		},
		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples, sampleOptions} = containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentLCMS[samples, ReplaceRule[sampleOptions,Simulation -> containerToSampleSimulation]]
	]
];

DefineOptions[
	resolveExperimentLCMSOptions,
	Options:>{SimulationOption, HelperOutputOption,CacheOption}
];

resolveExperimentLCMSOptions[mySamples:{ObjectP[Object[Sample]]...},myOptions:{_Rule...},myResolutionOptions:OptionsPattern[resolveExperimentLCMSOptions]]:=Module[
	{outputSpecification, output, gatherTestsQ, cache, samplePrepOptions, lcmsOptions,hplcOptionRulesWithFrequencies,
		simulatedSamples,simulationFastAssoc, messagesQ, engineQ,hplcOptions,blankOptions, standardOptions,
		lcmsOptionsAssociation,resolvedExperimentOptions, invalidInputs, invalidOptions,simulatedSampleIdentityModelFields,
		allTests, resolvedPostProcessingOptions, hplcResolvedOptions, resolvedOptions, hplcInvalidInputs, hplcInvalidOptions, hplcTests,
		roundedOptionsAssociation,userHPLCOptions, initialHPLCOptionsRule, hplcOptionsRuleWithInstrument,
		injectionTableSpecification, injectionTableSpecifiedQ,injectionTableHPLCFormat, transposedInjectionTable,
		injectionTableOmitMSMethod, injectionTableWithColumnAutomatics, hplcOptionsWithInjectionTable,
		relevantResolvedHPLCOptions, replacedHPLCOptions,
		columnSelectorSpecifiedQ, columnSelectorHPLCFormat, specifiedColumnSelector, columnSelectorWithHPLCKeys,
		hplcOptionsRuleWithColumns,
		chromatographyInstrumentModel, suppliedMassSpecModel, availableChromatographyInstrumentModels, availableMassSpecInstrumentModels,
		unavailableMassSpecOptions, unavailableMassSpecTest, unavailableLCOptions, unavailableLCTest, someRelevantResolvedHPLCOptions,
		columnOptionsToSingleton, columnOptionValuesFromHPLC, columnOptionsValuesSingleton, columnOptionSingleAssociation,updatedColumnSelector,
		massRelatedOptions, tenthVoltRelatedOptions, milliSecondOptions, secondOptions, hundrethsPlaceOptions,
		perSecondOptions, percentOptions, hundredVoltOptions, temperatureOptions, literPerHourOptions,
		optionsForRounding, valuesToRoundTo, nonSpecialRoundedOptions, nonSpecialRoundingTests,unitPatternDepth3Extractor,resolveMassSpecAnalytes,
		getExpandedDimensionsDepth3Columns,injectionTableTypes, blanksExistQ, blankFrequencyOptionRule, standardExistQ, standardFrequencyOptionRule,
		simulatedSamplePackets,simulatedSampleIdentityModelPackets,resolvedAnalytes, validAnalytes, filteredAnalytePackets, sampleCategories,
		sampleMolecularWeights, calibrantLookup, firstSampleCategory, firstIonMode, resolvedCalibrant,
		hplcInjectionTable, transposedHPLCInjectionTable, hplcInjectionTableColumnsRemoved, massSpecMethodsFromInjectionTable, samplePositions,
		standardPositions, blankPositions, columnFlushPositions, columnPrimePositions, sampleMassSpecMethodsFromIT, preresolvedStandard,
		preresolvedBlank, expandedStandardOptions, expandedStandardOptionsPreCheck, expandedBlankOptions, expandedBlankOptionsPreCheck,
		unexpandKeyValuePairs, standardMassSpecMethodsFromIT, blankMassSpecMethodsFromIT,
		columnFlushMassSpecMethodsFromIT, columnPrimeMassSpecMethodsFromIT, massSpecMethodSampleLookup, columnPrimeMassSpecMethodSampleLookup,
		columnFlushMassSpecMethodSampleLookup, standardMassSpecMethodSampleLookup, blankMassSpecMethodSampleLookup, bestSamplesMassSpecMethods,
		massSpecMethodConflictSamplesBool,resolvedStandard, resolvedBlank, standardPositionsAll, blankPositionsAll, columnFlushPositionsAll,
		columnPrimePositionsAll,columnFlushQ, columnPrimeQ,bestStandardsMassSpecMethods,massSpecMethodConflictStandardsBool,
		bestBlanksMassSpecMethods,massSpecMethodConflictBlanksBool, bestColumnPrimeMassSpecMethods,massSpecMethodConflictColumnPrimeBool,
		bestColumnFlushMassSpecMethods,massSpecMethodConflictColumnFlushBool, columnPrimeOptions, columnFlushOptions,
		columnFlushSpecificationBool, conflictingColumnFlushOptions, conflictingColumnFlushTest, columnPrimeSpecificationBool,
		conflictingColumnPrimeOptions, conflictingColumnPrimeTest, inclusionDomainOptions, exclusionDomainOptions,
		isotopicExclusionOptions, firstPatternForDepthFour, inclusionDomainPositioning,
		inclusionMassPositioning, inclusionCollisionEnergyPositioning, inclusionDeclusteringVoltagePositioning, inclusionChargeStatePositioning,
		inclusionScanTimePositioning, optionDefinition, unitPattern, inclusionDomainAutomatics, inclusionMassAutomatics, inclusionCollisionEnergyAutomatics,
		inclusionDeclusteringVoltageAutomatics, inclusionChargeStateAutomatics, inclusionScanTimeAutomatics, inclusionDomainInitialExpansion,
		inclusionMassInitialExpansion, inclusionCollisionEnergyInitialExpansion, inclusionDeclusteringVoltageInitialExpansion,
		inclusionChargeStateInitialExpansion, inclusionScanTimeInitialExpansion,noNullExtractorDepth3, withNullExtractorDepth3,
		acquisitionModeIndexMatchedOptions,expandedAcquisitionModeOptions, expandedDimensions, maxDimension,
		combinedTuples, paddedDimensions, exclusionDomainPositioning, exclusionMassPositioning,
		isotopicExclusionPositioning, isotopeRatioThresholdPositioning, isotopeDetectionMinimumPositioning,
		exclusionDomainAutomatics, exclusionMassAutomatics, isotopicExclusionAutomatics, isotopeRatioThresholdAutomatics,
		isotopeDetectionMinimumAutomatics, expandedDimensionsInclusion, expandedDimensionsExclusion, expandedDimensionsIsotope,
		maxExpansionConfigurationInclusion, maxExpansionConfigurationExclusion, maxExpansionConfigurationIsotope, initialExpansion,
		exclusionDomainInitialExpansion, exclusionMassInitialExpansion, isotopicExclusionInitialExpansion,
		isotopeRatioThresholdInitialExpansion, isotopeDetectionMinimumInitialExpansion, initialExpansionAssociation,
		matchedAcquisitionModeOptionsPositioning, matchedAcquisitionModeOptionsAutomatics, allowNullQ,
		resolvedIonModes, resolvedMassSpectrometryMethods, resolvedESICapillaryVoltages, resolvedDeclusteringVoltages, resolvedStepwaveVoltages,
		resolvedSourceTemperatures, resolvedDesolvationTemperatures, resolvedDesolvationGasFlows, resolvedConeGasFlows,
		relevantCases,methodDepthThreeFields, methodDepthFourFields, resolvedAcquisitionWindows, resolvedAcquisitionModes,
		resolvedFragments, resolvedMassDetections, resolvedScanTimes, resolvedFragmentMassDetections, resolvedCollisionEnergies,
		resolvedCollisionEnergyMassProfiles, resolvedCollisionEnergyMassScans, resolvedFragmentScanTimes, resolvedAcquisitionSurveys,
		resolvedMinimumThresholds, resolvedAcquisitionLimits, resolvedCycleTimeLimits, resolvedExclusionDomains, resolvedExclusionMasses,
		resolvedExclusionMassTolerances, resolvedExclusionRetentionTimeTolerances, resolvedInclusionDomains, resolvedInclusionMasses,
		resolvedInclusionCollisionEnergies, resolvedInclusionDeclusteringVoltages, resolvedInclusionChargeStates, resolvedInclusionScanTimes,
		resolvedInclusionMassTolerances, resolvedSurveyChargeStateExclusions, resolvedSurveyIsotopeExclusions,
		resolvedChargeStateExclusionLimits, resolvedChargeStateExclusions, resolvedChargeStateMassTolerances,
		resolvedIsotopicExclusions, resolvedIsotopeRatioThresholds, resolvedIsotopeDetectionMinimums,
		resolvedIsotopeMassTolerances, resolvedIsotopeRatioTolerances, fragmentModeConflictSampleBool,
		massDetectionConflictSampleBool, fragmentMassDetectionConflictSampleBool, collisionEnergyConflictSampleBool,
		collisionEnergyScanConflictSampleBool, fragmentScanTimeConflictSampleBool, acquisitionSurveyConflictSampleBool,
		acquisitionLimitConflictSampleBool, cycleTimeLimitConflictSampleBool, exclusionModeMassConflictSampleBool,
		exclusionMassToleranceConflictSampleBool, exclusionRetentionTimeToleranceConflictSampleBool, inclusionOptionsConflictSampleBool,
		inclusionMassToleranceConflictSampleBool, chargeStateExclusionLimitConflictSampleBool, chargeStateExclusionConflictSampleBool,
		chargeStateMassToleranceConflictSampleBool, isotopicExclusionLimitSampleBool, isotopicExclusionConflictSampleBool,
		isotopeMassToleranceConflictSampleBool, isotopeRatioToleranceConflictSampleBool,standardInclusionDomainOptions,
		standardExclusionDomainOptions, standardIsotopicExclusionOptions,blankInclusionDomainOptions,
		blankExclusionDomainOptions, blankIsotopicExclusionOptions, standardInclusionDomainPositioning, standardInclusionMassPositioning,
		standardInclusionCollisionEnergyPositioning, standardInclusionDeclusteringVoltagePositioning,
		standardInclusionChargeStatePositioning, standardInclusionScanTimePositioning, standardExclusionDomainPositioning,
		standardExclusionMassPositioning, standardIsotopicExclusionPositioning, standardIsotopeRatioThresholdPositioning,
		standardIsotopeDetectionMinimumPositioning, standardInclusionDomainAutomatics, standardInclusionMassAutomatics,
		standardInclusionCollisionEnergyAutomatics, standardInclusionDeclusteringVoltageAutomatics, standardInclusionChargeStateAutomatics,
		standardInclusionScanTimeAutomatics, standardExclusionDomainAutomatics, standardExclusionMassAutomatics,
		standardIsotopicExclusionAutomatics, standardIsotopeRatioThresholdAutomatics, standardIsotopeDetectionMinimumAutomatics,
		blankInclusionDomainPositioning, blankInclusionMassPositioning, blankInclusionCollisionEnergyPositioning,
		blankInclusionDeclusteringVoltagePositioning, blankInclusionChargeStatePositioning, blankInclusionScanTimePositioning,
		blankExclusionDomainPositioning, blankExclusionMassPositioning, blankIsotopicExclusionPositioning,
		blankIsotopeRatioThresholdPositioning, blankIsotopeDetectionMinimumPositioning, blankInclusionDomainAutomatics,
		blankInclusionMassAutomatics, blankInclusionCollisionEnergyAutomatics, blankInclusionDeclusteringVoltageAutomatics,
		blankInclusionChargeStateAutomatics, blankInclusionScanTimeAutomatics, blankExclusionDomainAutomatics,
		blankExclusionMassAutomatics, blankIsotopicExclusionAutomatics, blankIsotopeRatioThresholdAutomatics,
		blankIsotopeDetectionMinimumAutomatics,expandedStandardDimensionsInclusion, expandedStandardDimensionsExclusion,
		expandedStandardDimensionsIsotope, expandedBlankDimensionsInclusion, expandedBlankDimensionsExclusion,
		expandedBlankDimensionsIsotope,maxStandardExpansionConfigurationInclusion, maxStandardExpansionConfigurationExclusion,
		maxStandardExpansionConfigurationIsotope, maxBlankExpansionConfigurationInclusion, maxBlankExpansionConfigurationExclusion,
		maxBlankExpansionConfigurationIsotope,combinedOptionsAssociation, getExpandedDimensions,performDepth4Expansion,
		findMaximumDepth4Dimensions, standardInclusionDomainInitialExpansion, standardInclusionMassInitialExpansion,
		standardInclusionCollisionEnergyInitialExpansion, standardInclusionDeclusteringVoltageInitialExpansion, standardInclusionChargeStateInitialExpansion,
		standardInclusionScanTimeInitialExpansion, standardExclusionDomainInitialExpansion, standardExclusionMassInitialExpansion,
		standardIsotopicExclusionInitialExpansion, standardIsotopeRatioThresholdInitialExpansion, standardIsotopeDetectionMinimumInitialExpansion,
		blankInclusionDomainInitialExpansion, blankInclusionMassInitialExpansion, blankInclusionCollisionEnergyInitialExpansion,
		blankInclusionDeclusteringVoltageInitialExpansion, blankInclusionChargeStateInitialExpansion, blankInclusionScanTimeInitialExpansion,
		blankExclusionDomainInitialExpansion, blankExclusionMassInitialExpansion, blankIsotopicExclusionInitialExpansion,
		blankIsotopeRatioThresholdInitialExpansion, blankIsotopeDetectionMinimumInitialExpansion,standardAcquisitionModeIndexMatchedOptions,
		blankAcquisitionModeIndexMatchedOptions,matchedStandardAcquisitionModeOptionsPositioning,
		matchedStandardAcquisitionModeOptionsAutomatics,matchedBlankAcquisitionModeOptionsPositioning,
		matchedBlankAcquisitionModeOptionsAutomatics,getExpandedDimensionsDepth3,performDepth3Expansion,
		expandedStandardAcquisitionModeOptions, expandedBlankAcquisitionModeOptions,filterAnalytesFunction,
		resolveAnalytesFunction,resolvedFilteredAnalytes,getSampleCategoriesFunction,unitPatternDepth4Extractor,
		standardPackets, standardIdentityModelPackets, resolvedStandardAnalytes, standardAnalytePackets,
		standardCategories, standardMolecularWeights, blankPackets, blankIdentityModelPackets,
		resolvedBlankAnalytes, blankAnalytePackets, blankCategories, blankMolecularWeights,performDepth3ExpansionColumns,
		existsQ,passedOptions,resolvedStandardIonModes, resolvedStandardMassSpectrometryMethods, resolvedStandardESICapillaryVoltages,
		resolvedStandardDeclusteringVoltages, resolvedStandardStepwaveVoltages, resolvedStandardSourceTemperatures,
		resolvedStandardDesolvationTemperatures, resolvedStandardDesolvationGasFlows, resolvedStandardConeGasFlows,
		resolvedStandardAcquisitionWindows, resolvedStandardAcquisitionModes, resolvedStandardFragments,
		resolvedStandardMassDetections, resolvedStandardScanTimes, resolvedStandardFragmentMassDetections,
		resolvedStandardCollisionEnergies, resolvedStandardCollisionEnergyMassProfiles, resolvedStandardCollisionEnergyMassScans,
		resolvedStandardFragmentScanTimes, resolvedStandardAcquisitionSurveys, resolvedStandardMinimumThresholds,
		resolvedStandardAcquisitionLimits, resolvedStandardCycleTimeLimits, resolvedStandardExclusionDomains,
		resolvedStandardExclusionMasses, resolvedStandardExclusionMassTolerances, resolvedStandardExclusionRetentionTimeTolerances,
		resolvedStandardInclusionDomains, resolvedStandardInclusionMasses, resolvedStandardInclusionCollisionEnergies,
		resolvedStandardInclusionDeclusteringVoltages, resolvedStandardInclusionChargeStates, resolvedStandardInclusionScanTimes,
		resolvedStandardInclusionMassTolerances, resolvedStandardSurveyChargeStateExclusions, resolvedStandardSurveyIsotopeExclusions,
		resolvedStandardChargeStateExclusionLimits, resolvedStandardChargeStateExclusions, resolvedStandardChargeStateMassTolerances,
		resolvedStandardIsotopicExclusions, resolvedStandardIsotopeRatioThresholds, resolvedStandardIsotopeDetectionMinimums,
		resolvedStandardIsotopeMassTolerances, resolvedStandardIsotopeRatioTolerances, fragmentModeConflictStandardBool,
		massDetectionConflictStandardBool, fragmentMassDetectionConflictStandardBool, collisionEnergyConflictStandardBool,
		collisionEnergyScanConflictStandardBool, fragmentScanTimeConflictStandardBool, acquisitionSurveyConflictStandardBool,
		acquisitionLimitConflictStandardBool, cycleTimeLimitConflictStandardBool, exclusionModeMassConflictStandardBool,
		exclusionMassToleranceConflictStandardBool, exclusionRetentionTimeToleranceConflictStandardBool, inclusionOptionsConflictStandardBool,
		inclusionMassToleranceConflictStandardBool, chargeStateExclusionLimitConflictStandardBool, chargeStateExclusionConflictStandardBool,
		chargeStateMassToleranceConflictStandardBool, isotopicExclusionLimitStandardBool, isotopicExclusionConflictStandardBool,
		isotopeMassToleranceConflictStandardBool, isotopeRatioToleranceConflictStandardBool, resolvedBlankIonModes,
		resolvedBlankMassSpectrometryMethods, resolvedBlankESICapillaryVoltages, resolvedBlankDeclusteringVoltages,
		resolvedBlankStepwaveVoltages, resolvedBlankSourceTemperatures, resolvedBlankDesolvationTemperatures,
		resolvedBlankDesolvationGasFlows, resolvedBlankConeGasFlows, resolvedBlankAcquisitionWindows,
		resolvedBlankAcquisitionModes, resolvedBlankFragments, resolvedBlankMassDetections, resolvedBlankScanTimes,
		resolvedBlankFragmentMassDetections, resolvedBlankCollisionEnergies, resolvedBlankCollisionEnergyMassProfiles,
		resolvedBlankCollisionEnergyMassScans, resolvedBlankFragmentScanTimes, resolvedBlankAcquisitionSurveys,
		resolvedBlankMinimumThresholds, resolvedBlankAcquisitionLimits, resolvedBlankCycleTimeLimits,
		resolvedBlankExclusionDomains, resolvedBlankExclusionMasses, resolvedBlankExclusionMassTolerances,
		resolvedBlankExclusionRetentionTimeTolerances, resolvedBlankInclusionDomains, resolvedBlankInclusionMasses,
		resolvedBlankInclusionCollisionEnergies, resolvedBlankInclusionDeclusteringVoltages, resolvedBlankInclusionChargeStates,
		resolvedBlankInclusionScanTimes, resolvedBlankInclusionMassTolerances, resolvedBlankSurveyChargeStateExclusions,
		resolvedBlankSurveyIsotopeExclusions, resolvedBlankChargeStateExclusionLimits, resolvedBlankChargeStateExclusions,
		resolvedBlankChargeStateMassTolerances, resolvedBlankIsotopicExclusions, resolvedBlankIsotopeRatioThresholds,
		resolvedBlankIsotopeDetectionMinimums, resolvedBlankIsotopeMassTolerances, resolvedBlankIsotopeRatioTolerances,
		fragmentModeConflictBlankBool, massDetectionConflictBlankBool, fragmentMassDetectionConflictBlankBool,
		collisionEnergyConflictBlankBool, collisionEnergyScanConflictBlankBool, fragmentScanTimeConflictBlankBool,
		acquisitionSurveyConflictBlankBool, acquisitionLimitConflictBlankBool, cycleTimeLimitConflictBlankBool,
		exclusionModeMassConflictBlankBool, exclusionMassToleranceConflictBlankBool, exclusionRetentionTimeToleranceConflictBlankBool,
		inclusionOptionsConflictBlankBool, inclusionMassToleranceConflictBlankBool, chargeStateExclusionLimitConflictBlankBool,
		chargeStateExclusionConflictBlankBool, chargeStateMassToleranceConflictBlankBool, isotopicExclusionLimitBlankBool,
		isotopicExclusionConflictBlankBool, isotopeMassToleranceConflictBlankBool, isotopeRatioToleranceConflictBlankBool,
		columnPrimeAcquisitionWindowMatchedOptions,  columnFlushAcquisitionWindowMatchedOptions,
		columnPrimeInclusionDomainOptions, columnPrimeExclusionDomainOptions,
		columnPrimeIsotopicExclusionOptions,columnFlushInclusionDomainOptions, columnFlushExclusionDomainOptions,
		columnFlushIsotopicExclusionOptions, columnPrimeInclusionDomainPositioning, columnPrimeInclusionMassPositioning,
		columnPrimeInclusionCollisionEnergyPositioning, columnPrimeInclusionDeclusteringVoltagePositioning,
		columnPrimeInclusionChargeStatePositioning, columnPrimeInclusionScanTimePositioning,
		columnPrimeExclusionDomainPositioning, columnPrimeExclusionMassPositioning, columnPrimeIsotopicExclusionPositioning,
		columnPrimeIsotopeRatioThresholdPositioning, columnPrimeIsotopeDetectionMinimumPositioning, columnPrimeInclusionDomainAutomatics,
		columnPrimeInclusionMassAutomatics, columnPrimeInclusionCollisionEnergyAutomatics, columnPrimeInclusionDeclusteringVoltageAutomatics,
		columnPrimeInclusionChargeStateAutomatics, columnPrimeInclusionScanTimeAutomatics, columnPrimeExclusionDomainAutomatics,
		columnPrimeExclusionMassAutomatics, columnPrimeIsotopicExclusionAutomatics, columnPrimeIsotopeRatioThresholdAutomatics,
		columnPrimeIsotopeDetectionMinimumAutomatics,columnFlushInclusionDomainPositioning, columnFlushInclusionMassPositioning,
		columnFlushInclusionCollisionEnergyPositioning, columnFlushInclusionDeclusteringVoltagePositioning, columnFlushInclusionChargeStatePositioning,
		columnFlushInclusionScanTimePositioning, columnFlushExclusionDomainPositioning, columnFlushExclusionMassPositioning,
		columnFlushIsotopicExclusionPositioning, columnFlushIsotopeRatioThresholdPositioning, columnFlushIsotopeDetectionMinimumPositioning,
		columnFlushInclusionDomainAutomatics, columnFlushInclusionMassAutomatics, columnFlushInclusionCollisionEnergyAutomatics,
		columnFlushInclusionDeclusteringVoltageAutomatics, columnFlushInclusionChargeStateAutomatics, columnFlushInclusionScanTimeAutomatics,
		columnFlushExclusionDomainAutomatics, columnFlushExclusionMassAutomatics, columnFlushIsotopicExclusionAutomatics,
		columnFlushIsotopeRatioThresholdAutomatics, columnFlushIsotopeDetectionMinimumAutomatics,
		maxColumnPrimeExpansionInclusion, maxColumnPrimeExpansionExclusion, maxColumnPrimeExpansionIsotope,
		expandedColumnPrimeAcquisitionModeOptions,expandedColumnFlushAcquisitionModeOptions,
		maxColumnFlushExpansionInclusion, maxColumnFlushExpansionExclusion, maxColumnFlushExpansionIsotope,
		columnFlushPrimeDepth3ExpandedAssociation, resolvedColumnPrimeIonModes, resolvedColumnPrimeMassSpectrometryMethods,
		resolvedColumnPrimeESICapillaryVoltages, resolvedColumnPrimeDeclusteringVoltages, resolvedColumnPrimeStepwaveVoltages,
		resolvedColumnPrimeSourceTemperatures, resolvedColumnPrimeDesolvationTemperatures, resolvedColumnPrimeDesolvationGasFlows,
		resolvedColumnPrimeConeGasFlows, resolvedColumnPrimeAcquisitionWindows, resolvedColumnPrimeAcquisitionModes,
		resolvedColumnPrimeFragments, resolvedColumnPrimeMassDetections, resolvedColumnPrimeScanTimes,
		resolvedColumnPrimeFragmentMassDetections, resolvedColumnPrimeCollisionEnergies, resolvedColumnPrimeCollisionEnergyMassProfiles,
		resolvedColumnPrimeCollisionEnergyMassScans, resolvedColumnPrimeFragmentScanTimes, resolvedColumnPrimeAcquisitionSurveys,
		resolvedColumnPrimeMinimumThresholds, resolvedColumnPrimeAcquisitionLimits, resolvedColumnPrimeCycleTimeLimits,
		resolvedColumnPrimeExclusionDomains, resolvedColumnPrimeExclusionMasses, resolvedColumnPrimeExclusionMassTolerances,
		resolvedColumnPrimeExclusionRetentionTimeTolerances, resolvedColumnPrimeInclusionDomains, resolvedColumnPrimeInclusionMasses,
		resolvedColumnPrimeInclusionCollisionEnergies, resolvedColumnPrimeInclusionDeclusteringVoltages,
		resolvedColumnPrimeInclusionChargeStates, resolvedColumnPrimeInclusionScanTimes,
		resolvedColumnPrimeInclusionMassTolerances, resolvedColumnPrimeSurveyChargeStateExclusions,
		resolvedColumnPrimeSurveyIsotopeExclusions, resolvedColumnPrimeChargeStateExclusionLimits, resolvedColumnPrimeChargeStateExclusions,
		resolvedColumnPrimeChargeStateMassTolerances, resolvedColumnPrimeIsotopicExclusions, resolvedColumnPrimeIsotopeRatioThresholds,
		resolvedColumnPrimeIsotopeDetectionMinimums, resolvedColumnPrimeIsotopeMassTolerances, resolvedColumnPrimeIsotopeRatioTolerances,
		fragmentModeConflictColumnPrimeBool, massDetectionConflictColumnPrimeBool, fragmentMassDetectionConflictColumnPrimeBool,
		collisionEnergyConflictColumnPrimeBool, collisionEnergyScanConflictColumnPrimeBool, fragmentScanTimeConflictColumnPrimeBool,
		acquisitionSurveyConflictColumnPrimeBool, acquisitionLimitConflictColumnPrimeBool, cycleTimeLimitConflictColumnPrimeBool,
		exclusionModeMassConflictColumnPrimeBool, exclusionMassToleranceConflictColumnPrimeBool, exclusionRetentionTimeToleranceConflictColumnPrimeBool,
		inclusionOptionsConflictColumnPrimeBool, inclusionMassToleranceConflictColumnPrimeBool, chargeStateExclusionLimitConflictColumnPrimeBool,
		chargeStateExclusionConflictColumnPrimeBool, chargeStateMassToleranceConflictColumnPrimeBool, isotopicExclusionLimitColumnPrimeBool,
		isotopicExclusionConflictColumnPrimeBool, isotopeMassToleranceConflictColumnPrimeBool, isotopeRatioToleranceConflictColumnPrimeBool,
		resolvedColumnFlushIonModes, resolvedColumnFlushMassSpectrometryMethods, resolvedColumnFlushESICapillaryVoltages,
		resolvedColumnFlushDeclusteringVoltages, resolvedColumnFlushStepwaveVoltages, resolvedColumnFlushSourceTemperatures,
		resolvedColumnFlushDesolvationTemperatures, resolvedColumnFlushDesolvationGasFlows, resolvedColumnFlushConeGasFlows,
		resolvedColumnFlushAcquisitionWindows, resolvedColumnFlushAcquisitionModes, resolvedColumnFlushFragments,
		resolvedColumnFlushMassDetections, resolvedColumnFlushScanTimes, resolvedColumnFlushFragmentMassDetections,
		resolvedColumnFlushCollisionEnergies, resolvedColumnFlushCollisionEnergyMassProfiles, resolvedColumnFlushCollisionEnergyMassScans,
		resolvedColumnFlushFragmentScanTimes, resolvedColumnFlushAcquisitionSurveys, resolvedColumnFlushMinimumThresholds,
		resolvedColumnFlushAcquisitionLimits, resolvedColumnFlushCycleTimeLimits, resolvedColumnFlushExclusionDomains,
		resolvedColumnFlushExclusionMasses, resolvedColumnFlushExclusionMassTolerances, resolvedColumnFlushExclusionRetentionTimeTolerances,
		resolvedColumnFlushInclusionDomains, resolvedColumnFlushInclusionMasses, resolvedColumnFlushInclusionCollisionEnergies,
		resolvedColumnFlushInclusionDeclusteringVoltages, resolvedColumnFlushInclusionChargeStates, resolvedColumnFlushInclusionScanTimes,
		resolvedColumnFlushInclusionMassTolerances, resolvedColumnFlushSurveyChargeStateExclusions, resolvedColumnFlushSurveyIsotopeExclusions,
		resolvedColumnFlushChargeStateExclusionLimits, resolvedColumnFlushChargeStateExclusions, resolvedColumnFlushChargeStateMassTolerances,
		resolvedColumnFlushIsotopicExclusions, resolvedColumnFlushIsotopeRatioThresholds, resolvedColumnFlushIsotopeDetectionMinimums,
		resolvedColumnFlushIsotopeMassTolerances, resolvedColumnFlushIsotopeRatioTolerances, fragmentModeConflictColumnFlushBool,
		massDetectionConflictColumnFlushBool, fragmentMassDetectionConflictColumnFlushBool, collisionEnergyConflictColumnFlushBool,
		collisionEnergyScanConflictColumnFlushBool, fragmentScanTimeConflictColumnFlushBool, acquisitionSurveyConflictColumnFlushBool,
		acquisitionLimitConflictColumnFlushBool, cycleTimeLimitConflictColumnFlushBool, exclusionModeMassConflictColumnFlushBool,
		exclusionMassToleranceConflictColumnFlushBool, exclusionRetentionTimeToleranceConflictColumnFlushBool, inclusionOptionsConflictColumnFlushBool,
		inclusionMassToleranceConflictColumnFlushBool, chargeStateExclusionLimitConflictColumnFlushBool, chargeStateExclusionConflictColumnFlushBool,
		chargeStateMassToleranceConflictColumnFlushBool, isotopicExclusionLimitColumnFlushBool, isotopicExclusionConflictColumnFlushBool,
		isotopeMassToleranceConflictColumnFlushBool, isotopeRatioToleranceConflictColumnFlushBool,
		fragmentModeConflictBool, fragmentModeOverallConflictQ, fragmentModeConflictOptions, fragmentModeConflictTests,
		massDetectionConflictBool, massDetectionOverallConflictQ, massDetectionConflictOptions, massDetectionConflictTests,
		fragmentMassDetectionConflictBool, fragmentMassDetectionOverallConflictQ, fragmentMassDetectionConflictOptions,
		fragmentMassDetectionConflictTests, collisionEnergyConflictBool, collisionEnergyOverallConflictQ,
		collisionEnergyConflictOptions, collisionEnergyConflictTests, collisionEnergyScanConflictBool, collisionEnergyScanOverallConflictQ,
		collisionEnergyScanConflictOptions, collisionEnergyScanConflictTests, fragmentScanTimeConflictBool, fragmentScanTimeOverallConflictQ,
		fragmentScanTimeConflictOptions, fragmentScanTimeConflictTests, acquisitionSurveyConflictBool, acquisitionSurveyOverallConflictQ,
		acquisitionSurveyConflictOptions, acquisitionSurveyConflictTests, acquisitionLimitConflictBool, acquisitionLimitOverallConflictQ,
		acquisitionLimitConflictOptions, acquisitionLimitConflictTests, cycleTimeLimitConflictBool, cycleTimeLimitOverallConflictQ,
		cycleTimeLimitConflictOptions, cycleTimeLimitConflictTests, exclusionModeMassConflictBool, exclusionModeMassOverallConflictQ,
		exclusionModeMassConflictOptions, exclusionModeMassConflictTests, exclusionMassToleranceConflictBool, exclusionMassToleranceOverallConflictQ,
		exclusionMassToleranceConflictOptions, exclusionMassToleranceConflictTests, exclusionRetentionTimeToleranceConflictBool,
		exclusionRetentionTimeToleranceOverallConflictQ, exclusionRetentionTimeToleranceConflictOptions, exclusionRetentionTimeToleranceConflictTests,
		inclusionOptionsConflictBool, inclusionOptionsOverallConflictQ, inclusionOptionsConflictOptions, inclusionOptionsConflictTests,
		inclusionMassToleranceConflictBool, inclusionMassToleranceOverallConflictQ, inclusionMassToleranceConflictOptions,
		inclusionMassToleranceConflictTests, chargeStateExclusionLimitConflictBool, chargeStateExclusionLimitOverallConflictQ,
		chargeStateExclusionLimitConflictOptions, chargeStateExclusionLimitConflictTests, chargeStateExclusionConflictBool,
		chargeStateExclusionOverallConflictQ, chargeStateExclusionConflictOptions, chargeStateExclusionConflictTests,
		chargeStateMassToleranceConflictBool, chargeStateMassToleranceOverallConflictQ, chargeStateMassToleranceConflictOptions,
		chargeStateMassToleranceConflictTests, isotopicExclusionLimitBool, isotopicExclusionLimitOverallQ,
		isotopicExclusionLimitOptions, isotopicExclusionLimitTests, isotopicExclusionConflictBool,
		isotopicExclusionOverallConflictQ, isotopicExclusionConflictOptions, isotopicExclusionConflictTests,
		isotopeMassToleranceConflictBool, isotopeMassToleranceOverallConflictQ, isotopeMassToleranceConflictOptions,
		isotopeMassToleranceConflictTests, isotopeRatioToleranceConflictBool, isotopeRatioToleranceOverallConflictQ,
		isotopeRatioToleranceConflictOptions, isotopeRatioToleranceConflictTests, resolvedInjectionTable,
		injectionTableColumnDeleted,injectionTableSampleRules, injectionTableStandardRules, injectionTableBlankRules,
		injectionTableColumnFlushRules, injectionTableColumnPrimeRules, collapseErrorBools,massToleranceOptions,
		resolvedSampleMassSpecMethodsForIT, resolvedStandardMassSpecMethodsForIT, resolvedBlankMassSpecMethodsForIT,
		resolvedColumnFlushMassSpecMethodsForIT, resolvedColumnPrimeMassSpecMethodsForIT,columnPrimeToSingle,
		columnFlushToSingle, depth4Options, acquisitionWindowExpandedByMethod, currentMassAcquisitionMethodPacket,
		acquisitionMethodFromMethod, acquisitionMethodFromMethodLength, allesInOrdnungQ,
		expandAcquisitionWindowByMethod,standardAcquisitionWindowExpandedByMethod, blankAcquisitionWindowExpandedByMethod,
		columnPrimeAcquisitionWindowExpandedByMethod, columnFlushAcquisitionWindowExpandedByMethod,continueQ,mapThreadVariables,
		currentColumnPrimeAcquisitionWindow, currentColumnFlushAcquisitionWindow,
		columnPrimeOptionsExpandedByMethod, columnFlushOptionsExpandedByMethod,spanInsideQ,
		columnPrimeNumberOfAcquisitionWindows, columnFlushNumberOfAcquisitionWindows, findDepth3Positions, alternativesQ,
		listedPattern, spanPatternCases,spanPositions, replacedSpans, remainingCases, remainingPositions,
		overlappingAcquisitionWindowStandardBool, overlappingAcquisitionWindowBlankBool, overlappingAcquisitionWindowColumnPrimeBool,
		overlappingAcquisitionWindowColumnFlushBool,overlappingAcquisitionWindowSampleBool, overlappingAcquisitionWindowBool,
		overlappingAcquisitionWindowOverallConflictQ, overlappingAcquisitionWindowOptions, overlappingAcquisitionWindowTests,
		detectorLookup, repeatedDetectorOptionQ, detectorOptionDeleteDuplicates, repeatedDetectorOptionTest,
		dataIndependentNotAloneBool, dataIndependentNotAloneQ, dataIndependentNotAloneOptions, dataIndependentNotAloneTests,
		collisionEnergyProfileConflictColumnFlushBool,collisionEnergyProfileConflictColumnPrimeBool,
		collisionEnergyProfileConflictBlankBool,collisionEnergyProfileConflictStandardBool,collisionEnergyProfileConflictSampleBool,
		collisionEnergyProfileConflictBool, collisionEnergyProfileOverallConflictQ, collisionEnergyProfileConflictOptions,
		collisionEnergyProfileConflictTests,depth3ColumnOptions, columnFurtherExpansionAssociation,
		exclusionModesVariedSampleBool,exclusionModesVariedStandardBool,exclusionModesVariedBlankBool,
		exclusionModesVariedColumnPrimeBool, exclusionModesVariedColumnFlushBool,
		acquisitionWindowsTooLongSampleBool,acquisitionWindowsTooLongStandardBool,acquisitionWindowsTooLongBlankBool,
		acquisitionWindowsTooLongColumnPrimeBool,acquisitionWindowsTooLongColumnFlushBool, acquisitionWindowsTooLongBool,
		acquisitionWindowsTooLongOverallConflictQ, acquisitionWindowsTooLongOptions, acquisitionWindowsTooLongTests,
		exclusionModesVariedBool, exclusionModesVariedOverallConflictQ, exclusionModesVariedOptions, exclusionModesVariedTests,

		(*these are variables for the depth=2 map thread*)
		resolvedIonMode, resolvedMassSpectrometryMethod, resolvedESICapillaryVoltage, resolvedDeclusteringVoltage,
		resolvedStepwaveVoltage, resolvedSourceTemperature, resolvedDesolvationTemperature,
		resolvedDesolvationGasFlow, resolvedConeGasFlow,pHValue, pKaValue, acid, base, defaultCapillaryVoltage,
		defaultSourceTemperature, defaultDesolvationTemperature, defaultDesolvationGasFlow,defaultStepwaveVoltage,
		acquisitionOptionsMapResult, gradientEndTime, resolvedMassAcquisitionMethodPacket,resolvedAcquisitionWindowList,
		overlappingAcquisitionWindowsQ,acquisitionWindowsTooLongQ,fieldValuesFromMethod,fieldValuesFromMethodPackets,
		depth2Result,maximumFlowRate,lengthOfWindows,

		(*these are variable used in the depth=3 map thread*)
		resolvedAcquisitionMode, resolvedFragment, resolvedMassDetection,
		resolvedScanTime, resolvedFragmentMassDetection, resolvedCollisionEnergy, resolvedCollisionEnergyMassProfile,
		resolvedCollisionEnergyMassScan, resolvedFragmentScanTime, resolvedAcquisitionSurvey, resolvedMinimumThreshold,
		resolvedAcquisitionLimit, resolvedCycleTimeLimit, resolvedExclusionDomain, resolvedExclusionMass,
		resolvedExclusionMassTolerance, resolvedExclusionRetentionTimeTolerance, resolvedInclusionDomain, resolvedInclusionMass,
		resolvedInclusionCollisionEnergy, resolvedInclusionDeclusteringVoltage, resolvedInclusionChargeState, resolvedInclusionScanTime,
		resolvedInclusionMassTolerance, resolvedSurveyChargeStateExclusion, resolvedSurveyIsotopeExclusion, resolvedChargeStateExclusionLimit,
		resolvedChargeStateExclusion, resolvedChargeStateMassTolerance, resolvedIsotopicExclusion, resolvedIsotopeRatioThreshold,
		resolvedIsotopeDetectionMinimum, resolvedIsotopeMassTolerance, resolvedIsotopeRatioTolerance,
		innerExpandedExclusionDomain, innerExpandedExclusionMass, currentExpandedInclusionDomain, currentExpandedInclusionMass,
		currentExpandedInclusionCollisionEnergy, currentExpandedInclusionDeclusteringVoltage, currentExpandedInclusionChargeState,
		currentExpandedInclusionScanTime,inclusionLength,inclusionOptionsAllNullQ,collisionEnergyProfileConflictQ,
		ddaOptions,massesToMeasure, potentiallyUninterestingMasses, inclusionOptionsAllAutomaticQ, combinedInclusionOptions,
		ddaQ,chargeStateExclusionOptions, isotopeExclusionOptions, fragmentModeConflictQ, massDetectionConflictQ,
		fragmentMassDetectionConflictQ, collisionEnergyConflictQ, collisionEnergyScanConflictQ, fragmentScanTimeConflictQ,
		acquisitionSurveyConflictQ, acquisitionLimitConflictQ, cycleTimeLimitConflictQ, exclusionModeMassConflictQ,
		exclusionModesVariedQ,
		exclusionMassToleranceConflictQ, exclusionRetentionTimeToleranceConflictQ, inclusionOptionsConflictQ, inclusionMassToleranceConflictQ,
		chargeStateExclusionLimitConflictQ, chargeStateExclusionConflictQ, chargeStateMassToleranceConflictQ,
		isotopicExclusionLimitQ, isotopicExclusionConflictQ, isotopeMassToleranceConflictQ,
		isotopeRatioToleranceConflictQ, surveyIsotopeExclusionQ,surveyChargeStateExclusionQ, isotopeExclusionLength,
		currentExpandedIsotopicExclusion, currentExpandedIsotopeRatioThreshold, currentExpandedIsotopeDetectionMinimum, sciExInstrumentError,
		sciExInstrumentErrors, sciExInstrumentErrorsStandard, sciExInstrumentErrorsBlank, sciExInstrumentErrorsColumnPrime, sciExInstrumentErrorsColumnFlush,
		invalidParametersForSciExInstrument, invalidParametersForSciExInstrumentOverallQ, invalidParametersForSciExInstrumentOptions,
		invalidParametersForSciExInstrumentTests,
		
		(* ESI-QQQ new options*)
		suppliedMassAnalyzer,suppliedMassSpectrometerInstrument,qtofOnlyOptions,qqqOnlyOptions,allMassAcquisitionMethods,allMassAnalyzersInMethod,
		specifiedQTOFOnlyOptions,specifiedQQQOnlyOptions,resolvedMassAnalyzer,resolvedMassSpectrometryInstrument,conflictingMassAnalyzerAndInstrumentQ,
		conflictingMassAnalyzerAndInstrumentOptions,conflictingMassAnalyzerAndInstrumentTest,tripleQuadQ,uniqueIonMode,secondIonMode,resolvedSecondCalibrant,
		secondCalibrantLookup,resolvedNeutralLosses,resolvedDwellTimes,resolvedMultipleReactionMonitoringAssays,resolvedIonGuideVoltages,
		resolvedNeutralLoss,resolvedDwellTime,resolvedMultipleReactionMonitoringAssay,resolvedIonGuideVoltage,defaultDeclusteringVoltage,
		defaultIonGuideVoltage,	defaultConeGasFlow, invalidSourceTemperatureQ, invalidVoltagesQ, invalidGasFlowQ,invalidSourceTemperatureBool,
		invalidVoltagesBool,invalidGasFlowBool,positiveIonModeQ,fragmentAcqModesP,lowRange,highRange,defaultMassSelectionValue,qqqRangedMassScanQ,
		qqqRangedMS1MassScanQ,qqqTandemMassQ,acqModeMassAnalyzerMismatchedQ,acqModeMassAnalyzerMismatchBool,resolvedCollisionCellExitVoltage,resolvedCollisionCellExitVoltages,
		autoNeutralLossValueWarningQ,autoNeutralLossValueWarningList,analytesMolecularWeights,resolvedStandardNeutralLosses,resolvedStandardDwellTimes,
		resolvedStandardCollisionCellExitVoltages,resolvedStandardMultipleReactionMonitoringAssays,resolvedStandardIonGuideVoltages,
		resolvedMassDetectionStepSizes,resolvedMassDetectionStepSize,result,resolvedStandardMassDetectionStepSizes,
		autoNeutralLossValueWarningStandardList,autoNeutralLossValueWarningBlankList,autoNeutralLossValueWarningColumnPrimeList,
		autoNeutralLossValueWarningColumnFlushList,invalidSourceTemperatureColumnFlushBool,invalidVoltagesColumnFlushBool,invalidGasFlowColumnFlushBool,
		invalidSourceTemperatureStandardBool,invalidVoltagesStandardBool,invalidGasFlowStandardBool,
		invalidSourceTemperatureBlankBool,invalidVoltagesBlankBool,invalidGasFlowBlankBool,
		invalidSourceTemperatureColumnPrimeBool,invalidVoltagesColumnPrimeBool,invalidGasFlowColumnPrimeBool,sameCalibrantWarning, invalidScanTimeQ, numberOfPoints,
		acqModeMassAnalyzerMismatchedStandardBool,acqModeMassAnalyzerMismatchedBlankBool,acqModeMassAnalyzerMismatchedColumnPrimeBool,acqModeMassAnalyzerMismatchedColumnFlushBool,
		resolvedBlankNeutralLosses,resolvedBlankDwellTimes,resolvedBlankMassDetectionStepSizes,resolvedBlankCollisionCellExitVoltages,resolvedBlankMultipleReactionMonitoringAssays,resolvedBlankIonGuideVoltages,
		resolvedColumnPrimeNeutralLosses,resolvedColumnPrimeDwellTimes,resolvedColumnPrimeMassDetectionStepSizes,resolvedColumnPrimeCollisionCellExitVoltages,resolvedColumnPrimeMultipleReactionMonitoringAssays,resolvedColumnPrimeIonGuideVoltages,
		resolvedColumnFlushNeutralLosses,resolvedColumnFlushDwellTimes,resolvedColumnFlushMassDetectionStepSizes,resolvedColumnFlushCollisionCellExitVoltages,resolvedColumnFlushMultipleReactionMonitoringAssays,resolvedColumnFlushIonGuideVoltages,
		invalidCollisionVoltagesBool,invalidCollisionVoltagesStandardBool,invalidCollisionVoltagesBlankBool,invalidCollisionVoltagesColumnPrimeBool,
		invalidCollisionVoltagesColumnFlushBool,invalidCollisionVoltagesQ,numberOfMassInputs,invalidLengthOfInputOptionQ,invalidLengthOfInputOptionBool,collisionEnergyAcqModeInvalidBool,
		invalidLengthOfInputOptionStandardBool,invalidLengthOfInputOptionBlankBool,invalidLengthOfInputOptionColumnPrimeBool,invalidLengthOfInputOptionColumnFlushBool,
		sourceTemperatureErrorBools,sourceTemperatureErrorOverallConflictQ,sourceTemperatureErrorOptions,souceTemperatureConflictTest,
		collisionEnergyAcqModeInvalidStandardBool,collisionEnergyAcqModeInvalidBlankBool,collisionEnergyAcqModeInvalidColumnPrimeBool,collisionEnergyAcqModeInvalidColumnFlushBool,
		invalidVoltagesErrorBools,invalidVoltagesErrorOverallConflictQ,invalidVoltagesErrorOptions,voltagesConflictTest,invalidGasFlowErrorBools,
		invalidGasFlowErrorOverallConflictQ,invalidGasFlowErrorOptions,invalidAcqMethodErrorOverallConflictQ,collisionEnergyAcqModeInvalidBools,
		collisionEnergyAcqModeInvalidOverallConflictQ,invalidCollisionEnergyAcqModeOptions,invalidCollisionEnergyAcqModeTest,invalidAcqMethodErrorOptions,
		acqModeMassAnalyzerConflictTest,invalidAcqMethodErrorBools,gasflowsConflictTest,autoNeutralLossErrorBools,autoNeutralLossErrorOverallConflictQ,invalidCollisionVoltagesErrorBools,
		invalidCollisionVoltagesErrorOverallConflictQ,invalidCollisionVoltagesErrorOptions,collisionVoltagesConflictTest,invalidLengthOfInputBools,invalidLengthOfInputOverallConflictQ,
		invalidLengthOfInputOptions,memAssaysNotInSameLengthTest,collisionEnergyAcqModeInvalidQ,formattedMultipleReactionMonitoringAssays, invalidScanTimeStandardBool, invalidScanTimeBlankBool,
		invalidScanTimeColumnPrimeBool, invalidScanTimeColumnFlushBool, invalidScanTimeBool, numberOfPointsInScan,
		invalidScanTimesBool, invalidScanTimeOverallQ, invalidScanTimesOptions, invalidScanTimeTests, simulation, updatedSimulation,
		optionSymbolsIndexMatchingToColumnSelector, hplcSingletonCorrectionRules, hplcResolvedOptionsCorrected
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification=OptionValue[Output];
	output=ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTestsQ = MemberQ[output,Tests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* Separate out our lcms options from our Sample Prep options. *)
	{samplePrepOptions,lcmsOptions}=splitPrepOptions[myOptions];

	(* Determine if we should throw messages *)
	messagesQ = !gatherTestsQ;

	(* Determine if we're being executed in Engine *)
	engineQ = MatchQ[$ECLApplication,Engine];

	testOrNull[testDescription_String,passQ:BooleanP]:=If[gatherTestsQ,
		Test[testDescription,True,Evaluate[passQ]],
		Null
	];
	warningOrNull[testDescription_String,passQ:BooleanP]:=If[gatherTestsQ,
		Warning[testDescription,True,Evaluate[passQ]],
		Null
	];

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. *)
	lcmsOptionsAssociation = Association[lcmsOptions];
	
	(* we get the instrument models *)
	{suppliedMassSpecModel,chromatographyInstrumentModel}=Map[
		Function[{instrumentLookup},
			Which[
				MatchQ[instrumentLookup,Automatic],Automatic,
				MatchQ[instrumentLookup,ObjectP[Model[Instrument]]], Download[instrumentLookup,Object],
				True,Download[Lookup[fetchPacketFromCache[instrumentLookup,cache],Model],Object]
			]
		],
		Lookup[lcmsOptionsAssociation,{MassSpectrometerInstrument,ChromatographyInstrument}]
	];
	
	(*define the available instrument models*)
	availableChromatographyInstrumentModels={Model[Instrument, HPLC, "id:4pO6dM5lRrl7"](*"Waters Acquity UPLC I-Class PDA"*)};
	(* we will allow for Automatic here right now for the error checking, will resolve these value after we pre-resolved the MassSpecAquisitionMethod *)
	availableMassSpecInstrumentModels={Model[Instrument, MassSpectrometer, "id:aXRlGn6KaWdO"] (*"Xevo G2-XS QTOF"*),Model[Instrument, MassSpectrometer, "id:N80DNj1aROOD"] (*"QTRAP 6500"*), Model[Instrument, MassSpectrometer, "id:Y0lXejl8MeOa"] (* QTRAP 6500 PLUS *)};

	(* if the user specifies an mass spec that we don't have. throw the error *)
	unavailableMassSpecOptions = If[messagesQ && !MatchQ[suppliedMassSpecModel,(ObjectP[availableMassSpecInstrumentModels]|Automatic)],
		(
			Message[Error::OnlyMassSpecAvailable, ObjectToString[Lookup[lcmsOptionsAssociation,MassSpectrometerInstrument],Simulation->simulation], ObjectToString[availableMassSpecInstrumentModels,Simulation->simulation]];
			MassSpectrometerInstrument
		),
		{}
	];

	(* make a test for the standard injection table options *)
	unavailableMassSpecTest = If[gatherTestsQ,
		Test["The set MassSpectrometerInstrument must be available in current offerings:",
			MatchQ[suppliedMassSpecModel,(ObjectP[Download[availableMassSpecInstrumentModels,Object]]|Automatic)],
			True
		],
		Nothing
	];

	(* if the user specifies an mass spec that we don't have. throw the error *)
	unavailableLCOptions = If[messagesQ && !MatchQ[chromatographyInstrumentModel,ObjectP[Download[availableChromatographyInstrumentModels,Object]]],
		(
			Message[Error::OnlyHPLCAvailable, ObjectToString[Lookup[lcmsOptionsAssociation,ChromatographyInstrument],Simulation->simulation], ObjectToString[availableChromatographyInstrumentModels,Simulation->simulation]];
			ChromatographyInstrument
		),
		{}
	];

	(* make a test for the standard injection table options *)
	unavailableLCTest = If[gatherTestsQ,
		Test["The specified ChromatographyInstrument is connected with an mass spectrometer and can be used for ExperimentLCMS:",
			MatchQ[chromatographyInstrumentModel,ObjectP[Download[availableChromatographyInstrumentModels,Object]]],
			True
		],
		Nothing
	];

	(*before we go into HPLC, we do our own partial standard, blank, column refresh resolution*)
	blankOptions=ToExpression/@Select["OptionName"/.OptionDefinition[ExperimentLCMS],StringContainsQ["Blank"]];
	standardOptions=ToExpression/@Select["OptionName"/.OptionDefinition[ExperimentLCMS],StringContainsQ["Standard"]];
	columnPrimeOptions=ToExpression/@Select["OptionName"/.OptionDefinition[ExperimentLCMS],StringContainsQ["ColumnPrime"]];
	columnFlushOptions=ToExpression/@Select["OptionName"/.OptionDefinition[ExperimentLCMS],StringContainsQ["ColumnFlush"]];

	(*also grab the injection table*)
	injectionTableSpecification=Lookup[lcmsOptionsAssociation,InjectionTable];
	injectionTableSpecifiedQ=MatchQ[injectionTableSpecification,Except[Automatic]];

	(*if the injection table is specified, get the types of all of the samples*)
	injectionTableTypes=If[injectionTableSpecifiedQ,
		injectionTableSpecification[[All,1]],
		{}
	];

	(*check if we have blanks specified indirectly/directly*)
	blanksExistQ=Which[
		MatchQ[Lookup[lcmsOptionsAssociation, BlankFrequency],None], False,
		NullQ[Lookup[lcmsOptionsAssociation, Blank]], False,
		(*if one of the blank options is specified*)
		Or@@Map[MatchQ[#,Except[Automatic|None|ListableP[Null]]]&,Lookup[lcmsOptionsAssociation,blankOptions]],True,
		(*or if it's in the injection table*)
		True,MemberQ[injectionTableTypes,Blank]
	];

	(*set the blank frequency if we need to*)
	blankFrequencyOptionRule=If[And[blanksExistQ,!injectionTableSpecifiedQ,MatchQ[Lookup[lcmsOptionsAssociation,BlankFrequency],Automatic]],
		BlankFrequency -> FirstAndLast,
		BlankFrequency -> Lookup[lcmsOptionsAssociation,BlankFrequency]
	];

	(*check if we have standards specified indirectly/directly*)
	standardExistQ=Which[
		MatchQ[Lookup[lcmsOptionsAssociation, StandardFrequency],None], False,
		NullQ[Lookup[lcmsOptionsAssociation, Standard]], False,
		(*if one of the standard options is specified*)
		Or@@Map[MatchQ[#,Except[Automatic|None|ListableP[Null]]]&,Lookup[lcmsOptionsAssociation,standardOptions]],True,
		(*or if it's in the injection table*)
		True,MemberQ[injectionTableTypes,Standard]
	];

	(*set the standard frequency if we need to*)
	standardFrequencyOptionRule=If[And[standardExistQ,!injectionTableSpecifiedQ,MatchQ[Lookup[lcmsOptionsAssociation,StandardFrequency],Automatic]],
		StandardFrequency -> FirstAndLast,
		StandardFrequency -> Lookup[lcmsOptionsAssociation,StandardFrequency]
	];

	(*split relevant options into those needed for HPLC*)
	hplcOptions=commonHPLCAndLCMSOptions;

	(*look up the user specification*)
	userHPLCOptions=Lookup[lcmsOptionsAssociation,hplcOptions];

	(*put them into the rule format*)
	initialHPLCOptionsRule=MapThread[Rule,{hplcOptions,userHPLCOptions}];

	(*add the frequency options*)
	hplcOptionRulesWithFrequencies=Join[initialHPLCOptionsRule,{blankFrequencyOptionRule,standardFrequencyOptionRule}];

	(*include the chromatography instrument but it's named differently*)
	hplcOptionsRuleWithInstrument=Append[hplcOptionRulesWithFrequencies,Instrument->Lookup[lcmsOptionsAssociation,ChromatographyInstrument]];

	(* The ColumnSelector option in ExperimentHPLC has additional ColumnPosition, GuardColumnOrientation and ColumnOrientation *)
	columnSelectorSpecifiedQ=MatchQ[Lookup[lcmsOptionsAssociation, ColumnSelector],Except[Automatic]];
	columnSelectorHPLCFormat=If[columnSelectorSpecifiedQ,
		(
			specifiedColumnSelector=Lookup[lcmsOptionsAssociation, ColumnSelector];
			(* Insert Automatic for ColumnPosition, GuardColumnOrientation and ColumnOrientation  *)
			columnSelectorWithHPLCKeys=Insert[specifiedColumnSelector,Automatic,{{1},{2},{3}}];
			{columnSelectorWithHPLCKeys}
		),
		Automatic
	];
	hplcOptionsRuleWithColumns=ReplaceRule[hplcOptionsRuleWithInstrument,ColumnSelector->columnSelectorHPLCFormat];

	(*the injection table is different in LCMS versus HPLC and needs to be reformatted accordingly if specified*)
	(*LCMS injection table has a column for the mass spec method. obvious we want to take that out*)
	(*HPLC has a column for the Column of each sample. We'll want to just fill in automatics there*)

	injectionTableHPLCFormat=If[injectionTableSpecifiedQ,
		(
			transposedInjectionTable=Transpose[injectionTableSpecification];
			(*we don't need the last row (the Mass method)*)
			injectionTableOmitMSMethod=Most[transposedInjectionTable];
			(* Add a row of PositionA for the column position index (third from end). *)
			injectionTableWithColumnAutomatics = Insert[injectionTableOmitMSMethod, ConstantArray[PositionA, Length[First@transposedInjectionTable]], -3];
			(*and transpose back*)
			Transpose[injectionTableWithColumnAutomatics]
		),
		Automatic
	];

	(*now add this injection table to our options*)
	hplcOptionsWithInjectionTable=Append[hplcOptionsRuleWithColumns,InjectionTable->injectionTableHPLCFormat];

	(*we also need to pass the default HPLC options already expanded, but replace the samplePrep and the LCMS specific stuff*)
	replacedHPLCOptions=ReplaceRule[
		Last@ExpandIndexMatchedInputs[ExperimentHPLC, {mySamples}, SafeOptions[ExperimentHPLC]],
		Join[hplcOptionsWithInjectionTable,samplePrepOptions]
	];

	(*HPLC will also handle all of the sample prep and required aliquot options*)
	{
		{simulatedSamples, hplcResolvedOptions, hplcInvalidOptions, hplcInvalidInputs, updatedSimulation},
		hplcTests
	}= If[gatherTestsQ,
		resolveExperimentHPLCOptions[
			mySamples,
			replacedHPLCOptions,
			Cache->cache,
			Simulation -> simulation,
			Output->{Result,Tests},
			InternalUsage->True
		],
		List[
			resolveExperimentHPLCOptions[
				mySamples,
				replacedHPLCOptions,
				Cache->cache,
				Simulation -> simulation,
				Output->Result,
				InternalUsage->True
			],
			{}
		]
	];

	(* Note, although LCMS and HPLC share some option names, they don't necessarily have the same definition *)
	(* One major difference is for HPLC some options are index-matched to ColumnSelector option since multiple columns are allowed *)
	(* However for LCMS since we only allow single column, these options are singleton instead. We have to correct them, otherwise they will cause problem *)

	(* Find all options index-match to ColumnSelector. Excluding itself *)
	optionSymbolsIndexMatchingToColumnSelector = DeleteCases[
		Lookup[
			Cases[OptionDefinition[ExperimentHPLC], AssociationMatchP[ <|"IndexMatchingParent" -> "ColumnSelector"|>, AllowForeignKeys -> True]],
			"OptionSymbol"
		],
		ColumnSelector
	];

	(* Correct the option value to singleton if needed *)
	hplcSingletonCorrectionRules = Map[
		Function[{option},
			Module[{optionValue},
				optionValue = Lookup[hplcResolvedOptions, option, "Missing"];
				Switch[optionValue,
					(* If the option does not exist, don't include it *)
					"Missing",
						Nothing,
					(* If the option value is a list, take its first entry *)
					_List,
						option -> First[optionValue],
					(* In other cases, don't change anything *)
					_,
						Nothing
				]
			]
		],
		optionSymbolsIndexMatchingToColumnSelector
	];

	hplcResolvedOptionsCorrected = ReplaceRule[hplcResolvedOptions, hplcSingletonCorrectionRules];

	(*only take the HPLC options that are relevant*)
	someRelevantResolvedHPLCOptions=KeyTake[hplcResolvedOptionsCorrected,Join[hplcOptions,Keys@samplePrepOptions]];

	(* Convert ColumnSelector back to LCMS format - Singleton, no ColumnPosition and Orientation *)
	updatedColumnSelector=Lookup[hplcResolvedOptionsCorrected,ColumnSelector][[1,{2,4,6,7}]];

	(*add these to our list*)
	relevantResolvedHPLCOptions=Join[someRelevantResolvedHPLCOptions,Association[ColumnSelector->updatedColumnSelector]];

	(* LCMS Specific rounding options *)

	(*these will need to be rounded to 0.1 Gram/Mole*)
	massToleranceOptions=ToExpression /@ Select["OptionName" /. OptionDefinition[ExperimentLCMS], StringContainsQ[#, "MassTolerance"] &];

	(*these will need to be rounded to 1 Gram/Mole*)
	massRelatedOptions=Complement[
		ToExpression /@ Select["OptionName" /. OptionDefinition[ExperimentLCMS], StringContainsQ[#, "Mass"] &],
		massToleranceOptions
	];

	tenthVoltRelatedOptions={CollisionEnergy,CollisionEnergyMassProfile, CollisionEnergyMassScan,DeclusteringVoltage,StepwaveVoltage,CollisionCellExitVoltage,IonGuideVoltage,
		InclusionCollisionEnergy,InclusionDeclusteringVoltage, StandardCollisionEnergy,StandardCollisionEnergyMassProfile,StandardCollisionEnergyMassScan,StandardDeclusteringVoltage,
		StandardStepwaveVoltage,StandardCollisionCellExitVoltage, StandardMassDetectionStepSize,StandardIonGuideVoltage,StandardInclusionCollisionEnergy,StandardInclusionDeclusteringVoltage,BlankCollisionEnergy,
		BlankCollisionEnergyMassProfile,BlankCollisionEnergyMassScan,BlankDeclusteringVoltage,BlankStepwaveVoltage,BlankCollisionCellExitVoltage, BlankMassDetectionStepSize,BlankIonGuideVoltage,
		BlankInclusionCollisionEnergy,BlankInclusionDeclusteringVoltage,ColumnFlushCollisionEnergy,ColumnFlushCollisionEnergyMassProfile,
		ColumnFlushCollisionEnergyMassScan,ColumnFlushDeclusteringVoltage,ColumnFlushStepwaveVoltage,ColumnFlushCollisionCellExitVoltage,ColumnFlushMassDetectionStepSize,ColumnFlushIonGuideVoltage,ColumnFlushInclusionCollisionEnergy,
		ColumnFlushInclusionDeclusteringVoltage,ColumnPrimeCollisionEnergy,ColumnPrimeCollisionEnergyMassProfile,
		ColumnPrimeCollisionEnergyMassScan,ColumnPrimeDeclusteringVoltage,ColumnPrimeStepwaveVoltage,ColumnPrimeCollisionCellExitVoltage,ColumnPrimeMassDetectionStepSize,ColumnPrimeIonGuideVoltage,ColumnPrimeInclusionCollisionEnergy,
		ColumnPrimeInclusionDeclusteringVoltage
	};

	milliSecondOptions={ScanTime,FragmentScanTime,CycleTimeLimit,InclusionScanTime,
		StandardScanTime,StandardFragmentScanTime,StandardCycleTimeLimit,StandardInclusionScanTime,BlankScanTime,BlankFragmentScanTime,
		BlankCycleTimeLimit,BlankInclusionScanTime,ColumnFlushScanTime,ColumnFlushFragmentScanTime,ColumnFlushCycleTimeLimit,
		ColumnFlushInclusionScanTime,ColumnPrimeScanTime,ColumnPrimeFragmentScanTime,ColumnPrimeCycleTimeLimit,
		ColumnPrimeInclusionScanTime
	};

	secondOptions={AcquisitionWindow,ExclusionDomain,InclusionDomain,ExclusionRetentionTimeTolerance,
		StandardAcquisitionWindow,StandardExclusionDomain,StandardInclusionDomain,StandardExclusionRetentionTimeTolerance,BlankAcquisitionWindow,BlankExclusionDomain,BlankInclusionDomain,BlankExclusionRetentionTimeTolerance,ColumnFlushAcquisitionWindow,ColumnFlushExclusionDomain,ColumnFlushInclusionDomain,ColumnFlushExclusionRetentionTimeTolerance,ColumnPrimeAcquisitionWindow,ColumnPrimeExclusionDomain,ColumnPrimeInclusionDomain,ColumnPrimeExclusionRetentionTimeTolerance};

	hundrethsPlaceOptions={IsotopeRatioThreshold,StandardIsotopeRatioThreshold,BlankIsotopeRatioThreshold,
		ColumnFlushIsotopeRatioThreshold,ColumnPrimeIsotopeRatioThreshold};

	perSecondOptions={IsotopeDetectionMinimum,StandardIsotopeDetectionMinimum,BlankIsotopeDetectionMinimum,
		ColumnPrimeIsotopeDetectionMinimum,ColumnFlushIsotopeDetectionMinimum
	};
	percentOptions={IsotopeRatioTolerance,StandardIsotopeRatioTolerance,BlankIsotopeRatioTolerance,ColumnFlushIsotopeRatioTolerance,ColumnPrimeIsotopeRatioTolerance};
	hundredVoltOptions={ESICapillaryVoltage, StandardESICapillaryVoltage, BlankESICapillaryVoltage, ColumnPrimeESICapillaryVoltage,
		ColumnFlushESICapillaryVoltage};
	temperatureOptions={SourceTemperature, StandardSourceTemperature, BlankSourceTemperature, ColumnPrimeSourceTemperature,
		ColumnFlushSourceTemperature, DesolvationTemperature, StandardDesolvationTemperature, BlankDesolvationTemperature,
		ColumnPrimeDesolvationTemperature, ColumnFlushDesolvationTemperature};
	literPerHourOptions={DesolvationGasFlow, StandardDesolvationGasFlow, BlankDesolvationGasFlow, ColumnPrimeDesolvationGasFlow,
		ColumnFlushDesolvationGasFlow, ConeGasFlow, StandardConeGasFlow, BlankConeGasFlow, ColumnPrimeConeGasFlow,
		ColumnFlushConeGasFlow};

	(*concantenate all of the options for rounding*)
	optionsForRounding=Join[
		massToleranceOptions,
		massRelatedOptions,
		tenthVoltRelatedOptions,
		milliSecondOptions,
		secondOptions,
		hundrethsPlaceOptions,
		percentOptions,
		hundredVoltOptions,
		temperatureOptions,
		literPerHourOptions,
		perSecondOptions
	];

	(*generate a list of all of the units to round*)
	valuesToRoundTo = Join[
		ConstantArray[10^(-1) Gram/Mole,Length[massToleranceOptions]],
		ConstantArray[0.1 Gram/Mole,Length[massRelatedOptions]],
		ConstantArray[10^(-1) Volt,Length[tenthVoltRelatedOptions]],
		ConstantArray[1 Milli*Second,Length[milliSecondOptions]],
		ConstantArray[1 Second,Length[secondOptions]],
		ConstantArray[10^(-2),Length[hundrethsPlaceOptions]],
		ConstantArray[1 Percent,Length[percentOptions]],
		ConstantArray[10^(-1) Kilo*Volt,Length[hundredVoltOptions]],
		ConstantArray[1 Celsius,Length[temperatureOptions]],
		ConstantArray[1 Liter/Hour,Length[literPerHourOptions]],
		ConstantArray[1 1/Second,Length[perSecondOptions]]
	];

	(* Fetch association with volumes rounded *)
	{nonSpecialRoundedOptions, nonSpecialRoundingTests} = If[gatherTestsQ,
		RoundOptionPrecision[lcmsOptionsAssociation, optionsForRounding, valuesToRoundTo, Output -> {Result, Tests}],
		{RoundOptionPrecision[lcmsOptionsAssociation, optionsForRounding, valuesToRoundTo], {}}
	];

	(*combine all of the options so far to work with for the rest of the experiment function*)
	roundedOptionsAssociation=Join[
		lcmsOptionsAssociation,
		nonSpecialRoundedOptions,
		relevantResolvedHPLCOptions
	];

	(*grab the simulated sample packets*)
	simulatedSampleIdentityModelFields = {pKa,Acid,Base,Molecule,MolecularWeight,StandardComponents,PolymerType};
	simulationFastAssoc = makeFastAssocFromCache[FlattenCachePackets[{cache, Lookup[First[updatedSimulation], Packets]}]];
	simulatedSamplePackets=Map[
		fetchPacketFromFastAssoc[#,simulationFastAssoc]&,
		simulatedSamples
	];
	simulatedSampleIdentityModelPackets=Quiet[
		Download[
			simulatedSamples,
			Packet[Composition[[All,2]][simulatedSampleIdentityModelFields]],
			Cache->cache,
			Simulation -> updatedSimulation
		],
		Download::FieldDoesntExist
	];

	(* Helper function that resolves to the analytes of interest, given a list of a bunch of analyte packets. *)
	resolveMassSpecAnalytes[myAnalytePackets_]:=Which[
		(* Anything that could be considered analytes (Types[Model[Molecule]) is pulled out of the composition *)
		MemberQ[myAnalytePackets,(ObjectP[Model[Molecule,Protein]]|ObjectP[Model[Molecule,Carbohydrate]]|ObjectP[Model[Molecule,cDNA]]|ObjectP[Model[Molecule,Oligomer]]|ObjectP[Model[Molecule,Transcript]]|ObjectP[Model[Molecule,Polymer]])],
		Download[Cases[myAnalytePackets,ObjectP[{Model[Molecule,Protein],Model[Molecule,Carbohydrate],Model[Molecule,cDNA],Model[Molecule,Oligomer],Model[Molecule,Transcript],Model[Molecule,Polymer]}]],Object],
		(* Small Molecule Identity Model --- use the largest one (including water and solvents) since we don't know better *)
		MemberQ[myAnalytePackets,ObjectP[Model[Molecule]]],
		Module[{allMolWeightTuple,sortedTuple},
			(* Build a tuple for molecular weight and the object*)
			allMolWeightTuple=Download[Cases[myAnalytePackets,ObjectP[Model[Molecule]]], {Object,MolecularWeight}];
			
			(* Sort the list by molecular weight*)
			sortedTuple=SortBy[allMolWeightTuple,Last];
			
			(*Return the object with the largest molecular weight *)
			FirstOrDefault[LastOrDefault[sortedTuple]]
		],
		(* Field isn't filled out *)
		True,
		Null
	];

	(* Resolve the analytes of interest from our Composition field by looking at the Analytes field. *)
	(* Note: this is the option that we return to the user in the builder, but we do some additional filtering for internal use in the next few steps. *)
	resolveAnalytesFunction:=Function[{analytesOption,samplePacket,sampleComponentPackets},
		(* If the user specified the option, use that. *)
		If[!MatchQ[analytesOption,Automatic],
			analytesOption,
			(* ELSE: If the Analytes field in the Object[Sample] is filled out, use that. *)
			If[!MatchQ[Lookup[samplePacket,Analytes],{}|Null],
				Lookup[samplePacket,Analytes],
				(* ELSE: Prefer Protein>Peptide>Oligomer>Polymer>Small Molecule. *)
				resolveMassSpecAnalytes[Flatten@sampleComponentPackets]
			]
		]
	];

	resolvedAnalytes=MapThread[
		resolveAnalytesFunction,
		{Lookup[lcmsOptionsAssociation,Analytes],simulatedSamplePackets,simulatedSampleIdentityModelPackets}
	];

	validAnalytes=MapThread[
		Function[{analytesOption,samplePacket},
			Intersection[Download[Lookup[samplePacket,Composition][[All,2]],Object],ToList@Download[analytesOption,Object]]
		],
		{resolvedAnalytes,simulatedSamplePackets}
	];

	(*define a shared function for filtering the analytes*)
	filterAnalytesFunction:=Function[{sampleModelPackets, validAnalytesForSample},
		(* Filter by our mass spec hiearchy Protein>Peptide>Oligomer>Polymer>Small Molecule *)
		(* Note: This helper function takes in packets. *)
		resolvedFilteredAnalytes=resolveMassSpecAnalytes[Cases[sampleModelPackets,ObjectP[validAnalytesForSample]]];
		Cases[sampleModelPackets,ObjectP[resolvedFilteredAnalytes]]
	];

	(* Map over our valid analytes and make sure that we don't have multiple types of analytes that fall in different mass ranges. If we do, then resolve to the largest analytes via our helper function. *)
	(* From here on out, we use these packets internally in our function to resolve the different mass spec options (e.g. MassRange). *)
	filteredAnalytePackets=MapThread[
		filterAnalytesFunction,
		{simulatedSampleIdentityModelPackets, validAnalytes}
	];

	(* Determine the sample category of each sample since we will use this for the resolution below. If the category cannot be determined, it will be labeled None *)
	(* Categories are DNA (and all other oligonucleotides) / Peptide / Protein (including antibodies) / None *)
	getSampleCategoriesFunction:=Function[{samplePacket,sampleAnalytePackets},
		Which[
			MemberQ[Flatten@sampleAnalytePackets,ObjectP[Model[Molecule,Oligomer]]],
				Which[
					(* we treat any oligonucleotide as DNA - don't just look at PolymerType since that may contain the Mixed category *)
					MemberQ[Flatten[(PolymerType[ToStrand[#]]&)/@Lookup[Flatten@sampleAnalytePackets,Molecule]],(DNA|PNA|RNA|GammaLeftPNA|GammaRightPNA)],
					DNA,
					(* peptides are their own category *)
					MemberQ[Flatten[(PolymerType[ToStrand[#]]&)/@Lookup[Flatten@sampleAnalytePackets,Molecule]],Peptide],
					Peptide,
					(* just in case we missed a category or the pattern expands, do this catch-all *)
					True,
					None
				],
			(* Intact proteins and antibodies are treated as Protein *)
			MemberQ[Flatten@sampleAnalytePackets,ObjectP[Model[Molecule,Protein]]],
				Protein,
			(* If we're dealing with stock solution standards, and they have oligomers as StandardComponents we can check the StandardComponents properties *)
			MatchQ[Lookup[samplePacket,Model],Model[Sample,StockSolution,Standard]]&&!MatchQ[Flatten@sampleAnalytePackets,{}],
				Which[
					MatchQ[Commonest[DeleteCases[Flatten[(PolymerType[ToStrand[#]]&)/@Lookup[Flatten@sampleAnalytePackets,Molecule]],Except[PolymerP]]],(DNA|PNA|RNA|GammaLeftPNA|GammaRightPNA)],
					DNA,
					MatchQ[Commonest[DeleteCases[Flatten[(PolymerType[ToStrand[#]]&)/@Lookup[Flatten@sampleAnalytePackets,Molecule]],Except[PolymerP]]],Peptide],
					Peptide,
					True,
					None
				],
			(* If we're dealing with a sample chemical, a regular stock solution, or any other sample, we can't determine the sample category *)
			True, None
		]
	];

	sampleCategories=MapThread[getSampleCategoriesFunction,
		{simulatedSamplePackets,filteredAnalytePackets}
	];

	(* Lookup the molecular weight of analytes, per sample *)
	sampleMolecularWeights=Map[
		Function[{analytePackets},
			If[!MatchQ[analytePackets,{}|{Null..}],
				Cases[Lookup[analytePackets,MolecularWeight],MolecularWeightP],
				{}]
		],
		filteredAnalytePackets
	];

	(*if we have a specified injection table, we'll want to download the pertinent mass spec methods if there*)

	(*first we reassemble back from HPLC*)
	hplcInjectionTable=Lookup[hplcResolvedOptionsCorrected,InjectionTable];

	(*we'll put back in our mass spec methods and take out the column column*)
	transposedHPLCInjectionTable=Transpose[hplcInjectionTable];
	hplcInjectionTableColumnsRemoved=Delete[transposedHPLCInjectionTable,4];

	(*mass spec methods*)
	massSpecMethodsFromInjectionTable=If[injectionTableSpecifiedQ,
		(*if we have a injection table specification, take it from there*)
		Last@Transpose[injectionTableSpecification],
		(*otherwise we pad with automatics*)
		ConstantArray[Automatic,Length[First@transposedHPLCInjectionTable]]
	];

	(*expand the blank and standard options*)
	{preresolvedStandard,preresolvedBlank}=Lookup[hplcResolvedOptionsCorrected,{Standard,Blank}];

	(*if we do have these, keep them otherwise use an empty list*)
	resolvedStandard=If[standardExistQ,
		ToList[preresolvedStandard],
		{}
	];

	resolvedBlank=If[blanksExistQ,
		ToList[preresolvedBlank],
		{}
	];

	(*enumerate all of the sample, blank, standard, column flush, and prime positions*)
	samplePositions=Sequence@@@Position[hplcInjectionTable,{Sample,___}];
	standardPositionsAll=Sequence@@@Position[hplcInjectionTable,{Standard,___}];
	blankPositionsAll=Sequence@@@Position[hplcInjectionTable,{Blank,___}];
	columnFlushPositionsAll=Sequence@@@Position[hplcInjectionTable,{ColumnFlush,___}];
	columnPrimePositionsAll=Sequence@@@Position[hplcInjectionTable,{ColumnPrime,___}];

	(*do we have the column primes and flushes?*)
	columnFlushQ=Length[columnFlushPositionsAll]>0;
	columnPrimeQ=Length[columnPrimePositionsAll]>0;

	(*do some error checking here, if the user sets no column prime nor flush in the injection table but an option is set, then we want to throw an error*)
	columnFlushSpecificationBool=Map[
		MatchQ[Lookup[roundedOptionsAssociation,#,Null],Except[Null|Automatic]]&,
		columnFlushOptions
	];

	conflictingColumnFlushOptions=If[messagesQ && And[!columnFlushQ,Or@@columnFlushSpecificationBool],
		(
			Message[Error::ColumnFlushConflict, Join[PickList[columnFlushOptions,columnFlushSpecificationBool],{InjectionTable,ColumnRefreshFrequency}]];
			Join[PickList[columnFlushOptions,columnFlushSpecificationBool],{InjectionTable,ColumnRefreshFrequency}]
		),
		{}
	];
	conflictingColumnFlushTest = If[gatherTestsQ,
		Test["If ColumnFlush is turned off, then non of the corresponding options are set:",
			And[!columnFlushQ,Or@@columnFlushSpecificationBool],
			False
		],
		Nothing
	];

	columnPrimeSpecificationBool=Map[
		MatchQ[Lookup[roundedOptionsAssociation,#,Null],Except[Null|Automatic]]&,
		columnPrimeOptions
	];

	conflictingColumnPrimeOptions=If[messagesQ && And[!columnPrimeQ,Or@@columnPrimeSpecificationBool],
		(
			Message[Error::ColumnPrimeConflict, Join[PickList[columnPrimeOptions,columnPrimeSpecificationBool],{InjectionTable,ColumnRefreshFrequency}]];
			Join[PickList[columnPrimeOptions,columnPrimeSpecificationBool],{InjectionTable,ColumnRefreshFrequency}]
		),
		{}
	];
	conflictingColumnPrimeTest = If[gatherTestsQ,
		Test["If ColumnPrime is turned off, then non of the corresponding options are set:",
			And[!columnPrimeQ,Or@@columnPrimeSpecificationBool],
			False
		],
		Nothing
	];

	expandedStandardOptionsPreCheck = If[!standardExistQ,
		Association[#->{}&/@standardOptions],
		(*we need to wrap all the values in in list if not already*)
		Association@Last[ExpandIndexMatchedInputs[
			ExperimentLCMS,
			{mySamples},
			Normal@Append[
				KeyTake[roundedOptionsAssociation,standardOptions],
				Standard -> resolvedStandard
			],
			Messages -> False
		]]
	];

	expandedBlankOptionsPreCheck = If[!blanksExistQ,
		Association[#->{}&/@blankOptions],
		(*we need to wrap in list if not already*)
		Association@Last[ExpandIndexMatchedInputs[
			ExperimentLCMS,
			{mySamples},
			Normal@Append[
				KeyTake[roundedOptionsAssociation,blankOptions],
				Blank -> resolvedBlank
			],
			Messages -> False
		]]
	];

	(* It is possible for the following options to be over-expanded: StandardScanTime, BlankScanTime *)
	(* This module creates rules to unexpand these options if they were over-expanded. *)
	unexpandKeyValuePairs = Association @@ Module[{optionsToCheck, primaryIndexLengths, preexpansionLengths, preExpansionValues, noExpansionNeeded},

		(* Options that may be over-expanded. *)
		optionsToCheck = {StandardScanTime, BlankScanTime};

		(* Check the length of the primrary indicies. *)
		primaryIndexLengths = Length /@ {resolvedStandard, resolvedBlank};

		(* Lookup the options prior to expansion. *)
		preExpansionValues = Lookup[roundedOptionsAssociation, optionsToCheck];

		(* Get their lengths. *)
		preexpansionLengths = Length /@ preExpansionValues;

		(* Compare whether the options were index-matched appropriately prior to expansion. *)
		noExpansionNeeded = Map[EqualQ @@ # &, Transpose[{primaryIndexLengths, preexpansionLengths}]];

		(* Create rules to unexpand them. *)
		MapThread[If[#1, (#2 -> #3), Nothing]&, {noExpansionNeeded, optionsToCheck, preExpansionValues}]
	];

	(* Some other options will cross over into the other association but it should not matter. *)
	expandedStandardOptions = Join[expandedStandardOptionsPreCheck, unexpandKeyValuePairs];
	expandedBlankOptions = Join[expandedBlankOptionsPreCheck, unexpandKeyValuePairs];

	(*we want to get the standard analytes*)
	standardPackets=If[standardExistQ,Map[fetchPacketFromCache[#,cache]&,resolvedStandard],{}];
	standardIdentityModelPackets= If[standardExistQ,
		Quiet[Download[resolvedStandard, Packet[Composition[[All, 2]][simulatedSampleIdentityModelFields]], Cache -> cache, Simulation->updatedSimulation], Download::FieldDoesntExist],
		{}
	];

	(* Resolve the analytes of interest from our Composition field by looking at the Analytes field. *)
	(* Note: this is the option that we return to the user in the builder, but we do some additional filtering for internal use in the next few steps. *)
	resolvedStandardAnalytes=MapThread[
		resolveAnalytesFunction,
		{Lookup[expandedStandardOptions,StandardAnalytes]/.{Null->{},Automatic->{}},standardPackets,standardIdentityModelPackets}
	];

	standardAnalytePackets=Map[
		Function[{analyteSet}, Map[fetchPacketFromCache[#,cache]&,analyteSet]],
		resolvedStandardAnalytes
	];

	standardCategories=MapThread[getSampleCategoriesFunction,
		{standardPackets,standardAnalytePackets}
	];

	(* Lookup the molecular weight of analytes, per sample *)
	standardMolecularWeights=Map[
		Function[{analytePackets},
			If[!MatchQ[analytePackets,{}|{Null..}],
				Cases[Lookup[analytePackets,MolecularWeight],MolecularWeightP],
				{}]
		],
		standardAnalytePackets];

	blankPackets=If[blanksExistQ,Map[fetchPacketFromCache[#,cache]&,resolvedBlank],{}];
	blankIdentityModelPackets= If[blanksExistQ,
		Quiet[Download[resolvedBlank, Packet[Composition[[All, 2]][simulatedSampleIdentityModelFields]], Cache -> cache, Simulation->updatedSimulation], Download::FieldDoesntExist],
		{}
	];

	(* Resolve the analytes of interest from our Composition field by looking at the Analytes field. *)
	(* Note: this is the option that we return to the user in the builder, but we do some additional filtering for internal use in the next few steps. *)
	resolvedBlankAnalytes=MapThread[
		resolveAnalytesFunction,
		{Lookup[expandedBlankOptions,BlankAnalytes]/.{Null->{},Automatic->{}},blankPackets,blankIdentityModelPackets}
	];

	blankAnalytePackets=Map[
		Function[{analyteSet}, Map[fetchPacketFromCache[#,cache]&,analyteSet]],
		resolvedBlankAnalytes
	];

	blankCategories=MapThread[getSampleCategoriesFunction,
		{blankPackets,blankAnalytePackets}
	];

	(* Lookup the molecular weight of analytes, per sample *)
	blankMolecularWeights=Map[
		Function[{analytePackets},
			If[!MatchQ[analytePackets,{}|{Null..}],
				Cases[Lookup[analytePackets,MolecularWeight],MolecularWeightP],
				{}]
		],
		blankAnalytePackets];

	(*we want to also expand the acquisition window column prime/flush options*)

	columnPrimeAcquisitionWindowMatchedOptions=Map[
		ToExpression,
		"OptionName"/.Cases[OptionDefinition[ExperimentLCMS],KeyValuePattern["IndexMatchingParent"->"ColumnPrimeAcquisitionWindow"]]
	];

	columnFlushAcquisitionWindowMatchedOptions=Map[
		ToExpression,
		"OptionName"/.Cases[OptionDefinition[ExperimentLCMS],KeyValuePattern["IndexMatchingParent"->"ColumnFlushAcquisitionWindow"]]
	];

	(*these may have been replicated within the injection table, so we take the first set of the length*)
	(*we include the UpTo in case of conflicts*)
	standardPositions=Take[standardPositionsAll,UpTo[Length[resolvedStandard]]];
	blankPositions=Take[blankPositionsAll,UpTo[Length[resolvedBlank]]];
	columnFlushPositions=Take[columnFlushPositionsAll, UpTo[If[columnFlushQ,1,0]]];
	columnPrimePositions=Take[columnPrimePositionsAll, UpTo[If[columnPrimeQ,1,0]]];

	(*grab the pertinent mass spec methods for the samples*)
	(*we might have conflicts (happens when the injection table and the other options are not quite balanced, so we pad with atuomatics if necessary)*)
	sampleMassSpecMethodsFromIT= PadRight[massSpecMethodsFromInjectionTable[[samplePositions]],Length[mySamples],Automatic];
	standardMassSpecMethodsFromIT= PadRight[massSpecMethodsFromInjectionTable[[standardPositions]],Length[resolvedStandard],Automatic];
	blankMassSpecMethodsFromIT= PadRight[massSpecMethodsFromInjectionTable[[blankPositions]],Length[resolvedBlank],Automatic];
	columnFlushMassSpecMethodsFromIT= PadRight[massSpecMethodsFromInjectionTable[[columnFlushPositions]],If[columnFlushQ,1,0],Automatic];
	columnPrimeMassSpecMethodsFromIT= PadRight[massSpecMethodsFromInjectionTable[[columnPrimePositions]],If[columnPrimeQ,1,0],Automatic];

	(*and look up our method from the options*)
	{
		massSpecMethodSampleLookup,
		columnPrimeMassSpecMethodSampleLookup,
		columnFlushMassSpecMethodSampleLookup
	}=Lookup[roundedOptionsAssociation,{
		MassSpectrometryMethod,
		ColumnPrimeMassSpectrometryMethod,
		ColumnFlushMassSpectrometryMethod
	}];
	standardMassSpecMethodSampleLookup=Lookup[expandedStandardOptions,StandardMassSpectrometryMethod];
	blankMassSpecMethodSampleLookup=Lookup[expandedBlankOptions,BlankMassSpectrometryMethod];

	(*map through and take the best one for each sample*)
	{
		{bestSamplesMassSpecMethods,massSpecMethodConflictSamplesBool},
		{bestStandardsMassSpecMethods,massSpecMethodConflictStandardsBool},
		{bestBlanksMassSpecMethods,massSpecMethodConflictBlanksBool},
		{bestColumnPrimeMassSpecMethods,massSpecMethodConflictColumnPrimeBool},
		{bestColumnFlushMassSpecMethods,massSpecMethodConflictColumnFlushBool}
	}=Map[
		Function[{tuple},
			If[MatchQ[tuple,Except[{{},{}}]],
				Transpose@MapThread[
						Function[{optionMassSpecMethod,ijMassSpecMethod},
							Switch[{optionMassSpecMethod,ijMassSpecMethod},
								(*check if both were specified, and if so, see if it's the same*)
								{ObjectP[],ObjectP[]},{optionMassSpecMethod,!MatchQ[Download[optionMassSpecMethod,Object],ObjectP[Download[ijMassSpecMethod,Object]]]},
								{ObjectP[],_},{optionMassSpecMethod,False},
								{_,ObjectP[]},{ijMassSpecMethod,False},
								_,{Null,False}
							]
						],
					{First@tuple,Last@tuple}
				],
				{{},{}}
			]
		],
		{
			{massSpecMethodSampleLookup,sampleMassSpecMethodsFromIT},
			{standardMassSpecMethodSampleLookup,standardMassSpecMethodsFromIT},
			{blankMassSpecMethodSampleLookup,blankMassSpecMethodsFromIT},
			{If[columnPrimeQ, ToList@columnPrimeMassSpecMethodSampleLookup,{}],columnPrimeMassSpecMethodsFromIT},
			{If[columnFlushQ, ToList@columnFlushMassSpecMethodSampleLookup,{}],columnFlushMassSpecMethodsFromIT}
		}
	];
	
	
	(*===== 1. Resolve MassSpec Instrument, MassAnalyzer =====*)
	(* fetch the value from the option*)
	{suppliedMassAnalyzer,suppliedMassSpectrometerInstrument}=Lookup[roundedOptionsAssociation,{MassAnalyzer,MassSpectrometerInstrument}];
	
	(* collect those options that can only be specified in QTOF*)
	(* fetch all non Automaic or Null options *)
	qtofOnlyOptions=Lookup[roundedOptionsAssociation,{StepwaveVoltage,StandardStepwaveVoltage,BlankStepwaveVoltage,ColumnPrimeStepwaveVoltage,ColumnFlushStepwaveVoltage}];
	
	(* Check if any of the QTOF only options was speficied *)
	specifiedQTOFOnlyOptions=Cases[qtofOnlyOptions,Except[ListableP[Automatic|Null]]];
	
	(* Then check if any of the qqq options are specified  *)
	qqqOnlyOptions=Lookup[
		roundedOptionsAssociation,
		{
			DwellTime,
			CollisionCellExitVoltage,
			MassDetectionStepSize,
			MultipleReactionMonitoringAssays,
			NeutralLoss,
			IonGuideVoltage,
			
			StandardDwellTime,
			StandardCollisionCellExitVoltage,
			StandardMassDetectionStepSize,
			StandardMultipleReactionMonitoringAssays,
			StandardNeutralLoss,
			StandardIonGuideVoltage,
			
			BlankDwellTime,
			BlankCollisionCellExitVoltage,
			BlankMassDetectionStepSize,
			BlankMultipleReactionMonitoringAssays,
			BlankNeutralLoss,
			BlankIonGuideVoltage,
			
			ColumnPrimeDwellTime,
			ColumnPrimeCollisionCellExitVoltage,
			ColumnPrimeMassDetectionStepSize,
			ColumnPrimeMultipleReactionMonitoringAssays,
			ColumnPrimeNeutralLoss,
			ColumnPrimeIonGuideVoltage,
			
			ColumnFlushDwellTime,
			ColumnFlushCollisionCellExitVoltage,
			ColumnFlushMassDetectionStepSize,
			ColumnFlushMultipleReactionMonitoringAssays,
			ColumnFlushNeutralLoss,
			ColumnFlushIonGuideVoltage
			
		}
	];
	
	(* Check if any of the QQQ only options was speficied *)
	specifiedQQQOnlyOptions=Cases[qqqOnlyOptions,Except[ListableP[Automatic|Null]]];
	
	(* Fetch all method packets from from the cache, check their mass analyzer *)
	(* First collect all unique mass acquisition methods from all above options *)
	allMassAcquisitionMethods=DeleteDuplicates[
		Download[
			Flatten[
				{
					massSpecMethodSampleLookup,
					sampleMassSpecMethodsFromIT,
					standardMassSpecMethodSampleLookup,
					standardMassSpecMethodsFromIT,
					blankMassSpecMethodSampleLookup,
					blankMassSpecMethodsFromIT,
					columnPrimeMassSpecMethodSampleLookup,
					columnPrimeMassSpecMethodsFromIT,
					columnFlushMassSpecMethodSampleLookup,
					columnFlushMassSpecMethodsFromIT
				}/.{(Automatic|New)->{}}
			],
			Object
		]
	];
	
	(* Fetch all the input MassAnalyzers from all input method *)
	allMassAnalyzersInMethod=If[Length[allMassAcquisitionMethods]>0,
		fastAssocLookup[simulationFastAssoc, #, MassAnalyzer]& /@ allMassAcquisitionMethods,
		{}
	];
	
	(* now we have all information *)
	(* Resolve MassAnalyzer First*)
	resolvedMassAnalyzer=Which[
		
		(* Use user specified value if user specified something*)
		MatchQ[suppliedMassAnalyzer,Except[Automatic]],	suppliedMassAnalyzer,
		
		(* if user specified instrument, resolve the mass analyzer based on the specified the instrument *)
		MatchQ[suppliedMassSpecModel,ObjectP[{Model[Instrument, MassSpectrometer, "id:aXRlGn6KaWdO"] (*"Xevo G2-XS QTOF"*)}]],QTOF,
		MatchQ[suppliedMassSpecModel,ObjectP[{Model[Instrument, MassSpectrometer, "id:N80DNj1aROOD"] (*"QTRAP 6500"*), Model[Instrument, MassSpectrometer, "id:Y0lXejl8MeOa"] (* QTrap 6500 Plus *)}]],TripleQuadrupole,
		
		
		(* Else we check if user specified unique options, if so, we resolved to that mass analyzer to QQQ*)
		Length[specifiedQQQOnlyOptions]>0,TripleQuadrupole,
		
		(* Else check if specified MassAnalyzer Method has specified MassAnalyzer if so, use the first one *)
		Length[allMassAnalyzersInMethod]>0,First[allMassAnalyzersInMethod],
		
		(* Default to QTOF*)
		True, QTOF
		
	];
	
	(* Resolved MassSpectrometryInstrument then, since the MassAnalzyer has been well resolved, we rely all on resolvedMassAnalyzer here*)
	resolvedMassSpectrometryInstrument=If[
		
		(* if user specified a instrument, we use what user specified*)
		MatchQ[suppliedMassSpectrometerInstrument,Except[Automatic]],
		suppliedMassSpectrometerInstrument,
		
		(* then resolve based on mass analyzer *)
		If[MatchQ[resolvedMassAnalyzer,TripleQuadrupole],
			Model[Instrument, MassSpectrometer, "id:N80DNj1aROOD"], (*"QTRAP 6500"*)
			Model[Instrument, MassSpectrometer, "id:aXRlGn6KaWdO"] (*"Xevo G2-XS QTOF"*)
		]
	];
	
	(* check for all inconsistency between mass analyzer and mass spec instrument *)
	conflictingMassAnalyzerAndInstrumentQ=Which[
		MatchQ[resolvedMassAnalyzer,QTOF]&&MatchQ[suppliedMassSpecModel,ObjectP[]], (!MatchQ[suppliedMassSpecModel,ObjectP[Model[Instrument, MassSpectrometer, "id:aXRlGn6KaWdO"] (*"Xevo G2-XS QTOF"*)]]),
		MatchQ[suppliedMassSpecModel,ObjectP[]],(!MatchQ[suppliedMassSpecModel,ObjectP[{Model[Instrument, MassSpectrometer, "id:N80DNj1aROOD"] (*"QTRAP 6500"*), Model[Instrument, MassSpectrometer, "id:Y0lXejl8MeOa"] (* QTrap 6500 Plus *)}]]),
		True,False
	];
	
	conflictingMassAnalyzerAndInstrumentOptions=If[messagesQ && conflictingMassAnalyzerAndInstrumentQ,
		(
			Message[Error::MassAnalyzerAndMassSpecInstrumentConflict, resolvedMassAnalyzer, ObjectToString[resolvedMassSpectrometryInstrument,Simulation->updatedSimulation]];
			Join[PickList[columnPrimeOptions,columnPrimeSpecificationBool],{InjectionTable,ColumnRefreshFrequency}]
		),
		{}
	];
	conflictingMassAnalyzerAndInstrumentTest = If[gatherTestsQ,
		Test["If ColumnPrime is turned off, then non of the corresponding options are set:",
			And[!columnPrimeQ,Or@@columnPrimeSpecificationBool],
			False
		],
		Nothing
	];
	
	(*delineate everything that index-matched to inclusion domain*)
	inclusionDomainOptions={InclusionDomain,InclusionMass,InclusionCollisionEnergy, InclusionDeclusteringVoltage,InclusionChargeState,
		InclusionScanTime};
	exclusionDomainOptions={ExclusionDomain,ExclusionMass};
	isotopicExclusionOptions={IsotopicExclusion,IsotopeRatioThreshold,IsotopeDetectionMinimum};

	(*do the standard, blank, columnprime, and columnflush versions too -- the column versions will be used for the depth 3 and 4 expansion*)
	{
		{
			standardInclusionDomainOptions,
			standardExclusionDomainOptions,
			standardIsotopicExclusionOptions
		},
		{
			blankInclusionDomainOptions,
			blankExclusionDomainOptions,
			blankIsotopicExclusionOptions
		},
		{
			columnPrimeInclusionDomainOptions,
			columnPrimeExclusionDomainOptions,
			columnPrimeIsotopicExclusionOptions
		},
		{
			columnFlushInclusionDomainOptions,
			columnFlushExclusionDomainOptions,
			columnFlushIsotopicExclusionOptions
		}
	}=Map[
		Function[{header}, Map[
			Function[{groupOfOptions},
				ToExpression[header<>ToString[#]]&/@groupOfOptions
			],
			{
				inclusionDomainOptions,
				exclusionDomainOptions,
				isotopicExclusionOptions
			}
		]],
		{"Standard","Blank","ColumnPrime","ColumnFlush"}
	];

	(*combine everything so that we know what all is depth 4*)
	depth4Options=Join[inclusionDomainOptions, exclusionDomainOptions, isotopicExclusionOptions, standardInclusionDomainOptions,
		standardExclusionDomainOptions, standardIsotopicExclusionOptions, blankInclusionDomainOptions, blankExclusionDomainOptions,
		blankIsotopicExclusionOptions];

	(*combine all of the options that we have so far*)
	combinedOptionsAssociation=Join[
		roundedOptionsAssociation,
		expandedStandardOptions,
		expandedBlankOptions,
		(*if these are singleton, we want to wrap in list*)
		AssociationThread[
			columnPrimeAcquisitionWindowMatchedOptions,
			ToList/@Lookup[roundedOptionsAssociation,columnPrimeAcquisitionWindowMatchedOptions]
		],
		AssociationThread[
			columnFlushAcquisitionWindowMatchedOptions,
			ToList/@Lookup[roundedOptionsAssociation,columnFlushAcquisitionWindowMatchedOptions]
		]
	];

	(*helper functions from brad to help get the unit pattern for each option*)
	firstPatternForDepthFour[Verbatim[Hold][Verbatim[Alternatives][Verbatim[Alternatives][Verbatim[Alternatives][x_, ___],Automatic], Null]]]:=Hold[x];

	(*define a unit pattern extractor for depth 4*)
	unitPatternDepth4Extractor:=Function[{optionName},
		(*first we grab the option definition pattern for this*)
		optionDefinition=FirstCase[OptionDefinition[ExperimentLCMS],KeyValuePattern["OptionName"->ToString[optionName]]];
		(*get the unit pattern*)
		firstPatternForDepthFour["SingletonPattern"/.optionDefinition]
	];

	(*first figure out if anything has a depth of 4*)
	{
		{
			inclusionDomainPositioning,
			inclusionMassPositioning,
			inclusionCollisionEnergyPositioning,
			inclusionDeclusteringVoltagePositioning,
			inclusionChargeStatePositioning,
			inclusionScanTimePositioning,
			exclusionDomainPositioning,
			exclusionMassPositioning,
			isotopicExclusionPositioning,
			isotopeRatioThresholdPositioning,
			isotopeDetectionMinimumPositioning
		},
		{
			inclusionDomainAutomatics,
			inclusionMassAutomatics,
			inclusionCollisionEnergyAutomatics,
			inclusionDeclusteringVoltageAutomatics,
			inclusionChargeStateAutomatics,
			inclusionScanTimeAutomatics,
			exclusionDomainAutomatics,
			exclusionMassAutomatics,
			isotopicExclusionAutomatics,
			isotopeRatioThresholdAutomatics,
			isotopeDetectionMinimumAutomatics
		}
	}=Transpose@Map[
		Function[{optionName},
			(*get the unit pattern*)
			unitPattern=unitPatternDepth4Extractor[optionName];
			(*get all of the positions within the passed options as well as the automatics*)
			{
				Position[Lookup[roundedOptionsAssociation,optionName],ReleaseHold@unitPattern],
				Position[Lookup[roundedOptionsAssociation,optionName],Automatic|Null]
			}
		],
		Join[inclusionDomainOptions,exclusionDomainOptions,isotopicExclusionOptions]
	];

	(*do the same with the standards and the blanks, if we need to. otherwise, just leave {1} in all of them as a place holder*)
	{
		{
			standardInclusionDomainPositioning,
			standardInclusionMassPositioning,
			standardInclusionCollisionEnergyPositioning,
			standardInclusionDeclusteringVoltagePositioning,
			standardInclusionChargeStatePositioning,
			standardInclusionScanTimePositioning,
			standardExclusionDomainPositioning,
			standardExclusionMassPositioning,
			standardIsotopicExclusionPositioning,
			standardIsotopeRatioThresholdPositioning,
			standardIsotopeDetectionMinimumPositioning
		},
		{
			standardInclusionDomainAutomatics,
			standardInclusionMassAutomatics,
			standardInclusionCollisionEnergyAutomatics,
			standardInclusionDeclusteringVoltageAutomatics,
			standardInclusionChargeStateAutomatics,
			standardInclusionScanTimeAutomatics,
			standardExclusionDomainAutomatics,
			standardExclusionMassAutomatics,
			standardIsotopicExclusionAutomatics,
			standardIsotopeRatioThresholdAutomatics,
			standardIsotopeDetectionMinimumAutomatics
		}
	}= If[standardExistQ,
		Transpose@Map[
			Function[{optionName},
				(*get the unit pattern for this option*)
				(*first we grab the option definition pattern for this*)
				optionDefinition=FirstCase[OptionDefinition[ExperimentLCMS],KeyValuePattern["OptionName"->ToString[optionName]]];
				(*get the unit pattern*)
				unitPattern=firstPatternForDepthFour["SingletonPattern"/.optionDefinition];
				(*get all of the positions within the passed options as well as the automatics*)
				{
					Position[Lookup[combinedOptionsAssociation,optionName],ReleaseHold@unitPattern],
					Position[Lookup[combinedOptionsAssociation,optionName],Automatic|Null]
				}
			],
			Join[standardInclusionDomainOptions, standardExclusionDomainOptions, standardIsotopicExclusionOptions]
		],
		(*if there are no standards, then we just have filler*)
		List[
			ConstantArray[{},11],
			ConstantArray[{},11]
		]
	];

	{
		{
			blankInclusionDomainPositioning,
			blankInclusionMassPositioning,
			blankInclusionCollisionEnergyPositioning,
			blankInclusionDeclusteringVoltagePositioning,
			blankInclusionChargeStatePositioning,
			blankInclusionScanTimePositioning,
			blankExclusionDomainPositioning,
			blankExclusionMassPositioning,
			blankIsotopicExclusionPositioning,
			blankIsotopeRatioThresholdPositioning,
			blankIsotopeDetectionMinimumPositioning
		},
		{
			blankInclusionDomainAutomatics,
			blankInclusionMassAutomatics,
			blankInclusionCollisionEnergyAutomatics,
			blankInclusionDeclusteringVoltageAutomatics,
			blankInclusionChargeStateAutomatics,
			blankInclusionScanTimeAutomatics,
			blankExclusionDomainAutomatics,
			blankExclusionMassAutomatics,
			blankIsotopicExclusionAutomatics,
			blankIsotopeRatioThresholdAutomatics,
			blankIsotopeDetectionMinimumAutomatics
		}
	}= If[blanksExistQ,
		Transpose@Map[
			Function[{optionName},
				(*get the unit pattern for this option*)
				(*first we grab the option definition pattern for this*)
				optionDefinition=FirstCase[OptionDefinition[ExperimentLCMS],KeyValuePattern["OptionName"->ToString[optionName]]];
				(*get the unit pattern*)
				unitPattern=firstPatternForDepthFour["SingletonPattern"/.optionDefinition];
				(*get all of the positions within the passed options as well as the automatics*)
				{
					Position[Lookup[combinedOptionsAssociation,optionName],ReleaseHold@unitPattern],
					Position[Lookup[combinedOptionsAssociation,optionName],Automatic|Null]
				}
			],
			Join[blankInclusionDomainOptions, blankExclusionDomainOptions, blankIsotopicExclusionOptions]
		],
		(*if there are no blanks, then we just have filler*)
		List[
			ConstantArray[{},11],
			ConstantArray[{},11]
		]
	];

	(*define some helper functions that will be used in the nested expansions*)
	getExpandedDimensions:=Function[{positioningSet,automaticsSet,currentIndex}, MapThread[
		Function[{basePatternPositions, automaticsPositions},
			Which[
				(*if there are both automatics and unit patterns, we combine*)
				MemberQ[basePatternPositions,{currentIndex,_,_}]||MemberQ[automaticsPositions,{currentIndex,_,_}],
				(
					combinedTuples=Cases[Join[basePatternPositions,automaticsPositions],{currentIndex,_,_}];
					Map[
						Max[Part[Cases[combinedTuples,{_,#,_}],All,3]]&,
						Range@Max[Part[combinedTuples,All,2]]
					]
				),
				MemberQ[basePatternPositions,{currentIndex,_}]||MemberQ[automaticsPositions,{currentIndex,_}],
				(
					combinedTuples=Cases[Join[basePatternPositions,automaticsPositions],{currentIndex,_}];
					(*in this case, we just care about the max*)
					ConstantArray[1,Max[Part[combinedTuples,All,2]]]
				),
				(*otherwise, it's just {1}*)
				True,{1}
			]
		],
		{positioningSet,automaticsSet}
	]];

	findMaximumDepth4Dimensions:=Function[{expandedDimensions}, If[MemberQ[expandedDimensions, {_, _, ___}],
		(*first pad all of the dimensions to the maximum length*)
		paddedDimensions = PadRight[#, Max[Length /@ expandedDimensions], 1]& /@ expandedDimensions;
		(*we should have a rectangular matrix now, and can just transpose and take the max at each*)
		Max /@ Transpose[paddedDimensions],
		{1}
	]];

	(*now we do our checking.*)
	(*if the max is just 1 then we don't need do anything here and can let the downstream take care of it*)
	performDepth4Expansion:=Function[{expandedDimensions,optionSet,maxExpansionConfiguration,currentIndex},
		If[MatchQ[maxExpansionConfiguration,{1}],
			(*if just 1, we just apply a list around if an automatic or Null; otherwise, we have to check the pattern *)
			MapThread[
				Function[{currentOption,optionName},
					Switch[currentOption,
						Automatic|Null,{currentOption},
						{Automatic}|{Null},currentOption,
						(*we check if it's the base pattern, in which case we want to wrap it in a list*)
						(*get the unit pattern*)
						ReleaseHold@unitPatternDepth4Extractor[optionName],{currentOption},
						_,currentOption
					]
				],
				{
					Lookup[combinedOptionsAssociation, optionSet][[All, currentIndex]],
					optionSet
				}
			],
			(*otherwise, we just expand and check that nothing is effed*)
			MapThread[
				Function[{currentDimensions,currentOption,optionName},
					Which[
						(*if it's the same as the max, nothing to do*)
						MatchQ[currentDimensions,maxExpansionConfiguration],currentOption,
						(*if it's just {1}, then we mirror the max*)
						MatchQ[currentDimensions,{1}],
						ExpandDimensions[ConstantArray[1,#]&/@maxExpansionConfiguration,currentOption],
						(*if the length is one and the max is longer, then we pad accordingly*)
						Length[currentDimensions]==1&&Length[maxExpansionConfiguration]>1,
						Which[
							(*if the dimension is the same as the length, then we expand each entry by the max dimensions*)
							First[currentDimensions]==Length[maxExpansionConfiguration],
							MapThread[Function[{eachOptionValue,max},
								ConstantArray[eachOptionValue,max]
							],
								{
									First[currentOption],
									maxExpansionConfiguration
								}
							],
							(*don't need to do anything if already expanded in the first element, just pad with Automatics*)
							First[currentDimensions]==First[maxExpansionConfiguration],
							Join[
								currentOption[[1]],
								ExpandDimensions[ConstantArray[1,#]&/@Rest[maxExpansionConfiguration],Automatic]
							],
							(*in any other case we have a conflict. just pad with automatics*)
							True,(
								Sow[optionName];
								Join[
									PadRight[First[currentOption],First[maxExpansionConfiguration],Automatic],
									ExpandDimensions[ConstantArray[1,#]&/@Rest[maxExpansionConfiguration],Automatic]
								]
							)
						],
						(*otherwise map through and check if we have conflicts*)
						True,
						MapThread[
							Function[{current,max,currentIndex},
								Which[
									(*first check if the current index within the length; otherwise, we note a conflict and just leave automatics*)
									currentIndex>Length[currentDimensions],(
										Sow[optionName];
										If[max>1, ConstantArray[Automatic,max],Automatic]
									),
									(*if the current is just 1, then we expand to the max*)
									current==1, If[max>1,ConstantArray[currentOption[[currentIndex]],max],currentOption[[currentIndex]]],
									(*otherwise check if it's the same length, in which case, don't do anything*)
									current==max, currentOption[[currentIndex]],
									(*in any other case we have a conflict. we flag it, but we have to pad to the max; otherwise, we'll have downstream problems*)
									True,(
										Sow[optionName];
										PadRight[currentOption[[currentIndex]],max,Automatic]
									)
								]
							],
							{PadRight[currentDimensions,Length[maxExpansionConfiguration],1], maxExpansionConfiguration, Range@Length[maxExpansionConfiguration]}
						]
					]
				],
				List[
					expandedDimensions,
					Lookup[combinedOptionsAssociation,optionSet][[All,currentIndex]],
					optionSet
				]
			]
		]
	];

	(*we do an initial expansion across the different samples for the inclusion options*)
	{
		inclusionDomainInitialExpansion,
		inclusionMassInitialExpansion,
		inclusionCollisionEnergyInitialExpansion,
		inclusionDeclusteringVoltageInitialExpansion,
		inclusionChargeStateInitialExpansion,
		inclusionScanTimeInitialExpansion,
		exclusionDomainInitialExpansion,
		exclusionMassInitialExpansion,
		isotopicExclusionInitialExpansion,
		isotopeRatioThresholdInitialExpansion,
		isotopeDetectionMinimumInitialExpansion
	}=Transpose@Map[
		Function[{index},
			(*we try to figure out the expanded shape that should be taken if these are expanded *)
			(*e.g. {{1, 1, 1}, {1, 1, 2}, {1, 2, 1}, {1, 2, 3}, {1, 2, 2}} will go to {2,3} means that for current sample, it's split twice (indicated by the comma) and two times in the first position and three times in the second*)
			{
				expandedDimensionsInclusion,
				expandedDimensionsExclusion,
				expandedDimensionsIsotope
			}=MapThread[
				getExpandedDimensions,
				{
					{
						{
							inclusionDomainPositioning,
							inclusionMassPositioning,
							inclusionCollisionEnergyPositioning,
							inclusionDeclusteringVoltagePositioning,
							inclusionChargeStatePositioning,
							inclusionScanTimePositioning
						},
						{
							exclusionDomainPositioning,
							exclusionMassPositioning
						},
						{
							isotopicExclusionPositioning,
							isotopeRatioThresholdPositioning,
							isotopeDetectionMinimumPositioning
						}
					},
					{
						{
							inclusionDomainAutomatics,
							inclusionMassAutomatics,
							inclusionCollisionEnergyAutomatics,
							inclusionDeclusteringVoltageAutomatics,
							inclusionChargeStateAutomatics,
							inclusionScanTimeAutomatics
						},
						{
							exclusionDomainAutomatics,
							exclusionMassAutomatics
						},
						{
							isotopicExclusionAutomatics,
							isotopeRatioThresholdAutomatics,
							isotopeDetectionMinimumAutomatics
						}
					},
					{
						index,
						index,
						index
					}
				}
			];

			(*find the maximum expansion among all of the optiosn*)
			{
				maxExpansionConfigurationInclusion,
				maxExpansionConfigurationExclusion,
				maxExpansionConfigurationIsotope
			}= findMaximumDepth4Dimensions/@{
				expandedDimensionsInclusion,
				expandedDimensionsExclusion,
				expandedDimensionsIsotope
			};

			initialExpansion=MapThread[
				performDepth4Expansion,
				{
					{
						expandedDimensionsInclusion,
						expandedDimensionsExclusion,
						expandedDimensionsIsotope
					},
					{
						inclusionDomainOptions,
						exclusionDomainOptions,
						isotopicExclusionOptions
					},
					{
						maxExpansionConfigurationInclusion,
						maxExpansionConfigurationExclusion,
						maxExpansionConfigurationIsotope
					},
					{
						index,
						index,
						index
					}
				}
			];

			(*put these together*)
			Join@@initialExpansion
		],
		Range[Length@ToList[mySamples]]
	];

	(*do the same for the standards and the blanks*)
	{
		standardInclusionDomainInitialExpansion,
		standardInclusionMassInitialExpansion,
		standardInclusionCollisionEnergyInitialExpansion,
		standardInclusionDeclusteringVoltageInitialExpansion,
		standardInclusionChargeStateInitialExpansion,
		standardInclusionScanTimeInitialExpansion,
		standardExclusionDomainInitialExpansion,
		standardExclusionMassInitialExpansion,
		standardIsotopicExclusionInitialExpansion,
		standardIsotopeRatioThresholdInitialExpansion,
		standardIsotopeDetectionMinimumInitialExpansion
	}= If[standardExistQ,
		Transpose@Map[
			Function[{index},
				(*we try to figure out the expanded shape that should be taken if these are expanded *)
				(*e.g. {{1, 1, 1}, {1, 1, 2}, {1, 2, 1}, {1, 2, 3}, {1, 2, 2}} will go to {2,3} means that for current sample, it's split twice (indicated by the comma) and two times in the first position and three times in the second*)
				{
					expandedStandardDimensionsInclusion,
					expandedStandardDimensionsExclusion,
					expandedStandardDimensionsIsotope
				}=MapThread[
					getExpandedDimensions,
					{
						{
							{
								standardInclusionDomainPositioning,
								standardInclusionMassPositioning,
								standardInclusionCollisionEnergyPositioning,
								standardInclusionDeclusteringVoltagePositioning,
								standardInclusionChargeStatePositioning,
								standardInclusionScanTimePositioning
							},
							{
								standardExclusionDomainPositioning,
								standardExclusionMassPositioning
							},
							{
								standardIsotopicExclusionPositioning,
								standardIsotopeRatioThresholdPositioning,
								standardIsotopeDetectionMinimumPositioning
							}
						},
						{
							{
								standardInclusionDomainAutomatics,
								standardInclusionMassAutomatics,
								standardInclusionCollisionEnergyAutomatics,
								standardInclusionDeclusteringVoltageAutomatics,
								standardInclusionChargeStateAutomatics,
								standardInclusionScanTimeAutomatics
							},
							{
								standardExclusionDomainAutomatics,
								standardExclusionMassAutomatics
							},
							{
								standardIsotopicExclusionAutomatics,
								standardIsotopeRatioThresholdAutomatics,
								standardIsotopeDetectionMinimumAutomatics
							}
						},
						{
							index,
							index,
							index
						}
					}
				];

				(*find the maximum expansion among all of the optiosn*)
				{
					maxStandardExpansionConfigurationInclusion,
					maxStandardExpansionConfigurationExclusion,
					maxStandardExpansionConfigurationIsotope
				}= findMaximumDepth4Dimensions/@{
					expandedStandardDimensionsInclusion,
					expandedStandardDimensionsExclusion,
					expandedStandardDimensionsIsotope
				};

				initialExpansion=MapThread[
					performDepth4Expansion,
					{
						{
							expandedStandardDimensionsInclusion,
							expandedStandardDimensionsExclusion,
							expandedStandardDimensionsIsotope
						},
						{
							standardInclusionDomainOptions,
							standardExclusionDomainOptions,
							standardIsotopicExclusionOptions
						},
						{
							maxStandardExpansionConfigurationInclusion,
							maxStandardExpansionConfigurationExclusion,
							maxStandardExpansionConfigurationIsotope
						},
						{
							index,
							index,
							index
						}
					}
				];

				(*put these together*)
				Join@@initialExpansion
			],
			Range[Length@ToList[resolvedStandard]]
		],
		ConstantArray[Null,11]
	];

	{
		blankInclusionDomainInitialExpansion,
		blankInclusionMassInitialExpansion,
		blankInclusionCollisionEnergyInitialExpansion,
		blankInclusionDeclusteringVoltageInitialExpansion,
		blankInclusionChargeStateInitialExpansion,
		blankInclusionScanTimeInitialExpansion,
		blankExclusionDomainInitialExpansion,
		blankExclusionMassInitialExpansion,
		blankIsotopicExclusionInitialExpansion,
		blankIsotopeRatioThresholdInitialExpansion,
		blankIsotopeDetectionMinimumInitialExpansion
	}= If[blanksExistQ,
		Transpose@Map[
			Function[{index},
				(*we try to figure out the expanded shape that should be taken if these are expanded *)
				(*e.g. {{1, 1, 1}, {1, 1, 2}, {1, 2, 1}, {1, 2, 3}, {1, 2, 2}} will go to {2,3} means that for current sample, it's split twice (indicated by the comma) and two times in the first position and three times in the second*)
				{
					expandedBlankDimensionsInclusion,
					expandedBlankDimensionsExclusion,
					expandedBlankDimensionsIsotope
				}=MapThread[
					getExpandedDimensions,
					{
						{
							{
								blankInclusionDomainPositioning,
								blankInclusionMassPositioning,
								blankInclusionCollisionEnergyPositioning,
								blankInclusionDeclusteringVoltagePositioning,
								blankInclusionChargeStatePositioning,
								blankInclusionScanTimePositioning
							},
							{
								blankExclusionDomainPositioning,
								blankExclusionMassPositioning
							},
							{
								blankIsotopicExclusionPositioning,
								blankIsotopeRatioThresholdPositioning,
								blankIsotopeDetectionMinimumPositioning
							}
						},
						{
							{
								blankInclusionDomainAutomatics,
								blankInclusionMassAutomatics,
								blankInclusionCollisionEnergyAutomatics,
								blankInclusionDeclusteringVoltageAutomatics,
								blankInclusionChargeStateAutomatics,
								blankInclusionScanTimeAutomatics
							},
							{
								blankExclusionDomainAutomatics,
								blankExclusionMassAutomatics
							},
							{
								blankIsotopicExclusionAutomatics,
								blankIsotopeRatioThresholdAutomatics,
								blankIsotopeDetectionMinimumAutomatics
							}
						},
						{
							index,
							index,
							index
						}
					}
				];

				(*find the maximum expansion among all of the optiosn*)
				{
					maxBlankExpansionConfigurationInclusion,
					maxBlankExpansionConfigurationExclusion,
					maxBlankExpansionConfigurationIsotope
				}= findMaximumDepth4Dimensions/@{
					expandedBlankDimensionsInclusion,
					expandedBlankDimensionsExclusion,
					expandedBlankDimensionsIsotope
				};

				initialExpansion=MapThread[
					performDepth4Expansion,
					{
						{
							expandedBlankDimensionsInclusion,
							expandedBlankDimensionsExclusion,
							expandedBlankDimensionsIsotope
						},
						{
							blankInclusionDomainOptions,
							blankExclusionDomainOptions,
							blankIsotopicExclusionOptions
						},
						{
							maxBlankExpansionConfigurationInclusion,
							maxBlankExpansionConfigurationExclusion,
							maxBlankExpansionConfigurationIsotope
						},
						{
							index,
							index,
							index
						}
					}
				];

				(*put these together*)
				Join@@initialExpansion
			],
			Range[Length@ToList[resolvedBlank]]
		],
		ConstantArray[Null,11]
	];

	(*delineate everything that's index matched to Acquisition mode, all of the depth=3 options*)
	acquisitionModeIndexMatchedOptions={
		(*1*)AcquisitionWindow,
		(*2*)AcquisitionMode,
		(*3*)Fragment,
		(*4*)MassDetection,
		(*5*)ScanTime,
		(*6*)FragmentMassDetection,
		(*7*)CollisionEnergy,
		(*8*)CollisionEnergyMassProfile,
		(*9*)CollisionEnergyMassScan,
		(*10*)FragmentScanTime,
		(*11*)AcquisitionSurvey,
		(*12*)MinimumThreshold,
		(*13*)AcquisitionLimit,
		(*14*)CycleTimeLimit,
		(*15*)ExclusionDomain,
		(*16*)ExclusionMass,
		(*17*)ExclusionMassTolerance,
		(*18*)ExclusionRetentionTimeTolerance,
		(*19*)InclusionDomain,
		(*20*)InclusionMass,
		(*21*)InclusionCollisionEnergy,
		(*22*)InclusionDeclusteringVoltage,
		(*23*)InclusionChargeState,
		(*24*)InclusionScanTime,
		(*25*)InclusionMassTolerance,
		(*26*)SurveyChargeStateExclusion,
		(*27*)SurveyIsotopeExclusion,
		(*28*)ChargeStateExclusionLimit,
		(*29*)ChargeStateExclusion,
		(*30*)ChargeStateMassTolerance,
		(*31*)IsotopicExclusion,
		(*32*)IsotopeRatioThreshold,
		(*33*)IsotopeDetectionMinimum,
		(*34*)IsotopeMassTolerance,
		(*35*)IsotopeRatioTolerance,
		(*36*)NeutralLoss,
		(*37*)DwellTime,
		(*38*)CollisionCellExitVoltage,
		(*39*)MassDetectionStepSize,
		(*40*)MultipleReactionMonitoringAssays
	};
	
	(*make the blank and standard version of these options*)
	standardAcquisitionModeIndexMatchedOptions=Map[ToExpression["Standard"<>ToString[#]]&,acquisitionModeIndexMatchedOptions];
	blankAcquisitionModeIndexMatchedOptions=Map[ToExpression["Blank"<>ToString[#]]&,acquisitionModeIndexMatchedOptions];

	(*not all of these options are allownull -> True, so we need both a non-Null and Null version*)
	noNullExtractorDepth3[ Verbatim[Hold][Verbatim[Alternatives][Verbatim[Alternatives][x_, ___], Automatic]]] := Hold[x];
	withNullExtractorDepth3[Verbatim[Hold][Verbatim[Alternatives][Verbatim[Alternatives][Verbatim[Alternatives][x_, ___],Automatic],Null]]] := Hold[x];


	(*define a unit pattern extractor for depth 3*)
	unitPatternDepth3Extractor:=Function[{optionName},
		(*first we grab the option definition pattern for this*)
		optionDefinition=FirstCase[OptionDefinition[ExperimentLCMS],KeyValuePattern["OptionName"->ToString[optionName]]];
		(*check whether it's allow null true or not and that dictates the pattern extractor used*)
		allowNullQ="AllowNull"/.optionDefinition;
		(*get the unit pattern*)
		If[allowNullQ,
			withNullExtractorDepth3["SingletonPattern"/.optionDefinition],
			noNullExtractorDepth3["SingletonPattern"/.optionDefinition]
		]
	];

	(*we also need to pre expand if the customer provided a Mass Acquisiton method. We check if everything is automatic or the right length*)

	(*this is will work if everything is either Automatic, UnitPattern, or {UnitPattern..} with the later as the same length as what's in the method*)
	(*we'll update the acquisition window if so because we want everything expanded accordingly*)

	expandAcquisitionWindowByMethod:=Function[{currentAcquisitionWindow,massAcquisitionMethod,currentIndex,currentType},
		(*first we check if we have a method*)
		If[MatchQ[massAcquisitionMethod,ObjectP[]],
			(
				(*get the packet for the acquisition method*)
				currentMassAcquisitionMethodPacket=fetchPacketFromFastAssoc[Download[massAcquisitionMethod,Object],simulationFastAssoc];
				(*get the acquisition window in the method and convert to the native format for the resolver*)
				acquisitionMethodFromMethod={StartTime, EndTime} /.Lookup[currentMassAcquisitionMethodPacket,AcquisitionWindows];
				(*get the length*)
				acquisitionMethodFromMethodLength=Length@acquisitionMethodFromMethod;
				(*first check whether it's safe to expand, i.e. everything is is Automatic, UnitPattern or {UnitPattern..} of the same length*)
				allesInOrdnungQ=And@@Map[
					MatchQ[Part[Lookup[combinedOptionsAssociation,#],currentIndex],Alternatives[
						Automatic,
						Null,
						ReleaseHold@unitPatternDepth3Extractor[#],
						ConstantArray[Automatic,acquisitionMethodFromMethodLength],
						ConstantArray[Null,acquisitionMethodFromMethodLength],
						ConstantArray[ReleaseHold@unitPatternDepth3Extractor[#],acquisitionMethodFromMethodLength]
					]]&,
					Switch[currentType,
						Standard,standardAcquisitionModeIndexMatchedOptions,
						Blank,blankAcquisitionModeIndexMatchedOptions,
						ColumnPrime,columnPrimeAcquisitionWindowMatchedOptions,
						ColumnFlush,columnFlushAcquisitionWindowMatchedOptions,
						_,acquisitionModeIndexMatchedOptions
					]
				];
				(*if everything is okay and the acquisition window is automatic, then we supply it*)
				If[allesInOrdnungQ&&MatchQ[currentAcquisitionWindow,ListableP[Automatic]],
					Span@@@acquisitionMethodFromMethod,
					(*otherwise we have some incongruence, and unfortunately we have to just marshall through later*)
					currentAcquisitionWindow
				]
			),
			(*if we don't have an acquisition method then we keep samesies*)
			currentAcquisitionWindow
		]
	];

	acquisitionWindowExpandedByMethod=MapThread[
		expandAcquisitionWindowByMethod,
		{
			Lookup[combinedOptionsAssociation,AcquisitionWindow],
			bestSamplesMassSpecMethods,
			Range[Length@mySamples],
			ConstantArray[Sample,Length@mySamples]
		}
	];

	(*get the current acquisition windows*)
	currentColumnPrimeAcquisitionWindow=Lookup[combinedOptionsAssociation,ColumnPrimeAcquisitionWindow];
	currentColumnFlushAcquisitionWindow=Lookup[combinedOptionsAssociation,ColumnFlushAcquisitionWindow];

	(*do the same with the standards, blanks, prime, and flushes*)
	{
		standardAcquisitionWindowExpandedByMethod,
		blankAcquisitionWindowExpandedByMethod,
		{columnPrimeAcquisitionWindowExpandedByMethod},
		{columnFlushAcquisitionWindowExpandedByMethod}
	}=Map[Function[{entry},
			(*first we check whether to continue or return early*)
		  {continueQ,mapThreadVariables}=entry;

			If[!continueQ,
				(*if we're not continueing just return the acquisition windows as is*)
				First@mapThreadVariables,
				(*otherwise we take from the method*)
				MapThread[expandAcquisitionWindowByMethod,mapThreadVariables]
			]
		],
		{
			(*standards*)
			{
				standardExistQ,
				{
					Lookup[combinedOptionsAssociation,StandardAcquisitionWindow],
					bestStandardsMassSpecMethods,
					If[standardExistQ, Range[Length@resolvedStandard]],
					ConstantArray[Standard,Length@resolvedStandard]
				}
			},
			(*blanks*)
			{
				blanksExistQ,
				{
					Lookup[combinedOptionsAssociation,BlankAcquisitionWindow],
					bestBlanksMassSpecMethods,
					If[blanksExistQ, Range[Length@resolvedBlank]],
					ConstantArray[Blank,Length@resolvedBlank]
				}
			},
			(*prime*)
			{
				columnPrimeQ,
				{
					(*we check if the prime acquisition is already expanded, if so we wrap in a list*)
					If[MatchQ[currentColumnPrimeAcquisitionWindow,{_,__}],{currentColumnPrimeAcquisitionWindow},currentColumnPrimeAcquisitionWindow],
					bestColumnPrimeMassSpecMethods,
					{1},
					{ColumnPrime}
				}
			},
			(*flush*)
			{
				columnFlushQ,
				{
					If[MatchQ[currentColumnFlushAcquisitionWindow,{_,__}],{currentColumnFlushAcquisitionWindow},currentColumnFlushAcquisitionWindow],
					bestColumnFlushMassSpecMethods,
					{1},
					{ColumnFlush}
				}
			}
		}
	];

	(*if the column prime or flush were supplied, we have to reexpand*)
	columnPrimeOptionsExpandedByMethod=If[
		!MatchQ[ToList@columnPrimeAcquisitionWindowExpandedByMethod,Lookup[combinedOptionsAssociation,ColumnPrimeAcquisitionWindow]],
		Association@Last[ExpandIndexMatchedInputs[
			ExperimentLCMS,
			{mySamples},
			Normal@Append[
				KeyTake[roundedOptionsAssociation,columnPrimeAcquisitionWindowMatchedOptions],
				ColumnPrimeAcquisitionWindow -> columnPrimeAcquisitionWindowExpandedByMethod
			],
			Messages -> False
		]],
		Association[]
	];

	columnFlushOptionsExpandedByMethod=If[
		!MatchQ[ToList@columnFlushAcquisitionWindowExpandedByMethod,Lookup[combinedOptionsAssociation,ColumnFlushAcquisitionWindow]],
		Association@Last[ExpandIndexMatchedInputs[
			ExperimentLCMS,
			{mySamples},
			Normal@Append[
				KeyTake[roundedOptionsAssociation,columnFlushAcquisitionWindowMatchedOptions],
				ColumnFlushAcquisitionWindow -> columnFlushAcquisitionWindowExpandedByMethod
			],
			Messages -> False
		]],
		Association[]
	];

	(*make an updated option association with these*)
	initialExpansionAssociation=Join[
		combinedOptionsAssociation,
		Association[
			AcquisitionWindow -> acquisitionWindowExpandedByMethod,
			InclusionDomain -> inclusionDomainInitialExpansion,
			InclusionMass -> inclusionMassInitialExpansion,
			InclusionCollisionEnergy -> inclusionCollisionEnergyInitialExpansion,
			InclusionDeclusteringVoltage -> inclusionDeclusteringVoltageInitialExpansion,
			InclusionChargeState -> inclusionChargeStateInitialExpansion,
			InclusionScanTime -> inclusionScanTimeInitialExpansion,
			ExclusionDomain -> exclusionDomainInitialExpansion,
			ExclusionMass -> exclusionMassInitialExpansion,
			IsotopicExclusion -> isotopicExclusionInitialExpansion,
			IsotopeRatioThreshold -> isotopeRatioThresholdInitialExpansion,
			IsotopeDetectionMinimum -> isotopeDetectionMinimumInitialExpansion,
			StandardAcquisitionWindow -> standardAcquisitionWindowExpandedByMethod,
			StandardInclusionDomain -> standardInclusionDomainInitialExpansion,
			StandardInclusionMass -> standardInclusionMassInitialExpansion,
			StandardInclusionCollisionEnergy -> standardInclusionCollisionEnergyInitialExpansion,
			StandardInclusionDeclusteringVoltage -> standardInclusionDeclusteringVoltageInitialExpansion,
			StandardInclusionChargeState -> standardInclusionChargeStateInitialExpansion,
			StandardInclusionScanTime -> standardInclusionScanTimeInitialExpansion,
			StandardExclusionDomain -> standardExclusionDomainInitialExpansion,
			StandardExclusionMass -> standardExclusionMassInitialExpansion,
			StandardIsotopicExclusion -> standardIsotopicExclusionInitialExpansion,
			StandardIsotopeRatioThreshold -> standardIsotopeRatioThresholdInitialExpansion,
			StandardIsotopeDetectionMinimum -> standardIsotopeDetectionMinimumInitialExpansion,
			BlankAcquisitionWindow -> blankAcquisitionWindowExpandedByMethod,
			BlankInclusionDomain -> blankInclusionDomainInitialExpansion,
			BlankInclusionMass -> blankInclusionMassInitialExpansion,
			BlankInclusionCollisionEnergy -> blankInclusionCollisionEnergyInitialExpansion,
			BlankInclusionDeclusteringVoltage -> blankInclusionDeclusteringVoltageInitialExpansion,
			BlankInclusionChargeState -> blankInclusionChargeStateInitialExpansion,
			BlankInclusionScanTime -> blankInclusionScanTimeInitialExpansion,
			BlankExclusionDomain -> blankExclusionDomainInitialExpansion,
			BlankExclusionMass -> blankExclusionMassInitialExpansion,
			BlankIsotopicExclusion -> blankIsotopicExclusionInitialExpansion,
			BlankIsotopeRatioThreshold -> blankIsotopeRatioThresholdInitialExpansion,
			BlankIsotopeDetectionMinimum -> blankIsotopeDetectionMinimumInitialExpansion
		],
		columnPrimeOptionsExpandedByMethod,
		columnFlushOptionsExpandedByMethod
	];

	(*now we can focus on depth=3 options*)

	(*define our pattern extractors*)

	(*we make a function for the getting the value positions because sometimes a unit pattern might have multiple entities that match the unit pattern*)
	(*for example a span pattern would match the singleton pattern twice, and in this case, we only want to match the span pattern and leave out for consideration*)
	findDepth3Positions:=Function[{optionValue,currentUnitPattern},
		(*if there are multiple entities in the unit pattern, we first split into individual holds*)
		(*e.g. Hold[Alternatives[pattern1,pattern2]] becomes List[Hold[pattern1],Hold[pattern2]]*)

		(*all of the logic is only necessary if we have a list of alternatives, so we check that first*)
		alternativesQ=MatchQ[currentUnitPattern,Verbatim[Hold][Alternatives[_]]];

		(*convert the alternatives to a list if it's an alternative of stuff*)
		listedPattern=If[alternativesQ,
			ToList@Thread[List@@@currentUnitPattern],
			currentUnitPattern
		];

		(*check if we have span inside, in which case, we continue on*)
		spanInsideQ=If[alternativesQ,
			MemberQ[listedPattern, Verbatim[Hold][Span[_, _]]],
			False
		];

		(*if we don't have any spans then we return all the positions*)
		If[!spanInsideQ,
			Position[optionValue,ReleaseHold@currentUnitPattern],
			(
				(*otherwise more logic*)
				(*we then see if we have a span inside. those are the top ranking patterns, and we want to consider them before any singletons*)
				spanPatternCases=Cases[listedPattern, Verbatim[Hold][Span[_, _]]];

				(*first get the span positions*)
				spanPositions = Position[optionValue, Alternatives@@ReleaseHold[spanPatternCases]];

				(*replace out anything found with an Automatic (really it's just a placeholder)*)
				replacedSpans=ReplacePart[optionValue,Map[Rule[#,Automatic]&,spanPositions]];

				(*get the positions of anything else remaining*)
				remainingCases=Complement[listedPattern,spanPatternCases];
				remainingPositions=Position[replacedSpans, Alternatives@@ReleaseHold[remainingCases]];

				(*return all of the positions*)
				Join[spanPositions, remainingPositions]
			)
		]
	];

	(*grab the unit pattern and automatic positioning*)
	{
		matchedAcquisitionModeOptionsPositioning,
		matchedAcquisitionModeOptionsAutomatics
	}=Transpose@Map[
		Function[{optionName},
			(*get the unit pattern for this option*)
			unitPattern=unitPatternDepth3Extractor[optionName];

			(*get all of the positions within the passed options as well as the automatics*)
			{
				findDepth3Positions[Lookup[initialExpansionAssociation,optionName],unitPattern],
				Position[Lookup[initialExpansionAssociation,optionName],Automatic|Null]
			}
		],
		acquisitionModeIndexMatchedOptions
	];

	(*do the same with the standards and blanks, as needed*)
	{
		matchedStandardAcquisitionModeOptionsPositioning,
		matchedStandardAcquisitionModeOptionsAutomatics
	}= If[standardExistQ, Transpose@Map[
			Function[{optionName},
				(*get the unit pattern for this option*)
				unitPattern=unitPatternDepth3Extractor[optionName];
				(*get all of the positions within the passed options as well as the automatics*)
				{
					findDepth3Positions[Lookup[initialExpansionAssociation,optionName],unitPattern],
					Position[Lookup[initialExpansionAssociation,optionName],Automatic|Null]
				}
			],
			standardAcquisitionModeIndexMatchedOptions
		],
		List[
			ConstantArray[{},Length@standardAcquisitionModeIndexMatchedOptions],
			ConstantArray[{},Length@standardAcquisitionModeIndexMatchedOptions]
		]
	];

	{
		matchedBlankAcquisitionModeOptionsPositioning,
		matchedBlankAcquisitionModeOptionsAutomatics
	}= If[blanksExistQ, Transpose@Map[
			Function[{optionName},
				(*get the unit pattern for this option*)
				unitPattern=unitPatternDepth3Extractor[optionName];
				(*get all of the positions within the passed options as well as the automatics*)
				{
					findDepth3Positions[Lookup[initialExpansionAssociation,optionName],unitPattern],
					Position[Lookup[initialExpansionAssociation,optionName],Automatic|Null]
				}
			],
			blankAcquisitionModeIndexMatchedOptions
		],
		List[
			ConstantArray[{},Length@blankAcquisitionModeIndexMatchedOptions],
			ConstantArray[{},Length@blankAcquisitionModeIndexMatchedOptions]
		]
	];

	(*note all the depth 3 column options*)
	depth3ColumnOptions=Join[
		columnPrimeInclusionDomainOptions,
		columnPrimeExclusionDomainOptions,
		columnPrimeIsotopicExclusionOptions,
		columnFlushInclusionDomainOptions,
		columnFlushExclusionDomainOptions,
		columnFlushIsotopicExclusionOptions
	];

	(*there's an edge case, where if it's depth 3 and List[unitPattern..], then the positioning doesn't account for the depth*)
	(*so we make deeper in such a case*)
	columnFurtherExpansionAssociation=Association@KeyValueMap[
		Function[{key,value},
			If[MemberQ[depth3ColumnOptions,key],
				(
					unitPattern=unitPatternDepth3Extractor[key];
					Switch[value,
						List[ReleaseHold[unitPattern],ReleaseHold[unitPattern]..], Rule[key,List[value]],
						ReleaseHold[unitPattern],Rule[key,List[value]],
						_, Rule[key,value]
					]
				),
				Rule[key,value]
			]
		],
		initialExpansionAssociation
	];

	{
		{
			columnPrimeInclusionDomainPositioning,
			columnPrimeInclusionMassPositioning,
			columnPrimeInclusionCollisionEnergyPositioning,
			columnPrimeInclusionDeclusteringVoltagePositioning,
			columnPrimeInclusionChargeStatePositioning,
			columnPrimeInclusionScanTimePositioning,
			columnPrimeExclusionDomainPositioning,
			columnPrimeExclusionMassPositioning,
			columnPrimeIsotopicExclusionPositioning,
			columnPrimeIsotopeRatioThresholdPositioning,
			columnPrimeIsotopeDetectionMinimumPositioning
		},
		{
			columnPrimeInclusionDomainAutomatics,
			columnPrimeInclusionMassAutomatics,
			columnPrimeInclusionCollisionEnergyAutomatics,
			columnPrimeInclusionDeclusteringVoltageAutomatics,
			columnPrimeInclusionChargeStateAutomatics,
			columnPrimeInclusionScanTimeAutomatics,
			columnPrimeExclusionDomainAutomatics,
			columnPrimeExclusionMassAutomatics,
			columnPrimeIsotopicExclusionAutomatics,
			columnPrimeIsotopeRatioThresholdAutomatics,
			columnPrimeIsotopeDetectionMinimumAutomatics
		}
	}= If[columnPrimeQ,
		Transpose@Map[
			Function[{optionName},
				(*get the unit pattern for this option*)
				unitPattern=unitPatternDepth3Extractor[optionName];
				(*get all of the positions within the passed options as well as the automatics*)
				{
					(*there's an edge case, where if it's depth 3 and List[unitPattern..], then the positioning doesn't account for the depth*)
					(*so we make deeper in such a case*)
					findDepth3Positions[Lookup[columnFurtherExpansionAssociation,optionName],unitPattern],
					Position[Lookup[columnFurtherExpansionAssociation,optionName],Automatic|Null]
				}
			],
			Join[
				columnPrimeInclusionDomainOptions,
				columnPrimeExclusionDomainOptions,
				columnPrimeIsotopicExclusionOptions
			]
		],
		(*if there is no column prime, then we just have filler*)
		List[
			ConstantArray[{},11],
			ConstantArray[{},11]
		]
	];

	{
		{
			columnFlushInclusionDomainPositioning,
			columnFlushInclusionMassPositioning,
			columnFlushInclusionCollisionEnergyPositioning,
			columnFlushInclusionDeclusteringVoltagePositioning,
			columnFlushInclusionChargeStatePositioning,
			columnFlushInclusionScanTimePositioning,
			columnFlushExclusionDomainPositioning,
			columnFlushExclusionMassPositioning,
			columnFlushIsotopicExclusionPositioning,
			columnFlushIsotopeRatioThresholdPositioning,
			columnFlushIsotopeDetectionMinimumPositioning
		},
		{
			columnFlushInclusionDomainAutomatics,
			columnFlushInclusionMassAutomatics,
			columnFlushInclusionCollisionEnergyAutomatics,
			columnFlushInclusionDeclusteringVoltageAutomatics,
			columnFlushInclusionChargeStateAutomatics,
			columnFlushInclusionScanTimeAutomatics,
			columnFlushExclusionDomainAutomatics,
			columnFlushExclusionMassAutomatics,
			columnFlushIsotopicExclusionAutomatics,
			columnFlushIsotopeRatioThresholdAutomatics,
			columnFlushIsotopeDetectionMinimumAutomatics
		}
	}= If[columnFlushQ,
		Transpose@Map[
			Function[{optionName},
				(*get the unit pattern for this option*)
				unitPattern=unitPatternDepth3Extractor[optionName];
				(*get all of the positions within the passed options as well as the automatics*)
				{
					findDepth3Positions[Lookup[columnFurtherExpansionAssociation,optionName],unitPattern],
					Position[Lookup[columnFurtherExpansionAssociation,optionName],Automatic|Null]
				}
			],
			Join[
				columnFlushInclusionDomainOptions,
				columnFlushExclusionDomainOptions,
				columnFlushIsotopicExclusionOptions
			]
		],
		(*if there is no column flush, then we just have filler*)
		List[
			ConstantArray[{},11],
			ConstantArray[{},11]
		]
	];

	(*make the depth 3 version of the functions that we need*)
	getExpandedDimensionsDepth3:=Function[{basePatternPositions, automaticsPositions, currentIndex},
		(*just join everything and figure out everything relevant for the current index*)
		relevantCases=Cases[Join[basePatternPositions,automaticsPositions],{currentIndex,_,___}];
		(*check whether we have expansion in the relevant cases*)
		If[Length[relevantCases]>0,
			Max[#[[2]]&/@relevantCases],
			1
		]
	];

	(*it's a little different for column prime and flush because of the lack of indexing*)
	getExpandedDimensionsDepth3Columns:=Function[{basePatternPositions, automaticsPositions, acquisitionIndex},
		(*just join everything and figure out everything relevant for the current index*)
		relevantCases=Cases[Join[basePatternPositions,automaticsPositions],{acquisitionIndex,_,___}];
		(*check whether we have expansion in the relevant cases*)
		If[Length[relevantCases]>0,
			Max[#[[2]]&/@relevantCases],
			1
		]
	];

	performDepth3Expansion:=Function[{currentDimension,currentOption,optionName,maxDimensionHere},
		Which[
			(*
				there's a chance that it's already expanded (for example, if it's a depth 4 field with length 1).
				We want to take the first before expansion, if that's the case
				TODO: not sure if I want to consider this case
			*)
			MatchQ[currentOption,List@List[ReleaseHold@unitPatternDepth3Extractor[optionName]]],ConstantArray[First@currentOption,maxDimensionHere],
			(*check if it's already listed and depth 3, in which case we just expand out*)
			!MemberQ[depth4Options,optionName]&&MatchQ[currentOption,List[ReleaseHold@unitPatternDepth3Extractor[optionName]]],ConstantArray[First@currentOption,maxDimensionHere],
			(*if the current is 1, then we expand to the MAXXX*)
			currentDimension==1,ConstantArray[currentOption,maxDimensionHere],
			(*we might have a depth 4 field that may need another level of listiness*)
			(*we check that edge case*)
			currentDimension==maxDimensionHere&&MemberQ[depth4Options,optionName]&&MatchQ[currentOption,List[(ReleaseHold@unitPatternDepth4Extractor[optionName])..]],
				List/@currentOption,
			(*otherwise, if its the same, do nothing*)
			currentDimension==maxDimensionHere, currentOption,
			(*otherwise, we have a kerfuffle and just pad out with Automatics and note a conflict*)
			True,(
				Sow[optionName];
				PadRight[ToList@currentOption,maxDimensionHere,Automatic]
			)
		]
	];

	(*bit different for columns given their singleton nature*)
	performDepth3ExpansionColumns:=Function[{currentDimension,currentOption,optionName,maxDimensionHere},
		Which[
			(*if already listed, expand out*)
			currentDimension==1&&MatchQ[currentOption,List[(ReleaseHold@unitPatternDepth3Extractor[optionName])]],ConstantArray[First@currentOption,maxDimensionHere],
			(*if the current is 1, then we expand to the MAXXX*)
			currentDimension==1,ConstantArray[currentOption,maxDimensionHere],
			(*otherwise, if its the same, do nothing*)
			currentDimension==maxDimensionHere, currentOption,
			(*otherwise, we have a kerfuffle and just pad out with Automatics and note a conflict*)
			True,(
				Sow[optionName];
				PadRight[ToList@currentOption,maxDimensionHere,Automatic]
			)
		]
	];

	(*now expand all the depth=3*)
	expandedAcquisitionModeOptions=Transpose@Map[
		Function[{index},
			(*we get the number of dimensions for each -- not nearly as complicated as the depth=4 case*)
			(*here we just care about the total length for a given option*)
			expandedDimensions=MapThread[
				getExpandedDimensionsDepth3,
				{
					matchedAcquisitionModeOptionsPositioning,
					matchedAcquisitionModeOptionsAutomatics,
					ConstantArray[index,Length@matchedAcquisitionModeOptionsAutomatics]
				}
			];

			(*find the max length*)
			maxDimension=Max[expandedDimensions];
			
			(*now we do our checking and expansion.*)
			If[MatchQ[maxDimension,1],
				(*we don't have to do anything other than inner expansion -- if we're depth four then *)
				MapThread[
					Function[{currentOption,optionName},
						Switch[currentOption,
							Automatic|Null,{currentOption},
							{Automatic}|{Null},currentOption,
							(*we check if it's the base pattern, in which case we want to wrap it in a list*)
							List[ReleaseHold@unitPatternDepth4Extractor[optionName]], If[MemberQ[depth4Options,optionName], {currentOption}, currentOption],
							(*we check if the's the base pattern, if so wrap with a list*)
							ReleaseHold@unitPatternDepth3Extractor[optionName],List[currentOption],
							_,currentOption
						]
					],
					{
						Lookup[initialExpansionAssociation,acquisitionModeIndexMatchedOptions][[All,index]],
						acquisitionModeIndexMatchedOptions
					}
				],
				(*otherwise, we have to do stuff and expand to the max length*)
				MapThread[
					performDepth3Expansion,
					{
						expandedDimensions,
						Lookup[initialExpansionAssociation,acquisitionModeIndexMatchedOptions][[All,index]],
						acquisitionModeIndexMatchedOptions,
						ConstantArray[maxDimension,Length[expandedDimensions]]
					}
				]
			]
		],
		Range[Length@ToList[mySamples]]
	];
	
	(*expand all of the blank and standard options*)

	expandedStandardAcquisitionModeOptions=If[standardExistQ,
		Transpose@Map[
			Function[{index},
				(*we get the number of dimensions for each -- not nearly as complicated as the depth=4 case*)
				(*here we just care about the total length for a given option*)
				expandedDimensions = MapThread[
					getExpandedDimensionsDepth3,
					{
						matchedStandardAcquisitionModeOptionsPositioning,
						matchedStandardAcquisitionModeOptionsAutomatics,
						ConstantArray[index, Length@matchedStandardAcquisitionModeOptionsAutomatics]
					}
				];

				(*find the max length*)
				maxDimension = Max[expandedDimensions];
				
				(*now we do our checking and expansion.*)
				If[MatchQ[maxDimension, 1],
					(*we don't have to do anything other than inner expansion*)
					MapThread[
						Function[{currentOption,optionName},
							Switch[currentOption,
								Automatic|Null,{currentOption},
								{Automatic}|{Null},currentOption,
								(*we check if it's the base pattern, in which case we want to wrap it in a list*)
								List[ReleaseHold@unitPatternDepth4Extractor[optionName]], If[MemberQ[depth4Options,optionName], {currentOption}, currentOption],
								(*we check if the's the base pattern, if so wrap with a list*)
								ReleaseHold@unitPatternDepth3Extractor[optionName],List[currentOption],
								_,currentOption
							]
						],
						{
							Lookup[initialExpansionAssociation,standardAcquisitionModeIndexMatchedOptions][[All,index]],
							standardAcquisitionModeIndexMatchedOptions
						}
					],
					(*otherwise, we have to do stuff and expand to the max length*)
					MapThread[
						performDepth3Expansion,
						{
							expandedDimensions,
							Lookup[initialExpansionAssociation, standardAcquisitionModeIndexMatchedOptions][[All, index]],
							standardAcquisitionModeIndexMatchedOptions,
							ConstantArray[maxDimension,Length[expandedDimensions]]
						}
					]
				]
			],
			Range[Length@ToList[resolvedStandard]]
		],
		(*if no standards, just null out*)
		ConstantArray[Null,Length@standardAcquisitionModeIndexMatchedOptions]
	];

	expandedBlankAcquisitionModeOptions=If[blanksExistQ,
		Transpose@Map[
			Function[{index},
				(*we get the number of dimensions for each -- not nearly as complicated as the depth=4 case*)
				(*here we just care about the total length for a given option*)
				expandedDimensions = MapThread[
					getExpandedDimensionsDepth3,
					{
						matchedBlankAcquisitionModeOptionsPositioning,
						matchedBlankAcquisitionModeOptionsAutomatics,
						ConstantArray[index, Length@matchedBlankAcquisitionModeOptionsAutomatics]
					}
				];

				(*find the max length*)
				maxDimension = Max[expandedDimensions];

				(*now we do our checking and expansion.*)
				If[MatchQ[maxDimension, 1],
					(*we don't have to do anything other than inner expansion*)
					MapThread[
						Function[{currentOption,optionName},
							Switch[currentOption,
								Automatic|Null,{currentOption},
								{Automatic}|{Null},currentOption,
								(*we check if it's the base pattern, in which case we want to wrap it in a list*)
								List[ReleaseHold@unitPatternDepth4Extractor[optionName]], If[MemberQ[depth4Options,optionName], {currentOption}, currentOption],
								(*we check if the's the base pattern, if so wrap with a list*)
								ReleaseHold@unitPatternDepth3Extractor[optionName],List[currentOption],
								_,currentOption
							]
						],
						{
							Lookup[initialExpansionAssociation,blankAcquisitionModeIndexMatchedOptions][[All,index]],
							blankAcquisitionModeIndexMatchedOptions
						}
					],
					(*otherwise, we have to do stuff and expand to the max length*)
					MapThread[
						performDepth3Expansion,
						{
							expandedDimensions,
							Lookup[initialExpansionAssociation, blankAcquisitionModeIndexMatchedOptions][[All, index]],
							blankAcquisitionModeIndexMatchedOptions,
							ConstantArray[maxDimension,Length[expandedDimensions]]
						}
					]
				]
			],
			Range[Length@ToList[resolvedBlank]]
		],
		(*if no blanks, just null out*)
		ConstantArray[Null,Length@blankAcquisitionModeIndexMatchedOptions]
	];

	(*column stuff is actually already expanded, so it's much easier*)

	(*get the length of the acquisition windows*)
	{columnPrimeNumberOfAcquisitionWindows,columnFlushNumberOfAcquisitionWindows}=Map[Length,
		Lookup[columnFurtherExpansionAssociation,{ColumnPrimeAcquisitionWindow,ColumnFlushAcquisitionWindow}]
	];

	expandedColumnPrimeAcquisitionModeOptions=If[columnPrimeQ,
		(*NOTE: the mapping here is different. We're mapping over the acquisition windows*)
		Sequence@@@Transpose@Map[
			Function[{acquisitionIndex},
				{expandedDimensionsInclusion,expandedDimensionsExclusion,expandedDimensionsIsotope} = MapThread[
					Function[{positioningGroup,automaticsGroup},
						MapThread[
							getExpandedDimensionsDepth3Columns,
							{
								positioningGroup,
								automaticsGroup,
								ConstantArray[acquisitionIndex,Length[positioningGroup]]
							}
						]
					],
					{
						{
							{
								columnPrimeInclusionDomainPositioning,
								columnPrimeInclusionMassPositioning,
								columnPrimeInclusionCollisionEnergyPositioning,
								columnPrimeInclusionDeclusteringVoltagePositioning,
								columnPrimeInclusionChargeStatePositioning,
								columnPrimeInclusionScanTimePositioning
							},
							{
								columnPrimeExclusionDomainPositioning,
								columnPrimeExclusionMassPositioning
							},
							{
								columnPrimeIsotopicExclusionPositioning,
								columnPrimeIsotopeRatioThresholdPositioning,
								columnPrimeIsotopeDetectionMinimumPositioning
							}
						},
						{
							{
								columnPrimeInclusionDomainAutomatics,
								columnPrimeInclusionMassAutomatics,
								columnPrimeInclusionCollisionEnergyAutomatics,
								columnPrimeInclusionDeclusteringVoltageAutomatics,
								columnPrimeInclusionChargeStateAutomatics,
								columnPrimeInclusionScanTimeAutomatics
							},
							{
								columnPrimeExclusionDomainAutomatics,
								columnPrimeExclusionMassAutomatics
							},
							{
								columnPrimeIsotopicExclusionAutomatics,
								columnPrimeIsotopeRatioThresholdAutomatics,
								columnPrimeIsotopeDetectionMinimumAutomatics
							}
						}
					}
				];
				(*find the max length*)
				{
					maxColumnPrimeExpansionInclusion,
					maxColumnPrimeExpansionExclusion,
					maxColumnPrimeExpansionIsotope
				}=Map[Max,
					{expandedDimensionsInclusion,expandedDimensionsExclusion,expandedDimensionsIsotope}
				];

				(*now we do our checking and expansion.*)
				Join@MapThread[
					Function[{currentMaxDimension, currentExpandedDimensions, currentOptions},
						If[MatchQ[currentMaxDimension, 1],
							(*if one, we need to make sure everything is the right listiness level*)
							MapThread[
								Function[{currentOption,optionName},
									Switch[currentOption,
										Automatic|Null,currentOption,
										{Automatic}|{Null},First@currentOption,
										(*we check if it's the base pattern, in which case we want to wrap it in a double list*)
										(ReleaseHold@unitPatternDepth3Extractor[optionName]), {currentOption},
										_,currentOption
									]
								],
								{
									(*the case where there's only one window and the max dimension is 1, then we don't need do anything*)
									If[columnPrimeNumberOfAcquisitionWindows==1,
										Lookup[columnFurtherExpansionAssociation,currentOptions],
										Part[ToList/@Lookup[columnFurtherExpansionAssociation,currentOptions],All,acquisitionIndex]
									],
									currentOptions
								}
							],
							(*otherwise, we have to do stuff and expand to the max length*)
							MapThread[
								performDepth3ExpansionColumns,
								{
									currentExpandedDimensions,
									Lookup[columnFurtherExpansionAssociation, currentOptions][[All,acquisitionIndex]],
									currentOptions,
									ConstantArray[currentMaxDimension,Length[currentExpandedDimensions]]
								}
							]
						]
					],
					{
						{
							maxColumnPrimeExpansionInclusion,
							maxColumnPrimeExpansionExclusion,
							maxColumnPrimeExpansionIsotope
						},
						{
							expandedDimensionsInclusion,
							expandedDimensionsExclusion,
							expandedDimensionsIsotope
						},
						{
							columnPrimeInclusionDomainOptions,
							columnPrimeExclusionDomainOptions,
							columnPrimeIsotopicExclusionOptions
						}
					}
				]
			],
			Range[columnPrimeNumberOfAcquisitionWindows]
		],
		(*if no column prime, just null out*)
		ConstantArray[{Null},11]
	];

	expandedColumnFlushAcquisitionModeOptions=If[columnFlushQ,
		(*NOTE: the mapping here is different. We're mapping over the acquisition windows*)
		Sequence@@@Transpose@Map[
			Function[{acquisitionIndex},
				{expandedDimensionsInclusion,expandedDimensionsExclusion,expandedDimensionsIsotope} = MapThread[
					Function[{positioningGroup,automaticsGroup},
						MapThread[
							getExpandedDimensionsDepth3Columns,
							{
								positioningGroup,
								automaticsGroup,
								ConstantArray[acquisitionIndex,Length[positioningGroup]]
							}
						]
					],
					{
						{
							{
								columnFlushInclusionDomainPositioning,
								columnFlushInclusionMassPositioning,
								columnFlushInclusionCollisionEnergyPositioning,
								columnFlushInclusionDeclusteringVoltagePositioning,
								columnFlushInclusionChargeStatePositioning,
								columnFlushInclusionScanTimePositioning
							},
							{
								columnFlushExclusionDomainPositioning,
								columnFlushExclusionMassPositioning
							},
							{
								columnFlushIsotopicExclusionPositioning,
								columnFlushIsotopeRatioThresholdPositioning,
								columnFlushIsotopeDetectionMinimumPositioning
							}
						},
						{
							{
								columnFlushInclusionDomainAutomatics,
								columnFlushInclusionMassAutomatics,
								columnFlushInclusionCollisionEnergyAutomatics,
								columnFlushInclusionDeclusteringVoltageAutomatics,
								columnFlushInclusionChargeStateAutomatics,
								columnFlushInclusionScanTimeAutomatics
							},
							{
								columnFlushExclusionDomainAutomatics,
								columnFlushExclusionMassAutomatics
							},
							{
								columnFlushIsotopicExclusionAutomatics,
								columnFlushIsotopeRatioThresholdAutomatics,
								columnFlushIsotopeDetectionMinimumAutomatics
							}
						}
					}
				];
				(*find the max length*)
				{
					maxColumnFlushExpansionInclusion,
					maxColumnFlushExpansionExclusion,
					maxColumnFlushExpansionIsotope
				}=Map[Max,
					{expandedDimensionsInclusion,expandedDimensionsExclusion,expandedDimensionsIsotope}
				];

				(*now we do our checking and expansion.*)
				Join@MapThread[
					Function[{currentMaxDimension, currentExpandedDimensions, currentOptions},
						If[MatchQ[currentMaxDimension, 1],
							MapThread[
								Function[{currentOption,optionName},
									Switch[currentOption,
										Automatic|Null,currentOption,
										{Automatic}|{Null},First@currentOption,
										(ReleaseHold@unitPatternDepth3Extractor[optionName]), {currentOption},
										_,currentOption
									]
								],
								{
									(*we need to make sure that the lists of patterns are wrapped*)
									(*if there is only 1 window, then the initial expansion should be enough*)
									If[columnFlushNumberOfAcquisitionWindows==1,
										Lookup[columnFurtherExpansionAssociation,currentOptions],
										Part[ToList/@Lookup[columnFurtherExpansionAssociation,currentOptions],All,acquisitionIndex]
									],
									currentOptions
								}
							],
							(*otherwise, we have to do stuff and expand to the max length*)
							(*need another level of listiness *)
							MapThread[
								performDepth3ExpansionColumns,
								{
									currentExpandedDimensions,
									Lookup[columnFurtherExpansionAssociation, currentOptions][[All,acquisitionIndex]],
									currentOptions,
									ConstantArray[currentMaxDimension,Length[currentExpandedDimensions]]
								}
							]
						]
					],
					{
						{
							maxColumnFlushExpansionInclusion,
							maxColumnFlushExpansionExclusion,
							maxColumnFlushExpansionIsotope
						},
						{
							expandedDimensionsInclusion,
							expandedDimensionsExclusion,
							expandedDimensionsIsotope
						},
						{
							columnFlushInclusionDomainOptions,
							columnFlushExclusionDomainOptions,
							columnFlushIsotopicExclusionOptions
						}
					}
				]
			],
			Range[columnFlushNumberOfAcquisitionWindows]
		],
		(*if no column flush, just null out*)
		ConstantArray[{Null},11]
	];

	(*we replace the options for the column prime and flush*)
	columnFlushPrimeDepth3ExpandedAssociation=Join[
		columnFurtherExpansionAssociation,
		AssociationThread[
			Join[columnPrimeInclusionDomainOptions, columnPrimeExclusionDomainOptions, columnPrimeIsotopicExclusionOptions],
			(*more gymnastics to make this the right form after expansion*)
			Join@@If[columnPrimeQ,
				Transpose/@Partition[expandedColumnPrimeAcquisitionModeOptions, columnPrimeNumberOfAcquisitionWindows],
				expandedColumnPrimeAcquisitionModeOptions
			]
		],
		AssociationThread[
			Join[columnFlushInclusionDomainOptions, columnFlushExclusionDomainOptions, columnFlushIsotopicExclusionOptions],
			Join@@If[columnFlushQ,
				Transpose/@Partition[expandedColumnFlushAcquisitionModeOptions, columnFlushNumberOfAcquisitionWindows],
				expandedColumnFlushAcquisitionModeOptions
			]
		]
	];

	(*define the relevant fields in the massacquisition method object *)
	methodDepthThreeFields={
		AcquisitionModes,Fragmentations,MinMasses,MaxMasses,MassSelections,ScanTimes,FragmentMinMasses,
		FragmentMaxMasses,FragmentMassSelections,CollisionEnergies,CollisionCellExitVoltages,MassDetectionStepSizes,LowCollisionEnergies,HighCollisionEnergies,
		FinalLowCollisionEnergies, FinalHighCollisionEnergies,FragmentScanTimes,AcquisitionSurveys, MinimumThresholds,
		AcquisitionLimits,CycleTimeLimits,ExclusionDomains,ExclusionMasses,ExclusionMassTolerances,
		ExclusionRetentionTimeTolerances,InclusionDomains,InclusionDomains,InclusionMasses,InclusionCollisionEnergies,
		InclusionDeclusteringVoltages, InclusionChargeStates,InclusionScanTimes,InclusionMassTolerances,ChargeStateLimits,
		ChargeStateSelections,ChargeStateMassTolerances, IsotopeMassDifferences,IsotopeRatios,IsotopeDetectionMinimums,
		IsotopeRatioTolerances,IsotopeMassTolerances,
		
		(*ESI QQQ new options*)
		NeutralLosses,DwellTimes,MultipleReactionMonitoringAssays,IonGuideVoltage
	};
	methodDepthFourFields={
		InclusionDomains,InclusionModes,InclusionMasses,InclusionCollisionEnergies,InclusionDeclusteringVoltages,
		InclusionChargeStates,InclusionScanTimes,ExclusionDomains,ExclusionMasses
	};

	{
		(*1*)resolvedIonModes,
		(*2*)resolvedMassSpectrometryMethods,
		(*3*)resolvedESICapillaryVoltages,
		(*4*)resolvedDeclusteringVoltages,
		(*5*)resolvedStepwaveVoltages,
		(*6*)resolvedSourceTemperatures,
		(*7*)resolvedDesolvationTemperatures,
		(*8*)resolvedDesolvationGasFlows,
		(*9*)resolvedConeGasFlows,
		(*9.5*)resolvedIonGuideVoltages,
		(*depth 3-4 options*)
		(*10*)resolvedAcquisitionWindows,
		(*11*)resolvedAcquisitionModes,
		(*12*)resolvedFragments,
		(*13*)resolvedMassDetections,
		(*14*)resolvedScanTimes,
		(*15*)resolvedFragmentMassDetections,
		(*16*)resolvedCollisionEnergies,
		(*17*)resolvedCollisionEnergyMassProfiles,
		(*18*)resolvedCollisionEnergyMassScans,
		(*19*)resolvedFragmentScanTimes,
		(*20*)resolvedAcquisitionSurveys,
		(*21*)resolvedMinimumThresholds,
		(*22*)resolvedAcquisitionLimits,
		(*23*)resolvedCycleTimeLimits,
		(*24*)resolvedExclusionDomains,
		(*25*)resolvedExclusionMasses,
		(*26*)resolvedExclusionMassTolerances,
		(*27*)resolvedExclusionRetentionTimeTolerances,
		(*28*)resolvedInclusionDomains,
		(*29*)resolvedInclusionMasses,
		(*30*)resolvedInclusionCollisionEnergies,
		(*31*)resolvedInclusionDeclusteringVoltages,
		(*32*)resolvedInclusionChargeStates,
		(*33*)resolvedInclusionScanTimes,
		(*34*)resolvedInclusionMassTolerances,
		(*35*)resolvedSurveyChargeStateExclusions,
		(*36*)resolvedSurveyIsotopeExclusions,
		(*37*)resolvedChargeStateExclusionLimits,
		(*38*)resolvedChargeStateExclusions,
		(*39*)resolvedChargeStateMassTolerances,
		(*40*)resolvedIsotopicExclusions,
		(*41*)resolvedIsotopeRatioThresholds,
		(*42*)resolvedIsotopeDetectionMinimums,
		(*43*)resolvedIsotopeMassTolerances,
		(*44*)resolvedIsotopeRatioTolerances,
		(*45*)resolvedNeutralLosses,
		(*46*)resolvedDwellTimes,
		(*47*)resolvedMassDetectionStepSizes,
		(*48*)resolvedCollisionCellExitVoltages,
		(*49*)resolvedMultipleReactionMonitoringAssays,
		(*E1*)fragmentModeConflictSampleBool,
		(*E2*)massDetectionConflictSampleBool,
		(*E3*)fragmentMassDetectionConflictSampleBool,
		(*E4*)collisionEnergyConflictSampleBool,
		(*E5*)collisionEnergyScanConflictSampleBool,
		(*E6*)fragmentScanTimeConflictSampleBool,
		(*E7*)acquisitionSurveyConflictSampleBool,
		(*E8*)acquisitionLimitConflictSampleBool,
		(*E9*)cycleTimeLimitConflictSampleBool,
		(*E10*)exclusionModeMassConflictSampleBool,
		(*E11*)exclusionMassToleranceConflictSampleBool,
		(*E12*)exclusionRetentionTimeToleranceConflictSampleBool,
		(*E13*)inclusionOptionsConflictSampleBool,
		(*E14*)inclusionMassToleranceConflictSampleBool,
		(*E15*)chargeStateExclusionLimitConflictSampleBool,
		(*E16*)chargeStateExclusionConflictSampleBool,
		(*E17*)chargeStateMassToleranceConflictSampleBool,
		(*E18*)isotopicExclusionLimitSampleBool,
		(*E19*)isotopicExclusionConflictSampleBool,
		(*E20*)isotopeMassToleranceConflictSampleBool,
		(*E21*)isotopeRatioToleranceConflictSampleBool,
		(*E22*)collisionEnergyProfileConflictSampleBool,
		(*E23*)exclusionModesVariedSampleBool,
		(*E24*)acqModeMassAnalyzerMismatchBool,
		(*E25*)invalidCollisionVoltagesBool,
		(*E26*)invalidLengthOfInputOptionBool,
		(*E27*)collisionEnergyAcqModeInvalidBool,
		(*E27.5*)sciExInstrumentErrors,
		(*W1*)autoNeutralLossValueWarningList,
		(*E28*)overlappingAcquisitionWindowSampleBool,
		(*E29*)acquisitionWindowsTooLongSampleBool,
		(*E30*)invalidSourceTemperatureBool,
		(*E31*)invalidVoltagesBool,
		(*E32*)invalidGasFlowBool,
		(*E33*)invalidScanTimeBool,
		(*E34*)numberOfPointsInScan
	}=Transpose@MapThread[
		Function[
			{
			(*N1*)filteredAnalytePacketList,
			(*N2*)simulatedSamplePacket,
			(*N3*)sampleCategory,
			(*N4*)bestMassSpecMethod,
			(*N5*)flowRate,
			(*N6*)gradient,
			(*N7*)ionMode,
			(*N8*)massSpectrometryMethod,
			(*N9*)eSICapillaryVoltage,
			(*N10*)declusteringVoltage,
			(*N11*)stepwaveVoltage,
			(*N12*)ionGuideVoltage,
			(*N13*)sourceTemperature,
			(*N14*)desolvationTemperature,
			(*N15*)desolvationGasFlow,
			(*N16*)coneGasFlow,
			(*start depth 3/4 options*)
			(*1*)acquisitionWindowList,
			(*2*)acquisitionModeList,
			(*3*)fragmentList,
			(*4*)massDetectionList,
			(*5*)scanTimeList,
			(*6*)fragmentMassDetectionList,
			(*7*)collisionEnergyList,
			(*8*)collisionEnergyMassProfileList,
			(*9*)collisionEnergyMassScanList,
			(*10*)fragmentScanTimeList,
			(*11*)acquisitionSurveyList,
			(*12*)minimumThresholdList,
			(*13*)acquisitionLimitList,
			(*14*)cycleTimeLimitList,
			(*15*)exclusionDomainList,
			(*16*)exclusionMassList,
			(*17*)exclusionMassToleranceList,
			(*18*)exclusionRetentionTimeToleranceList,
			(*19*)inclusionDomainList,
			(*20*)inclusionMassList,
			(*21*)inclusionCollisionEnergyList,
			(*22*)inclusionDeclusteringVoltageList,
			(*23*)inclusionChargeStateList,
			(*24*)inclusionScanTimeList,
			(*25*)inclusionMassToleranceList,
			(*26*)surveyChargeStateExclusionList,
			(*27*)surveyIsotopeExclusionList,
			(*28*)chargeStateExclusionLimitList,
			(*29*)chargeStateExclusionList,
			(*30*)chargeStateMassToleranceList,
			(*31*)isotopicExclusionList,
			(*32*)isotopeRatioThresholdList,
			(*33*)isotopeDetectionMinimumList,
			(*34*)isotopeMassToleranceList,
			(*35*)isotopeRatioToleranceList,
			(*36*)neutralLossList,
			(*37*)dwellTimeList,
			(*38*)collisionCellExitVoltageList,
			(*39*)massDetectionStepSizeList,
			(*40*)multipleReactionMonitoringAssaysList
		},( (*no module because it's too slow*)
				
		
				(* -- Resolve ion mode -- *)
				pHValue=Lookup[simulatedSamplePacket,pH];
				pKaValue=If[!MatchQ[filteredAnalytePacketList,{}|{Null..}],
					Mean[Cases[Lookup[filteredAnalytePacketList,pKa],_?NumericQ]],
					Null];
				acid=If[!MatchQ[filteredAnalytePacketList,{}|{Null..}],
					Or@@(Lookup[filteredAnalytePacketList,Acid]/.{Null|$Failed->False}),
					Null];
				base=If[!MatchQ[filteredAnalytePacketList,{}|{Null..}],
					Or@@(Lookup[filteredAnalytePacketList,Base]/.{Null|$Failed->False}),
					Null];

				resolvedIonMode=Which[
					(*if the user specified it, then go with it*)
					MatchQ[ionMode,IonModeP],ionMode,
					MatchQ[bestMassSpecMethod,ObjectP[]],Lookup[fetchPacketFromCache[Download[bestMassSpecMethod,Object],cache],IonMode],

					(* - Resolve automatic - *)
					(* Sample type based resolution *)
					MatchQ[sampleCategory,Peptide|DNA], Positive,

					(* Acid/Based flag based resolution *)

					(* Bases are compounds that are protonated in solution, so they form positive ions -> Positive *)
					(* Acids are compounds that loose their proton in solution, so they form negative ions -> Negative *)
					TrueQ[acid],Negative,
					TrueQ[base],Positive,

					(* pKa-based resolution *)
					(* high pKa tend to bind protons, gaining a positive charge in the process -> Positive *)
					(* low pKA tend to loose a proton -> Negative *)
					NumericQ[pKaValue]&&pKaValue<8,Negative,
					NumericQ[pKaValue]&&pKaValue>=8,Positive,

					(* pH-based resolution *)
					(* pH is the property of the solution, so with low pH, a lot of protons are available, so most likely we are doing Positive *)
					NumericQ[pHValue]&&pHValue<5,Positive,
					NumericQ[pHValue]&&pHValue>=5,Negative,

					(* Default to positive, since this generally works *)
					True,Positive
				];

				(* Build a shorthand for ionMode*)
				positiveIonModeQ=MatchQ[resolvedIonMode,Positive];
				
				(*resolve the mass spec method -- pretty easy*)
				resolvedMassSpectrometryMethod=Which[
					MatchQ[massSpectrometryMethod,ObjectP[]],massSpectrometryMethod,
					MatchQ[bestMassSpecMethod,ObjectP[]],bestMassSpecMethod,
					True,New
				];

				(*if we have resolved the mass spec method to an object, get the packet as, we'll reference it a lot*)
				resolvedMassAcquisitionMethodPacket=If[MatchQ[resolvedMassSpectrometryMethod,ObjectP[]],
					fetchPacketFromCache[Download[resolvedMassSpectrometryMethod,Object],cache]
				];
				
				(* Build a short hand for using qqq as the mass analyzer*)
				tripleQuadQ=MatchQ[resolvedMassAnalyzer,TripleQuadrupole];
				
				(* -- Resolve SamplingConeVoltage -- *)
				defaultStepwaveVoltage=If[tripleQuadQ,
					
					(*Default to Null for QQQ*)
					Null,
					
					(*For QTOF default based on sample category*)
					Switch[{stepwaveVoltage,sampleCategory},
						{_,DNA},100 Volt,
						{_,Protein},120 Volt,
						_,40 Volt
					]
				];

				(*the flow rate may be a multiple and changing, so we take the maximum*)
				maximumFlowRate=If[MatchQ[flowRate,GreaterEqualP[0 * Milliliter / Minute]],
					flowRate,
					Max[flowRate[[All,2]]]
				];
				
				(* for the low flow, we differentiate between Positive and Negative for the capillary voltage, for all other options we just look at the flow rate *)
				{
					defaultCapillaryVoltage,
					defaultSourceTemperature,
					defaultDesolvationTemperature,
					defaultDesolvationGasFlow
				}=If[tripleQuadQ,
					
					(* Default strategy for TripleQuad*)
					Switch[maximumFlowRate,
						RangeP[0*Milliliter/Minute,0.02*Milliliter/Minute],{If[positiveIonModeQ,5.5*Kilovolt,-4.5*Kilovolt],150 Celsius,100*Celsius,20*PSI},
						RangeP[0.021*Milliliter/Minute,0.1*Milliliter/Minute],{If[positiveIonModeQ,4.5*Kilovolt,-4.0*Kilovolt],150 Celsius,200*Celsius,40*PSI},
						RangeP[0.101*Milliliter/Minute,0.3*Milliliter/Minute],{If[positiveIonModeQ,4.5*Kilovolt,-4.0*Kilovolt],150 Celsius,350*Celsius,60*PSI},
						RangeP[0.301*Milliliter/Minute,0.5*Milliliter/Minute],{If[positiveIonModeQ,4.0*Kilovolt,-4.0*Kilovolt],150 Celsius,500*Celsius,60*PSI},
						GreaterP[0.5*Milliliter/Minute],{If[positiveIonModeQ,4.0*Kilovolt,-4.0*Kilovolt],150 Celsius,600*Celsius,75*PSI}
					],
					
					(* Default stategy for QTOF*)
					Switch[maximumFlowRate,
						RangeP[0*Milliliter/Minute,0.02*Milliliter/Minute],{If[MatchQ[resolvedIonMode,Positive],3*Kilovolt,2.8*Kilovolt],100*Celsius,200*Celsius,600*Liter/Hour},
						RangeP[0.021*Milliliter/Minute,0.1*Milliliter/Minute],{2.5*Kilovolt,120*Celsius,350*Celsius,800*Liter/Hour},
						RangeP[0.101*Milliliter/Minute,0.3*Milliliter/Minute],{2*Kilovolt,120*Celsius,450*Celsius,800*Liter/Hour},
						RangeP[0.301*Milliliter/Minute,0.5*Milliliter/Minute],{1.5*Kilovolt,150*Celsius,500*Celsius,1000*Liter/Hour},
						GreaterP[0.5*Milliliter/Minute],{1*Kilovolt,150*Celsius,600*Celsius,1200*Liter/Hour}
					]
				];
				
				(* set the defult DeclusteringVoltage *)
				defaultDeclusteringVoltage=If[tripleQuadQ,
					
					(* For QQQ DeclusteringVolate is set based on ionMode *)
					If[positiveIonModeQ,90*Volt,-90*Volt],
					
					(* For QTOF, default to 40 Volt *)
					40 Volt
					
				];
				
				(* Set the default IonGuideVoltage *)
				defaultIonGuideVoltage=If[tripleQuadQ,
					
					(* For QQQ DeclusteringVolate is set based on ionMode *)
					If[positiveIonModeQ,10*Volt,-10*Volt],
					
					(* For QTOF, default to Null *)
					Null
				
				];
				
				(* Set default cone gas flow *)
				defaultConeGasFlow=If[tripleQuadQ,50PSI,50 Liter/Hour];
				
				(* If the user supplied any of these values, we use these, otherwise we go with our resolution *)
				{
					resolvedESICapillaryVoltage,
					resolvedSourceTemperature,
					resolvedDesolvationTemperature,
					resolvedDesolvationGasFlow,
					resolvedStepwaveVoltage,
					resolvedDeclusteringVoltage,
					resolvedConeGasFlow,
					resolvedIonGuideVoltage
				}=MapThread[
					Function[{optionName,default,specified},
						Which[
							MatchQ[specified,Except[Automatic]],specified,
							MatchQ[bestMassSpecMethod,ObjectP[]],Lookup[resolvedMassAcquisitionMethodPacket,optionName,Null],
							True,default
						]
					],
					{
						{
							ESICapillaryVoltage,
							SourceTemperature,
							DesolvationTemperature,
							DesolvationGasFlow,
							StepwaveVoltage,
							DeclusteringVoltage,
							ConeGasFlow,
							IonGuideVoltage
						},
						{
							defaultCapillaryVoltage,
							defaultSourceTemperature,
							defaultDesolvationTemperature,
							defaultDesolvationGasFlow,
							defaultStepwaveVoltage,
							defaultDeclusteringVoltage,
							defaultConeGasFlow,
							defaultIonGuideVoltage
						},
						{
							eSICapillaryVoltage,
							sourceTemperature,
							desolvationTemperature,
							desolvationGasFlow,
							stepwaveVoltage,
							declusteringVoltage,
							coneGasFlow,
							ionGuideVoltage
						}
					}
				];
				
				
				(* build error checkers for all voltage and pressure voltages *)
				(* for ESI-QQQ the source temperature has to be 150 Celsius *)
				invalidSourceTemperatureQ=If[tripleQuadQ, !EqualQ[resolvedSourceTemperature, 150 Celsius], False];
				(* for ESI-QTOF all voltages needs to be positive *)

				invalidVoltagesQ=If[
					!tripleQuadQ,
					!And[
						MatchQ[resolvedESICapillaryVoltage,GreaterP[0 Volt]],
						MatchQ[resolvedDeclusteringVoltage,GreaterP[0 Volt]]
					],
					If[MatchQ[resolvedIonMode,Positive],
						!And[
							MatchQ[resolvedESICapillaryVoltage,GreaterP[0 Volt]],
							MatchQ[resolvedDeclusteringVoltage,GreaterP[0 Volt]]
						],
						!And[
							MatchQ[resolvedESICapillaryVoltage,LessP[0 Volt]],
							MatchQ[resolvedDeclusteringVoltage,LessP[0 Volt]]
						]
					]
				];

				(* for pressure, ESI-QQQ use PSI, ESI-QTOF use mL/Min, so we need to check for error *)
				invalidGasFlowQ=If[
					tripleQuadQ,
					!And[
						MatchQ[resolvedDesolvationGasFlow,UnitsP[PSI]],
						MatchQ[resolvedConeGasFlow,UnitsP[PSI]]
					],
					!And[
						MatchQ[resolvedDesolvationGasFlow,UnitsP[Milliliter/Minute]],
						MatchQ[resolvedConeGasFlow,UnitsP[Milliliter/Minute]]
					]
				];

				(*get the gradient timing*)
				gradientEndTime=If[MatchQ[gradient,ObjectP[]],
					Lookup[fetchPacketFromCache[Download[gradient,Object],cache],Gradient][[-1,1]],
					gradient[[-1,1]]
				];

				(*we have to resolve the acquisiton windows first since resolution depends on others*)
				(*we take a look at the total time and go from there*)
				resolvedAcquisitionWindowList=Which[
					(*if just a single span, wrap with a list*)
					MatchQ[acquisitionWindowList,_Span],{acquisitionWindowList},
					(*if no automatics go with it*)
					MatchQ[acquisitionWindowList,List[Except[Automatic]..]],acquisitionWindowList,
					(*if fully automatic and there's a method, take the method*)
					MatchQ[acquisitionWindowList,Automatic|{Automatic..}]&&!NullQ[resolvedMassAcquisitionMethodPacket],
						Lookup[resolvedMassAcquisitionMethodPacket,AcquisitionWindows],
					(*if it's just automatics, we split the time window by the time*)
					MatchQ[acquisitionWindowList,{Automatic..}], splitTime[gradientEndTime,Length[acquisitionWindowList]],
					(*if we have the weird scenario where some are automatics, but some are defined, then we have to do more intricacy*)
					True,Module[{splitWindows},
						(*find the groupings of automatics versus spans*)
						splitWindows=SplitBy[acquisitionWindowList,MatchQ[#,Automatic]&];
						(*find the automatic groups and use the split time function to split each group of automatics accordingly*)
						Flatten@MapIndexed[Function[{grouping,index},
							If[MatchQ[grouping,{Automatic..}],
								(*in the case we find a group of automatics, we run the split time*)
								splitTime[
									splitWindows[[First@index-1,-1,-1]]+0.01Minute,
									If[Length[splitWindows]==First@index,
										gradientEndTime,
										splitWindows[[First@index+1,1,1]]-0.01Minute
									],
									Length[grouping]
								],
								(*otherwise, we don't have to anything*)
								grouping
							]],
							splitWindows
						]
					]
				];

				(*we need to check if any of the acquisition windows are overlapping*)
				overlappingAcquisitionWindowsQ=If[Length[resolvedAcquisitionWindowList]>1,
					Not[And@@MapThread[#1<=#2&,
						{
							(*all of the end time points for each span except the last one*)
							Most[Last/@SortBy[resolvedAcquisitionWindowList,First]],
							(*all of the starting time points for each span except the first*)
							Rest[First/@SortBy[resolvedAcquisitionWindowList,First]]
						}
					]],
					(*if only 1, by definition can not be overlapping*)
					False
				];

				(*check to see that the acquisition windows are not too long*)
				acquisitionWindowsTooLongQ=Max[Map[Sequence @@ # &, resolvedAcquisitionWindowList]]>gradientEndTime;

				(*note how long the current windows are for the inner map thread*)
				lengthOfWindows=Length[resolvedAcquisitionWindowList];

				(*we need to convert our mass spec method to something mappable*)
				(*we need the index matching to be good. otherwise, there will be fireworks in terms of walls of red*)
				fieldValuesFromMethod=If[!NullQ[resolvedMassAcquisitionMethodPacket],
					Map[
						Function[{currentFieldValue}, Which[
							(* For single field, replicate to match sample length *)
							!MatchQ[currentFieldValue, _List],
								ConstantArray[currentFieldValue, lengthOfWindows],
							(*if the length are the same, then no problem*)
							Length[currentFieldValue]==Length[resolvedAcquisitionWindowList],
								currentFieldValue,
							(*if too long, just chop it off*)
							Length[currentFieldValue]>Length[resolvedAcquisitionWindowList],
								Take[currentFieldValue,Length[resolvedAcquisitionWindowList]],
							(*if too short, just pad out with automatics*)
							Length[currentFieldValue]<Length[resolvedAcquisitionWindowList],
								PadRight[currentFieldValue,Length[resolvedAcquisitionWindowList],Automatic]
						]],
						Lookup[resolvedMassAcquisitionMethodPacket,methodDepthThreeFields,{Null}]
					],
					(*otherwise, we just have a matrix of Automatics*)
					ConstantArray[ConstantArray[Automatic,Length[resolvedAcquisitionWindowList]],Length[methodDepthThreeFields]]
				];

				(*package this into a packet; otherwise, it'll be unwiedly*)
				(*so we'll have a list of packets index-matched to each AcquisitionWindow*)
				fieldValuesFromMethodPackets=Map[Function[{currentOptionSet},
						Association@MapThread[Rule,{methodDepthThreeFields,currentOptionSet}]
					],
					Transpose[fieldValuesFromMethod]
				];

				(*now resolve our depth 3 options*)
				acquisitionOptionsMapResult=Transpose@MapThread[
					Function[
						{
						(*1*)acquisitionWindow,
						(*2*)acquisitionMode,
						(*3*)fragment,
						(*4*)massDetection,
						(*5*)scanTime,
						(*6*)fragmentMassDetection,
						(*7*)collisionEnergy,
						(*8*)collisionEnergyMassProfile,
						(*9*)collisionEnergyMassScan,
						(*10*)fragmentScanTime,
						(*11*)acquisitionSurvey,
						(*12*)minimumThreshold,
						(*13*)acquisitionLimit,
						(*14*)cycleTimeLimit,
						(*15*)exclusionDomain,
						(*16*)exclusionMass,
						(*17*)exclusionMassTolerance,
						(*18*)exclusionRetentionTimeTolerance,
						(*19*)inclusionDomain,
						(*20*)inclusionMass,
						(*21*)inclusionCollisionEnergy,
						(*22*)inclusionDeclusteringVoltage,
						(*23*)inclusionChargeState,
						(*24*)inclusionScanTime,
						(*25*)inclusionMassTolerance,
						(*26*)surveyChargeStateExclusion,
						(*27*)surveyIsotopeExclusion,
						(*28*)chargeStateExclusionLimit,
						(*29*)chargeStateExclusion,
						(*30*)chargeStateMassTolerance,
						(*31*)isotopicExclusion,
						(*32*)isotopeRatioThreshold,
						(*33*)isotopeDetectionMinimum,
						(*34*)isotopeMassTolerance,
						(*35*)isotopeRatioTolerance,
						(*36*)methodPacket,
						(*37*)neutralLoss,
						(*38*)dwellTime,
						(*39*)collisionCellExitVoltage,
						(*40*)massDetectionStepSize,
						(*41*)multipleReactionMonitoringAssays
					},((*we're not doing this in a module because it's too slow*)
						(*group all of the DDA options together*)

						ddaOptions={
							collisionEnergyMassScan,
							fragmentScanTime,
							acquisitionSurvey,
							minimumThreshold,
							acquisitionLimit,
							cycleTimeLimit,
							exclusionDomain,
							exclusionMass,
							exclusionMassTolerance,
							exclusionRetentionTimeTolerance,
							inclusionDomain,
							inclusionMass,
							inclusionCollisionEnergy,
							inclusionDeclusteringVoltage,
							inclusionChargeState,
							inclusionScanTime,
							inclusionMassTolerance,
							surveyChargeStateExclusion,
							surveyIsotopeExclusion,
							chargeStateExclusionLimit,
							chargeStateExclusion,
							chargeStateMassTolerance,
							isotopicExclusion,
							isotopeRatioThreshold,
							isotopeDetectionMinimum,
							isotopeMassTolerance,
							isotopeRatioTolerance
						};

					
						(*see if we have implications for what our mode should be*)
						resolvedAcquisitionMode=If[tripleQuadQ,
							
							(* Resolving AcquisitionMode for *)
							If[MatchQ[acquisitionMode,Except[Automatic]],
								(*if user specified a value, use what user specified*)
								acquisitionMode,
								
								(*Resolved automatic scan mode*)
								Switch[{fragment,massDetection,fragmentMassDetection},
									(*If user specified Fragment options as False, we resolved *)
									{False,_Span,_},MS1FullScan,
									{False,({UnitsP[Gram/Mole] ..}|UnitsP[Gram/Mole]|{UnitsP[Gram/Mole]}),_},SelectedIonMonitoring,
									
									(*Default all input as MS1FullScan*)
									{False,_,_},MS1FullScan,
									
									(*MS1:Range, MS2:Range, NeutralIonScan*)
									{True,_Span,_Span},NeutralIonLoss,
									
									(*MS1:Range, MS2:Selection, PrecursorIonScan*)
									{True,_Span,{UnitsP[Gram/Mole]}|UnitsP[Gram/Mole]},PrecursorIonScan,
									
									(*MS1:Selection, MS2:Range, ProductioIonScan*)
									{True,{UnitsP[Gram/Mole]}|UnitsP[Gram/Mole],_Span},MS1MS2ProductIonScan,
									
									(*MS1:Selection, MS2:Selection, MultipleReactionMonitoring*)
									{True,UnitsP[Gram/Mole]|{UnitsP[Gram/Mole]}|{UnitsP[Gram/Mole] ..},UnitsP[Gram/Mole]|{UnitsP[Gram/Mole]}|{UnitsP[Gram/Mole] ..}},MultipleReactionMonitoring,
									
									(*MS1:Selection, MS2:Automatic, Fragment is on we assigned it to ProductioIonScan*)
									{True,{UnitsP[Gram/Mole]}|{UnitsP[Gram/Mole]},_},MS1MS2ProductIonScan,
									
									(*MS1:Range, MS2:Selection, Fragment is on we assigned it to PrecursorIonScan*)
									{True,_Span,_},PrecursorIonScan,
									
									(*If we cannoe resolved by mass detection values, we check if user specified mass scan mode specific options*)
									{_,_,_},Which[
										MatchQ[Lookup[methodPacket,AcquisitionModes],Except[Automatic]],Lookup[methodPacket,AcquisitionModes],
										MatchQ[neutralLoss,Except[Automatic]], NeutralIonLoss,
										MatchQ[multipleReactionMonitoringAssays, Except[Automatic]], MultipleReactionMonitoring,
										MatchQ[collisionEnergy,Except[Automatic|Null]],MS1MS2ProductIonScan,
										True,MS1FullScan
									
									]
								]
							],
							
							
							(*resolving logic for using QTOF as the mass analyzer*)
							Which[
								(*if set we go with it*)
								MatchQ[acquisitionMode,Except[Automatic|{Automatic}|Null]],acquisitionMode,
								MatchQ[fragment,False],MS1FullScan,
								(*check if any of the dda options are specified *)
								MemberQ[ddaOptions,Except[Automatic|Null]],DataDependent,
								(*is mass detection a range? if so DIA*)
								lengthOfWindows==1&&MatchQ[massDetection,_Span]&&Or[MatchQ[fragment,True],MatchQ[fragmentMassDetection,Except[Automatic|Null]]],DataIndependent,
								(*fragment stuff on?*)
								Or[MatchQ[fragment,True],MatchQ[fragmentMassDetection,Except[Automatic|Null]]],MS1MS2ProductIonScan,
								(*is the collision energy on?*)
								lengthOfWindows==1&&MatchQ[collisionEnergyMassProfile,Except[Automatic|Null]],DataIndependent,
								MatchQ[collisionEnergyMassProfile,Except[Automatic|Null]],DataDependent,
								MatchQ[collisionEnergy,Except[Automatic|Null]],MS1MS2ProductIonScan,
								(*otherwise check from the method*)
								MatchQ[Lookup[methodPacket,AcquisitionModes],Except[Automatic]],
									Lookup[methodPacket,AcquisitionModes],
								(*otherwise default*)
								True,MS1FullScan
							]
						];
						
						(*Error checker for mismatched acquisition mode and massanalyzer*)
						acqModeMassAnalyzerMismatchedQ=If[
							tripleQuadQ,
							MatchQ[resolvedAcquisitionMode,(DataDependent| DataIndependent)],
							MatchQ[resolvedAcquisitionMode,Except[(DataDependent| DataIndependent| MS1MS2ProductIonScan|MS1FullScan)]]
						];
						
						
						fragmentAcqModesP=(DataDependent| DataIndependent| MS1MS2ProductIonScan|NeutralIonLoss | PrecursorIonScan | MultipleReactionMonitoring);
						
						resolvedFragment=Which[
							MatchQ[fragment,Except[Automatic]],fragment,
							(*otherwise, should just inherit from the mode*)
							MatchQ[resolvedAcquisitionMode,fragmentAcqModesP], True,
							True,False
						];

						(*check that the fragment and the mode are compatible*)
						fragmentModeConflictQ=Switch[{resolvedAcquisitionMode, resolvedFragment},
							{fragmentAcqModesP,True},False,
							{MS1FullScan|SelectedIonMonitoring,False},False,
							_,True
						];
						
						(* === first build some shorthands and calculate some values for *)
						(* define our default mass ranges *)
						lowRange=Span[5 *Gram/Mole, 1250 *Gram/Mole];
						highRange=Span[500 *Gram/Mole, 2000 *Gram/Mole];
						
						
						(*Add a judgement ranged Mass scan boolean here. *)
						qqqRangedMassScanQ=MatchQ[resolvedAcquisitionMode,(MS1FullScan|MS1MS2ProductIonScan|NeutralIonLoss|PrecursorIonScan)];
						qqqRangedMS1MassScanQ=MatchQ[resolvedAcquisitionMode,(MS1FullScan|PrecursorIonScan|NeutralIonLoss)];
						qqqTandemMassQ=MatchQ[resolvedAcquisitionMode,(MS1MS2ProductIonScan|NeutralIonLoss|PrecursorIonScan|MultipleReactionMonitoring)];
						
						
						(* Analyte Molecular weight *)
						analytesMolecularWeights=Flatten[Lookup[filteredAnalytePacketList, MolecularWeight,{}]];
						
						
						(*Use a helper function to help us figure out what default mass selection value we should give our user*)
						defaultMassSelectionValue=ToList[If[
							MatchQ[Min[analytesMolecularWeights],RangeP[5*Gram/Mole,1998*Gram/Mole]],
							If[
								positiveIonModeQ,
								(Min[analytesMolecularWeights]+1*Gram/Mole),
								(Min[analytesMolecularWeights]-1*Gram/Mole)
							],
							500*Gram/Mole
						]];
						
						(*  *)

						resolvedMassDetection=If[tripleQuadQ,
							(* resolve Mass Detection for QQQ as the mass analyzer *)
							Which[

								(* Usually we should always respect the user's input here. However, MassDetection is a special option that it allows multiple different patterns for different acquisition modes. Here, if we have a singleton, we wrap it with a list so that our later collapsing and expansion will work as expected *)
								MatchQ[massDetection,Except[Automatic]]&&MatchQ[massDetection,RangeP[2 Gram / Mole, 100000 Gram / Mole]],{massDetection},
								MatchQ[massDetection,Except[Automatic]],massDetection,
								
								(* 2. check if previous specified method has molecular weight filled*)
								(* Retrived the mass values from MinMasses and MaxMasses from the packet *)
								MatchQ[resolvedAcquisitionMode,qqqRangedMS1MassScanQ]&&And[
									MatchQ[Lookup[methodPacket,MinMasses],Except[Automatic|Null]],
									MatchQ[Lookup[methodPacket,MaxMasses],Except[Automatic|Null]]
								],
								Span[Lookup[methodPacket,MinMasses],Lookup[methodPacket,MaxMasses]],
								MatchQ[resolvedAcquisitionMode,(SelectedIonMonitoring| MultipleReactionMonitoring)]&&MatchQ[Lookup[methodPacket,MassSelections],Except[Automatic|Null]],
								Lookup[methodPacket,MassSelections],
								(*a specific selection is fine for any mode including MS1MS2ProductIonScan*)
								MatchQ[Lookup[methodPacket,MassSelections],List[_]],
								First@Lookup[methodPacket,MassSelections],
								
								(*3. Resolved based on other paramenters*)
								(*For those mass scan mode require MS1 as a ranged mass input, resolved it based on sample's category and molecular weight*)
								MatchQ[resolvedAcquisitionMode,(MS1FullScan|PrecursorIonScan|NeutralIonLoss)],Switch[
									{sampleCategory,Mean[analytesMolecularWeights]},
									{Peptide,_},lowRange,
									{_,RangeP[100*Gram/Mole,1250*Gram/Mole]},lowRange,
									{_,RangeP[500*Gram/Mole,2000*Gram/Mole]},highRange,
									_,lowRange
								],
								(*If user specified multiple reaction monitoring assays options, we resolved it based on what user specified*)
								
								And[MatchQ[multipleReactionMonitoringAssays,Except[Automatic]],!NullQ[multipleReactionMonitoringAssays]],Flatten[multipleReactionMonitoringAssays[[All,All,1]],1],
								
								(*For thos mass scan mode require MS1 as a ranged mass input, resolved it based on sample's and molecular weight*)
								(*If its Mininum MW fall into detection range, we use its protonated or deprotonated value (Positive or Negative value)*)
								
								MatchQ[resolvedAcquisitionMode,SelectedIonMonitoring|MultipleReactionMonitoring|ProduectIonScan(MS1MS2)],ToList@defaultMassSelectionValue,
								True,ToList@defaultMassSelectionValue
							
							],
							
							(* resolve MassDetection for QTOF as the Mass Analyzer   *)
							Which[
								(* Usually we should always respect the user's input here. However, MassDetection is a special option that it allows multiple different patterns for different acquisition modes. Here, if we have a singleton, we wrap it with a list so that our later collapsing and expansion will work as expected *)
								MatchQ[massDetection,Except[Automatic]]&&MatchQ[massDetection,RangeP[2 Gram / Mole, 100000 Gram / Mole]],{massDetection},
								MatchQ[massDetection,Except[Automatic]],massDetection,
								(*ranges only work in the following acquisition modes*)
								MatchQ[resolvedAcquisitionMode,(DataDependent| DataIndependent| MS1FullScan)]&&And[
										MatchQ[Lookup[methodPacket,MinMasses],Except[Automatic|Null]],
										MatchQ[Lookup[methodPacket,MaxMasses],Except[Automatic|Null]]
								],
									Span[Lookup[methodPacket,MinMasses],Lookup[methodPacket,MaxMasses]],
								MatchQ[resolvedAcquisitionMode,(DataDependent| DataIndependent| MS1FullScan)]&&MatchQ[Lookup[methodPacket,MassSelections],Except[Automatic|Null]],
									Lookup[methodPacket,MassSelections],
								(*a specific selection is fine for any mode including MS1MS2ProductIonScan*)
								MatchQ[Lookup[methodPacket,MassSelections],List[_]],
									First@Lookup[methodPacket,MassSelections],
								MatchQ[resolvedAcquisitionMode,(DataDependent| DataIndependent| MS1FullScan)]&&MatchQ[sampleCategory,DNA|Protein],
									sampleCategory,
								(*if can only choose one, then do the analyte based on the mode (positive or negative)*)
								MatchQ[resolvedAcquisitionMode,MS1MS2ProductIonScan]&&(Length[filteredAnalytePacketList]>0),
									If[MatchQ[resolvedIonMode, Positive],
										FirstOrDefault[Lookup[filteredAnalytePacketList, MolecularWeight,{}], 150 Gram / Mole] + 1 Gram/Mole,
										FirstOrDefault[Lookup[filteredAnalytePacketList, MolecularWeight,{}], 150 Gram / Mole] - 1  Gram/Mole
									],
								(*otherwise do the full range*)
								True,
									Span[2 Gram/Mole,100000 Gram/Mole]
							]
						];


						(*multiple masses will not work with MS1MS2ProductIonScan, so we need to check this*)
						massDetectionConflictQ=If[tripleQuadQ,
							Which[
								qqqRangedMS1MassScanQ,MatchQ[resolvedMassDetection,Except[_Span]],
								MatchQ[resolvedAcquisitionMode,MS1MS2ProductIonScan],MatchQ[resolvedMassDetection,Except[UnitsP[Gram/Mole]|{UnitsP[Gram/Mole]}]],
								MatchQ[resolvedAcquisitionMode,SelectedIonMonitoring|MultipleReactionMonitoring],MatchQ[resolvedMassDetection,Except[ListableP[{GreaterP[Gram/Mole]..}]]],
								True,False
							],
							Switch[{resolvedAcquisitionMode, resolvedMassDetection},
								{(DataDependent| DataIndependent| MS1FullScan),_},False,
								{MS1MS2ProductIonScan,Except[UnitsP[Gram/Mole]|{UnitsP[Gram/Mole]}]},True,
								_,False
							]
						];
						
						(*scan time is fairly jejune*)
						resolvedScanTime=Which[
							MatchQ[scanTime,Except[Automatic]],scanTime,
							MatchQ[Lookup[methodPacket,ScanTimes],Except[Automatic]],
								Lookup[methodPacket,ScanTimes],
							(*our default*)
							True, 1 Second
						];

						(* Resolve MassDetectionStepSize*)
						resolvedMassDetectionStepSize=Which[
							(* if user specified a value, use what user specified *)
							MatchQ[massDetectionStepSize,Except[Automatic]],massDetectionStepSize,

							(* if the MassAcquisition Method specified a value, usue that value*)
							MatchQ[Lookup[methodPacket,MassDetectionStepSizes],Except[Automatic|Null|_Missing]],Lookup[methodPacket,MassDetectionStepSizes],

							(* check if the acquisitionMode is Range scan and MassAnalzyer is QQQ, resolve it to 0.1 Gram/Mole *)
							(tripleQuadQ&&MatchQ[resolvedAcquisitionMode,(MS1FullScan|PrecursorIonScan|MS1MS2ProductIonScan|NeutralIonLoss)]), 0.1 Gram/Mole,

							(* In all other cases resolve it to Null *)
							True, Null

						];

						(* Determine the number of points in the ranged scan *)
						numberOfPoints = If[qqqRangedMS1MassScanQ&&tripleQuadQ, ((resolvedMassDetection[[2]] - resolvedMassDetection[[1]])/resolvedMassDetectionStepSize+1), Null];

						(* Check if the scan time is compatible with the QQQ *)
						invalidScanTimeQ = Which[
							(* If the mass spectra acquisition is QQQRangedMS1MassScan,*)
							qqqRangedMS1MassScanQ&&tripleQuadQ,
							(* Check that the resolved ScanTime is not outside the range supported by the QQQ *)
							Or[resolvedScanTime < numberOfPoints * 3 Microsecond, resolvedScanTime > numberOfPoints * 5 Second],
							(* Otherwise the ScanTime is valid *)
							True, False
						];

						sciExInstrumentError = If[MatchQ[{resolvedAcquisitionMode, resolvedMassDetection, resolvedMassDetectionStepSize, resolvedScanTime}, {MS1FullScan, Span[EqualP[5 Gram/Mole], EqualP[1250 Gram/Mole]], EqualP[0.1 Gram/Mole], EqualP[0.5 Second]}],
							True,
							False
						];

						resolvedFragmentMassDetection=If[tripleQuadQ,
							Which[
								
								MatchQ[fragmentMassDetection,Except[Automatic]],fragmentMassDetection,
								(*ranges only work in the following acquisition modes*)
								!qqqTandemMassQ,Null,
								
								(* for MS1MS2ProductIonScan|NeutralIonLoss, MS2 should be set to a _Span Value*)
								MatchQ[resolvedAcquisitionMode,(MS1MS2ProductIonScan|NeutralIonLoss)]&&And[
									MatchQ[Lookup[methodPacket,FragmentMinMasses],Except[Automatic|Null]],
									MatchQ[Lookup[methodPacket,FragmentMaxMasses],Except[Automatic|Null]]
								],
								Span[Lookup[methodPacket,FragmentMinMasses],Lookup[methodPacket,FragmentMaxMasses]],
								
								(* For PrecursorIonScan and MRM, the MS2 are supposed to be a single valuea or a list of values*)
								MatchQ[resolvedAcquisitionMode,(PrecursorIonScan|MultipleReactionMonitoring)]&&MatchQ[Lookup[methodPacket,FragmentMassSelections],Except[Automatic|Null]],
								ToList@Lookup[methodPacket,FragmentMassSelections],
								
								(* If massspec method was not specified, resolved based on other paramenter, most by acquisition mode *)
								(*For Product Ion Scan, resolve the automatic options to lowrange*)
								MatchQ[resolvedAcquisitionMode,MS1MS2ProductIonScan],lowRange,
								
								(*For MultipleReactionMonitoring mode*)
								MatchQ[resolvedAcquisitionMode,MultipleReactionMonitoring],
								ToList@If[And[MatchQ[multipleReactionMonitoringAssays,Except[Automatic]],!NullQ[multipleReactionMonitoringAssays]],
									
									(*First we check if user specified MultipleReactionMonitoring Assays*)
									Flatten[multipleReactionMonitoringAssays[[All,All,3]],1],
								
									(*we arbitarily resolved it to detect the dehydration product of the mass detection*)
									(resolvedMassDetection-18*Gram/Mole)
								],
								
								
								(*For NeutralLoss, and all other cases resolved it to All*)
								(* Note that MassDetection has wider valid range than FragmentMassDetection. We need to make sure our resolved option is valid *)
								MatchQ[resolvedMassDetection, _Span],
									Span[Max[20 Gram/Mole, First[resolvedMassDetection]], Min[16000 Gram/Mole, Last[resolvedMassDetection]]],
								True, resolvedMassDetection
							],
							
							Which[
								MatchQ[fragmentMassDetection,Except[Automatic]],fragmentMassDetection,
								(*ranges only work in the following acquisition modes*)
								MatchQ[resolvedAcquisitionMode,MS1FullScan],Null,
								MatchQ[resolvedAcquisitionMode,(DataDependent| DataIndependent| MS1MS2ProductIonScan)]&&And[
									MatchQ[Lookup[methodPacket,FragmentMinMasses],Except[Automatic|Null]],
									MatchQ[Lookup[methodPacket,FragmentMaxMasses],Except[Automatic|Null]]
								],
								Span[Lookup[methodPacket,FragmentMinMasses],Lookup[methodPacket,FragmentMaxMasses]],
								MatchQ[resolvedAcquisitionMode,(DataDependent| DataIndependent| MS1MS2ProductIonScan)]&&MatchQ[Lookup[methodPacket,FragmentMassSelections],Except[Automatic|Null]],
									Lookup[methodPacket,FragmentMassSelections],
								(*otherwise do the full range*)
								True, All
							]
						];

						
						(*fragment mass should not be set for MS1FullScan, and it should not be Null otherwise*)
						fragmentMassDetectionConflictQ=If[tripleQuadQ,
							
							(* Check if the FragmentMassDetection is valid for QQQ as the mass analyzer *)
							Which[
								
								(* For MS1 only scans, no FragmentMassDetection must be Null*)
								MatchQ[resolvedAcquisitionMode,(FullScan|SelectectIonMonitoring)],MatchQ[resolvedFragmentMassDetection,Except[Null]],
								
								(* for product ion scan, FragmentMassDetection needs to be span *)
								MatchQ[resolvedAcquisitionMode,(MS1MS2ProductIonScan)],MatchQ[resolvedFragmentMassDetection,Except[_Span]],
								
								(* for PrecursorIonScan, FragmentMassDetection needs to be a single value *)
								MatchQ[resolvedAcquisitionMode,PrecursorIonScan],MatchQ[resolvedFragmentMassDetection,Except[UnitsP[Gram/Mole]|{UnitsP[Gram/Mole]}]],
								
								(*For MRM, the FragmentMassDetection needs to be alist of mass values*)
								MatchQ[resolvedAcquisitionMode,MultipleReactionMonitoring],MatchQ[resolvedFragmentMassDetection,Except[ListableP[{GreaterP[Gram/Mole]..}]]],
								
								(* Catch all by false*)
								True,False
							],
							
							(* Error check for ESI-QTOF *)
							Or[
								MatchQ[resolvedAcquisitionMode,MS1FullScan]&&MatchQ[resolvedFragmentMassDetection,Except[Null|{Null}]],
								MatchQ[resolvedAcquisitionMode,Except[MS1FullScan]]&&MatchQ[resolvedFragmentMassDetection,Null|{Null}]
							]
						];
					
						resolvedCollisionEnergy=Which[
							
							(* If user specified a list of input mass detection values, but specified only a single collision
							 energy value, we assume this collision value will applied to all detections, thereby we expand it*)
							MatchQ[collisionEnergy,Except[Automatic]],If[
								MatchQ[resolvedMassDetection,{UnitsP[Gram/Mole] ..}]&&MatchQ[collisionEnergy,{UnitsP[Volt]}|UnitsP[Volt]],
								ConstantArray[First[ToList[collisionEnergy]],Length[resolvedMassDetection]],
								
								(* In all other cases we use what user specified, we will check if the length of each input are the same in below*)
								collisionEnergy
							],
							MatchQ[resolvedAcquisitionMode,MS1FullScan|SelectedIonMonitoring],Null,
							MatchQ[collisionEnergyMassProfile,Except[Automatic|Null]]&&MatchQ[resolvedAcquisitionMode, Except[DataIndependent]],Null,
							MatchQ[Lookup[methodPacket,LowCollisionEnergies],Except[Automatic|Null]],Null,
							MatchQ[Lookup[methodPacket,CollisionEnergies],Except[Automatic]], Lookup[methodPacket,CollisionEnergies],
							
							(*ESI-QQQ specific resolving strategy*)
							tripleQuadQ,ToList@Which[
								(*If user specified MultipleReactionAssays, we check user specified value and resolved those are Automatic*)
								And[MatchQ[multipleReactionMonitoringAssays,Except[Automatic]],!NullQ[multipleReactionMonitoringAssays]],
								Map[
									Function[eachCollisionEnergy,
										If[
											MatchQ[eachCollisionEnergy, Except[Automatic]],
											eachCollisionEnergy,
											If[positiveIonModeQ, 40*Volt, -40*Volt]
										]
									],
									Flatten[multipleReactionMonitoringAssays[[All,All,2]],1]
								],
								
								
								(*Otherwise resolved it based on input massRange type*)
								(*for single massDetection input, give it a single value*)
								MatchQ[resolvedMassDetection,_Span|UnitsP[Gram/Mole]], If[positiveIonModeQ,40*Volt,-40*Volt],
								
								(*For a list of inputs, give it a ConstantAssay*)
								True,If[positiveIonModeQ,ConstantArray[40*Volt, Length[resolvedMassDetection]],ConstantArray[-40*Volt, Length[resolvedMassDetection]]]
							
							],
							True,{40 Volt}
						];
						
						(* CollisionEnergy AcquisitionMode MisMatches *)
						collisionEnergyAcqModeInvalidQ=If[MatchQ[resolvedAcquisitionMode,Except[MultipleReactionMonitoring]],And[Length[ToList[resolvedCollisionEnergy]]>1,!NullQ[resolvedCollisionEnergy]],False];
						
						resolvedCollisionEnergyMassProfile=Which[
							MatchQ[collisionEnergyMassProfile,Except[Automatic]],collisionEnergyMassProfile,
							MatchQ[resolvedAcquisitionMode,MS1FullScan],Null,
							(*cannot have both the energy and the mass profile unless in DataIndependent mode*)
							MatchQ[resolvedCollisionEnergy,Except[Null]]&&MatchQ[resolvedAcquisitionMode,Except[DataIndependent]],Null,
							And[
								MatchQ[Lookup[methodPacket,LowCollisionEnergies],Except[Automatic|Null]],
								MatchQ[Lookup[methodPacket,HighCollisionEnergies],Except[Automatic|Null]]
							],
								Span[Lookup[methodPacket,LowCollisionEnergies],Lookup[methodPacket,HighCollisionEnergies]],
							(* if acquisition mode is DataIndependent but mass profile was not specified, use resolvedCollisionEnergy as the left side and max voltage as the right side *)
							MatchQ[resolvedAcquisitionMode,DataIndependent],Span[First[ToList[resolvedCollisionEnergy]], 255 Volt],
							True,Null
						];

						(*the collision energy options must be compatible withh the acquisition mode*)
						collisionEnergyConflictQ=Switch[{resolvedCollisionEnergy,resolvedCollisionEnergyMassProfile,resolvedAcquisitionMode},
							(* they can't be all Null, when a fragmenting mode*)
							{Null|{Null},Null|{Null},(DataDependent| DataIndependent| MS1MS2ProductIonScan)},True,
							(*conversely, either cannot be set when MS1FullScan*)
							{Except[Null|{Null}],_,MS1FullScan},True,
							{_,Except[Null|{Null}],MS1FullScan},True,
							_,False
						];
						
						(* Resolve QQQ specific tandem mass options *)
						resolvedDwellTime=Which[
							
							(* If user specified a value, we use  what user specified and will check for conflict in later section*)
							MatchQ[dwellTime,Except[Automatic]],
									(* If user specified a list of input mass detection values, but specified only a single dwell time value, we assume this dwell time will applied to all detections, thereby we expand it*)
							If[
								MatchQ[resolvedMassDetection,{UnitsP[Gram/Mole] ..}]&&MatchQ[dwellTime,{TimeP}|TimeP],
								ConstantArray[First[ToList[dwellTime]],Length[resolvedMassDetection]],
								
								(* In all the other cases we use what user specified us, will check if there is a mis match in the later section*)
								dwellTime
							],
							
							(* If specified the method contains dwelltime, use that value *)
							MatchQ[Lookup[methodPacket,DwellTimes], Except[Automatic|Null|{Null}]],
							Lookup[methodPacket,DwellTimes],
							
							
							(*Resolve automatic option input.*)
							(*If user specified MultipleReactionAssays, we check user specified value and resolved those are Automatic*)
							And[MatchQ[multipleReactionMonitoringAssays,Except[Automatic]],!NullQ[multipleReactionMonitoringAssays]],
							Map[
								Function[eachDwellTime,
									If[
										MatchQ[eachDwellTime, Except[Automatic]],
										eachDwellTime,
										200*Millisecond
									]
								],
								Flatten[multipleReactionMonitoringAssays[[All,All,4]],1]
							],
							
							(*Otherwise resolved it based on input massRange type*)
							(*for single massDetection fixed valueinput, give it a single value*)
							And[MatchQ[resolvedMassDetection,UnitsP[Gram/Mole]],MatchQ[resolvedAcquisitionMode,SelectedIonMonitoring|MultipleReactionMonitoring]],
							200*Millisecond,
							
							(*For a list of inputs, give it a ConstantAssay*)
							And[MatchQ[resolvedMassDetection,{UnitsP[Gram/Mole]..}],MatchQ[resolvedAcquisitionMode,SelectedIonMonitoring|MultipleReactionMonitoring]],
							ConstantArray[200*Millisecond, Length[resolvedMassDetection]],
							
							(*Catch all to set this option to Null*)
							True,
							Null
							
						];
						
						(* Build a error check for MRM assays to check if all inputs are in same length *)
						(*Generate how many mass detection values for this samplw we have*)
						numberOfMassInputs=Length[ToList[resolvedMassDetection]];
						
						(*Check if we have same number of inputs for those options with an adder*)
						invalidLengthOfInputOptionQ=Module[
							{
								relaventOptionNotListedNames, finalBooleanList,
								relaventOptionNotListedOptions
							},
							
							relaventOptionNotListedOptions={
								(*1*)resolvedCollisionEnergy,
								(*2*)resolvedFragmentMassDetection,
								(*3*)resolvedDwellTime
							};
							
							finalBooleanList=If[
								And[tripleQuadQ,MatchQ[resolvedAcquisitionMode,MultipleReactionMonitoring]],
								Map[
									If[
										MatchQ[#,Null],
										False,
										!((Length[ToList[#]])===numberOfMassInputs)
									]&,
									relaventOptionNotListedOptions
								],
								ConstantArray[False,Length[relaventOptionNotListedOptions]]
							
							];
							
							(*Out put which option does not have same length as the mass detection input*)
							ContainsAny[finalBooleanList, {True}]
						];
						
						(* Resolve CollisionCellExitVoltage for TripleQuad *)
						resolvedCollisionCellExitVoltage=Which[
							(* if user specified a value, use what user specified *)
							MatchQ[collisionCellExitVoltage,Except[Automatic]],collisionCellExitVoltage,
							
							(* if the MassAcquisition Method specified a value, usue that value*)
							MatchQ[Lookup[methodPacket,CollisionCellExitVoltages],Except[Automatic|Null|_Missing]],Lookup[methodPacket,CollisionCellExitVoltages],
							
							(* check if the acquisitionMode required fragement and the  QTOF, resolve it to Null *)
							(tripleQuadQ&&qqqTandemMassQ), If[positiveIonModeQ,15*Volt,-15*Volt],
							
							(* In all other cases resolve it to Null *)
							True, Null
						
						];
						
						(* For ESI-QQQ: Check CollisionEnergy and CollisionCellExitVotage matches ionmode *)
						invalidCollisionVoltagesQ=If[
							tripleQuadQ,
							Module[{invalidVoltages},
								invalidVoltages=Cases[
									{resolvedCollisionEnergy,resolvedCollisionCellExitVoltage},
									If[positiveIonModeQ,Except[ListableP[GreaterEqualP[0*Volt]|{GreaterEqualP[0*Volt]..}|Null]],Except[ListableP[LessEqualP[0*Volt]|{LessEqualP[0*Volt]..}|Null]]]
								];
								(* Return a checker to see if there are invalid voltages*)
								(Length[invalidVoltages]>0)
							],
							!And[
								MatchQ[resolvedCollisionEnergy,ListableP[GreaterEqualP[0*Volt]|Null]],
								NullQ[resolvedCollisionCellExitVoltage]
							]
						];
						
						(* Resolve NeutralLoss for QQQ MassAnalyzer *)
						autoNeutralLossValueWarningQ=False;
						
						resolvedNeutralLoss=Which[
							
							(* use user specified value *)
							MatchQ[neutralLoss,Except[Automatic]],neutralLoss,
							
							(* get the value from MassAcquisition Method, if specified *)
							MatchQ[Lookup[methodPacket,NeutralLosses],Except[Automatic|Null]],Lookup[methodPacket,NeutralLosses],
							
							(* if the acquisition mode is Neutral loss, auto resolved a value and throw a warning*)
							MatchQ[resolvedAcquisitionMode,NeutralIonLoss], autoNeutralLossValueWarningQ=True;50*Gram/Mole,
							
							(* in all other cases set it to Null *)
							True, Null
						
						];
					
						(* Resolve the MRM assay *)
						resolvedMultipleReactionMonitoringAssay=ToList[Which[
							(* use user specified value *)
							MatchQ[multipleReactionMonitoringAssays,Except[Automatic]],multipleReactionMonitoringAssays,
							(* If not in QQQ resolve to Null *)
							(* !tripleQuadQ,{Null,Null,Null,Null},*)
							!tripleQuadQ, Null,
							
							(* get the value from MassAcquisition Method, if specified *)
							MatchQ[Lookup[methodPacket,MultipleReactionMonitoringAssays],Except[Automatic|Null]],Lookup[methodPacket,MultipleReactionMonitoringAssays],
							
							(* if the acquisition mode is Neutral loss, auto resolved a value and throw a warning*)
							MatchQ[resolvedAcquisitionMode,MultipleReactionMonitoring], Transpose[PadRight[{ToList[resolvedMassDetection],ToList[resolvedCollisionEnergy],ToList[resolvedFragmentMassDetection],ToList[resolvedDwellTime]},{4,Length[ToList[resolvedMassDetection]]},Null]],
							
							(* in all other cases set it to Null *)
							True, Null (*{Null,Null,Null,Null}*)
						
						]];
						(*we also check if CollisionEnergy and CollisionEnergyMassProfile are defined correctly*)
						collisionEnergyProfileConflictQ=Which[
							(* in DataIndependent mode , we use CollisionEnergy for scan 1 and CollisionEnergyMassProfile for scan 2*)
							(* the left side of CollisionEnergyMassProfile--LowCollisionEnergy must be larger than CollisionEnergy *)
							(* the right side of CollisionEnergyMassProfile--HighCollisionEnergy must be larger than the left side--LowCollisionEnergy*)
							MatchQ[resolvedAcquisitionMode, DataIndependent],
							!And[
								(* the resolvedCollisionEnergy for DataIndependent could be {energy} or energy *)
								GreaterEqualQ[resolvedCollisionEnergyMassProfile[[1]], First[ToList[resolvedCollisionEnergy]]],
								GreaterEqualQ[resolvedCollisionEnergyMassProfile[[2]], resolvedCollisionEnergyMassProfile[[1]]]
							],
							(* in other mode, we only use one of them *)
							True,
							MatchQ[resolvedCollisionEnergy,Except[Null]]&&MatchQ[resolvedCollisionEnergyMassProfile,Except[Null]]
						];

						resolvedCollisionEnergyMassScan=Which[
							MatchQ[collisionEnergyMassScan,Except[Automatic]],collisionEnergyMassScan,
							Or[tripleQuadQ,MatchQ[resolvedAcquisitionMode,MS1FullScan]],Null,
							And[
								MatchQ[Lookup[methodPacket,FinalLowCollisionEnergies],Except[Automatic|Null]],
								MatchQ[Lookup[methodPacket,FinalHighCollisionEnergies],Except[Automatic|Null]]
							],
								Span[Lookup[methodPacket,FinalLowCollisionEnergies],Lookup[methodPacket,FinalHighCollisionEnergies]],
							(*this is a wine and cheese option, so we default to Null*)
							True,Null
						];

						(*this is only available for DDA*)
						collisionEnergyScanConflictQ=If[MatchQ[resolvedCollisionEnergyMassScan,Except[Null]],
							MatchQ[resolvedAcquisitionMode,Except[DataDependent]],
							False
						];

						(*from here on out the options are only applicable if we're doing DataDependent acquisition mode*)

						(*define a check that we'll use a lot*)
						ddaQ=MatchQ[resolvedAcquisitionMode,DataDependent];

						resolvedFragmentScanTime=Which[
							MatchQ[fragmentScanTime,Except[Automatic]],fragmentScanTime,
							!ddaQ,Null,
							MatchQ[Lookup[methodPacket,FragmentScanTimes],Except[Automatic|Null]],Lookup[methodPacket,FragmentScanTimes],
							True,resolvedScanTime
						];

						resolvedAcquisitionSurvey=Which[
							MatchQ[acquisitionSurvey,Except[Automatic]],acquisitionSurvey,
							!ddaQ,Null,
							(*if the user specifies a cycle time limit, we calculate what they want from that but should be at least 1*)
							MatchQ[cycleTimeLimit,Except[Automatic|Null]],
								Max[Floor[(cycleTimeLimit-resolvedScanTime)/resolvedFragmentScanTime],1],
							MatchQ[Lookup[methodPacket,AcquisitionSurveys],Except[Automatic|Null]],Lookup[methodPacket,AcquisitionSurveys],
							True,10
						];

						(*these MUST be defined iff DDA*)
						{
							fragmentScanTimeConflictQ,
							acquisitionSurveyConflictQ
						}=Map[
							If[ddaQ,NullQ[#],!NullQ[#]]&,
							{
								resolvedFragmentScanTime,
								resolvedAcquisitionSurvey
							}
						];

						(*the following options are optional, even if DDA mode is set*)
						resolvedMinimumThreshold=Which[
							MatchQ[minimumThreshold,Except[Automatic]],minimumThreshold,
							!ddaQ,Null,
							MatchQ[Lookup[methodPacket,MinimumThresholds],Except[Automatic|Null]],Lookup[methodPacket,MinimumThresholds],
							True,Null
						];

						resolvedAcquisitionLimit=Which[
							MatchQ[acquisitionLimit,Except[Automatic]],acquisitionLimit,
							!ddaQ,Null,
							MatchQ[Lookup[methodPacket,AcquisitionLimits],Except[Automatic|Null]],Lookup[methodPacket,AcquisitionLimits],
							True,Null
						];

						(*can be Null under DDA, but can't be set if not DDA*)
						acquisitionLimitConflictQ=If[!ddaQ,
							!NullQ[resolvedAcquisitionLimit],
							False
						];

						resolvedCycleTimeLimit=Which[
							MatchQ[cycleTimeLimit,Except[Automatic]],cycleTimeLimit,
							MatchQ[resolvedAcquisitionMode,Except[DataDependent]],Null,
							(*otherwise, just calculate this from the other options*)
							True,(resolvedAcquisitionSurvey*resolvedFragmentScanTime+resolvedScanTime)
						];

						(*check whether the time limit is less than the anticipated time*)
						cycleTimeLimitConflictQ=If[MatchQ[
								{resolvedCycleTimeLimit,resolvedAcquisitionSurvey,resolvedFragmentScanTime,resolvedScanTime},
								{Units[Minute],_Integer,Units[Minute],Units[Minute]}
							],
							(resolvedAcquisitionSurvey*resolvedFragmentScanTime+resolvedScanTime)>resolvedCycleTimeLimit,
							If[!NullQ[resolvedCycleTimeLimit], !ddaQ, False]
						];

						(*get a list of all of the measured masses*)
						(*we do this unitless; otherwise, it'll be incredibly slow*)
						massesToMeasure=Switch[resolvedMassDetection,
							_Span,Range[Sequence@@(Unitless[resolvedMassDetection,Gram/Mole])],
							MSAnalyteGroupP,Range[Sequence@@(Unitless[massRangeAnalyteType[resolvedMassDetection],Gram/Mole])],
								UnitsP[Gram/Mole],List[Unitless[resolvedMassDetection,Gram/Mole]],
							_,Unitless[resolvedMassDetection,Gram/Mole]
						];


						(*get the masses that we probably won't care about*)
						potentiallyUninterestingMasses=Complement[
							ToList[massesToMeasure],
							Unitless[sampleMolecularWeights,Gram/Mole]
						];

						{resolvedExclusionDomain,resolvedExclusionMass}=Which[
							(*if all nulls, return nulls*)
							MatchQ[{exclusionDomain,exclusionMass},{Null,Null}|{{Null},{Null}}],{Null,Null},
							(*if both are automatic and we're not in datadependent mode, then we just set Null *)
							MatchQ[{exclusionDomain,exclusionMass},{Automatic,Automatic}|{{Automatic},{Automatic}}]&&MatchQ[resolvedAcquisitionMode,Except[DataDependent]],{Null,Null},
							(*otherwise, we can draw from the supplied method, if one exists*)
							MatchQ[{exclusionDomain,exclusionMass},{Automatic,Automatic}|{{Automatic},{Automatic}}]&&And[
								MatchQ[Lookup[methodPacket,ExclusionDomains],Except[Automatic|Null|{}]],
								MatchQ[Lookup[methodPacket,ExclusionMasses],Except[Automatic|Null|{}]]
							],{
								Lookup[methodPacket,ExclusionDomains],
								Lookup[methodPacket,ExclusionMasses]
							},

							(*if still automatic, just set to Null*)
							MatchQ[
								{exclusionDomain,exclusionMass,exclusionMassTolerance,exclusionRetentionTimeTolerance},
								ConstantArray[Automatic|{Automatic},4]
							],{Null,Null},

							(*otherwise, we map through and resolve any automatics -- we're assuming that this is index-expanded at this point*)
							(*first we do any needed expansion*)
							True,(
								{innerExpandedExclusionDomain,innerExpandedExclusionMass}=Switch[{exclusionDomain,exclusionMass},
									(*if the exclusion domain is automatics, then match to to the exclusion mass*)
									{Automatic,Except[Automatic]},{ConstantArray[Automatic,Length[exclusionMass]],exclusionMass},
									(*otherwise, check vice versa*)
									{Except[Automatic],Automatic},{exclusionDomain,ConstantArray[Automatic,Length[exclusionDomain]]},
									(*otherwise, just make sure wrapped in a list*)
									_,ToList/@{exclusionDomain,exclusionMass}
								];
								Transpose@MapThread[Function[{currentExclusionDomain,currentExclusionMass,currentIndex},
									{
										(*if the domain is automatic, then just set to the entire domain*)
										If[MatchQ[currentExclusionDomain,Automatic],acquisitionWindow,currentExclusionDomain],
										(*if the mass is automatic, then just choose one we don't have*)
										If[MatchQ[currentExclusionMass,Automatic],
											{
												Once,
												If[currentIndex<Length[potentiallyUninterestingMasses],
													potentiallyUninterestingMasses[[currentIndex]]*Gram/Mole,
													(*otherwise, no idea what to do really*)
													First[massesToMeasure]*Gram/Mole
												]
											},
											currentExclusionMass
										]
									}
								],
								{
									innerExpandedExclusionDomain,
									innerExpandedExclusionMass,
									Range[Length@innerExpandedExclusionMass]
								}
							])
						];

						(*exclusion mode should only be on for data dependent and should not be null when the other is not*)
						exclusionModeMassConflictQ=Switch[{resolvedExclusionDomain, resolvedExclusionMass, resolvedAcquisitionMode},
							(*error no matter what if we have mismatching Null and specified*)
							{Null|{Null},Except[Null|{Null}],_},True,
							{Except[Null|{Null}],Null|{Null},_},True,
							(*error if we have not Null and acquisition mode is not DataDependent*)
							{Except[Null|{Null}],_,Except[DataDependent]},True,
							(*any other case is okay*)
							_,False
						];

						(*all of the exclusion modes have to be the same within (e.g. all Once*)
						exclusionModesVariedQ=If[MatchQ[resolvedExclusionMass,ListableP[Null]],
							False,
							Count[DeleteDuplicates[resolvedExclusionMass[[All,1]]], _] > 1
						];

						(*resolve the tolerance related options*)
						resolvedExclusionMassTolerance=Which[
							MatchQ[exclusionMassTolerance,Except[Automatic]],exclusionMassTolerance,
							MatchQ[resolvedAcquisitionMode,Except[DataDependent]],Null,
							NullQ[resolvedExclusionDomain],Null,
							MatchQ[Lookup[methodPacket,ExclusionMassTolerances],Except[{}|Automatic|Null]],Lookup[methodPacket,ExclusionMassTolerances],
							True,0.5 Gram/Mole
						];

						(*must be congruent with the other exclusion domain options*)
						exclusionMassToleranceConflictQ=Switch[{exclusionModeMassConflictQ, resolvedExclusionDomain, resolvedExclusionMass, resolvedExclusionMassTolerance},
							{True,___},False,
							{_,Null|{Null},Null|{Null},Except[Null|{Null}]},True,
							{_,Except[Null|{Null}],Except[Null|{Null}],Null|{Null}},True,
							(*any other case is okay*)
							_,False
						];

						(*resolve the tolerance related options*)
						resolvedExclusionRetentionTimeTolerance=Which[
							exclusionModeMassConflictQ, False,
							MatchQ[exclusionRetentionTimeTolerance, Except[Automatic]], exclusionRetentionTimeTolerance,
							MatchQ[resolvedAcquisitionMode, Except[DataDependent]], Null,
							NullQ[resolvedExclusionDomain], Null,
							MatchQ[Lookup[methodPacket, ExclusionRetentionTimeTolerances], Except[{} | Automatic | Null]], Lookup[methodPacket, ExclusionRetentionTimeTolerances],
							True, 10 Second
						];

						(*must be congruent with the other exclusion domain options*)
						exclusionRetentionTimeToleranceConflictQ=Switch[{resolvedExclusionDomain, resolvedExclusionMass, resolvedExclusionRetentionTimeTolerance},
							{Null|{Null},Null|{Null},Except[Null|{Null}]},True,
							{Except[Null|{Null}],Except[Null|{Null}],Null|{Null}},True,
							(*any other case is okay*)
							_,False
						];

						(*to make things easier, figure out if these are all automatics or Nulls*)
						inclusionOptionsAllAutomaticQ=MatchQ[
							{inclusionDomain, inclusionMass, inclusionCollisionEnergy, inclusionDeclusteringVoltage, inclusionChargeState, inclusionScanTime },
							ConstantArray[Automatic|{Automatic},6]
						];
						inclusionOptionsAllNullQ=MatchQ[
							{inclusionDomain, inclusionMass, inclusionCollisionEnergy, inclusionDeclusteringVoltage, inclusionChargeState, inclusionScanTime },
							ConstantArray[Null|{Null},6]
						];

						{
							resolvedInclusionDomain,
							resolvedInclusionMass,
							resolvedInclusionCollisionEnergy,
							resolvedInclusionDeclusteringVoltage,
							resolvedInclusionChargeState,
							resolvedInclusionScanTime
						}=Which[
							(*if all Null, easypeasy*)
							inclusionOptionsAllNullQ,ConstantArray[Null,6],
							(*check if everything is automatic*)
							(*if not data dependent, we set to Nulls*)
							inclusionOptionsAllAutomaticQ&&!ddaQ,
								ConstantArray[Null,6],
							(*otherwise, we can draw from the supplied method, if one exists*)
							inclusionOptionsAllAutomaticQ&&And[
								MatchQ[Lookup[methodPacket,InclusionDomains],Except[Automatic|Null|{}]],
								MatchQ[Lookup[methodPacket,InclusionMasses],Except[Automatic|Null|{}]],
								MatchQ[Lookup[methodPacket,InclusionCollisionEnergies],Except[Automatic|Null|{}]],
								MatchQ[Lookup[methodPacket,InclusionDeclusteringVoltages],Except[Automatic|Null|{}]],
								MatchQ[Lookup[methodPacket,InclusionChargeStates],Except[Automatic|Null|{}]],
								MatchQ[Lookup[methodPacket,InclusionScanTimes],Except[Automatic|Null|{}]]
							],{
								(* Note that in Object[Method, MassAcquisition] InclusionDomains are defined as List not span *)
								(* i.e., {start, end} instead of start;;end. Need to convert this *)
								Map[
									Apply[Span, #]&,
									Lookup[methodPacket,InclusionDomains]
								],
								Lookup[methodPacket,InclusionMasses],
								Lookup[methodPacket,InclusionCollisionEnergies],
								Lookup[methodPacket,InclusionDeclusteringVoltages],
								Lookup[methodPacket,InclusionChargeStates],
								Lookup[methodPacket,InclusionScanTimes]
							},
							inclusionOptionsAllAutomaticQ&&MatchQ[inclusionMassTolerance,Automatic|Null],ConstantArray[Null,6],
							(*otherwise, we map through and go for gold -- everything should already be index matching at this point but we might need to expan*)
							True,(
								(*find the option that's expanded*)
								inclusionLength=Length@FirstCase[{inclusionDomain, inclusionMass, inclusionCollisionEnergy, inclusionDeclusteringVoltage, inclusionChargeState, inclusionScanTime},_List,{Automatic}];
								(*we do a further expansion here*)
								{
									currentExpandedInclusionDomain,
									currentExpandedInclusionMass,
									currentExpandedInclusionCollisionEnergy,
									currentExpandedInclusionDeclusteringVoltage,
									currentExpandedInclusionChargeState,
									currentExpandedInclusionScanTime
								}=Map[
									If[MatchQ[#,Automatic|Null],
										ConstantArray[#,inclusionLength],
										ToList[#]
									]&,{
										inclusionDomain,
										inclusionMass,
										inclusionCollisionEnergy,
										inclusionDeclusteringVoltage,
										inclusionChargeState,
										inclusionScanTime
									}
								];
								Transpose@MapThread[
									Function[{
										currentInclusionDomain,
										currentInclusionMass,
										currentInclusionCollisionEnergy,
										currentInclusionDeclusteringVoltage,
										currentInclusionChargeState,
										currentInclusionScanTime,
										currentIndex
									},
										{
											If[MatchQ[currentInclusionDomain,Automatic],acquisitionWindow,currentInclusionDomain],
											(*if the mass is automatic, then just choose among the analytes*)
											If[MatchQ[currentInclusionMass,Automatic],
												{
													Preferential,
													If[currentIndex<Length[Flatten@sampleMolecularWeights],
														(Flatten@sampleMolecularWeights)[[currentIndex]],
														(*otherwise, no idea what to do really*)
														First[massesToMeasure]*Gram/Mole
													]
												},
												currentInclusionMass
											],
											If[MatchQ[currentInclusionCollisionEnergy,Automatic],
												If[!NullQ[resolvedCollisionEnergy], FirstOrDefault[resolvedCollisionEnergy,resolvedCollisionEnergy], 40 Volt],
												currentInclusionCollisionEnergy
											],
											If[MatchQ[currentInclusionDeclusteringVoltage,Automatic],
												resolvedDeclusteringVoltage,
												currentInclusionDeclusteringVoltage
											],
											If[MatchQ[currentInclusionChargeState,Automatic],
												1,
												currentInclusionChargeState
											],
											If[MatchQ[currentInclusionScanTime,Automatic],
												resolvedFragmentScanTime,
												currentInclusionScanTime
											]
										}
									],
									{
										currentExpandedInclusionDomain,
										currentExpandedInclusionMass,
										currentExpandedInclusionCollisionEnergy,
										currentExpandedInclusionDeclusteringVoltage,
										currentExpandedInclusionChargeState,
										currentExpandedInclusionScanTime,
										Range[inclusionLength]
									}
								]
							)
						];

						combinedInclusionOptions={
							resolvedInclusionDomain,
							resolvedInclusionMass,
							resolvedInclusionCollisionEnergy,
							resolvedInclusionDeclusteringVoltage,
							resolvedInclusionChargeState,
							resolvedInclusionScanTime
						};

						inclusionOptionsConflictQ=Which[
							(*can't have mix of Nulls and defined *)
							MemberQ[combinedInclusionOptions,Null]&&MemberQ[combinedInclusionOptions,Except[Null]],True,
							(*otherwise, can't have anything we're not DDA*)
							MemberQ[combinedInclusionOptions,Except[Null]]&&MatchQ[resolvedAcquisitionMode,Except[DataDependent]],True,
							True,False
						];

						(*resolve the tolerance related options*)
						resolvedInclusionMassTolerance=Which[
							MatchQ[inclusionMassTolerance,Except[Automatic]],inclusionMassTolerance,
							MatchQ[resolvedAcquisitionMode,Except[DataDependent]],Null,
							NullQ[resolvedInclusionDomain],Null,
							MatchQ[Lookup[methodPacket,InclusionMassTolerances],Except[{}|Automatic|Null]],Lookup[methodPacket,InclusionMassTolerances],
							True,0.5 Gram/Mole
						];

						(*must be congruent with the other inclusion domain options*)
						inclusionMassToleranceConflictQ=Which[
							inclusionOptionsConflictQ, False,
							(*tolerance should not be specified, if none of the inclusion options are specified*)
							MatchQ[resolvedInclusionMassTolerance,Except[Null]]&&!MemberQ[combinedInclusionOptions,Except[Null]],True,
							(*like wise, it should be Null if the other options are set*)
							NullQ[resolvedInclusionMassTolerance]&&!MemberQ[combinedInclusionOptions,Null],True,
							(*any other case is okay*)
							True,False
						];

						(*define all of the charge state options*)
						chargeStateExclusionOptions={
							chargeStateExclusionLimit,
							chargeStateExclusion,
							chargeStateMassTolerance
						};

						isotopeExclusionOptions={
							isotopicExclusion,
							isotopeRatioThreshold,
							isotopeDetectionMinimum,
							isotopeMassTolerance,
							isotopeRatioTolerance
						};

						(**)
						resolvedSurveyChargeStateExclusion=Which[
							MatchQ[surveyChargeStateExclusion,Except[Automatic]],surveyChargeStateExclusion,
							!ddaQ,Null,
							(*check to see if we have any of the relevant options set*)
							MemberQ[chargeStateExclusionOptions,Except[Automatic|Null]],True,
							(*otherwise, if all automatic, check the method packet*)
							MemberQ[Lookup[methodPacket,{ChargeStateLimits,ChargeStateSelections,ChargeStateMassTolerances}],Except[Automatic|Null|{}]],True,
							True,False
						];

						resolvedSurveyIsotopeExclusion=Which[
							MatchQ[surveyIsotopeExclusion,Except[Automatic]],surveyIsotopeExclusion,
							!ddaQ,Null,
							(*check to see if we have any of the relevant options set*)
							MemberQ[isotopeExclusionOptions,Except[ListableP[Automatic|Null]]],True,
							(*otherwise, if all automatic, check the method packet*)
							MemberQ[Lookup[methodPacket,{IsotopeMassDifferences,IsotopeRatios,IsotopeDetectionMinimums,IsotopeRatioTolerances, IsotopeMassTolerances}],Except[Automatic|Null|{}]],True,
							True,False
						];

						(*make the Q versions*)
						surveyChargeStateExclusionQ=MatchQ[resolvedSurveyChargeStateExclusion,True];
						surveyIsotopeExclusionQ=MatchQ[resolvedSurveyIsotopeExclusion,True];

						resolvedChargeStateExclusionLimit=Which[
							MatchQ[chargeStateExclusionLimit,Except[Automatic]],chargeStateExclusionLimit,
							!ddaQ,Null,
							!surveyChargeStateExclusionQ,Null,
							surveyChargeStateExclusionQ&&MatchQ[Lookup[methodPacket,ChargeStateLimits],Except[Null|Automatic|{}]],
								Lookup[methodPacket,ChargeStateLimits],
							(*if the survey is more than 5, stop at five*)
							MatchQ[resolvedAcquisitionSurvey,GreaterEqualP[5]],5,
							True,resolvedAcquisitionSurvey
						];

						resolvedChargeStateExclusion=Which[
							MatchQ[chargeStateExclusion,Except[Automatic]],chargeStateExclusion,
							!ddaQ,Null,
							!surveyChargeStateExclusionQ,Null,
							surveyChargeStateExclusionQ&&MatchQ[Lookup[methodPacket,ChargeStateSelections],Except[Null|Automatic|{}]],
								Lookup[methodPacket,ChargeStateSelections],
							(*just default here*)
							True,{1,2}
						];

						(*the only problem is when these are set and it's not DDA*)
						(*the only problem is when these are set and it's not DDA*)
						{
							chargeStateExclusionConflictQ
						} = Map[
							If[!ddaQ, !NullQ[#], False]&,
							{
								resolvedChargeStateExclusion
							}
						];

						(*can have the limit conflict, if the number if not DDA or higher than the survey*)
						chargeStateExclusionLimitConflictQ=Which[
							!NullQ[resolvedChargeStateExclusionLimit]&&!ddaQ,True,
							MatchQ[resolvedChargeStateExclusionLimit,GreaterP[resolvedAcquisitionSurvey]],True,
							True,False
						];

						resolvedChargeStateMassTolerance=Which[
							MatchQ[chargeStateMassTolerance,Except[Automatic]],chargeStateMassTolerance,
							!ddaQ,Null,
							!surveyChargeStateExclusionQ,Null,
							surveyChargeStateExclusionQ&&MatchQ[Lookup[methodPacket,ChargeStateMassTolerances],Except[Null|Automatic|{}]],
							Lookup[methodPacket,ChargeStateMassTolerances],
							(*just default here*)
							True,0.5 Gram/Mole
						];

						chargeStateMassToleranceConflictQ=Which[
							(*don't want to throw multiple errors*)
							chargeStateExclusionConflictQ, False,
							(*tolerance should not be specified, if none of the inclusion options are specified*)
							MatchQ[resolvedChargeStateMassTolerance, Except[Null]] && MemberQ[{resolvedChargeStateExclusionLimit, resolvedChargeStateExclusion}, Null|{Null..}], True,
							(*like wise, it should be Null if the other options are set*)
							NullQ[resolvedChargeStateMassTolerance] && MemberQ[{resolvedChargeStateExclusionLimit, resolvedChargeStateExclusion}, Except[Null|{Null..}]], True,
							(*any other case is okay*)
							True, False
						];

						{
							resolvedIsotopicExclusion,
							resolvedIsotopeRatioThreshold,
							resolvedIsotopeDetectionMinimum
						}=Which[
							(*check if they are all automatic and whether to *)
							MatchQ[{isotopicExclusion,isotopeRatioThreshold,isotopeDetectionMinimum},ConstantArray[Automatic|{Automatic},3]]&&!ddaQ,
								ConstantArray[Null,3],
							!surveyIsotopeExclusionQ&&MatchQ[{isotopicExclusion,isotopeRatioThreshold,isotopeDetectionMinimum},ConstantArray[Automatic|Null|{(Automatic|Null)..},3]],
								ConstantArray[Null,3],
							(*check if we can pull from the method file*)
							MatchQ[{isotopicExclusion,isotopeRatioThreshold,isotopeDetectionMinimum},ConstantArray[Automatic,3]]&&And[
								MatchQ[Lookup[methodPacket,IsotopeMassDifferences],Except[Automatic|Null|{}]],
								MatchQ[Lookup[methodPacket,IsotopeRatios],Except[Automatic|Null|{}]],
								MatchQ[Lookup[methodPacket,IsotopeDetectionMinimums],Except[Automatic|Null|{}]]
							],{
								Lookup[methodPacket,IsotopeMassDifferences],
								Lookup[methodPacket,IsotopeRatios],
								Lookup[methodPacket,IsotopeDetectionMinimums]
							},
							(*otherwise, we map through*)
							True,(
								(*we need to get the length to expand by*)
								isotopeExclusionLength=Length@FirstCase[{isotopicExclusion,isotopeRatioThreshold,isotopeDetectionMinimum},_List,{Automatic}];
								(*expand all of these variables*)
								{
									currentExpandedIsotopicExclusion,
									currentExpandedIsotopeRatioThreshold,
									currentExpandedIsotopeDetectionMinimum
								}=Map[
									If[MatchQ[#,Automatic|Null],ConstantArray[#,isotopeExclusionLength],ToList[#]]&,
									{
										isotopicExclusion,
										isotopeRatioThreshold,
										isotopeDetectionMinimum
									}
								];
								Transpose@MapThread[
									Function[{currentIsotopicExclusion, currentIsotopeRatioThreshold, currentIsotopeDetectionMinimum, currentIndex},
										{
											If[MatchQ[currentIsotopicExclusion,Automatic],
												currentIndex*1*Gram/Mole,
												currentIsotopicExclusion
											],
											If[MatchQ[currentIsotopeRatioThreshold,Automatic],
												0.1,
												currentIsotopeRatioThreshold
											],
											If[MatchQ[currentIsotopeDetectionMinimum,Automatic],
												10*1/Second,
												currentIsotopeDetectionMinimum
											]
										}
									],
									{
										currentExpandedIsotopicExclusion,
										currentExpandedIsotopeRatioThreshold,
										currentExpandedIsotopeDetectionMinimum,
										Range[isotopeExclusionLength]
									}
								]
							)
						];

						(*we can't do more than 2 isotopic exclusions*)
						isotopicExclusionLimitQ=If[!NullQ[resolvedIsotopicExclusion],
							Length[resolvedIsotopicExclusion]>2,
							False
						];

						(*check for conflicts*)
						isotopicExclusionConflictQ=Which[
							(*mix of Nulls and sets is bad*)
							And[
								MemberQ[{resolvedIsotopicExclusion,resolvedIsotopeRatioThreshold,resolvedIsotopeDetectionMinimum},Null],
								MemberQ[{resolvedIsotopicExclusion,resolvedIsotopeRatioThreshold,resolvedIsotopeDetectionMinimum},Except[Null]]
							],True,
							(*nothing should be set if not dda*)
							!ddaQ&&MemberQ[{resolvedIsotopicExclusion,resolvedIsotopeRatioThreshold,resolvedIsotopeDetectionMinimum},Except[Null]], True,
							(*otherwise false*)
							True,False
						];

						(*this is shared by the charge state and the isotope options*)
						resolvedIsotopeMassTolerance=Which[
							MatchQ[isotopeMassTolerance,Except[Automatic]],isotopeMassTolerance,
							!ddaQ,Null,
							!resolvedSurveyChargeStateExclusion&&!resolvedSurveyIsotopeExclusion,Null,
							Or[resolvedSurveyChargeStateExclusion,resolvedSurveyIsotopeExclusion]&&MatchQ[Lookup[methodPacket,IsotopeMassTolerances], Except[Null|Automatic|{}]],
								Lookup[methodPacket,IsotopeMassTolerances],
							(*just default here*)
							True,0.5 Gram/Mole
						];

						(*must be congruent with the other options*)
						isotopeMassToleranceConflictQ=Which[
							(*we don't want to throw this error if the charge state one is set*)
							isotopicExclusionConflictQ||chargeStateMassToleranceConflictQ||chargeStateExclusionLimitConflictQ||chargeStateExclusionConflictQ||isotopicExclusionLimitQ, False,
							(*tolerance should not be specified, if none of the inclusion options are specified*)
							MatchQ[resolvedIsotopeMassTolerance, Except[Null]] && MatchQ[{resolvedChargeStateExclusion, resolvedIsotopicExclusion, resolvedIsotopeRatioThreshold, resolvedIsotopeDetectionMinimum}, {(Null|{Null})..}], True,
							(*like wise, it should not be Null if the other options are set*)
							NullQ[resolvedIsotopeMassTolerance] && MemberQ[{resolvedChargeStateExclusion, resolvedIsotopicExclusion, resolvedIsotopeRatioThreshold, resolvedIsotopeDetectionMinimum}, Except[Null|{Null}]], True,
							(*any other case is okay*)
							True, False
						];

						resolvedIsotopeRatioTolerance=Which[
							MatchQ[isotopeRatioTolerance,Except[Automatic]],isotopeRatioTolerance,
							!ddaQ,Null,
							!resolvedSurveyIsotopeExclusion,Null,
							resolvedSurveyIsotopeExclusion&&MatchQ[Lookup[methodPacket,IsotopeRatioTolerances], Except[Null|Automatic|{}]],
								Lookup[methodPacket,IsotopeRatioTolerances],
							(*just default here*)
							True,30 Percent
						];

						isotopeRatioToleranceConflictQ=Which[
							isotopicExclusionConflictQ, False,
							(*tolerance should not be specified, if none of the inclusion options are specified*)
							MatchQ[resolvedIsotopeRatioTolerance,Except[Null]]&&!MemberQ[{resolvedIsotopicExclusion,resolvedIsotopeRatioThreshold,resolvedIsotopeDetectionMinimum},Except[Null]],True,
							(*like wise, it should not be Null if the other options are set*)
							NullQ[resolvedIsotopeRatioTolerance]&&!MemberQ[{resolvedIsotopicExclusion,resolvedIsotopeRatioThreshold,resolvedIsotopeDetectionMinimum},Null],True,
							(*any other case is okay*)
							True,False
						];

						(*return everything from the depth 3 mapping*)
						{
							(*11*)resolvedAcquisitionMode,
							(*12*)resolvedFragment,
							(*13*)resolvedMassDetection,
							(*14*)resolvedScanTime,
							(*15*)resolvedFragmentMassDetection,
							(*16*)resolvedCollisionEnergy,
							(*17*)resolvedCollisionEnergyMassProfile,
							(*18*)resolvedCollisionEnergyMassScan,
							(*19*)resolvedFragmentScanTime,
							(*20*)resolvedAcquisitionSurvey,
							(*21*)resolvedMinimumThreshold,
							(*22*)resolvedAcquisitionLimit,
							(*23*)resolvedCycleTimeLimit,
							(*24*)resolvedExclusionDomain,
							(*25*)resolvedExclusionMass,
							(*26*)resolvedExclusionMassTolerance,
							(*27*)resolvedExclusionRetentionTimeTolerance,
							(*28*)resolvedInclusionDomain,
							(*29*)resolvedInclusionMass,
							(*30*)resolvedInclusionCollisionEnergy,
							(*31*)resolvedInclusionDeclusteringVoltage,
							(*32*)resolvedInclusionChargeState,
							(*33*)resolvedInclusionScanTime,
							(*34*)resolvedInclusionMassTolerance,
							(*35*)resolvedSurveyChargeStateExclusion,
							(*36*)resolvedSurveyIsotopeExclusion,
							(*37*)resolvedChargeStateExclusionLimit,
							(*38*)resolvedChargeStateExclusion,
							(*39*)resolvedChargeStateMassTolerance,
							(*40*)resolvedIsotopicExclusion,
							(*41*)resolvedIsotopeRatioThreshold,
							(*42*)resolvedIsotopeDetectionMinimum,
							(*43*)resolvedIsotopeMassTolerance,
							(*44*)resolvedIsotopeRatioTolerance,
							(*45*)resolvedNeutralLoss,
							(*46*)resolvedDwellTime,
							(*47*)resolvedMassDetectionStepSize,
							(*48*)resolvedCollisionCellExitVoltage,
							(*49*)resolvedMultipleReactionMonitoringAssay,
							(*E1*)fragmentModeConflictQ,
							(*E2*)massDetectionConflictQ,
							(*E3*)fragmentMassDetectionConflictQ,
							(*E4*)collisionEnergyConflictQ,
							(*E5*)collisionEnergyScanConflictQ,
							(*E6*)fragmentScanTimeConflictQ,
							(*E7*)acquisitionSurveyConflictQ,
							(*E8*)acquisitionLimitConflictQ,
							(*E9*)cycleTimeLimitConflictQ,
							(*E10*)exclusionModeMassConflictQ,
							(*E11*)exclusionMassToleranceConflictQ,
							(*E12*)exclusionRetentionTimeToleranceConflictQ,
							(*E13*)inclusionOptionsConflictQ,
							(*E14*)inclusionMassToleranceConflictQ,
							(*E15*)chargeStateExclusionLimitConflictQ,
							(*E16*)chargeStateExclusionConflictQ,
							(*E17*)chargeStateMassToleranceConflictQ,
							(*E18*)isotopicExclusionLimitQ,
							(*E19*)isotopicExclusionConflictQ,
							(*E20*)isotopeMassToleranceConflictQ,
							(*E21*)isotopeRatioToleranceConflictQ,
							(*E22*)collisionEnergyProfileConflictQ,
							(*E23*)exclusionModesVariedQ,
							(*E24*)acqModeMassAnalyzerMismatchedQ,
							(*E25*)invalidCollisionVoltagesQ,
							(*E26*)invalidLengthOfInputOptionQ,
							(*E27*)collisionEnergyAcqModeInvalidQ,
							(*E27.5*)sciExInstrumentError,
							(*W1*)autoNeutralLossValueWarningQ
						}
					)],
					{
						(*1*)resolvedAcquisitionWindowList,
						(*2*)acquisitionModeList,
						(*3*)fragmentList,
						(*4*)massDetectionList,
						(*5*)scanTimeList,
						(*6*)fragmentMassDetectionList,
						(*7*)collisionEnergyList,
						(*8*)collisionEnergyMassProfileList,
						(*9*)collisionEnergyMassScanList,
						(*10*)fragmentScanTimeList,
						(*11*)acquisitionSurveyList,
						(*12*)minimumThresholdList,
						(*13*)acquisitionLimitList,
						(*14*)cycleTimeLimitList,
						(*15*)exclusionDomainList,
						(*16*)exclusionMassList,
						(*17*)exclusionMassToleranceList,
						(*18*)exclusionRetentionTimeToleranceList,
						(*19*)inclusionDomainList,
						(*20*)inclusionMassList,
						(*21*)inclusionCollisionEnergyList,
						(*22*)inclusionDeclusteringVoltageList,
						(*23*)inclusionChargeStateList,
						(*24*)inclusionScanTimeList,
						(*25*)inclusionMassToleranceList,
						(*26*)surveyChargeStateExclusionList,
						(*27*)surveyIsotopeExclusionList,
						(*28*)chargeStateExclusionLimitList,
						(*29*)chargeStateExclusionList,
						(*30*)chargeStateMassToleranceList,
						(*31*)isotopicExclusionList,
						(*32*)isotopeRatioThresholdList,
						(*33*)isotopeDetectionMinimumList,
						(*34*)isotopeMassToleranceList,
						(*35*)isotopeRatioToleranceList,
						(*36*)fieldValuesFromMethodPackets,
						(*37*)neutralLossList,
						(*38*)dwellTimeList,
						(*39*)collisionCellExitVoltageList,
						(*40*)massDetectionStepSizeList,
						(*41*)multipleReactionMonitoringAssaysList
					}
				];

				(*return everything*)
				depth2Result={
					(*1*)resolvedIonMode,
					(*2*)resolvedMassSpectrometryMethod,
					(*3*)resolvedESICapillaryVoltage,
					(*4*)resolvedDeclusteringVoltage,
					(*5*)resolvedStepwaveVoltage,
					(*6*)resolvedSourceTemperature,
					(*7*)resolvedDesolvationTemperature,
					(*8*)resolvedDesolvationGasFlow,
					(*9*)resolvedConeGasFlow,
					(*9.5*)resolvedIonGuideVoltage,
					(*depth 3/4 options*)
					(*10*)resolvedAcquisitionWindowList,
					(*11-50, E1-E27.5, W1*)Sequence@@acquisitionOptionsMapResult,
					(*E28*)overlappingAcquisitionWindowsQ,
					(*E29*)acquisitionWindowsTooLongQ,
					(*E30*)invalidSourceTemperatureQ,
					(*E31*)invalidVoltagesQ,
					(*E32*)invalidGasFlowQ,
					(*E33*)invalidScanTimeQ,
					(*E34*)numberOfPoints
				};

				depth2Result
			)
		],
		{
			(*N1*)filteredAnalytePackets,
			(*N2*)simulatedSamplePackets,
			(*N3*)sampleCategories,
			(*N4*)bestSamplesMassSpecMethods,
			(*N5*)Lookup[hplcResolvedOptionsCorrected,FlowRate],
			(*N6*)Lookup[hplcResolvedOptionsCorrected,Gradient],
			(*N7*)Lookup[roundedOptionsAssociation,IonMode],
			(*N8*)Lookup[roundedOptionsAssociation,MassSpectrometryMethod],
			(*N9*)Lookup[roundedOptionsAssociation,ESICapillaryVoltage],
			(*N10*)Lookup[roundedOptionsAssociation,DeclusteringVoltage],
			(*N11*)Lookup[roundedOptionsAssociation,StepwaveVoltage],
			(*N12*)Lookup[roundedOptionsAssociation,IonGuideVoltage],
			(*N13*)Lookup[roundedOptionsAssociation,SourceTemperature],
			(*N14*)Lookup[roundedOptionsAssociation,DesolvationTemperature],
			(*N15*)Lookup[roundedOptionsAssociation,DesolvationGasFlow],
			(*N16*)Lookup[roundedOptionsAssociation,ConeGasFlow],
			(*our fun times depth 3 and depth 4 options*)
			(*1-39*)Sequence@@expandedAcquisitionModeOptions
		}
	];
	
	
	(*=====  Resolved Calibrant After IonMode =====*)
	(*we'll resolve the calibrant based on the first sample*)
	{calibrantLookup,secondCalibrantLookup}=Lookup[roundedOptionsAssociation,{Calibrant,SecondCalibrant}];
	firstSampleCategory=First@sampleCategories;
	
	(* get the ion mode for resolving the calibrant *)
	uniqueIonMode=DeleteDuplicates[resolvedIonModes];
	firstIonMode=First@resolvedIonModes;
	secondIonMode=If[Length[uniqueIonMode]>1, Last[uniqueIonMode], Null];
	
	(* -- Resolve calibrant -- *)
	
	(* resolve the first calibrant *)
	resolvedCalibrant=If[tripleQuadQ,
		(* for QQQ as the mass analyzer, resolved based on the first IonMode*)
		Which[
			MatchQ[calibrantLookup,Except[Automatic]],calibrantLookup,
			MatchQ[firstIonMode,Negative], Model[Sample,StockSolution,Standard,"NEG PPG, 3E-5M (30 microMolar or stocksolution), SciEX Standard"],   (*id:mnk9jOR70aJN*)
			True, Model[Sample,StockSolution,Standard,"POS PPG, 2E-7M (0.2 microMolar or 500:1), SciEX Standard"]  (*id:zGj91a7DEKxx*)
		],
		
		(* for using QTOF as the mass analyzer, resolve calibrant based on molecular weight and sample identity *)
		Switch[{calibrantLookup,firstSampleCategory,Mean[Flatten@sampleMolecularWeights],firstIonMode},
			{ObjectP[],_,_,_},calibrantLookup,
			(* for Peptides, we always use Sodium Iodide *)
			{_,Peptide,_,_},Model[Sample,StockSolution,Standard,"Sodium Iodide ESI Calibrant"],
			(* for big stuff, we use cesium iodide if it's Positive and sodium iodide if Negative *)
			{_,Protein,_,Positive},Model[Sample,StockSolution,Standard,"Cesium Iodide ESI Calibrant"],
			{_,Protein,_,Negative},Model[Sample,StockSolution,Standard,"Sodium Iodide ESI Calibrant"],
			{_,_,GreaterP[2000 Dalton],Positive},Model[Sample,StockSolution,Standard,"Cesium Iodide ESI Calibrant"],
			{_,_,GreaterP[2000 Dalton],Negative},Model[Sample,StockSolution,Standard,"Sodium Iodide ESI Calibrant"],
			(* for small molecules, we always use Sodium Formate *)
			{_,_,LessEqualP[1200 Dalton],_},Model[Sample,StockSolution,Standard,"Sodium Formate ESI Calibrant"],
			(* catch all for medium sized molecules etc is sodium iodide *)
			_,Model[Sample,StockSolution,Standard,"Sodium Iodide ESI Calibrant"]
		]
	];
	(* resolve the 2nd calibrant  *)
	resolvedSecondCalibrant=Which[
		
		(* user user specified value*)
		MatchQ[secondCalibrantLookup,Except[Automatic]],secondCalibrantLookup,
		
		(* for QQQ, if the specifiedIonMode is negative user NEG PPG*)
		tripleQuadQ&&MatchQ[secondIonMode,Negative],Model[Sample,StockSolution,Standard,"NEG PPG, 3E-5M (30 microMolar or stocksolution), SciEX Standard"],   (*id:mnk9jOR70aJN*)
		
		(* For QQQ in positive, use POS PPG *)
		tripleQuadQ&&MatchQ[secondIonMode,Positive],Model[Sample,StockSolution,Standard,"POS PPG, 2E-7M (0.2 microMolar or 500:1), SciEX Standard"],  (*id:zGj91a7DEKxx*)
		
		(* otherwise set to Null*)
		True,Null
	];
	
	(* Throw a warning if two calibrant are the same *)
	sameCalibrantWarning=If[tripleQuadtQ,
		MatchQ[calibrantLookup,secondCalibrantLookup]&&(!NullQ[secondCalibrantLookup]),
		False
	];
	
	If[sameCalibrantWarning,Message[Warning::SameCalibrantsForLCMS,ObjectToString[calibrantLookup],ObjectToString[secondCalibrantLookup]]];
	
	(* Throw a warning if the MassAnalyzer is not qqq and 2nd Calibrant is specified *)
	If[(!tripleQuadQ)&&MatchQ[secondCalibrantLookup,ObjectP[]],
		Message[Warning::OnlyOneCalibrantWillBeRan,ObjectToString[resolvedCalibrant,Simulation -> updatedSimulation],ObjectToString[secondCalibrantLookup,Simulation -> updatedSimulation]];
	
	];
	
	(*we do the standard and blank versions of the options*)
	{
		{
			(*1*)resolvedStandardIonModes,
			(*2*)resolvedStandardMassSpectrometryMethods,
			(*3*)resolvedStandardESICapillaryVoltages,
			(*4*)resolvedStandardDeclusteringVoltages,
			(*5*)resolvedStandardStepwaveVoltages,
			(*6*)resolvedStandardSourceTemperatures,
			(*7*)resolvedStandardDesolvationTemperatures,
			(*8*)resolvedStandardDesolvationGasFlows,
			(*9*)resolvedStandardConeGasFlows,
			(*9.5*)resolvedStandardIonGuideVoltages,
			(*depth 3-4 options*)
			(*10*)resolvedStandardAcquisitionWindows,
			(*11*)resolvedStandardAcquisitionModes,
			(*12*)resolvedStandardFragments,
			(*13*)resolvedStandardMassDetections,
			(*14*)resolvedStandardScanTimes,
			(*15*)resolvedStandardFragmentMassDetections,
			(*16*)resolvedStandardCollisionEnergies,
			(*17*)resolvedStandardCollisionEnergyMassProfiles,
			(*18*)resolvedStandardCollisionEnergyMassScans,
			(*19*)resolvedStandardFragmentScanTimes,
			(*20*)resolvedStandardAcquisitionSurveys,
			(*21*)resolvedStandardMinimumThresholds,
			(*22*)resolvedStandardAcquisitionLimits,
			(*23*)resolvedStandardCycleTimeLimits,
			(*24*)resolvedStandardExclusionDomains,
			(*25*)resolvedStandardExclusionMasses,
			(*26*)resolvedStandardExclusionMassTolerances,
			(*27*)resolvedStandardExclusionRetentionTimeTolerances,
			(*28*)resolvedStandardInclusionDomains,
			(*29*)resolvedStandardInclusionMasses,
			(*30*)resolvedStandardInclusionCollisionEnergies,
			(*31*)resolvedStandardInclusionDeclusteringVoltages,
			(*32*)resolvedStandardInclusionChargeStates,
			(*33*)resolvedStandardInclusionScanTimes,
			(*34*)resolvedStandardInclusionMassTolerances,
			(*35*)resolvedStandardSurveyChargeStateExclusions,
			(*36*)resolvedStandardSurveyIsotopeExclusions,
			(*37*)resolvedStandardChargeStateExclusionLimits,
			(*38*)resolvedStandardChargeStateExclusions,
			(*39*)resolvedStandardChargeStateMassTolerances,
			(*40*)resolvedStandardIsotopicExclusions,
			(*41*)resolvedStandardIsotopeRatioThresholds,
			(*42*)resolvedStandardIsotopeDetectionMinimums,
			(*43*)resolvedStandardIsotopeMassTolerances,
			(*44*)resolvedStandardIsotopeRatioTolerances,
			(*45*)resolvedStandardNeutralLosses,
			(*46*)resolvedStandardDwellTimes,
			(*47*)resolvedStandardMassDetectionStepSizes,
			(*48*)resolvedStandardCollisionCellExitVoltages,
			(*49*)resolvedStandardMultipleReactionMonitoringAssays,
			(*E1*)fragmentModeConflictStandardBool,
			(*E2*)massDetectionConflictStandardBool,
			(*E3*)fragmentMassDetectionConflictStandardBool,
			(*E4*)collisionEnergyConflictStandardBool,
			(*E5*)collisionEnergyScanConflictStandardBool,
			(*E6*)fragmentScanTimeConflictStandardBool,
			(*E7*)acquisitionSurveyConflictStandardBool,
			(*E8*)acquisitionLimitConflictStandardBool,
			(*E9*)cycleTimeLimitConflictStandardBool,
			(*E10*)exclusionModeMassConflictStandardBool,
			(*E11*)exclusionMassToleranceConflictStandardBool,
			(*E12*)exclusionRetentionTimeToleranceConflictStandardBool,
			(*E13*)inclusionOptionsConflictStandardBool,
			(*E14*)inclusionMassToleranceConflictStandardBool,
			(*E15*)chargeStateExclusionLimitConflictStandardBool,
			(*E16*)chargeStateExclusionConflictStandardBool,
			(*E17*)chargeStateMassToleranceConflictStandardBool,
			(*E18*)isotopicExclusionLimitStandardBool,
			(*E19*)isotopicExclusionConflictStandardBool,
			(*E20*)isotopeMassToleranceConflictStandardBool,
			(*E21*)isotopeRatioToleranceConflictStandardBool,
			(*E22*)collisionEnergyProfileConflictStandardBool,
			(*E23*)exclusionModesVariedStandardBool,
			(*E24*)acqModeMassAnalyzerMismatchedStandardBool,
			(*E25*)invalidCollisionVoltagesStandardBool,
			(*E26*)invalidLengthOfInputOptionStandardBool,
			(*E27*)collisionEnergyAcqModeInvalidStandardBool,
			(*E27.5*)sciExInstrumentErrorsStandard,
			(*W1*)autoNeutralLossValueWarningStandardList,
			(*E28*)overlappingAcquisitionWindowStandardBool,
			(*E29*)acquisitionWindowsTooLongStandardBool,
			(*E30*)invalidSourceTemperatureStandardBool,
			(*E31*)invalidVoltagesStandardBool,
			(*E32*)invalidGasFlowStandardBool,
			(*E33*)invalidScanTimeStandardBool
		},
		{
			(*1*)resolvedBlankIonModes,
			(*2*)resolvedBlankMassSpectrometryMethods,
			(*3*)resolvedBlankESICapillaryVoltages,
			(*4*)resolvedBlankDeclusteringVoltages,
			(*5*)resolvedBlankStepwaveVoltages,
			(*6*)resolvedBlankSourceTemperatures,
			(*7*)resolvedBlankDesolvationTemperatures,
			(*8*)resolvedBlankDesolvationGasFlows,
			(*9*)resolvedBlankConeGasFlows,
			(*9.5*)resolvedBlankIonGuideVoltages,
			(*depth 3-4 options*)
			(*10*)resolvedBlankAcquisitionWindows,
			(*11*)resolvedBlankAcquisitionModes,
			(*12*)resolvedBlankFragments,
			(*13*)resolvedBlankMassDetections,
			(*14*)resolvedBlankScanTimes,
			(*15*)resolvedBlankFragmentMassDetections,
			(*16*)resolvedBlankCollisionEnergies,
			(*17*)resolvedBlankCollisionEnergyMassProfiles,
			(*18*)resolvedBlankCollisionEnergyMassScans,
			(*19*)resolvedBlankFragmentScanTimes,
			(*20*)resolvedBlankAcquisitionSurveys,
			(*21*)resolvedBlankMinimumThresholds,
			(*22*)resolvedBlankAcquisitionLimits,
			(*23*)resolvedBlankCycleTimeLimits,
			(*24*)resolvedBlankExclusionDomains,
			(*25*)resolvedBlankExclusionMasses,
			(*26*)resolvedBlankExclusionMassTolerances,
			(*27*)resolvedBlankExclusionRetentionTimeTolerances,
			(*28*)resolvedBlankInclusionDomains,
			(*29*)resolvedBlankInclusionMasses,
			(*30*)resolvedBlankInclusionCollisionEnergies,
			(*31*)resolvedBlankInclusionDeclusteringVoltages,
			(*32*)resolvedBlankInclusionChargeStates,
			(*33*)resolvedBlankInclusionScanTimes,
			(*34*)resolvedBlankInclusionMassTolerances,
			(*35*)resolvedBlankSurveyChargeStateExclusions,
			(*36*)resolvedBlankSurveyIsotopeExclusions,
			(*37*)resolvedBlankChargeStateExclusionLimits,
			(*38*)resolvedBlankChargeStateExclusions,
			(*39*)resolvedBlankChargeStateMassTolerances,
			(*40*)resolvedBlankIsotopicExclusions,
			(*41*)resolvedBlankIsotopeRatioThresholds,
			(*42*)resolvedBlankIsotopeDetectionMinimums,
			(*43*)resolvedBlankIsotopeMassTolerances,
			(*44*)resolvedBlankIsotopeRatioTolerances,
			(*45*)resolvedBlankNeutralLosses,
			(*46*)resolvedBlankDwellTimes,
			(*47*)resolvedBlankMassDetectionStepSizes,
			(*48*)resolvedBlankCollisionCellExitVoltages,
			(*49*)resolvedBlankMultipleReactionMonitoringAssays,
			(*E1*)fragmentModeConflictBlankBool,
			(*E2*)massDetectionConflictBlankBool,
			(*E3*)fragmentMassDetectionConflictBlankBool,
			(*E4*)collisionEnergyConflictBlankBool,
			(*E5*)collisionEnergyScanConflictBlankBool,
			(*E6*)fragmentScanTimeConflictBlankBool,
			(*E7*)acquisitionSurveyConflictBlankBool,
			(*E8*)acquisitionLimitConflictBlankBool,
			(*E9*)cycleTimeLimitConflictBlankBool,
			(*E10*)exclusionModeMassConflictBlankBool,
			(*E11*)exclusionMassToleranceConflictBlankBool,
			(*E12*)exclusionRetentionTimeToleranceConflictBlankBool,
			(*E13*)inclusionOptionsConflictBlankBool,
			(*E14*)inclusionMassToleranceConflictBlankBool,
			(*E15*)chargeStateExclusionLimitConflictBlankBool,
			(*E16*)chargeStateExclusionConflictBlankBool,
			(*E17*)chargeStateMassToleranceConflictBlankBool,
			(*E18*)isotopicExclusionLimitBlankBool,
			(*E19*)isotopicExclusionConflictBlankBool,
			(*E20*)isotopeMassToleranceConflictBlankBool,
			(*E21*)isotopeRatioToleranceConflictBlankBool,
			(*E22*)collisionEnergyProfileConflictBlankBool,
			(*E23*)exclusionModesVariedBlankBool,
			(*E24*)acqModeMassAnalyzerMismatchedBlankBool,
			(*E25*)invalidCollisionVoltagesBlankBool,
			(*E26*)invalidLengthOfInputOptionBlankBool,
			(*E27*)collisionEnergyAcqModeInvalidBlankBool,
			(*E27.5*)sciExInstrumentErrorsBlank,
			(*W1*)autoNeutralLossValueWarningBlankList,
			(*E28*)overlappingAcquisitionWindowBlankBool,
			(*E29*)acquisitionWindowsTooLongBlankBool,
			(*E30*)invalidSourceTemperatureBlankBool,
			(*E31*)invalidVoltagesBlankBool,
			(*E32*)invalidGasFlowBlankBool,
			(*E33*)invalidScanTimeBlankBool
		},
		{
			(*1*)resolvedColumnPrimeIonModes,
			(*2*)resolvedColumnPrimeMassSpectrometryMethods,
			(*3*)resolvedColumnPrimeESICapillaryVoltages,
			(*4*)resolvedColumnPrimeDeclusteringVoltages,
			(*5*)resolvedColumnPrimeStepwaveVoltages,
			(*6*)resolvedColumnPrimeSourceTemperatures,
			(*7*)resolvedColumnPrimeDesolvationTemperatures,
			(*8*)resolvedColumnPrimeDesolvationGasFlows,
			(*9*)resolvedColumnPrimeConeGasFlows,
			(*9.5*)resolvedColumnPrimeIonGuideVoltages,
			(*10*)resolvedColumnPrimeAcquisitionWindows,
			(*11*)resolvedColumnPrimeAcquisitionModes,
			(*12*)resolvedColumnPrimeFragments,
			(*13*)resolvedColumnPrimeMassDetections,
			(*14*)resolvedColumnPrimeScanTimes,
			(*15*)resolvedColumnPrimeFragmentMassDetections,
			(*16*)resolvedColumnPrimeCollisionEnergies,
			(*17*)resolvedColumnPrimeCollisionEnergyMassProfiles,
			(*18*)resolvedColumnPrimeCollisionEnergyMassScans,
			(*19*)resolvedColumnPrimeFragmentScanTimes,
			(*20*)resolvedColumnPrimeAcquisitionSurveys,
			(*21*)resolvedColumnPrimeMinimumThresholds,
			(*22*)resolvedColumnPrimeAcquisitionLimits,
			(*23*)resolvedColumnPrimeCycleTimeLimits,
			(*24*)resolvedColumnPrimeExclusionDomains,
			(*25*)resolvedColumnPrimeExclusionMasses,
			(*26*)resolvedColumnPrimeExclusionMassTolerances,
			(*27*)resolvedColumnPrimeExclusionRetentionTimeTolerances,
			(*28*)resolvedColumnPrimeInclusionDomains,
			(*29*)resolvedColumnPrimeInclusionMasses,
			(*30*)resolvedColumnPrimeInclusionCollisionEnergies,
			(*31*)resolvedColumnPrimeInclusionDeclusteringVoltages,
			(*32*)resolvedColumnPrimeInclusionChargeStates,
			(*33*)resolvedColumnPrimeInclusionScanTimes,
			(*34*)resolvedColumnPrimeInclusionMassTolerances,
			(*35*)resolvedColumnPrimeSurveyChargeStateExclusions,
			(*36*)resolvedColumnPrimeSurveyIsotopeExclusions,
			(*37*)resolvedColumnPrimeChargeStateExclusionLimits,
			(*38*)resolvedColumnPrimeChargeStateExclusions,
			(*39*)resolvedColumnPrimeChargeStateMassTolerances,
			(*40*)resolvedColumnPrimeIsotopicExclusions,
			(*41*)resolvedColumnPrimeIsotopeRatioThresholds,
			(*42*)resolvedColumnPrimeIsotopeDetectionMinimums,
			(*43*)resolvedColumnPrimeIsotopeMassTolerances,
			(*44*)resolvedColumnPrimeIsotopeRatioTolerances,
			(*45*)resolvedColumnPrimeNeutralLosses,
			(*46*)resolvedColumnPrimeDwellTimes,
			(*47*)resolvedColumnPrimeMassDetectionStepSizes,
			(*48*)resolvedColumnPrimeCollisionCellExitVoltages,
			(*49*)resolvedColumnPrimeMultipleReactionMonitoringAssays,
			(*E1*)fragmentModeConflictColumnPrimeBool,
			(*E2*)massDetectionConflictColumnPrimeBool,
			(*E3*)fragmentMassDetectionConflictColumnPrimeBool,
			(*E4*)collisionEnergyConflictColumnPrimeBool,
			(*E5*)collisionEnergyScanConflictColumnPrimeBool,
			(*E6*)fragmentScanTimeConflictColumnPrimeBool,
			(*E7*)acquisitionSurveyConflictColumnPrimeBool,
			(*E8*)acquisitionLimitConflictColumnPrimeBool,
			(*E9*)cycleTimeLimitConflictColumnPrimeBool,
			(*E10*)exclusionModeMassConflictColumnPrimeBool,
			(*E11*)exclusionMassToleranceConflictColumnPrimeBool,
			(*E12*)exclusionRetentionTimeToleranceConflictColumnPrimeBool,
			(*E13*)inclusionOptionsConflictColumnPrimeBool,
			(*E14*)inclusionMassToleranceConflictColumnPrimeBool,
			(*E15*)chargeStateExclusionLimitConflictColumnPrimeBool,
			(*E16*)chargeStateExclusionConflictColumnPrimeBool,
			(*E17*)chargeStateMassToleranceConflictColumnPrimeBool,
			(*E18*)isotopicExclusionLimitColumnPrimeBool,
			(*E19*)isotopicExclusionConflictColumnPrimeBool,
			(*E20*)isotopeMassToleranceConflictColumnPrimeBool,
			(*E21*)isotopeRatioToleranceConflictColumnPrimeBool,
			(*E22*)collisionEnergyProfileConflictColumnPrimeBool,
			(*E23*)exclusionModesVariedColumnPrimeBool,
			(*E24*)acqModeMassAnalyzerMismatchedColumnPrimeBool,
			(*E25*)invalidCollisionVoltagesColumnPrimeBool,
			(*E26*)invalidLengthOfInputOptionColumnPrimeBool,
			(*E27*)collisionEnergyAcqModeInvalidColumnPrimeBool,
			(*E27.5*)sciExInstrumentErrorsColumnPrime,
			(*W1*)autoNeutralLossValueWarningColumnPrimeList,
			(*E28*)overlappingAcquisitionWindowColumnPrimeBool,
			(*E29*)acquisitionWindowsTooLongColumnPrimeBool,
			(*E30*)invalidSourceTemperatureColumnPrimeBool,
			(*E31*)invalidVoltagesColumnPrimeBool,
			(*E32*)invalidGasFlowColumnPrimeBool,
			(*E33*)invalidScanTimeColumnPrimeBool
		},
		{
			(*1*)resolvedColumnFlushIonModes,
			(*2*)resolvedColumnFlushMassSpectrometryMethods,
			(*3*)resolvedColumnFlushESICapillaryVoltages,
			(*4*)resolvedColumnFlushDeclusteringVoltages,
			(*5*)resolvedColumnFlushStepwaveVoltages,
			(*6*)resolvedColumnFlushSourceTemperatures,
			(*7*)resolvedColumnFlushDesolvationTemperatures,
			(*8*)resolvedColumnFlushDesolvationGasFlows,
			(*9*)resolvedColumnFlushConeGasFlows,
			(*9.5*)resolvedColumnFlushIonGuideVoltages,
			(*depth 3-4 options*)
			(*10*)resolvedColumnFlushAcquisitionWindows,
			(*11*)resolvedColumnFlushAcquisitionModes,
			(*12*)resolvedColumnFlushFragments,
			(*13*)resolvedColumnFlushMassDetections,
			(*14*)resolvedColumnFlushScanTimes,
			(*15*)resolvedColumnFlushFragmentMassDetections,
			(*16*)resolvedColumnFlushCollisionEnergies,
			(*17*)resolvedColumnFlushCollisionEnergyMassProfiles,
			(*18*)resolvedColumnFlushCollisionEnergyMassScans,
			(*19*)resolvedColumnFlushFragmentScanTimes,
			(*20*)resolvedColumnFlushAcquisitionSurveys,
			(*21*)resolvedColumnFlushMinimumThresholds,
			(*22*)resolvedColumnFlushAcquisitionLimits,
			(*23*)resolvedColumnFlushCycleTimeLimits,
			(*24*)resolvedColumnFlushExclusionDomains,
			(*25*)resolvedColumnFlushExclusionMasses,
			(*26*)resolvedColumnFlushExclusionMassTolerances,
			(*27*)resolvedColumnFlushExclusionRetentionTimeTolerances,
			(*28*)resolvedColumnFlushInclusionDomains,
			(*29*)resolvedColumnFlushInclusionMasses,
			(*30*)resolvedColumnFlushInclusionCollisionEnergies,
			(*31*)resolvedColumnFlushInclusionDeclusteringVoltages,
			(*32*)resolvedColumnFlushInclusionChargeStates,
			(*33*)resolvedColumnFlushInclusionScanTimes,
			(*34*)resolvedColumnFlushInclusionMassTolerances,
			(*35*)resolvedColumnFlushSurveyChargeStateExclusions,
			(*36*)resolvedColumnFlushSurveyIsotopeExclusions,
			(*37*)resolvedColumnFlushChargeStateExclusionLimits,
			(*38*)resolvedColumnFlushChargeStateExclusions,
			(*39*)resolvedColumnFlushChargeStateMassTolerances,
			(*40*)resolvedColumnFlushIsotopicExclusions,
			(*41*)resolvedColumnFlushIsotopeRatioThresholds,
			(*42*)resolvedColumnFlushIsotopeDetectionMinimums,
			(*43*)resolvedColumnFlushIsotopeMassTolerances,
			(*44*)resolvedColumnFlushIsotopeRatioTolerances,
			(*45*)resolvedColumnFlushNeutralLosses,
			(*46*)resolvedColumnFlushDwellTimes,
			(*47*)resolvedColumnFlushMassDetectionStepSizes,
			(*48*)resolvedColumnFlushCollisionCellExitVoltages,
			(*49*)resolvedColumnFlushMultipleReactionMonitoringAssays,
			(*E1*)fragmentModeConflictColumnFlushBool,
			(*E2*)massDetectionConflictColumnFlushBool,
			(*E3*)fragmentMassDetectionConflictColumnFlushBool,
			(*E4*)collisionEnergyConflictColumnFlushBool,
			(*E5*)collisionEnergyScanConflictColumnFlushBool,
			(*E6*)fragmentScanTimeConflictColumnFlushBool,
			(*E7*)acquisitionSurveyConflictColumnFlushBool,
			(*E8*)acquisitionLimitConflictColumnFlushBool,
			(*E9*)cycleTimeLimitConflictColumnFlushBool,
			(*E10*)exclusionModeMassConflictColumnFlushBool,
			(*E11*)exclusionMassToleranceConflictColumnFlushBool,
			(*E12*)exclusionRetentionTimeToleranceConflictColumnFlushBool,
			(*E13*)inclusionOptionsConflictColumnFlushBool,
			(*E14*)inclusionMassToleranceConflictColumnFlushBool,
			(*E15*)chargeStateExclusionLimitConflictColumnFlushBool,
			(*E16*)chargeStateExclusionConflictColumnFlushBool,
			(*E17*)chargeStateMassToleranceConflictColumnFlushBool,
			(*E18*)isotopicExclusionLimitColumnFlushBool,
			(*E19*)isotopicExclusionConflictColumnFlushBool,
			(*E20*)isotopeMassToleranceConflictColumnFlushBool,
			(*E21*)isotopeRatioToleranceConflictColumnFlushBool,
			(*E22*)collisionEnergyProfileConflictColumnFlushBool,
			(*E23*)exclusionModesVariedColumnFlushBool,
			(*E24*)acqModeMassAnalyzerMismatchedColumnFlushBool,
			(*E25*)invalidCollisionVoltagesColumnFlushBool,
			(*E26*)invalidLengthOfInputOptionColumnFlushBool,
			(*E27*)collisionEnergyAcqModeInvalidColumnFlushBool,
			(*E27.5*)sciExInstrumentErrorsColumnFlush,
			(*W1*)autoNeutralLossValueWarningColumnFlushList,
			(*E28*)overlappingAcquisitionWindowColumnFlushBool,
			(*E29*)acquisitionWindowsTooLongColumnFlushBool,
			(*E30*)invalidSourceTemperatureColumnFlushBool,
			(*E31*)invalidVoltagesColumnFlushBool,
			(*E32*)invalidGasFlowColumnFlushBool,
			(*E33*)invalidScanTimeColumnFlushBool
		}
	}=Map[Function[{entry},

		(*we split our entry variable and figure out if we're going to even map thread in the first place*)
		{existsQ,passedOptions}=entry;

		If[!existsQ,
			(*just return Null and falses, if we're not map threading*)
			(* 51 options, and 31 error check and 1 warning check*)
			Join[ConstantArray[Null,50],ConstantArray[{False},35]],
			Transpose@MapThread[
				Function[{
					filteredAnalytePacketList,
					simulatedSamplePacket,
					sampleCategory,
					bestMassSpecMethod,
					flowRate,
					gradient,
					ionMode,
					massSpectrometryMethod,
					eSICapillaryVoltage,
					declusteringVoltage,
					stepwaveVoltage,
					ionGuideVoltage,
					sourceTemperature,
					desolvationTemperature,
					desolvationGasFlow,
					coneGasFlow,
					(*start depth 3/4 options*)
					acquisitionWindowList,
					acquisitionModeList,
					fragmentList,
					massDetectionList,
					scanTimeList,
					fragmentMassDetectionList,
					collisionEnergyList,
					collisionEnergyMassProfileList,
					collisionEnergyMassScanList,
					fragmentScanTimeList,
					acquisitionSurveyList,
					minimumThresholdList,
					acquisitionLimitList,
					cycleTimeLimitList,
					exclusionDomainList,
					exclusionMassList,
					exclusionMassToleranceList,
					exclusionRetentionTimeToleranceList,
					inclusionDomainList,
					inclusionMassList,
					inclusionCollisionEnergyList,
					inclusionDeclusteringVoltageList,
					inclusionChargeStateList,
					inclusionScanTimeList,
					inclusionMassToleranceList,
					surveyChargeStateExclusionList,
					surveyIsotopeExclusionList,
					chargeStateExclusionLimitList,
					chargeStateExclusionList,
					chargeStateMassToleranceList,
					isotopicExclusionList,
					isotopeRatioThresholdList,
					isotopeDetectionMinimumList,
					isotopeMassToleranceList,
					isotopeRatioToleranceList,
					neutralLossList,
					dwellTimeList,
					collisionCellExitVoltageList,
					massDetectionStepSizeList,
					multipleReactionMonitoringAssaysList
				}, ( (*no module because it's too slow*)
				
				
					(* -- Resolve ion mode -- *)
					pHValue = Lookup[simulatedSamplePacket, pH];
					pKaValue = If[!MatchQ[filteredAnalytePacketList, {} | {Null..}],
						Mean[Cases[Lookup[filteredAnalytePacketList, pKa], _?NumericQ]],
						Null];
					acid = If[!MatchQ[filteredAnalytePacketList, {} | {Null..}],
						Or @@ (Lookup[filteredAnalytePacketList, Acid] /. {Null | $Failed -> False}),
						Null];
					base = If[!MatchQ[filteredAnalytePacketList, {} | {Null..}],
						Or @@ (Lookup[filteredAnalytePacketList, Base] /. {Null | $Failed -> False}),
						Null];

					resolvedIonMode = Which[
						(*if the user specified it, then go with it*)
						MatchQ[ionMode, IonModeP], ionMode,
						MatchQ[bestMassSpecMethod, ObjectP[]], Lookup[fetchPacketFromCache[Download[bestMassSpecMethod,Object], cache], IonMode],

						(* - Resolve automatic - *)
						(* Sample type based resolution *)
						MatchQ[sampleCategory, Peptide | DNA], Positive,

						(* Acid/Based flag based resolution *)

						(* Bases are compounds that are protonated in solution, so they form positive ions -> Positive *)
						(* Acids are compounds that loose their proton in solution, so they form negative ions -> Negative *)
						TrueQ[acid], Negative,
						TrueQ[base], Positive,

						(* pKa-based resolution *)
						(* high pKa tend to bind protons, gaining a positive charge in the process -> Positive *)
						(* low pKA tend to loose a proton -> Negative *)
						NumericQ[pKaValue] && pKaValue < 8, Negative,
						NumericQ[pKaValue] && pKaValue >= 8, Positive,

						(* pH-based resolution *)
						(* pH is the property of the solution, so with low pH, a lot of protons are available, so most likely we are doing Positive *)
						NumericQ[pHValue] && pHValue < 5, Positive,
						NumericQ[pHValue] && pHValue >= 5, Negative,

						(* Default to positive, since this generally works *)
						True, Positive
					];

					(*resolve the mass spec method -- pretty easy*)
					resolvedMassSpectrometryMethod = Which[
						MatchQ[massSpectrometryMethod, ObjectP[]], massSpectrometryMethod,
						MatchQ[bestMassSpecMethod, ObjectP[]], bestMassSpecMethod,
						True, New
					];

					(*if we have resolved the mass spec method to an object, get the packet as, we'll reference it a lot*)
					resolvedMassAcquisitionMethodPacket = If[MatchQ[resolvedMassSpectrometryMethod, ObjectP[]],
						fetchPacketFromCache[Download[resolvedMassSpectrometryMethod,Object], cache]
					];
					
					(* -- Resolve SamplingConeVoltage -- *)
					defaultStepwaveVoltage=If[tripleQuadQ,
						
						(*Default to Null for QQQ*)
						Null,
						
						(*For QTOF default based on sample category*)
						Switch[{stepwaveVoltage,sampleCategory},
							{_,DNA},100 Volt,
							{_,Protein},120 Volt,
							_,40 Volt
						]
					];
					
					(*the flow rate may be a multiple and changing, so we take the maximum*)
					maximumFlowRate=If[MatchQ[flowRate,GreaterEqualP[0 * Milliliter / Minute]],
						flowRate,
						Max[flowRate[[All,2]]]
					];
					
					(* Build a shorthand for ionMode*)
					positiveIonModeQ=MatchQ[resolvedIonMode,Positive];
					
					(* for the low flow, we differentiate between Positive and Negative for the capillary voltage, for all other options we just look at the flow rate *)
					{
						defaultCapillaryVoltage,
						defaultSourceTemperature,
						defaultDesolvationTemperature,
						defaultDesolvationGasFlow
					}=If[tripleQuadQ,
						
						(* Default strategy for TripleQuad*)
						Switch[maximumFlowRate,
							RangeP[0*Milliliter/Minute,0.02*Milliliter/Minute],{If[positiveIonModeQ,5.5*Kilovolt,-4.5*Kilovolt],150 Celsius,100*Celsius,20*PSI},
							RangeP[0.021*Milliliter/Minute,0.1*Milliliter/Minute],{If[positiveIonModeQ,4.5*Kilovolt,-4.0*Kilovolt],150 Celsius,200*Celsius,40*PSI},
							RangeP[0.101*Milliliter/Minute,0.3*Milliliter/Minute],{If[positiveIonModeQ,4.5*Kilovolt,-4.0*Kilovolt],150 Celsius,350*Celsius,60*PSI},
							RangeP[0.301*Milliliter/Minute,0.5*Milliliter/Minute],{If[positiveIonModeQ,4.0*Kilovolt,-4.0*Kilovolt],150 Celsius,500*Celsius,60*PSI},
							GreaterP[0.5*Milliliter/Minute],{If[positiveIonModeQ,4.0*Kilovolt,-4.0*Kilovolt],150 Celsius,600*Celsius,75*PSI}
						],
						
						(* Default stategy for QTOF*)
						Switch[maximumFlowRate,
							RangeP[0*Milliliter/Minute,0.02*Milliliter/Minute],{If[MatchQ[resolvedIonMode,Positive],3*Kilovolt,2.8*Kilovolt],100*Celsius,200*Celsius,600*Liter/Hour},
							RangeP[0.021*Milliliter/Minute,0.1*Milliliter/Minute],{2.5*Kilovolt,120*Celsius,350*Celsius,800*Liter/Hour},
							RangeP[0.101*Milliliter/Minute,0.3*Milliliter/Minute],{2*Kilovolt,120*Celsius,450*Celsius,800*Liter/Hour},
							RangeP[0.301*Milliliter/Minute,0.5*Milliliter/Minute],{1.5*Kilovolt,150*Celsius,500*Celsius,1000*Liter/Hour},
							GreaterP[0.5*Milliliter/Minute],{1*Kilovolt,150*Celsius,600*Celsius,1200*Liter/Hour}
						]
					];
					
					(* set the defult DeclusteringVoltage *)
					defaultDeclusteringVoltage=If[tripleQuadQ,
						
						(* For QQQ DeclusteringVolate is set based on ionMode *)
						If[positiveIonModeQ,90*Volt,-90*Volt],
						
						(* For QTOF, default to 40 Volt *)
						40 Volt
					
					];
					
					(* Set the default IonGuideVoltage *)
					defaultIonGuideVoltage=If[tripleQuadQ,
						
						(* For QQQ DeclusteringVolate is set based on ionMode *)
						If[positiveIonModeQ,10*Volt,-10*Volt],
						
						(* For QTOF, default to Null *)
						Null
					
					];
					
					(* Set default cone gas flow *)
					defaultConeGasFlow=If[tripleQuadQ,50PSI,50 Liter/Hour];
					
					(* If the user supplied any of these values, we use these, otherwise we go with our resolution *)
					{
						resolvedESICapillaryVoltage,
						resolvedSourceTemperature,
						resolvedDesolvationTemperature,
						resolvedDesolvationGasFlow,
						resolvedStepwaveVoltage,
						resolvedDeclusteringVoltage,
						resolvedConeGasFlow,
						resolvedIonGuideVoltage
					}=MapThread[
						Function[{optionName,default,specified},
							Which[
								MatchQ[specified,Except[Automatic]],specified,
								MatchQ[bestMassSpecMethod,ObjectP[]],Lookup[resolvedMassAcquisitionMethodPacket,optionName,Null],
								True,default
							]
						],
						{
							{
								ESICapillaryVoltage,
								SourceTemperature,
								DesolvationTemperature,
								DesolvationGasFlow,
								StepwaveVoltage,
								DeclusteringVoltage,
								ConeGasFlow,
								IonGuideVoltage
							},
							{
								defaultCapillaryVoltage,
								defaultSourceTemperature,
								defaultDesolvationTemperature,
								defaultDesolvationGasFlow,
								defaultStepwaveVoltage,
								defaultDeclusteringVoltage,
								defaultConeGasFlow,
								defaultIonGuideVoltage
							},
							{
								eSICapillaryVoltage,
								sourceTemperature,
								desolvationTemperature,
								desolvationGasFlow,
								stepwaveVoltage,
								declusteringVoltage,
								coneGasFlow,
								ionGuideVoltage
							}
						}
					];
					
					(* build error checkers for all voltage and pressure voltages *)
					(* for ESI-QQQ the source temperature has to be 150 Celsius *)
					invalidSourceTemperatureQ=If[tripleQuadQ, !EqualQ[resolvedSourceTemperature, 150 Celsius], False];

					(* for ESI-QTOF all voltages needs to be positive *)
					invalidVoltagesQ=If[
						!tripleQuadQ,
						!And[
							MatchQ[resolvedESICapillaryVoltage,GreaterP[0 Volt]],
							MatchQ[resolvedDeclusteringVoltage,GreaterP[0 Volt]]
						],
						!If[MatchQ[resolvedIonMode,Positive],
							And[
								MatchQ[resolvedESICapillaryVoltage,GreaterP[0 Volt]],
								MatchQ[resolvedDeclusteringVoltage,GreaterP[0 Volt]]
							],
							And[
								MatchQ[resolvedESICapillaryVoltage,LessP[0 Volt]],
								MatchQ[resolvedDeclusteringVoltage,LessP[0 Volt]]
							]
						]
					];


					(* for pressure, ESI-QQQ use PSI, ESI-QTOF use mL/Min, so we need to check for error *)
					invalidGasFlowQ=If[
						tripleQuadQ,
						!And[
							MatchQ[resolvedDesolvationGasFlow,UnitsP[PSI]],
							MatchQ[resolvedConeGasFlow,UnitsP[PSI]]
						],
						!And[
							MatchQ[resolvedDesolvationGasFlow,UnitsP[Milliliter/Minute]],
							MatchQ[resolvedConeGasFlow,UnitsP[Milliliter/Minute]]
						]
					];


					(*get the gradient timing*)
					gradientEndTime = If[MatchQ[gradient, ObjectP[]],
						Lookup[fetchPacketFromCache[Download[gradient,Object], cache], Gradient][[-1, 1]],
						gradient[[-1, 1]]
					];

					(*we have to resolve the acquisiton windows first since resolution depends on others*)
					(*we take a look at the total time and go from there*)
					resolvedAcquisitionWindowList=Which[
						(*if just a single span, wrap with a list*)
						MatchQ[acquisitionWindowList,_Span],{acquisitionWindowList},
						(*if no automatics go with it*)
						MatchQ[acquisitionWindowList, List[Except[Automatic]..]], acquisitionWindowList,
						(*if fully automatic and there's a method, take the method*)
						MatchQ[acquisitionWindowList, Automatic | {Automatic}] && !NullQ[resolvedMassAcquisitionMethodPacket],
							Lookup[resolvedMassAcquisitionMethodPacket, AcquisitionWindows],
						(*if it's just automatics, we split the time window by the time*)
						MatchQ[acquisitionWindowList, {Automatic..}], splitTime[gradientEndTime, Length[acquisitionWindowList]],
						(*if we have the weird scenario where some are automatics, but some are defined, then we have to do more intricacy*)
						True, Module[{splitWindows},
							(*find the groupings of automatics versus spans*)
							splitWindows = SplitBy[acquisitionWindowList, MatchQ[#, Automatic]&];
							(*find the automatic groups and use the split time function to split each group of automatics accordingly*)
							Flatten@MapIndexed[Function[{grouping, index},
								If[MatchQ[grouping, {Automatic..}],
									(*in the case we find a group of automatics, we run the split time*)
									splitTime[
										splitWindows[[First@index - 1, -1, -1]] + 0.01Minute,
										If[Length[splitWindows] == First@index,
											gradientEndTime,
											splitWindows[[First@index + 1, 1, 1]] - 0.01Minute
										],
										Length[grouping]
									],
									(*otherwise, we don't have to anything*)
									grouping
								]],
								splitWindows
							]
						]
					];

					(*we need to check if any of the acquisition windows are overlapping*)
					overlappingAcquisitionWindowsQ = If[Length[resolvedAcquisitionWindowList] > 1,
						Not[And @@ MapThread[#1 <=#2&,
							{
								(*all of the end time points for each span except the last one*)
								Most[Last /@ SortBy[resolvedAcquisitionWindowList, First]],
								(*all of the starting time points for each span except the first*)
								Rest[First /@ SortBy[resolvedAcquisitionWindowList, First]]
							}
						]],
						(*if only 1, by definition can not be overlapping*)
						False
					];

					(*check to see that the acquisition windows are not too long*)
					acquisitionWindowsTooLongQ=Max[Map[Sequence @@ # &, resolvedAcquisitionWindowList]]>gradientEndTime;

					(*note how long the current windows are for the inner map thread*)
					lengthOfWindows=Length[resolvedAcquisitionWindowList];

					(*we need to convert our mass spec method to something mappable*)
					(*we need the index matching to be good. otherwise, there will be fireworks in terms of walls of red*)
					fieldValuesFromMethod = If[!NullQ[resolvedMassAcquisitionMethodPacket],
						Map[
							Function[{currentFieldValue}, Which[
								(* For single field, replicate to match sample length *)
								!MatchQ[currentFieldValue, _List],
								ConstantArray[currentFieldValue, Length[resolvedAcquisitionWindowList]],
								(*if the length are the same, then no problem*)
								Length[currentFieldValue] == Length[resolvedAcquisitionWindowList],
								currentFieldValue,
								(*if too long, just chop it off*)
								Length[currentFieldValue] > Length[resolvedAcquisitionWindowList],
								Take[currentFieldValue, Length[resolvedAcquisitionWindowList]],
								(*if too short, just pad out with automatics*)
								Length[currentFieldValue] < Length[resolvedAcquisitionWindowList],
								PadRight[currentFieldValue, Length[resolvedAcquisitionWindowList], Automatic]
							]],
							Lookup[resolvedMassAcquisitionMethodPacket, methodDepthThreeFields,{Null}]
						],
						(*otherwise, we just have a matrix of Automatics*)
						ConstantArray[ConstantArray[Automatic, Length[resolvedAcquisitionWindowList]], Length[methodDepthThreeFields]]
					];

					(*package this into a packet; otherwise, it'll be unwiedly*)
					(*so we'll have a list of packets index-matched to each AcquisitionWindow*)
					fieldValuesFromMethodPackets = Map[Function[{currentOptionSet},
						Association@MapThread[Rule, {methodDepthThreeFields, currentOptionSet}]
					],
						Transpose[fieldValuesFromMethod]
					];

					(*now resolve our depth 3 options*)
					acquisitionOptionsMapResult = Transpose@MapThread[
						Function[{
							(*1*)acquisitionWindow,
							(*2*)acquisitionMode,
							(*3*)fragment,
							(*4*)massDetection,
							(*5*)scanTime,
							(*6*)fragmentMassDetection,
							(*7*)collisionEnergy,
							(*8*)collisionEnergyMassProfile,
							(*9*)collisionEnergyMassScan,
							(*10*)fragmentScanTime,
							(*11*)acquisitionSurvey,
							(*12*)minimumThreshold,
							(*13*)acquisitionLimit,
							(*14*)cycleTimeLimit,
							(*15*)exclusionDomain,
							(*16*)exclusionMass,
							(*17*)exclusionMassTolerance,
							(*18*)exclusionRetentionTimeTolerance,
							(*19*)inclusionDomain,
							(*20*)inclusionMass,
							(*21*)inclusionCollisionEnergy,
							(*22*)inclusionDeclusteringVoltage,
							(*23*)inclusionChargeState,
							(*24*)inclusionScanTime,
							(*25*)inclusionMassTolerance,
							(*26*)surveyChargeStateExclusion,
							(*27*)surveyIsotopeExclusion,
							(*28*)chargeStateExclusionLimit,
							(*29*)chargeStateExclusion,
							(*30*)chargeStateMassTolerance,
							(*31*)isotopicExclusion,
							(*32*)isotopeRatioThreshold,
							(*33*)isotopeDetectionMinimum,
							(*34*)isotopeMassTolerance,
							(*35*)isotopeRatioTolerance,
							(*36*)methodPacket,
							(*37*)neutralLoss,
							(*38*)dwellTime,
							(*39*)collisionCellExitVoltage,
							(*40*)massDetectionStepSize,
							(*41*)multipleReactionMonitoringAssays
						}, ((*we're not doing this in a module because it's too slow*)
							(*group all of the DDA options together*)
							ddaOptions = {collisionEnergyMassScan, fragmentScanTime, acquisitionSurvey, minimumThreshold, acquisitionLimit, cycleTimeLimit, exclusionDomain,
								exclusionMass, exclusionMassTolerance, exclusionRetentionTimeTolerance, inclusionDomain, inclusionMass,
								inclusionCollisionEnergy, inclusionDeclusteringVoltage, inclusionChargeState, inclusionScanTime,
								inclusionMassTolerance, surveyChargeStateExclusion, surveyIsotopeExclusion, chargeStateExclusionLimit,
								chargeStateExclusion, chargeStateMassTolerance, isotopicExclusion, isotopeRatioThreshold,
								isotopeDetectionMinimum, isotopeMassTolerance, isotopeRatioTolerance};
							
							(* Unify the data structure for multipleReactionMonitoringAssays *)
							formattedMultipleReactionMonitoringAssays=If[
								MatchQ[multipleReactionMonitoringAssays, {{UnitsP[], UnitsP[], UnitsP[], UnitsP[]} ..}],
								{multipleReactionMonitoringAssays},
								multipleReactionMonitoringAssays
							];

							(*see if we have implications for what our mode should be*)
							resolvedAcquisitionMode=If[tripleQuadQ,
								
								(* Resolving AcquisitionMode for *)
								If[MatchQ[acquisitionMode,Except[Automatic]],
									(*if user specified a value, use what user specified*)
									acquisitionMode,
									
									(*Resolved automatic scan mode*)
									Switch[{fragment,massDetection,fragmentMassDetection},
										(*If user specified Fragment options as False, we resolved *)
										{False,_Span,_},MS1FullScan,
										{False,({UnitsP[Gram/Mole] ..}|UnitsP[Gram/Mole]|{UnitsP[Gram/Mole]}),_},SelectedIonMonitoring,
										
										(*Default all input as MS1FullScan*)
										{False,_,_},MS1FullScan,
										
										(*MS1:Range, MS2:Range, NeutralIonScan*)
										{True,_Span,_Span},NeutralIonLoss,
										
										(*MS1:Range, MS2:Selection, PrecursorIonScan*)
										{True,_Span,{UnitsP[Gram/Mole]}|UnitsP[Gram/Mole]},PrecursorIonScan,
										
										(*MS1:Selection, MS2:Range, ProductioIonScan*)
										{True,{UnitsP[Gram/Mole]}|UnitsP[Gram/Mole],_Span},MS1MS2ProductIonScan,
										
										(*MS1:Selection, MS2:Selection, MultipleReactionMonitoring*)
										{True,UnitsP[Gram/Mole]|{UnitsP[Gram/Mole]}|{UnitsP[Gram/Mole] ..},UnitsP[Gram/Mole]|{UnitsP[Gram/Mole]}|{UnitsP[Gram/Mole] ..}},MultipleReactionMonitoring,
										
										(*MS1:Selection, MS2:Automatic, Fragment is on we assigned it to ProductioIonScan*)
										{True,{UnitsP[Gram/Mole]}|{UnitsP[Gram/Mole]},_},MS1MS2ProductIonScan,
										
										(*MS1:Range, MS2:Selection, Fragment is on we assigned it to PrecursorIonScan*)
										{True,_Span,_},PrecursorIonScan,
										
										(*If we cannoe resolved by mass detection values, we check if user specified mass scan mode specific options*)
										
										(*If we cannoe resolved by mass detection values, we check if user specified mass scan mode specific options*)
										{_,_,_},Which[
											MatchQ[Lookup[methodPacket,AcquisitionModes],Except[Automatic]],Lookup[methodPacket,AcquisitionModes],
											MatchQ[neutralLoss,Except[Automatic]], NeutralIonLoss,
											MatchQ[formattedMultipleReactionMonitoringAssays, Except[Automatic]], MultipleReactionMonitoring,
											MatchQ[collisionEnergy,Except[Automatic|Null]],MS1MS2ProductIonScan,
											True,MS1FullScan
									
										]
									]
								],
								
								(*resolving logid for using QTOF as the mass analyzer*)
								Which[
									(*if set we go with it*)
									MatchQ[acquisitionMode,Except[Automatic|{Automatic}|Null]],acquisitionMode,
									MatchQ[fragment,False],MS1FullScan,
									(*check if any of the dda options are specified *)
									MemberQ[ddaOptions,Except[Automatic|Null]],DataDependent,
									(*is mass detection a range? if so DIA*)
									lengthOfWindows==1&&MatchQ[massDetection,_Span]&&Or[MatchQ[fragment,True],MatchQ[fragmentMassDetection,Except[Automatic|Null]]],DataIndependent,
									(*fragment stuff on?*)
									Or[MatchQ[fragment,True],MatchQ[fragmentMassDetection,Except[Automatic|Null]]],MS1MS2ProductIonScan,
									(*is the collision energy on?*)
									lengthOfWindows==1&&MatchQ[collisionEnergyMassProfile,Except[Automatic|Null]],DataIndependent,
									MatchQ[collisionEnergyMassProfile,Except[Automatic|Null]],DataDependent,
									MatchQ[collisionEnergy,Except[Automatic|Null]],MS1MS2ProductIonScan,
									(*otherwise check from the method*)
									MatchQ[Lookup[methodPacket,AcquisitionModes],Except[Automatic]],
									Lookup[methodPacket,AcquisitionModes],
									(*otherwise default*)
									True,MS1FullScan
								]
							];

							(*Error checker for mismatched acquisition mode and massanalyzer*)
							acqModeMassAnalyzerMismatchedQ=If[
								tripleQuadQ,
								MatchQ[resolvedAcquisitionMode,(DataDependent| DataIndependent)],
								MatchQ[resolvedAcquisitionMode,Except[(DataDependent| DataIndependent| MS1MS2ProductIonScan|MS1FullScan)]]
							];
							
							(*=============================================================================*)
							
							fragmentAcqModesP=(DataDependent| DataIndependent| MS1MS2ProductIonScan|NeutralIonLoss | PrecursorIonScan | MultipleReactionMonitoring);
							
							resolvedFragment=Which[
								MatchQ[fragment,Except[Automatic]],fragment,
								(*otherwise, should just inherit from the mode*)
								MatchQ[resolvedAcquisitionMode,fragmentAcqModesP], True,
								True,False
							];
							
							(*check that the fragment and the mode are compatible*)
							fragmentModeConflictQ=Switch[{resolvedAcquisitionMode, resolvedFragment},
								{fragmentAcqModesP,True},False,
								{MS1FullScan|SelectedIonMonitoring,False},False,
								_,True
							];
							
							(* === first build some shorthands and calculate some values for *)
							(* define our default mass ranges *)
							lowRange=Span[5 *Gram/Mole, 1250 *Gram/Mole];
							highRange=Span[500 *Gram/Mole, 2000 *Gram/Mole];
							
							
							(*Add a judgement ranged Mass scan boolean here. *)
							qqqRangedMassScanQ=MatchQ[resolvedAcquisitionMode,(MS1FullScan|MS1MS2ProductIonScan|NeutralIonLoss|PrecursorIonScan)];
							qqqRangedMS1MassScanQ=MatchQ[resolvedAcquisitionMode,(MS1FullScan|PrecursorIonScan|NeutralIonLoss)];
							qqqTandemMassQ=MatchQ[resolvedAcquisitionMode,(MS1MS2ProductIonScan|NeutralIonLoss|PrecursorIonScan|MultipleReactionMonitoring)];
							
							(* Analyte Molecular weight *)
							analytesMolecularWeights=Flatten[Lookup[filteredAnalytePacketList, MolecularWeight,{}]];
							
							(*Use a helper function to help us figure out what default mass selection value we should give our user*)
							defaultMassSelectionValue=ToList[If[
								MatchQ[Min[analytesMolecularWeights],RangeP[5*Gram/Mole,1998*Gram/Mole]],
								If[
									positiveIonModeQ,
									(Min[analytesMolecularWeights]+1*Gram/Mole),
									(Min[analytesMolecularWeights]-1*Gram/Mole)
								],
								500*Gram/Mole
							]];
							
							
							resolvedMassDetection=If[tripleQuadQ,
								(* resolve Mass Detection for QQQ as the mass analyzer *)
								Which[
									
									(*1. For those mass scan mode require MS1 as a ranged mass input, resolved it based on sample's category and molecular weight*)
									MatchQ[massDetection,Except[Automatic]],massDetection,
									
									(* 2. check if previous specified method has molecular weight filled*)
									(* Retrived the mass values from MinMasses and MaxMasses from the packet *)
									MatchQ[resolvedAcquisitionMode,qqqRangedMS1MassScanQ]&&And[
										MatchQ[Lookup[methodPacket,MinMasses],Except[Automatic|Null]],
										MatchQ[Lookup[methodPacket,MaxMasses],Except[Automatic|Null]]
									],
									Span[Lookup[methodPacket,MinMasses],Lookup[methodPacket,MaxMasses]],
									MatchQ[resolvedAcquisitionMode,(SelectedIonMonitoring| MultipleReactionMonitoring)]&&MatchQ[Lookup[methodPacket,MassSelections],Except[Automatic|Null]],
									Lookup[methodPacket,MassSelections],
									(*a specific selection is fine for any mode including MS1MS2ProductIonScan*)
									MatchQ[Lookup[methodPacket,MassSelections],List[_]],
									First@Lookup[methodPacket,MassSelections],
									
									(*3. Resolved based on other paramenters*)
									MatchQ[resolvedAcquisitionMode,(MS1FullScan|PrecursorIonScan|NeutralIonLoss)],Switch[
									{sampleCategory,Mean[analytesMolecularWeights]},
									{Peptide,_},lowRange,
									{_,RangeP[100*Gram/Mole,1250*Gram/Mole]},lowRange,
									{_,RangeP[500*Gram/Mole,2000*Gram/Mole]},highRange,
									_,lowRange
								],
									(*If user specified multiple reaction monitoring assays options, we resolved it based on what user specified*)
									
									And[MatchQ[formattedMultipleReactionMonitoringAssays,Except[Automatic]],!NullQ[formattedMultipleReactionMonitoringAssays]],Flatten[formattedMultipleReactionMonitoringAssays[[All,All,1]],1],
									
									(*For thos mass scan mode require MS1 as a ranged mass input, resolved it based on sample's and molecular weight*)
									(*If its Mininum MW fall into detection range, we use its protonated or deprotonated value (Positive or Negative value)*)
									
									MatchQ[resolvedAcquisitionMode,SelectedIonMonitoring|MultipleReactionMonitoring|ProduectIonScan(MS1MS2)],{defaultMassSelectionValue},
									True,defaultMassSelectionValue
								
								],
								
								(* resolve MassDetection for QTOF as the Mass Analyzer   *)
								Which[
									MatchQ[massDetection,Except[Automatic]],massDetection,
									(*ranges only work in the following acquisition modes*)
									MatchQ[resolvedAcquisitionMode,(DataDependent| DataIndependent| MS1FullScan)]&&And[
										MatchQ[Lookup[methodPacket,MinMasses],Except[Automatic|Null]],
										MatchQ[Lookup[methodPacket,MaxMasses],Except[Automatic|Null]]
									],
									Span[Lookup[methodPacket,MinMasses],Lookup[methodPacket,MaxMasses]],
									MatchQ[resolvedAcquisitionMode,(DataDependent| DataIndependent| MS1FullScan)]&&MatchQ[Lookup[methodPacket,MassSelections],Except[Automatic|Null]],
									Lookup[methodPacket,MassSelections],
									(*a specific selection is fine for any mode including MS1MS2ProductIonScan*)
									MatchQ[Lookup[methodPacket,MassSelections],List[_]],
									First@Lookup[methodPacket,MassSelections],
									MatchQ[resolvedAcquisitionMode,(DataDependent| DataIndependent| MS1FullScan)]&&MatchQ[sampleCategory,DNA|Protein],
									sampleCategory,
									(*if can only choose one, then do the analyte based on the mode (positive or negative)*)
									MatchQ[resolvedAcquisitionMode,MS1MS2ProductIonScan]&&(Length[filteredAnalytePacketList]>0),
									If[MatchQ[resolvedIonMode, Positive],
										FirstOrDefault[Lookup[filteredAnalytePacketList, MolecularWeight,{}], 150 Gram / Mole] + 1 Gram/Mole,
										FirstOrDefault[Lookup[filteredAnalytePacketList, MolecularWeight,{}], 150 Gram / Mole] - 1  Gram/Mole
									],
									MatchQ[resolvedAcquisitionMode,MS1MS2ProductIonScan],500Gram/Mole,
									(*otherwise do the full range*)
									True,
									Span[2 Gram/Mole,100000 Gram/Mole]
								]
							];
							
							(*multiple masses will not work with MS1MS2ProductIonScan, so we need to check this*)
							massDetectionConflictQ=If[tripleQuadQ,
								Which[
									qqqRangedMS1MassScanQ,MatchQ[resolvedMassDetection,Except[_Span]],
									MatchQ[resolvedAcquisitionMode,MS1MS2ProductIonScan],MatchQ[resolvedMassDetection,Except[UnitsP[Gram/Mole]|{UnitsP[Gram/Mole]}]],
									MatchQ[resolvedAcquisitionMode,SelectedIonMonitoring|MultipleReactionMonitoring],MatchQ[resolvedMassDetection,Except[GreaterP[Gram/Mole]|{GreaterP[Gram/Mole]..}]],
									_,False
								],
								Switch[{resolvedAcquisitionMode, resolvedMassDetection},
									{(DataDependent| DataIndependent| MS1FullScan),_},False,
									{MS1MS2ProductIonScan,Except[UnitsP[Gram/Mole]]},True,
									_,False
								]
							];
							(*scan time is fairly jejune*)
							resolvedScanTime=Which[
								MatchQ[scanTime,Except[Automatic]],scanTime,
								MatchQ[Lookup[methodPacket,ScanTimes],Except[Automatic]],
								Lookup[methodPacket,ScanTimes],
								(*our default*)
								True, 1 Second
							];

							(* Resolve MassDetectionStepSize*)
							resolvedMassDetectionStepSize=Which[
								(* if user specified a value, use what user specified *)
								MatchQ[massDetectionStepSize,Except[Automatic]],massDetectionStepSize,

								(* if the MassAcquisition Method specified a value, usue that value*)
								MatchQ[Lookup[methodPacket,MassDetectionStepSizes],Except[Automatic|Null|_Missing]],Lookup[methodPacket,MassDetectionStepSizes],

								(* check if the acquisitionMode is Range scan and MassAnalzyer is QQQ, resolve it to 0.1Gram/Mole *)
								(tripleQuadQ&&MatchQ[resolvedAcquisitionMode,(MS1FullScan|PrecursorIonScan|MS1MS2ProductIonScan|NeutralIonLoss)]), 0.1 Gram/Mole,

								(* In all other cases resolve it to Null *)
								True, Null

							];

							(* Determine the number of points in the ranged scan *)
							numberOfPoints = If[qqqRangedMS1MassScanQ&&tripleQuadQ, ((resolvedMassDetection[[2]] - resolvedMassDetection[[1]])/resolvedMassDetectionStepSize+1), Null];

							(* Check if the scan time is compatible with the QQQ *)
							invalidScanTimeQ = Which[
								(* If the mass spectra acquisition is QQQRangedMS1MassScan,*)
								qqqRangedMS1MassScanQ&&tripleQuadQ,
								(* Check that the resolved ScanTime is not outside the range supported by the QQQ *)
								Or[resolvedScanTime < numberOfPoints * 3 Microsecond, resolvedScanTime > numberOfPoints * 5 Second],
								(* Otherwise the ScanTime is valid *)
								True, False
							];

							sciExInstrumentError = If[MatchQ[{resolvedAcquisitionMode, resolvedMassDetection, resolvedMassDetectionStepSize, resolvedScanTime}, {MS1FullScan, Span[EqualP[5 Gram/Mole], EqualP[1250 Gram/Mole]], EqualP[0.1 Gram/Mole], EqualP[0.5 Second]}],
								True,
								False
							];
							
							resolvedFragmentMassDetection=If[tripleQuadQ,
								Which[
									
									MatchQ[fragmentMassDetection,Except[Automatic]],fragmentMassDetection,
									(*ranges only work in the following acquisition modes*)
									!qqqTandemMassQ,Null,
									
									(* for MS1MS2ProductIonScan|NeutralIonLoss, MS2 should be set to a _Span Value*)
									MatchQ[resolvedAcquisitionMode,(MS1MS2ProductIonScan|NeutralIonLoss)]&&And[
										MatchQ[Lookup[methodPacket,FragmentMinMasses],Except[Automatic|Null]],
										MatchQ[Lookup[methodPacket,FragmentMaxMasses],Except[Automatic|Null]]
									],
									Span[Lookup[methodPacket,FragmentMinMasses],Lookup[methodPacket,FragmentMaxMasses]],
									
									(* For PrecursorIonScan and MRM, the MS2 are supposed to be a single valuea or a list of values*)
									MatchQ[resolvedAcquisitionMode,(PrecursorIonScan|MultipleReactionMonitoring)]&&MatchQ[Lookup[methodPacket,FragmentMassSelections],Except[Automatic|Null]],
									Lookup[methodPacket,FragmentMassSelections],
									
									(* If massspec method was not specified, resolved based on other paramenter, most by acquisition mode *)
									(*For Product Ion Scan, resolve the automatic options to lowrange*)
									MatchQ[resolvedAcquisitionMode,MS1MS2ProductIonScan],lowRange,
									
									(*For MultipleReactionMonitoring mode*)
									MatchQ[resolvedAcquisitionMode,MultipleReactionMonitoring],
									If[And[MatchQ[formattedMultipleReactionMonitoringAssays,Except[Automatic]],!NullQ[formattedMultipleReactionMonitoringAssays]],

										(*First we check if user specified MultipleReactionMonitoring Assays*)
										Flatten[formattedMultipleReactionMonitoringAssays[[All,All,3]],1],

										(*we arbitarily resolved it to detect the dehydration product of the mass detection*)
										(resolvedMassDetection-18*Gram/Mole)
									],

									
									(*For NeutralLoss, and all other cases resolved it to All*)
									True, resolvedMassDetection
								],
								
								Which[
									MatchQ[fragmentMassDetection,Except[Automatic]],fragmentMassDetection,
									(*ranges only work in the following acquisition modes*)
									MatchQ[resolvedAcquisitionMode,MS1FullScan],Null,
									MatchQ[resolvedAcquisitionMode,(DataDependent| DataIndependent| MS1MS2ProductIonScan)]&&And[
										MatchQ[Lookup[methodPacket,FragmentMinMasses],Except[Automatic|Null]],
										MatchQ[Lookup[methodPacket,FragmentMaxMasses],Except[Automatic|Null]]
									],
									Span[Lookup[methodPacket,FragmentMinMasses],Lookup[methodPacket,FragmentMaxMasses]],
									MatchQ[resolvedAcquisitionMode,(DataDependent| DataIndependent| MS1MS2ProductIonScan)]&&MatchQ[Lookup[methodPacket,FragmentMassSelections],Except[Automatic|Null]],
									Lookup[methodPacket,FragmentMassSelections],
									(*otherwise do the full range*)
									True, All
								]
							];
							
							(*fragment mass should not be set for MS1FullScan, and it should not be Null otherwise*)
							fragmentMassDetectionConflictQ=If[tripleQuadQ,
								
								(* Check if the FragmentMassDetection is valid for QQQ as the mass analyzer *)
								Which[
									
									(* For MS1 only scans, no FragmentMassDetection must be Null*)
									MatchQ[resolvedAcquisitionMode,(FullScan|SelectectIonMonitoring)],MatchQ[resolvedFragmentMassDetection,Except[Null]],
									
									(* for product ion scan, FragmentMassDetection needs to be span *)
									MatchQ[resolvedAcquisitionMode,(MS1MS2ProductIonScan)],MatchQ[resolvedFragmentMassDetection,Except[_Span]],
									
									(* for PrecursorIonScan, FragmentMassDetection needs to be a single value *)
									MatchQ[resolvedAcquisitionMode,PrecursorIonScan],MatchQ[resolvedFragmentMassDetection,Except[UnitsP[Gram/Mole]]],
									
									(*For MRM, the FragmentMassDetection needs to be alist of mass values*)
									MatchQ[resolvedAcquisitionMode,MultipleReactionMonitoring],MatchQ[resolvedFragmentMassDetection,Except[ListableP[{GreaterP[Gram/Mole]..}]]],
									True,False
								],
								
								(* Error check for ESI-QTOF *)
								Or[
									MatchQ[resolvedAcquisitionMode,MS1FullScan]&&MatchQ[resolvedFragmentMassDetection,Except[Null|{Null}]],
									MatchQ[resolvedAcquisitionMode,Except[MS1FullScan]]&&MatchQ[resolvedFragmentMassDetection,Null|{Null}]
								]
							];
							
							
							resolvedCollisionEnergy=Which[
								
								(* If user specified a list of input mass detection values, but specified only a single collision
								 energy value, we assume this collision value will applied to all detections, thereby we expand it*)
								MatchQ[collisionEnergy,Except[Automatic]],If[
									MatchQ[resolvedMassDetection,{UnitsP[Gram/Mole] ..}]&&MatchQ[collisionEnergy,{UnitsP[Volt]}],
									ConstantArray[First[collisionEnergy],Length[resolvedMassDetection]],
									
									(* In all other cases we use what user specified, we will check if the length of each input are the same in below*)
									collisionEnergy
								],
								MatchQ[resolvedAcquisitionMode,MS1FullScan|SelectedIonMonitoring],Null,
								MatchQ[collisionEnergyMassProfile,Except[Automatic|Null]]&&MatchQ[resolvedAcquisitionMode, Except[DataIndependent]],Null,
								MatchQ[Lookup[methodPacket,LowCollisionEnergies],Except[Automatic|Null]],Null,
								MatchQ[Lookup[methodPacket,CollisionEnergies],Except[Automatic]], Lookup[methodPacket,CollisionEnergies],
								
								(*ESI-QQQ specific resolving strategy*)
								tripleQuadQ,Which[
									(*If user specified MultipleReactionAssays, we check user specified value and resolved those are Automatic*)
									And[MatchQ[formattedMultipleReactionMonitoringAssays,Except[Automatic]],!NullQ[formattedMultipleReactionMonitoringAssays]],
									Map[
										Function[eachCollisionEnergy,
											If[
												MatchQ[eachCollisionEnergy, Except[Automatic]],
												eachCollisionEnergy,
												If[positiveIonModeQ, 40*Volt, -40*Volt]
											]
										],
										Flatten[formattedMultipleReactionMonitoringAssays[[All,All,2]],1]
									],
									
									
									(*Otherwise resolved it based on input massRange type*)
									(*for single massDetection input, give it a single value*)
									MatchQ[resolvedMassDetection,_Span|UnitsP[Gram/Mole]], If[positiveIonModeQ,40*Volt,-40*Volt],
									
									(*For a list of inputs, give it a ConstantAssay*)
									True,If[positiveIonModeQ,ConstantArray[40*Volt, Length[resolvedMassDetection]],ConstantArray[-40*Volt, Length[resolvedMassDetection]]]
								
								],
								True,{40 Volt}
							];
							
							(* Resolve QQQ specific tandem mass options *)
							resolvedDwellTime=Which[
								
								(* If user specified a value, we use  what user specified and will check for conflict in later section*)
								MatchQ[dwellTime,Except[Automatic]],
								If[
									(* If user specified a list of input mass detection values, but specified only a single dwell time value, we assume this dwell time will applied to all detections, thereby we expand it*)
									MatchQ[resolvedMassDetection,{UnitsP[Gram/Mole] ..}]&&MatchQ[dwellTime,{UnitsP[Second]}|UnitsP[Second]],
									ConstantArray[First[ToList[dwellTime]],Length[resolvedMassDetection]],
									
									(* In all the other cases we use what user specified us, will check if there is a mis match in the later section*)
									dwellTime
								],
								
								(* If specified the method contains dwelltime, use that value *)
								MatchQ[Lookup[methodPacket,DwellTimes],Except[Automatic|Null]],Lookup[methodPacket,DwellTimes],
								
								(*use previsouly resolved voltage if available*)
								MatchQ[resolvedDwellTimes,ListableP[TimeP]|Null],First[resolvedDwellTimes],
								
								(*Resolve automatic option input.*)
								(*Resolve it to Null if we are not gonna use Fragment*)
								!MatchQ[resolvedAcquisitionMode,SelectedIonMonitoring|MultipleReactionMonitoring], Null,
								
								(*If user specified MultipleReactionAssays, we check user specified value and resolved those are Automatic*)
								And[MatchQ[formattedMultipleReactionMonitoringAssays,Except[Automatic]],!NullQ[formattedMultipleReactionMonitoringAssays]],
								Map[
									Function[eachDwellTime,
										If[
											MatchQ[eachDwellTime, Except[Automatic]],
											eachDwellTime,
											200*Millisecond
										]
									],
									Flatten[formattedMultipleReactionMonitoringAssays[[All,All,4]],1]
								],
								
								(*Otherwise resolved it based on input massRange type*)
								(*for single massDetection fixed valueinput, give it a single value*)
								MatchQ[resolvedMassDetection,UnitsP[Gram/Mole]], 200*Millisecond,
								
								(*For a list of inputs, give it a ConstantAssay*)
								MatchQ[resolvedMassDetection,{UnitsP[Gram/Mole]}],ConstantArray[200*Millisecond, Length[resolvedMassDetection]],
								
								(*Catch all to set this option to Null*)
								True,Null
							
							
							];
							(* Build a error check for MRM assays to check if all inputs are in same length *)
							(*Generate how many mass detection values for this samplw we have*)
							numberOfMassInputs=Length[ToList[resolvedMassDetection]];
							
							(*Check if we have same number of inputs for those options with an adder*)
							invalidLengthOfInputOptionQ=Module[
								{
									relaventOptionNotListedNames, finalBooleanList,
									relaventOptionNotListedOptions
								},
								
								relaventOptionNotListedOptions={
									(*1*)resolvedCollisionEnergy,
									(*2*)resolvedFragmentMassDetection,
									(*3*)resolvedDwellTime
								};
								
								finalBooleanList=If[
									And[tripleQuadQ,MatchQ[resolvedAcquisitionMode,MultipleReactionMonitoring]],
									Map[
										If[
											MatchQ[#,Null],
											False,
											!((Length[ToList[#]])===numberOfMassInputs)
										]&,
										relaventOptionNotListedOptions
									],
									ConstantArray[False,Length[relaventOptionNotListedOptions]]
								
								];
								
								(*Out put which option does not have same length as the mass detection input*)
								ContainsAny[finalBooleanList, {True}]
							];
							
							(* Resolve CollisionCellExitVoltage for TripleQuad *)
							resolvedCollisionCellExitVoltage=Which[
								(* if user specified a value, use what user specified *)
								MatchQ[collisionCellExitVoltage,Except[Automatic]],collisionCellExitVoltage,
								
								(* if the MassAcquisition Method specified a value, usue that value*)
								MatchQ[Lookup[methodPacket,CollisionCellExitVoltages],Except[Automatic|Null|_Missing]],Lookup[methodPacket,CollisionCellExitVoltages],

								(* check if the acquisitionMode required fragement and the  QTOF, resolve it to Null *)
								(tripleQuadQ&&qqqTandemMassQ), If[positiveIonModeQ,15*Volt,-15*Volt],
								
								(* In all other cases resolve it to Null *)
								True, Null
							
							];
							
							(* For ESI-QQQ: Check CollisionEnergy and CollisionCellExitVotage matches ionmode *)
							invalidCollisionVoltagesQ=If[
								tripleQuadQ,
								Module[{invalidVoltages},
									invalidVoltages=Cases[
										{resolvedCollisionEnergy,	resolvedCollisionCellExitVoltage},
										If[positiveIonModeQ,Except[ListableP[GreaterEqualP[0*Volt]|Null]],Except[ListableP[LessEqualP[0*Volt]|Null]]]
									];
									(* Return a checker to see if there are invalid voltages*)
									(Length[invalidVoltages]>0)
								],
								!And[
									MatchQ[resolvedCollisionEnergy,ListableP[GreaterEqualP[0*Volt]|Null]],
									NullQ[resolvedCollisionCellExitVoltage]
								]
							];
							
							(* Resolve NeutralLoss for QQQ MassAnalyzer *)
							autoNeutralLossValueWarningQ=False;
							
							resolvedNeutralLoss=Which[
								
								(* use user specified value *)
								MatchQ[neutralLoss,Except[Automatic]],neutralLoss,
								
								(* get the value from MassAcquisition Method, if specified *)
								MatchQ[Lookup[methodPacket,NeutralLosses],Except[Automatic|Null]],Lookup[methodPacket,NeutralLosses],

								
								(* if the acquisition mode is Neutral loss, auto resolved a value and throw a warning*)
								MatchQ[resolvedAcquisitionMode,NeutralIonLoss], autoNeutralLossValueWarningQ=True;50*Gram/Mole,
								
								(* in all other cases set it to Null *)
								True, Null
							
							];
							
							(* Resolve the MRM assay *)
							resolvedMultipleReactionMonitoringAssay=ToList[Which[

								(* use user specified value *)
								MatchQ[formattedMultipleReactionMonitoringAssays,Except[Automatic]],formattedMultipleReactionMonitoringAssays,
								(* If not in QQQ resolve to Null *)
(*								!tripleQuadQ,{Null,Null,Null,Null},*)
								!tripleQuadQ,Null,

								(* get the value from MassAcquisition Method, if specified *)
								MatchQ[Lookup[methodPacket,MultipleReactionMonitoringAssays],Except[Automatic|Null]],Lookup[methodPacket,MultipleReactionMonitoringAssays],

								(* if the acquisition mode is Neutral loss, auto resolved a value and throw a warning*)
								MatchQ[resolvedAcquisitionMode,MultipleReactionMonitoring], Transpose[PadRight[{ToList[resolvedMassDetection],ToList[resolvedCollisionEnergy],ToList[resolvedFragmentMassDetection],ToList[resolvedDwellTime]},{4,Length[ToList[resolvedMassDetection]]},Null]],
								
								(* in all other cases set it to Null *)
								True, Null (*{Null,Null,Null,Null}*)
							
							]];
							
							(* CollisionEnergy AcquisitionMode MisMatches *)
							collisionEnergyAcqModeInvalidQ=If[MatchQ[resolvedAcquisitionMode,Except[MultipleReactionMonitoring]],And[Length[ToList[resolvedCollisionEnergy]]>1,!NullQ[resolvedCollisionEnergy]],False];
			
							resolvedCollisionEnergyMassProfile = Which[
								MatchQ[collisionEnergyMassProfile, Except[Automatic]], collisionEnergyMassProfile,
								Or[tripleQuadQ,MatchQ[resolvedAcquisitionMode, MS1FullScan]], Null,
								(*cannot have both the energy and the mass profile unless in DataIndependent mode*)
								MatchQ[resolvedCollisionEnergy,Except[Null]]&&MatchQ[resolvedAcquisitionMode,Except[DataIndependent]],Null,
								And[
									MatchQ[Lookup[methodPacket, LowCollisionEnergies], Except[Automatic | Null]],
									MatchQ[Lookup[methodPacket, HighCollisionEnergies], Except[Automatic | Null]]
								],
								Span[Lookup[methodPacket, LowCollisionEnergies], Lookup[methodPacket, HighCollisionEnergies]],
								(* if acquisition mode is DataIndependent but mass profile was not specified, use resolvedCollisionEnergy as the left side and max voltage as the right side *)
								MatchQ[resolvedAcquisitionMode,DataIndependent],Span[First[ToList[resolvedCollisionEnergy]], 255 Volt],
								True,Null
							];

							(*the collision energy options must be compatible withh the acquisition mode*)
							collisionEnergyConflictQ=Switch[{resolvedCollisionEnergy,resolvedCollisionEnergyMassProfile,resolvedAcquisitionMode},
								(* they can't be all Null, when a fragmenting mode*)
								{Null,Null,(DataDependent| DataIndependent| MS1MS2ProductIonScan)},True,
								(*conversely, either cannot be set when MS1FullScan*)
								{Except[Null],_,MS1FullScan},True,
								{_,Except[Null],MS1FullScan},True,
								_,False
							];

							(*we also check if CollisionEnergy and CollisionEnergyMassProfile are defined correctly*)
							collisionEnergyProfileConflictQ=Which[
								(* in DataIndependent mode , we use CollisionEnergy for scan 1 and CollisionEnergyMassProfile for scan 2*)
								(* the left side of CollisionEnergyMassProfile--LowCollisionEnergy must be larger than CollisionEnergy *)
								(* the right side of CollisionEnergyMassProfile--HighCollisionEnergy must be larger than the left side--LowCollisionEnergy*)
								MatchQ[resolvedAcquisitionMode, DataIndependent],
								!And[
									(* the resolvedCollisionEnergy for DataIndependent could be {energy} or energy*)
									GreaterEqualQ[resolvedCollisionEnergyMassProfile[[1]], First[ToList[resolvedCollisionEnergy]]],
									GreaterEqualQ[resolvedCollisionEnergyMassProfile[[2]], resolvedCollisionEnergyMassProfile[[1]]]
								],
								(* in other mode, we only use one of them *)
								True,
								MatchQ[resolvedCollisionEnergy,Except[Null]]&&MatchQ[resolvedCollisionEnergyMassProfile,Except[Null]]
							];

							resolvedCollisionEnergyMassScan = Which[
								MatchQ[collisionEnergyMassScan, Except[Automatic]], collisionEnergyMassScan,
								MatchQ[resolvedAcquisitionMode, MS1FullScan], Null,
								And[
									MatchQ[Lookup[methodPacket, FinalLowCollisionEnergies], Except[Automatic | Null]],
									MatchQ[Lookup[methodPacket, FinalHighCollisionEnergies], Except[Automatic | Null]]
								],
								Span[Lookup[methodPacket, FinalLowCollisionEnergies], Lookup[methodPacket, FinalHighCollisionEnergies]],
								(*this is a wine and cheese option, so we default to Null*)
								True, Null
							];

							(*this is only available for DDA*)
							collisionEnergyScanConflictQ=If[MatchQ[resolvedCollisionEnergyMassScan,Except[Null]],
								MatchQ[resolvedAcquisitionMode,Except[DataDependent]],
								False
							];

							(*from here on out the options are only applicable if we're doing DataDependent acquisition mode*)

							(*define a check that we'll use a lot*)
							ddaQ = MatchQ[resolvedAcquisitionMode, DataDependent];

							resolvedFragmentScanTime = Which[
								MatchQ[fragmentScanTime, Except[Automatic]], fragmentScanTime,
								!ddaQ, Null,
								MatchQ[Lookup[methodPacket, FragmentScanTimes], Except[Automatic | Null]], Lookup[methodPacket, FragmentScanTimes],
								True, resolvedScanTime
							];

							resolvedAcquisitionSurvey = Which[
								MatchQ[acquisitionSurvey, Except[Automatic]], acquisitionSurvey,
								!ddaQ, Null,
								(*if the user specifies a cycle time limit, we calculate what they want from that*)
								MatchQ[cycleTimeLimit, Except[Automatic | Null]],
									Max[Floor[(cycleTimeLimit-resolvedScanTime)/resolvedFragmentScanTime],1],
								MatchQ[Lookup[methodPacket, AcquisitionSurveys], Except[Automatic | Null]], Lookup[methodPacket, AcquisitionSurveys],
								True, 10
							];

							(*these MUST be defined iff DDA*)
							{
								fragmentScanTimeConflictQ,
								acquisitionSurveyConflictQ
							} = Map[
								If[ddaQ, NullQ[#], !NullQ[#]]&,
								{
									resolvedFragmentScanTime,
									resolvedAcquisitionSurvey
								}
							];

							(*the following options are optional, even if DDA mode is set*)
							resolvedMinimumThreshold = Which[
								MatchQ[minimumThreshold, Except[Automatic]], minimumThreshold,
								!ddaQ, Null,
								MatchQ[Lookup[methodPacket, MinimumThresholds], Except[Automatic | Null]], Lookup[methodPacket, MinimumThresholds],
								True, Null
							];

							resolvedAcquisitionLimit = Which[
								MatchQ[acquisitionLimit, Except[Automatic]], acquisitionLimit,
								!ddaQ, Null,
								MatchQ[Lookup[methodPacket, AcquisitionLimits], Except[Automatic | Null]], Lookup[methodPacket, AcquisitionLimits],
								True, Null
							];

							(*can be Null under DDA, but can't be set if not DDA*)
							acquisitionLimitConflictQ = If[!ddaQ,
								!NullQ[resolvedAcquisitionLimit],
								False
							];

							resolvedCycleTimeLimit = Which[
								MatchQ[cycleTimeLimit, Except[Automatic]], cycleTimeLimit,
								MatchQ[resolvedAcquisitionMode, Except[DataDependent]], Null,
								(*otherwise, just calculate this from the other options*)
								True, (resolvedAcquisitionSurvey * resolvedFragmentScanTime + resolvedScanTime)
							];

							(*check whether the time limit is less than the anticipated time*)
							cycleTimeLimitConflictQ = If[MatchQ[
									{resolvedCycleTimeLimit, resolvedAcquisitionSurvey, resolvedFragmentScanTime, resolvedScanTime},
									{Units[Minute], _Integer, Units[Minute], Units[Minute]}
								],
								(resolvedAcquisitionSurvey * resolvedFragmentScanTime + resolvedScanTime) > resolvedCycleTimeLimit,
								If[!NullQ[resolvedCycleTimeLimit], !ddaQ, False]
							];

							(*get a list of all of the measured masses*)
							(*we do this unitless; otherwise, it'll be incredibly slow*)
							massesToMeasure=Switch[resolvedMassDetection,
								_Span,Range[Sequence@@(Unitless[resolvedMassDetection,Gram/Mole])],
								MSAnalyteGroupP,Range[Sequence@@(Unitless[massRangeAnalyteType[resolvedMassDetection],Gram/Mole])],
								UnitsP[Gram/Mole],List[Unitless[resolvedMassDetection,Gram/Mole]],
								_,Unitless[resolvedMassDetection,Gram/Mole]
							];

							(*get the masses that we probably won't care about*)
							potentiallyUninterestingMasses=Complement[
								ToList[massesToMeasure],
								Unitless[sampleMolecularWeights,Gram/Mole]
							];

							{resolvedExclusionDomain, resolvedExclusionMass} = Which[
								(*if all nulls, return nulls*)
								MatchQ[{exclusionDomain,exclusionMass},{Null,Null}|{{Null},{Null}}],{Null,Null},
								(*if both are automatic and we're not in datadependent mode, then we just set Null *)
								MatchQ[{exclusionDomain,exclusionMass},{Automatic,Automatic}|{{Automatic},{Automatic}}]&&MatchQ[resolvedAcquisitionMode,Except[DataDependent]],{Null,Null},
								(*otherwise, we can draw from the supplied method, if one exists*)
								MatchQ[{exclusionDomain,exclusionMass},{Automatic,Automatic}|{{Automatic},{Automatic}}]&&And[
									MatchQ[Lookup[methodPacket,ExclusionDomains],Except[Automatic|Null|{}]],
									MatchQ[Lookup[methodPacket,ExclusionMasses],Except[Automatic|Null|{}]]
								],{
									Lookup[methodPacket,ExclusionDomains],
									Lookup[methodPacket,ExclusionMasses]
								},

								MatchQ[
									{exclusionDomain,exclusionMass,exclusionMassTolerance,exclusionRetentionTimeTolerance},
									ConstantArray[Automatic|{Automatic},4]
								],{Null,Null},

								(*otherwise, we map through and resolve any automatics -- we're assuming that this is index-expanded at this point*)
								(*first we do any needed expansion*)
								True,(
									{innerExpandedExclusionDomain,innerExpandedExclusionMass}=Switch[{exclusionDomain,exclusionMass},
										(*if the exclusion domain is automatics, then match to to the exclusion mass*)
										{Automatic,Except[Automatic]},{ConstantArray[Automatic,Length[exclusionMass]],exclusionMass},
										(*otherwise, check vice versa*)
										{Except[Automatic],Automatic},{exclusionDomain,ConstantArray[Automatic,Length[exclusionDomain]]},
										(*otherwise, just make sure wrapped in a list*)
										_,ToList/@{exclusionDomain,exclusionMass}
									];
									Transpose@MapThread[Function[{currentExclusionDomain,currentExclusionMass,currentIndex},
										{
											(*if the domain is automatic, then just set to the entire domain*)
											If[MatchQ[currentExclusionDomain,Automatic],acquisitionWindow,currentExclusionDomain],
											(*if the mass is automatic, then just choose one we don't have*)
											If[MatchQ[currentExclusionMass,Automatic],
												{
													Once,
													If[currentIndex<Length[potentiallyUninterestingMasses],
														potentiallyUninterestingMasses[[currentIndex]]*Gram/Mole,
														(*otherwise, no idea what to do really*)
														First[massesToMeasure]*Gram/Mole
													]
												},
												currentExclusionMass
											]
										}
									],
										{
											innerExpandedExclusionDomain,
											innerExpandedExclusionMass,
											Range[Length@innerExpandedExclusionMass]
										}
									])
							];

							(*exclusion mode should only be on for data dependent and should not be null when the other is not*)
							exclusionModeMassConflictQ = Switch[{resolvedExclusionDomain, resolvedExclusionMass, resolvedAcquisitionMode},
								(*error no matter what if we have mismatching Null and specified*)
								{Null|{Null},Except[Null|{Null}],_},True,
								{Except[Null|{Null}],Null|{Null},_},True,
								(*error if we have not Null and acquisition mode is not DataDependent*)
								{Except[Null|{Null}],_,Except[DataDependent]},True,
								(*any other case is okay*)
								_,False
							];

							(*all of the exclusion modes have to be the same within (e.g. all Once*)
							exclusionModesVariedQ=If[MatchQ[resolvedExclusionMass,ListableP[Null]],
								False,
								Count[DeleteDuplicates[resolvedExclusionMass[[All,1]]], _] > 1
							];

							(*resolve the tolerance related options*)
							resolvedExclusionMassTolerance = Which[
								MatchQ[exclusionMassTolerance, Except[Automatic]], exclusionMassTolerance,
								MatchQ[resolvedAcquisitionMode, Except[DataDependent]], Null,
								NullQ[resolvedExclusionDomain], Null,
								MatchQ[Lookup[methodPacket, ExclusionMassTolerances], Except[{} | Automatic | Null]], Lookup[methodPacket, ExclusionMassTolerances],
								True, 0.5 Gram / Mole
							];

							(*must be congruent with the other exclusion domain options*)
							exclusionMassToleranceConflictQ = Switch[{exclusionModeMassConflictQ, resolvedExclusionDomain, resolvedExclusionMass, resolvedExclusionMassTolerance},
								{True,___},False,
								{_,Null|{Null},Null|{Null},Except[Null|{Null}]},True,
								{_,Except[Null|{Null}],Except[Null|{Null}],Null|{Null}},True,
								(*any other case is okay*)
								_,False
							];

							(*resolve the tolerance related options*)
							resolvedExclusionRetentionTimeTolerance = Which[
								exclusionModeMassConflictQ, False,
								MatchQ[exclusionRetentionTimeTolerance, Except[Automatic]], exclusionRetentionTimeTolerance,
								MatchQ[resolvedAcquisitionMode, Except[DataDependent]], Null,
								NullQ[resolvedExclusionDomain], Null,
								MatchQ[Lookup[methodPacket, ExclusionRetentionTimeTolerances], Except[{} | Automatic | Null]], Lookup[methodPacket, ExclusionRetentionTimeTolerances],
								True, 10 Second
							];

							(*must be congruent with the other exclusion domain options*)
							exclusionRetentionTimeToleranceConflictQ = Switch[{resolvedExclusionDomain, resolvedExclusionMass, resolvedExclusionRetentionTimeTolerance},
								{Null|{Null},Null|{Null},Except[Null|{Null}]},True,
								{Except[Null|{Null}],Except[Null|{Null}],Null|{Null}},True,
								(*any other case is okay*)
								_,False
							];

							(*to make things easier, figure out if these are all automatics*)
							inclusionOptionsAllAutomaticQ = MatchQ[
								{inclusionDomain, inclusionMass, inclusionCollisionEnergy, inclusionDeclusteringVoltage, inclusionChargeState, inclusionScanTime },
								ConstantArray[Automatic|{Automatic}, 6]
							];
							inclusionOptionsAllNullQ=MatchQ[
								{inclusionDomain, inclusionMass, inclusionCollisionEnergy, inclusionDeclusteringVoltage, inclusionChargeState, inclusionScanTime },
								ConstantArray[Null|{Null},6]
							];

							{
								resolvedInclusionDomain,
								resolvedInclusionMass,
								resolvedInclusionCollisionEnergy,
								resolvedInclusionDeclusteringVoltage,
								resolvedInclusionChargeState,
								resolvedInclusionScanTime
							} = Which[
								(*if all Null, easypeasy*)
								inclusionOptionsAllNullQ,ConstantArray[Null,6],
								(*check if everything is automatic*)
								(*if not data dependent, we set to Nulls*)
								inclusionOptionsAllAutomaticQ&&!ddaQ,
								ConstantArray[Null,6],
								(*otherwise, we can draw from the supplied method, if one exists*)
								inclusionOptionsAllAutomaticQ&&And[
									MatchQ[Lookup[methodPacket,InclusionDomains],Except[Automatic|Null|{}]],
									MatchQ[Lookup[methodPacket,InclusionMasses],Except[Automatic|Null|{}]],
									MatchQ[Lookup[methodPacket,InclusionCollisionEnergies],Except[Automatic|Null|{}]],
									MatchQ[Lookup[methodPacket,InclusionDeclusteringVoltages],Except[Automatic|Null|{}]],
									MatchQ[Lookup[methodPacket,InclusionChargeStates],Except[Automatic|Null|{}]],
									MatchQ[Lookup[methodPacket,InclusionScanTimes],Except[Automatic|Null|{}]]
								],{
									Map[
										Apply[Span, #]&,
										Lookup[methodPacket,InclusionDomains]
									],
									Lookup[methodPacket,InclusionMasses],
									Lookup[methodPacket,InclusionCollisionEnergies],
									Lookup[methodPacket,InclusionDeclusteringVoltages],
									Lookup[methodPacket,InclusionChargeStates],
									Lookup[methodPacket,InclusionScanTimes]
								},
								inclusionOptionsAllAutomaticQ&&MatchQ[inclusionMassTolerance,Automatic|Null],ConstantArray[Null,6],
								(*otherwise, we map through and go for gold -- everything should already be index matching at this point but we might need to expan*)
								True,(
									(*find the option that's expanded*)
									inclusionLength=Length@FirstCase[{inclusionDomain, inclusionMass, inclusionCollisionEnergy, inclusionDeclusteringVoltage, inclusionChargeState, inclusionScanTime},_List,{Automatic}];
									(*we do a further expansion here*)
									{
										currentExpandedInclusionDomain,
										currentExpandedInclusionMass,
										currentExpandedInclusionCollisionEnergy,
										currentExpandedInclusionDeclusteringVoltage,
										currentExpandedInclusionChargeState,
										currentExpandedInclusionScanTime
									}=Map[
										If[MatchQ[#,Automatic|Null],
											ConstantArray[#,inclusionLength],
											ToList[#]
										]&,{
											inclusionDomain,
											inclusionMass,
											inclusionCollisionEnergy,
											inclusionDeclusteringVoltage,
											inclusionChargeState,
											inclusionScanTime
										}
									];
									Transpose@MapThread[
										Function[{
											currentInclusionDomain,
											currentInclusionMass,
											currentInclusionCollisionEnergy,
											currentInclusionDeclusteringVoltage,
											currentInclusionChargeState,
											currentInclusionScanTime,
											currentIndex
										},
											{
												If[MatchQ[currentInclusionDomain,Automatic],acquisitionWindow,currentInclusionDomain],
												(*if the mass is automatic, then just choose among the analytes*)
												If[MatchQ[currentInclusionMass,Automatic],
													{
														Preferential,
														If[currentIndex<Length[Flatten@sampleMolecularWeights],
															(Flatten@sampleMolecularWeights)[[currentIndex]],
															(*otherwise, no idea what to do really*)
															First[massesToMeasure]*Gram/Mole
														]
													},
													currentInclusionMass
												],
												If[MatchQ[currentInclusionCollisionEnergy,Automatic],
													If[!NullQ[resolvedCollisionEnergy], FirstOrDefault[resolvedCollisionEnergy,resolvedCollisionEnergy], 40 Volt],
													currentInclusionCollisionEnergy
												],
												If[MatchQ[currentInclusionDeclusteringVoltage,Automatic],
													resolvedDeclusteringVoltage,
													currentInclusionDeclusteringVoltage
												],
												If[MatchQ[currentInclusionChargeState,Automatic],
													1,
													currentInclusionChargeState
												],
												If[MatchQ[currentInclusionScanTime,Automatic],
													resolvedFragmentScanTime,
													currentInclusionScanTime
												]
											}
										],
										{
											currentExpandedInclusionDomain,
											currentExpandedInclusionMass,
											currentExpandedInclusionCollisionEnergy,
											currentExpandedInclusionDeclusteringVoltage,
											currentExpandedInclusionChargeState,
											currentExpandedInclusionScanTime,
											Range[inclusionLength]
										}
									]
								)
							];

							combinedInclusionOptions = {
								resolvedInclusionDomain,
								resolvedInclusionMass,
								resolvedInclusionCollisionEnergy,
								resolvedInclusionDeclusteringVoltage,
								resolvedInclusionChargeState,
								resolvedInclusionScanTime
							};

							inclusionOptionsConflictQ = Which[
								(*can't have mix of Nulls and defined *)
								MemberQ[combinedInclusionOptions, Null] && MemberQ[combinedInclusionOptions, Except[Null]], True,
								(*otherwise, can't have anything we're not DDA*)
								MemberQ[combinedInclusionOptions, Except[Null]] && MatchQ[resolvedAcquisitionMode, Except[DataDependent]], True,
								True, False
							];

							(*resolve the tolerance related options*)
							resolvedInclusionMassTolerance = Which[
								MatchQ[inclusionMassTolerance, Except[Automatic]], inclusionMassTolerance,
								MatchQ[resolvedAcquisitionMode, Except[DataDependent]], Null,
								NullQ[resolvedInclusionDomain], Null,
								MatchQ[Lookup[methodPacket, InclusionMassTolerances], Except[{} | Automatic | Null]], Lookup[methodPacket, InclusionMassTolerances],
								True, 0.5 Gram / Mole
							];

							(*must be congruent with the other inclusion domain options*)
							inclusionMassToleranceConflictQ = Which[
								inclusionOptionsConflictQ, False,
								(*tolerance should not be specified, if none of the inclusion options are specified*)
								MatchQ[resolvedInclusionMassTolerance, Except[Null]] && !MemberQ[combinedInclusionOptions, Except[Null]], True,
								(*like wise, it should be Null if the other options are set*)
								NullQ[resolvedInclusionMassTolerance] && !MemberQ[combinedInclusionOptions, Null], True,
								(*any other case is okay*)
								True, False
							];

							(*define all of the charge state options*)
							chargeStateExclusionOptions = {
								chargeStateExclusionLimit,
								chargeStateExclusion,
								chargeStateMassTolerance
							};

							isotopeExclusionOptions = {
								isotopicExclusion,
								isotopeRatioThreshold,
								isotopeDetectionMinimum,
								isotopeMassTolerance,
								isotopeRatioTolerance
							};

							(**)
							resolvedSurveyChargeStateExclusion = Which[
								MatchQ[surveyChargeStateExclusion, Except[Automatic]], surveyChargeStateExclusion,
								!ddaQ, Null,
								(*check to see if we have any of the relevant options set*)
								MemberQ[chargeStateExclusionOptions, Except[Automatic | Null]], True,
								(*otherwise, if all automatic, check the method packet*)
								MemberQ[Lookup[methodPacket, {ChargeStateLimits, ChargeStateSelections, ChargeStateMassTolerances}], Except[Automatic | Null | {}]], True,
								True, False
							];

							resolvedSurveyIsotopeExclusion = Which[
								MatchQ[surveyIsotopeExclusion, Except[Automatic]], surveyIsotopeExclusion,
								!ddaQ, Null,
								(*check to see if we have any of the relevant options set*)
								MemberQ[isotopeExclusionOptions, Except[ListableP[Automatic | Null]]], True,
								(*otherwise, if all automatic, check the method packet*)
								MemberQ[Lookup[methodPacket, {IsotopeMassDifferences, IsotopeRatios, IsotopeDetectionMinimums, IsotopeRatioTolerances, IsotopeMassTolerances}], Except[Automatic | Null | {}]], True,
								True, False
							];

							(*make the Q versions*)
							surveyChargeStateExclusionQ = MatchQ[resolvedSurveyChargeStateExclusion, True];
							surveyIsotopeExclusionQ = MatchQ[resolvedSurveyIsotopeExclusion, True];

							resolvedChargeStateExclusionLimit = Which[
								MatchQ[chargeStateExclusionLimit, Except[Automatic]], chargeStateExclusionLimit,
								!ddaQ, Null,
								!surveyChargeStateExclusionQ, Null,
								surveyChargeStateExclusionQ && MatchQ[Lookup[methodPacket, ChargeStateLimits], Except[Null | Automatic | {}]],
								Lookup[methodPacket, ChargeStateLimits],
								(*if the survey is more than 5, stop at five*)
								MatchQ[resolvedAcquisitionSurvey, GreaterEqualP[5]], 5,
								True, resolvedAcquisitionSurvey
							];

							resolvedChargeStateExclusion = Which[
								MatchQ[chargeStateExclusion, Except[Automatic]], chargeStateExclusion,
								!ddaQ, Null,
								!surveyChargeStateExclusionQ, Null,
								surveyChargeStateExclusionQ && MatchQ[Lookup[methodPacket, ChargeStateSelections], Except[Null | Automatic | {}]],
								Lookup[methodPacket, ChargeStateSelections],
								(*just default here*)
								True, {1, 2}
							];

							(*the only problem is when these are set and it's not DDA*)
							{
								chargeStateExclusionConflictQ
							} = Map[
								If[!ddaQ, !NullQ[#], False]&,
								{
									resolvedChargeStateExclusion
								}
							];

							(*can have the limit conflict, if the number if not DDA or higher than the survey*)
							chargeStateExclusionLimitConflictQ=Which[
								!NullQ[resolvedChargeStateExclusionLimit]&&!ddaQ,True,
								MatchQ[resolvedChargeStateExclusionLimit,GreaterP[resolvedAcquisitionSurvey]],True,
								True,False
							];

							resolvedChargeStateMassTolerance = Which[
								MatchQ[chargeStateMassTolerance, Except[Automatic]], chargeStateMassTolerance,
								!ddaQ, Null,
								!surveyChargeStateExclusionQ, Null,
								surveyChargeStateExclusionQ && MatchQ[Lookup[methodPacket, ChargeStateMassTolerances], Except[Null | Automatic | {}]],
								Lookup[methodPacket, ChargeStateMassTolerances],
								(*just default here*)
								True, 0.5 Gram / Mole
							];

							chargeStateMassToleranceConflictQ = Which[
								chargeStateExclusionConflictQ, False,
								(*tolerance should not be specified, if none of the inclusion options are specified*)
								MatchQ[resolvedChargeStateMassTolerance, Except[Null]] && MemberQ[{resolvedChargeStateExclusionLimit, resolvedChargeStateExclusion}, Null|{Null..}], True,
								(*like wise, it should be Null if the other options are set*)
								NullQ[resolvedChargeStateMassTolerance] && MemberQ[{resolvedChargeStateExclusionLimit, resolvedChargeStateExclusion}, Except[Null|{Null..}]], True,
								(*any other case is okay*)
								True, False
							];

							{
								resolvedIsotopicExclusion,
								resolvedIsotopeRatioThreshold,
								resolvedIsotopeDetectionMinimum
							} = Which[
								(*check if they are all automatic and whether to *)
								MatchQ[{isotopicExclusion,isotopeRatioThreshold,isotopeDetectionMinimum},ConstantArray[Automatic|{Automatic},3]]&&!ddaQ,
									ConstantArray[Null,3],
								!surveyIsotopeExclusionQ&&MatchQ[{isotopicExclusion,isotopeRatioThreshold,isotopeDetectionMinimum},ConstantArray[Automatic|Null|{(Automatic|Null)..},3]],
									ConstantArray[Null,3],
								(*check if we can pull from the method file*)
								MatchQ[{isotopicExclusion,isotopeRatioThreshold,isotopeDetectionMinimum},ConstantArray[Automatic,3]]&&And[
									MatchQ[Lookup[methodPacket,IsotopeMassDifferences],Except[Automatic|Null|{}]],
									MatchQ[Lookup[methodPacket,IsotopeRatios],Except[Automatic|Null|{}]],
									MatchQ[Lookup[methodPacket,IsotopeDetectionMinimums],Except[Automatic|Null|{}]]
								],{
									Lookup[methodPacket,IsotopeMassDifferences],
									Lookup[methodPacket,IsotopeRatios],
									Lookup[methodPacket,IsotopeDetectionMinimums]
								},
								(*otherwise, we map through*)
								True,(
									(*we need to get the length to expand by*)
									isotopeExclusionLength=Length@FirstCase[{isotopicExclusion,isotopeRatioThreshold,isotopeDetectionMinimum},_List,{Automatic}];
									(*expand all of these variables*)
									{
										currentExpandedIsotopicExclusion,
										currentExpandedIsotopeRatioThreshold,
										currentExpandedIsotopeDetectionMinimum
									}=Map[
										If[MatchQ[#,Automatic|Null],ConstantArray[#,isotopeExclusionLength],ToList[#]]&,
										{
											isotopicExclusion,
											isotopeRatioThreshold,
											isotopeDetectionMinimum
										}
									];
									Transpose@MapThread[
										Function[{currentIsotopicExclusion, currentIsotopeRatioThreshold, currentIsotopeDetectionMinimum, currentIndex},
											{
												If[MatchQ[currentIsotopicExclusion,Automatic],
													currentIndex*1*Gram/Mole,
													currentIsotopicExclusion
												],
												If[MatchQ[currentIsotopeRatioThreshold,Automatic],
													0.1,
													currentIsotopeRatioThreshold
												],
												If[MatchQ[currentIsotopeDetectionMinimum,Automatic],
													10*1/Second,
													currentIsotopeDetectionMinimum
												]
											}
										],
										{
											currentExpandedIsotopicExclusion,
											currentExpandedIsotopeRatioThreshold,
											currentExpandedIsotopeDetectionMinimum,
											Range[isotopeExclusionLength]
										}
									]
								)
							];

							(*we can't do more than 2 isotopic exclusions*)
							isotopicExclusionLimitQ = If[!NullQ[resolvedIsotopicExclusion],
								Length[resolvedIsotopicExclusion] > 2,
								False
							];

							(*check for conflicts*)
							isotopicExclusionConflictQ = Which[
								(*mix of Nulls and sets is bad*)
								And[
									MemberQ[{resolvedIsotopicExclusion, resolvedIsotopeRatioThreshold, resolvedIsotopeDetectionMinimum}, Null],
									MemberQ[{resolvedIsotopicExclusion, resolvedIsotopeRatioThreshold, resolvedIsotopeDetectionMinimum}, Except[Null]]
								], True,
								(*nothing should be set if not dda*)
								!ddaQ && MemberQ[{resolvedIsotopicExclusion, resolvedIsotopeRatioThreshold, resolvedIsotopeDetectionMinimum}, Except[Null]], True,
								(*otherwise false*)
								True, False
							];

							(*this is shared by the charge state and the isotope options*)
							resolvedIsotopeMassTolerance = Which[
								MatchQ[isotopeMassTolerance, Except[Automatic]], isotopeMassTolerance,
								!ddaQ, Null,
								!resolvedSurveyChargeStateExclusion && !resolvedSurveyIsotopeExclusion, Null,
								Or[resolvedSurveyChargeStateExclusion, resolvedSurveyIsotopeExclusion] && MatchQ[Lookup[methodPacket, IsotopeMassTolerances], Except[Null | Automatic | {}]],
								Lookup[methodPacket, IsotopeMassTolerances],
								(*just default here*)
								True, 0.5 Gram / Mole
							];

							(*must be congruent with the other options*)
							isotopeMassToleranceConflictQ = Which[
								(*we don't want to throw this error if the charge state one is set*)
								isotopicExclusionConflictQ||chargeStateMassToleranceConflictQ||chargeStateExclusionLimitConflictQ||chargeStateExclusionConflictQ||isotopicExclusionLimitQ, False,
								(*tolerance should not be specified, if none of the inclusion options are specified*)
								MatchQ[resolvedIsotopeMassTolerance, Except[Null]] && MatchQ[{resolvedChargeStateExclusion, resolvedIsotopicExclusion, resolvedIsotopeRatioThreshold, resolvedIsotopeDetectionMinimum}, {(Null|{Null})..}], True,
								(*like wise, it should not be Null if the other options are set*)
								NullQ[resolvedIsotopeMassTolerance] && MemberQ[{resolvedChargeStateExclusion, resolvedIsotopicExclusion, resolvedIsotopeRatioThreshold, resolvedIsotopeDetectionMinimum}, Except[Null|{Null}]], True,
								(*any other case is okay*)
								True, False
							];

							resolvedIsotopeRatioTolerance = Which[
								MatchQ[isotopeRatioTolerance, Except[Automatic]], isotopeRatioTolerance,
								!ddaQ, Null,
								!resolvedSurveyIsotopeExclusion, Null,
								resolvedSurveyIsotopeExclusion && MatchQ[Lookup[methodPacket, IsotopeRatioTolerances], Except[Null | Automatic | {}]],
								Lookup[methodPacket, IsotopeRatioTolerances],
								(*just default here*)
								True, 30 Percent
							];

							isotopeRatioToleranceConflictQ = Which[
								isotopicExclusionConflictQ, False,
								(*tolerance should not be specified, if none of the inclusion options are specified*)
								MatchQ[resolvedIsotopeRatioTolerance, Except[Null]] && !MemberQ[{resolvedIsotopicExclusion, resolvedIsotopeRatioThreshold, resolvedIsotopeDetectionMinimum}, Except[Null]], True,
								(*like wise, it should not be Null if the other options are set*)
								NullQ[resolvedIsotopeRatioTolerance] && !MemberQ[{resolvedIsotopicExclusion, resolvedIsotopeRatioThreshold, resolvedIsotopeDetectionMinimum}, Null], True,
								(*any other case is okay*)
								True, False
							];

							(*return everything from the depth 3 mapping*)
							{
								(*11*)resolvedAcquisitionMode,
								(*12*)resolvedFragment,
								(*13*)resolvedMassDetection,
								(*14*)resolvedScanTime,
								(*15*)resolvedFragmentMassDetection,
								(*16*)resolvedCollisionEnergy,
								(*17*)resolvedCollisionEnergyMassProfile,
								(*18*)resolvedCollisionEnergyMassScan,
								(*19*)resolvedFragmentScanTime,
								(*20*)resolvedAcquisitionSurvey,
								(*21*)resolvedMinimumThreshold,
								(*22*)resolvedAcquisitionLimit,
								(*23*)resolvedCycleTimeLimit,
								(*24*)resolvedExclusionDomain,
								(*25*)resolvedExclusionMass,
								(*26*)resolvedExclusionMassTolerance,
								(*27*)resolvedExclusionRetentionTimeTolerance,
								(*28*)resolvedInclusionDomain,
								(*29*)resolvedInclusionMass,
								(*30*)resolvedInclusionCollisionEnergy,
								(*31*)resolvedInclusionDeclusteringVoltage,
								(*32*)resolvedInclusionChargeState,
								(*33*)resolvedInclusionScanTime,
								(*34*)resolvedInclusionMassTolerance,
								(*35*)resolvedSurveyChargeStateExclusion,
								(*36*)resolvedSurveyIsotopeExclusion,
								(*37*)resolvedChargeStateExclusionLimit,
								(*38*)resolvedChargeStateExclusion,
								(*39*)resolvedChargeStateMassTolerance,
								(*40*)resolvedIsotopicExclusion,
								(*41*)resolvedIsotopeRatioThreshold,
								(*42*)resolvedIsotopeDetectionMinimum,
								(*43*)resolvedIsotopeMassTolerance,
								(*44*)resolvedIsotopeRatioTolerance,
								(*45*)resolvedNeutralLoss,
								(*46*)resolvedDwellTime,
								(*47*)resolvedMassDetectionStepSize,
								(*48*)resolvedCollisionCellExitVoltage,
								(*49*)resolvedMultipleReactionMonitoringAssay,
								(*E1*)fragmentModeConflictQ,
								(*E2*)massDetectionConflictQ,
								(*E3*)fragmentMassDetectionConflictQ,
								(*E4*)collisionEnergyConflictQ,
								(*E5*)collisionEnergyScanConflictQ,
								(*E6*)fragmentScanTimeConflictQ,
								(*E7*)acquisitionSurveyConflictQ,
								(*E8*)acquisitionLimitConflictQ,
								(*E9*)cycleTimeLimitConflictQ,
								(*E10*)exclusionModeMassConflictQ,
								(*E11*)exclusionMassToleranceConflictQ,
								(*E12*)exclusionRetentionTimeToleranceConflictQ,
								(*E13*)inclusionOptionsConflictQ,
								(*E14*)inclusionMassToleranceConflictQ,
								(*E15*)chargeStateExclusionLimitConflictQ,
								(*E16*)chargeStateExclusionConflictQ,
								(*E17*)chargeStateMassToleranceConflictQ,
								(*E18*)isotopicExclusionLimitQ,
								(*E19*)isotopicExclusionConflictQ,
								(*E20*)isotopeMassToleranceConflictQ,
								(*E21*)isotopeRatioToleranceConflictQ,
								(*E22*)collisionEnergyProfileConflictQ,
								(*E23*)exclusionModesVariedQ,
								(*E24*)acqModeMassAnalyzerMismatchedQ,
								(*E25*)invalidCollisionVoltagesQ,
								(*E26*)invalidLengthOfInputOptionQ,
								(*E27*)collisionEnergyAcqModeInvalidQ,
								(*E27.5*)sciExInstrumentError,
								(*W1*)autoNeutralLossValueWarningQ
							}
						)],
						{
							(*1*)resolvedAcquisitionWindowList,
							(*2*)acquisitionModeList,
							(*3*)fragmentList,
							(*4*)massDetectionList,
							(*5*)scanTimeList,
							(*6*)fragmentMassDetectionList,
							(*7*)collisionEnergyList,
							(*8*)collisionEnergyMassProfileList,
							(*9*)collisionEnergyMassScanList,
							(*10*)fragmentScanTimeList,
							(*11*)acquisitionSurveyList,
							(*12*)minimumThresholdList,
							(*13*)acquisitionLimitList,
							(*14*)cycleTimeLimitList,
							(*15*)exclusionDomainList,
							(*16*)exclusionMassList,
							(*17*)exclusionMassToleranceList,
							(*18*)exclusionRetentionTimeToleranceList,
							(*19*)inclusionDomainList,
							(*20*)inclusionMassList,
							(*21*)inclusionCollisionEnergyList,
							(*22*)inclusionDeclusteringVoltageList,
							(*23*)inclusionChargeStateList,
							(*24*)inclusionScanTimeList,
							(*25*)inclusionMassToleranceList,
							(*26*)surveyChargeStateExclusionList,
							(*27*)surveyIsotopeExclusionList,
							(*28*)chargeStateExclusionLimitList,
							(*29*)chargeStateExclusionList,
							(*30*)chargeStateMassToleranceList,
							(*31*)isotopicExclusionList,
							(*32*)isotopeRatioThresholdList,
							(*33*)isotopeDetectionMinimumList,
							(*34*)isotopeMassToleranceList,
							(*35*)isotopeRatioToleranceList,
							(*36*)fieldValuesFromMethodPackets,
							(*37*)neutralLossList,
							(*38*)dwellTimeList,
							(*39*)collisionCellExitVoltageList,
							(*40*)massDetectionStepSizeList,
							(*41*)multipleReactionMonitoringAssaysList
						}
					];

					(*return everything*)
					depth2Result = {
						(*1*)resolvedIonMode,
						(*2*)resolvedMassSpectrometryMethod,
						(*3*)resolvedESICapillaryVoltage,
						(*4*)resolvedDeclusteringVoltage,
						(*5*)resolvedStepwaveVoltage,
						(*6*)resolvedSourceTemperature,
						(*7*)resolvedDesolvationTemperature,
						(*8*)resolvedDesolvationGasFlow,
						(*9*)resolvedConeGasFlow,
						(*9.5*)resolvedIonGuideVoltage,
						(*depth 3/4 options*)
						(*10*)resolvedAcquisitionWindowList,
						(*11-50,E1-E27.5,W1*)Sequence @@ acquisitionOptionsMapResult,
						(*E28*)overlappingAcquisitionWindowsQ,
						(*E29*)acquisitionWindowsTooLongQ,
						(*E30*)invalidSourceTemperatureQ,
						(*E31*)invalidVoltagesQ,
						(*E32*)invalidGasFlowQ,
						(*E33*)invalidScanTimeQ
					};
					
					
					depth2Result
				)
			],
			{
				Sequence @@ passedOptions
			}
		]]],
		{
			{
				standardExistQ,
				{
					standardAnalytePackets,
					standardPackets,
					standardCategories,
					bestStandardsMassSpecMethods,
					Lookup[hplcResolvedOptionsCorrected, StandardFlowRate],
					Lookup[hplcResolvedOptionsCorrected, StandardGradient],
					Lookup[expandedStandardOptions, StandardIonMode],
					Lookup[expandedStandardOptions, StandardMassSpectrometryMethod],
					Lookup[expandedStandardOptions, StandardESICapillaryVoltage],
					Lookup[expandedStandardOptions, StandardDeclusteringVoltage],
					Lookup[expandedStandardOptions, StandardStepwaveVoltage],
					Lookup[expandedStandardOptions, StandardIonGuideVoltage],
					Lookup[expandedStandardOptions, StandardSourceTemperature],
					Lookup[expandedStandardOptions, StandardDesolvationTemperature],
					Lookup[expandedStandardOptions, StandardDesolvationGasFlow],
					Lookup[expandedStandardOptions, StandardConeGasFlow],
					(*our fun times depth 3 and depth 4 options*)
					Sequence @@ expandedStandardAcquisitionModeOptions
				}
			},
			{
				blanksExistQ,
				{
					blankAnalytePackets,
					blankPackets,
					blankCategories,
					bestBlanksMassSpecMethods,
					Lookup[hplcResolvedOptionsCorrected, BlankFlowRate],
					Lookup[hplcResolvedOptionsCorrected, BlankGradient],
					Lookup[expandedBlankOptions, BlankIonMode],
					Lookup[expandedBlankOptions, BlankMassSpectrometryMethod],
					Lookup[expandedBlankOptions, BlankESICapillaryVoltage],
					Lookup[expandedBlankOptions, BlankDeclusteringVoltage],
					Lookup[expandedBlankOptions, BlankStepwaveVoltage],
					Lookup[expandedBlankOptions, BlankIonGuideVoltage],
					Lookup[expandedBlankOptions, BlankSourceTemperature],
					Lookup[expandedBlankOptions, BlankDesolvationTemperature],
					Lookup[expandedBlankOptions, BlankDesolvationGasFlow],
					Lookup[expandedBlankOptions, BlankConeGasFlow],
					(*our fun times depth 3 and depth 4 options*)
					Sequence @@ expandedBlankAcquisitionModeOptions
				}
			},
			{
				columnPrimeQ,
				(*column prime is singleton, so we must wrap in a list*)
				List/@{
					{}, (*no analytes*)
					{}, (*no sample packets*)
					{}, (*no categories*)
					bestColumnPrimeMassSpecMethods,

					Lookup[hplcResolvedOptionsCorrected, ColumnPrimeFlowRate],
					Lookup[hplcResolvedOptionsCorrected, ColumnPrimeGradient],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnPrimeIonMode],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnPrimeMassSpectrometryMethod],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnPrimeESICapillaryVoltage],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnPrimeDeclusteringVoltage],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnPrimeStepwaveVoltage],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnPrimeIonGuideVoltage],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnPrimeSourceTemperature],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnPrimeDesolvationTemperature],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnPrimeDesolvationGasFlow],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnPrimeConeGasFlow],
					(*our fun times depth 3 and depth 4 options*)
					Sequence @@ Lookup[columnFlushPrimeDepth3ExpandedAssociation,columnPrimeAcquisitionWindowMatchedOptions]
				}
			},
			{
				columnFlushQ,
				(*column flush is singleton, so we must wrap in a list*)
				List/@{
					{}, (*no analytes*)
					{}, (*no sample packets*)
					{}, (*no categories*)
					bestColumnFlushMassSpecMethods,
					(*this hplc assumes multiple columns, so have to take the first*)
					Lookup[hplcResolvedOptionsCorrected, ColumnFlushFlowRate],
					Lookup[hplcResolvedOptionsCorrected, ColumnFlushGradient],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnFlushIonMode],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnFlushMassSpectrometryMethod],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnFlushESICapillaryVoltage],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnFlushDeclusteringVoltage],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnFlushStepwaveVoltage],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnFlushIonGuideVoltage],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnFlushSourceTemperature],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnFlushDesolvationTemperature],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnFlushDesolvationGasFlow],
					Lookup[columnFlushPrimeDepth3ExpandedAssociation, ColumnFlushConeGasFlow],
					(*our fun times depth 3 and depth 4 options*)
					Sequence @@ Lookup[columnFlushPrimeDepth3ExpandedAssociation,columnFlushAcquisitionWindowMatchedOptions]
				}
			}
		}
	];
	
	(*grab the pertinent mass spec methods for the samples*)
	resolvedSampleMassSpecMethodsForIT=resolvedMassSpectrometryMethods;
	resolvedStandardMassSpecMethodsForIT= If[Length[standardPositionsAll]>0,
		PadRight[resolvedStandardMassSpectrometryMethods, Length[standardPositionsAll], resolvedStandardMassSpectrometryMethods],
		{}
	];
	resolvedBlankMassSpecMethodsForIT= If[Length[blankPositionsAll]>0,
		PadRight[resolvedBlankMassSpectrometryMethods, Length[blankPositionsAll], resolvedBlankMassSpectrometryMethods],
		{}
	];
	resolvedColumnFlushMassSpecMethodsForIT= If[Length[columnFlushPositionsAll]>0,
		PadRight[ToList@resolvedColumnFlushMassSpectrometryMethods, Length[columnFlushPositionsAll], resolvedColumnFlushMassSpectrometryMethods],
		{}
	];
	resolvedColumnPrimeMassSpecMethodsForIT= If[Length[columnPrimePositionsAll]>0,
		PadRight[ToList@resolvedColumnPrimeMassSpectrometryMethods, Length[columnPrimePositionsAll], resolvedColumnPrimeMassSpectrometryMethods],
		{}
	];

	(*finally do the injection table*)

	(*we delete the ColumnPosition entry from the injection table*)
	injectionTableColumnDeleted=Map[Delete[#,-3]&,hplcInjectionTable];

	(*we put the methods back and convert to New, if need be*)
	(*first we make all of the rules*)
	injectionTableSampleRules=MapThread[Rule[#3,Append[#2,resolvedSampleMassSpecMethodsForIT[[#1]]]]&,
		{Range@Length[samplePositions],injectionTableColumnDeleted[[samplePositions]],samplePositions}
	];
	injectionTableStandardRules=MapThread[Rule[#3,Append[#2,resolvedStandardMassSpecMethodsForIT[[#1]]]]&,
		{Range@Length[standardPositionsAll],injectionTableColumnDeleted[[standardPositionsAll]],standardPositionsAll}
	];
	injectionTableBlankRules=MapThread[Rule[#3,Append[#2,resolvedBlankMassSpecMethodsForIT[[#1]]]]&,
		{Range@Length[blankPositionsAll],injectionTableColumnDeleted[[blankPositionsAll]],blankPositionsAll}
	];
	injectionTableColumnFlushRules=MapThread[Rule[#3,Append[#2,resolvedColumnFlushMassSpecMethodsForIT[[#1]]]]&,
		{Range@Length[columnFlushPositionsAll],injectionTableColumnDeleted[[columnFlushPositionsAll]],columnFlushPositionsAll}
	];
	injectionTableColumnPrimeRules=MapThread[Rule[#3,Append[#2,resolvedColumnPrimeMassSpecMethodsForIT[[#1]]]]&,
		{Range@Length[columnPrimePositionsAll],injectionTableColumnDeleted[[columnPrimePositionsAll]],columnPrimePositionsAll}
	];

	(*then combine everything to our resolved injectionTable*)
	resolvedInjectionTable=Range[Length[injectionTableColumnDeleted]]/.Join[injectionTableSampleRules, injectionTableStandardRules, injectionTableBlankRules, injectionTableColumnFlushRules, injectionTableColumnPrimeRules];

	(* -- Error Checking -- *)

	(*this is a helper function to take a list of bools and convert to a list of bools index matched to samples, standard, blanks, prime and flush for each option*)
	collapseErrorBools[booleanList_List]:=(Or@@#&)/@Map[
		Function[{currentList},
			(*if it's from the inner map thread, we need to collapse the inside*)
			If[Depth[currentList]==3,
				(Or@@#&)/@currentList,
				currentList
			]
		],
		booleanList
	];

	(*forgive the sparse comments, but hopefully everything should be self evident*)

	fragmentModeConflictBool=collapseErrorBools@{fragmentModeConflictSampleBool,fragmentModeConflictStandardBool,fragmentModeConflictBlankBool,fragmentModeConflictColumnPrimeBool,fragmentModeConflictColumnFlushBool};
	fragmentModeOverallConflictQ=Or@@fragmentModeConflictBool;
	fragmentModeConflictOptions=If[fragmentModeOverallConflictQ&&messagesQ,
		Message[Error::FragmentConflict, PickList[{Fragment,StandardFragment,BlankFragment,ColumnPrimeFragment,ColumnFlushFragment},fragmentModeConflictBool]];
		PickList[{Fragment,StandardFragment,BlankFragment,ColumnPrimeFragment,ColumnFlushFragment},fragmentModeConflictBool],
		{}
	];
	fragmentModeConflictTests=If[gatherTestsQ,
		Test["If a Fragment option is specified, it does not conflict with other set options",
			fragmentModeOverallConflictQ,
			False
		],
		Nothing
	];

	massDetectionConflictBool=collapseErrorBools@{massDetectionConflictSampleBool,massDetectionConflictStandardBool,massDetectionConflictBlankBool,massDetectionConflictColumnPrimeBool,massDetectionConflictColumnFlushBool};
	massDetectionOverallConflictQ=Or@@massDetectionConflictBool;
	massDetectionConflictOptions=If[massDetectionOverallConflictQ&&messagesQ,
		Message[Error::MassDetectionConflict, PickList[{MassDetection,StandardMassDetection,BlankMassDetection,ColumnPrimeMassDetection,ColumnFlushMassDetection},massDetectionConflictBool]];
		PickList[{MassDetection,StandardMassDetection,BlankMassDetection,ColumnPrimeMassDetection,ColumnFlushMassDetection},massDetectionConflictBool],
		{}
	];
	massDetectionConflictTests=If[gatherTestsQ,
		Test["If a MassDetection option is specified, it does not conflict with other set options",
			massDetectionOverallConflictQ,
			False
		],
		Nothing
	];

	fragmentMassDetectionConflictBool=collapseErrorBools@{fragmentMassDetectionConflictSampleBool,fragmentMassDetectionConflictStandardBool,fragmentMassDetectionConflictBlankBool,fragmentMassDetectionConflictColumnPrimeBool,fragmentMassDetectionConflictColumnFlushBool};
	fragmentMassDetectionOverallConflictQ=Or@@fragmentMassDetectionConflictBool;
	fragmentMassDetectionConflictOptions=If[fragmentMassDetectionOverallConflictQ&&messagesQ,
		Message[Error::FragmentDetectionConflict, PickList[{FragmentMassDetection,StandardFragmentMassDetection,BlankFragmentMassDetection,ColumnPrimeFragmentMassDetection,ColumnFlushFragmentMassDetection},fragmentMassDetectionConflictBool]];
		PickList[{FragmentMassDetection,StandardFragmentMassDetection,BlankFragmentMassDetection,ColumnPrimeFragmentMassDetection,ColumnFlushFragmentMassDetection},fragmentMassDetectionConflictBool],
		{}
	];
	fragmentMassDetectionConflictTests=If[gatherTestsQ,
		Test["If a FragmentMassDetection option is specified, it does not conflict with other set options.",
			fragmentMassDetectionOverallConflictQ,
			False
		],
		Nothing
	];

	collisionEnergyConflictBool=collapseErrorBools@{collisionEnergyConflictSampleBool,collisionEnergyConflictStandardBool,collisionEnergyConflictBlankBool,collisionEnergyConflictColumnPrimeBool,collisionEnergyConflictColumnFlushBool};
	collisionEnergyOverallConflictQ=Or@@collisionEnergyConflictBool;
	collisionEnergyConflictOptions=If[collisionEnergyOverallConflictQ&&messagesQ,
		Message[Error::CollisonEnergyConflict, PickList[{CollisionEnergy,StandardCollisionEnergy,BlankCollisionEnergy,ColumnPrimeCollisionEnergy,ColumnFlushCollisionEnergy},collisionEnergyConflictBool]];
		PickList[{CollisionEnergy,StandardCollisionEnergy,BlankCollisionEnergy,ColumnPrimeCollisionEnergy,ColumnFlushCollisionEnergy},collisionEnergyConflictBool],
		{}
	];
	collisionEnergyConflictTests=If[gatherTestsQ,
		Test["If a CollisionEnergy option is specified, it does not conflict with the Acquisition mode options.",
			collisionEnergyOverallConflictQ,
			False
		],
		Nothing
	];

	collisionEnergyProfileConflictBool=collapseErrorBools@{collisionEnergyProfileConflictSampleBool,collisionEnergyProfileConflictStandardBool,collisionEnergyProfileConflictBlankBool,collisionEnergyProfileConflictColumnPrimeBool,collisionEnergyProfileConflictColumnFlushBool};
	collisionEnergyProfileOverallConflictQ=Or@@collisionEnergyProfileConflictBool;
	collisionEnergyProfileConflictOptions=If[collisionEnergyProfileOverallConflictQ&&messagesQ,
		Message[Error::CollisionEnergyProfileConflict, PickList[{CollisionEnergy,StandardCollisionEnergy,BlankCollisionEnergy,ColumnPrimeCollisionEnergy,ColumnFlushCollisionEnergy},collisionEnergyProfileConflictBool]];
		PickList[{CollisionEnergy,StandardCollisionEnergy,BlankCollisionEnergy,ColumnPrimeCollisionEnergy,ColumnFlushCollisionEnergy},collisionEnergyProfileConflictBool],
		{}
	];
	collisionEnergyProfileConflictTests=If[gatherTestsQ,
		Test["CollisionEnergy and CollisionEnergyMassProfile are not correctly defined.",
			collisionEnergyProfileOverallConflictQ,
			False
		],
		Nothing
	];

	collisionEnergyScanConflictBool=collapseErrorBools@{collisionEnergyScanConflictSampleBool,collisionEnergyScanConflictStandardBool,collisionEnergyScanConflictBlankBool,collisionEnergyScanConflictColumnPrimeBool,collisionEnergyScanConflictColumnFlushBool};
	collisionEnergyScanOverallConflictQ=Or@@collisionEnergyScanConflictBool;
	collisionEnergyScanConflictOptions=If[collisionEnergyScanOverallConflictQ&&messagesQ,
		Message[Error::CollisionEnergyScanConflict, PickList[{CollisionEnergyMassScan,StandardCollisionEnergyMassScan,BlankCollisionEnergyMassScan,ColumnPrimeCollisionEnergyMassScan,ColumnFlushCollisionEnergyMassScan},collisionEnergyScanConflictBool]];
		PickList[{CollisionEnergyMassScan,StandardCollisionEnergyMassScan,BlankCollisionEnergyMassScan,ColumnPrimeCollisionEnergyMassScan,ColumnFlushCollisionEnergyMassScan},collisionEnergyScanConflictBool],
		{}
	];
	collisionEnergyScanConflictTests=If[gatherTestsQ,
		Test["If a CollisionEnergyMassScan option is specified, the Acquisition mode is DataDependent.",
			collisionEnergyScanOverallConflictQ,
			False
		],
		Nothing
	];

	invalidScanTimesBool = collapseErrorBools @ {invalidScanTimeBool, invalidScanTimeStandardBool, invalidScanTimeBlankBool, invalidScanTimeColumnPrimeBool, invalidScanTimeColumnFlushBool};
	invalidScanTimeOverallQ = Or @@ invalidScanTimesBool;
	invalidScanTimesOptions = If[invalidScanTimeOverallQ && messagesQ,
		Message[Error::LCMSInvalidScanTime, PickList[{ScanTime, StandardScanTime, BlankScanTime, ColumnPrimeScanTime, ColumnFlushScanTime}, invalidScanTimesBool]];
		PickList[{ScanTime, StandardScanTime, BlankScanTime, ColumnPrimeScanTime, ColumnFlushScanTime}, invalidScanTimesBool],
		{}
	];
	invalidScanTimeTests = If[gatherTestsQ,
		Test["If a ScanTime option is specified (for the triple quad MS1), it is neither too short nor too long",
			invalidScanTimeOverallQ,
			False
		],
		Nothing
	];

	(* If conditions empirically determined not to work on the SciEx QTrap 6500 were specified.. *)
	invalidParametersForSciExInstrument = collapseErrorBools @ {sciExInstrumentErrors, sciExInstrumentErrorsStandard, sciExInstrumentErrorsBlank, sciExInstrumentErrorsColumnPrime, sciExInstrumentErrorsColumnFlush};
	invalidParametersForSciExInstrumentOverallQ = Or @@ invalidParametersForSciExInstrument;
	invalidParametersForSciExInstrumentOptions = If[invalidParametersForSciExInstrumentOverallQ && messagesQ,
		Message[Error::InstrumentationLimitation, PickList[{Samples, Standard, Blank, ColumnPrime, ColumnFlush}, invalidParametersForSciExInstrument]];
		Flatten[PickList[{{ScanTime, MassDetection, MassDetectionStepSize}, {StandardScanTime, StandardMassDetection, StandardMassDetectionStepSize}, {BlankScanTime, BlankMassDetection, BlankMassDetectionStepSize}, {ColumnPrimeScanTime, ColumnPrimeMassDetection, ColumnPrimeMassDetectionStepSize}, {ColumnFlushScanTime, ColumnFlushMassDetection, ColumnFlushMassDetectionStepSize}}, invalidParametersForSciExInstrument]],
		{}
	];
	invalidParametersForSciExInstrumentTests = If[gatherTestsQ,
		Test["A combination of conditions for ScanTime, MassDetection, and MassDetectionStepSize were not specified for samples, standards, blanks, column primes and column flushes that are known to cause issues with instrumentation was not given:",
			invalidParametersForSciExInstrumentOverallQ,
			False
		],
		Nothing
	];

	fragmentScanTimeConflictBool=collapseErrorBools@{fragmentScanTimeConflictSampleBool,fragmentScanTimeConflictStandardBool,fragmentScanTimeConflictBlankBool,fragmentScanTimeConflictColumnPrimeBool,fragmentScanTimeConflictColumnFlushBool};
	fragmentScanTimeOverallConflictQ=Or@@fragmentScanTimeConflictBool;
	fragmentScanTimeConflictOptions=If[fragmentScanTimeOverallConflictQ&&messagesQ,
		Message[Error::FragmentScanTimeConflict, PickList[{FragmentScanTime,StandardFragmentScanTime,BlankFragmentScanTime,ColumnPrimeFragmentScanTime,ColumnFlushFragmentScanTime},fragmentScanTimeConflictBool]];
		PickList[{FragmentScanTime,StandardFragmentScanTime,BlankFragmentScanTime,ColumnPrimeFragmentScanTime,ColumnFlushFragmentScanTime},fragmentScanTimeConflictBool],
		{}
	];
	fragmentScanTimeConflictTests=If[gatherTestsQ,
		Test["If a FragmentScanTime option is specified, it does not conflict with other set options",
			fragmentScanTimeOverallConflictQ,
			False
		],
		Nothing
	];

	acquisitionSurveyConflictBool=collapseErrorBools@{acquisitionSurveyConflictSampleBool,acquisitionSurveyConflictStandardBool,acquisitionSurveyConflictBlankBool,acquisitionSurveyConflictColumnPrimeBool,acquisitionSurveyConflictColumnFlushBool};
	acquisitionSurveyOverallConflictQ=Or@@acquisitionSurveyConflictBool;
	acquisitionSurveyConflictOptions=If[acquisitionSurveyOverallConflictQ&&messagesQ,
		Message[Error::AcquisitionSurveyConflict, PickList[{AcquisitionSurvey,StandardAcquisitionSurvey,BlankAcquisitionSurvey,ColumnPrimeAcquisitionSurvey,ColumnFlushAcquisitionSurvey},acquisitionSurveyConflictBool]];
		PickList[{AcquisitionSurvey,StandardAcquisitionSurvey,BlankAcquisitionSurvey,ColumnPrimeAcquisitionSurvey,ColumnFlushAcquisitionSurvey},acquisitionSurveyConflictBool],
		{}
	];
	acquisitionSurveyConflictTests=If[gatherTestsQ,
		Test["If a AcquisitionSurvey option is specified, it does not conflict with other set options",
			acquisitionSurveyOverallConflictQ,
			False
		],
		Nothing
	];

	acquisitionLimitConflictBool=collapseErrorBools@{acquisitionLimitConflictSampleBool,acquisitionLimitConflictStandardBool,acquisitionLimitConflictBlankBool,acquisitionLimitConflictColumnPrimeBool,acquisitionLimitConflictColumnFlushBool};
	acquisitionLimitOverallConflictQ=Or@@acquisitionLimitConflictBool;
	acquisitionLimitConflictOptions=If[acquisitionLimitOverallConflictQ&&messagesQ,
		Message[Error::AcquisitionLimitConflict, PickList[{AcquisitionLimit,StandardAcquisitionLimit,BlankAcquisitionLimit,ColumnPrimeAcquisitionLimit,ColumnFlushAcquisitionLimit},acquisitionLimitConflictBool]];
		PickList[{AcquisitionLimit,StandardAcquisitionLimit,BlankAcquisitionLimit,ColumnPrimeAcquisitionLimit,ColumnFlushAcquisitionLimit},acquisitionLimitConflictBool],
		{}
	];
	acquisitionLimitConflictTests=If[gatherTestsQ,
		Test["If a AcquisitionLimit option is specified, it does not conflict with other set options",
			acquisitionLimitOverallConflictQ,
			False
		],
		Nothing
	];

	cycleTimeLimitConflictBool=collapseErrorBools@{cycleTimeLimitConflictSampleBool,cycleTimeLimitConflictStandardBool,cycleTimeLimitConflictBlankBool,cycleTimeLimitConflictColumnPrimeBool,cycleTimeLimitConflictColumnFlushBool};
	cycleTimeLimitOverallConflictQ=Or@@cycleTimeLimitConflictBool;
	cycleTimeLimitConflictOptions=If[cycleTimeLimitOverallConflictQ&&messagesQ,
		Message[Error::CycleTimeLimitConflict, PickList[{CycleTimeLimit,StandardCycleTimeLimit,BlankCycleTimeLimit,ColumnPrimeCycleTimeLimit,ColumnFlushCycleTimeLimit},cycleTimeLimitConflictBool]];
		PickList[{CycleTimeLimit,StandardCycleTimeLimit,BlankCycleTimeLimit,ColumnPrimeCycleTimeLimit,ColumnFlushCycleTimeLimit},cycleTimeLimitConflictBool],
		{}
	];
	cycleTimeLimitConflictTests=If[gatherTestsQ,
		Test["If a CycleTimeLimit option is specified, it does not conflict with other set options",
			cycleTimeLimitOverallConflictQ,
			False
		],
		Nothing
	];

	exclusionModeMassConflictBool=collapseErrorBools@{exclusionModeMassConflictSampleBool,exclusionModeMassConflictStandardBool,exclusionModeMassConflictBlankBool,exclusionModeMassConflictColumnPrimeBool,exclusionModeMassConflictColumnFlushBool};
	exclusionModeMassOverallConflictQ=Or@@exclusionModeMassConflictBool;
	exclusionModeMassConflictOptions=If[exclusionModeMassOverallConflictQ&&messagesQ,
		Message[
			Error::ExclusionModeConflict,
			PickList[
				{
					{ExclusionDomain, ExclusionMass},
					{
						StandardExclusionDomain,
						StandardExclusionMass
					},
					{
						BlankExclusionDomain,
						BlankExclusionMass
					},
					{
						ColumnPrimeExclusionDomain,
						ColumnPrimeExclusionMass
					},
					{
						ColumnFlushExclusionDomain,
						ColumnFlushExclusionMass
					}
				},
				exclusionModeMassConflictBool
			]];
		PickList[{ExclusionMode,StandardExclusionMode,BlankExclusionMode,ColumnPrimeExclusionMode,ColumnFlushExclusionMode},exclusionModeMassConflictBool],
		{}
	];
	exclusionModeMassConflictTests=If[gatherTestsQ,
		Test["If a ExclusionMode option is specified, it does not conflict with other set options",
			exclusionModeMassOverallConflictQ,
			False
		],
		Nothing
	];

	exclusionModesVariedBool=collapseErrorBools@{exclusionModesVariedSampleBool,exclusionModesVariedStandardBool,exclusionModesVariedBlankBool, exclusionModesVariedColumnPrimeBool, exclusionModesVariedColumnFlushBool};
	exclusionModesVariedOverallConflictQ=Or@@exclusionModesVariedBool;
	exclusionModesVariedOptions=If[exclusionModesVariedOverallConflictQ&&messagesQ,
		Message[
			Error::ExclusionModeMustBeSame,
			PickList[{ExclusionMass,StandardExclusionMass,BlankExclusionMass,ColumnPrimeExclusionMass,ColumnFlushExclusionMass},exclusionModesVariedBool],
			PickList[{resolvedExclusionMasses,resolvedStandardExclusionMasses,resolvedBlankExclusionMasses,resolvedColumnPrimeExclusionMasses,resolvedColumnFlushExclusionMasses},exclusionModesVariedBool]
		];
		PickList[{ExclusionMass,StandardExclusionMass,BlankExclusionMass,ColumnPrimeExclusionMass,ColumnFlushExclusionMass},exclusionModesVariedBool],
		{}
	];
	exclusionModesVariedTests=If[gatherTestsQ,
		Test["If a ExclusionMass option is specified, the types of Exclusion (Once, All) are not varied.",
			exclusionModesVariedOverallConflictQ,
			False
		],
		Nothing
	];

	exclusionMassToleranceConflictBool=collapseErrorBools@{exclusionMassToleranceConflictSampleBool,exclusionMassToleranceConflictStandardBool,exclusionMassToleranceConflictBlankBool,exclusionMassToleranceConflictColumnPrimeBool,exclusionMassToleranceConflictColumnFlushBool};
	exclusionMassToleranceOverallConflictQ=Or@@exclusionMassToleranceConflictBool;
	exclusionMassToleranceConflictOptions=If[exclusionMassToleranceOverallConflictQ&&messagesQ,
		Message[Error::ExclusionMassToleranceConflict, PickList[{ExclusionMassTolerance,StandardExclusionMassTolerance,BlankExclusionMassTolerance,ColumnPrimeExclusionMassTolerance,ColumnFlushExclusionMassTolerance},exclusionMassToleranceConflictBool]];
		PickList[{ExclusionMassTolerance,StandardExclusionMassTolerance,BlankExclusionMassTolerance,ColumnPrimeExclusionMassTolerance,ColumnFlushExclusionMassTolerance},exclusionMassToleranceConflictBool],
		{}
	];
	exclusionMassToleranceConflictTests=If[gatherTestsQ,
		Test["If a ExclusionMassTolerance option is specified, it does not conflict with other set options",
			exclusionMassToleranceOverallConflictQ,
			False
		],
		Nothing
	];

	exclusionRetentionTimeToleranceConflictBool=collapseErrorBools@{exclusionRetentionTimeToleranceConflictSampleBool,exclusionRetentionTimeToleranceConflictStandardBool,exclusionRetentionTimeToleranceConflictBlankBool,exclusionRetentionTimeToleranceConflictColumnPrimeBool,exclusionRetentionTimeToleranceConflictColumnFlushBool};
	exclusionRetentionTimeToleranceOverallConflictQ=Or@@exclusionRetentionTimeToleranceConflictBool;
	exclusionRetentionTimeToleranceConflictOptions=If[exclusionRetentionTimeToleranceOverallConflictQ&&messagesQ,
		Message[Error::ExclusionRetentionTimeConflict, PickList[{ExclusionRetentionTime,StandardExclusionRetentionTime,BlankExclusionRetentionTime,ColumnPrimeExclusionRetentionTime,ColumnFlushExclusionRetentionTime},exclusionRetentionTimeToleranceConflictBool]];
		PickList[{ExclusionRetentionTime,StandardExclusionRetentionTime,BlankExclusionRetentionTime,ColumnPrimeExclusionRetentionTime,ColumnFlushExclusionRetentionTime},exclusionRetentionTimeToleranceConflictBool],
		{}
	];
	exclusionRetentionTimeToleranceConflictTests=If[gatherTestsQ,
		Test["If a ExclusionRetentionTime option is specified, it does not conflict with other set options",
			exclusionRetentionTimeToleranceOverallConflictQ,
			False
		],
		Nothing
	];

	inclusionOptionsConflictBool=collapseErrorBools@{inclusionOptionsConflictSampleBool,inclusionOptionsConflictStandardBool,inclusionOptionsConflictBlankBool,inclusionOptionsConflictColumnPrimeBool,inclusionOptionsConflictColumnFlushBool};
	inclusionOptionsOverallConflictQ=Or@@inclusionOptionsConflictBool;
	inclusionOptionsConflictOptions=If[inclusionOptionsOverallConflictQ&&messagesQ,
		Message[Error::InclusionModeConflict, PickList[{InclusionDomain,StandardInclusionDomain,BlankInclusionDomain,ColumnPrimeInclusionDomain,ColumnFlushInclusionDomain},inclusionOptionsConflictBool]];
		PickList[{InclusionDomain,StandardInclusionDomain,BlankInclusionDomain,ColumnPrimeInclusionDomain,ColumnFlushInclusionDomain},inclusionOptionsConflictBool],
		{}
	];
	inclusionOptionsConflictTests=If[gatherTestsQ,
		Test["If a InclusionDomain options are specified, it does not conflict with other set options",
			inclusionOptionsOverallConflictQ,
			False
		],
		Nothing
	];

	inclusionMassToleranceConflictBool=collapseErrorBools@{inclusionMassToleranceConflictSampleBool,inclusionMassToleranceConflictStandardBool,inclusionMassToleranceConflictBlankBool,inclusionMassToleranceConflictColumnPrimeBool,inclusionMassToleranceConflictColumnFlushBool};
	inclusionMassToleranceOverallConflictQ=Or@@inclusionMassToleranceConflictBool;
	inclusionMassToleranceConflictOptions=If[inclusionMassToleranceOverallConflictQ&&messagesQ,
		Message[Error::InclusionMassToleranceConflict, PickList[{InclusionMassTolerance,StandardInclusionMassTolerance,BlankInclusionMassTolerance,ColumnPrimeInclusionMassTolerance,ColumnFlushInclusionMassTolerance},inclusionMassToleranceConflictBool]];
		PickList[{InclusionMassTolerance,StandardInclusionMassTolerance,BlankInclusionMassTolerance,ColumnPrimeInclusionMassTolerance,ColumnFlushInclusionMassTolerance},inclusionMassToleranceConflictBool],
		{}
	];
	inclusionMassToleranceConflictTests=If[gatherTestsQ,
		Test["If a InclusionMassTolerance option is specified, it does not conflict with other set options",
			inclusionMassToleranceOverallConflictQ,
			False
		],
		Nothing
	];

	chargeStateExclusionLimitConflictBool=collapseErrorBools@{chargeStateExclusionLimitConflictSampleBool,chargeStateExclusionLimitConflictStandardBool,chargeStateExclusionLimitConflictBlankBool,chargeStateExclusionLimitConflictColumnPrimeBool,chargeStateExclusionLimitConflictColumnFlushBool};
	chargeStateExclusionLimitOverallConflictQ=Or@@chargeStateExclusionLimitConflictBool;
	chargeStateExclusionLimitConflictOptions=If[chargeStateExclusionLimitOverallConflictQ&&messagesQ,
		Message[Error::ChargeStateExclusionLimitConflict, PickList[{ChargeStateExclusionLimit,StandardChargeStateExclusionLimit,BlankChargeStateExclusionLimit,ColumnPrimeChargeStateExclusionLimit,ColumnFlushChargeStateExclusionLimit},chargeStateExclusionLimitConflictBool]];
		PickList[{ChargeStateExclusionLimit,StandardChargeStateExclusionLimit,BlankChargeStateExclusionLimit,ColumnPrimeChargeStateExclusionLimit,ColumnFlushChargeStateExclusionLimit},chargeStateExclusionLimitConflictBool],
		{}
	];
	chargeStateExclusionLimitConflictTests=If[gatherTestsQ,
		Test["If a ChargeStateExclusionLimit option is specified, it does not conflict with other set options",
			chargeStateExclusionLimitOverallConflictQ,
			False
		],
		Nothing
	];

	chargeStateExclusionConflictBool=collapseErrorBools@{chargeStateExclusionConflictSampleBool,chargeStateExclusionConflictStandardBool,chargeStateExclusionConflictBlankBool,chargeStateExclusionConflictColumnPrimeBool,chargeStateExclusionConflictColumnFlushBool};
	chargeStateExclusionOverallConflictQ=Or@@chargeStateExclusionConflictBool;
	chargeStateExclusionConflictOptions=If[chargeStateExclusionOverallConflictQ&&messagesQ,
		Message[Error::ChargeStateExclusionConflict, PickList[{ChargeStateExclusion,StandardChargeStateExclusion,BlankChargeStateExclusion,ColumnPrimeChargeStateExclusion,ColumnFlushChargeStateExclusion},chargeStateExclusionConflictBool]];
		PickList[{ChargeStateExclusion,StandardChargeStateExclusion,BlankChargeStateExclusion,ColumnPrimeChargeStateExclusion,ColumnFlushChargeStateExclusion},chargeStateExclusionConflictBool],
		{}
	];
	chargeStateExclusionConflictTests=If[gatherTestsQ,
		Test["If a ChargeStateExclusion option is specified, it does not conflict with other set options",
			chargeStateExclusionOverallConflictQ,
			False
		],
		Nothing
	];

	chargeStateMassToleranceConflictBool=collapseErrorBools@{chargeStateMassToleranceConflictSampleBool,chargeStateMassToleranceConflictStandardBool,chargeStateMassToleranceConflictBlankBool,chargeStateMassToleranceConflictColumnPrimeBool,chargeStateMassToleranceConflictColumnFlushBool};
	chargeStateMassToleranceOverallConflictQ=Or@@chargeStateMassToleranceConflictBool;
	chargeStateMassToleranceConflictOptions=If[chargeStateMassToleranceOverallConflictQ&&messagesQ,
		Message[Error::ChargeStateMassToleranceConflict, PickList[{ChargeStateMassTolerance,StandardChargeStateMassTolerance,BlankChargeStateMassTolerance,ColumnPrimeChargeStateMassTolerance,ColumnFlushChargeStateMassTolerance},chargeStateMassToleranceConflictBool]];
		PickList[{ChargeStateMassTolerance,StandardChargeStateMassTolerance,BlankChargeStateMassTolerance,ColumnPrimeChargeStateMassTolerance,ColumnFlushChargeStateMassTolerance},chargeStateMassToleranceConflictBool],
		{}
	];
	chargeStateMassToleranceConflictTests=If[gatherTestsQ,
		Test["If a ChargeStateMassTolerance option is specified, it does not conflict with other set options",
			chargeStateMassToleranceOverallConflictQ,
			False
		],
		Nothing
	];

	isotopicExclusionLimitBool=collapseErrorBools@{isotopicExclusionLimitSampleBool,isotopicExclusionLimitStandardBool,isotopicExclusionLimitBlankBool,isotopicExclusionLimitColumnPrimeBool,isotopicExclusionLimitColumnFlushBool};
	isotopicExclusionLimitOverallQ=Or@@isotopicExclusionLimitBool;
	isotopicExclusionLimitOptions=If[isotopicExclusionLimitOverallQ&&messagesQ,
		Message[Error::IsotopicExclusionLimitConflict, PickList[{IsotopicExclusion,StandardIsotopicExclusion,BlankIsotopicExclusion,ColumnPrimeIsotopicExclusion,ColumnFlushIsotopicExclusion},isotopicExclusionLimitBool]];
		PickList[{IsotopicExclusion,StandardIsotopicExclusion,BlankIsotopicExclusion,ColumnPrimeIsotopicExclusion,ColumnFlushIsotopicExclusion},isotopicExclusionLimitBool],
		{}
	];
	isotopicExclusionLimitTests=If[gatherTestsQ,
		Test["If an IsotopicExclusionLimit option is specified, it does not conflict with other set options",
			isotopicExclusionLimitOverallQ,
			False
		],
		Nothing
	];

	isotopicExclusionConflictBool=collapseErrorBools@{isotopicExclusionConflictSampleBool,isotopicExclusionConflictStandardBool,isotopicExclusionConflictBlankBool,isotopicExclusionConflictColumnPrimeBool,isotopicExclusionConflictColumnFlushBool};
	isotopicExclusionOverallConflictQ=Or@@isotopicExclusionConflictBool;
	isotopicExclusionConflictOptions=If[isotopicExclusionOverallConflictQ&&messagesQ,
		Message[Error::IsotopicExclusionMassConflict, PickList[{IsotopicExclusion,StandardIsotopicExclusion,BlankIsotopicExclusion,ColumnPrimeIsotopicExclusion,ColumnFlushIsotopicExclusion},isotopicExclusionConflictBool]];
		PickList[{IsotopicExclusion,StandardIsotopicExclusion,BlankIsotopicExclusion,ColumnPrimeIsotopicExclusion,ColumnFlushIsotopicExclusion},isotopicExclusionConflictBool],
		{}
	];
	isotopicExclusionConflictTests=If[gatherTestsQ,
		Test["If a IsotopicExclusionMass option is specified, it does not conflict with other set options",
			isotopicExclusionOverallConflictQ,
			False
		],
		Nothing
	];

	isotopeMassToleranceConflictBool=collapseErrorBools@{isotopeMassToleranceConflictSampleBool,isotopeMassToleranceConflictStandardBool,isotopeMassToleranceConflictBlankBool,isotopeMassToleranceConflictColumnPrimeBool,isotopeMassToleranceConflictColumnFlushBool};
	isotopeMassToleranceOverallConflictQ=Or@@isotopeMassToleranceConflictBool;
	isotopeMassToleranceConflictOptions=If[isotopeMassToleranceOverallConflictQ&&messagesQ,
		Message[Error::IsotopeMassToleranceConflict, PickList[{IsotopeMassTolerance,StandardIsotopeMassTolerance,BlankIsotopeMassTolerance,ColumnPrimeIsotopeMassTolerance,ColumnFlushIsotopeMassTolerance},isotopeMassToleranceConflictBool]];
		PickList[{IsotopeMassTolerance,StandardIsotopeMassTolerance,BlankIsotopeMassTolerance,ColumnPrimeIsotopeMassTolerance,ColumnFlushIsotopeMassTolerance},isotopeMassToleranceConflictBool],
		{}
	];
	isotopeMassToleranceConflictTests=If[gatherTestsQ,
		Test["If a IsotopeMassTolerance option is specified, it does not conflict with other set options",
			isotopeMassToleranceOverallConflictQ,
			False
		],
		Nothing
	];

	isotopeRatioToleranceConflictBool=collapseErrorBools@{isotopeRatioToleranceConflictSampleBool,isotopeRatioToleranceConflictStandardBool,isotopeRatioToleranceConflictBlankBool,isotopeRatioToleranceConflictColumnPrimeBool,isotopeRatioToleranceConflictColumnFlushBool};
	isotopeRatioToleranceOverallConflictQ=Or@@isotopeRatioToleranceConflictBool;
	isotopeRatioToleranceConflictOptions=If[isotopeRatioToleranceOverallConflictQ&&messagesQ,
		Message[Error::IsotopeRatioToleranceConflict, PickList[{IsotopeRatioTolerance,StandardIsotopeRatioTolerance,BlankIsotopeRatioTolerance,ColumnPrimeIsotopeRatioTolerance,ColumnFlushIsotopeRatioTolerance},isotopeRatioToleranceConflictBool]];
		PickList[{IsotopeRatioTolerance,StandardIsotopeRatioTolerance,BlankIsotopeRatioTolerance,ColumnPrimeIsotopeRatioTolerance,ColumnFlushIsotopeRatioTolerance},isotopeRatioToleranceConflictBool],
		{}
	];
	isotopeRatioToleranceConflictTests=If[gatherTestsQ,
		Test["If an IsotopeRatioTolerance option is specified, it does not conflict with other set options",
			isotopeRatioToleranceOverallConflictQ,
			False
		],
		Nothing
	];

	overlappingAcquisitionWindowBool=collapseErrorBools@{overlappingAcquisitionWindowSampleBool, overlappingAcquisitionWindowStandardBool, overlappingAcquisitionWindowBlankBool, overlappingAcquisitionWindowColumnPrimeBool, overlappingAcquisitionWindowColumnFlushBool};
	overlappingAcquisitionWindowOverallConflictQ=Or@@overlappingAcquisitionWindowBool;
	overlappingAcquisitionWindowOptions=If[overlappingAcquisitionWindowOverallConflictQ&&messagesQ,
		Message[
			Error::OverlappingAcquisitionWindows,
			PickList[{AcquisitionWindow,StandardAcquisitionWindow,BlankAcquisitionWindow,ColumnPrimeAcquisitionWindow,ColumnFlushAcquisitionWindow},overlappingAcquisitionWindowBool],
			PickList[{
				resolvedAcquisitionWindows,
				resolvedStandardAcquisitionWindows,
				resolvedBlankAcquisitionWindows,
				resolvedColumnPrimeAcquisitionWindows,
				resolvedColumnFlushAcquisitionWindows
			},overlappingAcquisitionWindowBool]
		];
		PickList[{AcquisitionWindow,StandardAcquisitionWindow,BlankAcquisitionWindow,ColumnPrimeAcquisitionWindow,ColumnFlushAcquisitionWindow},overlappingAcquisitionWindowBool],
		{}
	];
	overlappingAcquisitionWindowTests=If[gatherTestsQ,
		Test["If an AcquisitionWindow option is specified, the windows within do not overlap",
			overlappingAcquisitionWindowOverallConflictQ,
			False
		],
		Nothing
	];

	acquisitionWindowsTooLongBool=collapseErrorBools@{acquisitionWindowsTooLongSampleBool,acquisitionWindowsTooLongStandardBool,acquisitionWindowsTooLongBlankBool, acquisitionWindowsTooLongColumnPrimeBool,acquisitionWindowsTooLongColumnFlushBool};
	acquisitionWindowsTooLongOverallConflictQ=Or@@acquisitionWindowsTooLongBool;
	acquisitionWindowsTooLongOptions=If[acquisitionWindowsTooLongOverallConflictQ&&messagesQ,
		Message[
			Error::AcquisitionWindowTooLong,
			(*acquisition window option*)
			PickList[{AcquisitionWindow,StandardAcquisitionWindow,BlankAcquisitionWindow,ColumnPrimeAcquisitionWindow,ColumnFlushAcquisitionWindow},acquisitionWindowsTooLongBool],
			(*value*)
			PickList[{
				resolvedAcquisitionWindows,
				resolvedStandardAcquisitionWindows,
				resolvedBlankAcquisitionWindows,
				resolvedColumnPrimeAcquisitionWindows,
				resolvedColumnFlushAcquisitionWindows
			},acquisitionWindowsTooLongBool],
			(*gradient end time*)
			Map[
				Function[{gradient},
					If[MatchQ[gradient,ObjectP[]],
						Lookup[fetchPacketFromCache[Download[gradient,Object],cache],Gradient][[-1,1]],
						gradient[[-1,1]]
					]
				],
				PickList[
					Lookup[hplcResolvedOptionsCorrected,{Gradient,StandardGradient,BlankGradient,ColumnPrimeGradient,ColumnFlushGradient}],
					acquisitionWindowsTooLongBool
				]
			]
		];
		PickList[{AcquisitionWindow,StandardAcquisitionWindow,BlankAcquisitionWindow,ColumnPrimeAcquisitionWindow,ColumnFlushAcquisitionWindow},acquisitionWindowsTooLongBool],
		{}
	];
	acquisitionWindowsTooLongTests=If[gatherTestsQ,
		Test["If an AcquisitionWindow option is specified, the window does not exceed the gradient duration.",
			acquisitionWindowsTooLongOverallConflictQ,
			False
		],
		Nothing
	];
	
	(*Acquisition Speicfic ESI-QQQ errors*)
	(*Source Temperature*)
	sourceTemperatureErrorBools=collapseErrorBools@{invalidSourceTemperatureBool,invalidSourceTemperatureStandardBool,invalidSourceTemperatureBlankBool, invalidSourceTemperatureColumnPrimeBool,invalidSourceTemperatureColumnFlushBool};
	sourceTemperatureErrorOverallConflictQ=Or@@sourceTemperatureErrorBools;
	sourceTemperatureErrorOptions=If[sourceTemperatureErrorOverallConflictQ&&messagesQ,
		Message[
			Error::InvalidSourceTemperature,
			(*acquisition window option*)
			PickList[{SourceTemperature,StandardSourceTemperature,BlankSourceTemperature,ColumnPrimeSourceTemperature,ColumnFlushSourceTemperature},sourceTemperatureErrorBools],
			(*value*)
			PickList[{
				resolvedSourceTemperatures,
				resolvedStandardSourceTemperatures,
				resolvedBlankSourceTemperatures,
				resolvedColumnPrimeSourceTemperatures,
				resolvedColumnFlushSourceTemperatures
			},sourceTemperatureErrorBools]
		];
		PickList[{SourceTemperature,StandardSourceTemperature,BlankSourceTemperature,ColumnPrimeSourceTemperature,ColumnFlushSourceTemperature},sourceTemperatureErrorBools],
		{}
	];
	
	souceTemperatureConflictTest=If[gatherTestsQ,
		Test["For ESI-QQQ as mass analyzer, source temperature can only be 150 Celsius",
			sourceTemperatureErrorOverallConflictQ,
			False
		],
		Nothing
	];
	
	(*invalidVoltagesBool*)
	invalidVoltagesErrorBools=collapseErrorBools@{invalidVoltagesBool,invalidVoltagesStandardBool,invalidVoltagesBlankBool, invalidVoltagesColumnPrimeBool,invalidVoltagesColumnFlushBool};
	invalidVoltagesErrorOverallConflictQ=Or@@invalidVoltagesErrorBools;
	invalidVoltagesErrorOptions=If[invalidVoltagesErrorOverallConflictQ&&messagesQ,
		Message[
			Error::InvalidVoltageOptions,
			(*acquisition window option*)
			Flatten[PickList[{
				{ESICapillaryVoltage,DeclusteringVoltage},
				{StandardESICapillaryVoltage,StandardDeclusteringVoltage},
				{BlankESICapillaryVoltage,BlankDeclusteringVoltage},
				{ColumnPrimeESICapillaryVoltage,ColumnPrimeDeclusteringVoltage},
				{ColumnFlushESICapillaryVoltage,ColumnFlushDeclusteringVoltage}
			},invalidVoltagesErrorBools],1],
			(*value*)
			Flatten[PickList[{
				{resolvedESICapillaryVoltages,resolvedDeclusteringVoltages},
				{resolvedStandardESICapillaryVoltages,resolvedStandardDeclusteringVoltages},
				{resolvedBlankESICapillaryVoltages,resolvedBlankDeclusteringVoltages},
				{resolvedColumnPrimeESICapillaryVoltages,resolvedColumnPrimeDeclusteringVoltages},
				{resolvedColumnFlushESICapillaryVoltages,resolvedColumnFlushDeclusteringVoltages}
			},invalidVoltagesErrorBools],1],
			(*gradient end time*)
			Flatten[PickList[{
				resolvedIonModes,
				resolvedStandardIonModes,
				resolvedBlankIonModes,
				resolvedColumnPrimeIonModes,
				resolvedColumnFlushIonModes
			},invalidVoltagesErrorBools],1]
		];
		PickList[{
			{ESICapillaryVoltage,DeclusteringVoltage},
			{StandardESICapillaryVoltage,StandardDeclusteringVoltage},
			{BlankESICapillaryVoltage,BlankDeclusteringVoltage},
			{ColumnPrimeESICapillaryVoltage,ColumnPrimeDeclusteringVoltage},
			{ColumnFlushESICapillaryVoltage,ColumnFlushDeclusteringVoltage}
		},invalidVoltagesErrorBools],
		{}
	];
	
	voltagesConflictTest=If[gatherTestsQ,
		Test["For ESI-QQQ as mass analyzer, source temperature can only be 150 Celsius",
			invalidVoltagesErrorOverallConflictQ,
			False
		],
		Nothing
	];
	
	(*invalidCollisionVoltagesBool*)
	invalidCollisionVoltagesErrorBools=collapseErrorBools@{invalidCollisionVoltagesBool,invalidCollisionVoltagesStandardBool,invalidCollisionVoltagesBlankBool, invalidCollisionVoltagesColumnPrimeBool,invalidCollisionVoltagesColumnFlushBool};
	invalidCollisionVoltagesErrorOverallConflictQ=Or@@invalidCollisionVoltagesErrorBools;
	invalidCollisionVoltagesErrorOptions=If[invalidCollisionVoltagesErrorOverallConflictQ&&messagesQ,
		Message[
			Error::InvalidCollisionVoltageOptions,
			(*acquisition window option*)
			Flatten[PickList[{
				{CollisionEnergy,CollisionCellExitVoltage},
				{StandardCollisionEnergy,StandardCollisionCellExitVoltage},
				{BlankCollisionEnergy,BlankCollisionCellExitVoltage},
				{ColumnPrimeCollisionEnergy,ColumnPrimeCollisionCellExitVoltage},
				{ColumnFlushCollisionEnergy,ColumnFlushCollisionCellExitVoltage}
			},invalidCollisionVoltagesErrorBools],1],
			(*value*)
			Flatten[PickList[{
				{resolvedCollisionEnergies,resolvedCollisionCellExitVoltages},
				{resolvedStandardCollisionEnergies,resolvedStandardCollisionCellExitVoltages},
				{resolvedBlankCollisionEnergies,resolvedBlankCollisionCellExitVoltages},
				{resolvedColumnPrimeCollisionEnergies,resolvedColumnPrimeCollisionCellExitVoltages},
				{resolvedColumnFlushCollisionEnergies,resolvedColumnFlushCollisionCellExitVoltages}
			},invalidCollisionVoltagesErrorBools],1],
			(*gradient end time*)
			Flatten[PickList[{
				resolvedIonModes,
				resolvedStandardIonModes,
				resolvedBlankIonModes,
				resolvedColumnPrimeIonModes,
				resolvedColumnFlushIonModes
			},invalidCollisionVoltagesErrorBools],1]
		];
		PickList[{
			{CollisionEnergy,CollisionCellExitVoltage},
			{StandardCollisionEnergy,StandardCollisionCellExitVoltage},
			{BlankCollisionEnergy,BlankCollisionCellExitVoltage},
			{ColumnPrimeCollisionEnergy,ColumnPrimeCollisionCellExitVoltage},
			{ColumnFlushCollisionEnergy,ColumnFlushCollisionCellExitVoltage}
		},invalidCollisionVoltagesErrorBools],
		{}
	];
	
	collisionVoltagesConflictTest=If[gatherTestsQ,
		Test["For ESI-QQQ as mass analyzer, source temperature can only be 150 Celsius",
			invalidVoltagesErrorOverallConflictQ,
			False
		],
		Nothing
	];

	(*invalidLengthOfInputOptionBool for MultipleReactionMonitoring*)
	invalidLengthOfInputBools=collapseErrorBools@{
		invalidLengthOfInputOptionBool,
		invalidLengthOfInputOptionStandardBool,
		invalidLengthOfInputOptionBlankBool,
		invalidLengthOfInputOptionColumnPrimeBool,
		invalidLengthOfInputOptionColumnFlushBool
	};
	invalidLengthOfInputOverallConflictQ=Or@@invalidLengthOfInputBools;
	invalidLengthOfInputOptions=If[invalidLengthOfInputOverallConflictQ&&messagesQ,
		Message[
			Error::LCMSInvalidMultipleReactionMonitoringLengthOfInputOptions,
			(*acquisition window option*)
			PickList[{
				MultipleReactionMonitoringAssays,
				StandardMultipleReactionMonitoringAssays,
				BlankMultipleReactionMonitoringAssays,
				ColumnPrimeMultipleReactionMonitoringAssays,
				ColummFlushMultipleReactionMonitoringAssays
			},invalidLengthOfInputBools],
			(*value*)
			PickList[{
				resolvedMultipleReactionMonitoringAssays,
				resolvedStandardMultipleReactionMonitoringAssays,
				resolvedBlankMultipleReactionMonitoringAssays,
				resolvedColumnPrimeMultipleReactionMonitoringAssays,
				resolvedColumnFlushMultipleReactionMonitoringAssays
			},invalidLengthOfInputBools]
		];
		PickList[{
			MultipleReactionMonitoringAssays,
			StandardMultipleReactionMonitoringAssays,
			BlankMultipleReactionMonitoringAssays,
			ColumnPrimeMultipleReactionMonitoringAssays,
			ColummFlushMultipleReactionMonitoringAssays
		},invalidLengthOfInputBools],
		{}
	];

	memAssaysNotInSameLengthTest=If[gatherTestsQ,
		Test["For ESI-QQQ as mass analyzer, source temperature can only be 150 Celsius",
			invalidVoltagesErrorOverallConflictQ,
			False
		],
		Nothing
	];
	
	
	(*invalidLengthOfInputOptionBool for MultipleReactionMonitoring*)
	collisionEnergyAcqModeInvalidBools=collapseErrorBools@{
		collisionEnergyAcqModeInvalidBool,
		collisionEnergyAcqModeInvalidStandardBool,
		collisionEnergyAcqModeInvalidBlankBool,
		collisionEnergyAcqModeInvalidColumnPrimeBool,
		collisionEnergyAcqModeInvalidColumnFlushBool
	};
	collisionEnergyAcqModeInvalidOverallConflictQ=Or@@collisionEnergyAcqModeInvalidBools;
	invalidCollisionEnergyAcqModeOptions=If[collisionEnergyAcqModeInvalidOverallConflictQ&&messagesQ,
		Message[
			Error::LCMSCollisionEnergyAcquisitionModeConflict,
			(*acquisition window option*)
			PickList[{
				CollisionEnergy,
				StandardCollisionEnergy,
				BlankCollisionEnergy,
				ColumnPrimeCollisionEnergy,
				ColummFlushCollisionEnergy
			},collisionEnergyAcqModeInvalidBools],
			(*value*)
			First@Flatten[Map[List,PickList[{
				resolvedCollisionEnergies,
				resolvedStandardCollisionEnergies,
				resolvedBlankCollisionEnergies,
				resolvedColumnPrimeCollisionEnergies,
				resolvedColumnFlushCollisionEnergies
			},collisionEnergyAcqModeInvalidBools],{4}],2]
		];
		PickList[{
			CollisionEnergy,
			StandardCollisionEnergy,
			BlankCollisionEnergy,
			ColumnPrimeCollisionEnergy,
			ColummFlushCollisionEnergy
		},collisionEnergyAcqModeInvalidBools],
		{}
	];
	
	invalidCollisionEnergyAcqModeTest=If[gatherTestsQ,
		Test["If the AcquisitionMode is not MultipleReactionMonitoring, the CollisionEnergy cannot be a list:",
			collisionEnergyAcqModeInvalidOverallConflictQ,
			False
		],
		Nothing
	];
	
	
	(*invalidGasFlowBool*)
	invalidGasFlowErrorBools=collapseErrorBools@{invalidGasFlowBool,invalidGasFlowStandardBool,invalidGasFlowBlankBool, invalidGasFlowColumnPrimeBool,invalidGasFlowColumnFlushBool};
	invalidGasFlowErrorOverallConflictQ=Or@@invalidGasFlowErrorBools;
	invalidGasFlowErrorOptions=If[invalidGasFlowErrorOverallConflictQ&&messagesQ,
		Message[
			Error::InvalidGasFlowOptions,
			(*acquisition window option*)
			Flatten[PickList[{
				{ConeGasFlow,DesolvationGasFlow},
				{StandardConeGasFlow,StandardDesolvationGasFlow},
				{BlankConeGasFlow,BlankDesolvationGasFlow},
				{ColumnPrimeConeGasFlow,ColumnPrimeDesolvationGasFlow},
				{ColumnFlushConeGasFlow,ColumnFlushDesolvationGasFlow}
			},invalidGasFlowErrorBools],1],
			(*value*)
			Flatten[PickList[{
				{resolvedConeGasFlows,resolvedDesolvationGasFlows},
				{resolvedStandardConeGasFlows,resolvedStandardDesolvationGasFlows},
				{resolvedBlankConeGasFlows,resolvedBlankDesolvationGasFlows},
				{resolvedColumnPrimeConeGasFlows,resolvedColumnPrimeDesolvationGasFlows},
				{resolvedColumnFlushConeGasFlows,resolvedColumnFlushDesolvationGasFlows}
			},invalidGasFlowErrorBools],1],
			(*gradient end time*)
			resolvedMassAnalyzer
		];
		PickList[{
			{ConeGasFlow,DesolvationGasFlow},
			{StandardConeGasFlow,StandardDesolvationGasFlow},
			{BlankConeGasFlow,BlankDesolvationGasFlow},
			{ColumnPrimeConeGasFlow,ColumnPrimeDesolvationGasFlow},
			{ColumnFlushConeGasFlow,ColumnFlushDesolvationGasFlow}
		},invalidGasFlowErrorBools],
		{}
	];
	
	gasflowsConflictTest=If[gatherTestsQ,
		Test["For ESI-QQQ as mass analyzer, source temperature can only be 150 Celsius",
			invalidGasFlowErrorOverallConflictQ,
			False
		],
		Nothing
	];

	(*acqModeMassAnalyzerMismatchBool*)
	invalidAcqMethodErrorBools=collapseErrorBools@{
		acqModeMassAnalyzerMismatchBool,
		acqModeMassAnalyzerMismatchedStandardBool,
		acqModeMassAnalyzerMismatchedBlankBool,
		acqModeMassAnalyzerMismatchedColumnPrimeBool,
		acqModeMassAnalyzerMismatchedColumnFlushBool
	};
	invalidAcqMethodErrorOverallConflictQ=Or@@invalidAcqMethodErrorBools;
	invalidAcqMethodErrorOptions=If[invalidAcqMethodErrorOverallConflictQ&&messagesQ,
		Message[
			Error::MassAnalyzerAndAcquitionModeMismatched,
			(*acquisition window option*)
			PickList[{
				AcquisitionMode,
				StandardAcquisitionMode,
				BlankAcquisitionMode,
				ColumnPrimeAcquisitionMode,
				ColumnFlushAcquisitionMode
			},invalidAcqMethodErrorBools],
			(*value*)
			PickList[{
				resolvedAcquisitionModes,
				resolvedStandardAcquisitionModes,
				resolvedBlankAcquisitionModes,
				resolvedColumnPrimeAcquisitionModes,
				resolvedColumnFlushAcquisitionModes
			},invalidAcqMethodErrorBools],
			(*gradient end time*)
			resolvedMassAnalyzer
		];
		PickList[{
			AcquisitionMode,
			StandardAcquisitionMode,
			BlankAcquisitionMode,
			ColumnPrimeAcquisitionMode,
			ColumnFlushAcquisitionMode
		},invalidAcqMethodErrorBools],
		{}
	];
	acqModeMassAnalyzerConflictTest=If[gatherTestsQ,
		Test["For ESI-QQQ as mass analyzer, source temperature can only be 150 Celsius",
			invalidAcqMethodErrorOverallConflictQ,
			False
		],
		Nothing
	];

	(* Warning *)
	(*autoNeutralLossValueWarningList*)
	autoNeutralLossErrorBools=collapseErrorBools@{
		autoNeutralLossValueWarningList,
		autoNeutralLossValueWarningStandardList,
		autoNeutralLossValueWarningBlankList,
		autoNeutralLossValueWarningColumnPrimeList,
		autoNeutralLossValueWarningColumnFlushList
	};
	autoNeutralLossErrorOverallConflictQ=Or@@autoNeutralLossErrorBools;
	If[autoNeutralLossErrorOverallConflictQ&&messagesQ,
		Message[
			Warning::LCMSAutoResolvedNeutralLoss,
			(*acquisition window option*)
			PickList[{
				NeutralLoss,
				StandardNeutralLoss,
				BlankNeutralLoss,
				ColumnPrimeNeutralLoss,
				ColumnFlushNeutralLoss
			},autoNeutralLossErrorBools],
			(*value*)
			PickList[{
				resolvedNeutralLosses,
				resolvedStandardNeutralLosses,
				resolvedBlankNeutralLosses,
				resolvedColumnPrimeNeutralLosses,
				resolvedColumnFlushNeutralLosses
			},autoNeutralLossErrorBools]
		]
	];
	

	(*check whether the data independent is by itself in the acquisition modes*)
	dataIndependentNotAloneBool=Map[
		Function[{resolvedAcquistionModeSet},
			Or@@Map[
				Function[{currentAcquisitionModes},
					If[MemberQ[ToList@currentAcquisitionModes,DataIndependent],
						!MatchQ[ToList@currentAcquisitionModes,{DataIndependent}],
						False
					]
				],
				ToList@resolvedAcquistionModeSet
			]
		],
		{
			resolvedAcquisitionModes,
			resolvedStandardAcquisitionModes,
			resolvedBlankAcquisitionModes,
			{resolvedColumnPrimeAcquisitionModes},
			{resolvedColumnFlushAcquisitionModes}
		}
	];

	dataIndependentNotAloneQ=Or@@dataIndependentNotAloneBool;
	dataIndependentNotAloneOptions=If[dataIndependentNotAloneQ&&messagesQ,
		Message[Error::DataIndependentSoleWindow, PickList[{AcquisitionMode,StandardAcquisitionMode,BlankAcquisitionMode,ColumnPrimeAcquisitionMode,ColumnFlushAcquisitionMode},dataIndependentNotAloneBool]];
		PickList[{AcquisitionMode,StandardAcquisitionMode,BlankAcquisitionMode,ColumnPrimeAcquisitionMode,ColumnFlushAcquisitionMode},dataIndependentNotAloneBool],
		{}
	];
	dataIndependentNotAloneTests=If[gatherTestsQ,
		Test["If DataIndependent acquisition is desired, it's the only acquisition mode selected.",
			dataIndependentNotAloneQ,
			False
		],
		Nothing
	];

	(*check if the detector option has been repeated multiple times*)
	detectorLookup=ToList[Lookup[lcmsOptionsAssociation,Detector]];
	repeatedDetectorOptionQ=MemberQ[Last /@ Tally[detectorLookup], GreaterP[1]];

	If[repeatedDetectorOptionQ&&messagesQ,
		Message[Warning::RepeatedDetectors, ToString@detectorLookup]
	];

	detectorOptionDeleteDuplicates=If[repeatedDetectorOptionQ,
		DeleteDuplicates[detectorLookup],
		detectorLookup
	];

	repeatedDetectorOptionTest=If[gatherTestsQ,
		Warning["If Detector is specified, no entries are repeating.",
			repeatedDetectorOptionQ,
			False
		],
		Nothing
	];

	(* -- End Game -- *)

	resolvedExperimentOptions=Association[
		MassAnalyzer -> resolvedMassAnalyzer,
		MassSpectrometerInstrument -> resolvedMassSpectrometryInstrument,
		ChromatographyInstrument -> Lookup[lcmsOptionsAssociation,ChromatographyInstrument],
		Detector -> detectorOptionDeleteDuplicates,

		(*LCMS specific options*)

		InjectionTable -> resolvedInjectionTable,
		Calibrant -> resolvedCalibrant,
		SecondCalibrant ->resolvedSecondCalibrant,

		Analytes -> resolvedAnalytes,
		IonMode->resolvedIonModes,
		MassSpectrometryMethod->resolvedMassSpectrometryMethods,
		ESICapillaryVoltage->resolvedESICapillaryVoltages,
		DeclusteringVoltage->resolvedDeclusteringVoltages,
		IonGuideVoltage->resolvedIonGuideVoltages,
		StepwaveVoltage->resolvedStepwaveVoltages,
		SourceTemperature->resolvedSourceTemperatures,
		DesolvationTemperature->resolvedDesolvationTemperatures,
		DesolvationGasFlow->resolvedDesolvationGasFlows,
		ConeGasFlow->resolvedConeGasFlows,
		AcquisitionWindow->resolvedAcquisitionWindows,
		AcquisitionMode->resolvedAcquisitionModes,
		Fragment->resolvedFragments,
		MassDetection->resolvedMassDetections,
		ScanTime->resolvedScanTimes,
		FragmentMassDetection->resolvedFragmentMassDetections,
		CollisionEnergy->resolvedCollisionEnergies,
		CollisionEnergyMassProfile->resolvedCollisionEnergyMassProfiles,
		CollisionEnergyMassScan->resolvedCollisionEnergyMassScans,
		FragmentScanTime->resolvedFragmentScanTimes,
		AcquisitionSurvey->resolvedAcquisitionSurveys,
		MinimumThreshold->resolvedMinimumThresholds,
		AcquisitionLimit->resolvedAcquisitionLimits,
		CycleTimeLimit->resolvedCycleTimeLimits,
		ExclusionDomain->resolvedExclusionDomains,
		ExclusionMass->resolvedExclusionMasses,
		ExclusionMassTolerance->resolvedExclusionMassTolerances,
		ExclusionRetentionTimeTolerance->resolvedExclusionRetentionTimeTolerances,
		InclusionDomain->resolvedInclusionDomains,
		InclusionMass->resolvedInclusionMasses,
		InclusionCollisionEnergy->resolvedInclusionCollisionEnergies,
		InclusionDeclusteringVoltage->resolvedInclusionDeclusteringVoltages,
		InclusionChargeState->resolvedInclusionChargeStates,
		InclusionScanTime->resolvedInclusionScanTimes,
		InclusionMassTolerance->resolvedInclusionMassTolerances,
		SurveyChargeStateExclusion->resolvedSurveyChargeStateExclusions,
		SurveyIsotopeExclusion->resolvedSurveyIsotopeExclusions,
		ChargeStateExclusionLimit->resolvedChargeStateExclusionLimits,
		ChargeStateExclusion->resolvedChargeStateExclusions,
		ChargeStateMassTolerance->resolvedChargeStateMassTolerances,
		IsotopicExclusion->resolvedIsotopicExclusions,
		IsotopeRatioThreshold->resolvedIsotopeRatioThresholds,
		IsotopeDetectionMinimum->resolvedIsotopeDetectionMinimums,
		IsotopeMassTolerance->resolvedIsotopeMassTolerances,
		IsotopeRatioTolerance->resolvedIsotopeRatioTolerances,
		DwellTime->resolvedDwellTimes,
		CollisionCellExitVoltage->resolvedCollisionCellExitVoltages,
		MassDetectionStepSize->resolvedMassDetectionStepSizes,
		MultipleReactionMonitoringAssays->resolvedMultipleReactionMonitoringAssays,
		NeutralLoss->resolvedNeutralLosses,

		StandardFrequency -> Lookup[hplcResolvedOptionsCorrected,StandardFrequency],
		StandardAnalytes -> ReplaceAll[resolvedStandardAnalytes,{{}:>Null}],
		StandardIonMode -> resolvedStandardIonModes,
		StandardMassSpectrometryMethod -> resolvedStandardMassSpectrometryMethods,
		StandardESICapillaryVoltage -> resolvedStandardESICapillaryVoltages,
		StandardDeclusteringVoltage -> resolvedStandardDeclusteringVoltages,
		StandardStepwaveVoltage -> resolvedStandardStepwaveVoltages,
		StandardIonGuideVoltage->resolvedStandardIonGuideVoltages,
		StandardSourceTemperature -> resolvedStandardSourceTemperatures,
		StandardDesolvationTemperature -> resolvedStandardDesolvationTemperatures,
		StandardDesolvationGasFlow -> resolvedStandardDesolvationGasFlows,
		StandardConeGasFlow -> resolvedStandardConeGasFlows,
		StandardAcquisitionWindow->resolvedStandardAcquisitionWindows,
		StandardAcquisitionMode->resolvedStandardAcquisitionModes,
		StandardFragment->resolvedStandardFragments,
		StandardMassDetection->resolvedStandardMassDetections,
		StandardScanTime->resolvedStandardScanTimes,
		StandardFragmentMassDetection->resolvedStandardFragmentMassDetections,
		StandardCollisionEnergy->resolvedStandardCollisionEnergies,
		StandardCollisionEnergyMassProfile->resolvedStandardCollisionEnergyMassProfiles,
		StandardCollisionEnergyMassScan->resolvedStandardCollisionEnergyMassScans,
		StandardFragmentScanTime->resolvedStandardFragmentScanTimes,
		StandardAcquisitionSurvey->resolvedStandardAcquisitionSurveys,
		StandardMinimumThreshold->resolvedStandardMinimumThresholds,
		StandardAcquisitionLimit->resolvedStandardAcquisitionLimits,
		StandardCycleTimeLimit->resolvedStandardCycleTimeLimits,
		StandardExclusionDomain->resolvedStandardExclusionDomains,
		StandardExclusionMass->resolvedStandardExclusionMasses,
		StandardExclusionMassTolerance->resolvedStandardExclusionMassTolerances,
		StandardExclusionRetentionTimeTolerance->resolvedStandardExclusionRetentionTimeTolerances,
		StandardInclusionDomain->resolvedStandardInclusionDomains,
		StandardInclusionMass->resolvedStandardInclusionMasses,
		StandardInclusionCollisionEnergy->resolvedStandardInclusionCollisionEnergies,
		StandardInclusionDeclusteringVoltage->resolvedStandardInclusionDeclusteringVoltages,
		StandardInclusionChargeState->resolvedStandardInclusionChargeStates,
		StandardInclusionScanTime->resolvedStandardInclusionScanTimes,
		StandardInclusionMassTolerance->resolvedStandardInclusionMassTolerances,
		StandardSurveyChargeStateExclusion->resolvedStandardSurveyChargeStateExclusions,
		StandardSurveyIsotopeExclusion->resolvedStandardSurveyIsotopeExclusions,
		StandardChargeStateExclusionLimit->resolvedStandardChargeStateExclusionLimits,
		StandardChargeStateExclusion->resolvedStandardChargeStateExclusions,
		StandardChargeStateMassTolerance->resolvedStandardChargeStateMassTolerances,
		StandardIsotopicExclusion->resolvedStandardIsotopicExclusions,
		StandardIsotopeRatioThreshold->resolvedStandardIsotopeRatioThresholds,
		StandardIsotopeDetectionMinimum->resolvedStandardIsotopeDetectionMinimums,
		StandardIsotopeMassTolerance->resolvedStandardIsotopeMassTolerances,
		StandardIsotopeRatioTolerance->resolvedStandardIsotopeRatioTolerances,
		StandardDwellTime->resolvedStandardDwellTimes,
		StandardCollisionCellExitVoltage->resolvedStandardCollisionCellExitVoltages,
		StandardMassDetectionStepSize->resolvedStandardMassDetectionStepSizes,
		StandardMultipleReactionMonitoringAssays->resolvedStandardMultipleReactionMonitoringAssays,
		StandardNeutralLoss->resolvedStandardNeutralLosses,
		

		BlankFrequency -> Lookup[hplcResolvedOptionsCorrected,BlankFrequency],
		BlankAnalytes -> ReplaceAll[resolvedBlankAnalytes,{{}:>Null}],
		BlankIonMode -> resolvedBlankIonModes,
		BlankMassSpectrometryMethod -> resolvedBlankMassSpectrometryMethods,
		BlankESICapillaryVoltage -> resolvedBlankESICapillaryVoltages,
		BlankDeclusteringVoltage -> resolvedBlankDeclusteringVoltages,
		BlankStepwaveVoltage -> resolvedBlankStepwaveVoltages,
		BlankIonGuideVoltage->resolvedBlankIonGuideVoltages,
		BlankSourceTemperature -> resolvedBlankSourceTemperatures,
		BlankDesolvationTemperature -> resolvedBlankDesolvationTemperatures,
		BlankDesolvationGasFlow -> resolvedBlankDesolvationGasFlows,
		BlankConeGasFlow -> resolvedBlankConeGasFlows,
		BlankAcquisitionWindow->resolvedBlankAcquisitionWindows,
		BlankAcquisitionMode->resolvedBlankAcquisitionModes,
		BlankFragment->resolvedBlankFragments,
		BlankMassDetection->resolvedBlankMassDetections,
		BlankScanTime->resolvedBlankScanTimes,
		BlankFragmentMassDetection->resolvedBlankFragmentMassDetections,
		BlankCollisionEnergy->resolvedBlankCollisionEnergies,
		BlankCollisionEnergyMassProfile->resolvedBlankCollisionEnergyMassProfiles,
		BlankCollisionEnergyMassScan->resolvedBlankCollisionEnergyMassScans,
		BlankFragmentScanTime->resolvedBlankFragmentScanTimes,
		BlankAcquisitionSurvey->resolvedBlankAcquisitionSurveys,
		BlankMinimumThreshold->resolvedBlankMinimumThresholds,
		BlankAcquisitionLimit->resolvedBlankAcquisitionLimits,
		BlankCycleTimeLimit->resolvedBlankCycleTimeLimits,
		BlankExclusionDomain->resolvedBlankExclusionDomains,
		BlankExclusionMass->resolvedBlankExclusionMasses,
		BlankExclusionMassTolerance->resolvedBlankExclusionMassTolerances,
		BlankExclusionRetentionTimeTolerance->resolvedBlankExclusionRetentionTimeTolerances,
		BlankInclusionDomain->resolvedBlankInclusionDomains,
		BlankInclusionMass->resolvedBlankInclusionMasses,
		BlankInclusionCollisionEnergy->resolvedBlankInclusionCollisionEnergies,
		BlankInclusionDeclusteringVoltage->resolvedBlankInclusionDeclusteringVoltages,
		BlankInclusionChargeState->resolvedBlankInclusionChargeStates,
		BlankInclusionScanTime->resolvedBlankInclusionScanTimes,
		BlankInclusionMassTolerance->resolvedBlankInclusionMassTolerances,
		BlankSurveyChargeStateExclusion->resolvedBlankSurveyChargeStateExclusions,
		BlankSurveyIsotopeExclusion->resolvedBlankSurveyIsotopeExclusions,
		BlankChargeStateExclusionLimit->resolvedBlankChargeStateExclusionLimits,
		BlankChargeStateExclusion->resolvedBlankChargeStateExclusions,
		BlankChargeStateMassTolerance->resolvedBlankChargeStateMassTolerances,
		BlankIsotopicExclusion->resolvedBlankIsotopicExclusions,
		BlankIsotopeRatioThreshold->resolvedBlankIsotopeRatioThresholds,
		BlankIsotopeDetectionMinimum->resolvedBlankIsotopeDetectionMinimums,
		BlankIsotopeMassTolerance->resolvedBlankIsotopeMassTolerances,
		BlankIsotopeRatioTolerance->resolvedBlankIsotopeRatioTolerances,
		BlankDwellTime->resolvedBlankDwellTimes,
		BlankCollisionCellExitVoltage->resolvedBlankCollisionCellExitVoltages,
		BlankMassDetectionStepSize->resolvedBlankMassDetectionStepSizes,
		BlankMultipleReactionMonitoringAssays->resolvedBlankMultipleReactionMonitoringAssays,
		BlankNeutralLoss->resolvedBlankNeutralLosses,

		(*need to de list if we have something*)
		ColumnPrimeIonMode-> If[!NullQ[resolvedColumnPrimeIonModes], First@resolvedColumnPrimeIonModes],
		ColumnPrimeMassSpectrometryMethod-> If[!NullQ[resolvedColumnPrimeMassSpectrometryMethods], First@resolvedColumnPrimeMassSpectrometryMethods],
		ColumnPrimeESICapillaryVoltage-> If[!NullQ[resolvedColumnPrimeESICapillaryVoltages], First@resolvedColumnPrimeESICapillaryVoltages],
		ColumnPrimeDeclusteringVoltage-> If[!NullQ[resolvedColumnPrimeDeclusteringVoltages], First@resolvedColumnPrimeDeclusteringVoltages],
		ColumnPrimeStepwaveVoltage-> If[!NullQ[resolvedColumnPrimeStepwaveVoltages], First@resolvedColumnPrimeStepwaveVoltages],
		ColumnPrimeIonGuideVoltage-> If[!NullQ[resolvedColumnPrimeIonGuideVoltages], First@resolvedColumnPrimeIonGuideVoltages],
		ColumnPrimeSourceTemperature-> If[!NullQ[resolvedColumnPrimeSourceTemperatures], First@resolvedColumnPrimeSourceTemperatures],
		ColumnPrimeDesolvationTemperature-> If[!NullQ[resolvedColumnPrimeDesolvationTemperatures], First@resolvedColumnPrimeDesolvationTemperatures],
		ColumnPrimeDesolvationGasFlow-> If[!NullQ[resolvedColumnPrimeDesolvationGasFlows], First@resolvedColumnPrimeDesolvationGasFlows],
		ColumnPrimeConeGasFlow-> If[!NullQ[resolvedColumnPrimeConeGasFlows], First@resolvedColumnPrimeConeGasFlows],
		ColumnPrimeAcquisitionWindow-> If[!NullQ[resolvedColumnPrimeAcquisitionWindows], First@resolvedColumnPrimeAcquisitionWindows],
		ColumnPrimeAcquisitionMode-> If[!NullQ[resolvedColumnPrimeAcquisitionModes], First@resolvedColumnPrimeAcquisitionModes],
		ColumnPrimeFragment-> If[!NullQ[resolvedColumnPrimeFragments], First@resolvedColumnPrimeFragments],
		ColumnPrimeMassDetection-> If[!NullQ[resolvedColumnPrimeMassDetections], First@resolvedColumnPrimeMassDetections],
		ColumnPrimeScanTime-> If[!NullQ[resolvedColumnPrimeScanTimes], First@resolvedColumnPrimeScanTimes],
		ColumnPrimeFragmentMassDetection-> If[!NullQ[resolvedColumnPrimeFragmentMassDetections], First@resolvedColumnPrimeFragmentMassDetections],
		ColumnPrimeCollisionEnergy-> If[!NullQ[resolvedColumnPrimeCollisionEnergies], First@resolvedColumnPrimeCollisionEnergies],
		ColumnPrimeCollisionEnergyMassProfile-> If[!NullQ[resolvedColumnPrimeCollisionEnergyMassProfiles], First@resolvedColumnPrimeCollisionEnergyMassProfiles],
		ColumnPrimeCollisionEnergyMassScan-> If[!NullQ[resolvedColumnPrimeCollisionEnergyMassScans], First@resolvedColumnPrimeCollisionEnergyMassScans],
		ColumnPrimeFragmentScanTime-> If[!NullQ[resolvedColumnPrimeFragmentScanTimes], First@resolvedColumnPrimeFragmentScanTimes],
		ColumnPrimeAcquisitionSurvey-> If[!NullQ[resolvedColumnPrimeAcquisitionSurveys], First@resolvedColumnPrimeAcquisitionSurveys],
		ColumnPrimeMinimumThreshold-> If[!NullQ[resolvedColumnPrimeMinimumThresholds], First@resolvedColumnPrimeMinimumThresholds],
		ColumnPrimeAcquisitionLimit-> If[!NullQ[resolvedColumnPrimeAcquisitionLimits], First@resolvedColumnPrimeAcquisitionLimits],
		ColumnPrimeCycleTimeLimit-> If[!NullQ[resolvedColumnPrimeCycleTimeLimits], First@resolvedColumnPrimeCycleTimeLimits],
		ColumnPrimeExclusionDomain-> If[!NullQ[resolvedColumnPrimeExclusionDomains], First@resolvedColumnPrimeExclusionDomains],
		ColumnPrimeExclusionMass-> If[!NullQ[resolvedColumnPrimeExclusionMasses], First@resolvedColumnPrimeExclusionMasses],
		ColumnPrimeExclusionMassTolerance-> If[!NullQ[resolvedColumnPrimeExclusionMassTolerances], First@resolvedColumnPrimeExclusionMassTolerances],
		ColumnPrimeExclusionRetentionTimeTolerance-> If[!NullQ[resolvedColumnPrimeExclusionRetentionTimeTolerances], First@resolvedColumnPrimeExclusionRetentionTimeTolerances],
		ColumnPrimeInclusionDomain-> If[!NullQ[resolvedColumnPrimeInclusionDomains], First@resolvedColumnPrimeInclusionDomains],
		ColumnPrimeInclusionMass-> If[!NullQ[resolvedColumnPrimeInclusionMasses], First@resolvedColumnPrimeInclusionMasses],
		ColumnPrimeInclusionCollisionEnergy-> If[!NullQ[resolvedColumnPrimeInclusionCollisionEnergies], First@resolvedColumnPrimeInclusionCollisionEnergies],
		ColumnPrimeInclusionDeclusteringVoltage-> If[!NullQ[resolvedColumnPrimeInclusionDeclusteringVoltages], First@resolvedColumnPrimeInclusionDeclusteringVoltages],
		ColumnPrimeInclusionChargeState-> If[!NullQ[resolvedColumnPrimeInclusionChargeStates], First@resolvedColumnPrimeInclusionChargeStates],
		ColumnPrimeInclusionScanTime-> If[!NullQ[resolvedColumnPrimeInclusionScanTimes], First@resolvedColumnPrimeInclusionScanTimes],
		ColumnPrimeInclusionMassTolerance-> If[!NullQ[resolvedColumnPrimeInclusionMassTolerances], First@resolvedColumnPrimeInclusionMassTolerances],
		ColumnPrimeSurveyChargeStateExclusion-> If[!NullQ[resolvedColumnPrimeSurveyChargeStateExclusions], First@resolvedColumnPrimeSurveyChargeStateExclusions],
		ColumnPrimeSurveyIsotopeExclusion-> If[!NullQ[resolvedColumnPrimeSurveyIsotopeExclusions], First@resolvedColumnPrimeSurveyIsotopeExclusions],
		ColumnPrimeChargeStateExclusionLimit-> If[!NullQ[resolvedColumnPrimeChargeStateExclusionLimits], First@resolvedColumnPrimeChargeStateExclusionLimits],
		ColumnPrimeChargeStateExclusion-> If[!NullQ[resolvedColumnPrimeChargeStateExclusions], First@resolvedColumnPrimeChargeStateExclusions],
		ColumnPrimeChargeStateMassTolerance-> If[!NullQ[resolvedColumnPrimeChargeStateMassTolerances], First@resolvedColumnPrimeChargeStateMassTolerances],
		ColumnPrimeIsotopicExclusion-> If[!NullQ[resolvedColumnPrimeIsotopicExclusions], First@resolvedColumnPrimeIsotopicExclusions],
		ColumnPrimeIsotopeRatioThreshold-> If[!NullQ[resolvedColumnPrimeIsotopeRatioThresholds], First@resolvedColumnPrimeIsotopeRatioThresholds],
		ColumnPrimeIsotopeDetectionMinimum-> If[!NullQ[resolvedColumnPrimeIsotopeDetectionMinimums], First@resolvedColumnPrimeIsotopeDetectionMinimums],
		ColumnPrimeIsotopeMassTolerance-> If[!NullQ[resolvedColumnPrimeIsotopeMassTolerances], First@resolvedColumnPrimeIsotopeMassTolerances],
		ColumnPrimeIsotopeRatioTolerance-> If[!NullQ[resolvedColumnPrimeIsotopeRatioTolerances], First@resolvedColumnPrimeIsotopeRatioTolerances],
		ColumnPrimeDwellTime->If[!NullQ[resolvedColumnPrimeDwellTimes],First@resolvedColumnPrimeDwellTimes],
		ColumnPrimeCollisionCellExitVoltage->If[!NullQ[resolvedColumnPrimeCollisionCellExitVoltages],First@resolvedColumnPrimeCollisionCellExitVoltages],
		ColumnPrimeMassDetectionStepSize->If[!NullQ[resolvedColumnPrimeMassDetectionStepSizes],First@resolvedColumnPrimeMassDetectionStepSizes],
		ColumnPrimeMultipleReactionMonitoringAssays->If[!NullQ[resolvedColumnPrimeMultipleReactionMonitoringAssays],First@resolvedColumnPrimeMultipleReactionMonitoringAssays],
		ColumnPrimeNeutralLoss->If[!NullQ[resolvedColumnPrimeNeutralLosses],First@resolvedColumnPrimeNeutralLosses],

		(*need to de list if we have something*)
		ColumnFlushIonMode-> If[!NullQ[resolvedColumnFlushIonModes], First@resolvedColumnFlushIonModes],
		ColumnFlushMassSpectrometryMethod-> If[!NullQ[resolvedColumnFlushMassSpectrometryMethods], First@resolvedColumnFlushMassSpectrometryMethods],
		ColumnFlushESICapillaryVoltage-> If[!NullQ[resolvedColumnFlushESICapillaryVoltages], First@resolvedColumnFlushESICapillaryVoltages],
		ColumnFlushDeclusteringVoltage-> If[!NullQ[resolvedColumnFlushDeclusteringVoltages], First@resolvedColumnFlushDeclusteringVoltages],
		ColumnFlushStepwaveVoltage-> If[!NullQ[resolvedColumnFlushStepwaveVoltages], First@resolvedColumnFlushStepwaveVoltages],
		ColumnFlushIonGuideVoltage-> If[!NullQ[resolvedColumnFlushIonGuideVoltages], First@resolvedColumnFlushIonGuideVoltages],
		ColumnFlushSourceTemperature-> If[!NullQ[resolvedColumnFlushSourceTemperatures], First@resolvedColumnFlushSourceTemperatures],
		ColumnFlushDesolvationTemperature-> If[!NullQ[resolvedColumnFlushDesolvationTemperatures], First@resolvedColumnFlushDesolvationTemperatures],
		ColumnFlushDesolvationGasFlow-> If[!NullQ[resolvedColumnFlushDesolvationGasFlows], First@resolvedColumnFlushDesolvationGasFlows],
		ColumnFlushConeGasFlow-> If[!NullQ[resolvedColumnFlushConeGasFlows], First@resolvedColumnFlushConeGasFlows],
		ColumnFlushAcquisitionWindow-> If[!NullQ[resolvedColumnFlushAcquisitionWindows], First@resolvedColumnFlushAcquisitionWindows],
		ColumnFlushAcquisitionMode-> If[!NullQ[resolvedColumnFlushAcquisitionModes], First@resolvedColumnFlushAcquisitionModes],
		ColumnFlushFragment-> If[!NullQ[resolvedColumnFlushFragments], First@resolvedColumnFlushFragments],
		ColumnFlushMassDetection-> If[!NullQ[resolvedColumnFlushMassDetections], First@resolvedColumnFlushMassDetections],
		ColumnFlushScanTime-> If[!NullQ[resolvedColumnFlushScanTimes], First@resolvedColumnFlushScanTimes],
		ColumnFlushFragmentMassDetection-> If[!NullQ[resolvedColumnFlushFragmentMassDetections], First@resolvedColumnFlushFragmentMassDetections],
		ColumnFlushCollisionEnergy-> If[!NullQ[resolvedColumnFlushCollisionEnergies], First@resolvedColumnFlushCollisionEnergies],
		ColumnFlushCollisionEnergyMassProfile-> If[!NullQ[resolvedColumnFlushCollisionEnergyMassProfiles], First@resolvedColumnFlushCollisionEnergyMassProfiles],
		ColumnFlushCollisionEnergyMassScan-> If[!NullQ[resolvedColumnFlushCollisionEnergyMassScans], First@resolvedColumnFlushCollisionEnergyMassScans],
		ColumnFlushFragmentScanTime-> If[!NullQ[resolvedColumnFlushFragmentScanTimes], First@resolvedColumnFlushFragmentScanTimes],
		ColumnFlushAcquisitionSurvey-> If[!NullQ[resolvedColumnFlushAcquisitionSurveys], First@resolvedColumnFlushAcquisitionSurveys],
		ColumnFlushMinimumThreshold-> If[!NullQ[resolvedColumnFlushMinimumThresholds], First@resolvedColumnFlushMinimumThresholds],
		ColumnFlushAcquisitionLimit-> If[!NullQ[resolvedColumnFlushAcquisitionLimits], First@resolvedColumnFlushAcquisitionLimits],
		ColumnFlushCycleTimeLimit-> If[!NullQ[resolvedColumnFlushCycleTimeLimits], First@resolvedColumnFlushCycleTimeLimits],
		ColumnFlushExclusionDomain-> If[!NullQ[resolvedColumnFlushExclusionDomains], First@resolvedColumnFlushExclusionDomains],
		ColumnFlushExclusionMass-> If[!NullQ[resolvedColumnFlushExclusionMasses], First@resolvedColumnFlushExclusionMasses],
		ColumnFlushExclusionMassTolerance-> If[!NullQ[resolvedColumnFlushExclusionMassTolerances], First@resolvedColumnFlushExclusionMassTolerances],
		ColumnFlushExclusionRetentionTimeTolerance-> If[!NullQ[resolvedColumnFlushExclusionRetentionTimeTolerances], First@resolvedColumnFlushExclusionRetentionTimeTolerances],
		ColumnFlushInclusionDomain-> If[!NullQ[resolvedColumnFlushInclusionDomains], First@resolvedColumnFlushInclusionDomains],
		ColumnFlushInclusionMass-> If[!NullQ[resolvedColumnFlushInclusionMasses], First@resolvedColumnFlushInclusionMasses],
		ColumnFlushInclusionCollisionEnergy-> If[!NullQ[resolvedColumnFlushInclusionCollisionEnergies], First@resolvedColumnFlushInclusionCollisionEnergies],
		ColumnFlushInclusionDeclusteringVoltage-> If[!NullQ[resolvedColumnFlushInclusionDeclusteringVoltages], First@resolvedColumnFlushInclusionDeclusteringVoltages],
		ColumnFlushInclusionChargeState-> If[!NullQ[resolvedColumnFlushInclusionChargeStates], First@resolvedColumnFlushInclusionChargeStates],
		ColumnFlushInclusionScanTime-> If[!NullQ[resolvedColumnFlushInclusionScanTimes], First@resolvedColumnFlushInclusionScanTimes],
		ColumnFlushInclusionMassTolerance-> If[!NullQ[resolvedColumnFlushInclusionMassTolerances], First@resolvedColumnFlushInclusionMassTolerances],
		ColumnFlushSurveyChargeStateExclusion-> If[!NullQ[resolvedColumnFlushSurveyChargeStateExclusions], First@resolvedColumnFlushSurveyChargeStateExclusions],
		ColumnFlushSurveyIsotopeExclusion-> If[!NullQ[resolvedColumnFlushSurveyIsotopeExclusions], First@resolvedColumnFlushSurveyIsotopeExclusions],
		ColumnFlushChargeStateExclusionLimit-> If[!NullQ[resolvedColumnFlushChargeStateExclusionLimits], First@resolvedColumnFlushChargeStateExclusionLimits],
		ColumnFlushChargeStateExclusion-> If[!NullQ[resolvedColumnFlushChargeStateExclusions], First@resolvedColumnFlushChargeStateExclusions],
		ColumnFlushChargeStateMassTolerance-> If[!NullQ[resolvedColumnFlushChargeStateMassTolerances], First@resolvedColumnFlushChargeStateMassTolerances],
		ColumnFlushIsotopicExclusion-> If[!NullQ[resolvedColumnFlushIsotopicExclusions], First@resolvedColumnFlushIsotopicExclusions],
		ColumnFlushIsotopeRatioThreshold-> If[!NullQ[resolvedColumnFlushIsotopeRatioThresholds], First@resolvedColumnFlushIsotopeRatioThresholds],
		ColumnFlushIsotopeDetectionMinimum-> If[!NullQ[resolvedColumnFlushIsotopeDetectionMinimums], First@resolvedColumnFlushIsotopeDetectionMinimums],
		ColumnFlushIsotopeMassTolerance-> If[!NullQ[resolvedColumnFlushIsotopeMassTolerances], First@resolvedColumnFlushIsotopeMassTolerances],
		ColumnFlushIsotopeRatioTolerance-> If[!NullQ[resolvedColumnFlushIsotopeRatioTolerances], First@resolvedColumnFlushIsotopeRatioTolerances],
		ColumnFlushDwellTime->If[!NullQ[resolvedColumnFlushDwellTimes],First@resolvedColumnFlushDwellTimes],
		ColumnFlushCollisionCellExitVoltage->If[!NullQ[resolvedColumnFlushCollisionCellExitVoltages],First@resolvedColumnFlushCollisionCellExitVoltages],
		ColumnFlushMassDetectionStepSize->If[!NullQ[resolvedColumnFlushMassDetectionStepSizes],First@resolvedColumnFlushMassDetectionStepSizes],
		ColumnFlushMultipleReactionMonitoringAssays->If[!NullQ[resolvedColumnFlushMultipleReactionMonitoringAssays],First@resolvedColumnFlushMultipleReactionMonitoringAssays],
		ColumnFlushNeutralLoss->If[!NullQ[resolvedColumnFlushNeutralLosses],First@resolvedColumnFlushNeutralLosses]
	];

	invalidInputs=DeleteDuplicates[Flatten[{hplcInvalidInputs}]];

	invalidOptions=DeleteDuplicates[Flatten[{
		hplcInvalidOptions,
		unavailableMassSpecOptions,
		unavailableLCOptions,
		conflictingColumnFlushOptions,
		conflictingColumnPrimeOptions,
		fragmentModeConflictOptions,
		massDetectionConflictOptions,
		fragmentMassDetectionConflictOptions,
		collisionEnergyConflictOptions,
		collisionEnergyScanConflictOptions,
		fragmentScanTimeConflictOptions,
		acquisitionSurveyConflictOptions,
		acquisitionLimitConflictOptions,
		cycleTimeLimitConflictOptions,
		exclusionModeMassConflictOptions,
		exclusionModesVariedOptions,
		exclusionMassToleranceConflictOptions,
		exclusionRetentionTimeToleranceConflictOptions,
		inclusionOptionsConflictOptions,
		inclusionMassToleranceConflictOptions,
		chargeStateExclusionLimitConflictOptions,
		chargeStateExclusionConflictOptions,
		chargeStateMassToleranceConflictOptions,
		isotopicExclusionLimitOptions,
		isotopicExclusionConflictOptions,
		isotopeMassToleranceConflictOptions,
		isotopeRatioToleranceConflictOptions,
		overlappingAcquisitionWindowOptions,
		acquisitionWindowsTooLongOptions,
		dataIndependentNotAloneOptions,
		collisionEnergyProfileConflictOptions,
		conflictingMassAnalyzerAndInstrumentOptions,
		sourceTemperatureErrorOptions,
		invalidVoltagesErrorOptions,
		invalidGasFlowErrorOptions,
		invalidCollisionEnergyAcqModeOptions,
		invalidAcqMethodErrorOptions,
		invalidCollisionVoltagesErrorOptions,
		invalidLengthOfInputOptions,
		invalidScanTimesOptions,
		invalidParametersForSciExInstrumentOptions
	}]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs]>0&&!gatherTestsQ,
		Message[Error::InvalidInput,ObjectToString[invalidInputs,Simulation -> updatedSimulation]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions]>0&&!gatherTestsQ,
		Message[Error::InvalidOption,invalidOptions]
	];

	(*combine all of the tests*)
	allTests=DeleteCases[Flatten@{
		hplcTests,
		unavailableMassSpecTest,
		unavailableLCTest,
		nonSpecialRoundingTests,
		conflictingColumnFlushTest,
		conflictingColumnPrimeTest,
		fragmentModeConflictTests,
		massDetectionConflictTests,
		fragmentMassDetectionConflictTests,
		collisionEnergyConflictTests,
		collisionEnergyScanConflictTests,
		fragmentScanTimeConflictTests,
		acquisitionSurveyConflictTests,
		acquisitionLimitConflictTests,
		cycleTimeLimitConflictTests,
		exclusionModeMassConflictTests,
		exclusionMassToleranceConflictTests,
		exclusionRetentionTimeToleranceConflictTests,
		inclusionOptionsConflictTests,
		inclusionMassToleranceConflictTests,
		chargeStateExclusionLimitConflictTests,
		chargeStateExclusionConflictTests,
		chargeStateMassToleranceConflictTests,
		isotopicExclusionLimitTests,
		isotopicExclusionConflictTests,
		isotopeMassToleranceConflictTests,
		isotopeRatioToleranceConflictTests,
		overlappingAcquisitionWindowTests,
		repeatedDetectorOptionTest,
		dataIndependentNotAloneTests,
		collisionEnergyProfileConflictTests,
		acquisitionWindowsTooLongTests,
		exclusionModesVariedTests,
		conflictingMassAnalyzerAndInstrumentTest,
		souceTemperatureConflictTest,
		voltagesConflictTest,
		gasflowsConflictTest,
		acqModeMassAnalyzerConflictTest,
		collisionVoltagesConflictTest,
		memAssaysNotInSameLengthTest,
		invalidCollisionEnergyAcqModeTest,
		invalidScanTimeTests,
		invalidParametersForSciExInstrumentTests
	},Null];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions=resolvePostProcessingOptions[myOptions];

	(* Join all resolved options *)
	resolvedOptions = Normal@Join[
		roundedOptionsAssociation,
		relevantResolvedHPLCOptions,
		resolvedExperimentOptions,
		Association@resolvedPostProcessingOptions
	];

	(* Return our resolved options and/or tests. *)
	outputSpecification/.{
		Result -> resolvedOptions,
		Tests -> allTests
	}
];



(* ::Subsection:: *)
(* Resource Packets *)


(* ::Subsubsection:: *)
(* LCMSResourcePackets *)


DefineOptions[
	LCMSResourcePackets,
	Options:>{SimulationOption,OutputOption,CacheOption}
];

LCMSResourcePackets[mySamples:{ObjectP[Object[Sample]]..},myUnresolvedOptions:{_Rule...},myResolvedOptions:{_Rule...},ops:OptionsPattern[LCMSResourcePackets]]:=Module[
	{outputSpecification, output, gatherTestsQ, cache, protocolObjectID, protocolPacket, commonOptions,
		lcmsOptionsAssociation, hplcOptionAssociation, hplcOptionsAssociationWithInstrument,
		transposedInjectionTable, injectionTableOmitMSMethod, injectionTableWithColumns, resolvedColumnSelector, columnSelectorWithHPLCKeys, hplcOptionsWithInjectionTable,
		leftoverHPLCOptions, hplcAllOptions, hplcResourcePackets, hplcResourcePacketTests, hplcProtocolPacket,
		columnSelector,operatorResource, checkpoints, numberOfReplicates, gradientPackets, allPackets,
		separationTime, massSpectrometerResource, calibrant, calibrantResource, massAcquisitionRelatedOptions,
		standardMassAcquisitionRelatedOptions, blankMassAcquisitionRelatedOptions, columnPrimeMassAcquisitionRelatedOptions,
		columnFlushMassAcquisitionRelatedOptions, msInstrument, instrumentModelPacket, calibrantModel,
		formattedMinMasses, formattedMaxMasses, formattedMassSelections, transformedMassDetection,
		transformedFragmentMassDetection, formattedFragmentMinMasses, formattedFragmentMaxMasses, formattedFragmentMassSelections,
		sampleMassAcquisitionPackets, standardMassAcquisitionPackets, blankMassAcquisitionPackets, columnPrimeMassAcquisitionPacket,
		columnFlushMassAcquisitionPacket, minCollisionEnergy, maxCollisionEnergy, minScanCollisionEnergy, maxScanCollisionEnergy,
		packetWithIDRules, finalSampleMassAcquisitionPackets,formattedAcquisitionWindows,formattedExclusionDomains, listedWindow,
		combinedMassAcquisitionMethodPackets,massAcquisitionMethodKeys, massAcquisitionFieldDefinitions, fetchedMethodPacket,
		versionOneReformat, reformattedPacket,finalStandardMassAcquisitionPackets, finalBlankMassAcquisitionPackets,
		finalColumnPrimeMassAcquisitionPacket, finalColumnFlushMassAcquisitionPacket,finalCombinedMAPackets,
		maPacketsToUpload,sampleMAids, standardMAids, blankMAids, columnPrimeMAid, columnFlushMAid,
		samplePositions,standardPositions,blankPositions,columnPrimePositions,columnFlushPositions,
		hplcInjectionTable,sampleHPLCInjectionTableAssociations, standardHPLCInjectionTableAssociations,
		blankHPLCInjectionTableAssociations, columnPrimeHPLCInjectionTableAssociations, columnFlushHPLCInjectionTableAssociations,
		expandedSampleMAids, makeReverseAssociation, standardLookup, blankLookup, standardMappingAssociation, blankMappingAssociation,
		standardReverseAssociation, blankReverseAssociation,standardPositionsCorresponded, blankPositionsCorresponded,
		expandedStandardsMAids, expandedBlanksMAids, expandedColumnPrimeMAids, expandedColumnFlushMAids,
		updatedSampleInjectionTableAssociations, updatedStandardInjectionTableAssociations, updatedBlankInjectionTableAssociations,
		updatedColumnPrimeInjectionTableAssociations, updatedColumnFlushInjectionTableAssociations,
		injectionTableUploadable, noReplaceSampleMassAcquisitionPackets, noReplaceStandardMassAcquisitionPackets,
		noReplaceBlankMassAcquisitionPackets, noReplaceColumnPrimeMassAcquisitionPacket, noReplaceColumnFlushMassAcquisitionPacket,
		standardsQ,blanksQ,primeQ,flushQ,protocolPacketChunk1,protocolPacketChunk2,protocolPacketChunk3,
		protocolPacketChunk4,protocolPacketChunk5,protocolPacketChunk6, protoResolvedOptions, injectionTableLookup,
		sampleNoReplicatesPositions, standardNoReplicatesPositions, blankNoReplicatesPositions,methodComparisonBool,
		columnPrimeNoReplicatesPositions, columnFlushNoReplicatesPositions, methodReplacementRules,
		replacedInjectionTable, updatedResolvedOptions,bufferPlacements, allResources, resourcesFulfillableQ, resourceTests,
		sharedFieldPacket,columnPrimeToList, columnFlushToList, listifiedHPLCColumnOptionAssociation,
		formattedInclusionDomains,protoNoReplaceStandardMassAcquisitionPackets, protoNoReplaceBlankMassAcquisitionPackets,
		sampleMassAcquisitionPacketChangeBool, standardMassAcquisitionPacketChangeBool, blankMassAcquisitionPacketChangeBool,
		columnPrimeMassAcquisitionPacketChangeBool, columnFlushMassAcquisitionPacketChangeBool, messagesQ,
		sampleMassAcquisitionPacketChangeQ, standardMassAcquisitionPacketChangeQ, blankMassAcquisitionPacketChangeQ,
		columnPrimeMassAcquisitionPacketChangeQ, columnFlushMassAcquisitionPacketChangeQ, massAcquisitionPacketChangeQ,
		massAcquisitionPacketChangeTest, columnPrimeAbsorbanceSelectionLookup, columnFlushAbsorbanceSelectionLookup,
		columnPrimeAbsorbanceSelection, columnFlushAbsorbanceSelection, tripleQuadQ,secondCalibrant,secondCalibrantModel,
		secondCalibrantResource, calibrantSyringeResource, secondCalibrantSyringeResource, calibrantSyringeNeedleResource,
		secondCalibrantSyringeNeedleResource, calibrationTime, systemPrimeFlushPlateResource,allUnitOperationPacket,
		allPacketNoNull, allUnitOperationObjects, allUnitOperationTypes, allUnitOperationObjectsNested, allMassAcquisitionObjs,
		unitOperationLookup,positionUnitOperationLookup,massSpectrometryScansUpdate,cleanedInnerMultipleReactionMonitoringAssays,
		innerAcquisitionWindows,innerAcquisitionModes,innerFragmentations,innerMinMasses,innerMaxMasses,innerMassSelections,
		innerScanTimes,innerFragmentMinMasses,innerFragmentMaxMasses,innerFragmentMassSelections,innerCollisionEnergies,
		innerLowCollisionEnergies,innerHighCollisionEnergies,innerFinalLowCollisionEnergies,innerFinalHighCollisionEnergies,
		innerFragmentScanTimes,innerAcquisitionSurveys,innerMinimumThresholds,innerAcquisitionLimits,innerCycleTimeLimits,
		innerExclusionDomains,innerExclusionMasses,innerExclusionMassTolerances,innerExclusionRetentionTimeTolerances,
		innerInclusionDomains,innerInclusionMasses,innerInclusionCollisionEnergies,innerInclusionDeclusteringVoltages,
		innerInclusionChargeStates,innerInclusionScanTimes,innerInclusionMassTolerances,innerChargeStateLimits,
		innerChargeStateSelections,innerChargeStateMassTolerances,innerIsotopeMassDifferences,innerIsotopeRatios,
		innerIsotopeDetectionMinimums,innerIsotopeRatioTolerances,innerIsotopeMassTolerances,innerCollisionCellExitVoltages,
		innerMassDetectionStepSizes,innerNeutralLosses,innerDwellTimes,innerMultipleReactionMonitoringAssays,
		multipleReactionMonitoringAssayPackets,formattedCollisionEnergy, sampleToResourceRules, simulation,
		hplcCorrectedleftoverOptions, hplcAllOptionsRaw, gradientOptions, gradientCorrectionRules, expandedResolvedOptions,
		calibrantPrimeBufferResource,calibrantPrimeInfusionSyringeResource,calibrantPrimeInfusionSyringeNeedleResource,
		calibrantFlushBufferResource,calibrantFlushInfusionSyringeResource,calibrantFlushInfusionSyringeNeedleResource
	},

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTestsQ = MemberQ[output,Tests];

	(* Determine if we should throw messages *)
	messagesQ = !gatherTestsQ;

	(* Fetch passed cache *)
	cache = Lookup[ToList[ops], Cache, {}];
	simulation = Lookup[ToList[ops], Simulation, Simulation[]];

	(*put the options into an association format*)
	(* If there is only one acquisition window the following call will over-expand MultipleReactionMonitoringAssays *)
	expandedResolvedOptions = Last[ExpandIndexMatchedInputs[ExperimentLCMS, {mySamples}, myResolvedOptions]];
	lcmsOptionsAssociation = Association @ expandedResolvedOptions;

	(*get the common options between hplc and lcms*)
	commonOptions=ToExpression/@Intersection["OptionName"/.OptionDefinition[ExperimentHPLC],"OptionName"/.OptionDefinition[ExperimentLCMS]];

	(*get the options wanted from the LCMS resolution*)
	hplcOptionAssociation=KeyTake[lcmsOptionsAssociation,commonOptions];

	(*include the chromatography instrument but it's named differently*)
	hplcOptionsAssociationWithInstrument=Join[hplcOptionAssociation, <|Instrument -> Lookup[lcmsOptionsAssociation, ChromatographyInstrument]|>];

	(*we'll want to wrap a list around all of the relevant column options*)
	(*define the other options that need to made single*)
	columnPrimeToList={ColumnPrimeGradientA,ColumnPrimeGradientB,ColumnPrimeGradientC,ColumnPrimeGradientD, ColumnPrimeFlowRate,ColumnPrimeGradient, ColumnPrimeTemperature, ColumnPrimeAbsorbanceWavelength,ColumnPrimeWavelengthResolution, ColumnPrimeUVFilter,ColumnPrimeAbsorbanceSamplingRate
	};
	columnFlushToList={ColumnFlushGradientA,ColumnFlushGradientB,ColumnFlushGradientC,ColumnFlushGradientD, ColumnFlushFlowRate,ColumnFlushGradient, ColumnFlushTemperature, ColumnFlushAbsorbanceWavelength,ColumnFlushWavelengthResolution, ColumnFlushUVFilter,ColumnFlushAbsorbanceSamplingRate
	};

	listifiedHPLCColumnOptionAssociation=Association@KeyValueMap[
		Function[{key,value},
			If[!NullQ[value],
				key->List[value],
				key->value
			]
		],
		KeyTake[lcmsOptionsAssociation,Join[columnPrimeToList, columnFlushToList]]
	];

	(*the injection table is different in LCMS versus HPLC and needs to be reformatted accordingly if specified*)
	(*LCMS injection table has a column for the mass spec method. obvious we want to take that out*)
	(*HPLC has a column for the Column of each sample. We'll want to just fill in first column there*)

	transposedInjectionTable=Transpose[Lookup[lcmsOptionsAssociation,InjectionTable]];

	(*we don't need the last row (the Mass method)*)
	injectionTableOmitMSMethod=Most[transposedInjectionTable];

	(*we add a row of the column positions. it's the third from the last*)
	injectionTableWithColumns=Insert[injectionTableOmitMSMethod,ConstantArray[PositionA,Length[First@transposedInjectionTable]],-3];

	(* The ColumnSelector is different in LCMS versus HPLC and needs to be reformatted accordingly if specified *)
	resolvedColumnSelector=Lookup[lcmsOptionsAssociation, ColumnSelector];

	(* Insert ColumnPosition, GuardColumnOrientation and ColumnOrientation  *)
	columnSelectorWithHPLCKeys={
		PositionA,
		resolvedColumnSelector[[1]],
		Forward,
		resolvedColumnSelector[[2]],
		Forward,
		resolvedColumnSelector[[3]],
		resolvedColumnSelector[[4]]
	};

	(*now add this injection table to our options*)
	(*we also need to add the column selector with some extra listyness*)
	hplcOptionsWithInjectionTable=Join[hplcOptionsAssociationWithInstrument,
		listifiedHPLCColumnOptionAssociation,
		<|
			InjectionTable -> Transpose[injectionTableWithColumns],
			ColumnSelector -> List[columnSelectorWithHPLCKeys]
		|>
	];

	(*Null out any HPLC options that we didn't resolve*)
	leftoverHPLCOptions=Select[
		MapAt[ToExpression,Options[ExperimentHPLC],{All,1}],
		!MemberQ[Keys@hplcOptionsWithInjectionTable,First@#]&
	]/.{Automatic->Null};

	(* Some of the HPLC options cannot be Null, so here we need to correct them *)
	hplcCorrectedleftoverOptions = ReplaceRule[leftoverHPLCOptions,
		{
			Scale -> SemiPreparative,
			ColumnSelection -> False,
			ColumnPosition -> ConstantArray[PositionA, Length[mySamples]],
			CollectFractions -> False
		}
	];

	(*combine everything in order to pass to the HPLC resource packets function*)
	hplcAllOptionsRaw=Normal@Join[Association@hplcCorrectedleftoverOptions,hplcOptionsWithInjectionTable];

	(* We also need to correct the Gradient options. In HPLC Gradient, ColumnPrimeGradient and ColumnFlushGradient it has an extra entry of "Differential Refractive Index Reference Loading" *)
	gradientOptions = {Gradient, ColumnPrimeGradient, ColumnFlushGradient, BlankGradient, StandardGradient};

	gradientCorrectionRules = Map[
		Function[{optionName},
			Module[{optionValue, correctedOptionValue},
				optionValue = Lookup[hplcAllOptionsRaw, optionName];
				(* If the gradient takes the form of List of List, append a None in each inner-inner list *)
				correctedOptionValue = If[MatchQ[optionValue, {{_List..}..}],
					Map[
						Function[{eachGradient},
							Append[#, None]& /@ eachGradient
						],
						optionValue
					],
					optionValue
				];
				optionName -> correctedOptionValue
			]
		],
		gradientOptions
	];

	hplcAllOptions = ReplaceRule[hplcAllOptionsRaw, gradientCorrectionRules];

	(*call the HPLC resource packets function*)
	(*we don't care about the unresolved options so just pass whatever*)
	{hplcResourcePackets,hplcResourcePacketTests} = If[gatherTestsQ,
		HPLCResourcePacketsNew[mySamples,MapAt[ToExpression,Options[ExperimentHPLC],{All,1}],hplcAllOptions,Cache->cache,Simulation->simulation,Output->{Result,Tests},InternalUsage->True],
		{HPLCResourcePacketsNew[mySamples,MapAt[ToExpression,Options[ExperimentHPLC],{All,1}],hplcAllOptions,Cache->cache,Simulation->simulation,InternalUsage->True],{}}
	];

	(*extract out the hplc protocol packet*)
	hplcProtocolPacket=FirstCase[hplcResourcePackets,ObjectP[Object[Protocol,HPLC]]];

	(*get the column selector, as we'll use it to fill in many things*)
	(*we'll take the first since it'll be listed otherwise*)
	columnSelector=First@KeyDrop[Lookup[hplcProtocolPacket,Replace[ColumnSelectorAssembly]], {ColumnPosition,GuardColumnOrientation,ColumnOrientation}];

	(*get the separation time*)
	separationTime=Lookup[hplcProtocolPacket,SeparationTime];

	(*lookup the mass spec instrument*)
	msInstrument=Lookup[myResolvedOptions,MassSpectrometerInstrument];

	(*we need the resource for the mass spectrometer instrument*)
	massSpectrometerResource= Resource[
		Instrument -> msInstrument,
		Time -> separationTime,
		Name -> "Mass Spectrometer"
	];

	(*get the model packet for the instrument*)
	instrumentModelPacket = If[MatchQ[msInstrument,ObjectP[Model]],
		fetchPacketFromCache[Download[msInstrument,Object],cache],
		fetchModelPacketFromCacheHPLC[msInstrument,cache]
	];

	(*Build a checker for qqq as the mass analyzer*)
	tripleQuadQ=MatchQ[Lookup[lcmsOptionsAssociation,MassAnalyzer],TripleQuadrupole];
	
	(*need the resource for the calibrant*)

	(* Get objects in options *)
	{calibrant,secondCalibrant}=Download[Lookup[lcmsOptionsAssociation,{Calibrant,SecondCalibrant}],Object];

	(*make our calibrant resource*)
	calibrantResource=If[tripleQuadQ,
		Resource[
			Sample->calibrant,
			Amount->1 Milliliter,
			Name->CreateUUID[]
		],
		Resource[
			Sample->calibrant,
			Amount->15 Milliliter,
			Container->Model[Container,Vessel, "id:1ZA60vLx3RB5"] (*"Narrow Mouth Plastic Reservoir Bottle, 30mL, for Xevo G2-XS QTOF"*)
		]
	];
	
	secondCalibrantResource=If[tripleQuadQ&&MatchQ[secondCalibrant,ObjectP[]],
		Resource[
			Sample->secondCalibrant,
			Amount->1 Milliliter,
			Name->CreateUUID[]
		],
		Null
	];

	{
		calibrantSyringeResource,
		secondCalibrantSyringeResource,
		calibrantSyringeNeedleResource,
		secondCalibrantSyringeNeedleResource
	}=If[tripleQuadQ,
		{
			Resource[Sample->Model[Container, Syringe, "id:o1k9jAKOww7A"](*1mL All-Plastic Disposable Syringe*),Name->CreateUUID[]],
			If[
				MatchQ[secondCalibrant,ObjectP[]],
				Resource[Sample->Model[Container, Syringe, "id:o1k9jAKOww7A"](*1mL All-Plastic Disposable Syringe*),Name->CreateUUID[]],
				Null
			],
			Resource[Sample->Model[Item, Needle, "id:P5ZnEj4P88YE"](*21g x 1 Inch Single-Use Needle*),Name->CreateUUID[]],
			If[
				MatchQ[secondCalibrant,ObjectP[]],
				Resource[Sample->Model[Item, Needle, "id:P5ZnEj4P88YE"](*21g x 1 Inch Single-Use Needle*),Name->CreateUUID[]],
				Null
			]
		},
		{Null,Null,Null,Null}
	];

	(* Create resource for calibrant prime/flush *)
	(* Prime *)
	calibrantPrimeBufferResource = Resource[Sample -> Model[Sample, StockSolution, "id:7X104v6zO6X9"](*1:1 LCMS-Grade Methanol/Milli-Q Water*), Amount -> 3 Milliliter, Container -> Model[Container, Vessel, "id:9RdZXvKBeeqL"](*20mL Glass Scintillation Vial*), Name -> "Pre-Calibration Prime Buffer"];
	calibrantPrimeInfusionSyringeResource = Resource[Sample -> Model[Container, Syringe, "id:o1k9jAKOww7A"](*1mL All-Plastic Disposable Syringe*), Name -> "Pre-Calibration Prime Syringe"];
	calibrantPrimeInfusionSyringeNeedleResource = Resource[Sample -> Model[Item, Needle, "id:P5ZnEj4P88YE"](*21g x 1 Inch Single-Use Needle*), Name -> "Pre-Calibration Prime Syringe Needle"];
	(* Flush *)
	calibrantFlushBufferResource = Resource[Sample -> Model[Sample, StockSolution, "id:7X104v6zO6X9"](*1:1 LCMS-Grade Methanol/Milli-Q Water*), Amount -> 3 Milliliter, Container -> Model[Container, Vessel, "id:9RdZXvKBeeqL"](*20mL Glass Scintillation Vial*), Name -> "Post-Calibration Flush Buffer"];
	calibrantFlushInfusionSyringeResource = Resource[Sample -> Model[Container, Syringe, "id:o1k9jAKOww7A"](*1mL All-Plastic Disposable Syringe*), Name -> "Post-Calibration Flush Syringe"];
	calibrantFlushInfusionSyringeNeedleResource = Resource[Sample -> Model[Item, Needle, "id:P5ZnEj4P88YE"](*21g x 1 Inch Single-Use Needle*), Name -> "Post-Calibration Flush Syringe Needle"];


	(*get the calibrant model if need be*)
	calibrantModel=If[MatchQ[calibrant,ObjectP[Model]],
		calibrant,
		Lookup[fetchModelPacketFromCacheHPLC[calibrant,cache],Model]
	];
	
	(* get the second calibrant model *)
	secondCalibrantModel=Which[
		MatchQ[secondCalibrant,ObjectP[Model]], secondCalibrant,
		MatchQ[secondCalibrant,ObjectP[]],Lookup[fetchModelPacketFromCacheHPLC[secondCalibrant,cache],Model],
		True,Null
	];
	
	(* for esi qqq as the mass analyer, grab an empty plate to be put inside the auto sampler for system/column cleaning *)
	systemPrimeFlushPlateResource = Resource[
		Sample -> Model[Container, Plate,"96-well 2mL Deep Well Plate"],
		Name -> CreateUUID[]
	];
	
	
	(*define all of the mass spec options that we'll want to generate our mass acquisition packet*)
	massAcquisitionRelatedOptions={
		(*1*)IonMode,
		(*2*)ESICapillaryVoltage,
		(*3*)DeclusteringVoltage,
		(*4*)StepwaveVoltage,
		(*5*)IonGuideVoltage,
		(*6*)SourceTemperature,
		(*7*)DesolvationTemperature,
		(*8*)DesolvationGasFlow,
		(*9*)ConeGasFlow,
		(*10*)AcquisitionWindow,
		(*11*)AcquisitionMode,
		(*12*)Fragment,
		(*13*)MassDetection,
		(*14*)ScanTime,
		(*15*)FragmentMassDetection,
		(*16*)CollisionEnergy,
		(*17*)DwellTime,
		(*18*)CollisionCellExitVoltage,
		(*19*)MassDetectionStepSize,
		(*20*)NeutralLoss,
		(*21*)MultipleReactionMonitoringAssays,
		(*22*)CollisionEnergyMassProfile,
		(*23*)CollisionEnergyMassScan,
		(*24*)FragmentScanTime,
		(*25*)AcquisitionSurvey,
		(*26*)MinimumThreshold,
		(*27*)AcquisitionLimit,
		(*28*)CycleTimeLimit,
		(*29*)ExclusionDomain,
		(*30*)ExclusionMass,
		(*31*)ExclusionMassTolerance,
		(*32*)ExclusionRetentionTimeTolerance,
		(*33*)InclusionDomain,
		(*34*)InclusionMass,
		(*35*)InclusionCollisionEnergy,
		(*36*)InclusionDeclusteringVoltage,
		(*37*)InclusionChargeState,
		(*38*)InclusionScanTime,
		(*39*)InclusionMassTolerance,
		(*40*)ChargeStateExclusionLimit,
		(*41*)ChargeStateExclusion,
		(*42*)ChargeStateMassTolerance,
		(*43*)IsotopicExclusion,
		(*44*)IsotopeRatioThreshold,
		(*45*)IsotopeDetectionMinimum,
		(*46*)IsotopeMassTolerance,
		(*47*)IsotopeRatioTolerance
	};

	(*make the standard, blank, column prime, and column flush version of these options*)
	standardMassAcquisitionRelatedOptions=Map[ToExpression,("Standard"<>ToString[#]&)/@massAcquisitionRelatedOptions];
	blankMassAcquisitionRelatedOptions=Map[ToExpression,("Blank"<>ToString[#]&)/@massAcquisitionRelatedOptions];
	columnPrimeMassAcquisitionRelatedOptions=Map[ToExpression,("ColumnPrime"<>ToString[#]&)/@massAcquisitionRelatedOptions];
	columnFlushMassAcquisitionRelatedOptions=Map[ToExpression,("ColumnFlush"<>ToString[#]&)/@massAcquisitionRelatedOptions];

	(*==================================================*)
	(* Build a new mass acquisition method upload packet*)
	(*==================================================*)
	(*we map through and make our packets*)
	(*we presume that the options are fully expanded at this point*)
	{
		sampleMassAcquisitionPackets,
		standardMassAcquisitionPackets,
		blankMassAcquisitionPackets,
		{columnPrimeMassAcquisitionPacket},
		{columnFlushMassAcquisitionPacket}
	}=Map[Function[{optionValueSet},
			(*first check if this exists, e.g. no blanks*)
			If[MatchQ[optionValueSet,{(Null|{}|{Null})..}],
				(*in which case we return a list with a Null*)
				{Null},
				(*otherwise we have to map through the options -- this is assuming that they've already been expanded*)
				MapThread[
					Function[{
						(*1*)ionMode,
						(*2*)esiCapillaryVoltage,
						(*3*)declusteringVoltage,
						(*4*)stepwaveVoltage,
						(*5*)ionGuideVoltage,
						(*6*)sourceTemperature,
						(*7*)desolvationTemperature,
						(*8*)desolvationGasFlow,
						(*9*)coneGasFlow,
						(*10*)acquisitionWindow,
						(*11*)acquisitionMode,
						(*12*)fragment,
						(*13*)massDetection,
						(*14*)scanTime,
						(*15*)fragmentMassDetection,
						(*16*)collisionEnergy,
						(*17*)dwellTime,
						(*18*)collisionCellExitVoltage,
						(*19*)massDetectionStepSize,
						(*20*)neutralLoss,
						(*21*)multipleReactionMonitoringAssays,
						(*22*)collisionEnergyMassProfile,
						(*23*)collisionEnergyMassScan,
						(*24*)fragmentScanTime,
						(*25*)acquisitionSurvey,
						(*26*)minimumThreshold,
						(*27*)acquisitionLimit,
						(*28*)cycleTimeLimit,
						(*29*)exclusionDomain,
						(*30*)exclusionMass,
						(*31*)exclusionMassTolerance,
						(*32*)exclusionRetentionTimeTolerance,
						(*33*)inclusionDomain,
						(*34*)inclusionMass,
						(*35*)inclusionCollisionEnergy,
						(*36*)inclusionDeclusteringVoltage,
						(*37*)inclusionChargeState,
						(*38*)inclusionScanTime,
						(*39*)inclusionMassTolerance,
						(*40*)chargeStateExclusionLimit,
						(*41*)chargeStateExclusion,
						(*42*)chargeStateMassTolerance,
						(*43*)isotopicExclusion,
						(*44*)isotopeRatioThreshold,
						(*45*)isotopeDetectionMinimum,
						(*46*)isotopeMassTolerance,
						(*47*)isotopeRatioTolerance
					},

						(*we'll want to make our min and max ranges from the mass selection value*)
						transformedMassDetection = Map[
							Function[{currentMassDetection}, Switch[currentMassDetection,
								(*we need to break out all of the spans*)
								MSAnalyteGroupP,Append[massRangeAnalyteType[currentMassDetection]/.Span[x_, y_] :> {x, y},Null],
								_Span,Append[currentMassDetection/.Span[x_, y_] :> {x, y},Null],
								(*otherwise, we have specific masses and we want to pull those out*)
								_,{Null,Null,ToList[currentMassDetection]}
							]],
							massDetection
						];

						(*now we extract the reformated values*)
						(* MassDetection should have been reformatted accordingly *)
						formattedMinMasses=transformedMassDetection/.{{x:Null|UnitsP[Gram/Mole],Null|UnitsP[Gram/Mole],Null|_List}:>x};
						formattedMaxMasses=transformedMassDetection/.{{Null|UnitsP[Gram/Mole],x:Null|UnitsP[Gram/Mole],Null|_List}:>x};
						formattedMassSelections=transformedMassDetection/.{{Null|UnitsP[Gram/Mole],Null|UnitsP[Gram/Mole],x:Null|_List}:>x};

						(*do the same with the fragment mass detection*)
						transformedFragmentMassDetection = Map[
							Function[{currentFragmentMassDetection}, Switch[currentFragmentMassDetection,
								Null,{Null,Null,Null},
								(*we need to break out all of the spans*)
								All|{All},{20 Gram/Mole, 16000 Gram/Mole, Null},
								_Span,Append[currentFragmentMassDetection/.Span[x_, y_] :> {x, y},Null],
								(*otherwise, we have specific masses and we want to pull those out*)
								_,{Null,Null,ToList[currentFragmentMassDetection]}
							]],
							fragmentMassDetection
						];

						(*now we extract the reformated values*)
						(* MassDetection should have been reformatted accordingly *)
						formattedFragmentMinMasses=transformedFragmentMassDetection/.{{x:Null|UnitsP[Gram/Mole],Null|UnitsP[Gram/Mole],Null|_List}:>x};
						formattedFragmentMaxMasses=transformedFragmentMassDetection/.{{Null|UnitsP[Gram/Mole],x:Null|UnitsP[Gram/Mole],Null|_List}:>x};
						formattedFragmentMassSelections=transformedFragmentMassDetection/.{{Null|UnitsP[Gram/Mole],Null|UnitsP[Gram/Mole],x:Null|_List}:>x};

						(*now format the collision energies*)

						{minCollisionEnergy,maxCollisionEnergy} = Transpose@Map[
							Function[{currentCollisionEnergyMassProfile}, Switch[currentCollisionEnergyMassProfile,
								Null,{Null,Null},
								_Span,currentCollisionEnergyMassProfile/.Span[x_, y_] :> {x, y}
							]],
							collisionEnergyMassProfile
						];

						{minScanCollisionEnergy,maxScanCollisionEnergy} = Transpose@Map[
							Function[{currentCollisionEnergyMassScan}, Switch[currentCollisionEnergyMassScan,
								Null,{Null,Null},
								(*if a span split it*)
								_Span,currentCollisionEnergyMassScan/.Span[x_, y_] :> {x, y},
								(*otherwise replicate*)
								_,{currentCollisionEnergyMassScan,currentCollisionEnergyMassScan}
							]],
							collisionEnergyMassScan
						];

						(*format the acquisition windows to be named multiples*)
						formattedAcquisitionWindows=Map[
							( #/.Span[x_, y_] :> Association[StartTime->x,EndTime->y] )&,
							acquisitionWindow
						];

						(*format any exclusion domains as needed -- we replace out any Fulls or spans*)
						formattedExclusionDomains=If[!NullQ[exclusionDomain],
							MapThread[
								Function[{eachWindow,eachDomain},
									listedWindow={StartTime,EndTime}/.eachWindow;
									eachDomain/.{Full->listedWindow,Span[x_,y_]:>{x,y}}
								],
								{
									formattedAcquisitionWindows,
									exclusionDomain
								}
							],
							ConstantArray[Null,Length@acquisitionWindow]
						];

						formattedInclusionDomains=If[!NullQ[inclusionDomain],
							MapThread[
								Function[{eachWindow,eachDomain},
									listedWindow={StartTime,EndTime}/.eachWindow;
									eachDomain/.{Full->listedWindow,Span[x_,y_]:>{x,y}}
								],
								{
									formattedAcquisitionWindows,
									inclusionDomain
								}
							],
							ConstantArray[Null,Length@acquisitionWindow]
						];

						(*Transform MultipleReacitonMonitoringAssays to a association*)

						(* If we expanded a singleton Null to match acquisition windows just make Null associations. *)
						multipleReactionMonitoringAssayPackets=If[NullQ[multipleReactionMonitoringAssays],
							ConstantArray[<|MS1Mass ->Null,
								CollisionEnergy -> Null,
								MS2Mass -> Null,
								DwellTime -> Null
							|>, Length[multipleReactionMonitoringAssays]],
							(* Otherwise Map *)
							(* Note: For Map at level spec 2 we need to Flatten *)
							Flatten@Map[
							Function[{eachMRMAssay},
								If[
									NullQ[eachMRMAssay],
									<|MS1Mass ->Null,
										CollisionEnergy -> Null,
										MS2Mass -> Null,
										DwellTime -> Null
									|>,
									Module[{transposedMRM},
										transposedMRM = Transpose[
											If[
												MatchQ[eachMRMAssay,{{{__} ..}}],
												Flatten[eachMRMAssay,1],
												eachMRMAssay
											]
										];
										<|MS1Mass -> transposedMRM[[1]],
											CollisionEnergy -> transposedMRM[[2]],
											MS2Mass -> transposedMRM[[3]],
											DwellTime -> transposedMRM[[4]]
										|>
									]
								]
							],

							multipleReactionMonitoringAssays,
							(* If we have multiple acquisition windows multipleReactionMonitoringAssays will be one list level deeper. *)
							If[Length[formattedAcquisitionWindows] > 1, {2}, {1}]
						]];

						(* Format CollisionEnergy to avoid this parapmeter is wrongly expanded *)
						formattedCollisionEnergy=If[
							Length[formattedAcquisitionWindows]!=Length[collisionEnergy],
							Take[collisionEnergy,Length[formattedAcquisitionWindows]],
							collisionEnergy
						];
						
						(*make our packet here*)
						Association[
							Type->Object[Method,MassAcquisition],
							MassAnalyzer->Lookup[lcmsOptionsAssociation,MassAnalyzer],
							IonSource->First@Lookup[instrumentModelPacket,IonSources],
							ESICapillaryVoltage->esiCapillaryVoltage,
							DesolvationTemperature->desolvationTemperature,
							DesolvationGasFlow->desolvationGasFlow,
							SourceTemperature->sourceTemperature,
							DeclusteringVoltage->declusteringVoltage,
							ConeGasFlow->coneGasFlow,
							StepwaveVoltage->stepwaveVoltage,
							IonGuideVoltage->FirstOrDefault[ionGuideVoltage,ionGuideVoltage],
							IonMode->ionMode,
							Calibrant->Link@calibrantModel,
							SecondCalibrant->Link[secondCalibrantModel],

							Replace[AcquisitionWindows]->formattedAcquisitionWindows,
							Replace[AcquisitionModes]->acquisitionMode,
							Replace[Fragmentations]->fragment,
							Replace[MinMasses]->formattedMinMasses,
							Replace[MaxMasses]->formattedMaxMasses,
							Replace[MassSelections]->formattedMassSelections,
							Replace[ScanTimes]->scanTime,
							Replace[FragmentMinMasses]->formattedFragmentMinMasses,
							Replace[FragmentMaxMasses]->formattedFragmentMaxMasses,
							Replace[FragmentMassSelections]->formattedFragmentMassSelections,
							Replace[CollisionEnergies]->formattedCollisionEnergy,
							Replace[DwellTimes]->dwellTime,
							Replace[CollisionCellExitVoltages]->collisionCellExitVoltage,
							Replace[MassDetectionStepSizes]->massDetectionStepSize,
							Replace[NeutralLosses]->neutralLoss,
							Replace[MultipleReactionMonitoringAssays]->multipleReactionMonitoringAssayPackets,
							Replace[LowCollisionEnergies]->minCollisionEnergy,
							Replace[HighCollisionEnergies]->maxCollisionEnergy,
							Replace[FinalLowCollisionEnergies]->minScanCollisionEnergy,
							Replace[FinalHighCollisionEnergies]->maxScanCollisionEnergy,
							Replace[FragmentScanTimes]->fragmentScanTime,
							Replace[AcquisitionSurveys]->acquisitionSurvey,
							Replace[MinimumThresholds]->minimumThreshold,
							Replace[AcquisitionLimits]->acquisitionLimit,
							Replace[CycleTimeLimits]->cycleTimeLimit,
							Replace[ExclusionDomains]->formattedExclusionDomains,
							Replace[ExclusionMasses]->exclusionMass,
							Replace[ExclusionMassTolerances]->exclusionMassTolerance,
							Replace[ExclusionRetentionTimeTolerances]->exclusionRetentionTimeTolerance,
							Replace[InclusionDomains]->formattedInclusionDomains,
							Replace[InclusionMasses]->inclusionMass,
							Replace[InclusionCollisionEnergies]->inclusionCollisionEnergy,
							Replace[InclusionDeclusteringVoltages]->inclusionDeclusteringVoltage,
							Replace[InclusionChargeStates]->inclusionChargeState,
							Replace[InclusionScanTimes]->inclusionScanTime,
							Replace[InclusionMassTolerances]->inclusionMassTolerance,
							Replace[ChargeStateLimits]->chargeStateExclusionLimit,
							Replace[ChargeStateSelections]->chargeStateExclusion,
							Replace[ChargeStateMassTolerances]->chargeStateMassTolerance,
							Replace[IsotopeMassDifferences]->isotopicExclusion,
							Replace[IsotopeRatios]->isotopeRatioThreshold,
							Replace[IsotopeDetectionMinimums]->isotopeDetectionMinimum,
							Replace[IsotopeRatioTolerances]->isotopeRatioTolerance,
							Replace[IsotopeMassTolerances]->isotopeMassTolerance
						]

					],
					optionValueSet
				]
			]
		],
		{
			Lookup[lcmsOptionsAssociation,massAcquisitionRelatedOptions],
			Lookup[lcmsOptionsAssociation,standardMassAcquisitionRelatedOptions],
			Lookup[lcmsOptionsAssociation,blankMassAcquisitionRelatedOptions],
			List/@Lookup[lcmsOptionsAssociation,columnPrimeMassAcquisitionRelatedOptions],
			List/@Lookup[lcmsOptionsAssociation,columnFlushMassAcquisitionRelatedOptions]
		}
	];

	(*combine all of our ms method packets so that we can dole out object ids*)
	combinedMassAcquisitionMethodPackets=Cases[DeleteDuplicates@Flatten[{
		sampleMassAcquisitionPackets,
		standardMassAcquisitionPackets,
		blankMassAcquisitionPackets,
		{columnPrimeMassAcquisitionPacket},
		{columnFlushMassAcquisitionPacket}
	}],Except[Null]];

	(*make a list of rules for the packet with the id*)
	packetWithIDRules=Map[Rule[#,Join[<|Object -> CreateID[Object[Method, MassAcquisition]]|>,#]]&,combinedMassAcquisitionMethodPackets];

	(*define the keys that we'll want to use to compare the packet to the downloaded one. we ignore the calibrant key*)
	massAcquisitionMethodKeys=Complement[Keys[First@combinedMassAcquisitionMethodPackets]/.{Replace[x_]:>x},
		{Calibrant,CycleTimeLimits}
	];

	massAcquisitionFieldDefinitions=ECL`Fields/.LookupTypeDefinition[Object[Method,MassAcquisition]];

	(*now we map through get our final packets for each*)
	(*we note if the packets are changing*)
	{
		{finalSampleMassAcquisitionPackets,sampleMassAcquisitionPacketChangeBool},
		{finalStandardMassAcquisitionPackets,standardMassAcquisitionPacketChangeBool},
		{finalBlankMassAcquisitionPackets,blankMassAcquisitionPacketChangeBool},
		{{finalColumnPrimeMassAcquisitionPacket},columnPrimeMassAcquisitionPacketChangeBool},
		{{finalColumnFlushMassAcquisitionPacket},columnFlushMassAcquisitionPacketChangeBool}
	}=MapThread[Function[{methodSet,packetSet,index},
		If[!MatchQ[packetSet,Null|{Null}|{}],
			Transpose@MapThread[Function[{massAcquisitionOption,assembledPacket},
				(*if it's new, we use the new packet*)
				If[MatchQ[massAcquisitionOption,New],
					{assembledPacket/.packetWithIDRules,False},
					(*if the user had supplied an ID, the job is trickier: we do not want to use if if the options changed. so we do some logic*)
					(
						(*first grab the method packet from the cache*)
						fetchedMethodPacket=fetchPacketFromCache[Download[massAcquisitionOption,Object],cache];
						(*we then have to reformat it taking only the keys that we want*)
						versionOneReformat=KeyTake[fetchedMethodPacket,massAcquisitionMethodKeys]/.{x_Link:>Link[x]};
						(*we then have to replace all of the multiple keys with a replace head*)
						reformattedPacket=Association@KeyValueMap[
							Function[{fieldName,fieldValue},
								If[MatchQ[Lookup[Lookup[massAcquisitionFieldDefinitions,fieldName],Format],Multiple],
									Replace[fieldName]->fieldValue,
									fieldName->fieldValue
								]
							],
							versionOneReformat
						];
						(*create a boolean list where we map through to see what's different and what's the same*)
						(*we want to take a look at both the replaced and non-replaced versions*)
						methodComparisonBool=Map[
							If[MemberQ[ToList@Lookup[assembledPacket,#],UnitsP[],Infinity],
								(*some of these values are quantities*)
								Lookup[assembledPacket,#]==Lookup[reformattedPacket,#],
								MatchQ[Lookup[assembledPacket,#],Lookup[reformattedPacket,#]]
							]&,
							Join[massAcquisitionMethodKeys,Replace/@massAcquisitionMethodKeys]
						];

						(*now we check if the packets are equivalent*)
						If[And@@methodComparisonBool,
							(*in which case we stick with the packet that was given to us*)
							{fetchedMethodPacket, False},
							(*otherwise, we go with the new packet*)
							{assembledPacket/.packetWithIDRules,True}
						]
					)
				]
			],
				{
					ToList@methodSet,
					packetSet
				}
			],
			{{Null},{}}
		]],
		{
			Lookup[lcmsOptionsAssociation,{
				MassSpectrometryMethod,
				StandardMassSpectrometryMethod,
				BlankMassSpectrometryMethod,
				ColumnPrimeMassSpectrometryMethod,
				ColumnFlushMassSpectrometryMethod
			}],
			{
				sampleMassAcquisitionPackets,
				standardMassAcquisitionPackets,
				blankMassAcquisitionPackets,
				{columnPrimeMassAcquisitionPacket},
				{columnFlushMassAcquisitionPacket}
			},
			Range[5]
		}
	];

	(*We throw a warning if we're overwriting a mass acquisition method*)
	{
		sampleMassAcquisitionPacketChangeQ,
		standardMassAcquisitionPacketChangeQ,
		blankMassAcquisitionPacketChangeQ,
		columnPrimeMassAcquisitionPacketChangeQ,
		columnFlushMassAcquisitionPacketChangeQ
	}=Map[(Or@@#)&,
		{
			sampleMassAcquisitionPacketChangeBool,
			standardMassAcquisitionPacketChangeBool,
			blankMassAcquisitionPacketChangeBool,
			columnPrimeMassAcquisitionPacketChangeBool,
			columnFlushMassAcquisitionPacketChangeBool
		}
	];

	(*check if we're doing that*)
	massAcquisitionPacketChangeQ=Or[
		sampleMassAcquisitionPacketChangeQ,
		standardMassAcquisitionPacketChangeQ,
		blankMassAcquisitionPacketChangeQ,
		columnPrimeMassAcquisitionPacketChangeQ,
		columnFlushMassAcquisitionPacketChangeQ
	];

	If[messagesQ&&massAcquisitionPacketChangeQ,
		Message[Warning::OverwritingMassAcquisitionMethod,Join[{InjectionTable},PickList[
			{
				MassSpectrometryMethod,
				StandardMassSpectrometryMethod,
				BlankMassSpectrometryMethod,
				ColumnPrimeMassSpectrometryMethod,
				ColumnFlushMassSpectrometryMethod
			},
			{
				sampleMassAcquisitionPacketChangeQ,
				standardMassAcquisitionPacketChangeQ,
				blankMassAcquisitionPacketChangeQ,
				columnPrimeMassAcquisitionPacketChangeQ,
				columnFlushMassAcquisitionPacketChangeQ
			}
		]]]
	];

	massAcquisitionPacketChangeTest=If[gatherTestsQ,
		Warning["If acquisition methods are specified, they are not overwritten with new option specifications",
			massAcquisitionPacketChangeQ,
			False
		],
		Nothing
	];

	(*combine everything*)
	finalCombinedMAPackets=Cases[DeleteDuplicates@Flatten[{
		finalSampleMassAcquisitionPackets,
		finalStandardMassAcquisitionPackets,
		finalBlankMassAcquisitionPackets,
		{finalColumnPrimeMassAcquisitionPacket},
		{finalColumnFlushMassAcquisitionPacket}
	}],Except[Null]];

	(*we'll upload anything that's NOT in the cache*)
	maPacketsToUpload=Complement[finalCombinedMAPackets,cache];

	(*get the object ids to give to our injection table*)
	{
		sampleMAids,
		standardMAids,
		blankMAids,
		{columnPrimeMAid},
		{columnFlushMAid}
	}=Map[
		Function[{packets},
			If[MatchQ[packets,Null|{Null}|{}],
				{Null},
				Lookup[packets,Object]
			]
		],
		{
			finalSampleMassAcquisitionPackets,
			finalStandardMassAcquisitionPackets,
			finalBlankMassAcquisitionPackets,
			{finalColumnPrimeMassAcquisitionPacket},
			{finalColumnFlushMassAcquisitionPacket}
		}
	];

	(*get the number of replicates*)
	numberOfReplicates=Lookup[lcmsOptionsAssociation,NumberOfReplicates]/.{Null->1};

	(*update the injection table with the mass acquisition method packets and delete out the column column*)
	hplcInjectionTable=Lookup[hplcProtocolPacket,Replace[InjectionTable]];

	(*get all of the positions so that it's easy to update the injection table*)
	{samplePositions,standardPositions,blankPositions,columnPrimePositions,columnFlushPositions}=Map[
		Sequence@@@Position[hplcInjectionTable,KeyValuePattern[Type->#]]&
		,{Sample,Standard,Blank,ColumnPrime,ColumnFlush}];

	(*slice out the various types*)
	sampleHPLCInjectionTableAssociations=Part[hplcInjectionTable,samplePositions];
	standardHPLCInjectionTableAssociations=Part[hplcInjectionTable,standardPositions];
	blankHPLCInjectionTableAssociations=Part[hplcInjectionTable,blankPositions];
	columnPrimeHPLCInjectionTableAssociations=Part[hplcInjectionTable,columnPrimePositions];
	columnFlushHPLCInjectionTableAssociations=Part[hplcInjectionTable,columnFlushPositions];

	(*if the number of replicates is more than 1, we need to expand it*)
	expandedSampleMAids=If[numberOfReplicates>1, Flatten@Map[ConstantArray[#,numberOfReplicates]&,sampleMAids], sampleMAids];

	(*we need to create a mapping association so the index matching from the types goes to the positions with the table
  for example, the resolvedBlank maybe length 2 (e.g. {blank1,blank2}; However this may be repeated in the injectiontable
  based on the set BlankFrequency. For example BlankFrequency -> FirstAndLast will place at the beginning at the end
  therefore, we need to have associations for each that points to the locations within the table so that it's easier to update
  the resources*)

	(*a helper function used to make the reverse dictionary so that we can go from the injection table position to the other variables*)
	makeReverseAssociation[inputAssociation:Null]:=Null;
	makeReverseAssociation[inputAssociation_Association]:=Association[
		SortBy[Flatten@Map[
			Function[{rule},
				Map[#->First[rule]&,Last[rule]]
			],Normal@inputAssociation]
			,First]
	];

	{standardLookup,blankLookup}=Lookup[lcmsOptionsAssociation,{Standard,Blank}];

	(*first do the standards*)
	standardMappingAssociation=If[MatchQ[standardLookup,Null|{Null}|{}],
		(*first check whether there is anything here*)
		Null,
		(*otherwise we have to partition the positions by the length of our standards and map through*)
		Association@MapIndexed[Function[{positionSet,index},First[index]->positionSet],Transpose@Partition[standardPositions,Length[standardLookup]]]
	];

	(*do the blanks in the same way*)
	blankMappingAssociation=If[MatchQ[blankLookup,Null|{Null}|{}],
		(*first check whether there is anything here*)
		Null,
		(*otherwise we have to partition the positions by the length of our blank and map through*)
		Association@MapIndexed[Function[{positionSet,index},First[index]->positionSet],Transpose@Partition[blankPositions,Length[blankLookup]]]
	];

	(*make the reverse associations*)
	{standardReverseAssociation,blankReverseAssociation}=Map[makeReverseAssociation,
		{standardMappingAssociation,blankMappingAssociation}
	];

	(*to fill in the parameters we just need the injection table positions corresponded to the pertinent ones*)
	standardPositionsCorresponded=If[Length[standardPositions]>0,Last/@SortBy[Normal@standardReverseAssociation,First]];
	blankPositionsCorresponded=If[Length[blankPositions]>0,Last/@SortBy[Normal@blankReverseAssociation,First]];

	(*we could also have multiple column primes and flushes. so we need to expand these too*)
	expandedStandardsMAids=If[Length[standardPositions]>0,standardMAids[[standardPositionsCorresponded]]];
	expandedBlanksMAids=If[Length[blankPositions]>0,blankMAids[[blankPositionsCorresponded]]];
	expandedColumnPrimeMAids=If[Length[columnPrimePositions]>0,ConstantArray[columnPrimeMAid,Length[columnPrimePositions]]];
	expandedColumnFlushMAids=If[Length[columnFlushPositions]>0,ConstantArray[columnFlushMAid,Length[columnFlushPositions]]];

	(*now map through and update our injeciton table tuples*)
	{
		updatedSampleInjectionTableAssociations,
		updatedStandardInjectionTableAssociations,
		updatedBlankInjectionTableAssociations,
		updatedColumnPrimeInjectionTableAssociations,
		updatedColumnFlushInjectionTableAssociations
	}= MapThread[
		Function[{associationSet,objectIDSet},
			If[Length[associationSet]>0,
				MapThread[
					Function[{currentAssociation,methodObjectID},
						(*we remove the column position key and add the mass spec method*)
						Join[KeyDrop[currentAssociation,ColumnPosition],Association[MassSpectrometry->Link@methodObjectID]]
					],
					{
						associationSet,
						objectIDSet
					}
				],
				{}
			]
		],
		{
			{
				sampleHPLCInjectionTableAssociations,
				standardHPLCInjectionTableAssociations,
				blankHPLCInjectionTableAssociations,
				columnPrimeHPLCInjectionTableAssociations,
				columnFlushHPLCInjectionTableAssociations
			},
			{
				expandedSampleMAids,
				expandedStandardsMAids,
				expandedBlanksMAids,
				expandedColumnPrimeMAids,
				expandedColumnFlushMAids
			}
		}
	];

	(*make our complete injection table for upload*)
	injectionTableUploadable=Range[Length[hplcInjectionTable]]/.Join[
		AssociationThread[samplePositions,updatedSampleInjectionTableAssociations],
		AssociationThread[standardPositions,updatedStandardInjectionTableAssociations],
		AssociationThread[blankPositions,updatedBlankInjectionTableAssociations],
		AssociationThread[columnPrimePositions,updatedColumnPrimeInjectionTableAssociations],
		AssociationThread[columnFlushPositions,updatedColumnFlushInjectionTableAssociations]
	];

	(*remove the replaces from our mass acquisition methods so that it's easier to fill in the protocol packet*)
	{
		noReplaceSampleMassAcquisitionPackets,
		protoNoReplaceStandardMassAcquisitionPackets,
		protoNoReplaceBlankMassAcquisitionPackets,
		{noReplaceColumnPrimeMassAcquisitionPacket},
		{noReplaceColumnFlushMassAcquisitionPacket}
	}=Map[
		Function[{packetList},
			If[MatchQ[packetList,Except[{}|Null|{Null}]],
				Map[Association[Normal[#]/.{Replace[x_]:>x}]&,packetList],
				{Null}
			]
		],
		{
			finalSampleMassAcquisitionPackets,
			finalStandardMassAcquisitionPackets,
			finalBlankMassAcquisitionPackets,
			{finalColumnPrimeMassAcquisitionPacket},
			{finalColumnFlushMassAcquisitionPacket}
		}
	];

	(*define whether standards, blanks, primes, and flushes exist period*)
	{standardsQ,blanksQ,primeQ,flushQ}=Map[
		MatchQ[#,Except[{}|Null|{Null}]]&,
		{
			protoNoReplaceStandardMassAcquisitionPackets,
			protoNoReplaceBlankMassAcquisitionPackets,
			{noReplaceColumnPrimeMassAcquisitionPacket},
			{noReplaceColumnFlushMassAcquisitionPacket}
		}
	];

	(*for the standards and blanks we need to expand them by the number of times they're in the injection table*)
	noReplaceStandardMassAcquisitionPackets=If[standardsQ,
		PadRight[protoNoReplaceStandardMassAcquisitionPackets,Length[standardPositions],protoNoReplaceStandardMassAcquisitionPackets],
		protoNoReplaceStandardMassAcquisitionPackets
	];
	noReplaceBlankMassAcquisitionPackets=If[blanksQ,
		PadRight[protoNoReplaceBlankMassAcquisitionPackets,Length[blankPositions],protoNoReplaceBlankMassAcquisitionPackets],
		protoNoReplaceBlankMassAcquisitionPackets
	];

	(*update the resolved options -- remove all of the frequencies and update New with the method*)
	protoResolvedOptions=Association@CollapseIndexMatchedOptions[ExperimentLCMS,myResolvedOptions,Ignore->ToList[myUnresolvedOptions],Messages->False];

	(*update the mass spec methods and the injection table*)

	injectionTableLookup=Lookup[protoResolvedOptions,InjectionTable];

	(*get the positions again, this version does not account for Number of Replicates*)
	{
		sampleNoReplicatesPositions,
		standardNoReplicatesPositions,
		blankNoReplicatesPositions,
		columnPrimeNoReplicatesPositions,
		columnFlushNoReplicatesPositions
	}=Map[
		Sequence@@@Position[injectionTableLookup,{#,___}]&
		,{Sample,Standard,Blank,ColumnPrime,ColumnFlush}];

	(*generate the method replacements*)
	methodReplacementRules=Flatten@MapThread[Function[{positions,methods},
			If[Length[positions]>0,
				MapThread[{#1,6}->Download[#2,Object]&,{positions,methods}],
				{}
			]
		],
		{
			{
				sampleNoReplicatesPositions,
				standardNoReplicatesPositions,
				blankNoReplicatesPositions,
				columnPrimeNoReplicatesPositions,
				columnFlushNoReplicatesPositions
			},
			{
				sampleMAids,
				expandedStandardsMAids,
				expandedBlanksMAids,
				expandedColumnPrimeMAids,
				expandedColumnFlushMAids
			}
		}
	];

	(*make our replaced injection table*)
	replacedInjectionTable=ReplacePart[injectionTableLookup,methodReplacementRules];

	(*now make our updated resolved options*)
	updatedResolvedOptions=Normal@Join[protoResolvedOptions,
		Association[
			BlankFrequency->Null,
			StandardFrequency->Null,
			ColumnRefreshFrequency->Null,
			InjectionTable->replacedInjectionTable,
			MassSpectrometryMethod->sampleMAids,
			StandardMassSpectrometryMethod->standardMAids,
			BlankMassSpectrometryMethod->blankMAids,
			ColumnPrimeMassSpectrometryMethod->columnPrimeMAid,
			ColumnFlushMassSpectrometryMethod->columnFlushMAid
		]
	];

	(* Create placement field value for BufferA and BufferB *)
	(* complicated because it depends on how many buffers we have, and that we're building out; the most easily accessible BufferA slots are 4, then 3, then 2, then 1, and BufferB 5, then 6, then 7, then 8 *)
	bufferPlacements = MapThread[
		If[!NullQ[#1], {#1, {"Buffer " <> #2 <> " Slot"}}, Nothing]&,
		{
			{
				Lookup[hplcProtocolPacket,BufferA],
				Lookup[hplcProtocolPacket,BufferB],
				Lookup[hplcProtocolPacket,BufferC],
				Lookup[hplcProtocolPacket,BufferD]
			},
			{
				"A","B","C","D"
			}
		}
	];

	(*the column prime and flush absorbance require a little more finneese because of going from multiple to singleton*)
	columnPrimeAbsorbanceSelectionLookup=Lookup[hplcProtocolPacket,Replace[ColumnPrimeAbsorbanceWavelengths]];
	columnFlushAbsorbanceSelectionLookup=Lookup[hplcProtocolPacket,Replace[ColumnFlushAbsorbanceWavelengths]];
	columnPrimeAbsorbanceSelection=If[MatchQ[columnPrimeAbsorbanceSelectionLookup,List[UnitsP[Nanometer]..]],
		columnPrimeAbsorbanceSelectionLookup,
		FirstOrDefault@columnPrimeAbsorbanceSelectionLookup
	];
	columnFlushAbsorbanceSelection=If[MatchQ[columnFlushAbsorbanceSelectionLookup,List[UnitsP[Nanometer]..]],
		columnFlushAbsorbanceSelectionLookup,
		FirstOrDefault@columnFlushAbsorbanceSelectionLookup
	];
	
	(*estimate a calibration time for *)
	calibrationTime=If[MatchQ[secondCalibrant,ObjectP[]],40Minute,20Minute];
	(* Use Level 1 Operators *)
	operatorResource = $BaselineOperator;

	(*define all of the checkpoints*)
	checkpoints = If[tripleQuadQ,
		{
			{"Picking Resources", 1 Hour, "Buffers and columns required to run LCMS experiments are gathered.",Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
			{"Calibrate the Instrument",calibrationTime, "Check if the instrument is ready to run the sample, and calibrate the voltage offset if needed.",Link[Resource[Operator -> operatorResource, Time -> calibrationTime]]},
			{"Purging Instrument",1 Hour, "System priming buffers are connected to an LCMS instrument and the instrument is purged at a high flow rate.",Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
			{"Preparing Samples", 90 Minute, "An instrument is configured for the protocol.",Link[Resource[Operator -> operatorResource, Time -> 90 Minute]]},
			{"Acquiring Data", Lookup[hplcProtocolPacket,SeparationTime], "Samples are injected onto an HPLC and subject to buffer gradients.",Link[Resource[Operator -> operatorResource, Time -> Lookup[hplcProtocolPacket,SeparationTime]]]},
			{"Sample Post-Processing", 1 Hour, "Any measuring of volume, weight, or sample imaging post experiment is performed.",Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
			{"Flushing Instrument", 2 Hour, " Buffers are connected to an LCMS instrument and the instrument is flushed with each buffer at a high flow rate.",Link[Resource[Operator -> operatorResource, Time -> 2 Hour]]},
			{"Exporting Data", 20 Minute, "Acquired chromatography and mass spectrometry data is exported.",Link[Resource[Operator -> operatorResource, Time -> 20 Minute]]},
			{"Returning Materials", 15 Minute, "Samples are returned to storage.",Link[Resource[Operator -> operatorResource, Time -> 15 Minute]]}
		},
		{
			{"Picking Resources", 1 Hour, "Buffers and columns required to run LCMS experiments are gathered.",Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
			{"Purging Instrument",1 Hour, "System priming buffers are connected to an LCMS instrument and the instrument is purged at a high flow rate.",Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
			{"Preparing Samples", 90 Minute, "An instrument is configured for the protocol.",Link[Resource[Operator -> operatorResource, Time -> 90 Minute]]},
			{"Acquiring Data", Lookup[hplcProtocolPacket,SeparationTime], "Samples are injected onto an HPLC and subject to buffer gradients.",Link[Resource[Operator -> operatorResource, Time -> Lookup[hplcProtocolPacket,SeparationTime]]]},
			{"Sample Post-Processing", 1 Hour, "Any measuring of volume, weight, or sample imaging post experiment is performed.",Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
			{"Flushing Instrument", 2 Hour, " Buffers are connected to an LCMS instrument and the instrument is flushed with each buffer at a high flow rate.",Link[Resource[Operator -> operatorResource, Time -> 2 Hour]]},
			{"Exporting Data", 20 Minute, "Acquired chromatography and mass spectrometry data is exported.",Link[Resource[Operator -> operatorResource, Time -> 20 Minute]]},
			{"Returning Materials", 15 Minute, "Samples are returned to storage.",Link[Resource[Operator -> operatorResource, Time -> 15 Minute]]}
		}
	];

	(* Populate all shared fields using legacy Funtopia function *)
	sharedFieldPacket = populateSamplePrepFields[mySamples,myResolvedOptions,Cache->cache,Simulation->simulation];

	(*make the protocol packet id*)
	protocolObjectID=CreateID[Object[Protocol,LCMS]];

	(* Create UnitOperation Packet Lookup *)
	
	allPacketNoNull=Flatten[
		{
			noReplaceSampleMassAcquisitionPackets,
			If[primeQ,noReplaceColumnPrimeMassAcquisitionPacket,{}],
			If[standardsQ,noReplaceStandardMassAcquisitionPackets,{}],
			If[blanksQ,noReplaceBlankMassAcquisitionPackets,{}],
			If[flushQ,noReplaceColumnFlushMassAcquisitionPacket,{}]
		}
	];

	allMassAcquisitionObjs=Lookup[allPacketNoNull,Object];

	(* make replace rules converting the samples to their resource objects *)
	sampleToResourceRules = DeleteDuplicates[Map[
		If[MatchQ[#, _Resource],
			Download[#[Sample], Object] -> #,
			Nothing
		]&,
		(* importantly here, we need the resource form in the unit operation object, NOT the raw object.  This is because if we're using PreparatoryUnitOperations we're going to be hosed otherwise *)
		Flatten@{
			Lookup[hplcProtocolPacket,Replace[SamplesIn]]/.{Link[x_Resource,___]:>x},
			Lookup[hplcProtocolPacket,Replace[Blanks]] /. {Link[x_Resource, ___] :> x},
			Lookup[hplcProtocolPacket,Replace[Standards]] /. {Link[x_Resource, ___] :> x}
		}
	]];

	(* importantly here, we need the resource form in the unit operation object, NOT the raw object.  This is because if we're using PreparatoryUnitOperations we're going to be hosed otherwise *)
	allUnitOperationObjects=Join[
		ToList@Download[mySamples, Object],
		ToList@If[primeQ,Null,Nothing],
		ToList@If[standardsQ,PadRight[Lookup[lcmsOptionsAssociation, Standard],Length[standardPositions],Lookup[lcmsOptionsAssociation, Standard]],Nothing],
		ToList@If[blanksQ,PadRight[Lookup[lcmsOptionsAssociation, Blank],Length[blankPositions],Lookup[lcmsOptionsAssociation, Blank]],Nothing],
		ToList@If[flushQ,Null,Nothing]
	]/.sampleToResourceRules;
	allUnitOperationTypes=Join[
		ToList@ConstantArray[Sample,Length[Download[mySamples,Object]]],
		ToList@If[primeQ,ColumnPrime,Nothing],
		ToList@If[standardsQ,ConstantArray[Standard,Length[noReplaceStandardMassAcquisitionPackets]],{}],
		ToList@If[blanksQ,ConstantArray[Blank,Length[noReplaceBlankMassAcquisitionPackets]],{}],
		ToList@If[flushQ,ColumnFlush,Nothing]
	];
	
	(* Generate unitoperation packets *)
	allUnitOperationPacket=MapThread[
		(* For each mass sample, there is a massacquisitionpacket *)
		Function[
			
			{eachSampleMassAcquisition,sampleObject,sampleType},
			
			{
				(*1*)innerAcquisitionWindows,
				(*2*)innerAcquisitionModes,
				(*3*)innerFragmentations,
				(*4*)innerMinMasses,
				(*5*)innerMaxMasses,
				(*6*)innerMassSelections,
				(*7*)innerScanTimes,
				(*8*)innerFragmentMinMasses,
				(*9*)innerFragmentMaxMasses,
				(*10*)innerFragmentMassSelections,
				(*11*)innerCollisionEnergies,
				(*12*)innerLowCollisionEnergies,
				(*13*)innerHighCollisionEnergies,
				(*14*)innerFinalLowCollisionEnergies,
				(*15*)innerFinalHighCollisionEnergies,
				(*16*)innerFragmentScanTimes,
				(*17*)innerAcquisitionSurveys,
				(*18*)innerMinimumThresholds,
				(*19*)innerAcquisitionLimits,
				(*20*)innerCycleTimeLimits,
				(*21*)innerExclusionDomains,
				(*22*)innerExclusionMasses,
				(*23*)innerExclusionMassTolerances,
				(*24*)innerExclusionRetentionTimeTolerances,
				(*25*)innerInclusionDomains,
				(*26*)innerInclusionMasses,
				(*27*)innerInclusionCollisionEnergies,
				(*28*)innerInclusionDeclusteringVoltages,
				(*29*)innerInclusionChargeStates,
				(*30*)innerInclusionScanTimes,
				(*31*)innerInclusionMassTolerances,
				(*32*)innerChargeStateLimits,
				(*33*)innerChargeStateSelections,
				(*34*)innerChargeStateMassTolerances,
				(*35*)innerIsotopeMassDifferences,
				(*36*)innerIsotopeRatios,
				(*37*)innerIsotopeDetectionMinimums,
				(*38*)innerIsotopeRatioTolerances,
				(*39*)innerIsotopeMassTolerances,
				(*40*)innerCollisionCellExitVoltages,
				(*41*)innerMassDetectionStepSizes,
				(*42*)innerNeutralLosses,
				(*43*)innerDwellTimes,
				(*44*)innerMultipleReactionMonitoringAssays
			}=Lookup[eachSampleMassAcquisition,
				{
					(*1*)AcquisitionWindows,
					(*2*)AcquisitionModes,
					(*3*)Fragmentations,
					(*4*)MinMasses,
					(*5*)MaxMasses,
					(*6*)MassSelections,
					(*7*)ScanTimes,
					(*8*)FragmentMinMasses,
					(*9*)FragmentMaxMasses,
					(*10*)FragmentMassSelections,
					(*11*)CollisionEnergies,
					(*12*)LowCollisionEnergies,
					(*13*)HighCollisionEnergies,
					(*14*)FinalLowCollisionEnergies,
					(*15*)FinalHighCollisionEnergies,
					(*16*)FragmentScanTimes,
					(*17*)AcquisitionSurveys,
					(*18*)MinimumThresholds,
					(*19*)AcquisitionLimits,
					(*20*)CycleTimeLimits,
					(*21*)ExclusionDomains,
					(*22*)ExclusionMasses,
					(*23*)ExclusionMassTolerances,
					(*24*)ExclusionRetentionTimeTolerances,
					(*25*)InclusionDomains,
					(*26*)InclusionMasses,
					(*27*)InclusionCollisionEnergies,
					(*28*)InclusionDeclusteringVoltages,
					(*29*)InclusionChargeStates,
					(*30*)InclusionScanTimes,
					(*31*)InclusionMassTolerances,
					(*32*)ChargeStateLimits,
					(*33*)ChargeStateSelections,
					(*34*)ChargeStateMassTolerances,
					(*35*)IsotopeMassDifferences,
					(*36*)IsotopeRatios,
					(*37*)IsotopeDetectionMinimums,
					(*38*)IsotopeRatioTolerances,
					(*39*)IsotopeMassTolerances,
					(*40*)CollisionCellExitVoltages,
					(*41*)MassDetectionStepSizes,
					(*42*)NeutralLosses,
					(*43*)DwellTimes,
					(*44*)MultipleReactionMonitoringAssays
				}
			];
		
			(*Clean the innerMultipleReactionMonitoringAssays*)
			cleanedInnerMultipleReactionMonitoringAssays=Which[
				NullQ[#], Null,
				MatchQ[#,Except[_List]],
				ConstantArray[#,Length[innerAcquisitionWindows]],
				True,#
			]&/@innerMultipleReactionMonitoringAssays;
			
			(* MapThread all options for unit operations*)
			MapThread[
				Function[
					{
						(*1*)unitOperationAcquisitionWindow,
						(*2*)unitOperationAcquisitionMode,
						(*3*)unitOperationFragmentation,
						(*4*)unitOperationMinMasse,
						(*5*)unitOperationMaxMasse,
						(*6*)unitOperationMassSelection,
						(*7*)unitOperationScanTime,
						(*8*)unitOperationFragmentMinMasse,
						(*9*)unitOperationFragmentMaxMasse,
						(*10*)unitOperationFragmentMassSelection,
						(*11*)unitOperationCollisionEnergie,
						(*12*)unitOperationLowCollisionEnergie,
						(*13*)unitOperationHighCollisionEnergie,
						(*14*)unitOperationFinalLowCollisionEnergie,
						(*15*)unitOperationFinalHighCollisionEnergie,
						(*16*)unitOperationFragmentScanTime,
						(*17*)unitOperationAcquisitionSurvey,
						(*18*)unitOperationMinimumThreshold,
						(*19*)unitOperationAcquisitionLimit,
						(*20*)unitOperationCycleTimeLimit,
						(*21*)unitOperationExclusionDomain,
						(*22*)unitOperationExclusionMasse,
						(*23*)unitOperationExclusionMassTolerance,
						(*24*)unitOperationExclusionRetentionTimeTolerance,
						(*25*)unitOperationInclusionDomain,
						(*26*)unitOperationInclusionMasse,
						(*27*)unitOperationInclusionCollisionEnergie,
						(*28*)unitOperationInclusionDeclusteringVoltage,
						(*29*)unitOperationInclusionChargeState,
						(*30*)unitOperationInclusionScanTime,
						(*31*)unitOperationInclusionMassTolerance,
						(*32*)unitOperationChargeStateLimit,
						(*33*)unitOperationChargeStateSelection,
						(*34*)unitOperationChargeStateMassTolerance,
						(*35*)unitOperationIsotopeMassDifference,
						(*36*)unitOperationIsotopeRatio,
						(*37*)unitOperationIsotopeDetectionMinimum,
						(*38*)unitOperationIsotopeRatioTolerance,
						(*39*)unitOperationIsotopeMassTolerance,
						(*40*)unitOperationCollisionCellExitVoltage,
						(*41*)unitOperationMassDetectionStepSize,
						(*42*)unitOperationNeutralLosse,
						(*43*)unitOperationDwellTime,
						(*44*)unitOperationMultipleReactionMonitoringAssay
					},
					
					Association[
						Object->CreateID[Object[UnitOperation,MassSpectrometryScan]],
						Sample-> Link[sampleObject],
						SampleType -> sampleType,
						AcquisitionWindow->unitOperationAcquisitionWindow,
						AcquisitionMode->unitOperationAcquisitionMode,
						Fragmentation->unitOperationFragmentation,
						MinMass->unitOperationMinMasse,
						MaxMass->unitOperationMaxMasse,
						Replace[MassSelections]->unitOperationMassSelection,
						ScanTime->unitOperationScanTime,
						FragmentMinMass->unitOperationFragmentMinMasse,
						FragmentMaxMass->unitOperationFragmentMaxMasse,
						Replace[FragmentMassSelections]->unitOperationFragmentMassSelection,
						Replace[CollisionEnergies]->unitOperationCollisionEnergie,
						LowCollisionEnergy->unitOperationLowCollisionEnergie,
						HighCollisionEnergy->unitOperationHighCollisionEnergie,
						FinalLowCollisionEnergy->unitOperationFinalLowCollisionEnergie,
						FinalHighCollisionEnergy->unitOperationFinalHighCollisionEnergie,
						FragmentScanTime->unitOperationFragmentScanTime,
						AcquisitionSurvey->unitOperationAcquisitionSurvey,
						MinimumThreshold->unitOperationMinimumThreshold,
						AcquisitionLimit->unitOperationAcquisitionLimit,
						CycleTimeLimit->unitOperationCycleTimeLimit,
						Replace[ExclusionDomain]->unitOperationExclusionDomain,
						Replace[ExclusionMass]->unitOperationExclusionMasse,
						ExclusionMassTolerance->unitOperationExclusionMassTolerance,
						ExclusionRetentionTimeTolerance->unitOperationExclusionRetentionTimeTolerance,
						Replace[InclusionDomain]->unitOperationInclusionDomain,
						Replace[InclusionMass]->unitOperationInclusionMasse,
						Replace[InclusionCollisionEnergies]->unitOperationInclusionCollisionEnergie,
						Replace[InclusionDeclusteringVoltages]->unitOperationInclusionDeclusteringVoltage,
						Replace[InclusionChargeStates]->unitOperationInclusionChargeState,
						Replace[InclusionScanTimes]->unitOperationInclusionScanTime,
						InclusionMassTolerance->unitOperationInclusionMassTolerance,
						ChargeStateLimit->unitOperationChargeStateLimit,
						Replace[ChargeStateSelections]->unitOperationChargeStateSelection,
						ChargeStateMassTolerance->unitOperationChargeStateMassTolerance,
						Replace[IsotopeMassDifferences]->unitOperationIsotopeMassDifference,
						Replace[IsotopeRatios]->unitOperationIsotopeRatio,
						Replace[IsotopeDetectionMinimums]->unitOperationIsotopeDetectionMinimum,
						IsotopeRatioTolerance->unitOperationIsotopeRatioTolerance,
						IsotopeMassTolerance->unitOperationIsotopeMassTolerance,
						CollisionCellExitVoltage->unitOperationCollisionCellExitVoltage,
						MassDetectionStepSize->unitOperationMassDetectionStepSize,
						NeutralLoss->unitOperationNeutralLosse,
						Replace[DwellTime]->unitOperationDwellTime,
						Replace[MultipleReactionMonitoringAssays]->unitOperationMultipleReactionMonitoringAssay
					]
				
				],
				{
					(*1*)innerAcquisitionWindows,
					(*2*)innerAcquisitionModes,
					(*3*)innerFragmentations,
					(*4*)innerMinMasses,
					(*5*)innerMaxMasses,
					(*6*)innerMassSelections,
					(*7*)innerScanTimes,
					(*8*)innerFragmentMinMasses,
					(*9*)innerFragmentMaxMasses,
					(*10*)innerFragmentMassSelections,
					(*11*)innerCollisionEnergies,
					(*12*)innerLowCollisionEnergies,
					(*13*)innerHighCollisionEnergies,
					(*14*)innerFinalLowCollisionEnergies,
					(*15*)innerFinalHighCollisionEnergies,
					(*16*)innerFragmentScanTimes,
					(*17*)innerAcquisitionSurveys,
					(*18*)innerMinimumThresholds,
					(*19*)innerAcquisitionLimits,
					(*20*)innerCycleTimeLimits,
					(*21*)innerExclusionDomains,
					(*22*)innerExclusionMasses,
					(*23*)innerExclusionMassTolerances,
					(*24*)innerExclusionRetentionTimeTolerances,
					(*25*)innerInclusionDomains,
					(*26*)innerInclusionMasses,
					(*27*)innerInclusionCollisionEnergies,
					(*28*)innerInclusionDeclusteringVoltages,
					(*29*)innerInclusionChargeStates,
					(*30*)innerInclusionScanTimes,
					(*31*)innerInclusionMassTolerances,
					(*32*)innerChargeStateLimits,
					(*33*)innerChargeStateSelections,
					(*34*)innerChargeStateMassTolerances,
					(*35*)innerIsotopeMassDifferences,
					(*36*)innerIsotopeRatios,
					(*37*)innerIsotopeDetectionMinimums,
					(*38*)innerIsotopeRatioTolerances,
					(*39*)innerIsotopeMassTolerances,
					(*40*)innerCollisionCellExitVoltages,
					(*41*)innerMassDetectionStepSizes,
					(*42*)innerNeutralLosses,
					(*43*)innerDwellTimes,
					(*44*)cleanedInnerMultipleReactionMonitoringAssays
				}
			]
		
		],
		{
			(* the order for the packet is Sample,ColumnPrime,Standards,Blanks,ColumnFlush*)
			allPacketNoNull,
			allUnitOperationObjects,
			allUnitOperationTypes
		}
	];
	
	
	allUnitOperationObjectsNested=Lookup[#,Object]&/@allUnitOperationPacket;
	
	(* build a unit operation lookup for type*)
	unitOperationLookup=MapThread[{#1 -> #2} &, {allUnitOperationTypes,allUnitOperationObjectsNested}];
	
	(* Build a another lookup between mass acquisition and unit operations *)
	positionUnitOperationLookup=Flatten[MapThread[
		Function[{eachType,eachPoistion},
			Module[{eachUnitOperationObjectsNested,eachSamplePositionUOLookUp,cleanedUONestedObjects},
				
				(*Generate the sample UO packet*)
				eachUnitOperationObjectsNested=PickList[allUnitOperationObjectsNested,allUnitOperationTypes,eachType];
				
				(*Check the length of each sample type and how many UO packets we have*)
				(* Only Sample we have same size UO to same sample injection, for other type of sample, like standard, no matter how many samples we specified*)
				(*no matter how many samples we specified we should only have one set of data*)
				cleanedUONestedObjects=If[Length[eachUnitOperationObjectsNested]!=Length[eachPoistion],
					ConstantArray[FirstOrDefault[eachUnitOperationObjectsNested,{}],Length[eachPoistion]],
					eachUnitOperationObjectsNested
				];
				
				(* Build a loock to link the position with the Sample UO Packet Object ID*)
				eachSamplePositionUOLookUp=MapThread[
					{#1 -> #2} &,
					{eachPoistion,cleanedUONestedObjects}
				];
				
				(*Return the Lookup*)
				eachSamplePositionUOLookUp
			]
		],
		{
			{Sample,ColumnPrime,Standard,Blank,ColumnFlush},
			{samplePositions, columnPrimePositions, standardPositions, blankPositions, columnFlushPositions}
		}
	],2];
	
	(*make our complete injection table for upload*)
	massSpectrometryScansUpdate=Range[Length[hplcInjectionTable]]/.positionUnitOperationLookup;
	
	
	(*assemble the final protocol packet*)
	(*we chunk this so that it's easier to troubleshoot*)
	protocolPacketChunk1=Association[
		Type -> Object[Protocol,LCMS],
		Object -> protocolObjectID,
		Replace[SamplesIn] -> Lookup[hplcProtocolPacket,Replace[SamplesIn]],
		Replace[ContainersIn] -> Lookup[hplcProtocolPacket,Replace[ContainersIn]],

		(* For shared procedure with Object[Protocol, MassSpectrometry] etc. populate instrument field with the mass spectrometer *)
		Instrument -> Link@massSpectrometerResource,
		MassSpectrometryInstrument -> Link@massSpectrometerResource,
		ChromatographyInstrument -> Lookup[hplcProtocolPacket,Instrument],
		MassAnalyzer -> Lookup[lcmsOptionsAssociation,MassAnalyzer],
		IonSource -> First@Lookup[instrumentModelPacket,IonSources],
		SeparationMode -> Lookup[lcmsOptionsAssociation,SeparationMode],
		Replace[Detectors] -> {Pressure,Temperature,PhotoDiodeArray,MassSpectrometry},
		SeparationTime -> Lookup[hplcProtocolPacket,SeparationTime],
		NeedleWashSolution -> Lookup[hplcProtocolPacket,NeedleWashSolution],
		Replace[NeedleWashPlacements] -> Lookup[hplcProtocolPacket,Replace[NeedleWashPlacements]],

		SystemPrimeBufferA->Lookup[hplcProtocolPacket,SystemPrimeBufferA],
		SystemPrimeBufferB->Lookup[hplcProtocolPacket,SystemPrimeBufferB],
		SystemPrimeBufferC->Lookup[hplcProtocolPacket,SystemPrimeBufferC],
		SystemPrimeBufferD->Lookup[hplcProtocolPacket,SystemPrimeBufferD],
		Replace[SystemPrimeBufferPlacements]->Lookup[hplcProtocolPacket,Replace[SystemPrimeBufferContainerPlacements]],
		SystemPrimeGradient->Lookup[hplcProtocolPacket,SystemPrimeGradient],
		SystemPrimeMassAcquisitionMethod->If[tripleQuadQ,Link@Object[Method, MassAcquisition, "System Prime Flush MS Method For ESI-QQQ"],Link@Object[Method, MassAcquisition, "System Prime Flush MS Method"]],

		Replace[MassSpectrometryScans]->massSpectrometryScansUpdate,
		Replace[SampleMassSpectrometryScans]->samplePositions/.positionUnitOperationLookup,
		Replace[BlankMassSpectrometryScans]->blankPositions/.positionUnitOperationLookup,
		Replace[StandardMassSpectrometryScans]->standardPositions/.positionUnitOperationLookup,
		Replace[ColumnPrimeMassSpectrometryScans]->columnPrimePositions/.positionUnitOperationLookup,
		Replace[ColumnFlushMassSpectrometryScans]->columnFlushPositions/.positionUnitOperationLookup,
		
		
		Replace[ColumnSelection]->List@columnSelector,
		Column->(Column/.columnSelector),
		SecondaryColumn->(SecondaryColumn/.columnSelector),
		TertiaryColumn->(TertiaryColumn/.columnSelector),
		Replace[ColumnJoins]->{ColumnJoin, SecondaryColumnJoin}/.columnSelector,
		GuardColumn->(GuardColumn/.columnSelector),
		GuardCartridge->FirstOrDefault@Lookup[hplcProtocolPacket,Replace[GuardCartridge]],
		GuardColumnJoin->(GuardColumnJoin/.columnSelector),
		BufferA->Lookup[hplcProtocolPacket,BufferA],
		BufferB->Lookup[hplcProtocolPacket,BufferB],
		BufferC->Lookup[hplcProtocolPacket,BufferC],
		BufferD->Lookup[hplcProtocolPacket,BufferD],
		Replace[BufferContainerPlacements]->bufferPlacements,
		MaxAcceleration->Lookup[hplcProtocolPacket,MaxAcceleration],
		Replace[InjectionTable]->injectionTableUploadable,
		MaxPressure->Lookup[hplcProtocolPacket,MaxPressure]
	];
	protocolPacketChunk2=Association[
		(*column primes are multiple in the new HPLC; hence, the FirstOrDefault *)
		ColumnPrimeGradientMethod->FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnPrimeGradients]],
		Replace[ColumnPrimeGradientA]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnPrimeGradientAs],Nothing]],
		Replace[ColumnPrimeIsocraticGradientA]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnPrimeIsocraticGradientAs],Nothing]],
		Replace[ColumnPrimeGradientB]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnPrimeGradientBs],Nothing]],
		Replace[ColumnPrimeIsocraticGradientB]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnPrimeIsocraticGradientBs],Nothing]],
		Replace[ColumnPrimeGradientC]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnPrimeGradientCs],Nothing]],
		Replace[ColumnPrimeIsocraticGradientC]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnPrimeIsocraticGradientCs],Nothing]],
		Replace[ColumnPrimeGradientD]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnPrimeGradientDs],Nothing]],
		Replace[ColumnPrimeIsocraticGradientD]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnPrimeIsocraticGradientDs],Nothing]],
		Replace[ColumnPrimeFlowRateConstant]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnPrimeFlowRateConstant],Nothing]],
		Replace[ColumnPrimeFlowRateVariable]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnPrimeFlowRateVariable],Nothing]],
		ColumnPrimeTemperature->FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnPrimeTemperatures],{}],
		ColumnPrimeMassAcquisitionMethod->If[primeQ,Link@columnPrimeMAid],
		ColumnPrimeIonMode->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,IonMode]],
		ColumnPrimeESICapillaryVoltage->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,ESICapillaryVoltage]],
		ColumnPrimeDesolvationTemperature->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,DesolvationTemperature]],
		ColumnPrimeDesolvationGasFlow->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,DesolvationGasFlow]],
		ColumnPrimeSourceTemperature->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,SourceTemperature]],
		ColumnPrimeDeclusteringVoltage->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,DeclusteringVoltage]],
		ColumnPrimeConeGasFlow->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,ConeGasFlow]],
		ColumnPrimeStepwaveVoltage->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,StepwaveVoltage]],
		ColumnPrimeIonGuideVoltage->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,IonGuideVoltage]],
		Replace[ColumnPrimeAcquisitionWindows]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,AcquisitionWindows]],
		Replace[ColumnPrimeAcquisitionModes]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,AcquisitionModes]],
		Replace[ColumnPrimeFragmentations]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,Fragmentations]],
		Replace[ColumnPrimeMinMasses]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,MinMasses]],
		Replace[ColumnPrimeMaxMasses]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,MaxMasses]],
		Replace[ColumnPrimeMassSelections]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,MassSelections]],
		Replace[ColumnPrimeScanTimes]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,ScanTimes]],
		Replace[ColumnPrimeFragmentMinMasses]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,FragmentMinMasses]],
		Replace[ColumnPrimeFragmentMaxMasses]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,FragmentMaxMasses]],
		Replace[ColumnPrimeFragmentMassSelections]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,FragmentMassSelections]],
		Replace[ColumnPrimeCollisionEnergies]->If[primeQ,Flatten[Lookup[noReplaceColumnPrimeMassAcquisitionPacket,CollisionEnergies]]],
		Replace[ColumnPrimeDwellTimes]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,DwellTimes]],
		Replace[ColumnPrimeCollisionCellExitVoltages]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,CollisionCellExitVoltages]],
		Replace[ColumnPrimeMassDetectionStepSizes]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,MassDetectionStepSizes]],
		Replace[ColumnPrimeMultipleReactionMonitoringAssays]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,MultipleReactionMonitoringAssays]],
		Replace[ColumnPrimeNeutralLosses]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,NeutralLosses]],
		Replace[ColumnPrimeLowCollisionEnergies]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,LowCollisionEnergies]],
		Replace[ColumnPrimeHighCollisionEnergies]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,HighCollisionEnergies]],
		Replace[ColumnPrimeFinalLowCollisionEnergies]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,FinalLowCollisionEnergies]],
		Replace[ColumnPrimeFinalHighCollisionEnergies]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,FinalHighCollisionEnergies]],
		Replace[ColumnPrimeFragmentScanTimes]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,FragmentScanTimes]],
		Replace[ColumnPrimeAcquisitionSurveys]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,AcquisitionSurveys]],
		Replace[ColumnPrimeMinimumThresholds]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,MinimumThresholds]],
		Replace[ColumnPrimeAcquisitionLimits]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,AcquisitionLimits]],
		Replace[ColumnPrimeCycleTimeLimits]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,CycleTimeLimits]],
		Replace[ColumnPrimeExclusionDomains]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,ExclusionDomains]],
		Replace[ColumnPrimeExclusionMasses]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,ExclusionMasses]],
		Replace[ColumnPrimeExclusionMassTolerances]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,ExclusionMassTolerances]],
		Replace[ColumnPrimeExclusionRetentionTimeTolerances]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,ExclusionRetentionTimeTolerances]],
		Replace[ColumnPrimeInclusionDomains]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,InclusionDomains]],
		Replace[ColumnPrimeInclusionMasses]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,InclusionMasses]],
		Replace[ColumnPrimeInclusionCollisionEnergies]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,InclusionCollisionEnergies]],
		Replace[ColumnPrimeInclusionDeclusteringVoltages]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,InclusionDeclusteringVoltages]],
		Replace[ColumnPrimeInclusionChargeStates]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,InclusionChargeStates]],
		Replace[ColumnPrimeInclusionScanTimes]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,InclusionScanTimes]],
		Replace[ColumnPrimeInclusionMassTolerances]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,InclusionMassTolerances]],
		Replace[ColumnPrimeChargeStateLimits]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,ChargeStateLimits]],
		Replace[ColumnPrimeChargeStateSelections]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,ChargeStateSelections]],
		Replace[ColumnPrimeChargeStateMassTolerances]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,ChargeStateMassTolerances]],
		Replace[ColumnPrimeIsotopeMassDifferences]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,IsotopeMassDifferences]],
		Replace[ColumnPrimeIsotopeRatios]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,IsotopeRatios]],
		Replace[ColumnPrimeIsotopeDetectionMinimums]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,IsotopeDetectionMinimums]],
		Replace[ColumnPrimeIsotopeRatioTolerances]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,IsotopeRatioTolerances]],
		Replace[ColumnPrimeIsotopeMassTolerances]->If[primeQ,Lookup[noReplaceColumnPrimeMassAcquisitionPacket,IsotopeMassTolerances]],
		ColumnPrimeAbsorbanceSelection->columnPrimeAbsorbanceSelection,
		ColumnPrimeMinAbsorbanceWavelength->FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnPrimeMinAbsorbanceWavelengths]],
		ColumnPrimeMaxAbsorbanceWavelength->FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnPrimeMaxAbsorbanceWavelengths]],
		ColumnPrimeWavelengthResolution->FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnPrimeWavelengthResolutions]],
		ColumnPrimeUVFilter->FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnPrimeUVFilters]],
		ColumnPrimeAbsorbanceSamplingRate->FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnPrimeAbsorbanceSamplingRates]]
	];
	
	ClearAll[protocolPacketChunk3];
	
	protocolPacketChunk3=Association[
		SampleTemperature->Lookup[hplcProtocolPacket,SampleTemperature],
		Replace[SampleVolumes]->Lookup[hplcProtocolPacket,Replace[InjectionVolumes]],
		(* We will create Cover resources in the compiler, when we have the WorkingContainers and can prepare resources that are index matched to the WorkingContainers field *)
		Replace[GradientAs]->Lookup[hplcProtocolPacket,Replace[GradientA]],
		Replace[IsocraticGradientA]->Lookup[hplcProtocolPacket,Replace[IsocraticGradientA]],
		Replace[GradientBs]->Lookup[hplcProtocolPacket,Replace[GradientB]],
		Replace[IsocraticGradientB]->Lookup[hplcProtocolPacket,Replace[IsocraticGradientB]],
		Replace[GradientCs]->Lookup[hplcProtocolPacket,Replace[GradientC]],
		Replace[IsocraticGradientC]->Lookup[hplcProtocolPacket,Replace[IsocraticGradientC]],
		Replace[GradientDs]->Lookup[hplcProtocolPacket,Replace[GradientD]],
		Replace[IsocraticGradientD]->Lookup[hplcProtocolPacket,Replace[IsocraticGradientD]],
		Replace[FlowRateConstant]->Lookup[hplcProtocolPacket,Replace[FlowRateConstant]],
		Replace[FlowRateVariable]->Lookup[hplcProtocolPacket,Replace[FlowRateVariable]],
		Replace[ColumnTemperatures] -> Lookup[hplcProtocolPacket,Replace[ColumnTemperatures]],
		Replace[GradientMethods]->Lookup[hplcProtocolPacket,Replace[Gradients]],

		Calibrant->Link@calibrantResource,
		SecondCalibrant->Link[secondCalibrantModel],
		(* QTOF specific resources *)
		(* Syringe used to purge MS lines *)
		Replace[PrimingSyringe] -> If[tripleQuadQ, Null, Link[Resource[Sample -> Model[Item, Consumable, "id:9RdZXvdkxzGZ"], Rent -> True]]],

		(*	QQQ specific other resources*)
		Replace[UniqueCalibrants]->If[tripleQuadQ,({Link@calibrantResource,Link@secondCalibrantResource}/.{Null->Nothing}),Null],
		Replace[CalibrantInfusionVolumes]->If[tripleQuadQ,({calibrantResource,secondCalibrantResource}/.{Null->Nothing,_Resource -> 0.5 Milliliter}),Null],
		Replace[CalibrantInfusionSyringes]->If[tripleQuadQ,({calibrantSyringeResource,secondCalibrantSyringeResource}/.{Null->Nothing}),Null],
		Replace[CalibrantInfusionSyringeNeedles]->If[tripleQuadQ,({calibrantSyringeNeedleResource,secondCalibrantSyringeNeedleResource}/.{Null->Nothing}),Null],
		Replace[CalibrationLoopCounts]->If[tripleQuadQ,ConstantArray[0,Length[({calibrantResource,secondCalibrantResource}/.{Null->Nothing})]],Null],

		Sequence @@ If[tripleQuadQ,
			{
				CalibrantPrimeBuffer -> calibrantPrimeBufferResource,
				CalibrantPrimeInfusionSyringe -> calibrantPrimeInfusionSyringeResource,
				CalibrantPrimeInfusionVolume -> 1 Milliliter,
				CalibrantPrimeInfusionSyringeNeedle -> calibrantPrimeInfusionSyringeNeedleResource,
				CalibrantFlushBuffer -> calibrantFlushBufferResource,
				CalibrantFlushInfusionSyringe -> calibrantFlushInfusionSyringeResource,
				CalibrantFlushInfusionVolume -> 1 Milliliter,
				CalibrantFlushInfusionSyringeNeedle -> calibrantFlushInfusionSyringeNeedleResource
			},
			{Nothing}
		],

		(*	QQQ specific other resources *)
		EstimatedProcessingTime->If[tripleQuadQ,Round[(Lookup[hplcProtocolPacket,SeparationTime]+60Minute),10Minute],Null],
		SystemPrimeFlushPlate->If[tripleQuadQ,Link[systemPrimeFlushPlateResource],Null],
		(*---Connectors---*)
		
		(* Acquisition mode resource*)
		Replace[MassAcquisitionMethods]->Link/@sampleMAids,
		Replace[IonModes]->Lookup[noReplaceSampleMassAcquisitionPackets,IonMode],
		Replace[ESICapillaryVoltages]->Lookup[noReplaceSampleMassAcquisitionPackets,ESICapillaryVoltage],
		Replace[DesolvationTemperatures]->Lookup[noReplaceSampleMassAcquisitionPackets,DesolvationTemperature],
		Replace[DesolvationGasFlows]->Lookup[noReplaceSampleMassAcquisitionPackets,DesolvationGasFlow],
		Replace[SourceTemperatures]->Lookup[noReplaceSampleMassAcquisitionPackets,SourceTemperature],
		Replace[DeclusteringVoltages]->Lookup[noReplaceSampleMassAcquisitionPackets,DeclusteringVoltage],
		Replace[ConeGasFlows]->Lookup[noReplaceSampleMassAcquisitionPackets,ConeGasFlow],
		Replace[StepwaveVoltages]->Lookup[noReplaceSampleMassAcquisitionPackets,StepwaveVoltage],
		Replace[IonGuideVoltages]->Lookup[noReplaceSampleMassAcquisitionPackets,IonGuideVoltage],
		Replace[AcquisitionWindows]->Lookup[noReplaceSampleMassAcquisitionPackets,AcquisitionWindows]/.{x_Association :> Values[x]},
		Replace[AcquisitionModes]->Lookup[noReplaceSampleMassAcquisitionPackets,AcquisitionModes],
		Replace[Fragmentations]->Lookup[noReplaceSampleMassAcquisitionPackets,Fragmentations],
		Replace[MinMasses]->Lookup[noReplaceSampleMassAcquisitionPackets,MinMasses],
		Replace[MaxMasses]->Lookup[noReplaceSampleMassAcquisitionPackets,MaxMasses],
		Replace[MassSelections]->Lookup[noReplaceSampleMassAcquisitionPackets,MassSelections],
		Replace[ScanTimes]->Lookup[noReplaceSampleMassAcquisitionPackets,ScanTimes],
		Replace[FragmentMinMasses]->Lookup[noReplaceSampleMassAcquisitionPackets,FragmentMinMasses],
		Replace[FragmentMaxMasses]->Lookup[noReplaceSampleMassAcquisitionPackets,FragmentMaxMasses],
		Replace[FragmentMassSelections]->Lookup[noReplaceSampleMassAcquisitionPackets,FragmentMassSelections],
		Replace[CollisionEnergies]->Lookup[noReplaceSampleMassAcquisitionPackets,CollisionEnergies],
		Replace[DwellTimes]->Lookup[noReplaceSampleMassAcquisitionPackets,DwellTimes],
		Replace[CollisionCellExitVoltages]->Lookup[noReplaceSampleMassAcquisitionPackets,CollisionCellExitVoltages],
		Replace[MassDetectionStepSizes]->Lookup[noReplaceSampleMassAcquisitionPackets,MassDetectionStepSizes],
		Replace[MultipleReactionMonitoringAssays]->If[NullQ[Lookup[noReplaceSampleMassAcquisitionPackets,MultipleReactionMonitoringAssays]],Null,Lookup[noReplaceSampleMassAcquisitionPackets,MultipleReactionMonitoringAssays]],
		Replace[NeutralLosses]->Lookup[noReplaceSampleMassAcquisitionPackets,NeutralLosses],
		Replace[LowCollisionEnergies]->Lookup[noReplaceSampleMassAcquisitionPackets,LowCollisionEnergies],
		Replace[HighCollisionEnergies]->Lookup[noReplaceSampleMassAcquisitionPackets,HighCollisionEnergies],
		Replace[FinalLowCollisionEnergies]->Lookup[noReplaceSampleMassAcquisitionPackets,FinalLowCollisionEnergies],
		Replace[FinalHighCollisionEnergies]->Lookup[noReplaceSampleMassAcquisitionPackets,FinalHighCollisionEnergies],
		Replace[FragmentScanTimes]->Lookup[noReplaceSampleMassAcquisitionPackets,FragmentScanTimes],
		Replace[AcquisitionSurveys]->Lookup[noReplaceSampleMassAcquisitionPackets,AcquisitionSurveys],
		Replace[MinimumThresholds]->Lookup[noReplaceSampleMassAcquisitionPackets,MinimumThresholds],
		Replace[AcquisitionLimits]->Lookup[noReplaceSampleMassAcquisitionPackets,AcquisitionLimits],
		Replace[CycleTimeLimits]->Lookup[noReplaceSampleMassAcquisitionPackets,CycleTimeLimits],
		Replace[ExclusionDomains]->Lookup[noReplaceSampleMassAcquisitionPackets,ExclusionDomains],
		Replace[ExclusionMasses]->Lookup[noReplaceSampleMassAcquisitionPackets,ExclusionMasses],
		Replace[ExclusionMassTolerances]->Lookup[noReplaceSampleMassAcquisitionPackets,ExclusionMassTolerances],
		Replace[ExclusionRetentionTimeTolerances]->Lookup[noReplaceSampleMassAcquisitionPackets,ExclusionRetentionTimeTolerances],
		Replace[InclusionDomains]->Lookup[noReplaceSampleMassAcquisitionPackets,InclusionDomains],
		Replace[InclusionMasses]->Lookup[noReplaceSampleMassAcquisitionPackets,InclusionMasses],
		Replace[InclusionCollisionEnergies]->Lookup[noReplaceSampleMassAcquisitionPackets,InclusionCollisionEnergies],
		Replace[InclusionDeclusteringVoltages]->Lookup[noReplaceSampleMassAcquisitionPackets,InclusionDeclusteringVoltages],
		Replace[InclusionChargeStates]->Lookup[noReplaceSampleMassAcquisitionPackets,InclusionChargeStates],
		Replace[InclusionScanTimes]->Lookup[noReplaceSampleMassAcquisitionPackets,InclusionScanTimes],
		Replace[InclusionMassTolerances]->Lookup[noReplaceSampleMassAcquisitionPackets,InclusionMassTolerances],
		Replace[ChargeStateLimits]->Lookup[noReplaceSampleMassAcquisitionPackets,ChargeStateLimits],
		Replace[ChargeStateSelections]->Lookup[noReplaceSampleMassAcquisitionPackets,ChargeStateSelections],
		Replace[ChargeStateMassTolerances]->Lookup[noReplaceSampleMassAcquisitionPackets,ChargeStateMassTolerances],
		Replace[IsotopeMassDifferences]->Lookup[noReplaceSampleMassAcquisitionPackets,IsotopeMassDifferences],
		Replace[IsotopeRatios]->Lookup[noReplaceSampleMassAcquisitionPackets,IsotopeRatios],
		Replace[IsotopeDetectionMinimums]->Lookup[noReplaceSampleMassAcquisitionPackets,IsotopeDetectionMinimums],
		Replace[IsotopeRatioTolerances]->Lookup[noReplaceSampleMassAcquisitionPackets,IsotopeRatioTolerances],
		Replace[IsotopeMassTolerances]->Lookup[noReplaceSampleMassAcquisitionPackets,IsotopeMassTolerances],
		Replace[AbsorbanceSelection]->Lookup[hplcProtocolPacket,Replace[AbsorbanceWavelength]],
		Replace[MinAbsorbanceWavelengths]->Lookup[hplcProtocolPacket,Replace[MinAbsorbanceWavelength]],
		Replace[MaxAbsorbanceWavelengths]->Lookup[hplcProtocolPacket,Replace[MaxAbsorbanceWavelength]],
		Replace[WavelengthResolutions]->Lookup[hplcProtocolPacket,Replace[WavelengthResolution]],
		Replace[UVFilters]->Lookup[hplcProtocolPacket,Replace[UVFilter]],
		Replace[AbsorbanceSamplingRates]->Lookup[hplcProtocolPacket,Replace[AbsorbanceSamplingRate]]
	];

	protocolPacketChunk4=Association[
		Replace[Standards]->Lookup[hplcProtocolPacket,Replace[Standards]],
		Replace[StandardSampleVolumes]->Lookup[hplcProtocolPacket,Replace[StandardSampleVolumes]],
		Replace[StandardGradientMethods]->Lookup[hplcProtocolPacket,Replace[StandardGradients]],
		Replace[StandardGradientAs]->Lookup[hplcProtocolPacket,Replace[StandardGradientA]],
		Replace[StandardIsocraticGradientA]->Lookup[hplcProtocolPacket,Replace[StandardIsocraticGradientA]],
		Replace[StandardGradientBs]->Lookup[hplcProtocolPacket,Replace[StandardGradientB]],
		Replace[StandardIsocraticGradientB]->Lookup[hplcProtocolPacket,Replace[StandardIsocraticGradientB]],
		Replace[StandardGradientCs]->Lookup[hplcProtocolPacket,Replace[StandardGradientC]],
		Replace[StandardIsocraticGradientC]->Lookup[hplcProtocolPacket,Replace[StandardIsocraticGradientC]],
		Replace[StandardGradientDs]->Lookup[hplcProtocolPacket,Replace[StandardGradientD]],
		Replace[StandardIsocraticGradientD]->Lookup[hplcProtocolPacket,Replace[StandardIsocraticGradientD]],
		Replace[StandardFlowRateConstant]->Lookup[hplcProtocolPacket,Replace[StandardFlowRateConstant]],
		Replace[StandardFlowRateVariable]->Lookup[hplcProtocolPacket,Replace[StandardFlowRateVariable]],
		Replace[StandardColumnTemperatures]->Lookup[hplcProtocolPacket,Replace[StandardColumnTemperatures]],
		Replace[StandardMassAcquisitionMethods]-> If[standardsQ, Link/@expandedStandardsMAids],
		Replace[StandardIonModes]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,IonMode]],
		Replace[StandardESICapillaryVoltages]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,ESICapillaryVoltage]],
		Replace[StandardDesolvationTemperatures]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,DesolvationTemperature]],
		Replace[StandardDesolvationGasFlows]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,DesolvationGasFlow]],
		Replace[StandardSourceTemperatures]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,SourceTemperature]],
		Replace[StandardDeclusteringVoltages]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,DeclusteringVoltage]],
		Replace[StandardConeGasFlows]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,ConeGasFlow]],
		Replace[StandardStepwaveVoltages]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,StepwaveVoltage]],
		Replace[StandardIonGuideVoltages]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,IonGuideVoltage]],
		Replace[StandardAcquisitionWindows]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,AcquisitionWindows]]/.{x_Association :> Values[x]},
		Replace[StandardAcquisitionModes]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,AcquisitionModes]],
		Replace[StandardFragmentations]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,Fragmentations]],
		Replace[StandardMinMasses]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,MinMasses]],
		Replace[StandardMaxMasses]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,MaxMasses]],
		Replace[StandardMassSelections]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,MassSelections]],
		Replace[StandardScanTimes]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,ScanTimes]],
		Replace[StandardFragmentMinMasses]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,FragmentMinMasses]],
		Replace[StandardFragmentMaxMasses]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,FragmentMaxMasses]],
		Replace[StandardFragmentMassSelections]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,FragmentMassSelections]],
		Replace[StandardCollisionEnergies]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,CollisionEnergies]],
		Replace[StandardDwellTimes]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,DwellTimes]],
		Replace[StandardCollisionCellExitVoltages]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,CollisionCellExitVoltages]],
		Replace[StandardMassDetectionStepSizes]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,MassDetectionStepSizes]],
		Replace[StandardMultipleReactionMonitoringAssays]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,MultipleReactionMonitoringAssays]],
		Replace[StandardNeutralLosses]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,NeutralLosses]],
		Replace[StandardLowCollisionEnergies]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,LowCollisionEnergies]],
		Replace[StandardHighCollisionEnergies]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,HighCollisionEnergies]],
		Replace[StandardFinalLowCollisionEnergies]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,FinalLowCollisionEnergies]],
		Replace[StandardFinalHighCollisionEnergies]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,FinalHighCollisionEnergies]],
		Replace[StandardFragmentScanTimes]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,FragmentScanTimes]],
		Replace[StandardAcquisitionSurveys]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,AcquisitionSurveys]],
		Replace[StandardMinimumThresholds]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,MinimumThresholds]],
		Replace[StandardAcquisitionLimits]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,AcquisitionLimits]],
		Replace[StandardCycleTimeLimits]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,CycleTimeLimits]],
		Replace[StandardExclusionDomains]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,ExclusionDomains]],
		Replace[StandardExclusionMasses]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,ExclusionMasses]],
		Replace[StandardExclusionMassTolerances]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,ExclusionMassTolerances]],
		Replace[StandardExclusionRetentionTimeTolerances]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,ExclusionRetentionTimeTolerances]],
		Replace[StandardInclusionDomains]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,InclusionDomains]],
		Replace[StandardInclusionMasses]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,InclusionMasses]],
		Replace[StandardInclusionCollisionEnergies]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,InclusionCollisionEnergies]],
		Replace[StandardInclusionDeclusteringVoltages]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,InclusionDeclusteringVoltages]],
		Replace[StandardInclusionChargeStates]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,InclusionChargeStates]],
		Replace[StandardInclusionScanTimes]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,InclusionScanTimes]],
		Replace[StandardInclusionMassTolerances]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,InclusionMassTolerances]],
		Replace[StandardChargeStateLimits]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,ChargeStateLimits]],
		Replace[StandardChargeStateSelections]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,ChargeStateSelections]],
		Replace[StandardChargeStateMassTolerances]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,ChargeStateMassTolerances]],
		Replace[StandardIsotopeMassDifferences]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,IsotopeMassDifferences]],
		Replace[StandardIsotopeRatios]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,IsotopeRatios]],
		Replace[StandardIsotopeDetectionMinimums]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,IsotopeDetectionMinimums]],
		Replace[StandardIsotopeRatioTolerances]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,IsotopeRatioTolerances]],
		Replace[StandardIsotopeMassTolerances]->If[standardsQ,Lookup[noReplaceStandardMassAcquisitionPackets,IsotopeMassTolerances]],
		Replace[StandardAbsorbanceSelection]->Lookup[hplcProtocolPacket,Replace[StandardAbsorbanceWavelength]],
		Replace[StandardMinAbsorbanceWavelengths]->Lookup[hplcProtocolPacket,Replace[StandardMinAbsorbanceWavelength]],
		Replace[StandardMaxAbsorbanceWavelengths]->Lookup[hplcProtocolPacket,Replace[StandardMaxAbsorbanceWavelength]],
		Replace[StandardWavelengthResolutions]->Lookup[hplcProtocolPacket,Replace[StandardWavelengthResolution]],
		Replace[StandardUVFilters]->Lookup[hplcProtocolPacket,Replace[StandardUVFilter]],
		Replace[StandardAbsorbanceSamplingRates]->Lookup[hplcProtocolPacket,Replace[StandardAbsorbanceSamplingRate]],
		Replace[StandardsStorageConditions]->Lookup[hplcProtocolPacket,Replace[StandardsStorageConditions]]
	];
	protocolPacketChunk5=Association[
		Replace[Blanks]->Lookup[hplcProtocolPacket,Replace[Blanks]],
		Replace[BlankSampleVolumes]->Lookup[hplcProtocolPacket,Replace[BlankSampleVolumes]],
		Replace[BlankGradientMethods]->Lookup[hplcProtocolPacket,Replace[BlankGradients]],
		Replace[BlankGradientAs]->Lookup[hplcProtocolPacket,Replace[BlankGradientA]],
		Replace[BlankIsocraticGradientA]->Lookup[hplcProtocolPacket,Replace[BlankIsocraticGradientA]],
		Replace[BlankGradientBs]->Lookup[hplcProtocolPacket,Replace[BlankGradientB]],
		Replace[BlankIsocraticGradientB]->Lookup[hplcProtocolPacket,Replace[BlankIsocraticGradientB]],
		Replace[BlankGradientCs]->Lookup[hplcProtocolPacket,Replace[BlankGradientC]],
		Replace[BlankIsocraticGradientC]->Lookup[hplcProtocolPacket,Replace[BlankIsocraticGradientC]],
		Replace[BlankGradientDs]->Lookup[hplcProtocolPacket,Replace[BlankGradientD]],
		Replace[BlankIsocraticGradientD]->Lookup[hplcProtocolPacket,Replace[BlankIsocraticGradientD]],
		Replace[BlankFlowRateConstant]->Lookup[hplcProtocolPacket,Replace[BlankFlowRateConstant]],
		Replace[BlankFlowRateVariable]->Lookup[hplcProtocolPacket,Replace[BlankFlowRateVariable]],
		Replace[BlankColumnTemperatures]->Lookup[hplcProtocolPacket,Replace[BlankColumnTemperatures]],
		Replace[BlankMassAcquisitionMethods]-> If[blanksQ, Link/@expandedBlanksMAids],
		Replace[BlankIonModes]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,IonMode]],
		Replace[BlankESICapillaryVoltages]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,ESICapillaryVoltage]],
		Replace[BlankDesolvationTemperatures]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,DesolvationTemperature]],
		Replace[BlankDesolvationGasFlows]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,DesolvationGasFlow]],
		Replace[BlankSourceTemperatures]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,SourceTemperature]],
		Replace[BlankDeclusteringVoltages]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,DeclusteringVoltage]],
		Replace[BlankConeGasFlows]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,ConeGasFlow]],
		Replace[BlankStepwaveVoltages]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,StepwaveVoltage]],
		Replace[BlankIonGuideVoltages]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,IonGuideVoltage]],
		Replace[BlankAcquisitionWindows]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,AcquisitionWindows]]/.{x_Association :> Values[x]},
		Replace[BlankAcquisitionModes]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,AcquisitionModes]],
		Replace[BlankFragmentations]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,Fragmentations]],
		Replace[BlankMinMasses]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,MinMasses]],
		Replace[BlankMaxMasses]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,MaxMasses]],
		Replace[BlankMassSelections]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,MassSelections]],
		Replace[BlankScanTimes]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,ScanTimes]],
		Replace[BlankFragmentMinMasses]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,FragmentMinMasses]],
		Replace[BlankFragmentMaxMasses]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,FragmentMaxMasses]],
		Replace[BlankFragmentMassSelections]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,FragmentMassSelections]],
		Replace[BlankCollisionEnergies]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,CollisionEnergies]],
		Replace[BlankDwellTimes]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,DwellTimes]],
		Replace[BlankCollisionCellExitVoltages]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,CollisionCellExitVoltages]],
		Replace[BlankMassDetectionStepSizes]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,MassDetectionStepSizes]],
		Replace[BlankMultipleReactionMonitoringAssays]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,MultipleReactionMonitoringAssays]],
		Replace[BlankNeutralLosses]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,NeutralLosses]],
		Replace[BlankLowCollisionEnergies]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,LowCollisionEnergies]],
		Replace[BlankHighCollisionEnergies]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,HighCollisionEnergies]],
		Replace[BlankFinalLowCollisionEnergies]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,FinalLowCollisionEnergies]],
		Replace[BlankFinalHighCollisionEnergies]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,FinalHighCollisionEnergies]],
		Replace[BlankFragmentScanTimes]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,FragmentScanTimes]],
		Replace[BlankAcquisitionSurveys]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,AcquisitionSurveys]],
		Replace[BlankMinimumThresholds]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,MinimumThresholds]],
		Replace[BlankAcquisitionLimits]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,AcquisitionLimits]],
		Replace[BlankCycleTimeLimits]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,CycleTimeLimits]],
		Replace[BlankExclusionDomains]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,ExclusionDomains]],
		Replace[BlankExclusionMasses]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,ExclusionMasses]],
		Replace[BlankExclusionMassTolerances]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,ExclusionMassTolerances]],
		Replace[BlankExclusionRetentionTimeTolerances]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,ExclusionRetentionTimeTolerances]],
		Replace[BlankInclusionDomains]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,InclusionDomains]],
		Replace[BlankInclusionMasses]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,InclusionMasses]],
		Replace[BlankInclusionCollisionEnergies]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,InclusionCollisionEnergies]],
		Replace[BlankInclusionDeclusteringVoltages]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,InclusionDeclusteringVoltages]],
		Replace[BlankInclusionChargeStates]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,InclusionChargeStates]],
		Replace[BlankInclusionScanTimes]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,InclusionScanTimes]],
		Replace[BlankInclusionMassTolerances]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,InclusionMassTolerances]],
		Replace[BlankChargeStateLimits]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,ChargeStateLimits]],
		Replace[BlankChargeStateSelections]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,ChargeStateSelections]],
		Replace[BlankChargeStateMassTolerances]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,ChargeStateMassTolerances]],
		Replace[BlankIsotopeMassDifferences]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,IsotopeMassDifferences]],
		Replace[BlankIsotopeRatios]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,IsotopeRatios]],
		Replace[BlankIsotopeDetectionMinimums]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,IsotopeDetectionMinimums]],
		Replace[BlankIsotopeRatioTolerances]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,IsotopeRatioTolerances]],
		Replace[BlankIsotopeMassTolerances]->If[blanksQ,Lookup[noReplaceBlankMassAcquisitionPackets,IsotopeMassTolerances]],
		Replace[BlankAbsorbanceSelection]->Lookup[hplcProtocolPacket,Replace[BlankAbsorbanceWavelength]],
		Replace[BlankMinAbsorbanceWavelengths]->Lookup[hplcProtocolPacket,Replace[BlankMinAbsorbanceWavelength]],
		Replace[BlankMaxAbsorbanceWavelengths]->Lookup[hplcProtocolPacket,Replace[BlankMaxAbsorbanceWavelength]],
		Replace[BlankWavelengthResolutions]->Lookup[hplcProtocolPacket,Replace[BlankWavelengthResolution]],
		Replace[BlankUVFilters]->Lookup[hplcProtocolPacket,Replace[BlankUVFilter]],
		Replace[BlankAbsorbanceSamplingRates]->Lookup[hplcProtocolPacket,Replace[BlankAbsorbanceSamplingRate]],
		Replace[BlanksStorageConditions]->Lookup[hplcProtocolPacket,Replace[BlanksStorageConditions]]
	];
	protocolPacketChunk6=Association[
		(*column flushs are multiple in the new HPLC*)
		ColumnFlushGradientMethod->FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnFlushGradients]],
		Replace[ColumnFlushGradientA]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnFlushGradientAs],Nothing]],
		Replace[ColumnFlushIsocraticGradientA]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnFlushIsocraticGradientAs],Nothing]],
		Replace[ColumnFlushGradientB]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnFlushGradientBs],Nothing]],
		Replace[ColumnFlushIsocraticGradientB]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnFlushIsocraticGradientBs],Nothing]],
		Replace[ColumnFlushGradientC]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnFlushGradientCs],Nothing]],
		Replace[ColumnFlushIsocraticGradientC]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnFlushIsocraticGradientCs],Nothing]],
		Replace[ColumnFlushGradientD]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnFlushGradientDs],Nothing]],
		Replace[ColumnFlushIsocraticGradientD]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnFlushIsocraticGradientDs],Nothing]],
		Replace[ColumnFlushFlowRateConstant]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnFlushFlowRateConstant],Nothing]],
		Replace[ColumnFlushFlowRateVariable]->List[FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnFlushFlowRateVariable],Nothing]],
		ColumnFlushTemperature->FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnFlushTemperatures],{}],
		ColumnFlushMassAcquisitionMethod->If[flushQ, Link@columnFlushMAid],
		ColumnFlushIonMode->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,IonMode]],
		ColumnFlushESICapillaryVoltage->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,ESICapillaryVoltage]],
		ColumnFlushDesolvationTemperature->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,DesolvationTemperature]],
		ColumnFlushDesolvationGasFlow->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,DesolvationGasFlow]],
		ColumnFlushSourceTemperature->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,SourceTemperature]],
		ColumnFlushDeclusteringVoltage->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,DeclusteringVoltage]],
		ColumnFlushConeGasFlow->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,ConeGasFlow]],
		ColumnFlushStepwaveVoltage->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,StepwaveVoltage]],
		ColumnFlushIonGuideVoltage->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,IonGuideVoltage]],
		Replace[ColumnFlushAcquisitionWindows]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,AcquisitionWindows]],
		Replace[ColumnFlushAcquisitionModes]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,AcquisitionModes]],
		Replace[ColumnFlushFragmentations]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,Fragmentations]],
		Replace[ColumnFlushMinMasses]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,MinMasses]],
		Replace[ColumnFlushMaxMasses]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,MaxMasses]],
		Replace[ColumnFlushMassSelections]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,MassSelections]],
		Replace[ColumnFlushScanTimes]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,ScanTimes]],
		Replace[ColumnFlushFragmentMinMasses]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,FragmentMinMasses]],
		Replace[ColumnFlushFragmentMaxMasses]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,FragmentMaxMasses]],
		Replace[ColumnFlushFragmentMassSelections]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,FragmentMassSelections]],
		Replace[ColumnFlushCollisionEnergies]->If[flushQ,Flatten[Lookup[noReplaceColumnFlushMassAcquisitionPacket,CollisionEnergies]]],
		Replace[ColumnFlushDwellTimes]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,DwellTimes]],
		Replace[ColumnFlushCollisionCellExitVoltages]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,CollisionCellExitVoltages]],
		Replace[ColumnFlushMassDetectionStepSizes]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,MassDetectionStepSizes]],
		Replace[ColumnFlushMultipleReactionMonitoringAssays]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,MultipleReactionMonitoringAssays]],
		Replace[ColumnFlushNeutralLosses]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,NeutralLosses]],
		Replace[ColumnFlushLowCollisionEnergies]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,LowCollisionEnergies]],
		Replace[ColumnFlushHighCollisionEnergies]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,HighCollisionEnergies]],
		Replace[ColumnFlushFinalLowCollisionEnergies]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,FinalLowCollisionEnergies]],
		Replace[ColumnFlushFinalHighCollisionEnergies]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,FinalHighCollisionEnergies]],
		Replace[ColumnFlushFragmentScanTimes]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,FragmentScanTimes]],
		Replace[ColumnFlushAcquisitionSurveys]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,AcquisitionSurveys]],
		Replace[ColumnFlushMinimumThresholds]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,MinimumThresholds]],
		Replace[ColumnFlushAcquisitionLimits]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,AcquisitionLimits]],
		Replace[ColumnFlushCycleTimeLimits]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,CycleTimeLimits]],
		Replace[ColumnFlushExclusionDomains]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,ExclusionDomains]],
		Replace[ColumnFlushExclusionMasses]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,ExclusionMasses]],
		Replace[ColumnFlushExclusionMassTolerances]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,ExclusionMassTolerances]],
		Replace[ColumnFlushExclusionRetentionTimeTolerances]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,ExclusionRetentionTimeTolerances]],
		Replace[ColumnFlushInclusionDomains]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,InclusionDomains]],
		Replace[ColumnFlushInclusionMasses]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,InclusionMasses]],
		Replace[ColumnFlushInclusionCollisionEnergies]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,InclusionCollisionEnergies]],
		Replace[ColumnFlushInclusionDeclusteringVoltages]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,InclusionDeclusteringVoltages]],
		Replace[ColumnFlushInclusionChargeStates]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,InclusionChargeStates]],
		Replace[ColumnFlushInclusionScanTimes]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,InclusionScanTimes]],
		Replace[ColumnFlushInclusionMassTolerances]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,InclusionMassTolerances]],
		Replace[ColumnFlushChargeStateLimits]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,ChargeStateLimits]],
		Replace[ColumnFlushChargeStateSelections]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,ChargeStateSelections]],
		Replace[ColumnFlushChargeStateMassTolerances]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,ChargeStateMassTolerances]],
		Replace[ColumnFlushIsotopeMassDifferences]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,IsotopeMassDifferences]],
		Replace[ColumnFlushIsotopeRatios]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,IsotopeRatios]],
		Replace[ColumnFlushIsotopeDetectionMinimums]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,IsotopeDetectionMinimums]],
		Replace[ColumnFlushIsotopeRatioTolerances]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,IsotopeRatioTolerances]],
		Replace[ColumnFlushIsotopeMassTolerances]->If[flushQ,Lookup[noReplaceColumnFlushMassAcquisitionPacket,IsotopeMassTolerances]],
		ColumnFlushAbsorbanceSelection->columnFlushAbsorbanceSelection,
		ColumnFlushMinAbsorbanceWavelength->FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnFlushMinAbsorbanceWavelengths]],
		ColumnFlushMaxAbsorbanceWavelength->FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnFlushMaxAbsorbanceWavelengths]],
		ColumnFlushWavelengthResolution->FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnFlushWavelengthResolutions]],
		ColumnFlushUVFilter->FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnFlushUVFilters]],
		ColumnFlushAbsorbanceSamplingRate->FirstOrDefault@Lookup[hplcProtocolPacket,Replace[ColumnFlushAbsorbanceSamplingRates]],

		SystemFlushBufferA->Lookup[hplcProtocolPacket,SystemFlushBufferA],
		SystemFlushBufferB->Lookup[hplcProtocolPacket,SystemFlushBufferB],
		SystemFlushBufferC->Lookup[hplcProtocolPacket,SystemFlushBufferC],
		SystemFlushBufferD->Lookup[hplcProtocolPacket,SystemFlushBufferD],
		Replace[SystemFlushBufferContainerPlacements]->Lookup[hplcProtocolPacket,Replace[SystemFlushBufferContainerPlacements]],
		SystemFlushGradient->Lookup[hplcProtocolPacket,SystemFlushGradient],
		SystemFlushMassAcquisitionMethod->If[tripleQuadQ,Link@Object[Method, MassAcquisition, "System Prime Flush MS Method For ESI-QQQ"],Link@Object[Method, MassAcquisition, "System Prime Flush MS Method"]],
		
		TubingRinseSolution->Link[
			Resource[
				(* Milli-Q water *)
				Sample->Model[Sample,"id:8qZ1VWNmdLBD"],
				Amount->500 Milli Liter,
				(* 1000 mL Glass Beaker *)
				Container->Model[Container,Vessel,"id:O81aEB4kJJJo"],
				RentContainer->True
			]
		],
		
		Replace[Checkpoints] -> checkpoints,
		NumberOfReplicates -> numberOfReplicates,
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions -> updatedResolvedOptions
	];

	(*combine all of the chunks*)
	protocolPacket=Join[
		protocolPacketChunk1,
		protocolPacketChunk2,
		protocolPacketChunk3,
		protocolPacketChunk4,
		protocolPacketChunk5,
		protocolPacketChunk6,
		sharedFieldPacket
	];

	(*get all of the gradient packets from the HPLC resource packet function*)
	gradientPackets=Cases[hplcResourcePackets,PacketP[Object[Method,Gradient]]];

	(*combine all of the packets for upload*)
	allPackets=Flatten@{
		protocolPacket,
		gradientPackets,
		maPacketsToUpload,
		allUnitOperationPacket
	};

	(* Extract all resources *)
	allResources = DeleteDuplicates[Cases[allPackets,_Resource,Infinity]];

	(* Check fulfillability to resources *)
	{resourcesFulfillableQ,resourceTests} = If[gatherTestsQ,
		Resources`Private`fulfillableResourceQ[allResources,Site->Lookup[myResolvedOptions,Site],Output->{Result,Tests},Cache -> cache, Simulation -> simulation],
		{Resources`Private`fulfillableResourceQ[allResources,Site->Lookup[myResolvedOptions,Site],Cache -> cache, Simulation -> simulation],{}}
	];

	(* Return requested output *)
	outputSpecification/.{
		Result -> If[resourcesFulfillableQ,
			allPackets,
			{$Failed,$Failed}
		],
		Tests -> Append[resourceTests,massAcquisitionPacketChangeTest]
	}

];



(* ::Subsection::Closed:: *)
(*ExperimentLCMSPreview*)


(* ::Subsubsection:: *)
(*ExperimentLCMSPreview*)


DefineOptions[ExperimentLCMSPreview,
	SharedOptions :> {ExperimentLCMS}
];

ExperimentLCMSPreview[myObjects:ListableP[ObjectP[Object[Container]]]|ListableP[(ObjectP[Object[Sample]]|_String)],myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the preview for ExperimentLCMS *)
	ExperimentLCMS[myObjects, Append[noOutputOptions, Output -> Preview]]
];



(* ::Subsection::Closed:: *)
(*ExperimentLCMSOptions*)


(* ::Subsubsection:: *)
(*ExperimentLCMSOptions*)


DefineOptions[ExperimentLCMSOptions,
	Options:>{
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table|List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category->"General"
		}
	},
	SharedOptions :> {ExperimentLCMS}
];

ExperimentLCMSOptions[myObjects:ListableP[ObjectP[Object[Container]]]|ListableP[(ObjectP[{Object[Sample],Model[Sample]}]|_String)],myOptions:OptionsPattern[]]:=Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, (Output -> _) | (OutputFormat->_)];

	(* return only the preview for ExperimentLCMS *)
	options = ExperimentLCMS[myObjects, Append[noOutputOptions, Output -> Options]];

	(* If options fail, return failure *)
	If[MatchQ[options,$Failed],
		Return[$Failed]
	];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions,OutputFormat,Table],Table],
		LegacySLL`Private`optionsToTable[options,ExperimentLCMS],
		options
	]
];



(* ::Subsection:: *)
(*ValidExperimentLCMSQ*)


(* ::Subsubsection:: *)
(*ValidExperimentLCMSQ*)


DefineOptions[ValidExperimentLCMSQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentLCMS}
];


ValidExperimentLCMSQ[myObjects:ListableP[ObjectP[Object[Container]]]|ListableP[(ObjectP[{Object[Sample],Model[Sample]}]|_String)],myOptions:OptionsPattern[]]:=Module[
	{listedObjects,listedOptions,preparedOptions,lcmsTests,validObjectBooleans,voqWarnings,
		allTests,verbose,outputFormat},

	(* get the objects and options as a list *)
	listedObjects = ToList[myObjects];
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentLCMS *)
	lcmsTests = ExperimentLCMS[listedObjects, Append[preparedOptions, Output -> Tests]];

	(* Create warnings for invalid objects *)
	validObjectBooleans = ValidObjectQ[DeleteCases[listedObjects,_String], OutputFormat -> Boolean];
	voqWarnings = MapThread[
		Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
			#2,
			True
		]&,
		{DeleteCases[listedObjects,_String], validObjectBooleans}
	];

	(* Make a list of all the tests *)
	allTests = Join[lcmsTests,voqWarnings];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentLCMSQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentLCMSQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentLCMSQ"]
];

(*helper function used throughout to split a time window*)
(*endTime=10 Min and n=2 -> {0 Minute;;5Minute,5.01Minute;;10Minute}*)
splitTime[endTime:GreaterP[0Minute],n_Integer]:=splitTime[0 Minute,endTime,n];
splitTime[startTime:GreaterEqualP[0 Minute],endTime:GreaterP[0Minute],n_Integer]:=Module[{delta,startingTimes,
	endingTimes, shiftedEndingTimes},
	(*define the unitless delta*)
	delta=N[(Unitless[endTime,Minute]-Unitless[startTime,Minute])/n];
	(*these will be the start times for each span*)
	startingTimes=Round[Most@Range[Unitless[startTime,Minute], Unitless[endTime,Minute], delta],0.01]*Minute;
	(*the ending times for each span.*)
	endingTimes=Round[Rest@Range[Unitless[startTime,Minute], Unitless[endTime,Minute], delta],0.01];
	(*we want to shift the first part of this by 0.01 Minute*)
	shiftedEndingTimes=MapAt[#-0.01&,endingTimes,;;-2]*Minute;
	(*generate our spans and return them*)
	MapThread[Span,{startingTimes,shiftedEndingTimes}]
];

(*helper function to define the mass ranges for the different groups of biomolecules*)
massRangeAnalyteType[input:MSAnalyteGroupP]:=Switch[input,
	All|{All}, Span[2Gram/Mole,100000Gram/Mole],
	Peptide, Span[2Gram/Mole,3940Gram/Mole],
	SmallMolecule, Span[2Gram/Mole,2000Gram/Mole],
	Protein, Span[2Gram/Mole,20000Gram/Mole]
];

(*define the HPLC options used by LCMS*)
commonHPLCAndLCMSOptions:={SeparationMode, ColumnSelector, GuardColumn, Column, SecondaryColumn, TertiaryColumn, NumberOfReplicates,
	BufferA, BufferB, BufferC, BufferD, SampleTemperature, InjectionVolume, NeedleWashSolution, GradientA, GradientB, GradientC, GradientD,
	FlowRate, MaxAcceleration, Gradient, ColumnTemperature,
	AbsorbanceWavelength, WavelengthResolution, UVFilter, AbsorbanceSamplingRate, Standard, StandardInjectionVolume,
	StandardGradientA, StandardGradientB, StandardGradientC, StandardGradientD, StandardFlowRate, StandardGradient, StandardColumnTemperature,
	StandardAbsorbanceWavelength, StandardWavelengthResolution, StandardUVFilter, StandardAbsorbanceSamplingRate, StandardStorageCondition,
	Blank, BlankInjectionVolume, BlankGradientA, BlankGradientB, BlankGradientC, BlankGradientD, BlankFlowRate, BlankGradient, BlankColumnTemperature,
	BlankAbsorbanceWavelength, BlankWavelengthResolution, BlankUVFilter, BlankAbsorbanceSamplingRate, BlankStorageCondition,
	ColumnRefreshFrequency, ColumnPrimeGradientA, ColumnPrimeGradientB, ColumnPrimeGradientC, ColumnPrimeGradientD, ColumnPrimeFlowRate, ColumnPrimeGradient, ColumnPrimeTemperature,
	ColumnPrimeAbsorbanceWavelength, ColumnPrimeWavelengthResolution, ColumnPrimeUVFilter, ColumnPrimeAbsorbanceSamplingRate,
	ColumnFlushGradientA, ColumnFlushGradientB, ColumnFlushGradientC, ColumnFlushGradientD, ColumnFlushFlowRate, ColumnFlushGradient, ColumnFlushTemperature,
	ColumnFlushAbsorbanceWavelength, ColumnFlushWavelengthResolution, ColumnFlushUVFilter, ColumnFlushAbsorbanceSamplingRate,
	Confirm, CanaryBranch, Name, Upload, Email
};


(* ::Subsubsection:: *)
(* MassSpectrometryScan Primitive Definition *)

(* NOTE: This primitive will not be hooked up to the primitive framework and is for internal use in ImageCells only. *)
(* Therefore, we set ExperimentFunction->None since the framework doesn't need to resolve it for us. *)
massSpectrometryScanPrimitive=Module[{massSpecSharedOptions},
	massSpecSharedOptions={
		AcquisitionWindow,
		AcquisitionMode,
		Fragmentation,
		MinMass,
		MaxMass,
		MassSelections,
		ScanTime,
		FragmentMinMass,
		FragmentMaxMasses,
		FragmentMassSelections,
		CollisionEnergies,
		LowCollisionEnergy,
		HighCollisionEnergy,
		FinalLowCollisionEnergy,
		FinalHighCollisionEnergy,
		FragmentScanTime,
		AcquisitionSurvey,
		MinimumThreshold,
		AcquisitionLimit,
		CycleTimeLimit,
		ExclusionDomain,
		ExclusionMass,
		ExclusionMassTolerance,
		ExclusionRetentionTimeTolerance,
		InclusionDomain,
		InclusionMass,
		InclusionCollisionEnergies,
		InclusionDeclusteringVoltages,
		InclusionChargeStates,
		InclusionScanTimes,
		InclusionMassTolerance,
		ChargeStateLimit,
		ChargeStateSelections,
		ChargeStateMassTolerance,
		IsotopeMassDifferences,
		IsotopeRatios,
		IsotopeDetectionMinimums,
		IsotopeRatioTolerance,
		IsotopeMassTolerance,
		CollisionCellExitVoltage,
		MassDetectionStepSize,
		NeutralLoss,
		DwellTime,
		MultipleReactionMonitoringAssays
		
	};
	
	
	DefinePrimitive[MassSpectrometryScan,
		With[
			{
				insertMe=Flatten[
					Cases[
						OptionDefinition[ExperimentLCMS],
						KeyValuePattern["OptionName" -> ToString[#]]] & /@ massSpecSharedOptions
				]
			},
			SharedOptions:>insertMe
		],
		ExperimentFunction->None,
		(* TODO get a new icon from design team *)
		Icon->Import[FileNameJoin[{PackageDirectory["Experiment`"],"resources","images","AcquireImage.png"}]],
		Generative->False,
		Category->"Mass Spectrometry",
		Description->"A set of parameters for acquiring the mass spec data of a specific acquisition window from a sample.",
		Author -> {"ryan.bisbey", "jireh.sacramento"}
	]
];


(* ::Subsubsection:: *)
(* Imaging Primitive Pattern *)


Clear[MassSpectrometryScanP];
DefinePrimitiveSet[
	MassSpectrometryScanP,
	{massSpectrometryScanPrimitive}
];

(* Assign the author *)
Authors[MassSpectrometryScan] = {"ryan.bisbey"};