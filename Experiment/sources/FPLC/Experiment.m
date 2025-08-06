(* ::Package:: *)

(* ::Text:: *)
(*\[Copyright] 2011-2023 Emerald Cloud Lab, Inc.*)


(* ::Section:: *)
(*Source Code*)


(* ::Subsection:: *)
(*ExperimentFPLC*)

(* feature flag preferential selection of the thread-through caps for FPLC protocols in place of the normal EPDM aspiration caps *)
$FPLCThreadedCapPreference=True;


(* ::Subsubsection::Closed:: *)
(*Options*)


DefineOptions[ExperimentFPLC,
	Options :> {
		{
			OptionName -> SeparationMode,
			Default -> Automatic,
			Description -> "The category of method to be used to retain analytes selectively. This option is used to set the column and solvents. If multiple columns are specified, this option refers to the separation mode of the first column.",
			ResolutionDescription -> "Automatically set depending on the specified column(s).  If no columns are specified, set to SizeExclusion.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> IonExchange | SizeExclusion
			],
			Category -> "General"
		},
		{
			OptionName -> Column,
			Default -> Automatic,
			Description -> "Item containing the stationary phase through which the mobile phase and input samples flow. It adsorbs and separates the molecules within the sample based on the properties of the mobile phase, Samples, and Column material. Note that multiple columns may be connected in series.",
			ResolutionDescription -> "Automatically set to a column model ideal for the specified SeparationMode.",
			AllowNull -> False,
			Widget -> Alternatives[
				Adder[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[{Model[Item, Column], Object[Item, Column]}],
						OpenPaths -> {
							{
								Object[Catalog, "Root"],
								"Materials",
								"Liquid Chromatography",
								"FPLC Columns"
							}
						}
					]
				],
				Widget[
					Type -> Object,
					Pattern :> ObjectP[{Model[Item, Column], Object[Item, Column]}],
					OpenPaths -> {
						{
							Object[Catalog, "Root"],
							"Materials",
							"Liquid Chromatography",
							"FPLC Columns"
						}
					}
				]
			],
			Category -> "General"
		},
		{
			OptionName -> MaxColumnPressure,
			Default -> Automatic,
			Description -> "The limit of pressure drop across all of the devices in the Column.",
			ResolutionDescription -> "Automatically set to the total of the MaxPressure from the column model information.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterP[0*Megapascal],
				Units -> {Megapascal,  {Megapascal, PSI}}
			],
			Category -> "General"
		},
		{
			OptionName -> Scale,
			Default -> Analytical,
			Description -> "Indicates if the experiment is intended purify or analyze material. Analytical indicates that specific measurements will be employed (e.g the absorbance of the flow with injected sample for a given wavelength) and is amendable for quantification.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> PurificationScaleP
			],
			Category -> "General"
		},
		{
			OptionName -> Instrument,
			Default -> Automatic,
			Description -> "The measurement and collection device on which the protocol is to be run.",
			ResolutionDescription -> "Automatically set to Model[Instrument, FPLC, \"AKTA avant 150\"] if Scale -> Preparative, and Model[Instrument, FPLC, \"AKTA avant 25\"] if Scale -> Analytical.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Instrument, FPLC], Object[Instrument, FPLC]}],
				OpenPaths -> {
					{
						Object[Catalog, "Root"],
						"Instruments",
						"Chromatography",
						"Fast Protein Liquid Chromatography (FPLC)"
					}
				}
			],
			Category -> "General"
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> InjectionType,
				Default -> Automatic,
				Description -> "The manner of introducing sample to the flow path and Column. Autosampler entails a robotic handling device that injects directly from sample vials and/or plates. FlowInjection directly pumps the sample into the column. Superloop pumps sample into a specialized syringe/sample loop that ensures constant volume introduction onto the column.",
				ResolutionDescription -> "For injection volumes smaller than the instrument's sample loop, set to Autosampler. If set above 20 Milliliter or SamplePumpWash is true for any sample, set to direct flow injection; otherwise, set to Superloop.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> FPLCInjectionTypeP (*Autosampler|FlowInjection|Superloop*)
				],
				Category -> "General"
			},
			{
				OptionName -> SamplePumpWash,
				Default -> Automatic,
				Description -> "When InjectionType is FlowInjection, whether to include a pump wash step for sample pump in the prime method.",
				ResolutionDescription -> "Automatically set to False.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				],
				Category -> "Sample Parameters"
			}
		],
		{
			OptionName -> SampleLoopVolume,
			Default -> Automatic,
			Description -> "The tubing that contains the sample before injection into flow path and introduction into the Column.",
			ResolutionDescription -> "If InjectionType is Autosampler, defaults to Instrument's autosampler's smallest sample loop that can accommodate the InjectionVolume. For InjectionType -> FlowInjection, defaults to Null, and for Superloop, set to the smallest available syringe.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[50 Microliter, 10 Milliliter],
				Units -> Microliter
			],
			Category -> "General"
		},
		{
			OptionName -> Detector,
			Default -> Automatic,
			Description -> "The type measurement to employ. Currently, we offer Absorbance, Conductance, pH, Temperature, Pressure.",
			ResolutionDescription -> "Automatically set to the value in the Detectors field of the Instrument option's object.",
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> FPLCDetectorP
				],
				Adder[
					Widget[
						Type -> Enumeration,
						Pattern :> FPLCDetectorP
					]
				]
			],
			Category -> "General"
		},
		{
			OptionName -> MixerVolume,
			Default -> Automatic,
			Description -> "The capacity of the chamber used to homogenize the mobile phase. Higher volume is better for more viscous mobile phase. 0 Milliliter or Null indicates to use no mixing chamber.",
			ResolutionDescription -> "Automatically set to the default for the Instrument (1.4 mL for the Avant 25; 5 mL for Avant 150; 0.6 mL for AKTA 10).",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Milliliter, 5 Milliliter],
				Units -> {1, {Milliliter, {Microliter, Milliliter}}}
			],
			Category -> "General"
		},
		{
			OptionName -> FlowCell,
			Default -> 2 Millimeter,
			Description -> "The distance that light must travel in order to measure an absorbance signal in the liquid mobile phase. For the Avant 25 and 150 instruments, 0.5, 2, and 10 mm are available. For the AKTA 10, only 2 mm is available.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0.5 Millimeter, 10 Millimeter],
				Units -> Millimeter
			],
			Category -> "General"
		},

		(* --- Buffers --- *)
		{
			OptionName -> InjectionTable,
			Default -> Automatic,
			Description -> "The order of sample, Standard, and Blank sample loading into the Instrument during measurement and/or collection. Also includes the flushing and priming of the column.",
			ResolutionDescription -> "Determined to the order of input samples articulated. Standard and Blank samples are inserted based on the determination of StandardFrequency and BlankFrequency. For example, StandardFrequency -> FirstAndLast and BlankFrequency -> Null result in Standard samples injected first, then samples, and then the Standard sample set again.",
			AllowNull -> False,
			Widget -> Adder[
				Alternatives[
					{
						"Type" -> Widget[
							Type -> Enumeration,
							Pattern :> Standard | Sample | Blank
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
								Pattern :> Alternatives[Automatic]
							]
						],
						"InjectionType" -> Alternatives[
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
							],
							Widget[
								Type -> Enumeration,
								Pattern :> FPLCInjectionTypeP
							]
						],
						"InjectionVolume" -> Alternatives[
							Widget[
								Type -> Quantity,
								Pattern :> RangeP[1 Microliter, 4 Liter],
								Units :> Microliter
							],
							Widget[
								Type -> Enumeration,
								Pattern :> Alternatives[Automatic]
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
					{
						"Type" -> Widget[
							Type -> Enumeration,
							Pattern :> ColumnPrime | ColumnFlush
						],
						"Sample" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic | Null]
						],
						"InjectionType" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic | Null]
						],
						"InjectionVolume" -> Widget[
							Type -> Enumeration,
							Pattern :> Alternatives[Automatic | Null]
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

					}
				],
				Orientation -> Vertical
			],
			Category -> "Sample Parameters"
		},
		{
			OptionName -> SampleTemperature,
			Default -> Ambient,
			Description -> "The temperature at which the samples, Standard, and Blank are kept in the autosampler.",
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[4 Celsius, $AmbientTemperature],
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
			OptionName -> FlowInjectionPurgeCycle,
			Default -> Automatic,
			Description -> "When InjectionType is FlowInjection or Superloop, whether to take the leftover sample from purging the lines in the syringe and dispensing it into the sample container. If this option is False, extra sample of up to 20 mL may be used to purge the line and discarded afterward. If this option is True, some BufferA and BufferB solutions (in the already purged line) will mix with the sample for purging and be transferred back to the sample tube.",
			ResolutionDescription -> "Automatically set to False when InjectionType contains FlowInjection or Superloop. Set to Null otherwise.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			],
			Category -> "Sample Parameters"
		},
		{
			OptionName -> FractionCollectionTemperature,
			Default -> Automatic,
			Description -> "Indicates the temperature at which the fractions should be held during and after collection.",
			ResolutionDescription -> "Automatically set to the FractionCollectionTemperature of the specified FractionCollectionMethod, or Ambient otherwise.",
			AllowNull -> True,
			Category -> "FractionCollection",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[6 Celsius, 20 Celsius],
					Units -> Celsius
				],
				Widget[
					Type -> Enumeration,
					Pattern :> Alternatives[Ambient]
				]
			]
		},
		IndexMatching[
			IndexMatchingInput -> "experiment samples",
			{
				OptionName -> InjectionVolume,
				Default -> Automatic,
				Description -> "The physical quantity of sample loaded into the flow path for measurement and/or collection.",
				ResolutionDescription -> "Automatically resolves from Instrument and takes into account Instrument deadvolume and Sample volume.",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microliter, 4 Liter],
					Units -> Microliter
				],
				Category -> "Sample Parameters"
			},
			{
				OptionName -> SampleFlowRate,
				Default -> Automatic,
				Description -> "When InjectionType is FlowInjection, the rate at which the sample is introduced to the flow path.",
				ResolutionDescription -> "Automatically set to the first FlowRate if InjectionType is FlowInjection; otherwise, set to Null.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
					Units -> CompoundUnit[
						{1, {Milliliter, {Milliliter, Liter}}},
						{-1, {Minute, {Minute, Second}}}
					]
				],
				Category -> "Sample Parameters"
			}
		],
		{
			OptionName -> BufferA,
			Default -> Automatic,
			Description -> "The solvent pumped through channel A of the flow path.",
			ResolutionDescription -> "Automatically set from SeparationMode or the objects specified by the Gradient option.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
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
			Description -> "The solvent pumped through channel B of the flow path.",
			ResolutionDescription -> "Automatically set from SeparationMode or the objects specified by the Gradient option.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
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
			Description -> "The solvent pumped through a secondary channel A of the flow path.",
			ResolutionDescription -> "Automatically set from the objects specified by the Gradient option.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
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
			Description -> "The solvent pumped through a secondary channel B of the flow path.",
			ResolutionDescription -> "Automatically set from the objects specified by the Gradient option.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
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
			OptionName -> BufferE,
			Default -> Automatic,
			Description -> "The solvent pumped through a tertiary channel A of the flow path.",
			ResolutionDescription -> "Automatically set from the objects specified by the Gradient option.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
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
			OptionName -> BufferF,
			Default -> Automatic,
			Description -> "The solvent pumped through a tertiary channel B of the flow path.",
			ResolutionDescription -> "Automatically set from the objects specified by the Gradient option.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
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
			OptionName -> BufferG,
			Default -> Automatic,
			Description -> "The solvent pumped through the quaternary channel A of the flow path.",
			ResolutionDescription -> "Automatically set from the objects specified by the Gradient option.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
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
			OptionName -> BufferH,
			Default -> Automatic,
			Description -> "The solvent pumped through the quaternary channel B of the flow path.",
			ResolutionDescription -> "Automatically set from the objects specified by the Gradient option.",
			AllowNull -> True,
			Widget -> Widget[
				Type -> Object,
				Pattern :> ObjectP[{Model[Sample], Object[Sample]}],
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
			IndexMatchingInput -> "experiment samples",
			(* --- Gradient Specification Parameters --- *)
			{
				OptionName -> GradientA,
				Default -> Automatic,
				Description -> "The composition of BufferA within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientA->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferA in the flow will rise such that at 15 minutes, the composition should be 50*Percent.",
				ResolutionDescription -> "Automatically set from Gradient option or implicitly resolved from the GradientB and SeparationMode options.",
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
								Pattern :> GreaterEqualP[0 Minute],
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
				Description -> "The composition of BufferB within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientB->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferB in the flow will rise such that at 15 minutes, the composition should be 50*Percent.",
				ResolutionDescription -> "Automatically set from Gradient option or implicitly resolved from the GradientA and SeparationMode options.",
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
								Pattern :> GreaterEqualP[0 Minute],
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
				Description -> "The composition of BufferC within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientC->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferA in the flow will rise such that at 15 minutes, the composition should be 50*Percent.",
				ResolutionDescription -> "Automatically set from Gradient option in order to have the percentages total to 100%.",
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
								Pattern :> GreaterEqualP[0 Minute],
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
				Description -> "The composition of BufferD within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientB->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferB in the flow will rise such that at 15 minutes, the composition should be 50*Percent.",
				ResolutionDescription -> "Automatically set from Gradient option or implicitly resolved from the GradientA and SeparationMode options.",
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
								Pattern :> GreaterEqualP[0 Minute],
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
				OptionName -> GradientE,
				Default -> Automatic,
				Description -> "The composition of BufferE within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientC->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferA in the flow will rise such that at 15 minutes, the composition should be 50*Percent.",
				ResolutionDescription -> "Automatically set from Gradient option in order to have the percentages total to 100%.",
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
								Pattern :> GreaterEqualP[0 Minute],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer E Composition" -> Widget[
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
				OptionName -> GradientF,
				Default -> Automatic,
				Description -> "The composition of BufferF within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientB->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferB in the flow will rise such that at 15 minutes, the composition should be 50*Percent.",
				ResolutionDescription -> "Automatically set from Gradient option or implicitly resolved from the GradientA and SeparationMode options.",
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
								Pattern :> GreaterEqualP[0 Minute],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer F Composition" -> Widget[
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
				OptionName -> GradientG,
				Default -> Automatic,
				Description -> "The composition of BufferG within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientC->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferA in the flow will rise such that at 15 minutes, the composition should be 50*Percent.",
				ResolutionDescription -> "Automatically set from Gradient option in order to have the percentages total to 100%.",
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
								Pattern :> GreaterEqualP[0 Minute],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer G Composition" -> Widget[
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
				OptionName -> GradientH,
				Default -> Automatic,
				Description -> "The composition of BufferH within the flow, defined for specific time points. The composition is linearly interpolated for the intervening periods between the defined time points. For example for GradientB->{{0 Minute, 10 Percent},{30 Minute, 90 Percent}}, the percentage of BufferB in the flow will rise such that at 15 minutes, the composition should be 50*Percent.",
				ResolutionDescription -> "Automatically set from Gradient option or implicitly resolved from the GradientA and SeparationMode options.",
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
								Pattern :> GreaterEqualP[0 Minute],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer H Composition" -> Widget[
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
				OptionName -> Gradient,
				Default -> Automatic,
				Description -> "The buffer composition over time in the fluid flow. Specific parameters of an object can be overridden by specific options.",
				ResolutionDescription -> "Automatically set to best meet all the Gradient options (e.g. GradientA, GradientB, FlowRate, GradientStart, GradientEnd, GradientDuration, EquilibrateTime, FlushTime).",
				AllowNull -> False,
				Category -> "Gradient",
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[Method, Gradient]]
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
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
							"Flow Rate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
								Units -> CompoundUnit[
									{1, {Milliliter, {Milliliter, Liter}}},
									{-1, {Minute, {Minute, Second}}}
								]
							]
						},
						Orientation -> Vertical
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
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
								Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
								Units -> CompoundUnit[
									{1, {Milliliter, {Milliliter, Liter}}},
									{-1, {Minute, {Minute, Second}}}
								]
							]
						},
						Orientation -> Vertical
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
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
							"Buffer E Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Buffer F Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Buffer G Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Buffer H Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Flow Rate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
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
				OptionName -> FlowRate,
				Default -> Automatic,
				Description -> "The speed of the fluid through the pump. This speed is linearly interpolated such that consecutive entries of {Time, Flow Rate} will define the intervening fluid speed. For example, {{0 Minute, 0.3 Milliliter/Minute},{30 Minute, 0.5 Milliliter/Minute}} means flow rate of 0.4 Milliliter/Minute at 15 minutes into the run.",
				ResolutionDescription -> "Automatically set from SeparationMode and Scale or inherited from the method given in the Gradient option.",
				AllowNull -> False,
				Category -> "Gradient",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
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
								Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
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
				OptionName -> GradientStart,
				Default -> Null,
				Description -> "A shorthand option to specify the starting Buffer B composition. This option must be specified with GradientEnd and GradientDuration.",
				AllowNull -> True,
				Category -> "Gradient",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				]
			},
			{
				OptionName -> GradientEnd,
				Default -> Null,
				Description -> "A shorthand option to specify the final Buffer B composition. This option must be specified with GradientStart and GradientDuration.",
				AllowNull -> True,
				Category -> "Gradient",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				]
			},
			{
				OptionName -> GradientDuration,
				Default -> Null,
				Description -> "A shorthand option to specify the length of time during which the gradient will be applied.",
				AllowNull -> True,
				Category -> "Gradient",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Minute],
					Units -> {Minute, {Minute, Second}}
				]
			},
			{
				OptionName -> SampleLoopDisconnect,
				Default -> Automatic,
				Description -> "For runs using the autosampler, the volume of buffer that should be flowed through the sample loop at the initial conditions to displace the sample, before the sample loop is disconnected from the flow path and the gradient begins. Null indicates that the sample loop is not disconnected from the flow path.",
				ResolutionDescription -> "Automatically set to Null, leaving the sample loop connected for the duration of the gradient.",
				AllowNull -> True,
				Category -> "Gradient",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Milliliter, 4 Liter],
					Units -> {Milliliter, {Milliliter, Liter}}
				]
			},
			{
				OptionName -> PreInjectionEquilibrationTime,
				Default -> Automatic,
				Description -> "The amount of time that buffer should be run through the system at the initial conditions before the sample is injected.",
				ResolutionDescription -> "Automatically set to 5 Minute if Instrument is Model[Instrument,FPLC,AKTA avant 150], otherwise set to Null.",
				AllowNull -> True,
				Category -> "Gradient",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute,4 Hour],
					Units -> {Minute, {Minute, Second}}
				]
			},
			{
				OptionName -> EquilibrationTime,
				Default -> Null,
				Description -> "A shorthand option to specify the duration of equilibration at the starting buffer composition at the start of a gradient.",
				AllowNull -> True,
				Category -> "Gradient",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute,4 Hour],
					Units -> {Minute, {Minute, Second}}
				]
			},
			{
				OptionName -> FlushTime,
				Default -> Null,
				Description -> "A shorthand option to specify the duration of BufferB flush at the end of a gradient.",
				AllowNull -> True,
				Category -> "Gradient",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute,4 Hour],
					Units -> {Minute, {Minute, Second}}
				]
			},
			{
				OptionName -> FlowDirection,
				Default -> Forward,
				Description -> "The direction of the flow going through the column during the sample injection, controlled with the instrument software's plumbing settings. Forward indicates that the flow will go through the column in the direction indicated by the column manufacturer for standard operation. Reverse indicates that the flow will go through the column in the opposite direction indicated by the column manufacturer for standard operation. Reverse flow is only available on Model[Instrument, FPLC, AKTA avant 150] and Model[Instrument, FPLC, AKTA avant 25].",
				AllowNull -> False,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> ColumnOrientationP
				],
				Category -> "Gradient"
			},

			(* --- Fraction Collection Parameters --- *)
			{
				OptionName -> CollectFractions,
				Default -> Automatic,
				Description -> "Indicates whether to capture and store effluent from the Column by specific time windows (fractions).",
				ResolutionDescription -> "Automatically set to True if Scale is Preparative or any fraction collection options are specified.",
				AllowNull -> False,
				Category -> "FractionCollection",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> BooleanP
				]
			},
			{
				OptionName -> FractionCollectionMethod,
				Default -> Null,
				Description -> "The fraction collection method object which describes the conditions for which a fraction is collected. Specific parameters of the object can be overridden by other fraction collection options.",
				AllowNull -> True,
				Category -> "FractionCollection",
				Widget -> Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Method, FractionCollection]]
				]
			},
			{
				OptionName -> FractionCollectionStartTime,
				Default -> Automatic,
				Description -> "The time at which to start column effluent capture. 0*Minute will start fraction collection with the sample application. Time in this case is the duration from the start of analyte injection.",
				ResolutionDescription -> "Automatically set to the second time point of the gradient domains or inherited from the FractionCollectionMethod option.",
				AllowNull -> True,
				Category -> "FractionCollection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0 Minute],
					Units -> {Minute, {Minute, Second}}
				]
			},
			{
				OptionName -> FractionCollectionEndTime,
				Default -> Automatic,
				Description -> "The time to end column effluent capture. Time in this case is the duration from the start of analyte injection.",
				ResolutionDescription -> "Automatically set to the last time point of the gradient domains or inherited from a method specified by FractionCollectionMethod option.",
				AllowNull -> True,
				Category -> "FractionCollection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0 Minute],
					Units -> {Minute, {Minute, Second}}
				]
			},

			{
				OptionName -> FractionCollectionMode,
				Default -> Automatic,
				Description -> "The method by which fractions collection should be triggered (peak detection, a constant threshold, or a fixed fraction duration).",
				ResolutionDescription -> "Automatically set to Threshold, inherited from a method specified by FractionCollectionMethod option, or implicitly from other fraction collection options.",
				AllowNull -> True,
				Category -> "FractionCollection",
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> FractionCollectionModeP
				]
			},
			{
				OptionName -> MaxFractionVolume,
				Default -> Automatic,
				Description -> "The maximum volume of a single fraction.",
				ResolutionDescription -> "Automatically converted from MaxCollectionPeriod * the initial FlowRate, if that's specified. Otherwise, automatically set to 50 mL if the system can handle it, otherwise, 1.8 Milliliter or inherited from a method specified by FractionCollectionMethod option.",
				AllowNull -> True,
				Category -> "FractionCollection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[10 Microliter,250 Milliliter],
					Units -> {Milliliter, {Milliliter, Microliter}}
				]
			},
			(*we don't really have a straightforward of doing this in Unicorn, so it's hidden for now*)
			{
				OptionName -> MaxCollectionPeriod,
				Default -> Automatic,
				Description -> "The amount of time after which a new fraction will be generated.",
				ResolutionDescription -> "Automatically converted from MaxFractionVolume / the initial FlowRate.",
				AllowNull -> True,
				Category -> "FractionCollection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterEqualP[0 Second],
					Units -> {Second, {Second, Minute}}
				]
			},
			{
				OptionName -> AbsoluteThreshold,
				Default -> Automatic,
				Description -> "The absorbance or conductance signal value above which fractions will always be collected. Note that if specified in absorbance, this behavior is controlled by the absorbance at the first wavelength specified with the Wavelength option.",
				(*TODO update this*)
				ResolutionDescription -> "Automatically set to 500 mAU when FractionCollectionMode is Threshold or inherited from a method specified by FractionCollectionMethod option.",
				AllowNull -> True,
				Category -> "FractionCollection",
				Widget -> Alternatives[
					"Absorbance" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 AbsorbanceUnit],
						Units -> {MilliAbsorbanceUnit, {MilliAbsorbanceUnit, AbsorbanceUnit}}
					],
					"Conductance" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 Millisiemen / Centimeter],
						Units -> CompoundUnit[
							{1, {Millisiemen, {Millisiemen, Siemens}}},
							{-1, {Centimeter, {Centimeter}}}
						]
					]
				]
			},
			{
				OptionName -> PeakSlope,
				Default -> Automatic,
				Description -> "The minimum slope rate (per second) that must be met before a peak is detected and fraction collection begins.  A new peak (and new fraction) can be registered once the slope drops below this again, and collection ends when the PeakEndThreshold value is reached. Note that if specified with absorbance units, this behavior is controlled by the absorbance at the first wavelength specified with the Wavelength option.",
				ResolutionDescription -> "Automatically inherited from a method specified by FractionCollectionMethod option.",
				AllowNull -> True,
				Category -> "FractionCollection",
				Widget -> Alternatives[
					"Absorbance" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 AbsorbanceUnit / Second],
						Units -> CompoundUnit[
							{1, {AbsorbanceUnit, {AbsorbanceUnit, MilliAbsorbanceUnit}}},
							{-1, {Second, {Second, Millisecond}}}
						]
					],
					"Conductance" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 Millisiemen / (Centimeter * Second)],
						Units -> CompoundUnit[
							{1, {Millisiemen, {Millisiemen, Siemens}}},
							{-1, {Centimeter, {Centimeter}}},
							{-1, {Second, {Second, Millisecond}}}
						]
					]
				]
			},
			{
				OptionName -> PeakMinimumDuration,
				Default -> Automatic,
				Description -> "The least amount of time that changes in slopes or threshold must be maintained before they are registered for fraction collection. Note that this behavior is controlled by the absorbance at the first wavelength specified with the Wavelength option.",
				ResolutionDescription -> "Automatically set to 0 Second or inherited from a method specified by FractionCollectionMethod option.",
				AllowNull -> True,
				Category -> "FractionCollection",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.02 Minute, 1500 Minute],
					Units -> {Minute, {Minute, Second}}
				]
			},
			{
				OptionName -> PeakSlopeEnd,
				Default -> Automatic,
				Description -> "The maximum slope rate (per second) to cease fraction collection after being started.",
				ResolutionDescription -> "When FractionCollectionMode is Peak, automatically set to PeakSlope or inherited from a method specified by FractionCollectionMethod option.",
				AllowNull -> True,
				Category -> "FractionCollection",
				Widget -> Alternatives[
					"Absorbance" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 AbsorbanceUnit / Second],
						Units -> CompoundUnit[
							{1, {AbsorbanceUnit, {AbsorbanceUnit, MilliAbsorbanceUnit}}},
							{-1, {Second, {Second, Millisecond}}}
						]
					],
					"Conductance" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 Millisiemen / (Centimeter * Second)],
						Units -> CompoundUnit[
							{1, {Millisiemen, {Millisiemen, Siemens}}},
							{-1, {Centimeter, {Centimeter}}},
							{-1, {Second, {Second, Millisecond}}}
						]
					]
				]
			},
			{
				OptionName -> PeakEndThreshold,
				Default -> Automatic,
				Description -> "The absorbance or conductance signal value below which the end of a peak is marked and fraction collection stops. Note that if given as an absorbance value, this behavior is controlled by the absorbance at the first wavelength specified with the Wavelength option.",
				ResolutionDescription -> "Automatically set to Null or inherited from a method specified by FractionCollectionMethod option.",
				AllowNull -> True,
				Category -> "FractionCollection",
				Widget -> Alternatives[
					"Absorbance" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 AbsorbanceUnit],
						Units -> {MilliAbsorbanceUnit, {MilliAbsorbanceUnit, AbsorbanceUnit}}
					],
					"Conductance" -> Widget[
						Type -> Quantity,
						Pattern :> GreaterEqualP[0 Millisiemen / Centimeter],
						Units -> CompoundUnit[
							{1, {Millisiemen, {Millisiemen, Siemens}}},
							{-1, {Centimeter, {Centimeter}}}
						]
					]
				]
			}
		],

		(* --- Standard Options --- *)
		{
			OptionName -> StandardFrequency,
			Default -> Automatic,
			Description -> "Specify the frequency at which standard runs will be inserted among samples.",
			ResolutionDescription -> "Automatically set to FirstAndLast when any Standard options are specified.",
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
				OptionName -> Standard,
				Default -> Automatic,
				Description -> "A reference compound to inject to the instrument, often used for quantification or to check internal measurement consistency.",
				ResolutionDescription -> "Automatically set from SeparationMode when any other Standard option is specified, otherwise set to {}.",
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
						}
					}
				]
			},
			{
				OptionName -> StandardInjectionType,
				Default -> Automatic,
				Description -> "The manner of introducing standard to the flow path and Column. Autosampler entails a robotic handling device that injects directly from sample vials and/or plates. FlowInjection directly pumps the sample into the column. Superloop pumps sample into a specialized syringe/sample loop that ensures constant volume introduction onto the column.",
				ResolutionDescription -> "For standard injection volumes smaller than the instrument's sample loop, set to Autosampler. If set above 20 Milliliter, set to direct flow injection; otherwise, set to Superloop.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> FPLCInjectionTypeP (*Autosampler|FlowInjection|Superloop*)
				],
				Category -> "Standard"
			},
			{
				OptionName -> StandardInjectionVolume,
				Default -> Automatic,
				Description -> "The volume of each Standard to inject.",
				(* TODO change this resolution description (and the BlankInjectionVolume one) because it's not accurate at all *)
				ResolutionDescription -> "Automatically resolves to 10*Microliter if Standard is specified.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microliter, 4 Liter],
					Units -> Microliter
				]
			},
			{
				OptionName -> StandardGradient,
				Default -> Automatic,
				Description -> "The buffer composition over time in the fluid flow for Standard measurement.",
				ResolutionDescription -> "Automatically set to best meet all the StandardGradient_ options (e.g. StandardGradientA, StandardGradientB, StandardGradientDuration, StandardFlowRate).",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[Method, Gradient]]
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
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
							"Flow Rate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
								Units -> CompoundUnit[
									{1, {Milliliter, {Milliliter, Liter}}},
									{-1, {Minute, {Minute, Second}}}
								]
							]
						},
						Orientation -> Vertical
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
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
								Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
								Units -> CompoundUnit[
									{1, {Milliliter, {Milliliter, Liter}}},
									{-1, {Minute, {Minute, Second}}}
								]
							]
						},
						Orientation -> Vertical
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
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
							"Buffer E Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Buffer F Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Buffer G Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Buffer H Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Flow Rate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
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
				OptionName -> StandardGradientA,
				Default -> Automatic,
				Description -> "The composition of BufferA within the flow, defined for specific time points for Standard measurement.",
				ResolutionDescription -> "Automatically set from StandardGradient option or implicitly set from StandardGradientB options.",
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
								Pattern :> GreaterEqualP[0 Minute],
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
				Description -> "The composition of BufferB within the flow, defined for specific time points for Standard measurement.",
				ResolutionDescription -> "Automatically set from StandardGradient option or implicitly set from StandardGradientA options.",
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
								Pattern :> GreaterEqualP[0 Minute],
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
				Description -> "The composition of BufferC within the flow, defined for specific time points for Standard measurement.",
				ResolutionDescription -> "Automatically set from StandardGradient option or implicitly set from the other gradient options.",
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
								Pattern :> GreaterEqualP[0 Minute],
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
				Description -> "The composition of BufferD within the flow, defined for specific time points for Standard measurement.",
				ResolutionDescription -> "Automatically set from StandardGradient option or implicitly set from the other gradient options.",
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
								Pattern :> GreaterEqualP[0 Minute],
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
				OptionName -> StandardGradientE,
				Default -> Automatic,
				Description -> "The composition of BufferE within the flow, defined for specific time points for Standard measurement.",
				ResolutionDescription -> "Automatically set from StandardGradient option or implicitly set from the other gradient options.",
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
								Pattern :> GreaterEqualP[0 Minute],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer E Composition" -> Widget[
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
				OptionName -> StandardGradientF,
				Default -> Automatic,
				Description -> "The composition of BufferF within the flow, defined for specific time points for Standard measurement.",
				ResolutionDescription -> "Automatically set from StandardGradient option or implicitly set from the other gradient options.",
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
								Pattern :> GreaterEqualP[0 Minute],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer F Composition" -> Widget[
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
				OptionName -> StandardGradientG,
				Default -> Automatic,
				Description -> "The composition of BufferG within the flow, defined for specific time points for Standard measurement.",
				ResolutionDescription -> "Automatically set from StandardGradient option or implicitly set from the other gradient options.",
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
								Pattern :> GreaterEqualP[0 Minute],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer G Composition" -> Widget[
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
				OptionName -> StandardGradientH,
				Default -> Automatic,
				Description -> "The composition of BufferH within the flow, defined for specific time points for Standard measurement.",
				ResolutionDescription -> "Automatically set from StandardGradient option or implicitly set from the other gradient options.",
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
								Pattern :> GreaterEqualP[0 Minute],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer H Composition" -> Widget[
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
				Description -> "The speed of the fluid through the system for Standard measurement.",
				ResolutionDescription -> "Automatically set from SeparationMode and Scale or inherited from the method given in the StandardGradient option.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
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
								Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
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
				OptionName -> StandardGradientStart,
				Default -> Null,
				Description -> "A shorthand option to specify the starting Buffer B composition for standard samples. This option must be specified with StandardGradientEnd and StandardGradientDuration.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				]
			},
			{
				OptionName -> StandardGradientEnd,
				Default -> Null,
				Description -> "A shorthand option to specify the final Buffer B composition for standard samples. This option must be specified with StandardGradientStart and StandardGradientDuration.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				]
			},
			{
				OptionName -> StandardGradientDuration,
				Default -> Null,
				Description -> "A shorthand option to specify the duration of the standard gradient.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Minute],
					Units -> {Minute, {Minute, Second}}
				]
			},
			{
				OptionName -> StandardSampleLoopDisconnect,
				Default -> Automatic,
				Description -> "For runs using the autosampler, the volume of buffer that should be flowed through the sample loop at the initial conditions to displace the standard, before the sample loop is disconnected from the flow path and the gradient begins. Null indicates that the sample loop is not disconnected from the flow path.",
				ResolutionDescription -> "Automatically set to Null, leaving the sample loop connected for the duration of the gradient.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Milliliter, 4 Liter],
					Units -> {Milliliter, {Milliliter, Liter}}
				]
			},
			{
				OptionName -> StandardPreInjectionEquilibrationTime,
				Default -> Automatic,
				Description -> "The amount of time that buffer should be run through the system at the initial conditions before the sample is injected.",
				ResolutionDescription -> "Automatically set to 5 Minute if Instrument is Model[Instrument,FPLC,AKTA avant 150], otherwise set to Null.",
				AllowNull -> True,
				Category -> "Standard",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute,4 Hour],
					Units -> {Minute, {Minute, Second}}
				]
			},
			{
				OptionName -> StandardFlowDirection,
				Default -> Automatic,
				Description -> "The direction of the flow going through the column during the standard injection, controlled with the instrument software's plumbing settings. Forward indicates that the flow will go through the column in the direction indicated by the column manufacturer for standard operation. Reverse indicates that the flow will go through the column in the opposite direction indicated by the column manufacturer for standard operation. Reverse flow is only available on Model[Instrument, FPLC, AKTA avant 150] and Model[Instrument, FPLC, AKTA avant 25].",
				ResolutionDescription -> "Automatically set to Forward if Standard is specified.",
				AllowNull->True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> ColumnOrientationP
				],
				Category -> "Standard"
			},
			{
				OptionName -> StandardStorageCondition,
				Default -> Null,
				Description -> "The non-default conditions under which any standards used by this experiment should be stored after the protocol is completed. If left Null, the standard samples will be stored according to their Models' DefaultStorageCondition.",
				AllowNull -> True,
				Category -> "Standard",
				(* Null indicates the storage conditions will be inherited from the model *)
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal]
				]
			}
		],

		(* --- Wavelength Settings --- *)
		{
			OptionName -> Wavelength,
			Default -> Automatic,
			Description -> "The physical properties of light passed through the flow for the Absorbance Detector. Up to 3 separate wavelengths may be specified.",
			ResolutionDescription -> "Automatically set to 254 Nanometer if Instrument -> Model[Instrument, FPLC, \"AKTApurifier UPC 10\"], or {280 Nanometer, 260 Nanometer} otherwise.",
			AllowNull -> False,
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[190 Nanometer, 700 Nanometer, 1 Nanometer],
					Units :> Nanometer
				],
				Adder[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[190 Nanometer, 700 Nanometer, 1 Nanometer],
						Units :> Nanometer
					]
				]
			]
		},

		(* --- Blank Information --- *)
		{
			OptionName -> BlankFrequency,
			Default -> Automatic,
			Description -> "Specify the frequency at which blank runs will be inserted between samples.",
			ResolutionDescription -> "Automatically set to FirstAndLast when any Blank options are specified.",
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

		(* --- Blank Options --- *)
		IndexMatching[
			IndexMatchingParent -> Blank,
			{
				OptionName -> Blank,
				Default -> Automatic,
				Description -> "The object(s) to inject typically as negative controls (e.g. to test effects stemming from injection, sample solvent, or buffer).",
				ResolutionDescription -> "Automatically set to BufferA when any other Blank option is specified.",
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
				OptionName -> BlankInjectionType,
				Default -> Automatic,
				Description -> "The manner of introducing blank to the flow path and Column. Autosampler entails a robotic handling device that injects directly from sample vials and/or plates. FlowInjection directly pumps the sample into the column. Superloop pumps sample into a specialized syringe/sample loop that ensures constant volume introduction onto the column.",
				ResolutionDescription -> "For blank injection volumes smaller than the instrument's sample loop, set to Autosampler. If set above 20 Milliliter, set to direct flow injection; otherwise, set to Superloop.",
				AllowNull -> True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> FPLCInjectionTypeP (*Autosampler|FlowInjection|Superloop*)
				],
				Category -> "Blanks"
			},
			{
				OptionName -> BlankInjectionVolume,
				Default -> Automatic,
				Description -> "The volume of each Blank to inject.",
				ResolutionDescription -> "Automatically resolves to 10*Microliter if Blanks are specified.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[1 Microliter, 4 Liter],
					Units -> Microliter
				]
			},
			{
				OptionName -> BlankGradient,
				Default -> Automatic,
				Description -> "The buffer composition over time in the fluid flow for Blank measurement.",
				ResolutionDescription -> "Automatically set to best meet all the BlankGradient_ options (e.g. BlankGradientA, BlankGradientB, BlankGradientDuration, BlankFlowRate).",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Object,
						Pattern :> ObjectP[Object[Method, Gradient]]
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
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
							"Flow Rate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
								Units -> CompoundUnit[
									{1, {Milliliter, {Milliliter, Liter}}},
									{-1, {Minute, {Minute, Second}}}
								]
							]
						},
						Orientation -> Vertical
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
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
								Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
								Units -> CompoundUnit[
									{1, {Milliliter, {Milliliter, Liter}}},
									{-1, {Minute, {Minute, Second}}}
								]
							]
						},
						Orientation -> Vertical
					],
					Adder[
						{
							"Time" -> Widget[
								Type -> Quantity,
								Pattern :> GreaterEqualP[0 Minute],
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
							"Buffer E Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Buffer F Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Buffer G Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Buffer H Composition" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0 Percent, 100 Percent],
								Units -> Percent
							],
							"Flow Rate" -> Widget[
								Type -> Quantity,
								Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
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
				OptionName -> BlankGradientA,
				Default -> Automatic,
				Description -> "The composition of BufferA within the flow, defined for specific time points for Blank measurement.",
				ResolutionDescription -> "Automatically set from BlankGradient option or implicitly resolved from BlankGradientB option.",
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
								Pattern :> GreaterEqualP[0 Minute],
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
				Description -> "The composition of BufferB within the flow, defined for specific time points for Blank measurement.",
				ResolutionDescription -> "Automatically set from BlankGradient option or implicitly resolved from BlankGradientA option.",
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
								Pattern :> GreaterEqualP[0 Minute],
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
				Description -> "The composition of BufferC within the flow, defined for specific time points for Blank measurement.",
				ResolutionDescription -> "Automatically set from BlankGradient option or implicitly resolved from the Blank gradient options.",
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
								Pattern :> GreaterEqualP[0 Minute],
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
				Description -> "The composition of BufferD within the flow, defined for specific time points for Blank measurement.",
				ResolutionDescription -> "Automatically set from BlankGradient option or implicitly resolved from BlankGradient option.",
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
								Pattern :> GreaterEqualP[0 Minute],
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
				OptionName -> BlankGradientE,
				Default -> Automatic,
				Description -> "The composition of BufferE within the flow, defined for specific time points for Blank measurement.",
				ResolutionDescription -> "Automatically set from BlankGradient option or implicitly resolved from the Blank gradient options.",
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
								Pattern :> GreaterEqualP[0 Minute],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer E Composition" -> Widget[
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
				OptionName -> BlankGradientF,
				Default -> Automatic,
				Description -> "The composition of BufferF within the flow, defined for specific time points for Blank measurement.",
				ResolutionDescription -> "Automatically set from BlankGradient option or implicitly resolved from BlankGradient option.",
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
								Pattern :> GreaterEqualP[0 Minute],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer F Composition" -> Widget[
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
				OptionName -> BlankGradientG,
				Default -> Automatic,
				Description -> "The composition of BufferG within the flow, defined for specific time points for Blank measurement.",
				ResolutionDescription -> "Automatically set from BlankGradient option or implicitly resolved from the Blank gradient options.",
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
								Pattern :> GreaterEqualP[0 Minute],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer G Composition" -> Widget[
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
				OptionName -> BlankGradientH,
				Default -> Automatic,
				Description -> "The composition of BufferH within the flow, defined for specific time points for Blank measurement.",
				ResolutionDescription -> "Automatically set from BlankGradient option or implicitly resolved from BlankGradient option.",
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
								Pattern :> GreaterEqualP[0 Minute],
								Units -> {Minute, {Second, Minute}}
							],
							"Buffer H Composition" -> Widget[
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
				Description -> "The speed of the fluid through the system for Blank measurement.",
				ResolutionDescription -> "Automatically set from SelectionMode and Scale or inherited from the method given in the BlankGradient option.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Alternatives[
					Widget[
						Type -> Quantity,
						Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
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
								Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
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
				OptionName -> BlankGradientStart,
				Default -> Null,
				Description -> "A shorthand option to specify the starting Buffer B composition for blank samples. This option must be specified with BlankGradientEnd and BlankGradientDuration.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				]
			},
			{
				OptionName -> BlankGradientEnd,
				Default -> Null,
				Description -> "A shorthand option to specify the final Buffer B composition for blank samples. This option must be specified with BlankGradientStart and BlankGradientDuration.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Percent, 100 Percent],
					Units -> Percent
				]
			},
			{
				OptionName -> BlankGradientDuration,
				Default -> Null,
				Description -> "A shorthand option to specify the duration of the blank gradient.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> GreaterP[0 Minute],
					Units -> {Minute, {Minute, Second}}
				]
			},
			{
				OptionName -> BlankSampleLoopDisconnect,
				Default -> Automatic,
				Description -> "For runs using the autosampler, the volume of buffer that should be flowed through the sample loop at the initial conditions to displace the blank, before the sample loop is disconnected from the flow path and the gradient begins. Null indicates that the sample loop is not disconnected from the flow path.",
				ResolutionDescription -> "Automatically set to Null, leaving the sample loop connected for the duration of the gradient.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Milliliter, 4 Liter],
					Units -> {Milliliter, {Milliliter, Liter}}
				]
			},
			{
				OptionName -> BlankPreInjectionEquilibrationTime,
				Default -> Automatic,
				Description -> "The amount of time that buffer should be run through the system at the initial conditions before the sample is injected.",
				ResolutionDescription -> "Automatically set to 5 Minute if Instrument is Model[Instrument,FPLC,AKTA avant 150], otherwise set to Null.",
				AllowNull -> True,
				Category -> "Blanks",
				Widget -> Widget[
					Type -> Quantity,
					Pattern :> RangeP[0 Minute,4 Hour],
					Units -> {Minute, {Minute, Second}}
				]
			},
			{
				OptionName -> BlankFlowDirection,
				Default -> Automatic,
				Description -> "The direction of the flow going through the column during the blank injection, controlled with the instrument software's plumbing settings. Forward indicates that the flow will go through the column in the direction indicated by the column manufacturer for standard operation. Reverse indicates that the flow will go through the column in the opposite direction indicated by the column manufacturer for standard operation. Reverse flow is only available on Model[Instrument, FPLC, AKTA avant 150] and Model[Instrument, FPLC, AKTA avant 25].",
				ResolutionDescription -> "Automatically set to Forward if Blank is specified.",
				AllowNull->True,
				Widget -> Widget[
					Type -> Enumeration,
					Pattern :> ColumnOrientationP
				],
				Category -> "Blanks"
			},
			{
				OptionName -> BlankStorageCondition,
				Default -> Null,
				Description -> "The non-default conditions under which any blanks used by this experiment should be stored after the protocol is completed. If left Null, the blank samples will be stored according to their Models' DefaultStorageCondition.",
				AllowNull -> True,
				Category -> "Blanks",
				(* Null indicates the storage conditions will be inherited from the model *)
				Widget -> Alternatives[
					Widget[Type -> Enumeration, Pattern :> SampleStorageTypeP | Disposal]
				]
			}
		],

		(* --- Flush and Prime Information --- *)
		{
			OptionName -> ColumnRefreshFrequency,
			Default -> Automatic,
			Description -> "Specify the frequency at which column flush (where solvent is flowed without injection in order to release adsorbed compounds within the column) and primes (where solvent is flowed in order to equilibrate the column) will be inserted into the order of analyte injections. An initial column prime and final column flush will be performed unless Null or None is specified.",
			ResolutionDescription -> "Set to Null when InjectionTable option is specified (meaning that this option is inconsequential); otherwise, set to FirstAndLast (meaning initial column prime before the measurements and final column flush after measurements.) when there is a Column. Set to None if there is no flush or prime.",
			AllowNull -> True,
			Category -> "ColumnPrime",
			Widget -> Alternatives[
				Widget[
					Type -> Enumeration,
					Pattern :> None | FirstAndLast | First | Last
				],
				Widget[
					Type -> Number,
					Pattern :> GreaterP[0, 1]
				]
			]
		},
		(* --- Column Prime Gradient Parameters --- *)
		{
			OptionName -> ColumnPrimeGradient,
			Default -> Automatic,
			Description -> "The buffer composition over time in the fluid flow for column prime.",
			ResolutionDescription -> "Automatically set to best meet all the ColumnPrimeGradient_ options (e.g. ColumnPrimeGradientA, ColumnPrimeGradientB, ColumnPrimeDuration, ColumnPrimeFlowRate).",
			AllowNull -> True,
			Category -> "ColumnPrime",
			Widget -> Alternatives[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Method, Gradient]]
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
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
						"Flow Rate" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
							Units -> CompoundUnit[
								{1, {Milliliter, {Milliliter, Liter}}},
								{-1, {Minute, {Minute, Second}}}
							]
						]
					},
					Orientation -> Vertical
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
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
							Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
							Units -> CompoundUnit[
								{1, {Milliliter, {Milliliter, Liter}}},
								{-1, {Minute, {Minute, Second}}}
							]
						]
					},
					Orientation -> Vertical
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
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
						"Buffer E Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer F Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer G Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer H Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Flow Rate" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
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
			OptionName -> ColumnPrimeGradientA,
			Default -> Automatic,
			Description -> "The composition of BufferA within the flow, defined for specific time points for column prime.",
			ResolutionDescription -> "Automatically set from ColumnPrimeGradient option or implicitly resolved from ColumnPrimeGradientB option.",
			AllowNull -> True,
			Category -> "ColumnPrime",
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
							Pattern :> GreaterEqualP[0 Minute],
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
			Description -> "The composition of BufferB within the flow, defined for specific time points for column prime.",
			ResolutionDescription -> "Automatically set from ColumnPrimeGradient option or implicitly resolved from ColumnPrimeGradientA option.",
			AllowNull -> True,
			Category -> "ColumnPrime",
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
							Pattern :> GreaterEqualP[0 Minute],
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
			Description -> "The composition of BufferC within the flow, defined for specific time points for column prime.",
			ResolutionDescription -> "Automatically set from ColumnPrimeGradient option or implicitly resolved from ColumnPrimeGradient option.",
			AllowNull -> True,
			Category -> "ColumnPrime",
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
							Pattern :> GreaterEqualP[0 Minute],
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
			Description -> "The composition of BufferD within the flow, defined for specific time points for column prime.",
			ResolutionDescription -> "Automatically set from ColumnPrimeGradient option or implicitly resolved from ColumnPrimeGradient option.",
			AllowNull -> True,
			Category -> "ColumnPrime",
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
							Pattern :> GreaterEqualP[0 Minute],
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
			OptionName -> ColumnPrimeGradientE,
			Default -> Automatic,
			Description -> "The composition of BufferE within the flow, defined for specific time points for column prime.",
			ResolutionDescription -> "Automatically set from ColumnPrimeGradient option or implicitly resolved from ColumnPrimeGradient option.",
			AllowNull -> True,
			Category -> "ColumnPrime",
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
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer E Composition" -> Widget[
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
			OptionName -> ColumnPrimeGradientF,
			Default -> Automatic,
			Description -> "The composition of BufferF within the flow, defined for specific time points for column prime.",
			ResolutionDescription -> "Automatically set from ColumnPrimeGradient option or implicitly resolved from ColumnPrimeGradient option.",
			AllowNull -> True,
			Category -> "ColumnPrime",
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
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer F Composition" -> Widget[
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
			OptionName -> ColumnPrimeGradientG,
			Default -> Automatic,
			Description -> "The composition of BufferG within the flow, defined for specific time points for column prime.",
			ResolutionDescription -> "Automatically set from ColumnPrimeGradient option or implicitly resolved from ColumnPrimeGradient option.",
			AllowNull -> True,
			Category -> "ColumnPrime",
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
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer G Composition" -> Widget[
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
			OptionName -> ColumnPrimeGradientH,
			Default -> Automatic,
			Description -> "The composition of BufferH within the flow, defined for specific time points for column prime.",
			ResolutionDescription -> "Automatically set from ColumnPrimeGradient option or implicitly resolved from ColumnPrimeGradient option.",
			AllowNull -> True,
			Category -> "ColumnPrime",
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
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer H Composition" -> Widget[
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
			Description -> "The speed of the fluid through the system for column prime.",
			ResolutionDescription -> "Automatically set from SeparationMode and Scale or inherited from the method given in the ColumnPrimeGradient option.",
			AllowNull -> True,
			Category -> "ColumnPrime",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
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
							Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
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
			OptionName -> ColumnPrimeStart,
			Default -> Null,
			Description -> "A shorthand option to specify the starting Buffer B composition for column prime runs. This option must be specified with ColumnPrimeEnd and ColumnPrimeDuration.",
			AllowNull -> True,
			Category -> "ColumnPrime",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Percent, 100 Percent],
				Units -> Percent
			]
		},
		{
			OptionName -> ColumnPrimeEnd,
			Default -> Null,
			Description -> "A shorthand option to specify the final Buffer B composition for column prime runs. This option must be specified with ColumnPrimeStart and ColumnPrimeDuration.",
			AllowNull -> True,
			Category -> "ColumnPrime",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Percent, 100 Percent],
				Units -> Percent
			]
		},
		{
			OptionName -> ColumnPrimeDuration,
			Default -> Null,
			Description -> "A shorthand option to specify the duration of the column prime gradient.",
			AllowNull -> True,
			Category -> "ColumnPrime",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> {Minute, {Minute, Second}}
			]
		},
		{
			OptionName -> ColumnPrimePreInjectionEquilibrationTime,
			Default -> Automatic,
			Description -> "The amount of time that buffer should be run through the system at the initial conditions before the sample is injected.",
			ResolutionDescription -> "Automatically set to 5 Minute if Instrument is Model[Instrument,FPLC,AKTA avant 150], otherwise set to Null.",
			AllowNull -> True,
			Category -> "ColumnPrime",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Minute,4 Hour],
				Units -> {Minute, {Minute, Second}}
			]
		},
		{
			OptionName -> ColumnPrimeFlowDirection,
			Default -> Automatic,
			Description -> "The direction of the flow going through the column during column prime, controlled with the instrument software's plumbing settings. Forward indicates that the flow will go through the column in the direction indicated by the column manufacturer for standard operation. Reverse indicates that the flow will go through the column in the opposite direction indicated by the column manufacturer for standard operation. Reverse flow is only available on Model[Instrument, FPLC, AKTA avant 150] and Model[Instrument, FPLC, AKTA avant 25].",
			ResolutionDescription -> "Automatically set to Forward if column prime is specified.",
			AllowNull->True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> ColumnOrientationP
			],
			Category -> "ColumnPrime"
		},
		(* --- Column Flush Gradient Parameters --- *)
		{
			OptionName -> ColumnFlushGradient,
			Default -> Automatic,
			Description -> "The buffer composition over time in the fluid flow for column flush.",
			ResolutionDescription -> "Automatically set to best meet all the ColumnFlushGradient_ options (e.g. ColumnFlushGradientA, ColumnFlushGradientB, ColumnFlushDuration, ColumnFlushFlowRate).",
			AllowNull -> True,
			Category -> "ColumnFlush",
			Widget -> Alternatives[
				Widget[
					Type -> Object,
					Pattern :> ObjectP[Object[Method, Gradient]]
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
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
						"Flow Rate" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
							Units -> CompoundUnit[
								{1, {Milliliter, {Milliliter, Liter}}},
								{-1, {Minute, {Minute, Second}}}
							]
						]
					},
					Orientation -> Vertical
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
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
							Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
							Units -> CompoundUnit[
								{1, {Milliliter, {Milliliter, Liter}}},
								{-1, {Minute, {Minute, Second}}}
							]
						]
					},
					Orientation -> Vertical
				],
				Adder[
					{
						"Time" -> Widget[
							Type -> Quantity,
							Pattern :> GreaterEqualP[0 Minute],
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
						"Buffer E Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer F Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer G Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Buffer H Composition" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0 Percent, 100 Percent],
							Units -> Percent
						],
						"Flow Rate" -> Widget[
							Type -> Quantity,
							Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
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
			OptionName -> ColumnFlushGradientA,
			Default -> Automatic,
			Description -> "The composition of BufferA within the flow, defined for specific time points for column flush.",
			ResolutionDescription -> "Automatically set from ColumnFlushGradient option or implicitly resolved from ColumnFlushGradientB option.",
			AllowNull -> True,
			Category -> "ColumnFlush",
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
							Pattern :> GreaterEqualP[0 Minute],
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
			Description -> "The composition of BufferB within the flow, defined for specific time points for column flush.",
			ResolutionDescription -> "Automatically set from ColumnFlushGradient option or implicitly resolved from ColumnFlushGradientA option.",
			AllowNull -> True,
			Category -> "ColumnFlush",
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
							Pattern :> GreaterEqualP[0 Minute],
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
			Description -> "The composition of BufferC within the flow, defined for specific time points for column flush.",
			ResolutionDescription -> "Automatically set from ColumnFlushGradient option or implicitly resolved from ColumnFlushGradient options.",
			AllowNull -> True,
			Category -> "ColumnFlush",
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
							Pattern :> GreaterEqualP[0 Minute],
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
			Description -> "The composition of BufferD within the flow, defined for specific time points for column flush.",
			ResolutionDescription -> "Automatically set from ColumnFlushGradient option or implicitly resolved from ColumnFlushGradient options.",
			AllowNull -> True,
			Category -> "ColumnFlush",
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
							Pattern :> GreaterEqualP[0 Minute],
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
			OptionName -> ColumnFlushGradientE,
			Default -> Automatic,
			Description -> "The composition of BufferE within the flow, defined for specific time points for column flush.",
			ResolutionDescription -> "Automatically set from ColumnFlushGradient option or implicitly resolved from ColumnFlushGradient options.",
			AllowNull -> True,
			Category -> "ColumnFlush",
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
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer E Composition" -> Widget[
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
			OptionName -> ColumnFlushGradientF,
			Default -> Automatic,
			Description -> "The composition of BufferF within the flow, defined for specific time points for column flush.",
			ResolutionDescription -> "Automatically set from ColumnFlushGradient option or implicitly resolved from ColumnFlushGradient options.",
			AllowNull -> True,
			Category -> "ColumnFlush",
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
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer F Composition" -> Widget[
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
			OptionName -> ColumnFlushGradientG,
			Default -> Automatic,
			Description -> "The composition of BufferG within the flow, defined for specific time points for column flush.",
			ResolutionDescription -> "Automatically set from ColumnFlushGradient option or implicitly resolved from ColumnFlushGradient options.",
			AllowNull -> True,
			Category -> "ColumnFlush",
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
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer G Composition" -> Widget[
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
			OptionName -> ColumnFlushGradientH,
			Default -> Automatic,
			Description -> "The composition of BufferH within the flow, defined for specific time points for column flush.",
			ResolutionDescription -> "Automatically set from ColumnFlushGradient option or implicitly resolved from ColumnFlushGradient options.",
			AllowNull -> True,
			Category -> "ColumnFlush",
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
							Pattern :> GreaterEqualP[0 Minute],
							Units -> {Minute, {Second, Minute}}
						],
						"Buffer H Composition" -> Widget[
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
			Description -> "The speed of the fluid through the system for column flush.",
			ResolutionDescription -> "Automatically set from SeparationMode and Scale or inherited from the method given in the ColumnFlushGradient option.",
			AllowNull -> True,
			Category -> "ColumnFlush",
			Widget -> Alternatives[
				Widget[
					Type -> Quantity,
					Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
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
							Pattern :> RangeP[0.001 Milliliter / Minute, 150 Milliliter / Minute],
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
			OptionName -> ColumnFlushStart,
			Default -> Null,
			Description -> "A shorthand option to specify the starting Buffer B composition for column flush runs. This option must be specified with ColumnFlushEnd and ColumnFlushDuration.",
			AllowNull -> True,
			Category -> "ColumnFlush",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Percent, 100 Percent],
				Units -> Percent
			]
		},
		{
			OptionName -> ColumnFlushEnd,
			Default -> Null,
			Description -> "A shorthand option to specify the final Buffer B composition for column flush runs. This option must be specified with ColumnFlushStart and ColumnFlushDuration.",
			AllowNull -> True,
			Category -> "ColumnFlush",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Percent, 100 Percent],
				Units -> Percent
			]
		},
		{
			OptionName -> ColumnFlushDuration,
			Default -> Null,
			Description -> "A shorthand option to specify the duration of the column flush gradient.",
			AllowNull -> True,
			Category -> "ColumnFlush",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> GreaterEqualP[0 Minute],
				Units -> {Minute, {Minute, Second}}
			]
		},
		{
			OptionName -> ColumnFlushPreInjectionEquilibrationTime,
			Default -> Automatic,
			Description -> "The amount of time that buffer should be run through the system at the initial conditions before the sample is injected.",
			ResolutionDescription -> "Automatically set to 5 Minute if Instrument is Model[Instrument,FPLC,AKTA avant 150], otherwise set to Null.",
			AllowNull -> True,
			Category -> "ColumnFlush",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[0 Minute,4 Hour],
				Units -> {Minute, {Minute, Second}}
			]
		},
		{
			OptionName -> ColumnFlushFlowDirection,
			Default -> Automatic,
			Description -> "The direction of the flow going through the column during column flush, controlled with the instrument software's plumbing settings. Forward indicates that the flow will go through the column in the direction indicated by the column manufacturer for standard operation. Reverse indicates that the flow will go through the column in the opposite direction indicated by the column manufacturer for standard operation. Reverse flow is only available on Model[Instrument, FPLC, AKTA avant 150] and Model[Instrument, FPLC, AKTA avant 25].",
			ResolutionDescription -> "Automatically set to Forward if column flush is specified.",
			AllowNull->True,
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> ColumnOrientationP
			],
			Category -> "ColumnFlush"
		},
		(* --- General Options --- *)
		{
			OptionName -> NumberOfReplicates,
			Default -> 1,
			Description -> "The number of times each sample will be injected in an FPLC experiment. If Aliquot -> True, this also indicates the number of times each provided sample will be aliquoted.",
			AllowNull -> False,
			Widget -> Widget[
				Type -> Number,
				Pattern :> GreaterP[0, 1]
			]
		},
		{
			OptionName -> FullGradientChangePumpDisconnectAndPurge,
			Default -> Null,
			Description -> "When the gradients changes from 100% one buffer to 100% another buffer, if this option is set to True then, the flow path between the buffer inlet and injection valve is vacated and replaced with the new buffer.",
			AllowNull -> True,
			Category -> "Gradient",
			Widget -> Widget[
				Type -> Enumeration,
				Pattern :> BooleanP
			]
		},
		{
			OptionName -> PumpDisconnectOnFullGradientChangePurgeVolume,
			Default -> Automatic,
			Description -> "The amount of buffer used for each FullGradientChangePumpDisconnectAndPurge.",
			ResolutionDescription -> "Set to Null if FullGradientChangePumpDisconnectAndPurge is Off; otherwise, set to 15 Milliliter.",
			AllowNull -> True,
			Category -> "Gradient",
			Widget -> Widget[
				Type -> Quantity,
				Pattern :> RangeP[10 Milliliter, 50 Milliliter],
				Units -> {Milliliter, {Milliliter, Microliter}}
			]
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
		SimulationOption,
		SubprotocolDescriptionOption,
		SamplesInStorageOption,
		SamplesOutStorageOption
	}
];

Error::ColumnPrimeOptionInjectionTableConflict="Column prime options `1` cannot be set if ColumnPrime entries are not included in the InjectionTable.";
Error::ColumnFlushOptionInjectionTableConflict="Column flush options `1` cannot be set if ColumnFlush entries are not included in the InjectionTable.";
Error::GradientTooLong="The specifications related to `1` result in too long of a gradient (limit of `2`).";
Error::StandardOptionConflict="The following options can not be set to Null when Standards are specified, either in the option or the InjectionTable: `1`. Consider letting these options set automatically.";
Error::BlankOptionConflict="The following options can not be set to Null when Blanks are specified, either in the option or the InjectionTable: `1`. Consider letting these options set automatically.";
Error::FPLCTooManySamples = "The number of input samples, standards, and blanks times the NumberOfReplicates cannot fit onto the instrument in one run.  `1` were provided as input, but only `2` can be processed in a single protocol. Please consider splitting into several protocols.";
Warning::BufferConflict = "The resolved values of `1` (`2`)  differ from provided gradient method(s) for these options (`3`). Nonetheless, the experiment will commence as directed with the former value(s).";
Error::InvalidFractionCollectionTemperature = "The FractionCollectionTemperature option was set to `1`, but the specified instrument `2` does not support any temperature besides Ambient.  Please set FractionCollectionTemperature to Ambient, or change the Instrument to Model[Instrument, FPLC, \"AKTA avant 25\"] or Model[Instrument, FPLC, \"AKTA avant 150\"] (which support fraction temperature control).";
Error::InvalidSampleTemperature = "The SampleTemperature option was set to `1`, but the InjectionVolume, StandardInjectionVolume, or BlankInjectionVolume option(s) contained a value over `2`, the maximum allowed injection volume for the autosampler of the specified instrument.  Please set SampleTemperature to Ambient, or lower the injection volume(s) low enough to allow the use of the autosampler.";
Error::FlowRateAboveMax = "The specified flow rate for the following options: `1` (`2`) are not less than the required instrument's (`3`) or columns' (`4`) maximum (`5`). Please specify a compatible FlowRate.";
Error::InstrumentDoesNotContainDetector = "The following specified detectors (`1`) are not available on the specified instrument (`2`).  Please select a different instrument or detectors that are available for the specified instrument (populated in the Detector field of the instrument model).";
Error::TooManyWavelengths = "The Wavelength option (`1`) contains more wavelengths than is supported for the specified instrument (`2`).  Please only specify at most `3` wavelength(s) for this instrument.";
Error::UnsupportedWavelength = "The Wavelength option (`1`) contains value(s) that are not supported by the specified instrument `2`.  Please leave Wavelength blank or change to an instrument that supports this wavelength.";
Error::FractionVolumeAboveMax = "The following values of the MaxFractionVolume option (`1`) are greater than the maximum allowed fraction volume by the specified instrument `2` (2 Milliliter).  Please lower the MaxFractionVolume, or specify an instrument that allows a greater fraction volume.";
Error::TooManyBuffers = "The specified instrument (`1`) supports only `2` different BufferAs and `2` different BufferBs, but the combined buffers from the `3` options exceed this amount.  Please alter these options such that combined they consist of `2` or fewer values.";
Warning::FPLCBuffersNotFiltered = "The specified buffers (`1`) are not filtered prior to the FPLC experiment and may cause damage to the column. Please consider performing an ExperimentFilter on the buffers before the FPLC experiment.";
Error::IncompatibleInjectionVolume = "The following InjectionVolume/StandardInjectionVolume/BlankInjectionVolume values: `1` are above the maximum injection volume for `2` (`3`).  Please lower the volumes in these values, or select a different instrument that supports higher volumes.";
Error::InsufficientInjectionVolume = "The following InjectionVolume/StandardInjectionVolume/BlankInjectionVolume values: `1` are below the minimum injection volume for an InjectionType of FlowInjection (1 Milliliter).  Please increase the volumes in these values, or select a different InjectionType that supports lower volumes.";
Error::InjectionVolumeOutOfRange = "The following InjectionVolume/StandardInjectionVolume/BlankInjectionVolume values: `1` are outside the range of allowed injection volumes for an InjectionType of Superloop (1 Milliliter to 10 Milliliter).  Please adjust the volumes in these values, or select a different InjectionType that supports the specified volumes.";
Error::IncompatibleColumnTechnique="The specified `1` `2` has a ChromatographyType of `3` and may not perform as expected using the `4` ChromatographyType.";
Error::ConflictingPeakSlopeOptions="The specified values for PeakSlope, PeakMinimumDuration, and PeakSlopeThreshold are not compatible; either all must be specified to the same units or all must be left Automatic or Null.";
Error::ConflictingFractionCollectionOptions="There is a conflict between the FractionCollectionMode option and Peak and/or Thresholding options.  If FractionCollectionMode is set to Threshold, PeakSlope, PeakMinimumDuration, and PeakSlopeEnd must not be specified. If FractionCollectionMode is set to Peak, AbsoluteThreshold and PeakEndThreshold must not be specified.  If FractionCollectionMode is Time, all those options must not be specified.";
Error::ConflictingFractionOptions="There is a conflict between the CollectFractions option and other fraction collection options. Consider letting CollectFractions to auto set.";
Error::ConductivityThresholdNotSupported="Peak threshold as controlled by conductivity is not supported on `1`, but the following option(s) are specified in units of conductivity: `2`.  Please specify these option(s) in units of absorbance, or specify a different instrument.";
Error::StandardsBlanksOutside="Currently, Standards/Blanks are not supported with the AKTA10 system unless they're already in the same plate as the sample.";
Warning::OverwritingGradient="The inherited gradient will be overwritten based on setting of other options: `1`. Please review and ensure that it meets desired specifications.";
Error::NonBinaryFPLC="The following gradient options have nonbinary profiles (e.g. both A and C percents are non-zero, or B and D): `1`.";
Error::InjectionTypeLoopConflict="The specified SampleLoopVolume is not compatible with the Instrument and/or InjectionType. Consider letting SampleLoopVolume automatically set.";
Error::SampleFlowRateConflict="The specified SampleFlowRate is not compatible with the InjectionType. If InjectionType is set to FlowInjection, SampleFlowRate must not be Null.  Otherwise, it must be Null. Consider letting SampleFlowRate automatically set.";
Error::FeatureUnavailableFPLCInstrument="The following options were specified in ways incompatible with the Instrument: `1`. Consider allowing the Instrument to autoset in order to meet the features the best.";
Warning::FlowCellChangedToNearest="The specified flow cell pathlength `1` is not available for the instrument (the following are `2`). The flow cell pathlength was set to the nearest available one at `3`.";
Warning::MixerChangedToNearest="The specified mixer volume `1` is not available for the instrument (the following are `2`). The flow cell pathlength was set to the nearest available one at `3`.";
Warning::RemovedExtraGradientEntries="A specified gradient in `1` after rounding to acceptable time had duplicate entries. The duplicates were removed.";
Error::GradientSingleton="The following options have only one entry in the gradient table: `1` At least 2 are need.";
Error::ReverseFlowDirectionConflict="Reverse flow direction is only available on Model[Instrument, FPLC, \"AKTA avant 150\"] and Model[Instrument, FPLC, \"AKTA avant 25\"]. Please use Forward flow direction or update other options to use one of the allowed instrument models.";
Error::IncompatibleSampleContainer="The following sample containers `1` are not compatible with the instrument selected. Please consider using the default containers for the instrument `2`.";
Error::FlowInjectionPurgeCycleConflict="FlowInjectionPurgeCycle cannot be True when InjectionType does not contain FlowInjection or Superloop.";
Error::SamplePumpWashConflict="SamplePumpWash option at positions `1` cannot be True if the corresponding InjectionType is not FlowInjection.";
Warning::SuperloopInjectionVolumesRounded="Volumes must be specified in increments of 0.01 Milliliter if InjectionType -> Superloop. Specified volumes `1` have been rounded to the nearest 0.01 Milliliter quantity. ";
Warning::FPLCFlowInjectionPurgeCycle="Please note that some BufferA and BufferB solutions (in the already purged line) will mix with the sample for purging and be transferred back to the sample tube.";
Error::GradientPurgeConflict="FullGradientChangePumpDisconnectAndPurge and PumpDisconnectOnFullGradientChangePurgeVolume options are conflicting. If FullGradientChangePumpDisconnectAndPurge is False, PumpDisconnectOnFullGradientChangePurgeVolume cannot be specified. If FullGradientChangePumpDisconnectAndPurge is True, PumpDisconnectOnFullGradientChangePurgeVolume cannot be Null";
Error::SampleLoopDisconnectOptionConflict = "SampleLoopDisconnect volumes can only be specified when the corresponding sample injection type is Autosampler. The sample injection type `1` must be index matched with the provided SampleLoopDisconnect `2`.";
Error::StandardSampleLoopDisconnectOptionConflict = "StandardSampleLoopDisconnect volumes can only be specified when the corresponding standard injection type is Autosampler. The standard injection type `1` must be index matched with the provided StandardSampleLoopDisconnect `2`.";
Error::BlankSampleLoopDisconnectOptionConflict = "BlankSampleLoopDisconnect volumes can only be specified when the corresponding blank injection type is Autosampler. The blank injection type `1` must be index matched with the provided BlankSampleLoopDisconnect `2`.";
Error::SampleLoopDisconnectInstrumentOptionConflict="SampleLoopDisconnection volumes can only be specified when the instrument model is Avant 25 or Avant 150. Please remove the values of `1` for options `2` or specify the instrument as Avant 25 or Avant 150.";
Warning::LowAutosamplerFlushVolume="The SampleLoopDisconnection volumes `1` for options `2` are less than the total volume of tubing in the autosampler for the `3` of `4` (tubing volume + sample loop volume). The contents of the sample loop with therefore not be completely flushed into the flow path and may lead to incomplete sample application and/or carry over between adjacent injections. To avoid this, please specify volumes that exceed `4`.";
Warning::FPLCInsufficientSampleVolume="The samples `1` do not have sufficient volume for the injection volume plus the dead volume of `2`. The experiment will still attempt to make injections with what is currently available; please change the InjectionVolume options if this is not desired.";
Error::SuperloopMixedAndMatched="The InjectionType/BlankInjectionType/StandardInjectionType options have been set to multiple methods, one of which is the Superloop.  While FlowInjection and Autosampler may both be used in the same experiment, Superloop must be used by itself.  Please create multiple protocols, or use different injection types.";


(* ::Subsubsection:: *)
(*ExperimentFPLC (Code) *)

(* singleton sample overload *)
ExperimentFPLC[mySample : ObjectP[Object[Sample]], myOptions : OptionsPattern[ExperimentFPLC]] := ExperimentFPLC[{mySample}, myOptions];

(* core sample overload*)
ExperimentFPLC[mySamples : {ObjectP[Object[Sample]]..}, myOptions : OptionsPattern[ExperimentFPLC]] := Module[
	{listedOptions, listedSamples, outputSpecification, output, gatherTests, messages, safeOptions, safeOptionTests,
		validLengths, validLengthTests, upload, confirm, canaryBranch, fastTrack, parentProt, inheritedCache, unresolvedOptions,
		applyTemplateOptionTests, combinedOptions, expandedCombinedOptions, resolveOptionsResult, resolvedOptions,
		resolutionTests, resolvedOptionsNoHidden, returnEarlyQ, allDownloadValues, newCache, allInstrumentObjects,
		finalizedPackets, resourcePacketTests, allTests, validQ, previewRule, optionsRule, testsRule, resultRule,
		validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation,
		samplePreparationFields, sampleModelPreparationFields, modelPreparationFields, allGradientObjects, allColumnObjects, allFractionCollectionMethods,
		allContainerObjects, containerFields, containerModelFields, sampleContainerFields, allContainerModels, allCapModels,
		containerModelFieldsThroughLinks, sampleContainerModelFields,allSampleObjects,allSampleModels,
		mySamplesWithPreparedSamplesNamed, safeOptionsNamed, myOptionsWithPreparedSamplesNamed, combinedOptionsNoCache},

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* deterimine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	{listedSamples, listedOptions}=removeLinks[ToList[mySamples], ToList[myOptions]];

	(* Simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamplesNamed, myOptionsWithPreparedSamplesNamed, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentFPLC,
			listedSamples,
			listedOptions
		],
		$Failed,
		{Download::ObjectDoesNotExist,Error::MissingDefineNames}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptionsNamed, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentFPLC, myOptionsWithPreparedSamplesNamed, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentFPLC, myOptionsWithPreparedSamplesNamed, AutoCorrect -> False], Null}
	];
	
	(* Sanitize named inputs *)
	{mySamplesWithPreparedSamples,safeOptions, myOptionsWithPreparedSamples} = sanitizeInputs[mySamplesWithPreparedSamplesNamed, safeOptionsNamed, myOptionsWithPreparedSamplesNamed,Simulation->updatedSimulation];
	
	(* If the specified options don't match their patterns or if the option lengths are invalid, return $Failed*)
	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* call ValidInputLengthsQ to make sure all the options are the right length *)
	{validLengths, validLengthTests} = If[gatherTests,
		ValidInputLengthsQ[ExperimentFPLC, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> {Result, Tests}],
		{ValidInputLengthsQ[ExperimentFPLC, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1], Null}
	];

	(* If option lengths are invalid return $Failed (or the tests up to this point) *)
	If[Not[validLengths],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests, validLengthTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* get assorted hidden options *)
	{upload, confirm, canaryBranch, fastTrack, parentProt, inheritedCache} = Lookup[safeOptions, {Upload, Confirm, CanaryBranch, FastTrack, ParentProtocol, Cache}];

	(* apply the template options *)
	(* need to specify the definition number (we are number 1 for samples at this point) *)
	{unresolvedOptions, applyTemplateOptionTests} = If[gatherTests,
		ApplyTemplateOptions[ExperimentFPLC, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> {Result, Tests}],
		{ApplyTemplateOptions[ExperimentFPLC, {mySamplesWithPreparedSamples}, myOptionsWithPreparedSamples, 1, Output -> Result], Null}
	];

	(* If couldn't apply the template, return $Failed (or the tests up to this point) *)
	If[MatchQ[unresolvedOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> Flatten[{safeOptionTests, validLengthTests, applyTemplateOptionTests}],
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* combine the safe options with what we got from the template options *)
	combinedOptions = ReplaceRule[safeOptions, unresolvedOptions];

	(* remove the Cache and Simulation keys because we don't need to Download every object in those to actually do our big Download calls *)
	combinedOptionsNoCache = DeleteCases[combinedOptions, Rule[Cache | Simulation, _]];

	(* expand the combined options *)
	expandedCombinedOptions = Last[ExpandIndexMatchedInputs[ExperimentFPLC, {mySamplesWithPreparedSamples}, combinedOptions, 1]];

	(* Set up the samplePreparationFields using SamplePreparationCacheFields*)
	samplePreparationFields = Packet[SamplePreparationCacheFields[Object[Sample], Format -> Sequence], IncompatibleMaterials, LiquidHandlerIncompatible, Tablet, SolidUnitWeight, TransportTemperature];
	sampleModelPreparationFields = Packet[Model[Flatten[{IncompatibleMaterials, FilterMaterial, FilterSize, SamplePreparationCacheFields[Model[Sample], Format -> Sequence]}]]];
	modelPreparationFields = Packet[IncompatibleMaterials, FilterMaterial, FilterSize, SamplePreparationCacheFields[Model[Sample], Format -> Sequence]];

	(* get all the specified gradient and objects *)
	allGradientObjects = Join[
		DeleteDuplicates[Cases[combinedOptionsNoCache, ObjectReferenceP[Object[Method, Gradient]], Infinity]],
		fplcSystemGradientSearch["Memoization"]
	];

	(* get all of the sample objects*)
	(*don't include cache because that's a bad time when simulating with Prep Primiitves*)
	allSampleObjects = DeleteDuplicates[Cases[KeyDrop[combinedOptionsNoCache,Cache], ObjectReferenceP[Object[Sample]], Infinity]];

	allSampleModels = Join[
		DeleteDuplicates[Cases[KeyDrop[combinedOptionsNoCache,Cache], ObjectReferenceP[Model[Sample]], Infinity]],
		(* Buffer defaults *)
		{
			Model[Sample, StockSolution, "id:9RdZXvKBeEbJ"], (* Ion Exchange Buffer A Native *)
			Model[Sample, StockSolution, "id:8qZ1VWNmdLbb"], (* Ion Exchange Buffer B Native *)
			Model[Sample, "Milli-Q water"]
		}
	];

	(* get all the specified fraction collection objects *)
	allFractionCollectionMethods = DeleteDuplicates[Cases[combinedOptionsNoCache, ObjectReferenceP[Object[Method, FractionCollection]], Infinity]];

	(* get all the specified column objects.  Note that this includes the ones that we could resolve to *)
	allColumnObjects = DeleteDuplicates[Flatten[{
		Model[Item, Column, "id:1ZA60vwjbbm5"], (* 3x HiTrap 5x5mL Desalting Column *)
		Model[Item, Column, "id:o1k9jAGmWnjx"], (* HiTrap Q HP 5x5mL Column *)
		Model[Item, Column, "id:R8e1PjpK5a0n"], (* Tricorn column *)
		Cases[combinedOptionsNoCache, ObjectReferenceP[{Object[Item, Column], Model[Item, Column]}], Infinity]
	}]];

	(* get all the specified instruments, and all instruments we could use as well *)
	allInstrumentObjects = DeleteDuplicates[Flatten[{
		Cases[combinedOptionsNoCache, ObjectReferenceP[{Object[Instrument, FPLC], Model[Instrument, FPLC]}], Infinity],
		Search[Model[Instrument, FPLC], Deprecated != True]
	}]];

	(* get the containers we need to Download from *)
	(* these are default containers for autosampler and flow injection *)
	allContainerModels = DeleteDuplicates[Flatten[{
		Model[Container, Vessel, "HPLC vial (high recovery)"],
		Model[Container, Vessel, "1mL HPLC Vial (total recovery)"],
		Model[Container, Vessel, "22x45mm screw top vial 10mL"],
		Model[Container, Plate, "96-well 2mL Deep Well Plate"],
		Model[Container, Vessel, "50mL Tube"],
		Model[Container, Vessel, "50mL Light Sensitive Centrifuge Tube"],
		Model[Container, Vessel, "250mL Glass Bottle"],
		Model[Container, Vessel, "500mL Glass Bottle"],
		Model[Container, Vessel, "1L Glass Bottle"],
		Model[Container, Vessel, "2L Glass Bottle"],
		Model[Container, Vessel, "Amber Glass Bottle 4 L"],
		Cases[combinedOptionsNoCache, ObjectReferenceP[{Model[Container]}], Infinity]
	}]];
	allContainerObjects = Cases[combinedOptionsNoCache, ObjectReferenceP[{Object[Container]}], Infinity];

	(*also download caps that can be used on this instrument*)
	allCapModels ={
		Model[Item, Cap, "4L Bottle Aspiration Cap, EPDM"],
		Model[Item, Cap, "1L Glass Bottle Aspiration Cap, EPDM"],
		Model[Item, Cap, "500mL Glass Bottle Aspiration Cap, EPDM"],
		Model[Item, Cap, "50mL Tube Aspiration Cap"],
		Model[Item, Cap, "15mL Tube Aspiration Cap"],
		Model[Item, Cap, "2mL Tube Aspiration Cap"]
	};

	(* get the fields for the container and model; this is a little goofy because allContainerObjects can be containers _or_ models and so we basically need to get both *)
	containerFields = Packet[Model, SamplePreparationCacheFields[Object[Container], Format -> Sequence]];
	containerModelFieldsThroughLinks = Packet[Model[{Connectors,Name,MaxVolume,DefaultStorageCondition,SamplePreparationCacheFields[Model[Container],Format -> Sequence]}]];
	containerModelFields = Packet[Connectors,Name,MaxVolume,DefaultStorageCondition,SamplePreparationCacheFields[Model[Container], Format -> Sequence]];
	sampleContainerFields = Packet[Container[{Model, SamplePreparationCacheFields[Object[Container], Format -> Sequence]}]];
	sampleContainerModelFields = Packet[Container[Model][{Connectors,MaxVolume,Name,Dimensions,DefaultStorageCondition,SamplePreparationCacheFields[Model[Container], Format -> Sequence]}]];

	(* Download the sample's packets and their models *)
	allDownloadValues = Quiet[Download[
		{
			mySamples,
			allSampleObjects,
			allSampleModels,
			allGradientObjects,
			allFractionCollectionMethods,
			allColumnObjects,
			allInstrumentObjects,
			allContainerModels,
			allContainerObjects,
			allCapModels
		},
		{
			{
				samplePreparationFields,
				sampleModelPreparationFields,
				Packet[Composition[[All, 2]][{Molecule, PolymerType, MolecularWeight}]],
				sampleContainerFields,
				sampleContainerModelFields
			},
			{
				samplePreparationFields,
				sampleModelPreparationFields,
				Packet[Composition[[All, 2]][{Molecule, PolymerType, MolecularWeight}]],
				sampleContainerFields,
				sampleContainerModelFields
			},
			{
				modelPreparationFields,
				Packet[Composition[[All, 2]][{Molecule, PolymerType, MolecularWeight}]]
			},
			{
				Packet[Name, DateCreated, Temperature, BufferA, BufferB, BufferC, BufferD, BufferE, BufferF, BufferG, BufferH,
					FlowRate, InitialFlowRate, Gradient, GradientStart, GradientEnd, GradientDuration, EquilibrationTime,
					FlushTime]
			},
			{
				Packet[FractionCollectionMode, FractionCollectionStartTime, FractionCollectionEndTime, MaxFractionVolume, MaxCollectionPeriod, FractionCollectionTemperature, AbsoluteThreshold, PeakEndThreshold, PeakSlope, PeakSlopeEnd, PeakMinimumDuration]
			},
			{
				Packet[Name, SeparationMode, Model, NominalFlowRate, MinFlowRate, MaxFlowRate, ChromatographyType, MaxPressure],
				Packet[Model[{Name, SeparationMode, NominalFlowRate, MinFlowRate, MaxFlowRate, ChromatographyType, MaxPressure}]]
			},
			{
				Packet[Model, Name, MinSampleVolume, MaxSampleVolume, WettedMaterials, MaxFlowRate, Detectors, DefaultMixer, AssociatedAccessories, AutosamplerTubingDeadVolume],
				Packet[Model[{Name, MinSampleVolume, MaxSampleVolume, WettedMaterials, MaxFlowRate, Detectors, DefaultMixer, AssociatedAccessories, AutosamplerTubingDeadVolume}]],
				(*get the available mixers for this instrument and the volume*)
				Packet[AssociatedAccessories[[All, 1]][{Object, Volume}]],
				Packet[Model[AssociatedAccessories][[All, 1]][{Object, Volume}]],
				(* get the autosampler information for container compatibility check *)
				Packet[Model[AutosamplerDeckModel]],
				Packet[Model[BufferDeckModel]]
			},
			{
				containerModelFields
			},
			{
				containerFields,
				containerModelFieldsThroughLinks
			},
			{
				Packet[Connectors]
			}
		},
		Cache -> inheritedCache,
		Simulation -> updatedSimulation,
		Date -> Now
	], {Download::FieldDoesntExist, Download::NotLinkField}];

	(* make the new cache combining what we inherited and the stuff we Downloaded *)
	newCache = Cases[FlattenCachePackets[{inheritedCache, allDownloadValues}], PacketP[]];

	(* --- Resolve the options! --- *)

	(* resolve all options; if we throw InvalidOption or InvalidInput, we're also getting $Failed and we will return early *)
	resolveOptionsResult = Check[
		{resolvedOptions, resolutionTests} = If[gatherTests,
			resolveFPLCOptions[mySamplesWithPreparedSamples, expandedCombinedOptions, Output -> {Result, Tests}, Cache -> newCache, Simulation -> updatedSimulation],
			{resolveFPLCOptions[mySamplesWithPreparedSamples, expandedCombinedOptions, Output -> Result, Cache -> newCache, Simulation -> updatedSimulation], Null}
		],
		$Failed,
		{Error::InvalidInput, Error::InvalidOption}
	];

	(* remove the hidden options and collapse the expanded options if necessary *)
	(* need to do this at this level only because resolveFPLCOptions doesn't have access to listedOptions *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentFPLC,
		RemoveHiddenOptions[ExperimentFPLC, resolvedOptions],
		Messages -> False
	];

	(* run all the tests from the resolution; if any of them were False, then we should return early here *)
	(* need to do this becasue if we are collecting tests then the Check wouldn't have caught it *)
	(* basically, if _not_ all the tests are passing, then we do need to return early *)
	returnEarlyQ = Which[
		MatchQ[resolveOptionsResult, $Failed], True,
		gatherTests, Not[RunUnitTest[<|"Tests" -> resolutionTests|>, Verbose -> False, OutputFormat -> SingleBoolean]],
		True, False
	];

	(* if resolveOptionsResult is $Failed, return early; messages would have been thrown already *)
	If[returnEarlyQ,
		Return[outputSpecification /. {Result -> $Failed, Options -> resolvedOptionsNoHidden, Preview -> Null, Tests -> Flatten[{safeOptionTests, applyTemplateOptionTests, validLengthTests, resolutionTests}]}]
	];

	(* call the fplcResourcePackets function to create the protocol packets with resources in them *)
	(* if we're gathering tests, make sure the function spits out both the result and the tests; if we are not gathering tests, the result is enough, and the other can be Null *)
	{finalizedPackets, resourcePacketTests} = If[gatherTests,
		fplcResourcePackets[Download[mySamplesWithPreparedSamples, Object], unresolvedOptions, ReplaceRule[resolvedOptions, Output -> {Result, Tests}], Cache -> newCache, Simulation -> updatedSimulation],
		{fplcResourcePackets[Download[mySamplesWithPreparedSamples, Object], unresolvedOptions, ReplaceRule[resolvedOptions, Output -> Result], Cache -> newCache, Simulation -> updatedSimulation], Null}
	];

	(* --- Packaging the return value --- *)

	(* get all the tests together *)
	allTests = Cases[Flatten[{safeOptionTests, applyTemplateOptionTests, validLengthTests, resolutionTests, resourcePacketTests}], _EmeraldTest];

	(* figure out if we are returning $Failed for the Result option *)
	(* the tricky part is that if the Output option includes Tests _and_ Result, messages will be suppressed.
		Because of this, the Check won't catch the messages and go to $Failed, and so we need a different way to figure out if the Result call should be $Failed
		Doing this by doing RunUnitTest on the Tests; if it is False, Result MUST be $Failed *)
	validQ = Which[
		(* needs to be MemberQ because could possibly generate multiple protocols *)
		MemberQ[finalizedPackets, $Failed] || MatchQ[finalizedPackets, $Failed], False,
		gatherTests && MemberQ[output, Result], RunUnitTest[<|"Tests" -> allTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
		True, True
	];

	(* generate the Preview option; that is always Null *)
	previewRule = Preview -> Null;

	(* generate the options output rule *)
	optionsRule = Options -> If[MemberQ[output, Options],
		resolvedOptionsNoHidden,
		Null
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		allTests,
		Null
	];

	(* generate the Result output rule, but only if we've got a Valid experiment call (determined above) *)
	(* need to call UploadProtocol like this because the overloads get all confused if Rest[finalizedPackets] is {} because it gets treated like an option *)
	resultRule = Result -> Which[
		MemberQ[output, Result] && validQ && Length[finalizedPackets] == 1,
			UploadProtocol[
				First[finalizedPackets],
				Confirm -> confirm,
				CanaryBranch -> canaryBranch,
				Upload -> upload,
				FastTrack -> fastTrack,
				ParentProtocol -> parentProt,
				Priority->Lookup[safeOptions,Priority],
				StartDate->Lookup[safeOptions,StartDate],
				HoldOrder->Lookup[safeOptions,HoldOrder],
				QueuePosition->Lookup[safeOptions,QueuePosition],
				ConstellationMessage -> {Object[Protocol, FPLC]},
				Cache -> newCache,
				Simulation -> updatedSimulation
			],
		MemberQ[output, Result] && validQ,
			UploadProtocol[
				First[finalizedPackets],
				Rest[finalizedPackets],
				Confirm -> confirm,
				CanaryBranch -> canaryBranch,
				Upload -> upload,
				FastTrack -> fastTrack,
				ParentProtocol -> parentProt,
				Priority->Lookup[safeOptions,Priority],
				StartDate->Lookup[safeOptions,StartDate],
				HoldOrder->Lookup[safeOptions,HoldOrder],
				QueuePosition->Lookup[safeOptions,QueuePosition],
				ConstellationMessage -> {Object[Protocol, FPLC]},
				Cache -> newCache,
				Simulation -> updatedSimulation
			],
		True, $Failed
	];

	(* return the output as we desire it *)
	outputSpecification /. {previewRule, optionsRule, resultRule, testsRule}
];

(* singleton container input *)
ExperimentFPLC[myContainer : (ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String), myOptions : OptionsPattern[ExperimentFPLC]] := ExperimentFPLC[{myContainer}, myOptions];

(* multiple container input *)
ExperimentFPLC[myContainers : {(ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String)..}, myOptions : OptionsPattern[ExperimentFPLC]] := Module[
	{listedOptions, outputSpecification, output, gatherTests, safeOptions, safeOptionTests, containerToSampleResult,
		containerToSampleTests, validSamplePreparationResult, mySamplesWithPreparedSamples, myOptionsWithPreparedSamples,
		updatedSimulation, listedContainers, containerToSampleOutput, containerToSampleSimulation, samples,
		sampleOptions},

	(* determine the requested return value from the function *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* deterimine if we should keep a running list of tests; if True, then silence messages *)
	gatherTests = MemberQ[output, Tests];

	{listedContainers, listedOptions}={ToList[myContainers], ToList[myOptions]};

	(* First, simulate our sample preparation. *)
	validSamplePreparationResult = Check[
		(* Simulate sample preparation. *)
		{mySamplesWithPreparedSamples, myOptionsWithPreparedSamples, updatedSimulation} = simulateSamplePreparationPacketsNew[
			ExperimentFPLC,
			listedContainers,
			listedOptions,
			DefaultPreparedModelContainer -> Model[Container, Plate, "96-well 2mL Deep Well Plate"]
		],
		$Failed,
		{Download::ObjectDoesNotExist,Error::MissingDefineNames, Error::InvalidInput, Error::InvalidOption}
	];

	(* If we are given an invalid define name, return early. *)
	If[MatchQ[validSamplePreparationResult, $Failed],
		(* Return early. *)
		(* Note: We've already thrown a message above in simulateSamplePreparationPackets. *)
		Return[$Failed]
	];

	(* call SafeOptions to make sure all options match pattern *)
	{safeOptions, safeOptionTests} = If[gatherTests,
		SafeOptions[ExperimentFPLC, myOptionsWithPreparedSamples, Output -> {Result, Tests}, AutoCorrect -> False],
		{SafeOptions[ExperimentFPLC, myOptionsWithPreparedSamples, AutoCorrect -> False], Null}
	];

	(* If the specified options don't match their patterns, return $Failed*)
	If[MatchQ[safeOptions, $Failed],
		Return[outputSpecification /. {
			Result -> $Failed,
			Tests -> safeOptionTests,
			Options -> $Failed,
			Preview -> Null
		}]
	];

	(* convert the containers to samples, and also get the options index matched properly *)
	containerToSampleResult = If[gatherTests,
		(* We are gathering tests. This silences any messages being thrown. *)
		{containerToSampleOutput, containerToSampleTests, containerToSampleSimulation} = containerToSampleOptions[
			ExperimentFPLC,
			mySamplesWithPreparedSamples,
			safeOptions,
			Output -> {Result, Tests, Simulation},
			Simulation -> updatedSimulation
		];

		(* Therefore, we have to run the tests to see if we encountered a failure. *)
		If[RunUnitTest[<|"Tests" -> containerToSampleTests|>, OutputFormat -> SingleBoolean, Verbose -> False],
			Null,
			$Failed
		],

		(* We are not gathering tests. Simply check for Error::InvalidInput and Error::InvalidOption. *)
		Check[
			{containerToSampleOutput, containerToSampleSimulation} = containerToSampleOptions[
				ExperimentFPLC,
				mySamplesWithPreparedSamples,
				myOptionsWithPreparedSamples,
				Output -> {Result, Simulation},
				Simulation -> updatedSimulation
			],
			$Failed,
			{Error::EmptyContainers, Error::ContainerEmptyWells, Error::WellDoesNotExist}
		]
	];



	(* If we were given an empty container, return early. *)
	If[MatchQ[containerToSampleResult, $Failed],
		(* containerToSampleOptions failed - return $Failed *)
		outputSpecification /. {
			Result -> $Failed,
			Tests -> {safeOptionTests, containerToSampleTests},
			Options -> $Failed,
			Preview -> Null,
			Simulation -> Null,
			InvalidInputs -> {},
			InvalidOptions -> {}
		},

		(* Split up our containerToSample result into the samples and sampleOptions. *)
		{samples, sampleOptions} = containerToSampleOutput;

		(* Call our main function with our samples and converted options. *)
		ExperimentFPLC[samples, ReplaceRule[sampleOptions, Simulation -> containerToSampleSimulation]]
	]

];

(* ::Subsubsection:: *)
(*resolveFPLCOptions*)


DefineOptions[
	resolveFPLCOptions,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

resolveFPLCOptions[mySamples : {ObjectP[Object[Sample]]...}, myOptions : {_Rule...}, myResolutionOptions : OptionsPattern[resolveFPLCOptions]] := Module[
	{outputSpecification, output, gatherTests, cache, samplePrepOptions, fplcOptions, simulatedSamples, resolvedSamplePrepOptions, simulatedCache,
		samplePrepTests, invalidInputs, invalidOptions, resolvedAliquotOptions, discardedQ, discardedSamplePackets, discardedInvalidInputs, containerlessQ,
		resolvedPostProcessingOptions, messagesQ, engineQ, samplePackets, sampleStatuses, discardedSamplePacketsTest, resolvedExperimentOptions, resolvedOptions,
		roundedOptionsAssociation, simulatedSamplePackets, sampleContainers, simulatedSampleContainers, simulatedSampleContainerModels, containerlessSamples, containersExistTest,
		validNameQ, validNameTest, specifiedSeparationMode, preResolvedStandardMaybeList, preResolvedBlankMaybeList, fastAssoc,
		injectionTableSampleConflictQ, incompatibleBool, incompatibleSamplesTest,adjustedOverwriteBlankBool, adjustedOverwriteStandardBool,
		specifiedColumnModelPackets, specifiedColumnTypes, typeColumnCompatibleQ, specifiedColumnPackets, specifiedColumn,
		typeColumnTest, specifiedColumnTechniques, columnTechniqueCompatibleQ, columnTechniqueTest,resolvedInjectionType, resolveInjectionTypes,
		resolvedSamplePumpWash,samplePumpWashConflicts,samplePumpWashConflictPositions,samplePumpWashConflictQ,samplePumpWashConflictOptions,samplePumpWashConflictTest,
		injectionTableLookup, injectionTableSpecifiedQ, gradientOptions, inputSampleObjs, injectionTableSamples,
		roundedGradientOptions, roundedGradientTests, allRoundingTests, foreignBlankOptions, foreignBlankTest, foreignStandardOptions, foreignStandardTest,
		nonGradientRoundedOptions, nonGradientRoundingTests, foreignBlanksQ, foreignStandardsQ,peakSlopeEnds, specifiedPeakSlopeEnd,
		resolvedInjectionTableWithColumns, standardOptionSingletonPatterns, incompatibleColumnTechniqueOptions,
		optionsToRound, valuesToRoundTo, specifiedExpandedStandardGradientPackets, resolvedStandardBufferA,flowRatePrecision,
		resolvedStandardBufferB, resolvedStandard, standardOptionNames, injectionTableTypes, standardOptionSpecifiedBool,
		standardExistsQ, resolvedStandardFrequency, name, nameInvalidOptions, blankOptionSingletonPatterns,
		blankOptionNames, blankOptionSpecifiedBool, blankExistsQ, preResolvedBlankWithPlaceholder,injectionTypeLookup,
		resolvedBlankFrequency, resolvedBlank, preResolvedStandard, collapseGradient,
		allTests, expandedStandardOptions, expandedBlankOptions, resolvedOptionsForInjectionTable,resolvedBlankBufferC, resolvedBlankBufferD,
		resolvedColumn, specifiedExpandedBlankGradients, specifiedExpandedBlankGradientPackets, injectionTableStandards,
		multipleGradientsColumnPrimeFlushOptions, multipleGradientsColumnPrimeFlushTest, fakeInjectionTable, injectionTableBlanks,
		resolvedInjectionTableWithoutInjectionType, specifiedSamplePumpWash,
		resolvedColumnRefreshFrequency, specifiedExpandedStandardGradients, resolvedFlowInjectionPurgeCycle, flowInjectionPurgeCycleConflictQ,
		specifiedInjectionTable, specifiedInjectionTableBlankGradients, specifiedInjectionTableStandardGradients,
		resolvedGradients, resolvedGradientAs, resolvedGradientBs, resolvedGradientStarts, resolvedGradientEnds,
		resolvedGradientDurations, resolvedEquilibrationTimes, resolvedPreInjectionEquilibrationTimes, resolvedFlushTimes, injectionTableSampleRoundedGradients, resolvedFlowRates,
		gradientStartEndSpecifiedBool, gradientInjectionTableSpecifiedDifferentlyBool, resolvedAnalyteGradients, invalidGradientCompositionBool,
		injectionTableStandardGradients, injectionTableBlankGradients, noColumnPrimeQ, noColumnFlushQ,
		injectionTableColumnPrimeGradients, injectionTableColumnFlushGradients, multiplePrimeSameColumnQ, multipleFlushSameColumnQ,
		resolvedStandardAnalyticalGradients, standardGradientInjectionTableSpecifiedDifferentlyBool, standardInvalidGradientCompositionBool,
		resolvedBlankAnalyticalGradients, blankGradientInjectionTableSpecifiedDifferentlyBool, blankInvalidGradientCompositionBool,
		resolvedColumnPrimeAnalyticalGradient, columnPrimeGradientInjectionTableSpecifiedDifferentlyBool, columnPrimeInvalidGradientCompositionBool,
		resolvedColumnFlushAnalyticalGradient, columnFlushGradientInjectionTableSpecifiedDifferentlyBool, columnFlushInvalidGradientCompositionBool,
		resolvedStandardGradientAs, resolvedStandardGradientBs, resolvedStandardFlowRates, resolvedStandardGradients, resolvedBlankGradientAs,
		resolvedBlankGradientBs, resolvedBlankFlowRates, resolvedBufferA, resolvedBufferB, blankGradientMethodPackets,
		resolvedBlankGradients, resolvedColumnPrimeGradientA, resolvedColumnPrimeGradientB, standardGradientMethodPackets,
		resolvedColumnPrimeFlowRate, analyteGradientMethodPackets, columnPrimeMethodPacket, columnFlushMethodPacket,
		resolvedColumnPrimeGradient, resolvedColumnFlushGradientA, resolvedColumnFlushGradientB, allBufferAs, allBufferBs, allBuffers, allBufferFilteredQ, nonFilteredBufferTests, maxNumBuffers,
		tooManyBufferAsQ, tooManyBufferBsQ, badBufferOptions, tooManyBufferOptions, tooManyBufferTest,
		resolvedColumnFlushFlowRate, resolvedColumnFlushGradient,flowInjectionPurgeCycleConflictOptions, flowInjectionPurgeCycleConflictTest,
		gradientStartEndSpecifiedAdverselyQ, gradientStartEndSpecifiedAdverselyOptions, gradientStartEndSpecifiedAdverselyTest,
		gradientInjectionTableSpecifiedDifferentlyOptionsBool, gradientInjectionTableSpecifiedDifferentlyQ, gradientInjectionTableSpecifiedDifferentlyOptions,
		gradientInjectionTableSpecifiedDifferentlyTest, invalidGradientCompositionOptionsBool, invalidGradientCompositionEverythingQ, invalidGradientCompositionOptions, invalidGradientCompositionTest,
		injectionTableSampleInjectionVolumes,avantButNoAutosamplerQs, validAvantContainerModelsLimits, injectionTableSampleInjectionTypes,
		maxInjectionVolume, autosamplerDeadVolume, resolvedInjectionVolumes, invalidFractionCollectionTemperatureQ, invalidFractionCollectionTemperatureOptions, invalidFractionCollectionTemperatureTest,
		injectionTableStandardInjectionVolumes, resolvedStandardInjectionVolumes, injectionTableBlankInjectionVolumes, resolvedBlankInjectionVolumes,
		specifiedStandardInjectionType, resolvedStandardInjectionType, specifiedBlankInjectionType, resolvedBlankInjectionType,
		resolvedInjectionTable, resolvedEmail, blankBufferAClashQ, blankBufferBClashQ, standardBufferAClashQ, standardBufferBClashQ, compatibleContainers,
		columnPrimeBufferAClashQ, columnPrimeBufferBClashQ, columnFlushBufferAClashQ,specifiedColumnSeparationModes,
		columnFlushBufferBClashQ, defaultStandardBlankContainer,maxLimitEachContainerBool, maxLimitEachContainerQ,
		standardBlankContainerMaxVolume, standardBlankSampleMaxVolume, gatheredStandardInjectionTuples, gatheredBlankInjectionTuples, standardPartitions, blankPartitions,
		standardInjectionVolumeTuples, blankInjectionVolumeTuples, bufferClashWarnings, resolvedInstrumentPacket, resolvedInstrumentModelPacket,
		bufferAClashQ, bufferBClashQ, defaultBlank, resolvedStandardBlankOptions, invalidStandardBlankOptions, invalidStandardBlankTests,
		numberOfStandardBlankContainersRequired, containerCountTest,uniqueContainers, uniqueContainerModels,
		specifiedFractionCollectionTemperature, indexMatchingFractionCollectionOptions, requiredAliquotVolumes, groupedVolumes, validSampleVolumesQ, samplesWithInsufficientVolume, insufficientVolumeTest,
		containerlessInvalidInputs, specifiedInstrument, scale, resolvedInstrument,
		preresolvedAliquotOptions, resolveAliquotOptionTests, resolvedSeparationMode, maxMinFlowRates, minMaxFlowRates, collectFractions,
		testOrNull, warningOrNull, defaultStandard, resolvedColumnPackets, resolvedColumnModelPackets, optimalFlowRateForColumn, minFlowRates, maxFlowRates,
		bufferAClashSpecification, bufferAClashGradientValue, bufferBClashSpecification, bufferBClashGradientValue, blankBufferAClashSpecification, blankBufferAClashGradientValue,
		blankBufferBClashSpecification, blankBufferBClashGradientValue, standardBufferAClashSpecification, standardBufferAClashGradientValue, standardBufferBClashSpecification,
		standardBufferBClashGradientValue, columnPrimeBufferAClashSpecification, columnPrimeBufferAClashGradientValue, columnPrimeBufferBClashSpecification, columnPrimeBufferBClashGradientValue,
		superloopMixedAndMatched, superloopMixedAndMatchedOptions, superloopMixedAndMatchedTest,
		columnFlushBufferAClashSpecification, columnFlushBufferAClashGradientValue, columnFlushBufferBClashSpecification, columnFlushBufferBClashGradientValue,
		allClashSpecifications, allClashGradientValues, allClashOptions, fractionCollectionOptionNames, email, upload, parentProtocol, avant25Q, avant150Q,
		sampleContainerPackets, sampleContainerModel, allInjectionVolumes, allInjectionTypes, targetAliquotContainers, resolvedConsolidateAliquots, resolvedInjectionVolumesNotRounded,
		fractionCollectionMethod, fractionCollectionPackets, resolvedFractionCollectionMode, fractionCollectionStartTimes, fractionCollectionEndTimes,
		invalidFractionCollectionEndTimeBools, fractionCollectionEndTimeOptions, fractionCollectionEndTimeTest, maxFractionVolumes, maxFractionPeriods, absoluteThresholds,
		peakSlopes, peakMinimumDurations, peakEndThresholds, usingAvantAutosamplerQs, maxAllowedSamples, containersOrPair, numSampleContainers, specifiedSampleTemperature,
		invalidContainerCountQ, numReplicates, expandedSimulatedSamplePackets, containerCountOptions, noCollectionSpecifiedOptions, noCollectionSpecifiedTest,
		invalidSampleTemperatureQ, invalidSampleTemperatureOptions, invalidSampleTemperatureTest, columnMaxFlowRate, overMaxFlowRateQ, optionsAboveMaxFlowRate,
		overMaxFlowRateOptions, overMaxFlowRateTest, instrumentMaxFlowRate, actualMaxFlowRate, valuesOverMaxFlowRate, possibleDetectors, resolvedDetectors,
		notAllowedDetectors, notAllowedDetectorsOptions, notAllowedDetectorsTest, specifiedWavelength, resolvedWavelength, maxNumWavelengths,
		tooManyWavelengthsQ, tooManyWavelengthsOptions, tooManyWavelengthsTest, wrongWavelengthQ, wrongWavelengthOptions, wrongWavelengthTest, overMaxFractionVolumeQ,
		overMaxFractionVolumeOptions, overMaxFractionVolumeTest, fractionCollectionMethodTemperatures, resolvedFractionCollectionTemperature,
		resolvedInjectionTableBlanks, resolvedInjectionTableBlankInjectionVolumes, resolvedInjectionTableBlankGradients, resolvedInjectionTableStandards,
		injectionTableStandardInjectionTypes, injectionTableBlankInjectionTypes, resolvedInjectionTableBlankInjectionTypes,
		resolvedInjectionTableStandardInjectionTypes, injectionVolumeAutosamplerIncompatible, injectionVolumeFlowInjectionIncompatible, injectionVolumeSuperloopIncompatible,
		resolvedInjectionTableStandardInjectionVolumes, resolvedInjectionTableStandardGradients, injectionVolumesAutosamplerIncompatibleOptions,
		injectionVolumesFlowInjectionIncompatibleOptions, injectionVolumesSuperloopIncompatibleOptions,
		injectionVolumesIncompatibleTest, conflictingPeakSlopeOptions, conflictingFractionCollectionOptions, conductivityThresholdNotSupportedOptions, conflictingPeakSlopeTest,
		conflictingFractionCollectionTest, conductivityThresholdNotSupportedTest, agreeingPeakSlopeQs, conflictingFractionCollectionQs,
		oldAktaIncompatibleThresholdOptions, specifiedFractionCollectionMode, specifiedAbsoluteThreshold, specifiedPeakSlope, specifiedPeakMinimumDuration,
		specifiedPeakEndThreshold, specifiedMaxCollectionPeriod, columnPrimeNullOutQ, columnFlushNullOutQ, standardConflictOptions, standardConflictQ,
		invalidStandardConflictOptions, standardConflictTest, blankConflictOptions, blankConflictQ, invalidBlankConflictOptions, blankConflictTest,
		columnPrimeSetOptions, columnFlushSetOptions, columnPrimeOptionInjectionTableOptions, columnPrimeOptionInjectionTableTest, columnFlushOptionInjectionTableOptions,
		columnFlushOptionInjectionTableTest, resolvedInjectionTableResult, invalidInjectionTableOptions, invalidInjectionTableTests,
		sampleAnalytes, analyteTypes,maxGradientTimeLimit, maxTimesSamples, maxTimesStandards, maxTimesBlanks, maxTimeColumnPrime, maxTimeColumnFlush,
		maxTimeSampleQ, maxTimeStandardQ, maxTimeBlankQ, maxTimeColumnPrimeQ, maxTimeColumnFlushQ, tooLongQ, tooLongOptions, tooLongTest,
		reverseDirectionConflictBools, reverseDirectionConflictQ, reverseDirectionConflictOptions, reverseDirectionTest,
		allSpecifiedFlowRates, maxSpecifiedFlowRate, conflictingFractionQs, conflictingFractionOptions, conflictingFractionTest,overwriteOptionBool,
		combinedStandardsBlanks, standardBlankContainers, standardsBlanksOutsideContainerQ, standardsBlanksOutsideContainerOptions, standardsBlanksOutsideContainerTest,
		overwriteGradientsBool, overwriteStandardGradientsBool, overwriteBlankGradientsBool, overwriteColumnPrimeGradientBool, overwriteColumnFlushGradientBool,
		shownGradients, shownStandardGradients, shownBlankGradients, shownColumnPrimeGradient, shownColumnFlushGradient, shownColumnPrimeGradientList, shownColumnFlushGradientList,
		resolvedBufferC, resolvedBufferD,
		columnPrimeBufferCClashQ, columnPrimeBufferDClashQ, columnFlushBufferCClashQ, columnFlushBufferDClashQ,
		bufferCClashSpecification, bufferCClashGradientValue, bufferDClashSpecification, bufferDClashGradientValue, blankBufferCClashSpecification,
		blankBufferCClashGradientValue, blankBufferDClashSpecification, blankBufferDClashGradientValue, standardBufferCClashSpecification,
		standardBufferCClashGradientValue, standardBufferDClashSpecification, standardBufferDClashGradientValue, columnPrimeBufferCClashSpecification,
		columnPrimeBufferCClashGradientValue, columnPrimeBufferDClashSpecification, columnPrimeBufferDClashGradientValue, columnFlushBufferCClashSpecification,
		columnFlushBufferCClashGradientValue, columnFlushBufferDClashSpecification, columnFlushBufferDClashGradientValue,
		resolvedGradientCs, resolvedGradientDs, nonbinaryGradientBool, resolvedStandardGradientCs, resolvedStandardGradientDs, nonbinaryStandardGradientBool,
		resolvedBlankGradientCs, resolvedBlankGradientDs, nonbinaryBlankGradientBool, resolvedColumnPrimeGradientC, resolvedColumnPrimeGradientD,
		resolvedColumnFlushGradientC, resolvedColumnFlushGradientD,nonbinaryColumnPrimeGradientQ, nonbinaryColumnFlushGradientQ,
		nonBinaryOptionBool, nonBinaryOptionQ, nonBinaryOptions, nonBinaryGradientTest,sampleLoopShouldBe, resolvedSampleLoopVolume,
		loopInjectionConflictOptions, loopInjectionConflictTest,restrictedFeaturesForAKTA10, restrictedFeaturesOptions, restrictedFeaturesTest, totalDeadVolumes, sampleDeadVolumes,
		akta10Q, flowCellLookup, acceptableFlowCells, resolvedFlowCell, flowCellNearestTest, removedExtraBool,removedExtraStandardBool,
		removedExtraBlankBool, removedExtraColumnPrimeGradientQ, removedExtraColumnFlushGradientQ,
		gradientShortcutConflictBool, gradientStartEndBConflictBool, standardGradientShortcutConflictBool, standardGradientStartEndBConflictBool, blankGradientShortcutConflictBool, blankGradientStartEndBConflictBool, columnPrimeGradientShortcutConflictBool, columnPrimeGradientStartEndBConflictBool, 			columnFlushGradientShortcutConflictBool, columnFlushGradientStartEndBConflictBool,
		resolvedStandardFlowDirection, resolvedBlankFlowDirection, resolvedColumnPrimeFlowDirection, resolvedColumnFlushFlowDirection,
		gradientShortcutOverallBool, gradientShortcutOverallQ, gradientShortcutOptions, gradientShortcutTest, gradientStartEndBConflictOverallBool, gradientStartEndBConflictOverallQ, gradientStartEndBConflictTests,
		allMethodPackets, removedExtraOptionBool, removedExtraOptionQ, removedExtraOptions, removedExtraTest, resolvedSampleFlowRates,
		sampleFlowRateConflictQs, sampleFlowRateConflictOptions, sampleFlowRateConflictTest, resolvedStandardGradientEs,
		resolvedStandardGradientFs, resolvedStandardGradientGs, resolvedStandardGradientHs, resolvedBlankGradientEs, allTupledGradients,
		resolvedBlankGradientFs, resolvedBlankGradientGs, resolvedBlankGradientHs, resolvedColumnPrimeGradientE, resolvedColumnPrimeGradientF,
		resolvedColumnPrimeGradientG, resolvedColumnPrimeGradientH, columnPrimeGradientStartEndSpecifiedQ, resolvedColumnFlushGradientE,
		resolvedColumnFlushGradientF, resolvedColumnFlushGradientG, resolvedColumnFlushGradientH, columnFlushGradientStartEndSpecifiedQ,
		standardGradientStartEndSpecifiedBool, blankGradientStartEndSpecifiedBool, gradientStartEndCheckingBool,
		totaledGradient, gradientCQ, gradientDQ, gradientEQ, gradientFQ, gradientGQ, gradientHQ,
		resolvedBufferE, resolvedBufferF, resolvedBufferG, resolvedBufferH,resolvedGradientEs, resolvedGradientFs, resolvedGradientGs,
		resolvedGradientHs, bufferAClashBool, bufferBClashBool, bufferCClashBool, bufferDClashBool, bufferEClashBool, bufferFClashBool,
		bufferGClashBool, bufferHClashBool, bufferEClashGradientValue, bufferFClashGradientValue, bufferGClashGradientValue,
		bufferHClashGradientValue, blankBufferEClashGradientValue, blankBufferFClashGradientValue, blankBufferGClashGradientValue,
		blankBufferHClashGradientValue, standardBufferEClashGradientValue, standardBufferFClashGradientValue, standardBufferGClashGradientValue,
		standardBufferHClashGradientValue, columnPrimeBufferEClashGradientValue, columnPrimeBufferFClashGradientValue, columnPrimeBufferGClashGradientValue,
		columnPrimeBufferHClashGradientValue, columnFlushBufferEClashGradientValue, columnFlushBufferFClashGradientValue, columnFlushBufferGClashGradientValue,
		columnFlushBufferHClashGradientValue,standardBufferAClashBool, standardBufferBClashBool, standardBufferCClashBool, standardBufferDClashBool,
		standardBufferEClashBool, standardBufferFClashBool, standardBufferGClashBool, standardBufferHClashBool,
		blankBufferAClashBool, blankBufferBClashBool, blankBufferCClashBool, blankBufferDClashBool, blankBufferEClashBool,
		blankBufferFClashBool, blankBufferGClashBool, blankBufferHClashBool, columnPrimeBufferEClashQ, columnPrimeBufferFClashQ, columnPrimeBufferGClashQ,
		columnPrimeBufferHClashQ, columnFlushBufferEClashQ, columnFlushBufferFClashQ, columnFlushBufferGClashQ, columnFlushBufferHClashQ,
		anySingletonGradientsBool, anySingletonGradientOptions, anySingletonGradientTest, resolvedPumpDisconnectOnFullGradientChangePurgeVolume,
		gradientPurgeConflictQ, gradientPurgeConflictOptions, mixerVolumeLookup, availableMixers, acceptableMixerVolumes,
		defaultMixerVolume, resolvedMixerVolume, mixerNearestTest,defaultAutosamplerContainer,incompatibleContainerQ,incompatibleContainerList,
		incompatibleContainerTest,specifiedAliquotContainer,incompatibleContainerCheck,incompatibleContainerSamples,incompatibleContainerInput,
		completeContainerModelLimits,nonDefaultContainers,targetContainerPacket, currentDeadVolume,
		samplesInStorage, validContainerStorageConditionBool, validContainerStorageConditionTests, validContainerStoragConditionInvalidOptions,
		maxPressureForEachColumn, resolvedColumnMaxPressure, samplePositions, standardPositions, blankPositions, columnPrimePositions,
		columnFlushPositions, standardGradientsMatchingIT, blankGradientsMatchingIT, columnPrimeGradientsMatchingIT, columnFlushGradientsMatchingIT,
		injectionTableGradientRules, gradientReequilibratedBool, initialSampleGradientComposition, previousGradient, finalGradientDeltaDuration,
		finalGradientComposition, gradientReequilibratedQ, gradientReequilibratedWarning, injectionTableScrewedUpQ, roundedInjectionVolumes,
		resolvedStandardPreInjectionEquilibrationTimes,	resolvedBlankPreInjectionEquilibrationTimes,resolvedColumnPrimePreInjectionEquilibrationTime,
		resolvedColumnFlushPreInjectionEquilibrationTime, resolvedBlankSampleLoopDisconnects, resolvedStandardSampleLoopDisconnects, resolvedSampleLoopDisconnects,
		injectionTypeRules, resolvedInjectionTypePattern, sampleLoopDisconnection, sampleLoopDisconnectConflictQ, invalidSampleLoopDisconnectConflictOptions, sampleLoopDisconnectConflictTest,
		sampleLoopDisconnectInstrumentConflicts, sampleLoopDisconnectInstrumentConflictQ, invalidSampleLoopDisconnectInstrumentConflictOptions, sampleLoopDisconnectInstrumentConflictTest,
		autosamplerTotalVolume, autosamplerLowFlushVolumes, autosamplerLowFlushVolumesQ,resolvedStandardInjectionTypePattern,
		standardSampleLoopDisconnection,standardSampleLoopDisconnectConflictQ,invalidStandardSampleLoopDisconnectConflictOptions,
		standardSampleLoopDisconnectConflictTest,resolvedBlankInjectionTypePattern,blankSampleLoopDisconnection, simulation, updatedSimulation, allDownloadValues,
		blankSampleLoopDisconnectConflictQ,invalidBlankSampleLoopDisconnectConflictOptions,blankSampleLoopDisconnectConflictTest
	},

	(*-- SETUP OUR USER SPECIFIED OPTIONS AND CACHE --*)

	(* Determine the requested output format of this function. *)
	outputSpecification = Quiet[OptionDefault[OptionValue[Output]], OptionValue::nodef];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];

	(* Fetch our cache from the parent function. *)
	cache = Lookup[ToList[myResolutionOptions], Cache, {}];
	simulation = Lookup[ToList[myResolutionOptions], Simulation, Simulation[]];

	(* Separate out our FPLC options from our Sample Prep options. *)
	{samplePrepOptions, fplcOptions} = splitPrepOptions[myOptions];

	(* Resolve our sample prep options *)
	{{simulatedSamples, resolvedSamplePrepOptions, updatedSimulation}, samplePrepTests} = If[gatherTests,
		resolveSamplePrepOptionsNew[ExperimentFPLC, mySamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> {Result, Tests}],
		{resolveSamplePrepOptionsNew[ExperimentFPLC, mySamples, samplePrepOptions, Cache -> cache, Simulation -> simulation, Output -> Result], {}}
	];

	(* Download some values that we'll need below *)
	allDownloadValues = Download[
		DeleteDuplicates[Join[mySamples, simulatedSamples]],
		{
			Packet[Status, Container, Model, Volume, Mass, Count, State, Analytes, Composition, Solvent, IncompatibleMaterials],
			Packet[Composition[[All, 2]][ExtinctionCoefficients]],
			Packet[Container[{Model, Name, Contents}]],
			Packet[Container[Model][{Object, Name, Footprint}]]
		},
		Cache -> cache,
		Simulation -> updatedSimulation
	];

	(* get the fastAssoc; having a simulatedCache here helps with ObjectToString below *)
	simulatedCache = FlattenCachePackets[{cache, allDownloadValues}];
	fastAssoc = makeFastAssocFromCache[simulatedCache];

	(* Determine if we should keep a running list of tests *)
	gatherTests = MemberQ[output, Tests];

	(* Determine if we should throw messages *)
	messagesQ = Not[gatherTests];

	(* Determine if we're being executed in Engine *)
	engineQ = MatchQ[$ECLApplication, Engine];

	(* define the functions to generate all the tests *)
	(* note that this requires the sample list to be index matched with the boolean list (and True means Failing) *)
	testOrNull[testDescription_String, allSamples : {ObjectP[]..}, booleanList : {BooleanP..}] := If[gatherTests,
		Module[{failingTest, passingTest, failingSamples, passingSamples, failingString, passingString},

			(* in this case, True means Yes, we are failing *)
			failingSamples = PickList[allSamples, booleanList, True];
			passingSamples = PickList[allSamples, booleanList, False];

			(* get the failing and passing string *)
			failingString = If[MatchQ[failingSamples, {}],
				Null,
				StringReplace[testDescription, "`1`" :> ObjectToString[failingSamples, Cache -> simulatedCache]]
			];
			passingString = If[MatchQ[passingSamples, {}],
				Null,
				StringReplace[testDescription, "`1`" :> ObjectToString[passingSamples, Cache -> simulatedCache]]
			];

			(* create a test for non-passing and passing inputs *)
			failingTest = If[NullQ[failingString],
				Nothing,
				Test[failingString,
					False,
					True
				]
			];
			passingTest = If[NullQ[passingString],
				Nothing,
				Test[passingString,
					True,
					True
				]
			];

			{failingTest, passingTest}
		],
		Nothing
	];


	(* If you have Warning:: messages, do NOT throw them when MatchQ[$ECLApplication,Engine]. Warnings should NOT be surfaced in engine. *)

	(*-- INPUT VALIDATION CHECKS --*)

	(* Extract downloaded mySamples packets *)
	samplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ mySamples;

	(* Fetch simulated samples' cached packets *)
	simulatedSamplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ simulatedSamples;

	(* Extract sample statuses *)
	sampleStatuses = Lookup[samplePackets, Status];

	(* Find any samples that are discarded; also get DiscardedQ for use with the test-making function *)
	discardedSamplePackets = PickList[samplePackets, sampleStatuses, Discarded];
	discardedQ = MatchQ[#, Discarded]& /@ sampleStatuses;

	(* If there are any invalid inputs and we are throwing messages, throw an error message and keep track of the invalid inputs *)
	discardedInvalidInputs = If[MatchQ[discardedSamplePackets, {PacketP[]..}] && messagesQ,
		(
			Message[Error::DiscardedSamples, Lookup[discardedSamplePackets, Object, {}]];
			Lookup[discardedSamplePackets, Object, {}]
		),
		Lookup[discardedSamplePackets, Object, {}]
	];

	(* Test that all samples are in a container *)
	discardedSamplePacketsTest = testOrNull["Provided input samples `1` are not discarded:", samplePackets, discardedQ];

	(* Extract containers *)
	sampleContainers = Download[Lookup[samplePackets, Container], Object];

	(* Extract simulated sample containers *)
	simulatedSampleContainers = Download[Lookup[simulatedSamplePackets, Container], Object];

	(* Find simulated container models *)
	simulatedSampleContainerModels = Map[
		If[NullQ[#],
			Null,
			Download[Lookup[fetchPacketFromFastAssoc[#, fastAssoc], Model], Object]
		]&,
		simulatedSampleContainers
	];

	(* get whether a given sample is containerless *)
	containerlessSamples = PickList[mySamples, sampleContainers, Null];
	containerlessQ = NullQ[#]& /@ sampleContainers;

	(* Test that all samples are in a container *)
	containersExistTest = testOrNull["Provided input samples `1` are in containers:", samplePackets, containerlessQ];

	(* If a sample is not in a container, throw error *)
	containerlessInvalidInputs = If[messagesQ && Length[containerlessSamples] > 0,
		(
			Message[Error::ContainerlessSamples, ObjectToString[containerlessSamples, Cache -> simulatedCache]];
			containerlessSamples
		),
		containerlessSamples
	];

	(* pull out the specified name to start *)
	name = Lookup[fplcOptions, Name];

	(* If the specified Name is not in the database, it is valid *)
	validNameQ = If[MatchQ[name, _String],
		Not[DatabaseMemberQ[Object[Protocol, FPLC, name]]],
		True
	];

	(* if validNameQ is False AND we are throwing messages (or, equivalently, not gathering tests), then throw the message and make nameInvalidOptions = {Name}; otherwise, {} is fine *)
	nameInvalidOptions = If[Not[validNameQ] && messagesQ,
		(
			Message[Error::DuplicateName, "FPLC protocol"];
			{Name}
		),
		{}
	];

	(* Generate Test for Name check *)
	validNameTest = If[gatherTests && MatchQ[name, _String],
		Test["If specified, Name is not already an FPLC object name:",
			validNameQ,
			True
		],
		Null
	];

	(* pull out the specified instrument and scale options *)
	specifiedInstrument = Lookup[fplcOptions, Instrument];
	scale = Lookup[fplcOptions, Scale];

	(*check to see if we have high flow rates*)
	allSpecifiedFlowRates=Cases[Flatten@Values[fplcOptions],GreaterP[0 Milliliter/Minute]];

	(*we add a dummy if we have an empty list*)
	maxSpecifiedFlowRate=Max[Append[allSpecifiedFlowRates,1 Milliliter/Minute]];

	(* resolve the instrument option; if we're doing Analytical it will be the avant 25, or if Preparative it will be the avant 150 *)
	resolvedInstrument = Which[
		!MatchQ[specifiedInstrument, Automatic],specifiedInstrument,
		MatchQ[maxSpecifiedFlowRate,GreaterP[25 Milliliter/Minute]], Model[Instrument, FPLC, "AKTA avant 150"],
		MatchQ[scale, Analytical], Model[Instrument, FPLC, "AKTA avant 25"],
		MatchQ[scale, Preparative], Model[Instrument, FPLC, "AKTA avant 150"],
		(* TODO allow it to resolve to the 150 again once the shelves are working *)
		True, Model[Instrument, FPLC, "AKTA avant 25"]
	];

	(* get the resolved instrument model packet *)
	resolvedInstrumentPacket = fetchPacketFromFastAssoc[Download[resolvedInstrument, Object], fastAssoc];
	resolvedInstrumentModelPacket = If[MatchQ[resolvedInstrumentPacket, PacketP[Object[Instrument, FPLC]]],
		fetchPacketFromFastAssoc[Download[Lookup[resolvedInstrumentPacket, Model], Object], fastAssoc],
		resolvedInstrumentPacket
	];

	(* make Q variables for if we're using the avant 150 or avant 25*)
	avant25Q = MatchQ[resolvedInstrumentModelPacket, ObjectP[Model[Instrument, FPLC, "AKTA avant 25"]]];
	avant150Q = MatchQ[resolvedInstrumentModelPacket, ObjectP[Model[Instrument, FPLC, "AKTA avant 150"]]];

	(* pull out the possible detectors for the resolved instrument *)
	possibleDetectors = Lookup[resolvedInstrumentModelPacket, Detectors];

	(* resolve the Detector option; if Automatic, resolve to all the detectors the instrument has *)
	resolvedDetectors = If[MatchQ[Lookup[fplcOptions, Detector], Automatic],
		possibleDetectors,
		Lookup[fplcOptions, Detector]
	];

	(* find the not-allowed detectors *)
	notAllowedDetectors = DeleteCases[ToList[resolvedDetectors], Alternatives @@ possibleDetectors];

	(* if we have any not-allowed detectors, throw an error *)
	notAllowedDetectorsOptions = If[messagesQ && Not[MatchQ[notAllowedDetectors, {}]],
		(
			Message[Error::InstrumentDoesNotContainDetector, ObjectToString[notAllowedDetectors, Cache->simulatedCache], ObjectToString[resolvedInstrument, Cache->simulatedCache]];
			{Detector, Instrument}
		),
		{}
	];

	(* make a test for ensuring the instruments have the appropriate detectors *)
	notAllowedDetectorsTest = If[gatherTests,
		Test["The specified Detectors match those that are available for the specified instrument:",
			MatchQ[notAllowedDetectors, {}],
			True
		],
		Nothing
	];

	(*get the flow cell*)
	flowCellLookup=Lookup[fplcOptions, FlowCell];

	(*get the closest acceptable one to the specification*)
	acceptableFlowCells=If[avant25Q||avant150Q,
		{0.5 Millimeter, 2 Millimeter, 10 Millimeter},
		{2 Millimeter}
	];
	resolvedFlowCell=First@Nearest[acceptableFlowCells,flowCellLookup];

	(*throw a warning if we had to round*)
	If[Abs[resolvedFlowCell-flowCellLookup]>0 Millimeter&&messagesQ,
		Message[Warning::FlowCellChangedToNearest,flowCellLookup,acceptableFlowCells,resolvedFlowCell]
	];

	flowCellNearestTest=If[gatherTests,
		Warning["The FlowCell if specified, is available for the Instrument:",
			Abs[resolvedFlowCell-flowCellLookup]>0 Millimeter,
			False
		],
		Nothing
	];

	(*resolve the mixer volume*)
	mixerVolumeLookup=Lookup[fplcOptions, MixerVolume];

	(*get the available mixers for this instrument*)
	availableMixers=Cases[Lookup[resolvedInstrumentModelPacket,AssociatedAccessories][[All,1]][Object],ObjectP[Model[Part,Mixer]]];

	(*look up the acceptable volumes from associated accessories. add 0 a an option*)
	acceptableMixerVolumes=Prepend[Map[
		Lookup[fetchPacketFromFastAssoc[#,fastAssoc],Volume]&,
		availableMixers
	],0 Milliliter];

	(*get the default mixer volume*)
	defaultMixerVolume=Lookup[fetchPacketFromFastAssoc[Lookup[resolvedInstrumentModelPacket,DefaultMixer],fastAssoc],Volume];

	resolvedMixerVolume=If[MatchQ[mixerVolumeLookup,Automatic],
		defaultMixerVolume,
		First@Nearest[acceptableMixerVolumes,mixerVolumeLookup]
	];

	(*throw a warning if we had to round*)
	If[MatchQ[mixerVolumeLookup,UnitsP[0 Milliliter]], If[Abs[resolvedMixerVolume-mixerVolumeLookup]>0 Milliliter&&messagesQ,
		Message[Warning::MixerChangedToNearest,mixerVolumeLookup,acceptableMixerVolumes,resolvedMixerVolume]
	]];

	mixerNearestTest=If[gatherTests,
		Warning["The MixerVolume if specified, is available for the Instrument:",
			If[MatchQ[flowCellLookup,UnitsP[0 Milliliter]], Abs[resolvedFlowCell-flowCellLookup]>0 Millimeter, False],
			False
		],
		Nothing
	];

	(* Get the analyte types *)
	sampleAnalytes=Quiet[Experiment`Private`selectAnalyteFromSample[samplePackets], Warning::AmbiguousAnalyte];

	(*get all of the analyte types*)
	analyteTypes=DeleteDuplicates@Flatten@Map[
		Function[{analyte},
			Switch[analyte,
				ObjectP[Model[Molecule,Oligomer]],Lookup[fetchPacketFromFastAssoc[analyte,fastAssoc],PolymerType],
				(*otherwise, presumed to just be a molecule*)
				_,Molecule
			]
		],sampleAnalytes];

	(* figure out the wavelengths we want to use *)
	(* if we're using the old akta, automatically choose 254 Nanometer since it can only pick one and only 254 or 280 *)
	(* otherwise, pick 280 and 260 *)
	specifiedWavelength = Lookup[fplcOptions, Wavelength];
	resolvedWavelength = Which[
		MatchQ[specifiedWavelength, ListableP[UnitsP[Nanometer]]], specifiedWavelength,
		MatchQ[resolvedInstrumentModelPacket, ObjectP[Model[Instrument, FPLC, "AKTApurifier UPC 10"]]], 254 Nanometer,
		IntersectingQ[analyteTypes,{DNA,PNA,Peptide}],{260 Nanometer, 280 Nanometer},
		True, {280 Nanometer, 260 Nanometer}
	];

	(* decide the max number of wavelengths allowed (one for the old AKTA, three for the avants) *)
	maxNumWavelengths = If[MatchQ[resolvedInstrumentModelPacket, ObjectP[Model[Instrument, FPLC, "AKTApurifier UPC 10"]]],
		1,
		3
	];

	(* figure out if we have too many wavelengths specified *)
	(* If we have a list of wavelengths and there are more than three, or more than one on the old AKTA, then we have too many wavelengths *)
	tooManyWavelengthsQ = MatchQ[resolvedWavelength, {UnitsP[Nanometer]..}] && Length[resolvedWavelength] > maxNumWavelengths;

	(* throw an error if we have too many wavelengths *)
	tooManyWavelengthsOptions = If[messagesQ && tooManyWavelengthsQ,
		(
			Message[Error::TooManyWavelengths, resolvedWavelength, resolvedInstrument, maxNumWavelengths];
			{Instrument, Wavelength}
		),
		{}
	];


	(* make a test for if there are too many wavelengths *)
	tooManyWavelengthsTest = If[gatherTests,
		Test["There are no more than " <> ToString[maxNumWavelengths] <> " wavelengths specified in the Wavelength option:",
			tooManyWavelengthsQ,
			False
		]
	];

	(* if using the old AKTA, wavelength can only be 254 Nanometer or 280 Nanometer (or the lists of length 1 for that value).  Using EqualP here since technically the user could specify 254.0 Nanometer and MatchQ would return False*)
	wrongWavelengthQ = And[
		MatchQ[resolvedInstrumentModelPacket, ObjectP[Model[Instrument, FPLC, "AKTApurifier UPC 10"]]],
		Not[MatchQ[resolvedWavelength, EqualP[254 Nanometer] | EqualP[280 Nanometer] | EqualP[{254 Nanometer}] | EqualP[{280 Nanometer}]]]
	];

	(* throw an error if the wavelength is not supported *)
	wrongWavelengthOptions = If[messagesQ && wrongWavelengthQ,
		(
			Message[Error::UnsupportedWavelength, resolvedWavelength, resolvedInstrument];
			{Instrument, Wavelength}
		),
		{}
	];

	(* make a test for if the wavelength is not supported *)
	wrongWavelengthTest = If[gatherTests,
		Test["If Instrument -> Model[Instrument, FPLC, \"AKTApurifier UPC 10\"], Wavelength is either 254 Nanometer or 280 Nanometer:",
			wrongWavelengthQ,
			False
		],
		Nothing
	];

	(*get boolean for which sample/instrument combinations are incompatible (based on material). *)
	{incompatibleBool, incompatibleSamplesTest} = If[gatherTests,
		CompatibleMaterialsQ[resolvedInstrument, simulatedSamplePackets, Cache -> cache, Simulation -> updatedSimulation, Output -> {Result, Tests}],
		{CompatibleMaterialsQ[resolvedInstrument, simulatedSamplePackets, Cache -> cache, Simulation -> updatedSimulation, Output -> Result], Null}
	];

	(* pull out the specified column value *)
	specifiedColumn = Lookup[fplcOptions, Column];

	(* Fetch column packet if specified *)
	specifiedColumnPackets = If[MatchQ[specifiedColumn, ListableP[ObjectP[]]],
		fetchPacketFromFastAssoc[#, fastAssoc]& /@ ToList[specifiedColumn],
		{Null}
	];

	(* get the  model packet if applicable *)
	specifiedColumnModelPackets = Map[
		If[MatchQ[#, PacketP[Object[Item, Column]]],
			fetchPacketFromFastAssoc[Download[Lookup[#, Model], Object], fastAssoc],
			#
		]&,
		specifiedColumnPackets
	];

	(* - Column's ChromatographyType Check - *)

	(* If a column object is specified, fetch its ChromatographyType *)
	{specifiedColumnTypes,specifiedColumnSeparationModes} = Transpose[If[!NullQ[#],
		Lookup[#, {ChromatographyType,SeparationMode}],
		{Null,Null}
	]& /@ specifiedColumnModelPackets];

	(* pull out the specified chromatography type *)
	specifiedSeparationMode = Lookup[fplcOptions, SeparationMode];

	(* If Type and a column are specified, the column type should match the type of column *)
	typeColumnCompatibleQ = If[MatchQ[specifiedSeparationMode, ChromatographyTypeP] && MatchQ[specifiedColumnTypes, {ChromatographyTypeP..}],
		MatchQ[specifiedColumnTypes, {specifiedSeparationMode..}],
		True
	];

	(* Build test for Column-SeparationMode compatibility  *)
	typeColumnTest = If[gatherTests,
		Warning["If SeparationMode and Column are specified, the separation mode of the column(s) are the same as the specified SeparationMode:",
			typeColumnCompatibleQ,
			True
		],
		Nothing
	];

	(* Throw warning if SeparationMode and Column are incompatible *)
	If[messagesQ && !typeColumnCompatibleQ && !engineQ,
		Message[Warning::IncompatibleColumnType, Column, ObjectToString[specifiedColumn, Cache -> simulatedCache], specifiedColumnTypes, specifiedSeparationMode];
	];

	(* If a column object is specified, fetch its ChromatographyType *)
	specifiedColumnTechniques = If[!NullQ[#],
		Lookup[#, ChromatographyType, Null],
		Null
	]& /@ specifiedColumnModelPackets;

	(* Column technique should be FPLC or Null *)
	columnTechniqueCompatibleQ = MatchQ[specifiedColumnTechniques, {(FPLC | Null)..}];

	(* Build test for technique compatibility  *)
	columnTechniqueTest = Test["If Column is specified, its ChromatographyType is FPLC:",
		columnTechniqueCompatibleQ,
		True
	];

	(* Throw warning if technique is not FPLC *)
	incompatibleColumnTechniqueOptions = If[messagesQ && !columnTechniqueCompatibleQ,
		(
			Message[Error::IncompatibleColumnTechnique, Column, ObjectToString[specifiedColumn, Cache -> simulatedCache], specifiedColumnTechniques, FPLC];
			{Column}
		),
		{}
	];

	(*-- OPTION PRECISION CHECKS --*)

	(*we have to break apart our options so that it's easier to tackle this part*)

	(*get the injection table option and see if need consider the suboptions within it*)
	injectionTableLookup = Lookup[fplcOptions, InjectionTable, Null];

	(*is the injection specified (meaning that it has tuples within it)?*)
	injectionTableSpecifiedQ = MatchQ[injectionTableLookup, Except[Automatic | Null]];

	(* get the samples that are in the injection table, and the input sample objects *)
	injectionTableSamples = If[injectionTableSpecifiedQ,
		Download[Cases[injectionTableLookup, {Sample, sampleObj : ObjectP[], ___} :> sampleObj], Object, Cache -> cache],
		Null
	];
	inputSampleObjs = Download[mySamples, Object, Cache -> cache];

	(*we need to make sure that if the injection table is specified that the samples and the input are compatible*)
	injectionTableSampleConflictQ = If[injectionTableSpecifiedQ,
		(*check first if they're the same length. that's already bad*)
		If[Length[ToList[mySamples]]==Count[injectionTableLookup,{Sample,___}],
			Not[
				And@@MapThread[
					Function[{injectionTableSample,inputSample},
						MatchQ[injectionTableSample,Automatic|ObjectP[Download[inputSample,Object]]]
					],
					{
						Cases[injectionTableLookup,{Sample,___}]/.{Sample,x_,___}:>x,
						Download[ToList[mySamples],Object,Cache->cache]
					}
				]
			],
			True
		],
		False
	];

	(* All options that specify gradients *)
	gradientOptions = {
		Gradient,
		GradientA,
		GradientB,
		GradientC,
		GradientD,
		GradientE,
		GradientF,
		GradientG,
		GradientH,
		GradientStart,
		GradientEnd,
		FlowRate,
		GradientDuration,
		EquilibrationTime,
		FlushTime,

		StandardGradient,
		StandardGradientA,
		StandardGradientB,
		StandardGradientC,
		StandardGradientD,
		StandardGradientE,
		StandardGradientF,
		StandardGradientG,
		StandardGradientH,
		StandardGradientStart,
		StandardGradientEnd,
		StandardGradientDuration,
		StandardFlowRate,

		BlankGradient,
		BlankGradientA,
		BlankGradientB,
		BlankGradientC,
		BlankGradientD,
		BlankGradientE,
		BlankGradientF,
		BlankGradientG,
		BlankGradientH,
		BlankGradientStart,
		BlankGradientEnd,
		BlankGradientDuration,
		BlankFlowRate,

		ColumnPrimeGradient,
		ColumnPrimeGradientA,
		ColumnPrimeGradientB,
		ColumnPrimeGradientC,
		ColumnPrimeGradientD,
		ColumnPrimeGradientE,
		ColumnPrimeGradientF,
		ColumnPrimeGradientG,
		ColumnPrimeGradientH,
		ColumnPrimeStart,
		ColumnPrimeEnd,
		ColumnPrimeDuration,
		ColumnPrimeFlowRate,

		ColumnFlushGradient,
		ColumnFlushGradientA,
		ColumnFlushGradientB,
		ColumnFlushGradientC,
		ColumnFlushGradientD,
		ColumnPrimeGradientE,
		ColumnPrimeGradientF,
		ColumnPrimeGradientG,
		ColumnPrimeGradientH,
		ColumnFlushStart,
		ColumnFlushEnd,
		ColumnFlushDuration,
		ColumnFlushFlowRate
	};

	(*determine the flow rate precision that we want to achieve*)
	flowRatePrecision=Which[
		avant25Q,10^-3 Milliliter/Minute,
		avant150Q,10^-2 Milliliter/Minute,
		True,10^-1 Milliliter/Minute
	];

	(*use the helper function to round all of the gradient options collectively*)
	{roundedGradientOptions, roundedGradientTests} = Experiment`Private`roundGradientOptions[gradientOptions, Association[fplcOptions], gatherTests,
		FlowRatePrecision->flowRatePrecision,
		TimePrecision -> 1 Second
	];

	(* Options which need to be rounded *)
	optionsToRound = {
		SampleLoopVolume,
		InjectionVolume,
		StandardInjectionVolume,
		BlankInjectionVolume,
		Wavelength,
		SampleTemperature,
		FractionCollectionTemperature,
		FractionCollectionStartTime,
		FractionCollectionEndTime,
		MaxFractionVolume,
		MaxCollectionPeriod,
		PeakMinimumDuration,
		PreInjectionEquilibrationTime,
		SampleLoopDisconnect
	};

	(* values to round to *)
	valuesToRoundTo = {
		(*SampleLoopVolume*)
		10^0 Microliter,

		(* InjectionVolume/StandardInjectionVolume/BlankInjectionVolume *)
		10^0 Microliter,
		10^0 Microliter,
		10^0 Microliter,

		(* Wavelength *)
		10^0 Nanometer,

		(* SampleTemperature/FractionCollectionTemperature *)
		10^-1 Celsius,
		10^-1 Celsius,

		(* FractionCollectionStartTime/FractionCollectionEndTime *)
		10^0 Second,
		10^0 Second,

		(* MaxFractionVolume/MaxCollectionPeriod *)
		10^-1 Microliter,
		1 Second,

		(* PeakMinimumDuration *)
		10^-2 Minute,
		10^-2 Minute,

		(* Sample loop disconnect volume *)
		10^0 Microliter

	};

	(* Fetch association with volumes rounded *)
	{nonGradientRoundedOptions, nonGradientRoundingTests} = If[gatherTests,
		RoundOptionPrecision[Association[fplcOptions], optionsToRound, valuesToRoundTo, Output -> {Result, Tests}],
		{RoundOptionPrecision[Association[fplcOptions], optionsToRound, valuesToRoundTo], {}}
	];

	(* Join all rounded associations together, with rounded values overwriting existing values *)
	roundedOptionsAssociation = Join[
		Association[fplcOptions],
		nonGradientRoundedOptions,
		roundedGradientOptions,
		(* putting this here because going to need this below and that is the only option I've resolved above (since I wanted to do it before the CompatibleMaterialsQ check *)
		<|Instrument -> resolvedInstrument|>
	];

	(* Join all tests together *)
	allRoundingTests = Flatten[{roundedGradientTests, nonGradientRoundingTests}];

	(*-- CONFLICTING OPTIONS CHECKS --*)

	(*-- RESOLVE EXPERIMENT OPTIONS --*)

	(* Resolve SeparationMode based on resolved column types *)
	resolvedSeparationMode = Which[
		MatchQ[specifiedSeparationMode, SeparationModeP], specifiedSeparationMode,
		(* If a column is specified and it has a SeparationMode, use the first column's type; otherwise resolve to SizeExclusion *)
		MatchQ[FirstOrDefault[specifiedColumnSeparationModes], SeparationModeP], FirstOrDefault[specifiedColumnSeparationModes],
		True, SizeExclusion
	];

	(* Attempt to resolve Column. If Column is specified, use option value, Otherwise, resolve from SeparationMode. *)
	(* TODO this probably is going to want to be way more complicated once we actually have the high-flow-rate-columns (i.e., resolve based also on flow rate) *)
	resolvedColumn = Which[
		MatchQ[specifiedColumn, ListableP[ObjectP[{Object[Item, Column], Model[Item, Column]}]]], specifiedColumn,
		(*
		MatchQ[maxSpecifiedFlowRate,GreaterP[25 Milliliter/Minute]],Model[Item, Column, "id:R8e1PjpK5a0n"], *)(*Tricorn -- NOTE: this is a temporary solution and should be changed*)(*
		*)
		MatchQ[resolvedSeparationMode, SizeExclusion], Model[Item, Column, "id:1ZA60vwjbbm5"], (* HiTrap 5x5mL Desalting Column *)
		MatchQ[resolvedSeparationMode, IonExchange], Model[Item, Column, "id:o1k9jAGmWnjx"], (* HiTrap Q HP 5x5mL Column *)
		True, Null (* TODO throw an error if we get into this state, that we don't have a column that supports the specified options *)
	];

	(* get the resolved column model packets so that we can get the proper flow rate information *)
	resolvedColumnPackets = Map[
		fetchPacketFromFastAssoc[Download[#, Object], fastAssoc]&,
		ToList[resolvedColumn]
	];
	resolvedColumnModelPackets = Map[
		If[MatchQ[#, PacketP[Model[Item, Column]]],
			#,
			fetchPacketFromFastAssoc[Download[Lookup[#, Model], Object], fastAssoc]
		]&,
		resolvedColumnPackets
	];

	(*now resolve the maximum pressure across the column. for any Nulls, we just have a placeholder*)
	maxPressureForEachColumn = Lookup[resolvedColumnModelPackets,MaxPressure]/.{Null->2.4 Megapascal};

	resolvedColumnMaxPressure= If[
		MatchQ[Lookup[fplcOptions, MaxColumnPressure], Except[Automatic]],
		Lookup[fplcOptions, MaxColumnPressure],
		(*otherwise, total whatever we have from the models*)
		Round[UnitConvert[Total[maxPressureForEachColumn], PSI], 0.1 PSI]
	];

	(* pull out the MinFlowRate and MaxFlowRate values of the columns *)
	{minFlowRates, maxFlowRates} = Transpose[Lookup[resolvedColumnModelPackets, {MinFlowRate, MaxFlowRate}]];

	(* get the minimum of the MaxFlowRates and maximum of the MinFlowRates *)
	maxMinFlowRates = Max[Append[Cases[minFlowRates, FlowRateP],0Milliliter/Minute]];
	minMaxFlowRates = Min[Cases[maxFlowRates, FlowRateP]];

	(* pick the optimal flow rate for this column (the Min of all the MaxFlowRates and 1 Milliliter/Minute (or of the max of the MinFlowRates))  *)
	optimalFlowRateForColumn = If[maxMinFlowRates > 1 Milliliter / Minute,
		Min[maxMinFlowRates, minMaxFlowRates],
		Min[1 Milliliter / Minute, minMaxFlowRates]
	];

	(* articulate all the standard options *)
	(* this method is a little weird but it ensures that if we add new options we don't need to remember to add them to a hard coded list here *)
	standardOptionNames = ToExpression[Flatten[StringCases[Keys[Options[ExperimentFPLC]], "Standard" ~~ ___]]];

	(* get the expected _singleton_ patterns for each standard option *)
	standardOptionSingletonPatterns = Map[
		ReleaseHold[Lookup[#, "SingletonPattern"]]&,
		Select[OptionDefinition[ExperimentFPLC], MatchQ[ToExpression[Lookup[#, "OptionName"]], Alternatives @@ standardOptionNames]&]
	];

	(*if the injection table is specified, get the types of all of the samples*)
	injectionTableTypes = If[injectionTableSpecifiedQ,
		injectionTableLookup[[All, 1]],
		{}
	];

	(*first we ask if any of the standard options are defined*)
	standardOptionSpecifiedBool = Map[
		MatchQ[Lookup[roundedOptionsAssociation, #], Except[ListableP[(Null | None | Automatic)]]]&,
		standardOptionNames
	];

	(*now we ask whether any standards are to exist or already do*)
	standardExistsQ = MemberQ[standardOptionSpecifiedBool, True] || MemberQ[injectionTableTypes, Standard];

	(*simultaneously, we should check to see if certain options were set to Null when they shouldn't have been*)
	standardConflictOptions={StandardBufferA,StandardBufferB,StandardBufferC,StandardBufferD,StandardGradient,StandardGradientA,StandardGradientB,StandardGradientC,StandardGradientD,StandardFlowRate,StandardFlowDirection};
	standardConflictQ=And[standardExistsQ, MemberQ[Lookup[roundedOptionsAssociation, standardConflictOptions],Null]];

	(*do all of our error accounting *)
	invalidStandardConflictOptions = If[standardConflictQ && messagesQ,
		(
			Message[Error::StandardOptionConflict,PickList[standardConflictOptions,Lookup[roundedOptionsAssociation, standardConflictOptions],Null]];
			PickList[standardConflictOptions,Lookup[roundedOptionsAssociation, standardConflictOptions],Null]
		),
		{}
	];

	(* generate the test for mismatches between the injection table and the samples *)
	standardConflictTest = If[gatherTests && standardConflictQ,
		Test["If standards are specified, the other pertinent options should not be set to Null:",
			standardConflictQ,
			False
		],
		Nothing
	];

	(*now do the same with the blank options*)
	blankOptionNames = ToExpression[Flatten[StringCases[Keys[Options[ExperimentFPLC]], "Blank" ~~ ___]]];

	(* get the expected _singleton_ patterns for each blank option *)
	blankOptionSingletonPatterns = Map[
		ReleaseHold[Lookup[#, "SingletonPattern"]]&,
		Select[OptionDefinition[ExperimentFPLC], MatchQ[ToExpression[Lookup[#, "OptionName"]], Alternatives @@ blankOptionNames]&]
	];

	(*first we ask if any of the blank options are defined*)
	blankOptionSpecifiedBool = Map[
		MatchQ[Lookup[roundedOptionsAssociation, #], Except[ListableP[(Null | None | Automatic)]]]&,
		blankOptionNames
	];

	(*now we ask whether any standards are to exist or already do*)
	blankExistsQ = MemberQ[blankOptionSpecifiedBool, True] || MemberQ[injectionTableTypes, Blank];

	(*simultaneously, we should check to see if certain options were set to Null when they shouldn't have been*)
	blankConflictOptions={BlankBufferA,BlankBufferB,BlankBufferC,BlankBufferD,BlankGradient,BlankGradientA,BlankGradientA,BlankGradientC,BlankGradientD,BlankFlowRate,BlankFlowDirection};
	blankConflictQ=And[blankExistsQ, MemberQ[Lookup[roundedOptionsAssociation, blankConflictOptions],Null]];

	(*do all of our error accounting *)
	invalidBlankConflictOptions = If[blankConflictQ && messagesQ,
		(
			Message[Error::BlankOptionConflict,PickList[blankConflictOptions,Lookup[roundedOptionsAssociation, blankConflictOptions],Null]];
			PickList[blankConflictOptions,Lookup[roundedOptionsAssociation, blankConflictOptions],Null]
		),
		{}
	];

	(* generate the test for mismatches between the injection table and the samples *)
	blankConflictTest = If[gatherTests && blankConflictQ,
		Test["If blanks are specified, the other pertinent options should not be set to Null:",
			blankConflictQ,
			False
		],
		Nothing
	];

	(*define our default blank model*)
	defaultBlank = Model[Sample, "id:Fake placeholder to be replaced after resolution of BlankBufferA"];

	(* decide what the default model of standard should be *)
	defaultStandard = If[MatchQ[resolvedSeparationMode, SizeExclusion | IonExchange],
		(* "Thermo-Fisher dsDNA Ladder 10-300 bp, 50 ng/uL" *)
		Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"],
		(* "Peptide HPLC Standard Mix" is the preferred standard but currently not available due to supplier issues *)
		(*Model[Sample, StockSolution, Standard, "id:R8e1PjpkWx5X"]*)
		(* Until this can be ordered, use the more expensive alternative *)
		Model[Sample, StockSolution, Standard, "id:o1k9jAolAnVr"]
	];

	(*call our shared helper in order to resolve common options related to the Standard and Blank*)
	{{resolvedStandardBlankOptions, invalidStandardBlankOptions}, invalidStandardBlankTests} = If[gatherTests,
		resolveChromatographyStandardsAndBlanks[mySamples, roundedOptionsAssociation, standardExistsQ, defaultStandard, blankExistsQ, defaultBlank, Output -> {Result, Tests}],
		{resolveChromatographyStandardsAndBlanks[mySamples, roundedOptionsAssociation, standardExistsQ, defaultStandard, blankExistsQ, defaultBlank], {}}
	];

	(* pull out the resolved frequency and pre-resolved (i.e., not necessarily expanded) standard and blank options *)
	{resolvedStandardFrequency, preResolvedStandard, resolvedBlankFrequency, preResolvedBlankWithPlaceholder} = Lookup[resolvedStandardBlankOptions, {StandardFrequency, Standard, BlankFrequency, Blank}];

	(* if none of the expanded index matching standard or blank options are specified but the standard or blank do exist, then we need to ToList things; otherwise things will get expanded properly *)
	preResolvedStandardMaybeList = If[standardExistsQ && MatchQ[Lookup[roundedOptionsAssociation, standardOptionNames], standardOptionSingletonPatterns],
		ToList[preResolvedStandard],
		preResolvedStandard
	];
	preResolvedBlankMaybeList = If[blankExistsQ && MatchQ[Lookup[roundedOptionsAssociation, blankOptionNames], blankOptionSingletonPatterns],
		ToList[preResolvedBlankWithPlaceholder],
		preResolvedBlankWithPlaceholder
	];

	(*we need to expand out Blank and Standard Options respectively because we've resolved them (or, for the Blank, we've _mostly_ resolved them) *)
	expandedStandardOptions = If[!standardExistsQ,
		Association[# -> {}& /@ standardOptionNames],
		Last[ExpandIndexMatchedInputs[
			ExperimentFPLC,
			{mySamples},
			Normal[Append[
				KeyTake[roundedOptionsAssociation, standardOptionNames],
				Standard -> preResolvedStandardMaybeList
			]],
			Messages -> False
		]]
	];
	expandedBlankOptions = If[!blankExistsQ,
		Association[# -> {}& /@ blankOptionNames],
		Last[ExpandIndexMatchedInputs[
			ExperimentFPLC,
			{mySamples},
			Normal[Append[
				KeyTake[roundedOptionsAssociation, blankOptionNames],
				Blank -> preResolvedBlankMaybeList
			]],
			Messages -> False
		]]
	];

	(* --- Resolve BlankBufferA/BlankBufferB/StandardBufferA/StandardBufferB --- *)

	(* get the BlankGradient options *)
	specifiedExpandedBlankGradients = Lookup[expandedBlankOptions, BlankGradient];

	(* get what the specified injection table is *)
	specifiedInjectionTable = Lookup[roundedOptionsAssociation, InjectionTable];

	(* If the InjectionTable option is specified, pull out all the blank gradient objects *)
	specifiedInjectionTableBlankGradients = If[MatchQ[specifiedInjectionTable, Automatic],
		ConstantArray[Null, Length[ToList[specifiedExpandedBlankGradients]]],
		Cases[specifiedInjectionTable, {Blank, _, _, _, gradient_} :> gradient]
	];

	(* get the gradient packets that we care about for each blank *)
	(* note that we want to remove the possibility for some MapThread errors in case the InjectionTable and blank fields are mismatched *)
	specifiedExpandedBlankGradientPackets = If[Length[ToList[specifiedExpandedBlankGradients]] == Length[specifiedInjectionTableBlankGradients],
		MapThread[
			Function[{specifiedGrad, injectionTableGrad},
				Which[
					MatchQ[specifiedGrad, ObjectP[Object[Method, Gradient]]], fetchPacketFromFastAssoc[Download[specifiedGrad, Object], fastAssoc],
					MatchQ[injectionTableGrad, ObjectP[Object[Method, Gradient]]], fetchPacketFromFastAssoc[Download[injectionTableGrad, Object], fastAssoc],
					True, Null
				]
			],
			{ToList[specifiedExpandedBlankGradients], specifiedInjectionTableBlankGradients}
		],
		Map[
			Function[{specifiedGrad},
				If[MatchQ[specifiedGrad, ObjectP[Object[Method, Gradient]]],
					fetchPacketFromFastAssoc[Download[specifiedGrad, Object], fastAssoc],
					Null
				]
			],
			specifiedExpandedBlankGradients
		]
	];

	(* get the StandardGradient options *)
	specifiedExpandedStandardGradients = Lookup[expandedStandardOptions, StandardGradient];

	(* If the InjectionTable option is specified, pull out all the standard gradient objects *)
	specifiedInjectionTableStandardGradients = If[MatchQ[specifiedInjectionTable, Automatic],
		ConstantArray[Null, Length[ToList[specifiedExpandedStandardGradients]]],
		Cases[specifiedInjectionTable, {Standard, _, _, _, gradient_} :> gradient]
	];

	(* get the gradient packets that we care about for each standard *)
	(* note that we want to remove the possibility for some MapThread errors in case the InjectionTable and standard fields are mismatched *)
	specifiedExpandedStandardGradientPackets = If[Length[ToList[specifiedExpandedStandardGradients]] == Length[specifiedInjectionTableStandardGradients],
		MapThread[
			Function[{specifiedGrad, injectionTableGrad},
				Which[
					MatchQ[specifiedGrad, ObjectP[Object[Method, Gradient]]], fetchPacketFromFastAssoc[Download[specifiedGrad, Object], fastAssoc],
					MatchQ[injectionTableGrad, ObjectP[Object[Method, Gradient]]], fetchPacketFromFastAssoc[Download[injectionTableGrad, Object], fastAssoc],
					True, Null
				]
			],
			{ToList[specifiedExpandedStandardGradients], specifiedInjectionTableStandardGradients}
		],
		Map[
			Function[{specifiedGrad},
				If[MatchQ[specifiedGrad, ObjectP[Object[Method, Gradient]]],
					fetchPacketFromFastAssoc[Download[specifiedGrad, Object], fastAssoc],
					Null
				]
			],
			specifiedExpandedStandardGradients
		]
	];

	(* update the Standard option as expanded by the above *)
	resolvedStandard = Lookup[expandedStandardOptions, Standard];

	(*are we using the AKTA10?*)
	akta10Q=MatchQ[Lookup[resolvedInstrumentModelPacket,Object],ObjectP[Model[Instrument, FPLC, "AKTApurifier UPC 10"]]];

	(*check to see if any of the column prime or flush options were nulled out*)
	columnPrimeNullOutQ=MemberQ[Lookup[roundedOptionsAssociation, {ColumnPrimeGradientA, ColumnPrimeGradientB, ColumnPrimeGradientC, ColumnPrimeGradientD, ColumnPrimeGradient, ColumnPrimeFlowRate,ColumnPrimeFlowDirection}],Null];
	columnFlushNullOutQ=MemberQ[Lookup[roundedOptionsAssociation, {ColumnFlushGradientA, ColumnFlushGradientB, ColumnFlushGradientC, ColumnFlushGradientD, ColumnFlushGradient, ColumnFlushFlowRate,ColumnFlushFlowDirection}],Null];

	(*resolved column refresh frequency*)
	resolvedColumnRefreshFrequency = Which[
		(*always accede to the user*)
		MatchQ[Lookup[roundedOptionsAssociation, ColumnRefreshFrequency], Except[Automatic]], Lookup[roundedOptionsAssociation, ColumnRefreshFrequency],
		(*check whether we have an InjectionTable. If so, Null.*)
		MatchQ[Lookup[roundedOptionsAssociation, InjectionTable], Except[Automatic]], Null,
		(*if we're working with the Avant 10 system, no column primes or flushes can be used*)
		akta10Q, None,
		(*check to see if any of the column prime options were Nulled out, but not the last*)
		columnPrimeNullOutQ&&!columnFlushNullOutQ,Last,
		!columnPrimeNullOutQ&&columnFlushNullOutQ,First,
		columnPrimeNullOutQ&&columnFlushNullOutQ, None,
		(*otherwise, we'll do first and last*)
		True, FirstAndLast
	];

	(* --- Now we resolve the gradients, oh boy. We do something like the Master map thread here. --- *)

	(*first get the injection table gradients*)
	injectionTableSampleRoundedGradients = If[MatchQ[Lookup[roundedOptionsAssociation, InjectionTable], Except[Automatic]] && !injectionTableSampleConflictQ,
		Cases[Lookup[roundedOptionsAssociation, InjectionTable], {Sample, _, _, _, gradient_} :> gradient],
		(*otherwise just pad away with Automatics*)
		ConstantArray[Automatic, Length[mySamples]]
	];

	(* Helper to collapse gradient into single percentage value if the option is Automatic and all values are the same at each timepoint *)
	collapseGradient[gradientTimepoints : {{TimeP, PercentP | FlowRateP | PressureP}...}] := If[SameQ @@ (gradientTimepoints[[All, 2]]),
		gradientTimepoints[[1, 2]],
		gradientTimepoints
	];

	{
		(*1*)resolvedAnalyteGradients,
		(*2*)resolvedGradientStarts,
		(*3*)resolvedGradientEnds,
		(*4*)resolvedGradientDurations,
		(*5*)resolvedEquilibrationTimes,
		(*6*)resolvedPreInjectionEquilibrationTimes,
		(*7*)resolvedFlushTimes,
		(*8*)resolvedGradientAs,
		(*9*)resolvedGradientBs,
		(*10*)resolvedGradientCs,
		(*11*)resolvedGradientDs,
		(*12*)resolvedGradientEs,
		(*13*)resolvedGradientFs,
		(*14*)resolvedGradientGs,
		(*15*)resolvedGradientHs,
		(*16*)resolvedFlowRates,
		(*17*)resolvedGradients,
		(*18*)gradientStartEndSpecifiedBool,
		(*19*)gradientInjectionTableSpecifiedDifferentlyBool,
		(*20*)invalidGradientCompositionBool,
		(*21*)nonbinaryGradientBool,
		(*22*)removedExtraBool,
		(*23*)gradientShortcutConflictBool,
		(*24*)gradientStartEndBConflictBool,
		(*25*)resolvedSampleLoopDisconnects
	} = Transpose@MapThread[Function[
		{
			(*1*)gradient,
			(*2*)gradientA,
			(*3*)gradientB,
			(*4*)gradientC,
			(*5*)gradientD,
			(*6*)gradientE,
			(*7*)gradientF,
			(*8*)gradientG,
			(*9*)gradientH,
			(*10*)gradientStart,
			(*11*)gradientEnd,
			(*12*)gradientDuration,
			(*13*)equilibrationTime,
			(*14*)preInjectionEquilibrationTime,
			(*15*)flushTime,
			(*16*)flowRate,
			(*17*)sampleLoopDisconnect,
			(*18*)injectionTableGradient
		}, Module[
			{gradientStartEndSpecifiedQ, gradientInjectionTableSpecifiedDifferentlyQ, resolvedGradientStart, resolvedGradientEnd, removedExtrasQ,
				resolvedEquilibrationTime, resolvedPreInjectionEquilibrationTime,resolvedFlushTime, analyteGradientOptionTuple, defaultedAnalyteFlowRate, analyteGradient, analyteGradientReturned,
				invalidGradientCompositionQ, resolvedGradientA, resolvedGradientB, resolvedGradientC, resolvedGradientD, resolvedFlowRate,
				protoAnalyteGradientOptionTuple, resolvedGradient, nonbinaryGradientQ,gradientShortcutConflictQ,gradientStartEndBConflictQ,semiResolvedGradientA,resolvedGradientE, resolvedGradientF, resolvedGradientG,
				resolvedGradientH, semiResolvedGradientC, semiResolvedGradientE, semiResolvedGradientG, semiResolvedGradientB,
				semiResolvedGradientD, semiResolvedGradientF, semiResolvedGradientH, resolvedSampleLoopDisconnect},

			(*make sure that the start and end options are either all specified or not *)
			gradientStartEndSpecifiedQ = MatchQ[{gradientStart, gradientEnd}, {PercentP, PercentP} | {Null,Null}];

			(*check whether the shortcut options are specified and conflict with the other gradient option values *)
			(* If we do not have matching Start/End/B we check whether the shortcut options are specified and conflict with the other gradient option values *)
			gradientShortcutConflictQ=And[
				MatchQ[gradientDuration,TimeP],
				(* If there is duration, we must have Start/End pair or one of the A/B/C/D *)
				Xnor[
					MatchQ[{gradientStart, gradientEnd}, {PercentP, PercentP}],
					MemberQ[{gradientA,gradientB,gradientC,gradientD},Except[Automatic|Null]]
				]
			];

			(* If Start/End and B all exist, they must all be the same. Do not allow B as {TimeP,PercentP} *)
			gradientStartEndBConflictQ=Which[
				(* Ignore this error if we already give shortcut conflict error *)
				gradientShortcutConflictQ,False,
				MatchQ[gradientB,Automatic|Null],False,
				MatchQ[gradientStart,Automatic|Null]||MatchQ[gradientEnd,Automatic|Null],False,
				MatchQ[gradientB,PercentP],!(MatchQ[gradientStart,gradientB]&&MatchQ[gradientEnd,gradientB]),
				True,True
			];

			(*check whether both gradient and the injection table are specified and are the same object*)
			gradientInjectionTableSpecifiedDifferentlyQ = If[MatchQ[gradient, ObjectP[Object[Method, Gradient]]] && MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]],
				Not[MatchQ[Download[gradient, Object], Download[injectionTableGradient, Object]]],
				False
			];

			(* Extract or default GradientStart and GradientEnd values *)
			{resolvedGradientStart, resolvedGradientEnd} = Switch[{gradientStart, gradientEnd, gradientDuration},
				{PercentP, PercentP, _} | {Null, Null, Null | TimeP}, {gradientStart, gradientEnd},
				(* Default to gradientStart if something is wrong with gradientEnd *)
				{PercentP, _, _}, {gradientStart, gradientStart},
				(* Default to 0 if something is wrong with gradeintStart *)
				{_, PercentP, _}, {0 Percent, gradientEnd},
				(*otherwise, both Null*)
				_, {Null, Null}
			];

			(* Resolve equilibration times from option value or gradient or injection table object *)
			resolvedEquilibrationTime = Which[
				MatchQ[equilibrationTime, Except[Automatic]], equilibrationTime,
				MatchQ[gradient, ObjectP[Object[Method, Gradient]]], Lookup[fetchPacketFromFastAssoc[Download[gradient, Object], fastAssoc], EquilibrationTime],
				MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]], Lookup[fetchPacketFromFastAssoc[Download[injectionTableGradient, Object], fastAssoc], EquilibrationTime],
				True, Null
			];

			(* Resolve equilibration times from option value or gradient or injection table object *)
			resolvedPreInjectionEquilibrationTime = Which[

				(* Use user specified value if user specified something*)
				MatchQ[preInjectionEquilibrationTime, Except[Automatic]], preInjectionEquilibrationTime,

				(* Else if the instrument is Avant 150 we use 5 minute as the preinjectin equilibration time *)
				avant150Q,5Minute,

				(* In all other cases, resolve it to Null *)
				True, Null
			];

			(* Resolve flush times from option value or gradient object *)
			resolvedFlushTime = Which[
				MatchQ[flushTime, Except[Automatic]], flushTime,
				MatchQ[gradient, ObjectP[Object[Method, Gradient]]], Lookup[fetchPacketFromFastAssoc[Download[gradient, Object], fastAssoc], FlushTime],
				MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]], Lookup[fetchPacketFromFastAssoc[Download[injectionTableGradient, Object], fastAssoc], FlushTime],
				True, Null
			];

			(* If Gradient option is an object, pull Gradient value from packet *)
			protoAnalyteGradientOptionTuple = Which[
				MatchQ[gradient, ObjectP[Object[Method, Gradient]]], Lookup[fetchPacketFromFastAssoc[Download[gradient, Object], fastAssoc], Gradient],
				MatchQ[gradient, Automatic] && MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]], Lookup[fetchPacketFromFastAssoc[Download[injectionTableGradient, Object], fastAssoc], Gradient],
				(*if we just have two columns, expand to 8*)
				MatchQ[gradient,binaryGradientP], Transpose@Nest[Insert[#,Repeat[0 Percent,Length[gradient]], -2] &,Transpose@gradient, 6],
				(*if four columns, expand to 8*)
				MatchQ[gradient,gradientP], Transpose@Nest[Insert[#,Repeat[0 Percent,Length[gradient]], -2] &,Transpose@gradient, 4],
				True, gradient
			];

			(*if the flow rate was changed, we update that*)
			analyteGradientOptionTuple=If[MatchQ[flowRate, Except[Automatic]],
				ReplacePart[protoAnalyteGradientOptionTuple,Table[{x,-1}->flowRate,{x,1,Length[protoAnalyteGradientOptionTuple]}]],
				protoAnalyteGradientOptionTuple
			];

			(* Default FlowRate to option value, gradient tuple values, or the pre-calculated optimal flow rate for the column *)
			(* note that it's ok to have this flow rate either match FlowRateP, or be a list of pairs of time and flow rate since resolveHPLCGradient can handle either *)
			defaultedAnalyteFlowRate = Which[
				MatchQ[flowRate, Except[Automatic]], flowRate,
				MatchQ[analyteGradientOptionTuple, expandedGradientP], analyteGradientOptionTuple[[All, {1, -1}]],
				True, optimalFlowRateForColumn
			];

			(*if gradient C, E, or G is set, we want A to go to 0*)
			semiResolvedGradientA=If[MatchQ[gradientA,Automatic]&&MemberQ[{gradientC,gradientE,gradientG},GreaterP[0*Percent]],
				0 Percent,
				gradientA
			];
			semiResolvedGradientC=If[MatchQ[gradientC,Automatic]&&MemberQ[{gradientA,gradientE,gradientG},GreaterP[0*Percent]],
				0 Percent,
				gradientC
			];
			semiResolvedGradientE=If[MatchQ[gradientE,Automatic]&&MemberQ[{gradientA,gradientC,gradientG},GreaterP[0*Percent]],
				0 Percent,
				gradientE
			];
			semiResolvedGradientG=If[MatchQ[gradientG,Automatic]&&MemberQ[{gradientA,gradientC,gradientE},GreaterP[0*Percent]],
				0 Percent,
				gradientG
			];

			(*if gradient D, F, or H is set, we want H to go to 0*)
			semiResolvedGradientB=If[MatchQ[gradientB,Automatic]&&MemberQ[{gradientD,gradientF,gradientH},GreaterP[0*Percent]],
				0 Percent,
				gradientB
			];
			semiResolvedGradientD=If[MatchQ[gradientD,Automatic]&&MemberQ[{gradientB,gradientF,gradientH},GreaterP[0*Percent]],
				0 Percent,
				gradientD
			];
			semiResolvedGradientF=If[MatchQ[gradientF,Automatic]&&MemberQ[{gradientD,gradientB,gradientH},GreaterP[0*Percent]],
				0 Percent,
				gradientF
			];
			semiResolvedGradientH=If[MatchQ[gradientH,Automatic]&&MemberQ[{gradientD,gradientF,gradientB},GreaterP[0*Percent]],
				0 Percent,
				gradientH
			];

			(* finally run our helper resolution function *)
			analyteGradientReturned = Which[
				(*if the analyte gradient is already fully informed, then we go with that*)
				MatchQ[analyteGradientOptionTuple,expandedGradientP],analyteGradientOptionTuple,
				MatchQ[{analyteGradientOptionTuple, semiResolvedGradientA, semiResolvedGradientA, semiResolvedGradientB, semiResolvedGradientC, semiResolvedGradientD,
					semiResolvedGradientE, semiResolvedGradientF, semiResolvedGradientG, semiResolvedGradientH, resolvedGradientStart, resolvedGradientEnd, gradientDuration}, {(Null | Automatic)..}],
					resolveGradient[
						defaultGradientFPLC[defaultedAnalyteFlowRate],
						semiResolvedGradientA,
						semiResolvedGradientB,
						semiResolvedGradientC,
						semiResolvedGradientD,
						semiResolvedGradientE,
						semiResolvedGradientF,
						semiResolvedGradientG,
						semiResolvedGradientH,
						defaultedAnalyteFlowRate,
						gradientStart,
						gradientEnd,
						gradientDuration,
						resolvedFlushTime,
						resolvedEquilibrationTime
					],
				True,
					resolveGradient[
						analyteGradientOptionTuple,
						semiResolvedGradientA,
						semiResolvedGradientB,
						semiResolvedGradientC,
						semiResolvedGradientD,
						semiResolvedGradientE,
						semiResolvedGradientF,
						semiResolvedGradientG,
						semiResolvedGradientH,
						defaultedAnalyteFlowRate,
						gradientStart,
						gradientEnd,
						gradientDuration,
						resolvedFlushTime,
						resolvedEquilibrationTime
					]
			];

			(*remove duplicate entries if need be*)
			analyteGradient=DeleteDuplicatesBy[analyteGradientReturned,First[#*1.] &];

			(*if it's not the same note that*)
			removedExtrasQ=If[MatchQ[analyteGradientOptionTuple,expandedGradientP],
				!MatchQ[1.*analyteGradientOptionTuple,1.*analyteGradient],
				!MatchQ[1.*analyteGradientReturned,1.*analyteGradient]
			];

			(*check whether the gradient composition adds up to 100 okay*)
			invalidGradientCompositionQ = Not[AllTrue[analyteGradient, (#[[2]] + #[[3]] + #[[4]] + #[[5]] + #[[6]] + #[[7]] + #[[8]] + #[[9]] == 100 Percent)&]];

			(*check whether the gradient is non binary, meaning that any of the tuples have both A and C or both B and D*)
			nonbinaryGradientQ = Or@@MapThread[
				Function[{aPercent, bPercent, cPercent, dPercent, ePercent, fPercent, gPercent, hPercent},
					Or[
						Count[{aPercent, cPercent, ePercent, gPercent},GreaterP[0 Percent]]>1,
						Count[{bPercent, dPercent, fPercent, hPercent},GreaterP[0 Percent]]>1
					]
				], Transpose@analyteGradient[[All, {2, 3, 4, 5, 6, 7, 8, 9}]]
			];

			(*now resolve all of the individual gradients and flow rate*)
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
			resolvedGradientE = If[MatchQ[gradientE, Automatic],
				collapseGradient[analyteGradient[[All, {1, 6}]]],
				gradientE
			];
			resolvedGradientF = If[MatchQ[gradientF, Automatic],
				collapseGradient[analyteGradient[[All, {1, 7}]]],
				gradientF
			];
			resolvedGradientG = If[MatchQ[gradientG, Automatic],
				collapseGradient[analyteGradient[[All, {1, 8}]]],
				gradientG
			];
			resolvedGradientH = If[MatchQ[gradientH, Automatic],
				collapseGradient[analyteGradient[[All, {1, 9}]]],
				gradientH
			];
			resolvedFlowRate = If[MatchQ[flowRate, Automatic],
				collapseGradient[analyteGradient[[All, {1, -1}]]],
				flowRate
			];

			(*resolve the gradient*)
			resolvedGradient = Which[
				MatchQ[gradient, Except[Automatic]], gradient,
				(*otherwise if the gradient is automatic and the injection table is set, should use that*)
				MatchQ[gradient, Automatic] && MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]], Download[injectionTableGradient, Object],
				(*otherwise, it should be a tuple*)
				True, analyteGradient
			];

			(* Resolve the sample loop disconnect volume *)
			resolvedSampleLoopDisconnect=Switch[sampleLoopDisconnect,
				(* If automatic, we don't disconnect the sample loop, so pass through Null *)
				Alternatives[Automatic,Null],
				Null,

				(* Otherwise it's a volume that we can use directly *)
				_,
				sampleLoopDisconnect
			];

			(*return everything*)
			{
				(*1*)analyteGradient,
				(*2*)resolvedGradientStart,
				(*3*)resolvedGradientEnd,
				(*4*)gradientDuration,
				(*5*)resolvedEquilibrationTime,
				(*6*)resolvedPreInjectionEquilibrationTime,
				(*7*)resolvedFlushTime,
				(*8*)resolvedGradientA,
				(*9*)resolvedGradientB,
				(*10*)resolvedGradientC,
				(*11*)resolvedGradientD,
				(*12*)resolvedGradientE,
				(*13*)resolvedGradientF,
				(*14*)resolvedGradientG,
				(*15*)resolvedGradientH,
				(*16*)resolvedFlowRate,
				(*17*)resolvedGradient,
				(*18*)gradientStartEndSpecifiedQ,
				(*19*)gradientInjectionTableSpecifiedDifferentlyQ,
				(*20*)invalidGradientCompositionQ,
				(*21*)nonbinaryGradientQ,
				(*22*)removedExtrasQ,
				(*23*)gradientShortcutConflictQ,
				(*24*)gradientStartEndBConflictQ,
				(*25*)resolvedSampleLoopDisconnect
			}

		]],
		Append[
			Lookup[roundedOptionsAssociation,
				{
					(*1*)Gradient,
					(*2*)GradientA,
					(*3*)GradientB,
					(*4*)GradientC,
					(*5*)GradientD,
					(*6*)GradientE,
					(*7*)GradientF,
					(*8*)GradientG,
					(*9*)GradientH,
					(*10*)GradientStart,
					(*11*)GradientEnd,
					(*12*)GradientDuration,
					(*13*)EquilibrationTime,
					(*14*)PreInjectionEquilibrationTime,
					(*15*)FlushTime,
					(*16*)FlowRate,
					(*17*)SampleLoopDisconnect
				}
			],
			injectionTableSampleRoundedGradients
		]
	];

	(*we need to get all of the injection table gradients*)
	injectionTableStandardGradients = Which[
		(*grab the gradients column of the injection table for standard samples*)
		standardExistsQ && injectionTableSpecifiedQ, Cases[injectionTableLookup, {Standard, _, _, _, gradient_} :> gradient],
		(* otherwise just pad automatics *)
		standardExistsQ, ConstantArray[Automatic, Length[resolvedStandard]],
		(* if no standard exists, then resolvedStandard is going to be {} so obvi no gradients either *)
		True, {}
	];
	injectionTableBlankGradients = Which[
		(*grab the gradients column of the injection table for blank samples*)
		blankExistsQ && injectionTableSpecifiedQ, Cases[injectionTableLookup, {Blank, _, _, _, gradient_} :> gradient],
		(* otherwise just pad automatics *)
		blankExistsQ, ConstantArray[Automatic, Length[Lookup[expandedBlankOptions, Blank]]],
		(* if no standard exists, then resolvedBlank is going to be {} so obvi no gradients either *)
		True, {}
	];

	(* get the column prime gradients from the injection table *)
	injectionTableColumnPrimeGradients = Cases[specifiedInjectionTable, {ColumnPrime, _, _, _, gradient_} :> If[MatchQ[gradient, ObjectP[]], Download[gradient, Object], gradient]];
	injectionTableColumnFlushGradients = Cases[specifiedInjectionTable, {ColumnFlush, _, _, _, gradient_} :> If[MatchQ[gradient, ObjectP[]], Download[gradient, Object], gradient]];

	(*do some error checking*)
	multiplePrimeSameColumnQ = Length[DeleteDuplicates[Download[DeleteCases[injectionTableColumnPrimeGradients,Automatic], Object]]] > 1;
	multipleFlushSameColumnQ = Length[DeleteDuplicates[Download[DeleteCases[injectionTableColumnFlushGradients,Automatic], Object]]] > 1;

	(*if so, then get the offending options*)
	multipleGradientsColumnPrimeFlushOptions = If[(multiplePrimeSameColumnQ || multipleFlushSameColumnQ) && messagesQ,
		(
			Message[Error::InjectionTableColumnGradientConflict];
			{InjectionTable}
		),
		{}
	];

	(* make tests ensuring the ColumnPrime and ColumnFlush entries have the same gradient *)
	multipleGradientsColumnPrimeFlushTest = If[gatherTests,
		Test["If InjectionTable is defined, the ColumnPrime and ColumnFlush entries each have the same gradient:",
			multiplePrimeSameColumnQ || multipleFlushSameColumnQ,
			False
		],
		Nothing
	];

	(*now resolve all of the other gradients*)
	{
		{
			resolvedStandardAnalyticalGradients,
			resolvedStandardGradientAs,
			resolvedStandardGradientBs,
			resolvedStandardGradientCs,
			resolvedStandardGradientDs,
			resolvedStandardGradientEs,
			resolvedStandardGradientFs,
			resolvedStandardGradientGs,
			resolvedStandardGradientHs,
			resolvedStandardFlowRates,
			resolvedStandardGradients,
			resolvedStandardPreInjectionEquilibrationTimes,
			standardGradientStartEndSpecifiedBool,
			standardGradientInjectionTableSpecifiedDifferentlyBool,
			standardInvalidGradientCompositionBool,
			nonbinaryStandardGradientBool,
			removedExtraStandardBool,
			standardGradientShortcutConflictBool,
			standardGradientStartEndBConflictBool,
			resolvedStandardSampleLoopDisconnects
		},
		{
			resolvedBlankAnalyticalGradients,
			resolvedBlankGradientAs,
			resolvedBlankGradientBs,
			resolvedBlankGradientCs,
			resolvedBlankGradientDs,
			resolvedBlankGradientEs,
			resolvedBlankGradientFs,
			resolvedBlankGradientGs,
			resolvedBlankGradientHs,
			resolvedBlankFlowRates,
			resolvedBlankGradients,
			resolvedBlankPreInjectionEquilibrationTimes,
			blankGradientStartEndSpecifiedBool,
			blankGradientInjectionTableSpecifiedDifferentlyBool,
			blankInvalidGradientCompositionBool,
			nonbinaryBlankGradientBool,
			removedExtraBlankBool,
			blankGradientShortcutConflictBool,
			blankGradientStartEndBConflictBool,
			resolvedBlankSampleLoopDisconnects
		}
	} = Map[
		Function[{entry},
			Module[{gradientAs, gradientBs, gradientCs, gradientDs, gradientEs, gradientFs, gradientGs, gradientHs, gradients, gradientDurations, preInjectionEquilibrationTimes, flowRates,
				injectionTableGradients, type, mismatchedValues, gradientStarts, gradientEnds, injectionTableGradientsCorrectLength, sampleLoopDisconnects},

				(*split up the entry variable*)
				{gradientAs, gradientBs, gradientCs, gradientDs, gradientEs, gradientFs, gradientGs, gradientHs, gradients, gradientStarts, gradientEnds, gradientDurations, preInjectionEquilibrationTimes, flowRates, sampleLoopDisconnects, injectionTableGradients, type} = entry;

				(* if the InjectionTable values for the gradients are different length than the rest, then flip a switch and just fake it *)
				mismatchedValues = Length[injectionTableGradients] != Length[gradients];
				injectionTableGradientsCorrectLength = If[mismatchedValues,
					ConstantArray[Automatic, Length[gradients]],
					injectionTableGradients
				];

				Which[
					(*in which case, we resolve all the rest of the Automatics to Null/{} and return early *)
					MatchQ[{gradientAs, gradientBs, gradientCs, gradientDs,  gradientEs, gradientFs, gradientGs, gradientHs, gradients, gradientStarts, gradientEnds, gradientDurations, flowRates, sampleLoopDisconnects, injectionTableGradientsCorrectLength}, {(Null | {} | Automatic)..}] && MemberQ[{gradientAs, gradientBs, gradients, flowRates}, Null],
						{Sequence @@ ConstantArray[Null, 12],{}, {}, {}, {}, {}, {}, {}, {}},
					(* if we have no automatics, and only nulls/{}, then just reutnr the values straight up *)
					MatchQ[{gradientAs, gradientBs, gradientCs, gradientDs, gradientEs, gradientFs, gradientGs, gradientHs, gradients, gradientDurations, flowRates, sampleLoopDisconnects, injectionTableGradientsCorrectLength}, {(Null | {})..}],
						{Null, gradientAs, gradientBs, gradientCs, gradientDs, gradientEs, gradientFs, gradientGs, gradientHs, flowRates, gradients,Null, {}, {}, {}, {}, {}, {}, {}, {}},
					(*otherwise, we'll resolve the gradient and map through*)
					True,
						Transpose[MapThread[
							Function[{gradientA, gradientB, gradientC, gradientD, gradientE, gradientF, gradientG, gradientH, gradient, gradientStart, gradientEnd, gradientDuration,preInjectionEquilibrationTime, flowRate, sampleLoopDisconnect, injectionTableGradient},
								Module[{gradientInjectionTableSpecifiedDifferentlyQ, analyteGradientOptionTuple, defaultedAnalyteFlowRate, defaultGradient,protoAnalyteGradientOptionTuple,
									analyteGradient, invalidGradientCompositionQ, resolvedGradientA, resolvedGradientB, resolvedFlowRate, resolvedGradient, analyteGradientReturned,removedExtrasQ,
									nonbinaryGradientQ, resolvedGradientC, resolvedGradientD, semiResolvedGradientA,semiResolvedGradientC, semiResolvedGradientE, semiResolvedGradientG, semiResolvedGradientB,
									semiResolvedGradientD, semiResolvedGradientF, semiResolvedGradientH, resolvedGradientE, resolvedGradientF, resolvedGradientG, resolvedGradientH,
									resolvedGradientStart, resolvedGradientEnd, gradientStartEndSpecifiedQ,gradientShortcutConflictQ,gradientStartEndBConflictQ,resolvedPreInjectionEquilibrationTime,resolvedSampleLoopDisconnect},

									(*make sure that the start and end options are either all specified or not *)
									gradientStartEndSpecifiedQ = MatchQ[{gradientStart, gradientEnd}, {PercentP, PercentP} | {Null,Null}];

									(*check whether both gradient and the injection table are specified and are the same object*)
									gradientInjectionTableSpecifiedDifferentlyQ = If[MatchQ[gradient, ObjectP[Object[Method, Gradient]]] && MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]],
										Not[MatchQ[Download[gradient, Object], Download[injectionTableGradient, Object]]],
										False
									];

									(*check whether the shortcut options are specified and conflict with the other gradient option values *)
									gradientShortcutConflictQ=And[
										MatchQ[gradientDuration,TimeP],
										(* If there is duration, we must have Start/End pair or one of the A/B/C/D *)
										Xnor[
											MatchQ[{gradientStart, gradientEnd}, {PercentP, PercentP}],
											MemberQ[{gradientA,gradientB,gradientC,gradientD},Except[Automatic|Null]]
										]
									];

									(* If Start/End and B all exist, they must all be the same. Do not allow B as {TimeP,PercentP} *)
									gradientStartEndBConflictQ=Which[
										(* Ignore this error if we already give shortcut conflict error *)
										gradientShortcutConflictQ,False,
										MatchQ[gradientB,Automatic|Null],False,
										MatchQ[gradientStart,Automatic|Null]||MatchQ[gradientEnd,Automatic|Null],False,
										MatchQ[gradientB,PercentP],!(MatchQ[gradientStart,gradientB]&&MatchQ[gradientEnd,gradientB]),
										True,True
									];

									(* Extract or default GradientStart and GradientEnd values *)
									{resolvedGradientStart, resolvedGradientEnd} = Switch[{gradientStart, gradientEnd, gradientDuration},
										{PercentP, PercentP, _} | {Null, Null, Null | TimeP}, {gradientStart, gradientEnd},
										(* Default to gradientStart if something is wrong with gradientEnd *)
										{PercentP, _, _}, {gradientStart, gradientStart},
										(* Default to 0 if something is wrong with gradeintStart *)
										{_, PercentP, _}, {0 Percent, gradientEnd},
										(*otherwise, both Null*)
										_, {Null, Null}
									];

									(* If Gradient option is an object, pull Gradient value from packet *)
									protoAnalyteGradientOptionTuple = Which[
										MatchQ[gradient, ObjectP[Object[Method, Gradient]]], Lookup[fetchPacketFromFastAssoc[Download[gradient, Object], fastAssoc], Gradient],
										MatchQ[gradient, Automatic] && MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]], Lookup[fetchPacketFromFastAssoc[Download[injectionTableGradient, Object], fastAssoc], Gradient],
										(*if we just have two columns, expand to 8*)
										MatchQ[gradient,binaryGradientP], Transpose@Nest[Insert[#,Repeat[0 Percent,Length[gradient]], -2] &,Transpose@gradient, 6],
										(*if four columns, expand to 8*)
										MatchQ[gradient,gradientP], Transpose@Nest[Insert[#,Repeat[0 Percent,Length[gradient]], -2] &,Transpose@gradient, 4],
										True, gradient
									];

									(*if the flow rate was changed, we update that*)
									analyteGradientOptionTuple=If[MatchQ[flowRate, Except[Automatic]],
										ReplacePart[protoAnalyteGradientOptionTuple,Table[{x,-1}->flowRate,{x,1,Length[protoAnalyteGradientOptionTuple]}]],
										protoAnalyteGradientOptionTuple
									];

									(* Default FlowRate to option value, gradient tuple values (or, if given nothing else, pick from the resolved analyte gradients) *)
									defaultedAnalyteFlowRate = Which[
										MatchQ[flowRate, Except[Automatic]], flowRate,
										MatchQ[analyteGradientOptionTuple, expandedGradientP], analyteGradientOptionTuple[[All, {1, -1}]],
										True, resolvedAnalyteGradients[[1, 1, -1]]
									];

									(*create the default gradient based on the first resolved analyte gradient*)
									defaultGradient = First[resolvedAnalyteGradients];
									defaultGradient[[All, -1]] = ConstantArray[defaultedAnalyteFlowRate, Length[defaultGradient]];

									(*if gradient C, E, or G is set, we want A to go to 0*)
									semiResolvedGradientA=If[MatchQ[gradientA,Automatic]&&MemberQ[{gradientC,gradientE,gradientG},GreaterP[0*Percent]],
										0 Percent,
										gradientA
									];
									semiResolvedGradientC=If[MatchQ[gradientC,Automatic]&&MemberQ[{gradientA,gradientE,gradientG},GreaterP[0*Percent]],
										0 Percent,
										gradientC
									];
									semiResolvedGradientE=If[MatchQ[gradientE,Automatic]&&MemberQ[{gradientA,gradientC,gradientG},GreaterP[0*Percent]],
										0 Percent,
										gradientE
									];
									semiResolvedGradientG=If[MatchQ[gradientG,Automatic]&&MemberQ[{gradientA,gradientC,gradientE},GreaterP[0*Percent]],
										0 Percent,
										gradientG
									];

									(*if gradient D, F, or H is set, we want H to go to 0*)
									semiResolvedGradientB=If[MatchQ[gradientB,Automatic]&&MemberQ[{gradientD,gradientF,gradientH},GreaterP[0*Percent]],
										0 Percent,
										gradientB
									];
									semiResolvedGradientD=If[MatchQ[gradientD,Automatic]&&MemberQ[{gradientB,gradientF,gradientH},GreaterP[0*Percent]],
										0 Percent,
										gradientD
									];
									semiResolvedGradientF=If[MatchQ[gradientF,Automatic]&&MemberQ[{gradientD,gradientB,gradientH},GreaterP[0*Percent]],
										0 Percent,
										gradientF
									];
									semiResolvedGradientH=If[MatchQ[gradientH,Automatic]&&MemberQ[{gradientD,gradientF,gradientB},GreaterP[0*Percent]],
										0 Percent,
										gradientH
									];

									(*finally run our helper resolution function*)
									analyteGradientReturned = Which[
										(*if the analyte gradient is already fully informed, then we go with that*)
										MatchQ[analyteGradientOptionTuple,expandedGradientP],analyteGradientOptionTuple,
										MatchQ[{analyteGradientOptionTuple, semiResolvedGradientA, semiResolvedGradientB, semiResolvedGradientC, semiResolvedGradientD, semiResolvedGradientE,
											semiResolvedGradientF, semiResolvedGradientG, semiResolvedGradientH}, {(Null | Automatic)..}],
											resolveGradient[defaultGradient, semiResolvedGradientA, semiResolvedGradientB, semiResolvedGradientC, semiResolvedGradientD, semiResolvedGradientE,
												semiResolvedGradientF, semiResolvedGradientG, semiResolvedGradientH, defaultedAnalyteFlowRate, gradientStart, gradientEnd, gradientDuration, Null, Null],
										True,resolveGradient[analyteGradientOptionTuple, semiResolvedGradientA, semiResolvedGradientB, semiResolvedGradientC, semiResolvedGradientD, semiResolvedGradientE,
											semiResolvedGradientF, semiResolvedGradientG, semiResolvedGradientH, defaultedAnalyteFlowRate, gradientStart, gradientEnd, gradientDuration, Null, Null]
									];

									(*remove duplicate entries if need be*)
									analyteGradient=DeleteDuplicatesBy[analyteGradientReturned,First[#*1.] &];

									(*if it's not the same note that*)
									removedExtrasQ=If[MatchQ[analyteGradientOptionTuple,expandedGradientP],
										!MatchQ[1.*analyteGradientOptionTuple,1.*analyteGradient],
										!MatchQ[1.*analyteGradientReturned,1.*analyteGradient]
									];

									(*check whether the gradient composition adds up to 100 okay*)
									invalidGradientCompositionQ = Not[AllTrue[analyteGradient, (#[[2]] + #[[3]] + #[[4]] + #[[5]] + #[[6]] + #[[7]] + #[[8]] + #[[9]] == 100 Percent)&]];

									(*check whether the gradient is non binary, meaning that any of the tuples have both A and C or both B and D*)
									nonbinaryGradientQ = Or@@MapThread[
										Function[{aPercent, bPercent, cPercent, dPercent, ePercent, fPercent, gPercent, hPercent},
											Or[
												Count[{aPercent, cPercent, ePercent, gPercent},GreaterP[0 Percent]]>1,
												Count[{bPercent, dPercent, fPercent, hPercent},GreaterP[0 Percent]]>1
											]
										], Transpose@analyteGradient[[All, {2, 3, 4, 5, 6, 7, 8, 9}]]
									];

									(*now resolve all of the individual gradients and flow rate*)
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
									resolvedGradientE = If[MatchQ[gradientE, Automatic],
										collapseGradient[analyteGradient[[All, {1, 6}]]],
										gradientE
									];
									resolvedGradientF = If[MatchQ[gradientF, Automatic],
										collapseGradient[analyteGradient[[All, {1, 7}]]],
										gradientF
									];
									resolvedGradientG = If[MatchQ[gradientG, Automatic],
										collapseGradient[analyteGradient[[All, {1, 8}]]],
										gradientG
									];
									resolvedGradientH = If[MatchQ[gradientH, Automatic],
										collapseGradient[analyteGradient[[All, {1, 9}]]],
										gradientH
									];
									resolvedFlowRate = If[MatchQ[flowRate, Automatic],
										collapseGradient[analyteGradient[[All, {1, -1}]]],
										flowRate
									];

									(*finally resolve the gradient*)
									resolvedGradient = Which[
										MatchQ[gradient, Except[Automatic]], gradient,
										(*otherwise if the gradient is automatic and the injection table is set, should use that*)
										MatchQ[gradient, Automatic] && MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]], Download[injectionTableGradient, Object],
										(*otherwise, it should be a tuple*)
										True, analyteGradient
									];

									(* Resolve preInjectionEquilibrationTime for Blank and Standard*)
									resolvedPreInjectionEquilibrationTime = Which[

										(* Use user specified value if user specified something*)
										MatchQ[preInjectionEquilibrationTime, Except[Automatic]], preInjectionEquilibrationTime,

										(* Else if the instrument is Avant 150 we use 5 minute as the preinjectin equilibration time *)
										avant150Q,5Minute,

										(* In all other cases, resolve it to Null *)
										True, Null
									];

									(* Resolve the sample loop disconnect volume *)
									resolvedSampleLoopDisconnect=Switch[sampleLoopDisconnect,
										(* If automatic, we don't disconnect the sample loop, so pass through Null *)
										Alternatives[Automatic,Null],
										Null,

										(* Otherwise it's a volume that we can use directly *)
										_,
										sampleLoopDisconnect
									];


									(*return everything*)
									{
										analyteGradient,
										resolvedGradientA,
										resolvedGradientB,
										resolvedGradientC,
										resolvedGradientD,
										resolvedGradientE,
										resolvedGradientF,
										resolvedGradientG,
										resolvedGradientH,
										resolvedFlowRate,
										resolvedGradient,
										resolvedPreInjectionEquilibrationTime,
										gradientStartEndSpecifiedQ,
										gradientInjectionTableSpecifiedDifferentlyQ,
										invalidGradientCompositionQ,
										nonbinaryGradientQ,
										removedExtrasQ,
										gradientShortcutConflictQ,
										gradientStartEndBConflictQ,
										resolvedSampleLoopDisconnect
									}

								]
							],
							{gradientAs, gradientBs, gradientCs, gradientDs, gradientEs, gradientFs, gradientGs, gradientHs, gradients, gradientStarts, gradientEnds, gradientDurations, preInjectionEquilibrationTimes, flowRates, sampleLoopDisconnects, injectionTableGradientsCorrectLength}
					]]
				]
			]
		],
		{
			Join[Lookup[expandedStandardOptions, {
				StandardGradientA,
				StandardGradientB,
				StandardGradientC,
				StandardGradientD,
				StandardGradientE,
				StandardGradientF,
				StandardGradientG,
				StandardGradientH,
				StandardGradient,
				StandardGradientStart,
				StandardGradientEnd,
				StandardGradientDuration,
				StandardPreInjectionEquilibrationTime,
				StandardFlowRate,
				StandardSampleLoopDisconnect
			}], {injectionTableStandardGradients, Standard}],
			Join[Lookup[expandedBlankOptions, {
				BlankGradientA,
				BlankGradientB,
				BlankGradientC,
				BlankGradientD,
				BlankGradientE,
				BlankGradientF,
				BlankGradientG,
				BlankGradientH,
				BlankGradient,
				BlankGradientStart,
				BlankGradientEnd,
				BlankGradientDuration,
				BlankPreInjectionEquilibrationTime,
				BlankFlowRate,
				BlankSampleLoopDisconnect
			}], {injectionTableBlankGradients, Blank}]
		}
	];

	(* determine if ColumnPrime/ColumnFlush are explicitly excluded because the InjectionTable option doesn't include it *)
	(* if this is the case and they are explitly excluded, these Q values are True *)
	noColumnPrimeQ = MatchQ[specifiedInjectionTable, Except[Automatic | Null]] && MatchQ[Cases[specifiedInjectionTable, {ColumnPrime, __}], {}];
	noColumnFlushQ = MatchQ[specifiedInjectionTable, Except[Automatic | Null]] && MatchQ[Cases[specifiedInjectionTable, {ColumnFlush, __}], {}];

	(*we need to throw an error if there is no column prime in the injection table but the user specified it*)
	columnPrimeSetOptions={
		ColumnPrimeGradientA,
		ColumnPrimeGradientB,
		ColumnPrimeGradientC,
		ColumnPrimeGradientD,
		ColumnPrimeGradientE,
		ColumnPrimeGradientF,
		ColumnPrimeGradientG,
		ColumnPrimeGradientH,
		ColumnPrimeGradient,
		ColumnPrimeStart,
		ColumnPrimeEnd,
		ColumnPrimeDuration,
		ColumnPrimeFlowRate,
		ColumnPrimeFlowDirection
	};
	columnFlushSetOptions={
		ColumnFlushGradientA,
		ColumnFlushGradientB,
		ColumnFlushGradientC,
		ColumnFlushGradientD,
		ColumnFlushGradientE,
		ColumnFlushGradientF,
		ColumnFlushGradientG,
		ColumnFlushGradientH,
		ColumnFlushGradient,
		ColumnFlushStart,
		ColumnFlushEnd,
		ColumnFlushDuration,
		ColumnFlushFlowRate,
		ColumnFlushFlowDirection
	};

	(*check if the user has no column prime in the injection table, but defined options*)
	columnPrimeOptionInjectionTableOptions = If[Or@@Map[MatchQ[#,Except[Null|Automatic]]&,Lookup[roundedOptionsAssociation,columnPrimeSetOptions]] && noColumnPrimeQ && messagesQ,
		(
			Message[Error::ColumnPrimeOptionInjectionTableConflict,
				PickList[columnPrimeSetOptions,
					Map[MatchQ[#,Except[Null|Automatic]]&,Lookup[roundedOptionsAssociation,columnPrimeSetOptions]]
				]
			];
			PickList[columnPrimeSetOptions,
				Map[MatchQ[#,Except[Null|Automatic]]&,Lookup[roundedOptionsAssociation,columnPrimeSetOptions]]
			]
		),
		{}
	];
	columnPrimeOptionInjectionTableTest = If[gatherTests,
		Test["If InjectionTable is defined without a ColumnPrime entry, no column prime options are set:",
			Or@@Map[MatchQ[#,Except[Null|Automatic]]&,Lookup[roundedGradientOptions,columnPrimeSetOptions]] && noColumnPrimeQ ,
			False
		],
		Nothing
	];

	(*check if the user has no column flush in the injection table, but defined options*)
	columnFlushOptionInjectionTableOptions = If[Or@@Map[MatchQ[#,Except[Null|Automatic]]&,Lookup[roundedOptionsAssociation,columnFlushSetOptions]] && noColumnFlushQ && messagesQ,
		(
			Message[Error::ColumnFlushOptionInjectionTableConflict,
				PickList[columnFlushSetOptions,
					Map[MatchQ[#,Except[Null|Automatic]]&,Lookup[roundedOptionsAssociation,columnFlushSetOptions]]
				]
			];
			PickList[columnFlushSetOptions,
				Map[MatchQ[#,Except[Null|Automatic]]&,Lookup[roundedOptionsAssociation,columnFlushSetOptions]]
			]
		),
		{}
	];
	columnFlushOptionInjectionTableTest = If[gatherTests,
		Test["If InjectionTable is defined without a ColumnFlush entry, no column flush options are set:",
			Or@@Map[MatchQ[#,Except[Null|Automatic]]&,Lookup[roundedGradientOptions,columnFlushSetOptions]] && noColumnFlushQ ,
			False
		],
		Nothing
	];


	(* resolve the ColumnFlush/ColumnPrime gradients; almost the same as above, but not index matching options so one less level of mapping *)
	{
		{
			resolvedColumnPrimeAnalyticalGradient,
			resolvedColumnPrimeGradientA,
			resolvedColumnPrimeGradientB,
			resolvedColumnPrimeGradientC,
			resolvedColumnPrimeGradientD,
			resolvedColumnPrimeGradientE,
			resolvedColumnPrimeGradientF,
			resolvedColumnPrimeGradientG,
			resolvedColumnPrimeGradientH,
			resolvedColumnPrimeFlowRate,
			resolvedColumnPrimeGradient,
			resolvedColumnPrimePreInjectionEquilibrationTime,
			columnPrimeGradientStartEndSpecifiedQ,
			columnPrimeGradientInjectionTableSpecifiedDifferentlyBool,
			columnPrimeInvalidGradientCompositionBool,
			nonbinaryColumnPrimeGradientQ,
			removedExtraColumnPrimeGradientQ,
			columnPrimeGradientShortcutConflictBool,
			columnPrimeGradientStartEndBConflictBool
		},
		{
			resolvedColumnFlushAnalyticalGradient,
			resolvedColumnFlushGradientA,
			resolvedColumnFlushGradientB,
			resolvedColumnFlushGradientC,
			resolvedColumnFlushGradientD,
			resolvedColumnFlushGradientE,
			resolvedColumnFlushGradientF,
			resolvedColumnFlushGradientG,
			resolvedColumnFlushGradientH,
			resolvedColumnFlushFlowRate,
			resolvedColumnFlushGradient,
			resolvedColumnFlushPreInjectionEquilibrationTime,
			columnFlushGradientStartEndSpecifiedQ,
			columnFlushGradientInjectionTableSpecifiedDifferentlyBool,
			columnFlushInvalidGradientCompositionBool,
			nonbinaryColumnFlushGradientQ,
			removedExtraColumnFlushGradientQ,
			columnFlushGradientShortcutConflictBool,
			columnFlushGradientStartEndBConflictBool
		}
	} = Map[
		Function[{entry},
			Module[
				{gradientA, gradientB, gradientC, gradientD, gradientE, gradientF, gradientG, gradientH, gradient, gradientStart, gradientEnd,
					gradientDuration, preInjectionEquilibrationTime, flowRate, injectionTableGradientList, type, excludedFromInjectionTableQ},

				(*split up the entry variable*)
				{gradientA, gradientB, gradientC, gradientD, gradientE, gradientF, gradientG, gradientH, gradient, gradientStart, gradientEnd, gradientDuration, preInjectionEquilibrationTime, flowRate, injectionTableGradientList, type, excludedFromInjectionTableQ} = entry;

				(*first check whether these options are completely empty or Null (e.g. no column priming)*)
				(* defining "completely" empty or Null here as having at least one Null in GradientA/GradientB/Gradient/FlowRate and the rest being Automatic or {}, or if everything is Automatic/Null and ColumnPrime/Flush is not included in the injection table *)
				(*if we're doing the AKTA10, then no column prime nor flush*)
				If[
					Or[
						akta10Q,
						And[
							MatchQ[{gradientA, gradientB, gradientC, gradientD, gradientE, gradientF, gradientG, gradientH, gradient, preInjectionEquilibrationTime, gradientDuration, flowRate, injectionTableGradientList}, {(Null | {} | Automatic)..}],
							(excludedFromInjectionTableQ || MemberQ[{gradientA, gradientB, gradientC, gradientD, gradientE, gradientF, gradientG, gradientH, gradient, preInjectionEquilibrationTime, flowRate}, Null])
						]
					],
					(*in which case, we return all nulls and empties*)
					{Sequence @@ (List[gradient, gradientA, gradientB, gradientC, gradientD, gradientE, gradientF, gradientG, gradientH, flowRate, gradient, preInjectionEquilibrationTime]/.{Automatic->Null}), True, {}, {}, False, False, False, False},
					(*otherwise, we'll resolve the gradient and map through*)
					Module[
						{gradientInjectionTableSpecifiedDifferentlyQ, analyteGradientOptionTuple, defaultedAnalyteFlowRate, defaultGradient,protoAnalyteGradientOptionTuple,
						analyteGradient, invalidGradientCompositionQ, resolvedGradientA, resolvedGradientB, resolvedFlowRate, resolvedGradient, analyteGradientReturned, removedExtrasQ,
						nonbinaryGradientQ, resolvedGradientC, resolvedGradientD, semiResolvedGradientA,injectionTableGradient,gradientStartEndSpecifiedQ,gradientShortcutConflictQ, gradientStartEndBConflictQ,
						resolvedGradientStart, resolvedGradientEnd, semiResolvedGradientC, semiResolvedGradientE, semiResolvedGradientG, semiResolvedGradientB,
						semiResolvedGradientD, semiResolvedGradientF, semiResolvedGradientH, resolvedGradientE, resolvedGradientF, resolvedGradientG, resolvedGradientH,resolvedPreInjectionEquilibrationTime},

						(*make sure that the start end and duration options are either all specified or not *)
						gradientStartEndSpecifiedQ = MatchQ[{gradientStart, gradientEnd}, {PercentP, PercentP} | {Null,Null}];

						(*for flush and prime, we only consider the first instance if defined*)
						injectionTableGradient=If[MemberQ[ToList[injectionTableGradientList],ObjectP[Object[Method]]],
							FirstCase[ToList[injectionTableGradientList],ObjectP[Object[Method]]],
							injectionTableGradientList
						];

						(*check whether the shortcut options are specified and conflict with the other gradient option values *)
						gradientShortcutConflictQ=And[
							MatchQ[gradientDuration,TimeP],
							(* If there is duration, we must have Start/End pair or one of the A/B/C/D *)
							Xnor[
								MatchQ[{gradientStart, gradientEnd}, {PercentP, PercentP}],
								MemberQ[{gradientA,gradientB,gradientC,gradientD},Except[Automatic|Null]]
							]
						];

						(* If Start/End and B all exist, they must all be the same. Do not allow B as {TimeP,PercentP} *)
						gradientStartEndBConflictQ=Which[
							(* Ignore this error if we already give shortcut conflict error *)
							gradientShortcutConflictQ,False,
							MatchQ[gradientB,Automatic|Null],False,
							MatchQ[gradientStart,Automatic|Null]||MatchQ[gradientEnd,Automatic|Null],False,
							MatchQ[gradientB,PercentP],!(MatchQ[gradientStart,gradientB]&&MatchQ[gradientEnd,gradientB]),
							True,True
						];

						(* Extract or default GradientStart and GradientEnd values *)
						{resolvedGradientStart, resolvedGradientEnd} = Switch[{gradientStart, gradientEnd, gradientDuration},
							{PercentP, PercentP, _} | {Null, Null, Null | TimeP}, {gradientStart, gradientEnd},
							(* Default to gradientStart if something is wrong with gradientEnd *)
							{PercentP, _, _}, {gradientStart, gradientStart},
							(* Default to 0 if something is wrong with gradeintStart *)
							{_, PercentP, _}, {0 Percent, gradientEnd},
							(*otherwise, both Null*)
							_, {Null, Null}
						];

						(*check whether both gradient and the injection table are specified and are the same object*)
						gradientInjectionTableSpecifiedDifferentlyQ = If[MatchQ[gradient, ObjectP[Object[Method, Gradient]]] && MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]],
							Not[MatchQ[Download[gradient, Object], Download[injectionTableGradient, Object]]],
							False
						];

						(* If Gradient option is an object, pull Gradient value from packet *)
						protoAnalyteGradientOptionTuple = Which[
							MatchQ[gradient, ObjectP[Object[Method, Gradient]]], Lookup[fetchPacketFromFastAssoc[Download[gradient, Object], fastAssoc], Gradient],
							MatchQ[gradient, Automatic] && MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]], Lookup[fetchPacketFromFastAssoc[Download[injectionTableGradient, Object], fastAssoc], Gradient],
							(*if we just have two columns, expand to 8*)
							MatchQ[gradient,binaryGradientP], Transpose@Nest[Insert[#,Repeat[0 Percent,Length[gradient]], -2] &,Transpose@gradient, 6],
							(*if four columns, expand to 8*)
							MatchQ[gradient,gradientP], Transpose@Nest[Insert[#,Repeat[0 Percent,Length[gradient]], -2] &,Transpose@gradient, 4],
							True, gradient
						];

						(*if the flow rate was changed, we update that*)
						analyteGradientOptionTuple=If[MatchQ[flowRate, Except[Automatic]],
							ReplacePart[protoAnalyteGradientOptionTuple,Table[{x,-1}->flowRate,{x,1,Length[protoAnalyteGradientOptionTuple]}]],
							protoAnalyteGradientOptionTuple
						];

						(* Default FlowRate to option value, gradient tuple values (or, if given nothing else, pick from the resolved analyte gradients) *)
						defaultedAnalyteFlowRate = Which[
							MatchQ[flowRate, Except[Automatic]], flowRate,
							MatchQ[analyteGradientOptionTuple, expandedGradientP], analyteGradientOptionTuple[[All, {1, -1}]],
							True, resolvedAnalyteGradients[[1, 1, -1]]
						];

						(*create the default gradient based on the first resolved analyte gradient*)
						defaultGradient = First[resolvedAnalyteGradients];
						defaultGradient[[All, -1]] = ConstantArray[defaultedAnalyteFlowRate, Length[defaultGradient]];

						(*if gradient C is set, we want A to go to 0*)
						semiResolvedGradientA=If[MatchQ[gradientA,Automatic]&&MemberQ[{gradientC,gradientE,gradientG},GreaterP[0*Percent]],
							0 Percent,
							gradientA
						];
						semiResolvedGradientC=If[MatchQ[gradientC,Automatic]&&MemberQ[{gradientA,gradientE,gradientG},GreaterP[0*Percent]],
							0 Percent,
							gradientC
						];
						semiResolvedGradientE=If[MatchQ[gradientE,Automatic]&&MemberQ[{gradientA,gradientC,gradientG},GreaterP[0*Percent]],
							0 Percent,
							gradientE
						];
						semiResolvedGradientG=If[MatchQ[gradientG,Automatic]&&MemberQ[{gradientA,gradientC,gradientE},GreaterP[0*Percent]],
							0 Percent,
							gradientG
						];

						(*if gradient D, F, or H is set, we want H to go to 0*)
						semiResolvedGradientB=If[MatchQ[gradientB,Automatic]&&MemberQ[{gradientD,gradientF,gradientH},GreaterP[0*Percent]],
							0 Percent,
							gradientB
						];
						semiResolvedGradientD=If[MatchQ[gradientD,Automatic]&&MemberQ[{gradientB,gradientF,gradientH},GreaterP[0*Percent]],
							0 Percent,
							gradientD
						];
						semiResolvedGradientF=If[MatchQ[gradientF,Automatic]&&MemberQ[{gradientD,gradientB,gradientH},GreaterP[0*Percent]],
							0 Percent,
							gradientF
						];
						semiResolvedGradientH=If[MatchQ[gradientH,Automatic]&&MemberQ[{gradientD,gradientF,gradientB},GreaterP[0*Percent]],
							0 Percent,
							gradientH
						];

						(*finally run our helper resolution function depending on if we have ColumnPrime or ColumnFlush *)
						analyteGradientReturned = Which[
							(*if the analyte gradient is already fully informed, then we go with that*)
							MatchQ[analyteGradientOptionTuple,expandedGradientP],analyteGradientOptionTuple,
							Not[MatchQ[{analyteGradientOptionTuple, semiResolvedGradientA, semiResolvedGradientB, semiResolvedGradientC, semiResolvedGradientD, semiResolvedGradientE,
								semiResolvedGradientF, semiResolvedGradientG, semiResolvedGradientH}, {(Null | Automatic)..}]],
								resolveGradient[analyteGradientOptionTuple, semiResolvedGradientA, semiResolvedGradientB, semiResolvedGradientC, semiResolvedGradientD, semiResolvedGradientE,
									semiResolvedGradientF, semiResolvedGradientG, semiResolvedGradientH, defaultedAnalyteFlowRate, gradientStart, gradientEnd, gradientDuration, Null, Null],
							MatchQ[type, ColumnPrime],
								resolveGradient[defaultPrimeGradientFPLC[defaultedAnalyteFlowRate, resolvedAnalyteGradients[[1,1,2;;9]]], semiResolvedGradientA, semiResolvedGradientB, semiResolvedGradientC, semiResolvedGradientD, semiResolvedGradientE,
									semiResolvedGradientF, semiResolvedGradientG, semiResolvedGradientH, defaultedAnalyteFlowRate, gradientStart, gradientEnd, gradientDuration, Null, Null],
							MatchQ[type, ColumnFlush],
								resolveGradient[defaultFlushGradientFPLC[defaultedAnalyteFlowRate, resolvedAnalyteGradients[[1,1,2;;9]]], semiResolvedGradientA, semiResolvedGradientB, semiResolvedGradientC, semiResolvedGradientD, semiResolvedGradientE,
									semiResolvedGradientF, semiResolvedGradientG, semiResolvedGradientH, defaultedAnalyteFlowRate, gradientStart, gradientEnd, gradientDuration, Null, Null]
						];

						(*remove duplicate entries if need be*)
						analyteGradient=DeleteDuplicatesBy[analyteGradientReturned,First[#*1.] &];

						(*if it's not the same note that*)
						removedExtrasQ=If[MatchQ[analyteGradientOptionTuple,expandedGradientP],
							!MatchQ[1.*analyteGradientOptionTuple,1.*analyteGradient],
							!MatchQ[1.*analyteGradientReturned,1.*analyteGradient]
						];

						(*check whether the gradient composition adds up to 100 okay*)
						invalidGradientCompositionQ = Not[AllTrue[analyteGradient, (#[[2]] + #[[3]] + #[[4]] + #[[5]] + #[[6]] + #[[7]] + #[[8]] + #[[9]] == 100 Percent)&]];

						(*check whether the gradient is non binary, meaning that any of the tuples have both A and C or both B and D*)
						nonbinaryGradientQ = Or@@MapThread[
							Function[{aPercent, bPercent, cPercent, dPercent, ePercent, fPercent, gPercent, hPercent},
								Or[
									Count[{aPercent, cPercent, ePercent, gPercent},GreaterP[0 Percent]]>1,
									Count[{bPercent, dPercent, fPercent, hPercent},GreaterP[0 Percent]]>1
								]
							], Transpose@analyteGradient[[All, {2, 3, 4, 5, 6, 7, 8, 9}]]
						];

						(*now resolve all of the individual gradients and flow rate*)
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
						resolvedGradientE = If[MatchQ[gradientE, Automatic],
							collapseGradient[analyteGradient[[All, {1, 6}]]],
							gradientE
						];
						resolvedGradientF = If[MatchQ[gradientF, Automatic],
							collapseGradient[analyteGradient[[All, {1, 7}]]],
							gradientF
						];
						resolvedGradientG = If[MatchQ[gradientG, Automatic],
							collapseGradient[analyteGradient[[All, {1, 8}]]],
							gradientG
						];
						resolvedGradientH = If[MatchQ[gradientH, Automatic],
							collapseGradient[analyteGradient[[All, {1, 9}]]],
							gradientH
						];
						resolvedFlowRate = If[MatchQ[flowRate, Automatic],
							collapseGradient[analyteGradient[[All, {1, -1}]]],
							flowRate
						];

						(*finally resolve the gradient*)
						resolvedGradient = Which[
							MatchQ[gradient, Except[Automatic]], gradient,
							(*otherwise if the gradient is automatic and the injection table is set, should use that*)
							MatchQ[gradient, Automatic] && MatchQ[injectionTableGradient, ObjectP[Object[Method, Gradient]]], Download[injectionTableGradient, Object],
							(*otherwise, it should be a tuple*)
							True, analyteGradient
						];

						(* Resolve preInjectionEquilibrationTime for Blank and Standard*)
						resolvedPreInjectionEquilibrationTime = Which[

							(* Use user specified value if user specified something*)
							MatchQ[preInjectionEquilibrationTime, Except[Automatic]], preInjectionEquilibrationTime,

							(* Else if the instrument is Avant 150 we use 0 minute as the preinjectin equilibration time for column cleaning*)
							avant150Q,1Minute,

							(* In all other cases, resolve it to Null *)
							True, Null
						];


						(*return everything*)
						{
							analyteGradient,
							resolvedGradientA,
							resolvedGradientB,
							resolvedGradientC,
							resolvedGradientD,
							resolvedGradientE,
							resolvedGradientF,
							resolvedGradientG,
							resolvedGradientH,
							resolvedFlowRate,
							resolvedGradient,
							resolvedPreInjectionEquilibrationTime,
							gradientStartEndSpecifiedQ,
							gradientInjectionTableSpecifiedDifferentlyQ,
							invalidGradientCompositionQ,
							nonbinaryGradientQ,
							removedExtrasQ,
							gradientShortcutConflictQ,
							gradientStartEndBConflictQ
						}
					]
				]
			]
		],
		{
			Join[
				Lookup[roundedOptionsAssociation, {
					ColumnPrimeGradientA,
					ColumnPrimeGradientB,
					ColumnPrimeGradientC,
					ColumnPrimeGradientD,
					ColumnPrimeGradientE,
					ColumnPrimeGradientF,
					ColumnPrimeGradientG,
					ColumnPrimeGradientH,
					ColumnPrimeGradient,
					ColumnPrimeStart,
					ColumnPrimeEnd,
					ColumnPrimeDuration,
					ColumnPrimePreInjectionEquilibrationTime,
					ColumnPrimeFlowRate
				}],
				{injectionTableColumnPrimeGradients, ColumnPrime, noColumnPrimeQ}
			],
			Join[
				Lookup[roundedOptionsAssociation, {
					ColumnFlushGradientA,
					ColumnFlushGradientB,
					ColumnFlushGradientC,
					ColumnFlushGradientD,
					ColumnFlushGradientE,
					ColumnFlushGradientF,
					ColumnFlushGradientG,
					ColumnFlushGradientH,
					ColumnFlushGradient,
					ColumnFlushStart,
					ColumnFlushEnd,
					ColumnFlushDuration,
					ColumnFlushPreInjectionEquilibrationTime,
					ColumnFlushFlowRate
				}],
				{injectionTableColumnFlushGradients, ColumnFlush, noColumnFlushQ}
			]
		}
	];

	(* Resolve the FlowDirection options. Note that the sample's FlowDirection is not Automatic. *)
	(* FlowDirection is just set to Forward if not specified. *)
	resolvedStandardFlowDirection=If[standardExistsQ,
		Lookup[expandedStandardOptions, StandardFlowDirection]/.{Automatic->Forward},
		Null
	];
	resolvedBlankFlowDirection=If[blankExistsQ,
		Lookup[expandedBlankOptions, BlankFlowDirection]/.{Automatic->Forward},
		Null
	];
	resolvedColumnPrimeFlowDirection=Which[
		!MatchQ[Lookup[roundedOptionsAssociation,ColumnPrimeFlowDirection],Automatic],
		Lookup[roundedOptionsAssociation,ColumnPrimeFlowDirection],
		noColumnPrimeQ,
		Null,
		True,
		Forward
	];
	resolvedColumnFlushFlowDirection=Which[
		!MatchQ[Lookup[roundedOptionsAssociation,ColumnFlushFlowDirection],Automatic],
		Lookup[roundedOptionsAssociation,ColumnFlushFlowDirection],
		noColumnPrimeQ,
		Null,
		True,
		Forward
	];

	(*now do all of our gradient error checking*)

	(*check that none of the gradients were singletons*)
	anySingletonGradientsBool=Map[
		Function[{gradientList},
			MemberQ[Length/@gradientList,1]
		],
		{resolvedAnalyteGradients, resolvedStandardAnalyticalGradients, resolvedBlankAnalyticalGradients, {resolvedColumnPrimeAnalyticalGradient}, {resolvedColumnFlushAnalyticalGradient}}
	];

	(*if so, then get the offending options (and throw the error) *)
	anySingletonGradientOptions = If[And[Or@@anySingletonGradientsBool, messagesQ],
		PickList[{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}, anySingletonGradientsBool],
		{}
	];
	If[And[Or@@anySingletonGradientsBool, messagesQ],
		Message[Error::GradientSingleton, anySingletonGradientOptions]
	];

	(* generate the test testing for this issue *)
	anySingletonGradientTest = If[gatherTests,
		Test["If the gradient tuples are specified, there is more than one entry:",
			Or@@anySingletonGradientsBool,
			False
		],
		Nothing
	];

	(*any conflicts between the gradient start, end, or duration? (if so throw a message)*)

	gradientStartEndCheckingBool=Map[
		Not[And@@#]&,
		{
			gradientStartEndSpecifiedBool,
			standardGradientStartEndSpecifiedBool,
			blankGradientStartEndSpecifiedBool,
			{columnPrimeGradientStartEndSpecifiedQ},
			{columnFlushGradientStartEndSpecifiedQ}
		}
	];

	gradientStartEndSpecifiedAdverselyQ = MemberQ[gradientStartEndCheckingBool, True];
	gradientStartEndSpecifiedAdverselyOptions = If[gradientStartEndSpecifiedAdverselyQ && messagesQ,
		(
			Message[
				Error::GradientStartEndConflict,
				PickList[{{GradientStart,GradientEnd},{StandardGradientStart,StandardGradientEnd},{BlankGradientStart, BlankGradientEnd},{ColumnPrimeStart, ColumnPrimeEnd},{{ColumnFlushStart, ColumnFlushEnd}}},gradientStartEndCheckingBool],
				PickList[{"Sample","Standard","Blank","ColumnPrime","ColumnFlush"},gradientStartEndCheckingBool]
			];
			Flatten@PickList[
				{
					{GradientStart, GradientEnd},
					{StandardGradientStart, StandardGradientEnd},
					{BlankGradientStart, BlankGradientEnd},
					{ColumnPrimeStart, ColumnPrimeEnd},
					{ColumnFlushStart, ColumnFlushEnd}
				},
				gradientStartEndCheckingBool
			]
		),
		{}
	];
	gradientStartEndSpecifiedAdverselyTest = If[gatherTests,
		Test["If GradientStart, GradientEnd, and GradientDuration are specified, they are compatible:",
			gradientStartEndSpecifiedAdverselyQ,
			False
		],
		Nothing
	];

	(*check for collisions between the injection table and the gradient specifications*)

	(*which BlahGradient options conflict to the InjectionTable?*)
	gradientInjectionTableSpecifiedDifferentlyOptionsBool = Map[
		MemberQ[#, True] || TrueQ[#]&,
		{
			gradientInjectionTableSpecifiedDifferentlyBool,
			standardGradientInjectionTableSpecifiedDifferentlyBool,
			blankGradientInjectionTableSpecifiedDifferentlyBool,
			columnPrimeGradientInjectionTableSpecifiedDifferentlyBool,
			columnFlushGradientInjectionTableSpecifiedDifferentlyBool
		}
	];

	(*are any of these true*)
	gradientInjectionTableSpecifiedDifferentlyQ = MemberQ[gradientInjectionTableSpecifiedDifferentlyOptionsBool, True];

	(*if so, then get the offending options (and throw the error) *)
	gradientInjectionTableSpecifiedDifferentlyOptions = If[gradientInjectionTableSpecifiedDifferentlyQ && messagesQ,
		Append[PickList[{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}, gradientInjectionTableSpecifiedDifferentlyOptionsBool], InjectionTable],
		{}
	];
	If[messagesQ && gradientInjectionTableSpecifiedDifferentlyQ,
		Message[Error::InjectionTableGradientConflict, gradientInjectionTableSpecifiedDifferentlyOptions]
	];

	(* generate the test testing for this issue *)
	gradientInjectionTableSpecifiedDifferentlyTest = If[gatherTests,
		Test["If InjectionTable is specified as well as Gradient, StandardGradient, BlankGradient, ColumnFlushGradient, and/or ColumnPrimeGradient, they are compatible:",
			gradientInjectionTableSpecifiedDifferentlyQ,
			False
		],
		Nothing
	];

	(*check whether any of the gradients are defined as non-binary*)
	nonBinaryOptionBool = Map[
		MemberQ[#, True] || TrueQ[#]&,
		{
			nonbinaryGradientBool,
			nonbinaryStandardGradientBool,
			nonbinaryBlankGradientBool,
			nonbinaryColumnPrimeGradientQ,
			nonbinaryColumnFlushGradientQ
		}
	];

	(*are any of these true*)
	nonBinaryOptionQ = MemberQ[nonBinaryOptionBool, True];

	(*if so, then get the offending options (and throw the error) *)
	nonBinaryOptions = If[nonBinaryOptionQ && messagesQ,
		PickList[{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}, nonBinaryOptionBool],
		{}
	];
	If[messagesQ && nonBinaryOptionQ,
		Message[Error::NonBinaryFPLC, nonBinaryOptions]
	];

	(* generate the test testing for this issue *)
	nonBinaryGradientTest = If[gatherTests,
		Test["If Gradient, StandardGradient, BlankGradient, ColumnFlushGradient, and/or ColumnPrimeGradient are specified, the gradient values are all binary:",
			nonBinaryOptionQ,
			False
		],
		Nothing
	];

	(*check if we had to remove extra gradient tuples*)
	removedExtraOptionBool = Map[
		MemberQ[#, True] || TrueQ[#]&,
		{
			removedExtraBool,
			removedExtraStandardBool,
			removedExtraBlankBool,
			removedExtraColumnPrimeGradientQ,
			removedExtraColumnFlushGradientQ
		}
	];

	(*are any of these true*)
	removedExtraOptionQ = MemberQ[removedExtraOptionBool, True];

	(*if so, then get the offending options (and throw the error) *)
	removedExtraOptions = If[removedExtraOptionQ && messagesQ,
		PickList[{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}, removedExtraOptionBool],
		{}
	];
	If[messagesQ && removedExtraOptionQ,
		Message[Warning::RemovedExtraGradientEntries, removedExtraOptions]
	];

	(* generate the test testing for this issue *)
	removedExtraTest = If[gatherTests,
		Warning["If Gradient, StandardGradient, BlankGradient, ColumnFlushGradient, and/or ColumnPrimeGradient are specified, the gradient entries do not have duplicate times:",
			removedExtraOptionQ,
			False
		],
		Nothing
	];

	(*check if the gradient short cut options are conflicting*)
	gradientShortcutOverallBool = Map[
		MemberQ[#, True] || TrueQ[#]&,
		{
			gradientShortcutConflictBool,
			standardGradientShortcutConflictBool,
			blankGradientShortcutConflictBool,
			columnPrimeGradientShortcutConflictBool,
			columnFlushGradientShortcutConflictBool
		}
	];

	(*are any of these true*)
	gradientShortcutOverallQ = MemberQ[gradientShortcutOverallBool, True];

	(*if so, then get the offending options (and throw the error) *)
	gradientShortcutOptions = If[gradientShortcutOverallQ && messagesQ,
		Flatten@PickList[{
			{GradientStart, GradientEnd, GradientA, GradientB, GradientC, GradientD},
			{StandardGradientStart, StandardGradientEnd, StandardGradientA, StandardGradientB, StandardGradientC, StandardGradientD},
			{BlankGradientStart, BlankGradientEnd, BlankGradientA, BlankGradientB, BlankGradientC, BlankGradientD},
			{ColumnPrimeStart, ColumnPrimeEnd, ColumnPrimeGradientA, ColumnPrimeGradientB, ColumnPrimeGradientC, ColumnPrimeGradientD},
			{ColumnFlushStart, ColumnFlushEnd, ColumnFlushGradientA, ColumnFlushGradientB, ColumnFlushGradientC, ColumnFlushGradientD}
		},gradientShortcutOverallBool
		],
		{}
	];

	If[messagesQ && gradientShortcutOverallQ,
		Message[
			Error::GradientShortcutConflict,
			PickList[{GradientDuration,StandardGradientDuration,BlankGradientDuration,ColumnPrimeDuration,ColumnFlushDuration},gradientShortcutOverallBool],
			Flatten@PickList[{{GradientStart,GradientEnd},{StandardGradientStart,StandardGradientEnd},{BlankGradientStart,BlankGradientEnd},{ColumnPrimeStart,ColumnPrimeEnd},{ColumnFlushStart,ColumnFlushEnd}},gradientShortcutOverallBool],
			PickList[{"Gradient","StandardGradient","BlankGradient","ColumnPrimeGradient","ColumnFlushGradient"},gradientShortcutOverallBool]
		]
	];

	(* generate the test testing for this issue *)
	gradientShortcutTest = If[gatherTests,
		Test["If GradientDuration option is specified, GradientStart and GradientEnd cannot be specified with the corresponding Gradient A/B/C/D options:",
			gradientShortcutOverallQ,
			False
		],
		Nothing
	];

	(*check if the gradient start/end/B options are conflicting*)
	gradientStartEndBConflictOverallBool = Map[
		MemberQ[#, True] || TrueQ[#]&,
		{
			gradientStartEndBConflictBool,standardGradientStartEndBConflictBool,blankGradientStartEndBConflictBool,columnPrimeGradientStartEndBConflictBool,columnFlushGradientStartEndBConflictBool
		}
	];

	(*are any of these true*)
	gradientStartEndBConflictOverallQ = MemberQ[gradientStartEndBConflictOverallBool, True];

	If[messagesQ && gradientStartEndBConflictOverallQ && !engineQ,
		Message[
			Warning::GradientShortcutAmbiguity,
			Flatten@PickList[{{GradientStart,GradientEnd},{StandardGradientStart,StandardGradientEnd},{BlankGradientStart,BlankGradientEnd},{ColumnPrimeStart,ColumnPrimeEnd},{ColumnFlushStart,ColumnFlushEnd}},gradientStartEndBConflictOverallBool],
			PickList[{"Gradient","StandardGradient","BlankGradient","ColumnPrimeGradient","ColumnFlushGradient"},gradientStartEndBConflictOverallBool]
		]
	];

	(* generate the test testing for this issue *)
	gradientStartEndBConflictTests = If[gatherTests,
		Test["If GradientStart, GradientEnd and Gradient A/B/C/D options are specified, they must match each other:",
			gradientStartEndBConflictOverallQ,
			False
		],
		Nothing
	];

	(*check that all of the gradient compositions are okay (add up to 100%)*)

	(*which BlahGradient options conflict are invalid?*)
	invalidGradientCompositionOptionsBool = Map[
		MemberQ[#, True] || TrueQ[#]&,
		{
			invalidGradientCompositionBool,
			standardInvalidGradientCompositionBool,
			blankInvalidGradientCompositionBool,
			columnPrimeInvalidGradientCompositionBool,
			columnFlushInvalidGradientCompositionBool
		}
	];

	(*any of these true?*)
	invalidGradientCompositionEverythingQ = MemberQ[invalidGradientCompositionOptionsBool, True];

	(*if so, then get the offending options*)
	invalidGradientCompositionOptions = If[invalidGradientCompositionEverythingQ && messagesQ,
		(
			Message[Error::InvalidGradientComposition, PickList[{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}, invalidGradientCompositionOptionsBool]];
			PickList[{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}, invalidGradientCompositionOptionsBool]
		),
		{}
	];

	(* generate the test testing for this issue *)
	invalidGradientCompositionTest = If[gatherTests,
		Test["If Gradient, StandardGradient, BlankGradient, ColumnFlushGradient, and/or ColumnPrimeGradient are specified, they are valid gradients (add up to 100% for each time point):",
			invalidGradientCompositionEverythingQ,
			False
		],
		Nothing
	];

	(* check if any of the gradients are just too long (here being 1 week) *)
	maxGradientTimeLimit = 1 Week;

	{
		maxTimesSamples,
		maxTimesStandards,
		maxTimesBlanks,
		maxTimeColumnPrime,
		maxTimeColumnFlush
	}=Map[
		Function[{analyticalGradientList},
			If[!MatchQ[analyticalGradientList,ListableP[Null]],
				Map[
					Function[{gradientTuples},
						(*the last tuple point should be the max time*)
						gradientTuples[[-1,1]]
					],
					analyticalGradientList
				],
				{}
			]
		],
		{
			resolvedAnalyteGradients,
			resolvedStandardAnalyticalGradients,
			resolvedBlankAnalyticalGradients,
			List[resolvedColumnPrimeAnalyticalGradient],
			List[resolvedColumnFlushAnalyticalGradient]
		}
	];

	(*check if we have any gradients that are too long*)
	{
		maxTimeSampleQ,
		maxTimeStandardQ,
		maxTimeBlankQ,
		maxTimeColumnPrimeQ,
		maxTimeColumnFlushQ
	}=Map[
		Function[{maxTimeList},
			MemberQ[maxTimeList,GreaterP[maxGradientTimeLimit]]
		],
		{
			maxTimesSamples,
			maxTimesStandards,
			maxTimesBlanks,
			maxTimeColumnPrime,
			maxTimeColumnFlush
		}
	];

	(*do the error checking if need be*)

	(*any of these true?*)
	tooLongQ = MemberQ[{ maxTimeSampleQ, maxTimeStandardQ, maxTimeBlankQ, maxTimeColumnPrimeQ, maxTimeColumnFlushQ }, True];

	(*if so, then get the offending options*)
	tooLongOptions = If[tooLongQ && messagesQ,
		(
			Message[Error::GradientTooLong, PickList[{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}, { maxTimeSampleQ, maxTimeStandardQ, maxTimeBlankQ, maxTimeColumnPrimeQ, maxTimeColumnFlushQ }],maxGradientTimeLimit];
			PickList[{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}, { maxTimeSampleQ, maxTimeStandardQ, maxTimeBlankQ, maxTimeColumnPrimeQ, maxTimeColumnFlushQ }]
		),
		{}
	];

	(* generate the test testing for this issue *)
	tooLongTest = If[gatherTests,
		Test["If Gradient, StandardGradient, BlankGradient, ColumnFlushGradient, and/or ColumnPrimeGradient are specified, they do not exceed the maximum time limit:",
			tooLongQ,
			False
		],
		Nothing
	];

	(* Check FlowDirection to make sure it is not Reverse if using AKTA10 *)
	reverseDirectionConflictBools = Map[
		MemberQ[ToList[#],Reverse]&,
		{Lookup[roundedOptionsAssociation, FlowDirection],resolvedStandardFlowDirection, resolvedBlankFlowDirection, resolvedColumnPrimeFlowDirection, resolvedColumnFlushFlowDirection}
	];
	reverseDirectionConflictQ = If[avant25Q||avant150Q,
		False,
		Or@@reverseDirectionConflictBools
	];

	(*if so, then get the offending options*)
	reverseDirectionConflictOptions = If[reverseDirectionConflictQ && messagesQ,
		(
			Message[Error::ReverseFlowDirectionConflict];
			PickList[{FlowDirection, StandardFlowDirection, BlankFlowDirection, ColumnPrimeFlowDirection, ColumnFlushFlowDirection},reverseDirectionConflictBools,True]
		),
		{}
	];

	(* generate the test testing for this issue *)
	reverseDirectionTest = If[gatherTests,
		Test["Reverse flow direction is only available on Model[Instrument, FPLC, \"AKTA avant 150\"] and Model[Instrument, FPLC, \"AKTA avant 25\"]:",
			reverseDirectionConflictQ,
			False
		],
		Nothing
	];


	(* --- resolve the buffers --- *)

	(* get the method packets for all the gradients *)
	analyteGradientMethodPackets = Map[
		fetchPacketFromFastAssoc[Download[#, Object], fastAssoc]&,
		resolvedGradients
	];
	blankGradientMethodPackets = Map[
		fetchPacketFromFastAssoc[Download[#, Object], fastAssoc]&,
		resolvedBlankGradients
	];
	standardGradientMethodPackets = Map[
		fetchPacketFromFastAssoc[Download[#, Object], fastAssoc]&,
		resolvedStandardGradients
	];
	columnPrimeMethodPacket = If[MatchQ[resolvedColumnPrimeGradient, ObjectP[Object[Method, Gradient]]],
		fetchPacketFromFastAssoc[Download[resolvedColumnPrimeGradient, Object], fastAssoc],
		<||>
	];
	columnFlushMethodPacket = If[MatchQ[resolvedColumnFlushGradient, ObjectP[Object[Method, Gradient]]],
		fetchPacketFromFastAssoc[Download[resolvedColumnFlushGradient, Object], fastAssoc],
		<||>
	];

	(*combine all of the method packets together*)
	allMethodPackets=Cases[Flatten[
		List[
			analyteGradientMethodPackets,
			blankGradientMethodPackets,
			standardGradientMethodPackets,
			columnPrimeMethodPacket,
			columnFlushMethodPacket
		]
	],PacketP[Object[Method,Gradient]]];

	(*we also want to check whether it's even worth it for the auxillary buffers*)
	(*so we will check all of the analyte gradients to see if they use C, D, E, F, G, or H*)
	allTupledGradients=Join@@Cases[{
		resolvedAnalyteGradients,
		resolvedStandardAnalyticalGradients,
		resolvedBlankAnalyticalGradients,
		{resolvedColumnPrimeAnalyticalGradient},
		{resolvedColumnFlushAnalyticalGradient}
	},Except[Null|{Null}]];

	(*total everything to see if we're using those buffers*)
	totaledGradient=Total@Map[Total,allTupledGradients];

	(*see which of C through H are actually used*)
	{
		gradientCQ,
		gradientDQ,
		gradientEQ,
		gradientFQ,
		gradientGQ,
		gradientHQ
	}=Map[MatchQ[#, GreaterP[0 Percent]] &, totaledGradient[[4 ;; 9]]];


	(* resolve the Buffer options *)
	(* 1.) If it's specified go with it *)
	(* 2.) If it's is not specified, get it from the gradient if specified *)
	(* 3.) If it's not specified and there is no gradient, decide based on what the separation mode is *)
	resolvedBufferA = Which[
		MatchQ[Lookup[roundedOptionsAssociation, BufferA], Except[Automatic]], Lookup[roundedOptionsAssociation, BufferA],
		MemberQ[Lookup[allMethodPackets, BufferA,{}],ObjectP[Model[Sample]]],  FirstCase[Lookup[allMethodPackets, BufferA,{}], ObjectP[Model[Sample]]],
		MatchQ[resolvedSeparationMode, IonExchange], Model[Sample, StockSolution, "id:9RdZXvKBeEbJ"], (* Ion Exchange Buffer A Native *)
		True, Model[Sample, "Milli-Q water"]
	];

	(* update the Blanks option to use the resolved BufferA instead of the placeholder we used already *)
	resolvedBlank = Map[
		If[MatchQ[#1, defaultBlank],
			resolvedBufferA,
			#1
		]&,
		Lookup[expandedBlankOptions, Blank]
	];

	resolvedBufferB = Which[
		MatchQ[Lookup[roundedOptionsAssociation, BufferB], Except[Automatic]], Lookup[roundedOptionsAssociation, BufferB],
		MemberQ[Lookup[allMethodPackets, BufferB,{}],ObjectP[Model[Sample]]],  FirstCase[Lookup[allMethodPackets, BufferB,{}], ObjectP[Model[Sample]]],
		MatchQ[resolvedSeparationMode, IonExchange], Model[Sample, StockSolution, "id:8qZ1VWNmdLbb"], (* Ion Exchange Buffer B Native *)
		True, Model[Sample, "Milli-Q water"]
	];

	(*we only include the following buffers if they're being used for any of the gradients*)
	resolvedBufferC =  Which[
		MatchQ[Lookup[roundedOptionsAssociation, BufferC], Except[Automatic]], Lookup[roundedOptionsAssociation, BufferC],
		MemberQ[Lookup[allMethodPackets, BufferC,{}],ObjectP[Model[Sample]]],  FirstCase[Lookup[allMethodPackets, BufferC,{}], ObjectP[Model[Sample]]],
		gradientCQ, resolvedBufferA,
		True, Null
	];
	resolvedBufferD =  Which[
		MatchQ[Lookup[roundedOptionsAssociation, BufferD], Except[Automatic]], Lookup[roundedOptionsAssociation, BufferD],
		MemberQ[Lookup[allMethodPackets, BufferD,{}],ObjectP[Model[Sample]]],  FirstCase[Lookup[allMethodPackets, BufferD,{}], ObjectP[Model[Sample]]],
		gradientDQ, resolvedBufferB,
		True, Null
	];
	resolvedBufferE =  Which[
		MatchQ[Lookup[roundedOptionsAssociation, BufferE], Except[Automatic]], Lookup[roundedOptionsAssociation, BufferE],
		MemberQ[Lookup[allMethodPackets, BufferE,{}],ObjectP[Model[Sample]]],  FirstCase[Lookup[allMethodPackets, BufferE,{}], ObjectP[Model[Sample]]],
		gradientEQ, resolvedBufferA,
		True, Null
	];
	resolvedBufferF =  Which[
		MatchQ[Lookup[roundedOptionsAssociation, BufferF], Except[Automatic]], Lookup[roundedOptionsAssociation, BufferF],
		MemberQ[Lookup[allMethodPackets, BufferF,{}],ObjectP[Model[Sample]]],  FirstCase[Lookup[allMethodPackets, BufferF,{}], ObjectP[Model[Sample]]],
		gradientFQ, resolvedBufferB,
		True, Null
	];
	resolvedBufferG =  Which[
		MatchQ[Lookup[roundedOptionsAssociation, BufferG], Except[Automatic]], Lookup[roundedOptionsAssociation, BufferG],
		MemberQ[Lookup[allMethodPackets, BufferG,{}],ObjectP[Model[Sample]]],  FirstCase[Lookup[allMethodPackets, BufferG,{}], ObjectP[Model[Sample]]],
		gradientGQ, resolvedBufferA,
		True, Null
	];
	resolvedBufferH =  Which[
		MatchQ[Lookup[roundedOptionsAssociation, BufferH], Except[Automatic]], Lookup[roundedOptionsAssociation, BufferH],
		MemberQ[Lookup[allMethodPackets, BufferH,{}],ObjectP[Model[Sample]]],  FirstCase[Lookup[allMethodPackets, BufferH,{}], ObjectP[Model[Sample]]],
		gradientHQ, resolvedBufferB,
		True, Null
	];



	(* get the number of bufferAs and bufferBs *)
	allBufferAs = Cases[{resolvedBufferA, resolvedBufferC, resolvedBufferE, resolvedBufferG},ObjectP[]];

	allBufferBs = Cases[{resolvedBufferB, resolvedBufferD, resolvedBufferF, resolvedBufferH},ObjectP[]];

	(* get the maximum number of BufferA/BufferBs; for the old akta it's 1, and the new avants it's 4 *)
	maxNumBuffers = If[Not[avant150Q || avant25Q],
		1,
		4
	];

	(* figure out if we have too many bufferAs or too many bufferBs *)
	tooManyBufferAsQ = Length[allBufferAs] > maxNumBuffers;
	tooManyBufferBsQ = Length[allBufferBs] > maxNumBuffers;

	(* get the actual options that need to reduce the number of values *)
	badBufferOptions = Which[
		tooManyBufferAsQ && tooManyBufferBsQ, {BufferC, BufferD, BufferE, BufferF, BufferG, BufferH},
		tooManyBufferAsQ, {BufferC, BufferE, BufferG},
		tooManyBufferBsQ, {BufferD, BufferF, BufferH},
		True, {}
	];

	(* throw an error if we have too many BufferA or BufferB values *)
	tooManyBufferOptions = If[messagesQ && (tooManyBufferAsQ || tooManyBufferBsQ),
		(
			Message[Error::TooManyBuffers, resolvedInstrument, maxNumBuffers, badBufferOptions];
			badBufferOptions
		),
		{}
	];

	(* make a too-many-buffers test *)
	tooManyBufferTest = If[gatherTests,
		Test["No more than " <> ToString[maxNumBuffers] <> " BufferA, BufferB, BufferC, BufferD, BufferE, BufferF, BufferG, and BufferH values are specified:",
			tooManyBufferAsQ || tooManyBufferBsQ,
			False
		],
		Nothing
	];

	(* We have decided to remove filters from FPLC buffer caps due to bubbles. Then we want to warn users if their buffers are not pre-filtered as that may cause damage to their columns *)
	allBuffers=Join[allBufferAs,allBufferBs];

	(* Get the buffer's model packet and see if it was filtered *)
	allBufferFilteredQ=Map[
		Module[
			{modelPacket},
			modelPacket=If[MatchQ[#,ObjectP[Model]],
				fetchPacketFromCacheHPLC[#,cache],
				fetchModelPacketFromCacheHPLC[#,cache]
			];
			Which[
				(* If our sample does not have Model or if it is some reagent from manufacturer directly, let's assume user is taking care of filteration themselves before FPLC *)
				NullQ[modelPacket],True,
				!MatchQ[modelPacket,ObjectP[Model[Sample,StockSolution]]],True,
				(* If we have FilterMaterial or FilterSize, that basically means we filter it! *)
				MatchQ[Lookup[modelPacket,FilterMaterial,Null],Except[Null|$Failed]],True,
				MatchQ[Lookup[modelPacket,FilterSize,Null],Except[Null|$Failed]],True,
				(* Otherwise give warning *)
				True,False
			]
		]&,
		allBuffers
	];

	(* Throw warning if the buffer was not filtered *)
	If[MemberQ[allBufferFilteredQ,False]&&messagesQ,
		Message[Warning::FPLCBuffersNotFiltered, ToString@PickList[allBuffers,allBufferFilteredQ,False]];
	];

	(* Gather test for non-filtered buffers *)
	nonFilteredBufferTests = If[gatherTests,
		Warning["The buffers used in an FPLC experiment should be filtered prior to the experiment to avoid damage to the FPLC columns:",
			MemberQ[allBufferFilteredQ,False],
			False
		]
	];

	(* get the positions where BufferA clashes with the methods supplied*)

	{
		{
			bufferAClashBool,
			bufferBClashBool,
			bufferCClashBool,
			bufferDClashBool,
			bufferEClashBool,
			bufferFClashBool,
			bufferGClashBool,
			bufferHClashBool
		},
		{
			standardBufferAClashBool,
			standardBufferBClashBool,
			standardBufferCClashBool,
			standardBufferDClashBool,
			standardBufferEClashBool,
			standardBufferFClashBool,
			standardBufferGClashBool,
			standardBufferHClashBool
		},
		{
			blankBufferAClashBool,
			blankBufferBClashBool,
			blankBufferCClashBool,
			blankBufferDClashBool,
			blankBufferEClashBool,
			blankBufferFClashBool,
			blankBufferGClashBool,
			blankBufferHClashBool
		},
		{
			{columnPrimeBufferAClashQ},
			{columnPrimeBufferBClashQ},
			{columnPrimeBufferCClashQ},
			{columnPrimeBufferDClashQ},
			{columnPrimeBufferEClashQ},
			{columnPrimeBufferFClashQ},
			{columnPrimeBufferGClashQ},
			{columnPrimeBufferHClashQ}
		},
		{
			{columnFlushBufferAClashQ},
			{columnFlushBufferBClashQ},
			{columnFlushBufferCClashQ},
			{columnFlushBufferDClashQ},
			{columnFlushBufferEClashQ},
			{columnFlushBufferFClashQ},
			{columnFlushBufferGClashQ},
			{columnFlushBufferHClashQ}
		}
	}=Map[
		Function[{packetList},
			(*if we have an empty list, then just return an empty list*)
			If[Length[packetList]>0,
				Transpose@Map[
					Function[{potentialPacket},
						(*if there's no packet, then no worries for the rest of your days*)
						If[MatchQ[potentialPacket,Except[PacketP[Object[Method, Gradient]]]],
							Repeat[False,8],
							(*otherwise, check to see if it's same as the resolved, if not Null*)
							MapThread[
								Function[{bufferFromPacket,resolvedBuffer},
									!MatchQ[bufferFromPacket/.{x_Link:>Download[x,Object]},Null|ObjectP[resolvedBuffer]]
								],
								{
									Lookup[potentialPacket,{BufferA,BufferB,BufferC,BufferD,BufferE,BufferF,BufferG,BufferH}],
									{resolvedBufferA,resolvedBufferB,resolvedBufferC,resolvedBufferD,resolvedBufferE,resolvedBufferF,resolvedBufferG,resolvedBufferH}
								}
							]
						]
					],
					packetList
				],
				Repeat[{},8]
			]
		],
		{
			analyteGradientMethodPackets,
			standardGradientMethodPackets,
			blankGradientMethodPackets,
			{columnPrimeMethodPacket},
			{columnFlushMethodPacket}
		}
	];

	(* get the clashing option values for BufferA/BufferB etc.*)

	{
		{
			bufferAClashGradientValue,
			bufferBClashGradientValue,
			bufferCClashGradientValue,
			bufferDClashGradientValue,
			bufferEClashGradientValue,
			bufferFClashGradientValue,
			bufferGClashGradientValue,
			bufferHClashGradientValue
		},
		{
			blankBufferAClashGradientValue,
			blankBufferBClashGradientValue,
			blankBufferCClashGradientValue,
			blankBufferDClashGradientValue,
			blankBufferEClashGradientValue,
			blankBufferFClashGradientValue,
			blankBufferGClashGradientValue,
			blankBufferHClashGradientValue
		},
		{
			standardBufferAClashGradientValue,
			standardBufferBClashGradientValue,
			standardBufferCClashGradientValue,
			standardBufferDClashGradientValue,
			standardBufferEClashGradientValue,
			standardBufferFClashGradientValue,
			standardBufferGClashGradientValue,
			standardBufferHClashGradientValue
		},
		{
			columnPrimeBufferAClashGradientValue,
			columnPrimeBufferBClashGradientValue,
			columnPrimeBufferCClashGradientValue,
			columnPrimeBufferDClashGradientValue,
			columnPrimeBufferEClashGradientValue,
			columnPrimeBufferFClashGradientValue,
			columnPrimeBufferGClashGradientValue,
			columnPrimeBufferHClashGradientValue
		},
		{
			columnFlushBufferAClashGradientValue,
			columnFlushBufferBClashGradientValue,
			columnFlushBufferCClashGradientValue,
			columnFlushBufferDClashGradientValue,
			columnFlushBufferEClashGradientValue,
			columnFlushBufferFClashGradientValue,
			columnFlushBufferGClashGradientValue,
			columnFlushBufferHClashGradientValue
		}
	}=MapThread[Function[{clashBoolList,packetList},
		MapThread[
			Function[{clashingBool,bufferField},
				Download[Lookup[PickList[packetList, clashingBool], bufferField, {}], Object]
			],
			{
				clashBoolList,
				{
					BufferA,
					BufferB,
					BufferC,
					BufferD,
					BufferE,
					BufferF,
					BufferG,
					BufferH
				}
			}
		]],
		{
			{
				{
					bufferAClashBool,
					bufferBClashBool,
					bufferCClashBool,
					bufferDClashBool,
					bufferEClashBool,
					bufferFClashBool,
					bufferGClashBool,
					bufferHClashBool
				},
				{
					standardBufferAClashBool,
					standardBufferBClashBool,
					standardBufferCClashBool,
					standardBufferDClashBool,
					standardBufferEClashBool,
					standardBufferFClashBool,
					standardBufferGClashBool,
					standardBufferHClashBool
				},
				{
					blankBufferAClashBool,
					blankBufferBClashBool,
					blankBufferCClashBool,
					blankBufferDClashBool,
					blankBufferEClashBool,
					blankBufferFClashBool,
					blankBufferGClashBool,
					blankBufferHClashBool
				},
				{
					{columnPrimeBufferAClashQ},
					{columnPrimeBufferBClashQ},
					{columnPrimeBufferCClashQ},
					{columnPrimeBufferDClashQ},
					{columnPrimeBufferEClashQ},
					{columnPrimeBufferFClashQ},
					{columnPrimeBufferGClashQ},
					{columnPrimeBufferHClashQ}
				},
				{
					{columnFlushBufferAClashQ},
					{columnFlushBufferBClashQ},
					{columnFlushBufferCClashQ},
					{columnFlushBufferDClashQ},
					{columnFlushBufferEClashQ},
					{columnFlushBufferFClashQ},
					{columnFlushBufferGClashQ},
					{columnFlushBufferHClashQ}
				}
			},
			{
				analyteGradientMethodPackets,
				standardGradientMethodPackets,
				blankGradientMethodPackets,
				{columnPrimeMethodPacket},
				{columnFlushMethodPacket}
			}
		}
	];


	(* combine all the clash gradient values together *)
	allClashGradientValues = Join[
		bufferAClashGradientValue,
		bufferBClashGradientValue,
		bufferCClashGradientValue,
		bufferDClashGradientValue,
		bufferEClashGradientValue,
		bufferFClashGradientValue,
		bufferGClashGradientValue,
		bufferHClashGradientValue,
		blankBufferAClashGradientValue,
		blankBufferBClashGradientValue,
		blankBufferCClashGradientValue,
		blankBufferDClashGradientValue,
		blankBufferEClashGradientValue,
		blankBufferFClashGradientValue,
		blankBufferGClashGradientValue,
		blankBufferHClashGradientValue,
		standardBufferAClashGradientValue,
		standardBufferBClashGradientValue,
		standardBufferCClashGradientValue,
		standardBufferDClashGradientValue,
		standardBufferEClashGradientValue,
		standardBufferFClashGradientValue,
		standardBufferGClashGradientValue,
		standardBufferHClashGradientValue,
		columnPrimeBufferAClashGradientValue,
		columnPrimeBufferBClashGradientValue,
		columnPrimeBufferCClashGradientValue,
		columnPrimeBufferDClashGradientValue,
		columnPrimeBufferEClashGradientValue,
		columnPrimeBufferFClashGradientValue,
		columnPrimeBufferGClashGradientValue,
		columnPrimeBufferHClashGradientValue,
		columnFlushBufferAClashGradientValue,
		columnFlushBufferBClashGradientValue,
		columnFlushBufferCClashGradientValue,
		columnFlushBufferDClashGradientValue,
		columnFlushBufferEClashGradientValue,
		columnFlushBufferFClashGradientValue,
		columnFlushBufferGClashGradientValue,
		columnFlushBufferHClashGradientValue
	];

	(* get all the option value symbols together *)
	allClashOptions = Join[
		ConstantArray[BufferA, Length[bufferAClashGradientValue]],
		ConstantArray[BufferB, Length[bufferBClashGradientValue]],
		ConstantArray[BufferC, Length[bufferCClashGradientValue]],
		ConstantArray[BufferD, Length[bufferDClashGradientValue]],
		ConstantArray[BufferE, Length[bufferEClashGradientValue]],
		ConstantArray[BufferF, Length[bufferFClashGradientValue]],
		ConstantArray[BufferG, Length[bufferGClashGradientValue]],
		ConstantArray[BufferH, Length[bufferHClashGradientValue]],
		ConstantArray[BufferA, Length[blankBufferAClashGradientValue]],
		ConstantArray[BufferB, Length[blankBufferBClashGradientValue]],
		ConstantArray[BufferC, Length[blankBufferCClashGradientValue]],
		ConstantArray[BufferD, Length[blankBufferDClashGradientValue]],
		ConstantArray[BufferE, Length[blankBufferEClashGradientValue]],
		ConstantArray[BufferF, Length[blankBufferFClashGradientValue]],
		ConstantArray[BufferG, Length[blankBufferGClashGradientValue]],
		ConstantArray[BufferH, Length[blankBufferHClashGradientValue]],
		ConstantArray[BufferA, Length[standardBufferAClashGradientValue]],
		ConstantArray[BufferB, Length[standardBufferBClashGradientValue]],
		ConstantArray[BufferC, Length[standardBufferCClashGradientValue]],
		ConstantArray[BufferD, Length[standardBufferDClashGradientValue]],
		ConstantArray[BufferE, Length[standardBufferEClashGradientValue]],
		ConstantArray[BufferF, Length[standardBufferFClashGradientValue]],
		ConstantArray[BufferG, Length[standardBufferGClashGradientValue]],
		ConstantArray[BufferH, Length[standardBufferHClashGradientValue]],
		ConstantArray[BufferA, Length[columnPrimeBufferAClashGradientValue]],
		ConstantArray[BufferB, Length[columnPrimeBufferBClashGradientValue]],
		ConstantArray[BufferC, Length[columnPrimeBufferCClashGradientValue]],
		ConstantArray[BufferD, Length[columnPrimeBufferDClashGradientValue]],
		ConstantArray[BufferE, Length[columnPrimeBufferEClashGradientValue]],
		ConstantArray[BufferF, Length[columnPrimeBufferFClashGradientValue]],
		ConstantArray[BufferG, Length[columnPrimeBufferGClashGradientValue]],
		ConstantArray[BufferH, Length[columnPrimeBufferHClashGradientValue]],
		ConstantArray[BufferA, Length[columnFlushBufferAClashGradientValue]],
		ConstantArray[BufferB, Length[columnFlushBufferBClashGradientValue]],
		ConstantArray[BufferC, Length[columnFlushBufferCClashGradientValue]],
		ConstantArray[BufferD, Length[columnFlushBufferDClashGradientValue]],
		ConstantArray[BufferE, Length[columnFlushBufferEClashGradientValue]],
		ConstantArray[BufferF, Length[columnFlushBufferFClashGradientValue]],
		ConstantArray[BufferG, Length[columnFlushBufferGClashGradientValue]],
		ConstantArray[BufferH, Length[columnFlushBufferHClashGradientValue]]
	];

	(*throw a warning if we have any clashes*)
	If[messagesQ && Length[allClashOptions] > 0 && Not[engineQ],
		Message[Warning::BufferConflict, allClashOptions, ObjectToString[allClashSpecifications, Cache -> simulatedCache], ObjectToString[allClashGradientValues, Cache -> simulatedCache]]
	];


	(* make a warning test for whether the buffers conflict *)
	bufferClashWarnings = If[gatherTests,
		Module[{failingWarning, passingWarning, failingOptions, passingOptions, failingString, passingString},

			(* in this case, True means Yes, we are failing *)
			failingOptions = DeleteDuplicates[allClashOptions];
			passingOptions = Complement[
				{
					BufferA,
					BufferB,
					BufferC,
					BufferD,
					BufferE,
					BufferF,
					BufferG,
					BufferH
				},
				failingOptions
			];

			(* get the failing and passing string *)
			failingString = If[MatchQ[failingOptions, {}],
				Null,
				"The specified Buffers that correspond to " <> ToString[failingOptions] <> " match the buffers in their corresponding Gradient options:"
			];
			passingString = If[MatchQ[passingOptions, {}],
				Null,
				"The specified Buffers that correspond to " <> ToString[passingOptions] <> " match the buffers in their corresponding Gradient options:"
			];

			(* create a test for non-passing and passing inputs *)
			failingWarning = If[NullQ[failingString],
				Nothing,
				Warning[failingString,
					False,
					True
				]
			];
			passingWarning = If[NullQ[passingString],
				Nothing,
				Warning[passingString,
					True,
					True
				]
			];

			{failingWarning, passingWarning}
		],
		Nothing
	];

	(*now resolve the injection volumes*)

	(*we need to extract our the injection volume and type from the injection table*)
	injectionTableSampleInjectionVolumes = If[injectionTableSpecifiedQ && Not[injectionTableSampleConflictQ],
		Cases[specifiedInjectionTable, {Sample, _, _, injectionVolume_, _} :> injectionVolume],
		(*otherwise pad automatic*)
		ConstantArray[Automatic, Length[mySamples]]
	];
	injectionTableSampleInjectionTypes = If[injectionTableSpecifiedQ && Not[injectionTableSampleConflictQ],
		Cases[specifiedInjectionTable, {Sample, _, injectionType_, _, _} :> injectionType],
		(*otherwise pad automatic*)
		ConstantArray[Automatic, Length[mySamples]]
	];

	(* declare some global variables depending on what our instrument is *)
	maxInjectionVolume = Lookup[resolvedInstrumentModelPacket, MaxSampleVolume];

	(* get the dead volume; for whatever reason this isn't stored in the object space so need to hard code it here *)
	autosamplerDeadVolume = Which[
		avant25Q, 5 Microliter, (*note this is only true with the total recovery vial. high recovery and plate require more*)
		avant150Q, 1 Milliliter,
		True, 20 Microliter
	];

	(*look up the injection type*)
	injectionTypeLookup=Lookup[roundedOptionsAssociation,InjectionType];

	(* resolve the InjectionVolume option *)
	(* note that the trick here is that the old AKTA doens't have an autosampler, and also can't get arbitrarily-large injections *)
	(* thus, if we have an autosampler (i.e., the avants) and we're above the "max" injection volume, that's still fine (but you can't use the autosampler) *)
	(* I recognize that there is some irony in the fact that I'm only allowing something to go above the "max" injection volume only if it has an autosampler but in that context we're not actually using it *)
	resolvedInjectionVolumesNotRounded = MapThread[
		Function[{samplePacket, aliquotVolume, injectionVolume, injectionTableVolume},
			Which[
				(*user specified*)
				MatchQ[injectionVolume, VolumeP], injectionVolume,
				(*injectionTable specified*)
				MatchQ[injectionTableVolume, VolumeP], injectionTableVolume,
				(* we are aliquoting and know what the aliquot volume will be and it is less than the maximum autosampler injection volume, then go with that minus the dead volume *)
				MatchQ[aliquotVolume, GreaterP[0 * Microliter]],
					Min[aliquotVolume - autosamplerDeadVolume, maxInjectionVolume - autosamplerDeadVolume],
				MemberQ[injectionTypeLookup, FlowInjection | Superloop] && MatchQ[Lookup[samplePacket, Volume], VolumeP], 1 Milliliter,
				MatchQ[Lookup[roundedOptionsAssociation, SampleFlowRate], Except[ListableP[Automatic | Null]]] && MatchQ[Lookup[samplePacket, Volume], VolumeP], 1 Milliliter,
				MatchQ[Lookup[samplePacket, Volume], VolumeP], Min[Lookup[samplePacket, Volume], 10 Microliter],
				True, 10 Microliter
			]
		],
		{
			simulatedSamplePackets,
			Lookup[samplePrepOptions, AliquotAmount],
			Lookup[roundedOptionsAssociation, InjectionVolume],
			injectionTableSampleInjectionVolumes
		}
	];

	(* Lookup the specified SamplePumpWash option *)
	specifiedSamplePumpWash = Lookup[roundedOptionsAssociation, SamplePumpWash];

	(* make a helper function for resolving the injection type; this is used for the InjectionType, StandardInjectionType, and BlankInjectionType options *)
	resolveInjectionTypes[
		myInjectionVolume:(VolumeP|Automatic|Null),
		myInjectionTableInjectionType:(FPLCInjectionTypeP|Automatic),
		myInjectionType:(FPLCInjectionTypeP|Automatic|Null),
		mySampleLoopVolume:(VolumeP|Automatic|Null),
		mySampleFlowRate:(FlowRateP|Automatic|Null),
		myAvant25Q:BooleanP,
		mySamplePumpWash:{(BooleanP|Automatic|Null)...}
	]:=Which[
		MatchQ[myInjectionType, Except[Automatic]], myInjectionType,
		MatchQ[myInjectionTableInjectionType, Except[Automatic]], myInjectionTableInjectionType,
		(*if the injection volume is 10 mL and also we're using the avant 25s, then go with the superloop; you can use the autosampler for 10 mL for the 150s and so we'll resolve to that *)
		MatchQ[myInjectionVolume, 10 Milliliter] && myAvant25Q, Superloop,
		MatchQ[mySampleFlowRate, Except[Automatic | Null]], FlowInjection,
		MatchQ[myInjectionVolume, GreaterP[10 Milliliter]], FlowInjection,
		MatchQ[mySamplePumpWash, {___, True, ___}], FlowInjection,
		myAvant25Q && MatchQ[myInjectionVolume, GreaterP[1 Milliliter]], FlowInjection,
		True, Autosampler
	];

	(*we can resolve the injection type now too*)
	resolvedInjectionType = MapThread[
		Function[{injectionVolume, specifiedInjectionType, specifiedSampleFlowRate, injectionTableSampleInjectionType},
			resolveInjectionTypes[
				injectionVolume,
				injectionTableSampleInjectionType,
				specifiedInjectionType,
				Lookup[roundedOptionsAssociation, SampleLoopVolume],
				specifiedSampleFlowRate,
				avant25Q,
				specifiedSamplePumpWash
			]
		],
		{resolvedInjectionVolumesNotRounded, injectionTypeLookup, Lookup[roundedOptionsAssociation, SampleFlowRate], injectionTableSampleInjectionTypes}
	];

	(* resolve the SamplePumpWash option *)
	resolvedSamplePumpWash = Lookup[roundedOptionsAssociation, SamplePumpWash] /. {Automatic -> False};

	(*do the error checking for SamplePumpWash to see that there are no conflicts*)
	samplePumpWashConflicts = MapThread[
		#1 && MatchQ[#2, Autosampler|Superloop]&,
		{resolvedSamplePumpWash, resolvedInjectionType}
	];

	samplePumpWashConflictQ=Or@@samplePumpWashConflicts;
	samplePumpWashConflictPositions=Flatten[Position[samplePumpWashConflicts,True]];

	(* if there is a mismatch between the SamplePumpWash and injection type, note it *)
	samplePumpWashConflictOptions = If[messagesQ && samplePumpWashConflictQ,
		(
			Message[Error::SamplePumpWashConflict,samplePumpWashConflictPositions];
			{SamplePumpWash}
		),
		{}
	];
	samplePumpWashConflictTest = If[gatherTests,
		Test["SamplePumpWash must not be True when InjectionType does not contain FlowInjection:",
			samplePumpWashConflictQ,
			False
		],
		Nothing
	];

	(*can resolve the FlowInjectionPurgeCycle option too*)
	resolvedFlowInjectionPurgeCycle=Which[
		MatchQ[Lookup[roundedOptionsAssociation,FlowInjectionPurgeCycle],Except[Automatic]], Lookup[roundedOptionsAssociation,FlowInjectionPurgeCycle],

		(* Default this value to False and throw a warning to warn the user if FlowInjectionPurgeCycle is on*)
		MemberQ[resolvedInjectionType, FlowInjection|Superloop], False,

		True, Null
	];

	(*throw a warning to warn the user turn on FlowInjectionPurgeCycle *)
	If[messagesQ && TrueQ[Lookup[roundedOptionsAssociation,FlowInjectionPurgeCycle]],
		Message[Warning::FPLCFlowInjectionPurgeCycle]
	];

	(*do the error checking to see that there are no conflicts*)
	flowInjectionPurgeCycleConflictQ=Switch[{resolvedFlowInjectionPurgeCycle,resolvedInjectionType},
		{True,{Autosampler..}},True,
		_,False
	];

	(* if there is a mismatch between the sample loop volume and injection type, note it *)
	flowInjectionPurgeCycleConflictOptions = If[messagesQ && flowInjectionPurgeCycleConflictQ,
		(
			Message[Error::FlowInjectionPurgeCycleConflict];
			{FlowInjectionPurgeCycle}
		),
		{}
	];
	flowInjectionPurgeCycleConflictTest = If[gatherTests,
		Test["FlowInjectionPurgeCycle must not be True when InjectionType does not contain FlowInjection or Superloop:",
			flowInjectionPurgeCycleConflictQ,
			False
		],
		Nothing
	];

	(* round the resolved injection volume *)
	(* if we're using the 10 Milliliter superloop, then must be in increments of 0.01 Milliliter*)
	resolvedInjectionVolumes = MapThread[
		If[MatchQ[#1, Superloop],
			RoundOptionPrecision[#2, 10^-2 Milliliter],
			RoundOptionPrecision[#2, 10^-1 Microliter]
		]&,
		{resolvedInjectionType, resolvedInjectionVolumesNotRounded}
	];

	(* determine if any injection volumes were rounded *)
	roundedInjectionVolumes = MapThread[
		If[EqualQ[#1,#2],
			Nothing,
			#2
		]&,
		{resolvedInjectionVolumes, resolvedInjectionVolumesNotRounded}
	];

	(* make sure to throw a message indicating that the superloop can only take volumes in increments of 1 mL, and indicate which values were rounded *)
	If[MemberQ[resolvedInjectionType,Superloop] && Length[roundedInjectionVolumes]>0,
		If[messagesQ, Message[Warning::SuperloopInjectionVolumesRounded,roundedInjectionVolumes]]
	];

	(*go ahead and say what the sample loop should be for easy error checking*)
	sampleLoopShouldBe = Which[
		avant25Q && MemberQ[resolvedInjectionType, Autosampler], 2.5 Milliliter, (* TODO if we change the sample loop size this needs to change too; note that we can only have 50% of the max volume of the sample loop for the 25s *)
		avant150Q && MemberQ[resolvedInjectionType, Autosampler], 10 Milliliter,
		MemberQ[resolvedInjectionType, Autosampler], 1 Milliliter,
		(*no sample loop used for the flow injection*)
		MemberQ[resolvedInjectionType, Superloop], 10 Milliliter,
		(*otherwise, it's flow injection *)
		True, Null
	];

	(*resolve the sample loop volume*)
	resolvedSampleLoopVolume = If[MatchQ[Lookup[roundedOptionsAssociation, SampleLoopVolume], Except[Automatic]],
		Lookup[roundedOptionsAssociation, SampleLoopVolume],
		sampleLoopShouldBe
	];

	(* if there is a mismatch between the sample loop volume and injection type, note it *)
	loopInjectionConflictOptions = If[messagesQ && sampleLoopShouldBe!=resolvedSampleLoopVolume,
		(
			Message[Error::InjectionTypeLoopConflict];
			{InjectionType,SampleLoopVolume,Instrument}
		),
		{}
	];
	loopInjectionConflictTest = If[gatherTests,
		Test["If the SampleLoopVolume is specified, it's compatible with the Instrument and InjectionType:",
			sampleLoopShouldBe!=resolvedSampleLoopVolume,
			False
		],
		Nothing
	];

	(* SampleLoopDisconnection optin check *)
	(* Create a rule based on the injection types. *)
	injectionTypeRules = {Autosampler -> Automatic|Null|GreaterEqualP[0 Milliliter], FlowInjection -> Null|Automatic, Superloop -> Null|Automatic};

	(* Apply the rule to the provided injection types. *)
	resolvedInjectionTypePattern = resolvedInjectionType /.injectionTypeRules;

	(* Provided SampleLoopDisconnection option *)
	sampleLoopDisconnection = ToList[Lookup[roundedOptionsAssociation, SampleLoopDisconnect]];

	(* Check if the provided SampleLoopDisconnection is valid. *)
	sampleLoopDisconnectConflictQ = !MatchQ[sampleLoopDisconnection, resolvedInjectionTypePattern];

	(* If we have a problem, throw the error *)
	invalidSampleLoopDisconnectConflictOptions = If[sampleLoopDisconnectConflictQ && messagesQ,
		Message[Error::SampleLoopDisconnectOptionConflict,resolvedInjectionType,sampleLoopDisconnection];
		{InjectionType,SampleLoopDisconnect},
		{}
	];

	(* If we gather tests, output the test result. *)
	sampleLoopDisconnectConflictTest = If[gatherTests && sampleLoopDisconnectConflictQ,
		Test["If SampleLoopDisconnect volumes are specified, the autosampler injection type is index matched with the provided volume:",
			sampleLoopDisconnectConflictQ,
			False
		],
		Nothing
	];

	(* Throw a conflict if sample loop disconnect options are specified and the instrument is not the Avant 25/150 *)
	sampleLoopDisconnectInstrumentConflicts = If[Or[avant25Q,avant150Q],
		{
			{},
			{},
			{}
		},
		{
			Cases[ToList[Lookup[roundedOptionsAssociation,SampleLoopDisconnect]],GreaterEqualP[0 Milliliter]],
			Cases[ToList[Lookup[expandedStandardOptions,StandardSampleLoopDisconnect]],GreaterEqualP[0 Milliliter]],
			Cases[ToList[Lookup[expandedBlankOptions,BlankSampleLoopDisconnect]],GreaterEqualP[0 Milliliter]]
		}
	];

	(* Create the boolean *)
	sampleLoopDisconnectInstrumentConflictQ = !MatchQ[Flatten[sampleLoopDisconnectInstrumentConflicts],{}];

	(* If we have a problem, throw the error *)
	invalidSampleLoopDisconnectInstrumentConflictOptions = If[sampleLoopDisconnectInstrumentConflictQ && messagesQ,
		(
			Message[Error::SampleLoopDisconnectInstrumentOptionConflict,Cases[sampleLoopDisconnectInstrumentConflicts,Except[{}]],PickList[{SampleLoopDisconnect,StandardSampleLoopDisconnect,BlankSampleLoopDisconnect},sampleLoopDisconnectInstrumentConflicts,Except[{}]]];
			PickList[{SampleLoopDisconnect,StandardSampleLoopDisconnect,BlankSampleLoopDisconnect},sampleLoopDisconnectInstrumentConflicts,Except[{}]]
		),
		{}
	];

	sampleLoopDisconnectInstrumentConflictTest = If[gatherTests && sampleLoopDisconnectInstrumentConflictQ,
		Test["If SampleLoopDisconnect, StandardSampleLoopDisconnect or BlankSampleLoopDisconnect is specified, the instrument model must be Avant 25 or Avant 150:",
			sampleLoopDisconnectInstrumentConflictQ,
			False
		],
		Nothing
	];

	(* Warn if the sample loop disconnect volume is less than the sample loop volume plus autosampler tubing dead volume *)
	autosamplerTotalVolume=Plus[
		(* Volume of the tubing in the autosampler *)
		Lookup[resolvedInstrumentModelPacket,AutosamplerTubingDeadVolume]/.Null->0 Milliliter,

		(* Volume of the sample loop *)
		resolvedSampleLoopVolume
	];

	autosamplerLowFlushVolumes = If[Or[avant25Q,avant150Q]&&MemberQ[resolvedInjectionType,Autosampler],
		{
			Cases[PickList[ToList[Lookup[roundedOptionsAssociation,SampleLoopDisconnect]], resolvedInjectionType, Autosampler],LessP[autosamplerTotalVolume]],
			Cases[PickList[ToList[Lookup[expandedStandardOptions,StandardSampleLoopDisconnect]], resolvedStandardInjectionType, Autosampler],LessP[autosamplerTotalVolume]],
			Cases[PickList[ToList[Lookup[expandedBlankOptions,BlankSampleLoopDisconnect]], resolvedBlankInjectionType, Autosampler],LessP[autosamplerTotalVolume]]
		},
		{
			{},
			{},
			{}
		}
	];

	(* Create the boolean *)
	autosamplerLowFlushVolumesQ = !MatchQ[Flatten[autosamplerLowFlushVolumes],{}];

	(* If the volume is insufficent to flush out the whole autosampler sample loop, warn the user *)
	If[autosamplerLowFlushVolumesQ && messagesQ,
		Message[Warning::LowAutosamplerFlushVolume,Cases[autosamplerLowFlushVolumes,Except[{}]],PickList[{SampleLoopDisconnect,StandardSampleLoopDisconnect,BlankSampleLoopDisconnect},autosamplerLowFlushVolumes,Except[{}]],ObjectToString[Lookup[resolvedInstrumentModelPacket,Object],Cache->simulatedCache],autosamplerTotalVolume]
	];

	(*resolve the sample flow rates*)
	(* if we're using the autosampler or the superloop, then this doesn't matter and Null; otherwise, set to the first flow rate*)
	resolvedSampleFlowRates = MapThread[
		Function[{injType, sampleFlowRateCurrent, analyteGradients},
			Which[
				MatchQ[injType, Autosampler | Superloop], sampleFlowRateCurrent /. {Automatic -> Null},
				MatchQ[sampleFlowRateCurrent, Except[Automatic]], sampleFlowRateCurrent,
				True, analyteGradients[[1, -1]]
			]
		],
		{
			resolvedInjectionType,
			Lookup[roundedOptionsAssociation, SampleFlowRate],
			resolvedAnalyteGradients
		}
	];

	(*do we have a conflict with the injection type?*)
	sampleFlowRateConflictQs = MapThread[
		Or[
			MatchQ[#1, Except[FlowInjection]] && Not[NullQ[#2]],
			MatchQ[#1, FlowInjection] && NullQ[#2]
		]&,
		{resolvedInjectionType, resolvedSampleFlowRates}
	];

	(* gather options if need be*)
	sampleFlowRateConflictOptions = If[messagesQ && MemberQ[sampleFlowRateConflictQs, True],
		(
			Message[Error::SampleFlowRateConflict];
			{InjectionType,SampleFlowRate}
		),
		{}
	];
	sampleFlowRateConflictTest = If[gatherTests,
		Test["If the SampleFlowRate is specified, it's compatible with the Instrument and InjectionType:",
			MemberQ[sampleFlowRateConflictQs, True],
			False
		],
		Nothing
	];

	(*resolve the standard injection volumes*)
	(*we need to extract our the injection volume from the injection table*)
	injectionTableStandardInjectionVolumes = If[injectionTableSpecifiedQ,
		Cases[specifiedInjectionTable, {Standard, _, _, injectionVolume_, _} :> injectionVolume],
		(*otherwise pad automatic*)
		ConstantArray[Automatic, Length[resolvedStandard]]
	];
	injectionTableStandardInjectionTypes = If[injectionTableSpecifiedQ,
		Cases[specifiedInjectionTable, {Standard, _, injectionType_, _, _} :> injectionType],
		(*otherwise pad automatic*)
		ConstantArray[Automatic, Length[resolvedStandard]]
	];

	(* just use whatever injection volume we resolved above if we don't have it specified but at some point it uses the autosampler.  Otherwise updates to be 10% of the instrument's MaxSampleVolume *)
	(* doing this because it is kind of silly to use a standard not in the Autosampler and we don't want to just resolve to 1 Liter Standard injections if that's all we have in the resolvedInjectionVolumes *)
	specifiedStandardInjectionType = Lookup[expandedStandardOptions, StandardInjectionType];
	resolvedStandardInjectionVolumes = Which[
		Not[standardExistsQ], Null,
		Length[injectionTableStandardInjectionVolumes] == Length[Lookup[expandedStandardOptions, StandardInjectionVolume]],
			MapThread[
				Function[{injectionVolumeValue, injectionTableValue, specifiedStdInjType},
					Which[
						(*user specified*)
						MatchQ[injectionVolumeValue, VolumeP], injectionVolumeValue,
						(*injectionTable specified*)
						MatchQ[injectionTableValue, VolumeP], injectionTableValue,
						(* if InjectionType is specified and we have a sample that is also getting injected in the same way, pick that volume *)
						MemberQ[resolvedInjectionType, Autosampler] && MatchQ[specifiedStdInjType, Autosampler], First[PickList[resolvedInjectionVolumes, resolvedInjectionType, Autosampler]],
						(*otherwise default to 10% of the maximum that can be loaded onto the given instrument *)
						True, 0.1 * maxInjectionVolume
					]
				],
				{Lookup[expandedStandardOptions, StandardInjectionVolume], injectionTableStandardInjectionVolumes, specifiedStandardInjectionType}
			],
		True,
			MapThread[
				Function[{injectionVolumeValue, specifiedStdInjType},
					Which[
						VolumeQ[injectionVolumeValue], injectionVolumeValue,
						MemberQ[resolvedInjectionType, Autosampler] && MatchQ[specifiedStdInjType, Autosampler], First[PickList[resolvedInjectionVolumes, resolvedInjectionType, Autosampler]],
						True, 0.1 * maxInjectionVolume
					]
				],
				{Lookup[expandedStandardOptions, StandardInjectionVolume], specifiedStandardInjectionType}
			]
	];

	(* resolve the injection type for standards; this is probably going to be the Autosampler, but not necessarily if the StandardInjectionVolume is very large *)
	resolvedStandardInjectionType = Which[
		Not[standardExistsQ], Null,
		Length[injectionTableStandardInjectionTypes] == Length[specifiedStandardInjectionType],
			MapThread[
				Function[{standardInjectionVolume, standardInjectionType, injectionTableStandardInjectionType},
					resolveInjectionTypes[
						standardInjectionVolume,
						injectionTableStandardInjectionType,
						standardInjectionType,
						resolvedSampleLoopVolume,
						(* note that this is Null because we are automatically going to use the StandardFlowRate option for FlowInjection and so it having a value doesn't mean we want to auto-resolve to FlowInjection here *)
						Null,
						avant25Q,
						specifiedSamplePumpWash
					]
				],
				{resolvedStandardInjectionVolumes, specifiedStandardInjectionType, injectionTableStandardInjectionTypes}
			],
		True,
			MapThread[
				Function[{standardInjectionVolume, standardInjectionType},
					resolveInjectionTypes[
						standardInjectionVolume,
						Automatic,
						standardInjectionType,
						resolvedSampleLoopVolume,
						(* note that this is Null because we are automatically going to use the StandardFlowRate option for FlowInjection and so it having a value doesn't mean we want to auto-resolve to FlowInjection here *)
						Null,
						avant25Q,
						specifiedSamplePumpWash
					]
				],
				{resolvedStandardInjectionVolumes, specifiedStandardInjectionType}
			]
	];

	(* StandardSampleLoopDisconnect option check *)
	(* Apply the rule to the provided standard sample injection types. *)
	resolvedStandardInjectionTypePattern = If[standardExistsQ,
		resolvedStandardInjectionType /.injectionTypeRules];

	(* Provided StandardSampleLoopDisconnection option *)
	standardSampleLoopDisconnection = If[standardExistsQ,
		ToList[Lookup[expandedStandardOptions,StandardSampleLoopDisconnect]]];

	(* Check if the provided StandardSampleLoopDisconnection is valid. *)
	standardSampleLoopDisconnectConflictQ = If[standardExistsQ,
		!MatchQ[standardSampleLoopDisconnection, resolvedStandardInjectionTypePattern],
		False
	];

	(* If we have a problem, throw the error *)
	invalidStandardSampleLoopDisconnectConflictOptions = If[standardExistsQ && standardSampleLoopDisconnectConflictQ && messagesQ,
		Message[Error::StandardSampleLoopDisconnectOptionConflict,resolvedStandardInjectionType,standardSampleLoopDisconnection];
		{StandardInjectionType,StandardSampleLoopDisconnect},
		{}
	];

	(* If we gather tests, output the test result. *)
	standardSampleLoopDisconnectConflictTest = If[gatherTests && standardSampleLoopDisconnectConflictQ && standardExistsQ,
		Test["If StandardSampleLoopDisconnect volumes are specified, the autosampler injection type is index matched with the provided volume:",
			standardSampleLoopDisconnectConflictQ,
			False
		],
		Nothing
	];

	(*resolve the blank injection volumes*)
	(*we need to extract our the injection volume from the injection table*)
	injectionTableBlankInjectionVolumes = If[injectionTableSpecifiedQ,
		Cases[specifiedInjectionTable, {Blank, _, _, injectionVolume_, _} :> injectionVolume],
		(*otherwise pad automatic*)
		ConstantArray[Automatic, Length[resolvedBlank]]
	];
	injectionTableBlankInjectionTypes = If[injectionTableSpecifiedQ,
		Cases[specifiedInjectionTable, {Blank, _, injectionType_, _, _} :> injectionType],
		(*otherwise pad automatic*)
		ConstantArray[Automatic, Length[resolvedBlank]]
	];

	(* just use whatever injection volume we resolved above if we don't have it specified but at some point it uses the autosampler.  Otherwise updates to be 10% of the instrument's MaxSampleVolume *)
	(* doing this because it is kind of silly to use a blank not in the Autosampler and we don't want to just resolve to 1 Liter blank injections if that's all we have in the resolvedInjectionVolumes *)
	(* note that we want to remove the possibility for some MapThread errors in case the InjectionTable and blank fields are mismatched *)
	specifiedBlankInjectionType = Lookup[expandedBlankOptions, BlankInjectionType];
	resolvedBlankInjectionVolumes = Which[
		Not[blankExistsQ], Null,
		Length[injectionTableBlankInjectionVolumes] == Length[Lookup[expandedBlankOptions, BlankInjectionVolume]],
			MapThread[
				Function[{injectionVolumeValue, injectionTableValue, specifiedBlankInjType},
					Which[
						(*user specified*)
						MatchQ[injectionVolumeValue, VolumeP], injectionVolumeValue,
						(*injectionTable specified*)
						MatchQ[injectionTableValue, VolumeP], injectionTableValue,
						(* if InjectionType is specified and we have a sample that is also getting injected in the same way, pick that volume *)
						MemberQ[resolvedInjectionType, Autosampler] && MatchQ[specifiedBlankInjType, Autosampler], First[PickList[resolvedInjectionVolumes, resolvedInjectionType, Autosampler]],
						(*otherwise default to 10% of the maximum that can be loaded onto the given instrument *)
						True, 0.1 * maxInjectionVolume
					]
				],
				{Lookup[expandedBlankOptions, BlankInjectionVolume], injectionTableBlankInjectionVolumes, specifiedBlankInjectionType}
			],
		True,
			MapThread[
				Function[{injectionVolumeValue, specifiedBlankInjType},
					Which[
						VolumeQ[injectionVolumeValue], injectionVolumeValue,
						MemberQ[resolvedInjectionType, Autosampler] && MatchQ[specifiedBlankInjType, Autosampler], First[PickList[resolvedInjectionVolumes, resolvedInjectionType, Autosampler]],
						True, 0.1 * maxInjectionVolume
					]
				],
				{Lookup[expandedBlankOptions, BlankInjectionVolume], specifiedBlankInjectionType}
			]
	];

	(* resolve the injection type for standards; this is probably going to be the Autosampler, but not necessarily if the StandardInjectionVolume is very large *)
	resolvedBlankInjectionType = Which[
		Not[blankExistsQ], Null,
		Length[injectionTableBlankInjectionTypes] == Length[specifiedBlankInjectionType],
			MapThread[
				Function[{blankInjectionVolume, blankInjectionType, injectionTableBlankInjectionType},
					resolveInjectionTypes[
						blankInjectionVolume,
						injectionTableBlankInjectionType,
						blankInjectionType,
						resolvedSampleLoopVolume,
						(* note that this is Null because we are automatically going to use the BlankFlowRate option for FlowInjection and so it having a value doesn't mean we want to auto-resolve to FlowInjection here *)
						Null,
						avant25Q,
						specifiedSamplePumpWash
					]
				],
				{resolvedBlankInjectionVolumes, specifiedBlankInjectionType, injectionTableBlankInjectionTypes}
			],
		True,
			MapThread[
				Function[{blankInjectionVolume, blankInjectionType},
					resolveInjectionTypes[
						blankInjectionVolume,
						Automatic,
						blankInjectionType,
						resolvedSampleLoopVolume,
						(* note that this is Null because we are automatically going to use the BlankFlowRate option for FlowInjection and so it having a value doesn't mean we want to auto-resolve to FlowInjection here *)
						Null,
						avant25Q,
						specifiedSamplePumpWash
					]
				],
				{resolvedBlankInjectionVolumes, specifiedBlankInjectionType}
			]
	];

	(* BlankSampleLoopDisconnect option check *)
	(* Apply the rule to the provided blank sample injection types. *)
	resolvedBlankInjectionTypePattern = If[blankExistsQ,
		resolvedBlankInjectionType /.injectionTypeRules];

	(* Provided BlankSampleLoopDisconnection option *)
	blankSampleLoopDisconnection = If[blankExistsQ,
		ToList[Lookup[expandedBlankOptions,BlankSampleLoopDisconnect]]];

	(* Check if the provided BlankSampleLoopDisconnection is valid. *)
	blankSampleLoopDisconnectConflictQ = If[blankExistsQ,
		!MatchQ[blankSampleLoopDisconnection, resolvedBlankInjectionTypePattern],
		False
	];

	(* If we have a problem, throw the error *)
	invalidBlankSampleLoopDisconnectConflictOptions = If[blankExistsQ && blankSampleLoopDisconnectConflictQ && messagesQ,
		Message[Error::BlankSampleLoopDisconnectOptionConflict,resolvedBlankInjectionType,blankSampleLoopDisconnection];
		{BlankInjectionType,BlankSampleLoopDisconnect},
		{}
	];

	(* If we gather tests, output the test result. *)
	blankSampleLoopDisconnectConflictTest = If[gatherTests && blankSampleLoopDisconnectConflictQ && blankExistsQ,
		Test["If BlankSampleLoopDisconnect volumes are specified, the autosampler injection type is index matched with the provided volume:",
			blankSampleLoopDisconnectConflictQ,
			False
		],
		Nothing
	];

	(*finally we resolve our injection table using the helper function*)

	(* make a fake injection table that includes the column value as the 5th index *)
	fakeInjectionTable = If[MatchQ[specifiedInjectionTable, Null | Automatic],
		Null,
		{#[[1]], #[[2]], #[[3]], #[[4]], If[MatchQ[resolvedColumn, ObjectP[]], resolvedColumn, First[resolvedColumn]], #[[5]]}& /@ specifiedInjectionTable
	];

	(* get the InjectionTable Blank and Standard values *)
	injectionTableBlanks = If[MatchQ[specifiedInjectionTable, Null | Automatic],
		Null,
		Cases[fakeInjectionTable, {Blank, blank_, _, _, _, _} :> blank]
	];
	injectionTableStandards = If[MatchQ[specifiedInjectionTable, Null | Automatic],
		Null,
		Cases[fakeInjectionTable, {Standard, standard_, _, _, _, _} :> standard]
	];

	(*we also need to figure out if we're overwrite the gradients and supplying a new one*)
	{
		overwriteGradientsBool,
		overwriteStandardGradientsBool,
		overwriteBlankGradientsBool,
		{overwriteColumnPrimeGradientBool},
		{overwriteColumnFlushGradientBool}
	}=Map[
		Function[{listTuple},
			If[!MatchQ[listTuple[[1]],{}|Null],
				MapThread[
					Function[{resolvedGradientOption,fullGradientSpecified},
						If[MatchQ[resolvedGradientOption,ObjectP[Object[Method]]],
							(*check to see if the gradient was changed*)
							!MatchQ[fullGradientSpecified,
								Lookup[fetchPacketFromFastAssoc[resolvedGradientOption,fastAssoc],Gradient]
							],
							False
						]
					],
					{listTuple[[1]],listTuple[[2]]}
				]
			]
		],
		{
			{resolvedGradients,resolvedAnalyteGradients},
			{resolvedStandardGradients,resolvedStandardAnalyticalGradients},
			{resolvedBlankGradients,resolvedBlankAnalyticalGradients},
			{{resolvedColumnPrimeGradient},{resolvedColumnPrimeAnalyticalGradient}},
			{{resolvedColumnFlushGradient},{resolvedColumnFlushAnalyticalGradient}}
		}
	];

	(*Throw a warning whenever we're overwriting*)
	overwriteOptionBool=Map[
		Or@@#&,
		{
			overwriteGradientsBool,
			overwriteStandardGradientsBool,
			overwriteBlankGradientsBool,
			{overwriteColumnPrimeGradientBool},
			{overwriteColumnFlushGradientBool}
		}
	];

	(* if there is a mismatch between the Blank options and the injection table, throw an error *)
	If[messagesQ && Or@@overwriteOptionBool,
		Message[Warning::OverwritingGradient, PickList[{Gradient,StandardGradient,BlankGradient,ColumnPrimeGradient,ColumnFlushGradient},overwriteOptionBool]]
	];

	(*we must adjust the overwrite if the standards and blanks are imbalanced in the injection table*)
	adjustedOverwriteStandardBool=Which[
		Length[injectionTableStandardGradients] > Length[resolvedStandardGradients]&&!NullQ[injectionTableStandardGradients],PadRight[overwriteStandardGradientsBool,Length[injectionTableStandardGradients],False],
		Length[injectionTableStandardGradients] < Length[resolvedStandardGradients]&&!NullQ[injectionTableStandardGradients],Take[overwriteStandardGradientsBool,Length[injectionTableStandardGradients]],
		True,overwriteStandardGradientsBool
	];
	adjustedOverwriteBlankBool=Which[
		Length[injectionTableBlankGradients] > Length[resolvedBlankGradients]&&!NullQ[injectionTableBlankGradients],PadRight[overwriteBlankGradientsBool,Length[injectionTableBlankGradients],False],
		Length[injectionTableBlankGradients] < Length[resolvedBlankGradients]&&!NullQ[injectionTableBlankGradients],Take[overwriteBlankGradientsBool,Length[injectionTableBlankGradients]],
		True,overwriteBlankGradientsBool
	];

	(*we'll need to combine all of the relevant options for the injection table*)
	(* note that we are kind of cheating here for the Column value because the FPLC injection table doesn't actually _have_ columns,
     and so it doesn't actually matter what we put there, as long as it makes Karthik's great resolveInjectionTable function work properly (and then we will delete the injection table column afterwards) *)
	resolvedOptionsForInjectionTable = Association[
		Column -> ConstantArray[First[ToList[resolvedColumn]], Length[resolvedInjectionVolumes]],
		InjectionVolume -> resolvedInjectionVolumes,
		InjectionType -> resolvedInjectionType,
		Gradient -> resolvedGradients,
		Standard -> If[NullQ[injectionTableStandards] || Length[injectionTableStandards] == Length[resolvedStandard],
			resolvedStandard,
			injectionTableStandards
		],
		StandardColumn -> If[NullQ[injectionTableStandards],
			ConstantArray[First[ToList[resolvedColumn]], Length[resolvedStandard]],
			ConstantArray[First[ToList[resolvedColumn]], Length[injectionTableStandards]]
		],
		StandardFrequency -> resolvedStandardFrequency,
		StandardInjectionVolume -> If[NullQ[injectionTableStandardInjectionVolumes] || Length[injectionTableStandardInjectionVolumes] == Length[resolvedStandardInjectionVolumes],
			resolvedStandardInjectionVolumes,
			injectionTableStandardInjectionVolumes
		],
		StandardInjectionType -> If[NullQ[injectionTableStandardInjectionTypes] || Length[injectionTableStandardInjectionTypes] == Length[resolvedStandardInjectionType],
			resolvedStandardInjectionType,
			injectionTableStandardInjectionTypes
		],
		StandardGradient -> If[NullQ[injectionTableStandardGradients] || Length[injectionTableStandardGradients] == Length[resolvedStandardGradients],
			resolvedStandardGradients,
			injectionTableStandardGradients
		],
		Blank -> If[NullQ[injectionTableBlanks] || Length[injectionTableBlanks] == Length[resolvedBlank],
			resolvedBlank,
			injectionTableBlanks
		],
		BlankColumn -> If[NullQ[injectionTableBlanks],
			ConstantArray[First[ToList[resolvedColumn]], Length[resolvedBlank]],
			ConstantArray[First[ToList[resolvedColumn]], Length[injectionTableBlanks]]
		],
		BlankFrequency -> resolvedBlankFrequency,
		BlankInjectionVolume -> If[NullQ[injectionTableBlankInjectionVolumes] || Length[injectionTableBlankInjectionVolumes] == Length[resolvedBlankInjectionVolumes],
			resolvedBlankInjectionVolumes,
			injectionTableBlankInjectionVolumes
		],
		BlankInjectionType -> If[NullQ[injectionTableBlankInjectionTypes] || Length[injectionTableBlankInjectionTypes] == Length[resolvedBlankInjectionType],
			resolvedBlankInjectionType,
			injectionTableBlankInjectionTypes
		],
		BlankGradient -> If[NullQ[injectionTableBlankGradients] || Length[injectionTableBlankGradients] == Length[resolvedBlankGradients],
			resolvedBlankGradients,
			injectionTableBlankGradients
		],
		ColumnRefreshFrequency -> If[!akta10Q, resolvedColumnRefreshFrequency, None],
		ColumnPrimeGradient -> Replace[resolvedColumnPrimeGradient, x:ObjectP[] :> Download[x, Object], {1}],
		ColumnFlushGradient -> Replace[resolvedColumnFlushGradient, x:ObjectP[] :> Download[x, Object], {1}],
		InjectionTable -> fakeInjectionTable,
		GradientOverwrite->overwriteGradientsBool,
		BlankGradientOverwrite->adjustedOverwriteBlankBool,
		StandardGradientOverwrite->adjustedOverwriteStandardBool,
		ColumnFlushGradientOverwrite->overwriteColumnPrimeGradientBool,
		ColumnPrimeOverwrite->overwriteColumnFlushGradientBool
	];

	(*call our shared helper function*)
	{{resolvedInjectionTableResult, invalidInjectionTableOptions}, invalidInjectionTableTests} = If[gatherTests,
		resolveInjectionTable[mySamples, resolvedOptionsForInjectionTable, ExperimentFPLC, Object[Method, Gradient], Output -> {Result, Tests}],
		{resolveInjectionTable[mySamples, resolvedOptionsForInjectionTable, ExperimentFPLC, Object[Method, Gradient]], {}}
	];
	resolvedInjectionTableWithColumns = Lookup[resolvedInjectionTableResult, InjectionTable];

	(* delete the Column...column of the injection table *)
	resolvedInjectionTable = resolvedInjectionTableWithColumns[[All, {1, 2, 3, 4, 6}]];

	(* get the resolved values from the injection table *)
	resolvedInjectionTableBlanks = Cases[resolvedInjectionTable, {Blank, blank_, _, _, _} :> blank];
	resolvedInjectionTableBlankInjectionTypes = Cases[resolvedInjectionTable, {Blank, _, injectionType_, _, _} :> injectionType];
	resolvedInjectionTableBlankInjectionVolumes = Cases[resolvedInjectionTable, {Blank, _, _, injectionVolume_, _} :> injectionVolume];
	resolvedInjectionTableBlankGradients = Cases[resolvedInjectionTable, {Blank, _, _, _, gradient_} :> gradient];

	(* is there something in the injection table that doesn't match what is specified in the options? *)
	foreignBlanksQ = If[injectionTableSpecifiedQ&&NullQ[resolvedBlankFrequency] && Not[MatchQ[Lookup[expandedBlankOptions, blankOptionNames], {ListableP[Null | Automatic]..}]],
		Or[
			(* make sure there are not blanks specified in the injection table but not the options (or vice versa) *)
			Length[DeleteCases[Download[resolvedBlank, Object, Cache -> cache], Null | Alternatives @@ Download[resolvedInjectionTableBlanks, Object, Cache -> cache]]] > 0,
			Length[DeleteCases[Download[resolvedInjectionTableBlanks, Object, Cache -> cache], Null | Alternatives @@ Download[resolvedBlank, Object, Cache -> cache]]] > 0,
			(* make sure there are not blank injection volumes specified in the injection table but not the options (or vice versa) *)
			Length[DeleteCases[resolvedBlankInjectionVolumes, Null | Alternatives @@ resolvedInjectionTableBlankInjectionVolumes]] > 0,
			Length[DeleteCases[resolvedBlankInjectionType, Null | Alternatives @@ resolvedInjectionTableBlankInjectionTypes]] > 0,
			Length[DeleteCases[resolvedInjectionTableBlankInjectionTypes, Null | Alternatives @@ resolvedBlankInjectionType]] > 0,
			Length[DeleteCases[resolvedInjectionTableBlankInjectionVolumes, Null | Alternatives @@ resolvedBlankInjectionVolumes]] > 0,
			(* for gradients, can't really cross-check everything so just make sure they have the same length *)
			Length[resolvedInjectionTableBlankGradients] != Length[resolvedBlankGradients]
		],
		False
	];

	(* if there is a mismatch between the Blank options and the injection table, throw an error *)
	foreignBlankOptions = If[messagesQ && foreignBlanksQ,
		(
			Message[Error::InjectionTableForeignBlanks, ObjectToString[blankOptionNames]];
			blankOptionNames
		),
		{}
	];

	(* make a test for the blank injection table options *)
	foreignBlankTest = If[gatherTests,
		Test["If any blank options are specified, they must agree with the values specified in the InjectionTable:",
			foreignBlanksQ,
			False
		],
		Nothing
	];

	(* get the resolved values from the injection table *)
	resolvedInjectionTableStandards = Cases[resolvedInjectionTable, {Standard, standard_, _, _, _} :> standard];
	resolvedInjectionTableStandardInjectionTypes = Cases[resolvedInjectionTable, {Standard, _, injectionType_, _, _} :> injectionType];
	resolvedInjectionTableStandardInjectionVolumes = Cases[resolvedInjectionTable, {Standard, _, _, injectionVolume_, _} :> injectionVolume];
	resolvedInjectionTableStandardGradients = Cases[resolvedInjectionTable, {Standard, _, _, _, gradient_} :> gradient];

	(* is there something in the injection table that doesn't match what is specified in the options? *)
	foreignStandardsQ = If[injectionTableSpecifiedQ&&NullQ[resolvedStandardFrequency] && Not[MatchQ[Lookup[expandedStandardOptions, standardOptionNames], {(Null | Automatic)..}]],
		Or[
			(* make sure there are not standards specified in the injection table but not the options (or vice versa) *)
			Length[DeleteCases[Download[resolvedStandard, Object, Cache -> cache], Null | Alternatives @@ Download[resolvedInjectionTableStandards, Object, Cache -> cache]]] > 0,
			Length[DeleteCases[Download[resolvedInjectionTableStandards, Object, Cache -> cache], Null | Alternatives @@ Download[resolvedStandard, Object, Cache -> cache]]] > 0,
			(* make sure there are not standard injection volumes specified in the injection table but not the options (or vice versa) *)
			Length[DeleteCases[resolvedStandardInjectionType, Null | Alternatives @@ resolvedInjectionTableStandardInjectionTypes]] > 0,
			Length[DeleteCases[resolvedInjectionTableStandardInjectionTypes, Null | Alternatives @@ resolvedStandardInjectionType]] > 0,
			Length[DeleteCases[resolvedStandardInjectionVolumes, Null | Alternatives @@ resolvedInjectionTableStandardInjectionVolumes]] > 0,
			Length[DeleteCases[resolvedInjectionTableStandardInjectionVolumes, Null | Alternatives @@ resolvedStandardInjectionVolumes]] > 0,
			(* for gradients, can't really cross-check everything so just make sure they have the same length *)
			Length[resolvedInjectionTableStandardGradients] != Length[resolvedStandardGradients]
		],
		False
	];

	(* if there is a mismatch between the Standard options and the injection table, throw an error *)
	foreignStandardOptions = If[messagesQ && foreignStandardsQ,
		(
			Message[Error::InjectionTableForeignStandards, ObjectToString[standardOptionNames]];
			standardOptionNames
		),
		{}
	];

	(* make a test for the standard injection table options *)
	foreignStandardTest = If[gatherTests,
		Test["If any standard options are specified, they must agree with the values specified in the InjectionTable:",
			foreignStandardsQ,
			False
		],
		Nothing
	];

	(* combine all the injection volumes and injection types *)
	allInjectionVolumes = Cases[Flatten[{resolvedInjectionVolumes, resolvedBlankInjectionVolumes, resolvedStandardInjectionVolumes}], VolumeP];
	allInjectionTypes = Cases[Flatten[{resolvedInjectionType, resolvedBlankInjectionType, resolvedStandardInjectionType}], FPLCInjectionTypeP];

	(* can't mix and match Superloop with the other injection types *)
	superloopMixedAndMatched = MemberQ[allInjectionTypes, Superloop] && Not[MatchQ[allInjectionTypes, {Superloop..}]];
	superloopMixedAndMatchedOptions = If[messagesQ && superloopMixedAndMatched,
		(
			Message[Error::SuperloopMixedAndMatched];
			{InjectionType, BlankInjectionType, StandardInjectionType}
		),
		{}
	];
	superloopMixedAndMatchedTest = If[gatherTests,
		Test["InjectionType/BlankInjectionType/StandardInjectionType are not set to both Superloop and Autosampler/FlowInjection:",
			superloopMixedAndMatched,
			False
		],
		Nothing
	];

	(* pull out the email, upload, and parentProtocol options *)
	{email, upload, parentProtocol} = Lookup[myOptions, {Email, Upload, ParentProtocol}];

	(* get the resolved Email option; for this experiment, the default is True if it's a parent protocol, and False if it's a sub or Upload -> False *)
	resolvedEmail = Which[
		MatchQ[email, Except[Automatic]], email,
		MatchQ[email, Automatic] && NullQ[Lookup[roundedOptionsAssociation, ParentProtocol]] && TrueQ[upload] && MemberQ[output, Result], True,
		True, False
	];

	(* --- Resolve the fraction collection options --- *)

	(* Set list of all fraction collection options so we can automatically resolve CollectFractions
    based on if any are specified; need the hard coded list because we can't quite use the same Standard/Blank trick above because not fraction collection options start with FractionCollection *)
	fractionCollectionOptionNames = {
		CollectFractions,
		FractionCollectionTemperature,
		FractionCollectionMethod,
		FractionCollectionStartTime,
		FractionCollectionEndTime,
		FractionCollectionMode,
		MaxFractionVolume,
		MaxCollectionPeriod,
		AbsoluteThreshold,
		PeakSlope,
		PeakSlopeEnd,
		PeakMinimumDuration,
		PeakEndThreshold
	};

	(* get the specified FractionCollectionTemperature option and the option names without it (since that one is not automatically resolved) *)
	specifiedFractionCollectionTemperature = Lookup[roundedOptionsAssociation, FractionCollectionTemperature];
	indexMatchingFractionCollectionOptions = DeleteCases[fractionCollectionOptionNames, FractionCollectionTemperature];

	(* resolve the CollectFractions booleans from: *)
	(* 1.) option value *)
	(* 2.) Scale *)
	(* 3.) If any other fraction collection options are specified, resolve to True *)
	collectFractions = MapThread[
		Which[
			BooleanQ[#1], #1,
			MatchQ[scale, Preparative], True,
			MemberQ[#2, Except[(Null | Automatic)]] || TemperatureQ[specifiedFractionCollectionTemperature], True,
			True, False
		]&,
		{
			Lookup[roundedOptionsAssociation, CollectFractions],
			Transpose[Lookup[roundedOptionsAssociation, indexMatchingFractionCollectionOptions]]
		}
	];

	(* get the options that are specified even if CollectFractions -> False *)
	noCollectionSpecifiedOptions = DeleteDuplicates[Flatten[{
		If[MemberQ[collectFractions, False] && TemperatureQ[specifiedFractionCollectionTemperature], FractionCollectionTemperature, Nothing],
		MapThread[
			If[#1,
				{},
				PickList[indexMatchingFractionCollectionOptions, #2, Except[(Null | False | Automatic)]]
			]&,
			{
				collectFractions,
				Transpose[Lookup[roundedOptionsAssociation, indexMatchingFractionCollectionOptions]]
			}

		]
	}]];

	(*do we have more than one option? if so throw a warning*)
	If[Length[noCollectionSpecifiedOptions] > 0 && messagesQ && Not[engineQ],
		Message[Warning::ConflictFractionOptionSpecification, ObjectToString[noCollectionSpecifiedOptions]]
	];
	noCollectionSpecifiedTest = If[gatherTests,
		Warning["If CollectFractions -> False, no other fraction collection options are specified:",
			MatchQ[noCollectionSpecifiedOptions, {}],
			True
		],
		Nothing
	];

	(* pull out the fraction collection method *)
	fractionCollectionMethod = Lookup[roundedOptionsAssociation, FractionCollectionMethod];

	(* get the fraction collection method packets *)
	fractionCollectionPackets = Map[
		If[NullQ[#],
			Null,
			fetchPacketFromFastAssoc[Download[#, Object], fastAssoc]
		]&,
		fractionCollectionMethod
	];

	(* get the fraction temperatures in the method packets; Nothing-ing the Nulls since those become Ambient *)
	fractionCollectionMethodTemperatures = Map[
		If[NullQ[#] || NullQ[Lookup[#, FractionCollectionTemperature]],
			Nothing,
			Lookup[#, FractionCollectionTemperature]
		]&,
		fractionCollectionPackets
	];

	(* resolve the fraction temperature; since it's a singleton option, just going to pick the lowest temperature we have, or Ambient otherwise *)
	resolvedFractionCollectionTemperature = Which[
		TemperatureQ[specifiedFractionCollectionTemperature], specifiedFractionCollectionTemperature,
		MatchQ[fractionCollectionMethodTemperatures, {}], Ambient,
		MemberQ[fractionCollectionMethodTemperatures, TemperatureP], Min[fractionCollectionMethodTemperatures],
		True, Ambient
	];

	(* get the specified values for FractionCollectionMode, AbsoluteThreshold, PeakSlope, PeakMinimumDuration, and PeakEndThreshold *)
	{
		specifiedFractionCollectionMode,
		specifiedAbsoluteThreshold,
		specifiedPeakSlope,
		specifiedPeakSlopeEnd,
		specifiedPeakMinimumDuration,
		specifiedPeakEndThreshold,
		specifiedMaxCollectionPeriod
	} = Lookup[roundedOptionsAssociation, {FractionCollectionMode, AbsoluteThreshold, PeakSlope, PeakSlopeEnd, PeakMinimumDuration, PeakEndThreshold, MaxCollectionPeriod}];

	(* resolve the fraction collection mode *)
	resolvedFractionCollectionMode = MapThread[
		Function[{collectFractionsQ, mode, methodPacket, absThreshold, peakSlope, peakMinimumDuration, peakEndThreshold, maxCollectPeriod, peakSlopeEnd},
			Which[
				MatchQ[mode, Except[Automatic]], mode,
				Not[collectFractionsQ], Null,
				MatchQ[methodPacket, PacketP[Object[Method, FractionCollection]]], Lookup[methodPacket, FractionCollectionMode],
				MatchQ[absThreshold, Except[Automatic|Null]] || MatchQ[peakEndThreshold, Except[Automatic|Null]], Threshold,
				MatchQ[peakSlope, Except[Automatic|Null]] || MatchQ[peakMinimumDuration, UnitsP[Second]] || MatchQ[peakSlopeEnd, Except[Automatic|Null]], Peak,
				MatchQ[maxCollectPeriod, UnitsP[Second]], Time,
				True, Threshold
			]
		],
		{collectFractions, specifiedFractionCollectionMode, fractionCollectionPackets, specifiedAbsoluteThreshold, specifiedPeakSlope, specifiedPeakMinimumDuration, specifiedPeakEndThreshold, specifiedMaxCollectionPeriod, specifiedPeakSlopeEnd}
	];

	(* resolve the fraction start and end times *)
	(* fetch collection start time from:
        1.) option value if specified,
        2.) Null if we're not collecting fractions
        3.) otherwise fraction method if specified,
        4.) otherwise default to second timepoint of gradient *)
	fractionCollectionStartTimes = MapThread[
		Which[
			MatchQ[#2, Except[Automatic]], #2,
			Not[#1], Null,
			MatchQ[#3, PacketP[Object[Method, FractionCollection]]], Lookup[#3, FractionCollectionStartTime],
			(*if the gradient is only 2 lengths, then take the 25% point*)
			Length[#4]==2, RoundOptionPrecision[Sort[#4[[All, 1]]][[2]]*0.25, 10^-1 Minute],
			True, Sort[#4[[All, 1]]][[2]]
		]&,
		{collectFractions, Lookup[roundedOptionsAssociation, FractionCollectionStartTime], fractionCollectionPackets, resolvedAnalyteGradients}
	];

	(* resolve the fraction start and end times *)
	(* fetch collection start time from:
        1.) option value if specified,
        2.) Null if we're not collecting fractions
        3.) otherwise fraction method if specified,
        4.) otherwise default to last timepoint of gradient *)
	fractionCollectionEndTimes = MapThread[
		Which[
			MatchQ[#2, Except[Automatic]], #2,
			Not[#1], Null,
			MatchQ[#3, PacketP[Object[Method, FractionCollection]]], Lookup[#3, FractionCollectionEndTime],
			True, Last[Sort[#4[[All, 1]]]]
		]&,
		{collectFractions, Lookup[roundedOptionsAssociation, FractionCollectionEndTime], fractionCollectionPackets, resolvedAnalyteGradients}
	];

	(* FractionCollectionEndTime cannot be greater than the last timepoint of a gradient *)
	invalidFractionCollectionEndTimeBools = MapThread[
		Function[{startTime,endTime,gradientTimes},
			Or[
				TimeQ[endTime] && TrueQ[endTime > Last[gradientTimes]],
				If[And[TimeQ[startTime],TimeQ[endTime]], startTime > endTime,False]
			]
		],
		{fractionCollectionStartTimes,fractionCollectionEndTimes, resolvedAnalyteGradients[[All, All, 1]]}
	];

	(* If a FractionCollectionEndTime is greater than the last timepoint of a gradient, throw error *)
	fractionCollectionEndTimeOptions = If[messagesQ && MemberQ[invalidFractionCollectionEndTimeBools, True],
		(
			Message[Error::InvalidFractionCollectionEndTime, PickList[fractionCollectionEndTimes, invalidFractionCollectionEndTimeBools]];
			{FractionCollectionEndTime}
		),
		{}
	];
	fractionCollectionEndTimeTest = If[gatherTests,
		Test["All specified FractionCollectionEndTime values are less than the corresponding gradient's duration:",
			MemberQ[invalidFractionCollectionEndTimeBools, True],
			False
		],
		Nothing
	];

	(* If collecting fractions, fetch max fraction volume from:
        1.) option value if specified,
        2.) calculated from max period and flow rate,
        3.) fraction method,
        4.) 50 mL if using an avant
        5.) default to 1.8mL otherwise *)
	maxFractionVolumes = MapThread[
		Function[{collectQ, maxVolume, maxPeriod, methodPacket, flowRateTuples},
			Which[
				MatchQ[maxVolume, Except[Automatic]], maxVolume,
				Not[collectQ], Null,
				MatchQ[maxPeriod, Except[Automatic | Null]], First[flowRateTuples] * maxPeriod,
				MatchQ[methodPacket, PacketP[Object[Method, FractionCollection]]], Lookup[methodPacket, MaxFractionVolume],
				avant25Q || avant150Q, 50 Milliliter,
				True, 1.8 Milliliter
			]
		],
		{
			collectFractions,
			Lookup[roundedOptionsAssociation, MaxFractionVolume],
			specifiedMaxCollectionPeriod,
			fractionCollectionPackets,
			(* flow rate *)
			resolvedAnalyteGradients[[All, All, -1]]
		}
	];

	(* If collecting fractions, fetch the max fraction period from:
        1.) option value if specified,
        2.) calculated from max volume and flow rate,
        3.) fraction method,
        4.) if mode is Time, default to 30 seconds
        5.) otherwise, Null *)
	maxFractionPeriods = MapThread[
		Function[{collectQ, maxVolume, maxPeriod, methodPacket, flowRateTuples, fractionCollectionMode},
			Which[
				MatchQ[maxPeriod, Except[Automatic]], maxPeriod,
				Not[collectQ], Null,
				MatchQ[maxVolume, Except[Automatic | Null]], maxVolume / First[flowRateTuples],
				MatchQ[methodPacket, PacketP[Object[Method, FractionCollection]]], Lookup[methodPacket, MaxCollectionPeriod],
				MatchQ[fractionCollectionMode, Time], 30 Second,
				True, Null
			]
		],
		{
			collectFractions,
			maxFractionVolumes,
			specifiedMaxCollectionPeriod,
			fractionCollectionPackets,
			(* flow rate *)
			resolvedAnalyteGradients[[All, All, -1]],
			resolvedFractionCollectionMode
		}
	];

	(* If collecting fractions, fetch absolute threshold from:
        1.) option value if specified,
        2.) fraction method,
        3.) default to 500 mAU *)
	(* also need to round everything here too since it wasn't before*)
	absoluteThresholds = MapThread[
		Function[{collectQ, absoluteThreshold, methodPacket, fractionCollectionMode},
			Which[
				NullQ[absoluteThreshold], Null,
				MatchQ[absoluteThreshold, Except[Automatic]] && MatchQ[absoluteThreshold, UnitsP[AbsorbanceUnit]], RoundOptionPrecision[absoluteThreshold, 10^0 MilliAbsorbanceUnit, Round -> Down],
				MatchQ[absoluteThreshold, Except[Automatic]] && MatchQ[absoluteThreshold, UnitsP[Millisiemen/Centimeter]], RoundOptionPrecision[absoluteThreshold, 10^0 Millisiemen/Centimeter, Round -> Down],
				Not[collectQ], Null,
				Not[MatchQ[fractionCollectionMode, Threshold]], Null,
				MatchQ[methodPacket, PacketP[Object[Method, FractionCollection]]], Lookup[methodPacket, AbsoluteThreshold],
				MatchQ[resolvedDetectors,{Conductance}|Conductance], 5 Millisiemen/Centimeter,
				True, 500 MilliAbsorbanceUnit
			]
		],
		{collectFractions, specifiedAbsoluteThreshold, fractionCollectionPackets, resolvedFractionCollectionMode}
	];

	(* If collecting fractions, fetch PeakSlope from:
    1.) option value if specified
    2.) resolve to 2 mAu/s if FractionCollectionMode is Peak
    3.) fraction method
    4.) default to Null *)
	(* also need to round everything here too since it wasn't before *)
	peakSlopes = MapThread[
		Function[{collectQ, peakSlope, methodPacket, fractionCollectionMode, peakMinimumDuration, peakSlopeEnd},
			Which[
				NullQ[peakSlope], Null,
				MatchQ[peakSlope, Except[Automatic]] && MatchQ[peakSlope, UnitsP[AbsorbanceUnit/Second]], RoundOptionPrecision[peakSlope, 10^0 (MilliAbsorbanceUnit/Second), Round -> Down],
				MatchQ[peakSlope, Except[Automatic]] && MatchQ[peakSlope, UnitsP[Millisiemen/(Second Centimeter)]], RoundOptionPrecision[peakSlope, 10^0 Millisiemen/(Second Centimeter), Round -> Down],
				MatchQ[peakSlope, Except[Automatic]], peakSlope,
				MatchQ[peakSlopeEnd, UnitsP[Millisiemen/(Second Centimeter)]], peakSlopeEnd,
				MatchQ[peakMinimumDuration, Except[Automatic|Null]] && MatchQ[peakSlopeEnd, Except[Automatic|Null]], peakSlopeEnd,
				MatchQ[resolvedDetectors,{Conductance}|Conductance]&&MatchQ[fractionCollectionMode, Peak], 2 Millisiemen/(Centimeter Second),
				MatchQ[fractionCollectionMode, Peak], 2 MilliAbsorbanceUnit / Second,
				Not[collectQ], Null,
				Not[MatchQ[fractionCollectionMode, Peak]], Null,
				MatchQ[methodPacket, PacketP[Object[Method, FractionCollection]]], Lookup[methodPacket, PeakSlope],
				True, Null
			]
		],
		{collectFractions, specifiedPeakSlope, fractionCollectionPackets, resolvedFractionCollectionMode, specifiedPeakMinimumDuration, specifiedPeakSlopeEnd}
	];

	peakSlopeEnds = MapThread[
		Function[{collectQ, fractionCollectionMode, peakSlope, peakSlopeSpec, methodPacket},
			Which[
				NullQ[peakSlopeSpec], Null,
				MatchQ[peakSlopeSpec, Except[Automatic]] && MatchQ[peakSlopeSpec, UnitsP[AbsorbanceUnit/Second]], RoundOptionPrecision[peakSlopeSpec, 10^0 (MilliAbsorbanceUnit/Second), Round -> Down],
				MatchQ[peakSlopeSpec, Except[Automatic]] && MatchQ[peakSlopeSpec, UnitsP[Millisiemen/(Second Centimeter)]], RoundOptionPrecision[peakSlopeSpec, 10^0 Millisiemen/(Second Centimeter), Round -> Down],
				MatchQ[peakSlopeSpec, Except[Automatic]], peakSlopeSpec,
				Not[collectQ], Null,
				Not[MatchQ[fractionCollectionMode, Peak]], Null,
				MatchQ[methodPacket, PacketP[Object[Method, FractionCollection]]], Lookup[methodPacket, PeakSlopeEnd],
				(*otherwise, it should just set to the same as the peak slope*)
				True,peakSlope
			]
		],
		{
			collectFractions,
			resolvedFractionCollectionMode,
			peakSlopes,
			specifiedPeakSlopeEnd,
			fractionCollectionPackets
		}
	];

	(* If collecting fractions, fetch PeakMinimumDuration from:
    	option value if specified, resolution based on other peak options, fraction method, or default to Null *)
	peakMinimumDurations = MapThread[
		Function[{collectQ, peakMinimumDuration, methodPacket, fractionCollectionMode, peakSlope, peakEndThreshold},
			Which[
				MatchQ[peakMinimumDuration, Except[Automatic]], peakMinimumDuration,
				Not[collectQ], Null,
				MatchQ[methodPacket, PacketP[Object[Method, FractionCollection]]], Lookup[methodPacket, PeakMinimumDuration],
				MatchQ[fractionCollectionMode, Peak|Threshold], 0.15 Minute,
				True, Null
			]
		],
		{collectFractions, specifiedPeakMinimumDuration, fractionCollectionPackets, resolvedFractionCollectionMode, peakSlopes, specifiedPeakEndThreshold}
	];

	(* If collecting fractions, fetch PeakEndThreshold from:
        option value if specified, resolution based on other peak options, fraction method, or default to Null *)
	peakEndThresholds = MapThread[
		Function[{collectQ, peakEndThreshold, methodPacket, fractionCollectionMode, absoluteThreshold, peakMinimumDuration},
			Which[
				NullQ[peakEndThreshold], Null,
				MatchQ[peakEndThreshold, Except[Automatic]] && MatchQ[peakEndThreshold, UnitsP[AbsorbanceUnit]], RoundOptionPrecision[peakEndThreshold, 10^0 MilliAbsorbanceUnit, Round -> Down],
				MatchQ[peakEndThreshold, Except[Automatic]] && MatchQ[peakEndThreshold, UnitsP[Millisiemen/Centimeter]], RoundOptionPrecision[peakEndThreshold, 10^0 Millisiemen/Centimeter, Round -> Down],
				Not[collectQ], Null,
				Not[MatchQ[fractionCollectionMode, Threshold]], Null,
				MatchQ[methodPacket, PacketP[Object[Method, FractionCollection]]], Lookup[methodPacket, PeakEndThreshold],
				MatchQ[fractionCollectionMode, Threshold]&&QuantityQ[absoluteThreshold], absoluteThreshold,
				MatchQ[fractionCollectionMode, Threshold], 500 MilliAbsorbanceUnit,
				True, Null
			]
		],
		{collectFractions, specifiedPeakEndThreshold, fractionCollectionPackets, resolvedFractionCollectionMode, absoluteThresholds, peakMinimumDurations}
	];

	(* pull out the specified SampleTemperature field *)
	specifiedSampleTemperature = Lookup[roundedOptionsAssociation, SampleTemperature];

	(*we have to overwrite the shown gradient method if there were changes to it*)
	{
		shownGradients,
		shownStandardGradients,
		shownBlankGradients,
		shownColumnPrimeGradientList,
		shownColumnFlushGradientList
	}=MapThread[
		Function[{resolvedGradientList, removedExtraList, overwriteBoolList, gradientTupleList},
			If[!MatchQ[resolvedGradientList, Null |{Null}|{{}}|{}], MapThread[
				Function[{resolved, removedExtraEntryQ, overwriteQ, tupledGradient},
					Which[
						overwriteQ, tupledGradient,
						removedExtraEntryQ, tupledGradient,
						MatchQ[resolved, ObjectP[Object[Method]]|binaryGradientP|gradientP], resolved,
						True, tupledGradient
					]
				],
				{
					resolvedGradientList,
					removedExtraList,
					overwriteBoolList,
					gradientTupleList
				}
			]]
		],
		{
			{resolvedGradients,resolvedStandardGradients, resolvedBlankGradients, {resolvedColumnPrimeGradient}, {resolvedColumnFlushGradient}},
			{removedExtraBool, removedExtraStandardBool, removedExtraBlankBool, {removedExtraColumnPrimeGradientQ}, {removedExtraColumnFlushGradientQ}},
			{overwriteGradientsBool,overwriteStandardGradientsBool, overwriteBlankGradientsBool, {overwriteColumnPrimeGradientBool}, {overwriteColumnFlushGradientBool}},
			{resolvedAnalyteGradients, resolvedStandardAnalyticalGradients, resolvedBlankAnalyticalGradients, {resolvedColumnPrimeAnalyticalGradient}, {resolvedColumnFlushAnalyticalGradient}}
		}
	];

	(*since the column prime/fllush gradients were singleton, we pull them out unless Null*)
	{shownColumnPrimeGradient, shownColumnFlushGradient}=Map[If[!NullQ[#],First[#]]&,{shownColumnPrimeGradientList, shownColumnFlushGradientList}];

	(*we also want to check whether the gradient will equilibrate for each sample (i.e. the eluent is not left in the line when the sample is injected)*)
	(*we need to get all of the positions though in order to do this*)
	samplePositions = Sequence @@@ Position[resolvedInjectionTable, {Sample, ___}];
	standardPositions = Sequence @@@ Position[resolvedInjectionTable, {Standard, ___}];
	blankPositions = Sequence @@@ Position[resolvedInjectionTable, {Blank, ___}];
	columnPrimePositions = Sequence @@@ Position[resolvedInjectionTable, {ColumnPrime, ___}];
	columnFlushPositions = Sequence @@@ Position[resolvedInjectionTable, {ColumnFlush, ___}];

	(*now get the corresponding analyte gradients for each set*)
	(*for the blanks, standards, column primes/flushes, we may have to repeat out, if they appear multiple times*)
	standardGradientsMatchingIT = If[Length[standardPositions] > 0, PadRight[resolvedStandardAnalyticalGradients, Length[standardPositions], resolvedStandardAnalyticalGradients], {}];
	blankGradientsMatchingIT = If[Length[blankPositions] > 0, PadRight[resolvedBlankAnalyticalGradients, Length[blankPositions], resolvedBlankAnalyticalGradients], {}];
	columnPrimeGradientsMatchingIT = If[Length[columnPrimePositions] > 0, PadRight[{resolvedColumnPrimeAnalyticalGradient}, Length[columnPrimePositions], {resolvedColumnPrimeAnalyticalGradient}], {}];
	columnFlushGradientsMatchingIT = If[Length[columnFlushPositions] > 0, PadRight[{resolvedColumnFlushAnalyticalGradient}, Length[columnFlushPositions], {resolvedColumnFlushAnalyticalGradient}], {}];

	(*the following will not work if we have a screwed up injection table. since those errors will be throw, don't have to do so here*)
	injectionTableScrewedUpQ = Or[injectionTableSampleConflictQ];

	(*now create a list of rules that correspond the positions to the gradients*)
	injectionTableGradientRules = If[!injectionTableScrewedUpQ, Join[
		AssociationThread[samplePositions, resolvedAnalyteGradients],
		AssociationThread[standardPositions, standardGradientsMatchingIT],
		AssociationThread[blankPositions, blankGradientsMatchingIT],
		AssociationThread[columnPrimePositions, columnPrimeGradientsMatchingIT],
		AssociationThread[columnFlushPositions, columnFlushGradientsMatchingIT]
	]];

	(*okay, now we go through the sample gradients and check to see the gradient before it was equilibrated*)
	gradientReequilibratedBool = MapIndexed[
		Function[{currentSamplePosition, sampleIndex},
			(*if it's the first, then we're good... i guess*)
			(*if things are screw up. then we'll ignore this*)
			If[Or[currentSamplePosition == 1, injectionTableScrewedUpQ],
				True,
				(*otherwise, we do some logic to figure out if the gradient was completely reequilibrated*)
				(
					(*we get the initial sample gradient here*)
					initialSampleGradientComposition = resolvedAnalyteGradients[[First@sampleIndex]][[1, 2 ;; 9]];

					(*we get the gradient right before that*)
					previousGradient = (currentSamplePosition - 1) /. injectionTableGradientRules;

					(*we check to see if there's sufficient time (e.g. ~4 minutes, and that it's the same as the current sample gradient*)
					finalGradientDeltaDuration = previousGradient[[-1, 1]] - previousGradient[[-2, 1]];
					finalGradientComposition = previousGradient[[-1, 2 ;; 9]];

					initialSampleGradientComposition == finalGradientComposition
				)
			]
		],
		samplePositions
	];

	(*check if we have anything that goes out of whack*)
	gradientReequilibratedQ = And @@ gradientReequilibratedBool;

	If[messagesQ&&!gradientReequilibratedQ&&!engineQ,
		Message[Warning::GradientNotReequilibrated],
		Null
	];

	gradientReequilibratedWarning=If[gatherTests,
		Warning["If the InjectionType is Autosampler, the gradient reequilibrate in the previous gradient before the sample one:",
			gradientReequilibratedQ,
			True
		],
		Nothing
	];

	(*resolve this purge voluem option*)
	resolvedPumpDisconnectOnFullGradientChangePurgeVolume=Which[
		MatchQ[Lookup[roundedOptionsAssociation,PumpDisconnectOnFullGradientChangePurgeVolume],Except[Automatic]],Lookup[roundedOptionsAssociation,PumpDisconnectOnFullGradientChangePurgeVolume],
		MatchQ[Lookup[roundedOptionsAssociation, FullGradientChangePumpDisconnectAndPurge],True],15 Milliliter,
		True,Null
	];

	(*check if we have a conflict*)
	gradientPurgeConflictQ=MatchQ[
		{Lookup[roundedOptionsAssociation, FullGradientChangePumpDisconnectAndPurge], resolvedPumpDisconnectOnFullGradientChangePurgeVolume},
		{True,Null}|{False|Null,UnitsP[Milliliter]}
	];

	gradientPurgeConflictOptions=If[messagesQ&&gradientPurgeConflictQ,
		Message[Error::GradientPurgeConflict];
		{PumpDisconnectOnFullGradientChangePurgeVolume, FullGradientChangePumpDisconnectAndPurge},
		{}
	];

	(*no test for this because we don't care about these options*)

	(* Set all non-shared Experiment options to be resolved *)
	resolvedExperimentOptions = {
		SeparationMode -> resolvedSeparationMode,
		Column -> resolvedColumn,
		MaxColumnPressure -> resolvedColumnMaxPressure,
		Scale -> scale,
		Instrument -> resolvedInstrument,
		InjectionType -> resolvedInjectionType,
		SamplePumpWash -> resolvedSamplePumpWash,
		SampleLoopVolume -> resolvedSampleLoopVolume,
		Detector -> resolvedDetectors,
		MixerVolume -> resolvedMixerVolume,
		FlowCell -> resolvedFlowCell,
		InjectionTable -> resolvedInjectionTable,
		InjectionVolume -> resolvedInjectionVolumes,
		SampleFlowRate -> resolvedSampleFlowRates,
		SampleTemperature -> specifiedSampleTemperature,
		FlowInjectionPurgeCycle -> resolvedFlowInjectionPurgeCycle,
		Wavelength -> resolvedWavelength,
		BufferA -> resolvedBufferA,
		BufferB -> resolvedBufferB,
		BufferC -> resolvedBufferC,
		BufferD -> resolvedBufferD,
		BufferE -> resolvedBufferE,
		BufferF -> resolvedBufferF,
		BufferG -> resolvedBufferG,
		BufferH -> resolvedBufferH,
		GradientA -> resolvedGradientAs,
		GradientB -> resolvedGradientBs,
		GradientC -> resolvedGradientCs,
		GradientD -> resolvedGradientDs,
		GradientE -> resolvedGradientEs,
		GradientF -> resolvedGradientFs,
		GradientG -> resolvedGradientGs,
		GradientH -> resolvedGradientHs,
		Gradient -> shownGradients,
		FlowRate -> resolvedFlowRates,
		GradientStart -> resolvedGradientStarts,
		GradientEnd -> resolvedGradientEnds,
		GradientDuration -> resolvedGradientDurations,
		EquilibrationTime -> resolvedEquilibrationTimes,
		SampleLoopDisconnect -> resolvedSampleLoopDisconnects,
		PreInjectionEquilibrationTime -> resolvedPreInjectionEquilibrationTimes,
		FlushTime -> resolvedFlushTimes,
		FlowDirection -> Lookup[roundedOptionsAssociation, FlowDirection],
		SamplesInStorageCondition -> Lookup[roundedOptionsAssociation, SamplesInStorageCondition],
		SamplesOutStorageCondition -> Lookup[roundedOptionsAssociation, SamplesOutStorageCondition],
		StandardFrequency -> resolvedStandardFrequency,
		(* need to do all the {} -> Null shenanigans because {} might be what we have from stuff above, but those don't match the patterns of these options so can't be the final values *)
		Standard -> resolvedStandard /. {{} -> Null},
		StandardInjectionType -> resolvedStandardInjectionType /. {{} -> Null},
		StandardInjectionVolume -> resolvedStandardInjectionVolumes /. {{} -> Null},
		StandardGradient -> shownStandardGradients,
		StandardGradientA -> resolvedStandardGradientAs /. {{} -> Null},
		StandardGradientB -> resolvedStandardGradientBs /. {{} -> Null},
		StandardGradientC -> resolvedStandardGradientCs /. {{} -> Null},
		StandardGradientD -> resolvedStandardGradientDs /. {{} -> Null},
		StandardGradientE -> resolvedStandardGradientEs /. {{} -> Null},
		StandardGradientF -> resolvedStandardGradientFs /. {{} -> Null},
		StandardGradientG -> resolvedStandardGradientGs /. {{} -> Null},
		StandardGradientH -> resolvedStandardGradientHs /. {{} -> Null},
		StandardFlowRate -> resolvedStandardFlowRates /. {{} -> Null},
		StandardGradientStart -> Lookup[roundedOptionsAssociation, StandardGradientStart] /. {{} -> Null},
		StandardGradientEnd -> Lookup[roundedOptionsAssociation, StandardGradientEnd] /. {{} -> Null},
		StandardGradientDuration -> Lookup[roundedOptionsAssociation, StandardGradientDuration] /. {{} -> Null},
		StandardSampleLoopDisconnect -> resolvedStandardSampleLoopDisconnects  /. {{} -> Null},
		StandardPreInjectionEquilibrationTime->resolvedStandardPreInjectionEquilibrationTimes,
		StandardFlowDirection -> resolvedStandardFlowDirection,
		StandardStorageCondition -> Lookup[roundedOptionsAssociation, StandardStorageCondition] /. {{} -> Null},
		BlankFrequency -> resolvedBlankFrequency,
		Blank -> resolvedBlank /. {{} -> Null},
		BlankInjectionType -> resolvedBlankInjectionType /. {{} -> Null},
		BlankInjectionVolume -> resolvedBlankInjectionVolumes /. {{} -> Null},
		BlankGradient -> shownBlankGradients,
		BlankGradientA -> resolvedBlankGradientAs /. {{} -> Null},
		BlankGradientB -> resolvedBlankGradientBs /. {{} -> Null},
		BlankGradientC -> resolvedBlankGradientCs /. {{} -> Null},
		BlankGradientD -> resolvedBlankGradientDs /. {{} -> Null},
		BlankGradientE -> resolvedBlankGradientEs /. {{} -> Null},
		BlankGradientF -> resolvedBlankGradientFs /. {{} -> Null},
		BlankGradientG -> resolvedBlankGradientGs /. {{} -> Null},
		BlankGradientH -> resolvedBlankGradientHs /. {{} -> Null},
		BlankFlowRate -> resolvedBlankFlowRates /. {{} -> Null},
		BlankGradientStart -> Lookup[roundedOptionsAssociation, BlankGradientStart] /. {{} -> Null},
		BlankGradientEnd -> Lookup[roundedOptionsAssociation, BlankGradientEnd] /. {{} -> Null},
		BlankGradientDuration -> Lookup[roundedOptionsAssociation, BlankGradientDuration] /. {{} -> Null},
		BlankSampleLoopDisconnect -> resolvedBlankSampleLoopDisconnects  /. {{} -> Null},
		BlankPreInjectionEquilibrationTime->resolvedBlankPreInjectionEquilibrationTimes,
		BlankFlowDirection -> resolvedBlankFlowDirection,
		BlankStorageCondition -> Lookup[roundedOptionsAssociation, BlankStorageCondition] /. {{} -> Null},
		ColumnRefreshFrequency -> resolvedColumnRefreshFrequency,
		ColumnPrimeGradient -> shownColumnPrimeGradient,
		ColumnPrimeGradientA -> resolvedColumnPrimeGradientA,
		ColumnPrimeGradientB -> resolvedColumnPrimeGradientB,
		ColumnPrimeGradientC -> resolvedColumnPrimeGradientC,
		ColumnPrimeGradientD -> resolvedColumnPrimeGradientD,
		ColumnPrimeGradientE -> resolvedColumnPrimeGradientE,
		ColumnPrimeGradientF -> resolvedColumnPrimeGradientF,
		ColumnPrimeGradientG -> resolvedColumnPrimeGradientG,
		ColumnPrimeGradientH -> resolvedColumnPrimeGradientH,
		ColumnPrimeFlowRate -> resolvedColumnPrimeFlowRate,
		ColumnPrimeStart -> Lookup[roundedOptionsAssociation, ColumnPrimeStart],
		ColumnPrimeEnd -> Lookup[roundedOptionsAssociation, ColumnPrimeEnd],
		ColumnPrimeDuration -> Lookup[roundedOptionsAssociation, ColumnPrimeDuration],
		ColumnPrimePreInjectionEquilibrationTime->resolvedColumnPrimePreInjectionEquilibrationTime,
		ColumnPrimeFlowDirection -> resolvedColumnPrimeFlowDirection,
		ColumnFlushGradient -> shownColumnFlushGradient,
		ColumnFlushGradientA -> resolvedColumnFlushGradientA,
		ColumnFlushGradientB -> resolvedColumnFlushGradientB,
		ColumnFlushGradientC -> resolvedColumnFlushGradientC,
		ColumnFlushGradientD -> resolvedColumnFlushGradientD,
		ColumnFlushGradientE -> resolvedColumnFlushGradientE,
		ColumnFlushGradientF -> resolvedColumnFlushGradientF,
		ColumnFlushGradientG -> resolvedColumnFlushGradientG,
		ColumnFlushGradientH -> resolvedColumnFlushGradientH,
		ColumnFlushFlowRate -> resolvedColumnFlushFlowRate,
		ColumnFlushStart -> Lookup[roundedOptionsAssociation, ColumnFlushStart],
		ColumnFlushEnd -> Lookup[roundedOptionsAssociation, ColumnFlushEnd],
		ColumnFlushDuration -> Lookup[roundedOptionsAssociation, ColumnFlushDuration],
		ColumnFlushPreInjectionEquilibrationTime->resolvedColumnFlushPreInjectionEquilibrationTime,
		ColumnFlushFlowDirection -> resolvedColumnFlushFlowDirection,
		NumberOfReplicates -> Lookup[roundedOptionsAssociation, NumberOfReplicates],
		Cache -> Lookup[roundedOptionsAssociation, Cache],
		FastTrack -> Lookup[roundedOptionsAssociation, FastTrack],
		Template -> Lookup[roundedOptionsAssociation, Template],
		ParentProtocol -> Lookup[roundedOptionsAssociation, ParentProtocol],
		Operator -> Lookup[roundedOptionsAssociation, Operator],
		Confirm -> Lookup[roundedOptionsAssociation, Confirm],
		CanaryBranch -> Lookup[roundedOptionsAssociation, CanaryBranch],
		Name -> Lookup[roundedOptionsAssociation, Name],
		Upload -> Lookup[roundedOptionsAssociation, Upload],
		Output -> Lookup[roundedOptionsAssociation, Output],
		Email -> resolvedEmail,
		PreparatoryUnitOperations -> Lookup[roundedOptionsAssociation, PreparatoryUnitOperations],
		SubprotocolDescription -> Lookup[roundedOptionsAssociation, SubprotocolDescription],
		CollectFractions -> collectFractions,
		FractionCollectionTemperature -> resolvedFractionCollectionTemperature,
		FractionCollectionMethod -> fractionCollectionMethod,
		FractionCollectionStartTime -> fractionCollectionStartTimes,
		FractionCollectionEndTime -> fractionCollectionEndTimes,
		FractionCollectionMode -> resolvedFractionCollectionMode,
		MaxFractionVolume -> maxFractionVolumes,
		MaxCollectionPeriod -> maxFractionPeriods,
		AbsoluteThreshold -> absoluteThresholds,
		PeakSlope -> peakSlopes,
		PeakSlopeEnd -> peakSlopeEnds,
		PeakMinimumDuration -> peakMinimumDurations,
		PeakEndThreshold -> peakEndThresholds,
		FullGradientChangePumpDisconnectAndPurge -> Lookup[roundedOptionsAssociation, FullGradientChangePumpDisconnectAndPurge],
		PumpDisconnectOnFullGradientChangePurgeVolume -> resolvedPumpDisconnectOnFullGradientChangePurgeVolume
	};

	(* --- Aliquot options --- *)

	(* get the current containers that the samples are in *)
	sampleContainerPackets = Map[
		fastAssocPacketLookup[fastAssoc, #, Container]&,
		simulatedSamples
	];
	sampleContainerModel = Download[If[NullQ[#], Null, Lookup[#, Model, Null]]& /@ sampleContainerPackets, Object];

	(* get whether we're using the avant autosampler *)
	usingAvantAutosamplerQs = (avant150Q || avant25Q) && MatchQ[#, Autosampler]& /@ allInjectionTypes;

	(* indicate whether we're using an avant system with no autosampler *)
	avantButNoAutosamplerQs = (avant150Q || avant25Q) && Not[#]& /@ usingAvantAutosamplerQs;

	(* articulate all of the containers that are okay for measurement in the Avants sans autosampler and the max limit for each one*)
	(* these are default aliquot containers for flow injection *)
	validAvantContainerModelsLimits=Association[
		(*50 mL tubes*)
		Model[Container, Vessel, "id:bq9LA0dBGGR6"] -> 5,
		(*Light sensitive 50 mL*)
		Model[Container, Vessel, "id:bq9LA0dBGGrd"] -> 5,
		(*250 ml Bottle*)
		Model[Container, Vessel, "250mL Glass Bottle"] -> 5,
		(*500 mL Bottle*)
		Model[Container, Vessel, "500mL Glass Bottle"] -> 5,
		(*1 L bottle*)
		Model[Container, Vessel, "1L Glass Bottle"] -> 4,
		(*2 L bottle*)
		Model[Container, Vessel, "2L Glass Bottle"] -> 4,
		(*4 L bottle*)
		Model[Container, Vessel, "Amber Glass Bottle 4 L"] -> 2
	];



	(* get the required aliquot volume *)
	(* distribute the dead volume across all instances of identical aliquots *)
	totalDeadVolumes = Map[
		Which[
			# && resolvedFlowInjectionPurgeCycle, 12 Milliliter,
			#, 30 Milliliter,
			True, autosamplerDeadVolume
		]&,
		avantButNoAutosamplerQs
	];
	sampleDeadVolumes = Take[totalDeadVolumes, Length[simulatedSamplePackets]];

	(* get the target containers *)
	targetAliquotContainers = MapThread[
		Function[{currentSamplePacket,currentAliquotQ,currentSampleModel, avantButNoAutosamplerQ, totalDeadVolume},
			(*get the packet for the target container*)
			targetContainerPacket=fetchPacketFromFastAssoc[currentSampleModel,fastAssoc];
			Module[
				{allInjectionsSameSample,totalInjVol},
				allInjectionsSameSample=Cases[
					Transpose[{Download[simulatedSamplePackets, Object],resolvedInjectionVolumes}],
					{Lookup[currentSamplePacket, Object],___}
				];
				totalInjVol=Total[allInjectionsSameSample[[All,2]]];
				Which[
					(* if we're not aliquoting, then this is already Null *)
					MatchQ[currentAliquotQ, False | Null], Null,
					(* if we're using the avant 25 and injection volume is above 100 Microliter, then we only aliquot if not the right type of container*)
					avantButNoAutosamplerQ, If[!MatchQ[currentSampleModel,ObjectP[Keys[validAvantContainerModelsLimits]]],
						bestFPLCAliquotContainerModel[totalInjVol+totalDeadVolume]
					],
					avant25Q&&MatchQ[targetContainerPacket,Null|<||>|{}], Model[Container, Vessel, "1mL HPLC Vial (total recovery)"],
					(* if we're using the avant 25, need to use the total-recovery HPLC vials or 96 well plate*)
					avant25Q && Or[
						StringContainsQ[Lookup[targetContainerPacket,Name],"vial",IgnoreCase->True],
						MatchQ[currentSampleModel, ObjectP[{Model[Container, Plate, "96-well 2mL Deep Well Plate"]}]]
					], currentSampleModel,
					avant25Q, Model[Container, Vessel, "1mL HPLC Vial (total recovery)"],
					(* if we're using the avant 150, need to use the special 10 mL HPLC vials *)
					avant150Q, Model[Container, Vessel, "22x45mm screw top vial 10mL"],
					(* if we're using something else, use the deep well plate *)
					True, Model[Container, Plate, "96-well 2mL Deep Well Plate"]
				]
			]
		],
		{simulatedSamplePackets,Lookup[samplePrepOptions, Aliquot],sampleContainerModel, Take[avantButNoAutosamplerQs, Length[simulatedSamplePackets]], sampleDeadVolumes}
	];


	(*for the plate*)

	requiredAliquotVolumes = MapThread[
		(*if we're consolidating, then can divide the dead volume across*)
		(*plates will automatically set to ConsolidateAliquots*)
		Function[{samplePacket, resolvedInjVolume, targetContainer, totalDeadVolume},
			(*get the packet for the target container*)
			targetContainerPacket = fetchPacketFromFastAssoc[targetContainer, fastAssoc];
			(*get the sensible dead volume based on the target container*)
			currentDeadVolume = Which[
				NullQ[targetContainerPacket], totalDeadVolume,
				StringContainsQ[Lookup[targetContainerPacket, Name], "total recovery"], 5 Microliter,
				StringContainsQ[Lookup[targetContainerPacket, Name], "high recovery"], 15 Microliter,
				MatchQ[Lookup[targetContainerPacket, Model], ObjectP[Model[Container, Plate]]], 50 Microliter,
				True, totalDeadVolume
			];
			If[MemberQ[targetAliquotContainers, ObjectP[Model[Container, Plate]]] || MatchQ[Lookup[samplePrepOptions, ConsolidateAliquots], True],
				(resolvedInjVolume + (currentDeadVolume / Count[Download[mySamples, Object], Lookup[samplePacket, Object]])),
				(resolvedInjVolume + currentDeadVolume)
			]
		],
		{samplePackets, resolvedInjectionVolumes, targetAliquotContainers, sampleDeadVolumes}
	];

	(* Throw Error if we do not have enough amount. We do it here now since we have the dead volume resolved already *)
	(* Group injection volumes for each unique sample *)
	groupedVolumes = GatherBy[
		Transpose[{samplePackets,requiredAliquotVolumes, sampleDeadVolumes}],
		#[[1]]&
	];

	(* If the total injected volume for a sample is greater than its volume, throw error. we don't worry about this, if the samples are solid *)
	validSampleVolumesQ = Map[
		Or[
			MatchQ[Lookup[#[[1,1]],State],Solid],
			TrueQ[Lookup[#[[1,1]],Volume] >= (Total[#[[All,2]]])]
		]&,
		groupedVolumes
	];

	(* Extract list of objects with insufficient volume *)
	samplesWithInsufficientVolume = PickList[
		Lookup[#[[1,1]],Object]&/@groupedVolumes,
		validSampleVolumesQ,
		False
	];

	(* Build test for sample volume sufficiency. *)
	insufficientVolumeTest = If[!(And@@validSampleVolumesQ),
		(
			If[messagesQ&&!engineQ,
				Message[Warning::FPLCInsufficientSampleVolume,ObjectToString/@samplesWithInsufficientVolume,PickList[Total /@ groupedVolumes[[All, All, 3]], validSampleVolumesQ, False]]
			];
			warningOrNull["All samples have sufficient volume for the requested injection volume:",False]
		),
		warningOrNull["All samples have sufficient volume for the requested injection volume:",True]
	];


	(* resolve ConsolidateAliquots to True if it's still Automatic, and add it in to the pre-resolved aliquot options if were moving to a plate *)
	(**)
	resolvedConsolidateAliquots = If[MemberQ[targetAliquotContainers,ObjectP[Model[Container,Plate]]],
		Lookup[samplePrepOptions, ConsolidateAliquots] /. {Automatic -> True},
		Lookup[samplePrepOptions, ConsolidateAliquots]
	];
	preresolvedAliquotOptions = ReplaceRule[myOptions,
		Join[
			{
				ConsolidateAliquots -> resolvedConsolidateAliquots
			},
			resolvedSamplePrepOptions
		]
	];

	(* Resolve aliquot options. Since we want the samples packed as *)
	{resolvedAliquotOptions, resolveAliquotOptionTests} = If[gatherTests,
		resolveAliquotOptions[
			ExperimentFPLC,
			Download[mySamples, Object],
			simulatedSamples,
			preresolvedAliquotOptions,
			RequiredAliquotAmounts -> requiredAliquotVolumes,
			RequiredAliquotContainers -> targetAliquotContainers,
			AliquotWarningMessage -> "because the given samples are not in containers that are compatible with FPLC instruments.",
			Output -> {Result, Tests},
			Cache -> cache,
			Simulation->updatedSimulation
		],
		{
			resolveAliquotOptions[
				ExperimentFPLC,
				Download[mySamples, Object],
				simulatedSamples,
				preresolvedAliquotOptions,
				RequiredAliquotAmounts -> requiredAliquotVolumes,
				RequiredAliquotContainers -> targetAliquotContainers,
				AliquotWarningMessage -> "because the given samples are not in containers that are compatible with FPLC instruments.",
				Output -> Result,
				Cache -> cache,
				Simulation->updatedSimulation
			],
			{}
		}
	];

	(* Resolve Post Processing Options *)
	resolvedPostProcessingOptions = resolvePostProcessingOptions[myOptions];

	(* ===== sample container compatibility check ===== *)
	(* In cases where the input sample is in a huge container, ExperimentFPLC will force aliquot. Therefore, container compatibility check will happen after aliquot container is resolved *)
	(* default list of containers for different models of avant FPLC systems *)
	defaultAutosamplerContainer = Which[
		(* Default container for AKTA avant 25 is either HPLC vials on autosampler rack or 96 well deep well plate on autosampler deck *)
		avant25Q, {Model[Container, Plate, "id:L8kPEjkmLbvW"], Model[Container, Vessel, "id:jLq9jXvxr6OZ"]},

		(* Default container for AKTA avant 150 is 10 mL HPLC tubes from the autosampler rack *)
		avant150Q, {Model[Container, Vessel, "id:eGakldJ6p35e"]},

		(* Deafult container for UPC10 is 96 well deep well plate *)
		True, {Model[Container, Plate, "id:L8kPEjkmLbvW"]}
	];

	(* check if Aliquot Container is specified *)
	specifiedAliquotContainer = If[!MatchQ[Lookup[resolvedAliquotOptions, AliquotContainer], {} | {Null} | Null],
		Cases[Flatten@Lookup[resolvedAliquotOptions, AliquotContainer], ObjectP[Model[Container]]],
		Null
	];

	{
		incompatibleContainerQ,
		incompatibleContainerList,
		nonDefaultContainers
	} = Flatten /@ Transpose[Map[
		Function[{injectionType},
			Module[
				{uniqueSampleContainers, nonDefaultAutosamplerContainers, nonDefaultFlowInjectionContainers,
					badFlowInjectionContainerQ, badAutosamplerContainerQ},
				(* at this point, the aliquot container should be resolved already *)
				(* if the aliquot container is still Null, then check the compatbility of container for simulated samples *)
				uniqueSampleContainers = If[MatchQ[specifiedAliquotContainer, {} | Null | {Null}],
					DeleteDuplicates@simulatedSampleContainerModels,
					specifiedAliquotContainer
				];

				(* remove the default autosampler containers from the list of unique sample containers *)
				nonDefaultAutosamplerContainers = Which[
					avant25Q,
					uniqueSampleContainers /. {
						(* 96-well 2mL Deep Well Plate *)
						Model[Container, Plate, "id:L8kPEjkmLbvW"] -> Nothing,
						(* HPLC vial (high recovery) *)
						Model[Container, Vessel, "id:jLq9jXvxr6OZ"] -> Nothing
					},

					avant150Q,
					uniqueSampleContainers /. {
						(* 22x45mm screw top vial 10mL *)
						Model[Container, Vessel, "id:eGakldJ6p35e"] -> Nothing
					}
				];

				(* remove the default flow injection containers from the list of unique sample containers *)
				nonDefaultFlowInjectionContainers = uniqueSampleContainers /. Map[# -> Nothing&, Download[Keys[validAvantContainerModelsLimits], Object]];

				Which[
					(* if a protocol uses flow injection *)
					MatchQ[injectionType, FlowInjection | Superloop],

						(* check container compatibility against the buffer sample deck's "Sample Slot" *)
						(* if all flow injection containers are default containers, then set variable to False to pass compatibility check*)
						badFlowInjectionContainerQ = If[Length[nonDefaultFlowInjectionContainers] > 0,
							Or @@ MapIndexed[!CompatibleFootprintQ[Model[Container, Deck, "Avant Buffer Sample Deck"], #1, Position -> "Sample Slot " <> ToString[First@#2], ExactMatch -> False, Cache -> cache]&, nonDefaultFlowInjectionContainers],
							False
						];
						{
							badFlowInjectionContainerQ,
							(* compile a list of incompatible containers to throw in the error *)
							If[badFlowInjectionContainerQ, nonDefaultFlowInjectionContainers, {}],
							nonDefaultFlowInjectionContainers
						},

					MatchQ[injectionType, Autosampler],
						badAutosamplerContainerQ = If[Length[nonDefaultAutosamplerContainers] > 0,
							(* if there are non default sampler containers specified, then we need to check whether each of the container is compatible *)
							Map[
								Which[
									(* if using avant 25 *)
									avant25Q,
									(* we need to look at whether the provided container is a vessel or a plate *)
										Switch[#,
											(* if the provided container is a vessel, check compatibililty against the autosampler rack *)
											ObjectP[Model[Container, Vessel]],
											!CompatibleFootprintQ[Model[Container, Rack, "Avant Autosampler 2 mL Vial Rack"], #, ExactMatch -> False, Cache -> cache],
											(* if the provided container is a plate, check compatibility against the autosampler deck *)
											ObjectP[Model[Container, Plate]],
											!CompatibleFootprintQ[Model[Container, Deck, "Avant Sample Deck"], #, ExactMatch -> False, Cache -> cache]
										],

									(* if using avant 150 *)
									avant150Q,
										(* check container compatibility against autosampler rack *)
										!CompatibleFootprintQ[Model[Container, Rack, "Avant Autosampler 10 mL Vial Rack"], #, ExactMatch -> True, Cache -> cache],

									(* if using AKTA UPC 10 *)
									True,
										(* check container compatbility against autosampler deck *)
										!CompatibleFootprintQ[Model[Container, Deck, "AKTA Autosampler Deck"], #, ExactMatch -> False, Cache -> cache]

								]&,
								nonDefaultAutosamplerContainers
							],
							(* if only default containers are used for the instrument, set error tracking variable to False *)
							False
						];
						(* If nonDefaultSampleContainers is an empty list at this point, it means all the input containers are the default used by the instrument *)
						(* If not, it means there are input containers that are outside the default containers used by the instrument *)
						{
							badAutosamplerContainerQ,
							(* compile a list of incompatible containers to throw in the error *)
							PickList[nonDefaultAutosamplerContainers,badAutosamplerContainerQ,True],
							nonDefaultAutosamplerContainers
						}

				]
			]
		],
		resolvedInjectionType
	]];

	(* check the container of each simulated samples and compile a list of all simulated samples with incompatible containers as invalid input*)
	incompatibleContainerCheck = MemberQ[incompatibleContainerList, #]& /@ sampleContainerModel;
	incompatibleContainerSamples = PickList[simulatedSamples, incompatibleContainerCheck, True];

	(* generate test for incompatible sample containers for avant autosampler *)
	(* if 1) some containers are not compatible, 2) we are throwing messages, and 3) aliquot container is not specified, then we need to test + throw an error *)
	incompatibleContainerInput = If[MemberQ[incompatibleContainerQ, True] && messagesQ && MatchQ[specifiedAliquotContainer, ListableP[Automatic | Null]],
		(
			Message[Error::IncompatibleSampleContainer, incompatibleContainerList, defaultAutosamplerContainer];
			incompatibleContainerSamples
		),
		{}
	];

	incompatibleContainerTest = If[gatherTests,
		Test["If autosampler is used for injection, sample containers' model is compatible with the autosampler deck or rack:", Or @@ incompatibleContainerQ, False],
		Nothing
	];


	(*-- UNRESOLVABLE OPTION CHECKS --*)

	(* decide if the injection volumes are greater than the maximum allowed by instrument *)
	(* if we're using the avant autosampler or using the old akta, then just straightforward can't-be-above-the-max-volume thing; otherwise, we can't be above the max injection volume since it goes up to the option's maximum *)
	injectionVolumeAutosamplerIncompatible = Cases[PickList[allInjectionVolumes, allInjectionTypes, Autosampler], GreaterP[maxInjectionVolume]];
	injectionVolumeFlowInjectionIncompatible = Cases[PickList[allInjectionVolumes, allInjectionTypes, FlowInjection], LessP[1 Milliliter]];
	(*for the superloop, anything above or below the range of 1 and 10 mL can't be used*)
	injectionVolumeSuperloopIncompatible = Cases[PickList[allInjectionVolumes, allInjectionTypes, Superloop], Except[RangeP[1 Milliliter, 10 Milliliter]]];

	(* if the injection volumes are too high, throw an error *)
	injectionVolumesAutosamplerIncompatibleOptions = If[messagesQ && Not[MatchQ[injectionVolumeAutosamplerIncompatible, {}]],
		(
			Message[Error::IncompatibleInjectionVolume, ObjectToString[injectionVolumeAutosamplerIncompatible], ObjectToString[resolvedInstrument,Cache->simulatedCache], ObjectToString[maxInjectionVolume]];
			{Instrument, InjectionType, StandardInjectionType, BlankInjectionType, SampleLoopVolume, InjectionVolume, StandardInjectionVolume, BlankInjectionVolume}
		),
		{}
	];
	injectionVolumesFlowInjectionIncompatibleOptions = If[messagesQ && Not[MatchQ[injectionVolumeFlowInjectionIncompatible, {}]],
		(
			Message[Error::InsufficientInjectionVolume, ObjectToString[injectionVolumeFlowInjectionIncompatible,Cache->simulatedCache]];
			{Instrument, InjectionType, StandardInjectionType, BlankInjectionType, SampleLoopVolume, InjectionVolume, StandardInjectionVolume, BlankInjectionVolume}
		),
		{}
	];
	injectionVolumesSuperloopIncompatibleOptions = If[messagesQ && Not[MatchQ[injectionVolumeSuperloopIncompatible, {}]],
		(
			Message[Error::InjectionVolumeOutOfRange, ObjectToString[injectionVolumeSuperloopIncompatible,Cache->simulatedCache]];
			{Instrument, InjectionType, StandardInjectionType, BlankInjectionType, SampleLoopVolume, InjectionVolume, StandardInjectionVolume, BlankInjectionVolume}
		),
		{}
	];

	(* make a test for the injection volumes being too high *)
	injectionVolumesIncompatibleTest = If[gatherTests,
		Test["The specified InjectionVolume/StandardInjectionVolume/BlankInjectionVolume are within the allowed volume range for the specified Instrument and InjectionType:",
			MatchQ[Flatten[{injectionVolumeAutosamplerIncompatible, injectionVolumeFlowInjectionIncompatible, injectionVolumeSuperloopIncompatible}], {}],
			True
		],
		Nothing
	];

	(* get the maximum number of samples we allow *)
	maxAllowedSamples = Which[
		(* two 48-vial (1.5 mL each) racks, plus 5 flow injections *)
		MemberQ[allInjectionTypes, Autosampler] && MemberQ[allInjectionTypes, FlowInjection] && avant25Q, 96 + 5,
		MemberQ[allInjectionTypes, Autosampler] && avant25Q, 96,
		(* two 12-vial (10 mL each) racks, plus 5 flow injections*)
		MemberQ[allInjectionTypes, Autosampler] && MemberQ[allInjectionTypes, FlowInjection] && avant150Q, 24 + 5,
		MemberQ[allInjectionTypes, Autosampler] && avant150Q, 24,
		(* can only have 5 bottles loading manually *)
		(avant25Q || avant150Q) && Not[MemberQ[allInjectionTypes, Autosampler]], 5,
		(* for the non-avant FPLCs, can fit it all in the one 96-well deep well plate *)
		True, 96
	];

	(* Since checks for too-many-samples could depend on how many standard and blank
	containers will be required, we need to determine these container counts based
	on how many standards/blanks exist, their injection volumes, and injection frequency.
	Standards/blanks specified by models may have to run across multiple containers if
	their total injection volume is greater than the max volume of the default standard/blank
	container. *)

	(* Define the default container used for standards/blanks *)
	defaultStandardBlankContainer = Which[
		MemberQ[allInjectionTypes, Autosampler] && avant25Q, Model[Container, Vessel, "HPLC vial (high recovery)"],
		MemberQ[allInjectionTypes, Autosampler] && avant150Q, Model[Container, Vessel, "22x45mm screw top vial 10mL"],
		(* if we're not using the autosampler but are using the avant it truly does not matter what container we are using *)
		(avant25Q || avant150Q) && Not[MemberQ[allInjectionTypes, Autosampler]], Null,
		True, Model[Container, Plate, "96-well 2mL Deep Well Plate"]
	];

	(* Fetch the max volume of the standard/blank container *)
	standardBlankContainerMaxVolume = If[NullQ[defaultStandardBlankContainer],
		Null,
		Lookup[fetchPacketFromFastAssoc[Download[defaultStandardBlankContainer, Object], fastAssoc], MaxVolume]
	];

	(* pull out NumberOfReplicates becuase that is important here *)
	numReplicates = Lookup[roundedOptionsAssociation, NumberOfReplicates] /. {Automatic | Null -> 1};

	(* Define the max useable volume in the standard/blank containers when considering dead volume *)
	(* the max is 4 Liter because that's the size of the biggest non-autosampler bottles we have *)
	standardBlankSampleMaxVolume = If[NullQ[standardBlankContainerMaxVolume],
		4 Liter,
		(standardBlankContainerMaxVolume - autosamplerDeadVolume)
	];

	(*get the columns of the injection table pertinent for this resolution*)
	standardInjectionVolumeTuples = Cases[resolvedInjectionTable, {Standard, sample_, injectionType_, injectionVolume_, _} :> {sample, injectionType, injectionVolume}];
	blankInjectionVolumeTuples = Cases[resolvedInjectionTable, {Blank, sample_, injectionType_, injectionVolume_, _} :> {sample, injectionType, injectionVolume}];

	(* Gather tuples of standard/blank and its injection volume by the standard model/sample requested.
    In the form {{{standard1, volume1}, {standard1, volume2}, {standard1, volume3}}, {{standard2, volume1}}..} *)
	{gatheredStandardInjectionTuples, gatheredBlankInjectionTuples} = Map[
		GatherBy[#, First]&,
		{standardInjectionVolumeTuples, blankInjectionVolumeTuples}
	];

	(* Group each set of tuples of a given standard/blank into sets whose total injection volume
    is less than the max useable volume of the standard/blank container. Output partitions will
    be in the form: {{{standard1, volume1}, {standard1, volume2}}, {{standard1, volume2}}, {{standard2, volume3}}..}
    where volume1+volume2 <= max volume but volume1+volume2+volume3 > max volume (therefore volume3 spills
    over into another container) *)
	{standardPartitions, blankPartitions} = Map[
		Function[{injectionTuples},
			(* if we are not using the autosampler or don't have a max volume, just assume we don't have to partition anything *)
			(* need to multiply by NumberOfReplicates because that complicates everything *)
			Join @@ If[NullQ[standardBlankSampleMaxVolume],
				injectionTuples,
				Map[
					Join[
						Cases[#, {_, FlowInjection|Superloop, volume_} :> {volume}],
						GroupByTotal[Replace[Cases[#, {_, Autosampler, volume_} :> volume] * numReplicates, Null -> 0 Microliter, {1}], standardBlankSampleMaxVolume]
					]&,
					injectionTuples
				]
			]
		],
		{gatheredStandardInjectionTuples, gatheredBlankInjectionTuples}
	];

	(* The number of standard/blank containers we'll require is the number of partitions *)
	numberOfStandardBlankContainersRequired = Length[Join[standardPartitions, blankPartitions]];

	(* expand the simulated samples to account for NumberOfReplicates here *)
	expandedSimulatedSamplePackets = Flatten[ConstantArray[#, numReplicates]& /@ simulatedSamplePackets];

	(* get the container of every sample, either as an object (if we're not aliquoting) or as an ordered pair (if we are aliquoting) *)
	containersOrPair = MapThread[
		If[NullQ[#2],
			{{Download[Lookup[#1, Container], Object, Cache -> cache, Simulation -> updatedSimulation], Download[Lookup[#1, Container], Object, Cache -> cache, Simulation -> updatedSimulation]}, Lookup[#1, Position]},
			{#2, #3}
		]&,
		{expandedSimulatedSamplePackets, Lookup[resolvedAliquotOptions, AliquotContainer], Lookup[resolvedAliquotOptions, DestinationWell]}
	];

	(* get all of the unique containers *)
	(* if a sample has no container, this stuff below is going to fail; we will have already thrown an error message so this is just to prevent extra ones *)
	uniqueContainers = DeleteCases[DeleteDuplicates[containersOrPair], Null];

	(* get the model for each unique containers *)
	uniqueContainerModels = Map[
		If[MatchQ[#[[1, 2]], ObjectP[Container]],
			{{#[[1, 1]], fastAssocLookup[fastAssoc, #[[1, 2]], {Model, Object}]}, #[[2]]},
			#
		]&,
		uniqueContainers
	];

	(* here we are compiling a list of containers and the max number of each kind that can fit on the buffer sample deck *)
	(* including containers of customer choice *)
	completeContainerModelLimits = If[MatchQ[resolvedInjectionType, {Autosampler..}] || Length[nonDefaultContainers] == 0,

		validAvantContainerModelsLimits,

		Module[{containerProjectedArea, defaultContainerDimensions, defaultContainerProjectArea, maxNumberAllowed},
			(* calculate the projected area of all nondefault containers *)
			(* it will be used to check the max number of containers that can go onto the buffer sample deck *)
			containerProjectedArea = (Times @@ Take[#, 2])& /@ Download[nonDefaultContainers, Dimensions];

			(* calculate the projected area of 2L glass bottle and 500 mL glass bottle *)
			defaultContainerDimensions = Lookup[fetchPacketFromFastAssoc[#, fastAssoc], Dimensions]& /@
				Download[{Model[Container, Vessel, "2L Glass Bottle"], Model[Container, Vessel, "500mL Glass Bottle"]}, Object];
			defaultContainerProjectArea = (Times @@ Take[#, 2])& /@ defaultContainerDimensions;

			(* calculate the max number allowed containers on the sample slot *)
			(* if the non default container has projected area less than that of a 500 mL glass bottle, then we can fit 5 in the slot *)
			(* if it's bigger than that of a 2 L glass bottle, then we can only fit 2 in the slot *)
			(* if it's in between, then we can fit 4 *)
			maxNumberAllowed = Map[
				Which[
					containerProjectedArea[[#]] <= Min[defaultContainerProjectArea], nonDefaultContainers[[#]] -> 5,
					containerProjectedArea[[#]] > Max[defaultContainerProjectArea], nonDefaultContainers[[#]] -> 2,
					containerProjectedArea[[#]] > Min[defaultContainerProjectArea] && containerProjectedArea[[#]] <= Max[defaultContainerProjectArea],
					nonDefaultContainers[[#]] -> 4
				]&,
				Range[1, Length[nonDefaultContainers]]
			];

			Append[validAvantContainerModelsLimits, Association @@ maxNumberAllowed]
		]
	];

	(* if not using the autosampler on the avant system, we need to check that there are not too many containers of each type *)
	maxLimitEachContainerBool = If[MatchQ[resolvedInjectionType, {Autosampler..}],
		Null,
		Map[
			Function[{containerLimitRule},
				(* see if there is a max limit to the container type*)
				(* at this point uniqueContainerModels is of the format {{{integer(or container object), containerModel}, position}..}.  If we got this far then position is always A1 because we're talking non-autosampler (hence the [[All, 1]]: we can remove the position).*)
				(*  *)
				Count[DeleteDuplicates[uniqueContainerModels[[All, 1]]], {_Integer, ObjectP[First[containerLimitRule]]}] <= Last[containerLimitRule]
			],
			Normal[completeContainerModelLimits]
		]
	];

	(*check to see that this is passing*)
	maxLimitEachContainerQ = If[!NullQ[maxLimitEachContainerBool],And@@maxLimitEachContainerBool,True];

	(* get the number of sample containers *)
	numSampleContainers = Length[uniqueContainers];

	(* figure out if we have an invalid number of containers *)
	(* this can occur either by the total number of containers or by a specific type of container being too abundant *)
	invalidContainerCountQ = Or[
		numSampleContainers + numberOfStandardBlankContainersRequired > maxAllowedSamples,
		Not[maxLimitEachContainerQ]
	];

	(* throw a message if we have too many samples *)
	containerCountOptions = If[messagesQ && invalidContainerCountQ,
		(
			Message[Error::FPLCTooManySamples, numSampleContainers + numberOfStandardBlankContainersRequired, maxAllowedSamples];
			{AliquotContainer, Instrument, NumberOfReplicates, Standard, Blank}
		),
		{}
	];

	(* make a test for if we have too many samples *)
	containerCountTest = If[gatherTests,
		Test["Number of samples, blanks, and replicates is low enough such that the specified experiment can be run in one protocol:",
			invalidContainerCountQ,
			False
		],
		Nothing
	];

	combinedStandardsBlanks=Cases[Flatten[{resolvedStandard,resolvedBlank}],Except[Null]];

	(* currently we're only allowing object standards and blanks already in the plate to be used with the AKTA 10 *)
	standardsBlanksOutsideContainerQ = If[Not[avant25Q || avant150Q] && Or[standardExistsQ, blankExistsQ],
		(*if we have a model, throw the error*)
		If[MemberQ[combinedStandardsBlanks, ObjectP[Model[Sample]]],
			True,
			(*otherwise check the container of the blank/standards*)
			standardBlankContainers = Map[
				Function[{standardBlank},
					Download[Lookup[fetchPacketFromFastAssoc[standardBlank, fastAssoc], Container], Object]
				],
				combinedStandardsBlanks
			];
			(*when combined with the sample containers, do we have more than one*)
			Count[DeleteDuplicates@Flatten[{standardBlankContainers, containersOrPair}], ObjectP[Object[Container]]] > 1
		],
		False
	];
	standardsBlanksOutsideContainerOptions = If[messagesQ && standardsBlanksOutsideContainerQ,
		(
			Message[Error::StandardsBlanksOutside];
			{Standard,Blank}
		),
		{}
	];
	standardsBlanksOutsideContainerTest = If[gatherTests,
		Test["If an AKTA 10 system is used and standards or blanks are requested, they're already in the same plate:",
			standardsBlanksOutsideContainerQ,
			False
		],
		Nothing
	];

	(*now check whether certain options were set in ways unavailable to the avant 10*)
	restrictedFeaturesForAKTA10:=Association[
		InjectionType :> Flow|Superloop|_?(MemberQ[#, FlowInjection|Superloop]&),
		FractionCollectionMode :> Time|{___,Time,___},
		ColumnPrimeGradient :> Except[Null],
		ColumnFlushGradient :> Except[Null],
		ColumnRefreshFrequency :> Except[None|Null]
	];

	(*map through if the AKTA 10 and figure out what options are not specified correctly*)
	restrictedFeaturesOptions = If[Not[avant25Q || avant150Q],
		PickList[
			Keys[restrictedFeaturesForAKTA10],
			KeyValueMap[
				Function[{option, pattern},
					MatchQ[Lookup[resolvedExperimentOptions, option], pattern]
				],
				restrictedFeaturesForAKTA10
			]
		],
		{}
	];
	If[messagesQ && Length[restrictedFeaturesOptions]>0,
		Message[Error::FeatureUnavailableFPLCInstrument,restrictedFeaturesOptions]
	];
	restrictedFeaturesTest = If[gatherTests,
		Test["If using the AKTA 10, an unavailable feature is not requested:",
			Length[restrictedFeaturesOptions]>0,
			False
		],
		Nothing
	];

	(* if we are using an instrument besides the avant, FractionCollectionTemperature must be Ambient (or Null) *)
	invalidFractionCollectionTemperatureQ = Not[avant150Q || avant25Q] && Not[MatchQ[resolvedFractionCollectionTemperature, Ambient | Null]];

	(* throw a message if we are setting the fraction collection temperature incorrectly *)
	invalidFractionCollectionTemperatureOptions = If[messagesQ && invalidFractionCollectionTemperatureQ,
		(
			Message[Error::InvalidFractionCollectionTemperature, resolvedFractionCollectionTemperature, resolvedInstrument];
			{FractionCollectionTemperature, Instrument}
		),
		{}
	];

	(* make a test for if we have the fraction temperature specified *)
	invalidFractionCollectionTemperatureTest = If[gatherTests,
		Test["If FractionCollectionTemperature is specified to a value besides Ambient, " <> ObjectToString[resolvedInstrument,Cache->simulatedCache] <> " must support fraction temperature control:",
			invalidFractionCollectionTemperatureQ,
			False
		],
		Nothing
	];

	(* if we are using an avant but not using the autosampler, sample temperature must be Ambient *)
	invalidSampleTemperatureQ = (avant150Q || avant25Q) && Not[MatchQ[allInjectionTypes, {Autosampler..}]] && TemperatureQ[specifiedSampleTemperature];
	invalidSampleTemperatureOptions = If[messagesQ && invalidSampleTemperatureQ,
		(
			Message[Error::InvalidSampleTemperature, specifiedSampleTemperature, maxInjectionVolume];
			{InjectionVolume, StandardInjectionVolume, BlankInjectionVolume, SampleTemperature}
		),
		{}
	];

	(* make a test for if we have the sample temperature specified *)
	invalidSampleTemperatureTest = If[gatherTests,
		Test["If SampleTemperature is specified to a value besides Ambient, all InjectionVolumes must be below " <> ObjectToString[maxInjectionVolume] <> ":",
			invalidSampleTemperatureQ,
			False
		]
	];

	(* get the maximum flow rate of the column and instrument *)
	(* need the minimum since we can have multiple columns *)
	columnMaxFlowRate = Min[Lookup[resolvedColumnModelPackets, MaxFlowRate]];
	instrumentMaxFlowRate = Lookup[resolvedInstrumentModelPacket, MaxFlowRate];

	(* get the actual max flow rate *)
	actualMaxFlowRate = Min[{columnMaxFlowRate, instrumentMaxFlowRate}];

	(* get the option sets that have flow rates too high *)
	optionsAboveMaxFlowRate = PickList[
		{FlowRate, StandardFlowRate, BlankFlowRate, ColumnPrimeFlowRate, ColumnFlushFlowRate},
		{resolvedFlowRates, resolvedStandardFlowRates, resolvedBlankFlowRates, resolvedColumnPrimeFlowRate, resolvedColumnFlushFlowRate},
		_?(MemberQ[#, GreaterP[columnMaxFlowRate]]&) | GreaterP[actualMaxFlowRate]
	];

	(* get the values over the max flow rate *)
	valuesOverMaxFlowRate = Map[
		Which[
			MatchQ[#, GreaterP[actualMaxFlowRate]], #,
			MemberQ[#, GreaterP[actualMaxFlowRate]], Cases[#, GreaterP[actualMaxFlowRate]],
			True, Nothing
		]&,
		{resolvedFlowRates, resolvedStandardFlowRates, resolvedBlankFlowRates, resolvedColumnPrimeFlowRate, resolvedColumnFlushFlowRate}
	];

	(* figure out if there are any flow rates above this *)
	overMaxFlowRateQ = Not[MatchQ[optionsAboveMaxFlowRate, {}]];
	overMaxFlowRateOptions = If[messagesQ && overMaxFlowRateQ,
		(
			Message[Error::FlowRateAboveMax, ObjectToString[optionsAboveMaxFlowRate], ObjectToString[valuesOverMaxFlowRate], ObjectToString[resolvedInstrument,Cache->simulatedCache], ObjectToString[resolvedColumn,Cache->simulatedCache], ObjectToString[actualMaxFlowRate]];
			Flatten[{Column, Instrument, optionsAboveMaxFlowRate}]
		),
		{}
	];

	(* make a test for if we're above the max flow rate *)
	overMaxFlowRateTest = If[gatherTests,
		Test["All flow rates are below the maximum flow rates of the column(s) and instrument:",
			overMaxFlowRateQ,
			False
		],
		Nothing
	];

	(* if using the old akta and MaxFractionVolume is above 2 mL, throw an error *)
	overMaxFractionVolumeQ = Not[avant25Q || avant150Q] && MemberQ[maxFractionVolumes, GreaterP[2 Milliliter]];
	overMaxFractionVolumeOptions = If[messagesQ && overMaxFractionVolumeQ,
		(
			Message[Error::FractionVolumeAboveMax, Cases[maxFractionVolumes, GreaterP[2 Milliliter]], resolvedInstrument];
			{Instrument, MaxFractionVolume}
		),
		{}
	];

	(* make a test for having fraction volumes too high *)
	overMaxFractionVolumeTest = If[gatherTests,
		Test["MaxFractionVolume is below the maximum allowed by the specified instrument:",
			overMaxFractionVolumeQ,
			False
		],
		Nothing
	];

	(* figure out if PeakSlope/PeakMinimumDuration/PeakSlopeThreshold agree with each other *)
	(* only in the case where Mode is peak *)
	agreeingPeakSlopeQs = MapThread[
		Or[
			If[MatchQ[#4, Peak], MatchQ[#1, UnitsP[AbsorbanceUnit / Second]] && MatchQ[#2, UnitsP[Second]] && MatchQ[#3, UnitsP[AbsorbanceUnit / Second]], True],
			If[MatchQ[#4, Peak], MatchQ[#4, Peak] && MatchQ[#1, UnitsP[Millisiemen / (Centimeter Second)]] && MatchQ[#2, UnitsP[Second]] && MatchQ[#3, UnitsP[Millisiemen / (Centimeter  Second)]], True]
		]&,
		{peakSlopes, peakMinimumDurations, peakSlopeEnds, resolvedFractionCollectionMode}
	];
	conflictingPeakSlopeOptions = If[messagesQ && Not[MatchQ[agreeingPeakSlopeQs, {True..}]],
		(
			Message[Error::ConflictingPeakSlopeOptions];
			{PeakSlope, PeakMinimumDuration, PeakSlopeEnd}
		),
		{}
	];

	(* make a test if the peak slope options are conflicting *)
	conflictingPeakSlopeTest = If[gatherTests,
		Test["PeakSlope, PeakMinimumDuration, and PeakSlopeThreshold are either all specified or all Null:",
			agreeingPeakSlopeQs,
			{True..}
		]
	];

	(* figure out the collectfraction option is compatible with everything else *)
	conflictingFractionQs = MapThread[
		Function[{collectFraction, absThreshold, slope, slopeDuration, endThreshold, fractionCollectionMode},
			(*collect fraction can not be on when everything is off and vice versa*)
			Which[
				MatchQ[collectFraction,True]&&MatchQ[{absThreshold, slope, fractionCollectionMode},{Null,Null, Null}],True,
				MatchQ[collectFraction,True]&&NullQ[fractionCollectionMode],True,
				MatchQ[collectFraction,False]&&MatchQ[{absThreshold, slope, slopeDuration, endThreshold, fractionCollectionMode},Except[{Null..}]],True,
				True,False
			]
		],
		{collectFractions, absoluteThresholds, peakSlopes, peakMinimumDurations, peakEndThresholds, resolvedFractionCollectionMode}
	];
	conflictingFractionOptions = If[messagesQ && (Or@@conflictingFractionQs),
		(
			Message[Error::ConflictingFractionOptions];
			{CollectFractions}
		),
		{}
	];
	(* make a test if the fraction collecetion threshold/peak options are conflicting *)
	conflictingFractionTest = If[gatherTests,
		Test["The AbsoluteThreshold, PeakSlope, PeakMinimumDuration, FractionCollectionMode, and PeakEndThreshold options must agree with the CollectFractions option:",
			conflictingFractionCollectionQs,
			{False..}
		]
	];

	(* figure out if FractionCollectionMethod conflicts with the thresholding fields *)
	conflictingFractionCollectionQs = MapThread[
		Function[{fractionCollectionMode, absThreshold, slope, slopeDuration, slopeEnd, thresholdEnd},
			Which[
				NullQ[fractionCollectionMode] || MatchQ[fractionCollectionMode, Time], Not[NullQ[absThreshold] && NullQ[slope] && NullQ[slopeDuration] && NullQ[slopeEnd]],
				MatchQ[fractionCollectionMode, Threshold], Not[NullQ[slope] && NullQ[slopeEnd]],
				MatchQ[fractionCollectionMode, Peak], Not[NullQ[absThreshold]&&NullQ[thresholdEnd]],
				True, False
			]
		],
		{resolvedFractionCollectionMode, absoluteThresholds, peakSlopes, peakMinimumDurations, peakSlopeEnds, peakEndThresholds}
	];
	conflictingFractionCollectionOptions = If[messagesQ && Not[MatchQ[conflictingFractionCollectionQs, {False..}]],
		(
			Message[Error::ConflictingFractionCollectionOptions];
			{FractionCollectionMode, AbsoluteThreshold, PeakSlope, PeakMinimumDuration, PeakSlopeEnd}
		),
		{}
	];

	(* make a test if the fraction collecetion threshold/peak options are conflicting *)
	conflictingFractionCollectionTest = If[gatherTests,
		Test["The AbsoluteThreshold, PeakSlope, PeakMinimumDuration, and PeakEndThreshold options must agree with the FractionCollectionMethod option:",
			conflictingFractionCollectionQs,
			{False..}
		]
	];

	(* make sure if we're using the old akta, can't do peak thresholding except with absorbance *)
	oldAktaIncompatibleThresholdOptions = If[Not[avant150Q] && Not[avant25Q],
		{
			If[MemberQ[absoluteThresholds, UnitsP[Millisiemen/Centimeter]], AbsoluteThreshold, Nothing],
			If[MemberQ[peakEndThresholds, UnitsP[Millisiemen/Centimeter]], PeakEndThreshold, Nothing],
			If[MemberQ[peakSlopes, UnitsP[Millisiemen/(Centimeter Second)]], PeakSlope, Nothing]
		},
		{}
	];
	conductivityThresholdNotSupportedOptions = If[messagesQ && Not[MatchQ[oldAktaIncompatibleThresholdOptions, {}]],
		(
			Message[Error::ConductivityThresholdNotSupported, ObjectToString[resolvedInstrument,Cache->simulatedCache], oldAktaIncompatibleThresholdOptions];
			Flatten[{Instrument, oldAktaIncompatibleThresholdOptions}]
		),
		{}
	];

	(* make a test for if we're using the old akta and trying to threshold by conductivity *)
	conductivityThresholdNotSupportedTest = If[gatherTests,
		Test["If using an instrument other than the Avant 25 or Avant 150, peak threshold options are only be in units of Absorbance:",
			oldAktaIncompatibleThresholdOptions,
			{}
		]
	];

	(* get whether the SamplesInStorage option is ok *)
	samplesInStorage = Lookup[myOptions, SamplesInStorageCondition];

	(* Check whether the samples are ok *)
	{validContainerStorageConditionBool, validContainerStorageConditionTests} = If[gatherTests,
		ValidContainerStorageConditionQ[mySamples, samplesInStorage, Cache->cache, Simulation -> updatedSimulation, Output -> {Result, Tests}],
		{ValidContainerStorageConditionQ[mySamples, samplesInStorage, Cache->cache, Simulation -> updatedSimulation, Output -> Result], {}}
	];
	validContainerStoragConditionInvalidOptions = If[MemberQ[validContainerStorageConditionBool, False], SamplesInStorageCondition, Nothing];


	(* Check our invalid input and invalid option variables and throw Error::InvalidInput or Error::InvalidOption if necessary. *)
	invalidInputs = DeleteDuplicates[Flatten[{discardedInvalidInputs, containerlessInvalidInputs,incompatibleContainerInput}]];
	invalidOptions = DeleteDuplicates[Flatten[{
		nameInvalidOptions,
		invalidInjectionTableOptions,
		invalidStandardBlankOptions,
		incompatibleColumnTechniqueOptions,
		gradientStartEndSpecifiedAdverselyOptions,
		gradientShortcutOptions,
		gradientInjectionTableSpecifiedDifferentlyOptions,
		invalidGradientCompositionOptions,
		multipleGradientsColumnPrimeFlushOptions,
		fractionCollectionEndTimeOptions,
		containerCountOptions,
		invalidFractionCollectionTemperatureOptions,
		invalidSampleTemperatureOptions,
		overMaxFlowRateOptions,
		notAllowedDetectorsOptions,
		tooManyWavelengthsOptions,
		wrongWavelengthOptions,
		overMaxFractionVolumeOptions,
		tooManyBufferOptions,
		foreignStandardOptions,
		foreignBlankOptions,
		injectionVolumesAutosamplerIncompatibleOptions,
		injectionVolumesFlowInjectionIncompatibleOptions,
		injectionVolumesSuperloopIncompatibleOptions,
		conflictingPeakSlopeOptions,
		conflictingFractionCollectionOptions,
		conductivityThresholdNotSupportedOptions,
		invalidStandardConflictOptions,
		invalidBlankConflictOptions,
		columnPrimeOptionInjectionTableOptions,
		columnFlushOptionInjectionTableOptions,
		tooLongOptions,
		reverseDirectionConflictOptions,
		conflictingFractionOptions,
		standardsBlanksOutsideContainerOptions,
		nonBinaryOptions,
		loopInjectionConflictOptions,
		restrictedFeaturesOptions,
		sampleFlowRateConflictOptions,
		anySingletonGradientOptions,
		gradientPurgeConflictOptions,
		validContainerStoragConditionInvalidOptions,
		flowInjectionPurgeCycleConflictOptions,
		invalidSampleLoopDisconnectConflictOptions,
		invalidSampleLoopDisconnectInstrumentConflictOptions,
		superloopMixedAndMatchedOptions,
		invalidStandardSampleLoopDisconnectConflictOptions,
		invalidBlankSampleLoopDisconnectConflictOptions
	}]];


	(*combine all of the tests*)
	allTests = Cases[Flatten[{
		discardedSamplePacketsTest,
		containersExistTest,
		allRoundingTests,
		validNameTest,
		invalidStandardBlankTests,
		gradientStartEndSpecifiedAdverselyTest,
		gradientShortcutTest,
		gradientStartEndBConflictTests,
		gradientInjectionTableSpecifiedDifferentlyTest,
		invalidGradientCompositionTest,
		containerCountTest,
		resolveAliquotOptionTests,
		insufficientVolumeTest,
		incompatibleSamplesTest,
		multipleGradientsColumnPrimeFlushTest,
		fractionCollectionEndTimeTest,
		bufferClashWarnings,
		columnTechniqueTest,
		typeColumnTest,
		noCollectionSpecifiedTest,
		invalidFractionCollectionTemperatureTest,
		invalidSampleTemperatureTest,
		overMaxFlowRateTest,
		notAllowedDetectorsTest,
		tooManyWavelengthsTest,
		wrongWavelengthTest,
		overMaxFractionVolumeTest,
		tooManyBufferTest,
		nonFilteredBufferTests,
		foreignStandardTest,
		foreignBlankTest,
		injectionVolumesIncompatibleTest,
		conflictingPeakSlopeTest,
		conflictingFractionCollectionTest,
		conductivityThresholdNotSupportedTest,
		standardConflictTest,
		blankConflictTest,
		columnPrimeOptionInjectionTableTest,
		columnFlushOptionInjectionTableTest,
		invalidInjectionTableTests,
		tooLongTest,
		reverseDirectionTest,
		conflictingFractionTest,
		standardsBlanksOutsideContainerTest,
		nonBinaryGradientTest,
		loopInjectionConflictTest,
		restrictedFeaturesTest,
		flowCellNearestTest,
		removedExtraTest,
		sampleFlowRateConflictTest,
		anySingletonGradientTest,
		mixerNearestTest,
		incompatibleContainerTest,
		flowInjectionPurgeCycleConflictTest,
		gradientReequilibratedWarning,
		sampleLoopDisconnectConflictTest,
		sampleLoopDisconnectInstrumentConflictTest,
		superloopMixedAndMatchedTest
	}], _EmeraldTest];

	(* Throw Error::InvalidInput if there are invalid inputs. *)
	If[Length[invalidInputs] > 0 && messagesQ,
		Message[Error::InvalidInput, ObjectToString[invalidInputs, Cache -> simulatedCache]]
	];

	(* Throw Error::InvalidOption if there are invalid options. *)
	If[Length[invalidOptions] > 0 && messagesQ,
		Message[Error::InvalidOption, invalidOptions]
	];

	(* Join all resolved options *)
	resolvedOptions = Flatten[{
		resolvedExperimentOptions,
		resolvedSamplePrepOptions,
		resolvedAliquotOptions,
		resolvedPostProcessingOptions
	}];

	(* Return our resolved options and/or tests. *)
	outputSpecification /. {
		Result -> resolvedOptions,
		Tests -> allTests
	}
];

(* ::Subsubsection:: *)
(*fplcResourcePackets*)

DefineOptions[
	fplcResourcePackets,
	Options :> {HelperOutputOption, CacheOption, SimulationOption}
];

fplcResourcePackets[mySamples : {ObjectP[Object[Sample]]..}, myUnresolvedOptions : {___Rule}, myResolvedOptions : {___Rule}, ops : OptionsPattern[fplcResourcePackets]] := Module[
	{
		outputSpecification, output, gatherTests, messages, numReplicates, protocolPacket, sharedFieldPacket, finalizedPacket,
		allResourceBlobs, fulfillable, frqTests, testsRule, resultRule, samplesWithReplicates, optionsWithReplicates, totalRunTime,
		uniqueGradientPackets, allPackets, injectionTable, instrumentResource, sampleLoopResource,
		instrumentSystemPrimeGradientMethod, instrumentSystemFlushGradientMethod, instrumentSystemPrimeGradientPacket, instrumentSystemFlushGradientPacket,
		bufferDeadVolume, instrumentSystemPrimeGradient, instrumentSystemFlushGradient,replacedFractionPackets,
		systemPrimeBufferAVolume, systemPrimeBufferBVolume, uniqueSamplePackets, sampleContainers, uniquePlateContainers,
		systemPrimeBufferAModel, systemPrimeBufferBModel, systemFlushBufferAModel, systemFlushBufferBModel,
		systemPrimeBufferAResource, systemPrimeBufferBResource, systemPrimeBufferCResource, systemPrimeBufferDResource, systemPrimeBufferEResource, systemPrimeBufferFResource, systemPrimeBufferGResource, systemPrimeBufferHResource, allSystemPrimeBufferResources,
		systemPrimeBufferTime, systemPrimeBufferFlowRate, systemPrimeGradientTuples,
		systemFlushBufferAResource, systemFlushBufferBResource, systemFlushBufferCResource, systemFlushBufferDResource, systemFlushBufferEResource, systemFlushBufferFResource, systemFlushBufferGResource, systemFlushBufferHResource, allSystemFlushBufferResources,
		systemFlushBufferTime, systemFlushBufferFlowRate, systemFlushGradientTuples,
		lowFractionVolumes, medFractionVolumes, highFractionVolumes, veryHighFractionVolumes,
		uniqueSamples, uniqueSampleResources, sampleResources, samplePositions, sampleTuples, insertionAssociation, injectionTableInserted, injectionTableWithReplicates,
		systemFlushBufferAVolume, systemFlushBufferBVolume, makeReverseRules, sampleSampleFlowRate,
		tableGradients, sampleGradient, standardGradient, blankGradient, columnPrimeGradient, columnFlushGradient,
		resolvedGradients, gradientMethodInPlaceP, gradientObjectsToMake, injectionTableFull, cache,
		fractionCollectionVolumes, fractionCollectionVolumesNoNull,
		columnResources, fractionPackets, existingFractionCollectionMethods, newFractionPackets,
		standardPositions, blankPositions, columnPrimePositions, columnFlushPositions,
		standardLookup, blankLookup, standardMappingRules, blankMappingRules,
		standardReverseRules, blankReverseRules, collectFractionsQ, fractionContainerResources,
		fractionContainerRackResources, sampleReverseRules, fractionContainers, fractionContainerRacks,
		vialSampleMaxVolumeRules, vialDeadVolumeRules, preferredVialContainerRules, standardTuples, assignedStandardTuples, groupedStandardsTuples,
		groupedStandardsPositionVolumes, groupedStandardShared, groupedStandard, flatStandardResources, linkedStandardResources, standardContainers,
		blankTuples, assignedBlankTuples, groupedBlanksTuples, linkedSampleResources, injectionTableWithLinks,
		groupedBlanksPositionVolumes, groupedBlankShared, groupedBlank, flatBlankResources, linkedBlankResources,
		standardPositionsCorresponded, blankPositionsCorresponded, blankContainers,
		columnPrimeGradientA, columnPrimeGradientB,availableMixers, availableMixerVolumes, mixerResource,
		columnPrimeFlowRates,columnPrimeFlowDirections, samplePrepOptions, dontNeedThis, simulatedSamples, resolvedSamplePrepOptions, simulatedFastAssoc,
		sampleGradientA, sampleGradientB, sampleFlowRates,
		standardGradientA, standardGradientB, standardFlowRates,
		blankGradientA, blankGradientB, blankFlowRates,low96WellVolumes, low48WellVolumes,
		columnFlushGradientA, columnFlushGradientB, fastAssoc,
		columnFlushFlowRates,columnFlushFlowDirections,bufferCTableAmounts, bufferDTableAmounts, injectionTableUploadable, allGradients, allGradientTuples,
		allTimes, noAutosamplerQ,bufferAList, bufferBList,
		systemPrimeBufferPlacements, systemFlushBufferPlacements,
		systemPrimeFlushGradientObjects, systemPrimeFlushGradientPackets,
		uniqueContainers, eachContainerModelPacket, eachContainerModel, connectors,
		eachMaxVolume,sampleCaps, sampleCapResources, systemPrimeSampleCleaningBufferResources,
		systemFlushSampleCleaningBufferResources,
		sampleGradientC, sampleGradientD, sampleBufferC, sampleBufferD, standardGradientC, standardGradientD,
		standardBufferC, standardBufferD,blankGradientC, blankGradientD, blankBufferC, blankBufferD,
		columnPrimeGradientC, columnPrimeGradientD, columnPrimeBufferC, columnPrimeBufferD,
		columnFlushGradientC, columnFlushGradientD, allInjectionTypes, anyFlowInjectionQ, standardInjectionTypes,
		blankInjectionTypes,
		expandedInputs, expandedResolvedOptions, resolvedOptionsNoHidden, allDownloadValues, potentialInstrumentPacket,
		potentialInstrumentModelPacket, inheritedCache, resolvedInstrument, resolvedInstrumentModelPacket, avant25Q, avant150Q,
		allInjectionVolumes, largestInjectionVolume, resolvedAliquotAmount, resolvedAssayVolume, dilutionFactor, potentialColumnPackets,
		potentialColumnModelPackets, resolvedColumns, resolvedColumnModelPackets, allSystemGradients,  allResolvedBuffers, tableFlowRates,
		flowRatesForNewGradients, simulation, updatedSimulation,
		makeNullLists, tableFlushTimes, sampleFlushTimes, sampleEquilibrationTime, tableEquilibrationTimes, flushTimeForNewGradients,
		equilibrationTimesForNewGradients, injectionTableGradients, existingInjectionTableGradients,
		bufferASelectionResources, bufferBSelectionResources, bufferPlacements,
		initialColumnPrimeFlowRates, initialColumnFlushFlowRates, initialSampleFlowRates, initialStandardFlowRates, initialBlankFlowRates,
		flowCellResource,bufferA, bufferB, bufferC, bufferD, bufferE, bufferF, bufferG, bufferH,
		bufferAResource, bufferBResource, bufferCResource, bufferDResource, bufferEResource, bufferFResource, bufferGResource, bufferHResource,
		columnPrimeGradientE, columnPrimeGradientF, columnPrimeGradientG, columnPrimeGradientH, sampleGradientE, sampleGradientF, sampleGradientG,
		sampleGradientH,standardGradientE, standardGradientF, standardGradientG, standardGradientH, blankGradientE,
		blankGradientF, blankGradientG, blankGradientH, columnFlushGradientE, columnFlushGradientF, columnFlushGradientG, columnFlushGradientH,
		bufferATableAmount, bufferBTableAmount, bufferCTableAmount, bufferDTableAmount, bufferETableAmount, bufferFTableAmount,
		bufferGTableAmount, bufferHTableAmount, sampleCapContainerModel, sampleCapContainerMaxVolume, simulatedContainers, vesselToCapsRules,
		uniqueSimulatedContainers, sampleCapsInner, bufferAWashAmount, bufferBWashAmount, bufferCWashAmount, bufferDWashAmount,
		blankContainersForCaps, blankCapsInner, blankVesselToCapsRules, simulatedContainersWithNulls, containerModelVesselsOnly,
		bufferEWashAmount, bufferFWashAmount, bufferGWashAmount, bufferHWashAmount, standardContainersForCaps,
		standardCapsInner, standardVesselToCapsRules, injectionTableNulls, containerModelReplacePartRules,
		containerModelPacketsWithNulls, allVesselToCapRules, sampleNames, standardNames, blankNames, nameReplacePartRules,
		columnModels, resolvedColumnAdapters, columnAdapterResources, sampleCapLabels,
		flowInjectionPurgeMethodNames, flowInjectionPurgeContainers, sampleCapPositions, blankCapPositions, standardCapPositions,
		pHCalibrationVolume, lowpHBufferResource, highpHBufferResource, calibrationWashSolutionResource, relevantSyringe, 
		lowpHBufferSyringe, highpHBufferSyringe, calibrationWashSolutionSyringe, lowpHBufferNeedle, highpHBufferNeedle, 
		calibrationWashSolutionNeedle, lowpHTarget, highpHTarget, pHCalibrationStorageBufferResource, pHCalibrationStorageBufferSyringeResource,
		pHCalibrationStorageBufferSyringeNeedleResource,autosamplerInjectionWashBufferResource
	},

	(* expand the resolved options if they weren't expanded already *)
	{expandedInputs, expandedResolvedOptions} = ExpandIndexMatchedInputs[ExperimentFPLC, {mySamples}, myResolvedOptions];

	(* get the resolved collapsed index matching options that don't include hidden options *)
	resolvedOptionsNoHidden = CollapseIndexMatchedOptions[
		ExperimentFPLC,
		RemoveHiddenOptions[ExperimentFPLC, myResolvedOptions],
		Ignore -> myUnresolvedOptions,
		Messages -> False
	];

	(* Determine the requested output format of this function. *)
	outputSpecification = Lookup[expandedResolvedOptions, Output];
	output = ToList[outputSpecification];

	(* Determine if we should keep a running list of tests to return to the user. *)
	gatherTests = MemberQ[output, Tests];
	messages = Not[gatherTests];

	(*get the cache*)
	inheritedCache = Lookup[ToList[ops], Cache, {}];
	simulation = Lookup[ToList[ops], Simulation, Simulation[]];

	(* find all system gradients with AKTA Avant in them (i.e., all the FPLC system flush/prime gradients *)
	allSystemGradients = fplcSystemGradientSearch["Memoization"];

	(* get all the specified buffers *)
	allResolvedBuffers = Cases[Flatten[
		Lookup[
			expandedResolvedOptions,
			{
				BufferA,
				BufferB,
				BufferC,
				BufferD,
				BufferE,
				BufferF,
				BufferG,
				BufferH
			}
		]
	], ObjectP[]];

	(* get all the gradients from the injection table, but remove the ones that don't exist yet *)
	injectionTableGradients = Lookup[expandedResolvedOptions, InjectionTable][[All, 5]];
	existingInjectionTableGradients = PickList[injectionTableGradients, DatabaseMemberQ[injectionTableGradients]];

	(* simulate the sample preparation stuff so we have the right containers if we are aliquoting *)
	{simulatedSamples, updatedSimulation} = simulateSamplesResourcePacketsNew[ExperimentFPLC, mySamples, myResolvedOptions, Cache -> inheritedCache, Simulation -> simulation];

	(* --- Make our one big Download call --- *)

	(* make our one big Download call *)
	allDownloadValues = Quiet[Download[
		{
			ToList[Lookup[expandedResolvedOptions, Instrument]],
			ToList[Lookup[expandedResolvedOptions, Column]],
			Flatten[{allSystemGradients, existingInjectionTableGradients}],
			allResolvedBuffers
		},
		{
			{
				Packet[Model, Name, MinSampleVolume, MaxSampleVolume, WettedMaterials, MaxFlowRate, Detectors, DefaultMixer, AssociatedAccessories],
				Packet[Model[{Name, MinSampleVolume, MaxSampleVolume, WettedMaterials, MaxFlowRate, Detectors, DefaultMixer, AssociatedAccessories}]],
				(*get the available mixers for this instrument and the volume*)
				Packet[AssociatedAccessories[[All, 1]][{Object, Volume}]],
				Packet[Model[AssociatedAccessories][[All, 1]][{Object, Volume}]]
			},
			{
				Packet[Model, Name, SeparationMode],
				Packet[Model[{Name, SeparationMode}]]
			},
			{
				Packet[Name, DateCreated, Temperature, FlowRate, InitialFlowRate, Gradient, BufferA, BufferB, BufferC, BufferD, BufferE, BufferF, BufferG, BufferH]
			},
			{
				Packet[Model, Name]
			}
		},
		Cache -> inheritedCache,
		Simulation -> updatedSimulation
	], {Download::FieldDoesntExist, Download::NotLinkField}];

	(* add what we Downloaded to the new cache *)
	cache = FlattenCachePackets[{inheritedCache, Cases[Flatten[allDownloadValues], PacketP[]]}];
	fastAssoc = makeFastAssocFromCache[FlattenCachePackets[{cache, Lookup[First[updatedSimulation], Packets, {}]}]];

	(* pull out the instrument packet and instrument model packet (can't know for sure at this point because the Instrument option could be a model or object) *)
	potentialInstrumentPacket = allDownloadValues[[1, 1, 1]];
	potentialInstrumentModelPacket = allDownloadValues[[1, 1, 2]];

	(* figure out what instrument we're using *)
	resolvedInstrument = Lookup[expandedResolvedOptions, Instrument];
	resolvedInstrumentModelPacket = If[MatchQ[potentialInstrumentPacket, PacketP[Model[Instrument, FPLC]]],
		potentialInstrumentPacket,
		potentialInstrumentModelPacket
	];

	(* pull out the column and column model packets (can't know for sure at this point because the Column option could be a model or item) *)
	potentialColumnPackets = allDownloadValues[[2, All, 1]];
	potentialColumnModelPackets = allDownloadValues[[2, All, 2]];

	(* get the column model packets we're using *)
	resolvedColumns = ToList[Download[Lookup[expandedResolvedOptions, Column], Object]];
	resolvedColumnModelPackets = MapThread[
		If[MatchQ[#1, PacketP[Model[Item, Column]]],
			#1,
			#2
		]&,
		{potentialColumnPackets, potentialColumnModelPackets}
	];

	(* Pull out the number of replicates; make sure all Nulls become 1 *)
	numReplicates = Lookup[myResolvedOptions, NumberOfReplicates] /. {Null -> 1};

	(*expand the options based on the number of replicates*)
	{samplesWithReplicates, optionsWithReplicates} = expandNumberOfReplicates[ExperimentFPLC, Download[mySamples, Object], myResolvedOptions];

	(* Delete any duplicate input samples to create a single resource per unique sample *)
	(* using the one with replicates because that one already has Object downloaded from it *)
	uniqueSamples = DeleteDuplicates[samplesWithReplicates];

	(* Extract packets for sample objects *)
	uniqueSamplePackets = fetchPacketFromFastAssoc[#, fastAssoc]& /@ uniqueSamples;

	(*get the unique sample containers*)
	sampleContainers = Download[Lookup[uniqueSamplePackets, Container], Object];

	(*get the number of unique plate containers*)
	uniquePlateContainers = DeleteDuplicates[Cases[sampleContainers, ObjectP[Object[Container, Plate]]]];

	(* Create Resource for SamplesIn *)
	uniqueSampleResources = Resource[Sample -> #]& /@ uniqueSamples;

	(* Expand sample resources to index match mySamples *)
	sampleResources = Map[
		uniqueSampleResources[[First[FirstPosition[uniqueSamples, #]]]]&,
		Download[mySamples, Object]
	];

	(*get the resolved injection table because that will actually determine much that we do here*)
	injectionTable = Lookup[myResolvedOptions, InjectionTable];

	(*get all of the positions so that it's easy to update the injection table*)
	{samplePositions, standardPositions, blankPositions, columnPrimePositions, columnFlushPositions} = Map[
		Flatten[Position[injectionTable, {#, ___}]]&,
		{Sample, Standard, Blank, ColumnPrime, ColumnFlush}
	];

	(*look up the standards and the blanks*)
	{standardLookup, blankLookup} = Lookup[expandedResolvedOptions, {Standard, Blank}];

	(*we need to create a mapping association so the index matching from the types goes to the positions with the table
	for example, the resolvedBlank maybe length 2 (e.g. {blank1,blank2}; However this may be repeated in the injectiontable
	based on the set BlankFrequency. For example BlankFrequency -> FirstAndLast will place at the beginning at the end
	therefore, we need to have associations for each that points to the locations within the table so that it's easier to update
	the resources*)

	(*a helper function used to make the reverse dictionary so that we can go from the injection table positon to the other variables*)
	makeReverseRules[inputRules : Null] := Null;
	makeReverseRules[inputRules : {___Rule}] := SortBy[Flatten[
		KeyValueMap[
			Function[{key, value},
				# -> key & /@ value
			],
			Association[inputRules]
		]
	], First];

	(*first do the standards*)
	standardMappingRules = If[NullQ[standardLookup],
		(*first check whether there is anything here*)
		Null,
		(*otherwise we have to partition the positions by the length of our standards and map through*)
		MapIndexed[
			Function[{positionSet, index},
				First[index] -> positionSet
			],
			Transpose[Partition[standardPositions, Length[standardLookup]]]
		]
	];

	(*do the blanks in the same way*)
	blankMappingRules = If[NullQ[blankLookup],
		(*first check whether there is anything here*)
		Null,
		(*otherwise we have to partition the positions by the length of our blank and map through*)
		MapIndexed[
			Function[{positionSet, index},
				First[index] -> positionSet
			],
			Transpose[Partition[blankPositions, Length[blankLookup]]]
		]
	];

	(*make the reverse associations*)
	{standardReverseRules, blankReverseRules} = Map[
		makeReverseRules[#]&,
		{standardMappingRules, blankMappingRules}
	];

	(*also make the one for the samples*)
	sampleReverseRules = MapIndexed[
		Function[{position, index},
			position -> First[index]
		], samplePositions
	];

	(* make the resources for the column *)
	columnResources = Resource[Sample -> #, Name -> ToString[Unique[]]] & /@ DeleteDuplicates[resolvedColumns];

	(* make the resources for any column adapters *)
	(* Get the column models used *)
	columnModels = Download[Lookup[resolvedColumnModelPackets, Object],Object];

	(* Currently get two adapters per column if we use the column model with M6 connectors *)
	resolvedColumnAdapters = Table[Model[Plumbing, Fitting, "Union 1/16\" Female/M6 Male PEEK Fitting"], 2*Count[columnModels, ObjectP[{Model[Item, Column, "id:L8kPEjnM1vZG"],Model[Item, Column, "id:vXl9j57eoa4k"]}]]];

	(* Generate the resources *)
	columnAdapterResources = Resource[Sample -> #, Name -> ToString[Unique[]]] & /@ resolvedColumnAdapters;

	(*we need to figure out which gradients to make*)
	(*dereference any named objects*)
	tableGradients = Map[
		If[MatchQ[#, ObjectP[Object[Method]]],
			Download[#, Object],
			#
		]&,
		injectionTable[[All, 5]]
	];

	(*get all of the other gradients and see how many of them are objects*)
	{sampleGradient, standardGradient, blankGradient, columnPrimeGradient, columnFlushGradient} = Lookup[
		expandedResolvedOptions,
		{Gradient, StandardGradient, BlankGradient, ColumnPrimeGradient, ColumnFlushGradient}
	];

	(*all resolved gradient*)
	resolvedGradients = Join[Cases[{sampleGradient, standardGradient, blankGradient, columnPrimeGradient, columnFlushGradient}, Except[Null | {Null}]]];

	(*find all of the gradients where there is already a method*)
	(* need to Download Object to ensure we get rid of the names *)
	gradientMethodInPlaceP = Alternatives @@ Download[Flatten[Cases[resolvedGradients, ObjectReferenceP[Object[Method]], Infinity]], Object];

	(* get rid of all the graidents that were resolved from options (i.e., the ones that already exist and we don't need to make) *)
	(*we'll need to create packets for all of these gradient objects*)
	gradientObjectsToMake = Cases[tableGradients, Except[gradientMethodInPlaceP]];

	(* decide if we're using an avant or not *)
	avant25Q = MatchQ[resolvedInstrumentModelPacket, ObjectP[Model[Instrument, FPLC, "AKTA avant 25"]]];
	avant150Q = MatchQ[resolvedInstrumentModelPacket, ObjectP[Model[Instrument, FPLC, "AKTA avant 150"]]];

	(* pull out _all_ the injection volumes *)
	allInjectionVolumes = Cases[injectionTable[[All, 4]], VolumeP];
	largestInjectionVolume = Max[allInjectionVolumes];

	(* pull out all the injection types *)
	allInjectionTypes = Cases[injectionTable[[All, 3]], FPLCInjectionTypeP];
	standardInjectionTypes = Lookup[myResolvedOptions, StandardInjectionType] /. {Null -> {}};
	blankInjectionTypes = Lookup[myResolvedOptions, BlankInjectionType] /. {Null -> {}};

	(* indicate if we are doing FlowInjection at any point *)
	anyFlowInjectionQ = MemberQ[allInjectionTypes, FlowInjection];

	(* decide the maximum vial sample volume; this depends on what instrument we're using and what the biggest injection volume we're using *)
	vialSampleMaxVolumeRules = {
		Superloop -> 10 Milliliter,
		FlowInjection -> 4 Liter,
		Autosampler -> Which[
			avant25Q, 1.8 Milliliter, (* using Model[Container, Vessel, "HPLC vial (high recovery)"] *)
			avant150Q, 10 Milliliter, (* using Model[Container, Vessel, "22x45mm screw top vial 10mL"] *)
			True, 2 Milliliter (* using Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
		]
	};

	(* figure out what the vial dead volume is; it is kind of arbitrary but picking something (and for the 4 Liter case, it's _really_ hard to know so I'm just going to say 2 Milliliter since it's a total guess) *)
	vialDeadVolumeRules = {
		Superloop -> 10 Milliliter,
		FlowInjection -> 12 Milliliter,
		Autosampler -> Which[
			avant25Q, 50 Microliter, (* using Model[Container, Vessel, "HPLC vial (high recovery)"] *)
			avant150Q, 1 Milliliter, (* using Model[Container, Vessel, "22x45mm screw top vial 10mL"] *)
			True, 50 Microliter (* using Model[Container, Plate, "96-well 2mL Deep Well Plate"] *)
		]
	};

	(* decide the container we need the blanks/standards to be in *)
	(* if we we are using the avants but not using the autosampler, or if we're using the old akta, this is going to be Null *)
	preferredVialContainerRules = {
		Superloop -> Null,
		FlowInjection -> Null,
		Autosampler -> Which[
			avant25Q, Model[Container, Vessel, "HPLC vial (high recovery)"],
			avant150Q, Model[Container, Vessel, "22x45mm screw top vial 10mL"],
			True, Null (* these need to be in plates but this can't be done via the resource *)
		]
	};

	(*now we figure out injected resources*)

	(*get the standard samples out*)
	standardTuples = injectionTable[[standardPositions]];

	(*assign the position to these *)
	assignedStandardTuples = MapThread[#1 -> #2&, {standardPositions, standardTuples}];

	(*then group by the sample sample type and injection type (e.g. <|{standard1, Autosampler}->{1->{Standard,standard1,Autosampler, 10 Microliter,__},2->{Standard,standard1, Autosampler, 5 Microliter,__}}, {standard2, FlowInjection} ->... |>*)
	groupedStandardsTuples = GroupBy[assignedStandardTuples, Last[#][[{2, 3}]]&];

	(*then simplify further by selecting out the position and the injection volume <|{standard1, Autosampler}->{{1,10 Microliter},{2,5 Microliter}}*)
	groupedStandardsPositionVolumes = Map[
		Function[{eachUniqueStandard},
			Transpose[{Keys[eachUniqueStandard], Values[eachUniqueStandard][[All, 4]]}]
		],
		groupedStandardsTuples
	];

	(*we do a further grouping based on the total injection volume for example: <|{Model[Sample, StockSolution, Standard, "id:N80DNj1rWzaq"] -> {{{3, Quantity[2, "Microliters"]}}, {{7,  Quantity[2, "Microliters"]}}}, ...|>*)
	groupedStandardShared = Association[KeyValueMap[
		Function[{sampleInjectionTypePair, positionAndVolume},
			With[{vialSampleMaxVolume = Last[sampleInjectionTypePair] /. vialSampleMaxVolumeRules, vialDeadVolume = Last[sampleInjectionTypePair] /. vialDeadVolumeRules},
				sampleInjectionTypePair -> GroupByTotal[positionAndVolume, (vialSampleMaxVolume - vialDeadVolume)]
			]
		],
		groupedStandardsPositionVolumes
	]];

	(*huff huff huff... now we can finally make the resources*)
	(*we'll be left with a list of positions to a resource e.g. {{1,2}->Resource1,{3,4,5}->Resource2}*)
	groupedStandard = KeyValueMap[
		Function[{standardAndInjectionType, positionVolumes},
			With[{standard = First[standardAndInjectionType], injectionType = Last[standardAndInjectionType]},
				Sequence @@ Map[
					(*this is all of the positions*)
					#[[All, 1]] -> Resource[
						Sequence@@List[
							Sample -> standard,
							(*total the volume for the given group*)
							Amount -> Total[#[[All, 2]]] + (injectionType /. vialDeadVolumeRules),
							Name -> CreateUUID[],
							Which[
								(* if there is a preferred container already, just use it *)
								MatchQ[injectionType /. preferredVialContainerRules, ObjectP[]], Container ->  injectionType /. preferredVialContainerRules,
								(* if there is not but we are using the avants, use the bestFPLCAliquotContainerModel *)
								NullQ[injectionType /. preferredVialContainerRules] && (avant25Q || avant150Q), Container ->  bestFPLCAliquotContainerModel[Total[#[[All, 2]]] + (injectionType /. vialDeadVolumeRules)],
								(* otherwise don't ask for being in the container because we have to do it separately anyway and can't during resource picking *)
								True, Nothing
							]
						]
					]&,
					positionVolumes
				]

			]
		],
		groupedStandardShared
	];

	(*gasp... now we can flatten this list to our standards, index matched to the samples {1->Resource1, 2->Resource1, ... }*)
	flatStandardResources = SortBy[Flatten[Map[
		Function[{rule},
			Map[# -> Last[rule]&, First[rule]]
		],
		groupedStandard
	]], First];

	(*take the values and surround with link*)
	linkedStandardResources = Link[#]& /@ Values[flatStandardResources];
	standardContainers = Map[
		If[MatchQ[#[Container], ObjectP[{Model[Container], Object[Container]}]],
			#[Container],
			Null
		]&,
		Values[flatStandardResources]
	];

	(* get the standard containers *)

	(*now do the same with the blanks*)

	(*get the blank samples out*)
	blankTuples = injectionTable[[blankPositions]];

	(*assign the position to these *)
	assignedBlankTuples = MapThread[#1 -> #2&, {blankPositions, blankTuples}];

	(*then group by the sample sample type (e.g. <|blank1->{1->{Blank,blank1,Autosampler, 10 Microliter,__},2->{Blank,blank1, Autosampler, 5 Microliter,__}}, blank2 ->... |>*)
	groupedBlanksTuples = GroupBy[assignedBlankTuples, Last[#][[{2, 3}]]&];

	(*then simplify further by selecting out the positoin and the injection volume <|{blank1, Autosampler} -> {{1,10 Microliter},{2,5 Microliter}}*)
	groupedBlanksPositionVolumes = Map[
		Function[{eachUniqueBlank},
			Transpose[{Keys[eachUniqueBlank], Values[eachUniqueBlank][[All, 4]]}]
		],
		groupedBlanksTuples
	];

	(*we do a further grouping based on the total injection volume for example: <|{Model[Sample, StockSolution, "id:N80DNj1rWzaq"], Autosampler} -> {{{3, Quantity[2, "Microliters"]}}, {{7,  Quantity[2, "Microliters"]}}}, ...|>*)
	groupedBlankShared = Association[KeyValueMap[
		Function[{sampleInjectionTypePair, positionAndVolume},
			With[{vialSampleMaxVolume = Last[sampleInjectionTypePair] /. vialSampleMaxVolumeRules, vialDeadVolume = Last[sampleInjectionTypePair] /. vialDeadVolumeRules},
				sampleInjectionTypePair -> GroupByTotal[positionAndVolume, (vialSampleMaxVolume - vialDeadVolume)]
			]
		],
		groupedBlanksPositionVolumes
	]];

	(*huff huff huff... now we can finally make the resources*)
	(*we'll be left with a list of positions to a resource e.g. {{1,2}->Resource1,{3,4,5}->Resource2}*)
	groupedBlank = KeyValueMap[
		Function[{blankAndInjectionType, positionVolumes},
			With[{blank = First[blankAndInjectionType], injectionType = Last[blankAndInjectionType]},
				Sequence @@ Map[
					(*this is all of the positions*)
					#[[All, 1]] -> Resource[
						Sequence@@List[
							Sample -> blank,
							(*total the volume for the given group*)
							Amount -> Total[#[[All, 2]]] + (injectionType /. vialDeadVolumeRules),
							Name -> CreateUUID[],
							Which[
								(* if there is a preferred container already, just use it *)
								MatchQ[injectionType /. preferredVialContainerRules, ObjectP[]], Container ->  injectionType /. preferredVialContainerRules,
								(* if there is not but we are using the avants, use the PreferredContainer *)
								NullQ[injectionType /. preferredVialContainerRules] && (avant25Q || avant150Q), Container ->  bestFPLCAliquotContainerModel[Total[#[[All, 2]]] + (injectionType /. vialDeadVolumeRules)],
								(* otherwise don't ask for being in the container because we have to do it separately anyway and can't during resource picking *)
								True, Nothing
							]
						]
					]&,
					positionVolumes
				]

			]
		],
		groupedBlankShared
	];

	(*gasp... now we can flatten this list to our blanks, index matched to the samples {1->Resource1, 2->Resource1, ... }*)
	flatBlankResources = SortBy[Flatten[Map[
		Function[{rule},
			Map[# -> Last[rule]&, First[rule]]
		],
		groupedBlank
	]], First];

	(*take the values and surround with link*)
	linkedBlankResources = Link[#]& /@ Values[flatBlankResources];
	blankContainers = Map[
		If[MatchQ[#[Container], ObjectP[{Model[Container], Object[Container]}]],
			#[Container],
			Null
		]&,
		Values[flatBlankResources]
	];

	(*now let's update everything within our injection table*)
	linkedSampleResources = Link[#]& /@ sampleResources;

	(*for the system prime and flush we will defer to the default method; the gradient we use depends on the separation mode of the column *)
	{instrumentSystemPrimeGradientMethod,instrumentSystemFlushGradientMethod}=With[{avantNumber=Which[avant25Q," 25",avant150Q," 150",True,""]},
		Switch[Lookup[First[resolvedColumnModelPackets], SeparationMode],

			IonExchange,
			{Object[Method, Gradient, "IonExchange System Prime Method-AKTA Avant"<>avantNumber], Object[Method, Gradient, "IonExchange System Flush Method-AKTA Avant"<>avantNumber]},

			SizeExclusion,
			{Object[Method, Gradient, "SizeExclusion System Prime Method-AKTA Avant"<>avantNumber], Object[Method, Gradient, "SizeExclusion System Flush Method-AKTA Avant"<>avantNumber]},

			ReversePhase,
			{Object[Method, Gradient, "ReversePhase System Prime Method-AKTA Avant"<>avantNumber], Object[Method, Gradient, "ReversePhase System Flush Method-AKTA Avant"<>avantNumber]},

			NormalPhase,
			{Object[Method, Gradient, "NormalPhase System Prime Method-AKTA Avant"<>avantNumber], Object[Method, Gradient, "NormalPhase System Flush Method-AKTA Avant"<>avantNumber]},

			(* ultimately default to the size exclusion system *)
			_,
			{Object[Method, Gradient, "SizeExclusion System Prime Method-AKTA Avant"<>avantNumber], Object[Method, Gradient, "SizeExclusion System Flush Method-AKTA Avant"<>avantNumber]}
		]
	];

	(*get the packet from the cache*)
	instrumentSystemPrimeGradientPacket = fetchPacketFromFastAssoc[Download[instrumentSystemPrimeGradientMethod, Object], fastAssoc];
	instrumentSystemFlushGradientPacket = fetchPacketFromFastAssoc[Download[instrumentSystemFlushGradientMethod, Object], fastAssoc];

	(*get the gradient tuple*)
	instrumentSystemPrimeGradient = Lookup[instrumentSystemPrimeGradientPacket, Gradient, Null];
	instrumentSystemFlushGradient = Lookup[instrumentSystemFlushGradientPacket, Gradient, Null];

	(* tbh don't really know this but should figure it out better *)
	bufferDeadVolume = 800 Milliliter;

	(*start with the column prime*)
	{
		columnPrimeGradientA,
		columnPrimeGradientB,
		columnPrimeGradientC,
		columnPrimeGradientD,
		columnPrimeGradientE,
		columnPrimeGradientF,
		columnPrimeGradientG,
		columnPrimeGradientH,
		columnPrimeFlowRates,
		columnPrimeFlowDirections
	} = Map[
		ConstantArray[#, Length[columnPrimePositions]]&,
		Lookup[expandedResolvedOptions, {
			ColumnPrimeGradientA,
			ColumnPrimeGradientB,
			ColumnPrimeGradientC,
			ColumnPrimeGradientD,
			ColumnPrimeGradientE,
			ColumnPrimeGradientF,
			ColumnPrimeGradientG,
			ColumnPrimeGradientH,
			ColumnPrimeFlowRate,
			ColumnPrimeFlowDirection
		}]
	];

	(*now get the samples, which will always be there, so no mapping checks/positioning needed*)
	{
		sampleGradientA,
		sampleGradientB,
		sampleGradientC,
		sampleGradientD,
		sampleGradientE,
		sampleGradientF,
		sampleGradientG,
		sampleGradientH,
		sampleFlowRates,
		sampleFlushTimes,
		sampleEquilibrationTime,
		sampleSampleFlowRate
	} = Lookup[expandedResolvedOptions, {
		GradientA,
		GradientB,
		GradientC,
		GradientD,
		GradientE,
		GradientF,
		GradientG,
		GradientH,
		FlowRate,
		FlushTime,
		EquilibrationTime,
		SampleFlowRate
	}];


	(*to fill in the parameters we just need the injection table positions corresponded to the pertinent ones*)
	standardPositionsCorresponded = If[Length[standardPositions] > 0, Last /@ SortBy[standardReverseRules, First]];
	blankPositionsCorresponded = If[Length[blankPositions] > 0, Last /@ SortBy[blankReverseRules, First]];

	(*now the standard samples*)
	{
		standardGradientA,
		standardGradientB,
		standardGradientC,
		standardGradientD,
		standardGradientE,
		standardGradientF,
		standardGradientG,
		standardGradientH,
		standardFlowRates
	} = Map[
		Function[{optionLookup},
			If[!NullQ[standardPositionsCorresponded], optionLookup[[standardPositionsCorresponded]]]
		],
		Lookup[expandedResolvedOptions, {
			StandardGradientA,
			StandardGradientB,
			StandardGradientC,
			StandardGradientD,
			StandardGradientE,
			StandardGradientF,
			StandardGradientG,
			StandardGradientH,
			StandardFlowRate
		}]
	];

	(*now the blank samples*)
	{
		blankGradientA,
		blankGradientB,
		blankGradientC,
		blankGradientD,
		blankGradientE,
		blankGradientF,
		blankGradientG,
		blankGradientH,
		blankFlowRates
	} = Map[
		Function[{optionLookup},
			If[!NullQ[blankPositionsCorresponded], optionLookup[[blankPositionsCorresponded]]]
		],
		Lookup[expandedResolvedOptions,
			{
				BlankGradientA,
				BlankGradientB,
				BlankGradientC,
				BlankGradientD,
				BlankGradientE,
				BlankGradientF,
				BlankGradientG,
				BlankGradientH,
				BlankFlowRate
			}
		]
	];

	(*start with the column flush*)
	{
		columnFlushGradientA,
		columnFlushGradientB,
		columnFlushGradientC,
		columnFlushGradientD,
		columnFlushGradientE,
		columnFlushGradientF,
		columnFlushGradientG,
		columnFlushGradientH,
		columnFlushFlowRates,
		columnFlushFlowDirections
	} = Map[
		ConstantArray[#, Length[columnFlushPositions]]&,
		Lookup[expandedResolvedOptions, {
			ColumnFlushGradientA,
			ColumnFlushGradientB,
			ColumnFlushGradientC,
			ColumnFlushGradientD,
			ColumnFlushGradientE,
			ColumnFlushGradientF,
			ColumnFlushGradientG,
			ColumnFlushGradientH,
			ColumnFlushFlowRate,
			ColumnFlushFlowDirection
		}]
	];

	(*get the buffers*)
	(*convert to a model or Null (if a unlinked)*)
	{
		bufferA,
		bufferB,
		bufferC,
		bufferD,
		bufferE,
		bufferF,
		bufferG,
		bufferH
	} = Map[
		Function[{currentBuffer},
			Switch[currentBuffer,
				(*don't have to do anything if it's already a model or Null*)
				Null|ObjectP[Model[Sample]],currentBuffer,
				(*otherwise, if an object, fetch from the cache*)
				_,Download[fastAssocLookup[fastAssoc, currentBuffer, Model], Object]
			]
		],
		Lookup[expandedResolvedOptions, {BufferA, BufferB, BufferC, BufferD, BufferE, BufferF, BufferG, BufferH}]
	];

	(*only take the initial flow rates -- needed because flow rates can be changing*)
	{
		initialColumnPrimeFlowRates,
		initialColumnFlushFlowRates,
		initialSampleFlowRates,
		initialStandardFlowRates,
		initialBlankFlowRates
	}=Map[
		Function[{list},
			If[!NullQ[list],
				Map[
					Function[{insideFlowRate},
						If[MatchQ[insideFlowRate,{{GreaterEqualP[0*Minute],GreaterEqualP[0*Milliliter/Minute]}..}],
							insideFlowRate[[1,2]],
							insideFlowRate
						]
					],
					list
				]
			]
		],
		{columnPrimeFlowRates, columnFlushFlowRates, sampleFlowRates, standardFlowRates, blankFlowRates}
	];

	(* get the table flow rates times *)
	tableFlowRates = Values[
		SortBy[Flatten[MapThread[
			#1 -> #2&,
			{
				Flatten[{columnPrimePositions, columnFlushPositions, samplePositions, standardPositions, blankPositions}],
				DeleteCases[Flatten[{initialColumnPrimeFlowRates, initialColumnFlushFlowRates, initialSampleFlowRates, initialStandardFlowRates, initialBlankFlowRates}], Null]
			}
		]], First]
	];

	(* get the flow rates for the new gradients we're making *)
	flowRatesForNewGradients = PickList[tableFlowRates, tableGradients, Except[gradientMethodInPlaceP]];

	(* making tiny helper function to put Nulls everywhere besides the samples since FlushTime and EquilibrationTime are only for samples and not blanks/gradients/column prime/column flush*)
	makeNullLists[list_List]:=ConstantArray[Null, Length[list]];

	(* get the flush/equilibration times for the injection table *)
	(* note that for these two, I am _not_ deleting the Nulls because I don't need to here to ensure the correct index matching *)
	tableFlushTimes = Values[
		SortBy[Flatten[MapThread[
			#1 -> #2&,
			{
				Flatten[{columnPrimePositions, columnFlushPositions, samplePositions, standardPositions, blankPositions}],
				Flatten[{makeNullLists[columnPrimePositions], makeNullLists[columnFlushPositions], sampleFlushTimes, makeNullLists[standardPositions], makeNullLists[blankPositions]}]
			}
		]], First]
	];
	tableEquilibrationTimes = Values[
		SortBy[Flatten[MapThread[
			#1 -> #2&,
			{
				Flatten[{columnPrimePositions, columnFlushPositions, samplePositions, standardPositions, blankPositions}],
				Flatten[{makeNullLists[columnPrimePositions], makeNullLists[columnFlushPositions], sampleEquilibrationTime, makeNullLists[standardPositions], makeNullLists[blankPositions]}]
			}
		]], First]
	];

	(* get the flush/equilibration times for the new gradients we're making *)
	flushTimeForNewGradients = PickList[tableFlushTimes, tableGradients, Except[gradientMethodInPlaceP]];
	equilibrationTimesForNewGradients = PickList[tableEquilibrationTimes, tableGradients, Except[gradientMethodInPlaceP]];

	(*will map through and make a gradient for each based on the object ID*)
	uniqueGradientPackets = FlattenCachePackets@MapThread[
		Function[{gradientObjectID, flowRate, flushTime, equilibrationTime},
			Module[{injectionTablePosition, currentType, currentGradientTuple, currentGradientTupleLookup},

				(*find the injection Table position*)
				injectionTablePosition = First[FirstPosition[tableGradients, gradientObjectID]];

				(*figure out the type, based on which, look up the gradient tuple*)
				currentType = First[injectionTable[[injectionTablePosition]]];

				(*get the gradient based on the type and the position*)
				currentGradientTupleLookup = Switch[currentType,
					Sample, ToList[sampleGradient][[injectionTablePosition /. sampleReverseRules]],
					Standard, ToList[standardGradient][[injectionTablePosition /. standardReverseRules]],
					Blank, ToList[blankGradient][[injectionTablePosition /. blankReverseRules]],
					ColumnPrime, columnPrimeGradient,
					ColumnFlush, columnFlushGradient
				];

				(*expand it if need be*)
				currentGradientTuple=Switch[currentGradientTupleLookup,
					binaryGradientP,Transpose@Nest[Insert[#,Repeat[0 Percent,Length[currentGradientTupleLookup]], -2] &,Transpose@currentGradientTupleLookup, 6],
					gradientP,Transpose@Nest[Insert[#,Repeat[0 Percent,Length[currentGradientTupleLookup]], -2] &,Transpose@currentGradientTupleLookup, 4],
					_,currentGradientTupleLookup
				];

				(*make the gradient packet*)
				<|
					Object -> gradientObjectID,
					Type -> Object[Method, Gradient],
					BufferA -> Link[bufferA],
					BufferB -> Link[bufferB],
					BufferC -> Link[bufferC],
					BufferD -> Link[bufferD],
					BufferE -> Link[bufferE],
					BufferF -> Link[bufferF],
					BufferG -> Link[bufferG],
					BufferH -> Link[bufferH],
					Replace[Gradient] -> currentGradientTuple,
					GradientA -> currentGradientTuple[[All,{1,2}]],
					GradientB -> currentGradientTuple[[All,{1,3}]],
					GradientC -> currentGradientTuple[[All,{1,4}]],
					GradientD -> currentGradientTuple[[All,{1,5}]],
					GradientE -> currentGradientTuple[[All,{1,6}]],
					GradientF -> currentGradientTuple[[All,{1,7}]],
					GradientG -> currentGradientTuple[[All,{1,8}]],
					GradientH -> currentGradientTuple[[All,{1,9}]],
					FlowRate -> currentGradientTuple[[All,{1,-1}]],
					InitialFlowRate -> flowRate,
					FlushTime -> flushTime,
					EquilibrationTime -> equilibrationTime,
					(* the initial BufferB percentage *)
					GradientStart -> currentGradientTuple[[1, 3]],
					(* the end BufferB percentage *)
					GradientEnd -> currentGradientTuple[[-1, 3]],
					(* the time to get from the start to end percentage (i.e., the end time) *)
					GradientDuration -> currentGradientTuple[[-1, 1]],
					(* temperature is always 25 Celsius (i.e., ambient) *)
					Temperature -> $AmbientTemperature
				|>
			]
		],
		{
			gradientObjectsToMake,
			flowRatesForNewGradients,
			flushTimeForNewGradients,
			equilibrationTimesForNewGradients
		}
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
				peakSlopeEnd,
				peakMinimumDuration
			},
			Which[
				Not[TrueQ[collectFractions]], Null,
				MatchQ[fractionCollectionMethod, ObjectP[]],
					Association[
						Type -> Object[Method, FractionCollection],
						Object -> Download[fractionCollectionMethod, Object]
					],
				True,
					Association[
						Type -> Object[Method, FractionCollection],
						Object -> CreateID[Object[Method, FractionCollection]],
						FractionCollectionMode -> fractionCollectionMode,
						FractionCollectionStartTime -> fractionCollectionStartTime,
						FractionCollectionEndTime -> fractionCollectionEndTime,
						MaxFractionVolume -> maxFractionVolume,
						MaxCollectionPeriod -> maxCollectionPeriod,
						AbsoluteThreshold -> absoluteThreshold,
						PeakEndThreshold -> peakEndThreshold,
						PeakSlope -> peakSlope,
						PeakSlopeEnd -> peakSlopeEnd,
						PeakMinimumDuration -> peakMinimumDuration,
						FractionCollectionTemperature -> Lookup[expandedResolvedOptions, FractionCollectionTemperature] /. Ambient -> $AmbientTemperature
					]
			]
		],
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
				PeakSlopeEnd,
				PeakMinimumDuration
			}
		]
	];

	(*initialize our injectionTable with links*)
	injectionTableWithLinks = injectionTable;

	(*update all of the samples*)
	injectionTableWithLinks[[samplePositions, 2]] = linkedSampleResources;
	injectionTableWithLinks[[standardPositions, 2]] = linkedStandardResources;
	injectionTableWithLinks[[blankPositions, 2]] = linkedBlankResources;

	(*change all of the gradients to links*)
	injectionTableWithLinks[[All, 5]] = (Link[#]& /@ tableGradients);

	(*now let's add the extra columns to the injection table (dilution factor and column temperature*)

	(*first append Nulls to all of the rows to initialize*)
	injectionTableFull = Map[PadRight[#, 7, Null]&, injectionTableWithLinks];

	(* pull out the resolved AliquotAmount and AssayVolume options *)
	{resolvedAliquotAmount, resolvedAssayVolume} = Lookup[expandedResolvedOptions, {AliquotAmount, AssayVolume}];

	(* get the dilution factor if both the volumes are liquid *)
	dilutionFactor = MapThread[
		If[VolumeQ[#1] && VolumeQ[#2],
			#2 / #1,
			Null
		]&,
		{resolvedAliquotAmount, resolvedAssayVolume}
	];

	(*get the dilution factors and inform that first*)
	injectionTableFull[[samplePositions, 6]] = dilutionFactor;

	(* get the fraction collection method;  *)
	(*have to be careful here because it's already expanded by number of replicates, so should unexpand*)
	injectionTableFull[[samplePositions, 7]] = Link[#]& /@ Take[fractionPackets,Length[fractionPackets]/numReplicates];

	(*we'll need to use number of replicates to expand the effective injection table*)

	(*then get all of the sample tuples*)
	sampleTuples = injectionTableFull[[samplePositions]];

	(*make our insertion association (e.g. in the format of position to be inserted (P) and list to be inserted <|2 -> {{Sample,sample1,___}...}, *)
	insertionAssociation = MapThread[
		Function[{position, tuple},
			position -> Repeat[tuple, numReplicates - 1]
		],
		{samplePositions, sampleTuples}
	];

	(*fold through and insert these tuples into our injection table*)
	injectionTableInserted = If[numReplicates > 1,
		Fold[
			Insert[#1, Last[#2], First[#2]]&,
			injectionTableFull,
			insertionAssociation
		],
		injectionTableFull
	];

	(*flatten and reform our injection table*)
	injectionTableWithReplicates = Partition[Flatten[injectionTableInserted], 7];

	(*finally make our uploadable injection table*)
	injectionTableUploadable = MapThread[
		Function[{type, sample, injectionType, injectionVolume, gradient, dilutionFactor, fractionCollectionMethod},
			Association[
				Sample -> sample,
				Type -> type,
				Gradient -> Link[gradient],
				InjectionType -> injectionType,
				InjectionVolume -> injectionVolume,
				DilutionFactor -> dilutionFactor,
				ColumnTemperature -> $AmbientTemperature,
				FractionCollectionMethod -> Link[fractionCollectionMethod],
				Data -> Null
			]
		],
		Transpose[injectionTableWithReplicates]
	];

	(* figure out whether we're ever collecting fractions *)
	collectFractionsQ = MemberQ[Lookup[optionsWithReplicates, CollectFractions], True];

	(* Fetch existing method objects *)
	existingFractionCollectionMethods = Download[Cases[Lookup[expandedResolvedOptions, FractionCollectionMethod], ObjectP[]], Object];

	(* Extract new packets to upload *)
	newFractionPackets = DeleteCases[fractionPackets, Null | ObjectP[existingFractionCollectionMethods]];

	(* pull out all the fraction collection volumes *)
	fractionCollectionVolumes = Lookup[myResolvedOptions, MaxFractionVolume];
	fractionCollectionVolumesNoNull = DeleteCases[fractionCollectionVolumes, Null];

	(* get the fraction collection volumes that are in the less-than-4.5-mL, betewen-4.5mL-and-15mL, and between 15mL-and-50mL bins *)
	lowFractionVolumes = Cases[fractionCollectionVolumesNoNull, LessEqualP[4.5 Milliliter]];
	low96WellVolumes = Cases[fractionCollectionVolumesNoNull, LessEqualP[1.8 Milliliter]];
	low48WellVolumes = Cases[fractionCollectionVolumesNoNull, RangeP[1.8 Milliliter, 4.5 Milliliter, Inclusive -> Right]];
	medFractionVolumes = Cases[fractionCollectionVolumesNoNull, RangeP[4.5 Milliliter, 15 Milliliter, Inclusive -> Right]];
	highFractionVolumes = Cases[fractionCollectionVolumesNoNull, RangeP[15 Milliliter, 50 Milliliter, Inclusive -> Right]];
	veryHighFractionVolumes = Cases[fractionCollectionVolumesNoNull, GreaterP[50 Milliliter]];

	(* get the fraction container racks we want; this depends on the instrument and how many of each fraction container rack we have *)
	fractionContainerRacks = Which[
		Not[collectFractionsQ] || Not[avant25Q || avant150Q], {},
		MatchQ[{lowFractionVolumes, medFractionVolumes, highFractionVolumes, veryHighFractionVolumes}, {{VolumeP..}, {}, {}, {}}], Flatten[{Model[Container, Rack, "Avant Fraction Collector Cassette Rack"], ConstantArray[Model[Container, Rack, "Avant Fraction Collector Deep Well Plate Rack"], 6]}],
		MatchQ[{lowFractionVolumes, medFractionVolumes, highFractionVolumes, veryHighFractionVolumes}, {{}, {VolumeP..}, {}, {}}], Flatten[{Model[Container, Rack, "Avant Fraction Collector Cassette Rack"], ConstantArray[Model[Container, Rack, "Avant Fraction Collector 15 mL Tube Rack"], 6]}],
		MatchQ[{lowFractionVolumes, medFractionVolumes, highFractionVolumes, veryHighFractionVolumes}, {{}, {}, {VolumeP..}, {}}], Flatten[{Model[Container, Rack, "Avant Fraction Collector Cassette Rack"], ConstantArray[Model[Container, Rack, "Avant Fraction Collector 50 mL Tube Rack"], 6]}],
		MatchQ[{lowFractionVolumes, medFractionVolumes, highFractionVolumes, veryHighFractionVolumes}, {_, _, _, {VolumeP..}}], {Model[Container, Rack, "Avant Fraction Collector 250 mL Bottle Rack"]},
		MatchQ[{lowFractionVolumes, medFractionVolumes, highFractionVolumes}, {{VolumeP..}, {}, {VolumeP..}}], Join[{Model[Container, Rack, "Avant Fraction Collector Cassette Rack"]}, ConstantArray[Model[Container, Rack, "Avant Fraction Collector Deep Well Plate Rack"], 3], ConstantArray[Model[Container, Rack, "Avant Fraction Collector 50 mL Tube Rack"], 3]],
		MatchQ[{lowFractionVolumes, medFractionVolumes, highFractionVolumes}, {{}, {VolumeP..}, {VolumeP..}}], Join[{Model[Container, Rack, "Avant Fraction Collector Cassette Rack"]}, ConstantArray[Model[Container, Rack, "Avant Fraction Collector 15 mL Tube Rack"], 3], ConstantArray[Model[Container, Rack, "Avant Fraction Collector 50 mL Tube Rack"], 3]],
		MatchQ[{lowFractionVolumes, medFractionVolumes, highFractionVolumes}, {{VolumeP..}, {VolumeP..}, {}}], Join[{Model[Container, Rack, "Avant Fraction Collector Cassette Rack"]}, ConstantArray[Model[Container, Rack, "Avant Fraction Collector Deep Well Plate Rack"], 3], ConstantArray[Model[Container, Rack, "Avant Fraction Collector 15 mL Tube Rack"], 3]],
		MatchQ[{lowFractionVolumes, medFractionVolumes, highFractionVolumes}, {{VolumeP..}, {VolumeP..}, {VolumeP..}}], Join[{Model[Container, Rack, "Avant Fraction Collector Cassette Rack"]}, ConstantArray[Model[Container, Rack, "Avant Fraction Collector Deep Well Plate Rack"], 2], ConstantArray[Model[Container, Rack, "Avant Fraction Collector 15 mL Tube Rack"], 2], ConstantArray[Model[Container, Rack, "Avant Fraction Collector 50 mL Tube Rack"], 2]],
		True, {}
	];

	(* get the fraction containers we want; the old akta this just always 4 deep well plates as long as we're collecting fractions *)
	(* for the avants, 1 plate per rack/15 15mL tubes per rack/6 50mL tubes per rack *)
	fractionContainers = If[collectFractionsQ && Not[avant25Q || avant150Q],
		ConstantArray[Model[Container, Plate, "96-well 2mL Deep Well Plate"], 4],
		Flatten[MapIndexed[
			Switch[#1,
				Model[Container, Rack, "Avant Fraction Collector Deep Well Plate Rack"],
					(*we do some logic to figure if we need 48 well and 96 well plates. we toggle by the even/oddness*)
					Which[
						MatchQ[{low96WellVolumes, low48WellVolumes}, {{VolumeP..}, {VolumeP..}}] && EvenQ[First@#2], Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						MatchQ[{low96WellVolumes, low48WellVolumes}, {{VolumeP..}, {VolumeP..}}] && OddQ[First@#2], Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"],
						MatchQ[{low96WellVolumes, low48WellVolumes}, {{VolumeP..}, {}}], Model[Container, Plate, "96-well 2mL Deep Well Plate"],
						MatchQ[{low96WellVolumes, low48WellVolumes}, {{}, {VolumeP..}}], Model[Container, Plate, "48-well Pyramid Bottom Deep Well Plate"]
					],
				Model[Container, Rack, "Avant Fraction Collector 15 mL Tube Rack"], ConstantArray[Model[Container, Vessel, "15mL Tube"], 15],
				Model[Container, Rack, "Avant Fraction Collector 50 mL Tube Rack"], ConstantArray[Model[Container, Vessel, "50mL Tube"], 6],
				Model[Container, Rack, "Avant Fraction Collector 250 mL Bottle Rack"], ConstantArray[Model[Container, Vessel, "250mL Square Wide-Mouth HDPE Bottle with Closure"], 18],
				Model[Container, Rack, "Avant Fraction Collector Cassette Rack"], Nothing
			]&,
			fractionContainerRacks
		]]
	];

	(* make resources for the fraction containers *)
	fractionContainerResources = Link[Resource[Sample -> #, Name -> ToString[Unique[]]]]& /@ fractionContainers;

	(* make resources for the fraction container racks; this is only relevant for the avants *)
	fractionContainerRackResources = Link[Resource[Sample -> #, Name -> ToString[Unique[]]]]& /@ fractionContainerRacks;

	(*get all of the gradients used*)
	allGradients = Download[injectionTableWithReplicates[[All, 5]], Object];

	(*look everything up in the cache and extract out the gradient tuple*)
	allGradientTuples = Map[
		Function[{gradientObject},
			Lookup[
				fetchPacketFromFastAssoc[gradientObject, Join[fastAssoc, AssociationThread[Lookup[uniqueGradientPackets, Object, {}], uniqueGradientPackets]]],
				Gradient,
				(*otherwise check if there is a replace*)
				Lookup[fetchPacketFromFastAssoc[gradientObject, Join[fastAssoc, AssociationThread[Lookup[uniqueGradientPackets, Object, {}], uniqueGradientPackets]]], Replace[Gradient]]
			]
		],
		allGradients
	];

	(* get the total amounts of time for each entry of the injection table *)
	(* each injection also has ~20 minutes on top of whatever it is TODO arbitrary *)
	allTimes = Map[
		#[[-1, 1]] + 20 Minute&,
		allGradientTuples
	];

	(*use this to calculate the total run time*)
	totalRunTime = Total[allTimes] + 120 Minute;

	(* get the amounts of BufferA/BufferB we need for each entry of the injection table *)
	{
		bufferATableAmount,
		bufferBTableAmount,
		bufferCTableAmount,
		bufferDTableAmount,
		bufferETableAmount,
		bufferFTableAmount,
		bufferGTableAmount,
		bufferHTableAmount
	} = Table[
		Total@Map[
			Function[{currentGradientTuple},
				calculateBufferUsage[
					currentGradientTuple[[All, {1, x}]], (* the Buffer index *)
					Max[currentGradientTuple[[All, 1]]], (*last time point*)
					currentGradientTuple[[All, {1, -1}]],
					Last[currentGradientTuple[[All, x]]] (*last percentage of the current Buffer *)
				]
			],
			allGradientTuples
		],
		{x,2,9}
	];

	(*if we have the system washing on, we also need to calculate the amount needed for that*)
	{
		bufferAWashAmount,
		bufferBWashAmount,
		bufferCWashAmount,
		bufferDWashAmount,
		bufferEWashAmount,
		bufferFWashAmount,
		bufferGWashAmount,
		bufferHWashAmount
	}=If[MatchQ[Lookup[expandedResolvedOptions, FullGradientChangePumpDisconnectAndPurge],True],
		(*first map across the gradients*)
		Total@Map[
			Function[{currentGradientTuples},
				(*now map across the tuples*)
				Total@MapIndexed[
					Function[{gradientTuple, indexInside},
						If[
							Or[
								(*check if it's the first*)
								MatchQ[indexInside,{1}],
								(*check to see if we have switch*)
								!MatchQ[
									Map[MatchQ[#, GreaterP[0 Percent]] &, gradientTuple[[2 ;; 9]]],
									Map[MatchQ[#, GreaterP[0 Percent]] &, currentGradientTuples[[First[indexInside], 2 ;; 9]]]
								]
							],
							gradientTuple[[2 ;; 9]]*Lookup[expandedResolvedOptions, PumpDisconnectOnFullGradientChangePurgeVolume]/(100 Percent),
							ConstantArray[0*Milliliter,8]
						]
					],
					currentGradientTuples[[2;;]]
				]
			],
			allGradientTuples
		],
		ConstantArray[0*Milliliter,8]
	];

	(* make our buffer resources *)
	bufferAResource = Link@Resource[
		Sample -> Lookup[expandedResolvedOptions,BufferA],
		(* somewhat arbitrary here but can figure this out more clearly in the future *)
		Amount -> Min[bufferATableAmount + bufferAWashAmount + bufferDeadVolume,20 Liter],
		(* for now, saying we have to use 4L bottles or more because those definitely have the caps *)
		Container -> If[bufferATableAmount + bufferAWashAmount + bufferDeadVolume > 4 Liter,
			PreferredContainer[Min[bufferATableAmount + bufferAWashAmount + bufferDeadVolume,20 Liter]],
			Model[Container, Vessel, "Amber Glass Bottle 4 L"]
		],
		RentContainer -> True,
		Name -> CreateUUID[]
	];
	bufferBResource = Link@Resource[
		Sample -> Lookup[expandedResolvedOptions,BufferB],
		(* somewhat arbitrary here but can figure this out more clearly in the future *)
		Amount -> Min[bufferBTableAmount + bufferBWashAmount +  bufferDeadVolume,20 Liter],
		Container -> If[bufferBTableAmount + bufferBWashAmount + bufferDeadVolume > 4 Liter,
			PreferredContainer[Min[bufferBTableAmount + bufferBWashAmount  + bufferDeadVolume,20 Liter]],
			Model[Container, Vessel, "Amber Glass Bottle 4 L"]
		],
		RentContainer -> True,
		Name -> CreateUUID[]
	];

	(*make the other resources, if need be*)
	{
		bufferCResource,
		bufferDResource,
		bufferEResource,
		bufferFResource,
		bufferGResource,
		bufferHResource
	}=MapThread[
		Function[{currentBuffer,currentAmount,washAmount},
			If[!NullQ[currentBuffer],
				Link@Resource[
					Sample -> currentBuffer,
					(* somewhat arbitrary here but can figure this out more clearly in the future *)
					Amount -> Min[currentAmount + bufferDeadVolume + washAmount,20 Liter],
					Container -> If[currentAmount + bufferDeadVolume + washAmount > 4 Liter,
						PreferredContainer[Min[currentAmount + bufferDeadVolume + washAmount,20 Liter]],
						Model[Container, Vessel, "Amber Glass Bottle 4 L"]
					],
					RentContainer -> True,
					Name -> CreateUUID[]
				]
			]
		],
		{
			Lookup[expandedResolvedOptions, {BufferC, BufferD, BufferE, BufferF, BufferG, BufferH}],
			{
				bufferCTableAmount,
				bufferDTableAmount,
				bufferETableAmount,
				bufferFTableAmount,
				bufferGTableAmount,
				bufferHTableAmount
			},
			{
				bufferCWashAmount,
				bufferDWashAmount,
				bufferEWashAmount,
				bufferFWashAmount,
				bufferGWashAmount,
				bufferHWashAmount
			}
		}
	];

	(* combine all the resources for BufferA and BufferB that will be combined together *)
	bufferASelectionResources = DeleteCases[{
			bufferAResource,
			bufferCResource,
			bufferEResource,
			bufferGResource
		},Null];

	bufferBSelectionResources = DeleteCases[{
		bufferBResource,
		bufferDResource,
		bufferFResource,
		bufferHResource
	},Null];


	(* Create placement field value for BufferA and BufferB *)
	(* complicated because it depends on how many buffers we have, and that we're building out; the most easily accessible BufferA slots are 4, then 3, then 2, then 1, and BufferB 5, then 6, then 7, then 8 *)
	bufferPlacements = If[avant150Q || avant25Q,
		Join[
			MapIndexed[
				If[!NullQ[#1], {#1, {"Buffer A" <> ToString[First[#2]] <> " Slot"}}, Nothing]&,
				{
					bufferAResource,
					bufferCResource,
					bufferEResource,
					bufferGResource
				}
			],
			MapIndexed[
				If[!NullQ[#1], {#1, {"Buffer B" <> ToString[First[#2]] <> " Slot"}}, Nothing]&,
				{
					bufferBResource,
					bufferDResource,
					bufferFResource,
					bufferHResource
				}
			]
		],
		MapThread[
			If[!NullQ[#1],{#1,{#2}},Nothing]&,
			{
				{bufferAResource,bufferBResource,bufferCResource,bufferDResource},
				{"Buffer A Slot","Buffer B Slot","Buffer C Slot","Buffer D Slot"}
			}
		]
	];

	(* for the avant auto sampler, we need to add a needle wash buffer solution to the auto sampler. *)
	autosamplerInjectionWashBufferResource=If[(avant150Q || avant25Q)&&MemberQ[allInjectionTypes,Autosampler],
		Link@Resource[
			Sample -> Model[Sample, "Milli-Q water"],
			Amount -> 230 Milliliter,
			Container -> Model[Container, Vessel, "250mL Square Wide-Mouth HDPE Bottle with Closure"],
			Name -> CreateUUID[]
		],
		Null
	];



	(*if we're doing direct flow injection or using the superloop, we also need to resource pick the sample caps and cleaning buffers*)
	(*this can be tricky because the samples can be aliquot/consolidated, so we use the simulation framework to help out*)
	{sampleCaps, sampleCapContainerModel, sampleCapContainerMaxVolume, sampleCapLabels} = If[MatchQ[DeleteCases[allInjectionTypes, Null], {Autosampler..}],
		(*if using the autosampler, then just return Nulls*)
		{Null, Null, Null, Null},
		(
			(* get the position of all the samples in the injection table *)
			sampleCapPositions = Position[injectionTable, {Sample, _, FlowInjection, ___}, {1}];
			blankCapPositions = Position[injectionTable, {Blank, _, FlowInjection, ___}, {1}];
			standardCapPositions = Position[injectionTable, {Standard, _, FlowInjection, ___}, {1}];

			(*get the containers*)
			simulatedContainers = Map[fastAssocLookup[fastAssoc, #, {Container, Object}]&, simulatedSamples];

			(* replace the containers that are for the autosampler/superloop with Null here *)
			simulatedContainersWithNulls = MapThread[
				If[MatchQ[#2, FlowInjection],
					#1,
					Null
				]&,
				{simulatedContainers, Lookup[myResolvedOptions, InjectionType]}
			];

			(*for each unique container, we need to get the model and feasible cap*)
			eachContainerModelPacket = Map[
				If[NullQ[#],
					Null,
					fetchPacketFromFastAssoc[fastAssocLookup[fastAssoc, #, {Model, Object}], fastAssoc]
				]&,
				simulatedContainersWithNulls
			];

			(*get the unique containers*)
			uniqueSimulatedContainers = DeleteDuplicates@DeleteCases[eachContainerModelPacket, Null];

			(*pull out the needed information*)
			containerModelVesselsOnly = Lookup[Cases[uniqueSimulatedContainers, ObjectP[Model[Container, Vessel]]], Object, {}];

			(* use the findAspirationCaps helper to... find aspiration caps *)
			sampleCapsInner = Experiment`Private`findAspirationCap[containerModelVesselsOnly, LevelSensorType -> HexCap];

			vesselToCapsRules = AssociationThread[containerModelVesselsOnly, sampleCapsInner];

			(* get the caps for if we're doing any blanks by flow injection *)
			(* also get the names of the resources we'll be making *)
			{blankContainersForCaps, blankNames} = If[MatchQ[blankContainers, {}],
				{{}, {}},
				Transpose[MapThread[
					If[MatchQ[#1, FlowInjection] && MatchQ[#2, ObjectP[Model[Container, Vessel]]],
						{#2, "blank " <> #3[Name]},
						{Null, Null}
					]&,
					{Cases[injectionTable, {Blank, _, injectionType_, _, _} :> injectionType], blankContainers, Values[flatBlankResources]}
				]]
			];
			blankCapsInner = Experiment`Private`findAspirationCap[DeleteCases[blankContainersForCaps, Null], LevelSensorType -> HexCap];
			(* need the Download[_, Object] here because sometimes at this point we have the Named form and we want the ID form in order for allVesselToCapRules to work *)
			blankVesselToCapsRules = AssociationThread[Download[DeleteCases[blankContainersForCaps, Null], Object], blankCapsInner];

			(* get the caps for if we're doing any standards by flow injection *)
			(* also get the names of the resources we'll be making *)
			{standardContainersForCaps, standardNames} = If[MatchQ[standardContainers, {}],
				{{}, {}},
				Transpose[MapThread[
					If[MatchQ[#1, FlowInjection] && MatchQ[#2, ObjectP[Model[Container, Vessel]]],
						{#2, "standard " <> #3[Name]},
						{Null, Null}
					]&,
					{Cases[injectionTable, {Standard, _, injectionType_, _, _} :> injectionType], standardContainers, Values[flatStandardResources]}
				]]
			];
			standardCapsInner = Experiment`Private`findAspirationCap[DeleteCases[standardContainersForCaps, Null], LevelSensorType -> HexCap];
			(* need the Download[_, Object] here because sometimes at this point we have the Named form and we want the ID form in order for allVesselToCapRules to work *)
			standardVesselToCapsRules = AssociationThread[Download[DeleteCases[standardContainersForCaps, Null], Object], standardCapsInner];

			(* get a list of nulls the length of the injection table *)
			injectionTableNulls = ConstantArray[Null, Length[injectionTable]];

			(* make ReplacePart rules to make sure we have the proper positioning of everything *)
			containerModelReplacePartRules = Join[
				AssociationThread[sampleCapPositions, DeleteCases[eachContainerModelPacket, Null]],
				AssociationThread[blankCapPositions, DeleteCases[blankContainersForCaps, Null]],
				AssociationThread[standardCapPositions, DeleteCases[standardContainersForCaps, Null]]
			];
			containerModelPacketsWithNulls = ReplacePart[injectionTableNulls, containerModelReplacePartRules];

			(* combine the vessel to cap rules for the containers, blanks, and standards *)
			allVesselToCapRules = Join[
				vesselToCapsRules,
				blankVesselToCapsRules,
				standardVesselToCapsRules,
				<|Null | ObjectP[] -> Null|>
			];

			(* get the sample, blank, and standard names; these will go into the Resources for the caps *)
			sampleNames = ToString[#]& /@ PickList[simulatedSamples, simulatedContainersWithNulls, Except[Null]];

			(* do the same ReplacePart trick as above *)
			nameReplacePartRules = Join[
				AssociationThread[sampleCapPositions, sampleNames],
				AssociationThread[blankCapPositions, DeleteCases[blankNames, Null]],
				AssociationThread[standardCapPositions, DeleteCases[standardNames, Null]]
			];

			(*return everything*)
			{
				Download[containerModelPacketsWithNulls, Object] /. allVesselToCapRules,
				Download[containerModelPacketsWithNulls, Object],
				If[NullQ[#], Null, fastAssocLookup[fastAssoc, #, MaxVolume]]& /@ containerModelPacketsWithNulls,
				ReplacePart[injectionTableNulls, nameReplacePartRules]
			}
		)
	] /. If[$FPLCThreadedCapPreference, {Model[Item, Cap, "id:N80DNj1Ve4lN"] -> Model[Item, Cap, "id:n0k9mG865RWk"]}, {}];


	(*if we're doing direct sample introduction into the fplc, when we also need to resource pick caps for the sample containers*)
	uniqueContainers=DeleteDuplicates[sampleContainers];

	(* If using flow injection, determine the purge method file names *)
	flowInjectionPurgeMethodNames=If[MemberQ[allInjectionTypes, FlowInjection],
		Table["PurgeS" <> ToString[i], {i, Length[DeleteDuplicates[DeleteCases[sampleCapLabels, Null]]]}],
		{}
	];

	(* If using flow injection, create some containers for emptying the purge syringe *)
	flowInjectionPurgeContainers=If[MemberQ[allInjectionTypes, FlowInjection],
		Table[
			Resource[
				Sample -> Model[Container, Vessel, "50mL Tube"],
				Name -> CreateUUID[]
			],
			{i, Length[DeleteDuplicates[DeleteCases[sampleCapLabels, Null]]]}
		],
		{}
	];

	(*if we're using the superloop, then we need a resource for such*)
	(*currently, we have only one type of superloop; so if that changes, this will need to too*)
	sampleLoopResource=If[MemberQ[allInjectionTypes, Superloop],
		Link@Resource[Sample->Model[Plumbing, SampleLoop, "Avant 10mL Superloop"],Rent->True]
	];

	(*if we're swapping flow cells we need to make a resource for it*)
	flowCellResource=Switch[Lookup[myResolvedOptions,FlowCell],
		0.5 Millimeter, Link@Resource[Sample->Model[Part, FlowCell, "UV flow cell US-0.5"],Rent->True],
		10 Millimeter, Link@Resource[Sample->Model[Part, FlowCell, "UV flow cell US-10"],Rent->True],
		_,Null
	];

	(*get the available mixers for this instrument*)
	availableMixers=Cases[Lookup[resolvedInstrumentModelPacket,AssociatedAccessories][[All,1]][Object],ObjectP[Model[Part,Mixer]]];

	(*get the volumes associated*)
	availableMixerVolumes=Map[
		Lookup[fetchPacketFromFastAssoc[#,fastAssoc],Volume]&,
		availableMixers
	];

	(*if we're swapping mixers*)
	mixerResource=Which[
		(*if we're not using a mixer, then just take a column join*)
		Lookup[myResolvedOptions,MixerVolume]==0 Milliliter, Link@Resource[Sample->Model[Plumbing, ColumnJoin, "Union 1/16\" female - 1/16\" female"],Rent->True],
		(*if it's just the default, then we leave this Null and we'll inform in compiler. We don't not want to create resource*)
		Lookup[fetchPacketFromFastAssoc[Lookup[resolvedInstrumentModelPacket,DefaultMixer],fastAssoc],Volume]==Lookup[myResolvedOptions,MixerVolume],Null,
		(*otherwise, find the appropriate mixer*)
		True,Link@Resource[
			Sample->First@Nearest[MapThread[Rule,{availableMixerVolumes,availableMixers}],Lookup[myResolvedOptions,MixerVolume]],
			Rent->True
		]
	];

	(* make resources for all the flow injection caps *)
	sampleCapResources = If[NullQ[sampleCaps],
		ConstantArray[Null, Length[injectionTable]],
		MapThread[
			Function[{bufferCap, name},
				If[NullQ[bufferCap],
					Null,
					Link@Resource[Sample -> bufferCap, Rent -> True, Name -> name]
				]
			],
			{sampleCaps, sampleCapLabels}
		]
	];

	(* Determine volume of BufferA and BufferB required for system prime run *)
	(* BufferC-BufferH for system prime and system flush will repeat A and B, for the buffer lines that we are going to use *)
	systemPrimeBufferAVolume = calculateBufferUsage[
		instrumentSystemPrimeGradient[[All, {1, 2}]], (*the specific gradient*)
		Max[instrumentSystemPrimeGradient[[All, 1]]], (*the last time*)
		instrumentSystemPrimeGradient[[All, {1, -1}]], (*the flow rate profile*)
		Last[instrumentSystemPrimeGradient[[All, 2]]] (*the last percentage*)
	];

	(* Determine volume of BufferB required for system prime run *)
	systemPrimeBufferBVolume = calculateBufferUsage[
		instrumentSystemPrimeGradient[[All, {1, 3}]], (*the specific gradient*)
		Max[instrumentSystemPrimeGradient[[All, 1]]], (*the last time*)
		instrumentSystemPrimeGradient[[All, {1, -1}]], (*the flow rate profile*)
		Last[instrumentSystemPrimeGradient[[All, 3]]] (*the last percentage*)
	];

	(* Create resource for SystemPrime's BufferA *)
	systemPrimeBufferAModel = Download[Lookup[instrumentSystemPrimeGradientPacket, BufferA, Null],Object];
	systemPrimeBufferAResource = If[avant150Q || avant25Q,
		Link@Resource[
			Sample -> systemPrimeBufferAModel,
			Amount -> systemPrimeBufferAVolume + bufferDeadVolume,
			Container -> If[systemPrimeBufferAVolume + bufferDeadVolume > 4 Liter,
				PreferredContainer[systemPrimeBufferAVolume + bufferDeadVolume],
				Model[Container, Vessel, "Amber Glass Bottle 4 L"]
			],
			RentContainer -> True,
			Name -> CreateUUID[]
		],
		Null
	];

	(* Create resource for SystemPrime's BufferB *)
	systemPrimeBufferBModel = Download[Lookup[instrumentSystemPrimeGradientPacket, BufferB, Null],Object];
	systemPrimeBufferBResource = If[avant150Q || avant25Q,
		Link@Resource[
			Sample -> systemPrimeBufferBModel,
			Amount -> systemPrimeBufferBVolume + bufferDeadVolume,
			Container -> If[systemPrimeBufferBVolume + bufferDeadVolume > 4 Liter,
				PreferredContainer[systemPrimeBufferBVolume + bufferDeadVolume],
				Model[Container, Vessel, "Amber Glass Bottle 4 L"]
			],
			RentContainer -> True,
			Name -> CreateUUID[]
		],
		Null
	];
	
	{systemPrimeBufferCResource, systemPrimeBufferDResource, systemPrimeBufferEResource, systemPrimeBufferFResource, systemPrimeBufferGResource, systemPrimeBufferHResource}=If[avant150Q || avant25Q,
		MapThread[
			Function[{currentBufferQ,currentBuffer,currentAmount},
				If[NullQ[currentBufferQ],
					Null,
					Link@Resource[
						Sample -> currentBuffer,
						Amount -> currentAmount + bufferDeadVolume,
						Container -> If[currentAmount + bufferDeadVolume > 4 Liter,
							PreferredContainer[currentAmount + bufferDeadVolume],
							Model[Container, Vessel, "Amber Glass Bottle 4 L"]
						],
						RentContainer -> True,
						Name -> CreateUUID[]
					]
				]
			],
			{
				(* Decide if we need to prime this buffer line from if we use this buffer in the sample run *)
				Download[Lookup[expandedResolvedOptions, {BufferC, BufferD, BufferE, BufferF, BufferG, BufferH}],Object],
				(* Repeat the system prime buffer and gradient from A and B *)
				Flatten[Table[{Lookup[instrumentSystemPrimeGradientPacket, BufferA],Lookup[instrumentSystemPrimeGradientPacket, BufferB]},3]],
				Flatten[Table[{systemPrimeBufferAVolume,systemPrimeBufferBVolume},3]]
			}
		],
		Table[Null,6]
	];

	allSystemPrimeBufferResources={
		(* B/D/F/H - B Buffers B1-B4 *)
		systemPrimeBufferAResource,systemPrimeBufferCResource, systemPrimeBufferEResource, systemPrimeBufferGResource,
		(* B/D/F/H - B Buffers B1-B4 *)
		systemPrimeBufferBResource, systemPrimeBufferDResource, systemPrimeBufferFResource, systemPrimeBufferHResource
	};
	(* Repeat the A/B Gradient for all other buffers *)
	(* SystemPrime and SystemFlush of FPLC always run 100% BufferA first and then 100% BufferB. We will determine the time for each buffer, and then do all A buffers (A/C/E/G) first and then all B buffers (B/D/F/H) *)
	(* Figure out how long we run each buffer for *)
	systemPrimeBufferTime=instrumentSystemPrimeGradient[[2,1]]-instrumentSystemPrimeGradient[[1,1]];
	(* Figure out our flow rate *)
	systemPrimeBufferFlowRate=Lookup[instrumentSystemPrimeGradientPacket, InitialFlowRate, Null];
	(* Put together the tuples *)
	systemPrimeGradientTuples=Join@@MapIndexed[
		Function[
			{buffer,index},
			If[NullQ[buffer],
				Nothing,
				Module[
					{previousBufferCount,startTime,endTime,bufferPos,percentTuple},
					previousBufferCount=Count[
						allSystemPrimeBufferResources[[1;;(index[[1]]-1)]],
						Except[Null]
					];
					startTime=If[MatchQ[index[[1]],1],
						(* First time starts at 0.00 Minute *)
						systemPrimeBufferTime*previousBufferCount,
						(* First time starts at last time + 0.1 Minute *)
						systemPrimeBufferTime*previousBufferCount + 0.1Minute
					];
					endTime=systemPrimeBufferTime*(previousBufferCount+1);
					(* Since we do all As first and then all Bs, get the correct index of the buffer in the gradient *)
					bufferPos=Flatten[Transpose[Partition[Range[8],2]]][[index[[1]]]];
					percentTuple=ReplacePart[Table[0Percent,8],bufferPos->100Percent];
					{
						Join[{startTime},percentTuple, {systemPrimeBufferFlowRate}],
						Join[{endTime},percentTuple, {systemPrimeBufferFlowRate}]
					}
				]
			]
		],
		allSystemPrimeBufferResources
	];

	(* Determine volume of BufferA required for system flush run *)
	systemFlushBufferAVolume = calculateBufferUsage[
		instrumentSystemFlushGradient[[All, {1, 2}]], (*the specific gradient*)
		Max[instrumentSystemFlushGradient[[All, 1]]], (*the last time*)
		instrumentSystemFlushGradient[[All, {1, -1}]], (*the flow rate profile*)
		Last[instrumentSystemFlushGradient[[All, 2]]] (*the last percentage*)
	];

	(* Determine volume of BufferB required for system flush run *)
	systemFlushBufferBVolume = calculateBufferUsage[
		instrumentSystemFlushGradient[[All, {1, 3}]], (*the specific gradient*)
		Max[instrumentSystemFlushGradient[[All, 1]]], (*the last time*)
		instrumentSystemFlushGradient[[All, {1, -1}]], (*the flow rate profile*)
		Last[instrumentSystemFlushGradient[[All, 3]]] (*the last percentage*)
	];

	(* Create resource for SystemFlush's BufferA *)
	systemFlushBufferAModel = Download[Lookup[instrumentSystemFlushGradientPacket, BufferA, Null],Object];
	systemFlushBufferAResource = If[avant150Q || avant25Q,
		Link@Resource[
			Sample -> systemFlushBufferAModel,
			Amount -> systemFlushBufferAVolume + bufferDeadVolume,
			Container -> If[systemFlushBufferAVolume + bufferDeadVolume > 4 Liter,
				PreferredContainer[systemFlushBufferAVolume + bufferDeadVolume],
				Model[Container, Vessel, "Amber Glass Bottle 4 L"]
			],
			RentContainer -> True,
			Name -> CreateUUID[]
		]
	];

	(* Create resource for SystemFlush's BufferB *)
	systemFlushBufferBModel = Download[Lookup[instrumentSystemFlushGradientPacket, BufferB, Null],Object];
	systemFlushBufferBResource = If[avant150Q || avant25Q,
		Link@Resource[
			Sample -> systemFlushBufferBModel,
			Amount -> systemFlushBufferBVolume + bufferDeadVolume,
			Container -> If[systemFlushBufferBVolume + bufferDeadVolume > 4 Liter,
				PreferredContainer[systemFlushBufferBVolume + bufferDeadVolume],
				Model[Container, Vessel, "Amber Glass Bottle 4 L"]
			],
			RentContainer -> True,
			Name -> CreateUUID[]
		]
	];

	{systemFlushBufferCResource, systemFlushBufferDResource, systemFlushBufferEResource, systemFlushBufferFResource, systemFlushBufferGResource, systemFlushBufferHResource}=If[avant150Q || avant25Q,
		MapThread[
			Function[{currentBufferQ,currentBuffer,currentAmount},
				If[NullQ[currentBufferQ],
					Null,
					Link@Resource[
						Sample -> currentBuffer,
						Amount -> currentAmount + bufferDeadVolume,
						Container -> If[currentAmount + bufferDeadVolume > 4 Liter,
							PreferredContainer[currentAmount + bufferDeadVolume],
							Model[Container, Vessel, "Amber Glass Bottle 4 L"]
						],
						RentContainer -> True,
						Name -> CreateUUID[]
					]
				]
			],
			{
				(* Decide if we need to prime this buffer line from if we use this buffer in the sample run *)
				Download[Lookup[expandedResolvedOptions, {BufferC, BufferD, BufferE, BufferF, BufferG, BufferH}],Object],
				(* Repeat the system prime buffer A and B *)
				Flatten[Table[{Lookup[instrumentSystemFlushGradientPacket, BufferA],Lookup[instrumentSystemFlushGradientPacket, BufferB]},3]],
				Flatten[Table[{systemFlushBufferAVolume,systemFlushBufferBVolume},3]]
			}
		],
		Table[Null,6]
	];

	allSystemFlushBufferResources={
		(* B/D/F/H - B Buffers B1-B4 *)
		systemFlushBufferAResource,systemFlushBufferCResource, systemFlushBufferEResource, systemFlushBufferGResource,
		(* B/D/F/H - B Buffers B1-B4 *)
		systemFlushBufferBResource, systemFlushBufferDResource, systemFlushBufferFResource, systemFlushBufferHResource
	};
	(* Repeat the A/B Gradient for all other buffers *)
	(* SystemFlush and SystemFlush of FPLC always run 100% BufferA first and then 100% BufferB. We will determine the time for each buffer, and then do all As (A/C/E/G) first and then all Bs (B/D/F/H) *)
	(* Figure out how long we run each buffer for *)
	systemFlushBufferTime=instrumentSystemFlushGradient[[2,1]]-instrumentSystemFlushGradient[[1,1]];
	(* Figure out our flow rate *)
	systemFlushBufferFlowRate=Lookup[instrumentSystemFlushGradientPacket, InitialFlowRate];
	(* Put together the tuples *)
	systemFlushGradientTuples=Join@@MapIndexed[
		Function[
			{buffer,index},
			If[NullQ[buffer],
				Nothing,
				Module[
					{previousBufferCount,startTime,endTime,bufferPos,percentTuple},
					previousBufferCount=Count[
						allSystemFlushBufferResources[[1;;(index[[1]]-1)]],
						Except[Null]
					];
					startTime=If[MatchQ[index[[1]],1],
						(* First time starts at 0.00 Minute *)
						systemFlushBufferTime*previousBufferCount,
						(* First time starts at last time + 0.1 Minute *)
						systemFlushBufferTime*previousBufferCount + 0.1Minute
					];
					endTime=systemFlushBufferTime*(previousBufferCount+1);
					(* Since we do all As first and then all Bs, get the correct index of the buffer in the gradient *)
					bufferPos=Flatten[Transpose[Partition[Range[8],2]]][[index[[1]]]];
					percentTuple=ReplacePart[Table[0Percent,8],bufferPos->100Percent];
					{
						Join[{startTime},percentTuple, {systemFlushBufferFlowRate}],
						Join[{endTime},percentTuple, {systemFlushBufferFlowRate}]
					}
				]
			]
		],
		allSystemFlushBufferResources
	];

	(*additionally, we need to make all of the resources needed for the system buffers*)
	{systemPrimeSampleCleaningBufferResources,systemFlushSampleCleaningBufferResources}=If[anyFlowInjectionQ,
		Transpose@MapThread[
			Function[{invContainerModel,maxVol, label},
				If[NullQ[invContainerModel],
					{Null, Null},
					Table[Resource[
						(*for the prime, we just want to use water to clear out the methanol*)
						Sample-> If[x==1,Model[Sample, "Milli-Q water"],Model[Sample, StockSolution, "20% Methanol in MilliQ Water"]],
						Amount -> Max[maxVol*0.3,50*Milliliter],
						Container -> invContainerModel,
						(*if it's a tube container, then we don't rent it*)
						RentContainer -> (maxVol > 99 Milliliter),
						(* need to do this to ensure that we don't accidentally make too many resources and thus have too many buffers *)
						Name -> If[x == 1,
							"system prime buffer for " <> ToString[label],
							"system flush buffer for " <> ToString[label]
						]
					],{x,1,2}]
				]
			],
			{sampleCapContainerModel,sampleCapContainerMaxVolume, sampleCapLabels}
		],
		{Null,Null}
	];

	(* Create placement field value for SystemPrime buffers (but only if using the avants) *)
	(* Only use the buffer positions that we need to prime *)
	systemPrimeBufferPlacements = If[avant150Q || avant25Q,
		Join[
			(* Place all  *)
			DeleteCases[
				Transpose[{
					allSystemPrimeBufferResources,
					Join[
						{"Buffer A" <> ToString[#] <> " Slot"}&/@Range[4],
						{"Buffer B" <> ToString[#] <> " Slot"}&/@Range[4]
					]
				}],
				{Null,_}
			],
			{
				(*if we are doing flow injection, we must place the cleaning solutions for the sample inlet lines*)
				If[anyFlowInjectionQ,
					Sequence@@MapIndexed[
						{Link[#1], {"Sample Slot "<>ToString[First[#2]]}}&,
						DeleteDuplicates[DeleteCases[systemPrimeSampleCleaningBufferResources, Null]]
					],
					Nothing
				]
			}
		],
		{}
	];

	(* Create placement field value for SystemFlush buffers *)
	systemFlushBufferPlacements = If[avant150Q || avant25Q,
		Join[
			(* Place all  *)
			DeleteCases[
				Transpose[{
					{
						(* B/D/F/H - B Buffers B1-B4 *)
						systemFlushBufferAResource,systemFlushBufferCResource, systemFlushBufferEResource, systemFlushBufferGResource,
						(* B/D/F/H - B Buffers B1-B4 *)
						systemFlushBufferBResource, systemFlushBufferDResource, systemFlushBufferFResource, systemFlushBufferHResource
					},
					Join[
						{"Buffer A" <> ToString[#] <> " Slot"}&/@Range[4],
						{"Buffer B" <> ToString[#] <> " Slot"}&/@Range[4]
					]
				}],
				{Null,_}
			],
			{
				(*if we are doing flow injection, we must place the cleaning solutions for the sample inlet lines*)
				If[anyFlowInjectionQ,
					Sequence@@MapIndexed[
						{Link[#1], {"Sample Slot "<>ToString[First[#2]]}}&,
						DeleteDuplicates[DeleteCases[systemFlushSampleCleaningBufferResources, Null]]
					],
					Nothing
				]
			}
		],
		{}
	];

	systemPrimeFlushGradientObjects=If[avant150Q || avant25Q,
		Table[CreateID[Object[Method, Gradient]], 2],
		{Null,Null}
	];
	systemPrimeFlushGradientPackets=If[avant150Q || avant25Q,
		MapThread[
			Function[
				{gradientObjectID,gradientTuple,flowRate,bufferAModel,bufferBModel,bufferResourceList},
				(* Make the gradient packet *)
				<|
					Object -> gradientObjectID,
					Type -> Object[Method, Gradient],
					BufferA -> If[NullQ[bufferResourceList[[1]]],Null,Link[bufferAModel]],
					BufferB -> If[NullQ[bufferResourceList[[2]]],Null,Link[bufferBModel]],
					BufferC -> If[NullQ[bufferResourceList[[3]]],Null,Link[bufferAModel]],
					BufferD -> If[NullQ[bufferResourceList[[4]]],Null,Link[bufferBModel]],
					BufferE -> If[NullQ[bufferResourceList[[5]]],Null,Link[bufferAModel]],
					BufferF -> If[NullQ[bufferResourceList[[6]]],Null,Link[bufferBModel]],
					BufferG -> If[NullQ[bufferResourceList[[7]]],Null,Link[bufferAModel]],
					BufferH -> If[NullQ[bufferResourceList[[8]]],Null,Link[bufferBModel]],
					Replace[Gradient] -> gradientTuple,
					GradientA -> gradientTuple[[All,{1,2}]],
					GradientB -> gradientTuple[[All,{1,3}]],
					GradientC -> gradientTuple[[All,{1,4}]],
					GradientD -> gradientTuple[[All,{1,5}]],
					GradientE -> gradientTuple[[All,{1,6}]],
					GradientF -> gradientTuple[[All,{1,7}]],
					GradientG -> gradientTuple[[All,{1,8}]],
					GradientH -> gradientTuple[[All,{1,9}]],
					FlowRate -> gradientTuple[[All,{1,-1}]],
					InitialFlowRate -> flowRate,
					(* No need for the shortcut options for system gradient methods *)
					FlushTime -> Null,
					EquilibrationTime -> Null,
					GradientStart -> Null,
					GradientEnd -> Null,
					GradientDuration -> Null,
					(* Temperature is always 25 Celsius (i.e., ambient) *)
					Temperature -> $AmbientTemperature
				|>
			],
			{
				systemPrimeFlushGradientObjects,
				{systemPrimeGradientTuples,systemFlushGradientTuples},
				{systemPrimeBufferFlowRate,systemFlushBufferFlowRate},
				(* BufferA, BufferB *)
				{systemPrimeBufferAModel,systemPrimeBufferBModel},
				{systemFlushBufferAModel,systemFlushBufferBModel},
				{allSystemPrimeBufferResources,allSystemFlushBufferResources}
			}
		],
		{}
	];

	(* create an instrument resource *)
	instrumentResource = Resource[Instrument -> resolvedInstrument, Time -> totalRunTime, Name -> ToString[Unique[]]];

	(*in order to fill in our fraction parameters we'll use the fraction packets, but replace the Null entries with Associations*)
	replacedFractionPackets=Map[
		If[NullQ[#],
			Association[],
			#
		]&,
		fractionPackets
	];

	(* hard code the amount that gets injected during calibration, and the pHs that we are doing *)
	pHCalibrationVolume = 10 Milliliter;
	lowpHTarget = 4.63;
	highpHTarget = 11.00;

	(* make resources for the pH detector calibrations *)
	lowpHBufferResource = Resource[
		Sample -> Model[Sample, "id:XnlV5jKN18jz"], (* Model[Sample, "Reference Buffer - pH 4.63"]*)
		Amount -> pHCalibrationVolume,
		Container -> Model[Container, Vessel, "id:xRO9n3vk11pw"] (* Model[Container, Vessel, "15mL Tube"]*)
	];
	highpHBufferResource = Resource[
		Sample -> Model[Sample, "id:3em6ZvLrY13V"], (* Model[Sample, "Reference Buffer - pH 11.00"] *)
		Amount -> pHCalibrationVolume,
		Container -> Model[Container, Vessel, "id:xRO9n3vk11pw"] (* Model[Container, Vessel, "15mL Tube"]*)
	];
	calibrationWashSolutionResource = Resource[
		Sample -> Model[Sample, "id:8qZ1VWNmdLBD"], (* Model[Sample, "Milli-Q water"] *)
		Amount -> pHCalibrationVolume,
		Container -> Model[Container, Vessel, "id:xRO9n3vk11pw"] (* Model[Container, Vessel, "15mL Tube"] *)
	];
	pHCalibrationStorageBufferResource = Resource[
		Sample -> Model[Sample, StockSolution, "1:1 solution of pH 4.01 Calibration buffer, Sachets and 1 M Potassium Nitrate"], (* Model[Sample, StockSolution, "1:1 solution of pH 4.01 Calibration buffer, Sachets and 1 M Potassium Nitrate"] id is Model[Sample, StockSolution, "id:3em6ZvmMNmnM"] in production *)
		Amount -> pHCalibrationVolume,
		Container -> Model[Container, Vessel, "id:xRO9n3vk11pw"] (* Model[Container, Vessel, "15mL Tube"] *)
	];

	(* use TransferDevices to select the syringe I want to use to inject the calibration buffers *)
	relevantSyringe = FirstOrDefault[FirstOrDefault[
		TransferDevices[Model[Container, Syringe], pHCalibrationVolume]
	]];

	(* make syringe resources for the pH detector calibrations *)
	lowpHBufferSyringe = Resource[Sample -> relevantSyringe];
	highpHBufferSyringe = Resource[Sample -> relevantSyringe];
	calibrationWashSolutionSyringe = Resource[Sample -> relevantSyringe];
	pHCalibrationStorageBufferSyringeResource = Resource[Sample -> relevantSyringe];

	(* make needle resources for the pH detector calibrations *)
	lowpHBufferNeedle = Resource[Sample -> Model[Item, Needle, "21g x 1 Inch Single-Use Needle"]];
	highpHBufferNeedle = Resource[Sample -> Model[Item, Needle, "21g x 1 Inch Single-Use Needle"]];
	calibrationWashSolutionNeedle = Resource[Sample -> Model[Item, Needle, "21g x 1 Inch Single-Use Needle"]];
	pHCalibrationStorageBufferSyringeNeedleResource = Resource[Sample -> Model[Item, Needle, "21g x 1 Inch Single-Use Needle"]];


	(* --- Generate the protocol packet --- *)
	protocolPacket = <|
		Type -> Object[Protocol, FPLC],
		Object -> CreateID[Object[Protocol, FPLC]],
		Replace[SamplesIn] -> (Link[#, Protocols]& /@ sampleResources),
		Replace[ContainersIn] -> (Link[Resource[Sample -> #], Protocols]& /@ uniqueContainers),
		UnresolvedOptions -> RemoveHiddenOptions[ExperimentFPLC,myUnresolvedOptions],
		(* doing this ReplaceRule because if this protocol is subsequently used as a template, having the Frequency options specified _and_ the InjectionTable ones specified will throw an error and cause it to fail *)
		(* since at this point we have a resolved InjectionTable anyway, these options don't do anything anyway and they are still in the UnresolvedOptions if we really need them *)
		ResolvedOptions -> ReplaceRule[RemoveHiddenOptions[ExperimentFPLC,myResolvedOptions], {StandardFrequency -> Null, BlankFrequency -> Null, ColumnRefreshFrequency -> Null}],
		Template -> If[MatchQ[Lookup[myResolvedOptions, Template], FieldReferenceP[]],
			Link[Most[Lookup[myResolvedOptions, Template]], ProtocolsTemplated],
			Link[Lookup[myResolvedOptions, Template], ProtocolsTemplated]
		],
		NumberOfReplicates -> numReplicates,
		Instrument -> Link[instrumentResource],
		Scale -> Lookup[myResolvedOptions, Scale],
		SeparationMode -> Lookup[myResolvedOptions, SeparationMode],
		Replace[Detectors] -> Lookup[resolvedInstrumentModelPacket, Detectors],
		Replace[Wavelengths] -> Lookup[myResolvedOptions, Wavelength],
		SeparationTime -> totalRunTime,
		Replace[InjectionTypes] -> Lookup[myResolvedOptions, InjectionType],
		Replace[SamplePumpWash] -> Lookup[myResolvedOptions, SamplePumpWash],
		SampleLoop -> sampleLoopResource,
		Mixer -> mixerResource,
		MixerDisconnectionSlot -> If[avant25Q || avant150Q,
			{Link[instrumentResource], "Mixer Slot"},
			Null
		],
		FlowCell -> flowCellResource,

		Replace[SampleCaps]->sampleCapResources,
		SystemPrimeBufferA -> systemPrimeBufferAResource,
		SystemPrimeBufferB -> systemPrimeBufferBResource,
		SystemPrimeBufferC -> systemPrimeBufferCResource,
		SystemPrimeBufferD -> systemPrimeBufferDResource,
		SystemPrimeBufferE -> systemPrimeBufferEResource,
		SystemPrimeBufferF -> systemPrimeBufferFResource,
		SystemPrimeBufferG -> systemPrimeBufferGResource,
		SystemPrimeBufferH -> systemPrimeBufferHResource,
		Replace[SystemPrimeCleaningBuffers]-> If[anyFlowInjectionQ, Link/@systemPrimeSampleCleaningBufferResources, ConstantArray[Null, Length[injectionTable]]],
		SystemPrimeGradient -> If[avant150Q || avant25Q, Link[systemPrimeFlushGradientObjects[[1]]]],
		
		Replace[SystemPrimeBufferContainerPlacements] -> systemPrimeBufferPlacements,
		TubingRinseSolution -> Link[
			Resource[
				Sample -> Model[Sample, "Milli-Q water"],
				Amount -> 500 Milli Liter,
				(* 1000 mL Glass Beaker *)
				Container -> Model[Container, Vessel, "id:O81aEB4kJJJo"],
				RentContainer -> True
			]
		],
		PlateSeal -> If[Length[uniquePlateContainers]>0, Link[
			Resource[
				Sample -> Model[Item, PlateSeal, "id:Vrbp1jKZJ0Rm"]
			]
		]],

		SystemFlushBufferA -> systemFlushBufferAResource,
		SystemFlushBufferB -> systemFlushBufferBResource,
		SystemFlushBufferC -> systemFlushBufferCResource,
		SystemFlushBufferD -> systemFlushBufferDResource,
		SystemFlushBufferE -> systemFlushBufferEResource,
		SystemFlushBufferF -> systemFlushBufferFResource,
		SystemFlushBufferG -> systemFlushBufferGResource,
		SystemFlushBufferH -> systemFlushBufferHResource,
		Replace[SystemFlushCleaningBuffers]-> If[anyFlowInjectionQ, Link/@systemFlushSampleCleaningBufferResources,ConstantArray[Null, Length[injectionTable]]],
		SystemFlushGradient -> If[avant150Q || avant25Q, Link[systemPrimeFlushGradientObjects[[2]]]],
		Replace[SystemFlushBufferContainerPlacements] -> systemFlushBufferPlacements,

		FlowInjectionPurgeCycle -> Lookup[myResolvedOptions, FlowInjectionPurgeCycle],
		Replace[FlowInjectionPurgeMethodFiles] -> flowInjectionPurgeMethodNames,
		Replace[SampleRecoupContainers] -> Link/@flowInjectionPurgeContainers,
		Replace[InjectionTable] -> injectionTableUploadable,
		NumberOfInjections -> Length[injectionTableUploadable],

		Replace[ColumnPrimeGradients] -> If[Length[columnPrimePositions] > 0, injectionTableWithLinks[[columnPrimePositions, 5]]],
		Replace[ColumnPrimeGradientA] -> columnPrimeGradientA,
		Replace[ColumnPrimeGradientB] -> columnPrimeGradientB,
		Replace[ColumnPrimeGradientC] -> columnPrimeGradientC,
		Replace[ColumnPrimeGradientD] -> columnPrimeGradientD,
		Replace[ColumnPrimeGradientE] -> columnPrimeGradientE,
		Replace[ColumnPrimeGradientF] -> columnPrimeGradientF,
		Replace[ColumnPrimeGradientG] -> columnPrimeGradientG,
		Replace[ColumnPrimeGradientH] -> columnPrimeGradientH,
		Replace[ColumnPrimeFlowDirections] -> columnPrimeFlowDirections,

		Replace[ColumnFlushGradients] -> If[Length[columnFlushPositions] > 0, injectionTableWithLinks[[columnFlushPositions, 5]]],
		Replace[ColumnFlushGradientA] -> columnFlushGradientA,
		Replace[ColumnFlushGradientB] -> columnFlushGradientB,
		Replace[ColumnFlushGradientC] -> columnFlushGradientC,
		Replace[ColumnFlushGradientD] -> columnFlushGradientD,
		Replace[ColumnFlushGradientE] -> columnFlushGradientE,
		Replace[ColumnFlushGradientF] -> columnFlushGradientF,
		Replace[ColumnFlushGradientG] -> columnFlushGradientG,
		Replace[ColumnFlushGradientH] -> columnFlushGradientH,
		Replace[ColumnFlushFlowDirections] -> columnFlushFlowDirections,

		FractionCollectionTemperature -> Lookup[myResolvedOptions, FractionCollectionTemperature] /. (Ambient -> 25 * Celsius),
		SampleTemperature -> Lookup[myResolvedOptions, SampleTemperature] /. (Ambient -> $AmbientTemperature),

		Replace[SampleVolumes] -> sampleTuples[[All, 4]],
		Replace[SampleFlowRate] -> sampleSampleFlowRate,
		Replace[GradientMethods] -> injectionTableWithLinks[[samplePositions, 5]],
		Replace[GradientA] -> sampleGradientA,
		Replace[GradientB] -> sampleGradientB,
		Replace[GradientC] -> sampleGradientC,
		Replace[GradientD] -> sampleGradientD,
		Replace[GradientE] -> sampleGradientE,
		Replace[GradientF] -> sampleGradientF,
		Replace[GradientG] -> sampleGradientG,
		Replace[GradientH] -> sampleGradientH,
		Replace[Columns] -> columnResources,
		Replace[ColumnFittings] -> columnAdapterResources,
		MaxColumnPressure -> Lookup[myResolvedOptions,MaxColumnPressure],
		ColumnDisconnectionSlot -> If[avant25Q || avant150Q,
			{Link[instrumentResource], "Column Slot"},
			Null
		],
		Replace[FlowRate] -> sampleFlowRates,
		Replace[FlowDirections] -> Lookup[myResolvedOptions, FlowDirection],
		BufferA -> bufferAResource,
		BufferB -> bufferBResource,
		BufferC -> bufferCResource,
		BufferD -> bufferDResource,
		BufferE -> bufferEResource,
		BufferF -> bufferFResource,
		BufferG -> bufferGResource,
		BufferH -> bufferHResource,
		Replace[BufferASelection] -> bufferASelectionResources,
		Replace[BufferBSelection] -> bufferBSelectionResources,
		Replace[BufferContainerPlacements] -> bufferPlacements,
		Replace[FractionCollectionModes] -> Lookup[replacedFractionPackets, FractionCollectionMode, Null],
		Replace[FractionCollectionStartTimes] -> Lookup[replacedFractionPackets, FractionCollectionStartTime, Null],
		Replace[FractionCollectionEndTimes] -> Lookup[replacedFractionPackets, FractionCollectionEndTime, Null],
		Replace[MaxFractionVolumes] -> Lookup[replacedFractionPackets, MaxFractionVolume, Null],
		Replace[MaxCollectionPeriods] -> Lookup[replacedFractionPackets, MaxCollectionPeriod, Null],
		Replace[AbsoluteThresholds] -> Lookup[replacedFractionPackets, AbsoluteThreshold, Null],
		Replace[PeakEndThresholds] -> Lookup[replacedFractionPackets, PeakEndThreshold, Null],
		Replace[PeakSlopes] -> Lookup[replacedFractionPackets, PeakSlope, Null],
		Replace[PeakSlopeEnds] -> Lookup[replacedFractionPackets, PeakSlopeEnd, Null],
		Replace[PeakMinimumDurations] -> Lookup[replacedFractionPackets, PeakMinimumDuration, Null],

		Replace[SamplesInStorage] -> Lookup[optionsWithReplicates, SamplesInStorageCondition],
		Replace[SamplesOutStorage] -> Lookup[optionsWithReplicates, SamplesOutStorageCondition],

		Replace[Standards] -> linkedStandardResources,
		Replace[StandardInjectionTypes] -> standardInjectionTypes,
		Replace[StandardSampleVolumes] -> If[Length[standardPositions] > 0, standardTuples[[All, 4]]],
		Replace[StandardGradientMethods] -> If[Length[standardPositions] > 0, injectionTableWithLinks[[standardPositions, 5]]],
		Replace[StandardGradientA] -> standardGradientA,
		Replace[StandardGradientB] -> standardGradientB,
		Replace[StandardGradientC] -> standardGradientC,
		Replace[StandardGradientD] -> standardGradientD,
		Replace[StandardGradientE] -> standardGradientE,
		Replace[StandardGradientF] -> standardGradientF,
		Replace[StandardGradientG] -> standardGradientG,
		Replace[StandardGradientH] -> standardGradientH,
		Replace[StandardsFlowDirections] -> Lookup[myResolvedOptions, StandardFlowDirection] /. {Null -> {}},
		Replace[StandardsStorageConditions] -> If[Length[standardPositions] > 0 && !NullQ[Lookup[myResolvedOptions, StandardStorageCondition]],
			ToList[Lookup[myResolvedOptions, StandardStorageCondition]][[standardPositionsCorresponded]]
		],

		Replace[Blanks] -> linkedBlankResources,
		Replace[BlankInjectionTypes] -> blankInjectionTypes,
		Replace[BlankSampleVolumes] -> If[Length[blankPositions] > 0, blankTuples[[All, 4]]],
		Replace[BlankGradientMethods] -> If[Length[blankPositions] > 0, injectionTableWithLinks[[blankPositions, 5]]],
		Replace[BlankGradientA] -> blankGradientA,
		Replace[BlankGradientB] -> blankGradientB,
		Replace[BlankGradientC] -> blankGradientC,
		Replace[BlankGradientD] -> blankGradientD,
		Replace[BlankGradientE] -> blankGradientE,
		Replace[BlankGradientF] -> blankGradientF,
		Replace[BlankGradientG] -> blankGradientG,
		Replace[BlankGradientH] -> blankGradientH,
		Replace[BlanksFlowDirections] -> Lookup[myResolvedOptions, BlankFlowDirection] /. {Null -> {}},
		Replace[BlanksStorageConditions] -> If[
			Length[blankPositions] > 0 && !NullQ[Lookup[myResolvedOptions, BlankStorageCondition]],
			ToList[Lookup[myResolvedOptions, BlankStorageCondition]][[blankPositionsCorresponded]]
		],
		
		(*PreInjectionEquilibrationTimes*)
		Replace[PreInjectionEquilibrationTimes]->Lookup[expandedResolvedOptions, PreInjectionEquilibrationTime],
		Replace[StandardPreInjectionEquilibrationTimes]->Lookup[expandedResolvedOptions, StandardPreInjectionEquilibrationTime],
		Replace[BlankPreInjectionEquilibrationTimes]->Lookup[expandedResolvedOptions, BlankPreInjectionEquilibrationTime],
		Replace[ColumnPrimePreInjectionEquilibrationTimes]->Lookup[expandedResolvedOptions, ColumnPrimePreInjectionEquilibrationTime],
		Replace[ColumnFlushPreInjectionEquilibrationTimes]->Lookup[expandedResolvedOptions, ColumnFlushPreInjectionEquilibrationTime],

		(* Sample loop disconnect *)
		Replace[SampleLoopDisconnects]->Lookup[expandedResolvedOptions, SampleLoopDisconnect],

		Replace[StandardSampleLoopDisconnects] -> If[Length[standardPositions] > 0 && !NullQ[Lookup[myResolvedOptions, StandardSampleLoopDisconnect]],
			ToList[Lookup[myResolvedOptions, StandardSampleLoopDisconnect]][[standardPositionsCorresponded]]
		],
		Replace[BlankSampleLoopDisconnects] -> If[Length[blankPositions] > 0 && !NullQ[Lookup[myResolvedOptions, BlankSampleLoopDisconnect]],
			ToList[Lookup[myResolvedOptions, BlankSampleLoopDisconnect]][[blankPositionsCorresponded]]
		],

		FractionCollection -> MemberQ[Lookup[expandedResolvedOptions, CollectFractions], True],
		FractionCollectionTemperature -> (Lookup[expandedResolvedOptions, FractionCollectionTemperature] /. Ambient -> $AmbientTemperature),
		Replace[FractionCollectionMethods] -> Link[Download[fractionPackets, Object]],
		Replace[ContainersOut] -> fractionContainerResources,
		Replace[FractionContainers] -> fractionContainerResources,
		Replace[FractionContainerRacks] -> fractionContainerRackResources,

		GradientPurge -> Lookup[expandedResolvedOptions, FullGradientChangePumpDisconnectAndPurge],
		PurgeVolume -> Lookup[expandedResolvedOptions, PumpDisconnectOnFullGradientChangePurgeVolume],
		AutosamplerWashSolution->autosamplerInjectionWashBufferResource,
		(* pH detector calibration; currently doing this for the 25s only; TODO once we get the luer lock valve for the 150 we can do that too *)
		If[avant25Q,
			<|
				CalibrationWashSolution -> Link[calibrationWashSolutionResource],
				LowpHCalibrationBuffer -> Link[lowpHBufferResource],
				HighpHCalibrationBuffer -> Link[highpHBufferResource],
				pHCalibrationStorageBuffer -> Link[pHCalibrationStorageBufferResource],

				CalibrationWashSolutionSyringe -> Link[calibrationWashSolutionSyringe],
				LowpHCalibrationBufferSyringe -> Link[lowpHBufferSyringe],
				HighpHCalibrationBufferSyringe -> Link[highpHBufferSyringe],
				pHCalibrationStorageBufferSyringe -> Link[pHCalibrationStorageBufferSyringeResource],

				CalibrationWashSolutionSyringeNeedle -> Link[calibrationWashSolutionNeedle],
				LowpHCalibrationBufferSyringeNeedle -> Link[lowpHBufferNeedle],
				HighpHCalibrationBufferSyringeNeedle -> Link[highpHBufferNeedle],
				pHCalibrationStorageBufferSyringeNeedle -> Link[pHCalibrationStorageBufferSyringeNeedleResource],

				LowpHCalibrationTarget -> lowpHTarget,
				HighpHCalibrationTarget -> highpHTarget
			|>,
			Nothing
		],
		(* TODO this is totally off but will be more sensible once we have the procedure *)
		Replace[Checkpoints] -> {
			{"Picking Resources", 1 Hour, "Buffers and columns required to run FPLC experiments are gathered.", Link[Resource[Operator -> $BaselineOperator, Time -> 1 Hour]]},
			{"Purging Instrument", 1.5 Hour, "System priming buffers are connected to an FPLC instrument and the instrument is purged at a high flow rate.", Link[Resource[Operator -> $BaselineOperator, Time -> 1.5 Hour]]},
			{"Priming Instrument", 2 Hour, "System priming buffers are connected to an FPLC instrument and the instrument is primed with each buffer at a high flow rate.", Link[Resource[Operator -> $BaselineOperator, Time -> 2Hour]]},
			{"Preparing Instrument", 1 Hour, "An instrument is configured for the protocol.", Link[Resource[Operator -> $BaselineOperator, Time -> 1 Hour]]},
			{"Running Samples", totalRunTime, "Samples are injected onto an FPLC and subject to buffer gradients.", Link[Resource[Operator -> $BaselineOperator, Time -> totalRunTime]]},
			{"Sample Post-Processing", 1 Hour, "Any measuring of volume, weight, or sample imaging post experiment is performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 1 Hour]]},
			{"Flushing Instrument", 2 Hour, " Buffers are connected to an FPLC instrument and the instrument is flushed with each buffer at a high flow rate.", Link[Resource[Operator -> $BaselineOperator, Time -> 2Hour]]},
			{"Exporting Data", 20 Minute, "Acquired chromatography data is exported.", Link[Resource[Operator -> $BaselineOperator, Time -> 20 Minute]]},
			{"Cleaning Up", 30 Minute, "System buffers are taken down, filters are cleaned, and any measuring of volume on the used system buffers is performed.", Link[Resource[Operator -> $BaselineOperator, Time -> 30 Minute]]},
			{"Returning Materials", 15 Minute, "Samples are returned to storage.", Link[Resource[Operator -> $BaselineOperator, Time -> 15 Minute]]}
		},
		Operator -> Link[Lookup[expandedResolvedOptions, Operator]],
		SubprotocolDescription -> Lookup[expandedResolvedOptions, SubprotocolDescription]
	|>;

	(* generate a packet with the shared fields *)
	sharedFieldPacket = populateSamplePrepFields[mySamples, myResolvedOptions, Cache -> cache, Simulation -> updatedSimulation];

	(* Merge the shared fields with the specific fields *)
	finalizedPacket = Join[protocolPacket, sharedFieldPacket];

	(* Return all generated packets *)
	allPackets = Flatten[{
		finalizedPacket,
		uniqueGradientPackets,
		systemPrimeFlushGradientPackets,
		newFractionPackets
	}];

	(* get all the resource symbolic representations *)
	(* need to pull these at infinite depth because otherwise all resources with Link wrapped around them won't be grabbed *)
	allResourceBlobs = DeleteDuplicates[Cases[Flatten[Values[finalizedPacket]], _Resource, Infinity]];

	(* call fulfillableResourceQ on all the resources we created *)
	{fulfillable, frqTests} = Which[
		MatchQ[$ECLApplication, Engine], {True, {}},
		gatherTests, Resources`Private`fulfillableResourceQ[allResourceBlobs, Output -> {Result, Tests}, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Cache -> cache,Simulation->updatedSimulation],
		True, {Resources`Private`fulfillableResourceQ[allResourceBlobs, FastTrack -> Lookup[myResolvedOptions, FastTrack],Site->Lookup[myResolvedOptions,Site], Messages -> messages, Cache -> cache, Simulation->updatedSimulation],Null}
	];

	(* generate the tests rule *)
	testsRule = Tests -> If[gatherTests,
		frqTests,
		Null
	];

	(* generate the Result output rule *)
	(* if not returning Result, or the resources are not fulfillable, Results rule is just $Failed *)
	resultRule = Result -> If[MemberQ[output, Result] && TrueQ[fulfillable],
		allPackets,
		{$Failed, $Failed}
	];

	(* return the output as we desire it *)
	outputSpecification /. {resultRule, testsRule}
];

(* ::Subsubsection:: *)
(*bestFPLCAliquotContainerModel*)

(* hard coded function for which containers to choose from when aliquoting/making resources for flow injection.  Importantly, this is not the same logic as PreferredContainer *)
(* make a function to figure out which container based on which injection volume *)
bestFPLCAliquotContainerModel[injectionVolume : VolumeP] := Switch[injectionVolume,
	GreaterP[2 Liter], Model[Container, Vessel, "Amber Glass Bottle 4 L"],
	GreaterP[1 Liter], Model[Container, Vessel, "2L Glass Bottle"],
	GreaterP[0.5 Liter], Model[Container, Vessel, "1L Glass Bottle"],
	GreaterP[0.25 Liter], Model[Container, Vessel, "500mL Glass Bottle"],
	GreaterP[0.05 Liter], Model[Container, Vessel, "250mL Glass Bottle"],
	_, Model[Container, Vessel, "50mL Tube"]
];

(* ::Subsubsection:: *)
(*Sister functions*)


DefineOptions[ExperimentFPLCOptions,
	Options :> {
		{
			OptionName -> OutputFormat,
			Default -> Table,
			AllowNull -> False,
			Widget -> Widget[Type -> Enumeration, Pattern :> (Table | List)],
			Description -> "Determines whether the function returns a table or a list of the options.",
			Category -> "General"
		}
	},
	SharedOptions :> {ExperimentFPLC}
];


ExperimentFPLCOptions[myInput : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[]] := Module[
	{listedOptions, noOutputOptions, options},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];

	(* remove the Output and OutputFormat option before passing to the core function because it doesn't make sense here *)
	noOutputOptions = DeleteCases[listedOptions, Alternatives[Output -> _, OutputFormat -> _]];

	(* get only the options for ExperimentFPLC *)
	options = ExperimentFPLC[myInput, Append[noOutputOptions, Output -> Options]];

	(* Return the option as a list or table *)
	If[MatchQ[Lookup[listedOptions, OutputFormat, Table], Table],
		LegacySLL`Private`optionsToTable[options, ExperimentFPLC],
		options
	]
];


ExperimentFPLCPreview[myInput : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ExperimentFPLC]] :=
	ExperimentFPLC[myInput, Append[ToList[myOptions], Output -> Preview]];


DefineOptions[ValidExperimentFPLCQ,
	Options :> {VerboseOption, OutputFormatOption},
	SharedOptions :> {ExperimentFPLC}
];


ValidExperimentFPLCQ[myInput : ListableP[ObjectP[{Object[Container], Object[Sample], Model[Sample]}] | _String], myOptions : OptionsPattern[ValidExperimentFPLCQ]] := Module[
	{listedOptions, listedInput, preparedOptions, filterTests, initialTestDescription, allTests, verbose, outputFormat},

	(* get the options as a list *)
	listedOptions = ToList[myOptions];
	listedInput = ToList[myInput];

	(* remove the Output option before passing to the core function because it doesn't make sense here *)
	preparedOptions = DeleteCases[listedOptions, (Output | Verbose | OutputFormat) -> _];

	(* return only the tests for ExperimentFPLC *)
	filterTests = ExperimentFPLC[myInput, Append[preparedOptions, Output -> Tests]];

	(* define the general test description *)
	initialTestDescription = "All provided options and inputs match their provided patterns (no further testing can proceed if this test fails):";

	(* make a list of all the tests, including the blanket test *)
	allTests = If[MatchQ[filterTests, $Failed],
		{Test[initialTestDescription, False, True]},
		Module[
			{initialTest, validObjectBooleans, voqWarnings},

			(* generate the initial test, which we know will pass if we got this far (?) *)
			initialTest = Test[initialTestDescription, True, True];

			(* create warnings for invalid objects *)
			validObjectBooleans = ValidObjectQ[DeleteCases[listedInput, _String], OutputFormat -> Boolean];
			voqWarnings = MapThread[
				Warning[StringJoin[ToString[#1, InputForm], " is valid (run ValidObjectQ for more detailed information):"],
					#2,
					True
				]&,
				{DeleteCases[listedInput, _String], validObjectBooleans}
			];

			(* get all the tests/warnings *)
			Flatten[{initialTest, filterTests, voqWarnings}]
		]
	];

	(* determine the Verbose and OutputFormat options; quiet the OptionValue::nodef message in case someone just passed nonsense *)
	(* like if I ran OptionDefault[OptionValue[ValidExperimentMassSpectrometryQ, {Horse -> Zebra, Verbose -> True, OutputFormat -> Boolean}, {Verbose, OutputFormat}]], it would throw a message for the Horse -> Zebra option not existing, even if I am not actually pulling that one out *)
	{verbose, outputFormat} = Quiet[OptionDefault[OptionValue[{Verbose, OutputFormat}]], OptionValue::nodef];

	(* run all the tests as requested *)
	Lookup[RunUnitTest[<|"ValidExperimentFPLCQ" -> allTests|>, OutputFormat -> outputFormat, Verbose -> verbose], "ValidExperimentFPLCQ"]
];

(* ::Subsubsection::Closed:: *)
(*fplcGradientSearch*)

(* Function to search the database for all FPLC System Prime/Flush Gradients. *)
fplcSystemGradientSearch[fakeString:_String] := fplcSystemGradientSearch[fakeString] = Module[{},
	(*Add allCentrifugeEquipmentSearch to list of Memoized functions*)
	AppendTo[$Memoization,Experiment`Private`fplcSystemGradientSearch];
	Search[Object[Method, Gradient], Name == (___~~"System"~~___~~"AKTA Avant"~~___) && Notebook == Null]
];

defaultGradientFPLC[myDefaultFlowRate : FlowRateP] := {
	{Quantity[0., Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent],Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[5., Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent],Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[30., Minute], Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent],Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[30.1, Minute], Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent],Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[35., Minute], Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent],Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[35.1, Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent],Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[40., Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate}
};

(* Below is the default for SizeExclusion *)
defaultPrimeGradientFPLC[myDefaultFlowRate : FlowRateP, finalComposition: {GreaterEqualP[0 Percent],GreaterEqualP[0 Percent],GreaterEqualP[0 Percent],GreaterEqualP[0 Percent],GreaterEqualP[0 Percent],GreaterEqualP[0 Percent],GreaterEqualP[0 Percent],GreaterEqualP[0 Percent]}] := {
	{Quantity[0., Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[5., Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[5.1, Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[10., Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[10.1, Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[15., Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[15.1, Minute], Sequence@@finalComposition, myDefaultFlowRate},
	{Quantity[20., Minute], Sequence@@finalComposition, myDefaultFlowRate}
};

defaultPrimeGradientFPLC[myDefaultFlowRate : FlowRateP] := defaultPrimeGradientFPLC[myDefaultFlowRate, {
	Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent]
}];

(* Below is the default for SizeExclusion *)
defaultFlushGradientFPLC[myDefaultFlowRate : FlowRateP, finalComposition: {GreaterEqualP[0 Percent],GreaterEqualP[0 Percent],GreaterEqualP[0 Percent],GreaterEqualP[0 Percent],GreaterEqualP[0 Percent],GreaterEqualP[0 Percent],GreaterEqualP[0 Percent],GreaterEqualP[0 Percent]}] := {
	{Quantity[0., Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[5., Minute], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[5.1, Minute], Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[10., Minute], Quantity[0., Percent], Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], myDefaultFlowRate},
	{Quantity[10.1, Minute], Sequence@@finalComposition, myDefaultFlowRate},
	{Quantity[15., Minute], Sequence@@finalComposition, myDefaultFlowRate}
};

defaultFlushGradientFPLC[myDefaultFlowRate : FlowRateP] := defaultFlushGradientFPLC[myDefaultFlowRate, {
	Quantity[100., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent], Quantity[0., Percent]
}];



(* ::Section:: *)
(*End Private*)
