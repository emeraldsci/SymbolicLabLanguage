(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Subsection:: *)
(* Options *)


(* NOTE: this is an updated resolver that Karthik was working on before LCMS became prioritized.
Since the updated resolver would serve better for LC/MS, working with it.
*)

(* ExperimentHPLC *)

DefineOptions[ExperimentHPLC,
	Options :> {
		{
			OptionName -> Instrument,
			Default -> Automatic,
			Description -> "A list of one or more measurement and collection devices to run the experiment on and that satisfy the Scale and Detector options.",
			ResolutionDescription -> "For FractionCollection option specification and/or for Scale->Preparative or SemiPreparative, automatically set to instrument models that have fraction collection capabilities. Otherwise, automatically set to instrument models that meet the requested Detector.",
			AllowNull -> True,
			Widget -> Alternatives[
				Widget[
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
				Adder[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Model[Instrument, HPLC]],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Instruments",
								"Chromatography",
								"High Pressure Liquid Chromatography (HPLC)"
							}
						}
					]
				]
			],
			Category -> "General"
		},
		{
			OptionName -> Scale,
			Default -> Automatic,
			Description -> "The output of the experiment. Preparative and SemiPreparative indicates that effluent is to be collected by fractions. Analytical indicates that specific measurements will be employed and new SamplesOut will not be generated (e.g the absorbance of the flow with injected sample for a given wavelength).",
			ResolutionDescription -> "If any fraction collection options are specified and injection volume is greater that 500 uL, then Scale -> Preparative; if fraction collection options are specified and injection volume is less than or equal to 500uL, then Scale -> SemiPreparative; otherwise, Scale -> Analytical.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PurificationScaleP
			],
			Category -> "General"
		},
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
			OptionName -> Detector,
			Default -> Automatic,
			Description -> "The type of measurement to employ. Options include Pressure (measures the pump pressure) , Temperature (measures the temperature of the column oven), UVVis (measures the absorbance of a single wavelength of light), PhotoDiodeArray (measures the absorbance of a range of wavelengths), Fluorescence (measures the emitted light from samples after light excitation),pH, Conductance, MultiAngleLightScattering (measures the scattered light intensity at different angles), DynamicLightScattering (measures the scattered light fluctuation), RefractiveIndex (measures how fast light travels through the sample) and EvaporativeLightScattering (separates the flow into airborne droplets and measures the light scattering).",
			ResolutionDescription -> "Automatically set to the detector(s) available for the first selected instrument. For example, if Agilent 1290 Infinity II Instrument is requested, the Detector option will include Pressure and PhotoDiodeArray.",
			AllowNull -> False,
			(* Need to do these With shenanigans because of Widget pattern shit that is HoldSomething, but it is admittedly really dumb that we have to do that*)
			Widget -> With[{insertMe = HPLCDetectorTypeP},
				Widget[
					Type -> MultiSelect,
					Pattern :> DuplicateFreeListableP[insertMe]
				]
			],
			Category -> "General"
		},
		{
			OptionName -> ColumnSelection,
			Default -> Automatic,
			Description -> "Indicates if multiple different columns will be employed for different samples during the run. All columns are installed during the beginning of the run and the valve on the instrument allows to switch between them automatically.",
			ResolutionDescription -> "If ColumnSelector and InjectionTable are not specified, automatically set to False. If InjectionTable is set but with only one set of column(s), automatically set to False. Otherwise, set to True.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "General"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> ColumnPosition,
				Default -> Automatic,
				Description -> "The position of the column selector valve and the desired column configuration that will be used for each sample as it is injected.",
				ResolutionDescription -> "If InjectionTable is specified, automatically set from the Column Position entry for the sample. Otherwise set to PositionA.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> ColumnPositionP
				],
				Category -> "General"
			}
		],
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
						"HPLC Columns"
					}
				}
			],
			Category -> "General"
		},
		{
			OptionName -> GuardColumnOrientation,
			Default -> Automatic,
			Description -> "The position of the GuardColumn with respect to the Column, SecondaryColumn and TertiaryColumn. Forward indicates that the GuardColumn will be placed in front of the Column, SecondaryColumn and TertiaryColumn. If a Column is specified and GuardColumnOrientation is Reverse, the GuardColumn will be placed after the Column, SecondaryColumn, and/or TertiaryColumn in the flow path which is typically performed during column cleaning.",
			ResolutionDescription -> "If GuardColumn is specified automatically set to Forward.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> ColumnOrientationP
			],
			Category -> "General"
		},
		{
			OptionName -> Column,
			Default -> Automatic,
			Description -> "The item containing the stationary phase through which the mobile phase and input samples flow. It adsorbs and separates the molecules within the sample based on the properties of the mobile phase, Samples, Column material, and the desired column temperature in the specified InjectionTable.",
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
			Category -> "General"
		},

		{
			OptionName -> ColumnOrientation,
			Default -> Automatic,
			Description -> "The direction of the Column with respect to the flow. Forward indicates that the Column will be placed in the direction indicated by the column manufacturer for standard operation. Reverse indicates that the Column will be placed in the opposite direction indicated by the column manufacturer for standard operation. This also specifies the orientation of secondary and tertiary columns if provided.",
			ResolutionDescription -> "Automatically set to Forward if column orientation options are not specified.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> ColumnOrientationP
			],
			Category -> "General"
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
			Category -> "General"
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
			Category -> "General"
		},
		{
			OptionName -> IncubateColumn,
			Default -> Automatic,
			Description -> "Indicates if the columns are placed inside the column oven compartment of the HPLC instrument during the experiment. If set to False, the columns are placed on a rack outside the column oven under ambient temperature.",
			ResolutionDescription -> "Automatically set to False if the selected connection of GuardColumn, Column, SecondaryColumn, and TertiaryColumn cannot fit into the column oven compartment of the Instrument. Otherwise set to True.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "General"
		},
		(* --- Buffers --- *)
		{
			OptionName -> BufferA,
			Default -> Automatic,
			Description -> "A solvent or buffer placed in the 'A' bottle as shown in Figure 2.1.1 - 2.9.1 of ExperimentHPLC help file, pumped through the instrument as part of the mobile phase, the compositions of which is determined by the GradientA option.",
			ResolutionDescription -> "Automatically set from the SeparationMode (e.g. Water buffer if ReversePhase) option or the objects specified in the Gradient option.",
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
			Category -> "General"
		},
		{
			OptionName -> BufferB,
			Default -> Automatic,
			Description -> "A solvent or buffer placed in the 'B' bottle as shown in Figure 2.1.1 - 2.9.1 of ExperimentHPLC help file, pumped through the instrument as part of the mobile phase, the compositions of which is determined by the GradientB option.",
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
			Category -> "General"
		},
		{
			OptionName -> BufferC,
			Default -> Automatic,
			Description -> "A solvent or buffer placed in the 'C' bottle as shown in Figure 2.1.1 - 2.9.1 of ExperimentHPLC help file, pumped through the instrument as part of the mobile phase, the compositions of which is determined by the GradientC option.",
			ResolutionDescription -> "Automatically set from the SeparationMode option or the objects specified in the Gradient option.",
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
			Category -> "General"
		},
		{
			OptionName -> BufferD,
			Default -> Automatic,
			Description -> "A solvent or buffer placed in the 'D' bottle as shown in Figure 2.1.1 - 2.5.1 of ExperimentHPLC help file, pumped through the instrument as part of the mobile phase, the compositions of which is determined by the GradientD option.",
			ResolutionDescription -> "If the specified Instrument's pump does not support Buffer D, automatically set to Null. Otherwise, set from the SeparationMode option or the objects specified in the Gradient option.",
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
			Category -> "General"
		},
		IndexMatching[
			IndexMatchingParent -> ColumnSelector,
			{
				OptionName -> ColumnSelector,
				Default -> Automatic,
				Description -> "The set of all the columns loaded into the Instrument's column selector and referenced in Column, SecondaryColumn, TertiaryColumn. The Serial configuration indicates one fluid line for all the samples, Standard and Blank. The Selector configuration indicates use of a column selector where the column line is programmatically switchable between samples.",
				ResolutionDescription -> "If ColumnSelection is False, set to match the values in Column, SecondaryColumn, TertiaryColumn, ColumnOrientation, GuardColumn and GuardColumnOrientation options.",
				AllowNull -> False,
				Widget -> {
					"Column Position" ->
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[ColumnPositionP, Automatic, Null]
							],
					"Guard Column" -> Alternatives[
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
							Pattern :> Alternatives[Automatic, Null]
						]
					],
					"Guard Column Orientation" -> Alternatives[
						Widget[
							Type -> Enumeration,
							Pattern :> ColumnOrientationP
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
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
							Pattern :> Alternatives[Automatic, Null]
						]
					],
					"Column Orientation" -> Alternatives[
						Widget[
							Type -> Enumeration,
							Pattern :> ColumnOrientationP
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
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
							Pattern :> Alternatives[Automatic, Null]
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
							Pattern :> Alternatives[Automatic, Null]
						]
					]
				},
				Category -> "Column Installation"
			},
			{
				OptionName -> ColumnStorageBuffer,
				Default -> Automatic,
				AllowNull -> False,
				Description -> "The solvent in which the selected column should be stored in for long term storage after removing from the instrument.",
				ResolutionDescription -> "Automatically set from the StorageBuffer field from the Model[Item,Column] specified for the specified Column, if it is one of the buffers specified in the protocol. Otherwise set to BufferA of the protocol.",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Object[Sample], Model[Sample]}]
				],
				Category -> "Separation"
			}
		],
		{
			OptionName -> NumberOfReplicates,
			Default -> Null,
			Description -> "The number of times to repeat measurements on each provided sample(s). If Aliquot -> True, this also indicates the number of times each provided sample will be aliquoted. For experiment samples {A,B,C} if NumberOfReplicates is specified as 3, the order of samples to run on the instrument will be {A,A,A,B,B,B,C,C,C}.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[1, 96, 1]
			],
			Category -> "Sample Parameters"
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
							ObjectTypes -> {Model[Sample], Object[Sample]}
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
						]
					],
					"InjectionVolume" -> Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Microliter, 16 Milliliter],
							Units :> {Microliter, {Microliter, Milliliter}}
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic, Null]
						]
					],
					"Column Position" -> Alternatives[
						Widget[
							Type -> Enumeration,
							Pattern :> ColumnPositionP
						],
						Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic]
						]
					],
					"Column Temperature" -> Alternatives[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[5 Celsius, 90 Celsius],
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
							Pattern :> Alternatives[Automatic]
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

		(* --- SamplesIn IndexMatched Options --- *)
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName->ColumnTemperature,
				Default -> Automatic,
				Description -> "The temperature of the column assembly throughout the measurement and/or fraction collection.",
				ResolutionDescription -> "Automatically set to the corresponding gradient temperature specified in the Gradient option or the column temperature for the sample in the InjectionTable option; otherwise, set to Ambient.",
				AllowNull -> False,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[5 Celsius, 90 Celsius],
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
				Description -> "The physical quantity of sample loaded into the flow path for measurement and/or collection.",
				ResolutionDescription -> "Automatically defaults to the lesser of 10 uL or 90% of the available sample volume for Analytical measurement, lesser of 500 uL or 90% of the available sample volume for Semipreparative measurement and lesser of 5mL or 90% of available sample volume for Preparative measurement.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter, 16 Milliliter],
					Units -> {Microliter, {Microliter, Milliliter}}
				],
				Category -> "Sample Parameters"
			}
		],
		{
			OptionName -> NeedleWashSolution,
			Default -> Automatic,
			Description -> "The solvent used to wash the injection needle before each sample introduction. For Dionex instruments, this is the same as BufferC and cannot be defined separately.",
			ResolutionDescription -> "If the instrument shares NeedleWashSolution with BufferC, automatically set to specified BufferC. Otherwise, defaults to Model[Sample, \"Milli-Q water\"] for IonExchange and SizeExclusion SeparationType or Model[Sample, StockSolution, \"20% Methanol in MilliQ Water\"] for other SeparationType.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Reagents",
						"Solvents"
					}
				}
			],
			Category -> "Sample Parameters"
		},

		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			(* === Gradient Specification Parameters === *)
			{
				OptionName -> GradientA,
				Default -> Automatic,
				Description -> "The composition of BufferA within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientA->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferA in the flow will rise such that at 15 minutes, the composition should be 50 Percent.",
				ResolutionDescription -> "If Gradient option is specified, set from it or implicitly determined from the GradientB, GradientC, and GradientD options such that the total amounts to 100%.",
				AllowNull -> False,
				Category -> "Separation",
				Widget -> Alternatives[
					"Isocratic" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					"Binary" -> Adder[
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
				ResolutionDescription -> "If Gradient option is specified, set from it or implicitly determined from the GradientA, GradientC, and GradientD options such that the total amounts to 100%.",
				AllowNull -> False,
				Category -> "Separation",
				Widget -> Alternatives[
					"Isocratic" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					"Binary" -> Adder[
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
				Category -> "Separation",
				Widget -> Alternatives[
					"Isocratic" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					"Binary" -> Adder[
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
				Category -> "Separation",
				Widget -> Alternatives[
					"Isocratic" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					"Binary" -> Adder[
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
				Category -> "Separation",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Milliliter / Minute, 200 Milliliter / Minute],
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
								Pattern :> RangeP[0 Milliliter / Minute, 200 Milliliter / Minute],
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
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0 (Milliliter / Minute / Minute)],
				Units -> CompoundUnit[
					{1, {Milliliter, {Milliliter, Liter}}},
					{-2, {Minute, {Minute, Second}}}
				]
			],
			Category -> "Separation"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> Gradient,
				Default -> Automatic,
				Description -> "The composition of different specified buffers in BufferA, BufferB, BufferC and BufferD over time in the fluid flow. Specific parameters of a gradient object can be overridden by specific options. Differential Refractive Index Reference Loading refers to the HPLC refractive index loading reference values as shown in the Figure 2.7.4. When open, the flow downstream of the column is loaded into the two flow cells simultaneously.",
				ResolutionDescription -> "Automatically set to best meet all the Gradient options (e.g. GradientA, GradientB, GradientC, GradientD, FlowRate).",
				AllowNull -> False,
				Category -> "Separation",
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
								Pattern :> RangeP[0 Milliliter / Minute, 200 Milliliter / Minute],
								Units -> CompoundUnit[
									{1, {Milliliter, {Milliliter, Liter}}},
									{-1, {Minute, {Minute, Second}}}
								]
							],
							"Differential Refractive Index Reference Loading" -> Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Open, Closed, None, Automatic]
							]
						},
						Orientation -> Vertical
					]
				]
			},

			(* === Detector Specific Parameters === *)
			{
				OptionName -> AbsorbanceWavelength,
				Default -> Automatic,
				Description -> "The wavelength of light passed through the flow cell for the UVVis Detector. For PhotoDiodeArray Detector, a 3D data is generated from a spectrum of light passing through the flow cell. Absorbance wavelength in that case represents the wavelength at which a 2D data slice is generated from the 3D data.",
				ResolutionDescription -> "If a UVVis Detector is selected or available on the selected instrument, automatically set to the absorbance wavelength corresponding to the maximum extinction coefficient from the ExtinctionCoefficients field in the identity model of the samples specified. If no ExtinctionCoefficients available, automatically set to to 260 Nanometer for oligomers or 280 Nanometer for proteins. If a PhotoDiodeArray Detector is selected or available on the selected Instrument, automatically set to All.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Single" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[190 Nanometer, 900 Nanometer],
						Units -> Nanometer
					],
					"All" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					],
					"Range" -> Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[190 Nanometer, 900 Nanometer],
							Units -> Nanometer
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[200 Nanometer, 900 Nanometer],
							Units -> Nanometer
						]
					]
				],
				Category -> "Detection"
			},
			{
				OptionName -> WavelengthResolution,
				Default -> Automatic,
				Description -> "The increment in wavelength for the range of wavelength of light passed through the flow for absorbance measurement of PhotoDiodeArray Detector.",
				ResolutionDescription -> "If a PhotoDiodeArray Detector is selected or available on the selected Instrument, automatically set to 2.4 Nanometer.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 * Nanometer, 12.0 * Nanometer],
					Units -> Nanometer
				],
				Category -> "Detection"
			},
			{
				OptionName -> UVFilter,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if UV wavelengths (less than 210 nm) should be blocked from being transmitted through the sample for the PhotoDiodeArray Detector.",
				ResolutionDescription -> "If a PhotoDiodeArray Detector is selected or available on the selected Instrument, automatically set to False.",
				Category -> "Detection"
			},
			{
				OptionName -> AbsorbanceSamplingRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * 1 / Second, 120 * 1 / Second], (*can be only specific values*)
					Units -> {-1, {Minute, {Minute, Second}}}
				],
				Description -> "The number of times an absorbance measurement is made per second by the detector on the selected instrument. Lower values will be less susceptible to noise but will record less frequently across time.",
				ResolutionDescription -> "If a UVVis Detector or PhotoDiodeArray Detector is selected or available on the selected instrument, automatically set to 20/Second .",
				Category -> "Detection"
			},
			{
				OptionName -> ExcitationWavelength,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Single-Channel" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[200 Nanometer, 890Nanometer],
						Units :> Nanometer
					],
					"Multi-Channel" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[200 Nanometer, 890Nanometer],
							Units :> Nanometer
						]
					]
				],
				Description -> "The wavelength(s) of light that is used to excite fluorescence in the samples when passed through the Fluorescence Detector.",
				ResolutionDescription -> "If Fluorescence Detector is selected, automatically set from the FluorescenceExcitationMaximums field in the identity Model of the sample specified.",
				Category -> "Detection"
			},
			{
				OptionName -> EmissionWavelength,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Single-Channel" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[200 Nanometer, 890Nanometer],
						Units :> Nanometer
					],
					"Multi-Channel" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[200 Nanometer, 890Nanometer],
							Units :> Nanometer
						]
					]
				],
				Description -> "The wavelength(s) of light at which fluorescence emitted from the sample is measured in the Fluorescence Detector.",
				ResolutionDescription -> "If Fluorescence Detector is selected, automatically set from the FluorescenceEmissionMaximums field in the identity Model of the sample specified.",
				Category -> "Detection"
			},
			{
				OptionName -> EmissionCutOffFilter,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> HPLCEmissionCutOffFilterP
				],
				Description -> "The cut-off wavelength to pre-select the emitted light from the sample and allow only the light with wavelength above the desired value to pass, before the light enters emission monochromator for final wavelength selection for Ultimate 3000 with FLR Detector. If set to None, no cut-off filter is used.",
				ResolutionDescription -> "If a Fluorescence Detector with a cut-off filter wheel is selected, automatically set to None.",
				Category -> "Detection"
			},
			{
				OptionName -> FluorescenceGain,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Constant" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					"Variable Fluorescence Sensitivity" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					]
				],
				Description -> "For each ExcitationWavelength/EmissionWavelength pair, the signal amplification factor which modulates the percentage of maximum voltage that can be applied to the Photomultiplier Tube of the Fluorescence Detector. Linear increase in voltage applied to the Photomultiplier tube leads to an exponential change in RFU signal. Variable Fluorescence Sensitivity implies a different fluorescence sensitivity for each Excitation/Emission Wavelength pair.",
				ResolutionDescription -> "If an instrument Fluorescence Detector is selected (Ultimate 3000 with FLR Detector or Waters Acquity UPLC H-Class FLR), automatically set to 1.",
				Category -> "Detection"
			},
			{
				OptionName -> FluorescenceFlowCellTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[25 Celsius, 50 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Description -> "The temperature that the thermostat inside the fluorescence flow cell of the Fluorescence Detector is set to during the fluorescence measurement of the sample.",
				ResolutionDescription -> "If Fluorescence Detector is selected and temperature control is available on that unit, automatically set to Ambient.",
				Category -> "Detection"
			},
			{
				OptionName -> LightScatteringLaserPower,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[10 * Percent, 100 * Percent],
					Units :> Percent
				],
				Description -> "The laser power filter used in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) Detector. 100% means that no filter is being used to restrict the laser power.",
				ResolutionDescription -> "If MultiAngleLightScattering Detector and/or DynamicLightScattering Detector are selected, automatically set to 100 Percent.",
				Category -> "Detection"
			},
			{
				OptionName -> LightScatteringFlowCellTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[20 Celsius, 70 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Description -> "The temperature that the thermostat inside the flow cell of the Detector is set to during the Multi-Angle static Light Scattering (MALS) and/or Dynamic Light Scattering (DLS) measurement of the sample.",
				ResolutionDescription -> "If MultiAngleLightScattering Detector and/or DynamicLightScattering Detector are selected, automatically set to Ambient.",
				Category -> "Detection"
			},
			{
				OptionName -> RefractiveIndexMethod,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[RefractiveIndex, DifferentialRefractiveIndex]
				],
				Description -> "The type of refractive index measurement of the Refractive Index (RI) Detector for the measurement of the sample. When DifferentialRefractiveIndex is selected, the refractive index difference between the flow downstream sample and the reference solvent is measured. See Figure 2.7.4 for more information.",
				ResolutionDescription -> "If RefractiveIndex Detector is selected and Differential Refractive Index Reference Loading is set to Closed in Gradient, automatically set to DifferentialRefractiveIndex. Otherwise automatically set to RefractiveIndex.",
				Category -> "Detection"
			},
			{
				OptionName -> RefractiveIndexFlowCellTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[4 Celsius, 65 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Description -> "The temperature that the thermostat inside the refractive index flow cell of the Refractive Index (RI) Detector is set to during the refractive index measurement of the sample.",
				ResolutionDescription -> "If RefractiveIndex Detector is selected, automatically set to Ambient.",
				Category -> "Detection"
			}
		],
		(* === pH and Conductivity Calibration related options === *)
		{
			OptionName -> pHCalibration,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if 2-point calibration of the pH probe should be performed before the experiment starts. pH And Conductivity calibration is performed monthly every time a qualification procedure is run on the instrument.",
			ResolutionDescription -> "Automatically set to True if pH Detector is selected.",
			Category -> "Detection"
		},
		{
			OptionName -> LowpHCalibrationBuffer,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Materials",
						"Reagents",
						"Titration"
					}
				}
			],
			Description -> "The low pH buffer that should be used to calibrate the pH probe in the 2-point calibration.",
			ResolutionDescription -> "Automatically set to Model[Sample, \"pH 4.01 Calibration Buffer, Sachets\"] if pH Detector is selected and pHCalibration is True.",
			Category -> "Detection"
		},
		{
			OptionName -> LowpHCalibrationTarget,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[0, 14]
			],
			Description -> "The pH of the LowpHCalibrationBuffer that should be used to calibrate the pH probe in the 2-point calibration.",
			ResolutionDescription -> "Automatically set to the pH of the LowpHCalibrationBuffer's model.",
			Category -> "Detection"
		},
		{
			OptionName -> HighpHCalibrationBuffer,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths -> {
					{Object[Catalog, "Root"],
						"Materials",
						"Reagents",
						"Titration"
					}
				}
			],
			Description -> "The high pH buffer that should be used to calibrate the pH probe in the 2-point calibration.",
			ResolutionDescription -> "Automatically set to Model[Sample, \"pH 7.00 Calibration Buffer, Sachets\"] if pH Detector is selected and pHCalibration is True. If HighpHCalibrationTarget is specified, set to a buffer with pH value close to that.",
			Category -> "Detection"
		},
		{
			OptionName -> HighpHCalibrationTarget, (* Throw soft warning when these don't match with Model of HighpHCalibrationBuffer *)
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Number,
				Pattern :> RangeP[0, 14]
			],
			Description -> "The pH of the HighpHCalibrationBuffer that should be used to calibrate the pH probe in the 2-point calibration.",
			ResolutionDescription -> "Automatically set to the pH of the HighpHCalibrationBuffer's model.",
			Category -> "Detection"
		},
		{
			OptionName -> pHTemperatureCompensation,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if the measured pH value should be automatically corrected according to the temperature inside the pH flow cell.",
			ResolutionDescription -> "Automatically set to True if pH Detector is selected.",
			Category -> "Detection"
		},
		{
			OptionName -> ConductivityCalibration,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if 1-point calibration of the conductivity probe should be performed before the experiment starts. pH And Conductivity calibration is performed monthly every time a qualification procedure is run on the instrument.",
			ResolutionDescription -> "Automatically set to True if Conductivity Detector is selected.",
			Category -> "Detection"
		},
		{
			OptionName -> ConductivityCalibrationBuffer,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Object[Sample], Model[Sample]}],
				OpenPaths -> {
					{Object[Catalog, "Root"],
						"Materials",
						"Reagents"
					}
				}
			],
			Description -> "The buffer that should be used to calibrate the conductivity probe in the 1-point calibration.",
			ResolutionDescription -> "Automatically set to Model[Sample, \"Conductivity Standard 1413 \[Micro]S, Sachets\"] if Conductivity Detector is selected and ConductivityCalibration is True.",
			Category -> "Detection"
		},
		{
			OptionName -> ConductivityCalibrationTarget,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[10 * Micro Siemens / Centimeter, 1000 Milli Siemens / Centimeter],
				Units -> CompoundUnit[
					{1, {Micro Siemens, {Micro Siemens, Millisiemen, Siemens}}},
					{-1, {Centimeter, {Centimeter}}}
				]
			],
			Description -> "The conductivity value of the ConductivityCalibrationBuffer that should be used to calibrate the conductivity probe in the 1-point calibration.",
			ResolutionDescription -> "Automatically set to the Conductivity of the ConductivityCalibrationBuffer's model.",
			Category -> "Detection"
		},
		{
			OptionName -> ConductivityTemperatureCompensation,
			Default -> Automatic,
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Description -> "Indicates if the measured conductivity value should be automatically corrected according to the temperature inside the conductivity flow cell.",
			ResolutionDescription -> "Automatically set to True if Conductivity Detector is selected.",
			Category -> "Detection"
		},
		(* === END: pH and Conductivity Calibration related options === *)

		(* === ELSD Parameters === *)
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> NebulizerGas,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if Nitrogen sheath gas is flowed along with the sample within the EvaporativeLightScattering Detector.",
				ResolutionDescription -> "If EvaporativeLightScattering detector is selected, automatically set to True.",
				Category -> "Detection"
			},
			{
				OptionName -> NebulizerGasHeating,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the sheath gas that carries samples in the EvaporativeLightScattering Detector is heated.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and NebulizerGas is True, automatically set to True.",
				Category -> "Detection"
			},
			{
				OptionName -> NebulizerHeatingPower,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Percent, 100 * Percent],
					Units :> Percent
				],
				Description -> "The relative magnitude of the heating element used to heat the sheath gas for the EvaporativeLightScattering Detector (Corresponding temperature not measured by the manufacturer). Higher percent values correspond to percent of power going to heating coil.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and NebulizerGasHeating is True, automatically set to 50 Percent.",
				Category -> "Detection"
			},
			{
				OptionName -> NebulizerGasPressure,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[20 * PSI, 60 * PSI],
					Units :> PSI
				],
				Description -> "The applied pressure of sheath gas for the EvaporativeLightScattering Detector (Flow rate unmeasured by the manufacturer). Higher pressure (20-60 PSI) corresponds to faster sheath gas flow.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and NebulizerGas is True, automatically set to 40 PSI.",
				Category -> "Detection"
			},
			{
				OptionName -> DriftTubeTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[20 * Celsius, 100 * Celsius],
					Units :> Celsius
				],
				Description -> "The set temperature of the chamber thermostat through which the nebulized analytes flow within the EvaporativeLightScattering Detector. The purpose to heat the drift tube is to evaporate any unevaporated solvent remaining in the flow from the nebulizer.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and NebulizerGas is True, automatically set to 50 Celsius.",
				Category -> "Detection"
			},
			{
				OptionName -> ELSDGain,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Percent, 100 * Percent],
					Units -> Percent
				],
				Description -> "The percent of maximum voltage sent to the Photo Mulitplier Tube (PMT) for signal amplification for the EvaporativeLightScattering measurement. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the PMT.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and NebulizerGas is True, automatically set to 50 Percent.",
				Category -> "Detection"
			},
			{
				OptionName -> ELSDSamplingRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * 1 / Second, 80 * 1 / Second], (*can be only specific values*)
					Units -> {-1, {Minute, {Minute, Second}}}
				],
				Description -> "The frequency of evaporative light scattering measurement. Lower values will be less susceptible to noise but will record less frequently across time. Lower or higher values do not affect the y axis of the measurement.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and NebulizerGas is True, automatically set to 1/Second.",
				Category -> "Detection"
			}
		],
		(* === Fraction Collection Options === *)
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> CollectFractions,
				Default -> Automatic,
				Description -> "Indicates if effluents from the Column should be captured and stored at specific time windows or during detection of peaks (fractions).",
				ResolutionDescription -> "If Scale is Preparative/SemiPreparative or any fraction collection options are specified, set to True. For analytical measurements, set to False.",
				AllowNull -> False,
				Category -> "Fraction Collection",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			}
		],
		{
			OptionName -> FractionCollectionDetector,
			Default -> Automatic,
			Description -> "The type of measurement that is used as signal to trigger fraction collection. It corresponds to the type of detector on the instrument.",
			ResolutionDescription -> "If CollectFractions is True, automatically set to the Detector in the Detector option for which the Detector hardware can communicate with the fraction collection (as indicated in the Instrumentation Table of ExperimentHPLC help file).",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> HPLCFractionCollectionDetectorTypeP
			],
			Category -> "Fraction Collection"
		},
		{
			OptionName -> FractionCollectionContainer,
			Default -> Automatic,
			AllowNull -> True,
			Description -> "The container in which the fractions are collected on the selected instrument's fraction collector.",
			ResolutionDescription -> "Automatically set to Model[Container, Plate, \"96-well 2mL Deep Well Plate\"] for UltiMate 3000 HPLC instruments and to Model[Container, Vessel, \"50mL Tube\"] for Agilent 1290 Infinity II instrument.",
			Category -> "Fraction Collection",
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Container]}]
			]
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> FractionCollectionMethod,
				Default -> Null,
				Description -> "The fraction collection method object which describes the conditions for which a fraction is collected. Specific parameters of the object can be overridden by other fraction collection options.",
				AllowNull -> True,
				Category -> "Fraction Collection",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Method, FractionCollection]]
				]
			},
			{
				OptionName -> FractionCollectionStartTime,
				Default -> Automatic,
				Description -> "The time at which to start column effluent capture. Time in this case is the duration from the start of sample injection.",
				ResolutionDescription -> "Automatically set from the method specified in the FractionCollectionMethod option, if available. Otherwise set to the second time point of the gradient domains if there are more than two time points, or the first time point if not.",
				AllowNull -> True,
				Category -> "Fraction Collection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute, $MaxExperimentTime],
					Units -> {Minute, {Second, Minute, Hour}}
				]
			},
			{
				OptionName -> FractionCollectionEndTime,
				Default -> Automatic,
				Description -> "The time to end column effluent capture. Time in this case is the duration from the start of sample injection.",
				ResolutionDescription -> "Automatically inherited from the method specified in the FractionCollectionMethod option. Otherwise set to the last time point of the gradient domains.",
				AllowNull -> True,
				Category -> "Fraction Collection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute, $MaxExperimentTime],
					Units -> {Minute, {Second, Minute, Hour}}
				]
			},
			{
				OptionName -> FractionCollectionMode,
				Default -> Automatic,
				Description -> "The method by which fractions collection should be triggered (peak detection, a constant threshold, or a fixed fraction time). In peak detection mode, the fraction collection is triggered when a change in slope of the FractionCollectionDetector signal is observed for a specified PeakDuration time. In constant threshold method, whenever the signal from the FractionCollectionDetector is above the specified value, fraction collection is triggered. In fixed fraction time, fractions are collected during the whole time interval specified.",
				ResolutionDescription -> "Automatically inherited from a method specified by FractionCollectionMethod option, or implicitly resolved from other fraction collection options. If AbsoluteThreshold is specified, set to Threshold. If PeakSlope is specified, set to Peak. If MaxCollectionPeriod is specified, set to Time. Otherwise set to Threshold if CollectFractions is True.",
				AllowNull -> True,
				Category -> "Fraction Collection",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> FractionCollectionModeP
				]
			},
			{
				OptionName -> MaxFractionVolume,
				Default -> Automatic,
				Description -> "The maximum amount of sample to be collected in a single fraction. If fraction detection trigger is not off, the collector moves position to the next container. For example, if AbsorbanceThreshold is set to 180 MilliAbsorbanceUnit and at MaxFractionVolume the absorbance value is still above 180 MilliAbsorbanceUnit, the fraction collector continues to collect fractions in the next container in line.",
				ResolutionDescription -> "If FractionCollection is True, automatically set according to the MaxFractionVolume in the method specified by FractionCollectionMethod option, if available. If FractionCollectionContainer is specified, set to MaxVolume of the Model specified. Otherwise, automatically set to 1.8 Milliliter for UltiMate 3000 HPLC instruments and 50 Milliliter for Agilent 1290 Infinity II instrument.",
				AllowNull -> True,
				Category -> "Fraction Collection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[10 Microliter, 50 Milliliter],
					Units -> {Milliliter, {Milliliter, Microliter}}
				]
			},
			{
				OptionName -> MaxCollectionPeriod,
				Default -> Automatic,
				Description -> "The amount of time after which a new fraction will be generated (Fraction Collector moves to the next vial) when FractionCollectionMode is Time. For example, if MaxCollectionPeriod is 120 Second, the fraction collector continues to collect fractions in the next container in line after 120 Second.",
				ResolutionDescription -> "If FractionCollection is True, automatically set according to the MaxCollectionPeriod in the method specified by FractionCollectionMethod option, if available. Otherwise automatically set to the time it takes to fill the FractionCollectorContainer to 80% of the MaxFractionVolume.",
				AllowNull -> True,
				Category -> "Fraction Collection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Second, $MaxExperimentTime],
					Units -> {Second, {Second, Minute}}
				]
			},
			{
				OptionName -> AbsoluteThreshold,
				Default -> Automatic,
				Description -> "The signal value from FractionCollectionDetector above which fractions will always be collected. Both AbsoluteThreshold and PeakSlope conditions must be met in order to trigger fraction collection.",
				ResolutionDescription -> "Inherited from a method specified by FractionCollectionMethod option or set based on FractionCollectionDetector if FractionCollectionMode is Threshold. If the FractionCollectionDetector is UVVis, automatically set to 500 Milli AbsorbanceUnit. If the FractionCollectionDetector is Fluorescence, automatically set to 100 Milli RFU.",
				AllowNull -> True,
				Category -> "Fraction Collection",
				Widget -> Alternatives[
					"pH" -> Widget[
						Type -> Number,
						Pattern :> RangeP[0, 14]
					],
					"Others" -> Widget[
						Type -> Quantity,
						Pattern :> (GreaterEqualP[0 AbsorbanceUnit] | GreaterEqualP[0 RFU] | GreaterEqualP[10 Micro Siemens / Centimeter]),
						Units -> Alternatives[
							{1, {MilliAbsorbanceUnit, {MilliAbsorbanceUnit, AbsorbanceUnit}}},
							{1, {RFU * Milli, {RFU * Milli, RFU}}},
							CompoundUnit[
								{1, {Micro Siemens, {Micro Siemens, Millisiemen, Siemens}}},
								{-1, {Centimeter, {Centimeter}}}
							]
						]
					]
				]
			},
			{
				OptionName -> PeakSlope,
				Default -> Automatic,
				Description -> "The minimum slope (signal change per second) for PeakSlopeDuration that must be met before a peak is detected and fraction collection begins, and collection ends when the AbsoluteThreshold value is reached. A new peak (and new fraction) can be registered once the slope drops below this. Both AbsoluteThreshold and PeakSlope conditions must be met in order to trigger fraction collection.",
				ResolutionDescription -> "If FractionCollection is True, automatically set according to the PeakSlope in the method specified by FractionCollectionMethod option, if available. If the FractionCollectionDetector is UVVis and FractionCollectionMode is Peak, automatically set to 1 Milli AbsorbanceUnit/Second. If the FractionCollectionDetector is Fluorescence and FractionCollectionMode is Peak, automatically set to 0.2 Milli RFU/Second.",
				AllowNull -> True,
				Category -> "Fraction Collection",
				Widget -> Alternatives[
					"pH" -> Widget[
						Type -> Number,
						Pattern :> RangeP[0, 14]
					],
					"Others" -> Widget[
						Type -> Quantity,
						Pattern :> (GreaterEqualP[0 AbsorbanceUnit / Second] | GreaterEqualP[0 RFU / Second] | GreaterEqualP[10 Micro (Siemens / Centimeter) / Second]),
						Units -> Alternatives[
							CompoundUnit[
								{1, {AbsorbanceUnit, {AbsorbanceUnit, MilliAbsorbanceUnit}}},
								{-1, {Second, {Second, Millisecond}}}
							],
							CompoundUnit[
								{1, {RFU * Milli, {RFU * Milli, RFU}}},
								{-1, {Second, {Second, Millisecond}}}
							],
							CompoundUnit[
								{1, {Micro Siemens, {Micro Siemens, Milli Siemens, Siemens}}},
								{-1, {Centimeter, {Centimeter}}},
								{-1, {Second, {Second, Millisecond}}}
							]
						]
					]
				]
			},
			{
				OptionName -> PeakSlopeDuration,
				Default -> Automatic,
				Description -> "The minimum duration that changes in slopes must be maintained before they are registered.",
				ResolutionDescription -> "If FractionCollection is True, automatically set according to the PeakSlopeDuration in the method specified by FractionCollectionMethod option, if available. Otherwise automatically set to 0.5 Second if FractionCollectionMode is Peak.",
				AllowNull -> True,
				Category -> "Fraction Collection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Second, 4 Second],
					Units -> {Second, {Second, Millisecond}}
				]
			},
			{
				OptionName -> PeakEndThreshold,
				Default -> Automatic,
				Description -> "The signal value below which the end of a peak is marked and fraction collection stops.",
				ResolutionDescription -> "If FractionCollection is True, automatically set according to the PeakEndThreshold in the method specified by FractionCollectionMethod option, if available. If FractionCollectionMode is Peak, automatically set to 1 Milli AbsorbanceUnit for UVVis detector, 0.2 Milli * RFU for Fluorescence detector, 10 for pH detector or 10.0 Milli * Siemens / Centimeter for Conductivity detector.",
				AllowNull -> True,
				Category -> "Fraction Collection",
				Widget -> Alternatives[
					"pH" -> Widget[
						Type -> Number,
						Pattern :> RangeP[0, 14]
					],
					"Others" -> Widget[
						Type -> Quantity,
						Pattern :> (GreaterEqualP[0 AbsorbanceUnit] | GreaterEqualP[0 RFU] | GreaterEqualP[10 Micro Siemens / Centimeter]),
						Units -> Alternatives[
							{1, {MilliAbsorbanceUnit, {MilliAbsorbanceUnit, AbsorbanceUnit}}},
							{1, {RFU * Milli, {RFU * Milli, RFU}}},
							CompoundUnit[
								{1, {Micro Siemens, {Micro Siemens, Millisiemen, Siemens}}},
								{-1, {Centimeter, {Centimeter}}}
							]
						]
					]
				]
			}
		],
		(* === Standard Options === *)
		IndexMatching[
			IndexMatchingParent -> Standard,
			{
				OptionName -> Standard,
				Default -> Automatic,
				Description -> "The reference compound(s) to inject to the instrument, often used for quantification or to check internal measurement consistency.",
				ResolutionDescription -> "If any other Standard option is specified, automatically set based on the SeparationMode option. If InjectionTable is specified, set from the specified Standard entries in the InjectionTable.",
				AllowNull -> True,
				Category -> "Standards",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
				]
			},
			{
				OptionName -> StandardInjectionVolume,
				Default -> Automatic,
				Description -> "The physical quantity of Standard sample loaded into the flow path on the selected instrument along with the mobile phase onto the stationary phase.",
				ResolutionDescription -> "Automatically set equal to the first entry in InjectionVolume.",
				AllowNull -> True,
				Category -> "Standards",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Microliter, 16 Milliliter],
					Units -> {Microliter, {Microliter, Milliliter}}
				]
			}
		],
		{
			OptionName -> StandardFrequency,
			Default -> Automatic,
			Description -> "The frequency at which Standard measurements will be inserted between the experiment samples.",
			ResolutionDescription -> "If injectionTable is given, automatically set to Null and the sequence of Standards specified in the InjectionTable will be used in the experiment. If any other Standard option is specified, automatically set to FirstAndLast.",
			AllowNull -> True,
			Category -> "Standards",
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
				OptionName -> StandardColumnPosition,
				Default -> Automatic,
				Description -> "The position of the column selector valve and the desired column configuration that will be used for each standard sample as it is injected.",
				ResolutionDescription -> "If InjectionTable is specified, automatically set from the Column Position entry for the standard sample. Otherwise set to PositionA.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> ColumnPositionP
				],
				Category -> "Standards"
			},
			{
				OptionName -> StandardColumnTemperature,
				Default -> Automatic,
				Description -> "The temperature of the column assembly throughout the Standard gradient and measurement.",
				ResolutionDescription -> "Automatically set to the corresponding gradient temperature specified in the StandardGradient option or the column temperature for the sample in the InjectionTable option; otherwise, set as the first value of the ColumnTemperature option.",
				AllowNull -> True,
				Category -> "Standards",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[5 Celsius, 90 Celsius],
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
				Category -> "Standards",
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
				Category -> "Standards",
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
				Category -> "Standards",
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
				Category -> "Standards",
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
				Category -> "Standards",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Milliliter / Minute, 200 Milliliter / Minute],
						Units -> CompoundUnit[
							{1, {Milliliter, {Milliliter, Liter}}},
							{-1, {Minute, {Minute, Second}}}
						]
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> {Minute, {Second, Minute}}
							],
							"Flow Rate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Milliliter / Minute, 200 Milliliter / Minute],
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
				Description -> "The composition of different specified buffers in BufferA, BufferB, BufferC and BufferD over time in the fluid flow for Standard measurement. Specific parameters of a gradient object can be overridden by specific options. Differential Refractive Index Reference Loading refers to the HPLC refractive index loading reference values as shown in the Figure 2.7.4. When open, the flow downstream of the column is loaded into the two flow cells simultaneously.",
				ResolutionDescription -> "Automatically set to best meet all the StandardGradient options (e.g. StandardGradientA, StandardGradientB, StandardGradientC, StandardGradientD, StandardFlowRate).",
				AllowNull -> True,
				Category -> "Standards",
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
								Pattern :> RangeP[0 Milliliter / Minute, 200 Milliliter / Minute],
								Units -> CompoundUnit[
									{1, {Milliliter, {Milliliter, Liter}}},
									{-1, {Minute, {Minute, Second}}}
								]
							],
							"Differential Refractive Index Reference Loading" -> Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Open, Closed, None, Automatic]
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> StandardAbsorbanceWavelength,
				Default -> Automatic,
				Description -> "For Standard measurement, the wavelength of light passed through the flow cell for the UVVis Detector. For PhotoDiodeArray Detector, a 3D data is generated from a spectrum of light passing through the flow cell. Absorbance wavelength in that case represents the wavelength at which a 2D data slice is generated from the 3D data.",
				ResolutionDescription -> "If a UVVis Detector or PhotoDiodeArray Detector is selected or available on the selected instrument, automatically set equal to the same value as the first entry in AbsorbanceWavelength.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Single" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[190 Nanometer, 900 Nanometer],
						Units -> Nanometer
					],
					"All" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					],
					"Range" -> Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[190 Nanometer, 900 Nanometer],
							Units -> Nanometer
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[200 Nanometer, 900 Nanometer],
							Units -> Nanometer
						]
					]
				],
				Category -> "Standards"
			},
			{
				OptionName -> StandardWavelengthResolution,
				Default -> Automatic,
				Description -> "The increment in wavelength for the range of wavelength of light passed through the flow for absorbance measurement for the instruments with PhotoDiodeArray Detector for Standard measurement.",
				ResolutionDescription -> "If a PhotoDiodeArray Detector is selected or available on the selected Instrument, automatically set equal to the same value as the first entry in WavelengthResolution.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 * Nanometer, 12.0 * Nanometer],
					Units -> Nanometer
				],
				Category -> "Standards"
			},
			{
				OptionName -> StandardUVFilter,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if UV wavelengths (less than 210 nm) should be blocked from being transmitted through the sample for the PhotoDiodeArray Detector for Standard measurement.",
				ResolutionDescription -> "If a PhotoDiodeArray Detector is selected or available on the selected Instrument, automatically set to the first entry in UVFilter.",
				Category -> "Standards"
			},
			{
				OptionName -> StandardAbsorbanceSamplingRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * 1 / Second, 120 * 1 / Second], (*can be only specific values*)
					Units -> {-1, {Minute, {Minute, Second}}}
				],
				Description -> "The number of times an absorbance measurement is made per second for Standard sample. Lower values will be less susceptible to noise but will record less frequently across time.",
				ResolutionDescription -> "If a UVVis Detector or PhotoDiodeArray Detector is selected or available on the selected instrument,  automatically set equal to the first entry in AbsorbanceSamplingRate.",
				Category -> "Standards"
			},
			{
				OptionName -> StandardExcitationWavelength,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Single-Channel" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[200 Nanometer, 890Nanometer],
						Units :> Nanometer
					],
					"Multi-Channel" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[200 Nanometer, 890Nanometer],
							Units :> Nanometer
						]
					]
				],
				Description -> "The wavelength(s) that is used to excite fluorescence in the Standard sample in the Fluorescence Detector.",
				ResolutionDescription -> "If Fluorescence Detector is selected, automatically set to the first entry in ExcitationWavelength.",
				Category -> "Standards"
			},
			{
				OptionName -> StandardEmissionWavelength,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Single-Channel" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[200 Nanometer, 890Nanometer],
						Units :> Nanometer
					],
					"Multi-Channel" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[200 Nanometer, 890Nanometer],
							Units :> Nanometer
						]
					]
				],
				Description -> "The wavelength(s) of light at which fluorescence emitted from the Standard sample is measured in the Fluorescence Detector.",
				ResolutionDescription -> "If Fluorescence Detector is selected, automatically set to the first entry in EmissionWavelength.",
				Category -> "Standards"
			},
			{
				OptionName -> StandardEmissionCutOffFilter,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> HPLCEmissionCutOffFilterP
				],
				Description -> "The cut-off wavelength to pre-select the emitted light from the Standard sample and allow only the light with wavelength above the desired value to pass, before the light enters emission monochromator for final wavelength selection for Ultimate 3000 with FLR Detector. If set to None, no cut-off filter is used.",
				ResolutionDescription -> "If a Fluorescence Detector with a cut-off filter wheel is selected, automatically set to the first entry in EmissionCutOffFilter.",
				Category -> "Standards"
			},
			{
				OptionName -> StandardFluorescenceGain,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Constant" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					"Variable Fluorescence Sensitivity" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					]
				],
				Description -> "For each StandardExcitationWavelength/StandardEmissionWavelength pair, the signal amplification factor which modulates the percentage of maximum voltage that can be applied to the Photomultiplier Tube of the Fluorescence Detector during Standard measurement. Linear increase in voltage applied to the Photomultiplier tube leads to an exponential change in RFU signal. Variable Fluorescence Sensitivity implies a different fluorescence sensitivity for each Excitation/Emission Wavelength pair.",
				ResolutionDescription -> "If Fluorescence Detector is selected, automatically set to the first entry in FluorescenceGain.",
				Category -> "Standards"
			},
			{
				OptionName -> StandardFluorescenceFlowCellTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[25 Celsius, 50 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Description -> "The temperature that the thermostat inside the fluorescence flow cell of the Fluorescence Detector is set to during the fluorescence measurement of the Standard sample.",
				ResolutionDescription -> "If Fluorescence Detector is selected and temperature control is available on that unit, automatically set to the first entry in FluorescenceFlowCellTemperature.",
				Category -> "Standards"
			},
			{
				OptionName -> StandardLightScatteringLaserPower,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[10 * Percent, 100 * Percent],
					Units :> Percent
				],
				Description -> "The laser power filter used in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) Detector for the measurement of the Standard sample. 100% means that no filter is being used to restrict the laser power.",
				ResolutionDescription -> "If MultiAngleLightScattering Detector and/or DynamicLightScattering Detector are selected, automatically set to the first entry in LightScatteringLaserPower.",
				Category -> "Standards"
			},
			{
				OptionName -> StandardLightScatteringFlowCellTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[-15 Celsius, 210 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Description -> "The temperature that the thermostat inside the flow cell of the Detector is set to during the Multi-Angle static Light Scattering (MALS) and/or Dynamic Light Scattering (DLS) measurement of the Standard sample.",
				ResolutionDescription -> "If MultiAngleLightScattering Detector and/or DynamicLightScattering Detector are selected, automatically set to the first entry in LightScatteringFlowCellTemperature.",
				Category -> "Standards"
			},
			{
				OptionName -> StandardRefractiveIndexMethod,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[RefractiveIndex, DifferentialRefractiveIndex]
				],
				Description -> "The type of refractive index measurement of the Refractive Index (RI) Detector for the measurement of the Standard. When DifferentialRefractiveIndex is selected, the refractive index difference between the flow downstream sample and the reference solvent is measured. See Figure 2.7.4 for more information.",
				ResolutionDescription -> "If RefractiveIndex Detector is selected and Differential Refractive Index Reference Loading is set to Closed in StandardGradient, automatically set to DifferentialRefractiveIndex. Otherwise automatically set to RefractiveIndex.",
				Category -> "Standards"
			},
			{
				OptionName -> StandardRefractiveIndexFlowCellTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[4 Celsius, 65 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Description -> "The temperature that the thermostat inside the refractive index flow cell of the Refractive Index (RI) Detector is set to during the refractive index measurement of the Standard sample.",
				ResolutionDescription -> "If RefractiveIndex Detector is selected, automatically set to the first entry in RefractiveIndexFlowCellTemperature.",
				Category -> "Standards"
			},
			{
				OptionName -> StandardNebulizerGas,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if Nitrogen sheath gas is flowed along with the Standard sample within the EvaporativeLightScattering Detector.",
				ResolutionDescription -> "If EvaporativeLightScattering is selected, automatically set to the first entry in NebulizerGas.",
				Category -> "Standards"
			},
			{
				OptionName -> StandardNebulizerGasHeating,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the sheath gas that carries samples in the EvaporativeLightScattering Detector is heated for Standard measurement.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and StandardNebulizerGas is True, automatically set to the first entry in NebulizerGasHeating.",
				Category -> "Standards"
			},
			{
				OptionName -> StandardNebulizerHeatingPower,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Percent, 100 * Percent],
					Units :> Percent
				],
				Description -> "The relative magnitude of the heating element used to heat the sheath gas for the EvaporativeLightScattering Detector for Standard measurement (Corresponding temperature not measured by the manufacturer). Higher percent values correspond to percent of power going to heating coil.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and StandardNebulizerGas is True, automatically set to the first entry in NebulizerHeatingPower.",
				Category -> "Standards"
			},
			{
				OptionName -> StandardNebulizerGasPressure,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[20 * PSI, 60 * PSI],
					Units :> PSI
				],
				Description -> "The applied pressure of sheath gas for the EvaporativeLightScattering Detector for Standard measurement (Flow rate unmeasured by the manufacturer). Higher pressure corresponds to faster sheath gas flow.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and StandardNebulizerGas is True, automatically set to the first entry in NebulizerGasPressure.",
				Category -> "Standards"
			},
			{
				OptionName -> StandardDriftTubeTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[20 * Celsius, 100 * Celsius],
					Units :> Celsius
				],
				Description -> "The set temperature of the chamber thermostat through which the nebulized analytes flow within the EvaporativeLightScattering Detector for Standard samples. The purpose to heat the drift tube is to evaporate any unevaporated solvent remaining in the flow from the nebulizer.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and StandardNebulizerGas is True, automatically set to the first entry in DriftTubeTemperature.",
				Category -> "Standards"
			},
			{
				OptionName -> StandardELSDGain,
				Default -> Automatic,
				Description -> "The percent of maximum voltage sent to the Photo Mulitplier Tube (PMT) for signal amplification for the EvaporativeLightScattering measurement. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the PMT.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and StandardNebulizerGas is True, automatically set to the first entry in ELSDGain.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Category -> "Standards"
			},
			{
				OptionName -> StandardELSDSamplingRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * 1 / Second, 80 * 1 / Second], (*can be only specific values*)
					Units -> {-1, {Minute, {Minute, Second}}}
				],
				Description -> "The frequency of evaporative light scattering measurement for Standard samples. Lower values will be less susceptible to noise but will record less frequently across time. Lower or higher values do not affect the y axis of the measurement.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and NebulizerGas is True, automatically set to the first entry in ELSDSamplingRate.",
				Category -> "Standards"
			},
			{
				OptionName -> StandardStorageCondition,
				Default -> Null,
				Description -> "The non-default conditions under which any standards used by this experiment should be stored after the protocol is completed. If left unset, Standard samples will be stored according to their Models' DefaultStorageCondition.",
				AllowNull -> True,
				Category -> "Standards",
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal]
				]
			}
		],

		(* === Blank Options === *)
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
					Pattern :> ObjectP[{Model[Sample], Object[Sample]}]
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
					Pattern :> RangeP[0 Microliter, 16 Milliliter],
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
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> None | First | Last | FirstAndLast | GradientChange
				],
				Widget[
					Type -> Number,
					Pattern :> GreaterP[0, 1]
				]
			],
			Category -> "Blanks"
		},
		IndexMatching[
			IndexMatchingParent -> Blank,
			{
				OptionName -> BlankColumnPosition,
				Default -> Automatic,
				Description -> "The position of the column selector valve and the desired column configuration that will be used for each blank sample as it is injected.",
				ResolutionDescription -> "For a batch of samples automatically set from the specified Column option. If InjectionTable is specified, set from the Column Position for blank Type injections.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> ColumnPositionP
				],
				Category -> "Blanks"
			},
			{
				OptionName -> BlankColumnTemperature,
				Default -> Automatic,
				Description -> "The temperature of the column assembly throughout the Blank gradient and measurement.",
				ResolutionDescription -> "Automatically set to the corresponding gradient temperature specified in the BlankGradient option or the column temperature for the sample in the InjectionTable option; otherwise, set as the first value of the ColumnTemperature option.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[5 Celsius, 90 Celsius],
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
						Pattern :> RangeP[0 Milliliter / Minute, 200 Milliliter / Minute],
						Units -> CompoundUnit[
							{1, {Milliliter, {Milliliter, Liter}}},
							{-1, {Minute, {Minute, Second}}}
						]
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> {Minute, {Second, Minute}}
							],
							"Flow Rate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Milliliter / Minute, 200 Milliliter / Minute],
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
				Description -> "The composition of different specified buffers in BufferA, BufferB, BufferC and BufferD over time in the fluid flow during Blank measurement. Specific parameters of a gradient object can be overridden by specific options. Differential Refractive Index Reference Loading refers to the HPLC refractive index loading reference values as shown in the Figure 2.7.4. When open, the flow downstream of the column is loaded into the two flow cells simultaneously.",
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
								Pattern :> RangeP[0 Milliliter / Minute, 200 Milliliter / Minute],
								Units -> CompoundUnit[
									{1, {Milliliter, {Milliliter, Liter}}},
									{-1, {Minute, {Minute, Second}}}
								]
							],
							"Differential Refractive Index Reference Loading" -> Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Open, Closed, None, Automatic]
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> BlankAbsorbanceWavelength,
				Default -> Automatic,
				Description -> "For Blank measurement, the wavelength of light passed through the flow cell for the UVVis Detector. For PhotoDiodeArray Detector, a 3D data is generated from a spectrum of light passing through the flow cell. Absorbance wavelength in that case represents the wavelength at which a 2D data slice is generated from the 3D data.",
				ResolutionDescription -> "If a UVVis Detector or PhotoDiodeArray Detector is selected or available on the selected instrument, automatically set as the first entry in AbsorbanceWavelength.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Single" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[190 Nanometer, 900 Nanometer],
						Units -> Nanometer
					],
					"All" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					],
					"Range" -> Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[190 Nanometer, 900 Nanometer],
							Units -> Nanometer
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[200 Nanometer, 900 Nanometer],
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
				ResolutionDescription -> "If a PhotoDiodeArray Detector is selected or available on the selected instrument, automatically set as the first entry in WavelengthResolution.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 * Nanometer, 12.0 * Nanometer],
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
				ResolutionDescription -> "If a PhotoDiodeArray Detector is selected or available on the selected instrument, automatically set as the first entry in UVFilter.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankAbsorbanceSamplingRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * 1 / Second, 120 * 1 / Second], (*can be only specific values*)
					Units -> {-1, {Minute, {Minute, Second}}}
				],
				Description -> "The number of times the absorbance measurement is made per second during Blank measurement. Lower values will be less susceptible to noise but will record less frequently across time.",
				ResolutionDescription -> "If a UVVis Detector or PhotoDiodeArray Detector is selected or available on the selected instrument,  automatically set equal to the first entry in AbsorbanceSamplingRate.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankExcitationWavelength,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Single-Channel" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[200 Nanometer, 890Nanometer],
						Units :> Nanometer
					],
					"Multi-Channel" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[200 Nanometer, 890Nanometer],
							Units :> Nanometer
						]
					]
				],
				Description -> "The wavelength(s) that is used to excite fluorescence in the Blank sample in the Fluorescence Detector.",
				ResolutionDescription -> "If Fluorescence Detector is selected, automatically set to the first entry in ExcitationWavelength.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankEmissionWavelength,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Single-Channel" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[200 Nanometer, 890Nanometer],
						Units :> Nanometer
					],
					"Multi-Channel" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[200 Nanometer, 890Nanometer],
							Units :> Nanometer
						]
					]
				],
				Description -> "The wavelength(s) of light at which fluorescence emitted from the Blank sample is measured in the Fluorescence Detector.",
				ResolutionDescription -> "If Fluorescence Detector is selected, automatically set to the first entry in EmissionWavelength.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankEmissionCutOffFilter,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> HPLCEmissionCutOffFilterP
				],
				Description -> "The cut-off wavelength to pre-select the emitted light from the Blank sample and allow only the light with wavelength above the desired value to pass, before the light enters emission monochromator for final wavelength selection for Ultimate 3000 with FLR Detector. If set to None, no cut-off filter is used.",
				ResolutionDescription -> "If a Fluorescence Detector with a cut-off filter wheel is selected, automatically set to the first entry in EmissionCutOffFilter.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankFluorescenceGain,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Constant" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					"Variable Fluorescence Sensitivity" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					]
				],
				Description -> "For each BlankExcitationWavelength/BlankEmissionWavelength pair, the signal amplification factor which modulates the percentage of maximum voltage that can be applied to the Photomultiplier Tube of the Fluorescence Detector during Standard measurement. Linear increase in voltage applied to the Photomultiplier tube leads to an exponential change in RFU signal. Variable Fluorescence Sensitivity implies a different fluorescence sensitivity for each Excitation/Emission Wavelength pair.",
				ResolutionDescription -> "If Fluorescence Detector is selected, automatically set to the first entry in FluorescenceGain.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankFluorescenceFlowCellTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[25 Celsius, 50 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Description -> "The temperature that the thermostat inside the fluorescence flow cell of the Fluorescence Detector is set to during the fluorescence measurement of the Blank sample.",
				ResolutionDescription -> "If Fluorescence Detector is selected and temperature control is available on that unit, automatically set to the first entry in FluorescenceFlowCellTemperature.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankLightScatteringLaserPower,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[10 * Percent, 100 * Percent],
					Units :> Percent
				],
				Description -> "The laser power filter used in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) Detector for the measurement of the Blank sample. 100% means that no filter is being used to restrict the laser power.",
				ResolutionDescription -> "If MultiAngleLightScattering Detector and/or DynamicLightScattering Detector are selected, automatically set to the first entry in LightScatteringLaserPower.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankLightScatteringFlowCellTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[-15 Celsius, 210 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Description -> "The temperature that the thermostat inside the flow cell of the Detector is set to during the Multi-Angle static Light Scattering (MALS) and/or Dynamic Light Scattering (DLS) measurement of the Blank sample.",
				ResolutionDescription -> "If MultiAngleLightScattering Detector and/or DynamicLightScattering Detector are selected, automatically set to the first entry in LightScatteringFlowCellTemperature.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankRefractiveIndexMethod,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[RefractiveIndex, DifferentialRefractiveIndex]
				],
				Description -> "The type of refractive index measurement of the Refractive Index (RI) Detector for the measurement of the Blank. When DifferentialRefractiveIndex is selected, the refractive index difference between the flow downstream sample and the reference solvent is measured. See Figure 2.7.4 for more information.",
				ResolutionDescription -> "If RefractiveIndex Detector is selected and Differential Refractive Index Reference Loading is set to Closed in BlankGradient, automatically set to DifferentialRefractiveIndex. Otherwise automatically set to RefractiveIndex.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankRefractiveIndexFlowCellTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[4 Celsius, 65 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Description -> "The temperature that the thermostat inside the refractive index flow cell of the Refractive Index (RI) Detector is set to during the refractive index measurement of the Blank sample.",
				ResolutionDescription -> "If RefractiveIndex Detector is selected, automatically set to the first entry in RefractiveIndexFlowCellTemperature.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankNebulizerGas,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if Nitrogen sheath gas is flowed along with the Blank sample within the EvaporativeLightScattering Detector.",
				ResolutionDescription -> "If EvaporativeLightScattering is selected, automatically set to the first entry in NebulizerGas.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankNebulizerGasHeating,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the sheath gas that carries samples in the EvaporativeLightScattering Detector is heated for Blank measurement.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and BlankNebulizerGas is True, automatically set to the first entry in NebulizerGasHeating.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankNebulizerHeatingPower,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Percent, 100 * Percent],
					Units :> Percent
				],
				Description -> "The relative magnitude of the heating element used to heat the sheath gas for the EvaporativeLightScattering Detector for Blank measurement (Corresponding temperature not measured by the manufacturer). Higher percent values correspond to percent of power going to heating coil.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and BlankNebulizerGas is True, automatically set to the first entry in NebulizerHeatingPower.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankNebulizerGasPressure,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[20 * PSI, 60 * PSI],
					Units :> PSI
				],
				Description -> "The applied pressure of sheath gas for the EvaporativeLightScattering Detector for Blank measurement (Flow rate unmeasured by the manufacturer). Higher pressure corresponds to faster sheath gas flow.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and BlankNebulizerGas is True, automatically set to the first entry in NebulizerGasPressure.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankDriftTubeTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[20 * Celsius, 100 * Celsius],
					Units :> Celsius
				],
				Description -> "The set temperature of the chamber thermostat through which the nebulized analytes flow within the EvaporativeLightScattering Detector for Blank samples. The purpose to heat the drift tube is to evaporate any unevaporated solvent remaining in the flow from the nebulizer.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and BlankNebulizerGas is True, automatically set to the first entry in DriftTubeTemperature.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankELSDGain,
				Default -> Automatic,
				Description -> "The percent of maximum voltage sent to the Photo Mulitplier Tube (PMT) for signal amplification for the EvaporativeLightScattering measurement. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the PMT.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and BlankNebulizerGas is True, automatically set to the first entry in ELSDGain.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Category -> "Blanks"
			},
			{
				OptionName -> BlankELSDSamplingRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * 1 / Second, 80 * 1 / Second], (*can be only specific values*)
					Units -> {-1, {Minute, {Minute, Second}}}
				],
				Description -> "The frequency of evaporative light scattering measurement for Blank Samples. Lower values will be less susceptible to noise but will record less frequently across time. Lower or higher values do not affect the y axis of the measurement.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and BlankNebulizerGas is True, automatically set to the first entry in ELSDSamplingRate.",
				Category -> "Blanks"
			},
			{
				OptionName -> BlankStorageCondition,
				Default -> Null,
				Description -> "The non-default conditions under which any blanks used by this experiment should be stored after the protocol is completed. If left unset, Blank samples will be stored according to their Models' DefaultStorageCondition.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal]
				]
			}
		],
		(* === End: Blank options === *)
		(* === Column Prime and Flush options === *)
		IndexMatching[
			IndexMatchingParent -> ColumnSelector,
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
				Description -> "The column assembly's temperature at which the ColumnPrimeGradient is run.",
				ResolutionDescription -> "Automatically set to the corresponding gradient temperature specified in the ColumnPrimeGradient option or the column temperature for the column prime in the InjectionTable option; otherwise, set as the first value of the ColumnTemperature option.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[5 Celsius, 90 Celsius],
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
				Description -> "The net speed of the fluid flowing through the pump inclusive of the composition of BufferA, BufferB, BufferC, and BufferD specified in the ColumePrimeGradient options during column prime. This speed is linearly interpolated such that consecutive entries of {Time, Flow Rate} will define the intervening fluid speed. For example, {{0 Minute, 0.3 Milliliter/Minute},{30 Minute, 0.5 Milliliter/Minute}} means flow rate of 0.4 Milliliter/Minute at 15 minutes into the run.",
				ResolutionDescription -> "If ColumnPrimeGradient option is specified, automatically set from the method given in the ColumnPrimeGradient option. If NominalFlowRate of the column model is specified, set to lesser of the NominalFlowRate for each of the columns, guard columns or the instrument's MaxFlowRate. Otherwise set to 1 Milliliter / Minute.",
				AllowNull -> True,
				Category -> "Column Prime",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Milliliter / Minute, 200 Milliliter / Minute],
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
								Pattern :> RangeP[0 Milliliter / Minute, 200 Milliliter / Minute],
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
				Description -> "The composition of different specified buffers in BufferA, BufferB, BufferC and BufferD over time in the fluid flow for column prime. Specific parameters of a gradient object can be overridden by specific options. Differential Refractive Index Reference Loading refers to the HPLC refractive index loading reference values as shown in the Figure 2.7.4. When open, the flow downstream of the column is loaded into the two flow cells simultaneously.",
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
								Pattern :> RangeP[0 Milliliter / Minute, 200 Milliliter / Minute],
								Units -> CompoundUnit[
									{1, {Milliliter, {Milliliter, Liter}}},
									{-1, {Minute, {Minute, Second}}}
								]
							],
							"Differential Refractive Index Reference Loading" -> Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Open, Closed, None, Automatic]
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> ColumnPrimeAbsorbanceWavelength,
				Default -> Automatic,
				Description -> "The wavelength of light passed through the flow for the UVVis and Detector for detection during column prime. For PhotoDiodeArray Detector, a 3D data is generated from a spectrum of light passing through the flow cell. Absorbance wavelength in that case represents the wavelength at which a 2D data slice is generated from the 3D data.",
				ResolutionDescription -> "If a UVVis Detector or PhotoDiodeArray Detector is selected or available on the selected instrument, automatically set equal to the same value as the first entry in AbsorbanceWavelength.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Single" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[190 Nanometer, 900 Nanometer],
						Units -> Nanometer
					],
					"All" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					],
					"Range" -> Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[190 Nanometer, 900 Nanometer],
							Units -> Nanometer
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[200 Nanometer, 900 Nanometer],
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
				ResolutionDescription -> "If a PhotoDiodeArray Detector is selected or available on the selected instrument, automatically set equal to the same value as the first entry in WavelengthResolution.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 * Nanometer, 12.0 * Nanometer],
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
				Description -> "Indicates if UV wavelengths (less than 210 nm) should be blocked from being transmitted through the flow for PhotoDiodeArray Detector during column prime.",
				ResolutionDescription -> "If a PhotoDiodeArray Detector is selected or available on the selected instrument, automatically set to the first entry in UVFilter.",
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeAbsorbanceSamplingRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * 1 / Second, 120 * 1 / Second], (*can be only specific values*)
					Units -> {-1, {Minute, {Minute, Second}}}
				],
				Description -> "The number of times an absorbance measurement is made per second during column prime. Lower values will be less susceptible to noise but will record less frequently across time.",
				ResolutionDescription -> "If a UVVis Detector or PhotoDiodeArray Detector is selected or available on the selected instrument, automatically set equal to the first entry in AbsorbanceSamplingRate.",
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeExcitationWavelength,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Single-Channel" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[200 Nanometer, 890Nanometer],
						Units :> Nanometer
					],
					"Multi-Channel" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[200 Nanometer, 890Nanometer],
							Units :> Nanometer
						]
					]
				],
				Description -> "The wavelength(s) of light that is used to excite fluorescence in the Fluorescence Detector during column prime.",
				ResolutionDescription -> "If Fluorescence Detector is selected, automatically set to the first entry in ExcitationWavelength.",
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeEmissionWavelength,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Single-Channel" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[200 Nanometer, 890Nanometer],
						Units :> Nanometer
					],
					"Multi-Channel" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[200 Nanometer, 890Nanometer],
							Units :> Nanometer
						]
					]
				],
				Description -> "The wavelength(s) of light at which fluorescence emitted from the flow downstream of the column is measured in the Fluorescence Detector during column prime.",
				ResolutionDescription -> "If Fluorescence Detector is selected, automatically set to the first entry in EmissionWavelength.",
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeEmissionCutOffFilter,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> HPLCEmissionCutOffFilterP
				],
				Description -> "The cut-off wavelength to pre-select the emitted light from the flow downstream of the column and allow only the light with wavelength above the desired value to pass, before the light enters emission monochromator for final wavelength selection during column prime for Ultimate 3000 with FLR Detector. If set to None, no cut-off filter is used.",
				ResolutionDescription -> "If a Fluorescence Detector with a cut-off filter wheel is selected, automatically set to the first entry in EmissionCutOffFilter.",
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeFluorescenceGain,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Constant" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					"Variable Fluorescence Sensitivity" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					]
				],
				Description -> "For each ColumnPrimeExcitationWavelength/ColumnPrimeEmissionWavelength pair, the signal amplification factor which modulates the percentage of maximum voltage that can be applied to the Photomultiplier Tube of the Fluorescence Detector during column prime. Linear increase in voltage applied to the Photomultiplier tube leads to an exponential change in RFU signal. Variable Fluorescence Sensitivity implies a different fluorescence sensitivity for each Excitation/Emission Wavelength pair.",
				ResolutionDescription -> "If Fluorescence Detector is selected, automatically set to the first entry in FluorescenceGain.",
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeFluorescenceFlowCellTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[25 Celsius, 50 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Description -> "The temperature that the thermostat inside the fluorescence flow cell of the Fluorescence Detector is set to during column prime.",
				ResolutionDescription -> "If Fluorescence Detector is selected and temperature control is available on that unit, automatically set to the first entry in FluorescenceFlowCellTemperature.",
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeLightScatteringLaserPower,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[10 * Percent, 100 * Percent],
					Units :> Percent
				],
				Description -> "The laser power filter used in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) Detector during column prime measurement. 100% means that no filter is being used to restrict the laser power.",
				ResolutionDescription -> "If MultiAngleLightScattering Detector and/or DynamicLightScattering Detector are selected, automatically set to the first entry in LightScatteringLaserPower.",
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeLightScatteringFlowCellTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[-15 Celsius, 210 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Description -> "The temperature that the thermostat inside the flow cell inside the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector is set to during column prime.",
				ResolutionDescription -> "If MultiAngleLightScattering Detector and/or DynamicLightScattering Detector are selected, automatically set to the first entry in LightScatteringFlowCellTemperature.",
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeRefractiveIndexMethod,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[RefractiveIndex, DifferentialRefractiveIndex]
				],
				Description -> "The type of refractive index measurement of the Refractive Index (RI) Detector during column prime. When DifferentialRefractiveIndex is selected, the refractive index difference between the flow downstream sample and the reference solvent is measured. See Figure 2.7.4 for more information.",
				ResolutionDescription -> "If RefractiveIndex Detector is selected and Differential Refractive Index Reference Loading is set to Closed in ColumnPrimeGradient, automatically set to DifferentialRefractiveIndex. Otherwise automatically set to RefractiveIndex.",
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeRefractiveIndexFlowCellTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[4 Celsius, 65 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Description -> "The temperature that the thermostat inside the refractive index flow cell of the Refractive Index (RI) Detector is set to during column prime.",
				ResolutionDescription -> "If RefractiveIndex Detector is selected, automatically set to the first entry in RefractiveIndexFlowCellTemperature.",
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeNebulizerGas,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if Nitrogen sheath gas is flowed with the buffer(s) within the EvaporativeLightScattering Detector during column prime.",
				ResolutionDescription -> "If EvaporativeLightScattering is selected, automatically set to the first entry in NebulizerGas.",
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeNebulizerGasHeating,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the sheath gas that carries buffer(s) in the EvaporativeLightScattering Detector is heated during column prime.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and ColumnPrimeNebulizerGas is True, automatically set to the first entry in NebulizerGasHeating.",
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeNebulizerHeatingPower,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Percent, 100 * Percent],
					Units :> Percent
				],
				Description -> "The relative magnitude of the heating element used to heat the sheath gas for the EvaporativeLightScattering Detector during column prime (Corresponding temperature not measured by the manufacturer). Higher percent values correspond to percent of power going to heating coil.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and ColumnPrimeNebulizerGas is True, automatically set to the first entry in NebulizerHeatingPower.",
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeNebulizerGasPressure,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[20 * PSI, 60 * PSI],
					Units :> PSI
				],
				Description -> "The applied pressure of sheath gas for the EvaporativeLightScattering Detector during column prime (Flow rate unmeasured by the manufacturer). Higher pressure corresponds to faster sheath gas flow.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and ColumnPrimeNebulizerGas is True, automatically set to the first entry in NebulizerGasPressure.",
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeDriftTubeTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[20 * Celsius, 100 * Celsius],
					Units :> Celsius
				],
				Description -> "The set temperature of the chamber thermostat through which the nebulized analytes flow within the EvaporativeLightScattering Detector during Column Prime. The purpose to heat the drift tube is to evaporate any unevaporated solvent remaining in the flow from the nebulizer.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and ColumnPrimeNebulizerGas is True, automatically set to the first entry in DriftTubeTemperature.",
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeELSDGain,
				Default -> Automatic,
				Description -> "The percent of maximum voltage sent to the Photo Mulitplier Tube (PMT) for signal amplification for the EvaporativeLightScattering measurement. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the PMT.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and ColumnPrimeNebulizerGas is True, automatically set to the first entry in ELSDGain.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Category -> "Column Prime"
			},
			{
				OptionName -> ColumnPrimeELSDSamplingRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * 1 / Second, 80 * 1 / Second],
					Units -> {-1, {Minute, {Minute, Second}}}
				],
				Description -> "The frequency of evaporative light scattering measurement during column prime. Lower values will be less susceptible to noise but will record less frequently across time. Lower or higher values do not affect the y axis of the measurement.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and ColumnPrimeNebulizerGas is True, automatically set to the first entry in ELSDSamplingRate.",
				Category -> "Column Prime"
			},
			(* --- Column Flush Gradient Parameters --- *)
			{
				OptionName -> ColumnFlushTemperature,
				Default -> Automatic,
				Description -> "The column assembly's temperature at which the ColumnFlushGradient is run.",
				ResolutionDescription -> "Automatically set to the corresponding gradient temperature specified in the ColumnFlushGradient option or the column temperature for the column flush in the InjectionTable option; otherwise, set as the first value of the ColumnTemperature option.",
				AllowNull -> True,
				Category -> "Column Flush",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[5 Celsius, 90 Celsius],
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
						Pattern :> RangeP[0 Milliliter / Minute, 200 Milliliter / Minute],
						Units -> CompoundUnit[
							{1, {Milliliter, {Milliliter, Liter}}},
							{-1, {Minute, {Minute, Second}}}
						]
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
								Units -> {Minute, {Second, Minute}}
							],
							"Flow Rate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Milliliter / Minute, 200 Milliliter / Minute],
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
				Description -> "The composition of different specified buffers in BufferA, BufferB, BufferC and BufferD over time in the fluid flow for column prime. Specific parameters of a gradient object can be overridden by specific options. Differential Refractive Index Reference Loading refers to the HPLC refractive index loading reference values as shown in the Figure 2.7.4. When open, the flow downstream of the column is loaded into the two flow cells simultaneously.",
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
								Pattern :> RangeP[0 Milliliter / Minute, 200 Milliliter / Minute],
								Units -> CompoundUnit[
									{1, {Milliliter, {Milliliter, Liter}}},
									{-1, {Minute, {Minute, Second}}}
								]
							],
							"Differential Refractive Index Reference Loading" -> Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Open, Closed, None, Automatic]
							]
						},
						Orientation -> Vertical
					]
				]
			},
			{
				OptionName -> ColumnFlushAbsorbanceWavelength,
				Default -> Automatic,
				Description -> "The wavelength of light passed through the flow for the UVVis and Detector for detection during column flush. For PhotoDiodeArray Detector, a 3D data is generated from a spectrum of light passing through the flow cell. Absorbance wavelength in that case represents the wavelength at which a 2D data slice is generated from the 3D data.",
				ResolutionDescription -> "If a UVVis Detector or PhotoDiodeArray Detector is selected or available on the selected instrument, automatically set equal to the same value as the first entry in AbsorbanceWavelength.",
				AllowNull -> True,
				Widget -> Alternatives[
					"Single" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[190 Nanometer, 900 Nanometer],
						Units -> Nanometer
					],
					"All" -> Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[All]
					],
					"Range" -> Span[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[190 Nanometer, 900 Nanometer],
							Units -> Nanometer
						],
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[200 Nanometer, 900 Nanometer],
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
				ResolutionDescription -> "If a PhotoDiodeArray Detector is selected or available on the selected instrument, automatically set equal to the same value as the first entry in WavelengthResolution.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.1 * Nanometer, 12.0 * Nanometer],
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
				ResolutionDescription -> "If a PhotoDiodeArray Detector is selected or available on the selected instrument, automatically set to the first entry in UVFilter.",
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushAbsorbanceSamplingRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * 1 / Second, 120 * 1 / Second], (*can be only specific values*)
					Units -> {-1, {Minute, {Minute, Second}}}
				],
				Description -> "The number of times an absorbance measurement is made per second during column flush. Lower values will be less susceptible to noise but will record less frequently across time.",
				ResolutionDescription -> "If a UVVis Detector or PhotoDiodeArray Detector is selected or available on the selected instrument, automatically set equal to the first entry in AbsorbanceSamplingRate.",
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushExcitationWavelength,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Single-Channel" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[200 Nanometer, 890Nanometer],
						Units :> Nanometer
					],
					"Multi-Channel" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[200 Nanometer, 890Nanometer],
							Units :> Nanometer
						]
					]
				],
				Description -> "The wavelength(s) of light that is used to excite fluorescence in the Fluorescence Detector during column flush.",
				ResolutionDescription -> "If Fluorescence Detector is selected, automatically set to the first entry in ExcitationWavelength.",
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushEmissionWavelength,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Single-Channel" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[200 Nanometer, 890Nanometer],
						Units :> Nanometer
					],
					"Multi-Channel" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[200 Nanometer, 890Nanometer],
							Units :> Nanometer
						]
					]
				],
				Description -> "The wavelength(s) of light at which fluorescence emitted from the flow downstream of the column is measured in the Fluorescence Detector during column flush.",
				ResolutionDescription -> "If Fluorescence Detector is selected, automatically set to the first entry in EmissionWavelength.",
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushEmissionCutOffFilter,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> HPLCEmissionCutOffFilterP
				],
				Description -> "The cut-off wavelength to pre-select the emitted light from the flow downstream of the column and allow only the light with wavelength above the desired value to pass, before the light enters emission monochromator for final wavelength selection during column flush for Ultimate 3000 with FLR Detector. If set to None, no cut-off filter is used.",
				ResolutionDescription -> "If a Fluorescence Detector with a cut-off filter wheel is selected, automatically set to the first entry in EmissionCutOffFilter.",
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushFluorescenceGain,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					"Constant" -> Widget[
						Type -> Quantity,
						Pattern :> RangeP[0 Percent, 100 Percent],
						Units -> Percent
					],
					"Variable Fluorescence Sensitivity" -> Adder[
						Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						]
					]
				],
				Description -> "For each ColumnFlushExcitationWavelength/ColumnFlushEmissionWavelength pair, the signal amplification factor which modulates the percentage of maximum voltage that can be applied to the Photomultiplier Tube of the Fluorescence Detector during column flush. Linear increase in voltage applied to the Photomultiplier tube leads to an exponential change in RFU signal. Variable Fluorescence Sensitivity implies a different fluorescence sensitivity for each Excitation/Emission Wavelength pair.",
				ResolutionDescription -> "If Fluorescence Detector is selected, automatically set to the first entry in FluorescenceGain.",
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushFluorescenceFlowCellTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[25 Celsius, 50 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Description -> "The temperature that the thermostat inside the fluorescence flow cell of the Fluorescence Detector is set to during column flush.",
				ResolutionDescription -> "If Fluorescence Detector is selected and temperature control is available on that unit, automatically set to the first entry in FluorescenceFlowCellTemperature.",
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushLightScatteringLaserPower,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[10 * Percent, 100 * Percent],
					Units :> Percent
				],
				Description -> "The laser power filter used in the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) Detector during column flush measurement. 100% means that no filter is being used to restrict the laser power.",
				ResolutionDescription -> "If MultiAngleLightScattering Detector and/or DynamicLightScattering Detector are selected, automatically set to the first entry in LightScatteringLaserPower.",
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushLightScatteringFlowCellTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[-15 Celsius, 210 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Description -> "The temperature that the thermostat inside the flow cell inside the Multi-Angle static Light Scattering (MALS) and Dynamic Light Scattering (DLS) detector is set to during column flush.",
				ResolutionDescription -> "If MultiAngleLightScattering detector and/or DynamicLightScattering detector are selected, automatically set to the first entry in LightScatteringFlowCellTemperature.",
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushRefractiveIndexMethod,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[RefractiveIndex, DifferentialRefractiveIndex]
				],
				Description -> "The type of refractive index measurement of the Refractive Index (RI) Detector during column flush. When DifferentialRefractiveIndex is selected, the refractive index difference between the flow downstream sample and the reference solvent is measured. See Figure 2.7.4 for more information.",
				ResolutionDescription -> "If RefractiveIndex Detector is selected and Differential Refractive Index Reference Loading is set to Closed in ColumnFlushGradient, automatically set to DifferentialRefractiveIndex. Otherwise automatically set to RefractiveIndex.",
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushRefractiveIndexFlowCellTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[4 Celsius, 65 Celsius],
						Units -> Celsius
					],
					Widget[
						Type -> Enumeration,
						Pattern :> Alternatives[Ambient]
					]
				],
				Description -> "The temperature that the thermostat inside the refractive index flow cell of the Refractive Index (RI) Detector is set to during column flush.",
				ResolutionDescription -> "If RefractiveIndex detector is selected, automatically set to the first entry in RefractiveIndexFlowCellTemperature.",
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushNebulizerGas,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if Nitrogen sheath gas is flowed with the buffer(s) within the EvaporativeLightScattering Detector during column flush.",
				ResolutionDescription -> "If EvaporativeLightScattering is selected, automatically set to the first entry in NebulizerGas.",
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushNebulizerGasHeating,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Description -> "Indicates if the sheath gas that carries buffer(s) in the EvaporativeLightScattering Detector is heated during column flush.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and ColumnFlushNebulizerGas is True, automatically set to the first entry in NebulizerGasHeating.",
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushNebulizerHeatingPower,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 * Percent, 100 * Percent],
					Units :> Percent
				],
				Description -> "The relative magnitude of the heating element used to heat the sheath gas for the EvaporativeLightScattering Detector during column flush (Corresponding temperature not measured by the manufacturer). Higher percent values correspond to percent of power going to heating coil.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and ColumnFlushNebulizerGas is True, automatically set to the first entry in NebulizerHeatingPower.",
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushNebulizerGasPressure,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[20 * PSI, 60 * PSI],
					Units :> PSI
				],
				Description -> "The applied pressure of sheath gas for the EvaporativeLightScattering Detector during column flush (Flow rate unmeasured by the manufacturer). Higher pressure corresponds to faster sheath gas flow.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and ColumnFlushNebulizerGas is True, automatically set to the first entry in NebulizerGasPressure.",
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushDriftTubeTemperature,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[20 * Celsius, 100 * Celsius],
					Units :> Celsius
				],
				Description -> "The set temperature of the chamber thermostat through which the nebulized analytes flow within the EvaporativeLightScattering Detector during Column Flush. The purpose to heat the drift tube is to evaporate any unevaporated solvent remaining in the flow from the nebulizer.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and ColumnFlushNebulizerGas is True, automatically set to the first entry in DriftTubeTemperature.",
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushELSDGain,
				Default -> Automatic,
				Description -> "The percent of maximum voltage sent to the Photo Mulitplier Tube (PMT) for signal amplification for the EvaporativeLightScattering measurement. The percentage value specified here is converted into a unitless factor from 0 to 1000 which the software accepts to modulate the voltage for the PMT.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and ColumnFlushNebulizerGas is True, automatically set to the first entry in ELSDGain.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				],
				Category -> "Column Flush"
			},
			{
				OptionName -> ColumnFlushELSDSamplingRate,
				Default -> Automatic,
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 * 1 / Second, 80 * 1 / Second], (*can be only specific values*)
					Units -> {-1, {Minute, {Minute, Second}}}
				],
				Description -> "The frequency of evaporative light scattering measurement during column flush. Lower values will be less susceptible to noise but will record less frequently across time. Lower or higher values do not affect the y axis of the measurement.",
				ResolutionDescription -> "If EvaporativeLightScattering Detector is selected and ColumnFlushNebulizerGas is True, automatically set to the first entry in ELSDSamplingRate.",
				Category -> "Column Flush"
			}
		],
		(* === END: Column Prime and Flush Options === *)
		FuntopiaSharedOptions,
		{
			OptionName -> InjectionSampleVolumeMeasurement,
			Default -> False,
			Description -> "Indicates if any liquid samples prepared in the sub SamplePreparationProtocols of are volume checked prior to injection to provide QC data.",
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> BooleanP],
			Category -> "Sample Preparation"
		},
		SamplesInStorageOptions,
		SamplesOutStorageOptions

	}
];



Error::ObjectDoesNotExist = "The following objects, `1`, could not be found. Please verify that the objects' ID or Name exist in the database.";
Error::ContainerlessSamples = "The samples `1` are not in a container. Please make sure their containers are accurately uploaded.";
Error::RetiredChromatographyInstrument = "The specified instrument `1` are retired and cannot be used. Please select another instrument or specify its model, `2`.";
Error::DeprecatedInstrumentModel = "The specified instrument model `1` are deprecated and no longer supported. Please specify a different model or allow automatic instrument resolution.";
Error::InvalidHPLCAlternateInstruments = "The specified Instrument option cannot be fulfill the other experiment options. Please specify different instrument models in this option or allow it to resolve automatically.";
Error::HPLCIncompatibleAliquotContainer = "The specified AliquotContainer is not compatible with an instrument's autosampler. Please use a compatible container type: `1`.";
Error::HPLCTooManySamples = "The number of samples and/or aliquots are in too many containers and cannot fit on one of the required instrument's autosampler.";
Error::SamplesOutStorageConditionRequired = "The input samples for which fraction collection is specified have multiple distinct storage conditions. Please specify SamplesOutStorageCondition to disambiguate fraction sample storage.";
Warning::ConflictingInjectionSampleVolumeMeasurementOption = "The InjectionSampleVolumeMeasurement option was specified True, but PreparatoryUnitOperations/PreparatoryPrimitives option were not specified. InjectionSampleVolumeMeasurement option will be ignored.";

Error::StandardOptionsButNoStandard = "Standard cannot be Null, if other Standard options `1` are set. Please specify a Standard or allow the other Standard options to be automatically resolved.";
Error::BlankOptionsButNoBlank = "Blank cannot be Null, if other Blank options `1` are set. Please specify a Blank or allow the other Blank options to be automatically resolved.";
Error::ColumnOptionsButNoColumn = "ColumnSelector and Column options cannot be Null, if other Column options `1` are set. Please allow ColumnSelector and Column options to resolve automatically or set it to the desired columns.";

Warning::IncompatibleColumnType = "The specified `1` `2` has a SeparationMode of `3` which is not the same as the selected SeparationMode for the experiment (`4`).";
Warning::VariableColumnTypes = "The specified Columns `1` have a SeparationMode of `2`. When using Column SeparationMode to resolve automatic options, only the SeparationMode for the first column will be considered.";
(* This warning is thrown in HPLC, SFC, and FPLC so it needs the `4` to specify that *)
Warning::IncompatibleColumnTechnique = "The specified `1` `2` has a ChromatographyType of `3` and may not perform as expected using the `4` ChromatographyType.";
(* 1: column temperature option name 2: invalid temperatures 3: column option name 4: column object 5,6: min/max temperature *)
Warning::IncompatibleColumnTemperature = "The specified column temperatures (`1`) are outside the specified `2` (`3`) temperature range of `4` to `5`. To prevent column damage, use column temperatures within this compatible range or specify a different column.";
Error::ReverseMoreThanOneColumn = "ColumnOrientation cannot be Reverse with more than two columns specified. Please set ColumnOrientation to Forward or specify only one column.";
Error::ColumnGap = "There are gaps between the following column options `1`. Please make sure the columns are connected with each other without gaps or allow these options to resolve automatically.";
Error::GuardColumnSelector = "The specified GuardColumn option must match the Guard Column in the ColumnSelector option. Please set the GuardColumn and ColumnSelector options to be the same Model[Item,Column]/Object[Item,Column] or allow one of the options to be resolved automatically.";
Error::ColumnOrientationSelector = "The specified GuardColumnOrientation and ColumnOrientation options must match the corresponding column orientations in the ColumnSelector option. Please set the GuardColumnOrientation, ColumnOrientation and ColumnSelector options to be copacetic or allow one of the options to be resolved automatically.";
Error::ColumnSelectorConflict = "The specified ColumnSelector does not match other the column options. Please allow ColumnSelector to resolve automatically or modify ColumnSelector to match the other column options.";
Error::HPLCColumnsCannotFit = "The specified columns cannot fit into the instrument's column oven compartment. Please check the Dimensions of the column and the MaxColumnLength of the instruments or make sure IncubateColumn is set to False and all the specified column temperature values are set to Ambient temperatures.";
Error::HPLCCannotIncubateColumn = "To incubate column to a non-ambient temperature, columns must fit into the instrument's column oven compartment and IncubateColumn option must be set to True. Please reset IncubateColumn option or select smaller columns to continue.";
Error::HPLCCannotIncubateColumnWaters = "Column compartment cannot be skipped for the instrument `1` that is specified or best fit the other options. Please reset IncubateColumn option or select another instrument to continue.";
Error::InjectionTableColumnConflictHPLC = "The specified column positions in InjectionTable require more sets of column assemblies that specified in the Column and ColumnSelector options. Please specify ColumnSelector option to match the required number of column sets or allow the options to resolve automatically.";
Error::ColumnPositionColumnConflict = "The specified ColumnPosition options require more sets of column assemblies that specified in the Column and ColumnSelector options. Please specify ColumnSelector option to match the required number of column sets or allow the options to resolve automatically.";
Error::DuplicateColumnSelectorPositions = "The specified ColumnSelector options has duplicated Column Positions. Only one set of columns can be installed per column selector position. Please specify different Column Positions.";
Error::ColumnPositionInjectionTableConflict = "The specified InjectionTable does not match the required column positions in ColumnPosition/ StandardColumnPosition/ BlankColumnPosition options. Please update them to be copacetic or allow the options to resolve automatically.";
Error::ColumnTemperatureInjectionTableConflict = "The specified InjectionTable does not match the required column temperatures in `1` options. Please update them to be copacetic or allow the options to resolve automatically.";

Warning::InsufficientSampleVolume = "The samples `1` do not have sufficient volume for the injection volume (default to 10 uL for Analytical measurement or 500 uL for SemiPreparative measurement) plus the autosampler's dead volume of `2`. The experiment will still attempt to make injections with what is currently available; please change the InjectionVolume options if this is not desired.";

Error::HPLCInstrumentScaleConflict = "The specified Instrument option `1` include the instrument model Model[Instrument, HPLC, \"Agilent 1290 Infinity II LC System\"] and other ECL-supported HPLC instruments. Due to the different container and volume requirements of the different instruments, this instrument cannot be selected with other instruments for one HPLC protocol. Please update the Instrument option to have only one type of HPLC instruments or allow it to be resolved automatically.";
Error::MissingHPLCScaleInstrument = "The experiment is resolved to be performed at the Preparative scale but the specified Instrument option `1` does not include the Preparative scale instrument model Model[Instrument, HPLC, \"Agilent 1290 Infinity II LC System\"]. Please update the Instrument option to have the correct HPLC instrument or allow it to be resolved automatically.";
Error::UnsupportedSampleTemperature = "The specified Instrument `1` do not support the SampleTemperature option since its autosampler is not equipped with a temperature controller. Please specify another instrument or allow SampleTemperature to be automatically resolved.";
Error::UnsupportedBufferD = "The specified Instrument `1` does not support the BufferD specification option because its pump only supports three buffers. Please use another instrument or any specified options related to BufferD.";
Error::UnsupportedGradientD = "The specified Instrument `1` does not support gradient specifications that use BufferD since its pump only supports three buffers. Please use another instrument or remove any specified options related to BufferD.";
Error::WavelengthOutOfRange = "The specified `1` value(s) (`2`) are outside of the specified Instrument's (`3`) combined wavelength range of `4` to `5`. Please provide Wavelength options that are within the instrument's operating range or select other instruments.";
Error::BufferDMustExistForInstrument = "The specified Instrument, `1`, must have a BufferD and is therefore incompatible with BufferD->Null specification. Please set BufferD to Automatic or an Object[Sample]/Model[Sample] in order to use this instrument or select a different instrument.";
Error::BufferDMustExistForSampleTemperature = "The only instrument that supports SampleTemperature specification must have BufferD. Please remove the BufferD->Null or SampleTemperature specification.";
Error::BufferDMustExistForGradient = "BufferD cannot be set to Null when Gradient or GradientD specify usage of BufferD. Please modify gradient usage or specify BufferD as an object.";
Error::IncompatibleInstrumentBufferD = "BufferD and its gradient are only available on the Waters Acquity UPLC H-Class instrument and cannot support fraction collection. Please remove any specified options related to BufferD or remove fraction collection options.";
Error::WavelengthTemperatureConflict = "The specified `1` value(s) (`2`) are out of range for the instrument which supports SampleTemperature specification (Model[Instrument,HPLC,\"Waters Acquity UPLC H-Class PDA\"]). Please use wavelengths within range or remove temperature specification.";
Error::ColumnSelectorInstrumentConflict = "The specified ColumnSelector option (`1`) requires a total of `2` sets of columns, which is not compatible with the required instrument supporting all other parameters (`3`). Please select a different instrument or fewer column sets.";
Error::ScaleInstrumentConflict = "The specified Scale (`1`) is not compatible with the required instrument supporting all other parameters (`2`). Please specify scale as Analytical.";
Error::SampleTemperatureConflict = "No suitable instrument exists that supports the specified SampleTemperature and all other options (e.g. Scale -> Preparative or FractionCollection -> True). Consider relaxing options to allow for a suitable instrument or not specifying SampleTemperature.";
Error::IncompatibleDetectionWavelength = "The specified absorbance wavelengths are not within the compatible range of the best instrument (`1` to `2`).";
Error::IncompatibleNeedleWash = "BufferC and NeedleWashSolution cannot be specified differently for the Instrument `1`. Please set both NeedleWashSolution and BufferC to the same Object[Sample]/Model[Sample] or select an instrument that supports different BufferC and NeedleWashSolution solutions.";
Error::IncompatibleHPLCColumnTemperature = "No instrument is available to meet the specified column temperature values. The allowed column temperature range is `1` to `2`. Please adjust the desired column temperature.";
Error::InvalidHPLCMaxAcceleration = "The specified MaxAcceleration (`1`) is either greater than the MaxAcceleration of the required instrument model and column(s) (`2`)  or less than the instrument's MinAcceleration. Please specify a value less than the maximum, greater than the minimum or leave MaxAcceleration and MinAcceleration as Automatic.";
Error::IncompatibleContainerAndNeedleWashBuffer = "When BufferC and NeedleWashSolution are different, all sample containers must fit into an instrument with Quaternary buffer system like `1`. Please set BufferC and NeedleWashSolution to the same buffer or allow aliquoting samples into the same plates for HPLC experiment.";
Error::IncompatibleFractionCollectionAndNeedleWashBuffer = "There is no available instrument that support both SemiPreparative fraction collection and different BufferC and NeedleWashSolution solutions. Please set BufferC and NeedleWashSolution to the same buffer or set CollectFractions to False.";
Error::NoSuitableHPLCInstrument = "There is no HPLC instrument that can match all the required options. Please check ExperimentHPLC help file for the specifications of all available instruments and select a desired instrument in the Instrument option.";
Error::NonSupportedHPLCInstrument = "Waters Acquity UPLC I-Class instruments are currently supported only in ExperimentLCMS and cannot be used in ExperimentHPLC.";
Error::NoSuitableInstrumentForDetection = "The specified detectors `1` are not available in any instrument compatible with other options. Please change the detector specified in `2` or allow them to resolve automatically.";
Error::HPLCIncompatibleInjectionVolume = "The following InjectionVolume/StandardInjectionVolume/BlankInjectionVolume values: `1` are not within the acceptable injection volume range for `2`. The range is `3` to `4`. Please specify lower or higher volumes, or select a different instrument that supports different injection volume ranges.";
Warning::HPLCSmallInjectionVolume = "The following InjectionVolume/StandardInjectionVolume/BlankInjectionVolume values: `1` are smaller than the recommended injection volume `2`. The minimum recommended volume is `3`. Please consider increasing the injection volume for better results.";

Error::InvalidFractionCollectionContainer = "The selected FractionCollectionContainer `1` is not supported with the selected scale `2`. Please use `3` instead.";
Error::FractionCollectionDetectorConflict = "Fraction collection parameters cannot be specified when the specified Detector does not match the AbsorbanceDetector (`2`) of the instrument supporting fraction collection (`1`). Please remove fraction collection parameter specification or Detector value.";
Error::InvalidFractionCollectionEndTime = "The specified FractionCollectionEndTime values `1` are greater than their corresponding gradient durations. Please ensure the maximum fraction collection time is less than the total gradient runtime.";
Warning::ConflictFractionOptionSpecification = "The specified options `1` conflict with the resolution of no fraction collection. These options will be ignored.";
Error::ConflictingFractionCollectionMethodOptions = "When FractionCollectionMethod is specified, the other fraction collection options (AbsoluteThreshold, and PeakEndThreshold, PeakSlope and PeakEndThreshold) should be in accordance with the FractionCollectionMethod. Please specify only the FractionCollectionMethod or the other options.";
Error::HPLCConflictingFractionCollectionOptions = "There is a conflict between the FractionCollectionMode option and Peak and/or Thresholding options.  If FractionCollectionMode is set to Threshold, PeakSlope, PeakSlopeDuration, and PeakEndThreshold must not be specified. If FractionCollectionMode is set to Peak, AbsoluteThreshold must not be specified. If FractionCollectionMode is Time, PeakSlope, and PeakSlopeEnd, AbsoluteThreshold, and PeakEndThreshold must not be specified.";
Error::MissingFractionCollectionDetector = "The specified FractionCollectionDetector `1` is not a member of the available detectors `2` on the resolved HPLC instrument `3`. Please change Detector or Instrument to use a different instrument or specify another FractionCollectionDetector.";
Error::ConflictFractionCollectionUnit = "To use `1` as the FractionCollectionDetector, the `2` options should be set to the correct unit `3`. Please set all option values correctly or allow them to resolve automatically.";

Error::InvalidGradientCompositionOptions = "The specified gradient buffer compositions for analyte(s) in options `1` do not sum to 100% at all timepoints. Please check the provided gradients and make sure all buffers sum to 100% at every timepoint.";
Warning::HPLCBufferConflict = "The resolved values of `1` differ from provided gradient method(s). The experiment will commence as directed with the former value(s).";
Error::InjectionTableColumnGradientConflict = "For the Injection Table, each column should have the same ColumnPrime gradient and the same ColumnFlush gradient. Please make sure the same ColumnPrime gradient and ColumnFlush gradient are selected.";
Error::InjectionTableGradientConflict = "The provided gradient methods for the same sample in the InjectionTable do not match each other in the following options: `1`. Please set them to the same value or allow one of them to resolve automatically.";
Warning::RemovedExtraGradientEntries = "A specified gradient in `1` after rounding to acceptable time had duplicate entries. The duplicates were removed.";
Warning::OverwritingGradient = "The inherited gradient will be overwritten based on setting of other options: `1`. Please review and ensure that it meets desired specifications.";
Error::GradientSingleton = "The following options have only one entry in the gradient table: `1` At least 2 are need.";
Warning::HPLCGradientNotReequilibrated = "The gradients occurring before the sample injections of `1` at index `2` of the input samples, do not re-equilibrate the gradient. This may lead to the analyte prematurely eluting. We recommend running the gradient for at least 1.5 times column volume. Please consider setting ColumnRefreshFrequency -> 1.";
Error::IncompatibleFlowRate = "The required flow rate for samples `1` is more than the required instrument's or columns' maximum flow rate (`2`). Please specify a compatible flow rate.";
Error::IncompatibleStandardFlowRate = "The required flow rate for standards `1` is not less than the required instrument's or columns' maximum flow rate (`2`). Please specify a compatible flow rate.";
Error::IncompatibleBlankFlowRate = "The required flow rate for blanks `1` is not less than the required instrument's or columns' maximum flow rate (`2`). Please specify a compatible flow rate.";
Error::IncompatibleColumnPrimeFlowRate = "The required flow rate for the column prime of column selector `1` is not less than the required instrument's or columns' maximum flow rate (`2`). Please specify a compatible flow rate.";
Error::IncompatibleColumnFlushFlowRate = "The required flow rate for the column flush of column selector `1` is not less than the required instrument's or columns' maximum flow rate (`2`). Please specify a compatible flow rate.";

Error::DetectorConflict = "The specified Detector option (`3`) are not available in the list of available Detectors (`2`) of the specified instrument (`1`). Please refer to the ExperimentHPLC Help File to find a different instrument with all desired Detector or select different detectors in the Detector option.";
Error::InvalidHPLCDetectorOptions = "The following detectors `1` are not available in the specified `2` option while its detector related options `3` are specified. Please add the additional detectors to the Detector option, choose another instrument, or allow the related options to resolve automatically.";
Error::ConflictHPLCDetectorOptions = "Some of the detector related options `1` are specified while the others are set to Null for `2` detector. Please specify all of these options if the detector is desired, or set all of these options to Null if the detector is not desired, or allow all the options to resolve automatically.";
Error::MissingHPLCDetectorOptions = "When `1` detector is requested, the following options `2` cannot be Null. Please specify the desired values in the options or allow these options to resolve automatically.";
Error::UnsupportedSampleTemperatureAndDetectors = "The detector related options `1` requested `2` detectors. These detectors are only available on HPLC instruments without SampleTemperature support. Please select different detectors (in the Detector option or in detector-related options) or remove the SampleTemperature specification.";
Error::UnsupportedBufferDAndDetectors = "The detector-related options `1` requested `2` detectors. These detectors are only available on HPLC instruments without BufferD support. Please select different detectors (in the Detector option or in detector-related options) or remove the BufferD specification.";
Error::UnsupportedGradientDAndDetectors = "The detector related options `1` requested `2` detectors. These detectors are only available on HPLC instruments that do not support GradientD. Please select different detectors (in the Detector option or in detector-related options) or remove gradient specifications that use BufferD.";

Error::WavelengthResolutionConflict = "The specified options for AbsorbanceWavelength and WavelengthResolution conflict. When AbsorbanceWavelength is a single value, the corresponding WavelengthResolution option must be left unspecified. Please allow WavelengthResolution to be automatically resolved or provide a wavelength range in AbsorbanceWavelength option.";
Warning::AbsorbanceRateAdjusted = "The following absorbance sampling rate options, `1`, can only be specific values and were set to the closest one.";
Warning::WavelengthResolutionAdjusted = "The following wavelength resolution options, `1`, can only be specific values and were set to the closest one.";
Warning::UVVisOptionsNotApplicable = "The following options `1` are not available for the UVVis detector on the instrument best suited to meet all options. These options will be ignored.";
Error::FractionCollectionWavelengthConflict = "CollectFractions is set to True for `1` but the AbsorbanceWavelength is not a single wavelength value. Please provide a single AbsorbanceWavelength for fraction collection.";
Error::GasPressureRequiresNebulizer = "The specified NebulizerGasPressure options require that NebulizerGas is True or Automatic. Please change NubulizerGas to True or allow it to be automatically resolved.";
Error::GasHeatingRequiresNebulizer = "The specified NebulizerGasHeating options require that NebulizerGas is True or Automatic. Please change NubulizerGas to True or allow it to be automatically resolved.";
Error::HeatingPowerRequiresNebulizerHeating = "The specified NebulizerGasHeating options require that NebulizerGas is True or Automatic and that NebulizerGasHeating is also True or Automatic. Please change NebulizerGas and NebulizerGasHeating to True or allow both options to be automatically resolved.";

Error::MissingHPLCpHCalibrationOptions = "When pHCalibration is set to True, the related options `1` cannot be Null. Please specify the desired values in these options.";
Error::InvalidHPLCpHCalibrationOptions = "When pHCalibration is False or Null, the related options `1` cannot be specified. Please set pHCalibration to True if calibration is desired, set the related options to Null or allow these options to resolve automatically.";
Error::MissingHPLCConductivityCalibrationOptions = "When ConductivityCalibration is set to True, the related options `1` cannot be Null. Please specify the desired values in these options.";
Error::InvalidHPLCConductivityCalibrationOptions = "When ConductivityCalibration is False or Null, the related options `1` cannot be specified. Please set ConductivityCalibration to True if calibration is desired, set the related options to Null or allow these options to resolve automatically.";
Warning::HPLCpHCalibrationBufferSwapped = "The LowpHCalibrationTarget is larger than HighpHCalibrationTarget. The two calibration buffers will be swapped during calibration. Please choose different calibration buffers if this is not desired.";

Error::HPLCEmissionLowerThanExcitation = "The following options `1` (for `2` `3`) have excitation wavelengths that are larger than the emission wavelengths. Please ensure that the excitation wavelengths are lower than the emission wavelengths.";
Error::HPLCEmissionExcitationTooNarrow = "The following options `1` (for `2` `3`) have excitation wavelengths that are within 20 nm of the emission wavelengths. The `4` instrument cannot support emission wavelength within 20 nm of excitation wavelength. Please select different wavelength values or seleect another instrument.";
Error::ConflictHPLCFluorescenceOptionsLengths = "The following options `1` contain different numbers of fluorescence detection channels for `2` `3`. Please ensure that there is a 1:1:1 ratio of excitation wavelengths, emission wavelengths, and fluorescence gains.";
Error::HPLCFluorescenceWavelengthLimit = "The following options `1` have specified too many specified fluorescence channels to measure for `2` `3`. Only up to `4` channels can be measured per sample. Please ensure that the number of fluorescence channels is less than `4` per sample.";
Error::InvalidHPLCEmissionCutOffFilter = "The fluorescence emission cut-off filter is not available on `1`. Please set the option `2` to Null or select a different instrument (like `3`).";
Error::TooLargeHPLCEmissionCutOffFilter = "For `1` `2`, the selected `3` `4` should not be larger than `5` `6` so that the emission light can pass through the cut-off filter and reach the emission monochromator for final wavelength selection. Please specify a larger emission cut-off filter value or set it to Open to allow lights of all wavelengths to pass through.";
Error::InvalidWatersHPLCFluorescenceGain="When `1` is used, the fluorescence gain option `2` can only be set to a constant value for multi-channel fluorescence measurement. Please correct the option values to continue.";
Error::InvalidHPLCFluorescenceFlowCellTemperature = "The fluorescence flow cell temperature control is not available on `1`. Please set the option `2` to Null or select a different instrument (like `3`).";
Error::ConflictRefractiveIndexMethod = "For `3` `4`, when DifferentialRefractiveIndex method is selected in `1`, the gradient in `2` should have the differential refractive index reference loading closed. Please select RefractiveIndex instead or choose a different gradient.";
Warning::RepeatedDetectors = "The specified Detector option `1` has repeated entries. The repeat entries have been removed.";


(* ::Subsection:: *)
(* ExperimentHPLC Constants *)

(* Prep HPLC Racks *)
(* 30 x 100 mm Tube Container for Preparative HPLC *)
$LargeAgilentHPLCAutosamplerRack=Model[Container, Rack, "id:n0k9mGko1Ldr"];
(* 16 x 100 mm Tube Container for Preparative HPLC *)
$SmallAgilentHPLCAutosamplerRack=Model[Container, Rack, "id:Z1lqpMl3m9Mz"];

(* HPLC Columns *)
(* "XBridge Shield RP18 XP Column 130A, 2.5 um 4.6 x 75mm" *)
$DefaultLCMSColumn=Model[Item, Column, "id:KBL5DvYOa5vv"];
(* "SEC Protein Column for MALS, 5 um, 500 A" *)
$DefaultSizeExclusionColumn=Model[Item, Column, "id:qdkmxzq7GA9V"];
(*  Prep C18 HPLC 50x50 Column *)
$DefaultReversePhasePreparativeColumn=Model[Item, Column, "id:o1k9jAkaXB77"];
(* Aeris XB-C18 Peptide Column (15 cm) *)
$DefaultReversePhaseAnalyticalColumn=Model[Item, Column, "id:o1k9jAKOw6d7"];
(* DNAPac PA200, 9x250mm *)
$DefaultIonExchangePreparativeColumn=Model[Item, Column, "id:rea9jl1or6Np"];
(* "DNAPac PA200 4x250mm Column" *)
$DefaultIonExchangeAnalyticalColumn=Model[Item, Column, "id:zGj91aR3d6GL"];
$DefaultHPLCColumns=List[$DefaultLCMSColumn,$DefaultSizeExclusionColumn,$DefaultReversePhasePreparativeColumn,$DefaultReversePhaseAnalyticalColumn,$DefaultIonExchangePreparativeColumn,$DefaultIonExchangeAnalyticalColumn];

(* ::Subsection:: *)
(* ExperimentHPLC *)


(* ::Subsubsection:: *)
(* ExperimentHPLC *)


(* Core Sample Overload *)
ExperimentHPLC[mySamples : ListableP[ObjectP[Object[Sample]]], myOptions : OptionsPattern[]] := Module[
	{listedSamples, listedOptions, outputSpecification, output, gatherTestsQ, validSamplePreparationResult, mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples, samplePreparationCache, safeOps, safeOpsTests, validLengthsQ, validLengthTests,
		templatedOptions, templateTests, inheritedOptions, expandedSafeOps, instrumentFields, modelInstrumentFields, columnFields,
		modelColumnFields, gradientFields, fractionCollectionFields, sampleFields, modelContainerFields, optionsWithObjects,
		userSpecifiedObjects, objectsExistQs, simulatedSampleQ, objectsExistTests, availableInstruments, allObjects, sampleObjects, modelSampleObjects, modelContainerObjects,
		instrumentObjects, objectSampleFields, modelSampleFields, modelSampleFieldsPacket, objectContainerFields, modelContainerFieldsPacket, analyteFields,
		modelContainerSyringeFields, syringeContainerFieldsPacket,
		modelInstrumentObjects, columnObjects, modelColumnObjects, gradientObjects, fractionCollectionObjects, syringeObject, cacheBall,
		resolvedOptionsResult, resolvedOptions, resolvedOptionsTests, collapsedResolvedOptions, protocolObject, resourcePackets,
		resourcePacketTests, cartridgeObjects, modelCartridgeObjects, cartridgeFields, modelCartridgeFields,
		mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed, syringeFields},

	(* Make sure we're working with a list of options *)
	{listedSamples, listedOptions} = removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTestsQ = MemberQ[output, Tests];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, samplePreparationCache} = simulateSamplePreparationPackets[
			ExperimentHPLC,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];
		Return[$Failed]
	];

	(* Call SafeOptions to make sure all options match pattern *)
	{safeOpsNamed, safeOpsTests} = If[gatherTestsQ,
		SafeOptions[ExperimentHPLC, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False, Output -> {Result, Tests}],
		{SafeOptions[ExperimentHPLC, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], {}}
	];

	(* Sanitize named inputs *)
	{mySamplesWithPreparedSamples, safeOps, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOpsNamed, myOptionsWithPreparedSamplesNamed];

	(* If the specified options don't match their patterns or if option lengths are invalid return $Failed *)
	If[MatchQ[safeOps, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOpsTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Call ValidInputLengthsQ to make sure all options are the right length *)
	{validLengthsQ, validLengthTests} = If[gatherTestsQ,
		ValidInputLengthsQ[ExperimentHPLC, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentHPLC, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[!validLengthsQ,
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Use any template options to get values for options not specified in myOptions *)
	{templatedOptions, templateTests} = If[gatherTestsQ,
		ApplyTemplateOptions[ExperimentHPLC, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentHPLC, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples], Null}
	];

	(* Return early if the template cannot be used - will only occur if the template object does not exist. *)
	If[MatchQ[templatedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* Replace our safe options with our inherited options from our template. *)
	inheritedOptions = ReplaceRule[safeOps, templatedOptions];

	(* Expand index-matching options *)
	expandedSafeOps = Last[ExpandIndexMatchedInputs[ExperimentHPLC, {mySamplesWithPreparedSamples}, inheritedOptions]];

	(* Disallow Upload->False and Confirm->True. *)
	(* Not making a test here because Upload is a hidden option and we don't currently make tests for hidden options. *)
	If[MatchQ[Lookup[safeOps, Upload], False] && TrueQ[Lookup[safeOps, Confirm]],
		Message[Error::ConfirmUploadConflict];
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOpsTests, validLengthTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(*-- DOWNLOAD THE INFORMATION THAT WE NEED FOR OUR OPTION RESOLVER AND RESOURCE PACKET FUNCTION --*)
	(* Fields to download from any instrument objects *)
	instrumentFields = {
		Packet[Model, Status, MinColumnTemperature, MaxColumnTemperature],
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
			AbsorbanceDetector,
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
		}]],
		Packet[Model[Field[SystemPrimeGradients[[All, 2]]][{Gradient, BufferA, BufferB, BufferC, BufferD, RefractiveIndexReferenceLoading}]]],
		Packet[Model[Field[SystemFlushGradients[[All, 2]]][{Gradient, BufferA, BufferB, BufferC, BufferD, RefractiveIndexReferenceLoading}]]],
		Packet[Model[Field[AutosamplerDeckModel]][{Positions}]]
	};

	(* Fields to download from any model instrument objects *)
	modelInstrumentFields = {
		Packet[
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
			AbsorbanceDetector,
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

	(* Fields to download from any column objects *)
	columnFields = {
		Packet[Model],
		Packet[Model[{SeparationMode, ChromatographyType, MaxAcceleration, MinFlowRate, MaxFlowRate, MaxPressure, PreferredGuardColumn, PreferredColumnJoin, MinTemperature, MaxTemperature, PreferredGuardCartridge, Dimensions, Diameter}]],
		Packet[Model[PreferredGuardColumn][{SeparationMode, ChromatographyType, MaxAcceleration, MinFlowRate, MaxFlowRate, MaxPressure, PreferredGuardColumn, PreferredColumnJoin, MinTemperature, MaxTemperature, PreferredGuardCartridge, Dimensions, Diameter}]]
	};

	(* Fields to download from any column model objects *)
	modelColumnFields = {
		Packet[SeparationMode, ChromatographyType, MaxAcceleration, MinFlowRate, MaxFlowRate, MaxPressure, PreferredGuardColumn, PreferredColumnJoin, MinTemperature, MaxTemperature, PreferredGuardCartridge, Dimensions, Diameter, StorageBuffer],
		Packet[PreferredGuardColumn[{SeparationMode, ChromatographyType, MaxAcceleration, MinFlowRate, MaxFlowRate, MaxPressure, PreferredGuardColumn, PreferredColumnJoin, MinTemperature, MaxTemperature, PreferredGuardCartridge, Dimensions, Diameter, StorageBuffer}]]};

	(* Fields to download from any cartridge objects *)
	cartridgeFields = {
		Packet[Model],
		Packet[Model[{PreferredGuardColumn, MaxPressure}]],
		Packet[Model[PreferredGuardColumn][{SeparationMode, ChromatographyType, MaxAcceleration, MinFlowRate, MaxFlowRate, MaxPressure, PreferredGuardColumn, PreferredColumnJoin, MinTemperature, MaxTemperature}]]
	};

	(* Fields to download from any cartridge model objects *)
	modelCartridgeFields = {
		Packet[PreferredGuardColumn, MaxPressure],
		Packet[PreferredGuardColumn[{SeparationMode, ChromatographyType, MaxAcceleration, MinFlowRate, MaxFlowRate, MaxPressure, PreferredGuardColumn, PreferredColumnJoin, MinTemperature, MaxTemperature}]]};

	(* Set fields to download from gradient objects *)
	gradientFields = {Packet[BufferA, BufferB, BufferC, BufferD, Gradient, RefractiveIndexReferenceLoading, Temperature]};

	(* Set fields to download from fraction collection method objects *)
	fractionCollectionFields = {Packet[FractionCollectionMode, FractionCollectionStartTime, FractionCollectionEndTime, AbsoluteThreshold, PeakSlope, PeakSlopeDuration, PeakEndThreshold, MaxFractionVolume, MaxCollectionPeriod]};

	(* Define all the fields that we want *)
	objectSampleFields = Union[SamplePreparationCacheFields[Object[Sample]], {Analytes, Density, LightSensitive, State, IncompatibleMaterials}];
	modelSampleFields = Union[SamplePreparationCacheFields[Model[Sample]], {pH, Conductivity, IncompatibleMaterials}];
	analyteFields = {Object, PolymerType, MolecularWeight, FluorescenceExcitationMaximums, FluorescenceEmissionMaximums, ExtinctionCoefficients};
	objectContainerFields = Union[SamplePreparationCacheFields[Object[Container]]];
	modelContainerFields = Union[{DefaultStorageCondition,NumberOfPositions}, SamplePreparationCacheFields[Model[Container]]];
	modelContainerSyringeFields = Union[{InnerDiameter, OuterDiameter}, modelContainerFields];

	(* Set fields to download from mySamples *)
	sampleFields = {
		Packet[Sequence @@ objectSampleFields],
		Packet[Model[modelSampleFields]],
		Packet[Analytes[analyteFields]],
		Packet[Field[Composition[[All, 2]]][{Object, Name, PolymerType, MolecularWeight, FluorescenceExcitationMaximums, FluorescenceEmissionMaximums, ExtinctionCoefficients}]],
		Packet[Container[objectContainerFields]],
		Packet[Container[Model][modelContainerFields]]
	};

	(* Fields to download for the samples *)
	modelSampleFieldsPacket = {Packet[Sequence @@ modelSampleFields]};

	(* Container Model fields to download ; also Syringe Model[Container] fields to download*)
	modelContainerFieldsPacket = {Packet[Sequence @@ modelContainerFields]};
	syringeContainerFieldsPacket = {Packet[Sequence @@ modelContainerSyringeFields]};

	(* Any options whose values _could_ be an object *)
	optionsWithObjects = {
		Column,
		SecondaryColumn,
		TertiaryColumn,
		ColumnSelector,
		GuardColumn,
		Instrument,
		InjectionTable,
		BufferA,
		BufferB,
		BufferC,
		BufferD,
		NeedleWashSolution,
		Gradient,
		FractionCollectionMethod,
		FractionCollectionContainer,
		Standard,
		StandardGradient,
		Blank,
		BlankGradient,
		ColumnPrimeGradient,
		ColumnFlushGradient,
		LowpHCalibrationBuffer,
		HighpHCalibrationBuffer,
		ConductivityCalibrationBuffer,
		ColumnStorageBuffer
	};

	(* Extract any objects that the user has explicitly specified *)
	userSpecifiedObjects = DeleteDuplicates@Cases[
		Flatten@Join[ToList[mySamples], Lookup[ToList[myOptions], optionsWithObjects, Null]],
		ObjectP[]
	];

	(* Check that the specified objects exist or are visible to the current user *)
	simulatedSampleQ = Map[
		If[MatchQ[#, ObjectP[Lookup[samplePreparationCache, Object, {}]]],
			Lookup[fetchPacketFromCache[#, samplePreparationCache], Simulated, False],
			False
		]&,
		userSpecifiedObjects
	];
	objectsExistQs = DatabaseMemberQ[PickList[userSpecifiedObjects, simulatedSampleQ, False]];

	(* Build tests for object existence *)
	objectsExistTests = If[gatherTestsQ,
		MapThread[
			Test[StringTemplate["Specified object `1` exists in the database:"][#1], #2, True]&,
			{PickList[userSpecifiedObjects, simulatedSampleQ, False], objectsExistQs}
		],
		{}
	];

	(* If objects do not exist, return failure *)
	If[!(And @@ objectsExistQs),
		If[!gatherTestsQ,
			Message[Error::ObjectDoesNotExist, PickList[PickList[userSpecifiedObjects, simulatedSampleQ, False], objectsExistQs, False]];
			Message[Error::InvalidInput, PickList[PickList[userSpecifiedObjects, simulatedSampleQ, False], objectsExistQs, False]]
		];
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests, objectsExistTests],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* All the instruments to download and possibly use from memoization *)
	availableInstruments = allHPLCInstrumentSearch["Memoization"][[1]];

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
					(* Vials used for standards/blanks *)
					Model[Container, Vessel, "1mL HPLC Vial (total recovery)"],
					Model[Container, Vessel, "HPLC vial (high recovery)"],
					Model[Container, Vessel, "HPLC vial (flat bottom)"],
					Model[Container, Vessel, "Amber HPLC vial (high recovery)"],
					Model[Container, Vessel, "HPLC vial (high recovery), LCMS Certified"],
					(* Preparatory HPLC *)
					Model[Container, Vessel, "15mL Tube"],
					Model[Container, Vessel, "50mL Tube"],
					Model[Container, Vessel, "15mL Light Sensitive Centrifuge Tube"],
					Model[Container, Vessel, "50mL Light Sensitive Centrifuge Tube"],
					(* Instruments *)
					availableInstruments,
					(* Autosampler Racks *)
					Model[Container, Rack, "HPLC Vial Rack"],
					Model[Container, Rack, "Waters Acquity UPLC Autosampler Rack"],
					Experiment`Private`$LargeAgilentHPLCAutosamplerRack,
					Experiment`Private`$SmallAgilentHPLCAutosamplerRack,
					(* Default Buffers *)
					Model[Sample, StockSolution, "id:9RdZXvKBeEbJ"],
					Model[Sample, StockSolution, "id:Vrbp1jG80zwE"],
					Model[Sample, StockSolution, "id:8qZ1VWNmdLbb"],
					Model[Sample, StockSolution, "id:eGakld01zKqx"],
					Model[Sample, "id:8qZ1VWNmdLBD"],
					Model[Sample, "id:O81aEB4kJXr1"],
					Model[Sample, StockSolution, "id:AEqRl9KNxZPp"]
				},
				(* All options that _could_ have an object *)
				Lookup[expandedSafeOps, optionsWithObjects]
			],
			ObjectP[]
		],
		Object
	];

	(* Isolate objects of particular types so we can build a indexed-download call *)
	sampleObjects = Cases[allObjects, NonSelfContainedSampleP];
	modelSampleObjects = Cases[allObjects, ObjectP[Model[Sample]]];
	modelContainerObjects = Cases[allObjects, ObjectP[Model[Container]]];
	instrumentObjects = Cases[allObjects, ObjectP[Object[Instrument, HPLC]]];
	modelInstrumentObjects = Cases[allObjects, ObjectP[Model[Instrument, HPLC]]];
	columnObjects = Cases[allObjects, ObjectP[Object[Item, Column]]];
	modelColumnObjects = Cases[allObjects, ObjectP[Model[Item, Column]]];
	gradientObjects = Cases[allObjects, ObjectP[Object[Method, Gradient]]];
	fractionCollectionObjects = Cases[allObjects, ObjectP[Object[Method, FractionCollection]]];
	cartridgeObjects = Cases[allObjects, ObjectP[Object[Item, Cartridge, Column]]];
	modelCartridgeObjects = Cases[allObjects, ObjectP[Model[Item, Cartridge, Column]]];
	syringeObject = {Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"]};

	(* Make one download for all possible parameters needed *)
	cacheBall = DeleteCases[
		FlattenCachePackets@Quiet[
			{
				samplePreparationCache,
				Download[
					{sampleObjects, modelSampleObjects, modelContainerObjects, instrumentObjects, modelInstrumentObjects, columnObjects, modelColumnObjects, gradientObjects, fractionCollectionObjects, cartridgeObjects, modelCartridgeObjects, syringeObject},
					{sampleFields, modelSampleFieldsPacket, modelContainerFieldsPacket, instrumentFields, modelInstrumentFields, columnFields, modelColumnFields, gradientFields, fractionCollectionFields, cartridgeFields, modelCartridgeFields, syringeContainerFieldsPacket},
					Cache -> samplePreparationCache,
					Date -> Now
				]
			},
			{Download::FieldDoesntExist}
		],
		Null
	];

	(* Build the resolved options *)
	resolvedOptionsResult = If[gatherTestsQ,
		(* We are gathering tests. This silences any messages being thrown. *)
		{resolvedOptions, resolvedOptionsTests} = resolveExperimentHPLCOptions[
			ToList[mySamplesWithPreparedSamples],
			expandedSafeOps,
			Cache -> cacheBall,
			Output -> {Result, Tests}
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> resolvedOptionsTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{resolvedOptions, resolvedOptionsTests} = {
				resolveExperimentHPLCOptions[
					mySamplesWithPreparedSamples,
					expandedSafeOps,
					Cache -> cacheBall
				],
				{}
			},
			$Failed,
			{Error::InvalidInput, Error::InvalidOption}
		]
	];

	(* Collapse the resolved options *)
	collapsedResolvedOptions = CollapseIndexMatchedOptions[
		ExperimentHPLC,
		resolvedOptions,
		(* Ignore options which were explicitly input *)
		Ignore -> myOptionsWithPreparedSamples,
		Messages -> False
	];

	(* If option resolution failed, return early. *)
	If[MatchQ[resolvedOptionsResult, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests, resolvedOptionsTests],
			Options -> RemoveHiddenOptions[ExperimentHPLC, collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* Build packets with resources *)
	{resourcePackets, resourcePacketTests} = If[gatherTestsQ,
		HPLCResourcePacketsNew[mySamplesWithPreparedSamples, templatedOptions, resolvedOptions, Cache -> cacheBall, Output -> {Result, Tests}],
		{HPLCResourcePacketsNew[mySamplesWithPreparedSamples, templatedOptions, resolvedOptions, Cache -> cacheBall], {}}
	];

	(* If Result does not exist in the output, return everything without uploading *)
	If[!MemberQ[output, Result],
		Return[outputSpecification /. {
			Result -> Null,
			Tests -> Join[safeOpsTests, validLengthTests, templateTests, objectsExistTests, resolvedOptionsTests, resourcePacketTests],
			Options -> RemoveHiddenOptions[ExperimentHPLC, collapsedResolvedOptions],
			Preview -> Null
		}]
	];

	(* We have to return the result. Call UploadProtocol[...] to prepare our protocol packet (and upload it if asked). *)
	protocolObject = If[!MatchQ[resourcePackets, $Failed],
		UploadProtocol[
			First[resourcePackets],
			Rest[resourcePackets] /. {} -> Null,
			Upload -> Lookup[safeOps, Upload],
			Confirm -> Lookup[safeOps, Confirm],
			ParentProtocol -> Lookup[safeOps, ParentProtocol],
			Priority -> Lookup[safeOps, Priority],
			StartDate -> Lookup[safeOps, StartDate],
			HoldOrder -> Lookup[safeOps, HoldOrder],
			QueuePosition -> Lookup[safeOps, QueuePosition],
			ConstellationMessage -> Object[Protocol, HPLC],
			Cache -> samplePreparationCache
		],
		$Failed
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> protocolObject,
		Tests -> Flatten[{safeOpsTests, validLengthTests, templateTests, objectsExistTests, resolvedOptionsTests, resourcePacketTests}],
		Options -> RemoveHiddenOptions[ExperimentHPLC, collapsedResolvedOptions],
		Preview -> Null
	}

];


(* Container overload *)
ExperimentHPLC[myContainers : ListableP[ObjectP[{Object[Container], Object[Sample]}] | _String | {LocationPositionP, _String | ObjectP[Object[Container]]}], myOptions : OptionsPattern[]] := Module[
	{listedContainers, listedOptions, outputSpecification, output, gatherTestsQ, validSamplePreparationResult, mySamplesWithPreparedSamples,
		myOptionsWithPreparedSamples, samplePreparationCache, mySamples, mySampleOptions, containerToSampleOutput, mySampleCache,
		containerToSampleTests, containerToSampleResult, updatedCache},

	(* Make sure we're working with a list of options *)
	{listedContainers, listedOptions} = removeLinks[ToList[myContainers], ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTestsQ = MemberQ[output, Tests];

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, samplePreparationCache} = simulateSamplePreparationPackets[
			ExperimentHPLC,
			ToList[listedContainers],
			ToList[myOptions]
		],
		$Failed,
		{Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		ClearMemoization[Experiment`Private`simulateSamplePreparationPackets];Return[$Failed]
	];

	(* Convert our given containers into samples and sample index-matched options. *)
	containerToSampleResult = If[gatherTestsQ,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests} = containerToSampleOptions[
			ExperimentHPLC,
			mySamplesWithPreparedSamples,
			myOptionsWithPreparedSamples,
			Output -> {Result, Tests},
			Cache -> samplePreparationCache
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			containerToSampleOutput = containerToSampleOptions[
				ExperimentHPLC,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Cache -> samplePreparationCache
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];

	(* Update our cache with our new simulated values. *)
	updatedCache = Flatten[{
		samplePreparationCache,
		Lookup[listedOptions, Cache, {}]
	}];

	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult, $Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification /. {
			Result -> $Failed,
			Tests -> containerToSampleTests,
			Options -> $Failed,
			Preview -> Null
		},
		{mySamples, mySampleOptions, mySampleCache} = containerToSampleOutput;
		(* Call our main function with our samples and converted options. *)
		ExperimentHPLC[mySamples, ReplaceRule[mySampleOptions, Cache -> updatedCache]]
	]
];


(* ::Subsubsection::Closed:: *)
(* resolveExperimentHPLCOptions *)


DefineOptions[
	resolveExperimentHPLCOptions,
	Options :> {
		{InternalUsage -> False, BooleanP, "Indicates if this function is being called from another function (e.g. ExperimentLCMS) or not."},
		HelperOutputOption,
		CacheOption
	}
];


resolveExperimentHPLCOptions[mySamples : {ObjectP[Object[Sample]]...}, myOptions : {_Rule...}, ops : OptionsPattern[resolveExperimentHPLCOptions]] := Module[
	{outputSpecification, output, gatherTestsQ, messagesQ, engineQ, testOrNull, warningOrNull, cache, simulatedSamplePackets,
		samplePrepOptions, hplcOptions, samplePrepTests, simulatedSamples,
		resolvedSamplePrepOptions, simulatedCache, optionsAssociation,
		samplePackets, sampleStatuses, discardedSamples,
		discardedSamplesTest, sampleContainers, simulatedSampleContainers,
		simulatedSampleContainerModels, containerlessSamples,
		containersExistTest, validNameQ, validNameTest,
		instrumentStatusTests, columnTemperatureOptions,
		roundedOptionsAssociation, roundingTests,
		specifiedColumnModelPackets, specifiedGuardColumnModelPackets,
		specifiedGuardCartridgeModelPackets, specifiedColumnTypes,
		typeColumnCompatibleQ, typeColumnCompatibleBool, typeColumnTest,
		specifiedGuardColumnTypes, typeGuardColumnCompatibleQ,
		typeGuardColumnCompatibleBool, typeGuardColumnTest,
		specifiedColumnTechniques, columnTechniqueCompatibleQ,
		columnTechniqueTest, specifiedGuardColumnTechniques,
		guardColumnTechniqueCompatibleQ, guardColumnTechniqueTest,
		columnTemperatureTests, fractionCollectionOptions,
		absorbanceWavelengthOptions, tuvAbsorbanceWavelengthBool,
		pdaAbsorbanceWavelengthBool, tuvOptions, pdaOptions, elsdOptions,
		flrOptions, excitationWavelengthFlrOptions,
		emissionWavelengthFlrOptions, dionexFlrOptions,
		lightScatteringOptions, refractiveIndexSingleOptions,
		refractiveIndexGradientOptions, refractiveIndexOptions, pHOptions,
		conductivityOptions, numberOfReplicates, specifiedGradients,
		availableInstruments, testHPLCInstruments,
		dionexHPLCInstruments, agilentHPLCInstruments, watersHPLCInstruments, dionexpHInstrument,
		dionexHPLCPattern, agilentHPLCPattern, allHPLCInstruments,
		nonDionexHPLCInstruments, allHPLCInstrumentPackets,
		dionexHPLCInstrumentPackets, nonDionexHPLCInstrumentPackets,
		dionexDetectors, nondionexDetectors, dionexOnlyDetectors,
		instrumentConflictInvalidOptions, requiredInstrumentConflictTests,
		conflictUVOpsQ, conflictPDAOpsQ, conflictFlrOpsQ, conflictELSDOpsQ,
		conflictCDOpsQ, conflictLightScatteringOpsQ, conflictRIOpsQ,
		conflictpHOpsQ, conflictConductivityOpsQ, conflictDetectorOptions,
		conflictDetectorTests, resolvedSeparationMode, collectFractions,
		resolvedColumn, resolvedGuardColumn, resolvedGuardColumnModelPackets,
		resolvedType, semiResolvedDetector, resolvedGuardColumnOrientation,
		incompatibleDetectionWavelengthsQ,
		injectionTableLookup, compatibleColumnTemperatureRanges,
		compatibleColumnTemperatureRange,
		compatibleGuardColumnTemperatureRanges,
		compatibleGuardColumnTemperatureRange, specifiedColumnTemperatures,
		incompatibleColumnTemperatures, incompatibleGuardColumnTemperatures,
		guardColumnTemperatureTests, invalidStandardBlankOptions,
		invalidStandardBlankTests, resolvedStandardFrequency,
		resolvedStandard, resolvedBlankFrequency, resolvedBlank,
		injectionTableTypes, standardOptionSpecifiedBool, standardExistsQ,
		standardOptionSpecifiedQ, defaultStandard, blankOptionSpecifiedBool,
		refractiveIndexDetectorQ, blankExistsQ, defaultBlank,
		resolvedStandardBlankOptions, resolvedInstrument,
		instrumentResolutionTests, instrumentModelPacket, instrumentModel,
		instrumentSpecificOptionSet, columnSelectorInitialLookup,
		preexpandedStandardOptions, preresolvedStandard,
		preexpandedBlankOptions, preresolvedBlank, watersAbsorbanceOptions,
		validContainerCountQ, containerCountTest, tooManyInvalidInputs,
		preresolvedAliquotBools, validAliquotContainerBools,
		compatibleContainers, namedCompatibleContainers,
		validAliquotContainerTest,
		resolvedAliquotContainers, requiredAliquotVolumes,
		preresolvedAliquotOptions, fractionCollectionObjectPositions,
		fractionCollectionObjects, needlewashBufferCDistinctInstruments,
		fractionCollectionPackets, resolvedBufferA, resolvedBufferB,
		resolvedBufferC, resolvedBufferD, resolvedNeedleWashSolution,
		standardOptions, standardFrequency, expandedStandardOptions,
		blankOptions, specifiedFractionBool, conflictingFractionOptions,
		preWavefunctionResolution,
		blankFrequency, expandedBlankOptions,
		specifiedSampleColumnTemperatures,columnTemperatureInjectionTableConflictQ,
		specifiedStandardColumnTemperatures, standardColumnTemperatureInjectionTableConflictQ,
		specifiedBlankColumnTemperatures, blankColumnTemperatureInjectionTableConflictQ,
		specifiedPrimeColumnTemperatures, columnPrimeTemperatureInjectionTableConflictQ,
		specifiedFlushColumnTemperatures, columnFlushTemperatureInjectionTableConflictQ,
		resolvedColumnTemperatures, resolvedPrimeColumnTemperatures, resolvedFlushColumnTemperatures, resolvedStandardColumnTemperatures, resolvedBlankColumnTemperatures,
		columnTemperatureInjectionTableConflictOptions,
		columnTemperatureInjectionTableConflictTest,
		instrumentSpecificOptionInvalidOptions, injectionTableSpecifiedQ,
		columnSelectorSpecifiedQ, columnOptions, mainOptionsColumns, columnSelectorColumns,
		allColumnObjects, maxAccelerationLookup,
		maxAccelerationInstruments, resolvedColumnSelector,
		defaultColumnPosition, resolvedColumnPosition,
		resolvedColumnSelection,
		columnPositionInjectionTableConflictQ, standardColumnPositionInjectionTableConflictQ, blankColumnPositionInjectionTableConflictQ,
		columnPositionInjectionTableConflictOptions,columnPositionInjectionTableConflictTest,
		columnSelectorConflictQ, autosamplerDeckModel,
		availableAutosamplerRacks, specifiedAliquotBools,
		preResolvedRequiredAliquotVolumes, possibleAliquotingSamplesTuples,
		groupedAliquotingSamplesTuples, volumeFitAliquotContainerQ,
		preresolvedConsolidateAliquots, invalidContainerModelBools,
		uniqueAliquotableSamples, uniqueNonAliquotablePlates,
		uniqueNonAliquotableVessels, uniqueNonAliquotableSmallVessels, uniqueNonAliquotableLargeVessels, uniqueNonSuitableContainers,
		defaultStandardBlankContainer,
		standardBlankContainerMaxVolume, standardBlankSampleMaxVolume,
		standardInjectionTuples, blankInjectionTuples,
		expandedStandardInjectionTuples, expandedBlankInjectionTuples,
		gatheredStandardInjectionTuples, gatheredBlankInjectionTuples,
		standardPartitions, blankPartitions,
		numberOfStandardBlankContainersRequired, validDionexCountQ,
		validWatersCountQ, agilentRackPositionRules, agilentSmallRackCount, agilentLargeRackCount, requestedFractionRack, validAgilentCountQ, containerCountBool, countCapableInstruments,
		instrumentSpecificTests, columnLookup,
		columnSelectorLookup, injectionTableSampleConflictQ, injectionTableStandardConflictQ, injectionTableBlankConflictQ,
		specifiedColumnPositions, injectionTableColumnPositions, defaultColumn,
		columnLookupNoGap,secondaryColumnLookupNoGap,tertiaryColumnLookupNoGap,columnGapQ,
		columnSelectorNoGap,columnSelectorGapQ,
		columnPositionConflictQ,columnPositionDuplicateQ,
		columnPositionConflictOptions,columnPositionConflictTest,
		duplicateColumnPositionOptions,duplicateColumnPositionTest,
		columnSelectorSampleConflictQ, tableColumnPositionConflictQ,
		secondaryColumnLookup, tertiaryColumnLookup, guardColumnLookup,
		guardColumnOrientationLookup, columnOrientationLookup,
		expandedColumnSelectorOptions, guardColumnSelectorConflictBool,
		resolvedSecondaryColumn, resolvedTertiaryColumn,
		secondaryColumnSelectorSampleConflictQ, tertiaryColumnSelectorSampleConflictQ,
		resolvedStandardColumnPosition, tableColumnStandardConflictQ,
		columnSelectorStandardConflictQ, resolvedBlankColumn,
		resolvedBlankColumnPosition, tableColumnBlankConflictQ,
		columnSelectorBlankConflictQ, resolvedScale,
		resolvedColumnRefreshFrequency, resolvedInjectionTableResult,
		injectionTableTests, resolvedInjectionTable,
		injectionTableInvalidOptions, resolvedEmail,
		resolvedAnalyteGradients, analyteGradientTests,
		resolvedStandardGradients, standardGradientTests,
		resolvedBlankGradients, blankGradientTests,
		resolvedColumnPrimeGradients, columnPrimeGradientTests,
		resolvedColumnFlushGradients, columnFlushGradientTests,
		resolvedGradientAs, resolvedGradientBs, resolvedGradientCs,
		resolvedGradientDs, resolvedFlowRates, resolvedStandardGradientAs,
		resolvedStandardGradientBs, resolvedStandardGradientCs,
		resolvedStandardGradientDs, resolvedStandardFlowRates,
		resolvedBlankGradientAs, resolvedBlankGradientBs,
		resolvedBlankGradientCs, resolvedBlankGradientDs,
		resolvedBlankFlowRates, resolvedColumnPrimeGradientAs,
		resolvedColumnPrimeGradientBs, resolvedColumnPrimeGradientCs,
		resolvedColumnPrimeGradientDs, resolvedColumnPrimeFlowRates,
		resolvedColumnFlushGradientAs, resolvedColumnFlushGradientBs,
		resolvedColumnFlushGradientCs, resolvedColumnFlushGradientDs,
		resolvedColumnFlushFlowRates, compatibleColumnPrimeFlowRateBool,
		compatibleColumnPrimeFlowRateQ, validColumnPrimeFlowRateTest,
		compatibleColumnFlushFlowRateBool, compatibleColumnFlushFlowRateQ,
		validColumnFlushFlowRateTest, autosamplerDeadVolume,
		defaultInjectionVolume, standardOptionTests, standardVolumes,
		standardInjectionVolumeOptionValues, columnSelectorOptions,
		columnSelectorPrimaryColumns, columnSelectorConflictOptions,
		semiResolvedColumnStorageBuffers, semiResolvedColumnStorageBufferPositions,
		resolvedColumnStorageBuffer, columnSelectorConflictTest,
		tableColumnConflictQ, tableColumnConflictOptions,
		tableColumnConflictTest, resolvedStandardAnalyticalGradients,
		standardGradientInjectionTableSpecifiedDifferentlyBool,
		standardInvalidGradientCompositionBool,
		resolvedBlankAnalyticalGradients,
		blankGradientInjectionTableSpecifiedDifferentlyBool,
		blankInvalidGradientCompositionBool,
		resolvedColumnPrimeAnalyticalGradients,
		columnPrimeGradientInjectionTableSpecifiedDifferentlyBool,
		columnPrimeInvalidGradientCompositionBool,
		resolvedColumnFlushAnalyticalGradients,
		columnFlushGradientInjectionTableSpecifiedDifferentlyBool,
		columnFlushInvalidGradientCompositionBool,
		columnSelectorQ, expandedColumnGradientOptions,
		resolvedColumnOrientation, injectionTableStandardGradients,
		injectionTableBlankGradients, injectionTableObjectified,
		columnSelectorObjectified, resolvedStandardInjectionVolumes,
		blankVolumes, blankConcentrations, blankMassConcentrations,
		blankInjectionVolumeOptionValues, resolvedBlankInjectionVolumes,
		guardColumnSelectorConflictQ, guardColumnOrientationSelectorConflictQ,
		columnOrientationSelectorConflictQ, guardColumnSelectorConflictOptions,
		guardColumnSelectorConflictTest,
		columnOrientationSelectorConflictOptions, columnOrientationSelectorConflictTest, compatibleBlankInjectionVolumeBools,
		validBlankInjectionVolumeTest, aliquotOptions,
		resolvedAliquotOptions, aliquotOptionsTests,
		resolvedInjectionVolumes, validInjectionVolumeTest, groupedVolumes,
		validSampleVolumesQ, samplesWithInsufficientVolume,
		insufficientVolumeTest, fractionCollectionModes,
		fractionCollectionStartTimes, fractionCollectionEndTimes,
		validFractionCollectionEndTimeBools, fractionCollectionEndTimeTest,
		maxFractionVolumes, resolvedFractionCollectionContainer,
		invalidFractionCollectionContainerOption, fractionCollectionContainerTest,
		resolvedFractionCollectionContainerMaxVolume,
		maxFractionPeriods, absoluteThresholds, peakSlopes,
		peakSlopeDurations, peakEndThresholds, gasPressureAsList,
		gasHeatingAsList, gasOptionAsList, powerOptionAsList,
		columnGapOptions, columnGapTest, overallColumnGapQ,
		absorbanceSamplingRateOptions, bufferAClashQ, bufferBClashQ, bufferCClashQ,
		bufferDClashQ, allInstrumentPositions, instrumentMaxColumnLength, columnPosition,
		columnPositionWidth, columnPositionDepth, columnPositionHeight,
		maxColumnDiameter, maxTotalColumnLength, columnsFitQ,
		columnFitLeftOverInstrumentsQ, validAlternateInstruments,
		resolvedIncubateColumn, columnTemperatureQ, nonFitColumnOption,
		nonFitColumnTest, conflictColumnOvenOption, conflictColumnOvenTest,
		conflictColumnOutsideInstrument, conflictColumnOutsideInstrumentTest,
		resolvedExperimentOptions, validSamplesOutStorageConditionQ,
		samplesOutStorageConditionTest, resolvedOptions,
		resolvedPostProcessingOptions, allTests, invalidInputs,
		specifiedInstrumentPackets, specifiedInstrumentModelPackets,
		retiredInstrumentBool, retiredInstrumentQ, deprecatedInstrumentQ,
		deprecatedInstrumentBool, validAgilentInstrumentQ,
		validSampleTemperatureQ, validSampleTemperatureAndDionexDetectorQ,
		validBufferDAndDionexDetectorQ, validGradientDAndDionexDetectorQ,
		noCapableInstrumentQ, compatibleCountAndNeedleWashBufferQ,
		compatibleFractionCollectionAndNeedleWashBufferQ,
		bufferNumberConflictQ, detectorInstrumentConflictQ,
		incompatibleColumnSelectorQ,
		flowRateInstrumentConflictQ, detectorInstrumentConflictOptions,
		compatibleSampleTemperatureQ,
		validBufferDQ, validBufferDNullQ, validGradientDQ, validGradientQ,
		validGradientCompositionQ, injectionTableStandardInjectionVolumes,
		injectionTableBlankInjectionVolumes,
		resolvedOptionsForInjectionTable, pHDetectorQ, pHCalibrationOptions,
		pHCalibrationRequestedQ, pHCalibrationRequestedNullQ,
		resolvedpHCalibration, resolvedLowpHCalibrationBuffer,
		resolvedLowpHCalibrationTarget, resolvedHighpHCalibrationBuffer,
		resolvedHighpHCalibrationTarget, conductivityDetectorQ,
		conductivityCalibrationOptions, conductivityCalibrationRequestedQ,
		conductivityCalibrationRequestedNullQ,
		resolvedConductivityCalibration,
		resolvedConductivityCalibrationBuffer,
		resolvedConductivityCalibrationTarget, missingpHCalibrationOptions,
		missingpHCalibrationTests, invalidpHCalibrationOptions,
		invalidpHCalibrationTests, swappedpHCalibrationTargetQ,
		swappedpHCalibrationTargetTests,
		missingConductivityCalibrationOptions,
		missingConductivityCalibrationTests,
		invalidConductivityCalibrationOptions,
		invalidConductivityCalibrationTests,
		resolvedInjectionSampleVolumeMeasurement, validDetectionWavelengthQ,
		compatibleDetectionWavelengthQ, validStandardDetectionWavelengthQ,
		compatibleStandardDetectionWavelengthQ,
		validBlankDetectionWavelengthQ, compatibleBlankDetectionWavelengthQ,
		validColumnPrimeDetectionWavelengthQ,
		compatibleColumnPrimeDetectionWavelengthQ,
		validColumnFlushDetectionWavelengthQ,
		compatibleColumnFlushDetectionWavelengthQ, compatibleDetectorQ,
		compatibleCollectFractionsDetectorQ, compatibleScaleQ,
		sampleAnalytes, analyteTypes, validOptionLookup, invalidOptionsMap, invalidOptions,
		compatibleStandardColumnTemperatureQ,
		compatibleBlankColumnTemperatureQ, compatibleColumnPrimeTemperatureQ,
		compatibleColumnFlushTemperatureQ, 
		validStandardGradientCompositionQ,
		validBlankGradientCompositionQ,
		validColumnPrimeGradientCompositionQ,
		validColumnFlushGradientCompositionQ,
		knownStandardConcentrationQ, compatibleBlankInjectionVolumesQ,
		knownBlankConcentrationQ, compatibleContainerModelQ,
		compatibleAliquotContainerQ, impliedDetectorQ,
		alternateInstrumentsOption, numberOfBufferInstruments,
		detectorCapableInstruments, maxInjectionFlowRate,
		instrumentFlowRates, flowRateCompatibleInstruments,
		sampleTemperatureOption, watersInstrumentsBool,
		agilentInstrumentsBool, watersRequestedQ, nonDionexUVRequestedQ,
		resolveAliquotOptionsResult, resolveAliquotOptionTests,
		allTupledGradients, gradientTypes, instrumentGradientTypes,
		gradientCapableInstruments, allColumnTemperatures,
		capableColumnTemperatureInstruments, minColumnTemperature,
		maxColumnTemperature, collectFractionsQ,
		uvOptionSpecifiedBool, pdaOptionSpecifiedBool,
		flrOptionSpecifiedBool, dionexFlrOptionSpecifiedBool,
		watersFlrOptionSpecifiedBool, elsdOptionSpecifiedBool,
		watersSpecifiedBool, nonDionexUVSpecifiedBool, lightScatteringSpecifiedBool,
		refractiveIndexSpecifiedBoolSingleOption,
		refractiveIndexSpecifiedGradientBool, refractiveIndexSpecifiedBool,
		phSpecifiedBool, conductivitySpecifiedBool, uvOptionNullBool,
		pdaOptionNullBool, flrOptionNullBool, dionexFlrOptionNullBool,
		elsdOptionNullBool, watersNullBool, lightScatteringNullBool,
		refractiveIndexNullBool, phNullBool, conductivityNullBool,
		pdaRequestedQ, flrRequestedQ, dionexFlrRequestedQ,
		watersFlrRequestedQ, elsdRequestedQ, uvRequestedQ,
		lightScatteringRequestedQ, refractiveIndexRequestedQ, pHRequestedQ,
		conductivityRequestedQ, dionexDetectorRequestedQ, pdaRequestedNullQ,
		flrRequestedNullQ, dionexFlrRequestedNullQ, elsdRequestedNullQ,
		uvRequestedNullQ, lightScatteringRequestedNullQ,
		refractiveIndexRequestedNullQ, pHRequestedNullQ,
		conductivityRequestedNullQ, dionexDetectorRequestedNullQ,
		watersRequestedNullQ, detectorOpsBoolLookupTable,
		detectorOpsListLookupTable, detectorSpecifiedOpsListLookupTable,
		impliedDetectors, impliedInstrumentBoolean, impliedInstruments,
		instrumentOption, instrumentModelOption, detectorOption,
		columnSelectorInstruments, primaryInstrumentDefault,
		secondaryInstrumentDefault, leftoverInstruments,
		alternateInstrumentConverted, semiResolvedAlternateInstruments,
		eachInstrumentPacket, resolvedAlternateInstruments,combinedResolvedInstruments,
		invalidAlternateInstrumentsQ, instrumentManufacturer,
		watersManufacturedQ, bestInstruments, secondaryBestInstruments,
		tertiaryBestInstruments, quaternatryBestInstruments,
		capableInstruments, fractionCollectionInstruments,
		scaleInstruments, allInjectionVolumes,
		capableInjectionVolumeInstruments, possibleInstrument,
		nonInternalHPLCErrorQ, possibleInstrumentModelPacket,
		compatibleWavelengthsQ, moreSpecificPDAOptions,
		incompatibleNeedleWashQ, incompatibleNeedleWashOptions,
		incompatibleNeedleWashTest, compatibleColumnTemperaturesQ,
		instrumentColumnTemperatureRange, invalidColumnTemperatureOptions, sampleTemperatureInstruments,
		injectionTableSampleInjectionVolumes, multipleColumnsReverseQ,
		multipleColumnReverseOptions, multipleColumnReverseTest,
		bufferAMethodList, bufferBMethodList, bufferCMethodList,
		bufferDMethodList, allResolvedGradientMethods,
		allGradientMethodPackets, anyGradientAQ, anyGradientBQ,
		anyGradientCQ, anyGradientDQ, 
		gradientInjectionTableSpecifiedDifferentlyOptionsBool,
		gradientInjectionTableSpecifiedDifferentlyQ,
		gradientInjectionTableSpecifiedDifferentlyOptions,
		gradientInjectionTableSpecifiedDifferentlyTest,
		invalidGradientCompositionOptionsBool, invalidGradientCompositionQ,
		invalidGradientCompositionOptions, invalidGradientCompositionTest,
		injectionTableColumnPrimeGradients,
		injectionTableColumnFlushGradients, multiplePrimeSameColumnBool,
		multipleFlushSameColumnBool, multiplePrimeSameColumnQ,
		multipleFlushSameColumnQ, multipleGradientsColumnPrimeFlushOptions,
		multipleGradientsColumnPrimeFlushTest, nonbinaryGradientBool,
		resolvedGradients, gradientInjectionTableSpecifiedDifferentlyBool,
		invalidGradientCompositionBool, injectionTableSampleRoundedGradients,
		finalResolvedGradients, finalResolvedStandardGradients,
		finalResolvedBlankGradients, finalResolvedColumnPrimeGradients,
		finalResolvedColumnFlushGradients, reformattedGradientOptions,
		knownSampleConcentrationQ, compatibleInjectionVolumeQ,
		tooSmallInjectionVolumeQ, maxFlowRate, validFlowRateTest,
		compatibleFlowRateBools, compatibleFlowRateQ,
		compatibleBlankFlowRateBools, validBlankFlowRateTest,
		compatibleBlankFlowRateQ, compatibleStandardFlowRateBools,
		validStandardFlowRateTest, compatibleStandardFlowRateQ,
		validFractionCollectionEndTimeQ, standardNonbinaryGradientBool,
		blankNonbinaryGradientBool, columnPrimeNonbinaryGradientBool,
		columnFlushNonbinaryGradientBool, nonBinaryOptionBool,
		nonBinaryOptionQ, instrumentBinaryOnlyQ, nonBinaryOptions,
		nonBinaryGradientTest, columnTypesConsistentQ,
		columnTypeConsistencyTest, internalUsage, internalUsageQ,
		columnPrimeQ, columnFlushQ, samplesInStorage, blankStorage,
		standardStorage, validContainerStorageConditionBool,
		validContainerStorageConditionTests,
		validContainerStorageConditionInvalidOptions, blanksNoModels,
		blankStorageNoModels, validBlankStorageConditionBool,
		validBlankStorageConditionTests,
		validBlankStorageConditionInvalidOptions, standardsNoModels,
		standardStorageNoModels, validStandardStorageConditionBool,
		validStandardStorageConditionTests,
		validStandardStorageConditionInvalidOptions, samplePositions,
		standardITPositions, blankITPositions, columnPrimePositions,
		columnFlushPositions, standardGradientsMatchingIT,
		blankGradientsMatchingIT, columnPrimeGradientsMatchingIT,
		columnFlushGradientsMatchingIT, injectionTableGradientRules, columnSelectorEquilibrationDurationRules,
		injectionTableScrewedUpQ, gradientReequilibratedBool,
		gradientReequilibratedQ,
		gradientReequilibratedWarning,
		adjustedOverwriteBlankBool, adjustedOverwriteStandardBool,
		allSamplesInContact, anySingletonGradientOptions,
		anySingletonGradientsBool, anySingletonGradientTest,
		compatibleMaterialsBool, compatibleMaterialsInvalidOption,
		compatibleMaterialsTests, overwriteBlankGradientsBool,
		overwriteColumnFlushGradientBool, overwriteColumnPrimeGradientBool,
		overwriteGradientsBool, overwriteOptionBool,
		overwriteStandardGradientsBool, removedExtraBlankBool,
		removedExtraBool, removedExtraColumnFlushGradientBool,
		removedExtraColumnPrimeGradientBool, removedExtraOptionBool,
		removedExtraOptionQ, removedExtraOptions, removedExtraStandardBool,
		removedExtraTest, shownBlankGradients, shownColumnFlushGradientList,
		shownColumnPrimeGradientList, shownGradients, shownStandardGradients,
		standardFrequencyStandardOptionsConflictOptions,
		standardFrequencyStandardOptionsConflictTests, blankOptionSpecifiedQ,
		blankFrequencyBlankOptionsConflictOptions,
		blankFrequencyBlankOptionsConflictTests, columnOptionSpecifiedBool,
		columnOpttionSpecifiedQ, columnNullOptionsConflictOptions,
		columnNullOptionsConflictTests, standardNullOptionsConflictOptions,
		standardNullOptionsConflictTests, blankNullOptionsConflictOptions,
		blankNullOptionsConflictTests,
		gradientAmbiguityBool, standardGradientAmbiguityBool,
		blankGradientAmbiguityBool, columnPrimeGradientAmbiguityBool,
		columnFlushGradientAmbiguityBool, gradientAmbiguityOverallBool,
		gradientAmbiguityOverallQ, gradientAmbiguityOptions,
		gradientAmbiguityTest, incorrectGradientOrderBool,
		standardIncorrectGradientOrderBool, blankIncorrectGradientOrderBool,
		columnPrimeIncorrectGradientOrderBool,
		columnFlushIncorrectGradientOrderBool,
		incorrectGradientOrderOverallBool,
		incorrectGradientOrderOverallBoolQ, incorrectGradientOrderOptions,
		incorrectGradientOrderOverallTest,
		standardColumnEquilibrationDurations,blankColumnEquilibrationDurations,
		columnPrimeColumnEquilibrationDurations,columnFlushColumnEquilibrationDurations,
		sufficientEquilibrationTimeQ,
		resolvedColumnEquilibriumDuration, columnConfigurationVolumes,
		columnEquilibrationDurationLookup, modelColumnStorageBuffers,
		injectionTableTemperaturesAssociation, injectionTableVolumeAssociation,
		injectionTemperatureRoundedAssociation, injectionTemperatureRoundedTests,
		injectionVolumeRoundedAssociation, injectionVolumeRoundedTests,
		roundedInjectionTable
	},

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine whether this function is just for internal usage (for LCMS) or not *)
	internalUsage = OptionValue[InternalUsage];
	internalUsageQ = MatchQ[internalUsage, True];

	(* Determine if we should keep a running list of tests *)
	gatherTestsQ = MemberQ[output, Tests];

	(* Determine if we should throw messages *)
	messagesQ = !gatherTestsQ;

	(* Determine if we're being executed in Engine *)
	engineQ = MatchQ[$ECLApplication, Engine];

	testOrNull[testDescription_String, passQ : BooleanP] := If[gatherTestsQ,
		Test[testDescription, True, Evaluate[passQ]],
		Null
	];
	warningOrNull[testDescription_String, passQ : BooleanP] := If[gatherTestsQ,
		Warning[testDescription, True, Evaluate[passQ]],
		Null
	];

	(* Set all error-checking variables to True (ie: valid) *)
	(# = True)& /@ {retiredInstrumentQ, deprecatedInstrumentQ, validAgilentInstrumentQ, validSampleTemperatureQ,
		validBufferDQ, validBufferDNullQ, validGradientDQ, validSampleTemperatureAndDionexDetectorQ, validBufferDAndDionexDetectorQ, validGradientDAndDionexDetectorQ, validGradientQ, validGradientCompositionQ, validDetectionWavelengthQ,
		compatibleFlowRateQ, compatibleBlankFlowRateQ, compatibleStandardFlowRateQ, compatibleColumnPrimeFlowRateQ, compatibleColumnFlushFlowRateQ,
		compatibleDetectionWavelengthQ, validStandardDetectionWavelengthQ, compatibleStandardDetectionWavelengthQ,
		validBlankDetectionWavelengthQ, compatibleBlankDetectionWavelengthQ, validColumnPrimeDetectionWavelengthQ,
		compatibleColumnPrimeDetectionWavelengthQ, validColumnFlushDetectionWavelengthQ, compatibleColumnFlushDetectionWavelengthQ,
		compatibleDetectorQ, compatibleSampleTemperatureQ, compatibleCollectFractionsDetectorQ,
		validOptionLookup, invalidOptions, compatibleStandardColumnTemperatureQ, compatibleBlankColumnTemperatureQ,
		compatibleColumnPrimeTemperatureQ, compatibleColumnFlushTemperatureQ,
		validStandardGradientCompositionQ,
		validBlankGradientCompositionQ, validColumnPrimeGradientCompositionQ,
		validColumnFlushGradientCompositionQ,
		knownStandardConcentrationQ, compatibleBlankInjectionVolumesQ,
		knownBlankConcentrationQ, compatibleContainerModelQ, compatibleAliquotContainerQ,
		knownSampleConcentrationQ, compatibleInjectionVolumeQ, tooSmallInjectionVolumeQ, validFractionCollectionEndTimeQ};

	(* Separate out our <Type> options from our Sample Prep options. *)
	{samplePrepOptions, hplcOptions} = splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples, resolvedSamplePrepOptions, simulatedCache}, samplePrepTests} = If[gatherTestsQ,
		resolveSamplePrepOptions[ExperimentHPLC, mySamples, samplePrepOptions, Cache -> OptionValue[Cache], Output -> {Result, Tests}],
		{resolveSamplePrepOptions[ExperimentHPLC, mySamples, samplePrepOptions, Cache -> OptionValue[Cache], Output -> Result], {}}
	];

	(* Fetch passed cache *)
	cache = Flatten[{OptionValue[Cache], simulatedCache}];

	(* Fetch simulated samples' cached packets *)
	simulatedSamplePackets = fetchPacketFromCacheHPLC[#, cache]& /@ simulatedSamples;

	(* Convert list of rules to Association so we can Lookup, Append, Join as usual. Another step is to make sure our Gradient options match the pattern for ExperimentHPLC. ExperimentLCMS is missing the last column for refractive index loading status *)
	optionsAssociation = If[internalUsageQ,
		Association[
			ReplaceRule[
				hplcOptions,
				MapThread[
					Function[{optionName, option},
						optionName -> ReplaceAll[option, x : {GreaterEqualP[0 Minute], RangeP[0 Percent, 100 Percent], RangeP[0 Percent, 100 Percent], RangeP[0 Percent, 100 Percent], RangeP[0 Percent, 100 Percent], GreaterEqualP[0 Milliliter / Minute]} :> Append[x, Automatic]]
					],
					{
						{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient},
						Lookup[hplcOptions, {Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}]
					}
				]
			]
		],
		Association[hplcOptions]
	];

	(* Extract downloaded mySamples packets *)
	samplePackets = fetchPacketFromCacheHPLC[#, cache]& /@ mySamples;

	(* Get the analyte types *)
	sampleAnalytes = Quiet[Experiment`Private`selectAnalyteFromSample[samplePackets], Warning::AmbiguousAnalyte];

	(* Extract sample statuses *)
	sampleStatuses = Lookup[samplePackets, Status];

	(* Find any samples that are discarded *)
	discardedSamples = PickList[mySamples, sampleStatuses, Discarded];

	(* Test that all samples are in a container *)
	discardedSamplesTest = If[Length[discardedSamples] > 0,
		(
			If[messagesQ,
				Message[Error::DiscardedSamples, ObjectToString /@ discardedSamples]
			];
			testOrNull["Input samples are not discarded:", False]
		),
		testOrNull["Input samples are not discarded:", True]
	];

	(* Extract containers *)
	sampleContainers = Download[Lookup[samplePackets, Container], Object];

	(* Extract simulated sample containers *)
	simulatedSampleContainers = Download[Lookup[simulatedSamplePackets, Container], Object];

	(* Find simulated container models *)
	simulatedSampleContainerModels = Map[
		If[NullQ[#],
			Null,
			Download[Lookup[fetchPacketFromCacheHPLC[#, cache], Model], Object]
		]&,
		simulatedSampleContainers
	];

	(* Extract any samples without a container *)
	containerlessSamples = PickList[mySamples, sampleContainers, Null];

	(* Test that all samples are in a container *)
	containersExistTest = If[Length[containerlessSamples] > 0,
		testOrNull["Input samples are all in containers:", False],
		testOrNull["Input samples are all in containers:", True]
	];

	(* If a sample is not in a container, throw error *)
	If[messagesQ && Length[containerlessSamples] > 0,
		Message[Error::ContainerlessSamples, ObjectToString /@ containerlessSamples];
	];

	(* If the specified Name is not in the database, it is valid *)
	validNameQ = If[MatchQ[Lookup[optionsAssociation, Name], _String],
		!DatabaseMemberQ[Object[Protocol, HPLC, Lookup[optionsAssociation, Name]]],
		True
	];

	(* Generate Test for Name check *)
	validNameTest = If[validNameQ,
		testOrNull["If specified, Name is not already an HPLC object name:", True],
		testOrNull["If specified, Name is not already an HPLC object name:", False]
	];

	(* If Name is invalid, throw error *)
	If[messagesQ && !validNameQ,
		Message[Error::DuplicateName, Lookup[optionsAssociation, Name]];
	];

	(* Build tests for the instrument's status and model instrument's deprecation *)

	(* Get the Dionex HPLC models and create a pattern for them *)
	{availableInstruments,dionexHPLCInstruments,agilentHPLCInstruments,watersHPLCInstruments,testHPLCInstruments}=allHPLCInstrumentSearch["Memoization"];

	dionexHPLCPattern = Alternatives @@ dionexHPLCInstruments;
	(* Agilent instrument has totally different requirements for containers etc so if Agilent is selected as one of the instruments, we will go with it and deny all the other instruments *)
	agilentHPLCPattern = Alternatives @@ agilentHPLCInstruments;

	(* Fetch instrument packet if specified *)
	specifiedInstrumentPackets = If[MatchQ[Lookup[optionsAssociation, Instrument], Except[(Null|Automatic)]],
		Map[
			If[MatchQ[#,ObjectP[Object[Instrument,HPLC]]],
				fetchPacketFromCacheHPLC[#, cache],
				Null
			]&,
			ToList[Lookup[optionsAssociation, Instrument]]
		],
		Null
	];

	(* Fetch model instrument packet if specified *)
	specifiedInstrumentModelPackets = If[MatchQ[Lookup[optionsAssociation, Instrument], Except[(Null|Automatic)]],
		Map[
			Switch[#,
				ObjectP[Object[Instrument, HPLC]],
				fetchModelPacketFromCacheHPLC[#, cache],
				ObjectP[Model[Instrument, HPLC]],
				fetchPacketFromCacheHPLC[#, cache],
				_,
				Null
			]&,
			ToList[Lookup[optionsAssociation, Instrument]]
		],
		Null
	];

	(* Bool tracking if specified instrument is retired *)
	retiredInstrumentBool = If[NullQ[specifiedInstrumentPackets],
		False,
		Map[
			If[NullQ[#],
				False,
				MatchQ[Lookup[#,Status],Retired]
			]&,
			specifiedInstrumentPackets
		]
	];
	retiredInstrumentQ = Or@@ToList[retiredInstrumentBool];

	(* Bool tracking if specified instrument model is deprecated *)
	deprecatedInstrumentBool = If[NullQ[specifiedInstrumentModelPackets],
		False,
		Map[
			TrueQ[Lookup[#,Deprecated]]&,
			specifiedInstrumentModelPackets
		]
	];
	deprecatedInstrumentQ = Or@@ToList[deprecatedInstrumentBool];

	(* Return tests and throw errors if necessary *)
	instrumentStatusTests = {
		If[retiredInstrumentQ,
			If[messagesQ,
				(* If we get here, we definitely have user-specified instruments so we can safely PickList *)
				Message[Error::RetiredChromatographyInstrument, ObjectToString[PickList[Lookup[specifiedInstrumentPackets,Object],retiredInstrumentBool,True]], ObjectToString[PickList[Lookup[specifiedInstrumentModelPackets,Object],retiredInstrumentBool,True]]]
			];
			testOrNull["If specified, Instrument is not retired:", False],
			testOrNull["If specified, Instrument is not retired:", True]
		],
		If[deprecatedInstrumentQ,
			If[messagesQ,
				Message[Error::DeprecatedInstrumentModel, ObjectToString[PickList[Lookup[specifiedInstrumentModelPackets,Object],deprecatedInstrumentBool,True]]]
			];
			testOrNull["Instrument model is not deprecated:", False],
			testOrNull["Instrument model is not deprecated:", True]
		]
	};

	(* Get our number of replicates *)
	numberOfReplicates = Lookup[optionsAssociation, NumberOfReplicates] /. {Null -> 1};

	(* Build options association with rounded options and list of all option precision tests *)
	{roundedOptionsAssociation, roundingTests} = Module[
		{gradientOptions, roundedGradientOptions, roundedGradientTests, detectionWavelengthOptions, detectorResolutionOptions, timeOptions, temperatureOptions, preciseTemperatureOptions, volumeOptions, thresholdOptions, fluorescenceWavelengthOptions, laserPowerOptions,
			timeRoundedAssociation, timeRoundedTests, temperatureRoundedAssociation, temperatureRoundedTests, preciseTemperatureRoundedAssociation, preciseTemperatureRoundedTests, wavelengthRoundedAssociation, wavelengthRoundedTests, wavelengthResolutionRoundedAssociation, wavelengthResolutionRoundedTests, volumeRoundedAssociation, volumeRoundedTests, laserPowerRoundedAssociation, laserPowerRoundedTests,
			unroundedAbsoluteThreshold, unroundedPeakEndThreshold, thresholdOptionValues, absValuePositions, rfuValuePositions, absValueAssociation, rfuValueAssociation, absRoundedAssociation, absRoundedTests, rfuRoundedAssociation, rfuRoundedTests, roundedThresholdOptions,
			unroundedPeakSlope, absSlopeValuePositions, rfuSlopeValuePositions, absSlopeValueAssociation, rfuSlopeValueAssociation, absSlopeRoundedAssociation, absSlopeRoundedTests, rfuSlopeRoundedAssociation, rfuSlopeRoundedTests, roundedPeakSlopeOptions,
			fluorescenceWavelengthOptionValues, flattenedFluorescenceWavelengthOptionValues, fluorescenceRoundedAssociation, fluorescenceRoundedTests, roundedFluorescenceOptions,
			allRoundedOptionsAssociation, allRoundingTests},

		(* All options that specify gradients *)
		gradientOptions = {
			Gradient,
			GradientA,
			GradientB,
			GradientC,
			GradientD,
			FlowRate,
			StandardGradient,
			StandardGradientA,
			StandardGradientB,
			StandardGradientC,
			StandardGradientD,
			StandardFlowRate,
			BlankGradient,
			BlankGradientA,
			BlankGradientB,
			BlankGradientC,
			BlankGradientD,
			BlankFlowRate,
			ColumnPrimeGradient,
			ColumnPrimeGradientA,
			ColumnPrimeGradientB,
			ColumnPrimeGradientC,
			ColumnPrimeGradientD,
			ColumnPrimeFlowRate,
			ColumnFlushGradient,
			ColumnFlushGradientA,
			ColumnFlushGradientB,
			ColumnFlushGradientC,
			ColumnFlushGradientD,
			ColumnFlushFlowRate
		};

		(* Use the helper function to round all of the gradient options collectively *)
		{roundedGradientOptions, roundedGradientTests} = roundGradientOptions[gradientOptions, optionsAssociation, gatherTestsQ, FlowRatePrecision -> 10^-2 Milliliter / Minute, GradientPrecision -> 10^-1 Percent];

		(* The rest of the options will be singleton or a list,
		so they can normally be passed to RoundOptionPrecision *)

		(* Options which reference wavelengths *)
		(* Note that WavelengthResolution is not the same precision as Wavelength *)
		detectionWavelengthOptions = {
			AbsorbanceWavelength,
			StandardAbsorbanceWavelength,
			BlankAbsorbanceWavelength,
			ColumnPrimeAbsorbanceWavelength,
			ColumnFlushAbsorbanceWavelength
		};
		detectorResolutionOptions = {
			WavelengthResolution,
			StandardWavelengthResolution,
			BlankWavelengthResolution,
			ColumnPrimeWavelengthResolution,
			ColumnFlushWavelengthResolution
		};

		(* Options which reference times *)
		timeOptions = {
			FractionCollectionStartTime,
			FractionCollectionEndTime,
			MaxCollectionPeriod,
			PeakSlopeDuration
		};

		(* Options which reference temperatures *)
		temperatureOptions = {
			ColumnTemperature,
			SampleTemperature,
			StandardColumnTemperature,
			BlankColumnTemperature,
			ColumnPrimeTemperature,
			ColumnFlushTemperature
		};

		(* Options which reference more precise temperature controls *)
		preciseTemperatureOptions = {
			FluorescenceFlowCellTemperature,
			LightScatteringFlowCellTemperature,
			RefractiveIndexFlowCellTemperature,
			StandardFluorescenceFlowCellTemperature,
			StandardLightScatteringFlowCellTemperature,
			StandardRefractiveIndexFlowCellTemperature,
			BlankFluorescenceFlowCellTemperature,
			BlankLightScatteringFlowCellTemperature,
			BlankRefractiveIndexFlowCellTemperature,
			ColumnPrimeFluorescenceFlowCellTemperature,
			ColumnPrimeLightScatteringFlowCellTemperature,
			ColumnPrimeRefractiveIndexFlowCellTemperature,
			ColumnFlushFluorescenceFlowCellTemperature,
			ColumnFlushLightScatteringFlowCellTemperature,
			ColumnFlushRefractiveIndexFlowCellTemperature
		};

		(* Options which reference volumes *)
		volumeOptions = {
			InjectionVolume,
			StandardInjectionVolume,
			BlankInjectionVolume,
			MaxFractionVolume
		};

		(* Options with MALS/DLS Laser Power *)
		laserPowerOptions = {
			LightScatteringLaserPower,
			StandardLightScatteringLaserPower,
			BlankLightScatteringLaserPower,
			ColumnPrimeLightScatteringLaserPower,
			ColumnFlushLightScatteringLaserPower
		};

		(* Fetch association with times rounded *)
		{timeRoundedAssociation, timeRoundedTests} = If[gatherTestsQ,
			RoundOptionPrecision[optionsAssociation, timeOptions, Table[1 Second, Length[timeOptions]], Output -> {Result, Tests}],
			{RoundOptionPrecision[optionsAssociation, timeOptions, Table[1 Second, Length[timeOptions]]], {}}
		];

		(* Fetch association with temperatures rounded *)
		{temperatureRoundedAssociation,temperatureRoundedTests} = If[gatherTestsQ,
			RoundOptionPrecision[optionsAssociation,temperatureOptions,Table[10^-1 Celsius,Length[temperatureOptions]],Output->{Result,Tests}],
			{RoundOptionPrecision[optionsAssociation,temperatureOptions,Table[10^-1 Celsius,Length[temperatureOptions]]],{}}
		];

		(* Fetch association with precise temperatures rounded *)
		{preciseTemperatureRoundedAssociation, preciseTemperatureRoundedTests} = If[gatherTestsQ,
			RoundOptionPrecision[optionsAssociation, preciseTemperatureOptions, Table[10^-2 Celsius, Length[preciseTemperatureOptions]], Output -> {Result, Tests}],
			{RoundOptionPrecision[optionsAssociation, preciseTemperatureOptions, Table[10^-2 Celsius, Length[preciseTemperatureOptions]]], {}}
		];

		(* Fetch association with wavelengths rounded *)
		{wavelengthRoundedAssociation, wavelengthRoundedTests} = If[gatherTestsQ,
			RoundOptionPrecision[optionsAssociation, detectionWavelengthOptions, Table[1 Nanometer, Length[detectionWavelengthOptions]], Output -> {Result, Tests}],
			{RoundOptionPrecision[optionsAssociation, detectionWavelengthOptions, Table[1 Nanometer, Length[detectionWavelengthOptions]]], {}}
		];

		{wavelengthResolutionRoundedAssociation, wavelengthResolutionRoundedTests} = If[gatherTestsQ,
			RoundOptionPrecision[optionsAssociation, detectorResolutionOptions, Table[0.1 Nanometer, Length[detectorResolutionOptions]], Output -> {Result, Tests}],
			{RoundOptionPrecision[optionsAssociation, detectorResolutionOptions, Table[0.1 Nanometer, Length[detectorResolutionOptions]]], {}}
		];

		(* Fetch association with volumes rounded *)
		{volumeRoundedAssociation, volumeRoundedTests} = If[gatherTestsQ,
			RoundOptionPrecision[optionsAssociation, volumeOptions, Table[10^-1 Microliter, Length[volumeOptions]], Output -> {Result, Tests}],
			{RoundOptionPrecision[optionsAssociation, volumeOptions, Table[10^-1 Microliter, Length[volumeOptions]]], {}}
		];

		(* Fetch association with laser power rounded *)
		{laserPowerRoundedAssociation, laserPowerRoundedTests} = If[gatherTestsQ,
			RoundOptionPrecision[optionsAssociation, laserPowerOptions, Table[1Percent, Length[laserPowerOptions]], Output -> {Result, Tests}],
			{RoundOptionPrecision[optionsAssociation, laserPowerOptions, Table[1Percent, Length[laserPowerOptions]]], {}}
		];

		(* Fetch temperature and volume values from inside the injection Table *)
		injectionTableTemperaturesAssociation = If[MatchQ[Lookup[optionsAssociation, InjectionTable], Except[Null | Automatic]],
			<|InjectionTable -> Lookup[optionsAssociation, InjectionTable][[All, 5]]|>,
			<|InjectionTable -> {}|>
		];
		injectionTableVolumeAssociation = If[MatchQ[Lookup[optionsAssociation, InjectionTable], Except[Null | Automatic]],
			<|InjectionTable -> Lookup[optionsAssociation, InjectionTable][[All, 3]]|>,
			<|InjectionTable -> {}|>
		];

		(* Round Temperatures inside Injection Table *)
		{injectionTemperatureRoundedAssociation, injectionTemperatureRoundedTests} = If[gatherTestsQ,
			RoundOptionPrecision[injectionTableTemperaturesAssociation, InjectionTable, 10^-1 Celsius, Output -> {Result, Tests}],
			{RoundOptionPrecision[injectionTableTemperaturesAssociation, InjectionTable, 10^-1 Celsius], {}}
		];
		(* Round Volumes inside Injection Table *)
		{injectionVolumeRoundedAssociation, injectionVolumeRoundedTests} = If[gatherTestsQ,
			RoundOptionPrecision[injectionTableVolumeAssociation, InjectionTable, 10^-1 Microliter, Output -> {Result, Tests}],
			{RoundOptionPrecision[injectionTableVolumeAssociation, InjectionTable, 10^-1 Microliter], {}}
		];

		(* Replace InjectionTable with rounded *)
		roundedInjectionTable = Association[
			InjectionTable -> If[MatchQ[Lookup[optionsAssociation, InjectionTable], Except[Null | Automatic]],
				MapThread[
					Function[
						{row, temperatureValue, volumeValue},
						ReplacePart[row, {5 -> temperatureValue, 3 -> volumeValue}]
					],
					{Lookup[optionsAssociation, InjectionTable], injectionTemperatureRoundedAssociation[InjectionTable], injectionVolumeRoundedAssociation[InjectionTable]}
				],
				Lookup[optionsAssociation, InjectionTable]
			]
		];

		(* Round the Threshold options - either in AbsorbanceUnit or in RFU *)
		(* Get the option values *)
		{unroundedAbsoluteThreshold, unroundedPeakEndThreshold} = Lookup[optionsAssociation, {AbsoluteThreshold, PeakEndThreshold}];

		thresholdOptionValues = {unroundedAbsoluteThreshold, unroundedPeakEndThreshold};

		(* Get the option numbers *)
		thresholdOptions = {
			AbsoluteThreshold,
			PeakEndThreshold
		};

		(* Get the positions of the Absorbance unit and RFU unit *)
		absValuePositions = Map[
			Position[#, GreaterEqualP[0 AbsorbanceUnit], Infinity, Heads -> False]&,
			thresholdOptionValues
		];

		rfuValuePositions = Map[
			Position[#, GreaterEqualP[0 RFU], Infinity, Heads -> False]&,
			thresholdOptionValues
		];

		(* Build association with completely flattened Absorbance values *)
		absValueAssociation = Association@MapThread[
			Function[{optionName, optionValue, indices},
				(optionName -> (Extract[ToList[optionValue], #]& /@ indices))
			],
			{thresholdOptions, thresholdOptionValues, absValuePositions}
		];

		(* Build association with completely flattened RFU values *)
		rfuValueAssociation = Association@MapThread[
			Function[{optionName, optionValue, indices},
				(optionName -> (Extract[ToList[optionValue], #]& /@ indices))
			],
			{thresholdOptions, thresholdOptionValues, rfuValuePositions}
		];

		(* Pass built absorbance and fluorescence threshold value association into RoundOptionPrecision to get processed. Gather tests if needed. *)
		{absRoundedAssociation, absRoundedTests} = If[gatherTestsQ && !MatchQ[Flatten[absValuePositions], {}],
			RoundOptionPrecision[
				absValueAssociation,
				thresholdOptions,
				ConstantArray[1 Milli AbsorbanceUnit, Length[thresholdOptions]],
				Output -> {Result, Tests}
			],
			{
				RoundOptionPrecision[
					absValueAssociation,
					thresholdOptions,
					ConstantArray[1 Milli AbsorbanceUnit, Length[thresholdOptions]]
				],
				{}
			}
		];
		{rfuRoundedAssociation, rfuRoundedTests} = If[gatherTestsQ && !MatchQ[Flatten[rfuValuePositions], {}],
			RoundOptionPrecision[
				rfuValueAssociation,
				thresholdOptions,
				ConstantArray[1 Micro RFU, Length[thresholdOptions]],
				Output -> {Result, Tests}
			],
			{
				RoundOptionPrecision[
					rfuValueAssociation,
					thresholdOptions,
					ConstantArray[1 Micro RFU, Length[thresholdOptions]]
				],
				{}
			}
		];

		(* Rebuild the threshold options by replacing the flat rounded values at the positions they were originally found *)
		roundedThresholdOptions = Association@MapThread[
			Function[{optionName, optionValue, absPositions, rfuPositions},
				optionName -> If[MatchQ[optionValue, _List],
					ReplacePart[
						optionValue,
						Join[
							MapThread[
								Rule,
								{absPositions, Lookup[absRoundedAssociation, optionName]}
							],
							MapThread[
								Rule,
								{rfuPositions, Lookup[rfuRoundedAssociation, optionName]}
							]
						]
					],
					ReplacePart[
						ToList[optionValue],
						Join[
							MapThread[
								Rule,
								{absPositions, Lookup[absRoundedAssociation, optionName]}
							],
							MapThread[
								Rule,
								{rfuPositions, Lookup[rfuRoundedAssociation, optionName]}
							]
						]
					][[1]]
				]
			],
			{thresholdOptions, thresholdOptionValues, absValuePositions, rfuValuePositions}
		];

		(* Round the PeakSlope option - either in AbsorbanceUnit/Second or in RFU/Second *)
		(* Get the option value *)
		unroundedPeakSlope = Lookup[optionsAssociation, PeakSlope];

		(* Get the positions of the Absorbance/Second unit and RFU/Second unit *)
		absSlopeValuePositions = Position[unroundedPeakSlope, GreaterEqualP[0 AbsorbanceUnit / Second], Infinity, Heads -> False];

		rfuSlopeValuePositions = Position[unroundedPeakSlope, GreaterEqualP[0 RFU / Second], Infinity, Heads -> False];

		(* Build association with completely flattened Absorbance/Second values *)
		absSlopeValueAssociation = Association[
			(PeakSlope -> (Extract[ToList[unroundedPeakSlope], #]& /@ absSlopeValuePositions))
		];

		(* Build association with completely flattened Absorbance/Second values *)
		rfuSlopeValueAssociation = Association[
			(PeakSlope -> (Extract[ToList[unroundedPeakSlope], #]& /@ rfuSlopeValuePositions))
		];

		(* Pass built absorbance and fluorescence threshold value association into RoundOptionPrecision to get processed. Gather tests if needed. *)
		{absSlopeRoundedAssociation, absSlopeRoundedTests} = If[gatherTestsQ && !MatchQ[Flatten[absSlopeValuePositions], {}],
			RoundOptionPrecision[
				absSlopeValueAssociation,
				PeakSlope,
				1 Milli AbsorbanceUnit / Second,
				Output -> {Result, Tests}
			],
			{
				RoundOptionPrecision[
					absSlopeValueAssociation,
					PeakSlope,
					1 Milli AbsorbanceUnit / Second
				],
				{}
			}
		];
		{rfuSlopeRoundedAssociation, rfuSlopeRoundedTests} = If[gatherTestsQ && !MatchQ[Flatten[rfuSlopeValuePositions], {}],
			RoundOptionPrecision[
				rfuSlopeValueAssociation,
				PeakSlope,
				1 Micro RFU / Second,
				Output -> {Result, Tests}
			],
			{
				RoundOptionPrecision[
					rfuSlopeValueAssociation,
					PeakSlope,
					1 Micro RFU / Second
				],
				{}
			}
		];

		(* Rebuild the threshold options by replacing the flat rounded values at the positions they were originally found *)
		roundedPeakSlopeOptions = Association[
			PeakSlope -> If[MatchQ[unroundedPeakSlope, _List],
				ReplacePart[
					unroundedPeakSlope,
					Join[
						MapThread[
							Rule,
							{absSlopeValuePositions, Lookup[absSlopeRoundedAssociation, PeakSlope]}
						],
						MapThread[
							Rule,
							{rfuSlopeValuePositions, Lookup[rfuSlopeRoundedAssociation, PeakSlope]}
						]
					]
				],
				ReplacePart[
					ToList[unroundedPeakSlope],
					Join[
						MapThread[
							Rule,
							{absSlopeValuePositions, Lookup[absSlopeRoundedAssociation, PeakSlope]}
						],
						MapThread[
							Rule,
							{rfuSlopeValuePositions, Lookup[rfuSlopeRoundedAssociation, PeakSlope]}
						]
					]
				][[1]]
			]
		];

		(* Detector-related Options *)
		(* Options with fluorescence wavelengths - These allow nested list of wavelengths *)
		fluorescenceWavelengthOptions = {
			ExcitationWavelength,
			EmissionWavelength,
			StandardExcitationWavelength,
			StandardEmissionWavelength,
			BlankExcitationWavelength,
			BlankEmissionWavelength,
			ColumnPrimeExcitationWavelength,
			ColumnPrimeEmissionWavelength,
			ColumnFlushExcitationWavelength,
			ColumnFlushEmissionWavelength
		};

		(* Get the option values from the option list *)
		fluorescenceWavelengthOptionValues = Lookup[optionsAssociation, fluorescenceWavelengthOptions];

		(* Because there can only be one type of unit - Wavelength unit Nanometer, we can flatten all the options and unflatten at the end to rebuild all the options *)
		flattenedFluorescenceWavelengthOptionValues = Flatten[fluorescenceWavelengthOptionValues];

		(* Round the option values *)
		{fluorescenceRoundedAssociation, fluorescenceRoundedTests} = If[gatherTestsQ,
			RoundOptionPrecision[
				<|Wavelength -> flattenedFluorescenceWavelengthOptionValues|>,
				Wavelength,
				1 Nanometer,
				Output -> {Result, Tests}
			],
			{
				RoundOptionPrecision[
					<|Wavelength -> flattenedFluorescenceWavelengthOptionValues|>,
					Wavelength,
					1 Nanometer
				],
				{}
			}
		];

		(* Unflatten the options so that we can put it back into the association *)
		roundedFluorescenceOptions = Association@MapThread[
			(#1 -> #2)&,
			{fluorescenceWavelengthOptions, Unflatten[Lookup[fluorescenceRoundedAssociation, Wavelength], fluorescenceWavelengthOptionValues]}
		];

		(* Join all rounded associations together, with rounded values overwriting existing values *)
		allRoundedOptionsAssociation = Join[
			optionsAssociation,
			roundedGradientOptions,
			KeyTake[timeRoundedAssociation, timeOptions],
			KeyTake[temperatureRoundedAssociation,temperatureOptions],
			KeyTake[preciseTemperatureRoundedAssociation, preciseTemperatureOptions],
			KeyTake[wavelengthRoundedAssociation, detectionWavelengthOptions],
			KeyTake[wavelengthResolutionRoundedAssociation, detectorResolutionOptions],
			KeyTake[volumeRoundedAssociation, volumeOptions],
			KeyTake[laserPowerRoundedAssociation, laserPowerOptions],
			roundedThresholdOptions,
			roundedInjectionTable,
			roundedPeakSlopeOptions,
			roundedFluorescenceOptions
		];

		(* Join all tests together *)
		allRoundingTests = Join[
			roundedGradientTests,
			timeRoundedTests,
			{injectionTemperatureRoundedTests},
			temperatureRoundedTests,
			preciseTemperatureRoundedTests,
			wavelengthRoundedTests,
			wavelengthResolutionRoundedTests,
			volumeRoundedTests,
			laserPowerRoundedTests,
			absRoundedTests,
			rfuRoundedTests,
			absSlopeRoundedTests,
			rfuSlopeRoundedTests,
			{fluorescenceRoundedTests}
		];

		(* Return expected tuple of the rounded association and all tests *)
		{allRoundedOptionsAssociation, allRoundingTests}
	];

	(* Check whether the injection table and column selector are specified *)
	{injectionTableLookup, columnSelectorInitialLookup} = Lookup[roundedOptionsAssociation, {InjectionTable, ColumnSelector}];
	injectionTableSpecifiedQ = MatchQ[injectionTableLookup, Except[Automatic | Null]];
	columnSelectorSpecifiedQ = MatchQ[columnSelectorInitialLookup, Except[Automatic | Null]];

	(* If the column selector option is specified as a single tuple, we need to reform it so that it's listed *)
	columnSelectorLookup = If[columnSelectorSpecifiedQ,
		Partition[Flatten[columnSelectorInitialLookup], 7],
		columnSelectorInitialLookup
	];

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(* Initial process of detector options so we can decide how to resolve column *)
	absorbanceWavelengthOptions = {AbsorbanceWavelength, StandardAbsorbanceWavelength, BlankAbsorbanceWavelength, ColumnPrimeAbsorbanceWavelength, ColumnFlushAbsorbanceWavelength};
	(* UVFilter is only available on Waters *)
	watersAbsorbanceOptions = {
		UVFilter,
		StandardUVFilter,
		BlankUVFilter,
		ColumnPrimeUVFilter,
		ColumnFlushUVFilter
	};
	(* SamplingRate is available on all instruments *)
	absorbanceSamplingRateOptions = {AbsorbanceSamplingRate, StandardAbsorbanceSamplingRate, BlankAbsorbanceSamplingRate, ColumnPrimeAbsorbanceSamplingRate, ColumnFlushAbsorbanceSamplingRate};

	(* We need to figure out if any of the absorbanceWavelength options are TUV or PDA related *)
	tuvAbsorbanceWavelengthBool = MatchQ[#, ListableP[GreaterP[0 * Nanometer]]]& /@ Lookup[roundedOptionsAssociation, absorbanceWavelengthOptions];
	pdaAbsorbanceWavelengthBool = MatchQ[#, ListableP[_Span]]& /@ Lookup[roundedOptionsAssociation, absorbanceWavelengthOptions];
	(*compile a list of the TUV related options. Some of these are shared with the PDA. The SamplingRate is associated only to the waters system*)
	tuvOptions = Join[watersAbsorbanceOptions, absorbanceSamplingRateOptions, PickList[absorbanceWavelengthOptions, tuvAbsorbanceWavelengthBool]];

	(* Compile a list of the PDA related options. If the AbsorbanceWavelengths are a span pattern then it's a PDA. Some are shared with TUV *)
	pdaOptions = Join[watersAbsorbanceOptions, absorbanceSamplingRateOptions, {
		WavelengthResolution,
		StandardWavelengthResolution,
		BlankWavelengthResolution,
		ColumnPrimeWavelengthResolution,
		ColumnFlushWavelengthResolution
	}, PickList[absorbanceWavelengthOptions, pdaAbsorbanceWavelengthBool]];

	(* Compile a list of the FLR related options and FLR related options specifically for Ultimate 3000 FLD-3000 Detector *)
	flrOptions = {
		ExcitationWavelength,
		EmissionWavelength,
		FluorescenceGain,
		StandardExcitationWavelength,
		StandardEmissionWavelength,
		StandardFluorescenceGain,
		BlankExcitationWavelength,
		BlankEmissionWavelength,
		BlankFluorescenceGain,
		ColumnPrimeExcitationWavelength,
		ColumnPrimeEmissionWavelength,
		ColumnPrimeFluorescenceGain,
		ColumnFlushExcitationWavelength,
		ColumnFlushEmissionWavelength,
		ColumnFlushFluorescenceGain
	};
	excitationWavelengthFlrOptions = {
		ExcitationWavelength,
		StandardExcitationWavelength,
		BlankExcitationWavelength,
		ColumnPrimeExcitationWavelength,
		ColumnFlushExcitationWavelength
	};
	emissionWavelengthFlrOptions = {
		EmissionWavelength,
		StandardEmissionWavelength,
		BlankEmissionWavelength,
		ColumnPrimeEmissionWavelength,
		ColumnFlushEmissionWavelength
	};
	dionexFlrOptions = {
		EmissionCutOffFilter,
		FluorescenceFlowCellTemperature,
		StandardEmissionCutOffFilter,
		StandardFluorescenceFlowCellTemperature,
		BlankEmissionCutOffFilter,
		BlankFluorescenceFlowCellTemperature,
		ColumnPrimeEmissionCutOffFilter,
		ColumnPrimeFluorescenceFlowCellTemperature,
		ColumnFlushEmissionCutOffFilter,
		ColumnFlushFluorescenceFlowCellTemperature
	};

	(* Compile a list of the ELSD related options *)
	elsdOptions = {
		NebulizerGas,
		NebulizerGasHeating,
		NebulizerHeatingPower,
		NebulizerGasPressure,
		DriftTubeTemperature,
		ELSDGain,
		ELSDSamplingRate,
		StandardNebulizerGas,
		StandardNebulizerGasHeating,
		StandardNebulizerHeatingPower,
		StandardNebulizerGasPressure,
		StandardDriftTubeTemperature,
		StandardELSDGain,
		StandardELSDSamplingRate,
		BlankNebulizerGas,
		BlankNebulizerGasHeating,
		BlankNebulizerHeatingPower,
		BlankNebulizerGasPressure,
		BlankDriftTubeTemperature,
		BlankELSDGain,
		BlankELSDSamplingRate,
		ColumnPrimeNebulizerGas,
		ColumnPrimeNebulizerGasHeating,
		ColumnPrimeNebulizerHeatingPower,
		ColumnPrimeNebulizerGasPressure,
		ColumnPrimeDriftTubeTemperature,
		ColumnPrimeELSDGain,
		ColumnPrimeELSDSamplingRate,
		ColumnFlushNebulizerGas,
		ColumnFlushNebulizerGasHeating,
		ColumnFlushNebulizerHeatingPower,
		ColumnFlushNebulizerGasPressure,
		ColumnFlushDriftTubeTemperature,
		ColumnFlushELSDGain,
		ColumnFlushELSDSamplingRate
	};


	(* Compile a list of the MALS/DLS detector related options *)
	lightScatteringOptions = {
		LightScatteringLaserPower,
		LightScatteringFlowCellTemperature,
		StandardLightScatteringLaserPower,
		StandardLightScatteringFlowCellTemperature,
		BlankLightScatteringLaserPower,
		BlankLightScatteringFlowCellTemperature,
		ColumnPrimeLightScatteringLaserPower,
		ColumnPrimeLightScatteringFlowCellTemperature,
		ColumnFlushLightScatteringLaserPower,
		ColumnFlushLightScatteringFlowCellTemperature
	};

	(* Compile a list of the pH detector related options *)
	pHOptions = {
		pHCalibration,
		LowpHCalibrationBuffer,
		LowpHCalibrationTarget,
		HighpHCalibrationBuffer,
		HighpHCalibrationTarget,
		pHTemperatureCompensation
	};

	(* Compile a list of the Conductivity detector related options *)
	conductivityOptions = {
		ConductivityCalibration,
		ConductivityCalibrationBuffer,
		ConductivityCalibrationTarget,
		ConductivityTemperatureCompensation
	};

	(* We should be more rigorous about the PDA options and exclude whatever is in the TUV *)
	moreSpecificPDAOptions = Join[{
		WavelengthResolution,
		StandardWavelengthResolution,
		BlankWavelengthResolution,
		ColumnPrimeWavelengthResolution,
		ColumnFlushWavelengthResolution
	}, PickList[absorbanceWavelengthOptions, pdaAbsorbanceWavelengthBool]];

	(* Note that Refractive Index detector related options are already gathered earlier because we used them to help resolve Graident options. *)

	(* Check to see if the user positively specified any of the UVVis detector options *)
	uvOptionSpecifiedBool = MatchQ[#, Except[ListableP[Null | Automatic]]]& /@ Lookup[roundedOptionsAssociation, tuvOptions];
	(* PDA *)
	pdaOptionSpecifiedBool = MatchQ[#, Except[ListableP[Null | Automatic]]]& /@ Lookup[roundedOptionsAssociation, moreSpecificPDAOptions];
	(* Fluorescence *)
	flrOptionSpecifiedBool = MatchQ[#, Except[ListableP[Null | Automatic]]]& /@ Lookup[roundedOptionsAssociation, flrOptions];
	(* Dionex Fluorescence *)
	dionexFlrOptionSpecifiedBool = MatchQ[#, Except[ListableP[Null | Automatic]]]& /@ Lookup[roundedOptionsAssociation, dionexFlrOptions];
	(* Waters fluorescence - only Waters allow <20 nm Ex/Em *)
	watersFlrOptionSpecifiedBool = MapThread[
		Function[{exGroup, emGroup},
			If[MatchQ[exGroup, ListableP[Null | Automatic]] || MatchQ[emGroup, ListableP[Null | Automatic]],
				False,
				Or @@ MapThread[
					If[MatchQ[#1, Null | Automatic] || MatchQ[#2, Null | Automatic],
						False,
						TrueQ[#1 > #2 - 20Nanometer] && TrueQ[#1 < #2]
					]&,
					{ToList[exGroup], ToList[emGroup]}
				]
			]
		],
		{
			Lookup[roundedOptionsAssociation, excitationWavelengthFlrOptions],
			Lookup[roundedOptionsAssociation, emissionWavelengthFlrOptions]
		}
	];
	(* ELSD *)
	elsdOptionSpecifiedBool = MatchQ[#, Except[ListableP[Null | Automatic]]]& /@ Lookup[roundedOptionsAssociation, elsdOptions];
	(* Waters specified *)
	watersSpecifiedBool = MatchQ[#, Except[ListableP[Null | Automatic]]]& /@ Lookup[roundedOptionsAssociation, watersAbsorbanceOptions];
	(* Waters and Agilent UV *)
	nonDionexUVSpecifiedBool = MatchQ[#, Except[ListableP[Null | Automatic]]]& /@ Lookup[roundedOptionsAssociation, absorbanceSamplingRateOptions];
	(* Light Scattering (MALS/DLS) *)
	lightScatteringSpecifiedBool = MatchQ[#, Except[ListableP[Null | Automatic]]]& /@ Lookup[roundedOptionsAssociation, lightScatteringOptions];
	(* pH *)
	phSpecifiedBool = MatchQ[#, Except[ListableP[Null | Automatic]]]& /@ Lookup[roundedOptionsAssociation, pHOptions];
	(* Conductivity *)
	conductivitySpecifiedBool = MatchQ[#, Except[ListableP[Null | Automatic]]]& /@ Lookup[roundedOptionsAssociation, conductivityOptions];

	(* Check to see if the user negatively specified any of the UVVis detector options to Null *)
	uvOptionNullBool = MatchQ[#, ListableP[Null]]& /@ Lookup[roundedOptionsAssociation, tuvOptions];
	(* PDA *)
	pdaOptionNullBool = MatchQ[#, ListableP[Null]]& /@ Lookup[roundedOptionsAssociation, moreSpecificPDAOptions];
	(* Fluorescence *)
	flrOptionNullBool = MatchQ[#, ListableP[Null]]& /@ Lookup[roundedOptionsAssociation, flrOptions];
	(* Dionex Fluorescence *)
	dionexFlrOptionNullBool = MatchQ[#, ListableP[Null]]& /@ Lookup[roundedOptionsAssociation, dionexFlrOptions];
	(* ELSD *)
	elsdOptionNullBool = MatchQ[#, ListableP[Null]]& /@ Lookup[roundedOptionsAssociation, elsdOptions];
	(* Waters specified *)
	watersNullBool = MatchQ[#, ListableP[Null]]& /@ Lookup[roundedOptionsAssociation, watersAbsorbanceOptions];
	(* Light Scattering (MALS/DLS) *)
	lightScatteringNullBool = MatchQ[#, ListableP[Null]]& /@ Lookup[roundedOptionsAssociation, lightScatteringOptions];
	(* Refractive Index *)
	refractiveIndexNullBool = MatchQ[#, ListableP[Null]]& /@ Lookup[roundedOptionsAssociation, refractiveIndexOptions];
	(* pH *)
	phNullBool = MatchQ[#, ListableP[Null]]& /@ Lookup[roundedOptionsAssociation, {pHCalibration, pHTemperatureCompensation}];
	(* Conductivity *)
	conductivityNullBool = MatchQ[#, ListableP[Null]]& /@ Lookup[roundedOptionsAssociation, {ConductivityCalibration, ConductivityTemperatureCompensation}];

	(* Were any of the detectors implicitly requested by option specification? *)
	uvRequestedQ = Or @@ Flatten[uvOptionSpecifiedBool];
	pdaRequestedQ = Or @@ Flatten[pdaOptionSpecifiedBool];
	flrRequestedQ = Or @@ Flatten[flrOptionSpecifiedBool];
	dionexFlrRequestedQ = Or @@ Flatten[dionexFlrOptionSpecifiedBool];
	watersFlrRequestedQ = Or @@ Flatten[watersFlrOptionSpecifiedBool];
	elsdRequestedQ = Or @@ Flatten[elsdOptionSpecifiedBool];
	watersRequestedQ = Or @@ Flatten[watersSpecifiedBool];
	nonDionexUVRequestedQ = Or @@ Flatten[nonDionexUVSpecifiedBool];
	lightScatteringRequestedQ = Or @@ Flatten[lightScatteringSpecifiedBool];
	pHRequestedQ = Or @@ Flatten[phSpecifiedBool];
	conductivityRequestedQ = Or @@ Flatten[conductivitySpecifiedBool];

	(* Were any of the detectors implicitly set to Null by option specification? *)
	uvRequestedNullQ = Or @@ Flatten[uvOptionNullBool];
	pdaRequestedNullQ = Or @@ Flatten[pdaOptionNullBool];
	flrRequestedNullQ = Or @@ Flatten[flrOptionNullBool];
	dionexFlrRequestedNullQ = Or @@ Flatten[dionexFlrOptionNullBool];
	elsdRequestedNullQ = Or @@ Flatten[elsdOptionNullBool];
	watersRequestedNullQ = Or @@ Flatten[watersNullBool];
	lightScatteringRequestedNullQ = Or @@ Flatten[lightScatteringNullBool];
	refractiveIndexRequestedNullQ = Or @@ Flatten[refractiveIndexNullBool];
	pHRequestedNullQ = Or @@ Flatten[phNullBool];
	conductivityRequestedNullQ = Or @@ Flatten[conductivityNullBool];

	(* Column Selection Boolean is set to true if InjectionTable and ColumnSelector options are specified, if not set to False *)
	resolvedColumnSelection = Which[
		MatchQ[Lookup[roundedOptionsAssociation, ColumnSelection], Except[Automatic]], Lookup[roundedOptionsAssociation, ColumnSelection],
		columnSelectorSpecifiedQ, True,
		(* Check InjectionTable to see if we actually have more than 1 set of columns. If we have more than 1 set, set ColumnSelection to True *)
		injectionTableSpecifiedQ,
		MatchQ[Length[DeleteCases[DeleteDuplicates[injectionTableLookup[[All, 4]]],(Null|Automatic)]],LessEqualP[1]],
		True, False
	];

	(* RESOLVE SeparationMode *)
	(* We'll need to grab all of the potential columns *)
	columnOptions = {
		ColumnPosition,
		Column,
		SecondaryColumn,
		TertiaryColumn,
		StandardColumnPosition,
		BlankColumnPosition
	};

	mainOptionsColumns = Cases[Flatten@ToList[Lookup[roundedOptionsAssociation, columnOptions]], ObjectP[]];

	(* There can also be columns in the selector, but we ignore the guard columns for resolving SeparationMode *)
	columnSelectorColumns = If[columnSelectorSpecifiedQ,
		Cases[Flatten[columnSelectorLookup[[All, {4, 6, 7}]]], ObjectP[]],
		{}
	];
	
	(* Combine all of the columns *)
	allColumnObjects = Join[mainOptionsColumns, columnSelectorColumns];

	(* Extract column model packets if option is specified *)
	specifiedColumnModelPackets = Map[
		Switch[#,
			ObjectP[Model],
			fetchPacketFromCacheHPLC[#, cache],
			ObjectP[],
			fetchModelPacketFromCacheHPLC[#, cache],
			_,
			Null
		]&,
		If[Length[allColumnObjects] > 0, allColumnObjects, {Null}]
	];

	(* If a column object is specified, fetch its SeparationMode *)
	specifiedColumnTypes = Map[
		If[!NullQ[#],
			Lookup[#, SeparationMode],
			Null
		]&,
		specifiedColumnModelPackets
	];

	(* Get all of the analyte types *)
	analyteTypes = DeleteDuplicates[
		Flatten[
			Map[
				Function[
					{analyte},
					Switch[analyte,
						ObjectP[Model[Molecule, Oligomer]], Lookup[fetchPacketFromCache[analyte, cache], PolymerType],
						ObjectP[Model[Molecule, Protein]], Protein,
						(* Otherwise, presumed to just be a molecule *)
						_, Molecule
					]
				], 
				sampleAnalytes
			]
		]
	];

	(* Resolve type based on sample strand types and the detector - if circular dichroism or MALS/DLS is requested *)
	(* This is safe to do as we don't actually resolve to CD or MALS/DLS detector if the user does not request that *)
	resolvedSeparationMode = If[MatchQ[Lookup[roundedOptionsAssociation, SeparationMode], SeparationModeP],
		Lookup[roundedOptionsAssociation, SeparationMode],
		Which[
			(* If a column is specified and it has a SeparationMode, use the first column's type *)
			MatchQ[FirstOrDefault[specifiedColumnTypes], SeparationModeP],
			FirstOrDefault[specifiedColumnTypes],
			(* If Circular Dichroism is requested, default to Chiral *)
			MemberQ[ToList[Lookup[roundedOptionsAssociation, Detector]], CircularDichroism] || MemberQ[ToList[Lookup[roundedOptionsAssociation, FractionCollectionDetector]], CircularDichroism],
			Chiral,
			(* If MALS and/or DLS is requested, default to SizeExclusion. MALS/DLS cannot be used for fraction collection and an error will be thrown later *)
			MemberQ[ToList[Lookup[roundedOptionsAssociation, Detector]], MultiAngleLightScattering | DynamicLightScattering],
			SizeExclusion,
			Or[
				(* If any are PNA or Peptides or Protein, resolve to ReversePhase *)
				MemberQ[analyteTypes, PNA],
				MemberQ[analyteTypes, Peptide],
				MemberQ[analyteTypes, Protein]
			],
			ReversePhase,
			(* DNA resolves to IonExchange *)
			MemberQ[analyteTypes, DNA],
			IonExchange,
			True,
			ReversePhase
		]
	];

	(* RESOLVE Standard and Blank *)

	(* Articulate all the standard options *)
	(* Set list of all standard options so we can determine if Standards are being injected (if any are specified) *)
	standardOptions = ToExpression /@ Select["OptionName" /. OptionDefinition[ExperimentHPLC], StringContainsQ["Standard"]];

	(*if the injection table is specified, get the types of all of the samples*)
	injectionTableTypes = If[injectionTableSpecifiedQ,
		injectionTableLookup[[All, 1]],
		{}
	];

	(* First we ask if any of the standard options are defined *)
	standardOptionSpecifiedBool = Map[MatchQ[Lookup[roundedOptionsAssociation, #], Except[(Null | None | Automatic)]]&, standardOptions];

	(* Check if any of them are specified *)
	standardOptionSpecifiedQ = Or @@ standardOptionSpecifiedBool;

	(* Now we ask whether any standards are to exist or already do *)
	standardExistsQ = Which[
		MatchQ[Lookup[roundedOptionsAssociation, StandardFrequency], None], False,
		NullQ[Lookup[roundedOptionsAssociation, Standard]], False,
		True, Or[Or @@ standardOptionSpecifiedBool, MemberQ[injectionTableTypes, Standard]]
	];

	(* Check to see if any of the standard options conflict with StandardFrequency -> None *)
	(* resolveChromatographyStandardsAndBlanks will error when Standard specifically is specified and StandardFrequency -> None, so we don't count that *)
	standardFrequencyStandardOptionsConflictOptions = If[MatchQ[Lookup[roundedOptionsAssociation, StandardFrequency], None] && standardOptionSpecifiedQ && MatchQ[Lookup[roundedOptionsAssociation, Standard], Automatic | Null],
		If[messagesQ, Message[Error::StandardOptionsButNoFrequency, PickList[standardOptions, standardOptionSpecifiedBool]]];
		PickList[standardOptions, standardOptionSpecifiedBool],
		{}
	];

	standardFrequencyStandardOptionsConflictTests = If[gatherTestsQ,
		Test["If StandardFrequency -> None, no other standard options are specified:",
			MatchQ[Lookup[roundedOptionsAssociation, StandardFrequency], None] && standardOptionSpecifiedQ,
			False
		],
		Nothing
	];

	standardNullOptionsConflictOptions = If[NullQ[Lookup[roundedOptionsAssociation, Standard]] && standardOptionSpecifiedQ,
		If[messagesQ, Message[Error::StandardOptionsButNoStandard, PickList[standardOptions, standardOptionSpecifiedBool] ]];
		PickList[standardOptions, standardOptionSpecifiedBool],
		{}
	];

	standardNullOptionsConflictTests = If[gatherTestsQ,
		Test["If Standard -> Null, no other standard options are specified:",
			NullQ[Lookup[roundedOptionsAssociation, Standard]] && standardOptionSpecifiedQ,
			False
		],
		Nothing
	];

	defaultStandard = Which[
		MatchQ[resolvedSeparationMode, IonExchange],
		(* "Thermo-Fisher dsDNA Ladder 10-300 bp, 50 ng/uL" *)
		Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
		(* Fluorescence Detector - Fluorescein *)
		MemberQ[ToList[Lookup[roundedOptionsAssociation, Detector]], Fluorescence],
		Model[Sample, StockSolution, "Fluorescein 1 mg/mL solution"],
		(* BSA for SizeExclusion *)
		MatchQ[resolvedSeparationMode, SizeExclusion],
		Model[Sample, "2 mg/mL Bovine Serum Albumin Standard"],
		(* Ibuprofen for Chiral *)
		MatchQ[resolvedSeparationMode, Chiral],
		Model[Sample, "Ibuprofen"],
		(* "Peptide HPLC Standard Mix" *)
		True,
		Model[Sample, StockSolution, Standard, "id:R8e1PjpkWx5X"]
	];

	(* Set list of all blank options so we can determine if blanks are being injected (if any are specified) *)
	blankOptions = ToExpression /@ Select["OptionName" /. OptionDefinition[ExperimentHPLC], StringContainsQ["Blank"]];

	(* First we ask if any of the blank options are defined *)
	blankOptionSpecifiedBool = Map[MatchQ[Lookup[roundedOptionsAssociation, #], Except[(Null | None | Automatic)]]&, blankOptions];

	(* Check if any of them are specified *)
	blankOptionSpecifiedQ = Or @@ blankOptionSpecifiedBool;

	(* Now we ask whether any blanks are to exist or already do*)
	(* A special case here is that if the user selects RefractiveIndex as one of the Detector, we would like to always include a blank - defaulted BufferA - to get the refractive index background *)
	(* First check whether any of the RefractiveIndex options is specified - indicating that refractive index detector is desired *)
	(* Compile a list of the RefractiveIndex detector related options *)
	refractiveIndexSingleOptions = {
		RefractiveIndexMethod,
		RefractiveIndexFlowCellTemperature,
		StandardRefractiveIndexMethod,
		StandardRefractiveIndexFlowCellTemperature,
		BlankRefractiveIndexMethod,
		BlankRefractiveIndexFlowCellTemperature,
		ColumnPrimeRefractiveIndexMethod,
		ColumnPrimeRefractiveIndexFlowCellTemperature,
		ColumnFlushRefractiveIndexMethod,
		ColumnFlushRefractiveIndexFlowCellTemperature
	};

	(* Also, if they choose to specify refractive index loading status in gradient, count that as requesting RefractiveIndex detector *)
	refractiveIndexGradientOptions = {
		Gradient,
		StandardGradient,
		BlankGradient,
		ColumnPrimeGradient,
		ColumnFlushGradient
	};

	(* Join all related options together *)
	refractiveIndexOptions = Join[refractiveIndexSingleOptions, refractiveIndexGradientOptions];

	(* Check to see if user positively specified any refractive index options *)
	refractiveIndexSpecifiedBoolSingleOption = MatchQ[#, Except[ListableP[Null | Automatic]]]& /@ Lookup[roundedOptionsAssociation, refractiveIndexSingleOptions];

	refractiveIndexSpecifiedGradientBool = Map[
		Function[{singleGradientOption},
			If[MatchQ[singleGradientOption, Automatic | Null | ObjectP[]],
				(* False if the option is not expanded or kept as Null *)
				False,
				(* Otherwise map through each gradient entry *)
				Or @@ Map[
					Which[
						MatchQ[#, Automatic | Null | ObjectP[]], False,
						MatchQ[#[[-1]], Open | Closed | None | Automatic], MatchQ[#[[-1]], Open | Closed],
						True, MemberQ[#[[All, -1]], Open | Closed]
					]&,
					singleGradientOption
				]
			]
		],
		Lookup[roundedOptionsAssociation, refractiveIndexGradientOptions]
	];

	refractiveIndexSpecifiedBool = Join[refractiveIndexSpecifiedBoolSingleOption, refractiveIndexSpecifiedGradientBool];

	(* Check if the refractive index detector is requested by any of the option *)
	refractiveIndexRequestedQ = Or @@ Flatten[refractiveIndexSpecifiedBool];

	refractiveIndexDetectorQ = Or[
		(* If RefractiveIndex is selected as Detector *)
		MemberQ[ToList[Lookup[roundedOptionsAssociation, Detector]], RefractiveIndex],
		(* If the provided Instrument has RefractiveIndex as one of the Detector and we will resolve the Detector automatically *)
		MemberQ[
			If[NullQ[specifiedInstrumentModelPackets] || !MatchQ[Lookup[roundedOptionsAssociation, Detector], Automatic],
				{},
				Intersection@@Lookup[specifiedInstrumentModelPackets, Detectors]
			],
			RefractiveIndex
		],
		refractiveIndexRequestedQ
	];

	(* Now we ask whether any blanks are to exist or already do *)
	blankExistsQ = Which[
		MatchQ[Lookup[roundedOptionsAssociation, BlankFrequency], None], False,
		NullQ[Lookup[roundedOptionsAssociation, Blank]], False,
		True,
		Or[
			Or @@ blankOptionSpecifiedBool,
			MemberQ[injectionTableTypes, Blank],
			refractiveIndexDetectorQ
		]
	];

	(* Check to see if any of the blank options conflict with BlankFrequency -> None *)
	blankFrequencyBlankOptionsConflictOptions = If[MatchQ[Lookup[roundedOptionsAssociation, BlankFrequency], None] && blankOptionSpecifiedQ && MatchQ[Lookup[roundedOptionsAssociation, Blank], Automatic | Null],
		If[messagesQ, Message[Error::BlankOptionsButNoFrequency, PickList[blankOptions, blankOptionSpecifiedBool] ]];
		PickList[blankOptions, blankOptionSpecifiedBool],
		{}
	];

	blankFrequencyBlankOptionsConflictTests = If[gatherTestsQ,
		Test["If BlankFrequency -> None, no other blank options are specified:",
			MatchQ[Lookup[roundedOptionsAssociation, BlankFrequency], None] && blankOptionSpecifiedQ,
			False
		],
		Nothing
	];

	blankNullOptionsConflictOptions = If[NullQ[Lookup[roundedOptionsAssociation, Blank]] && blankOptionSpecifiedQ,
		If[messagesQ, Message[Error::BlankOptionsButNoBlank, PickList[blankOptions, blankOptionSpecifiedBool] ]];
		PickList[blankOptions, blankOptionSpecifiedBool],
		{}
	];

	blankNullOptionsConflictTests = If[gatherTestsQ,
		Test["If Blank -> Null, no other blank options are specified:",
			NullQ[Lookup[roundedOptionsAssociation, Blank]] && blankOptionSpecifiedQ,
			False
		],
		Nothing
	];

	(* Define our default blank model*)
	defaultBlank = If[MatchQ[Lookup[roundedOptionsAssociation, BufferA], ObjectP[Model[Sample]]],
		(* Default to BufferA if specified *)
		Lookup[roundedOptionsAssociation, BufferA],
		(* Otherwise, default to water *)
		Model[Sample, "id:8qZ1VWNmdLBD"]
	];

	(* Call our shared helper in order to resolve common options related to the Standard and Blank *)
	{{resolvedStandardBlankOptions, invalidStandardBlankOptions}, invalidStandardBlankTests} = If[gatherTestsQ,
		resolveChromatographyStandardsAndBlanks[mySamples, roundedOptionsAssociation, standardExistsQ, defaultStandard, blankExistsQ, defaultBlank, Output -> {Result, Tests}],
		{resolveChromatographyStandardsAndBlanks[mySamples, roundedOptionsAssociation, standardExistsQ, defaultStandard, blankExistsQ, defaultBlank], {}}
	];

	{resolvedStandardFrequency, preresolvedStandard, resolvedBlankFrequency, preresolvedBlank} = Lookup[resolvedStandardBlankOptions, {StandardFrequency, Standard, BlankFrequency, Blank}];

	(* We need to expand out Blank and Standard Options respectively because we've resolved them *)
	preexpandedStandardOptions = If[!standardExistsQ,
		Association[# -> {}& /@ standardOptions],
		(* We need to wrap all the values in in list if not already *)
		Last[ExpandIndexMatchedInputs[
			ExperimentHPLC,
			{mySamples},
			Normal@Append[
				KeyTake[roundedOptionsAssociation, standardOptions],
				Standard -> preresolvedStandard
			],
			Messages -> False
		]]
	];

	preexpandedBlankOptions = If[!blankExistsQ,
		Association[# -> {}& /@ blankOptions],
		(* We need to wrap all the values in in list if not already *)
		Last[ExpandIndexMatchedInputs[
			ExperimentHPLC,
			{mySamples},
			Normal@Append[
				KeyTake[roundedOptionsAssociation, blankOptions],
				Blank -> preresolvedBlank
			],
			Messages -> False
		]]
	];

	(* If we have the singleton blank/standard, we need to wrap with a list for the rest of the experiment function *)
	{resolvedBlank, expandedBlankOptions} = If[And[
		Depth[Lookup[preexpandedBlankOptions, Blank]] <= 2,
		MatchQ[Lookup[preexpandedBlankOptions, Blank], Except[{} | {Null}]]
	],
		{
			ToList[Lookup[preexpandedBlankOptions, Blank]],
			Map[(First[#] -> List[Last[#]]) &, preexpandedBlankOptions]
		},
		(*if not the singleton case, then nothing to change *)
		{
			Lookup[preexpandedBlankOptions, Blank],
			preexpandedBlankOptions
		}
	];

	{resolvedStandard, expandedStandardOptions} = If[And[
		Depth[Lookup[preexpandedStandardOptions, Standard]] <= 2,
		MatchQ[Lookup[preexpandedStandardOptions, Standard], Except[{} | {Null}]]
	],
		{
			ToList[Lookup[preexpandedStandardOptions, Standard]],
			Map[(First[#] -> List[Last[#]]) &, preexpandedStandardOptions]
		},
		(* If not the singleton case, then nothing to change *)
		{
			Lookup[preexpandedStandardOptions, Standard],
			preexpandedStandardOptions
		}
	];

	(* Resolve Column options*)
	(* Column options are singleton options *)
	{columnLookup, secondaryColumnLookup, tertiaryColumnLookup, guardColumnLookup, guardColumnOrientationLookup, columnOrientationLookup} = Lookup[roundedOptionsAssociation, {Column, SecondaryColumn, TertiaryColumn, GuardColumn, GuardColumnOrientation, ColumnOrientation}];

	(* Track the specified ColumnPosition *)
	specifiedColumnPositions=DeleteCases[DeleteDuplicates[Flatten[Lookup[roundedOptionsAssociation, {ColumnPosition,StandardColumnPosition,BlankColumnPosition}]]],(Null|Automatic)];

	(*if the injection table is specified, then grab the column positions to see how many sets of columns we need *)
	injectionTableColumnPositions=If[injectionTableSpecifiedQ,
		DeleteCases[DeleteDuplicates[injectionTableLookup[[All, 4]]],(Null|Automatic)],
		{}
	];

	defaultColumn = Which[
		(* Use smaller column for LCMS instrument or ELSD as the column oven is smaller *)
		internalUsageQ, $DefaultLCMSColumn,

		MemberQ[Lookup[specifiedInstrumentModelPackets/.{Null->{}},ColumnPreheater,{Null}],True], $DefaultLCMSColumn,

		elsdRequestedQ, $DefaultLCMSColumn,

		(* MALS/DLS SizeExclusition - SEC Protein Column for MALS, 5 um, 500 A *)
		MemberQ[ToList[Lookup[roundedOptionsAssociation, Detector]], MultiAngleLightScattering | DynamicLightScattering]||lightScatteringRequestedQ,
		$DefaultSizeExclusionColumn,

		(* Preparative scale and ReversePhase *)
		MatchQ[Lookup[roundedOptionsAssociation, Scale], Preparative]&&MatchQ[resolvedSeparationMode, ReversePhase | SizeExclusion],
		(*  Prep C18 HPLC 50x50 Column *)
		$DefaultReversePhasePreparativeColumn,

		MatchQ[resolvedSeparationMode, ReversePhase | SizeExclusion],
		(* Aeris XB-C18 Peptide Column (15 cm) *)
		$DefaultReversePhaseAnalyticalColumn,

		(* IonExchange Column *)
		MatchQ[resolvedSeparationMode, IonExchange],
		If[MatchQ[Lookup[roundedOptionsAssociation, Scale], Preparative | SemiPreparative],
			(* "DNAPac PA200 9x250mm Column" *)
			$DefaultIonExchangePreparativeColumn,
			(* "DNAPac PA200 4x250mm Column" *)
			$DefaultIonExchangeAnalyticalColumn
		],

		(* Catch All *)
		MatchQ[Lookup[roundedOptionsAssociation, Scale], Preparative],
		(*  Prep C18 HPLC 50x50 Column *)
		$DefaultReversePhasePreparativeColumn,
		True,
		(* Aeris XB-C18 Peptide Column (15 cm) *)
		$DefaultReversePhaseAnalyticalColumn
	];

	(* Check for column gap in ColumnSelector and Column/SecondaryColumn/TertiaryColumn, basically that upstream column is Null but downstream column(s) are specified *)
	(* In this (expectedly) rare case, we should pad the columns upstream but will process with resolving other options *)
	{columnLookupNoGap,secondaryColumnLookupNoGap,tertiaryColumnLookupNoGap,columnGapQ}=Module[
		{allSpecifiedColumns,innerColumnGapQ},
		allSpecifiedColumns=Cases[{columnLookup,secondaryColumnLookup,tertiaryColumnLookup},(ObjectP[]|Automatic)];
		innerColumnGapQ=MatchQ[
			{columnLookup,secondaryColumnLookup,tertiaryColumnLookup},
			{___,Null,___,ObjectP[],___}
		];
		If[TrueQ[innerColumnGapQ],
			Join[
				(* Pad the column list to the left *)
				PadRight[allSpecifiedColumns,3,Null],
				{innerColumnGapQ}
			],
			Join[
				(* No gap - keep the user's list *)
				{columnLookup,secondaryColumnLookup,tertiaryColumnLookup},
				{innerColumnGapQ}
			]
		]
	];

	{columnSelectorNoGap,columnSelectorGapQ}=If[columnSelectorSpecifiedQ,
		Module[
			{innerColumnSelectorTuple,innerColumnSelectorGapBool},
			{innerColumnSelectorTuple,innerColumnSelectorGapBool}=Transpose@Map[
				Module[
					{innerColumns,innerColumnObjects,innerColumnGapQ},
					innerColumns=#[[{4,6,7}]];
					innerColumnObjects=Cases[innerColumns,(ObjectP[]|Automatic)];
					innerColumnGapQ=MatchQ[
						innerColumns,
						{___,Null,___,ObjectP[],___}
					];
					If[innerColumnGapQ,
						{
							(* If there is a gap, pad to the upstream *)
							ReplacePart[#,AssociationThread[{4,6,7},PadRight[innerColumnObjects,3,Null]]],
							innerColumnGapQ
						},
						{#,innerColumnGapQ}
					]
				]&,
				columnSelectorLookup
			]
		],
		{columnSelectorLookup,False}
	];

	(* Resolve Column and ColumnSelection and track error tracking booleans *)
	(* Column/SecondaryColumn/TertiaryColumn/GuardColumn are Single options and used when there is ONLY one set of column *)
	(* ColumnSelector is used when there are two or more sets of columns *)
	(* If there is only one set of column specified with Column/SecondaryColumn/TertiaryColumn/GuardColumn options, we  compile everything into ColumnSelector *)
	(* If user specify one set of column in ColumnSelector and Column/SecondaryColumn/TertiaryColumn and they match, we will still accept them *)
	(* columnSelectorSampleConflictQ/secondaryColumnSelectorSampleConflictQ/tertiaryColumnSelectorSampleConflictQ is to deal with the case that the user has specified ColumnSelector AND Column/SecondaryColumn/TertiaryColumn and they do not match *)
	(* tableColumnPositionConflictQ is to deal with the case that the user has specified ColumnSelector AND InjectionTable but the number of entries do not match *)
	(* columnPositionConflictQ is to deal with the case that ColumnPosition option has more different entries than Column/ColumnSelector *)
	(* columnPositionDuplicateQ is to deal with multiple entries in ColumnSelector with the same ColumnPosition *)
	(* Note that the ColumnPosition option may be conflicting with the Column Position entry in InjectionTable and this will be checked later *)
	(* GuardCartridge is no longer an option for ExperimentHPLC. We will automatically select the pair of GuardColumn/GuardCartridge in our resource packets *)
	{
		(*1*)resolvedColumn,
		(*2*)resolvedSecondaryColumn,
		(*3*)resolvedTertiaryColumn,
		(*4*)resolvedColumnOrientation,
		(*5*)resolvedGuardColumn,
		(*6*)resolvedGuardColumnOrientation,
		(*7*)resolvedColumnSelector,
		(*8*)columnSelectorSampleConflictQ,
		(*9*)secondaryColumnSelectorSampleConflictQ,
		(*10*)tertiaryColumnSelectorSampleConflictQ,
		(*11*)guardColumnSelectorConflictQ,
		(*12*)guardColumnOrientationSelectorConflictQ,
		(*13*)columnOrientationSelectorConflictQ,
		(*14*)tableColumnPositionConflictQ,
		(*15*)columnPositionConflictQ,
		(*16*)columnPositionDuplicateQ,
		(*17*)multipleColumnsReverseQ
	}=Module[
		{columnSelectorColumns,columnSelectorGuardColumns,columnSelectorGuardColumnOrientations,columnSelectorColumnOrientations,column,secondaryColumn,tertiaryColumn,guardColumn,guardColumnOrientation,columnOrientation,allColumnPositions,allSpecifiedColumnPositions,reorderedColumnPositions,columnSelectorAutomaticPositions,columnSelectorPositions,columnSelector,columnConflictQ,secondaryColumnConflictQ,tertiaryColumnConflictQ,guardColumnConflictQ,guardColumnOrientationConflictQ,columnOrientationConflictQ,tableConflictQ,positionConflictQ,positionDuplicateQ,reverseQ},

		{columnConflictQ,secondaryColumnConflictQ,tertiaryColumnConflictQ,guardColumnConflictQ,tableConflictQ,positionConflictQ,positionDuplicateQ,reverseQ}={False,False,False,False,False,False,False,False};
		(* Resolve ColumnSelector first *)
		columnSelectorColumns = Which[
			(* ColumnSelector is specified *)
			columnSelectorSpecifiedQ,
				Map[
					{
						(* If first column is automatic, convert to columnLookup and then to defaultColumn *)
						(#[[1]]/.{Automatic->columnLookup})/.{Automatic->defaultColumn},
						(* If second column is automatic, convert to secondaryColumnLookup and then to Null *)
						(#[[2]]/.{Automatic->secondaryColumnLookup})/.{Automatic->Null},
						(* If third column is automatic, convert to secondaryColumnLookup and then to Null *)
						(#[[3]]/.{Automatic->tertiaryColumnLookup})/.{Automatic->Null}
					}&,
					columnSelectorLookup[[All,{4,6,7}]]
				],
			NullQ[columnSelectorLookup],
				(* Convert Null to list of Nulls for easy processing later *)
				{{Null, Null, Null}},
			(* ColumnSelector is not specified but something is provided in the Column/SecondaryColumn/TertiaryColumn options *)
			(* The usage of these three options mean that the user wants ONLY one set of columns *)
			MemberQ[{columnLookup,secondaryColumnLookup,tertiaryColumnLookup},Except[Automatic]],
				{
					{
						(* First column - columnLookup and then to defaultColumn if automatic *)
						columnLookup/.{Automatic->defaultColumn},
						(* Second column - secondaryColumnLookup and then to Null if automatic *)
						secondaryColumnLookup/.{Automatic->Null},
						(* Third column - tertiaryColumnLookup and then to Null if automatic *)
						tertiaryColumnLookup/.{Automatic->Null}
					}
				},
			(* ColumnSelector is not specified and we don't have Column/SecondaryColumn/TertiaryColumn options either *)
			(* Decide the number of column selector required by column positions in InjectionTable or from ColumnPosition options *)
			True,
				ConstantArray[
					{defaultColumn,Null,Null},
					Max[{
						(* Give at least 1 set of column *)
						1,
						Length[injectionTableColumnPositions],
						Length[specifiedColumnPositions]
					}]
				]
		];

		(* Resolve ColumnSelector's GuardColumn *)
		columnSelectorGuardColumns=If[columnSelectorSpecifiedQ,
			MapThread[
				Which[
					(* Respect user option *)
					!MatchQ[#2,Automatic],#2,
					(* No column, no guard column *)
					NullQ[#1[[1]]],Null,
					(* Use GuardColumn option if specified *)
					!MatchQ[guardColumnLookup,Automatic],guardColumnLookup,
					(* Resolve based on column *)
					MatchQ[#1[[1]],ObjectP[Model]],Lookup[fetchPacketFromCacheHPLC[#1[[1]],cache],PreferredGuardColumn, Null]/.{x:ObjectP[]:>Download[x,Object]},
					MatchQ[#1[[1]],ObjectP[Object]],Lookup[fetchModelPacketFromCacheHPLC[#1[[1]],cache],PreferredGuardColumn, Null]/.{x:ObjectP[]:>Download[x,Object]}
				]&,
				(* Since we resolve columnSelectorColumns from columnSelectorLookup if specified so these are guaranteed to have matching lengths *)
				{columnSelectorColumns,columnSelectorLookup[[All,2]]}
			],
			Map[
				Which[
					(* No column, no guard column *)
					NullQ[#1[[1]]],Null,
					(* Use GuardColumn option if specified *)
					!MatchQ[guardColumnLookup,Automatic],guardColumnLookup,
					(* Resolve based on column *)
					MatchQ[#1[[1]],ObjectP[Model]],Lookup[fetchPacketFromCacheHPLC[#1[[1]],cache],PreferredGuardColumn, Null]/.{x:ObjectP[]:>Download[x,Object]},
					MatchQ[#1[[1]],ObjectP[Object]],Lookup[fetchModelPacketFromCacheHPLC[#1[[1]],cache],PreferredGuardColumn, Null]/.{x:ObjectP[]:>Download[x,Object]}
				]&,
				columnSelectorColumns
			]
		];

		(* Resolve ColumnSelector's GuardColumnOrientation *)
		columnSelectorGuardColumnOrientations=If[columnSelectorSpecifiedQ,
			MapThread[
				Which[
					(* Respect user option *)
					!MatchQ[#2,Automatic],#2,
					(* No guard column, no orientation *)
					NullQ[#1],Null,
					(* Use GuardColumnOrientation option if specified *)
					!MatchQ[guardColumnOrientationLookup,Automatic],guardColumnOrientationLookup,
					True,Forward
				]&,
				(* Since we resolve columnSelectorColumns from columnSelectorLookup if specified so these are guaranteed to have matching lengths *)
				{columnSelectorGuardColumns,columnSelectorLookup[[All,3]]}
			],
			Map[
				Which[
					(* No guard column, no orientation *)
					NullQ[#1],Null,
					(* Use GuardColumnOrientation option if specified *)
					!MatchQ[guardColumnOrientationLookup,Automatic],guardColumnOrientationLookup,
					True,Forward
				]&,
				columnSelectorColumns
			]
		];

		(* Resolve ColumnSelector's GuardColumnOrientation *)
		columnSelectorColumnOrientations=If[columnSelectorSpecifiedQ,
			MapThread[
				Which[
					(* Respect user option *)
					!MatchQ[#2,Automatic],#2,
					(* No column, no orientation *)
					NullQ[#1[[1]]],Null,
					(* Use ColumnOrientation option if specified *)
					!MatchQ[columnOrientationLookup,Automatic],columnOrientationLookup,
					True,Forward
				]&,
				(* Since we resolve columnSelectorColumns from columnSelectorLookup if specified so these are guaranteed to have matching lengths *)
				{columnSelectorColumns,columnSelectorLookup[[All,5]]}
			],
			Map[
				Which[
					(* No column, no orientation *)
					NullQ[#1[[1]]],Null,
					(* Use ColumnOrientation option if specified *)
					!MatchQ[columnOrientationLookup,Automatic],columnOrientationLookup,
					True,Forward
				]&,
				columnSelectorColumns
			]
		];

		(* Get the resolved Column/SecondaryColumn/TertiaryColumn *)
		(* Since ColumnSelector resolution is already resolved to remove any Automatic, we can use its value directly *)
		column=Which[
			!MatchQ[columnLookup,Automatic],columnLookup,
			(* If we have more than 1 set of columns, we do not use the Singleton options *)
			Length[columnSelectorColumns]>1,Null,
			True,columnSelectorColumns[[1,1]]
		];
		secondaryColumn=Which[
			!MatchQ[secondaryColumnLookup,Automatic],secondaryColumnLookup,
			(* If we have more than 1 set of columns, we do not use the Singleton options *)
			Length[columnSelectorColumns]>1,Null,
			True,columnSelectorColumns[[1,2]]
		];
		tertiaryColumn=Which[
			!MatchQ[tertiaryColumnLookup,Automatic],tertiaryColumnLookup,
			(* If we have more than 1 set of columns, we do not use the Singleton options *)
			Length[columnSelectorColumns]>1,Null,
			True,columnSelectorColumns[[1,3]]
		];
		guardColumn=Which[
			!MatchQ[guardColumnLookup,Automatic],guardColumnLookup,
			(* If we have more than 1 set of columns, we do not use the Singleton options *)
			Length[columnSelectorGuardColumns]>1,Null,
			True,columnSelectorGuardColumns[[1]]
		];
		guardColumnOrientation=Which[
			!MatchQ[guardColumnOrientationLookup,Automatic],guardColumnOrientationLookup,
			(* If we have more than 1 set of columns, we do not use the Singleton options *)
			Length[columnSelectorGuardColumnOrientations]>1,Null,
			True,columnSelectorGuardColumnOrientations[[1]]
		];
		columnOrientation=Which[
			!MatchQ[columnOrientationLookup,Automatic],columnOrientationLookup,
			(* If we have more than 1 set of columns, we do not use the Singleton options *)
			Length[columnSelectorColumnOrientations]>1,Null,
			True,columnSelectorColumnOrientations[[1]]
		];

		(* Resolve the ColumnPosition in ColumnSelector *)
		allColumnPositions=List@@(ColumnPositionP);
		allSpecifiedColumnPositions=DeleteDuplicates[
			Join[
				(* From ColumnPosition options *)
				specifiedColumnPositions,
				(* From InjectionTable option *)
				injectionTableColumnPositions,
				(* From ColumnSelector option *)
				If[columnSelectorSpecifiedQ,
					Cases[columnSelectorLookup[[All,1]],ColumnPositionP],
					{}
				]
			]
		];
		reorderedColumnPositions=Join[allSpecifiedColumnPositions,Complement[allColumnPositions,specifiedColumnPositions]];
		(* Find where Automatic ColumnPositions need to be replaced *)
		columnSelectorAutomaticPositions=If[columnSelectorSpecifiedQ,
			(* If user has specified  *)
			Flatten[Position[columnSelectorLookup[[All,1]],Automatic]],
			Range[Length[columnSelectorColumns]]
		];

		columnSelectorPositions=ReplacePart[
			(* Replace Automatic from user's ColumnSelector or a list of Automatic matching required number of sets *)
			If[columnSelectorSpecifiedQ,
				columnSelectorLookup[[All,1]],
				ConstantArray[Automatic,Length[columnSelectorColumns]]
			],
			(* Replace the Automatic positions with the preferred (required) ColumnPositions *)
			AssociationThread[
				columnSelectorAutomaticPositions,
				Take[reorderedColumnPositions,columnSelectorAutomaticPositions]
			]
		];

		(* Put together the ColumnSelector *)
		columnSelector=MapThread[
			{#1,#2,#3,#4[[1]],#5,#4[[2]],#4[[3]]}&,
			{columnSelectorPositions,columnSelectorGuardColumns,columnSelectorGuardColumnOrientations,columnSelectorColumns,columnSelectorColumnOrientations}
		];

		(* Perform the error checks *)
		columnConflictQ=!Or[
			(* If both Column and ColumnSelector are Null, it is fine *)
			And[
				NullQ[column],
				NullQ[columnSelectorColumns]
			],
			(* If ColumnSelector has >=2 sets, Column should be Null *)
			And[
				NullQ[column],
				Length[columnSelectorColumns]>1
			],
			(* Otherwise ColumnSelector should match the column *)
			And[
				Length[columnSelectorColumns]==1,
				MatchQ[column,columnSelectorColumns[[1,1]]]
			]
		];
		secondaryColumnConflictQ=!Or[
			(* If both SecondaryColumn and ColumnSelector are Null, it is fine *)
			And[
				NullQ[secondaryColumn],
				NullQ[columnSelectorColumns]
			],
			(* If ColumnSelector has >=2 sets, SecondaryColumn should be Null *)
			And[
				NullQ[secondaryColumn],
				Length[columnSelectorColumns]>1
			],
			(* Otherwise ColumnSelector should match the SecondaryColumn *)
			And[
				Length[columnSelectorColumns]==1,
				MatchQ[secondaryColumn,columnSelectorColumns[[1,2]]]
			]
		];
		tertiaryColumnConflictQ=!Or[
			(* If both TertiaryColumn and ColumnSelector are Null, it is fine *)
			And[
				NullQ[tertiaryColumn],
				NullQ[columnSelectorColumns]
			],
			(* If ColumnSelector has >=2 sets, TertiaryColumn should be Null *)
			And[
				NullQ[tertiaryColumn],
				Length[columnSelectorColumns]>1
			],
			(* Otherwise ColumnSelector should match the TertiaryColumn *)
			And[
				Length[columnSelectorColumns]==1,
				MatchQ[tertiaryColumn,columnSelectorColumns[[1,3]]]
			]
		];
		guardColumnConflictQ=!Or[
			(* If both GuardColumn and ColumnSelector are Null, it is fine *)
			And[
				NullQ[guardColumn],
				NullQ[columnSelectorGuardColumns]
			],
			(* If ColumnSelector has >=2 sets, GuardColumn should be Null *)
			And[
				NullQ[guardColumn],
				Length[columnSelectorGuardColumns]>1
			],
			(* Otherwise ColumnSelector should match the GuardColumn *)
			And[
				Length[columnSelectorGuardColumns]==1,
				MatchQ[guardColumn,columnSelectorGuardColumns[[1]]]
			]
		];
		guardColumnOrientationConflictQ=!Or[
			(* If GuardColumn is Null, it is fine *)
			NullQ[guardColumn],
			(* If ColumnSelector has >=2 sets, GuardColumnOrientation should be Null *)
			And[
				NullQ[guardColumnOrientation],
				Length[columnSelectorGuardColumnOrientations]>1
			],
			(* Otherwise ColumnSelector should match the GuardColumnOrientation *)
			And[
				Length[columnSelectorGuardColumnOrientations]==1,
				MatchQ[guardColumnOrientation,columnSelectorGuardColumnOrientations[[1]]]
			]
		];
		columnOrientationConflictQ=!Or[
			(* If Column is Null, it is fine *)
			NullQ[columnSelectorColumns],
			(* If ColumnSelector has >=2 sets, GuardColumnOrientation should be Null *)
			And[
				NullQ[columnOrientation],
				Length[columnSelectorColumnOrientations]>1
			],
			(* Otherwise ColumnSelector should match the TertiaryColumn *)
			And[
				Length[columnSelectorColumnOrientations]==1,
				MatchQ[columnOrientation,columnSelectorColumnOrientations[[1]]]
			]
		];

		(* Check if more ColumnPosition are required in our injection table than what we were able to resolve *)
		(* If columnSelectorColumns is resolved to be Null ({Null,Null,Null}) (meaning that we don't have Column), it is still allowed to have one position as PositionA *)
		tableConflictQ=MatchQ[Length[injectionTableColumnPositions],GreaterP[Length[columnSelectorPositions]]];

		(* Check if more ColumnPosition are required in our ColumnPosition option than what we were able to resolve *)
		positionConflictQ=MatchQ[Length[specifiedColumnPositions],GreaterP[Length[columnSelectorPositions]]];

		(* Check if there are duplicate ColumnPositions, this must have been specified by the user *)
		positionDuplicateQ=!DuplicateFreeQ[columnSelectorPositions];

		(* Check if we have multiple columns but the column orientation is Reverse *)
		reverseQ=Or@@MapThread[
			And[
				Count[#1,ObjectP[]]>1,
				MatchQ[#2,Reverse]
			]&,
			{columnSelectorColumns,columnSelectorColumnOrientations}
		];

		(* Return everything *)
		{
			(*1*)column,
			(*2*)secondaryColumn,
			(*3*)tertiaryColumn,
			(*4*)columnOrientation,
			(*5*)guardColumn,
			(*6*)guardColumnOrientation,
			(*7*)columnSelector,
			(*8*)columnConflictQ,
			(*9*)secondaryColumnConflictQ,
			(*10*)tertiaryColumnConflictQ,
			(*11*)guardColumnConflictQ,
			(*12*)guardColumnOrientationConflictQ,
			(*13*)columnOrientationConflictQ,
			(*14*)tableConflictQ,
			(*15*)positionConflictQ,
			(*16*)positionDuplicateQ,
			(*17*)reverseQ
		}
	];

	(* Throw our errors and tabulate our tests from column related resolution *)
	(* Check if we have column(s) *)
	(* resolvedColumnSelector is list of Null if we have no column *)
	columnSelectorQ = If[!NullQ[resolvedColumnSelector],
		!Or[
			Length[resolvedColumnSelector] == 0,
			(* Or only with ColumnPosition entry but no column *)
			(* We have to get a column position entry for samples *)
			NullQ[resolvedColumnSelector[[1,2;;]]]
		],
		False
	];

	columnSelectorOptions = Map[
		ToExpression,
		"OptionName" /. Cases[OptionDefinition[ExperimentHPLC], KeyValuePattern["IndexMatchingParent" -> "ColumnSelector"]]
	];

	(* First we ask if any of the column options are defined *)
	columnOptionSpecifiedBool = Map[MatchQ[Lookup[roundedOptionsAssociation, #], Except[(Null | None | Automatic)]]&, columnSelectorOptions];

	(* Check if any of them are specified *)
	columnOpttionSpecifiedQ = Or @@ columnOptionSpecifiedBool;

	columnNullOptionsConflictOptions = If[!columnSelectorQ && columnOpttionSpecifiedQ,
		If[messagesQ, Message[Error::ColumnOptionsButNoColumn, PickList[columnSelectorOptions, columnOptionSpecifiedBool]]];
		PickList[columnSelectorOptions, columnOptionSpecifiedBool],
		{}
	];

	columnNullOptionsConflictTests = If[gatherTestsQ,
		Test["If the Column/ColumnSelector options are set to Null (indicating there will be no column for the experiment), no other column options are specified:",
			!columnSelectorQ && columnOpttionSpecifiedQ,
			False
		],
		Nothing
	];

	(* Check to see if there is a gap overall *)
	overallColumnGapQ = Or @@ Flatten[{columnGapQ, columnSelectorGapQ}];

	(* Throw errors if there is gap in column options *)
	columnGapOptions = If[overallColumnGapQ,
		Flatten[
			PickList[
				{
					{Column, SecondaryColumn, TertiaryColumn},
					ColumnSelector
				},
				{columnGapQ, Or@@columnSelectorGapQ}
			]
		],
		{}
	];

	columnGapTest = If[overallColumnGapQ,
		testOrNull["If any of the column options are specified (e.g. ColumnSelector, Column, SecondaryColumn, TertiaryColumn), then there are no gaps:", False],
		testOrNull["If any of the column options are specified (e.g. ColumnSelector, Column, SecondaryColumn, TertiaryColumn), then there are no gaps:", True]
	];

	If[messagesQ && overallColumnGapQ, Message[Error::ColumnGap, ToString[columnGapOptions]]];

	(* Column/SecondaryColumn/TertiaryColumn should match ColumnSelector *)
	columnSelectorConflictQ = Or @@ {columnSelectorSampleConflictQ, secondaryColumnSelectorSampleConflictQ, tertiaryColumnSelectorSampleConflictQ};

	columnSelectorConflictOptions = If[columnSelectorConflictQ,
		If[messagesQ, Message[Error::ColumnSelectorConflict]];
		Append[PickList[{Column,SecondaryColumn,TertiaryColumn}, {columnSelectorSampleConflictQ, secondaryColumnSelectorSampleConflictQ, tertiaryColumnSelectorSampleConflictQ}], ColumnSelector],
		{}
	];

	columnSelectorConflictTest = If[columnSelectorConflictQ,
		testOrNull["If ColumnSelector and any of the Column,SecondaryColumn,TertiaryColumn options are specified, the ColumnSelector includes the columns within the other options:", False],
		testOrNull["If ColumnSelector and any of the Column,SecondaryColumn,TertiaryColumn options are specified, the ColumnSelector includes the columns within the other options:", True]
	];

	(* GuardColumn should match ColumnSelector *)
	guardColumnSelectorConflictOptions = If[guardColumnSelectorConflictQ,
		If[messagesQ, Message[Error::GuardColumnSelector]];
		{GuardColumn, ColumnSelector},
		{}
	];

	guardColumnSelectorConflictTest = If[guardColumnSelectorConflictQ,
		testOrNull["If both GuardColumn and ColumnSelector are specified, then they're equivalent:", False],
		testOrNull["If both GuardColumn and ColumnSelector are specified, then they're equivalent:", True]
	];

	(* GuardColumnOrientation/ColumnOrientation should match ColumnSelector *)
	columnOrientationSelectorConflictOptions = If[Or[guardColumnOrientationSelectorConflictQ,columnOrientationSelectorConflictQ],
		If[messagesQ, Message[Error::ColumnOrientationSelector]];
		PickList[{GuardColumnOrientation, ColumnOrientation},{guardColumnOrientationSelectorConflictQ,columnOrientationSelectorConflictQ}],
		{}
	];

	columnOrientationSelectorConflictTest = If[guardColumnSelectorConflictQ,
		testOrNull["If GuardColumnOrientation and ColumnOrientation options are specified with ColumnSelector, then they're equivalent:", False],
		testOrNull["If GuardColumnOrientation and ColumnOrientation options are specified with ColumnSelector, then they're equivalent:", True]
	];

	(* InjectionTable and Column option conflict - this error is thrown if InjectionTable thinks we should have more than 1 column sets but we were only able to get one through our resolution *)
	tableColumnConflictOptions = If[tableColumnPositionConflictQ,
		If[messagesQ, Message[Error::InjectionTableColumnConflictHPLC]];
		{InjectionTable},
		{}
	];
	tableColumnConflictTest = If[tableColumnPositionConflictQ,
		testOrNull["If the InjectionTable option is specified, the required column sets are specified in the ColumnSelector option:", False],
		testOrNull["If the InjectionTable option is specified, the required column sets are specified in the ColumnSelector option:", True]
	];

	(* ColumnPosition and Column option conflict - this error is thrown if ColumnPosition thinks we should have more than 1 column sets but we were only able to get one through our resolution *)
	columnPositionConflictOptions = If[columnPositionConflictQ,
		If[messagesQ, Message[Error::ColumnPositionColumnConflict]];
		PickList[
			{ColumnPosition,StandardColumnPosition,BlankColumnPosition},
			Lookup[roundedOptionsAssociation, {ColumnPosition,StandardColumnPosition,BlankColumnPosition}],
			Except[{}|ListableP[Automatic|Null]]
		],
		{}
	];
	columnPositionConflictTest = If[columnPositionConflictQ,
		testOrNull["If the ColumnPosition option(s) are specified, the required column sets are specified in the ColumnSelector option:", False],
		testOrNull["If the ColumnPosition option(s) are specified, the required column sets are specified in the ColumnSelector option:", True]
	];

	(* ColumnPosition in ColumnSelector has duplicates *)
	duplicateColumnPositionOptions = If[columnPositionDuplicateQ,
		If[messagesQ, Message[Error::DuplicateColumnSelectorPositions]];
		{ColumnSelector},
		{}
	];
	duplicateColumnPositionTest = If[columnPositionDuplicateQ,
		testOrNull["If the ColumnSelector option is specified, the required Column Position does not have duplicates:", False],
		testOrNull["If the ColumnSelector option is specified, the required Column Position does not have duplicates:", True]
	];

	(* More than 1 column with ColumnOrientation->Reverse *)
	multipleColumnReverseOptions = If[multipleColumnsReverseQ, {Column, ColumnOrientation}, {}];

	multipleColumnReverseTest = If[multipleColumnsReverseQ,
		(
			If[messagesQ,
				Message[Error::ReverseMoreThanOneColumn]
			];
			testOrNull["ColumnOrientation is not ReverseColumn with more than one column given:", False]
		),
		testOrNull["ColumnOrientation is not ReverseColumn with more than one column given:", True]
	];

	(* Resolve ColumnPosition *)
	(* We need to make sure that if the injection table is specified that the samples and the input are copacetic *)
	injectionTableSampleConflictQ = If[injectionTableSpecifiedQ,
		!MatchQ[Download[Cases[injectionTableLookup, {Sample, ___}] /. {Sample, x_, ___} :> x, Object, Cache -> cache], Download[mySamples, Object, Cache -> cache]],
		(* Valid if there is no InjectionTable *)
		False
	];
	injectionTableStandardConflictQ = If[injectionTableSpecifiedQ,
		!MatchQ[Download[Cases[injectionTableLookup, {Standard, ___}] /. {Standard, x_, ___} :> x, Object, Cache -> cache], Download[Lookup[expandedStandardOptions,Standard,{}], Object, Cache -> cache]],
		(* Valid if there is no InjectionTable *)
		False
	];
	injectionTableBlankConflictQ = If[injectionTableSpecifiedQ,
		!MatchQ[Download[Cases[injectionTableLookup, {Blank, ___}] /. {Blank, x_, ___} :> x, Object, Cache -> cache], Download[Lookup[expandedBlankOptions,Blank], Object, Cache -> cache]],
		(* Valid if there is no InjectionTable *)
		False
	];

	(* Define a default Position for our Automatic column positions, this is the first position that appears in the ColumnSelector, InjectionTable, ColumnPosition options *)
	defaultColumnPosition=If[
		(* We may have mismatching ColumnPosition in InjectionTable/ColumnPosition vs ColumnSelector, go with the first possible value for an existing sample *)
		!MatchQ[Join[specifiedColumnPositions,injectionTableColumnPositions],{}],
		First[Join[specifiedColumnPositions,injectionTableColumnPositions]],
		FirstOrDefault[
			resolvedColumnSelector[[All,1]],
			PositionA
		]
	];

	(* Column positions are the list of positions indexed matched to samples in the Injection Table *)
	{resolvedColumnPosition,columnPositionInjectionTableConflictQ} = If[injectionTableSpecifiedQ&&!injectionTableSampleConflictQ,
		(* If injection Table is specified, get the values from there and combine with the ColumnPosition option *)
		Module[
			{positions,conflictBools},
			{positions,conflictBools}=Transpose@MapThread[
				If[!MatchQ[#1,Automatic],
					{#1,!MatchQ[#2,Automatic|#1]},
					(* No conflict if either automatic *)
					{#2/.{Automatic->defaultColumnPosition},False}
				]&,
				{
					Lookup[roundedOptionsAssociation, ColumnPosition],
					Cases[injectionTableLookup, {Sample, ___}][[All, 4]]
				}
			];
			{positions,Or@@conflictBools}
		],
		(* Otherwise resolve to the default position *)
		{
			Lookup[roundedOptionsAssociation, ColumnPosition]/.{Automatic->defaultColumnPosition},
			False
		}
	];

	(* Get column positions for the Standards *)
	{resolvedStandardColumnPosition,standardColumnPositionInjectionTableConflictQ} = If[injectionTableSpecifiedQ&&!injectionTableStandardConflictQ,
		(* If injection Table is specified, get the values from there and combine with the ColumnPosition option *)
		Module[
			{positions,conflictBools},
			{positions,conflictBools}=If[!standardExistsQ,
				{{},{}},
				Transpose@MapThread[
					If[!MatchQ[#1,Automatic],
						{#1,!MatchQ[#2,Automatic|#1]},
						(* No conflict if either automatic *)
						{#2/.{Automatic->defaultColumnPosition},False}
					]&,
					{
						Lookup[expandedStandardOptions, StandardColumnPosition],
						Cases[injectionTableLookup, {Standard, ___}][[All, 4]]
					}
				]
			];
			{positions,Or@@conflictBools}
		],
		(* Otherwise resolve to the default position *)
		{
			Lookup[expandedStandardOptions, StandardColumnPosition]/.{Automatic->defaultColumnPosition},
			False
		}
	];

	(* Get column positions for the Blanks *)
	{resolvedBlankColumnPosition,blankColumnPositionInjectionTableConflictQ} = If[injectionTableSpecifiedQ&&!injectionTableBlankConflictQ,
		(* If injection Table is specified, get the values from there and combine with the ColumnPosition option *)
		Module[
			{positions,conflictBools},
			{positions,conflictBools}=If[!blankExistsQ,
				{{},{}},
				Transpose@MapThread[
					If[!MatchQ[#1,Automatic],
						{#1,!MatchQ[#2,Automatic|#1]},
						(* No conflict if either automatic *)
						{#2/.{Automatic->defaultColumnPosition},False}
					]&,
					{
						Lookup[expandedBlankOptions, BlankColumnPosition],
						Cases[injectionTableLookup, {Blank, ___}][[All, 4]]
					}
				]
			];
			{positions,Or@@conflictBools}
		],
		(* Otherwise resolve to the default position *)
		{
			Lookup[expandedBlankOptions, BlankColumnPosition]/.{Automatic->defaultColumnPosition},
			False
		}
	];

	(* Check if specified ColumnPosition in InjectionTable match the standalone ColumnPosition options *)
	(* ColumnPosition in ColumnSelector has duplicates *)
	columnPositionInjectionTableConflictOptions = If[Or[columnPositionInjectionTableConflictQ, standardColumnPositionInjectionTableConflictQ, blankColumnPositionInjectionTableConflictQ],
		If[messagesQ, Message[Error::ColumnPositionInjectionTableConflict]];
		Join[
			{ColumnSelector},
			PickList[
				{ColumnPosition,StandardColumnPosition,BlankColumnPosition},
				{columnPositionInjectionTableConflictQ, standardColumnPositionInjectionTableConflictQ, blankColumnPositionInjectionTableConflictQ}
			]
		],
		{}
	];
	columnPositionInjectionTableConflictTest = If[Or[columnPositionInjectionTableConflictQ, standardColumnPositionInjectionTableConflictQ, blankColumnPositionInjectionTableConflictQ],
		testOrNull["The ColumnPosition/ StandardColumnPosition/ BlankColumnPosition options match the specified column positions in the InjectionTable option:", False],
		testOrNull["The ColumnPosition/ StandardColumnPosition/ BlankColumnPosition options match the specified column positions in the InjectionTable option:", True]
	];


	(* Extract cartridge model packet if guard column option is specified as a cartridge *)
	(* This is only to check user-provided values *)
	specifiedGuardCartridgeModelPackets = Map[
		Switch[#,
			ObjectP[Model[Item, Cartridge, Column]],
			fetchPacketFromCacheHPLC[Download[#,Object],cache],
			ObjectP[Object[Item, Cartridge, Column]],
			fetchModelPacketFromCacheHPLC[Download[#,Object],cache],
			_,
			Null
		]&,
		Join[
			{guardColumnLookup/.{(Automatic->Null)}},
			If[columnSelectorSpecifiedQ,
				columnSelectorLookup[[All,2]],
				{}
			]
		]
	];

	(* Extract guard column model packet if guard column option is specified. If the option was specified as a cartridge, use the first GuardColumn that the cartridge points to. *)
	specifiedGuardColumnModelPackets = MapThread[
		Function[{guardColumn, cartridgeModelPacket},
			Switch[guardColumn,
				ObjectP[Model[Item, Column]], fetchPacketFromCacheHPLC[Download[guardColumn, Object], cache],
				ObjectP[Object[Item, Column]], fetchModelPacketFromCacheHPLC[Download[guardColumn, Object], cache],
				ObjectP[{Model[Item, CartridgeColumn], Object[Item, Cartridge, Column]}], fetchPacketFromCacheHPLC[Download[Lookup[cartridgeModelPacket, PreferredGuardColumn], Object], cache],
				_, Null
			]
		],
		{
			Join[
				{guardColumnLookup/.{(Automatic->Null)}},
				If[columnSelectorSpecifiedQ,
					columnSelectorLookup[[All,2]],
					{}
				]
			],
			specifiedGuardCartridgeModelPackets
		}
	];

	(* - Column's SeparationMode Check - *)

	(* If SeparationMode and a column are specified, the column type should match the type of column *)
	(* Note that we only check the user provided options, not our resolved columns because (1) we resolve SeparationMode based on the user's columns; (2) we resolve column based on SeparationMode but due to the limitation of our preferred columns, we may not have the matching column resolution for all SeparationMode *)
	typeColumnCompatibleBool = Map[
		If[
			And[
				MatchQ[Lookup[roundedOptionsAssociation,SeparationMode],SeparationModeP],
				MatchQ[#,SeparationModeP]
			],
			MatchQ[#,Lookup[roundedOptionsAssociation, SeparationMode]],
			True
		]&,
		specifiedColumnTypes
	];

	typeColumnCompatibleQ = And @@ typeColumnCompatibleBool;

	(* Build test for Column-Type compatibility *)
	typeColumnTest = If[typeColumnCompatibleQ,
		warningOrNull["If SeparationMode and Column are specified, the separation mode of the column is the same as the selected SeparationMode:", True],
		warningOrNull["If SeparationMode and Column are specified, the separation mode of the column is the same as the selected SeparationMode:", False]
	];

	(* Throw warning if Type and Column are incompatible *)
	If[messagesQ && !typeColumnCompatibleQ && !engineQ,
		Message[Warning::IncompatibleColumnType, Column, ObjectToString@PickList[allColumnObjects, Not /@ typeColumnCompatibleBool], PickList[specifiedColumnTypes, Not /@ typeColumnCompatibleBool], resolvedSeparationMode];
	];

	(* If multiple columns are specified, they should have the same separation mode *)
	columnTypesConsistentQ = RepeatedQ[specifiedColumnTypes];

	(* Build test for consistency across column types *)
	columnTypeConsistencyTest = If[columnTypesConsistentQ,
		warningOrNull["If multiple columns are specified, the separation mode of the columns are the same:", True],
		warningOrNull["If multiple columns are specified, the separation mode of the columns are the same:", False]
	];

	(* Throw warning if Type and Column are incompatible *)
	If[messagesQ && !columnTypesConsistentQ && !engineQ,
		Message[Warning::VariableColumnTypes, ObjectToString@allColumnObjects, specifiedColumnTypes];
	];

	(* - GuardColumn's SeparationMode Check - *)

	(* If SeparationMode and a guard column are specified, the column type should match the type of guard column *)
	(* Note that we only check the user provided options, not our resolved guard columns because (1) we resolve SeparationMode based on the user's columns; (2) we resolve column based on SeparationMode but due to the limitation of our preferred columns, we may not have the matching column resolution for all SeparationMode; (3) we resolve guard column based on the primary column *)
	specifiedGuardColumnTypes = Map[
		If[!NullQ[#],
			Lookup[#, SeparationMode],
			Null
		]&,
		specifiedGuardColumnModelPackets
	];

	(* If SeparationMode and a guard column are specified, the column type should match the type of column *)
	typeGuardColumnCompatibleBool = Map[
		If[
			And[
				MatchQ[Lookup[roundedOptionsAssociation,SeparationMode],SeparationModeP],
				MatchQ[#,SeparationModeP]
			],
			MatchQ[#,Lookup[roundedOptionsAssociation, SeparationMode]],
			True
		]&,
		specifiedGuardColumnTypes
	];

	typeGuardColumnCompatibleQ = And @@ typeGuardColumnCompatibleBool;

	(* Build test for Column-Type compatibility  *)
	typeGuardColumnTest = If[typeGuardColumnCompatibleQ,
		warningOrNull["If SeparationMode and GuardColumn are specified, the separation mode of the guard column is the same as the selected SeparationMode:", True],
		warningOrNull["If SeparationMode and GuardColumn are specified, the separation mode of the guard column is the same as the selected SeparationMode:", False]
	];

	(* Throw warning if Type and Column are incompatible *)
	If[messagesQ && !typeGuardColumnCompatibleQ && !engineQ,
		Message[Warning::IncompatibleColumnType, GuardColumn, ObjectToString@Lookup[roundedOptionsAssociation, GuardColumn], specifiedGuardColumnTypes, Lookup[roundedOptionsAssociation, SeparationMode]];
	];


	(* - Column's ChromatographyType Check - *)

	(* If a column object is specified, fetch its ChromatographyType *)
	specifiedColumnTechniques = Map[
		If[!NullQ[#],
			Lookup[#, ChromatographyType],
			Null
		]&,
		specifiedColumnModelPackets
	];

	(* Column technique should be HPLC or Null *)
	columnTechniqueCompatibleQ = MatchQ[specifiedColumnTechniques, {(HPLC | Null)...}];

	(* Build test for technique compatibility  *)
	columnTechniqueTest = If[columnTechniqueCompatibleQ,
		warningOrNull["If Column is specified, its ChromatographyType is HPLC:", True],
		warningOrNull["If Column is specified, its ChromatographyType is HPLC:", False]
	];

	(* Throw warning if technique is not HPLC *)
	If[messagesQ && !columnTechniqueCompatibleQ && !engineQ,
		Message[Warning::IncompatibleColumnTechnique, Column, ObjectToString[allColumnObjects], specifiedColumnTechniques, HPLC];
	];

	(* - GuardColumn's ChromatographyType Check - *)

	(* If a column object is specified, fetch its ChromatographyType *)
	specifiedGuardColumnTechniques=Map[
		If[NullQ[#],
			Null,
			Lookup[#, ChromatographyType]
		]&,
		specifiedGuardColumnModelPackets
	];

	guardColumnTechniqueCompatibleQ = MatchQ[specifiedGuardColumnTechniques, {(HPLC | Null)...}];

	(* Build test for technique compatibility *)
	guardColumnTechniqueTest = If[guardColumnTechniqueCompatibleQ,
		warningOrNull["If GuardColumn is specified, its ChromatographyType is HPLC:", True],
		warningOrNull["If GuardColumn is specified, its ChromatographyType is HPLC:", False]
	];

	(* Throw warning if technique is not HPLC *)
	If[messagesQ && !guardColumnTechniqueCompatibleQ && !engineQ,
		Message[Warning::IncompatibleColumnTechnique, GuardColumn, ObjectToString@Lookup[specifiedGuardColumnModelPackets, Object], specifiedGuardColumnTechniques, HPLC];
	];

	(* - Column/GuardColumn Temperature range check - *)
	(* Column Temperature now can only be specified in InjectionTable *)
	(* Note that even if we have multiple sets of columns, they live in the same column compartment. We can only set one column temperature, so we don't need to consider each range separately. *)

	(* Different from how we handle SeparationType or ChromatographyType, we are going to check on our resolved column as well. The reason is that we don't actually consider column temperature when resolving column (too much to consider there) so we want to make sure the user gives us column if they have very high temperature *)
	compatibleColumnTemperatureRanges = Map[
		Module[
			{columnModelPacket},
			columnModelPacket=Switch[#,
				ObjectP[Model],
				fetchPacketFromCacheHPLC[#, cache],
				ObjectP[],
				fetchModelPacketFromCacheHPLC[#, cache],
				_,
				Null
			];
			If[!NullQ[columnModelPacket],
				Lookup[columnModelPacket, {MinTemperature, MaxTemperature}],
				Nothing
			]
		]&,
		Flatten[resolvedColumnSelector[[All,{4,6,7}]]]
	];

	(* Get the most restrictive min and max range for the columns *)
	compatibleColumnTemperatureRange = Which[
		NullQ[compatibleColumnTemperatureRanges]||MatchQ[compatibleColumnTemperatureRanges,{}],
		Null,
		NullQ[compatibleColumnTemperatureRanges[[All, 1]]],
		{
			Null,
			Min[DeleteCases[compatibleColumnTemperatureRanges[[All, 2]],Null]]
		},
		NullQ[compatibleColumnTemperatureRanges[[All, 2]]],
		{
			Max[DeleteCases[compatibleColumnTemperatureRanges[[All, 1]],Null]],
			Null
		},
		True,
		{
			Max[DeleteCases[compatibleColumnTemperatureRanges[[All, 1]],Null]],
			Min[DeleteCases[compatibleColumnTemperatureRanges[[All, 2]],Null]]
		}
	];

	(* If a guard column object is specified, fetch its compatible temperature range *)
	(* Different from how we handle SeparationType or ChromatographyType, we are going to check on our resolved column as well. The reason is that we don't actually consider column temperature when resolving column (too much to consider there) so we want to make sure the user gives us column if they have very high temperature *)
	compatibleGuardColumnTemperatureRanges =  Map[
		Module[
			{guardColumn,guardColumnModelPacket},
			guardColumn=Switch[#,
				ObjectP[Model[Item, Cartridge, Column]],
				Lookup[fetchPacketFromCacheHPLC[Download[#,Object],cache],PreferredGuardColumn],
				ObjectP[Object[Item, Cartridge, Column]],
				Lookup[fetchModelPacketFromCacheHPLC[Download[#,Object],cache],PreferredGuardColumn],
				_,
				#
			];
			guardColumnModelPacket=Switch[guardColumn,
				ObjectP[Model],
				fetchPacketFromCacheHPLC[guardColumn, cache],
				ObjectP[],
				fetchModelPacketFromCacheHPLC[guardColumn, cache],
				_,
				Null
			];
			If[!NullQ[guardColumnModelPacket],
				Lookup[guardColumnModelPacket, {MinTemperature, MaxTemperature}],
				Nothing
			]
		]&,
		resolvedColumnSelector[[All,1]]
	];

	(* Get the most restrictive min and max range for the columns *)
	compatibleGuardColumnTemperatureRange = Which[
		NullQ[compatibleGuardColumnTemperatureRanges]||MatchQ[compatibleGuardColumnTemperatureRanges,{}],
		Null,
		NullQ[compatibleGuardColumnTemperatureRanges[[All, 1]]],
		{
			Null,
			Min[DeleteCases[compatibleGuardColumnTemperatureRanges[[All, 2]],Null]]
		},
		NullQ[compatibleGuardColumnTemperatureRanges[[All, 2]]],
		{
			Max[DeleteCases[compatibleGuardColumnTemperatureRanges[[All, 1]],Null]],
			Null
		},
		True,
		{
			Max[DeleteCases[compatibleGuardColumnTemperatureRanges[[All, 1]],Null]],
			Min[DeleteCases[compatibleGuardColumnTemperatureRanges[[All, 2]],Null]]
		}
	];

	(* Options which reference temperatures *)
	columnTemperatureOptions = {
		ColumnTemperature,
		StandardColumnTemperature,
		BlankColumnTemperature,
		ColumnPrimeTemperature,
		ColumnFlushTemperature
	};

	(* Fetch any specified temperatures from the standalone options and the InjectionTable *)
	specifiedColumnTemperatures = Join[
		Cases[Flatten[{Lookup[roundedOptionsAssociation,columnTemperatureOptions]}],TemperatureP],
		If[injectionTableSpecifiedQ,
			Cases[injectionTableLookup[[All,5]], TemperatureP],
			{}
		]
	];

	(* Extract any specified temperatures for each option that is not within the Column's compatible range *)
	incompatibleColumnTemperatures = Which[
		MatchQ[compatibleColumnTemperatureRange, {TemperatureP, TemperatureP}], Cases[specifiedColumnTemperatures, Except[RangeP @@ compatibleColumnTemperatureRange]],
		MatchQ[compatibleColumnTemperatureRange, {Null, TemperatureP}], Cases[specifiedColumnTemperatures, GreaterP @@ (compatibleColumnTemperatureRange[[2]])],
		MatchQ[compatibleColumnTemperatureRange, {TemperatureP, Null}], Cases[specifiedColumnTemperatures, LessP @@ (compatibleColumnTemperatureRange[[1]])],
		True, {}
	];

	(* Extract any specified temperatures for each option that is not within the GuardColumn's compatible range *)
	incompatibleGuardColumnTemperatures = Which[
		MatchQ[compatibleGuardColumnTemperatureRange, {TemperatureP, TemperatureP}], Cases[specifiedColumnTemperatures, Except[RangeP @@ compatibleGuardColumnTemperatureRange]],
		MatchQ[compatibleGuardColumnTemperatureRange, {Null, TemperatureP}], Cases[specifiedColumnTemperatures, GreaterP @@ (compatibleGuardColumnTemperatureRange[[2]])],
		MatchQ[compatibleGuardColumnTemperatureRange, {TemperatureP, Null}], Cases[specifiedColumnTemperatures, LessP @@ (compatibleGuardColumnTemperatureRange[[1]])],
		True, {}
	];

	(* Throw warning if column temperatures are incompatible *)
	columnTemperatureTests = If[Length[incompatibleColumnTemperatures] > 0,
		If[messagesQ && !engineQ,
			Message[Warning::IncompatibleColumnTemperature, incompatibleColumnTemperatures, "Column", ObjectToString[DeleteDuplicates[Cases[Download[Flatten[resolvedColumnSelector[[All,{4,6,7}]]],Object],ObjectP[]]]], compatibleColumnTemperatureRange[[1]], compatibleColumnTemperatureRange[[2]]]
		];
		warningOrNull["If Column and Column Temperature in InjectionTable are specified, all specified column temperatures are within the column's MinTemperature/MaxTemperature range:", False],
		warningOrNull["If Column and Column Temperature in InjectionTable are specified, all specified column temperatures are within the column's MinTemperature/MaxTemperature range:", True]
	];

	(* Throw warning if guard column temperatures are incompatible *)
	guardColumnTemperatureTests = If[Length[incompatibleGuardColumnTemperatures] > 0,
		If[messagesQ && !engineQ,
			Message[Warning::IncompatibleColumnTemperature, incompatibleGuardColumnTemperatures, "Guard Column", ObjectToString[DeleteDuplicates[Cases[Download[resolvedColumnSelector[[All,1]],Object],ObjectP[]]]], compatibleGuardColumnTemperatureRange[[1]], compatibleGuardColumnTemperatureRange[[2]]]
		];
		warningOrNull["If GuardColumn and Column Temperature in InjectionTable are specified, all specified column temperatures are within the column's MinTemperature/MaxTemperature range:", False],
		warningOrNull["If GuardColumn and Column Temperature in InjectionTable are specified, all specified column temperatures are within the column's MinTemperature/MaxTemperature range:", True]
	];

	(* Calculate column volumes for each column configuration inside the column selector, used to resolve the ColumnStorageDuration and the ColumnPrimeGradient *)
	columnConfigurationVolumes = Map[
		Function[
			{individualColumnSelector},
			Total[
				Map[
					Module[
						{dimensions,length,diameter},
						dimensions = Which[
							MatchQ[#, ObjectP[Model]],
							Lookup[fetchPacketFromCacheHPLC[#, cache], Dimensions, {0Millimeter, 0Millimeter, 0Millimeter}] /. {Null -> {0Millimeter, 0Millimeter, 0Millimeter}},

							MatchQ[#, ObjectP[Object]],
							Lookup[fetchModelPacketFromCacheHPLC[#, cache], Dimensions, {0Millimeter, 0Millimeter, 0Millimeter}] /. {Null -> {0Millimeter, 0Millimeter, 0Millimeter}},

							True,
							{0Millimeter, 0Millimeter, 0Millimeter}
						];
						length=Max[dimensions];
						diameter=Max[Most[Sort[dimensions]]];
						(* Get the volume of the column *)
						Round[Pi*((diameter/2)^2)*length,0.1Milliliter]
					]&,
					individualColumnSelector
				]
			]
		],
		resolvedColumnSelector
	];

	(*-- RESOLVE GRADIENT information --*)
	(* Resolve Gradient and related options *)
	(* For any specified Gradient values, get the tuples describing the gradient *)
	(* This will help us decide if BufferD is required *)
	specifiedGradients = Map[
		Switch[#,
			ObjectP[],
			Lookup[fetchPacketFromCacheHPLC[#, cache], Gradient],
			_List,
			#,
			_,
			Nothing
		]&,
		Join[
			(* Gradient from Gradient/StandardGradient/BlankGradient/ColumnPrimeGradient/ColumnFlushGradient options *)
			Join@@Map[
				Which[
					!MatchQ[#,_List],
						ToList[#],
					MatchQ[#,ListableP[Automatic]],
						ToList[#],
					(* If the option is a singleton Gradient of {{time,gradientA,gradientB,gradientC,gradientD,flowRate}..} or {{time,gradientA,gradientB,gradientC,gradientD,flowRate,dRIOpen}..}, not expanded to match index matching, wrap with a list *)
					MatchQ[#,binaryGradientP|gradientP],
						{#},
					MatchQ[#[[1]],_List]&&MatchQ[#[[All,1;;-2]],binaryGradientP|gradientP],
						{#},
					True,
						ToList[#]
				]&,
				Lookup[roundedOptionsAssociation, refractiveIndexGradientOptions]
			],
			If[injectionTableSpecifiedQ,
				injectionTableLookup[[All,-1]],
				{}
			]
		]
	];

	(* First get a semi-resolved Detector to help determine the default gradient - only get the most critical detector *)
	semiResolvedDetector = Which[
		MemberQ[ToList[Lookup[roundedOptionsAssociation, Detector]], MultiAngleLightScattering], MultiAngleLightScattering,
		MemberQ[ToList[Lookup[roundedOptionsAssociation, Detector]], DynamicLightScattering], DynamicLightScattering,
		MemberQ[ToList[Lookup[roundedOptionsAssociation, Detector]], RefractiveIndex], RefractiveIndex,
		MemberQ[ToList[Lookup[roundedOptionsAssociation, Detector]], pH], pH,
		MemberQ[ToList[Lookup[roundedOptionsAssociation, Detector]], Conductance], Conductance,
		MatchQ[Lookup[roundedOptionsAssociation, Detector], Automatic] && lightScatteringRequestedQ, MultiAngleLightScattering,
		MatchQ[Lookup[roundedOptionsAssociation, Detector], Automatic] && refractiveIndexRequestedQ, RefractiveIndex,
		MatchQ[Lookup[roundedOptionsAssociation, Detector], Automatic] && pHRequestedQ, pH,
		MatchQ[Lookup[roundedOptionsAssociation, Detector], Automatic] && conductivityRequestedQ, Conductance,
		True, Null
	];

	(* --- Analyte Gradient-related option resolution --- *)

	(* First get the injection table gradients *)
	injectionTableSampleRoundedGradients = If[injectionTableSpecifiedQ && !injectionTableSampleConflictQ,
		Cases[injectionTableLookup, {Sample, ___}][[All, 6]],
		(*otherwise just pad away with Automatics*)
		ConstantArray[Automatic, Length[mySamples]]
	];

	(* Helper to collapse gradient into single percentage value if the option is Automatic and all values are the same at each timepoint *)
	collapseGradient[gradient : ({{TimeP, PercentP | FlowRateP}...}|Null|RangeP[0 Percent,100 Percent])] := If[
		!NullQ[gradient] && !MatchQ[gradient,RangeP[0 Percent,100 Percent]] && (SameQ @@ (gradient[[All, 2]])),
		gradient[[1, 2]],
		gradient
	];

	{
		resolvedAnalyteGradients,
		resolvedGradientAs,
		resolvedGradientBs,
		resolvedGradientCs,
		resolvedGradientDs,
		resolvedFlowRates,
		resolvedGradients,
		gradientInjectionTableSpecifiedDifferentlyBool,
		invalidGradientCompositionBool,
		nonbinaryGradientBool,
		removedExtraBool,
		gradientAmbiguityBool,
		incorrectGradientOrderBool
	} = Transpose@MapThread[
		Function[
			{gradient, gradientA, gradientB, gradientC, gradientD, flowRate, refractiveIndexMethod, injectionTableGradient},
			Module[
				{analyteGradientOptionTuple, defaultedAnalyteFlowRate, analyteGradient,
				invalidGradientCompositionQ, resolvedGradientA, resolvedGradientB, resolvedGradientC, resolvedGradientD, resolvedFlowRate,
				resolvedGradient, semiResolvedGradientA, semiResolvedGradientC, semiResolvedGradientB, semiResolvedGradientD, totaledGradient,
				loadingStatusFromOption, loadingStatusForResolver, analyteGradientOptionTupleWithRILoading,
				protoAnalyteGradientOptionTuple, analyteGradientReturned,
				removedExtrasQ, nonbinaryGradientQ, gradientAmbiguityQ, incorrectGradientOrderQ},

				(* Check whether the specified gradient is a full tuple at the sub gradients (e.g. GradientB) are defined. we will warn about gradient ambiguity *)
				gradientAmbiguityQ = Which[
					(* This part only applies to the LCMS case where Gradient option does not have the last "Differential Refractive Index Reference Loading" entry *)
					MatchQ[gradient, binaryGradientP | gradientP],
					Or @@ MapThread[
						Function[{currentGradientShort, index},
							Switch[currentGradientShort,
								Automatic | Null, False,
								(* Check that the relevant gradient table column and the shortcut option are the same *)
								(* Note that for binaryGradientP, GradientC and GradientD do not exist so they should never enter the branches here *)
								UnitsP[Percent],
								!And[
									(* only one gradient shortcut value *)
									MatchQ[
										Length[DeleteDuplicates[gradient[[All, index]]]],
										1
									],
									(* The Gradient's shortcut value is the same as the Gradient value *)
									EqualQ[
										gradient[[1, index]],
										currentGradientShort
									]
								],
								{{_, UnitsP[Percent]}..},
								Not[
									MatchQ[
										SortBy[gradient[[All, {1, index}]],First],
										SortBy[currentGradientShort,First]
									]
								],
								_, False
							]
						],
						{
							{gradientA, gradientB, gradientC, gradientD, flowRate},
							(* The corresponding positions of the value in Gradient *)
							{2,3,4,5,-1}
						}
					],
					(* This part is for HPLC's gradient with "Differential Refractive Index Reference Loading" *)
					!MatchQ[gradient, Automatic | ObjectP[] | binaryGradientP | gradientP],
					And[
						MatchQ[gradient[[All, 1 ;; -2]], binaryGradientP | gradientP],
						Or @@ MapThread[
							Function[{currentGradientShort, index},
								Switch[currentGradientShort,
									Automatic | Null, False,
									(* Check that the relevant gradient table column and the shortcut option are the same *)
									(* Note that for binaryGradientP, GradientC and GradientD do not exist so they should never enter the branches here *)
									UnitsP[Percent],
									!And[
										(* only one gradient shortcut value *)
										MatchQ[
											Length[DeleteDuplicates[gradient[[All, index]]]],
											1
										],
										(* The Gradient's shortcut value is the same as the Gradient value *)
										EqualQ[
											gradient[[1, index]],
											currentGradientShort
										]
									],
									{{_, UnitsP[Percent]}..},
									Not[
										MatchQ[
											SortBy[gradient[[All, {1, index}]],First],
											SortBy[currentGradientShort,First]
										]
									],
									_, False
								]
							],
							{
								{gradientA, gradientB, gradientC, gradientD, flowRate},
								(* The corresponding positions of the value in Gradient *)
								{2,3,4,5,-2}
							}
						]
					],
					True, False
				];


				(* Check whether both gradient and the injection table are specified and are the same object *)
				gradientInjectionTableSpecifiedDifferentlyQ = If[MatchQ[gradient, ObjectP[Object[Method, Gradient]]] && MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]],
					Not[MatchQ[Download[gradient, Object], Download[injectionTableGradient, Object]]],
					False
				];

				(* If Gradient option is an object, pull Gradient value from packet *)
				(* We only pull the ABCD columns from it and get rid of the Refractive Index Reference Loading status if needed *)
				protoAnalyteGradientOptionTuple = Which[
					MatchQ[gradient, ObjectP[Object[Method, Gradient]]], Part[Lookup[fetchPacketFromCache[Download[gradient, Object], cache], Gradient], All, {1, 2, 3, 4, 5, -1}],
					MatchQ[gradient, Automatic] && MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]], Part[Lookup[fetchPacketFromCache[Download[injectionTableGradient, Object], cache], Gradient], All, {1, 2, 3, 4, 5, -1}],
					(* If we just have two columns, expand to 4 *)
					!MatchQ[gradient, Automatic] && MatchQ[gradient[[All, 1 ;; -2]], binaryGradientP], Transpose@Nest[Insert[#, Repeat[0 Percent, Length[gradient]], -3] &, Transpose@(gradient[[All, 1 ;; -2]]), 2],
					MatchQ[gradient, Automatic], gradient,
					(* Get rid of reference loading status if it is from HPLC option *)
					MatchQ[gradient, {{TimeP, PercentP, PercentP, PercentP, PercentP, FlowRateP, Alternatives[Open, Closed, None, Automatic]}...}], gradient[[All, 1 ;; -2]],
					(* Keep Gradient as it is if our resolver is called from another experiment (LCMS) or it is automatic *)
					True, gradient
				];

				(* If the flow rate was changed, we update that *)
				(* Note that we skip this step if FlowRate is specified as {time, flowRate} tuples and the time points of the option do not match the Gradient option *)
				analyteGradientOptionTuple = Which[
					MatchQ[flowRate, Automatic],
					protoAnalyteGradientOptionTuple,
					MatchQ[flowRate, FlowRateP],
					ReplacePart[protoAnalyteGradientOptionTuple, Table[{x, -1} -> flowRate, {x, 1, Length[protoAnalyteGradientOptionTuple]}]],
					And[
						MatchQ[flowRate,{{TimeP,FlowRateP}..}],
						!MatchQ[protoAnalyteGradientOptionTuple,Automatic],
						MatchQ[protoAnalyteGradientOptionTuple[[All,1]],flowRate[[All,1]]]
					],
					ReplacePart[
						protoAnalyteGradientOptionTuple,
						AssociationThread[
							{#,-1}&/@Range[Length[protoAnalyteGradientOptionTuple]],
							flowRate[[All,2]]
						]
					],
					True,
					protoAnalyteGradientOptionTuple
				];

				(* Default FlowRate to option value, gradient tuple values, or the pre-calculated optimal flow rate for the column *)
				(* Note that it's ok to have this flow rate either match FlowRateP, or be a list of pairs of time and flow rate since resolveGradient can handle either *)
				(* Add a 0 Minute point if not already provided *)
				defaultedAnalyteFlowRate = Which[
					MatchQ[flowRate, FlowRateP], flowRate,
					MatchQ[flowRate, {{TimeP,FlowRateP}..}],
					DeleteDuplicatesBy[
						Append[flowRate, {0 Minute, flowRate[[1,2]]}],
						First[#] * 1.&
					],
					MatchQ[analyteGradientOptionTuple, gradientP], analyteGradientOptionTuple[[All, {1, -1}]],
					True, 1 Milliliter / Minute
				];

				(* This part is to semi-resolve gradient for binary pumps. If user does not give use the gradients for A/C or B/D, we want to make it possible to be binary *)
				(* If more than 2 gradient options are specified, we do not want to do the binary settings as we may actually lead to a non-100% sum *)
				(* If gradient C is set, we want A to go to 0 *)
				semiResolvedGradientA = If[MatchQ[{gradientA, gradientC, gradientB, gradientD}, {Automatic, Except[Automatic], Automatic, Automatic}],
					Which[
						MatchQ[gradientC, GreaterP[0 Percent]], 0 Percent,
						(* Make the same as gradient C and replace out the right side with zeros *)
						MemberQ[gradientC, {_, GreaterP[0 Percent]}],
						(* We also want to add a starting point, if not there *)
						DeleteDuplicatesBy[
							Append[ReplacePart[gradientC, Table[{x, 2} -> 0 Percent, {x, 1, Length[gradientC]}]], {0 Minute, 0 Percent}],
							First[#] * 1.&
						],
						True, gradientA
					],
					gradientA
				];
				(* If gradient A is set, we want C to go to 0 *)
				semiResolvedGradientC = If[MatchQ[{gradientC, gradientA, gradientB, gradientD}, {Automatic, Except[Automatic], Automatic, Automatic}],
					Which[
						MatchQ[gradientA, GreaterP[0 Percent]], 0 Percent,
						(* Make the same as gradient A and replace out the right side with zeros*)
						MemberQ[gradientA, {_, GreaterP[0 Percent]}],
						DeleteDuplicatesBy[
							Append[ReplacePart[gradientA, Table[{x, 2} -> 0 Percent, {x, 1, Length[gradientA]}]], {0 Minute, 0 Percent}],
							First[#] * 1.&
						],
						True, gradientC
					],
					gradientC
				];

				(* If gradient D is set, we want B to go to 0 *)
				semiResolvedGradientB = If[MatchQ[{gradientB, gradientD, gradientA, gradientC}, {Automatic, Except[Automatic], Automatic, Automatic}],
					Which[
						MatchQ[gradientD, GreaterP[0 Percent]], 0 Percent,
						(* Make the same as gradient D and replace out the right side with zeros *)
						MemberQ[gradientD, {_, GreaterP[0 Percent]}],
						DeleteDuplicatesBy[
							Append[ReplacePart[gradientD, Table[{x, 2} -> 0 Percent, {x, 1, Length[gradientD]}]], {0 Minute, 0 Percent}],
							First[#] * 1.&
						],
						True, gradientB
					],
					gradientB
				];
				(* If gradient B is set, we want D to go to 0 *)
				semiResolvedGradientD = If[MatchQ[{gradientD, gradientB, gradientA, gradientC}, {Automatic, Except[Automatic], Automatic, Automatic}],
					Which[
						MatchQ[gradientB, GreaterP[0 Percent]], 0 Percent,
						(* Make the same as gradient B and replace out the right side with zeros*)
						MemberQ[gradientB, {_, GreaterP[0 Percent]}],
						DeleteDuplicatesBy[
							Append[ReplacePart[gradientB, Table[{x, 2} -> 0 Percent, {x, 1, Length[gradientB]}]], {0 Minute, 0 Percent}],
							First[#] * 1.&
						],
						True, gradientD
					],
					gradientD
				];

				(* A special preparation before resolving gradient is about the Refractive Index detector*)
				(* If DifferentialRefractiveIndex is requested, the reference loading needs to be closed in the gradient process. We resolve it to always closed to use the prime solution as reference. User has the ability to change it *)
				(* Note that unless user asks for dRI, we always try to resolve to RefractiveIndex *)
				loadingStatusFromOption = Which[
					(* Set to True /Closed for DRI *)
					MatchQ[refractiveIndexMethod, DifferentialRefractiveIndex], Closed,
					(* If RI detector is requested, we can set it to Open for RefractiveIndex method *)
					refractiveIndexRequestedQ, Open,
					(* Otherwise set to None *)
					True, None
				];

				loadingStatusForResolver = Which[
					(* Get the reference loading status from the provided gradient method object *)
					MatchQ[gradient, ObjectP[Object[Method, Gradient]]] && !MatchQ[Lookup[fetchPacketFromCache[Download[gradient, Object], cache], RefractiveIndexReferenceLoading], {}], Lookup[fetchPacketFromCache[Download[gradient, Object], cache], RefractiveIndexReferenceLoading],
					MatchQ[gradient, Automatic] && MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]] && !MatchQ[Lookup[fetchPacketFromCache[Download[injectionTableGradient, Object], cache], RefractiveIndexReferenceLoading], {}], Lookup[fetchPacketFromCache[Download[injectionTableGradient, Object], cache], RefractiveIndexReferenceLoading],
					(* Get the reference loading status from the provided gradient option values *)
					!MatchQ[gradient, Automatic | ObjectP[Object[Method, Gradient]]], gradient[[All, -1]] /. {Automatic -> loadingStatusFromOption},
					(* Otherwise go with the loading status from the detector *)
					MatchQ[analyteGradientOptionTuple, gradientP], ConstantArray[loadingStatusFromOption, Length[analyteGradientOptionTuple]],
					True, loadingStatusFromOption
				];

				(* Get our required refractive index reference loading information, if provided *)
				analyteGradientOptionTupleWithRILoading = If[MatchQ[analyteGradientOptionTuple, gradientP],
					MapThread[
						Append[#1, #2]&,
						{analyteGradientOptionTuple, loadingStatusForResolver}
					],
					Automatic
				];

				(* Finally run our helper resolution function *)
				analyteGradientReturned = Which[
					(* If the analyte gradient is already fully informed, then we go with that*)
					MatchQ[analyteGradientOptionTuple, gradientP], analyteGradientOptionTupleWithRILoading,
					(* Everything is Automatic *)
					MatchQ[{analyteGradientOptionTuple, semiResolvedGradientA, semiResolvedGradientB, semiResolvedGradientC, semiResolvedGradientD}, {(Null | Automatic)..}],
					resolveGradient[
						(* This handles the case where FlowRate is specified *)
						defaultGradient[defaultedAnalyteFlowRate, SeparationMode -> resolvedSeparationMode, Detector -> semiResolvedDetector],
						semiResolvedGradientA,
						semiResolvedGradientB,
						semiResolvedGradientC,
						semiResolvedGradientD,
						defaultedAnalyteFlowRate,
						(* We no longer have GradientStart, GradientEnd, GradientDuration, FlushTime and EquilibrationTime options in HPLC to use only the formal Gradient options. Give Null to all these in resolveGradient *)
						Null,
						Null,
						Null,
						Null,
						Null,
						loadingStatusForResolver
					],
					True,
					resolveGradient[
						analyteGradientOptionTuple,
						semiResolvedGradientA,
						semiResolvedGradientB,
						semiResolvedGradientC,
						semiResolvedGradientD,
						defaultedAnalyteFlowRate,
						(* We no longer have GradientStart, GradientEnd, GradientDuration, FlushTime and EquilibrationTime options in HPLC to use only the formal Gradient options. Give Null to all these in resolveGradient *)
						Null,
						Null,
						Null,
						Null,
						Null,
						loadingStatusForResolver
					]
				];

				(* Remove duplicate entries if need be *)
				analyteGradient = DeleteDuplicatesBy[analyteGradientReturned, First[# * 1.] &];

				(* If we have to remove the extra, note that *)
				removedExtrasQ = If[MatchQ[analyteGradientOptionTuple, gradientP],
					(* For LCMS gradient case (input is gradientP already) The returned gradient will have the Reference Loading at the end so we need to remove it for comparing to analyteGradientOptionTuple *)
					!MatchQ[1. * analyteGradientOptionTuple, 1. * (Most[#]& /@ analyteGradient)],
					!MatchQ[1. * analyteGradientReturned, 1. * analyteGradient]
				];

				(* Make sure that the gradient is in the correct order *)
				incorrectGradientOrderQ = Not@OrderedQ[analyteGradient[[All, 1]]];

				(* Check whether the gradient composition adds up to 100 % *)
				invalidGradientCompositionQ = Not[AllTrue[analyteGradient, (Total[#[[{2, 3, 4, 5}]]] == 100 Percent)&]];

				(* Now resolve all of the individual gradients and flow rate *)
				resolvedGradientA = If[MatchQ[gradientA, Automatic],
					collapseGradient[analyteGradient[[All, {1, 2}]]],
					gradientA
				];
				resolvedGradientB = If[MatchQ[gradientB, Automatic],
					collapseGradient[analyteGradient[[All, {1, 3}]]],
					gradientB
				];
				resolvedGradientC = If[MatchQ[gradientC, Automatic],
					collapseGradient[analyteGradient[[All, {1, 4}]]],
					gradientC
				];
				resolvedGradientD = If[MatchQ[gradientD, Automatic],
					collapseGradient[analyteGradient[[All, {1, 5}]]],
					gradientD
				];
				resolvedFlowRate = If[MatchQ[flowRate, Automatic],
					collapseGradient[analyteGradient[[All, {1, 6}]]],
					flowRate
				];

				(* Finally resolve the gradient *)
				resolvedGradient = Which[
					(* Keep whatever user gives us *)
					MatchQ[gradient, Except[Automatic]], gradient,
					(* Otherwise if the gradient is automatic and the injection table is set, should use that *)
					MatchQ[gradient, Automatic] && MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]], Download[injectionTableGradient, Object],
					(* Otherwise use the resolved tuple we got *)
					(* For the above two cases, the provided value should match the resolved analyteGradient *)
					True, analyteGradient
				];

				(* Total the gradient so that we can do our non-binary gradient check *)
				totaledGradient = Total[analyteGradient][[2 ;; 5]];

				(* Check whether the gradient is non-binary, meaning that any of the tuples have both A and C or both B and D *)
				(* Note that we are probably over-restrictive here since in theory, we can allow A/B at one time point and C/D at later time point. However, gradient actually gradually change over time so it is more complicated to calculate more percentage changes during the entire gradient. We restrict that only one of the binary gradients to be used for one single injection *)
				nonbinaryGradientQ = MatchQ[totaledGradient, {GreaterP[0 Percent], _, GreaterP[0 Percent], _} | {_, GreaterP[0 Percent], _, GreaterP[0 Percent]}];

				(* Return everything *)
				{
					analyteGradient,
					resolvedGradientA,
					resolvedGradientB,
					resolvedGradientC,
					resolvedGradientD,
					resolvedFlowRate,
					resolvedGradient,
					gradientInjectionTableSpecifiedDifferentlyQ,
					invalidGradientCompositionQ,
					nonbinaryGradientQ,
					removedExtrasQ,
					gradientAmbiguityQ,
					incorrectGradientOrderQ
				}
			]
		],
		Append[
			Lookup[roundedOptionsAssociation,
				{
					Gradient,
					GradientA,
					GradientB,
					GradientC,
					GradientD,
					FlowRate,
					RefractiveIndexMethod
				}
			],
			injectionTableSampleRoundedGradients
		]
	];

	(* Get all of the injection table gradients *)
	(* Standard *)
	injectionTableStandardGradients = If[standardExistsQ && injectionTableSpecifiedQ,
		(* Grab the gradients column of the injection table for standard samples*)
		(* We have to adjust the size in case there was a bad specification in the injection table *)
		PadRight[Cases[injectionTableLookup, {Standard, ___}][[All, 6]], Length[ToList[resolvedStandard]], Automatic],
		(* Otherwise just Automatic *)
		If[standardExistsQ,
			ConstantArray[Automatic, Length[ToList[resolvedStandard]]],
			Null
		]
	];

	(* Blank *)
	injectionTableBlankGradients = If[blankExistsQ && injectionTableSpecifiedQ,
		(* Grab the gradients column of the injection table for blank samples*)
		(* We have to adjust the size in case there was a bad specification in the injection table *)
		PadRight[Cases[injectionTableLookup, {Blank, ___}][[All, 6]], Length[ToList[resolvedBlank]], Automatic],
		(*otherwise, just pad automatics*)
		If[blankExistsQ,
			ConstantArray[Automatic, Length[ToList[resolvedBlank]]],
			Null
		]
	];

	(* The column prime and column flush are a little more tricky because it depends on the specific column. we have to associate each one separately with the injection table *)
	(* Expand the column flush and column prime gradient related options for resolution purpose *)
	expandedColumnGradientOptions = If[!columnSelectorQ,
		Association[# -> {}& /@ columnSelectorOptions],
		(* Here we change the resolved ColumnSelector to Null for success index matching expanding. It seems when ObjectP[] is resolved as the first element - GuardColumn of the ColumnSelector, ExpandIndexMatchedInputs is confused with the length. *)
		ReplaceRule[
			Last[ExpandIndexMatchedInputs[
				ExperimentHPLC,
				{mySamples},
				Normal@Append[
					KeyTake[roundedOptionsAssociation, columnSelectorOptions],
					ColumnSelector -> resolvedColumnSelector /. {x : ObjectP[] -> Null}
				],
				Messages -> False
			]],
			ColumnSelector -> resolvedColumnSelector
		]
	];

	(* ColumnRefreshFrequency has been expanded with ColumnSelector and we decide based on if column is used or not *)
	resolvedColumnRefreshFrequency = If[columnSelectorQ,
		Lookup[expandedColumnGradientOptions, ColumnRefreshFrequency]/.{Automatic->GradientChange},
		Lookup[expandedColumnGradientOptions, ColumnRefreshFrequency]/.{Automatic->Null}
	];

	(* Check if we're doing column prime or flush based on the refresh frequency or injection table*)
	columnPrimeQ = Not[
		(* There's no column prime in the following situations *)
		Or[
			MatchQ[resolvedColumnRefreshFrequency, ListableP[None | Last]],
			NullQ[resolvedColumnRefreshFrequency] && !injectionTableSpecifiedQ,
			If[injectionTableSpecifiedQ, !MemberQ[injectionTableLookup, {ColumnPrime, ___}], False],
			!columnSelectorQ
		]
	];

	columnFlushQ = Not[
		(* There's no column flush in the following situations *)
		Or[
			MatchQ[resolvedColumnRefreshFrequency, ListableP[None | First]],
			NullQ[resolvedColumnRefreshFrequency] && !injectionTableSpecifiedQ,
			If[injectionTableSpecifiedQ, !MemberQ[injectionTableLookup, {ColumnFlush, ___}], False],
			!columnSelectorQ
		]
	];

	(* First dereference the injection column and gradient option to objects *)
	injectionTableObjectified = If[injectionTableSpecifiedQ,
		MapThread[
			Function[{type, columnPosition, gradient},
				{
					type,
					columnPosition,
					If[MatchQ[gradient, ObjectP[]], Download[gradient, Object], gradient]
				}
			],
			Transpose@(injectionTableLookup[[All, {1, 4, 6}]])]
	];

	(* Do the same for the resolved ColumnSelector*)
	columnSelectorObjectified = If[columnSelectorQ,
		resolvedColumnSelector/.{x : ObjectP[] :> Download[x, Object]},
		resolvedColumnSelector
	];

	(* Grab the gradients from the injection table if they're defined *)
	(* Otherwise, pad with Automatics *)
	{
		injectionTableColumnPrimeGradients,
		injectionTableColumnFlushGradients,
		multiplePrimeSameColumnBool,
		multipleFlushSameColumnBool
	} = If[columnSelectorQ && injectionTableSpecifiedQ,
		(* Both ColumnSelector and InjectionTable exist *)
		(* Map through each element in the column selector *)
		Transpose@Map[
			Function[
				{currentColumn},
				Module[
					{columnPrimeResult, columnFlushResult, bestColumnPrimeGradient, bestColumnFlushGradient},
					(* See what column prime options we have, using the Column Position from ColumnSelector *)
					columnPrimeResult = Cases[injectionTableObjectified, {ColumnPrime, currentColumn[[1]], _}][[All, 3]];
					(* Likewise for flush *)
					columnFlushResult = Cases[injectionTableObjectified, {ColumnFlush, currentColumn[[1]], _}][[All, 3]];
					(* Find the best column prime gradient*)
					(* If there is a gradient object, we take that; otherwise, we go automatic or Null if there is nothing *)
					bestColumnPrimeGradient = If[Length[columnPrimeResult] > 0, FirstOrDefault[Cases[columnPrimeResult, ObjectP[]], Automatic]];
					(* Same for the flush *)
					bestColumnFlushGradient = If[Length[columnFlushResult] > 0, FirstOrDefault[Cases[columnFlushResult, ObjectP[]], Automatic]];
					(* We also check whether the same column is defined multiple times for different gradients *)

					(* Return the best candidates *)

					{
						bestColumnPrimeGradient,
						bestColumnFlushGradient,
						(*  Also make sure that multiple different flush/prime gradients weren't defined for the same columns *)
						Length[DeleteDuplicates@DeleteCases[columnPrimeResult, Automatic]] > 1,
						Length[DeleteDuplicates@DeleteCases[columnFlushResult, Automatic]] > 1
					}
				]
			],
			columnSelectorObjectified
		],
		If[columnSelectorQ,
			(* If no injection table, pad automatics *)
			Join[
				ConstantArray[ConstantArray[Automatic, Length[ToList[resolvedColumnSelector]]], 2],
				{{False}, {False}}
			],
			(* With no columns, nothing to worry about *)
			{Null, Null, {False}, {False}}
		]
	];

	(* Throw errors for multiple column prime/flush gradients *)

	multiplePrimeSameColumnQ = Or @@ multiplePrimeSameColumnBool;
	multipleFlushSameColumnQ = Or @@ multipleFlushSameColumnBool;

	multipleGradientsColumnPrimeFlushOptions = If[Or[multiplePrimeSameColumnQ, multipleFlushSameColumnQ],
		If[messagesQ, Message[Error::InjectionTableColumnGradientConflict]];
		{InjectionTable},
		{}
	];

	multipleGradientsColumnPrimeFlushTest = If[Or[multiplePrimeSameColumnQ, multipleFlushSameColumnQ],
		testOrNull["If InjectionTable is defined, the ColumnPrime and ColumnFlush entries have the same gradient for each column:", False],
		testOrNull["If InjectionTable is defined, the ColumnPrime and ColumnFlush entries have the same gradient for each column:", True]
	];

	(* Resolve ColumnStorageBuffer so that we can decide the final flush gradient *)
	(* Get the Storage Buffers from the Model Packet of the columns *)
	(* We are going to have a list of all storage buffers for all columns in this position *)
	modelColumnStorageBuffers = If[columnSelectorQ,
		Map[
			Function[
				{columnTuple},
				Module[
					{allColumns},
					allColumns=Cases[columnTuple,ObjectP[]];
					Map[
						If[MatchQ[#,ObjectP[Model]],
							Download[Lookup[fetchPacketFromCache[#, cache], StorageBuffer,Null],Object],
							(* Object *)
							Download[Lookup[fetchModelPacketFromCacheHPLC[#, cache], StorageBuffer,Null],Object]
						]&,
						allColumns
					]
				]
			],
			resolvedColumnSelector
		],
		{}
	];

	(* Select the first storage buffer that matches any specified buffer or just use BufferA. Map through all column tuples *)
	semiResolvedColumnStorageBuffers = MapThread[
		Which[
			!MatchQ[#2,Automatic],
			FirstOrDefault[
				Intersection[
					{Download[#2,Object]},
					Download[
						DeleteCases[
							Lookup[roundedOptionsAssociation,{BufferA,BufferB,BufferC,BufferD}],
							Automatic|Null
						],
						Object
					]
				],
				(* Default to BufferA, and we will fill in the sample model later *)
				BufferA
			],
			NullQ[#],
			(* Default to BufferA, and we will fill in the sample model later *)
			BufferA,
			True,
			FirstOrDefault[
				Intersection[
					Cases[#,ObjectP[]],
					Download[
						DeleteCases[
							Lookup[roundedOptionsAssociation,{BufferA,BufferB,BufferC,BufferD}],
							Automatic|Null
						],
						Object
					]
				],
				(* Default to BufferA, and we will fill in the sample model later *)
				BufferA
			]
		]&,
		{
			modelColumnStorageBuffers,
			Lookup[expandedColumnGradientOptions,ColumnStorageBuffer]
		}
	];

	(* Get the buffer letter for semiResolvedColumnStorageBuffers *)
	semiResolvedColumnStorageBufferPositions = Map[
		FirstOrDefault[
			PickList[
				{BufferA,BufferB,BufferC,BufferD},
				Lookup[roundedOptionsAssociation,{BufferA,BufferB,BufferC,BufferD}],
				ObjectP[#]
			],
			BufferA
		]&,
		semiResolvedColumnStorageBuffers
	];

	(* Now resolve all of the other gradients *)
	{
		{
			resolvedStandardAnalyticalGradients,
			resolvedStandardGradientAs,
			resolvedStandardGradientBs,
			resolvedStandardGradientCs,
			resolvedStandardGradientDs,
			resolvedStandardFlowRates,
			resolvedStandardGradients,
			standardGradientInjectionTableSpecifiedDifferentlyBool,
			standardInvalidGradientCompositionBool,
			standardNonbinaryGradientBool,
			removedExtraStandardBool,
			standardGradientAmbiguityBool,
			standardIncorrectGradientOrderBool,
			(* This will be Null since this concept applies to column prime only *)
			standardColumnEquilibrationDurations
		},
		{
			resolvedBlankAnalyticalGradients,
			resolvedBlankGradientAs,
			resolvedBlankGradientBs,
			resolvedBlankGradientCs,
			resolvedBlankGradientDs,
			resolvedBlankFlowRates,
			resolvedBlankGradients,
			blankGradientInjectionTableSpecifiedDifferentlyBool,
			blankInvalidGradientCompositionBool,
			blankNonbinaryGradientBool,
			removedExtraBlankBool,
			blankGradientAmbiguityBool,
			blankIncorrectGradientOrderBool,
			(* This will be Null since this concept applies to column prime only *)
			blankColumnEquilibrationDurations
		},
		{
			resolvedColumnPrimeAnalyticalGradients,
			resolvedColumnPrimeGradientAs,
			resolvedColumnPrimeGradientBs,
			resolvedColumnPrimeGradientCs,
			resolvedColumnPrimeGradientDs,
			resolvedColumnPrimeFlowRates,
			resolvedColumnPrimeGradients,
			columnPrimeGradientInjectionTableSpecifiedDifferentlyBool,
			columnPrimeInvalidGradientCompositionBool,
			columnPrimeNonbinaryGradientBool,
			removedExtraColumnPrimeGradientBool,
			columnPrimeGradientAmbiguityBool,
			columnPrimeIncorrectGradientOrderBool,
			columnPrimeColumnEquilibrationDurations
		},
		{
			resolvedColumnFlushAnalyticalGradients,
			resolvedColumnFlushGradientAs,
			resolvedColumnFlushGradientBs,
			resolvedColumnFlushGradientCs,
			resolvedColumnFlushGradientDs,
			resolvedColumnFlushFlowRates,
			resolvedColumnFlushGradients,
			columnFlushGradientInjectionTableSpecifiedDifferentlyBool,
			columnFlushInvalidGradientCompositionBool,
			columnFlushNonbinaryGradientBool,
			removedExtraColumnFlushGradientBool,
			columnFlushGradientAmbiguityBool,
			columnFlushIncorrectGradientOrderBool,
			(* This will be Null since this concept applies to column prime only *)
			columnFlushColumnEquilibrationDurations
		}
	} = Map[
		Function[
			{entry},
			Module[
				{
					gradientAs, gradientBs, gradientCs, gradientDs, gradients, flowRates, injectionTableGradients, type,
					entryRefractiveIndexLoadingMethods, existsQ,storageBuffers, columnVolumes,
					processedInjectionTableGradients
				},

				(* Split up the entry variable *)
				{
					gradientAs,
					gradientBs,
					gradientCs,
					gradientDs,
					gradients,
					flowRates,
					entryRefractiveIndexLoadingMethods,
					injectionTableGradients,
					type,
					existsQ,
					storageBuffers,
					columnVolumes
				} = entry;

				(* Process the injectionTableGradients to make sure it matches the length of the other options, in case there are conflicts *)
				processedInjectionTableGradients = If[SameLengthQ[injectionTableGradients, gradients] || !existsQ,
					injectionTableGradients,
					PadRight[injectionTableGradients, Length[gradients], Automatic]
				];

				(* First check whether these options need to be resolved, we Null anything if the type does not exist *)
				If[!existsQ,
					(* In which case, we return all nulls and empties *)
					(* Only exception is to calculate columnEquilibrationDuration for ColumnPrime case to pass down the information to later functions *)
					Module[
						{defaultedAnalyteFlowRate,columnEquilibrationDuration},
						(* Default FlowRate to the first flow rate for the sample *)
						defaultedAnalyteFlowRate = If[MatchQ[FirstOrDefault[resolvedFlowRates], FlowRateP],
							FirstOrDefault[resolvedFlowRates],
							1 Milliliter / Minute
						];

						columnEquilibrationDuration=Map[
							(* Calculate the amount of time it is required to flow 1.5* column volume's buffer through the column to help resolve column prime gradient *)
							Which[
								NullQ[#],
								Null,
								MatchQ[defaultedAnalyteFlowRate,FlowRateP],
								Round[Divide[UnitConvert[#, Milliliter], defaultedAnalyteFlowRate] * 1.5, 0.1Minute],
								True,
								Null
							]&,
							columnVolumes
						];
						ReplaceAll[
							{
								gradients,
								gradientAs,
								gradientBs,
								gradientCs,
								gradientDs,
								flowRates,
								gradients,
								{},
								{},
								{},
								{},
								{},
								{},
								columnEquilibrationDuration
							},
							{{Automatic} :> Null, Automatic :> Null, ObjectP[Object[Method]] :> Null}
						]
					],
					(* Otherwise, we'll resolve the gradient and map through *)
					Transpose@MapThread[
						Function[{gradientA, gradientB, gradientC, gradientD, gradient, flowRate, refractiveIndexMethod, injectionTableGradient, storageBuffer, columnVolume},
							Module[
								{gradientInjectionTableSpecifiedDifferentlyQ, analyteGradientOptionTuple, defaultedAnalyteFlowRate, columnEquilibrationDuration, defaultGradient, defaultStartingGradient, defaultEndingGradient,
								analyteGradient, invalidGradientCompositionQ, resolvedGradientA, resolvedGradientB, resolvedGradientC, resolvedGradientD,
								resolvedFlowRate, resolvedGradient, protoAnalyteGradientOptionTuple, semiResolvedGradientA, semiResolvedGradientC, semiResolvedGradientB, semiResolvedGradientD, totaledGradient,
								loadingStatusFromOption, loadingStatusForResolver, analyteGradientOptionTupleWithRILoading,
								nonbinaryGradientQ, analyteGradientReturned, removedExtrasQ, gradientAmbiguityQ, incorrectGradientOrderQ},

								(* Check whether the specified gradient is a full tuple at the sub gradients (e.g. GradientB) are defined. we will warn about gradient ambiguity *)
								gradientAmbiguityQ = Which[
									(* This part only applies to the LCMS case where Gradient option does not have the last "Differential Refractive Index Reference Loading" entry *)
									MatchQ[gradient, binaryGradientP | gradientP],
									Or @@ MapThread[
										Function[{currentGradientShort, index},
											Switch[currentGradientShort,
												Automatic | Null, False,
												(* Check that the relevant gradient table column and the shortcut option are the same *)
												(* Note that for binaryGradientP, GradientC and GradientD do not exist so they should never enter the branches here *)
												UnitsP[Percent],
												!And[
													(* only one gradient shortcut value *)
													MatchQ[
														Length[DeleteDuplicates[gradient[[All, index]]]],
														1
													],
													(* The Gradient's shortcut value is the same as the Gradient value *)
													EqualQ[
														gradient[[1, index]],
														currentGradientShort
													]
												],
												{{_, UnitsP[Percent]}..},
												Not[
													MatchQ[
														SortBy[gradient[[All, {1, index}]],First],
														SortBy[currentGradientShort,First]
													]
												],
												_, False
											]
										],
										{
											{gradientA, gradientB, gradientC, gradientD, flowRate},
											(* The corresponding positions of the value in Gradient *)
											{2,3,4,5,-1}
										}
									],
									!MatchQ[gradient, Automatic | ObjectP[] | binaryGradientP | gradientP],
									And[
										MatchQ[gradient[[All, 1 ;; -2]], binaryGradientP | gradientP],
										Or @@  MapThread[
											Function[{currentGradientShort, index},
												Switch[currentGradientShort,
													Automatic | Null, False,
													(* Check that the relevant gradient table column and the shortcut option are the same *)
													(* Note that for binaryGradientP, GradientC and GradientD do not exist so they should never enter the branches here *)
													UnitsP[Percent],
													!And[
														(* only one gradient shortcut value *)
														MatchQ[
															Length[DeleteDuplicates[gradient[[All, index]]]],
															1
														],
														(* The Gradient's shortcut value is the same as the Gradient value *)
														EqualQ[
															gradient[[1, index]],
															currentGradientShort
														]
													],
													{{_, UnitsP[Percent]}..},
													Not[
														MatchQ[
															SortBy[gradient[[All, {1, index}]],First],
															SortBy[currentGradientShort,First]
														]
													],
													_, False
												]
											],
											{
												{gradientA, gradientB, gradientC, gradientD, flowRate},
												(* The corresponding positions of the value in Gradient *)
												{2,3,4,5,-2}
											}
										]
									],
									True, False
								];

								(* Check whether both gradient and the injection table are specified and are the same object *)
								gradientInjectionTableSpecifiedDifferentlyQ = If[And[MatchQ[gradient, ObjectP[Object[Method, Gradient]]], MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]]],
									!MatchQ[Download[gradient, Object], ObjectP[Download[injectionTableGradient, Object]]],
									False
								];

								(* If Gradient option is an object, pull Gradient value from packet *)
								(* We only pull the ABCD columns from it and get rid of the Refractive Index Reference Loading status if needed *)
								protoAnalyteGradientOptionTuple = Which[
									MatchQ[gradient, ObjectP[Object[Method, Gradient]]], Part[Lookup[fetchPacketFromCache[Download[gradient, Object], cache], Gradient], All, {1, 2, 3, 4, 5, -1}],
									MatchQ[gradient, Automatic] && MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]], Part[Lookup[fetchPacketFromCache[Download[injectionTableGradient, Object], cache], Gradient], All, {1, 2, 3, 4, 5, -1}],
									(* If we just have two columns, expand to 4 *)
									!MatchQ[gradient, Automatic] && MatchQ[gradient[[All, 1 ;; -2]], binaryGradientP], Transpose@Nest[Insert[#, Repeat[0 Percent, Length[gradient]], -3] &, Transpose@(gradient[[All, 1 ;; -2]]), 2],
									MatchQ[gradient, Automatic], gradient,
									(* Get rid of reference loading status if it is from HPLC option *)
									MatchQ[gradient, {{TimeP, PercentP, PercentP, PercentP, PercentP, FlowRateP, Alternatives[Open, Closed, None, Automatic]}...}], gradient[[All, 1 ;; -2]],
									(* Keep Gradient as it is if our resolver is called from another experiment *)
									True, gradient
								];

								(* If the flow rate was changed, we update that *)
								(* Note that we skip this step if FlowRate is specified as {time, flowRate} tuples and the time points of the option do not match the Gradient option *)
								analyteGradientOptionTuple = Which[
									MatchQ[flowRate, Automatic],
									protoAnalyteGradientOptionTuple,
									MatchQ[flowRate, FlowRateP],
									ReplacePart[protoAnalyteGradientOptionTuple, Table[{x, -1} -> flowRate, {x, 1, Length[protoAnalyteGradientOptionTuple]}]],
									And[
										MatchQ[flowRate,{{TimeP,FlowRateP}..}],
										!MatchQ[protoAnalyteGradientOptionTuple,Automatic],
										MatchQ[protoAnalyteGradientOptionTuple[[All,1]],flowRate[[All,1]]]
									],
									ReplacePart[
										protoAnalyteGradientOptionTuple,
										AssociationThread[
											{#,-1}&/@Range[Length[protoAnalyteGradientOptionTuple]],
											flowRate[[All,2]]
										]
									],
									True,
									protoAnalyteGradientOptionTuple
								];

								(* Default FlowRate to option value, gradient tuple values, or the pre-calculated optimal flow rate for the column *)
								(* Note that it's ok to have this flow rate either match FlowRateP, or be a list of pairs of time and flow rate since resolveGradient can handle either *)
								(* Add a 0 Minute point if not already provided *)
								defaultedAnalyteFlowRate = Which[
									MatchQ[flowRate, FlowRateP], flowRate,
									MatchQ[flowRate, {{TimeP,FlowRateP}..}],
									DeleteDuplicatesBy[
										Append[flowRate, {0 Minute, flowRate[[1,2]]}],
										First[#] * 1.&
									],
									MatchQ[analyteGradientOptionTuple, gradientP], analyteGradientOptionTuple[[All, {1, -1}]],
									MatchQ[FirstOrDefault[resolvedFlowRates], FlowRateP], FirstOrDefault[resolvedFlowRates],
									True, 1 Milliliter / Minute
								];

								(* Calculate the amount of time it is required to flow 1.5* column volume's buffer through the column to help resolve column prime gradient *)
								(* Note that we don't resolve this value if (1) we are not in column prime (the volume is Null) OR (2) we have flow rate with timepoints (this means we will follow that for gradient resolution and we don't care about adding more time to the end) *)
								columnEquilibrationDuration=Which[
									NullQ[columnVolume],
									Null,
									MatchQ[defaultedAnalyteFlowRate,FlowRateP],
									Round[Divide[UnitConvert[columnVolume, Milliliter], defaultedAnalyteFlowRate] * 1.5, 0.1Minute],
									True,
									Null
								];

								(* Create the default gradient based on the first resolved analyte gradient - get rid of the Refractive Index Reference Loading status to be resolveGradient friendly *)
								defaultGradient = First[resolvedAnalyteGradients][[All, 1 ;; -2]];
								(* Change the flow rate of the defaultGradient to match the specified option *)
								Which[
									MatchQ[defaultedAnalyteFlowRate,FlowRateP],
									(* Singleton FlowRate, we can replace it *)
									defaultGradient[[All, 6]] = ConstantArray[defaultedAnalyteFlowRate, Length[defaultGradient]],
									(* Replace with the flow rate if the timepoints are the same *)
									And[
										MatchQ[flowRate,{{TimeP,FlowRateP}..}],
										MatchQ[defaultedAnalyteFlowRate[[All,1]],flowRate[[All,1]]]
									],
									defaultGradient[[All, 6]] = defaultedAnalyteFlowRate,
									True,
									Null
								];

								(* We would like ColumnPrimeGradient to end with the starting gradient of the sample. To do this, get the defaultStartingGradient by get the 4 percentage values only *)
								(* If our instrument is a binary pump instrument - i.e., LCMS, and we are using more than just A/B, keep as the default to make sure we can use the pump properly *)
								defaultStartingGradient = If[!MatchQ[defaultGradient[[1, 2 ;; -2]], {_, _, EqualP[0Percent], EqualP[0Percent]}],
									{Quantity[90., Percent], Quantity[10., Percent], Quantity[0., Percent], Quantity[0., Percent]},
									First[defaultGradient][[2 ;; -2]]
								];

								(* We would like ColumnFlushGradient to end with the desired ColumnStorageBuffer *)
								defaultEndingGradient = Switch[storageBuffer,
									BufferA, {Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent]},
									BufferB, {Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent]},
									BufferC, {Quantity[0., Percent], Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent]},
									BufferD, {Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[100., Percent]},
									_, {Quantity[90., Percent], Quantity[10., Percent], Quantity[0., Percent], Quantity[0., Percent]}
								];

								(* This part is to semi-resolve gradient for binary pumps. If user does not give use the gradients for A/C or B/D, we want to make it possible to be binary *)
								(* If more than 2 gradient options are specified, we do not want to do the binary settings as we may actually lead to a non-100% sum *)
								(* If gradient C is set, we want A to go to 0 *)
								semiResolvedGradientA = If[MatchQ[{gradientA, gradientC, gradientB, gradientD}, {Automatic, Except[Automatic], Automatic, Automatic}],
									Which[
										MatchQ[gradientC, GreaterP[0 Percent]], 0 Percent,
										(* Make the same as gradient C and replace out the right side with zeros *)
										MemberQ[gradientC, {_, GreaterP[0 Percent]}],
										(* We also want to add a starting point, if not there *)
										DeleteDuplicatesBy[
											Append[ReplacePart[gradientC, Table[{x, 2} -> 0 Percent, {x, 1, Length[gradientC]}]], {0 Minute, 0 Percent}],
											First[#] * 1.&
										],
										True, gradientA
									],
									gradientA
								];
								(* If gradient A is set, we want C to go to 0 *)
								semiResolvedGradientC = If[MatchQ[{gradientC, gradientA, gradientB, gradientD}, {Automatic, Except[Automatic], Automatic, Automatic}],
									Which[
										MatchQ[gradientA, GreaterP[0 Percent]], 0 Percent,
										(* Make the same as gradient A and replace out the right side with zeros*)
										MemberQ[gradientA, {_, GreaterP[0 Percent]}],
										DeleteDuplicatesBy[
											Append[ReplacePart[gradientA, Table[{x, 2} -> 0 Percent, {x, 1, Length[gradientA]}]], {0 Minute, 0 Percent}],
											First[#] * 1.&
										],
										True, gradientC
									],
									gradientC
								];

								(* If gradient D is set, we want B to go to 0 *)
								semiResolvedGradientB = If[MatchQ[{gradientB, gradientD, gradientA, gradientC}, {Automatic, Except[Automatic], Automatic, Automatic}],
									Which[
										MatchQ[gradientD, GreaterP[0 Percent]], 0 Percent,
										(* Make the same as gradient D and replace out the right side with zeros *)
										MemberQ[gradientD, {_, GreaterP[0 Percent]}],
										DeleteDuplicatesBy[
											Append[ReplacePart[gradientD, Table[{x, 2} -> 0 Percent, {x, 1, Length[gradientD]}]], {0 Minute, 0 Percent}],
											First[#] * 1.&
										],
										True, gradientB
									],
									gradientB
								];
								(* If gradient B is set, we want D to go to 0 *)
								semiResolvedGradientD = If[MatchQ[{gradientD, gradientB, gradientA, gradientC}, {Automatic, Except[Automatic], Automatic, Automatic}],
									Which[
										MatchQ[gradientB, GreaterP[0 Percent]], 0 Percent,
										(* Make the same as gradient B and replace out the right side with zeros*)
										MemberQ[gradientB, {_, GreaterP[0 Percent]}],
										DeleteDuplicatesBy[
											Append[ReplacePart[gradientB, Table[{x, 2} -> 0 Percent, {x, 1, Length[gradientB]}]], {0 Minute, 0 Percent}],
											First[#] * 1.&
										],
										True, gradientD
									],
									gradientD
								];

								(* A special preparation before resolving gradient is about the Refractive Index detector*)
								(* If DifferentialRefractiveIndex is requested, the reference loading needs to be closed in the gradient process. We resolve it to always closed to use the prime solution as reference. User has the ability to change it *)
								(* Note that unless user asks for dRI, we always try to resolve to RefractiveIndex *)
								loadingStatusFromOption = Which[
									(* Set to True /Closed for DRI *)
									MatchQ[refractiveIndexMethod, DifferentialRefractiveIndex], Closed,
									(* If RI detector is requested, we can set it to Open for RefrativeIndex method *)
									refractiveIndexRequestedQ, Open,
									(* Otherwise set to None *)
									True, None
								];

								loadingStatusForResolver = Which[
									(* Get the reference loading status from the provided gradient method object *)
									MatchQ[gradient, ObjectP[Object[Method, Gradient]]] && !MatchQ[Lookup[fetchPacketFromCache[Download[gradient, Object], cache], RefractiveIndexReferenceLoading], {}], Lookup[fetchPacketFromCache[Download[gradient, Object], cache], RefractiveIndexReferenceLoading],
									MatchQ[gradient, Automatic] && MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]] && !MatchQ[Lookup[fetchPacketFromCache[Download[injectionTableGradient, Object], cache], RefractiveIndexReferenceLoading], {}], Lookup[fetchPacketFromCache[Download[injectionTableGradient, Object], cache], RefractiveIndexReferenceLoading],
									(* Get the reference loading status from the provided gradient option values *)
									!MatchQ[gradient, Automatic | ObjectP[Object[Method, Gradient]]], gradient[[All, -1]] /. {Automatic -> loadingStatusFromOption},
									(* Otherwise go with the loading status from the detector *)
									MatchQ[analyteGradientOptionTuple, gradientP], ConstantArray[loadingStatusFromOption, Length[analyteGradientOptionTuple]],
									True, loadingStatusFromOption
								];

								(* Get our required refractive index reference loading information, if provided *)
								analyteGradientOptionTupleWithRILoading = If[MatchQ[analyteGradientOptionTuple, gradientP],
									MapThread[
										Append[#1, #2]&,
										{analyteGradientOptionTuple, loadingStatusForResolver}
									],
									Automatic
								];

								(* Finally run our helper resolution function *)
								analyteGradientReturned = Switch[type,
									(* If we have a standard or blank, we want to default to the first sample gradient, if a standard or blank *)
									(Standard | Blank), Which[
										(* If the analyte gradient is already fully informed, then we go with that*)

										MatchQ[analyteGradientOptionTuple, gradientP], analyteGradientOptionTupleWithRILoading,
										MatchQ[{analyteGradientOptionTuple, semiResolvedGradientA, semiResolvedGradientB, semiResolvedGradientC, semiResolvedGradientD}, {(Null | Automatic)..}],
										resolveGradient[
											defaultGradient,
											semiResolvedGradientA,
											semiResolvedGradientB,
											semiResolvedGradientC,
											semiResolvedGradientD,
											defaultedAnalyteFlowRate,
											(* We no longer have GradientStart, GradientEnd, GradientDuration, FlushTime and EquilibrationTime options in HPLC to use only the formal Gradient options. Give Null to all these in resolveGradient *)
											Null,
											Null,
											Null,
											Null,
											Null,
											loadingStatusForResolver
										],
										True,
										resolveGradient[
											analyteGradientOptionTuple,
											semiResolvedGradientA,
											semiResolvedGradientB,
											semiResolvedGradientC,
											semiResolvedGradientD,
											defaultedAnalyteFlowRate,
											(* We no longer have GradientStart, GradientEnd, GradientDuration, FlushTime and EquilibrationTime options in HPLC to use only the formal Gradient options. Give Null to all these in resolveGradient *)
											Null,
											Null,
											Null,
											Null,
											Null,
											loadingStatusForResolver
										]
									],
									(* Column Prime type *)
									ColumnPrime,
									Which[
										(* If the analyte gradient is already fully informed, then we go with that *)
										MatchQ[analyteGradientOptionTuple, gradientP], analyteGradientOptionTupleWithRILoading,
										MatchQ[{analyteGradientOptionTuple, semiResolvedGradientA, semiResolvedGradientB, semiResolvedGradientC, semiResolvedGradientD}, {(Null | Automatic)..}],
										resolveGradient[
											defaultPrimeGradient[defaultedAnalyteFlowRate, columnEquilibrationDuration, defaultStartingGradient],
											semiResolvedGradientA,
											semiResolvedGradientB,
											semiResolvedGradientC,
											semiResolvedGradientD,
											defaultedAnalyteFlowRate,
											Null,
											Null,
											Null,
											Null,
											Null,
											loadingStatusForResolver
										],
										True,
										resolveGradient[
											analyteGradientOptionTuple,
											semiResolvedGradientA,
											semiResolvedGradientB,
											semiResolvedGradientC,
											semiResolvedGradientD,
											defaultedAnalyteFlowRate,
											Null,
											Null,
											Null,
											Null,
											Null,
											loadingStatusForResolver
										]
									],
									(* Last case - Column Flush type*)
									_, Which[
										(* If the analyte gradient is already fully informed, then we go with that*)
										MatchQ[analyteGradientOptionTuple, gradientP], analyteGradientOptionTupleWithRILoading,
										MatchQ[{analyteGradientOptionTuple, semiResolvedGradientA, semiResolvedGradientB, semiResolvedGradientC, semiResolvedGradientD}, {(Null | Automatic)..}],
										resolveGradient[
											defaultFlushGradient[defaultedAnalyteFlowRate, defaultEndingGradient],
											semiResolvedGradientA,
											semiResolvedGradientB,
											semiResolvedGradientC,
											semiResolvedGradientD,
											defaultedAnalyteFlowRate,
											Null,
											Null,
											Null,
											Null,
											Null,
											loadingStatusForResolver
										],
										True,
										resolveGradient[
											analyteGradientOptionTuple,
											semiResolvedGradientA,
											semiResolvedGradientB,
											semiResolvedGradientC,
											semiResolvedGradientD,
											defaultedAnalyteFlowRate,
											Null,
											Null,
											Null,
											Null,
											Null,
											loadingStatusForResolver
										]
									]
								];

								(* Remove duplicate entries if need be *)
								analyteGradient = DeleteDuplicatesBy[analyteGradientReturned, First[# * 1.] &];

								(* If we have to remove the extra, note that *)
								removedExtrasQ = If[MatchQ[analyteGradientOptionTuple, gradientP],
									(* For LCMS gradient case (input is gradientP already) The returned gradient will have the Reference Loading at the end so we need to remove it for comparing to analyteGradientOptionTuple *)
									!MatchQ[1. * analyteGradientOptionTuple, 1. * (Most[#]& /@ analyteGradient)],
									!MatchQ[1. * analyteGradientReturned, 1. * analyteGradient]
								];

								(* Make sure that the gradient is in the correct order *)
								incorrectGradientOrderQ = Not@OrderedQ[analyteGradient[[All, 1]]];

								(* Check whether the gradient composition adds up to 100 % *)
								invalidGradientCompositionQ = Not[AllTrue[analyteGradient, (Total[#[[{2, 3, 4, 5}]]] == 100 Percent)&]];

								(* Now resolve all of the individual gradients and flow rate *)
								resolvedGradientA = If[MatchQ[gradientA, Automatic],
									collapseGradient[analyteGradient[[All, {1, 2}]]],
									gradientA
								];

								resolvedGradientB = If[MatchQ[gradientB, Automatic],
									collapseGradient[analyteGradient[[All, {1, 3}]]],
									gradientB
								];

								resolvedGradientC = If[MatchQ[gradientC, Automatic],
									collapseGradient[analyteGradient[[All, {1, 4}]]],
									gradientC
								];

								resolvedGradientD = If[MatchQ[gradientD, Automatic],
									collapseGradient[analyteGradient[[All, {1, 5}]]],
									gradientD
								];

								resolvedFlowRate = If[MatchQ[flowRate, Automatic],
									collapseGradient[analyteGradient[[All, {1, 6}]]],
									flowRate
								];

								(* Finally resolve the gradient *)
								resolvedGradient = Which[
									MatchQ[gradient, ObjectP[Object[Method, Gradient]]], Download[gradient, Object],
									MatchQ[gradient, Except[Automatic]], gradient,
									(* Otherwise if the gradient is automatic and the injection table is set, should use that *)
									MatchQ[gradient, Automatic] && MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]], Download[injectionTableGradient, Object],
									(* Otherwise use the resolved tuple we got *)
									True, analyteGradient
								];

								(* Total the gradient so that we can do our non-binary gradient check *)
								totaledGradient = Total[analyteGradient][[2 ;; 5]];

								(* Check whether the gradient is non-binary, meaning that any of the tuples have both A and C or both B and D *)
								(* Note that we are probably over-restrictive here since in theory, we can allow A/B at one time point and C/D at later time point. However, gradient actually gradually change over time so it is more complicated to calculate more percentage changes during the entire gradient. We restrict that only one of the binary gradients to be used for one single injection *)
								nonbinaryGradientQ = MatchQ[totaledGradient, {GreaterP[0 Percent], _, GreaterP[0 Percent], _} | {_, GreaterP[0 Percent], _, GreaterP[0 Percent]}];

								(* Return everything *)
								{
									analyteGradient,
									resolvedGradientA,
									resolvedGradientB,
									resolvedGradientC,
									resolvedGradientD,
									resolvedFlowRate,
									resolvedGradient,
									gradientInjectionTableSpecifiedDifferentlyQ,
									invalidGradientCompositionQ,
									nonbinaryGradientQ,
									removedExtrasQ,
									gradientAmbiguityQ,
									incorrectGradientOrderQ,
									columnEquilibrationDuration
								}
							]
						],
						{
							gradientAs,
							gradientBs,
							gradientCs,
							gradientDs,
							gradients,
							flowRates,
							entryRefractiveIndexLoadingMethods,
							processedInjectionTableGradients,
							storageBuffers,
							columnVolumes
						}
					]
				]
			]
		],
		{
			Join[
				Lookup[
					expandedStandardOptions,
					{
						StandardGradientA,
						StandardGradientB,
						StandardGradientC,
						StandardGradientD,
						StandardGradient,
						StandardFlowRate,
						StandardRefractiveIndexMethod
					}
				],
				{
					injectionTableStandardGradients,
					Standard,
					standardExistsQ,
					(* ColumnStorageBuffer and Column total Volume only apply to ColumnPrime and Flush *)
					ConstantArray[Null,Length[injectionTableStandardGradients]],
					ConstantArray[Null,Length[injectionTableStandardGradients]]
				}
			],
			Join[
				Lookup[
					expandedBlankOptions,
					{
						BlankGradientA,
						BlankGradientB,
						BlankGradientC,
						BlankGradientD,
						BlankGradient,
						BlankFlowRate,
						BlankRefractiveIndexMethod
					}
				],
				{
					injectionTableBlankGradients,
					Blank,
					blankExistsQ,
					(* ColumnStorageBuffer and Column total Volume only apply to ColumnPrime and Flush *)
					ConstantArray[Null,Length[injectionTableBlankGradients]],
					ConstantArray[Null,Length[injectionTableBlankGradients]]
				}
			],
			Join[
				Lookup[
					expandedColumnGradientOptions,
					{
						ColumnPrimeGradientA,
						ColumnPrimeGradientB,
						ColumnPrimeGradientC,
						ColumnPrimeGradientD,
						ColumnPrimeGradient,
						ColumnPrimeFlowRate,
						ColumnPrimeRefractiveIndexMethod
					},
					Null
				],
				{
					injectionTableColumnPrimeGradients,
					ColumnPrime,
					columnPrimeQ,
					(* No need for column storage buffer for Prime *)
					semiResolvedColumnStorageBufferPositions,
					(* Column total volume to help decide gradient *)
					columnConfigurationVolumes
				}
			],
			Join[
				Lookup[
					expandedColumnGradientOptions,
					{
						ColumnFlushGradientA,
						ColumnFlushGradientB,
						ColumnFlushGradientC,
						ColumnFlushGradientD,
						ColumnFlushGradient,
						ColumnFlushFlowRate,
						ColumnFlushRefractiveIndexMethod
					},
					Null
				],
				{
					injectionTableColumnFlushGradients,
					ColumnFlush,
					columnFlushQ,
					(* Storage Buffer Position *)
					semiResolvedColumnStorageBufferPositions,
					(* Column total volume to help decide gradient *)
					columnConfigurationVolumes
				}
			]
		}
	];

	(* Gradient Error Checking *)
	(* Check for collisions between the injection table and the gradient specifications *)
	(* Which BlahGradient options conflict to the InjectionTable? *)
	gradientInjectionTableSpecifiedDifferentlyOptionsBool = Map[
		(Or @@ #)&,
		{
			gradientInjectionTableSpecifiedDifferentlyBool,
			standardGradientInjectionTableSpecifiedDifferentlyBool,
			blankGradientInjectionTableSpecifiedDifferentlyBool,
			columnPrimeGradientInjectionTableSpecifiedDifferentlyBool,
			columnFlushGradientInjectionTableSpecifiedDifferentlyBool
		}
	];
	gradientInjectionTableSpecifiedDifferentlyQ = Or @@ gradientInjectionTableSpecifiedDifferentlyOptionsBool;

	(* If any is True, track the invalid option and throw error message *)
	gradientInjectionTableSpecifiedDifferentlyOptions = If[gradientInjectionTableSpecifiedDifferentlyQ,
		Append[PickList[{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}, gradientInjectionTableSpecifiedDifferentlyOptionsBool], InjectionTable],
		{}
	];

	If[messagesQ && gradientInjectionTableSpecifiedDifferentlyQ, Message[Error::InjectionTableGradientConflict, ObjectToString[Drop[gradientInjectionTableSpecifiedDifferentlyOptions,-1]]]];

	gradientInjectionTableSpecifiedDifferentlyTest = If[gradientInjectionTableSpecifiedDifferentlyQ,
		testOrNull["If InjectionTable is specified as well as Gradient, StandardGradient, BlankGradient, ColumnFlushGradient, and/or ColumnPrimeGradient, they are copacetic:", False],
		testOrNull["If InjectionTable is specified as well as Gradient, StandardGradient, BlankGradient, ColumnFlushGradient, and/or ColumnPrimeGradient, they are copacetic:", True]
	];

	(* Check if we had to remove extra gradient tuples *)
	removedExtraOptionBool = Map[
		MemberQ[#, True] || TrueQ[#]&,
		{
			removedExtraBool,
			removedExtraStandardBool,
			removedExtraBlankBool,
			removedExtraColumnPrimeGradientBool,
			removedExtraColumnFlushGradientBool
		}
	];
	removedExtraOptionQ = MemberQ[removedExtraOptionBool, True];

	(* If any is True, then get the offending options (and throw the error) *)
	removedExtraOptions = If[removedExtraOptionQ && messagesQ,
		PickList[{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}, removedExtraOptionBool],
		{}
	];
	If[messagesQ && removedExtraOptionQ && !engineQ,
		Message[Warning::RemovedExtraGradientEntries, removedExtraOptions]
	];

	(* Generate the test testing for this issue *)
	removedExtraTest = If[gatherTestsQ,
		Warning["If Gradient, StandardGradient, BlankGradient, ColumnFlushGradient, and/or ColumnPrimeGradient are specified, the gradient entries do not have duplicate times:",
			removedExtraOptionQ,
			False
		],
		Nothing
	];

	(* Check if any of the gradient A/B/C/D options conflict with Gradient option *)
	gradientAmbiguityOverallBool = Map[
		MemberQ[#, True] || TrueQ[#]&,
		{
			gradientAmbiguityBool,
			standardGradientAmbiguityBool,
			blankGradientAmbiguityBool,
			columnPrimeGradientAmbiguityBool,
			columnFlushGradientAmbiguityBool
		}
	];
	gradientAmbiguityOverallQ = MemberQ[gradientAmbiguityOverallBool, True];

	(* If any is True, then get the offending options (and throw the error) *)
	gradientAmbiguityOptions = If[gradientAmbiguityOverallQ && messagesQ,
		PickList[{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}, gradientAmbiguityOverallBool],
		{}
	];
	If[messagesQ && gradientAmbiguityOverallQ,
		Message[Warning::GradientAmbiguity, gradientAmbiguityOptions]
	];

	(* Generate the test testing for this issue *)
	gradientAmbiguityTest = If[gatherTestsQ,
		Warning["If Gradient, StandardGradient, BlankGradient, ColumnFlushGradient, and/or ColumnPrimeGradient are specified as gradient tables, the corresponding GradientA/B/C/D options are not specified:",
			gradientAmbiguityOverallQ,
			False
		],
		Nothing
	];

	(* Check if we had to reorder gradient tuples *)
	incorrectGradientOrderOverallBool = Map[
		MemberQ[#, True] || TrueQ[#]&,
		{
			incorrectGradientOrderBool,
			standardIncorrectGradientOrderBool,
			blankIncorrectGradientOrderBool,
			columnPrimeIncorrectGradientOrderBool,
			columnFlushIncorrectGradientOrderBool
		}
	];
	incorrectGradientOrderOverallBoolQ = MemberQ[incorrectGradientOrderOverallBool, True];

	(* If any is True, then get the offending options (and throw the error) *)
	incorrectGradientOrderOptions = If[incorrectGradientOrderOverallBoolQ && messagesQ,
		PickList[{ Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient }, incorrectGradientOrderOverallBool],
		{}
	];

	If[messagesQ && incorrectGradientOrderOverallBoolQ,
		Message[Error::GradientOutOfOrder, incorrectGradientOrderOptions]
	];

	(* Generate the test testing for this issue *)
	incorrectGradientOrderOverallTest = If[gatherTestsQ,
		Test["If a full gradient table sequence is provided, then all of the Gradients are in ascending order:",
			incorrectGradientOrderOverallBoolQ,
			False
		],
		Nothing
	];

	(* Check that all of the gradient compositions are valid (add up to 100%) *)
	invalidGradientCompositionOptionsBool = Map[
		(Or @@ #)&,
		{
			invalidGradientCompositionBool,
			standardInvalidGradientCompositionBool,
			blankInvalidGradientCompositionBool,
			columnPrimeInvalidGradientCompositionBool,
			columnFlushInvalidGradientCompositionBool
		}
	];
	invalidGradientCompositionQ = Or @@ invalidGradientCompositionOptionsBool;

	(* If any is True, then get the offending options *)
	invalidGradientCompositionOptions = If[invalidGradientCompositionQ,
		If[messagesQ, Message[Error::InvalidGradientCompositionOptions, PickList[{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}, invalidGradientCompositionOptionsBool]]];
		PickList[{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}, invalidGradientCompositionOptionsBool],
		{}
	];

	invalidGradientCompositionTest = If[invalidGradientCompositionQ,
		testOrNull["If Gradient, StandardGradient, BlankGradient, ColumnFlushGradient, and/or ColumnPrimeGradient are specified, they are valid gradients (add up to 100% for each time point):", False],
		testOrNull["If Gradient, StandardGradient, BlankGradient, ColumnFlushGradient, and/or ColumnPrimeGradient are specified, they are valid gradients (add up to 100% for each time point):", True]
	];

	(* We also need to figure out if we're overwrite the gradients and supplying a new one*)
	{
		overwriteGradientsBool,
		overwriteStandardGradientsBool,
		overwriteBlankGradientsBool,
		overwriteColumnPrimeGradientBool,
		overwriteColumnFlushGradientBool
	} = Map[
		Function[
			{listTuple},
			If[!MatchQ[listTuple[[1]], {} | Null],
				MapThread[
					Function[{resolvedGradientOption, fullGradientSpecified},
						If[MatchQ[resolvedGradientOption, ObjectP[Object[Method]]],
							(*check to see if the gradient was changed*)
							!MatchQ[
								Most[#]& /@ fullGradientSpecified,
								Lookup[fetchPacketFromCache[Download[resolvedGradientOption, Object], simulatedCache], Gradient][[All, {1, 2, 3, 4, 5, -1}]]
							],
							False
						]
					],
					{listTuple[[1]], listTuple[[2]]}
				]
			]
		],
		{
			{resolvedGradients, resolvedAnalyteGradients},
			{resolvedStandardGradients, resolvedStandardAnalyticalGradients},
			{resolvedBlankGradients, resolvedBlankAnalyticalGradients},
			{resolvedColumnPrimeGradients, resolvedColumnPrimeAnalyticalGradients},
			{resolvedColumnFlushGradients, resolvedColumnFlushAnalyticalGradients}
		}
	];

	(* Throw a warning whenever we're overwriting *)
	overwriteOptionBool = Map[
		Or @@ #&,
		{
			overwriteGradientsBool,
			overwriteStandardGradientsBool,
			overwriteBlankGradientsBool,
			overwriteColumnPrimeGradientBool,
			overwriteColumnFlushGradientBool
		}
	];

	(* If there is a mismatch between the Blank options and the injection table, throw an error *)
	If[messagesQ && Or @@ overwriteOptionBool && !engineQ,
		Message[Warning::OverwritingGradient, PickList[{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}, overwriteOptionBool]]
	];

	(* Check that none of the gradients were singletons *)
	anySingletonGradientsBool = Map[
		Function[{gradientList},
			MemberQ[Length /@ gradientList, 1]
		],
		{resolvedAnalyteGradients, resolvedStandardAnalyticalGradients, resolvedBlankAnalyticalGradients, resolvedColumnPrimeAnalyticalGradients, resolvedColumnFlushAnalyticalGradients}
	];

	(* If so, then get the offending options (and throw the error) *)
	anySingletonGradientOptions = If[And[Or @@ anySingletonGradientsBool, messagesQ],
		PickList[{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}, anySingletonGradientsBool],
		{}
	];
	If[And[Or @@ anySingletonGradientsBool, messagesQ],
		Message[Error::GradientSingleton, anySingletonGradientOptions]
	];

	(* Generate the test for this issue *)
	anySingletonGradientTest = If[gatherTestsQ,
		Test["If the gradient tuples are specified, there is more than one entry:",
			Or @@ anySingletonGradientsBool,
			False
		],
		Nothing
	];

	(* We must adjust the overwrite if the standards and blanks are imbalanced in the injection table *)
	adjustedOverwriteStandardBool = Which[
		Length[injectionTableStandardGradients] > Length[resolvedStandardGradients] && !NullQ[injectionTableStandardGradients], PadRight[overwriteStandardGradientsBool, Length[injectionTableStandardGradients], False],
		Length[injectionTableStandardGradients] < Length[resolvedStandardGradients] && !NullQ[injectionTableStandardGradients], Take[overwriteStandardGradientsBool, Length[injectionTableStandardGradients]],
		True, overwriteStandardGradientsBool
	];
	adjustedOverwriteBlankBool = Which[
		Length[injectionTableBlankGradients] > Length[resolvedBlankGradients] && !NullQ[injectionTableBlankGradients], PadRight[overwriteBlankGradientsBool, Length[injectionTableBlankGradients], False],
		Length[injectionTableBlankGradients] < Length[resolvedBlankGradients] && !NullQ[injectionTableBlankGradients], Take[overwriteBlankGradientsBool, Length[injectionTableBlankGradients]],
		True, overwriteBlankGradientsBool
	];

	(* Resolve the buffers *)
	(* Skip BufferC and NeedleWashSolution since we need to see if we have Dionex instrument *)
	(*  Bundle all the resolved gradients together so that it'll be helpful *)
	allResolvedGradientMethods = Cases[
		Join[
			resolvedGradients,
			resolvedStandardGradients /. {Null -> {}},
			resolvedBlankGradients /. {Null -> {}},
			resolvedColumnPrimeGradients /. {Null -> {}},
			resolvedColumnFlushGradients /. {Null -> {}}
		],
		ObjectP[Object[Method, Gradient]]
	];

	(* Get the packets for any associated gradient method objects *)
	allGradientMethodPackets = Map[
		fetchPacketFromCache[Download[#, Object], cache]&,
		allResolvedGradientMethods
	];

	(* See if any of the gradients have been specified by seeing if there are > 0 Percent point(s) *)
	anyGradientAQ = Or @@ Map[
		Count[#, GreaterP[0 Percent] | {{GreaterEqualP[0 Minute], GreaterEqualP[0 Percent]}..}] > 0&,
		{resolvedGradientAs, resolvedStandardGradientAs, resolvedBlankGradientAs, resolvedColumnPrimeGradientAs, resolvedColumnFlushGradientAs}
	];

	anyGradientBQ = Or @@ Map[
		Count[#, GreaterP[0 Percent] | {{GreaterEqualP[0 Minute], GreaterEqualP[0 Percent]}..}] > 0&,
		{resolvedGradientBs, resolvedStandardGradientBs, resolvedBlankGradientBs, resolvedColumnPrimeGradientBs, resolvedColumnFlushGradientBs}
	];

	anyGradientCQ = Or @@ Map[
		Count[#, GreaterP[0 Percent] | {{GreaterEqualP[0 Minute], GreaterEqualP[0 Percent]}..}] > 0&,
		{resolvedGradientCs, resolvedStandardGradientCs, resolvedBlankGradientCs, resolvedColumnPrimeGradientCs, resolvedColumnFlushGradientCs}
	];

	anyGradientDQ = Or @@ Map[
		Count[#, GreaterP[0 Percent] | {{GreaterEqualP[0 Minute], GreaterEqualP[0 Percent]}..}] > 0&,
		{resolvedGradientDs, resolvedStandardGradientDs, resolvedBlankGradientDs, resolvedColumnPrimeGradientDs, resolvedColumnFlushGradientDs}
	];

	(* Get all the method buffers and dereference *)
	{
		bufferAMethodList,
		bufferBMethodList,
		bufferCMethodList,
		bufferDMethodList
	} = Transpose[
		Map[
			Download[#, Object]&,
			Lookup[
				allGradientMethodPackets,
				{
					BufferA,
					BufferB,
					BufferC,
					BufferD
				},
				{Null, Null, Null, Null}
			]
		]
	];

	(* Resolve Buffers *)
	resolvedBufferA = Which[
		MatchQ[Lookup[roundedOptionsAssociation, BufferA], Except[Automatic]], Lookup[roundedOptionsAssociation, BufferA],
		(* If the user specified a gradient method, we'll want to take from there *)
		Count[bufferAMethodList, ObjectP[Model[Sample]]] > 0, FirstCase[bufferAMethodList, ObjectP[Model[Sample]]],
		(* If this is LCMS, we want to use the formic acid in water*)
		internalUsageQ, Model[Sample, "0.1% Formic acid in Water"],
		(* "Ion Exchange Buffer A Native" *)
		MatchQ[resolvedSeparationMode, IonExchange], Model[Sample, StockSolution, "id:9RdZXvKBeEbJ"],
		(* "100 mM Phosphate Buffer - 0.02% Sodium Azide - pH 6.8" *)
		MatchQ[resolvedSeparationMode, SizeExclusion], Model[Sample, StockSolution, "id:01G6nvwAxYYm"],
		(* "Acetonitrile, HPLC Grade" *)
		MatchQ[resolvedSeparationMode, Chiral], Model[Sample, "id:O81aEB4kJXr1"],
		(* Reverse phase - buffer B 0.05% HFBA *)
		True, Model[Sample, StockSolution, "id:Vrbp1jG80zwE"]
	];

	resolvedBufferB = Which[
		MatchQ[Lookup[roundedOptionsAssociation, BufferB], Except[Automatic]], Lookup[roundedOptionsAssociation, BufferB],
		(* If the user specified a gradient method, we'll want to take from there *)
		Count[bufferBMethodList, ObjectP[Model[Sample]]] > 0, FirstCase[bufferBMethodList, ObjectP[Model[Sample]]],
		(* If this is LCMS, we want to use the formic acid in ACN *)
		internalUsageQ, Model[Sample, "0.1% Formic acid in Acetonirile for LCMS"],
		(* "Ion Exchange Buffer B Native" *)
		MatchQ[resolvedSeparationMode, IonExchange], Model[Sample, StockSolution, "id:8qZ1VWNmdLbb"],
		(* "Milli-Q water" *)
		MatchQ[resolvedSeparationMode, Chiral | SizeExclusion], Model[Sample, "id:8qZ1VWNmdLBD"],
		(* "Reverse phase buffer B 0.05% HFBA" *)
		True, Model[Sample, StockSolution, "id:eGakld01zKqx"]
	];

	(* We have a particular case where the dionex instrument shares the BufferC with the NeedleWashSolution *)
	(* Because of this specifial case, we do this after the Instrument is resolved *)

	(* We would like to do a temporary resolution of BufferD in order to help resolve the instrument. Depending on the finally resolved instrument, we can resolve the BufferD to a solution or keep Null *)
	resolvedBufferD = Which[
		MatchQ[Lookup[roundedOptionsAssociation, BufferD], Except[Automatic]], Lookup[roundedOptionsAssociation, BufferD],
		(* If the user specified a gradient method, we'll want to take from there *)
		Count[bufferDMethodList, ObjectP[Model[Sample]]] > 0, FirstCase[bufferDMethodList, ObjectP[Model[Sample]]],
		(* We only give something if the user requests GradientD *)
		anyGradientDQ, Model[Sample, "Milli-Q water"],
		True, Null
	];

	(* Finally resolve ColumnStorageBuffer by replacing BufferA *)
	resolvedColumnStorageBuffer=semiResolvedColumnStorageBuffers/.{BufferA->resolvedBufferA};

	(* Resolve Column Temperature to help resolve Instrument *)
	(* Get Column Temperature and Sample Temperature from injection Table or default to Automatic *)
	{specifiedSampleColumnTemperatures,columnTemperatureInjectionTableConflictQ} = If[injectionTableSpecifiedQ&&SameLengthQ[Cases[injectionTableLookup, {Sample, ___}],mySamples],
		Transpose@MapThread[
			If[!MatchQ[#1,Automatic],
				{
					#1,
					(* Cases that we consider injection table to match the standalone options *)
					!Or[
						(* Injection table value is exactly the same as standalone option or Automatic *)
						MatchQ[#2,Automatic|EqualP[#1]],
						(* Both values are Ambient (or $AmbientTemperature) *)
						And[
							MatchQ[#1,Ambient|EqualP[$AmbientTemperature]],
							MatchQ[#2,Ambient|EqualP[$AmbientTemperature]]
						]
					]
				},
				{#2,False}
			]&,
			{
				Lookup[roundedOptionsAssociation,ColumnTemperature],
				Cases[injectionTableLookup, {Sample, ___}][[All, 5]]
			}
		],
		(* Otherwise just use the values from the ColumnTemperature option *)
		{
			Lookup[roundedOptionsAssociation, ColumnTemperature],
			ConstantArray[False,Length[mySamples]]
		}
	];

	(* Resolve analyte column temperatures based on option value, gradient packet, or default to Ambient *)
	resolvedColumnTemperatures = MapThread[
		Function[{temperatureOptionValue, gradientOptionValue},
			(* If option is specified, take option value *)
			If[!MatchQ[temperatureOptionValue, Automatic],
				temperatureOptionValue,
				(* If gradient object is specified, inherit Temperature from gradient object *)
				If[MatchQ[gradientOptionValue, ObjectP[Object[Method, Gradient]]],
					Lookup[
						fetchPacketFromCache[Download[gradientOptionValue, Object], cache],
						Temperature
					]/.{Null :> Ambient},
					(* Default to Ambient *)
					Ambient
				]
			]
		],
		{
			specifiedSampleColumnTemperatures,
			If[injectionTableSampleConflictQ,
				PadRight[resolvedGradients, Length[specifiedSampleColumnTemperatures],Null],
				resolvedGradients
			]
		}
	];

	(* Get column temperatures for standard, Blank, ColumnPrime and ColumnFlush from standalone options or InjectionTable *)
	{specifiedStandardColumnTemperatures, standardColumnTemperatureInjectionTableConflictQ} = If[injectionTableSpecifiedQ&&SameLengthQ[Cases[injectionTableLookup, {Standard, ___}],resolvedStandard]&&standardExistsQ,
		Transpose@MapThread[
			If[!MatchQ[#1,Automatic],
				{
					#1,
					(* Cases that we consider injection table to match the standalone options *)
					!Or[
						(* Injection table value is exactly the same as standalone option or Automatic *)
						MatchQ[#2,Automatic|EqualP[#1]],
						(* Both values are Ambient (or $AmbientTemperature) *)
						And[
							MatchQ[#1,Ambient|EqualP[$AmbientTemperature]],
							MatchQ[#2,Ambient|EqualP[$AmbientTemperature]]
						]
					]
				},
				{#2,False}
			]&,
			{
				Lookup[expandedStandardOptions,StandardColumnTemperature],
				Cases[injectionTableLookup, {Standard, ___}][[All, 5]]
			}
		],
		(* Otherwise just use the values from the ColumnTemperature option *)
		{
			Lookup[expandedStandardOptions,StandardColumnTemperature],
			ConstantArray[False,Length[resolvedStandard]]
		}
	];

	{specifiedBlankColumnTemperatures, blankColumnTemperatureInjectionTableConflictQ} = If[injectionTableSpecifiedQ&&SameLengthQ[Cases[injectionTableLookup, {Blank, ___}],resolvedBlank]&&blankExistsQ,
		Transpose@MapThread[
			If[!MatchQ[#1,Automatic],
				{
					#1,
					(* Cases that we consider injection table to match the standalone options *)
					!Or[
						(* Injection table value is exactly the same as standalone option or Automatic *)
						MatchQ[#2,Automatic|EqualP[#1]],
						(* Both values are Ambient (or $AmbientTemperature) *)
						And[
							MatchQ[#1,Ambient|EqualP[$AmbientTemperature]],
							MatchQ[#2,Ambient|EqualP[$AmbientTemperature]]
						]
					]
				},
				{#2,False}
			]&,
			{
				Lookup[expandedBlankOptions,BlankColumnTemperature],
				Cases[injectionTableLookup, {Blank, ___}][[All, 5]]
			}
		],
		(* Otherwise just use the values from the ColumnTemperature option *)
		{
			Lookup[expandedBlankOptions,BlankColumnTemperature],
			ConstantArray[False,Length[resolvedBlank]]
		}
	];

	(* Find the column selection's temperature by position *)
	{specifiedPrimeColumnTemperatures, columnPrimeTemperatureInjectionTableConflictQ,specifiedFlushColumnTemperatures,columnFlushTemperatureInjectionTableConflictQ} = If[columnSelectorQ,
		Transpose@MapThread[
			Module[{columnPrimeResult, columnFlushResult, bestColumnPrimeTemperature, bestColumnFlushTemperature},
				(* See what column prime options we have, using the Column Position from ColumnSelector *)
				columnPrimeResult = Cases[injectionTableLookup, {ColumnPrime, #[[1]], _}][[All, 5]];
				(* Likewise for flush *)
				columnFlushResult = Cases[injectionTableLookup, {ColumnFlush, #[[1]], _}][[All, 5]];
				(* Find the best column prime and flush temperature *)
				bestColumnPrimeTemperature=If[
					MatchQ[#2,Except[Automatic]],
					{
						#2,
						(* Cases that we consider injection table to match the standalone options *)
						!Or[
							(* Injection table value is exactly the same as standalone option or Automatic *)
							MatchQ[FirstCase[columnPrimeResult,TemperatureP,Automatic],Automatic|EqualP[#2]],
							(* Both values are Ambient (or $AmbientTemperature) *)
							And[
								MatchQ[FirstCase[columnPrimeResult,TemperatureP,Automatic],Ambient|EqualP[$AmbientTemperature]],
								MatchQ[#2,Ambient|EqualP[$AmbientTemperature]]
							]
						]
					},
					{FirstCase[columnPrimeResult, TemperatureP, Automatic],False}
				];
				bestColumnFlushTemperature=If[
					MatchQ[#3,Except[Automatic]],
					{
						#3,
						(* Cases that we consider injection table to match the standalone options *)
						!Or[
							(* Injection table value is exactly the same as standalone option or Automatic *)
							MatchQ[FirstCase[columnFlushResult,TemperatureP,Automatic],Automatic|EqualP[#2]],
							(* Both values are Ambient (or $AmbientTemperature) *)
							And[
								MatchQ[FirstCase[columnFlushResult,TemperatureP,Automatic],Ambient|EqualP[$AmbientTemperature]],
								MatchQ[#3,Ambient|EqualP[$AmbientTemperature]]
							]
						]
					},
					{FirstCase[columnFlushResult, TemperatureP, Automatic],False}
				];
				Join[bestColumnPrimeTemperature,bestColumnFlushTemperature]
			]&,
			{
				columnSelectorObjectified,
				Lookup[expandedColumnGradientOptions,ColumnPrimeTemperature],
				Lookup[expandedColumnGradientOptions,ColumnFlushTemperature]
			}
		],
		{
			{},
			{},
			{},
			{}
		}
	];

	(* Resolve the all other column temperatures options now all together*)
	{resolvedStandardColumnTemperatures, resolvedBlankColumnTemperatures, resolvedPrimeColumnTemperatures, resolvedFlushColumnTemperatures} = Map[
		Function[
			{tuple},
			Module[{specifiedTemperatures, gradients},
				{specifiedTemperatures, gradients} = tuple;

				(* Check if there is something, if so then we map over and resolve the temperature *)
				If[MatchQ[gradients, {} | Null],
					Null,
					MapThread[
						Function[
							{temperatureOptionValue, gradientOptionValue},
							(* If option is specified, take option value *)
							If[!MatchQ[temperatureOptionValue, Automatic],
								temperatureOptionValue,
								(* If gradient object is specified, inherit Temperature from gradient object; if it's null, convert to Ambient *)
								If[MatchQ[gradientOptionValue, ObjectP[Object[Method, Gradient]]],
									Lookup[
										fetchPacketFromCache[Download[gradientOptionValue, Object], allGradientMethodPackets],
										Temperature
									]/.{Null :> Ambient},
									(* Otherwise set to sample's ColumnTemperature *)
									First[resolvedColumnTemperatures]
								]
							]
						],
						{specifiedTemperatures, gradients}
					]
				]
			]
		],
		(* In case of InjectionTable and Standard/Blank mismatch, pad to the same length *)
		{
			{
				PadRight[specifiedStandardColumnTemperatures,Length[resolvedStandardGradients],Null],
				resolvedStandardGradients
			},
			{
				PadRight[specifiedBlankColumnTemperatures,Length[resolvedBlankGradients],Null],
				resolvedBlankGradients
			},
			{
				specifiedPrimeColumnTemperatures,
				resolvedColumnPrimeGradients
			},
			{
				specifiedFlushColumnTemperatures,
				resolvedColumnFlushGradients
			}
		}
	];

	(* Check if specified ColumnTemperature in InjectionTable match the standalone ColumnTemperature options *)
	(* ColumnTemperature in ColumnSelector has duplicates *)
	columnTemperatureInjectionTableConflictOptions = If[Or[Or@@columnTemperatureInjectionTableConflictQ, Or@@standardColumnTemperatureInjectionTableConflictQ, Or@@blankColumnTemperatureInjectionTableConflictQ,Or@@columnPrimeTemperatureInjectionTableConflictQ,Or@@columnFlushTemperatureInjectionTableConflictQ],
		If[messagesQ,
			Message[Error::ColumnTemperatureInjectionTableConflict,
				PickList[
					{
						ColumnTemperature,
						StandardColumnTemperature,
						BlankColumnTemperature,
						ColumnPrimeTemperature,
						ColumnFlushTemperature
					},
					{
						Or@@columnTemperatureInjectionTableConflictQ,
						Or@@standardColumnTemperatureInjectionTableConflictQ,
						Or@@blankColumnTemperatureInjectionTableConflictQ,
						Or@@columnPrimeTemperatureInjectionTableConflictQ,
						Or@@columnFlushTemperatureInjectionTableConflictQ
					}
				]
			]
		];
		Join[
			{InjectionTable},
			PickList[
				{
					ColumnTemperature,
					StandardColumnTemperature,
					BlankColumnTemperature,
					ColumnPrimeTemperature,
					ColumnFlushTemperature
				},
				{
					Or@@columnTemperatureInjectionTableConflictQ,
					Or@@standardColumnTemperatureInjectionTableConflictQ,
					Or@@blankColumnTemperatureInjectionTableConflictQ,
					Or@@columnPrimeTemperatureInjectionTableConflictQ,
					Or@@columnFlushTemperatureInjectionTableConflictQ
				}
			]
		],
		{}
	];
	columnTemperatureInjectionTableConflictTest = If[Or[Or@@columnTemperatureInjectionTableConflictQ, Or@@standardColumnTemperatureInjectionTableConflictQ, Or@@blankColumnTemperatureInjectionTableConflictQ,Or@@columnPrimeTemperatureInjectionTableConflictQ,Or@@columnFlushTemperatureInjectionTableConflictQ],
		testOrNull["The ColumnTemperature/ StandardColumnTemperature/ BlankColumnTemperature/ ColumnPrimeTemperature/ ColumnFlushTemperature options match the specified column temperatures in the InjectionTable option:", False],
		testOrNull["The ColumnPosition/ StandardColumnPosition/ BlankColumnPosition options match the specified column positions in the InjectionTable option:", True]
	];

	(* Get the highest flow rate of all the gradients to help resolve *)
	maxInjectionFlowRate = Max[
		Append[
			Cases[
				Flatten[{resolvedFlowRates, resolvedBlankFlowRates, resolvedStandardFlowRates, resolvedColumnPrimeFlowRates, resolvedColumnFlushFlowRates}],
				FlowRateP
			],
			0Milliliter / Minute
		]
	];

	(* Resolve CollectFractions for Scale *)
	(* Set list of all fraction collection options so we can automatically resolve CollectFractions based on if any are specified *)
	fractionCollectionOptions = {
		FractionCollectionStartTime,
		FractionCollectionEndTime,
		FractionCollectionMethod,
		FractionCollectionMode,
		MaxFractionVolume,
		MaxCollectionPeriod,
		AbsoluteThreshold,
		PeakSlope,
		PeakSlopeDuration,
		PeakEndThreshold
	};

	(* Resolve CollectFractions booleans from:
	  - option value
	  - Scale
	  - FractionCollectionDetector
	  - If any other fraction collection options are specified, resolve to True
  	*)
	collectFractions = MapThread[
		If[MatchQ[#1, BooleanP],
			#1,
			If[MatchQ[Lookup[roundedOptionsAssociation, Scale], Preparative | SemiPreparative] || MatchQ[Lookup[roundedOptionsAssociation, FractionCollectionDetector], HPLCDetectorTypeP] || MatchQ[Lookup[roundedOptionsAssociation, FractionCollectionContainer], ObjectP[]],
				True,
				(* If any fraction collection options are specified, resolve to True *)
				If[MemberQ[#2, Except[(Null | Automatic)]],
					True,
					False
				]
			]
		]&,
		{
			Lookup[roundedOptionsAssociation, CollectFractions],
			Transpose[Lookup[roundedOptionsAssociation, fractionCollectionOptions]]
		}
	];

	(* Find where all the fraction options are specified *)
	specifiedFractionBool = Map[
		MatchQ[#, Except[ListableP[(Automatic | Null)]]] &,
		Lookup[roundedOptionsAssociation, fractionCollectionOptions]
	];

	(* We should check whether the user specified conflicting options in regards to fractions *)
	conflictingFractionOptions = If[!(Or@@collectFractions),
		(* If we're ultimately not collecting fractions, we should see if the user specified conflicting options *)
		Flatten@{
			If[MatchQ[Lookup[roundedOptionsAssociation, Scale], SemiPreparative | Preparative], Scale, Nothing],
			If[MatchQ[Lookup[roundedOptionsAssociation, FractionCollectionDetector], HPLCDetectorTypeP], FractionCollectionDetector, Nothing],
			If[MatchQ[Lookup[roundedOptionsAssociation, FractionCollectionContainer], ObjectP[]], FractionCollectionContainer, Nothing],
			PickList[fractionCollectionOptions, specifiedFractionBool]
		}
	];

	(* Do we have more than one option? if so throw a warning *)
	If[Length[conflictingFractionOptions] > 0 && messagesQ && !engineQ,
		Message[Warning::ConflictFractionOptionSpecification, ObjectToString@conflictingFractionOptions]
	];

	(* Resolve the scale. By default we want to go to Analytical unless the user specified fraction collection *)
	resolvedScale = Which[
		(* If user defined *)
		MatchQ[Lookup[roundedOptionsAssociation, Scale], Except[Automatic]], Lookup[roundedOptionsAssociation, Scale],
		(* Did the user specify to collect fractions? *)
		(* The flow rate higher than 8 mL/min -> Preparative (Agilent) *)
		(* Dionex has a MaxFlowRate of 8 mL/min *)
		Or[
			(* If Agilent is requested, we just use Preparative *)
			And[
				!NullQ[specifiedInstrumentModelPackets],
				MemberQ[Lookup[specifiedInstrumentModelPackets, Object], agilentHPLCPattern]
			],
			And[
				Or @@ collectFractions,
				(maxInjectionFlowRate > 8 Milliliter / Minute)
			]
		],
		Preparative,
		(* The flow rate equal to or lower than 10 mL/min -> SemiPreparative (Dionex) *)
		And[
			Or @@ collectFractions,
			(maxInjectionFlowRate <= 8 Milliliter / Minute)
		],
		SemiPreparative,
		(*otherwise, go analytical*)
		True, Analytical
	];

	(* Pause on some resolution of FractionCollection information because Agilent uses the same deck for fraction collection and autosampler. We would like to make sure to resolve a container that best fit the deck *)

	(* Resolve the injection volumes *)

	(* Extract shared options relevant for aliquotting *)
	aliquotOptions = KeySelect[samplePrepOptions, And[MatchQ[#, Alternatives @@ ToExpression[Options[AliquotOptions][[All, 1]]]], MemberQ[Keys[samplePrepOptions], #]]&];

	(* NOTE: handling this dead volume should change once we have a better dead volume handling system because the dead volume will change for each instrument based on what container model is being used *)
	(* This is tricky right now since we resolve instrument model/object later with this volume and container grouping information *)
	autosamplerDeadVolume = Which[
		internalUsageQ, 40 Microliter,
		(* Model[Instrument, HPLC, "Agilent 1290 Infinity II LC System"] has a very large dead volume, we use it if we are told to use this instrument OR if we have resolved to be Preparative *)
		Or[
			And[
				!NullQ[specifiedInstrumentModelPackets],
				MemberQ[Lookup[specifiedInstrumentModelPackets, Object], agilentHPLCPattern]
			],
			MatchQ[resolvedScale, Preparative]
		],
		5 Milliliter,
		True, 40 Microliter
	];

	(* Find the possible injection volume range *)
	defaultInjectionVolume = Which[
		MatchQ[resolvedScale, Preparative], 5 Milliliter, (* Model[Instrument, HPLC, "Agilent 1290 Infinity II LC System"] *)
		MatchQ[resolvedScale, SemiPreparative], 500 Microliter,
		MatchQ[resolvedScale, Analytical],
		If[!NullQ[specifiedInstrumentModelPackets] && MemberQ[Lookup[specifiedInstrumentModelPackets, Object], agilentHPLCPattern],
			200 Microliter, (* For Model[Instrument, HPLC, "Agilent 1290 Infinity II LC System"] Analytical runs *)
			10 Microliter
		],
		True, 10 Microliter
	];

	(* Extract our the Injection Volume from the InjectionTable *)
	injectionTableSampleInjectionVolumes = If[injectionTableSpecifiedQ && !injectionTableSampleConflictQ,
		Cases[injectionTableLookup, {Sample, ___}][[All, 3]],
		(* Otherwise pad Automatic to match length of mySamples *)
		ConstantArray[Automatic, Length[mySamples]]
	];

	(*
		Resolve InjectionVolume for analyte runs based on:
		- Input option value
		- the Injection table value
		- aliquot volume
		- or default to defaultInjectionVolume depending on the scale and instrument
	*)
	resolvedInjectionVolumes = MapThread[
		Function[{inputSamplePacket, samplePacket, injectionTableVolume, aliquotQ, aliquotVolume, injectionVolume},
			Which[
				MatchQ[injectionVolume, VolumeP], injectionVolume,
				MatchQ[injectionTableVolume, VolumeP], injectionTableVolume,
				(* Give solid sample a default volume to avoid duplicate errors *)
				MatchQ[Lookup[samplePacket, State], Solid],defaultInjectionVolume,
				TrueQ[aliquotQ],
				If[MatchQ[aliquotVolume, UnitsP[Microliter]],
					(* Just in case we have a small aliquot volume, make sure we are not getting a negative value *)
					Min[aliquotVolume - autosamplerDeadVolume, defaultInjectionVolume] /. {amount : LessEqualP[5Microliter] :> defaultInjectionVolume},
					If[MatchQ[Lookup[samplePacket, Volume], VolumeP],
						Min[
							Divide[
								Lookup[samplePacket, Volume],
								(Count[Download[mySamples, Object], Lookup[inputSamplePacket, Object]] * numberOfReplicates) /. {0 -> 1}
							] - autosamplerDeadVolume,
							defaultInjectionVolume
						] /. {amount : LessEqualP[5Microliter] :> defaultInjectionVolume},
						defaultInjectionVolume
					]
				],
				True,
				If[MatchQ[Lookup[samplePacket, Volume], VolumeP],
					If[MatchQ[resolvedScale, SemiPreparative | Preparative],
						Which[
							TrueQ[
								Divide[
									Lookup[samplePacket, Volume],
									(Count[Download[mySamples, Object], Lookup[inputSamplePacket, Object]] * numberOfReplicates) /. {0 -> 1}
								] <= (defaultInjectionVolume - autosamplerDeadVolume)
							],
							Max[
								Divide[
									Lookup[samplePacket, Volume],
									(Count[Download[mySamples, Object], Lookup[inputSamplePacket, Object]] * numberOfReplicates) /. {0 -> 1}
								] - autosamplerDeadVolume,
								10 Microliter
							],
							TrueQ[
								Divide[
									Lookup[samplePacket, Volume],
									(Count[Download[mySamples, Object], Lookup[inputSamplePacket, Object]] * numberOfReplicates) /. {0 -> 1}
								] >= (defaultInjectionVolume + autosamplerDeadVolume)
							],
							defaultInjectionVolume,
							True,
							Max[
								Divide[
									Lookup[samplePacket, Volume],
									(Count[Download[mySamples, Object], Lookup[inputSamplePacket, Object]] * numberOfReplicates) /. {0 -> 1}
								] - autosamplerDeadVolume,
								10 Microliter
							]
						],
						Min[
							Divide[
								Lookup[samplePacket, Volume],
								(Count[Download[mySamples, Object], Lookup[inputSamplePacket, Object]] * numberOfReplicates) /. {0 -> 1}
							] - autosamplerDeadVolume,
							defaultInjectionVolume
						] /. {amount : LessEqualP[5Microliter] :> defaultInjectionVolume}
					],
					defaultInjectionVolume
				]
			]
		],
		{
			samplePackets,
			simulatedSamplePackets,
			injectionTableSampleInjectionVolumes,
			Lookup[aliquotOptions, Aliquot, ConstantArray[Automatic, Length[mySamples]]],
			Lookup[aliquotOptions, AliquotAmount, ConstantArray[Automatic, Length[mySamples]]],
			Lookup[roundedOptionsAssociation, InjectionVolume]
		}
	];

	(* Resolve the Standard injection volumes *)
	(* Extract standard injection volume from the injection table *)
	injectionTableStandardInjectionVolumes = If[injectionTableSpecifiedQ,
		(* As always, we must adjust the size if there is misspecification *)
		PadRight[Cases[injectionTableLookup, {Standard, ___}][[All, 3]], Length[ToList@resolvedStandard], Automatic],
		(* Otherwise pad Automatic *)
		ConstantArray[Automatic, Length[ToList@resolvedStandard]]
	];

	resolvedStandardInjectionVolumes = If[standardExistsQ,
		MapThread[
			Function[{injectionVolumeValue, injectionTableValue},
				Which[
					(* User specified *)
					MatchQ[injectionVolumeValue, VolumeP], injectionVolumeValue,
					(* InjectionTable specified *)
					MatchQ[injectionTableValue, VolumeP], injectionTableValue,
					(* Otherwise default to the first resolution *)
					True, First[resolvedInjectionVolumes]
				]
			],
			{
				Lookup[expandedStandardOptions, StandardInjectionVolume],
				injectionTableStandardInjectionVolumes
			}
		],
		Null
	];

	(* Resolve the Blank injection volumes *)
	(* Extract blank injection volume from the injection table *)
	injectionTableBlankInjectionVolumes = If[injectionTableSpecifiedQ,
		PadRight[Cases[injectionTableLookup, {Blank, ___}][[All, 3]], Length[ToList@resolvedBlank], Automatic],
		(* Otherwise pad Automatic *)
		ConstantArray[Automatic, Length[ToList@resolvedBlank]]
	];

	resolvedBlankInjectionVolumes = If[blankExistsQ,
		MapThread[
			Function[{injectionVolumeValue, injectionTableValue},
				Which[
					(*user specified*)
					MatchQ[injectionVolumeValue, VolumeP], injectionVolumeValue,
					(*injectionTable specified*)
					MatchQ[injectionTableValue, VolumeP], injectionTableValue,
					(*otherwise default to the first resolution*)
					True, First@resolvedInjectionVolumes
				]
			],
			{
				Lookup[expandedBlankOptions, BlankInjectionVolume],
				injectionTableBlankInjectionVolumes
			}
		],
		Null
	];

	(* Group injection volumes for each unique sample *)
	groupedVolumes = GatherBy[
		Transpose[{samplePackets, resolvedInjectionVolumes}],
		#[[1]]&
	];

	(* If the total injected volume for a sample is greater than its volume, throw error. we don't worry about this, if the samples are solid *)
	validSampleVolumesQ = Map[
		Or[
			MatchQ[Lookup[#[[1, 1]], State], Solid],
			TrueQ[Lookup[#[[1, 1]], Volume] >= (Total[#[[All, 2]]] + autosamplerDeadVolume)]
		]&,
		groupedVolumes
	];

	(* Extract list of objects with insufficient volume *)
	samplesWithInsufficientVolume = PickList[
		Lookup[#[[1, 1]], Object]& /@ groupedVolumes,
		validSampleVolumesQ,
		False
	];

	(* Build test for sample volume sufficiency. *)
	insufficientVolumeTest = If[!(And @@ validSampleVolumesQ),
		(
			If[messagesQ && !engineQ,
				Message[Warning::InsufficientSampleVolume, ObjectToString /@ samplesWithInsufficientVolume, autosamplerDeadVolume]
			];
			testOrNull["All samples have sufficient volume for the requested injection volume:", False]
		),
		testOrNull["All samples have sufficient volume for the requested injection volume:", True]
	];

	(* --- Container Counting AND Resolve Aliquot Options ---*)

	(* Extract list of Aliquot bools *)
	specifiedAliquotBools = Lookup[aliquotOptions, Aliquot];

	(* Preresolve ConsolidateAliquots based on the user option and the volume of the sample *)

	(* If we end up aliquoting and AliquotAmount is not specified, it is possible we need to force AliquotVolume to be the appropriate InjectionVolume. *)
	preResolvedRequiredAliquotVolumes = MapThread[
		Function[
			{samplePacket, injectionVolume, aliquotVolume},
			Which[
				MatchQ[aliquotVolume, VolumeP], aliquotVolume,
				MatchQ[injectionVolume, VolumeP],
				(* Distribute autosampler dead volume across all instances of an identical aliquots with the consideration that we will consolidate aliquots *)
				Total[{
					injectionVolume,
					Divide[
						autosamplerDeadVolume,
						Count[Download[mySamples, Object], Lookup[samplePacket, Object]] * numberOfReplicates
					]
				}],
				(* We should never enter here since we have resolved InjectionVolume earlier but we want to be extremely safe and give a default *)
				True,
				If[MatchQ[Lookup[samplePacket, Volume], VolumeP],
					If[MatchQ[Lookup[roundedOptionsAssociation, Scale], SemiPreparative | Preparative],
						Lookup[samplePacket, Volume],
						Min[
							Lookup[samplePacket, Volume],
							Total[{
								25 Microliter,
								Divide[
									autosamplerDeadVolume,
									Count[Download[mySamples, Object], Lookup[samplePacket, Object]] * numberOfReplicates
								]
							}]
						]
					],
					Total[{
						25 Microliter,
						Divide[
							autosamplerDeadVolume,
							Count[Download[mySamples, Object], Lookup[samplePacket, Object]] * numberOfReplicates
						]
					}]
				]
			]
		],
		{
			samplePackets,
			resolvedInjectionVolumes,
			Lookup[aliquotOptions, AliquotAmount]
		}
	];

	(* Group the sample together with volume and pick the possible aliquoting ones *)
	possibleAliquotingSamplesTuples = PickList[
		Transpose[
			{
				mySamples,
				Lookup[aliquotOptions, AliquotContainer],
				Lookup[aliquotOptions, DestinationWell],
				preResolvedRequiredAliquotVolumes
			}
		],
		specifiedAliquotBools,
		True | Automatic
	];

	(* Group same sample together if they can be in the same container *)
	groupedAliquotingSamplesTuples = Gather[
		possibleAliquotingSamplesTuples,
		And[
			(* Same sample *)
			MatchQ[First[#1], First[#2]],
			(* Automatic or same aliquot container *)
			Or[
				MatchQ[#1[[2]], #2[[2]] | Automatic],
				MatchQ[#2[[2]], Automatic]
			],
			(* Automatic or same destination well *)
			Or[
				MatchQ[#1[[3]], #2[[3]] | Automatic],
				MatchQ[#2[[3]], Automatic]
			]
		]&
	];

	volumeFitAliquotContainerQ = Map[
		Function[{sampleEntry},
			Module[
				{totalVolume, maxVolume, containerPacket, defaultContainer, container},
				defaultContainer = If[
					Or[
						And[
							!NullQ[specifiedInstrumentModelPackets],
							MemberQ[Lookup[specifiedInstrumentModelPackets, Object], agilentHPLCPattern]
						],
						MatchQ[resolvedScale, Preparative]
					],
					(* For Model[Instrument, HPLC, "Agilent 1290 Infinity II LC System"], we can use 15mL Tube or 50mL Tube. We default to 50mL Tube to hold larger volume when possible, as our default InjectionVolume is 5 mL. *)
					(* Model[Container, Vessel, "50mL Tube"] *)
					Model[Container, Vessel, "id:bq9LA0dBGGR6"],
					(* Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
					Model[Container, Plate, "id:L8kPEjkmLbvW"]
				];
				container = Which[
					MatchQ[sampleEntry[[1, 2]], {_, ObjectP[]}], sampleEntry[[1, 2, 2]],
					MatchQ[sampleEntry[[1, 2]], ObjectP[]], sampleEntry[[1, 2]],
					True, defaultContainer
				];
				totalVolume = Total[sampleEntry[[All, 4]]];
				containerPacket = If[MatchQ[container, ObjectP[Model]],
					fetchPacketFromCacheHPLC[container, simulatedCache],
					fetchModelPacketFromCacheHPLC[container, simulatedCache]
				];
				maxVolume = If[MatchQ[containerPacket, PacketP[]],
					Lookup[containerPacket, MaxVolume, Infinity * Microliter],
					Infinity * Microliter
				];
				TrueQ[totalVolume * numberOfReplicates <= maxVolume]
			]
		],
		groupedAliquotingSamplesTuples
	];

	preresolvedConsolidateAliquots = If[!MatchQ[Lookup[aliquotOptions, ConsolidateAliquots], Automatic],
		(* Always go with user option *)
		Lookup[aliquotOptions, ConsolidateAliquots],
		(* If the total volumes are too large, do not consolidate *)
		!MemberQ[volumeFitAliquotContainerQ, False]
	];

	(* Extract all samples that could be aliquotted (ie: definitely cannot be aliquotted) *)
	(* NOTE: We need to consider if the samples are consolidated or not *)
	uniqueAliquotableSamples = If[preresolvedConsolidateAliquots,
		DeleteDuplicates[PickList[simulatedSamples, specifiedAliquotBools, True | Automatic]],
		Flatten[ConstantArray[PickList[simulatedSamples, specifiedAliquotBools, True | Automatic], numberOfReplicates]]
	];

	(* Find unique containers for samples that definitely cannot be aliquotted *)
	(* Plates are for Dionex and Waters instruments *)
	uniqueNonAliquotablePlates = DeleteDuplicates@Cases[
		PickList[simulatedSampleContainers, specifiedAliquotBools, False],
		ObjectP[Object[Container, Plate]]
	];
	(* Vessels are for Dionex and Waters instruments *)
	uniqueNonAliquotableVessels = DeleteDuplicates@PickList[
		simulatedSampleContainers,
		Transpose[{specifiedAliquotBools, simulatedSampleContainerModels}],
		(* {Model[Container, Vessel, "HPLC vial (high recovery)"], Model[Container, Vessel, "1mL HPLC Vial (total recovery)"], Model[Container, Vessel, "Amber HPLC vial (high recovery)"], Model[Container, Vessel, "HPLC vial (high recovery), LCMS Certified"]} *)
		{False, ObjectP[{Model[Container, Vessel, "id:jLq9jXvxr6OZ"], Model[Container, Vessel, "id:1ZA60vL48X85"], Model[Container, Vessel, "id:GmzlKjznOxmE"], Model[Container, Vessel, "id:3em6ZvL8x4p8"]}]}
	];

	(* For Agilent, split uniqueNonAliquotableVessels into two parts with different models *)
	uniqueNonAliquotableSmallVessels = DeleteDuplicates@PickList[
		simulatedSampleContainers,
		Transpose[{specifiedAliquotBools, simulatedSampleContainerModels}],
		(* Model[Container, Vessel, "15mL Tube"] *)
		{False, ObjectP[{Model[Container, Vessel, "id:xRO9n3vk11pw"], Model[Container, Vessel, "id:rea9jl1orrMp"]}]}
	];

	uniqueNonAliquotableLargeVessels = DeleteDuplicates@PickList[
		simulatedSampleContainers,
		Transpose[{specifiedAliquotBools, simulatedSampleContainerModels}],
		(* Model[Container, Vessel, "50mL Tube"] *)
		{False, ObjectP[{Model[Container, Vessel, "id:bq9LA0dBGGR6"],Model[Container, Vessel, "id:bq9LA0dBGGrd"]}]}
	];

	(* Also track the samples that are not in suitable containers and cannot be aliquoted *)
	uniqueNonSuitableContainers = DeleteDuplicates@Complement[
		PickList[simulatedSampleContainers,specifiedAliquotBools,False],
		uniqueNonAliquotableSmallVessels,
		uniqueNonAliquotableLargeVessels
	];

	(* Since checks for too-many-samples could depend on how many standard and blank containers will be required, we need to determine these container counts based on how many standards/blanks exist, their injection volumes, and injection frequency.
	Standards/blanks specified by models may have to run across multiple containers if their total injection volume is greater than the max volume of the default standard/blank container. *)

	(* Define the default container used for standards/blanks *)
	defaultStandardBlankContainer = If[
		Or[
			And[
				!NullQ[specifiedInstrumentModelPackets],
				MemberQ[Lookup[specifiedInstrumentModelPackets, Object, {}], agilentHPLCPattern]
			],
			MatchQ[resolvedScale, Preparative]
		],
		(* Use 50mL Tube if we are going to have Agilent from user option or we have to go with it since we are Preparative *)
		Model[Container, Vessel, "50mL Tube"],
		(* It might be possible that we will end up using the Amber one in resource packet but all models hold the same max volume so will not change our result here *)
		Model[Container, Vessel, "HPLC vial (high recovery)"]
	];

	(* Fetch the max volume of the standard/blank container *)
	standardBlankContainerMaxVolume = Lookup[fetchPacketFromCacheHPLC[defaultStandardBlankContainer, cache], MaxVolume];

	(* Define the max usable volume in the standard/blank containers when considering dead volume *)
	standardBlankSampleMaxVolume = (standardBlankContainerMaxVolume - autosamplerDeadVolume);

	(* Generate tuples of standard/blank and its injection volume in the form: {{standard1, volume1}, {standard1, volume2}, {standard1, volume3}, {standard2, volume1}..} *)
	{standardInjectionTuples, blankInjectionTuples} = {
		Transpose[{
			If[MatchQ[resolvedStandard, Null], {}, resolvedStandard],
			If[MatchQ[resolvedStandardInjectionVolumes, {Null} | Null], {}, resolvedStandardInjectionVolumes]
		}],
		Transpose[{
			If[MatchQ[resolvedBlank, Null], {}, resolvedBlank],
			If[MatchQ[resolvedBlankInjectionVolumes, {Null} | Null], {}, resolvedBlankInjectionVolumes]
		}]
	};

	(* Expand the standard/blank injections based on the frequency they will be injected *)
	(* If the InjectionTable is specified, we have resolved xxxFrequency to be Null and we will keep the {standardInjectionTuples, blankInjectionTuples} as they are and the resolution of the Blanks/Standards and volumes already considered the possible conflict between InjectionTable and the stand-alone Standard/Blank options *)
	{expandedStandardInjectionTuples, expandedBlankInjectionTuples} = MapThread[
		Function[{tuples, frequency},
			Switch[frequency,
				First | Last,
				tuples,
				FirstAndLast,
				Join @@ Table[tuples, 2],
				GradientChange,
				Join @@ Table[tuples, Length[DeleteDuplicates[resolvedAnalyteGradients]]],
				_Integer,
				Join @@ Table[tuples, Length@Range[1, Length[mySamples], frequency]],
				_,
				tuples
			]
		],
		{{standardInjectionTuples, blankInjectionTuples}, {standardFrequency, blankFrequency}}
	];

	(* Gather tuples of standard/blank and its injection volume by the standard model/sample requested in the form {{{standard1, volume1}, {standard1, volume2}, {standard1, volume3}}, {{standard2, volume1}}..} *)
	{gatheredStandardInjectionTuples, gatheredBlankInjectionTuples} = Map[
		GatherBy[#, First]&,
		{expandedStandardInjectionTuples, expandedBlankInjectionTuples}
	];

	(* Group each set of tuples of a given standard/blank into sets whose total injection volume is less than the max usable volume of the standard/blank container. Output partitions will be in the form: {{{standard1, volume1}, {standard1, volume2}}, {{standard1, volume2}}, {{standard2, volume3}}..}
	where volume1+volume2 <= max volume but volume1+volume2+volume3 > max volume (therefore volume3 spills over into another container) *)
	{standardPartitions, blankPartitions} = Map[
		(Join @@ (GroupByTotal[Replace[#[[All, 2]], Null -> 0 Microliter, {1}], standardBlankSampleMaxVolume]& /@ #))&,
		{gatheredStandardInjectionTuples, gatheredBlankInjectionTuples}
	];

	(* The number of standard containers we'll require is the number of partitions *)
	numberOfStandardBlankContainersRequired = Length[Join[standardPartitions, blankPartitions]];

	(* Now we figure out what instruments are able to accommodate the samples. This is hard-coded because implementing the footprint system would be difficult. *)

	(* Dionex Instrument - Count the samples, Standards, Blanks and containers for the Dionex Ultimate 3000 instrument *)
	(* Dionex has 2 * plate positions and 1 rack position, room for:
		- 48 vials AND 2 plates
	*)
	validDionexCountQ = And[
		Or[
			(* If aliquotable samples can all fit in a DWP, then there can exist 1 non aliquotable plate *)
			And[
				Length[uniqueAliquotableSamples] <= 96,
				Length[uniqueNonAliquotablePlates] <= 1
			],
			(* If there are no aliquotable samples, then there must exist two or fewer non aliquotable plates *)
			And[
				Length[uniqueAliquotableSamples] == 0,
				Length[uniqueNonAliquotablePlates] <= 2
			],
			(* If all samples can be aliquotted, they must fit in fewer than 2 plates *)
			And[
				Length[uniqueAliquotableSamples] <= (96 * 2),
				Length[uniqueNonAliquotablePlates] == 0
			]
		],
		(* <= 48 vials *)
		Total[Length[uniqueNonAliquotableVessels],numberOfStandardBlankContainersRequired] <= 48
	];

	(* Waters Instrument - Count the samples, Standards, Blanks and containers for the Waters Acquity instrument *)
	(* Waters has 2 autosampler positions, room for:
		- 96 vials, 0 plates
		- 48 vials, 1 plate
		- 2 plates, 0 vials (no standard/blank/vial samples)
	*)
	validWatersCountQ = Or[
		(* If non-aliquotable samples and aliquotable samples exist, the non-aliquotable samples must be in at-most 1 plate and the aliquotable samples must be already - in or transferred to vials, therefore there must be <= (48 - number of standard vials - number of blank vials - non aliquotable vials) *)
		And[
			Length[uniqueNonAliquotablePlates] <= 1,
			Length[uniqueAliquotableSamples] <= (48 - numberOfStandardBlankContainersRequired - Length[uniqueNonAliquotableVessels])
		],
		(* If non-aliquotable samples are all in vials, then the number of aliquottable samples must fit in 1 plate *)
		And[
			Length[uniqueNonAliquotablePlates] == 0,
			Length[uniqueAliquotableSamples] <= (96 - numberOfStandardBlankContainersRequired - Length[uniqueNonAliquotableVessels])
		],
		(* If just plates and no Standards/Blanks *)
		And[
			Length[uniqueNonAliquotablePlates] == 2,
			numberOfStandardBlankContainersRequired == 0,
			Length[uniqueNonAliquotableVessels] == 0
		]
	];

	(* Agilent Instrument - Count the samples, Standards, Blanks and containers for the Agilent 1290 instrument *)
	(* Agilent has 6 autosampler positions for racks.
		All racks:
			{Model[Container, Rack, "30 x 100 mm Tube Container for Preparative HPLC"],
Model[Container, Rack, "16 x 100 mm Tube Container for Preparative HPLC"],}
		We will use update to 5 racks if collection fractions (saving at least 1 for fractions since they share the same deck; 6 racks if not.
		Model[Container, Rack, "16 x 100 mm Tube Container for Preparative HPLC"] - 36 positions
		Model[Container, Rack, "30 x 100 mm Tube Container for Preparative HPLC"] - 10 positions
	*)
	agilentRackPositionRules=Map[
		Module[
			{rackPacket},
			rackPacket=fetchPacketFromCache[#,cache];
			#->(Lookup[rackPacket,NumberOfPositions]/.{Null->10})
		]&,
		(* Model[Container, Rack, "16 x 100 mm Tube Container for Preparative HPLC"] and Model[Container, Rack, "30 x 100 mm Tube Container for Preparative HPLC"] *)
		{Experiment`Private`$SmallAgilentHPLCAutosamplerRack,Experiment`Private`$LargeAgilentHPLCAutosamplerRack}
	];
	agilentSmallRackCount = Ceiling[Length[uniqueNonAliquotableSmallVessels]/(Lookup[agilentRackPositionRules,Experiment`Private`$SmallAgilentHPLCAutosamplerRack])];
	agilentLargeRackCount = Ceiling[(Length[uniqueNonAliquotableLargeVessels]+Length[uniqueAliquotableSamples]+numberOfStandardBlankContainersRequired)/(Lookup[agilentRackPositionRules,Experiment`Private`$LargeAgilentHPLCAutosamplerRack])];
	requestedFractionRack = Which[
		MatchQ[Lookup[roundedOptionsAssociation, FractionCollectionContainer],ObjectP[{Model[Container, Vessel, "id:xRO9n3vk11pw"], Model[Container, Vessel, "id:rea9jl1orrMp"]}]],
		Small,
		MatchQ[Lookup[roundedOptionsAssociation, FractionCollectionContainer],ObjectP[{Model[Container, Vessel, "id:bq9LA0dBGGR6"], Model[Container, Vessel, "id:bq9LA0dBGGrd"]}]],
		Large,
		True,Null
	];
	validAgilentCountQ = If[Or @@ collectFractions,
		(* non aliquotable samples - we check for each type it is below the limit *)
		(* Aliquotable samples - we always use 50mL tube so we count that only *)
		And[
			Total[
				agilentSmallRackCount,
				agilentLargeRackCount
			] <= 5,
			agilentSmallRackCount+If[MatchQ[requestedFractionRack,Small],1,0]<=3,
			agilentLargeRackCount+If[MatchQ[requestedFractionRack,Large],1,0]<=3,
			Length[uniqueNonSuitableContainers]==0
		],
		And[
			Total[
				agilentSmallRackCount,
				agilentLargeRackCount
			] <= 6,
			Length[uniqueNonSuitableContainers]==0
		]
	];

	(* If an instrument is already provided, we can directly check whether it is valid and throw error *)
	validContainerCountQ = If[!NullQ[specifiedInstrumentModelPackets],
		Or@@Map[
			Which[
				MatchQ[Lookup[#, Object], dionexHPLCPattern],
				validDionexCountQ,
				MatchQ[Lookup[#, Object], agilentHPLCPattern],
				validAgilentCountQ,
				(* Waters *)
				True,
				validWatersCountQ
			]&,
			specifiedInstrumentModelPackets
		],
		Or[validDionexCountQ, validWatersCountQ, validAgilentCountQ]
	];

	(* Build test for container count validity *)
	containerCountTest = If[!validContainerCountQ,
		(
			If[messagesQ,
				Message[Error::HPLCTooManySamples]
			];
			tooManyInvalidInputs = mySamples;
			testOrNull["The number of sample and/or aliquot containers can fit on the instrument's autosampler:", False]
		),
		(
			tooManyInvalidInputs = {};
			testOrNull["The number of sample and/or aliquot containers can fit on the instrument's autosampler:", True]
		)
	];

	(* Finish resolution of more fraction collection options *)
	(* Resolve fraction CollectionContainer based on Scale *)
	resolvedFractionCollectionContainer = Which[
		(* Take the container that the user specifies *)
		MatchQ[Lookup[roundedOptionsAssociation, FractionCollectionContainer], Except[Automatic]], Lookup[roundedOptionsAssociation, FractionCollectionContainer],
		Or[
			And[
				!NullQ[specifiedInstrumentModelPackets],
				MemberQ[Lookup[specifiedInstrumentModelPackets, Object, {}], agilentHPLCPattern]
			],
			MatchQ[resolvedScale, Preparative]
		],
		(* Use 50mL Tube if we are going to have Agilent from user option or we have to go with it since we are Preparative *)
		If[TrueQ[agilentLargeRackCount<=2],
			Model[Container, Vessel, "id:bq9LA0dBGGR6"],
			Model[Container, Vessel, "id:xRO9n3vk11pw"]
		],
		(* Dionex - "96-well 2mL Deep Well Plate" *)
		MatchQ[resolvedScale, SemiPreparative], Model[Container, Plate, "id:L8kPEjkmLbvW"],
		True, Null
	];

	(* Throw an error message if the fraction collection container is not valid *)
	invalidFractionCollectionContainerOption = Which[
		Or[
			And[
				!NullQ[specifiedInstrumentModelPackets],
				MemberQ[Lookup[specifiedInstrumentModelPackets, Object, {}], agilentHPLCPattern]
			],
			MatchQ[resolvedScale, Preparative]
		],
		(* Agilent allows 50 mL tube or 15 mL tube *)
		(* {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "15mL Tube"], Model[Container, Vessel, "50mL Light Sensitive Centrifuge Tube"], Model[Container, Vessel, "15mL Light Sensitive Centrifuge Tube"]} *)
		If[MemberQ[{Model[Container, Vessel, "id:bq9LA0dBGGR6"],Model[Container, Vessel, "id:xRO9n3vk11pw"],Model[Container, Vessel, "id:bq9LA0dBGGrd"],Model[Container, Vessel, "id:rea9jl1orrMp"]},Download[resolvedFractionCollectionContainer,Object]],
			{},
			Message[Error::InvalidFractionCollectionContainer, resolvedFractionCollectionContainer, Preparative, ObjectToString/@{Model[Container, Vessel, "id:bq9LA0dBGGR6"],Model[Container, Vessel, "id:xRO9n3vk11pw"],Model[Container, Vessel, "id:bq9LA0dBGGrd"],Model[Container, Vessel, "id:rea9jl1orrMp"]}];
			{FractionCollectionContainer}
		],
		MatchQ[resolvedScale, SemiPreparative],
		If[MatchQ[Download[resolvedFractionCollectionContainer,Object],Model[Container, Plate, "id:L8kPEjkmLbvW"]],
			{},
			Message[Error::InvalidFractionCollectionContainer, resolvedFractionCollectionContainer, SemiPreparative, ObjectToString[Model[Container, Plate, "id:L8kPEjkmLbvW"]]];
			{FractionCollectionContainer}
		],
		True,
		{}
	];

	fractionCollectionContainerTest = If[!MatchQ[invalidFractionCollectionContainerOption,{}],
		testOrNull["The selected FractionCollectionContainer is compatible with the Scale and Instrument options:", False],
		testOrNull["The selected FractionCollectionContainer is compatible with the Scale and Instrument options:", True]
	];

	resolvedFractionCollectionContainerMaxVolume = If[NullQ[resolvedFractionCollectionContainer],
		Null,
		Lookup[fetchPacketFromCacheHPLC[resolvedFractionCollectionContainer,cache],MaxVolume,2 Milliliter]
	];


	(* Resolve other FractionCollection Options *)
	(* Find the position for any objects specified in the FractionCollectionMethod option *)
	fractionCollectionObjectPositions = Flatten@Position[Lookup[roundedOptionsAssociation, FractionCollectionMethod], ObjectP[Object[Method, FractionCollection]], {1}];

	(* Extract any specified method objects for below Download *)
	fractionCollectionObjects = Lookup[roundedOptionsAssociation, FractionCollectionMethod][[fractionCollectionObjectPositions]];

	(* If fraction collection method packets are downloaded, they will be in nested lists *)
	fractionCollectionPackets = If[MatchQ[fractionCollectionObjects, {}],
		Table[Null, Length[mySamples]],
		fetchPacketFromCacheHPLC[#, cache]& /@ Lookup[roundedOptionsAssociation, FractionCollectionMethod]
	];

	(* If collecting fractions, fetch mode from: option value if specified, otherwise fraction method if specified, otherwise default to Threshold if other options are not specified *)
	fractionCollectionModes = MapThread[
		Function[
			{collectFractionsQ, mode, methodPacket, absThreshold, peakSlope, peakMinimumDuration, peakSlopeEnd, maxCollectPeriod},
			Which[
				MatchQ[mode, Except[Automatic]], mode,
				Not[collectFractionsQ], Null,
				MatchQ[methodPacket, PacketP[Object[Method, FractionCollection]]], Lookup[methodPacket, FractionCollectionMode],
				MatchQ[absThreshold, Except[Automatic | Null]], Threshold,
				MatchQ[peakSlope, Except[Automatic | Null]] || MatchQ[peakMinimumDuration, UnitsP[Second]] || MatchQ[peakSlopeEnd, Except[Automatic | Null]], Peak,
				MatchQ[maxCollectPeriod, UnitsP[Second]], Time,
				True, Threshold
			]
		],
		{
			collectFractions,
			Lookup[roundedOptionsAssociation, FractionCollectionMode],
			fractionCollectionPackets,
			Lookup[roundedOptionsAssociation, AbsoluteThreshold],
			Lookup[roundedOptionsAssociation, PeakSlope],
			Lookup[roundedOptionsAssociation, PeakSlopeDuration],
			Lookup[roundedOptionsAssociation, PeakEndThreshold],
			Lookup[roundedOptionsAssociation, MaxCollectionPeriod]
		}
	];

	(* If collecting fractions, fetch collection start time from: option value if specified, otherwise fraction method if specified, otherwise default to second timepoint of gradient, unless that is the final point (resolve to first point in that case) *)
	fractionCollectionStartTimes = MapThread[
		If[TrueQ[#1],
			Which[
				!MatchQ[#2,Automatic],
				#2,
				MatchQ[#3,PacketP[]],
				Lookup[#3,FractionCollectionStartTime],
				TrueQ[Length[#4]<=2],
				Sort[#4[[All,1]]][[1]],
				True,
				Sort[#4[[All,1]]][[2]]
			],
			Null
		]&,
		{
			collectFractions,
			Lookup[roundedOptionsAssociation, FractionCollectionStartTime],
			fractionCollectionPackets,
			resolvedAnalyteGradients
		}
	];

	(* If collecting fractions, fetch collection end time from: option value if specified, otherwise fraction method if specified, otherwise default to last timepoint of gradient *)
	fractionCollectionEndTimes = MapThread[
		If[TrueQ[#1],
			If[!MatchQ[#2, Automatic],
				#2,
				If[MatchQ[#3, PacketP[]],
					Lookup[#3, FractionCollectionEndTime],
					Last[Sort[#4[[All, 1]]]]
				]
			],
			Null
		]&,
		{
			collectFractions,
			Lookup[roundedOptionsAssociation, FractionCollectionEndTime],
			fractionCollectionPackets,
			resolvedAnalyteGradients
		}
	];

	(* FractionCollectionEndTime cannot be greater than the last timepoint of a gradient *)
	validFractionCollectionEndTimeBools = MapThread[
		!And[MatchQ[#1, TimeP], TrueQ[#1 > Last[#2]]]&,
		{fractionCollectionEndTimes, resolvedAnalyteGradients[[All, All, 1]]}
	];

	(* If a FractionCollectionEndTime is greater than the last timepoint of a gradient, throw error *)
	fractionCollectionEndTimeTest = If[!(And @@ validFractionCollectionEndTimeBools),
		(
			If[messagesQ,
				Message[Error::InvalidFractionCollectionEndTime, PickList[fractionCollectionEndTimes, validFractionCollectionEndTimeBools, False]]
			];
			validFractionCollectionEndTimeQ = False;
			testOrNull["All specified FractionCollectionEndTime values are less than the corresponding gradient's duration:", False]
		),
		testOrNull["All specified FractionCollectionEndTime values are less than the corresponding gradient's duration:", True]
	];

	(* If collecting fractions, fetch max fraction volume from: option value if specified, calculated from max period and flow rate, fraction method, or default to 1.8mL *)
	maxFractionVolumes = MapThread[
		Function[{collectQ, maxVolume, maxPeriod, methodPacket, flowRateTuples},
			If[TrueQ[collectQ],
				Which[
					!MatchQ[maxVolume, Automatic], maxVolume,
					!MatchQ[maxPeriod, Automatic], (flowRateTuples[[1]]) * maxPeriod,
					MatchQ[methodPacket, PacketP[]], Lookup[methodPacket, MaxFractionVolume, Null],
					(* Fill to 90% of the collection container's MaxVolume *)
					MatchQ[resolvedFractionCollectionContainerMaxVolume,VolumeP],Round[resolvedFractionCollectionContainerMaxVolume*0.9,0.1Milliliter],
					MatchQ[resolvedScale, SemiPreparative], 1.8 Milliliter,
					MatchQ[resolvedScale, Preparative], 45 Milliliter,
					True,1.8 Milliliter
				],
				Null
			]
		],
		{
			collectFractions,
			Lookup[roundedOptionsAssociation, MaxFractionVolume],
			Lookup[roundedOptionsAssociation, MaxCollectionPeriod],
			fractionCollectionPackets,
			(* flow rate...seems to be in the -2 index now? *)
			resolvedAnalyteGradients[[All, All, -2]]
		}
	];

	(* If collecting fractions, fetch max fraction period from: option value if specified, calculated from max volume and flow rate, fraction method, or if mode it Time, default to 30s otherwise Null *)
	maxFractionPeriods = MapThread[
		Function[{collectQ, maxVolume, maxPeriod, methodPacket, flowRateTuples, fractionCollectionMode},
			If[TrueQ[collectQ],
				Which[
					!MatchQ[maxPeriod, Automatic], maxPeriod,
					!MatchQ[maxVolume, Automatic], maxVolume / (flowRateTuples[[1]]),
					MatchQ[methodPacket, PacketP[]], Lookup[methodPacket, MaxCollectionPeriod, Null],
					MatchQ[fractionCollectionMode, Time], 0.8 * maxVolume / (flowRateTuples[[1]]),
					True, Null
				],
				Null
			]
		],
		{
			collectFractions,
			Lookup[roundedOptionsAssociation, MaxFractionVolume],
			Lookup[roundedOptionsAssociation, MaxCollectionPeriod],
			fractionCollectionPackets,
			(* flow rate *)
			resolvedAnalyteGradients[[All, All, -2]],
			fractionCollectionModes
		}
	];

	(* Note that we will resolve the Detector-related FractionCollection options AFTER instrument and detector resolution *)

	(* --- Resolve and Error Check Instrument ---*)

	(* Resolve Instrument (and Detector) *)
	(* Detector and Instrument related Checks *)
	(* Make sure we delete the HPLC that is only used in LCMS. The model is hard-coded in ExperimentLCMS now as variable availableChromatographyInstrumentModels *)
	(* LCMS HPLCs are not supported in HPLC procedure now. They are not H-Class and not covered in our procedure! Error out if we are given the I-Class instruments for stand-alone HPLCs *)
	allHPLCInstruments = Which[
		(* No change if we are called by LCMS *)
		internalUsageQ, Complement[availableInstruments, testHPLCInstruments],
		(* No specified instrument model. Then exclude I-Class UPLC from LCMS *)
		NullQ[specifiedInstrumentModelPackets],
		DeleteCases[Complement[availableInstruments, testHPLCInstruments], ObjectReferenceP[Model[Instrument, HPLC, "id:4pO6dM5lRrl7"](* "Waters Acquity UPLC I-Class PDA" *)]],
		(* If the LCMS HPLC is specified, go with it *)
		MemberQ[Lookup[specifiedInstrumentModelPackets, Object, Null], ObjectReferenceP[Model[Instrument, HPLC, "id:4pO6dM5lRrl7"]]], Complement[availableInstruments, testHPLCInstruments],
		(* Otherwise exclude I-Class UPLC from LCMS *)
		True, DeleteCases[Complement[availableInstruments, testHPLCInstruments],ObjectReferenceP[Model[Instrument, HPLC, "id:4pO6dM5lRrl7"](* "Waters Acquity UPLC I-Class PDA" *)]]
	];
	nonDionexHPLCInstruments = Complement[allHPLCInstruments, dionexHPLCInstruments];

	(* Fetch all the instrument model packets *)
	(* Dionex is made special here because of the available detectors on it. We haven't split Waters and Agilent because Agilent has only PDA detector, which is also avaialble on Waters *)
	allHPLCInstrumentPackets = fetchPacketFromCache[#, cache]& /@ allHPLCInstruments;
	dionexHPLCInstrumentPackets = fetchPacketFromCache[#, cache]& /@ dionexHPLCInstruments;
	nonDionexHPLCInstrumentPackets = fetchPacketFromCache[#, cache]& /@ nonDionexHPLCInstruments;

	(* Is a dionex only detector requested? *)
	(* Get the types of HPLC detectors that are only available on Dionex HPLC instruments *)
	dionexDetectors = DeleteDuplicates[Flatten[Lookup[dionexHPLCInstrumentPackets, Detectors]]];
	nondionexDetectors = DeleteDuplicates[Flatten[Lookup[nonDionexHPLCInstrumentPackets, Detectors]]];
	dionexOnlyDetectors = Complement[dionexDetectors, nondionexDetectors];
	dionexDetectorRequestedQ = Or[
		dionexFlrRequestedQ || lightScatteringRequestedQ || refractiveIndexRequestedQ || pHRequestedQ || conductivityRequestedQ,
		MemberQ[ToList[Lookup[roundedOptionsAssociation, Detector]], Alternatives@@dionexOnlyDetectors]
	];

	(* Get the relations between the detectors and the option booleans *)
	detectorOpsBoolLookupTable = {
		{UVVis, PhotoDiodeArray} -> uvRequestedQ || watersRequestedQ,
		PhotoDiodeArray -> pdaRequestedQ,
		Fluorescence -> flrRequestedQ || dionexFlrRequestedQ,
		EvaporativeLightScattering -> elsdRequestedQ,
		{MultiAngleLightScattering, DynamicLightScattering} -> lightScatteringRequestedQ,
		RefractiveIndex -> refractiveIndexRequestedQ,
		pH -> pHRequestedQ,
		Conductance -> conductivityRequestedQ
	};

	(* Get the relations between the detectors and the options list *)
	detectorOpsListLookupTable = {
		{UVVis, PhotoDiodeArray} -> Join[tuvOptions, watersAbsorbanceOptions],
		PhotoDiodeArray -> moreSpecificPDAOptions,
		Fluorescence -> Join[flrOptions, dionexFlrOptions],
		EvaporativeLightScattering -> elsdOptions,
		{MultiAngleLightScattering, DynamicLightScattering} -> lightScatteringOptions,
		RefractiveIndex -> refractiveIndexOptions,
		pH -> pHOptions,
		Conductance -> conductivityOptions
	};

	(* Get the relations between the detectors and the specified options list *)
	detectorSpecifiedOpsListLookupTable = {
		{UVVis, PhotoDiodeArray} -> PickList[Join[tuvOptions, watersAbsorbanceOptions], Join[uvOptionSpecifiedBool, watersSpecifiedBool]],
		PhotoDiodeArray -> PickList[moreSpecificPDAOptions, pdaOptionSpecifiedBool],
		Fluorescence -> PickList[Join[flrOptions, dionexFlrOptions], Join[flrOptionSpecifiedBool, dionexFlrOptionSpecifiedBool]],
		EvaporativeLightScattering -> PickList[elsdOptions, elsdOptionSpecifiedBool],
		{MultiAngleLightScattering, DynamicLightScattering} -> PickList[lightScatteringOptions, lightScatteringSpecifiedBool],
		RefractiveIndex -> PickList[refractiveIndexOptions, refractiveIndexSpecifiedBool],
		pH -> PickList[pHOptions, phSpecifiedBool],
		Conductance -> PickList[conductivityOptions, conductivitySpecifiedBool]
	};

	(* Get all of the Waters and Agilent instruments *)
	watersInstrumentsBool = Map[
		MatchQ[
			(Lookup[#, Manufacturer] /. x_Link :> Download[x, Object]),
			ObjectP[Object[Company, Supplier, "Waters"]]
		]&,
		allHPLCInstrumentPackets
	];

	agilentInstrumentsBool = Map[
		MatchQ[
			(Lookup[#, Manufacturer] /. x_Link :> Download[x, Object]),
			ObjectP[Object[Company, Supplier, "Agilent"]]
		]&,
		allHPLCInstrumentPackets
	];

	(* Check that any specified options are compatible with at least one instrument model (or the specified instrument(s) if explicitly provided). Track the invalid options and the tests *)
	(* We will throw Warning messages for the following cases:
		1 - Agilent instrument is specified with non-Agilent instruments
		2 - Some or all of the instruments specified are not compatible with the other options
		We will further filter out the instruments that do not work with Error::InvalidHPLCAlternateInstruments
	 *)
	{instrumentConflictInvalidOptions, requiredInstrumentConflictTests} = Module[
		{agilentInstrumentConflictTest,agilentInstrumentRequiredTest,sampleTemperatureSupportTest, bufferDSupportTest, gradientDSupportTest,
			sampleTemperatureAndDionexDetectorSupportTest, bufferDAndDionexDetectorSupportTest, gradientDAndDionexDetectorSupportTest,
			compatibleDetectionWavelengthRange, specifiedDetectionWavelengths, incompatibleDetectionWavelengths,
			detectionWavelengthTests, watersHPLCInstrumentMaxWavelength, detectionWavelengthSampleTemperatureTests, bufferDNullTests, detectorCompatibilityTest,
			requestedDetector, invalidDetectors, invalidDetectorOptions, invalidDetectorTrackingOptions, invalidDetectorTest, invalidDionexDetectors, invalidDionexDetectorOptions,
			allInstrumentInvalidOptions, allInstrumentTests},

		(* If the specified Instrument is a list, check if only Agilent instruments are requested *)
		agilentInstrumentConflictTest = If[
			(* It has Agilent instruments but not all are Agilent instrument, throw error *)
			And[
				!NullQ[specifiedInstrumentModelPackets],
				MemberQ[Lookup[specifiedInstrumentModelPackets, Object],agilentHPLCPattern],
				!MatchQ[Lookup[specifiedInstrumentModelPackets, Object],ListableP[agilentHPLCPattern]]
			],
			(
				If[messagesQ,
					Message[Error::HPLCInstrumentScaleConflict, ObjectToString@Lookup[roundedOptionsAssociation, Instrument]]
				];
				validAgilentInstrumentQ = False;
				testOrNull["The Preparative scale HPLC instrument cannot be requested together with other instruments as potential choices in the Instrument option:", False]
			),
			testOrNull["The Preparative scale HPLC instrument cannot be requested together with other instruments as potential choices in the Instrument option:", True]
		];

		(* If the resolvedScale is Preparative, check if Agilent instruments are requested or left Automatic *)
		agilentInstrumentRequiredTest = If[
			And[
				!NullQ[specifiedInstrumentModelPackets],
				MatchQ[resolvedScale,Preparative],
				!MemberQ[Lookup[specifiedInstrumentModelPackets, Object],agilentHPLCPattern]
			],
			(
				If[messagesQ,
					Message[Error::MissingHPLCScaleInstrument, ObjectToString@Lookup[roundedOptionsAssociation, Instrument]]
				];
				validAgilentInstrumentQ = False;
				testOrNull["If the Scale of the experiment is Preparative, the matching HPLC instrument Model[Instrument, HPLC, \"Agilent 1290 Infinity II LC System\"] must be selected in the Instrument option:", False]
			),
			testOrNull["If the Scale of the experiment is Preparative, the matching HPLC instrument Model[Instrument, HPLC, \"Agilent 1290 Infinity II LC System\"] must be selected in the Instrument option:", True]
		];

		(* If SampleTemperature is specified, Instrument cannot be specified as the Dionex or Agilent since they do not support sample incubation *)
		sampleTemperatureSupportTest = If[
			And[
				!NullQ[specifiedInstrumentModelPackets],
				(* "UltiMate 3000" with any detector and Agilent 1290 have MinSampleTemperature and MaxSampleTemperature as Null *)
				MemberQ[Lookup[specifiedInstrumentModelPackets, MinSampleTemperature], Null],
				MatchQ[Lookup[roundedOptionsAssociation, SampleTemperature], TemperatureP]
			],
			(
				If[messagesQ,
					Message[Error::UnsupportedSampleTemperature, ObjectToString[PickList[Lookup[specifiedInstrumentModelPackets,Object],Lookup[specifiedInstrumentModelPackets, MinSampleTemperature],Null]]]
				];
				validSampleTemperatureQ = False;
				testOrNull["If SampleTemperature and Instrument are specified, the instrument(s) allow autosampler incubation:", False]
			),
			testOrNull["If SampleTemperature and Instrument are specified, the instrument(s) allow autosampler incubation:", True]
		];

		(* If BufferD is specified as an object, Instrument cannot be specified as the Dionex since it does not have a quaternary pump *)
		bufferDSupportTest = If[
			And[
				!NullQ[specifiedInstrumentModelPackets],
				(* "UltiMate 3000" with any detector has Ternary pump *)
				MemberQ[Lookup[specifiedInstrumentModelPackets, PumpType, Null], Ternary],
				MatchQ[Lookup[roundedOptionsAssociation, BufferD], ObjectP[]]
			],
			(
				If[messagesQ,
					Message[Error::UnsupportedBufferD, ObjectToString[PickList[Lookup[specifiedInstrumentModelPackets,Object],Lookup[specifiedInstrumentModelPackets, PumpType],Ternary]]]
				];
				validBufferDQ = False;
				testOrNull["If BufferD and Instrument are specified, the instrument supports four buffers:", False]
			),
			testOrNull["If BufferD and Instrument are specified, the instrument supports four buffers:", True]
		];

		(* If any gradients use BufferD, Instrument cannot be specified as the Dionex since it does not have a quaternary pump *)
		gradientDSupportTest = If[
			And[
				!NullQ[specifiedInstrumentModelPackets],
				(* "UltiMate 3000" with any detector has Ternary pump *)
				MemberQ[Lookup[specifiedInstrumentModelPackets, PumpType, Null], Ternary],
				TrueQ[anyGradientDQ]
			],
			(
				If[messagesQ,
					Message[Error::UnsupportedGradientD, ObjectToString[PickList[Lookup[specifiedInstrumentModelPackets,Object],Lookup[specifiedInstrumentModelPackets, PumpType],Ternary]]]
				];
				If[AnyTrue[Lookup[roundedOptionsAssociation, GradientD], !MatchQ[#, Null | Automatic]&],
					validGradientDQ = False,
					validGradientQ = False
				];
				testOrNull["If a gradient specification uses BufferD and Instrument is specified, the instrument supports four buffers:", False]
			),
			testOrNull["If a gradient specification uses BufferD and Instrument is specified, the instrument supports four buffers:", True]
		];

		(* If Instrument is specified, fetch its compatible absorbance wavelength range *)
		compatibleDetectionWavelengthRange = If[!NullQ[specifiedInstrumentModelPackets],
			{
				(* Take the max of Min wavelength and min of Max to get the smallest range *)
				Max[Append[Cases[Lookup[specifiedInstrumentModelPackets, MinAbsorbanceWavelength,Null],DistanceP],190 Nanometer]],
				Min[Append[Cases[Lookup[specifiedInstrumentModelPackets, MaxAbsorbanceWavelength,Null],DistanceP],900 Nanometer]]
			},
			Null
		];

		(* Fetch any specified wavelengths from options *)
		specifiedDetectionWavelengths = Map[
			Cases[ToList@Lookup[roundedOptionsAssociation, #], DistanceP]&,
			absorbanceWavelengthOptions
		];

		(* Extract any specified detection wavelengths for each option that is not within the Instrument's compatible range *)
		incompatibleDetectionWavelengths = Map[
			If[!MatchQ[compatibleDetectionWavelengthRange, {DistanceP, DistanceP}] || MatchQ[#, {}],
				{},
				Cases[#, Except[RangeP @@ compatibleDetectionWavelengthRange]]
			]&,
			specifiedDetectionWavelengths
		];

		(* Any failing cases? *)
		incompatibleDetectionWavelengthsQ = Or @@ (Length[#] > 0& /@ incompatibleDetectionWavelengths);

		detectionWavelengthTests = MapThread[
			If[Length[#2] > 0,
				(
					If[messagesQ,
						Message[Error::WavelengthOutOfRange, #1, #2, ObjectToString@Lookup[roundedOptionsAssociation, Instrument], compatibleDetectionWavelengthRange[[1]], compatibleDetectionWavelengthRange[[2]]]
					];
					Switch[#1,
						AbsorbanceWavelength,
						validDetectionWavelengthQ = False,
						StandardAbsorbanceWavelength,
						validStandardDetectionWavelengthQ = False,
						BlankAbsorbanceWavelength,
						validBlankDetectionWavelengthQ = False,
						ColumnPrimeAbsorbanceWavelength,
						validColumnPrimeDetectionWavelengthQ = False,
						ColumnFlushAbsorbanceWavelength,
						validColumnFlushDetectionWavelengthQ = False
					];
					testOrNull[StringTemplate["If `1` and Instrument are specified, the specified wavelengths are within the instrument's supported range:"][#1], False]
				),
				testOrNull[StringTemplate["If `1` and Instrument are specified, the specified wavelengths are within the instrument's supported range:"][#1], True]
			]&,
			{absorbanceWavelengthOptions, incompatibleDetectionWavelengths}
		];

		(* Waters PDA can only support wavelengths < 500nm and Waters TUV can only support < 700 nm so SampleTemperature cannot be specified if wavelengths are > 700nm *)
		(* SampleTemperature is not supported on Agilent or Doinex *)
		watersHPLCInstrumentMaxWavelength=Max[
			Cases[
				Lookup[fetchPacketFromCache[#,cache],MaxAbsorbanceWavelength]&/@watersHPLCInstruments,
				DistanceP
			]
		];
		detectionWavelengthSampleTemperatureTests = MapThread[
			If[
				And[
					MatchQ[Lookup[roundedOptionsAssociation, SampleTemperature], TemperatureP], AnyTrue[#2, (# > watersHPLCInstrumentMaxWavelength)&]
				],
				(
					If[messagesQ,
						Message[Error::WavelengthTemperatureConflict, #1, Select[#2, (# > 500 Nanometer)&]]
					];
					Switch[#1,
						AbsorbanceWavelength,
						validDetectionWavelengthQ = False,
						StandardAbsorbanceWavelength,
						validStandardDetectionWavelengthQ = False,
						BlankAbsorbanceWavelength,
						validBlankDetectionWavelengthQ = False,
						ColumnPrimeAbsorbanceWavelength,
						validColumnPrimeDetectionWavelengthQ = False,
						ColumnFlushAbsorbanceWavelength,
						validColumnFlushDetectionWavelengthQ = False
					];
					testOrNull[StringTemplate["If `1` and SampleTemperature are specified, the specified wavelengths are within the instrument which supports autosampler incubation's range:"][#1], False]
				),
				testOrNull[StringTemplate["If `1` and SampleTemperature are specified, the specified wavelengths are within the instrument which supports autosampler incubation's range:"][#1], True]
			]&,
			{absorbanceWavelengthOptions, specifiedDetectionWavelengths}
		];

		(* BufferD cannot be required if it is set to Null *)
		bufferDNullTests = If[NullQ[Lookup[roundedOptionsAssociation, BufferD]],
			{
				(* "Waters HPLCs cannot have BufferD -> Null since some sort of BufferD needs to be hooked up *)
				If[!NullQ[specifiedInstrumentModelPackets] && MemberQ[Lookup[specifiedInstrumentModelPackets,Object],Alternatives@@nonDionexHPLCInstruments],
					(
						If[messagesQ,
							Message[Error::BufferDMustExistForInstrument, ObjectToString[Cases[Lookup[specifiedInstrumentModelPackets,Object],Alternatives@@nonDionexHPLCInstruments]]]
						];
						validBufferDNullQ = False;
						testOrNull["If Instrument is specified and BufferD is set to Null, the instrument does not have a quaternary pump:", False]
					),
					testOrNull["If Instrument is specified and BufferD is set to Null, the instrument does not have a quaternary pump:", True]
				],
				(* Only the waters HPLC can support SampleTemperature, and it needs a BufferD, therefore if BufferD->Null and SampleTemperature is specified, error *)
				If[MatchQ[Lookup[roundedOptionsAssociation, SampleTemperature], TemperatureP],
					(
						If[messagesQ,
							Message[Error::BufferDMustExistForSampleTemperature]
						];
						validBufferDNullQ = False;
						testOrNull["If BufferD is set to Null, SampleTemperature is not set:", False]
					),
					testOrNull["If BufferD is set to Null, SampleTemperature is not set:", True]
				],
				(* If BufferD->Null, no gradient specifications can specify BufferD usage *)
				If[anyGradientDQ,
					(
						If[messagesQ,
							Message[Error::BufferDMustExistForGradient]
						];
						validBufferDNullQ = False;
						testOrNull["If BufferD is set to Null, gradient specifications do not use BufferD:", False]
					),
					testOrNull["If BufferD is set to Null, gradient specifications do not use BufferD:", True]
				]
			},
			{
				testOrNull["If Instrument is specified and BufferD is set to Null, the instrument does not have a quaternary pump:", True],
				testOrNull["If BufferD is set to Null, SampleTemperature is not set:", True],
				testOrNull["If BufferD is set to Null, gradient specifications do not use BufferD:", True]
			}
		];

		(* A specified Detector must match a specified instrument's detector *)
		detectorCompatibilityTest = If[
			And[
				!NullQ[specifiedInstrumentModelPackets],
				MatchQ[Lookup[roundedOptionsAssociation, Detector], Except[Automatic]],
				!SubsetQ[
					Intersection @@ Lookup[specifiedInstrumentModelPackets, Detectors, {}],
					ToList@Lookup[roundedOptionsAssociation, Detector]
				]
			],
			(
				If[messagesQ,
					Message[Error::DetectorConflict, ObjectToString@Lookup[roundedOptionsAssociation, Instrument], Intersection @@ Lookup[specifiedInstrumentModelPackets, Detectors, {}], Lookup[roundedOptionsAssociation, Detector]]
				];
				compatibleDetectorQ = False;
				testOrNull["If Detector and Instrument are specified, the specified Detector must be a subset of the instrument's Detectors:", False]
			),
			testOrNull["If Detector and Instrument are specified, the specified Detector must be a subset of the instrument's Detectors:", True]
		];

		(* If any of the detector options are specified, the corresponding detector must be available in the specified Instrument *)
		(* Get the available detectors - either from the Detectors of the specified instrument or from option Detector *)
		requestedDetector = Which[
			MatchQ[Lookup[roundedOptionsAssociation, Detector], Except[Automatic]], Lookup[roundedOptionsAssociation, Detector],
			!NullQ[specifiedInstrumentModelPackets],  Intersection @@ Lookup[specifiedInstrumentModelPackets, Detectors],
			(* If no detector or instrument is specified, basically any detector is OK *)
			True, List @@ ChromatographyDetectorTypeP
		];

		(* Check whether a detector is presented when the corresponding options are specified. Also track the corresponding non-Automatic/Null options when it is an invalid detector *)
		{invalidDetectors, invalidDetectorOptions} = Transpose[
			MapThread[
				If[MatchQ[#2, True] && !IntersectingQ[ToList[#1], ToList[requestedDetector]],
					{#1, #3},
					(* Get the place-holder empty list so the invalid detectors and options are Transpose-friendly *)
					{{}, {}}
				]&,
				{Keys[detectorOpsBoolLookupTable], Values[detectorOpsBoolLookupTable], Values[detectorSpecifiedOpsListLookupTable]}
			]
		];

		(* Gather the invalid options if there are invalid Detector. *)
		invalidDetectorTrackingOptions = Which[
			MatchQ[Lookup[roundedOptionsAssociation, Detector], Except[Automatic]] && !MatchQ[Flatten[invalidDetectors], {}], Append[Flatten[invalidDetectorOptions], Detector],
			!NullQ[specifiedInstrumentModelPackets] && !MatchQ[Flatten[invalidDetectors], {}], Append[Flatten[invalidDetectorOptions], Instrument],
			True, {}
		];

		(* Throw error message and generate tests *)
		invalidDetectorTest = If[
			!MatchQ[Flatten[invalidDetectors], {}],
			(
				If[messagesQ,
					Message[Error::InvalidHPLCDetectorOptions, ToString[Flatten[invalidDetectors]], ToString[Last[invalidDetectorTrackingOptions]], ToString[Most[invalidDetectorTrackingOptions]]]
				];
				testOrNull["If the detector related options are specified, the corresponding detectors are available in the Detector option or the Instrument option:", False]
			),
			testOrNull["If the detector related options are specified, the corresponding detectors are available in the Detector option or the Instrument option:", True]
		];

		(* Check the requested Dionex only detector options *)
		{invalidDionexDetectors, invalidDionexDetectorOptions} = Transpose[
			MapThread[
				Which[
					(* Track the Detector and options if they are provided *)
					MatchQ[#2, True], {#1, #3},
					(* Otherwise track the specified detectors if it is provided from the Detector option *)
					MemberQ[ToList[Lookup[roundedOptionsAssociation, Detector]], Alternatives @@ ToList[#1]], {#1, Detector},
					(* Get the place-holder empty list so the invalid detectors and options are Transpose-friendly *)
					True, {{}, {}}
				]&,
				{
					{Fluorescence, {MultiAngleLightScattering, DynamicLightScattering}, RefractiveIndex, pH, Conductance},
					Lookup[detectorOpsBoolLookupTable, {Fluorescence, {MultiAngleLightScattering, DynamicLightScattering}, RefractiveIndex, pH, Conductance}],
					Lookup[detectorSpecifiedOpsListLookupTable, {Fluorescence, {MultiAngleLightScattering, DynamicLightScattering}, RefractiveIndex, pH, Conductance}]
				}
			]
		];

		(* If we have to use Dionex due to the detector reason - Dionex only detector options are specified, SampleTemperature cannot be required *)
		sampleTemperatureAndDionexDetectorSupportTest = If[
			And[
				(* Only check this when we don't have conflict from Instrument option *)
				validSampleTemperatureQ,
				(* Dionex only Detectors are requested *)
				dionexDetectorRequestedQ,
				MatchQ[Lookup[roundedOptionsAssociation, SampleTemperature], TemperatureP]
			],
			(
				If[messagesQ,
					Message[Error::UnsupportedSampleTemperatureAndDetectors, ToString[Flatten[invalidDionexDetectorOptions]], ToString[Flatten[invalidDionexDetectors]]]
				];
				validSampleTemperatureAndDionexDetectorQ = False;
				testOrNull["If SampleTemperature is requested, the detector related options cannot request a detector that is only available on UltiMate 3000 HPLC systems, which does not support SampleTemperature setting:", False]
			),
			testOrNull["If SampleTemperature is requested, the detector related options cannot request a detector that is only available on UltiMate 3000 HPLC systems, which does not support SampleTemperature setting:", True]
		];

		(* If we have to use Dionex due to the detector reason - Dionex only detector options are specified, BufferD cannot be required *)
		bufferDAndDionexDetectorSupportTest = If[
			And[
				(* Only check this when we don't have conflict from Instrument option *)
				validBufferDQ,
				(* Dionex only Detectors are requested *)
				dionexDetectorRequestedQ,
				MatchQ[Lookup[roundedOptionsAssociation, BufferD], ObjectP[]]
			],
			(
				If[messagesQ,
					Message[Error::UnsupportedBufferDAndDetectors, ToString[Flatten[invalidDionexDetectorOptions]], ToString[Flatten[invalidDionexDetectors]]]
				];
				validBufferDAndDionexDetectorQ = False;
				testOrNull["If BufferD is requested, the detector related options cannot request a detector that is only available on UltiMate 3000 HPLC systems, which does not support BufferD setting:", False]
			),
			testOrNull["If BufferD is requested, the detector related options cannot request a detector that is only available on UltiMate 3000 HPLC systems, which does not support BufferD setting:", True]
		];

		(* If we have to use Dionex due to the detector reason - Dionex only detector options are specified, GradientD cannot be required *)
		gradientDAndDionexDetectorSupportTest = If[
			And[
				(* Only check this when we don't have conflict from Instrument option *)
				validGradientDQ,
				(* Dionex only Detectors are requested *)
				dionexDetectorRequestedQ,
				anyGradientDQ
			],
			(
				If[messagesQ,
					Message[Error::UnsupportedGradientDAndDetectors, ToString[Flatten[invalidDionexDetectorOptions]], ToString[Flatten[invalidDionexDetectors]]]
				];
				validGradientDAndDionexDetectorQ = False;
				testOrNull["If a gradient specification uses BufferD, the detector related options cannot request a detector that is only available on UltiMate 3000 HPLC systems, which does not support BufferD setting:", False]
			),
			testOrNull["If a gradient specification uses BufferD, the detector related options cannot request a detector that is only available on UltiMate 3000 HPLC systems, which does not support BufferD setting:", True]
		];

		(* Track all the invalid options *)
		allInstrumentInvalidOptions = Flatten[{
			invalidDetectorTrackingOptions
		}];

		(* Join all instrument-compatibility tests *)
		allInstrumentTests = Flatten[{
			agilentInstrumentConflictTest,
			agilentInstrumentRequiredTest,
			sampleTemperatureSupportTest,
			bufferDSupportTest,
			gradientDSupportTest,
			detectionWavelengthTests,
			detectionWavelengthSampleTemperatureTests,
			bufferDNullTests,
			detectorCompatibilityTest,
			invalidDetectorTest,
			sampleTemperatureAndDionexDetectorSupportTest,
			bufferDAndDionexDetectorSupportTest,
			gradientDAndDionexDetectorSupportTest
		}];

		(* Return the invalid options and tests *)
		{allInstrumentInvalidOptions, allInstrumentTests}

	];

	(* Check the detector related options - they should not be set to a mixture of Null and un-Null because we cannot resolve whether the detector is requested or not *)
	{
		conflictUVOpsQ,
		conflictPDAOpsQ,
		conflictFlrOpsQ,
		conflictELSDOpsQ,
		conflictLightScatteringOpsQ,
		conflictRIOpsQ,
		conflictpHOpsQ,
		conflictConductivityOpsQ
	} = MapThread[
		(* If both are true, then some options are set to Null but some are specified. They are conflicting with each other *)
		And[#1, #2]&,
		{
			{uvRequestedQ || watersRequestedQ, pdaRequestedQ, flrRequestedQ || dionexFlrRequestedQ, elsdRequestedQ, lightScatteringRequestedQ, refractiveIndexRequestedQ, pHRequestedQ, conductivityRequestedQ},
			{uvRequestedNullQ || watersRequestedNullQ, pdaRequestedNullQ, flrRequestedNullQ || dionexFlrRequestedNullQ, elsdRequestedNullQ, lightScatteringRequestedNullQ, refractiveIndexRequestedNullQ, pHRequestedNullQ, conductivityRequestedNullQ}
		}
	];

	(* Track the invalid option and throw error message. We do want to include the error message inside this small MapThread so that we can have one message per detector. *)
	conflictDetectorOptions = MapThread[
		If[TrueQ[#1],
			Message[Error::ConflictHPLCDetectorOptions, ToString[#3], ToString[#2]];
			#2,
			Nothing
		]&,
		{
			{
				conflictUVOpsQ,
				conflictPDAOpsQ,
				conflictFlrOpsQ,
				conflictELSDOpsQ,
				conflictLightScatteringOpsQ,
				conflictRIOpsQ,
				conflictpHOpsQ,
				conflictConductivityOpsQ
			},
			Keys[detectorOpsListLookupTable],
			Values[detectorOpsListLookupTable]
		}
	];

	(* Generate Tests for the conflict detector options *)
	conflictDetectorTests = MapThread[
		If[TrueQ[#3],
			testOrNull["The " <> ToString[#1] <> " detector related options " <> ToString[#2] <> " are not set to Null or populated partially.", False],
			testOrNull["The " <> ToString[#1] <> " detector related options " <> ToString[#2] <> " are not set to Null or populated partially.", True]
		]&,
		{
			Keys[detectorOpsListLookupTable],
			Values[detectorOpsListLookupTable],
			{
				conflictUVOpsQ,
				conflictPDAOpsQ,
				conflictFlrOpsQ,
				conflictELSDOpsQ,
				conflictLightScatteringOpsQ,
				conflictRIOpsQ,
				conflictpHOpsQ,
				conflictConductivityOpsQ
			}
		}
	];

	(* Broadly there are many options that narrow our search for instrument. among them are as follows *)
	(* Instrument, Detector, Detector-related Options, Fraction Collection, Fraction Collection Options, SampleTemperature, BufferD, GradientD, ColumnSelector, Quatenary/Ternary/Binary gradient (PumpType), Flow Rate, the weird sharing of NeedleWashSolution and BufferC on Dionex, counts of containers on Waters and Dionex (since they share the same type of containers *)
	(* Generally, the logic is that for each of these conditions, we'll have a list of instruments that meet the criteria *)
	(* At the end, we'll take the intersection of all the instruments *)

	(* Determine which instruments can meet the container count *)
	containerCountBool = Map[
		Which[
			MatchQ[#, dionexHPLCPattern],
			validDionexCountQ,
			MatchQ[#, agilentHPLCPattern],
			validAgilentCountQ,
			True,
			validWatersCountQ
		]&,
		allHPLCInstruments
	];

	countCapableInstruments = PickList[allHPLCInstruments, containerCountBool];

	(* Should we collect fractions? *)
	collectFractionsQ = Or @@ collectFractions;

	(* Get the instruments related whether to collect fractions *)
	fractionCollectionInstruments = If[collectFractionsQ,
		Join[dionexHPLCInstruments, agilentHPLCInstruments],
		(* Otherwise any instrument should work *)
		allHPLCInstruments
	];

	(* Get the scale required instruments *)
	scaleInstruments = Switch[resolvedScale,
		Preparative, agilentHPLCInstruments,
		SemiPreparative, Join[agilentHPLCInstruments,dionexHPLCInstruments],
		(* Analytical operation mode is supported but not ideal on Agilent 1290 instrument due to the sample loop installed (20mL prep sample loop is installed) *)
		(* We still include the Agilent instrument here but it will be filtered out later as being not preferred *)
		_,allHPLCInstruments
	];

	(* Get all the specified column temperatures *)
	allColumnTemperatures = Cases[Flatten[{resolvedColumnTemperatures,resolvedStandardColumnTemperatures, resolvedBlankColumnTemperatures, resolvedPrimeColumnTemperatures, resolvedFlushColumnTemperatures}], GreaterP[0 * Celsius]];

	(* Get the compatible instruments for column temperatures *)
	capableColumnTemperatureInstruments = If[Length[allColumnTemperatures] > 0,
		(* Get the min and max column temperature in our list *)
		{minColumnTemperature, maxColumnTemperature} = {Min[allColumnTemperatures], Max[allColumnTemperatures]};
		(* Map over the possible instruments and pick out the ones that can meet the specification *)
		MapThread[
			Function[
				{packet, instrument},
				Module[
					{currentMin, currentMax},
					(* Get the current instrument temperature range*)
					{currentMin, currentMax} = Lookup[packet, {MinColumnTemperature, MaxColumnTemperature},$AmbientTemperature];
					(* If it's capable, then add the instrument to our list; otherwise, don't *)
					If[minColumnTemperature >= currentMin && maxColumnTemperature <= currentMax,
						instrument,
						Nothing
					]
				]
			],
			{allHPLCInstrumentPackets, allHPLCInstruments}
		],
		(* If there is no column temp restrictions, then all instruments are accepted *)
		allHPLCInstruments
	];

	(* Get that weird case of when the user specifies that that BufferC and NeedleWashSolution are different *)
	(* NeedleWashSolution must be the same as bufferC on Dionex instruments *)
	needlewashBufferCDistinctInstruments = If[MatchQ[Lookup[roundedOptionsAssociation, {NeedleWashSolution, BufferC}], {Except[Automatic], Except[Automatic]}],
		(* In the case that these are different *)
		If[!MatchQ[Download[Lookup[roundedOptionsAssociation, NeedleWashSolution], Object], ObjectP[Download[Lookup[roundedOptionsAssociation, BufferC], Object]]],
			(* If so, we remove the dionex from the list *)
			nonDionexHPLCInstruments,
			allHPLCInstruments
		],
		allHPLCInstruments
	];

	(* Check the injection volumes *)
	allInjectionVolumes = Cases[Flatten[{resolvedInjectionVolumes,resolvedStandardInjectionVolumes,resolvedBlankInjectionVolumes}], VolumeP];

	(* Get the compatible instruments for injection volume *)
	capableInjectionVolumeInstruments = If[Length[allInjectionVolumes] > 0,
		(* Map over our instruments and pick out the ones that can meet the specification *)
		Map[
			Module[
				{currentMin, currentMax},
				(* Get the current instrument injection volume range *)
				{currentMin, currentMax} = Lookup[#, {MinSampleVolume, MaxSampleVolume}];
				(* If it's capable, then add to our list; otherwise, don't *)
				If[Min[allInjectionVolumes] >= currentMin && Max[allInjectionVolumes] <= currentMax,
					Download[#, Object],
					Nothing
				]
			]&,
			allHPLCInstrumentPackets
		],
		(* If no injection volume restrictions, then all instruments are accepted. Since we resolve InjectionVolume earlier in the resolver, this should never be the case. *)
		allHPLCInstruments
	];

	(* Get all of the all compatible instruments for the sample temperature. This is a single option as the autosampler chamber will be at a single temperature *)
	sampleTemperatureOption = Lookup[roundedOptionsAssociation, SampleTemperature];

	(* Get all of the capable instruments *)
	sampleTemperatureInstruments = If[MatchQ[sampleTemperatureOption, GreaterP[0 * Celsius]],
		(* Check to see if each instrument works *)
		MapThread[
			Function[
				{instrument, packet},
				(* Check whether either is Null in the instrument packet*)
				If[
					Or[
						NullQ[Lookup[packet, MinSampleTemperature]],
						NullQ[Lookup[packet, MaxSampleTemperature]]
					],
					(* In which case, we don't consider this instrument *)
					Nothing,
					(* Otherwise if it falls within range, then it's good *)
					If[
						And[
							MatchQ[sampleTemperatureOption, GreaterEqualP[Lookup[packet, MinSampleTemperature]]],
							MatchQ[sampleTemperatureOption, LessEqualP[Lookup[packet, MaxSampleTemperature]]]
						],
						instrument,
						Nothing
					]
				]
			],
			{allHPLCInstruments, allHPLCInstrumentPackets}
		],
		(* If no sample temperature restrictions, then anything is accepted *)
		allHPLCInstruments
	];

	(* Now check what kind of gradients we have (Binary, Ternary, Quaternary) *)
	allTupledGradients = Cases[Join @@ Cases[{resolvedAnalyteGradients, resolvedStandardAnalyticalGradients, resolvedBlankAnalyticalGradients, resolvedColumnPrimeAnalyticalGradients, resolvedColumnFlushAnalyticalGradients}, Except[ListableP[Null]]], Except[ObjectP[]]];

	(* Tabulate the gradient types *)
	gradientTypes = DeleteDuplicates[
		Map[
			Function[
				{gradientTuple},
				Switch[Total[gradientTuple][[2 ;; 5]],
					(* If only A and B are used, then Binary *)
					{GreaterEqualP[0 Percent], GreaterEqualP[0 Percent], EqualP[0 Percent], EqualP[0 Percent]}, Binary,
					(* If A and C (and optionally B) are used then Ternary *)
					{GreaterP[0 Percent], GreaterEqualP[0 Percent], GreaterP[0 Percent], EqualP[0 Percent]}, Ternary,
					(* If B and C are used exclusively then it could be BinaryFourBuffers or Ternary *)
					{EqualP[0 Percent], GreaterEqualP[0 Percent], GreaterEqualP[0 Percent], EqualP[0 Percent]}, BinaryFourBuffersOrTernary,
					(* If 4 Buffers are used, but never A and C together or B and D together, then BinaryFourBuffers *)
					{GreaterEqualP[0 Percent], EqualP[0 Percent], EqualP[0 Percent], GreaterEqualP[0 Percent]}, BinaryFourBuffers,
					{EqualP[0 Percent], EqualP[0 Percent], GreaterEqualP[0 Percent], GreaterEqualP[0 Percent]}, BinaryFourBuffers,
					(* Otherwise, Quaternary *)
					_, Quaternary
				]
			],
			allTupledGradients
		]
	];

	(* For each instrument, we figure out what they're capable of based on the number of buffers and pump type *)
	instrumentGradientTypes = Map[
		Function[
			{instrumentPacket},
			Switch[Lookup[instrumentPacket, {PumpType, NumberOfBuffers}],
				(* If we have a quaternary, then we can do anything *)
				{Quaternary,_},{Binary, BinaryFourBuffers, Ternary, Quaternary},
				{Binary,4},{Binary, BinaryFourBuffers, BinaryFourBuffersOrTernary},
				{Ternary,_},{Binary, Ternary, BinaryFourBuffersOrTernary},
				(* Otherwise just binary, but there shouldn't be any instrument like this currently *)
				_, {Binary}
			]
		],
		allHPLCInstrumentPackets
	];

	(* Finally figure out which instruments can meet the demand *)
	gradientCapableInstruments = PickList[
		allHPLCInstruments,
		(* Find where the subset meets the types *)
		Map[SubsetQ[#, gradientTypes]&, instrumentGradientTypes]
	];

	(* Check to see if a fourth buffer is desired *)
	(* Note that resolvedBufferD is resolved to Null as long as we don't have to have it, that does not really mean we cannot use Quaternary instruments *)
	numberOfBufferInstruments = If[MatchQ[resolvedBufferD, Except[Null]],
		(* Check for all of the instruments with a fourth buffe r*)
		PickList[allHPLCInstruments, Lookup[allHPLCInstrumentPackets, NumberOfBuffers], GreaterEqualP[4]],
		(* If no buffer D desired than we just give all the instruments *)
		allHPLCInstruments
	];

	(* Flow rate compatible instrument *)

	instrumentFlowRates = Lookup[allHPLCInstrumentPackets, MaxFlowRate, Null];

	flowRateCompatibleInstruments = PickList[allHPLCInstruments, instrumentFlowRates, Null | GreaterEqualP[maxInjectionFlowRate]];

	(* Explicit detector option *)

	detectorOption = ToList[Lookup[roundedOptionsAssociation, Detector]];

	(* If the user gave an explicit specification to the detector or the fraction collection detector, we see what instruments can meet it*)
	detectorCapableInstruments = Which[
		MatchQ[detectorOption, Except[{Automatic} | Automatic | Null]],
		(* Find the instrument models capable of meeting the detector specification *)
		MapThread[
			Function[{instrument, packet},
				(* Check if an instrument can meet all of the specified detectors *)
				If[SubsetQ[Flatten[Lookup[packet, Detectors, {}]/.{PhotoDiodeArray-> {PhotoDiodeArray,UVVis}}], ToList[detectorOption]],
					instrument,
					Nothing
				]
			],
			{allHPLCInstruments, allHPLCInstrumentPackets}
		],
		MatchQ[Lookup[roundedOptionsAssociation, FractionCollectionDetector], Except[Automatic]],
		MapThread[
			Function[{instrument, packet},
				(* Check if an instrument can meet the specified fraction collection detector *)
				If[MemberQ[Flatten[Lookup[packet, Detectors, {}]/.{PhotoDiodeArray-> {PhotoDiodeArray,UVVis}}], Lookup[roundedOptionsAssociation, FractionCollectionDetector]],
					instrument,
					Nothing
				]
			],
			{allHPLCInstruments, allHPLCInstrumentPackets}
		],
		True,
		allHPLCInstruments
	];

	(* Implicit detector option *)

	(* Check whether the instrument detector was implied *)
	impliedDetectorQ = Or[flrRequestedQ, dionexFlrRequestedQ, elsdRequestedQ, uvRequestedQ, pdaRequestedQ, lightScatteringRequestedQ, refractiveIndexRequestedQ, pHRequestedQ, conductivityRequestedQ];

	(* Get the implicit detectors *)
	impliedDetectors = PickList[
		{Fluorescence, EvaporativeLightScattering, UVVis, PhotoDiodeArray, {MultiAngleLightScattering, DynamicLightScattering}, RefractiveIndex, pH, Conductance},
		{flrRequestedQ || dionexFlrRequestedQ, elsdRequestedQ, uvRequestedQ, pdaRequestedQ, lightScatteringRequestedQ, refractiveIndexRequestedQ, pHRequestedQ, conductivityRequestedQ}
	];

	(* Get a True or False for instruments meeting the implied detector option. If there is a PDA, UVVis is implied *)
	impliedInstrumentBoolean = Map[
		SubsetQ[
			If[MemberQ[#, PhotoDiodeArray], Append[#, UVVis], #],
			Flatten[impliedDetectors]
		]&,
		Lookup[allHPLCInstrumentPackets, Detectors, {}]
	];

	(* Get all of the capable instruments *)
	impliedInstruments = If[impliedDetectorQ,
		Which[
			(* If Waters is implied, go for those *)
			watersRequestedQ || watersFlrRequestedQ, PickList[allHPLCInstruments, MapThread[And, {watersInstrumentsBool, impliedInstrumentBoolean}]],
			(* If Waters or Agilent UV option is implied, go for those *)
			nonDionexUVRequestedQ, PickList[allHPLCInstruments, MapThread[And[Or[#1,#2], #3]&, {watersInstrumentsBool, agilentInstrumentsBool, impliedInstrumentBoolean}]],
			(* If Dionex Detector is implied, go for those *)
			(* Technically we should do dionexBool here since we have Waters and Agilent besides Dionex. However, Fluorescence detector is not currently on Agilent and would have been disqualified in impliedInstrumentBoolean *)
			dionexFlrRequestedQ, PickList[allHPLCInstruments, MapThread[And[Not[#1], #2]&, {watersInstrumentsBool, impliedInstrumentBoolean}]],
			True, PickList[allHPLCInstruments, impliedInstrumentBoolean]
		],
		allHPLCInstruments
	];

	(* Lookup for an instrument with a compatible number of column slots *)
	columnSelectorInstruments = If[Length[resolvedColumnSelector] > 1,
		PickList[allHPLCInstruments, Lookup[allHPLCInstrumentPackets, MaxNumberOfColumns], GreaterEqualP[Length[resolvedColumnSelector]]],
		allHPLCInstruments
	];

	(* Select out the instruments by max acceleration if that's specified*)
	maxAccelerationLookup = Lookup[roundedOptionsAssociation, MaxAcceleration];
	maxAccelerationInstruments = If[MatchQ[maxAccelerationLookup, Except[Automatic]],
		PickList[
			allHPLCInstruments,
			(* Generate a boolean of whether the specified max acceleration is in range*)
			Map[
				Function[
					{instrumentPacket},
					And[
						MatchQ[maxAccelerationLookup, GreaterEqualP[Lookup[instrumentPacket, MinAcceleration] /. {Null -> 0 * Milliliter / (Minute * Minute)}]],
						MatchQ[maxAccelerationLookup, LessEqualP[Lookup[instrumentPacket, MaxAcceleration] /. {Null -> Infinity * Milliliter / (Minute * Minute)}]]
					]
				],
				allHPLCInstrumentPackets
			]
		],
		allHPLCInstruments
	];

	(* Take the intersection of all of instruments requirements *)
	(* Two special steps here are about the impliedInstruments from the detectors - if the empty list is caused requesting Waters UV or WatersFLR or Dionex FLR because we can safely ignore those options with a Warning message or throw a more specific Error message *)
	(* Another special case is about the flow rate. We have more specific Error message for flow rate later. We will just get rid of these instruments from alternate instruments (the combined Instrument option) *)
	bestInstruments = Intersection[
		countCapableInstruments,
		fractionCollectionInstruments,
		scaleInstruments,
		needlewashBufferCDistinctInstruments,
		capableColumnTemperatureInstruments,
		sampleTemperatureInstruments,
		gradientCapableInstruments,
		numberOfBufferInstruments,
		flowRateCompatibleInstruments,
		detectorCapableInstruments,
		capableInjectionVolumeInstruments,
		impliedInstruments,
		columnSelectorInstruments,
		maxAccelerationInstruments
	];

	secondaryBestInstruments = Intersection[
		countCapableInstruments,
		fractionCollectionInstruments,
		scaleInstruments,
		needlewashBufferCDistinctInstruments,
		capableColumnTemperatureInstruments,
		sampleTemperatureInstruments,
		gradientCapableInstruments,
		numberOfBufferInstruments,
		flowRateCompatibleInstruments,
		detectorCapableInstruments,
		capableInjectionVolumeInstruments,
		PickList[allHPLCInstruments, impliedInstrumentBoolean],
		columnSelectorInstruments,
		maxAccelerationInstruments
	];

	tertiaryBestInstruments = Intersection[
		countCapableInstruments,
		fractionCollectionInstruments,
		scaleInstruments,
		needlewashBufferCDistinctInstruments,
		capableColumnTemperatureInstruments,
		sampleTemperatureInstruments,
		gradientCapableInstruments,
		numberOfBufferInstruments,
		detectorCapableInstruments,
		capableInjectionVolumeInstruments,
		impliedInstruments,
		columnSelectorInstruments,
		maxAccelerationInstruments
	];

	quaternatryBestInstruments = Intersection[
		countCapableInstruments,
		fractionCollectionInstruments,
		scaleInstruments,
		needlewashBufferCDistinctInstruments,
		capableColumnTemperatureInstruments,
		sampleTemperatureInstruments,
		gradientCapableInstruments,
		numberOfBufferInstruments,
		detectorCapableInstruments,
		capableInjectionVolumeInstruments,
		impliedInstruments,
		columnSelectorInstruments,
		maxAccelerationInstruments
	];

	capableInstruments = Which[
		!MatchQ[bestInstruments, {}], bestInstruments,
		!MatchQ[secondaryBestInstruments, {}], secondaryBestInstruments,
		!MatchQ[tertiaryBestInstruments, {}], tertiaryBestInstruments,
		!MatchQ[quaternatryBestInstruments, {}], quaternatryBestInstruments,
		True, {}
	];

	(* Define our primary defaults, in the case, where we have a lot of flexibility *)
	(* {Model[Instrument, HPLC, "UltiMate 3000"], Model[Instrument, HPLC, "Waters Acquity UPLC H-Class PDA"]} *)
	{primaryInstrumentDefault, secondaryInstrumentDefault} = {Model[Instrument, HPLC, "id:N80DNjlYwwJq"], Model[Instrument, HPLC, "id:Z1lqpMGJmR0O"]};

	(* Get some pertinent options that the user specified for instrument resolution*)
	instrumentOption = Lookup[roundedOptionsAssociation, Instrument];

	(* Do the first step resolution - to get the best instrument *)
	(* If the user specified then we go with that *)
	possibleInstrument = Which[
		(* Stand-alone HPLC with I-Class *)
		MatchQ[instrumentOption, Except[Automatic]] && !internalUsageQ && MatchQ[Lookup[specifiedInstrumentModelPackets, Object, Null], {ObjectReferenceP[Model[Instrument, HPLC, "id:4pO6dM5lRrl7"](* "Waters Acquity UPLC I-Class PDA" *)]}],
		instrumentOption,
		(* Agilent instrument is in the capable instrument list and provided by the user, we will go with it *)
		And[
			MatchQ[instrumentOption, Except[Automatic]],
			MemberQ[capableInstruments,agilentHPLCPattern],
			MemberQ[Lookup[specifiedInstrumentModelPackets, Object, {}],agilentHPLCPattern]
		],
		First[PickList[ToList[instrumentOption],Lookup[specifiedInstrumentModelPackets, Object, {}],agilentHPLCPattern]],
		MatchQ[instrumentOption, Except[Automatic]],
		(* Resolve to the first possible instrument from capableInstruments list, or just the first one *)
		FirstOrDefault[
			MapThread[
				If[MemberQ[capableInstruments,Lookup[#2,Object]],
					#1,
					Nothing
				]&,
				{ToList[instrumentOption],specifiedInstrumentModelPackets}
			],
			First[ToList[instrumentOption]]
		],
		(* Otherwise we do some logic*)
		True,
		Which[
			(* If the primary default instrument is the available list, then we go with it *)
			MemberQ[capableInstruments, ObjectP[primaryInstrumentDefault]], primaryInstrumentDefault,
			(* Otherwise, we check whether the secondary default is available*)
			MemberQ[capableInstruments, ObjectP[secondaryInstrumentDefault]], secondaryInstrumentDefault,
			(* Otherwise, check the list length and return Null if empty *)
			Length[capableInstruments] == 0, Null,
			(* Otherwise, take the first acceptable option *)
			True, First[capableInstruments]
		]
	];

	(* Define the alternate instruments as the ones that were specified but not selected as the possibleInstrument *)
	alternateInstrumentsOption = If[MatchQ[instrumentOption, Except[Automatic]],
		Complement[ToList[instrumentOption],ToList[possibleInstrument]],
		Automatic
	];

	nonInternalHPLCErrorQ = And[
		MatchQ[instrumentOption, Except[Automatic]],
		!internalUsageQ,
		(* "Waters Acquity UPLC I-Class PDA" *)
		MemberQ[Lookup[specifiedInstrumentModelPackets, Object, Null], ObjectReferenceP[Model[Instrument, HPLC, "id:4pO6dM5lRrl7"]]]
	];

	(* Fetch possible instrument's model packet *)
	possibleInstrumentModelPacket = Switch[possibleInstrument,
		(* Give an empty packet for valid Lookup *)
		Null,
		<||>,
		ObjectP[Model],
		fetchPacketFromCacheHPLC[possibleInstrument, cache],
		_,
		fetchModelPacketFromCacheHPLC[possibleInstrument, cache]
	];

	(* If we don't have any instrument available then we have no capableInstrument and we'll need to throw the error message at some point. Depending on why there is no capable instruments at the end, we throw different errors. *)

	noCapableInstrumentQ = NullQ[possibleInstrument];

	(* Some of the options may require Dionex while others require Waters. Check these instruments and track the error. Dionex is more generous about container count and fraction collection will also lead to resolution of Dionex. These two will not be conflicting with each other. *)
	(* Agilent instruments are very specific as for container count requirement. For Agilent containers, we should have a pass for validDionexCountQ and validWatersCountQ *)
	compatibleCountAndNeedleWashBufferQ = !And[
		noCapableInstrumentQ,
		!MatchQ[countCapableInstruments, {}],
		MatchQ[
			Intersection[
				countCapableInstruments,
				needlewashBufferCDistinctInstruments
			],
			{}
		]
	];

	compatibleFractionCollectionAndNeedleWashBufferQ = !And[
		noCapableInstrumentQ,
		compatibleCountAndNeedleWashBufferQ,
		!MatchQ[countCapableInstruments, {}],
		MatchQ[
			Intersection[
				countCapableInstruments,
				scaleInstruments,
				fractionCollectionInstruments,
				needlewashBufferCDistinctInstruments
			],
			{}
		]
	];

	bufferNumberConflictQ = And[
		noCapableInstrumentQ,
		compatibleCountAndNeedleWashBufferQ,
		compatibleFractionCollectionAndNeedleWashBufferQ,
		!MatchQ[countCapableInstruments, {}],
		MatchQ[
			Intersection[
				countCapableInstruments,
				fractionCollectionInstruments,
				scaleInstruments,
				needlewashBufferCDistinctInstruments,
				gradientCapableInstruments,
				numberOfBufferInstruments
			],
			{}
		]
	];

	(* Check whether it is the detector's problem leading to no possible instrument *)
	detectorInstrumentConflictQ = And[
		noCapableInstrumentQ,
		!MatchQ[countCapableInstruments, {}],
		!MatchQ[
			Intersection[
				countCapableInstruments,
				fractionCollectionInstruments,
				scaleInstruments,
				needlewashBufferCDistinctInstruments,
				capableColumnTemperatureInstruments,
				sampleTemperatureInstruments,
				gradientCapableInstruments,
				numberOfBufferInstruments,
				flowRateCompatibleInstruments,
				capableInjectionVolumeInstruments,
				impliedInstruments,
				columnSelectorInstruments,
				maxAccelerationInstruments
			],
			{}
		],
		(* Stand-alone HPLC with I-Class *)
		!nonInternalHPLCErrorQ
	];

	detectorInstrumentConflictOptions = If[detectorInstrumentConflictQ,
		Which[
			MatchQ[detectorOption, Except[{Automatic} | Automatic | Null]], {Detector},
			MatchQ[Lookup[roundedOptionsAssociation, FractionCollectionDetector], Except[Automatic]], {FractionCollectionDetector},
			(* If our invalid option is from impliedDetector, we still track Detector option *)
			True, {Detector}
		],
		{}
	];

	(* Check if it is the ColumnSelector issue that caused the unresolvable instrument *)
	incompatibleColumnSelectorQ=And[
		noCapableInstrumentQ,
		!MatchQ[
			Intersection[
				countCapableInstruments,
				fractionCollectionInstruments,
				scaleInstruments,
				needlewashBufferCDistinctInstruments,
				capableColumnTemperatureInstruments,
				sampleTemperatureInstruments,
				gradientCapableInstruments,
				numberOfBufferInstruments,
				flowRateCompatibleInstruments,
				detectorCapableInstruments,
				capableInjectionVolumeInstruments,
				impliedInstruments,
				maxAccelerationInstruments
			],
			{}
		],
		(* Stand-alone HPLC with I-Class *)
		!nonInternalHPLCErrorQ
	];

	(* We've already test above cases where an instrument is specified. Here we need to test that the _resolved_ instrument is not incompatible. In other words, if there are options specified that mean an instrument cannot be resolved, we need to find the combination of options that are conflicting *)

	(* SampleTemperature cannot be a temperature when the instrument doesn't support it *)
	compatibleSampleTemperatureQ = Which[
		!NullQ[possibleInstrument],
		(* If there is a possible instrument, check if the temperature range is good *)
		If[MatchQ[sampleTemperatureOption, TemperatureP],
			If[MatchQ[Lookup[possibleInstrumentModelPacket, {MinSampleTemperature, MaxSampleTemperature}, {Null, Null}], {Null, Null}],
				(* Check whether we have temperature control*)
				False,
				(* Check whether the specified temperature is in the right range *)
				MatchQ[sampleTemperatureOption, RangeP[Sequence @@ Lookup[possibleInstrumentModelPacket, {MinSampleTemperature, MaxSampleTemperature}]]]
			],
			True
		],
		(* Stand-alone HPLC with I-Class. Avoid duplicate message *)
		nonInternalHPLCErrorQ,
		True,
		(* Otherwise we can check if sample temperature is the issue here *)
		True,
		MatchQ[
			Intersection[
				countCapableInstruments,
				fractionCollectionInstruments,
				needlewashBufferCDistinctInstruments,
				capableColumnTemperatureInstruments,
				gradientCapableInstruments,
				numberOfBufferInstruments,
				detectorCapableInstruments,
				capableInjectionVolumeInstruments,
				impliedInstruments,
				columnSelectorInstruments,
				maxAccelerationInstruments
			],
			{}
		]
	];

	(* CollectFractions cannot be true if specified Detector does not match Dionex or Agilent's detector *)
	compatibleCollectFractionsDetectorQ = !And[
		MemberQ[collectFractions, True],
		If[MatchQ[Lookup[roundedOptionsAssociation, Detector], Automatic],
			False,
			(* Did the user specify a detector that's not available, then throw an error *)
			!SubsetQ[Lookup[possibleInstrumentModelPacket, Detectors, {}], ToList@Lookup[roundedOptionsAssociation, Detector]]
		]
	];

	(* Instrument must be Dionex/Agilent if Scale is SemiPreparative or Preparative *)
	compatibleScaleQ = Or[
		(* Valid if Analytical *)
		MatchQ[resolvedScale, Analytical],
		(* If no possible instrument, we don't want to throw too many errors *)
		NullQ[possibleInstrument],
		And[
			MatchQ[resolvedScale, SemiPreparative],
			MatchQ[Lookup[possibleInstrumentModelPacket, Object, Null], dionexHPLCPattern|agilentHPLCPattern]
		],
		And[
			MatchQ[resolvedScale, Preparative],
			MatchQ[Lookup[possibleInstrumentModelPacket, Object, Null], agilentHPLCPattern]
		]
	];

	(* Any specified detection wavelengths must be within one of the instruments' ranges *)
	compatibleWavelengthsQ = And @@ Map[
		Which[
			(* If automatic or Null return True *)
			MatchQ[#, (Automatic | Null | All)], True,
			(* If a span. check each part *)
			MatchQ[#, _Span],
			And[
				MatchQ[#[[1]], RangeP @@ Lookup[possibleInstrumentModelPacket, {MinAbsorbanceWavelength, MaxAbsorbanceWavelength}]],
				MatchQ[#[[-1]], RangeP @@ Lookup[possibleInstrumentModelPacket, {MinAbsorbanceWavelength, MaxAbsorbanceWavelength}]]
			],
			(* Otherwise singleton value that we can check *)
			True, MatchQ[#, RangeP @@ Lookup[possibleInstrumentModelPacket, {MinAbsorbanceWavelength, MaxAbsorbanceWavelength}]]
		]&,
		Flatten[Lookup[roundedOptionsAssociation, absorbanceWavelengthOptions]]
	];

	(* Any specified column temperatures must be within one of the instruments' ranges *)
	compatibleColumnTemperaturesQ = Or[
		NullQ[possibleInstrument],
		MemberQ[
			Download[#, Object]& /@ capableColumnTemperatureInstruments,
			If[Length[possibleInstrumentModelPacket] == 0,
				Null,
				Download[possibleInstrumentModelPacket, Object]
			]
		]
	];

	(* Check that InjectionVolume is not an issue *)
	compatibleInjectionVolumeQ = Or[
		NullQ[possibleInstrument],
		Length[allInjectionVolumes] == 0,
		And[
			Length[allInjectionVolumes] > 0,
			Min[allInjectionVolumes] >= Lookup[possibleInstrumentModelPacket, MinSampleVolume],
			Max[allInjectionVolumes] <= Lookup[possibleInstrumentModelPacket, MaxSampleVolume]
		]
	];

	(* If we are below the recommended volume, let's throw a warning *)
	tooSmallInjectionVolumeQ = !Or[
		(* Do not accumulate another warning if we are already giving an error *)
		!compatibleInjectionVolumeQ,
		Or[
			NullQ[possibleInstrument],
			Length[allInjectionVolumes] == 0,
			And[
				Length[allInjectionVolumes] > 0,
				Min[allInjectionVolumes] >= Lookup[possibleInstrumentModelPacket, RecommendedSampleVolume, 0Microliter] /. {Null -> 0Microliter}
			]
		]
	];

	(* Assemble tests for all above checks *)
	instrumentResolutionTests = {
		If[incompatibleColumnSelectorQ,
			(
				If[messagesQ,
					Message[
						Error::ColumnSelectorInstrumentConflict,
						resolvedColumnSelector,
						Length[resolvedColumnSelector],
						Intersection[
							countCapableInstruments,
							fractionCollectionInstruments,
							scaleInstruments,
							needlewashBufferCDistinctInstruments,
							capableColumnTemperatureInstruments,
							sampleTemperatureInstruments,
							gradientCapableInstruments,
							numberOfBufferInstruments,
							capableInjectionVolumeInstruments,
							maxAccelerationInstruments
						]
					];
				];
				testOrNull["The specified ColumnSelector is compatible with the required instrument:", False]
			),
			testOrNull["The specified ColumnSelector is compatible with the required instrument:", True]
		],
		If[!compatibleScaleQ,
			(
				If[messagesQ,
					Message[Error::ScaleInstrumentConflict, Lookup[roundedOptionsAssociation, Scale], possibleInstrument];
				];
				testOrNull["The specified Scale is compatible with the required instrument:", False]
			),
			testOrNull["The specified Scale is compatible with the required instrument:", True]
		],
		If[!compatibleSampleTemperatureQ && validSampleTemperatureQ && validSampleTemperatureAndDionexDetectorQ && (And @@ {validDetectionWavelengthQ, validStandardDetectionWavelengthQ, validBlankDetectionWavelengthQ, validColumnPrimeDetectionWavelengthQ, validColumnFlushDetectionWavelengthQ}),
			(
				If[messagesQ,
					Message[Error::SampleTemperatureConflict];
				];
				testOrNull["SampleTemperature is not a temperature when an instrument without SampleTemperature control is chosen:", False]
			),
			testOrNull["SampleTemperature is not a temperature when an instrument without SampleTemperature control is chosen:", True]
		],
		If[!compatibleCollectFractionsDetectorQ,
			(
				If[messagesQ,
					Message[Error::FractionCollectionDetectorConflict, ObjectToString[Model[Instrument, HPLC, "UltiMate 3000"]], Lookup[First[dionexHPLCInstrumentPackets], AbsorbanceDetector]];
				];
				testOrNull[StringTemplate["Fraction collection parameters are not specified when the specified Detector does not match the AbsorbanceDetector (`2`) of `1`:"][Model[Instrument, HPLC, "UltiMate 3000"], Lookup[First[dionexHPLCInstrumentPackets], AbsorbanceDetector]], False]
			),
			testOrNull[StringTemplate["Fraction collection parameters are not specified when the specified Detector does not match the AbsorbanceDetector (`2`) of `1`:"][Model[Instrument, HPLC, "UltiMate 3000"], Lookup[First[dionexHPLCInstrumentPackets], AbsorbanceDetector]], True]
		],
		If[!compatibleWavelengthsQ && !incompatibleDetectionWavelengthsQ && validDetectionWavelengthQ && validStandardDetectionWavelengthQ && validBlankDetectionWavelengthQ && validColumnPrimeDetectionWavelengthQ && validColumnFlushDetectionWavelengthQ,
			(
				If[messagesQ,
					Message[Error::IncompatibleDetectionWavelength, Sequence @@ Lookup[possibleInstrumentModelPacket, {MinAbsorbanceWavelength, MaxAbsorbanceWavelength}]];
				];
				Map[
					If[
						MemberQ[
							ToList[Lookup[roundedOptionsAssociation, #]],
							Except[(Automatic | RangeP @@ Lookup[possibleInstrumentModelPacket, {MinAbsorbanceWavelength, MaxAbsorbanceWavelength}])]
						],
						Switch[#,
							AbsorbanceWavelength,
							compatibleDetectionWavelengthQ = False,
							StandardAbsorbanceWavelength,
							compatibleStandardDetectionWavelengthQ = False,
							BlankAbsorbanceWavelength,
							compatibleBlankDetectionWavelengthQ = False,
							ColumnPrimeAbsorbanceWavelength,
							compatibleColumnPrimeDetectionWavelengthQ = False,
							ColumnFlushAbsorbanceWavelength,
							compatibleColumnFlushDetectionWavelengthQ = False
						]
					]&,
					absorbanceWavelengthOptions
				];
				testOrNull["Detection wavelengths are compatible with at least one instrument model:", False]
			),
			testOrNull["Detection wavelengths are compatible with at least one instrument model:", True]
		],
		If[!compatibleColumnTemperaturesQ && !deprecatedInstrumentQ && compatibleSampleTemperatureQ,
			(
				instrumentColumnTemperatureRange = If[MatchQ[instrumentOption, Automatic],
					{Min[Lookup[allHPLCInstrumentPackets, MinColumnTemperature]], Max[Lookup[allHPLCInstrumentPackets, MaxColumnTemperature]]},
					Lookup[fetchPacketFromCacheHPLC[Download[instrumentOption, Object], cache], {MinColumnTemperature, MaxColumnTemperature}]
				];
				invalidColumnTemperatureOptions = If[injectionTableSpecifiedQ,
					{ColumnTemperature, StandardColumnTemperature, BlankColumnTemperature, ColumnPrimeTemperature, ColumnFlushTemperature,InjectionTable},
					{ColumnTemperature, StandardColumnTemperature, BlankColumnTemperature, ColumnPrimeTemperature, ColumnFlushTemperature}
				];
				If[messagesQ,
					Message[Error::IncompatibleHPLCColumnTemperature,First[instrumentColumnTemperatureRange], Last[instrumentColumnTemperatureRange]],
				testOrNull["Column temperatures are compatible with at least one instrument model:", False]
				]
			),
			invalidColumnTemperatureOptions={};
			testOrNull["Column temperatures are compatible with at least one instrument model:", True]
		],
		If[!compatibleInjectionVolumeQ,
			(
				If[messagesQ,
					Message[Error::HPLCIncompatibleInjectionVolume, ToString[Cases[allInjectionVolumes, GreaterP[Lookup[possibleInstrumentModelPacket, MaxSampleVolume]] | LessP[Lookup[possibleInstrumentModelPacket, MinSampleVolume]]]], ObjectToString[possibleInstrument], ToString[Lookup[possibleInstrumentModelPacket, MinSampleVolume]], ToString[Lookup[possibleInstrumentModelPacket, MaxSampleVolume]]];
				];
				testOrNull["Sample/Standard/Blank InjectionVolume values are compatible with at least one instrument model:", False]
			),
			testOrNull["Sample/Standard/Blank InjectionVolume values are compatible with at least one instrument model:", True]
		],
		If[tooSmallInjectionVolumeQ,
			(
				If[messagesQ,
					Message[Warning::HPLCSmallInjectionVolume, ToString[Cases[allInjectionVolumes, LessP[Lookup[possibleInstrumentModelPacket, RecommendedSampleVolume]]]], ObjectToString[possibleInstrument], ToString[Lookup[possibleInstrumentModelPacket, RecommendedSampleVolume]]];
				];
				warningOrNull["Sample/Standard/Blank InjectionVolume values are higher than the minimum recommended injection volume:", False]
			),
			warningOrNull["Sample/Standard/Blank InjectionVolume values are higher than the minimum recommended injection volume:", True]
		],
		If[
			(* If we get conflict between the number of Containers and the NeedleWashBuffer, throw error *)
			And[
				!compatibleCountAndNeedleWashBufferQ,
				(* Avoid all other instrument related errors *)
				validSampleTemperatureQ && validBufferDQ && validGradientDQ && (validDetectionWavelengthQ && validStandardDetectionWavelengthQ && validBlankDetectionWavelengthQ && validColumnPrimeDetectionWavelengthQ && validColumnFlushDetectionWavelengthQ) && validBufferDNullQ && compatibleDetectorQ && validSampleTemperatureAndDionexDetectorQ && validBufferDAndDionexDetectorQ && validGradientDAndDionexDetectorQ && compatibleSampleTemperatureQ && compatibleCollectFractionsDetectorQ && compatibleScaleQ && compatibleWavelengthsQ && compatibleColumnTemperaturesQ && compatibleInjectionVolumeQ
			],
			(
				If[messagesQ,
					Message[Error::IncompatibleContainerAndNeedleWashBuffer, ObjectToString[secondaryInstrumentDefault]];
				];
				testOrNull["When BufferC and NeedleWashSolution are different, all sample containers must fit onto " <> ObjectToString[secondaryInstrumentDefault] <> " .", False]
			),
			testOrNull["When BufferC and NeedleWashSolution are different, all sample containers must fit onto " <> ObjectToString[secondaryInstrumentDefault] <> " .", True]
		],
		If[
			(* If we get conflict between the requirement of fraction collection and the NeedleWashBuffer, throw error *)
			And[
				!compatibleFractionCollectionAndNeedleWashBufferQ,
				(* Avoid all other instrument related errors *)
				validSampleTemperatureQ && validBufferDQ && validGradientDQ && (validDetectionWavelengthQ && validStandardDetectionWavelengthQ && validBlankDetectionWavelengthQ && validColumnPrimeDetectionWavelengthQ && validColumnFlushDetectionWavelengthQ) && validBufferDNullQ && compatibleDetectorQ && validSampleTemperatureAndDionexDetectorQ && validBufferDAndDionexDetectorQ && validGradientDAndDionexDetectorQ && compatibleSampleTemperatureQ && compatibleCollectFractionsDetectorQ && compatibleScaleQ && compatibleWavelengthsQ && compatibleColumnTemperaturesQ && compatibleInjectionVolumeQ
			],
			(
				If[messagesQ,
					Message[Error::IncompatibleFractionCollectionAndNeedleWashBuffer];
				];
				testOrNull["When BufferC and NeedleWashSolution are different, SemiPreparative scale HPLC cannot be performed.", False]
			),
			testOrNull["When BufferC and NeedleWashSolution are different, SemiPreparative scale HPLC cannot be performed.", True]
		],
		If[
			(* If we get conflict between the requirement of fraction collection and the NeedleWashBuffer, throw error *)
			And[
				bufferNumberConflictQ,
				(* Avoid all other instrument related errors *)
				validSampleTemperatureQ && validBufferDQ && validGradientDQ && (validDetectionWavelengthQ && validStandardDetectionWavelengthQ && validBlankDetectionWavelengthQ && validColumnPrimeDetectionWavelengthQ && validColumnFlushDetectionWavelengthQ) && validBufferDNullQ && compatibleDetectorQ && validSampleTemperatureAndDionexDetectorQ && validBufferDAndDionexDetectorQ && validGradientDAndDionexDetectorQ && compatibleSampleTemperatureQ && compatibleCollectFractionsDetectorQ && compatibleScaleQ && compatibleWavelengthsQ && compatibleColumnTemperaturesQ && compatibleInjectionVolumeQ
			],
			(
				If[messagesQ,
					Message[Error::IncompatibleInstrumentBufferD];
				];
				testOrNull["BufferD and its gradient is only available on the Waters Acquity UPLC H-Class instrument and cannot support fraction collection.", False]
			),
			testOrNull["BufferD and its gradient is only available on the Waters Acquity UPLC H-Class instrument and cannot support fraction collection.", True]
		],
		(* It is very possible that the problem is from the detector *)
		If[
			And[
				detectorInstrumentConflictQ,
				(* Avoid all other instrument related errors *)
				validSampleTemperatureQ && validBufferDQ && validGradientDQ && (validDetectionWavelengthQ && validStandardDetectionWavelengthQ && validBlankDetectionWavelengthQ && validColumnPrimeDetectionWavelengthQ && validColumnFlushDetectionWavelengthQ) && validBufferDNullQ && compatibleDetectorQ && validSampleTemperatureAndDionexDetectorQ && validBufferDAndDionexDetectorQ && validGradientDAndDionexDetectorQ && compatibleSampleTemperatureQ && compatibleCollectFractionsDetectorQ && compatibleScaleQ && compatibleWavelengthsQ && compatibleColumnTemperaturesQ && compatibleInjectionVolumeQ
			],
			(
				If[messagesQ,
					Message[Error::NoSuitableInstrumentForDetection,
						(* Detectors *)
						Which[
							MatchQ[detectorOption, Except[{Automatic} | Automatic | Null]], detectorOption,
							MatchQ[Lookup[roundedOptionsAssociation, FractionCollectionDetector], Except[Automatic]], Lookup[roundedOptionsAssociation, FractionCollectionDetector],
							True, impliedDetectors
						],
						(* Where the detector is from *)
						Which[
							MatchQ[detectorOption, Except[{Automatic} | Automatic | Null]], Detector,
							MatchQ[Lookup[roundedOptionsAssociation, FractionCollectionDetector], Except[Automatic]], FractionCollectionDetector,
							(* If our invalid option is from impliedDetector, we don't want to give a long list here*)
							True, "the detection options related to " <> ToString[impliedDetectors]
						]
					];
				];
				testOrNull["The required detector(s) must be available from an instrument that is compatible with other selected options.", False]
			),
			testOrNull["The required detector(s) must be available from an instrument that is compatible with other selected options.", True]
		],
		(* We got no instrument because we are doing I-Class HPLC *)
		If[nonInternalHPLCErrorQ,
			If[messagesQ,
				Message[Error::NonSupportedHPLCInstrument];
			];
			testOrNull["Waters I-Class instruments cannot be used in ExperimentHPLC. They are only supported in ExperimentLCMS.", False],
			testOrNull["Waters I-Class instruments cannot be used in ExperimentHPLC. They are only supported in ExperimentLCMS.", True]
		],
		(* Last case - this is a really general error message but this should be the very last case that all the other error messages didn't catch *)
		If[And[
			noCapableInstrumentQ,
			!nonInternalHPLCErrorQ,
			(* Avoid all other instrument related errors *)
			validSampleTemperatureQ && validBufferDQ && validGradientDQ && (validDetectionWavelengthQ && validStandardDetectionWavelengthQ && validBlankDetectionWavelengthQ && validColumnPrimeDetectionWavelengthQ && validColumnFlushDetectionWavelengthQ) && validBufferDNullQ && compatibleDetectorQ && validSampleTemperatureAndDionexDetectorQ && validBufferDAndDionexDetectorQ && validGradientDAndDionexDetectorQ && compatibleSampleTemperatureQ && compatibleCollectFractionsDetectorQ && compatibleScaleQ && !incompatibleColumnSelectorQ && compatibleWavelengthsQ && compatibleColumnTemperaturesQ && compatibleInjectionVolumeQ,
			(* Avoid other instrument checks leading to Null capableInstruments *)
			compatibleCountAndNeedleWashBufferQ && compatibleFractionCollectionAndNeedleWashBufferQ && !bufferNumberConflictQ && !detectorInstrumentConflictQ
		],
			If[messagesQ,
				Message[Error::NoSuitableHPLCInstrument];
			];
			testOrNull["There is at least one HPLC instrument that can match all the required options.", False],
			testOrNull["There is at least one HPLC instrument that can match all the required options.", True]
		]
	};

	(* Default Null (erroneous case) to dionex *)
	resolvedInstrument = If[NullQ[possibleInstrument],
		Model[Instrument, HPLC, "UltiMate 3000"],
		possibleInstrument
	];

	(* Fetch resolved instrument's model packet *)
	instrumentModelPacket = If[MatchQ[resolvedInstrument, ObjectP[Model]],
		fetchPacketFromCacheHPLC[resolvedInstrument, cache],
		fetchModelPacketFromCacheHPLC[resolvedInstrument, cache]
	];

	(* Extract instrument model's object *)
	instrumentModel = Lookup[instrumentModelPacket, Object];

	(* Figure out what left instruments we have *)
	leftoverInstruments = DeleteCases[capableInstruments, ObjectP[Flatten[{instrumentModel,agilentHPLCInstruments}]]];

	(* If the user specified the alternate instruments, the we do some error checking *)
	(* The pattern has required Instrument option to be a single Instrument object, single Instrument Model or a list of Instrument models *)
	(* We currently have one Instrument option to cover all the instruments. The alternateInstrumentsOption is defined as the Instrument option minus the primary instrument we selected earlier *)
	(* Resolve a possible list of alternate instruments so that we can check the dimensions of the column oven *)
	semiResolvedAlternateInstruments = Switch[alternateInstrumentsOption,
		(* If it's specified, no problems *)
		Except[Automatic], alternateInstrumentsOption,
		(* If it's automatic, then we return the leftover list, unless the resolved Instrument was specified as an Object and we Null it *)
		(*also if we have to put column outside, remember to get rid of Waters instruments*)
		Automatic,
		If[MatchQ[resolvedInstrument, ObjectP[Object]],
			{},
			leftoverInstruments
		]
	];


	(* Post Instrument resolutions and error checking *)
	(* Check whether the resolved instrument is a Waters or not *)
	(* Look up the instrument manufacturer *)
	instrumentManufacturer = Lookup[instrumentModelPacket, Manufacturer] /. x_Link :> Download[x, Object];

	(* Is it a waters instrument? *)
	watersManufacturedQ = MatchQ[instrumentManufacturer, ObjectP[Object[Company, Supplier, "id:aXRlGnZmpK1v"](* "Waters" *)]];

	(* Finally resolve BufferC and NeedleWashSolution *)
	resolvedBufferC = Which[
		MatchQ[Lookup[roundedOptionsAssociation, BufferC], Except[Automatic]], Lookup[roundedOptionsAssociation, BufferC],
		(* Check whether the needle wash solution is specified and we have a dionex instrument *)
		And[
			MatchQ[instrumentModel, ObjectP[dionexHPLCInstruments]],
			MatchQ[Lookup[roundedOptionsAssociation, NeedleWashSolution], Except[Automatic]]
		],
		Lookup[roundedOptionsAssociation, NeedleWashSolution],
		(* If the user specified a gradient method, we'll want to take from there *)
		Count[bufferCMethodList, ObjectP[Model[Sample]]] > 0, FirstCase[bufferCMethodList, ObjectP[Model[Sample]]],
		(* Model[Sample, "Milli-Q water"] *)
		MatchQ[resolvedSeparationMode, IonExchange | SizeExclusion], Model[Sample, "id:8qZ1VWNmdLBD"],
		(* Model[Sample, "Acetonitrile, HPLC Grade"] if user wants to use BufferC*)
		anyGradientCQ, Model[Sample, "id:O81aEB4kJXr1"],
		(* Otherwise, we use Model[Sample, StockSolution, "20% Methanol in MilliQ Water"] in case to clean the needles *)
		True, Model[Sample, StockSolution, "id:Z1lqpMzmp5MO"]
	];

	resolvedNeedleWashSolution = Which[
		MatchQ[Lookup[roundedOptionsAssociation, NeedleWashSolution], Except[Automatic]], Lookup[roundedOptionsAssociation, NeedleWashSolution],
		MatchQ[instrumentModel, ObjectP[dionexHPLCInstruments]], resolvedBufferC,
		(* Model[Sample, "Milli-Q water"] *)
		MatchQ[resolvedSeparationMode, IonExchange | SizeExclusion], Model[Sample, "id:8qZ1VWNmdLBD"],
		(* Otherwise we use Model[Sample, StockSolution, "20% Methanol in MilliQ Water"] *)
		True, Model[Sample, StockSolution, "id:Z1lqpMzmp5MO"]
	];

	(* Need to do a final check whether bufferC and needlewash are different, and if the instrument is a Dionex *)
	incompatibleNeedleWashQ = If[noCapableInstrumentQ,
		False,
		And[
			!SameObjectQ[resolvedBufferC, resolvedNeedleWashSolution],
			MatchQ[instrumentModel, dionexHPLCPattern]
		]
	];

	{incompatibleNeedleWashOptions, incompatibleNeedleWashTest} = If[incompatibleNeedleWashQ,
		If[messagesQ,
			Message[Error::IncompatibleNeedleWash, resolvedInstrument]
		];
		{{NeedleWashSolution}, testOrNull["If the resolved Instrument shares BufferC and NeedleWashSolution, they are not specified distinctly:", False]},
		{{}, testOrNull["If the resolved Instrument shares BufferC and NeedleWashSolution, they are not specified distinctly:", True]}
	];

	(* Check whether we resolved to a buffer that clashes with what was in the specified gradient methods *)
	{
		bufferAClashQ,
		bufferBClashQ,
		bufferCClashQ,
		bufferDClashQ
	} = MapThread[
		Function[
			{resolved, methodList},
			(* Check whether the resolved matches all the gradient methods *)
			If[!NullQ[resolved] && MatchQ[methodList, Except[ListableP[Null]]],
				TrueQ[Length[Complement[methodList, {Download[resolved, Object]}]] > 0],
				False
			]
		],
		{
			{resolvedBufferA, resolvedBufferB, resolvedBufferC, resolvedBufferD},
			{bufferAMethodList, bufferBMethodList, bufferCMethodList, bufferDMethodList}
		}
	];

	(* Throw a warning if we have any clashes *)
	If[messagesQ && !engineQ && Or[bufferAClashQ, bufferBClashQ, bufferCClashQ, bufferDClashQ],
		Message[
			Warning::HPLCBufferConflict,
			PickList[{BufferA, BufferB, BufferC, BufferD}, {bufferAClashQ, bufferBClashQ, bufferCClashQ, bufferDClashQ}],
			ObjectToString@PickList[{resolvedBufferA, resolvedBufferB, resolvedBufferC, resolvedBufferD}, {bufferAClashQ, bufferBClashQ, bufferCClashQ, bufferDClashQ}],
			ObjectToString@PickList[{bufferAMethodList, bufferBMethodList, bufferCMethodList, bufferDMethodList}, {bufferAClashQ, bufferBClashQ, bufferCClashQ, bufferDClashQ}]
		]
	];

	(* Finally resolve IncubateColumn boolean and do error checking - need to do this when we have all columns resolved and also instrument resolved *)
	(* Get all the positions *)
	allInstrumentPositions = Lookup[instrumentModelPacket, Positions, {}];

	instrumentMaxColumnLength = Lookup[instrumentModelPacket, MaxColumnLength, Infinity*Meter]/.{Null->Infinity*Meter};

	(* Find the column slot of the Instrument - Depending on the configuration of the column oven (vertical or horizontal) *)
	columnPosition = FirstCase[allInstrumentPositions, KeyValuePattern[Name -> "Column Slot"], <||>];
	columnPositionWidth = If[MatchQ[columnPosition, <||>],
		Infinity * Meter,
		Max[DeleteCases[Lookup[columnPosition, {MaxWidth, MaxDepth, MaxHeight}, Null], Null]]
	];
	{columnPositionDepth, columnPositionHeight} = If[MatchQ[columnPosition, <||>],
		{Infinity * Meter, Infinity * Meter},
		DeleteCases[Lookup[columnPosition, {MaxWidth, MaxDepth, MaxHeight}, Infinity * Meter], columnPositionWidth] /. {Null -> Infinity * Meter}
	];

	(* Find the column size info *)
	(* Get the largest diamter of all columns. This should be smaller than the width and depth of the instrument column slot *)
	maxColumnDiameter = Max[
		Append[
			Map[
				(Lookup[fetchPacketFromCacheHPLC[#, cache], Diameter, 0Millimeter] /. {Null -> 0Millimeter})&,
				Cases[Flatten[{resolvedColumnSelector}], ObjectP[]]
			],
			0Meter
		]
	];

	(* Get the total length of the columns *)
	maxTotalColumnLength = If[MatchQ[resolvedColumnSelector, Listable[{Null...}] | Null],
		0Millimeter,
		Max[
			Map[
				Function[
					{individualColumnSelector},
					Total[
						Map[
							Which[
								MatchQ[#, ObjectP[Model]],
								Max[Lookup[fetchPacketFromCacheHPLC[#, cache], Dimensions, {0Millimeter, 0Millimeter, 0Millimeter}]/.{Null->{0Millimeter, 0Millimeter, 0Millimeter}}],
								MatchQ[#, ObjectP[Object]],
								Max[Lookup[fetchModelPacketFromCacheHPLC[#, cache], Dimensions, {0Millimeter, 0Millimeter, 0Millimeter}]/.{Null->{0Millimeter, 0Millimeter, 0Millimeter}}],
								True,
								0Meter
							]&,
							individualColumnSelector
						]
					]
				],
				resolvedColumnSelector
			]
		]
	];

	(* Can the column fit into column compartment? - Make some room for diameter in Dionex as the inlet/outlet tend to be larger and this is significant for prep columns*)
	columnsFitQ = If[MatchQ[Lookup[instrumentModelPacket, Object], dionexHPLCPattern],
		And[
			Or[
				MatchQ[columnPositionDepth, Infinity * Meter],
				TrueQ[maxColumnDiameter <= columnPositionDepth - 6Millimeter]
			],
			Or[
				MatchQ[columnPositionHeight, Infinity * Meter],
				TrueQ[maxColumnDiameter <= columnPositionHeight - 6Millimeter]
			],
			Or[
				MatchQ[columnPositionWidth,Infinity*Meter]&&MatchQ[instrumentMaxColumnLength, Infinity*Meter],
				(* MM 12.0.1 throws errors when comparing quantities involving Infinity *)
				(* Convert to unitless for the comparison and reconvert to a quantity after *)
				TrueQ[maxTotalColumnLength<=Min[Unitless[{columnPositionWidth, instrumentMaxColumnLength}, Meter]] * Meter]
			]
		],
		And[
			Or[
				MatchQ[columnPositionDepth, Infinity * Meter],
				TrueQ[maxColumnDiameter <= columnPositionDepth - 2Millimeter]
			],
			Or[
				MatchQ[columnPositionHeight, Infinity * Meter],
				TrueQ[maxColumnDiameter <= columnPositionHeight - 2Millimeter]
			],
			Or[
				MatchQ[columnPositionWidth,Infinity*Meter]&&MatchQ[instrumentMaxColumnLength, Infinity*Meter],
				(* MM 12.0.1 throws errors when comparing quantities involving Infinity *)
				(* Convert to unitless for the comparison and reconvert to a quantity after *)
				TrueQ[maxTotalColumnLength<=Min[Unitless[{columnPositionWidth, instrumentMaxColumnLength}, Meter]] * Meter]
			]
		]
	];

	(* Perform the same check for the possible alternative instruments *)
	columnFitLeftOverInstrumentsQ = Map[
		Module[{individualInstrument, individualInstrumentPacket, individualInstrumentPositions, individualInstrumentColumnPosition, individualInstrumentColumnPositionWidth, individualInstrumentMaxColumnLength, individualInstrumentColumnPositionDepth, individualInstrumentColumnPositionHeight},
			individualInstrument = Download[#, Object];
			individualInstrumentPacket = If[MatchQ[individualInstrument, ObjectP[Model]],
				fetchPacketFromCacheHPLC[individualInstrument, cache],
				fetchModelPacketFromCacheHPLC[individualInstrument, cache]
			];
			individualInstrumentMaxColumnLength=Lookup[individualInstrumentPacket, MaxColumnLength, Infinity*Meter]/.{Null->Infinity*Meter};
			individualInstrumentPositions = Lookup[individualInstrumentPacket, Positions, {}];
			individualInstrumentColumnPosition = FirstCase[individualInstrumentPositions, KeyValuePattern[Name -> "Column Slot"], <||>];

			individualInstrumentColumnPositionWidth = If[MatchQ[individualInstrumentColumnPosition, <||>],
				Infinity * Meter,
				Max[DeleteCases[Lookup[individualInstrumentColumnPosition, {MaxWidth, MaxDepth, MaxHeight}, Null], Null]]
			];
			{individualInstrumentColumnPositionDepth, individualInstrumentColumnPositionHeight} = If[MatchQ[individualInstrumentColumnPosition, <||>],
				{Infinity * Meter, Infinity * Meter},
				DeleteCases[Lookup[individualInstrumentColumnPosition, {MaxWidth, MaxDepth, MaxHeight}, Infinity * Meter], individualInstrumentColumnPositionWidth] /. {Null -> Infinity * Meter}
			];

			If[MatchQ[Lookup[individualInstrumentPacket, Object], dionexHPLCPattern],
				And[
					Or[
						MatchQ[individualInstrumentColumnPositionDepth, Infinity * Meter],
						TrueQ[maxColumnDiameter <= individualInstrumentColumnPositionDepth - 6Millimeter]
					],
					Or[
						MatchQ[individualInstrumentColumnPositionHeight, Infinity * Meter],
						TrueQ[maxColumnDiameter <= individualInstrumentColumnPositionHeight - 6Millimeter]
					],
					Or[
						MatchQ[individualInstrumentColumnPositionWidth,Infinity*Meter]&&MatchQ[individualInstrumentMaxColumnLength,Infinity*Meter],
						(* MM 12.0.1 throws errors when comparing quantities involving Infinity *)
						(* Convert to unitless for the comparison and reconvert to a quantity after *)
						TrueQ[maxTotalColumnLength<=Min[Unitless[{individualInstrumentColumnPositionWidth, individualInstrumentMaxColumnLength}, Meter]] * Meter]
					]
				],
				And[
					Or[
						MatchQ[individualInstrumentColumnPositionDepth, Infinity * Meter],
						TrueQ[maxColumnDiameter <= individualInstrumentColumnPositionDepth - 2Millimeter]
					],
					Or[
						MatchQ[individualInstrumentColumnPositionHeight, Infinity * Meter],
						TrueQ[maxColumnDiameter <= individualInstrumentColumnPositionHeight - 2Millimeter]
					],
					Or[
						MatchQ[individualInstrumentColumnPositionWidth,Infinity*Meter]&&MatchQ[individualInstrumentMaxColumnLength,Infinity*Meter],
						(* MM 12.0.1 throws errors when comparing quantities involving Infinity *)
						(* Convert to unitless for the comparison and reconvert to a quantity after *)
						TrueQ[maxTotalColumnLength<=Min[Unitless[{individualInstrumentColumnPositionWidth, individualInstrumentMaxColumnLength}, Meter]] * Meter]
					]
				]
			]
		]&,
		semiResolvedAlternateInstruments
	];

	validAlternateInstruments = PickList[semiResolvedAlternateInstruments, columnFitLeftOverInstrumentsQ, True];

	(* Resolve IncubateColumn *)
	resolvedIncubateColumn = Which[
		(* IncubateColumn is not an option in LCMS yet *)
		internalUsageQ, True,
		!MatchQ[Lookup[roundedOptionsAssociation, IncubateColumn], Automatic], Lookup[roundedOptionsAssociation, IncubateColumn],
		(* IncubateColumn must be True for Waters *)
		!MatchQ[Lookup[instrumentModelPacket, Object], dionexHPLCPattern], True,
		!columnsFitQ, False,
		!columnSelectorQ, Null,
		True, True
	];

	(* Check if our columns need to be incubated at a temperature *)
	columnTemperatureQ = MemberQ[Flatten[{resolvedColumnTemperatures, resolvedStandardColumnTemperatures, resolvedBlankColumnTemperatures, resolvedPrimeColumnTemperatures, resolvedFlushColumnTemperatures}], Except[Null | AmbientTemperatureP]];

	(* Error Checking 1 - Cannot incubate column when columns do not fit into column compartment *)
	nonFitColumnOption = Which[
		!columnsFitQ && (resolvedIncubateColumn || columnTemperatureQ) && messagesQ && !internalUsageQ,
		Message[Error::HPLCColumnsCannotFit];{IncubateColumn},
		!columnsFitQ && internalUsageQ && messagesQ,
		Message[Error::HPLCColumnsCannotFitLCMS];{Column},
		True,
		{}
	];

	(* Gather Tests *)
	nonFitColumnTest = If[!internalUsageQ,
		testOrNull["If column incubation is desired, the specified columns can fit into the instrument's column oven compartment.", columnsFitQ || !resolvedIncubateColumn || !columnTemperatureQ],
		(* For LCMS *)
		testOrNull["The specified columns can fit into the column oven compartment of ChromatographyInstrument.", columnsFitQ]
	];

	(* Error Checking 2 - Cannot set column to a different temperature if we do not incubate the columns *)
	conflictColumnOvenOption = If[!resolvedIncubateColumn && columnTemperatureQ,
		Message[Error::HPLCCannotIncubateColumn];{IncubateColumn, ColumnTemperature, StandardColumnTemperature, BlankColumnTemperature, ColumnPrimeTemperature, ColumnFlushTemperature},
		{}
	];

	(* Gather Tests *)
	conflictColumnOvenTest = If[!internalUsageQ,
		testOrNull["If column temperature is not ambient, IncubateColumn option must be True and the columns must fit into the instrument's column oven compartment.", resolvedIncubateColumn || !columnTemperatureQ]
	];

	(* Error Checking 3 - Cannot incubate column in Waters as we cannot use the hook *)
	conflictColumnOutsideInstrument = If[!resolvedIncubateColumn && !MatchQ[Lookup[instrumentModelPacket, Object], dionexHPLCPattern],
		Message[Error::HPLCCannotIncubateColumnWaters, resolvedInstrument];{IncubateColumn},
		{}
	];

	(* Gather Tests *)
	conflictColumnOutsideInstrumentTest = If[!internalUsageQ,
		testOrNull["Column compartment cannot be skipped for Waters instruments.", resolvedIncubateColumn || MatchQ[Lookup[instrumentModelPacket, Object], dionexHPLCPattern]]
	];

	(* Error check for flow rate - need to do this after we have resolved the instrument *)
	(* Find the maximum possible FlowRate for the instrument and all the columns *)
	maxFlowRate = Min[
		Replace[
			Flatten[{
				Lookup[instrumentModelPacket, MaxFlowRate],
				Map[
					Lookup[fetchPacketFromCacheHPLC[#, cache], MaxFlowRate, Nothing]&,
					Cases[Flatten[{resolvedColumnSelector}], ObjectP[]]
				]
			}],
			Null -> Infinity Milliliter / Minute,
			{1}
		]
	];

	(* Build bool mask to make sure flow rates are compatible with instrument and column *)
	compatibleFlowRateBools = Map[
		Which[
			MatchQ[#, FlowRateP],
			TrueQ[(# <= maxFlowRate)],
			MatchQ[#, {{TimeP, FlowRateP}...}],
			TrueQ[(Max[#[[All, 2]]] <= maxFlowRate)],
			True,
			True
		]&,
		resolvedFlowRates
	];

	(* Build test based on flow rate compatibility *)
	validFlowRateTest = If[!(And @@ compatibleFlowRateBools),
		(
			If[messagesQ,
				Message[Error::IncompatibleFlowRate, ObjectToString /@ PickList[simulatedSamples, compatibleFlowRateBools, False], maxFlowRate]
			];
			compatibleFlowRateQ = False;
			testOrNull["The required flow rates for all samples are within the required instrument compatible range:", False]
		),
		testOrNull["The required flow rates for all samples are within the required instrument compatible range:", True]
	];

	(* Build bool mask to make sure blank flow rates are compatible with instrument *)
	compatibleBlankFlowRateBools = Map[
		Which[
			MatchQ[#, FlowRateP],
			TrueQ[(# <= maxFlowRate)],
			MatchQ[#, {{TimeP, FlowRateP}...}],
			TrueQ[(Max[#[[All, 2]]] <= maxFlowRate)],
			True,
			True
		]&,
		resolvedBlankFlowRates
	];

	validBlankFlowRateTest = If[!(And @@ compatibleBlankFlowRateBools),
		(
			If[messagesQ,
				Message[Error::IncompatibleBlankFlowRate, ObjectToString /@ PickList[blanks, compatibleBlankFlowRateBools, False], maxFlowRate]
			];
			compatibleBlankFlowRateQ = False;
			testOrNull["The required flow rates for all blanks are within the required instrument's compatible range:", False]
		),
		testOrNull["The required flow rates for all blanks are within the required instrument's compatible range:", True]
	];


	(* Build bool mask to make sure standard flow rates are compatible with instrument *)
	compatibleStandardFlowRateBools = Map[
		Which[
			MatchQ[#, FlowRateP],
			TrueQ[(# <= maxFlowRate)],
			MatchQ[#, {{TimeP, FlowRateP}...}],
			TrueQ[(Max[#[[All, 2]]] <= maxFlowRate)],
			True,
			True
		]&,
		resolvedStandardFlowRates
	];

	(* Build test based on flow rate compatibility *)
	validStandardFlowRateTest = If[!(And @@ compatibleStandardFlowRateBools),
		(
			If[messagesQ,
				Message[Error::IncompatibleStandardFlowRate, ObjectToString /@ PickList[resolvedStandard, compatibleStandardFlowRateBools, False], maxFlowRate]
			];
			compatibleStandardFlowRateQ = False;
			testOrNull["The required flow rates for all standards are within the required instrument's compatible range:", False]
		),
		testOrNull["The required flow rates for all standards are within the required instrument's compatible range:", True]
	];

	(* Build bool mask to make sure column prime flow rates are compatible with instrument *)
	compatibleColumnPrimeFlowRateBool = Map[
		Which[
			MatchQ[#, FlowRateP],
			TrueQ[(# <= maxFlowRate)],
			MatchQ[#, {{TimeP, FlowRateP}...}],
			TrueQ[(Max[#[[All, 2]]] <= maxFlowRate)],
			True,
			True
		]&,
		resolvedColumnPrimeFlowRates
	];

	(* Build test based on flow rate compatibility *)
	validColumnPrimeFlowRateTest = If[!NullQ[compatibleColumnPrimeFlowRateBool] && !(And @@ compatibleColumnPrimeFlowRateBool),
		(
			If[messagesQ,
				Message[Error::IncompatibleColumnPrimeFlowRate, ObjectToString /@ PickList[resolvedColumnSelector, compatibleColumnPrimeFlowRateBool, False], maxFlowRate]
			];
			compatibleColumnPrimeFlowRateQ = False;
			testOrNull["The required flow rate for the column prime is within the required instrument's compatible range:", False]
		),
		testOrNull["The required flow rates for the column prime is within the required instrument's compatible range:", True]
	];

	(* Build bool mask to make sure flow column flush rates are compatible with instrument *)
	compatibleColumnFlushFlowRateBool = Map[
		Which[
			MatchQ[#, FlowRateP],
			TrueQ[(# <= maxFlowRate)],
			MatchQ[#, {{TimeP, FlowRateP}...}],
			TrueQ[(Max[#[[All, 2]]] <= maxFlowRate)],
			True,
			True
		]&,
		resolvedColumnFlushFlowRates
	];

	(* Build test based on flow rate compatibility *)
	validColumnFlushFlowRateTest = If[!NullQ[compatibleColumnFlushFlowRateBool] && !(And @@ compatibleColumnFlushFlowRateBool),
		(
			If[messagesQ,
				Message[Error::IncompatibleColumnFlushFlowRate, ObjectToString /@ PickList[resolvedColumnSelector, compatibleColumnFlushFlowRateBool, False], maxFlowRate]
			];
			compatibleColumnFlushFlowRateQ = False;
			testOrNull["The required flow rate for the column flush is within the required instrument's compatible range:", False]
		),
		testOrNull["The required flow rates for the column flush is within the required instrument's compatible range:", True]
	];

	(* Check whether any of the gradients are defined as non-binary but we have an instrument that's only capable of binary*)
	nonBinaryOptionBool = Map[
		MemberQ[#, True] || TrueQ[#]&,
		{
			nonbinaryGradientBool,
			standardNonbinaryGradientBool,
			blankNonbinaryGradientBool,
			columnPrimeNonbinaryGradientBool,
			columnFlushNonbinaryGradientBool
		}
	];

	(* Are any of these true*)
	nonBinaryOptionQ = MemberQ[nonBinaryOptionBool, True];

	(* Is our instrument binary only? *)
	instrumentBinaryOnlyQ = MatchQ[Lookup[instrumentModelPacket, PumpType], Binary];

	(* If so, then get the offending options (and throw the error) *)
	nonBinaryOptions = If[nonBinaryOptionQ && messagesQ && instrumentBinaryOnlyQ,
		PickList[{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}, nonBinaryOptionBool],
		{}
	];

	If[messagesQ && nonBinaryOptionQ && instrumentBinaryOnlyQ,
		Message[Error::NonBinaryHPLC, nonBinaryOptions]
	];

	(* Generate the test testing for this issue *)
	nonBinaryGradientTest = If[gatherTestsQ,
		Test["If Gradient, StandardGradient, BlankGradient, ColumnFlushGradient, and/or ColumnPrimeGradient are specified, the gradient values are all binary if the instrument can only take binary gradients:",
			nonBinaryOptionQ && instrumentBinaryOnlyQ,
			False
		],
		Nothing
	];

	(* Finally resolve the alternate instruments option*)
	dionexpHInstrument = Map[
		Module[
			{packet},
			packet=fetchPacketFromCacheHPLC[#,cache];
			If[MemberQ[Lookup[packet,Detectors,{}],pH],
				#,
				Nothing
			]
		]&,
		dionexHPLCInstruments
	];
	{resolvedAlternateInstruments, invalidAlternateInstrumentsQ} = Switch[alternateInstrumentsOption,
		(* If it's Null, no problems*)
		{}, {{}, False},
		(* If it's automatic, then we return the leftover list, unless Instrument was specified; otherwise, it goes to Null*)
		(* Also if we have to put column outside, remember to get rid of Waters and Agilent instruments *)
		Automatic,
		{
			Which[
				MatchQ[instrumentOption, Automatic] && MatchQ[resolvedIncubateColumn,(True|Null)], DeleteCases[validAlternateInstruments, ObjectP[dionexpHInstrument]],
				MatchQ[instrumentOption, Automatic] && MatchQ[resolvedIncubateColumn, False], DeleteCases[Cases[leftoverInstruments, dionexHPLCPattern], ObjectP[dionexpHInstrument]],
				True, {}
			],
			False
		},
		(* If it's user specified, we got with it, but we make sure that everything is copacetic *)
		_,
		{
			alternateInstrumentsOption,
			Or[
				!SubsetQ[validAlternateInstruments, semiResolvedAlternateInstruments],
				!SubsetQ[leftoverInstruments, semiResolvedAlternateInstruments]
			]
		}
	];

	(* Combine the instruments together for full return *)
	combinedResolvedInstruments=If[!MatchQ[instrumentOption,Automatic],
		instrumentOption,
		If[MatchQ[resolvedInstrument,ObjectP[Object]],
			resolvedInstrument,
			Join[{resolvedInstrument},resolvedAlternateInstruments]
		]
	];

	(* Throw error message for Alternate Instruments *)
	If[invalidAlternateInstrumentsQ, Message[Error::InvalidHPLCAlternateInstruments]];

	(* --- Call CompatibleMaterialsQ to determine if the samples are chemically compatible with the instrument --- *)

	(*we include all of the samples here*)
	allSamplesInContact = Cases[Flatten@List[
		simulatedSamples,
		resolvedBufferA,
		resolvedBufferB,
		resolvedBufferC,
		resolvedBufferD,
		resolvedNeedleWashSolution
	], ObjectP[]];

	(* Call CompatibleMaterialsQ and figure out if materials are compatible *)
	{compatibleMaterialsBool, compatibleMaterialsTests} = If[gatherTestsQ,
		CompatibleMaterialsQ[resolvedInstrument, allSamplesInContact, Output -> {Result, Tests}, Cache -> simulatedCache],
		{CompatibleMaterialsQ[resolvedInstrument, allSamplesInContact, Messages -> messagesQ, Cache -> simulatedCache], {}}
	];

	(* if the materials are incompatible, then the Instrument is invalid *)
	compatibleMaterialsInvalidOption = If[Not[compatibleMaterialsBool] && messagesQ,
		If[internalUsageQ, {ChromatographyInstrument}, {Instrument}],
		{}
	];

	(* Resolve the Email option if Automatic *)
	resolvedEmail = If[!MatchQ[Lookup[roundedOptionsAssociation, Email], Automatic],
		(* If Email!=Automatic, use the supplied value *)
		Lookup[roundedOptionsAssociation, Email],
		(* If BOTH Upload -> True and Result is a member of Output, send emails. Otherwise, DO NOT send emails *)
		If[And[Lookup[roundedOptionsAssociation, Upload], MemberQ[output, Result]],
			True,
			False
		]
	];

	(* Finally we resolve our injection table using the helper function*)
	(* We'll need to combine all of the relevant options for the injection table *)
	resolvedOptionsForInjectionTable = Association[
		Column -> ConstantArray[resolvedColumn,Length[mySamples]],
		(* BlankColumn and StandardColumn are no longer options for ExperimentHPLC but we keep them here for the injection table resolver to be compatible with other experiments *)
		BlankColumn -> ConstantArray[resolvedColumn,Length[resolvedBlank]],
		StandardColumn -> ConstantArray[resolvedColumn,Length[resolvedStandard]],
		If[columnSelectorQ,
			ColumnSelector -> resolvedColumnSelector,
			Nothing
		],
		ColumnPosition -> resolvedColumnPosition,
		ColumnTemperature -> resolvedColumnTemperatures,
		InjectionVolume -> resolvedInjectionVolumes,
		Gradient -> resolvedGradients,
		Standard -> resolvedStandard,
		StandardColumnPosition -> resolvedStandardColumnPosition,
		StandardColumnTemperature -> resolvedStandardColumnTemperatures,
		StandardFrequency -> resolvedStandardFrequency,
		StandardInjectionVolume -> resolvedStandardInjectionVolumes,
		StandardGradient -> resolvedStandardGradients,
		Blank -> resolvedBlank,
		BlankColumnPosition -> resolvedBlankColumnPosition,
		BlankColumnTemperature -> resolvedBlankColumnTemperatures,
		BlankFrequency -> resolvedBlankFrequency,
		BlankInjectionVolume -> resolvedBlankInjectionVolumes,
		BlankGradient -> resolvedBlankGradients,
		ColumnRefreshFrequency -> resolvedColumnRefreshFrequency,
		ColumnPrimeGradient -> resolvedColumnPrimeGradients,
		ColumnPrimeTemperature -> resolvedPrimeColumnTemperatures,
		ColumnFlushGradient -> resolvedColumnFlushGradients,
		ColumnFlushTemperature -> resolvedFlushColumnTemperatures,
		InjectionTable -> injectionTableLookup,
		GradientOverwrite -> overwriteGradientsBool,
		BlankGradientOverwrite -> adjustedOverwriteBlankBool,
		StandardGradientOverwrite -> adjustedOverwriteStandardBool,
		ColumnFlushGradientOverwrite -> overwriteColumnPrimeGradientBool,
		ColumnPrimeOverwrite -> overwriteColumnFlushGradientBool
	];

	{resolvedInjectionTableResult, injectionTableTests} = If[gatherTestsQ,
		resolveInjectionTable[mySamples, resolvedOptionsForInjectionTable, ExperimentHPLC, Object[Method, Gradient], Output -> {Result, Tests}],
		{resolveInjectionTable[mySamples, resolvedOptionsForInjectionTable, ExperimentHPLC, Object[Method, Gradient], Output -> Result], {}}
	];

	resolvedInjectionTable = Lookup[First@resolvedInjectionTableResult, InjectionTable];

	injectionTableInvalidOptions = Last[resolvedInjectionTableResult];

	(* We have to overwrite the shown gradient method if there were changes to it (like removed extra or overwritten by other options). In those cases, we show the new gradients *)
	{
		shownGradients,
		shownStandardGradients,
		shownBlankGradients,
		shownColumnPrimeGradientList,
		shownColumnFlushGradientList
	} = MapThread[
		Function[
			{resolvedGradientList, removedExtraList, overwriteBoolList, gradientTupleList},
			If[!MatchQ[resolvedGradientList, Null | {Null} | {{}} | {}],
				MapThread[
					Function[
						{resolved, removedExtraEntryQ, overwriteQ, tupledGradient},
						Which[
							overwriteQ, tupledGradient,
							removedExtraEntryQ, tupledGradient,
							MatchQ[resolved, ObjectP[Object[Method]] | binaryGradientP | gradientP], resolved,
							True, tupledGradient
						]
					],
					{
						resolvedGradientList,
						removedExtraList,
						overwriteBoolList,
						gradientTupleList
					}
				]
			]
		],
		{
			{resolvedGradients, resolvedStandardGradients, resolvedBlankGradients, resolvedColumnPrimeGradients, resolvedColumnFlushGradients},
			{removedExtraBool, removedExtraStandardBool, removedExtraBlankBool, removedExtraColumnPrimeGradientBool, removedExtraColumnFlushGradientBool},
			{overwriteGradientsBool, overwriteStandardGradientsBool, overwriteBlankGradientsBool, overwriteColumnPrimeGradientBool, overwriteColumnFlushGradientBool},
			{resolvedAnalyteGradients, resolvedStandardAnalyticalGradients, resolvedBlankAnalyticalGradients, resolvedColumnPrimeAnalyticalGradients, resolvedColumnFlushAnalyticalGradients}
		}
	];

	(* Special Step - If we have InternalUsage->True, we need to change the Pattern of the Gradient options to remove the Refractive Index Reference Loading *)
	{
		finalResolvedGradients,
		finalResolvedStandardGradients,
		finalResolvedBlankGradients,
		finalResolvedColumnPrimeGradients,
		finalResolvedColumnFlushGradients
	} = Map[
		Function[
			{gradientEntry},
			If[!internalUsageQ,
				(* Keep the pattern of HPLC option *)
				gradientEntry,
				(* Index matching values of the gradient option - remove refractive index loading *)
				Map[
					If[MatchQ[#, {{TimeP, PercentP, PercentP, PercentP, PercentP, FlowRateP, Alternatives[Open, Closed, None, Automatic]}...}],
						#[[All, 1 ;; -2]],
						#
					]&,
					gradientEntry
				]
			]
		],
		{
			shownGradients,
			shownStandardGradients /. {Null -> {}},
			shownBlankGradients /. {Null -> {}},
			shownColumnPrimeGradientList /. {Null -> {}},
			shownColumnFlushGradientList /. {Null -> {}}
		}
	];

	(* Get our reformatted Gradient options *)
	reformattedGradientOptions = <|
		Gradient -> finalResolvedGradients,
		StandardGradient -> If[standardExistsQ, finalResolvedStandardGradients, Null],
		BlankGradient -> If[blankExistsQ, finalResolvedBlankGradients, Null],
		ColumnPrimeGradient -> finalResolvedColumnPrimeGradients /. {{} -> Null},
		ColumnFlushGradient -> finalResolvedColumnFlushGradients /. {{} -> Null}
	|>;

	(* We also want to check whether the gradient will equilibrate for each sample (i.e. the eluent is not left in the line when the sample is injected) *)
	(* We need to get all of the positions though in order to do this*)
	samplePositions = Sequence @@@ Position[resolvedInjectionTable, {Sample, ___}];
	standardITPositions = Sequence @@@ Position[resolvedInjectionTable, {Standard, ___}];
	blankITPositions = Sequence @@@ Position[resolvedInjectionTable, {Blank, ___}];
	columnPrimePositions = Sequence @@@ Position[resolvedInjectionTable, {ColumnPrime, ___}];
	columnFlushPositions = Sequence @@@ Position[resolvedInjectionTable, {ColumnFlush, ___}];

	(* Now get the corresponding analyte gradients for each set *)
	(* For the blanks, standards, column primes/flushes, we may have to repeat out, if they appear multiple times *)
	(* Need to make sure we match the standard/blank/column prime/column flush in injection table with the input as much as we can *)
	{standardGradientsMatchingIT,blankGradientsMatchingIT}=MapThread[
		Function[
			{pos,gradients,samples},
			Which[
				Length[pos]==0,{},
				(* Same length of gradients, use it directly *)
				Length[pos]==Length[gradients],gradients,
				True,
				Module[{injectionTableEntries,sampleGradientRule},
					(* Get the standard/blank entries of the injection table *)
					injectionTableEntries=resolvedInjectionTable[[pos]];
					(* Create a relationship from the sample to the gradient *)
					sampleGradientRule=MapThread[
						(Download[#1,Object]->#2)&,
						{samples,gradients}
					];
					(* Replace the samples inside injection table with corresponding gradients *)
					Download[injectionTableEntries[[All,2]],Object]/.sampleGradientRule
				]
			]
		],
		{
			{standardITPositions,blankITPositions},
			{resolvedStandardGradients,resolvedBlankGradients},
			{resolvedStandard,resolvedBlank}
		}
	];
	(* For column prime/flush, need to match the column position *)
	{columnPrimeGradientsMatchingIT,columnFlushGradientsMatchingIT}=MapThread[
		Function[
			{pos,gradients},
			Which[
				Length[pos]==0,{},
				(* Same length of gradients, use it directly *)
				Length[pos]==Length[gradients],gradients,
				True,
				Module[{injectionTableEntries,sampleGradientRule},
					(* Get the standard/blank entries of the injection table *)
					injectionTableEntries=resolvedInjectionTable[[pos]];
					(* Create a relationship from the column position to the gradient *)
					sampleGradientRule=MapThread[
						(#1[[1]]->#2)&,
						{resolvedColumnSelector,gradients}
					];
					(* Replace the samples inside injection table with corresponding gradients *)
					injectionTableEntries[[All,4]]/.sampleGradientRule
				]
			]
		],
		{
			{columnPrimePositions,columnFlushPositions},
			{resolvedColumnPrimeGradients,resolvedColumnFlushGradients}
		}
	];

	(* There are a bunch of injection table issues that can lead to problems with our tests here. so we account for them*)
	injectionTableScrewedUpQ = !MatchQ[invalidStandardBlankOptions, {}];

	(* Now create a list of rules that correspond the positions to the gradients *)
	injectionTableGradientRules = If[!injectionTableScrewedUpQ,
		Join[
			AssociationThread[samplePositions, resolvedAnalyteGradients],
			AssociationThread[standardITPositions, standardGradientsMatchingIT],
			AssociationThread[blankITPositions, blankGradientsMatchingIT],
			AssociationThread[columnPrimePositions, columnPrimeGradientsMatchingIT],
			AssociationThread[columnFlushPositions, columnFlushGradientsMatchingIT]
		]
	];

	(* Put together a rule from column position to the equilibration time *)
	columnSelectorEquilibrationDurationRules=If[columnSelectorQ,
		AssociationThread[resolvedColumnSelector[[All,1]],columnPrimeColumnEquilibrationDurations],
		{}
	];

	(* Now we go through the sample gradients and check to see the gradient before it was equilibrated *)
	gradientReequilibratedBool = MapIndexed[
		Function[
			{currentSamplePosition, sampleIndex},
			(* If the injection table is screwed up, then we're good *)
			If[injectionTableScrewedUpQ,
				True,
				(* Otherwise, we do some logic to figure out if the gradient was completely re-equilibrated *)
				Module[
					{initialSampleGradientComposition,injectionTuple,injectionColumnPosition,injectionColumnEquilibrationDuration,previousPosition,previousGradient,previousInjectionType,requiredEquilibrationTime,previousGradientTuple, finalGradientDeltaDuration,finalGradientComposition,gradientMatchBool},
					(* We get the initial sample gradient here *)
					initialSampleGradientComposition = resolvedAnalyteGradients[[First@sampleIndex]][[1,2 ;; 5]];

					(* Get the column position of this injection *)
					injectionTuple=resolvedInjectionTable[[currentSamplePosition]];
					injectionColumnPosition=injectionTuple[[4]];
					injectionColumnEquilibrationDuration=injectionTuple[[4]]/.columnSelectorEquilibrationDurationRules;

					(* We get the gradient right before that on the same column *)
					previousPosition = LastOrDefault[
						Position[
							resolvedInjectionTable[[;;(currentSamplePosition-1)]][[All,4]],
							injectionColumnPosition
						],
						{0}
					][[1]];

					If[MatchQ[previousPosition,0],
						True,
						(
							previousGradient = previousPosition /. injectionTableGradientRules;
							previousInjectionType = resolvedInjectionTable[[previousPosition,1]];

							(* Require injectionColumnEquilibrationDuration if the previous injection is ColumnPrime but 5 Minute default for anything else *)
							requiredEquilibrationTime=If[MatchQ[previousInjectionType,ColumnPrime],
								injectionColumnEquilibrationDuration,
								4.9Minute
							];

							previousGradientTuple = If[MatchQ[previousGradient, ObjectP[Object[Method, Gradient]]],
								Lookup[fetchPacketFromCacheHPLC[previousGradient, cache], Gradient],
								previousGradient
							];

							(* We check to see if there's sufficient time (over injectionColumnEquilibrationDuration for column prime or 5 Minute for any other gradient) to reach equilibrium *)
							finalGradientDeltaDuration = If[Length[previousGradientTuple]<2,
								(* If we had only 1 timepoint in previous gradient, we have already thrown an error about GradientSingleton *)
								requiredEquilibrationTime,
								previousGradientTuple[[-1, 1]] - previousGradientTuple[[-2, 1]]
							];
							finalGradientComposition = previousGradientTuple[[-1, 2 ;; 5]];

							(* Use EqualQ to make sure we treat 0 Percent and 0. Percent the same *)
							gradientMatchBool = MapThread[
								EqualQ[#1,#2]&,
								{initialSampleGradientComposition, finalGradientComposition}
							];

							And[
								And@@gradientMatchBool,
								GreaterEqualQ[finalGradientDeltaDuration, requiredEquilibrationTime]
							]
						)
					]
				]
			]
		],
		samplePositions
	];

	(* Check if we have anything that goes out of whack *)
	gradientReequilibratedQ = And @@ gradientReequilibratedBool;

	If[messagesQ && !gradientReequilibratedQ && !engineQ,
		Message[Warning::HPLCGradientNotReequilibrated, PickList[mySamples, gradientReequilibratedBool, False], PickList[Range[1, Length[mySamples]], gradientReequilibratedBool, False]],
		Null
	];

	gradientReequilibratedWarning = If[gatherTestsQ,
		Warning["If the InjectionType is Autosampler, the gradient reequilibrate in the previous gradient before the sample one:",
			gradientReequilibratedQ,
			True
		],
		Nothing
	];

	(* Detector related Options Resolution *)
	(* pHCalibration and ConductivityCalibration related options *)
	(* These options are resolved here in the main resolver, instead of in the instrument option resolver because we don't want to mess up with the calibration buffer resources. These options are not index matching to samples. *)
	(* Note that we only resolve to pH or Conductivity detector when the user asks for it so it is very safe to assume it's not instrument dependent *)

	(* Now check whether we have pH and/or Conductivity as detector *)
	pHDetectorQ = If[MatchQ[Lookup[roundedOptionsAssociation, Detector], Automatic],
		Or[
			MemberQ[impliedDetectors, pH],
			MemberQ[Lookup[instrumentModelPacket,Detectors,{}],pH]
		],
		MemberQ[ToList[Lookup[roundedOptionsAssociation, Detector]], pH]
	];
	conductivityDetectorQ = If[MatchQ[Lookup[roundedOptionsAssociation, Detector], Automatic],
		Or[
			MemberQ[impliedDetectors, Conductance],
			MemberQ[Lookup[instrumentModelPacket,Detectors,{}],Conductance]
		],
		MemberQ[ToList[Lookup[roundedOptionsAssociation, Detector]], Conductance]
	];

	(* Resolve pH Detector related options *)
	pHCalibrationOptions = {
		LowpHCalibrationBuffer,
		LowpHCalibrationTarget,
		HighpHCalibrationBuffer,
		HighpHCalibrationTarget
	};

	(* Check the options to see whether pH Calibration is required or required as Null *)
	pHCalibrationRequestedQ = Or @@ Flatten[MatchQ[#, Except[Automatic | Null]]& /@ Lookup[roundedOptionsAssociation, pHCalibrationOptions]];

	pHCalibrationRequestedNullQ = Or @@ Flatten[MatchQ[#, Null]& /@ Lookup[roundedOptionsAssociation, pHCalibrationOptions]];

	(* Resolve pHCalibration *)
	resolvedpHCalibration = Which[
		(* If pH is requested and user didn't specify the option pHCalibration, set it to True when any related option is populated *)
		MatchQ[Lookup[roundedOptionsAssociation, pHCalibration], Automatic] && pHDetectorQ && pHCalibrationRequestedQ, True,
		(* If pH is requested and user didn't specify the option pHCalibration, set it to False when any related option is set to Null *)
		MatchQ[Lookup[roundedOptionsAssociation, pHCalibration], Automatic] && pHDetectorQ && pHCalibrationRequestedNullQ, False,
		MatchQ[Lookup[roundedOptionsAssociation, pHCalibration], Automatic] && pHDetectorQ, True,
		(* If pH is not requested, set to Null *)
		MatchQ[Lookup[roundedOptionsAssociation, pHCalibration], Automatic], Null,
		True, Lookup[roundedOptionsAssociation, pHCalibration]
	];

	(* Resolve pH Calibration related options *)
	{resolvedLowpHCalibrationBuffer, resolvedLowpHCalibrationTarget, resolvedHighpHCalibrationBuffer, resolvedHighpHCalibrationTarget} = Module[
		{
			suppliedLowpHCalibrationBuffer, suppliedLowpHCalibrationTarget, suppliedHighpHCalibrationBuffer, suppliedHighpHCalibrationTarget,
			suppliedLowpHCalibrationBufferModelPacket, suppliedLowpHCalibrationBufferpH, suppliedHighpHCalibrationBufferModelPacket, suppliedHighpHCalibrationBufferpH,
			suppliedLowpHCalibrationTargetBuffer, suppliedHighpHCalibrationTargetBuffer,
			lowPHCalibrationBuffer, lowpHCalibrationTarget, highpHCalibrationBuffer, highpHCalibrationTarget
		},

		suppliedLowpHCalibrationBuffer = Lookup[roundedOptionsAssociation, LowpHCalibrationBuffer];
		suppliedLowpHCalibrationTarget = If[MatchQ[Lookup[roundedOptionsAssociation, LowpHCalibrationTarget], Automatic | Null],
			Lookup[roundedOptionsAssociation, LowpHCalibrationTarget],
			First@Nearest[{4, 7, 10}, Lookup[roundedOptionsAssociation, LowpHCalibrationTarget]]
		];
		suppliedHighpHCalibrationBuffer = Lookup[roundedOptionsAssociation, HighpHCalibrationBuffer];
		suppliedHighpHCalibrationTarget = If[MatchQ[Lookup[roundedOptionsAssociation, HighpHCalibrationTarget], Automatic | Null],
			Lookup[roundedOptionsAssociation, HighpHCalibrationTarget],
			First@Nearest[{4, 7, 10}, Lookup[roundedOptionsAssociation, HighpHCalibrationTarget]]
		];

		(* Get the pH value of the buffers *)
		suppliedLowpHCalibrationBufferModelPacket = Which[
			MatchQ[suppliedLowpHCalibrationBuffer, ObjectP[Model]], fetchPacketFromCacheHPLC[suppliedLowpHCalibrationBuffer, cache],
			MatchQ[suppliedLowpHCalibrationBuffer, ObjectP[]], fetchModelPacketFromCacheHPLC[suppliedLowpHCalibrationBuffer, cache],
			True, Null
		];
		suppliedLowpHCalibrationBufferpH = If[NullQ[suppliedLowpHCalibrationBufferModelPacket],
			Null,
			Lookup[suppliedLowpHCalibrationBufferModelPacket, pH, Null]
		];

		suppliedHighpHCalibrationBufferModelPacket = Which[
			MatchQ[suppliedHighpHCalibrationBuffer, ObjectP[Model]], fetchPacketFromCacheHPLC[suppliedHighpHCalibrationBuffer, cache],
			MatchQ[suppliedHighpHCalibrationBuffer, ObjectP[]], fetchModelPacketFromCacheHPLC[suppliedHighpHCalibrationBuffer, cache],
			True, Null
		];
		suppliedHighpHCalibrationBufferpH = If[NullQ[suppliedHighpHCalibrationBufferModelPacket],
			Null,
			Lookup[suppliedHighpHCalibrationBufferModelPacket, pH, Null]
		];

		(* Get the corresponding buffer of the target pH *)
		suppliedLowpHCalibrationTargetBuffer = Which[
			EqualQ[suppliedLowpHCalibrationTarget, 4], Model[Sample, "pH 4.01 Calibration Buffer, Sachets"],
			EqualQ[suppliedLowpHCalibrationTarget, 7], Model[Sample, "pH 7.00 Calibration Buffer, Sachets"],
			EqualQ[suppliedLowpHCalibrationTarget, 10], Model[Sample, "pH 10.01 Calibration Buffer, Sachets"],
			True, Null
		];

		suppliedHighpHCalibrationTargetBuffer = Which[
			EqualQ[suppliedHighpHCalibrationTarget, 4], Model[Sample, "pH 4.01 Calibration Buffer, Sachets"],
			EqualQ[suppliedHighpHCalibrationTarget, 7], Model[Sample, "pH 7.00 Calibration Buffer, Sachets"],
			EqualQ[suppliedHighpHCalibrationTarget, 10], Model[Sample, "pH 10.01 Calibration Buffer, Sachets"],
			True, Null
		];

		(* Depending on which are provided, resolve differently *)
		lowPHCalibrationBuffer = Which[
			(* Use the user-specified value *)
			!MatchQ[suppliedLowpHCalibrationBuffer, Automatic], suppliedLowpHCalibrationBuffer,
			(* Get a buffer from the target pH*)
			!NullQ[suppliedLowpHCalibrationTargetBuffer] && TrueQ[resolvedpHCalibration], suppliedLowpHCalibrationTargetBuffer,
			(* Use a buffer lower than the specified HighpH buffer *)
			(MatchQ[suppliedHighpHCalibrationTarget, LessP[10]] || MatchQ[suppliedLowpHCalibrationBufferpH, LessP[10]]) && TrueQ[resolvedpHCalibration], Model[Sample, "pH 7.00 Calibration Buffer, Sachets"],
			TrueQ[resolvedpHCalibration], Model[Sample, "pH 4.01 Calibration Buffer, Sachets"],
			True, Null
		];

		lowpHCalibrationTarget = Which[
			(* Use the user-specified value *)
			!MatchQ[suppliedLowpHCalibrationTarget, Automatic], suppliedLowpHCalibrationTarget,
			(* Get the pH of the buffer*)
			!MatchQ[suppliedLowpHCalibrationBuffer, Automatic] && TrueQ[resolvedpHCalibration], suppliedLowpHCalibrationBufferpH,
			(* Get the pH of the resolved lowPHCalibrationBuffer when it is resolved *)
			MatchQ[lowPHCalibrationBuffer, ObjectP[Model[Sample, "pH 4.01 Calibration Buffer, Sachets"]]] && TrueQ[resolvedpHCalibration], 4,
			MatchQ[lowPHCalibrationBuffer, ObjectP[Model[Sample, "pH 7.00 Calibration Buffer, Sachets"]]] && TrueQ[resolvedpHCalibration], 7,
			True, Null
		];

		highpHCalibrationBuffer = Which[
			(* Use the user-specified value *)
			!MatchQ[suppliedHighpHCalibrationBuffer, Automatic], suppliedHighpHCalibrationBuffer,
			(* Get a buffer from the target pH*)
			!NullQ[suppliedHighpHCalibrationTargetBuffer] && TrueQ[resolvedpHCalibration], suppliedHighpHCalibrationTargetBuffer,
			(* Use a buffer Higher than the specified HighpH buffer *)
			(MatchQ[suppliedLowpHCalibrationTarget, GreaterP[4]] || MatchQ[suppliedLowpHCalibrationBufferpH, GreaterP[4]]) && TrueQ[resolvedpHCalibration], Model[Sample, "pH 10.01 Calibration Buffer, Sachets"],
			TrueQ[resolvedpHCalibration], Model[Sample, "pH 7.00 Calibration Buffer, Sachets"],
			True, Null
		];

		highpHCalibrationTarget = Which[
			(* Use the user-specified value *)
			!MatchQ[suppliedHighpHCalibrationTarget, Automatic], suppliedHighpHCalibrationTarget,
			(* Get the pH of the buffer*)
			!MatchQ[suppliedHighpHCalibrationBuffer, Automatic] && TrueQ[resolvedpHCalibration], suppliedHighpHCalibrationBufferpH,
			(* Get the pH of the resolved HighPHCalibrationBuffer when it is resolved *)
			MatchQ[highpHCalibrationBuffer, ObjectP[Model[Sample, "pH 7.00 Calibration Buffer, Sachets"]]] && TrueQ[resolvedpHCalibration], 7,
			MatchQ[highpHCalibrationBuffer, ObjectP[Model[Sample, "pH 10.01 Calibration Buffer, Sachets"]]] && TrueQ[resolvedpHCalibration], 10,
			True, Null
		];

		{lowPHCalibrationBuffer, lowpHCalibrationTarget, highpHCalibrationBuffer, highpHCalibrationTarget}

	];

	(* Resolve Conductance Detector related options *)
	conductivityCalibrationOptions = {
		ConductivityCalibrationBuffer,
		ConductivityCalibrationTarget
	};

	(* Check the options to see whether Conductivity Calibration is required or required as Null *)
	conductivityCalibrationRequestedQ = Or @@ Flatten[MatchQ[#, Except[Automatic | Null]]& /@ Lookup[roundedOptionsAssociation, conductivityCalibrationOptions]];

	conductivityCalibrationRequestedNullQ = Or @@ Flatten[MatchQ[#, Null]& /@ Lookup[roundedOptionsAssociation, conductivityCalibrationOptions]];

	(* Resolve ConductivityCalibration *)
	resolvedConductivityCalibration = Which[
		(* If Conductance is requested and user didn't specify the option pHCalibration, set it to True when any related option is populated *)
		MatchQ[Lookup[roundedOptionsAssociation, ConductivityCalibration], Automatic] && conductivityDetectorQ && conductivityCalibrationRequestedQ, True,
		(* If Conductance is requested and user didn't specify the option ConductivityCalibration, set it to False when any related option is set to Null *)
		MatchQ[Lookup[roundedOptionsAssociation, ConductivityCalibration], Automatic] && conductivityDetectorQ && conductivityCalibrationRequestedQ, False,
		MatchQ[Lookup[roundedOptionsAssociation, ConductivityCalibration], Automatic] && conductivityDetectorQ, True,
		(* If pH is not requested, set to Null *)
		MatchQ[Lookup[roundedOptionsAssociation, ConductivityCalibration], Automatic], Null,
		True, Lookup[roundedOptionsAssociation, ConductivityCalibration]
	];

	(* Resolve Conductivity Calibration related options *)
	{resolvedConductivityCalibrationBuffer, resolvedConductivityCalibrationTarget} = Module[
		{
			suppliedConductivityCalibrationBuffer, suppliedConductivityCalibrationTarget,
			suppliedConductivityCalibrationBufferModelPacket, suppliedConductivityCalibrationBufferConductivity, suppliedConductivityCalibrationTargetBuffer,
			conductivityCalibrationBuffer, conductivityCalibrationTarget
		},

		suppliedConductivityCalibrationBuffer = Lookup[roundedOptionsAssociation, ConductivityCalibrationBuffer];
		suppliedConductivityCalibrationTarget = Lookup[roundedOptionsAssociation, ConductivityCalibrationTarget];

		(* Get the Conductivity value of the buffers *)
		suppliedConductivityCalibrationBufferModelPacket = Which[
			MatchQ[suppliedConductivityCalibrationBuffer, ObjectP[Model]], fetchPacketFromCacheHPLC[suppliedConductivityCalibrationBuffer, cache],
			MatchQ[suppliedConductivityCalibrationBuffer, ObjectP[]], fetchModelPacketFromCacheHPLC[suppliedConductivityCalibrationBuffer, cache],
			True, Null
		];
		suppliedConductivityCalibrationBufferConductivity = If[NullQ[suppliedConductivityCalibrationBufferModelPacket],
			Null,
			Lookup[suppliedConductivityCalibrationBufferModelPacket, Conductivity, Null]
		];

		(* Get the corresponding buffer of the target Conductivity *)
		suppliedConductivityCalibrationTargetBuffer = Which[
			EqualQ[suppliedConductivityCalibrationTarget, 1413Micro * Siemens / Centimeter], Model[Sample, "id:eGakldJ6WqD4"],
			EqualQ[suppliedConductivityCalibrationTarget, 84Micro * Siemens / Centimeter], Model[Sample, "id:AEqRl9qdZzlp"],
			EqualQ[suppliedConductivityCalibrationTarget, 10Micro * Siemens / Centimeter], Model[Sample, "id:4pO6dM5qa66o"],
			EqualQ[suppliedConductivityCalibrationTarget, 12.88Milli * Siemens / Centimeter], Model[Sample, "id:3em6ZvLnwqb7"],
			EqualQ[suppliedConductivityCalibrationTarget, 500Micro * Siemens / Centimeter], Model[Sample, "id:XnlV5jKMrjln"],
			EqualQ[suppliedConductivityCalibrationTarget, 150Milli * Siemens / Centimeter], Model[Sample, "id:n0k9mG8mANa3"],
			EqualQ[suppliedConductivityCalibrationTarget, 100Milli * Siemens / Centimeter], Model[Sample, "id:01G6nvwn7BrK"],
			True, Null
		];

		(* Depending on which are provided, resolve differently *)
		conductivityCalibrationBuffer = Which[
			(* Use the user-specified value *)
			!MatchQ[suppliedConductivityCalibrationBuffer, Automatic], suppliedConductivityCalibrationBuffer,
			(* Get a buffer from the target conductivity*)
			!MatchQ[suppliedConductivityCalibrationTarget, Automatic | Null] && TrueQ[resolvedConductivityCalibration], suppliedConductivityCalibrationTargetBuffer,
			(* set to 1413 Micro*Siemens/Centimeter reference buffer *)
			TrueQ[resolvedConductivityCalibration], Model[Sample, "id:eGakldJ6WqD4"],
			True, Null
		];

		conductivityCalibrationTarget = Which[
			(* Use the user-specified value *)
			!MatchQ[suppliedConductivityCalibrationTarget, Automatic], suppliedConductivityCalibrationTarget,
			(* Get the conductivity of the buffer*)
			!MatchQ[suppliedConductivityCalibrationBuffer, Automatic] && TrueQ[resolvedConductivityCalibration], suppliedConductivityCalibrationBufferConductivity,
			(* Get the conductivity of the resolved conductivityCalibrationBuffer when it is resolved *)
			TrueQ[resolvedConductivityCalibration], 1413Micro * Siemens / Centimeter,
			True, Null
		];

		{conductivityCalibrationBuffer, conductivityCalibrationTarget}

	];

	(* Error check for pH Calibration and Conductivity Calibration stuff *)
	(* pH Detector *)
	(* Track the invalid options - When pHCalibration is True, all options must be specified *)
	missingpHCalibrationOptions = If[TrueQ[resolvedpHCalibration] && pHDetectorQ,
		MapThread[
			If[NullQ[#1],
				#2,
				Nothing
			]&,
			{{resolvedLowpHCalibrationBuffer, resolvedLowpHCalibrationTarget, resolvedHighpHCalibrationBuffer, resolvedHighpHCalibrationTarget}, {LowpHCalibrationBuffer, LowpHCalibrationTarget, HighpHCalibrationBuffer, HighpHCalibrationTarget}}
		],
		{}
	];

	(* Throw error message if there is invalid option *)
	If[!MatchQ[missingpHCalibrationOptions, {}] && messagesQ,
		Message[Error::MissingHPLCpHCalibrationOptions, ToString[missingpHCalibrationOptions]]
	];

	(* Generate tests if needed *)
	missingpHCalibrationTests = testOrNull["If pHCalibration is set to True, the pH calibration related options {LowpHCalibrationBuffer,LowpHCalibrationTarget,HighpHCalibrationBuffer,HighpHCalibrationTarget} should not be Null.", MatchQ[missingpHCalibrationOptions, {}]];

	(* Track the invalid option - When pHCalibration is not True, none of the options can be specified *)
	invalidpHCalibrationOptions = If[!TrueQ[resolvedpHCalibration] && pHDetectorQ,
		MapThread[
			If[!NullQ[#1],
				#2,
				Nothing
			]&,
			{{resolvedLowpHCalibrationBuffer, resolvedLowpHCalibrationTarget, resolvedHighpHCalibrationBuffer, resolvedHighpHCalibrationTarget}, {LowpHCalibrationBuffer, LowpHCalibrationTarget, HighpHCalibrationBuffer, HighpHCalibrationTarget}}
		],
		{}
	];

	(* Throw error message if there is invalid option *)
	If[!MatchQ[invalidpHCalibrationOptions, {}] && messagesQ,
		Message[Error::InvalidHPLCpHCalibrationOptions, ToString[invalidpHCalibrationOptions]]
	];

	(* Generate tests if needed *)
	invalidpHCalibrationTests = testOrNull["If pHCalibration is not set to True, the pH calibration related options {LowpHCalibrationBuffer,LowpHCalibrationTarget,HighpHCalibrationBuffer,HighpHCalibrationTarget} should be Null.", MatchQ[invalidpHCalibrationOptions, {}]];

	(* Low pH target should be smaller than high pH target *)
	swappedpHCalibrationTargetQ = If[!NullQ[resolvedLowpHCalibrationTarget] && !NullQ[resolvedHighpHCalibrationTarget] && TrueQ[resolvedLowpHCalibrationTarget > resolvedHighpHCalibrationTarget] && messagesQ && !engineQ,
		Message[Warning::HPLCpHCalibrationBufferSwapped];True,
		False
	];

	swappedpHCalibrationTargetTests = warningOrNull["The LowpHCalibrationTarget is smaller than HighpHCalibrationTarget.", !swappedpHCalibrationTargetQ];

	(* Conductance Detector *)
	(* Track the invalid options - When ConductivityCalibration is True, all options must be specified *)
	missingConductivityCalibrationOptions = If[TrueQ[resolvedConductivityCalibration] && conductivityDetectorQ,
		MapThread[
			If[NullQ[#1],
				#2,
				Nothing
			]&,
			{{resolvedConductivityCalibrationBuffer, resolvedConductivityCalibrationTarget}, {ConductivityCalibrationBuffer, ConductivityCalibrationTarget}}
		],
		{}
	];

	(* Throw error message if there is invalid option *)
	If[!MatchQ[missingConductivityCalibrationOptions, {}] && messagesQ,
		Message[Error::MissingHPLCConductivityCalibrationOptions, ToString[missingConductivityCalibrationOptions]]
	];

	(* Generate tests if needed *)
	missingConductivityCalibrationTests = testOrNull["If ConductivityCalibration is set to True, the conductivity calibration related options {ConductivityCalibrationBuffer,ConductivityCalibrationTarget} should not be Null.", MatchQ[missingConductivityCalibrationOptions, {}]];

	(* Track the invalid option - When ConductivityCalibration is not True, none of the options can be specified *)
	invalidConductivityCalibrationOptions = If[!TrueQ[resolvedConductivityCalibration] && conductivityDetectorQ,
		MapThread[
			If[!NullQ[#1],
				#2,
				Nothing
			]&,
			{{resolvedConductivityCalibrationBuffer, resolvedConductivityCalibrationTarget}, {ConductivityCalibrationBuffer, ConductivityCalibrationTarget}}
		],
		{}
	];

	(* Throw error message if there is invalid option *)
	If[!MatchQ[invalidConductivityCalibrationOptions, {}] && messagesQ,
		Message[Error::InvalidHPLCConductivityCalibrationOptions, ToString[invalidConductivityCalibrationOptions]]
	];

	(* Generate tests if needed *)
	invalidConductivityCalibrationTests = testOrNull["If ConductivityCalibration is not set to True, the conductivity calibration related options {ConductivityCalibrationBuffer,ConductivityCalibrationTarget} should be Null.", MatchQ[invalidConductivityCalibrationOptions, {}]];

	(* Resolve InjectionSampleVolumeMeasurement option*)
	(* Changed from VolumeCheckSamplePrep *)
	resolvedInjectionSampleVolumeMeasurement = Switch[
		{Lookup[optionsAssociation, InjectionSampleVolumeMeasurement], Lookup[optionsAssociation, PreparatoryUnitOperations], Lookup[optionsAssociation, PreparatoryPrimitives]},

		(* If there are no PreparatoryUnitOperations specified and InjectionSampleVolumeMeasurement specified True, throw a warning and switch it to False*)
		{True, NullP, NullP}, (If[messagesQ && !engineQ, Message[Warning::ConflictingInjectionSampleVolumeMeasurementOption]]; False),
		(* Otherwise use the specified value *)
		_, Lookup[optionsAssociation, InjectionSampleVolumeMeasurement]
	];

	(* Check whether the SamplesInStorage/BlankStorageCondition/StandardStorageCondition options are ok *)
	samplesInStorage = Lookup[roundedOptionsAssociation, SamplesInStorageCondition];
	blankStorage = Lookup[expandedBlankOptions, BlankStorageCondition];
	standardStorage = Lookup[expandedStandardOptions, StandardStorageCondition];

	(* Call ValidContainerStorageConditionQ to do that *)
	{validContainerStorageConditionBool, validContainerStorageConditionTests} = If[Not[messagesQ],
		ValidContainerStorageConditionQ[mySamples, samplesInStorage, Output -> {Result, Tests}, Cache -> simulatedCache],
		{ValidContainerStorageConditionQ[mySamples, samplesInStorage, Output -> Result, Cache -> simulatedCache], {}}
	];
	validContainerStorageConditionInvalidOptions = If[MemberQ[validContainerStorageConditionBool, False], SamplesInStorageCondition, Nothing];

	(* Get the blanks with models removed *)
	blanksNoModels = If[blankExistsQ,
		Cases[resolvedBlank, ObjectP[Object[Sample]]],
		{}
	];
	blankStorageNoModels = If[blankExistsQ,
		PickList[blankStorage, resolvedBlank, ObjectP[Object[Sample]]],
		{}
	];

	(* Check whether the blanks are ok *)
	{validBlankStorageConditionBool, validBlankStorageConditionTests} = Which[
		MatchQ[blanksNoModels, {}], {{}, {}},
		Not[messagesQ], ValidContainerStorageConditionQ[blanksNoModels, blankStorageNoModels, Output -> {Result, Tests}, Cache -> cache],
		True, {ValidContainerStorageConditionQ[blanksNoModels, blankStorageNoModels, Output -> Result, Cache -> cache], {}}
	];
	validBlankStorageConditionInvalidOptions = If[MemberQ[validBlankStorageConditionBool, False], BlankStorageCondition, Nothing];

	(* Get the standards with models removed *)
	standardsNoModels = If[standardExistsQ,
		Cases[resolvedStandard, ObjectP[Object[Sample]]],
		{}
	];
	standardStorageNoModels = If[standardExistsQ,
		PickList[standardStorage, resolvedStandard, ObjectP[Object[Sample]]],
		{}
	];

	(* Check whether the blanks are ok *)
	{validStandardStorageConditionBool, validStandardStorageConditionTests} = Which[
		MatchQ[standardsNoModels, {}], {{}, {}},
		Not[messagesQ], ValidContainerStorageConditionQ[standardsNoModels, standardStorageNoModels, Output -> {Result, Tests}, Cache -> cache],
		True, {ValidContainerStorageConditionQ[standardsNoModels, standardStorageNoModels, Output -> Result, Cache -> cache], {}}
	];
	validStandardStorageConditionInvalidOptions = If[MemberQ[validStandardStorageConditionBool, False], StandardStorageCondition, Nothing];

	(* If we're collecting fractions, and SamplesIn have different storage conditions, SamplesOutStorageCondition must be specified so we know how to store the fractions *)
	validSamplesOutStorageConditionQ = True;
	samplesOutStorageConditionTest = Module[
		{fractionCollectionSamplePackets, fractionCollectionSampleStorageConditions},

		(* Extract samples for which we'll be collecting fractions *)
		fractionCollectionSamplePackets = PickList[samplePackets, collectFractions, True];

		(* Extract storage conditions for samples *)
		fractionCollectionSampleStorageConditions = DeleteDuplicates@DeleteCases[
			Download[
				Map[
					If[NullQ[Lookup[#, StorageCondition]],
						Null,
						Lookup[#, StorageCondition]
					]&,
					fractionCollectionSamplePackets
				],
				Object
			],
			Null
		];

		(* If the samples for which we are collecting fractions have more than one distinct storage condition, SamplesOutStorageCondition must be specified so we know where to store them. *)
		If[
			And[
				Length[fractionCollectionSampleStorageConditions] > 1,
				NullQ[Lookup[roundedOptionsAssociation, SamplesOutStorageCondition]]
			],
			(
				If[messagesQ,
					Message[Error::SamplesOutStorageConditionRequired]
				];
				validSamplesOutStorageConditionQ = False;
				testOrNull["If samples for which CollectFractions is True have distinct storage conditions, SamplesOutStorageCondition is specified:", False]
			),
			testOrNull["If samples for which CollectFractions is True have distinct storage conditions, SamplesOutStorageCondition is specified:", True]
		]
	];

	(* Define what we've resolved so far *)
	preWavefunctionResolution = Association[
		SeparationMode -> resolvedSeparationMode,
		Scale -> resolvedScale,
		Column -> resolvedColumn,
		SecondaryColumn -> resolvedSecondaryColumn,
		TertiaryColumn -> resolvedTertiaryColumn,
		ColumnSelection -> resolvedColumnSelection,
		ColumnPosition -> resolvedColumnPosition,
		ColumnTemperature -> resolvedColumnTemperatures,
		ColumnSelector -> resolvedColumnSelector,
		ColumnOrientation -> resolvedColumnOrientation,
		GuardColumn -> resolvedGuardColumn,
		GuardColumnOrientation -> resolvedGuardColumnOrientation,
		IncubateColumn -> resolvedIncubateColumn,
		ColumnStorageBuffer -> resolvedColumnStorageBuffer,

		BufferA -> resolvedBufferA,
		BufferB -> resolvedBufferB,
		BufferC -> resolvedBufferC,
		BufferD -> resolvedBufferD,
		Instrument -> combinedResolvedInstruments,
		FlowRate -> resolvedFlowRates,
		Gradient -> shownGradients,
		GradientA -> resolvedGradientAs,
		GradientB -> resolvedGradientBs,
		GradientC -> resolvedGradientCs,
		GradientD -> resolvedGradientDs,
		NeedleWashSolution -> resolvedNeedleWashSolution,

		CollectFractions -> collectFractions,
		FractionCollectionMethod -> Lookup[roundedOptionsAssociation, FractionCollectionMethod],
		FractionCollectionMode -> fractionCollectionModes,
		FractionCollectionStartTime -> fractionCollectionStartTimes,
		FractionCollectionEndTime -> fractionCollectionEndTimes,
		MaxFractionVolume -> maxFractionVolumes,
		FractionCollectionContainer -> resolvedFractionCollectionContainer,
		MaxCollectionPeriod -> maxFractionPeriods,

		InjectionVolume -> resolvedInjectionVolumes,
		InjectionTable -> resolvedInjectionTable,

		Standard -> If[standardExistsQ, resolvedStandard, Null],
		StandardColumnPosition -> If[standardExistsQ, resolvedStandardColumnPosition, Null],
		StandardColumnTemperature -> If[standardExistsQ, resolvedStandardColumnTemperatures, Null],
		StandardInjectionVolume -> If[standardExistsQ, resolvedStandardInjectionVolumes, Null],
		StandardGradientA -> If[standardExistsQ, resolvedStandardGradientAs, Null],
		StandardGradientB -> If[standardExistsQ, resolvedStandardGradientBs, Null],
		StandardGradientC -> If[standardExistsQ, resolvedStandardGradientCs, Null],
		StandardGradientD -> If[standardExistsQ, resolvedStandardGradientDs, Null],
		StandardGradient -> If[standardExistsQ, shownStandardGradients, Null],
		StandardFlowRate -> If[standardExistsQ, resolvedStandardFlowRates, Null],
		StandardFrequency -> If[standardExistsQ, resolvedStandardFrequency, Null],

		Blank -> If[blankExistsQ, resolvedBlank, Null],
		BlankColumnPosition -> If[blankExistsQ, resolvedBlankColumnPosition, Null],
		BlankColumnTemperature -> If[blankExistsQ, resolvedBlankColumnTemperatures, Null],
		BlankInjectionVolume -> If[blankExistsQ, resolvedBlankInjectionVolumes, Null],
		BlankGradientA -> If[blankExistsQ, resolvedBlankGradientAs, Null],
		BlankGradientB -> If[blankExistsQ, resolvedBlankGradientBs, Null],
		BlankGradientC -> If[blankExistsQ, resolvedBlankGradientCs, Null],
		BlankGradientD -> If[blankExistsQ, resolvedBlankGradientDs, Null],
		BlankGradient -> If[blankExistsQ, shownBlankGradients, Null],
		BlankFlowRate -> If[blankExistsQ, resolvedBlankFlowRates, Null],
		BlankFrequency -> If[blankExistsQ, resolvedBlankFrequency, Null],

		ColumnRefreshFrequency -> resolvedColumnRefreshFrequency,
		ColumnPrimeTemperature -> resolvedPrimeColumnTemperatures,
		ColumnPrimeGradientA -> resolvedColumnPrimeGradientAs,
		ColumnPrimeGradientB -> resolvedColumnPrimeGradientBs,
		ColumnPrimeGradientC -> resolvedColumnPrimeGradientCs,
		ColumnPrimeGradientD -> resolvedColumnPrimeGradientDs,
		ColumnPrimeGradient -> shownColumnPrimeGradientList,
		ColumnPrimeFlowRate -> resolvedColumnPrimeFlowRates,
		ColumnFlushTemperature -> resolvedFlushColumnTemperatures,
		ColumnFlushGradientA -> resolvedColumnFlushGradientAs,
		ColumnFlushGradientB -> resolvedColumnFlushGradientBs,
		ColumnFlushGradientC -> resolvedColumnFlushGradientCs,
		ColumnFlushGradientD -> resolvedColumnFlushGradientDs,
		ColumnFlushGradient -> shownColumnFlushGradientList,
		ColumnFlushFlowRate -> resolvedColumnFlushFlowRates,

		(* Part of the pH/Conductivity Detector related options *)
		pHCalibration -> resolvedpHCalibration,
		LowpHCalibrationBuffer -> resolvedLowpHCalibrationBuffer,
		LowpHCalibrationTarget -> resolvedLowpHCalibrationTarget,
		HighpHCalibrationBuffer -> resolvedHighpHCalibrationBuffer,
		HighpHCalibrationTarget -> resolvedHighpHCalibrationTarget,
		ConductivityCalibration -> resolvedConductivityCalibration,
		ConductivityCalibrationBuffer -> resolvedConductivityCalibrationBuffer,
		ConductivityCalibrationTarget -> resolvedConductivityCalibrationTarget,

		Name -> Lookup[roundedOptionsAssociation, Name],
		Email -> resolvedEmail,
		ImageSample -> If[MatchQ[Lookup[roundedOptionsAssociation, ImageSample], Automatic], True, Lookup[roundedOptionsAssociation, ImageSample]],
		SamplesInStorageCondition -> samplesInStorage,
		SamplesOutStorageCondition -> Lookup[roundedOptionsAssociation, SamplesOutStorageCondition],
		StandardStorageCondition -> standardStorage /. {{} -> Null},
		BlankStorageCondition -> blankStorage /. {{} -> Null},
		InjectionSampleVolumeMeasurement -> resolvedInjectionSampleVolumeMeasurement (*Changed from VolumeCheckSamplePrep Volume*)
	];

	(* Resolve the instrument specific options *)

	{{instrumentSpecificOptionSet, instrumentSpecificOptionInvalidOptions}, instrumentSpecificTests} = If[gatherTestsQ,
		resolveHPLCInstrumentOptions[mySamples, resolvedInstrument, Join[roundedOptionsAssociation, preWavefunctionResolution], cache, Output -> {Result, Tests}],
		{resolveHPLCInstrumentOptions[mySamples, resolvedInstrument, Join[roundedOptionsAssociation, preWavefunctionResolution], cache, Output -> Result], Null}
	];

	(* We will now finish the resolution of the aliquot container.
	Dionex: If sample plate count >2, aliquot.
	Waters: If sample plate count >1, aliquot.
	Agilent: Samples not in 50 mL tube or 15 mL tube, aliquot.
	We're already throwing an error if the container count is invalid so we know we can just blindly flip all Aliquot -> Automatic to True if Aliquot is needed to make the samples fit.
	If the container count is invalid, don't modify any values *)

	(* Get the instrument autosampler deck *)
	autosamplerDeckModel = Lookup[instrumentModelPacket, AutosamplerDeckModel];

	(*get all of the associated racks with the instrument*)
	availableAutosamplerRacks = Which[
		MatchQ[instrumentModel, dionexHPLCPattern],
		{Model[Container, Rack, "HPLC Vial Rack"]},
		MatchQ[instrumentModel, agilentHPLCPattern],
		(* Agilent's last type of rack is 25 mm tube rack but it is only compatible with test tubes and we are not going to support it in our experiment *)
		{$LargeAgilentHPLCAutosamplerRack, $SmallAgilentHPLCAutosamplerRack},
		True, {Model[Container, Rack, "Waters Acquity UPLC Autosampler Rack"]}
	];

	(* The containers that wil fit on the instrument's autosampler *)
	{compatibleContainers, namedCompatibleContainers} = Which[
		MatchQ[instrumentModel, dionexHPLCPattern],
		{{Model[Container, Vessel, "id:jLq9jXvxr6OZ"], Model[Container, Vessel, "id:1ZA60vL48X85"], Model[Container, Vessel, "id:GmzlKjznOxmE"], Model[Container, Vessel, "id:3em6ZvL8x4p8"]}, {Model[Container, Vessel, "HPLC vial (high recovery)"], Model[Container, Vessel, "1mL HPLC Vial (total recovery)"], Model[Container, Vessel, "Amber HPLC vial (high recovery)"], Model[Container, Vessel, "HPLC vial (high recovery), LCMS Certified"]}},
		MatchQ[instrumentModel, agilentHPLCPattern],
		{{Model[Container, Vessel, "id:bq9LA0dBGGR6"], Model[Container, Vessel, "id:xRO9n3vk11pw"], Model[Container, Vessel, "id:bq9LA0dBGGrd"], Model[Container, Vessel, "id:rea9jl1orrMp"]}, {Model[Container, Vessel, "50mL Tube"], Model[Container, Vessel, "15mL Tube"], Model[Container, Vessel, "50mL Light Sensitive Centrifuge Tube"], Model[Container, Vessel, "15mL Light Sensitive Centrifuge Tube"]}},
		True,
		{{Model[Container, Vessel, "id:jLq9jXvxr6OZ"], Model[Container, Vessel, "id:1ZA60vL48X85"], Model[Container, Vessel, "id:GmzlKjznOxmE"], Model[Container, Vessel, "id:3em6ZvL8x4p8"]}, {Model[Container, Vessel, "HPLC vial (high recovery)"], Model[Container, Vessel, "1mL HPLC Vial (total recovery)"], Model[Container, Vessel, "Amber HPLC vial (high recovery)"], Model[Container, Vessel, "HPLC vial (high recovery), LCMS Certified"]}}
	];

	(* If the sample's container model is not compatible with the instrument, it will not be possible to run the samples. *)
	invalidContainerModelBools = Map[
		(* Check if we have plate, if so, check if it can fit on the autosampler *)
		Function[
			{currentContainer},
			If[(MatchQ[currentContainer, ObjectP[Model[Container, Plate]]]) && !MatchQ[instrumentModel, agilentHPLCPattern],
				!CompatibleFootprintQ[autosamplerDeckModel, currentContainer, ExactMatch -> False, Cache -> cache],
				(* Otherwise, see if it fits into any of the Racks *)
				!MatchQ[currentContainer, Alternatives @@ compatibleContainers | Alternatives @@ namedCompatibleContainers]
			]
		],
		simulatedSampleContainerModels
	];

	(* Enforce that _if_ AliquotContainer is specified, they are compatible *)
	validAliquotContainerBools = MapThread[
		Function[{aliquotQ, aliquotContainer},
			Or[
				(* If Aliquot is explicitly False, we don't need this check *)
				MatchQ[Lookup[aliquotOptions, Aliquot], False],
				(* Use the same logic as deciding invalidContainerModelBools  *)
				Switch[{aliquotContainer,instrumentModel},
					{Except[ObjectP[]],_}, True,
					(* Agilent is not compatible with plates *)
					{ObjectP[Model[Container, Plate]],Except[agilentHPLCPattern]}, CompatibleFootprintQ[autosamplerDeckModel, aliquotContainer, ExactMatch -> False, Cache -> cache],
					_, MatchQ[aliquotContainer, Alternatives @@ compatibleContainers | Alternatives @@ namedCompatibleContainers]
				]
			]
		],
		{specifiedAliquotBools, Lookup[aliquotOptions, AliquotContainer]}
	];

	(* Build test for aliquot container specification validity *)
	validAliquotContainerTest = If[!(And @@ validAliquotContainerBools),
		(
			If[messagesQ,
				Message[Error::HPLCIncompatibleAliquotContainer, ObjectToString /@ namedCompatibleContainers]
			];
			compatibleAliquotContainerQ = False;
			testOrNull["If AliquotContainer is specified, it is compatible with an HPLC autosampler:", False]
		),
		testOrNull["If AliquotContainer is specified, it is compatible with an HPLC autosampler:", True]
	];

	(* If we end up aliquoting and AliquotAmount is not specified, it is possible we need to force AliquotVolume to be the appropriate InjectionVolume. *)
	(* Also decide the distribution of dead volume based on consolidation *)
	requiredAliquotVolumes = MapThread[
		Function[
			{samplePacket, injectionVolume},
			Which[
				MatchQ[injectionVolume, VolumeP],
				(* Distribute autosampler dead volume across all instances of an identical aliquots *)
				Total[{
					injectionVolume,
					Divide[
						autosamplerDeadVolume,
						If[preresolvedConsolidateAliquots,
							Count[Download[mySamples, Object], Lookup[samplePacket, Object]] * numberOfReplicates,
							1
						]
					]
				}],
				True,
				If[MatchQ[Lookup[samplePacket, Volume], VolumeP],
					If[MatchQ[Lookup[roundedOptionsAssociation, Scale], (SemiPreparative | Preparative)],
						Lookup[samplePacket, Volume],
						Min[
							Lookup[samplePacket, Volume],
							Total[{
								25 Microliter,
								Divide[
									autosamplerDeadVolume,
									If[preresolvedConsolidateAliquots,
										Count[Download[mySamples, Object], Lookup[samplePacket, Object]] * numberOfReplicates,
										1
									]
								]
							}]
						]
					],
					Total[{
						25 Microliter,
						Divide[
							autosamplerDeadVolume,
							If[preresolvedConsolidateAliquots,
								Count[Download[mySamples, Object], Lookup[samplePacket, Object]] * numberOfReplicates,
								1
							]
						]
					}]
				]
			]
		],
		{
			samplePackets,
			resolvedInjectionVolumes
		}
	];

	(* Determine if Aliquot is required
		Dionex: If sample plate count >2, aliquot.
		Waters: If sample plate count >1, aliquot.
		Agilent: Samples not in 50 mL tube or 15 mL tube, aliquot.
	*)
	preresolvedAliquotBools = Which[
		MatchQ[instrumentModel, agilentHPLCPattern],
		(* For Agilent, the aliquoting is solely decided based on the container model, we can keep any Automatic and let resolveAliquotOptions figure out *)
		specifiedAliquotBools,
		Or[
			And[
				validContainerCountQ,
				Count[DeleteDuplicates[simulatedSampleContainers], ObjectP[Object[Container, Plate]]] > 2
			],
			(* In the case where we have waters instruments in our ensemble, we force this *)
			And[
				Or[
					MemberQ[Download[watersHPLCInstruments, Object], instrumentModel],
					IntersectingQ[semiResolvedAlternateInstruments /. {Automatic :> {}}, watersHPLCInstruments]
				],
				Count[DeleteDuplicates[simulatedSampleContainers], ObjectP[Object[Container, Plate]]] > 1
			]
		],
		Replace[specifiedAliquotBools, Automatic -> True, {1}],
		True,
		specifiedAliquotBools
	];

	(* If Aliquot option is not specifically set to False, we may need to use the aliquotting system to move them *)
	(* Set the container if we need to aliquot *)
	resolvedAliquotContainers = MapThread[
		Which[
			TrueQ[#1] && MatchQ[instrumentModel, agilentHPLCPattern],
			Model[Container, Vessel, "50mL Tube"],
			(* If we have invalid container OR if we have to aliquot due to count of containers, give the default plate *)
			TrueQ[#1]||TrueQ[#2],
			Model[Container, Plate, "96-well 2mL Deep Well Plate"],
			True, Null
		]&,
		{invalidContainerModelBools,preresolvedAliquotBools}
	];

	(* Combine all options we've "pre-resolved" *)
	preresolvedAliquotOptions = Append[
		aliquotOptions,
		{
			Aliquot -> preresolvedAliquotBools,
			ConsolidateAliquots -> preresolvedConsolidateAliquots
		}
	];

	(* Resolve aliquot options. Since we want the samples packed as
tightly as possible, put them all in a single target grouping *)
	{resolveAliquotOptionsResult, resolveAliquotOptionTests} = If[gatherTestsQ,
		Quiet[resolveAliquotOptions[
			ExperimentHPLC,
			mySamples,
			simulatedSamples,
			ReplaceRule[Normal@preresolvedAliquotOptions, Append[resolvedSamplePrepOptions, NumberOfReplicates -> Lookup[optionsAssociation, NumberOfReplicates]]],
			RequiredAliquotAmounts -> RoundOptionPrecision[requiredAliquotVolumes, 0.1 Microliter],
			RequiredAliquotContainers -> resolvedAliquotContainers,
			AliquotWarningMessage -> "because the given samples are not in containers that are compatible with HPLC instruments.",
			Output -> {Result, Tests},
			Cache -> cache
		], {Warning::InstrumentPrecision}],
		{
			Quiet[resolveAliquotOptions[
				ExperimentHPLC,
				mySamples,
				simulatedSamples,
				ReplaceRule[Normal@preresolvedAliquotOptions, Append[resolvedSamplePrepOptions, NumberOfReplicates -> Lookup[optionsAssociation, NumberOfReplicates]]],
				RequiredAliquotAmounts -> RoundOptionPrecision[requiredAliquotVolumes, 0.1 Microliter],
				RequiredAliquotContainers -> resolvedAliquotContainers,
				AliquotWarningMessage -> "because the given samples are not in containers that are compatible with HPLC instruments.",
				Cache -> cache
			], {Warning::InstrumentPrecision}],
			{}
		}
	];

	(* If none of our aliquot booleans are turned on, turn off the ConsolidateAliquots option (we turned it on manually). *)
	resolvedAliquotOptions = If[MatchQ[Lookup[resolveAliquotOptionsResult, Aliquot], {False...} | False],
		resolveAliquotOptionsResult /. {
			(ConsolidateAliquots -> _) :> (ConsolidateAliquots -> Null)
		},
		resolveAliquotOptionsResult
	];

	(* Join all tests *)
	aliquotOptionsTests = Flatten[{
		containerCountTest,
		validAliquotContainerTest,
		resolveAliquotOptionTests
	}];

	(* Set all non-shared Experiment options *)
	resolvedExperimentOptions = If[internalUsageQ,
		Join[preWavefunctionResolution, instrumentSpecificOptionSet, reformattedGradientOptions],
		Join[preWavefunctionResolution, instrumentSpecificOptionSet, reformattedGradientOptions]
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(* Join all resolved options *)
	resolvedOptions = Normal@Join[
		roundedOptionsAssociation,
		resolvedExperimentOptions,
		Association@resolvedSamplePrepOptions,
		Association@resolvedAliquotOptions,
		Association@resolvedPostProcessingOptions
	];

	(* Join all generated tests *)
	allTests = DeleteCases[
		Flatten[{aliquotOptionsTests, columnGapTest,
			columnSelectorConflictTest,
			columnTechniqueTest, columnTemperatureTests,
			columnTypeConsistencyTest, containersExistTest, discardedSamplesTest,
			fractionCollectionEndTimeTest, multipleGradientsColumnPrimeFlushTest,
			gradientInjectionTableSpecifiedDifferentlyTest,
			columnOrientationSelectorConflictTest,
			guardColumnSelectorConflictTest,
			tableColumnConflictTest,columnPositionConflictTest,duplicateColumnPositionTest,
			columnPositionInjectionTableConflictTest,
			columnTemperatureInjectionTableConflictTest,guardColumnTechniqueTest,
			guardColumnTemperatureTests, instrumentResolutionTests,
			instrumentSpecificTests, instrumentStatusTests,
			insufficientVolumeTest, invalidGradientCompositionTest,
			multipleColumnReverseTest, requiredInstrumentConflictTests, incompatibleNeedleWashTest,
			roundingTests, samplePrepTests,
			samplesOutStorageConditionTest, tableColumnConflictTest,
			typeGuardColumnTest, validNameTest,
			fractionCollectionContainerTest,
			conflictDetectorTests,
			missingpHCalibrationTests, invalidpHCalibrationTests, swappedpHCalibrationTargetTests, missingConductivityCalibrationTests, invalidConductivityCalibrationTests,
			validContainerStorageConditionTests, validBlankStorageConditionTests, validStandardStorageConditionTests,
			nonBinaryGradientTest, compatibleMaterialsTests, anySingletonGradientTest,
			standardFrequencyStandardOptionsConflictTests, blankFrequencyBlankOptionsConflictTests,
			standardNullOptionsConflictTests, blankNullOptionsConflictTests, invalidStandardBlankTests, columnNullOptionsConflictTests,
			validFlowRateTest, validBlankFlowRateTest, validStandardFlowRateTest, validColumnPrimeFlowRateTest, validColumnFlushFlowRateTest,
			removedExtraTest, gradientReequilibratedWarning, gradientAmbiguityTest, incorrectGradientOrderOverallTest,
			injectionTableTests, nonFitColumnTest, conflictColumnOvenTest, conflictColumnOutsideInstrumentTest
		}],
		Null
	];

	(* Join all found invalid samples *)
	invalidInputs = DeleteDuplicates@Join[
		discardedSamples,
		containerlessSamples,
		tooManyInvalidInputs
	];

	(* Build lookup table mapping an option to its validity from all error-check bools
	(In the form: OptionName -> BooleanP where True represents a valid option value) *)
	validOptionLookup = Association[
		Name -> validNameQ,
		Instrument -> And[
			!retiredInstrumentQ,
			!deprecatedInstrumentQ,
			!noCapableInstrumentQ,
			validAgilentInstrumentQ,
			!incompatibleColumnSelectorQ,
			!nonInternalHPLCErrorQ
		],
		AlternateInstruments -> !invalidAlternateInstrumentsQ,
		SampleTemperature -> And[
			validSampleTemperatureQ,
			validSampleTemperatureAndDionexDetectorQ,
			compatibleSampleTemperatureQ
		],
		BufferD -> And[
			validBufferDQ,
			validBufferDAndDionexDetectorQ,
			validBufferDNullQ,
			!bufferNumberConflictQ
		],
		GradientD -> And[
			validGradientDQ,
			validGradientDAndDionexDetectorQ,
			!bufferNumberConflictQ
		],
		NeedleWashSolution -> And[
			compatibleCountAndNeedleWashBufferQ,
			compatibleFractionCollectionAndNeedleWashBufferQ
		],
		Gradient -> And[validGradientQ, validGradientCompositionQ],
		AbsorbanceWavelength -> And[
			validDetectionWavelengthQ,
			compatibleDetectionWavelengthQ
		],
		StandardAbsorbanceWavelength -> And[
			validStandardDetectionWavelengthQ,
			compatibleStandardDetectionWavelengthQ
		],
		BlankAbsorbanceWavelength -> And[
			validBlankDetectionWavelengthQ,
			compatibleBlankDetectionWavelengthQ
		],
		ColumnPrimeAbsorbanceWavelength -> And[
			validColumnPrimeDetectionWavelengthQ,
			compatibleColumnPrimeDetectionWavelengthQ
		],
		ColumnFlushAbsorbanceWavelength -> And[
			validColumnFlushDetectionWavelengthQ,
			compatibleColumnFlushDetectionWavelengthQ
		],
		Detector -> And[
			compatibleDetectorQ,
			compatibleCollectFractionsDetectorQ
		],
		ColumnSelector -> !incompatibleColumnSelectorQ,
		Scale -> compatibleScaleQ,
		StandardGradient -> validStandardGradientCompositionQ,
		BlankGradient -> validBlankGradientCompositionQ,
		ColumnPrimeGradient -> validColumnPrimeGradientCompositionQ,
		ColumnFlushGradient -> validColumnFlushGradientCompositionQ,
		InjectionVolume -> compatibleInjectionVolumeQ,
		StandardInjectionVolume -> compatibleInjectionVolumeQ,
		BlankInjectionVolume -> compatibleInjectionVolumeQ,
		Aliquot -> compatibleContainerModelQ,
		AliquotContainer -> compatibleAliquotContainerQ,
		FractionCollectionEndTime -> validFractionCollectionEndTimeQ,
		FlowRate -> compatibleFlowRateQ,
		StandardFlowRate -> compatibleStandardFlowRateQ,
		BlankFlowRate -> compatibleBlankFlowRateQ,
		ColumnPrimeFlowRate -> compatibleColumnPrimeFlowRateQ,
		ColumnFlushFlowRate -> compatibleColumnFlushFlowRateQ,
		SamplesOutStorageCondition -> validSamplesOutStorageConditionQ
	];

	(* Extract all invalid option names from lookup *)
	invalidOptionsMap = KeyValueMap[
		Function[{optionName, validQ},
			If[Not[validQ],
				optionName,
				Nothing
			]
		],
		validOptionLookup
	];

	invalidOptions = DeleteDuplicates[Flatten[
		{
			invalidOptionsMap,
			invalidStandardBlankOptions,
			guardColumnSelectorConflictOptions,
			columnOrientationSelectorConflictOptions,
			tableColumnConflictOptions,
			columnPositionConflictOptions,
			duplicateColumnPositionOptions,
			columnPositionInjectionTableConflictOptions,
			columnTemperatureInjectionTableConflictOptions,
			multipleColumnReverseOptions,
			columnSelectorConflictOptions,
			columnGapOptions,
			gradientInjectionTableSpecifiedDifferentlyOptions,
			invalidGradientCompositionOptions,
			multipleGradientsColumnPrimeFlushOptions,
			invalidFractionCollectionContainerOption,
			instrumentSpecificOptionInvalidOptions,
			instrumentConflictInvalidOptions,
			conflictDetectorOptions,
			incompatibleNeedleWashOptions,
			missingpHCalibrationOptions,
			invalidpHCalibrationOptions,
			missingConductivityCalibrationOptions,
			invalidConductivityCalibrationOptions,
			detectorInstrumentConflictOptions,
			validContainerStorageConditionInvalidOptions,
			validBlankStorageConditionInvalidOptions,
			validStandardStorageConditionInvalidOptions,
			instrumentSpecificOptionInvalidOptions,
			nonBinaryOptions,
			anySingletonGradientOptions,
			standardFrequencyStandardOptionsConflictOptions,
			standardNullOptionsConflictOptions,
			blankFrequencyBlankOptionsConflictOptions,
			blankNullOptionsConflictOptions,
			columnNullOptionsConflictOptions,
			incorrectGradientOrderOptions,
			injectionTableInvalidOptions,
			invalidColumnTemperatureOptions,
			nonFitColumnOption,
			conflictColumnOvenOption,
			conflictColumnOutsideInstrument
		}
	]];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[And[Length[invalidInputs] > 0, messagesQ, !internalUsageQ],
		Message[Error::InvalidInput, ObjectToString /@ invalidInputs]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[And[Length[invalidOptions] > 0, messagesQ, !internalUsageQ],
		Message[Error::InvalidOption, invalidOptions]
	];

	outputSpecification /. {
		Tests -> allTests,
		Result -> If[!internalUsageQ, resolvedOptions, {simulatedSamples, resolvedOptions, invalidOptions, invalidInputs, simulatedCache}]
	}

];



(* ::Subsection:: *)
(* resolveHPLCInstrumentOptions *)


(* ::Subsubsection:: *)
(* resolveHPLCInstrumentOptions *)


DefineOptions[
	resolveHPLCInstrumentOptions,
	Options :> {OutputOption}
];

(*this is a helper function to resolve the instrument specific options. it's important for generating the wavefunction ensemble of options*)
resolveHPLCInstrumentOptions[
	mySamples : ListableP[ObjectP[Object[Sample]]],
	currentInstrument : ObjectP[{Object[Instrument, HPLC], Model[Instrument, HPLC]}],
	partiallyResolvedOptions : _Association,
	cache_ : {PacketP..},
	myOptions : OptionsPattern[]
] := Module[
	{
		safeOps, output, gatherTestsQ, messagesQ, engineQ, testOrNull, warningOrNull, requiredOptions, resolvedColumnSelector, allColumnsUsed, allColumnModelPackets, maxAccelerations, minMaxAcceleration, minAcceleration, validMaxAccelerationQ, availableDetectors,
		fractionCollectionQ, fractionCollectionDetectorOption, missingFractionCollectionDetectorTest, availableFractionCollectionDetectors, uvDetector, fractionCollectionUnitDetectors, resolvedFractionCollectionDetector,
		fractionCollectionObjectPositions, fractionCollectionObjects, fractionCollectionPackets, conflictFractionCollectionUnitQ, fractionCollectionCorrectUnit, conflictFractionCollectionUnitOptions, conflictFractionCollectionUnitTests, resolvedAbsoluteThreshold, fractionCollectionModes, resolvedPeakSlope, resolvedPeakSlopeDuration, resolvedPeakEndThreshold,
		conflictFractionCollectionOptionsBool, incompatibleFractionCollectionOptionsBool, incompatibleFractionCollectionOptions, incompatibleFractionCollectionOptionsQ, incompatibleFractionCollectionAllOptions, conflictFractionCollectionMethodOptions, incompatibleFractionCollectionTest, conflictFractionCollectionMethodTests,
		pHRequiredOptions, conductivityRequiredOptions, fluorescenceRequiredOptions, dionexFluorescenceRequiredOptions, lightScatteringRequiredOptions, refractiveIndexRequiredOptions, finalFluorescenceRequiredOptions,
		missingOptionsDetectorPairs, missingOptionDetectors, missingDetectionOptions, missingDetectionOptionsTests,
		resolvedpHTemperatureCompensation, resolvedConductivityTemperatureCompensation,
		resolvedInstrumentSpecificOptions, resultRule, testsRule, outputSpecification, resolvedDetector, resolvedMaxAcceleration, resolvedSampleTemperature, resolvedAbsorbanceWavelengths, missingFractionCollectionDetectorOption, resolvedAbsorbanceSamplingRates, resolvedUVFilters,
		fluorescenceWavelengthLimit, resolvedExcitationWavelength, resolvedEmissionWavelength, resolvedEmissionCutOffFilter, resolvedFluorescenceGain, resolvedFluorescenceFlowCellTemperature, wavelengthSwappedErrors, conflictFluorescenceLengthErrors, tooNarrowFluorescenceRangeErrors, tooManyFluorescenceWavelengthsErrors, invalidEmissionCutOffFilterErrors, tooLargeEmissionCutOffFilterErrors, invalidWatersFluorescenceGainErrors, invalidFluorescenceFlowCellTemperatureErrors,
		resolvedStandardExcitationWavelength, resolvedStandardEmissionWavelength, resolvedStandardEmissionCutOffFilter, resolvedStandardFluorescenceGain, resolvedStandardFluorescenceFlowCellTemperature, standardWavelengthSwappedErrors, standardTooNarrowFluorescenceRangeErrors, standardConflictFluorescenceLengthErrors, standardTooManyFluorescenceWavelengthsErrors, standardInvalidEmissionCutOffFilterErrors, standardTooLargeEmissionCutOffFilterErrors, standardInvalidWatersFluorescenceGainErrors, standardInvalidFluorescenceFlowCellTemperatureErrors,
		resolvedBlankExcitationWavelength, resolvedBlankEmissionWavelength, resolvedBlankEmissionCutOffFilter, resolvedBlankFluorescenceGain, resolvedBlankFluorescenceFlowCellTemperature, blankWavelengthSwappedErrors, blankTooNarrowFluorescenceRangeErrors, blankConflictFluorescenceLengthErrors, blankTooManyFluorescenceWavelengthsErrors, blankInvalidEmissionCutOffFilterErrors, blankTooLargeEmissionCutOffFilterErrors, blankInvalidWatersFluorescenceGainErrors, blankInvalidFluorescenceFlowCellTemperatureErrors,
		resolvedColumnPrimeExcitationWavelength, resolvedColumnPrimeEmissionWavelength, resolvedColumnPrimeEmissionCutOffFilter, resolvedColumnPrimeFluorescenceGain, resolvedColumnPrimeFluorescenceFlowCellTemperature, columnPrimeWavelengthSwappedErrors, columnPrimeTooNarrowFluorescenceRangeErrors, columnPrimeConflictFluorescenceLengthErrors, columnPrimeTooManyFluorescenceWavelengthsErrors, columnPrimeInvalidEmissionCutOffFilterErrors, columnPrimeTooLargeEmissionCutOffFilterErrors, columnPrimeInvalidWatersFluorescenceGainErrors, columnPrimeInvalidFluorescenceFlowCellTemperatureErrors,
		resolvedColumnFlushExcitationWavelength, resolvedColumnFlushEmissionWavelength, resolvedColumnFlushEmissionCutOffFilter, resolvedColumnFlushFluorescenceGain,  resolvedColumnFlushFluorescenceFlowCellTemperature, columnFlushWavelengthSwappedErrors, columnFlushTooNarrowFluorescenceRangeErrors, columnFlushConflictFluorescenceLengthErrors, columnFlushTooManyFluorescenceWavelengthsErrors, columnFlushInvalidEmissionCutOffFilterErrors, columnFlushTooLargeEmissionCutOffFilterErrors, columnFlushInvalidWatersFluorescenceGainErrors, columnFlushInvalidFluorescenceFlowCellTemperatureErrors,
		resolvedLightScatteringLaserPower, resolvedLightScatteringFlowCellTemperature, resolvedStandardLightScatteringLaserPower, resolvedStandardLightScatteringFlowCellTemperature, resolvedBlankLightScatteringLaserPower, resolvedBlankLightScatteringFlowCellTemperature, resolvedColumnPrimeLightScatteringLaserPower, resolvedColumnPrimeLightScatteringFlowCellTemperature, resolvedColumnFlushLightScatteringLaserPower, resolvedColumnFlushLightScatteringFlowCellTemperature,
		resolvedRefractiveIndexMethod, resolvedRefractiveIndexFlowCellTemperature, refractiveIndexMethodConflictErrors, resolvedStandardRefractiveIndexMethod, resolvedStandardRefractiveIndexFlowCellTemperature, standardRefractiveIndexMethodConflictErrors, resolvedBlankRefractiveIndexMethod, resolvedBlankRefractiveIndexFlowCellTemperature, blankRefractiveIndexMethodConflictErrors, resolvedColumnPrimeRefractiveIndexMethod, resolvedColumnPrimeRefractiveIndexFlowCellTemperature, columnPrimeRefractiveIndexMethodConflictErrors, resolvedColumnFlushRefractiveIndexMethod, resolvedColumnFlushRefractiveIndexFlowCellTemperature, columnFlushRefractiveIndexMethodConflictErrors,
		resolvedNebulizerGas, resolvedNebulizerGasHeating, resolvedNebulizerHeatingPower, resolvedNebulizerGasPressure, resolvedDriftTubeTemperatures, resolvedELSDGains, resolvedELSDSamplingRates, standardNebulizerGas, standardNebulizerGasHeating, invalidOptions, gasPressureAsList,
		standardNebulizerHeatingPower, standardNebulizerGasPressure, standardDriftTubeTemperature, standardELSDGain, standardELSDSamplingRate,
		resolvedStandard, resolvedBlank, standardExistsQ, blankExistsQ, columnsExistQ, standardOptions, blankOptions, columnOptions, expandedStandardOptions,
		expandedBlankOptions, expandedColumnOptions, potentialAnalyteTests, wavelengthResolutionOptions,
		blankNebulizerGas, blankNebulizerGasHeating,
		blankNebulizerHeatingPower, blankNebulizerGasPressure, blankDriftTubeTemperature, blankELSDGain, blankELSDSamplingRate, columnPrimeNebulizerGas, columnPrimeNebulizerGasHeating,
		columnPrimeNebulizerHeatingPower, columnPrimeNebulizerGasPressure, columnPrimeDriftTubeTemperature, columnPrimeELSDGain, columnPrimeELSDSamplingRate,
		columnFlushNebulizerGas, gasHeatingAsList, gasOptionAsList, powerOptionAsList,
		columnFlushNebulizerGasHeating, columnFlushNebulizerHeatingPower, columnFlushNebulizerGasPressure, columnFlushDriftTubeTemperature, columnFlushELSDGain, columnFlushELSDSamplingRate,
		currentInstrumentModelPacket, currentInstrumentModel, alternateInstrumentsOption, alternativeInstrumentModelPackets, allInstrumentDetectors,
		invalidMaxAccerationOption, maxAccelerationTest, instrumentManufacturer,
		watersManufacturedQ, agilentManufacturedQ, collectFractionsQ, detectorOption, possibleAbsorbanceRateValues, possibleWavelengthResolutions, samplePackets, possibleAnalytes, analyteTypes,
		resolvedWavelengthResolutions, wavelengthResolutionSampleConflictBool, roundedSamplingSampleRateBool, roundedWavelengthSampleResolutionBool, wavelengthFractionCollectionConflictBool,
		resolvedStandardAbsorbanceWavelengths, resolvedStandardWavelengthResolutions, resolvedStandardUVFilters, resolvedStandardAbsorbanceSamplingRates,
		wavelengthResolutionStandardConflictBool, roundedSamplingStandardRateBool, roundedWavelengthStandardResolutionBool, roundedWavelengthColumnPrimeResolutionBool,
		resolvedBlankAbsorbanceWavelengths, resolvedBlankWavelengthResolutions, resolvedBlankUVFilters, resolvedBlankAbsorbanceSamplingRates,
		wavelengthResolutionBlankConflictBool, roundedSamplingBlankRateBool, roundedWavelengthBlankResolutionBool, resolvedColumnPrimeAbsorbanceWavelengths,
		resolvedColumnPrimeWavelengthResolutions, resolvedColumnPrimeUVFilters, resolvedColumnPrimeAbsorbanceSamplingRates, wavelengthResolutionColumnPrimeConflictBool,
		roundedSamplingColumnPrimeRateBool, resolvedColumnFlushAbsorbanceWavelengths, resolvedColumnFlushWavelengthResolutions, resolvedColumnFlushUVFilters,
		resolvedColumnFlushAbsorbanceSamplingRates, wavelengthResolutionColumnFlushConflictBool, roundedSamplingColumnFlushRateBool, roundedWavelengthColumnFlushResolutionBool,
		absorbanceRateOptions, roundedSamplingRateRoundingBool, roundedSamplingRateRoundingOptions, roundedWavelengthResolutionBool, roundedWavelengthResolutionBoolOptions,
		wavelengthResolutionConflictBool, wavelengthResolutionConflictOptions, wavelengthResolutionConflictTests, wavelengthFractionCollectionConflictOptions, wavelengthFractionCollectionConflictTests,
		innerResult, innerNebulizerGas, innerNebulizerGasHeating, innerNebulizerHeatingPower, innerNebulizerGasPressure, innerDriftTubeTemperature, innerELSDGain, innerELSDSamplingRate,
		fluorescenceGreaterEmissionInvalidOptions, fluorescenceGreaterEmissionInvalidTests, fluorescenceRangeTooNarrowInvalidOptions, fluorescenceRangeTooNarrowInvalidTests, conflictFluorescenceLengthOptions, conflictFluorescenceLengthTests, tooManyFluorescenceChannelsOptions, tooManyFluorescenceChannelsTests, invalidEmissionCutOffFilterOptions, invalidEmissionCutOffFilterTests, tooLargeEmissionCutOffFilterOptions, tooLargeEmissionCutOffFilterTests, invalidDionexFluorescenceGainOptions, invalidWatersFluorescenceGainOptions, invalidWatersFluorescenceGainTests, invalidFluorescenceFlowCellTemperatureOptions, invalidFluorescenceFlowCellTemperatureTests, conflictRefractiveIndexMethodOptions, conflictRefractiveIndexMethodTests,
		gasPressureOptions, nebulizerGasOptions, gasPressureConflictBool, gasPressureConflictOptions, gasPressureConflictTest, nebulizerGasHeatingOptions, gasHeatingConflictBool, gasHeatingConflictOptions, gasHeatingConflictTest, nebulizerHeatingPowerOptions,
		heatingPowerConflictGasBool, heatingPowerConflictHeatingBool, gasHeatingPowerConflictOptions, gasHeatingPowerConflictTest, uvFilterOptions, samplingRateOptions, tuvOptionsNotNeededQ,
		tuvNotNeededOptions, tuvOptionsNotNeededTest, resolvedInjectionTable, columnPrimeQ, columnFlushQ, columnPrimeOptions, columnFlushOptions,
		preexpandedColumnOptions, fluorescenceEmissionMaximums, fluorescenceExcitationMaximums, extinctionCoefficientWavelengths
	},

	(* Get the safe options *)
	safeOps = SafeOptions[resolveHPLCInstrumentOptions, ToList[myOptions]];

	(* Determine the requested return value from the function *)
	outputSpecification = Lookup[safeOps, Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTestsQ = MemberQ[output, Tests];

	(* Determine if we should throw messages *)
	messagesQ = !gatherTestsQ;

	(* Determine if we're being executed in Engine *)
	engineQ = MatchQ[$ECLApplication, Engine];

	testOrNull[testDescription_String, passQ : BooleanP] := If[gatherTestsQ,
		Test[testDescription, True, Evaluate[passQ]],
		Null
	];
	warningOrNull[testDescription_String, passQ : BooleanP] := If[gatherTestsQ,
		Warning[testDescription, True, Evaluate[passQ]],
		Null
	];

	(* Extract downloaded mySamples packets *)
	samplePackets = fetchPacketFromCacheHPLC[#, cache]& /@ mySamples;

	{possibleAnalytes, potentialAnalyteTests} = If[gatherTestsQ,
		Quiet[selectAnalyteFromSample[samplePackets, Cache -> cache, Output -> {Result, Tests}], {Warning::AmbiguousAnalyte}],
		{Quiet[selectAnalyteFromSample[samplePackets, Cache -> cache, Output -> Result], {Warning::AmbiguousAnalyte}], Null}
	];

	(* Get all of the analyte types *)
	analyteTypes = Map[
		Function[
			{analyte},
			Switch[analyte,
				ObjectP[Model[Molecule, Oligomer]], Lookup[fetchPacketFromCache[analyte, cache], PolymerType],
				ObjectP[Model[Molecule, Protein]], Protein,
				(* Otherwise, presumed to just be a molecule *)
				_, Molecule
			]
		],
		possibleAnalytes
	];

	extinctionCoefficientWavelengths = Map[
		Function[
			{analyte},
			Module[{extinctionCoefficients},
				extinctionCoefficients = If[NullQ[analyte],
					Null,
					Lookup[fetchPacketFromCache[analyte, cache], ExtinctionCoefficients] /. {} -> Null
				];
				If[NullQ[extinctionCoefficients]||MatchQ[extinctionCoefficients,{}],
					Null,
					First[Lookup[MaximalBy[extinctionCoefficients, Lookup[#, ExtinctionCoefficient]&], Wavelength]]
				]
			]
		],
		possibleAnalytes
	];

	(* Fetch current instrument's model packet *)
	currentInstrumentModelPacket = If[MatchQ[currentInstrument, ObjectP[Model]],
		fetchPacketFromCacheHPLC[currentInstrument, cache],
		fetchModelPacketFromCacheHPLC[currentInstrument, cache]
	];

	(* Extract instrument model's object *)
	currentInstrumentModel = Lookup[currentInstrumentModelPacket, Object];

	(* Get the AlternativeInstruments to help resolve the detector *)
	alternateInstrumentsOption = RestOrDefault[ToList[Lookup[partiallyResolvedOptions, Instrument, {}]]] /. {} -> Null;

	(* Fetch alternate instrument's model packet *)
	alternativeInstrumentModelPackets = If[NullQ[alternateInstrumentsOption],
		{},
		Map[
			If[MatchQ[#, ObjectP[Model]],
				fetchPacketFromCacheHPLC[#, cache],
				fetchModelPacketFromCacheHPLC[#, cache]
			]&,
			ToList[alternateInstrumentsOption]
		]
	];

	(* Get the Detectors of all the instruments *)
	allInstrumentDetectors = Map[
		Lookup[#, Detectors]&,
		Prepend[alternativeInstrumentModelPackets, currentInstrumentModelPacket]
	];

	(* Define the required options that we need for the resolution here *)
	requiredOptions = {
		Standard,
		Blank,
		InjectionTable,
		ColumnSelector
	};

	(* Get the pertinent options*)
	{
		resolvedStandard,
		resolvedBlank,
		resolvedInjectionTable,
		resolvedColumnSelector
	} = Lookup[partiallyResolvedOptions,
		requiredOptions
	];

	(* Get the fraction collection requirement *)
	fractionCollectionQ = Or @@ (Lookup[partiallyResolvedOptions, CollectFractions]);

	(* Get all the columns used here *)
	allColumnsUsed = Cases[Flatten[ToList[resolvedColumnSelector]], ObjectP[]];
	(* Get all of the model packets for all columns used *)
	allColumnModelPackets = Map[
		Function[
			{column},
			If[MatchQ[column, ObjectP[Object[Item]]],
				fetchModelPacketFromCacheHPLC[column, cache],
				(* Otherwise, should be a model *)
				fetchPacketFromCache[column, cache]
			]
		],
		allColumnsUsed
	];

	(* Extract all populated max accelerations *)
	maxAccelerations = Cases[
		Flatten[{
			Lookup[currentInstrumentModelPacket, MaxAcceleration, Null],
			Lookup[allColumnModelPackets, MaxAcceleration, Null]
		}],
		Except[Null]
	];

	(* Find the min MaxAcceleration *)
	minMaxAcceleration = If[Length[maxAccelerations] > 0,
		Min[maxAccelerations],
		Null
	];

	(* Find the min minAcceleration of the instrument *)
	minAcceleration = If[!NullQ[Lookup[currentInstrumentModelPacket, MinAcceleration]],
		Lookup[currentInstrumentModelPacket, MinAcceleration],
		0 (Milliliter / Minute^2)
	];

	(* Resolve MaxAcceleration by taking option value or minimum of the max acceleration of column and instrument *)
	resolvedMaxAcceleration = If[!MatchQ[Lookup[partiallyResolvedOptions, MaxAcceleration], Automatic],
		Lookup[partiallyResolvedOptions, MaxAcceleration],
		minMaxAcceleration
	];

	(* Check that a specified MaxAcceleration is below the max of the instrument and column(s) *)
	validMaxAccelerationQ = If[
		MatchQ[{minAcceleration, resolvedMaxAcceleration, minMaxAcceleration}, {GreaterEqualP[0 Milliliter / Minute^2], GreaterEqualP[0 Milliliter / Minute^2], GreaterEqualP[0 Milliliter / Minute^2]}],
		minAcceleration <= resolvedMaxAcceleration <= minMaxAcceleration,
		True
	];

	invalidMaxAccerationOption = If[!validMaxAccelerationQ, {MaxAcceleration}, {}];

	(* Build max acceleration test *)
	maxAccelerationTest = If[!validMaxAccelerationQ,
		(
			If[messagesQ,
				Message[Error::InvalidHPLCMaxAcceleration, Lookup[partiallyResolvedOptions, MaxAcceleration], minMaxAcceleration]
			];
			testOrNull["A specified MaxAcceleration is less than the instrument and column(s)'s MaxAcceleration values and greater than the instrument's MinAcceleration:", False]
		),
		testOrNull["A specified MaxAcceleration is less than the instrument and column(s)'s MaxAcceleration values and greater than the instrument's MinAcceleration", True]
	];

	(* Get the detectors of all instrument or alternative instrument *)
	(* We do it this way to avoid providing different kinds of data after protocol is submitted *)
	(* This will absolutely not be an empty list - if a detector is requested, it must show here; if Detector is automatic, the resolved instruments should at least share UVVis-PDA, which both give Absorbance data and we can switch. *)
	availableDetectors = Intersection @@ allInstrumentDetectors;

	(* Perform our detector resolution *)
	detectorOption = ToList[Lookup[partiallyResolvedOptions, Detector]];

	(* We resolved the instrument based on the Detector option so this is guaranteed to be valid *)
	resolvedDetector = If[MatchQ[First@detectorOption, Automatic],
		DeleteDuplicates[
			Prepend[
				availableDetectors,
				If[MemberQ[Lookup[currentInstrumentModelPacket, Detectors], UVVis],
					UVVis,
					PhotoDiodeArray
				]
			]
		],
		DeleteDuplicates[detectorOption]
	];

	(* Perform our fraction collection detector resolution *)
	(* Get the user-provided fraction collection detector *)
	fractionCollectionDetectorOption = Lookup[partiallyResolvedOptions, FractionCollectionDetector];

	(* The provided fraction collection detector should be a member of resolvedDetector *)
	(* Throw an error message if FractionCollectionDetector is missing from resolvedDetector but it should be provided *)
	missingFractionCollectionDetectorOption = If[MatchQ[fractionCollectionDetectorOption, Except[Automatic | Null]] && !MemberQ[resolvedDetector, fractionCollectionDetectorOption] && fractionCollectionQ,
		{FractionCollectionDetector},
		{}
	];

	(* Generate the tests for missing fraction collection detector *)
	missingFractionCollectionDetectorTest = If[!MatchQ[missingFractionCollectionDetectorOption, {}],
		(
			If[messagesQ,
				Message[Error::MissingFractionCollectionDetector, Lookup[partiallyResolvedOptions, FractionCollectionDetector], resolvedDetector, ObjectToString[currentInstrument, Cache -> cache]]
			];
			testOrNull["The specified FractionCollectionDetector " <> ToString[Lookup[partiallyResolvedOptions, FractionCollectionDetector]] <> " is a member of the available detectors " <> ToString[resolvedDetector] <> " of the resolved HPLC instrument " <> ObjectToString[currentInstrument, Cache -> cache] <> ".", False]
		),
		testOrNull["The specified FractionCollectionDetector is a member of the available detectors of the resolved HPLC instrument when fraction collection is requested.", True]
	];

	(* The provided fraction collection detector should be availble for fraction collection - as in the FractionCollectionDetectors field of the resolved Instrument *)
	(* Get all of the available fraction collection detectors of the resolvedInstrument*)
	availableFractionCollectionDetectors = Lookup[currentInstrumentModelPacket, FractionCollectionDetectors];

	(* Get the units specified in the related options to help resolve fraction collection detector *)
	(* Currently we allow UVVis/Fluorescence for fraction collection *)
	(* UVVis and PDA are for different instruments and we would like to resolve based on our instrument *)
	uvDetector=If[MemberQ[resolvedDetector,PhotoDiodeArray],
		PhotoDiodeArray,
		UVVis
	];
	fractionCollectionUnitDetectors = Which[
		(* Check AbsoluteThreshold first - if AbsorbanceUnit is selected, go with UVVis or CD*)
		MemberQ[Lookup[partiallyResolvedOptions, AbsoluteThreshold], GreaterEqualP[0 AbsorbanceUnit]], {uvDetector},
		(* if Fluorescence is selected, go with Fluorescence *)
		MemberQ[Lookup[partiallyResolvedOptions, AbsoluteThreshold], GreaterEqualP[0 RFU]], {Fluorescence},
		(* if No units go with pH*)
		MemberQ[Lookup[partiallyResolvedOptions, AbsoluteThreshold], GreaterEqualP[0]], {pH},
		(* if units given in siemens/centimeter go with conductance*)
		MemberQ[Lookup[partiallyResolvedOptions, AbsoluteThreshold], GreaterEqualP[0 Siemens / Centimeter]], {Conductance},
		(* Likewise check PeakSlope *)
		MemberQ[Lookup[partiallyResolvedOptions, PeakSlope], GreaterEqualP[0 AbsorbanceUnit / Second]], {uvDetector},
		MemberQ[Lookup[partiallyResolvedOptions, PeakSlope], GreaterEqualP[0 RFU / Second]], {Fluorescence},
		MemberQ[Lookup[partiallyResolvedOptions, PeakSlope], GreaterEqualP[0]], {pH},
		MemberQ[Lookup[partiallyResolvedOptions, PeakSlope], GreaterEqualP[0 Siemens / Centimeter]], {Conductance},
		(* Likewise check PeakEndThreshold *)
		MemberQ[Lookup[partiallyResolvedOptions, PeakEndThreshold], GreaterEqualP[0 AbsorbanceUnit]], {uvDetector},
		MemberQ[Lookup[partiallyResolvedOptions, PeakEndThreshold], GreaterEqualP[0 RFU]], {Fluorescence},
		MemberQ[Lookup[partiallyResolvedOptions, PeakEndThreshold], GreaterEqualP[0]], {pH},
		MemberQ[Lookup[partiallyResolvedOptions, PeakEndThreshold], GreaterEqualP[0 Siemens / Centimeter]], {Conductance},
		(* Otherwise, anything is OK *)
		True, {UVVis, Fluorescence}
	];

	(* Resolved FractionCollectionDetector *)
	resolvedFractionCollectionDetector = If[MatchQ[fractionCollectionDetectorOption, Automatic],
		If[fractionCollectionQ,
			(* Use the first member of Detector that is available for fraction collection. If none is available, set to Null. An error message was thrown earlier*)
			(* Note that UVVis is preferred over any other detector *)
			FirstOrDefault[
				SortBy[
					Intersection[resolvedDetector, availableFractionCollectionDetectors, fractionCollectionUnitDetectors],
					(* UVVis preferred over Fluorescence and over CD - Give a default {Infinity} incase we get anything bad into the list so it is always the end of the list*)
					First[FirstPosition[{UVVis, PhotoDiodeArray, Fluorescence}, #, {Infinity}]]&
				]
			],
			Null
		],
		fractionCollectionDetectorOption
	];

	(* Resolve Fraction Collection related options - the units depend on the FractionCollectionDetector *)
	(* Get the related information *)
	(* Find the position for any objects specified in the FractionCollectionMethod option *)
	fractionCollectionObjectPositions = Flatten@Position[Lookup[partiallyResolvedOptions, FractionCollectionMethod], ObjectP[Object[Method, FractionCollection]], {1}];

	(* Extract any specified method objects for below Download *)
	fractionCollectionObjects = Lookup[partiallyResolvedOptions, FractionCollectionMethod][[fractionCollectionObjectPositions]];

	(* If fraction collection method packets are downloaded, they will be in nested lists *)
	fractionCollectionPackets = If[MatchQ[fractionCollectionObjects, {}],
		Table[Null, Length[mySamples]],
		fetchPacketFromCacheHPLC[#, cache]& /@ Lookup[partiallyResolvedOptions, FractionCollectionMethod]
	];

	(* Check that the values are provided with the correct units according to the resolvedFractionCollectionDetector *)
	conflictFractionCollectionUnitQ = Map[
		Which[
			(* AbsorbanceUnit should not exist for Fluorescence detector *)
			MatchQ[resolvedFractionCollectionDetector, Fluorescence],
			MemberQ[Lookup[partiallyResolvedOptions, #], GreaterEqualP[0 AbsorbanceUnit] | GreaterEqualP[0 AbsorbanceUnit / Second]] | GreaterEqualP[0] | GreaterEqualP[0 Siemens / Centimeter],
			MatchQ[resolvedFractionCollectionDetector, UVVis|PhotoDiodeArray],
			MemberQ[Lookup[partiallyResolvedOptions, #], GreaterEqualP[0 RFU] | GreaterEqualP[0 RFU / Second] | GreaterEqualP[0] | GreaterEqualP[0 Siemens / Centimeter]],
			True, False
		]&,
		{AbsoluteThreshold, PeakSlope, PeakEndThreshold}
	];

	(* Get the correct unit *)
	fractionCollectionCorrectUnit = Which[
		MatchQ[resolvedFractionCollectionDetector, Fluorescence], RFU,
		MatchQ[resolvedFractionCollectionDetector, UVVis|PhotoDiodeArray], AbsorbanceUnit,
		MatchQ[resolvedFractionCollectionDetector, Conductance], Siemens / Centimeter,
		True, None
	];

	(* Throw error message for the conflict units *)
	conflictFractionCollectionUnitOptions = If[MemberQ[conflictFractionCollectionUnitQ, True],
		Message[Error::ConflictFractionCollectionUnit, ToString[resolvedFractionCollectionDetector], ToString[PickList[{AbsoluteThreshold, PeakSlope, PeakEndThreshold}, conflictFractionCollectionUnitQ]], ToString[fractionCollectionCorrectUnit]];
		PickList[{AbsoluteThreshold, PeakSlope, PeakEndThreshold}, conflictFractionCollectionUnitQ],
		{}
	];

	(* Generate tests for wrong units *)
	conflictFractionCollectionUnitTests = Module[{passingTest, failingTest},
		passingTest = If[MemberQ[conflictFractionCollectionUnitQ, False],
			testOrNull["The specified fraction collection options " <> ToString[PickList[{AbsoluteThreshold, PeakSlope, PeakEndThreshold}, conflictFractionCollectionUnitQ, False]] <> " match the required units of the FractionCollectionDetector " <> ToString[resolvedFractionCollectionDetector] <> ".", True],
			Nothing
		];
		failingTest = If[MemberQ[conflictFractionCollectionUnitQ, True],
			testOrNull["The specified fraction collection options " <> ToString[PickList[{AbsoluteThreshold, PeakSlope, PeakEndThreshold}, conflictFractionCollectionUnitQ]] <> " match the required units of the FractionCollectionDetector " <> ToString[resolvedFractionCollectionDetector] <> ".", False],
			Nothing
		];
		{passingTest, failingTest}
	];

	(* If collecting fractions, fetch absolute threshold from: option value if specified, fraction method, or default to different values depending on the detector*)

	fractionCollectionModes = Lookup[partiallyResolvedOptions, FractionCollectionMode];

	resolvedAbsoluteThreshold = MapThread[
		If[TrueQ[#1],
			If[!MatchQ[#2, Automatic],
				#2,
				If[MatchQ[#3, PacketP[]],
					Lookup[#3, AbsoluteThreshold],
					(* set the default value depending on the different type of fraction collection detector *)
					If[MatchQ[#4, Threshold],
						Switch[resolvedFractionCollectionDetector,
							Fluorescence, 100 Milli * RFU,
							Conductance, 5000 Milli * Siemens / Centimeter,
							pH, 10,
							(* UVVis or PhotoDiodeArray or not resolvable *)
							_, 500 Milli * AbsorbanceUnit
						],
						Null
					]
				]
			],
			Null
		]&,
		{
			Lookup[partiallyResolvedOptions, CollectFractions],
			Lookup[partiallyResolvedOptions, AbsoluteThreshold],
			fractionCollectionPackets,
			fractionCollectionModes
		}
	];

	(* If collecting fractions, fetch PeakSlope from: option value if specified, fraction method, or default to Null *)
	resolvedPeakSlope = MapThread[
		If[TrueQ[#1],
			If[!MatchQ[#2, Automatic],
				#2,
				If[MatchQ[#3, PacketP[]],
					Lookup[#3, PeakSlope],
					If[MatchQ[#4, Peak],
						Switch[resolvedFractionCollectionDetector,
							Fluorescence, 0.2 Milli * RFU / Second,
							Conductance, 0.5 Milli * Siemens / Centimeter / Second,
							pH, 0.5 Power[Second, -1],
							(* UVVis or PhotoDiodeArray or not resolvable *)
							_, 1 Milli AbsorbanceUnit / Second
						],
						Null
					]
				]
			],
			Null
		]&,
		{
			Lookup[partiallyResolvedOptions, CollectFractions],
			Lookup[partiallyResolvedOptions, PeakSlope],
			fractionCollectionPackets,
			fractionCollectionModes
		}
	];

	(* If collecting fractions, fetch PeakSlopeDuration from: option value if specified, fraction method, or default to Null *)
	resolvedPeakSlopeDuration = MapThread[
		If[TrueQ[#1],
			If[!MatchQ[#2, Automatic],
				#2,
				If[MatchQ[#3, PacketP[]],
					Lookup[#3, PeakSlopeDuration],
					If[MatchQ[#4, Peak], 1 Second, Null]
				]
			],
			Null
		]&,
		{
			Lookup[partiallyResolvedOptions, CollectFractions],
			Lookup[partiallyResolvedOptions, PeakSlopeDuration],
			fractionCollectionPackets,
			fractionCollectionModes
		}
	];

	(* If collecting fractions, fetch PeakEndThreshold from: option value if specified, fraction method, or default to Null *)
	resolvedPeakEndThreshold = MapThread[
		If[TrueQ[#1],
			If[!MatchQ[#2, Automatic],
				#2,
				If[MatchQ[#3, PacketP[]],
					Lookup[#3, PeakEndThreshold],
					If[MatchQ[#4, Peak],
						Switch[resolvedFractionCollectionDetector,
							Fluorescence, 0.2 Milli * RFU,
							Conductivity, 10.0 Milli * Siemens / Centimeter,
							pH, 10,
							(* UVVis or PhotoDiodeArray or not resolvable *)
							_, 1 Milli AbsorbanceUnit
						],
						Null
					]
				]
			],
			If[!MatchQ[#2, Automatic],
				#2,
				Null
			]
		]&,
		{
			Lookup[partiallyResolvedOptions, CollectFractions],
			Lookup[partiallyResolvedOptions, PeakEndThreshold],
			fractionCollectionPackets,
			fractionCollectionModes
		}
	];

	(* Check that the method is not conflicting with other methods *)
	conflictFractionCollectionOptionsBool = MapThread[
		If[NullQ[#1],
			False,
			!And[
				MatchQ[Lookup[#1, FractionCollectionMode, Null], #2],
				MatchQ[Lookup[#1, AbsoluteThreshold, Null], #3],
				MatchQ[Lookup[#1, PeakSlope, Null], #4],
				MatchQ[Lookup[#1, PeakSlopeDuration, Null], #5],
				MatchQ[Lookup[#1, PeakEndThreshold, Null], #6],
				MatchQ[Lookup[#1, FractionCollectionStartTime, Null], #7],
				MatchQ[Lookup[#1, FractionCollectionEndTime, Null], #8],
				MatchQ[Lookup[#1, MaxFractionVolume, Null], #9],
				MatchQ[Lookup[#1, MaxCollectionPeriod, Null], #10]
			]
		]&,
		{
			fractionCollectionPackets,
			fractionCollectionModes,
			resolvedAbsoluteThreshold,
			resolvedPeakSlope,
			resolvedPeakSlopeDuration,
			resolvedPeakEndThreshold,
			Lookup[partiallyResolvedOptions, FractionCollectionStartTime],
			Lookup[partiallyResolvedOptions, FractionCollectionEndTime],
			Lookup[partiallyResolvedOptions, MaxFractionVolume],
			Lookup[partiallyResolvedOptions, MaxCollectionPeriod]
		}
	];

	(* Make sure that the modes have the corresponding fields specified or not *)
	{incompatibleFractionCollectionOptionsBool, incompatibleFractionCollectionOptions} = Transpose@MapThread[
		Function[{mode, absThres, peSlope, peDuration, peThreshold, methodConflict},
			(* If we have method conflict, just do not throw message for the other options *)
			If[methodConflict,
				{False, {}},
				Switch[{mode, absThres, peSlope, peDuration, peThreshold},
					{Null, ___}, {False, {}},
					(*none of these should be defined if time*)
					{Time, Null..}, {False, {}},
					{Time, ___}, {True,
					PickList[{AbsoluteThreshold, PeakSlope, PeakSlopeDuration, PeakEndThreshold}, {absThres, peSlope, peDuration, peThreshold}, Except[Null]]
				},
					{Threshold, _, Null..}, {False, {}},
					{Threshold, _, ___}, {True,
					PickList[{PeakSlope, PeakSlopeDuration, PeakEndThreshold}, {peSlope, peDuration, peThreshold}, Except[Null]]
				},
					{Peak, Null, ___}, {False, {}},
					{Peak, ___}, {True, {AbsoluteThreshold}}
				]
			]
		],
		{
			fractionCollectionModes,
			resolvedAbsoluteThreshold,
			resolvedPeakSlope,
			resolvedPeakSlopeDuration,
			resolvedPeakEndThreshold,
			conflictFractionCollectionOptionsBool
		}
	];

	(* Track the fraction collection method conflicting and throw message *)
	conflictFractionCollectionMethodOptions = If[MemberQ[conflictFractionCollectionOptionsBool, True] && messagesQ,
		Message[Error::ConflictingFractionCollectionMethodOptions];
		{FractionCollectionMethod},
		{}
	];

	(* Make the test *)
	conflictFractionCollectionMethodTests = If[!MatchQ[conflictFractionCollectionMethodOptions, {}],
		testOrNull["All of the fraction collection options are in accordance with the FractionCollectionMethod:", False],
		testOrNull["All of the fraction collection options are in accordance with the FractionCollectionMethod:", True]
	];


	incompatibleFractionCollectionOptionsQ = Or @@ incompatibleFractionCollectionOptionsBool;

	incompatibleFractionCollectionAllOptions = If[incompatibleFractionCollectionOptionsQ && messagesQ && !engineQ,
		Message[Error::HPLCConflictingFractionCollectionOptions];
		Flatten[incompatibleFractionCollectionOptions],
		{}
	];

	(* Make the test *)
	incompatibleFractionCollectionTest = If[incompatibleFractionCollectionOptionsQ,
		testOrNull["All of the fraction collection options are compatible with the FractionCollectionMode:", False],
		testOrNull["All of the fraction collection options are compatible with the FractionCollectionMode:", True]
	];

	(* Perform Detector Conflict Checks and Option Resolution *)
	(* Note that we don't need to check the case that detector related options are populated while the instrument/detector cannot provide this detector. This was checked earlier in the main resolver. Also, we don't need to check that the options are set to a mixture of Null/un-Null, those are also checked in the main resolver. *)

	(* Conflict Check - If a detector is required, the related options cannot be set to Null *)
	pHRequiredOptions = {
		pHCalibration,
		pHTemperatureCompensation
	};
	conductivityRequiredOptions = {
		ConductivityCalibration,
		ConductivityTemperatureCompensation
	};
	fluorescenceRequiredOptions = {
		ExcitationWavelength,
		EmissionWavelength,
		FluorescenceGain,
		StandardExcitationWavelength,
		StandardEmissionWavelength,
		StandardFluorescenceGain,
		BlankExcitationWavelength,
		BlankEmissionWavelength,
		BlankFluorescenceGain,
		ColumnPrimeExcitationWavelength,
		ColumnPrimeEmissionWavelength,
		ColumnPrimeFluorescenceGain,
		ColumnFlushExcitationWavelength,
		ColumnFlushEmissionWavelength,
		ColumnFlushFluorescenceGain
	};
	dionexFluorescenceRequiredOptions = {
		EmissionCutOffFilter,
		FluorescenceFlowCellTemperature,
		StandardEmissionCutOffFilter,
		StandardFluorescenceFlowCellTemperature,
		BlankEmissionCutOffFilter,
		BlankFluorescenceFlowCellTemperature,
		ColumnPrimeEmissionCutOffFilter,
		ColumnPrimeFluorescenceFlowCellTemperature,
		ColumnFlushEmissionCutOffFilter,
		ColumnFlushFluorescenceFlowCellTemperature
	};
	lightScatteringRequiredOptions = {
		LightScatteringLaserPower,
		LightScatteringFlowCellTemperature,
		StandardLightScatteringLaserPower,
		StandardLightScatteringFlowCellTemperature,
		BlankLightScatteringLaserPower,
		BlankLightScatteringFlowCellTemperature,
		ColumnPrimeLightScatteringLaserPower,
		ColumnPrimeLightScatteringFlowCellTemperature,
		ColumnFlushLightScatteringLaserPower,
		ColumnFlushLightScatteringFlowCellTemperature
	};
	refractiveIndexRequiredOptions = {
		RefractiveIndexMethod,
		RefractiveIndexFlowCellTemperature,
		StandardRefractiveIndexMethod,
		StandardRefractiveIndexFlowCellTemperature,
		BlankRefractiveIndexMethod,
		BlankRefractiveIndexFlowCellTemperature,
		ColumnPrimeRefractiveIndexMethod,
		ColumnPrimeRefractiveIndexFlowCellTemperature,
		ColumnFlushRefractiveIndexMethod,
		ColumnFlushRefractiveIndexFlowCellTemperature
	};

	(* Depending on the resolved instrument, check whether it is UltiMate 3000 or not *)
	finalFluorescenceRequiredOptions = If[MatchQ[currentInstrumentModel, ObjectP[Model[Instrument, HPLC, "id:wqW9BP7BzwAG"]]],
		Join[fluorescenceRequiredOptions, dionexFluorescenceRequiredOptions],
		fluorescenceRequiredOptions
	];

	(* Check the Null options *)
	missingOptionsDetectorPairs = DeleteCases[
		MapThread[
			Function[
				{detector, options},
				(* Only check the options when the detector is selected *)
				If[MemberQ[resolvedDetector, detector],
					{
						detector,
						(* Track the option with Null members *)
						Map[
							If[MemberQ[ToList[Lookup[partiallyResolvedOptions, #]], Null],
								#,
								Nothing
							]&,
							options
						]
					},
					Nothing
				]
			],
			{{pH, Conductance, Fluorescence, MultiAngleLightScattering | DynamicLightScattering, RefractiveIndex}, {pHRequiredOptions, conductivityRequiredOptions, finalFluorescenceRequiredOptions, lightScatteringRequiredOptions, refractiveIndexRequiredOptions}}
		],
		(* Delete the detector with no invalid options *)
		{_, {}}
	];

	(* Separate the Detector and the invalid options for error tracking *)
	{missingOptionDetectors, missingDetectionOptions} = If[MatchQ[missingOptionsDetectorPairs, {}],
		{{}, {}},
		Transpose[missingOptionsDetectorPairs]
	];

	(* Throw error message and generate tests for every detector with invalid option. Here we do want to throw multiple message so it is clear for each detector *)
	missingDetectionOptionsTests = Map[
		If[!MatchQ[Last[#], {}],
			(
				If[messagesQ,
					Message[Error::MissingHPLCDetectorOptions, ToString[First[#]], ToString[Last[#]]]
				];
				testOrNull["The " <> ToString[First[#]] <> " detector related options " <> ToString[Last[#]] <> " are not set to Null when the detector is selected.", False]
			),
			testOrNull["The " <> ToString[First[#]] <> " detector related options are not set to Null when the detector is selected.", True]
		]&,
		missingOptionsDetectorPairs
	];

	(* pH and Conductivity Detector options *)
	resolvedpHTemperatureCompensation = Which[
		(* If pH is requested and user didn't specify the option pHCalibration, set it to True *)
		MatchQ[Lookup[partiallyResolvedOptions, pHTemperatureCompensation], Automatic] && MemberQ[resolvedDetector, pH], True,
		(* If pH is not requested, set to Null *)
		MatchQ[Lookup[partiallyResolvedOptions, pHTemperatureCompensation], Automatic], Null,
		True, Lookup[partiallyResolvedOptions, pHTemperatureCompensation]
	];

	resolvedConductivityTemperatureCompensation = Which[
		(* If Conductance is requested and user didn't specify the option ConductivityCalibration, set it to True *)
		MatchQ[Lookup[partiallyResolvedOptions, ConductivityTemperatureCompensation], Automatic] && MemberQ[resolvedDetector, Conductance], True,
		(* If Conductance is not requested, set to Null *)
		MatchQ[Lookup[partiallyResolvedOptions, ConductivityTemperatureCompensation], Automatic], Null,
		True, Lookup[partiallyResolvedOptions, ConductivityTemperatureCompensation]
	];


	(* SET UP Standar/Blank/Column related Options *)
	(* Do we have standard, blanks, primes, flushes, and columnms? *)
	columnsExistQ=MatchQ[resolvedColumnSelector, Except[{} | Null | {Null}]];

	{
		standardExistsQ,
		blankExistsQ,
		columnPrimeQ,
		columnFlushQ
	} = Map[
		Function[{type},
			MemberQ[resolvedInjectionTable, {type, ___}]
		],
		{
			Standard,
			Blank,
			ColumnPrime,
			ColumnFlush
		}
	];

	(* Define all of the options that we need *)
	standardOptions = {Standard, StandardGradient,
		StandardAbsorbanceWavelength, StandardWavelengthResolution, StandardUVFilter, StandardAbsorbanceSamplingRate,
		StandardExcitationWavelength, StandardEmissionWavelength, StandardEmissionCutOffFilter, StandardFluorescenceGain, StandardFluorescenceFlowCellTemperature,
		StandardLightScatteringLaserPower, StandardLightScatteringFlowCellTemperature, StandardRefractiveIndexMethod, StandardRefractiveIndexFlowCellTemperature,
		StandardNebulizerGas, StandardNebulizerGasHeating, StandardNebulizerHeatingPower, StandardNebulizerGasPressure, StandardDriftTubeTemperature, StandardELSDGain, StandardELSDSamplingRate};
	blankOptions = {Blank, BlankGradient,
		BlankAbsorbanceWavelength, BlankWavelengthResolution, BlankUVFilter, BlankAbsorbanceSamplingRate,
		BlankExcitationWavelength, BlankEmissionWavelength, BlankEmissionCutOffFilter, BlankFluorescenceGain, BlankFluorescenceFlowCellTemperature,
		BlankLightScatteringLaserPower, BlankLightScatteringFlowCellTemperature, BlankRefractiveIndexMethod, BlankRefractiveIndexFlowCellTemperature,
		BlankNebulizerGas, BlankNebulizerGasHeating, BlankNebulizerHeatingPower, BlankNebulizerGasPressure, BlankDriftTubeTemperature, BlankELSDGain, BlankELSDSamplingRate};
	columnOptions = {ColumnSelector, ColumnPrimeGradient, ColumnFlushGradient,
		ColumnPrimeAbsorbanceWavelength, ColumnPrimeWavelengthResolution, ColumnPrimeUVFilter, ColumnPrimeAbsorbanceSamplingRate,
		ColumnPrimeExcitationWavelength, ColumnPrimeEmissionWavelength, ColumnPrimeEmissionCutOffFilter, ColumnPrimeFluorescenceGain, ColumnPrimeFluorescenceFlowCellTemperature,
		ColumnPrimeLightScatteringLaserPower, ColumnPrimeLightScatteringFlowCellTemperature, ColumnPrimeRefractiveIndexMethod, ColumnPrimeRefractiveIndexFlowCellTemperature,
		ColumnPrimeNebulizerGas, ColumnPrimeNebulizerGasHeating, ColumnPrimeNebulizerHeatingPower, ColumnPrimeNebulizerGasPressure, ColumnPrimeDriftTubeTemperature, ColumnPrimeELSDGain, ColumnPrimeELSDSamplingRate,
		ColumnFlushAbsorbanceWavelength, ColumnFlushWavelengthResolution, ColumnFlushUVFilter, ColumnFlushAbsorbanceSamplingRate,
		ColumnFlushExcitationWavelength, ColumnFlushEmissionWavelength, ColumnFlushEmissionCutOffFilter, ColumnFlushFluorescenceGain, ColumnFlushFluorescenceFlowCellTemperature,
		ColumnFlushLightScatteringLaserPower, ColumnFlushLightScatteringFlowCellTemperature, ColumnFlushRefractiveIndexMethod, ColumnFlushRefractiveIndexFlowCellTemperature,
		ColumnFlushNebulizerGas, ColumnFlushNebulizerGasHeating, ColumnFlushNebulizerHeatingPower, ColumnFlushNebulizerGasPressure, ColumnFlushDriftTubeTemperature, ColumnFlushELSDGain, ColumnFlushELSDSamplingRate
	};
	columnPrimeOptions = Select[columnOptions, StringContainsQ[ToString[#], "ColumnPrime"]&];
	columnFlushOptions = Select[columnOptions, StringContainsQ[ToString[#], "ColumnFlush"]&];

	(* We need to expand all of the standard, blank, and column options as necessary *)
	expandedStandardOptions = If[!standardExistsQ,
		Association[# -> {}& /@ standardOptions],
		Last[ExpandIndexMatchedInputs[
			ExperimentHPLC,
			{mySamples},
			Normal@Append[
				KeyTake[partiallyResolvedOptions, standardOptions],
				Standard -> resolvedStandard
			],
			Messages -> False
		]]
	];

	expandedBlankOptions = If[!blankExistsQ,
		Association[# -> {}& /@ blankOptions],
		Last[ExpandIndexMatchedInputs[
			ExperimentHPLC,
			{mySamples},
			Normal@Append[
				KeyTake[partiallyResolvedOptions, blankOptions],
				Blank -> resolvedBlank
			],
			Messages -> False
		]]
	];

	preexpandedColumnOptions = If[!columnsExistQ,
		Association[# -> {}& /@ columnOptions],
		Last[ExpandIndexMatchedInputs[
			ExperimentHPLC,
			{mySamples},
			Normal@Append[
				KeyTake[partiallyResolvedOptions, columnOptions],
				ColumnSelector -> resolvedColumnSelector
			],
			Messages -> False
		]]
	];

	(* Take out individual prime or flushes *)
	expandedColumnOptions = Join[
		Association@preexpandedColumnOptions,
		If[!columnPrimeQ, Association[# -> {}& /@ columnPrimeOptions], Association[]],
		If[!columnFlushQ, Association[# -> {}& /@ columnFlushOptions], Association[]]
	];

	(* Look up the instrument manufacturer *)
	instrumentManufacturer = Lookup[currentInstrumentModelPacket, Manufacturer] /. x_Link :> Download[x, Object];
	(* Is it a waters instrument? This is used to distinguish the Agilent PDA and Waters PDA *)
	watersManufacturedQ = MatchQ[instrumentManufacturer, ObjectP[Object[Company, Supplier, "id:aXRlGnZmpK1v"]]];
	agilentManufacturedQ = MatchQ[instrumentManufacturer, ObjectP[Object[Company, Supplier, "id:M8n3rxYERoq5"]]];
	collectFractionsQ = Or@@Lookup[partiallyResolvedOptions, CollectFractions];

	(* Default unresolved autosampler temperature to room temperature on the waters, Null on dionex *)
	resolvedSampleTemperature = If[!MatchQ[Lookup[partiallyResolvedOptions, SampleTemperature], Automatic],
		Lookup[partiallyResolvedOptions, SampleTemperature],
		If[watersManufacturedQ,
			(* Only Waters allows SampleTemperature *)
			Ambient,
			Null
		]
	];

	(* Define the exact absorbance rate values that we can have *)
	possibleAbsorbanceRateValues = If[agilentManufacturedQ,
		{1.25 / (4 Second), 1.25 / (2 Second), 1.25 / Second, 2.5 * 1 / Second, 5 * 1 / Second, 10 * 1 / Second, 20 * 1 / Second, 40 * 1 / Second, 80 * 1 / Second, 120 * 1 / Second} * 1.,
		{1 / Second, 2 * 1 / Second, 5 * 1 / Second, 10 * 1 / Second, 20 * 1 / Second, 40 * 1 / Second, 80 * 1 / Second} * 1.
	];

	(* Define the possible resolutions for Waters instrument *)
	possibleWavelengthResolutions = {1.2 * Nanometer, 2.4 * Nanometer, 3.6 * Nanometer, 4.8 * Nanometer, 6.0 * Nanometer, 7.2 * Nanometer, 8.4 * Nanometer, 9.6 * Nanometer, 10.8 * Nanometer, 12.0 * Nanometer};

	(* Now do the photo diode array detector options *)
	{
		resolvedAbsorbanceWavelengths,
		resolvedWavelengthResolutions,
		resolvedUVFilters,
		resolvedAbsorbanceSamplingRates,
		wavelengthResolutionSampleConflictBool,
		roundedSamplingSampleRateBool,
		roundedWavelengthSampleResolutionBool,
		wavelengthFractionCollectionConflictBool
	} = Transpose@MapThread[
		Function[
			{absorbanceWavelength, wavelengthResolution, uvFilter, absorbanceSampleRate, fractionQ, analyteType, extinctionCoefficientWavelength},
			Module[
				{wavelengthResolutionConflictQ, roundedSamplingRateQ, roundedResolutionQ, wavelengthFractionCollectionConflictQ, resolvedAbsorbanceWavelength, resolvedWavelengthResolution, resolvedUVFilter, resolvedAbsorbanceSamplingRate},

				(* The absorbanceWavelength and UV filter just comes from the input options *)
				resolvedUVFilter = If[MatchQ[uvFilter, Except[Automatic]],
					uvFilter,
					If[MemberQ[resolvedDetector, PhotoDiodeArray]&&watersManufacturedQ, False, Null]
				];

				resolvedAbsorbanceWavelength = Which[
					(* Always accede to user specification *)
					MatchQ[absorbanceWavelength, Except[Automatic]], absorbanceWavelength,
					(* Check if a UV detector or PDA with fraction collection *)
					Or[
						MemberQ[resolvedDetector, UVVis],
						And[
							MemberQ[resolvedDetector, PhotoDiodeArray],
							TrueQ[fractionQ]
						]
					],
					Which[
						MatchQ[analyteType, DNA | Peptide | RNA | PNA], 260 Nanometer,
						MatchQ[analyteType, Protein], 280 Nanometer,
						!NullQ[extinctionCoefficientWavelength], extinctionCoefficientWavelength,
						True, 280 Nanometer
					],
					(* Otherwise check if has a PDA detector but not collecting fractions *)
					MemberQ[resolvedDetector, PhotoDiodeArray], All,
					True, Null
				];

				(* If we are collecting fractions but not given a single wavelength for collection, throw an error *)
				wavelengthFractionCollectionConflictQ=And[
					(* True for collection fractions *)
					TrueQ[fractionQ],
					(* True for using PDA/UVVis to collect fractions *)
					MatchQ[resolvedFractionCollectionDetector,(UVVis|PhotoDiodeArray)],
					(* If we are collecting fractions based on UVVis/PDA, we must have a single wavelength *)
					!MatchQ[resolvedAbsorbanceWavelength,DistanceP]
				];

				(* For the sampling rate, need to make sure that it's rounded to one of the sensible options *)
				{resolvedAbsorbanceSamplingRate, roundedSamplingRateQ} = Switch[absorbanceSampleRate,
					GreaterEqualP[0 * 1 / Second],
					(* If it's exact then we're okay *)
					If[Count[Abs[possibleAbsorbanceRateValues - absorbanceSampleRate], LessEqualP[0 * 1 / Second]] > 0,
						{absorbanceSampleRate, False},
						(* Otherwise, we need to find the closest value in our array *)
						{First@Nearest[possibleAbsorbanceRateValues, absorbanceSampleRate], True}
					],
					(* If Null, no problem here *)
					Null, {Null, False},
					(* Otherwise we resolve *)
					_,
					{
						If[Or[MemberQ[resolvedDetector, UVVis], MemberQ[resolvedDetector, PhotoDiodeArray]] && Or[watersManufacturedQ,agilentManufacturedQ], 20 / Second, Null],
						False
					}
				];

				(* The wavelength resolution needs to be resolved, and the errors must be checked *)
				{resolvedWavelengthResolution, wavelengthResolutionConflictQ, roundedResolutionQ} = Switch[{wavelengthResolution, resolvedAbsorbanceWavelength},
					(* Check if automatic, and if so depends on the absorbance wavelength *)
					{Automatic, _Span | All}, {1.2 Nanometer, False, False},
					{Automatic, GreaterP[0 * Nanometer]}, {Null, False, False},
					(* If no absorbance wavelength is available, set resolution to Null *)
					{Automatic, Null}, {Null, False, False},
					(* If it's set, we need to make sure copacetic *)
					{Null, _Span | All}, {Null, True, False},
					(* Need to round to one of the values potentially*)
					{GreaterP[0 * Nanometer], _},
					Which[
						(* Agilent allows WavelengthResolution to be anything with 0.1 nm rounding, which was done in the main resolver *)
						agilentManufacturedQ,
						{wavelengthResolution,MatchQ[resolvedAbsorbanceWavelength, GreaterP[0 * Nanometer]], False},
						Count[Abs[possibleWavelengthResolutions - wavelengthResolution], LessEqualP[0 * Nanometer]] > 0,
						(* We're good, but also need to make sure that resolvedAbsorbance wavelength isn't just a singelton *)
						{wavelengthResolution, MatchQ[resolvedAbsorbanceWavelength, GreaterP[0 * Nanometer]], False},
						(* Otherwise, we need to find the closest value in our array *)
						True,
						{First@MinimalBy[possibleWavelengthResolutions, Abs[# - wavelengthResolution]&], MatchQ[resolvedAbsorbanceWavelength, GreaterP[0 * Nanometer]], True}
					]
				];

				(* Return everything *)
				{
					resolvedAbsorbanceWavelength,
					resolvedWavelengthResolution,
					resolvedUVFilter,
					resolvedAbsorbanceSamplingRate,
					wavelengthResolutionConflictQ,
					roundedSamplingRateQ,
					roundedResolutionQ,
					wavelengthFractionCollectionConflictQ
				}
			]
		],
		Join[Lookup[partiallyResolvedOptions, {AbsorbanceWavelength, WavelengthResolution, UVFilter, AbsorbanceSamplingRate, CollectFractions}], {analyteTypes, extinctionCoefficientWavelengths}]
	];

	(* Now do all of the other options simultaneously *)
	{
		{
			resolvedStandardAbsorbanceWavelengths,
			resolvedStandardWavelengthResolutions,
			resolvedStandardUVFilters,
			resolvedStandardAbsorbanceSamplingRates,
			wavelengthResolutionStandardConflictBool,
			roundedSamplingStandardRateBool,
			roundedWavelengthStandardResolutionBool
		},
		{
			resolvedBlankAbsorbanceWavelengths,
			resolvedBlankWavelengthResolutions,
			resolvedBlankUVFilters,
			resolvedBlankAbsorbanceSamplingRates,
			wavelengthResolutionBlankConflictBool,
			roundedSamplingBlankRateBool,
			roundedWavelengthBlankResolutionBool
		},
		{
			resolvedColumnPrimeAbsorbanceWavelengths,
			resolvedColumnPrimeWavelengthResolutions,
			resolvedColumnPrimeUVFilters,
			resolvedColumnPrimeAbsorbanceSamplingRates,
			wavelengthResolutionColumnPrimeConflictBool,
			roundedSamplingColumnPrimeRateBool,
			roundedWavelengthColumnPrimeResolutionBool
		},
		{
			resolvedColumnFlushAbsorbanceWavelengths,
			resolvedColumnFlushWavelengthResolutions,
			resolvedColumnFlushUVFilters,
			resolvedColumnFlushAbsorbanceSamplingRates,
			wavelengthResolutionColumnFlushConflictBool,
			roundedSamplingColumnFlushRateBool,
			roundedWavelengthColumnFlushResolutionBool
		}
	} = Map[
		Function[
			{entry},
			Module[
				{absorbanceWavelengths, wavelengthResolutions, uvFilters, absorbanceSampleRates},

				(* Split the entry variable *)
				{absorbanceWavelengths, wavelengthResolutions, uvFilters, absorbanceSampleRates} = entry;

				(* First we check whether there is actually anything (i.e. no standards) *)
				If[MatchQ[{absorbanceWavelengths, wavelengthResolutions, uvFilters, absorbanceSampleRates}, {(Null | {})..}],
					(* In which case, we return all Null and empties *)
					{Sequence @@ ConstantArray[Null, 4], {}, {}, {}},
					(* Otherwise, we'll resolve the detector options and map through *)
					Transpose@MapThread[
						Function[
							{absorbanceWavelength, wavelengthResolution, uvFilter, absorbanceSampleRate},
							Module[
								{wavelengthResolutionConflictQ, roundedSamplingRateQ, roundedResolutionQ, resolvedAbsorbanceWavelength, resolvedWavelengthResolution, resolvedUVFilter, resolvedAbsorbanceSamplingRate},

								(* For most of these options we can just take it if specified, otherwise we default to the first resolution *)
								{
									resolvedUVFilter,
									resolvedAbsorbanceWavelength
								} = MapThread[
									Function[
										{currentOption, sampleOption},
										If[MatchQ[currentOption, Except[Automatic]],
											currentOption,
											First@sampleOption
										]
									],
									{
										{uvFilter, absorbanceWavelength},
										(* Just so that there is no confusion, the following are the already resolved options for the samples! *)
										{resolvedUVFilters, resolvedAbsorbanceWavelengths}
									}
								];

								(* For the sampling rate, need to make sure that it's rounded to one of the sensible options, if specified *)
								{resolvedAbsorbanceSamplingRate, roundedSamplingRateQ} = If[MatchQ[absorbanceSampleRate, Except[Automatic]],
									If[
										(* If it's exact then we're okay *)
										Count[Abs[possibleAbsorbanceRateValues - absorbanceSampleRate], LessEqualP[0 * 1 / Second]] > 0,
										{absorbanceSampleRate, False},
										(*otherwise, we need to find the closest value in our array*)
										{First@MinimalBy[possibleAbsorbanceRateValues, Abs[# - absorbanceSampleRate]&], True}
									],
									(* If automatic, take the first resolved*)
									{First@resolvedAbsorbanceSamplingRates, False}
								];

								(* The wavelength resolution needs to be resolved, and the errors must be checked *)
								{resolvedWavelengthResolution, wavelengthResolutionConflictQ, roundedResolutionQ} = Switch[{wavelengthResolution, resolvedAbsorbanceWavelength},
									(* Check if automatic, and if so depends on the absorbance wavelength *)
									{Automatic, _Span | All}, {First@resolvedWavelengthResolutions, False, False},
									{Automatic, GreaterP[0 * Nanometer]}, {Null, False, False},
									(* If no absorbance wavelength is available, set resolution to Null *)
									{Automatic, Null}, {Null, False, False},
									(* If it's set, we need to make sure copacetic *)
									{Null, _Span | All}, {Null, True, False},
									(* Need to round to one of the values potentially *)
									{GreaterP[0 * Nanometer], _},
									Which[
										(* Agilent allows WavelengthResolution to be anything with 0.1 nm rounding, which was done in the main resolver *)
										agilentManufacturedQ,
										{wavelengthResolution,MatchQ[resolvedAbsorbanceWavelength, GreaterP[0 * Nanometer]], False},
										   Count[Abs[possibleWavelengthResolutions - wavelengthResolution], LessEqualP[0 * Nanometer]] > 0,
										(* We're good, but also need to make sure that resolvedAbsorbance wavelength isn't just a singelton *)
										{wavelengthResolution, MatchQ[resolvedAbsorbanceWavelength, GreaterP[0 * Nanometer]], False},
										(* Otherwise, we need to find the closest value in our array *)
										True,
										{First@MinimalBy[possibleWavelengthResolutions, Abs[# - wavelengthResolution]&], MatchQ[resolvedAbsorbanceWavelength, GreaterP[0 * Nanometer]], True}
									]
								];

								(* Return everything *)
								{
									resolvedAbsorbanceWavelength,
									resolvedWavelengthResolution,
									resolvedUVFilter,
									resolvedAbsorbanceSamplingRate,
									wavelengthResolutionConflictQ,
									roundedSamplingRateQ,
									roundedResolutionQ
								}
							]
						],
						ToList /@ {absorbanceWavelengths, wavelengthResolutions, uvFilters, absorbanceSampleRates}
					]
				]
			]
		],
		{
			Lookup[expandedStandardOptions, {StandardAbsorbanceWavelength, StandardWavelengthResolution, StandardUVFilter, StandardAbsorbanceSamplingRate}],
			Lookup[expandedBlankOptions, {BlankAbsorbanceWavelength, BlankWavelengthResolution, BlankUVFilter, BlankAbsorbanceSamplingRate}],
			Lookup[expandedColumnOptions, {ColumnPrimeAbsorbanceWavelength, ColumnPrimeWavelengthResolution, ColumnPrimeUVFilter, ColumnPrimeAbsorbanceSamplingRate}],
			Lookup[expandedColumnOptions, {ColumnFlushAbsorbanceWavelength, ColumnFlushWavelengthResolution, ColumnFlushUVFilter, ColumnFlushAbsorbanceSamplingRate}]
		}
	];

	(* Do the error check from the option absorbance detector option resolution *)
	(* Define the absorbance sampling rate options *)
	absorbanceRateOptions = {AbsorbanceSamplingRate, StandardAbsorbanceSamplingRate, BlankAbsorbanceSamplingRate, ColumnPrimeAbsorbanceSamplingRate, ColumnFlushAbsorbanceSamplingRate};

	(* Find which options were offending *)
	roundedSamplingRateRoundingBool = (Or @@ #&) /@ {roundedSamplingSampleRateBool, roundedSamplingStandardRateBool, roundedSamplingBlankRateBool, roundedSamplingColumnPrimeRateBool, roundedSamplingColumnFlushRateBool};
	roundedSamplingRateRoundingOptions = PickList[absorbanceRateOptions, roundedSamplingRateRoundingBool];

	If[Length[roundedSamplingRateRoundingOptions] > 0 && messagesQ && !engineQ,
		Message[Warning::AbsorbanceRateAdjusted, ObjectToString[roundedSamplingRateRoundingOptions]]
	];

	wavelengthResolutionOptions = {WavelengthResolution, StandardWavelengthResolution, BlankWavelengthResolution, ColumnPrimeWavelengthResolution, ColumnFlushWavelengthResolution};

	(* Do the same with the WavelengthResolution *)
	roundedWavelengthResolutionBool = (Or @@ #&) /@ {roundedWavelengthSampleResolutionBool, roundedWavelengthStandardResolutionBool, roundedWavelengthBlankResolutionBool, roundedWavelengthColumnPrimeResolutionBool, roundedWavelengthColumnFlushResolutionBool};
	roundedWavelengthResolutionBoolOptions = PickList[wavelengthResolutionOptions, roundedWavelengthResolutionBool];

	If[Length[roundedWavelengthResolutionBoolOptions] > 0 && messagesQ && !engineQ,
		Message[Warning::WavelengthResolutionAdjusted, ObjectToString[roundedWavelengthResolutionBoolOptions]]
	];

	(* Check for a conflict between the wavelength resolution and absorbance wavelength *)
	wavelengthResolutionConflictBool = (Or @@ #&) /@ {wavelengthResolutionSampleConflictBool, wavelengthResolutionStandardConflictBool, wavelengthResolutionBlankConflictBool, wavelengthResolutionColumnPrimeConflictBool, wavelengthResolutionColumnFlushConflictBool};
	wavelengthResolutionConflictOptions = PickList[wavelengthResolutionOptions, wavelengthResolutionConflictBool];

	If[Length[wavelengthResolutionConflictOptions] > 0 && messagesQ,
		Message[Error::WavelengthResolutionConflict, ObjectToString[wavelengthResolutionConflictOptions]]
	];

	wavelengthResolutionConflictTests = If[Length[wavelengthResolutionConflictOptions] > 0,
		testOrNull["When AbsorbanceWavelength is a single value, the corresponding WavelengthResolution option must be left unspecified:", False],
		testOrNull["When AbsorbanceWavelength is a single value, the corresponding WavelengthResolution option must be left unspecified:", True]
	];

	(* Perform the FractionCollection + AbsorbanceWavelength check to make sure we know what wavelength to use for fraction collection *)

	wavelengthFractionCollectionConflictOptions=If[MemberQ[wavelengthFractionCollectionConflictBool,True] && messagesQ,
		Message[Error::FractionCollectionWavelengthConflict, ObjectToString[PickList[mySamples,wavelengthFractionCollectionConflictBool]]];{AbsorbanceWavelength},
		{}
	];

	wavelengthFractionCollectionConflictTests = If[Length[wavelengthFractionCollectionConflictOptions] > 0,
		testOrNull["When CollectFractions is True, the AbsorbanceWavelength must be a single wavelength value:", False],
		testOrNull["When CollectFractions is True, the AbsorbanceWavelength must be a single wavelength value:", True]
	];


	(* Resolve Fluorescence detector options and track errors *)
	(* Get the limit for the number of measurements. for now this is hard coded *)
	fluorescenceWavelengthLimit = 4;

	(* Get the maximum emission wavelength from the model of the analytes, if the field is empty, set it to null *)
	fluorescenceExcitationMaximums = Map[
		Function[{analyte},
			If[NullQ[analyte],
				analyte,
				Max[Lookup[fetchPacketFromCache[analyte, cache], FluorescenceExcitationMaximums] /. {} -> Null]
			]
		],
		possibleAnalytes
	];
	(* Get the maximum emission wavelength from the model of the analytes, if the field is empty, set it to Null *)
	fluorescenceEmissionMaximums = Map[
		Function[{analyte},
			If[NullQ[analyte],
				analyte,
				Max[Lookup[fetchPacketFromCache[analyte, cache], FluorescenceEmissionMaximums] /. {} -> Null]]
		],
		possibleAnalytes
	];

	(* Continue with the resolution *)
	{
		resolvedExcitationWavelength,
		resolvedEmissionWavelength,
		resolvedEmissionCutOffFilter,
		resolvedFluorescenceGain,
		resolvedFluorescenceFlowCellTemperature,
		wavelengthSwappedErrors,
		tooNarrowFluorescenceRangeErrors,
		conflictFluorescenceLengthErrors,
		tooManyFluorescenceWavelengthsErrors,
		invalidEmissionCutOffFilterErrors,
		tooLargeEmissionCutOffFilterErrors,
		invalidWatersFluorescenceGainErrors,
		invalidFluorescenceFlowCellTemperatureErrors
	} = Transpose[
		MapThread[
			Function[
				{excitationWavelength, emissionWavelength, emissionCutOffFilter, fluorescenceGain, fluorescenceFlowCellTemperature, maximumExcitationWavelength, maximumEmissionWavelength},
				Module[
					{
						resolvedSingleExcitationWavelength, resolvedSingleEmissionWavelength, resolvedSingleEmissionCutOffFilter, resolvedSingleFluorescenceGain, resolvedSingleFluorescenceFlowCellTemperature,
						wavelengthSwappedError, tooNarrowFluorescenceRangeError, conflictFluorescenceLengthError, tooManyFluorescenceWavelengthsError, invalidEmissionCutOffFilterError, tooLargeEmissionCutOffFilterError, invalidWatersFluorescenceGainError, invalidFluorescenceFlowCellTemperatureError
					},

					{wavelengthSwappedError, tooNarrowFluorescenceRangeError, conflictFluorescenceLengthError, tooManyFluorescenceWavelengthsError, invalidEmissionCutOffFilterError, tooLargeEmissionCutOffFilterError, invalidWatersFluorescenceGainError, invalidFluorescenceFlowCellTemperatureError} = ConstantArray[False, 8];

					(* Set Ex/Em from the provided values or automatically *)
					{resolvedSingleExcitationWavelength, resolvedSingleEmissionWavelength} = If[MemberQ[resolvedDetector, Fluorescence],
						Switch[
							{excitationWavelength, emissionWavelength},
							{Except[Automatic], Except[Automatic]}, {excitationWavelength, emissionWavelength},
							{Automatic, Null},
							If[NullQ[maximumExcitationWavelength],
								{485Nanometer, Null},
								{maximumExcitationWavelength, Null}
							],
							{Automatic, Except[Automatic]},
							If[NullQ[maximumExcitationWavelength],
								{emissionWavelength - 35Nanometer, emissionWavelength},
								{maximumExcitationWavelength, emissionWavelength}
							],
							{Null, Automatic},
							If[NullQ[maximumEmissionWavelength],
								{Null, 520Nanometer},
								{Null, maximumEmissionWavelength}
							],
							{Except[Automatic], Automatic},
							If[NullQ[maximumEmissionWavelength],
								{excitationWavelength, excitationWavelength + 35Nanometer},
								{excitationWavelength, maximumEmissionWavelength}
							],
							{Automatic, Automatic},
							Which[
								And[!NullQ[maximumExcitationWavelength], !NullQ[maximumEmissionWavelength]], {maximumExcitationWavelength, maximumEmissionWavelength},
								And[!NullQ[maximumExcitationWavelength], NullQ[maximumEmissionWavelength]], {maximumExcitationWavelength, 520Nanometer},
								And[NullQ[maximumExcitationWavelength], !NullQ[maximumEmissionWavelength]], {485Nanometer, maximumEmissionWavelength},
								True, {485Nanometer, 520Nanometer}
							]
						],
						Switch[
							{excitationWavelength, emissionWavelength},
							{Except[Automatic], Except[Automatic]}, {excitationWavelength, emissionWavelength},
							{Automatic, Except[Automatic]}, {Null, emissionWavelength},
							{Except[Automatic], Automatic}, {excitationWavelength, Null},
							{Automatic, Automatic}, {Null, Null}
						]
					];
					(* Resolve the Cut-Off Filter based on the provided value or the resolved Instrument *)
					resolvedSingleEmissionCutOffFilter = Which[
						!MatchQ[emissionCutOffFilter, Automatic], emissionCutOffFilter,
						(* Cut Off Filter is only available on UltiMate 3000 *)
						MemberQ[resolvedDetector, Fluorescence] && MatchQ[currentInstrumentModel, ObjectP[Model[Instrument, HPLC, "id:wqW9BP7BzwAG"]]], None,
						(* Set to Null otherwise *)
						True, Null
					];
					(* Resolve the Gain from the provided values or automatically *)
					resolvedSingleFluorescenceGain = Which[
						!MatchQ[fluorescenceGain, Automatic], fluorescenceGain,
						MemberQ[resolvedDetector, Fluorescence], 100 Percent, (* Changed to percent *)
						True, Null
					];
					resolvedSingleFluorescenceFlowCellTemperature = Which[
						!MatchQ[fluorescenceFlowCellTemperature, Automatic], fluorescenceFlowCellTemperature,
						(* Flow cell temperature control is only available on UltiMate 3000 *)
						MemberQ[resolvedDetector, Fluorescence] && MatchQ[currentInstrumentModel, ObjectP[Model[Instrument, HPLC, "id:wqW9BP7BzwAG"]]], 40Celsius,
						(* Set to Null otherwise *)
						True, Null
					];

					(* If Em/Ex/Gain are not at the same length, track the error *)
					conflictFluorescenceLengthError = If[MemberQ[resolvedDetector, Fluorescence],
						!And[
							(* Ex/Em must be the same length *)
							SameLengthQ[ToList[resolvedSingleExcitationWavelength], ToList[resolvedSingleEmissionWavelength]],
							(* Gain can be a single value - constant or the same length with Ex/Em *)
							Or[
								MatchQ[resolvedSingleFluorescenceGain, GreaterEqualP[0]],
								SameLengthQ[ToList[resolvedSingleExcitationWavelength], ToList[resolvedSingleFluorescenceGain]]
							]
						],
						False
					];

					(* Track the error for more than 4 wavelength. Only do this when there is no length conflict to avoid giving too many errors *)
					tooManyFluorescenceWavelengthsError = If[MemberQ[resolvedDetector, Fluorescence] && !conflictFluorescenceLengthError,
						TrueQ[Length[ToList[resolvedSingleExcitationWavelength]] > 4],
						False
					];

					(* If Em is smaller than Ex in any combination, track the error *)
					wavelengthSwappedError = If[MemberQ[resolvedDetector, Fluorescence] && !conflictFluorescenceLengthError,
						And @@ MapThread[
							TrueQ[#1 >= #2]&,
							{ToList[resolvedSingleExcitationWavelength], ToList[resolvedSingleEmissionWavelength]}
						],
						False
					];

					(* If Ex/Em are too narrow apart <20 nm for Dionex, track the error *)
					tooNarrowFluorescenceRangeError = If[MemberQ[resolvedDetector, Fluorescence] && !conflictFluorescenceLengthError && MatchQ[currentInstrumentModel, ObjectP[Model[Instrument, HPLC, "id:wqW9BP7BzwAG"]]],
						And @@ MapThread[
							And[
								TrueQ[#1 < #2],
								TrueQ[#1 > #2 - 20Nanometer]
							]&,
							{ToList[resolvedSingleExcitationWavelength], ToList[resolvedSingleEmissionWavelength]}
						],
						False
					];

					(* If EmissionCutOffFilter is not available on the instrument, it cannot be specified *)
					invalidEmissionCutOffFilterError = MemberQ[resolvedDetector, Fluorescence] && !MatchQ[currentInstrumentModel, ObjectP[Model[Instrument, HPLC, "id:wqW9BP7BzwAG"]]] && !NullQ[resolvedSingleEmissionCutOffFilter];

					(* If the EmissionCutOffFilter is too large - larger than Em, track the error *)
					tooLargeEmissionCutOffFilterError = If[MemberQ[resolvedDetector, Fluorescence] && !MatchQ[resolvedSingleEmissionCutOffFilter, None | Null],
						TrueQ[resolvedSingleEmissionCutOffFilter > Max[resolvedSingleEmissionWavelength]],
						False
					];

					(* If Waters is used, fluorescence gain can only be constant even if multiple channels are selected *)
					invalidWatersFluorescenceGainError = If[MemberQ[resolvedDetector, Fluorescence] && !NullQ[resolvedSingleFluorescenceGain] && MatchQ[currentInstrumentModel, ObjectP[Model[Instrument, HPLC, "Waters Acquity UPLC H-Class FLR"]]],
						TrueQ[Length[DeleteDuplicates[ToList[resolvedSingleFluorescenceGain]]] > 1],
						False
					];

					(* Flow cell temperature can only be set for UltiMate 3000 *)
					invalidFluorescenceFlowCellTemperatureError = MemberQ[resolvedDetector, Fluorescence] && !MatchQ[currentInstrumentModel, ObjectP[Model[Instrument, HPLC, "id:wqW9BP7BzwAG"]]] && !MatchQ[resolvedSingleFluorescenceFlowCellTemperature, Ambient | Null];

					(* Return everything *)
					{
						resolvedSingleExcitationWavelength, resolvedSingleEmissionWavelength, resolvedSingleEmissionCutOffFilter, resolvedSingleFluorescenceGain, resolvedSingleFluorescenceFlowCellTemperature,
						wavelengthSwappedError, tooNarrowFluorescenceRangeError, conflictFluorescenceLengthError, tooManyFluorescenceWavelengthsError, invalidEmissionCutOffFilterError, tooLargeEmissionCutOffFilterError, invalidWatersFluorescenceGainError, invalidFluorescenceFlowCellTemperatureError
					}
				]
			],
			Join[Lookup[partiallyResolvedOptions, {ExcitationWavelength, EmissionWavelength, EmissionCutOffFilter, FluorescenceGain, FluorescenceFlowCellTemperature}], {fluorescenceExcitationMaximums, fluorescenceEmissionMaximums}]
		]
	];

	(* Now do all of the other fluorescence options simultaneously *)
	{
		{
			resolvedStandardExcitationWavelength,
			resolvedStandardEmissionWavelength,
			resolvedStandardEmissionCutOffFilter,
			resolvedStandardFluorescenceGain,
			resolvedStandardFluorescenceFlowCellTemperature,
			standardWavelengthSwappedErrors,
			standardTooNarrowFluorescenceRangeErrors,
			standardConflictFluorescenceLengthErrors,
			standardTooManyFluorescenceWavelengthsErrors,
			standardInvalidEmissionCutOffFilterErrors,
			standardTooLargeEmissionCutOffFilterErrors,
			standardInvalidWatersFluorescenceGainErrors,
			standardInvalidFluorescenceFlowCellTemperatureErrors
		},
		{
			resolvedBlankExcitationWavelength,
			resolvedBlankEmissionWavelength,
			resolvedBlankEmissionCutOffFilter,
			resolvedBlankFluorescenceGain,
			resolvedBlankFluorescenceFlowCellTemperature,
			blankWavelengthSwappedErrors,
			blankTooNarrowFluorescenceRangeErrors,
			blankConflictFluorescenceLengthErrors,
			blankTooManyFluorescenceWavelengthsErrors,
			blankInvalidEmissionCutOffFilterErrors,
			blankTooLargeEmissionCutOffFilterErrors,
			blankInvalidWatersFluorescenceGainErrors,
			blankInvalidFluorescenceFlowCellTemperatureErrors
		},
		{
			resolvedColumnPrimeExcitationWavelength,
			resolvedColumnPrimeEmissionWavelength,
			resolvedColumnPrimeEmissionCutOffFilter,
			resolvedColumnPrimeFluorescenceGain,
			resolvedColumnPrimeFluorescenceFlowCellTemperature,
			columnPrimeWavelengthSwappedErrors,
			columnPrimeTooNarrowFluorescenceRangeErrors,
			columnPrimeConflictFluorescenceLengthErrors,
			columnPrimeTooManyFluorescenceWavelengthsErrors,
			columnPrimeInvalidEmissionCutOffFilterErrors,
			columnPrimeTooLargeEmissionCutOffFilterErrors,
			columnPrimeInvalidWatersFluorescenceGainErrors,
			columnPrimeInvalidFluorescenceFlowCellTemperatureErrors
		},
		{
			resolvedColumnFlushExcitationWavelength,
			resolvedColumnFlushEmissionWavelength,
			resolvedColumnFlushEmissionCutOffFilter,
			resolvedColumnFlushFluorescenceGain,
			resolvedColumnFlushFluorescenceFlowCellTemperature,
			columnFlushWavelengthSwappedErrors,
			columnFlushTooNarrowFluorescenceRangeErrors,
			columnFlushConflictFluorescenceLengthErrors,
			columnFlushTooManyFluorescenceWavelengthsErrors,
			columnFlushInvalidEmissionCutOffFilterErrors,
			columnFlushTooLargeEmissionCutOffFilterErrors,
			columnFlushInvalidWatersFluorescenceGainErrors,
			columnFlushInvalidFluorescenceFlowCellTemperatureErrors
		}
	} = MapThread[
		Function[{entry, bool},
			If[bool,
				(* Only do the resolution when the option exists *)
				Transpose[
					MapThread[
						Function[
							{excitationWavelength, emissionWavelength, emissionCutOffFilter, fluorescenceGain, fluorescenceFlowCellTemperature},
							Module[
								{
									resolvedSingleExcitationWavelength, resolvedSingleEmissionWavelength, resolvedSingleEmissionCutOffFilter, resolvedSingleFluorescenceGain, resolvedSingleFluorescenceFlowCellTemperature,
									wavelengthSwappedError, tooNarrowFluorescenceRangeError, conflictFluorescenceLengthError, tooManyFluorescenceWavelengthsError, invalidEmissionCutOffFilterError, tooLargeEmissionCutOffFilterError, invalidWatersFluorescenceGainError, invalidFluorescenceFlowCellTemperatureError
								},

								{wavelengthSwappedError, tooNarrowFluorescenceRangeError, conflictFluorescenceLengthError, tooManyFluorescenceWavelengthsError, invalidEmissionCutOffFilterError, tooLargeEmissionCutOffFilterError, invalidWatersFluorescenceGainError, invalidFluorescenceFlowCellTemperatureError} = ConstantArray[False, 8];

								(* Set Ex/Em from the provided values or automatically *)
								{resolvedSingleExcitationWavelength, resolvedSingleEmissionWavelength} = If[MemberQ[resolvedDetector, Fluorescence],
									Which[
										MatchQ[{excitationWavelength, emissionWavelength}, {Except[Automatic], Except[Automatic]}], {excitationWavelength, emissionWavelength},
										(* To avoid Ex/Em length/value conflict, set from the provided value instead of the first pair for samples *)
										MatchQ[{excitationWavelength, emissionWavelength}, {Automatic, Null}], {485Nanometer, Null},
										MatchQ[{excitationWavelength, emissionWavelength}, {Automatic, Except[Automatic]}], {emissionWavelength - 35Nanometer, emissionWavelength},
										MatchQ[{excitationWavelength, emissionWavelength}, {Null, Automatic}], {Null, 520Nanometer},
										MatchQ[{excitationWavelength, emissionWavelength}, {Except[Automatic], Automatic}], {excitationWavelength, excitationWavelength + 35Nanometer},
										(* Set to the first pair in samples for samples if they are valid *)
										MatchQ[{excitationWavelength, emissionWavelength}, {Automatic, Automatic}] && !First[wavelengthSwappedErrors] && !First[tooNarrowFluorescenceRangeErrors] && !First[conflictFluorescenceLengthErrors] && !First[tooManyFluorescenceWavelengthsErrors], {First[resolvedExcitationWavelength], First[resolvedEmissionWavelength]},
										True, {485Nanometer, 520Nanometer}
									],
									Switch[
										{excitationWavelength, emissionWavelength},
										{Except[Automatic], Except[Automatic]}, {excitationWavelength, emissionWavelength},
										{Automatic, Except[Automatic]}, {Null, emissionWavelength},
										{Except[Automatic], Automatic}, {excitationWavelength, Null},
										{Automatic, Automatic}, {Null, Null}
									]
								];
								(* Resolve the Cut-Off Filter based on the provided value or the resolved Instrument *)
								resolvedSingleEmissionCutOffFilter = Which[
									!MatchQ[emissionCutOffFilter, Automatic], emissionCutOffFilter,
									(* Cut Off Filter is only available on UltiMate 3000 *)
									(* Set to the first member of the EmissionCutOffFilter if it is not larger than our resolvedSingleEmissionWavelength *)
									MemberQ[resolvedDetector, Fluorescence] && MatchQ[currentInstrumentModel, ObjectP[Model[Instrument, HPLC, "id:wqW9BP7BzwAG"]]] && !MatchQ[First[resolvedEmissionCutOffFilter], None | Null],
									If[TrueQ[First[resolvedEmissionCutOffFilter] >= Max[resolvedSingleEmissionWavelength]],
										None,
										First[resolvedEmissionCutOffFilter]
									],
									MemberQ[resolvedDetector, Fluorescence] && MatchQ[currentInstrumentModel, ObjectP[Model[Instrument, HPLC, "id:wqW9BP7BzwAG"]]], None,
									(* Set to Null otherwise *)
									True, Null
								];
								(* Resolve the Gain from the provided values or automatically *)
								resolvedSingleFluorescenceGain = Which[
									!MatchQ[fluorescenceGain, Automatic], fluorescenceGain,
									MemberQ[resolvedDetector, Fluorescence], 100 Percent,
									True, Null
								];
								(* Resolve the flow cell temperature based on the provided value or the resolved Instrument *)
								resolvedSingleFluorescenceFlowCellTemperature = Which[
									!MatchQ[fluorescenceFlowCellTemperature, Automatic], fluorescenceFlowCellTemperature,
									(* Flow cell temperature control is only available on UltiMate 3000 *)
									MemberQ[resolvedDetector, Fluorescence] && MatchQ[currentInstrumentModel, ObjectP[Model[Instrument, HPLC, "id:wqW9BP7BzwAG"]]] && !NullQ[First[resolvedFluorescenceFlowCellTemperature]], First[resolvedFluorescenceFlowCellTemperature],
									MemberQ[resolvedDetector, Fluorescence] && MatchQ[currentInstrumentModel, ObjectP[Model[Instrument, HPLC, "id:wqW9BP7BzwAG"]]], Ambient,
									(* Set to Null otherwise *)
									True, Null
								];

								(* If Em/Ex/Gain are not at the same length, track the error *)
								conflictFluorescenceLengthError = If[MemberQ[resolvedDetector, Fluorescence],
									!And[
										(* Ex/Em must be the same length *)
										SameLengthQ[ToList[resolvedSingleExcitationWavelength], ToList[resolvedSingleEmissionWavelength]],
										(* Gain can be a single value - constant or the same length with Ex/Em *)
										Or[
											MatchQ[resolvedSingleFluorescenceGain, GreaterEqualP[0]],
											SameLengthQ[ToList[resolvedSingleExcitationWavelength], ToList[resolvedSingleFluorescenceGain]]
										]
									],
									False
								];

								(* Track the error for more than 4 wavelength. Only do this when there is no length conflict to avoid giving too many errors *)
								tooManyFluorescenceWavelengthsError = If[MemberQ[resolvedDetector, Fluorescence] && !conflictFluorescenceLengthError,
									TrueQ[Length[ToList[resolvedSingleExcitationWavelength]] > 4],
									False
								];

								(* If Em is smaller than Ex in any combination, track the error *)
								wavelengthSwappedError = If[MemberQ[resolvedDetector, Fluorescence] && !conflictFluorescenceLengthError,
									And @@ MapThread[
										TrueQ[#1 >= #2]&,
										{ToList[resolvedSingleExcitationWavelength], ToList[resolvedSingleEmissionWavelength]}
									],
									False
								];

								(* If Ex/Em are too narrow apart <20 nm for Dionex, track the error *)
								tooNarrowFluorescenceRangeError = If[MemberQ[resolvedDetector, Fluorescence] && !conflictFluorescenceLengthError && MatchQ[currentInstrumentModel, ObjectP[Model[Instrument, HPLC, "id:wqW9BP7BzwAG"]]],
									And @@ MapThread[
										And[
											TrueQ[#1 < #2],
											TrueQ[#1 > #2 - 20Nanometer]
										]&,
										{ToList[resolvedSingleExcitationWavelength], ToList[resolvedSingleEmissionWavelength]}
									],
									False
								];

								(* If EmissionCutOffFilter is not available on the instrument, it cannot be specified *)
								invalidEmissionCutOffFilterError = MemberQ[resolvedDetector, Fluorescence] && !MatchQ[currentInstrumentModel, ObjectP[Model[Instrument, HPLC, "id:wqW9BP7BzwAG"]]] && !NullQ[resolvedSingleEmissionCutOffFilter];

								(* If the EmissionCutOffFilter is too large - larger than Em, track the error *)
								tooLargeEmissionCutOffFilterError = If[MemberQ[resolvedDetector, Fluorescence] && !MatchQ[resolvedSingleEmissionCutOffFilter, None | Null],
									TrueQ[resolvedSingleEmissionCutOffFilter > Max[resolvedSingleEmissionWavelength]],
									False
								];

								(* If Waters is used, fluorescence gain can only be constant even if multiple channels are selected *)
								invalidWatersFluorescenceGainError = If[MemberQ[resolvedDetector, Fluorescence] && !NullQ[resolvedSingleFluorescenceGain] && MatchQ[currentInstrumentModel, ObjectP[Model[Instrument, HPLC, "Waters Acquity UPLC H-Class FLR"]]],
									TrueQ[Length[DeleteDuplicates[ToList[resolvedSingleFluorescenceGain]]] > 1],
									False
								];

								(* Flow cell temperature can only be set for UltiMate 3000 *)
								invalidFluorescenceFlowCellTemperatureError = MemberQ[resolvedDetector, Fluorescence] && !MatchQ[currentInstrumentModel, ObjectP[Model[Instrument, HPLC, "id:wqW9BP7BzwAG"]]] && !MatchQ[resolvedSingleFluorescenceFlowCellTemperature, Ambient | Null];

								(* Return everything *)
								{
									resolvedSingleExcitationWavelength, resolvedSingleEmissionWavelength, resolvedSingleEmissionCutOffFilter, resolvedSingleFluorescenceGain, resolvedSingleFluorescenceFlowCellTemperature,
									wavelengthSwappedError, tooNarrowFluorescenceRangeError, conflictFluorescenceLengthError, tooManyFluorescenceWavelengthsError, invalidEmissionCutOffFilterError, tooLargeEmissionCutOffFilterError, invalidWatersFluorescenceGainError, invalidFluorescenceFlowCellTemperatureError
								}
							]
						],
						entry
					]
				],
				(* When there is no index matching parent, go with Null or what user specifies *)
				Join[
					Map[
						If[MatchQ[#, Automatic | {}],
							Null,
							#
						]&,
						entry
					],
					ConstantArray[{}, 8]
				]
			]
		],
		{
			{
				Lookup[expandedStandardOptions, {StandardExcitationWavelength, StandardEmissionWavelength, StandardEmissionCutOffFilter, StandardFluorescenceGain, StandardFluorescenceFlowCellTemperature}],
				Lookup[expandedBlankOptions, {BlankExcitationWavelength, BlankEmissionWavelength, BlankEmissionCutOffFilter, BlankFluorescenceGain, BlankFluorescenceFlowCellTemperature}],
				Lookup[expandedColumnOptions, {ColumnPrimeExcitationWavelength, ColumnPrimeEmissionWavelength, ColumnPrimeEmissionCutOffFilter, ColumnPrimeFluorescenceGain, ColumnPrimeFluorescenceFlowCellTemperature}],
				Lookup[expandedColumnOptions, {ColumnFlushExcitationWavelength, ColumnFlushEmissionWavelength, ColumnFlushEmissionCutOffFilter, ColumnFlushFluorescenceGain, ColumnFlushFluorescenceFlowCellTemperature}]
			},
			{
				standardExistsQ,
				blankExistsQ,
				columnPrimeQ,
				columnFlushQ
			}
		}
	];

	(* Resolve MALS/DLS detector options and track errors *)
	{
		resolvedLightScatteringLaserPower,
		resolvedLightScatteringFlowCellTemperature
	} = Transpose[
		MapThread[
			Function[
				{laserPower, temp},
				Module[
					{
						resolvedSingleLightScatteringLaserPower, resolvedSingleLightScatteringFlowCellTemperature
					},

					resolvedSingleLightScatteringLaserPower = Which[
						(* Always accede to user specification *)
						MatchQ[laserPower, Except[Automatic]], laserPower,
						(* Set to 100% if MALS/DLS is requested *)
						MemberQ[resolvedDetector, MultiAngleLightScattering | DynamicLightScattering], 100Percent,
						(* Otherwise just set to Null *)
						True, Null
					];

					resolvedSingleLightScatteringFlowCellTemperature = Which[
						(* Always accede to user specification *)
						MatchQ[temp, Except[Automatic]], temp,
						(* Set to Ambient if MALS/DLS is requested *)
						MemberQ[resolvedDetector, MultiAngleLightScattering | DynamicLightScattering], Ambient,
						(* Otherwise just set to Null *)
						True, Null
					];

					(* Return everything *)
					{
						resolvedSingleLightScatteringLaserPower, resolvedSingleLightScatteringFlowCellTemperature
					}
				]
			],
			Lookup[partiallyResolvedOptions, {LightScatteringLaserPower, LightScatteringFlowCellTemperature}]
		]
	];

	(* Resolve other MALS/DLS detector options *)
	{
		{
			resolvedStandardLightScatteringLaserPower,
			resolvedStandardLightScatteringFlowCellTemperature
		},
		{
			resolvedBlankLightScatteringLaserPower,
			resolvedBlankLightScatteringFlowCellTemperature
		},
		{
			resolvedColumnPrimeLightScatteringLaserPower,
			resolvedColumnPrimeLightScatteringFlowCellTemperature
		},
		{
			resolvedColumnFlushLightScatteringLaserPower,
			resolvedColumnFlushLightScatteringFlowCellTemperature
		}
	} = MapThread[
		Function[{entry, bool},
			If[bool,
				(* Only do the resolution when the option exists *)
				Transpose[
					MapThread[
						Function[
							{laserPower, temp},
							Module[
								{
									resolvedSingleLightScatteringLaserPower, resolvedSingleLightScatteringFlowCellTemperature
								},

								resolvedSingleLightScatteringLaserPower = Which[
									(* Always accede to user specification *)
									MatchQ[laserPower, Except[Automatic]], laserPower,
									(* Set to the first resolved value for the samples *)
									MemberQ[resolvedDetector, MultiAngleLightScattering | DynamicLightScattering], First[resolvedLightScatteringLaserPower],
									(* Otherwise just set to Null *)
									True, Null
								];

								resolvedSingleLightScatteringFlowCellTemperature = Which[
									(* Always accede to user specification *)
									MatchQ[temp, Except[Automatic]], temp,
									(* Set to the first resolved value for the samples *)
									MemberQ[resolvedDetector, MultiAngleLightScattering | DynamicLightScattering], First[resolvedLightScatteringFlowCellTemperature],
									(* Otherwise just set to Null *)
									True, Null
								];

								(* Return everything *)
								{
									resolvedSingleLightScatteringLaserPower, resolvedSingleLightScatteringFlowCellTemperature
								}
							]
						],
						entry
					]
				],
				(* When there is no index matching parent, go with Null or what user specifies *)
				Map[
					If[MatchQ[#, Automatic | {}],
						Null,
						#
					]&,
					entry
				]
			]
		],
		{
			{
				Lookup[expandedStandardOptions, {StandardLightScatteringLaserPower, StandardLightScatteringFlowCellTemperature}],
				Lookup[expandedBlankOptions, {BlankLightScatteringLaserPower, BlankLightScatteringFlowCellTemperature}],
				Lookup[expandedColumnOptions, {ColumnPrimeLightScatteringLaserPower, ColumnPrimeLightScatteringFlowCellTemperature}],
				Lookup[expandedColumnOptions, {ColumnFlushLightScatteringLaserPower, ColumnFlushLightScatteringFlowCellTemperature}]
			},
			{
				standardExistsQ,
				blankExistsQ,
				columnPrimeQ,
				columnFlushQ
			}
		}
	];


	(* Resolve Refractive Index detector options and track errors *)
	{
		resolvedRefractiveIndexMethod,
		resolvedRefractiveIndexFlowCellTemperature,
		refractiveIndexMethodConflictErrors
	} = Transpose[
		MapThread[
			Function[
				{riMethod, temp, gradient},
				Module[
					{
						resolvedSingleRefractiveIndexMethod, resolvedSingleRefractiveIndexFlowCellTemperature, gradientPacket, gradientReferenceLoadingStatus, gradientReferenceLoadingClosedQ, refractiveIndexMethodConflictError
					},

					(* Check whether the reference loading is closed during any stage of the gradient *)
					gradientPacket = If[MatchQ[gradient, ObjectP[Object[Method, Gradient]]],
						fetchPacketFromCacheHPLC[gradient, cache],
						<||>
					];

					(* Get the reference open/closed status - If it is ever closed, go with DifferentialRefractiveIndex *)
					gradientReferenceLoadingStatus = If[MatchQ[gradient, ObjectP[Object[Method, Gradient]]],
						Lookup[gradientPacket, RefractiveIndexReferenceLoading, {}],
						gradient[[All, -1]]
					];
					gradientReferenceLoadingClosedQ = MemberQ[gradientReferenceLoadingStatus, Closed];

					resolvedSingleRefractiveIndexMethod = Which[
						(* Always accede to user specification *)
						MatchQ[riMethod, Except[Automatic]], riMethod,
						(* If the reference loading is ever closed *)
						MemberQ[resolvedDetector, RefractiveIndex] && gradientReferenceLoadingClosedQ, DifferentialRefractiveIndex,
						MemberQ[resolvedDetector, RefractiveIndex], RefractiveIndex,
						(* Otherwise just set to Null *)
						True, Null
					];

					resolvedSingleRefractiveIndexFlowCellTemperature = Which[
						(* Always accede to user specification *)
						MatchQ[temp, Except[Automatic]], temp,
						(* Set to Ambient if RI detector is used *)
						MemberQ[resolvedDetector, RefractiveIndex], Ambient,
						(* Otherwise just set to Null *)
						True, Null
					];

					(* If the reference loading is always open but DifferentialRefractiveIndex is requested, we need to return error *)
					refractiveIndexMethodConflictError = !gradientReferenceLoadingClosedQ && MatchQ[resolvedSingleRefractiveIndexMethod, DifferentialRefractiveIndex];

					(* Return everything *)
					{
						resolvedSingleRefractiveIndexMethod, resolvedSingleRefractiveIndexFlowCellTemperature, refractiveIndexMethodConflictError
					}
				]
			],
			Lookup[partiallyResolvedOptions, {RefractiveIndexMethod, RefractiveIndexFlowCellTemperature, Gradient}]
		]
	];

	(* Resolve other MALS/DLS detector options *)
	{
		{
			resolvedStandardRefractiveIndexMethod,
			resolvedStandardRefractiveIndexFlowCellTemperature,
			standardRefractiveIndexMethodConflictErrors
		},
		{
			resolvedBlankRefractiveIndexMethod,
			resolvedBlankRefractiveIndexFlowCellTemperature,
			blankRefractiveIndexMethodConflictErrors
		},
		{
			resolvedColumnPrimeRefractiveIndexMethod,
			resolvedColumnPrimeRefractiveIndexFlowCellTemperature,
			columnPrimeRefractiveIndexMethodConflictErrors
		},
		{
			resolvedColumnFlushRefractiveIndexMethod,
			resolvedColumnFlushRefractiveIndexFlowCellTemperature,
			columnFlushRefractiveIndexMethodConflictErrors
		}
	} = MapThread[
		Function[{entry, bool},
			If[bool,
				(* Only do the resolution when the option exists *)
				Transpose[
					MapThread[
						Function[
							{riMethod, temp, gradient},
							Module[
								{
									resolvedSingleRefractiveIndexMethod, resolvedSingleRefractiveIndexFlowCellTemperature, gradientPacket, gradientReferenceLoadingStatus, gradientReferenceLoadingClosedQ, refractiveIndexMethodConflictError
								},

								(* Check whether the reference loading is closed during any stage of the gradient *)
								gradientPacket = If[MatchQ[gradient, ObjectP[Object[Method, Gradient]]],
									fetchPacketFromCacheHPLC[gradient, cache],
									<||>
								];

								(* Get the reference open/closed status - If it is ever closed, go with DifferentialRefractiveIndex *)
								gradientReferenceLoadingStatus = If[MatchQ[gradient, ObjectP[Object[Method, Gradient]]],
									Lookup[gradientPacket, Gradient, {}][[All, -1]],
									gradient[[All, -1]]
								];
								gradientReferenceLoadingClosedQ = MemberQ[DifferentialRefractiveIndex, Closed];

								resolvedSingleRefractiveIndexMethod = Which[
									(* Always accede to user specification *)
									MatchQ[riMethod, Except[Automatic]], riMethod,
									(* If the reference loading is ever closed *)
									MemberQ[resolvedDetector, RefractiveIndex] && gradientReferenceLoadingClosedQ, DifferentialRefractiveIndex,
									MemberQ[resolvedDetector, RefractiveIndex], RefractiveIndex,
									(* Otherwise just set to Null *)
									True, Null
								];

								resolvedSingleRefractiveIndexFlowCellTemperature = Which[
									(* Always accede to user specification *)
									MatchQ[temp, Except[Automatic]], temp,
									(* Set to Ambient if RI detector is used *)
									MemberQ[resolvedDetector, RefractiveIndex], First[resolvedRefractiveIndexFlowCellTemperature],
									(* Otherwise just set to Null *)
									True, Null
								];

								(* If the reference loading is always open but DifferentialRefractiveIndex is requested, we need to return error *)
								refractiveIndexMethodConflictError = !gradientReferenceLoadingClosedQ && MatchQ[resolvedSingleRefractiveIndexMethod, DifferentialRefractiveIndex];

								(* Return everything *)
								{
									resolvedSingleRefractiveIndexMethod, resolvedSingleRefractiveIndexFlowCellTemperature, refractiveIndexMethodConflictError
								}
							]
						],
						entry
					]
				],
				(* When there is no index matching parent, go with Null or what user specifies *)
				Append[
					Map[
						If[MatchQ[#, Automatic | {}],
							Null,
							#
						]&,
						Most[entry]
					],
					(* Add an empty list for error tracking booleans *)
					{}
				]
			]
		],
		{
			{
				Lookup[expandedStandardOptions, {StandardRefractiveIndexMethod, StandardRefractiveIndexFlowCellTemperature, StandardGradient}],
				Lookup[expandedBlankOptions, {BlankRefractiveIndexMethod, BlankRefractiveIndexFlowCellTemperature, BlankGradient}],
				Lookup[expandedColumnOptions, {ColumnPrimeRefractiveIndexMethod, ColumnPrimeRefractiveIndexFlowCellTemperature, ColumnPrimeGradient}],
				Lookup[expandedColumnOptions, {ColumnFlushRefractiveIndexMethod, ColumnFlushRefractiveIndexFlowCellTemperature, ColumnFlushGradient}]
			},
			{
				standardExistsQ,
				blankExistsQ,
				columnPrimeQ,
				columnFlushQ
			}
		}
	];


	(* ELSD NebulizerGas options. These need to be resolved together given the interdependencies *)
	{resolvedNebulizerGas, resolvedNebulizerGasHeating, resolvedNebulizerHeatingPower, resolvedNebulizerGasPressure} = Transpose@MapThread[
		Function[{nebulizerGas, gasHeating, heatingPower, gasPressure},
			(* Check whether we have a ELSD detector *)
			If[MemberQ[resolvedDetector, EvaporativeLightScattering],
				Switch[{nebulizerGas, gasHeating, heatingPower, gasPressure},
					(* Case when all are specified *)
					{Except[Automatic], Except[Automatic], Except[Automatic], Except[Automatic]},
					{nebulizerGas, gasHeating, heatingPower, gasPressure},
					(* Check whether heating power is on, in which case we turn on the gas heating and gas and pressure *)
					{_, _, GreaterEqualP[0 * Percent], _},
					{
						If[MatchQ[nebulizerGas, Automatic], True, nebulizerGas],
						If[MatchQ[gasHeating, Automatic], True, gasHeating],
						heatingPower,
						If[MatchQ[gasPressure, Automatic],
							If[MatchQ[nebulizerGas, False], Null, 40 * PSI],
							gasPressure]
					},
					{_, _, Null, _},
					{
						If[MatchQ[nebulizerGas, Automatic], True, nebulizerGas],
						If[MatchQ[gasHeating, Automatic], False, gasHeating],
						heatingPower,
						If[MatchQ[gasPressure, Automatic],
							If[MatchQ[nebulizerGas, False], Null, 40 * PSI],
							gasPressure]
					},
					(* Check whether the gas flow rate is on, in which case, we turn on the case but turn off the heating by default *)
					{_, _, _, GreaterP[0 * PSI]},
					{
						If[MatchQ[nebulizerGas, Automatic], True, nebulizerGas],
						If[MatchQ[gasHeating, Automatic], False, gasHeating],
						If[MatchQ[gasHeating, True], 50 Percent, Null],
						gasPressure
					},
					{_, _, _, Null},
					{
						If[MatchQ[nebulizerGas, Automatic], False, nebulizerGas],
						If[MatchQ[gasHeating, Automatic], False, gasHeating],
						Null,
						gasPressure
					},
					(* Check whether the gas heating was toggled *)
					{_, True, _, _},
					{
						If[MatchQ[nebulizerGas, Automatic], True, nebulizerGas],
						gasHeating,
						50 Percent,
						40 * PSI
					},
					{_, False, _, _},
					{
						If[MatchQ[nebulizerGas, Automatic], True, nebulizerGas],
						gasHeating,
						Null,
						40 * PSI
					},
					(* Check whether the gas was turned on or off *)
					{True, _, _, _},
					{
						nebulizerGas,
						False,
						Null,
						40 * PSI
					},
					{False, _, _, _},
					{
						nebulizerGas,
						Null,
						Null,
						Null
					},
					(* Otherwise nothing is specified, so take the default option *)
					_,
					{
						True,
						False,
						Null,
						40 * PSI
					}
				],
				(* If no ELSD detector then everything should be Null *)
				{
					If[MatchQ[nebulizerGas, Automatic], Null, nebulizerGas],
					If[MatchQ[gasHeating, Automatic], Null, gasHeating],
					If[MatchQ[heatingPower, Automatic], Null, heatingPower],
					If[MatchQ[gasPressure, Automatic], Null, gasPressure]
				}
			]
		],
		Lookup[partiallyResolvedOptions, {NebulizerGas, NebulizerGasHeating, NebulizerHeatingPower, NebulizerGasPressure}]
	];

	(* Resolve the ELSD DriftTubeTemperature *)
	resolvedDriftTubeTemperatures = Map[
		If[MatchQ[#, Except[Automatic]],
			#,
			If[MemberQ[resolvedDetector, EvaporativeLightScattering], 50 * Celsius, Null]
		]&,
		Lookup[partiallyResolvedOptions, DriftTubeTemperature]
	];

	(* Resolve the ELSDGains*)
	resolvedELSDGains = Map[
		If[MatchQ[#, Except[Automatic]],
			#,
			If[MemberQ[resolvedDetector, EvaporativeLightScattering], 50 Percent, Null]
		]&,
		Lookup[partiallyResolvedOptions, ELSDGain]
	];

	(* Resolve the ELSDSamplingRate *)
	resolvedELSDSamplingRates = Map[
		If[MatchQ[#, Except[Automatic]],
			#,
			If[MemberQ[resolvedDetector, EvaporativeLightScattering], 1 / Second, Null]
		]&,
		Lookup[partiallyResolvedOptions, ELSDSamplingRate]
	];

	(* Now resolve everything related to the ELSD. We'll have a similar process as before *)
	{
		{standardNebulizerGas, standardNebulizerGasHeating, standardNebulizerHeatingPower, standardNebulizerGasPressure, standardDriftTubeTemperature, standardELSDGain, standardELSDSamplingRate},
		{blankNebulizerGas, blankNebulizerGasHeating, blankNebulizerHeatingPower, blankNebulizerGasPressure, blankDriftTubeTemperature, blankELSDGain, blankELSDSamplingRate},
		{columnPrimeNebulizerGas, columnPrimeNebulizerGasHeating, columnPrimeNebulizerHeatingPower, columnPrimeNebulizerGasPressure, columnPrimeDriftTubeTemperature, columnPrimeELSDGain, columnPrimeELSDSamplingRate},
		{columnFlushNebulizerGas, columnFlushNebulizerGasHeating, columnFlushNebulizerHeatingPower, columnFlushNebulizerGasPressure, columnFlushDriftTubeTemperature, columnFlushELSDGain, columnFlushELSDSamplingRate}
	} = Map[
		Module[
			{innerResult},
			innerResult = MapThread[
				Function[
					{nebulizerGas, nebulizerGasHeating, nebulizerHeatingPower, nebulizerGasPressure, driftTubeTemperature, elsdGain, elsdSamplingRate},

					(* Resolve the first four options together given the interdependencies *)
					{innerNebulizerGas, innerNebulizerGasHeating, innerNebulizerHeatingPower, innerNebulizerGasPressure} = If[
						(* Check whether we have a ELSD detector*)
						MemberQ[resolvedDetector, EvaporativeLightScattering],
						Switch[{nebulizerGas, nebulizerGasHeating, nebulizerHeatingPower, nebulizerGasPressure},
							(* Case when all are specified *)
							{Except[Automatic], Except[Automatic], Except[Automatic], Except[Automatic]},
							{nebulizerGas, nebulizerGasHeating, nebulizerHeatingPower, nebulizerGasPressure},
							(* Check whether heating power is on, in which case we turn on the gas heating and gas and pressure *)
							{_, _, GreaterEqualP[0 * Percent], _},
							{
								If[MatchQ[nebulizerGas, Automatic], True, nebulizerGas],
								If[MatchQ[nebulizerGasHeating, Automatic], True, nebulizerGasHeating],
								nebulizerHeatingPower,
								If[MatchQ[nebulizerGasPressure, Automatic],
									If[MatchQ[nebulizerGas, False], Null, 40 * PSI],
									nebulizerGasPressure
								]
							},
							{_, _, Null, _},
							{
								If[MatchQ[nebulizerGas, Automatic], True, nebulizerGas],
								If[MatchQ[nebulizerGasHeating, Automatic], False, nebulizerGasHeating],
								nebulizerHeatingPower,
								If[MatchQ[nebulizerGasPressure, Automatic],
									If[MatchQ[nebulizerGas, False], Null, 40 * PSI],
									nebulizerGasPressure
								]
							},
							(* Check whether the gas flow rate is on, in which case, we turn on the case but turn off the heating by default*)
							{_, _, _, GreaterP[0 * PSI]},
							{
								If[MatchQ[nebulizerGas, Automatic], True, nebulizerGas],
								If[MatchQ[nebulizerGasHeating, Automatic], False, nebulizerGasHeating],
								If[MatchQ[nebulizerGasHeating, True], 50 Percent, Null],
								nebulizerGasPressure
							},
							{_, _, _, Null},
							{
								If[MatchQ[nebulizerGas, Automatic], False, nebulizerGas],
								If[MatchQ[nebulizerGasHeating, Automatic], False, nebulizerGasHeating],
								Null,
								nebulizerGasPressure
							},
							(* Check whether the gas heating was toggled*)
							{_, True, _, _},
							{
								If[MatchQ[nebulizerGas, Automatic], True, nebulizerGas],
								nebulizerGasHeating,
								50 Percent,
								40 * PSI
							},
							{_, False, _, _},
							{
								If[MatchQ[nebulizerGas, Automatic], True, nebulizerGas],
								nebulizerGasHeating,
								Null,
								40 * PSI
							},
						(* Check whether the gas was turned on or off*)
							{True, _, _, _},
							{
								nebulizerGas,
								False,
								Null,
								40 * PSI
							},
							{False, _, _, _},
							{
								nebulizerGas,
								Null,
								Null,
								Null
							},
							(* Otherwise nothing is specified, so take the default from the first resolution*)
							_,
							First /@ {resolvedNebulizerGas, resolvedNebulizerGasHeating, resolvedNebulizerHeatingPower, resolvedNebulizerGasPressure}
						],
						(* If no ELSD detector then everything should be Null *)
						{
							If[MatchQ[nebulizerGas, Automatic], Null, nebulizerGas],
							If[MatchQ[nebulizerGasHeating, Automatic], Null, nebulizerGasHeating],
							If[MatchQ[nebulizerHeatingPower, Automatic], Null, nebulizerHeatingPower],
							If[MatchQ[nebulizerGasPressure, Automatic], Null, nebulizerGasPressure]
						}
					];

					(* Resolve the drift tube temp *)
					innerDriftTubeTemperature = If[MatchQ[driftTubeTemperature, Except[Automatic]],
						driftTubeTemperature,
						If[MemberQ[resolvedDetector, EvaporativeLightScattering], First[resolvedDriftTubeTemperatures], Null]
					];

					(* Resolve the ELSDGains *)
					innerELSDGain = If[MatchQ[elsdGain, Except[Automatic]],
						elsdGain,
						If[MemberQ[resolvedDetector, EvaporativeLightScattering], First[resolvedELSDGains], Null]
					];

					(* Resolve the ELSDSamplingRate *)
					innerELSDSamplingRate = If[MatchQ[elsdSamplingRate, Except[Automatic]],
						elsdSamplingRate,
						If[MemberQ[resolvedDetector, EvaporativeLightScattering], First[resolvedELSDSamplingRates], Null]
					];

					{innerNebulizerGas, innerNebulizerGasHeating, innerNebulizerHeatingPower, innerNebulizerGasPressure, innerDriftTubeTemperature, innerELSDGain, innerELSDSamplingRate}
				],
				#
			];

			If[MatchQ[innerResult, {}],
				ConstantArray[Null, 7],
				Transpose[innerResult]
			]
		]&,
		{
			Lookup[expandedStandardOptions, {StandardNebulizerGas, StandardNebulizerGasHeating, StandardNebulizerHeatingPower, StandardNebulizerGasPressure, StandardDriftTubeTemperature, StandardELSDGain, StandardELSDSamplingRate}],
			Lookup[expandedBlankOptions, {BlankNebulizerGas, BlankNebulizerGasHeating, BlankNebulizerHeatingPower, BlankNebulizerGasPressure, BlankDriftTubeTemperature, BlankELSDGain, BlankELSDSamplingRate}],
			Lookup[expandedColumnOptions, {ColumnPrimeNebulizerGas, ColumnPrimeNebulizerGasHeating, ColumnPrimeNebulizerHeatingPower, ColumnPrimeNebulizerGasPressure, ColumnPrimeDriftTubeTemperature, ColumnPrimeELSDGain, ColumnPrimeELSDSamplingRate}],
			Lookup[expandedColumnOptions, {ColumnFlushNebulizerGas, ColumnFlushNebulizerGasHeating, ColumnFlushNebulizerHeatingPower, ColumnFlushNebulizerGasPressure, ColumnFlushDriftTubeTemperature, ColumnFlushELSDGain, ColumnFlushELSDSamplingRate}]
		}
	];

	(* -- Fraction collection params -- *)

	(* Consolidate all our assembled options *)
	resolvedInstrumentSpecificOptions = Association[
		Detector -> resolvedDetector,
		MaxAcceleration -> resolvedMaxAcceleration,
		SampleTemperature -> resolvedSampleTemperature,
		FractionCollectionDetector -> resolvedFractionCollectionDetector,
		AbsoluteThreshold -> resolvedAbsoluteThreshold,
		PeakSlope -> resolvedPeakSlope,
		PeakSlopeDuration -> resolvedPeakSlopeDuration,
		PeakEndThreshold -> resolvedPeakEndThreshold,

		pHTemperatureCompensation -> resolvedpHTemperatureCompensation,
		ConductivityTemperatureCompensation -> resolvedConductivityTemperatureCompensation,

		AbsorbanceWavelength -> resolvedAbsorbanceWavelengths,
		WavelengthResolution -> resolvedWavelengthResolutions,
		AbsorbanceSamplingRate -> resolvedAbsorbanceSamplingRates,
		UVFilter -> resolvedUVFilters,
		ExcitationWavelength -> resolvedExcitationWavelength /. {(x_) ..} :> x,
		EmissionWavelength -> resolvedEmissionWavelength /. {(x_) ..} :> x,
		EmissionCutOffFilter -> resolvedEmissionCutOffFilter,
		FluorescenceGain -> resolvedFluorescenceGain /. {(x_) ..} :> x,
		FluorescenceFlowCellTemperature -> resolvedFluorescenceFlowCellTemperature,
		NebulizerGas -> resolvedNebulizerGas,
		NebulizerGasHeating -> resolvedNebulizerGasHeating,
		NebulizerHeatingPower -> resolvedNebulizerHeatingPower,
		NebulizerGasPressure -> resolvedNebulizerGasPressure,
		DriftTubeTemperature -> resolvedDriftTubeTemperatures,
		ELSDGain -> resolvedELSDGains, (*Changed it to percent value*)
		ELSDSamplingRate -> resolvedELSDSamplingRates,
		LightScatteringLaserPower -> resolvedLightScatteringLaserPower,
		LightScatteringFlowCellTemperature -> resolvedLightScatteringFlowCellTemperature,
		RefractiveIndexMethod -> resolvedRefractiveIndexMethod,
		RefractiveIndexFlowCellTemperature -> resolvedRefractiveIndexFlowCellTemperature,

		StandardAbsorbanceWavelength -> resolvedStandardAbsorbanceWavelengths,
		StandardWavelengthResolution -> resolvedStandardWavelengthResolutions,
		StandardAbsorbanceSamplingRate -> resolvedStandardAbsorbanceSamplingRates,
		StandardUVFilter -> resolvedStandardUVFilters,
		StandardExcitationWavelength -> resolvedStandardExcitationWavelength /. {(x_) ..} :> x,
		StandardEmissionWavelength -> resolvedStandardEmissionWavelength /. {(x_) ..} :> x,
		StandardEmissionCutOffFilter -> resolvedStandardEmissionCutOffFilter,
		StandardFluorescenceGain -> resolvedStandardFluorescenceGain /. {(x_) ..} :> x,
		StandardFluorescenceFlowCellTemperature -> resolvedStandardFluorescenceFlowCellTemperature,
		StandardNebulizerGas -> standardNebulizerGas,
		StandardNebulizerGasHeating -> standardNebulizerGasHeating,
		StandardNebulizerHeatingPower -> standardNebulizerHeatingPower,
		StandardNebulizerGasPressure -> standardNebulizerGasPressure,
		StandardDriftTubeTemperature -> standardDriftTubeTemperature,
		StandardELSDGain -> standardELSDGain,
		StandardELSDSamplingRate -> standardELSDSamplingRate,
		StandardLightScatteringLaserPower -> resolvedStandardLightScatteringLaserPower,
		StandardLightScatteringFlowCellTemperature -> resolvedStandardLightScatteringFlowCellTemperature,
		StandardRefractiveIndexMethod -> resolvedStandardRefractiveIndexMethod,
		StandardRefractiveIndexFlowCellTemperature -> resolvedStandardRefractiveIndexFlowCellTemperature,

		BlankAbsorbanceWavelength -> resolvedBlankAbsorbanceWavelengths,
		BlankWavelengthResolution -> resolvedBlankWavelengthResolutions,
		BlankAbsorbanceSamplingRate -> resolvedBlankAbsorbanceSamplingRates,
		BlankUVFilter -> resolvedBlankUVFilters,
		BlankExcitationWavelength -> resolvedBlankExcitationWavelength /. {(x_) ..} :> x,
		BlankEmissionWavelength -> resolvedBlankEmissionWavelength /. {(x_) ..} :> x,
		BlankEmissionCutOffFilter -> resolvedBlankEmissionCutOffFilter,
		BlankFluorescenceGain -> resolvedBlankFluorescenceGain /. {(x_) ..} :> x,
		BlankFluorescenceFlowCellTemperature -> resolvedBlankFluorescenceFlowCellTemperature,
		BlankNebulizerGas -> blankNebulizerGas,
		BlankNebulizerGasHeating -> blankNebulizerGasHeating,
		BlankNebulizerHeatingPower -> blankNebulizerHeatingPower,
		BlankNebulizerGasPressure -> blankNebulizerGasPressure,
		BlankDriftTubeTemperature -> blankDriftTubeTemperature,
		BlankELSDGain -> blankELSDGain,
		BlankELSDSamplingRate -> blankELSDSamplingRate,
		BlankLightScatteringLaserPower -> resolvedBlankLightScatteringLaserPower,
		BlankLightScatteringFlowCellTemperature -> resolvedBlankLightScatteringFlowCellTemperature,
		BlankRefractiveIndexMethod -> resolvedBlankRefractiveIndexMethod,
		BlankRefractiveIndexFlowCellTemperature -> resolvedBlankRefractiveIndexFlowCellTemperature,

		ColumnPrimeAbsorbanceWavelength -> resolvedColumnPrimeAbsorbanceWavelengths,
		ColumnPrimeWavelengthResolution -> resolvedColumnPrimeWavelengthResolutions,
		ColumnPrimeAbsorbanceSamplingRate -> resolvedColumnPrimeAbsorbanceSamplingRates,
		ColumnPrimeUVFilter -> resolvedColumnPrimeUVFilters,
		ColumnPrimeExcitationWavelength -> resolvedColumnPrimeExcitationWavelength /. {(x_) ..} :> x,
		ColumnPrimeEmissionWavelength -> resolvedColumnPrimeEmissionWavelength /. {(x_) ..} :> x,
		ColumnPrimeEmissionCutOffFilter -> resolvedColumnPrimeEmissionCutOffFilter,
		ColumnPrimeFluorescenceGain -> resolvedColumnPrimeFluorescenceGain /. {(x_) ..} :> x,
		ColumnPrimeFluorescenceFlowCellTemperature -> resolvedColumnPrimeFluorescenceFlowCellTemperature,
		ColumnPrimeNebulizerGas -> columnPrimeNebulizerGas,
		ColumnPrimeNebulizerGasHeating -> columnPrimeNebulizerGasHeating,
		ColumnPrimeNebulizerHeatingPower -> columnPrimeNebulizerHeatingPower,
		ColumnPrimeNebulizerGasPressure -> columnPrimeNebulizerGasPressure,
		ColumnPrimeDriftTubeTemperature -> columnPrimeDriftTubeTemperature,
		ColumnPrimeELSDGain -> columnPrimeELSDGain,
		ColumnPrimeELSDSamplingRate -> columnPrimeELSDSamplingRate,
		ColumnPrimeLightScatteringLaserPower -> resolvedColumnPrimeLightScatteringLaserPower,
		ColumnPrimeLightScatteringFlowCellTemperature -> resolvedColumnPrimeLightScatteringFlowCellTemperature,
		ColumnPrimeRefractiveIndexMethod -> resolvedColumnPrimeRefractiveIndexMethod,
		ColumnPrimeRefractiveIndexFlowCellTemperature -> resolvedColumnPrimeRefractiveIndexFlowCellTemperature,

		ColumnFlushAbsorbanceWavelength -> resolvedColumnFlushAbsorbanceWavelengths,
		ColumnFlushWavelengthResolution -> resolvedColumnFlushWavelengthResolutions,
		ColumnFlushAbsorbanceSamplingRate -> resolvedColumnFlushAbsorbanceSamplingRates,
		ColumnFlushUVFilter -> resolvedColumnFlushUVFilters,
		ColumnFlushExcitationWavelength -> resolvedColumnFlushExcitationWavelength /. {(x_) ..} :> x,
		ColumnFlushEmissionWavelength -> resolvedColumnFlushEmissionWavelength /. {(x_) ..} :> x,
		ColumnFlushEmissionCutOffFilter -> resolvedColumnFlushEmissionCutOffFilter,
		ColumnFlushFluorescenceGain -> resolvedColumnFlushFluorescenceGain /. {(x_) ..} :> x,
		ColumnFlushFluorescenceFlowCellTemperature -> resolvedColumnFlushFluorescenceFlowCellTemperature,
		ColumnFlushNebulizerGas -> columnFlushNebulizerGas,
		ColumnFlushNebulizerGasHeating -> columnFlushNebulizerGasHeating,
		ColumnFlushNebulizerHeatingPower -> columnFlushNebulizerHeatingPower,
		ColumnFlushNebulizerGasPressure -> columnFlushNebulizerGasPressure,
		ColumnFlushDriftTubeTemperature -> columnFlushDriftTubeTemperature,
		ColumnFlushELSDGain -> columnFlushELSDGain,
		ColumnFlushELSDSamplingRate -> columnFlushELSDSamplingRate,
		ColumnFlushLightScatteringLaserPower -> resolvedColumnFlushLightScatteringLaserPower,
		ColumnFlushLightScatteringFlowCellTemperature -> resolvedColumnFlushLightScatteringFlowCellTemperature,
		ColumnFlushRefractiveIndexMethod -> resolvedColumnFlushRefractiveIndexMethod,
		ColumnFlushRefractiveIndexFlowCellTemperature -> resolvedColumnFlushRefractiveIndexFlowCellTemperature
	];

	(* Do some final error checking *)

	(* Fluorescence Detector *)
	(* Fluorescence Detector Errors has been tracked through booleans in the MapThread *)
	(* Here we try to throw an error and generate one test for each of the following: Sample, Standard, Blank, Column Prime and Column Flush so we can be specific about the corresponding options *)
	(* Fluorescence Error 1-1 - HPLCEmissionLowerThanExcitation *)
	fluorescenceGreaterEmissionInvalidOptions = MapThread[
		If[MemberQ[#1, True],
			(* Construct the error message to give information about invalid options, type of samples and the samples that are invalid *)
			Message[Error::HPLCEmissionLowerThanExcitation, ToString[#2], #4, ObjectToString[PickList[#3, #1, True], Cache -> cache]];{#2},
			{}
		]&,
		{
			(* Error tracking booleans *)
			{
				wavelengthSwappedErrors,
				standardWavelengthSwappedErrors,
				blankWavelengthSwappedErrors,
				columnPrimeWavelengthSwappedErrors,
				columnFlushWavelengthSwappedErrors
			},
			(* Option Names *)
			{
				{ExcitationWavelength, EmissionWavelength},
				{StandardExcitationWavelength, StandardEmissionWavelength},
				{BlankExcitationWavelength, BlankEmissionWavelength},
				{ColumnPrimeExcitationWavelength, ColumnPrimeEmissionWavelength},
				{ColumnFlushExcitationWavelength, ColumnFlushEmissionWavelength}
			},
			(* Samples *)
			{
				mySamples,
				resolvedStandard,
				resolvedBlank,
				resolvedColumnSelector,
				resolvedColumnSelector
			},
			(* Text *)
			{
				"samples",
				"standard samples",
				"blank samples",
				"column flush",
				"column prime"
			}
		}
	];

	fluorescenceGreaterEmissionInvalidTests = MapThread[
		testOrNull["All specified excitation wavelengths are less than emission wavelengths in " <> ToString[#2] <> " options for all " <> #3".", !MemberQ[#1, True]]&,
		{
			(* Error tracking booleans *)
			{
				wavelengthSwappedErrors,
				standardWavelengthSwappedErrors,
				blankWavelengthSwappedErrors,
				columnPrimeWavelengthSwappedErrors,
				columnFlushWavelengthSwappedErrors
			},
			(* Option Names *)
			{
				{ExcitationWavelength, EmissionWavelength},
				{StandardExcitationWavelength, StandardEmissionWavelength},
				{BlankExcitationWavelength, BlankEmissionWavelength},
				{ColumnPrimeExcitationWavelength, ColumnPrimeEmissionWavelength},
				{ColumnFlushExcitationWavelength, ColumnFlushEmissionWavelength}
			},
			(* Text *)
			{
				"samples",
				"standard samples",
				"blank samples",
				"column flush",
				"column prime"
			}
		}
	];

	(* Fluorescence Error 1-2 - HPLCEmissionExcitationTooNarrow *)
	fluorescenceRangeTooNarrowInvalidOptions = MapThread[
		If[MemberQ[#1, True],
			(* Construct the error message to give information about invalid options, type of samples and the samples that are invalid *)
			Message[Error::HPLCEmissionExcitationTooNarrow, ToString[#2], #4, ObjectToString[PickList[#3, #1, True], Cache -> cache], ObjectToString[currentInstrument, Cache -> cache]];{#2},
			{}
		]&,
		{
			(* Error tracking booleans *)
			{
				tooNarrowFluorescenceRangeErrors,
				standardTooNarrowFluorescenceRangeErrors,
				blankTooNarrowFluorescenceRangeErrors,
				columnPrimeTooNarrowFluorescenceRangeErrors,
				columnFlushTooNarrowFluorescenceRangeErrors
			},
			(* Option Names *)
			{
				{ExcitationWavelength, EmissionWavelength},
				{StandardExcitationWavelength, StandardEmissionWavelength},
				{BlankExcitationWavelength, BlankEmissionWavelength},
				{ColumnPrimeExcitationWavelength, ColumnPrimeEmissionWavelength},
				{ColumnFlushExcitationWavelength, ColumnFlushEmissionWavelength}
			},
			(* Samples *)
			{
				mySamples,
				resolvedStandard,
				resolvedBlank,
				resolvedColumnSelector,
				resolvedColumnSelector
			},
			(* Text *)
			{
				"samples",
				"standard samples",
				"blank samples",
				"column flush",
				"column prime"
			}
		}
	];

	fluorescenceRangeTooNarrowInvalidTests = MapThread[
		testOrNull["If Model[Instrument, HPLC, \"UltiMate 3000 with FLR Detector\"] is selected, all specified excitation wavelengths are not within 20 nm of emission wavelengths in " <> ToString[#2] <> " options for all " <> #3".", !MemberQ[#1, True]]&,
		{
			(* Error tracking booleans *)
			{
				tooNarrowFluorescenceRangeErrors,
				standardTooNarrowFluorescenceRangeErrors,
				blankTooNarrowFluorescenceRangeErrors,
				columnPrimeTooNarrowFluorescenceRangeErrors,
				columnFlushTooNarrowFluorescenceRangeErrors
			},
			(* Option Names *)
			{
				{ExcitationWavelength, EmissionWavelength},
				{StandardExcitationWavelength, StandardEmissionWavelength},
				{BlankExcitationWavelength, BlankEmissionWavelength},
				{ColumnPrimeExcitationWavelength, ColumnPrimeEmissionWavelength},
				{ColumnFlushExcitationWavelength, ColumnFlushEmissionWavelength}
			},
			(* Text *)
			{
				"samples",
				"standard samples",
				"blank samples",
				"column flush",
				"column prime"
			}
		}
	];

	(* Fluorescence Error 2 - ConflictFluorescenceOptionLengths - Different number of detector channels provided in the fluorescence parameters *)
	conflictFluorescenceLengthOptions = MapThread[
		If[MemberQ[#1, True],
			(* Construct the error message to give information about invalid options, type of samples and the samples that are invalid *)
			Message[Error::ConflictHPLCFluorescenceOptionsLengths, ToString[#2], #4, ObjectToString[PickList[#3, #1, True], Cache -> cache]];{#2},
			{}
		]&,
		{
			(* Error tracking booleans *)
			{
				conflictFluorescenceLengthErrors,
				standardConflictFluorescenceLengthErrors,
				blankConflictFluorescenceLengthErrors,
				columnPrimeConflictFluorescenceLengthErrors,
				columnFlushConflictFluorescenceLengthErrors
			},
			(* Option Names *)
			{
				{ExcitationWavelength, EmissionWavelength, FluorescenceGain},
				{StandardExcitationWavelength, StandardEmissionWavelength, StandardFluorescenceGain},
				{BlankExcitationWavelength, BlankEmissionWavelength, BlankFluorescenceGain},
				{ColumnPrimeExcitationWavelength, ColumnPrimeEmissionWavelength, ColumnPrimeFluorescenceGain},
				{ColumnFlushExcitationWavelength, ColumnFlushEmissionWavelength, ColumnFlushFluorescenceGain}
			},
			(* Samples *)
			{
				mySamples,
				resolvedStandard,
				resolvedBlank,
				resolvedColumnSelector,
				resolvedColumnSelector
			},
			(* Text *)
			{
				"samples",
				"standard samples",
				"blank samples",
				"column flush",
				"column prime"
			}
		}
	];

	conflictFluorescenceLengthTests = MapThread[
		testOrNull["The specified excitation wavelength, emission wavelength and fluorescence gain options " <> ToString[#2] <> " should be the same length for all " <> #3 <> ".", !MemberQ[#1, True]]&,
		{
			(* Error tracking booleans *)
			{
				conflictFluorescenceLengthErrors,
				standardConflictFluorescenceLengthErrors,
				blankConflictFluorescenceLengthErrors,
				columnPrimeConflictFluorescenceLengthErrors,
				columnFlushConflictFluorescenceLengthErrors
			},
			(* Option Names *)
			{
				{ExcitationWavelength, EmissionWavelength, FluorescenceGain},
				{StandardExcitationWavelength, StandardEmissionWavelength, StandardFluorescenceGain},
				{BlankExcitationWavelength, BlankEmissionWavelength, BlankFluorescenceGain},
				{ColumnPrimeExcitationWavelength, ColumnPrimeEmissionWavelength, ColumnPrimeFluorescenceGain},
				{ColumnFlushExcitationWavelength, ColumnFlushEmissionWavelength, ColumnFlushFluorescenceGain}
			},
			(* Text *)
			{
				"samples",
				"standard samples",
				"blank samples",
				"column flush",
				"column prime"
			}
		}
	];

	(* Fluorescence Error 3 - HPLCFluorescenceWavelengthLimit - too many detection channels - currently limit to 4*)
	tooManyFluorescenceChannelsOptions = MapThread[
		If[MemberQ[#1, True],
			(* Construct the error message to give information about invalid options, type of samples and the samples that are invalid *)
			Message[Error::HPLCFluorescenceWavelengthLimit, ToString[#2], #4, ObjectToString[PickList[#3, #1, True], Cache -> cache], ToString[fluorescenceWavelengthLimit]];{#2},
			{}
		]&,
		{
			(* Error tracking booleans *)
			{
				tooManyFluorescenceWavelengthsErrors,
				standardTooManyFluorescenceWavelengthsErrors,
				blankTooManyFluorescenceWavelengthsErrors,
				columnPrimeTooManyFluorescenceWavelengthsErrors,
				columnFlushTooManyFluorescenceWavelengthsErrors
			},
			(* Option Names *)
			{
				{ExcitationWavelength, EmissionWavelength, FluorescenceGain},
				{StandardExcitationWavelength, StandardEmissionWavelength, StandardFluorescenceGain},
				{BlankExcitationWavelength, BlankEmissionWavelength, BlankFluorescenceGain},
				{ColumnPrimeExcitationWavelength, ColumnPrimeEmissionWavelength, ColumnPrimeFluorescenceGain},
				{ColumnFlushExcitationWavelength, ColumnFlushEmissionWavelength, ColumnFlushFluorescenceGain}
			},
			(* Samples *)
			{
				mySamples,
				resolvedStandard,
				resolvedBlank,
				resolvedColumnSelector,
				resolvedColumnSelector
			},
			(* Text *)
			{
				"samples",
				"standard samples",
				"blank samples",
				"column flush",
				"column prime"
			}
		}
	];

	tooManyFluorescenceChannelsTests = MapThread[
		testOrNull["Only up to " <> ToString[fluorescenceWavelengthLimit] <> " channels can be detected for each member of the " <> #2 <> ".", !MemberQ[#1, True]]&,
		{
			(* Error tracking booleans *)
			{
				tooManyFluorescenceWavelengthsErrors,
				standardTooManyFluorescenceWavelengthsErrors,
				blankTooManyFluorescenceWavelengthsErrors,
				columnPrimeTooManyFluorescenceWavelengthsErrors,
				columnFlushTooManyFluorescenceWavelengthsErrors
			},
			(* Text *)
			{
				"samples",
				"standard samples",
				"blank samples",
				"column flush",
				"column prime"
			}
		}
	];

	(* Fluorescence Error 4 - InvalidHPLCEmissionCutOffFilter - filter is not available on Waters instrument *)
	invalidEmissionCutOffFilterOptions = MapThread[
		If[MemberQ[#1, True],
			(* Construct the error message to give information about invalid options, type of samples and the samples that are invalid *)
			Message[Error::InvalidHPLCEmissionCutOffFilter, ObjectToString[currentInstrument, Cache -> cache], ToString[#2], ObjectToString[Model[Instrument, HPLC, "id:wqW9BP7BzwAG"], Cache -> cache]];{#2},
			{}
		]&,
		{
			(* Error tracking booleans *)
			{
				invalidEmissionCutOffFilterErrors,
				standardInvalidEmissionCutOffFilterErrors,
				blankInvalidEmissionCutOffFilterErrors,
				columnPrimeInvalidEmissionCutOffFilterErrors,
				columnFlushInvalidEmissionCutOffFilterErrors
			},
			(* Option Names *)
			{
				EmissionCutOffFilter,
				StandardEmissionCutOffFilter,
				BlankEmissionCutOffFilter,
				ColumnPrimeEmissionCutOffFilter,
				ColumnFlushEmissionCutOffFilter
			}
		}
	];

	invalidEmissionCutOffFilterTests = MapThread[
		testOrNull["The option " <> ToString[#2] <> " can only be set when an instrument with the emission cut-off filter is selected.", !MemberQ[#1, True]]&,
		{
			(* Error tracking booleans *)
			{
				invalidEmissionCutOffFilterErrors,
				standardInvalidEmissionCutOffFilterErrors,
				blankInvalidEmissionCutOffFilterErrors,
				columnPrimeInvalidEmissionCutOffFilterErrors,
				columnFlushInvalidEmissionCutOffFilterErrors
			},
			(* Option Names *)
			{
				EmissionCutOffFilter,
				StandardEmissionCutOffFilter,
				BlankEmissionCutOffFilter,
				ColumnPrimeEmissionCutOffFilter,
				ColumnFlushEmissionCutOffFilter
			}
		}
	];

	(* Fluorescence Error 5 - TooLargeHPLCEmissionCutOffFilter - filter should allow emission light to go through *)
	tooLargeEmissionCutOffFilterOptions = MapThread[
		If[MemberQ[#1, True],
			(* Construct the error message to give information about invalid options, type of samples and the samples that are invalid *)
			Message[Error::TooLargeHPLCEmissionCutOffFilter, #4, ObjectToString[PickList[#3, #1, True], Cache -> cache], ToString[First[#2]], ToString[PickList[#5, #1, True]], ToString[Last[#2]], ToString[PickList[#6, #1, True]]];{#2},
			{}
		]&,
		{
			(* Error tracking booleans *)
			{
				tooLargeEmissionCutOffFilterErrors,
				standardTooLargeEmissionCutOffFilterErrors,
				blankTooLargeEmissionCutOffFilterErrors,
				columnPrimeTooLargeEmissionCutOffFilterErrors,
				columnFlushTooLargeEmissionCutOffFilterErrors
			},
			(* Option Names *)
			{
				{EmissionCutOffFilter, EmissionWavelength},
				{StandardEmissionCutOffFilter, StandardEmissionWavelength},
				{BlankEmissionCutOffFilter, BlankEmissionWavelength},
				{ColumnPrimeEmissionCutOffFilter, ColumnPrimeEmissionWavelength},
				{ColumnFlushEmissionCutOffFilter, ColumnFlushEmissionWavelength}
			},
			(* Samples *)
			{
				mySamples,
				resolvedStandard,
				resolvedBlank,
				resolvedColumnSelector,
				resolvedColumnSelector
			},
			(* Text *)
			{
				"samples",
				"standard samples",
				"blank samples",
				"column flush",
				"column prime"
			},
			(* Option Values for cut-off filter *)
			{
				resolvedEmissionCutOffFilter,
				resolvedStandardEmissionCutOffFilter,
				resolvedBlankEmissionCutOffFilter,
				resolvedColumnPrimeEmissionCutOffFilter,
				resolvedColumnFlushEmissionCutOffFilter
			},
			(* Option Values for emission wavelength *)
			{
				resolvedEmissionWavelength,
				resolvedStandardEmissionWavelength,
				resolvedBlankEmissionWavelength,
				resolvedColumnPrimeEmissionWavelength,
				resolvedColumnFlushEmissionWavelength
			}
		}
	];

	tooLargeEmissionCutOffFilterTests = MapThread[
		testOrNull["The selected " <> ToString[First[#2]] <> " are not larger than " <> ToString[Last[#2]] <> " for the emission light to pass through.", !MemberQ[#1, True]]&,
		{
			(* Error tracking booleans *)
			{
				tooLargeEmissionCutOffFilterErrors,
				standardTooLargeEmissionCutOffFilterErrors,
				blankTooLargeEmissionCutOffFilterErrors,
				columnPrimeTooLargeEmissionCutOffFilterErrors,
				columnFlushTooLargeEmissionCutOffFilterErrors
			},
			(* Option Names *)
			{
				{EmissionCutOffFilter, EmissionWavelength},
				{StandardEmissionCutOffFilter, StandardEmissionWavelength},
				{BlankEmissionCutOffFilter, BlankEmissionWavelength},
				{ColumnPrimeEmissionCutOffFilter, ColumnPrimeEmissionWavelength},
				{ColumnFlushEmissionCutOffFilter, ColumnFlushEmissionWavelength}
			}
		}
	];

	(* Fluorescence Error 6 - InvalidWatersHPLCFluorescenceGain - the gain must be the same for multi-channel fluorescence measurement for Waters *)
	invalidWatersFluorescenceGainOptions = MapThread[
		If[MemberQ[#1, True],
			(* Construct the error message to give information about invalid options, type of samples and the samples that are invalid *)
			Message[Error::InvalidWatersHPLCFluorescenceGain, ObjectToString[currentInstrument, Cache -> cache], ToString[#2]];{#2},
			{}
		]&,
		{
			(* Error tracking booleans *)
			{
				invalidWatersFluorescenceGainErrors,
				standardInvalidWatersFluorescenceGainErrors,
				blankInvalidWatersFluorescenceGainErrors,
				columnPrimeInvalidWatersFluorescenceGainErrors,
				columnFlushInvalidWatersFluorescenceGainErrors
			},
			(* Option Names *)
			{
				FluorescenceGain,
				StandardFluorescenceGain,
				BlankFluorescenceGain,
				ColumnPrimeFluorescenceGain,
				ColumnFlushFluorescenceGain
			}
		}
	];

	invalidWatersFluorescenceGainTests = MapThread[
		testOrNull["For Waters Acquity HPLC system with Fluorescence detector, the " <> ToString[#2] <> " option must be set to a constant value for multi-channel measurement.", !MemberQ[#1, True]]&,
		{
			(* Error tracking booleans *)
			{
				invalidWatersFluorescenceGainErrors,
				standardInvalidWatersFluorescenceGainErrors,
				blankInvalidWatersFluorescenceGainErrors,
				columnPrimeInvalidWatersFluorescenceGainErrors,
				columnFlushInvalidWatersFluorescenceGainErrors
			},
			(* Option Names *)
			{
				FluorescenceGain,
				StandardFluorescenceGain,
				BlankFluorescenceGain,
				ColumnPrimeFluorescenceGain,
				ColumnFlushFluorescenceGain
			}
		}
	];

	(* Fluorescence Error 7 - InvalidHPLCFluorescenceFlowCellTemperature - flow cell temperature control is not available on Waters instrument *)
	invalidFluorescenceFlowCellTemperatureOptions = MapThread[
		If[MemberQ[#1, True],
			(* Construct the error message to give information about invalid options, type of samples and the samples that are invalid *)
			Message[Error::InvalidHPLCFluorescenceFlowCellTemperature, ObjectToString[currentInstrument, Cache -> cache], ToString[#2], ObjectToString[Model[Instrument, HPLC, "id:wqW9BP7BzwAG"], Cache -> cache]];{#2},
			{}
		]&,
		{
			(* Error tracking booleans *)
			{
				invalidFluorescenceFlowCellTemperatureErrors,
				standardInvalidFluorescenceFlowCellTemperatureErrors,
				blankInvalidFluorescenceFlowCellTemperatureErrors,
				columnPrimeInvalidFluorescenceFlowCellTemperatureErrors,
				columnFlushInvalidFluorescenceFlowCellTemperatureErrors
			},
			(* Option Names *)
			{
				FluorescenceFlowCellTemperature,
				StandardFluorescenceFlowCellTemperature,
				BlankFluorescenceFlowCellTemperature,
				ColumnPrimeFluorescenceFlowCellTemperature,
				ColumnFlushFluorescenceFlowCellTemperature
			}
		}
	];

	invalidFluorescenceFlowCellTemperatureTests = MapThread[
		testOrNull["The option " <> ToString[#2] <> " can only be set when an instrument with the fluorescence flow cell temperature control is selected.", !MemberQ[#1, True]]&,
		{
			(* Error tracking booleans *)
			{
				invalidFluorescenceFlowCellTemperatureErrors,
				standardInvalidFluorescenceFlowCellTemperatureErrors,
				blankInvalidFluorescenceFlowCellTemperatureErrors,
				columnPrimeInvalidFluorescenceFlowCellTemperatureErrors,
				columnFlushInvalidFluorescenceFlowCellTemperatureErrors
			},
			(* Option Names *)
			{
				FluorescenceFlowCellTemperature,
				StandardFluorescenceFlowCellTemperature,
				BlankFluorescenceFlowCellTemperature,
				ColumnPrimeFluorescenceFlowCellTemperature,
				ColumnFlushFluorescenceFlowCellTemperature
			}
		}
	];


	(* Refractive Index Detector *)
	(* Check for mismatching RI method and the reference loading status *)
	(* ConflictRefractiveIndexMethod - When DifferentialRefractiveIndex is selected, the reference loading must be closed *)
	conflictRefractiveIndexMethodOptions = MapThread[
		If[MemberQ[#1, True],
			(* Construct the error message to give information about invalid options, type of samples and the samples that are invalid *)
			Message[Error::ConflictRefractiveIndexMethod, #4, ObjectToString[PickList[#3, #1, True], Cache -> cache], ToString[First[#2]], ToString[Last[#2]]];{#2},
			{}
		]&,
		{
			(* Error tracking booleans *)
			{
				refractiveIndexMethodConflictErrors,
				standardRefractiveIndexMethodConflictErrors,
				blankRefractiveIndexMethodConflictErrors,
				columnPrimeRefractiveIndexMethodConflictErrors,
				columnFlushRefractiveIndexMethodConflictErrors
			},
			(* Option Names *)
			{
				{RefractiveIndexMethod, Gradient},
				{StandardRefractiveIndexMethod, StandardGradient},
				{BlankRefractiveIndexMethod, BlankGradient},
				{ColumnPrimeRefractiveIndexMethod, ColumnPrimeGradient},
				{ColumnFlushRefractiveIndexMethod, ColumnFlushGradient}
			},
			(* Samples *)
			{
				mySamples,
				resolvedStandard,
				resolvedBlank,
				resolvedColumnSelector,
				resolvedColumnSelector
			},
			(* Text *)
			{
				"samples",
				"standard samples",
				"blank samples",
				"column flush",
				"column prime"
			}
		}
	];

	conflictRefractiveIndexMethodTests = MapThread[
		testOrNull["When DifferentialRefractiveIndex method is select in " <> ToString[First[#2]] <> ", the gradient in " <> ToString[Last[#2]] <> " has the differential refractive index reference loading closed.", !MemberQ[#1, True]]&,
		{
			(* Error tracking booleans *)
			{
				refractiveIndexMethodConflictErrors,
				standardRefractiveIndexMethodConflictErrors,
				blankRefractiveIndexMethodConflictErrors,
				columnPrimeRefractiveIndexMethodConflictErrors,
				columnFlushRefractiveIndexMethodConflictErrors
			},
			(* Option Names *)
			{
				{RefractiveIndexMethod, Gradient},
				{StandardRefractiveIndexMethod, StandardGradient},
				{BlankRefractiveIndexMethod, BlankGradient},
				{ColumnPrimeRefractiveIndexMethod, ColumnPrimeGradient},
				{ColumnFlushRefractiveIndexMethod, ColumnFlushGradient}
			}
		}
	];


	(* ELSD Detector *)
	(* Checking for the ELSD option conflicts *)
	gasPressureOptions = {NebulizerGasPressure, StandardNebulizerGasPressure, BlankNebulizerGasPressure, ColumnPrimeNebulizerGasPressure, ColumnFlushNebulizerGasPressure};
	nebulizerGasOptions = {NebulizerGas, StandardNebulizerGas, BlankNebulizerGas, ColumnPrimeNebulizerGas, ColumnFlushNebulizerGas};

	(* Check whenever gas Pressure is specified on AND that the gas is False *)
	gasPressureConflictBool = MapThread[
		Function[
			{gasPressureOption, gasOption},
			(* Convert to a list if need be *)
			gasPressureAsList = ToList[gasPressureOption];
			gasOptionAsList = ToList[gasOption];

			(* Check if we have any option failures *)
			(Or @@ MapThread[And[MatchQ[#1, GreaterP[0 * PSI]], MatchQ[#2, False | Null]]&, {gasPressureAsList, gasOptionAsList}]) /. {} -> False

		],
		{Lookup[partiallyResolvedOptions, gasPressureOptions], Lookup[partiallyResolvedOptions, nebulizerGasOptions]}
	];

	gasPressureConflictOptions = Flatten@{PickList[gasPressureOptions, gasPressureConflictBool], PickList[nebulizerGasOptions, gasPressureConflictBool]};

	gasPressureConflictTest = If[Length[gasPressureConflictOptions] > 0,
		(
			If[messagesQ,
				Message[Error::GasPressureRequiresNebulizer, gasPressureConflictOptions]
			];
			testOrNull["When _NebulizerGasPressure is specified to a pressure value, the corresponding _NebulizerGas is not False or Null:", False]
		),
		testOrNull["When _NebulizerGasPressure is specified to a pressure value, the corresponding _NebulizerGas or _NebulizerGasHeating is not False or Null:", True]
	];

	(* Check whether the gas Heating is On, but the gas is off *)
	nebulizerGasHeatingOptions = {NebulizerGasHeating, StandardNebulizerGasHeating, BlankNebulizerGasHeating, ColumnPrimeNebulizerGasHeating, ColumnFlushNebulizerGasHeating};
	gasHeatingConflictBool = MapThread[
		Function[{gasHeatingOption, gasOption},
			(* Convert to a list if need be *)
			gasHeatingAsList = ToList[gasHeatingOption];
			gasOptionAsList = ToList[gasOption];

			(* Check if we have any option failures *)
			(Or @@ MapThread[And[TrueQ[#1], MatchQ[#2, False | Null]]&, {gasHeatingAsList, gasOptionAsList}]) /. {} -> False

		],
		{Lookup[partiallyResolvedOptions, nebulizerGasHeatingOptions], Lookup[partiallyResolvedOptions, nebulizerGasOptions]}
	];

	gasHeatingConflictOptions = Flatten@{PickList[nebulizerGasHeatingOptions, gasHeatingConflictBool], PickList[nebulizerGasOptions, gasHeatingConflictBool]};

	gasHeatingConflictTest = If[Length[gasHeatingConflictOptions] > 0,
		(
			If[messagesQ,
				Message[Error::GasHeatingRequiresNebulizer, gasHeatingConflictOptions]
			];
			testOrNull["When _NebulizerGasHeating is specified to True, the corresponding _NebulizerGas is not False or Null:", False]
		),
		testOrNull["When _NebulizerGasPressure is specified to True, the corresponding _NebulizerGas is not False or Null:", True]
	];

	(* Check whether the heating power option was specified, if so check whether the heating or gas is specified off *)
	nebulizerHeatingPowerOptions = {NebulizerHeatingPower, StandardNebulizerHeatingPower, BlankNebulizerHeatingPower, ColumnPrimeNebulizerHeatingPower, ColumnFlushNebulizerHeatingPower};
	{heatingPowerConflictGasBool, heatingPowerConflictHeatingBool} = Transpose@MapThread[
		Function[{gasHeatingOption, gasOption, powerOption},
			(* Convert to a list if need be *)
			gasHeatingAsList = ToList[gasHeatingOption];
			gasOptionAsList = ToList[gasOption];
			powerOptionAsList = ToList[powerOption];

			(* Check if we have any option failures. We need to keep the failure for the gas separate from the gasHeating *)
			{
				(Or @@ MapThread[And[MatchQ[#2, False | Null], MatchQ[#3, GreaterEqualP[0 * Percent]]]&, {gasHeatingAsList, gasOptionAsList, powerOptionAsList}]) /. {} -> False,
				(Or @@ MapThread[And[MatchQ[#1, False | Null], MatchQ[#3, GreaterEqualP[0 * Percent]]]&, {gasHeatingAsList, gasOptionAsList, powerOptionAsList}]) /. {} -> False
			}
		],
		{Lookup[partiallyResolvedOptions, nebulizerGasHeatingOptions], Lookup[partiallyResolvedOptions, nebulizerGasOptions], Lookup[partiallyResolvedOptions, nebulizerHeatingPowerOptions]}
	];

	(* Find all of the offending options *)
	gasHeatingPowerConflictOptions = DeleteDuplicates@Flatten@{
		PickList[nebulizerHeatingPowerOptions, heatingPowerConflictGasBool],
		PickList[nebulizerGasOptions, heatingPowerConflictGasBool],
		PickList[nebulizerHeatingPowerOptions, heatingPowerConflictHeatingBool],
		PickList[nebulizerGasHeatingOptions, heatingPowerConflictHeatingBool]
	};

	gasHeatingPowerConflictTest = If[Length[gasHeatingPowerConflictOptions] > 0,
		(
			If[messagesQ,
				Message[Error::HeatingPowerRequiresNebulizerHeating, gasHeatingPowerConflictOptions]
			];
			testOrNull["When _NebulizerheatingPower is specified, the corresponding _NebulizerGas or _NebulizerGasHeating is not False or Null:", False]
		),
		testOrNull["When _NebulizerGasPressure is specified, the corresponding _NebulizerGas or _NebulizerGasHeating is not False or Null:", True]
	];

	(* Need to check whether any of the waters specific options were set but the we're actually using a UVVis from not Waters *)
	uvFilterOptions = {UVFilter, StandardUVFilter, BlankUVFilter, ColumnPrimeUVFilter, ColumnFlushUVFilter};

	samplingRateOptions = {AbsorbanceSamplingRate, StandardAbsorbanceSamplingRate, BlankAbsorbanceSamplingRate, ColumnPrimeAbsorbanceSamplingRate, ColumnFlushAbsorbanceSamplingRate};

	(* If we don't have a waters or Agilent and we have a UVVis detector, need to see if these options are specified *)
	{tuvOptionsNotNeededQ, tuvNotNeededOptions} = Which[
		(* If a waters instrument or no UVVis/PDA detector, then we don't care *)
		Or[
			watersManufacturedQ,
			And[!MemberQ[resolvedDetector, UVVis], !MemberQ[resolvedDetector, PhotoDiodeArray]]
		],
		{False, {}},
		agilentManufacturedQ,
		Module[
			{innerResult},
			innerResult = MatchQ[#, Except[ListableP[Automatic | Null]]]& /@ Lookup[partiallyResolvedOptions, uvFilterOptions];
			(* If we got a hit, then we return true with the offending options *)
			If[Or @@ innerResult, {True, PickList[uvFilterOptions, innerResult]}, {False, {}}]
		],
		True,
		Module[
			{innerResult},
			innerResult = MatchQ[#, Except[ListableP[Automatic | Null]]]& /@ Lookup[partiallyResolvedOptions, Join[samplingRateOptions, uvFilterOptions]];
			(* If we got a hit, then we return true with the offending options *)
			If[Or @@ innerResult, {True, PickList[Join[samplingRateOptions, uvFilterOptions], innerResult]}, {False, {}}]
		]
	];

	(* Test and Warning *)
	tuvOptionsNotNeededTest = If[tuvOptionsNotNeededQ,
		(
			If[messagesQ && !engineQ,
				Message[Warning::UVVisOptionsNotApplicable, tuvNotNeededOptions]
			];
			testOrNull["If the resolved Instrument has a UVVis detector on a Dionex HPLC instrument, AbsorbanceSamplingRate options and UVFilter options cannot be specified:", False]
		),
		testOrNull["If the resolved Instrument has a UVVis detector on a Dionex HPLC instrument, AbsorbanceSamplingRate options and UVFilter options cannot be specified:", True]
	];

	(* Tabulate all of the invalid options *)
	invalidOptions = DeleteDuplicates@Flatten@{
		invalidMaxAccerationOption,
		missingFractionCollectionDetectorOption,
		conflictFractionCollectionUnitOptions,
		missingDetectionOptions,
		fluorescenceGreaterEmissionInvalidOptions,
		fluorescenceRangeTooNarrowInvalidOptions,
		conflictFluorescenceLengthOptions,
		tooManyFluorescenceChannelsOptions,
		invalidEmissionCutOffFilterOptions,
		tooLargeEmissionCutOffFilterOptions,
		invalidWatersFluorescenceGainOptions,
		invalidFluorescenceFlowCellTemperatureOptions,
		conflictRefractiveIndexMethodOptions,
		gasPressureConflictOptions,
		gasHeatingPowerConflictOptions,
		gasHeatingConflictOptions,
		wavelengthResolutionConflictOptions,
		wavelengthFractionCollectionConflictOptions,
		incompatibleFractionCollectionAllOptions,
		conflictFractionCollectionMethodOptions
	};

	(* Make the result and tests rules *)
	resultRule = Result -> {resolvedInstrumentSpecificOptions, invalidOptions};
	testsRule = Tests -> Cases[Flatten[{
		potentialAnalyteTests,
		missingFractionCollectionDetectorTest,
		conflictFractionCollectionUnitTests,
		missingDetectionOptionsTests,
		fluorescenceGreaterEmissionInvalidTests,
		fluorescenceRangeTooNarrowInvalidTests,
		conflictFluorescenceLengthTests,
		tooManyFluorescenceChannelsTests,
		invalidEmissionCutOffFilterTests,
		tooLargeEmissionCutOffFilterTests,
		invalidWatersFluorescenceGainTests,
		invalidFluorescenceFlowCellTemperatureTests,
		conflictRefractiveIndexMethodTests,
		gasPressureConflictTest,
		gasHeatingConflictTest,
		gasHeatingPowerConflictTest,
		tuvOptionsNotNeededTest,
		wavelengthResolutionConflictTests,
		wavelengthFractionCollectionConflictTests,
		incompatibleFractionCollectionTest,
		conflictFractionCollectionMethodTests
	}], _EmeraldTest];

	outputSpecification /. {resultRule, testsRule}
];


(* ::Subsection:: *)
(* Resource Packets *)


(* ::Subsubsection:: *)
(* HPLCResourcePacketsNew *)


DefineOptions[
	HPLCResourcePacketsNew,
	Options :> {
		{InternalUsage -> False, BooleanP, "Whether this function is being called from another function (e.g. ExperimentLCMS) or not."},
		OutputOption,
		CacheOption
	}
];

HPLCResourcePacketsNew[mySamples : {ObjectP[Object[Sample]]..}, myUnresolvedOptions : {_Rule...}, myResolvedOptions : {_Rule...}, ops : OptionsPattern[HPLCResourcePacketsNew]] := Module[
	{outputSpecification, output, gatherTestsQ, cache, resolvedOptions, instrumentObject, columnObjects,
		numberOfReplicates, sampleObjects, samplesWithReplicates, optionsWithReplicates,
		columnSelectorLookup, columnSelectorWithJoins, columnSelectorResources, columnSelectorUploadable, columnSelectorNewUploadable, columnHolderResources,
		guardColumnResources, compatibleVialContainer, resolvedGradients, gradientMethodInPlace, gradientObjectsToMake,
		systemPrimeGradientObject, systemPrimeGradientPacket, systemFlushGradientObject, systemFlushGradientPacket, systemPrimeGradient,
		systemFlushGradient, instrumentModelPacket, maxColumnPressure, injectionTable, majorityProtocolPacket,
		columnPrimePositions, columnFlushPositions, standardLookup, blankLookup, standardMappingAssociation, blankMappingAssociation,
		columnPrimeMappingAssociation, standardReverseAssociation, blankReverseAssociation, columnPrimeReverseAssociation, columnFlushReverseAssociation,
		sampleReverseAssociation, columnFlushMappingAssociation, groupedStandard, flatStandardResources, linkedStandardResources, blankTuples,
		assignedBlankTuples, groupedBlanksTuples, groupedBlanksPositionVolumes, groupedBlankShared, groupedBlank,
		flatBlankResources, linkedBlankResources, linkedSampleResources, injectionTableWithLinks,
		standardTuples, assignedStandardTuples, groupedStandardsTuples, groupedStandardsPositionVolumes, groupedStandardShared,
		samplePackets, samplePositions, samplePositionsWithReplicates, sampleContainers, aliquotContainers, bufferAModel, bufferBModel, bufferCModel, bufferDModel,
		guardCartridgeResources, sampleGradient, standardGradient, blankGradient, columnPrimeGradient, columnFlushGradient,
		instrumentModel, columnFlushInitialFlowRate, protocolObjectID,
		fractionPackets, existingFractionCollectionMethods, newFractionPackets,standardPositions, blankPositions,
		instrumentManufacturer, alternateInstruments, alternateInstrumentOptions, resolvedStandard, resolvedBlank,
		listifiedStandard, listifiedBlank, needleWashSolutionPlacements, instrumentResource,
		shutdownGradient, shutdownFileName, autosamplerDeadVolume, vialContainerMaxVolume, vialSampleMaxVolume,
		calibrationBufferContainer, calibrationBufferVolume, lowpHCalibrationBufferResource, highpHCalibrationBufferResource, conductivityCalibrationBufferResource,
		pHCalibrationQ, conductivityCalibrationQ, calibrationWashSolutionResource, calibrationWasteContainer, syringePumpResource,
		calibrationWashSolutionSyringeResource, conductivityCalibrationBufferSyringeResource, lowpHCalibrationBufferSyringeResource, highpHCalibrationBufferSyringeResource,
		calibrationWashSolutionNeedleResource, conductivityCalibrationBufferNeedleResource, lowpHCalibrationBufferNeedleResource, highpHCalibrationBufferNeedleResource,
		calibrationWashSolutionFlowRate, lowpHCalibrationBufferFlowRate, highpHCalibrationBufferFlowRate, conductivityCalibrationBufferFlowRate,
		calibrationWashSolutionVolume, lowpHCalibrationBufferVolume, highpHCalibrationBufferVolume, conductivityCalibrationBufferVolume,
		syringeInnerDiameter, calibrationWashSolutionSyringeInnerDiameter, lowpHCalibrationBufferSyringeInnerDiameter, highpHCalibrationBufferSyringeInnerDiameter, conductivityCalibrationBufferSyringeInnerDiameter,
		instrumentSpecificOptions, unresolvedOptions, guardColumns, guardCartridgeModelPackets, guardColumnModelPackets, guardColumnObjects, guardCartridgeObjects,
		availableInstruments, watersManufacturedQ, watersHPLCInstruments, dionexHPLCInstruments, testHPLCInstruments, dionexHPLCPattern, standardPositionsCorresponded, plateContainerCount, instrumentSpecifiedProtocolPacket,
		blankPositionsCorresponded, columnPrimePositionsCorresponded, columnFlushPositionsCorresponded,
		blankColumnTupleResourcesUnmapped, standardColumnTupleResourcesUnmapped,
		uniqueGradientPackets, allGradientTuples, totalRunTime, bufferAVolumePerGradient, bufferBVolumePerGradient, bufferCVolumePerGradient,
		bufferDVolumePerGradient, systemPrimeBufferAVolumeUsage, systemPrimeBufferBVolumeUsage, systemPrimeBufferCVolumeUsage,
		systemPrimeBufferDVolumeUsage, systemFlushBufferAVolumeUsage, systemFlushBufferBVolumeUsage, systemFlushBufferCVolumeUsage,
		systemFlushBufferDVolumeUsage, bufferDeadVolume, bufferAVolume, bufferBVolume, bufferCVolume, bufferDVolume, systemPrimeBufferAVolume,
		systemPrimeBufferBVolume, systemPrimeBufferCVolume, systemPrimeBufferDVolume, systemFlushBufferAVolume, systemFlushBufferBVolume,
		systemFlushBufferCVolume, systemFlushBufferDVolume, bufferAContainer, bufferBContainer, bufferCContainer, bufferDContainer,
		tableGradients, injectionTableFull, sampleTuples, insertionAssociation, injectionTableInserted, injectionTableWithReplicates, injectionTableUploadable,
		systemPrimeBufferContainer, systemFlushBufferContainer, bufferAResource, bufferBResource, bufferCResource, bufferDResource, needleWashSolution, needleWashResource,
		systemPrimeBufferA, systemPrimeBufferB, systemPrimeBufferC, systemPrimeBufferD,
		systemFlushBufferA, systemFlushBufferB, systemFlushBufferC, systemFlushBufferD,
		systemPrimeBufferAResource, systemPrimeBufferBResource, systemPrimeBufferCResource, systemPrimeBufferDResource,
		systemFlushBufferAResource, systemFlushBufferBResource, systemFlushBufferCResource, systemFlushBufferDResource,
		sampleContainerModels, agilentRackPositionRules, smallVesselCount, largeVesselCount,
		agilentFractionCollectionRackPositions, fractionPositionCount, fractionContainerCount, maxFractionTotalVolume,
		checkInFrequency,
		systemPrimeBufferPlacements, systemFlushBufferPlacements,
		componentMaxPressures, upperPressureLimit, sampleResources, expandedPreInstrumentOptions, resolvedAliquotAmount, resolvedAssayVolume, dilutionFactors,
		columnPrimeGradientA, columnPrimeGradientB, columnPrimeGradientC, columnPrimeGradientD, columnPrimeFlowRates, columnPrimeFlowRatesConstant, columnPrimeFlowRatesVariable, 
		sampleGradientA, sampleGradientB, sampleGradientC, sampleGradientD, sampleFlowRates, sampleFlowRatesConstant, sampleFlowRatesVariable, sampleColumnTemperatures,
		standardGradientA, standardGradientB, standardGradientC, standardGradientD, standardFlowRates, standardFlowRatesConstant, standardFlowRatesVariable, standardTemperatures,
		blankGradientA, blankGradientB, blankGradientC, blankGradientD, blankFlowRates, blankFlowRatesConstant, blankFlowRatesVariable, blankTemperatures,
		columnPrimeTemperatures, columnFlushGradientA, columnFlushGradientB, columnFlushGradientC, columnFlushGradientD, columnFlushFlowRates, columnFlushFlowRatesConstant, columnFlushFlowRatesVariable,
		internalUsage, internalUsageQ,
		columnFlushTemperatures, uniqueSamples, uniqueSampleResources,
		operatorResource, primeFlushTime, detectorCalibrationTime, checkpoints, sharedFieldPacket, joinedProtocolPacket, allPackets, preInstrumentOptionResolution,
		expandedStandardsStorageConditions, standardStorageLookup, blankStorageLookup, expandedBlanksStorageConditions,
		allResources, resourcesFulfillableQ, resourceTests, expandForNumberOfReplicates, agilentHPLCInstruments, agilentHPLCPattern},

	(* Determine the requested return value from the function *)
	outputSpecification = OptionValue[Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests *)
	gatherTestsQ = MemberQ[output, Tests];

	(* Determine whether this fucntion is just for internal usage or not *)
	internalUsage = OptionValue[InternalUsage];
	internalUsageQ = MatchQ[internalUsage, True];

	(* Fetch passed cache *)
	cache = OptionValue[Cache];

	(* Convert list of rules to an association *)
	resolvedOptions = Association@Last[ExpandIndexMatchedInputs[ExperimentHPLC, {mySamples}, myResolvedOptions]];

	(* Define the list of options that we'll need to do instrument specific resolution for *)
	(* Note that Detector is resolved again. We resolved the Detector based on Instrument and AlternateInstruments to make sure user is aware of the type of data they are going to get when they confirm protocol. The PDA and UVVis are generating the same type of data though so we can switch it *)
	(* Most of the detector related options are instrument specific - except the pH/Conductivity calibration options. We don't want to resolve these options again because we cannot prepare the resources for the buffers again *)
	instrumentSpecificOptions = {Detector, MaxAcceleration, SampleTemperature, FractionCollectionDetector, AbsoluteThreshold, PeakSlope, PeakSlopeDuration, PeakEndThreshold,
		pHTemperatureCompensation, ConductivityTemperatureCompensation,
		AbsorbanceWavelength, WavelengthResolution, AbsorbanceSamplingRate, UVFilter,
		ExcitationWavelength, EmissionWavelength, EmissionCutOffFilter, FluorescenceGain, FluorescenceFlowCellTemperature,
		NebulizerGas, NebulizerGasHeating, NebulizerHeatingPower, NebulizerGasPressure, DriftTubeTemperature, ELSDGain, ELSDSamplingRate,
		LightScatteringLaserPower, LightScatteringFlowCellTemperature, RefractiveIndexMethod, RefractiveIndexFlowCellTemperature,
		StandardAbsorbanceWavelength, StandardWavelengthResolution, StandardAbsorbanceSamplingRate, StandardUVFilter,
		StandardExcitationWavelength, StandardEmissionWavelength, StandardEmissionCutOffFilter, StandardFluorescenceGain, StandardFluorescenceFlowCellTemperature,
		StandardNebulizerGas, StandardNebulizerGasHeating, StandardNebulizerHeatingPower, StandardNebulizerGasPressure, StandardDriftTubeTemperature, StandardELSDGain, StandardELSDSamplingRate,
		StandardLightScatteringLaserPower, StandardLightScatteringFlowCellTemperature, StandardRefractiveIndexMethod, StandardRefractiveIndexFlowCellTemperature,
		BlankAbsorbanceWavelength, BlankWavelengthResolution, BlankAbsorbanceSamplingRate, BlankUVFilter,
		BlankExcitationWavelength, BlankEmissionWavelength, BlankEmissionCutOffFilter, BlankFluorescenceGain, BlankFluorescenceFlowCellTemperature,
		BlankNebulizerGas, BlankNebulizerGasHeating, BlankNebulizerHeatingPower, BlankNebulizerGasPressure, BlankDriftTubeTemperature, BlankELSDGain, BlankELSDSamplingRate,
		BlankLightScatteringLaserPower, BlankLightScatteringFlowCellTemperature, BlankRefractiveIndexMethod, BlankRefractiveIndexFlowCellTemperature,
		ColumnPrimeAbsorbanceWavelength, ColumnPrimeWavelengthResolution, ColumnPrimeAbsorbanceSamplingRate, ColumnPrimeUVFilter,
		ColumnPrimeExcitationWavelength, ColumnPrimeEmissionWavelength, ColumnPrimeEmissionCutOffFilter, ColumnPrimeFluorescenceGain, ColumnPrimeFluorescenceFlowCellTemperature,
		ColumnPrimeNebulizerGas, ColumnPrimeNebulizerGasHeating, ColumnPrimeNebulizerHeatingPower, ColumnPrimeNebulizerGasPressure, ColumnPrimeDriftTubeTemperature, ColumnPrimeELSDGain, ColumnPrimeELSDSamplingRate,
		ColumnPrimeLightScatteringLaserPower, ColumnPrimeLightScatteringFlowCellTemperature, ColumnPrimeRefractiveIndexMethod, ColumnPrimeRefractiveIndexFlowCellTemperature,
		ColumnFlushAbsorbanceWavelength, ColumnFlushWavelengthResolution, ColumnFlushAbsorbanceSamplingRate, ColumnFlushUVFilter,
		ColumnFlushExcitationWavelength, ColumnFlushEmissionWavelength, ColumnFlushEmissionCutOffFilter, ColumnFlushFluorescenceGain, ColumnFlushFluorescenceFlowCellTemperature,
		ColumnFlushNebulizerGas, ColumnFlushNebulizerGasHeating, ColumnFlushNebulizerHeatingPower, ColumnFlushNebulizerGasPressure, ColumnFlushDriftTubeTemperature, ColumnFlushELSDGain, ColumnFlushELSDSamplingRate,
		ColumnFlushLightScatteringLaserPower, ColumnFlushLightScatteringFlowCellTemperature, ColumnFlushRefractiveIndexMethod, ColumnFlushRefractiveIndexFlowCellTemperature
	};

	(* Get all of the unresolved options *)
	unresolvedOptions = Association[myUnresolvedOptions];

	(* Get the state of the options before the specific instrument specification *)
	preInstrumentOptionResolution = Join[resolvedOptions, KeyTake[SafeOptions[ExperimentHPLC], instrumentSpecificOptions], unresolvedOptions];

	(* Expand the options *)
	expandedPreInstrumentOptions = Association@Last[ExpandIndexMatchedInputs[ExperimentHPLC, {mySamples}, Normal@preInstrumentOptionResolution]];

	(* Get the alternate instruments *)
	alternateInstruments = RestOrDefault[ToList[Lookup[resolvedOptions, Instrument]]];

	(* For each one, we do a new resolution with the instrument switched to the instrument at hand *)
	(* NOTE: we do not ever request the tests here because any offending instruments should have been culled out of the alternate list*)
	alternateInstrumentOptions = If[MatchQ[alternateInstruments, Except[Null | {}]],
		Map[
			Join[
				First@Quiet[resolveHPLCInstrumentOptions[
					mySamples,
					#,
					expandedPreInstrumentOptions,
					cache,
					Output -> Result
				]],
				(* We tag it with the instrument so that we know which it corresponds to *)
				<|Instrument -> #|>
			]&,
			alternateInstruments
		]
	];

	(* Get rid of the links in mySamples. *)
	sampleObjects = mySamples /. {object:ObjectP[] :> Download[object, Object]};

	(* Get our number of replicates. *)
	numberOfReplicates = Lookup[myResolvedOptions, NumberOfReplicates] /. {Null -> 1};

	(* Delete any duplicate input samples to create a single resource per unique sample *)
	uniqueSamples = DeleteDuplicates[sampleObjects];

	(* Create Resource for SamplesIn *)
	uniqueSampleResources = Resource[Sample -> #, Name -> CreateUUID[]]& /@ uniqueSamples;

	(* Expand sample resources to index match mySamples *)
	sampleResources = Map[
		uniqueSampleResources[[First[FirstPosition[uniqueSamples, #]]]]&,
		sampleObjects
	];

	(* Expand our samples and options according to NumberOfReplicates. *)
	{samplesWithReplicates, optionsWithReplicates} = expandNumberOfReplicates[ExperimentHPLC, sampleObjects, myResolvedOptions];

	(* Helper for later use to expand SamplesIn-index-matched options to reflect NumberOfReplicates. This is needed in addition to expandNumberOfReplicates because some of these options (e.g., GradientMethod) have been modified in this resource packets function and can't just be pulled from optionsWithReplicates. *)
	expandForNumberOfReplicates[unexpandedValue_] := Apply[Join, ConstantArray[#, numberOfReplicates]& /@ unexpandedValue];

	(* Extract resolved instrument Object or Model *)
	instrumentObject = FirstOrDefault[ToList[Lookup[resolvedOptions, Instrument]]];

	(* Fetch packet for instrument model *)
	instrumentModelPacket = If[MatchQ[instrumentObject, ObjectP[Model]],
		fetchPacketFromCache[Download[instrumentObject, Object], cache],
		fetchModelPacketFromCacheHPLC[instrumentObject, cache]
	];

	(* Extract model from instrument packet *)
	instrumentModel = Lookup[instrumentModelPacket, Object];

	(* Look up the instrument manufacturer*)
	instrumentManufacturer = Lookup[instrumentModelPacket, Manufacturer] /. x_Link :> Download[x, Object];

	(* Is it a waters instrument? *)
	watersManufacturedQ = MatchQ[instrumentManufacturer, ObjectP[Object[Company, Supplier, "Waters"]]];

	(* Get the Dionex/Agilent HPLC models and create a pattern for them *)
	{availableInstruments,dionexHPLCInstruments,agilentHPLCInstruments,watersHPLCInstruments,testHPLCInstruments}=allHPLCInstrumentSearch["Memoization"];

	dionexHPLCPattern = Alternatives @@ dionexHPLCInstruments;
	agilentHPLCPattern = Alternatives @@ agilentHPLCInstruments;

	(* Look up the column selector *)
	columnSelectorLookup = Lookup[resolvedOptions, ColumnSelector];

	(* Extract resolved Column Object or Model. Put it in a list if it is single. *)
	columnObjects = DeleteDuplicates[
		Cases[
			Flatten[ToList[Lookup[resolvedOptions, {ColumnSelector, Column, SecondaryColumn, TertiaryColumn, GuardColumn}]]],
			Except[Null | ColumnPositionP | ColumnOrientationP]
		]
	];

	(* Look up the guard columns *)
	guardColumns = columnSelectorLookup[[All,2]];

	(* Extract cartridge model packet if guard column option is a cartridge *)
	guardCartridgeModelPackets = Map[
		Switch[#,
			ObjectP[Model[Item, Cartridge, Column]],
			fetchPacketFromCacheHPLC[Download[#, Object], cache],
			ObjectP[Object[Item, Cartridge, Column]],
			fetchModelPacketFromCacheHPLC[Download[#, Object], cache],
			_,
			Null
		]&,
		guardColumns
	];

	(* Extract guard column model packet. If the option was specified as a cartridge, use the first GuardColumn that the cartridge points to. *)
	guardColumnModelPackets = MapThread[
		Switch[#1,
			ObjectP[Model[Item, Column]],
			fetchPacketFromCacheHPLC[Download[#1, Object], cache],
			ObjectP[Object[Item, Column]],
			fetchModelPacketFromCacheHPLC[Download[#1, Object], cache],
			ObjectP[{Model[Item, Cartridge, Column], Object[Item, Cartridge, Column]}],
			fetchPacketFromCacheHPLC[Download[Lookup[#2, PreferredGuardColumn], Object], cache],
			_,
			Null
		]&,
		{guardColumns, guardCartridgeModelPackets}
	];

	(* Split the columns and the objects *)
	{guardColumnObjects, guardCartridgeObjects} = If[Length[guardColumnModelPackets] >= 1,
		Transpose[
			MapThread[
				Function[
					{guardColumnLookup, guardColumnPacket},
					Switch[guardColumnLookup,
						None | Null, {Null, Null},
						ObjectP[{Model[Item, Column], Object[Item, Column]}], {guardColumnLookup, Lookup[guardColumnPacket, PreferredGuardCartridge]},
						ObjectP[{Model[Item, Cartridge, Column], Object[Item, Cartridge, Column]}], {Lookup[guardColumnPacket, Object], guardColumnLookup}
					]
				],
				{
					guardColumns,
					guardColumnModelPackets
				}
			]
		],
		{
			{Null}, {Null}
		}
	];


	(* Now we need to map through and add joins for all of the guards and columns *)
	columnSelectorWithJoins = If[MatchQ[columnSelectorLookup, Except[{}|ListableP[Null]]],
		MapThread[
			Function[{columnTuple, guardColumn},
				(* We return a tuple of length 10; where the joins are interdigitated within *)
				{
					(* First we have the column Position *)
					columnTuple[[1]],
					(* Guard Column - Switch to the correct column - instead of using the Guard Cartridge. Because our options are resolved, GuardColumn must match the column selector *)
					guardColumn,
					(* Now we add GuardColumnOrientation *)
					columnTuple[[3]],
					(* GuardColumnJoin *)
					Switch[
						Prepend[columnTuple[[{4, 6, 7}]], guardColumn],
						(* If there is no guard column or column after, then no join needed*)
						{Null, _, _, _}, Null,
						{_, Null, Null, Null}, Null,
						(* Otherwise, we'll select it out of the packet *)
						{ObjectP[Object], _, _, _},
						Lookup[fetchModelPacketFromCacheHPLC[Download[guardColumn, Object], cache], PreferredColumnJoin, Null],
						{ObjectP[Model], _, _, _},
						Lookup[fetchPacketFromCache[Download[guardColumn, Object], cache], PreferredColumnJoin, Null]
					],
					(* Column *)
					columnTuple[[4]],
					(* ColumnOrientation *)
					columnTuple[[5]],
					(* PrimaryColumnJoin *)
					Switch[columnTuple[[{4, 6, 7}]],
						(* If there is no column or column after, then no join needed *)
						{Null, _, _}, Null,
						{_, Null, Null}, Null,
						(* Otherwise, take the default *)
						{ObjectP[], _, _}, Model[Plumbing, ColumnJoin, "id:bq9LA0J98evL"]
					],
					(* SecondaryColumn *)
					columnTuple[[6]],
					(* SecondaryColumnJoin *)
					Switch[columnTuple[[6 ;; 7]],
						(* If there is no column or column after, then no join needed *)
						{Null, _}, Null,
						{_, Null}, Null,
						(* Otherwise, take the default *)
						{ObjectP[], _}, Model[Plumbing, ColumnJoin, "id:bq9LA0J98evL"]
					],
					(* TertiaryColumn *)
					columnTuple[[7]]
				}
			],
			{columnSelectorLookup, guardColumnObjects}
		],
		Null
	];

	(* Now, we convert everything to a resource within the selector *)
	(* We can use multiple columns of the same model, so a separate resource is needed for each *)
	columnSelectorResources = If[MatchQ[columnSelectorWithJoins, Except[{}|ListableP[Null]]],
		MapIndexed[
			Function[
				{tuple, tupleIndex},
				(* The map across the each entity within to make our resource *)
				MapThread[
					Function[
						{entity, letter},
						If[!NullQ[entity],
							If[MatchQ[entity, ColumnPositionP | ColumnOrientationP], (* Check if the entity within the tuple is an BlahColumnOrientation or ColumnPosition *)
								entity,
								Link[Resource[
									Sample -> entity,
									Name -> "Column Selector entity " <> ToString[tupleIndex] <> letter
								]]
							],
							(* Otherwise return Null *)
							Null
						]
					],
					{
						tuple,
						(* We use the letters to help with the labeling within the tuple resource *)
						{"A", "B", "C", "D", "E", "F", "G", "H", "I", "J"}
					}
				]
			],
			columnSelectorWithJoins
		],
		Null
	];

	(* Finally make our uploadable column selector table *)
	columnSelectorUploadable = If[MatchQ[columnSelectorResources, Except[{}|ListableP[Null]]],
		MapThread[
			Function[
				{columnPosition, guardColumn, gcOrientation, gcJoin, primColumn, pcOrientation, pcJoin, secondColumn, scJoin, thirdColumn},
				Association[
					ColumnPosition -> columnPosition,
					GuardColumn -> guardColumn,
					GuardColumnOrientation -> gcOrientation,
					GuardColumnJoin -> gcJoin,
					Column -> primColumn,
					ColumnOrientation -> pcOrientation,
					ColumnJoin -> pcJoin,
					SecondaryColumn -> secondColumn,
					SecondaryColumnJoin -> scJoin,
					TertiaryColumn -> thirdColumn
				]
			],
			Transpose[columnSelectorResources]
		],
		{}
	];

	(* Get the guard columns, which is just the first column of the selector resources *)
	guardColumnResources = If[MatchQ[columnSelectorResources, Except[{}|ListableP[Null]]],
		columnSelectorResources[[All, 2]],
		{}
	];

	(* Make Column Holder Resources, if we need them *)
	columnHolderResources = If[MatchQ[Lookup[myResolvedOptions, IncubateColumn], False],
		{
			Resource[
				Sample -> Model[Item, ColumnHolder, "id:xRO9n3BrjqJO"],
				Name -> "Column Holder 1 " <> CreateUUID[],
				Rent -> True
			],
			Resource[
				Sample -> Model[Item, ColumnHolder, "id:xRO9n3BrjqJO"],
				Name -> "Column Holder 2 " <> CreateUUID[],
				Rent -> True
			],
			Resource[
				Sample -> Model[Item, ColumnHolder, "id:xRO9n3BrjqJO"],
				Name -> "Column Holder 3 " <> CreateUUID[],
				Rent -> True
			]
		},
		Null
	];

	(* Make the guard cartridge resources *)
	(* Need to do it here since we want to empty out GuardCartridge is we don't have column *)
	guardCartridgeResources = If[NullQ[columnSelectorResources],
		{},
		Map[
			If[!NullQ[#],
				Link@Resource[
					Sample -> #
				],
				Null
			]&,
			guardCartridgeObjects
		]
	];


	(* Get the resolved injection table because that will actually determine much that we do here *)
	injectionTable = Lookup[myResolvedOptions, InjectionTable];

	(* Get all of the positions so that it's easy to update the injection table *)
	{samplePositions, standardPositions, blankPositions, columnPrimePositions, columnFlushPositions} = Map[
		Sequence @@@ Position[injectionTable, {#, ___}]&,
		{Sample, Standard, Blank, ColumnPrime, ColumnFlush}
	];

	(* Make all of the resources for standard, blank, samples *)

	(* Depending on instrument model, different vial type is compatible. *)
	compatibleVialContainer = If[MatchQ[instrumentModel,agilentHPLCPattern],
		(* "50mL Tube" *)
		{Model[Container, Vessel, "id:bq9LA0dBGGR6"]},
		(* {"HPLC vial (high recovery)", "1mL HPLC Vial (total recovery)", "Amber HPLC vial (high recovery)", "HPLC vial (high recovery), LCMS Certified"} *)
		{Model[Container, Vessel, "id:jLq9jXvxr6OZ"], Model[Container, Vessel, "id:1ZA60vL48X85"], Model[Container, Vessel, "id:GmzlKjznOxmE"], Model[Container, Vessel, "id:3em6ZvL8x4p8"]}
	];

	(* Set autosampler dead volume (following the same number as in the resolver *)
	autosamplerDeadVolume = Which[
		internalUsageQ, 40 Microliter,
		(* Model[Instrument, HPLC, "Agilent 1290 Infinity II LC System"] has a larger dead volume *)
		MatchQ[instrumentModel,agilentHPLCPattern],
		5 Milliliter,
		True, 40 Microliter
	];

	(* Fetch container vial's min and max volume *)
	vialContainerMaxVolume = Lookup[fetchPacketFromCache[#, cache], MaxVolume]& /@ compatibleVialContainer;

	(* Determine how much sample can be expected to reliably be injected per vial *)
	vialSampleMaxVolume = (vialContainerMaxVolume - autosamplerDeadVolume);

	(* Get the standard samples out *)
	standardTuples = (injectionTable[[standardPositions]])/.{object:ObjectP[]:>Download[object,Object]};

	(* Assign the position to these *)
	assignedStandardTuples = MapThread[#1 -> #2&, {standardPositions, standardTuples}];

	(* Then group by the sample object (e.g. <|standard1->{1->{Standard,standard1,10 Microliter,__},2->{Standard,standard1, 5 Microliter,__}}, standard2 ->... |> *)
	groupedStandardsTuples = GroupBy[assignedStandardTuples, Last[#][[2]]&];

	(* Then simplify further by selecting out the positoin and the injection volume <|standard1->{{1,10 Microliter},{2,5 Microliter}} *)
	groupedStandardsPositionVolumes = Map[
		Function[
			{eachUniqueStandard},
			Transpose[
				{
					Keys[eachUniqueStandard],
					(* Injection volume still at this position *)
					Values[eachUniqueStandard][[All, 3]]
				}
			]
		],
		groupedStandardsTuples
	];

	(* We do a further grouping based on the total injection volume for example: <|Model[Sample, StockSolution, Standard, "1234"] -> {{{3, Quantity[2, "Microliters"]}}, {{7,  Quantity[2, "Microliters"]}}}, ...|> *)
	(* Fill to 90% of the max volume of the container *)
	groupedStandardShared = Map[GroupByTotal[#, Max[vialSampleMaxVolume] * 0.9 - autosamplerDeadVolume]&, groupedStandardsPositionVolumes];

	(* Now we can finally make the resources *)
	(* We'll be left with a list of positions to a resource e.g. {{1,2}->Resource1,{3,4,5}->Resource2} *)
	groupedStandard = Map[
		Function[
			{rule},
			Sequence @@ Map[
				(* This is all of the positions *)
				(
					#[[All, 1]] ->
					Resource[
						Sample -> First[rule],
						(* Total the volume for the given group *)
						Amount -> Round[(Total[#[[All, 2]]] + autosamplerDeadVolume)/0.9,0.1Milliliter],
						Container -> PickList[compatibleVialContainer, vialSampleMaxVolume, GreaterEqualP[(Total[#[[All, 2]]] + autosamplerDeadVolume)/0.9]],
						Name -> CreateUUID[]
					]
				)&,
				Last[rule]
			]
		],
		(* Convert to a list *)
		Normal[groupedStandardShared]
	];

	(* Now we can flatten this list to our standards, index matched to the samples {1->Resource1, 2->Resource1, ... } *)
	flatStandardResources = SortBy[
		Map[
			Function[
				{rule},
				Sequence @@ Map[# -> Last[rule]&, First[rule]]
			],
			groupedStandard
		],
		First
	];

	(* Take the values and surround with Link *)
	linkedStandardResources = Map[Link, Values[flatStandardResources]];

	(* Do the same with the blanks *)

	(* Get the blank samples out *)
	blankTuples = injectionTable[[blankPositions]]/.{object:ObjectP[]:>Download[object,Object]};

	(* Assign the position to these *)
	assignedBlankTuples = MapThread[#1 -> #2&, {blankPositions, blankTuples}];

	(* Then group by the sample sample type (e.g. <|blank1->{1->{Blank,blank1,10 Microliter,__},2->{Blank,blank1, 5 Microliter,__}}, blank2 ->... |> *)
	groupedBlanksTuples = GroupBy[assignedBlankTuples, Last[#][[2]]&];

	(* Then simplify further by selecting out the positoin and the injection volume <|blank1->{{1,10 Microliter},{2,5 Microliter}} *)
	groupedBlanksPositionVolumes = Map[
		Function[
			{eachUniqueBlank},
			Transpose[
				{
					Keys[eachUniqueBlank],
					(* Injection volume still at this position *)
					Values[eachUniqueBlank][[All, 3]]
				}
			]
		],
		groupedBlanksTuples
	];

	(* We do a further grouping based on the total injection volume for example: <|Model[Sample, StockSolution, "1234"] -> {{{3, Quantity[2, "Microliters"]}}, {{7,  Quantity[2, "Microliters"]}}}, ...|>*)
	(* Fill to 90% of the max volume of the container *)
	groupedBlankShared = Map[GroupByTotal[#, Max[vialSampleMaxVolume] * 0.9 - autosamplerDeadVolume]&, groupedBlanksPositionVolumes];

	(* Now we can finally make the resources *)
	(* We'll be left with a list of positions to a resource e.g. {{1,2}->Resource1,{3,4,5}->Resource2} *)
	groupedBlank = Map[
		Function[
			{rule},
			Sequence @@ Map[
				(* This is all of the positions *)
				(
					#[[All, 1]] ->
							Resource[
								Sample -> First[rule],
								(* Total the volume for the given group *)
								Amount -> Round[(Total[#[[All, 2]]] + autosamplerDeadVolume)/0.9,0.1Milliliter],
								Container -> PickList[compatibleVialContainer, vialSampleMaxVolume, GreaterEqualP[(Total[#[[All, 2]]] + autosamplerDeadVolume)/0.9]],
								Name -> CreateUUID[]
							]
				)&,
				Last[rule]
			]
		],
		(* Convert to a list *)
		Normal[groupedBlankShared]
	];

	(* Now we can flatten this list to our blanks, index matched to the samples {1->Resource1, 2->Resource1, ... } *)
	flatBlankResources = SortBy[
		Map[
			Function[
				{rule},
				Sequence @@ Map[# -> Last[rule]&, First[rule]]
			],
			groupedBlank
		],
		First
	];

	(* Take the values and surround with Link *)
	linkedBlankResources = Map[Link, Values[flatBlankResources]];

	(* Now let's update everything within our injection table *)
	linkedSampleResources = Link /@ sampleResources;

	(* We need to create a mapping association so the index matching from the types goes to the positions with the table.
	For example, the resolvedBlank maybe length 2 (e.g. {blank1,blank2}; However this may be repeated in the injectiontable based on the set BlankFrequency. For example BlankFrequency -> FirstAndLast will place at the beginning at the end therefore, we need to have associations for each that points to the locations within the table so that it's easier to update the resources*)

	(* A helper function used to make the reverse dictionary so that we can go from the injection table position to the other variables *)
	makeReverseAssociation[inputAssociation : Null] := Null;
	makeReverseAssociation[inputAssociation_Association] := Association[
		SortBy[
			Flatten@Map[
				Function[{rule},
					Map[# -> First[rule]&, Last[rule]]
				],
				Normal@inputAssociation
			],
			First
		]
	];

	(* Look up the standards and the blanks*)
	{standardLookup, blankLookup} = ToList /@ Lookup[myResolvedOptions, {Standard, Blank}];

	(* First do the standards *)
	standardMappingAssociation = If[MatchQ[standardLookup, Null | {Null} | {}],
		(* First check whether there is anything here *)
		Null,
		(* Otherwise we have to partition the positions by the length of our standards and map through *)
		Association[
			MapIndexed[
				Function[
					{positionSet, index},
					First[index] -> positionSet
				],
				Transpose[
					Partition[standardPositions, Length[standardLookup]]
				]
			]
		]
	];

	(* Do the blanks in the same way *)
	blankMappingAssociation = If[MatchQ[blankLookup, Null | {Null} | {}],
		(* First check whether there is anything here *)
		Null,
		(* Otherwise we have to partition the positions by the length of our standards and map through *)
		Association[
			MapIndexed[
				Function[
					{positionSet, index},
					First[index] -> positionSet
				],
				Transpose[
					Partition[blankPositions, Length[blankLookup]]
				]
			]
		]
	];

	(* For the column prime and flush, it's a bit easier because we can simply considering by the column (position) *)
	columnPrimeMappingAssociation = Association[
		MapIndexed[
			Function[{columnTuple, index},
				First[index] -> Sequence @@@ Position[injectionTable, {ColumnPrime, _, _, columnTuple[[1]], _, _}]
			],
			columnSelectorLookup
		]
	];

	columnFlushMappingAssociation = Association[
		MapIndexed[
			Function[{columnTuple, index},
				First[index] -> Sequence @@@ Position[injectionTable, {ColumnFlush, _, _, columnTuple[[1]], _, _}]
			],
			columnSelectorLookup
		]
	];

	(* Make the reverse associations *)
	{standardReverseAssociation, blankReverseAssociation, columnPrimeReverseAssociation, columnFlushReverseAssociation} = Map[makeReverseAssociation,
		{standardMappingAssociation, blankMappingAssociation, columnPrimeMappingAssociation, columnFlushMappingAssociation}
	];

	(* Also make the one for the samples *)
	sampleReverseAssociation = Association[
		MapIndexed[
			Function[
				{position, index},
				position -> First[index]
			],
			samplePositions
		]
	];

	(* To fill in the parameters we just need the injection table positions corresponded to the pertinent ones *)
	standardPositionsCorresponded = If[Length[standardPositions] > 0, Last /@ SortBy[Normal@standardReverseAssociation, First]];
	blankPositionsCorresponded = If[Length[blankPositions] > 0, Last /@ SortBy[Normal@blankReverseAssociation, First]];
	columnPrimePositionsCorresponded = If[Length[columnPrimePositions] > 0, Last /@ SortBy[Normal@columnPrimeReverseAssociation, First], {}];
	columnFlushPositionsCorresponded = If[Length[columnFlushPositions] > 0, Last /@ SortBy[Normal@columnFlushReverseAssociation, First], {}];

	(* Initialize our injectionTable with links *)
	injectionTableWithLinks = injectionTable;

	(* Update all of the samples *)
	injectionTableWithLinks[[samplePositions, 2]] = linkedSampleResources;
	injectionTableWithLinks[[standardPositions, 2]] = linkedStandardResources;
	injectionTableWithLinks[[blankPositions, 2]] = linkedBlankResources;

	(* There is no need to update Type, InjectionVolume, ColumnPosition, ColumnTemperature since they don't need resources and can directly use resource values *)

	(* We need to figure out which gradients to make *)
	(* Dereference any named objects *)
	(* Gradient is column 6 of injection table *)
	tableGradients = injectionTable[[All, 6]] /. {x : ObjectP[Object[Method]] :> Download[x, Object]};

	(* Change all of the gradients to links *)
	injectionTableWithLinks[[All, 6]] = (Link /@ tableGradients);

	(* First append Nulls to all of the rows to initialize the DilutionFactor *)
	injectionTableFull = Map[
		PadRight[#, 7, Null]&,
		injectionTableWithLinks
	];

	(* Pull out the resolved AliquotAmount and AssayVoluallGradientTuplesme options *)
	{resolvedAliquotAmount, resolvedAssayVolume} = Lookup[expandedPreInstrumentOptions, {AliquotAmount, AssayVolume}];

	(* Get the dilution factor if both volumes exist *)
	dilutionFactors = MapThread[
		Function[
			{aliquotAmount, assayVolume},
			If[VolumeQ[aliquotAmount] && VolumeQ[assayVolume],
				assayVolume / aliquotAmount,
				Null
			]
		],
		{resolvedAliquotAmount, resolvedAssayVolume}
	];

	(* Populate the DilutionFactor into the InjectionTable *)
	injectionTableFull[[samplePositions, 7]] = dilutionFactors;

	(* We'll need to use number of replicates to expand the effective injection table *)
	(* Get all of the sample tuples *)
	sampleTuples = injectionTableFull[[samplePositions]];

	(* Make our insertion association (e.g. in the format of position to be inserted (P) and list to be inserted <|2 -> {{Sample,sample1,___}...},...|> *)
	(* Make sure the same samples are grouped together by adding index to position *)
	insertionAssociation = MapThread[
		Function[
			{position, tuple, index},
			(position + index - 1) -> ConstantArray[tuple, numberOfReplicates - 1]
		],
		{samplePositions, sampleTuples, Range[1, Length[samplePositions]]}
	];

	(* Fold through and insert these tuples into our injection table *)
	injectionTableInserted = If[numberOfReplicates > 1,
		Fold[
			Insert[#1, Last[#2], First[#2]]&,
			injectionTableFull,
			insertionAssociation
		],
		injectionTableFull
	];

	(* Flatten and reform our injection table *)
	injectionTableWithReplicates = Partition[Flatten[injectionTableInserted], 7];

	(* Finally make our uploadable injection table *)
	injectionTableUploadable = MapThread[
		Function[{type, sample, injectionVolume, columnPosition, columnTemperature, gradient, dilutionFactor},
			Association[
				Type -> type,
				Sample -> sample,
				InjectionVolume -> injectionVolume,
				ColumnPosition -> columnPosition,
				ColumnTemperature -> columnTemperature /. {Ambient -> $AmbientTemperature},
				Gradient -> gradient,
				DilutionFactor -> dilutionFactor,
				Data -> Null
			]
		],
		Transpose[injectionTableWithReplicates]
	];

	(* Update the sample position with replicates *)
	samplePositionsWithReplicates = Sequence @@@ Position[injectionTableWithReplicates, {Sample, ___}];

	(* Get all of the other gradient options and see how many of them are objects *)
	{sampleGradient, standardGradient, blankGradient, columnPrimeGradient, columnFlushGradient} = Lookup[myResolvedOptions,
		{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}
	];
	(* Combine all the gradients *)
	resolvedGradients = Join@@Cases[{sampleGradient, standardGradient, blankGradient, columnPrimeGradient, columnFlushGradient}, Except[Null|{Null}]];

	(* Find all of the gradients where there is already a method *)
	gradientMethodInPlace = Flatten[Cases[resolvedGradients, ListableP[ObjectP[Object[Method]]]]] /. {x : ObjectP[] :> Download[x, Object]};

	(* Take the complement of the table gradients and the ones already in place *)
	(* We'll need to create packets for all of these gradient objects *)
	gradientObjectsToMake = Complement[tableGradients, gradientMethodInPlace];

	(* Set BufferA's model based on resolved value or Downloaded value *)
	bufferAModel = If[MatchQ[Lookup[resolvedOptions, BufferA], ObjectP[Model]],
		Lookup[resolvedOptions, BufferA],
		Download[fetchModelPacketFromCacheHPLC[Lookup[resolvedOptions, BufferA], cache], Object]
	];

	(* Set BufferB's model based on resolved value or Downloaded value *)
	bufferBModel = If[MatchQ[Lookup[resolvedOptions, BufferB], ObjectP[Model]],
		Lookup[resolvedOptions, BufferB],
		Download[fetchModelPacketFromCacheHPLC[Lookup[resolvedOptions, BufferB], cache], Object]
	];

	(* Set BufferC's model based on resolved value or Downloaded value *)
	bufferCModel = If[MatchQ[Lookup[resolvedOptions, BufferC], ObjectP[Model]],
		Lookup[resolvedOptions, BufferC],
		Download[fetchModelPacketFromCacheHPLC[Lookup[resolvedOptions, BufferC], cache], Object]
	];

	(* Set BufferD's model based on resolved value or Downloaded value *)
	bufferDModel = If[MatchQ[Lookup[resolvedOptions, BufferD], ObjectP[Model] | Null],
		Lookup[resolvedOptions, BufferD],
		Download[fetchModelPacketFromCacheHPLC[Lookup[resolvedOptions, BufferD], cache], Object]
	];

	(* Map through and make a gradient for each based on the object ID *)
	uniqueGradientPackets = Map[
		Function[
			{gradientObjectID},
			Module[
				{injectionTablePosition, currentType, currentGradientLookup, currentGradientTuple, refractiveIndexReferenceLoading, currentGradientDownload, currentGradientLoading},

				(* Find the injection Table position *)
				injectionTablePosition = First[FirstPosition[tableGradients, gradientObjectID]];

				(* Figure out the type, based on which, look up the gradient tuple *)
				currentType = First[injectionTable[[injectionTablePosition]]];

				(* Get the gradient based on the type and the position *)
				currentGradientLookup = Switch[currentType,
					Sample, ToList[sampleGradient][[injectionTablePosition /. sampleReverseAssociation]],
					Standard, ToList[standardGradient][[injectionTablePosition /. standardReverseAssociation]],
					Blank, ToList[blankGradient][[injectionTablePosition /. blankReverseAssociation]],
					ColumnPrime, ToList[columnPrimeGradient][[injectionTablePosition /. columnPrimeReverseAssociation]],
					ColumnFlush, ToList[columnFlushGradient][[injectionTablePosition /. columnFlushReverseAssociation]]
				];

				(* Make sure we get the gradient tuple. If we have a template gradient but changed something in it, we may still get an object from the step above but will have to change it to the gradient before moving to make new objects - also need to add an additional column for the case of missing RefractiveIndexReferenceLoading *)
				currentGradientDownload = If[MatchQ[currentGradientLookup, ObjectP[Object[Method, Gradient]]],
					Lookup[fetchPacketFromCacheHPLC[currentGradientLookup, cache], Gradient],
					Null
				];

				currentGradientLoading = If[MatchQ[currentGradientLookup, ObjectP[Object[Method, Gradient]]],
					Lookup[fetchPacketFromCacheHPLC[currentGradientLookup, cache], RefractiveIndexReferenceLoading, {}],
					Null
				];

				(* Add reference loading info to the gradient or keep it if it's already in good shape*)
				currentGradientTuple = Which[
					MatchQ[currentGradientLookup, ObjectP[Object[Method, Gradient]]],
					If[MatchQ[currentGradientLoading, Null | {}],
						Map[Append[#, Null]&, currentGradientDownload],
						MapThread[Append[#1, #2]&, {currentGradientDownload, currentGradientLoading}]
					],
					(*  If it's from LCMS, the gradient is missing the reference loading info *)
					MatchQ[currentGradientLookup, gradientP],
					Map[Append[#, Null]&, currentGradientLookup],
					True, currentGradientLookup
				];

				(* Get the refractive index reference loading status. If Refractive Index is not requested as a detector, use Null *)
				refractiveIndexReferenceLoading = If[MemberQ[Lookup[resolvedOptions, Detector], RefractiveIndex],
					ReplaceAll[currentGradientTuple[[All, -1]], None -> Null],
					{}
				];

				(* Make the gradient packet *)
				<|
					Object -> gradientObjectID,
					Type -> Object[Method, Gradient],
					BufferA -> Link@bufferAModel,
					BufferB -> Link@bufferBModel,
					BufferC -> Link@bufferCModel,
					BufferD -> Link@bufferDModel,
					GradientA -> currentGradientTuple[[All, {1, 2}]],
					GradientB -> currentGradientTuple[[All, {1, 3}]],
					GradientC -> currentGradientTuple[[All, {1, 4}]],
					GradientD -> currentGradientTuple[[All, {1, 5}]],
					FlowRate -> currentGradientTuple[[All, {1, -2}]],
					EquilibrationTime -> If[currentGradientTuple[[1, 2 ;; 5]] == currentGradientTuple[[2, 2 ;; 5]],
						currentGradientTuple[[2, 1]] - currentGradientTuple[[1, 1]],
						Null
					],
					FlushTime -> If[currentGradientTuple[[-1, 2 ;; 5]] == currentGradientTuple[[-2, 2 ;; 5]] && (Length[currentGradientTuple] > 2),
						currentGradientTuple[[-1, 1]] - currentGradientTuple[[-2, 1]],
						Null
					],
					Replace[Gradient] -> If[MatchQ[currentGradientTuple[[All, 1 ;; -2]], expandedGradientP],
						(* If it's already expanded, nothing to do *)
						currentGradientTuple[[All, 1 ;; -2]],
						(* Otherwise, we insert 4 more columns *)
						Transpose@Nest[Insert[#, Repeat[0 Percent, Length[currentGradientTuple]], -2] &, Transpose@currentGradientTuple[[All, 1 ;; -2]], 4]
					],
					Replace[RefractiveIndexReferenceLoading] -> refractiveIndexReferenceLoading,
					InitialFlowRate -> currentGradientTuple[[1, -2]],
					(* Get our column temperature *)
					Temperature -> injectionTable[[injectionTablePosition]][[5]] /. {Ambient -> $AmbientTemperature}
				|>
			]
		],
		gradientObjectsToMake
	];


	(* Look everything up in the cache and extract out the gradient tuples for run time estimate and buffer resource volume estimate *)
	allGradientTuples = Map[
		Function[{gradientObject},
			Lookup[
				fetchPacketFromCache[gradientObject, Join[cache, uniqueGradientPackets]],
				Gradient,
				(* Otherwise check if there is a Replace *)
				Lookup[fetchPacketFromCache[gradientObject, Join[cache, uniqueGradientPackets]], Replace[Gradient]]
			]
		],
		Download[injectionTableWithReplicates[[All, 6]], Object]
	];

	(* Extract packets for sample objects *)
	samplePackets = fetchPacketFromCacheHPLC[#, cache]& /@ samplesWithReplicates;

	(* Extract SamplesIn containers *)
	sampleContainers = Download[Lookup[samplePackets, Container], Object];

	(* Also get AliquotContainers *)
	aliquotContainers = Lookup[optionsWithReplicates, AliquotContainer];

	(* Get the lowest max column pressure. (This field is required by VOQ.) *)
	maxColumnPressure = If[Count[columnObjects, Except[Null]] > 0,
		Min[
			Map[
				If[MatchQ[#, ObjectP[Object]],
					Lookup[fetchModelPacketFromCacheHPLC[#, cache], MaxPressure],
					Lookup[fetchPacketFromCacheHPLC[#, cache], MaxPressure]
				]&,
				columnObjects
			]
		],
		Null
	];

	(* For runs that are collecting fractions, build fraction collection method packet *)
	fractionPackets = MapThread[
		Function[
			{
				collectFractions,
				fractionCollectionMethod,
				fractionCollectionMode,
				fractionCollectionStartTime,
				fractionCollectionEndTime,
				maxFractionVolume,
				maxCollectionPeriod,
				absoluteThreshold,
				peakEndThreshold,
				peakSlope,
				peakSlopeDuration
			},
			If[TrueQ[collectFractions],
				If[MatchQ[fractionCollectionMethod, ObjectP[]],
					Association[
						Type -> Object[Method, FractionCollection],
						Object -> Download[fractionCollectionMethod, Object]
					],
					Association[
						Type -> Object[Method, FractionCollection],
						Object -> CreateID[Object[Method, FractionCollection]],
						FractionCollectionMode -> fractionCollectionMode,
						FractionCollectionDetector -> Lookup[myResolvedOptions, FractionCollectionDetector],
						FractionCollectionStartTime -> fractionCollectionStartTime,
						FractionCollectionEndTime -> fractionCollectionEndTime,
						MaxFractionVolume -> maxFractionVolume,
						MaxCollectionPeriod -> maxCollectionPeriod,
						AbsoluteThreshold -> absoluteThreshold,
						PeakEndThreshold -> peakEndThreshold,
						PeakSlope -> peakSlope,
						PeakSlopeDuration -> peakSlopeDuration
					]
				],
				Null
			]
		],
		Replace[
			Lookup[
				optionsWithReplicates,
				{
					CollectFractions,
					FractionCollectionMethod,
					FractionCollectionMode,
					FractionCollectionStartTime,
					FractionCollectionEndTime,
					MaxFractionVolume,
					MaxCollectionPeriod,
					AbsoluteThreshold,
					PeakEndThreshold,
					PeakSlope,
					PeakSlopeDuration
				}
			],
			Null -> {},
			{1}
		]
	];

	(* Fetch existing method objects *)
	existingFractionCollectionMethods = Download[
		Cases[Lookup[optionsWithReplicates, FractionCollectionMethod], ObjectP[]],
		Object
	];

	(* Extract new packets to upload *)
	newFractionPackets = Select[
		Cases[fractionPackets, ObjectP[]],
		!MemberQ[existingFractionCollectionMethods, Download[#, Object]]&
	];

	(* SystemPrimeGradients stores an list of tuples associating a chromatography type with a gradient (in the form: {type, gradient method}) *)
	systemPrimeGradientObject = FirstCase[
		Lookup[instrumentModelPacket, SystemPrimeGradients],
		{Lookup[resolvedOptions, SeparationMode], gradObject : ObjectP[]} :> Download[gradObject, Object]
	];

	(* Fetch packet for model instrument's system prime gradient *)
	systemPrimeGradientPacket = fetchPacketFromCacheHPLC[systemPrimeGradientObject, cache];

	(* SystemFlushGradients stores an list of tuples associating a chromatography type with a gradient (in the form: {type, gradient method}) *)
	systemFlushGradientObject = FirstCase[
		Lookup[instrumentModelPacket, SystemFlushGradients],
		{Lookup[resolvedOptions, SeparationMode], gradObject : ObjectP[]} :> Download[gradObject, Object]
	];

	(* Fetch packet for model instrument's system prime gradient *)
	systemFlushGradientPacket = fetchPacketFromCacheHPLC[systemFlushGradientObject, cache];

	(* Create gradient packet for Shutdown (Dionex machine needs this shutdown method) *)
	(* Prepare the shutdown method by getting some info from the last ColumnFlush *)
	(* Start with the column flush *)
	{
		columnFlushFlowRates,
		columnFlushTemperatures
	}=Map[
		Function[
			{optionLookup},
			If[!NullQ[columnFlushPositionsCorresponded]&&Not[MatchQ[columnFlushPositionsCorresponded,{}]],
				optionLookup[[DeleteDuplicates[columnFlushPositionsCorresponded]]]
			]
		],
		Lookup[
			myResolvedOptions,
			{
				ColumnFlushFlowRate,
				ColumnFlushTemperature
			}
		]
	];

	(* Split the field to be Constant or Variable *)
	columnFlushFlowRatesConstant = Map[
		If[MatchQ[#,GreaterEqualP[(0 * Milli * Liter) / Minute]],
			#,
			Null
		]&,
		columnFlushFlowRates
	];

	columnFlushFlowRatesVariable = Map[
		If[MatchQ[#,ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}]],
			#,
			Null
		]&,
		columnFlushFlowRates
	];

	(* Then the column prime *)
	{
		columnPrimeFlowRates,
		columnPrimeTemperatures
	}=Map[
		Function[
			{optionLookup},
			If[!NullQ[columnPrimePositionsCorresponded]&&Not[MatchQ[columnPrimePositionsCorresponded,{}]],
				optionLookup[[DeleteDuplicates[columnPrimePositionsCorresponded]]]
			]
		],
		Lookup[myResolvedOptions,
			{
				ColumnPrimeFlowRate,
				ColumnPrimeTemperature
			}
		]
	];

	(* Split the field to be Constant or Variable *)
	columnPrimeFlowRatesConstant = Map[
		If[MatchQ[#,GreaterEqualP[(0 * Milli * Liter) / Minute]],
			#,
			Null
		]&,
		columnPrimeFlowRates
	];

	columnPrimeFlowRatesVariable = Map[
		If[MatchQ[#,ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}]],
			#,
			Null
		]&,
		columnPrimeFlowRates
	];

	(* Get the Initial FlowRate of the last ColumnFlush or ColumnPrime - if ColumnPrime is specified as frequency, it will serve as a flush *)
	columnFlushInitialFlowRate = Which[
		!NullQ[columnFlushFlowRates], Last[columnFlushFlowRates],
		!NullQ[columnPrimeFlowRates], Last[columnPrimeFlowRates],
		True, 1Milliliter / Minute
	];

	(* Put together the Shutdown gradient *)
	shutdownGradient = If[MatchQ[instrumentModel, ObjectP[dionexHPLCInstruments]],
		Association[
			Type -> Object[Method, Gradient],
			Object -> CreateID[Object[Method, Gradient]],
			(* Because we have ColumnSelector and potentially multiple sets of Columns, use the last one for ShutDown *)
			Temperature -> LastOrDefault[Cases[injectionTable, {ColumnFlush, ___}][[All, 5]],
				LastOrDefault[Cases[injectionTable, {ColumnPrime, ___}][[All, 5]],Ambient]] /. {Ambient | Null -> $AmbientTemperature},
			InitialFlowRate -> columnFlushInitialFlowRate,
			BufferA -> Link[bufferAModel],
			BufferB -> Link[bufferBModel],
			BufferC -> Link[bufferCModel],
			Replace[Gradient] -> {
				{0 Minute, 0 Percent, 0 Percent, 100 Percent, 0 Percent, 0 Percent, 0 Percent, 0 Percent, 0 Percent, columnFlushInitialFlowRate},
				{0.1 Minute, 0 Percent, 0 Percent, 100 Percent, 0 Percent, 0 Percent, 0 Percent, 0 Percent, 0 Percent, columnFlushInitialFlowRate}
			}
		],
		Null
	];

	(* Get the shutdown program name based on the protocol info *)
	shutdownFileName = If[NullQ[shutdownGradient],
		Null,
		StringJoin[
			"Shutdown_",
			ToString[(Length[injectionTableUploadable] + 1)],
			"_",
			ObjectToFilePath[shutdownGradient, FastTrack -> True],
			"_",
			StringReplace[ToString[Unitless[N[260 * Nanometer]]], "." -> "_"],
			If[MemberQ[Lookup[resolvedOptions, Detector], Fluorescence],
				"_Fluorescence",
				""
			],
			If[MemberQ[Lookup[resolvedOptions, Detector], pH],
				"_pH",
				""
			],
			If[MemberQ[Lookup[resolvedOptions, Detector], Conductance],
				"_Conductivity",
				""
			]
		]
	];

	(* Determine entire runtime based on duration of all gradients run *)
	(* Add the time of pHCalibration and/or ConductivityCalibration because that requires instrument as well *)
	totalRunTime = Total[
		Join[
			Max /@ Unitless[allGradientTuples[[All, All, 1]], Minute],
			{
				If[TrueQ[Lookup[resolvedOptions, pHCalibration]],
					(* 1 Hr for pH Calibration *)
					60,
					0
				],
				If[TrueQ[Lookup[resolvedOptions, ConductivityCalibration]],
					(* 1 Hr for Conductivity Calibration *)
					60,
					0
				]
			}
		]
	] * Minute;

	(* Determine volume of BufferA required for each gradient run *)
	bufferAVolumePerGradient = Map[
		calculateBufferUsage[
			#[[All, {1, 2}]],
			Max[#[[All, 1]]],
			#[[All, {1, -1}]],
			Last[#[[All, 2]]]
		]&,
		allGradientTuples
	];

	(* Determine volume of BufferB required for each gradient run *)
	bufferBVolumePerGradient = Map[
		calculateBufferUsage[
			#[[All, {1, 3}]],
			Max[#[[All, 1]]],
			#[[All, {1, -1}]],
			Last[#[[All, 3]]]
		]&,
		allGradientTuples
	];

	(* Determine volume of BufferC required for each gradient run *)
	bufferCVolumePerGradient = Map[
		calculateBufferUsage[
			#[[All, {1, 4}]],
			Max[#[[All, 1]]],
			#[[All, {1, -1}]],
			Last[#[[All, 4]]]
		]&,
		allGradientTuples
	];

	(* Determine volume of BufferD required for each gradient run *)
	bufferDVolumePerGradient = Map[
		calculateBufferUsage[
			#[[All, {1, 5}]],
			Max[#[[All, 1]]],
			#[[All, {1, -1}]],
			Last[#[[All, 5]]]
		]&,
		allGradientTuples
	];

	systemPrimeGradient = If[!NullQ[systemPrimeGradientPacket],
		Lookup[systemPrimeGradientPacket, Gradient],
		Null
	];

	(* Determine volume of BufferA required for system prime run *)
	systemPrimeBufferAVolumeUsage = If[NullQ[systemPrimeGradientPacket],
		Null,
		calculateBufferUsage[
			systemPrimeGradient[[All, {1, 2}]],
			Max[systemPrimeGradient[[All, 1]]],
			systemPrimeGradient[[All, {1, -1}]],
			Last[systemPrimeGradient[[All, 2]]]
		]
	];

	(* Determine volume of BufferB required for system prime run *)
	systemPrimeBufferBVolumeUsage = If[NullQ[systemPrimeGradientPacket],
		Null,
		calculateBufferUsage[
			systemPrimeGradient[[All, {1, 3}]],
			Max[systemPrimeGradient[[All, 1]]],
			systemPrimeGradient[[All, {1, -1}]],
			Last[systemPrimeGradient[[All, 3]]]
		]
	];

	(* Determine volume of BufferC required for system prime run *)
	systemPrimeBufferCVolumeUsage = If[NullQ[systemPrimeGradientPacket],
		Null,
		calculateBufferUsage[
			systemPrimeGradient[[All, {1, 4}]],
			Max[systemPrimeGradient[[All, 1]]],
			systemPrimeGradient[[All, {1, -1}]],
			Last[systemPrimeGradient[[All, 4]]]
		]
	];

	(* Determine volume of BufferD required for system prime run *)
	systemPrimeBufferDVolumeUsage = If[NullQ[systemPrimeGradientPacket],
		Null,
		calculateBufferUsage[
			systemPrimeGradient[[All, {1, 5}]],
			Max[systemPrimeGradient[[All, 1]]],
			systemPrimeGradient[[All, {1, -1}]],
			Last[systemPrimeGradient[[All, 5]]]
		]
	];

	systemFlushGradient = Lookup[systemFlushGradientPacket, Gradient];

	(* Determine volume of BufferA required for system flush run *)
	systemFlushBufferAVolumeUsage = If[NullQ[systemFlushGradientPacket],
		Null,
		calculateBufferUsage[
			systemFlushGradient[[All, {1, 2}]],
			Max[systemFlushGradient[[All, 1]]],
			systemFlushGradient[[All, {1, -1}]],
			Last[systemFlushGradient[[All, 2]]]
		]
	];

	(* Determine volume of BufferB required for system flush run *)
	systemFlushBufferBVolumeUsage = If[NullQ[systemFlushGradientPacket],
		Null,
		calculateBufferUsage[
			systemFlushGradient[[All, {1, 3}]],
			Max[systemFlushGradient[[All, 1]]],
			systemFlushGradient[[All, {1, -1}]],
			Last[systemFlushGradient[[All, 3]]]
		]
	];

	(* Determine volume of BufferC required for system flush run *)
	systemFlushBufferCVolumeUsage = If[NullQ[systemFlushGradientPacket],
		Null,
		calculateBufferUsage[
			systemFlushGradient[[All, {1, 4}]],
			Max[systemFlushGradient[[All, 1]]],
			systemFlushGradient[[All, {1, -1}]],
			Last[systemFlushGradient[[All, 4]]]
		]
	];

	(* Determine volume of BufferD required for system flush run *)
	systemFlushBufferDVolumeUsage = If[NullQ[systemFlushGradientPacket],
		Null,
		calculateBufferUsage[
			systemFlushGradient[[All, {1, 5}]],
			Max[systemFlushGradient[[All, 1]]],
			systemFlushGradient[[All, {1, -1}]],
			Last[systemFlushGradient[[All, 5]]]
		]
	];

	(* Depending on instrument model's buffer cap type, the dead volume is different *)
	bufferDeadVolume = If[watersManufacturedQ,
		(* Waters *)
		300 Milliliter,
		650 Milliliter
	];

	(* Round for water dispenser if buffer is water. 75 mL for initial purge instrument Purge *)
	bufferAVolume = If[MatchQ[bufferAModel, WaterModelP],
		roundToDispenseVolume[Total[bufferAVolumePerGradient] + 75 Milliliter],
		Total[bufferAVolumePerGradient] + 75 Milliliter
	];

	(* Round for water dispenser if buffer is water. 75 mL for initial purge instrument Purge *)
	bufferBVolume = If[MatchQ[bufferBModel, WaterModelP],
		roundToDispenseVolume[Total[bufferBVolumePerGradient] + 75 Milliliter],
		Total[bufferBVolumePerGradient] + 75 Milliliter
	];

	(* Round for water dispenser if buffer is water. 75 mL for initial purge instrument Purge *)
	bufferCVolume = If[MatchQ[bufferCModel, WaterModelP],
		roundToDispenseVolume[Total[bufferCVolumePerGradient] + 75 Milliliter],
		Total[bufferCVolumePerGradient] + 75 Milliliter
	];

	(* Leave 0 mL if no BufferD used. Round for water dispenser if buffer is water. *)
	bufferDVolume = If[NullQ[bufferDModel],
		0 Milliliter,
		If[MatchQ[bufferDModel, WaterModelP],
			roundToDispenseVolume[Total[bufferDVolumePerGradient] + 75 Milliliter],
			Total[bufferDVolumePerGradient] + 75 Milliliter
		]
	];

	(* Round for water dispenser if buffer is water. *)
	systemPrimeBufferAVolume = If[NullQ[systemPrimeGradientPacket],
		Null,
		If[MatchQ[Lookup[systemPrimeGradientPacket, BufferA], WaterModelP],
			roundToDispenseVolume[systemPrimeBufferAVolumeUsage],
			systemPrimeBufferAVolumeUsage
		]
	];

	(* Round for water dispenser if buffer is water. *)
	systemPrimeBufferBVolume = If[NullQ[systemPrimeGradientPacket],
		Null,
		If[MatchQ[Lookup[systemPrimeGradientPacket, BufferB], WaterModelP],
			roundToDispenseVolume[systemPrimeBufferBVolumeUsage],
			systemPrimeBufferBVolumeUsage
		]
	];

	(* Round for water dispenser if buffer is water. *)
	systemPrimeBufferCVolume = If[NullQ[systemPrimeGradientPacket],
		Null,
		If[MatchQ[Lookup[systemPrimeGradientPacket, BufferC], WaterModelP],
			roundToDispenseVolume[systemPrimeBufferCVolumeUsage],
			systemPrimeBufferCVolumeUsage
		]
	];

	(* Leave Null if no BufferD used. Round for water dispenser if buffer is water. *)
	systemPrimeBufferDVolume = If[NullQ[Lookup[systemPrimeGradientPacket, BufferD]] || NullQ[systemPrimeGradientPacket],
		Null,
		If[MatchQ[Lookup[systemPrimeGradientPacket, BufferD], WaterModelP],
			roundToDispenseVolume[systemPrimeBufferDVolumeUsage],
			systemPrimeBufferDVolumeUsage
		]
	];

	(* Round for water dispenser if buffer is water. *)
	systemFlushBufferAVolume = If[NullQ[systemFlushGradientPacket],
		Null,
		If[MatchQ[Lookup[systemFlushGradientPacket, BufferA], WaterModelP],
			roundToDispenseVolume[systemFlushBufferAVolumeUsage],
			systemFlushBufferAVolumeUsage
		]
	];

	(* Round for water dispenser if buffer is water. *)
	systemFlushBufferBVolume = If[NullQ[systemFlushGradientPacket],
		Null,
		If[MatchQ[Lookup[systemFlushGradientPacket, BufferB], WaterModelP],
			roundToDispenseVolume[systemFlushBufferBVolumeUsage],
			systemFlushBufferBVolumeUsage
		]
	];

	(* Round for water dispenser if buffer is water. *)
	systemFlushBufferCVolume = If[NullQ[systemFlushGradientPacket],
		Null,
		If[MatchQ[Lookup[systemFlushGradientPacket, BufferC], WaterModelP],
			roundToDispenseVolume[systemFlushBufferCVolumeUsage],
			systemFlushBufferCVolumeUsage
		]
	];

	(* Leave Null if no BufferD used. Round for water dispenser if buffer is water. *)
	systemFlushBufferDVolume = If[NullQ[Lookup[systemFlushGradientPacket, BufferD]] || NullQ[systemFlushGradientPacket],
		Null,
		If[MatchQ[Lookup[systemFlushGradientPacket, BufferD], WaterModelP],
			roundToDispenseVolume[systemFlushBufferDVolumeUsage],
			systemFlushBufferDVolumeUsage
		]
	];

	(* Resolve buffer containers *)

	(* Find an appropriate container based on volume.
	Dionex/Agilent: The only container models that currently fit the HPLCs' buffer caps are 4L bottle, 10L carboy or 20L carboy.
	Waters: The only container model that currently fit the HPLCs' buffer caps are 2L bottle
	*)
	bufferAContainer = Which[
		(* Waters must use a 2L bottle *)
		(* User detergent-sensitive bottles for LCMS *)
		internalUsageQ, {Model[Container, Vessel, "id:rea9jlRPKB05"]}, (* 2L Glass Bottle, Detergent-Sensitive *)
		watersManufacturedQ, {Model[Container, Vessel, "id:3em6Zv9Njjbv"], Model[Container, Vessel, "id:O81aEBZpZODD"]}, (* 2L Glass Bottle, 2L Glass Bottle, Sterile *)

		(* If buffer + dead volume fits into an Amber Glass Bottle 4 L, use that *)
		TrueQ[(bufferAVolume + bufferDeadVolume) <= 4 Liter], {Model[Container, Vessel, "id:Vrbp1jG800Zm"]},

		(* Otherwise, we need a carboy and will use a dead volume of 2.5L in the resource generation below. Find a carboy based on that dead volume *)
		(* If the volume is less than 10L, we can use either a 10L or 20L carboy *)
		TrueQ[(bufferAVolume) <= 7.5 Liter], {Model[Container, Vessel, "id:aXRlGnZmOOB9"], Model[Container, Vessel, "id:3em6Zv9NjjkY"]},

		(* Otherwise, we must use a 20L carboy *)
		True, {Model[Container, Vessel, "id:3em6Zv9NjjkY"]}
	];

	(* Find an appropriate container based on volume. The only container models that currently fit the HPLCs' buffer caps are 4L bottle, 10L carboy or 20L carboy *)
	bufferBContainer = Which[
		(* Waters must use a 2L bottle *)
		(* User detergent-sensitive bottles for LCMS *)
		internalUsageQ, {Model[Container, Vessel, "id:rea9jlRPKB05"]}, (* 2L Glass Bottle, Detergent-Sensitive *)
		watersManufacturedQ, {Model[Container, Vessel, "id:3em6Zv9Njjbv"], Model[Container, Vessel, "id:O81aEBZpZODD"]}, (* 2L Glass Bottle, 2L Glass Bottle, Sterile *)

		(* If buffer + dead volume fits into an Amber Glass Bottle 4 L, use that *)
		TrueQ[(bufferBVolume + bufferDeadVolume) <= 4 Liter], {Model[Container, Vessel, "id:Vrbp1jG800Zm"]},

		(* Otherwise, we need a carboy and will use a dead volume of 2.5L in the resource generation below. Find a carboy based on that dead volume *)
		(* If the volume is less than 10L, we can use either a 10L or 20L carboy *)
		TrueQ[(bufferBVolume) <= 7.5 Liter], {Model[Container, Vessel, "id:aXRlGnZmOOB9"], Model[Container, Vessel, "id:3em6Zv9NjjkY"]},

		(* Otherwise, we must use a 20L carboy *)
		True, {Model[Container, Vessel, "id:3em6Zv9NjjkY"]}
	];

	(* Find an appropriate container based on volume. The only container models that currently fit the HPLCs' buffer caps are 4L bottle, 10L carboy or 20L carboy *)
	bufferCContainer = Which[
		(* Waters must use a 2L bottle *)
		(* User detergent-sensitive bottles for LCMS *)
		internalUsageQ, {Model[Container, Vessel, "id:rea9jlRPKB05"]}, (* 2L Glass Bottle, Detergent-Sensitive *)
		watersManufacturedQ, {Model[Container, Vessel, "id:3em6Zv9Njjbv"], Model[Container, Vessel, "id:O81aEBZpZODD"]}, (* 2L Glass Bottle, 2L Glass Bottle, Sterile *)

		(* If buffer + dead volume fits into an Amber Glass Bottle 4 L, use that *)
		TrueQ[(bufferCVolume + bufferDeadVolume) <= 4 Liter], {Model[Container, Vessel, "id:Vrbp1jG800Zm"]},

		(* Otherwise, we need a carboy and will use a dead volume of 2.5L in the resource generation below. Find a carboy based on that dead volume *)
		(* If the volume is less than 10L, we can use either a 10L or 20L carboy *)
		TrueQ[(bufferCVolume) <= 7.5 Liter], {Model[Container, Vessel, "id:aXRlGnZmOOB9"], Model[Container, Vessel, "id:3em6Zv9NjjkY"]},

		(* Otherwise, we must use a 20L carboy *)
		True, {Model[Container, Vessel, "id:3em6Zv9NjjkY"]}
	];

	(* Find an appropriate container based on volume. The only container models that currently fit the HPLCs' buffer caps are 4L bottle, 10L carboy or 20L carboy *)
	bufferDContainer = Which[
		(* Waters must use a 2L bottle *)
		(* User detergent-sensitive bottles for LCMS *)
		internalUsageQ, {Model[Container, Vessel, "id:rea9jlRPKB05"]}, (* 2L Glass Bottle, Detergent-Sensitive *)
		watersManufacturedQ, {Model[Container, Vessel, "id:3em6Zv9Njjbv"], Model[Container, Vessel, "id:O81aEBZpZODD"]}, (* 2L Glass Bottle, 2L Glass Bottle, Sterile *)

		(* If buffer + dead volume fits into an Amber Glass Bottle 4 L, use that *)
		TrueQ[(bufferDVolume + bufferDeadVolume) <= 4 Liter], {Model[Container, Vessel, "id:Vrbp1jG800Zm"]},

		(* Otherwise, we need a carboy and will use a dead volume of 2.5L in the resource generation below. Find a carboy based on that dead volume *)
		(* If the volume is less than 10L, we can use either a 10L or 20L carboy *)
		TrueQ[(bufferDVolume) <= 7.5 Liter], {Model[Container, Vessel, "id:aXRlGnZmOOB9"], Model[Container, Vessel, "id:3em6Zv9NjjkY"]},

		(* Otherwise, we must use a 20L carboy *)
		True, {Model[Container, Vessel, "id:3em6Zv9NjjkY"]}
	];

	(* Resolve SystemPrime buffer containers *)

	(* These are the only container models that currently fit the HPLCs' buffer caps *)
	systemPrimeBufferContainer = If[NullQ[systemPrimeGradientPacket],
		Null,
		Which[
			(* User detergent-sensitive bottles for LCMS *)
			internalUsageQ, {Model[Container, Vessel, "id:rea9jlRPKB05"]}, (* 2L Glass Bottle, Detergent-Sensitive *)
			watersManufacturedQ,
			(* Waters moust use a 2L bottle *)
			{Model[Container, Vessel, "id:3em6Zv9Njjbv"], Model[Container, Vessel, "id:O81aEBZpZODD"]}, (* 2L Glass Bottle, 2L Glass Bottle, Sterile *)
			(* Dionex/Agilent must use Amber Glass Bottle 4 L for system prime/flush due to the caps used *)
			True, {Model[Container, Vessel, "id:Vrbp1jG800Zm"]}
		]
	];

	systemFlushBufferContainer = If[NullQ[systemFlushGradientPacket],
		Null,
		Which[
			(* User detergent-sensitive bottles for LCMS *)
			internalUsageQ, {Model[Container, Vessel, "id:rea9jlRPKB05"]}, (* 2L Glass Bottle, Detergent-Sensitive *)
			watersManufacturedQ,
			(* Waters moust use a 2L bottle *)
			{Model[Container, Vessel, "id:3em6Zv9Njjbv"], Model[Container, Vessel, "id:O81aEBZpZODD"]}, (* 2L Glass Bottle, 2L Glass Bottle, Sterile *)
			(* Dionex/Agilent must use Amber Glass Bottle 4 L for system prime/flush due to the caps used *)
			True, {Model[Container, Vessel, "id:Vrbp1jG800Zm"]}
		]
	];

	(* Create resource for BufferA *)
	bufferAResource = If[MatchQ[bufferAContainer, {Model[Container, Vessel, "id:aXRlGnZmOOB9"], Model[Container, Vessel, "id:3em6Zv9NjjkY"]} | {Model[Container, Vessel, "id:3em6Zv9NjjkY"]}],
		(* Ask for 2.5 Liter more for the carboys to make sure we can pull liquid out*)
		Resource[
			Sample -> Lookup[resolvedOptions, BufferA],
			Amount -> bufferAVolume + 2.5 Liter,
			Container -> bufferAContainer,
			Name -> CreateUUID[]
		],
		Resource[
			Sample -> Lookup[resolvedOptions, BufferA],
			Amount -> bufferAVolume + bufferDeadVolume,
			Container -> bufferAContainer,
			Name -> CreateUUID[]
		]
	];

	(* Create resource for BufferB *)
	bufferBResource = If[MatchQ[bufferBContainer, {Model[Container, Vessel, "id:aXRlGnZmOOB9"], Model[Container, Vessel, "id:3em6Zv9NjjkY"]} | {Model[Container, Vessel, "id:3em6Zv9NjjkY"]}],
		(* Ask for 2.5 Liter more for the carboys to make sure we can pull liquid out*)
		Resource[
			Sample -> Lookup[resolvedOptions, BufferB],
			Amount -> bufferBVolume + 2.5 Liter,
			Container -> bufferBContainer,
			Name -> CreateUUID[]
		],
		Resource[
			Sample -> Lookup[resolvedOptions, BufferB],
			Amount -> bufferBVolume + bufferDeadVolume,
			Container -> bufferBContainer,
			Name -> CreateUUID[]
		]
	];

	(* Create resource for BufferC *)
	bufferCResource = If[MatchQ[bufferCContainer, {Model[Container, Vessel, "id:aXRlGnZmOOB9"], Model[Container, Vessel, "id:3em6Zv9NjjkY"]} | {Model[Container, Vessel, "id:3em6Zv9NjjkY"]}],
		(* Ask for 2.5 Liter more for the carboys to make sure we can pull liquid out*)
		Resource[
			Sample -> Lookup[resolvedOptions, BufferC],
			Amount -> bufferCVolume + 2.5 Liter,
			Container -> bufferCContainer,
			Name -> CreateUUID[]
		],
		Resource[
			Sample -> Lookup[resolvedOptions, BufferC],
			Amount -> bufferCVolume + bufferDeadVolume,
			Container -> bufferCContainer,
			Name -> CreateUUID[]
		]
	];

	(* Create resource for BufferD *)
	bufferDResource = Which[
		(* If no BufferD AND Dionex, set to Null *)
		And[
			NullQ[bufferDModel],
			MatchQ[instrumentModel,dionexHPLCPattern]
		],
		Null,
		(* For the carboy ask 2.5 L more so we can pull the liquid out *)
		(* This is only for Agilent *)
		MatchQ[bufferDContainer, {Model[Container, Vessel, "id:aXRlGnZmOOB9"], Model[Container, Vessel, "id:3em6Zv9NjjkY"]} | {Model[Container, Vessel, "id:3em6Zv9NjjkY"]}],
		Resource[
			Sample -> Lookup[resolvedOptions, BufferC],
			Amount -> bufferDVolume + 2.5 Liter,
			Container -> bufferDContainer,
			Name -> CreateUUID[]
		],
		(* Otherwise we have a non-carboy *)
		True,
		Resource[
			Sample -> If[!NullQ[bufferDModel], Lookup[resolvedOptions, BufferD], Model[Sample, "Milli-Q water"]],
			Amount -> bufferDVolume + bufferDeadVolume,
			Container -> bufferDContainer,
			Name -> CreateUUID[]
		]
	];

	(* Create a resource for the NeedleWashSolution.*)
	needleWashSolution = Lookup[resolvedOptions, NeedleWashSolution];
	needleWashResource = If[MatchQ[instrumentModel,dionexHPLCPattern],
		(* Same as BufferC for Dionex *)
		bufferCResource,
		Module[
			{needleWashSolutionAmount, needleWashSolutionContainer},
			(* Estimate to be 5 mL per injection, plus dead volume *)
			needleWashSolutionAmount = Length[allGradientTuples] * 5 * Milliliter + bufferDeadVolume;
			needleWashSolutionContainer = Which[
				MatchQ[instrumentModel,agilentHPLCPattern],
				(* Amber Glass Bottle 4 L for Agilent *)
				{Model[Container, Vessel, "id:Vrbp1jG800Zm"]},
				MatchQ[needleWashSolutionAmount, LessEqualP[1Liter]],
				If[internalUsageQ,
					{Model[Container, Vessel, "id:4pO6dM5l83Vz"]}, (* 1L Glass Bottle, Detergent-Sensitive *)
					{Model[Container, Vessel, "id:zGj91aR3ddXJ"], Model[Container, Vessel, "id:XnlV5jKRKBqn"]} (* 1L Glass Bottle *)
				],
				True,
				If[internalUsageQ,
					{Model[Container, Vessel, "id:rea9jlRPKB05"]}, (* 2L Glass Bottle, Detergent-Sensitive *)
					{Model[Container, Vessel, "id:3em6Zv9Njjbv"], Model[Container, Vessel, "id:O81aEBZpZODD"]} (* 2L Glass Bottle *)
				]
			];
			Resource[
				Sample -> needleWashSolution,
				Amount -> needleWashSolutionAmount,
				Container -> needleWashSolutionContainer,
				Name -> CreateUUID[]
			]
		]
	];

	(* Get SystemPrime's BufferA - Do not create resource yet. We will require resource in Engine so alternate instruments are exchangable *)
	systemPrimeBufferA = If[NullQ[systemPrimeGradientPacket],
		Null,
		Lookup[systemPrimeGradientPacket, BufferA]
	];

	systemPrimeBufferAResource = If[NullQ[systemPrimeGradientPacket],
		Null,
		Resource[
			Sample -> Lookup[systemPrimeGradientPacket, BufferA],
			Amount -> systemPrimeBufferAVolume + bufferDeadVolume,
			Container -> systemPrimeBufferContainer,
			RentContainer -> True,
			Name -> CreateUUID[]
		]
	];

	(* Get SystemPrime's BufferB - Do not create resource yet. We will require resource in Engine so alternate instruments are exchangable *)
	systemPrimeBufferB = If[NullQ[systemPrimeGradientPacket],
		Null,
		Lookup[systemPrimeGradientPacket, BufferB]
	];

	systemPrimeBufferBResource = If[NullQ[systemPrimeGradientPacket],
		Null,
		Resource[
			Sample -> Lookup[systemPrimeGradientPacket, BufferB],
			Amount -> systemPrimeBufferBVolume + bufferDeadVolume,
			Container -> systemPrimeBufferContainer,
			RentContainer -> True,
			Name -> CreateUUID[]
		]
	];

	(* Get SystemPrime's BufferC - Do not create resource yet. We will require resource in Engine so alternate instruments are exchangable *)
	systemPrimeBufferC = If[NullQ[systemPrimeGradientPacket],
		Null,
		Lookup[systemPrimeGradientPacket, BufferC]
	];

	systemPrimeBufferCResource = If[NullQ[systemPrimeGradientPacket] || NullQ[systemPrimeBufferC],
		Null,
		Resource[
			Sample -> Lookup[systemPrimeGradientPacket, BufferC],
			Amount -> systemPrimeBufferCVolume + bufferDeadVolume,
			Container -> systemPrimeBufferContainer,
			RentContainer -> True,
			Name -> CreateUUID[]
		]
	];

	(* Get SystemPrime's BufferD - Do not create resource yet. We will require resource in Engine so alternate instruments are exchangable *)
	systemPrimeBufferD = If[NullQ[systemPrimeGradientPacket] || NullQ[Lookup[systemPrimeGradientPacket, BufferD]],
		Null,
		Lookup[systemPrimeGradientPacket, BufferD]
	];

	(* Create resource for SystemPrime's BufferD *)
	systemPrimeBufferDResource = If[NullQ[systemPrimeGradientPacket] || NullQ[systemPrimeBufferD],
		Null,
		Resource[
			Sample -> Lookup[systemPrimeGradientPacket, BufferD],
			Amount -> systemPrimeBufferDVolume + bufferDeadVolume,
			Container -> systemPrimeBufferContainer,
			RentContainer -> True,
			Name -> CreateUUID[]
		]
	];

	(* Get SystemFlush's BufferA - Do not create resource yet. We will require resource in Engine so alternate instruments are exchangable *)
	systemFlushBufferA = If[NullQ[systemFlushGradientPacket],
		Null,
		Lookup[systemFlushGradientPacket, BufferA]
	];

	systemFlushBufferAResource = If[NullQ[systemFlushGradientPacket],
		Null,
		Resource[
			Sample -> Lookup[systemFlushGradientPacket, BufferA],
			Amount -> systemFlushBufferAVolume + bufferDeadVolume,
			Container -> systemFlushBufferContainer,
			RentContainer -> True,
			Name -> CreateUUID[]
		]
	];

	(* Get SystemFlush's BufferB - Do not create resource yet. We will require resource in Engine so alternate instruments are exchangable *)
	systemFlushBufferB = If[NullQ[systemFlushGradientPacket],
		Null,
		Lookup[systemFlushGradientPacket, BufferB]
	];

	systemFlushBufferBResource = If[NullQ[systemFlushGradientPacket],
		Null,
		Resource[
			Sample -> Lookup[systemFlushGradientPacket, BufferB],
			Amount -> systemFlushBufferBVolume + bufferDeadVolume,
			Container -> systemFlushBufferContainer,
			RentContainer -> True,
			Name -> CreateUUID[]
		]
	];

	(* Get SystemFlush's BufferC - Do not create resource yet. We will require resource in Engine so alternate instruments are exchangable *)
	systemFlushBufferC = If[NullQ[systemFlushGradientPacket],
		Null,
		Lookup[systemFlushGradientPacket, BufferC]
	];

	systemFlushBufferCResource = If[NullQ[systemFlushGradientPacket] || NullQ[systemFlushBufferC],
		Null,
		Resource[
			Sample -> Lookup[systemFlushGradientPacket, BufferC],
			Amount -> systemFlushBufferCVolume + bufferDeadVolume,
			Container -> systemFlushBufferContainer,
			RentContainer -> True,
			Name -> CreateUUID[]
		]
	];

	(* Get SystemFlush's BufferD - Do not create resource yet. We will require resource in Engine so alternate instruments are exchangable *)
	systemFlushBufferD = If[NullQ[systemFlushGradientPacket] || NullQ[Lookup[systemFlushGradientPacket, BufferD]],
		Null,
		Lookup[systemFlushGradientPacket, BufferD]
	];

	systemFlushBufferDResource = If[NullQ[systemFlushGradientPacket] || NullQ[Lookup[systemFlushGradientPacket, BufferD]],
		Null,
		Resource[
			Sample -> Lookup[systemFlushGradientPacket, BufferD],
			Amount -> systemFlushBufferDVolume + bufferDeadVolume,
			Container -> systemFlushBufferContainer,
			RentContainer -> True,
			Name -> CreateUUID[]
		]
	];

	(* Find out how many FractionContainers we need *)
	(* We only care about thi for Agilent instrument *)
	sampleContainerModels = If[MatchQ[instrumentModel,agilentHPLCPattern],
		Join[
			MapThread[
				Which[
					(* Container Model with Index *)
					MatchQ[#2,{_Integer,ObjectP[Model]}],
					Download[#2[[2]],Object],
					(* Container Model *)
					MatchQ[#2,ObjectP[Model]],
					Download[#2,Object],
					(* Container Object *)
					MatchQ[#2,ObjectP[Object]],
					Download[Lookup[fetchPacketFromCache[#2,cache],Model],Object],
					(* Sample's Container Object *)
					True,
					Download[Lookup[fetchPacketFromCache[#1,cache],Model],Object]
				]&,
				Transpose[
					DeleteDuplicates[
						Transpose[{sampleContainers,aliquotContainers}]
					]
				]
			],
			Map[
				Download[Lookup[#[[1]],Container][[1]],Object]&,
				Values[groupedStandard]
			],
			Map[
				Download[Lookup[#[[1]],Container][[1]],Object]&,
				Values[groupedBlank]
			]
		],
		{}
	];

	(* Agilent Instrument - Count the samples, Standards, Blanks and containers for the Agilent 1290 instrument *)
	(* Agilent has 6 autosampler positions for racks.
		All racks:
			{Model[Container, Rack, "30 x 100 mm Tube Container for Preparative HPLC"],
Model[Container, Rack, "16 x 100 mm Tube Container for Preparative HPLC"],}
		We will use update to 5 racks if collection fractions (saving at least 1 for fractions since they share the same deck; 6 racks if not.
		Model[Container, Rack, "16 x 100 mm Tube Container for Preparative HPLC"] - 36 positions
		Model[Container, Rack, "30 x 100 mm Tube Container for Preparative HPLC"] - 10 positions
	*)
	agilentRackPositionRules=Map[
		Module[
			{rackPacket},
			rackPacket=fetchPacketFromCache[#,cache];
			#->(Lookup[rackPacket,NumberOfPositions]/.{Null->10})
		]&,
		(* Model[Container, Rack, "16 x 100 mm Tube Container for Preparative HPLC"] and Model[Container, Rack, "30 x 100 mm Tube Container for Preparative HPLC"] *)
		{Experiment`Private`$SmallAgilentHPLCAutosamplerRack,Experiment`Private`$LargeAgilentHPLCAutosamplerRack}
	];

	(* Get the 15mL tube and 50mL tube count *)
	smallVesselCount = Count[sampleContainerModels,(Model[Container, Vessel, "id:xRO9n3vk11pw"]|Model[Container, Vessel, "id:rea9jl1orrMp"])];
	largeVesselCount = Count[sampleContainerModels,(Model[Container, Vessel, "id:bq9LA0dBGGR6"]|Model[Container, Vessel, "id:bq9LA0dBGGrd"])];

	(* For Agilent, get the number of unoccupied racks *)
	(* We have 3 of each type of racks *)
	agilentFractionCollectionRackPositions = If[MatchQ[Lookup[myResolvedOptions,FractionCollectionContainer],ObjectP[{Model[Container, Vessel, "id:xRO9n3vk11pw"], Model[Container, Vessel, "id:rea9jl1orrMp"]}]],
		3 - Ceiling[smallVesselCount / (Lookup[agilentRackPositionRules, Experiment`Private`$LargeAgilentHPLCAutosamplerRack])],
		3 - Ceiling[largeVesselCount / (Lookup[agilentRackPositionRules, Experiment`Private`$LargeAgilentHPLCAutosamplerRack])]
	];

	(* Check how many fraction containers we are going to have *)
	fractionPositionCount =  If[MatchQ[instrumentModel,agilentHPLCPattern],
		agilentFractionCollectionRackPositions * If[MatchQ[Lookup[myResolvedOptions,FractionCollectionContainer],ObjectP[{Model[Container, Vessel, "id:xRO9n3vk11pw"], Model[Container, Vessel, "id:rea9jl1orrMp"]}]],
			(* 15mL Tube - 36 per rack *)
			(Lookup[agilentRackPositionRules,Experiment`Private`$SmallAgilentHPLCAutosamplerRack]),
			(* 50mL Tube - 10 per rack *)
			(Lookup[agilentRackPositionRules,Experiment`Private`$LargeAgilentHPLCAutosamplerRack])
		],
		(* 4 plates of 96 positions each *)
		96 * 4
	];
	fractionContainerCount = If[MatchQ[instrumentModel,agilentHPLCPattern],
		fractionPositionCount,
		4
	];

	(* Get the maximum of fraciton volumes before we have to replace the fraction containers *)
	maxFractionTotalVolume = If[NullQ[Lookup[myResolvedOptions,MaxFractionVolume]],
		Null,
		fractionPositionCount * Max[Cases[Lookup[myResolvedOptions,MaxFractionVolume],VolumeP]]
	];

	checkInFrequency = If[(Or @@ Lookup[myResolvedOptions, CollectFractions]),
		Module[{totalBufferUsage, totalTime, bufferUsePerTime},

			totalBufferUsage = Total[
				Join[
					bufferAVolumePerGradient,
					bufferBVolumePerGradient,
					bufferCVolumePerGradient,
					bufferDVolumePerGradient
				]
			];

			(* Total sample run time *)
			totalTime = Total[Max /@ (allGradientTuples[[All, All, 1]])];

			bufferUsePerTime = totalBufferUsage / totalTime;

			(* Use buffer and fraction volume to decide the time, or take 6 Hour *)
			Min[maxFractionTotalVolume / bufferUsePerTime, 6 Hour]
		],
		6 Hour
	];

	(* Create placement field value for SystemPrime buffers *)
	systemPrimeBufferPlacements = Which[
		NullQ[systemPrimeGradientPacket], {},
		internalUsageQ,
		{
			{Link[systemPrimeBufferAResource], {"Buffer A Slot"}},
			{Link[systemPrimeBufferBResource], {"Buffer B Slot"}},
			{Link[systemPrimeBufferCResource], {"Buffer C Slot"}},
			If[NullQ[systemPrimeBufferDResource],
				Nothing,
				{Link[systemPrimeBufferDResource], {"Buffer D Slot"}}
			]
		},
		True,
		{
			{Link[systemPrimeBufferA], {"Buffer A Slot"}},
			{Link[systemPrimeBufferB], {"Buffer B Slot"}},
			{Link[systemPrimeBufferC], {"Buffer C Slot"}},
			If[NullQ[systemPrimeBufferD],
				Nothing,
				{Link[systemPrimeBufferD], {"Buffer D Slot"}}
			]
		}
	];

	(* Create placement field value for SystemFlush buffers *)
	systemFlushBufferPlacements = Which[
		NullQ[systemFlushGradientPacket], {},
		internalUsageQ,
		{
			{Link[systemFlushBufferAResource], {"Buffer A Slot"}},
			{Link[systemFlushBufferBResource], {"Buffer B Slot"}},
			{Link[systemFlushBufferCResource], {"Buffer C Slot"}},
			If[NullQ[systemFlushBufferDResource],
				Nothing,
				{Link[systemFlushBufferDResource], {"Buffer D Slot"}}
			]
		},
		True,
		{
			{Link[systemFlushBufferA], {"Buffer A Slot"}},
			{Link[systemFlushBufferB], {"Buffer B Slot"}},
			{Link[systemFlushBufferC], {"Buffer C Slot"}},
			If[NullQ[systemFlushBufferD],
				Nothing,
				{Link[systemFlushBufferD], {"Buffer D Slot"}}
			]
		}
	];

	(* Fetch max pressures for instrument and column components (Cases for Pressure in case field is Null)  *)
	componentMaxPressures = Cases[
		Append[Lookup[instrumentModelPacket, {TubingMaxPressure, PumpMaxPressure}], maxColumnPressure],
		PressureP
	];

	(* Set upper pressure limit to the lowest component max pressure *)
	upperPressureLimit = If[!MatchQ[componentMaxPressures, {PressureP..}],
		Null,
		Min[componentMaxPressures]
	];

	(* Get the Gradient options that just need to be expanded *)
	(* Helper to collapse gradient into single percentage value if the option is Isocratic and all values are the same at each timepoint *)
	collapseGradient[gradient : ({{TimeP, PercentP | FlowRateP}...}|Null|RangeP[0 Percent,100 Percent])] := If[
		!NullQ[gradient] && !MatchQ[gradient,RangeP[0 Percent,100 Percent]] && (SameQ @@ (gradient[[All, 2]])),
		gradient[[1, 2]],
		gradient
	];
	(* Start with the column prime *)
	{
		columnPrimeGradientA,
		columnPrimeGradientB,
		columnPrimeGradientC,
		columnPrimeGradientD
	} = Map[
		Function[{optionLookup},
			If[!NullQ[columnPrimePositionsCorresponded] && Not[MatchQ[columnPrimePositionsCorresponded, {}]],
				collapseGradient/@(optionLookup[[DeleteDuplicates[columnPrimePositionsCorresponded]]])
			]
		],
		Lookup[myResolvedOptions,
			{
				ColumnPrimeGradientA,
				ColumnPrimeGradientB,
				ColumnPrimeGradientC,
				ColumnPrimeGradientD
			}
		]
	];

	(* Now get the samples, which will always be there, so no mapping checks/positioning needed *)
	{
		sampleGradientA,
		sampleGradientB,
		sampleGradientC,
		sampleGradientD
	} = Transpose[
		Map[
			Module[{packet},
				packet = fetchPacketFromCache[#, Join[cache, uniqueGradientPackets]];
				{
					collapseGradient[Lookup[packet, GradientA, Null]],
					collapseGradient[Lookup[packet, GradientB, Null]],
					collapseGradient[Lookup[packet, GradientC, Null]],
					collapseGradient[Lookup[packet, GradientD, Null]]
				}
			]&,
			Download[injectionTableWithReplicates[[samplePositionsWithReplicates, 6]], Object]
		]
	];

	{
		sampleFlowRates,
		sampleColumnTemperatures
	}=Map[
		expandForNumberOfReplicates[#]&,
		Lookup[myResolvedOptions,
			{
				FlowRate,
				ColumnTemperature
			}
		]
	];
	
	(* Split the field to be Constant or Variable *)
	sampleFlowRatesConstant = Map[
		If[MatchQ[#,GreaterEqualP[(0 * Milli * Liter) / Minute]],
			#,
			Null
		]&,
		sampleFlowRates
	];

	sampleFlowRatesVariable = Map[
		If[MatchQ[#,ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}]],
			#,
			Null
		]&,
		sampleFlowRates
	];

	(* Now the standard samples *)
	{
		standardGradientA,
		standardGradientB,
		standardGradientC,
		standardGradientD
	} = If[!NullQ[standardPositionsCorresponded],
		Transpose[
			Map[
				Module[{packet},
					packet = fetchPacketFromCache[#, Join[cache, uniqueGradientPackets]];
					{
						collapseGradient[Lookup[packet, GradientA, Null]],
						collapseGradient[Lookup[packet, GradientB, Null]],
						collapseGradient[Lookup[packet, GradientC, Null]],
						collapseGradient[Lookup[packet, GradientD, Null]]
					}
				]&,
				Download[injectionTableWithLinks[[standardPositions, 6]], Object]
			]
		],
		ConstantArray[Null, 4]
	];

	{
		standardFlowRates,
		standardTemperatures
	}=Map[
		Function[
			{optionLookup},
			If[!NullQ[standardPositionsCorresponded],
				optionLookup[[standardPositionsCorresponded]]
			]
		],
		Lookup[
			myResolvedOptions,
			{
				StandardFlowRate,
				StandardColumnTemperature
			}
		]
	];

	(* Split the field to be Constant or Variable *)
	standardFlowRatesConstant = Map[
		If[MatchQ[#,GreaterEqualP[(0 * Milli * Liter) / Minute]],
			#,
			Null
		]&,
		standardFlowRates
	];

	standardFlowRatesVariable = Map[
		If[MatchQ[#,ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}]],
			#,
			Null
		]&,
		standardFlowRates
	];

	(* Now the blank samples *)
	{
		blankGradientA,
		blankGradientB,
		blankGradientC,
		blankGradientD
	} = If[!NullQ[blankPositionsCorresponded],
		Transpose[
			Map[
				Module[{packet},
					packet = fetchPacketFromCache[#, Join[cache, uniqueGradientPackets]];
					{
						collapseGradient[Lookup[packet, GradientA, Null]],
						collapseGradient[Lookup[packet, GradientB, Null]],
						collapseGradient[Lookup[packet, GradientC, Null]],
						collapseGradient[Lookup[packet, GradientD, Null]]
					}
				]&,
				Download[injectionTableWithLinks[[blankPositions, 6]], Object]
			]
		],
		ConstantArray[Null, 4]
	];

	{
		blankFlowRates,
		blankTemperatures
	}=Map[
		Function[
			{optionLookup},
			If[!NullQ[blankPositionsCorresponded],
				optionLookup[[blankPositionsCorresponded]]
			]
		],
		Lookup[
			myResolvedOptions,
			{
				BlankFlowRate,
				BlankColumnTemperature
			}
		]
	];
	
	(* Split the field to be Constant or Variable *)
	blankFlowRatesConstant = Map[
		If[MatchQ[#,GreaterEqualP[(0 * Milli * Liter) / Minute]],
			#,
			Null
		]&,
		blankFlowRates
	];

	blankFlowRatesVariable = Map[
		If[MatchQ[#,ListableP[{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}]],
			#,
			Null
		]&,
		blankFlowRates
	];

	(* Column Flush *)
	{
		columnFlushGradientA,
		columnFlushGradientB,
		columnFlushGradientC,
		columnFlushGradientD
	} = Map[
		Function[{optionLookup},
			If[!NullQ[columnFlushPositionsCorresponded] && Not[MatchQ[columnFlushPositionsCorresponded, {}]],
				collapseGradient/@(optionLookup[[DeleteDuplicates[columnFlushPositionsCorresponded]]])
			]
		],
		Lookup[myResolvedOptions,
			{
				ColumnFlushGradientA,
				ColumnFlushGradientB,
				ColumnFlushGradientC,
				ColumnFlushGradientD
			}
		]
	];

	(* Helper to split gradient into Isocratic field and normal field for upload *)
	splitGradient[gradients : ({({{TimeP, PercentP | FlowRateP}...}|RangeP[0 Percent,100 Percent]|Null)...}|{}|Null), type:(Isocratic|Full)] := If[NullQ[gradients],
		Null,
		Map[
			If[
				Or[
					MatchQ[#,{{TimeP, PercentP | FlowRateP}...}]&&MatchQ[type,Full],
					MatchQ[#,RangeP[0 Percent,100 Percent]]&&MatchQ[type,Isocratic]
				],
				#,
				Null
			]&,
			gradients
		]
	];

	(* Create the placement fields for the needle wash solution *)
	needleWashSolutionPlacements = Which[
		internalUsageQ,
		{{Link[needleWashResource], {"SM Purge Reservoir Slot"}}},
		(* Do not use resource yet if not used in LCMS. We will require resource in Engine so alternate instruments are exchangable  *)
		watersManufacturedQ,
		{{Link[needleWashSolution], {"SM Purge Reservoir Slot"}}},
		MatchQ[instrumentModel,agilentHPLCPattern],
		{{Link[needleWashSolution], {"Wash Solvent Slot 1"}}},
		True,
		{}
	];

	(* Calibration Buffers Preparation *)
	(* For each calibration buffer, the required volume is 10 mL - enough for cleaning the flow cell and measurement; Note that we don't move the calibration buffer resource if we are using sachets *)
	calibrationBufferContainer = PreferredContainer[10Milliliter];
	calibrationBufferVolume = 10 Milliliter;

	(* Create the resources of the calibration buffers *)
	lowpHCalibrationBufferResource = If[NullQ[Lookup[resolvedOptions, LowpHCalibrationBuffer]],
		Null,
		If[MatchQ[Lookup[resolvedOptions, LowpHCalibrationBuffer], ObjectP[{Model[Sample, "pH 4.01 Calibration Buffer, Sachets"], Model[Sample, "pH 7.00 Calibration Buffer, Sachets"], Model[Sample, "pH 10.01 Calibration Buffer, Sachets"]}]],
			(* Do not move the calibration buffer in sachet *)
			Resource[
				Sample -> Lookup[resolvedOptions, LowpHCalibrationBuffer],
				Amount -> calibrationBufferVolume,
				Name -> CreateUUID[]
			],
			(* Otherwise use our preferred container *)
			Resource[
				Sample -> Lookup[resolvedOptions, LowpHCalibrationBuffer],
				Amount -> calibrationBufferVolume,
				Container -> calibrationBufferContainer,
				Name -> CreateUUID[]
			]
		]
	];

	highpHCalibrationBufferResource = If[NullQ[Lookup[resolvedOptions, HighpHCalibrationBuffer]],
		Null,
		If[MatchQ[Lookup[resolvedOptions, HighpHCalibrationBuffer], ObjectP[{Model[Sample, "pH 4.01 Calibration Buffer, Sachets"], Model[Sample, "pH 7.00 Calibration Buffer, Sachets"], Model[Sample, "pH 10.01 Calibration Buffer, Sachets"]}]],
			(* Do not move the calibration buffer in sachet *)
			Resource[
				Sample -> Lookup[resolvedOptions, HighpHCalibrationBuffer],
				Amount -> calibrationBufferVolume,
				Name -> CreateUUID[]
			],
			(* Otherwise use our preferred container *)
			Resource[
				Sample -> Lookup[resolvedOptions, HighpHCalibrationBuffer],
				Amount -> calibrationBufferVolume,
				Container -> calibrationBufferContainer,
				Name -> CreateUUID[]
			]
		]
	];

	conductivityCalibrationBufferResource = If[NullQ[Lookup[resolvedOptions, ConductivityCalibrationBuffer]],
		Null,
		(* 1314 uS model for sachets. Use ID here since micro unit in name is not dealt very well in the code *)
		If[MatchQ[Lookup[resolvedOptions, ConductivityCalibrationBuffer], ObjectP[{Model[Sample, "id:eGakldJ6WqD4"]}]],
			(* Do not move the calibration buffer in sachet *)
			Resource[
				Sample -> Lookup[resolvedOptions, ConductivityCalibrationBuffer],
				Amount -> calibrationBufferVolume,
				Name -> CreateUUID[]
			],
			(* Otherwise use our preferred container *)
			Resource[
				Sample -> Lookup[resolvedOptions, ConductivityCalibrationBuffer],
				Amount -> calibrationBufferVolume,
				Container -> calibrationBufferContainer,
				Name -> CreateUUID[]
			]
		]
	];

	(* Create the resources for other required items for calibration *)
	pHCalibrationQ = TrueQ[Lookup[resolvedOptions, pHCalibration]];
	conductivityCalibrationQ = TrueQ[Lookup[resolvedOptions, ConductivityCalibration]];

	(* Wash solution is just water *)
	calibrationWashSolutionResource = If[pHCalibrationQ || conductivityCalibrationQ,
		Module[{volume},
			(* 10 mL for each washing *)
			volume = Which[
				pHCalibrationQ && conductivityCalibrationQ, 50Milliliter,
				pHCalibrationQ, 30Milliliter,
				conductivityCalibrationQ, 20Milliliter
			];
			Link[Resource[Sample -> Model[Sample, "Milli-Q water"], Amount -> volume, Container -> PreferredContainer[volume], Name -> CreateUUID[]]]
		],
		Null
	];

	(* Waste container to hold any waste from the flow cells - total is below 100 mL so a 250 mL beaker is more than enough *)
	calibrationWasteContainer = If[pHCalibrationQ || conductivityCalibrationQ,
		Link[Resource[Sample -> Model[Container, Vessel, "250mL Kimax Beaker"], Rent -> True, Name -> ToString[Unique[]]]],
		Null
	];

	(* All the syringes - Get our default model - one for each solution *)
	calibrationWashSolutionSyringeResource = If[pHCalibrationQ || conductivityCalibrationQ,
		Link[Resource[Sample -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Name -> ToString[Unique[]]]],
		Null
	];

	conductivityCalibrationBufferSyringeResource = If[conductivityCalibrationQ,
		Link[Resource[Sample -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Name -> ToString[Unique[]]]],
		Null
	];

	lowpHCalibrationBufferSyringeResource = If[pHCalibrationQ,
		Link[Resource[Sample -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Name -> ToString[Unique[]]]],
		Null
	];

	highpHCalibrationBufferSyringeResource = If[pHCalibrationQ,
		Link[Resource[Sample -> Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], Name -> ToString[Unique[]]]],
		Null
	];

	(* All the needles - Get our default model - one for each solution *)
	calibrationWashSolutionNeedleResource = If[pHCalibrationQ || conductivityCalibrationQ,
		Link[Resource[Sample -> Model[Item, Needle, "21g x 1 Inch Single-Use Needle"], Name -> ToString[Unique[]]]],
		Null
	];

	conductivityCalibrationBufferNeedleResource = If[conductivityCalibrationQ,
		Link[Resource[Sample -> Model[Item, Needle, "21g x 1 Inch Single-Use Needle"], Name -> ToString[Unique[]]]],
		Null
	];

	lowpHCalibrationBufferNeedleResource = If[pHCalibrationQ,
		Link[Resource[Sample -> Model[Item, Needle, "21g x 1 Inch Single-Use Needle"], Name -> ToString[Unique[]]]],
		Null
	];

	highpHCalibrationBufferNeedleResource = If[pHCalibrationQ,
		Link[Resource[Sample -> Model[Item, Needle, "21g x 1 Inch Single-Use Needle"], Name -> ToString[Unique[]]]],
		Null
	];

	(* Set the default syringe info and the flow rate *)
	calibrationWashSolutionFlowRate = If[pHCalibrationQ || conductivityCalibrationQ,
		1Milliliter / Minute,
		Null
	];

	{lowpHCalibrationBufferFlowRate, highpHCalibrationBufferFlowRate} = If[pHCalibrationQ,
		{1Milliliter / Minute, 1Milliliter / Minute},
		{Null, Null}
	];

	conductivityCalibrationBufferFlowRate = If[conductivityCalibrationQ,
		1Milliliter / Minute,
		Null
	];

	(* Set the default volume for cleaning/loading flow cell - Give 1 Milliliter extra to make sure we don't inject air into flow cell *)
	calibrationWashSolutionVolume = If[pHCalibrationQ || conductivityCalibrationQ,
		9Milliliter,
		Null
	];

	{lowpHCalibrationBufferVolume, highpHCalibrationBufferVolume} = If[pHCalibrationQ,
		{9Milliliter, 9Milliliter},
		{Null, Null}
	];

	conductivityCalibrationBufferVolume = If[conductivityCalibrationQ,
		9Milliliter,
		Null
	];

	(* Set the default syringe inner diameter *)
	syringeInnerDiameter = If[pHCalibrationQ || conductivityCalibrationQ,
		Lookup[fetchPacketFromCacheHPLC[Model[Container, Syringe, "20mL All-Plastic Disposable Luer-Lock Syringe"], cache], InnerDiameter],
		Null
	];

	calibrationWashSolutionSyringeInnerDiameter = If[pHCalibrationQ || conductivityCalibrationQ,
		syringeInnerDiameter,
		Null
	];

	{lowpHCalibrationBufferSyringeInnerDiameter, highpHCalibrationBufferSyringeInnerDiameter} = If[pHCalibrationQ,
		{syringeInnerDiameter, syringeInnerDiameter},
		{Null, Null}
	];

	conductivityCalibrationBufferSyringeInnerDiameter = If[conductivityCalibrationQ,
		syringeInnerDiameter,
		Null
	];

	(* Time needed to prime/flush instrument *)
	primeFlushTime = If[MemberQ[Lookup[instrumentModelPacket, Detectors], pH],
		7 Hour,
		2 Hour
	];

	(* Time needed for pH/Conductivity Calibration *)
	detectorCalibrationTime = Total[
		{
			(* pH Calibration *)
			If[pHCalibrationQ,
				(* 1 Hour for calibration *)
				1 Hour,
				0 Hour
			],
			If[conductivityCalibrationQ,
				(* 1 Hour for calibration *)
				1 Hour,
				0 Hour
			],
			(* pH Detector additional system prime and flush *)
			If[MemberQ[Lookup[resolvedOptions, Detector], pH],
				8 Hour,
				0 Hour
			]
		}
	];

	(* Get the resource for the syringe pump instrument *)
	syringePumpResource = If[pHCalibrationQ || conductivityCalibrationQ,
		Resource[
			Instrument -> Model[Instrument, SyringePump, "NE-1010 Syringe Pump"],
			Time -> detectorCalibrationTime
		],
		Null
	];

	(* Populate all shared fields using legacy Funtopia function *)
	sharedFieldPacket = populateSamplePrepFields[mySamples, Normal[resolvedOptions], Cache -> cache];

	(* Use Level 0 Operators for HPLC *)
	operatorResource = Model[User, Emerald, Operator, "Trainee"];

	(* Checkpoints are different depending on the instrument-dependent procedure being used and whether calibration is required *)
	checkpoints = Which[
		watersManufacturedQ,
		(* Waters *)
		{
			{"Picking Resources", 1 Hour, "Buffers and columns required to run HPLC experiments are gathered.", Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
			{"Purging Instrument", 1 Hour, "System priming buffers are connected to an HPLC instrument and the instrument is purged at a high flow rate.", Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
			{"Priming Instrument", If[TrueQ[Lookup[resolvedOptions, Aliquot]], 4 Hour, 3 Hour], "System priming buffers are connected to an HPLC instrument and the instrument is primed with each buffer at a high flow rate.", Link[Resource[Operator -> operatorResource, Time -> If[TrueQ[Lookup[resolvedOptions, Aliquot]], 4 Hour, 3 Hour]]]},
			{"Preparing Instrument", 90 Minute, "An instrument is configured for the protocol.", Link[Resource[Operator -> operatorResource, Time -> 90 Minute]]},
			{"Running Samples", totalRunTime, "Samples are injected onto an HPLC and subject to buffer gradients.", Link[Resource[Operator -> operatorResource, Time -> totalRunTime]]},
			{"Sample Post-Processing", 1 Hour, "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
			{"Flushing Instrument", 2 Hour, " Buffers are connected to an HPLC instrument and the instrument is flushed with each buffer at a high flow rate.", Link[Resource[Operator -> operatorResource, Time -> 2 Hour]]},
			{"Exporting Data", 20 Minute, "Acquired chromatography data is exported.", Link[Resource[Operator -> operatorResource, Time -> 20 Minute]]},
			{"Returning Materials", 15 Minute, "Samples are returned to storage.", Link[Resource[Operator -> operatorResource, Time -> 15 Minute]]}
		},
		!watersManufacturedQ && !EqualQ[Round[detectorCalibrationTime, 1Hour], 0Hour],
		{
			{"Picking Resources", 1 Hour, "Buffers and columns required to run HPLC experiments are gathered.", Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
			{"Purging Instrument", primeFlushTime, "System priming buffers are connected to an HPLC instrument and the instrument is purged at a high flow rate.", Link[Resource[Operator -> operatorResource, Time -> primeFlushTime]]},
			{"Detector Calibration", detectorCalibrationTime, "pH and Conductivity detectors are calibrated and the instrument is flushed by system priming buffers at a high flow rate.", Link[Resource[Operator -> operatorResource, Time -> detectorCalibrationTime]]},
			{"Priming Instrument", If[TrueQ[Lookup[resolvedOptions, Aliquot]], 2 Hour, 1 Hour] + primeFlushTime, "System priming buffers are connected to an HPLC instrument and the instrument is primed with each buffer at a high flow rate.", Link[Resource[Operator -> operatorResource, Time -> (If[TrueQ[Lookup[resolvedOptions, Aliquot]], 2 Hour, 1 Hour] + primeFlushTime)]]},
			{"Preparing Instrument", 1 Hour, "An instrument is configured for the protocol.", Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
			{"Running Samples", totalRunTime, "Samples are injected onto an HPLC and subject to buffer gradients.", Link[Resource[Operator -> operatorResource, Time -> totalRunTime]]},
			{"Sample Post-Processing", 1 Hour, "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
			{"Flushing Instrument", primeFlushTime, " Buffers are connected to an HPLC instrument and the instrument is flushed with each buffer at a high flow rate.", Link[Resource[Operator -> operatorResource, Time -> primeFlushTime]]},
			{"Exporting Data", Quantity[20, "Minutes"], "Acquired chromatography data is exported.", Link[Resource[Operator -> operatorResource, Time -> 20 Minute]]},
			{"Cleaning Up", Quantity[30, "Minutes"], "System buffers are taken down, filters are cleaned, and any measuring of volume on the used system buffers is performed.", Link[Resource[Operator -> operatorResource, Time -> 30 Minute]]},
			{"Returning Materials", Quantity[15, "Minutes"], "Samples are returned to storage.", Link[Resource[Operator -> operatorResource, Time -> 15 Minute]]}
		},
		True,
		{
			{"Picking Resources", 1 Hour, "Buffers and columns required to run HPLC experiments are gathered.", Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
			{"Purging Instrument", primeFlushTime, "System priming buffers are connected to an HPLC instrument and the instrument is purged at a high flow rate.", Link[Resource[Operator -> operatorResource, Time -> primeFlushTime]]},
			{"Priming Instrument", If[TrueQ[Lookup[resolvedOptions, Aliquot]], 2 Hour, 1 Hour] + primeFlushTime, "System priming buffers are connected to an HPLC instrument and the instrument is primed with each buffer at a high flow rate.", Link[Resource[Operator -> operatorResource, Time -> (If[TrueQ[Lookup[resolvedOptions, Aliquot]], 2 Hour, 1 Hour] + primeFlushTime)]]},
			{"Preparing Instrument", 1 Hour, "An instrument is configured for the protocol.", Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
			{"Running Samples", totalRunTime, "Samples are injected onto an HPLC and subject to buffer gradients.", Link[Resource[Operator -> operatorResource, Time -> totalRunTime]]},
			{"Sample Post-Processing", 1 Hour, "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> operatorResource, Time -> 1 Hour]]},
			{"Flushing Instrument", primeFlushTime, " Buffers are connected to an HPLC instrument and the instrument is flushed with each buffer at a high flow rate.", Link[Resource[Operator -> operatorResource, Time -> primeFlushTime]]},
			{"Exporting Data", Quantity[20, "Minutes"], "Acquired chromatography data is exported.", Link[Resource[Operator -> operatorResource, Time -> 20 Minute]]},
			{"Cleaning Up", Quantity[30, "Minutes"], "System buffers are taken down, filters are cleaned, and any measuring of volume on the used system buffers is performed.", Link[Resource[Operator -> operatorResource, Time -> 30 Minute]]},
			{"Returning Materials", Quantity[15, "Minutes"], "Samples are returned to storage.", Link[Resource[Operator -> operatorResource, Time -> 15 Minute]]}
		}
	];

	(* Make the protocol packet id *)
	protocolObjectID = CreateID[Object[Protocol, HPLC]];

	(* Make the instrument resource. if this is a qual (i.e. a single object), we don't do a list *)
	(* For LCMS, we should not try to make a resource - Engine will make the resource *)
	instrumentResource = Which[
		internalUsageQ,
		FirstOrDefault[ToList[Lookup[myResolvedOptions, Instrument]]],
		MatchQ[Lookup[myResolvedOptions, Instrument], ObjectP[Object[Instrument]]],
		Resource[
			Instrument -> Lookup[myResolvedOptions, Instrument],
			Time -> totalRunTime
		],
		True,
		Resource[
			Instrument -> Cases[ToList[Lookup[myResolvedOptions, Instrument]], ObjectP[]],
			Time -> totalRunTime
		]
	];

	(* Look up the standards and the blanks storage conditions *)
	{standardStorageLookup, blankStorageLookup} = ToList /@ Lookup[myResolvedOptions, {StandardStorageCondition, BlankStorageCondition}];

	expandedStandardsStorageConditions = If[!NullQ[standardReverseAssociation],
		Module[
			{standardStorageReplacementRules},

			(* Create storage condition replacement rules *)
			standardStorageReplacementRules = Map[
				Function[
					rule,
					rule[[1]] -> standardStorageLookup[[rule[[2]]]]
				],
				Normal[standardReverseAssociation]
			];

			(* Perform the replacement and then condense so that the storage conditions are in the right order *)
			Replace[ReplacePart[ConstantArray[None, Length[injectionTable]], standardStorageReplacementRules], None -> Nothing, All]
		],
		standardStorageLookup
	];

	(* Same logic for blanks *)
	expandedBlanksStorageConditions = If[!NullQ[blankReverseAssociation],
		Module[
			{blankStorageReplacementRules},

			(* Create storage condition replacement rules *)
			blankStorageReplacementRules = Map[
				Function[
					rule,
					rule[[1]] -> blankStorageLookup[[rule[[2]]]]
				],
				Normal[blankReverseAssociation]
			];

			(* Perform the replacement and then condense so that the storage conditions are in the right order *)
			Replace[ReplacePart[ConstantArray[None, Length[injectionTable]], blankStorageReplacementRules], None -> Nothing, All]
		],
		blankStorageLookup
	];

	(* Build packet with protocol-specific fields populated before the instrument ones *)
	majorityProtocolPacket = Association[
		Type -> Object[Protocol, HPLC],
		Object -> protocolObjectID,
		(* If Name is specified, upload packet with Name (we've checked upstream that the name is available) *)
		If[MatchQ[Lookup[myResolvedOptions, Name], _String],
			Name -> Lookup[myResolvedOptions, Name],
			Nothing
		],
		Replace[SamplesIn] -> expandForNumberOfReplicates[(Link[#, Protocols]& /@ sampleResources)],
		Replace[ContainersIn] -> (Link[Resource[Sample -> #], Protocols]&) /@ DeleteDuplicates[sampleContainers],
		Instrument -> Link[instrumentResource],
		Replace[AlternateOptions]->Normal/@alternateInstrumentOptions,
		SeparationTime -> totalRunTime,
		CheckInFrequency -> checkInFrequency,
		Replace[ColumnSelector] -> Lookup[resolvedOptions, ColumnSelection],
		Replace[ColumnSelectorAssembly] -> columnSelectorUploadable,
		Column -> If[Length[columnSelectorResources]==1,
			columnSelectorResources[[1, 5]],
			Null
		],
		SecondaryColumn -> If[Length[columnSelectorResources]==1,
			columnSelectorResources[[1, 8]],
			Null
		],
		TertiaryColumn -> If[Length[columnSelectorResources]==1,
			columnSelectorResources[[1, 10]],
			Null
		],
		ColumnOrientation -> If[Length[columnSelectorResources]==1,
			columnSelectorResources[[1, 6]],
			Null
		],
		IncubateColumn -> Lookup[myResolvedOptions, IncubateColumn],
		ColumnHolders -> columnHolderResources,

		Replace[InjectionTable] -> injectionTableUploadable,
		GuardColumn -> If[Length[columnSelectorResources]==1,
			columnSelectorResources[[1, 2]],
			Null
		],
		GuardColumnOrientation -> If[Length[columnSelectorResources]==1,
			columnSelectorResources[[1, 3]],
			Null
		],
		(* In the case we don't have column, make sure our GuardCartridge is also an empty list so the length matches *)
		Replace[GuardCartridge] -> guardCartridgeResources,

		(* We let Cover pick the plate seal resource and this is just a model here *)
		PlateSeal -> Link[Model[Item, PlateSeal, "id:Vrbp1jKZJ0Rm"]],
		BufferA -> Link[bufferAResource],
		BufferB -> Link[bufferBResource],
		BufferC -> Link[bufferCResource],
		BufferD -> Link[bufferDResource],
		(* Do not create resource yet if not used in LCMS. We will require resource in Engine so alternate instruments are exchangable  *)
		NeedleWashSolution -> If[internalUsageQ,
			Link[needleWashResource],
			Link[needleWashSolution]
		],
		Replace[NeedleWashPlacements] -> needleWashSolutionPlacements,
		Scale -> Lookup[myResolvedOptions, Scale],

		Replace[InjectionVolumes] -> Lookup[optionsWithReplicates, InjectionVolume],
		Replace[Gradients] -> injectionTableWithReplicates[[samplePositionsWithReplicates, 6]],
		Replace[GradientA] -> splitGradient[sampleGradientA,Full],
		Replace[IsocraticGradientA] -> splitGradient[sampleGradientA,Isocratic],
		Replace[GradientB] -> splitGradient[sampleGradientB,Full],
		Replace[IsocraticGradientB] -> splitGradient[sampleGradientB,Isocratic],
		Replace[GradientC] -> splitGradient[sampleGradientC,Full],
		Replace[IsocraticGradientC] -> splitGradient[sampleGradientC,Isocratic],
		Replace[GradientD] -> splitGradient[sampleGradientD,Full],
		Replace[IsocraticGradientD] -> splitGradient[sampleGradientD,Isocratic],
		Replace[FlowRateConstant] -> sampleFlowRatesConstant,
		Replace[FlowRateVariable] -> sampleFlowRatesVariable,
		Replace[ColumnTemperatures] -> sampleColumnTemperatures /.{Ambient->$AmbientTemperature},

		Replace[ColumnPrimeGradients] -> If[Length[columnPrimePositions] > 0, injectionTableWithLinks[[Keys[DeleteDuplicatesBy[Normal[columnPrimeReverseAssociation], Values[#]&]], 6]]],
		Replace[ColumnPrimeGradientAs] -> splitGradient[columnPrimeGradientA,Full],
		Replace[ColumnPrimeIsocraticGradientAs] -> splitGradient[columnPrimeGradientA,Isocratic],
		Replace[ColumnPrimeGradientBs] -> splitGradient[columnPrimeGradientB,Full],
		Replace[ColumnPrimeIsocraticGradientBs] -> splitGradient[columnPrimeGradientB,Isocratic],
		Replace[ColumnPrimeGradientCs] -> splitGradient[columnPrimeGradientC,Full],
		Replace[ColumnPrimeIsocraticGradientCs] -> splitGradient[columnPrimeGradientC,Isocratic],
		Replace[ColumnPrimeGradientDs] -> splitGradient[columnPrimeGradientD,Full],
		Replace[ColumnPrimeIsocraticGradientDs] -> splitGradient[columnPrimeGradientD,Isocratic],
		Replace[ColumnPrimeFlowRateConstant] -> columnPrimeFlowRatesConstant,
		Replace[ColumnPrimeFlowRateVariable] -> columnPrimeFlowRatesVariable,
		Replace[ColumnPrimeTemperatures]->columnPrimeTemperatures/.{Ambient->$AmbientTemperature},

		Replace[Standards] -> linkedStandardResources,
		Replace[StandardSampleVolumes] -> If[Length[standardPositions] > 0, injectionTableWithLinks[[standardPositions, 3]]],
		Replace[StandardGradients] -> If[Length[standardPositions] > 0, injectionTableWithLinks[[standardPositions, 6]]],
		Replace[StandardGradientA] -> splitGradient[standardGradientA,Full],
		Replace[StandardIsocraticGradientA] -> splitGradient[standardGradientA,Isocratic],
		Replace[StandardGradientB] -> splitGradient[standardGradientB,Full],
		Replace[StandardIsocraticGradientB] -> splitGradient[standardGradientB,Isocratic],
		Replace[StandardGradientC] -> splitGradient[standardGradientC,Full],
		Replace[StandardIsocraticGradientC] -> splitGradient[standardGradientC,Isocratic],
		Replace[StandardGradientD] -> splitGradient[standardGradientD,Full],
		Replace[StandardIsocraticGradientD] -> splitGradient[standardGradientD,Isocratic],
		Replace[StandardFlowRateConstant] -> standardFlowRates,
		Replace[StandardFlowRateVariable] -> standardFlowRatesVariable,
		Replace[StandardColumnTemperatures]-> standardTemperatures/.{Ambient->$AmbientTemperature},

		Replace[Blanks] -> linkedBlankResources,
		Replace[BlankSampleVolumes] -> If[Length[blankPositions] > 0, injectionTableWithLinks[[blankPositions, 3]]],
		Replace[BlankGradients] -> If[Length[blankPositions] > 0, injectionTableWithLinks[[blankPositions, 6]]],
		Replace[BlankGradientA] -> splitGradient[blankGradientA,Full],
		Replace[BlankIsocraticGradientA] -> splitGradient[blankGradientA,Isocratic],
		Replace[BlankGradientB] -> splitGradient[blankGradientB,Full],
		Replace[BlankIsocraticGradientB] -> splitGradient[blankGradientB,Isocratic],
		Replace[BlankGradientC] -> splitGradient[blankGradientC,Full],
		Replace[BlankIsocraticGradientC] -> splitGradient[blankGradientC,Isocratic],
		Replace[BlankGradientD] -> splitGradient[blankGradientD,Full],
		Replace[BlankIsocraticGradientD] -> splitGradient[blankGradientD,Isocratic],
		Replace[BlankFlowRateConstant] -> blankFlowRatesConstant,
		Replace[BlankFlowRateVariable] -> blankFlowRatesVariable,
		Replace[BlankColumnTemperatures]-> blankTemperatures/.{Ambient->$AmbientTemperature},

		Replace[ColumnFlushGradients] -> If[Length[columnFlushPositions] > 0, injectionTableWithLinks[[Keys[DeleteDuplicatesBy[Normal[columnFlushReverseAssociation], Values[#]&]], 6]]],
		Replace[ColumnFlushGradientAs] -> splitGradient[columnFlushGradientA,Full],
		Replace[ColumnFlushIsocraticGradientAs] -> splitGradient[columnFlushGradientA,Isocratic],
		Replace[ColumnFlushGradientBs] -> splitGradient[columnFlushGradientB,Full],
		Replace[ColumnFlushIsocraticGradientBs] -> splitGradient[columnFlushGradientB,Isocratic],
		Replace[ColumnFlushGradientCs] -> splitGradient[columnFlushGradientC,Full],
		Replace[ColumnFlushIsocraticGradientCs] -> splitGradient[columnFlushGradientC,Isocratic],
		Replace[ColumnFlushGradientDs] -> splitGradient[columnFlushGradientD,Full],
		Replace[ColumnFlushIsocraticGradientDs] -> splitGradient[columnFlushGradientD,Isocratic],
		Replace[ColumnFlushFlowRateConstant] -> columnFlushFlowRatesConstant,
		Replace[ColumnFlushFlowRateVariable] -> columnFlushFlowRatesVariable,
		Replace[ColumnFlushTemperatures]->columnFlushTemperatures/.{Ambient->$AmbientTemperature},

		(* Calibration related *)
		CalibrationWashSolution -> calibrationWashSolutionResource,
		CalibrationWashSolutionSyringe -> calibrationWashSolutionSyringeResource,
		CalibrationWashSolutionSyringeNeedle -> calibrationWashSolutionNeedleResource,
		CalibrationWashSolutionFlowRate -> calibrationWashSolutionFlowRate,
		CalibrationWashSolutionVolume -> calibrationWashSolutionVolume,
		CalibrationWasteContainer -> calibrationWasteContainer,
		CalibrationSyringePump -> syringePumpResource,

		(* pH detector calibration related *)
		pHCalibration -> Lookup[resolvedOptions, pHCalibration],
		LowpHCalibrationBuffer -> lowpHCalibrationBufferResource,
		LowpHCalibrationTarget -> Lookup[resolvedOptions, LowpHCalibrationTarget],
		HighpHCalibrationBuffer -> highpHCalibrationBufferResource,
		HighpHCalibrationTarget -> Lookup[resolvedOptions, HighpHCalibrationTarget],
		LowpHCalibrationBufferSyringe -> lowpHCalibrationBufferSyringeResource,
		LowpHCalibrationBufferSyringeNeedle -> lowpHCalibrationBufferNeedleResource,
		LowpHCalibrationBufferFlowRate -> lowpHCalibrationBufferFlowRate,
		LowpHCalibrationBufferVolume -> lowpHCalibrationBufferVolume,
		HighpHCalibrationBufferSyringe -> highpHCalibrationBufferSyringeResource,
		HighpHCalibrationBufferSyringeNeedle -> highpHCalibrationBufferNeedleResource,
		HighpHCalibrationBufferFlowRate -> highpHCalibrationBufferFlowRate,
		HighpHCalibrationBufferVolume -> highpHCalibrationBufferVolume,

		(* Conductivity detector calibration related *)
		ConductivityCalibration -> Lookup[resolvedOptions, pHCalibration],
		ConductivityCalibrationBuffer -> conductivityCalibrationBufferResource,
		ConductivityCalibrationTarget -> Lookup[resolvedOptions, ConductivityCalibrationTarget],
		ConductivityCalibrationBufferSyringe -> conductivityCalibrationBufferSyringeResource,
		ConductivityCalibrationBufferSyringeNeedle -> conductivityCalibrationBufferNeedleResource,
		ConductivityCalibrationBufferFlowRate -> conductivityCalibrationBufferFlowRate,
		ConductivityCalibrationBufferVolume -> conductivityCalibrationBufferVolume,

		MaxAcceleration -> Lookup[myResolvedOptions, MaxAcceleration],

		SampleTemperature -> If[MatchQ[Lookup[myResolvedOptions, SampleTemperature], Ambient],
			Null,
			Lookup[myResolvedOptions, SampleTemperature]
		],
		TubingRinseSolution -> Link[
			Resource[
				(* Milli-Q water *)
				Sample -> Model[Sample, "id:8qZ1VWNmdLBD"],
				Amount -> 500 Milli Liter,
				(* 1000 mL Glass Beaker *)
				Container -> Model[Container, Vessel, "id:O81aEB4kJJJo"],
				RentContainer -> True
			]
		],
		SeparationMode -> Lookup[myResolvedOptions, SeparationMode],
		FractionCollection -> (Or @@ Lookup[myResolvedOptions, CollectFractions]),
		Replace[FractionContainers] -> If[(Or @@ Lookup[myResolvedOptions, CollectFractions]),
			Link /@ ConstantArray[Resource[Sample -> Download[Lookup[myResolvedOptions, FractionCollectionContainer], Object]], fractionContainerCount],
			{}
		],
		NumberOfFractionContainers -> fractionContainerCount,
		(* If fraction container replacement is required, it is picked from this field. Do not create resources for these. *)
		Replace[ReplacementFractionContainers] -> If[(Or @@ Lookup[myResolvedOptions, CollectFractions]),
			Link /@ ConstantArray[Download[Lookup[myResolvedOptions, FractionCollectionContainer], Object], fractionContainerCount],
			{}
		],

		FractionCollectionDetector -> Lookup[myResolvedOptions, FractionCollectionDetector],
		Replace[FractionCollectionMethods] -> Map[
			If[NullQ[#],
				Null,
				Link[Lookup[#, Object]]
			]&,
			fractionPackets
		],

		SystemPrimeBufferA -> If[internalUsageQ,
			Link[systemPrimeBufferAResource],
			Link[systemPrimeBufferA]
		],
		SystemPrimeBufferB -> If[internalUsageQ,
			Link[systemPrimeBufferBResource],
			Link[systemPrimeBufferB]
		],
		SystemPrimeBufferC -> If[internalUsageQ,
			Link[systemPrimeBufferCResource],
			Link[systemPrimeBufferC]
		],
		SystemPrimeBufferD -> If[internalUsageQ,
			Link[systemPrimeBufferDResource],
			Link[systemPrimeBufferD]
		],
		SystemPrimeGradient -> If[NullQ[systemPrimeGradientPacket],
			Null,
			Link[Lookup[systemPrimeGradientPacket, Object]]
		],
		Replace[SystemPrimeBufferContainerPlacements] -> systemPrimeBufferPlacements,
		SystemFlushBufferA -> If[internalUsageQ,
			Link[systemFlushBufferAResource],
			Link[systemFlushBufferA]
		],
		SystemFlushBufferB -> If[internalUsageQ,
			Link[systemFlushBufferBResource],
			Link[systemFlushBufferB]
		],
		SystemFlushBufferC -> If[internalUsageQ,
			Link[systemFlushBufferCResource],
			Link[systemFlushBufferC]
		],
		SystemFlushBufferD -> If[internalUsageQ,
			Link[systemFlushBufferDResource],
			Link[systemFlushBufferD]
		],
		SystemFlushGradient -> If[NullQ[systemFlushGradientPacket],
			Null,
			Link[Lookup[systemFlushGradientPacket, Object]]
		],
		Replace[SystemFlushBufferContainerPlacements] -> systemFlushBufferPlacements,
		ShutdownMethod -> If[NullQ[shutdownGradient],Null,Link[shutdownGradient]],
		ShutdownFilename -> shutdownFileName,
		MaxPressure -> upperPressureLimit,
		MinPressure -> Lookup[myResolvedOptions, LowPressureLimit, 100PSI] /. {Null -> 100PSI},

		Replace[Checkpoints] -> checkpoints,
		NumberOfReplicates -> numberOfReplicates,
		Replace[SamplesOutStorage] -> If[NullQ[Lookup[myResolvedOptions, SamplesOutStorageCondition]],
			{},
			Lookup[myResolvedOptions, SamplesOutStorageCondition]
		],
		Replace[StandardsStorageConditions] -> expandedStandardsStorageConditions,
		Replace[BlanksStorageConditions] -> expandedBlanksStorageConditions,
		InjectionSampleVolumeMeasurement -> Lookup[myResolvedOptions, InjectionSampleVolumeMeasurement],
		UnresolvedOptions -> myUnresolvedOptions,
		ResolvedOptions -> CollapseIndexMatchedOptions[ExperimentHPLC, myResolvedOptions, Ignore -> ToList[myUnresolvedOptions], Messages -> False]
	];

	(*Now get our instrument specific protocol packet*)
	instrumentSpecifiedProtocolPacket = hplcInstrumentResourcePackets[protocolObjectID, instrumentModel, Cache -> Append[cache, majorityProtocolPacket], Upload -> False];

	(* Join protocol-specific packet with shared fields packet and the instrument specific *)
	joinedProtocolPacket = Join[
		majorityProtocolPacket,
		instrumentSpecifiedProtocolPacket,
		sharedFieldPacket
	];

	(* Return all generated packets *)
	allPackets = Join[
		{joinedProtocolPacket},
		uniqueGradientPackets,
		If[!NullQ[shutdownGradient],
			{shutdownGradient},
			{}
		],
		newFractionPackets
	];

	(* Extract all resources *)
	allResources = If[!internalUsageQ, DeleteDuplicates[Cases[allPackets, _Resource, Infinity]]];

	(* Check fulfillability to resources *)
	(* Don't need to do this test if internal*)
	{resourcesFulfillableQ, resourceTests} = If[!internalUsageQ,
		If[gatherTestsQ,
			Resources`Private`fulfillableResourceQ[allResources, Site -> Lookup[myResolvedOptions, Site], Output -> {Result, Tests}, Cache -> cache],
			{Resources`Private`fulfillableResourceQ[allResources, Site -> Lookup[myResolvedOptions, Site], Cache -> cache], {}}
		],
		{Null, Null}
	];

	(* Return requested output *)
	outputSpecification /. {
		Result -> If[resourcesFulfillableQ || internalUsageQ,
			allPackets,
			{$Failed, $Failed}
		],
		Tests -> resourceTests
	}

];


(* ::Subsection::Closed:: *)
(*hplcInstrumentResourcePackets*)


(* ::Subsubsection:: *)
(*hplcInstrumentResourcePackets*)


(* This is a shared resource packets function used by the resource packets here and in the procedure through an execute task in case another instrument is selected *)

DefineOptions[
	hplcInstrumentResourcePackets,
	Options :> {OutputOption, CacheOption, UploadOption}
];

hplcInstrumentResourcePackets[
	myProtocol : ObjectP[Object[Protocol, HPLC]],
	instrumentModel : ObjectP[Model[Instrument, HPLC]],
	ops : OptionsPattern[hplcInstrumentResourcePackets]
] := Module[
	{
		cache, preuploadPacketQ, resolvedOptions, safeOptions, uploadQ, alternateOptions, instrumentModelPacket, pertinentOptions,
		columnPrimeWavelengthResolutions, columnPrimeUVFilter, columnPrimeAbsorbanceSamplingRates,
		columnPrimeExcitationWavelengths, columnPrimeSecondaryExcitationWavelengths, columnPrimeTertiaryExcitationWavelengths, columnPrimeQuaternaryExcitationWavelengths, columnPrimeEmissionWavelengths, columnPrimeSecondaryEmissionWavelengths, columnPrimeTertiaryEmissionWavelengths, columnPrimeQuaternaryEmissionWavelengths, columnPrimeEmissionCutOffFilters, columnPrimeFluorescenceGains, columnPrimeSecondaryFluorescenceGains, columnPrimeTertiaryFluorescenceGains, columnPrimeQuaternaryFluorescenceGains, columnPrimeFluorescenceFlowCellTemperatures,
		columnPrimeLightScatteringLaserPowers, columnPrimeLightScatteringFlowCellTemperatures, columnPrimeRefractiveIndexMethods, columnPrimeRefractiveIndexFlowCellTemperatures,
		columnPrimeNebulizerGases, columnPrimeNebulizerGasPressures, columnPrimeNebulizerGasHeatings, columnPrimeNebulizerHeatingPowers, columnPrimeDriftTubeTemperatures, columnPrimeELSDGains, columnPrimeELSDSamplingRates,
		sampleWavelengthResolutions, sampleUVFilter, sampleAbsorbanceSamplingRates,
		sampleExcitationWavelengths, sampleSecondaryExcitationWavelengths, sampleTertiaryExcitationWavelengths, sampleQuaternaryExcitationWavelengths, sampleEmissionWavelengths, sampleSecondaryEmissionWavelengths, sampleTertiaryEmissionWavelengths, sampleQuaternaryEmissionWavelengths, sampleEmissionCutOffFilters, sampleFluorescenceGains, sampleSecondaryFluorescenceGains, sampleTertiaryFluorescenceGains, sampleQuaternaryFluorescenceGains, sampleFluorescenceFlowCellTemperatures,
		sampleLightScatteringLaserPowers, sampleLightScatteringFlowCellTemperatures, sampleRefractiveIndexMethods, sampleRefractiveIndexFlowCellTemperatures,
		nebulizerGas, nebulizerGasHeating, nebulizerHeatingPower, nebulizerGasPressure, driftTubeTemperature, elsdGain, elsdSamplingRate,
		standardWavelengthResolutions, standardUVFilter, standardAbsorbanceSamplingRates,
		standardExcitationWavelengths, standardSecondaryExcitationWavelengths, standardTertiaryExcitationWavelengths, standardQuaternaryExcitationWavelengths, standardEmissionWavelengths, standardSecondaryEmissionWavelengths, standardTertiaryEmissionWavelengths, standardQuaternaryEmissionWavelengths, standardEmissionCutOffFilters, standardFluorescenceGains, standardSecondaryFluorescenceGains, standardTertiaryFluorescenceGains, standardQuaternaryFluorescenceGains, standardFluorescenceFlowCellTemperatures,
		standardLightScatteringLaserPowers, standardLightScatteringFlowCellTemperatures, standardRefractiveIndexMethods, standardRefractiveIndexFlowCellTemperatures,
		standardDriftTubeTemperature, standardELSDGain, standardELSDSamplingRate, standardNebulizerGas, standardNebulizerGasHeating, standardNebulizerHeatingPower, standardNebulizerGasPressure,
		blankWavelengthResolutions, blankUVFilter, blankAbsorbanceSamplingRates,
		blankExcitationWavelengths, blankSecondaryExcitationWavelengths, blankTertiaryExcitationWavelengths, blankQuaternaryExcitationWavelengths, blankEmissionWavelengths, blankSecondaryEmissionWavelengths, blankTertiaryEmissionWavelengths, blankQuaternaryEmissionWavelengths, blankEmissionCutOffFilters, blankFluorescenceGains, blankSecondaryFluorescenceGains, blankTertiaryFluorescenceGains, blankQuaternaryFluorescenceGains, blankFluorescenceFlowCellTemperatures,
		blankLightScatteringLaserPowers, blankLightScatteringFlowCellTemperatures, blankRefractiveIndexMethods, blankRefractiveIndexFlowCellTemperatures,
		blankDriftTubeTemperature, blankELSDGain, blankELSDSamplingRate, blankNebulizerGas, blankNebulizerGasHeating, blankNebulizerHeatingPower, blankNebulizerGasPressure,
		columnFlushWavelengthResolutions, columnFlushUVFilter, columnFlushAbsorbanceSamplingRates,
		columnFlushExcitationWavelengths, columnFlushSecondaryExcitationWavelengths, columnFlushTertiaryExcitationWavelengths, columnFlushQuaternaryExcitationWavelengths, columnFlushEmissionWavelengths, columnFlushSecondaryEmissionWavelengths, columnFlushTertiaryEmissionWavelengths, columnFlushQuaternaryEmissionWavelengths, columnFlushEmissionCutOffFilters, columnFlushFluorescenceGains, columnFlushSecondaryFluorescenceGains, columnFlushTertiaryFluorescenceGains, columnFlushQuaternaryFluorescenceGains, columnFlushFluorescenceFlowCellTemperatures,
		columnFlushLightScatteringLaserPowers, columnFlushLightScatteringFlowCellTemperatures, columnFlushRefractiveIndexMethods, columnFlushRefractiveIndexFlowCellTemperatures,
		columnFlushNebulizerGases, columnFlushNebulizerGasPressures, columnFlushNebulizerGasHeatings, columnFlushNebulizerHeatingPowers, columnFlushDriftTubeTemperatures, columnFlushELSDGains, columnFlushELSDSamplingRates,
		instrumentSpecificPacket,
		columnPrimeAbsorbanceWavelength, columnPrimeMinAbsorbanceWavelengths, columnPrimeMaxAbsorbanceWavelengths,
		sampleAbsorbanceWavelength, sampleMinAbsorbanceWavelengths, sampleMaxAbsorbanceWavelengths, minAbsorbance, maxAbsorbance,
		standardAbsorbanceWavelength, standardMinAbsorbanceWavelengths, standardMaxAbsorbanceWavelengths,
		blankAbsorbanceWavelength, blankMinAbsorbanceWavelengths, blankMaxAbsorbanceWavelengths, injectionTable, injectionTableLookup,
		samplePositions, standardPositions, blankPositions, columnPrimePositions, columnFlushPositions, standardLookup, blankLookup,
		standardReverseAssociation, blankReverseAssociation, columnPrimeReverseAssociation, columnFlushReverseAssociation,
		columnFlushAbsorbanceWavelength, columnFlushMinAbsorbanceWavelengths, columnFlushMaxAbsorbanceWavelengths,
		standardPositionsCorresponded, blankPositionsCorresponded, columnPrimePositionsCorresponded, columnFlushPositionsCorresponded,
		standardMappingAssociation, blankMappingAssociation, columnPrimeMappingAssociation, columnFlushMappingAssociation,
		samplesInWithReplicates, samplesIn, unexpandedPertinentOptions, pertinentOptionsNoReplicate, sampleObjects, numberOfReplicates, samplesWithReplicates, protocolPacket, resolvedStandard, resolvedBlank, resolvedColumnSelector, listifiedStandard, listifiedBlank, listifiedColumnSelector,
		fluorescenceListRequiredQ, processedExcitationWavelength, processedEmissionWavelength, processedFluorescenceGain, processedStandardExcitationWavelength, processedStandardEmissionWavelength, processedStandardFluorescenceGain, processedBlankExcitationWavelength, processedBlankEmissionWavelength, processedBlankFluorescenceGain, processedColumnPrimeExcitationWavelength, processedColumnPrimeEmissionWavelength, processedColumnPrimeFluorescenceGain, processedColumnFlushExcitationWavelength, processedColumnFlushEmissionWavelength, processedColumnFlushFluorescenceGain
	},

	(* Filter input options through SafeOptions *)
	safeOptions = SafeOptions[hplcInstrumentResourcePackets, ToList[ops]];

	(* Fetch passed cache *)
	cache = OptionValue[Cache];

	(* Get Upload option *)
	uploadQ = TrueQ[Lookup[safeOptions, Upload]];

	(* Check whether we have the protocol packet before upload in our midst, if so grab it. Otherwise, we need to download *)
	preuploadPacketQ = Count[cache, KeyValuePattern[Object -> ObjectP[myProtocol]]] > 0;

	(* We want to get the resolved and alternate options from the protocol packet*)
	(* Note that the injection table should never change even if a different instrument is selected. We should get it from the protocol packet instead of the options because we must consider number of replicates *)
	{
		{samplesInWithReplicates, resolvedOptions, alternateOptions, injectionTableLookup},
		instrumentModelPacket
	} = If[preuploadPacketQ,
		(* First see if this is a preuploaded packet and, if so, fetch everything *)
		protocolPacket = fetchPacketFromCache[Download[myProtocol, Object], cache];
		{
			{
				(* Get the samplesIn. If it's a resource. we need to select out the samples *)
				Lookup[protocolPacket, Replace[SamplesIn], Lookup[protocolPacket, SamplesIn]] /. Resource[Association[Sample -> x_, Name -> _, Type -> _]] :> Download[x, Object],
				(* Get the resolved options*)
				Lookup[protocolPacket, ResolvedOptions],
				(* Finally get the alternate options *)
				Lookup[protocolPacket, Replace[AlternateOptions], Lookup[protocolPacket, AlternateOptions]],
				Lookup[protocolPacket, Replace[InjectionTable], Lookup[protocolPacket, InjectionTable]]
			},
			fetchPacketFromCache[instrumentModel, cache]
		},
		(* Otherwise, we'll need to download everything *)
		Download[
			{
				myProtocol,
				instrumentModel
			},
			{
				{SamplesIn, ResolvedOptions, AlternateOptions, InjectionTable},
				Packet[Detectors, MinAbsorbanceWavelength, MaxAbsorbanceWavelength]
			},
			Cache -> cache
		]
	];

	(* Make sure the injection table is in the correct format - change resource to the sample *)
	injectionTable = (Values[#]& /@ injectionTableLookup) /. {Link[x_Resource] :> x[Sample], x : LinkP[] :> Download[x, Object]};

	(* Select the correct set of options *)
	unexpandedPertinentOptions = If[MatchQ[instrumentModel, ObjectP[Lookup[resolvedOptions, Instrument][[1]]]],
		(* If the resolved options match the first instrument (the default instrument for all other options), then go with the resolved options *)
		Association@resolvedOptions,
		(* Otherwise we select out the instrument that we care about and use that *)
		Join[Association@resolvedOptions, Association@FirstCase[If[NullQ[alternateOptions], {}, alternateOptions], KeyValuePattern[Instrument -> ObjectP[instrumentModel]], Association[]]]
	];

	(* Get our number of replicates. *)
	numberOfReplicates = Lookup[unexpandedPertinentOptions, NumberOfReplicates] /. {Null -> 1};

	(* Collapse the SamplesIn based on numberOfReplicates - it is expanded when uploaded to Protocol *)
	samplesIn = Partition[samplesInWithReplicates, numberOfReplicates][[All, 1]];

	(* Get the standard, blank, and column selector *)
	{resolvedStandard, resolvedBlank, resolvedColumnSelector} = Lookup[unexpandedPertinentOptions, {Standard, Blank, ColumnSelector}]/.{object:ObjectP[]:>Download[object,Object]};

	(* We may need to listify if need be, i.e. if it's a singleton object *)
	{listifiedStandard, listifiedBlank} = Map[
		If[And[
			Depth[#] <= 2,
			MatchQ[#, Except[{} | Null]]
		],
			ToList[#],
			#
		]&,
		{Download[resolvedStandard,Object], Download[resolvedBlank,Object]}
	];

	(* ColumnSelector may be collapsed and need to be wrapped with another list *)
	listifiedColumnSelector = If[Depth[resolvedColumnSelector] <= 3, List[resolvedColumnSelector], resolvedColumnSelector];

	(* Another preparation is we may need to collapse ExcitationWavelength, EmissionWavelength and FluorescenceGain manually as these options allow both singleton and Adder widget and may be expanded wrongly *)
	(* We will make each entry a list. For example, 485Nanometer will because {485Nanometer}. Only need to do this when each entry is a singleton and the length matches the sample *)
	fluorescenceListRequiredQ = Map[
		Function[entry,
			Module[{sample, ex, em, gain},
				{sample, ex, em, gain} = entry;
				And[
					MatchQ[ex, {(DistanceP | {DistanceP})..}],
					MatchQ[em, {(DistanceP | {DistanceP})..}],
					MatchQ[gain, {(GreaterEqualP[0] | {GreaterEqualP[0]})..}],
					SameLengthQ[sample, ex, em, gain]
				]
			]
		],
		{
			{samplesIn, Lookup[unexpandedPertinentOptions, ExcitationWavelength], Lookup[unexpandedPertinentOptions, EmissionWavelength], Lookup[unexpandedPertinentOptions, FluorescenceGain]},
			{listifiedStandard, Lookup[unexpandedPertinentOptions, StandardExcitationWavelength], Lookup[unexpandedPertinentOptions, StandardEmissionWavelength], Lookup[unexpandedPertinentOptions, StandardFluorescenceGain]},
			{listifiedBlank, Lookup[unexpandedPertinentOptions, BlankExcitationWavelength], Lookup[unexpandedPertinentOptions, BlankEmissionWavelength], Lookup[unexpandedPertinentOptions, BlankFluorescenceGain]},
			{listifiedColumnSelector, Lookup[unexpandedPertinentOptions, ColumnPrimeExcitationWavelength], Lookup[unexpandedPertinentOptions, ColumnPrimeEmissionWavelength], Lookup[unexpandedPertinentOptions, ColumnPrimeFluorescenceGain]},
			{listifiedColumnSelector, Lookup[unexpandedPertinentOptions, ColumnFlushExcitationWavelength], Lookup[unexpandedPertinentOptions, ColumnFlushEmissionWavelength], Lookup[unexpandedPertinentOptions, ColumnFlushFluorescenceGain]}
		}
	];

	{
		{processedExcitationWavelength, processedEmissionWavelength, processedFluorescenceGain},
		{processedStandardExcitationWavelength, processedStandardEmissionWavelength, processedStandardFluorescenceGain},
		{processedBlankExcitationWavelength, processedBlankEmissionWavelength, processedBlankFluorescenceGain},
		{processedColumnPrimeExcitationWavelength, processedColumnPrimeEmissionWavelength, processedColumnPrimeFluorescenceGain},
		{processedColumnFlushExcitationWavelength, processedColumnFlushEmissionWavelength, processedColumnFlushFluorescenceGain}
	} = MapThread[
		Function[{bool, ex, em, gain},
			If[bool,
				{
					ToList[#]& /@ ex,
					ToList[#]& /@ em,
					ToList[#]& /@ gain
				},
				{ex, em, gain}
			]
		],
		{fluorescenceListRequiredQ, Lookup[unexpandedPertinentOptions, {ExcitationWavelength, StandardExcitationWavelength, BlankExcitationWavelength, ColumnPrimeExcitationWavelength, ColumnFlushExcitationWavelength}], Lookup[unexpandedPertinentOptions, {EmissionWavelength, StandardEmissionWavelength, BlankEmissionWavelength, ColumnPrimeEmissionWavelength, ColumnFlushEmissionWavelength}], Lookup[unexpandedPertinentOptions, {FluorescenceGain, StandardFluorescenceGain, BlankFluorescenceGain, ColumnPrimeFluorescenceGain, ColumnFlushFluorescenceGain}]}
	];

	(* Expand the options *)
	(* Here we change the resolved ColumnSelector to Automatic for success index matching expanding. It seems when ObjectP[] is resolved as the first element - GuardColumn of the ColumnSelector, ExpandIndexMatchedInputs is confused with the length. *)
	pertinentOptionsNoReplicate = Association[
		ReplaceRule[
			Last[ExpandIndexMatchedInputs[
				ExperimentHPLC,
				{samplesIn},
				Normal@Join[
					unexpandedPertinentOptions,
					Association[
						Standard -> listifiedStandard,
						Blank -> listifiedBlank,
						ColumnSelector -> listifiedColumnSelector/.{ObjectP[]->Automatic},
						ExcitationWavelength -> processedExcitationWavelength,
						StandardExcitationWavelength -> processedStandardExcitationWavelength,
						BlankExcitationWavelength -> processedBlankExcitationWavelength,
						ColumnPrimeExcitationWavelength -> processedColumnPrimeExcitationWavelength,
						ColumnFlushExcitationWavelength -> processedColumnFlushExcitationWavelength,
						EmissionWavelength -> processedEmissionWavelength,
						StandardEmissionWavelength -> processedStandardEmissionWavelength,
						BlankEmissionWavelength -> processedBlankEmissionWavelength,
						ColumnPrimeEmissionWavelength -> processedColumnPrimeEmissionWavelength,
						ColumnFlushEmissionWavelength -> processedColumnFlushEmissionWavelength,
						FluorescenceGain -> processedFluorescenceGain,
						StandardFluorescenceGain -> processedStandardFluorescenceGain,
						BlankFluorescenceGain -> processedBlankFluorescenceGain,
						ColumnPrimeFluorescenceGain -> processedColumnPrimeFluorescenceGain,
						ColumnFlushFluorescenceGain -> processedColumnFlushFluorescenceGain
					]
				],
				Messages -> False
			]],
			ColumnSelector -> listifiedColumnSelector
		]
	];

	(* Get rid of the links in mySamples. *)
	sampleObjects = samplesIn /. {object:ObjectP[] :> Download[object, Object]};

	(* Expand our samples and options according to NumberOfReplicates. *)
	{samplesWithReplicates, pertinentOptions} = expandNumberOfReplicates[ExperimentHPLC, sampleObjects, Normal@pertinentOptionsNoReplicate];

	(* Get all of the positions so that it's easy to update the injection table *)
	{samplePositions, standardPositions, blankPositions, columnPrimePositions, columnFlushPositions} = Map[
		Sequence @@@ Position[injectionTable, {#, ___}]&,
		{Sample, Standard, Blank, ColumnPrime, ColumnFlush}
	];

	(* We need to create a mapping association so the index matching from the types goes to the positions with the table.
	For example, the resolvedBlank maybe length 2 (e.g. {blank1,blank2}; However this may be repeated in the injectiontable based on the set BlankFrequency. For example BlankFrequency -> FirstAndLast will place at the beginning at the end therefore, we need to have associations for each that points to the locations within the table so that it's easier to update the resources*)

	(* A helper function used to make the reverse dictionary so that we can go from the injection table position to the other variables *)
	makeReverseAssociation[inputAssociation : Null] := Null;
	makeReverseAssociation[inputAssociation_Association] := Association[
		SortBy[
			Flatten@Map[
				Function[{rule},
					Map[# -> First[rule]&, Last[rule]]
				],
				Normal@inputAssociation
			],
			First
		]
	];

	(* Look up the standards and the blanks*)
	{standardLookup, blankLookup} = ToList /@ Lookup[pertinentOptions, {Standard, Blank}];

	(* First do the standards *)
	standardMappingAssociation = If[MatchQ[standardLookup, Null | {Null} | {}],
		(* First check whether there is anything here *)
		Null,
		(* Otherwise we have to partition the positions by the length of our standards and map through *)
		Association[
			MapIndexed[
				Function[
					{positionSet, index},
					First[index] -> positionSet
				],
				Transpose[
					Partition[standardPositions, Length[standardLookup]]
				]
			]
		]
	];

	(* Do the blanks in the same way *)
	blankMappingAssociation = If[MatchQ[blankLookup, Null | {Null} | {}],
		(* First check whether there is anything here *)
		Null,
		(* Otherwise we have to partition the positions by the length of our standards and map through *)
		Association[
			MapIndexed[
				Function[
					{positionSet, index},
					First[index] -> positionSet
				],
				Transpose[
					Partition[blankPositions, Length[blankLookup]]
				]
			]
		]
	];

	(* For the column prime and flush, it's a bit easier because we can simply considering by the column (position) *)
	columnPrimeMappingAssociation = Association[
		MapIndexed[
			Function[{columnTuple, index},
				First[index] -> Sequence @@@ Position[injectionTable, {ColumnPrime, _, _, columnTuple[[1]], ___}]
			],
			listifiedColumnSelector
		]
	];

	columnFlushMappingAssociation = Association[
		MapIndexed[
			Function[{columnTuple, index},
				(* The InjectionTable here has extra columns as in InjectionTable for upload *)
				First[index] -> Sequence @@@ Position[injectionTable, {ColumnFlush, _, _, columnTuple[[1]], ___}]
			],
			listifiedColumnSelector
		]
	];

	(* Make the reverse associations *)
	{standardReverseAssociation, blankReverseAssociation, columnPrimeReverseAssociation, columnFlushReverseAssociation} = Map[makeReverseAssociation,
		{standardMappingAssociation, blankMappingAssociation, columnPrimeMappingAssociation, columnFlushMappingAssociation}
	];

	(* To fill in the parameters we just need the injection table positions corresponded to the pertinent ones *)
	standardPositionsCorresponded = If[Length[standardPositions] > 0, Last /@ SortBy[Normal@standardReverseAssociation, First]];
	blankPositionsCorresponded = If[Length[blankPositions] > 0, Last /@ SortBy[Normal@blankReverseAssociation, First]];
	columnPrimePositionsCorresponded = If[Length[columnPrimePositions] > 0, Last /@ SortBy[Normal@columnPrimeReverseAssociation, First]];
	columnFlushPositionsCorresponded = If[Length[columnFlushPositions] > 0, Last /@ SortBy[Normal@columnFlushReverseAssociation, First]];

	(* Start with the column prime*)
	(* Start with the ones that can be directly transferred into protocol object*)
	{
		columnPrimeWavelengthResolutions,
		columnPrimeUVFilter,
		columnPrimeAbsorbanceSamplingRates,
		columnPrimeLightScatteringLaserPowers,
		columnPrimeRefractiveIndexMethods,
		columnPrimeNebulizerGases,
		columnPrimeNebulizerGasPressures,
		columnPrimeNebulizerGasHeatings,
		columnPrimeNebulizerHeatingPowers,
		columnPrimeDriftTubeTemperatures,
		columnPrimeELSDGains,
		columnPrimeELSDSamplingRates
	} = Map[
		Function[
			{optionLookup},
			If[!NullQ[columnPrimePositionsCorresponded] && !NullQ[optionLookup],
				optionLookup[[DeleteDuplicates[columnPrimePositionsCorresponded]]],
				Null
			]
		],
		Lookup[pertinentOptions,
			{
				ColumnPrimeWavelengthResolution,
				ColumnPrimeUVFilter,
				ColumnPrimeAbsorbanceSamplingRate,
				ColumnPrimeLightScatteringLaserPower,
				ColumnPrimeRefractiveIndexMethod,
				ColumnPrimeNebulizerGas,
				ColumnPrimeNebulizerGasPressure,
				ColumnPrimeNebulizerGasHeating,
				ColumnPrimeNebulizerHeatingPower,
				ColumnPrimeDriftTubeTemperature,
				ColumnPrimeELSDGain,
				ColumnPrimeELSDSamplingRate
			}
		]
	];

	(* Fluorescence options - need to break up into 4 groups*)
	{
		columnPrimeExcitationWavelengths,
		columnPrimeSecondaryExcitationWavelengths,
		columnPrimeTertiaryExcitationWavelengths,
		columnPrimeQuaternaryExcitationWavelengths,
		columnPrimeEmissionWavelengths,
		columnPrimeSecondaryEmissionWavelengths,
		columnPrimeTertiaryEmissionWavelengths,
		columnPrimeQuaternaryEmissionWavelengths,
		columnPrimeFluorescenceGains,
		columnPrimeSecondaryFluorescenceGains,
		columnPrimeTertiaryFluorescenceGains,
		columnPrimeQuaternaryFluorescenceGains
	} = If[NullQ[Lookup[pertinentOptions, ColumnPrimeExcitationWavelength]] || NullQ[columnPrimePositionsCorresponded],
		(* If Fluorescence is not selected, i.e., the options are Null, upload with {} *)
		ConstantArray[Null, 12],
		(* Break up the options into the protocol fields *)
		Map[
			#[[DeleteDuplicates[columnPrimePositionsCorresponded]]]&,
			Transpose[
				MapThread[
					Function[
						{exValues, emValues, gainValues},
						Module[
							{length, expandedGainValues, expandedExValues, expandedEmValues},
							length = Length[ToList[exValues]];

							(* Add Null for empty channels *)
							expandedExValues = PadRight[ToList[exValues], 4, Null];
							expandedEmValues = PadRight[ToList[emValues], 4, Null];
							(* Expand Gain to the same length with Ex/Em and then add Null for empty channels *)
							expandedGainValues = PadRight[
								If[Length[ToList[gainValues]] == 1,
									Flatten[ConstantArray[gainValues, length]],
									gainValues
								],
								4,
								Null
							];
							(* Return all the values *)
							Flatten[{expandedExValues, expandedEmValues, expandedGainValues}]
						]
					],
					{Lookup[pertinentOptions, ColumnPrimeExcitationWavelength], Lookup[pertinentOptions, ColumnPrimeEmissionWavelength], Lookup[pertinentOptions, ColumnPrimeFluorescenceGain]}
				]
			]
		]
	];

	(* Change cut-off filter values from None to Null  *)
	columnPrimeEmissionCutOffFilters = If[NullQ[Lookup[pertinentOptions, ColumnPrimeEmissionCutOffFilter]] || NullQ[columnPrimePositionsCorresponded],
		Null,
		Map[
			(* Change None to Null *)
			If[MatchQ[#, None], Null, #]&,
			Lookup[pertinentOptions, ColumnPrimeEmissionCutOffFilter][[DeleteDuplicates[columnPrimePositionsCorresponded]]]
		]
	];

	(* Temperature options - changes from ambient to Null is required for upload *)
	{columnPrimeFluorescenceFlowCellTemperatures, columnPrimeLightScatteringFlowCellTemperatures, columnPrimeRefractiveIndexFlowCellTemperatures} = Map[
		If[MatchQ[#, Null | {}] || NullQ[columnPrimePositionsCorresponded],
			Null,
			ReplaceAll[#[[DeleteDuplicates[columnPrimePositionsCorresponded]]], Ambient -> $AmbientTemperature]
		]&,
		{Lookup[pertinentOptions, ColumnPrimeFluorescenceFlowCellTemperature], Lookup[pertinentOptions, ColumnPrimeLightScatteringFlowCellTemperature], Lookup[pertinentOptions, ColumnPrimeRefractiveIndexFlowCellTemperature]}
	];

	(* Now get the samples, which will always be there, so no mapping checks/positioning needed *)
	(* Start with the ones that can be directly transferred into protocol object *)
	{
		sampleWavelengthResolutions,
		sampleUVFilter,
		sampleAbsorbanceSamplingRates,
		sampleLightScatteringLaserPowers,
		sampleRefractiveIndexMethods,
		nebulizerGas,
		nebulizerGasHeating,
		nebulizerHeatingPower,
		nebulizerGasPressure,
		driftTubeTemperature,
		elsdGain,
		elsdSamplingRate
	} = Lookup[pertinentOptions,
		{
			WavelengthResolution,
			UVFilter,
			AbsorbanceSamplingRate,
			LightScatteringLaserPower,
			RefractiveIndexMethod,
			NebulizerGas,
			NebulizerGasHeating,
			NebulizerHeatingPower,
			NebulizerGasPressure,
			DriftTubeTemperature,
			ELSDGain,
			ELSDSamplingRate
		}
	];

	(* Fluorescence options - need to break up into 4 groups *)
	{
		sampleExcitationWavelengths,
		sampleSecondaryExcitationWavelengths,
		sampleTertiaryExcitationWavelengths,
		sampleQuaternaryExcitationWavelengths,
		sampleEmissionWavelengths,
		sampleSecondaryEmissionWavelengths,
		sampleTertiaryEmissionWavelengths,
		sampleQuaternaryEmissionWavelengths,
		sampleFluorescenceGains,
		sampleSecondaryFluorescenceGains,
		sampleTertiaryFluorescenceGains,
		sampleQuaternaryFluorescenceGains
	} = If[NullQ[Lookup[pertinentOptions, ExcitationWavelength]],
		(* If Fluorescence is not selected, i.e., the options are Null, upload with {} *)
		ConstantArray[Null, 12],
		(* Break up the options into the protocol fields *)
		Transpose[
			MapThread[
				Function[
					{exValues, emValues, gainValues},
					Module[
						{length, expandedGainValues, expandedExValues, expandedEmValues},
						length = Length[ToList[exValues]];
						(* Add Null for empty channels *)
						expandedExValues = PadRight[ToList[exValues], 4, Null];
						expandedEmValues = PadRight[ToList[emValues], 4, Null];
						(* Expand Gain to the same length with Ex/Em and then add Null for empty channels *)
						expandedGainValues = PadRight[
							If[Length[ToList[gainValues]] == 1,
								Flatten[ConstantArray[gainValues, length]],
								gainValues
							],
							4,
							Null
						];
						(* Return all the values *)
						Flatten[{
							expandedExValues, expandedEmValues, expandedGainValues
						}]
					]
				],
				{Lookup[pertinentOptions, ExcitationWavelength], Lookup[pertinentOptions, EmissionWavelength], Lookup[pertinentOptions, FluorescenceGain]}
			]
		]
	];

	(* Change cut-off filter values from None to Null  *)
	sampleEmissionCutOffFilters = If[NullQ[Lookup[pertinentOptions, EmissionCutOffFilter]],
		Null,
		Map[
			(* Change None to Null *)
			If[MatchQ[#, None], Null, #]&,
			Lookup[pertinentOptions, EmissionCutOffFilter]
		]
	];

	(* Temperature options - changes from ambient to Null is required for upload *)
	{sampleFluorescenceFlowCellTemperatures, sampleLightScatteringFlowCellTemperatures, sampleRefractiveIndexFlowCellTemperatures} = Map[
		ReplaceAll[#, Ambient -> $AmbientTemperature]&,
		{Lookup[pertinentOptions, FluorescenceFlowCellTemperature], Lookup[pertinentOptions, LightScatteringFlowCellTemperature], Lookup[pertinentOptions, RefractiveIndexFlowCellTemperature]}
	];

	(* Now the standard samples *)
	(* Start with the ones that can be directly transferred into protocol object *)
	{
		standardWavelengthResolutions,
		standardUVFilter,
		standardAbsorbanceSamplingRates,
		standardLightScatteringLaserPowers,
		standardRefractiveIndexMethods,
		standardDriftTubeTemperature,
		standardELSDGain,
		standardELSDSamplingRate,
		standardNebulizerGas,
		standardNebulizerGasHeating,
		standardNebulizerHeatingPower,
		standardNebulizerGasPressure
	} = Map[
		Function[{optionLookup},
			If[!NullQ[standardPositionsCorresponded] && !NullQ[optionLookup],
				optionLookup[[standardPositionsCorresponded]],
				Null
			]
		],
		Lookup[pertinentOptions,
			{
				StandardWavelengthResolution,
				StandardUVFilter,
				StandardAbsorbanceSamplingRate,
				StandardLightScatteringLaserPower,
				StandardRefractiveIndexMethod,
				StandardDriftTubeTemperature,
				StandardELSDGain,
				StandardELSDSamplingRate,
				StandardNebulizerGas,
				StandardNebulizerGasHeating,
				StandardNebulizerHeatingPower,
				StandardNebulizerGasPressure
			}
		]
	];

	(* Fluorescence options - need to break up into 4 groups *)
	{
		standardExcitationWavelengths,
		standardSecondaryExcitationWavelengths,
		standardTertiaryExcitationWavelengths,
		standardQuaternaryExcitationWavelengths,
		standardEmissionWavelengths,
		standardSecondaryEmissionWavelengths,
		standardTertiaryEmissionWavelengths,
		standardQuaternaryEmissionWavelengths,
		standardFluorescenceGains,
		standardSecondaryFluorescenceGains,
		standardTertiaryFluorescenceGains,
		standardQuaternaryFluorescenceGains
	} = If[NullQ[Lookup[pertinentOptions, StandardExcitationWavelength]] || NullQ[standardPositionsCorresponded],
		(* If Fluorescence is not selected, i.e., the options are Null, upload with {} *)
		ConstantArray[Null, 12],
		(* Break up the options into the protocol fields and expand out by the corresponding positions*)
		Map[
			#[[standardPositionsCorresponded]]&,
			Transpose[
				MapThread[
					Function[
						{exValues, emValues, gainValues},
						Module[
							{length, expandedGainValues, expandedExValues, expandedEmValues},
							length = Length[ToList[exValues]];

							(* Add Null for empty channels *)
							expandedExValues = PadRight[ToList[exValues], 4, Null];
							expandedEmValues = PadRight[ToList[emValues], 4, Null];
							(* Expand Gain to the same length with Ex/Em and then add Null for empty channels *)
							expandedGainValues = PadRight[
								If[Length[ToList[gainValues]] == 1,
									Flatten[ConstantArray[gainValues, length]],
									gainValues
								],
								4,
								Null
							];
							(* Return all the values *)
							Flatten[{expandedExValues, expandedEmValues, expandedGainValues}]
						]
					],
					{Lookup[pertinentOptions, StandardExcitationWavelength], Lookup[pertinentOptions, StandardEmissionWavelength], Lookup[pertinentOptions, StandardFluorescenceGain]}
				]
			]
		]
	];

	(* Change cut-off filter values from None to Null *)
	standardEmissionCutOffFilters = If[NullQ[Lookup[pertinentOptions, StandardEmissionCutOffFilter]] || NullQ[standardPositionsCorresponded],
		Null,
		Map[
			(* Change None to Null *)
			If[MatchQ[#, None], Null, #]&,
			Lookup[pertinentOptions, StandardEmissionCutOffFilter][[standardPositionsCorresponded]]
		]
	];

	(* Temperature options - changes from ambient to 25Celsius is required for upload *)
	{standardFluorescenceFlowCellTemperatures, standardLightScatteringFlowCellTemperatures, standardRefractiveIndexFlowCellTemperatures} = Map[
		If[MatchQ[#, Null | {}] || NullQ[standardPositionsCorresponded],
			Null,
			ReplaceAll[#[[standardPositionsCorresponded]], Ambient -> $AmbientTemperature]
		]&,
		{Lookup[pertinentOptions, StandardFluorescenceFlowCellTemperature], Lookup[pertinentOptions, StandardLightScatteringFlowCellTemperature], Lookup[pertinentOptions, StandardRefractiveIndexFlowCellTemperature]}
	];

	(* Now the blank samples*)
	(* Start with the ones that can be directly transferred into protocol object *)
	{
		blankWavelengthResolutions,
		blankUVFilter,
		blankAbsorbanceSamplingRates,
		blankLightScatteringLaserPowers,
		blankRefractiveIndexMethods,
		blankDriftTubeTemperature,
		blankELSDGain,
		blankELSDSamplingRate,
		blankNebulizerGas,
		blankNebulizerGasHeating,
		blankNebulizerHeatingPower,
		blankNebulizerGasPressure
	} = Map[
		Function[{optionLookup},
			If[!NullQ[blankPositionsCorresponded] && !NullQ[optionLookup],
				optionLookup[[blankPositionsCorresponded]],
				Null
			]
		],
		Lookup[pertinentOptions,
			{
				BlankWavelengthResolution,
				BlankUVFilter,
				BlankAbsorbanceSamplingRate,
				BlankLightScatteringLaserPower,
				BlankRefractiveIndexMethod,
				BlankDriftTubeTemperature,
				BlankELSDGain,
				BlankELSDSamplingRate,
				BlankNebulizerGas,
				BlankNebulizerGasHeating,
				BlankNebulizerHeatingPower,
				BlankNebulizerGasPressure
			}
		]
	];

	(* Fluorescence options - need to break up into 4 groups *)
	{
		blankExcitationWavelengths,
		blankSecondaryExcitationWavelengths,
		blankTertiaryExcitationWavelengths,
		blankQuaternaryExcitationWavelengths,
		blankEmissionWavelengths,
		blankSecondaryEmissionWavelengths,
		blankTertiaryEmissionWavelengths,
		blankQuaternaryEmissionWavelengths,
		blankFluorescenceGains,
		blankSecondaryFluorescenceGains,
		blankTertiaryFluorescenceGains,
		blankQuaternaryFluorescenceGains
	} = If[NullQ[Lookup[pertinentOptions, BlankExcitationWavelength]] || NullQ[blankPositionsCorresponded],
		(* If Fluorescence is not selected, i.e., the options are Null, upload with {} *)
		ConstantArray[Null, 12],
		(* Break up the options into the protocol fields and expand out by the corresponding positinos *)
		Map[
			#[[blankPositionsCorresponded]]&,
			Transpose[
				MapThread[
					Function[
						{exValues, emValues, gainValues},
						Module[
							{length, expandedGainValues, expandedExValues, expandedEmValues},
							length = Length[ToList[exValues]];

							(* Add Null for empty channels *)
							expandedExValues = PadRight[ToList[exValues], 4, Null];
							expandedEmValues = PadRight[ToList[emValues], 4, Null];
							(* Expand Gain to the same length with Ex/Em and then add Null for empty channels *)
							expandedGainValues = PadRight[
								If[Length[ToList[gainValues]] == 1,
									Flatten[ConstantArray[gainValues, length]],
									gainValues
								],
								4,
								Null
							];
							(* Return all the values *)
							Flatten[{expandedExValues, expandedEmValues, expandedGainValues}]
						]
					],
					{Lookup[pertinentOptions, BlankExcitationWavelength], Lookup[pertinentOptions, BlankEmissionWavelength], Lookup[pertinentOptions, BlankFluorescenceGain]}
				]
			]
		]
	];

	(* Change cut-off filter values from None to Null *)
	blankEmissionCutOffFilters = If[NullQ[Lookup[pertinentOptions, BlankEmissionCutOffFilter]] || NullQ[blankPositionsCorresponded],
		Null,
		Map[
			(* Change None to Null *)
			If[MatchQ[#, None], Null, #]&,
			Lookup[pertinentOptions, BlankEmissionCutOffFilter][[blankPositionsCorresponded]]
		]
	];

	(* Temperature options - changes from ambient to Null is required for upload *)
	{blankFluorescenceFlowCellTemperatures, blankLightScatteringFlowCellTemperatures, blankRefractiveIndexFlowCellTemperatures} = Map[
		If[MatchQ[#, Null | {}] || NullQ[blankPositionsCorresponded],
			Null,
			ReplaceAll[#[[blankPositionsCorresponded]], Ambient -> $AmbientTemperature]
		]&,
		{Lookup[pertinentOptions, BlankFluorescenceFlowCellTemperature], Lookup[pertinentOptions, BlankLightScatteringFlowCellTemperature], Lookup[pertinentOptions, BlankRefractiveIndexFlowCellTemperature]}
	];

	(* Last column flush *)
	{
		columnFlushWavelengthResolutions,
		columnFlushUVFilter,
		columnFlushAbsorbanceSamplingRates,
		columnFlushLightScatteringLaserPowers,
		columnFlushRefractiveIndexMethods,
		columnFlushNebulizerGases,
		columnFlushNebulizerGasPressures,
		columnFlushNebulizerGasHeatings,
		columnFlushNebulizerHeatingPowers,
		columnFlushDriftTubeTemperatures,
		columnFlushELSDGains,
		columnFlushELSDSamplingRates
	} = Map[
		Function[{optionLookup},
			If[!NullQ[columnFlushPositionsCorresponded] && !NullQ[optionLookup],
				optionLookup[[DeleteDuplicates[columnFlushPositionsCorresponded]]],
				Null
			]
		],
		Lookup[pertinentOptions,
			{
				ColumnFlushWavelengthResolution,
				ColumnFlushUVFilter,
				ColumnFlushAbsorbanceSamplingRate,
				ColumnFlushLightScatteringLaserPower,
				ColumnFlushRefractiveIndexMethod,
				ColumnFlushNebulizerGas,
				ColumnFlushNebulizerGasPressure,
				ColumnFlushNebulizerGasHeating,
				ColumnFlushNebulizerHeatingPower,
				ColumnFlushDriftTubeTemperature,
				ColumnFlushELSDGain,
				ColumnFlushELSDSamplingRate
			}
		]
	];

	(* Fluorescence options - need to break up into 4 groups *)
	{
		columnFlushExcitationWavelengths,
		columnFlushSecondaryExcitationWavelengths,
		columnFlushTertiaryExcitationWavelengths,
		columnFlushQuaternaryExcitationWavelengths,
		columnFlushEmissionWavelengths,
		columnFlushSecondaryEmissionWavelengths,
		columnFlushTertiaryEmissionWavelengths,
		columnFlushQuaternaryEmissionWavelengths,
		columnFlushFluorescenceGains,
		columnFlushSecondaryFluorescenceGains,
		columnFlushTertiaryFluorescenceGains,
		columnFlushQuaternaryFluorescenceGains
	} = If[NullQ[Lookup[pertinentOptions, ColumnFlushExcitationWavelength]] || NullQ[columnFlushPositionsCorresponded],
		(* If Fluorescence is not selected, i.e., the options are Null, upload with {} *)
		ConstantArray[Null, 12],
		(* Break up the options into the protocol fields and expand out by the corresponding positinos *)
		Map[
			#[[DeleteDuplicates[columnFlushPositionsCorresponded]]]&,
			Transpose[
				MapThread[
					Function[
						{exValues, emValues, gainValues},
						Module[
							{length, expandedGainValues, expandedExValues, expandedEmValues},
							length = Length[ToList[exValues]];

							(* Add Null for empty channels *)
							expandedExValues = PadRight[ToList[exValues], 4, Null];
							expandedEmValues = PadRight[ToList[emValues], 4, Null];
							(* Expand Gain to the same length with Ex/Em and then add Null for empty channels *)
							expandedGainValues = PadRight[
								If[Length[ToList[gainValues]] == 1,
									Flatten[ConstantArray[gainValues, length]],
									gainValues
								],
								4,
								Null
							];
							(* Return all the values *)
							Flatten[{expandedExValues, expandedEmValues, expandedGainValues}]
						]
					],
					{Lookup[pertinentOptions, ColumnFlushExcitationWavelength], Lookup[pertinentOptions, ColumnFlushEmissionWavelength], Lookup[pertinentOptions, ColumnFlushFluorescenceGain]}
				]
			]
		]
	];

	(* Change cut-off filter values from None to Null *)
	columnFlushEmissionCutOffFilters = If[NullQ[Lookup[pertinentOptions, ColumnFlushEmissionCutOffFilter]] || NullQ[columnFlushPositionsCorresponded],
		Null,
		Map[
			(* Change None to Null *)
			If[MatchQ[#, None], Null, #]&,
			Lookup[pertinentOptions, ColumnFlushEmissionCutOffFilter][[DeleteDuplicates[columnFlushPositionsCorresponded]]]
		]
	];

	(* Temperature options - changes from ambient to Null is required for upload *)
	{columnFlushFluorescenceFlowCellTemperatures, columnFlushLightScatteringFlowCellTemperatures, columnFlushRefractiveIndexFlowCellTemperatures} = Map[
		If[NullQ[#] || NullQ[columnFlushPositionsCorresponded],
			Null,
			ReplaceAll[#[[DeleteDuplicates[columnFlushPositionsCorresponded]]], Ambient -> $AmbientTemperature]
		]&,
		{Lookup[pertinentOptions, ColumnFlushFluorescenceFlowCellTemperature], Lookup[pertinentOptions, ColumnFlushLightScatteringFlowCellTemperature], Lookup[pertinentOptions, ColumnFlushRefractiveIndexFlowCellTemperature]}
	];

	(* Get the maximum range for the instrument*)
	{minAbsorbance, maxAbsorbance} = Lookup[instrumentModelPacket, {MinAbsorbanceWavelength, MaxAbsorbanceWavelength}];

	(* Resolve the range parameters for the absorbance detection *)
	{
		{columnPrimeAbsorbanceWavelength, columnPrimeMinAbsorbanceWavelengths, columnPrimeMaxAbsorbanceWavelengths},
		{sampleAbsorbanceWavelength, sampleMinAbsorbanceWavelengths, sampleMaxAbsorbanceWavelengths},
		{standardAbsorbanceWavelength, standardMinAbsorbanceWavelengths, standardMaxAbsorbanceWavelengths},
		{blankAbsorbanceWavelength, blankMinAbsorbanceWavelengths, blankMaxAbsorbanceWavelengths},
		{columnFlushAbsorbanceWavelength, columnFlushMinAbsorbanceWavelengths, columnFlushMaxAbsorbanceWavelengths}
	} = Map[
		Function[{entry},
			Module[
				{detectionOptions, resolutions, correspondingPositions, detectionOptionsIn, resolutionsIn},

				(* Split our entry variable *)
				{detectionOptionsIn, resolutionsIn, correspondingPositions} = entry;

				(* Have to list these options*)
				{detectionOptions, resolutions} = ToList /@ {detectionOptionsIn, resolutionsIn};

				(* Check whether our corresponding positions is Null, if so return Nulls *)
				If[NullQ[correspondingPositions],
					{Null, Null, Null},
					(* Otherwise will need to map through the option and break apart what's relevant. We'll also need to expand out by the corresponding positions *)
					#[[correspondingPositions]]& /@
						(Transpose@MapThread[
							Function[
								{detectorOption, resolutionOption},
								Switch[detectorOption,
									(* Check if All was specified, then it's easy *)
									All, {Null, minAbsorbance, maxAbsorbance},
									(* Then check if it's a span, and if so, split it up for the min and max *)
									_Span, Prepend[detectorOption /. Span[x_, y_] :> {x, y}, Null],
									(* Otherwise it's specific wavelength and we Null out the max and min *)
									_, {detectorOption, Null, Null}
								]
							],
							{detectionOptions, resolutions}
						])
				]
			]
		],
		{
			Append[
				Lookup[pertinentOptions, {ColumnPrimeAbsorbanceWavelength, ColumnPrimeWavelengthResolution}],
				If[NullQ[columnPrimePositionsCorresponded],
					Null,
					DeleteDuplicates[columnPrimePositionsCorresponded]
				]
			],
			Append[Lookup[pertinentOptions, {AbsorbanceWavelength, WavelengthResolution}], Range[1, Length[samplePositions]]],
			Append[Lookup[pertinentOptions, {StandardAbsorbanceWavelength, StandardWavelengthResolution}], standardPositionsCorresponded],
			Append[Lookup[pertinentOptions, {BlankAbsorbanceWavelength, BlankWavelengthResolution}], blankPositionsCorresponded],
			Append[
				Lookup[pertinentOptions, {ColumnFlushAbsorbanceWavelength, ColumnFlushWavelengthResolution}],
				If[NullQ[columnFlushPositionsCorresponded],
					Null,
					DeleteDuplicates[columnFlushPositionsCorresponded]
				]
			]
		}
	];

	instrumentSpecificPacket = Association[
		Object -> myProtocol,

		Replace[Detectors] -> ToList[Lookup[unexpandedPertinentOptions, Detector, Lookup[resolvedOptions, Detector]]],
		pHTemperatureCompensation -> Lookup[pertinentOptions, pHTemperatureCompensation],
		ConductivityTemperatureCompensation -> Lookup[pertinentOptions, ConductivityTemperatureCompensation],

		Replace[ColumnPrimeAbsorbanceWavelengths] -> columnPrimeAbsorbanceWavelength /. {{Null...} -> {}},
		Replace[ColumnPrimeMinAbsorbanceWavelengths] -> columnPrimeMinAbsorbanceWavelengths /. {{Null...} -> {}},
		Replace[ColumnPrimeMaxAbsorbanceWavelengths] -> columnPrimeMaxAbsorbanceWavelengths /. {{Null...} -> {}},
		Replace[ColumnPrimeWavelengthResolutions] -> columnPrimeWavelengthResolutions /. {{Null...} -> {}},
		Replace[ColumnPrimeUVFilters] -> columnPrimeUVFilter /. {{Null...} -> {}},
		Replace[ColumnPrimeAbsorbanceSamplingRates] -> columnPrimeAbsorbanceSamplingRates /. {{Null...} -> {}},
		Replace[ColumnPrimeExcitationWavelengths] -> columnPrimeExcitationWavelengths /. {{Null...} -> {}},
		Replace[ColumnPrimeSecondaryExcitationWavelengths] -> columnPrimeSecondaryExcitationWavelengths /. {{Null...} -> {}},
		Replace[ColumnPrimeTertiaryExcitationWavelengths] -> columnPrimeTertiaryExcitationWavelengths /. {{Null...} -> {}},
		Replace[ColumnPrimeQuaternaryExcitationWavelengths] -> columnPrimeQuaternaryExcitationWavelengths /. {{Null...} -> {}},
		Replace[ColumnPrimeEmissionWavelengths] -> columnPrimeEmissionWavelengths /. {{Null...} -> {}},
		Replace[ColumnPrimeSecondaryEmissionWavelengths] -> columnPrimeSecondaryEmissionWavelengths /. {{Null...} -> {}},
		Replace[ColumnPrimeTertiaryEmissionWavelengths] -> columnPrimeTertiaryEmissionWavelengths /. {{Null...} -> {}},
		Replace[ColumnPrimeEmissionCutOffFilters] -> columnPrimeEmissionCutOffFilters /. {{Null...} -> {}},
		Replace[ColumnPrimeFluorescenceGains] -> columnPrimeFluorescenceGains /. {{Null...} -> {}},
		Replace[ColumnPrimeSecondaryFluorescenceGains] -> columnPrimeSecondaryFluorescenceGains /. {{Null...} -> {}},
		Replace[ColumnPrimeTertiaryFluorescenceGains] -> columnPrimeTertiaryFluorescenceGains /. {{Null...} -> {}},
		Replace[ColumnPrimeQuaternaryFluorescenceGains] -> columnPrimeQuaternaryFluorescenceGains /. {{Null...} -> {}},
		Replace[ColumnPrimeFluorescenceFlowCellTemperatures] -> columnPrimeFluorescenceFlowCellTemperatures /. {{Null...} -> {}},
		Replace[ColumnPrimeLightScatteringLaserPowers] -> columnPrimeLightScatteringLaserPowers /. {{Null...} -> {}},
		Replace[ColumnPrimeLightScatteringFlowCellTemperatures] -> columnPrimeLightScatteringFlowCellTemperatures /. {{Null...} -> {}},
		Replace[ColumnPrimeRefractiveIndexMethods] -> columnPrimeRefractiveIndexMethods /. {{Null...} -> {}},
		Replace[ColumnPrimeRefractiveIndexFlowCellTemperatures] -> columnPrimeRefractiveIndexFlowCellTemperatures /. {{Null...} -> {}},
		Replace[ColumnPrimeNebulizerGases] -> columnPrimeNebulizerGases /. {{Null...} -> {}},
		Replace[ColumnPrimeNebulizerGasPressures] -> columnPrimeNebulizerGasPressures /. {{Null...} -> {}},
		Replace[ColumnPrimeNebulizerGasHeatings] -> columnPrimeNebulizerGasHeatings /. {{Null...} -> {}},
		Replace[ColumnPrimeNebulizerHeatingPowers] -> columnPrimeNebulizerHeatingPowers /. {{Null...} -> {}},
		Replace[ColumnPrimeDriftTubeTemperatures] -> columnPrimeDriftTubeTemperatures /. {{Null...} -> {}},
		Replace[ColumnPrimeELSDGains] -> columnPrimeELSDGains /. {{Null...} -> {}},
		Replace[ColumnPrimeELSDSamplingRates] -> columnPrimeELSDSamplingRates /. {{Null...} -> {}},

		(* All the sample detector options *)
		Replace[AbsorbanceWavelength] -> sampleAbsorbanceWavelength /. {{Null...} -> {}},
		Replace[MinAbsorbanceWavelength] -> sampleMinAbsorbanceWavelengths /. {{Null...} -> {}},
		Replace[MaxAbsorbanceWavelength] -> sampleMaxAbsorbanceWavelengths /. {{Null...} -> {}},
		Replace[WavelengthResolution] -> sampleWavelengthResolutions /. {{Null...} -> {}},
		Replace[UVFilter] -> sampleUVFilter /. {{Null...} -> {}},
		Replace[AbsorbanceSamplingRate] -> sampleAbsorbanceSamplingRates /. {{Null...} -> {}},
		Replace[ExcitationWavelengths] -> sampleExcitationWavelengths /. {{Null...} -> {}},
		Replace[SecondaryExcitationWavelengths] -> sampleSecondaryExcitationWavelengths /. {{Null...} -> {}},
		Replace[TertiaryExcitationWavelengths] -> sampleTertiaryExcitationWavelengths /. {{Null...} -> {}},
		Replace[QuaternaryExcitationWavelengths] -> sampleQuaternaryExcitationWavelengths /. {{Null...} -> {}},
		Replace[EmissionWavelengths] -> sampleEmissionWavelengths /. {{Null...} -> {}},
		Replace[SecondaryEmissionWavelengths] -> sampleSecondaryEmissionWavelengths /. {{Null...} -> {}},
		Replace[TertiaryEmissionWavelengths] -> sampleTertiaryEmissionWavelengths /. {{Null...} -> {}},
		Replace[QuaternaryEmissionWavelengths] -> sampleQuaternaryEmissionWavelengths /. {{Null...} -> {}},
		Replace[EmissionCutOffFilters] -> sampleEmissionCutOffFilters /. {{Null...} -> {}},
		Replace[FluorescenceGains] -> sampleFluorescenceGains /. {{Null...} -> {}},
		Replace[SecondaryFluorescenceGains] -> sampleSecondaryFluorescenceGains /. {{Null...} -> {}},
		Replace[TertiaryFluorescenceGains] -> sampleTertiaryFluorescenceGains /. {{Null...} -> {}},
		Replace[QuaternaryFluorescenceGains] -> sampleQuaternaryFluorescenceGains /. {{Null...} -> {}},
		Replace[FluorescenceFlowCellTemperatures] -> sampleFluorescenceFlowCellTemperatures /. {{Null...} -> {}},
		Replace[LightScatteringLaserPowers] -> sampleLightScatteringLaserPowers /. {{Null...} -> {}},
		Replace[LightScatteringFlowCellTemperatures] -> sampleLightScatteringFlowCellTemperatures /. {{Null...} -> {}},
		Replace[RefractiveIndexMethods] -> sampleRefractiveIndexMethods /. {{Null...} -> {}},
		Replace[RefractiveIndexFlowCellTemperatures] -> sampleRefractiveIndexFlowCellTemperatures /. {{Null...} -> {}},
		Replace[NebulizerGas] -> nebulizerGas /. {{Null...} -> {}},
		Replace[NebulizerGasHeating] -> nebulizerGasHeating /. {{Null...} -> {}},
		Replace[NebulizerHeatingPower] -> nebulizerHeatingPower /. {{Null...} -> {}},
		Replace[NebulizerGasPressure] -> nebulizerGasPressure /. {{Null...} -> {}},
		Replace[DriftTubeTemperature] -> driftTubeTemperature /. {{Null...} -> {}},
		Replace[ELSDGain] -> elsdGain /. {{Null...} -> {}},
		Replace[ELSDSamplingRate] -> elsdSamplingRate /. {{Null...} -> {}},

		Replace[StandardAbsorbanceWavelength] -> standardAbsorbanceWavelength /. {{Null...} -> {}},
		Replace[StandardMinAbsorbanceWavelength] -> standardMinAbsorbanceWavelengths /. {{Null...} -> {}},
		Replace[StandardMaxAbsorbanceWavelength] -> standardMaxAbsorbanceWavelengths /. {{Null...} -> {}},
		Replace[StandardWavelengthResolution] -> standardWavelengthResolutions /. {{Null...} -> {}},
		Replace[StandardUVFilter] -> standardUVFilter /. {{Null...} -> {}},
		Replace[StandardAbsorbanceSamplingRate] -> standardAbsorbanceSamplingRates /. {{Null...} -> {}},
		Replace[StandardExcitationWavelengths] -> standardExcitationWavelengths /. {{Null...} -> {}},
		Replace[StandardSecondaryExcitationWavelengths] -> standardSecondaryExcitationWavelengths /. {{Null...} -> {}},
		Replace[StandardTertiaryExcitationWavelengths] -> standardTertiaryExcitationWavelengths /. {{Null...} -> {}},
		Replace[StandardQuaternaryExcitationWavelengths] -> standardQuaternaryExcitationWavelengths /. {{Null...} -> {}},
		Replace[StandardEmissionWavelengths] -> standardEmissionWavelengths /. {{Null...} -> {}},
		Replace[StandardSecondaryEmissionWavelengths] -> standardSecondaryEmissionWavelengths /. {{Null...} -> {}},
		Replace[StandardTertiaryEmissionWavelengths] -> standardTertiaryEmissionWavelengths /. {{Null...} -> {}},
		Replace[StandardQuaternaryEmissionWavelengths] -> standardQuaternaryEmissionWavelengths /. {{Null...} -> {}},
		Replace[StandardEmissionCutOffFilters] -> standardEmissionCutOffFilters /. {{Null...} -> {}},
		Replace[StandardFluorescenceGains] -> standardFluorescenceGains /. {{Null...} -> {}},
		Replace[StandardSecondaryFluorescenceGains] -> standardSecondaryFluorescenceGains /. {{Null...} -> {}},
		Replace[StandardTertiaryFluorescenceGains] -> standardTertiaryFluorescenceGains /. {{Null...} -> {}},
		Replace[StandardQuaternaryFluorescenceGains] -> standardQuaternaryFluorescenceGains /. {{Null...} -> {}},
		Replace[StandardFluorescenceFlowCellTemperatures] -> standardFluorescenceFlowCellTemperatures /. {{Null...} -> {}},
		Replace[StandardLightScatteringLaserPowers] -> standardLightScatteringLaserPowers /. {{Null...} -> {}},
		Replace[StandardLightScatteringFlowCellTemperatures] -> standardLightScatteringFlowCellTemperatures /. {{Null...} -> {}},
		Replace[StandardRefractiveIndexMethods] -> standardRefractiveIndexMethods /. {{Null...} -> {}},
		Replace[StandardRefractiveIndexFlowCellTemperatures] -> standardRefractiveIndexFlowCellTemperatures /. {{Null...} -> {}},
		Replace[StandardDriftTubeTemperature] -> standardDriftTubeTemperature /. {{Null...} -> {}},
		Replace[StandardELSDGain] -> standardELSDGain /. {{Null...} -> {}},
		Replace[StandardELSDSamplingRate] -> standardELSDSamplingRate /. {{Null...} -> {}},
		Replace[StandardNebulizerGas] -> standardNebulizerGas /. {{Null...} -> {}},
		Replace[StandardNebulizerGasHeating] -> standardNebulizerGasHeating /. {{Null...} -> {}},
		Replace[StandardNebulizerHeatingPower] -> standardNebulizerHeatingPower /. {{Null...} -> {}},
		Replace[StandardNebulizerGasPressure] -> standardNebulizerGasPressure /. {{Null...} -> {}},

		Replace[BlankAbsorbanceWavelength] -> blankAbsorbanceWavelength /. {{Null...} -> {}},
		Replace[BlankMinAbsorbanceWavelength] -> blankMinAbsorbanceWavelengths /. {{Null...} -> {}},
		Replace[BlankMaxAbsorbanceWavelength] -> blankMaxAbsorbanceWavelengths /. {{Null...} -> {}},
		Replace[BlankWavelengthResolution] -> blankWavelengthResolutions /. {{Null...} -> {}},
		Replace[BlankUVFilter] -> blankUVFilter /. {{Null...} -> {}},
		Replace[BlankAbsorbanceSamplingRate] -> blankAbsorbanceSamplingRates /. {{Null...} -> {}},
		Replace[BlankExcitationWavelengths] -> blankExcitationWavelengths /. {{Null...} -> {}},
		Replace[BlankSecondaryExcitationWavelengths] -> blankSecondaryExcitationWavelengths /. {{Null...} -> {}},
		Replace[BlankTertiaryExcitationWavelengths] -> blankTertiaryExcitationWavelengths /. {{Null...} -> {}},
		Replace[BlankQuaternaryExcitationWavelengths] -> blankQuaternaryExcitationWavelengths /. {{Null...} -> {}},
		Replace[BlankEmissionWavelengths] -> blankEmissionWavelengths /. {{Null...} -> {}},
		Replace[BlankSecondaryEmissionWavelengths] -> blankSecondaryEmissionWavelengths /. {{Null...} -> {}},
		Replace[BlankTertiaryEmissionWavelengths] -> blankTertiaryEmissionWavelengths /. {{Null...} -> {}},
		Replace[BlankQuaternaryEmissionWavelengths] -> blankQuaternaryEmissionWavelengths /. {{Null...} -> {}},
		Replace[BlankEmissionCutOffFilters] -> blankEmissionCutOffFilters /. {{Null...} -> {}},
		Replace[BlankFluorescenceGains] -> blankFluorescenceGains /. {{Null...} -> {}},
		Replace[BlankSecondaryFluorescenceGains] -> blankSecondaryFluorescenceGains /. {{Null...} -> {}},
		Replace[BlankTertiaryFluorescenceGains] -> blankTertiaryFluorescenceGains /. {{Null...} -> {}},
		Replace[BlankQuaternaryFluorescenceGains] -> blankQuaternaryFluorescenceGains /. {{Null...} -> {}},
		Replace[BlankFluorescenceFlowCellTemperatures] -> blankFluorescenceFlowCellTemperatures /. {{Null...} -> {}},
		Replace[BlankLightScatteringLaserPowers] -> blankLightScatteringLaserPowers /. {{Null...} -> {}},
		Replace[BlankLightScatteringFlowCellTemperatures] -> blankLightScatteringFlowCellTemperatures /. {{Null...} -> {}},
		Replace[BlankRefractiveIndexMethods] -> blankRefractiveIndexMethods /. {{Null...} -> {}},
		Replace[BlankRefractiveIndexFlowCellTemperatures] -> blankRefractiveIndexFlowCellTemperatures /. {{Null...} -> {}},
		Replace[BlankDriftTubeTemperature] -> blankDriftTubeTemperature /. {{Null...} -> {}},
		Replace[BlankELSDGain] -> blankELSDGain /. {{Null...} -> {}},
		Replace[BlankELSDSamplingRate] -> blankELSDSamplingRate /. {{Null...} -> {}},
		Replace[BlankNebulizerGas] -> blankNebulizerGas /. {{Null...} -> {}},
		Replace[BlankNebulizerGasHeating] -> blankNebulizerGasHeating /. {{Null...} -> {}},
		Replace[BlankNebulizerHeatingPower] -> blankNebulizerHeatingPower /. {{Null...} -> {}},
		Replace[BlankNebulizerGasPressure] -> blankNebulizerGasPressure /. {{Null...} -> {}},

		Replace[ColumnFlushAbsorbanceWavelengths] -> columnFlushAbsorbanceWavelength /. {{Null...} -> {}},
		Replace[ColumnFlushMinAbsorbanceWavelengths] -> columnFlushMinAbsorbanceWavelengths /. {{Null...} -> {}},
		Replace[ColumnFlushMaxAbsorbanceWavelengths] -> columnFlushMaxAbsorbanceWavelengths /. {{Null...} -> {}},
		Replace[ColumnFlushWavelengthResolutions] -> columnFlushWavelengthResolutions /. {{Null...} -> {}},
		Replace[ColumnFlushUVFilters] -> columnFlushUVFilter /. {{Null...} -> {}},
		Replace[ColumnFlushAbsorbanceSamplingRates] -> columnFlushAbsorbanceSamplingRates /. {{Null...} -> {}},
		Replace[ColumnFlushExcitationWavelengths] -> columnFlushExcitationWavelengths /. {{Null...} -> {}},
		Replace[ColumnFlushSecondaryExcitationWavelengths] -> columnFlushSecondaryExcitationWavelengths /. {{Null...} -> {}},
		Replace[ColumnFlushTertiaryExcitationWavelengths] -> columnFlushTertiaryExcitationWavelengths /. {{Null...} -> {}},
		Replace[ColumnFlushQuaternaryExcitationWavelengths] -> columnFlushQuaternaryExcitationWavelengths /. {{Null...} -> {}},
		Replace[ColumnFlushEmissionWavelengths] -> columnFlushEmissionWavelengths /. {{Null...} -> {}},
		Replace[ColumnFlushSecondaryEmissionWavelengths] -> columnFlushSecondaryEmissionWavelengths /. {{Null...} -> {}},
		Replace[ColumnFlushTertiaryEmissionWavelengths] -> columnFlushTertiaryEmissionWavelengths /. {{Null...} -> {}},
		Replace[ColumnFlushQuaternaryEmissionWavelengths] -> columnFlushQuaternaryEmissionWavelengths /. {{Null...} -> {}},
		Replace[ColumnFlushEmissionCutOffFilters] -> columnFlushEmissionCutOffFilters /. {{Null...} -> {}},
		Replace[ColumnFlushFluorescenceGains] -> columnFlushFluorescenceGains /. {{Null...} -> {}},
		Replace[ColumnFlushSecondaryFluorescenceGains] -> columnFlushSecondaryFluorescenceGains /. {{Null...} -> {}},
		Replace[ColumnFlushTertiaryFluorescenceGains] -> columnFlushTertiaryFluorescenceGains /. {{Null...} -> {}},
		Replace[ColumnFlushQuaternaryFluorescenceGains] -> columnFlushQuaternaryFluorescenceGains /. {{Null...} -> {}},
		Replace[ColumnFlushFluorescenceFlowCellTemperatures] -> columnFlushFluorescenceFlowCellTemperatures /. {{Null...} -> {}},
		Replace[ColumnFlushLightScatteringLaserPowers] -> columnFlushLightScatteringLaserPowers /. {{Null...} -> {}},
		Replace[ColumnFlushLightScatteringFlowCellTemperatures] -> columnFlushLightScatteringFlowCellTemperatures /. {{Null...} -> {}},
		Replace[ColumnFlushRefractiveIndexMethods] -> columnFlushRefractiveIndexMethods /. {{Null...} -> {}},
		Replace[ColumnFlushRefractiveIndexFlowCellTemperatures] -> columnFlushRefractiveIndexFlowCellTemperatures /. {{Null...} -> {}},
		Replace[ColumnFlushNebulizerGases] -> columnFlushNebulizerGases /. {{Null...} -> {}},
		Replace[ColumnFlushNebulizerGasPressures] -> columnFlushNebulizerGasPressures /. {{Null...} -> {}},
		Replace[ColumnFlushNebulizerGasHeatings] -> columnFlushNebulizerGasHeatings /. {{Null...} -> {}},
		Replace[ColumnFlushNebulizerHeatingPowers] -> columnFlushNebulizerHeatingPowers /. {{Null...} -> {}},
		Replace[ColumnFlushDriftTubeTemperatures] -> columnFlushDriftTubeTemperatures /. {{Null...} -> {}},
		Replace[ColumnFlushELSDGains] -> columnFlushELSDGains /. {{Null...} -> {}},
		Replace[ColumnFlushELSDSamplingRates] -> columnFlushELSDSamplingRates /. {{Null...} -> {}}

	];

	(*upload if we are. otherwise return the change packet*)

	If[uploadQ,
		Upload[instrumentSpecificPacket],
		instrumentSpecificPacket
	]

];


(* ::Subsection::Closed:: *)
(*ExperimentHPLCPreview*)


(* ::Subsubsection:: *)
(*ExperimentHPLCPreview*)


DefineOptions[ExperimentHPLCPreview,
	SharedOptions :> {ExperimentHPLC}
];

ExperimentHPLCPreview[myObjects : ListableP[ObjectP[Object[Container]]] | ListableP[(ObjectP[Object[Sample]] | _String)], myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Output -> _];

	(* return only the preview for ExperimentHPLC *)
	ExperimentHPLC[myObjects, Append[noOutputOptions, Output -> Preview]]
];



(* ::Subsection::Closed:: *)
(*ExperimentHPLCOptions*)


(* ::Subsubsection:: *)
(*ExperimentHPLCOptions*)


DefineOptions[ExperimentHPLCOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table | List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category -> "Protocol"
		}
	},
	SharedOptions :> {ExperimentHPLC}
];

ExperimentHPLCOptions[myObjects : ListableP[ObjectP[Object[Container]]] | ListableP[(ObjectP[Object[Sample]] | _String)], myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, (Output -> _) | (OutputFormat -> _)];

	(* return only the preview for ExperimentHPLC *)
	options = ExperimentHPLC[myObjects, Append[noOutputOptions, Output -> Options]];

	(* If options fail, return failure *)
	If[MatchQ[options, $Failed],
		Return[$Failed]
	];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentHPLC],
		options
	]
];



(* ::Subsection:: *)
(*ValidExperimentHPLCQ*)


(* ::Subsubsection:: *)
(*ValidExperimentHPLCQ*)


DefineOptions[ValidExperimentHPLCQ,
	Options :> {
		VerboseOption,
		OutputFormatOption
	},
	SharedOptions :> {ExperimentHPLC}
];


ValidExperimentHPLCQ[myObject : (ObjectP[Object[Sample]] | _String), myOptions : OptionsPattern[]] := ValidExperimentHPLCQ[{myObject}, myOptions];

ValidExperimentHPLCQ[myObjects : {(ObjectP[Object[Sample]] | _String)...}, myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions, preparedOptions, hplcTests, validObjectBooleans, voqWarnings,
		initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output option before passing to the core function because it doens't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentHPLC *)
	hplcTests = ExperimentHPLC[myObjects, Append[preparedOptions, Output -> Tests]];

	(* Create warnings for invalid objects *)
	validObjectBooleans = ValidObjectQ[DeleteCases[myObjects, _String], OutputFormat -> Boolean];
	voqWarnings = MapThread[
		Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
			#2,
			True
		]&,
		{DeleteCases[myObjects, _String], validObjectBooleans}
	];

	(* Make a list of all the tests *)
	allTests = Join[hplcTests, voqWarnings];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentHPLCQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentHPLCQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentHPLCQ"]
];




(* ::Subsection::Closed:: *)
(* Helper Functions *)


roundToDispenseVolume[myVolume : VolumeP] := With[
	{
		possibleVolumes = Join[
			{15, 50, 100, 250, 500, 750, 1000},
			Range[1250, 5000, 250],
			Range[6000, 20000, 1000]
		] * Milliliter
	},

	SelectFirst[possibleVolumes, (# >= myVolume)&]
];



(* ::Subsubsection::Closed:: *)
(* fetchPacketFromCacheHPLC *)


fetchPacketFromCacheHPLC[Null, _] := Null;
fetchPacketFromCacheHPLC[myObject : ObjectP[], myCachedPackets : {PacketP[]...}] := FirstCase[myCachedPackets, KeyValuePattern[{Object -> Download[myObject, Object]}]];


(* ::Subsubsection::Closed:: *)
(* fetchModelPacketFromCacheHPLC *)


fetchModelPacketFromCacheHPLC[Null, _] := Null;
fetchModelPacketFromCacheHPLC[myObject : ObjectP[Object], myCachedPackets : {PacketP[]...}] := fetchPacketFromCacheHPLC[Download[Lookup[fetchPacketFromCacheHPLC[myObject, myCachedPackets], Model], Object], myCachedPackets];


(* ::Subsubsection:: *)
(* defaultGradient *)


DefineOptions[defaultGradient,
	Options :> {
		(* seperation mode leads to diffrent gradient *)
		{SeparationMode -> Null, SeparationModeP | Null, "The HPLC separation mode this default gradient is for."},
		{Detector -> Null, HPLCDetectorTypeP | Null, "The HPLC detector this default gradient is for."}
	}
];

(* Overload for constant flow rate *)
defaultGradient[myDefaultFlowRate : FlowRateP, myOptions : OptionsPattern[]] := Module[
	{safeOptions, separationMode, detector},

	(* Get the option values *)
	safeOptions = SafeOptions[defaultGradient, ToList[myOptions]];

	(* Get the separation mode and detector options *)
	separationMode = Lookup[safeOptions, SeparationMode];
	detector = Lookup[safeOptions, Detector];

	(* Give different default gradients based on the different separation mode and/or detector *)
	Switch[
		{separationMode, detector},
		(* Chiral or Normal Phase *)
		{Chiral | NormalPhase, _},
		{
			{Quantity[0., Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
			{Quantity[30., Minute], Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
			(* Equilibrate to the starting composition *)
			{Quantity[30.1, Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
			{Quantity[35, Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate}
		},
		(* MALS/DLS/RI/pH/Conductivity Detector - Always Buffer A *)
		{_, MultiAngleLightScattering | DynamicLightScattering | RefractiveIndex | pH | Conductance},
		{
			{Quantity[0., Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
			{Quantity[30., Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate}
		},
		(* Others *)
		_,
		{
			{Quantity[0., Minute], Quantity[90., Percent], Quantity[10., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
			{Quantity[5., Minute], Quantity[90., Percent], Quantity[10., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
			{Quantity[30., Minute], Quantity[35., Percent], Quantity[65., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
			{Quantity[30.1, Minute], Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
			{Quantity[35., Minute], Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
			{Quantity[35.1, Minute], Quantity[90., Percent], Quantity[10., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
			{Quantity[40., Minute], Quantity[90., Percent], Quantity[10., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate}
		}
	]
];

(* Overload for given FlowRate with timepoints without final composition (default to 90/10) *)
defaultGradient[myDefaultFlowRate : {{TimeP,FlowRateP}..}, myOptions : OptionsPattern[]] := Module[
	{safeOptions, separationMode, detector, flowRateLength, sortedFlowRate},

	(* Get the option values *)
	safeOptions = SafeOptions[defaultGradient, ToList[myOptions]];

	(* Get the separation mode and detector options *)
	separationMode = Lookup[safeOptions, SeparationMode];
	detector = Lookup[safeOptions, Detector];
	(* Flow Rate length *)
	flowRateLength = Length[myDefaultFlowRate];
	sortedFlowRate = SortBy[myDefaultFlowRate,First[#]&];

	(* Give different default gradients based on the different sepration mode and/or detector and respect the provided flow rate tuples *)
	Switch[
		{flowRateLength, separationMode, detector},
		(* Chiral or Normal Phase *)
		(* <=3 flow rate points, use single gradient since we cannot adjust back to the original gradient at the end with the limited number of points *)
		{LessEqualP[3],Chiral | NormalPhase, _},
		Map[
			{#[[1]], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], #[[2]]}&,
			sortedFlowRate
		],
		{_,Chiral | NormalPhase, _},
		Join[
			(* Point 1 - 100% A *)
			{{sortedFlowRate[[1,1]], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], sortedFlowRate[[1,2]]}},
			(* Point 2 - -3 - 100%B *)
			Map[
				{#[[1]], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], #[[2]]}&,
				sortedFlowRate[[2;;-3]]
			],
			(* Point -2 - -1 - 100%A *)
			(* Equilibrate to the starting composition *)
			Map[
				{#[[1]], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], #[[2]]}&,
				sortedFlowRate[[-2;;]]
			]
		],
		(* MALS/DLS/RI/pH/Conductivity Detector - Always Buffer A *)
		{_, MultiAngleLightScattering | DynamicLightScattering | RefractiveIndex | pH | Conductance},
		Map[
			{#[[1]], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], #[[2]]}&,
			sortedFlowRate
		],
		(* Others *)
		_,
		(* <=3 flow rate points, use single gradient since we cannot adjust back to the original gradient at the end with the limited number of points *)
		{LessEqualP[3],___},
		Map[
			{#[[1]], Quantity[90., Percent], Quantity[10., Percent], Quantity[0., Percent], Quantity[0., Percent], #[[2]]}&,
			sortedFlowRate
		],
		_,
		Join[
			(* Point 1 - 90% A + 10% B *)
			{{sortedFlowRate[[1,1]], Quantity[90., Percent], Quantity[10., Percent], Quantity[0., Percent], Quantity[0., Percent], sortedFlowRate[[1,2]]}},
			(* Point 2 - -3 - 100%B *)
			Map[
				{#[[1]], Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], #[[2]]}&,
				sortedFlowRate[[2;;-3]]
			],
			(* Point -2 - -1 - 90%A + 10% B*)
			(* Equilibrate to the starting composition *)
			Map[
				{#[[1]], Quantity[90., Percent], Quantity[10., Percent], Quantity[0., Percent], Quantity[0., Percent], #[[2]]}&,
				sortedFlowRate[[-2;;]]
			]
		]
	]
];

(* Overload for given FlowRate with timepoints with desired final flushing time and final composition *)
(* Ignore the request of equilibration time since we are going to respect the timepoints in flow rate input *)
defaultPrimeGradient[myDefaultFlowRate : {{TimeP,FlowRateP}..}, equilibrationDuration: (TimeP|Null), finalComposition : {GreaterEqualP[0 Percent], GreaterEqualP[0 Percent], GreaterEqualP[0 Percent], GreaterEqualP[0 Percent]}]:= defaultPrimeGradient[myDefaultFlowRate, finalComposition];

(* Overload for given FlowRate with timepoints with final composition *)
defaultPrimeGradient[myDefaultFlowRate : {{TimeP,FlowRateP}..}, finalComposition : {GreaterEqualP[0 Percent], GreaterEqualP[0 Percent], GreaterEqualP[0 Percent], GreaterEqualP[0 Percent]}] := Module[
	{flowRateLength,sortedFlowRate},
	flowRateLength = Length[myDefaultFlowRate];
	sortedFlowRate = SortBy[myDefaultFlowRate,First[#]&];
	If[LessEqualQ[flowRateLength,3],
		(* <=3 flow rate points, use single gradient since we cannot adjust back to the original gradient at the end with the limited number of points *)
		Map[
			{#[[1]], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], #[[2]]}&,
			sortedFlowRate
		],
		Join[
			(* Point 1 - 90% A + 10% B *)
			{{sortedFlowRate[[1,1]], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], sortedFlowRate[[1,2]]}},
			(* Point 2 - -3 - 100%B *)
			Map[
				{#[[1]], Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], #[[2]]}&,
				sortedFlowRate[[2;;-3]]
			],
			(* Point -2 - -1 - 90%A + 10% B*)
			(* Equilibrate to the starting composition *)
			Map[
				{#[[1]], Sequence @@ finalComposition, #[[2]]}&,
				sortedFlowRate[[-2;;]]
			]
		]
	]
];

(* Overload for any flow rate and assign a default composition *)
defaultPrimeGradient[myDefaultFlowRate : (FlowRateP|{{TimeP,FlowRateP}..})] := defaultPrimeGradient[myDefaultFlowRate, {
	Quantity[90., Percent], Quantity[10., Percent], Quantity[0., Percent], Quantity[0., Percent]
}];

(* Overload for any flow rate and an equilibration duration, assign a default composition *)
defaultPrimeGradient[myDefaultFlowRate : (FlowRateP|{{TimeP,FlowRateP}..}),equilibrationDuration: (TimeP|Null)] := defaultPrimeGradient[myDefaultFlowRate, equilibrationDuration, {
	Quantity[90., Percent], Quantity[10., Percent], Quantity[0., Percent], Quantity[0., Percent]
}];

(* Overload for a constant flow rate with a final composition *)
defaultPrimeGradient[myDefaultFlowRate : FlowRateP, finalComposition : {GreaterEqualP[0 Percent], GreaterEqualP[0 Percent], GreaterEqualP[0 Percent], GreaterEqualP[0 Percent]}] := defaultPrimeGradient[myDefaultFlowRate, 5 Minute, finalComposition];

(* Overload for a constant flow rate with a final composition *)
defaultPrimeGradient[myDefaultFlowRate : FlowRateP, equilibrationDuration: (TimeP|Null), finalComposition : {GreaterEqualP[0 Percent], GreaterEqualP[0 Percent], GreaterEqualP[0 Percent], GreaterEqualP[0 Percent]}] := Module[
	{convertedTime},
	convertedTime=If[NullQ[equilibrationDuration],5Minute,Convert[equilibrationDuration,Minute]];
	{
		{Quantity[0., Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
		{Quantity[5., Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
		{Quantity[5.1, Minute], Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
		{Quantity[15., Minute], Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
		{Quantity[15.1, Minute], Sequence @@ finalComposition, myDefaultFlowRate},
		{Quantity[15.1, Minute]+convertedTime, Sequence @@ finalComposition, myDefaultFlowRate}
	}
];

defaultFlushGradient[myDefaultFlowRate : {{TimeP,FlowRateP}..}, finalComposition : {GreaterEqualP[0 Percent], GreaterEqualP[0 Percent], GreaterEqualP[0 Percent], GreaterEqualP[0 Percent]}] := Module[
	{flowRateLength,sortedFlowRate},
	flowRateLength = Length[myDefaultFlowRate];
	sortedFlowRate = SortBy[myDefaultFlowRate,First[#]&];
	If[LessEqualQ[flowRateLength,3],
		(* <=3 flow rate points, use single gradient since we cannot adjust back to the original gradient at the end with the limited number of points *)
		Map[
			{#[[1]], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], #[[2]]}&,
			sortedFlowRate
		],
		Join[
			(* Point 1 - 90% A + 10% B *)
			{{sortedFlowRate[[1,1]], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], sortedFlowRate[[1,2]]}},
			(* Point 2 - -3 - 100%B *)
			Map[
				{#[[1]], Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], #[[2]]}&,
				sortedFlowRate[[2;;-3]]
			],
			(* Point -2 - -1 - 90%A + 10% B*)
			(* Equilibrate to the starting composition *)
			Map[
				{#[[1]], Sequence @@ finalComposition, #[[2]]}&,
				sortedFlowRate[[-2;;]]
			]
		]
	]
];

defaultFlushGradient[myDefaultFlowRate : FlowRateP] := defaultFlushGradient[myDefaultFlowRate, {
	Quantity[90., Percent], Quantity[10., Percent], Quantity[0., Percent], Quantity[0., Percent]
}];

defaultFlushGradient[myDefaultFlowRate : FlowRateP, finalComposition : {GreaterEqualP[0 Percent], GreaterEqualP[0 Percent], GreaterEqualP[0 Percent], GreaterEqualP[0 Percent]}] := {
	{Quantity[0., Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[10., Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[10.1, Minute], Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[20., Minute], Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[20.1, Minute], Sequence @@ finalComposition, myDefaultFlowRate},
	{Quantity[30., Minute], Sequence @@ finalComposition, myDefaultFlowRate}
};

(* NOTE: This only works if the times are in Minutes *)
interpolationFunctionForGradient = Function[
	gradient,
	Interpolation[gradient, InterpolationOrder -> 1]
];
interpolatedPointsForTimes[times_] := Function[
	interpolationFunction,
	Map[
		Function[
			time,
			Which[
				time < Quantity[First[First[interpolationFunction["Domain"]]], "Minutes"],
				0. Units@interpolationFunction[Quantity[First[First[interpolationFunction["Domain"]]], "Minutes"]],
				time > Quantity[Last[First[interpolationFunction["Domain"]]], "Minutes"],
				0. Units@interpolationFunction[Quantity[Last[First[interpolationFunction["Domain"]]], "Minutes"]],
				True,
				interpolationFunction[time]
			]
		],
		times
	]
];

(* NOTE: This only works if the times are in Minutes *)
getInterpolationValuesForTimes[{} | Null, times_] := Table[Quantity[0., "Percent"], {Length[times]}];
getInterpolationValuesForTimes[{{time : TimeP, composition : (PercentP | FlowRateP)}}, times_] := Table[composition, {Length[times]}];
getInterpolationValuesForTimes[gradient_, times_] := RightComposition[
	interpolationFunctionForGradient,
	interpolatedPointsForTimes[times]
][gradient];


(* ::Subsubsection::Closed:: *)
(*calculateBufferUsage*)


(* Buffer usage calculates the amount of buffer need to finish the run + 5  min for fraction collector cleaning + 2 min run time prior to injection *)
calculateBufferUsage[grad_, maxTime_, flowRates_, finalGradientPercentABC_] := Module[
	{gradientInterpolation, flowRateInterpolation, lastFlowRate, unitlessMaxTime,
		totalGradientProportion, totalVolume, extraVolume},

	gradientInterpolation = Interpolation[DeleteDuplicates[Unitless[grad, {Minute, Percent}]], InterpolationOrder -> 1];

	flowRateInterpolation = Interpolation[DeleteDuplicates[Unitless[flowRates, {Minute, Milliliter / Minute}]], InterpolationOrder -> 1];

	lastFlowRate = Last[flowRates][[2]];

	unitlessMaxTime = Unitless[maxTime, Minute];

	(* Divide by 100% * max time to get total proportion of buffer usage
      ie: the proportion of buffer out of all the buffer used for the gradient *)
	totalGradientProportion = (NIntegrate[gradientInterpolation[t], {t, 0, unitlessMaxTime}] / (100 * unitlessMaxTime));

	(* Total amount of buffer used in the gradient *)
	totalVolume = NIntegrate[flowRateInterpolation[t], {t, 0, unitlessMaxTime}];

	(* add volume buffer with a rough estimate of 5 min for fraction collector cleaning + 2 min run time prior to injection *)
	extraVolume = (Unitless[lastFlowRate, Milliliter / Minute] * 7 * Unitless[finalGradientPercentABC] / 100);

	((totalVolume * totalGradientProportion) + extraVolume) Milliliter
];


(* ::Subsubsection::Closed:: *)
(*allHPLCInstrumentSearch*)

(* Function to search the database for all non-deprecated HPLC instruments.
 	Memoizes the result after first execution to avoid repeated database trips within a single kernel session. *)
allHPLCInstrumentSearch[fakeString:_String] := allHPLCInstrumentSearch[fakeString] = Module[{},
	(*Add allCentrifugeEquipmentSearch to list of Memoized functions*)
	AppendTo[$Memoization,Experiment`Private`allHPLCInstrumentSearch];

	Search[
		{
			Model[Instrument, HPLC],
			Model[Instrument, HPLC],
			Model[Instrument, HPLC],
			Model[Instrument, HPLC],
			Model[Instrument, HPLC]
		},
		{
			(* All *)
			Deprecated!=True,
			(* Dionex *)
			StringContainsQ[Name, "UltiMate 3000"],
			(* Agilent *)
			StringContainsQ[Name, "Agilent"],
			(* Waters *)
			StringContainsQ[Name, "Waters"],
			(* Test Instruments *)
			StringContainsQ[Name, "Test"]
		}
	]
];